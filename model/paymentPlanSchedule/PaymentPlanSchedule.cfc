/*
model/PaymentPlanSchedule.cfc
@author Peruz Carlsen
@createdate 20111007
@description PaymentPlanSchedule entity
*/
component
	persistent="true"
	table="PaymentPlanSchedule"
	output="false"
{
	// primary key
	property name="paymentPlanScheduleID" fieldtype="id" column="paymentPlanScheduleID" generator="native" setter="false";

	// properties
	property name="installmentNumber" ormtype="short" default="0";
	property name="installmentInterval" ormtype="short" default="0";
	property name="paymentPercent" ormtype="float" default="0";
	property name="paymentAmount" ormtype="float" default="0";
	property name="noticeDays" ormtype="short" default="0";
	property name="isDeposit" ormtype="short" default="0";
	property name="agentProcessFee" ormtype="float" default="0";
	property name="ATPFFee" ormtype="float" default="0";
	property name="agentEndorsementFee" ormtype="float" default="0";
	property name="agentRenewalFee" ormtype="float" default="0";
	property name="policyFeeAmount" ormtype="float" default="0";
	property name="policyFeeRate" ormtype="float" default="0";

	// relations
	property name="paymentPlan" fieldtype="many-to-one" fkcolumn="paymentPlanID" cfc="model.paymentPlan.PaymentPlan" lazy="true" inverse="true";
}