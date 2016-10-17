/*
model/AutoDriverFactor.cfc
@author Peruz Carlsen
@createdate 20111004
@description AutoDriverFactor entity
*/
component
	persistent="true"
	table="AutoDriverFactor"
	datasource="windhavenRate"
	output="false"
{
	// primary key
	property name="autoDriverFactorID" fieldtype="id" column="autoDriverFactorID" generator="native" setter="false";

	// properties
	property name="policyCoverageID" column="policyCoveragesID" ormtype="int" default="0";
	property name="gender" ormtype="string" default="";
	property name="maritalStatus" ormtype="string" default="";
	property name="minAge" ormtype="short" default="0";
	property name="maxAge" ormtype="short" default="0";
	property name="minExperience" ormtype="short" default="0";
	property name="maxExperience" ormtype="short" default="0";
	property name="code" ormtype="string" default="";
	property name="factor" ormtype="float" default="1";

	// relations
	property name="ratingGroup" fieldtype="many-to-one" fkcolumn="ratingGroupID" cfc="model.rate.ratingGroup.RatingGroup" lazy="true" inverse="true";
	property name="ratingVersion" fieldtype="many-to-one" fkcolumn="ratingVersionID" cfc="model.rate.ratingVersion.RatingVersion" lazy="true" inverse="true";
}