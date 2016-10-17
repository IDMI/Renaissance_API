/**
surcharge/VehicleSurchargeService.cfc
@author Peruz Carlsen
@createdate 20120307
@hint Vehicle surcharge service
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
	public model.surcharge.VehicleSurchargeService function init() {
		super.init(entityName="VehicleSurcharge");

		return this;
	}
}