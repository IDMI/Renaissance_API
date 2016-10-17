component
	extends="Base"
	accessors="true"
	output="false"
{
	property name="dateUtils" inject="model";
	property name="paymentService" inject="model";
	property name="paymentInfoService" inject="model";
	property name="policyService" inject="model";

	public void function create(event,rc,prc) {
		event.paramValue("method", 0);
		event.paramValue("ccType", 0);
		event.paramValue("paymentInfoType", event.getValue("method"));
		event.paramValue("paymentDate", getDateUtils().formatDateTime(now()));
		event.paramValue("postMarkedDate", getDateUtils().formatDateTime(now()));
		event.setValue("ccType", isNumeric(event.getValue("ccType"))?event.getValue("ccType"):0);

		var policy = getPolicyService().get(event.getValue("policyID"));
		var payment = populateModel(getPaymentService().new());
		var paymentInfo = populateModel(getPaymentInfoService().new());
		var errors = {};

		// validate payment
		var results = validateModel(target=payment);
		if (results.hasErrors()) {
			structInsert(errors, "payment", results.getAllErrors());
		}

		// validate paymentInfo
		var constraints = structKeyExists(paymentInfo, "constraints")?duplicate(structFind(paymentInfo, "constraints")):{};
		if (payment.getMethod() == application.constants.payment.method.creditCard) {
			structAppend(constraints, {
				"ccType" = {"required" = true, type="integer", inList="1,2,3,4"},
				"ccNumber" = {"required" = true, type="creditcard"},
				"ccExpDate" = {"required" = true, regex="^((\d{4})|(\d{2}\/\d{2})|(\d{2}\/\d{4})|(\d{2}\/\d{2}\/\d{4}))$"},
				"ccSecurity1" = {"required" = true, type="integer", regex="^\d{3,4}$"}
			});
		} else if (payment.getMethod() == application.constants.payment.method.bankDraft) {
			structAppend(constraints, {
				"bankRoutingNum" = {"required" = true, validator="BankRoutingNumber"},
				"bankAcctNum" = {"required" = true, regex="^\d{1,25}$"}
			});
		}

		var results = validateModel(target=paymentInfo, constraints=constraints);
		if (results.hasErrors()) {
			structInsert(errors, "paymentInfo", results.getAllErrors());
		}

		// validation check
		if (!structIsEmpty(errors)) {
			prc.data.error = true;
			prc.data.message = "Invalid or missing data";
			prc.data.detail = errors;
		} else {
			if (len(trim(paymentInfo.getCCExpDate()))) {
				paymentInfo.setCCExpDate(getDateUtils().formatDate(createDate(right(trim(paymentInfo.getCCExpDate()), 2), left(trim(paymentInfo.getCCExpDate()), 2), daysInMonth(createDate(right(trim(paymentInfo.getCCExpDate()), 2), left(trim(paymentInfo.getCCExpDate()), 2), 1)))));
			}

			prc.data.message = getPaymentService().sale(policy, payment, paymentInfo);
		}
	}
}