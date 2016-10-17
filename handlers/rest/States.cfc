component
	extends="Base"
	accessors="true"
	output="false"
{
	property name="stateService" inject="model";

	function index(event, rc, prc) {
		prc.data.message = stateService.list(criteria=rc, sortOrder=event.getValue("sort", ""),max=event.getValue("max", 0),asQuery=event.getValue("asQuery", false));
	}

	function show(event, rc, prc) {
		prc.data.message = stateService.get(rc.id);
	}
}