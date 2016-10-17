/*
model/RatingGroup.cfc
@author Peruz Carlsen
@createdate 20110619
@description RatingGroup entity
*/
component
	persistent="true"
	table="RatingGroup"
	datasource="windhavenRate"
	output="false"
{
	// primary key
	property name="ratingGroupID" fieldtype="id" column="ratingGroupID" generator="native" setter="false";

	// properties
	property name="companyID" ormtype="int" default="0";
	property name="stateID" ormtype="int" default="0";
	property name="policyType" ormtype="short" default="0";
	property name="policyTerm" ormtype="string" default="";
	property name="ratingProgram" ormtype="short" default="0";
	property name="description" ormtype="string" default="";
	property name="notes" ormtype="string" default="";
	property name="addDate" ormtype="timestamp" setter="false" insert="false" update="false";
}