/*
model/IVRPayment.cfc
@author Peruz Carlsen
@createdate 20110803
@description IVRPayment entity
*/
component
	persistent="true"
	table="IVR_Payment"
	output="false"
{
	// primary key
	property name="IVRPaymentID" column="IVR_PaymentID" type="numeric" ormtype="int" fieldtype="id" generator="native" setter="false";

	// properties
	property name="callID" column="callID" type="numeric" ormtype="int" default="1";
	property name="type" column="type" type="numeric" ormtype="byte" default="0";
	property name="paymentMethod" column="paymentMethod" type="numeric" ormtype="short" default="0";
	property name="cardType" column="cardType" type="string" ormtype="string" default="";
	property name="cardNumber" column="cardNumber" type="string" ormtype="string" default="";
	property name="cardAuth" column="cardAuth" type="string" ormtype="string" default="";
	property name="amount" column="amount" type="numeric" ormtype="float" default="0";
	property name="primorisFee" column="primorisFee" type="numeric" ormtype="float" default="0";
	property name="paymentDate" column="paymentDate" type="date" ormtype="timestamp";
	property name="PTSIdentifier" column="PTSIdentifier" type="string" ormtype="string" default="";
	property name="addDate" ormtype="timestamp" insert="false" update="false" setter="false";
	property name="errorMessage" column="errorMessage" type="string" ormtype="string" default="";
	property name="remoteIP" column="remoteIP" type="string" ormtype="string" default="";
	property name="isPosted" column="isPosted" type="numeric" ormtype="short" default="0";
	property name="isExported" column="isExported" type="numeric" ormtype="short" default="0";
	property name="cardholder" column="cardholder" type="string" ormtype="string" default="0";

	// relations
	property name="payment" fieldtype="many-to-one" fkcolumn="paymentID" cfc="model.payment.Payment" missingrowignored="true";
	property name="policy" fieldtype="many-to-one" fkcolumn="policyID" cfc="model.policy.Policy";
}