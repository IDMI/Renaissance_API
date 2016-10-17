/*
model/Insured.cfc
@author Peruz Carlsen
@createdate 20110618
@description Insured entity
*/
component
	persistent="true"
	table="Insured"
	output="false"
{
	// primary key
	property name="insuredID" fieldtype="id" column="insuredID" generator="native" setter="false";

	// properties
	property name="insuredName" ormtype="string";
	property name="fname1" ormtype="string" default="";
	property name="middle1" ormtype="string" default="";
	property name="lname1" ormtype="string" default="";
	property name="fname2" ormtype="string" default="";
	property name="middle2" ormtype="string" default="";
	property name="lname2" ormtype="string" default="";
	property name="address1" ormtype="string" default="";
	property name="address2" ormtype="string" default="";
	property name="city" ormtype="string" default="";
	property name="state" ormtype="string" default="";
	property name="zip" ormtype="string" default="";
	property name="county" ormtype="string" default="";
	property name="phone" ormtype="string" default="";
	property name="phone2" ormtype="string" default="";
	property name="fax" ormtype="string" default="";
	property name="tollFree" ormtype="string" default="";
	property name="pager" ormtype="string" default="";
	property name="email" ormtype="string" default="";
	property name="creditScore" ormtype="short" default="0";
	property name="businessType" ormtype="short" type="numeric" default="0";

	public string function getFullName1() {
		if (getBusinessType() == 1) {
			return getInsuredName();
		}

		return getFname1() & (len(trim(getMiddle1())) ? " " & getMiddle1() : "" ) & " " & getLname1();
	}

	public string function getFullName2() {
		if (getBusinessType() == 1) {
			return getInsuredName();
		}

		return getFname2() & (len(trim(getMiddle2())) ? " " & getMiddle2() : "" ) & " " & getLname2();
	}
}