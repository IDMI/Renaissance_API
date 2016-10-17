/**
api/Insureds.cfc
@author Peruz Carlsen
@createdate 20140908
@hint Insured handler
**/
component  output="false" accessors="true" extends="Base" {
	property name="insuredService" inject;

	function show(event, rc, prc) {
		prc.data.message = insuredService.get(rc.id);
	}
}
