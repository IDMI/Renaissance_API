/**
rate/autoRateDetail/AutoRateDetailService.cfc
@author Peruz Carlsen
@createdate 20120307
@hint Auto rate detail service
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
	public model.rate.autoRateDetail.AutoRateDetailService function init() {
		super.init(entityName="AutoRateDetail");

		return this;
	}

	/**
    @author Peruz Carlsen
    @createdate 20120326
    @hint Returns distinct description array based on given criteria
    @output false
    **/
	public array function getDescriptionCollection(required struct criteria) {
		var descriptionCollection = [];
		var autoRateDetails = findAllWhere(arguments.criteria);

		for (var i=1;i<=arrayLen(autoRateDetails);i++) {
			if (arrayFindNoCase(descriptionCollection, autoRateDetails[i].getDescription()) ||
				len(trim(autoRateDetails[i].getDescription())) == 0	)
			{
				continue;
			}

			arrayAppend(descriptionCollection, trim(autoRateDetails[i].getDescription()));
		}

		return descriptionCollection;
	}
}