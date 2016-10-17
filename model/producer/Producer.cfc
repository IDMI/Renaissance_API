/*
model/Producer.cfc
@author Peruz Carlsen
@createdate 20110618
@description Producer entity
*/
component
	persistent="true"
	table="Producer"
	output="false"
{
	// primary key
	property name="producerID" fieldtype="id" column="producerID" generator="native" setter="false";

	// properties
	property name="mainProducerID" ormtype="int" type="numeric" insert="false" update="false";
	property name="branchID" ormtype="int" type="numeric" insert="false" update="false";
	property name="underwriterID" ormtype="int" type="numeric" insert="false" update="false";
	property name="code" ormtype="string" default="";
	property name="subCode" ormtype="string" default="";
	property name="producerName" ormtype="string" default="";
	property name="address1" ormtype="string" default="";
	property name="address2" ormtype="string" default="";
	property name="city" ormtype="string" default="";
	property name="state" ormtype="string" default="";
	property name="zip" ormtype="string" default="";
	property name="phone" ormtype="string" default="";
	property name="phone2" ormtype="string" default="";
	property name="fax" ormtype="string" default="";
	property name="tollFree" ormtype="string" default="";
	property name="email" ormtype="string" default="";

	// relations
	property name="branchProducer" fieldtype="many-to-one" cfc="Producer" fkcolumn="branchID" joincolumn="producerID" cascade="save-update";
	property name="mainProducer" fieldtype="many-to-one" fkcolumn="mainProducerID" joincolumn="producerID" cfc="model.producer.Producer";
	property name="underwriter" fieldtype="many-to-one" fkcolumn="underwriterID" joincolumn="usersID" cfc="model.user.User";
	property name="producerPolicyTypes" fieldtype="one-to-many" fkcolumn="producerID" cfc="model.producerPolicyType.ProducerPolicyType" singularname="producerPolicyType" cascade="all-delete-orphan";
}