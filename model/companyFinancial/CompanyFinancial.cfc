/*
model/CompanyFinancial.cfc
@author Peruz Carlsen
@createdate 20111004
@description CompanyFinancial entity
*/
component
	persistent="true"
	table="CompanyFinancials"
	output="false"
{
	// primary key
	property name="companyFinancialID" fieldtype="id" column="companyFinancialsID" generator="native" setter="false";

	// Properties
	property name="ratingVersionID" ormtype="int" default="0";
	property name="policyTerm" ormtype="short" default="0";
	property name="description" ormtype="string" default="";
	property name="policyCharge" ormtype="float" default="0";
	property name="renewalPolicyCharge" ormtype="float" default="0";
	property name="SR22Fee" ormtype="float" default="0";

	// relations
	property name="company" fieldtype="many-to-one" fkcolumn="companyID" cfc="model.company.Company" lazy="true" inverse="true";
}