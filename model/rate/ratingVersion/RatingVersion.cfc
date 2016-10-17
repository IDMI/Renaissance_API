/*
model/RatingVersion.cfc
@author Peruz Carlsen
@createdate 20110619
@description RatingVersion entity
*/
component
	persistent="true"
	table="RatingVersion"
	datasource="windhavenRate"
	output="false"
{
	// primary key
	property name="ratingVersionID" fieldtype="id" column="ratingVersionID" generator="native" setter="false";

	// properties
	property name="ratingGroupID" ormtype="int" type="numeric" insert="false" update="false";
	property name="newBusinessDate" ormtype="timestamp";
	property name="renewalBusinessDate" ormtype="timestamp";
	property name="stopNewDate" ormtype="timestamp";
	property name="stopRenewalDate" ormtype="timestamp";
	property name="description" ormtype="string" default="";
	property name="notes" ormtype="string" default="";

	// relations
	property name="ratingGroup" fieldtype="many-to-one" fkcolumn="ratingGroupID" cfc="model.rate.ratingGroup.RatingGroup" lazy="true" inverse="true";
}