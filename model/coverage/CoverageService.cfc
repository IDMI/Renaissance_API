/**
coverage/CoverageService.cfc
@author Peruz Carlsen
@createdate 20120307
@hint Coverage service
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
	public model.coverage.CoverageService function init() {
		super.init(entityName="Coverage");

		return this;
	}
}