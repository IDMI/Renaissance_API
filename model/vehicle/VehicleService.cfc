/**
vehicle/VehicleService.cfc
@author Peruz Carlsen
@createdate 20120307
@hint Vehicle service
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
	public model.vehicle.VehicleService function init() {
		super.init(entityName="Vehicle");

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

		if (structKeyExists(criteria, "policyID") && isNumeric(criteria.policyID) && criteria.policyID) {
			c.isEQ("policyID", javaCast("int", criteria.policyID));
		}

		return c.list(sortOrder=sortOrder, offset=offset, max=max, timeout=timeout, ignoreCase=ignoreCase, asQuery=asQuery);
	}
}