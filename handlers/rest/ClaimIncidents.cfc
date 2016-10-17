/**
api/ClaimIncidents.cfc
@author Peruz Carlsen
@createdate 20141002
@hint ClaimIncident handler
**/
component  output="false" accessors="true" extends="Base" {
	property name="claimCodeService" inject;
	property name="claimIncidentAutoService" inject;
	property name="claimIncidentService" inject;
	property name="driverService" inject;
	property name="policyService" inject;
	property name="userService" inject;
	property name="vehicleService" inject;

	function index(event, rc, prc) {
		prc.data.message = claimIncidentService.list(criteria=rc, sortOrder=event.getValue("sort", ""),max=event.getValue("max", 0),asQuery=event.getValue("asQuery", false));
	}

	function show(event, rc, prc) {
		prc.data.message = claimIncidentService.get(rc.id);
	}

	function create(event, rc, prc) {
		prc.data.message = claimIncidentService.populate(target=claimIncidentService.new(), memento=rc, exclude="id,addDate,dateOfLoss,dateReported,claimCode,claimIncidentAuto,internalAdjuster,policy,user");

		prc.data.message.setStatus(event.getValue("status", 1));
		prc.data.message.setNum("TBD");
		prc.data.message.setDateOfLoss(dateConvert("utc2Local", rc.dateOfLoss));
		prc.data.message.setDateReported(dateConvert("utc2Local", rc.dateReported));

		if (event.valueExists("claimCode")) {
			prc.data.message.setClaimCode(claimCodeService.get(rc.claimCode.id));
		}

		if (event.valueExists("policy")) {
			prc.data.message.setPolicy(policyService.get(rc.policy.policyID));
		}

		if (event.valueExists("internalAdjuster")) {
			prc.data.message.setInternalAdjuster(userService.get(rc.internalAdjuster.userID));
		}

		if (event.valueExists("user")) {
			prc.data.message.setUser(userService.get(rc.user.userID));
		}

		if (prc.data.message.hasPolicy()) {
			if (prc.data.message.getPolicy().getPolicyType() == 1) {
				prc.claimIncidentAuto = claimIncidentAutoService.populate(target=claimIncidentAutoService.new(), memento=rc.claimIncidentAuto, exclude="id");

				prc.driver = driverService.get(rc.claimIncidentAuto.driverID, false);
				if (!isNull(prc.driver)) prc.claimIncidentAuto.setDriver(prc.driver);

				prc.vehicle = vehicleService.get(rc.claimIncidentAuto.vehicleID, false);
				if (!isNull(prc.vehicle)) prc.claimIncidentAuto.setVehicle(prc.vehicle);

				prc.data.message.setClaimIncidentAuto(prc.claimIncidentAuto);
				prc.claimIncidentAuto.setClaimIncident(prc.data.message);
			}
		}

		prc.validation = validateModel(target=prc.data.message, constraints=claimIncidentService.getConstraints());
		prc.errors = prc.validation.getAllErrors();

		if (dateDiff("n", now(), prc.data.message.getDateOfLoss()) > 0) {
			arrayAppend(prc.errors, "Date of loss cannot be in the future.");
		}

		if (arrayLen(prc.errors)) {
			throw(arrayToList(prc.errors, "|"));
		}

		claimIncidentService.saveClaimIncident(claimIncident=prc.data.message, flush=true);
	}
}
