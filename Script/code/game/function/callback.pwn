#if defined __game_function_callback
	#endinput
#endif
#define __game_function_callback

function LoadActors()
{
	new actor;
	
	// hajléktalan szálló
	{
		// kiszolgáló
		actor = CreateActor(29, 1159.035, 2562.517, 10.922, 225.358);
		SetActorVirtualWorld(actor, VW_HAJLEKTALAN_SZALLO);
	
		actor = CreateActor(GetRandomHomelessSkin(), 1160.077, 2555.159, 11.284, 222.370);
		SetActorVirtualWorld(actor, VW_HAJLEKTALAN_SZALLO);
		ApplyActorAnimation(actor, "CRACK", "CRCKIDLE2", 4.0, 1, 0, 0, 0, 0);
		
		actor = CreateActor(GetRandomHomelessSkin(), 1165.091, 2560.173, 11.283, 225.526);
		SetActorVirtualWorld(actor, VW_HAJLEKTALAN_SZALLO);
		ApplyActorAnimation(actor, "CRACK", "CRCKIDLE2", 4.0, 1, 0, 0, 0, 0);
		
		actor = CreateActor(GetRandomHomelessSkin(), 1165.126, 2554.992, 10.922, 45.671);
		SetActorVirtualWorld(actor, VW_HAJLEKTALAN_SZALLO);
		ApplyActorAnimation(actor, "CRACK", "CRCKIDLE1", 4.0, 1, 0, 0, 0, 0);
		
		actor = CreateActor(GetRandomHomelessSkin(), 1175.861, 2552.981, 10.922, 321.866);
		SetActorVirtualWorld(actor, VW_HAJLEKTALAN_SZALLO);
		ApplyActorAnimation(actor, "CRACK", "CRCKIDLE3", 4.0, 1, 0, 0, 0, 0);
		
		actor = CreateActor(GetRandomHomelessSkin(), 1178.851, 2558.506, 11.283, 225.503);
		SetActorVirtualWorld(actor, VW_HAJLEKTALAN_SZALLO);
		ApplyActorAnimation(actor, "CRACK", "CRCKIDLE2", 4.0, 1, 0, 0, 0, 0);
		
		actor = CreateActor(GetRandomHomelessSkin(), 1173.001, 2575.899, 10.922, 316.708);
		SetActorVirtualWorld(actor, VW_HAJLEKTALAN_SZALLO);
		ApplyActorAnimation(actor, "SMOKING", "M_smklean_loop", 4.0, 1, 0, 0, 0, 0);
		
		actor = CreateActor(GetRandomHomelessSkin(), 1173.713, 2560.087, 10.922, 135.286);
		SetActorVirtualWorld(actor, VW_HAJLEKTALAN_SZALLO);
		ApplyActorAnimation(actor, "CRACK", "CRCKIDLE2", 4.0, 1, 0, 0, 0, 0);
		
		actor = CreateActor(GetRandomHomelessSkin(), 1162.480, 2552.687, 10.922, 37.595);
		SetActorVirtualWorld(actor, VW_HAJLEKTALAN_SZALLO);
		ApplyActorAnimation(actor, "SMOKING", "M_smklean_loop", 4.0, 1, 0, 0, 0, 0);
		
		actor = CreateActor(GetRandomHomelessSkin(), 1165.983, 2553.287, 10.922, 23.977);
		SetActorVirtualWorld(actor, VW_HAJLEKTALAN_SZALLO);
		ApplyActorAnimation(actor, "CRACK", "CRCKIDLE2", 4.0, 1, 0, 0, 0, 0);
		
		actor = CreateActor(GetRandomHomelessSkin(), 1167.652, 2566.326, 12.165, 58.757);
		SetActorVirtualWorld(actor, VW_HAJLEKTALAN_SZALLO);
		ApplyActorAnimation(actor, "CRACK", "CRCKIDLE3", 4.0, 1, 0, 0, 0, 0);
		
		// kint lévõ
		actor = CreateActor(GetRandomHomelessSkin(), 2521.367, -1346.482, 29.934, 91.299);
		ApplyActorAnimation(actor, "CRACK", "CRCKIDLE1", 4.0, 1, 0, 0, 0, 0);
		
		actor = CreateActor(GetRandomHomelessSkin(), 1172.266, 2563.730, 11.670, 327.553);
		SetActorVirtualWorld(actor, VW_HAJLEKTALAN_SZALLO);
		ApplyActorAnimation(actor, "CRACK", "CRCKIDLE2", 4.0, 1, 0, 0, 0, 0);
		
		actor = CreateActor(GetRandomHomelessSkin(), 1174.338, 2565.947, 11.682, 133.018);
		SetActorVirtualWorld(actor, VW_HAJLEKTALAN_SZALLO);
		ApplyActorAnimation(actor, "CRACK", "CRCKIDLE2", 4.0, 1, 0, 0, 0, 0);
		
		actor = CreateActor(GetRandomHomelessSkin(), 1176.147, 2564.070, 11.667, 143.382);
		SetActorVirtualWorld(actor, VW_HAJLEKTALAN_SZALLO);
		ApplyActorAnimation(actor, "CRACK", "CRCKIDLE2", 4.0, 1, 0, 0, 0, 0);
		
		actor = CreateActor(GetRandomHomelessSkin(), 1177.897, 2562.209, 11.685, 139.308);
		SetActorVirtualWorld(actor, VW_HAJLEKTALAN_SZALLO);
		ApplyActorAnimation(actor, "CRACK", "CRCKIDLE2", 4.0, 1, 0, 0, 0, 0);
		
		actor = CreateActor(GetRandomHomelessSkin(), 1178.826, 2560.397, 11.675, 43.114);
		SetActorVirtualWorld(actor, VW_HAJLEKTALAN_SZALLO);
		ApplyActorAnimation(actor, "CRACK", "CRCKIDLE2", 4.0, 1, 0, 0, 0, 0);
		
		actor = CreateActor(GetRandomHomelessSkin(), 1175.906, 2572.766, 11.282, 317.452);
		SetActorVirtualWorld(actor, VW_HAJLEKTALAN_SZALLO);
		ApplyActorAnimation(actor, "CRACK", "CRCKIDLE2", 4.0, 1, 0, 0, 0, 0);
	}
}

