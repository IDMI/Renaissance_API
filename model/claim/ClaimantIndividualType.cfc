/**
claim/ClaimantIndividualType.cfc
@author Peruz Carlsen
@createdate 20140820
@hint ClaimantIndividualType entity
**/
component
	output="false"
	persistent="true"
	table="ClaimantIndividualType"
	schema="dbo"
{
	// id
	property name="id" column="claimantIndividualTypeID" fieldtype="id" ormtype="int" type="numeric" generator="native";

	// fields
	property name="type" column="individualType" ormtype="short" type="numeric" default="0";
	property name="description" ormtype="string" type="string" default="";
	property name="sortOrder" ormtype="short" type="numeric" default="0";
	property name="isActive" column="active" ormtype="boolean" type="boolean" default="false";
	property name="addDate" ormtype="timestamp" type="date" update="false";
}