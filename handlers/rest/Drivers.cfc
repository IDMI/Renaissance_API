/**
api/Drivers.cfc
@author Peruz Carlsen
@createdate 20141002
@hint Driver handler
**/
component  output="false" accessors="true" extends="Base" {
	property name="driverService" inject;

	function index(event, rc, prc) {
		prc.data.message = driverService.list(criteria=rc, sortOrder=event.getValue("sort", ""),max=event.getValue("max", 0),asQuery=event.getValue("asQuery", false));
	}

	function show(event, rc, prc) {
		prc.data.message = driverService.get(rc.id);
	}
}
