/*
beans/PolicyRateDetail.cfc
@author Peruz Carlsen
@createdate 20120209
@description PolicyRateDetail entity
*/
component
	persistent="true"
	table="PolicyRateDetail"
	output="false"
{
	// primary key
	property name="policyRateDetailID" fieldtype="id" column="policyRateDetailID" generator="native" setter="false";

	// properties
	property name="premiumTotal" column="premiumTotal" type="numeric" ormtype="float" default="0";
	property name="ratingVersion" column="ratingVersion" type="numeric" ormtype="float" default="0";
	property name="addDate" ormtype="timestamp" insert="false" update="false" setter="false";

	// relations
	property name="policy" fieldtype="one-to-one" fkcolumn="policyID" cfc="model.policy.Policy" cascade="all-delete-orphan" lazy="true";
	property name="user" fieldtype="many-to-one" fkcolumn="usersID" cfc="model.user.User" lazy="true" inverse="true";
}