# windhaven_API

To set up the API site:

1. Follow the normal documentation to create the local site (https://www.ourvolaris.com/sites/Silvervine/DEV/Technical%20Documentation/How%20to%20Create%20a%20Local.aspx).
2. Name it windhaven.api.local in IIS/hosts file for consistency among workstations and compatibility with what is set by default in the Windhaven_Insured repo.
3. There are no local settings for it.



To test that it's working:
1. Make an insured web account locally in the PTS with your email.
2. Log into your local insured web site.
	* If at any point you need to adjust your local settings in the insured web, make sure you run http://windhaven.insured.local?init=8899 to reinitialize the application scope variables.
	* Be mindful of the "application.api" in local settings for your local API url.  Sample insured web local settings:
```
<cfscript>
	application.PTSSystem = "local";
	application.protocol = "http";
	application.MainPassword = "all41";
	application.BATCH_DIR = "d:\pts\documents";
	application.ptsUrl = "http://#application.PTSname#.local";
	// API
	application.api = {
		"url" = "http://windhaven.api.local/index.cfm",
		"secretKey" = "G^02z0C"
	};
	application.remoteWSDL = "#application.ptsURL#/service/external/insured/Remote.cfc?wsdl";
</cfscript>
```

3. Attempt to make a credit card payment.  Test info for ECS:
VISA 4111111111111111 Exp: 10/25 CVV2: 123
4. If you get "Element MESSAGE.RESPONSE is undefined in VALIDATERESPONSE." on /payments/paymentError", it means Unexpected resultConnection Failure.  This is the error that is generated when it can't find a matching payment gateway to use.
	* In your local CFADMIN, check Log Files > http.log to see which URL is being used.
	* If you see "Starting HTTP request {URL='http://no.valid.url.specified', method='POST'}", this is the problem.
	* Make sure your PTS local settings contain the gateway creds:
```
	application.gatewayCreds = {
		"NLR" = {
				transURL = "https://secure.networkmerchants.com/api/transact.php",
				queryURL = "https://secure.networkmerchants.com/api/query.php",
				username = "demo",
				password = "password"
		},
		"NLR.Main" = {
			transURL = "https://secure.networkmerchants.com/api/transact.php",
			queryURL = "https://secure.networkmerchants.com/api/query.php",
			username = "demo",
			password = "password"
		},
		"NLR.Envoy" = {
			transURL = "https://secure.networkmerchants.com/api/transact.php",
			queryURL = "https://secure.networkmerchants.com/api/query.php",
			username = "demo",
			password = "password"
		},
		"CNB.FL.Main" = {
			transURL = "https://secure.networkmerchants.com/api/transact.php",
			queryURL = "https://secure.networkmerchants.com/api/query.php",
			username = "demo",
			password = "password"
		}
		/* add additional merchants here as needed:
		,
		"other" = {
				transURL = "https://URL_HERE",
				queryURL = "https://URL_HERE",
				username = "demo",
				password = "password"
		}
		*/
	};
  ```
  
	5. Then try to make another payment in the insured web.  If you can make a credit card payment through your local insured web connected to your local PTS and local API, it means everything is working as it should.
