/**
claim/ClaimIncidentProperty.cfc
@author Brittany Stewart
@createdate 20180604
@hint ClaimIncidentProperty entity
**/
component
	output="false"
	persistent="true"
	table="ClaimIncidentProperty"
	schema="dbo"
{
	// id
	property name="id" column="claimIncidentPropertyID" fieldtype="id" ormtype="int" type="numeric" generator="native";

	// fields
	property name="claimIncidentID" ormtype="int" type="numeric" insert="false" update="false";
	property name="propertyAddress1" ormtype="string" type="string" default="";
	property name="propertyAddress2" ormtype="string" type="string" default="";
	property name="propertyCity" ormtype="string" type="string" default="";
	property name="propertyState" ormtype="string" type="string" default="";
	property name="propertyCounty" column="county" ormtype="string" type="string" default="";
	property name="isPowerIntact" column="isPowerIntact" ormtype="int" type="numeric" insert="false" update="false";
	property name="isRoofLeaking" column="isRoofLeaking" ormtype="int" type="numeric" insert="false" update="false";
	property name="hasWetMaterials" column="hasWetMaterials" ormtype="int" type="numeric" insert="false" update="false";
	property name="isHomeLivable" column="isHomeLivable" ormtype="int" type="numeric" insert="false" update="false";
	property name="priority" column="priority" ormtype="int" type="numeric" insert="false" update="false";
	property name="severityCode" column="severityCode" ormtype="int" type="numeric" insert="false" update="false";
	property name="otherInformation" ormtype="string" type="string" default="";
	property name="isKitchenDamaged" column="isKitchenDamaged" ormtype="int" type="numeric" insert="false" update="false";
	property name="isRepresented" column="isRepresented" ormtype="int" type="numeric" insert="false" update="false";
	property name="overrideSeverityCode" column="overrideSeverityCode" ormtype="int" type="numeric" insert="false" update="false";


	// relations
	property name="claimIncident" fieldtype="many-to-one" cfc="ClaimIncident" fkcolumn="claimIncidentID" cascade="save-update";

}