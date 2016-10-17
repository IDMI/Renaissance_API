/*
model/CoveragePackageDetail.cfc
@author Peruz Carlsen
@createdate 20110929
@description CoveragePackageDetail entity
*/
component
	persistent="true"
	table="CoveragePackageDetail"
	datasource="windhavenInsuredPortal"
	output="false"
{
	// primary key
	property name="coveragePackageDetailID" fieldtype="id" column="coveragePackageDetailID" generator="native" setter="false";

	// properties
	property name="type" ormtype="string" default="";
	property name="name" ormtype="string" default="";
	property name="description" ormtype="string" default="";
	property name="perPerson" ormtype="int" default="0";
	property name="perAccident" ormtype="int" default="0";
	property name="deductible" ormtype="int" default="0";
	property name="useCoverage" ormtype="short" default="1";
	property name="active" ormtype="short" default="1";
	property name="sortOrder" ormtype="short" default="1";
	property name="addDate" ormtype="timestamp" setter="false" insert="false" update="false";
	property name="limit1" persistent="false";
	property name="limit2" persistent="false";

	// relations
	property name="coveragePackage" fieldtype="many-to-one" fkcolumn="coveragePackageID" cfc="model.insuredPortal.coveragePackage.CoveragePackage" inverse="true" lazy="true";

	public function getLimit1()
		output="false"
	{
		return getPerPerson();
	}

	public function getLimit2()
		output="false"
	{
		return getPerAccident();
	}
}