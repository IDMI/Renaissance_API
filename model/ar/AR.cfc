/*
model/AR.cfc
@author Peruz Carlsen
@createdate 20110803
@description AR entity
*/
component
	persistent="true"
	table="AR"
	output="false"
{
	// primary key
	property name="arID" fieldtype="id" column="arID" generator="native" setter="false";

	// properties
	property name="arDate" ormtype="timestamp";
	property name="amount" ormtype="float" default="0";
	property name="arType" ormtype="short" default="0";
	property name="isDeposit" ormtype="short" default="0";
	property name="addDate" ormtype="timestamp" insert="false" update="false" setter="false";
	property name="amountCleared" ormtype="float" default="0";
	property name="invoiced" ormtype="short" default="0";
	property name="invoiceDate" ormtype="timestamp";
	property name="invoiceEndDate" ormtype="timestamp";
	property name="invoiceID" ormtype="int" default="1";
	property name="arSubType" ormtype="short" default="0";
	property name="policyPremiumID" ormtype="int" default="1";
	property name="accountExpenseID" ormtype="int" default="1";
	property name="installmentNumber" ormtype="short" default="0";
	property name="isFinance" ormtype="short" default="0";
	property name="arGroupType" ormtype="short" default="0";
	property name="debugNote" ormtype="string" default="";

	// relations
	property name="policy" fieldtype="many-to-one" fkcolumn="policyID" cfc="model.policy.Policy";
	property name="user" fieldtype="many-to-one" fkcolumn="usersID" cfc="model.user.User";
}