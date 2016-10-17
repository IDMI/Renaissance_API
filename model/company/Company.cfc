/*
model/Company.cfc
@author Peruz Carlsen
@createdate 20110618
@description Company entity
*/
component
	persistent="true"
	table="Company"
	output="false"
{
	// primary key
	property name="companyID" fieldtype="id" column="companyID" generator="native" setter="false";

	// properties
	property name="companyName" ormtype="string";
	property name="carrierName" ormtype="string";
	property name="address1" ormtype="string";
	property name="address2" ormtype="string";
	property name="city" ormtype="string";
	property name="state" ormtype="string";
	property name="zip" ormtype="string";
	property name="phone" ormtype="string";
	property name="phone2" ormtype="string";
	property name="fax" ormtype="string";
	property name="tollFree" ormtype="string";

	// relations
	property name="financials" fieldtype="one-to-many" fkcolumn="companyID" cfc="model.companyFinancial.CompanyFinancial" singularname="financial" cascade="all-delete-orphan" lazy="extra";
}