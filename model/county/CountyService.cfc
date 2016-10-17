/**
county/CountyService.cfc
@author Peruz Carlsen
@createdate 20120307
@hint County service
@output false
**/
component
	extends="coldbox.system.orm.hibernate.VirtualEntityService"
	singleton
{
	/**
    @author Peruz Carlsen
    @createdate 20120307
    @hint constructor
    @output false
    **/
	public model.county.CountyService function init() {
		super.init(entityName="County");

		return this;
	}

	public any function list(
		struct criteria=structnew(),
  		string sortOrder="",
  		numeric offset=0,
  		numeric max=0,
  		numeric timeout=0,
  		boolean ignoreCase=false,
  		boolean asQuery=getDefaultAsQuery())
	{
		var c = newCriteria();

		if (structKeyExists(criteria, "stateID") && isNumeric(criteria.stateID) && criteria.stateID) {
			c.isEQ("stateID", javaCast("int", criteria.stateID));
		}

		if (structKeyExists(criteria, "stateShort") && len(trim(criteria.stateShort))) {
			c.isEQ("stateShort", javaCast("string", criteria.stateShort));
		}

		return c.list(sortOrder=sortOrder, offset=offset, max=max, timeout=timeout, ignoreCase=ignoreCase, asQuery=asQuery);
	}
}