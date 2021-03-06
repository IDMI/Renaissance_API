/**
api/ClaimCodeCategories.cfc
@author Peruz Carlsen
@createdate 20141002
@hint claimCodeCategory handler
**/
component  output="false" accessors="true" extends="Base" {
	property name="claimCodeCategoryService" inject;

	function index(event, rc, prc) {
		prc.data.message = claimCodeCategoryService.list(criteria=rc, sortOrder=event.getValue("sort", ""),max=event.getValue("max", 0),asQuery=event.getValue("asQuery", false));
	}

	function show(event, rc, prc) {
		prc.data.message = claimCodeCategoryService.get(rc.id);
	}
}
