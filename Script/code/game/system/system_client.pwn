#if defined __game_system_system_client
	#endinput
#endif
#define __game_system_system_client

fpublic CC_Login(preQuery, client, name[], pass[])
{
	if(preQuery)
	{
		new escname[32];
		mysql_escape_string(name, escname);
		
		format(_tmpString, 256, "SELECT ID, Nev FROM %s WHERE Nev='%s' AND Pass='%s'", SQL_DB_Player, escname, pass);
		doQuery(_tmpString, SQL_CC_LOGIN, client);
		return 1;
	}
	
	new rows, fields;
	sql_data(rows, fields);
	
	if(rows == 1)
	{
		new id, nev[MAX_PLAYER_NAME];
		id = sql_get_int(0);
		sql_get_str(1, nev);
		
		// ID
		format(_tmpString, 128, "ID:%d", id);
		
		CallRemoteFunction("CC_Process_Login", "dddss", client, 1, id, nev, _tmpString);
	}
	else
		CallRemoteFunction("CC_Process_Login", "dddss", client, 0, 0, "0", "0");
	
	return 1;
}

fpublic CC_Scan(client, uid, name[], found, hacks[])
{
	new key[64];
	for(new k = 0; k < 32; k++)
		key[k] = '0' + random(10);
	
	new time = gettime();
	format(key, 64, "%d_%s", time, key);
	
	new query[1024];
	format(query, 256, "INSERT INTO cc_scans(UID, Name, Auth, Hacks, Ido) VALUES('%d', '%s', '%s', '%s', '%d')", uid, name, key, hacks, time);
	doQuery(query);
	
	CallRemoteFunction("CC_Process_Scan", "ds", client, key);
}

fpublic CC_GTA_Exit(uid)
{
	foreach(Jatekosok, p)
	{
		if(SQLID(p) == uid)
			WKick(p);
	}
}

/*fpublic CC_PassCode(playerid, uid, code[])
{
	if(Connected[playerid] && PlayerInfo[playerid][pID] == uid)
	{
		strmid(PlayerInfo[playerid][pCode], code, 0, 39, 40);
		return 1;
	}
	
	return 0;
}*/

fpublic CC_FpsLimitChange(uid, fps)
{
	foreach(Jatekosok, p)
	{
		if(PlayerInfo[p][pID] == uid)
		{
			PlayerInfo[p][pFPSlimiter] = fps;
			if(0 < fps < FPS_LIMITER_MIN_FPS)
			{
				PlayerInfo[p][pFPSlimiterWarn]++;
				if(PlayerInfo[p][pFPSlimiterWarn] > FPS_LIMITER_MAX_WARN)
				{
					SeeBan(p, UnixTime + FPS_LIMITER_BAN_TIME, _, "Alacsony fpslimiter beállítás");
					break;
				}
				else
				{
					SendClientMessage(p, COLOR_LIGHTRED, "===[ FIGYELMEZTETÉS ]===");
					SendClientMessage(p, COLOR_LIGHTRED, "A minimum /fpslimit beállítás "#FPS_LIMITER_MIN_FPS);
					SendClientMessage(p, COLOR_LIGHTRED, "Ha nem állítod át, a rendszer tiltani fog");
					SendClientMessage(p, COLOR_LIGHTRED, "Kérlek írd be ezt: /fpslimit "#FPS_LIMITER_MIN_FPS);
				}
			}
		}
	}
}

fpublic CC_SendRemoteCommand(uid, cmd[])
{
	new key[64];
	for(new k = 0; k < 32; k++)
		key[k] = '0' + random(10);
	
	new time = gettime();
	format(key, 64, "%d_%s", time, key);
	
	/*new query[1024];
	format(query, 256, "INSERT INTO cc_requests(UID, Name, Auth, Ido) VALUES('%d', '%s', '%s', '%d')", uid, name, key, time);
	doQuery(query);*/
	
	CallRemoteFunction("CC_Send_Command", "ds", uid, cmd);
}

fpublic CC_SetDebug(setdebug)
{
	CallRemoteFunction("CC_Set_Debug", "d", setdebug);
}