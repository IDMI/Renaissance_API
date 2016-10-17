/**
config/policyCoverage/PolicyCoverageService.cfc
@author Peruz Carlsen
@createdate 20120307
@hint Policy coverage service
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
	public model.config.policyCoverage.PolicyCoverageService function init() {
		super.init(entityName="PolicyCoverage");

		return this;
	}
}