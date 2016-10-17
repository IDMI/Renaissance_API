component extends="coldbox.system.orm.hibernate.VirtualEntityService" singleton {
	public NoteService function init() {
		// init super class
		super.init(entityName="Note");
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

		if (structKeyExists(criteria, "policyID") && isNumeric(criteria.policyID) && criteria.policyID) {
			c.isEQ("policyID", javaCast("int", criteria.policyID));
		}

		return c.list(sortOrder=sortOrder, offset=offset, max=max, timeout=timeout, ignoreCase=ignoreCase, asQuery=asQuery);
	}
}