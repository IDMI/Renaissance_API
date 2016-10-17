/**
api/ClaimIncidentAutos.cfc
@author Peruz Carlsen
@createdate 20141002
@hint ClaimIncidentAuto handler
**/
component  output="false" accessors="true" extends="Base" {
	property name="claimIncidentAutoService" inject;

	function index(event, rc, prc) {
		prc.data.message = claimIncidentAutoService.list(criteria=rc, sortOrder=event.getValue("sort", ""),max=event.getValue("max", 0),asQuery=event.getValue("asQuery", false));
	}

	function show(event, rc, prc) {
		prc.data.message = claimIncidentAutoService.get(rc.id);
	}
}
