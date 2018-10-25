/*
model/Note.cfc
@author Peruz Carlsen
@createdate 20110912
@description Note entity
*/
component
	persistent="true"
	table="Note"
	output="false"
{
	// primary key
	property name="noteID" fieldtype="id" column="noteID" generator="native" setter="false";

	// properties
	property name="claimIncidentID" ormtype="int" type="numeric" insert="false" update="false";
	property name="policyID" ormtype="int" type="numeric" insert="false" update="false";
	property name="userID" column="usersID" ormtype="int" type="numeric" insert="false" update="false";
	property name="noteType" column="noteType" type="numeric" ormtype="short" default="0";
	property name="body" column="body" type="string" ormtype="string" default="";
	property name="addDate" ormtype="timestamp" generated="insert" insert="false" update="false";
	property name="noDelete" column="noDelete" type="numeric" ormtype="short" default="0";
	property name="noteDate" ormtype="timestamp" generated="insert" insert="false" update="false";
	property name="internalNote" column="internalNote" type="numeric" ormtype="short" default="0";
	property name="subject" column="subject" type="string" ormtype="string" default="";

	// relations
	property name="claimIncident" fieldtype="many-to-one" cfc="model.claim.ClaimIncident" fkcolumn="claimIncidentID" cascade="save-update" missingrowignored="true";
	property name="policy" fieldtype="many-to-one" fkcolumn="policyID" cfc="model.policy.Policy" lazy="true" inverse="true" missingrowignored="true";
	property name="user" fieldtype="many-to-one" fkcolumn="usersID" cfc="model.user.User" lazy="true" inverse="true";
}