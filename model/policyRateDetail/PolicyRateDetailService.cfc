/**
policyRateDetail/PolicyRateDetailService.cfc
@author Peruz Carlsen
@createdate 20120307
@hint Policy rate detail service
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
	public model.policyRateDetail.PolicyRateDetailService function init() {
		super.init(entityName="PolicyRateDetail");

		return this;
	}
}