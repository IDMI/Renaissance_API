/**
suspense/SuspenseService.cfc
@author Peruz Carlsen
@createdate 20120307
@hint Suspense service
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
	public model.suspense.SuspenseService function init() {
		super.init(entityName="Suspense");

		return this;
	}
}