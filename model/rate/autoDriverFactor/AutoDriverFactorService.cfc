/**
rate/autoDriverFactor/AutoDriverFactorService.cfc
@author Peruz Carlsen
@createdate 20120307
@hint Auto driver factor service
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
	public model.rate.autoDriverFactor.AutoDriverFactorService function init() {
		super.init(entityName="AutoDriverFactor");

		return this;
	}

	/**
    @author Peruz Carlsen
    @createdate 20120326
    @hint Returns result based on given criteria
    @output false
    **/
	public array function findAllWhere(required struct criteria) {
		var age = javacast("null", "");

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

		if (structKeyExists(arguments.criteria, "age")) {
			age = structFind(arguments.criteria, "age");
			structDelete(arguments.criteria, "age");
		}

		var autoDriverFactors = super.findAllWhere(arguments.criteria);

		if (!isNull(age)) {
			for (var i=arrayLen(autoDriverFactors);i>=1;i--) {
				if (autoDriverFactors[i].getMinAge() > age || autoDriverFactors[i].getMaxAge() < age) {
					arrayDeleteAt(autoDriverFactors, i);
					continue;
				}
			}
		}

		return autoDriverFactors;
	}
}