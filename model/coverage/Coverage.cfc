/*
model/Coverage.cfc
@author Peruz Carlsen
@createdate 20110930
@description Coverage entity
*/
component
	persistent="true"
	table="Coverages"
	discriminatorcolumn="objectName"
	output="false"
{
	// primary key
	property name="coverageID" column="coveragesID" fieldtype="id" generator="native" setter="false";

	// properties
	property name="policyType" column="policyType" type="numeric" ormtype="int" default="0";
	property name="policyCoverageID" column="policyCoveragesID" type="numeric" ormtype="int" default="0";
	property name="coverage" column="coverage" type="string" ormtype="string" default="";
	property name="limit1" column="limit1" type="numeric" ormtype="int" default="0";
	property name="limit2" column="limit2" type="numeric" ormtype="int" default="0";
	property name="limit3" column="limit3" type="numeric" ormtype="int" default="0";
	property name="deductible" column="deductible" type="numeric" ormtype="int" default="0";
	property name="premium" column="premium" type="numeric" ormtype="float" default="0";
	property name="premiumChange" column="premiumChange" type="numeric" ormtype="float" default="0";
	property name="limitDescription" column="limitDescription" type="string" ormtype="string" default="";
	property name="addDate" ormtype="timestamp" setter="false" insert="false" update="false";

	// relations
	property name="policy" fieldtype="many-to-one" fkcolumn="policyID" cfc="model.policy.Policy" lazy="true" inverse="true";
}