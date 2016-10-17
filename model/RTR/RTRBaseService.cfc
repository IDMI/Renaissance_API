component
	accessors="true"
	output="false"
{
	property struct data;
	property string action;
	property string id;
	property any line;
	property payments;
	property paymentInfos;
	property IVRPayments;
	property name="companyService" inject="model";
	property name="companyFinancialService" inject="model";
	property name="dateUtils" inject="model";
	property name="entityService" inject="EntityService";
	property name="IVRService" inject;
	property name="notAssignedUser" inject;
	property name="paymentPlanService" inject="model";
	property name="policyRatingService" inject;
	property name="producerPolicyTypeService" inject="model";
	property name="ratingGroupService" inject="model";
	property name="ratingVersionService" inject="model";
	property name="RTRValidatorService" inject="model";
	property name="stateService" inject="model";
	property name="systemUser" inject;
	property name="underwritingService" inject="model";
	property name="utils" inject="model";
	property name="validator" inject="model";

	public model.RTR.RTRBaseService function init(struct data={})
		output="false"
	{
		setPayments([]);
		setPaymentInfos([]);
		setIVRPayments([]);
		setData(arguments.data);

		return this;
	}

	public any function execute()
		output="false"
	{
		if (!structIsEmpty(arguments)) {
			init(argumentCollection=arguments);
		}

		validate();
		save();

		setUnderwritingCollectionValue();

		return generateResult();
	}

	public void function setData(required struct data)
		output="false"
	{
		variables.data = arguments.data;

		if (!structIsEmpty(variables.data)) {
			load();
		}
	}

	private void function createPolicySuspense(required string title, required string body, date expires = now(), struct options = {})
		output="false"
	{
		var policy = getLine().getPolicy();

		var params = {
			policy = policy,
			insured = policy.getInsured(),
			issued = now(),
			company = policy.getCompany(),
			Producer = policy.getProducer(),
			userIDto = policy.getProducer().getUnderwriter(),
			userIDFrom = getSystemUser(),
			completedUser = getNotAssignedUser(),
			supervisorUser = getNotAssignedUser()
		};

		structAppend(params, arguments.options, true);

		var suspense = getEntityService().new("Suspense", params);
		suspense.setTitle(arguments.title);
		suspense.setBody(arguments.body);
		suspense.setExpires(arguments.expires);

		getEntityService().save(suspense);
	}

	private struct function generateResult()
		output="false"
	{
		var result = {};
		var i = 0;

		structAppend(result, {
			"id" = getID(),
			"policy" = {
				"policyID" = getLine().getPolicy().getPolicyID(),
				"companyID" = getLine().getPolicy().getCompany().getCompanyID(),
				"stateID" = getLine().getPolicy().getState().getStateID(),
				"policyType" = getLine().getPolicy().getPolicyType(),
				"ratingGroupID" = getLine().getPolicy().getRatingGroupID(),
				"ratingVersionID" = getLine().getPolicy().getRatingVersionID(),
				"policyNum" = getLine().getPolicy().getPolicyNum(),
				"effectiveDate" = getLine().getPolicy().getEffectiveDate(),
				"expirationDate" = getLine().getPolicy().getExpirationDate(),
				"policyTerm" = getLine().getPolicy().getPolicyTerm(),
				"premium" = getLine().getPolicy().getPremiumTotal(),
				"discounts" = getLine().getPolicy().getDiscountCollection(),
				"surcharges" = getLine().getPolicy().getSurchargeCollection(),
				"underwriting" = getLine().getPolicy().getUnderwritingCollection(),
				"paymentPlanID" = !isNull(getLine().getPolicy().getPaymentPlan())?getLine().getPolicy().getPaymentPlan().getPaymentPlanID():1,
				"depositAmount" = getLine().getDepositAmount(),
				"policyCharge" = getLine().getPolicy().getPolicyCharge(),
				"fees" = {
					"policyCharge" = getLine().getPolicy().getPolicyCharge(),
					"sr22Fee" = getLine().getSR22FeeTotal()
				},
				"installmentAmount" = getLine().getInstallmentAmount(),
				"installmentCount" = getLine().getPolicy().getInstallmentCount(),
				"amountDue" = getLine().getPolicy().getAmountDue(),
				"amountPaid" = getLine().getPolicy().getTotalPayments(),
				"balance" = getLine().getPolicy().getBalance()
			},
			"insured" = {
				"insuredID" = getLine().getPolicy().getInsured().getInsuredID(),
				"fname1" = getLine().getPolicy().getInsured().getFName1(),
				"middle1" = getLine().getPolicy().getInsured().getMiddle1(),
				"lname1" = getLine().getPolicy().getInsured().getLName1(),
				"fname2" = !isNull(getLine().getPolicy().getInsured().getFName2())?getLine().getPolicy().getInsured().getFName2():"",
				"middle2" = !isNull(getLine().getPolicy().getInsured().getMiddle2())?getLine().getPolicy().getInsured().getMiddle2():"",
				"lname2" = !isNull(getLine().getPolicy().getInsured().getLName2())?getLine().getPolicy().getInsured().getLName2():"",
				"address1" = getLine().getPolicy().getInsured().getAddress1(),
				"address2" = !isNull(getLine().getPolicy().getInsured().getAddress2())?getLine().getPolicy().getInsured().getAddress2():"",
				"city" = getLine().getPolicy().getInsured().getCity(),
				"state" = getLine().getPolicy().getInsured().getState(),
				"zip" = getLine().getPolicy().getInsured().getZip()
			},
			"payments" = []
		});

		// Payments
		if (!isNull(getLine().getPolicy().getPayments())) {
			for (i=1;i<=arrayLen(getLine().getPolicy().getPayments());i++) {
				arrayAppend(result["payments"], {
					"paymentID" = getLine().getPolicy().getPayments()[i].getPaymentID(),
					"paymentDate" = getDateUtils().formatDateTime(getLine().getPolicy().getPayments()[i].getPaymentDate()),
					"postMarkedDate" = getDateUtils().formatDate(getLine().getPolicy().getPayments()[i].getPostMarkedDate()),
					"amount" = getLine().getPolicy().getPayments()[i].getAmount(),
					"method" = getLine().getPolicy().getPayments()[i].getMethodAsText()
				});
			}
		}

		return result;
	}

	private model.IVRPayment.IVRPayment function getIVRPayment(required numeric index)
		output="false"
	{
		return getIVRPayments()[arguments.index];
	}

	private numeric function getIVRPaymentCount()
		output="false"
	{
		return arrayLen(getIVRPayments());
	}

	private model.payment.Payment function getPayment(required numeric index)
		output="false"
	{
		return getPayments()[arguments.index];
	}

	private numeric function getPaymentCount()
		output="false"
	{
		return arrayLen(getPayments());
	}

	private model.paymentInfo.PaymentInfo function getPaymentInfo(required numeric index)
		output="false"
	{
		return getPaymentInfos()[arguments.index];
	}

	private numeric function getPaymentInfoCount()
		output="false"
	{
		return arrayLen(getPaymentInfos());
	}

	private void function load()
		output="false"
	{
		loadAction();
		loadID();
		loadLine();
		loadPolicy();
		loadInsured();
		loadVehicles();
		loadDrivers();
		loadAppQuestionResponses();
		loadPayments();
		loadPaymentInfos();

		setExpirationDateValue();
		setCompanyValue();
		setStateValue();
		setRatingGroupIDValue();
		setRatingVersionIDValue();
		setPaymentPlanValue();
		setPolicyDiscountTypeIDValue();
		setCreditScoreValue();
		setPolicyChargeValue();
	}

	private void function loadAction()
		output="false"
	{
		setAction(getData().attributes.action);

		if (!arrayFindNoCase([application.constants.action.quote, application.constants.action.policy, application.constants.action.submission, application.constants.action.bind, application.constants.action.payment], getAction())) {
			throw("Invalid action [#getAction()#]");
		}
	}

	private void function loadAppQuestionResponses()
		output="false"
	{
		if (!structKeyExists(getData(), "appQuestionResponses")) {
			return;
		}

		var appQuestionResponseData = !isArray(getData().appQuestionResponses.appQuestionResponse)?[getData().appQuestionResponses.appQuestionResponse]:getData().appQuestionResponses.appQuestionResponse;

		for (var i=1;i<=arrayLen(appQuestionResponseData);i++) {
			var memento = {};

			for (var e in appQuestionResponseData[i]) {
				if (arrayFindNoCase(["appQuestionID"], e)) {
					structInsert(memento, "appQuestion", getEntityService().get("AppQuestion", appQuestionResponseData[i][e]["text"]), true);
				} else if (isStruct(appQuestionResponseData[i][e]) &&
					structKeyExists(appQuestionResponseData[i][e], "text") &&
					isSimpleValue(appQuestionResponseData[i][e]["text"]))
				{
					structInsert(memento, e, trim(appQuestionResponseData[i][e]["text"]), true);
				}
			}

			if (!structIsEmpty(memento)) {
				structAppend(memento, {
					"policy" = getLine().getPolicy(),
					"user" = getSystemUser()
				}, false);

				getLine().getPolicy().addAppQuestionResponse(getEntityService().new("AppQuestionResponse", memento));
			}
		}
	}

	private void function loadDrivers()
		output="false"
	{
		if (!structKeyExists(getData(), "drivers")) {
			return;
		}

		var driverData = !isArray(getData().drivers.driver)?[getData().drivers.driver]:getData().drivers.driver;

		for (var i=1;i<=arrayLen(driverData);i++) {
			var memento = {};

			for (var e in driverData[i]) {
				if (arrayFindNoCase(["driverAccidents"], e)){
					if (!(isArray(driverData[i]["driverAccidents"]) xor structKeyExists(driverData[i]["driverAccidents"], "driverAccident"))) {
						continue;
					}

					if (!structKeyExists(memento, "driverAccidents")) {
						structInsert(memento, "driverAccidents", []);
					}

					var driverAccidentData = !isArray(driverData[i]["driverAccidents"]["driverAccident"])?[driverData[i]["driverAccidents"]["driverAccident"]]:driverData[i]["driverAccidents"]["driverAccident"];

					for (var k=1;k<=arrayLen(driverAccidentData);k++) {
						var driverAccident = {};

						for (var l in driverAccidentData[k]) {
							if (isStruct(driverAccidentData[k][l]) &&
								structKeyExists(driverAccidentData[k][l], "text") &&
								isSimpleValue(driverAccidentData[k][l]["text"]))
							{
								structInsert(driverAccident, l, trim(driverAccidentData[k][l]["text"]), true);
							}
						}

						if (!structIsEmpty(driverAccident)) {
							structAppend(driverAccident, {
								"policy" = getLine().getPolicy(),
								"auto" = getLine()
							}, false);

							arrayAppend(memento.driverAccidents, getEntityService().new("DriverAccident", driverAccident));
						}
					}
				} else if (isStruct(driverData[i][e]) &&
					structKeyExists(driverData[i][e], "text") &&
					isSimpleValue(driverData[i][e]["text"]))
				{
					structInsert(memento, e, trim(driverData[i][e]["text"]), true);
				}
			}

			structAppend(memento, {
				"policy" = getLine().getPolicy(),
				"auto" = getLine(),
				"driverNumber" = i,
				"driverOrder" = i,
				"licState" = getLine().getPolicy().getInsured().getState(),
				"relationToApplicant" = i==1?"INSURED":"OTHER",
				"namedInsured" = i==1?1:0
			}, false);

			getLine().addDriver(getEntityService().new("Driver", memento));
			getLine().setDriverCount(getLine().getDriverCount()+1);
		}
	}

	private void function loadID()
		output="false"
	{
		setID(structKeyExists(getData().attributes, "id")?structFind(getData().attributes, "id"):"n/a");
	}

	private void function loadInsured()
		hint="I load insured entity"
		output="false"
	{
		if (!structKeyExists(getData(), "insureds")) {
			return;
		}

		var insuredData = !isArray(getData().insureds.insured)?[getData().insureds.insured]:getData().insureds.insured;
		var insured = getEntityService().new("Insured");
		insured.setCreditScore(javacast("null", ""));

		if (!isNull(getLine().getPolicy().getInsured())) {
			insured = getLine().getPolicy().getInsured();
		}

		for (var i=1;i<=arrayLen(insuredData);i++) {
			for (var e in insuredData[i]) {
				if (arrayFindNoCase(["fname","middle","lname"], e)) {
					evaluate("insured.set#e##i#(trim(insuredData[i][e]['text']))");
				} else if (isStruct(insuredData[i][e]) &&
					structKeyExists(insuredData[i][e], "text") &&
					isSimpleValue(insuredData[i][e]["text"]))
				{
					evaluate("insured.set#e#(trim(insuredData[i][e]['text']))");
				}
			}
		}

		var lookup = entityLoadByExample(insured);

		if (arrayLen(lookup) == 1) {
			insured = lookup[1];
		}

		getLine().getPolicy().setInsured(insured);
	}

	private void function loadLine()
		output="false"
	{
		return;
	}

	private void function loadPayments()
		output="false"
	{
		if (!structKeyExists(getData(), "payments")) {
			return;
		}

		var systemInfo = getEntityService().findWhere("SystemInfo", {});
		var paymentData = !isArray(getData().payments.payment)?[getData().payments.payment]:getData().payments.payment;

		for (var i=1;i<=arrayLen(paymentData);i++) {
			var memento = {};

			for (var e in paymentData[i]) {
				if (isStruct(paymentData[i][e]) &&
					structKeyExists(paymentData[i][e], "text") &&
					isSimpleValue(paymentData[i][e]["text"]))
				{
					structInsert(memento, e, trim(paymentData[i][e]["text"]), true);
				}
			}

			structAppend(memento, {
				"policy" = getLine().getPolicy(),
				"insured" = getLine().getPolicy().getInsured(),
				"postMarkedDate" = getDateUtils().formatDateTime(now()),
				"paymentDate" = getDateUtils().formatDateTime(now()),
				"user" = getSystemUser(),
				"depositNum" = systemInfo.getCurrentDepositNum()
			}, false);

			if (!isNull(getLine().getPolicy().getCompany())) {
				structInsert(memento, "company", getLine().getPolicy().getCompany(), true);
			}

			if (!isNull(getLine().getPolicy().getProducer())) {
				structInsert(memento, "producer", getLine().getPolicy().getProducer(), true);
			}

			if (!structKeyExists(memento, "method")) {
				continue;
			} else if (arrayFind([application.constants.payment.method.creditCard, application.constants.payment.method.bankDraft], structFind(memento, "method"))) {
				var payment = getEntityService().new("Payment");
			}

			for (var m in memento) {
				try {
					evaluate("payment.set#m#(memento[m])");
				} catch (any error) {  }
			}

			arrayAppend(getPayments(), payment);
		}
	}

	private void function loadPaymentInfos()
		output="false"
	{
		if (!structKeyExists(getData(), "payments")) {
			return;
		}

		var paymentData = !isArray(getData().payments.payment)?[getData().payments.payment]:getData().payments.payment;

		for (var i=1;i<=arrayLen(paymentData);i++) {
			var memento = {};

			for (var e in paymentData[i]) {
				if (arrayFindNoCase(["ccType"], e)) {
					if (arrayFindNoCase(["American Express", "Amex", 1], trim(paymentData[i][e]["text"]))) {
						structInsert(memento, e, 1, true);
					} else if (arrayFindNoCase(["MasterCard", "MC", 2], trim(paymentData[i][e]["text"]))) {
						structInsert(memento, e, 2, true);
					} else if (arrayFindNoCase(["Visa", "VI", 3], trim(paymentData[i][e]["text"]))) {
						structInsert(memento, e, 3, true);
					} else if (arrayFindNoCase(["Discover", "DC", 4], trim(paymentData[i][e]["text"]))) {
						structInsert(memento, e, 4, true);
					} else {
						structInsert(memento, e, 99, true);
					}
				} else if (arrayFindNoCase(["ccNumber"], e)) {
					structInsert(memento, e, trim(paymentData[i][e]["text"]), true);
				} else if (arrayFindNoCase(["CVV2"], e)) {
					structInsert(memento, "ccSecurity1", trim(paymentData[i][e]["text"]), true);
				} else if (arrayFindNoCase(["ccExpDate"], e) && getValidator().isCCExpDate(trim(paymentData[i][e]["text"]))) {
					structInsert(
						memento,
						e,
						getDateUtils().formatDate(createDate(right(trim(paymentData[i][e]["text"]), 2), left(trim(paymentData[i][e]["text"]), 2), daysInMonth(createDate(right(trim(paymentData[i][e]["text"]), 2), left(trim(paymentData[i][e]["text"]), 2), 1)))),
						true
					);
				} else if (isStruct(paymentData[i][e]) &&
					structKeyExists(paymentData[i][e], "text") &&
					isSimpleValue(paymentData[i][e]["text"]))
				{
					structInsert(memento, e, trim(paymentData[i][e]["text"]), true);
				}
			}

			structAppend(memento, {
				"policy" = getLine().getPolicy(),
				"insured" = getLine().getPolicy().getInsured(),
				"user" = getSystemUser()
			}, false);

			if (!structKeyExists(memento, "method")) {
				continue;
			} else if (arrayFind([application.constants.payment.method.creditCard, application.constants.payment.method.bankDraft], structFind(memento, "method"))) {
				var paymentInfo = getEntityService().new("PaymentInfo");
			}

			for (var m in memento) {
				try {
					evaluate("paymentInfo.set#m#(memento[m])");
				} catch (any error) {  }
			}

			arrayAppend(getPaymentInfos(), paymentInfo);
		}
	}

	private void function loadPolicy()
		hint="I load policy entity"
		output="false"
	{
		if (!structKeyExists(getData(), "policy")) {
			return;
		}

		var policyData = structFind(getData(), "policy");
		var policy = getEntityService().new("Policy", {
			"policyNum" = "TBD",
			"policyType" = application.constants.policyType.pAuto,
			"status" = 99,
			"isDirect" = 1
		});

		if (!isNull(getLine().getPolicy())) {
			policy = getLine().getPolicy();
		}

		for (var e in policyData) {
			if (arrayFindNoCase(["discounts"], e)) {
				var discountData = listToArray(trim(policyData[e]["text"]));

				for (var k=1;k<=arrayLen(discountData);k++) {
					policy.addDiscount(getEntityService().new("PolicyDiscount", {"type" = discountData[k]}));
				}
			} else if (arrayFindNoCase(["companyID"], e)) {
				evaluate("policy.setCompany(getEntityService().get('Company', policyData[e]['text']))");
			} else if (arrayFindNoCase(["stateID"], e)) {
				evaluate("policy.setState(getEntityService().get('State', policyData[e]['text']))");
			} else if (arrayFindNoCase(["producerID"], e)) {
				evaluate("policy.setProducer(getEntityService().get('Producer', policyData[e]['text']))");
			} else if (arrayFindNoCase(["paymentPlanID"], e)) {
				evaluate("policy.setPaymentPlan(getEntityService().get('PaymentPlan', policyData[e]['text']))");
			} else if (isStruct(policyData[e]) &&
				structKeyExists(policyData[e], "text") &&
				isSimpleValue(policyData[e]["text"]))
			{
				try {
					evaluate("policy.set#e#(trim(policyData[e]['text']))");
				} catch (any error) { }
			}
		}

		getLine().setPolicy(policy);
	}

	private void function loadVehicles()
		output="false"
	{
		if (!structKeyExists(getData(), "vehicles")) {
			return;
		}

		var vehicleData = !isArray(getData().vehicles.vehicle)?[getData().vehicles.vehicle]:getData().vehicles.vehicle;

		for (var i=1;i<=arrayLen(vehicleData);i++) {
			var memento = {};

			for (var e in vehicleData[i]) {
				if (arrayFindNoCase(["coverages"], e)){
					if (!(isArray(vehicleData[i]["coverages"]) xor structKeyExists(vehicleData[i]["coverages"], "coverage"))) {
						continue;
					}

					if (!structKeyExists(memento, "coverages")) {
						structInsert(memento, "coverages", []);
					}

					var coverageData = !isArray(vehicleData[i]["coverages"]["coverage"])?[vehicleData[i]["coverages"]["coverage"]]:vehicleData[i]["coverages"]["coverage"];

					for (var k=1;k<=arrayLen(coverageData);k++) {
						var coverage = {};

						for (var l in coverageData[k]) {
							if (arrayFindNoCase(["type"], l)) {
								structInsert(coverage, "coverage", trim(coverageData[k][l]["text"]), true);
							} else if (isStruct(coverageData[k][l]) &&
								structKeyExists(coverageData[k][l], "text") &&
								isSimpleValue(coverageData[k][l]["text"]))
							{
								structInsert(coverage, l, trim(coverageData[k][l]["text"]), true);
							}
						}

						if (!structIsEmpty(coverage)) {
							structAppend(coverage, {
								"policy" = getLine().getPolicy(),
								"policyType" = getLine().getPolicy().getPolicyType()
							}, false);

							arrayAppend(memento.coverages, getEntityService().new("VehicleCoverage", coverage));
						}
					}
				} else if (arrayFindNoCase(["lienholders"], e)){
					if (!(isArray(vehicleData[i]["lienholders"]) xor structKeyExists(vehicleData[i]["lienholders"], "lienholder"))) {
						continue;
					}

					var lienholderData = !isArray(vehicleData[i]["lienholders"]["lienholder"])?[vehicleData[i]["lienholders"]["lienholder"]]:vehicleData[i]["lienholders"]["lienholder"];

					for (var m=1;m<=arrayLen(lienholderData);m++) {
						if (m > 2) {
							break;
						}

						var lienholder = {};

						for (var n in lienholderData[m]) {
							if (arrayFindNoCase(["lientype"], n)) {
								structInsert(memento, "lientype#m#", trim(lienholderData[m][n]["text"]), true);
							} else if (isStruct(lienholderData[m][n]) &&
								structKeyExists(lienholderData[m][n], "text") &&
								isSimpleValue(lienholderData[m][n]["text"]))
							{
								structInsert(lienholder, n, trim(lienholderData[m][n]["text"]), true);
							}
						}

						if (!structIsEmpty(lienholder)) {
							var index = -1;

							structAppend(lienholder, {
								"policy" = getLine().getPolicy(),
								"lienName" = "",
								"address1" = "",
								"city" = "",
								"state" = "",
								"zip" = ""
							}, false);

							if (!isNull(getLine().getPolicy().getLienholders())) {
								for (var p=1;p<=arrayLen(getLine().getPolicy().getLienholders());p++) {
									if (getLine().getPolicy().getLienholders()[p].getLienName() == structFind(lienholder, "lienName") &&
										getLine().getPolicy().getLienholders()[p].getAddress1() == structFind(lienholder, "address1") &&
										getLine().getPolicy().getLienholders()[p].getCity() == structFind(lienholder, "city") &&
										getLine().getPolicy().getLienholders()[p].getState() == structFind(lienholder, "state") &&
										getLine().getPolicy().getLienholders()[p].getZip() == structFind(lienholder, "zip"))
									{
										index = p;
										break;
									}
								}
							}

							if (index == -1) {
								getLine().getPolicy().addLienholder(getEntityService().new("Lienholder", lienholder));
								index = arrayLen(getLine().getPolicy().getLienholders());
							}

							structInsert(memento, "lienholder#m#", getLine().getPolicy().getLienholders()[index]);
						}
					}
				} else if (isStruct(vehicleData[i][e]) &&
					structKeyExists(vehicleData[i][e], "text") &&
					isSimpleValue(vehicleData[i][e]["text"]))
				{
					structInsert(memento, e, trim(vehicleData[i][e]["text"]), true);
				}
			}

			structAppend(memento, {
				"policy" = getLine().getPolicy(),
				"auto" = getLine(),
				"vehicleNumber" = i,
				"vehicleOrder" = i,
				"garageAddress1" = getLine().getPolicy().getInsured().getAddress1(),
				"garageAddress2" = getLine().getPolicy().getInsured().getAddress2(),
				"garageCity" = getLine().getPolicy().getInsured().getCity(),
				"garageState" = getLine().getPolicy().getInsured().getState(),
				"garageZip" = getLine().getPolicy().getInsured().getZip(),
				"usage" = "P"
			}, false);

			getLine().addVehicle(getEntityService().new("Vehicle", memento));
			getLine().setVehicleCount(getLine().getVehicleCount()+1);
		}
	}

	private void function postPaymentInfos()
		output="false"
	{
		var ps = new storedproc();
		var i = 0;

		ps.setProcedure("PostPaymentInfo");

		if (!isNull(getPaymentInfos())) {
			for (i=1;i<=getPaymentInfoCount();i++) {
				var payment = getPayment(i);
				var paymentInfo = getPaymentInfo(i);

				if (isNull(paymentInfo.getPaymentInfoID()) ||
					isNull(payment.getPaymentID()) ||
					!arrayFind([application.constants.payment.method.creditCard, application.constants.payment.method.bankDraft], payment.getMethod()))
				{
					continue;
				}

				ps.addParam(cfsqltype="cf_sql_integer", type="in", value=paymentInfo.getPolicy().getPolicyID());
				ps.addParam(cfsqltype="cf_sql_integer", type="in", value=paymentInfo.getPaymentInfoID());
				ps.addParam(cfsqltype="cf_sql_money", type="in", value=payment.getAmount());
				ps.addParam(cfsqltype="cf_sql_tinyint", type="in", value=payment.getMethod());
				ps.addParam(cfsqltype="cf_sql_integer", type="in", value=payment.getUser().getUserID());
				ps.addParam(cfsqltype="cf_sql_integer", type="in", value=payment.getPaymentID());
				ps.addParam(cfsqltype="cf_sql_integer", type="out", variable="paymentDetailID");
				ps.execute();
				ps.clearParams();
			}
		}
	}

	private void function postProcessPayment()
		output="false"
	{
		var ps = new storedproc();

		// run ProcessRenewal_NotWritten
		if (getLine().getPolicy().getIsRenewal() == 1 && getLine().getPolicy().getStatus() == application.constants.policy.status.notwritten) {
			ps.setProcedure("ProcessRenewal_NotWritten");
			ps.addParam(cfsqltype="cf_sql_integer", type="in", value=getLine().getPolicy().getPolicyID());
			ps.execute();
			ps.clearParams();

			getEntityService().refresh(getLine());
		}
	}

	private void function processPayments()
		output="false"
	{
		if (getPaymentInfoCount() == 0) {
			return;
		}

		var i = 0;
		var directOnlineAgencyFee = 0;

		if (arrayFindNoCase([application.constants.action.bind], getAction())) {
			directOnlineAgencyFee = getProducerPolicyTypeService().getDirectOnlineAgencyFee({
				"producer" = getLine().getPolicy().getProducer().getMainProducer(),
				"company" = getLine().getPolicy().getCompany(),
				"state" = getLine().getPolicy().getState(),
				"policyType" = getLine().getPolicy().getPolicyType()
			});
		}

		for (i=1;i<=getPaymentInfoCount();i++) {
			var payment = getPayment(i);
			var paymentInfo = getPaymentInfo(i);

			if (payment.getMethod() == application.constants.payment.method.creditCard) {
				var storeCardResponse = xmlParse(getIVRService().storeCard(getLine().getPolicy(), paymentInfo));

				if (!storeCardResponse.xmlRoot.storeCardSuccessful.xmlText) {
					throw(
						"Unable to post credit card payment." & getUtils().newLine() &
						"Error Code: " & storeCardResponse.xmlRoot.errorCode.xmlText & getUtils().newLine() &
						"Server Reponse: " & storeCardResponse.xmlRoot.responseText.xmlText
					);
				}

				paymentInfo = getEntityService().get("PaymentInfo", storeCardResponse.xmlRoot.paymentInfoID.xmlText);
				getLine().getPolicy().addPaymentInfo(paymentInfo);
				setPaymentInfo(i, paymentInfo);

				var saleResponse = xmlParse(getIVRService().sale(getLine().getPolicy(), payment, paymentInfo));

				if (!saleResponse.xmlRoot.saleSuccessful.xmlText) {
					throw(
						"Unable to post credit card payment." & getUtils().newLine() &
						"Error Code: " & saleResponse.xmlRoot.errorCode.xmlText & getUtils().newLine() &
						"Server Reponse: " & saleResponse.xmlRoot.responseText.xmlText
					);
				}

				// handle agency fee
				if (!getLine().getPolicy().hasDirectOnlineAgencyFee() &&
					directOnlineAgencyFee > 0 &&
					payment.getAmount() > directOnlineAgencyFee)
				{
					payment.setAmount(payment.getAmount() - directOnlineAgencyFee);
					getLine().getPolicy().addAgencyFee(getEntityService().new("AgencyFee", {
						"policy" = getLine().getPolicy(),
						"payment" = payment,
						"user" = getSystemUser(),
						"agencyFeeDate" = getDateUtils().formatDateTime(now()),
						"amount" = directOnlineAgencyFee,
						"agencyFeeType" = 1,
						"isDirectOnlineAgencyFee" = 1
					}));
				}

				getLine().getPolicy().addPayment(payment);

				var IVRPayment = getEntityService().get("IVRPayment", saleResponse.xmlRoot.IVR_PaymentID.xmlText);
				IVRPayment.setPayment(payment);
				IVRPayment.setIsPosted(1);
				getEntityService().save(IVRPayment);

				setIVRPayment(i, IVRPayment);
				getLine().getPolicy().addIVRPayment(getIVRPayment(i));
			} else {
				// handle agency fee
				if (!getLine().getPolicy().hasDirectOnlineAgencyFee() &&
					directOnlineAgencyFee > 0 &&
					payment.getAmount() > directOnlineAgencyFee)
				{
					payment.setAmount(payment.getAmount() - directOnlineAgencyFee);
					getLine().getPolicy().addAgencyFee(getEntityService().new("AgencyFee", {
						"policy" = getLine().getPolicy(),
						"payment" = payment,
						"user" = getSystemUser(),
						"agencyFeeDate" = getDateUtils().formatDateTime(now()),
						"amount" = directOnlineAgencyFee,
						"agencyFeeType" = 1,
						"isDirectOnlineAgencyFee" = 1
					}));
				}

				getLine().getPolicy().addPayment(payment);

				getLine().getPolicy().addPaymentInfo(paymentInfo);
			}
		}

		getEntityService().save(entity=getLine(), flush=true);
		getEntityService().refresh(getLine());

		// check for postProcessPayment()
		if (structKeyExists(variables, "postProcessPayment")) {
			postProcessPayment();
		}
	}

	private void function refundPayments()
		output="false"
	{
		var systemInfo = getEntityService().findWhere("SystemInfo", {});
		var policy = getLine().getPolicy();
		var i = 0;
		var j = 0;

		if (!isNull(getPayments())) {
			for (i=1;i<=getPaymentCount();i++) {
				var payment = getPayment(i);

				if (isNull(payment.getPaymentID()) || arrayFind([20], payment.getPaymentType()) || arrayFind([20], payment.getStatus())) {
					continue;
				}

				// adjust existing payment
				payment.setStatus(20);
				payment.setDepositNum(systemInfo.getCurrentDepositNum()==payment.getDepositNum()?0:payment.getDepositNum());
				getEntityService().save(payment);

				// adjust DepositProof
				var depositProof = getEntityService().findWhere("DepositProof", {payment = payment});

				if (structKeyExists(local, "depositProof")) {
					depositProof.setProofBatchNum("REVERSED");
					getEntityService().save(depositProof);
				}

				// reverse payment
				var newPayment = getEntityService().new("Payment", {
					policy = payment.getPolicy(),
					amount = 0 - payment.getAmount(),
					paymentDate = payment.getPaymentDate(),
					postMarkedDate = payment.getPostMarkedDate(),
					paymentType = payment.getStatus(),
					method = payment.getMethod(),
					checkNum = payment.getCheckNum(),
					depositNum = payment.getDepositNum(),
					note = "Voided Payment",
					insured = payment.getInsured(),
					producer = payment.getProducer(),
					company = payment.getCompany(),
					user = payment.getUser(),
					noTrans = 2
				});
				getEntityService().save(newPayment);

				// reverse trans
				for (var j=1;j<=arrayLen(payment.getTrans());j++) {
					var oldTrans = payment.getTrans()[j];
					var newTrans = getEntityService().new("Trans", {
						payment = newPayment,
						amount = 0 - oldTrans.getAmount(),
						transDate = oldTrans.getTransDate(),
						transType = oldTrans.getTransType(),
						depositNum = oldTrans.getDepositNum(),
						policy = oldTrans.getPolicy(),
						isRenewal = oldTrans.getIsRenewal(),
						insured = oldTrans.getInsured(),
						producer = oldTrans.getProducer(),
						company = oldTrans.getCompany(),
						transSubType = oldTrans.getTransSubType()
					});

					if (oldTrans.getTransType() == 99) {
						oldTrans.setTransType(98);
						newTrans.setTransType(98);
						getEntityService().save(oldTrans);
					}
					getEntityService().save(newTrans);
				}

				// reverse IVRPayment
				if (payment.getMethod() == application.constants.payment.method.creditCard && !isNull(getIVRPayments())) {
					var IVRPayment = getIVRPayment(i);
					var IVRResponse = javacast("null", "");

					var IVRResponse = getEntityService().findWhere("IVRResponse", {
						policy = policy,
						callID = IVRPayment.getCallID()
					});

					if (isNull(IVRResponse)) {
						continue;
					}

					var refundResponse = xmlParse(getIVRService().refund(policy, payment, IVRPayment, IVRResponse));

					if (!refundResponse.xmlRoot.refundSuccessful.xmlText) {
						throw(
							"Unable to refund credit card payment." & getUtils().newLine() &
							"Error Code: " & refundResponse.xmlRoot.errorCode.xmlText & getUtils().newLine() &
							"Server Reponse: " & refundResponse.xmlRoot.responseText.xmlText
						);
					}

				  	// update refund IVRPayment
					var refundIVRPayment = getEntityService().get("IVRPayment", refundResponse.xmlRoot.refundIVR_PaymentID.xmlText);
				  	refundIVRPayment.setPayment(newPayment);
				  	refundIVRPayment.setIsPosted(1);
				  	getEntityService().save(refundIVRPayment);
				 }
	  		}
		}
	}

	private void function save()
		hint="I save entites"
		output="false"
	{
		try {
			getEntityService().save(entity=getLine(), flush=true);
			getEntityService().refresh(getLine());

			processPayments();

			if (arrayFind([application.constants.action.quote, application.constants.action.policy, application.constants.action.submission], getAction())) {
				getPolicyRatingService().execute(getLine().getPolicy(), getLine().getPolicy().getStatus());
				getEntityService().refresh(getLine());
			}

			if (arrayFindNoCase([application.constants.action.submission, application.constants.action.policy], getAction())) {
				getLine().getPolicy().setStatus(0);
				getLine().getPolicy().setNeedsRated(1);
				getEntityService().save(entity=getLine(), flush=true);
				getLine().getPolicy().setNeedsRated(0);
				getLine().getPolicy().setForceLogEntry(0);
				getEntityService().save(entity=getLine(), flush=true);
			} else if (getAction() == application.constants.action.bind) {
				if (arrayFind([0], getLine().getPolicy().getStatus())) {
					getLine().getPolicy().setStatus(2);
					getEntityService().save(entity=getLine(), flush=true);
					getEntityService().refresh(getLine());
					getLine().getPolicy().setStatus(1);
					getEntityService().save(entity=getLine(), flush=true);
				}
			}

			postPaymentInfos();
		} catch (any e) {
			// refund payments
			refundPayments();

			postPaymentInfos();

			// create an error suspense
			saveContent variable="local.body" {writeOutput(trim("
				Action:#getUtils().newTab(3)##getAction()##getUtils().newLine()#
				Error message:#getUtils().newTab()##e.message##getUtils().newLine()#
				Error detail:#getUtils().newTab()##e.detail##getUtils().newLine(2)#
				All payment transaction(s) (if any) have been refunded and reversed.#getUtils().newLine()#
			"));};
			createPolicySuspense("Error During Remote Call", local.body);

			ormFlush();

			throw(object=e);
		}
	}

	private void function setCompanyValue()
		output="false"
	{
		if (!isNull(getLine().getPolicy().getCompany())) {
			var company = getLine().getPolicy().getCompany();
		} else {
			var company = getCompanyService().findWhere({companyName = getLine().getPolicy().getCompanyName()});
		}

		if (structKeyExists(local, "company")) {
			getLine().getPolicy().setCompany(company);

			if (!isNull(getLine().getPolicy().getPayments())) {
				for (var c=1;c<=arrayLen(getLine().getPolicy().getPayments());c++) {
					if (!isNull(getLine().getPolicy().getPayments()[c].getCompany())) {
						continue;
					}

					getLine().getPolicy().getPayments()[c].setCompany(getLine().getPolicy().getCompany());
				}
			}
		}
	}

	private void function setCreditScoreValue()
		output="false"
	{
		if (getLine().getPolicy().getInsured().getCreditScore() == application.constants.insured.creditScore.none ||
			isNull(getLine().getPolicy().getInsured().getCreditScore()))
		{
			getLine().getPolicy().getInsured().setCreditScore(application.constants.insured.creditScore.good);
		}
	}

	private void function setExpirationDateValue()
		output="false"
	{
		if (isDate(getLine().getPolicy().getExpirationDate()) ||
			!arrayFindNoCase([application.constants.action.quote, application.constants.action.submission], getAction()))
		{
			return;
		}

		getLine().getPolicy().setExpirationDate(getDateUtils().formatDate(dateAdd("m", getLine().getPolicy().getPolicyTerm(), getLine().getPolicy().getEffectivedate())) & " 12:00 AM");
	}

	private void function setIVRPayment(required numeric index, required model.IVRPayment.IVRPayment IVRPayment)
		output="false"
	{
		arraySet(getIVRPayments(), arguments.index, arguments.index, arguments.IVRPayment);
	}

	private void function setPayment(required numeric index, required model.payment.Payment payment)
		output="false"
	{
		arraySet(getPayments(), arguments.index, arguments.index, arguments.payment);
	}

	private void function setPaymentInfo(required numeric index, required model.paymentInfo.PaymentInfo paymentInfo)
		output="false"
	{
		arraySet(getPaymentInfos(), arguments.index, arguments.index, arguments.paymentInfo);
	}

	private void function setPaymentPlanValue()
		output="false"
	{
		if (isNull(getLine().getPolicy().getRatingGroupID()) || !isNull(getLine().getPolicy().getPaymentPlan())) {
			return;
		}

		var paymentPlan = getPaymentPlanService().findWhere({
			planName = len(trim(getLine().getPolicy().getPaymentPlanName()))==0?"Pay In Full":getLine().getPolicy().getPaymentPlanName(),
			policyType = getLine().getPolicy().getPolicyType(),
			company = getLine().getPolicy().getCompany(),
			state = getLine().getPolicy().getState(),
			policyTerm = getLine().getPolicy().getPolicyTerm(),
			isRenewal = getLine().getPolicy().getIsRenewal()
		});

		if (structKeyExists(local, "paymentPlan")) {
			getLine().getPolicy().setPaymentPlan(paymentPlan);
			getLine().getPolicy().setDepositPercent(paymentPlan.getDepositPercent());
			getLine().getPolicy().setInstallmentCount(paymentPlan.getInstallmentCount());
		} else {
			getLine().getPolicy().setPaymentPlan(javaCast("null", ""));
			getLine().getPolicy().setDepositPercent(100);
			getLine().getPolicy().setInstallmentCount(0);
		}
	}

	private void function setPolicyChargeValue()
		output="false"
	{
		var policy = getLine().getPolicy();

		if (isNull(policy.getCompany()) || isNull(policy.getCompany().getFinancials())) {
			return;
		}

		var companyFinancial = getCompanyFinancialService().findWhere({
			"company" = policy.getCompany(),
			"ratingVersionID" = policy.getRatingVersionID(),
			"policyTerm" = policy.getPolicyTerm()
		});

		if (structKeyExists(local, "companyFinancial")) {
			policy.setPolicyCharge(policy.getIsRenewal()==1?companyFinancial.getRenewalPolicyCharge():companyFinancial.getPolicyCharge());
		}
	}

	private void function setPolicyDiscountTypeIDValue()
		output="false"
	{
		var policy = getLine().getPolicy();

		if (isNull(policy.getDiscounts())) {
			return;
		}

		for(var i=arrayLen(policy.getDiscounts());i>=1;i--) {
			var discount = policy.getDiscounts()[i];
			var discountType = getEntityService().findWhere("DiscountType", {"type" = discount.getType()});

			if (!structKeyExists(local, "discountType")) {
				continue;
			}

			discount.setDiscountTypeID(discountType.getDiscountTypeID());
			discount.setDiscountMask(discountType.getDiscountMask());
			discount.setDescription(discountType.getDescription());
			discount.setPolicy(policy);
			discount.setParent(policy);
		}
	}

	private void function setRatingGroupIDValue()
		hint="I determine the value of rating group ID"
		output="false"
	{
		if (isNull(getLine().getPolicy().getCompany()) || isNull(getLine().getPolicy().getState()) || getLine().getPolicy().getRatingGroupID() > 1 ||
			!arrayFindNoCase([application.constants.action.quote, application.constants.action.submission], getAction()))
		{
			return;
		}

		var ratingGroup = getRatingGroupService().findWhere({
			"companyID" = getLine().getPolicy().getCompany().getCompanyID(),
			"stateID" = getLine().getPolicy().getState().getStateID(),
			"policyType" = getLine().getPolicy().getPolicyType(),
			"policyTerm" = getLine().getPolicy().getPolicyTerm()
		});

		if (structKeyExists(local, "ratingGroup")) {
			getLine().getPolicy().setRatingGroupID(ratingGroup.getRatingGroupID());
		}
	}

	private void function setRatingVersionIDValue()
		hint="I determine the value of rating version ID"
		output="false"
	{
		if (getLine().getPolicy().getRatingGroupID() <= 1 || getLine().getPolicy().getRatingVersionID() > 1 ||
			!arrayFindNoCase([application.constants.action.quote, application.constants.action.submission], getAction()))
		{
			return;
		}

		var ratingVersion = getRatingVersionService().findWhere({
			"ratingGroupID" = getLine().getPolicy().getRatingGroupID(),
			"isRenewal" = getLine().getPolicy().getIsRenewal(),
			"effectiveDate" = getLine().getPolicy().getEffectiveDate()
		});

		if (structKeyExists(local, "ratingVersion")) {
			getLine().getPolicy().setRatingVersionID(ratingVersion.getRatingVersionID());
		}
	}

	private void function setStateValue()
		output="false"
	{
		if (!isNull(getLine().getPolicy().getState()) ||
			!arrayFindNoCase([application.constants.action.quote, application.constants.action.submission], getAction()))
		{
			return;
		}

		var state = getStateService().findWhere({
			"state" = getLine().getPolicy().getInsured().getState()
		});

		if (structKeyExists(local, "state")) {
			getLine().getPolicy().setState(state);
		}
	}

	private void function setDiscountCollectionValue()
		output="false"
	{
		return;
	}

	private void function setSurchargeCollectionValue()
		output="false"
	{
		return;
	}

	private void function setUnderwritingCollectionValue()
		output="false"
	{
		getLine().getPolicy().setUnderwritingCollection(getUnderwritingService().getNoteCollection({
			"policyID" = getLine().getPolicy().getPolicyID(),
			"status" = 0,
			"questionText" = ""
		}));
	}

	private void function validate()
		output="false"
	{
		var validator = getRTRValidatorService();
		validator.setLine(getLine());
		validator.setPayments(getPayments());
		validator.setPaymentInfos(getPaymentInfos());
		validator.setAction(getAction());

		if (validator.hasErrors()) {
			throw("Invalid or missing data", "error", serializeJSON(validator.getErrors()));
		}
	}
}