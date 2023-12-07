function bool:P:IsValidKey(id)
{
	return (CrateKeyInfo[id][C:Pos][0] != 0.0);
}

function P:InitKeys()
{
	P:LoadKeys();
	
	new keysToActivate = min(BONUS_CRATE_KEY_ACTIVE_ITEMS, P:CountValidKeys());
	new activated;
	
	while(activated < keysToActivate)
	{
		new id = random(MAX_CRATE_KEYS);
		if(!P:IsValidKey(id) || CrateKeyInfo[id][C:Active])
			continue;
		
		P:ActivateKey(id, true);
		activated++;
	}
}

function P:RestartKeys()
{
	for(new i = 0; i < MAX_CRATE_KEYS; i++)
	{
		P:DestroyKey(i);
	}
	
	P:InitKeys();
	P:ShowKeys();
}

function P:LoadKeys()
{
	if(!fexist("Config/ladakulcsok.cfg"))
		return 1;
	
	new File:f, buf[256], id;
	f = fopen("Config/ladakulcsok.cfg", io_read);
	
	while(id < MAX_CRATE_KEYS && fread(f, buf))
	{
		if(sscanf(buf, "p<,>fffd", ArrExt(CrateKeyInfo[id][C:Pos]), CrateKeyInfo[id][C:VW]))
			continue;
		
		if(CrateKeyInfo[id][C:Pos][0] != 0.0)
			P:CreateKeyMapIcon(id);
		
		id++;
	}
	
	return 1;
}

function P:SaveKeys()
{
	new File:f, buf[256];
	f = fopen("Config/ladakulcsok.cfg");
	for(new i = 0; i < MAX_CRATE_KEYS; i++)
	{
		if(CrateKeyInfo[i][C:Pos][0] == 0.0)
			continue;
			
		Format(buf, "%f,%f,%f,%d\n", ArrExt(CrateKeyInfo[i][C:Pos]), CrateKeyInfo[i][C:VW]);
		fwrite(f, buf);
	}
	
	fclose(f);
}

function P:ActivateKey(id, bool:activate)
{
	if(!P:IsValidKey(id))
		return 1;
	
	if(activate)
	{
		P:ActivateKey(id, false);
		CrateKeyInfo[id][C:Active] = true;
		CrateKeyInfo[id][C:ObjectID] = CreateDynamicObject(BONUS_CRATE_KEY_OBJECT, CrateKeyInfo[id][C:Pos][0], CrateKeyInfo[id][C:Pos][1], CrateKeyInfo[id][C:Pos][2] + BONUS_CRATE_KEY_OBJECT_Z, 0.0, 0.0, 0.0, .streamdistance = BONUS_KEY_STREAM_DISTANCE, .drawdistance = BONUS_KEY_DRAW_DISTANCE);
		SetObjectMaterial(CrateKeyInfo[id][C:ObjectID], 0, -1, "none", "none", BONUS_CRATE_KEY_OBJECT_COLOR);
	}
	else
	{
		CrateKeyInfo[id][C:Active] = false;
		if(CrateKeyInfo[id][C:ObjectID] != INVALID_OBJECT_ID)
		{
			DestroyDynamicObject(CrateKeyInfo[id][C:ObjectID]);
			CrateKeyInfo[id][C:ObjectID] = INVALID_OBJECT_ID;
		}
	}
	
	return 1;
}

function P:ActivateRandomKey()
{
	while(TRUE)
	{
		new id = random(MAX_CRATE_KEYS);
		if(!P:IsValidKey(id) || CrateKeyInfo[id][C:Active])
			continue;
			
		P:ActivateKey(id, true);
		break;
	}
}

function P:CountValidKeys()
{
	new valid;
	for(new i = 0; i < MAX_CRATE_KEYS; i++)
	{
		if(CrateKeyInfo[i][C:Pos][0] == 0.0)
			continue;
		
		valid++;
	}
	
	return valid;
}

