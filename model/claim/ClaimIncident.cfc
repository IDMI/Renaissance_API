/**
claim/ClaimIncident.cfc
@author Peruz Carlsen
@createdate 20140820
@hint ClaimIncident entity
**/
component
	output="false"
	persistent="true"
	table="ClaimIncident"
	schema="dbo"
{
	// id
	property name="id" column="claimIncidentID" fieldtype="id" ormtype="int" type="numeric" generator="native";

	// fields
	property name="claimCodeID" ormtype="int" type="numeric" insert="false" update="false";
	property name="claimIncidentAutoID" ormtype="int" type="numeric" insert="false" update="false";
	property name="internalAdjusterID" ormtype="int" type="numeric" insert="false" update="false";
	property name="policyID" ormtype="int" type="numeric" insert="false" update="false";
	property name="userID" column="usersID" ormtype="int" type="numeric" insert="false" update="false";
	property name="status" ormtype="short" type="numeric" default="0";
	property name="num" column="claimIncidentNum" ormtype="string" type="string" default="";
	property name="dateOfLoss" ormtype="timestamp" type="date";
	property name="dateReported" ormtype="timestamp" type="date";
	property name="dateClosed" ormtype="timestamp" type="date";
	property name="description" column="claimDescription" ormtype="string" type="string" default="";
	property name="reportedBy" ormtype="string" type="string" default="";
	property name="addDate" column="dateOpened" ormtype="timestamp" type="date" update="false";

	// non-persistents
	property name="statusText" persistent="false" type="string" default="";

	// relations
	property name="claimCode" fieldtype="many-to-one" cfc="ClaimCode" fkcolumn="claimCodeID" cascade="save-update";
	property name="claimIncidentAuto" fieldtype="many-to-one" cfc="ClaimIncidentAuto" fkcolumn="claimIncidentAutoID" cascade="save-update" missingrowignored="true";
	property name="claimNotes" fieldtype="one-to-many" cfc="ClaimNote" fkcolumn="claimIncidentID" singularname="claimNote" inverse="true" cascade="save-update";
	property name="internalAdjuster" fieldtype="many-to-one" cfc="model.user.User" fkcolumn="internalAdjusterID" cascade="save-update";
	property name="notes" fieldtype="one-to-many" cfc="model.note.Note" fkcolumn="claimIncidentID" singularname="note" inverse="true" cascade="save-update";
	property name="policy" fieldtype="many-to-one" cfc="model.policy.Policy" fkcolumn="policyID" cascade="save-update";
	property name="user" fieldtype="many-to-one" cfc="model.user.User" fkcolumn="usersID" cascade="save-update";

	public string function getStatusText(numeric status = getStatus(), string defaultVal = "???") {
		var arr = ["Open", "In Review", "Litigation", "Subrogation", "Closed", "Denied", "Report Only", "Salvage"];
		return (arrayLen(arr) > arguments.status) ? arr[arguments.status + 1] : defaultVal;
	}
}