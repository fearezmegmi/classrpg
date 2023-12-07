#if defined __fs_object_definition
	#endinput
#endif
#define __fs_object_definition

stock ClintObject(modelid, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz, worldid = -1, interiorid = -1, playerid = -1, Float:distance = ALAPOBJECTDISTANCE, Float:draw = 150.0)
{
	new obj = CreateDynamicObject(modelid, x, y, z, rx, ry, rz, (VW != NINCS ? VW : worldid), \
		(Interior != NINCS ? Interior : interiorid), (Player != NINCS ? Player : playerid), (Distance != 0.0 ? Distance : distance), draw);
		
	Iter_Add(Object, obj);
	return obj;
}
	
#define CreateObject(%1) ClintObject(%1)

#define AddRemoveObjectToList(%1,%2,%3,%4,%5) OR[++db][rO]=%1,OR[db][rP][0]=%2,OR[db][rP][1]=%3,OR[db][rP][2]=%4,OR[db][rD]=%5
#if !defined FILTER_DUPES
	#define RemoveBuildingForPlayer(playerid,%1,%2,%3,%4,%5) AddRemoveObjectToList(%1,%2,%3,%4,%5)
#else
	#define RemoveBuildingForPlayer(playerid,%1,%2,%3,%4,%5) AddRemoveObject(%1,%2,%3,%4,%5)
	stock AddRemoveObject(object, Float:px, Float:py, Float:pz, Float:dist)
	{
		new exist;
		
		for(new x = 0; x <= db; x++)
		{
			if(OR[x][rO] == object && OR[x][rP][0] == px && OR[x][rP][1] == py && OR[x][rP][2] == pz && OR[x][rD] == dist)
			{
				exist++;
				printf("DUPE[%ddb]: %d, %.4f, %.4f, %.4f, %.4f", exist, OR[x][rO], OR[x][rP][0], OR[x][rP][1], OR[x][rP][2], OR[x][rD]);
			}
		}
		
		if(!exist)
			AddRemoveObjectToList(object, px, py, pz, dist);
	}
#endif