component
	extends="Base"
	accessors="true"
	output="false"
{
	property name="policyService" inject;

	function index(event, rc, prc) {
		prc.data.message = policyService.list(criteria=rc, sortOrder=event.getValue("sort", ""),max=event.getValue("max", 0),asQuery=event.getValue("asQuery", false));
	}

	function show(event, rc, prc) {
		prc.data.message = policyService.get(rc.id);
	}
}