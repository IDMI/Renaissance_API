component
	extends="Base"
	accessors="true"
	output="false"
{
	property name="RTRService" inject;

	public void function create(event,rc,prc) {
		prc.data.message = getRTRService().execute(event.getValue("data", ""));
	}
}