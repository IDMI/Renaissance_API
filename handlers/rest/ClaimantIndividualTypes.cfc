/**
api/ClaimantIndividualTypes.cfc
@author Peruz Carlsen
@createdate 20141002
@hint ClaimantIndividualType handler
**/
component  output="false" accessors="true" extends="Base" {
	property name="claimantIndividualTypeService" inject;

	function index(event, rc, prc) {
		prc.data.message = claimantIndividualTypeService.list(criteria=rc, sortOrder=event.getValue("sort", ""),max=event.getValue("max", 0),asQuery=event.getValue("asQuery", false));
	}

	function show(event, rc, prc) {
		prc.data.message = claimantIndividualTypeService.get(rc.id);
	}
}
