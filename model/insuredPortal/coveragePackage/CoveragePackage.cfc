/*
model/CoveragePackage.cfc
@author Peruz Carlsen
@createdate 20110929
@description CoveragePackage entity
*/
component
	persistent="true"
	table="CoveragePackage"
	datasource="RenaissanceInsuredPortal"
	output="false"
{
	// primary key
	property name="coveragePackageID" fieldtype="id" column="coveragePackageID" generator="native" setter="false";

	// properties
	property name="companyID" ormtype="int" default="0";
	property name="stateID" ormtype="int" default="0";
	property name="policyType" ormtype="short" default="0";
	property name="name" ormtype="string" default="";
	property name="description" ormtype="string" default="";
	property name="startDate" ormtype="timestamp";
	property name="endDate" ormtype="timestamp";
	property name="active" ormtype="short" default="1";
	property name="sortOrder" ormtype="short" default="1";
	property name="IDMIname" ormtype="string" default="";

	// relations
	property name="details" fieldtype="one-to-many" fkcolumn="coveragePackageID" cfc="model.insuredPortal.coveragePackageDetail.CoveragePackageDetail" singularname="detail" lazy="extra" cascade="all-delete-orphan" where="active=1 AND useCoverage=1" orderby="sortOrder";
}