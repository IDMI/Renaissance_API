/*
model/AppQuestionResponse.cfc
@author Peruz Carlsen
@createdate 20111006
@description AppQuestionResponse entity
*/
component
	persistent="true"
	table="AppQuestionResponse"
	output="false"
{
	// primary key
	property name="appQuestionResponseID" fieldtype="id" column="appQuestionResponseID" generator="native" setter="false";

	// properties
	property name="response" column="response" type="numeric" ormtype="short" default="0";
	property name="comment" column="comment" type="string" ormtype="string" default="";
	property name="addDate" ormtype="timestamp" insert="false" update="false";

	// relations
	property name="appQuestion" fieldtype="many-to-one" fkcolumn="appQuestionID" cfc="model.appQuestion.AppQuestion" lazy="true" inverse="true";
	property name="policy" fieldtype="many-to-one" fkcolumn="policyID" cfc="model.policy.Policy" lazy="true" inverse="true";
	property name="user" fieldtype="many-to-one" fkcolumn="usersID" cfc="model.user.User" lazy="true" inverse="true";
}