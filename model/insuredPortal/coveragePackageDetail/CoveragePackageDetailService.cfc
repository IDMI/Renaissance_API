/**
insuredPortal/coveragePackageDetail/CoveragePackageDetailService.cfc
@author Peruz Carlsen
@createdate 20120307
@hint Coverage package detail service
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
	public model.insuredPortal.coveragePackageDetail.CoveragePackageDetailService function init() {
		super.init(entityName="CoveragePackageDetail");

		return this;
	}
}