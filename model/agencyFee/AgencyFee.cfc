/*
model/AgencyFee.cfc
@author Peruz Carlsen
@createdate 20111118
@description AgencyFee entity
*/
component
	persistent="true"
	table="AgencyFee"
	output="false"
{
	// Primary Key
	property name="agencyFeeID" fieldtype="id" column="agencyFeeID" generator="native" setter="false";

	// Properties
	property name="agencyFeeDate" ormtype="timestamp";
	property name="amount" ormtype="float" default="0";
	property name="agencyFeeType" ormtype="short" default="0";
	property name="addDate" ormtype="timestamp" insert="false" update="false" setter="false";
	property name="isDirectOnlineAgencyFee" persistent="false" type="numeric" default="0";

	// relations
	property name="payment" fieldtype="many-to-one" fkcolumn="paymentID" cfc="model.payment.Payment" missingrowignored="true";
	property name="policy" fieldtype="many-to-one" fkcolumn="policyID" cfc="model.policy.Policy";
	property name="user" fieldtype="many-to-one" fkcolumn="usersID" cfc="model.user.User";
}