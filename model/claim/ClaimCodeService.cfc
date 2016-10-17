component extends="coldbox.system.orm.hibernate.VirtualEntityService" singleton {
	public ClaimCodeService function init() {
		// init super class
		super.init(entityName="ClaimCode");
		// Use Query Caching
	    setUseQueryCaching( true );
	    // Query Cache Region
	    setQueryCacheRegion( 'ORMService.defaultCache' );
	    // EventHandling
	    setEventHandling( true );

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

		if (structKeyExists(criteria, "claimCodeCategoryID") && isNumeric(criteria.claimCodeCategoryID) && criteria.claimCodeCategoryID) {
			c.isEQ("claimCodeCategoryID", javaCast("int", criteria.claimCodeCategoryID));
		}

		if (structKeyExists(criteria, "policyType") && isNumeric(criteria.policyType) && criteria.policyType) {
			c.isEQ("policyType", javaCast("short", criteria.policyType));
		}

		return c.list(sortOrder=sortOrder, offset=offset, max=max, timeout=timeout, ignoreCase=ignoreCase, asQuery=asQuery);
	}
}