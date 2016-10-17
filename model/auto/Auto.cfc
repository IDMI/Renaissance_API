/*
model/Auto.cfc
@author Peruz Carlsen
@createdate 20110930
@description Auto entity
*/
component
	persistent="true"
	table="Auto"
	output="false"
{
	// primary key
	property name="autoID" fieldtype="id" column="autoID" generator="native" setter="false";

	// properties
	property name="agentInspectedVehicle" column="agentInspectedVehicle" type="numeric" ormtype="short" default="0";
	property name="attachStateSupplement" column="attachStateSupplement" type="numeric" ormtype="short" default="0";
	property name="attachYoungDriver" column="attachYoungDriver" type="numeric" ormtype="short" default="0";
	property name="attachDriverTraining" column="attachDriverTraining" type="numeric" ormtype="short" default="0";
	property name="attachGoodStudent" column="attachGoodStudent" type="numeric" ormtype="short" default="0";
	property name="attachAntiTheft" column="attachAntiTheft" type="numeric" ormtype="short" default="0";
	property name="attachMedical" column="attachMedical" type="numeric" ormtype="short" default="0";
	property name="attachMotorVehicleReport" column="attachMotorVehicleReport" type="numeric" ormtype="short" default="0";
	property name="attachPhotograph" column="attachPhotograph" type="numeric" ormtype="short" default="0";
	property name="attachBillOfSale" column="attachBillOfSale" type="numeric" ormtype="short" default="0";
	property name="priorCarrier" column="priorCarrier" type="string" ormtype="string" default="";
	property name="priorProducer" column="priorProducer" type="string" ormtype="string" default="";
	property name="priorPolicyNum" column="priorPolicyNum" type="string" ormtype="string" default="";
	property name="priorPolicyExpDate" column="priorPolicyExpDate" type="date" ormtype="timestamp";
	property name="priorYearsWithCompany" column="priorYearsWithCompany" type="numeric" ormtype="float" default="0";
	property name="curResidenceYears" column="curResidenceYears" type="numeric" ormtype="float" default="0";
	property name="curResidenceOwn" column="curResidenceOwn" type="numeric" ormtype="short" default="0";
	property name="prevResidenceYears" column="prevResidenceYears" type="numeric" ormtype="float" default="0";
	property name="prevResidenceAddress1" column="prevResidenceAddress1" type="string" ormtype="string" default="";
	property name="prevResidenceAddress2" column="prevResidenceAddress2" type="string" ormtype="string" default="";
	property name="prevResidenceCity" column="prevResidenceCity" type="string" ormtype="string" default="";
	property name="prevResidenceState" column="prevResidenceState" type="string" ormtype="string" default="";
	property name="prevResidenceZip" column="prevResidenceZip" type="string" ormtype="string" default="";
	property name="appEmployerName" column="appEmployerName" type="string" ormtype="string" default="";
	property name="appEmployerAddress1" column="appEmployerAddress1" type="string" ormtype="string" default="";
	property name="appEmployerAddress2" column="appEmployerAddress2" type="string" ormtype="string" default="";
	property name="appEmployerCity" column="appEmployerCity" type="string" ormtype="string" default="";
	property name="appEmployerState" column="appEmployerState" type="string" ormtype="string" default="";
	property name="appEmployerZip" column="appEmployerZip" type="string" ormtype="string" default="";
	property name="appEmployerPhone" column="appEmployerPhone" type="string" ormtype="string" default="";
	property name="appEmployerYears" column="appEmployerYears" type="numeric" ormtype="float" default="0";
	property name="appPrevEmployerYears" column="appPrevEmployerYears" type="numeric" ormtype="float" default="0";
	property name="coappEmployerName" column="coappEmployerName" type="string" ormtype="string" default="";
	property name="coappEmployerAddress1" column="coappEmployerAddress1" type="string" ormtype="string" default="";
	property name="coappEmployerAddress2" column="coappEmployerAddress2" type="string" ormtype="string" default="";
	property name="coappEmployerCity" column="coappEmployerCity" type="string" ormtype="string" default="";
	property name="coappEmployerState" column="coappEmployerState" type="string" ormtype="string" default="";
	property name="coappEmployerZip" column="coappEmployerZip" type="string" ormtype="string" default="";
	property name="coappEmployerPhone" column="coappEmployerPhone" type="string" ormtype="string" default="";
	property name="coappEmployerYears" column="coappEmployerYears" type="numeric" ormtype="float" default="0";
	property name="coappPrevEmployerYears" column="coappPrevEmployerYears" type="numeric" ormtype="float" default="0";
	property name="newBusiness" column="newBusiness" type="numeric" ormtype="short" default="0";
	property name="remarks" column="remarks" type="string" ormtype="string" default="";
	property name="endorsementDate" column="endorsementDate" type="date" ormtype="timestamp";
	property name="discountsApplied" column="discountsApplied" type="string" ormtype="string" default="";
	property name="tempRecord" column="tempRecord" type="numeric" ormtype="short" default="0";
	property name="policyState" column="policyState" type="numeric" ormtype="short" default="0";
	property name="noLogEntry" column="noLogEntry" type="numeric" ormtype="short" default="0";
	property name="policyZip" column="policyZip" type="string" ormtype="string" default="";
	property name="appQuestions" column="appQuestions" type="string" ormtype="string" default="";
	property name="policyZipID" column="policyZipID" type="numeric" ormtype="int" default="0";
	property name="generalEndorsement" column="generalEndorsement" type="string" ormtype="string" default="";
	property name="infoRequested_Auto" column="infoRequested_Auto" type="string" ormtype="string" default="";
	property name="assessLateFee" column="assessLateFee" type="numeric" ormtype="float" default="0";
	property name="priorPolicyExpDays" column="priorPolicyExpDays" type="numeric" ormtype="short" default="0";
	property name="marketLevel" column="marketLevel" type="string" ormtype="string" default="";
	property name="priorBIEachPerson" column="priorBIEachPerson" type="numeric" ormtype="int" default="0";
	property name="nonOwnedType" column="nonOwnedType" type="numeric" ormtype="short" default="0";
	property name="extendNonOwned" column="extendNonOwned" type="numeric" ormtype="short" default="0";
	property name="paymentMethod" column="paymentMethod" type="numeric" ormtype="short" default="0";
	property name="hasNonOwned" column="hasNonOwned" type="numeric" ormtype="short" default="0";
	property name="vehicleCount" column="vehicleCount" type="numeric" ormtype="short" default="0";
	property name="driverCount" column="driverCount" type="numeric" ormtype="short" default="0";

	// relations
	property name="drivers" fieldtype="one-to-many" fkcolumn="autoID" cfc="model.driver.Driver" singularname="driver" cascade="all-delete-orphan" lazy="extra" inverse="true";
	property name="policy" fieldtype="one-to-one" fkcolumn="policyID" cfc="model.policy.Policy" cascade="all-delete-orphan" lazy="true";
	property name="vehicles" fieldtype="one-to-many" fkcolumn="autoID" cfc="model.vehicle.Vehicle" singularname="vehicle" cascade="all-delete-orphan" lazy="extra" inverse="true";

	public numeric function getSR22FeeTotal()
		output="false"
	{
		if (isNull(getPolicy()) ||
			isNull(getPolicy().getPaymentPlan()) ||
			isNUll(getPolicy().getPaymentPlan().getSchedules()) ||
			isNull(getPolicy().getCompany()) ||
			isNull(getPolicy().getCompany().getFinancials()) ||
			isNull(getDrivers()))
		{
			return 0;
		}

		var sr22Count = 0;
		for (var i=1;i<=arrayLen(getDrivers());i++) {
			var driver = getDrivers()[i];
			if (driver.getRequiresSR22() == 1) {
				sr22Count++;
			}
		}

		for (var j=1;j<=arrayLen(getPolicy().getCompany().getFinancials());j++) {
			var financial = getPolicy().getCompany().getFinancials()[j];
			if (financial.getRatingVersionID() == getPolicy().getRatingVersionID() &&
				financial.getPolicyTerm() == getPolicy().getPolicyTerm())
			{
				return numberFormat(sr22Count * financial.getSR22Fee(), "9.99");
			}
		}

		return 0;
	}

	public numeric function getDepositAmount()
		output="false"
	{
		if (isNull(getPolicy()) ||
			isNull(getPolicy().getPaymentPlan()) ||
			isNUll(getPolicy().getPaymentPlan().getSchedules()) ||
			isNull(getPolicy().getCompany()) ||
			isNull(getPolicy().getCompany().getFinancials()))
		{
			return 0;
		}

		return numberFormat(getPolicy().getTermPremiumsDue() * getPolicy().getPaymentPlan().getDepositPercent() * 0.01, "9.99") + getPolicy().getPolicyChargeDeposit() + getSR22FeeTotal();
	}

	public numeric function getInstallmentAmount()
		hint="I return the installment amount"
		output="false"
	{
		if (isNull(getPolicy()) ||
			isNull(getPolicy().getPaymentPlan()) ||
			isNUll(getPolicy().getPaymentPlan().getSchedules()) ||
			isNull(getPolicy().getCompany()) ||
			isNull(getPolicy().getCompany().getFinancials()))
		{
			return 0;
		} else if (getPolicy().getPaymentPlan().getInstallmentCount() == 0) {
			return 0;
		}

		var depositAmount = numberFormat(getPolicy().getTermPremiumsDue() * getPolicy().getPaymentPlan().getDepositPercent() * 0.01, "9.99");

		return numberFormat(getPolicy().getPolicyChargeInstallment() + (getPolicy().getTermPremiumsDue() - depositAmount) / getPolicy().getPaymentPlan().getInstallmentCount(), "9.99");
	}
}
