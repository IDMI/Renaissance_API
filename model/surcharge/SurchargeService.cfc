/**
surcharge/SurchargeService.cfc
@author Peruz Carlsen
@createdate 20120307
@hint surcharge service
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
	public model.surcharge.SurchargeService function init() {
		super.init(entityName="Surcharge");

		return this;
	}
}