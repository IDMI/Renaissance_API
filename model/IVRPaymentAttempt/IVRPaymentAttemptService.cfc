/**
IVRPaymentAttempt/IVRPaymentAttemptService.cfc
@author Peruz Carlsen
@createdate 20120307
@hint IVR payment attempt service
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
	public model.IVRPaymentAttempt.IVRPaymentAttemptService function init() {
		super.init(entityName="IVRPaymentAttempt");

		return this;
	}
}