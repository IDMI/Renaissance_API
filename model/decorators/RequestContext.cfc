/**
decorators/RequestContext.cfc
@author Peruz Carlsen
@createdate 20121205
@hint Custom request context decorator
**/
component output="false" accessors="true" extends="coldbox.system.web.context.RequestContextDecorator" {
	public void function configure() {
		var rc = getRequestContext().getCollection();
		var requestBody = toString(getHttpRequestData().content);

		if (isJSON(requestBody)) {
			structAppend(rc, deserializeJSON(requestBody), true);
		}

		for (var key in rc) {
			if (arrayFindNoCase(["event"], key)) {
				continue;
			}

			if (structKeyExists(rc, key) &&
				isSimpleValue(rc[key]))
			{
				rc[key] = trim(rc[key]);
			}
		}
	}
}