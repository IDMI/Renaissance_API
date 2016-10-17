/*
model/SystemInfo.cfc
@author Peruz Carlsen
@createdate 20110804
@description SystemInfo entity
*/
component
	persistent="true"
	table="SystemInfo"
	output="false"
{
	// properties
	property name="webAdminColor" column="webAdminColor" type="string" ormtype="string" default="";
	property name="webUnderColor" column="webUnderColor" type="string" ormtype="string" default="";
	property name="webUserColor" column="webUserColor" type="string" ormtype="string" default="";
	property name="webProducerColor" column="webProducerColor" type="string" ormtype="string" default="";
	property name="webAdjusterColor" column="webAdjusterColor" type="string" ormtype="string" default="";
	property name="currentDepositNum" column="currentDepositNum" type="numeric" ormtype="int" default="1";
	property name="stopPayments" column="stopPayments" type="numeric" ormtype="short" default="0";
	property name="qbClaims" column="qbClaims" type="string" ormtype="string" default="";
	property name="qbGeneral" column="qbGeneral" type="string" ormtype="string" default="";
	property name="qbCommissions" column="qbCommissions" type="string" ormtype="string" default="";
	property name="qbDeposit" column="qbDeposit" type="string" ormtype="string" default="";
	property name="qbPolicyFees" column="qbPolicyFees" type="string" ormtype="string" default="";
	property name="qbPolicyFees_I" column="qbPolicyFees_I" type="string" ormtype="string" default="";
	property name="qbServiceCharges" column="qbServiceCharges" type="string" ormtype="string" default="";
	property name="qbServiceCharges_I" column="qbServiceCharges_I" type="string" ormtype="string" default="";
	property name="qbPremiums" column="qbPremiums" type="string" ormtype="string" default="";
	property name="qbPremiums_I" column="qbPremiums_I" type="string" ormtype="string" default="";
	property name="qbCommissions_E" column="qbCommissions_E" type="string" ormtype="string" default="";
	property name="qbClaims_E" column="qbClaims_E" type="string" ormtype="string" default="";
	property name="qbPolicyCharges" column="qbPolicyCharges" type="string" ormtype="string" default="";
	property name="qbPolicyCharges_I" column="qbPolicyCharges_I" type="string" ormtype="string" default="";
	property name="qbMiscFees" column="qbMiscFees" type="string" ormtype="string" default="";
	property name="qbMiscFees_I" column="qbMiscFees_I" type="string" ormtype="string" default="";
	property name="lastInvoiceDate" column="lastInvoiceDate" type="date" ormtype="timestamp";
	property name="companyName" column="companyName" type="string" ormtype="string" default="";
	property name="address1" column="address1" type="string" ormtype="string" default="";
	property name="address2" column="address2" type="string" ormtype="string" default="";
	property name="city" column="city" type="string" ormtype="string" default="";
	property name="state" column="state" type="string" ormtype="string" default="";
	property name="zip" column="zip" type="string" ormtype="string" default="";
	property name="phone" column="phone" type="string" ormtype="string" default="";
	property name="phone2" column="phone2" type="string" ormtype="string" default="";
	property name="fax" column="fax" type="string" ormtype="string" default="";
	property name="tollFree" column="tollFree" type="string" ormtype="string" default="";
	property name="paymentPhone" column="paymentPhone" type="string" ormtype="string" default="";
	property name="email" column="email" type="string" ormtype="string" default="";
	property name="link" column="link" type="string" ormtype="string" default="";
	property name="lateGracePeriod" column="lateGracePeriod" type="numeric" ormtype="short" default="0";
	property name="reinstatementPeriod" column="reinstatementPeriod" type="numeric" ormtype="short" default="0";
	property name="naicCode" column="naicCode" type="string" ormtype="string" default="";
	property name="notes" column="notes" type="string" ormtype="string" default="";
	property name="depositGrace" column="depositGrace" type="numeric" ormtype="float";
	property name="invoiceDueDate" column="invoiceDueDate" type="numeric" ormtype="short" default="0";
	property name="invoiceAdvance" column="invoiceAdvance" type="numeric" ormtype="short" default="0";
	property name="filingBatchNum" column="filingBatchNum" type="numeric" ormtype="short" default="0";
	property name="patriotCommissionRate" column="patriotCommissionRate" type="numeric" ormtype="float";
	property name="presidentialCommissionRate" column="presidentialCommissionRate" type="numeric" ormtype="float";
	property name="qbRefunds" column="qbRefunds" type="string" ormtype="string" default="";
	property name="qbRefunds_E" column="qbRefunds_E" type="string" ormtype="string" default="";
	property name="bindingCutoff" column="bindingCutoff" type="numeric" ormtype="short" default="0";
	property name="bindingCutoffReason" column="bindingCutoffReason" type="string" ormtype="string" default="";
	property name="billMethods" column="billMethods" type="numeric" ormtype="short" default="0";
	property name="postProducerAdj" column="postProducerAdj" type="numeric" ormtype="short" default="0";
	property name="allowRecurPayment" column="allowRecurPayment" type="numeric" ormtype="short" default="0";
	property name="installmentGraceAmount" column="installmentGraceAmount" type="numeric" ormtype="float";
	property name="invoicePeriod" column="invoicePeriod" type="numeric" ormtype="short" default="0";
	property name="invoiceDeposit" column="invoiceDeposit" type="numeric" ormtype="short" default="0";
	property name="invoiceAP" column="invoiceAP" type="numeric" ormtype="short" default="0";
	property name="stopQuotes" column="stopQuotes" type="numeric" ormtype="short" default="0";
	property name="policyHeaderControl" column="policyHeaderControl" type="numeric" ormtype="short" default="0";
	property name="claimsHeaderControl" column="claimsHeaderControl" type="numeric" ormtype="short" default="0";
	property name="claimsPayableTo" column="claimsPayableTo" type="string" ormtype="string" default="";
	property name="claimsPaymentAddress1" column="claimsPaymentAddress1" type="string" ormtype="string" default="";
	property name="claimsPaymentAddress2" column="claimsPaymentAddress2" type="string" ormtype="string" default="";
	property name="claimsPaymentCity" column="claimsPaymentCity" type="string" ormtype="string" default="";
	property name="claimsPaymentState" column="claimsPaymentState" type="string" ormtype="string" default="";
	property name="claimsPaymentZip" column="claimsPaymentZip" type="string" ormtype="string" default="";
	property name="claimsDepartmentPhone" column="claimsDepartmentPhone" type="string" ormtype="string" default="";
	property name="claimsDepartmentPhone2" column="claimsDepartmentPhone2" type="string" ormtype="string" default="";
	property name="claimsDepartmentFax" column="claimsDepartmentFax" type="string" ormtype="string" default="";
	property name="claimsPaymentTollFree" column="claimsPaymentTollFree" type="string" ormtype="string" default="";
	property name="claimsPaymentPhone" column="claimsPaymentPhone" type="string" ormtype="string" default="";
	property name="claimsDepartmentEmail" column="claimsDepartmentEmail" type="string" ormtype="string" default="";
	property name="logoFile" column="logoFile" type="string" ormtype="string" default="";
	property name="HDR_status" column="HDR_status" type="numeric" ormtype="short" default="0";
	property name="systemInfoID" column="systemInfoID" type="numeric" ormtype="int" fieldtype="id";
	property name="isShutdown" column="isShutdown" type="numeric" ormtype="short" default="0";
	property name="listAllowedUsersID" column="listAllowedUsersID" type="string" ormtype="string" default="";
	property name="shutDownStart" column="shutDownStart" type="date" ormtype="timestamp";
	property name="shutDownEnd" column="shutDownEnd" type="date" ormtype="timestamp";
	property name="shutDownReason" column="shutDownReason" type="string" ormtype="string" default="";
	property name="shutDownScheduleName" column="shutDownScheduleName" type="string" ormtype="string" default="";
	property name="restartScheduleName" column="restartScheduleName" type="string" ormtype="string" default="";
	property name="allowDraft" column="allowDraft" type="numeric" ormtype="short" default="0";
	property name="MVR_Status" column="MVR_Status" type="numeric" ormtype="short" default="0";
	property name="MVR_Type" column="MVR_Type" type="numeric" ormtype="short" default="0";
	property name="passwordInterval" column="passwordInterval" type="numeric" ormtype="int" default="1";
	property name="passwordReuseInterval" column="passwordReuseInterval" type="numeric" ormtype="int" default="1";
	property name="invoiceText" column="invoiceText" type="string" ormtype="string" default="";
	property name="ACEMessaging" column="ACEMessaging" type="string" ormtype="string" default="";
	property name="setAdjusterAtIncident" column="setAdjusterAtIncident" type="numeric" ormtype="short" default="0";
	property name="autoAssignByFeature" column="autoAssignByFeature" type="numeric" ormtype="short" default="0";
	property name="usePrimorisCC" column="usePrimorisCC" type="numeric" ormtype="short" default="0";
	property name="allowRecurringCC" column="allowRecurringCC" type="numeric" ormtype="short" default="0";
}