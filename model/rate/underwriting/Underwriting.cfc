/*
model/Underwriting.cfc
@author Peruz Carlsen
@createdate 20110619
@description Underwriting entity
*/
component
	persistent="true"
	table="Underwriting"
	datasource="windhavenRate"
	output="false"
{
	// primary key
	property name="underwritingID" fieldtype="id" column="underwritingID" generator="native" setter="false";

	// properties
	property name="policyID" ormtype="int" default="0";
	property name="companyID" ormtype="int" default="0";
	property name="isValid" ormtype="short" default="0";
	property name="description" ormtype="string" default="";
	property name="questionText" ormtype="string" default="";
	property name="doNotSubmitAnswer" ormtype="string" default="";
	property name="doNotSubmitReason" ormtype="string" default="";
	property name="doNotBindAnswer" ormtype="string" default="";
	property name="doNotBindReason" ormtype="string" default="";
	property name="producerOnly" ormtype="string" default="";
	property name="notes" ormtype="string" default="";
	property name="driverID" ormtype="int" default="0";
	property name="vehicleID" ormtype="int" default="0";
	property name="ruleNumber" ormtype="float" default="0";
	property name="status" ormtype="short" default="0";
	property name="usersID" ormtype="int" default="0";

	// relations
	property name="ratingGroup" fieldtype="many-to-one" fkcolumn="ratingGroupID" cfc="model.rate.ratingGroup.RatingGroup" lazy="true" inverse="true";
	property name="ratingVersion" fieldtype="many-to-one" fkcolumn="ratingVersionID" cfc="model.rate.ratingVersion.RatingVersion" lazy="true" inverse="true";
}