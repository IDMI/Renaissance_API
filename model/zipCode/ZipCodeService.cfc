/**
zipCode/ZipCodeService.cfc
@author Peruz Carlsen
@createdate 20120307
@hint Zip code service
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
	public model.zipCode.ZipCodeService function init() {
		super.init(entityName="ZipCode");

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

		if (structKeyExists(criteria, "zipCode") && len(trim(criteria.zipCode))) {
			c.isEQ("zipCode", javaCast("string", criteria.zipCode));
		}

		return c.list(sortOrder=sortOrder, offset=offset, max=max, timeout=timeout, ignoreCase=ignoreCase, asQuery=asQuery);
	}
}