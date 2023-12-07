#if defined __game_function_function_other
	#endinput
#endif
#define __game_function_function_other

stock BuyFuggveny(playerid)
{
	//Msg(playerid,"Buyfugveny");
	if(PlayerToPoint(100, playerid,-30.875, -88.9609, 1004.53))
	{	
		if(MunkaFolyamatban[playerid]) return Msg(playerid, "Jelenleg nem vásárolhatsz semmit!");
		new szoveg[750], id;
		while(id < sizeof(BuyCuccok))
		{
			if(id == 0) format(szoveg, 750, "%s", BuyCuccok[0]);
			else format(szoveg, 750, "%s\n%s", szoveg, BuyCuccok[id]);
			id++;
		}

		ShowPlayerDialog(playerid, DIALOG_VESZ, DIALOG_STYLE_LIST, "24/7", szoveg, "Megvesz", "Mégse");
		TogglePlayerControllable(playerid, false);
		Cselekves(playerid, "nézelodik", 1);
		return 1;
		
	}
	else if(PlayerToPoint(100, playerid, 1347.6865,1328.8383,10.8400) && (GetPlayerVirtualWorld(playerid) == 124 || GetPlayerVirtualWorld(playerid) == 135 && GetPlayerInterior(playerid) != 16))
	{
		ShowPlayerDialog(playerid, DIALOG_AVESZ, DIALOG_STYLE_LIST, "Autósbolt", "Vontatókötél - 3.000Ft\nAkkumulátortölto(egyszerhasználatos) - 40.000Ft\nGPS Lokátor - 25.000Ft\nBikázó kábel - 20.000Ft\nSzerszámosláda - 50.000Ft\nMotorolaj(egyszerhasználatos) - 20.000 Ft\nFestékszóró - 15.000Ft", "Megvesz","Mégse");
		Cselekves(playerid, "nézelodik", 1);
		return 1;
	}
	else if(PlayerToPoint(50, playerid, 1335.5967, 1373.4138, 12.4695) && (GetPlayerInterior(playerid) == 16 && GetPlayerVirtualWorld(playerid) != 124 || GetPlayerVirtualWorld(playerid) != 135 || GetPlayerVirtualWorld(playerid) != 0))
	{
	
		ShowPlayerDialog(playerid, DIALOG_GYVESZ, DIALOG_STYLE_LIST, "Gyógyszertár", "Aspirin(10 DB hp +10/db) - 8.000Ft\nCataflan(10 DB hp +20/db)- 12.000Ft\n ", "Megvesz","Mégse");
		Cselekves(playerid, "nézelodik", 1);
		return 1;
	}
	

	return 0;
}

stock GetRandomHomelessSkin()
{
	switch(random(9))
	{
		case 0: return 77;
		case 1: return 78;
		case 2: return 79;
		case 3: return 134;
		case 4: return 135;
		case 5: return 137;
		case 6: return 212;
		case 7: return 230;
		case 8: return 239;
	}
	
	return 77;
}

stock GetPlayerCameraLookAt(playerid, &Float:x, &Float:y, &Float:z, Float:scale = 5.0)
{
	new Float:camPos[3], Float:camVector[3];
	GetPlayerCameraPos(playerid, ArrExt(camPos));
	GetPlayerCameraFrontVector(playerid, ArrExt(camVector));
	
	x = camPos[0] + floatmul(camVector[0], scale);
	y = camPos[1] + floatmul(camVector[1], scale);
	z = camPos[2] + floatmul(camVector[2], scale);
}

stock IsValidHouse(houseid)
{
	if(houseid < 0 || houseid >= MAXHAZ || !HouseInfo[houseid][Van])
		return false;
	
	return true;
}

