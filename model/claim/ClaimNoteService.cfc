component extends="coldbox.system.orm.hibernate.VirtualEntityService" singleton {
	public ClaimNoteService function init() {
		// init super class
		super.init(entityName="ClaimNote");
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

		if (structKeyExists(criteria, "claimIncidentID") && isNumeric(criteria.claimIncidentID) && criteria.claimIncidentID) {
			c.isEQ("claimIncidentID", javaCast("int", criteria.claimIncidentID));
		}

		if (structKeyExists(criteria, "type") && len(trim(criteria.type))) {
			c.isEQ("type", javaCast("string", criteria.type));
		}

		return c.list(sortOrder=sortOrder, offset=offset, max=max, timeout=timeout, ignoreCase=ignoreCase, asQuery=asQuery);
	}
}