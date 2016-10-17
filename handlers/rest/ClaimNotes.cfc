/**
api/ClaimNotes.cfc
@author Peruz Carlsen
@createdate 20141002
@hint ClaimNote handler
**/
component  output="false" accessors="true" extends="Base" {
	property name="claimNoteService" inject;

	function index(event, rc, prc) {
		prc.data.message = claimNoteService.list(criteria=rc, sortOrder=event.getValue("sort", ""),max=event.getValue("max", 0),asQuery=event.getValue("asQuery", false));
	}

	function show(event, rc, prc) {
		prc.data.message = claimNoteService.get(rc.id);
	}

	function create(event, rc, prc) {
		prc.data.message = claimNoteService.populate(target=claimNoteService.new(), memento=rc, exclude="id,addDate");
		claimNoteService.save(entity=prc.data.message, flush=true);
	}
}
