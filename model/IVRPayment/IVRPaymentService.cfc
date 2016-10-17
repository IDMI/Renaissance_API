/**
IVRPayment/IVRPaymentService.cfc
@author Peruz Carlsen
@createdate 20120307
@hint IVR payment service
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
	public model.IVRPayment.IVRPaymentService function init() {
		super.init(entityName="IVRPayment");

		return this;
	}
}