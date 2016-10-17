component extends="coldbox.system.orm.hibernate.VirtualEntityService" singleton {
	public ClaimIncidentService function init() {
		// init super class
		super.init(entityName="ClaimIncident");
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

		if (structKeyExists(criteria, "policyID") && isNumeric(criteria.policyID) && criteria.policyID) {
			c.isEQ("policyID", javaCast("int", criteria.policyID));
		}

		return c.list(sortOrder=sortOrder, offset=offset, max=max, timeout=timeout, ignoreCase=ignoreCase, asQuery=asQuery);
	}

	public void function saveClaimIncident(required claimIncident, boolean forceInsert=false, boolean flush=false, boolean transactional=getUseTransactions()) {
		save(claimIncident, forceInsert, flush, transactional);

		if (claimIncident.getNum() == "TBD") {
			claimIncident.setNum(getClaimNumber(claimIncident));
			save(claimIncident, forceInsert, flush, transactional);
		}
	}

	private string function getClaimNumber(required claimIncident) {
		var storedproc = new storedproc();

		storedproc.setProcedure("GetClaimNumber");
		storedproc.addParam(cfsqltype="cf_sql_integer", type="in", value="#claimIncident.getID()#");
		storedproc.addParam(cfsqltype="cf_sql_integer", type="in", value="#claimIncident.getPolicy().getPolicyID()#");
		storedproc.addParam(cfsqltype="cf_sql_varchar", type="out", variable="claimIncidentNum");

		var result = storedproc.execute();

		return result.getprocOutVariables().claimIncidentNum;
	}

	public struct function getConstraints() {
		return {
			"status" = {
				"required" = true,
				"requiredMessage" = "Status is required",
				"type" = "numeric",
				"typeMessage" = "Status must be numeric"
			},
			"num" = {
				"required" = true,
				"requiredMessage" = "Number name is required"
			},
			"dateOfLoss" = {
				"required" = true,
				"requiredMessage" = "Date of loss is required",
				"type"="date",
				"typeMessage" = "Date of loss is invalid"
			},
			"dateReported" = {
				"required" = true,
				"requiredMessage" = "Date reported is required",
				"type"="date",
				"typeMessage" = "Date reported is invalid"
			},
			"claimCode" = {
				"required" = true,
				"requiredMessage" = "Claim code is required"
			},
			"internalAdjuster" = {
				"required" = true,
				"requiredMessage" = "Internal adjuster is required"
			},
			"policy" = {
				"required" = true,
				"requiredMessage" = "Policy is required"
			},
			"user" = {
				"required" = true,
				"requiredMessage" = "User is required"
			}
		};
	}
}