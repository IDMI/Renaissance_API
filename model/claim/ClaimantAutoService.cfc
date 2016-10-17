component extends="coldbox.system.orm.hibernate.VirtualEntityService" singleton {
	public ClaimantAutoService function init() {
		// init super class
		super.init(entityName="ClaimantAuto");
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

		if (structKeyExists(criteria, "claimantID") && isNumeric(criteria.claimantID) && criteria.claimantID) {
			c.isEQ("claimantID", javaCast("int", criteria.claimantID));
		}

		return c.list(sortOrder=sortOrder, offset=offset, max=max, timeout=timeout, ignoreCase=ignoreCase, asQuery=asQuery);
	}
}