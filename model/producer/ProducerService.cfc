/**
producer/ProducerService.cfc
@author Peruz Carlsen
@createdate 20120307
@hint Producer service
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
	public model.producer.ProducerService function init() {
		super.init(entityName="Producer");

		return this;
	}
}