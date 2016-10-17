/**
discount/PolicyDiscountService.cfc
@author Peruz Carlsen
@createdate 20120307
@hint Deposit proof service
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
	public model.discount.PolicyDiscountService function init() {
		super.init(entityName="PolicyDiscount");

		return this;
	}
}