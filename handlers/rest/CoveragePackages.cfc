component
	extends="Base"
	accessors="true"
	output="false"
{
	property name="coveragePackageService" inject;

	public void function index(event, rc, prc) {
		prc.data.message = coveragePackageService.list(criteria=rc, sortOrder=event.getValue("sort", ""),max=event.getValue("max", 0),asQuery=event.getValue("asQuery", false));
	}
}