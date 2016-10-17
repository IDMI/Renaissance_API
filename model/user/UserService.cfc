/**
user/UserService.cfc
@author Peruz Carlsen
@createdate 20120307
@hint User service
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
	public model.user.UserService function init() {
		super.init(entityName="User");

		return this;
	}
}