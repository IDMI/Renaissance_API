/*
model/ProducerPolicyType.cfc
@author Peruz Carlsen
@createdate 20111118
@description ProducerPolicyType entity
*/
component
	persistent="true"
	table="ProducerPolicyType"
	output="false"
{
	// Primary Key
	property name="producerPolicyTypeID" fieldtype="id" column="producerPolicyTypeID" generator="native" setter="false";

	// Properties
	property name="companyID" ormtype="int" type="numeric" insert="false" update="false";
	property name="producerID" ormtype="int" type="numeric" insert="false" update="false";
	property name="stateID" ormtype="int" type="numeric" insert="false" update="false";
	property name="policyType" ormtype="short" default="0";
	property name="quoteStatus" ormtype="short" default="0";
	property name="endorsementStatus" ormtype="short" default="0";
	property name="paymentStatus" ormtype="short" default="0";
	property name="bindingStatus" ormtype="short" default="0";
	property name="addDate" ormtype="timestamp" insert="false" update="false" setter="false";
	property name="notes" ormtype="string" default="";
	property name="directOnlineAgencyFee" persistent="false" type="numeric" default="0";

	// relations
	property name="company" fieldtype="many-to-one" fkcolumn="companyID" cfc="model.company.Company" lazy="true" inverse="true";
	property name="producer" fieldtype="many-to-one" fkcolumn="producerID" cfc="model.producer.Producer" cascade="save-update" lazy="true" inverse="true";
	property name="state" fieldtype="many-to-one" fkcolumn="stateID" cfc="model.state.State" lazy="true" inverse="true";
	property name="user" fieldtype="many-to-one" fkcolumn="usersID" cfc="model.user.User" lazy="true" inverse="true";
}