/**
config/discountType/DiscountTypeService.cfc
@author Peruz Carlsen
@createdate 20120307
@hint Discount type service
@output false
**/
component
	extends="coldbox.system.orm.hibernate.VirtualEntityService"
	accessors="true"
	singleton
{
	/**
    @author Peruz Carlsen
    @createdate 20120307
    @hint constructor
    @output false
    **/
	public model.config.discountType.DiscountTypeService function init() {
		super.init(entityName="DiscountType");

		return this;
	}
}