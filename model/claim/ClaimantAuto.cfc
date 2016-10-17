/**
claim/ClaimantAuto.cfc
@author Peruz Carlsen
@createdate 20140820
@hint ClaimantAuto entity
**/
component
	output="false"
	persistent="true"
	table="ClaimantAuto"
	schema="dbo"
{
	// id
	property name="id" column="claimantAutoID" fieldtype="id" ormtype="int" type="numeric" generator="native";

	// fields
	property name="claimantID" ormtype="int" type="numeric" insert="false" update="false";
	property name="vehicleVIN" column="VIN" ormtype="string" type="string" default="";
	property name="vehicleYear" ormtype="string" type="string" default="";
	property name="vehicleMake" ormtype="string" type="string" default="";
	property name="vehicleModel" ormtype="string" type="string" default="";
	property name="driverName" ormtype="string" type="string" default="";
	property name="driverAddress1" ormtype="string" type="string" default="";
	property name="driverAddress2" ormtype="string" type="string" default="";
	property name="driverCity" ormtype="string" type="string" default="";
	property name="driverState" ormtype="string" type="string" default="";
	property name="driverZip" ormtype="string" type="string" default="";
	property name="driverPhone" column="driverPhone1" ormtype="string" type="string" default="";
	property name="driverPhone2" ormtype="string" type="string" default="";
	property name="driverLicNum" column="licNum" ormtype="string" type="string" default="";

	// relations
	property name="claimant" fieldtype="many-to-one" cfc="Claimant" fkcolumn="claimantID" cascade="save-update";
}