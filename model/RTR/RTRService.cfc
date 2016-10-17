component
	accessors="true"
	output="false"
{
	property name="Conversions" inject="model";
	property name="policyService" inject="model";
	property name="policyTypeService" inject="model";
	property name="wirebox" inject;

	public model.RTR.RTRService function init()
		output="false"
	{
		return this;
	}

	public array function execute(required any data)
		output="false"
	{
		var newData = getConversions().toStruct(arguments.data);
		var results = [];

		if (structIsEmpty(newData)) {
			return results;
		}

		var requests = !isArray(newData.requests.request)?[newData.requests.request]:newData.requests.request;

		for (var i=1;i<=arrayLen(requests);i++) {
			var request = requests[i];
			var policyData = request.policy;
			var policyType = getPolicyTypeValue(policyData);

			if (isNull(policyType)) {
				arrayAppend(results, "Unable to determine policy's line of business");
				continue;
			}

			if (policyType == application.constants.policyType.pAuto) {
				arrayAppend(results, getWirebox().getInstance("RTRPAutoService").execute(request));
			} else {
				arrayAppend(results, "RTR is not supported for policy's line of business");
			}
		}

		return results;
	}

	private any function getPolicyTypeValue(required struct policyData)
		output="false"
	{
		if (structKeyExists(arguments.policyData.attributes, "id") &&
			isNumeric(structFind(arguments.policyData.attributes, "id")) &&
			structFind(arguments.policyData.attributes, "id") > 1)
		{
			var policy = getPolicyService().findWhere({"policyID"=structFind(arguments.policyData.attributes, "id")});

			if (structKeyExists(local, "policy")) {
				return policy.getPolicyType();
			}
		}

		if (structKeyExists(arguments.policyData, "policyType")) {
			var policyType = getPolicyTypeService().findWhere({"policyType"=arguments.policyData.policyType.text});

			if (structKeyExists(local, "policyType")) {
				return policyType.getPolicyType();
			}
		}

		if (structKeyExists(arguments.policyData, "policyTypeDesc")) {
			var policyType = getPolicyTypeService().findWhere({"policyType"=arguments.policyData.policyTypeDesc.text});

			if (structKeyExists(local, "policyType")) {
				return policyType.getPolicyType();
			}
		}

		return 0;
	}
}