fpublic OnPreConfigurationComplete(playerid)
{
	// set money
	GivePlayerMoney(playerid, (PlayerInfo[playerid][pID] * -1) - GetPlayerMoney(playerid));
}

fpublic OnPlayerActivityChanged(playerid, type, oldValue, newValue)
{
	#if defined SYSTEM_BONUS
	if(type == STAT_ACTIVITY_IDO)
	{
		new count = (newValue / BONUS_ACTIVITY_PLAYER);
		new splitVal = (count * BONUS_ACTIVITY_PLAYER);
		if(/*count == 1 &&*/ oldValue < splitVal && newValue >= splitVal)
		{
			SendClientMessage(playerid, COLOR_LIGHTBLUE, "==========[ Láda ]==========");
			SendClientMessage(playerid, COLOR_LIGHTBLUE, "Gratulálunk! Aktivitásodért kaptál egy ládát!");
			GiveRandomToken(playerid, BONUS_REASON_ACTIVITY_PLAYER);
		}
	}
	else if(type == STAT_ACTIVITY_ONDUTY)
	{
		new count = (newValue / BONUS_ACTIVITY_ADMIN);
		new splitVal = (count * BONUS_ACTIVITY_ADMIN);
		if(/*count == 1 &&*/ oldValue < splitVal && newValue >= splitVal)
		{
			SendClientMessage(playerid, COLOR_LIGHTBLUE, "==========[ Láda ]==========");
			SendClientMessage(playerid, COLOR_LIGHTBLUE, "Gratulálunk! Admin aktivitásodért kaptál egy ládát és egy kulcsot!");
			GiveRandomToken(playerid, BONUS_REASON_ACTIVITY_ADMIN);
			PlayerInfo[playerid][pLadaKulcs] += 1;
		}
	}
	#endif
	
	return 1;
}

public OnQueryError( errorid, const error[], const callback[], const query[], MySQL:handle )
{
    new sqlerror[128];
	if(errorid == 1062) {
		format(sqlerror, 128, "MySQL Hiba történt. Részletek a logban (Duplikáció #%d)", errorid);
	} else {
	    format(sqlerror, 128, "MySQL Hiba történt. Részletek a logban (#%d)", errorid);
	}
	
	printf("[debug] SQL Error: [%d]%s - query: %s", errorid, error, query);
	ABroadCast(COLOR_LIGHTRED, sqlerror, 1);
	new entry[5000], fajl[64];

    format(fajl, sizeof(fajl), "Log/MySQL/%s-%s-%s.log", Time("ev"), Time("honap"), Time("nap"));
	format(entry, sizeof(entry), "[%s:%s:%s]-[%d] %s - [query] %s\n", Time("ora"), Time("perc"), Time("mp"), errorid, error, query);

	new File:hFile;
	hFile = fopen(fajl, io_append);
	fwrite(hFile, entry);
	fclose(hFile);
	
	if(errorid == 2006) // gone away
	{
		MySQLProba++;
		if(MySQLProba < 3)
		{
			//mysql_reconnect();
		}
		else
			Stop();
	}
}

