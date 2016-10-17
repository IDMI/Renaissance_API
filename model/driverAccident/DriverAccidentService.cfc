/**
driverAccident/DriverAccidentService.cfc
@author Peruz Carlsen
@createdate 20120307
@hint Driver accident service
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
	public model.driverAccident.DriverAccidentService function init() {
		super.init(entityName="DriverAccident");

		return this;
	}
}