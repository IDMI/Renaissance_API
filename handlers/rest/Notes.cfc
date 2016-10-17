/**
api/Notes.cfc
@author Peruz Carlsen
@createdate 20141002
@hint Note handler
**/
component  output="false" accessors="true" extends="Base" {
	property name="noteService" inject;

	function index(event, rc, prc) {
		prc.data.message = noteService.list(criteria=rc, sortOrder=event.getValue("sort", ""),max=event.getValue("max", 0),asQuery=event.getValue("asQuery", false));
	}

	function show(event, rc, prc) {
		prc.data.message = noteService.get(rc.id);
	}
}
