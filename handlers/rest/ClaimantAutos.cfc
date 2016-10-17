/**
api/ClaimantAutos.cfc
@author Peruz Carlsen
@createdate 20141002
@hint ClaimantAuto handler
**/
component  output="false" accessors="true" extends="Base" {
	property name="claimantAutoService" inject;

	function index(event, rc, prc) {
		prc.data.message = claimantAutoService.list(criteria=rc, sortOrder=event.getValue("sort", ""),max=event.getValue("max", 0),asQuery=event.getValue("asQuery", false));
	}

	function show(event, rc, prc) {
		prc.data.message = claimantAutoService.get(rc.id);
	}
}
