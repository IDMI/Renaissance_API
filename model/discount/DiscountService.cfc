/**
discount/DiscountService.cfc
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
	public model.discount.DiscountService function init() {
		super.init(entityName="Discount");

		return this;
	}
}