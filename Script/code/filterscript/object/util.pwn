#if defined __fs_object_util
	#endinput
#endif
#define __fs_object_util

stock Float:GetDistanceBetweenPoints(Float: x1, Float: y1, Float: z1, Float: x2, Float: y2, Float: z2)
	return VectorSize(x1-x2, y1-y2, z1-z2);
	
forward PrintObjectsInDistance(playerid, Float:distance);
public PrintObjectsInDistance(playerid, Float:distance)
{
	new
		Float: x, Float: y, Float: z, int, vw,
		model, Float: ox, Float: oy, Float: oz,
		Float: dist, str[256],
		bool: count
	;
	
	GetPlayerPos(playerid, x, y, z);
	vw = GetPlayerVirtualWorld(playerid);
	int = GetPlayerInterior(playerid);
	
	new limit = Streamer_GetUpperBound(STREAMER_TYPE_OBJECT);
	for(new obj = 0; obj <= limit; obj++)
	{
		if(IsValidDynamicObject(obj))
		{
			if(
				(Streamer_IsInArrayData(STREAMER_TYPE_OBJECT, obj, E_STREAMER_WORLD_ID, -1) || Streamer_IsInArrayData(STREAMER_TYPE_OBJECT, obj, E_STREAMER_INTERIOR_ID, int))
				&& (Streamer_IsInArrayData(STREAMER_TYPE_OBJECT, obj, E_STREAMER_WORLD_ID, -1) || Streamer_IsInArrayData(STREAMER_TYPE_OBJECT, obj, E_STREAMER_INTERIOR_ID, vw))
			)
			{
				Streamer_GetFloatData(STREAMER_TYPE_OBJECT, obj, E_STREAMER_X, ox);
				Streamer_GetFloatData(STREAMER_TYPE_OBJECT, obj, E_STREAMER_Y, oy);
				Streamer_GetFloatData(STREAMER_TYPE_OBJECT, obj, E_STREAMER_Z, oz);
				
				dist = VectorSize(x-ox, y-oy, z-oz);
				if(dist <= distance)
				{
					model = Streamer_GetIntData(STREAMER_TYPE_OBJECT, obj, E_STREAMER_MODEL_ID);
					format(str, 256, "[Model: %d / dist: %.1f] Pos: (%f, %f, %f)", model, dist, ox, oy, oz);
					SendClientMessage(playerid, -1, str);
					count++;
				}
			}
		}
	}
	
	if(!count)
		SendClientMessage(playerid, -1, "Nincs egy object sem a megadott távolságon belül");
}

forward Do_Remove(player);
public Do_Remove(player) {
	if(!Connected{player})
		return;
	
	#define CID CF[player]
	
	new did;//, msg[128];
	do {
		#if defined WAIT_BETWEEN_BIG_REMOVE
		if(OR[CID][rD] > 0.25 && did) {
			break;
		}
		#endif
		
		RemoveBuildingForPlayer(player, OR[CID][rO], OR[CID][rP][0], OR[CID][rP][1], OR[CID][rP][2], OR[CID][rD]);
		/*new dupe;
		for(new i = 0; i < MAX_OBJECT_REMOVE; i++)
		{
			if(OR[i][rO] && OR[i][rP][0] == OR[CID][rP][0] && OR[i][rP][1] == OR[CID][rP][1] && OR[i][rP][2] == OR[CID][rP][2])
				dupe++;
		}
		if(dupe)
			printf("DUPE[%ddb]: %d, %.4f, %.4f, %.4f, %.4f", dupe, OR[CID][rO], OR[CID][rP][0], OR[CID][rP][1], OR[CID][rP][2], OR[CID][rD]);*/
		
		did++, CID++;
	} while(did < MAX_REMOVE_PER_CYCLE && CID < db);
	
	if(CID < db)
		SetTimerEx("Do_Remove", TIME_BETWEEN_CYCLE, 0, "d", player);
	
	#undef CID
}