public OnGameModeInit()
{
	ServerPort = GetServerVarAsInt("port");
	
	//EnableVehicleFriendlyFire();
	onPause_Init();
	Label_Init();
	
	

	ManualVehicleEngineAndLights();

	Streamer_TickRate(200);
	Streamer_VisibleItems(STREAMER_TYPE_OBJECT, 900);
	
	
	print("Játékmód betöltése folyamatban...");
	new start = tickcount();
	
	for(new c = 0; c < MAX_VEHICLES; c++)//akku
	{
		CarPart[c][cAkkumulator] = 100;
	}
	for(new c = 0; c < sizeof(RosszGas); c++)
	{
		RosszGas[c] = 0;
	}
	
	/*GetServerVarAsString("bind", server_ip, sizeof(server_ip));
	if(HamisSzerver())
	{
		FatalServerStopping();
		GameModeExit();
		return 1;
	}*/
	printf("== Port: %d ==", GetServerVarAsInt("port"));
	//SetPDistance(0);
    DisableInteriorEnterExits();
	EnableStuntBonusForAll(false);
	ShowNameTags(true);
	SetNameTagDrawDistance(250.0);
	DisableNameTagLOS();

	print("Szerver indul...");
	print("MySQL kapcsolódás...");

	//mysql_log(ConfigVal("mysql-debug"));
	mysql_log(ERROR | WARNING);

	//mysql_init(LOG_ALL);
	MysqlKapcsolodas(true);
	print("MySQL kapcsolódás sikeres");

	doQuery( "UPDATE playerek SET Online='0'" );
	doQuery( "DELETE FROM "SQL_DB_Cmd );

    new string[MAX_PLAYER_NAME];
    new string1[MAX_PLAYER_NAME];
	for(new c=0; c<sizeof(Gas); c++)
	{
		Gas[c] = 300;
		Neon[c] = 0;
	}
	LoadBankAdatok();
//	LoadFrakcio();
	SzefToltes();
	LoadIRC();
	LoadInts();
	LoadIgenylesek();
	LoadAjtok();
	LoadBizz();
	LoadHouse();
	LoadAratas();
	LoadBerSzef();
	LoadButor();
	LoadGarazs();
	AllCarSpawn();
	LoadATM();
	LoadAreaforgalom();
	LoadKereskedo();
	LoadKikepzo();
	LoadWar();
	//LoadOBJECT();
	LoadPARKOLO();
	LoadPICKUP();
	PICKUPToltes();
	//LoadRaktar();
	INI_Load(INI_TYPE_FEGYVERRAKTAR);
	INI_Load(INI_TYPE_FRAKCIO);
	INI_Load(INI_TYPE_ALFRAKCIO_POLICE);
	LoadMelleny();
	LoadSwat();
	LoadStuff();
	FekvoRendor();
	LoadRendeles();
	FszMuvelet(2);
	LoterBetoltes();
	TelefonBetoltes();
	LoadRejtekhely();
	LoadWifi();
	LoadHitboxes();
	CreateLaserStuff();
	CreateLaser();
	CreateAjto();
	LoadRobHelyek();
	LoadActors();
	LoadGPS();
	
	TeruletekBetoltese();
	
	AjtoSF[0]= CreateDynamicPickup(1318,23,2169.9451,1589.8287,999.9761,1555,1,NINCS);
	AjtoSF[1]= CreateDynamicPickup(1318,23,2319.246, -1.239, 26.749,1555,0,NINCS);
	
	//ideide
	
	for(new b = 0; b < MAX_OBJECTSZ; b++)
	{
		new file[64];
		format(file, 64, "data/objectek/%d.ini", b);
				
		if(fexist(file))
			INI_ParseFile(file, "INI_LOAD_ObjectDATA", .bExtra = true, .extra = b);
	
		if(OBJECT[b][sTipus] != NINCS && OBJECT[b][sTipus] != 0)
			OBJECT[b][sObjectID] = CreateDynamicObject(OBJECT[b][sTipus], OBJECT[b][sPosX], OBJECT[b][sPosY], OBJECT[b][sPosZ], OBJECT[b][sPosZX], OBJECT[b][sPosZY], OBJECT[b][sPosA],OBJECT[b][sVw],OBJECT[b][sInt]);
	}
	for(new b = 0; b < MAX_OBJECTSZ; b++)
	{
		new file[64];
		format(file, 64, "data/objectek/torol_%d.ini", b);
				
		if(fexist(file))
			INI_ParseFile(file, "INI_LOAD_Object_Torol_DATA", .bExtra = true, .extra = b);
	}
	for(new b = 0; b < MAXGRAFFITI; b++)
	{
		new file[64];
		format(file, 64, "data/graffiti/%d.ini", b);
		
		if(fexist(file))
			INI_ParseFile(file, "INI_LOAD_GraffitiDATA", .bExtra = true, .extra = b);
		
		if(Graffiti[b][gVId] > 0 || b == 0)
		{
			new graf[128];
			format(graf, 128, "{%s}%s", Graffiti[b][gColor], Graffiti[b][gSzoveg]);
			
			Graffiti[b][gVan] = true;
			Graffiti[b][gObject] = CreateDynamicObject(19482, Graffiti[b][gPosX], Graffiti[b][gPosY], Graffiti[b][gPosZ], Graffiti[b][gPosRX], Graffiti[b][gPosRY], Graffiti[b][gPosRZ], 0, 0);
			SetDynamicObjectMaterialText(Graffiti[b][gObject], 0, graf, OBJECT_MATERIAL_SIZE_256x256, Graffiti[b][gFont], Graffiti[b][gSize], 0, 0xFFFFFFFF, 0, 1);
		}
		
	}
			
	if(BizzInfo[BIZ_LOTER][bLocked] == 1)
	{
		BizzInfo[BIZ_LOTER][bLocked] = 0;
	}
	for(new b = 0; b < MAX_BENZINKUT; b++)
	{
		//BenzinKút betöltése
		new file[64];
		format(file, 64, "data/kut/%d.ini", b);
				
		if(fexist(file))
			INI_ParseFile(file, "INI_Load_KutData", .bExtra = true, .extra = b);
		//===================	
		if(BenzinKutak[b][bBenzinAra] < 300)
		{
			BenzinKutak[b][bBenzinAra] = 300;
		}
		if(BenzinKutak[b][bDieselAra] < 300)
		{
			BenzinKutak[b][bDieselAra] = 300;
		}
		if(BenzinKutak[b][bKerozinAra] < 400)
		{
			BenzinKutak[b][bKerozinAra] = 400;
		}
	}
	IRCInfo[0][iPlayers] = 0; IRCInfo[1][iPlayers] = 0; IRCInfo[2][iPlayers] = 0;
	IRCInfo[3][iPlayers] = 0; IRCInfo[4][iPlayers] = 0; IRCInfo[5][iPlayers] = 0;
	IRCInfo[6][iPlayers] = 0; IRCInfo[7][iPlayers] = 0; IRCInfo[8][iPlayers] = 0;
	IRCInfo[9][iPlayers] = 0;
	News[hTaken1] = 0; News[hTaken2] = 0; News[hTaken3] = 0; News[hTaken4] = 0; News[hTaken5] = 0;
	format(string, sizeof(string), "Nothing");
	strmid(News[hAdd1], string, 0, strlen(string), 255);
	strmid(News[hAdd2], string, 0, strlen(string), 255);
	strmid(News[hAdd3], string, 0, strlen(string), 255);
	strmid(News[hAdd4], string, 0, strlen(string), 255);
	strmid(News[hAdd5], string, 0, strlen(string), 255);
	format(string1, sizeof(string1), "No-one");
	strmid(News[hContact1], string1, 0, strlen(string1), 255);
	strmid(News[hContact2], string1, 0, strlen(string1), 255);
	strmid(News[hContact3], string1, 0, strlen(string1), 255);
	strmid(News[hContact4], string1, 0, strlen(string1), 255);
	strmid(News[hContact5], string1, 0, strlen(string1), 255);
	SetGameModeText(modnev);
	SetMapName(mapnev);

	new motd[128];
	format(motd, sizeof(motd), "Szerver: Üdvözöllek a Class RPG-n, jó szórakozást kívánunk!");
	gettime(ghour, gminute, gsecond);
	FixHour(ghour);
	ghour = shifthour;
	if(!realtime)
	{
		//SetWorldTime(wtime);
		IdoAllitas(wtime);
	}
	//EnableZoneNames(1);
	AllowInteriorWeapons(1);
	//AllowAdminTeleport(1);
	//UsePlayerPedAnims();
	SetNameTagDrawDistance(50);
	for(new k = 0; k < MAX_VEHICLES; k++)
	{
	    VanBombaBenne[k] = NINCS;
	}
	for(new v = 0; v < MAXVSKOCSI; v++)
	{
		Matrica[v] = 3;
	}
	// CreatedCars check
	for(new i = 0; i < sizeof(CreatedCars); i++)
	{
	    CreatedCars[i] = 0;
	}
	// Zones
	/*for(new i = 0; i < sizeof(TurfInfo); i++)
	{
	    Turfs[i] = GangZoneCreate(TurfInfo[i][zMinX],TurfInfo[i][zMinY],TurfInfo[i][zMaxX],TurfInfo[i][zMaxY]);
	}*/
	// Player Class's
	for(new i = 1; i < MAX_SKIN; i++)
	{
		if(!SkinData[i])
			AddPlayerClass(i, 1958.3783,1343.1572,1100.3746,269.1425, 0, 0, 0, 0, 0, 0);
	}
	for(new i = 0; i < sizeof(NPCKocsi); i++)
		NPCKocsi[i] = false;
	for(new i = 0; i < MAX_VEHICLES; i++)
		Lopott[i] = false;
	Ninjaengedely = false;
	FeketeRadar = GangZoneCreate(-2999.0, -2999.0, 2999.0, 2999.0);
	//================================= Kapuk ===========================//
	LSPD = true;
	SFPD = true;
	HusvetiEvent = false;

	for(new a=0; a<MAX_FIXTRAFI; a++)
		FixTrafi[a][fxID] = NINCS;
		
	for(new i=0; i<MAX_REPORTS; i++)
	{
		Report[i][rID] = NINCS;	
		Report[i][rNev] = EOS;	
		Report[i][rSzoveg] = EOS;	
		Report[i][rChannel] = NINCS;	
		Report[i][rSQLID] = NINCS;	
	}
	

	//Ideide

	/*LSPDKapu[1] = CreateDynamicObject(980, 1547.3752441406, -1627.8746337891, 15.156204223633, 0, 0, 90);
	LSPDAjto[0] = CreateDynamicObject(1495, 244.92448425293, 72.571937561035, 1002.640625, 0, 0, 0);
	LSPDAjto[1] = CreateDynamicObject(1495, 247.93836975098, 72.613395690918, 1002.640625, 0, 0, 179.99450683594);
	LSPDAjto[2] = CreateDynamicObject(1495, 244.8291015625, 74.322265625, 1002.8529663086, 0, 0, 90);
	LSPDAjto[3] = CreateDynamicObject(1495, 244.80000305176, 77.2890625, 1002.8547363281, 0, 0, 270);
	LSPDAjto[4] = CreateDynamicObject(1495, 248, 74.330642700195, 1002.640625, 0, 0, 90);
	LSPDAjto[5] = CreateDynamicObject(1495, 247.9700012207, 77.340270996094, 1002.640625, 0, 0, 270);*/


    FBILift[0] = CreateDynamicObject(18755, -1386.4052734375, -175.3232421875, 15.199687004089, 0, 0, 65);
    FBILift[1] = CreateDynamicObject(18756, -1386.4638671875, -175.35809326172, 26.440265655518, 0, 0, 65);
    FBILift[2] = CreateDynamicObject(18757, -1386.4593505859, -175.35487365723, 26.440265655518, 0, 0, 65);
    FBILift[3] = CreateDynamicObject(18756, -1384.7703857422, -176.16192626953, 15.157948493958, 0, 0, 65);
    FBILift[4] = CreateDynamicObject(18757, -1388.0495605469, -174.60585021973, 15.157948493958, 0, 0, 65);
	

	//swatkapu1 = CreateDynamicObject(976, 1626.2834472656, -1856.1879882813, 12.547634124756, 0, 0, 182); 
	swatkapu1 = CreateDynamicObject(2990, 1621.47375, -1856.35315, 16.36366,   0.00000, 0.00000, 0.00000);
 	CreateDynamicObject(973, -1695.534424, 689.405762, 24.730844, 0.0000, 0.0000, 0.0000);
	CreateDynamicObject(973, -1686.182373, 689.409790, 24.730844, 0.0000, 0.0000, 0.0000);


	// alcatraz cellák
	for(new i=0; i<sizeof(fortKapuBal); i++)
	{
		fortKapuBalObj[i] = CreateDynamicObject(2930, fortKapuBal[i][0], fortKapuBal[i][1], fortKapuBal[i][2], fortKapuBal[i][3], fortKapuBal[i][4], fortKapuBal[i][5], 126, 0);
	}
	for(new i=0; i<sizeof(fortKapuJobb); i++)
	{
		fortKapuJobbObj[i] = CreateDynamicObject(2930, fortKapuJobb[i][0], fortKapuJobb[i][1], fortKapuJobb[i][2], fortKapuJobb[i][3], fortKapuJobb[i][4], fortKapuJobb[i][5], 126, 0);
	}
	
	// alcatraz udvar
	audvar = CreateDynamicObject(5856, 1382.17554, 1503.19678, 10.97000,   0.00000, 0.00000, 0.00000);


	GSFAjto = CreateDynamicObject(1498, 2118.1401367188, -2274.5935058594, 19.677122116089, 0, 0, 315);

	OnkormanyzatAjto[0] = CreateDynamicObject(1505, 353.48245239258, 165.39109802246, 1024.7963867188, 0, 0, 0);

	//Kereskedõ
	KereskedoKapu = CreateDynamicObject(980, -1697.0, 23.0, 5.328079, 0.000000, 0.000000, 314.829987);
	KereskedoKapuHQn = CreateDynamicObject(980, -2017.732178, -261.280273, 37.093704, 0.0000, 0.0000, 0.0000);



	Katonacsatorna = CreateDynamicObject(980, -977.00042724609, -436.6813659668, 18.968152999878, 0, 0, 359.24194335938);
	DeanObject[0] = CreateDynamicObject(986, -670.34442138672, 966.6923828125, 12.099822998047, 0, 0, 88.75);

	//FBI kapuk
	//Fbibelso = CreateDynamicObject(2634, 1780.56824, -1298.08557, 13.70000, 0, 0, 307.70001);
	Fbilezaro1 =CreateDynamicObject(974, 1786.58167, -1301.24500, 9.00000, 0, 0, 0);
	Fbilezaro2 = CreateDynamicObject(987, 1790.85022, -1295.70972, 5.00000, 0, 0, 180.0);
	Fbilezaro3 = CreateDynamicObject(987, 1799.87952, -1295.73022, 5.33860, 0, 0, 180.0);

	BankAjto = CreateDynamicObject(2634, 2144.1845703125, 1627.1131591797, 994.28723144531, 0, 0, 180.63439941406);

	//nav
	SFPDKapu[0] = CreateDynamicObject(2990, -2437.47, 494.53, 31.19,   0.00, 0.00, 384.90);
	SFPDKapu[1] = CreateDynamicObject(2990, -2429.23, 498.23, 31.19,   0.00, 0.00, 23.40);

	//lsbank
	//LsBankKapu=CreateDynamicObject(2634, 1931.56549229, -2435.53287467, 14.6419142578,  0.0000,  0.0000,  -20.0000, 1555); régi
	LsBankKapu=CreateDynamicObject(2634, -1156.06, -212.17, 14.66,  0.0000,  0.0000,  -0.85, 1555);




    gMap = TextDrawCreate(147.000000, 50.000000, "samaps:map");
	TextDrawBackgroundColor(gMap, 255);
	TextDrawFont(gMap, 4);
	TextDrawLetterSize(gMap, 0.500000, 1.000000);
	TextDrawColor(gMap, -1);
	TextDrawSetOutline(gMap, 0);
	TextDrawSetProportional(gMap, 1);
	TextDrawSetShadow(gMap, 1);
	TextDrawUseBox(gMap, 1);
	TextDrawBoxColor(gMap, 255);
	TextDrawTextSize(gMap, 350.000000, 350.000000);

	TuzInfo[0] = TextDrawCreate(90, 290, "T«zriad¦");
	TextDrawAlignment(TuzInfo[0], 2);
	TextDrawFont(TuzInfo[0], 1);

	TextDrawColor(TuzInfo[0], COLOR_RED); // COLOR_BLACK
	TextDrawBackgroundColor(TuzInfo[0], COLOR_WHITE);

	TextDrawSetOutline(TuzInfo[0], 1);
	TextDrawSetShadow(TuzInfo[0], 1);

	TextDrawLetterSize(TuzInfo[0], 1.0, 2.0);

	//TextDrawUseBox(TuzInfo[0], 1);
	//TextDrawBoxColor(TuzInfo[0], 0x05050555);
	//TextDrawTextSize(TuzInfo[0], 0, 120); // x = y, y = szélesség

	TuzInfo[1] = TextDrawCreate(90, 315, "+?Ft~n~~g~??:??"); // az elõzõhez képest +17 y
	TextDrawAlignment(TuzInfo[1], 2);
	TextDrawFont(TuzInfo[1], 1);

	TextDrawColor(TuzInfo[1], COLOR_DARKBLUE);
	TextDrawBackgroundColor(TuzInfo[1], COLOR_WHITE);

	TextDrawSetOutline(TuzInfo[1], 1);
	TextDrawSetShadow(TuzInfo[1], 1);

	TextDrawLetterSize(TuzInfo[1], 0.5, 1.2);

	//TextDrawUseBox(TuzInfo[1], 1);
	//TextDrawBoxColor(TuzInfo[1], 0x05050555);
	//TextDrawTextSize(TuzInfo[1], 0, 120);

	TuzInfo[2] = TextDrawCreate(320, 400, "T«zolt?s folyamatban"); // az elõzõhez képest +17 y
	TextDrawAlignment(TuzInfo[2], 2);
	TextDrawFont(TuzInfo[2], 1);

	TextDrawColor(TuzInfo[2], COLOR_RED);
	//TextDrawBackgroundColor(TuzInfo[2], COLOR_WHITE);
	//TextDrawSetShadow(TuzInfo[2], 1);
	//TextDrawSetOutline(TuzInfo[2], 1);

	TextDrawLetterSize(TuzInfo[2], 0.9, 2.0);

	resitd = TextDrawCreate(565, 3, "CarResi!");
	TextDrawAlignment(resitd, 2);
	TextDrawFont(resitd, 1);
	TextDrawLetterSize(resitd, 0.4, 1.2);
	TextDrawColor(resitd, 0xFF0000FF);
	TextDrawSetShadow(resitd, 1);
	TextDrawSetOutline(resitd, 1);
	
	resiszerver = TextDrawCreate(515, 3, "SzerverResi!");
	TextDrawAlignment(resiszerver, 2);
	TextDrawFont(resiszerver, 1);
	TextDrawLetterSize(resiszerver, 0.4, 1.2);
	TextDrawColor(resiszerver, 0xFF0000FF);
	TextDrawSetShadow(resiszerver, 1);
	TextDrawSetOutline(resiszerver, 1);

	FeketesegTD= TextDrawCreate(0, 0, "~b~");
	TextDrawTextSize(FeketesegTD, 640, 480);
	TextDrawLetterSize(FeketesegTD,0.0,50.0);
	TextDrawUseBox(FeketesegTD , 1);
	TextDrawBoxColor(FeketesegTD, 0x000000FF);

	zerotd = TextDrawCreate(86, 327, "Zero Tolerancia!");
	TextDrawAlignment(zerotd, 2);
	TextDrawFont(zerotd, 1);
	TextDrawLetterSize(zerotd, 0.4, 1.2);
	TextDrawColor(zerotd, 0xFF0000FF);
	TextDrawSetShadow(zerotd, 1);
	TextDrawSetOutline(zerotd, 1);

	

	//utoker pick
    UjPickup(1239, 23, -1523.176, 17.085, 86.355);
	//Fort be / ki
	UjPickup(1318, 23, 135.465728, 1946.600585, 19.359313);
	UjPickup(1318, 23, 135.642883, 1934.607543, 19.258510);

	//Fort be / ki 2 a katona hq fele
	UjPickup(1318, 23, 291.151, 1821.415, 17.640);
	UjPickup(1318, 23, 279.645, 1821.550, 17.640);

	//Autóparkoló be / ki >> Oktató HQ
	UjPickup(1318, 23, 2491.210449, 2773.332519, 10.798006);
	UjPickup(1318, 23, 2503.887207, 2773.661376, 10.820312);

	UjPickup(1239, 23, 215.038833, 1862.826782, 13.140625);

	UjPickup(1279, 23, 2543.095703, -1290.998779, 1044.125000); // Drog pickup a gyárban, a droghoz
	UjPickup(1279, 23, 2555.9519,-1291.0038,1044.1250); // M4 pickup a gyárban, a matihoz
	UjPickup(1279, 23, 2560.0454,-1283.8326,1044.1250); // M4 pickup a gyárban, a matihoz
	UjPickup(1279, 23, 2552.0381,-1283.7162,1044.1250); // M4 pickup a gyárban, a matihoz
	UjPickup(1279, 23, 2544.0610,-1283.6829,1044.1250); // M4 pickup a gyárban, a matihoz
	
	UjPickup(356, 23, 2543.111328, -1295.866333, 1044.125000); // M4 pickup a gyárban, a matihoz
	UjPickup(356, 23, 2560.0732,-1303.5065,1044.1250); // Drog pickup a gyárban, a droghoz
	UjPickup(356, 23, 2552.0959,-1303.6090,1044.1250); // Drog pickup a gyárban, a droghoz
	UjPickup(356, 23, 2544.0491,-1303.6232,1044.1250); // Drog pickup a gyárban, a droghoz
	UjPickup(356, 23, 2556.0754,-1295.8505,1044.1250); // Drog pickup a gyárban, a droghoz

	UjPickup(1239, 23, 362.639312, 169.937469, 1025.789062); //VH munka

	UjPickup(1239, 23, 691.2158,-1276.0931,13.5605); // yakuza
	UjPickup(1239, 23, 246.4178,87.9876,1003.6406); // pd
    UjPickup(1239, 23, 1526.9127,-1677.7935,5.8906); // pd

	//UjPickup(1242, 2, 202.3766,1861.6320,13.1406); // ng armor
  	UjPickup(1240, 2, 202.5629,1859.7087,13.1406); // ng health
  	UjPickup(1242, 2, 261.6862,71.2168,1003.2422); // PD armor

	//UjPickup(1239, 23, 1173.2563,-1323.3102,15.3943); //Hospital 1 near Ammu
	UjPickup(1239, 23, 2029.5945,-1404.6426,17.2512); //Hospital 2 near speedway
	UjPickup(1239, 23, 253.9280,69.6094,1003.6406); //Clear icon in Police Station
	//UjPickup(1239, 23, -1606.3289,675.3354,-5.2422); //SFPD Arrest ikon(i)
	UjPickup(1239, 23, 2277.637207, 2425.318359, 3.476562); //LVPD MDC ikon(i)
	//UjPickup(1239, 23, 1381.0413,-1088.8511,27.3906); //Bill Board (old Job Department)
	UjPickup(371, 23, 1544.2,-1353.4,329.4); //LS towertop
	UjPickup(371, 23, 1536.0, -1360.0, 1150.0); //LS towertop
	//UjPickup(1239, 23, 2035.1941,-1304.8467,20.9037); // Los Aztecas Hq enter
	UjPickup(1239, 23, 258.4913,-41.5296,1002.0234); // Los Aztecas Hq enter
	//UjPickup(1239, 23, 2193.072265, 2792.155761, 10.820312); // LV mûanyag
	//UjPickup(1318, 23, 1643.5533,-1523.0732,13.5588); // LS Tuning Bejárat
	//UjPickup(1318, 23, -2089.8782,95.2754,35.3203); // SF Tuning Bejárat
	UjPickup(1239, 23, 362.3623,209.2845,1008.3828); // Útlevél Megvétele
	UjPickup(1239, 23, 354.9763,154.1686,1025.7964); // Adó befizetés
	UjPickup(1239, 23, 363.1144,152.3946,1025.7964); // Adó ellenõrzés
/*
	UjPickup(1239, 23, -2047.288, -91.537, 35.171); // Kereskedõ HQ
	UjPickup(1239, 23, -2046.842, -115.706, 35.239); // Kereskedõ HQ
	*/
//	UjPickup(1239, 23, 1465.222900, -1010.950683, 26.843750); //LS Bank
//	UjPickup(1239, 23, 1462.3811,-1011.8452,26.8438); //LS Bank
//	UjPickup(1239, 23, -1942.973876, 556.252868, 35.171875); //SF Bank
	/*UjPickup(1239, 23, 226.7355,122.7866,999.0410); // Vpop duty
	UjPickup(1239, 23, 734.2736,-1351.9012,13.5000);// Vpop átszállító

	UjPickup(1239, 23, 1829.1796,-1109.0520,23.8951); // FBI Szállító és arrest hely a garázsnál*/
	UjPickup(1239, 23, -1017.8073,-683.6983,32.0078); //Fegyenctelep

	//AddStaticPickup(1247, 23, 555.087768, -2197.163818, 1.501912); // Sona fegyenclerakó * sárga csillag

	pickups=pickups+29;
	printf("Pickups Max = 100, Current Pickups = %d",pickups);
	if (realtime)
	{
		new tmphour;
		new tmpminute;
		new tmpsecond;
		gettime(tmphour, tmpminute, tmpsecond);
		FixHour(tmphour);
		tmphour = shifthour;
		//SetWorldTime(tmphour - IDOHOZZAADAS);
		IdoAllitas(tmphour);
	}

	//timm
	Timerek[0] = SetTimer("CheckGas", RunOutTime, 1);
    Timerek[1] = SetTimer("StoppedVehicle", RunOutTime, 1);
	Timerek[2] = SetTimer("RandomHirdetes", (hirdetesidokoz * 1000), 1);
	Timerek[3] = SetTimer("BackupTimer", (BackTime*1000), 1);

	Timerek[4] = SetTimer("TextDrawUpdateAll", 900, 1);

	Timerek[5] = SetTimer("OtherTimer", 1000, 1);
	Timerek[6] = SetTimer("EgyebTimer", 1000, 1);
	Timerek[7] = SetTimer("SetPlayerUnjail", 1000, 1);
	Timerek[8] = SetTimer("EletTimer", 1000, 1);
	Timerek[9] = SetTimer("CustomPickups", 3000, 1);
	//Timerek[10] = SetTimer("Spectator", 1000, 1);
	
	Timerek[11] = SetTimer("TeleTimer", 2000, 1);
	Timerek[12] = SetTimer("MunkaTimer", 2000, 1);
	Timerek[13] = SetTimer("Drog", 2000, 1);

	Timerek[14] = SetTimer("AfkChecker", 5000, 1);

	//Timerek[15] = SetTimer("MysqlEllenorzes", 10000, 1);

	Timerek[16] = SetTimer("PayDay", 30000, 1);
	Timerek[17] = SetTimer("CarCheck", 30000, 1);

	Timerek[18] = SetTimer("SyncUp", 60000, 1);//60000

	Timerek[19] = SetTimer("Production", 300000, 1);

	Timerek[20] = SetTimer("IdojarasValtozas", 900000, 1); //900000

	Timerek[21] = SetTimer("MySQLUpdater", 900000, 1);

	Timerek[22] = SetTimer("RaceTimer", 1000, 1);
	Timerek[23] = SetTimer("Hatar", 1000, 1);
	Timerek[24] = SetTimer("SecTimer", 1000, 1);
	Timerek[25] = SetTimer("NPCTimer", 1000, 1);
	Timerek[26] = SetTimer("ClientTimer", 5000, 1);
	
	//Timerek[26] =SetTimer("ScanTimer",200,1);

	//Timerek[26] =SetTimer("FekvoRendor",400,1);
	//Timerek[27] = SetTimer("SebessegKorlatozo", 50, 1);

	//Timerek[] = SetTimer("", 000, 1);

//	sonatimer = SetTimer("SonaFigyelo", 5000, 1);

	if(ServerPort != DEVMODE_PORT || DEVMODE_NPC)
		NPCBetoltese();

	LoadRadio();
	KapuAkcio();

	TuzAkcio();
	KincsAkcio();
	KincsAkcio( KINCS_INDIT );
	GyemantAkcio();
	TojasAkcio();

	LoadArak();
	
    InfoPickup = CreateDynamicPickup(1239, 23, -1970.8292, -2432.2322, 30.6250, 0, 0);

	new
		fa = -1
	;
	for(;++fa < MAX_FA;)
	{
		FaAdatok[fa][faposx] = 0.0;
		FaAdatok[fa][faposy] = 0.0;
		FaAdatok[fa][faposz] = -10.0;
		FaAdatok[fa][faplayerid] = -1;
		FaAdatok[fa][fahasznalva] = false;
	}

	for(new x = 0; x < MAX_CHANNEL; x++)
	{
		ReportChannel[x][rMaxPlayers] = CHANNEL_PLAYERS;
		ReportChannel[x][rTimeOut] = CHANNEL_TIMEOUT;

		if(x == 0) strmid(ReportChannel[x][rTitle], "Adminsegédek", 0, 12, 40);
		else if(x == 1) strmid(ReportChannel[x][rTitle], "Adminok", 0, 7, 40);
		else if(x == 2) strmid(ReportChannel[x][rTitle], "Fõadminok", 0, 9, 40);
		else if(x == 3) strmid(ReportChannel[x][rTitle], "Scripterek", 0, 12, 40);
		else
		{
			strmid(ReportChannel[x][rTitle], "-----", 0, 4, 40);
			ReportChannel[x][rClosed] = 1;
		}
	}

	RioZene = "";
	MoriartyZene = "";
	RiporterZene = "";
	SendRconCommand("rcon 0");
	//SendRconCommand("loadfs Objectek");
	LoadVersion();
	LetszamFrissites();
	LeaderFrissites();

	UpdatePerSec[uPlayer] = 15;
	UpdatePerSec[uHaz] = 15;
	UpdatePerSec[uGarazs]=15;
	UpdatePerSec[uKocsi] = 15;
	UpdatePerSec[uBiz] = 15;
	UpdatePerSec[uTerulet] = 15;

	UpdateFolytatodik[uPlayer] = NINCS;
	UpdateFolytatodik[uHaz] = NINCS;
	UpdateFolytatodik[uGarazs] = NINCS;
	UpdateFolytatodik[uKocsi] = NINCS;
	UpdateFolytatodik[uBiz] = NINCS;
	UpdateFolytatodik[uTerulet] = NINCS;
	ResiKukaFrissites = true;
	Csendvan = false;
	ModBetoltve = 1;
	OnModBetoltve();
	
	printf("start ido: %dms", tickcount() - start);
	
	CheckClassClient();
	
	
	/*if(UnixTime < 1388966400)
		GetFreeGiftPos();*/
	return 1;
}