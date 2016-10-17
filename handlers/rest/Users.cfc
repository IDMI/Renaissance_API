/**
api/Users.cfc
@author Peruz Carlsen
@createdate 20141016
@hint Users handler
**/
component  output="false" accessors="true" extends="Base" {
	property name="userService" inject;

	public function show(event, rc, prc) {
		prc.data.message = userService.get(rc.id);
	}
}