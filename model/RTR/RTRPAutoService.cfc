component
	accessors="true"
	extends="model.RTR.RTRBaseService"
	output="false"
{
	property name="autoDriverFactorService" inject="model";
	property name="policyCoverageService" inject="model";
	property name="autoRateDetailService" inject="model";
	property name="autoTerritoryService" inject="model";
	property name="autoViolationChargeService" inject="model";

	public model.RTR.RTRPAutoService function init()
		output="false"
	{
		super.init(argumentCollection=arguments);

		return this;
	}

	private struct function generateResult()
		output="false"
	{
		var result = super.generateResult();
		var line = getLine();

		structAppend(result, {
			"drivers" = [],
			"vehicles" = []
		});

		// drivers
		for (var i=1;i<=arrayLen(line.getDrivers());i++) {
			var driver = line.getDrivers()[i];
			arrayAppend(result["drivers"], {
				"driverID" = driver.getDriverID(),
				"driverType" = driver.getDriverType(),
				"fname" = driver.getFName(),
				"middle" = driver.getMiddle(),
				"lname" = driver.getLName(),
				"dob" = driver.getDOB(),
				"age" = driver.getDriverAge(),
				"gender" = driver.getGender(),
				"maritalStatus" = driver.getMaritalStatus(),
				"relationToApplicant" = driver.getRelationToApplicant(),
				"licState" = driver.getLicState(),
				"licNum" = driver.getLicNum(),
				"dateLicensed" = driver.getDateLicensed()
			});
		}

		getEntityService().refresh(line.getVehicles());

		// vehicles
		for (var j=1;j<=arrayLen(line.getVehicles());j++) {
			var vehicle = line.getVehicles()[j];
			arrayAppend(result["vehicles"], {
				"vehicleID" = vehicle.getVehicleID(),
				"vin" = vehicle.getVIN(),
				"vehicleYear" = vehicle.getVehicleYear(),
				"make" = vehicle.getMake(),
				"model" = vehicle.getModel(),
				"usage" = vehicle.getUsage(),
				"garageCity" = vehicle.getGarageCity(),
				"garageState" = !isNull(vehicle.getGarageState())?vehicle.getGarageState():"",
				"garageZip" = vehicle.getGarageZip(),
				"coverages" = []
			});

			// coverages
			for (var k=1;k<=arrayLen(vehicle.getCoverages());k++) {
				var coverage = vehicle.getCoverages()[k];
				arrayAppend(result["vehicles"][arrayLen(result["vehicles"])]["coverages"], {
					"coverage" = coverage.getCoverage(),
					"limit1" = coverage.getLimit1(),
					"limit2" = coverage.getLimit2(),
					"limit3" = coverage.getLimit3(),
					"deductible" = coverage.getDeductible()
				});
			}
		}


		return result;
	}

	private string function getRandomVIN(required numeric year, required string make, required string model, required string bodyType)
		output="false"
	{
		try {
			var qVINS = queryNew("vin,symbolGroup,comprehensiveSymbol,collisionSymbol,symbolTotal");
			var vin = createObject("com", "Vin.VinLookup");

			vin.year = arguments.year;
			vin.make = arguments.make;
			vin.model = arguments.model;

			for (var e in application.constants.vehicle.bodyTypes) {
				if (getUtils().smartArrayFindNoCase(e, arguments.bodyType)) {
					arguments.bodyType = e[1];
					break;
				}
			}

			for (var i=1; i<=vin.modelCount; i++) {
				vin.modelNumber = i;

				if (len(trim(vin.model)) == len(trim(arguments.model)) &&
					trim(vin.model) == trim(arguments.model) &&
					trim(vin.bodyStyle) == trim(arguments.bodyType))
				{
					queryAddRow(qVINS);
					querySetCell(qVINS, "vin", vin.vin);
					querySetCell(qVINS, "symbolGroup", vin.isosymbol);
					querySetCell(qVINS, "comprehensiveSymbol", vin.year>2010?vin.CompSym2011:vin.isosymbol);
					querySetCell(qVINS, "collisionSymbol", vin.year>2010?vin.CollSym2011:vin.isosymbol);
					querySetCell(qVINS, "symbolTotal", vin.isosymbol+(vin.year>2010?vin.CompSym2011:vin.isosymbol)+(vin.year>2010?vin.CollSym2011:vin.isosymbol));
				}
			}

			var qs = new Query();
			qs.setAttributes(dbtype = "query", QoQSrcTable = qVINS);
			qVINS = qs.execute(sql = "SELECT * FROM QoQSrcTable ORDER BY symbolTotal").getResult();

			return qVINS.recordCount?qVINS.vin[1]:"n/a";
		} catch (any error) {
			return "n/a";
		}
	}

	private void function load()
		output="false"
	{
		super.load();

		//loadVinDetail();

		setDOBValue();
		setObjectIDValue();
		setPolicyCoveragesIDValue();
		setRelationToApplicantValue();
		setDateLicensedValue();
		setPolicyZipValue();
		setTerritoryValue();
		setDriverClassValue();
		setDriverIDValue();
		setSdipDescriptionValue();

		checkMultiCarDiscount();
		checkBusinessSurcharge();
		checkCommercialSurcharge();
		checkSchoolSurcharge();
	}

	private void function checkBusinessSurcharge()
		output="false"
	{
		var surchargeType = getEntityService().findWhere("SurchargeType", {"type" = "business"});

		if (!structKeyExists(local, "surchargeType")) {
			return;
		}

		var line = getLine();
		for(var i=1;i<=arrayLen(line.getVehicles());i++) {
			var vehicle = line.getVehicles()[i];
			var hasSurcharge = vehicle.hasSurchargeType(surchargeType);

			if (arrayFindNoCase(["A", "B"], vehicle.getUsage()) && !hasSurcharge) {
				vehicle.addSurcharge(getEntityService().new("VehicleSurcharge", {
					"surchargeTypeID" = surchargeType.getSurchargeTypeID(),
					"surchargeMask" = surchargeType.getSurchargeMask(),
					"description" = surchargeType.getDescription(),
					"type" = surchargeType.getType(),
					"policy" = line.getPolicy(),
					"parent" = vehicle
				}));
			} else if (!arrayFindNoCase(["A", "B"], vehicle.getUsage()) && hasSurcharge) {
				vehicle.removeSurcharge(surchargeType);
			}
		}
	}

	private void function checkCommercialSurcharge()
		output="false"
	{
		var surchargeType = getEntityService().findWhere("SurchargeType", {"type" = "commercial"});

		if (!structKeyExists(local, "surchargeType")) {
			return;
		}

		var line = getLine();
		for(var i=1;i<=arrayLen(line.getVehicles());i++) {
			var vehicle = line.getVehicles()[i];
			var hasSurcharge = vehicle.hasSurchargeType(surchargeType);

			if (arrayFindNoCase(["C"], vehicle.getUsage()) && !hasSurcharge) {
				vehicle.addSurcharge(getEntityService().new("VehicleSurcharge", {
					"surchargeTypeID" = surchargeType.getSurchargeTypeID(),
					"surchargeMask" = surchargeType.getSurchargeMask(),
					"description" = surchargeType.getDescription(),
					"type" = surchargeType.getType(),
					"policy" = line.getPolicy(),
					"parent" = vehicle
				}));
			} else if (!arrayFindNoCase(["C"], vehicle.getUsage()) && hasSurcharge) {
				vehicle.removeSurcharge(surchargeType);
			}
		}
	}

	private void function checkMultiCarDiscount()
		output="false"
	{
		var discountType = getEntityService().findWhere("DiscountType", {"type" = "MC"});

		if (!structKeyExists(local, "discountType")) {
			return;
		}

		var hasDiscount = getLine().getPolicy().hasDiscountType(discountType);

		if (arrayLen(getLine().getVehicles()) > 1 && !hasDiscount) {
			getLine().getPolicy().addDiscount(getEntityService().new("PolicyDiscount", {
				"discountTypeID" = discountType.getDiscountTypeID(),
				"discountMask" = discountType.getDiscountMask(),
				"description" = discountType.getDescription(),
				"type" = discountType.getType(),
				"policy" = getLine().getPolicy(),
				"parent" = getLine().getPolicy()
			}));
		} else if (arrayLen(getLine().getVehicles()) <= 1 && hasDiscount) {
			getLine().getPolicy().removeDiscount(discountType);
		}
	}

	private void function checkSchoolSurcharge()
		output="false"
	{
		var surchargeType = getEntityService().findWhere("SurchargeType", {"type" = "school"});

		if (!structKeyExists(local, "surchargeType")) {
			return;
		}

		var line = getLine();
		for(var i=1;i<=arrayLen(line.getVehicles());i++) {
			var vehicle = line.getVehicles()[i];
			var hasSurcharge = vehicle.hasSurchargeType(surchargeType);

			if (arrayFindNoCase(["S"], vehicle.getUsage()) && !hasSurcharge) {
				vehicle.addSurcharge(getEntityService().new("VehicleSurcharge", {
					"surchargeTypeID" = surchargeType.getSurchargeTypeID(),
					"surchargeMask" = surchargeType.getSurchargeMask(),
					"description" = surchargeType.getDescription(),
					"type" = surchargeType.getType(),
					"policy" = line.getPolicy(),
					"parent" = vehicle
				}));
			} else if (!arrayFindNoCase(["S"], vehicle.getUsage()) && hasSurcharge) {
				vehicle.removeSurcharge(surchargeType);
			}
		}
	}

	private void function loadLine()
		output="false"
	{
		var policyData = structFind(getData(), "policy");

		if (structKeyExists(policyData.attributes, "id")) {
			setLine(getEntityService().findWhere("Auto", {policy=getEntityService().get("Policy", policyData.attributes.id)}));
		} else {
			setLine(getEntityService().new("Auto"));
		}

		for (var e in policyData) {
			if (isStruct(policyData[e]) &&
				structKeyExists(policyData[e], "text") &&
				isSimpleValue(policyData[e]["text"]))
			{
				try {
					evaluate("getLine().set#e#(trim(policyData[e]['text']))");
				} catch (any error) { }
			}
		}
	}

	private void function loadVinDetail()
		output="false"
	{
		try {
			var vin = createObject("com", "Vin.VinLookup");

			var line = getLine();
			for(var i=1;i<=arrayLen(line.getVehicles());i++) {
				var vehicle = line.getVehicles()[i];

				if (vehicle.getVIN() == "undefined" || len(trim(vehicle.getVIN())) == 0) {
					vehicle.setVIN(getRandomVIN(vehicle.getVehicleYear(), vehicle.getMake(), vehicle.getModel(), vehicle.getBodyType()));

					if (vehicle.getVIN() == "n/a") {
						continue;
					}
				}

				vin.vin = vehicle.getVIN();

				// bodyType
				for (var bodyType in application.constants.vehicle.bodyTypes) {
					if (getUtils().smartArrayFindNoCase(bodyType, vin.bodyStyle)) {
						vehicle.setBodyType(bodyType[2]);
						break;
					}
				}

				// symbolGroup
				if (vin.year > 2010) {
					vehicle.setSymbolGroup(vin.CompSym2011);
					vehicle.setRatingSymbol(vin.CompSym2011);
				} else {
					vehicle.setSymbolGroup(vin.isosymbol);
					vehicle.setRatingSymbol(vin.isosymbol);
				}

				// airbag
				switch (vin.restraint) {
					case "A":
					case "P":
					case "M":
					case "N":
						vehicle.setAirbag(0);
						break;
					default:
						vehicle.setAirbag(1);
						break;
				}

				// antiLockBrakes
				switch (vin.brake_indicator) {
					case "S":
					case "R":
					case "J":
						vehicle.setAntiLockBrakes(1);
						break;
					default:
						vehicle.setAntiLockBrakes(0);
						break;
				}

				// is4X4
				switch (vin.fourbyfour) {
					case 4:
						vehicle.setIs4X4(1);
						break;
					default:
						vehicle.setIs4X4(0);
						break;
				}

				// antiTheft
				if (len(trim(vin.antitheft))) {
					vehicle.setAntiTheft(1);
				} else {
					vehicle.setAntiTheft(0);
				}

				// biSymbol
				if (isNumeric(vin.liabSymbol)) {
					vehicle.setBISymbol(vin.liabSymbol);
				} else {
					vehicle.setBISymbol(0);
				}

				// pdSymbol
				if (isNumeric(vin.liabSymbol)) {
					vehicle.setPDSymbol(vin.liabSymbol);
				} else {
					vehicle.setPDSymbol(0);
				}

				// pipSymbol
				if (isNumeric(vin.pipSymbol)) {
					vehicle.setPIPSymbol(vin.pipSymbol);
				} else {
					vehicle.setPIPSymbol(0);
				}

				// mpSymbol
				if (isNumeric(vin.pipSymbol)) {
					vehicle.setMPSymbol(vin.pipSymbol);
				} else {
					vehicle.setMPSymbol(0);
				}

				// classCode
				if (isNumeric(vin.classCode)) {
					vehicle.setClassCode(vin.classCode);
				} else {
					vehicle.setClassCode(0);
				}
			}
		} catch (any error) { }
	}

	private void function save()
		output="false"
	{
		super.save();

		transaction {
			try {
				var qs = new Query();

				qs.clearParams();
				qs.addParam(name="autoID", value=getLine().getAutoID(), cfsqltype="cf_sql_integer");
				qs.addParam(name="policyID", value=getLine().getPolicy().getPolicyID(), cfsqltype="cf_sql_integer");
				qs.setSQL(getUtils().cleanSQL("
					UPDATE Vehicle SET
						lienholderID1 = ISNULL(lienholderID1, 1),
						lienholderID2 = ISNULL(lienholderID2, 1)
					WHERE policyID = :policyID

					UPDATE Policy SET
						needsRated = 0
					WHERE policyID = :policyID
				"));
				qs.execute();
			} catch (any e) {
				transactionRollback();
				throw(object=e);
			}
		}
	}

	private void function setDateLicensedValue()
		output="false"
	{
		var line = getLine();
		for(var i=1;i<=arrayLen(line.getDrivers());i++) {
			var driver = line.getDrivers()[i];
			if (isDate(driver.getDateLicensed()) || !isDate(driver.getDOB())) {
				continue;
			}

			driver.setDateLicensed(getDateUtils().formatDate(dateAdd("yyyy", 16, driver.getDOB())));
		}
	}

	private void function setDOBValue()
		output="false"
	{
		var line = getLine();
		for(var i=1;i<=arrayLen(line.getDrivers());i++) {
			var driver = line.getDrivers()[i];
			if (isDate(driver.getDOB()) || isNull(driver.getAge()) || driver.getAge() <= 0) {
				continue;
			}

			driver.setDOB(getDateUtils().formatDate(dateAdd("yyyy", -driver.getAge(), line.getPolicy().getEffectiveDate())));
		}
	}

	private void function setDriverClassValue()
		output="false"
	{
		var line = getLine();
		for(var i=1;i<=arrayLen(line.getDrivers());i++) {
			var driver = line.getDrivers()[i];

			var autoDriverFactor = getAutoDriverFactorService().findAllWhere({
				"ratingGroupID" = line.getPolicy().getRatingGroupID(),
				"ratingVersionID" = line.getPolicy().getRatingVersionID(),
				"gender" = driver.getGender(),
				"maritalStatus" = driver.getMaritalStatusShort(),
				"age" = driver.getDriverAge(line.getPolicy().getEffectiveDate())
			});

			if (arrayLen(autoDriverFactor) == 0) {
				continue;
			}

			driver.setDriverClass(autoDriverFactor[1].getCode());
		}
	}

	private void function setDriverIDValue()
		output="false"
	{
		var line = getLine();
		for(var i=1;i<=arrayLen(line.getDrivers());i++) {
			var driver = line.getDrivers()[i];

			if (isNull(driver.getDriverAccidents())) {
				continue;
			}

			for (var k=arrayLen(driver.getDriverAccidents());k>=1;k--) {
				var driverAccident = driver.getDriverAccidents()[k];
				driverAccident.setDriver(driver);
			}
		}
	}

	private void function setObjectIDValue()
		output="false"
	{
		var line = getLine();
		for(var i=1;i<=arrayLen(line.getVehicles());i++) {
			var vehicle = line.getVehicles()[i];
			for(var k=1;k<=arrayLen(vehicle.getCoverages());k++) {
				var coverage = vehicle.getCoverages()[k];
				coverage.setVehicle(vehicle);
			}
		}
	}

	private void function setPolicyCoveragesIDValue()
		output="false"
	{
		var line = getLine();
		for(var i=1;i<=arrayLen(line.getVehicles());i++) {
			var vehicle = line.getVehicles()[i];
			for(var k=arrayLen(vehicle.getCoverages());k>=1;k--) {
				var coverage = vehicle.getCoverages()[k];
				var policyCoverage = getPolicyCoverageService().findWhere({
					"coverage" = coverage.getCoverage(),
					"policyType" = line.getPolicy().getPolicyType()
				});

				if (!structKeyExists(local, "policyCoverage")) {
					continue;
				}

				coverage.setPolicyCoverageID(policyCoverage.getPolicyCoverageID());
			}
		}
	}

	private void function setPolicyZipValue()
		output="false"
	{
		var line = getLine();

		if (isNull(line.getPolicyZip()) || !isValid("zipcode", line.getPolicyZip())) {
			line.setPolicyZip(line.getPolicy().getInsured().getZip());
		}

		if (line.getPolicy().getRatingVersionID() <= 1) {
			return;
		}

		var autoTerritory = getAutoTerritoryService().findAllWhere({
			"ratingVersionID" = line.getPolicy().getRatingVersionID(),
			"zipCode" = line.getPolicyZip()
		});

		if (arrayLen(autoTerritory) == 0) {
			return;
		}

		line.setPolicyZipID(autoTerritory[1].getAutoTerritoryID());
	}

	private void function setRelationToApplicantValue()
		output="false"
	{
		var line = getLine();
		for(var i=2;i<=arrayLen(line.getDrivers());i++) {
			var driver = line.getDrivers()[i];

			if (getLine().getPolicy().getInsured().getFName2() == driver.getFName() &&
				getLine().getPolicy().getInsured().getLName2() == driver.getLName() &&
				driver.getMaritalStatus() == application.constants.driver.maritalStatus.married)
			{
				driver.setRelationToApplicant("SPOUSE");
			} else {
				driver.setRelationToApplicant("OTHER");
			}
		}
	}

	private void function setSdipDescriptionValue()
		output="false"
	{
		var line = getLine();
		for(var i=1;i<=arrayLen(line.getDrivers());i++) {
			var driver = line.getDrivers()[i];

			if (isNull(driver.getDriverAccidents())) {
				continue;
			}

			for (var k=arrayLen(driver.getDriverAccidents());k>=1;k--) {
				var driverAccident = driver.getDriverAccidents()[k];

				var autoViolationCharge = getAutoViolationChargeService().findWhere({
					"ratingGroup" = getRatingGroupService().get(line.getPolicy().getRatingGroupID()),
					"ratingVersion" = getRatingVersionService().get(line.getPolicy().getRatingVersionID()),
					"autoViolationID" = driverAccident.getSdipID()
				});

				if (!structKeyExists(local, "autoViolationCharge")) {
					continue;
				}

				driverAccident.setSdipDescription(autoViolationCharge.getViolation());
				driverAccident.setAgingType(autoViolationCharge.getAgingType());

				var violationMonths = dateDiff("m", getDateUtils().formatDate(driverAccident.getAccidentDate()), getDateUtils().formatDate(line.getPolicy().getEffectiveDate()));
				if (violationMonths < 12) {
					driverAccident.setAgingValue(1);
				} else if (violationMonths < 24) {
					driverAccident.setAgingValue(2);
				} else if (violationMonths <= 36) {
					driverAccident.setAgingValue(3);
				}
			}
		}
	}

	private void function setTerritoryValue()
		output="false"
	{
		var line = getLine();

		if (line.getPolicy().getRatingGroupID() <= 0 || line.getPolicy().getRatingVersionID() <= 0) {
			return;
		}

		for(var i=1;i<=arrayLen(line.getVehicles());i++) {
			var vehicle = line.getVehicles()[i];
			var autoTerritory = getAutoTerritoryService().findAllWhere({
				"ratingGroupID" = line.getPolicy().getRatingGroupID(),
				"ratingVersionID" = line.getPolicy().getRatingVersionID(),
				"zipCode" = vehicle.getGarageZip()
			});

			if (arrayLen(autoTerritory) == 0) {
				continue;
			}

			vehicle.setTerritory(autoTerritory[1].getTerritory());
			vehicle.setVehicleZipID(autoTerritory[1].getAutoTerritoryID());
		}
	}
}