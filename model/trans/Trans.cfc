/*
model/Trans.cfc
@author Peruz Carlsen
@createdate 20110804
@description Trans entity
*/
component
	persistent="true"
	table="Trans"
	output="false"
{
	// primary key
	property name="transID" column="transID" type="numeric" ormtype="int" fieldtype="id" generator="native" setter="false";

	// properties
	property name="transDate" column="transDate" type="date" ormtype="timestamp";
	property name="amount" column="amount" type="numeric" ormtype="float" default="0";
	property name="transType" column="transType" type="numeric" ormtype="short" default="0";
	property name="expenseAccountName" column="expenseAccountName" type="string" ormtype="string" default="";
	property name="expenseAccountNum" column="expenseAccountNum" type="string" ormtype="string" default="";
	property name="incomeAccountName" column="incomeAccountName" type="string" ormtype="string" default="";
	property name="incomeAccountNum" column="incomeAccountNum" type="string" ormtype="string" default="";
	property name="depositNum" column="depositNum" type="numeric" ormtype="int" default="1";
	property name="isRenewal" column="isRenewal" type="numeric" ormtype="short" default="0";
	property name="commissionID" column="commissionID" type="numeric" ormtype="int" default="1";
	property name="commissionRate" column="commissionRate" type="numeric" ormtype="float" default="0";
	property name="transSubType" column="transSubType" type="numeric" ormtype="short" default="0";
	property name="noLogEntry" column="noLogEntry" type="numeric" ormtype="short" default="0";

	// relations
	property name="company" fieldtype="many-to-one" fkcolumn="companyID" cfc="model.company.Company" lazy="true" inverse="true";
	property name="insured" fieldtype="many-to-one" fkcolumn="insuredID" cfc="model.insured.Insured" lazy="true" inverse="true";
	property name="payment" fieldtype="many-to-one" fkcolumn="paymentID" cfc="model.payment.Payment" lazy="true" inverse="true";
	property name="policy" fieldtype="many-to-one" fkcolumn="policyID" cfc="model.policy.Policy" lazy="true" inverse="true";
	property name="producer" fieldtype="many-to-one" fkcolumn="producerID" cfc="model.producer.Producer" lazy="true" inverse="true";
}