/*function P:CountActivatedKeys()
{
	new count;
	for(new i = 0; i < MAX_CRATE_KEYS; i++)
	{
		if(P:IsValidKey(i) && CrateKeyInfo[i][C:Active])
			count++;
	}
	
	return count;
}*/

function P:CreateKeyMapIcon(id)
{
	CrateKeyInfo[id][C:MapID] = CreateDynamicMapIcon( ArrExt( CrateKeyInfo[id][C:Pos] ), 36, 0, NINCS, NINCS, NINCS, 1000.0);
	Streamer_SetIntData( STREAMER_TYPE_MAP_ICON, CrateKeyInfo[id][C:MapID], E_STREAMER_STYLE, 3); // Global + checkpoint
	if(Streamer_IsInArrayData( STREAMER_TYPE_MAP_ICON, CrateKeyInfo[id][C:MapID], E_STREAMER_PLAYER_ID, NINCS))
		Streamer_RemoveArrayData( STREAMER_TYPE_MAP_ICON, CrateKeyInfo[id][C:MapID], E_STREAMER_PLAYER_ID, NINCS);
}

function P:DestroyKey(id)
{
	CrateKeyInfo[id][C:Pos] = Float:{0.0, 0.0, 0.0};
	DestroyDynamicMapIcon(CrateKeyInfo[id][C:MapID]);
	CrateKeyInfo[id][C:MapID] = 0;
	
	if(CrateKeyInfo[id][C:ObjectID] != INVALID_OBJECT_ID)
	{
		DestroyDynamicObject(CrateKeyInfo[id][C:ObjectID]);
		CrateKeyInfo[id][C:ObjectID] = INVALID_OBJECT_ID;
	}
	
	CrateKeyInfo[id][C:Active] = false;
}

function P:ShowKeysFor(playerid, bool:show)
{
	for(new i = 0; i < MAX_CRATE_KEYS; i++)
	{
		if(CrateKeyInfo[i][C:Pos][0] == 0.0)
			continue;
		
		P:ShowKeyFor(playerid, i, show);
	}
}

function P:ShowKeyFor(playerid, id, bool:show)
{
	if(CrateKeyInfo[id][C:Pos][0] == 0.0)
		return 1;
	
	if(show && !Streamer_IsInArrayData( STREAMER_TYPE_MAP_ICON, CrateKeyInfo[id][C:MapID], E_STREAMER_PLAYER_ID, playerid) )
		Streamer_AppendArrayData( STREAMER_TYPE_MAP_ICON, CrateKeyInfo[id][C:MapID], E_STREAMER_PLAYER_ID, playerid);
	else if(!show && Streamer_IsInArrayData( STREAMER_TYPE_MAP_ICON, CrateKeyInfo[id][C:MapID], E_STREAMER_PLAYER_ID, playerid) )
		Streamer_RemoveArrayData( STREAMER_TYPE_MAP_ICON, CrateKeyInfo[id][C:MapID], E_STREAMER_PLAYER_ID, playerid);
		
	return 1;
}

function P:ShowKeys()
{
	foreach(Jatekosok, p)
	{
		P:ShowKeysFor(p, LadaKulcsMutat[p]);
	}
}

function P:GetNearbyKeyForPlayer(playerid, Float:checkDist = 0.5, bool:onlyActive = false)
{
	new Float:pos[3];
	GetPlayerPos(playerid, ArrExt(pos));
	return P:GetNearbyKey(ArrExt(pos), GetPlayerVirtualWorld(playerid), checkDist, onlyActive);
}

function P:GetNearbyKey(Float:x, Float:y, Float:z, vw, Float:checkDist = 0.5, bool:onlyActive = false)
{
	new Float:tav;
	for(new i = 0; i < MAX_CRATE_KEYS; i++)
	{
		if(CrateKeyInfo[i][C:Pos][0] == 0.0)
			continue;
			
		tav = GetDistanceBetweenPoints(x, y, z, ArrExt(CrateKeyInfo[i][C:Pos]));
		if(tav < checkDist && CrateKeyInfo[i][C:VW] == vw && (!onlyActive || CrateKeyInfo[i][C:Active]))
			return i;
	}
	
	return NINCS;
}

