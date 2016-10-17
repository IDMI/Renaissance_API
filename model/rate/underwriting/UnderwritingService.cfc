/**
rate/underwriting/UnderwritingService.cfc
@author Peruz Carlsen
@createdate 20120307
@hint Underwriting service
@output false
**/
component
	extends="coldbox.system.orm.hibernate.VirtualEntityService"
	accessors="true"
	singleton
{
	/**
    @author Peruz Carlsen
    @createdate 20120307
    @hint constructor
    @output false
    **/
	public model.rate.underwriting.UnderwritingService function init() {
		super.init(entityName="Underwriting");

		return this;
	}

	/**
    @author Peruz Carlsen
    @createdate 20120326
    @hint Returns array of notes based on given criteria
    @output false
    **/
	public array function getNoteCollection(required struct criteria) {
		var noteCollection = [];
		var underwritings = findAllWhere(arguments.criteria);

		for (var i=1;i<=arrayLen(underwritings);i++) {
			arrayAppend(noteCollection, underwritings[i].getNotes());
		}

		return noteCollection;
	}
}