/*
model/PolicyCoverage.cfc
@author Peruz Carlsen
@createdate 20111002
@description PolicyCoverage entity
*/
component
	persistent="true"
	table="PolicyCoverages"
	datasource="RenaissanceConfig"
	output="false"
{
	// primary key
	property name="policyCoverageID" fieldtype="id" column="policyCoveragesID" generator="native" setter="false";

	// properties
	property name="coverage" ormtype="string" default="";
	property name="shortName" ormtype="string" default="";
	property name="longName" ormtype="string" default="";
	property name="description" ormtype="string" default="";
	property name="policyType" ormtype="short" default="0";
	property name="isLiability" ormtype="short" default="0";
	property name="isClaimCoverage" ormtype="short" default="0";
	property name="displayOrder" ormtype="short" default="0";
	property name="rateDetailCol" ormtype="string" default="";
}