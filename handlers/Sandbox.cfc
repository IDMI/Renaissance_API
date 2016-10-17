component
	accessors="true"
	output="true"
{
	property name="dateUtils" inject="model";
	property name="paymentService" inject="model";
	property name="paymentInfoService" inject="model";
	property name="policyService" inject="model";
	property name="wirebox" inject;

	public void function index(event,rc,prc)
		output="true"
	{
		event.paramValue("pw", "test");

		var salt = generateSecretKey("AES");

		saveContent variable="local.contents" {writeOutput("
			<pre>
			remote_add = #cgi.remote_addr#
			salt = #salt#
			pw = #hash(salt & event.getValue("pw"), "SHA-512")#
			</pre>
		");}

		writeOutput(local.contents);
		$abort();
	}

	public void function debug() {
		/*
		var RTRService = getWirebox().getInstance("RTRService");
		var result = RTRService.execute(reReplace('
			<?xml version="1.0" encoding="UTF-8"?>
			<requests>
				<request action="payment">
					<policy id="24796" />
					 <payments>
					 	<payment>
					 		<method>9</method>
					 		<paymentName>Peruz Carlsen</paymentName>
					 		<ccType>3</ccType>
					 		<ccNumber>4012301230123010</ccNumber>
					 		<CVV2>123</CVV2>
					 		<ccExpDate>1212</ccExpDate>
					 		<address1>123 test st</address1>
					 		<city>some city</city>
					 		<state>TN</state>
					 		<zip>37010</zip>
					 		<amount>#randRange(5,20)#</amount>
					 	</payment>
					 </payments>
				</request>
			</requests>
		', "\t|\n|\r|\f", "", "all"));

		$dump(result);
		*/


		/*var policy = getPolicyService().get(18040);
		var payment = getPaymentService().new({
			"method" = 9,
			"amount" = randRange(1, 20),
			"paymentDate" = getDateUtils().formatDateTime(now()),
			"postMarkedDate" = getDateUtils().formatDateTime(now())
		});*/
		/*
		var paymentInfo = getPaymentInfoService().new({
			"paymentName" = "Peruz Carlsen",
			"paymentInfoType" = payment.getMethod(),
			"address1" = "123 test st",
	 		"city" = "some city",
	 		"state" = "TN",
	 		"zip" = "37010",
	 		"bankRoutingNum" = "261072770",
	 		"bankAcctNum" = "243434343"
		});*/
		/*var paymentInfo = getPaymentInfoService().new({
			"paymentName" = "Peruz Carlsen",
			"paymentInfoType" = payment.getMethod(),
			"address1" = "123 test st",
	 		"city" = "some city",
	 		"state" = "TN",
	 		"zip" = "37010",
	 		"ccType" = "3",
	 		"ccNumber" = "4012301230123010",
	 		"ccExpDate" = "12/31/2012",
	 		"CVV2" = "123"
		});

		var result = getPaymentService().sale(policy, payment, paymentInfo);
		$dump(result);*/

		//var result = getPaymentService().sale(getPaymentService().get(5178));
		//$dump(result);
		/*
		var httpService = new http();
		httpService.setURL("http://sterlingapi.local/index.cfm/payment");
		httpService.setMethod("post");
		httpService.addParam(type="header", name="secretKey", value="test");
		httpService.addParam(type="formfield", name="policyID", value="25237");
		httpService.addParam(type="formfield", name="method", value="10");
		httpService.addParam(type="formfield", name="amount", value="2");
		httpService.addParam(type="formfield", name="paymentName", value="Peruz Carlsen");
		httpService.addParam(type="formfield", name="address1", value="123 Test St");
		httpService.addParam(type="formfield", name="city", value="Warner Robins");
		httpService.addParam(type="formfield", name="state", value="GA");
		httpService.addParam(type="formfield", name="zip", value="31088");
		httpService.addParam(type="formfield", name="bankRoutingNum", value="061000052");
		httpService.addParam(type="formfield", name="bankAcctNum", value="12135454545");
		httpService.addParam(type="formfield", name="ccType", value="");
		httpService.addParam(type="formfield", name="ccNumber", value="");
		httpService.addParam(type="formfield", name="ccExpDate", value="");
		httpService.addParam(type="formfield", name="ccSecurity1", value="");

		var prefix = httpService.send().getPrefix();
		var fileContent = toString(prefix.fileContent);

		if (isJSON(fileContent)) {
			fileContent = deserializeJSON(fileContent);
		}

		$dump(fileContent);
		*/

		$abort();
	}
}