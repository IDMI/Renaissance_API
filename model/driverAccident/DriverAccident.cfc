/*
model/DriverAccident.cfc
@author Peruz Carlsen
@createdate 20110911
@description DriverAccident entity
*/
component
	persistent="true"
	table="DriverAccident"
	output="false"
{
	// primary key
	property name="driverAccidentID" column="driverAccidentID" fieldtype="id" generator="native" setter="false";

	// properties
	property name="accidentDate" column="accidentDate" type="string" ormtype="string" default="";
	property name="description" column="description" type="string" ormtype="string" default="";
	property name="sdipID" column="sdipID" type="numeric" ormtype="int" default="0";
	property name="sdipDescription" column="sdipDescription" type="string"ormtype="string" default="";
	property name="place" column="place" type="string"ormtype="string" default="";
	property name="agingType" column="agingType" type="numeric" ormtype="short" default="0";
	property name="agingValue" column="agingValue" type="numeric" ormtype="short" default="0";
	property name="importCode" type="string" default="" persistent="false";
	property name="importPoints" type="numeric" default="0" persistent="false";

	// relations
	property name="auto" fieldtype="many-to-one" fkcolumn="autoID" cfc="model.auto.Auto" lazy="true" inverse="true";
	property name="driver" fieldtype="many-to-one" fkcolumn="driverID" cfc="model.driver.Driver" lazy="true" inverse="true";
	property name="policy" fieldtype="many-to-one" fkcolumn="policyID" cfc="model.policy.Policy" lazy="true" inverse="true";
}