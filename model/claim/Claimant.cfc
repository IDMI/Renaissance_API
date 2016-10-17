/**
claim/Claimant.cfc
@author Peruz Carlsen
@createdate 20140820
@hint Claimant entity
**/
component
	output="false"
	persistent="true"
	table="Claimant"
	schema="dbo"
{
	// id
	property name="id" column="claimantID" fieldtype="id" ormtype="int" type="numeric" generator="native";

	// fields
	property name="claimIncidentID" ormtype="int" type="numeric" insert="false" update="false";
	property name="individualType" ormtype="short" type="numeric" default="0";
	property name="partyType" ormtype="short" type="numeric" default="0";
	property name="isInsured" ormtype="short" type="numeric" default="0";
	property name="fname" column="fname1" ormtype="string" type="string" default="";
	property name="middle" column="middle1" ormtype="string" type="string" default="";
	property name="lname" column="lname1" ormtype="string" type="string" default="";
	property name="address1" ormtype="string" type="string" default="";
	property name="address2" ormtype="string" type="string" default="";
	property name="city" ormtype="string" type="string" default="";
	property name="state" ormtype="string" type="string" default="";
	property name="zip" ormtype="string" type="string" default="";
	property name="county" ormtype="string" type="string" default="";
	property name="phone" ormtype="string" type="string" default="";
	property name="phone2" ormtype="string" type="string" default="";
	property name="fax" ormtype="string" type="string" default="";
	property name="tollFree" ormtype="string" type="string" default="";
	property name="pager" ormtype="string" type="string" default="";
	property name="email" ormtype="string" type="string" default="";
	property name="dob" ormtype="timestamp" type="date";
	property name="addDate" ormtype="timestamp" type="date" update="false";

	// relations
	property name="claimantAutos" fieldtype="one-to-many" cfc="ClaimantAuto" fkcolumn="claimantID" singularname="claimantAuto" inverse="true" cascade="all-delete-orphan";
	property name="claimIncident" fieldtype="many-to-one" cfc="ClaimIncident" fkcolumn="claimIncidentID" cascade="save-update";
}