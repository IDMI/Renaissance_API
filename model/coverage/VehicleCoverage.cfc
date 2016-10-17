/*
model/VehicleCoverage.cfc
@author Peruz Carlsen
@createdate 20111002
@description VehicleCoverage entity
*/
component
	persistent="true"
	table="Coverages"
	extends="Coverage"
	discriminatorvalue="Vehicle"
	output="false"
{
	// relations
	property name="vehicle" fieldtype="many-to-one" fkcolumn="objectID" joincolumn="vehicleID" cfc="model.vehicle.Vehicle" lazy="true" inverse="true";
}