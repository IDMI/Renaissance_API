/**
security/SecurityService.cfc
@author Peruz Carlsen
@createdate 20120307
@hint Security service
@output false
**/
component
	accessors="true"
{
	/**
    @author Peruz Carlsen
    @createdate 20120307
    @hint Constructor
    @output false
    **/
    public model.security.SecurityService function init() {
    	return this;
    }

    /**
    @author Peruz Carlsen
    @createdate 20120307
    @hint Validates the user against predefined security rules
    @output false
    **/
	public boolean function userValidator(required struct rule, required any messageBox, required any controller) {
		var httpRequest = getHTTPRequestData();
		var remoteAddress = getRemoteAddress();

		// exit if localhost
		if (remoteAddress == "127.0.0.1") return true;

		// check SSL
		if (arguments.controller.getSetting("requiresSSL", false, true) &&
			!cgi.server_port_secure)
		{
			return false;
		}

		// check for existance of secretKey in header
		if (!structKeyExists(httpRequest.headers, "secretKey")) {
			return false;
		}

		var secretKey = trim(structFind(httpRequest.headers, "secretKey"));
		var queryService = new Query();

		queryService.addParam(name="ipAddress", value=remoteAddress, cfsqltype="cf_sql_varchar");
		queryService.addParam(name="active", value=1, cfsqltype="cf_sql_tinyint", list=true);
		queryService.setSQL("SELECT secretKey, salt FROM APIUser WHERE ipAddress = :ipAddress AND active IN (:active)");

		var apiUser = queryService.execute().getResult();

		// check for existance api usage registration
		if (apiUser.recordCount != 1) {
			return false;
		}

		// check for secretKey value
		if (hash(apiUser.salt & secretKey, "SHA-512") != apiUser.secretKey) {
			return false;
		}

		return true;
	}

	/**
    @author Peruz Carlsen
    @createdate 20120307
    @hint Returns remove address
    @output false
    **/
	private string function getRemoteAddress() {
		var headers = structFind(getHTTPRequestData(), "headers");
		var remoteAddress = cgi.remote_addr;

		if (structKeyExists(headers, "X-Forwarded-For")) {
			remoteAddress = structFind(headers, "X-Forwarded-For");
		}

		return remoteAddress;
	}
}