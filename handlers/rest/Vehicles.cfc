/**
api/Vehicles.cfc
@author Peruz Carlsen
@createdate 20141002
@hint Vehicle handler
**/
component  output="false" accessors="true" extends="Base" {
	property name="vehicleservice" inject;

	function index(event, rc, prc) {
		prc.data.message = vehicleservice.list(criteria=rc, sortOrder=event.getValue("sort", ""),max=event.getValue("max", 0),asQuery=event.getValue("asQuery", false));
	}

	function show(event, rc, prc) {
		prc.data.message = vehicleservice.get(rc.id);
	}
}
