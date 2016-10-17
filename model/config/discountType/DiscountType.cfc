/*
model/DiscountType.cfc
@author Peruz Carlsen
@createdate 20111003
@description DiscountType entity
*/
component
	persistent="true"
	table="DiscountTypes"
	datasource="windhavenConfig"
	output="false"
{
	// primary key
	property name="discountTypeID" fieldtype="id" column="discountTypesID" generator="native" setter="false";

	// properties
	property name="description" ormtype="string" default="";
	property name="discountMask" ormtype="int" default="0";
	property name="type" ormtype="string" default="";
}