stock CancelDynamicEdit(playerid, objectid)
{
	CallLocalFunction("OnPlayerEditDynamicObject", "dddffffff", playerid, objectid, EDIT_RESPONSE_CANCEL, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
	CancelEdit(playerid);
	return 1;
}

stock FixHour(hour)
{
	if (hour < 0)
	{
		hour = hour+24;
	}
	else if (hour > 23)
	{
		hour = hour-24;
	}
	shifthour = hour;
	return 1;
}
stock RoncsDerbiTorles(playerid)
{

	new rkocsi;
	RoncsDerby[playerid][rdVersenyez] = false;
	
	
	rkocsi = DerbiKocsi[RoncsDerby[playerid][rdSlot]];
	DerbiKocsi[RoncsDerby[playerid][rdSlot]] = NINCS;

	DestroyVehicle(rkocsi);
	
	SetPlayerHealth(playerid, 150.0);
	
	Tele(playerid,-2110.9934,-444.3106,38.7344,false,0,0);
	TogglePlayerControllable(playerid, 1);
	SetTimerEx("WarSegit", 5000, false, "i", playerid);
	return 1;

}
stock KocsiLopasListaGenerator()
{
	print("============= KocsiLopasListaGenerator KEZD============");
	
	for(new xx = 1; xx < 15; xx++)
	{
		new szamol;
		for(new model=0;model < MAX_JARMUARA; model++)
		{
			
			new kocsiara = JarmuAra[model][jAra];
			if(kocsiara < xx*KOCSI_LOPAS_SZORZO && kocsiara >= (xx-1)*KOCSI_LOPAS_SZORZO && kocsiara > 100000 && !CarMunkaTilt(model+400))
				szamol++;
		}
		for(new r = 0; r < 8; r++)
		{
			
			new rand = random(szamol);
			new i=0;
			for(new model=0;model < MAX_JARMUARA; model++)
			{
				
				new kocsiara = JarmuAra[model][jAra];
				if(kocsiara < xx*KOCSI_LOPAS_SZORZO && kocsiara >= (xx-1)*KOCSI_LOPAS_SZORZO && kocsiara > 100000 && !CarMunkaTilt(model+400))
				{
					if(rand == i)
					{
					
						KocsiLopasLista[xx][r][Kmodel] = model+400;
					
						if(kocsiara < 20000)
							KocsiLopasLista[xx][r][Kara] = floatround(float(kocsiara) * 0.1) + random(100000)-40000;
						else if(kocsiara < 8000000)
							KocsiLopasLista[xx][r][Kara] = floatround(float(kocsiara) * 0.025) + random(150000)-50000;
						else if(kocsiara < 18000000)
							KocsiLopasLista[xx][r][Kara] = floatround(float(kocsiara) * 0.019) + random(150000)-100000;
						else
							KocsiLopasLista[xx][r][Kara] = floatround(float(kocsiara) * 0.013) + random(200000)-150000;
						

						if(KocsiLopasLista[xx][r][Kara] < 10000)
							KocsiLopasLista[xx][r][Kara] = random(10000)+2000;
							
						if(KocsiLopasLista[xx][r][Kara] >= 650000)
							KocsiLopasLista[xx][r][Kara] = KocsiLopasLista[xx][r][Kara]/2;
							
						for(new rx = 0; rx < 5; rx++)
						{
							if(KocsiLopasLista[xx][r][Kmodel] == KocsiLopasLista[xx][rx][Kmodel] && r != rx)
							{
								KocsiLopasLista[xx][r][Kmodel] = NINCS;
								KocsiLopasLista[xx][r][Kara] = NINCS;
							
							}
						}
						
						
						printf("Szint: %d hely: %d Kocsi: %d Ára: %s",xx,r,KocsiLopasLista[xx][r][Kmodel],FormatInt(KocsiLopasLista[xx][r][Kara]));
					}
					i++;
				}
				
			}
		}
	
	}
	print("============= KocsiLopasListaGenerator VÉGE============");
	return 1;
}

stock FrakcioAdoStat()
{
	new days_of_month[12] = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
	
	new nap, honap, ev, ora, perc, sec, het;
	getdate(ev, honap, nap);
	gettime(ora, perc, sec);
	het = GetWeekdayNum(nap,honap,ev);
	
	
	
	
	if(((ev % 4 == 0) && (ev % 100 != 0)) || (ev % 400 == 0))
	{
		days_of_month[1] = 29;
	}
	else
	{
		days_of_month[1] = 28;
	}
	//Havi nullázás
	//printf("év: %d hónap: %d nap:%d  óra: %d perc:%d  másodperc: %d hét: %d hónapnapjai: %d ",ev,honap,nap,ora,perc,sec,het,days_of_month[honap-1]);
	if(nap == days_of_month[honap-1] && ora == 23 && perc > 44)
	{
	
		for(new yx; yx < MAX_ADO_FRAKCIO; yx++)
		{
			new id=AdozoFrakciok[yx];
			
			if(FrakcioInfo[id][fHavi] > 10000)
			{
				new szeflog[256];
				format(szeflog,sizeof(szeflog), "[FrakcioSTAT - HAVI]%s HAVI: %s Ft",Szervezetneve[id-1][0],FormatInt(FrakcioInfo[id][fHavi]));
				Log("Scripter",szeflog);
				FrakcioInfo[id][fHavi] = 0;
				format(szeflog,sizeof(szeflog), "év: %d hónap: %d nap:%d  óra: %d perc:%d  másodperc: %d hét: %d hónapnapjai: %d ",ev,honap,nap,ora,perc,sec,het,days_of_month[honap-1]);
				Log("Scripter",szeflog);
			}
		}
	}
	
	
	//Heti nullázás
	if(het == 7 && ora == 23 && perc > 44)
	{
		for(new yx; yx < MAX_ADO_FRAKCIO; yx++)
		{
			new id=AdozoFrakciok[yx];
			
			if(FrakcioInfo[id][fHeti] > 10000)
			{
				new szeflog[128];
				format(szeflog,sizeof(szeflog), "[FrakcioSTAT - HETI]%s Heti: %s Ft",Szervezetneve[id-1][0],FormatInt(FrakcioInfo[id][fHeti]));
				Log("Scripter",szeflog);
				FrakcioInfo[id][fHeti] = 0;
				format(szeflog,sizeof(szeflog), "év: %d hónap: %d nap:%d  óra: %d perc:%d  másodperc: %d hét: %d hónapnapjai: %d ",ev,honap,nap,ora,perc,sec,het,days_of_month[honap-1]);
				Log("Scripter",szeflog);
			}
		}
	}
	return 1;
}
/*
if(weekday == 1){TextDrawSetString(WeekDayg,"Monday");}
        if(weekday == 2){TextDrawSetString(WeekDayg,"Tuesday");}
        if(weekday == 3){TextDrawSetString(WeekDayg,"Wednesday");}
        if(weekday == 4){TextDrawSetString(WeekDayg,"Thursday");}
        if(weekday == 5){TextDrawSetString(WeekDayg,"Friday");}
        if(weekday == 6){TextDrawSetString(WeekDayg,"Saturday");}
        if(weekday == 7){TextDrawSetString(WeekDayg,"Sunday");}
*/

stock GetWeekdayString(nap)
{
	new napnev[24];
	switch(nap)
	{
		case 1: napnev = "Hétfõ";
		case 2: napnev = "Kedd";
		case 3: napnev = "Szerda";
		case 4: napnev = "Csütörtök";
		case 5: napnev = "Péntek";
		case 6: napnev = "Szombat";
		case 7: napnev = "Vasárnap";
		default: napnev = "Hiba";
	}
	return napnev;
}

stock GetWeekdayNum(d,m,y) //by d.wine
{
        m-=2;
        if(m<=0)
                {
                y--;
                m+=12;
                }
        new cen = y/100;
        y=getrem(y,100);
        new w = d + ((13*m-1)/5) + y + (y/4) + (cen/4) - 2*cen;
        w=getrem(w,7);
        if (w==0) w=7;
        return w;
}
stock getrem(a,b) //get remnant of division
{
        new divv = a/b;
        new left = a-b*divv;
        return left;
}
stock RoncsDerbiNullazas()
{
	for(new x; x < MAX_DERBI_KOCSI; x++)
	{
		
		if(DerbiKocsi[x] > 0)
			DestroyVehicle(DerbiKocsi[x]),DerbiKocsi[x]=NINCS;

	}
	
	RoncsDerbi[rFutam] = false;
	RoncsDerbi[rInditva] = false;
	RoncsDerbi[rIndit] = false;
	RoncsDerbi[rNyeremenyOssz] = NINCS;
	RoncsDerbi[rNyeremeny3] = NINCS;
	RoncsDerbi[rNyeremeny2] = NINCS;
	//RoncsDerbi[rNyeremeny1] = NINCS;
	RoncsDerbi[rModel] = NINCS;
	RoncsDerbi[rJatekos] = NINCS;

}
stock RoncsDerbiKieses(playerid)
{

	if(RoncsDerby[playerid][rdVersenyez])
	{
		
		new szamol=0;
		foreach(Jatekosok, x)
		{
		
			if(RoncsDerby[x][rdVersenyez])
				szamol++;
		}
		//extra biztosítás
		RoncsDerbi[rJatekos] = szamol;
		
		RoncsDerby[playerid][rKiesett] = UnixTime+10;
		if(szamol == 3)
		{
			
			SendFormatMessage(playerid,COLOR_YELLOW,"[Roncsderbi] Harmadik lettél, nyereményed %s Ft",FormatInt(RoncsDerbi[rNyeremeny3]));
			foreach(Jatekosok,x)
			{
				SendFormatMessage(x,COLOR_YELLOW,"[Roncsderbi] Harmadik lett %s, nyereménye %s Ft",ICPlayerName(playerid),FormatInt(RoncsDerbi[rNyeremeny3]));
			}
			GiveMoney(playerid,RoncsDerbi[rNyeremeny3]);
			RoncsDerbi[rJatekos]--;
			RoncsDerbiTorles(playerid);
			return 1;
		}	
		else if(szamol == 2)
		{
			SendFormatMessage(playerid,COLOR_YELLOW,"[Roncsderbi] Második lettél, nyereményed %s Ft",FormatInt(RoncsDerbi[rNyeremeny2]));
			foreach(Jatekosok,x)
			{
				SendFormatMessage(x,COLOR_YELLOW,"[Roncsderbi] Második lett %s, nyereménye %s Ft",ICPlayerName(playerid),FormatInt(RoncsDerbi[rNyeremeny2]));
			}
			GiveMoney(playerid,RoncsDerbi[rNyeremeny2]);
			RoncsDerbi[rJatekos]--;
			
			RoncsDerbiTorles(playerid);
			
			foreach(Jatekosok, y)
			{
				SendFormatMessage(y,COLOR_YELLOW,"[Roncsderbi] Elsõ lett %s, nyereménye %s Ft",ICPlayerName(playerid),FormatInt(RoncsDerbi[rNyeremeny1]));
				if(RoncsDerby[y][rdVersenyez])
				{
					SendFormatMessage(y,COLOR_YELLOW,"[Roncsderbi] Elsõ lettél, nyereményed %s Ft",FormatInt(RoncsDerbi[rNyeremeny1]));
					
					GiveMoney(y,RoncsDerbi[rNyeremeny1]);
					
					RoncsDerbiTorles(playerid);
					
					
					RoncsDerbiNullazas();
				}	
			
			}
			return 1;
			
		}
		else
		{
			SendFormatMessage(playerid,COLOR_YELLOW,"[Roncsderbi] Kiestél a futamból, %d lettél",szamol);
			RoncsDerbi[rJatekos]--;
			foreach(Jatekosok, y)
			{
				if(RoncsDerby[y][rdVersenyez] && RoncsDerbi[rInditva])
					SendFormatMessage(y,COLOR_YELLOW,"[Roncsderbi] %s kieset a futamból! %d helyezet lett!",PlayerName(playerid),szamol);
			}
			
			RoncsDerbiTorles(playerid);
			return 1;
		}	
		
		
		
		
		
	}
	return 1;
}

stock IsOOC(szoveg[])
{
	if(strfind(szoveg, "(") != NINCS || strfind(szoveg, ")") != NINCS ||
		strfind(szoveg, "{") != NINCS || strfind(szoveg, "}") != NINCS ||
		strfind(szoveg, "[") != NINCS || strfind(szoveg, "]") != NINCS ||
		strfind(szoveg, "|") != NINCS
	)
		return 1;
	return 0;
}

stock ProxDetector(Float:radi, playerid, string[], col1, col2, col3, col4, col5, bool:kocsitalk = false, nyelv[] = "")
{
	if(IsPlayerConnected(playerid))
	{
		new kocsi = GetPlayerVehicleID(playerid);//, bool:kocsitalk;

		

		new Float:tav, VW = GetPlayerVirtualWorld(playerid), str1[128], str2[128], str3[128], nyelv_nev[32], bool:modositott;
		if(strlen(nyelv) && PlayerInfo[playerid][pANyelv])
		{
			if(0 < PlayerInfo[playerid][pANyelv] <= MAX_NYELV)
			{
				format(nyelv_nev, 32, " %s", Nyelvek[ PlayerInfo[playerid][pANyelv] - 1][1]);
				format(str1, 128, string, nyelv_nev, nyelv); // ismeri a nyelvet + olvassa
				format(str2, 128, string, "", "*** idegennyelv ***"); // nem ismeri a nyelvet + nem olvassa
				format(str3, 128, string, nyelv_nev, "*** idegennyelv ***"); // ismeri a nyelvet, de nem olvassa
				modositott = true;
			}
			else
				PlayerInfo[playerid][pANyelv] = 0;
		}

		foreach(Jatekosok, player)
		{
			
			tav = GetDistanceBetweenPlayers(playerid, player);
			if(GetPlayerVirtualWorld(player) != VW || tav > radi) continue;

			if(!kocsitalk)
			{
				if(radi/16 >= tav) SendClientMessage(player, col1, modositott ? (PlayerInfo[player][pNyelv][ PlayerInfo[playerid][pANyelv] ] >= 100 || AdminDuty[player] ? str1 : (PlayerInfo[player][pNyelv][ PlayerInfo[playerid][pANyelv] ] >= 20 ? str3 : str2)) : string);
				else if(radi/8 >= tav) SendClientMessage(player, col2, modositott ? (PlayerInfo[player][pNyelv][ PlayerInfo[playerid][pANyelv] ] >= 100 || AdminDuty[player] ? str1 : (PlayerInfo[player][pNyelv][ PlayerInfo[playerid][pANyelv] ] >= 20 ? str3 : str2)) : string);
				else if(radi/4 >= tav) SendClientMessage(player, col3, modositott ? (PlayerInfo[player][pNyelv][ PlayerInfo[playerid][pANyelv] ] >= 100 || AdminDuty[player] ? str1 : (PlayerInfo[player][pNyelv][ PlayerInfo[playerid][pANyelv] ] >= 20 ? str3 : str2)) : string);
				else if(radi/2 >= tav) SendClientMessage(player, col4, modositott ? (PlayerInfo[player][pNyelv][ PlayerInfo[playerid][pANyelv] ] >= 100 || AdminDuty[player] ? str1 : (PlayerInfo[player][pNyelv][ PlayerInfo[playerid][pANyelv] ] >= 20 ? str3 : str2)) : string);
				else if(radi >= tav) SendClientMessage(player, col5, modositott ? (PlayerInfo[player][pNyelv][ PlayerInfo[playerid][pANyelv] ] >= 100 || AdminDuty[player] ? str1 : (PlayerInfo[player][pNyelv][ PlayerInfo[playerid][pANyelv] ] >= 20 ? str3 : str2)) : string);
			}
			else if(IsPlayerInVehicle(player, kocsi))
				SendClientMessage(player, col1, ((modositott) ? ((PlayerInfo[playerid][pANyelv] == 0 || PlayerInfo[player][pNyelv][ PlayerInfo[playerid][pANyelv] ] >= 100) ? str1 : str2) : string));
		
		}
	}
	return 1;
}

stock SendMessageByActor(actor, string[], Float:radi, col1 = COLOR_FADE1, col2 = COLOR_FADE2, col3 = COLOR_FADE3, col4 = COLOR_FADE4, col5 = COLOR_FADE5)
{
	new Float:pos[3];
	GetActorPos(actor, ArrExt(pos));
	
	SendMessageByDistance(string, radi, ArrExt(pos), GetActorVirtualWorld(actor), col1, col2, col3, col4, col5);
}

stock SendFormalMessageByActor(actor, name[], string[], Float:radi, col1 = COLOR_FADE1, col2 = COLOR_FADE2, col3 = COLOR_FADE3, col4 = COLOR_FADE4, col5 = COLOR_FADE5)
{
	SendMessageByActor(actor, TFormatInline("%s mondja: %s", name, string), radi, col1, col2, col3, col4, col5);
}

stock SendMessageByPlayer(playerid, string[], Float:radi, col1 = COLOR_FADE1, col2 = COLOR_FADE2, col3 = COLOR_FADE3, col4 = COLOR_FADE4, col5 = COLOR_FADE5)
{
	new Float:pos[3];
	GetPlayerPos(playerid, ArrExt(pos));
	
	SendMessageByDistance(string, radi, ArrExt(pos), GetPlayerVirtualWorld(playerid), col1, col2, col3, col4, col5);
}

stock SendFormalMessageByPlayer(playerid, string[], Float:radi, col1 = COLOR_FADE1, col2 = COLOR_FADE2, col3 = COLOR_FADE3, col4 = COLOR_FADE4, col5 = COLOR_FADE5)
{
	SendMessageByPlayer(playerid, TFormatInline("%s mondja: %s", PlayerInfo[playerid][pNev], string), radi, col1, col2, col3, col4, col5);
}

stock SendMessageByDistance(string[], Float:radi, Float:x, Float:y, Float:z, vw, col1 = COLOR_FADE1, col2 = COLOR_FADE2, col3 = COLOR_FADE3, col4 = COLOR_FADE4, col5 = COLOR_FADE5)
{
	new Float:tav, Float:pos[3];
	foreach(Jatekosok, player)
	{
		GetPlayerPos(player, ArrExt(pos));
		tav = GetDistanceBetweenPoints(ArrExt(pos), x, y, z);
		if(GetPlayerVirtualWorld(player) != vw || tav > radi) continue;
		
		if(radi/16 >= tav)
			SendClientMessage(player, col1, string);
			
		else if(radi/8 >= tav)
			SendClientMessage(player, col2, string);
			
		else if(radi/4 >= tav)
			SendClientMessage(player, col3, string);
			
		else if(radi/2 >= tav)
			SendClientMessage(player, col4, string);
			
		else if(radi >= tav)
			SendClientMessage(player, col5, string);
	
	}
	return 1;
}

stock UresWifi()
{
	for(new i = 0; i < MAXWIFI; i++)
	{
		if(WifiPont[i][wPos][0] == 0.0 && WifiPont[i][wPos][1] == 0.0 && WifiPont[i][wPos][2] == 0.0)
			return i;
	}
	return NINCS;
}

stock Float:GetDistanceToWifiPoint(playerid, wifi)
{
	if(IsPlayerConnected(playerid) && WifiPont[wifi][wPos][0] != 0.0)
	{
		return GetPlayerDistanceFromPoint(playerid, WifiPont[wifi][wPos][0], WifiPont[wifi][wPos][1], WifiPont[wifi][wPos][2]);
	}
	return INF_FLOAT;
}

stock GetClosestWifiPoint(playerid)
{
	if(IsPlayerConnected(playerid))
	{
		new tav = NINCS, Float:distance = 5000.0, Float:dist;
		for(new wifi = 0; wifi < sizeof(WifiPont); wifi++)
		{
			dist = GetDistanceToWifiPoint(playerid, wifi);
			if(dist < distance)
			{
				distance = dist;
				tav = wifi;
			}
		}
		return tav;
	}
	return NINCS;
}

stock GetWifiSignal(playerid, wifi)
{
	if(GetPlayerDistanceFromPoint(playerid, ArrExt(WifiPont[wifi][wPos])) > 100.0)
        return 0;

	new Float:pos[3];
	GetPlayerPos(playerid,ArrExt(pos));

	new Float:distance = GetDistanceBetweenPoints(ArrExt(pos),ArrExt(WifiPont[wifi][wPos]));
	new Float:result = distance-100.0;
	result = abs(floatround(result, floatround_round));

	if(result > 100)
		return 0;
	else
		return abs(floatround(result, floatround_round));
}

stock CreateWifi(Float:x, Float:y, Float:z, vw, int, nev[])
{
	for(new i = 0; i < sizeof(WifiPont); i++)
	{
		if(WifiPont[i][wPos][0] == 0.0 && WifiPont[i][wPos][1] == 0.0 && WifiPont[i][wPos][2] == 0.0)
		{
			WifiPont[i][wPos][0] = x;
			WifiPont[i][wPos][1] = y;
			WifiPont[i][wPos][2] = z;
			WifiPont[i][wVw] = vw;
			WifiPont[i][wInt] = int;
			WifiPont[i][wID] = i;
			_tmpString = "ClassHotSpot_";
			strcat(_tmpString, nev);
			strmid(WifiPont[i][wNev], _tmpString, 0, strlen(_tmpString), 128);
			printf("Wifi hozzáférési pont lerakva - %.1f, %.1f, %.1f | vw: %d | int: %d | %s", WifiPont[i][wPos][0], WifiPont[i][wPos][1], WifiPont[i][wPos][2], WifiPont[i][wVw], WifiPont[i][wInt], WifiPont[i][wNev]);
			break;
		}
	}
	SaveWifi();
}

stock SaveWifi()
{	
	new File:file, id, buff[128];
	file = fopen("Config/wifi.cfg", io_write);
	
	while(id < MAXWIFI)
	{
		if(WifiPont[id][wPos][0] != 0.0)
		{
			format(buff, 256, "%d,%f,%f,%f,%d,%d,%s\n", WifiPont[id][wID], ArrExt(WifiPont[id][wPos]), WifiPont[id][wVw], WifiPont[id][wInt], WifiPont[id][wNev]);
			fwrite(file, buff);
		}
		id++;
	}
			
	fclose(file);	
	return 1;
}

stock LoadWifi()
{
	new File:file, id, buff[128], buff2[7][32];
	if(!fexist("Config/wifi.cfg")) return 1;
			
	file = fopen("Config/wifi.cfg", io_read);
			
	while(id < MAXWIFI && fread(file, buff) && strfind(buff, ",") != NINCS)
	{
		split(buff, buff2, ',');
		WifiPont[id][wID] = strval(buff2[0]);
		WifiPont[id][wPos][0] = floatstr(buff2[1]);
		WifiPont[id][wPos][1] = floatstr(buff2[2]);
		WifiPont[id][wPos][2] = floatstr(buff2[3]);
		WifiPont[id][wVw] = strval(buff2[4]);
		WifiPont[id][wInt] = strval(buff2[5]);
		strmid(WifiPont[id][wNev], buff2[6], 0, strlen(buff2[6]), 255);
		id++;
	}
	fclose(file);
	return 1;
}

stock Label_Init()
{
	//Lõtér
	new loterfelirat = CreateObject(19353,1368.6838, -1317.1407, 17.0000,  0.00, 0.00, 0.00);
	SetObjectMaterialText(loterfelirat,"Lõtér",0,50,"Arial",24,1,COLOR_PIROS, 0, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	
	//O'Neill GSM
	new oneill = CreateObject(19353, 2139.1088, 2827.8659, 11.9825, -0.4999, 1.3999, 178.3743);
	SetObjectMaterialText(oneill, "O'Neill GSM Zrt.", 0, 50, "Arial", 18, 1, -65536, 0, 1);
	
	//Autósbolt neon (?)
	new autosboltneon = CreateObject(19353, 1334.47, -1865.24, 16.48,   0.00, 0.00, 68.34);
	SetObjectMaterialText(autosboltneon," ",0,50,"Arial",24,1,COLOR_PIROS, 0, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	
	//Autósbolt
	new autosboltfelirat = CreateObject(19353, 1331.98, -1864.25, 16.48,   0.00, 0.00, 68.34);
	SetObjectMaterialText(autosboltfelirat,"Autósbolt",0,50,"Arial",24,1,COLOR_PIROS, 0, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	
	//Disco ablak védelem
	new v1 = CreateObject(19446, 1682.83, -1316.40, 18.19,   0.00, 0.00, 90.00);
	SetObjectMaterialText(v1," ",0,50,"Arial",24,1,COLOR_PIROS, 0, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	new v2 = CreateObject(19446, 1682.81, -1316.40, 21.33,   0.00, 0.00, 90.00);
	SetObjectMaterialText(v2," ",0,50,"Arial",24,1,COLOR_PIROS, 0, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	new v3 = CreateObject(19446, 1690.71, -1316.40, 18.19,   0.00, 0.00, 90.00);
	SetObjectMaterialText(v3," ",0,50,"Arial",24,1,COLOR_PIROS, 0, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	new v4 = CreateObject(19446, 1690.71, -1316.40, 21.33,   0.00, 0.00, 90.00);
	SetObjectMaterialText(v4," ",0,50,"Arial",24,1,COLOR_PIROS, 0, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	new v5 = CreateObject(19354, 1677.74, -1318.50, 18.36,   0.00, 0.00, 0.00);
	SetObjectMaterialText(v5," ",0,50,"Arial",24,1,COLOR_PIROS, 0, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	new v6 = CreateObject(19354, 1677.74, -1318.50, 21.36,   0.00, 0.00, 0.00);
	SetObjectMaterialText(v6,"  ",0,50,"Arial",24,1,COLOR_PIROS, 0, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	new v7 = CreateObject(19446, 1672.54, -1321.47, 21.33,   0.00, 0.00, 90.00);
	SetObjectMaterialText(v7,"  ",0,50,"Arial",24,1,COLOR_PIROS, 0, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	new v8 = CreateObject(19354, 1666.37, -1321.47, 21.33,   0.00, 0.00, 90.00);
	SetObjectMaterialText(v8," ",0,50,"Arial",24,1,COLOR_PIROS, 0, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	new v9 = CreateObject(19354, 1667.59, -1321.47, 17.97,   0.00, 0.00, 90.00);
	SetObjectMaterialText(v9," ",0,50,"Arial",24,1,COLOR_PIROS, 0, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	new v10 = CreateObject(19354, 1668.45, -1321.47, 17.97,   0.00, 0.00, 90.00);
	SetObjectMaterialText(v10," ",0,50,"Arial",24,1,COLOR_PIROS, 0, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	new v11 = CreateObject(19354, 1675.74, -1321.47, 17.97,   0.00, 0.00, 90.00);
	SetObjectMaterialText(v11," ",0,50,"Arial",24,1,COLOR_PIROS, 0, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	new v12 = CreateObject(19354, 1674.50, -1321.47, 17.97,   0.00, 0.00, 90.00);
	SetObjectMaterialText(v12," ",0,50,"Arial",24,1,COLOR_PIROS, 0, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	new v13 = CreateObject(19354, 1665.24, -1318.50, 18.36,   0.00, 0.00, 0.00);
	SetObjectMaterialText(v13," ",0,50,"Arial",24,1,COLOR_PIROS, 0, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	new v14 = CreateObject(19354, 1665.24, -1318.50, 21.36,   0.00, 0.00, 0.00);
	SetObjectMaterialText(v14," ",0,50,"Arial",24,1,COLOR_PIROS, 0, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	new v15 = CreateObject(19446, 1660.15, -1316.40, 18.19,   0.00, 0.00, 90.00);
	SetObjectMaterialText(v15," ",0,50,"Arial",24,1,COLOR_PIROS, 0, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	new v16 = CreateObject(19446, 1660.15, -1316.40, 21.36,   0.00, 0.00, 90.00);
	SetObjectMaterialText(v16," ",0,50,"Arial",24,1,COLOR_PIROS, 0, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	new v17 = CreateObject(19446, 1652.35, -1316.40, 18.19,   0.00, 0.00, 90.00);
	SetObjectMaterialText(v17," ",0,50,"Arial",24,1,COLOR_PIROS, 0, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
    new v18 = CreateObject(19446, 1652.35, -1316.40, 21.36,   0.00, 0.00, 90.00);
	SetObjectMaterialText(v18," ",0,50,"Arial",24,1,COLOR_PIROS, 0, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	new v19 = CreateObject(19446, 1647.58, -1321.13, 18.19,   0.00, 0.00, 0.00);
	SetObjectMaterialText(v19," ",0,50,"Arial",24,1,COLOR_PIROS, 0, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	new v20 = CreateObject(19446, 1647.58, -1321.13, 21.36,   0.00, 0.00, 0.00);
	SetObjectMaterialText(v20," ",0,50,"Arial",24,1,COLOR_PIROS, 0, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	new v21 = CreateObject(19446, 1647.58, -1330.75, 18.19,   0.00, 0.00, 0.00);
	SetObjectMaterialText(v21," ",0,50,"Arial",24,1,COLOR_PIROS, 0, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	new v22 = CreateObject(19446, 1647.58, -1330.75, 21.36,   0.00, 0.00, 0.00);
	SetObjectMaterialText(v22," ",0,50,"Arial",24,1,COLOR_PIROS, 0, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	new v23 = CreateObject(19446, 1647.58, -1340.35, 18.19,   0.00, 0.00, 0.00);
	SetObjectMaterialText(v23," ",0,50,"Arial",24,1,COLOR_PIROS, 0, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	new v24 = CreateObject(19446, 1647.58, -1340.35, 21.36,   0.00, 0.00, 0.00);
	SetObjectMaterialText(v24," ",0,50,"Arial",24,1,COLOR_PIROS, 0, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	new v25 = CreateObject(19446, 1647.58, -1346.41, 18.19,   0.00, 0.00, 0.00);
	SetObjectMaterialText(v25," ",0,50,"Arial",24,1,COLOR_PIROS, 0, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	new v26 = CreateObject(19446, 1647.58, -1346.41, 21.36,   0.00, 0.00, 0.00);
	SetObjectMaterialText(v26," ",0,50,"Arial",24,1,COLOR_PIROS, 0, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	new v27 = CreateObject(19446, 1652.47, -1351.16, 18.19,   0.00, 0.00, 90.00);
	SetObjectMaterialText(v27," ",0,50,"Arial",24,1,COLOR_PIROS, 0, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	new v28 = CreateObject(19446, 1652.47, -1351.16, 21.36,   0.00, 0.00, 90.00);
	SetObjectMaterialText(v28," ",0,50,"Arial",24,1,COLOR_PIROS, 0, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	new v29 = CreateObject(19446, 1662.09, -1351.16, 18.19,   0.00, 0.00, 90.00);
	SetObjectMaterialText(v29," ",0,50,"Arial",24,1,COLOR_PIROS, 0, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	new v30 = CreateObject(19446, 1662.09, -1351.16, 21.36,   0.00, 0.00, 90.00);
	SetObjectMaterialText(v30," ",0,50,"Arial",24,1,COLOR_PIROS, 0, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	new v31 = CreateObject(19446, 1671.21, -1351.16, 18.19,   0.00, 0.00, 90.00);
	SetObjectMaterialText(v31," ",0,50,"Arial",24,1,COLOR_PIROS, 0, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	new v32 = CreateObject(19446, 1671.21, -1351.16, 21.36,   0.00, 0.00, 90.00);
	SetObjectMaterialText(v32," ",0,50,"Arial",24,1,COLOR_PIROS, 0, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	new v33 = CreateObject(19446, 1680.91, -1351.16, 18.19,   0.00, 0.00, 90.00);
	SetObjectMaterialText(v33," ",0,50,"Arial",24,1,COLOR_PIROS, 0, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	new v34 = CreateObject(19446, 1680.91, -1351.16, 21.36,   0.00, 0.00, 90.00);
	SetObjectMaterialText(v34," ",0,50,"Arial",24,1,COLOR_PIROS, 0, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	new v35 = CreateObject(19446, 1690.59, -1351.16, 18.19,   0.00, 0.00, 90.00);
	SetObjectMaterialText(v35," ",0,50,"Arial",24,1,COLOR_PIROS, 0, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	new v36 = CreateObject(19446, 1690.59, -1351.16, 21.36,   0.00, 0.00, 90.00);
	SetObjectMaterialText(v36," ",0,50,"Arial",24,1,COLOR_PIROS, 0, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	new v37 = CreateObject(19446, 1695.48, -1346.45, 18.19,   0.00, 0.00, 0.00);
	SetObjectMaterialText(v37," ",0,50,"Arial",24,1,COLOR_PIROS, 0, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	new v38 = CreateObject(19446, 1695.48, -1346.45, 21.36,   0.00, 0.00, 0.00);
	SetObjectMaterialText(v38," ",0,50,"Arial",24,1,COLOR_PIROS, 0, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	new v39 = CreateObject(19446, 1695.48, -1336.83, 18.19,   0.00, 0.00, 0.00);
	SetObjectMaterialText(v39," ",0,50,"Arial",24,1,COLOR_PIROS, 0, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	new v40 = CreateObject(19446, 1695.48, -1336.83, 21.36,   0.00, 0.00, 0.00);
	SetObjectMaterialText(v40," ",0,50,"Arial",24,1,COLOR_PIROS, 0, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	new v41 = CreateObject(19446, 1695.48, -1327.23, 18.19,   0.00, 0.00, 0.00);
	SetObjectMaterialText(v41," ",0,50,"Arial",24,1,COLOR_PIROS, 0, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	new v42 = CreateObject(19446, 1695.48, -1327.23, 21.36,   0.00, 0.00, 0.00);
	SetObjectMaterialText(v42," ",0,50,"Arial",24,1,COLOR_PIROS, 0, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	new v43 = CreateObject(19446, 1695.48, -1321.13, 18.19,   0.00, 0.00, 0.00);
	SetObjectMaterialText(v43," ",0,50,"Arial",24,1,COLOR_PIROS, 0, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	new v44 = CreateObject(19446, 1695.48, -1321.13, 21.36,   0.00, 0.00, 0.00);
	SetObjectMaterialText(v44," ",0,50,"Arial",24,1,COLOR_PIROS, 0, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	
	//Butler Birtok
	new butler = CreateObject(19353, -688.115295, 943.714294, 16.500762, 0.0000, 0.0000, 90);
	SetObjectMaterialText(butler, "BUTLER", 0, 50, "Arial", 24, 1, -256, 0, 1);
}

stock RandomString(strDest[], strLen)
{
    while(strLen--)
        strDest[strLen] = random(2) ? (random(26) + (random(2) ? 'a' : 'A')) : (random(10) + '0');
		
	return strDest[strLen];
}

stock IllegalStuffDelete()
{
	for(new f = 0; f < MAX_FRAKCIO; f++)
	{
		if(!LegalisFrakcio(f)) continue;
		FrakcioInfo[f][fMati] = 0;
		FrakcioInfo[f][fHeroin] = 0;
		FrakcioInfo[f][fKokain] = 0;
		FrakcioInfo[f][fMarihuana] = 0;
		SendMessage(SEND_MESSAGE_FRACTION, "<< ClassRPG: A rendszer nullázta az illegális anyagok számát a raktárból >>", COLOR_LIGHTRED, f);
		printf("[IllegalStuffDelete] FrakcióID: %d", f);
	}
}