/**
********************************************************************************
Copyright Since 2005 ColdBox Framework by Luis Majano and Ortus Solutions, Corp
www.coldbox.org | www.luismajano.com | www.ortussolutions.com
********************************************************************************

Author     :	Luis Majano
Date        :	10/16/2007
Description :
	A ColdBox Enabled Hibernate Event Handler that ties to the ColdBox proxy for ColdBox Operations.

*/
component
	extends="coldbox.system.orm.hibernate.EventHandler"
{
	/**
	@output false
	**/
	public void function preInsert(entity) {
		try { entity.setAddDate(now()); } catch (any e) { }
		try { entity.setModifiedDate(now()); } catch (any e) { }
	}

	/**
	@output false
	**/
	public void function preUpdate(entity) {
		try { entity.setModifiedDate(now()); } catch (any e) { }
	}
}