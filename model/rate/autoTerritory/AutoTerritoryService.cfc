/**
rate/autoTerritory/AutoTerritoryService.cfc
@author Peruz Carlsen
@createdate 20120307
@hint Auto territory service
@output false
**/
component
	extends="coldbox.system.orm.hibernate.VirtualEntityService"
	accessors="true"
	singleton
{
	property name="ratingGroupService" inject="model";
	property name="ratingVersionService" inject="model";

	/**
    @author Peruz Carlsen
    @createdate 20120307
    @hint constructor
    @output false
    **/
	public model.rate.autoTerritory.AutoTerritoryService function init() {
		super.init(entityName="AutoTerritory");

		return this;
	}

	/**
    @author Peruz Carlsen
    @createdate 20120326
    @hint Returns result based on given criteria
    @output false
    **/
	public array function findAllWhere(required struct criteria) {
		// convert ratingGroupID into ratingGroup entity
		if (structKeyExists(arguments.criteria, "ratingGroupID")) {
			structInsert(arguments.criteria, "ratingGroup", getRatingGroupService().get(structFind(arguments.criteria, "ratingGroupID")), true);
			structDelete(arguments.criteria, "ratingGroupID");
		}

		// convert ratingVersionID into ratingVersion entity
		if (structKeyExists(arguments.criteria, "ratingVersionID")) {
			structInsert(arguments.criteria, "ratingVersion", getRatingVersionService().get(structFind(arguments.criteria, "ratingVersionID")), true);
			structDelete(arguments.criteria, "ratingVersionID");
		}

		return super.findAllWhere(arguments.criteria);
	}
}