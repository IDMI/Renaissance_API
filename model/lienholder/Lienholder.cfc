/*
model/Lienholder.cfc
@author Peruz Carlsen
@createdate 20110627
@description Lienholder entity
*/
component
	persistent="true"
	table="Lienholder"
	output="false"
{
	// primary key
	property name="lienholderID" fieldtype="id" column="lienholderID" generator="native" setter="false";

	// properties
	property name="lienName" ormtype="string" default="";
	property name="lienName2" ormtype="string" default="";
	property name="lienNumber" ormtype="int" default="1";
	property name="lienType" ormtype="short" default="0";
	property name="lienAccountNum" ormtype="string" default="";
	property name="address1" ormtype="string" default="";
	property name="address2" ormtype="string" default="";
	property name="city" ormtype="string" default="";
	property name="state" ormtype="string" default="";
	property name="zip" ormtype="string" default="";
	property name="billingStatus" ormtype="short" default="0";
	property name="addDate" ormtype="timestamp" insert="false" update="false" setter="false";
	property name="status" ormtype="short" default="0";
	property name="removedDate" ormtype="timestamp" insert="false" update="false" setter="false";
	property name="lienDetailID" ormtype="string" default="";
	property name="itemNumber" type="numeric" persistent="false";

	// relations
	property name="policy" fieldtype="many-to-one" fkcolumn="policyID" cfc="model.policy.Policy" missingrowignored="true" lazy="true" inverse="true";
	property name="removedUser" fieldtype="many-to-one" fkcolumn="removedUsersID" joincolumn="usersID"  cfc="model.user.User" missingrowignored="true" lazy="true" inverse="true";
}