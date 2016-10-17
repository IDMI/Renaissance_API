/**
claim/ClaimNote.cfc
@author Peruz Carlsen
@createdate 20140820
@hint ClaimNote entity
**/
component
	output="false"
	persistent="true"
	table="ClaimNote"
	schema="dbo"
{
	// id
	property name="id" column="claimNoteID" fieldtype="id" ormtype="int" type="numeric" generator="native";

	// fields
	property name="claimIncidentID" ormtype="int" type="numeric" insert="false" update="false";
	property name="userID" column="usersID" ormtype="int" type="numeric" insert="false" update="false";
	property name="type" column="noteType" ormtype="string" type="string";
	property name="title" column="noteTitle" ormtype="string" type="string" default="";
	property name="body" ormtype="string" type="string" default="";
	property name="addDate" ormtype="timestamp" type="date" update="false";

	// relations
	property name="claimIncident" fieldtype="many-to-one" cfc="ClaimIncident" fkcolumn="claimIncidentID" cascade="save-update";
	property name="user" fieldtype="many-to-one" cfc="model.user.User" fkcolumn="usersID" cascade="save-update";
}