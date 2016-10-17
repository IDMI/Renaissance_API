/*
model/IVRResponse.cfc
@author Peruz Carlsen
@createdate 20110803
@description IVRResponse entity
*/
component
	persistent="true"
	table="IVR_Response"
	output="false"
{
	// primary key
	property name="IVRResponseID" column="IVR_ResponseID" type="numeric" ormtype="int" fieldtype="id" generator="native" setter="false";

	// properties
	property name="callID" column="callID" type="numeric" ormtype="int" default="1";
	property name="sent_policyNum" column="sent_policyNum" type="string" ormtype="string" default="";
	property name="sent_pin" column="sent_pin" type="string" ormtype="string" default="";
	property name="requestStatus" column="requestStatus" type="numeric" ormtype="short" default="0";
	property name="policyStatus" column="policyStatus" type="numeric" ormtype="short" default="0";
	property name="balance" column="balance" type="numeric" ormtype="float" default="0";
	property name="nextPayment" column="nextPayment" type="numeric" ormtype="float" default="0";
	property name="nextPaymentDue" column="nextPaymentDue" type="date" ormtype="timestamp";
	property name="renewalAmount" column="renewalAmount" type="numeric" ormtype="float" default="0";
	property name="isRenewal" column="isRenewal" type="numeric" ormtype="short" default="0";
	property name="effective" column="effective" type="date" ormtype="timestamp";
	property name="expiration" column="expiration" type="date" ormtype="timestamp";
	property name="allowRenew" column="allowRenew" type="numeric" ormtype="short" default="0";
	property name="allowPayment" column="allowPayment" type="numeric" ormtype="short" default="0";
	property name="cancelledDate" column="cancelledDate" type="date" ormtype="timestamp";
	property name="cancelledReason" column="cancelledReason" type="numeric" ormtype="short";
	property name="lastPaymentDate" column="lastPaymentDate" type="date" ormtype="timestamp";
	property name="lastPaymentAmount" column="lastPaymentAmount" type="numeric" ormtype="float" default="0";
	property name="addDate" ormtype="timestamp" insert="false" update="false" setter="false";
	property name="errorMessage" column="errorMessage" type="string" ormtype="string" default="";
	property name="remoteIP" column="remoteIP" type="string" ormtype="string" default="";
	property name="uri" column="uri" type="string" ormtype="string" default="";

	// relations
	property name="insured" fieldtype="many-to-one" fkcolumn="insuredID" cfc="model.insured.Insured";
	property name="policy" fieldtype="many-to-one" fkcolumn="policyID" cfc="model.policy.Policy";
}