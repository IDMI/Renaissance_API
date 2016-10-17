/**
rate/autoViolationCharge/AutoViolationChargeService.cfc
@author Peruz Carlsen
@createdate 20120307
@hint Auto violation charge service
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
	public model.rate.autoViolationCharge.AutoViolationChargeService function init() {
		super.init(entityName="AutoViolationCharge");

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

		if (structKeyExists(criteria, "ratingVersionID") && isNumeric(criteria.ratingVersionID) && criteria.ratingVersionID) {
			c.isEQ("ratingVersionID", javaCast("int", criteria.ratingVersionID));
		}

		return c.list(sortOrder=sortOrder, offset=offset, max=max, timeout=timeout, ignoreCase=ignoreCase, asQuery=asQuery);
	}
}