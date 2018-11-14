/*
model/Policy.cfc
@author Peruz Carlsen
@createdate 20110618
@description Policy entity
*/
component
	persistent="true"
	table="Policy"
	output="false"
{
	// primary key
	property name="policyID" fieldtype="id" column="policyID" generator="native" setter="false";

	// properties
	property name="companyID" ormtype="int" type="numeric" insert="false" update="false";
	property name="insuredID" ormtype="int" type="numeric" insert="false" update="false";
	property name="producerID" ormtype="int" type="numeric" insert="false" update="false";
	property name="stateID" ormtype="int" type="numeric" insert="false" update="false";
	property name="policyNum" ormtype="string";
	property name="policyType" ormtype="short" default="0";
	property name="status" ormtype="short" default="0";
	property name="effectiveDate" ormtype="timestamp";
	property name="expirationDate" ormtype="timestamp";
	property name="cancelledDate" ormtype="timestamp";
	property name="endorsementDate" ormtype="timestamp";
	property name="policyTerm" ormtype="short" default="0";
	property name="isRenewal" ormtype="short" default="0";
	property name="renewalCount" ormtype="short" default="0";
	property name="premiumTotal" ormtype="float" default="0";
	property name="termPremiumsDue" ormtype="float" default="0";
	property name="ratingGroupID" ormtype="int" default="0";
	property name="ratingVersionID" ormtype="int" default="0";
	property name="ratingVersion" ormtype="float" default="0";
	property name="depositPercent" ormtype="float" default="100";
	property name="installmentCount" ormtype="short" default="0";
	property name="policyCharge" ormtype="float" default="0";
	property name="needsRated" ormtype="short" default="0";
	property name="forceLogEntry" ormtype="short" default="0";
	property name="endorsementDescription" ormtype="string" default="";
	property name="checkReinstatement" ormtype="short" default="0";
	property name="cancelledReason" ormtype="short" default="0";
	property name="isDirect" ormtype="short" default="0";
	property name="companyName" generated="never" insert="false" update="false" persistent="false";
	property name="paymentPlanName" generated="never" insert="false" update="false" persistent="false";
	property name="policyTypeDesc" generated="never" insert="false" update="false" persistent="false";

	// collections
	property name="underwritingCollection" generated="never" insert="false" update="false" persistent="false";
	property name="discountCollection" fieldtype="collection" fkcolumn="policyID" elementcolumn="description" table="PolicyDiscounts";
	property name="surchargeCollection" fieldtype="collection" fkcolumn="policyID" elementcolumn="description" table="PolicySurcharges";

	// relations
	property name="agencyFees" fieldtype="one-to-many" fkcolumn="policyID" cfc="model.agencyFee.AgencyFee" singularname="agencyFee" cascade="all-delete-orphan";
	property name="appQuestionResponses" fieldtype="one-to-many" fkcolumn="policyID" cfc="model.appQuestionResponse.AppQuestionResponse" singularname="appQuestionResponse" cascade="all-delete-orphan" lazy="extra";
	property name="AR" fieldtype="one-to-many" fkcolumn="policyID" cfc="model.ar.AR" orderby="arDate, arType" cascade="all-delete-orphan" lazy="extra";
	property name="attachments" fieldtype="one-to-many" cfc="model.attachment.Attachment" fkcolumn="policyID" singularname="attachment" inverse="true" cascade="save-update";
	property name="claimIncidents" fieldtype="one-to-many" cfc="model.claim.ClaimIncident" fkcolumn="policyID" singularname="claimIncident" inverse="true" cascade="save-update";
	property name="company" fieldtype="many-to-one" fkcolumn="companyID" cfc="model.company.Company" lazy="true" inverse="true";
	property name="discounts" fieldtype="one-to-many" fkcolumn="parentID" joincolumn="policyID" where="parentTable='Policy'" cfc="model.discount.PolicyDiscount" singularname="discount" cascade="all-delete-orphan" lazy="extra";
	property name="insured" fieldtype="many-to-one" fkcolumn="insuredID" cfc="model.insured.Insured" cascade="save-update" lazy="true" inverse="true";
	property name="IVRPayments" fieldtype="one-to-many" fkcolumn="policyID" cfc="model.IVRPayment.IVRPayment" singularname="IVRPayment" cascade="all-delete-orphan";
	property name="lienholders" fieldtype="one-to-many" fkcolumn="policyID" cfc="model.lienholder.Lienholder" singularname="lienholder" cascade="save-update" lazy="extra";
	property name="notes" fieldtype="one-to-many" fkcolumn="policyID" cfc="model.note.Note" singularname="note" cascade="all-delete-orphan" lazy="extra";
	property name="paymentInfos" fieldtype="one-to-many" fkcolumn="policyID" cfc="model.paymentInfo.PaymentInfo" singularname="paymentInfo" cascade="all-delete-orphan";
	property name="paymentPlan" fieldtype="many-to-one" fkcolumn="paymentPlanID" cfc="model.paymentPlan.PaymentPlan" missingrowignored="true";
	property name="payments" fieldtype="one-to-many" fkcolumn="policyID" cfc="model.payment.Payment" singularname="payment" orderby="paymentDate, paymentID" cascade="all-delete-orphan";
	property name="producer" fieldtype="many-to-one" fkcolumn="producerID" cfc="model.producer.Producer" cascade="save-update" lazy="true" inverse="true";
	property name="state" fieldtype="many-to-one" fkcolumn="stateID" cfc="model.state.State" lazy="true" inverse="true";

	public numeric function getPolicyChargeDeposit()
		output="false"
	{
		if (isNull(getPaymentPlan()) || isNull(getPaymentPlan().getSchedules())) {
			return getPolicyCharge();
		}

		for (var i=1;i<=arrayLen(getPaymentPlan().getSchedules());i++) {
			if (getPaymentPlan().getSchedules()[i].getIsDeposit() == 1) {
				if (getPaymentPlan().getSchedules()[i].getPolicyFeeAmount() == 0 && getPaymentPlan().getSchedules()[i].getPolicyFeeRate() > 0) {
					return getPaymentPlan().getSchedules()[i].getPolicyFeeRate() * getPolicyCharge() * 0.01;
				} else {
					return getPaymentPlan().getSchedules()[i].getPolicyFeeAmount();
				}
			}
		}

		return getPolicyCharge();
	}

	public numeric function getPolicyChargeInstallment(numeric installmentNumber=1)
		output="false"
		hint="I return the policy charge installment"
	{
		if (isNull(getPaymentPlan()) || isNull(getPaymentPlan().getSchedules())) {
			return 0;
		}

		for (var i=1;i<=arrayLen(getPaymentPlan().getSchedules());i++) {
			if (getPaymentPlan().getSchedules()[i].getInstallmentNumber() == arguments.installmentNumber &&
				getPaymentPlan().getSchedules()[i].getIsDeposit() != 1)
			{
				if (getPaymentPlan().getSchedules()[i].getPolicyFeeAmount() == 0 && getPaymentPlan().getSchedules()[i].getPolicyFeeRate() > 0) {
					return getPaymentPlan().getSchedules()[i].getPolicyFeeRate() * getPolicyCharge() * 0.01;
				} else {
					return getPaymentPlan().getSchedules()[i].getPolicyFeeAmount();
				}
			}
		}

		return 0;
	}

	public boolean function hasDiscountType(required model.config.discountType.DiscountType discountType)
		output="false"
	{
		if (isNull(getDiscounts())) {
			return false;
		}

		for (var i=1;i<=arrayLen(getDiscounts());i++) {
			if (getDiscounts()[i].getDiscountTypeID() == arguments.discountType.getDiscountTypeID()) {
				return true;
			}
		}

		return false;
	}

	public numeric function getTotalPayments()
		output="false"
	{
		if (isNull(getPayments())) {
			return 0;
		}

		var paymentSum = 0;

		for (var i=1;i<=arrayLen(getPayments());i++) {
			paymentSum += isNumeric(getPayments()[i].getAmount())?getPayments()[i].getAmount():0;
		}

		return paymentSum;
	}

	public numeric function getAmountDue(asOf="")
		output="false"
	{
		if (isNull(getAR())) {
			return 0;
		}

		arguments.asOf = dateFormat(isDate(arguments.asOf)?arguments.asOf:now(), "m/d/yyyy");
		if (isDate(getEffectiveDate()) && dateDiff("d", arguments.asOf, getEffectiveDate()) > 0) {
			arguments.asOf = dateFormat(getEffectiveDate(), "m/d/yyyy");
		}

		var amountOwed = 0;

		for (var i=1;i<=arrayLen(getAR());i++) {
			if (dateDiff("d", arguments.asOf, getAR()[i].getARDate()) > 0) {
				continue;
			}

			amountOwed += isNumeric(getAR()[i].getAmount())?getAR()[i].getAmount():0;
		}

		return numberFormat((amountOwed - getTotalPayments())>0?(amountOwed - getTotalPayments()):0, "9.99");
	}

	public numeric function getBalance()
		output="false"
	{
		if (isNull(getAR())) {
			return 0;
		}

		var amountOwed = 0;

		for (var i=1;i<=arrayLen(getAR());i++) {
			amountOwed += isNumeric(getAR()[i].getAmount())?getAR()[i].getAmount():0;
		}

		return numberFormat(amountOwed - getTotalPayments(), "9.99");
	}

	public boolean function hasDirectOnlineAgencyFee()
		output="false"
	{
		if (isNull(getAgencyFees())) {
			return false;
		}

		for (var i=1;i<=arrayLen(getAgencyFees());i++) {
			if (getAgencyFees()[i].getIsDirectOnlineAgencyFee() == 1) {
				return true;
			}
		}

		return false;
	}

	public boolean function hasEsignedBindingDocs()
		output="false"
	{
		var qs = new Query();
		qs.addParam(name="policyID", value=getPolicyID(), cfsqltype="cf_sql_integer");
		qs.setSQL("
			SELECT 1
			FROM Policy
			WHERE policyID = :policyID
				AND isRenewal = 0
				AND EXISTS(SELECT 1
					FROM EsigSessionLog WITH (NOLOCK)
					WHERE policyID = Policy.policyID
						AND remoteSig = 1
						AND isSigned > 0
						AND CAST(GetDate() AS DATE) < DateAdd(day, (SELECT daysAllowedForRemoteEsign FROM Windhaven_Config.dbo.PolicyTypes WHERE policyType = Policy.policyType), Policy.effectiveDate))
		");

		return (qs.execute().getResult().recordCount == 1) ? true : false;
	}
}