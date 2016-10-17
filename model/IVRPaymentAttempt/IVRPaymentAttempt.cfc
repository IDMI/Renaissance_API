/*
beans/IVRPaymentAttempt.cfc
@author Peruz Carlsen
@createdate 20120110
@description IVR_Payment_Attemp entity
*/
component
	persistent="true"
	table="IVR_PaymentAttempt"
	output="false"
{
	// primary key
	property name="IVRPaymentAttemptID" column="IVR_PaymentAttemptID" type="numeric" ormtype="int" fieldtype="id" generator="native" setter="false";

	// properties
	property name="policyHolderLoginID" column="policyHolderLoginID" type="numeric" ormtype="int" default="0";
	property name="timeAtInitiation" column="timeAtInitiation" type="date" ormtype="timestamp";
	property name="isPayment" column="isPayment" type="numeric" ormtype="short" default="0";
	property name="message" column="message" type="string" ormtype="string" default="";

	// relations
	property name="insured" fieldtype="many-to-one" fkcolumn="insuredID" cfc="model.insured.Insured" cascade="save-update" inverse="true" missingrowignored="true";
	property name="user" fieldtype="many-to-one" fkcolumn="usersID" cfc="model.user.User" inverse="true";
}
