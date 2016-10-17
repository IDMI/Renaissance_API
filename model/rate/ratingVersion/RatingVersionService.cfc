/**
rate/ratingVersion/RatingVersionService.cfc
@author Peruz Carlsen
@createdate 20120307
@hint Rating version service
@output false
**/
component
	extends="coldbox.system.orm.hibernate.VirtualEntityService"
	accessors="true"
	singleton
{
	/**
    @author Peruz Carlsen
    @createdate 20120307
    @hint constructor
    @output false
    **/
	public model.rate.ratingVersion.RatingVersionService function init() {
		super.init(entityName="RatingVersion");

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

		if (structKeyExists(criteria, "ratingGroupID") && isNumeric(criteria.ratingGroupID) && criteria.ratingGroupID) {
			c.isEQ("ratingGroupID", javaCast("int", criteria.ratingGroupID));
		}

		if (structKeyExists(criteria, "isRenewal") && isNumeric(criteria.isRenewal) &&
			structKeyExists(criteria, "effectiveDate") && isDate(criteria.effectiveDate))
		{
			if (criteria.isRenewal == 0) {
				c.le("newBusinessDate", createODBCDate(criteria.effectiveDate));
				c.or(
					c.restrictions.isNull("stopNewDate"),
					c.restrictions.gt("stopNewDate", createODBCDate(criteria.effectiveDate))
				);
			} else {
				c.le("renewalBusinessDate", createODBCDate(criteria.effectiveDate));
				c.or(
					c.restrictions.isNull("stopRenewalDate"),
					c.restrictions.gt("stopRenewalDate", createODBCDate(criteria.effectiveDate))
				);
			}
		}

		return c.list(sortOrder=sortOrder, offset=offset, max=max, timeout=timeout, ignoreCase=ignoreCase, asQuery=asQuery);
	}
}