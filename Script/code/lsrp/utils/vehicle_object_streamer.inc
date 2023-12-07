/*
	Vehicle Object Streamer by mick88
	convoytrucking@gmail.com

	You are allowed to edit and redistribute
	this file without changing credits
*/

stock CreateVehicleObject(modelid, vehicleid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:stream_distance=100.0)
{
	return CallRemoteFunction("CreateVehicleObject", "ddfffffff", modelid, vehicleid, fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ, stream_distance);
}

stock DestroyVehicleObject(vobjectid)
{
	return CallRemoteFunction("DestroyVehicleObject", "d", vobjectid);
}

stock RemoveObjectsFromVehicle(vehicleid)
{
	return CallRemoteFunction("RemoveObjectsFromVehicle", "d", vehicleid);
}

/*
	Vehicle Object Streamer by mick88
	convoytrucking@gmail.com

	You are allowed to edit and redistribute
	this file without changing credits
*/
