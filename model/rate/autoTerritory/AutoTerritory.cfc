/*
model/AutoTerritory.cfc
@author Peruz Carlsen
@createdate 20111003
@description AutoTerritory entity
*/
component
	persistent="true"
	table="AutoTerritory"
	datasource="RenaissanceRate"
	output="false"
{
	// primary key
	property name="autoTerritoryID" fieldtype="id" column="autoTerritoryID" generator="native" setter="false";

	// properties
	property name="city" ormtype="string" default="";
	property name="county" ormtype="string" default="";
	property name="zipCode" ormtype="int" default="0";
	property name="territory" ormtype="string" default="";
	property name="ratingTerritory" ormtype="int" default="0";

	// relations
	property name="ratingGroup" fieldtype="many-to-one" fkcolumn="ratingGroupID" cfc="model.rate.ratingGroup.RatingGroup" lazy="true" inverse="true";
	property name="ratingVersion" fieldtype="many-to-one" fkcolumn="ratingVersionID" cfc="model.rate.ratingVersion.RatingVersion" lazy="true" inverse="true";
}