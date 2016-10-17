/*
model/AppQuestion.cfc
@author Peruz Carlsen
@createdate 20111005
@description AppQuestion entity
*/
component
	persistent="true"
	table="AppQuestion"
	output="false"
{
	// primary key
	property name="appQuestionID" fieldtype="id" column="appQuestionID" generator="native" setter="false";

	// properties
	property name="ratingGroupID" column="ratingGroupID" type="numeric" ormtype="int" default="0";
	property name="ratingVersionID" column="ratingVersionID" type="numeric" ormtype="int" default="0";
	property name="type" column="type" type="string" ormtype="string" default="";
	property name="deny" column="deny" type="string" ormtype="string" default="";
	property name="comment" column="comment" type="string" ormtype="string" default="";
	property name="question" column="question" type="string" ormtype="string" default="";
	property name="doNotBindAnswer" column="doNotBindAnswer" type="string" ormtype="string" default="";
	property name="sortOrder" column="sortOrder" type="numeric" ormtype="short" default="0";
	property name="active" column="active" type="numeric" ormtype="short" default="1";
	property name="policyType" column="policyType" type="numeric" ormtype="short" default="0";
	property name="addDate" ormtype="timestamp" insert="false" update="false";
	property name="shortID" column="shortID" type="string" ormtype="string" default="";

	// relations
	property name="user" fieldtype="many-to-one" fkcolumn="usersID" cfc="model.user.User" lazy="true" inverse="true";
}