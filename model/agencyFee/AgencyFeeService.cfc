/**
agencyFee/AgencyFeeService.cfc
@author Peruz Carlsen
@createdate 20120307
@hint Agency fee service
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
	public model.agencyFee.AgencyFeeService function init() {
		super.init(entityName="AgencyFee");

		return this;
	}
}