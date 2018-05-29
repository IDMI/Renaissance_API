/**
claim/ClaimCodeCategory.cfc
@author Peruz Carlsen
@createdate 20140820
@hint ClaimCodeCategory entity
**/
component
	output="false"
	persistent="true"
	table="ClaimCodeCategories"
	schema="dbo"
{
	// id
	property name="id" fieldtype="id" ormtype="int" type="numeric" generator="native";

	// fields
	property name="parentID" ormtype="int" type="numeric" insert="false" update="false";
	property name="description" ormtype="string" type="string" default="";
	property name="logo" ormtype="string" type="string" default="";
	property name="sortOrder" ormtype="short" type="numeric" default="1";
	property name="isActive" ormtype="boolean" type="boolean" default="true";
	property name="addDate" ormtype="timestamp" type="date" update="false";
	property name="policyType" ormtype="int" type="numeric" default="1";

	// relations
	property name="claimCodes" fieldtype="one-to-many" fkcolumn="claimCodeCategoryID" cfc="ClaimCode" singularname="claimCode" inverse="true" cascade="all-delete-orphan";
	property name="parent" fieldtype="many-to-one" fkcolumn="parentID" cfc="ClaimCodeCategory";
}