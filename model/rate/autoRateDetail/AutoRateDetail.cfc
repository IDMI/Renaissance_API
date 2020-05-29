/*
beans/AutoRateDetail.cfc
@author Peruz Carlsen
@createdate 20120209
@description AutoRateDetail entity
*/
component
	persistent="true"
	table="AutoRateDetail"
	datasource="RenaissanceRate"
	output="false"
{
	// primary key
	property name="autoRateDetailID" fieldtype="id" column="autoRateDetailID" generator="native" setter="false";

	// properties
	property name="policyID" column="policyID" type="numeric" ormtype="int" default="1";
	property name="policyRateDetailID" column="policyRateDetailID" type="numeric" ormtype="int" default="1";
	property name="description" column="description" type="string" ormtype="string" default="";
	property name="vehicleNum" column="vehicleNum" type="numeric" ormtype="short" default="0";
	property name="itemCategory" column="itemCategory" type="numeric" ormtype="short" default="1";
}