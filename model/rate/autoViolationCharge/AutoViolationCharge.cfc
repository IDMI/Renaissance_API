/*
model/AutoViolationCharge.cfc
@author Peruz Carlsen
@createdate 20111005
@description AutoViolationCharge entity
*/
component
	persistent="true"
	table="AutoViolationCharge"
	datasource="windhavenRate"
	output="false"
{
	// primary key
	property name="autoViolationChargeID" fieldtype="id" column="autoViolationChargeID" generator="native" setter="false";

	// Properties
	property name="ratingGroupID" ormtype="int" type="numeric" insert="false" update="false";
	property name="ratingVersionID" ormtype="int" type="numeric" insert="false" update="false";
	property name="autoViolationID" column="autoViolationID" ormtype="int" default="0";
	property name="autoViolationTypeID" column="autoViolationTypeID" ormtype="int" default="0";
	property name="violation" ormtype="string" default="";
	property name="agingType" ormtype="short" default="0";

	// relations
	property name="ratingGroup" fieldtype="many-to-one" fkcolumn="ratingGroupID" cfc="model.rate.ratingGroup.RatingGroup" lazy="true" inverse="true";
	property name="ratingVersion" fieldtype="many-to-one" fkcolumn="ratingVersionID" cfc="model.rate.ratingVersion.RatingVersion" lazy="true" inverse="true";
}