/**
insuredPortal/CoveragePackage/CoveragePackageService.cfc
@author Peruz Carlsen
@createdate 20120307
@hint Coverage package service
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
	public model.insuredPortal.coveragePackage.CoveragePackageService function init() {
		super.init(entityName="CoveragePackage");

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

		if (structKeyExists(criteria, "companyID") && isNumeric(criteria.companyID) && criteria.companyID) {
			c.isEQ("companyID", javaCast("int", criteria.companyID));
		}

		if (structKeyExists(criteria, "stateID") && isNumeric(criteria.stateID) && criteria.stateID) {
			c.isEQ("stateID", javaCast("int", criteria.stateID));
		}

		if (structKeyExists(criteria, "policyType") && isNumeric(criteria.policyType) && criteria.policyType) {
			c.isEQ("policyType", javaCast("short", criteria.policyType));
		}

		return c.list(sortOrder=sortOrder, offset=offset, max=max, timeout=timeout, ignoreCase=ignoreCase, asQuery=asQuery);
	}
}