/*
model/Suspense.cfc
@author Peruz Carlsen
@createdate 20110804
@description Suspense entity
*/
component
	persistent="true"
	table="Suspense"
	output="false"
{
	// primary key
	property name="suspenseID" column="suspenseID" type="numeric" ormtype="int" fieldtype="id" generator="native" setter="false";

	// properties
	property name="suspenseType" column="suspenseType" type="numeric" ormtype="byte" default="0";
	property name="issued" column="issued" type="date" ormtype="timestamp";
	property name="expires" column="expires" type="date" ormtype="timestamp";
	property name="title" column="title" type="string" ormtype="string" default="";
	property name="body" column="body" type="string" ormtype="string" default="";
	property name="completed" column="completed" type="numeric" ormtype="short" default="0";
	property name="completedDate" column="completedDate" type="date" ormtype="timestamp";
	property name="notes" column="notes" type="string" ormtype="string" default="";
	property name="claimIncidentID" column="claimIncidentID" type="numeric" ormtype="int" default="1";
	property name="terminationDetailID" column="terminationDetailID" type="numeric" ormtype="int" default="1";

	// relations
	property name="company" fieldtype="many-to-one" fkcolumn="companyID" cfc="model.company.Company"missingrowignored="true";
	property name="completedUser" fieldtype="many-to-one" fkcolumn="completedID" joincolumn="usersID" cfc="model.user.User";
	property name="insured" fieldtype="many-to-one" fkcolumn="insuredID" cfc="model.insured.Insured" missingrowignored="true";
	property name="policy" fieldtype="many-to-one" fkcolumn="policyID" cfc="model.policy.Policy" missingrowignored="true";
	property name="producer" fieldtype="many-to-one" fkcolumn="producerID" cfc="model.producer.Producer"missingrowignored="true";
	property name="supervisorUser" fieldtype="many-to-one" fkcolumn="usersIDSupervisor" joincolumn="usersID" cfc="model.user.User";
	property name="userFrom" fieldtype="many-to-one" fkcolumn="usersIDfrom" joincolumn="usersID" cfc="model.user.User";
	property name="userTo" fieldtype="many-to-one" fkcolumn="usersIDTo" joincolumn="usersID" cfc="model.user.User";
}