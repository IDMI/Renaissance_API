/*
beans/IVRConfigClient.cfc
@author Peruz Carlsen
@createdate 20120110
@description IVR_Config_Client entity
*/
component
	persistent="true"
	table="IVR_Config_Client"
	output="false"
{
	// primary key
	property name="IVRConfigClientID" column="IVR_Config_ClientID" type="numeric" ormtype="int" fieldtype="id" generator="native" setter="false";

	// properties
	property name="PTSIdentifier" column="PTSIdentifier" type="string" ormtype="string" default="";
	property name="creditCardFee" column="creditCardFee" type="numeric" ormtype="float" default="0";
	property name="eCheckFee" column="eCheckFee" type="numeric" ormtype="float" default="0";
	property name="clientName" column="clientName" type="string" ormtype="string" default="";
	property name="PTSName" column="PTSName" type="string" ormtype="string" default="";
	property name="paymentCategory" column="paymentCategory" type="numeric" ormtype="int" default="0";

	// relations
	property name="company" fieldtype="many-to-one" fkcolumn="companyID" cfc="model.company.Company" inverse="true" missingrowignored="true";
	property name="state" fieldtype="many-to-one" fkcolumn="stateID" cfc="model.state.State" inverse="true" missingrowignored="true";
}