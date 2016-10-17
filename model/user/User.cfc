/*
model/Users.cfc
@author Peruz Carlsen
@createdate 20110618
@description Users entity
*/
component
	persistent="true"
	table="Users"
	output="false"
{
	// primary key
	property name="userID" fieldtype="id" column="usersID" generator="native" setter="false";

	// properties
	property name="fname" ormtype="string" default="";
	property name="middle" ormtype="string" default="";
	property name="lname" ormtype="string" default="";
	property name="username" ormtype="string" default="";
	property name="password" ormtype="string" default="";
	property name="userDatabase" ormtype="string" default="";
	property name="userDSN" ormtype="string" default="";
	property name="userType" ormtype="short" default="0";
	property name="phone" ormtype="string" default="";
	property name="email" ormtype="string" default="";
	property name="range" ormtype="string" default="";
	property name="lastLogin" ormtype="timestamp";
	property name="adjusterID" ormtype="int" default="1";
	property name="producerID" ormtype="int" default="1";
	property name="active" ormtype="short" default="1";

	public string function getFullName() {
		return getFname() & (len(trim(getMiddle())) ? " " & getMiddle() : "" ) & " " & getLname();
	}
}