function P:GetFreeKeySlot()
{
	for(new i = 0; i < MAX_CRATE_KEYS; i++)
	{
		if(CrateKeyInfo[i][C:Pos][0] == 0.0)
			return i;
	}
	
	return NINCS;
}

ALIAS(lk):ladakulcs; // lk
ALIAS(l1dakulcs):ladakulcs; // ládakulcs
CMD:ladakulcs(playerid, params[])
{
	new fojog = Admin(playerid, 1337);
	
	new cmd[32], subcmd[128];
	if(sscanf(params, "s[32] S()[128]", cmd, subcmd))
	{
		if(fojog)
			return Msg(playerid, "Használat: /ládakulcs [felvesz / mutat / új / töröl]");
		else
			return Msg(playerid, "Használat: /ládakulcs [felvesz / átad]");
	}
		
	if(fojog && egyezik(cmd, "mutat"))
	{
		LadaKulcsMutat[playerid] = !LadaKulcsMutat[playerid];
		if(LadaKulcsMutat[playerid])
			Msg(playerid, "Kulcsok jelezve a térképen");
		else
			Msg(playerid, "Kulcsok elrejtve a térképen");
			
		P:ShowKeysFor(playerid, LadaKulcsMutat[playerid]);
		Streamer_Update(playerid);
		return 1;
	}
	else if(fojog && (egyezik(cmd, "uj") || egyezik(cmd, "új")))
	{
		new id = P:GetNearbyKeyForPlayer(playerid, 30.0);
		if(id != NINCS)
			return Msg(playerid, "A közelben már van kulcs!");
			
		id = P:GetFreeKeySlot();
		if(id == NINCS)
			return Msg(playerid, "Több nem rakható le!");
		
		GetPlayerPos(playerid, ArrExt(CrateKeyInfo[id][C:Pos]));
		P:CreateKeyMapIcon(id);
		
		foreach(Jatekosok, p)
		{
			if(LadaKulcsMutat[p])
				P:ShowKeyFor(p, id, LadaKulcsMutat[p]);
		}
		
		P:SaveKeys();
		Streamer_Update(playerid);
		
		Msg(playerid, "Kulcs hozzáadva");
	}
	else if(fojog && (egyezik(cmd, "töröl") || egyezik(cmd, "torol")))
	{
		new id = NINCS;
		sscanf(subcmd, "d", id);
		
		if(id == NINCS)
			id = P:GetNearbyKeyForPlayer(playerid, 3.0);
			
		if(id == NINCS)
			return Msg(playerid, "A közelben nincs kulcs (id szerinti törlés: /ládakulcs töröl [id])");
		
		P:DestroyKey(id);
		P:SaveKeys();
		Streamer_Update(playerid);
		
		Msg(playerid, "Kulcs törölve");
	}
	else if(fojog && egyezik(cmd, "restart"))
	{
		P:RestartKeys();
		Streamer_Update(playerid);
		
		Msg(playerid, "Újraindítva");
	}
	else if(egyezik(cmd, "felvesz"))
	{
		if(GetPlayerVehicleID(playerid) > 0)
			return Msg(playerid, "A-a!");
			
		if(PlayerInfo[playerid][pLadaKulcs] >= BONUS_MAX_PLAYER_KEYS)
			return Msg(playerid, TFormatInline("Legfeljebb %d darab kulcs lehet nálad egyszerre", BONUS_MAX_PLAYER_KEYS));
		
		new id = P:GetNearbyKeyForPlayer(playerid, .onlyActive = true);
		if(id == NINCS)
			return Msg(playerid, "A közelben nincs kulcs");
			
		P:ActivateKey(id, false);
		P:ActivateRandomKey();
		Streamer_Update(playerid);
		
		PlayerInfo[playerid][pLadaKulcs]++;
		Cselekves(playerid, "felvett egy kulcsot a földrõl");
		
		ApplyAnimation(playerid, "BOMBER", "BOM_PLANT_2IDLE", 4.1, false, false, false, false, 0, true);
		
		Log("Szef", TFormatInline("[%d]%s felvett egy kulcsot a földrõl", playerid, PlayerName(playerid)));
	}
	else if(egyezik(cmd, "átad") || egyezik(cmd, "atad"))
	{
		if(PlayerInfo[playerid][pLadaKulcs] < 1)
			return Msg(playerid, "Nincs kulcsod");
			
		new target, amount;
		if(sscanf(subcmd, "ri", target, amount))
			return Msg(playerid, "Használat: /ládakulcs átad [játékos] [mennyiség]");
			
		if(target == INVALID_PLAYER_ID || target == playerid)
			return Msg(playerid, "Nincs ilyen játékos");
			
		if(GetDistanceBetweenPlayers(playerid, target) > 1.0)
			return Msg(playerid, "Nincs a közeledben");
		
		if(amount < 1)
			return Msg(playerid, "Minimum 1");
		
		if(amount > PlayerInfo[playerid][pLadaKulcs])
			return Msg(playerid, "Nincs ennyi kulcsod");
		
		if(PlayerInfo[target][pLadaKulcs] >= BONUS_MAX_PLAYER_KEYS)
			return Msg(playerid, "Nála nincs több hely");
		
		new targetAmount = (PlayerInfo[target][pLadaKulcs] + amount);
		if(targetAmount > BONUS_MAX_PLAYER_KEYS)
			return Msg(playerid, TFormatInline("Ennyi nem fér el nála - max %d darabot adhatsz át", (BONUS_MAX_PLAYER_KEYS - PlayerInfo[target][pLadaKulcs])));
		
		PlayerInfo[playerid][pLadaKulcs] -= amount;
		PlayerInfo[target][pLadaKulcs] += amount;
		SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Átadtál %ddb kulcsot neki: %s", amount, PlayerName(target));
		SendFormatMessage(target, COLOR_LIGHTBLUE, "Kaptál %ddb kulcsot tõle: %s", amount, PlayerName(playerid));
		Cselekves(playerid, "átadott néhány kulcsot");
	}
	else if(fojog && egyezik(cmd, "set"))
	{
		new target;
		new amount;
		if(sscanf(subcmd, "rd", target, amount))
			return Msg(playerid, "Használat: /kulcs set [player] [kulcsok száma]");
			
		if(target == INVALID_PLAYER_ID)
			return Msg(playerid, "Érvénytelen játékos");
			
		PlayerInfo[target][pLadaKulcs] = amount;
		Msg(playerid, TFormatInline("%s kulcsinak száma beállítva: %d darab", PlayerName(target), amount));
	}
	else if(fojog && egyezik(cmd, "listactive"))
	{
		SendClientMessage(playerid, COLOR_YELLOW, "Aktív kulcsok:");
		for(new i = 0; i < MAX_CRATE_KEYS; i++)
		{
			if(P:IsValidKey(i) && CrateKeyInfo[i][C:Active])
				SendFormatMessage(playerid, COLOR_YELLOW, "Active: %d", i);
		}
	}
	else if(fojog && egyezik(cmd, "go"))
	{
		new id = NINCS;
		if(sscanf(subcmd, "d", id))
			return Msg(playerid, "Használat: /ládakulcs go [id]");
			
		if(id < 0 || id >= MAX_CRATE_KEYS || !P:IsValidKey(id))
			return Msg(playerid, "Érvénytelen ID");
		
		Tele(playerid, ArrExt(CrateKeyInfo[id][C:Pos]), .VW = CrateKeyInfo[id][C:VW]);
	}
	
	return 1;
}