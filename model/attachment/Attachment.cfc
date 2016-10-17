/**
attachment/Attachment.cfc
@author Peruz Carlsen
@createdate 20141028
@hint Attachment entity
**/
component
	output="false"
	persistent="true"
	table="Attachment"
	schema="dbo"
{
	// id
	property name="id" column="attachmentID" fieldtype="id" ormtype="int" type="numeric" generator="native";

	// fields
	property name="policyID" ormtype="int" type="numeric" insert="false" update="false";
	property name="claimIncidentID" ormtype="int" type="numeric" insert="false" update="false";
	property name="userID" column="usersID" ormtype="int" type="numeric" insert="false" update="false";
	property name="name" column="fileName" ormtype="string" type="string" default="";
	property name="path" column="filePath" ormtype="string" type="string" default="";
	property name="description" ormtype="string" type="string" default="";
	property name="notes" ormtype="string" type="string" default="";
	property name="isViewableByInsured" ormtype="boolean" type="boolean" default="false";
	property name="addDate" ormtype="timestamp" type="date" update="false";

	// relations
	property name="claimIncident" fieldtype="many-to-one" cfc="model.claim.ClaimIncident" fkcolumn="claimIncidentID" cascade="save-update" missingrowignored="true";
	property name="policy" fieldtype="many-to-one" cfc="model.policy.Policy" fkcolumn="policyID" cascade="save-update" missingrowignored="true";
	property name="user" fieldtype="many-to-one" cfc="model.user.User" fkcolumn="usersID" cascade="save-update" missingrowignored="true";
}