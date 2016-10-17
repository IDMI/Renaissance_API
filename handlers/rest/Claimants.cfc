/**
api/Claimants.cfc
@author Peruz Carlsen
@createdate 20141002
@hint Claimant handler
**/
component  output="false" accessors="true" extends="Base" {
	property name="claimantService" inject;

	function index(event, rc, prc) {
		prc.data.message = claimantService.list(criteria=rc, sortOrder=event.getValue("sort", ""),max=event.getValue("max", 0),asQuery=event.getValue("asQuery", false));
	}

	function show(event, rc, prc) {
		prc.data.message = claimantService.get(rc.id);
	}
}
