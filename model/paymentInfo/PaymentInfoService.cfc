/**
paymentInfo/PaymentInfoService.cfc
@author Peruz Carlsen
@createdate 20120307
@hint PaymentInfo service
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
	public model.paymentInfo.PaymentInfoService function init() {
		super.init(entityName="PaymentInfo");

		return this;
	}
}