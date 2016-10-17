/*
model/DepositProof.cfc
@author Peruz Carlsen
@createdate 20110804
@description DepositProof entity
*/
component
	persistent="true"
	table="DepositProof"
	output="false"
{
	// primary key
	property name="depositProofID" column="depositProofID" type="numeric" ormtype="int" fieldtype="id" generator="native" setter="false";

	// properties
	property name="depositID" column="depositID" type="numeric" ormtype="int" default="1";
	property name="depositNum" column="depositNum" type="numeric" ormtype="int" default="1";
	property name="proofBatchNum" column="proofBatchNum" type="string" ormtype="string" default="";
	property name="addDate" ormtype="timestamp" insert="false" update="false" setter="false";
	property name="status" column="status" type="numeric" ormtype="short" default="0";
	property name="isFinance" column="isFinance" type="numeric" ormtype="short" default="0";

	// relations
	property name="payment" fieldtype="many-to-one" fkcolumn="paymentID" cfc="model.payment.Payment";
	property name="user" fieldtype="many-to-one" fkcolumn="usersID" cfc="model.user.User";
}