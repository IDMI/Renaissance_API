/**
config/surchargeType/SurchargeTypeService.cfc
@author Peruz Carlsen
@createdate 20120307
@hint Surcharge type service
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
	public model.config.surchargeType.SurchargeTypeService function init() {
		super.init(entityName="SurchargeType");

		return this;
	}
}