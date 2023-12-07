#if defined __game_system_system_drop
	#endinput
#endif
#define __game_system_system_drop

enum dropInfo
{
	bool:dVan,
	dType,
	dObject,
	Text3D:dText,
	Float:dPos[3],
	dVW,
	dInt,
	dTime,
	dData[3]
}

#define MAX_DROP 1000
new DropInfo[MAX_DROP][dropInfo];

enum playerDropInfo
{
	pAmmoDropped
}
new PlayerDropInfo[MAX_PLAYERS][playerDropInfo];

#define DROP_DEFAULT_TIME		3600
#define DROP_DEFAULT_DISTANCE	2.0

#define DROP_TYPE_WEAPON	1
#define DROP_TYPE_AMMO		2

stock DropAdd(type, Float:x, Float:y, Float:z, objectID = INVALID_OBJECT_ID, Text3D:textID = INVALID_3D_TEXT_ID, vw = 0, int = 0, time = DROP_DEFAULT_TIME)
{
	new slot = NINCS;
	
	for(new s = 0; s < MAX_DROP; s++)
	{
		if(!DropInfo[s][dVan])
		{
			slot = s;
			break;
		}
	}
	
	if(slot == NINCS)
		return NINCS;
	
	DropInfo[slot][dVan] = true;
	DropInfo[slot][dType] = type;
	DropInfo[slot][dObject] = objectID;
	DropInfo[slot][dText] = textID;
	ArrSet(DropInfo[slot][dPos], x, y, z);
	DropInfo[slot][dVW] = vw;
	DropInfo[slot][dInt] = int;
	DropInfo[slot][dTime] = (time ? UnixTime + time : 0);
	
	return slot;
}

stock DropAddWeapon(Float:x, Float:y, Float:z, weapon, vw = 0, int = 0, time = DROP_DEFAULT_TIME)
{
	if(weapon < 1 || weapon > MAX_WEAPONS)
		return 0;
	
	format(_tmpString, 128, "%s fegyver", GunName(weapon));
	new object = CreateDynamicObject(WeaponObject(weapon), x, y, z-1, 80.0, 0.0, 0.0, vw, int);
	new Text3D:text = CreateDynamic3DTextLabel(_tmpString, COLOR_YELLOW, x, y, z-1, 30.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, vw, int);
	
	new slot = DropAdd(DROP_TYPE_WEAPON, x, y, z, object, text, vw, int, time);
	
	if(slot != NINCS)
		DropInfo[slot][dData][0] = weapon;
	
	return slot;
}

stock DropAddAmmo(Float:x, Float:y, Float:z, weapon, ammo, vw = 0, int = 0, time = DROP_DEFAULT_TIME)
{
	if(weapon < 1 || weapon > MAX_WEAPONS || ammo < 1)
		return 0;
	
	format(_tmpString, 128, "%s lõszer\n%ddb", GunName(weapon), ammo);
	new object = CreateDynamicObject(WeaponObject(weapon), x, y, z-1, 80.0, 0.0, 0.0, vw, int);
	new Text3D:text = CreateDynamic3DTextLabel(_tmpString, COLOR_YELLOW, x, y, z-1, 30.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, vw, int);
	
	new slot = DropAdd(DROP_TYPE_AMMO, x, y, z, object, text, vw, int, time);
	
	if(slot != NINCS)
		DropInfo[slot][dData][0] = weapon, DropInfo[slot][dData][1] = ammo;
	
	return slot;
}

stock DropNear(Float:x, Float:y, Float:z, Float:dist = DROP_DEFAULT_DISTANCE)
{
	for(new d = 0; d < MAX_DROP; d++)
	{
		if(GetDistanceBetweenPoints(x, y, z, ArrExt(DropInfo[d][dPos])) <= dist)
			return d;
	}
	
	return NINCS;
}

stock DropNearPlayer(playerid, Float:dist = DROP_DEFAULT_DISTANCE)
{
	for(new d = 0; d < MAX_DROP; d++)
	{
		if(GetPlayerDistanceFromPoint(playerid, ArrExt(DropInfo[d][dPos])) <= dist)
			return d;
	}
	
	return NINCS;
}

stock DropRemove(id)
{
	if(id < 0 || id >= MAX_DROP || !DropInfo[id][dVan])
		return 0;
	
	if(DropInfo[id][dObject] != INVALID_OBJECT_ID)
		DestroyDynamicObject(DropInfo[id][dObject]), DropInfo[id][dObject] = INVALID_OBJECT_ID;
	
	if(DropInfo[id][dText] != INVALID_3D_TEXT_ID)
		DestroyDynamic3DTextLabel(DropInfo[id][dText]), DropInfo[id][dText] = INVALID_3D_TEXT_ID;
		
	DropInfo[id][dVan] = false;
	
	return 1;
}