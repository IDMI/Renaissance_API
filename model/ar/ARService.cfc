/**
ar/ARService.cfc
@author Peruz Carlsen
@createdate 20120307
@hint AR service
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
	public model.ar.ARService function init() {
		super.init(entityName="AR");

		return this;
	}
}