/**
coverage/VehicleCoverageService.cfc
@author Peruz Carlsen
@createdate 20120307
@hint Vehicle coverage service
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
	public model.coverage.VehicleCoverageService function init() {
		super.init(entityName="VehicleCoverage");

		return this;
	}
}