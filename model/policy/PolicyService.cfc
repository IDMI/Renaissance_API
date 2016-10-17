/**
policy/PolicyService.cfc
@author Peruz Carlsen
@createdate 20120307
@hint Policy service
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
	public model.policy.PolicyService function init() {
		super.init(entityName="Policy");

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

		if (structKeyExists(criteria, "insuredID") && isNumeric(criteria.insuredID) && criteria.insuredID) {
			c.isEQ("insuredID", javaCast("int", criteria.insuredID));
		}

		if (structKeyExists(criteria, "producerID") && isNumeric(criteria.producerID) && criteria.producerID) {
			c.isEQ("producerID", javaCast("int", criteria.producerID));
		}

		if (structKeyExists(criteria, "status") && isNumeric(criteria.status) && criteria.status) {
			c.isEQ("status", javaCast("short", criteria.status));
		}

		if (structKeyExists(criteria, "policyType") && isNumeric(criteria.policyType) && criteria.policyType) {
			c.isEQ("policyType", javaCast("short", criteria.policyType));
		}

		if (structKeyExists(criteria, "policyTerm") && isNumeric(criteria.policyTerm) && criteria.policyTerm) {
			c.isEQ("policyTerm", javaCast("short", criteria.policyTerm));
		}

		return c.list(sortOrder=sortOrder, offset=offset, max=max, timeout=timeout, ignoreCase=ignoreCase, asQuery=asQuery);
	}
}