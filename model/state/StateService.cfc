/**
state/StateService.cfc
@author Peruz Carlsen
@createdate 20120307
@hint State service
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
	public model.state.StateService function init() {
		super.init(entityName="State");

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

		if (structKeyExists(criteria, "country") && len(trim(criteria.country))) {
			c.isEQ("country", javaCast("string", criteria.country));
		}

		if (structKeyExists(criteria, "stateShort") && len(trim(criteria.stateShort))) {
			c.isEQ("stateShort", javaCast("string", criteria.stateShort));
		}

		if (structKeyExists(criteria, "stateLong") && len(trim(criteria.stateLong))) {
			c.isEQ("stateLong", javaCast("string", criteria.stateLong));
		}

		if (structKeyExists(criteria, "active") && isNumeric(criteria.active)) {
			c.isEQ("active", javaCast("short", criteria.active));
		}

		return c.list(sortOrder=sortOrder, offset=offset, max=max, timeout=timeout, ignoreCase=ignoreCase, asQuery=asQuery);
	}
}