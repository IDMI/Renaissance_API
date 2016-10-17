/**
paymentPlanSchedule/PaymentPlanScheduleService.cfc
@author Peruz Carlsen
@createdate 20120307
@hint Payment plan schedule service
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
	public model.paymentPlanSchedule.PaymentPlanScheduleService function init() {
		super.init(entityName="PaymentPlanSchedule");

		return this;
	}
}