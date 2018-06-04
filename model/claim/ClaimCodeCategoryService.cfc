component extends="coldbox.system.orm.hibernate.VirtualEntityService" singleton {
	public ClaimCodeCategoryService function init() {
		// init super class
		super.init(entityName="ClaimCodeCategory");
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

		if (structKeyExists(criteria, "parentID") && isNumeric(criteria.parentID) && criteria.parentID) {
			c.isEQ("parentID", javaCast("int", criteria.parentID));
		}

		if (structKeyExists(criteria, "hasParent") && isBoolean(criteria.hasParent)) {
			if (criteria.hasParent) {
				c.isNotNull("parentID");
			} else {
				c.isNull("parentID");
			}
		}

		if (structKeyExists(criteria, "isActive") && isNumeric(criteria.isActive) && isNumeric(criteria.isActive)) {
			c.isEQ("isActive", javaCast("boolean", criteria.isActive));
		}

		if (structKeyExists(criteria, "policyType") && isNumeric(criteria.policyType) && criteria.policyType) {
			c.isEQ("policyType", javaCast("int", criteria.policyType));
		}

		return c.list(sortOrder=sortOrder, offset=offset, max=max, timeout=timeout, ignoreCase=ignoreCase, asQuery=asQuery);
	}
}