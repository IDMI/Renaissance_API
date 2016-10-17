/**
claim/ClaimIncidentAuto.cfc
@author Peruz Carlsen
@createdate 20140820
@hint ClaimIncidentAuto entity
**/
component
	output="false"
	persistent="true"
	table="ClaimIncidentAuto"
	schema="dbo"
{
	// id
	property name="id" column="claimIncidentAutoID" fieldtype="id" ormtype="int" type="numeric" generator="native";

	// fields
	property name="claimIncidentID" ormtype="int" type="numeric" insert="false" update="false";
	property name="driverID" ormtype="int" type="numeric" insert="false" update="false";
	property name="vehicleID" ormtype="int" type="numeric" insert="false" update="false";
	property name="incidentStreet" ormtype="string" type="string" default="";
	property name="incidentCity" ormtype="string" type="string" default="";
	property name="incidentState" ormtype="string" type="string" default="";
	property name="incidentCounty" column="county" ormtype="string" type="string" default="";
	property name="vehicleDescription" ormtype="string" type="string" default="";
	property name="vehicleVIN" ormtype="string" type="string" default="";
	property name="vehicleYear" ormtype="string" type="string" default="";
	property name="vehicleMake" ormtype="string" type="string" default="";
	property name="vehicleModel" ormtype="string" type="string" default="";
	property name="driverDescription" ormtype="string" type="string" default="";
	property name="driverName" ormtype="string" type="string" default="";
	property name="driverAddress1" ormtype="string" type="string" default="";
	property name="driverAddress2" ormtype="string" type="string" default="";
	property name="driverCity" ormtype="string" type="string" default="";
	property name="driverState" ormtype="string" type="string" default="";
	property name="driverZip" ormtype="string" type="string" default="";
	property name="driverPhone" ormtype="string" type="string" default="";
	property name="driverPhone2" ormtype="string" type="string" default="";
	property name="driverRelationToInsured" ormtype="string" type="string" default="";
	property name="driverDOB" ormtype="timestamp" type="date";
	property name="driverLicNum" ormtype="string" type="string" default="";
	property name="policeSummary" ormtype="string" type="string" default="";
	property name="citationsIssued" ormtype="string" type="string" default="";
	property name="reportNumber" ormtype="string" type="string" default="";

	// relations
	property name="claimIncident" fieldtype="many-to-one" cfc="ClaimIncident" fkcolumn="claimIncidentID" cascade="save-update";
	property name="driver" fieldtype="many-to-one" cfc="model.driver.Driver" fkcolumn="driverID" cascade="save-update" missingrowignored="true";
	property name="vehicle" fieldtype="many-to-one" cfc="model.vehicle.Vehicle" fkcolumn="vehicleID" cascade="save-update" missingrowignored="true";
}