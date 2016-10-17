/**
claim/ClaimCode.cfc
@author Peruz Carlsen
@createdate 20140820
@hint ClaimCode entity
**/
component
	output="false"
	persistent="true"
	table="ClaimCode"
	schema="dbo"
{
	// id
	property name="id" column="claimCodeID" fieldtype="id" ormtype="int" type="numeric" generator="native";

	// fields
	property name="claimCodeCategoryID" ormtype="int" type="numeric" insert="false" update="false";
	property name="code" ormtype="string" type="string" default="";
	property name="description" column="codeDescription" ormtype="string" type="string" default="";
	property name="policyType" ormtype="short" type="numeric" default="0";

	// relations
	property name="category" fieldtype="many-to-one" fkcolumn="claimCodeCategoryID" cfc="ClaimCodeCategory";

}