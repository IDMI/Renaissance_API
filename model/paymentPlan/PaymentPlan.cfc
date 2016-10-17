/*
model/PaymentPlan.cfc
@author Peruz Carlsen
@createdate 20110620
@description PaymentPlan entity
*/
component
	persistent="true"
	table="PaymentPlan"
	output="false"
{
	// primary key
	property name="paymentPlanID" fieldtype="id" column="paymentPlanID" generator="native" setter="false";

	// properties
	property name="companyID" ormtype="int" type="numeric" insert="false" update="false";
	property name="stateID" ormtype="int" type="numeric" insert="false" update="false";
	property name="planName" ormtype="string" default="";
	property name="policyType" ormtype="short" default="0";
	property name="policyTerm" ormtype="short" default="0";
	property name="noticeDays" ormtype="short" default="0";
	property name="invoiceDeposit" ormtype="short" default="0";
	property name="invoiceAP" ormtype="short" default="0";
	property name="installmentCharge" ormtype="float" default="0";
	property name="renewalFee" ormtype="float" default="0";
	property name="installmentCount" ormtype="short" default="0";
	property name="depositPercent" ormtype="float" default="0";
	property name="depositAmount" ormtype="float" default="0";
	property name="APDepositPercent" ormtype="float" default="0";
	property name="APDepositAmount" ormtype="float" default="0";
	property name="minAPAmount" ormtype="float" default="0";
	property name="maxAPAmount" ormtype="float" default="0";
	property name="lateFee" ormtype="float" default="0";
	property name="lateGracePeriod" ormtype="short" default="0";
	property name="firstDueDays" ormtype="short" default="0";
	property name="firstDueIncrement" ormtype="short" default="0";
	property name="startDate" ormtype="date";
	property name="stopDate" ormtype="date";
	property name="addDate" ormtype="timestamp" insert="false" update="false";
	property name="lastModified" ormtype="timestamp" insert="false" update="false";
	property name="addFeePremium" ormtype="float" default="0";
	property name="addFeeIncrement" ormtype="float" default="0";
	property name="addFeePerAmount" ormtype="float" default="0";
	property name="graceAmount" ormtype="short" default="0";
	property name="installmentIncrement" ormtype="short" default="0";
	property name="locked" ormtype="short" default="0";
	property name="proRatePolicyFee" ormtype="short" default="0";
	property name="feeInDeposit" ormtype="short" default="0";
	property name="useEquityDating" ormtype="short" default="0";
	property name="renewalDays" ormtype="short" default="0";
	property name="renewalReview" ormtype="short" default="0";
	property name="renewalDepositDays" ormtype="short" default="0";
	property name="renewalFirstDueDays" ormtype="int" default="0";
	property name="policyChargeInstallment" ormtype="short" default="0";
	property name="policyChargeDepositPercent" ormtype="float" default="0";
	property name="requiresEFT" ormtype="short" default="0";
	property name="preferredPlan" ormtype="short" default="0";
	property name="EFTInstallmentCharge" ormtype="float" default="0";
	property name="depositDueDays" ormtype="short" default="0";
	property name="isRenewal" ormtype="short" default="0";

	// relations
	property name="company" fieldtype="many-to-one" fkcolumn="companyID" cfc="model.company.Company";
	property name="preferredPayPlan" fieldtype="many-to-one" fkcolumn="preferredPaymentPlanID" joincolumn="paymentPlanID" cfc="model.paymentPlan.PaymentPlan" missingrowignored="true" lazy="true" inverse="true";
	property name="renewalPaymentPlan" fieldtype="many-to-one" fkcolumn="renewalPaymentPlanID" joincolumn="paymentPlanID" cfc="model.paymentPlan.PaymentPlan" missingrowignored="true" lazy="true" inverse="true";
	property name="schedules" fieldtype="one-to-many" fkcolumn="paymentPlanID" cfc="model.paymentPlanSchedule.PaymentPlanSchedule" singularname="schedule" cascade="all-delete-orphan" lazy="extra" orderby="installmentNumber";
	property name="state" fieldtype="many-to-one" fkcolumn="stateID" cfc="model.state.State";
}