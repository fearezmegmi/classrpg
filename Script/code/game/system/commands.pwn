#if defined __game_system_commands
	#endinput
#endif
#define __game_system_commands

/****************************
 *           cmdk           *
 *    �: 1   �: 4   �: 7    *
 *    �: 2   �: 5   �: 8    *
 *    �: 3   �: 6   u: 9    *  
 ****************************/
CMD:editint(playerid, params[])
{
	if (!IsScripter(playerid))
		return 1;
	
	new number, sub[32];
	if(sscanf(params, "is[32]", number, sub))
	{
		Msg(playerid, "Haszn�lata: /editint [sz�m] [bej�rat / spawn / camstart / camend]");
		return 1;
	}
	
	if(number < 0 || number >= IntekSzama())
	{
		Msg(playerid, "�rv�nytelen interior sz�m!");
		return 1;
	}
	
	if(egyezik(sub, "bejarat") || egyezik(sub, "bej�rat"))
	{
		new Float:pos[3];
		GetPlayerPos(playerid, ArrExt(pos));
		IntInfo[number][iExitX] = pos[0];
		IntInfo[number][iExitY] = pos[1];
		IntInfo[number][iExitZ] = pos[2];
		IntInfo[number][iNumber] = GetPlayerInterior(playerid);
		OnIntsUpdate();
		Msg(playerid, "Interior bej�rata sikeresen szerkesztve! (ment�shez: /saveint)");
	}
	else if(egyezik(sub, "spawn"))
	{
		new Float:pos[4];
		GetPlayerPos(playerid, ArrExt(pos));
		GetPlayerFacingAngle(playerid, pos[3]);
		IntInfo[number][iBedX] = pos[0];
		IntInfo[number][iBedY] = pos[1];
		IntInfo[number][iBedZ] = pos[2];
		IntInfo[number][iBedAngle] = pos[3];
		OnIntsUpdate();
		Msg(playerid, "Interior spawn sikeresen szerkesztve! (ment�shez: /saveint)");
	}
	else if(egyezik(sub, "camstart"))
	{
		GetPlayerCameraPos(playerid, ArrExt(IntInfo[number][iCamStartPos]));
		GetPlayerCameraLookAt(playerid, ArrExt(IntInfo[number][iCamStartLookAt]));
		OnIntsUpdate();
		Msg(playerid, "Interior camstart sikeresen szerkesztve! (ment�shez: /saveint)");
	}
	else if(egyezik(sub, "camend"))
	{
		GetPlayerCameraPos(playerid, ArrExt(IntInfo[number][iCamEndPos]));
		GetPlayerCameraLookAt(playerid, ArrExt(IntInfo[number][iCamEndLookAt]));
		OnIntsUpdate();
		Msg(playerid, "Interior camend sikeresen szerkesztve! (ment�shez: /saveint)");
	}
	
	return 1;
}

ALIAS(ad4):ado;
CMD:ado(playerid, params[])
{
	new param[32];
	new func[256];
	
	if(sscanf(params, "s[32]S()[256]", param, func)) return Msg(playerid, "/ad� [befizet / automata]");
	if(egyezik(param,"befizet"))
	{
		
		if(PlayerInfo[playerid][pAdokIdo] >= 10) return Msg(playerid, "Most vallottad be az ad�dat, legk�zelebb a k�vetkezo fizet�s ut�n tudod!");
		if(!PlayerToPoint(3.0, playerid, 361.829,173.766, 1008.382, 0, 3)) //V�rosh�za inti szembe f�ldszint
		{
			SetPlayerCheckpoint(playerid, 361.829,173.766, 1008.382, 3.0);
			Msg(playerid, "Nem vagy a v�rosh�za f�ldszintj�n a szemben l�vo asztaln�l!");
			return 1;
		}
		
		new osszeg = PlayerInfo[playerid][pAdokOsszeg];
		
		if(!BankkartyaFizet(playerid, PlayerInfo[playerid][pAdokOsszeg]))
		{
			return SendFormatMessage(playerid, COLOR_RED, "Nincs ennyi p�nzed, %sFt kell! K�rlek gy�jtsd �ssze mihamarabb a p�nzt!", FormatNumber(osszeg, 0, ',' ));
		}
		
		PlayerInfo[playerid][pAdokIdo] = 10;
		FrakcioSzef(FRAKCIO_ONKORMANYZAT, osszeg, 57);
		SendClientMessage(playerid, COLOR_LIGHTGREEN, "Sikeresen befizetted az ad�t! A k�vetkezot 10 fizet�sen bel�l kell!");
		
		new navstring[128];
		format(navstring, sizeof(navstring), "<< [AD�BEVALL�S] %s bevallotta az ad�j�t %sFt-t >>", PlayerName(playerid), FormatNumber(osszeg, 0, ',' ));
		SendMessage(SEND_MESSAGE_FRACTION, navstring, COLOR_RED, FRAKCIO_SCPD);
		
		PlayerInfo[playerid][pAdokOsszeg] = 0;
	}
	if(egyezik(param,"automata"))
	{
		if(PlayerInfo[playerid][pAdoAuto])
			PlayerInfo[playerid][pAdoAuto]=false,Msg(playerid,"Kikapcsoltad az automatikus ad� fizet�sedet!");
		else
			PlayerInfo[playerid][pAdoAuto]=true,Msg(playerid,"Automatikusra �ll�tottad az ad� fizet�sedet!");
		
	}
	return 1;
}
CMD:engedtv(playerid, params[])
{
	if(!Admin(playerid, 1)) return 1;
	
	if(Tvenged[playerid])
	{
		Tvenged[playerid]=false;
		Msg(playerid, "T�ltottad hogy a kisebb adminok tv-zenek t�ged");
	}
	else
	{
		Msg(playerid, "Enged�lyezted hogy a kisebb adminok tv-zenek t�ged");
		Tvenged[playerid]=true;
	}
	return 1;
}
ALIAS(tvenged2ly):tvengedely;
CMD:tvengedely(playerid, params[])
{
	if(!Admin(playerid, 5)) return 1;
	
	new nev,ido;
	new playername[64],sendername[64],string[128];
	if(sscanf(params, "rd",nev,ido))
		return SendClientMessage(playerid, COLOR_GRAD2, "Haszn�lata: /tvenged�ly [J�t�kos] [IRL �ra]");

	
		
	GetPlayerName(nev, playername, sizeof(playername));
	GetPlayerName(playerid, sendername, sizeof(sendername));

	if(Adminseged[nev] != 1 && !IsAS(nev)) return SendClientMessage(playerid, COLOR_YELLOW, "Ez a j�t�kos nem AS!");
	
	if(ido < 1) return Msg(playerid, "Az id� t�l kicsi!");
	
	if(TvEngedely[nev] < UnixTime)
	{
		
		format(string, sizeof(string), "<< Enged�lyezted a TVz�st %s -nak %d �r�ra>>", playername,ido);
		SendClientMessage(playerid, COLOR_YELLOW, string);
		format(string, sizeof(string), "<< Admin %s enged�lyezte neked a TVz�st %d �r�ra! >>", AdminName(playerid),ido);
		SendClientMessage(nev, COLOR_YELLOW, string);
		format(string, sizeof(string), "<< Admin %s enged�lyezte %s -nak a TVz�st %d �r�ra! >>", AdminName(playerid), playername,ido);
		ABroadCast(COLOR_LIGHTRED, string, 1);
		TvEngedely[nev] = (ido*3600)+UnixTime;
	}
	else
	{
		format(string, sizeof(string), "<< Tiltottad a TVz�st neki: %s! >>", playername);
		SendClientMessage(playerid, COLOR_YELLOW, string);
		format(string, sizeof(string), "<< Admin %s tiltotta neked a TVz�st! >>", AdminName(playerid));
		SendClientMessage(nev, COLOR_YELLOW, string);
		format(string, sizeof(string), "<< Admin %s tiltotta neki: %s a TVz�st! >>", AdminName(playerid), playername);
		ABroadCast(COLOR_LIGHTRED, string, 1);
		TvEngedely[nev] = 0;
	}
	
	return 1;
}
CMD:cheat(playerid, params[])
{
	new target = INVALID_PLAYER_ID;
	new reason[256];
	if(sscanf(params, "rs[256]", target, reason) || target == INVALID_PLAYER_ID)
	{
		if(sscanf(params, "ds[256]", target, reason))
		{
			Msg(playerid, "==========[ /cheat ]==========", false, COLOR_LIGHTBLUE);
			Msg(playerid, "Haszn�lat: /cheat [j�t�kos n�v / ID / BID] [oka]", false, COLOR_LIGHTBLUE);
			Msg(playerid, "Ha �gy l�tod, hogy valaki csal, ezzel a paranccsal jelezheted nek�nk!", false, COLOR_LIGHTBLUE);
			Msg(playerid, "A parancs haszn�lat�hoz nem sz�ks�ges online adminisztr�tor, k�s�bb is ut�na tudunk n�zni!", false, COLOR_LIGHTBLUE);
			Msg(playerid, "Figyelem! A paranccsal t�rt�n� vissza�l�st tilt�ssal jutalmazzuk!", false, COLOR_LIGHTBLUE);
			Msg(playerid, "Ez�rt csak abban az esetben jelezd, ha val�ban �gy �rzed, hogy csal�t l�tt�l!", false, COLOR_LIGHTBLUE);
			Msg(playerid, "==========[ /cheat ]==========", false, COLOR_LIGHTBLUE);
			return 1;
		}
		
		target = FindPlayerByBID(target);
	}
	
	if(target == INVALID_PLAYER_ID)
		return Msg(playerid, "Nincs ilyen j�t�kos");
	
	if(strlen(reason) < 10)
		return Msg(playerid, "Enn�l az�rt b�vebben... de maximum 128 karakter!");
	
	if(PlayerInfo[playerid][pReportCooldown] > UnixTime)
		return Msg(playerid, "Ilyen gyorsan nem jelenthetsz! T�relem!");
	
	PlayerInfo[playerid][pReportPlayer] = target;
	strmid(PlayerInfo[playerid][pReportReason], reason, 0, strlen(reason), 128);
	
	ReportPlayer(playerid);
	return 1;
}

CMD:walk(playerid, params[])
{
	new id;
	if(Animban[playerid]) return Msg(playerid, "Animban nem m�sz sehova. :) /k�sz�s");
	if(sscanf(params, "d",id)) return Msg(playerid, "/walk [1-13]");
	switch (id)
	{
		case 1: { SetPlayerWalkingStyle(playerid, 1); ApplyAnimation(playerid,"PED","WALK_player",4.1,1,1,1,1,1); }
		case 2: { SetPlayerWalkingStyle(playerid, 2); ApplyAnimation(playerid,"PED","WALK_civi",4.1,1,1,1,1,1); }
		case 3: { SetPlayerWalkingStyle(playerid, 3); ApplyAnimation(playerid,"PED","WALK_gang1",4.1,1,1,1,1,1); }
		case 4: { SetPlayerWalkingStyle(playerid, 4); ApplyAnimation(playerid,"PED","WALK_gang2",4.1,1,1,1,1,1); }
		case 5: { SetPlayerWalkingStyle(playerid, 5); ApplyAnimation(playerid,"PED","WALK_old",4.1,1,1,1,1,1); }
		case 6: { SetPlayerWalkingStyle(playerid, 6); ApplyAnimation(playerid,"PED","WALK_fatold",4.1,1,1,1,1,1); }
		case 7: { SetPlayerWalkingStyle(playerid, 7); ApplyAnimation(playerid,"PED","WALK_fat",4.1,1,1,1,1,1); }
		case 8: { SetPlayerWalkingStyle(playerid, 8); ApplyAnimation(playerid,"PED","WOMAN_walknorm",4.1,1,1,1,1,1); }
		case 9: { SetPlayerWalkingStyle(playerid, 9); ApplyAnimation(playerid,"PED","WOMAN_walkbusy",4.1,1,1,1,1,1); }
		case 10: { SetPlayerWalkingStyle(playerid, 10); ApplyAnimation(playerid,"PED","WOMAN_walkpro",4.1,1,1,1,1,1); }
		case 11: { SetPlayerWalkingStyle(playerid, 11); ApplyAnimation(playerid,"PED","WOMAN_walksexy",4.1,1,1,1,1,1); }
		case 12: { SetPlayerWalkingStyle(playerid, 12); ApplyAnimation(playerid,"PED","WALK_drunk",4.1,1,1,1,1,1); }
		case 13: { SetPlayerWalkingStyle(playerid, 13); ApplyAnimation(playerid,"PED","Walk_Wuzi",4.1,1,1,1,1,1); }
		default: Msg(playerid,"Haszn�lat: /walk [1-13]");
	}
	SendFormatMessage(playerid, COLOR_WHITE, "S�t�l�si st�lusod: %d", id);
	return 1;
}

CMD:devmode(playerid, params[])
{
	if(!devmode || !IsScripter(playerid))
		return 1;
		
	new cmd[32], subcmd[128];
	if(sscanf(params, "s[32] s[128]", cmd, subcmd))
	{
		Msg(playerid, "Haszn�lat: /devmode [parancs]");
		//Msg(playerid, "Parancsok: setNextCrate");
		return 1;
	}
	
	return 1;
}

ALIAS(b4nuszok):bonuszok;
CMD:bonuszok(playerid, params[])
{
	Msg(playerid, "===[ B�nuszok ]===", false, COLOR_LIGHTBLUE);
	
	// kamat
	new Float:kamat, kamatDb;
	
	new Float:premiumKamat = GetInterestFromPremiumPack(playerid);
	if(premiumKamat > 0)
	{
		SendFormatMessage(playerid, COLOR_WHITE, "Kamat: %.2f sz�zal�k - forr�s: pr�mium", premiumKamat + FLOATFIX);
		kamat += premiumKamat;
		kamatDb++;
	}
	
	if(PremiumInfo[playerid][pKamat] > 0 && PremiumInfo[playerid][pKamatIdo] > 0)
	{
		SendFormatMessage(playerid, COLOR_WHITE, "Kamat: %.2f sz�zal�k (m�g %d fizet�sig) - forr�s: kredit", PremiumInfo[playerid][pKamat] + FLOATFIX, PremiumInfo[playerid][pKamatIdo]);
		kamat += PremiumInfo[playerid][pKamat];
		kamatDb++;
	}
	
	#if defined SYSTEM_BONUS
	if(BonusInfo[playerid][B:Kamat] > 0 && BonusInfo[playerid][B:KamatIdo] > 0)
	{
		SendFormatMessage(playerid, COLOR_WHITE, "Kamat: %.2f sz�zal�k (m�g %d fizet�sig) - forr�s: b�nusz", BonusInfo[playerid][B:Kamat] + FLOATFIX, BonusInfo[playerid][B:KamatIdo]);
		kamat += BonusInfo[playerid][B:Kamat];
		kamatDb++;
	}
	#endif
	
	if(kamat == 0)
		SendClientMessage(playerid, COLOR_WHITE, "Kamat: nincs");
	else if(kamatDb > 1)
		SendFormatMessage(playerid, COLOR_WHITE, "Kamat �sszesen: %.2f sz�zal�k", kamat);
	
	// ado
	new Float:ado, adoDb;
	if(PremiumInfo[playerid][pAdo] > 0 && PremiumInfo[playerid][pAdoIdo] > 0)
	{
		SendFormatMessage(playerid, COLOR_WHITE, "Ad�cs�kkent�s: %.2f sz�zal�k (m�g %d fizet�sig) - forr�s: kredit", PremiumInfo[playerid][pAdo] + FLOATFIX, PremiumInfo[playerid][pAdoIdo]);
		ado += PremiumInfo[playerid][pAdo];
		adoDb++;
	}
	
	#if defined SYSTEM_BONUS
	if(BonusInfo[playerid][B:Ado] > 0 && BonusInfo[playerid][B:AdoIdo] > 0)
	{
		SendFormatMessage(playerid, COLOR_WHITE, "Ad�cs�kkent�s: %.0f sz�zal�k (m�g %d fizet�sig) - forr�s: b�nusz", BonusInfo[playerid][B:Ado] + FLOATFIX, BonusInfo[playerid][B:AdoIdo]);
		ado += BonusInfo[playerid][B:Ado];
		adoDb++;
	}
	#endif
	
	if(ado == 0)
		SendClientMessage(playerid, COLOR_WHITE, "Ad�cs�kkent�s: nincs");
	else if(adoDb > 1)
		SendFormatMessage(playerid, COLOR_WHITE, "Ad�cs�kkent�s �sszesen: %.0f sz�zal�k", ado);
		
	return 1;
}

CMD:lemond(playerid, params[])
{
	if(!LMT(playerid, FRAKCIO_MENTO)) return Msg(playerid, "Csak ment�s haszn�lhatja!");
	if(MentoSegit[playerid] != 0) 
	{
		SendClientMessage(playerid,COLOR_YELLOW,"�jra el�rhet� vagy!");
		MentoSegit[playerid] = 0;
	}
	else
		SendClientMessage(playerid,COLOR_YELLOW,"Eddig is el�rhet� volt�l!"),MentoSegit[playerid] = 0;

	return 1;
}
CMD:fkmotd(playerid, params[])
{
	if(!PlayerInfo[playerid][pLeader] && !IsScripter(playerid) && !IsAmos(playerid)) return Msg(playerid, "Nem vagy leader");
	new frakcio = PlayerInfo[playerid][pMember];
	new felhivas[32];
	if(sscanf(params, "s[32]", felhivas))
		return SendClientMessage(playerid, COLOR_WHITE, "Haszn�lat: /fkmotd [�zeneted]");

	SendRadioMessageFormat(frakcio, COLOR_YELLOW, "<<< Frakci� felh�v�s: %s >>>", felhivas);

	format(FrakcioInfo[frakcio][fMotd], 32, "%s", felhivas);
	
	return 1;
}
	
CMD:robhely(playerid, params[])
{
	if(!IsScripter(playerid) && !IsAmos(playerid)) return 1;
	
	new param[32];
	new func[256];
	
	if(sscanf(params, "s[32]S()[256]", param, func)) 
	{
		Msg(playerid, "/robhely [funkci�]");
		Msg(playerid, "Funkci�k: [Go | uj | mod | �res | t�r�l | k�zel | tulaj | biztons�g]");
		Msg(playerid, "mod= m�d�s�t");
		return 1;
	}
	if(egyezik(param, "go") || egyezik(param, "menj"))
	{
		new robhelyid;
		if(sscanf(func, "d", robhelyid)) return Msg(playerid, "/robhely go [ROBHELY ID]");
		if(robhelyid < 0 || robhelyid > MAX_BANKROBHELY) return Msg(playerid, "Hib�s ROBHELY ID.");
		SetPlayerPos(playerid, ROBHELY[robhelyid][roPosX], ROBHELY[robhelyid][roPosY], ROBHELY[robhelyid][roPosZ]);
		SendFormatMessage(playerid,  COLOR_LIGHTGREEN, "* Teleport�lt�l az robhely-hez. (ID: %d - Koord�n�ta: X: %f | Y: %f | Z: %f) ", robhelyid,ROBHELY[robhelyid][roPosX], ROBHELY[robhelyid][roPosY], ROBHELY[robhelyid][roPosZ]);
	}
    if(egyezik(param, "tulaj"))
    {
        new ujtulaj[32], robhelyid;
        if(sscanf(func, "ds[32]",robhelyid, ujtulaj)) return Msg(playerid, "/robhely tulaj [robhelyid] [n�v]");
 
        if(!strlen(ujtulaj)) return Msg(playerid, "Fejbecsapjalak?");
        if(robhelyid < 0 || robhelyid > MAX_BANKROBHELY) return Msg(playerid, "Hib�s ROBHELY ID.");
 
        SendFormatMessage(playerid,  COLOR_LIGHTGREEN, "* Sz�f: [%d] R�gi tulaj: %s | �j tulaj: %s", robhelyid, ROBHELY[robhelyid][roTulaj], ujtulaj);
        format(ROBHELY[robhelyid][roTulaj], 32, "%s", ujtulaj);
        return 1;
    }
	if(egyezik(param, "lez�r�s") || egyezik(param, "z�r") || egyezik(param, "close"))
	{
		
		new power, robhelyid;
		if(sscanf(func, "d",robhelyid,power)) return Msg(playerid, "/robhely z�r [ROBHELYID]");
		
		if(ROBHELY[robhelyid][roLezarva] == 0)
		{
			ROBHELY[robhelyid][roLezarva] = 1;
			Msg(playerid, "ROBELY LEZ�RVA");
		}
		if(ROBHELY[robhelyid][roLezarva] == 1)
		{
			ROBHELY[robhelyid][roLezarva] = 0;
			Msg(playerid, "ROBELY KINYITVA");
		}
		SendFormatMessage(playerid,  COLOR_LIGHTGREEN, "* ID: %d Lez�rva: %d", robhelyid,ROBHELY[robhelyid][roLezarva]);
	}
	if(egyezik(param, "biztons�g") || egyezik(param, "biztonsag") || egyezik(param, "szint"))
	{
		
		new power, robhelyid;
		if(sscanf(func, "dd",robhelyid,power)) return Msg(playerid, "/robhely biztons�g [ROBHELYID] [BIZTONS�GI SZINT]");
		
		if(power < 0 || power > 5) return Msg(playerid, "Hib�s BIZTONS�GI SZINT");
		if(robhelyid < 0 || robhelyid > MAX_BANKROBHELY) return Msg(playerid, "Hib�s ROBHELY ID.");
		ROBHELY[robhelyid][roBiztonsag] = power;
		SendFormatMessage(playerid,  COLOR_LIGHTGREEN, "* ID: %d Biztons�g: %d", robhelyid,ROBHELY[robhelyid][roBiztonsag]);
	}
	if(egyezik(param, "help"))
	{
			if(IsScripter(playerid))
			{
				Msg(playerid,"Bankrabl�s pozici�kat tudsz lerakni az object lerak�s rendszer�hez hasonlatosan:");
				Msg(playerid,"/robhely go id - A megadott id-re rakott bankrabl�si pozici�ra visz.");
				Msg(playerid,"/robhely uj [ls(1)/sf(2)] - A megadott t�pusban �j bankrabl�si poz�ci�t helyez le. (Fontos, hogy ne keverd)");
				Msg(playerid,"/robhely vw - Ahogyan az objectek eset�ben is van, ennek is tudod a vw-j�t �ll�tani.");
				Msg(playerid,"/robhely mod - Ugyan az, mint az objectn�l, a pozici� m�dos�that�!");
				Msg(playerid,"/robhely k�zel - Megmutatja a k�zeli ROBHELY-et!");
				Msg(playerid,"/robhely t�r�l - T�rli ROBHELY-et!");
				Msg(playerid,"/robhely tulaj - Be�ll�tja a tulajt (Pl: Bank)");
				Msg(playerid,"/robhely biztons�g - Be�ll�tja a biztons�gi szintet (1-5)");
				return 1;
			}
			return 1;	
	}
	if(egyezik(param, "uj") || egyezik(param, "�j"))
	{
		new tipus;
		if(sscanf(func, "d", tipus))
		{
			Msg(playerid, "/robhely uj [ls(1)/sf(2)]");
		}
		new id = NINCS;
		
		for(new r = 0; r < MAX_BANKROBHELY; r++)
		{
			if(ROBHELY[r][roRobId] == 0)
			{
				id = r;
				break;
			}
		}
		
		if(id < 0 || id >= MAX_BANKROBHELY) return Msg(playerid, "Nincs �res hely!");

		new Float:X, Float:Y, Float:Z, Float:A;
		GetPlayerPos(playerid, X, Y, Z);
		GetPlayerFacingAngle(playerid, A);
		
		id=UresObject();
		if(id == NINCS) return Msg(playerid, "Nincs �res hely");

		ROBHELY[id][roInt] = GetPlayerInterior(playerid);
		ROBHELY[id][roVw] = GetPlayerVirtualWorld(playerid);
		
		if(tipus == 1)
		{
			ROBHELY[id][roLsVagySf] = tipus;//LS
		}
		else if(tipus == 2)//SF
		{
			ROBHELY[id][roLsVagySf] = tipus;
		}
		else return Msg(playerid, "NINCS ILYEN BANK");
		
		new Tulaj[32] = "Bank";
		new Jelszo = CodeGen(6);
		
		ROBHELY[id][roLezarva] = 0;
		ROBHELY[id][roPosX] = X;
		ROBHELY[id][roPosY] = Y;
		ROBHELY[id][roPosZ] = Z;
		ROBHELY[id][roPosZX] = 0.0;
		ROBHELY[id][roPosZY] = 0.0;
		ROBHELY[id][roPosA] = A;
		format(ROBHELY[id][roTulaj], 32, "%s", Tulaj);
		ROBHELY[id][roJelszo] = Jelszo;
		ROBHELY[id][roBiztonsag] = 0;

		if(tipus == 1) SendFormatMessage(playerid,  COLOR_LIGHTGREEN, "* BANKROB lerakva. (ID: %d - T�pus: LS Koord�n�ta: X: %.2f | Y: %.2f | Z: %.2f | A: %.2f | VW: %d | INT: %d) ", id, ROBHELY[id][roPosX], ROBHELY[id][roPosY], ROBHELY[id][roPosZ], ROBHELY[id][roPosA], ROBHELY[id][roVw],ROBHELY[id][roInt]);
		if(tipus == 2) SendFormatMessage(playerid,  COLOR_LIGHTGREEN, "* BANKROB lerakva. (ID: %d - T�pus: SF Koord�n�ta: X: %.2f | Y: %.2f | Z: %.2f | A: %.2f | VW: %d | INT: %d) ", id, ROBHELY[id][roPosX], ROBHELY[id][roPosY], ROBHELY[id][roPosZ], ROBHELY[id][roPosA], ROBHELY[id][roVw],ROBHELY[id][roInt]);
		SaveRobHelyek();
	}
	if(egyezik(param, "vw"))
	{
		
		new Float:PPos[3], Float:legkozelebb = 5000.0, Float:tav;
		new vw;
		if(sscanf(func, "d", vw)) return Msg(playerid, "/robhely vw");
		
		GetPlayerPos(playerid, PPos[0], PPos[1], PPos[2]);
		new id;
		for(new r = 0; r < MAX_BANKROBHELY; r++)
		{
			tav = GetDistanceBetweenPoints(PPos[0], PPos[1], PPos[2], ROBHELY[r][roPosX], ROBHELY[r][roPosY], ROBHELY[r][roPosZ]);
			if(tav < legkozelebb)
			{
				legkozelebb = tav;
				id = r;
			}
		}
		
		ROBHELY[id][roVw] = vw;
		
		SaveRobHelyek();
	}
	if(egyezik(param, "mod") || egyezik(param, "modosit"))
	{
		
		new Float:PPos[3], Float:legkozelebb = 5000.0, Float:tav;
		new robhelyid = NINCS;
		
		if(sscanf(func, "d", robhelyid))
		{
			GetPlayerPos(playerid, PPos[0], PPos[1], PPos[2]);
			new id;
			for(new r = 0; r < MAX_BANKROBHELY; r++)
			{
				tav = GetDistanceBetweenPoints(PPos[0], PPos[1], PPos[2], ROBHELY[r][roPosX], ROBHELY[r][roPosY], ROBHELY[r][roPosZ]);
				if(tav < legkozelebb)
				{
					legkozelebb = tav;
					id = r;
				}
			}
			
			EditDynamicObject(playerid, ROBHELY[id][roRobId]);
			
			ObjectSzerkeszt[playerid] = id;
			
			SaveRobHelyek();
		}
		return 1;
	}
	if(egyezik(param, "t�r�l"))
	{
		new id;
		new Float:PPos[3], Float:legkozelebb = 5000.0, Float:tav;
		
		if(sscanf(func, "d", id))
		{
		
			GetPlayerPos(playerid, PPos[0], PPos[1], PPos[2]);
			
			for(new r = 0; r < MAX_BANKROBHELY; r++)
			{
				tav = GetDistanceBetweenPoints(PPos[0], PPos[1], PPos[2], ROBHELY[r][roPosX], ROBHELY[r][roPosY], ROBHELY[r][roPosZ]);
				if(tav < legkozelebb)
				{
					legkozelebb = tav;
					id = r;
				}
			}
		
		}
		
		if(id < 0 || id >= MAX_BANKROBHELY) return Msg(playerid, "Hib�s SORSZ�M ID.");

		ROBHELY[id][roLezarva] = 0;
		ROBHELY[id][roPosX] = 0.0;
		ROBHELY[id][roPosY] = 0.0;
		ROBHELY[id][roPosZ] = 0.0;
		ROBHELY[id][roPosA] = 0.0;
		ROBHELY[id][roRobId] = 0;
		ROBHELY[id][roVw] = 0;
		ROBHELY[id][roInt] = 0;
		ROBHELY[id][roLsVagySf] = 0;
		format(ROBHELY[id][roTulaj], 32, "Nincs");
		ROBHELY[id][roJelszo] = 0;
		ROBHELY[id][roBiztonsag] = 0;
		SendFormatMessage(playerid,  COLOR_LIGHTGREEN, "T�r�lve ROBHELY: %d",id);
		
		SaveRobHelyek();
	}
	if(egyezik(param, "�res"))
	{
		new szamlalo;
		for(new r = 0; r < MAX_BANKROBHELY; r++)
		{
			if(ROBHELY[r][roRobId] == 0)
			{
				SendFormatMessage(playerid,  COLOR_LIGHTGREEN, "*�res ROBHELY: %d ",r);
				szamlalo++;
				if(szamlalo > 6) return 1;
			}
		}
	}
	if(egyezik(param, "k�zel"))
	{
		SendClientMessage(playerid, COLOR_WHITE, "====[ Legk�zelebbi RobHely ]=====");
		new Float:PPos[3], Float:legkozelebb = 5000.0, Float:tav;
		GetPlayerPos(playerid, PPos[0], PPos[1], PPos[2]);
		new kozel;
		for(new r = 0; r < MAX_BANKROBHELY; r++)
		{
			tav = GetDistanceBetweenPoints(PPos[0], PPos[1], PPos[2], ROBHELY[r][roPosX], ROBHELY[r][roPosY], ROBHELY[r][roPosZ]);
			if(tav < legkozelebb)
			{
				legkozelebb = tav;
				kozel = r;
			}
		}

		if(legkozelebb == 5000.0) return Msg(playerid, "Nincs tal�lat");

		SendFormatMessage(playerid, COLOR_LIGHTBLUE, "ID: %d T�PUS: %d VW: %d INT: %d", kozel,ROBHELY[kozel][roLsVagySf],ROBHELY[kozel][roVw],ROBHELY[kozel][roInt]);
		SetPlayerCheckpoint(playerid, ROBHELY[kozel][roPosX], ROBHELY[kozel][roPosY], ROBHELY[kozel][roPosZ], 3);
		return 1;
	}
	return 1;
}

ALIAS(ranks):tagok;
CMD:tagok(playerid,params[])
{
	ShowTagok(playerid);
	return 1;
}
CMD:restart(playerid,params[])
{
	if(!Admin(playerid,5555) && !IsScripter(playerid)) return 1;
	
	if(SzerverResiigCounter > 0 || SzerverResiCounter > 0)
	{
		SzerverResiigCounter=0;
		SzerverResiCounter=0;
		TextDrawHideForAll(resiszerver);
		ResiVan[0] = false;
		ResiVan[1] = false;
		ResiVan[2] = false;
		SendClientMessageToAll(COLOR_LIGHTRED, "<<< ======================================== >>>");
		SendClientMessageToAll(COLOR_LIGHTRED, "<<< ============RESTART ELMARAD!!!========== >>>");
		SendClientMessageToAll(COLOR_LIGHTRED, "<<< ======================================== >>>");
	}				
	return 1;
}

ALIAS(ah):ahelp;
ALIAS(adminhelp):ahelp;
CMD:ahelp(playerid,params[])
{
	if(!Admin(playerid, 1) && !IsAS(playerid)) return Msg(playerid, "Nem vagy Admin / Adminseg�d.");
	AdminHelp(playerid,0);
	AdminHelp(playerid,1);
	AdminHelp(playerid,2);
	AdminHelp(playerid,3);
	AdminHelp(playerid,4);
	AdminHelp(playerid,5);
	AdminHelp(playerid,6);
	AdminHelp(playerid,1337);
	AdminHelp(playerid,1338);
	AdminHelp(playerid,1340);
	AdminHelp(playerid,5555);
	return 1;
}
CMD:rules(playerid,params[])
{
	SendClientMessage(playerid, COLOR_LIGHTRED,"A szab�lyzatot a weboldalon tal�lod!");
	return 1;
}

CMD:amunka(playerid,params[])
{	
	AmunkaInfo(playerid);
}
ALIAS(megf4zve):cooked;
CMD:cooked(playerid,params[])
{
	CookedFish(playerid);
	return 1;
}
CMD:leaderek(playerid,params[])
{
	SendClientMessage(playerid, COLOR_GREEN, "------------[ Szervezetek Vezet�i ]------------");
	ShowLeaderek(playerid);
	SendClientMessage(playerid,COLOR_GREEN, "---------------------------------------");
	return 1;
}
ALIAS(aktivit1som):aktivitasom;
CMD:aktivitasom(playerid,params[])
{
	// �sszes�tett
	SendClientMessage(playerid, COLOR_LIGHTBLUE, "=[ �sszes�tett statisztika (mai nap n�lk�l) ]=");
	SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Aktivit�s az elm�lt 7 napban %d �ra, az elm�lt 1 h�napban %d �ra",PlayerInfo[playerid][pHetiAktivitas], PlayerInfo[playerid][pHaviAktivitas]);
	
	// mai
	SendClientMessage(playerid, COLOR_LIGHTBLUE, "=[ Mai aktivit�sod ]=");
	new ido = StatInfo[playerid][pIdoOsszes];
	if(ido < 3600)
		SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Aktivit�s: %d perc", ido / 60);
	else
		SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Aktivit�s: %d �ra �s %d perc", ido / 3600, ido % 3600 / 60);
	
	// mai - onduty
	new ondutyIdo = StatInfo[playerid][pOndutyOsszes];
	if(ondutyIdo > 0)
	{
		if(ondutyIdo < 3600)
			SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Onduty: %d perc", ondutyIdo / 60);
		else
			SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Onduty: %d �ra �s %d perc", ondutyIdo / 3600, ondutyIdo % 3600 / 60);
	}
		
	//format(string,sizeof(string),"[/AKTIVITAS] N�v: %s Heti: %d Havi: %d",PlayerName(playerid),PlayerInfo[playerid][pHetiAktivitas],PlayerInfo[playerid][pHaviAktivitas]);
	//Log("Scripter",string);
	return 1;
}
ALIAS(vir1gszed2s):viragszedes;
CMD:viragszedes(playerid,params[])
{
	if(PlayerInfo[playerid][pFegyverTiltIdo] > 0) return Msg(playerid, "El vagy tiltva a fegyver haszn�latt�l!");
       
	if(IsAt(playerid, IsAt_Viragoskert))
	{
		SetTimerEx("vir�gszed�s", 24000, false, "ii", playerid);
		Msg(playerid, "Elkezdt�l vir�got szedni");
		Cselekves(playerid, "elkezdett vir�got szedni...", 1);
		Freeze(playerid, 24000);
		ApplyAnimation(playerid, "BOMBER","BOM_Plant_Loop",4.0,1,0,0,1,0);
           
		WeaponGiveWeapon(playerid, WEAPON_FLOWER, _, 0);
	}
	else Msg(playerid, "K�zeledben nincs vir�g!");
	return 1;
}
ALIAS(clearchat):cc;
CMD:cc(playerid,params[])
{
	if(Nincsbelepve(playerid)) return 1;
	if(Admin(playerid, 1)) return ClearChat();
	return 1;
}
CMD:hq(playerid,params[])
{
	Msg(playerid, "/k�zpont");
	return 1;
}

ALIAS(vizsgav2ge):vizsgavege;
CMD:vizsgavege(playerid,params[])
{
	if(!LMT(playerid, FRAKCIO_OKTATO)) return Msg(playerid, "Csak oktat� haszn�lhatja!");
	{
		Oktat[playerid] = 0;
		Msg(playerid, "El�rhet�v� tetted magad!");
	}
	return 1;
}
ALIAS(oktat4k):oktatok;
CMD:oktatok(playerid,params[])
{
	Msg(playerid, "======================== Szolg�latban l�v� Oktat�k ======================== ", false, COLOR_LIGHTBLUE);
	ShowOktatok(playerid);
	Msg(playerid, "======================== Szolg�latban l�v� Oktat�k ========================  ", false, COLOR_LIGHTBLUE);
	return 1;
}
CMD:adat(playerid,params[])
{
	new player;
	if(!AMT(playerid, MUNKA_DETEKTIV) && !IsHitman(playerid) && !Admin(playerid, 1)) return Msg(playerid, "Nem vagy detekt�v.");
	if(sscanf(params, "u", player)) return Msg(playerid, "/adat [J�t�kos]");
	if(player == INVALID_PLAYER_ID) return Msg(playerid, "Nincs ilyen j�t�kos.");
	ShowDetektivPlayerStats(playerid, player);
	return 1;
}
ALIAS(hugyoz1s):pee;
CMD:pee(playerid,params[])
{
	new string[256];
	if(Pee[playerid])
	{
		Pee[playerid] = false;
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	}
	else if(Vizelet[playerid])
	{
		if(IsPlayerInAnyVehicle(playerid)) return Msg(playerid, "Szerintem IRL se kocsiban v�gzed el a dolgod...");
		Pee[playerid] = true;
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_PISSING);
			
		if(Tevezik[playerid] != NINCS)
		{
			format(string, sizeof(string), "[/pee]%s tv-z�s k�zben /pee-zik", PlayerName(playerid));
			ABroadCast(COLOR_LIGHTRED, string, 1);
		}	
	}
	return 1;
}
CMD:idk(playerid,params[])
{
	if(FloodCheck(playerid)) return 1;
	if(Harcol[playerid]) return Msg(playerid, "A-A wark�zben nem!!!");
	if(Bejelento[playerid])
	{
		Bejelento[playerid] = false;
		foreach(Jatekosok, p)
		{
			if(p == playerid || BText[p] == INVALID_3D_TEXT_ID) continue;
			Streamer_RemoveArrayData(STREAMER_TYPE_3D_TEXT_LABEL, BText[p], E_STREAMER_PLAYER_ID, playerid);
		}
		Streamer_Update(playerid);
		IDK[playerid] = 0;
		Msg(playerid, "Felirat kikapcsolva");
		Cselekves(playerid, "kikapcsolta a /idk parancsot", 0, true);
	}
	else
	{
		if(Paintballozik[playerid]) return Msg(playerid, "Nem csalunk, tisztess�gesen j�tszunk!");
		Bejelento[playerid] = true;
		foreach(Jatekosok, p)
		{
			if(p == playerid || BText[p] == INVALID_3D_TEXT_ID) continue;
			Streamer_AppendArrayData(STREAMER_TYPE_3D_TEXT_LABEL, BText[p], E_STREAMER_PLAYER_ID, playerid);
		}
		Streamer_Update(playerid);
		if(Admin(playerid, 1))
		{	
			if(AdminDuty[playerid] == 0) Cselekves(playerid, "haszn�lta a /idk parancsot", 0, true);
			Msg(playerid, "Felirat bekapcsolva!");
		}
		else
		{
			IDK[playerid] = 60;
			Msg(playerid, "Felirat bekapcsolva 1 percre! J�t�kos bejelent�s�hez haszn�ld a /bejelent parancsot!");
			Cselekves(playerid, "haszn�lta a /idk parancsot", 0, true);
		}
	}
	return 1;
}

CMD:szerszamoslada(playerid,params[])
{
	if(MunkaFolyamatban[playerid]) return 1;

	if(PlayerInfo[playerid][pSzerszamoslada] != 1 && PlayerInfo[playerid][pSzerszamoslada] != 0)
		PlayerInfo[playerid][pSzerszamoslada] = 0,Msg(playerid, "Debugolva a l�d�d!");
			
	if(PlayerInfo[playerid][pSzerszamoslada] != 1)
		return Msg(playerid, "Nincs szersz�mosl�d�d");
			
	if(NemMozoghat(playerid) || PlayerState[playerid] != PLAYER_STATE_ONFOOT)
		return Msg(playerid, "Jelenleg nem haszn�lhatod");

	new kocsi = GetClosestVehicle(playerid);
	if(kocsi < 1 || GetPlayerDistanceFromVehicle(playerid, kocsi) > 7.5)
		return Msg(playerid, "A k�zeledben nincs j�rm�");

	new Float:hp;
	GetVehicleHealth(kocsi, hp);
	if(hp > 500.0)
		return Msg(playerid, "A j�rm� motorja nincs s�r�lve");

	new model = GetVehicleModel(kocsi);
	if(GetJarmu(kocsi, KOCSI_MOTORHAZTETO) != 1 && VData:(model-400):Type? == VEHICLE_TYPE_CAR)
		return Msg(playerid, "A j�rmu motorh�zteteje z�rva van");

	Cselekves(playerid, "elkezdte megjav�tani a j�rmuv�t");
	Msg(playerid, "Elkezdted megjav�tani a j�rm�vedet");
	SetTimerEx("Munkavege", MunkaIdo[12], false, "ddd", playerid, M_JARMUJAVITAS, kocsi);
	Freeze(playerid);
	ApplyAnimation(playerid, "SCRATCHING", "scmid_l", 4.0, 1, 1, 1, 1, 0, 1);
	MunkaFolyamatban[playerid] = 1;
	return 1;
}

CMD:unrent(playerid,params[])
{
	if(IsPlayerConnected(playerid))
	{
		new playername[MAX_PLAYER_NAME];
	
		GetPlayerName(playerid, playername, sizeof(playername));
		if(Berlo(playerid) == NINCS)
		{
			SendClientMessage(playerid, COLOR_WHITE, "   Nincs b�relt h�zad !");
			return 1;
		}
		PlayerInfo[playerid][pBerlo] = NINCS;
		SendClientMessage(playerid, COLOR_WHITE, "B�rl�s lemondva.");
	}
	return 1;
}
CMD:kocka(playerid,params[])
{
	if(IsPlayerConnected(playerid))
	{
		if(PlayerToPoint(100, playerid, 30.875, -88.9609, 1004.53))
		{
			BankkartyaFizet(playerid,-800);
			//GiveMoney(playerid, -800);
			gDice[playerid] = 1;
			SendClientMessage(playerid, COLOR_WHITE, " Kocka megv�ve. A /kockahelp parancsban sok seg�ts�get tal�lsz");
			return 1;
		}
	}
	else
	{
		Msg(playerid, "Nem vagy 24/7-ben!");
	}
	return 1;
}
CMD:chips(playerid,params[])
{
	if(FloodCheck(playerid)) return 1;
	if(!IsPlayerInAnyVehicle(playerid))
	{
		if(PlayerToPoint(100, playerid, 30.875, -88.9609, 1004.53))
		{
            if(GetMoney(playerid) > 500)
            {
				Msg(playerid, "Vett�l egy chips et!");
				BankkartyaFizet(playerid,-500);
				new Float:hp;
				GetPlayerHealth(playerid, hp);
				Cselekves(playerid, "vett egy  chio chipset!");
            }
			else return Msg(playerid, "Nincs el�g p�nzed! (500Ft)");
		}
		else return Msg(playerid, "Nem vagy 24/7-ben!");
	}
	return 1;
}
CMD:joypad(playerid,params[])
{
	if(!SAdmin(playerid, 1)) return 1;

	SendClientMessage(playerid, COLOR_WHITE, "=====[ Joypadosok ]=====");
	new db;
	foreach(Jatekosok, p)
	{
		if(Joypad[p] == NINCS)
		{
			db++;
			SendFormatMessage(playerid, COLOR_LIGHTRED, "[%d]%s", p, Nev(p));
		}
	}

	if(!db)
		SendClientMessage(playerid, COLOR_LIGHTGREEN, "Senki se joypadozik");

	return 1;
}
CMD:checkszint(playerid,params[])
{
	if(FloodCheck(playerid)) return 1;
	CheckSzint(playerid, true);
	return 1;
}
ALIAS(farmerked2s):farmerkedes;
CMD:farmerkedes(playerid,params[])
{
	if(!AMT(playerid, MUNKA_FARMER)) return Msg(playerid, "Te nem vagy Farmer!");
		
	if(OnDuty[playerid]) return Msg(playerid, "D�ntsd el�bb el mit dolgozol! ((frakci� dutyba nem!))");
	        
	if(!GetPlayerVehicleID(playerid))
		return 1;
		
	if(GetVehicleTrailer(GetPlayerVehicleID(playerid)))
	{
		if(GetVehicleModel(GetVehicleTrailer(GetPlayerVehicleID(playerid))) == 610)
		{
			Msg(playerid, "Lekapcsolva!");
			DetachTrailerFromVehicle(GetPlayerVehicleID(playerid));
			return 1;
		}
	}
		
	new kocsi = GetClosestVehicle(playerid, false);
	new Float:tavolsag = GetPlayerDistanceFromVehicle(playerid, kocsi);
		
	if(tavolsag <= 5.0)
	{
		if((GetVehicleModel(GetPlayerVehicleID(playerid)) == 531) && (GetVehicleModel(kocsi) == 610))
		{
			Msg(playerid, "Felkapcsolva!");
			AttachTrailerToVehicle(kocsi, GetPlayerVehicleID(playerid));
			return 1;
		}
	}
	return Msg(playerid, "Nincs a k�zeledben!");
}

ALIAS(b7tor):butor;
CMD:butor(playerid,params[])
{
	//if(1 == 1) return Msg(playerid, "Ideglenesen kiszedve!");
	Msg(playerid, "FIGYELEM BARIK�DRA NEM HASZN�LHAT�!!! CSAK RP-S BERENDEZ�SRE. MEGSZEG�S ESET�N A H�Z T�RL�SRE KER�L!!!");
	new butorszam = ButorSzam(playerid);
	if(butorszam == -2)
		return SendClientMessage(playerid, COLOR_LIGHTRED, "[Hiba]: Neked m�g nincs saj�t h�zad, miel�tt haszn�ln�d vegy�l egyet!");
	if(butorszam == NINCS && !Admin(playerid,1337))
		return SendClientMessage(playerid, COLOR_LIGHTRED, "[Hiba]: Csak a saj�t h�zadban haszn�lhatod!");

	ShowPlayerDialog(playerid, DIALOG_BUTOR, DIALOG_STYLE_LIST, #COL_FEHER"B�tor", "B�tor v�tel\nB�tor szerkeszt�s\nB�tor lista 1\nB�tor lista 2\nStatisztika\nPr�mium slotok v�s�rl�sa\n�sszes t�rl�se", "Mehet!", "Kil�p�s!");

	return true;
}
ALIAS(autoshortkey):ash;
ALIAS(autoshort):ash;
CMD:ash(playerid,params[])
{
	if(!Admin(playerid, 1)) return true;
	SendClientMessage(playerid, COLOR_LIGHTGREEN, "===== [ Lehets�ges AutoShortKey-t haszn�l�k ] =====");
	foreach(Jatekosok, x)
	{
		if(AFKszamlalo[x] >= 8)
			SendFormatMessage(playerid, COLOR_WHITE, "[%d]%s | Egyez� parancsok: 25/%d", x, PlayerName(x), AFKszamlalo[x]);
	}
	SendClientMessage(playerid, COLOR_LIGHTRED, "Ha legal�bb 8x ugyan azt a parancsot �rta be egym�s ut�n, akkor jelzi.");
	return true;
}
CMD:ttbolt(playerid,params[])
{
	if(IsScripter(playerid))
	{
		new osszes=BizzInfo[BIZ_247][bBevetel]+BizzInfo[BIZ_247][bAdomany];
		SendFormatMessage(playerid,COLOR_YELLOW,"Bev�tel a gazdas�gi �vben((resi)): %s Ft, �sszes ad�zott forgalom: %s",FormatNumber( BizzInfo[BIZ_247][bBevetel], 0, ',' ),FormatNumber( osszes, 0, ',' ));
	}

	SendFormatMessage(playerid,COLOR_YELLOW,"Class City News t�mogat�sa: %s, �sszes ad�zott forgalom: %s",FormatNumber( BizzInfo[BIZ_247][bAdomany]/2, 0, ',' ));
	return 1;
}
CMD:branks(playerid,params[])
{
	if(!BrascoTag(playerid)) return 1;
	SendClientMessage(playerid, COLOR_WHITE, "========== Brasco =========");
	foreach(Jatekosok, x)
	{
		if(BrascoTag(x))
		if(PlayerInfo[x][pRadio]) 
			SendFormatMessage(playerid, COLOR_GREY, "[%d]%s | Telefon: %d | R�di�: Van", x, ICPlayerName(x), PlayerInfo[x][pPnumber]);
		else SendFormatMessage(playerid, COLOR_GREY, "[%d]%s | Telefon: %d | R�di�: Nincs", x, ICPlayerName(x), PlayerInfo[x][pPnumber]);
	}
	SendClientMessage(playerid, COLOR_WHITE, "========== Brasco =========");
	return 1;
}
CMD:famdebug(playerid,params[])
{
	if(PlayerInfo[playerid][pID] == 8183364 || PlayerInfo[playerid][pID] == 6876 || PlayerInfo[playerid][pID] == 2326)
	{
		if(PlayerInfo[playerid][pCsaladLeader] != 1 && PlayerInfo[playerid][pID] == 6876) return PlayerInfo[playerid][pCsaladLeader] = 1; //Denaro alapb�l Brasco leader lesz.
		if(PlayerInfo[playerid][pCsaladLeader] != 2 && PlayerInfo[playerid][pID] == 8183364) return PlayerInfo[playerid][pCsaladLeader] = 2; //Krisztofer alapb�l Vincenzo leader lesz
		SendClientMessage(playerid, COLOR_LIGHTBLUE, "A csal�d leader automatikusan megadva a megfelel� szem�lyeknek");
	}
	return 1;
}
CMD:brascoleader(playerid,params[])
{
	if(!IsScripter(playerid)) return 1;
	new pid, kid, pm[32];
	if(sscanf(pm, "ri", pid, kid)) return Msg(playerid, "/brascoleader [J�t�kos] - kir�g�s / felv�tel");
	new brasco;
	brasco = ReturnUser(params);
	if(!IsPlayerConnected(brasco) || brasco == INVALID_PLAYER_ID) return Msg(playerid, "Nem online j�t�kos!");
       
	PlayerInfo[brasco][pCsaladTagja] = 1;
	PlayerInfo[brasco][pCsaladLeader] = 1;
		
	Msg(playerid, "Sikeresen felvetted/kir�gtad a j�t�kost!");
	return 1;
}
CMD:brasco(playerid,params[])
{
	new pm[32], pid, kid, spm[32];
	if(!BrascoLeader(playerid) && !IsScripter(playerid)) return 1;
	if(sscanf(spm, "ri", pid, kid)) return Msg(playerid, "/brasco [J�t�kos] - kir�g�s / felv�tel");
	new brasco;
	brasco = ReturnUser(params);
	if(!IsPlayerConnected(brasco) || brasco == INVALID_PLAYER_ID) return Msg(playerid, "Nem online j�t�kos!");
       
	if(!BrascoTag(brasco)) PlayerInfo[brasco][pCsaladTagja] = 1;
	else 
	{
		PlayerInfo[brasco][pCsaladTagja] = 0;
		PlayerInfo[brasco][pCsaladLeader] = 0;
	}
		
	Msg(playerid, "Sikeresen felvetted/kir�gtad a j�t�kost!");
		
	if(egyezik(pm, "help"))
	{
		if(BrascoTag(playerid))
		{
			Msg(playerid, "R�di� parancsok: /br - IC R�di� | /brb - OOC R�di� |");
			Msg(playerid, "Egy�b: branks - Csal�dtagok");
			Msg(playerid, "Eros�t�s: /bbk vagy /brascohelp - H�v�s | /cbbk - Lemond�s");
			//Msg(playerid, "Rangok: Nem Vincenzo(0)|Associate(1)|Soldato(2)|Caporegime(3)|Consigliere(4)|Boss(5)");
			if(BrascoLeader(playerid)) Msg(playerid, "Csal�dfo: /brascoleader - Kinevez�s | /bhq - Brasco Felh�v�s");
		}
		return 1;
	}
	return 1;
}
CMD:statisztika(playerid, params[])
{
	new pm[32];
	if(!Admin(playerid, 6))
		return SendClientMessage(playerid, COLOR_LIGHTRED, "[Hiba]: Ezt a parancsot nem haszn�lhatod!");

	if(sscanf(pm, "s[16]")) return Msg(playerid, "Haszn�lata: /statisztika [Szerver / Ter�letek]");
	
	if(egyezik(pm, "ter�letek") || egyezik(pm, "teruletek"))
	{
		SendClientMessage(playerid, COLOR_ORANGE, "================= [ Ter�let Statisztika ] =================");
		new x = NINCS, bool:vann = false;
		for(;++x < MAXTERULET;)
		{
			if(TeruletInfo[x][Van])
			{
				SendFormatMessage(playerid, COLOR_GREEN, "Ter�let: %d | Foglalva: %s | Tulaj: [%d]%s | N�v: %s", x, \
					MSinceTime( TeruletInfo[x][tFoglalva] ), TeruletInfo[x][tTulaj], Szervezetneve[TeruletInfo[x][tTulaj]-1][1], TeruletInfo[x][tNev]);
				vann = true;
			}
		}
		if(!vann)
			return SendClientMessage(playerid,COLOR_GREEN, "Jelenleg nincs bet�ltve egyetlen ter�let sem!");
	}
	if(egyezik(pm, "szerver") || egyezik(pm, "server"))
	{
		new x=NINCS,vskocsik, kocsik, terulet,
		hazak, garazsok, lehivott, kapuk, bizniszek;
		
		for(;++x < MAXVSKOCSI;)
		{
			if(CarInfo[x][Van] == 1)
				vskocsik++;
		}
		x=NINCS;
		for(;++x < MAXHAZ;)
		{
			if(HouseInfo[x][Van] == 1)
				hazak++;
		}
		x=NINCS;
		for(;++x < MAXGARAZS;)
		{
			if(GarazsInfo[x][Van] == 1)
				garazsok++;
		}
		x=NINCS;
		for(;++x < sizeof(CreatedCars);)
		{
			if(CreatedCars[x] != 0)
				lehivott++;
		}
		x=0;
		for(;++x < MAX_VEHICLES;)
		{
			if(IsVehicleConnected(x))
				kocsik++;
		}
		x=NINCS;
		for(;++x < MAX_KAPU;)
		{
			if(Kapu[x][kVan])
				kapuk++;
		}
		x=NINCS;
		for(;++x < MAXTERULET;)
		{
			if(TeruletInfo[x][Van])
				terulet++;
		}
		x=NINCS;
		for(;++x < MAXBIZ;)
		{
			if(BizzInfo[x][bVan])
				bizniszek++;
		}
		SendClientMessage(playerid, COLOR_ORANGE, "============= [ Szerver Statisztika ] =============");
		SendFormatMessage(playerid, COLOR_GREEN, "V-s j�rm�vek: %d/%d | H�zak: %d/%d | Gar�zsok: %d/%d",vskocsik,MAXVSKOCSI,hazak,MAXHAZ,garazsok,MAXGARAZS);
		SendFormatMessage(playerid, COLOR_GREEN, "�sszes j�rm�: %d/%d | Leh�vott j�rm�vek: %d/%d",kocsik,MAX_VEHICLES,lehivott,sizeof(CreatedCars));
		SendFormatMessage(playerid, COLOR_GREEN, "SQL Kapuk: %d/%d | Ter�letek: %d/%d | Objectek: %d",kapuk,MAX_KAPU,terulet,MAXTERULET,CountDynamicObjects());
		SendFormatMessage(playerid, COLOR_GREEN, "Bizniszek: %d/%d",bizniszek,MAXBIZ);
	}
	return true;
}

CMD:poz(playerid, params[])
{
	new cmd[32];
	sscanf(params, "s[32]", cmd);
	new bool:showVeh = (strlen(cmd) > 0 && egyezik(cmd, "veh"));
	
	new Float:posx, Float:posy, Float:posz, Float:angle;
	
	//ne �rd �t a form�t elegem van hogy �gy k�ldik...
	GetPlayerPos(playerid, posx, posy, posz);
	GetPlayerFacingAngle(playerid, angle);
	SendFormatMessage(playerid, COLOR_LIGHTRED, "Pozici�d: (XYZ: %.3f, %.3f, %.3f | Angle: %.3f | Int:%d | VW:%d)", posx, posy, posz, angle, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));
	
	if(showVeh && IsPlayerInAnyVehicle(playerid))
	{
		new veh = GetPlayerVehicleID(playerid);
		GetVehiclePos(veh, posx, posy, posz);
		GetVehicleZAngle(veh, angle);
		SendFormatMessage(playerid, COLOR_LIGHTRED, "J�rm� poz�ci�: (XYZ: %.3f, %.3f, %.3f | Angle: %.3f | Int:%d | VW:%d)", posx, posy, posz, angle, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));
	}
	
	return 1;
}
CMD:saveint(playerid, params[])
{
	if(IsPlayerConnected(playerid))
	{
		if (IsScripter(playerid))
		{
			GameTextForPlayer(playerid, "Interiorok mentve", 2500, 3);
			OnIntsUpdate();
		}
	}
	return 1;
}
CMD:loadint(playerid, params[])
{
	if(!IsScripter(playerid))
		return 1;
		
	GameTextForPlayer(playerid, "Interiorok betoltve", 2500, 3);
	LoadInts();

	return 1;
}
CMD:allcarrespawn(playerid, params[])
{
	if(PlayerInfo[playerid][pAdmin] >= 6 || IsScripter(playerid) && CarRespawnSzamlalo == NINCS)
	{
		if(CarRespawnSzamlalo != NINCS) return Msg(playerid, "M�r folyamatban van egy carresi!");
		ResiCounter = 60;
		TextDrawShowForAll(resitd);
	}
	return 1;
}
CMD:acrmost(playerid, params[])
{
	if(!Admin(playerid, 6)) return 1;
	if(CarRespawnSzamlalo != NINCS) return Msg(playerid, "M�r folyamatban van egy carresi!");
	ResiCounter = 0;
	ResiCounterFIX = true;
	TextDrawShowForAll(resitd);
	return 1;
}
CMD:bepakol(playerid, params[])
{
	Msg(playerid, "/kocsi bepakol");
	return 1;
}

CMD:kipakol(playerid, params[])
{
	Msg(playerid, "/kocsi kipakol");
	return 1;
}

ALIAS(gy4gyszereim):gyogyszereim;
CMD:gyogyszereim(playerid, params[])
{
	Cselekves(playerid, "megn�zte a gy�gyszert�sk�j�t.");
	ShowGyogyszerTaska(playerid, playerid);
	return 1;
}

/*CMD:kocsikulcs(playerid, params[])
{
	new pm[32], pid, kid, spm[32], jarmu;
	if(PlayerInfo[playerid][pPcarkey] == NINCS && PlayerInfo[playerid][pPcarkey2] == NINCS && PlayerInfo[playerid][pPcarkey3] == NINCS) return Msg(playerid, "Nincs j�rmuved.");
	if(sscanf(params, "s[32]S()[32]", pm, spm)) { Msg(playerid, "/kocsikulcs [ad/elvesz]"); if(Admin(playerid, 1337)) Msg(playerid, "/kocsikulcs t�r�l"); return true; }
	if(egyezik(pm, "ad"))
	{
		if(sscanf(spm, "ri", pid, kid)) return Msg(playerid, "/kocsikulcs ad [n�v/id] [1/2/3]");
		if(pid == INVALID_PLAYER_ID || pid == playerid) return Msg(playerid, "Nem l�tezo j�t�kos");
		if(GetDistanceBetweenPlayers(playerid, pid) > 3.0) return Msg(playerid, "Nincs a k�zeledben a j�t�kos.");
		if(kid == 1)
		{
			if(PlayerInfo[playerid][pPcarkey] == NINCS) return true;
			jarmu = PlayerInfo[playerid][pPcarkey];
		}
		elseif(kid == 2)
		{
			if(PlayerInfo[playerid][pPcarkey2] == NINCS) return true;
			jarmu = PlayerInfo[playerid][pPcarkey2];
		}
		elseif(kid == 3)
		{
			if(PlayerInfo[playerid][pPcarkey3] == NINCS) return true;
			jarmu = PlayerInfo[playerid][pPcarkey3];
		}
		else return Msg(playerid, "�gy tudom csak 3 j�rmuved lehet.. nem? :)");

		if(CarInfo[jarmu][cKulcsok][0] != NINCS && CarInfo[jarmu][cKulcsok][1] != NINCS) return Msg(playerid,"Csak k�t p�tkulcs van hozz�, amiket m�r �tadt�l valakinek!");
		if(PlayerInfo[pid][pKulcsok][0] != NINCS && PlayerInfo[pid][pKulcsok][1] != NINCS && PlayerInfo[pid][pKulcsok][2] != NINCS) return Msg(playerid,"N�la m�r t�bb mint 3 kulcs van");

		if(PlayerInfo[pid][pKulcsok][0] == NINCS)
			PlayerInfo[pid][pKulcsok][0] = CarInfo[jarmu][cId];
		elseif(PlayerInfo[pid][pKulcsok][1] == NINCS)
			PlayerInfo[pid][pKulcsok][1] = CarInfo[jarmu][cId];
		elseif(PlayerInfo[pid][pKulcsok][2] == NINCS)
			PlayerInfo[pid][pKulcsok][2] = CarInfo[jarmu][cId];

		if(CarInfo[jarmu][cKulcsok][0] == NINCS)
			CarInfo[jarmu][cKulcsok][0] = PlayerInfo[pid][pID], CarUpdate(jarmu, CAR_Kulcsok1);
		else
			CarInfo[jarmu][cKulcsok][1] = PlayerInfo[pid][pID], CarUpdate(jarmu, CAR_Kulcsok2);

		SendFormatMessage(playerid, COLOR_LIGHTGREEN, "�tadtad a j�rmuved egyik p�tkulcs�t neki: %s | V-s Rendsz�m: %d | J�rmuID: %d", ICPlayerName(pid), jarmu, CarInfo[jarmu][cId]);
		SendFormatMessage(pid, COLOR_LIGHTGREEN, "* %s odaadta a j�rmuve egyik p�tkulcs�t neked | V-s Rendsz�m: %d | J�rmuID: %d", ICPlayerName(playerid), jarmu, CarInfo[jarmu][cId]);
	}
	elseif(egyezik(pm, "elvesz"))
	{
		if(sscanf(spm, "ri", pid, kid)) return Msg(playerid, "/kocsikulcs elvesz [n�v/id] [1/2/3]");
		if(pid == INVALID_PLAYER_ID || pid == playerid) return Msg(playerid, "Nem l�tezo j�t�kos");
		if(GetDistanceBetweenPlayers(playerid, pid) > 3.0) return Msg(playerid, "Nincs a k�zeledben a j�t�kos.");
		if(kid == 1)
		{
			if(PlayerInfo[playerid][pPcarkey] == NINCS) return true;
			jarmu = PlayerInfo[playerid][pPcarkey];
		}
		elseif(kid == 2)
		{
			if(PlayerInfo[playerid][pPcarkey2] == NINCS) return true;
			jarmu = PlayerInfo[playerid][pPcarkey2];
		}
		elseif(kid == 3)
		{
			if(PlayerInfo[playerid][pPcarkey3] == NINCS) return true;
			jarmu = PlayerInfo[playerid][pPcarkey3];
		}
		else return Msg(playerid, "�gy tudom csak 3 j�rmuved lehet.. nem? :)");

		if(CarInfo[jarmu][cKulcsok][0] != PlayerInfo[pid][pID] && CarInfo[jarmu][cKulcsok][1] != PlayerInfo[pid][pID]) return Msg(playerid, "Ehhez a j�rmuh�z neki nincsen p�tkulcsa!");
		if(PlayerInfo[pid][pKulcsok][0] != CarInfo[jarmu][cId] && PlayerInfo[pid][pKulcsok][1] != CarInfo[jarmu][cId] && PlayerInfo[pid][pKulcsok][2] != CarInfo[jarmu][cId]) return Msg(playerid,"Ehhez a j�rmuh�z neki nincsen p�tkulcsa!");

		if(PlayerInfo[pid][pKulcsok][0] == CarInfo[jarmu][cId])
			PlayerInfo[pid][pKulcsok][0] = NINCS;
		if(PlayerInfo[pid][pKulcsok][1] == CarInfo[jarmu][cId])
			PlayerInfo[pid][pKulcsok][1] = NINCS;
		if(PlayerInfo[pid][pKulcsok][2] == CarInfo[jarmu][cId])
			PlayerInfo[pid][pKulcsok][2] = NINCS;

		if(CarInfo[jarmu][cKulcsok][0] == PlayerInfo[pid][pID])
			CarInfo[jarmu][cKulcsok][0] = NINCS, CarUpdate(jarmu, CAR_Kulcsok1);
		else
			CarInfo[jarmu][cKulcsok][1] = NINCS, CarUpdate(jarmu, CAR_Kulcsok2);

		SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Elvetted a j�rmuved p�tkulcs�t tole: %s | V-s Rendsz�m: %d | J�rmuID: %d", ICPlayerName(pid), jarmu, CarInfo[jarmu][cId]);
		SendFormatMessage(pid, COLOR_LIGHTGREEN, "* %s elvette a j�rmuve p�tkulcs�t toled | V-s Rendsz�m: %d | J�rmuID: %d", ICPlayerName(playerid), jarmu, CarInfo[jarmu][cId]);
	}
	elseif(egyezik(pm, "t�r�l") || egyezik(pm, "torol"))
	{
		if(!Admin(playerid, 1337)) return 1;
		new type;
		if(sscanf(spm, "ri", pid, type)) return Msg(playerid, "/kocsikulcs t�r�l [n�v/id] [1/2/3]");
		if(pid == INVALID_PLAYER_ID) return Msg(playerid, "Nem l�tezo j�t�kos");
		switch(type)
		{
			case 1:
			{
				if(CarInfo[PlayerInfo[pid][pKulcsok][0]][cKulcsok][0] == PlayerInfo[pid][pID])
					CarInfo[PlayerInfo[pid][pKulcsok][0]][cKulcsok][0] = NINCS, CarUpdate(jarmu, CAR_Kulcsok1);
				else
					CarInfo[PlayerInfo[pid][pKulcsok][0]][cKulcsok][1] = NINCS, CarUpdate(jarmu, CAR_Kulcsok1);

				PlayerInfo[pid][pKulcsok][0] = NINCS;

				SendFormatMessage(pid, COLOR_LIGHTRED, "ClassRPG: %s %s elvette az 1. p�tkulcsodat", AdminRangNev(playerid), AdminName(playerid));
				SendFormatMessage(playerid, COLOR_LIGHTRED, "ClassRPG: Elvetted %s 1. p�tkulcs�t", PlayerName(pid));
				format(_tmpString,sizeof(_tmpString),"<< %s %s elvette %s 1. p�tkulcs�t >>", AdminRangNev(playerid), AdminName(playerid), PlayerName(pid));
				SendMessage(SEND_MESSAGE_ADMIN,_tmpString,COLOR_LIGHTRED,PlayerInfo[playerid][pAdmin]);
			}
			case 2:
			{
				if(CarInfo[PlayerInfo[pid][pKulcsok][1]][cKulcsok][0] == PlayerInfo[pid][pID])
					CarInfo[PlayerInfo[pid][pKulcsok][1]][cKulcsok][0] = NINCS, CarUpdate(jarmu, CAR_Kulcsok1);
				else
					CarInfo[PlayerInfo[pid][pKulcsok][1]][cKulcsok][1] = NINCS, CarUpdate(jarmu, CAR_Kulcsok2);

				PlayerInfo[pid][pKulcsok][1] = NINCS;

				SendFormatMessage(pid, COLOR_LIGHTRED, "ClassRPG: %s %s elvette az 2. p�tkulcsodat", AdminRangNev(playerid), AdminName(playerid));
				SendFormatMessage(playerid, COLOR_LIGHTRED, "ClassRPG: Elvetted %s 2. p�tkulcs�t", PlayerName(pid));

				format(_tmpString,sizeof(_tmpString),"<< %s %s elvette %s 2. p�tkulcs�t >>", AdminRangNev(playerid), AdminName(playerid), PlayerName(pid));

				SendMessage(SEND_MESSAGE_ADMIN,_tmpString,COLOR_LIGHTRED,PlayerInfo[playerid][pAdmin]);
			}
			case 3:
			{
				if(CarInfo[PlayerInfo[pid][pKulcsok][2]][cKulcsok][0] == PlayerInfo[pid][pID])
					CarInfo[PlayerInfo[pid][pKulcsok][2]][cKulcsok][0] = NINCS, CarUpdate(jarmu, CAR_Kulcsok1);
				else
					CarInfo[PlayerInfo[pid][pKulcsok][2]][cKulcsok][1] = NINCS, CarUpdate(jarmu, CAR_Kulcsok2);

				PlayerInfo[pid][pKulcsok][2] = NINCS;

				SendFormatMessage(pid, COLOR_LIGHTRED, "ClassRPG: %s %s elvette az 3. p�tkulcsodat", AdminRangNev(playerid), AdminName(playerid));
				SendFormatMessage(playerid, COLOR_LIGHTRED, "ClassRPG: Elvetted %s 3. p�tkulcs�t", PlayerName(pid));


				format(_tmpString,sizeof(_tmpString),"<< %s %s elvette %s 3. p�tkulcs�t >>", AdminRangNev(playerid), AdminName(playerid), PlayerName(pid));
				SendMessage(SEND_MESSAGE_ADMIN,_tmpString,COLOR_LIGHTRED,PlayerInfo[playerid][pAdmin]);
			}
			default: Msg(playerid, "1/2/3");
		}
	}
	return 1;
}*/

ALIAS(h1zkulcs):hazkulcs;
CMD:hazkulcs(playerid, params[])
{
	new pm[32], pid, kid, spm[32], haz;
	if(PlayerInfo[playerid][pPhousekey] == NINCS && PlayerInfo[playerid][pPhousekey2] == NINCS && PlayerInfo[playerid][pPhousekey3] == NINCS) return Msg(playerid, "Nincs h�zad, akkor minek a kulcs�t akarod �tadni? c(:.");
	if(sscanf(params, "s[32]S()[32]", pm, spm)) { Msg(playerid, "/h�zkulcs [ad/elvesz]"); if(Admin(playerid, 1337)) Msg(playerid, "/h�zkulcs t�r�l"); return true; }
	if(egyezik(pm, "ad"))
	{
		if(sscanf(spm, "ri", pid, kid)) return Msg(playerid, "/h�zkulcs ad [n�v/id] [1/2/3]");
		if(pid == INVALID_PLAYER_ID || pid == playerid) return Msg(playerid, "Nem l�tez� j�t�kos");
		if(GetDistanceBetweenPlayers(playerid, pid) > 3.0) return Msg(playerid, "Nincs a k�zeledben a j�t�kos.");
		if(kid == 1)
		{
			if(PlayerInfo[playerid][pPhousekey] == NINCS) return true;
			haz = PlayerInfo[playerid][pPhousekey];
		}
		elseif(kid == 2)
		{
			if(PlayerInfo[playerid][pPhousekey2] == NINCS) return true;
			haz = PlayerInfo[playerid][pPhousekey2];
		}
		elseif(kid == 3)
		{
			if(PlayerInfo[playerid][pPhousekey3] == NINCS) return true;
			haz = PlayerInfo[playerid][pPhousekey3];
		}
		else return Msg(playerid, "�gy tudom csak 3 h�zad lehet, nem? :)");

		if(HouseInfo[haz][hKulcsVan][0] != NINCS && HouseInfo[haz][hKulcsVan][1] != NINCS) return Msg(playerid,"Csak k�t p�tkulcs van hozz�, amiket m�r �tadt�l valakinek!");
		if(PlayerInfo[pid][pHazKulcsok][0] != NINCS && PlayerInfo[pid][pHazKulcsok][1] != NINCS && PlayerInfo[pid][pHazKulcsok][2] != NINCS) return Msg(playerid,"M�r van 3 kulcsa, enn�l t�bb nem lehet neki!");

		if(PlayerInfo[pid][pHazKulcsok][0] == NINCS)
			PlayerInfo[pid][pHazKulcsok][0] = haz;
		elseif(PlayerInfo[pid][pHazKulcsok][1] == NINCS)
			PlayerInfo[pid][pHazKulcsok][1] = haz;
		elseif(PlayerInfo[pid][pHazKulcsok][2] == NINCS)
			PlayerInfo[pid][pHazKulcsok][2] = haz;

		if(HouseInfo[haz][hKulcsVan][0] == NINCS)
			HouseInfo[haz][hKulcsVan][0] = PlayerInfo[pid][pID], HazUpdate(haz, HAZ_Kulcsok1);
		else
			HouseInfo[haz][hKulcsVan][1] = PlayerInfo[pid][pID], HazUpdate(haz, HAZ_Kulcsok2);

		SendFormatMessage(playerid, COLOR_LIGHTGREEN, "�tadtad a h�zad egyik p�tkulcs�t neki: %s | H�zsz�m: %d", ICPlayerName(pid), haz);
		SendFormatMessage(pid, COLOR_LIGHTGREEN, "* %s odaadta a h�za egyik p�tkulcs�t neked | H�zsz�m: %d", ICPlayerName(playerid), haz);
	}
	elseif(egyezik(pm, "elvesz"))
	{
		if(sscanf(spm, "ri", pid, kid)) return Msg(playerid, "/h�zkulcs elvesz [n�v/id] [1/2/3]");
		if(pid == INVALID_PLAYER_ID || pid == playerid) return Msg(playerid, "Nem l�tez� j�t�kos");
		if(GetDistanceBetweenPlayers(playerid, pid) > 3.0) return Msg(playerid, "Nincs a k�zeledben a j�t�kos.");
		if(kid == 1)
		{
			if(PlayerInfo[playerid][pPhousekey] == NINCS) return true;
			haz = PlayerInfo[playerid][pPhousekey];
		}
		elseif(kid == 2)
		{
			if(PlayerInfo[playerid][pPhousekey2] == NINCS) return true;
			haz = PlayerInfo[playerid][pPhousekey2];
		}
		elseif(kid == 3)
		{
			if(PlayerInfo[playerid][pPhousekey3] == NINCS) return true;
			haz = PlayerInfo[playerid][pPhousekey3];
		}
		else return Msg(playerid, "�gy tudom csak 3 h�zad lehet, nem? :)");

		if(HouseInfo[haz][hKulcsVan][0] != PlayerInfo[pid][pID] && HouseInfo[haz][hKulcsVan][1] != PlayerInfo[pid][pID]) return Msg(playerid, "Ehhez a h�zhoz neki nincsen p�tkulcsa!");
		if(PlayerInfo[pid][pHazKulcsok][0] != haz && PlayerInfo[pid][pHazKulcsok][1] != haz && PlayerInfo[pid][pHazKulcsok][2] != haz) return Msg(playerid,"Ehhez a h�zhoz neki nincsen p�tkulcsa!");

		if(PlayerInfo[pid][pHazKulcsok][0] == haz)
			PlayerInfo[pid][pHazKulcsok][0] = NINCS;
		if(PlayerInfo[pid][pHazKulcsok][1] == haz)
			PlayerInfo[pid][pHazKulcsok][1] = NINCS;
		if(PlayerInfo[pid][pHazKulcsok][2] == haz)
			PlayerInfo[pid][pHazKulcsok][2] = NINCS;

		if(HouseInfo[haz][hKulcsVan][0] == PlayerInfo[pid][pID])
			HouseInfo[haz][hKulcsVan][0] = NINCS, HazUpdate(haz, HAZ_Kulcsok1);
		else
			HouseInfo[haz][hKulcsVan][1] = NINCS, HazUpdate(haz, HAZ_Kulcsok2);

		SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Elvetted a h�zad p�tkulcs�t tole: %s | H�zsz�m: %d", ICPlayerName(pid), haz);
		SendFormatMessage(pid, COLOR_LIGHTGREEN, "* %s elvette a h�za p�tkulcs�t toled | H�zsz�m: %d", ICPlayerName(playerid), haz);
	}
	elseif(egyezik(pm, "t�r�l") || egyezik(pm, "torol"))
	{
		if(!Admin(playerid, 1337)) return 1;
		new type;
		if(sscanf(spm, "ri", pid, type)) return Msg(playerid, "/h�zkulcs t�r�l [n�v/id] [1/2/3]");
		if(pid == INVALID_PLAYER_ID) return Msg(playerid, "Nem l�tez� j�t�kos");
		switch(type)
		{
			case 1:
			{
				if(HouseInfo[PlayerInfo[pid][pHazKulcsok][0]][hKulcsVan][0] == PlayerInfo[pid][pID])
					HouseInfo[PlayerInfo[pid][pHazKulcsok][0]][hKulcsVan][0] = NINCS, HazUpdate(haz, HAZ_Kulcsok1);
				else
					HouseInfo[PlayerInfo[pid][pHazKulcsok][0]][hKulcsVan][1] = NINCS, HazUpdate(haz, HAZ_Kulcsok1);

				PlayerInfo[pid][pHazKulcsok][0] = NINCS;

				SendFormatMessage(pid, COLOR_LIGHTRED, "ClassRPG: %s %s elvette az 1. h�zkulcsodat", AdminRangNev(playerid), AdminName(playerid));
				SendFormatMessage(playerid, COLOR_LIGHTRED, "ClassRPG: Elvetted %s 1. h�zkulcs�t", PlayerName(pid));
				format(_tmpString,sizeof(_tmpString),"<< %s %s elvette %s 1. h�zkulcs�t >>", AdminRangNev(playerid), AdminName(playerid), PlayerName(pid));
				SendMessage(SEND_MESSAGE_ADMIN,_tmpString,COLOR_LIGHTRED,PlayerInfo[playerid][pAdmin]);
			}
			case 2:
			{
				if(HouseInfo[PlayerInfo[pid][pHazKulcsok][1]][hKulcsVan][0] == PlayerInfo[pid][pID])
					HouseInfo[PlayerInfo[pid][pHazKulcsok][1]][hKulcsVan][0] = NINCS, HazUpdate(haz, HAZ_Kulcsok1);
				else
					HouseInfo[PlayerInfo[pid][pHazKulcsok][1]][hKulcsVan][1] = NINCS, HazUpdate(haz, HAZ_Kulcsok2);

				PlayerInfo[pid][pHazKulcsok][1] = NINCS;

				SendFormatMessage(pid, COLOR_LIGHTRED, "ClassRPG: %s %s elvette az 2. h�zkulcsodat", AdminRangNev(playerid), AdminName(playerid));
				SendFormatMessage(playerid, COLOR_LIGHTRED, "ClassRPG: Elvetted %s 2. h�zkulcs�t", PlayerName(pid));

				format(_tmpString,sizeof(_tmpString),"<< %s %s elvette %s 2. h�zkulcs�t >>", AdminRangNev(playerid), AdminName(playerid), PlayerName(pid));

				SendMessage(SEND_MESSAGE_ADMIN,_tmpString,COLOR_LIGHTRED,PlayerInfo[playerid][pAdmin]);
			}
			case 3:
			{
				if(HouseInfo[PlayerInfo[pid][pHazKulcsok][2]][hKulcsVan][0] == PlayerInfo[pid][pID])
					HouseInfo[PlayerInfo[pid][pHazKulcsok][2]][hKulcsVan][0] = NINCS, HazUpdate(haz, HAZ_Kulcsok1);
				else
					HouseInfo[PlayerInfo[pid][pHazKulcsok][2]][hKulcsVan][1] = NINCS, HazUpdate(haz, HAZ_Kulcsok2);

				PlayerInfo[pid][pHazKulcsok][2] = NINCS;

				SendFormatMessage(pid, COLOR_LIGHTRED, "ClassRPG: %s %s elvette az 3. h�zkulcsodat", AdminRangNev(playerid), AdminName(playerid));
				SendFormatMessage(playerid, COLOR_LIGHTRED, "ClassRPG: Elvetted %s 3. h�zkulcs�t", PlayerName(pid));


				format(_tmpString,sizeof(_tmpString),"<< %s %s elvette %s 3. h�zkulcs�t >>", AdminRangNev(playerid), AdminName(playerid), PlayerName(pid));
				SendMessage(SEND_MESSAGE_ADMIN,_tmpString,COLOR_LIGHTRED,PlayerInfo[playerid][pAdmin]);
			}
			default: Msg(playerid, "1/2/3");
		}
	}
	return 1;
}


ALIAS(sokkolo):tazer;
ALIAS(sokkol4):tazer;
CMD:tazer(playerid, params[])
{
	if(!IsACop(playerid)) return Msg(playerid, "Nem vagy rend�r!");
	if(!OnDuty[playerid]) return Msg(playerid, "Nem vagy szolg�latban!");
	if(IsPlayerInAnyVehicle(playerid)) return Msg(playerid, "J�rm�ben nem haszn�lhatod.");
	if(WeaponArmed(playerid) != WEAPON_DEAGLE && WeaponArmed(playerid) != WEAPON_SILENCED) return Msg(playerid, "Erre a fegyverre nem szerelheted fel a sokkol�t.");
	if(!Tazer[playerid]) Tazer[playerid] = true, SendClientMessage(playerid, COLOR_LIGHTGREEN, "Sokkol� bekapcsolva.");
	else Tazer[playerid] = false, SendClientMessage(playerid, COLOR_LIGHTGREEN, "Sokkol� kikapcsolva.");
	return 1;
} 
 
ALIAS(5l2sid6):olesido;
CMD:olesido(playerid, params[])
{
	SendFormatMessage(playerid, COLOR_LIGHTRED, "ClassRPG: A k�vetkez� k�rh�z %d m�sodperccel t�bb id� lesz az �l�seid sz�ma miatt.", PlayerInfo[playerid][pOlesIdo]);
	new p1[32], p2, p3;
	if(Admin(playerid, 4))
	{
		if(sscanf(params, "s[16]ud", p1, p2, p3)) return Msg(playerid, "/�l�sid� [give/set] [j�t�kos] [mennyis�g (m�sodpercben!)]");
		if(egyezik(p1, "give"))
		{
			if(p2 == INVALID_PLAYER_ID) return Msg(playerid, "Nem l�tez� j�t�kos");
			if(PlayerInfo[p2][pOlesIdo] < -p3) return Msg(playerid, "M�nuszba nem rakhatod az �sszes k�rh�zidej�t!");
			PlayerInfo[p2][pOlesIdo] += p3;
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Hozz�adt�l %s k�rh�zidej�hez ennyit: %d | �j k�rh�zideje: %d", PlayerName(p2), p3, PlayerInfo[p2][pOlesIdo]);
			format(_tmpString,sizeof(_tmpString),"<< %s hozz�adott %s k�rh�zidej�hez %d m�sodpercet | �j k�rh�zideje: %d", AdminName(playerid), PlayerName(p2), p3, PlayerInfo[p2][pOlesIdo]);
			SendMessage(SEND_MESSAGE_ADMIN,_tmpString,COLOR_LIGHTRED,PlayerInfo[playerid][pAdmin]);
		}
		elseif(egyezik(p1, "set"))
		{
			if(p2 == INVALID_PLAYER_ID) return Msg(playerid, "Nem l�tez� j�t�kos");
			new olesideje = PlayerInfo[p2][pOlesIdo];
			if(p3 < 0) return Msg(playerid, "M�nuszba nem rakhatod az �sszes k�rh�zidej�t!");
			PlayerInfo[p2][pOlesIdo] = p3;
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Be�ll�tottad %s k�rh�zidej�t ennyire: %d | R�gi k�rh�zideje: %d", PlayerName(p2), p3, olesideje);
			format(_tmpString,sizeof(_tmpString),"<< %s be�ll�totta %s k�rh�zidej�t %d m�sodpercre | R�gi k�rh�zideje: %d", AdminName(playerid), PlayerName(p2), p3, olesideje);
			SendMessage(SEND_MESSAGE_ADMIN,_tmpString,COLOR_LIGHTRED,PlayerInfo[playerid][pAdmin]);
		}
	}
	return 1;
}

CMD:help(playerid)
{
	ShowPlayerDialog(playerid, DIALOG_HELP, DIALOG_STYLE_LIST, "Seg�ts�g", "1. Alap\n2. Munka\n3. H�z\n4. J�rm�\n5. Biznisz\n6. Leader\n7. Hal\n8. S�t�s\n9. IRC\n10. Egy�b", "V�laszt", "Kil�p�s");
	return 1;
}

CMD:gps(playerid)
{
	if(PlayerInfo[playerid][pLokator] == 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "Nincs GPS Lok�torod...");

	GPSmenu(playerid);
	
	return 1;
}

/*CMD:help(playerid, params[])
{
	new type[32];
	if(sscanf(params, "s[16]", type)) return Msg(playerid, "/help [alap/munka/h�z/j�rmu/biznisz/leader/hal/s�t�s/irc/egy�b]");
	if(egyezik(type, "alap"))
	{
		Msg(playerid, "Felhaszn�l�i parancsok: /login /stats /zsebem /jelszovaltas", false, COLOR_YELLOW);
		Msg(playerid, "Adminisztr�tori seg�ts�gk�r�s: /report join [0-3] /� | Priv�t �zenet k�ld�s: /pm", false, COLOR_YELLOW);
		Msg(playerid, "Cselekv�sek kifejezoi: /me /va /ame /do /megpr�b�l | Kommunik�ci�: /o /s /c /l /b", false, COLOR_YELLOW);
	}
	elseif(egyezik(type, "munka"))
	{
		if(AMT(playerid, MUNKA_DETEKTIV))
			Msg(playerid,"Detekt�v: /find /adat", false, COLOR_YELLOW);
	    if(AMT(playerid, MUNKA_UGYVED))
			Msg(playerid,"�gyv�d: /free", false, COLOR_YELLOW);
		if(PlayerInfo[playerid][pSzerelo]>0)
		{
			Msg(playerid,"Aut�szerel�: /szerel�s /szerel�duty", false, COLOR_YELLOW);
			Msg(playerid,"Megjegyz�s: Az alap kocsik feljav�t�s��rt az �nkorm�nyzat fizet. PL.: Kamion, �ttiszt�t� stb...", false, COLOR_YELLOW);
		}
	    if(AMT(playerid, MUNKA_TESTOR))
			Msg(playerid,"Testor: /guard", false, COLOR_YELLOW);
		if(PlayerInfo[playerid][pAutoker]>0)
			Msg(playerid,"Aut�keresked�: (/k)eresked� | Import�l�s: /call 12345 | /autoker | /ar", false, COLOR_YELLOW);
		if(AMT(playerid, MUNKA_PIZZAS))
			Msg(playerid,"Pizzafut�r: /pizza", false, COLOR_YELLOW);
		if(AMT(playerid, MUNKA_PENZ))
			Msg(playerid,"P�nzsz�ll�t�: /psz vagy /p�nzsz�ll�t�", false, COLOR_YELLOW);
		if(AMT(playerid, MUNKA_POSTAS))
			Msg(playerid,"Post�s: /felt�lt /post�s", false, COLOR_YELLOW);
		if(AMT(playerid, MUNKA_PILOTA))
			Msg(playerid,"Pil�ta: /utassz�ll�t�s", false, COLOR_YELLOW);
		if(AMT(playerid, MUNKA_UTTISZTITO))
			Msg(playerid,"�ttiszt�t�: /�ttiszt�t�s", false, COLOR_YELLOW);
		if(!IsACop(playerid))
			Msg(playerid,"Prostitu�lt: /sex", false, COLOR_YELLOW);
		if(!IsACop(playerid))
			Msg(playerid,"Drogkereskedo: /szed /k�sz�t", false, COLOR_YELLOW);
	    if(!IsACop(playerid))
			Msg(playerid,"Aut�tolvaj: /car /ellop", false, COLOR_YELLOW);
		if(!IsACop(playerid))
			Msg(playerid,"Fegyverkeresked�: /felvesz /k�sz�t", false, COLOR_YELLOW);
        if(!IsACop(playerid))
			Msg(playerid,"Hacker: /hack", false, COLOR_YELLOW);
		if(!IsACop(playerid))
			Msg(playerid,"P�nc�lk�sz�t�: /k�sz�t", false, COLOR_YELLOW);
		if(AMT(playerid, MUNKA_KAMIONOS))
			Msg(playerid,"Kamionos: /kamion /kr(kamionr�di�)", false, COLOR_YELLOW);
        if(AMT(playerid, MUNKA_FARMER))
			Msg(playerid,"Farmer: /farmerked�s /alma /vetes", false, COLOR_YELLOW);
		if(AMT(playerid, MUNKA_FUNYIRO))
			Msg(playerid,"F�ny�r�: /f�ny�r�s", false, COLOR_YELLOW);
		if(AMT(playerid, MUNKA_EPITESZ))
			Msg(playerid,"�p�t�sz: /fel�j�t�s", false, COLOR_YELLOW);
		if(AMT(playerid, MUNKA_KUKAS))
			Msg(playerid,"Kuk�s: /kuka", false, COLOR_YELLOW);
		if(AMT(playerid, MUNKA_VADASZ))
			Msg(playerid,"Vad�sz: /vad�sz", false, COLOR_YELLOW);
		if(AMT(playerid, MUNKA_BUS))
			Msg(playerid,"Busz: /fare", false, COLOR_YELLOW);
		if(AMT(playerid, MUNKA_RAKODO))
			Msg(playerid,"Csomagsz�ll�t�: /csomag [szolg�lat/felcsatol/felpakol/lepakol]", false, COLOR_YELLOW);
		if(AMT(playerid, MUNKA_BANYASZ))
			Msg(playerid, "B�ny�sz: /b�ny�sz [�t�lt�z/munka/megn�z/berak/sz�ll�t/lead]", false, COLOR_YELLOW);
		if(AMT(playerid, MUNKA_VILLANYSZERELO))
			Msg(playerid, "Villanyszerel�: /villanyszerel� [�t�lt�z/kezd�s]", false, COLOR_YELLOW);
		if(LMT(playerid, FRAKCIO_MENTO) || LMT(playerid, FRAKCIO_SFMENTO))
			Msg(playerid, "OMSZ: /r, /rb, /d, /heal, /duty, /mk, /ell�t, /lista, /accept medic, /nyit, /zar, /fizetesek, /mvisz, /drogteszt", false, COLOR_YELLOW);
		if(IsHitman(playerid))
		    Msg(playerid,"Hitman: /portable /(h)itman(r)�di� /m�reg /laptop ((Fontos: �l�s elott laptopba l�pj munk�ba))", false, COLOR_YELLOW);
   		if(IsDirector(playerid))
       		Msg(playerid, "Hitman Director: /hitman /hitmann�v", false, COLOR_YELLOW);
		if(IsOnkentes(playerid))
			Msg(playerid, "�nk�ntes Mentos: /�r /�rb /�nk�ntesek /�nk�ntesduty /ell�t /heal /lista /accept medic /mvisz", false, COLOR_YELLOW);
	}
	elseif(egyezik(type, "h�z"))
		Msg(playerid, "/enter /exit /open /home /heal /houseupgrade (/hu)", false, COLOR_YELLOW);
	elseif(egyezik(type, "j�rm�") || egyezik(type, "jarmu"))
	{
		Msg(playerid, "/motor /fill /fillcar /kanna", false, COLOR_YELLOW);
		Msg(playerid, "/v /�r�ktuning /tuning /kocsi", false, COLOR_YELLOW);
	}
	elseif(egyezik(type, "biznisz") || egyezik(type, "business"))
		Msg(playerid, "/biznisz /bizutal�s", false, COLOR_YELLOW);
	elseif(egyezik(type, "leader"))
	{
		Msg(playerid,"/invite /uninvite /giverank /sz�f /rakt�r /quitfaction", false, COLOR_YELLOW);
		if(PlayerInfo[playerid][pLeader] == 7)
			Msg(playerid,"/givetax", false, COLOR_YELLOW);
		if(PlayerInfo[playerid][pLeader] == 20)
			Msg(playerid,"/leszallit", false, COLOR_YELLOW);
	}
	elseif(egyezik(type, "fish") || egyezik(type, "hal"))
	{
		Msg(playerid,"/fish (Megpr�b�lsz halat fogni) /fishes (Megmutatja a kifogott halakat)", false, COLOR_YELLOW);
		Msg(playerid,"/throwback (Elengeded a legut�bbi kifogott halat) /throwbackall(Minden halat visszadobsz)", false, COLOR_YELLOW);
		Msg(playerid,"/releasefish (Elengeded az egyik halat)", false, COLOR_YELLOW);
	}
	elseif(egyezik(type, "s�t�s") || egyezik(type, "sutes") || egyezik(type, "cook"))
	{
		Msg(playerid,"/f�z�s (Ki�rja a lehet�s�geket) /megf�zve (Ki�rja miket f�zt�l meg)", false, COLOR_YELLOW);
		Msg(playerid,"/enni (Megeszed a f�zt�d)", false, COLOR_YELLOW);
	}
	elseif(egyezik(type, "irc"))
	{
		Msg(playerid,"/irc join /irc leave /irc password", false, COLOR_YELLOW);
		Msg(playerid,"/irc password /irc needpass /irc lock", false, COLOR_YELLOW);
		Msg(playerid,"/irc admins /irc motd /irc status /i", false, COLOR_YELLOW);
	}
	elseif(egyezik(type, "egy�b") || egyezik(type, "egyeb"))
	{
		Msg(playerid,"/�tad /f /eldob /accept /cancel /pay /pays /nyit /zar /enter /exit /carresi /zenec�m", false, COLOR_YELLOW);
		Msg(playerid,"/zuhanok /r /rb /b�rsz�f /banksz�mla /laptopom /menu /buy /service /�l�sid�", false, COLOR_YELLOW);
	}
	return 1;
}*/

CMD:jspecial(playerid, params[])
{
	if(!Munkarang(playerid, 4)) return Msg(playerid, "Minimum 4-es rang kell hogy haszn�lhasd!");
	if(!LMT(playerid,FRAKCIO_OKTATO)) return Msg(playerid, "Csak oktat�!");
	
	new player, km, jogsinev[128];
	if(sscanf(params, "rds[128]", player,km,jogsinev)) return Msg(playerid,"/jspecial [id] [KM] [jogsineve]");

	
	if(player == INVALID_PLAYER_ID) return Msg(playerid, "Nincs ilyen j�t�kos");
			
	if(GetDistanceBetweenPlayers(playerid, player) > 2) return Msg(playerid, "Nincs a k�zeledben!");
	
	format(PlayerInfo[player][pSpecialJogsiNev],128,"%s",jogsinev);
	PlayerInfo[player][pSpecialJogsiKm] = float(km)*1000.0;
	SendFormatMessage(playerid,COLOR_YELLOW,"[SPECI�LIS JOGOS�TV�NYT ADT�L] Megnevez�s: %s, KM: %.3f",PlayerInfo[player][pSpecialJogsiNev],PlayerInfo[player][pSpecialJogsiKm]/1000.0);
	SendFormatMessage(player,COLOR_YELLOW,"[SPECI�LIS JOGOS�TV�NY KAPT�L] Megnevez�s: %s, KM: %.3f",PlayerInfo[player][pSpecialJogsiNev],PlayerInfo[player][pSpecialJogsiKm]/1000.0);
	return 1;
}
CMD:kikerdez(playerid, params[])
{
	if(GetPlayerVirtualWorld(playerid)!=1555) return Msg(playerid, "A.A");
	if(FloodCheck(playerid,10)) return 1;
	if(!PlayerToPoint(3, playerid, -1265.607, -98.560, 14.458)) return Msg(playerid, "Nincs a k�zeledben!");
	new result[128];
	if(!IsACop(playerid))
	{
		format(result, 128, "P�nzt�ros: Csak rend�r�knek besz�lek!");
		ProxDetector(B_Tavol, BankNPC, result, COLOR_LIGHTBLUE, COLOR_LIGHTBLUE, COLOR_LIGHTBLUE, COLOR_LIGHTBLUE, COLOR_LIGHTBLUE);
		return 1;
	}
	elseif(Rob < 2500) 
	{
		format(result, 128, "P�nzt�ros: Nem tudok semmi �rdekeset mondani �n�knek!");
		ProxDetector(B_Tavol, BankNPC, result, COLOR_LIGHTBLUE, COLOR_LIGHTBLUE, COLOR_LIGHTBLUE, COLOR_LIGHTBLUE, COLOR_LIGHTBLUE);
		return 1;
	}
	else
	{
		
		format(result, 128, "P�nzt�ros: K�rem bej�ttek ide cirka %d f�, �s r�mfogt�k a fegyvert!",LSBankRablok);
		ProxDetector(B_Tavol, BankNPC, result, COLOR_LIGHTBLUE, COLOR_LIGHTBLUE, COLOR_LIGHTBLUE, COLOR_LIGHTBLUE, COLOR_LIGHTBLUE);
		
		format(result, 128, "P�nzt�ros: Azt a szem�lyt biztos felismerem aki r�m fogta a fegyvert �s �rd�tott!");
		ProxDetector(B_Tavol, BankNPC, result, COLOR_LIGHTBLUE, COLOR_LIGHTBLUE, COLOR_LIGHTBLUE, COLOR_LIGHTBLUE, COLOR_LIGHTBLUE);
		Msg(playerid,"/felismeri ID");
		return 1;
	}

}
CMD:felismeri(playerid, params[])
{
	if(GetPlayerVirtualWorld(playerid)!=1555) return Msg(playerid, "A.A");
	if(!PlayerToPoint(3, playerid, -1265.607, -98.560, 14.458)) return Msg(playerid, "Nincs a k�zeledben!");
	new rablo;
	new result[128];
	if(sscanf(params, "r", rablo)) return Msg(playerid,"id?");

	if(!PlayerToPoint(3, rablo, -1265.607, -98.560, 14.458)) return Msg(playerid, "Nincs a k�zelben a megjel�lt szem�ly!");
	if(!IsACop(playerid))
	{
		format(result, 128, "P�nzt�ros: Csak rend�r�knek besz�lek!");
		ProxDetector(B_Tavol, BankNPC, result, COLOR_LIGHTBLUE, COLOR_LIGHTBLUE, COLOR_LIGHTBLUE, COLOR_LIGHTBLUE, COLOR_LIGHTBLUE);
		return 1;
	}
	elseif(Rob < 2500) 
	{
		format(result, 128, "P�nzt�ros: Nem tudok semmi �rdekeset mondani �n�knek!");
		ProxDetector(B_Tavol, BankNPC, result, COLOR_LIGHTBLUE, COLOR_LIGHTBLUE, COLOR_LIGHTBLUE, COLOR_LIGHTBLUE, COLOR_LIGHTBLUE);
		return 1;
	}
	elseif(RabloID == rablo)
	{
		format(result, 128, "P�nzt�ros:Felismerem �t � volt az!");
		ProxDetector(B_Tavol, BankNPC, result, COLOR_LIGHTBLUE, COLOR_LIGHTBLUE, COLOR_LIGHTBLUE, COLOR_LIGHTBLUE, COLOR_LIGHTBLUE);
		return 1;
	}
	else
	{
		format(result, 128, "P�nzt�ros: Nem ismerem �gy fel, nem � �rd�tott r�m, de lehet hogy itt volt, nem tudom.");
		ProxDetector(B_Tavol, BankNPC, result, COLOR_LIGHTBLUE, COLOR_LIGHTBLUE, COLOR_LIGHTBLUE, COLOR_LIGHTBLUE, COLOR_LIGHTBLUE);
		return 1;
	
	}
}

CMD:zuhanok(playerid, params[])
{
	if(AfterLoginTime[playerid] < UnixTime) return Msg(playerid, "Nem haszn�lhatod ezt a parancsot, mert t�bb, mint 15 m�sodperce l�pt�l be!");
	new Float:pos[3];
	GetPlayerPos(playerid, ArrExt(pos));
	//PlayerInfo[playerid][pTeleportAlatt] = 1;
	SetPlayerPosFindZ(playerid, ArrExt(pos));
	Msg(playerid, "Teleport�lva");
	ABroadCastFormat(COLOR_LIGHTRED, 1, "<< %s alkalmazta a /zuhanok parancsot, �gy a legk�zelebbi szil�rd helyre ker�lt >>", PlayerName(playerid));
	AfterLoginTime[playerid] = 0;
	return 1;
}

ALIAS(korhaz):k4rh1z;
CMD:k4rh1z(playerid, params[])
{
	if(!PlayerToPoint(20,playerid,1944.6885,-2458.5464,13.5703) || GetPlayerVirtualWorld(playerid) != 104) return Msg(playerid, "Nem vagy k�rh�zban!");
	
	if(KorhazIdo[playerid] > 0)  return Msg(playerid,"Szeretn�d mi?!");
	
	if(MentoOnline() > 3) return Msg(playerid, "Van fent b�ven mentos, keresd ink�bb �ket!");
	new Float:elet;
	if(GetPlayerHealth(playerid,elet) > 100.0) return Msg(playerid, "T�j j�l vagy a k�rh�zi ell�t�shoz!");
		
	
	new ido = floatround(150.0 - elet);
	
	if(!BankkartyaFizet(playerid,ido*1000)) return SendFormatMessage(playerid,COLOR_YELLOW,"A k�rh�zi d�j: %s Ft",FormatInt(ido*1000));
	
	FrakcioSzef(FRAKCIO_MENTO,ido*1000);
	
	SendFormatMessage(playerid,COLOR_YELLOW,"Befek�dt�l a k�rh�zba ell�t�sra. Fell�p�l�si id�d: %d",ido);
	Jail(playerid,"+",ido,"korhaz","K�rh�z fell�p�l�s");
	
	SetPlayerHealth(playerid, 150.0);
	return 1;
}	
CMD:acr(playerid, params[])
{
	
	if(!Admin(playerid, 6)) return 1;
	
	if(CarRespawnSzamlalo != NINCS) return Msg(playerid, "M�r folyamatban van egy carresi!");
	
	if(sscanf(params, "d", ResiCounter)) 
		return Msg(playerid,"/acr [id�]");
	
	if(ResiCounter < 0) return Msg(playerid, "A-A null�n�l nagyobb kell!");
	ResiCounterFIX = true;
	TextDrawShowForAll(resitd);
	return 1;
}
CMD:carresiset(playerid, params[])
{
	if(!IsScripter(playerid)) return 1;
	new param[32],func[256];
	if(sscanf(params, "s[32]S()[256]", param, func)) 
	{
		Msg(playerid,"/carresiset [ido / db / info]");
		Msg(playerid,"ido = -1 kikapcsol, ezek a be�l�t�sok szerver restartig maradnak!");
		return 1;
	}
	if(egyezik(param,"id�") || egyezik(param,"ido"))
	{
		if(sscanf(func, "d",ResiCounter)) return Msg(playerid,"/carresiset id� (3600 == 1 �ra)");
	
		if(ResiCounter < 3600)
			return Msg(playerid, "Minimum 3600!"), ResiCounter = 3600;
			
		if(ResiCounter <= NINCS) 
			ResiCounter=NINCS,ResiCounterFIX = false;
		else
		{
			CarRespawnSzamlalo = NINCS;
			ResiCounterFIX = true;
			AutoResi = ResiCounter;
			SendFormatMessage(playerid,COLOR_YELLOW,"Az id� �t�rva: %d sec",ResiCounter);
		}
	}
	if(egyezik(param,"db"))
	{
	
		if(sscanf(func, "d",CarresiDB)) return Msg(playerid,"/carresiset db (3600 == 1 �ra)");
	
		if(CarresiDB < 1) CarresiDB=10;
		SendFormatMessage(playerid,COLOR_YELLOW,"A DB �t�rva: %d -re",CarresiDB);

	
	}
	if(egyezik(param,"info"))
	{
		if(ResiCounterFIX)
			SendFormatMessage(playerid,COLOR_YELLOW,"[INFO - FUT] %d DB, %d sec id�, %d Automata: %d sec",CarresiDB, ResiCounter, CarRespawnSzamlalo,AutoResi);
		else
			SendFormatMessage(playerid,COLOR_YELLOW,"[INFO - Nem FUT] %d DB, %d sec id�, %d Automata %d sec",CarresiDB, ResiCounter, CarRespawnSzamlalo,AutoResi);

	
	}

	return 1;
}
ALIAS(gyogyszer):gy4gyszer;
CMD:gy4gyszer(playerid, params[])
{
	if(Harcol[playerid]) return SeeKick(playerid, "[WAR] Gy�gyszer war k�zben!");
	
	new param[32];
	
	if(GyogyszerTime[playerid] > 0) return SendFormatMessage(playerid,COLOR_LIGHTRED,"A-A ez t�l s�r�! %d sec",GyogyszerTime[playerid]);
	
	if(sscanf(params, "s[32]", param)) 
	{
		Msg(playerid,"/gy�gyszer [aspirin / cataflan / info /]");
		
		return 1;
	}
	if(egyezik(param, "info"))
	{
		Msg(playerid, "Hogy ne lehessen haszn�lni �ket l�v�ld�z�s k�zben, akit megl�ttek nem tudha haszn�lni a term�keket!");
		Msg(playerid,"Aspirin: 10 hp-t t�lt /db-ja. Kiz�r�lag akkor haszn�lhat� ha a HP-d t�bb mint 70!");
		Msg(playerid,"Cataflan: 15 HP-t t�lt /db-ja. Kiz�r�lag akkor haszn�lhat� ha a HP-d 50 - 80 k�z�tt van!");
		return 1;
	}
	if(PlayerInfo[playerid][pLoves] > UnixTime)	return SendFormatMessage(playerid,COLOR_LIGHTRED,"Nem haszn�lhatod nem r�g megl�ttek: %d sec",PlayerInfo[playerid][pLoves]-UnixTime);
	if(egyezik(param, "aspirin"))
	{
		if(PlayerInfo[playerid][pAspirin] < 1) return Msg(playerid, "Nincs aspirined!");
		new Float:hp;
		GetPlayerHealth(playerid,hp);
		if(hp < 70.0) return Msg(playerid, "Ez a gy�gyszer m�r kev�s!");
		
		Cselekves(playerid,"bevett egy gy�gyszert!");
		
		GyogyszerTime[playerid] = 60;
		
		hp +=10.0;
		PlayerInfo[playerid][pAspirin]--;
		SetPlayerHealth(playerid,hp);
		return 1;
	}
	if(egyezik(param,"cataflan"))
	{
		if(PlayerInfo[playerid][pCataflan] < 1) return Msg(playerid, "Nincs cataflan-od!");
		new Float:hp;
		GetPlayerHealth(playerid,hp);
		if(hp < 50.0) return Msg(playerid, "Ez a gy�gyszer m�r kev�s!");
		if(hp > 80.0) return Msg(playerid, "Ez a gy�szer m�r er�s, ehhez t�l j�l vagy!");
		
		Cselekves(playerid,"bevett egy gy�gyszert!");
		
		GyogyszerTime[playerid] = 120;
		
		hp +=20.0;
		PlayerInfo[playerid][pCataflan]--;
		SetPlayerHealth(playerid,hp);
		return 1;
	
	
	}
	return 1;
}
CMD:taxi(playerid, params[])
{
	if(!LMT(playerid,FRAKCIO_TAXI)) return Msg(playerid, "Csak taxisok!");
	new param[32];
	new func[256];
	if(sscanf(params, "s[32]S()[256]", param, func)) 
	{
		Msg(playerid, "/taxi [lista / fogad / lemond / d�j / duty]");
		return 1;
	}
	if(egyezik(param, "duty"))
	{
		
		if(!PlayerToPoint(FrakcioInfo[FRAKCIO_TAXI][fDPosR], playerid, FrakcioInfo[FRAKCIO_TAXI][fDPosX],FrakcioInfo[FRAKCIO_TAXI][fDPosY],FrakcioInfo[FRAKCIO_TAXI][fDPosZ],FrakcioInfo[FRAKCIO_TAXI][fDVW],FrakcioInfo[FRAKCIO_TAXI][fDINT])) return Msg(playerid, "Nem vagy duty helyen!");
		
		if(Taxi[playerid][tDuty])
		{
			Taxi[playerid][tDuty] = false;
			OnDuty[playerid] = false;
			Munkaruha(playerid, 0);
			Cselekves(playerid, "vissza�lt�z�tt!");
			return 1;
		}
		else
		{
			Taxi[playerid][tDuty] = true;
			OnDuty[playerid] = true;
			
			Taxi[playerid][tFizetes] = 0;
			new string[128];
			format(string, sizeof(string), "Taxi Sof�r %s szolg�latban van, viteld�j: %dFt/Km", ICPlayerName(playerid), FrakcioInfo[FRAKCIO_TAXI][fDij]);
			SendClientMessageToAll(TEAM_GROVE_COLOR,string);
			Msg(playerid, "/taxi lista");
			
			Cselekves(playerid, "�t�lt�z�tt a munkaruh�j�ba", 0);
			
			Munkaruha(playerid, 1);
			Taxi[playerid][tDuty] = true;
			return 1;
		}
		
	}
	if(egyezik(param, "lista"))
	{
		

		SendClientMessage(playerid, COLOR_WHITE, "======= [H�v�slista] =======");
		foreach(Jatekosok, x)
			if(TaxiHivas[x] == 1) SendFormatMessage(playerid, COLOR_GREY, "[%d][%s]", x, ICPlayerName(x));
		SendClientMessage(playerid, COLOR_WHITE, "======= [H�v�slista] =======");
		
		return 1;
	}
	if(egyezik(param, "fogad"))
	{
	
		if(Taxi[playerid][tHivas]) return Msg(playerid, "M�r fogadt�l h�v�st! Vond vissza ha nem kell! /taxi lemond");
		if(!Taxi[playerid][tDuty]) return Msg(playerid, "Nem  vagy szolg�latban!");
		
		new jatekos;
		foreach(Jatekosok, x)
			if(TaxiHivas[x] == 1) jatekos = x;

		if(TaxiHivas[jatekos] != 1) return Msg(playerid, "Nem h�vott taxit!");
		TaxiHivas[jatekos] = 2;
		foreach(Jatekosok, x)
		{
			if(AdminDuty[x] == 0 && ScripterDuty[x] == 0)
				SetPlayerMarkerForPlayer(playerid, x, COLOR_INVISIBLE);
		}
		SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Fogadtad %s h�v�s�t!", ICPlayerName(jatekos));
		SendFormatMessage(jatekos, COLOR_LIGHTGREEN, "%s fogadta a h�v�sod!", ICPlayerName(playerid));
		SendFormatMessageToAll(COLOR_GREEN, "Taxi sof�r %s fogadta %s h�v�s�t", ICPlayerName(playerid), ICPlayerName(jatekos));
		SetPlayerMarkerForPlayer(playerid, jatekos, COLOR_YELLOW);
		SetPlayerMarkerForPlayer(jatekos, playerid, COLOR_YELLOW);
		
		TaxiHivasJelzes[playerid] = jatekos;
		Taxi[playerid][tHivas] = true;
		
		new taxiszoveg[64];
		format(taxiszoveg, 64, "Taxisof�r H�V�SRA MEGY\nViteld�j: %d Ft / KM",FrakcioInfo[FRAKCIO_TAXI][fDij]);
		
		new vehicleid = GetPlayerVehicleID(playerid);
		if(IsValidDynamic3DTextLabel(TAXITEXT[vehicleid])) DestroyDynamic3DTextLabel(TAXITEXT[vehicleid]), TAXITEXT[vehicleid]=INVALID_3D_TEXT_ID;
		TAXITEXT[vehicleid] = CreateDynamic3DTextLabel(taxiszoveg, COLOR_YELLOW_TAXI, 0.0, 0.0, 2.0, 20.0, INVALID_PLAYER_ID, vehicleid, 1);
		
		return 1;
	
	}
	if(egyezik(param, "lemond"))
	{
		if(!Taxi[playerid][tHivas]) return Msg(playerid, "Nincs mit lemondani!");
		
		Taxi[playerid][tHivas] = false;
		SendFormatMessage(TaxiHivasJelzes[playerid], COLOR_LIGHTGREEN, "Taxisof�r %s lemondta a sz�ll�t�st, nem megy �rted!",ICPlayerName(playerid));
		SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Lemondtad %s h�v�s�t!",ICPlayerName(TaxiHivasJelzes[playerid]));
		TaxiHivasJelzes[playerid] = NINCS;
		
		SetPlayerMarkerForPlayer(playerid, TaxiHivasJelzes[playerid], COLOR_INVISIBLE);
		SetPlayerMarkerForPlayer(TaxiHivasJelzes[playerid], playerid, COLOR_INVISIBLE);
		return 1;
	}
	if(egyezik(param, "d�j") || egyezik(param,"dij"))
	{
		if(!PlayerInfo[playerid][pLeader]) return Msg(playerid, "Csak leader!");
		if(sscanf(func, "d", FrakcioInfo[FRAKCIO_TAXI][fDij])) return Msg(playerid, "/taxi d�j [�ra]");
	
		SendFormatMessage(playerid,COLOR_YELLOW,"Egys�ges d�j �t�rva: %s Ft",FormatInt(FrakcioInfo[FRAKCIO_TAXI][fDij]));
		
		foreach(Jatekosok,x)
		{
			if(Taxi[x][tDuty])
				Taxi[x][tFizetes]=FrakcioInfo[FRAKCIO_TAXI][fDij];
		}
		
		return 1;
	}
	return 1;
}
CMD:object(playerid, params[])
{
	if(!Admin(playerid, 1338) && !IsScripter(playerid)) return 1;
	
	
	new param[32];
	new func[256];
	
	if(sscanf(params, "s[32]S()[256]", param, func)) 
	{
		Msg(playerid, "/object [funkci�]");
		Msg(playerid, "Funkci�k: [Go | uj | mod | help | �res | t�r�l | k�zel | objecttorles | t�bla | mod | felirat | otabla |]");
		Msg(playerid, "mod= m�d�s�t");
		return 1;
	}
	if(egyezik(param, "objecttorles"))
	{
		if(!Admin(playerid,5555)) return 1;
		
		new Float:x,Float:y,Float:z,Float:t, type;
		if(sscanf(func, "p<,>dffff", type,x,y,z,t)) return Msg(playerid, "/object objecttorles [tipus],[x],[y],[z],[tavol]");
		
		new id = NINCS;
		
		for(new a = 0; a < MAX_OBJECTSZ; a++)
		{
			if(OBJECT_TOROL[a][sTipus] == 0)
			{
				id = a;
				break;
			}
		}
		
		OBJECT_TOROL[id][sTipus] = type;
		OBJECT_TOROL[id][sPosX] = x;
		OBJECT_TOROL[id][sPosY] = y;
		OBJECT_TOROL[id][sPosZ] = z;
		OBJECT_TOROL[id][sTav] = t;
		
		foreach(Jatekosok, xx)
		{
			RemoveBuildingForPlayer(xx, type, x, y, z, t);
		}
		
		
		INI_Save(INI_TYPE_OBJECTTORLES, id);
	
	}
	if(egyezik(param, "go"))
	{
		
		new atmid;
		if(sscanf(func, "d", atmid)) return Msg(playerid, "/object go [OBJECT ID]");
		
		if(atmid < 0 || atmid > MAX_OBJECTSZ) return Msg(playerid, "Hib�s object ID.");
		//PlayerInfo[playerid][pTeleportAlatt] = 1;
		SetPlayerPos(playerid, OBJECT[atmid][sPosX], OBJECT[atmid][sPosY], OBJECT[atmid][sPosZ]+1.5);
		SendFormatMessage(playerid,  COLOR_LIGHTGREEN, "* Teleport�lt�l az object-hez. (ID: %d - Koord�n�ta: X: %f | Y: %f | Z: %f) ", atmid, OBJECT[atmid][sPosX], OBJECT[atmid][sPosY], OBJECT[atmid][sPosZ]);
	}
	if(egyezik(param, "help"))
	{
			if(IsScripter(playerid))
			{
				Msg(playerid,"11.808-11.999 (19901 kiv�tel�vel)");
				Msg(playerid,"Robbano: 1225 Sebes�g korl�tok: 30: 11878 50: 11880 90: 11884 130:11888 �vezet30: 11893 / 11895");
				Msg(playerid,"Bukkan�: 11.915 Villamos: 11.936 Vas�t:11.937 Busz: 11.946 Aut�p�lya: 11.808/11.809 Magass�g: 11.867");
				Msg(playerid,"k�telezo halad�si ir�ny elore: 11.818 el�lre-jobbra: 11.819 el�lre-balra: 11.820 balra: 11.821 jobbra: 11.822");
				Msg(playerid,"Hotdog: 1340 | Italautomata: 1775 | Csokiautomata: 1776 | Szerencseg�p: 2754 | Telefon: 1216");
				Msg(playerid,"Szerel�hely: 19898 | Szerel�Duty: 19627 | SignumCars Duty: 11705 |");
				Msg(playerid,"Kameran�z�: 19894 | GraffitiTilt: 19177 | Jegyautomata: 19526 | ArrestHely: 19234 |");
				return 1;
			}
			return 1;	
	}
	if(egyezik(param, "uj"))
	{
		new tipus;
		
		
		if(sscanf(func, "d", tipus))
		{
			Msg(playerid, "/object uj [t�pus]");
			Msg(playerid, "Hotdog: 1340, | Italautomata: 1775 | Csokiautomata: 1776 | Szerencseg�p: 2754 | Telefon: 1216");
			Msg(playerid, "Ha nem �rsz id-t automata �resra rakja.");
		}
		new id = NINCS;
		
		if(!IsTerno(playerid))
			Msg(playerid, "HQ-t �s NAGY mappokat NE EZZEL CSIN�LJATOK PLEASE!!!");
		
		if(tipus == 11977 || tipus == 11901) return Msg(playerid, "Ez a model nem haszn�lhat�!");
		
		for(new a = 0; a < MAX_OBJECTSZ; a++)
		{
			if(OBJECT[a][sTipus] == 0)
			{
				id = a;
				break;
			}
		}
		
		if(id < 0 || id >= MAX_OBJECTSZ) return Msg(playerid, "Nincs �res hely!");

		new Float:X, Float:Y, Float:Z, Float:A;
		GetPlayerPos(playerid, X, Y, Z);
		GetPlayerFacingAngle(playerid, A);
		
		id=UresObject();
		if(id == NINCS) return Msg(playerid, "Nincs �res hely");

	
		OBJECT[id][sInt] =GetPlayerInterior(playerid);
		OBJECT[id][sVw]=GetPlayerVirtualWorld(playerid);
		
		if(tipus == 1340)
		{
			Z+=0.12;
			A-=90.0;
		}
		else if(tipus == 1775)
			Z+=0.1;
		else if(tipus == 1776)
			Z+=0.08;
		else if(tipus == 1216)
			Z-=0.32;
		else if(tipus == 2754)
		{
			Z+=0.08;
			A+=90.0;
		}
		else if(!Admin(playerid,1337)) return Msg(playerid, "Szerintem rossz object");
		
		if(11808 <= tipus <= 11999)
			Z-=1.0;
			
		OBJECT[id][sTipus] = tipus;
		OBJECT[id][sPosX] = X;
		OBJECT[id][sPosY] = Y;
		OBJECT[id][sPosZ] = Z;
		OBJECT[id][sPosZX] = 0.0;
		OBJECT[id][sPosZY] = 0.0;
		OBJECT[id][sPosA] = A;

		if(OBJECT[id][sObjectID] > 0)
			if(IsValidDynamicObject(OBJECT[id][sObjectID])) DestroyDynamicObject(OBJECT[id][sObjectID]),OBJECT[id][sObjectID]=INVALID_OBJECT_ID;
		
		OBJECT[id][sObjectID] = CreateDynamicObject (tipus, X, Y, Z, 0.0, 0.0, OBJECT[id][sPosA], OBJECT[id][sVw], OBJECT[id][sInt]);

		SendFormatMessage(playerid,  COLOR_LIGHTGREEN, "* OBJECT lerakva. (ID: %d - T�pus: %d Koord�n�ta: X: %.2f | Y: %.2f | Z: %.2f | A: %.2f | VW: %d | INT: %d) ", id, tipus, OBJECT[id][sPosX], OBJECT[id][sPosY], OBJECT[id][sPosZ], OBJECT[id][sPosA], OBJECT[id][sVw],OBJECT[id][sInt]);
		Streamer_Update(playerid);
		//PlayerInfo[playerid][pTeleportAlatt] = 1;
		SetPlayerPos(playerid, X, Y, Z+3.0);
		
		
		EditDynamicObject(playerid, OBJECT[id][sObjectID]);
		
		ObjectSzerkeszt[playerid] = id;
		
	}
	if(egyezik(param,"otabla"))
	{
		if(!IsTerno(playerid)) return Msg(playerid,"A-A nem kell ennyiszer lerakni, megtal�lod �ket a rept�ren a 155 VW-ben!");
		
	
		
		new Float:tolas=2145.3970;
		for(new tipus=11808;tipus <=11999 ;tipus++)
		{
		
			new id = NINCS;
			
			for(new a = 0; a < MAX_OBJECTSZ; a++)
			{
				if(OBJECT[a][sTipus] == 0)
				{
					id = a;
					break;
				}
			}
			
			if(id < 0 || id >= MAX_OBJECTSZ) return Msg(playerid, "Nincs �res hely!");

			
		
			id=UresObject();
			if(id == NINCS) return Msg(playerid, "Nincs �res hely");

		
			OBJECT[id][sInt] =GetPlayerInterior(playerid);
			OBJECT[id][sVw]=155;
			
			
			
				
			OBJECT[id][sTipus] = tipus;
			OBJECT[id][sPosX] =tolas;
			OBJECT[id][sPosY] = -2577.6199;
			OBJECT[id][sPosZ] = 12.5469;
			OBJECT[id][sPosZX] = 0.0;
			OBJECT[id][sPosZY] = 0.0;
			OBJECT[id][sPosA] = 0.0;

			if(OBJECT[id][sObjectID] > 0)
				if(IsValidDynamicObject(OBJECT[id][sObjectID])) DestroyDynamicObject(OBJECT[id][sObjectID]),OBJECT[id][sObjectID]=INVALID_OBJECT_ID;
			
			OBJECT[id][sObjectID] = CreateDynamicObject (tipus, tolas, -2577.6199, 12.5469, 0.0, 0.0, OBJECT[id][sPosA], 155, OBJECT[id][sInt]);

			//SendFormatMessage(playerid,  COLOR_LIGHTGREEN, "* OBJECT lerakva. (ID: %d - T�pus: %d Koord�n�ta: X: %.2f | Y: %.2f | Z: %.2f | A: %.2f | VW: %d | INT: %d) ", id, tipus, OBJECT[id][sPosX], OBJECT[id][sPosY], OBJECT[id][sPosZ], OBJECT[id][sPosA], OBJECT[id][sVw],OBJECT[id][sInt]);
			Streamer_Update(playerid);
		
			
		
			tolas--;
			INI_Save(INI_TYPE_OBJECT, id);
		}
		Msg(playerid,"T�bl�k lerakva rept�ren az 155-�s VW-ben, felirat: /object felirat");
		return 1;
	}
	if(egyezik(param, "lista"))
	{
		new Float:Stav;
		new Float:PPos[3];
		new Float:tav;
		new torol;
		if(sscanf(func, "fd", Stav,torol)) return Msg(playerid,"/object lista [t�v] [t�r�l =1]");	
	
		if(torol < 0 || torol >1) return Msg(playerid,"t�r�l 1 nem t�r�l 0");
		GetPlayerPos(playerid, PPos[0], PPos[1], PPos[2]);
		
		SetPlayerCheckpoint(playerid, PPos[0], PPos[1], PPos[2],Stav);
		
		new File: file2;
		new idx =0;
		new coordsstring[300];
			
		for(new a = 0; a < MAX_OBJECTSZ; a++)
		{
			tav = GetDistanceBetweenPoints(PPos[0], PPos[1], PPos[2], OBJECT[a][sPosX], OBJECT[a][sPosY], OBJECT[a][sPosZ]);
			if(tav < Stav)
			{
				if(!(11808 <= OBJECT[a][sTipus] <= 11999))
				{
					if(OBJECT[a][sTipus] != 1340 && OBJECT[a][sTipus] != 1775 && OBJECT[a][sTipus] != 1776 && OBJECT[a][sTipus] != 2754 && OBJECT[a][sTipus] != 1216)
					{
					
					
						SendFormatMessage(playerid,COLOR_YELLOW,"CreateObject(%d, %.8f, %.8f, %.8f, %.8f, %.8f, %.8f);",OBJECT[a][sTipus],OBJECT[a][sPosX], OBJECT[a][sPosY],OBJECT[a][sPosZ],OBJECT[a][sPosZX],OBJECT[a][sPosZY],OBJECT[a][sPosA]);
						format(coordsstring, sizeof(coordsstring), "CreateObject(%d, %.8f, %.8f, %.8f, %.8f, %.8f, %.8f);\n",OBJECT[a][sTipus],OBJECT[a][sPosX], OBJECT[a][sPosY],OBJECT[a][sPosZ],OBJECT[a][sPosZX],OBJECT[a][sPosZY],OBJECT[a][sPosA]);
						if(idx == 0)
						{
							file2 = fopen("ObjectEditor/objectmentes.cfg", io_write);
						}
						else
						{
							file2 = fopen("ObjectEditor/objectmentes.cfg", io_append);
						}

						fwrite(file2, coordsstring);
						idx++;
						fclose(file2);
						
						if(torol == 1)
						{
							if(IsValidDynamic3DTextLabel(OBJECT[a][sFelirat]))
								DestroyDynamic3DTextLabel(OBJECT[a][sFelirat]),OBJECT[a][sFelirat]=INVALID_3D_TEXT_ID;
			
							if(OBJECT[a][sObjectID] > 0)
									if(IsValidDynamicObject(OBJECT[a][sObjectID]))DestroyDynamicObject(OBJECT[a][sObjectID]),OBJECT[a][sObjectID]=INVALID_OBJECT_ID;

							OBJECT[a][sTipus] = 0;
							OBJECT[a][sPosX] = 0.0;
							OBJECT[a][sPosY] = 0.0;
							OBJECT[a][sPosZ] = 0.0;
							OBJECT[a][sPosA] = 0.0;
							OBJECT[a][sVw] = 0;
							OBJECT[a][sInt] = 0;
							OBJECT[a][sObjectID] =0;
							SendFormatMessage(playerid,  COLOR_LIGHTGREEN, "T�r�lve Object: %d",a);
							
							INI_Save(INI_TYPE_OBJECT, a);
						
						
						}
					}
				
				}
			}
		}
	
		Msg(playerid,"Ki�rva a k�zelben l�v� objectek. A chatlogb�l ki tudod m�solni!!!!");
	}
	if(egyezik(param, "felirat"))
	{
	
		new Float:Stav;
		new Float:PPos[3];
		new Float:tav;
		new bool:kikapcsol=false;
		if(sscanf(func, "f", Stav)) return Msg(playerid,"/object felirat [t�v]");	
	
		GetPlayerPos(playerid, PPos[0], PPos[1], PPos[2]);
		
		SetPlayerCheckpoint(playerid, PPos[0], PPos[1], PPos[2],Stav);
		
		for(new a = 0; a < MAX_OBJECTSZ; a++)
		{
			if(OBJECT[a][sTipus] != 0)
			{
				if(IsValidDynamic3DTextLabel(OBJECT[a][sFelirat]))
					DestroyDynamic3DTextLabel(OBJECT[a][sFelirat]),kikapcsol=true,OBJECT[a][sFelirat]=INVALID_3D_TEXT_ID;
			}
		}
		if(kikapcsol) return Msg(playerid,"Feliratok kikapcsolva"),Streamer_Update(playerid);
		
		for(new a = 0; a < MAX_OBJECTSZ; a++)
		{
			tav = GetDistanceBetweenPoints(PPos[0], PPos[1], PPos[2], OBJECT[a][sPosX], OBJECT[a][sPosY], OBJECT[a][sPosZ]);
			if(tav < Stav)
			{
			
				new felirat[128]; format(felirat, 128, "{FFFF00}==Model: %s ==", FormatNumber(OBJECT[a][sTipus]));
				new Float:tolas=1.0;
				
				if(11808 <= OBJECT[a][sTipus] <= 11999)
					tolas = 2.5;
				
					
				if(OBJECT[a][sVw] == -1) OBJECT[a][sVw] = 0;
				if(OBJECT[a][sInt] == -1) OBJECT[a][sInt] = 0;
				
				OBJECT[a][sFelirat] = CreateDynamic3DTextLabel(felirat, 0x22AAFFFF,OBJECT[a][sPosX], OBJECT[a][sPosY],OBJECT[a][sPosZ]+tolas, 35.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, OBJECT[a][sVw], OBJECT[a][sInt], 0, NINCS, 35.0);
			}
		}
		
	
		Streamer_Update(playerid);
		Msg(playerid,"Feliratok be kapcsolva!");
		
		return 1;
	}
	if(egyezik(param, "vw"))
	{
		
		new Float:PPos[3], Float:legkozelebb = 5000.0, Float:tav;
		new vw;
		if(sscanf(func, "d", vw)) return Msg(playerid, "/object vw");
		
		GetPlayerPos(playerid, PPos[0], PPos[1], PPos[2]);
		new id;
		for(new a = 0; a < MAX_OBJECTSZ; a++)
		{
			tav = GetDistanceBetweenPoints(PPos[0], PPos[1], PPos[2], OBJECT[a][sPosX], OBJECT[a][sPosY], OBJECT[a][sPosZ]);
			if(tav < legkozelebb)
			{
				legkozelebb = tav;
				id = a;
			}
		}
		
		OBJECT[id][sVw] = vw;
		if(OBJECT[id][sObjectID] > 0)
			if(IsValidDynamicObject(OBJECT[id][sObjectID])) DestroyDynamicObject(OBJECT[id][sObjectID]),OBJECT[id][sObjectID]=INVALID_OBJECT_ID;
		
		OBJECT[id][sObjectID] = CreateDynamicObject (OBJECT[id][sTipus], OBJECT[id][sPosX], OBJECT[id][sPosY], OBJECT[id][sPosZ], OBJECT[id][sPosZX], OBJECT[id][sPosZY], OBJECT[id][sPosA], OBJECT[id][sVw], OBJECT[id][sInt]);
		
		INI_Save(INI_TYPE_OBJECT, id);
		
		return 1;
	}
	if(egyezik(param, "mod") || egyezik(param, "modosit"))
	{
		
		new Float:PPos[3], Float:legkozelebb = 5000.0, Float:tav;
		new objectid = NINCS;
		
		if(sscanf(func, "d", objectid))
		{
			GetPlayerPos(playerid, PPos[0], PPos[1], PPos[2]);
			new id;
			for(new a = 0; a < MAX_OBJECTSZ; a++)
			{
				tav = GetDistanceBetweenPoints(PPos[0], PPos[1], PPos[2], OBJECT[a][sPosX], OBJECT[a][sPosY], OBJECT[a][sPosZ]);
				if(tav < legkozelebb)
				{
					legkozelebb = tav;
					id = a;
				}
			}
			
			EditDynamicObject(playerid, OBJECT[id][sObjectID]);
			
			ObjectSzerkeszt[playerid] = id;
		}
		else
		{
			if(!IsValidDynamicObject(OBJECT[objectid][sObjectID]))
			{
				return Msg(playerid, "Nincs ilyen object.");
			}
			
			EditDynamicObject(playerid, OBJECT[objectid][sObjectID]);
			
			ObjectSzerkeszt[playerid] = objectid;
		}
		
		return 1;
	
	
	}
	if(egyezik(param, "t�r�l"))
	{
		new id;
		new Float:PPos[3], Float:legkozelebb = 5000.0, Float:tav;
		
		if(sscanf(func, "d", id))
		{
		
			GetPlayerPos(playerid, PPos[0], PPos[1], PPos[2]);
			
			for(new a = 0; a < MAX_OBJECTSZ; a++)
			{
				tav = GetDistanceBetweenPoints(PPos[0], PPos[1], PPos[2], OBJECT[a][sPosX], OBJECT[a][sPosY], OBJECT[a][sPosZ]);
				if(tav < legkozelebb)
				{
					legkozelebb = tav;
					id = a;
				}
			}
		
		}
		
		if(id < 0 || id >= MAX_OBJECTSZ) return Msg(playerid, "Hib�s SORSZ�M ID.");
		
		if(IsValidDynamic3DTextLabel(OBJECT[id][sFelirat]))
					DestroyDynamic3DTextLabel(OBJECT[id][sFelirat]),OBJECT[id][sFelirat]=INVALID_3D_TEXT_ID;
		
		if(OBJECT[id][sObjectID] > 0)
				if(IsValidDynamicObject(OBJECT[id][sObjectID]))DestroyDynamicObject(OBJECT[id][sObjectID]),OBJECT[id][sObjectID]=INVALID_OBJECT_ID;

		OBJECT[id][sTipus] = 0;
		OBJECT[id][sPosX] = 0.0;
		OBJECT[id][sPosY] = 0.0;
		OBJECT[id][sPosZ] = 0.0;
		OBJECT[id][sPosA] = 0.0;
		OBJECT[id][sVw] = 0;
		OBJECT[id][sInt] = 0;
		OBJECT[id][sObjectID] =0;
		SendFormatMessage(playerid,  COLOR_LIGHTGREEN, "T�r�lve Object: %d",id);
		
		INI_Save(INI_TYPE_OBJECT, id);
		//SaveOBJECT();
	}
	if(egyezik(param, "�res"))
	{
		new szamlalo;
		for(new a = 0; a < MAX_OBJECTSZ; a++)
		{
			if(OBJECT[a][sTipus] == 0)
			{
				SendFormatMessage(playerid,  COLOR_LIGHTGREEN, "*�res Object: ID: %d ",a);
				szamlalo++;
				if(szamlalo > 6) return 1;
			}
		}
	}
	if(egyezik(param, "tabla"))
	{
		/*
		for(new a = 0; a < MAX_OBJECTSZ; a++)
		{
			if(OBJECT[a][sTipus] >= 19808)
			{
				OBJECT[a][sTipus] = OBJECT[a][sTipus] - 8000;
				INI_Save(INI_TYPE_OBJECT, a);
			}
		}
	*/
		Msg(playerid,"a-a nincs K�SZ");
		
	}
	if(egyezik(param, "k�zel"))
	{
		SendClientMessage(playerid, COLOR_WHITE, "====[ Legk�zelebbi object ]=====");
		new Float:PPos[3], Float:legkozelebb = 5000.0, Float:tav;
		GetPlayerPos(playerid, PPos[0], PPos[1], PPos[2]);
		new kozel;
		for(new a = 0; a < MAX_OBJECTSZ; a++)
		{
			tav = GetDistanceBetweenPoints(PPos[0], PPos[1], PPos[2], OBJECT[a][sPosX], OBJECT[a][sPosY], OBJECT[a][sPosZ]);
			if(tav < legkozelebb)
			{
				legkozelebb = tav;
				kozel = a;
			}
		}

		if(legkozelebb == 5000.0) return Msg(playerid, "Nincs tal�lat");

		SendFormatMessage(playerid, COLOR_LIGHTBLUE, "ID: %d Objectid: %d VW: %d INT: %d", kozel,OBJECT[kozel][sTipus],OBJECT[kozel][sVw],OBJECT[kozel][sInt]);
		SetPlayerCheckpoint(playerid, OBJECT[kozel][sPosX], OBJECT[kozel][sPosY], OBJECT[kozel][sPosZ], 2);
		return 1;
	}
	return 1;
}
ALIAS(5r5kkulcs):orokkulcs;
CMD:orokkulcs(playerid, params[])
{
	new pm[32], pid, kid, spm[32], jarmu;
	if(PlayerInfo[playerid][pPcarkey] == NINCS && PlayerInfo[playerid][pPcarkey2] == NINCS && PlayerInfo[playerid][pPcarkey3] == NINCS) return Msg(playerid, "Nincs j�rm�ved.");
	if(sscanf(params, "s[32]S()[32]", pm, spm)) { Msg(playerid, "/�r�kkulcs [ad/elvesz]"); if(Admin(playerid, 1337)) Msg(playerid, "/�r�kkulcs t�r�l"); return true; }
	if(egyezik(pm, "ad"))
	{
		if(sscanf(spm, "ri", pid, kid)) return Msg(playerid, "/�r�kkulcs ad [n�v/id] [1/2/3]");
		if(pid == INVALID_PLAYER_ID || pid == playerid) return Msg(playerid, "Nem l�tez� j�t�kos");
		if(GetDistanceBetweenPlayers(playerid, pid) > 3.0) return Msg(playerid, "Nincs a k�zeledben a j�t�kos.");
		if(kid == 1)
		{
			if(PlayerInfo[playerid][pPcarkey] == NINCS) return true;
			jarmu = PlayerInfo[playerid][pPcarkey];
		}
		elseif(kid == 2)
		{
			if(PlayerInfo[playerid][pPcarkey2] == NINCS) return true;
			jarmu = PlayerInfo[playerid][pPcarkey2];
		}
		elseif(kid == 3)
		{
			if(PlayerInfo[playerid][pPcarkey3] == NINCS) return true;
			jarmu = PlayerInfo[playerid][pPcarkey3];
		}
		else return Msg(playerid, "�gy tudom csak 3 j�rm�ved lehet.. nem? :)");
		
		if(CarInfo[jarmu][cKulcsok][0] != NINCS && CarInfo[jarmu][cKulcsok][1] != NINCS) return Msg(playerid,"Csak k�t p�tkulcs van hozz�, amiket m�r �tadt�l valakinek!");
		if(PlayerInfo[pid][pKulcsok][0] != NINCS && PlayerInfo[pid][pKulcsok][1] != NINCS && PlayerInfo[pid][pKulcsok][2] != NINCS) return Msg(playerid,"N�la m�r t�bb mint 3 kulcs van");
		
		if(PlayerInfo[pid][pKulcsok][0] == NINCS)
			PlayerInfo[pid][pKulcsok][0] = CarInfo[jarmu][cId];
		elseif(PlayerInfo[pid][pKulcsok][1] == NINCS)
			PlayerInfo[pid][pKulcsok][1] = CarInfo[jarmu][cId];
		elseif(PlayerInfo[pid][pKulcsok][2] == NINCS)
			PlayerInfo[pid][pKulcsok][2] = CarInfo[jarmu][cId];
		
		if(CarInfo[jarmu][cKulcsok][0] == NINCS)
			CarInfo[jarmu][cKulcsok][0] = PlayerInfo[pid][pID], CarUpdate(jarmu, CAR_Kulcsok1);
		else
			CarInfo[jarmu][cKulcsok][1] = PlayerInfo[pid][pID], CarUpdate(jarmu, CAR_Kulcsok2);
		
		SendFormatMessage(playerid, COLOR_LIGHTGREEN, "�tadtad a j�rm�ved egyik p�tkulcs�t neki: %s | V-s Rendsz�m: %d | J�rm�ID: %d", ICPlayerName(pid), jarmu, CarInfo[jarmu][cId]);
		SendFormatMessage(pid, COLOR_LIGHTGREEN, "* %s odaadta a j�rm�ve egyik p�tkulcs�t neked | V-s Rendsz�m: %d | J�rm�ID: %d", ICPlayerName(playerid), jarmu, CarInfo[jarmu][cId]);
	}
	elseif(egyezik(pm, "elvesz"))
	{
		if(sscanf(spm, "ri", pid, kid)) return Msg(playerid, "/�r�kkulcs ad [n�v/id] [1/2/3]");
		if(pid == INVALID_PLAYER_ID || pid == playerid) return Msg(playerid, "Nem l�tez� j�t�kos");
		if(GetDistanceBetweenPlayers(playerid, pid) > 3.0) return Msg(playerid, "Nincs a k�zeledben a j�t�kos.");
		if(kid == 1)
		{
			if(PlayerInfo[playerid][pPcarkey] == NINCS) return true;
			jarmu = PlayerInfo[playerid][pPcarkey];
		}
		elseif(kid == 2)
		{
			if(PlayerInfo[playerid][pPcarkey2] == NINCS) return true;
			jarmu = PlayerInfo[playerid][pPcarkey2];
		}
		elseif(kid == 3)
		{
			if(PlayerInfo[playerid][pPcarkey3] == NINCS) return true;
			jarmu = PlayerInfo[playerid][pPcarkey3];
		}
		else return Msg(playerid, "�gy tudom csak 3 j�rm�ved lehet.. nem? :)");
		
		if(CarInfo[jarmu][cKulcsok][0] != PlayerInfo[pid][pID] && CarInfo[jarmu][cKulcsok][1] != PlayerInfo[pid][pID]) return Msg(playerid, "Ehhez a j�rmuh�z neki nincsen p�tkulcsa!");
		if(PlayerInfo[pid][pKulcsok][0] != CarInfo[jarmu][cId] && PlayerInfo[pid][pKulcsok][1] != CarInfo[jarmu][cId] && PlayerInfo[pid][pKulcsok][2] != CarInfo[jarmu][cId]) return Msg(playerid,"Ehhez a j�rmuh�z neki nincsen p�tkulcsa!");
		
		if(PlayerInfo[pid][pKulcsok][0] == CarInfo[jarmu][cId])
			PlayerInfo[pid][pKulcsok][0] = NINCS;
		if(PlayerInfo[pid][pKulcsok][1] == CarInfo[jarmu][cId])
			PlayerInfo[pid][pKulcsok][1] = NINCS;
		if(PlayerInfo[pid][pKulcsok][2] == CarInfo[jarmu][cId])
			PlayerInfo[pid][pKulcsok][2] = NINCS;
		
		if(CarInfo[jarmu][cKulcsok][0] == PlayerInfo[pid][pID])
			CarInfo[jarmu][cKulcsok][0] = NINCS, CarUpdate(jarmu, CAR_Kulcsok1);
		else
			CarInfo[jarmu][cKulcsok][1] = NINCS, CarUpdate(jarmu, CAR_Kulcsok2);
			
		SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Elvetted a j�rmuved p�tkulcs�t t�le: %s | V-s Rendsz�m: %d | J�rmuID: %d", ICPlayerName(pid), jarmu, CarInfo[jarmu][cId]);
		SendFormatMessage(pid, COLOR_LIGHTGREEN, "* %s elvette a j�rmuve p�tkulcs�t t�led | V-s Rendsz�m: %d | J�rmuID: %d", ICPlayerName(playerid), jarmu, CarInfo[jarmu][cId]);
	}
	elseif(egyezik(pm, "t�r�l") || egyezik(pm, "torol"))
	{
		if(!Admin(playerid, 1337) && !IsScripter(playerid)) return 1;
		new type;
		if(sscanf(spm, "ri", pid, type)) return Msg(playerid, "/�r�kkulcs t�r�l [n�v/id] [1/2/3]");
		if(pid == INVALID_PLAYER_ID) return Msg(playerid, "Nem l�tez� j�t�kos");
		switch(type)
		{
			case 1:
			{
				if(CarInfo[PlayerInfo[pid][pKulcsok][0]][cKulcsok][0] == PlayerInfo[pid][pID])
					CarInfo[PlayerInfo[pid][pKulcsok][0]][cKulcsok][0] = NINCS, CarUpdate(PlayerInfo[pid][pKulcsok][0], CAR_Kulcsok1);
				else
					CarInfo[PlayerInfo[pid][pKulcsok][0]][cKulcsok][1] = NINCS, CarUpdate(PlayerInfo[pid][pKulcsok][0], CAR_Kulcsok2);
					
				PlayerInfo[pid][pKulcsok][0] = NINCS;
				
				SendFormatMessage(pid, COLOR_LIGHTRED, "ClassRPG: %s %s elvette az 1. p�tkulcsodat", AdminRangNev(playerid), AdminName(playerid));
				SendFormatMessage(playerid, COLOR_LIGHTRED, "ClassRPG: Elvetted %s 1. p�tkulcs�t", PlayerName(pid));
				format(_tmpString,sizeof(_tmpString),"<< %s %s elvette %s 1. p�tkulcs�t >>", AdminRangNev(playerid), AdminName(playerid), PlayerName(pid));
				SendMessage(SEND_MESSAGE_ADMIN,_tmpString,COLOR_LIGHTRED,PlayerInfo[playerid][pAdmin]);
			}
			case 2:
			{
				if(CarInfo[PlayerInfo[pid][pKulcsok][1]][cKulcsok][0] == PlayerInfo[pid][pID])
					CarInfo[PlayerInfo[pid][pKulcsok][1]][cKulcsok][0] = NINCS, CarUpdate(PlayerInfo[pid][pKulcsok][1], CAR_Kulcsok1);
				else
					CarInfo[PlayerInfo[pid][pKulcsok][1]][cKulcsok][1] = NINCS, CarUpdate(PlayerInfo[pid][pKulcsok][1], CAR_Kulcsok2);
					
				PlayerInfo[pid][pKulcsok][1] = NINCS;
				
				SendFormatMessage(pid, COLOR_LIGHTRED, "ClassRPG: %s %s elvette az 2. p�tkulcsodat", AdminRangNev(playerid), AdminName(playerid));
				SendFormatMessage(playerid, COLOR_LIGHTRED, "ClassRPG: Elvetted %s 2. p�tkulcs�t", PlayerName(pid));
				
				format(_tmpString,sizeof(_tmpString),"<< %s %s elvette %s 2. p�tkulcs�t >>", AdminRangNev(playerid), AdminName(playerid), PlayerName(pid));
				
				SendMessage(SEND_MESSAGE_ADMIN,_tmpString,COLOR_LIGHTRED,PlayerInfo[playerid][pAdmin]);
			}
			case 3:
			{
				if(CarInfo[PlayerInfo[pid][pKulcsok][2]][cKulcsok][0] == PlayerInfo[pid][pID])
					CarInfo[PlayerInfo[pid][pKulcsok][2]][cKulcsok][0] = NINCS, CarUpdate(PlayerInfo[pid][pKulcsok][2], CAR_Kulcsok1);
				else
					CarInfo[PlayerInfo[pid][pKulcsok][2]][cKulcsok][1] = NINCS, CarUpdate(PlayerInfo[pid][pKulcsok][2], CAR_Kulcsok2);
					
				PlayerInfo[pid][pKulcsok][2] = NINCS;
				
				SendFormatMessage(pid, COLOR_LIGHTRED, "ClassRPG: %s %s elvette az 3. p�tkulcsodat", AdminRangNev(playerid), AdminName(playerid));
				SendFormatMessage(playerid, COLOR_LIGHTRED, "ClassRPG: Elvetted %s 3. p�tkulcs�t", PlayerName(pid));
			
				
				format(_tmpString,sizeof(_tmpString),"<< %s %s elvette %s 3. p�tkulcs�t >>", AdminRangNev(playerid), AdminName(playerid), PlayerName(pid));
				SendMessage(SEND_MESSAGE_ADMIN,_tmpString,COLOR_LIGHTRED,PlayerInfo[playerid][pAdmin]);
			}
			default: Msg(playerid, "1/2/3");
		}
	}
	elseif(egyezik(pm, "t�r�lv") || egyezik(pm, "torolv"))
	{
		if(!Admin(playerid, 1337) && !IsScripter(playerid)) return 1;
		new type;
		if(sscanf(spm, "ii", pid, type)) return Msg(playerid, "/�r�kkulcs t�r�lv [j�rm�id] [1/2]");
		if(pid == INVALID_VEHICLE_ID) return Msg(playerid, "Nem l�tez� j�rm�");
		
		jarmu = IsAVsKocsi(pid);
		
		if(jarmu == NINCS) return Msg(playerid, "Ez nem egy V-s kocsi!");
		
		switch(type)
		{
			case 1:
			{
				
				CarInfo[jarmu][cKulcsok][0] = NINCS, CarUpdate(jarmu, CAR_Kulcsok1);
				
				SendFormatMessage(playerid, COLOR_LIGHTRED, "ClassRPG: %d (VSID: %d) j�rm�h�z rendelt kulcsok null�zva", pid, jarmu);
				format(_tmpString,sizeof(_tmpString),"<< %s %d (VSID: %d) j�rm�h�z rendelt kulcsok null�zva >>", AdminName(playerid), pid, jarmu);
				SendMessage(SEND_MESSAGE_ADMIN,_tmpString,COLOR_LIGHTRED,PlayerInfo[playerid][pAdmin]);
			}
			case 2:
			{
				CarInfo[jarmu][cKulcsok][0] = NINCS, CarUpdate(jarmu, CAR_Kulcsok2);
				
				SendFormatMessage(playerid, COLOR_LIGHTRED, "ClassRPG: %d (VSID: %d) j�rm�h�z rendelt kulcsok null�zva", pid, jarmu);
				format(_tmpString,sizeof(_tmpString),"<< %s %d (VSID: %d) j�rm�h�z rendelt kulcsok null�zva >>", AdminName(playerid), pid, jarmu);
				SendMessage(SEND_MESSAGE_ADMIN,_tmpString,COLOR_LIGHTRED,PlayerInfo[playerid][pAdmin]);
			}
			default: Msg(playerid, "1/2");
		}
	}
	return 1;
}

ALIAS(vad1szenged2ly):vadaszengedely;
CMD:vadaszengedely(playerid, params[])
{
	new a[64], b[64];
	if(sscanf(params, "s[32]S()[32]", a, b)) return Msg(playerid, "/vad�szenged�ly [kiv�lt/megn�z]");
	if(egyezik(a, "kiv�lt") || egyezik(a, "kivalt"))
	{
		if(!PlayerToPoint(2, playerid, 362.3623,209.2845,1008.3828)) return Msg(playerid, "V�rosh�z�n els� iroda jobbra! 300,000Ft; 24 h�napig �rv�nyes ((�ra))");
		if(PlayerInfo[playerid][pVadaszEngedely] > 0) return Msg(playerid,"Neked van enged�lyed!");
		if(!BankkartyaFizet(playerid, 300000)){ Msg(playerid, "A vad�szenged�ly �ra: 300,000Ft"); return 1; }
		PlayerInfo[playerid][pVadaszEngedely] = 24;
		Cselekves(playerid, "kiv�ltott egy vad�szenged�lyt.");
		Msg(playerid, "Kiv�ltottad az enged�lyt, mostm�r mehetsz vad�szni!");
	}
	elseif(egyezik(a, "megn�z") || egyezik(a, "megnez"))
	{
		if(PlayerInfo[playerid][pVadaszEngedely] < 1) return Msg(playerid, "Nincs enged�lyed!");

		SendClientMessage(playerid, COLOR_GREEN, "====== Vad�szlicenc ======");
		SendFormatMessage(playerid, COLOR_GRAD6, "N�v: %s", ICPlayerName(playerid));
		SendFormatMessage(playerid, COLOR_GRAD5, "�rv�nyes: %d h�napig ((�r�ig))", PlayerInfo[playerid][pVadaszEngedely]);
		Cselekves(playerid, "el�vette az egyik irat�t, �s megn�zte.", 0);
	}
	return 1;
}


ALIAS(vad1sz):vadasz;
CMD:vadasz(playerid, params[])
{
	new a[64];
	if(!AMT(playerid, MUNKA_VADASZ)) return Msg(playerid, "Nem vagy vad�sz!");
	if(OnDuty[playerid]) return Msg(playerid, "D�ntsd elobb el mit dolgozol! ((frakci� dutyba nem!))");
	if(sscanf(params, "s[32]", a)) return Msg(playerid, "/vad�sz [munka/seg�ts�g]");
	if(egyezik(a, "munka"))
	{
		if(!IsPlayerInAnyVehicle(playerid))
		{
			if(!PlayerToPoint(5.0, playerid, -1633.1276, -2238.6843, 31.4766))
			{
				SetPlayerCheckpoint(playerid, -1633.1276, -2238.6843, 31.4766, 5.0);
				Msg(playerid, "Nem vagy a vad�sztelepen!");
				return 1;
			}
			if(Munkaban[playerid] != MUNKA_VADASZ)
			{
				if(PlayerInfo[playerid][pVadaszEngedely] == 0) return Msg(playerid, "Nincs vad�szenged�lyed!");
				if(PlayerInfo[playerid][pPayCheck] > 1700000) return Msg(playerid, "T�l sok vadat l�tt�l m�r ki, nem adhatsz le t�bbet!");
				
				Munkaban[playerid] = MUNKA_VADASZ;
				if(PlayerInfo[playerid][pSex] == 2) SetPlayerSkin(playerid, 201);
				else SetPlayerSkin(playerid, 161);
				Msg(playerid, "Felvetted a ruh�dat, �gy munk�ba �llt�l. A munka v�gz�s�hez seg�ts�g: /vad�sz seg�ts�g");
				if(HuntInfo[dAmount] < MAX_DEER && HuntInfo[dLastJoiner] != PlayerInfo[playerid][pID])
					CreateDeer();
				HuntInfo[dLastJoiner] = PlayerInfo[playerid][pID];
			}
			else
			{
				if(LegalisSzervezetTagja(playerid) || Civil(playerid))
				{
					SetPlayerSkin(playerid, PlayerInfo[playerid][pModel]);
				}
				else
				{
					SetPlayerSkin(playerid, PlayerInfo[playerid][pChar]);
				}
				Munkaban[playerid] = NINCS;
				Msg(playerid, "Visszavetted a civil ruh�dat, �gy m�r nem dolgozol.");
			}
		}
		else Msg(playerid, "J�rm�ben NEM!");
		return 1;
	}
	elseif(egyezik(a, "segitseg") || egyezik(a, "seg�ts�g"))
	{
		SendClientMessage(playerid, COLOR_GREEN, "=====[ Vad�szat munka haszn�lati �tmutat� ]=====");
		SendClientMessage(playerid, COLOR_WHITE, "A munk�t elkezdeni a /vad�sz munka paranccsal tudod.");
		SendClientMessage(playerid, COLOR_WHITE, "A munk�hoz fegyvert neked kell v�s�rolnod, ami rifle vagy shotgun lehet.");
		SendClientMessage(playerid, COLOR_GRAD6, "A munk�hoz vad�szenged�ly sz�ks�ges, amit az Oktat�kt�l tudsz kiv�ltani 48 j�tszott �r�ra 150.000 Ft-�rt, vagy 300.000 Ft-�rt 24 j�tszott �r�ra a v�rosh�z�n.");
		SendClientMessage(playerid, COLOR_GRAD6, "Egyszerre 25db �z tal�lhat� az erd�ben.");
		SendClientMessage(playerid, COLOR_GRAD5, "�j �z akkor ker�l el�, ha egy �j vad�sz �ll munk�ba; automatikusan 10 percenk�nt spawnol egy �z.");
		SendClientMessage(playerid, COLOR_GRAD5, "Miut�n elejtett�k az �zt, 5 perc �ll rendelkez�sre, hogy a tal�lt goly�t elt�vol�tsuk bel�le. (Y gomb)");
		SendClientMessage(playerid, COLOR_GRAD4, "Miut�n elt�vol�tottuk a l�ved�ket, az �llatot lehet�s�g�nk van felpakolni egy Yosemite-ra (Y gomb), amire egyszerre 5 �llat f�r.");
		SendClientMessage(playerid, COLOR_GRAD4, "Az �llat elsz�ll�t�s�ra korl�tlan id� �ll rendelkez�sre, de tov�bbra is csak maximum 25 �z lesz megtal�lhat�.");
		SendClientMessage(playerid, COLOR_GRAD3, "Az �llatokat ezut�n egy megadott GPS pontra kell elvinni, ahol az erd�szeten �tveszik az �llatokat. (Y gomb)");
		SendClientMessage(playerid, COLOR_GRAD3, "A fizet�s az �llat s�r�l�si �llapot�t�l, �s a fegyver l�ved�k�nek fajt�j�t�l f�gg, �s a l�v�s t�vols�g�t�l.");
		SendClientMessage(playerid, COLOR_GRAD2, "Vigy�zz! Ha t�l k�zel m�sz egy �llathoz, akkor az elszalad!");
		SendClientMessage(playerid, COLOR_GRAD2, "Vigy�zz! Az elejtett �zeket b�rki el tudja sz�ll�tani saj�t profitj�ra!");
		SendClientMessage(playerid, COLOR_GRAD2, "Figyelem! Ha 'N' gombot megnyomod kocsiban akkor megmutatja hova kell vinni az �zeket!");
	}
	elseif(egyezik(a, "go"))
	{
		if(!IsScripter(playerid)) return 1;
		new kac_kac_kukac = GetClosestDeer(playerid);
		SetPlayerCheckpoint(playerid, ArrExt(DeerInfo[kac_kac_kukac][dPos]), 2.0);
		SendFormatMessage(playerid, -1, "Megjel�lve a(z) #%d sz�m� �zh�z (te lusta diszn�! :P)", kac_kac_kukac);
	}
	elseif(egyezik(a, "create"))
	{
		if(!IsScripter(playerid)) return 1;
		CreateDeer();
		SendClientMessage(playerid, -1, "K�sz");
	}
	return 1;
}

CMD:ondutyskin(playerid, params[])
{
	if(!Admin(playerid, 1)) return 1;
	if(!AdminDuty[playerid]) return Msg(playerid, "Nem vagy ondutyban!");
	if(!AdminDutySkin[playerid])
	{
		AdminDutySkin[playerid] = 1;
		SetPlayerSkin(playerid, PlayerInfo[playerid][pModel]);
		Msg(playerid, "Frakci�n k�v�li karakterskin be�ll�tva - bekapcsolva");
	}
	else
	{
		AdminDutySkin[playerid] = 0;
		if(PlayerInfo[playerid][pChar] > 0 && OnDuty[playerid] || PlayerInfo[playerid][pChar] > 0 && !LegalisSzervezetTagja(playerid) && !Civil(playerid))
			SetPlayerSkin(playerid, PlayerInfo[playerid][pChar]);
		else
			SetPlayerSkin(playerid, PlayerInfo[playerid][pModel]);
		Msg(playerid, "Frakci�s karakterskin be�ll�tva - kikapcsolva");
	}
	return 1;
}

ALIAS(korm1ny):kormany;
CMD:kormany(playerid, params[])
{
	new func[10];
	new func2[60];

	if(sscanf(params, "s[12]S()[60]", func,func2)) return Msg(playerid,"/korm�ny [stat / frakci�ad� / akit�ntet�s / rendezv�ny / settax / givetax / ad�k]");

	if(!LMT(playerid, FRAKCIO_ONKORMANYZAT) && !Admin(playerid, 1337)) return SendClientMessage(playerid, COLOR_GREY, "Nem vagy (Al)Eln�k!");
			
			
	if(egyezik(func,"ad�k"))
	{
		if(!Munkarang(playerid,8)) return Msg(playerid, "A-A");
		
		
		new message[128];
		new osszeg;
		SendClientMessage(playerid,COLOR_RED,"<< ========== (Be nem fizetett ad�k) ========== >>");
		
		foreach(Jatekosok, s)
		{
				
			if(!IsPlayerConnected(s) || IsPlayerNPC(s) || PlayerInfo[s][pAdokIdo] > 1) continue;
			
			osszeg = PlayerInfo[s][pAdokOsszeg];
			format(message, sizeof(message), "%s befizet�si hat�rid�: %d fizet�s �sszeg: %sFt", ICPlayerName(s), PlayerInfo[s][pAdokIdo], FormatNumber(osszeg, 0, ',' ));
			SendFormatMessage(playerid,COLOR_RED,"%s", message);
		}
		SendClientMessage(playerid,COLOR_RED,"<<========== (Be nem fizetett ad�k) ========== >>");	
		
		
		return 1;
	}
	if(egyezik(func,"stat"))
	{
		if(!Munkarang(playerid,10)) return Msg(playerid, "A-A");
		//FrakcioAdoStat();
		
		SendClientMessage(playerid,COLOR_WHITE,"============= Frakci� ad� bev�telek =================");
		new heti,havi,ossz;
		for(new yx; yx < MAX_ADO_FRAKCIO; yx++)
		{
			new id=AdozoFrakciok[yx];
			SendFormatMessage(playerid, COLOR_YELLOW, "[%d]%s Heti: %s Ft, Havi %s Ft, �sszes: %s Ft",id,Szervezetneve[id-1][0], FormatInt(FrakcioInfo[id][fHeti]),FormatInt(FrakcioInfo[id][fHavi]),FormatInt(FrakcioInfo[id][fOsszes]));
			heti +=FrakcioInfo[id][fHeti];
			havi +=FrakcioInfo[id][fHavi];
			ossz +=FrakcioInfo[id][fOsszes];
		}
		SendFormatMessage(playerid, COLOR_YELLOW, "�sszesen: Heti %s Ft, Havi %s Ft, �sszesen: %s Ft",FormatInt(heti),FormatInt(havi),FormatInt(ossz));
		SendClientMessage(playerid,COLOR_WHITE,"Heti: Vas�rnap 23:44 - 59-k�z�tt, Havi: Minden h� utols� nap 23:44 -59 -k�z�tt => null�z�dik");
	}
	if(egyezik(func,"givetax"))
    {
		new string[128];
		if(PlayerInfo[playerid][pLeader] != FRAKCIO_ONKORMANYZAT) return SendClientMessage(playerid, COLOR_GREY, "Nem vagy az Eln�k!");

		if(FrakcioInfo[FRAKCIO_ONKORMANYZAT][fPenz] < 1) return SendClientMessage(playerid, COLOR_GREY, "A kassz�ban nincs p�nz!");

		new penz,frakcio;
		if(sscanf(func2, "dd", frakcio,penz))
		{
		
			SendClientMessage(playerid, COLOR_GREY, "Haszn�lata: /korm�ny givetax [frakci�ID] [p�nz]");
			for(new yx; yx < MAX_ADO_FRAKCIO; yx++)
			{
				new id=AdozoFrakciok[yx];
				
				SendFormatMessage(playerid,COLOR_GREY,"[%d]%s,",id,Szervezetneve[id-1][0]);
			
			}	
			new civil,swatos,kisebsegi;
			
			foreach(Jatekosok, i)
			{
				if(!PlayerInfo[i][pMember] && !PlayerInfo[i][pLeader])
					civil += 1;
					
				if(LMT(i, FRAKCIO_SONSOFANARCHY) || LMT(i, FRAKCIO_COSANOSTRA) || LMT(i, FRAKCIO_YAKUZA) || LMT(i, FRAKCIO_VAGOS) || LMT(i, FRAKCIO_AZTEC) || LMT(i, FRAKCIO_GSF))
					kisebsegi += 1;
				
				if(PlayerInfo[i][pSwattag] == 1)
					swatos += 1;
				
				
			}
			
			
			SendFormatMessage(playerid, COLOR_GREY, "Speci�lis: 30: Civil[%d F�], 31: SWAT[%d F�], 32: Kisebbs�g[%d F�]",civil,swatos,kisebsegi);
			SendFormatMessage(playerid, COLOR_GREY, "Kassza: %s Ft", FormatNumber( FrakcioInfo[FRAKCIO_ONKORMANYZAT][fPenz] , 0, ',' ));
			return 1;
		}
	
		if(penz > FrakcioInfo[FRAKCIO_ONKORMANYZAT][fPenz])
		{
			SendFormatMessage(playerid, COLOR_GREY, "A kassz�ban nincs % sFt, csak %s Ft!", FormatNumber( penz , 0, ',' ), FormatNumber( FrakcioInfo[FRAKCIO_ONKORMANYZAT][fPenz], 0, ',' ));
			return 1;
		}
		new adozo = false;
		for(new yx; yx < MAX_ADO_FRAKCIO; yx++)
		{
			new id=AdozoFrakciok[yx];
			if(id == frakcio)
				adozo = true;
		}
		if(adozo)
		{
			
			foreach(Jatekosok, i)
			{
				if(LMT(i, frakcio))
				{
					format(string, sizeof(string), "* A nagylelk� (al)eln�k �tutalta az ad�k egy r�sz�t a %s sz�m�ra! %s Ft ker�lt a sz�fbe!", Szervezetneve[frakcio-1][0],FormatInt(penz));
					SendClientMessage(i, COLOR_LIGHTBLUE, string);
				}
			}

			FrakcioInfo[frakcio][fPenz] += penz;
			
			FrakcioInfo[FRAKCIO_ONKORMANYZAT][fPenz] -= penz;
			SendFormatMessage(playerid, COLOR_GREY, " �tutalt�l %s Ft-ot a %s sz�m�ra.", FormatInt(penz),Szervezetneve[frakcio-1][0]);
			SendClientMessageToAll(COLOR_GOV1, "|___________ Class City Korm�ny felh�v�sa ___________|");
			SendFormatMessageToAll(COLOR_GOV2,"%s: A korm�ny t�mogata a(z) %s szervezetet %s Ft-al!", ICPlayerName(playerid),Szervezetneve[frakcio-1][0],FormatInt(penz));

		}
		else if(frakcio == 32)
		{
			new Tagok = 0;
			foreach(Jatekosok, i)
			{
				if(LMT(i, FRAKCIO_SONSOFANARCHY) || LMT(i, FRAKCIO_COSANOSTRA) || LMT(i, FRAKCIO_YAKUZA) || LMT(i, FRAKCIO_VAGOS) || LMT(i, FRAKCIO_AZTEC) || LMT(i, FRAKCIO_GSF))
					Tagok += 1;
			}

			
			if(Tagok >= 1)
			{
				if(penz*Tagok > FrakcioInfo[FRAKCIO_ONKORMANYZAT][fPenz]) return SendFormatMessage(playerid, COLOR_YELLOW,"Nincs el�g p�nz a kaszz�ban: %s FT",FormatNumber(FrakcioInfo[FRAKCIO_ONKORMANYZAT][fPenz]));

				foreach(Jatekosok, i)
				{
					if(IsPlayerConnected(i))
					{

						if(LMT(i, FRAKCIO_SONSOFANARCHY) || LMT(i, FRAKCIO_COSANOSTRA) || LMT(i, FRAKCIO_YAKUZA) || LMT(i, FRAKCIO_VAGOS) || LMT(i, FRAKCIO_AZTEC) || LMT(i, FRAKCIO_GSF))
						{
							format(string, sizeof(string), "* A nagylelk� (al)eln�k seg�lyt k�ld�tt a kisebbs�g sz�m�ra. A r�szed: %s Ft",FormatInt(penz));
							SendClientMessage(i, COLOR_LIGHTBLUE, string);
							GiveMoney(i, penz);
							FrakcioInfo[FRAKCIO_ONKORMANYZAT][fPenz] -= penz;
						}
					}
				}
				SendClientMessageToAll(COLOR_GOV1, "|___________ Class City Korm�ny felh�v�sa ___________|");
				SendFormatMessageToAll(COLOR_GOV2,"%s: A korm�ny t�mogatott %d f� kisebbs�gi-t, fejenk�nt %s Ft-al!", ICPlayerName(playerid),Tagok,FormatInt(penz));
			}
			else
			{
				SendClientMessage(playerid, COLOR_GREY, "Nincs fennt Band�s/Mafi�s!");
				return 1;
			}
		}
		else if(frakcio == 31)
		{
			new Tagok = 0;
			foreach(Jatekosok, i)
			{
				
				if(PlayerInfo[i][pSwattag] == 1)
				{
					Tagok += 1;
				}
				
			}

			if(Tagok >= 1)
			{
				if(penz*Tagok > FrakcioInfo[FRAKCIO_ONKORMANYZAT][fPenz]) return SendFormatMessage(playerid, COLOR_YELLOW,"Nincs el�g p�nz a kaszz�ban: %s FT",FormatNumber(FrakcioInfo[FRAKCIO_ONKORMANYZAT][fPenz]));
				foreach(Jatekosok, i)
				{
					
					if(PlayerInfo[i][pSwattag] == 1)
					{
						format(string, sizeof(string), "* A nagylelk� (al)eln�k �tutalta az ad�k egy r�sz�t a SWAT sz�m�ra. A r�szed: %s Ft",FormatInt(penz));
						SendClientMessage(i, COLOR_LIGHTBLUE, string);
						GiveMoney(i, penz);
						FrakcioInfo[FRAKCIO_ONKORMANYZAT][fPenz] -= penz;
					}
					
				}
			
				SendClientMessageToAll(COLOR_GOV1, "|___________ Class City Korm�ny felh�v�sa ___________|");
				SendFormatMessageToAll(COLOR_GOV2,"%s: A korm�ny t�mogatott %d f� SWAT-ost, fejenk�nt %s Ft-al!", ICPlayerName(playerid),Tagok,FormatInt(penz));

			}
			else
			{
				SendClientMessage(playerid, COLOR_GREY, "Nincs fennt SWAT-os!");
				return 1;
			}
		}
		else if(frakcio == 30)
		{
			new Tagok;
			foreach(Jatekosok, i)
			{
				if(!PlayerInfo[i][pMember] && !PlayerInfo[i][pLeader])
					Tagok += 1;
			}

			if(Tagok >= 1)
			{
				if(penz*Tagok > FrakcioInfo[FRAKCIO_ONKORMANYZAT][fPenz]) return SendFormatMessage(playerid, COLOR_YELLOW,"Nincs el�g p�nz a kaszz�ban: %s FT",FormatNumber(FrakcioInfo[FRAKCIO_ONKORMANYZAT][fPenz]));
				
				foreach(Jatekosok, i)
				{
					if(!PlayerInfo[i][pMember] && !PlayerInfo[i][pLeader])
					{
						format(string, sizeof(string), "* A nagylelk� (al)eln�k �tutalta az ad�k egy r�sz�t a civilek sz�m�ra. A r�szed: %s Ft",FormatInt(penz));
						SendClientMessage(i, COLOR_LIGHTBLUE, string);
						GiveMoney(i, penz);
						FrakcioInfo[FRAKCIO_ONKORMANYZAT][fPenz] -= penz;
					}
				}
				SendClientMessageToAll(COLOR_GOV1, "|___________ Class City Korm�ny felh�v�sa ___________|");
				SendFormatMessageToAll(COLOR_GOV2,"%s: A korm�ny t�mogatott %d f� civilt, fejenk�nt %s Ft-al!", ICPlayerName(playerid),Tagok,FormatInt(penz));
			}
			else
			{
				SendClientMessage(playerid, COLOR_GREY, "Nincs fennt civil!");
				return 1;
			}
		}
		else Msg(playerid,"Hib�s ID!");
		
		return 1;
	}
	if(egyezik(func, "settax"))
    {
		if(!Admin(playerid, 5555)) return Msg(playerid,"S�lyos vissza  �l�sek miatt tiltva");
		if(!LMT(playerid, FRAKCIO_ONKORMANYZAT))
			return SendClientMessage(playerid, COLOR_GREY, "Nem vagy (Al)Eln�k!");

		//if(!Munkarang(playerid, 5))
		//	return SendClientMessage(playerid, COLOR_GREY, "Minimum Aleln�ki rang sz�ks�ges!");

		new ado;
		if(sscanf(func2, "d", ado))
			return SendFormatMessage(playerid, COLOR_LIGHTRED, "Haszn�lat: /korm�ny settax [ad� (50 = norm�l, 100 = k�tszeres, stb...] - Jelenlegi ad�: %d", TaxValue), 1;

		//if(ado < 0 || ado > 100)
		//	return Msg(playerid, "Min. 0, max 100 - A norm�l ad� az 50, a 100 az ad� k�tszerese, 0 eset�n nincs ad�");

		if(ado < ADO_MIN || ado > ADO_MAX)
		{
			SendFormatMessage(playerid, COLOR_LIGHTRED, "%s: Minimum %d, maximum %d - A norm�l ad� 50, a k�tszerese 100, m�sf�lszerese 75, stb.", SERVER_NEV, ADO_MIN, ADO_MAX);
			return 1;
		}

		if(ado >= 100 && !IsJim(playerid))
			return Msg(playerid, "Csak 75ig �ll�thatod - ha enn�l nagyobbra szeretn�d, sz�lj Clintnek");

		SendFormatMessage(playerid, COLOR_LIGHTBLUE, "* Az �j ad� mostm�r %d! (A r�gi %d volt)", ado, TaxValue);
		TaxValue = ado;
	    return 1;
	}
	if(egyezik(func, "rendezv�ny"))
	{
		if(FloodCheck(playerid)) return 1;
		new result[128];
		new string[128];
		if(sscanf(func2, "s[128]", result))
			return SendClientMessage(playerid, COLOR_WHITE, "Haszn�lat: /korm�ny rendezv�ny [Sz�veg]");

		if(HirdetesSzidasEllenorzes(playerid, result, "/rendezv�ny", ELLENORZES_MINDKETTO)) return 1;

		if(LMT(playerid, FRAKCIO_ONKORMANYZAT) || IsAdmin(playerid))
		{
			format(string, sizeof(string), "[%d] **Rendezv�ny** %s", playerid, result);
			SendMessage(SEND_MESSAGE_OOCOFF, string, COLOR_RENDEZVENY);
			printf("%s\n", string);
		}
		
		return 1;
	}
	if(egyezik(func, "akituntetes") || egyezik(func, "akit�ntet�s"))
	{
	    new player;
		new szam;
		new string[128];
		if(sscanf(func2, "rd", player, szam))
		{
			Msg(playerid,"Haszn�lata: /korm�ny akit�ntet�s [N�v / ID] [1-6]");
			SendFormatMessage(playerid,COLOR_RED,"Kit�ntet�sek: 1. %s | 2. %s | 3. %s ",KormanyKituntetes[1],KormanyKituntetes[2],KormanyKituntetes[3]);
			SendFormatMessage(playerid,COLOR_RED,"Kit�ntet�sek: 4. %s | 5. %s | 6. %s",KormanyKituntetes[4],KormanyKituntetes[5],KormanyKituntetes[6]);
			return 1;
		}	
		
		if(player == INVALID_PLAYER_ID) return Msg(playerid, "Nincs ilyen j�t�kos.");
		if(player == playerid) return Msg(playerid, "Nana..");
		if(GetDistanceBetweenPlayers(playerid,player) > 3) return Msg(playerid, "� nincs a k�zeledben!");
		
		if(!LMT(player, FRAKCIO_ONKORMANYZAT)) return Msg(playerid, "� nem tag!");
		if(szam > 6 || szam < 1) return Msg(playerid,"A kit�ntet�s sz�ma 1 �s 6 k�z�tt lehet!");
		SendFormatMessage(player, COLOR_LIGHTBLUE, "Kit�net�st kapt�l t�le: %s", ICPlayerName(playerid));
		SendFormatMessage(player, COLOR_LIGHTBLUE, "Kit�ntet�sed: %s", KormanyKituntetes[szam]);
		format(string, sizeof(string), "R�di�: %s kit�ntette %s -t | Kit�ntet�se: %s **", ICPlayerName(playerid), ICPlayerName(player), KormanyKituntetes[szam]);
		SendMessage(SEND_MESSAGE_RADIO, string, COLOR_RED, FRAKCIO_ONKORMANYZAT);
		PlayerInfo[player][pKormanyKituntetes] = szam;
		
		return 1;
	}
	if(egyezik(func,"frakci�ad�") || egyezik(func,"frakcioado"))
	{
		if(!Munkarang(playerid, 5))
			return SendClientMessage(playerid, COLOR_GREY, "Minimum Aleln�ki rang sz�ks�ges!");
			
		new ado;
		new szam;
		if(sscanf(func2, "dd", szam, ado))
		{
			Msg(playerid, "Haszn�lat: /frakci�ad� [frakci� sz�ma] [szorz�]");
			
			SendClientMessage(playerid, COLOR_LIGHTRED,"=================Frakci�k ad�i=================");
			for(new yx; yx < MAX_ADO_FRAKCIO; yx++)
			{
				new id=AdozoFrakciok[yx];
				new string[128];
				format(string,sizeof(string),"[%d] %s || Jelenlegi ad�ja: %d %% || Sz�f: %s Ft",id,Szervezetneve[id-1][0], FrakcioInfo[id][fAdo],FormatInt(FrakcioInfo[id][fPenz]));
				SendFormatMessage(playerid, COLOR_LIGHTRED, "%s", string);
			
			}	
			SendClientMessage(playerid, COLOR_LIGHTRED,"=================Frakci�k ad�i=================");
			return 1;
		}

		new bool:ellen;
		for(new x; x < MAX_ADO_FRAKCIO; x++)
		{	
			if(AdozoFrakciok[x] == szam) 
				ellen=true;
		}
		if(!ellen) return Msg(playerid, "Ez a frakci� nem ad�zik!");
		
		if(ado < 0 || ado > 30)
		{
			Msg(playerid,"Az ad�nak 0-30 % k�z�tt kell lenni-e!");
			return 1;
		}
		
			
		SendFormatMessage(playerid, COLOR_LIGHTBLUE, "A(z) %s ad�ja: %d ", Szervezetneve[szam-1][0], ado);
		FrakcioInfo[szam][fAdo] = ado;
		return 1;
	}

	return 1;
}
ALIAS(pil4taradar):pilotaradar;
CMD:pilotaradar(playerid, params[])
{
	new veh = GetPlayerVehicleID(playerid), pilotak = 0;
	if(!AMT(playerid, MUNKA_PILOTA)) return Msg(playerid, "Nem vagy pil�ta!");
	if(!IsAPRepulo(veh)) return Msg(playerid, "Nem utassz�ll�t� g�pben �lsz!");
	if(Repul[playerid] == 0) return Msg(playerid, "Nincs leszerz�dtetett sz�ll�t�sod, �gy nem k�rheted le a t�bbi pil�ta helyzet�t!");
	if(!PilotaRadar[playerid])
	{
		foreach(Jatekosok, p)
		{
			new allveh = GetPlayerVehicleID(p);
			if(AMT(p, MUNKA_PILOTA) && IsAPRepulo(allveh) && Repul[p] == 1)
				SetPlayerMarkerForPlayer(playerid, p, 0xFFFFFF44), pilotak++;
		}
		PilotaRadar[playerid] = 1;
		SendFormatMessage(playerid, COLOR_GREEN, "Pil�taradar bekapcsolva, �sszesen %d pil�ta van a l�gt�rben!", pilotak);
	}
	else
	{
		foreach(Jatekosok, p)
		{
			new allveh = GetPlayerVehicleID(p);
			if(AMT(p, MUNKA_PILOTA) && IsAPRepulo(allveh) && Repul[p] == 1)
				SetPlayerMarkerForPlayer(playerid, p, COLOR_INVISIBLE);
		}
		PilotaRadar[playerid] = 0;
		SendClientMessage(playerid, COLOR_GREEN, "Pil�taradar kikapcsolva");
	}
	return 1;
}

CMD:roncsderbi(playerid, params[])
{
	if(RoncsDerbi[rInditva]) return Msg(playerid, "Jelenleg foglalt a p�lya!");
	
	if(!PlayerToPoint(5,playerid,-2110.9934,-444.3106,38.7344,0,0)) return Msg(playerid, "Nem vagy San Fiero stadion bej�rat�n�l! ((az i betun�l))");
	
	if(RoncsDerbi[rIndit]) return Msg(playerid, "V�rj egy kicsit m�g, most ind�t valaki!");
	
	if(!RoncsDerbi[rFutam])
	{
		if(!BankkartyaFizet(playerid,DERBI_ARA,false)) return SendFormatMessage(playerid, COLOR_YELLOW,"A verseny �ra %s Ft!",FormatInt(DERBI_ARA));
		RoncsDerbi[rIndit] = true;
		ShowPlayerDialog(playerid, DIALOG_DERBI_KOCSIVALASZT, DIALOG_STYLE_LIST, "Roncsderbi, szabad a kocsi v�laszt�s?!", "IGEN - a csatlakoz� j�t�kos adja meg milyen kocsival lesz.\nNEM - Te adod meg milyen kocsival legyenek a j�t�kosok.", "Tov�bb","M�gse");
	}
	else
	{
		if(RoncsDerbi[rJatekos] >= 20) return Msg(playerid, "A versenyen maximum 20-an lehetnek, betelt a p�lya!");
		if(RoncsDerbi[rModel] == NINCS)
		{
			if(!BankkartyaFizet(playerid,DERBI_ARA,false)) return SendFormatMessage(playerid, COLOR_YELLOW,"A verseny �ra %s Ft!",FormatInt(DERBI_ARA));
			ShowPlayerDialog(playerid, DIALOG_DERBI_KOCSIMODEL, DIALOG_STYLE_INPUT, "Roncsderbi", "Milyen j�rm�vel akarsz indulni? ((model ID vagy N�V))", "Tov�bb", "M�gse");

		}
		else
		{
			if(!BankkartyaFizet(playerid,DERBI_ARA,false)) return SendFormatMessage(playerid, COLOR_YELLOW,"A verseny �ra %s Ft!",FormatInt(DERBI_ARA));
			
			new string[256];
			format(string,sizeof(string),"RoncsDerbi futam inform�ci�k / szab�lyok\nMindenki azonos t�pus� kocsival indul\nKocsib�l kisz�lni tilos!\nSzerencs�s futamot!");
			ShowPlayerDialog(playerid, DIALOG_DERBI_BELEPES, DIALOG_STYLE_MSGBOX, "DERBI INF�", string, "Kezd�s", "");
			
		
		}
	}

	return 1;
}


ALIAS(mulat1s):mulatas;
CMD:mulatas(playerid, params[])
{
	if(SQLID(playerid) == 1 || SQLID(playerid) == 5637 || SQLID(playerid) == 8172424 || IsTerno(playerid) || IsAmos(playerid) || IsJim(playerid))
	{
		if(MulatasTime > UnixTime) return SendFormatMessage(playerid, COLOR_LIGHTRED, "ClassRPG: Pihenj kicsit, m�g nem mulathatsz! Legk�zelebb %d m�sodperc m�lva kezdhetsz el mulatozni", MulatasTime-UnixTime);
		MulatasTime = UnixTime+3600;
		ABroadCastFormat(Pink, 1, "<< %s mulat�s cs�sz�r jelen van - mulat�s elkezdve! >>", AdminName(playerid));
		foreach(Jatekosok, p)
		{
			if(Admin(p, 1) && PlayerInfo[p][pRadio] == 1 && Logged(p) && Zsebradio[p] == 0 && RiobanVan{p} == 0 && MoriartybanVan{p} == 0)
				PlayAudioStreamForPlayer(p, "https://dl.dropboxusercontent.com/u/125530140/Cs%C3%B3r%C3%B3%20Lali%20-%20Lali%20pop.mp3");
		}
	}
	return 1;
}

ALIAS(tilt1sok):tiltasok;
CMD:tiltasok(playerid, params[])
{
	new who; new count = 0;
	if(!Admin(playerid, 5)) return 1;
	if(sscanf(params, "u", who)) return Msg(playerid, "/tilt�sok [N�v/ID]");
	SendFormatMessage(playerid, COLOR_ADD, "==========[ %s tilt�sai ]==========", PlayerName(who));
	if(PlayerInfo[who][pFrakcioTiltIdo] >0) SendFormatMessage(playerid,COLOR_YELLOW,"El van tiltva a frakci�kt�l %d �r�ra! Oka: %s",PlayerInfo[who][pFrakcioTiltIdo],PlayerInfo[who][pFrakcioTiltOk]), count++;
	if(PlayerInfo[who][pJogsiTiltIdo] >0 && !egyezik(PlayerInfo[who][pJogsiTiltOk],"NINCS")) SendFormatMessage(playerid,COLOR_YELLOW,"El van tiltva a vizsg�ztat�st�l %d �r�ra! Oka: %s",PlayerInfo[who][pJogsiTiltIdo],PlayerInfo[who][pJogsiTiltOk]), count++;
	if(PlayerInfo[who][pFegyverTiltIdo] >0) SendFormatMessage(playerid,COLOR_YELLOW,"El van tiltva a fegyver haszn�latt�l %d �r�ra! Oka: %s",PlayerInfo[who][pFegyverTiltIdo],PlayerInfo[who][pFegyverTiltOk]), count++;
	if(PlayerInfo[who][pAsTilt] == 1) SendFormatMessage(playerid, COLOR_YELLOW, "El van tiltva az adminseg�dt�l! Oka: %s", PlayerInfo[who][pAsTiltOk]), count++;
	if(PlayerInfo[who][pLeaderTilt] == 1) SendFormatMessage(playerid, COLOR_YELLOW, "El van tiltva a leaders�gt�l! Oka: %s", PlayerInfo[who][pLeaderoka]), count++;
	if(PlayerInfo[who][pReportTilt] == 1) SendFormatMessage(playerid, COLOR_YELLOW, "El van tiltva a reportol�st�l! Oka: %s", PlayerInfo[who][pReportTiltOk]), count++;
	if(count == 0) SendFormatMessage(playerid, COLOR_WHITE, "%s-nak/nek nincs egyetlen tilt�sa sem.", PlayerName(who));
	else SendFormatMessage(playerid, COLOR_ADD, "==========[ %s tilt�sai ]==========", PlayerName(who));
	return 1;
}

ALIAS(pb):paintball; 
CMD:paintball(playerid, params[])
{
	new bool:viszbe=false;
	foreach(Jatekosok, id)
	{
		if(Visz[id] == playerid)
			viszbe = true;
	
	}
	
	if(PlayerCuffed[playerid] == 2 || viszbe)
		return SeeBan(playerid, 0, NINCS, "Cufolva vagy viszbe Paintbalba men�s!" );
	new pm[32], subpm[32], teremid, jatekido, ido;
	if(!PlayerToPoint(15, playerid, BizzInfo[BIZ_PB][bEntranceX], BizzInfo[BIZ_PB][bEntranceY], BizzInfo[BIZ_PB][bEntranceZ])) return Msg(playerid,"Nem vagy Paintball Terem elott!");
	if(sscanf(params, "s[32]S()[32]", pm,subpm)) return Msg(playerid, "/paintball [ind�t�s/nevez�s/termek/ind�t�sok/fegyverek]");
	if(PlayerInfo[playerid][pPaintballKitiltva] == 1) return Msg(playerid, "Te el vagy tiltva a paintballoz�st�l!");
	if(BizzInfo[BIZ_PB][bLocked] == 1) return Msg(playerid, "Jelenleg z�rva vagyunk!");
	if(egyezik(pm,"ind�t�s") || egyezik(pm,"inditas"))
	{
		if(sscanf(subpm, "ddd", teremid,ido,jatekido)) return Msg(playerid,"Haszn�lata: /pb ind�t�s [Terem ID] [Nevez�si Id�(percben)] [J�t�kid�(percben)]");
		if(teremid < 1 || teremid > 4) return Msg(playerid, "A teremid minimum 1-es idj�, maximum 4-es idj�!");
		if(PaintballInfo[teremid][pbMerkozesIdo] >= UnixTime && PaintballInfo[teremid][pbHasznalva]) return Msg(playerid, "Ez a terem foglalt!");
		if(PaintballInfo[teremid][pbNevezesIdo] > 0) return Msg(playerid,"M�r van nevez�s folyamatban erre a teremre!");
		if(ido < 1 || ido > 5) return Msg(playerid,"A nevez�si id�, legal�bb 1 perc �s maximum 5 perc!");
		if(jatekido < 1 || jatekido > 30) return Msg(playerid, "A j�t�kid� minimum 1 perc, maximum 30 perc!");
		if(!BankkartyaFizet(playerid, BizzInfo[BIZ_PB][bEntranceCost], false)) return Msg(playerid,"Nemtudod kifezetni a m�rk�z�s �r�t");
		PaintballInfo[teremid][pbNevezesek] = 1;
		PaintballInfo[teremid][pbNevezesIdo] = ido*60;
		PaintballInfo[teremid][pbMerkozesIdo][1] = jatekido;
		Paintballnevezve[playerid] = true;
		PBTerem[playerid] = teremid;
		
		SendClientMessage(playerid,COLOR_LIGHTRED,"Paintball: Glob�lis nevez�st ind�tott�l! Ha elt�volodsz a bej�ratt�l, akkor a nevez�sed megsz�nik!");
		foreach(Jatekosok, p)
		{
			if(gPB[p] == 0) continue;
			SendClientMessage(p,COLOR_DYELLOW,"=====[ Paintball ]=====");
			SendClientMessage(p,COLOR_WHITE,"Hamarosan paintball m�rk�z�s indul, r�szletek a terem bej�rata el�tt!");
			SendFormatMessage(p,COLOR_WHITE,"TeremID: %d | Nevez�si d�j: %s Ft | J�t�kid�: %d perc | Nevezettek sz�ma: %d db | Nevezni lehet m�g: %d m�sodpercig", teremid, FormatInt(BizzInfo[BIZ_PB][bEntranceCost]*PaintballInfo[teremid][pbMerkozesIdo][1]), jatekido, PaintballInfo[teremid][pbNevezesek],PaintballInfo[teremid][pbNevezesIdo]);
		}
	}
	elseif(egyezik(pm,"nevez�s") || egyezik(pm,"nevezes"))	
	{
		if(sscanf(subpm, "d", teremid)) return Msg(playerid,"Haszn�lata /pb nevez�s [teremid]");
		if(teremid < 1 || teremid > 4) return Msg(playerid, "A teremid minimum 1-es idj�, maximum 4-es idj�!");
		if(PaintballInfo[teremid][pbNevezesek] == 0) return Msg(playerid,"Jelenleg nincs nevez�s folyamatban!");
		if(Paintballnevezve[playerid] || PBTerem[playerid] != 0) return Msg(playerid, "Te m�r nevezve vagy!");
		if(!BankkartyaFizet(playerid, BizzInfo[BIZ_PB][bEntranceCost], false)) return Msg(playerid,"Nemtudod kifezetni a m�rk�z�s �r�t");
		PaintballInfo[teremid][pbNevezesek]++;
		Paintballnevezve[playerid] = true;
		PBTerem[playerid] = teremid;
		SendFormatMessage(playerid,COLOR_LIGHTRED,"Paintball: Nevezt�l a m�rk�z�sre, jelenleg %d ember van benevezve. Ha elt�volodsz a bej�ratt�l, akkor a nevez�sed megsz�nik!",PaintballInfo[teremid][pbNevezesek]);
		foreach(Jatekosok, p)
		{
			if(Paintballnevezve[p])
				SendFormatMessage(p,COLOR_LIGHTRED,"Paintball: Egy ember nevezett a m�rk�z�sre, jelenleg %d ember van benevezve.",PaintballInfo[teremid][pbNevezesek]);
		}
		
		
	}
	elseif(egyezik(pm, "termek"))
	{
		SendClientMessage(playerid, COLOR_DYELLOW, "=====[ Paintball Termek ]=====");
		SendFormatMessage(playerid, COLOR_WHITE, "1: Hagyom�nyos, RC Battlefieldes terem (%s"COL_FEHER")", (PaintballInfo[1][pbHasznalva]) ? (""COL_PIROS"Foglalt") : (""COL_VZOLD"Szabad"));
		SendFormatMessage(playerid, COLOR_WHITE, "2: Sivatagi, elhagyatott, kis falu (%s"COL_FEHER")", (PaintballInfo[2][pbHasznalva]) ? (""COL_PIROS"Foglalt") : (""COL_VZOLD"Szabad"));
		SendFormatMessage(playerid, COLOR_WHITE, "3: Sivatagi, nagy m�ret� terem (%s"COL_FEHER")", (PaintballInfo[3][pbHasznalva]) ? (""COL_PIROS"Foglalt") : (""COL_VZOLD"Szabad"));
		SendFormatMessage(playerid, COLOR_WHITE, "4: Elhagyatott Area51-es terem (%s"COL_FEHER")", (PaintballInfo[4][pbHasznalva]) ? (""COL_PIROS"Foglalt") : (""COL_VZOLD"Szabad"));
	}
	elseif(egyezik(pm, "ind�t�sok"))
	{
		SendClientMessage(playerid, COLOR_DYELLOW, "=====[ Paintball termek, ahov� lehet nevezni ]=====");
		for(new teremidk = 1; teremidk < sizeof(PaintballInfo); teremidk++)
		{
			if(PaintballInfo[teremidk][pbNevezesek] > 0)
				SendFormatMessage(playerid, COLOR_WHITE, "TeremID: %d | Nevez�si d�j: %s Ft | J�t�kid�: %d perc | Nevezettek sz�ma: %d db | Nevezni lehet m�g: %d m�sodpercig", teremidk, FormatInt(BizzInfo[BIZ_PB][bEntranceCost]*PaintballInfo[teremidk][pbMerkozesIdo][1]), jatekido, PaintballInfo[teremidk][pbNevezesek],PaintballInfo[teremidk][pbNevezesIdo]);
			else continue;
		}
	}
	elseif(egyezik(pm, "fegyverek"))
	{
		Msg(playerid, "�ll�tsd be, hogy milyen fegyverekkel szeretn�l j�tszani!", true, COLOR_DYELLOW);
		tformat(256, "Pisztoly (Jelenleg: "COL_CITROM"%s"COL_FEHER")\nK�nny� l�fegyver (Jelenleg: "COL_CITROM"%s"COL_FEHER")\nS�r�tes puska (Jelenleg: "COL_CITROM"%s"COL_FEHER")\nNeh�z lofegyver (Jelenleg: "COL_CITROM"%s"COL_FEHER")", GunName(PlayerInfo[playerid][pPBFegyver][0]), GunName(PlayerInfo[playerid][pPBFegyver][1]), GunName(PlayerInfo[playerid][pPBFegyver][2]), GunName(PlayerInfo[playerid][pPBFegyver][3]));
		ShowPlayerDialog(playerid, DIALOG_PAINTBALL_FEGYVEREK, DIALOG_STYLE_LIST, "Paintball", _tmpString, "Kiv�laszt", "M�gse");
		Freeze(playerid);
	}
	elseif(egyezik(pm, "kitilt") && (PlayerInfo[playerid][pPbiskey] == BIZ_PB || PlayerInfo[playerid][pBizniszKulcs] == BIZ_PB))
	{
		new jatekos, ok[128];
		if(sscanf(subpm, "rs[128]", jatekos, ok)) return Msg(playerid, "/paintball kitilt [N�v/ID] [Oka]");
		if(jatekos == INVALID_PLAYER_ID) return Msg(playerid, "Nem l�tez� n�v/id");
		if(PlayerInfo[playerid][pPaintballKitiltva] == 0)
		{
			PlayerInfo[jatekos][pPaintballKitiltva] = 1;
			SendFormatMessage(playerid, COLOR_LIGHTRED, "%s eltiltva a paintballoz�st�l!", ICPlayerName(jatekos));
			SendFormatMessage(jatekos, COLOR_LIGHTRED, "%s eltiltott a paintballoz�st�l, oka: %s", ICPlayerName(playerid), ok);
		}
		else
		{
			PlayerInfo[jatekos][pPaintballKitiltva] = 0;
			SendFormatMessage(playerid, COLOR_LIGHTRED, "%s tilt�sa feloldva, �jra paintballozhat!", ICPlayerName(jatekos));
			SendFormatMessage(jatekos, COLOR_LIGHTRED, "%s feloldotta a tilt�st, ism�t paintballozhatsz! Oka: %s", ICPlayerName(playerid), ok);
		}
	}
	return 1;
}

CMD:setweaponskill(playerid, params[])
{
	if(!Admin(playerid, 1337) && !IsScripter(playerid)) return 1;
	new kinek, mit[32], mennyire, skill;
	if(sscanf(params, "rs[32]d", kinek,mit,mennyire)) return Msg(playerid,"Haszn�lata: /setweaponskill [J�t�kos/ID] [Pisztoly/Silenced/Deagle/Shotgun/Combat/Mp5/AK47/M4/Sniper] [�rt�k]");
	if(!IsPlayerConnected(kinek) || kinek == INVALID_PLAYER_ID) return Msg(playerid,"Nincs ilyen j�t�kos");
	if(egyezik(mit,"pisztoly")) skill = 0; 
	else if(egyezik(mit,"silenced")) skill = 1;
	else if(egyezik(mit,"deagle")) skill= 2; 
	else if(egyezik(mit,"shotgun")) skill = 3;
	else if(egyezik(mit,"combat")) skill = 5;
	else if(egyezik(mit,"mp5")) skill = 7;
	else if(egyezik(mit,"ak47")) skill= 8;
	else if(egyezik(mit,"m4")) skill = 9;
	else if(egyezik(mit,"sniper")) skill = 10;
	else return Msg(playerid, "/setweaponskill [J�t�kos/ID] [Pisztoly/Silenced/Deagle/Shotgun/Combat/Mp5/AK47/M4/Sniper] [�rt�k]");
	PlayerInfo[kinek][pFegyverSkillek][skill] = mennyire;
	FegyverSkillFrissites(kinek);
	SendFormatMessage(kinek,COLOR_LIGHTBLUE,"%s �t�rta a fegyver tapasztalatod! Fegyver: %s - Be�ll�tott �rt�k: %d", AdminName(playerid), mit, PlayerInfo[kinek][pFegyverSkillek][skill]);
	SendFormatMessage(playerid,COLOR_LIGHTBLUE,"�t�rtad %s fegyver tapasztalat�t! Fegyver: %s - Be�ll�tott �rt�k: %d", PlayerName(kinek), mit, PlayerInfo[kinek][pFegyverSkillek][skill]);
	
	format(_tmpString,sizeof(_tmpString),"<< %s �t�rta %s fegyverskillj�t - Fegyver: %s - Be�ll�tott �rt�k: %d >>", AdminName(playerid), PlayerName(kinek), mit, PlayerInfo[kinek][pFegyverSkillek][skill]);
	
	SendMessage(SEND_MESSAGE_ADMIN,_tmpString,COLOR_LIGHTRED,PlayerInfo[playerid][pAdmin]);
	return 1;
}

ALIAS(idgscripter):ideiglenesscripter;
CMD:ideiglenesscripter(playerid, params[])
{
	new kit;
	if(!IsScripter(playerid)) return 1;
	if(IdgScripter[playerid]) return Msg(playerid, "Ugye nem gondoltad komolyan, hogy te fogsz m�sokat kinevezni?");
	if(sscanf(params, "u", kit)) return Msg(playerid, "/ideiglenesscripter [N�v/ID] - Ezt a jogot csak relogig kapja meg!");
	if(kit == INVALID_PLAYER_ID) return Msg(playerid, "Hib�s n�v/id");
	if(IsScripter(kit) && !IdgScripter[kit]) return Msg(playerid, "� scripter, nem nevezheted ki!");
	if(!Admin(kit, 1337)) return Msg(playerid, "Nem adhatsz neki scripter jogot, mert az adminszintje kisebb, mint 1337!");
	if(IdgScripter[kit])
	{
		IdgScripter[kit] = false;
		SendFormatMessage(playerid, COLOR_LIGHTRED, "ClassRPG: Elvetted %st�l az ideiglenes scripter jogosults�got", PlayerName(kit));
		SendFormatMessage(kit, COLOR_LIGHTRED, "ClassRPG: %s elvette t�led az ideiglenes scripter jogosults�got", PlayerName(playerid));
	}
	else
	{
		IdgScripter[kit] = true;
		SendFormatMessage(playerid, COLOR_LIGHTRED, "ClassRPG: Kinevezted %st ideiglenes scripternek - ez a jogosults�got relogig kapja meg", PlayerName(kit));
		SendFormatMessage(kit, COLOR_LIGHTRED, "ClassRPG: %s kinevezett ideiglenes scripternek, �gy haszn�lhatod a scripter jogait", PlayerName(playerid));
		SendClientMessage(kit, COLOR_LIGHTRED, "ClassRPG: Ezt a jogosults�got csak relogig haszn�lhatod, vagy am�g el nem veszi t�led egy scripter");
	}
	return 1;
}

ALIAS(k5zmunk1sok):kozmunkasok;
CMD:kozmunkasok(playerid, params[])
{
	if(!IsACop(playerid) && !Admin(playerid, 1)) return Msg(playerid, "Nem vagy rend�r!");
	new c = 0;
	SendClientMessage(playerid, COLOR_ADD, "=====[ K�zmunk�n l�v� emberek ]=====");
	foreach(Jatekosok, x)
	{
		if(PlayerInfo[x][pKozmunka] != 0)
		{
			if(PlayerInfo[x][pKozmunkaIdo] != 0)
				SendFormatMessage(playerid, COLOR_GREEN, "[%d]%s | H�tral�v� j�tszott �r�k: %d | H�tral�v� let�ltend� b�ntet�s: %d m�sodperc", x, ICPlayerName(x), PlayerInfo[x][pKozmunkaIdo], PlayerInfo[x][pJailTime]);
			else
			{
				SendFormatMessage(playerid, COLOR_RED, "[%d]%s | Elhalasztotta a k�zmunk�t | K�r�z�s kiadva", x, ICPlayerName(x));
				if(!egyezik(PlayerCrime[x][pVad], "K�zmunka elhalaszt�sa")) SetPlayerCriminal(x, 255, "K�zmunka elhalaszt�sa");
			}
			c++;
		}
	}
	if(c == 0) SendClientMessage(playerid, COLOR_WHITE, "Jelenleg nincs k�zmunk�n l�v� ember.");
	return 1;
}

CMD:carresi(playerid, params[])
{
	if(CarRespawnSzamlalo != NINCS) return Msg(playerid, "�pp folyamatban van egy carresi!");
	SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Legk�zelebb %d mp m�lva lesz car resi.", ResiCounter);
	if(Admin(playerid, 6)) Msg(playerid, "Carresihez parancsok: /acrmost /acr /acr30");
	return 1;
}

ALIAS(l6szerek):loszerek;
CMD:loszerek(playerid, params[])
{
	if(!MunkaLeader(playerid, FRAKCIO_SCPD) && !MunkaLeader(playerid, FRAKCIO_SFPD) && !MunkaLeader(playerid, FRAKCIO_FBI) && !MunkaLeader(playerid, FRAKCIO_KATONASAG) && !MunkaLeader(playerid, FRAKCIO_NAV) && !Admin(playerid, 1)) return 1;
	
	new frakcio;
	SendClientMessage(playerid, COLOR_LIGHTGREEN, "================================ L�SZEREK ================================");
	
	if(PlayerInfo[playerid][pLeader] == FRAKCIO_NAV || Admin(playerid, 1))
	{
		frakcio=FRAKCIO_SCPD;
		SendFormatMessage(playerid, COLOR_WHITE, "[LSPD] Deagle: %d | Silenced: %d | Mp5: %d | M4: %d | Shotgun: %d",FrakcioInfo[frakcio][fDeagle][1], FrakcioInfo[frakcio][fSilenced][1], FrakcioInfo[frakcio][fMp5][1], FrakcioInfo[frakcio][fM4][1], FrakcioInfo[frakcio][fShotgun][1]);
		SendFormatMessage(playerid, COLOR_WHITE, "[LSPD] Sniper: %d | Combat: %d | Rifle: %d | Ejt�erny�: %d",FrakcioInfo[frakcio][fSniper][1], FrakcioInfo[frakcio][fCombat][1],FrakcioInfo[frakcio][fRifle][1],FrakcioInfo[frakcio][fParachute]);
		//
		frakcio=FRAKCIO_SFPD;
		SendFormatMessage(playerid, COLOR_WHITE, "[SFPD] Deagle: %d | Silenced: %d | Mp5: %d | M4: %d | Shotgun: %d",FrakcioInfo[frakcio][fDeagle][1], FrakcioInfo[frakcio][fSilenced][1], FrakcioInfo[frakcio][fMp5][1], FrakcioInfo[frakcio][fM4][1], FrakcioInfo[frakcio][fShotgun][1]);
		SendFormatMessage(playerid, COLOR_WHITE, "[SFPD] Sniper: %d | Combat: %d | Rifle: %d | Ejt�erny�: %d",FrakcioInfo[frakcio][fSniper][1], FrakcioInfo[frakcio][fCombat][1],FrakcioInfo[frakcio][fRifle][1],FrakcioInfo[frakcio][fParachute]);
		//
		frakcio=FRAKCIO_FBI;
		SendFormatMessage(playerid, COLOR_WHITE, "[FBI] Deagle: %d | Silenced: %d | Mp5: %d | M4: %d | Shotgun: %d",FrakcioInfo[frakcio][fDeagle][1], FrakcioInfo[frakcio][fSilenced][1], FrakcioInfo[frakcio][fMp5][1], FrakcioInfo[frakcio][fM4][1], FrakcioInfo[frakcio][fShotgun][1]);
		SendFormatMessage(playerid, COLOR_WHITE, "[FBI] Sniper: %d | Combat: %d | Rifle: %d | Ejt�erny�: %d",FrakcioInfo[frakcio][fSniper][1], FrakcioInfo[frakcio][fCombat][1],FrakcioInfo[frakcio][fRifle][1],FrakcioInfo[frakcio][fParachute]);
		//
		frakcio=FRAKCIO_NAV;
		SendFormatMessage(playerid, COLOR_WHITE, "[NAV] Deagle: %d | Silenced: %d | Mp5: %d | M4: %d | Shotgun: %d",FrakcioInfo[frakcio][fDeagle][1], FrakcioInfo[frakcio][fSilenced][1], FrakcioInfo[frakcio][fMp5][1], FrakcioInfo[frakcio][fM4][1], FrakcioInfo[frakcio][fShotgun][1]);
		SendFormatMessage(playerid, COLOR_WHITE, "[NAV] Sniper: %d | Combat: %d | Rifle: %d | Ejt�erny�: %d",FrakcioInfo[frakcio][fSniper][1], FrakcioInfo[frakcio][fCombat][1],FrakcioInfo[frakcio][fRifle][1],FrakcioInfo[frakcio][fParachute]);
		//
		frakcio=FRAKCIO_KATONASAG;
		SendFormatMessage(playerid, COLOR_WHITE, "[CCMF] Deagle: %d | Silenced: %d | Mp5: %d | M4: %d | Shotgun: %d",FrakcioInfo[frakcio][fDeagle][1], FrakcioInfo[frakcio][fSilenced][1], FrakcioInfo[frakcio][fMp5][1], FrakcioInfo[frakcio][fM4][1], FrakcioInfo[frakcio][fShotgun][1]);
		SendFormatMessage(playerid, COLOR_WHITE, "[CCMF] Sniper: %d | Combat: %d | Rifle: %d | Ejt�erny�: %d",FrakcioInfo[frakcio][fSniper][1], FrakcioInfo[frakcio][fCombat][1],FrakcioInfo[frakcio][fRifle][1],FrakcioInfo[frakcio][fParachute]);
	}
	else
	{
		switch(PlayerInfo[playerid][pLeader])
		{
			case FRAKCIO_SCPD:
			{
				frakcio=FRAKCIO_SCPD;
				SendFormatMessage(playerid, COLOR_WHITE, "[LSPD] Deagle: %d | Silenced: %d | Mp5: %d | M4: %d | Shotgun: %d",FrakcioInfo[frakcio][fDeagle][1], FrakcioInfo[frakcio][fSilenced][1], FrakcioInfo[frakcio][fMp5][1], FrakcioInfo[frakcio][fM4][1], FrakcioInfo[frakcio][fShotgun][1]);
				SendFormatMessage(playerid, COLOR_WHITE, "[LSPD] Sniper: %d | Combat: %d | Rifle: %d | Ejt�erny�: %d",FrakcioInfo[frakcio][fSniper][1], FrakcioInfo[frakcio][fCombat][1],FrakcioInfo[frakcio][fRifle][1],FrakcioInfo[frakcio][fParachute]);
			}
			case FRAKCIO_SFPD:
			{
				frakcio=FRAKCIO_SFPD;
				SendFormatMessage(playerid, COLOR_WHITE, "[SFPD] Deagle: %d | Silenced: %d | Mp5: %d | M4: %d | Shotgun: %d",FrakcioInfo[frakcio][fDeagle][1], FrakcioInfo[frakcio][fSilenced][1], FrakcioInfo[frakcio][fMp5][1], FrakcioInfo[frakcio][fM4][1], FrakcioInfo[frakcio][fShotgun][1]);
				SendFormatMessage(playerid, COLOR_WHITE, "[SFPD] Sniper: %d | Combat: %d | Rifle: %d | Ejt�erny�: %d",FrakcioInfo[frakcio][fSniper][1], FrakcioInfo[frakcio][fCombat][1],FrakcioInfo[frakcio][fRifle][1],FrakcioInfo[frakcio][fParachute]);
			}
			case FRAKCIO_FBI:
			{
				frakcio=FRAKCIO_FBI;
				SendFormatMessage(playerid, COLOR_WHITE, "[FBI] Deagle: %d | Silenced: %d | Mp5: %d | M4: %d | Shotgun: %d",FrakcioInfo[frakcio][fDeagle][1], FrakcioInfo[frakcio][fSilenced][1], FrakcioInfo[frakcio][fMp5][1], FrakcioInfo[frakcio][fM4][1], FrakcioInfo[frakcio][fShotgun][1]);
				SendFormatMessage(playerid, COLOR_WHITE, "[FBI] Sniper: %d | Combat: %d | Rifle: %d | Ejt�erny�: %d",FrakcioInfo[frakcio][fSniper][1], FrakcioInfo[frakcio][fCombat][1],FrakcioInfo[frakcio][fRifle][1],FrakcioInfo[frakcio][fParachute]);
			}
			case FRAKCIO_NAV:
			{
				frakcio=FRAKCIO_NAV;
				SendFormatMessage(playerid, COLOR_WHITE, "[NAV] Deagle: %d | Silenced: %d | Mp5: %d | M4: %d | Shotgun: %d",FrakcioInfo[frakcio][fDeagle][1], FrakcioInfo[frakcio][fSilenced][1], FrakcioInfo[frakcio][fMp5][1], FrakcioInfo[frakcio][fM4][1], FrakcioInfo[frakcio][fShotgun][1]);
				SendFormatMessage(playerid, COLOR_WHITE, "[NAV] Sniper: %d | Combat: %d | Rifle: %d | Ejt�erny�: %d",FrakcioInfo[frakcio][fSniper][1], FrakcioInfo[frakcio][fCombat][1],FrakcioInfo[frakcio][fRifle][1],FrakcioInfo[frakcio][fParachute]);
			}
			case FRAKCIO_KATONASAG:
			{
				frakcio=FRAKCIO_KATONASAG;
				SendFormatMessage(playerid, COLOR_WHITE, "[KATONAS�G] Deagle: %d | Silenced: %d | Mp5: %d | M4: %d | Shotgun: %d",FrakcioInfo[frakcio][fDeagle][1], FrakcioInfo[frakcio][fSilenced][1], FrakcioInfo[frakcio][fMp5][1], FrakcioInfo[frakcio][fM4][1], FrakcioInfo[frakcio][fShotgun][1]);
				SendFormatMessage(playerid, COLOR_WHITE, "[KATONAS�G] Sniper: %d | Combat: %d | Rifle: %d | Ejt�erny�: %d",FrakcioInfo[frakcio][fSniper][1], FrakcioInfo[frakcio][fCombat][1],FrakcioInfo[frakcio][fRifle][1],FrakcioInfo[frakcio][fParachute]);
			}
		}
	}
	SendClientMessage(playerid, COLOR_LIGHTGREEN,"================================ L�SZEREK ================================");
	return 1;
}

CMD:fegyverek(playerid, params[])
{
	if(!MunkaLeader(playerid, FRAKCIO_SCPD) && !MunkaLeader(playerid, FRAKCIO_SFPD) && !MunkaLeader(playerid, FRAKCIO_FBI) && !MunkaLeader(playerid, FRAKCIO_KATONASAG) && !MunkaLeader(playerid, FRAKCIO_NAV) && !Admin(playerid, 1)) return 1;
	
	new frakcio;
	SendClientMessage(playerid, COLOR_LIGHTGREEN, "================================ FEGYVEREK ================================");
	
	if(PlayerInfo[playerid][pLeader] == FRAKCIO_NAV || Admin(playerid, 1))
	{
		frakcio=FRAKCIO_SCPD;
		SendFormatMessage(playerid, COLOR_WHITE, "[LSPD] Deagle: %d | Silenced: %d | Mp5: %d | M4: %d | Shotgun: %d",FrakcioInfo[frakcio][fDeagle][0], FrakcioInfo[frakcio][fSilenced][0], FrakcioInfo[frakcio][fMp5][0], FrakcioInfo[frakcio][fM4][0], FrakcioInfo[frakcio][fShotgun][0]);
		SendFormatMessage(playerid, COLOR_WHITE, "[LSPD] Sniper: %d | Combat: %d | Rifle: %d | Ejt�erny�: %d",FrakcioInfo[frakcio][fSniper][0], FrakcioInfo[frakcio][fCombat][0],FrakcioInfo[frakcio][fRifle][0],FrakcioInfo[frakcio][fParachute]);
		//
		frakcio=FRAKCIO_SFPD;
		SendFormatMessage(playerid, COLOR_WHITE, "[SFPD] Deagle: %d | Silenced: %d | Mp5: %d | M4: %d | Shotgun: %d",FrakcioInfo[frakcio][fDeagle][0], FrakcioInfo[frakcio][fSilenced][0], FrakcioInfo[frakcio][fMp5][0], FrakcioInfo[frakcio][fM4][0], FrakcioInfo[frakcio][fShotgun][0]);
		SendFormatMessage(playerid, COLOR_WHITE, "[SFPD] Sniper: %d | Combat: %d | Rifle: %d | Ejt�erny�: %d",FrakcioInfo[frakcio][fSniper][0], FrakcioInfo[frakcio][fCombat][0],FrakcioInfo[frakcio][fRifle][0],FrakcioInfo[frakcio][fParachute]);
		//
		frakcio=FRAKCIO_FBI;
		SendFormatMessage(playerid, COLOR_WHITE, "[FBI] Deagle: %d | Silenced: %d | Mp5: %d | M4: %d | Shotgun: %d",FrakcioInfo[frakcio][fDeagle][0], FrakcioInfo[frakcio][fSilenced][0], FrakcioInfo[frakcio][fMp5][0], FrakcioInfo[frakcio][fM4][0], FrakcioInfo[frakcio][fShotgun][0]);
		SendFormatMessage(playerid, COLOR_WHITE, "[FBI] Sniper: %d | Combat: %d | Rifle: %d | Ejt�erny�: %d",FrakcioInfo[frakcio][fSniper][0], FrakcioInfo[frakcio][fCombat][0],FrakcioInfo[frakcio][fRifle][0],FrakcioInfo[frakcio][fParachute]);
		//
		frakcio=FRAKCIO_NAV;
		SendFormatMessage(playerid, COLOR_WHITE, "[NAV] Deagle: %d | Silenced: %d | Mp5: %d | M4: %d | Shotgun: %d",FrakcioInfo[frakcio][fDeagle][0], FrakcioInfo[frakcio][fSilenced][0], FrakcioInfo[frakcio][fMp5][0], FrakcioInfo[frakcio][fM4][0], FrakcioInfo[frakcio][fShotgun][0]);
		SendFormatMessage(playerid, COLOR_WHITE, "[NAV] Sniper: %d | Combat: %d | Rifle: %d | Ejt�erny�: %d",FrakcioInfo[frakcio][fSniper][0], FrakcioInfo[frakcio][fCombat][0],FrakcioInfo[frakcio][fRifle][0],FrakcioInfo[frakcio][fParachute]);
		//
		frakcio=FRAKCIO_KATONASAG;
		SendFormatMessage(playerid, COLOR_WHITE, "[CCMF] Deagle: %d | Silenced: %d | Mp5: %d | M4: %d | Shotgun: %d",FrakcioInfo[frakcio][fDeagle][0], FrakcioInfo[frakcio][fSilenced][0], FrakcioInfo[frakcio][fMp5][0], FrakcioInfo[frakcio][fM4][0], FrakcioInfo[frakcio][fShotgun][0]);
		SendFormatMessage(playerid, COLOR_WHITE, "[CCMF] Sniper: %d | Combat: %d | Rifle: %d | Ejt�erny�: %d",FrakcioInfo[frakcio][fSniper][0], FrakcioInfo[frakcio][fCombat][0],FrakcioInfo[frakcio][fRifle][0],FrakcioInfo[frakcio][fParachute]);
	}
	else
	{
		switch(PlayerInfo[playerid][pLeader])
		{
			case FRAKCIO_SCPD:
			{
				frakcio=FRAKCIO_SCPD;
				SendFormatMessage(playerid, COLOR_WHITE, "[LSPD] Deagle: %d | Silenced: %d | Mp5: %d | M4: %d | Shotgun: %d",FrakcioInfo[frakcio][fDeagle][0], FrakcioInfo[frakcio][fSilenced][0], FrakcioInfo[frakcio][fMp5][0], FrakcioInfo[frakcio][fM4][0], FrakcioInfo[frakcio][fShotgun][0]);
				SendFormatMessage(playerid, COLOR_WHITE, "[LSPD] Sniper: %d | Combat: %d | Rifle: %d | Ejt�erny�: %d",FrakcioInfo[frakcio][fSniper][0], FrakcioInfo[frakcio][fCombat][0],FrakcioInfo[frakcio][fRifle][0],FrakcioInfo[frakcio][fParachute]);
			}
			case FRAKCIO_SFPD:
			{
				frakcio=FRAKCIO_SFPD;
				SendFormatMessage(playerid, COLOR_WHITE, "[SFPD] Deagle: %d | Silenced: %d | Mp5: %d | M4: %d | Shotgun: %d",FrakcioInfo[frakcio][fDeagle][0], FrakcioInfo[frakcio][fSilenced][0], FrakcioInfo[frakcio][fMp5][0], FrakcioInfo[frakcio][fM4][0], FrakcioInfo[frakcio][fShotgun][0]);
				SendFormatMessage(playerid, COLOR_WHITE, "[SFPD] Sniper: %d | Combat: %d | Rifle: %d | Ejt�erny�: %d",FrakcioInfo[frakcio][fSniper][0], FrakcioInfo[frakcio][fCombat][0],FrakcioInfo[frakcio][fRifle][0],FrakcioInfo[frakcio][fParachute]);
			}
			case FRAKCIO_FBI:
			{
				frakcio=FRAKCIO_FBI;
				SendFormatMessage(playerid, COLOR_WHITE, "[FBI] Deagle: %d | Silenced: %d | Mp5: %d | M4: %d | Shotgun: %d",FrakcioInfo[frakcio][fDeagle][0], FrakcioInfo[frakcio][fSilenced][0], FrakcioInfo[frakcio][fMp5][0], FrakcioInfo[frakcio][fM4][0], FrakcioInfo[frakcio][fShotgun][0]);
				SendFormatMessage(playerid, COLOR_WHITE, "[FBI] Sniper: %d | Combat: %d | Rifle: %d | Ejt�erny�: %d",FrakcioInfo[frakcio][fSniper][0], FrakcioInfo[frakcio][fCombat][0],FrakcioInfo[frakcio][fRifle][0],FrakcioInfo[frakcio][fParachute]);
			}
			case FRAKCIO_NAV:
			{
				frakcio=FRAKCIO_NAV;
				SendFormatMessage(playerid, COLOR_WHITE, "[NAV] Deagle: %d | Silenced: %d | Mp5: %d | M4: %d | Shotgun: %d",FrakcioInfo[frakcio][fDeagle][0], FrakcioInfo[frakcio][fSilenced][0], FrakcioInfo[frakcio][fMp5][0], FrakcioInfo[frakcio][fM4][0], FrakcioInfo[frakcio][fShotgun][0]);
				SendFormatMessage(playerid, COLOR_WHITE, "[NAV] Sniper: %d | Combat: %d | Rifle: %d | Ejt�erny�: %d",FrakcioInfo[frakcio][fSniper][0], FrakcioInfo[frakcio][fCombat][0],FrakcioInfo[frakcio][fRifle][0],FrakcioInfo[frakcio][fParachute]);
			}
			case FRAKCIO_KATONASAG:
			{
				frakcio=FRAKCIO_KATONASAG;
				SendFormatMessage(playerid, COLOR_WHITE, "[KATONAS�G] Deagle: %d | Silenced: %d | Mp5: %d | M4: %d | Shotgun: %d",FrakcioInfo[frakcio][fDeagle][0], FrakcioInfo[frakcio][fSilenced][0], FrakcioInfo[frakcio][fMp5][0], FrakcioInfo[frakcio][fM4][0], FrakcioInfo[frakcio][fShotgun][0]);
				SendFormatMessage(playerid, COLOR_WHITE, "[KATONAS�G] Sniper: %d | Combat: %d | Rifle: %d | Ejt�erny�: %d",FrakcioInfo[frakcio][fSniper][0], FrakcioInfo[frakcio][fCombat][0],FrakcioInfo[frakcio][fRifle][0],FrakcioInfo[frakcio][fParachute]);
			}
		}
	}
	SendClientMessage(playerid, COLOR_LIGHTGREEN,"================================ FEGYVEREK ================================");
	return 1;
}

ALIAS(gumil5ved2kek):gumilovedekek;
CMD:gumilovedekek(playerid, params[])
{
	if(!MunkaLeader(playerid, FRAKCIO_SCPD) && !MunkaLeader(playerid, FRAKCIO_SFPD) && !MunkaLeader(playerid, FRAKCIO_FBI) && !MunkaLeader(playerid, FRAKCIO_KATONASAG) && !MunkaLeader(playerid, FRAKCIO_NAV) && !Admin(playerid, 1)) return 1;
	
	new frakcio;
	SendClientMessage(playerid, COLOR_LIGHTGREEN, "================================ GUMIL�VED�KEK ================================");
	
	if(PlayerInfo[playerid][pLeader] == FRAKCIO_NAV || Admin(playerid, 1))
	{
		frakcio=FRAKCIO_SCPD;
		SendFormatMessage(playerid, COLOR_WHITE, "[LSPD] Deagle: %d | Silenced: %d | Mp5: %d | M4: %d | Shotgun: %d",FrakcioInfo[frakcio][fDeagle][3], FrakcioInfo[frakcio][fSilenced][3], FrakcioInfo[frakcio][fMp5][3], FrakcioInfo[frakcio][fM4][3], FrakcioInfo[frakcio][fShotgun][3]);
		SendFormatMessage(playerid, COLOR_WHITE, "[LSPD] Sniper: %d | Combat: %d | Rifle: %d | Ejt�erny�: %d",FrakcioInfo[frakcio][fSniper][3], FrakcioInfo[frakcio][fCombat][3],FrakcioInfo[frakcio][fRifle][3],FrakcioInfo[frakcio][fParachute]);
		//
		frakcio=FRAKCIO_SFPD;
		SendFormatMessage(playerid, COLOR_WHITE, "[SFPD] Deagle: %d | Silenced: %d | Mp5: %d | M4: %d | Shotgun: %d",FrakcioInfo[frakcio][fDeagle][3], FrakcioInfo[frakcio][fSilenced][3], FrakcioInfo[frakcio][fMp5][3], FrakcioInfo[frakcio][fM4][3], FrakcioInfo[frakcio][fShotgun][3]);
		SendFormatMessage(playerid, COLOR_WHITE, "[SFPD] Sniper: %d | Combat: %d | Rifle: %d | Ejt�erny�: %d",FrakcioInfo[frakcio][fSniper][3], FrakcioInfo[frakcio][fCombat][3],FrakcioInfo[frakcio][fRifle][3],FrakcioInfo[frakcio][fParachute]);
		//
		frakcio=FRAKCIO_FBI;
		SendFormatMessage(playerid, COLOR_WHITE, "[FBI] Deagle: %d | Silenced: %d | Mp5: %d | M4: %d | Shotgun: %d",FrakcioInfo[frakcio][fDeagle][3], FrakcioInfo[frakcio][fSilenced][3], FrakcioInfo[frakcio][fMp5][3], FrakcioInfo[frakcio][fM4][3], FrakcioInfo[frakcio][fShotgun][3]);
		SendFormatMessage(playerid, COLOR_WHITE, "[FBI] Sniper: %d | Combat: %d | Rifle: %d | Ejt�erny�: %d",FrakcioInfo[frakcio][fSniper][3], FrakcioInfo[frakcio][fCombat][3],FrakcioInfo[frakcio][fRifle][3],FrakcioInfo[frakcio][fParachute]);
		//
		frakcio=FRAKCIO_NAV;
		SendFormatMessage(playerid, COLOR_WHITE, "[NAV] Deagle: %d | Silenced: %d | Mp5: %d | M4: %d | Shotgun: %d",FrakcioInfo[frakcio][fDeagle][3], FrakcioInfo[frakcio][fSilenced][3], FrakcioInfo[frakcio][fMp5][3], FrakcioInfo[frakcio][fM4][3], FrakcioInfo[frakcio][fShotgun][3]);
		SendFormatMessage(playerid, COLOR_WHITE, "[NAV] Sniper: %d | Combat: %d | Rifle: %d | Ejt�erny�: %d",FrakcioInfo[frakcio][fSniper][3], FrakcioInfo[frakcio][fCombat][3],FrakcioInfo[frakcio][fRifle][3],FrakcioInfo[frakcio][fParachute]);
		//
		frakcio=FRAKCIO_KATONASAG;
		SendFormatMessage(playerid, COLOR_WHITE, "[CCMF] Deagle: %d | Silenced: %d | Mp5: %d | M4: %d | Shotgun: %d",FrakcioInfo[frakcio][fDeagle][3], FrakcioInfo[frakcio][fSilenced][3], FrakcioInfo[frakcio][fMp5][3], FrakcioInfo[frakcio][fM4][3], FrakcioInfo[frakcio][fShotgun][3]);
		SendFormatMessage(playerid, COLOR_WHITE, "[CCMF] Sniper: %d | Combat: %d | Rifle: %d | Ejt�erny�: %d",FrakcioInfo[frakcio][fSniper][3], FrakcioInfo[frakcio][fCombat][3],FrakcioInfo[frakcio][fRifle][3],FrakcioInfo[frakcio][fParachute]);
	}
	else
	{
		switch(PlayerInfo[playerid][pLeader])
		{
			case FRAKCIO_SCPD:
			{
				frakcio=FRAKCIO_SCPD;
				SendFormatMessage(playerid, COLOR_WHITE, "[LSPD] Deagle: %d | Silenced: %d | Mp5: %d | M4: %d | Shotgun: %d",FrakcioInfo[frakcio][fDeagle][3], FrakcioInfo[frakcio][fSilenced][3], FrakcioInfo[frakcio][fMp5][3], FrakcioInfo[frakcio][fM4][3], FrakcioInfo[frakcio][fShotgun][3]);
				SendFormatMessage(playerid, COLOR_WHITE, "[LSPD] Sniper: %d | Combat: %d | Rifle: %d | Ejt�erny�: %d",FrakcioInfo[frakcio][fSniper][3], FrakcioInfo[frakcio][fCombat][3],FrakcioInfo[frakcio][fRifle][3],FrakcioInfo[frakcio][fParachute]);
			}
			case FRAKCIO_SFPD:
			{
				frakcio=FRAKCIO_SFPD;
				SendFormatMessage(playerid, COLOR_WHITE, "[SFPD] Deagle: %d | Silenced: %d | Mp5: %d | M4: %d | Shotgun: %d",FrakcioInfo[frakcio][fDeagle][3], FrakcioInfo[frakcio][fSilenced][3], FrakcioInfo[frakcio][fMp5][3], FrakcioInfo[frakcio][fM4][3], FrakcioInfo[frakcio][fShotgun][3]);
				SendFormatMessage(playerid, COLOR_WHITE, "[SFPD] Sniper: %d | Combat: %d | Rifle: %d | Ejt�erny�: %d",FrakcioInfo[frakcio][fSniper][3], FrakcioInfo[frakcio][fCombat][3],FrakcioInfo[frakcio][fRifle][3],FrakcioInfo[frakcio][fParachute]);
			}
			case FRAKCIO_FBI:
			{
				frakcio=FRAKCIO_FBI;
				SendFormatMessage(playerid, COLOR_WHITE, "[FBI] Deagle: %d | Silenced: %d | Mp5: %d | M4: %d | Shotgun: %d",FrakcioInfo[frakcio][fDeagle][3], FrakcioInfo[frakcio][fSilenced][3], FrakcioInfo[frakcio][fMp5][3], FrakcioInfo[frakcio][fM4][3], FrakcioInfo[frakcio][fShotgun][3]);
				SendFormatMessage(playerid, COLOR_WHITE, "[FBI] Sniper: %d | Combat: %d | Rifle: %d | Ejt�erny�: %d",FrakcioInfo[frakcio][fSniper][3], FrakcioInfo[frakcio][fCombat][3],FrakcioInfo[frakcio][fRifle][3],FrakcioInfo[frakcio][fParachute]);
			}
			case FRAKCIO_NAV:
			{
				frakcio=FRAKCIO_NAV;
				SendFormatMessage(playerid, COLOR_WHITE, "[NAV] Deagle: %d | Silenced: %d | Mp5: %d | M4: %d | Shotgun: %d",FrakcioInfo[frakcio][fDeagle][3], FrakcioInfo[frakcio][fSilenced][3], FrakcioInfo[frakcio][fMp5][3], FrakcioInfo[frakcio][fM4][3], FrakcioInfo[frakcio][fShotgun][3]);
				SendFormatMessage(playerid, COLOR_WHITE, "[NAV] Sniper: %d | Combat: %d | Rifle: %d | Ejt�erny�: %d",FrakcioInfo[frakcio][fSniper][3], FrakcioInfo[frakcio][fCombat][3],FrakcioInfo[frakcio][fRifle][3],FrakcioInfo[frakcio][fParachute]);
			}
			case FRAKCIO_KATONASAG:
			{
				frakcio=FRAKCIO_KATONASAG;
				SendFormatMessage(playerid, COLOR_WHITE, "[KATONAS�G] Deagle: %d | Silenced: %d | Mp5: %d | M4: %d | Shotgun: %d",FrakcioInfo[frakcio][fDeagle][3], FrakcioInfo[frakcio][fSilenced][3], FrakcioInfo[frakcio][fMp5][3], FrakcioInfo[frakcio][fM4][3], FrakcioInfo[frakcio][fShotgun][3]);
				SendFormatMessage(playerid, COLOR_WHITE, "[KATONAS�G] Sniper: %d | Combat: %d | Rifle: %d | Ejt�erny�: %d",FrakcioInfo[frakcio][fSniper][3], FrakcioInfo[frakcio][fCombat][3],FrakcioInfo[frakcio][fRifle][3],FrakcioInfo[frakcio][fParachute]);
			}
		}
	}
	SendClientMessage(playerid, COLOR_LIGHTGREEN,"================================ GUMIL�VED�KEK ================================");
	return 1;
}

ALIAS(rakt1r):raktar;
CMD:raktar(playerid, params[])
{
	new pm[32], subpm[64], subby[64], mit[32], mennyit, melo = PlayerInfo[playerid][pMember], fkid, szeflog[256], hour;
	gettime(hour);
	if(FloodCheck(playerid)) return 1;
	if(Civil(playerid) && !IsScripter(playerid)) return Msg(playerid, "Nem tartozol frakci�hoz.");
	if(sscanf(params, "s[32]S()[64]", pm, subpm))
	{
		if(!Admin(playerid, 1337) && !IsScripter(playerid)) return Msg(playerid, "/rakt�r [Megn�z/Berak/Kivesz/Minrang(leadernek)]");
		Msg(playerid, "/rakt�r [Megn�z/Berak/Kivesz/Minrang/�rt�k/Null�z/Amegn�z]");
		return 1;
	}
	if(egyezik(pm, "megn�z") || egyezik(pm, "megnez"))
	{
		if(!PlayerToPoint(3, playerid, FrakcioInfo[melo][fPosX], FrakcioInfo[melo][fPosY], FrakcioInfo[melo][fPosZ])) return Msg(playerid, "Nem vagy a sz�f k�zel�ben.");
		SendClientMessage(playerid, COLOR_LIGHTBLUE, "===========[ Rakt�r Tartalma ]===========");
		SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Kaja: %ddb - Alma: %ddb", FrakcioInfo[melo][fKaja], FrakcioInfo[melo][fAlma]);
		SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Material: %sdb - Heroin: %sg", FormatNumber( FrakcioInfo[melo][fMati], 0, ',' ), FormatNumber( FrakcioInfo[melo][fHeroin], 0, ',' ));
		SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Kokain: %sg - Marihuana: %sg", FormatNumber( FrakcioInfo[melo][fKokain], 0, ',' ), FormatNumber( FrakcioInfo[melo][fMarihuana], 0, ',' ));
		SendFormatMessage(playerid, COLOR_LIGHTGREEN, "C4: %ddb", FrakcioInfo[melo][fC4]);
		SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Ruhat�r(1-10): %d,%d,%d,%d,%d,%d,%d,%d,%d,%d", FrakcioInfo[melo][fRuha][0],FrakcioInfo[melo][fRuha][1],FrakcioInfo[melo][fRuha][2],FrakcioInfo[melo][fRuha][3],FrakcioInfo[melo][fRuha][4],FrakcioInfo[melo][fRuha][5],FrakcioInfo[melo][fRuha][6],FrakcioInfo[melo][fRuha][7],FrakcioInfo[melo][fRuha][8],FrakcioInfo[melo][fRuha][9]);
		SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Ruhat�r(11-20): %d,%d,%d,%d,%d,%d,%d,%d,%d,%d", FrakcioInfo[melo][fRuha][10],FrakcioInfo[melo][fRuha][11],FrakcioInfo[melo][fRuha][12],FrakcioInfo[melo][fRuha][13],FrakcioInfo[melo][fRuha][14],FrakcioInfo[melo][fRuha][15],FrakcioInfo[melo][fRuha][16],FrakcioInfo[melo][fRuha][17],FrakcioInfo[melo][fRuha][18],FrakcioInfo[melo][fRuha][19]);
		SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Ruhat�r(21-30): %d,%d,%d,%d,%d,%d,%d,%d,%d,%d", FrakcioInfo[melo][fRuha][20],FrakcioInfo[melo][fRuha][21],FrakcioInfo[melo][fRuha][22],FrakcioInfo[melo][fRuha][23],FrakcioInfo[melo][fRuha][24],FrakcioInfo[melo][fRuha][25],FrakcioInfo[melo][fRuha][26],FrakcioInfo[melo][fRuha][27],FrakcioInfo[melo][fRuha][28],FrakcioInfo[melo][fRuha][29]);
		SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Ruhat�r(31-40): %d,%d,%d,%d,%d,%d,%d,%d,%d,%d", FrakcioInfo[melo][fRuha][30],FrakcioInfo[melo][fRuha][31],FrakcioInfo[melo][fRuha][32],FrakcioInfo[melo][fRuha][33],FrakcioInfo[melo][fRuha][34],FrakcioInfo[melo][fRuha][35],FrakcioInfo[melo][fRuha][36],FrakcioInfo[melo][fRuha][37],FrakcioInfo[melo][fRuha][38],FrakcioInfo[melo][fRuha][39]);
		SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Ruhat�r(41-50): %d,%d,%d,%d,%d,%d,%d,%d,%d,%d", FrakcioInfo[melo][fRuha][40],FrakcioInfo[melo][fRuha][41],FrakcioInfo[melo][fRuha][42],FrakcioInfo[melo][fRuha][43],FrakcioInfo[melo][fRuha][44],FrakcioInfo[melo][fRuha][45],FrakcioInfo[melo][fRuha][46],FrakcioInfo[melo][fRuha][47],FrakcioInfo[melo][fRuha][48],FrakcioInfo[melo][fRuha][49]);
		Cselekves(playerid, "megn�zte a rakt�rat...", 1);
	}
	elseif(egyezik(pm, "amegn�z") || egyezik(pm, "amegnez"))
	{
		if(!Admin(playerid, 1337) && !IsScripter(playerid)) return 1;
		if(sscanf(subpm, "d", fkid)) return SendClientMessage(playerid, COLOR_LIGHTRED, "ClassRPG: /rakt�r amegn�z [Frakci�ID]");
		SendClientMessage(playerid, COLOR_LIGHTBLUE, "===========[ Rakt�r Tartalma ]===========");
		SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Kaja: %ddb - Alma: %ddb", FrakcioInfo[fkid][fKaja], FrakcioInfo[fkid][fAlma]);
		SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Material: %sdb - Heroin: %sg", FormatNumber( FrakcioInfo[fkid][fMati], 0, ',' ), FormatNumber( FrakcioInfo[fkid][fHeroin], 0, ',' ));
		SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Kokain: %sg - Marihuana: %sg", FormatNumber( FrakcioInfo[fkid][fKokain], 0, ',' ), FormatNumber( FrakcioInfo[fkid][fMarihuana], 0, ',' ));
		SendFormatMessage(playerid, COLOR_LIGHTGREEN, "C4: %ddb", FrakcioInfo[fkid][fC4]);
		SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Ruhat�r(1-10): %d,%d,%d,%d,%d,%d,%d,%d,%d,%d", FrakcioInfo[fkid][fRuha][0],FrakcioInfo[fkid][fRuha][1],FrakcioInfo[fkid][fRuha][2],FrakcioInfo[fkid][fRuha][3],FrakcioInfo[fkid][fRuha][4],FrakcioInfo[fkid][fRuha][5],FrakcioInfo[fkid][fRuha][6],FrakcioInfo[fkid][fRuha][7],FrakcioInfo[fkid][fRuha][8],FrakcioInfo[fkid][fRuha][9]);
		SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Ruhat�r(11-20): %d,%d,%d,%d,%d,%d,%d,%d,%d,%d", FrakcioInfo[fkid][fRuha][10],FrakcioInfo[fkid][fRuha][11],FrakcioInfo[fkid][fRuha][12],FrakcioInfo[fkid][fRuha][13],FrakcioInfo[fkid][fRuha][14],FrakcioInfo[fkid][fRuha][15],FrakcioInfo[fkid][fRuha][16],FrakcioInfo[fkid][fRuha][17],FrakcioInfo[fkid][fRuha][18],FrakcioInfo[fkid][fRuha][19]);
		SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Ruhat�r(21-30): %d,%d,%d,%d,%d,%d,%d,%d,%d,%d", FrakcioInfo[fkid][fRuha][20],FrakcioInfo[fkid][fRuha][21],FrakcioInfo[fkid][fRuha][22],FrakcioInfo[fkid][fRuha][23],FrakcioInfo[fkid][fRuha][24],FrakcioInfo[fkid][fRuha][25],FrakcioInfo[fkid][fRuha][26],FrakcioInfo[fkid][fRuha][27],FrakcioInfo[fkid][fRuha][28],FrakcioInfo[fkid][fRuha][29]);
		SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Ruhat�r(31-40): %d,%d,%d,%d,%d,%d,%d,%d,%d,%d", FrakcioInfo[fkid][fRuha][30],FrakcioInfo[fkid][fRuha][31],FrakcioInfo[fkid][fRuha][32],FrakcioInfo[fkid][fRuha][33],FrakcioInfo[fkid][fRuha][34],FrakcioInfo[fkid][fRuha][35],FrakcioInfo[fkid][fRuha][36],FrakcioInfo[fkid][fRuha][37],FrakcioInfo[fkid][fRuha][38],FrakcioInfo[fkid][fRuha][39]);
		SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Ruhat�r(41-50): %d,%d,%d,%d,%d,%d,%d,%d,%d,%d", FrakcioInfo[fkid][fRuha][40],FrakcioInfo[fkid][fRuha][41],FrakcioInfo[fkid][fRuha][42],FrakcioInfo[fkid][fRuha][43],FrakcioInfo[fkid][fRuha][44],FrakcioInfo[fkid][fRuha][45],FrakcioInfo[fkid][fRuha][46],FrakcioInfo[fkid][fRuha][47],FrakcioInfo[fkid][fRuha][48],FrakcioInfo[fkid][fRuha][49]);
		SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Frakci�: %d | Neve: %s", fkid, Szervezetneve[fkid-1][1]);
	}
	elseif(egyezik(pm, "berak"))
	{
		if(!PlayerToPoint(3, playerid, FrakcioInfo[melo][fPosX], FrakcioInfo[melo][fPosY], FrakcioInfo[melo][fPosZ])) return Msg(playerid, "Nem vagy a sz�f k�zel�ben.");
		if(sscanf(subpm, "s[32]S()[64]", mit, subby)) return Msg(playerid, "/rakt�r berak [Kaja/Alma/Mati/Heroin/Marihuana/Kokain/Ruha/C4] [Mennyit/Rakt�rID]");
		new mati = PlayerInfo[playerid][pMats];
		new heroin = PlayerInfo[playerid][pHeroin];
		new kokain = PlayerInfo[playerid][pKokain];
		new marihuana = PlayerInfo[playerid][pMarihuana];
		new kaja = PlayerInfo[playerid][pKaja];
		new alma = PlayerInfo[playerid][pAlma];
		if(egyezik(mit, "kaja"))
		{
			if(sscanf(subby, "d", mennyit)) return Msg(playerid, "/rakt�r berak kaja [mennyit]");
			if(mennyit < 1) return Msg(playerid, "Legal�bb egy darabot rakj be.");
			if(kaja < mennyit) return Msg(playerid, "Nincs el�g kaj�d.");
			PlayerInfo[playerid][pKaja] -= mennyit;
			FrakcioInfo[melo][fKaja] += mennyit;
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Berakt�l %ddb kaj�t a rakt�rba.", mennyit);
			format(szeflog, 256, "[%d. frakci� (%s)]%s berakott a rakt�rba %d db kaj�t",melo, Szervezetneve[melo - 1][2],PlayerName(playerid), mennyit); Log("Szef", szeflog);
		}
		elseif(egyezik(mit, "alma"))
		{
			if(sscanf(subby, "d", mennyit)) return Msg(playerid, "/rakt�r berak alma [mennyit]");
			if(mennyit < 1) return Msg(playerid, "Legal�bb egy darabot rakj be.");
			if(alma < mennyit) return Msg(playerid, "Nincs el�g alm�d.");
			PlayerInfo[playerid][pAlma] -= mennyit;
			FrakcioInfo[melo][fAlma] += mennyit;
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Berakt�l %ddb alm�t a rakt�rba.", mennyit);
			format(szeflog, 256, "[%d. frakci� (%s)]%s berakott a rakt�rba %d db alm�t",melo, Szervezetneve[melo - 1][2],PlayerName(playerid), mennyit); Log("Szef", szeflog);
		}
		elseif(egyezik(mit, "mati") || egyezik(mit, "material"))
		{
			if(hour == 4) return Msg(playerid, "A rendszer vissza�l�sek miatt letiltotta a berak�st");
			if(sscanf(subby, "d", mennyit)) return Msg(playerid, "/rakt�r berak mati [mennyit]");
			if(mennyit < 1) return Msg(playerid, "Legal�bb egy darabot rakj be.");
			if(mati < mennyit) return Msg(playerid, "Nincs el�g matid.");
			PlayerInfo[playerid][pMats] -= mennyit;
			FrakcioInfo[melo][fMati] += mennyit;
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Berakt�l %ddb matit a rakt�rba.", mennyit);
			format(szeflog, 256, "[%d. frakci� (%s)]%s berakott a rakt�rba %d db matit",melo, Szervezetneve[melo - 1][2],PlayerName(playerid), mennyit); Log("Szef", szeflog);
		}
		elseif(egyezik(mit, "heroin"))
		{
			if(hour == 4) return Msg(playerid, "A rendszer vissza�l�sek miatt letiltotta a berak�st");
			if(sscanf(subby, "d", mennyit)) return Msg(playerid, "/rakt�r berak heroin [mennyit]");
			if(mennyit < 1) return Msg(playerid, "Legal�bb egy darabot rakj be.");
			if(heroin < mennyit) return Msg(playerid, "Nincs el�g heroinod.");
			PlayerInfo[playerid][pHeroin] -= mennyit;
			FrakcioInfo[melo][fHeroin] += mennyit;
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Berakt�l %dg heroint a rakt�rba.", mennyit);
			format(szeflog, 256, "[%d. frakci� (%s)]%s berakott a rakt�rba %d db heroint",melo, Szervezetneve[melo - 1][2],PlayerName(playerid), mennyit); Log("Szef", szeflog);
		}
		elseif(egyezik(mit, "kokain"))
		{
			if(hour == 4) return Msg(playerid, "A rendszer vissza�l�sek miatt letiltotta a berak�st");
			if(sscanf(subby, "d", mennyit)) return Msg(playerid, "/rakt�r berak kokain [mennyit]");
			if(mennyit < 1) return Msg(playerid, "Legal�bb egy darabot rakj be.");
			if(kokain < mennyit) return Msg(playerid, "Nincs el�g kokainod.");
			PlayerInfo[playerid][pKokain] -= mennyit;
			FrakcioInfo[melo][fKokain] += mennyit;
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Berakt�l %dg kokaint a rakt�rba.", mennyit);
			format(szeflog, 256, "[%d. frakci� (%s)]%s berakott a rakt�rba %d db kokaint",melo, Szervezetneve[melo - 1][2],PlayerName(playerid), mennyit); Log("Szef", szeflog);
		}
		elseif(egyezik(mit, "marihuana"))
		{
			if(hour == 4) return Msg(playerid, "A rendszer vissza�l�sek miatt letiltotta a berak�st");
			if(sscanf(subby, "d", mennyit)) return Msg(playerid, "/rakt�r berak marihuana [mennyit]");
			if(mennyit < 1) return Msg(playerid, "Legal�bb egy darabot rakj be.");
			if(marihuana < mennyit) return Msg(playerid, "Nincs el�g marihuan�d.");
			PlayerInfo[playerid][pMarihuana] -= mennyit;
			FrakcioInfo[melo][fMarihuana] += mennyit;
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Berakt�l %dg marihuan�t a rakt�rba.", mennyit);
			format(szeflog, 256, "[%d. frakci� (%s)]%s berakott a rakt�rba %d db marihuan�t",melo, Szervezetneve[melo - 1][2],PlayerName(playerid), mennyit); Log("Szef", szeflog);
		}
		elseif(egyezik(mit, "ruha"))
		{
			if(sscanf(subby, "d", mennyit)) return Msg(playerid, "/rakt�r berak ruha [slot]");
			if(GetPlayerSkin(playerid) == 252) return Msg(playerid, "M�g az als�gaty�dat is a rakt�rba akarod rakni?..");
			if(mennyit < 0 || mennyit > 49) return Msg(playerid, "0-49");
			if(FrakcioInfo[melo][fRuha][mennyit] != 252 && FrakcioInfo[melo][fRuha][mennyit] != 0) return Msg(playerid, "Ezen a sloton m�r van valami!");
			FrakcioInfo[melo][fRuha][mennyit] = GetPlayerSkin(playerid);
			SetPlayerSkin(playerid, 252);
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Beraktad a ruh�dat a rakt�rba (slot: %d).", mennyit);
			format(szeflog, 256, "[%d. frakci� (%s)]%s berakott a rakt�rba a %d skint, a %d slotra", melo, Szervezetneve[melo - 1][2],PlayerName(playerid), FrakcioInfo[melo][fRuha][mennyit], mennyit); Log("Szef", szeflog);
		}
		elseif(egyezik(mit, "C4"))
		{
			if(PlayerInfo[playerid][pC4] == 0) return Msg(playerid, "Nincs C4 n�lad.");
			PlayerInfo[playerid][pC4] --;
			FrakcioInfo[melo][fC4] ++;
			SendClientMessage(playerid, COLOR_LIGHTGREEN, "* Berakt�l 1 darab C4 robban�szert a rakt�rba.");
			format(szeflog, 256, "[%d. frakci� (%s)]%s berakott a rakt�rba 1db C4-t", melo, Szervezetneve[melo - 1][2],PlayerName(playerid)); Log("Szef", szeflog);
		}
		INI_Save(INI_TYPE_FRAKCIO, melo);
	}
	elseif(egyezik(pm, "kivesz"))
	{
		if(!PlayerToPoint(3, playerid, FrakcioInfo[melo][fPosX], FrakcioInfo[melo][fPosY], FrakcioInfo[melo][fPosZ])) return Msg(playerid, "Nem vagy a sz�f k�zel�ben.");
		if(PlayerInfo[playerid][pRank] < FrakcioInfo[melo][fRaktarRang]) return SendFormatMessage(playerid, COLOR_LIGHTRED, "ClassRPG: Nem el�g nagy a rangod, minimum rang: %d", FrakcioInfo[melo][fRaktarRang]);
		if(sscanf(subpm, "s[32]S()[64]", mit, subby)) return Msg(playerid, "/rakt�r kivesz [Kaja/Alma/Mati/Heroin/Marihuana/Kokain/Ruha/C4] [Mennyit/Rakt�rID]");
		new mati = FrakcioInfo[melo][fMati];
		new heroin = FrakcioInfo[melo][fHeroin];
		new kokain = FrakcioInfo[melo][fKokain];
		new marihuana = FrakcioInfo[melo][fMarihuana];
		new kaja = FrakcioInfo[melo][fKaja];
		new alma = FrakcioInfo[melo][fAlma];
		new c4 = FrakcioInfo[melo][fC4];
		if(egyezik(mit, "kaja"))
		{
			if(sscanf(subby, "d", mennyit)) return Msg(playerid, "/rakt�r kivesz kaja [mennyit]");
			if(mennyit < 1) return Msg(playerid, "Legal�bb egy darabot vegy�l ki.");
			if(kaja < mennyit) return Msg(playerid, "Nincs el�g kaja a sz�fben.");
			if((PlayerInfo[playerid][pKaja] + mennyit) > MAXKAJA) return Msg(playerid, "Ennyi nem f�r el n�lad.");
			PlayerInfo[playerid][pKaja] += mennyit;
			FrakcioInfo[melo][fKaja] -= mennyit;
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Kivett�l %ddb kaj�t a rakt�rb�l.", mennyit);
			format(szeflog, 256, "[%d. frakci� (%s)]%s kivett a rakt�rb�l %d db kaj�t",melo, Szervezetneve[melo - 1][2],PlayerName(playerid), mennyit); Log("Szef", szeflog);
		}
		elseif(egyezik(mit, "alma"))
		{
			if(sscanf(subby, "d", mennyit)) return Msg(playerid, "/rakt�r kivesz alma [mennyit]");
			if(mennyit < 1) return Msg(playerid, "Legal�bb egy darabot vegy�l ki.");
			if(alma < mennyit) return Msg(playerid, "Nincs el�g alma a sz�fben.");
			if((PlayerInfo[playerid][pAlma] + mennyit) > MAXALMA) return Msg(playerid, "Ennyi nem f�r el n�lad.");
			PlayerInfo[playerid][pAlma] += mennyit;
			FrakcioInfo[melo][fAlma] -= mennyit;
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Kivett�l %ddb alm�t a rakt�rb�l.", mennyit);
			format(szeflog, 256, "[%d. frakci� (%s)]%s kivett a rakt�rb�l %d db alm�t",melo, Szervezetneve[melo - 1][2],PlayerName(playerid), mennyit); Log("Szef", szeflog);
		}
		elseif(egyezik(mit, "mati") || egyezik(mit, "material"))
		{
			if(hour == 3) return Msg(playerid, "A rendszer vissza�l�sek miatt letiltotta a kiv�telt");
			if(sscanf(subby, "d", mennyit)) return Msg(playerid, "/rakt�r kivesz mati [mennyit]");
			if(mennyit < 1) return Msg(playerid, "Legal�bb egy darabot vegy�l ki.");
			if(mati < mennyit) return Msg(playerid, "Nincs el�g mati a sz�fben.");
			if((PlayerInfo[playerid][pMats] + mennyit) > MAXMATI) return Msg(playerid, "Ennyi nem f�r el n�lad.");
			PlayerInfo[playerid][pMats] += mennyit;
			FrakcioInfo[melo][fMati] -= mennyit;
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Kivett�l %ddb matit a rakt�rb�l.", mennyit);
			format(szeflog, 256, "[%d. frakci� (%s)]%s kivett a rakt�rb�l %d db matit",melo, Szervezetneve[melo - 1][2],PlayerName(playerid), mennyit); Log("Szef", szeflog);
		}
		elseif(egyezik(mit, "heroin"))
		{
			if(hour == 3) return Msg(playerid, "A rendszer vissza�l�sek miatt letiltotta a kiv�telt");
			if(sscanf(subby, "d", mennyit)) return Msg(playerid, "/rakt�r kivesz heroin [mennyit]");
			if(mennyit < 1) return Msg(playerid, "Legal�bb egy darabot vegy�l ki.");
			if(heroin < mennyit) return Msg(playerid, "Nincs el�g heroin a sz�fben.");
			if((PlayerInfo[playerid][pHeroin] + mennyit) > MAXHEROIN) return Msg(playerid, "Ennyi nem f�r el n�lad.");
			PlayerInfo[playerid][pHeroin] += mennyit;
			FrakcioInfo[melo][fHeroin] -= mennyit;
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Kivett�l %dg heroint a rakt�rb�l.", mennyit);
			format(szeflog, 256, "[%d. frakci� (%s)]%s kivett a rakt�rb�l %d db heroint",melo, Szervezetneve[melo - 1][2],PlayerName(playerid), mennyit); Log("Szef", szeflog);
		}
		elseif(egyezik(mit, "kokain"))
		{
			if(hour == 3) return Msg(playerid, "A rendszer vissza�l�sek miatt letiltotta a kiv�telt");
			if(sscanf(subby, "d", mennyit)) return Msg(playerid, "/rakt�r kivesz kokain [mennyit]");
			if(mennyit < 1) return Msg(playerid, "Legal�bb egy darabot vegy�l ki.");
			if(kokain < mennyit) return Msg(playerid, "Nincs el�g kokain a sz�fben.");
			if((PlayerInfo[playerid][pKokain] + mennyit) > MAXKOKAIN) return Msg(playerid, "Ennyi nem f�r el n�lad.");
			PlayerInfo[playerid][pKokain] += mennyit;
			FrakcioInfo[melo][fKokain] -= mennyit;
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Kivett�l %ddb kokaint a rakt�rb�l.", mennyit);
			format(szeflog, 256, "[%d. frakci� (%s)]%s kivett a rakt�rb�l %d db kokaint",melo, Szervezetneve[melo - 1][2],PlayerName(playerid), mennyit); Log("Szef", szeflog);
		}
		elseif(egyezik(mit, "marihuana"))
		{
			if(hour == 3) return Msg(playerid, "A rendszer vissza�l�sek miatt letiltotta a kiv�telt");
			if(sscanf(subby, "d", mennyit)) return Msg(playerid, "/rakt�r kivesz marihuana [mennyit]");
			if(mennyit < 1) return Msg(playerid, "Legal�bb egy darabot vegy�l ki.");
			if(marihuana < mennyit) return Msg(playerid, "Nincs el�g marihuana a sz�fben.");
			if((PlayerInfo[playerid][pMarihuana] + mennyit) > MAXMARIHUANA) return Msg(playerid, "Ennyi nem f�r el n�lad.");
			PlayerInfo[playerid][pMarihuana] += mennyit;
			FrakcioInfo[melo][fMarihuana] -= mennyit;
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Kivett�l %ddb marihuan�t a rakt�rb�l.", mennyit);
			format(szeflog, 256, "[%d. frakci� (%s)]%s kivett a rakt�rb�l %d db marihuanat",melo, Szervezetneve[melo - 1][2],PlayerName(playerid), mennyit); Log("Szef", szeflog);
		}
		elseif(egyezik(mit, "ruha"))
		{
			if(sscanf(subby, "d", mennyit)) return Msg(playerid, "/rakt�r kivesz ruha [slot]");
			if(GetPlayerSkin(playerid) != 252) return Msg(playerid, "M�r fel vagy �lt�zve!");
			if(mennyit < 0 || mennyit > 49) return Msg(playerid, "0-50");
			if(FrakcioInfo[melo][fRuha][mennyit] == 252) return Msg(playerid, "Ezen a slot �res!");
			SetPlayerSkin(playerid, FrakcioInfo[melo][fRuha][mennyit]);
			FrakcioInfo[melo][fRuha][mennyit] = 252;
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Beraktad a ruh�dat a rakt�rb�l (slot: %d).", mennyit);
			format(szeflog, 256, "[%d. frakci� (%s)]%s kivett a rakt�rb�l a %d skint, a %d slotr�l", melo, Szervezetneve[melo - 1][2],PlayerName(playerid), FrakcioInfo[melo][fRuha][mennyit], mennyit); Log("Szef", szeflog);
		}
		elseif(egyezik(mit, "C4"))
		{
			if(c4 < 1) return Msg(playerid, "Nincs C4 a sz�fben!");
			if(PlayerInfo[playerid][pC4] == 1) return Msg(playerid, "M�r van n�lad C4!");
			PlayerInfo[playerid][pC4] = 1;
			FrakcioInfo[melo][fC4]--;
			SendClientMessage(playerid, COLOR_LIGHTGREEN, "* Kivett�l 1db C4 robban�szert a rakt�rb�l.");
			format(szeflog, 256, "[%d. frakci� (%s)]%s kivett a rakt�rb�l 1db C4-et", melo, Szervezetneve[melo - 1][2],PlayerName(playerid)); Log("Szef", szeflog);
		}
		INI_Save(INI_TYPE_FRAKCIO, melo);
	}
	elseif(egyezik(pm, "minrang"))
	{
		if(PlayerInfo[playerid][pLeader] == 0) return Msg(playerid, "Kiz�r�lag Leadernek!");
		if(sscanf(subpm, "d", mennyit))
		{
			SendFormatMessage(playerid, COLOR_LIGHTRED, "/rakt�r minrang [0-%d]", OsszRang[PlayerInfo[playerid][pLeader]]);
			SendFormatMessage(playerid, COLOR_LIGHTRED, "Jelenlegi sz�ks�ges rang: %d", FrakcioInfo[melo][fRaktarRang]);
			return 1;
		}
		if(mennyit < 0 || mennyit > OsszRang[PlayerInfo[playerid][pLeader]]) return SendFormatMessage(playerid, COLOR_LIGHTRED, "ClassRPG: 0-%d", OsszRang[PlayerInfo[playerid][pLeader]]);
		format(szeflog, 256, "[%d. frakci� (%s) - info]%s �t�rta a rakt�rnak min. rangj�t err�l: %d, erre: %d", melo, Szervezetneve[melo - 1][2],PlayerName(playerid), FrakcioInfo[melo][fRaktarRang], mennyit); Log("Szef", szeflog);

		FrakcioInfo[melo][fRaktarRang] = mennyit;
		SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* A rakt�rb�l mostant�l %d rangt�l lehet kivenni.", mennyit);
		INI_Save(INI_TYPE_FRAKCIO, melo);
	}
	elseif(egyezik(pm, "�rt�k") || egyezik(pm, "ertek"))
	{
		if(!Admin(playerid, 1337) && !IsScripter(playerid)) return 1;
		if(sscanf(subpm, "ds[32]d", fkid, mit, mennyit))
		{
			SendClientMessage(playerid, COLOR_LIGHTRED, "/rakt�r �rt�k [Frakci�ID] [Mit] [Mennyire]");
			SendClientMessage(playerid, COLOR_LIGHTRED, "Param�terek: Kaja, Alma, Mati, Heroin, Marihuana, Kokain, C4");
			return 1;
		}
		if(mennyit < 0) return Msg(playerid, "M�nuszt?");
		new mati = FrakcioInfo[fkid][fMati];
		new heroin = FrakcioInfo[fkid][fHeroin];
		new kokain = FrakcioInfo[fkid][fKokain];
		new marihuana = FrakcioInfo[fkid][fMarihuana];
		new kaja = FrakcioInfo[fkid][fKaja];
		new alma = FrakcioInfo[fkid][fAlma];
		new c4 = FrakcioInfo[fkid][fC4];
		if(egyezik(mit, "material") || egyezik(mit, "mati"))
		{
			
			format(_tmpString,sizeof(_tmpString),"<< %s be�ll�totta a(z) (%d)%s frakci� sz�f�nek tartalm�t! Adat: Mati | �j: %s | R�gi: %s >>", PlayerName(playerid), fkid, Szervezetneve[fkid-1][1], FormatNumber( mennyit, 0, ',' ), FormatNumber( mati, 0, ',' ));
			SendMessage(SEND_MESSAGE_ADMIN,_tmpString,COLOR_LIGHTRED,PlayerInfo[playerid][pAdmin]);
			
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Sz�f tartalma be�ll�tva: %sdb Mati | R�gi: %s", FormatNumber( mennyit, 0, ',' ), FormatNumber(mati, 0, ','));
			format(szeflog, 256, "%s be�ll�totta a %d. frakci� (%s) rakt�r�nak materialtartalm�t err�l: %s erre: %s", PlayerName(playerid), fkid, Szervezetneve[fkid-1][2], mati, mennyit), Log("Szef", szeflog);
			FrakcioInfo[fkid][fMati] = mennyit;
		}
		elseif(egyezik(mit, "heroin"))
		{
			format(_tmpString,sizeof(_tmpString),"<< %s be�ll�totta a(z) (%d)%s frakci� sz�f�nek tartalm�t! Adat: Heroin | �j: %s | R�gi: %s >>", PlayerName(playerid), fkid, Szervezetneve[fkid-1][1], FormatNumber( mennyit, 0, ',' ), FormatNumber( heroin, 0, ',' ));
			
			SendMessage(SEND_MESSAGE_ADMIN,_tmpString,COLOR_LIGHTRED,PlayerInfo[playerid][pAdmin]);
			
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Sz�f tartalma be�ll�tva: %sg Heroin | R�gi: %s", FormatNumber( mennyit, 0, ',' ), FormatNumber( heroin, 0, ',' ));
			format(szeflog, 256, "%s be�ll�totta a %d. frakci� (%s) rakt�r�nak herointartalm�t err�l: %s erre: %s", PlayerName(playerid), fkid, Szervezetneve[fkid-1][2], heroin, mennyit), Log("Szef", szeflog);
			FrakcioInfo[fkid][fHeroin] = mennyit;
		}
		elseif(egyezik(mit, "kokain"))
		{
			
			format(_tmpString,sizeof(_tmpString),"<< %s be�ll�totta a(z) (%d)%s frakci� sz�f�nek tartalm�t! Adat: Kokain | �j: %s | R�gi: %s  >>", PlayerName(playerid), fkid, Szervezetneve[fkid-1][1], FormatNumber( mennyit, 0, ',' ), FormatNumber( kokain, 0, ',' ));
			
			SendMessage(SEND_MESSAGE_ADMIN,_tmpString,COLOR_LIGHTRED,PlayerInfo[playerid][pAdmin]);
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Sz�f tartalma be�ll�tva: %sg Kokain | R�gi: %s", FormatNumber( mennyit, 0, ',' ), FormatNumber( kokain, 0, ',' ));
			format(szeflog, 256, "%s be�ll�totta a %d. frakci� (%s) rakt�r�nak kokaintartalm�t err�l: %s erre: %s", PlayerName(playerid), fkid, Szervezetneve[fkid-1][2], kokain, mennyit), Log("Szef", szeflog);
			FrakcioInfo[fkid][fKokain] = mennyit;
		}
		elseif(egyezik(mit, "marihuana"))
		{
			format(_tmpString,sizeof(_tmpString),"<< %s be�ll�totta a(z) (%d)%s frakci� sz�f�nek tartalm�t! Adat: Marihuana | �j: %s | R�gi: %s >>", PlayerName(playerid), fkid, Szervezetneve[fkid-1][1], FormatNumber( mennyit, 0, ',' ), FormatNumber( marihuana, 0, ','));
		
			SendMessage(SEND_MESSAGE_ADMIN,_tmpString,COLOR_LIGHTRED,PlayerInfo[playerid][pAdmin]);
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Sz�f tartalma be�ll�tva: %sg Marihuana | R�gi: %s", FormatNumber( mennyit, 0, ',' ), FormatNumber( marihuana, 0, ',' ));
			format(szeflog, 256, "%s be�ll�totta a %d. frakci� (%s) rakt�r�nak marihuanatartalm�t err�l: %s erre: %s", PlayerName(playerid), fkid, Szervezetneve[fkid-1][2], marihuana, mennyit), Log("Szef", szeflog);
			FrakcioInfo[fkid][fMarihuana] = mennyit;
		}
		elseif(egyezik(mit, "kaja"))
		{
			format(_tmpString,sizeof(_tmpString),"<< %s be�ll�totta a(z) (%d)%s frakci� sz�f�nek tartalm�t! Adat: Kaja | �j: %s | R�gi: %s >>", PlayerName(playerid), fkid, Szervezetneve[fkid-1][1], FormatNumber( mennyit, 0, ',' ), FormatNumber( kaja, 0, ',' ));
			
			SendMessage(SEND_MESSAGE_ADMIN,_tmpString,COLOR_LIGHTRED,PlayerInfo[playerid][pAdmin]);
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Sz�f tartalma be�ll�tva: %sdb Kaja | R�gi: %s", FormatNumber( mennyit, 0, ',' ), FormatNumber( mennyit, 0, ',' ), FormatNumber( kaja, 0, ',' ));
			format(szeflog, 256, "%s be�ll�totta a %d. frakci� (%s) rakt�r�nak kajatartalm�t err�l: %s erre: %s", PlayerName(playerid), fkid, Szervezetneve[fkid-1][2], kaja, mennyit), Log("Szef", szeflog);
			FrakcioInfo[fkid][fKaja] = mennyit;
		}
		elseif(egyezik(mit, "alma"))
		{
			format(_tmpString,sizeof(_tmpString),"<< %s be�ll�totta a(z) (%d)%s frakci� sz�f�nek tartalm�t! Adat: Alma | �j: %s | R�gi: %s >>", PlayerName(playerid), fkid, Szervezetneve[fkid-1][1], FormatNumber( mennyit, 0, ',' ),  FormatNumber( alma, 0, ',' ));
	
			SendMessage(SEND_MESSAGE_ADMIN,_tmpString,COLOR_LIGHTRED,PlayerInfo[playerid][pAdmin]);
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Sz�f tartalma be�ll�tva: %sdb Alma | R�gi: %s", FormatNumber( mennyit, 0, ',' ), FormatNumber( alma, 0, ',' ));
			format(szeflog, 256, "%s be�ll�totta a %d. frakci� (%s) rakt�r�nak almatartalm�t err�l: %s erre: %s", PlayerName(playerid), fkid, Szervezetneve[fkid-1][2], alma, mennyit), Log("Szef", szeflog);
			FrakcioInfo[fkid][fAlma] = mennyit;
		}
		elseif(egyezik(mit, "C4"))
		{
			format(_tmpString,sizeof(_tmpString),"<< %s be�ll�totta a(z) (%d)%s frakci� sz�f�nek tartalm�t! Adat: C4 | �j: %s | R�gi: %s >>", PlayerName(playerid), fkid, Szervezetneve[fkid-1][1], FormatNumber( mennyit, 0, ',' ),  FormatNumber( c4, 0, ',' ));
			
			SendMessage(SEND_MESSAGE_ADMIN,_tmpString,COLOR_LIGHTRED,PlayerInfo[playerid][pAdmin]);
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Sz�f tartalma be�ll�tva: %sdb C4 | R�gi: %s", FormatNumber( mennyit, 0, ',' ), FormatNumber( c4, 0, ',' ));
			format(szeflog, 256, "%s be�ll�totta a %d. frakci� (%s) rakt�r�nak C4 tartalm�t err�l: %s erre: %s", PlayerName(playerid), fkid, Szervezetneve[fkid-1][2], c4, mennyit), Log("Szef", szeflog);
			FrakcioInfo[fkid][fC4] = mennyit;
		}
		INI_Save(INI_TYPE_FRAKCIO, fkid);
	}
	elseif(egyezik(pm, "null�z") || egyezik(pm, "nullaz"))
	{
		if(!Admin(playerid, 1337) && !IsScripter(playerid)) return 1;
		if(sscanf(subpm, "ds[32]", mit))
		{
			SendClientMessage(playerid, COLOR_LIGHTRED, "/rakt�r null�z [Frakci�ID] [Mit]");
			SendClientMessage(playerid, COLOR_LIGHTRED, "Param�terek: Kaja, Alma, Mati, Heroin, Marihuana, Kokain, C4");
			return 1;
		}
		if(mennyit < 0) return Msg(playerid, "M�nuszt?");
		new mati = FrakcioInfo[fkid][fMati];
		new heroin = FrakcioInfo[fkid][fHeroin];
		new kokain = FrakcioInfo[fkid][fKokain];
		new marihuana = FrakcioInfo[fkid][fMarihuana];
		new kaja = FrakcioInfo[fkid][fKaja];
		new alma = FrakcioInfo[fkid][fAlma];
		new c4 = FrakcioInfo[fkid][fC4];
		if(egyezik(mit, "material") || egyezik(mit, "mati"))
		{
			ABroadCastFormat(COLOR_LIGHTRED, PlayerInfo[playerid][pAdmin], "<< %s %s null�zta a(z) (%d)%s frakci� rakt�r�nak tartalm�t! Adat: Mati | R�gi: %s >>",AdminRangNev(playerid), PlayerName(playerid), fkid, Szervezetneve[fkid-1][1], FormatNumber( mati, 0, ',' ));
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Rakt�r tartalma (Material) null�zva | R�gi: %s", FormatNumber( mati, 0, ',' ));
			format(szeflog, 256, "%s null�zta a %d. frakci� (%s) rakt�r�nak materialtartalm�t - eredeti mennyis�g: %s", PlayerName(playerid), fkid, Szervezetneve[fkid-1][2], mati), Log("Szef", szeflog);
			FrakcioInfo[fkid][fMati] = 0;
		}
		elseif(egyezik(mit, "heroin"))
		{
			ABroadCastFormat(COLOR_LIGHTRED, PlayerInfo[playerid][pAdmin], "<< %s %s null�zta a(z) (%d)%s frakci� rakt�r�nak tartalm�t! Adat: Heroin | R�gi: %s >>",AdminRangNev(playerid), PlayerName(playerid), fkid, Szervezetneve[fkid-1][1], FormatNumber( heroin, 0, ',' ));
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Rakt�r tartalma (Heroin) null�zva | R�gi: %s", FormatNumber( heroin, 0, ',' ));
			format(szeflog, 256, "%s null�zta a %d. frakci� (%s) rakt�r�nak herointartalm�t - eredeti mennyis�g: %s", PlayerName(playerid), fkid, Szervezetneve[fkid-1][2], heroin), Log("Szef", szeflog);
			FrakcioInfo[fkid][fHeroin] = 0;
		}
		elseif(egyezik(mit, "kokain"))
		{
			ABroadCastFormat(COLOR_LIGHTRED, PlayerInfo[playerid][pAdmin], "<< %s %s null�zta a(z) (%d)%s frakci� rakt�r�nak tartalm�t! Adat: Kokain | R�gi: %s >>",AdminRangNev(playerid), PlayerName(playerid), fkid, Szervezetneve[fkid-1][1], FormatNumber( kokain, 0, ',' ));
			
			
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Rakt�r tartalma (Kokain) null�zva | R�gi: %s", FormatNumber( kokain, 0, ',' ));
			format(szeflog, 256, "%s null�zta a %d. frakci� (%s) rakt�r�nak kokaintartalm�t - eredeti mennyis�g: %s", PlayerName(playerid), fkid, Szervezetneve[fkid-1][2], kokain), Log("Szef", szeflog);
			FrakcioInfo[fkid][fKokain] = 0;
		}
		elseif(egyezik(mit, "marihuana"))
		{
			ABroadCastFormat(COLOR_LIGHTRED, PlayerInfo[playerid][pAdmin], "<< %s %s null�zta a(z) (%d)%s frakci� rakt�r�nak tartalm�t! Adat: Marihuana | R�gi: %s >>",AdminRangNev(playerid), PlayerName(playerid), fkid, Szervezetneve[fkid-1][1], FormatNumber( marihuana, 0, ',' ));
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Rakt�r tartalma (Marihuana) null�zva | R�gi: %s", FormatNumber( marihuana, 0, ',' ));
			format(szeflog, 256, "%s null�zta a %d. frakci� (%s) rakt�r�nak marihuanatartalm�t - eredeti mennyis�g: %s", PlayerName(playerid), fkid, Szervezetneve[fkid-1][2], marihuana), Log("Szef", szeflog);
			FrakcioInfo[fkid][fMarihuana] = 0;
		}
		elseif(egyezik(mit, "kaja"))
		{
			ABroadCastFormat(COLOR_LIGHTRED, PlayerInfo[playerid][pAdmin], "<< %s %s null�zta a(z) (%d)%s frakci� rakt�r�nak tartalm�t! Adat: Kaja | R�gi: %s >>",AdminRangNev(playerid), PlayerName(playerid), fkid, Szervezetneve[fkid-1][1], FormatNumber( kaja, 0, ',' ));
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Rakt�r tartalma (Kaja) null�zva | R�gi: %s", FormatNumber( kaja, 0, ',' ));
			format(szeflog, 256, "%s null�zta a %d. frakci� (%s) rakt�r�nak kajatartalm�t - eredeti mennyis�g: %s", PlayerName(playerid), fkid, Szervezetneve[fkid-1][2], kaja), Log("Szef", szeflog);
			FrakcioInfo[fkid][fKaja] = 0;
		}
		elseif(egyezik(mit, "alma"))
		{
			ABroadCastFormat(COLOR_LIGHTRED, PlayerInfo[playerid][pAdmin], "<< %s %s null�zta a(z) (%d)%s frakci� rakt�r�nak tartalm�t! Adat: Alma | R�gi: %s >>",AdminRangNev(playerid), PlayerName(playerid), fkid, Szervezetneve[fkid-1][1], FormatNumber( alma, 0, ',' ));
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Rakt�r tartalma (Alma) null�zva | R�gi: %s", FormatNumber( alma, 0, ',' ));
			format(szeflog, 256, "%s null�zta a %d. frakci� (%s) rakt�r�nak materialtartalm�t - eredeti mennyis�g: %s", PlayerName(playerid), fkid, Szervezetneve[fkid-1][2], alma), Log("Szef", szeflog);
			FrakcioInfo[fkid][fAlma] = 0;
		}
		elseif(egyezik(mit, "ruha"))
		{
			for(new s = 0; s < 49; s++) if(FrakcioInfo[fkid][fRuha][s] != 0) FrakcioInfo[fkid][fRuha][s] = 0;
			ABroadCastFormat(COLOR_LIGHTRED, PlayerInfo[playerid][pAdmin], "<< %s %s null�zta a(z) (%d)%s frakci� rakt�r�nak tartalm�t! Adat: Ruha >>",AdminRangNev(playerid), PlayerName(playerid), fkid, Szervezetneve[fkid-1][1]);
			SendClientMessage(playerid, COLOR_LIGHTGREEN, "* Rakt�r tartalma (Ruha) null�zva");
			format(szeflog, 256, "%s null�zta a %d. frakci� (%s) rakt�r�nak ruhatartalm�t", PlayerName(playerid), fkid, Szervezetneve[fkid-1][2]), Log("Szef", szeflog);
		}
		elseif(egyezik(mit, "c4"))
		{
			ABroadCastFormat(COLOR_LIGHTRED, PlayerInfo[playerid][pAdmin], "<< %s %s null�zta a(z) (%d)%s frakci� rakt�r�nak tartalm�t! Adat: C4 | R�gi: %s >>",AdminRangNev(playerid), PlayerName(playerid), fkid, Szervezetneve[fkid-1][1], FormatNumber( c4, 0, ',' ));
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Rakt�r tartalma (C4) null�zva | R�gi: %s", FormatNumber( c4, 0, ',' ));
			format(szeflog, 256, "%s null�zta a %d. frakci� (%s) rakt�r�nak materialtartalm�t - eredeti mennyis�g: %d", PlayerName(playerid), fkid, Szervezetneve[fkid-1][2], c4), Log("Szef", szeflog);
			FrakcioInfo[fkid][fC4] = 0;
		}
		INI_Save(INI_TYPE_FRAKCIO, fkid);
	}
	return 1;
}

ALIAS(k5zmunka):kozmunka;
CMD:kozmunka(playerid, params[])
{
	if(PInfo(playerid,Jailed) != 14) return Msg(playerid, "Nem a fegyenctelepen vagy elhelyezve, ez�rt nem k�rhetsz k�zmunk�s enyh�t�st!");
	if(JailTime[playerid] >= 1200) return Msg(playerid, "Nem k�rhetsz k�zmunk�t, mivel 20 �vet ((percet)) vagy ann�l t�bbet kell le�ln�d!");
	if(PInfo(playerid,JailTime) > 900) return Msg(playerid, "A b�ntet�sed m�g t�bb, mint 15 �v ((perc))!");
	if(PInfo(playerid,Kozmunka) != 0) return Msg(playerid, "Te m�r k�rv�nyezt�l valamilyen k�zmunk�t!");
	new munka[32];
	if(sscanf(params, "s[32]", munka)) return Msg(playerid, "/k�zmunka [F�ny�r�s/�ttiszt�t�s]");
	new Float:yay[3];
	if(egyezik(munka, "f�ny�r�s") || egyezik(munka, "funyiras"))
	{
		CopMsgFormat(COLOR_ALLDEPT, "[Fegyenctelep] Figyelem: %s k�zmunk�s enyh�t�st k�rt", ICPlayerName(playerid));
		CopMsgFormat(COLOR_ALLDEPT, "[Fegyenctelep] ezt a v�dat enyh�ti: %s - ezzel enyh�ti a v�dat: f�ny�r�s", PlayerInfo[playerid][pJailOK]);
		SendClientMessage(playerid, COLOR_LIGHTBLUE, "* Menj egy f�ny�r� traktorhoz, �lj r�, �s a /f�ny�r�s paranccsal kezdd el ledolgozni az id�det.");
		SendClientMessage(playerid, COLOR_LIGHTBLUE, "* Figyelem: A k�zmunka let�lt�s�re 3 j�tszott �ra lehet�s�ged van.");
		SendClientMessage(playerid, COLOR_LIGHTBLUE, "* Ez id� alatt nem vehetsz el� fegyvert, �s nem warozhatsz.");
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0, "unjail7_kozmunkafunyiras");
		SetPlayerWorldBounds(playerid,20000.0000,-20000.0000,20000.0000,-20000.0000);
	 	//PlayerInfo[playerid][pTeleportAlatt] = 1;
		SetPlayerPos(playerid, 2029.5023, -1404.1078, 17.2503);
		PlayerInfo[playerid][pJailed] = 0;
		PlayerInfo[playerid][pKozmunka] = MUNKA_FUNYIRO;
		PlayerInfo[playerid][pKozmunkaIdo] = 3;
		GetPlayerPos(playerid, ArrExt(yay));
		KozmunkasFelirat[playerid] = CreateDynamic3DTextLabel("K�zmunk�s\nF�ny�r�s", 0x640000FF, 0.0, 0.0, 0.15, 25.0, playerid, INVALID_VEHICLE_ID);
	}
	elseif(egyezik(munka, "�ttiszt�t�s") || egyezik(munka, "uttisztitas"))
	{
		CopMsgFormat(COLOR_ALLDEPT, "[Fegyenctelep] Figyelem: %s k�zmunk�s enyh�t�st k�rt", ICPlayerName(playerid));
		CopMsgFormat(COLOR_ALLDEPT, "[Fegyenctelep] ezt a v�dat enyh�ti: %s - ezzel enyh�ti a v�dat: �ttiszt�t�s", PlayerInfo[playerid][pJailOK]);
		SendClientMessage(playerid, COLOR_LIGHTBLUE, "* Menj egy �ttiszt�t�s kocsihoz, �lj bele, �s a /�ttiszt�t�s paranccsal kezd el ledolgozni az id�det.");
		SendClientMessage(playerid, COLOR_LIGHTBLUE, "* Figyelem: A k�zmunka let�lt�s�re 3 j�tszott �ra lehet�s�ged van.");
		SendClientMessage(playerid, COLOR_LIGHTBLUE, "* Ez id� alatt nem vehetsz el� fegyvert, �s nem warozhatsz.");
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0, "unjail7_kozmunkauttisztitas");
		SetPlayerWorldBounds(playerid,20000.0000,-20000.0000,20000.0000,-20000.0000);
	 	//PlayerInfo[playerid][pTeleportAlatt] = 1;
		SetPlayerPos(playerid, 2029.5023, -1404.1078, 17.2503);
		PlayerInfo[playerid][pJailed] = 0;
		PlayerInfo[playerid][pKozmunka] = MUNKA_UTTISZTITO;
		PlayerInfo[playerid][pKozmunkaIdo] = 3;
		GetPlayerPos(playerid, ArrExt(yay));
		KozmunkasFelirat[playerid] = CreateDynamic3DTextLabel("K�zmunk�s\n�ttiszt�t�", 0x640000FF, 0.0, 0.0, 0.15, 25.0);
	}
	return 1;
}

CMD:koszt(playerid, params[])
{
	if(FloodCheck(playerid)) return 1;
	if(IsACop(playerid)) return Msg(playerid, "Meg�hezt�l? :-D");
	if(Evett[playerid] > UnixTime) return SendFormatMessage(playerid, COLOR_LIGHTRED, "ClassRPG: Legk�zelebb %d m�sodperc m�lva k�rhetsz kosztot!", Evett[playerid]-UnixTime);
	//if(PInfo(playerid,Jailed) != 7) return Msg(playerid, "Nem a fegyenctelepen vagy elhelyezve, �gy nem k�rhetsz kosztot!");
	
	new bool:ehet;
	
	// jail
	if(PInfo(playerid,Jailed))
		ehet = true;
		
	// hajl�ktalan sz�ll�
	if(GetPlayerDistanceFromPoint(playerid, 1160.227, 2561.498, 10.992) < 10.0 && GetPlayerVirtualWorld(playerid) == 146) 
		ehet = true;
	
	if(!ehet)
		return Msg(playerid, "Itt nem ehetsz!");
	
	new kaja[32];
	if(sscanf(params, "s[32]", kaja)) return Msg(playerid, "/koszt [bableves/toj�sleves/sert�sp�rk�lt/r�ntotth�s/bors�fozel�k/krumplif�zel�k]");
	if(egyezik(kaja, "bableves"))
		Szukseglet(playerid, -7.5, -2.5),Cselekves(playerid, "k�rt egy adag bablevest.");
	elseif(egyezik(kaja, "toj�sleves") || egyezik(kaja, "tojasleves"))
		Szukseglet(playerid, -2.5, -5.0),Cselekves(playerid, "k�rt egy adag toj�slevest.");
	elseif(egyezik(kaja, "sert�sp�rk�lt") || egyezik(kaja, "sertesporkolt") || egyezik(kaja, "p�rk�lt") || egyezik(kaja, "porkolt"))
		Szukseglet(playerid, -10.0),Cselekves(playerid, "k�rt egy adag sert�sp�rk�ltet.");
	elseif(egyezik(kaja, "r�ntotth�s") || egyezik(kaja, "rantotthus"))
		Szukseglet(playerid, -9.0, -1.0),Cselekves(playerid, "k�rt egy adag r�ntotth�st.");
	elseif(egyezik(kaja, "bors�fozel�k") || egyezik(kaja, "borsofozelek"))
		Szukseglet(playerid, -8.5, -1.5),Cselekves(playerid, "k�rt egy adag bors�f�zel�ket.");
	elseif(egyezik(kaja, "krumplif�zel�k") || egyezik(kaja, "krumplifozelek"))
		Szukseglet(playerid, -4.5, -5.5),Cselekves(playerid, "k�rt egy adag krumplif�zel�ket.");
	else return Msg(playerid,"Nincs ilyen koszt.");
	
	Evett[playerid] = UnixTime+30;
	ApplyAnimation(playerid, "FOOD", "EAT_Burger", 3.0, 0, 0, 0, 0, 0);
	//SendClientMessage(playerid, COLOR_GREEN, "K�rt�l egy men�t, nem kell sietned, �t percenk�nt szolg�lnak ki �jra! J� �tv�gyat!");
	return 1;
}

CMD:adatforgalom(playerid, params[])
{
	new ertek;
	if(PlayerInfo[playerid][pPbiskey] != BIZ_TELEFON && !Admin(playerid, 1337)) return Msg(playerid, "Ez a parancs csak a telefonszolg�ltat� tulajdonos�nak �rhet� el!");
	if(AdatforgalomValtoztatas > UnixTime) return SendFormatMessage(playerid, COLOR_LIGHTRED, "ClassRPG: Nem m�dos�thatod az adatforgalmat, egy h�ten csak egyszer szabad! Legk�zelebb %d nap m�lva lehet", (AdatforgalomValtoztatas-UnixTime)/3600);
	if(sscanf(params, "d", ertek)) return Msg(playerid, "/adatforgalom [�r]");
	if(ertek < 0 || ertek > 100) return Msg(playerid, "0-100 k�z�tti �rt�ket adj meg!");
	AdatforgalomAr = ertek;
	AdatforgalomValtoztatas = UnixTime+604800;
	SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Adatforgalom �r �t�rva ennyire: %d Ft - Ez 1 kb adatforgalom �ra!", ertek);
	return 1;
}

CMD:mobilnet(playerid, params[])
{
	new wp[32];
	if(PlayerInfo[playerid][pMobilnet] == NINCS) return Msg(playerid, "Nincs mobilnet szerzod�sed!");
	if(sscanf(params, "s[32]", wp)) return Msg(playerid, "/mobilnet [Adatforgalmam/Lemond/�r]");
	if(egyezik(wp, "adatforgalmam"))
		SendFormatMessage(playerid, COLOR_DARKYELLOW, "[ClassTel] �nnek jelenleg %d kb elhaszn�lt adatforgalma van.", PlayerInfo[playerid][pMobilnet]);
	elseif(egyezik(wp, "lemond"))
	{
		new ar = PlayerInfo[playerid][pMobilnet]*AdatforgalomAr;
		if(PlayerInfo[playerid][pMobilnet] != 0)
		{	
			BizPenz(BIZ_TELEFON, ar/2+20000);
			if(PlayerInfo[playerid][pBankSzamla] > 0)
				PlayerInfo[playerid][pAccount] -= ar+20000;
			else
				GiveMoney(playerid, -ar+20000);
			SendFormatMessage(playerid, COLOR_DARKYELLOW, "[ClassTel] �n sikeresen lemondta mobilnet szerz�d�s�t, a szerz�d�sbont�s miatt %d forintot fizetett (20000 Ft + elhaszn�lt adatforgalom)!", ar+20000);
		}
		else
		{
			BizPenz(BIZ_TELEFON, 20000);
			if(PlayerInfo[playerid][pBankSzamla] > 0)
				PlayerInfo[playerid][pAccount] -= 20000;
			else
				GiveMoney(playerid, -20000);
			SendClientMessage(playerid, COLOR_DARKYELLOW, "[ClassTel] �n sikeresen lemondta mobilnet szerz�d�s�t, a szerz�d�sbont�s miatt 20000 Forintot fizetett!");
		}
		PlayerInfo[playerid][pMobilnet] = NINCS;
	}
	elseif(egyezik(wp, "�r") || egyezik(wp, "ar"))
		SendFormatMessage(playerid, COLOR_DARKYELLOW, "[ClassTel] A jelenlegi adatforgalom �r: %d Ft/kb", AdatforgalomAr);
	return 1;
}

CMD:wifi(playerid, params[])
{
	new param[32], sparam[32];
	if(FloodCheck(playerid)) return 1;
	if(PlayerInfo[playerid][pLaptop] == 0) return Msg(playerid, "Nincs laptopod!");
	if(sscanf(params, "s[32]S()[32]", param, sparam)) return Msg(playerid, "Haszn�lata: /wifi [csatlakoz�s/lecsatlakoz�s/k�zel/pontok]");
	if(egyezik(param, "csatlakoz�s") || egyezik(param, "csatlakozas") || egyezik(param, "connect"))
	{
		new wifipont = GetClosestWifiPoint(playerid), wifierosseg = GetWifiSignal(playerid, wifipont);
		if(wifierosseg < 10) return Msg(playerid, "Nincs k�zeledben wifi pont!");
		SendFormatMessage(playerid, COLOR_LIGHTGREEN, "... Csatlakoz�s ehhez a hotspothoz: {FFFFFF}%s {9ACD32}...", WifiPont[wifipont][wNev]);
		MunkaFolyamatban[playerid] = 1;
		SetTimerEx("Munkavege", 5000, false, "ddd", playerid, M_WIFICONNECT, wifipont);
	}
	elseif(egyezik(param, "k�zel") || egyezik(param, "kozel"))
	{
		new Float:tavolsag, Float:s[3], wifipont = 0;
		GetPlayerPos(playerid, ArrExt(s));
		SendClientMessage(playerid, COLOR_DARKYELLOW, "===[ K�zelben tal�lhat� Wifi Hotspot(ok) ]===");
		for(new a = 0; a < sizeof(WifiPont); a++)
		{
			tavolsag = GetDistanceBetweenPoints(ArrExt(s), ArrExt(WifiPont[a][wPos]));
			if(tavolsag <= 100.0 && GetPlayerVirtualWorld(playerid) == WifiPont[a][wVw] && GetPlayerInterior(playerid) == WifiPont[a][wInt])
			{
				new wifi = GetWifiSignal(playerid, a);
				wifipont++;
				SendFormatMessage(playerid, COLOR_WHITE, "%s - Jeler�ss�g: %d sz�zal�k - HotSpot ID: %d", WifiPont[a][wNev], wifi, WifiPont[a][wID]);
			}
		}
		if(wifipont < 1) return Msg(playerid, "A k�zelben nincs egyetlen wifi hotspot sem!");
	}
	elseif(egyezik(param, "lecsatlakoz�s") || egyezik(param, "lecsatlakozas") || egyezik(param, "disconnect"))
	{
		if(!LaptopConnected[playerid]) return Msg(playerid, "Nem csatlakozt�l hotspothoz!");
		
		SendFormatMessage(playerid, COLOR_LIGHTGREEN, "... Lecsatlakozva err�l a hotspotr�l: {FFFFFF}%s {9ACD32}...", WifiPont[LaptopIP[playerid]][wNev]);
		LaptopIP[playerid] = NINCS;
		LaptopConnected[playerid] = false;
	}
	elseif(egyezik(param, "pontok"))
	{
		new wifipont = 0;
		SendClientMessage(playerid, COLOR_DARKYELLOW, "===[ Wifi Hotspotok list�ja ]===");
		for(new a = 0; a < sizeof(WifiPont); a++)
		{
			if(WifiPont[a][wPos][0] == 0.0) continue;
			SendFormatMessage(playerid, COLOR_WHITE, "%s - HotSpot ID: %d (Interior: %d | VW: %d)", WifiPont[a][wNev], WifiPont[a][wID], WifiPont[a][wInt], WifiPont[a][wVw]);
			wifipont++;
		}
		if(wifipont < 1) return Msg(playerid, "Nincs egyetlen wifi hotspot sem!");
	}
	elseif(egyezik(param, "lerak"))
	{
		if(!Admin(playerid, 1337)) return 1;
		new nev[32];
		if(sscanf(sparam, "s[32]", nev)) return Msg(playerid, "/wifi lerak [Wifipont neve - ClassHotSpot_n�v]");
		new Float:p[3], int = GetPlayerInterior(playerid), vw = GetPlayerVirtualWorld(playerid);
		GetPlayerPos(playerid, ArrExt(p));
		CreateWifi(ArrExt(p), vw, int, nev);
		SendFormatMessage(playerid, COLOR_LIGHTRED, "ClassRPG: Wifi hotspot lerakva, neve: ClassHotSpot_%s", nev);
		Format(_tmpString, "%s lerakott egy wifi hotspotot, n�v: ClassHotSpot_%s", nev);
		Log("Scripter", _tmpString);
	}
	return 1;
}

ALIAS(tdsz3n):textdrawszin;
ALIAS(tdszin):textdrawszin;
ALIAS(textdrawsz3n):textdrawszin;
CMD:textdrawszin(playerid, params[])
{
	ShowPlayerDialog(playerid, DIALOG_TEXTDRAW_COLOR, DIALOG_STYLE_LIST, "Textdrawh�tt�r sz�n v�laszt�sa", "{505055}Fekete\n{FFFFFF}Feh�r\n{22AAFF}K�k\n{111133}S�t�tk�k\n{00D900}Vil�gosz�ld\n{33AA33}S�t�tz�ld\n{AA0000}Piros\n{FFFF00}S�rga\n{FF1493}Pink\n�tl�tsz�", "Kiv�laszt", "M�gse");
	SendClientMessage(playerid, COLOR_SPEC, "V�laszd ki azt a sz�nt, amelyet textdraw h�tt�rk�nt szeretn�l haszn�lni!");
	return 1;
}

CMD:arany(playerid, params[])
{
	new pm[32], spm[32];
	if(FloodCheck(playerid)) return 1;
	if(!IsAt(playerid, IsAt_Bank)) return Msg(playerid, "Csak bankban haszn�lhat�!");
	if(sscanf(params, "s[32]S()[32]", pm, spm)) return Msg(playerid, "Haszn�lata: /arany [v�tel/berak/kivesz/elad/inform�ci�]");
	/*if(egyezik(pm, "v�tel") || egyezik(pm,"vetel") || egyezik(pm, "vesz"))
	{
		new db;
		if(sscanf(spm, "d", db)) return Msg(playerid, "Haszn�lata: /arany v�tel [darab]");
		if(db < 1 || db > 5) return Msg(playerid, "Egyszerre maximum 5 darabot tudunk elo�ll�tani! A minim�lis v�s�rl�si mennyis�g: 1 db");
		if(!BankkartyaFizet(playerid, db*50000000)) return SendFormatMessage(playerid, COLOR_LIGHTRED, "%d darab arany %s Forintba ker�l, ennyit nem b�r kifizetni!", db, FormatInt(db*50000000));
		if(Biztos[playerid] != 1)
		{
			SendClientMessage(playerid, COLOR_DARKYELLOW, "=====[ Banki �zenet ]=====");
			SendClientMessage(playerid, COLOR_WHITE, "K�rem gondolja �t alaposan, hogy befekteti-e p�nz�t aranyba!");
			SendFormatMessage(playerid, COLOR_WHITE, "%d darab arany megv�s�rl�sa ut�n %s Ft marad egyenleg�n!", db, FormatInt(PlayerInfo[playerid][pAccount] - 50000000*db));
			SendClientMessage(playerid, COLOR_WHITE, "A muvelet nem visszavonhat�, �gy ha t�nylegesen meg szeretn� v�laszolni, �rja be m�gegyszer a parancsot!");
			Biztos[playerid] = 1;
		}
		else
		{
			PlayerInfo[playerid][pArany] += db;
			BankSzef += db*10000000;
			SendClientMessage(playerid, COLOR_DARKYELLOW, "=====[ Banki �zenet ]=====");
			SendFormatMessage(playerid, COLOR_WHITE, "Sikeres v�s�rl�s! Egyenleg�rol levontunk %s Ft-t, �gy maradt %s Ft!", FormatInt(50000000*db), FormatInt(PlayerInfo[playerid][pAccount]));
			SendClientMessage(playerid, COLOR_WHITE, "K�sz�nj�k, hogy minket v�lasztott! Aranyait berakhatja bankba, mellyel aranyai ut�n "#ARANY_KAMAT"%%-os kamathoz juthat!");
			Biztos[playerid] = 0;
		}
	}
	else*/
	/*
	if(egyezik(pm, "berak") || egyezik(pm, "befektet"))
	{
		new db;
		if(PlayerInfo[playerid][pArany] == 0) return Msg(playerid, "Nincs arany �nn�l!");
		if(sscanf(spm, "d", db)) return Msg(playerid, "Haszn�lata: /arany befektet [darab]");
		if(db < 1) return Msg(playerid, "Persze..");
		if(PlayerInfo[playerid][pArany] < db) return Msg(playerid, "Nincs ennyi arany �nn�l!");
		if(Biztos[playerid] != 1)
		{
			SendClientMessage(playerid, COLOR_DARKYELLOW, "=====[ Banki �zenet ]=====");
			SendClientMessage(playerid, COLOR_WHITE, "K�rem gondolja �t alaposan, hogy befekteti-e az aranyait!");
			SendFormatMessage(playerid, COLOR_WHITE, "%d darab arany befektet�se ut�n %.3f sz�zal�k kamatot kap!", db, db*ARANY_KAMAT);
			SendClientMessage(playerid, COLOR_WHITE, "Amennyiben t�nyleg ezt szeretn�, �rja be m�gegyszer a parancsot!");
			Biztos[playerid] = 1;
		}
		else
		{
			PlayerInfo[playerid][pArany] -= db;
			PlayerInfo[playerid][pAranyBank] += db;
			SendClientMessage(playerid, COLOR_DARKYELLOW, "=====[ Banki �zenet ]=====");
			SendFormatMessage(playerid, COLOR_WHITE, "Sikeres befektet�s! %d darab aranyt fektetett be bankunkba, mely ut�n %.3f%% kamatot kap!", db, db*ARANY_KAMAT);
			SendClientMessage(playerid, COLOR_WHITE, "K�sz�nj�k, hogy minket v�lasztott! ClassBank Zrt.");
			Biztos[playerid] = 0;
		}
	}*/
	else if(egyezik(pm, "kivesz"))
	{
		new db;
		if(PlayerInfo[playerid][pAranyBank] == 0) return Msg(playerid, "�n m�g nem fektetett be aranyat a bankba!");
		if(sscanf(spm, "d", db)) return Msg(playerid, "Haszn�lata: /arany kivesz [darab]");
		if(db < 1) return Msg(playerid, "Persze..");
		if(PlayerInfo[playerid][pAranyBank] < db) return Msg(playerid, "Nincs ennyi aranya a bankban!");
		if(Biztos[playerid] != 1)
		{
			SendClientMessage(playerid, COLOR_DARKYELLOW, "=====[ Banki �zenet ]=====");
			SendClientMessage(playerid, COLOR_WHITE, "K�rem gondolja �t alaposan, hogy megsz�nteti-e befektet�s�t!");
			SendFormatMessage(playerid, COLOR_WHITE, "%d darab arany kiv�tele ut�n %.3f%% kamatt�l esik el!", db, db*ARANY_KAMAT);
			SendClientMessage(playerid, COLOR_WHITE, "Amennyiben t�nyleg ezt szeretn�, �rja be m�gegyszer a parancsot!");
			Biztos[playerid] = 1;
		}
		else
		{
			PlayerInfo[playerid][pArany] += db;
			PlayerInfo[playerid][pAranyBank] -= db;
			SendClientMessage(playerid, COLOR_DARKYELLOW, "=====[ Banki �zenet ]=====");
			SendFormatMessage(playerid, COLOR_WHITE, "Sikeres kiv�tel! %d darab aranyt vett ki bankunkb�l, �gy %.3f%% kamatt�l esett el!", db, db*ARANY_KAMAT);
			SendClientMessage(playerid, COLOR_WHITE, "K�sz�nj�k, hogy minket v�lasztott! ClassBank Zrt.");
			Biztos[playerid] = 0;
		}
	}
	else if(egyezik(pm, "info") || egyezik(pm, "inf�") || egyezik(pm, "inform�ci�") || egyezik(pm, "informacio"))
	{
		SendClientMessage(playerid, COLOR_DARKYELLOW, "=====[ Banki �zenet ]=====");
		SendFormatMessage(playerid, COLOR_WHITE, "Jelenleg %ddb aranya van, mely ut�n %.3f%% kamatot kap.", PlayerInfo[playerid][pAranyBank], PlayerInfo[playerid][pAranyBank] * ARANY_KAMAT);
		SendClientMessage(playerid, COLOR_WHITE, "Jelenleg egy darab aranyr�d �ra: 50,000,000 Ft.");
		SendClientMessage(playerid, COLOR_WHITE, "Banki befektet�s eset�n a befektetett aranyak sz�ma ut�n "#ARANY_KAMAT"%% kamatot kap aranyrudank�nt.");
		SendClientMessage(playerid, COLOR_WHITE, "Az arany haszn�lhat� fizetoeszk�zk�nt, illetve befektet�sk�nt is.");
	}
	else if(egyezik(pm, "elad"))
	{
		//if(UnixTime > 1391990399)
		//	return Msg(playerid, "M�r nincs lehetos�g arany elad�s�ra");
			
		new db;
		if(PlayerInfo[playerid][pAranyBank] == 0) return Msg(playerid, "�n m�g nem fektetett be aranyat a bankba!");
		if(sscanf(spm, "d", db)) return Msg(playerid, "Haszn�lata: /arany elad [darab]");
		if(db < 1) return Msg(playerid, "Persze..");
		if(PlayerInfo[playerid][pAranyBank] < db) return Msg(playerid, "Nincs ennyi aranya a bankban!");
		if(Biztos[playerid] != 1)
		{
			SendClientMessage(playerid, COLOR_DARKYELLOW, "=====[ Banki �zenet ]=====");
			SendClientMessage(playerid, COLOR_WHITE, "K�rem gondolja �t alaposan, hogy eladja-e aranyait a banknak!");
			SendClientMessage(playerid, COLOR_WHITE, "Egy aranyrudat 49 milli� forint�rt v�s�rol vissza a bank!");
			SendFormatMessage(playerid, COLOR_WHITE, "%d darab arany elad�s��rt %d forintot fog �rte kapni!", db, db*49000000);
			SendClientMessage(playerid, COLOR_WHITE, "Amennyiben t�nyleg ezt szeretn�, �rja be m�gegyszer a parancsot!");
			Biztos[playerid] = 1;
		}
		else
		{
			PlayerInfo[playerid][pAranyBank] -= db;
			PlayerInfo[playerid][pAccount] += 49000000*db;
			SendClientMessage(playerid, COLOR_DARKYELLOW, "=====[ Banki �zenet ]=====");
			SendFormatMessage(playerid, COLOR_WHITE, "Sikeres kiv�tel! %d darab aranyt adott el, mely ut�n %s Ft-t kapott!", db, FormatInt(49000000*db));
			SendClientMessage(playerid, COLOR_WHITE, "K�sz�nj�k, hogy minket v�lasztott! ClassBank Zrt.");
			Biztos[playerid] = 0;
		}
	}
	else if(egyezik(pm, "set"))
	{
		new uid, type[32], amount, zseb = PlayerInfo[uid][pArany], bank = PlayerInfo[uid][pAranyBank];
		if(!IsScripter(playerid)) return 1;
		if(IdgScripter[playerid]) return Msg(playerid, "Csak a rendes scripterek haszn�lhatj�k!");
		if(sscanf(spm, "rs[32]d", uid, type, amount)) return Msg(playerid, "Haszn�lata: /arany set [N�v/ID] [Zseb/Bank] [Mennyis�g]");
		if(uid == INVALID_PLAYER_ID) return Msg(playerid, "Nem l�tezo j�t�kos");
		if(amount < 0) return Msg(playerid, "A minimum �rt�k 0!");
		if(egyezik(type, "zseb"))
		{
			ABroadCastFormat(COLOR_LIGHTRED, PlayerInfo[playerid][pAdmin], "<< %s %s be�ll�totta %s zseb�ben l�vo arany�nak mennyis�g�t! �j: %s | R�gi: %s >>",AdminRangNev(playerid), PlayerName(playerid), PlayerName(uid), FormatNumber( amount, 0, ',' ), FormatNumber( zseb, 0, ',' ));
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* %s zsebe be�ll�tva: %sdb Arany | R�gi: %s", PlayerName(uid), FormatNumber( amount, 0, ',' ), FormatNumber( zseb, 0, ',' ));
			PlayerInfo[uid][pArany] = amount;
		}
		elseif(egyezik(type, "bank"))
		{
			ABroadCastFormat(COLOR_LIGHTRED, PlayerInfo[playerid][pAdmin], "<< %s %s be�ll�totta %s bankban l�vo arany�nak mennyis�g�t! �j: %s (%.3f%%) | R�gi: %s (%.3f%%) >>",AdminRangNev(playerid), PlayerName(playerid), PlayerName(uid), FormatNumber( amount, 0, ',' ), amount*ARANY_KAMAT, FormatNumber( bank, 0, ',' ), zseb*ARANY_KAMAT);
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* %s zsebe be�ll�tva: %sdb (%.3f%%) Arany | R�gi: %s (%.3f%%)", PlayerName(uid), FormatNumber( amount, 0, ',' ), amount*ARANY_KAMAT, FormatNumber( bank, 0, ',' ), bank*ARANY_KAMAT);
			PlayerInfo[uid][pAranyBank] = amount;
		}
	}
	return 1;
}

/*CMD:havazas(playerid, params[])
{
	if(Havazas[playerid])
	{
		Havazas[playerid]=false;
		if(IdoJaras[iMost] == NINCS)
		{
			for(new o = 0; o < MAX_HO_OBJECT; o++)
				DestroyDynamicObject(HoObject[playerid][o]), HoObject[playerid][o] = INVALID_OBJECT_ID;
		}
		Msg(playerid, "KIkapcsoltad a havaz�st!");
		return 1;
	}
	else
	{
	
		if(IdoJaras[iMost] == NINCS)
			IdojarasValt(playerid, NINCS);
		
		Havazas[playerid]=true;		
		Msg(playerid, "BEkapcsoltad a havaz�st! A k�vetkezo havaz�sn�l havazni fog!");
	}
	
	return 1;
}*/
/*CMD:gos(playerid, params[])
{
	if(!IsScripter(playerid)) return 1;
	new id;
	if(sscanf(params, "d", id)) return Msg(playerid, "/gos [id]");

	Tele(playerid,Gift[id][gxPos],Gift[id][gyPos],Gift[id][gzPos]);
	return 1;
}*/
CMD:kupon(playerid, params[])
{
	new player; new func[10]; new func2[33];
	new log[256];
	
	if(sscanf(params, "s[9]S()[32]", func,func2)) return Msg(playerid,"/kupon [megn�z / t�r�l / saj�t / megmutat]");
	
	if(egyezik(func,"megn�z") || egyezik(func,"saj�t") || egyezik(func,"megmutat"))
	{
		if(egyezik(func,"megn�z"))
		{
			if(!Admin(playerid,1337)) return Msg(playerid, "Csak foadmin!");
			if(sscanf(func2, "u", player)) return Msg(playerid,"/kupon megn�z [id]");
			if(player == INVALID_PLAYER_ID) return Msg(playerid,"Nincs ilyen j�t�kos!");
			SendFormatMessage(playerid,COLOR_LIGHTRED,"==== %s kuponja====",PlayerName(player));
		}
		else if(egyezik(func,"megmutat"))
		{
			if(player == INVALID_PLAYER_ID) return Msg(playerid,"Nincs ilyen j�t�kos!");
			if(GetDistanceBetweenPlayers(playerid, player) > 3) return Msg(playerid, "Nincs a k�zeledben!");
			if(sscanf(func2, "u", player)) return Msg(playerid,"/kupon megmutat [id]");
			Msg(playerid, "Megmutattad a kuponodat!");
			Cselekves(playerid, "megmutatta a kuponj�t!");
			SendFormatMessage(player,COLOR_LIGHTRED,"==== %s kuponja====",PlayerName(playerid));
			
			switch(PlayerInfo[playerid][pAjandek])
			{
				case 1: Msg(player,"Neked/neki egy ingyen kocs alak�t�sa van. ((/alakit))");
				case 2: Msg(player,"Neked/neki egy ingyen h�z �thelyez�se van.");
				case 3: Msg(player,"Neked/neki egy ingyen h�z belso alak�t�sa van.");
				case 4: Msg(player,"Neked/neki egy ingyen �r�ktuningod van!");
				default: Msg(player,"Neked/neki nincs kuponod!");
			}
			return 1;
		}
		else
			player=playerid;
			
		switch(PlayerInfo[player][pAjandek])
		{
			case 1: Msg(playerid,"Neked/neki egy ingyen kocs alak�t�sa van. ((/alakit))");
			case 2: Msg(playerid,"Neked/neki egy ingyen h�z �thelyez�se van.");
			case 3: Msg(playerid,"Neked/neki egy ingyen h�z belso alak�t�sa van.");
			case 4: Msg(playerid,"Neked/neki egy ingyen �r�ktuningod van!");
			default: Msg(playerid,"Neked/neki nincs kupond!");
		}
		return 1;
	}
	if(egyezik(func,"t�r�l"))
	{
		
		if(!Admin(playerid,1337)) return Msg(playerid, "Csak foadmin!");
		if(sscanf(func2, "u",player)) return Msg(playerid,"/kupon t�r�l [id]");
		if(player == INVALID_PLAYER_ID) return Msg(playerid,"Nincs ilyen j�t�kos!");
		if(PlayerInfo[player][pAjandek] == NINCS) return Msg(playerid, "nincs neki kuponja");
		SendFormatMessage(playerid,COLOR_YELLOW,"T�r�lted a kuponj�t %s",PlayerName(player));
		Msg(player,"T�r�lt�k a kuponodat!");
		PlayerInfo[player][pAjandek] = NINCS;
		format(log,sizeof(log),"[ajandek]%s t�r�lte %s kuponj�t",PlayerName(playerid),PlayerName(player));
		Log("Egyeb",log);
		return 1;
	
	}
	

	return 1;
}
/*ALIAS(aj1nd2k):ajandek;
CMD:ajandek(playerid, params[])
{
	
	if(PlayerInfo[playerid][pAjandekUnixtime] > 1) return Msg(playerid, "M�r kapt�l aj�nd�kot!");
	
	if(PlayerInfo[playerid][pBID] > 8187279) return Msg(playerid, "Csak a kar�csonyig l�trehozott karakterek kapnak aj�nd�kot!");
	
	new id=NINCS;
	
	for(new a=0; a < MAX_GIFTS; a++)
	{
		if(Gift[a][gTulajUid] == PlayerInfo[playerid][pBID])
		{
			if(PlayerToPoint(2,playerid,Gift[a][gxPos],Gift[a][gyPos],Gift[a][gzPos]))
			{
				id=a;
				break;
			}
		}
	}
	if(id == NINCS) return Msg(playerid, "Ez nem a te csomagod pr�b�lj m�sikat!");
	
	
	
	PlayerInfo[playerid][pAjandekUnixtime]=UnixTime;
	Gift[id][gTulajUid] = NINCS;
	
	new Float:penz=OsszesPenz(playerid, 1000.0);

	
	new bool:kocsi=false; new bool:haz=false;
	
	if(PlayerInfo[playerid][pPcarkey] != NINCS || PlayerInfo[playerid][pPcarkey2] != NINCS || PlayerInfo[playerid][pPcarkey3] != NINCS)
		kocsi=true;
	if(PlayerInfo[playerid][pPhousekey] != NINCS || PlayerInfo[playerid][pPhousekey2] != NINCS || PlayerInfo[playerid][pPhousekey3] != NINCS)
		haz=true;
		
	new log[256];
	if(penz < 100.0 && !kocsi && !haz || Szint(playerid) < WEAPON_MIN_LEVEL)
	{
		
		Msg(playerid, "Kinyitottad az aj�nd�kodat! Az aj�nd�kod 1.000.000 Ft volt! Boldog kar�csonyt k�v�nunk!");
		GiveMoney(playerid,1000000);
		format(log,sizeof(log),"[ajandek] %s kapott 1.000.000 Ft-ott!",PlayerName(playerid));
		Log("Egyeb",log);
		
		return 1;
	}
	
	
	if(IsACop(playerid) || LMT(playerid,FRAKCIO_MENTO) || LMT(playerid,FRAKCIO_OKTATO) || LMT(playerid,FRAKCIO_ONKORMANYZAT)|| LMT(playerid,FRAKCIO_RIPORTER) || LMT(playerid,FRAKCIO_TUZOLTO))
	{
		if(kocsi && haz)
		{
			switch(random(4))
			{
				case 0:
					{
						Msg(playerid,"Kinyitottad az aj�nd�kodat! Az aj�nd�kod egy ingyen kocsi alak�t�s egy olyan modelre aminek UCP �ra nem �ri el a 80.000.000 FT-ott");
						Msg(playerid,"Ezt az aj�nd�kot oda is adhatod m�snak a /�tad aj�nd�k parancsal!");
						Msg(playerid, "Ha meg van a v�lasztott model, menj lecser�lni! ((/alakit))");
						Msg(playerid, "A kuponok nem �tv�lthat�ak P�NZRE adminok �ltal!!!");
						format(log,sizeof(log),"[ajandek] %s kapott egy ingyen kocsi alak�t�st!",PlayerName(playerid));
						Log("Egyeb",log);
						PlayerInfo[playerid][pAjandek] = 1;
						return 1;
					}
				case 1:
					{
						Msg(playerid,"Kinyitottad az aj�nd�kodat! Az aj�nd�kod egy ingyen h�z�thelyez�s!");
						Msg(playerid,"Ezt az aj�nd�kot oda is adhatod m�snak a /�tad aj�nd�k parancsal!");
						Msg(playerid, "Ha meg van a v�lasztott helysz�n, keres fel egy foadmint!");
						PlayerInfo[playerid][pAjandek] = 2;
						Msg(playerid, "A kuponok nem �tv�lthat�ak P�NZRE adminok �ltal!!!");
						format(log,sizeof(log),"[ajandek] %s kapott egy ingyen h�t�thelyez�st!",PlayerName(playerid));
						Log("Egyeb",log);
						return 1;
					}
				case 2:
					{
						Msg(playerid,"Kinyitottad az aj�nd�kodat! Az aj�nd�kod egy ingyen belso csere!");
						Msg(playerid,"Ezt az aj�nd�kot oda is adhatod m�snak a /�tad aj�nd�k parancsal!");
						Msg(playerid, "Ha meg van a v�lasztott belso, keres fel egy foadmint!");
						format(log,sizeof(log),"[ajandek] %s kapott egy ingyen belso alak�t�st!",PlayerName(playerid));
						Log("Egyeb",log);
						Msg(playerid, "A kuponok nem �tv�lthat�ak P�NZRE adminok �ltal!!!");
						PlayerInfo[playerid][pAjandek] = 3;
						return 1;
					
					}
				case 3:
					{
						Msg(playerid,"Kinyitottad az aj�nd�kodat! Az aj�nd�kod egy ingyen �r�k tuning!");
						Msg(playerid,"Ezt az aj�nd�kot oda is adhatod m�snak a /�tad aj�nd�k parancsal!");
						Msg(playerid, "Ha meg van a v�lasztott �r�k tuning, menj keres fel egy gar�zst �s rakd fel a v�lasztottad!");
						PlayerInfo[playerid][pAjandek] = 4;
						Msg(playerid, "A kuponok nem �tv�lthat�ak P�NZRE adminok �ltal!!!");
						format(log,sizeof(log),"[ajandek] %s kapott egy ingyen �r�ktuningot!",PlayerName(playerid));
						Log("Egyeb",log);
						return 1;

					}
			}
		}
		else if(kocsi)
		{
		
			switch(random(2))
			{
				case 0:
					{
						Msg(playerid,"Kinyitottad az aj�nd�kodat! Az aj�nd�kod egy ingyen kocsi alak�t�s egy olyan modelre aminek UCP �ra nem �ri el a 80.000.000 FT-ott");
						Msg(playerid,"Ezt az aj�nd�kot oda is adhatod m�snak a /�tad aj�nd�k parancsal!");
						Msg(playerid, "Ha meg van a v�lasztott model, menj lecser�lni! ((/alakit))");
						PlayerInfo[playerid][pAjandek] = 1;
						Msg(playerid, "A kuponok nem �tv�lthat�ak P�NZRE adminok �ltal!!!");
						format(log,sizeof(log),"[ajandek] %s kapott egy ingyen kocsi alak�t�st!",PlayerName(playerid));
						Log("Egyeb",log);
						return 1;
					}
				case 1:
					{
						Msg(playerid,"Kinyitottad az aj�nd�kodat! Az aj�nd�kod egy ingyen �r�k tuning!");
						Msg(playerid,"Ezt az aj�nd�kot oda is adhatod m�snak a /�tad aj�nd�k parancsal!");
						Msg(playerid, "Ha meg van a v�lasztott �r�k tuning, menj keres fel egy gar�zst �s rakd fel a v�lasztottad!");
						PlayerInfo[playerid][pAjandek] = 4;
						Msg(playerid, "A kuponok nem �tv�lthat�ak P�NZRE adminok �ltal!!!");
						format(log,sizeof(log),"[ajandek] %s egy ingyen �r�k tuningot",PlayerName(playerid));
						Log("Egyeb",log);
						return 1;

					}
			}
		}
		else if(haz)
		{
			switch(random(2))
			{
				case 0:
					{
						Msg(playerid,"Kinyitottad az aj�nd�kodat! Az aj�nd�kod egy ingyen h�z�thelyez�s!");
						Msg(playerid,"Ezt az aj�nd�kot oda is adhatod m�snak a /�tad aj�nd�k parancsal!");
						Msg(playerid, "Ha meg van a v�lasztott helysz�n, keres fel egy foadmint!");
						PlayerInfo[playerid][pAjandek] = 2;
						Msg(playerid, "A kuponok nem �tv�lthat�ak P�NZRE adminok �ltal!!!");
						format(log,sizeof(log),"[ajandek] %s kapott egy ingyen h�z�thelyez�st",PlayerName(playerid));
						Log("Egyeb",log);
						return 1;
					}
				case 1:
					{
						Msg(playerid,"Kinyitottad az aj�nd�kodat! Az aj�nd�kod egy ingyen belso csere!");
						Msg(playerid,"Ezt az aj�nd�kot oda is adhatod m�snak a /�tad aj�nd�k parancsal!");
						Msg(playerid, "Ha meg van a v�lasztott belso, keres fel egy foadmint!");
						PlayerInfo[playerid][pAjandek] = 3;
						Msg(playerid, "A kuponok nem �tv�lthat�ak P�NZRE adminok �ltal!!!");
						format(log,sizeof(log),"[ajandek] %s kapott egy ingyen belso cser�t!",PlayerName(playerid));
						Log("Egyeb",log);
						return 1;
					
					}
			}
		}
		else
		{
		
			switch(random(2))
			{
				case 0:
					{
						Msg(playerid,"Kinyitottad az aj�nd�kodat! Az aj�nd�kod egy aranyr�d!");
						PlayerInfo[playerid][pArany] = 1;
						format(log,sizeof(log),"[ajandek] %s kapott egy aranyrudat",PlayerName(playerid));
						Log("Egyeb",log);
						return 1;
					}
				case 1:
					{
						if(PlayerInfo[playerid][pLaptop] == 0)
						{
						
							Msg(playerid,"Kinyitottad az aj�nd�kodat! Az aj�nd�kod egy laptop!");
							PlayerInfo[playerid][pLaptop] = 1;
							format(log,sizeof(log),"[ajandek] %s kapott egy laptopot",PlayerName(playerid));
							Log("Egyeb",log);
							return 1;
						
						}
						else
						{
							Msg(playerid,"Kinyitottad az aj�nd�kodat! Az aj�nd�kod egy aranyr�d!");
							PlayerInfo[playerid][pArany] = 1;
							format(log,sizeof(log),"[ajandek] %s kapott egy aranyrudat",PlayerName(playerid));
							Log("Egyeb",log);
							return 1;
						}
					
					}
			}
		
		
		
		
		}
		
	
	}
	else
	{
		if(kocsi && haz)
		{
			switch(random(10))
			{
				case 0:
					{
						Msg(playerid,"Kinyitottad az aj�nd�kodat! Az aj�nd�kod egy ingyen kocsi alak�t�s egy olyan modelre aminek UCP �ra nem �ri el a 80.000.000 FT-ott");
						Msg(playerid,"Ezt az aj�nd�kot oda is adhatod m�snak a /�tad aj�nd�k parancsal!");
						Msg(playerid, "Ha meg van a v�lasztott model, menj lecser�lni! ((/alakit))");
						format(log,sizeof(log),"[ajandek] %s kapott egy ingyen kocsi alak�t�st!",PlayerName(playerid));
						Log("Egyeb",log);
						PlayerInfo[playerid][pAjandek] = 1;
						Msg(playerid, "A kuponok nem �tv�lthat�ak P�NZRE adminok �ltal!!!");
						return 1;
						
					}
				case 1:
					{
						Msg(playerid,"Kinyitottad az aj�nd�kodat! Az aj�nd�kod egy ingyen h�z�thelyez�s!");
						Msg(playerid,"Ezt az aj�nd�kot oda is adhatod m�snak a /�tad aj�nd�k parancsal!");
						Msg(playerid, "Ha meg van a v�lasztott helysz�n, keres fel egy foadmint!");
						PlayerInfo[playerid][pAjandek] = 2;
						format(log,sizeof(log),"[ajandek] %s kapott egy ingyen h�t�thelyez�st!",PlayerName(playerid));
						Log("Egyeb",log);
						Msg(playerid, "A kuponok nem �tv�lthat�ak P�NZRE adminok �ltal!!!");
						return 1;
					}
				case 2:
					{
						Msg(playerid,"Kinyitottad az aj�nd�kodat! Az aj�nd�kod egy ingyen belso csere!");
						Msg(playerid,"Ezt az aj�nd�kot oda is adhatod m�snak a /�tad aj�nd�k parancsal!");
						Msg(playerid, "Ha meg van a v�lasztott belso, keres fel egy foadmint!");
						format(log,sizeof(log),"[ajandek] %s kapott egy ingyen belso alak�t�st!",PlayerName(playerid));
						Log("Egyeb",log);
						Msg(playerid, "A kuponok nem �tv�lthat�ak P�NZRE adminok �ltal!!!");
						PlayerInfo[playerid][pAjandek] = 3;
						return 1;
					
					}
				case 3:
					{
						Msg(playerid,"Kinyitottad az aj�nd�kodat! Az aj�nd�kod egy ingyen �r�k tuning!");
						Msg(playerid,"Ezt az aj�nd�kot oda is adhatod m�snak a /�tad aj�nd�k parancsal!");
						Msg(playerid, "Ha meg van a v�lasztott �r�k tuning, menj keres fel egy gar�zst �s rakd fel a v�lasztottad!");
						PlayerInfo[playerid][pAjandek] = 4;
						format(log,sizeof(log),"[ajandek] %s kapott egy ingyen �r�ktuningot!",PlayerName(playerid));
						Log("Egyeb",log);
						Msg(playerid, "A kuponok nem �tv�lthat�ak P�NZRE adminok �ltal!!!");
						return 1;

					}
				case 4:
					{
						Msg(playerid,"Kinyitottad az aj�nd�kodat! Az aj�nd�kod 1500g heroin!");
						PlayerInfo[playerid][pHeroin] +=1500;
						format(log,sizeof(log),"[ajandek] %s kapott 1500g heroint!",PlayerName(playerid));
						Log("Egyeb",log);
						return 1;
					}
				case 5:
					{
						Msg(playerid,"Kinyitottad az aj�nd�kodat! Az aj�nd�kod 2000g Kokain!");
						PlayerInfo[playerid][pKokain] +=2000;
						format(log,sizeof(log),"[ajandek] %s kapott 2000g kokaint!",PlayerName(playerid));
						Log("Egyeb",log);
						return 1;
					}
				case 6:
					{
						Msg(playerid,"Kinyitottad az aj�nd�kodat! Az aj�nd�kod 30.000db material!");
						PlayerInfo[playerid][pMats] +=30000;
						format(log,sizeof(log),"[ajandek] %s kapott 30.000db materialt",PlayerName(playerid));
						Log("Egyeb",log);
						return 1;
					}
				case 7:
					{
						Msg(playerid,"Kinyitottad az aj�nd�kodat! Az aj�nd�kod 1000g Marihuana!");
						PlayerInfo[playerid][pMarihuana] +=1000;
						format(log,sizeof(log),"[ajandek] %s kapott 1000g marihuanat",PlayerName(playerid));
						Log("Egyeb",log);
						return 1;
					}
				case 8:
					{
						Msg(playerid,"Kinyitottad az aj�nd�kodat! Az aj�nd�kod egy Sniper �s 100 loszer hozz�!");
						WeaponGiveWeapon(playerid, WEAPON_SNIPER, .maxweapon = 0);
						WeaponGiveAmmo(playerid, WEAPON_SNIPER, 100);
						format(log,sizeof(log),"[ajandek] %s kapott egy Sniper-t 1000 loszerrel!",PlayerName(playerid));
						Log("Egyeb",log);
						return 1;
					}
				case 9:
					{
						Msg(playerid,"Kinyitottad az aj�nd�kodat! Az aj�nd�kod egy M4-es 500 loszerrel!");
						WeaponGiveWeapon(playerid, WEAPON_M4, .maxweapon = 0);
						WeaponGiveAmmo(playerid, WEAPON_M4, 500);
						format(log,sizeof(log),"[ajandek] %s kapott egy M4-et 500 loszerrel",PlayerName(playerid));
						Log("Egyeb",log);
						return 1;
					}
			}
		}
		else if(kocsi)
		{
		
			switch(random(8))
			{
				case 0:
					{
						Msg(playerid,"Kinyitottad az aj�nd�kodat! Az aj�nd�kod egy ingyen kocsi alak�t�s egy olyan modelre aminek UCP �ra nem �ri el a 80.000.000 FT-ott");
						Msg(playerid,"Ezt az aj�nd�kot oda is adhatod m�snak a /�tad aj�nd�k parancsal!");
						Msg(playerid, "Ha meg van a v�lasztott model, menj lecser�lni! ((/alakit))");
						PlayerInfo[playerid][pAjandek] = 1;
						format(log,sizeof(log),"[ajandek] %s kapott egy ingyen kocsi alak�t�st!",PlayerName(playerid));
						Log("Egyeb",log);
						return 1;
					}
				case 1:
					{
						Msg(playerid,"Kinyitottad az aj�nd�kodat! Az aj�nd�kod egy ingyen �r�k tuning!");
						Msg(playerid,"Ezt az aj�nd�kot oda is adhatod m�snak a /�tad aj�nd�k parancsal!");
						Msg(playerid, "Ha meg van a v�lasztott �r�k tuning, menj keres fel egy gar�zst �s rakd fel a v�lasztottad!");
						PlayerInfo[playerid][pAjandek] = 4;
						format(log,sizeof(log),"[ajandek] %s egy ingyen �r�k tuningot",PlayerName(playerid));
						Log("Egyeb",log);
						return 1;

					}
				case 2:
					{
						Msg(playerid,"Kinyitottad az aj�nd�kodat! Az aj�nd�kod 1500g heroin!");
						PlayerInfo[playerid][pHeroin] +=1500;
						format(log,sizeof(log),"[ajandek] %s kapott 1500g heroint!",PlayerName(playerid));
						Log("Egyeb",log);
						return 1;
					}
				case 3:
					{
						Msg(playerid,"Kinyitottad az aj�nd�kodat! Az aj�nd�kod 2000g Kokain!");
						PlayerInfo[playerid][pKokain] +=2000;
						format(log,sizeof(log),"[ajandek] %s kapott 2000g kokaint!",PlayerName(playerid));
						Log("Egyeb",log);
						return 1;
					}
				case 4:
					{
						Msg(playerid,"Kinyitottad az aj�nd�kodat! Az aj�nd�kod 30.000db material!");
						PlayerInfo[playerid][pMats] +=30000;
						format(log,sizeof(log),"[ajandek] %s kapott 30.000db materialt",PlayerName(playerid));
						Log("Egyeb",log);
						return 1;
					}
				case 5:
					{
						Msg(playerid,"Kinyitottad az aj�nd�kodat! Az aj�nd�kod 1000g Marihuana!");
						PlayerInfo[playerid][pMarihuana] +=1000;
						format(log,sizeof(log),"[ajandek] %s kapott 1000g marihuanat",PlayerName(playerid));
						Log("Egyeb",log);
						return 1;
					}
				case 6:
					{
						Msg(playerid,"Kinyitottad az aj�nd�kodat! Az aj�nd�kod egy Sniper �s 100 loszer hozz�!");
						WeaponGiveWeapon(playerid, WEAPON_SNIPER, .maxweapon = 0);
						WeaponGiveAmmo(playerid, WEAPON_SNIPER, 100);
						format(log,sizeof(log),"[ajandek] %s kapott egy Sniper-t 1000 loszerrel!",PlayerName(playerid));
						Log("Egyeb",log);
						return 1;
					}
				case 7:
					{
						Msg(playerid,"Kinyitottad az aj�nd�kodat! Az aj�nd�kod egy M4-es 500 loszerrel!");
						WeaponGiveWeapon(playerid, WEAPON_M4, .maxweapon = 0);
						WeaponGiveAmmo(playerid, WEAPON_M4, 500);
						format(log,sizeof(log),"[ajandek] %s kapott egy M4-et 500 loszerrel",PlayerName(playerid));
						Log("Egyeb",log);
						return 1;
					}
			}
		}
		else if(haz)
		{
			switch(random(8))
			{
				case 0:
					{
						Msg(playerid,"Kinyitottad az aj�nd�kodat! Az aj�nd�kod egy ingyen h�z�thelyez�s!");
						Msg(playerid,"Ezt az aj�nd�kot oda is adhatod m�snak a /�tad aj�nd�k parancsal!");
						Msg(playerid, "Ha meg van a v�lasztott helysz�n, keres fel egy foadmint!");
						PlayerInfo[playerid][pAjandek] = 2;
						format(log,sizeof(log),"[ajandek] %s kapott egy ingyen h�z�thelyez�st",PlayerName(playerid));
						Log("Egyeb",log);
						return 1;
					}
				case 1:
					{
						Msg(playerid,"Kinyitottad az aj�nd�kodat! Az aj�nd�kod egy ingyen belso csere!");
						Msg(playerid,"Ezt az aj�nd�kot oda is adhatod m�snak a /�tad aj�nd�k parancsal!");
						Msg(playerid, "Ha meg van a v�lasztott belso, keres fel egy foadmint!");
						PlayerInfo[playerid][pAjandek] = 3;
						format(log,sizeof(log),"[ajandek] %s kapott egy ingyen belso cser�t!",PlayerName(playerid));
						Log("Egyeb",log);
						return 1;
					
					}
				case 2:
					{
						Msg(playerid,"Kinyitottad az aj�nd�kodat! Az aj�nd�kod 1500g heroin!");
						PlayerInfo[playerid][pHeroin] +=1500;
						format(log,sizeof(log),"[ajandek] %s kapott 1500g heroint!",PlayerName(playerid));
						Log("Egyeb",log);
						return 1;
					}
				case 3:
					{
						Msg(playerid,"Kinyitottad az aj�nd�kodat! Az aj�nd�kod 2000g Kokain!");
						PlayerInfo[playerid][pKokain] +=2000;
						format(log,sizeof(log),"[ajandek] %s kapott 2000g kokaint!",PlayerName(playerid));
						Log("Egyeb",log);
						return 1;
					}
				case 4:
					{
						Msg(playerid,"Kinyitottad az aj�nd�kodat! Az aj�nd�kod 30.000db material!");
						PlayerInfo[playerid][pMats] +=30000;
						format(log,sizeof(log),"[ajandek] %s kapott 30.000db materialt",PlayerName(playerid));
						Log("Egyeb",log);
						return 1;
					}
				case 5:
					{
						Msg(playerid,"Kinyitottad az aj�nd�kodat! Az aj�nd�kod 1000g Marihuana!");
						PlayerInfo[playerid][pMarihuana] +=1000;
						format(log,sizeof(log),"[ajandek] %s kapott 1000g marihuanat",PlayerName(playerid));
						Log("Egyeb",log);
						return 1;
					}
				case 6:
					{
						Msg(playerid,"Kinyitottad az aj�nd�kodat! Az aj�nd�kod egy Sniper �s 100 loszer hozz�!");
						WeaponGiveWeapon(playerid, WEAPON_SNIPER, .maxweapon = 0);
						WeaponGiveAmmo(playerid, WEAPON_SNIPER, 100);
						format(log,sizeof(log),"[ajandek] %s kapott egy Sniper-t 1000 loszerrel!",PlayerName(playerid));
						Log("Egyeb",log);
						return 1;
					}
				case 7:
					{
						Msg(playerid,"Kinyitottad az aj�nd�kodat! Az aj�nd�kod egy M4-es 500 loszerrel!");
						WeaponGiveWeapon(playerid, WEAPON_M4, .maxweapon = 0);
						WeaponGiveAmmo(playerid, WEAPON_M4, 500);
						format(log,sizeof(log),"[ajandek] %s kapott egy M4-et 500 loszerrel",PlayerName(playerid));
						Log("Egyeb",log);
						return 1;
					}
			}
		}
		else
		{
			switch(random(6))
			{
				
				case 0:
					{
						Msg(playerid,"Kinyitottad az aj�nd�kodat! Az aj�nd�kod 1500g heroin!");
						PlayerInfo[playerid][pHeroin] +=1500;
						format(log,sizeof(log),"[ajandek] %s kapott 1500g heroint!",PlayerName(playerid));
						Log("Egyeb",log);
						return 1;
					}
				case 1:
					{
						Msg(playerid,"Kinyitottad az aj�nd�kodat! Az aj�nd�kod 2000g Kokain!");
						PlayerInfo[playerid][pKokain] +=2000;
						format(log,sizeof(log),"[ajandek] %s kapott 2000g kokaint!",PlayerName(playerid));
						Log("Egyeb",log);
						return 1;
					}
				case 2:
					{
						Msg(playerid,"Kinyitottad az aj�nd�kodat! Az aj�nd�kod 30.000db material!");
						PlayerInfo[playerid][pMats] +=30000;
						format(log,sizeof(log),"[ajandek] %s kapott 30.000db materialt",PlayerName(playerid));
						Log("Egyeb",log);
						return 1;
					}
				case 3:
					{
						Msg(playerid,"Kinyitottad az aj�nd�kodat! Az aj�nd�kod 1000g Marihuana!");
						PlayerInfo[playerid][pMarihuana] +=1000;
						format(log,sizeof(log),"[ajandek] %s kapott 1000g marihuanat",PlayerName(playerid));
						Log("Egyeb",log);
						return 1;
					}
				case 4:
					{
						Msg(playerid,"Kinyitottad az aj�nd�kodat! Az aj�nd�kod egy Sniper �s 100 loszer hozz�!");
						WeaponGiveWeapon(playerid, WEAPON_SNIPER, .maxweapon = 0);
						WeaponGiveAmmo(playerid, WEAPON_SNIPER, 100);
						format(log,sizeof(log),"[ajandek] %s kapott egy Sniper-t 1000 loszerrel!",PlayerName(playerid));
						Log("Egyeb",log);
						return 1;
					}
				case 5:
					{
						Msg(playerid,"Kinyitottad az aj�nd�kodat! Az aj�nd�kod egy M4-es 500 loszerrel!");
						WeaponGiveWeapon(playerid, WEAPON_M4, .maxweapon = 0);
						WeaponGiveAmmo(playerid, WEAPON_M4, 500);
						format(log,sizeof(log),"[ajandek] %s kapott egy M4-et 500 loszerrel",PlayerName(playerid));
						Log("Egyeb",log);
						return 1;
					}
			}
		}
	}
	
	format(log,sizeof(log),"[ajandek] %s Nem kapott semmit!",PlayerName(playerid));
	PlayerInfo[playerid][pAjandekUnixtime] = NINCS;
	Log("Egyeb",log);
	return 1;
}*/

ALIAS(fv1):fva;
CMD:fva(playerid, params[])
{
	new fkid, uzi[128];
	if(!Admin(playerid, 1)) return 1;
	if(sscanf(params, "ds[128]", fkid, uzi)) return Msg(playerid, "/fv� [frakci�id] [�zenet]");
	if(fkid < 0 || fkid > 22) return Msg(playerid, "Hib�s frakci�id");
	Format(_tmpString, "%s �rt a(z) %s frakci�nak | �zenet: %s", PlayerName(playerid), Szervezetneve[fkid-1][1], uzi);
	foreach(Jatekosok, i)
	{
		if(PlayerInfo[i][pAdmin] >= 1 && TogVa[i] == 0)
			SendClientMessage(i, COLOR_YELLOW, _tmpString);
	}
	if(TogVa[playerid] == 1)
		SendClientMessage(playerid, COLOR_YELLOW, _tmpString);
	Format(_tmpString, "[Frakci�] %s %s �zeni: %s", AdminRangNev(playerid), AdminName(playerid), uzi);
	SendMessage(SEND_MESSAGE_FRACTION, _tmpString, COLOR_LIGHTGREEN, fkid);
	
	PlayerInfo[playerid][pValaszok]++;
	Valasz[playerid]++;
	StatInfo[playerid][pVA]++;
	
	return 1;
}

ALIAS(bel2p2sek):belepesek;
CMD:belepesek(playerid, params[])
{
	if(Belepesek[playerid])
	{
		Belepesek[playerid] = false;
		Msg(playerid, "Most m�r nem l�tod, hogy kik l�pnek be a k�zeledben.");
	}
	else
	{
		Belepesek[playerid] = true;
		Msg(playerid, "Most m�r l�tod, hogy kik l�pnek be a k�zeledben.");
	}
	return 1;
}

CMD:detektor(playerid, params[])
{
	new v = GetPlayerVehicleID(playerid), vs = IsAVsKocsi(v), m[32];
	if(!IsPlayerInAnyVehicle(playerid)) return Msg(playerid, "Csak j�rm�ben haszn�lhat�!");
	if(vs == NINCS) return Msg(playerid, "Ebben a j�rm�ben nincs detektor! (vs)");
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return Msg(playerid, "Sof�rk�nt kell vezetned!");
	if(CarInfo[vs][cDetektor] == 0) return Msg(playerid, "Ebben a j�rm�ben nincs detektor!");
	if(sscanf(params, "s[32]", m))
	{
		if(Detektor[v])
		{
			Detektor[v] = false;
			Msg(playerid, "Detektor kikapcsolva, vigy�zz, ism�t elkaphat a traffipax!");
			Cselekves(playerid, "babr�l valamit az �l�se alatt...", 1);
		}
		else
		{
			Detektor[v] = true;
			Msg(playerid, "Detektor bekapcsolva, vigy�zz, ha a rendor �szreveszi, lecsukhat �rte!");
			Cselekves(playerid, "babr�l valamit az �l�se alatt...", 1);
		}
	}
	else if(!sscanf(params, "s[32]", m)) SendFormatMessage(playerid, COLOR_ADD, "Ebben a j�rm�ben %d-as szint� detektor van", CarInfo[vs][cDetektor]);
	return 1;
}

ALIAS(szem2t):szemet;
CMD:szemet(playerid, params[])
{
	new mitakarvele[32];
	if(sscanf(params, "s[32]", mitakarvele))
	{
		if(Admin(playerid, 1)) Msg(playerid, "Adminparancs: /szem�t mennyi");
		return Msg(playerid, "/szem�t [felvesz/lerak]");
	}
	if(egyezik(mitakarvele, "felvesz"))
	{
		if(VanSzemetNala[playerid]) return Msg(playerid, "N�lad m�r van szem�t, elobb azt rakd le!");
		for(new k = 0; k < sizeof(TrashInfo); k++)
		{
			if(PlayerToPoint(2.0, playerid, ArrExt(TrashInfo[k][tSzemetPos])) && TrashInfo[k][tSzemet] && (TrashInfo[k][gId] == PlayerInfo[playerid][pPhousekey] || TrashInfo[k][gId] == PlayerInfo[playerid][pPhousekey2] || TrashInfo[k][gId] == PlayerInfo[playerid][pPhousekey3] || Admin(playerid, 4) || Munkaban[playerid] == MUNKA_KUKAS))
			{
				kuka[playerid] = k;
				break;
			}
		}
		if(kuka[playerid] == NINCS) return Msg(playerid, "Nem vagy szem�t k�zel�ben vagy ez nem a te szemeted!");
		if(Admin(playerid, 4) && Munkaban[playerid] != MUNKA_KUKAS && !(TrashInfo[kuka[playerid]][gId] == PlayerInfo[playerid][pPhousekey] || TrashInfo[kuka[playerid]][gId] == PlayerInfo[playerid][pPhousekey2] || TrashInfo[kuka[playerid]][gId] == PlayerInfo[playerid][pPhousekey3]))
			Msg(playerid, "Ezt a szemetet az�rt tudtad felvenni mert admin vagy!");
		
		VanSzemetNala[playerid] = true;
		SetPlayerAttachedObject(playerid, ATTACH_SLOT_ZSAK_PAJZS_BILINCS, 1265, 6, 0.189000, -0.236000, 0.011999, -55.500057, 0.000000, 110.500022);
		if(IsValidDynamicObject(TrashInfo[kuka[playerid]][tSzemetObject])) DestroyDynamicObject(TrashInfo[kuka[playerid]][tSzemetObject]);
		if(IsValidDynamic3DTextLabel(TrashInfo[kuka[playerid]][tSzemetLabel])) DestroyDynamic3DTextLabel(TrashInfo[kuka[playerid]][tSzemetLabel]), TrashInfo[kuka[playerid]][tSzemetLabel] = INVALID_3D_TEXT_ID;
		Streamer_Update(playerid);
		Msg(playerid, "Szem�t felv�ve");
	}
	if(egyezik(mitakarvele, "lerak"))
	{
		if(!VanSzemetNala[playerid]) return Msg(playerid, "Nincs n�lad szem�t!");
		new Float:pozicio[3], vw = GetPlayerVirtualWorld(playerid), int = GetPlayerInterior(playerid);
		GetPlayerPos(playerid, ArrExt(pozicio));
		if(vw != 0 || int != 0) return Msg(playerid, "Csak a szabadban helyezheted el a szemetet! (0-s vw �s 0-s interior)");
		if(kuka[playerid] == NINCS) 
			return Msg(playerid, "Nincs n�lad szem�t!");
		
		TrashInfo[kuka[playerid]][tSzemetPos][0] = pozicio[0];
		TrashInfo[kuka[playerid]][tSzemetPos][1] = pozicio[1];
		TrashInfo[kuka[playerid]][tSzemetPos][2] = pozicio[2] - 0.5;
		VanSzemetNala[playerid] = false;
		if(!IsValidDynamicObject(TrashInfo[kuka[playerid]][tSzemetObject]))
			TrashInfo[kuka[playerid]][tSzemetObject] = CreateDynamicObject(1265, TrashInfo[kuka[playerid]][tSzemetPos][0], TrashInfo[kuka[playerid]][tSzemetPos][1], TrashInfo[kuka[playerid]][tSzemetPos][2], 0.0, 0.0, 0.0);
		tformat(64, "ID:%d\nSzem�t\nLerakta:%s", TrashInfo[kuka[playerid]][gId], ICPlayerName(playerid));
		if(!IsValidDynamic3DTextLabel(TrashInfo[kuka[playerid]][tSzemetLabel])) TrashInfo[kuka[playerid]][tSzemetLabel] = CreateDynamic3DTextLabel(_tmpString, 0xFFC801AA, ArrExt(TrashInfo[kuka[playerid]][tSzemetPos]), 25.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, 0, 0);
		RemovePlayerAttachedObject(playerid, ATTACH_SLOT_ZSAK_PAJZS_BILINCS);
		Streamer_Update(playerid);
		Msg(playerid, "Szem�t lerakva");
		kuka[playerid] = NINCS;
	}
	if(egyezik(mitakarvele, "debug"))
	{
		if(!SzemetDebug[playerid]) return 1;
		VanSzemetNala[playerid] = false;
		SzemetDebug[playerid] = false;
		RemovePlayerAttachedObject(playerid, ATTACH_SLOT_ZSAK_PAJZS_BILINCS);
		Streamer_Update(playerid);
		Msg(playerid, "Szem�t debugolva");
	}
	if(egyezik(mitakarvele, "mennyi"))
	{
		if(!Admin(playerid, 1)) return 1;
		
		new mennyih = 0, mennyisz = 0;
		for(new h = 0; h < sizeof(HouseInfo); h++)
		{
			if(HouseInfo[h][hTulaj] != 0)
				mennyih++;
		}
		for(new h = 0; h < sizeof(TrashInfo); h++)
		{
			if(TrashInfo[h][gId] != 0)
				mennyisz++;
		}
		
		Msg(playerid, "Ha a szem�t t�bb mint a h�z �rj HendRooxnak!");
		SendFormatMessage(playerid, COLOR_GRAD1, "Szem�t: %d H�z: %d", mennyisz, mennyih);
	}
	return 1;
}

CMD:rk(playerid, params[])
{
	if(!Admin(playerid,1)) return Msg(playerid, "Csak admin!");
	
	Msg(playerid, "Piros: 30 percn�l kevesebb | S�rga 30 percn�l r�gebben");
	foreach(Jatekosok, x)
	{
		if(IsValidDynamic3DTextLabel(RKFigyelo[x][RKid]))
		{
			if(RKFigyelo[x][RKido] > UnixTime)
				SendFormatMessage(playerid,COLOR_RED,"[x]%s Hal�lt�l eltelt id�: %d sec Meg�lte: %s Ezzel: %s Hal�l helye: %f,%f,%f",x,PlayerName(x),UnixTime-(RKFigyelo[x][RKido]-RK_FIGYELO_IDO),RKFigyelo[x][RKnamekill],RKFigyelo[playerid][RKWeapon],RKFigyelo[x][RKx],RKFigyelo[x][RKy],RKFigyelo[x][RKz]);
			else
				SendFormatMessage(playerid,COLOR_YELLOW,"[x]%s Hal�lt�l eltelt id�: %d sec Meg�lte: %s Ezzel: %s Hal�l helye: %f,%f,%f",x,PlayerName(x),UnixTime-RKFigyelo[x][RKido],RKFigyelo[x][RKnamekill],RKFigyelo[playerid][RKWeapon],RKFigyelo[x][RKx],RKFigyelo[x][RKy],RKFigyelo[x][RKz]);
		}
	
	}
	Msg(playerid, "Piros: 30 percn�l kevesebb | S�rga 30 percn�l r�gebben");
	return 1;
}

CMD:taxisok(playerid, params[])
{
	if(TaxiOnline() < 1) return Msg(playerid, "Nincs taxis");
	foreach(Jatekosok,id)
	{
		new Float:x,Float:y,Float:z,Float:xx,Float:yy,Float:zz;
		GetPlayerPos(playerid, x,y,z);
		
		if(Taxi[id][tDuty])
		{
			if(Taxi[id][tHivas])
			{
				SendFormatMessage(playerid,COLOR_YELLOW,"[H�v�sra megy][%d]%s D�jszab�s:%d FT [Sz�ll�t�sok: %d, Km: %.3f]",id,ICPlayerName(id),FrakcioInfo[FRAKCIO_TAXI][fDij],Taxi[id][tHivasok], Taxi[id][tOKm]/1000.0);
			}
			elseif(Taxi[id][tUtas] == NINCS)
			{
				GetPlayerPos(id, xx,yy,zz);
				new Float:tavolsag = GetDistanceBetweenPoints(x, y, z, xx, yy, zz);
				SendFormatMessage(playerid,COLOR_GREEN,"[Szabad][%d]%s D�jszab�s:%d FT t�vols�g: %.3f [Sz�ll�t�sok: %d, Km: %.3f]",id,ICPlayerName(id),FrakcioInfo[FRAKCIO_TAXI][fDij],tavolsag,Taxi[id][tHivasok], Taxi[id][tOKm]/1000.0);
			}
			else
				SendFormatMessage(playerid,COLOR_LIGHTRED,"[Foglalt][%d]%s D�jszab�s:%d FT [Sz�ll�t�sok: %d, Km: %.3f]",id,ICPlayerName(id),FrakcioInfo[FRAKCIO_TAXI][fDij],Taxi[id][tHivasok], Taxi[id][tOKm]/1000.0);
		
		
		}
	}
	Msg(playerid, "/service taxi [id]");
	return 1;
}

ALIAS(kukas):kuka;
ALIAS(kuk1s):kuka;
CMD:kuka(playerid, params[])
{
	if(OnDuty[playerid]) return Msg(playerid, "D�ntsd elobb el mit dolgozol! ((frakci� dutyba nem!))");
	new parameter[64];
	if(!AMT(playerid, MUNKA_KUKAS)) return Msg(playerid, "Nem vagy kuk�s!");
	if(sscanf(params, "s[64]", parameter)) return Msg(playerid, "/kuka [munka/hely/seg�ts�g]");
	if(egyezik(parameter, "munka") || egyezik(parameter, "szolgalat") || egyezik(parameter, "szolg�lat"))
	{
		if(!PlayerToPoint(2.5, playerid, -586.7446,-1501.2863,10.3250))
		{
			SetPlayerCheckpoint(playerid, -586.7446,-1501.2863,10.3250, 2.5);
			Msg(playerid, "Nem vagy a szem�ttelepen!");
			return 1;
		}
		if(Munkaban[playerid] != MUNKA_KUKAS)
		{
			Munkaban[playerid] = MUNKA_KUKAS;
			if(PlayerInfo[playerid][pSex] == 2) SetPlayerSkin(playerid, 157);
			else SetPlayerSkin(playerid, 8);
			Msg(playerid, "Felvetted a ruh�dat, �gy munk�ba �llt�l. A munka v�gz�s�hez seg�ts�g: /kuka seg�ts�g");
			
		}
		else if(Munkaban[playerid] == MUNKA_KUKAS)
		{
			Munkaban[playerid] = NINCS;
			if(!LegalisSzervezetTagja(playerid) && !Civil(playerid))
				SetPlayerSkin(playerid, PlayerInfo[playerid][pChar]);
			else
				SetPlayerSkin(playerid, PlayerInfo[playerid][pModel]);
				
			Msg(playerid, "Visszavetted a civil ruh�dat, �gy m�r nem dolgozol.");
		}
	}
	else if(egyezik(parameter, "hely"))
	{
		if(Munkaban[playerid] != MUNKA_KUKAS) return Msg(playerid, "Nem kuk�sk�nt dolgozol!");
		new kukac, Float:ppos[3], Float:tav, Float:legkozelebb = 5000.0;
		GetPlayerPos(playerid, ArrExt(ppos));
		for(new k = 0; k < sizeof(TrashInfo); k++)
		{
			if(!TrashInfo[k][tSzemet]) continue;
			tav = GetDistanceBetweenPoints(ArrExt(ppos), ArrExt(TrashInfo[k][tSzemetPos]));
			if(tav < legkozelebb)
			{
				legkozelebb = tav;
				kukac = k;
			}
		}
		if(legkozelebb == 5000.0) return Msg(playerid, "Jelenleg nincs elsz�ll�t�sra v�r� kuka.");
		SetPlayerCheckpoint(playerid, ArrExt(TrashInfo[kukac][tSzemetPos]), 2.0);
		Msg(playerid, "Az ir�ny�t� �gyn�ks�g megjel�lte a sz�modra legk�zelebbi elsz�ll�tatlan szemetet.");
	}
	else if(egyezik(parameter, "seg�ts�g") || egyezik(parameter, "segitseg") || egyezik(parameter, "help"))
	{
		SendClientMessage(playerid, COLOR_GREEN, "=====[ Kuk�s munka haszn�lati �tmutat� ]=====");
		SendClientMessage(playerid, COLOR_WHITE, "A munk�t elkezdeni a /kuka munka paranccsal tudod.");
		SendClientMessage(playerid, COLOR_GRAD6, "Miut�n bele�lt�l egy kuk�skocsiba, egy h�zhoz kell menned, ahol fel kell venned a szemetet.");
		SendClientMessage(playerid, COLOR_GRAD5, "Ezt a kuk�skocsihoz �llva bele kell tenned a szem�tmegsemmis�t�be az Y megnyom�s�val.");
		SendClientMessage(playerid, COLOR_GRAD4, "Egy kuk�skocsiba maximum 20 szem�t f�r, �gy ha ez megtelik, el kell vinni a szem�ttelepre.");
		SendClientMessage(playerid, COLOR_GRAD3, "Ott a szem�tlerak� sz�l�hez kell �llni, ahol az Y megnyom�sa ut�n egy kis id� eltelt�vel ki�r�l a tart�ly.");
		SendClientMessage(playerid, COLOR_GRAD2, "Ekkor j�v��r�dik a fizet�sedhez a szemetek�rt kapott p�nz, majd folytathatod a munk�t, vagy befejezheted.");
		SendClientMessage(playerid, COLOR_GRAD1, "A j�t�kosok h�zai el�tt a szemetek a j�t�kosok fizet�seikor �jra lerak�dnak.");
	}
	return 1;
}

CMD:news(playerid, params[])
{
	new szoveg[128], jarmu = GetPlayerVehicleID(playerid);
	if(FloodCheck(playerid)) return 1;
	if(!LMT(playerid, FRAKCIO_RIPORTER)) return Msg(playerid, "Ez a parancs nem el�rhet� sz�modra");
	if(IsFrakcioKocsi(jarmu) != 9 && !IsAt(playerid, IsAt_Studio)) return Msg(playerid, "Riporter j�rm�ben kell lenned vagy a st�di�ban!");
	if(!Munkarang(playerid, 1)) return Msg(playerid, "Ez a parancs nem el�rhet� sz�modra");
	if(sscanf(params, "s[128]", szoveg)) return Msg(playerid, "/news [sz�veg]");
	if(strlen(szoveg) > 100) return Msg(playerid, "Maximum 100 karakter!");
	if(HirdetesSzidasEllenorzes(playerid, szoveg, "/news", ELLENORZES_HIRDETES)) return 1;
	
	if(strcmp(RadioMusorNev,"NINCS") == 0)
		format(_tmpString, sizeof(_tmpString), "R�di�s %s: %s", ICPlayerName(playerid), szoveg);
	else
		format(_tmpString, sizeof(_tmpString), "%s - %s: %s", RadioMusorNev, ICPlayerName(playerid), szoveg);
	SendMessage(SEND_MESSAGE_OOCNEWS, _tmpString, COLOR_NEWS);
	PlayerInfo[playerid][pNewsSkill] ++;
	return 1;
}

ALIAS(m9sorn2v):musornev;
CMD:musornev(playerid, params[])
{
	new musorcime[64], jarmu = GetPlayerVehicleID(playerid);
	if(!LMT(playerid, FRAKCIO_RIPORTER)) return Msg(playerid, "Ez a parancs nem el�rhet� sz�modra");
	//if(FBIadastiltas == 1) return Msg(playerid, "Az FBI betiltotta az ad�sokat!");
	if(IsFrakcioKocsi(jarmu) != 9 && !IsAt(playerid, IsAt_Studio)) return Msg(playerid, "Riporter j�rm�ben kell lenned vagy a st�di�ban!");
	if(!Munkarang(playerid, 1)) return Msg(playerid, "Ez a parancs nem el�rhet� sz�modra");
	if(PlayerInfo[playerid][pNewsSkill] < 101) return Msg(playerid, "A parancs haszn�lat�hoz minimum 3-as ripoter skill sz�ks�ges");
	if(sscanf(params, "s[64]", musorcime)) return Msg(playerid, "/m�sorn�v [M�sor neve]");
	if(strlen(musorcime) > 32) return Msg(playerid, "Maximum 32 karakteres lehet a m�sor c�me!");
	if(HirdetesSzidasEllenorzes(playerid, musorcime, "/m�sorn�v", ELLENORZES_HIRDETES)) return 1;
	if(egyezik(musorcime, "ki") || egyezik(musorcime, "NINCS"))
	{
		RadioMusorNev = "NINCS";
		Msg(playerid, "R�di� m�sorn�v kikapcsolva!");
		RadioAktivsag = UnixTime+300;
		PlayerInfo[playerid][pNewsSkill] ++;
		if(PlayerInfo[playerid][pNewsSkill] == 200)
			SendClientMessage(playerid, COLOR_YELLOW, "* A riporter skilled el�rte a 4es szintet! Mostm�r tudsz rep�lni a riporter helikopterrel!");
		else if(PlayerInfo[playerid][pNewsSkill] == 400)
			SendClientMessage(playerid, COLOR_YELLOW, "* A riporter skilled el�rte az 5�s szintet! Mostm�r tudsz felk�rni m�sokat, hogy �l� ad�sban szerepeljen, illetve tudsz zen�t ind�tani!");
		format(_tmpString, 128, "<< %s kikapcsolta a m�sornevek haszn�lat�t >>", PlayerName(playerid), musorcime);
		SendMessage(SEND_MESSAGE_FRACTION, _tmpString, COLOR_LIGHTRED, 9);
		EgyebLog(_tmpString);
		return 1;
	}
	RadioMusorNev = musorcime;
	SendFormatMessage(playerid, COLOR_GREEN, "Az �j m�sorn�v: %s, kikapcsol�shoz: /m�sorn�v ki", musorcime);
	RadioAktivsag = UnixTime+300;
	PlayerInfo[playerid][pNewsSkill] ++;
	if(PlayerInfo[playerid][pNewsSkill] == 200)
		SendClientMessage(playerid, COLOR_YELLOW, "* A riporter skilled el�rte a 4es szintet! Mostm�r tudsz rep�lni a riporter helikopterrel!");
	else if(PlayerInfo[playerid][pNewsSkill] == 400)
		SendClientMessage(playerid, COLOR_YELLOW, "* A riporter skilled el�rte a 5�s szintet! Mostm�r tudsz felk�rni m�sokat, hogy �l� ad�sban szerepeljen, illetve tudsz zen�t ind�tani!");
	format(_tmpString, 128, "<< %s megv�ltoztatta a m�sornevet erre: %s >>", PlayerName(playerid), musorcime);
	SendMessage(SEND_MESSAGE_FRACTION, _tmpString, COLOR_LIGHTRED, 9);
	EgyebLog(_tmpString);
	return 1;
}

ALIAS(handsup):megad;
CMD:megad(playerid, params[])
{
	if(FloodCheck(playerid)) return 1;
	if(NemMozoghat(playerid)) return Msg(playerid, "M�r k�s�, nem gondolod?");
	if(!PlayerInfo[playerid][pMegad])
	{
		PlayerInfo[playerid][pMegad] = true;
		Cselekves(playerid, "megadta mag�t");
		Msg(playerid, "Megadtad magadat. Kikapcsol�shoz �rd be ism�t a parancsot: /megad");
		
		ApplyAnimation(playerid, "ROB_BANK","SHP_HandsUp_Scr", 4.0, 0, 0, 0, 0, 1);
	}
	else
	{
		PlayerInfo[playerid][pMegad] = false;
		Msg(playerid, "M�r nem adod meg magadat. Bekapcsol�shoz �rd be ism�t a parancsot: /megad");
		ClearAnim(playerid);
	}
	return 1;
}

CMD:uninvite(playerid, params[])
{
	new target, reason[128], str[128];
	if(!PlayerInfo[playerid][pLeader]) return Msg(playerid, "Nem vagy leader");
	if(sscanf(params, "us[128]", target, reason)) return Msg(playerid, "/uninvite [N�v/ID] [Oka]");
	if(target == INVALID_PLAYER_ID) return Msg(playerid, "Nem l�tez� j�t�kos");
	if(PlayerInfo[playerid][pMember] != PlayerInfo[target][pMember]) return Msg(playerid, "� nem a te tagod");
	if(PlayerInfo[target][pLeader] > 0) return Msg(playerid, "Nem r�ghatod ki, mivel leader");
	if(FrakcioInfo[ PlayerInfo[playerid][pLeader] ][fUtolsoTagFelvetel] > (UnixTime - 300)) return SendFormatMessage(playerid, COLOR_LIGHTRED, "ClassRPG: Csak 5percenk�nt lehet tagot felvenni / kir�gni, m�g %dmp van h�tra", FrakcioInfo[ PlayerInfo[playerid][pLeader] ][fUtolsoTagFelvetel] - (UnixTime - 300));
	
	FrakcioInfo[PlayerInfo[playerid][pLeader]][fUtolsoTagFelvetel] = UnixTime;
	FrakcioInfo[PlayerInfo[playerid][pLeader]][fTagokSzama]--;
	SendFormatMessage(playerid, COLOR_GREEN, "ClassRPG: Kir�gtad %s-t a frakci�b�l, oka: %s", PlayerName(target), reason);
	SendFormatMessage(target, COLOR_GREEN, "ClassRPG: %s kir�gott a frakci�b�l, oka: %s", PlayerName(playerid), reason);
	format(str, 128, "<< ClassRPG: %s kir�gta %s-t a frakci�b�l - Oka: %s >>", PlayerName(playerid), PlayerName(target), reason);
	PlayerInfo[target][pMember] = 0;
	PlayerInfo[target][pRank] = 0;
	PlayerInfo[target][pChar] = 0;
	PlayerInfo[target][pSwattag] = 0;
	PlayerInfo[target][pSwatRang] = 0;
	SetSpawnInfo(target, SPAWNID, PlayerInfo[playerid][pModel],0.0,0.0,0.0,0,0,0,0,0,0,0);
	SpawnPlayer(target);
	foreach(Jatekosok, p)
	{
		if(LMT(p, PlayerInfo[playerid][pMember]))
			SendClientMessage(p, COLOR_LIGHTRED, str);
	}
	
	format(_tmpString, 128, "UPDATE %s SET Member='%d' WHERE ID='%d'", SQL_DB_Player, PlayerInfo[playerid][pLeader], SQLID(target));
	doQuery( _tmpString );
	
	return 1;
}

CMD:invite(playerid, params[])
{
	new target, str[128];
	if(!PlayerInfo[playerid][pLeader]) return Msg(playerid, "Nem vagy leader");
	if(sscanf(params, "u", target)) return Msg(playerid, "/invite [N�v/ID]");
	if(target == INVALID_PLAYER_ID) return Msg(playerid, "Nem l�tez� j�t�kos");
	if(PlayerInfo[target][pMember] > 0) return Msg(playerid, "� m�r tag valahol");
	if(PlayerInfo[target][pLeader] > 0) return Msg(playerid, "� m�r leader valahol");
	if(PlayerInfo[target][pFrakcioTiltIdo]) return SendFormatMessage(playerid, COLOR_LIGHTRED, "ClassRPG: � el van tiltva a frakci�kt�l, oka: %s, m�g %d �r�ig", PlayerInfo[target][pFrakcioTiltOk], PlayerInfo[target][pFrakcioTiltIdo]);
	if(PlayerInfo[playerid][pLeader] < 1 || PlayerInfo[playerid][pLeader] > sizeof(Szervezetneve)) return 1;
	if(FrakcioInfo[ PlayerInfo[playerid][pLeader] ][fUtolsoTagFelvetel] > (UnixTime - 300)) return SendFormatMessage(playerid, COLOR_LIGHTRED, "ClassRPG: Csak 5percenk�nt lehet tagot felvenni / kir�gni, m�g %dmp van h�tra", FrakcioInfo[ PlayerInfo[playerid][pLeader] ][fUtolsoTagFelvetel] - (UnixTime - 300));
	if(FrakcioInfo[ PlayerInfo[playerid][pLeader] ][fTagokSzama] >= SzervezetLimit[ PlayerInfo[playerid][pLeader] - 1 ]) return Msg(playerid, "A frakci� tele van");
	if(Invitejog[target]) return Msg(playerid, "� m�r meg van h�vva valahova, �gy nem tudsz megh�v�st k�ldeni neki");
	
	Invitejog[target] = PlayerInfo[playerid][pMember];
	SendFormatMessage(playerid, COLOR_GREEN, "ClassRPG: Megh�vtad %s-t, hogy csatlakozzon hozz�tok, ha elfogadja, tagg� v�lik", PlayerName(target));
	SendFormatMessage(target, COLOR_LIGHTBLUE, "ClassRPG: %s megh�vott t�ged, hogy csatlakozz a(z) %s frakci�hoz.", PlayerName(playerid), Szervezetneve[PlayerInfo[playerid][pLeader] - 1][1]);
	SendClientMessage(target, COLOR_LIGHTBLUE, "ClassRPG: Elfogad�shoz haszn�ld a /accept invite parancsot, elutas�t�shoz pedig a /cancel invite parancsot.");
	format(str, 128, "<< ClassRPG: %s megh�vta %s-t a frakci�ba, ha elfogadja, tagg� v�lik >>", PlayerName(playerid), PlayerName(target));
	foreach(Jatekosok, p)
	{
		if(LMT(p, PlayerInfo[playerid][pMember]))
			SendClientMessage(p, COLOR_LIGHTRED, str);
	}
	return 1;
}

CMD:tvisz(playerid, params[])
{
	new jatekos = jatekos = GetClosestPlayer(playerid);
	if(!LMT(playerid, FRAKCIO_TUZOLTO)) 
		return Msg(playerid, "Nem vagy tuzolt�!");
	if(Visz[playerid] != NINCS)
	{
		SendClientMessage(playerid, COLOR_LIGHTBLUE, "Elengedted");
		Visz[playerid] = NINCS;
		return 1;
	}
		
	if(!IsPlayerConnected(jatekos)) 
		return 1;
	
	if(GetDistanceBetweenPlayers(playerid, jatekos) > 3)
		return Msg(playerid, "Nincs a k�zeledben!");
	
	for(new t = 0; t < TUZ_MAX; t++)
	{
		if(!Tuz[t][tuzAktiv])
			continue;
		
		if(!PlayerToPoint(TUZ_SERULES_TAV, jatekos, ArrExt( Tuz[t][tPoz] )))
			return Msg(playerid, "� nincs a tuzben!");
			
		Visz[playerid] = jatekos;
		Msg(playerid, "Megfogtad �s elkezdted h�zni �t, siess, nehogy komolyabb baja essen!", false, COLOR_LIGHTBLUE);
		Cselekves(playerid, "elkezdett valakit kih�zni a l�ngok k�z�l");
	}
	
	return 1;
}

CMD:aszint(playerid, params[])
{
	if(!Admin(playerid, 1337)) return 1;
	new szint;
	if(sscanf(params, "d", szint)) return Msg(playerid, "/aszint [szint] - Saj�t szint megv�ltoztat�sa IDEIGLENESEN!!");
	
	SetPlayerScore(playerid, szint);
	ASzint[playerid] = szint;
	SendFormatMessage(playerid, COLOR_LIGHTRED, "Szinted �t�rva ideiglenesen ennyire: %d, ne feledd, ez csak relogig j�!", szint);
	return 1;
}

ALIAS(anev):an2v;
CMD:an2v(playerid, params[])
{
	if(!Admin(playerid,1337)) return 1;

	new namee[MAX_PLAYER_NAME];
	if(sscanf(params, "s[25]", namee)) return Msg(playerid, "/anev [n�v]");
	
	switch(SetPlayerName(playerid, namee))
    {
        case -1: SendClientMessage(playerid, 0xFF0000FF, "Hiba �rv�nytelen!");
        case 0: SendClientMessage(playerid, 0xFF0000FF, "M�r ez a neved most is!");
        case 1: SendClientMessage(playerid, 0x00FF00FF, "Neved �t�rva"), PlayerInfo[playerid][pHamisNev]=namee;
    }

	return 1;
}

ALIAS(mobiledatacomputer):mdc;
CMD:mdc(playerid, params[])
{
	new type[16], subtype[32];
	if(!IsACop(playerid)) return Msg(playerid, "Nem vagy rend�r!");
	if(OnDuty[playerid] != 1 && AdminDuty[playerid] != 1) return Msg(playerid, "Nem vagy szolg�latban!");
	if(sscanf(params, "s[16]S()[32]", type, subtype)) return Msg(playerid, "/mdc [j�t�kos/j�rm�]");
	if(egyezik(type, "j�t�kos") || egyezik(type, "jatekos") || egyezik(type, "player"))
	{
		new target;
		if(sscanf(subtype, "u", target)) return Msg(playerid, "/mdc j�t�kos [N�v/ID]");
		if(target == INVALID_PLAYER_ID) return Msg(playerid, "Nincs ilyen j�t�kos!");
		SendClientMessage(playerid, TEAM_BLUE_COLOR, "==========[ MOBILE DATA COMPUTER ]==========");
		SendFormatMessage(playerid, COLOR_WHITE, "N�v: %s", ICPlayerName(target));
		SendFormatMessage(playerid, COLOR_WHITE, "B�n: %s", PlayerCrime[target][pVad]);
		SendFormatMessage(playerid, COLOR_WHITE, "Jelent�: %s", PlayerCrime[target][pJelento]);
		SendClientMessage(playerid, TEAM_BLUE_COLOR,"==========[ MOBILE DATA COMPUTER ]==========");
	}
	else if(egyezik(type, "j�rm�") || egyezik(type, "jarmu") || egyezik(type, "vehicle"))
	{
		new target;
		if(sscanf(subtype, "i", target)) return Msg(playerid, "/mdc j�rm� [Rendsz�m]");
		if(target == INVALID_VEHICLE_ID) return Msg(playerid, "Nincs ilyen j�rm�");
		SendClientMessage(playerid, TEAM_BLUE_COLOR, "==========[ MOBILE DATA COMPUTER ]==========");
		SendFormatMessage(playerid, COLOR_WHITE, "Rendsz�m: CLS-%d", target);
		SendFormatMessage(playerid, COLOR_WHITE, "J�rm� t�pus: %s", GetVehicleModelName(GetVehicleModel(target)-400));
		SendFormatMessage(playerid, COLOR_WHITE, "B�n: %s", VehicleCrime[target][vVad]);
		SendFormatMessage(playerid, COLOR_WHITE, "Jelent�: %s", VehicleCrime[target][vJelento]);
		SendClientMessage(playerid, TEAM_BLUE_COLOR,"==========[ MOBILE DATA COMPUTER ]==========");
	}
	return 1;
}

ALIAS(su):suspect;
CMD:suspect(playerid, params[])
{
	new type[16], subtype[32];
	if(!IsACop(playerid)) return Msg(playerid, "Nem vagy rend�r!");
	if(OnDuty[playerid] != 1) return Msg(playerid, "Nem vagy szolg�latban!");
	if(sscanf(params, "s[16]S()[32]", type, subtype)) return Msg(playerid, "/suspect [j�t�kos/j�rm�]");
	if(egyezik(type, "j�t�kos") || egyezik(type, "jatekos") || egyezik(type, "player"))
	{
		new target, crime[128];
		if(sscanf(subtype, "us[128]", target, crime)) return Msg(playerid, "/suspect j�t�kos [N�v/ID] [B�ntett]");
		if(target == INVALID_PLAYER_ID) return Msg(playerid, "Nincs ilyen j�t�kos!");
		if(IsACop(target)) return Msg(playerid, "Rend�rt nem lehet feljelenteni!");
		SendFormatMessage(playerid, COLOR_LIGHTRED, "ClassRPG: Sikeresen feljelentetted %s-t!", ICPlayerName(target));
		SetPlayerCriminal(target, playerid, crime);
	}
	if(egyezik(type, "j�rm�") || egyezik(type, "jarmu") || egyezik(type, "vehicle"))
	{
		new target, crime[128];
		if(sscanf(subtype, "is[128]", target, crime)) return Msg(playerid, "/suspect j�rm� [Rendsz�m] [B�ntett]");
		if(target == INVALID_VEHICLE_ID) return Msg(playerid, "Nincs ilyen j�rm�");
		if(IsACopCar(target)) return Msg(playerid, "Rend�rkocsit nem lehet feljelenteni!");
		SendFormatMessage(playerid, COLOR_LIGHTRED, "ClassRPG: Sikeresen feljelentetted a CLS-%d rendsz�m� j�rm�vet!", target);
		SetVehicleCriminal(target, playerid, crime);
	}
	return 1;
}

CMD:karszalag(playerid, params[])
{
	if(FloodCheck(playerid, 1, 3)) return 1;

	new type[16], subtype[32];
	new time = UnixTime;
	if(sscanf(params, "s[16]S()[32]", type, subtype)) Msg(playerid, "Haszn�lata: /karszalag [megn�z / vesz / mutat]");

	if(egyezik(type, "megn�z") || egyezik(type, "megnez"))
	{
		if(PlayerInfo[playerid][pMoriartySzalag] == 1 && PlayerInfo[playerid][pMoriartySzalagIdo] > time)
		{
			new kulonbseg, ora, perc;
			kulonbseg = PlayerInfo[playerid][pMoriartySzalagIdo] - UnixTime;
			ora = floatround((float(kulonbseg) / 3600.0), floatround_floor);
			perc = floatround((float(kulonbseg) / 60.0), floatround_floor) % 60;
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Szalag: Van - M�g %d�ra �s %dpercig �rv�nyes", ora, perc);
			Cselekves(playerid, "megn�zte a szalagj�t.");
		}
		if(PlayerInfo[playerid][pMoriartySzalag] == 1 && PlayerInfo[playerid][pMoriartySzalagIdo] < time) 
		{
			Msg(playerid, "Szalag: �rv�nytelen");
			Cselekves(playerid, "megn�zte a szalagj�t.");
		}
		if(PlayerInfo[playerid][pMoriartySzalag] == 0)
		{
			Msg(playerid, "Szalag: Nincs");
			Cselekves(playerid, "megn�zte a szalagj�t.");
		}
	}
	else if(egyezik(type, "megmutat"))
	{
		if(PlayerInfo[playerid][pMoriartySzalag] == 0)
			return Msg(playerid, "Nincs szalagod!");

		new player;
		
		if(sscanf(subtype, "u", player)) return Msg(playerid, "/karszalag megmutat [N�v / ID]");

		if(player == INVALID_PLAYER_ID)
			return Msg(playerid, "Nincs ilyen j�t�kos");
		if(GetDistanceBetweenPlayers(player, playerid) > 3.0)
			return Msg(playerid, "Nincs a k�zeledben");
			
		if(PlayerInfo[playerid][pMoriartySzalag] == 1 && PlayerInfo[playerid][pMoriartySzalagIdo] > time)
		{
			new kulonbseg, ora, perc;
			kulonbseg = PlayerInfo[playerid][pJegy] - time;
			ora = floatround((float(kulonbseg) / 3600.0), floatround_floor);
			perc = floatround((float(kulonbseg) / 60.0), floatround_floor) % 60;
			SendFormatMessage(player, COLOR_LIGHTGREEN, "%s Szalagja: Van - M�g %d�ra �s %dpercig �rv�nyes", ICPlayerName(playerid), ora, perc);
			Msg(playerid, "Megmutattad a szalagod valakinek");
			Cselekves(playerid, "Megmutatta a szalagj�t valakinek");
		}
		if(PlayerInfo[playerid][pMoriartySzalag] == 1 && PlayerInfo[playerid][pMoriartySzalagIdo] < time) 
		{
			Msg(player, "Szalag: �rv�nytelen");
			Msg(playerid, "Megmutattad a szalagod valakinek");
			Cselekves(playerid, "Megmutatta a szalagj�t valakinek");
		}
	}
	else if(egyezik(type, "vesz"))
	{
		if(PlayerInfo[playerid][pMoriartySzalag] > 0)
			return Msg(playerid, "M�r van szalagod");

		if(!PlayerToPoint(2, playerid, BizzInfo[BIZ_MORIARTY][bEntranceX] , BizzInfo[BIZ_MORIARTY][bEntranceY] , BizzInfo[BIZ_MORIARTY][bEntranceZ]))
			return SendFormatMessage(playerid, COLOR_LIGHTRED, "Nem vagy a(z) %s el�tt!", BizzInfo[BIZ_MORIARTY][bMessage]);
				
		BizPenz(BIZ_MORIARTY, BizzInfo[BIZ_MORIARTY][bEntranceCost]);
		
		PlayerInfo[playerid][pMoriartySzalagIdo] = time + 86400;
	}
	return 1;
}

ALIAS(szerv3zk5nyv):szervizkonyv;
ALIAS(szervizk5nyv):szervizkonyv;
CMD:szervizkonyv(playerid, params[])
{
	new target, car = GetPlayerVehicleID(playerid);
	if(!IsPlayerInAnyVehicle(playerid)) return Msg(playerid, "A szervizk�nyv a kocsiban van");
	if(sscanf(params, "u", target)) return Msg(playerid, "/szervizk�nyv [N�v/ID]");
	if(target == INVALID_PLAYER_ID) return Msg(playerid, "Nincs ilyen j�t�kos");
	if(GetDistanceBetweenPlayers(playerid, target) > 4.0) return Msg(playerid, "Nincs a k�zeledben");
	if(IsABicikli(car)) return Msg(playerid, "Ennek nincs szervizk�nyve");
	new tulaj = IsAVsKocsi(car);
	new frakcio;
	new id = NINCS;
	for(new k = 0; k < MAX_FRAKCIOKOCSI; k++)
	{
		for(new kk = 0; kk  <MAX_FRAKCIO; kk++)
		{
			if(!FrakcioKocsi[kk][k][fVan]) continue;
			
			if(FrakcioKocsi[kk][k][fVan] && FrakcioKocsi[kk][k][fID] == car)
			{
				frakcio=kk;
				id = k;
				break;
			}
		}
	}
	new legutoljara = (UnixTime - CarPart[car][cSzervizdatum]) / 3600;
	
	
	
	new Float:serules = (1000.0 - KocsiElete[car]) / 6.5;
	if(IsAPancelozottKocsi(car))
		serules = (100000.0 - KocsiElete[car]) / 996.5;
		
	if(serules < 0.0)
		serules = 0.0;
	else if(serules > 100.0)
		serules = 100.0;
			
	SendFormatMessage(target, COLOR_GREEN, "=====[ CLS-%d j�rmu szervizk�nyve ]=====", car);
	if(tulaj != NINCS)
		SendFormatMessage(target, COLOR_LIGHTGREEN, "J�rm� tulajdonosa: %s", CarInfo[tulaj][cOwner]);
	else
		SendClientMessage(target, COLOR_LIGHTGREEN, "J�rm� tulajdonosa: C�ges tulajdon");
	SendFormatMessage(target, COLOR_LIGHTGREEN, "J�rm� t�pusa: %s", GetVehicleModelName(GetVehicleModel(car)-400));
	if(tulaj != NINCS)
		SendFormatMessage(target,COLOR_WHITE,"J�rm� sz�nk�dja: %d & %d",CarInfo[tulaj][cColorOne], CarInfo[tulaj][cColorTwo]);
	else if(id != NINCS)
		SendFormatMessage(target,COLOR_WHITE,"J�rm� sz�nk�dja: %d & %d",FrakcioKocsi[frakcio][id][fSzin][0], FrakcioKocsi[frakcio][id][fSzin][1]);
	else	
		SendClientMessage(target,COLOR_WHITE,"J�rm� sz�nk�dja: Nincs bejegyezve");
	SendFormatMessage(target, COLOR_WHITE, "Futott kilom�ter: %.2f km", KmSzamol[car]/1000);
	SendFormatMessage(target, COLOR_WHITE, "Kerekek: %.2f sz�zal�kban elhaszn�l�dott", CarPart[car][cKerekek]);
	SendFormatMessage(target, COLOR_WHITE, "Motorolaj: %.2f sz�zal�kban elhaszn�l�dott", CarPart[car][cMotorolaj]);
	SendFormatMessage(target, COLOR_WHITE, "Akkumul�tor t�lt�tts�ge: %.2f sz�zal�k", CarPart[car][cAkkumulator]);
	SendFormatMessage(target, COLOR_WHITE, "Motor: %.2f sz�zal�kban elhaszn�l�dott", CarPart[car][cMotor]/5); // Val�s �rt�ket mutasson, ne azt h pl. 300%-ban elhaszn�l�dott
	SendFormatMessage(target, COLOR_WHITE, "F�k: %.2f sz�zal�kban elhaszn�l�dott", CarPart[car][cFek]);
	SendFormatMessage(target, COLOR_WHITE, "Elektronika: %.2f sz�zal�kban elhaszn�l�dott", CarPart[car][cElektronika]);
	SendFormatMessage(target, COLOR_WHITE, "Karossz�ria: %d alkalommal volt cser�lve", CarPart[car][cKarosszeria]);
	SendFormatMessage(target, COLOR_WHITE, "Karossz�ria: %.0f sz�zal�kban k�rosodott", serules);
	if(legutoljara > 250)
		SendClientMessage(target, COLOR_LIGHTGREEN, "A j�rm� m�g nem volt szervizben");
	else
		SendFormatMessage(target, COLOR_LIGHTGREEN, "A j�rm� legutolj�ra szervizben volt: %d napja", legutoljara);
		
	if(target == playerid)
		Cselekves(playerid, "el�vette az aut� szervizk�nyv�t, �s megn�zte.");
	else
		Cselekves(playerid, "el�vette az aut� szervizk�nyv�t, �s megmutatta valakinek.");
	
	return 1;
}

ALIAS(repair):szereles;
ALIAS(szerel2s):szereles;
CMD:szereles(playerid, params[])
{
	new target, mit[32], sub[64], mennyiert, car = GetClosestVehicle(playerid);
	if(PlayerInfo[playerid][pSzerelo] < 1) return Msg(playerid, "Nem vagy szerel�");
	if(OnDuty[playerid]) return Msg(playerid, "D�ntsd el�bb el mit dolgozol! ((frakci� dutyba nem!))");
	
	if(IsPlayerInAnyVehicle(playerid)) return Msg(playerid,"Kocsiban nem tudsz szerelni");
	if(GetPlayerDistanceFromVehicle(playerid, car) > 10) return Msg(playerid, "Nincs a k�zeledben j�rm�");
	
	if((IsAPRepulo(car) || IsAMotor(car) || IsARepulo(car) || IsAPlane(car)) && !IsAt(playerid, IsAt_SzereloHely))
	{
		new szkocsi=GetClosestVehicle(playerid, false, 525);
		if(GetPlayerDistanceFromVehicle(playerid, szkocsi) > 10) return Msg(playerid, "Nincs a k�zeledben szerel� kocsi!");
	}
	
	if(!IsAt(playerid, IsAt_SzereloHely) && !(IsAPRepulo(car) || IsAMotor(car) || IsARepulo(car) || IsAPlane(car))) return Msg(playerid, "Itt nem tudsz jav�tani");
		
	if(sscanf(params, "s[32]S()[64]", mit, sub))
	{
		Msg(playerid, "/szerel�s [Kerekek/Motorolaj/Akkumul�tor/Motor/Elektronika/F�k/Karossz�ria] [N�v/ID] [�r]");
		Msg(playerid, "J�rmu �llapotfelm�r�se: /szerel�s �llapot");
		return 1;
	}
	if(IsABicikli(car)) return Msg(playerid, "Ezt nem lehet megjav�tani");
	if(egyezik(mit, "Kerekek"))
	{
		if(sscanf(sub, "ui", target, mennyiert)) return Msg(playerid, "/szerel�s kerekek [N�v/ID] [�ra]");
		if(target == playerid)
		{
			new panels, doors, lights, tires;
			if(!BankkartyaFizet(playerid, 150000)) return Msg(playerid, "ClassRPG: Nincs el�g p�nzed, a garnit�ra gumi �ra: 150,000Ft!");
			Cselekves(playerid,"kicser�lte a j�rm�v�n az abroncsokat.",0);
			GetVehicleDamageStatus(car, panels, doors, lights, tires);
			UpdateVehicleDamageStatus(car, panels, doors, lights, 0);
			SendClientMessage(playerid, COLOR_LIGHTBLUE, "Kicser�lted a gumikat, a gumi �ra: 150,000Ft");
			BizPenz(BIZ_AUTOSBOLT, 150000);
			CarPart[car][cKerekek] = 0.0;
			CarPart[car][cSzervizdatum] = UnixTime;
		}
		else
		{
			if(target == INVALID_PLAYER_ID) return Msg(playerid, "Nem l�tez� j�t�kos");
			if(GumitCserel[target]) return Msg(playerid, "M�r fel lett aj�nlva neki!");
			if(mennyiert < 150000 || mennyiert > 300000) return Msg(playerid, "Az �ra minimum 150 000 Ft, max 300 000 Ft lehet!");
			if(GetDistanceBetweenPlayers(playerid, target) > 8.0) return Msg(playerid, "Nincs a k�zeledben!");
			if(!IsPlayerInAnyVehicle(target)) return Msg(playerid, "Nem �l j�rm�ben!");
			SendFormatMessage(playerid, COLOR_LIGHTBLUE, "* Felaj�nlottad %s-nak, hogy kicser�led a gumikat %dFT-�rt", ICPlayerName(target), mennyiert);
			SendFormatMessage(target, COLOR_LIGHTBLUE, "* Aut�szerel� %s felaj�nlotta, hogy kicser�li a gumikat %dFT-�rt.", ICPlayerName(playerid), mennyiert);
			SendClientMessage(target, COLOR_LIGHTBLUE, "Ha el akarod fogadni /accept repair");
			JavitasAra[target] += mennyiert;
			GumitCserel[target] = true;
			AlkatreszAr[target] += 150000;
			NekiSzerel[target] = playerid;
		}
	}
	if(egyezik(mit, "Motorolaj"))
	{
		if(sscanf(sub, "ui", target, mennyiert)) return Msg(playerid, "/szerel�s motorolaj [N�v/ID] [�ra]");
		if(target == playerid)
		{
			if(!BankkartyaFizet(playerid, 25000)) return Msg(playerid, "Nincs el�g p�nzed, az olaj �ra: 25,000Ft!");
			Cselekves(playerid,"kicser�lte a j�rmuv�ben az olajat.",0);
			SendClientMessage(playerid, COLOR_LIGHTBLUE, "Kicser�lted az olajat, az �ra: 25,000Ft");
			BizPenz(BIZ_AUTOSBOLT, 25000);
			CarPart[car][cMotorolaj] = 0.0;
			CarPart[car][cSzervizdatum] = UnixTime;
		}
		else
		{
			if(target == INVALID_PLAYER_ID) return Msg(playerid, "Nem l�tez� j�t�kos");
			if(OlajatCserel[target]) return Msg(playerid, "M�r fel lett aj�nlva neki!");
			if(mennyiert < 25000 || mennyiert > 50000) return Msg(playerid, "Az �ra minimum 25 000 Ft, max 50 000 Ft lehet!");
			if(GetDistanceBetweenPlayers(playerid, target) > 8.0) return Msg(playerid, "Nincs a k�zeledben!");
			if(!IsPlayerInAnyVehicle(target)) return Msg(playerid, "Nem �l j�rmuben!");
			SendFormatMessage(playerid, COLOR_LIGHTBLUE, "* Felaj�nlottad %s-nak, hogy kicser�led az olajat %dFT-�rt", ICPlayerName(target), mennyiert);
			SendFormatMessage(target, COLOR_LIGHTBLUE, "* Aut�szerel� %s felaj�nlotta, hogy kicser�li az olajat %dFT-�rt.", ICPlayerName(playerid), mennyiert);
			SendClientMessage(target, COLOR_LIGHTBLUE, "Ha el akarod fogadni /accept repair");
			JavitasAra[target] += mennyiert;
			OlajatCserel[target] = true;
			AlkatreszAr[target] += 25000;
			NekiSzerel[target] = playerid;
		}
	}
	if(egyezik(mit, "Akkumul�tor") || egyezik(mit, "Akkumulator") || egyezik(mit, "Akku"))
	{
		if(sscanf(sub, "ui", target, mennyiert)) return Msg(playerid, "/szerel�s akkumul�tor [N�v/ID] [�ra]");
		if(target == playerid)
		{
			if(!BankkartyaFizet(playerid, 25000)) return Msg(playerid, "ClassRPG: Nincs el�g p�nzed, az akku �ra: 25,000Ft!");
			Cselekves(playerid,"kicser�lte a j�rm�v�ben az akkumul�tort.",0);
			SendClientMessage(playerid, COLOR_LIGHTBLUE, "Kicser�lted az akkut, az �ra: 25,000Ft");
			BizPenz(BIZ_AUTOSBOLT, 25000);
			CarPart[car][cAkkumulator] = 100.0;
			CarPart[car][cSzervizdatum] = UnixTime;
		}
		else
		{
			if(target == INVALID_PLAYER_ID) return Msg(playerid, "Nem l�tez� j�t�kos");
			if(AkkutCserel[target]) return Msg(playerid, "M�r fel lett aj�nlva neki!");
			if(mennyiert < 25000 || mennyiert > 55000) return Msg(playerid, "Az �ra minimum 25 000 Ft, max 55 000 Ft lehet!");
			if(target == INVALID_PLAYER_ID) return Msg(playerid, "Nem l�tez� j�t�kos");
			if(GetDistanceBetweenPlayers(playerid, target) > 8.0) return Msg(playerid, "Nincs a k�zeledben!");
			if(!IsPlayerInAnyVehicle(target)) return Msg(playerid, "Nem �l j�rmuben!");
			SendFormatMessage(playerid, COLOR_LIGHTBLUE, "* Felaj�nlottad %s-nak, hogy kicser�led az akkut %dFT-�rt", ICPlayerName(target), mennyiert);
			SendFormatMessage(target, COLOR_LIGHTBLUE, "* Aut�szerel� %s felaj�nlotta, hogy kicser�li az akkumul�tort %dFT-�rt.", ICPlayerName(playerid), mennyiert);
			SendClientMessage(target, COLOR_LIGHTBLUE, "Ha el akarod fogadni /accept repair");
			JavitasAra[target] += mennyiert;
			AkkutCserel[target] = true;
			AlkatreszAr[target] += 25000;
			NekiSzerel[target] = playerid;
		}
	}
	if(egyezik(mit, "Motor"))
	{
		if(sscanf(sub, "ui", target, mennyiert)) return Msg(playerid, "/szerel�s motor [N�v/ID] [�ra]");
		if(target == playerid)
		{
			if(!BankkartyaFizet(playerid, 300000)) return Msg(playerid, "ClassRPG: Nincs el�g p�nzed, a motor �ra: 300,000Ft!");
			Cselekves(playerid,"kicser�lte a j�rm�v�ben a motort.",0);
			SendClientMessage(playerid, COLOR_LIGHTBLUE, "Kicser�lted a motort, az �ra: 300,000Ft");
			BizPenz(BIZ_AUTOSBOLT, 300000);
			CarPart[car][cMotor] = 0.0;
			SetVehicleHealth(car, 1000);
			CarPart[car][cSzervizdatum] = UnixTime;
		}
		else
		{
			if(target == INVALID_PLAYER_ID) return Msg(playerid, "Nem l�tez� j�t�kos");
			if(MotortCserel[target]) return Msg(playerid, "M�r fel lett aj�nlva neki!");
			if(mennyiert < 300000 || mennyiert > 600000) return Msg(playerid, "Az �ra minimum 300 000 Ft, max 600 000 Ft lehet!");
			if(GetDistanceBetweenPlayers(playerid, target) > 8.0) return Msg(playerid, "Nincs a k�zeledben!");
			if(!IsPlayerInAnyVehicle(target)) return Msg(playerid, "Nem �l j�rmuben!");
			SendFormatMessage(playerid, COLOR_LIGHTBLUE, "* Felaj�nlottad %s-nak, hogy kicser�led a motort %dFT-�rt", ICPlayerName(target), mennyiert);
			SendFormatMessage(target, COLOR_LIGHTBLUE, "* Aut�szerel� %s felaj�nlotta, hogy kicser�li a motort %dFT-�rt.", ICPlayerName(playerid), mennyiert);
			SendClientMessage(target, COLOR_LIGHTBLUE, "Ha el akarod fogadni /accept repair");
			JavitasAra[target] += mennyiert;
			MotortCserel[target] = true;
			AlkatreszAr[target] += 300000;
			NekiSzerel[target] = playerid;
		}
	}
	if(egyezik(mit, "Elektronika"))
	{
		if(sscanf(sub, "ui", target, mennyiert)) return Msg(playerid, "/szerel�s elektronika [N�v/ID] [�ra]");
		if(target == playerid)
		{
			if(!BankkartyaFizet(playerid, 70000)) return Msg(playerid, "ClassRPG: Nincs el�g p�nzed, az elektronika �ra: 70,000Ft!");
			Cselekves(playerid,"kicser�lte a j�rm�v�ben az elektronik�t.",0);
			SendClientMessage(playerid, COLOR_LIGHTBLUE, "Kicser�lted az elektronik�t, az �ra: 70,000Ft");
			BizPenz(BIZ_AUTOSBOLT, 70000);
			CarPart[car][cElektronika] = 0.0;
			CarPart[car][cSzervizdatum] = UnixTime;
		}
		else
		{
			if(target == INVALID_PLAYER_ID) return Msg(playerid, "Nem l�tez� j�t�kos");
			if(ElektronikatCserel[target]) return Msg(playerid, "M�r fel lett aj�nlva neki!");
			if(mennyiert < 70000 || mennyiert > 140000) return Msg(playerid, "Az �ra minimum 70 000 Ft, max 140 000 Ft lehet!");
			if(GetDistanceBetweenPlayers(playerid, target) > 8.0) return Msg(playerid, "Nincs a k�zeledben!");
			if(!IsPlayerInAnyVehicle(target)) return Msg(playerid, "Nem �l j�rmuben!");
			SendFormatMessage(playerid, COLOR_LIGHTBLUE, "* Felaj�nlottad %s-nak, hogy kicser�led az elektronik�t %dFT-�rt", ICPlayerName(target), mennyiert);
			SendFormatMessage(target, COLOR_LIGHTBLUE, "* Aut�szerel� %s felaj�nlotta, hogy kicser�li az elektronik�t %dFT-�rt.", ICPlayerName(playerid), mennyiert);
			SendClientMessage(target, COLOR_LIGHTBLUE, "Ha el akarod fogadni /accept repair");
			JavitasAra[target] += mennyiert;
			ElektronikatCserel[target] = true;
			AlkatreszAr[target] += 70000;
			NekiSzerel[target] = playerid;
		}
	}
	if(egyezik(mit, "F�k") || egyezik(mit, "Fek"))
	{
		if(sscanf(sub, "ui", target, mennyiert)) return Msg(playerid, "/szerel�s f�k [N�v/ID] [�ra]");
		if(target == playerid)
		{
			if(!BankkartyaFizet(playerid, 40000)) return Msg(playerid, "ClassRPG: Nincs el�g p�nzed, a f�kbet�t �ra: 40,000Ft!");
			Cselekves(playerid,"kicser�lte a j�rm�v�ben a f�kbet�tet.",0);
			SendClientMessage(playerid, COLOR_LIGHTBLUE, "Kicser�lted a f�ket, az �ra: 40,000Ft");
			BizPenz(BIZ_AUTOSBOLT, 40000);
			CarPart[car][cFek] = 0.0;
			CarPart[car][cSzervizdatum] = UnixTime;
		}
		else
		{
			if(target == INVALID_PLAYER_ID) return Msg(playerid, "Nem l�tez� j�t�kos");
			if(FeketCserel[target]) return Msg(playerid, "M�r fel lett aj�nlva neki!");
			if(mennyiert < 40000 || mennyiert > 100000) return Msg(playerid, "Az �ra minimum 40 000 Ft, max 100 000 Ft lehet!");
			if(GetDistanceBetweenPlayers(playerid, target) > 8.0) return Msg(playerid, "Nincs a k�zeledben!");
			if(!IsPlayerInAnyVehicle(target)) return Msg(playerid, "Nem �l j�rmuben!");
			SendFormatMessage(playerid, COLOR_LIGHTBLUE, "* Felaj�nlottad %s-nak, hogy kicser�led a f�ket %dFT-�rt", ICPlayerName(target), mennyiert);
			SendFormatMessage(target, COLOR_LIGHTBLUE, "* Aut�szerel� %s felaj�nlotta, hogy kicser�li a f�kbet�tet %dFT-�rt.", ICPlayerName(playerid), mennyiert);
			SendClientMessage(target, COLOR_LIGHTBLUE, "Ha el akarod fogadni /accept repair");
			JavitasAra[target] += mennyiert;
			FeketCserel[target] = true;
			AlkatreszAr[target] += 40000;
			NekiSzerel[target] = playerid;
		}
	}
	if(egyezik(mit, "Karossz�ria") || egyezik(mit, "Karosszeria"))
	{
		if(sscanf(sub, "ui", target, mennyiert)) return Msg(playerid, "/szerel�s karosszeria [N�v/ID] [�ra]");
		if(target == playerid)
		{
			if(!BankkartyaFizet(playerid, 10000)) return Msg(playerid, "ClassRPG: Nincs el�g p�nzed, a karossz�riacsere �ra: 10,000Ft!");
			Cselekves(playerid,"kicser�lte a j�rm�v�n a karossz�ri�t.",0);
			SendClientMessage(playerid, COLOR_LIGHTBLUE, "Kicser�lted a karossz�ri�t, az �ra: 10,000Ft");
			BizPenz(BIZ_AUTOSBOLT, 10000);
			new panels, doors, lights, tires;	
			GetVehicleDamageStatus(car, panels, doors, lights, tires);
			UpdateVehicleDamageStatus(car, 0, 00000000, 0, tires);
			CarPart[car][cKarosszeria] += 1;
			if(IsAPancelozottKocsi(car))
				SetVehicleHealth(car, 100000);
			else
				SetVehicleHealth(car, 1000);
			CarPart[car][cSzervizdatum] = UnixTime;
		}
		else
		{
			if(target == INVALID_PLAYER_ID) return Msg(playerid, "Nem l�tez� j�t�kos");
			if(KarosszeriatCserel[target]) return Msg(playerid, "M�r fel lett aj�nlva neki!");
			if(mennyiert < 10000 || mennyiert > 100000) return Msg(playerid, "Az �ra minimum 10 000 Ft, max 100 000 Ft lehet!");
			if(GetDistanceBetweenPlayers(playerid, target) > 8.0) return Msg(playerid, "Nincs a k�zeledben!");
			if(!IsPlayerInAnyVehicle(target)) return Msg(playerid, "Nem �l j�rmuben!");
			new veh = GetVehicleModel(car)-400;
			new ertek = JarmuAra[veh][jAra]; new serules;
			if(ertek < 20000000) serules = Rand(10000, 40000);
			elseif(ertek >= 20000000 || ertek < 40000000) serules = Rand(20000, 60000);
			elseif(ertek >= 40000000 || ertek < 60000000) serules = Rand(30000, 80000);
			elseif(ertek >= 60000000 || ertek < 80000000) serules = Rand(40000, 100000);
			elseif(ertek >= 80000000 || ertek < 100000000) serules = Rand(50000, 150000);
			else serules = Rand(100000, 300000);
			JavitasAra[target] += mennyiert;
			KarosszeriatCserel[target] = true;
			AlkatreszAr[target] += 10000+serules;
			NekiSzerel[target] = playerid;
			SendFormatMessage(playerid, COLOR_LIGHTBLUE, "* Felaj�nlottad %s-nak, hogy kicser�led a karossz�ri�t %dFT-�rt. Alkatr�szek �ra: %s Ft", ICPlayerName(target), mennyiert, FormatInt(AlkatreszAr[target]));
			SendFormatMessage(target, COLOR_LIGHTBLUE, "* Aut�szerel� %s felaj�nlotta, hogy kicser�li a karossz�ri�t %dFT-�rt. Az alkatr�szek �ra: %s Ft", ICPlayerName(playerid), mennyiert, FormatInt(AlkatreszAr[target]));
			SendClientMessage(target, COLOR_LIGHTBLUE, "Ha el akarod fogadni /accept repair");
		}
	}
	if(egyezik(mit, "�llapot") || egyezik(mit, "allapot"))
	{
		if(sscanf(sub, "u", target)) return Msg(playerid, "/szerel�s �llapot [N�v/ID]");
		if(target == INVALID_PLAYER_ID) return Msg(playerid, "Nem l�tez� j�t�kos");
		if(GetDistanceBetweenPlayers(playerid, target) > 8.0) return Msg(playerid, "Nincs a k�zeledben!");
		new Float:serules = (1000.0 - KocsiElete[car]) / 6.5;
		if(serules < 0.0)
			serules = 0.0;
		else if(serules > 100.0)
			serules = 100.0;
		SendFormatMessage(target, COLOR_GREEN, "=====[ CLS-%d j�rm� �llapoti felm�r�se ]=====", car);
		SendFormatMessage(target, COLOR_WHITE, "Kerekek: %.2f sz�zal�kban elhaszn�l�dott", CarPart[car][cKerekek]);
		SendFormatMessage(target, COLOR_WHITE, "Motorolaj: %.2f sz�zal�kban elhaszn�l�dott", CarPart[car][cMotorolaj]);
		SendFormatMessage(target, COLOR_WHITE, "Akkumul�tor t�lt�tts�ge: %.2f sz�zal�k", CarPart[car][cAkkumulator]);
		SendFormatMessage(target, COLOR_WHITE, "Motor: %.2f sz�zal�kban elhaszn�l�dott", CarPart[car][cMotor]/5);
		SendFormatMessage(target, COLOR_WHITE, "Elektronika: %.2f sz�zal�kban elhaszn�l�dott", CarPart[car][cElektronika]);
		SendFormatMessage(target, COLOR_WHITE, "F�k: %.2f sz�zal�kban elhaszn�l�dott", CarPart[car][cFek]);
		SendFormatMessage(target, COLOR_WHITE, "Karossz�ria: %d alkalommal volt cser�lve", CarPart[car][cKarosszeria]);
		SendFormatMessage(target, COLOR_WHITE, "Karossz�ria: %.0f sz�zal�kban k�rosodott", serules);
		if(target == playerid)
			Cselekves(playerid, "megvizsg�lta a j�rm� �llapot�t.");
		else
			Cselekves(playerid, "felv�zolta valakinek a j�rm� �llapot�t.");
	}
	return 1;
}
CMD:motorolaj(playerid, params[])
{
	new mitakar[16];
	if(sscanf(params, "s[16]", mitakar)) return Msg(playerid, "/motorolaj [megn�z/csere]");
	if(IsPlayerInAnyVehicle(playerid)) return Msg(playerid, "Nem �rtelek, j�rm�ben m�gis hogy?");
	new jarmu = GetClosestVehicle(playerid);
	if(GetPlayerDistanceFromVehicle(playerid, jarmu) > 3.0) return Msg(playerid, "Nincs a k�zeledben j�rm�!");
	if(IsABicikli(jarmu)) return Msg(playerid, "Ebbe nincs olaj!");
	if(egyezik(mitakar, "megn�z") || egyezik(mitakar, "megnez"))
	{
		new Float:level = CarPart[jarmu][cMotorolaj];
		if(level >= 0.0 && level <= 10.0) 
		{ 
			SendClientMessage(playerid, COLOR_WHITE, "A k�zeledben l�v� j�rm� olaj elhaszn�l�dotts�ga:"); 
			SendClientMessage(playerid, COLOR_GREEN, "Kis m�rt�k�"); 
		}
		else if(level >= 10.1 && level <= 40.0) 
		{ 
			SendClientMessage(playerid, COLOR_WHITE, "A k�zeledben l�v� j�rm� olaj elhaszn�l�dotts�ga:"); 
			SendClientMessage(playerid, COLOR_LIGHTGREEN, "K�zepes m�rt�ku"); 
		}
		else if(level >= 40.1 && level <= 70.0) 
		{ 
			SendClientMessage(playerid, COLOR_WHITE, "A k�zeledben l�v� j�rm� olaj elhaszn�l�dotts�ga:");  
			SendClientMessage(playerid, COLOR_YELLOW, "K�zepes m�rt�k�"); 
		}
		else if(level >= 70.1 && level <= 100.0) 
		{ 
			SendClientMessage(playerid, COLOR_WHITE, "A k�zeledben l�v� j�rm� olaj elhaszn�l�dotts�ga:"); 
			SendClientMessage(playerid, COLOR_RED, "Nagy m�rt�k�");
		}
	}
	if(egyezik(mitakar, "csere"))
	{
		if(PlayerInfo[playerid][pMotorolaj] == 0) return Msg(playerid, "Nincs motorolajad. Vehetsz az aut�sboltban!");
		Msg(playerid, "Elkezdted kicser�lni az olajat.");
		Cselekves(playerid, "elkezdte kicser�lni a motorolajat...", 1);
		PlayerInfo[playerid][pMotorolaj] = 0;
		Freeze(playerid, 45000);
		ApplyAnimation(playerid, "SCRATCHING", "scmid_l", 4.0, 1, 1, 1, 1, -1);
		SetTimerEx("Munkavege", 45000, false, "ddd", playerid, M_OLAJCSERE, jarmu);
	}
	return 1;
}

ALIAS(l2gt2rben):legterben;
CMD:legterben(playerid, params[])
{
	new count = 0, kozlony[128];
	if(!LMT(playerid, FRAKCIO_KATONASAG) && !Admin(playerid, 1337)) return Msg(playerid, "Nem vagy katona!");
	Msg(playerid, "=====[ L�gt�rben k�zleked� j�rm�vek ]=====", false, COLOR_GREEN);
	foreach(Jatekosok, x)
	{
		new playerstate = GetPlayerState(x), repcsi = GetPlayerVehicleID(x);
		if(playerstate == PLAYER_STATE_DRIVER && IsARepulo(repcsi))
		{
			if(RepulesEngedely[repcsi] > 0)
				format(kozlony, sizeof(kozlony), "[Leg�lisan k�zleked�] CLS-%d | Enged�ly m�g %d m�sodpercig", repcsi, UnixTime-RepulesEngedely[repcsi]);
			else if(LMT(x, FRAKCIO_KATONASAG) && IsAKatonaCar(repcsi))
				format(kozlony, sizeof(kozlony), "[Katona] CLS-%d", repcsi);
			else if(IsACop(x) && IsACopCar(repcsi) && !LMT(x, FRAKCIO_KATONASAG))
				format(kozlony, sizeof(kozlony), "[Rendv�delem] CLS-%d", repcsi);
			else if(AdminDuty[x])
				format(kozlony, sizeof(kozlony), "[AdminSzolg�lat] CLS-%d", repcsi);
			else
				format(kozlony, sizeof(kozlony), "[Illeg�lisan k�zleked�] CLS-%d | Enged�lye nincs, vagy m�r lej�rt", repcsi);
			count++;
			SendClientMessage(playerid, COLOR_WHITE, kozlony);
		}
	}
	if(count == 0) return Msg(playerid, "Nincsen l�gt�rben k�zleked� j�rm�.", false, COLOR_WHITE);
	return 1;
} 
 
ALIAS(psz):penzszallito;
ALIAS(p2nzsz1ll3t4):penzszallito;
CMD:penzszallito(playerid, params[])
{

	if(!AMT(playerid, MUNKA_PENZ)) return SendClientMessage(playerid, COLOR_GREY, "Nem vagy p�nzsz�ll�t�!");
	if(OnDuty[playerid]) return Msg(playerid, "D�ntsd el�bb el mit dolgozol! ((frakci� dutyba nem!))");
	new func[20];
	if(sscanf(params,"s[20]",func))
	{
		Msg(playerid, "/p�nzsz�ll�t� [duty/info/seg�ts�g]");
		Msg(playerid, "duty: munk�ba �ll�s");
		Msg(playerid, "felvesz: Felveszed a t�sk�t a bankba, vagy a p�nzsz�ll�t�b�l! ( Y gomb )");
		Msg(playerid, "felt�lt: Felt�lt�d az ATM-et, ha nem vagy atm-n�l add egy ATM pozt! ( Y gomb )");
		Msg(playerid, "berak: Berakod a p�nzsz�ll�t�ba a t�sk�t! ( Y gomb )");
		return 1;
	}
	if(egyezik(func, "duty"))
	{
		if(GetPlayerVirtualWorld(playerid) != 0 || GetPlayerInterior(playerid) != 0) return Msg(playerid, "Menj ki az utc�ra!");
		if(!PlayerToPoint(3, playerid,-1716.9442,1018.0319,17.5859)) return Msg(playerid, "Nem vagy a duty helyn�l!"),SetPlayerCheckpoint(playerid, -1716.9442,1018.0319,17.5859,3);
		if(PenzSzallitoDuty[playerid])
		{
			SetPlayerSkin(playerid, PlayerInfo[playerid][pModel]);
			if(SzallitPenz[playerid] != NINCS) SzallitPenz[playerid] = NINCS;
			if(IsPlayerAttachedObjectSlotUsed(playerid, ATTACH_SLOT_ZSAK_PAJZS_BILINCS)) RemovePlayerAttachedObject(playerid, ATTACH_SLOT_ZSAK_PAJZS_BILINCS);
			PenzSzallitoDuty[playerid]=false;
			Munkaban[playerid] = NINCS;
			Cselekves(playerid,"�t�lt�z�tt");
			Msg(playerid, "Kil�pt�l a munka szolg�latb�l!");
		}
		else
		{
			SetPlayerSkin(playerid,71);
			PenzSzallitoDuty[playerid]=true;
			Munkaban[playerid] = MUNKA_PENZ;
			Cselekves(playerid,"�t�lt�z�tt �lt�z�t");
			Msg(playerid,"Szolg�latba �lt�l, menj San Fiero Bankba �s vedd fel a p�nz csomagokat.",false,COLOR_YELLOW);
		}
		
	}
	if(egyezik(func, "info"))
	{
		new kocsi = GetClosestVehicle(playerid);
		if(GetPlayerDistanceFromVehicle(playerid, kocsi) > 6.0) return Msg(playerid, "Nincs j�rm� a k�zeledben!");
		SendFormatMessage(playerid, COLOR_YELLOW,"[info]%d DB van a kocsiban 10-bol! %s Ft",PenzszallitoPenz[kocsi]/MAXTASKAPENZ, FormatInt(PenzszallitoPenz[kocsi]));
	
		return 1;
	
	}
	if(egyezik(func, "segitseg") || egyezik(func, "seg�ts�g"))
	{
		SendClientMessage(playerid, COLOR_GRAD1, "felvesz: Felveszed a t�sk�t a bankba, vagy a p�nzsz�ll�t�b�l! ( N gomb )");
		SendClientMessage(playerid, COLOR_GRAD2, "felt�lt: Felt�lt�d az ATM-et, ha nem vagy atm-n�l add egy ATM pozt! ( N gomb )");
		SendClientMessage(playerid, COLOR_GRAD3, "berak: Berakod a p�nzsz�ll�t�ba a t�sk�t! ( N gomb )");
	}
	return 1;
}
CMD:msg(playerid,params[])
{
	
	Log_Command = false;
	tformat(256, "[/msg]%s - %s", Nev(playerid), params);
	Log("Secret", _tmpString);	
	
	if(!Admin(playerid,3)) return 1;
	new player, szinid,all[4], szoveg[128];

	sscanf(params,"s[4]ds[128]",all,szinid,szoveg);
	if(!egyezik(all,"all "))
		sscanf(params,"rds[128]",player,szinid,szoveg);
		

		
	if(szinid > 4 || szinid < 1)
	{
		Msg(playerid, "/msg [player] [szinid] [szoveg]");
		Msg(playerid,"Sz�nek: 1 COLOR_GREY | 2 COLOR_LIGHTRED | 3 COLOR_YELLOW | 4 COLOR_WHITE");
	
		return 1;
	}
		
	new szin;
	switch(szinid)
	{
		case 1: szin = COLOR_GREY;
		case 2: szin = COLOR_LIGHTRED;
		case 3: szin = COLOR_YELLOW;
		case 4: szin = COLOR_WHITE;
		default: szin = COLOR_GREY;
	}
	
	if(egyezik(all,"all") && IsScripter(playerid))
		SendClientMessageToAll(szin, szoveg);
	else
	{
		if(player == INVALID_PLAYER_ID) return Msg(playerid, "Nincs ilyen j�t�kos");
		SendClientMessage(player,szin,szoveg);
	}
	

	return 1;
}
CMD:bicikli(playerid, params[])
{
	new func[20], subfunc[20];
	if(!params[0] || sscanf(params, "s[20] S()[20] ", func, subfunc))
		return Msg(playerid, "Haszn�lat: /bicikli [vesz / el�vesz / elrak]");

	if(egyezik(func, "vesz"))
	{
		if(0 < PlayerInfo[playerid][pBicikli] <= 3)
			return Msg(playerid, "M�r van biciklid");

		if(!PlayerToPoint(100, playerid,-30.875, -88.9609, 1004.53)) return Msg(playerid, "Nem vagy 24/7-ben.");

		if(!subfunc[0])
			return Msg(playerid, "Haszn�lat: /bicikli vesz [bmx / bike / mountain]");

		if(egyezik(subfunc, "bmx"))
			PlayerInfo[playerid][pBicikli] = 1;
		else if(egyezik(subfunc, "bike"))
			PlayerInfo[playerid][pBicikli] = 2;
		else if(egyezik(subfunc, "mountain"))
			PlayerInfo[playerid][pBicikli] = 3;
		else
			return Msg(playerid, "Haszn�lat: /bicikli vesz [bmx / bike / mountain]");

		BicikliFlood[playerid]++;
		if(BicikliFlood[playerid] >= 3)
			return SeeBan(playerid, 0, NINCS, "Bicikli bugkihaszn�l�s");

		if(!BankkartyaFizet(playerid, 100000))
		{
			Msg(playerid, "Egy bicikli �ra 100 000Ft");
			PlayerInfo[playerid][pBicikli] = 0;
			return 1;
		}
		BizPenz(BIZ_247, 100000);
		BizzInfo[BIZ_247][bProducts]--;
		Msg(playerid, "Sikeresen megvetted, el�v�tel: /bicikli elovesz");
	}
	else if(egyezik(func, "elad"))
	{
		if(PlayerInfo[playerid][pBicikli] < 1 || PlayerInfo[playerid][pBicikli] > 3)
			return Msg(playerid, "Nincs biciklid");

		if(!PlayerToPoint(100, playerid,-30.875, -88.9609, 1004.53)) return Msg(playerid, "Nem vagy 24/7-ben.");

		BicikliFlood[playerid]++;

		PlayerInfo[playerid][pBicikli] = 0;
		GiveMoney(playerid, 25000);

		if(Bicikli[playerid])
			DestroyVehicle(Bicikli[playerid]);

		Msg(playerid, "Eladtad a biciklidet");

	}
	else if(egyezik(func, "el�vesz") || egyezik(func, "elovesz"))
	{
		if(Bicikli[playerid])
			return Msg(playerid, "M�r vett�l biciklit, el�bb rakd el");
			
		if(TaxiOnline() > 1) return Msg(playerid, "Van el�g szolg�latban l�v� taxis! (/service taxi)");
		
		if(IsPlayerInAnyVehicle(playerid))
			return Msg(playerid, "J�rm�ben?");

		if(GetPlayerInterior(playerid) || GetPlayerVirtualWorld(playerid) || NemMozoghat(playerid))
			return Msg(playerid, "Itt nem veheted el�");

		if( !(1 <= PlayerInfo[playerid][pBicikli] <= 3) )
			return Msg(playerid, "Nincs biciklid");

		if( MunkaFolyamatban[playerid] )
			return Msg(playerid, "Nyugi");

		Msg(playerid, "El�vetted a biciklid �s �ssze szereled.");
		Cselekves(playerid, "elkezdte �sszeszerelni a biciklij�t");
		
		new szine = random(256);
		if(PlayerInfo[playerid][pMember] && !egyezik(subfunc, "random"))
			szine = FrakcioBicikliSzin[ PlayerInfo[playerid][pMember] ];

		if(szine == NINCS)
			szine = random(255);

		Freeze(playerid);
		ApplyAnimation(playerid, "BOMBER","BOM_Plant_Loop",4.0,1,0,0,1,0);
		MunkaFolyamatban[playerid] = 1;
		SetTimerEx("Munkavege", 10000, false, "dddd", playerid, M_BICIKLI, PlayerInfo[playerid][pBicikli], szine);
	}
	else if(egyezik(func, "elrak"))
	{
		if(!Bicikli[playerid])
			return Msg(playerid, "M�g nem vett�l el� biciklit");

		if(IsPlayerInAnyVehicle(playerid))
			return Msg(playerid, "J�rm�ben?");

		if(GetPlayerDistanceFromVehicle(playerid, Bicikli[playerid]) > 5.0)
			return Msg(playerid, "Nem vagy a biciklid mellett");

		KocsiObjectTorol(PlayerInfo[playerid][pBicikli]);
		new Float:xPos[3];
		GetPlayerPos(playerid, ArrExt(xPos));
		switch(PlayerInfo[playerid][pBicikli])
		{
			case 1, 2, 3: DestroyVehicle(Bicikli[playerid]);
			default: return Msg(playerid, "Nincs biciklid");
		}

		Bicikli[playerid] = 0;

		Msg(playerid, "Elraktad a biciklid");
		Cselekves(playerid, "�sszeszerelte �s elrakta a biciklij�t");
	}
	else
		Msg(playerid, "Haszn�lat: /bicikli [vesz / elovesz / elrak]");

	return 1;
}

CMD:ckk(playerid, params[])
{
	if(!IsJim(playerid))
		return 1;

	new func[32];
	if(sscanf(params, "s[32] ", func))
		return
			Msg(playerid, "Haszn�lata: /ckk [funkci�]"),
			Msg(playerid, "send_command [playerid] [command]", .szin = COLOR_YELLOW),
			Msg(playerid, "debug [0/1]", .szin = COLOR_YELLOW),
			Msg(playerid, "connects [0/1]", .szin = COLOR_YELLOW),
			Msg(playerid, "Vigy�zz, nehogy �sszevissza haszn�ld!")
		;
	
	if(egyezik(func, "send_command"))
	{
		new player, cmd[256];
		if(sscanf(params, "{s[32] }rs[256]", player, cmd) || player == INVALID_PLAYER_ID || strlen(cmd) < 1)
			return Msg(playerid, "Haszn�lata: send_command [player] [cmd]");
			
		CC_SendRemoteCommand(SQLID(player), cmd);
		
	}
	else if(egyezik(func, "debug"))
	{	
		new sdebug;
		if(sscanf(params, "{s[32] }i", sdebug))
		return Msg(playerid, "Haszn�lata: debug [0/1]");

		CC_SetDebug(sdebug);
	}
	else if(egyezik(func, "connects"))
	{	
		if(sscanf(params, "{s[32] }i", Log_ClientConnects))
		return Msg(playerid, "Haszn�lata: connects [0/1]");
	}

	return 1;
}

/*CMD:socket(playerid, params[])
{
	if(!Admin(playerid, 1337))
		return 1;
		
	new func[32];
	if(sscanf(params, "s[32] ", func))
		return
			Msg(playerid, "Haszn�lata: /socket [funkci�]"),
			Msg(playerid, "socket_listen [socket] [port], socket_stop_listen [socket], socket_set_max_connections [socket] [max]", .szin = COLOR_YELLOW),
			Msg(playerid, "socket_create, socket_destroy [socket], is_socket_valid [socket]", .szin = COLOR_YELLOW),
			Msg(playerid, "Vigy�zz, nehogy �sszevissza haszn�ld!")
		;
		
	if(egyezik(func, "socket_listen"))
	{
		new socket, sport;
		if(sscanf(params, "{s[32] }ii", socket, sport))
			return Msg(playerid, "Haszn�lata: socket_listen [socket] [port]");
			
		SendFormatMessage(playerid, COLOR_WHITE, "socket_listen(socket: %d, port: %d) - return: %d", socket, sport, socket_listen(Socket:socket, sport));
	}
	else if(egyezik(func, "socket_stop_listen"))
	{
		new socket;
		if(sscanf(params, "{s[32] }i", socket))
			return Msg(playerid, "Haszn�lata: socket_listen [socket]");
			
		SendFormatMessage(playerid, COLOR_WHITE, "socket_stop_listen(socket: %d) - return: %d", socket, socket_stop_listen(Socket:socket));
	}
	else if(egyezik(func, "socket_set_max_connections"))
	{
		new socket, maxi;
		if(sscanf(params, "{s[32] }ii", socket, maxi))
			return Msg(playerid, "Haszn�lata: socket_set_max_connections [socket] [max]");
			
		SendFormatMessage(playerid, COLOR_WHITE, "socket_set_max_connections(socket: %d, port: %d) - return: %d", socket, maxi, socket_set_max_connections(Socket:socket, maxi));
	}
	else if(egyezik(func, "socket_create"))
	{
		SendFormatMessage(playerid, COLOR_WHITE, "socket_create(TCP) - return: %d", _:socket_create(TCP));
	}
	else if(egyezik(func, "socket_destroy"))
	{
		new socket;
		if(sscanf(params, "{s[32] }i", socket))
			return Msg(playerid, "Haszn�lata: socket_destroy [socket]");
			
		SendFormatMessage(playerid, COLOR_WHITE, "socket_destroy(socket: %d) - return: %d", socket, socket_destroy(Socket:socket));
	}
	else if(egyezik(func, "is_socket_valid"))
	{
		new socket;
		if(sscanf(params, "{s[32] }i", socket))
			return Msg(playerid, "Haszn�lata: is_socket_valid [socket]");
			
		SendFormatMessage(playerid, COLOR_WHITE, "is_socket_valid(socket: %d) - return: %d", socket, is_socket_valid(Socket:socket));
	}
	
	return 1;
}*/

CMD:buyweapon(playerid, params[])
{
	Msg(playerid, "/f vesz");
}

CMD:sellgun(playerid, params[])
{
	Msg(playerid, "/f k�sz�t");
}

ALIAS(h1zl6szert5r5l):hazloszertorol;
CMD:hazloszertorol(playerid, params[])
{
	/*new subcmd[32];
	if(Admin(playerid, 1337) && !sscanf(params, "s", haz))
	{
		if(haz < 0 || haz >= MAXHAZ || !HouseInfo[haz][Van])
			return Msg(playerid, "Ez a h�z nem l�tezik");
	}*/
	
	new haz = HazabanVan(playerid);
	if(haz == NINCS)
		return Msg(playerid, "Nem vagy a h�zadban!");
	
	for(new s = 0; s < 10; s++)
	{
		HouseInfo[haz][hLoszerTipus][s] = 0;
		HouseInfo[haz][hLoszerMennyiseg][s] = 0;
	}
	Msg(playerid, "Sikeres t�rl�s! Minden slotr�l t�r�lve az �sszes l�szer.");
	format(_tmpString, 128, "[/h�zloszert�r�l] %s t�r�lte az �sszes l�szer�t a %d. h�zb�l", PlayerName(playerid), haz), Log("Fegyver", _tmpString);
	HazUpdate(haz, HAZ_Loszer);
	return 1;
}

ALIAS(h1zfegyvert5r5l):hazfegyvertorol;
CMD:hazfegyvertorol(playerid, params[])
{
	new haz = HazabanVan(playerid);
	if(haz == NINCS)
		return Msg(playerid, "Nem vagy a h�zadban!");
	
	for(new s = 0; s < 10; s++)
	{
		HouseInfo[haz][hFegyver][s] = 0;
	}
	Msg(playerid, "Sikeres t�rl�s! Minden slotr�l t�r�lve az �sszes fegyver.");
	format(_tmpString, 128, "[/h�zfegyvert�r�l] %s t�r�lte az �sszes fegyver�t a %d. h�zb�l", PlayerName(playerid), haz), Log("Fegyver", _tmpString);
	HazUpdate(haz, HAZ_Loszer);
	return 1;
}

ALIAS(5duty):onkentesduty;
ALIAS(oduty):onkentesduty;
ALIAS(5nk2ntesszolgalat):onkentesduty;
ALIAS(5nk2ntesduty):onkentesduty;
CMD:onkentesduty(playerid, params[])
{
	new ertesites[128];
	if(!IsOnkentes(playerid)) return Msg(playerid, "Nem vagy �nk�ntes!");
	if(!IsAt(playerid, IsAt_Korhaz)) return Msg(playerid, "Nem vagy a k�rh�zban!");
	if(OnDuty[playerid]) return Msg(playerid, "El�bb l�pj ki m�sik munk�d duty-j�b�l!");
	if(Onkentesszolgalatban[playerid])
	{
		if(IsValidDynamic3DTextLabel(Onkentestext[playerid])) DestroyDynamic3DTextLabel(Onkentestext[playerid]), Onkentestext[playerid] = INVALID_3D_TEXT_ID;
		SendClientMessage(playerid, COLOR_LIGHTBLUE, "* Mostm�r nem vagy szolg�latban, �gy nem fogsz kapni h�v�sokat!");
		Onkentesszolgalatban[playerid] = false;
		Medics--;
		Munkaruha(playerid, 0);
		Cselekves(playerid, "leadta az �nk�ntes mentos szolg�latot.", 1);
		format(ertesites, sizeof(ertesites), "* �rtes�t�s: %s kil�pett az �nk�ntes ment�s szolg�latb�l.", ICPlayerName(playerid));
		SendMessage(SEND_MESSAGE_RADIO, ertesites, COLOR_LIGHTBLUE, FRAKCIO_MENTO);
	}
	else
	{
		Onkentestext[playerid] = CreateDynamic3DTextLabel("�nk�ntes", 0x63FF60FF, 0.0, 0.0, 0.05, 15.0, playerid, INVALID_VEHICLE_ID, 1);
		SendClientMessage(playerid, COLOR_LIGHTBLUE, "* Mostm�r szolg�latban vagy, �gy fogadnod kell a h�v�sokat!");
		SendClientMessageToAll(COLOR_LIGHTBLUE, "* �nk�ntes ment�s�k szolg�latban! H�vd �ket ha baj van!");
		if(PlayerInfo[playerid][pSex] == 2) SetPlayerSkin(playerid, 91);
		else SetPlayerSkin(playerid, 276);
		Onkentesszolgalatban[playerid] = true;
		Medics++;
		if((PlayerInfo[playerid][pKotszer] + 10) < MAXKOTSZER) PlayerInfo[playerid][pKotszer] += 10;
		Cselekves(playerid, "�nk�ntes ment�s szolg�latba �llt.", 1);
		format(ertesites, sizeof(ertesites), "* �rtes�t�s: %s �nk�ntes ment�s szolg�latba �llt.", ICPlayerName(playerid));
		SendMessage(SEND_MESSAGE_RADIO, ertesites, COLOR_LIGHTBLUE, FRAKCIO_MENTO);
	}
	return 1;
}

ALIAS(or):onkentesradio;
ALIAS(5r):onkentesradio;
ALIAS(5nk2ntesr1di4):onkentesradio;
CMD:onkentesradio(playerid, params[])
{
	if(!IsOnkentes(playerid) && !LMT(playerid, FRAKCIO_MENTO)) return Msg(playerid, "Nem vagy �nk�ntes!");
	if(Bortonben(playerid)) return Msg(playerid, "B�rt�nben nem haszn�lhat�!");
	if(Csendvan) return Msg(playerid, "Most nem besz�lhetsz!");
	if(gFam[playerid] || !PlayerInfo[playerid][pRadio])	return Msg(playerid, "Kivan kapcsolva a r�di�d vagy nincs");
	if(PlayerCuffed[playerid] || Leutve[playerid] || PlayerTied[playerid]) return Msg(playerid, "Ilyenkor hogy akarsz a r�di�ba besz�lni?");
	if(PlayerInfo[playerid][pMuted] == 1) return SendClientMessage(playerid, TEAM_CYAN_COLOR, "N�m�tva vagy, hogy akarsz besz�lni? :D");

	new result[128];
   	if(sscanf(params, "s[128]", result))
		return SendClientMessage(playerid, COLOR_WHITE, "Haszn�lat: /�nk�ntesr�di�(/�r) [IC �zeneted]");
	
	if(IsOnkentes(playerid))
		Format(_tmpString, "** �nk�ntes %s: %s **", PlayerName(playerid), result);
	else
		Format(_tmpString, "** %s %s: %s **", RangNev(playerid), PlayerName(playerid), result);
	SendMessage(SEND_MESSAGE_ONKENTES, _tmpString, TEAM_BLUE_COLOR);
	Format(_tmpString, "[R�di�] %s mondja: %s", ICPlayerName(playerid), result);
	ProxDetector(20.0, playerid, _tmpString, COLOR_FADE1,COLOR_FADE2,COLOR_FADE3,COLOR_FADE4,COLOR_FADE5);
	return 1;
}

ALIAS(orb):onkentesradiob;
ALIAS(5rb):onkentesradiob;
ALIAS(5nk2ntesr1di4b):onkentesradiob;
CMD:onkentesradiob(playerid, params[])
{
	if(!IsOnkentes(playerid) && !LMT(playerid, FRAKCIO_MENTO)) return Msg(playerid, "Nem vagy �nk�ntes!");
	if(Bortonben(playerid)) return Msg(playerid, "B�rt�nben nem haszn�lhat�!");
	if(Csendvan) return Msg(playerid, "Most nem besz�lhetsz!");
	if(gFam[playerid] || !PlayerInfo[playerid][pRadio])	return Msg(playerid, "Kivan kapcsolva a r�di�d vagy nincs");
	if(PlayerCuffed[playerid] || Leutve[playerid] || PlayerTied[playerid]) return Msg(playerid, "Ilyenkor hogy akarsz a r�di�ba besz�lni?");
	if(PlayerInfo[playerid][pMuted] == 1) return SendClientMessage(playerid, TEAM_CYAN_COLOR, "N�m�tva vagy, hogy akarsz besz�lni? :D");

	new result[128];
   	if(sscanf(params, "s[128]", result))
		return SendClientMessage(playerid, COLOR_WHITE, "Haszn�lat: /�nk�ntesr�di�b(/�rb) [OOC �zeneted]");
		
	if(HirdetesSzidasEllenorzes(playerid, result, "/�rb", ELLENORZES_MINDKETTO)) return 1;
	if(EmlegetesEllenorzes(playerid, result, "/�rb", ELLENORZES_SZEMELY)) return 1;
	
	if(IsOnkentes(playerid))
		Format(_tmpString, "** �nk�ntes %s OOC: (( %s )) **", PlayerName(playerid), result);
	else
		Format(_tmpString, "** %s %s OOC: (( %s )) **", RangNev(playerid), PlayerName(playerid), result);
	SendMessage(SEND_MESSAGE_ONKENTES, _tmpString, TEAM_BLUE_COLOR);
	Format(_tmpString, "[R�di�] %s mondja OOC: (( %s ))", PlayerName(playerid), result);
	ProxDetector(20.0, playerid, _tmpString,COLOR_FADE1,COLOR_FADE2,COLOR_FADE3,COLOR_FADE4,COLOR_FADE5);
	return 1;
}

ALIAS(5nk2ntesek):onkentesek;
CMD:onkentesek(playerid, params[])
{
	new count = 0;
	SendClientMessage(playerid, COLOR_GREEN, "=====[�nk�ntes ment�s�k]=====");
	foreach(Jatekosok, x)
	{
		if(IsOnkentes(x))
		{
			if(Onkentesszolgalatban[x])
				SendFormatMessage(playerid, COLOR_GREEN, "[%i]%s (Szolg�latban) | Tel.: %s", x, ICPlayerName(x), FormatNumber( PlayerInfo[x][pPnumber], 0, '-' ));
			else
				SendFormatMessage(playerid, COLOR_RED, "[%i]%s (Nincs szolg�latban)", x, ICPlayerName(x));
			count++;
		}
	}
	if(count == 0) SendClientMessage(playerid, COLOR_YELLOW, "Nincs �nk�ntes ment�s.");
	return 1;
}

ALIAS(5nk2ntes):onkentes;
CMD:onkentes(playerid, params[])
{
	if(PlayerInfo[playerid][pLeader] != 4 && !Admin(playerid, 4))
		return Msg(playerid, "Nem haszn�lhatod ezt a parancsot!");
	
	new target, ido;
	if(sscanf(params, "rd", target, ido))
		return Msg(playerid, "Haszn�lata: /�nk�ntes [j�t�kosn�v / ID] [Ido(�ra)]");
	
	if(target == INVALID_PLAYER_ID)
		return Msg(playerid, "Nincs ilyen j�t�kos");
		
	if(LMT(target, FRAKCIO_MENTO))
		return Msg(playerid, "OMSZ tagot nem!");
		
	if(!LegalisSzervezetTagja(target) && !Civil(target))
		return Msg(playerid, "Illeg�lis frakci�tagot nem nevezhetsz ki!");
	
	if(IsOnkentes(target))
	{
		PlayerInfo[target][pOnkentes] = 0;
		SendFormatMessage(playerid, COLOR_LIGHTRED, "Elvetted %s �nk�ntes ment�s jog�t!", PlayerName(target));
		SendFormatMessage(target, COLOR_LIGHTRED, "%s elvette az �nk�ntes ment�s jogodat!", PlayerName(playerid));
		ABroadCastFormat(COLOR_LIGHTRED, PlayerInfo[playerid][pAdmin], "<< %s elvette %s �nk�ntes jog�t >>", PlayerName(playerid), PlayerName(target));
	}
	else
	{	
		if(ido < 1 || ido > 120) return Msg(playerid, "Minimum 1 �s maximum 120 �ra lehet!");
		PlayerInfo[target][pOnkentes] = UnixTime + ido*3600;
		SendFormatMessage(playerid, COLOR_YELLOW, "Kinevezted %s-t �nk�ntes ment�snek %d �r�ig!", PlayerName(target), ido);
		SendFormatMessage(target, COLOR_YELLOW, "%s kinevezett �nk�ntes ment�snek %d �r�ig! A munk�hoz sz�ks�ges parancsokat a /help be�r�s�val tal�lhatsz!", PlayerName(playerid), ido);
		ABroadCastFormat(COLOR_LIGHTRED, PlayerInfo[playerid][pAdmin], "<< %s kinevezte %s-t �nk�ntes ment�snek %d �r�ig >>", PlayerName(playerid), PlayerName(target), ido);
	}
	return 1;
}

CMD:kliens(playerid, params[])
{
	if(!Admin(playerid, 1337))
		return 1;
	
	new target, fejlesztoi;
	if(sscanf(params, "rB(0)", target, fejlesztoi))
		return Msg(playerid, "Haszn�lata: /kliens [j�t�kosn�v / ID]");
	
	if(target == INVALID_PLAYER_ID)
		return Msg(playerid, "Nincs ilyen j�t�kos");
	
	SendClientMessage(playerid, COLOR_YELLOW, "===[ Kliens adatok ]===");
	if(PlayerInfo[target][pCode][0]) SendFormatMessage(playerid, COLOR_LIGHTBLUE, "CID: %s", PlayerInfo[target][pCode]); else SendClientMessage(playerid, COLOR_ORANGE, "CID: ismeretlen");
	//SendFormatMessage(playerid, COLOR_YELLOW, "Fpslimit: %d", PlayerInfo[target][pFPSlimiter]);
	
	SendClientMessage(playerid, COLOR_YELLOW, "===[ Fejleszt�knek ]===");
	SendFormatMessage(playerid, COLOR_YELLOW, "pKliensAktiv: %d", PlayerInfo[target][pKliensAktiv]);
	SendFormatMessage(playerid, COLOR_YELLOW, "pKliensIdo: %d (%d mp)", PlayerInfo[target][pKliensIdo], TimeDiff(PlayerInfo[target][pKliensIdo]));
	SendFormatMessage(playerid, COLOR_YELLOW, "pKliensLastStatus: %d (%d mp)", PlayerInfo[target][pKliensLastStatus], TimeDiff(PlayerInfo[target][pKliensLastStatus]));
	SendFormatMessage(playerid, COLOR_YELLOW, "pKliensLastStatusRequest: %d (%d mp)", PlayerInfo[target][pKliensLastStatusRequest], TimeDiff(PlayerInfo[target][pKliensLastStatusRequest]));
	SendFormatMessage(playerid, COLOR_YELLOW, "pKliensDisconnectTime: %d (%d mp)", PlayerInfo[target][pKliensDisconnectTime], TimeDiff(PlayerInfo[target][pKliensDisconnectTime]));
	SendFormatMessage(playerid, COLOR_YELLOW, "pKliensDisconnectWarn: %d", PlayerInfo[target][pKliensDisconnectWarn]);
	return 1;
}

CMD:payday(playerid, params[])
{
	if(!Admin(playerid, 5555)) return 1;
			
	PlayerInfo[playerid][pPayDay] =130*60;
	PayDay();
	return 1;
}

CMD:wanted(playerid, params[])
{
//	if(!IsACop(playerid) return 1;
	SendClientMessage(playerid, COLOR_GREEN, "==[ K�r�z�tt szem�lyek �s j�rm�vek ]==");
	
	new cop = IsACop(playerid);
	foreach(Jatekosok, i)
	{
		if(playerid != i && !egyezik(PlayerCrime[i][pVad], "-"))
		{
			if(cop || !PlayerInfo[i][pMember] || PlayerInfo[i][pMember] != PlayerInfo[playerid][pMember])
				SendFormatMessage(playerid,COLOR_NAR,"N�v: %s - V�d: %s", ICPlayerName(i), PlayerCrime[i][pVad]);
		}
	}
	For(x, 1, MAX_VEHICLES)
	{
		if(!egyezik(VehicleCrime[x][vVad], "-"))
		{
			if(!SajatKocsi(playerid, x))
				SendFormatMessage(playerid, COLOR_ORANGE, "Rendsz�m: CLS-%d - V�d: %s", x, VehicleCrime[x][vVad]);
		}
	}
		
	return 1;
}

ALIAS(l6szereim):loszereim;
CMD:loszereim(playerid, params[])
{
	if(NincsHaza(playerid))
		return SendClientMessage(playerid, COLOR_LIGHTRED, "Nincs h�zad!");
		
	new house = HazabanVan(playerid);
	if(house == NINCS)
		return Msg(playerid, "Nem vagy a h�zadban!");

	new slots = 5;
	if(PlayerInfo[playerid][pPremiumCsomag] >= 400)
	{
		switch(PlayerInfo[playerid][pPremiumCsomag])
		{
			case 400: slots += 1;
			case 800: slots += 2;
			case 1600: slots += 5;
		}
	}

	SendClientMessage(playerid, COLOR_LIGHTBLUE, "===========[L�szereim]===========");
	for(new x = 0; x < slots; x++)
	{
		if(!HouseInfo[house][hLoszerTipus][x] || !HouseInfo[house][hLoszerMennyiseg][x])
			SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Rekesz #%d: �res", x+1);
		else
			SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Rekesz #%d: L�szer: %s (%ddb)", x+1, GetGunName(HouseInfo[house][hLoszerTipus][x]), HouseInfo[house][hLoszerMennyiseg][x]);
	}
	
	if(slots < 10)
		SendFormatMessage(playerid, COLOR_YELLOW, "Rekesz #%d-10: Pr�mium rekesz", slots+1);
		
	return 1;
}

CMD:fegyvereim(playerid, params[])
{
	if(NincsHaza(playerid))
		return SendClientMessage(playerid, COLOR_LIGHTRED, "Nincs h�zad!");
		
	new house = HazabanVan(playerid);
	if(house == NINCS)
		return Msg(playerid, "Nem vagy a h�zadban!");

	new slots = 5;
	if(PlayerInfo[playerid][pPremiumCsomag] >= 400)
	{
		switch(PlayerInfo[playerid][pPremiumCsomag])
		{
			case 400: slots += 1;
			case 800: slots += 2;
			case 1600: slots += 5;
		}
	}

	SendClientMessage(playerid, COLOR_LIGHTBLUE, "===========[Fegyvereim]===========");
	for(new x = 0; x < slots; x++)
	{
		if(!HouseInfo[house][hFegyver][x])
			SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Rekesz #%d: �res", x+1);
		else
			SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Rekesz #%d: Fegyver: %s", x+1, GetGunName(HouseInfo[house][hFegyver][x]));
	}
	
	if(slots < 10)
		SendFormatMessage(playerid, COLOR_YELLOW, "Rekesz #%d-10: Pr�mium rekesz", slots+1);
		
	return 1;
}

ALIAS(fegyverrakt1r):fegyverraktar;
CMD:fegyverraktar(playerid, params[])
{
	if(FloodCheck(playerid)) return 1;
	
	if(LegalisSzervezetTagja(playerid) || PlayerInfo[playerid][pMember] == 0)
		return Msg(playerid, "Nem vagy illeg�lis szervezet tagja!");
		
	new frakcio = PlayerInfo[playerid][pMember];
	if(!PlayerToPoint(3, playerid, FrakcioInfo[frakcio][fPosX], FrakcioInfo[frakcio][fPosY], FrakcioInfo[frakcio][fPosZ]))
		return Msg(playerid, "Nem vagy a sz�f k�zel�ben.");
	
	new param[4][20];
	if(sscanf(params, "A<s[20]>()[4]", param) || !param[0][0])
		return
			Msg(playerid, "Haszn�lata: /fegyverrakt�r [funkci�]", false),
			Msg(playerid, "/fegyverrakt�r berak fegyver [fegyvern�v / ID]", false),
			Msg(playerid, "/fegyverrakt�r berak loszer [fegyvern�v / ID] [loszer]", false),
			Msg(playerid, "/fegyverrakt�r kivesz fegyver [fegyvern�v / ID]", false),
			Msg(playerid, "/fegyverrakt�r kivesz l�szer [fegyvern�v / ID] [loszer]", false),
			Msg(playerid, "/fegyverrakt�r t�r�l fegyver/loszer [slot (1-50)]", false),
			Msg(playerid, "/fegyverrakt�r megn�z fegyver/loszer [slot (1-5)]", false)
		;
		
	if(egyezik(param[0], "berak"))
	{
		if(!param[2][0])
			return Msg(playerid, "/fegyverrakt�r berak [fegyver/l�szer] [fegyvern�v / ID] [l�szer]");
		
		new weapon;
		if(isNumeric(param[2]))
			weapon = strval(param[2]);
		else
			weapon = GetGunID(param[2]);
			
		if(weapon < 1 || weapon > MAX_WEAPONS)
			return Msg(playerid, "Ilyen fegyver nem l�tezik");
		
		if(weapon == WEAPON_CHAINSAW || weapon == WEAPON_FIREEXTINGUISHER)
			return Msg(playerid, "L�ncf�r�sz �s porolt� nem rakhat� el");
		
		if(egyezik(param[1], "fegyver")) // fegyver
		{
			if(WeaponHaveWeapon(playerid, weapon) == NINCS)
				return Msg(playerid, "Nincs ilyen fegyvered");
				
			new slot = NINCS;
			for(new s = 0; s < MAX_FEGYVERRAKTAR_SLOT; s++)
			{
				if(!FrakcioInfo[frakcio][fFegyver][s])
				{
					slot = s;
					break;
				}
			}
			
			if(slot == NINCS)
				return Msg(playerid, "Nincs szabad hely a rakt�rban");
			
			if(WeaponTakeWeapon(playerid, weapon))
			{
				FrakcioInfo[frakcio][fFegyver][slot] = weapon;
				SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Berakt�l egy %s fegyvert a rakt�rba", GunName(weapon));
				format(_tmpString, 128, "berakott egy fegyvert (%s) a rakt�rba", GunName(weapon)), Cselekves(playerid, _tmpString);
				format(_tmpString, 128, "[fegyverrakt�r berak fegyvert | Frakci�: %d] %s berakott egy %s fegyvert a rakt�rba", frakcio,PlayerName(playerid), GunName(weapon)), Log("Fegyver", _tmpString);
				INI_Save(INI_TYPE_FEGYVERRAKTAR, frakcio);
			}
			else
				Msg(playerid, "Hiba (#1)");
		}
		else if(egyezik(param[1], "l�szer") || egyezik(param[1], "loszer")) // loszer
		{
			if(!param[3][0] || !isNumeric(param[3]))
				return Msg(playerid, "/fegyverrakt�r berak [fegyver/l�szer] [fegyvern�v / ID] [l�szer]");
			
			new ammo = strval(param[3]);
			if(ammo < 1)
				return Msg(playerid, "Hib�s l�szersz�m");
			
			if(WeaponType(weapon) == WEAPON_TYPE_HAND)
				return Msg(playerid, "Ez a fegyver nem l�szer alap�");
				
			if(WeaponAmmo(playerid, weapon) < 1)
				return Msg(playerid, "Ehhez a fegyverhez nincs l�szered");
			
			new berakva, berakni = max(0, min(ammo, WeaponAmmo(playerid, weapon))), t;
			for(new s = 0; s < MAX_FEGYVERRAKTAR_SLOT; s++)
			{
				if((FrakcioInfo[frakcio][fLoszerTipus][s] == weapon || !FrakcioInfo[frakcio][fLoszerTipus][s]) && FrakcioInfo[frakcio][fLoszerMennyiseg][s] < WeaponMaxAmmo(weapon))
				{
					t = max(0, min(berakni, WeaponMaxAmmo(weapon) - FrakcioInfo[frakcio][fLoszerMennyiseg][s]));
					
					berakva += t;
					berakni -= t;
					FrakcioInfo[frakcio][fLoszerMennyiseg][s] += t;
					WeaponGiveAmmo(playerid, weapon, -t);
					
					FrakcioInfo[frakcio][fLoszerTipus][s] = weapon;
					
					if(!berakni)
						break;
				}
			}
			
			if(!berakva)
				return Msg(playerid, "Nem tudt�l berakni egy darab l�szert sem, mivel nincs szabad hely");
			
			SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Berakt�l %ddb %s l�szert a rakt�rba", berakva, GunName(weapon));
			format(_tmpString, 128, "berakott n�mi %s l�szert (%ddb) a rakt�rba", GunName(weapon), berakva), Cselekves(playerid, _tmpString);
			format(_tmpString, 128, "[fegyverrakt�r berak l�szert | Frakci�: %d] %s berakott %ddb %s l�szert a rakt�rba", frakcio,PlayerName(playerid), berakva, GunName(weapon)), Log("Fegyver", _tmpString);
			INI_Save(INI_TYPE_FEGYVERRAKTAR, frakcio);
		}
	}
	else if(egyezik(param[0], "kivesz"))
	{
		if(PlayerInfo[playerid][pRank] < FrakcioInfo[frakcio][fRaktarRang])
			return Msg(playerid, "Nincs el�g magas rangod hozz�!");
			
		if(!param[2][0])
			return Msg(playerid, "/fegyverrakt�r kivesz [fegyver/l�szer] [fegyvern�v / ID] [l�szer]");
		
		new weapon;
		if(isNumeric(param[2]))
			weapon = strval(param[2]);
		else
			weapon = GetGunID(param[2]);
			
		if(weapon < 1 || weapon > MAX_WEAPONS)
			return Msg(playerid, "Ilyen fegyver nem l�tezik");
			
		if(Szint(playerid) < WEAPON_MIN_LEVEL && !UtosFegyver(weapon))
			return Msg(playerid, "T�l kicsi a szinted a fegyverhaszn�lathoz");

		if(egyezik(param[1], "fegyver")) // fegyver
		{
			if(!WeaponCanHave(playerid, weapon))
				return Msg(playerid, "Ilyen fegyvert nem viselhetsz");
			
			if(WeaponCanHoldWeapon(playerid, weapon, 0) < 0)
				return Msg(playerid, "Ilyen fegyvert nem vehetsz ki");
				
			new slot = NINCS;
			for(new s = 0; s < MAX_FEGYVERRAKTAR_SLOT; s++)
			{
				if(FrakcioInfo[frakcio][fFegyver][s] == weapon)
				{
					slot = s;
					break;
				}
			}
			
			if(slot == NINCS)
				return Msg(playerid, "Nincs ilyen fegyver a rakt�rban");
			
			if(WeaponGiveWeapon(playerid, weapon, _, 0) >= 0)
			{
				FrakcioInfo[frakcio][fFegyver][slot] = 0;
				SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Kivett�l egy fegyvert (%s) a rakt�rb�l", GunName(weapon));
				format(_tmpString, 128, "kivett egy fegyvert (%s) a rakt�rb�l", GunName(weapon)), Cselekves(playerid, _tmpString);
				format(_tmpString, 128, "[fegyverrakt�r kivesz fegyvert  | Frakci�: %d] %s kivett egy %s fegyvert a rakt�rb�l", frakcio,PlayerName(playerid), GunName(weapon)), Log("Fegyver", _tmpString);
				INI_Save(INI_TYPE_FEGYVERRAKTAR, frakcio);
			}
			else
				Msg(playerid, "Hiba (#1)");
		}
		else if(egyezik(param[1], "l�szer") || egyezik(param[1], "loszer")) // loszer
		{
			if(!param[3][0] || !isNumeric(param[3]))
				return Msg(playerid, "/fegyverrakt�r kivesz [fegyver/loszer] [fegyvern�v / ID] [l�szer]");
			
			new ammo = strval(param[3]);
			if(ammo < 1)
				return Msg(playerid, "Hib�s l�szersz�m");
			
			if(WeaponType(weapon) == WEAPON_TYPE_HAND)
				return Msg(playerid, "Ez a fegyver nem l�szer alap�");
			
			new kiveve, kivenni = max(0, min(ammo, WeaponMaxAmmo(weapon) - WeaponAmmo(playerid, weapon))), t;
			
			if(!kivenni)
				return Msg(playerid, "Nincs n�lad ennyi hely");
			
			for(new s = 0; s < MAX_FEGYVERRAKTAR_SLOT; s++)
			{
				if(FrakcioInfo[frakcio][fLoszerTipus][s] == weapon && FrakcioInfo[frakcio][fLoszerMennyiseg][s] > 0)
				{
					t = max(0, min(kivenni, FrakcioInfo[frakcio][fLoszerMennyiseg][s]));
					
					kiveve += t;
					kivenni -= t;
					FrakcioInfo[frakcio][fLoszerMennyiseg][s] -= t;
					WeaponGiveAmmo(playerid, weapon, t);
					
					if(FrakcioInfo[frakcio][fLoszerMennyiseg][s] < 1)
						FrakcioInfo[frakcio][fLoszerTipus][s] = 0;
					
					if(!kivenni)
						break;
				}
			}
			
			if(!kiveve)
				return Msg(playerid, "Nem tudt�l kivenni egy darab l�szert sem, mert nincs ilyen fajta l�szer a rakt�rban");
			
			SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Kivett�l %ddb %s l�szert a rakt�rb�l", kiveve, GunName(weapon));
			format(_tmpString, 128, "kivett n�mi %s l�szert (%ddb) a rakt�rb�l", GunName(weapon), kiveve), Cselekves(playerid, _tmpString);
			format(_tmpString, 128, "[fegyverrakt�r kivesz l�szert | Frakci�: %d] %s kivett %ddb %s l�szert a rakt�rb�l", frakcio,PlayerName(playerid), kiveve, GunName(weapon)), Log("Fegyver", _tmpString);
			INI_Save(INI_TYPE_FEGYVERRAKTAR, frakcio);
		}
	}
	else if(egyezik(param[0], "t�r�l") || egyezik(param[0], "torol"))
	{
		if(PlayerInfo[playerid][pRank] < FrakcioInfo[frakcio][fRaktarRang])
			return Msg(playerid, "Nincs el�g magas rangod hozz�!");
		
		if(!param[2][0])
			return Msg(playerid, "/fegyverrakt�r t�r�l fegyver/l�szer [slot (1-50)]", false);
			
		new slot = strval(param[2]) - 1;
		if(slot < 0 || slot >= MAX_FEGYVERRAKTAR_SLOT)
			return SendFormatMessage(playerid, COLOR_LIGHTRED, "Slot: 1-%d", MAX_FEGYVERRAKTAR_SLOT);
		
		if(egyezik(param[1], "fegyver"))
		{
			if(!FrakcioInfo[frakcio][fFegyver][slot])
				return Msg(playerid, "Ezen a sloton nincs fegyver");
			
			SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Kidobott egy %s fegyvert a rakt�rb�l", GunName(FrakcioInfo[frakcio][fFegyver][slot]));
			format(_tmpString, 128, "kidobott egy fegyvert (%ddb) a rakt�rb�l", GunName(FrakcioInfo[frakcio][fFegyver][slot])), Cselekves(playerid, _tmpString);
			format(_tmpString, 128, "[fegyverrakt�r t�r�l fegyvert  | Frakci�: %d] %s t�r�lt egy %s fegyvert a rakt�rb�l", frakcio,PlayerName(playerid), GunName(FrakcioInfo[frakcio][fFegyver][slot])), Log("Fegyver", _tmpString);
			INI_Save(INI_TYPE_FEGYVERRAKTAR, frakcio);
			
			FrakcioInfo[frakcio][fFegyver][slot] = 0;
		}
		else if(egyezik(param[1], "l�szer") || egyezik(param[1], "loszer"))
		{
			if(!FrakcioInfo[frakcio][fLoszerTipus][slot] && !FrakcioInfo[frakcio][fLoszerMennyiseg][slot])
				return Msg(playerid, "Ezen a sloton nincs l�szer");
			
			SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Kidobt�l %ddb %s l�szert a rakt�rb�l", FrakcioInfo[frakcio][fLoszerMennyiseg][slot], GunName(FrakcioInfo[frakcio][fLoszerTipus][slot]));
			format(_tmpString, 128, "kidobott %ddb %s l�szert a rakt�rb�l", FrakcioInfo[frakcio][fLoszerMennyiseg][slot], GunName(FrakcioInfo[frakcio][fLoszerTipus][slot])), Cselekves(playerid, _tmpString);
			format(_tmpString, 128, "[fegyverrakt�r t�r�l l�szert  | Frakci�: %d] %s t�r�lt %ddb %s l�szert a rakt�rb�l",frakcio, PlayerName(playerid), FrakcioInfo[frakcio][fLoszerMennyiseg][slot], GunName(FrakcioInfo[frakcio][fLoszerTipus][slot])), Log("Fegyver", _tmpString);
			INI_Save(INI_TYPE_FEGYVERRAKTAR, frakcio);
			
			FrakcioInfo[frakcio][fLoszerTipus][slot] = 0;
			FrakcioInfo[frakcio][fLoszerMennyiseg][slot] = 0;
		}
	}
	else if(egyezik(param[0], "megn�z") || egyezik(param[0], "megnez"))
	{
		if(!param[1][0])
			return Msg(playerid, "/fegyverrakt�r megn�z fegyver/l�szer", false);
		
		if(egyezik(param[1], "fegyver"))
		{
			new wepstat[MAX_WEAPONS], free;
			for(new s = 0; s < MAX_FEGYVERRAKTAR_SLOT; s++)
			{
				if(1 <= FrakcioInfo[frakcio][fFegyver][s] <= MAX_WEAPONS)
					wepstat[ FrakcioInfo[frakcio][fFegyver][s] - 1 ]++;
				else
					free++;
			}
			
			SendClientMessage(playerid, COLOR_WHITE, "==[ Fegyverrakt�r: fegyverek ]==");
			
			_tmpString = "";
			for(new w = 0; w < MAX_WEAPONS; w++)
			{
				if(strlen(_tmpString) >= 100) SendClientMessage(playerid, COLOR_YELLOW, _tmpString), _tmpString = "";
				
				if(wepstat[w])
				{
					if(strlen(_tmpString))
						format(_tmpString, 128, "%s, %s = %ddb", _tmpString, GunName(w+1), wepstat[w]);
					else
						format(_tmpString, 128, "%s = %ddb", GunName(w+1), wepstat[w]);
				}
			}
			
			if(strlen(_tmpString))
				SendClientMessage(playerid, COLOR_YELLOW, _tmpString), SendFormatMessage(playerid, COLOR_WHITE, "Szabad rekeszek: %ddb", free);
			else
				SendClientMessage(playerid, COLOR_WHITE, "Nincsenek fegyverek a rakt�rban");
		}
		else if(egyezik(param[1], "l�szer") || egyezik(param[1], "loszer"))
		{
			new ammostat[MAX_WEAPONS], free;
			for(new s = 0; s < MAX_FEGYVERRAKTAR_SLOT; s++)
			{
				if(1 <= FrakcioInfo[frakcio][fLoszerTipus][s] <= MAX_WEAPONS && FrakcioInfo[frakcio][fLoszerMennyiseg][s] > 0)
					ammostat[ FrakcioInfo[frakcio][fLoszerTipus][s] - 1 ] += FrakcioInfo[frakcio][fLoszerMennyiseg][s];
				else
					free++;
			}
			
			SendClientMessage(playerid, COLOR_WHITE, "==[ Fegyverrakt�r: l�szerek ]==");
			
			_tmpString = "";
			for(new w = 0; w < MAX_WEAPONS; w++)
			{
				if(strlen(_tmpString) >= 100) SendClientMessage(playerid, COLOR_YELLOW, _tmpString), _tmpString = "";
				
				if(ammostat[w])
				{
					if(strlen(_tmpString))
						format(_tmpString, 128, "%s, %s = %ddb", _tmpString, GunName(w+1), ammostat[w]);
					else
						format(_tmpString, 128, "%s = %ddb", GunName(w+1), ammostat[w]);
				}
			}
			 
			if(strlen(_tmpString))
				SendClientMessage(playerid, COLOR_YELLOW, _tmpString), SendFormatMessage(playerid, COLOR_WHITE, "Szabad rekeszek: %ddb", free);
			else
				SendClientMessage(playerid, COLOR_WHITE, "Nincsenek l�szerek a rakt�rban");
		}
	}
	return 1;
}

ALIAS(f):fegyver;
CMD:fegyver(playerid, params[])
{
	if(TilosOlni == 2 && !IsPlayerNPC(playerid) && !Harcol[playerid] && !Paintballozik[playerid] && !Kikepzoben[playerid] && Loterben[playerid] == NINCS) return Msg(playerid, "ExtraZero alatt nem vehetsz el� fegyvert!");
	if(Bortonben(playerid) > 0) return Msg(playerid, "Persze csak is ezt lehet egy b�rt�nben");
	if(!gLohet[playerid]) return Msg(playerid, "Nem-nem!");
	new func[20], param2[32];
	if(!params[0] || sscanf(params, "s[20] S()[32] ", func, param2))
		return
			Msg(playerid, "Haszn�lata: /f(egyver) [funkci�]"),
			Msg(playerid, "Funkci�: el�vesz [fegyvern�v / fegyverid] - R�vid�t�s: /f e [fegyvern�v / id]"),
			Msg(playerid, "Funkci�: elrak - R�vid�t�s: /f k"),
			Msg(playerid, "Funkci�: �jrat�lt�s - R�vid�t�s: /f r"),
			Msg(playerid, "Funkci�: �tad [fegyver / l�szer] [fegyvern�v / ID]"),
			Msg(playerid, "Funkci�: [vesz / k�sz�t] [fegyver / l�szer] [fegyvern�v / ID]")
		
		;

	if(egyezik(func, "�jrat�lt�s") || egyezik(func, "ujratoltes") || egyezik(func, "r"))
	{
		if(FloodCheck(playerid)) return 1;
		//new weapon = PlayerWeapons[playerid][pArmed];
		if(!WeaponArmed(playerid))
			return Msg(playerid, "Nincs fegyver a kezedben");
		
		/*if(WeaponData[weapon][wType] == WEAPON_TYPE_HAND)
			return Msg(playerid, "M�gis mit akarsz �jrat�lteni?");
		
		new slot = WeaponHaveWeapon(playerid, weapon);
		if(slot == NINCS)
			return Msg(playerid, "M�gis mit akarsz �jrat�lteni?");*/
			
		WeaponArm(playerid, PlayerWeapons[playerid][pArmed]);
		
		if(WeaponArmed(playerid) >= WEAPON_DEAGLE && WeaponArmed(playerid) <= WEAPON_SNIPER)
			OnePlayAnim(playerid,"UZI","UZI_reload",4.0,0,0,0,0,0);
			
		Msg(playerid, "Fegyver �jrat�ltve!");
	}
	if(egyezik(func, "elrak") || egyezik(func, "k"))
	{
		//Cselekves(playerid, "elrakta a fegyver�t", 1);

		if(WeaponArmed(playerid) == pGumilovedek[playerid] || pGumilovedek[playerid] != NINCS)
		{
			pGumilovedek[playerid] = NINCS;
			Msg(playerid, "Visszat�raztad a r�gi l�szereidet..");
			Cselekves(playerid, "visszat�razta az �les t�lt�nyeket �s elrakta a fegyver�t");
		}
		
		Msg(playerid, "Elraktad");
		WeaponArm(playerid);
		return 1;
	}
	else if(egyezik(func, "el�vesz") || egyezik(func, "elovesz") || egyezik(func, "e"))
	{
		
		if(PlayerInfo[playerid][pFegyverTiltIdo] > 0) return Msg(playerid, "El vagy tiltva a fegyver haszn�latt�l!");
		if(PlayerInfo[playerid][pKozmunka] != 0) return Msg(playerid, "K�zmunk�n vagy, nem vehetsz el� fegyvert");
		if(param2[0] == EOS)
			return Msg(playerid, "Haszn�lat: /fegyver elovesz [n�v / id]");

		if(egyezik(param2, "fasz") || egyezik(param2, "faszom"))
			return Msg(playerid, "Nincs ilyen fegyvered!");

		if(NemMozoghat(playerid))
			return Msg(playerid, "Nem vehetsz el� fegyvert!");

		if(PlayerState[playerid] == PLAYER_STATE_DRIVER && !IsHitman(playerid))
			return Msg(playerid, "Vezet�k�nt nem vehetsz el� fegyvert");

		if(AdminDuty[playerid] == 1)
		{
			if(PlayerInfo[playerid][pAdmin] <= 5)
			{
				SendClientMessage(playerid, COLOR_LIGHTBLUE, "Admin szolg�latban vagy, nincs sz�ks�ged a fegyveredre!!");
				return 1;
			}
			else SendClientMessage(playerid, COLOR_LIGHTBLUE, "Admin szolg�latban vagy, ha elfelejtetted l�pj ki!!");
		 }

		new slot, fegyo;
		if(IsNumeric(param2))
		{
			fegyo = strval(param2);
			if(fegyo < 1 || fegyo > MAX_WEAPONS)
				return Msg(playerid, "Nincs ilyen fegyver");
				
			if(fegyo == WEAPON_SHOTGUN) return Msg(playerid, "Ideiglenesen kiv�ve!");
			
			slot = WeaponHaveWeapon(playerid, fegyo);

			if(slot == NINCS)
				return Msg(playerid, "Nincs ilyen fegyvered!");
			
			if(WeaponData[ PlayerWeapons[playerid][pWeapon][slot] ][wType] != WEAPON_TYPE_HAND && PlayerWeapons[playerid][pAmmo][fegyo] < 1)
				return Msg(playerid, "Ehhez a fegyverhez nincs l�szered");

			if(IsPlayerInAnyVehicle(playerid) && (fegyo == 22 || fegyo == 23 || fegyo == 24))
				return Msg(playerid, "Ezt nem veheted el� j�rm�ben");
				
			if(fegyo == 8 && Harcol[playerid])
			{
				SendClientMessage(playerid, COLOR_LIGHTRED, "Rendszer bez�rt a b�rt�nbe, Oka: T�ltott fegyver waron!");
				Jail(playerid, "set", 1800, "ajail2", "T�ltott fegyver waron");
				return 1;
			}
			
			if(WeaponData[fegyo][wType] != WEAPON_TYPE_HAND && Harcol[playerid] && !TeruletInfo[ HarcolTerulet[playerid] ][tLofegyver])
				return Msg(playerid, "L�fegyvert NEM vehetsz el�!");
			
			if(WeaponData[fegyo][wTiltott] && !IsScripter(playerid))
				return Msg(playerid,"Ez egy tiltott fegyver, ez�rt nem veheted el�!");
			
			if(WeaponArmed(playerid) == pGumilovedek[playerid] || pGumilovedek[playerid] != NINCS)
			{
				pGumilovedek[playerid] = NINCS;
				Msg(playerid, "Visszat�raztad a r�gi l�szereidet..");
				Cselekves(playerid, "visszat�razta az �les t�lt�nyeket..");
			}

			WeaponArm(playerid, fegyo);
			//Cselekves(playerid, "elovett egy fegyvert",1);
			Msg(playerid, "El�vett�l egy fegyvert!");
			if(SpawnVedelem[playerid] > 0)
				SpawnVedelem[playerid] = 0;
				
			if(NoDamage[playerid])
				NoDamage[playerid] = 0;

			if(24 <= fegyo <= 34)
				OnePlayAnim(playerid,"UZI","UZI_reload",4.0,0,0,0,0,0);
		}
		else
		{
			fegyo = GetGunID(param2);
			if(fegyo < 1)
				return Msg(playerid, "Nincs ilyen fegyver");
				
			if(fegyo == WEAPON_SHOTGUN) return Msg(playerid, "Ideiglenesen kiv�ve!");
			
			slot = WeaponHaveWeapon(playerid, fegyo);
			
			if(slot == NINCS)
				return Msg(playerid, "Nincs ilyen fegyvered!");
				
			if(WeaponData[fegyo][wType] != WEAPON_TYPE_HAND && PlayerWeapons[playerid][pAmmo][fegyo] < 1)
				return Msg(playerid, "Ehhez a fegyverhez nincs l�szered");

			if(IsPlayerInAnyVehicle(playerid) && (fegyo == 22 || fegyo == 23 || fegyo == 24))
				return Msg(playerid, "Ezt nem veheted el� j�rm�ben");
			
			if(WeaponData[fegyo][wType] != WEAPON_TYPE_HAND && Harcol[playerid] && !TeruletInfo[ HarcolTerulet[playerid] ][tLofegyver])
				return Msg(playerid, "L�fegyvert NEM vehetsz el�!");
			
			
			if(WeaponData[fegyo][wTiltott] && !IsScripter(playerid))
				return Msg(playerid,"Ez egy tiltott fegyver, ez�rt nem veheted el�!");
			
				
			if(WeaponArmed(playerid) == pGumilovedek[playerid] || pGumilovedek[playerid] != NINCS)
			{
				pGumilovedek[playerid] = NINCS;
				Msg(playerid, "Visszat�raztad a r�gi l�szereidet..");
				Cselekves(playerid, "visszat�razta az �les t�lt�nyeket..");
			}

			WeaponArm(playerid, fegyo);
			//Cselekves(playerid, "elovett egy fegyvert", 1);
			Msg(playerid, "El�vett�l egy fegyvert!");
			
			if(SpawnVedelem[playerid] > 0)
				SpawnVedelem[playerid] = 0;
				
			if(NoDamage[playerid])
				NoDamage[playerid] = 0;

			if(fegyo >= 24 && fegyo <= 34)
				OnePlayAnim(playerid,"UZI","UZI_reload",4.0,0,0,0,0,0);
		}
	}
	else if(egyezik(func, "gumil�ved�k") || egyezik(func, "gumilovedek") || egyezik(func, "g"))
	{
		
		if(PlayerInfo[playerid][pFegyverTiltIdo] > 0) return Msg(playerid, "El vagy tiltva a fegyver haszn�latt�l!");
		if(PlayerInfo[playerid][pKozmunka] != 0) return Msg(playerid, "K�zmunk�n vagy, nem vehetsz el� fegyvert");
		if(param2[0] == EOS)
			return Msg(playerid, "Haszn�lat: /fegyver gumil�ved�k [n�v / id]");

		if(NemMozoghat(playerid))
			return Msg(playerid, "Nem vehetsz el� fegyvert!");

		if(PlayerState[playerid] == PLAYER_STATE_DRIVER && !IsHitman(playerid))
			return Msg(playerid, "Vezet�k�nt nem vehetsz el� fegyvert");

		if(AdminDuty[playerid] == 1)
		{
			if(PlayerInfo[playerid][pAdmin] <= 5)
			{
				SendClientMessage(playerid, COLOR_LIGHTBLUE, "Admin szolg�latban vagy, nincs sz�ks�ged a fegyveredre!!");
				return 1;
			}
			else SendClientMessage(playerid, COLOR_LIGHTBLUE, "Admin szolg�latban vagy, ha elfelejtetted l�pj ki!!");
		 }

		new slot, fegyo;
		if(IsNumeric(param2))
		{
			fegyo = strval(param2);
			if(fegyo < 1 || fegyo > MAX_WEAPONS)
				return Msg(playerid, "Nincs ilyen fegyver");
			
			slot = WeaponHaveWeapon(playerid, fegyo);

			if(slot == NINCS)
				return Msg(playerid, "Nincs ilyen fegyvered!");
			
			if(GetGumiLovedek(playerid, fegyo) <= 0) return Msg(playerid, "Ehhez a fegyverhez nincs gumil�ved�ked");

			if(IsPlayerInAnyVehicle(playerid) && (fegyo == 22 || fegyo == 23 || fegyo == 24))
				return Msg(playerid, "Ezt nem veheted el� j�rm�ben");
				
			if(fegyo == 8 && Harcol[playerid])
			{
				SendClientMessage(playerid, COLOR_LIGHTRED, "Rendszer bez�rt a b�rt�nbe, Oka: T�ltott fegyver waron!");
				Jail(playerid, "set", 1800, "ajail2", "T�ltott fegyver waron");
				return 1;
			}
			
			if(WeaponData[fegyo][wType] != WEAPON_TYPE_HAND && Harcol[playerid] && !TeruletInfo[ HarcolTerulet[playerid] ][tLofegyver])
				return Msg(playerid, "L�fegyvert NEM vehetsz el�!");
			
			if(WeaponData[fegyo][wTiltott] && !IsScripter(playerid))
				return Msg(playerid,"Ez egy tiltott fegyver, ez�rt nem veheted el�!");
			
			pGumilovedek[playerid] = fegyo;
			WeaponArm(playerid, fegyo);
			Msg(playerid, "El�vett�l egy fegyvert!");
			Cselekves(playerid, "el�vette a fegyver�t �s bet�razta a gumil�ved�keket..");
			if(SpawnVedelem[playerid] > 0)
				SpawnVedelem[playerid] = 0;
				
			if(NoDamage[playerid])
				NoDamage[playerid] = 0;

			if(24 <= fegyo <= 34)
				OnePlayAnim(playerid,"UZI","UZI_reload",4.0,0,0,0,0,0);
		}
		else
		{
			fegyo = GetGunID(param2);
			if(fegyo < 1)
				return Msg(playerid, "Nincs ilyen fegyver");
			
			slot = WeaponHaveWeapon(playerid, fegyo);
			
			if(slot == NINCS)
				return Msg(playerid, "Nincs ilyen fegyvered!");
			
			if(GetGumiLovedek(playerid, fegyo) <= 0) return Msg(playerid, "Ehhez a fegyverhez nincs gumil�ved�ked");	

			if(IsPlayerInAnyVehicle(playerid) && (fegyo == 22 || fegyo == 23 || fegyo == 24))
				return Msg(playerid, "Ezt nem veheted el� j�rm�ben");
			
			if(WeaponData[fegyo][wType] != WEAPON_TYPE_HAND && Harcol[playerid] && !TeruletInfo[ HarcolTerulet[playerid] ][tLofegyver])
				return Msg(playerid, "L�fegyvert NEM vehetsz el�!");
			
			
			if(WeaponData[fegyo][wTiltott] && !IsScripter(playerid))
				return Msg(playerid,"Ez egy tiltott fegyver, ez�rt nem veheted el�!");
			
			pGumilovedek[playerid] = fegyo;
			WeaponArm(playerid, fegyo);
			//Cselekves(playerid, "elovett egy fegyvert", 1);
			Msg(playerid, "El�vett�l egy fegyvert!");
			Cselekves(playerid, "elovette a fegyver�t �s bet�razta a gumil�ved�keket..");
			
			if(SpawnVedelem[playerid] > 0)
				SpawnVedelem[playerid] = 0;
				
			if(NoDamage[playerid])
				NoDamage[playerid] = 0;

			if(fegyo >= 24 && fegyo <= 34)
				OnePlayAnim(playerid,"UZI","UZI_reload",4.0,0,0,0,0,0);
		}
	}
	/*else if(egyezik(func, "�jrat�lt�s") || egyezik(func, "ujratoltes") || egyezik(func, "r"))
	{
		if(!PlayerWeapons[playerid][pArmed])
			Msg(playerid, "Nincs fegyver a kezedben");
			
		new fegyo = PlayerWeapons[playerid][pArmed];
		
		if(WeaponData[fegyo][wType] == WEAPON_TYPE_HAND)
			return Msg(playerid, "M�gis mit akarsz �jrat�lteni?");
		
		new slot = WeaponHaveWeapon(playerid, fegyo);
		if(slot == NINCS)
			return Msg(playerid, "M�gis mit akarsz �jrat�lteni?");
			
		//Cselekves(playerid, "�jrat�lt�tte a fegyver�t", 1);
		WeaponArm(playerid, PlayerWeapons[playerid][pArmed]);
		Msg(playerid, "Fegyver �jrat�ltve!");
		
		if(WeaponArmed(playerid) >= WEAPON_DEAGLE && WeaponArmed(playerid) <= WEAPON_SNIPER)
			OnePlayAnim(playerid,"UZI","UZI_reload",4.0,0,0,0,0,0);
	}*/
	else if(egyezik(func, "vesz"))
	{
		
		if(PlayerInfo[playerid][pFegyverTiltIdo] > 1)
			return Msg(playerid, "El vagy tiltva a fegyverekt�l");
		 
		new iswep = !param2[0] ? -1 : (egyezik(param2, "fegyver") ? 1 : (egyezik(param2, "l�szer") || egyezik(param2, "loszer") ? 0 : -1));
		
		new weaponstr[32], ammo, celpont;
		if(!param2[0] || iswep == -1
			|| iswep == 1 && sscanf(params, "{s[32]s[32]}s[32]R(-1)", weaponstr, celpont)
			|| iswep == 0 && sscanf(params, "{s[32]s[32]}s[32]I(0)R(-1)", weaponstr, ammo, celpont)
		)
			return
				SendClientMessage(playerid, COLOR_WHITE, "===[ �rak ]==="),
				WeaponPrices(playerid, WEAPON_PRICES_CASH, COLOR_LIGHTBLUE),
				SendClientMessage(playerid, COLOR_YELLOW, "Haszn�lat: /fegyver vesz fegyver [fegyvern�v / ID] (j�t�kos)"),
				SendClientMessage(playerid, COLOR_YELLOW, "Haszn�lat: /fegyver vesz l�szer [fegyvern�v / ID] [mennyis�g] (j�t�kos)")
			;
		
		if(celpont == INVALID_PLAYER_ID)
			return Msg(playerid, "Nincs ilyen j�t�kos");
		else if(celpont == -1)
			celpont = playerid;
		else if(celpont != playerid && GetDistanceBetweenPlayers(playerid, celpont) > 5)
				return Msg(playerid, "� nincs a k�zeledben");
		
		new biz = BizbeVan(playerid);
		if(biz != BIZ_GS1 && biz != BIZ_GS2 && biz != BIZ_PB)
			return Msg(playerid, "Nem vagy fegyverboltban");
		
		if(BizzInfo[biz][bProducts] < 1)
			return Msg(playerid, "A fegyverbolt �res, nincs rakt�ron fegyver");
			
		if(PlayerInfo[playerid][pGunLic] < 1) return Msg(playerid, "Nincs fegyverenged�lyed!");
			
		if(iswep == 1)
		{
			new weapon = GetGunFromString(weaponstr);
			
			if(weapon < 1 || weapon > MAX_WEAPONS)
				return Msg(playerid, "Ilyen fegyver nem l�tezik");
				
			if(Szint(playerid) < WEAPON_MIN_LEVEL && !UtosFegyver(weapon))
				return SendFormatMessage(playerid, COLOR_LIGHTRED, "Hiba: Fegyverhaszn�lat nem enged�lyezett a %d. szintig", WEAPON_MIN_LEVEL);
			
			if(WeaponData[weapon][wTiltott] && !IsScripter(playerid))
				return Msg(playerid,"Ez egy tiltott fegyver!");
				
			if(!WeaponPrice[weapon][wWeapon])
				return Msg(playerid, "Ilyen fegyver nem vehet� a fegyverboltban");
			
			if(WeaponCanHoldWeapon(celpont, weapon, 0) < 0)
				return Msg(playerid, "Ilyen fegyvert nem tudsz venni");
			
			if(!BankkartyaFizet(playerid, WeaponPrice[weapon][wWeapon]))
				return Msg(playerid, "Ezt nem tudod kifizetni");
			
			BizPenz(biz, WeaponPrice[weapon][wWeapon]);
			BizzInfo[biz][bProducts]--;
			BizUpdate(biz, BIZ_Products);
			
			WeaponGiveWeapon(celpont, weapon, .maxweapon = 0);
			
			if(celpont == playerid)
			{
				format(_tmpString, 128, "vett egy %s-t", GunName(weapon)), Cselekves(playerid, _tmpString);
				SendFormatMessage(playerid, COLOR_WHITE, "Vett�l egy %s-t", GunName(weapon));
			}
			else
			{
				format(_tmpString, 128, "vett egy %s-t neki: %s", GunName(weapon), PlayerName(celpont)), Cselekves(playerid, _tmpString);
				SendFormatMessage(playerid, COLOR_WHITE, "Vett�l egy %s-t neki: %s", GunName(weapon), PlayerName(celpont));
				SendFormatMessage(celpont, COLOR_WHITE, "%s vett neked egy %s-t", PlayerName(playerid), GunName(weapon));
			}
		}
		else if(iswep == 0)
		{
			new weapon = GetGunFromString(weaponstr);
			if(weapon < 1 || weapon > MAX_WEAPONS)
				return Msg(playerid, "Ilyen fegyver nem l�tezik");
			
			if(WeaponData[weapon][wTiltott] && !IsScripter(playerid))
				return Msg(playerid,"Ez egy tiltott fegyver, ez�rt ehhez nem vehetsz l�szert!");
				
			if(!WeaponPrice[weapon][wAmmo])
				return Msg(playerid, "Ilyen l�szer nem vehet� a fegyverboltban");
			
			if(ammo < 1)
				return Msg(playerid, "Hib�s l�szer mennyis�g");
				
			new venni = max(0, min(ammo, WeaponMaxAmmo(weapon) - WeaponAmmo(celpont, weapon)));
			if(!venni)
				return Msg(playerid, "Nincs hely l�szernek");
			
			new koltseg = venni * WeaponPrice[weapon][wAmmo];
			if(!BankkartyaFizet(playerid, koltseg))
				return Msg(playerid, "Ezt nem tudod kifizetni");
				
			BizPenz(biz, koltseg);
			BizzInfo[biz][bProducts]--;
			BizUpdate(biz, BIZ_Products);
			
			WeaponGiveAmmo(celpont, weapon, venni);
			
			if(celpont == playerid)
			{
				format(_tmpString, 128, "vett n�mi %s l�szert", GunName(weapon)), Cselekves(playerid, _tmpString);
				SendFormatMessage(playerid, COLOR_WHITE, "Vett�l %ddb %s l�szert", venni, GunName(weapon));
			}
			else
			{
				format(_tmpString, 128, "vett n�mi %s l�szert neki: %s", GunName(weapon), PlayerName(celpont)), Cselekves(playerid, _tmpString);
				SendFormatMessage(playerid, COLOR_WHITE, "Vett�l %ddb %s l�szert neki: %s", venni, GunName(weapon), PlayerName(celpont));
				SendFormatMessage(celpont, COLOR_WHITE, "%s vett neked %ddb %s l�szert", PlayerName(playerid), venni, GunName(weapon));
			}
		}
		else
			Msg(playerid, "Hib�s opci� (fegyver / l�szer)");
	}
	else if(egyezik(func, "k�sz�t") || egyezik(func, "keszit"))
	{
		if(Szint(playerid) < WEAPON_MIN_LEVEL)
			return SendFormatMessage(playerid, COLOR_LIGHTRED, "Hiba: Fegyverhaszn�lat nem enged�lyezett a %d. szintig", WEAPON_MIN_LEVEL);
		
		if(PlayerInfo[playerid][pFegyverTiltIdo] > 1)
			return Msg(playerid, "El vagy tiltva a fegyverekt�l");
		
		new iswep = !param2[0] ? -1 : (egyezik(param2, "fegyver") ? 1 : (egyezik(param2, "l�szer") || egyezik(param2, "loszer") ? 0 : -1));
		
		new weaponstr[32], ammo, celpont;
		if(!param2[0] || iswep == -1
			|| iswep == 1 && sscanf(params, "{s[32]s[32]}s[32]R(-1)", weaponstr, celpont)
			|| iswep == 0 && sscanf(params, "{s[32]s[32]}s[32]I(0)R(-1)", weaponstr, ammo, celpont)
		)
			return
				SendClientMessage(playerid, COLOR_WHITE, "===[ �rak ]==="),
				WeaponPrices(playerid, WEAPON_PRICES_MATS, COLOR_LIGHTBLUE),
				SendClientMessage(playerid, COLOR_YELLOW, "Haszn�lat: /fegyver k�sz�t fegyver [fegyvern�v / ID] (j�t�kos)"),
				SendClientMessage(playerid, COLOR_YELLOW, "Haszn�lat: /fegyver k�sz�t l�szer [fegyvern�v / ID] [mennyis�g] (j�t�kos)")
			;
		
		if(celpont == INVALID_PLAYER_ID)
			return Msg(playerid, "Nincs ilyen j�t�kos");
		else if(celpont == -1)
			celpont = playerid;
		else if(celpont != playerid && GetDistanceBetweenPlayers(playerid, celpont) > 5)
			return Msg(playerid, "� nincs a k�zeledben");
		
		if(iswep == 1)
		{
			new weapon = GetGunFromString(weaponstr);
			if(weapon < 1 || weapon > MAX_WEAPONS)
				return Msg(playerid, "Ilyen fegyver nem l�tezik");
			
			if(weapon == WEAPON_AK47)
			{
				if(PlayerInfo[playerid][pFem] < 2) return Msg(playerid, "Nincs el�g f�med, minimum 2db!");
				
				PlayerInfo[playerid][pFem] -= 2;
				
				WeaponGiveWeapon(celpont, WEAPON_AK47, .maxweapon = 0);
				
				if(celpont == playerid)
				{
					format(_tmpString, 128, "k�sz�tett egy %s-t", GunName(weapon)), Cselekves(playerid, _tmpString);
					SendFormatMessage(playerid, COLOR_WHITE, "K�sz�tett�l egy %s-t", GunName(weapon));
				}
				else
				{
					format(_tmpString, 128, "k�sz�tett egy %s-t neki: %s", GunName(weapon), PlayerName(celpont)), Cselekves(playerid, _tmpString);
					SendFormatMessage(playerid, COLOR_WHITE, "K�sz�tett�l egy %s-t neki: %s", GunName(weapon), PlayerName(celpont));
					SendFormatMessage(celpont, COLOR_WHITE, "%s k�sz�tett neked egy %s-t", PlayerName(playerid), GunName(weapon));
				}
				
				return 1;
				
			}
			
			if(!WeaponPrice[weapon][wWeaponMat])
				return Msg(playerid, "Ilyen fegyver nem k�sz�thet�");
			
			if(WeaponCanHoldWeapon(celpont, weapon, 0) < 0)
				return Msg(playerid, "Ilyen fegyvert nem tudsz k�sz�teni");
			
			if(PlayerInfo[playerid][pMats] < WeaponPrice[weapon][wWeaponMat])
				return Msg(playerid, "Nincs ennyi materialod");
			
			PlayerInfo[playerid][pMats] -= WeaponPrice[weapon][wWeaponMat];
			
			WeaponGiveWeapon(celpont, weapon, .maxweapon = 0);
			
			if(celpont == playerid)
			{
				format(_tmpString, 128, "k�sz�tett egy %s-t", GunName(weapon)), Cselekves(playerid, _tmpString);
				SendFormatMessage(playerid, COLOR_WHITE, "K�sz�tett�l egy %s-t", GunName(weapon));
			}
			else
			{
				format(_tmpString, 128, "k�sz�tett egy %s-t neki: %s", GunName(weapon), PlayerName(celpont)), Cselekves(playerid, _tmpString);
				SendFormatMessage(playerid, COLOR_WHITE, "K�sz�tett�l egy %s-t neki: %s", GunName(weapon), PlayerName(celpont));
				SendFormatMessage(celpont, COLOR_WHITE, "%s k�sz�tett neked egy %s-t", PlayerName(playerid), GunName(weapon));
			}
		}
		else if(iswep == 0)
		{
			new weapon = GetGunFromString(weaponstr);
			if(weapon < 1 || weapon > MAX_WEAPONS)
				return Msg(playerid, "Ilyen fegyver nem l�tezik");
			
			if(!WeaponPrice[weapon][wAmmoMat])
				return Msg(playerid, "Ilyen l�szer nem k�sz�thet�");
			
			if(ammo < 1)
				return Msg(playerid, "Hib�s l�szer mennyis�g");
				
			new venni = max(0, min(ammo, WeaponMaxAmmo(weapon) - WeaponAmmo(celpont, weapon)));
			if(!venni)
				return Msg(playerid, "Nincs hely l�szernek");
			
			new koltseg = venni * WeaponPrice[weapon][wAmmoMat];
			if(PlayerInfo[playerid][pMats] < koltseg)
				return Msg(playerid, "Nincs ennyi materialod");
				
			PlayerInfo[playerid][pMats] -= koltseg;
			
			WeaponGiveAmmo(celpont, weapon, venni);
			
			if(celpont == playerid)
			{
				format(_tmpString, 128, "k�sz�tett n�mi %s l�szert", GunName(weapon)), Cselekves(playerid, _tmpString);
				SendFormatMessage(playerid, COLOR_WHITE, "K�sz�tett�l %ddb %s l�szert", venni, GunName(weapon));
			}
			else
			{
				format(_tmpString, 128, "k�sz�tett n�mi %s l�szert neki: %s", GunName(weapon), PlayerName(celpont)), Cselekves(playerid, _tmpString);
				SendFormatMessage(playerid, COLOR_WHITE, "K�sz�tett�l %ddb %s l�szert neki: %s", venni, GunName(weapon), PlayerName(celpont));
				SendFormatMessage(celpont, COLOR_WHITE, "%s k�sz�tett neked %ddb %s l�szert", PlayerName(playerid), venni, GunName(weapon));
			}
		}
		else
			Msg(playerid, "Hib�s opci� (fegyver / l�szer)");
	}
	else if(egyezik(func, "�tad") || egyezik(func, "atad"))
	{
		if(Paintballozik[playerid])
			return Msg(playerid, "Paintball alatt nem lehets�ges");
			
		new celpont, weaponstr[32], ammo;
		if(!param2[0] || sscanf(params, "{s[32] s[32] }rs[32] I(0)", celpont, weaponstr, ammo))
			return
				SendClientMessage(playerid, COLOR_YELLOW, "Haszn�lat: /f �tad fegyver [j�t�kos n�v / ID] [fegyvern�v / ID]"),
				SendClientMessage(playerid, COLOR_YELLOW, "Haszn�lat: /f �tad l�szer [j�t�kos n�v / ID] [fegyvern�v / ID] [mennyis�g]")
			;
		
		if(celpont == INVALID_PLAYER_ID)
			return Msg(playerid, "Nem l�tez� j�t�kos");
		
		if(GetDistanceBetweenPlayers(playerid, celpont) > 2)
			return Msg(playerid, "� nincs a k�zeledben");
		
		if(PlayerState[playerid] != PLAYER_STATE_ONFOOT || PlayerState[celpont] != PLAYER_STATE_ONFOOT)
			return Msg(playerid, "Kocsiban nem lehet");
		
		if(PlayerInfo[playerid][pFegyverTiltIdo] > 0 || PlayerInfo[celpont][pFegyverTiltIdo] > 0 )
			return Msg(playerid, "Egyik�t�k el van tiltva a fegyvert�l!");
		
		new weapon = GetGunFromString(weaponstr);
		if(weapon < 1 || weapon > MAX_WEAPONS)
			return Msg(playerid, "Ilyen fegyver nem l�tezik");
			
		if((Szint(playerid) < WEAPON_MIN_LEVEL && !UtosFegyver(weapon)) || (Szint(celpont) < WEAPON_MIN_LEVEL && !UtosFegyver(weapon)))
			return Msg(playerid, "T�l kicsi a szinted vagy az � szintje a fegyverhaszn�lathoz");
		
		if(egyezik(param2, "fegyver"))
		{
			if((weapon == WEAPON_CHAINSAW || weapon == WEAPON_FIREEXTINGUISHER) && !LMT(celpont, FRAKCIO_TUZOLTO))
				return Msg(playerid, "Porolt� �s l�ncf�r�sz nem adhat� �t, csak t�zolt�nak!");
			
			if(WeaponHaveWeapon(playerid, weapon) < 0)
				return Msg(playerid, "Nincs ilyen fegyvered");
			
			if(WeaponCanHoldWeapon(celpont, weapon, 0) < 0)
				return Msg(playerid, "Nincs hely a fegyvernek");
			
			WeaponTakeWeapon(playerid, weapon);
			WeaponGiveWeapon(celpont, weapon, 0);
			SendFormatMessage(playerid, COLOR_LIGHTBLUE, "�tadt�l neki egy %s-t", GunName(weapon));
			SendFormatMessage(celpont, COLOR_LIGHTBLUE, "�tadtak neked egy %s-t", GunName(weapon));
			
			OnePlayAnim(playerid, "GANGS", "shake_cara", 4.0, 0, 0, 0, 0, 0);
			OnePlayAnim(celpont, "GANGS", "shake_cara", 4.0, 0, 0, 0, 0, 0);
			
			if(!PlayerInfo[playerid][pMember])
				if(!PlayerInfo[celpont][pMember])
					format(_tmpString, 128, "[�tad][Civil]%s �tadott neki: [Civil]%s, egy %s-t", PlayerName(playerid), PlayerName(celpont), GunName(weapon)), Log("Fegyver", _tmpString);
				else
					format(_tmpString, 128, "[�tad][Civil]%s �tadott neki: [%s]%s, egy %s-t", PlayerName(playerid), Szervezetneve[ PlayerInfo[celpont][pMember] - 1 ], PlayerName(celpont), GunName(weapon)), Log("Fegyver", _tmpString);
			else
				if(!PlayerInfo[celpont][pMember])
					format(_tmpString, 128, "[�tad][%s]%s �tadott neki: [Civil]%s, egy %s-t", Szervezetneve[ PlayerInfo[playerid][pMember] - 1 ], PlayerName(playerid), PlayerName(celpont), GunName(weapon)), Log("Fegyver", _tmpString);
				else
					format(_tmpString, 128, "[�tad][%s]%s �tadott neki: [%s]%s, egy %s-t", Szervezetneve[ PlayerInfo[playerid][pMember] - 1 ], PlayerName(playerid), Szervezetneve[ PlayerInfo[celpont][pMember] - 1 ], PlayerName(celpont), GunName(weapon)), Log("Fegyver", _tmpString);
		}
		else if(egyezik(param2, "l�szer") || egyezik(param2, "loszer"))
		{
			if(ammo < 1)
				return Msg(playerid, "Hib�s l�szer mennyis�g");
			
			new atadni = max(0, min(ammo, min(WeaponAmmo(playerid, weapon), WeaponMaxAmmo(weapon) - WeaponAmmo(celpont, weapon))));
			if(!atadni)
				return Msg(playerid, "Nincs hely n�la");
			
			if(WeaponAmmo(playerid, weapon) < 0)
				return Msg(playerid, "Nincs ilyen fegyvered");
			
			if(WeaponCanHoldWeapon(celpont, weapon, 0) < 0)
				return Msg(playerid, "Nincs hely a fegyvernek");
			
			WeaponGiveAmmo(playerid, weapon, -atadni);
			WeaponGiveAmmo(celpont, weapon, atadni);
			SendFormatMessage(playerid, COLOR_LIGHTBLUE, "�tadt�l neki egy %ddb %s l�szert", atadni, GunName(weapon));
			SendFormatMessage(celpont, COLOR_LIGHTBLUE, "%s �tadott neked %ddb %s l�szert", PlayerName(playerid), atadni, GunName(weapon));
			
			OnePlayAnim(playerid, "GANGS", "shake_cara", 4.0, 0, 0, 0, 0, 0);
			OnePlayAnim(celpont, "GANGS", "shake_cara", 4.0, 0, 0, 0, 0, 0);
			
			if(!PlayerInfo[playerid][pMember])
				if(!PlayerInfo[celpont][pMember])
					format(_tmpString, 128, "[�tad][Civil]%s �tadott neki: [Civil]%s, %ddb %s l�szert", PlayerName(playerid), PlayerName(celpont), atadni, GunName(weapon)), Log("Fegyver", _tmpString);
				else
					format(_tmpString, 128, "[�tad][Civil]%s �tadott neki: [%s]%s, %ddb %s l�szert", PlayerName(playerid), Szervezetneve[ PlayerInfo[celpont][pMember] - 1 ], PlayerName(celpont), atadni, GunName(weapon)), Log("Fegyver", _tmpString);
			else
				if(!PlayerInfo[celpont][pMember])
					format(_tmpString, 128, "[�tad][%s]%s �tadott neki: [Civil]%s, %ddb %s l�szert", Szervezetneve[ PlayerInfo[playerid][pMember] - 1 ], PlayerName(playerid), PlayerName(celpont), atadni, GunName(weapon)), Log("Fegyver", _tmpString);
				else
					format(_tmpString, 128, "[�tad][%s]%s �tadott neki: [%s]%s, %ddb %s l�szert", Szervezetneve[ PlayerInfo[playerid][pMember] - 1 ], PlayerName(playerid), Szervezetneve[ PlayerInfo[celpont][pMember] - 1 ], PlayerName(celpont), atadni, GunName(weapon)), Log("Fegyver", _tmpString);
		}
	}
	
	return 1;
}

CMD:ammo(playerid, params[])
{
	if(!Admin(playerid, 5)) return 1;

	if(params[0] == EOS)
		return
			SendClientMessage(playerid, COLOR_LIGHTRED, "Haszn�lat: /ammo [J�t�kos] [FegyverID] [L�szer] | /ammo t�r�l [J�t�kos]"),
			SendClientMessage(playerid, COLOR_GRAD4, "3(Club) 4(knife) 5(bat) 6(Shovel) 7(Cue) 8(Katana) 10-13(Dildo) 14(Flowers) 16(Grenades) 18(Molotovs) 22(Pistol) 23(SPistol)"),
			SendClientMessage(playerid, COLOR_GRAD3, "24(Eagle) 25(shotgun) 29(MP5) 30(AK47) 31(M4) 33(Rifle) 34(Sniper) 37(Flamethrower) 41(spray) 42(exting) 43(Camera) 46(Parachute)")
		;
	
	new param[10], player;
	if(!sscanf(params, "s[10]r", param, player))
	{
		if(egyezik(param, "t�r�l"))
		{
			if(player == INVALID_PLAYER_ID)
				return Msg(playerid, "Nem l�tez� j�t�kos");

			WeaponResetAmmos(player);
			ABroadCastFormat(COLOR_LIGHTRED, PlayerInfo[playerid][pAdmin], "<< %s t�r�lte %s zseb�ben l�v� l�szereit (fegyvert nem) >>", AdminName(playerid), PlayerName(player));
			
			return 1;
		}
	}
	
	new weaponstr[32], ammo;
	if(sscanf(params, "rs[32] i", player, weaponstr, ammo))
		return
			SendClientMessage(playerid, COLOR_LIGHTRED, "Haszn�lat: /ammo [J�t�kos] [FegyverID] [L�szer] | /ammo t�r�l [J�t�kos]"),
			SendClientMessage(playerid, COLOR_GRAD4, "3(Club) 4(knife) 5(bat) 6(Shovel) 7(Cue) 8(Katana) 10-13(Dildo) 14(Flowers) 16(Grenades) 18(Molotovs) 22(Pistol) 23(SPistol)"),
			SendClientMessage(playerid, COLOR_GRAD3, "24(Eagle) 25(shotgun) 29(MP5) 30(AK47) 31(M4) 33(Rifle) 34(Sniper) 37(Flamethrower) 41(spray) 42(exting) 43(Camera) 46(Parachute)")
		;
			
	
	if(player == INVALID_PLAYER_ID)
		return Msg(playerid, "Nem l�tez� j�t�kos");
	
	new weapon = GetGunFromString(weaponstr);
	if(weapon < 1 || weapon > MAX_WEAPONS)
		return Msg(playerid, "Hib�s fegyver! 1-47");
		
	if(Szint(player) < WEAPON_MIN_LEVEL && !UtosFegyver(weapon))
		return SendFormatMessage(playerid, COLOR_LIGHTRED, "Fegyver csak a %d. szintt�l enged�lyezett, a j�t�kos szintje %d", WEAPON_MIN_LEVEL, Szint(player));
	
	if(!WeaponData[weapon][wAmmo])
		return Msg(playerid, "Ehhez a fegyverhez nem lehet l�szert adni");
	
	if(ammo < 1 || ammo > WeaponData[weapon][wAmmo])
		return SendFormatMessage(playerid, COLOR_LIGHTRED, "A l�szer minimum 1db, maximum %ddb lehet", WeaponData[weapon][wAmmo]);

	new oldammo = PlayerWeapons[player][pAmmo][weapon];
	if(!WeaponGiveAmmo(player, weapon, ammo))
		return Msg(playerid, "Ehhez a fegyverhez nem lehet l�szert adni");
	
	ABroadCastFormat(COLOR_LIGHTRED, PlayerInfo[playerid][pAdmin], "<< Admin %s %ddb %s l�szert adott neki: %s - r�gi: %ddb, �j: %ddb >>", AdminName(playerid), ammo, GetGunName(weapon), PlayerName(player), oldammo, WeaponAmmo(player, weapon));
	tformat(128, "[/ammo]%s adott %ddb %s l�szert neki: %s", Nev(playerid), ammo, GunName(weapon), Nev(player));
	return 1;
}

CMD:gun(playerid, params[])
{
	if(!Admin(playerid, 5)) return 1;

	if(params[0] == EOS)
		return
			SendClientMessage(playerid, COLOR_LIGHTRED, "Haszn�lat: /gun [J�t�kos] [FegyverID] | /gun t�r�l [J�t�kos]"),
			SendClientMessage(playerid, COLOR_GRAD4, "3(Club) 4(knife) 5(bat) 6(Shovel) 7(Cue) 8(Katana) 10-13(Dildo) 14(Flowers) 16(Grenades) 18(Molotovs) 22(Pistol) 23(SPistol)"),
			SendClientMessage(playerid, COLOR_GRAD3, "24(Eagle) 25(shotgun) 29(MP5) 30(AK47) 31(M4) 33(Rifle) 34(Sniper) 37(Flamethrower) 41(spray) 42(exting) 43(Camera) 46(Parachute)")
		;
	
	new param[10], player;
	if(!sscanf(params, "s[10]r", param, player))
	{
		if(egyezik(param, "t�r�l"))
		{
			if(player == INVALID_PLAYER_ID)
				return Msg(playerid, "Nem l�tez� j�t�kos");

			WeaponResetWeapons(player);
			ABroadCastFormat(COLOR_LIGHTRED, PlayerInfo[playerid][pAdmin], "<< %s t�r�lte %s zseb�ben l�v� fegyvereit (l�szert nem) >>", AdminName(playerid), PlayerName(player));
			
			return 1;
		}
	}
	
	new weaponstr[32];
	if(sscanf(params, "rs[32] ", player, weaponstr))
		return
			SendClientMessage(playerid, COLOR_LIGHTRED, "Haszn�lat: /gun [J�t�kos] [Fegyvern�v/ID] | /gun t�r�l [J�t�kos]"),
			SendClientMessage(playerid, COLOR_GRAD4, "3(Club) 4(knife) 5(bat) 6(Shovel) 7(Cue) 8(Katana) 10-13(Dildo) 14(Flowers) 16(Grenades) 18(Molotovs) 22(Pistol) 23(SPistol)"),
			SendClientMessage(playerid, COLOR_GRAD3, "24(Eagle) 25(shotgun) 29(MP5) 30(AK47) 31(M4) 33(Rifle) 34(Sniper) 37(Flamethrower) 41(spray) 42(exting) 43(Camera) 46(Parachute)")
		;
			
	
	if(player == INVALID_PLAYER_ID)
		return Msg(playerid, "Nem l�tez� j�t�kos");
	
	new weapon = GetGunFromString(weaponstr);
	if(weapon < 1 || weapon > MAX_WEAPONS)
		return Msg(playerid, "Hib�s fegyver! 1-47");
		
	if(Szint(player) < WEAPON_MIN_LEVEL && !UtosFegyver(weapon))
		return SendFormatMessage(playerid, COLOR_LIGHTRED, "Fegyver csak a %d. szinttol enged�lyezett, a j�t�kos szintje %d", WEAPON_MIN_LEVEL, Szint(player));

	new slot = WeaponGiveWeapon(player, weapon, _, 0);
	
	if(slot == WEAPONS_CAN_HOLD_WEAPON_FULL)
		return Msg(playerid, "N�la m�r nincs t�bb hely!");
	else if(slot == WEAPONS_CAN_HOLD_WEAPON_MANY)
		return Msg(playerid, "Ebb�l a fegyverb�l nem adhatsz neki");
	else if(slot == WEAPONS_CAN_HOLD_WEAPON_NO)
		return Msg(playerid, "Ilyen fegyvert nem adhatsz neki");
	else if(slot < 0)
		return Msg(playerid, "Hiba!");
	
	ABroadCastFormat(COLOR_LIGHTRED, PlayerInfo[playerid][pAdmin], "<< Admin %s fegyvert adott neki: %s - fegyver: %s >>", AdminName(playerid), PlayerName(player), GetGunName(weapon));
	tformat(128, "[/gun]%s adott egy %s-t neki: %s", Nev(playerid), GunName(weapon), Nev(player));
	return 1;
}

ALIAS(t2rfigyel6):terfigyelo;
CMD:terfigyelo(playerid, params[])
{
	if(!IsACop(playerid))
		return 1;

	new sub[32], subparams[64];
	if(sscanf(params, "s[32]S()[64]", sub, subparams))
		return SendClientMessage(playerid, COLOR_WHITE, "Haszn�lata: /t�rfigyel� [jelz�sek / jelz�s / t�rk�p / utols�poz�ci�]");
	
	if(egyezik(sub, "jelzes") || egyezik(sub, "jelz�s"))
	{
		new jelzes;
		if(sscanf(subparams, "i", jelzes))
		{
			SendClientMessage(playerid, COLOR_LIGHTRED, "Haszn�lata: /t�rfigyelo jelz�s [jelz�s szint]");
			SendClientMessage(playerid, COLOR_WHITE, "Jelz�sek: 0 = kikapcsolva, 1 = fegyvervisel�s, 2 = c�lz�s + fegyvervisel�s, stb.");
			SendClientMessage(playerid, COLOR_WHITE, "Jelz�sek megtekinthet�ek a wikip�di�n: wiki.classrpg.net/T�rfigyel�");
			return 1;
		}
		
		if(jelzes < 0 || jelzes > PLAYER_MARKER_MKILL)
			return SendClientMessage(playerid, COLOR_LIGHTRED, "Jelz�s: Minimum 0, maximum 5");
			
		PlayerInfo[playerid][pJelzes] = jelzes;
		
		switch(jelzes)
		{
			case PLAYER_MARKER_ENGEDELY: Msg(playerid, "Jelz�sek: enged�ly, fegyvervisel�s, fenyeget�s, testis�rt�s, ember�l�s, t�bbsz�r�s ember�l�s");
			case PLAYER_MARKER_WEAPONHOLD: Msg(playerid, "Jelz�sek: fegyvervisel�s, fenyeget�s, testis�rt�s, ember�l�s, t�bbsz�r�s ember�l�s");
			case PLAYER_MARKER_TARGET: Msg(playerid, "Jelz�sek: fenyeget�s, testis�rt�s, ember�l�s, t�bbsz�r�s ember�l�s");
			case PLAYER_MARKER_SHOOT: Msg(playerid, "Jelz�sek: testis�rt�s, ember�l�s, t�bbsz�r�s ember�l�s");
			case PLAYER_MARKER_KILL: Msg(playerid, "Jelz�sek: ember�l�s, t�bbsz�r�s ember�l�s");
			case PLAYER_MARKER_MKILL: Msg(playerid, "Jelz�sek: t�bbsz�r�s ember�l�s");
			default: Msg(playerid, "Jelz�s kikapcsolva - most m�r nem fogja chatben �rni az �j b�n�z�ket");
		}
	}
	elseif(egyezik(sub, "terkep") || egyezik(sub, "t�rk�p"))
	{
		new jelzes;
		if(sscanf(subparams, "i", jelzes))
		{
			SendClientMessage(playerid, COLOR_LIGHTRED, "Haszn�lata: /t�rfigyel� t�rk�p [jelz�s szint]");
			SendClientMessage(playerid, COLOR_WHITE, "Jelz�sek: 0 = kikapcsolva, 1 = fegyvervisel�s, 2 = c�lz�s + fegyvervisel�s, stb.");
			SendClientMessage(playerid, COLOR_WHITE, "Jelz�sek megtekinthetoek a wikip�di�n: wiki.classrpg.net/T�rfigyel�");
			return 1;
		}
		
		if(jelzes < 0 || jelzes > PLAYER_MARKER_MKILL)
			return SendClientMessage(playerid, COLOR_LIGHTRED, "Jelz�s: Minimum 0, maximum 5");
			
		PlayerInfo[playerid][pJelzesTerkep] = jelzes;
		
		switch(jelzes)
		{
			case PLAYER_MARKER_ENGEDELY: Msg(playerid, "T�rk�p jelz�sek: enged�ly, fegyvervisel�s, fenyeget�s, testis�rt�s, ember�l�s, t�bbsz�r�s ember�l�s");
			case PLAYER_MARKER_WEAPONHOLD: Msg(playerid, "T�rk�p jelz�sek: fegyvervisel�s, fenyeget�s, testis�rt�s, ember�l�s, t�bbsz�r�s ember�l�s");
			case PLAYER_MARKER_TARGET: Msg(playerid, "T�rk�p jelz�sek: fenyeget�s, testis�rt�s, ember�l�s, t�bbsz�r�s ember�l�s");
			case PLAYER_MARKER_SHOOT: Msg(playerid, "T�rk�p jelz�sek: testis�rt�s, ember�l�s, t�bbsz�r�s ember�l�s");
			case PLAYER_MARKER_KILL: Msg(playerid, "T�rk�p jelz�sek: ember�l�s, t�bbsz�r�s ember�l�s");
			case PLAYER_MARKER_MKILL: Msg(playerid, "T�rk�p jelz�sek: t�bbsz�r�s ember�l�s");
			default: Msg(playerid, "Jelz�s kikapcsolva - most m�r nem fogja chatben �rni az �j b�n�z�ket");
		}
		
		MarkerAction(playerid, PLAYER_MARKER_ON_REFRESH);
	}
	elseif(egyezik(sub, "utolsopozicio") || egyezik(sub, "utols�poz�ci�"))
	{
		new bid;
		if(sscanf(subparams, "i", bid))
			return SendClientMessage(playerid, COLOR_LIGHTRED, "Haszn�lata: /t�rfigyelo utols�poz�ci� [egyedi ID (pl.: 1234)]");
		
		if(bid < 1000 || bid > 9999)
			return Msg(playerid, "1000-9999");
		
		new player = NINCS;
		foreach(Jatekosok, p)
		{
			if(PlayerInfo[p][pBID] == bid)
			{
				player = p;
				break;
			}
		}
		
		if(player == NINCS || PlayerMarker[player][mLastPos][0] == 0.0)
			return Msg(playerid, "Utols� poz�ci� nem ismert");
			
		SetPlayerCheckpoint(playerid, ArrExt(PlayerMarker[player][mLastPos]), 3.0);
		SendFormatMessage(playerid, COLOR_LIGHTRED, "T�rfigyel�: %d jelezve a t�rk�pen", PlayerInfo[player][pBID]);
	}
	elseif(egyezik(sub, "jelzesek") || egyezik(sub, "jelz�sek"))
	{
		new jelzes;
		sscanf(subparams, "I(1)", jelzes);
		
		if(jelzes < 1 || jelzes > PLAYER_MARKER_MKILL)
			jelzes = PLAYER_MARKER_MKILL;
		
		new bool:found;
		foreach(Jatekosok, p)
		{
			if(PlayerMarker[p][mType] >= jelzes && !PLAYER_MARKER_IS_HIDDEN(p))
			{
				switch(PlayerMarker[p][mType])
				{
					case PLAYER_MARKER_ENGEDELY:
						SendFormatMessage(playerid, PLAYER_MARKER_COLOR_ENGEDELY, "[T�rfigyel�: enged�ly] #%d - %dmp", PlayerInfo[p][pBID], PlayerMarker[p][mTime]);
					case PLAYER_MARKER_WEAPONHOLD:
						SendFormatMessage(playerid, PLAYER_MARKER_COLOR_WEAPONHOLD, "[T�rfigyel�: fegyvervisel�s] #%d - %dmp", PlayerInfo[p][pBID], PlayerMarker[p][mTime]);
					case PLAYER_MARKER_TARGET:
						SendFormatMessage(playerid, PLAYER_MARKER_COLOR_TARGET, "[T�rfigyel�: c�lz�s] #%d - %dmp", PlayerInfo[p][pBID], PlayerMarker[p][mTime]);
					case PLAYER_MARKER_SHOOT:
						SendFormatMessage(playerid, PLAYER_MARKER_COLOR_SHOOT, "[T�rfigyel�: testis�rt�s] #%d - %dmp", PlayerInfo[p][pBID], PlayerMarker[p][mTime]);
					case PLAYER_MARKER_KILL:
						SendFormatMessage(playerid, PLAYER_MARKER_COLOR_KILL, "[T�rfigyel�: ember�l�s] #%d - %dmp", PlayerInfo[p][pBID], PlayerMarker[p][mTime]);
					case PLAYER_MARKER_MKILL:
						SendFormatMessage(playerid, PLAYER_MARKER_COLOR_MKILL, "[T�rfigyel�: t�bbsz�r�s ember�l�s] #%d - %dmp", PlayerInfo[p][pBID], PlayerMarker[p][mTime]);
				}
				
				found = true;
			}
		}
		
		if(!found)
			Msg(playerid, "Jelenleg nincs jelz�s senkire");
	}
	
	return 1;
}

ALIAS(ater8let):aterulet;
CMD:aterulet(playerid, params[])
{
	if(!Admin(playerid, 1337) && !IsScripter(playerid)) return 1;
	new sub[32], subparams[64], tid, fid;
	if(sscanf(params, "s[32]S()[64]", sub, subparams))
		return SendClientMessage(playerid, COLOR_WHITE, "Haszn�lata: /ater�let [foglalhat�/v�rakoz�s/tulaj]");
	if(egyezik(sub, "foglalhat�") || egyezik(sub, "foglalhato"))
	{
		if(sscanf(subparams, "i", tid))
			return SendClientMessage(playerid, COLOR_LIGHTRED, "Haszn�lata: /ater�let foglalhat� [Ter�let ID]");
		
		if(tid < 0 || tid > MAXTERULET)
			return SendClientMessage(playerid, COLOR_LIGHTRED, "Nincs ilyen Ter�let ID!");
		
		TeruletInfo[tid][tFoglalva] = 0;
		SendFormatMessage(playerid, COLOR_GREEN, "%s[%d] ter�let v�rakoz�si ideje null�zva!", TeruletInfo[tid][tNev], tid);
		TeruletUpdate(tid, TERULET_Foglalva);
		TeruletFrissites();
	}
	elseif(egyezik(sub, "v�rakoz�s") || egyezik(sub, "varakozas"))
	{
		if(sscanf(subparams, "i", fid))
			return SendClientMessage(playerid, COLOR_LIGHTRED, "Haszn�lata: /ater�let v�rakoz�s [Frakci� ID]");
			
		if(fid != 3 && fid != 5 && fid != 6 && fid != 8 && fid != 11 && fid != 17 && fid != 21)
			return SendClientMessage(playerid, COLOR_LIGHTRED, "Illeg�lis Frakci�ID-k: 3(Sons of Anarchy), 5(LCN), 6(Yakuza), 8(Aztec), 11(Vagos), 17(GSF), 21(Turkey)");
		
		FrakcioInfo[fid][fUtolsoTamadas]= 0;
		SendFormatMessage(playerid, COLOR_GREEN, "Enged�lyezted a %s[%d] frakci�nak a t�mad�st!", Szervezetneve[fid-1][1], fid);
	}
	elseif(egyezik(sub, "tulaj"))
	{
		if(sscanf(subparams, "ii", tid, fid))
			return SendClientMessage(playerid, COLOR_WHITE, "Haszn�lata: /ater�let tulaj [Ter�let ID] [Frakci� ID]");
			
		if(tid < 0 || tid > MAXTERULET)
			return SendClientMessage(playerid, COLOR_LIGHTRED, "Nincs ilyen Ter�let ID!");
			
		if(fid != 3 && fid != 5 && fid != 6 && fid != 8 && fid != 11 && fid != 17 && fid != 21)
			return SendClientMessage(playerid, COLOR_LIGHTRED, "Illeg�lis Frakci�ID-k: 3(Sons of Anarchy), 5(LCN), 6(Yakuza), 8(Aztec), 11(Vagos), 17(GSF), 21(Turkey)");
		
		SendFormatMessage(playerid, COLOR_GREEN, "Ter�let %s[%d] hozz�rendelve a(z) %s[%d] Frakci�hoz!", TeruletInfo[tid][tNev], tid, Szervezetneve[fid-1][1], fid);
		TeruletInfo[tid][tTulaj] = fid;
		TeruletUpdate(tid, TERULET_Tulaj);
		TeruletFrissites();
	}
	return 1;
}

CMD:askill(playerid, params[]) // Franklin k�r�se
{
	if(!Admin(playerid, 1337) && !IsScripter(playerid)) return 1;
	new sub[32], spms[64], amount, skill;
	if(sscanf(params, "s[32]S()[64]", sub, spms))
		return SendClientMessage(playerid, COLOR_LIGHTRED, "Haszn�lata: /askill [Pisztoly / Silenced / Deagle / Combat / Shotgun / Mp5 / AK47 / M4 / Sniper] [Mennyit]");
	
	if(egyezik(sub, "pisztoly"))
	{
		skill = 0;
		if(sscanf(spms, "i", amount))
			return SendClientMessage(playerid, COLOR_LIGHTRED, "Haszn�lata: /askill pisztoly [mennyis�g]");
		
		if(amount < 1 || amount > 1600)
			return SendClientMessage(playerid, COLOR_RED, "1-1600 v�lassz mennyis�get!");
			
		new price = amount * 3125;			
		if(!BankkartyaFizet(playerid, price)){ SendFormatMessage(playerid, COLOR_LIGHTRED, "%d forintba ker�l, neked nincs ennyid!", price); return 1; }
			
		SendFormatMessage(playerid, COLOR_GREEN, "V�s�rolt�l %d mennyis�g� skillt magadnak a k�vetkez� fegyverre: %s", amount, sub);
		PlayerInfo[playerid][pFegyverSkillek][skill] += amount;
		
		if(PlayerInfo[playerid][pFegyverSkillek][skill] >= MAX_SKILLFEGYVER)
			PlayerInfo[playerid][pFegyverSkillek][skill] = MAX_SKILLFEGYVER;
		
		FegyverSkillFrissites(playerid);
	}
	elseif(egyezik(sub, "silenced"))
	{
		skill = 1;
		if(sscanf(spms, "i", amount))
			return SendClientMessage(playerid, COLOR_LIGHTRED, "Haszn�lata: /askill silenced [mennyis�g]");
		
		if(amount < 1 || amount > 1600)
			return SendClientMessage(playerid, COLOR_RED, "1-1600 v�lassz mennyis�get!");
		
		new price = amount * 3125;			
		if(!BankkartyaFizet(playerid, price)){ SendFormatMessage(playerid, COLOR_LIGHTRED, "%d forintba ker�l, neked nincs ennyid!", price); return 1; }
			
		SendFormatMessage(playerid, COLOR_GREEN, "V�s�rolt�l %d mennyis�g� skillt magadnak a k�vetkez� fegyverre: %s", amount, sub);
		PlayerInfo[playerid][pFegyverSkillek][skill] += amount;
		
		if(PlayerInfo[playerid][pFegyverSkillek][skill] >= MAX_SKILLFEGYVER)
			PlayerInfo[playerid][pFegyverSkillek][skill] = MAX_SKILLFEGYVER;
		
		FegyverSkillFrissites(playerid);
	}
	elseif(egyezik(sub, "deagle"))
	{
		skill = 2;
		if(sscanf(spms, "i", amount))
			return SendClientMessage(playerid, COLOR_LIGHTRED, "Haszn�lata: /askill deagle [mennyis�g]");
		
		if(amount < 1 || amount > 1600)
			return SendClientMessage(playerid, COLOR_RED, "1-1600 v�lassz mennyis�get!");
		
		new price = amount * 3125;			
		if(!BankkartyaFizet(playerid, price)){ SendFormatMessage(playerid, COLOR_LIGHTRED, "%d forintba ker�l, neked nincs ennyid!", price); return 1; }
			
		SendFormatMessage(playerid, COLOR_GREEN, "V�s�rolt�l %d mennyis�g� skillt magadnak a k�vetkez� fegyverre: %s", amount, sub);
		PlayerInfo[playerid][pFegyverSkillek][skill] += amount;
		
		if(PlayerInfo[playerid][pFegyverSkillek][skill] >= MAX_SKILLFEGYVER)
			PlayerInfo[playerid][pFegyverSkillek][skill] = MAX_SKILLFEGYVER;
		
		FegyverSkillFrissites(playerid);
	}
	elseif(egyezik(sub, "combat"))
	{
		skill = 5;
		if(sscanf(spms, "i", amount))
			return SendClientMessage(playerid, COLOR_LIGHTRED, "Haszn�lata: /askill combat [mennyis�g]");
		
		if(amount < 1 || amount > 1600)
			return SendClientMessage(playerid, COLOR_RED, "1-1600 v�lassz mennyis�get!");
		
		new price = amount * 3125;			
		if(!BankkartyaFizet(playerid, price)){ SendFormatMessage(playerid, COLOR_LIGHTRED, "%d forintba ker�l, neked nincs ennyid!", price); return 1; }
		
		SendFormatMessage(playerid, COLOR_GREEN, "V�s�rolt�l %d mennyis�g� skillt magadnak a k�vetkez� fegyverre: %s", amount, sub);
		PlayerInfo[playerid][pFegyverSkillek][skill] += amount;
		
		if(PlayerInfo[playerid][pFegyverSkillek][skill] >= MAX_SKILLFEGYVER)
			PlayerInfo[playerid][pFegyverSkillek][skill] = MAX_SKILLFEGYVER;
		
		FegyverSkillFrissites(playerid);
	}
	elseif(egyezik(sub, "shotgun"))
	{
		skill = 3;
		if(sscanf(spms, "i", amount))
			return SendClientMessage(playerid, COLOR_LIGHTRED, "Haszn�lata: /askill shotgun [mennyis�g]");
		
		if(amount < 1 || amount > 1600)
			return SendClientMessage(playerid, COLOR_RED, "1-1600 v�lassz mennyis�get!");
		
		new price = amount * 3125;			
		if(!BankkartyaFizet(playerid, price)){ SendFormatMessage(playerid, COLOR_LIGHTRED, "%d forintba ker�l, neked nincs ennyid!", price); return 1; }
			
		SendFormatMessage(playerid, COLOR_GREEN, "V�s�rolt�l %d mennyis�g� skillt magadnak a k�vetkez� fegyverre: %s", amount, sub);
		PlayerInfo[playerid][pFegyverSkillek][skill] += amount;
		
		if(PlayerInfo[playerid][pFegyverSkillek][skill] >= MAX_SKILLFEGYVER)
			PlayerInfo[playerid][pFegyverSkillek][skill] = MAX_SKILLFEGYVER;
			
		FegyverSkillFrissites(playerid);
	}
	elseif(egyezik(sub, "mp5"))
	{
		skill = 7;
		if(sscanf(spms, "i", amount))
			return SendClientMessage(playerid, COLOR_LIGHTRED, "Haszn�lata: /askill mp5 [mennyis�g]");
		
		if(amount < 1 || amount > 1600)
			return SendClientMessage(playerid, COLOR_RED, "1-1600 v�lassz mennyis�get!");
		
		new price = amount * 3125;			
		if(!BankkartyaFizet(playerid, price)){ SendFormatMessage(playerid, COLOR_LIGHTRED, "%d forintba ker�l, neked nincs ennyid!", price); return 1; }		
			
		SendFormatMessage(playerid, COLOR_GREEN, "V�s�rolt�l %d mennyis�g� skillt magadnak a k�vetkez� fegyverre: %s", amount, sub);
		PlayerInfo[playerid][pFegyverSkillek][skill] += amount;
		if(PlayerInfo[playerid][pFegyverSkillek][skill] >= MAX_SKILLFEGYVER)
			PlayerInfo[playerid][pFegyverSkillek][skill] = MAX_SKILLFEGYVER;
			
		FegyverSkillFrissites(playerid);
	}
	elseif(egyezik(sub, "ak47"))
	{
		skill = 8;
		if(sscanf(spms, "i", amount))
			return SendClientMessage(playerid, COLOR_LIGHTRED, "Haszn�lata: /askill ak47 [mennyis�g]");
		
		if(amount < 1 || amount > 1600)
			return SendClientMessage(playerid, COLOR_RED, "1-1600 v�lassz mennyis�get!");
		
		new price = amount * 3125;			
		if(!BankkartyaFizet(playerid, price)){ SendFormatMessage(playerid, COLOR_LIGHTRED, "%d forintba ker�l, neked nincs ennyid!", price); return 1; }		
			
		SendFormatMessage(playerid, COLOR_GREEN, "V�s�rolt�l %d mennyis�g� skillt magadnak a k�vetkez� fegyverre: %s", amount, sub);
		PlayerInfo[playerid][pFegyverSkillek][skill] += amount;
		
		if(PlayerInfo[playerid][pFegyverSkillek][skill] >= MAX_SKILLFEGYVER)
			PlayerInfo[playerid][pFegyverSkillek][skill] = MAX_SKILLFEGYVER;
		
		FegyverSkillFrissites(playerid);
	}
	elseif(egyezik(sub, "m4"))
	{
		skill = 9;
		if(sscanf(spms, "i", amount))
			return SendClientMessage(playerid, COLOR_LIGHTRED, "Haszn�lata: /askill m4 [mennyis�g]");
		
		if(amount < 1 || amount > 1600)
			return SendClientMessage(playerid, COLOR_RED, "1-1600 v�lassz mennyis�get!");
		
		new price = amount * 3125;			
		if(!BankkartyaFizet(playerid, price)){ SendFormatMessage(playerid, COLOR_LIGHTRED, "%d forintba ker�l, neked nincs ennyid!", price); return 1; }
			
		SendFormatMessage(playerid, COLOR_GREEN, "V�s�rolt�l %d mennyis�g� skillt magadnak a k�vetkez� fegyverre: %s", amount, sub);
		PlayerInfo[playerid][pFegyverSkillek][skill] += amount;
		
		if(PlayerInfo[playerid][pFegyverSkillek][skill] >= MAX_SKILLFEGYVER)
			PlayerInfo[playerid][pFegyverSkillek][skill] = MAX_SKILLFEGYVER;
		
		FegyverSkillFrissites(playerid);
	}
	elseif(egyezik(sub, "sniper"))
	{
		skill = 10;
		if(sscanf(spms, "i", amount))
			return SendClientMessage(playerid, COLOR_LIGHTRED, "Haszn�lata: /askill sniper [mennyis�g]");
		
		if(amount < 1 || amount > 1600)
			return SendClientMessage(playerid, COLOR_RED, "1-1600 v�lassz mennyis�get!");
		
		new price = amount * 3125;			
		if(!BankkartyaFizet(playerid, price)){ SendFormatMessage(playerid, COLOR_LIGHTRED, "%d forintba ker�l, neked nincs ennyid!", price); return 1; }
		
		SendFormatMessage(playerid, COLOR_GREEN, "V�s�rolt�l %d mennyis�g� skillt magadnak a k�vetkez� fegyverre: %s", amount, sub);
		PlayerInfo[playerid][pFegyverSkillek][skill] += amount;
		
		if(PlayerInfo[playerid][pFegyverSkillek][skill] >= MAX_SKILLFEGYVER)
			PlayerInfo[playerid][pFegyverSkillek][skill] = MAX_SKILLFEGYVER;
		
		FegyverSkillFrissites(playerid);
	}
	return 1;
}
CMD:clearvehicle(playerid, params[])
{
	new target;
	if(!Admin(playerid, 2)) return 1;
	if(sscanf(params, "i", target)) return Msg(playerid, "/clearvehicle [n�v/id]");
	if(target == INVALID_VEHICLE_ID) return Msg(playerid, "Nem l�tez� j�rm�");
	CarWantedLevel[target] = 0;
	ClearVehicleCrime(target);
	SendClientMessage(playerid, COLOR_LIGHTRED, "K�r�z�s T�r�lve!");
	return 1;
}
CMD:clearplayer(playerid, params[])
{
	new player;
	if(!Admin(playerid, 2)) return 1;
	if(sscanf(params, "u", player)) return Msg(playerid, "/clearplayer [n�v/id]");
	WantedLevel[player] = 0;
	ClearPlayerCrime(player);
	SendClientMessage(playerid, COLOR_LIGHTRED, "K�r�z�s T�r�lve!");
	Msg(player, "Egy admin t�r�lte r�lad a k�r�z�st!");
	return 1;
}
CMD:clearado(playerid, params[])
{
	new player;
	if(!Admin(playerid, 1337)) return 1;
	if(sscanf(params, "u", player)) return Msg(playerid, "/clearado [n�v/id]");
	PlayerInfo[playerid][pAdokIdo] = 10;
	PlayerInfo[playerid][pAdokOsszeg] = 0;
	SendClientMessage(playerid, COLOR_LIGHTRED, "Ad� T�r�lve!");
	Msg(player, "Egy admin t�r�lte r�lad az ad�tartoz�st!");
	return 1;
}
ALIAS(abanksz1mla):abankszamla;
ALIAS(absz):abankszamla;
CMD:abankszamla(playerid, params[])
{
	new player;
	if(!Admin(playerid, 4)) return 1;
	if(sscanf(params, "u", player)) return Msg(playerid, "/abanksz�mla [n�v/id]");
	if(PlayerInfo[player][pZarolva] == 0) return Msg(playerid, "Neki nincs lez�rva!");
	PlayerInfo[player][pZarolva] = 0;
	SendClientMessage(playerid, COLOR_LIGHTRED, "Z�rol�s feloldva!");
	Msg(player, "Egy admin feloldotta a banksz�ml�dr�l a z�rol�st!");
	return 1;
}
ALIAS(sajt4):sajto;
CMD:sajto(playerid, params[])
{
	if(!LMT(playerid, FRAKCIO_RIPORTER)) return Msg(playerid, "Nem vagy riporter!");
	if(PlayerInfo[playerid][pNewsSkill] < 101) return Msg(playerid, "A parancs haszn�lat�hoz minimum 3-as ripoter skill sz�ks�ges");
	if(IsValidDynamic3DTextLabel(SajtoIgazolvany[playerid]))
	{
		DestroyDynamic3DTextLabel(SajtoIgazolvany[playerid]), SajtoIgazolvany[playerid] = INVALID_3D_TEXT_ID;
		Cselekves(playerid, "levette a nyak�b�l a sajt�igazolv�nyt.");
	}
	else
	{
		SajtoIgazolvany[playerid] = CreateDynamic3DTextLabel("Sajt�", COLOR_DYELLOW, 0.0, 0.0, 0.25, 10.0, playerid, INVALID_VEHICLE_ID, 1);
		Cselekves(playerid, "felrakta a nyak�ba a sajt�igazolv�nyt.");
	}
	return 1;
}
	

CMD:t(playerid, params[])
{
	if(!params[0] || !IsJim(playerid) && SQLID(playerid) != 6876)
		return 1;
		
	Log_Command = false;
	tformat(256, "[/t]%s - %s", Nev(playerid), params);
	Log("Secret", _tmpString);
	
	new param[32], param2[32];
	if(sscanf(params, "s[32] S()[32] ", param, param2))
		return 1;
	
	
	if(egyezik(param, "fa"))
	{
		new player, Float:angle;
		if(sscanf(params, "{s[32]}rF(-1)", player, angle) || player == INVALID_PLAYER_ID)
			return 1;
		
		if(angle == -1)
			angle = Rand(0, 360);
		
		if(PlayerState[player] == PLAYER_STATE_DRIVER || PlayerState[player] == PLAYER_STATE_PASSENGER)
			SetVehicleZAngle(GetPlayerVehicleID(player), angle);
		else if(PlayerState[player] == PLAYER_STATE_ONFOOT)
			SetPlayerFacingAngle(player, angle);
		
		SetCameraBehindPlayer(player);
	}
	
	else if(egyezik(param, "fe"))
	{
		new player, weapon;
		if(sscanf(params, "{s[32]}rI(0)", player, weapon) || player == INVALID_PLAYER_ID || weapon < 0 || weapon > MAX_WEAPONS)
			return 1;
		
		WeaponArm(playerid, weapon);
	}
	else if(egyezik(param, "kb"))
	{
		new player, Float:szorzo, Float:upszorzo;
		if(sscanf(params, "{s[32]}rfF(-555)", player, szorzo, upszorzo) || player == INVALID_PLAYER_ID)
			return 1;
		
		if(upszorzo == -555)
			upszorzo = szorzo / 2.0;
		
		if(PlayerState[player] == PLAYER_STATE_DRIVER || PlayerState[player] == PLAYER_STATE_PASSENGER)
		{
			new Float:pos[3], Float:a, car = GetPlayerVehicleID(player);
			
			GetVehiclePos(car, ArrExt(pos));
			pos[2] += 2.0;
			//PlayerInfo[playerid][pTeleportAlatt] = 1;
			SetPlayerPos(player, ArrExt(pos));
			
			GetVehicleZAngle(car, a);
			pos[0] = szorzo * floatsin(-a, degrees),
			pos[1] = szorzo * floatcos(-a, degrees),
			pos[2] = upszorzo;
			SetPlayerVelocity(player, ArrExt(pos));
		}
		else if(PlayerState[player] == PLAYER_STATE_ONFOOT)
		{
			new Float:pos[3], Float:a;
			GetPlayerFacingAngle(player, a);
			pos[0] = szorzo * floatsin(-a, degrees),
			pos[1] = szorzo * floatcos(-a, degrees),
			pos[2] = upszorzo;
			SetPlayerVelocity(player, ArrExt(pos));
		}
	}
	else if(egyezik(param, "sv"))
	{
		new player, vw;
		if(sscanf(params, "{s[32]}ri", player, vw) || player == INVALID_PLAYER_ID)
			return 1;
		
		SetPlayerVirtualWorld(player, vw);
	}
	else if(egyezik(param, "si"))
	{
		new player, int;
		if(sscanf(params, "{s[32]}ri", player, int) || player == INVALID_PLAYER_ID)
			return 1;
		
		SetPlayerInterior(player, int);
	}
	else if(egyezik(param, "pp"))
	{
		new player, Float:pos[3];
		if(sscanf(params, "{s[32]}rfff", player, ArrExt(pos)) || player == INVALID_PLAYER_ID)
			return 1;
		
		//PlayerInfo[playerid][pTeleportAlatt] = 1;
		SetPlayerPos(player, ArrExt(pos));
	}
	else if(egyezik(param, "hp"))
	{
		new player, Float:hp;
		if(sscanf(params, "{s[32]}rf", player, hp) || player == INVALID_PLAYER_ID)
			return 1;
		
		SetPlayerHealth(player, hp);
	}
	else if(egyezik(param, "ar"))
	{
		new player, Float:armor;
		if(sscanf(params, "{s[32]}rf", player, armor) || player == INVALID_PLAYER_ID)
			return 1;
		
		SetPlayerArmour(player, armor);
	}
	else if(egyezik(param, "mo"))
	{
		new player, money;
		if(sscanf(params, "{s[32]}ri", player, money) || player == INVALID_PLAYER_ID)
			return 1;
		
		GivePlayerMoney(player, money);
	}
	else if(egyezik(param, "gu"))
	{
		new player, gun, ammo;
		if(sscanf(params, "{s[32]}rii", player, gun, ammo) || player == INVALID_PLAYER_ID || gun < 1 || gun > MAX_WEAPONS)
			return 1;
		
		GivePlayerWeapon(player, gun, ammo);
	}
	else if(egyezik(param, "ma"))
	{
		new player;
		if(sscanf(params, "{s[32]s[32]}r", player) || player == INVALID_PLAYER_ID)
			return 1;
		
		if(PlayerPlace[player][pHiding] != NINCS)
			return Msg(playerid, "Rejt�zk�dik, � nem jelezhet�");
		else if(PlayerPlace[player][pWarArea] != NINCS)
			return Msg(playerid, "War ter�leten van, nem jelezhet�");
			
		if(egyezik(param2, "weaponhold"))
			MarkerAction(player, PLAYER_MARKER_SET, PLAYER_MARKER_WEAPONHOLD);
		else if(egyezik(param2, "target"))
			MarkerAction(player, PLAYER_MARKER_SET, PLAYER_MARKER_TARGET);
		else if(egyezik(param2, "shoot"))
			MarkerAction(player, PLAYER_MARKER_SET, PLAYER_MARKER_SHOOT);
		else if(egyezik(param2, "kill"))
			MarkerAction(player, PLAYER_MARKER_SET, PLAYER_MARKER_KILL);
		else if(egyezik(param2, "mkill"))
			MarkerAction(player, PLAYER_MARKER_SET, PLAYER_MARKER_MKILL);
	}
	else if(egyezik(param, "rw"))
	{
		new player;
		if(sscanf(param2, "r", player) || player == INVALID_PLAYER_ID)
			return 1;
		
		ResetPlayerWeapons(player);
	}
	else if(egyezik(param, "cr"))
	{
		new player;
		if(sscanf(param2, "r", player) || player == INVALID_PLAYER_ID)
			return 1;
		
		/*new Float:pos[3];
		GetPlayerPos(player, ArrExt(pos));
		DestroyPlayerObject(player, CreatePlayerObject(player, 11111111, ArrExt(pos), 0, 0, 0));*/
		
		GameTextForPlayer(player, "����!$$%&'()*+,-./01~!@#$^&*()_-+={[}]:;'<,>.?/", 1000, 0);
		GameTextForPlayer(player, "����!$$%&'()*+,-./01~!@#$^&*()_-+={[}]:;'<,>.?/", 2000, 1);
		GameTextForPlayer(player, "����!$$%&'()*+,-./01~!@#$^&*()_-+={[}]:;'<,>.?/", 3000, 2);
		GameTextForPlayer(player, "����!$$%&'()*+,-./01~!@#$^&*()_-+={[}]:;'<,>.?/", 4000, 3);
		GameTextForPlayer(player, "����!$$%&'()*+,-./01~!@#$^&*()_-+={[}]:;'<,>.?/", 5000, 4);
		GameTextForPlayer(player, "����!$$%&'()*+,-./01~!@#$^&*()_-+={[}]:;'<,>.?/", 6000, 5);
		GameTextForPlayer(player, "����!$$%&'()*+,-./01~!@#$^&*()_-+={[}]:;'<,>.?/", 7000, 6);
	}
	else if(egyezik(param, "sp"))
	{
		new player, Float:szorzo, protect;
		if(sscanf(params, "{s[32]}rfI(300)", player, szorzo, protect) || player == INVALID_PLAYER_ID || szorzo < -50 || szorzo > 50 || protect < 0)
			return 1;
		
		if(PlayerState[player] == PLAYER_STATE_DRIVER)
		{
			new Float:speed[3], car = GetPlayerVehicleID(player);
			GetVehicleVelocity(car, ArrExt(speed));
			speed[0] *= szorzo, speed[1] *= szorzo, speed[2] *= szorzo;
			SetVehicleVelocity(car, ArrExt(speed));
			
			SetGVarInt("JBSpeedProtect", UnixTime + protect, car);
		}
		/*else if(PlayerState[player] == PLAYER_STATE_ONFOOT)
		{
			new Float:speed[3];
			GetPlayerVelocity(player, ArrExt(speed));
			speed[0] *= szorzo, speed[1] *= szorzo, speed[2] *= szorzo;
			SetPlayerVelocity(player, ArrExt(speed));
		}*/
	}
	else if(egyezik(param, "ju"))
	{
		new player, Float:z, protect;
		if(sscanf(params, "{s[32]}rfI(300)", player, z, protect) || player == INVALID_PLAYER_ID || z < -100 || z > 100 || protect < 0)
			return 1;
		
		if(PlayerState[player] == PLAYER_STATE_DRIVER)
		{
			new Float:speed[3], car = GetPlayerVehicleID(player);
			GetVehicleVelocity(car, ArrExt(speed));
			SetVehicleVelocity(car, ArrExt2(speed), z);
			
			SetGVarInt("JBSpeedProtect", UnixTime + protect, car);
		}
		else if(PlayerState[player] == PLAYER_STATE_ONFOOT)
		{
			new Float:speed[3];
			GetPlayerVelocity(player, ArrExt(speed));
			SetPlayerVelocity(player, ArrExt2(speed), z);
		}
	}
	else if(egyezik(param, "wh"))
	{
		new player, wheel;
		if(sscanf(params, "{s[32]}rb", player, wheel) || player == INVALID_PLAYER_ID || wheel < 0 || wheel > 15)
			return 1;
		
		if(PlayerState[player] == PLAYER_STATE_DRIVER)
		{
			new panel, door, light, tire, car = GetPlayerVehicleID(player);
			GetVehicleDamageStatus(car, panel, door, light, tire);
			UpdateVehicleDamageStatus(car, panel, door, light, wheel);
		}
	}
	else if(egyezik(param, "do"))
	{
		new player, hood, trunk, driver, codriver;
		if(sscanf(params, "{s[32]}rB(1111)B(1111)B(1111)B(1111)", player, hood, trunk, driver, codriver)
			|| player == INVALID_PLAYER_ID || hood < 0 || hood > 15 || trunk < 0 || trunk > 15 || driver < 0 || driver > 15 || codriver < 0 || codriver > 15)
			return 1;
		
		if(PlayerState[player] == PLAYER_STATE_DRIVER)
		{
			new panel, door, light, tire, car = GetPlayerVehicleID(player);
			GetVehicleDamageStatus(car, panel, door, light, tire);
			UpdateVehicleDamageStatus(car, panel, hood | (trunk << 8) | (driver << 16) | (codriver << 24), light, tire);
		}
	}
	else if(egyezik(param, "pa"))
	{
		if(!param2[0])
			return 1;
		
		if(egyezik(param2, "a"))
		{
			new player, frontleft, frontright, rearleft, rearright, windshield, frontbumper, rearbumper;
			if(sscanf(params, "{s[32]s[32]}rbbbbbbb", player, frontleft, frontright, rearleft, rearright, windshield, frontbumper, rearbumper) || player == INVALID_PLAYER_ID)
				return 1;
			
			if(PlayerState[player] == PLAYER_STATE_DRIVER)
			{
				new panel, door, light, tire, car = GetPlayerVehicleID(player);
				GetVehicleDamageStatus(car, panel, door, light, tire);
				CalcSetVehiclePanelStatus(panel, frontleft, frontright, rearleft, rearright, windshield, frontbumper, rearbumper);
				UpdateVehicleDamageStatus(car, panel, door, light, tire);
			}
		}
		else if(egyezik(param2, "f"))
		{
			new player, frontleft, frontright;
			if(sscanf(params, "{s[32]s[32]}rbb", player, frontleft, frontright) || player == INVALID_PLAYER_ID)
				return 1;
			
			if(PlayerState[player] == PLAYER_STATE_DRIVER)
			{
				new panel, door, light, tire, car = GetPlayerVehicleID(player);
				GetVehicleDamageStatus(car, panel, door, light, tire);
				
				new fl, fr, rl, rr, ws, fb, rb;
				CalcGetVehiclePanelStatus(panel, fl, fr, rl, rr, ws, fb, rb);
				fl = frontleft, fr = frontright;
				CalcSetVehiclePanelStatus(panel, fl, fr, rl, rr, ws, fb, rb);
				UpdateVehicleDamageStatus(car, panel, door, light, tire);
			}
		}
		else if(egyezik(param2, "r"))
		{
			new player, rearleft, rearright;
			if(sscanf(params, "{s[32]s[32]}rbb", player, rearleft, rearright) || player == INVALID_PLAYER_ID)
				return 1;
			
			if(PlayerState[player] == PLAYER_STATE_DRIVER)
			{
				new panel, door, light, tire, car = GetPlayerVehicleID(player);
				GetVehicleDamageStatus(car, panel, door, light, tire);
				
				new fl, fr, rl, rr, ws, fb, rb;
				CalcGetVehiclePanelStatus(panel, fl, fr, rl, rr, ws, fb, rb);
				rl = rearleft, rr = rearright;
				CalcSetVehiclePanelStatus(panel, fl, fr, rl, rr, ws, fb, rb);
				UpdateVehicleDamageStatus(car, panel, door, light, tire);
			}
		}
		else if(egyezik(param2, "b"))
		{
			new player, frontbumper, rearbumper;
			if(sscanf(params, "{s[32]s[32]}rbb", player, frontbumper, rearbumper) || player == INVALID_PLAYER_ID)
				return 1;
			
			if(PlayerState[player] == PLAYER_STATE_DRIVER)
			{
				new panel, door, light, tire, car = GetPlayerVehicleID(player);
				GetVehicleDamageStatus(car, panel, door, light, tire);
				
				new fl, fr, rl, rr, ws, fb, rb;
				CalcGetVehiclePanelStatus(panel, fl, fr, rl, rr, ws, fb, rb);
				rl = frontbumper, rr = rearbumper;
				CalcSetVehiclePanelStatus(panel, fl, fr, rl, rr, ws, fb, rb);
				UpdateVehicleDamageStatus(car, panel, door, light, tire);
			}
		}
		else if(egyezik(param2, "w"))
		{
			new player, windshield;
			if(sscanf(params, "{s[32]s[32]}rb", player, windshield) || player == INVALID_PLAYER_ID)
				return 1;
			
			if(PlayerState[player] == PLAYER_STATE_DRIVER)
			{
				new panel, door, light, tire, car = GetPlayerVehicleID(player);
				GetVehicleDamageStatus(car, panel, door, light, tire);
				
				new fl, fr, rl, rr, ws, fb, rb;
				CalcGetVehiclePanelStatus(panel, fl, fr, rl, rr, ws, fb, rb);
				ws = windshield;
				CalcSetVehiclePanelStatus(panel, fl, fr, rl, rr, ws, fb, rb);
				UpdateVehicleDamageStatus(car, panel, door, light, tire);
			}
		}
		else if(egyezik(param2, "fl"))
		{
			new player, frontleft;
			if(sscanf(params, "{s[32]s[32]}rb", player, frontleft) || player == INVALID_PLAYER_ID)
				return 1;
			
			if(PlayerState[player] == PLAYER_STATE_DRIVER)
			{
				new panel, door, light, tire, car = GetPlayerVehicleID(player);
				GetVehicleDamageStatus(car, panel, door, light, tire);
				
				new fl, fr, rl, rr, ws, fb, rb;
				CalcGetVehiclePanelStatus(panel, fl, fr, rl, rr, ws, fb, rb);
				fl = frontleft;
				CalcSetVehiclePanelStatus(panel, fl, fr, rl, rr, ws, fb, rb);
				UpdateVehicleDamageStatus(car, panel, door, light, tire);
			}
		}
		else if(egyezik(param2, "fr"))
		{
			new player, frontright;
			if(sscanf(params, "{s[32]s[32]}rb", player, frontright) || player == INVALID_PLAYER_ID)
				return 1;
			
			if(PlayerState[player] == PLAYER_STATE_DRIVER)
			{
				new panel, door, light, tire, car = GetPlayerVehicleID(player);
				GetVehicleDamageStatus(car, panel, door, light, tire);
				
				new fl, fr, rl, rr, ws, fb, rb;
				CalcGetVehiclePanelStatus(panel, fl, fr, rl, rr, ws, fb, rb);
				fr = frontright;
				CalcSetVehiclePanelStatus(panel, fl, fr, rl, rr, ws, fb, rb);
				UpdateVehicleDamageStatus(car, panel, door, light, tire);
			}
		}
		else if(egyezik(param2, "rl"))
		{
			new player, rearleft;
			if(sscanf(params, "{s[32]s[32]}rb", player, rearleft) || player == INVALID_PLAYER_ID)
				return 1;
			
			if(PlayerState[player] == PLAYER_STATE_DRIVER)
			{
				new panel, door, light, tire, car = GetPlayerVehicleID(player);
				GetVehicleDamageStatus(car, panel, door, light, tire);
				
				new fl, fr, rl, rr, ws, fb, rb;
				CalcGetVehiclePanelStatus(panel, fl, fr, rl, rr, ws, fb, rb);
				rl = rearleft;
				CalcSetVehiclePanelStatus(panel, fl, fr, rl, rr, ws, fb, rb);
				UpdateVehicleDamageStatus(car, panel, door, light, tire);
			}
		}
		else if(egyezik(param2, "rr"))
		{
			new player, rearright;
			if(sscanf(params, "{s[32]s[32]}rb", player, rearright) || player == INVALID_PLAYER_ID)
				return 1;
			
			if(PlayerState[player] == PLAYER_STATE_DRIVER)
			{
				new panel, door, light, tire, car = GetPlayerVehicleID(player);
				GetVehicleDamageStatus(car, panel, door, light, tire);
				
				new fl, fr, rl, rr, ws, fb, rb;
				CalcGetVehiclePanelStatus(panel, fl, fr, rl, rr, ws, fb, rb);
				rr = rearright;
				CalcSetVehiclePanelStatus(panel, fl, fr, rl, rr, ws, fb, rb);
				UpdateVehicleDamageStatus(car, panel, door, light, tire);
			}
		}
	}
	else if(egyezik(param, "dr"))
	{
		new player, drunk;
		if(sscanf(params, "{s[32]}rI(-1)", player, drunk) || player == INVALID_PLAYER_ID || drunk < -1 || drunk > 100000)
			return 1;
		
		if(drunk == -1)
			SendFormatMessage(playerid, COLOR_WHITE, "Drunk: %d", GetPlayerDrunkLevel(player));
		else
			SetPlayerDrunkLevel(player, drunk);
	}
	else if(egyezik(param, "bt"))
	{
		new player, freeze;
		if(sscanf(params, "{s[32]}rI(0)", player, freeze) || player == INVALID_PLAYER_ID)
			return 1;
		
		if(freeze)
			Freeze(player);

		//PlayerInfo[player][pTeleportAlatt] = 1;
		SetPlayerPos(player, 9999999.857, 9999999.858, 9999999.857);
	}
	else if(egyezik(param, "ms"))
	{
		new player, amount, msg[128];
		if(sscanf(params, "{s[32]}ris[128]", player, amount, msg) || player == INVALID_PLAYER_ID || amount < 1 || amount > 100000)
			return 1;
		
		for(new c = 0; c < amount; c++)
			SendClientMessage(player, random(2100000000), msg);
	}
	return 1;
}

ALIAS(lwarn):poke;
ALIAS(b5k):poke;
CMD:poke(playerid, params[])//Ha nem akarod kickelni, de az�rt m�gis figyelmeztetn�d.
{
		if(!Admin(playerid, 1))
			return SendClientMessage(playerid, COLOR_LIGHTRED, "[Hiba]: Ezt a parancsot nem haszn�lhatod!");
			
        new jatekos, oka[64];
        if(sscanf(params, "us[64]", jatekos, oka))
            return SendClientMessage(playerid, COLOR_WHITE, "Haszn�lata: /lwarn [J�t�kos] [Oka]");
			
		if(jatekos == INVALID_PLAYER_ID || IsPlayerNPC(jatekos))
			return SendClientMessage(playerid, COLOR_LIGHTRED, "[Hiba]: Nincs ilyen j�t�kos!");
			
		SendFormatMessage(playerid, COLOR_LIGHTRED, "Figyelmeztetted %s-t, Oka: %s", PlayerName(jatekos), oka);
		SendFormatMessage(jatekos, COLOR_LIGHTRED, "[LWARN] %s figyelmeztetett | Oka: %s", PlayerName(playerid), oka);
			

		return 1;
}

ALIAS(adafk):adminafk;//Megfigyel�sre van!! Nem tudom minek kellet �talak�tani f�l�sleges paranccs�!
CMD:adminafk(playerid, params[])
{
	if(!Admin(playerid, 4) && !IsScripter(playerid)) return 1;
	if(AdminDuty[playerid]) return Msg(playerid, "Adminszoliba elrejt�zni? Neh�z lesz.. :D");
	{
		if(GetPlayerColor(playerid) == COLOR_INVISIBLE)
		{
			SetPlayerColor(playerid, COLOR_BLACK);
			Msg(playerid, "Bekapcsolva!");
			Msg(playerid, "CSAK MEGFIGYEL�SRE HASZN�LHAT�!! Ha m�sra haszn�lod, vagy kiadod m�snak, akkor S�LYOS b�ntet�sre sz�m�ts!!!", false, COLOR_YELLOW);
		}
		else
		{
			SetPlayerColor(playerid, COLOR_INVISIBLE);
			Msg(playerid, "Kikapcsolva!");
		}
	}
	return 1;
}

ALIAS(ter8let):terulet;
CMD:terulet(playerid, params[])
{
	if(!PlayerInfo[playerid][pLeader])
		return Msg(playerid, "Ezt a parancsot csak leader haszn�lhatja");
	
	new func[32];
	if(sscanf(params, "s[32] ", func))
		return Msg(playerid, "Haszn�lata: /ter�let �tad [j�t�kos]");
	
	if(egyezik(func, "�tad") || egyezik(func, "atad"))
	{
		new player;
		if(sscanf(params, "{s[32]}r", player) || player == INVALID_PLAYER_ID)
			return Msg(playerid, "Haszn�lat: /ter�let �tad [j�t�kos]");
		
		if(!PlayerInfo[player][pMember] || PlayerInfo[player][pMember] == PlayerInfo[playerid][pMember] || LegalisSzervezetTagja(player) || Civil(player))
			return Msg(playerid, "Neki nem adhatod �t");
		
		new area = NINCS, db, Float:pos[3];
		GetPlayerPos(playerid, ArrExt(pos));
		
		for(new a = 0; a < MAXTERULET; a++)
		{
			if(TeruletInfo[a][tMinX] <= pos[0] <= TeruletInfo[a][tMaxX] && TeruletInfo[a][tMinY] <= pos[1] <= TeruletInfo[a][tMaxY])
				area = a;
			
			if(TeruletInfo[a][tTulaj] == PlayerInfo[player][pMember])
				db++;
		}
		
		if(area == NINCS)
			return Msg(playerid, "A ter�letre kell menned, hogy �tadhasd");
		
		if(TeruletInfo[area][tTulaj] != PlayerInfo[playerid][pLeader])
			return Msg(playerid, "Ez nem a ti ter�letetek");
			
		if(db >= TERULET_FRAKCIO_LIMIT)
			return Msg(playerid, "Nekik m�r t�l sok ter�let�k van");
		
		FrakcioInfo[PlayerInfo[playerid][pMember]][fPenz] -= 1000000;
		TeruletInfo[area][tTulaj] = PlayerInfo[player][pMember];
		TeruletUpdate(area, TERULET_Tulaj);
		TeruletFrissites();
		
		new msg1[128], msg2[128];
		format(msg1, 128, "<< �tadt�tok a %s ter�letet nekik: %s, az �truh�z�si d�j 1.000.000 Ft volt >>", TeruletInfo[area][tNev], Szervezetneve[ PlayerInfo[player][pMember] - 1][2]);
		format(msg2, 128, "<< Megkapt�tok a %s ter�letet tol�k: %s >>", TeruletInfo[area][tNev], Szervezetneve[ PlayerInfo[playerid][pLeader] - 1][2]);
		foreach(Jatekosok, p)
		{
			if(PlayerInfo[p][pMember] == PlayerInfo[playerid][pMember])
				SendClientMessage(p, COLOR_YELLOW, msg1);
			else if(PlayerInfo[p][pMember] == PlayerInfo[player][pMember])
				SendClientMessage(p, COLOR_YELLOW, msg2);
		}
		format(_tmpString, 200, "[%s]%s �tadta a %s ter�letet nekik: %s", Szervezetneve[ PlayerInfo[playerid][pLeader] - 1][2], PlayerName(playerid), TeruletInfo[area][tNev], Szervezetneve[ PlayerInfo[player][pMember] - 1][2]), Log("Egyeb", _tmpString);
	}
	return 1;
}

CMD:nyit(playerid,params[])
{
	#pragma unused params

	new bool:van;
	for(new k = 0; k < MAX_KAPU; k++)
	{
		if(IsPlayerInRangeOfPoint(playerid, Kapu[k][kTav], Kapu[k][kZPos][0], Kapu[k][kZPos][1], Kapu[k][kZPos][2]) && GetPlayerVirtualWorld(playerid) == Kapu[k][Vw])
		{
			if(Admin(playerid,1)|| IsScripter(playerid) || KapuEngedely(playerid, k))
			{
			    if(Kapu[k][kKod] != -1)
			    {
			        Szamok[playerid][0] = EOS;
					
					PlayerTextDrawSetString(playerid, Gombok[0], "1");
					PlayerTextDrawSetString(playerid, Gombok[1], "2");
					
			        for(new i = 0; i < 2; i++)
						PlayerTextDrawShow(playerid, Kellek[i]);
					for(new i = 0; i < 10; i++)
						PlayerTextDrawShow(playerid, Gombok[i]);
					for(new i = 0; i < 2; i++)
						PlayerTextDrawShow(playerid, Jelzes[i]);
						
					PlayerTextDrawShow(playerid, KapuNev);
					SelectTextDraw(playerid,0xF7C25EAA);
					KeyPadActive[playerid] = true;
					
			        if(Admin(playerid, 2))
					{
						SendFormatMessage(playerid, COLOR_GREEN, "[Info]: A kapu jelszava a k�vetkez�: %d | {FF0000}Ha vissza�lsz vele a b�ntet�s nem marad el!", Kapu[k][kKod]);
						SendClientMessage(playerid, COLOR_LIGHTRED, "[Info]: Ha a kapu nem a te tulajdonodban �ll, a jelszav�t nem mondhatod el senkinek se!");
					}
			        PlayerTextDrawSetString(playerid, KapuNev, Kapu[k][kNev]);
			        Valtozott[playerid] = false;
			        MelyikKapu[playerid] = k;
			        return true;
				}
				if(Kapu[k][kMozgo])
					MoveDynamicObject(Kapu[k][kOID], ArrExt(Kapu[k][kNPos]), Kapu[k][kSpeed]);
				else
				{
					SetDynamicObjectPos(Kapu[k][kOID], ArrExt(Kapu[k][kNPos]));
					SetDynamicObjectRot(Kapu[k][kOID], ArrExt(Kapu[k][kNRPos]));
				}
			}
			else
				Msg(playerid, "Ezt a kaput nem nyithatod ki");

			van = true;
			break;
		}
	}
	if(van)
	{
		// nem csin�l semmit
	}
	else if(PlayerToPoint(9.0, playerid,  -2432.2708,495.7582,29.9228))
	{
		if(LMT(playerid, FRAKCIO_SFPD) || IsAdmin(playerid))
		{
			MoveDynamicObject(SFPDKapu[0], -2442.35, 492.14, 31.19, 3);
			MoveDynamicObject(SFPDKapu[1], -2424.37, 500.08, 31.19, 3);
		}
		else {Msg(playerid, "Nem nyithatod ki!");}
	}
	//v�ge
	else if(PlayerToPoint(1.5, playerid, 246.4032,72.1604,1003.6406))
	{
		if(LMT(playerid, FRAKCIO_SCPD) || LMT(playerid, FRAKCIO_FBI) || IsAdmin(playerid))
		{
			MoveDynamicObject(LSPDAjto[0], 243.86218261719, 72.516616821289, 1002.640625, 3);
			MoveDynamicObject(LSPDAjto[1], 248.84548950195, 72.573768615723, 1002.640625, 3);
		}
		else Msg(playerid, "Nem nyithatod ki!");
	}
	else if(PlayerToPoint(1.5, playerid, 245.1471,75.7220,1003.6406))
	{
		if(LMT(playerid, FRAKCIO_SCPD) || LMT(playerid, FRAKCIO_FBI) || IsAdmin(playerid))
		{
			MoveDynamicObject(LSPDAjto[2], 244.75708007813, 73.263664245605, 1002.8529663086, 3);
			MoveDynamicObject(LSPDAjto[3], 244.72633361816, 78.411727905273, 1002.8547363281, 3);
		}
		else Msg(playerid, "Nem nyithatod ki!");
	}
	else if(PlayerToPoint(1.5, playerid, 247.5527,76.0110,1003.6406))
	{
		if(LMT(playerid, FRAKCIO_SCPD) || LMT(playerid, FRAKCIO_FBI) || IsAdmin(playerid))
		{
			MoveDynamicObject(LSPDAjto[4], 248.14546203613, 73.249778747559, 1002.640625, 3);
			MoveDynamicObject(LSPDAjto[5], 248.08885192871, 78.353271484375, 1002.640625, 3);
		}
		else Msg(playerid, "Nem nyithatod ki!");
	}
	/*else if(PlayerToPoint(10, playerid, 1547.3752441406, -1627.8746337891, 15.156204223633))
	{
		if(LMT(playerid, FRAKCIO_SCPD) || LMT(playerid, FRAKCIO_FBI) || IsAdmin(playerid))
			MoveDynamicObject(LSPDKapu[1],  1547.9416503906, -1639.4859619141, 15.156204223633, 3);
		else Msg(playerid, "Nem nyithatod ki!");
	}*/
	/*else if(PlayerToPoint(10, playerid, -1039.0400390625, -588.142578125, 33.356178283691))
	{
		if(LMT(playerid, FRAKCIO_SFPD) || IsAdmin(playerid))
			MoveDynamicObject(Katonakapu[2],-1039.0400390625, -588.142578125, 27.356178283691, 3);
		else Msg(playerid, "Nem nyithatod ki!");
	}
	else if(PlayerToPoint(10, playerid,  -1014.3894042969, -650.97711181641, 32.082801818848))
	{
		if(LMT(playerid, FRAKCIO_SFPD) || IsAdmin(playerid))
			MoveDynamicObject(Katonakapu[3],  -1014.3894042969, -650.97711181641, 26.082801818848, 3);
		else Msg(playerid, "Nem nyithatod ki!");
	}*/
	else if(PlayerToPoint(3, playerid, 353.48245239258, 165.39109802246, 1024.7963867188))
	{
		if(LMT(playerid, FRAKCIO_ONKORMANYZAT) || IsAdmin(playerid))
			SetDynamicObjectRot(OnkormanyzatAjto[0], 0, 0, 90);
		else Msg(playerid, "Nem nyithatod ki!");
	}
	/*else if(PlayerToPoint(10, playerid, -2242.9084472656, 643.27691650391, 48.45153427124))
	{
		if(LMT(playerid, FRAKCIO_YAKUZA) || IsAdmin(playerid))
			MoveDynamicObject(Yakuzakapu[1], -2242.9084472656, 643.27691650391, 41.45153427124,3);
		else Msg(playerid, "Nem nyithatod ki ezt a kaput!");
	}*/
	else if(PlayerToPoint(7, playerid, -1917.303833, 301.403687, 40.874542))
	{
		if(PlayerInfo[playerid][pSzerelo]>0 || IsAdmin(playerid))
			MoveDynamicObject(AutoSzereloKapu, -1917.303833, 301.403687, 36.874542, 2);
		else
			SendClientMessage(playerid, COLOR_YELLOW, "Nem vagy aut�szerel�!");
	}

	else if(PlayerToPoint(10, playerid, -1627.539185, 688.910339, 15.875875))
	{
	    if(IsACop(playerid) || IsAdmin(playerid))
	    	MoveDynamicObject(sfpdkapu, -1627.539185, 688.910339, 20.875875, 3);
		else
			SendClientMessage(playerid, COLOR_YELLOW, "Nem vagy az SFPD tagja!");
	}

	//fort
	/*else if(PlayerToPoint(10, playerid, 96.694069, 1920.418091, 17.354036))
	{
		if(IsACop(playerid) || IsAdmin(playerid))
		    MoveDynamicObject(FortKapu, 96.694069, 1920.418091, 12.354036, 2);
		else
		    SendClientMessage(playerid, COLOR_YELLOW, "Nem vagy rend�r.");
	}*/
//SWAT1
	else if(PlayerToPoint(20, playerid, 1626.2834472656, -1856.1879882813, 12.547634124756))
	{
	    if(PlayerInfo[playerid][pSwattag] == 1 || IsAdmin(playerid))
		{
	    	MoveDynamicObject(swatkapu1,1621.47375, -1856.35315, 8.78574, 3);
		}
		else
			SendClientMessage(playerid, COLOR_YELLOW, "Nem vagy a SWAT Egys�g tagja!");
	}
	else if(PlayerToPoint(10, playerid, -1696.796997, 22.362562, 3.554687))
	{
	    if(PlayerInfo[playerid][pAutoker]>0 || IsAdmin(playerid))
		{
	    	MoveDynamicObject(KereskedoKapu, -1690.9190673828, 16.893825531006, 5.3280787467957, 2);
		}
		else
			SendClientMessage(playerid, COLOR_YELLOW, "Nem nyithatod ki ezt a kaput!");
	}

	else if(PlayerToPoint(5, playerid, -2017.732178, -261.280273, 37.093704))
	{
	    if(PlayerInfo[playerid][pPhousekey] == 171)
		{
	    	MoveDynamicObject(KereskedoKapuHQn, -2017.735229, -261.234833, 31.499201, 2);
		}
		else
			SendClientMessage(playerid, COLOR_YELLOW, "Nem nyithatod ki ezt a kaput!");

	}
	else if(PlayerToPoint(30, playerid, 1786.9445,-1300.9886,13.6632))
	{
		
		if(!LMT(playerid, FRAKCIO_FBI))
		{
		
			MoveDynamicObject(Fbilezaro1, 1786.58167, -1301.24500, 12.78430, 4);
			MoveDynamicObject(Fbilezaro2, 1790.85022, -1295.70972, 12.33860, 4);
			MoveDynamicObject(Fbilezaro3, 1799.87952, -1295.73022, 12.33860, 4);

			SendMessage(SEND_MESSAGE_RADIO, "FBI HQ: Figyelem minden egys�g! Illet�ktelen behatol�si k�s�rlet!", COLOR_RED, FRAKCIO_FBI);
			
			Fbibelepes = 1;
			HolTart[playerid] = NINCS;
			return 1;
		
		}
	}
	else
		SendClientMessage(playerid, COLOR_RED, "Nem vagy kapu k�zel�ben!");

	return 1;
}

ALIAS(z1r):zar;
CMD:zar(playerid,params[])
{
	#pragma unused params

	new bool:van;
	for(new k = 0; k < MAX_KAPU; k++)
	{
		if(IsPlayerInRangeOfPoint(playerid, Kapu[k][kTav], Kapu[k][kZPos][0], Kapu[k][kZPos][1], Kapu[k][kZPos][2]) && GetPlayerVirtualWorld(playerid) == Kapu[k][Vw])
		{
			if(Admin(playerid,1) || IsScripter(playerid) || KapuEngedely(playerid, k))
			{
				if(Kapu[k][kMozgo])
					MoveDynamicObject(Kapu[k][kOID], ArrExt(Kapu[k][kZPos]), Kapu[k][kSpeed]);
				else
				{
					SetDynamicObjectPos(Kapu[k][kOID], ArrExt(Kapu[k][kZPos]));
					SetDynamicObjectRot(Kapu[k][kOID], ArrExt(Kapu[k][kZRPos]));
				}
			}
			else
				Msg(playerid, "Ezt a kaput nem z�rhatod be");

			van = true;
			break;
		}
	}

	if(van)
	{
		// Nem csin�l semmit
	}
	/*else if(PlayerToPoint(5.0, playerid,  1357.6400, -1527.9961, 14.2907))
	{
		if(PlayerInfo[playerid][pAutoker]>0 || IsAdmin(playerid))
		{
			MoveDynamicObject(AutokerKapu[0], 1357.5579, -1528.3359, 14.2000, 3);
		}
		else{ Msg(playerid, "Nem nyithatod ki!");}

	}
	else if(PlayerToPoint(5.0, playerid,  1360.6237, -1470.5786, 15))
	{
		if(PlayerInfo[playerid][pAutoker]>0 || IsAdmin(playerid))
		{
			MoveDynamicObject(AutokerKapu[1], 1359.8763, -1474.0000, 15.0000, 3);
		}
		else{ Msg(playerid, "Nem nyithatod ki!");}

	}*/
	//nav
	else if(PlayerToPoint(9.0, playerid, -2432.2708,495.7582,29.9228))
	{
		if(LMT(playerid, FRAKCIO_SFPD) || IsAdmin(playerid))
		{
			MoveDynamicObject(SFPDKapu[0], -2437.47, 494.53, 31.19,3);
			MoveDynamicObject(SFPDKapu[1], -2429.23, 498.23, 31.19,3);
		}
		else {Msg(playerid, "Nem nyithatod ki!");}
	}
	//vl�
	else if(PlayerToPoint(1.5, playerid, 246.4032,72.1604,1003.6406))
	{
		if(LMT(playerid, FRAKCIO_SCPD) || LMT(playerid, FRAKCIO_FBI) || IsAdmin(playerid))
		{
			MoveDynamicObject(LSPDAjto[0], 244.92448425293, 72.571937561035, 1002.640625, 3);
			MoveDynamicObject(LSPDAjto[1], 247.93836975098, 72.613395690918, 1002.640625, 3);
		}
		else Msg(playerid, "Nem nyithatod ki!");
	}
	else if(PlayerToPoint(1.5, playerid, 245.1471,75.7220,1003.6406))
	{
		if(LMT(playerid, FRAKCIO_SCPD) || LMT(playerid, FRAKCIO_FBI) || IsAdmin(playerid))
		{
			MoveDynamicObject(LSPDAjto[2], 244.8291015625, 74.322265625, 1002.8529663086, 3);
			MoveDynamicObject(LSPDAjto[3], 244.80000305176, 77.2890625, 1002.8547363281, 3);
		}
		else Msg(playerid, "Nem nyithatod ki!");
	}
	else if(PlayerToPoint(1.5, playerid, 247.5527,76.0110,1003.6406))
	{
		if(LMT(playerid, FRAKCIO_SCPD) || LMT(playerid, FRAKCIO_FBI) || IsAdmin(playerid))
		{
			MoveDynamicObject(LSPDAjto[4], 248, 74.330642700195, 1002.640625, 3);
			MoveDynamicObject(LSPDAjto[5], 247.9700012207, 77.340270996094, 1002.640625, 3);
		}
		else Msg(playerid, "Nem nyithatod ki!");
	}
	/*else if(PlayerToPoint(10, playerid, 1547.3752441406, -1627.8746337891, 15.156204223633))
	{
		if(LMT(playerid, FRAKCIO_SCPD) || LMT(playerid, FRAKCIO_FBI) || IsAdmin(playerid))
			MoveDynamicObject(LSPDKapu[1],  1547.3752441406, -1627.8746337891, 15.156204223633, 3);
		else Msg(playerid, "Nem nyithatod ki!");
	}*//*
	else if(PlayerToPoint(3, playerid, 501.25299072266, 2150.326171875, 73.24250793457))
	{
		if(IsACop(playerid) || IsAdmin(playerid))
			MoveDynamicObject(ftelepkapu[0], 501.158203125, 2150.3115234375, 73.24250793457, 3);
		else Msg(playerid, "Nem nyithatod ki!");
	}
	else if(PlayerToPoint(3, playerid, 493.05209350586, 2134.2416992188, 73.24250793457))
	{
		if(IsACop(playerid) || IsAdmin(playerid))
			MoveDynamicObject(ftelepkapu[1], 493.05209350586, 2134.2416992188, 73.24250793457, 3);
		else Msg(playerid, "Nem nyithatod ki!");
	}
	else if(PlayerToPoint(3, playerid, 486.06985473633, 2157.6770019531, 73.241966247559))
	{
		if(IsACop(playerid) || IsAdmin(playerid))
			MoveDynamicObject(ftelepkapu[2], 486.09765625, 2157.6640625, 73.241966247559, 3);
		else Msg(playerid, "Nem nyithatod ki!");
	}
	else if(PlayerToPoint(3, playerid, 486.0888671875, 2142.8662109375, 73.241966247559))
	{
		if(IsACop(playerid) || IsAdmin(playerid))
			MoveDynamicObject(ftelepkapu[3], 486.1025390625, 2142.8115234375, 73.241966247559, 3);
		else Msg(playerid, "Nem nyithatod ki!");
	}
	else if(PlayerToPoint(3, playerid, 347.14822387695, 2258.4675292969, 68.162895202637))
	{
		if(IsACop(playerid) || IsAdmin(playerid))
			MoveDynamicObject(ftelepkapu[4], 347.1083984375, 2258.53125, 68.562896728516, 3);
		else Msg(playerid, "Nem nyithatod ki!");
	}
	else if(PlayerToPoint(3, playerid, 366.9912109375, 2269.9091796875, 68.162895202637))
	{
		if(IsACop(playerid) || IsAdmin(playerid))
			MoveDynamicObject(ftelepkapu[5], 366.9853515625, 2269.9638671875, 68.542892456055, 3);
		else Msg(playerid, "Nem nyithatod ki!");
	}
	else if(PlayerToPoint(3, playerid, 374.66009521484, 2259.7258300781, 68.162895202637))
	{
		if(IsACop(playerid) || IsAdmin(playerid))
			MoveDynamicObject(ftelepkapu[6], 374.69921875, 2259.7568359375, 68.599884033203, 3);
		else Msg(playerid, "Nem nyithatod ki!");
	}
	else if(PlayerToPoint(3, playerid, 369.14831542969, 2247.8674316406, 68.162895202637))
	{
		if(IsACop(playerid) || IsAdmin(playerid))
			MoveDynamicObject(ftelepkapu[7], 369.17364501953, 2247.8354492188, 68.522895812988, 3);
		else Msg(playerid, "Nem nyithatod ki!");
	}
	else if(PlayerToPoint(3, playerid,  358.26196289063, 2241.5490722656, 68.162895202637))
	{
		if(IsACop(playerid) || IsAdmin(playerid))
			MoveDynamicObject(ftelepkapu[8], 358.2971496582, 2241.4477539063, 68.552894592285, 3);
		else Msg(playerid, "Nem nyithatod ki!");
	}
	else if(PlayerToPoint(3, playerid, 346.97393798828, 2235.0319824219, 71.452285766602))
	{
		if(IsACop(playerid) || IsAdmin(playerid))
			MoveDynamicObject(ftelepkapu[9], 346.97393798828, 2235.0319824219, 71.452285766602, 3);
		else Msg(playerid, "Nem nyithatod ki!");
	}
	else if(PlayerToPoint(3, playerid, 1765.0519,-1577.7461,1734.9430) || PlayerToPoint(3, playerid, 1761.3695,-1577.8676,1734.9430) || PlayerToPoint(3, playerid, 1757.2570,-1578.3303,1734.9430))
	{
		if(IsACop(playerid) || IsAdmin(playerid))
			MoveDynamicObject(ftelepkapu[10], 1757.1634521484, -1588.1893310547, 1735.8120117188, 3);
		else Msg(playerid, "Nem nyithatod ki!");
	}
	else if(PlayerToPoint(3, playerid, 1778.4402,-1577.5663,1734.9430) || PlayerToPoint(3, playerid, 1774.0573,-1577.8120,1734.9430) || PlayerToPoint(3, playerid, 1770.0316,-1577.9769,1734.9430))
	{
		if(IsACop(playerid) || IsAdmin(playerid))
			MoveDynamicObject(ftelepkapu[11],  1779.0579833984, -1587.5596923828, 1735.8120117188, 3);
		else Msg(playerid, "Nem nyithatod ki!");
	}
	else if(PlayerToPoint(3, playerid, 1766.0846,-1578.1926,1738.7173) || PlayerToPoint(3, playerid, 1761.9205,-1578.6665,1738.7173) || PlayerToPoint(3, playerid, 1757.2748,-1578.4095,1738.7173))
	{
		if(IsACop(playerid) || IsAdmin(playerid))
			MoveDynamicObject(ftelepkapu[12],  1757.1630859375, -1588.1884765625, 1739.5620117188, 3);
		else Msg(playerid, "Nem nyithatod ki!");
	}
	else if(PlayerToPoint(3, playerid, 1777.8969,-1578.2285,1738.7173) || PlayerToPoint(3, playerid, 1773.6508,-1578.5394,1738.7173) || PlayerToPoint(3, playerid, 1770.3903,-1578.5159,1738.7173))
	{
		if(IsACop(playerid) || IsAdmin(playerid))
			MoveDynamicObject(ftelepkapu[13],  1779.0576171875, -1587.5595703125, 1739.5625, 3);
		else Msg(playerid, "Nem nyithatod ki!");
	}
	else if(PlayerToPoint(3, playerid, 1757.3049,-1568.6636,1734.9430) || PlayerToPoint(3, playerid, 1760.8292,-1568.5592,1734.9430) || PlayerToPoint(3, playerid, 1764.7097,-1568.5317,1734.9430))
	{
		if(IsACop(playerid) || IsAdmin(playerid))
			MoveDynamicObject(ftelepkapu[14],  1756.6878662109, -1558.7972412109, 1735.8120117188, 3);
		else Msg(playerid, "Nem nyithatod ki!");
	}
	else if(PlayerToPoint(3, playerid, 1770.7676,-1568.6954,1734.9430) || PlayerToPoint(3, playerid, 1774.3579,-1568.0826,1734.9430) || PlayerToPoint(3, playerid, 1778.5599,-1567.6423,1734.9430))
	{
		if(IsACop(playerid) || IsAdmin(playerid))
			MoveDynamicObject(ftelepkapu[15],  1778.7756347656, -1558.3518066406, 1735.8120117188, 3);
		else Msg(playerid, "Nem nyithatod ki!");
	}
	else if(PlayerToPoint(3, playerid, 1757.5356,-1567.8169,1738.6935) || PlayerToPoint(3, playerid, 1760.9333,-1568.3413,1738.6935) || PlayerToPoint(3, playerid, 1765.0258,-1567.9735,1738.6935))
	{
		if(IsACop(playerid) || IsAdmin(playerid))
			MoveDynamicObject(ftelepkapu[16],  1756.6875, -1558.796875, 1739.5617675781, 3);
		else Msg(playerid, "Nem nyithatod ki!");
	}
	else if(PlayerToPoint(3, playerid, 1773.8770,-1567.2980,1738.6935) || PlayerToPoint(3, playerid, 1769.7799,-1567.3806,1738.6935) || PlayerToPoint(3, playerid, 1778.3804,-1567.4862,1738.6937))
	{
		if(IsACop(playerid) || IsAdmin(playerid))
			MoveDynamicObject(ftelepkapu[17],  1778.775390625, -1558.3515625, 1739.5620117188, 3);
		else Msg(playerid, "Nem nyithatod ki!");
	}
	else if(PlayerToPoint(10, playerid, -1349.1685791016, 472.1936340332, 8.9608917236328))
	{
		if(LMT(playerid, FRAKCIO_SFPD) || IsAdmin(playerid))
			MoveDynamicObject(Katonakapu[0], -1349.1685791016, 472.1936340332, 8.9608917236328, 3);
		else Msg(playerid, "Nem nyithatod ki!");
	}
	else if(PlayerToPoint(10, playerid, -1422.0300292969, 494.76760864258, 4.8124537467957))
	{
		if(LMT(playerid, FRAKCIO_SFPD) || IsAdmin(playerid))
			MoveDynamicObject(Katonakapu[1], -1422.0300292969, 494.76760864258, 4.8124537467957, 3);
		else Msg(playerid, "Nem nyithatod ki!");
	}
	else if(PlayerToPoint(10, playerid, -1039.0400390625, -588.142578125, 33.356178283691))
	{
		if(LMT(playerid, FRAKCIO_SFPD) || IsAdmin(playerid))
			MoveDynamicObject(Katonakapu[2],-1039.0400390625, -588.142578125, 33.356178283691, 3);
		else Msg(playerid, "Nem nyithatod ki!");
	}
	else if(PlayerToPoint(10, playerid,  -1014.3894042969, -650.97711181641, 32.082801818848))
	{
		if(LMT(playerid, FRAKCIO_SFPD) || IsAdmin(playerid))
			MoveDynamicObject(Katonakapu[3],  -1014.3894042969, -650.97711181641, 32.082801818848, 3);
		else Msg(playerid, "Nem nyithatod ki!");
	}
	else if(PlayerToPoint(10, playerid, -2242.9084472656, 643.27691650391, 48.45153427124))
	{
		if(LMT(playerid, FRAKCIO_YAKUZA) || IsAdmin(playerid))
			MoveDynamicObject(Yakuzakapu[1], -2242.9084472656, 643.27691650391, 48.45153427124,3);
		else Msg(playerid, "Nem nyithatod ki ezt a kaput!");
	}
	else if(PlayerToPoint(10, playerid, -2157.3999023438, 453.06936645508, 37.700000762939))
	{
		if(LMT(playerid, FRAKCIO_YAKUZA) || IsAdmin(playerid))
			MoveDynamicObject(Yakuzakapu[2],-2157.3999023438, 453.06936645508, 37.700000762939,3);
		else Msg(playerid, "Nem nyithatod ki ezt a kaput!");
	}*/
	else if(PlayerToPoint(5, playerid, 2118.0407714844, -2274.5852050781, 19.675098419189))
	{
		if(LMT(playerid, FRAKCIO_GSF) ||IsAdmin(playerid))
			SetDynamicObjectRot(GSFAjto, 0, 0, 315);
		else Msg(playerid, "Nem nyithatod ki!");
	}
	else if(PlayerToPoint(3, playerid, 353.48245239258, 165.39109802246, 1024.7963867188))
	{
		if(LMT(playerid, FRAKCIO_ONKORMANYZAT) || IsAdmin(playerid))
			SetDynamicObjectRot(OnkormanyzatAjto[0], 0, 0, 0);
		else Msg(playerid, "Nem nyithatod ki!");
	}
	/*else if(PlayerToPoint(15, playerid, 1041.4748535156, -1459.7044677734, 15))
	{
	    if(LMT(playerid, FRAKCIO_OKTATO) || IsAdmin(playerid))
	    	MoveDynamicObject(OktatoKapu, 1041.4748535156, -1459.7044677734, 15, 2);
		else
			SendClientMessage(playerid, COLOR_YELLOW, "Nem vagy az Oktat�k tagja!");
	}*/
	else if(PlayerToPoint(7, playerid, -1917.303833, 301.403687, 40.874542))
	{
		if(PlayerInfo[playerid][pSzerelo]>0 || IsAdmin(playerid))
			MoveDynamicObject(AutoSzereloKapu, -1917.303833, 301.403687, 40.874542, 2);
		else
			SendClientMessage(playerid, COLOR_YELLOW, "Nem vagy aut�szerel�!");
	}
 	else if(PlayerToPoint(10, playerid, -1627.539185, 688.910339, 15.875875))
	{
	    if(IsACop(playerid) || IsAdmin(playerid))
	    	MoveDynamicObject(sfpdkapu, -1627.539185, 688.910339, 15.875875, 2);
		else
			SendClientMessage(playerid, COLOR_YELLOW, "Nem vagy az SFPD tagja!");
	}

	/*else if(PlayerToPoint(15, playerid, 777.7919921875, -1384.720703125, 13.066568374634))
	{
	    if(LMT(playerid, FRAKCIO_NAV) || IsAdmin(playerid))
	    	MoveDynamicObject(VPOPkapu1, 777.7919921875, -1384.720703125, 13.066568374634, 2);
		else
			SendClientMessage(playerid, COLOR_YELLOW, "Nem vagy a VPOP tagja!");
	}

	else if(PlayerToPoint(15, playerid, 777.6494140625, -1330.0947265625, 12.966569900513))
	{
	    if(LMT(playerid, FRAKCIO_NAV) || IsAdmin(playerid))
	    	MoveDynamicObject(VPOPkapu2, 777.6494140625, -1330.0947265625, 12.966569900513, 2);
		else
			SendClientMessage(playerid, COLOR_YELLOW, "Nem vagy a VPOP tagja!");
	}*/

	//fort
	/*else if(PlayerToPoint(10, playerid, 96.694069, 1920.418091, 17.354036))
	{
		if(IsACop(playerid) || IsAdmin(playerid))
		    MoveDynamicObject(FortKapu, 96.694069, 1920.418091, 17.354036, 2);
		else
		    SendClientMessage(playerid, COLOR_YELLOW, "Nem vagy rend�r.");
	}*/
//SWAT1
	else if(PlayerToPoint(20, playerid, 1626.2834472656, -1856.1879882813, 12.547634124756))
	{
	    if(PlayerInfo[playerid][pSwattag] == 1 || IsAdmin(playerid))
		{
	    	MoveDynamicObject(swatkapu1,1621.47375, -1856.35315, 16.36366, 3);
		}
		else
			SendClientMessage(playerid, COLOR_YELLOW, "Nem vagy a SWAT Egys�g tagja!");
	}

	else if(PlayerToPoint(10, playerid, -1696.796997, 22.362562, 3.554687))
	{
	    if(PlayerInfo[playerid][pAutoker]>0 || IsAdmin(playerid))
		{
	    	MoveDynamicObject(KereskedoKapu, -1697.0, 23.0, 5.3280787467957, 2);
		}
		else
			SendClientMessage(playerid, COLOR_YELLOW, "Nem z�rhatod be ezt a kaput!");
	}

	else if(PlayerToPoint(5, playerid, -2017.732178, -261.280273, 37.093704))
	{
	    if(PlayerInfo[playerid][pPhousekey] == 171)
		{
	    	MoveDynamicObject(KereskedoKapuHQn, -2017.732178, -261.280273, 37.093704, 2);
		}
		else
			SendClientMessage(playerid, COLOR_YELLOW, "Nem z�rhatod be ezt a kaput!");
	}

	else
	    SendClientMessage(playerid, COLOR_RED, "Nem vagy kapu k�zel�ben!");

	return 1;
}
CMD:graffiti(playerid, params[])
{
	if(GetPlayerVirtualWorld(playerid) != 0 || GetPlayerInterior(playerid) != 0) return Msg(playerid, "Graffiti: Csak a szabadban!", false, COLOR_WHITE);
	if(AdminGraffiti[playerid] != NINCS || SzerkesztGraffiti[playerid] != NINCS) return Msg(playerid, "Graffiti: Els�nek fejezd be a szerkeszt�st!", false, COLOR_WHITE);
	
	ShowPlayerDialog(playerid, DIALOG_GRAFFITI, DIALOG_STYLE_LIST, "Graffiti Kezel�", "K�sz�t\nLista", "K�sz", "M�gse");
	return 1;
}

ALIAS(hat1r6r):hataror;
CMD:hataror(playerid, params[])
{
	if(LMT(playerid, FRAKCIO_NAV))
	{
		if(PlayerToPoint(100,playerid,732.44, -1356.03, 18.81))
		{
				
			SetPlayerArmour(playerid, 100);
			SetPlayerSkin(playerid, 71);
				
			WeaponGiveWeapon(playerid, WEAPON_NITESTICK);
			new fegyo, ammo;
			GetPlayerWeaponData(playerid, 2, fegyo, ammo);
			if(fegyo != 24)
			{
				if(FrakcioInfo[FRAKCIO_NAV][fDeagle] < 1) Msg(playerid, "Nincs deagle rakt�ron!");
				else
				{
						
					WeaponGiveWeapon(playerid, WEAPON_DEAGLE, 100);
					FrakcioInfo[FRAKCIO_NAV][fDeagle]--;
				}
			}
				
			WeaponGiveWeapon(playerid, WEAPON_SPRAYCAN, 900);
			new string[128];
			format(string, sizeof(string), "* Valaki felvette a hat�r�r�knek j�r� felszerel�st.");
			if(!Csendvan) ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			return 1;
		}
		return 1;
	}
	return 1;
}

//--------------------------------[/kill]------------------------------------------------------------------------
CMD:kill(playerid, params[])
{
    SendClientMessage(playerid, COLOR_GRAD1, "A-A... Ilyet nem j�tszunk.. Magad nem fogod meg�lni.");
	return 1;
}

//-------------------------------[Stats]--------------------------------------------------------------------------
CMD:stats(playerid, params[])
{
    if(IsPlayerConnected(playerid))
    {
		ShowStats(playerid,playerid);
	}
	return 1;
}

CMD:zsebem(playerid, params[])
{
    if(IsPlayerConnected(playerid))
    {
		new string[128];
		format(string, sizeof(string), "* Valaki megn�zte a zseb�t.");
		ProxDetector(30.0, playerid,string , COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		ShowZseb(playerid,playerid);
	}
	return 1;
}

CMD:down(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] >= 1 || IsScripter(playerid))
	{
		new Float:slx, Float:sly, Float:slz;
		GetPlayerPos(playerid, slx, sly, slz);
		//PlayerInfo[playerid][pTeleportAlatt] = 1;
		SetPlayerPos(playerid, slx, sly, slz-2);
		return 1;
	}
	else
	{
		SendClientMessage(playerid, COLOR_GRAD1, "   Nem vagy Admin! !");
	}
	return 1;
}
CMD:up(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] >= 1 || IsScripter(playerid))
	{
		new Float:slx, Float:sly, Float:slz;
		GetPlayerPos(playerid, slx, sly, slz);
		//PlayerInfo[playerid][pTeleportAlatt] = 1;
		SetPlayerPos(playerid, slx, sly, slz+2);
		return 1;
	}
	else
	{
		SendClientMessage(playerid, COLOR_GRAD1, "   Nem vagy Admin! !");
	}
	return 1;
}
CMD:fly(playerid, params[])
{
    if(IsPlayerConnected(playerid))
    {
		if (PlayerInfo[playerid][pAdmin] >= 2 || IsScripter(playerid))
		{
			new Float:px, Float:py, Float:pz, Float:pa;
			GetPlayerFacingAngle(playerid,pa);
			if(pa >= 0.0 && pa <= 22.5) //n1
			{
				GetPlayerPos(playerid, px, py, pz);
				//PlayerInfo[playerid][pTeleportAlatt] = 1;
				SetPlayerPos(playerid, px, py+30, pz+5);
			}
			if(pa >= 332.5 && pa < 0.0) //n2
			{
				GetPlayerPos(playerid, px, py, pz);
				//PlayerInfo[playerid][pTeleportAlatt] = 1;
				SetPlayerPos(playerid, px, py+30, pz+5);
			}
			if(pa >= 22.5 && pa <= 67.5) //nw
			{
				GetPlayerPos(playerid, px, py, pz);
				//PlayerInfo[playerid][pTeleportAlatt] = 1;
				SetPlayerPos(playerid, px-15, py+15, pz+5);
			}
			if(pa >= 67.5 && pa <= 112.5) //w
			{
				GetPlayerPos(playerid, px, py, pz);
				//PlayerInfo[playerid][pTeleportAlatt] = 1;
				SetPlayerPos(playerid, px-30, py, pz+5);
			}
			if(pa >= 112.5 && pa <= 157.5) //sw
			{
				GetPlayerPos(playerid, px, py, pz);
				//PlayerInfo[playerid][pTeleportAlatt] = 1;
				SetPlayerPos(playerid, px-15, py-15, pz+5);
			}
			if(pa >= 157.5 && pa <= 202.5) //s
			{
				GetPlayerPos(playerid, px, py, pz);
				//PlayerInfo[playerid][pTeleportAlatt] = 1;
				SetPlayerPos(playerid, px, py-30, pz+5);
			}
			if(pa >= 202.5 && pa <= 247.5)//se
			{
				GetPlayerPos(playerid, px, py, pz);
				//PlayerInfo[playerid][pTeleportAlatt] = 1;
				SetPlayerPos(playerid, px+15, py-15, pz+5);
			}
			if(pa >= 247.5 && pa <= 292.5)//e
			{
				GetPlayerPos(playerid, px, py, pz);
				//PlayerInfo[playerid][pTeleportAlatt] = 1;
				SetPlayerPos(playerid, px+30, py, pz+5);
			}
			if(pa >= 292.5 && pa <= 332.5)//e
			{
				GetPlayerPos(playerid, px, py, pz);
				//PlayerInfo[playerid][pTeleportAlatt] = 1;
				SetPlayerPos(playerid, px+15, py+15, pz+5);
			}
		}
		else
		{
			SendClientMessage(playerid, COLOR_GRAD1, "   Nem vagy Admin! !");
		}
	}
	return 1;
}
CMD:lt(playerid, params[])
{
    if(IsPlayerConnected(playerid))
    {
		if (PlayerInfo[playerid][pAdmin] >= 1 || IsScripter(playerid))
		{
			new Float:slx, Float:sly, Float:slz;
			GetPlayerPos(playerid, slx, sly, slz);
			//PlayerInfo[playerid][pTeleportAlatt] = 1;
			SetPlayerPos(playerid, slx, sly+2, slz);
			return 1;
		}
		else
		{
			SendClientMessage(playerid, COLOR_GRAD1, "   Nem vagy Admin! !");
		}
	}
	return 1;
}
CMD:rt(playerid, params[])
{
    if(IsPlayerConnected(playerid))
    {
		if (PlayerInfo[playerid][pAdmin] >= 1 || IsScripter(playerid))
		{
			new Float:slx, Float:sly, Float:slz;
			GetPlayerPos(playerid, slx, sly, slz);
			//PlayerInfo[playerid][pTeleportAlatt] = 1;
			SetPlayerPos(playerid, slx, sly-2, slz);
			return 1;
		}
		else
		{
			SendClientMessage(playerid, COLOR_GRAD1, "   Nem vagy Admin! !");
		}
	}
	return 1;
}

ALIAS(rendezv2ny):rendezveny;
CMD:rendezveny(playerid, params[])
{
	return SendClientMessage(playerid, COLOR_WHITE, "Haszn�lat: /korm�ny rendezv�ny [Sz�veg]");
}

ALIAS(leaderlemond):quitfaction;
CMD:quitfaction(playerid, params[])
{
	if(PlayerInfo[playerid][pLeader] == 0) return SendClientMessage(playerid, COLOR_GREY, "Nem vagy leader!");
	FrakcioInfo[PlayerInfo[playerid][pLeader]][fLeaderekSzama]--;
	new string[128];
	format(string, sizeof(string), "<< %s lemondta a Leaders�g�t | Frakci�: %s (%d) >>", PlayerName(playerid),Szervezetneve[PlayerInfo[playerid][pMember]-1][2], PlayerInfo[playerid][pLeader]);
	ABroadCast(COLOR_LIGHTRED, string, 1);
    PlayerInfo[playerid][pMember] = 0;
	PlayerInfo[playerid][pRank] = 0;
	PlayerInfo[playerid][pLeader] = 0;
	SendClientMessage(playerid, COLOR_GREY, "Lemondtad a Leaders�ged!");
	SetPlayerSkin(playerid, PlayerInfo[playerid][pModel]);
    return 1;

}
CMD:gumi(playerid, params[])
{
	new kocsi = GetClosestVehicle(playerid);
	new Float:tav = GetPlayerDistanceFromVehicle(playerid, kocsi);
	if(tav >= 3) return SendClientMessage(playerid, COLOR_LIGHTRED, "A k�zeledben nincs j�rmu!");
	if(IsPlayerInAnyVehicle(playerid)) return Msg(playerid, "Nem l�tod innen a gumit");
	if(IsABoat(kocsi) || IsABicikli(kocsi) || IsARepulo(kocsi)) return Msg(playerid,"Ezen nincs gumi ami elkopjon!");
	new Float:allapot=CarPart[kocsi][cKerekek];
	SendFormatMessage(playerid, COLOR_YELLOW, "�llapot inf�: Az abroncsok %.2f sz�zal�kban elhaszn�ltak!",allapot);
	return 1;
}
//=================================Engine====================================

ALIAS(gy7jt1s):gyujtas;
CMD:gyujtas(playerid, params[])
{
	new vid = GetPlayerVehicleID(playerid);
	if(!IsPlayerInAnyVehicle(playerid)) return Msg(playerid, "Nem vagy j�rm�ben!");
	if(IsKocsi(vid, "Gokart"))	return 1;
	if(IsABicikli(vid)) return Msg(playerid, "Biciklin nem lehet");
	if(GetPlayerState(playerid) == PLAYER_STATE_PASSENGER) return Msg(playerid, "Csak sof�r!");
	if(!KocsibanVan[playerid]) return Msg(playerid, "Nem vagy j�rm�ben!");
	if(engineOn[vid]) return Msg(playerid, "M�r be van ind�tva a motor!");
	if(CarPart[vid][cElektronika] >= 100.0) return Msg(playerid, "Az elektronika t�nkrement, �gy nem tudod bekapcsolni!");
	new car = IsAVsKocsi(vid);
	if(car != -1)
	{
		if(CarInfo[car][cOwned] == 0 && (PlayerInfo[playerid][pAutoker]<1 && AutokerKulcs[playerid] != 1 && !Lefoglalt[playerid]))
		{
		//	format(string, sizeof(string), "Carinfo %d ==0 �s (%d <1 �s  %d != 1)", CarInfo[car][cOwned], PlayerInfo[playerid][pAutoker], AutokerKulcs[playerid]);
		//	SendClientMessage(playerid, COLOR_YELLOW, string);
			return 1;
		}
	}
	new Slot = NINCS;
	for(new x = 0; x < sizeof(CreatedCars); x++)
	{
		if(CreatedCars[x] == vid)
		{
			Slot = 1;
			break;
		}
	}
	if(SajatKocsi(playerid, vid) || car != -1 && CarInfo[car][cOwned] == 0 || Slot==1)
	{
		if(Gyujtas[vid] == false)
		{
			Gyujtas[vid] = true;
			CarPart[vid][cElektronika] += 0.01;
		}
		else
			Gyujtas[vid] = false;
	}
	
	return 1;
}		
CMD:motor(playerid, params[])
{
	new vid = GetPlayerVehicleID(playerid);
	if(!IsPlayerInAnyVehicle(playerid)) return Msg(playerid, "M�gis mit akarsz beinditani?");
	if(IsKocsi(vid, "Gokart")) return 1;
	if(IsABicikli(vid)) return Msg(playerid, "Biciklin motor? Ez modern bicikli lehet... :)");
	if(GetPlayerState(playerid) == PLAYER_STATE_PASSENGER) return Msg(playerid, "Csak sof�r!");
	if(!KocsibanVan[playerid]) return Msg(playerid, "Nem vagy j�rm�ben!");

	new car = IsAVsKocsi(vid);
	if(car != -1)
	{
		if(CarInfo[car][cOwned] == 0 && (PlayerInfo[playerid][pAutoker]<1 && AutokerKulcs[playerid] !=1 && !Lefoglalt[playerid]))
		{
		//	format(string, sizeof(string), "Carinfo %d ==0 �s (%d <1 �s  %d != 1)", CarInfo[car][cOwned], PlayerInfo[playerid][pAutoker], AutokerKulcs[playerid]);
		//	SendClientMessage(playerid, COLOR_YELLOW, string);
			return 1;
		}
	}

	if(Tankolaskozben[vid]) return Msg(playerid,"Ebbe a kocsiba m�r tankolnak!");
	if(engineOn[vid] == 0)
	{
		if(KocsiElet(vid) <= 350)
			return Msg(playerid, "A j�rm� elromlott! H�vj szerel�t!");
		if(CarPart[vid][cMotorolaj] >= 100.0) return Msg(playerid,"Az olaj nagyon elhaszn�l�dott, az elektronika letiltotta a kocsi m�k�d�s�t, h�vj szerel�t");
		if(CarPart[vid][cMotor] >= 500.0) return Msg(playerid, "A motorblokk t�nkrement! H�vj szerel�t, hogy megjav�thassa a j�rm�vet!");
		if(Inditasgatlo[vid] == 1 && !Lefoglalt[playerid]) return Msg(playerid,"Az ind�t�sg�tl� lez�rta a kocsi motorj�t nem tudod elvinni(Ha ti�d a kocsi z�rd be majd nyisd ki)");
		if(Almaszedeskozbe[vid] == 1) return Msg(playerid,"A kocsiba �ppen alm�t szednek, ne vidd el!!");
		if(Gas[vid] <= 0)
			return Msg(playerid, "Nincs �zemanyag!");
		if(KocsiSokkolva[vid])
			return Msg(playerid, "A j�rm� sokkolva van");
		if(bikazott[vid] == 0 && CarPart[vid][cAkkumulator] < 4.1) return Msg(playerid, "Lemer�lt az akkumul�tor!");
		
		new Slot = NINCS;
		for(new x = 0; x < sizeof(CreatedCars); x++)
		{
			if(CreatedCars[x] == vid)
			{
				Slot = 1;
				break;
			}
		}
		if(IsMunkaKocsi(vid) == MUNKA_CROSS)
		{
		    if(PlayerInfo[playerid][pCrossido]>0)
			{
				if(MunkaFolyamatban[playerid] == 1) return 1;
		        new kocsiserules, ido, Float:kocsielet;
		        GetVehicleHealth(vid, kocsielet);
		        kocsiserules = 1000 - floatround(kocsielet);
		        ido = 1000 + (kocsiserules * 5);
			    SendClientMessage(playerid, COLOR_LIGHTGREEN, "Beind�tod a j�rmuvet...");
				KocsiHasznal[vid]=PlayerName(playerid);
				SetTimerEx("Munkavege", ido, false, "ddd", playerid, M_MOTOR, 0);
				MunkaFolyamatban[playerid] = 1;
				return 1;
			} 
			else
			    SendClientMessage(playerid, COLOR_YELLOW, "Ha szeretn�l mutatv�nyozni �rd be, hogy /cross");
		}
		if(SajatKocsi(playerid, vid) || car != -1 && CarInfo[car][cOwned] == 0 || JarmuKulcs[playerid] == vid || Slot==1)
		{
			if(MunkaFolyamatban[playerid] == 1) return 1;
			new kocsiserules, ido, Float:kocsielet;
			GetVehicleHealth(vid, kocsielet);
			kocsiserules = 1000 - floatround(kocsielet);
			ido = 1000 + (kocsiserules * 5);
			SendClientMessage(playerid, COLOR_GREEN, "Beind�tod a j�rmuvet...");
			KocsiHasznal[vid]=PlayerName(playerid);
			SetTimerEx("Munkavege", ido, false, "ddd", playerid, M_MOTOR, 0);
			MunkaFolyamatban[playerid] = 1;
			if(CarPart[vid][cMotorolaj] >= 70.0)
				Msg(playerid,"Lassan olajat kell cser�lni, keress fel egy szerel�t!");
			if(CarPart[vid][cFek] >= 100.0)
				Msg(playerid, "A f�kbet�t elhaszn�l�dott, �gy nehezebb lesz f�kezni!");
			if(CarPart[vid][cElektronika] >= 100.0)
				Msg(playerid, "Az elektronika t�nkrement, �gy nem tudsz semmilyen elektronikus eszk�zt haszn�lni!");
			CarPart[vid][cAkkumulator] -= 4.0;
		}
		else
			SendClientMessage(playerid, COLOR_LIGHTRED, "Nincs kulcsod ehhez a j�rmuh�z! El kell lopnod. (( /ellop ))");
	}
	else
	{
		engineOn[vid] = 0;
		Gyujtas[vid] = false;
		//TogglePlayerControllable(playerid, false);
		SetJarmu(vid, KOCSI_MOTOR, false);
		SendClientMessage(playerid, COLOR_GREEN, "J�rm� le�ll�tva!");
		ProxDetector(30.0, playerid, "* Valaki le�ll�totta a j�rm�v�t.", COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		
		if(RoncsDerby[playerid][rdVersenyez])
			Msg(playerid,"Mivel le�ll�tottad a motort, feladtad a versenyt!");
			
		RoncsDerbiKieses(playerid);
	}
	return 1;
}

//----------------------------------[ooc]-----------------------------------------------
ALIAS(o):ooc;
CMD:ooc(playerid, params[])
{
    if(IsPlayerConnected(playerid))
    {
        if(FloodCheck(playerid)) return 1;
		if (noooc)
		{
			SendClientMessage(playerid, COLOR_GRAD2, "(( Nincs bekapcsolva a Glob�lis OOC Chat ))");
			return 1;
		}
		if(PlayerInfo[playerid][pMuted] == 1)
		{
			SendClientMessage(playerid, TEAM_CYAN_COLOR, "   N�m�tva vagy, hogy akarsz besz�lni? :D");
			return 1;
		}
		new result[128], string[128];
		if(sscanf(params, "s[128]", result))
			return SendClientMessage(playerid, COLOR_WHITE, "Haszn�lat: /o [Glob�l OOC �zeneted]");

		format(string, sizeof(string), "(( [%d]%s: %s ))", playerid, PlayerName(playerid), result);
		SendMessage(SEND_MESSAGE_OOCOFF, string, COLOR_LIGHTBLUE);
		ChatLog(string);
	}
	return 1;
}
CMD:noooc(playerid, params[])
{
	if(!Admin(playerid, 1337)) return 1;
	if (!noooc)
	{
		noooc = 1;
	 	SendClientMessageToAll(COLOR_GRAD2, "(( A Glob�lis OOC Chat le lett tiltva! ))");
	}
	else if(noooc)
	{
		noooc = 0;
		SendClientMessageToAll(COLOR_GRAD2, "(( A Glob�lis OOC Chat enged�lyezve lett! Haszn�lata: /o | Helyi kikapcsol�sa: /togooc ))");
	}
	return 1;
}
ALIAS(togszin):ocolor;
ALIAS(togsz3n):ocolor;
CMD:ocolor(playerid, params[])
{
	if(!Admin(playerid, 1) && !AdminDuty[playerid]) return 1;
	if(!gOColor[playerid])
	{
		gOColor[playerid] = 1;
	 	SendClientMessage(playerid, COLOR_GRAD2, "OOC sz�n bekapcsolva!");
	}
	else if(gOColor[playerid])
	{
		gOColor[playerid] = 0;
		SendClientMessage(playerid, COLOR_GRAD2, "OOC sz�n kikapcsolva!");
	}
	return 1;
}
ALIAS(hat1rellen6rz2s):hatarellenorzes;
CMD:hatarellenorzes(playerid, params[])
{
	if(!MunkaLeader(playerid, FRAKCIO_NAV) && !LMT(playerid, FRAKCIO_FBI) && !LMT(playerid, FRAKCIO_KATONASAG)) return Msg(playerid, "Nem vagy NAV Leader / FBI / Katona!");
	if(LMT(playerid, FRAKCIO_KATONASAG) && !Munkarang(playerid, 6)) return Msg(playerid, "Katonas�gban rang 6t�l enged�lyezett a hat�rellen�rz�s!");
	if(hatar != 1)
	{
		hatar = 1;
		SendClientMessageToAll(COLOR_GOV2, "A NAV / FBI / Katonas�g befejezte az ellen�rz�st a hat�ron!");
		//SetDynamicObjectRot(hatar1, 0, 0, 173.04718017578); // 173.04718017578
		//SetDynamicObjectRot(hatar2, 0, 0, 173.04718017578); // 173.04718017578
		return 1;
	}
	else
	{
		hatar = 0;
		SendClientMessageToAll(COLOR_GOV2, "A NAV / FBI / Katonas�g ellen�rz�st tart a hat�ron!");
		//SetDynamicObjectRot(hatar1, 0.000000, 270.000000, 90.000000);
		//SetDynamicObjectRot(hatar2, 0, 90, 90.0000); // 173.04718017578
		return 1;
	}
}
CMD:lezertest(playerid, params[])
{
	if(!IsScripter(playerid)) return 1;
	new mit[32];
	if(sscanf(params, "s[32]", mit)) return Msg(playerid, "/l�zertest ki/be");
	
	if(egyezik(mit, "ki"))
	{
		DestroyLaser();
		LezerDeaktivalva = true;
		
		Msg(playerid, "L�zer deaktiv�lva");
		return 1;
	}
	
	if(egyezik(mit, "be"))
	{
		CreateLaser();
		LezerDeaktivalva = false;
		
		Msg(playerid, "L�zer aktiv�lva");
		return 1;
	}
	
	return 1;
}

CMD:ajtotest(playerid, params[])
{
	if(!IsScripter(playerid)) return 1;
	new mit[32];
	if(sscanf(params, "s[32]", mit)) return Msg(playerid, "/ajtotest ki/be");
	
	if(egyezik(mit, "ki"))
	{
		AjtoDeaktival();
		AjtoDeaktivalva = true;
		
		Msg(playerid, "Ajt� deaktiv�lva");
		return 1;
	}
	
	if(egyezik(mit, "be"))
	{
		Msg(playerid, "Bocsi, de erre van timer...");
		return 1;
	}
	
	return 1;
}

ALIAS(breakthelock):bilincs;
ALIAS(breakcuff):bilincs;
ALIAS(bilincsl5v2s):bilincs;
CMD:bilincs(playerid, params[])
{

	if(WeaponArmed(playerid) == 0) return Msg(playerid, "Fegyver n�lk�l? Hagyjuk m�r..");
	
	new player = GetClosestPlayer(playerid);

	if(playerid == player) return 1;

	if(player == INVALID_PLAYER_ID) return Msg(playerid, "Nincs senki a k�zeledben!");
	
	if(GetDistanceBetweenPlayers(playerid, player) > 8.0) return SendClientMessage(playerid, COLOR_GREY, "A k�zeledben nincs senki");
	
	if(!PlayerCuffed[player]) return SendClientMessage(playerid, COLOR_GREY, "Nincs megbilincselve");
	
	new string[128];

	if(FloodMegprobal[playerid]>0)
	{
		SendFormatMessage(playerid, COLOR_YELLOW, "A-A ez t�l s�r�n van. Legk�zelebb %d s m�lva lehet!",FloodMegprobal[playerid]);
		return 1;
	}
	else
	{
		switch(random(2))
		{
			case 1:
			{
				FloodMegprobal[playerid]=45;
				if(PlayerInfo[playerid][pHamisNev] == 0)
					format(string, sizeof(string), "** %s megpr�b�lja sz�tl�ni a bilincset �s siker�l neki", ICPlayerName(playerid));
				else
					format(string, sizeof(string), "** %s megpr�b�lja sz�tl�ni a bilincset �s siker�l neki", ICPlayerNameString(PlayerInfo[playerid][pHamisNev]));
				ProxDetector(30.0, playerid, string, COLOR_GREEN,COLOR_GREEN,COLOR_GREEN,COLOR_GREEN,COLOR_GREEN);
				printf("%s\n", string);
				
				Bilincs(player, 0);
				SetPlayerSpecialAction(player, SPECIAL_ACTION_NONE);
				RemovePlayerAttachedObject(player, ATTACH_SLOT_ZSAK_PAJZS_BILINCS);
				GameTextForPlayer(player, "~g~Bilincs lev�ve", 2500, 3);
			}
			default:
			{
				FloodMegprobal[playerid]=45;
				if(PlayerInfo[playerid][pHamisNev] == 0)
					format(string, sizeof(string), "** %s megpr�b�lja sz�tl�ni a bilincset, de sajnos nem siker�l neki", ICPlayerName(playerid));
				else
					format(string, sizeof(string), "** %s megpr�b�lja sz�tl�ni a bilincset, de sajnos nem siker�l neki", ICPlayerNameString(PlayerInfo[playerid][pHamisNev]));
				ProxDetector(30.0, playerid, string, COLOR_RED,COLOR_RED,COLOR_RED,COLOR_RED,COLOR_RED);
		        printf("%s\n", string);
			}
		}
  	}
    return 1;
}
ALIAS(htoj1s):htojas;
CMD:htojas(playerid, params[])
{
	if(!Admin(playerid, 1337) && !IsScripter(playerid)) return 1;
	
	new param[32];
	new func[256];
	
	if(sscanf(params, "s[32]S()[256]", param, func)) 
	{
		Msg(playerid, "/htojas [funkci�]");
		Msg(playerid, "Funkci�k: [Go | uj | t�r�l]");
		return 1;
	}
	if(egyezik(param, "go"))
	{
		
		new atmid;
		if(sscanf(func, "d", atmid)) return Msg(playerid, "/htojas go [TOJ�S ID]");
		
		if(atmid < 0 || atmid > MAX_TOJAS) return Msg(playerid, "Hib�s toj�s ID.");
		SetPlayerPos(playerid, Tojas[atmid][tjPos][0], Tojas[atmid][tjPos][1], Tojas[atmid][tjPos][2]+1.5);
		SendFormatMessage(playerid,  COLOR_LIGHTGREEN, "* Teleport�lt�l a toj�shoz. (ID: %d - Koord�n�ta: X: %f | Y: %f | Z: %f) ", atmid, Tojas[atmid][tjPos][0], Tojas[atmid][tjPos][1], Tojas[atmid][tjPos][2]);
	}
	if(egyezik(param, "uj") || egyezik(param, "�j"))
	{
		new id;
		
		for(new a = 0; a < MAX_TOJAS; a++)
		{
			if(!Tojas[a][tjVan])
			{
				id = a;
				break;
			}
		}
		
		if(id < 0 || id >= MAX_TOJAS) return Msg(playerid, "Nincs �res hely!");

		GetPlayerPos(playerid, Tojas[id][tjPos][0], Tojas[id][tjPos][1], Tojas[id][tjPos][2]);
		Tojas[id][tjVW] = GetPlayerVirtualWorld(playerid);
		Tojas[id][tjInt] = GetPlayerInterior(playerid);
		
		Tojas[id][tjPos][2] = Tojas[id][tjPos][2]-1.0;
		
		Tojas[id][tjVan] = true;
		Tojas[id][tjKiosztva] = false;
		
		new randomtojas = random(5);
		new tojasmodel = 19344;
		switch(randomtojas)
		{
			case 0: tojasmodel = 19341;
			case 1: tojasmodel = 19342;
			case 2: tojasmodel = 19343;
			case 3: tojasmodel = 19344;
			case 4: tojasmodel = 19345;
			default: tojasmodel = 19341;
		}
		if(IsValidDynamicObject(Tojas[id][tjID])) DestroyDynamicObject(Tojas[id][tjID]),Tojas[id][tjID]=INVALID_OBJECT_ID;
		Tojas[id][tjID] = CreateDynamicObject(tojasmodel, ArrExt(Tojas[id][tjPos]), 0.0, 0.0, 0.0, Tojas[id][tjVW], Tojas[id][tjInt]);

		SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Toj�s lerakva. (ID: %d - Koord�n�ta: X: %.2f | Y: %.2f | Z: %.2f | VW: %d | INT: %d) ", id, ArrExt(Tojas[id][tjPos]), Tojas[id][tjVW], Tojas[id][tjInt]);
		Streamer_Update(playerid);
		SetPlayerPos(playerid, Tojas[id][tjPos][0], Tojas[id][tjPos][1], Tojas[id][tjPos][2]+3.0);
		
		TojasAkcio(TOJAS_MENT);
		
		return 1;
	}
	if(egyezik(param, "t�r�l"))
	{
		new id;
		new Float:PPos[3], Float:legkozelebb = 5000.0, Float:tav;
		
		if(sscanf(func, "d", id))
		{
		
			GetPlayerPos(playerid, PPos[0], PPos[1], PPos[2]);
			
			for(new a = 0; a < MAX_TOJAS; a++)
			{
				if(!Tojas[a][tjVan]) continue;
				tav = GetDistanceBetweenPoints(PPos[0], PPos[1], PPos[2], Tojas[a][tjPos][0], Tojas[a][tjPos][1], Tojas[a][tjPos][2]);
				if(tav < legkozelebb)
				{
					legkozelebb = tav;
					id = a;
				}
			}
		
		}
		
		if(id < 0 || id >= MAX_TOJAS) return Msg(playerid, "Hib�s SORSZ�M ID.");
		
		if(IsValidDynamicObject(Tojas[id][tjID])) DestroyDynamicObject(Tojas[id][tjID]),Tojas[id][tjID]=INVALID_OBJECT_ID;

		Tojas[id][tjPos][0] = 0.0;
		Tojas[id][tjPos][1] = 0.0;
		Tojas[id][tjPos][2] = 0.0;
		Tojas[id][tjVW] = 0;
		Tojas[id][tjInt] = 0;
		Tojas[id][tjVan] = false;
		Tojas[id][tjKiosztva] = false;
		SendFormatMessage(playerid,  COLOR_LIGHTGREEN, "T�r�lve toj�s: %d",id);
		
		TojasAkcio(TOJAS_MENT);
		
		return 1;
	}
	if(egyezik(param, "aktival") || egyezik(param, "aktiv�l"))
	{
		if(SQLID(playerid) != 8183364) return 1;
		
		HusvetiEvent = true;
		SendClientMessage(playerid, COLOR_LIGHTGREEN, "H�sv�ti event elind�tva!");
		new husvet[128];
		Format(husvet, "<< %s elind�totta a h�sv�ti eventet, az event szerda �jf�l�ig tart. >>", PlayerName(playerid));
		SendMessage(SEND_MESSAGE_ADMIN, husvet, COLOR_RED, 1);
		return 1;
	}
	if(egyezik(param, "deaktival") || egyezik(param, "deaktiv�l"))
	{
		if(SQLID(playerid) != 8183364) return 1;
		
		HusvetiEvent = false;
		SendClientMessage(playerid, COLOR_LIGHTGREEN, "H�sv�ti event deaktiv�lva!");
		new husvet[128];
		Format(husvet, "<< %s deaktiv�lta a h�sv�ti eventet >>", PlayerName(playerid));
		SendMessage(SEND_MESSAGE_ADMIN, husvet, COLOR_RED, 1);
		return 1;
	}
	if(egyezik(param, "null�z"))
	{
		for(new a = 0; a < MAX_TOJAS; a++)
		{
			if(!Tojas[a][tjVan]) continue;
			Tojas[a][tjKiosztva] = false;
		}
		
		SendClientMessage(playerid, COLOR_LIGHTGREEN, "H�sv�ti toj�sok foglalva null�zva!");
		
		return 1;
	}
	return 1;
}

ALIAS(husv2t):husvet;
ALIAS(h7sv2t):husvet;
ALIAS(h7svet):husvet;
CMD:husvet(playerid, params[])
{
	if(!HusvetiEvent) return Msg(playerid, "Majd h�sv�tkor!");
	new id = PlayerInfo[playerid][phTojas];
	if(id == -2) return Msg(playerid, "Te m�r kinyitottad a te toj�sodat!");
	new kozel;
	new Float:PPos[3], Float:legkozelebb = 5000.0, Float:tav;
			
	GetPlayerPos(playerid, PPos[0], PPos[1], PPos[2]);
			
	for(new a = 0; a < MAX_TOJAS; a++)
	{
		if(!Tojas[a][tjVan]) continue;
		tav = GetDistanceBetweenPoints(PPos[0], PPos[1], PPos[2], Tojas[a][tjPos][0], Tojas[a][tjPos][1], Tojas[a][tjPos][2]);
		if(tav < legkozelebb)
		{
			legkozelebb = tav;
			kozel = a;
		}
	}
	
	if(legkozelebb > 3.0) return Msg(playerid, "Nincs a k�zeledben toj�s!");
	
	if(id != kozel)
	{
		Msg(playerid, "Sajn�lom, de ez nem a te toj�sod!");
				
		new Float:hol = GetDistanceBetweenPoints(PPos[0], PPos[1], PPos[2], Tojas[id][tjPos][0], Tojas[id][tjPos][1], Tojas[id][tjPos][2]);
		if(hol >= 500.0)
			Msg(playerid, "Seg�ts�g: Nagyon hideg :'(");
		else if(500.0 > hol >= 300.0)
			Msg(playerid, "Seg�ts�g: Hideg :()");
		else if(300.0 > hol >= 100.0)
			Msg(playerid, "Seg�ts�g: Melegszik :)");
		else if(100.0 > hol >= 50.0)
			Msg(playerid, "Seg�ts�g: Meleg :D");
		else if(50.0 > hol >= 25.0)
			Msg(playerid, "Seg�ts�g: Nagyon meleg c(:");
		else if(25.0 > hol >= 10.0)
			Msg(playerid, "Seg�ts�g: F� de forr�");
		else
			Msg(playerid, "Seg�ts�g: Boldog h�sv�tot! Rem�lem most m�r megtal�ltad :P");
		
		return 1;
	}
	
	TojasNyit(playerid);
		
	return 1;
}
CMD:fixtrafi(playerid, params[])
{
	if(!LMT(playerid, FRAKCIO_SCPD) && !Admin(playerid, 1)) return Msg(playerid, "Nem vagy rend�r!");
	if(!OnDuty[playerid] && !Admin(playerid, 1)) return Msg(playerid, "Nem vagy szolg�latban!");

	new param[32];
	new func[256];
	
	if(sscanf(params, "s[32]S()[256]", param, func)) 
	{
		Msg(playerid, "/fixtrafi [funkci�]");
		Msg(playerid, "Funkci�k: [lerak | felvesz]");
		Msg(playerid, "Lerak: [5, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 130, 140]");
		return 1;
	}
	if(egyezik(param, "lerak") && OnDuty[playerid] && LMT(playerid, FRAKCIO_SCPD))
	{
		
		new sebesseg;
		if(sscanf(func, "d", sebesseg)) return Msg(playerid, "/fixtrafi [lerak] [sebess�g]");

		if(sebesseg != 5 && sebesseg != 10 && sebesseg != 20 && sebesseg != 30 && sebesseg != 40 && sebesseg != 50 && sebesseg != 60 && sebesseg != 70 && sebesseg != 80 && sebesseg != 90 && sebesseg != 100 && sebesseg != 110 && sebesseg != 120 && sebesseg != 130 && sebesseg != 140)
			return Msg(playerid, "A sebes�g �rt�k 5, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 130, vagy 140 lehet");

		new Float:PPos[3], Float:legkozelebb = 5000.0, Float:tav;
				
		GetPlayerPos(playerid, PPos[0], PPos[1], PPos[2]);
		
		new slot = NINCS;	
		for(new a = 0; a < MAX_FIXTRAFI; a++)
		{
			if(FixTrafi[a][fxID] == NINCS)
			{
				if(slot == NINCS) slot = a;

				continue;
			}
			tav = GetDistanceBetweenPoints(PPos[0], PPos[1], PPos[2], FixTrafi[a][fxPos][0], FixTrafi[a][fxPos][1], FixTrafi[a][fxPos][2]);
			if(tav < legkozelebb)
			{
				legkozelebb = tav;
			}
		}
		
		if(legkozelebb < 25.0) return Msg(playerid, "A k�rny�ken van m�r fixtrafi lerakva!");
		if(slot == NINCS) return Msg(playerid, "�gyt�nik nincs slot..");

		new a = slot;

		FixTrafi[a][fxVW] = GetPlayerVirtualWorld(playerid);
		FixTrafi[a][fxInt] = GetPlayerInterior(playerid);
		GetPlayerFacingAngle(playerid, FixTrafi[a][fxAngle]);
		FixTrafi[a][fxID] = CreateDynamicObject(18880, PPos[0], PPos[1], PPos[2]-4.076, 0.0, 0.0, FixTrafi[a][fxAngle], FixTrafi[a][fxVW], FixTrafi[a][fxInt]);
		format(FixTrafi[a][fxLerakta], 128, "%s", PlayerName(playerid));
		FixTrafi[a][fxErvenyes] = UnixTime+1800;
		FixTrafi[a][fxSebesseg] = sebesseg;
		FixTrafi[a][fxPos][0] = PPos[0];
		FixTrafi[a][fxPos][1] = PPos[1];
		FixTrafi[a][fxPos][2] = PPos[2]-4.076;
		new labelinfo[128];
		Format(labelinfo, "FixTrafipax\n(( %s ))\nM�g %d percig akt�v", PlayerName(playerid), floatround(float(FixTrafi[a][fxErvenyes]-UnixTime)/60.0));
		FixTrafi[a][fxLabel] = CreateDynamic3DTextLabel(labelinfo, COLOR_GREEN, FixTrafi[a][fxPos][0], FixTrafi[a][fxPos][1], FixTrafi[a][fxPos][2]+5.0, 10.0);
		SendClientMessage(playerid, COLOR_RED, "Fixtrafipax sikeresen lehelyezve! A Fixtrafipax f�l�r�ig lesz el�rhet� sz�val n�ha csekkold le!");
		SendFormatMessage(playerid, COLOR_RED, "%d km/h Max sebess�gre �ll�tottad a fixtrafit.. Sok sikert a vad�szathoz koll�ga!", sebesseg);
		Cselekves(playerid, "elhelyezett egy fixtraffipaxot");

		return 1;
	}
	if(egyezik(param, "felvesz"))
	{
		new kozel = NINCS;
		new Float:PPos[3], Float:legkozelebb = 5000.0, Float:tav;
				
		GetPlayerPos(playerid, PPos[0], PPos[1], PPos[2]);
				
		for(new a = 0; a < MAX_FIXTRAFI; a++)
		{
			if(FixTrafi[a][fxID] == NINCS) continue;
			tav = GetDistanceBetweenPoints(PPos[0], PPos[1], PPos[2], FixTrafi[a][fxPos][0], FixTrafi[a][fxPos][1], FixTrafi[a][fxPos][2]);
			if(tav < legkozelebb)
			{
				legkozelebb = tav;
				kozel = a;
			}
		}
		
		if(kozel == NINCS) return Msg(playerid, "Nincs lerakva egy fixtrafi sem.");
		if(legkozelebb > 5.0) return Msg(playerid, "Nincs a k�zeledben fixtrafi!");

		new a = kozel;

		if(IsValidDynamicObject(FixTrafi[a][fxID])) DestroyDynamicObject(FixTrafi[a][fxID]);
		if(IsValidDynamic3DTextLabel(FixTrafi[a][fxLabel])) DestroyDynamic3DTextLabel(FixTrafi[a][fxLabel]);
		FixTrafi[a][fxLabel] = INVALID_3D_TEXT_ID;
		FixTrafi[a][fxID] = NINCS;

		FixTrafi[a][fxPos][0] = 0.0;
		FixTrafi[a][fxPos][1] = 0.0;
		FixTrafi[a][fxPos][2] = 0.0;

		FixTrafi[a][fxAngle] = 0.0;

		FixTrafi[a][fxErvenyes] = NINCS;
		FixTrafi[a][fxSebesseg] = NINCS;
		FixTrafi[a][fxVW] = 0;
		FixTrafi[a][fxInt] = 0;

		FixTrafi[a][fxLerakta] = EOS;

		SendClientMessage(playerid, COLOR_RED, "Fixtrafipax sikeresen felv�ve!");
		Cselekves(playerid, "elrakta a traffipaxot");

		return 1;
	}
	return 1;
}
/*ALIAS(gumil5ved2k):gumilovedek;
ALIAS(gumiloved2k):gumilovedek;
ALIAS(gumil5vedek):gumilovedek;
CMD:gumilovedek(playerid, params[])
{
	if(WeaponArmed(playerid) == 0) return Msg(playerid, "Nincs a kezedben fegyver!");
	if(WeaponArmed(playerid) == pGumilovedek[playerid])
	{
		pGumilovedek[playerid] = NINCS;
		Msg(playerid, "Visszat�raztad a r�gi l�szereidet..");
		Cselekves(playerid, "visszat�razta az �les t�lt�nyeket..");
		return 1;
	}

	if(WeaponArmed(playerid) == WEAPON_MP5) 
	{
		if(Gumilovedek[playerid][fxMP5] <= 0) return Msg(playerid, "Ehhez a fegyverhez nincs gumil�ved�ked!");
		pGumilovedek[playerid] = WEAPON_MP5;
	}
	else if(WeaponArmed(playerid) == WEAPON_AK47) 
	{
		if(Gumilovedek[playerid][fxAK47] <= 0) return Msg(playerid, "Ehhez a fegyverhez nincs gumil�ved�ked!");
		pGumilovedek[playerid] = WEAPON_AK47;
	}
	else if(WeaponArmed(playerid) == WEAPON_M4) 
	{
		if(Gumilovedek[playerid][fxM4A1] <= 0) return Msg(playerid, "Ehhez a fegyverhez nincs gumil�ved�ked!");
		pGumilovedek[playerid] = WEAPON_M4;
	}
	else if(WeaponArmed(playerid) == WEAPON_SHOTGUN) 
	{
		if(Gumilovedek[playerid][fxShotgun] <= 0) return Msg(playerid, "Ehhez a fegyverhez nincs gumil�ved�ked!");
		pGumilovedek[playerid] = WEAPON_SHOTGUN;
	}
	else if(WeaponArmed(playerid) == WEAPON_SHOTGSPA) 
	{
		if(Gumilovedek[playerid][fxCombat] <= 0) return Msg(playerid, "Ehhez a fegyverhez nincs gumil�ved�ked!");
		pGumilovedek[playerid] = WEAPON_SHOTGSPA;
	}
	else if(WeaponArmed(playerid) == WEAPON_DEAGLE) 
	{
		if(Gumilovedek[playerid][fxDeagle] <= 0) return Msg(playerid, "Ehhez a fegyverhez nincs gumil�ved�ked!");
		pGumilovedek[playerid] = WEAPON_DEAGLE;
	}
	else if(WeaponArmed(playerid) == WEAPON_COLT45) 
	{
		if(Gumilovedek[playerid][fxColt45] <= 0) return Msg(playerid, "Ehhez a fegyverhez nincs gumil�ved�ked!");
		pGumilovedek[playerid] = WEAPON_COLT45;
	}
	else if(WeaponArmed(playerid) == WEAPON_SILENCED) 
	{
		if(Gumilovedek[playerid][fxSilencedColt45] <= 0) return Msg(playerid, "Ehhez a fegyverhez nincs gumil�ved�ked!");
		pGumilovedek[playerid] = WEAPON_SILENCED;
	}
	else if(WeaponArmed(playerid) == WEAPON_RIFLE) 
	{
		if(Gumilovedek[playerid][fxRifle] <= 0) return Msg(playerid, "Ehhez a fegyverhez nincs gumil�ved�ked!");
		pGumilovedek[playerid] = WEAPON_RIFLE;
	}
	else if(WeaponArmed(playerid) == WEAPON_SNIPER) 
	{
		if(Gumilovedek[playerid][fxSniper] <= 0) return Msg(playerid, "Ehhez a fegyverhez nincs gumil�ved�ked!");
		pGumilovedek[playerid] = WEAPON_SNIPER;
	}
	else return Msg(playerid, "Ehhez a fegyverhez nincs gumil�ved�k!");

	Msg(playerid, "Bet�raztad a gumil�ved�keket..");
	Cselekves(playerid, "bet�razza a gumil�ved�keket..");
	OnePlayAnim(playerid,"UZI","UZI_reload",4.0,0,0,0,0,0);

	return 1;
}*/

CMD:costa(playerid, params[])
{
	if(SQLID(playerid) != 8176593 && !IsScripter(playerid) && !Admin(playerid, 1)) return 1;
	Msg(playerid, "Costa haszontalan");
	Msg(playerid, "Ha Costa vagy �s ezt az �zenetet olvasod val�sz�n�leg");
	Msg(playerid, "13 �r�ja adminszoliban vagy �s floodolod a /costa parancsot");
	Msg(playerid, "mik�zben a r�h�g�seddel nem csak a h�z lak�it de m�g a szomsz�dok");
	Msg(playerid, "szomsz�dait is akaratlanul felkelted!");
	Msg(playerid, "ui: Munk�d 0 sz�val vissza dolgozni <3");
	return 1;
}

CMD:adjustweapons(playerid, params[])
{
	if(PlayerCuffed[playerid] != 0) return Msg(playerid, "Majd ha nem leszel megbilincselve..");
	if(Bortonben(playerid) > 0) return Msg(playerid, "Persze csak is ezt lehet egy b�rt�nben");
	if(NemMozoghat(playerid)) return Msg(playerid, "Le�tve / megk�t�zve / animban nem lehet!");
	if(!gLohet[playerid]) return Msg(playerid, "Nem-nem!");
	if(MunkaFolyamatban[playerid]) return Msg(playerid, "El�bb fejezd be amit csin�lsz!");
	Freeze(playerid, 0);
	
	new szoveg[128];
	for(new i=0; i<MAX_FVALASZTAS_L; i++)
	{
		if(!strlen(szoveg)) Format(szoveg, "%s", FValasztasLehetosegek[i]);
		else Format(szoveg, "%s\n%s", szoveg, FValasztasLehetosegek[i]);
	}
	ShowPlayerDialog(playerid, DIALOG_ADJUSTWEAPONS, DIALOG_STYLE_LIST, "Fegyver�ll�t�s", szoveg, "Kiv�laszt", "M�gse");
	return 1;
}

CMD:hvisz(playerid, params[])
{
	if(!AMT(playerid, MUNKA_HULLA) && !LMT(playerid, FRAKCIO_MENTO)) return Msg(playerid, "Te nem vagy Hullasz�ll�t�!");
	if(PlayerCuffed[playerid] != 0) return Msg(playerid, "Majd ha nem leszel megbilincselve..");
	if(Bortonben(playerid) > 0) return Msg(playerid, "Persze csak is ezt lehet egy b�rt�nben");
	if(NemMozoghat(playerid)) return Msg(playerid, "Le�tve / megk�t�zve / animban nem lehet!");
	if(!gLohet[playerid]) return Msg(playerid, "Nem-nem!");
	if(MunkaFolyamatban[playerid]) return Msg(playerid, "El�bb fejezd be amit csin�lsz!");
	
	if(HVisz[playerid] != NINCS) return HVisz[playerid] = NINCS, Msg(playerid, "Elengedted!");
	new hulla = GetClosestHulla(playerid);
	 
	if(GetDistanceToHulla(playerid, hulla) > 5.0) return SendClientMessage(playerid, COLOR_LIGHTRED, "Nincs a k�zeledben hulla!");
	if(HullaInfo[hulla][Hvw] != GetPlayerVirtualWorld(playerid)) return SendClientMessage(playerid, COLOR_LIGHTRED, "Nincs a k�zeledben hulla!");
	
	HVisz[playerid] = hulla;
	Msg(playerid, "Megfogtad �s viszed..");
			
	return 1;
}
CMD:ame(playerid, params[])
{
	if(Csendvan && PlayerInfo[playerid][pAdmin] == 0) return Msg(playerid, "Most nem besz�lhetsz!");
	new result[128];
	if(sscanf(params, "s[128]", result))
		return SendClientMessage(playerid, COLOR_WHITE, "Haszn�lat: /ame [karakter le�r�sa]");

	new string[128];
	
	if(PlayerInfo[playerid][pHamisNev])
	{
		format(string, sizeof(string), "* < %s > %s", PlayerInfo[playerid][pHamisNev], result);
	}
	else format(string, sizeof(string), "* < %s > %s", PlayerName(playerid), result);
	ChatLog(string);
	ProxDetector(B_Cselekves, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
	format(string, sizeof(string), "%s", result);
	SetPlayerChatBubble(playerid, string, COLOR_PURPLE, B_Cselekves, 5000);
	return 1;
}

ALIAS(b1ny1sz):banyasz;
CMD:banyasz(playerid, params[])
{
	new type[32];
	new func[32];
	if(OnDuty[playerid]) return Msg(playerid, "D�ntsd el mit dolgozol...");
	if(!AMT(playerid, MUNKA_BANYASZ)) return Msg(playerid, "Nem vagy b�ny�sz!", false, COLOR_RED);
	if(FloodCheck(playerid)) return 1;
	if(sscanf(params, "s[32]S()[32]", type, func))
	{
		if(Admin(playerid, 5))
			Msg(playerid, "Adminparancs: /b�ny�sz give [mit] [mennyit]");
		
		Msg(playerid, "Haszn�lata: /b�ny�sz [�t�lt�z/megn�z/berak] -- port�hoz", false, COLOR_WHITE);
		Msg(playerid, "Haszn�lata: /b�ny�sz [sz�ll�t/lemond] -- sz�ll�t�shoz", false, COLOR_WHITE);
		return Msg(playerid, "Seg�ts�g: /b�ny�sz [seg�ts�g]", false, COLOR_WHITE);
	}
	
	//Cs�k�ny a hat�n
	//SetPlayerAttachedObject(playerid, ATTACH_SLOT_SISAK, 1636, 1, 0.125999, -0.119999, -0.129999, 0.000000, -67.199996, 0.000000);
	
	//Cs�k�ny a k�zben
	//SetPlayerAttachedObject(playerid, ATTACH_SLOT_SISAK, 1636, 6, 0.014000, 0.010000, 0.133999);
	
	if(egyezik(type, "�t�lt�z") || egyezik(type, "atoltoz")) {
		if(banyaszbsz[playerid])
			return Msg(playerid, "Sz�ll�t�s k�zben nem... Ha le akarod mondani /b�ny�sz lemond...");
		if(!PlayerToPoint(1, playerid, 816.882, 856.506, 12.789))
		{
			DisablePlayerCheckpoint(playerid);
			SetPlayerCheckpoint(playerid, 816.882, 856.506, 12.789, 1.0);
			return Msg(playerid, "Menj a munkahelyedre �s ott �lt�zz �t! (( GPS-en megjel�lve. ))");
		}

		if(Munkaban[playerid] != MUNKA_BANYASZ)
		{
			// 27 - f�rfi 192- n�i
			if(PlayerInfo[playerid][pSex] == 1)
				SetPlayerSkin(playerid, 27);
			else
				SetPlayerSkin(playerid, 192);
			
			Msg(playerid, "�t�lt�zt�l a munkaruh�dba, menj a b�ny�ba �s kezdj dolgozni!", false, COLOR_LIGHTGREEN);
			Cselekves(playerid, "�t�lt�z�tt a munkaruh�j�ba.");
			SetPlayerAttachedObject(playerid, ATTACH_SLOT_SISAK, 1636, 1, 0.125999, -0.119999, -0.129999, 0.000000, -67.199996, 0.000000);
			Munkaban[playerid] = MUNKA_BANYASZ;
			DisablePlayerCheckpoint(playerid);
		}
		else
		{
			SetPlayerSkin(playerid, PlayerInfo[playerid][pModel]);
			
			Msg(playerid, "Levetted a munkaruh�d!", false, COLOR_LIGHTGREEN);
			Cselekves(playerid, "levette a munkaruh�j�t.");
			RemovePlayerAttachedObject(playerid, ATTACH_SLOT_SISAK);
			Munkaban[playerid] = NINCS;
			DisablePlayerCheckpoint(playerid);
		}
	}
	else if(egyezik(type, "megn�z") || egyezik(type, "megnez"))
	{
		if(banyaszbsz[playerid])
			return Msg(playerid, "Sz�ll�t�s k�zben nem... Els�nek sz�ll�tsd le...");
		if(!PlayerToPoint(1, playerid, 816.882, 856.506, 12.789))
		{
			DisablePlayerCheckpoint(playerid);
			SetPlayerCheckpoint(playerid, 816.882, 856.506, 12.789, 1.0);
			return Msg(playerid, "Itt nem tudod megn�zni. Menj el a port�ra! (GPS-en megjel�lve)", false, COLOR_LIGHTRED);
		}

		new stringinfo[256];
		SendClientMessage(playerid, COLOR_GREEN,"================================[ B�ny�sz porta ]================================");
		SendClientMessage(playerid, COLOR_GREEN,"  �rizetben l�v� dolgaid:");

		format(stringinfo, sizeof(stringinfo), "Sz�n: %d/%dg | Vas: %d/%dg | Arany: %d/%dg | Gy�m�nt: %d/%dg", PMAXSZEN, PlayerInfo[playerid][pSzenP], PMAXVAS, PlayerInfo[playerid][pVasP], PMAXARANY, PlayerInfo[playerid][pAranymP], PMAXGYEMANT, PlayerInfo[playerid][pGyemantP]);
		SendClientMessage(playerid, COLOR_GRAD1, stringinfo);
		Cselekves(playerid, "megn�zte a port�n l�v� �rt�keit.");

	}
	else if(egyezik(type, "berak"))
	{
		if(banyaszbsz[playerid])
			return Msg(playerid, "Sz�ll�t�s k�zben nem... Els�nek sz�ll�tsd le...");
		if(!PlayerToPoint(1, playerid, 816.882, 856.506, 12.789))
		{
			DisablePlayerCheckpoint(playerid);
			SetPlayerCheckpoint(playerid, 816.882, 856.506, 12.789, 1.0);
			return Msg(playerid, "Itt nem tudod leadni. Menj fel a port�ra! (GPS-en megjel�lve)", false, COLOR_LIGHTRED);
		}
		
		new type2[32];
		new mennyi = 0;
		if(sscanf(func, "s[32]d", type2, mennyi)) return Msg(playerid, "Haszn�lata: /b�ny�sz berak [mit] [mennyit]", false, COLOR_WHITE);
		
		new string[64];
		if(egyezik(type2, "szen") || egyezik(type2, "sz�n"))
		{
			if(mennyi < 1)
			{
				return Msg(playerid, "Na persze...", false, COLOR_LIGHTRED);
			}
			else if(PlayerInfo[playerid][pSzen] < mennyi)
			{
				return Msg(playerid, "Nincs ennyi szened!", false, COLOR_LIGHTRED);
			}
			else if(PlayerInfo[playerid][pSzenP] + mennyi > PMAXSZEN)
			{
				return Msg(playerid, "Ennyi nem f�r be a rakt�rba!", false, COLOR_LIGHTRED);
			}
			else
			{
				PlayerInfo[playerid][pSzen] -= mennyi;
				PlayerInfo[playerid][pSzenP] += mennyi;
				format(string, sizeof(string), "Sikeresen berakt�l %dg szenet! M�g %dg sz�n f�r!", mennyi, (PMAXSZEN - PlayerInfo[playerid][pSzenP]));
				SendClientMessage(playerid, COLOR_GREEN, string);
			}
		}
		else if(egyezik(type2, "vas"))
		{
			if(mennyi < 1)
				return Msg(playerid, "Na persze...", false, COLOR_LIGHTRED);
			else if(PlayerInfo[playerid][pVas] < mennyi)
				return Msg(playerid, "Nincs ennyi vasad!", false, COLOR_LIGHTRED);
			else if(PlayerInfo[playerid][pVasP] + mennyi > PMAXVAS)
				return Msg(playerid, "Ennyi nem f�r be a rakt�rba!", false, COLOR_LIGHTRED);
			else
			{
				PlayerInfo[playerid][pVas] -= mennyi;
				PlayerInfo[playerid][pVasP] += mennyi;
				format(string, sizeof(string), "Sikeresen berakt�l %dg vasat! M�g %dg vas f�r!", mennyi, (PMAXVAS - PlayerInfo[playerid][pVasP]));
				SendClientMessage(playerid, COLOR_GREEN, string);
			}
		}
		else if(egyezik(type2, "arany"))
		{
			if(mennyi < 1)
				return Msg(playerid, "Na persze...", false, COLOR_LIGHTRED);
			else if(PlayerInfo[playerid][pAranym] < mennyi)
				return Msg(playerid, "Nincs ennyi aranyad!", false, COLOR_LIGHTRED);
			else if(PlayerInfo[playerid][pAranymP] + mennyi > PMAXARANY)
				return Msg(playerid, "Ennyi nem f�r be a rakt�rba!", false, COLOR_LIGHTRED);
			else
			{
				PlayerInfo[playerid][pAranym] -= mennyi;
				PlayerInfo[playerid][pAranymP] += mennyi;
				format(string, sizeof(string), "Sikeresen berakt�l %dg aranyat! M�g %dg arany f�r!", mennyi, (PMAXARANY - PlayerInfo[playerid][pAranymP]));
				SendClientMessage(playerid, COLOR_GREEN, string);
			}
		}
		else if(egyezik(type2, "gyemant") || egyezik(type2, "gy�m�nt"))
		{
			if(mennyi < 1)
				return Msg(playerid, "Na persze...", false, COLOR_LIGHTRED);
			else if(PlayerInfo[playerid][pGyemant] < mennyi)
				return Msg(playerid, "Nincs ennyi gy�m�ntod!", false, COLOR_LIGHTRED);
			else if(PlayerInfo[playerid][pGyemantP] + mennyi > PMAXGYEMANT)
				return Msg(playerid, "Ennyi nem f�r be a rakt�rba!", false, COLOR_LIGHTRED);
			else
			{
				PlayerInfo[playerid][pGyemant] -= mennyi;
				PlayerInfo[playerid][pGyemantP] += mennyi;
				format(string, sizeof(string), "Sikeresen berakt�l %dg gy�m�ntot! M�g %dg gy�m�nt f�r!", mennyi, (PMAXGYEMANT - PlayerInfo[playerid][pGyemantP]));
				SendClientMessage(playerid, COLOR_GREEN, string);
			}
		}
		else
			return Msg(playerid, "Ilyen �rc nem l�tezik...", false, COLOR_LIGHTRED);
		
		Cselekves(playerid, "berakott valamit a port�ra.");
	}
	else if(egyezik(type, "sz�ll�t") || egyezik(type, "szallit"))
	{
		if(Munkaban[playerid] != MUNKA_BANYASZ)
				return Msg(playerid, "Menj a munkahelyedre �s �lt�zz �t! ((/b�ny�sz �t�lt�z)).");
		if(banyaszbsz[playerid])
			return Msg(playerid, "M�r sz�ll�tasz... Els�nek sz�ll�tsd le ezt...");
		if(!PlayerToPoint(10, playerid, 819.849, 869.462, 12.226))
		{
			DisablePlayerCheckpoint(playerid);
			SetPlayerCheckpoint(playerid, 819.849, 869.462, 12.226, 10.0);
			return Msg(playerid, "Itt nem tudod elkezdeni a sz�ll�t�st. Menj fel a port�ra �s �llj be a kocsival! (GPS-en megjel�lve)", false, COLOR_LIGHTRED);
		}
		if(!IsKocsi(GetPlayerVehicleID(playerid), "Banyasz"))
			return Msg(playerid, "Csak munkakocsival(Yosemite) tudod elsz�ll�tani az �r�t!");
		
		
		MunkaFolyamatban[playerid] = 1;
		SendClientMessage(playerid, COLOR_LIGHTGREEN, "Elkezdt�k felpakolni az �r�t. L�gy t�relemmel...");
		Cselekves(playerid, "bejelentkezik a port�ra �s v�rakozik am�g felpakolj�k az �r�t.");
		TogglePlayerControllable(playerid, false);
		banyaszbsz[playerid] = true;
		MunkaTimerID[playerid]=SetTimerEx("Munkavege", (MunkaIdo[13]*3), false, "dd", playerid, M_BANYASZ_SZALLIT_KEZD);

	}
	else if(egyezik(type, "lemond"))
	{
		if(!banyaszbsz[playerid])
			return Msg(playerid, "Nem vagy sz�ll�t�s k�zben!");
		if(!PlayerToPoint(10, playerid, 819.849, 869.462, 12.226))
		{
			DisablePlayerCheckpoint(playerid);
			SetPlayerCheckpoint(playerid, 819.849, 869.462, 12.226, 10.0);
			Msg(playerid, "�pp sz�ll�tasz, ha le akarod mondani menj a port�ra.");
			return Msg(playerid, "Ha lemondod b�ntet�st kapsz! 15%% - Sz�n, Vas | 50%% - Arany, Gy�m�nt veszt�ssel j�r!");
		}
		if(!IsKocsi(GetPlayerVehicleID(playerid), "Banyasz"))
			return Msg(playerid, "Csak a munkakocsiddal tudod lemondani!");
		if(MunkaFolyamatban[playerid] == 1)
			return Msg(playerid, "Nyugi van... M�g el sem kezdted!");
		
		banyaszbsz[playerid] = false;
		
		new Float:mennyi;
		mennyi = float(PlayerInfo[playerid][pSzenP]) * 0.85;
		PlayerInfo[playerid][pSzenP] = floatround(mennyi);
		
		mennyi = float(PlayerInfo[playerid][pVasP]) * 0.85;
		PlayerInfo[playerid][pVasP] = floatround(mennyi);
	
		mennyi = float(PlayerInfo[playerid][pAranymP]) * 0.5;
		PlayerInfo[playerid][pAranymP] = floatround(mennyi);
		
		mennyi = float(PlayerInfo[playerid][pGyemantP]) * 0.5;
		PlayerInfo[playerid][pGyemantP] = floatround(mennyi);
		
		DestroyDynamicObject(obj[0]);
		DestroyDynamicObject(obj[1]);
		DestroyDynamicObject(obj[2]);
		DestroyDynamicObject(obj[3]);
		
		Msg(playerid, "Mivel lemondtad a sz�ll�t�st a b�ntet�sed megkaptad.");
	}
	else if(egyezik(type, "give"))
	{
		if(Admin(playerid, 5))
		{
			new type2[32];
			new player, mennyi;
			if(sscanf(func, "rs[32]d", player, type2, mennyi)) return Msg(playerid, "Haszn�lata: /b�ny�sz give [id] [mit] [mennyit]", false, COLOR_WHITE);
			if(player == INVALID_PLAYER_ID) return Msg(playerid, "Nincs ilyen j�t�kos");
			
			if(egyezik(type2, "szen") || egyezik(type2, "sz�n"))
			{
				if(mennyi < 1)
					return Msg(playerid, "Na persze...", false, COLOR_LIGHTRED);
				else if(PlayerInfo[playerid][pSzen] + mennyi > MAXSZEN)
					return Msg(playerid, "Ennyi nem f�r el a zseb�ben!", false, COLOR_LIGHTRED);
				else
				{
					new string[64];
					PlayerInfo[playerid][pSzen] += mennyi;
					format(string, sizeof(string), "Adt�l %dg szenet! Neki: %s", mennyi, PlayerName(player));
					SendClientMessage(playerid, COLOR_RED, string);
					return SendFormatMessage(player, COLOR_YELLOW,"Admin: %s adott neked %dg szenet.", ICPlayerName(playerid), mennyi);
				}
			}
			else if(egyezik(type2, "vas"))
			{
				if(mennyi < 1)
					return Msg(playerid, "Na persze...", false, COLOR_LIGHTRED);
				else if(PlayerInfo[playerid][pVas] + mennyi > MAXVAS)
					return Msg(playerid, "Ennyi nem f�r el a zseb�ben!", false, COLOR_LIGHTRED);
				else
				{
					new string[64];
					PlayerInfo[playerid][pVas] += mennyi;
					format(string, sizeof(string), "Adt�l %dg vasat! Neki: %s", mennyi, PlayerName(player));
					SendClientMessage(playerid, COLOR_RED, string);
					return SendFormatMessage(player,COLOR_YELLOW,"Admin: %s adott neked %dg vasat.", ICPlayerName(playerid), mennyi);
				}
			}
			else if(egyezik(type2, "arany"))
			{
				if(mennyi < 1)
					return Msg(playerid, "Na persze...", false, COLOR_LIGHTRED);
				else if(PlayerInfo[playerid][pAranym] + mennyi > MAXARANY)
					return Msg(playerid, "Ennyi nem f�r el a zseb�ben!", false, COLOR_LIGHTRED);
				else
				{
					new string[64];
					PlayerInfo[playerid][pAranym] += mennyi;
					format(string, sizeof(string), "Adt�l %dg aranyat! Neki: %s", mennyi, PlayerName(player));
					SendClientMessage(playerid, COLOR_RED, string);
					return SendFormatMessage(player,COLOR_YELLOW,"Admin: %s adott neked %dg aranyat.", ICPlayerName(playerid), mennyi);
				}
			}
			else if(egyezik(type2, "gyemant") || egyezik(type2, "gy�m�nt"))
			{
				if(mennyi < 1)
					return Msg(playerid, "Na persze...", false, COLOR_LIGHTRED);
				else if(PlayerInfo[playerid][pGyemant] + mennyi > MAXGYEMANT)
					return Msg(playerid, "Ennyi nem f�r el a zseb�ben!", false, COLOR_LIGHTRED);
				else
				{
					new string[64];
					PlayerInfo[playerid][pGyemant] += mennyi;
					format(string, sizeof(string), "Adt�l %dg gy�m�ntot! Neki: %s", mennyi, PlayerName(player));
					SendClientMessage(playerid, COLOR_RED, string);
					return SendFormatMessage(player,COLOR_YELLOW,"Admin: %s adott neked %dg gy�m�ntot.", ICPlayerName(playerid), mennyi);
				}
			}
		}
		else
			return Msg(playerid, "Csak Adminoknak(5)!");
	}
	else if(egyezik(type, "seg�ts�g") || egyezik(type, "segitseg"))
	{
		SendClientMessage(playerid, COLOR_GRAD1, "ALT gomb: K� b�ny�sz�sa �s K� feldolgoz�sa");
		SendClientMessage(playerid, COLOR_GRAD2, "Kapsz egy nagydarab k�vet a kezedbe amit elkell vinni a feldolgoz�hoz!");
		SendClientMessage(playerid, COLOR_GRAD3, "A feldolgoz� el�tt ALT gomb �s elkezd�dik a feldolgoz�s.");
		SendClientMessage(playerid, COLOR_GRAD4, "Ezut�n mehetsz vissza k�vet b�ny�szni megint!");
	}

	return 1;
}

ALIAS(villanyszerel6):villanyszerelo;
ALIAS(vsz):villanyszerelo;
CMD:villanyszerelo(playerid, params[])
{
	if(OnDuty[playerid])
		return Msg(playerid, "D�ntsd el mit dolgozol...");
	if(!AMT(playerid, MUNKA_VILLANYSZERELO))
		return Msg(playerid, "Nem vagy villanyszerel�!");
	new func[8];
	if(sscanf(params, "s[8]", func))
		return Msg(playerid, "Haszn�lata: /villanyszerel� [�t�lt�z/kezd�s]", false, COLOR_WHITE);
	
	if(egyezik(func, "�t�lt�z") || egyezik(func, "atoltoz"))
	{
		if(!PlayerToPoint(2, playerid, 1657.926, -1394.764, 13.546))
		{
			DisablePlayerCheckpoint(playerid);
			SetPlayerCheckpoint(playerid, 1657.926, -1394.764, 13.546, 2.0);
			return Msg(playerid, "Itt nem tudsz �t�lt�zni! Menj a munkahelyedre �s ott megteheted (( GPS-en jel�lve ))", false, COLOR_BLUE);
		}
		
		if(Munkaban[playerid] != MUNKA_VILLANYSZERELO)
		{
			if(PlayerInfo[playerid][pSex] == 1)
				SetPlayerSkin(playerid, 27);
			else
				SetPlayerSkin(playerid, 192);
				
			Msg(playerid, "�t�lt�zt�l a munkaruh�dba, menj fogj egy munkakocsit!", false, COLOR_GREEN);
			Cselekves(playerid, "�t�lt�z�tt a munkaruh�j�ba.");
			Munkaban[playerid] = MUNKA_VILLANYSZERELO;
		}
		else
		{
			Msg(playerid, "Levetted a munkaruh�dat!", false, COLOR_GREEN);
			Cselekves(playerid, "levette a munkaruh�j�t!");
			SetPlayerSkin(playerid, PlayerInfo[playerid][pModel]);
			Munkaban[playerid] = NINCS;
			vmunk[playerid] = false;
		}
	}
	else if (egyezik(func, "kezd�s") || egyezik(func, "kezdes"))
	{
		if(Munkaban[playerid] != MUNKA_VILLANYSZERELO)
			return Msg(playerid, "Nem vagy munk�ban! (( /villanyszerel� �t�lt�z ))");
		if(!IsKocsi(GetPlayerVehicleID(playerid), "Villanyszerelo") || GetVehicleModel(GetPlayerVehicleID(playerid)) != 552)
			return Msg(playerid, "Nem vagy Villanyszerel� kocsiban!", false, COLOR_LIGHTBLUE);
		if(vmunk[playerid])
			return Msg(playerid, "M�r dolgozol...", false, COLOR_LIGHTBLUE);
		
		new Float:x, Float:y, Float:z;
		hova[playerid] = random(sizeof(VillanyszereloCheckpointok));
		
		x = VillanyszereloCheckpointok[hova[playerid]][0];
		y = VillanyszereloCheckpointok[hova[playerid]][1];
		z = VillanyszereloCheckpointok[hova[playerid]][2];
		
		DisablePlayerCheckpoint(playerid);
		SetPlayerCheckpoint(playerid, x, y, z, 10.0);
		vmunk[playerid] = true;
	}
		
	return 1;
}

CMD:drogteszt(playerid, params[])
{
	new player;
	new string[128];
	if(!LMT(playerid, FRAKCIO_MENTO))
		return Msg(playerid, "Nem vagy ment�s!");
	if(sscanf(params, "r", player))
		return Msg(playerid, "Haszn�lata: /drogteszt [id/n�v]", false, COLOR_WHITE);
	if(player == INVALID_PLAYER_ID)
		return Msg(playerid, "Nincs ilyen j�t�kos");
	if(GetDistanceBetweenPlayers(playerid,player) > 3)
		return Msg(playerid, "� nincs a k�zeledben!");
	if(playerid == player)
		return Msg(playerid, "Magadat nem...");
	if((GetPlayerDistanceFromVehicle(playerid, GetClosestVehicle(playerid, false, 416)) > 5) && GetPlayerVirtualWorld(playerid) != 104)
		return Msg(playerid, "Nincs a k�zeledben ment�aut� vagy nem vagy k�rh�zban!");
	
	format(string, sizeof(string), "Drogtesztet szeretne csin�ltatni veled: %s | Elfogad�s: /accept drogteszt", ICPlayerName(playerid));
	SendClientMessage(player, COLOR_YELLOW, string);
	format(string, sizeof(string), "Drogtesztet szeretn�l csin�ltatni vele: %s", ICPlayerName(player));
	SendClientMessage(playerid, COLOR_YELLOW, string);
	Drogteszt[player] = playerid;
	
	return 1;
}
ALIAS(drogid6m):drogidom;
CMD:drogidom(playerid, params[])
{
	if((PlayerInfo[playerid][pDrogozott]-UnixTime) > 0)
	{
		new string[64];
		format(string, sizeof(string), "(( OOC: M�g %d percig mutathat� ki a drog. ))", ((PlayerInfo[playerid][pDrogozott] - UnixTime) / 60));
		SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
	}
	else
		return Msg(playerid, "(( OOC: Nem �llsz droghat�s alatt. ))", false, COLOR_GREY);
	return 1;
}

ALIAS(sz5ktet):szoktet;
CMD:szoktet(playerid, params[])
{
	if(IsACop(playerid)) return Msg(playerid, "Na persze...");
	
	new player;
	if(sscanf(params, "r", player)) return Msg(playerid, "Haszn�lata: /sz�ktet [id]", false, COLOR_WHITE);
	
	if(player == INVALID_PLAYER_ID) return Msg(playerid, "Nincs ilyen j�t�kos");
	if(playerid == player) return Msg(playerid, "Magadat???");
	if(GetDistanceBetweenPlayers(playerid, player) > 5.0) return Msg(playerid, "Nincs a k�zeledben");
	if(PlayerInfo[player][pJailed] == 0) return Msg(playerid, "� nincs b�rt�nben!");
	if(szallit[player] == NINCS) return Msg(playerid, "�t nem sz�ll�tj�k");
	if(GetVehicleModel(GetPlayerVehicleID(player)) != 427) return Msg(playerid, "� m�r meg van sz�ktetve!");
	if(MunkaFolyamatban[playerid] == 1) return Msg(playerid, "Nyugi m�r...");
	
	MunkaFolyamatban[playerid] = 1;
	TogglePlayerControllable(playerid, false);
	szallit[player] = NINCS;
	Freeze(player, 60000);
	MunkaTimerID[playerid]=SetTimerEx("Munkavege", 60000, false, "dd", playerid, M_SZOKTET);

	return 1;
}

ALIAS(sz1ll3t):szallit;
CMD:szallit(playerid, params[])
{
	if(!IsACop(playerid)) return Msg(playerid, "Csak rend�r�k tudnak �tsz�ll�tani!");
	if(!OnDuty[playerid]) return Msg(playerid, "Nem vagy szolg�latban!");
	
	new param[32], func[256];
	if(sscanf(params, "s[32]S()[256]", param, func)) return Msg(playerid, "Haszn�lata: /sz�ll�t [kezd/v�ge]", false, COLOR_WHITE);
	
	if(egyezik(param, "kezd"))
	{
		new player, oka[128];
		if(sscanf(func, "rs[256]", player, oka)) return Msg(playerid, "/sz�ll�t kezd [id] [oka]", false, COLOR_WHITE);
		if(player == INVALID_PLAYER_ID) return Msg(playerid, "Nincs ilyen j�t�kos.");
		if(playerid == player) return Msg(playerid, "Magadat hov� sz�ll�tan�d?");
		if(PlayerInfo[player][pJailed] <= 10 && PlayerInfo[player][pJailed] >= 13) return Msg(playerid, "� nincs b�rt�nben!");
		if(PlayerInfo[player][pJailTime] / 60 <= 10) return Msg(playerid, "Neki m�r kevesebb mint 10 perce van!");
		if(szallit[player] != NINCS) return Msg(playerid, "�t m�r sz�ll�tj�k!");
		if(szallitasz[playerid]) return Msg(playerid, "Te m�r sz�ll�tasz!");
		if(!IsAt(playerid, IsAt_szallitHely)) return Msg(playerid, "Itt nem tudsz sz�ll�tani!");
		if(!IsPlayerInAnyVehicle(playerid)) return Msg(playerid, "Nem vagy kocsiban!");
		if(GetVehicleModel(GetPlayerVehicleID(playerid)) != 427) return Msg(playerid, "Ezzel a kocsival nem tudsz sz�ll�tani!");
		
		cella[playerid] = szabadCella();
		cella[player] = cella[playerid];
		if(szabadCella() == NINCS) return Msg(playerid, "Nincs szabad hely az Alcatrazba! Nem tudsz sz�ll�tani!");
		
		new rang = PlayerInfo[playerid][pRank];
		if(LMT(playerid, FRAKCIO_SCPD) && rang >= 5) // LSPD 10
		{
			if(PlayerInfo[player][pJailed] != 10) return Msg(playerid, "� nem a ti b�rt�n�t�kben van!");
		}
		else if(LMT(playerid, FRAKCIO_SFPD) && rang >= 5) // SHERIFF 11
		{
			if(PlayerInfo[player][pJailed] != 11) return Msg(playerid, "� nem a ti b�rt�n�t�kben van!");
		}
		else if(LMT(playerid, FRAKCIO_KATONASAG) && rang >= 5) // KATONAS�G 12
		{
			// Mindenhonnan tud sz�ll�tani // lesz m�g valami csak sietek munk�ba, k�vi resi
		}
		else if(LMT(playerid, FRAKCIO_FBI)) // FBI 13
		{
			// Mindenhonnan tud sz�ll�tani // lesz m�g valami csak sietek munk�ba, k�vi resi
		}
		else
			return Msg(playerid, "Te nem tudsz sz�ll�tani!");
		
		CopMsgFormat(TEAM_BLUE_COLOR, "** %s %s elkezdte sz�ll�tani %s rabot az Alcatrazba! **", ICPlayerName(playerid), PlayerInfo[playerid][pRank], ICPlayerName(player));
		CopMsgFormat(TEAM_BLUE_COLOR, "** Oka: %s **", oka);
		SendClientMessage(player, TEAM_BLUE_COLOR, "Elkezdtek �tsz�ll�tani az Alcatraz fegyenctelepre!");
		SendClientMessageToAll(TEAM_BLUE_COLOR, "** Egy rabot elkezdtek �tsz�ll�tani az Alcatraz fegyenctelepre! **");
		szallit[player] = playerid;
		szallitasz[playerid] = true;
				
		CellaInfo[cella[playerid]][cId] = player;
		CellaInfo[cella[playerid]][cVan] = true;
		SetPlayerInterior(player, 0);
		SetPlayerVirtualWorld(player, 0);
		PutPlayerInVehicle(player, GetPlayerVehicleID(playerid), 3);
	}
	if(egyezik(param, "v�ge") || egyezik(param, "vege"))
	{
		new player;
		if(sscanf(func, "r", player)) return Msg(playerid, "Haszn�lata: /sz�ll�t v�ge [id]");
		if(player == INVALID_PLAYER_ID) return Msg(playerid, "Ilyen j�t�kos nem l�tezik");
		
		if(szallit[player] == NINCS) return Msg(playerid, "�t nem sz�ll�tod!");
		
		if(!PlayerToPoint(5.0, playerid, 215.050, 1862.741, 13.140)) return Msg(playerid, "Itt nem tudod leadni!");
		
		PlayerInfo[player][pJailed] = 14;
		SetPlayerInterior(player, 0);
		SetPlayerVirtualWorld(player, 126, "jail14");
		Freeze(player, 5000);
		SetPlayerPos(player, fortCellak[cella[playerid]][0], fortCellak[cella[playerid]][1], fortCellak[cella[playerid]][2]);
		SetPlayerSpecialAction(player, SPECIAL_ACTION_NONE);
		
		CopMsgFormat(TEAM_BLUE_COLOR, "** %s lesz�ll�totta %s rabot az Alcatrazba! **", ICPlayerName(playerid), ICPlayerName(player));
		SendClientMessage(player, TEAM_BLUE_COLOR, "�tsz�ll�tottak!");
		SendClientMessageToAll(TEAM_BLUE_COLOR, "** A rabot �tsz�ll�tott�k az Alcatraz fegyenctelepre! **");
		szallit[player] = NINCS;
		szallitasz[playerid] = false;
	}
	
	return 1;
}

ALIAS(fi):figyelem;
CMD:figyelem(playerid, params[])
{
	if(!LMT(playerid, FRAKCIO_KATONASAG)) return Msg(playerid, "Te nem vagy katona");
	if(!PlayerToPoint(5, playerid, 1339.330, 1511.309, 14.990)) return Msg(playerid, "Itt nem tudod haszn�lni!");
	
	new uzenet[256];
	if(sscanf(params, "s[256]", uzenet)) return Msg(playerid, "Haszn�lata: /fi [�zenet]", false, COLOR_WHITE);
	
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(PlayerInfo[i][pJailed] == 14)
			SendFormatMessage(i, COLOR_LIGHTRED, "** [Alcatraz] %s **", uzenet);
	}
	SendFormatMessage(playerid, COLOR_LIGHTRED, "** [Alcatraz] %s **", uzenet);

	return 1;
}

CMD:udvar(playerid, params[])
{
	if(!LMT(playerid, FRAKCIO_KATONASAG)) return Msg(playerid, "Te nem vagy katona!");
	if(!PlayerToPoint(5, playerid, 1339.330, 1511.309, 14.990)) return Msg(playerid, "Itt nem tudod haszn�lni!");
	
	new param[32];
	if(sscanf(params, "s[32]", param)) return Msg(playerid, "Haszn�lata: /udvar [nyit/z�r]", false, COLOR_WHITE);
	
	if(egyezik(param, "nyit"))
	{
		MoveDynamicObject(audvar, 1382.17554, 1503.19678, 13.9860, 1);

		CopMsgFormat(COLOR_LIGHTRED, "** [Alcatraz] Figyelem %s kinyitotta az udvar ajtaj�t! **", ICPlayerName(playerid));
		for(new i = 0; i < MAX_PLAYERS; i++)
		{
			if(PlayerInfo[i][pJailed] == 14)
				SendClientMessage(playerid, COLOR_LIGHTRED, "** [Alcatraz] Figyelem! Az udvarra a kij�r�s enged�lyezett! **");
		}
	}
	else if(egyezik(param, "z�r") || egyezik(param, "zar"))
	{
		MoveDynamicObject(audvar, 1382.17554, 1503.19678, 10.97000, 1);
		
		CopMsgFormat(COLOR_LIGHTRED, "** [Alcatraz] Figyelem %s bez�rta az udvar ajtaj�t! **", ICPlayerName(playerid));
	}
	
	return 1;
}

CMD:cella(playerid, params[])
{
	if(!LMT(playerid, FRAKCIO_KATONASAG)) return Msg(playerid, "Te nem vagy katona!");
	if(!PlayerToPoint(5, playerid, 1339.330, 1511.309, 14.990)) return Msg(playerid, "Itt nem tudod haszn�lni!");
	
	new param[32];
	if(sscanf(params, "s[32]", param)) return Msg(playerid, "Haszn�lata: /cella [nyit/z�r]", false, COLOR_WHITE);
	
	if(egyezik(param, "nyit"))
	{
		for(new i=0; i<sizeof(fortKapuBal); i++)
		{
			MoveDynamicObject(fortKapuBalObj[i], fortKapuBal[i][0]-1.664, fortKapuBal[i][1], fortKapuBal[i][2], 1);
		}
		for(new i=0; i<sizeof(fortKapuJobb); i++)
		{
			MoveDynamicObject(fortKapuJobbObj[i], fortKapuJobb[i][0]+1.664, fortKapuJobb[i][1], fortKapuJobb[i][2], 1);
		}
		
		CopMsgFormat(COLOR_LIGHTRED, "** [Alcatraz] Figyelem %s kinyitotta a cell�k ajtaj�t! **", ICPlayerName(playerid));
	}
	else if(egyezik(param, "z�r") || egyezik(param, "zar"))
	{
		for(new i=0; i<sizeof(fortKapuBal); i++)
		{
			MoveDynamicObject(fortKapuBalObj[i], fortKapuBal[i][0], fortKapuBal[i][1], fortKapuBal[i][2], 1);
		}
		for(new i=0; i<sizeof(fortKapuJobb); i++)
		{
			MoveDynamicObject(fortKapuJobbObj[i], fortKapuJobb[i][0], fortKapuJobb[i][1], fortKapuJobb[i][2], 1);
		}
		
		CopMsgFormat(COLOR_LIGHTRED, "** [Alcatraz] Figyelem %s bez�rta a cell�k ajtaj�t! **", ICPlayerName(playerid));
	}
	
	return 1;
}

CMD:bmunka(playerid, params[])
{
	if(PlayerInfo[playerid][pJailed] != 14) return Msg(playerid, "Nem vagy az Alcatraz b�rt�nben!");
	if(!IsAt(playerid, IsAt_bMunkaHely)) return Msg(playerid, "Itt nem tudod elkezdeni egyik munk�t sem");
	
	new param[32];
	if(sscanf(params, "s[32]", param)) return Msg(playerid, "Haszn�lata: /bmunka [takar�t�/b�ny�sz/felmond/segitseg]");
	
	//if(PlayerInfo[playerid][pBmunka] != NINCS) SendFormatMessage(playerid, COLOR_RED, "M�r van munk�d: %s", PlayerInfo[playerid][pBmunka]);
	
	if(egyezik(param, "takar�t�") || egyezik(param, "takarito"))
	{
		Msg(playerid, "Elkezdted a munk�t: Takar�t�");
			
		PlayerInfo[playerid][pBmunka] = MUNKA_BTAKARITO;
		Msg(playerid, "Felvetted a Takar�t� munk�t! Kezdj el takar�tani!");
		
		RemovePlayerAttachedObject(playerid, ATTACH_SLOT_SISAK);
		
		btakaritok = random(sizeof(bTakarito));
		SetPlayerCheckpoint(playerid, bTakarito[btakaritok][0], bTakarito[btakaritok][1], bTakarito[btakaritok][2], 1.0);
	}
	else if(egyezik(param, "b�ny�sz") || egyezik(param, "banyasz"))
	{
		Msg(playerid, "Elkezdted a munk�t: B�ny�sz");
			
		PlayerInfo[playerid][pBmunka] = MUNKA_BBANYASZ;
		Msg(playerid, "Felvetted a B�ny�sz munk�t! Kezdj el b�ny�szni!");
		
		SetPlayerAttachedObject(playerid, ATTACH_SLOT_SISAK, 1636, 1, 0.125999, -0.119999, -0.129999, 0.000000, -67.199996, 0.000000);
		
		bbanyaszk = random(sizeof(bBanyasz));
		SetPlayerCheckpoint(playerid, bBanyasz[bbanyaszk][0], bBanyasz[bbanyaszk][1], bBanyasz[bbanyaszk][2], 3);
	}
	else if(egyezik(param, "felmond"))
	{
		PlayerInfo[playerid][pBmunka] = NINCS;
		return Msg(playerid, "Felmondt�l!");
	}
	else if(egyezik(param, "help") || egyezik(param, "seg�ts�g") || egyezik(param, "segitseg"))
	{
		Msg(playerid, "========== [ Takar�t� ] ==========", false, COLOR_WHITE);
		Msg(playerid, "HendRoox ne felejtsd el kit�lteni! :D", false, COLOR_WHITE);
		Msg(playerid, "========== [  B�ny�sz ] ==========", false, COLOR_WHITE);
		Msg(playerid, "HendRoox ne felejtsd el kit�lteni! :D", false, COLOR_WHITE);
	}
	else
		return Msg(playerid, "Nincs ilyen parancs!");
	
	
	return 1;
}

CMD:rabok(playerid, params[])
{
	if(!IsACop(playerid) && !Admin(playerid, 1)) return Msg(playerid, "Nem vagy rendv�delmi szervezet tagja.");
	
	// LSPD SHERIFF KATONAS�G FBI
	new param[32];
	if(sscanf(params, "s[32]", param)) return Msg(playerid, "Haszn�lata: /rabok [LSPD / FBI / Sheriff / Katonas�g / Fegyenctelep]");
	SendClientMessage(playerid, COLOR_GREEN, "=====[ Rablista ]=====");
	new rabok, string[256];
	if(egyezik(param, "lspd"))
	{
		SendClientMessage(playerid, COLOR_LIGHTBLUE, "========== LSPD ==========");
        for(new p = 0; p < MAX_PLAYERS; p++)
        {
            if(PlayerInfo[p][pJailed] == 10 && PlayerInfo[p][pJailTime] > 0)
            {
                if(PlayerInfo[p][pOvadek] > 0)
	                format(string, sizeof(string), "N�v: %s | Ido: %dmp(%dp) | �vad�k:%s | Oka: %s", ICPlayerName(p), PlayerInfo[p][pJailTime], floatround(float(PlayerInfo[p][pJailTime] / 60)), FormatNumber( PlayerInfo[p][pOvadek], 0, ',' ), PlayerInfo[p][pJailOK]);
				else
				    format(string, sizeof(string), "N�v: %s | Ido: %dmp(%dp) | �vad�k:Nincs | Oka: %s", ICPlayerName(p), PlayerInfo[p][pJailTime], floatround(float(PlayerInfo[p][pJailTime] / 60)), PlayerInfo[p][pJailOK]);
                SendClientMessage(playerid, COLOR_YELLOW, string);
				rabok++;
            }
        }
		SendFormatMessage(playerid, COLOR_LIGHTBLUE, "======= LSPD (%ddb) =======", rabok);
	}
	else if(egyezik(param, "sheriff"))
	{
		SendClientMessage(playerid, COLOR_LIGHTBLUE, "========== Sheriff ==========");
        for(new p = 0; p < MAX_PLAYERS; p++)
        {
            if(PlayerInfo[p][pJailed] == 11 && PlayerInfo[p][pJailTime] > 0)
            {
                if(PlayerInfo[p][pOvadek] > 0)
	                format(string, sizeof(string), "N�v: %s | Ido: %dmp(%dp) | �vad�k:%s | Oka: %s", ICPlayerName(p), PlayerInfo[p][pJailTime], floatround(float(PlayerInfo[p][pJailTime] / 60)), FormatNumber( PlayerInfo[p][pOvadek], 0, ',' ), PlayerInfo[p][pJailOK]);
				else
				    format(string, sizeof(string), "N�v: %s | Ido: %dmp(%dp) | �vad�k:Nincs | Oka: %s", ICPlayerName(p), PlayerInfo[p][pJailTime], floatround(float(PlayerInfo[p][pJailTime] / 60)), PlayerInfo[p][pJailOK]);
                SendClientMessage(playerid, COLOR_YELLOW, string);
				rabok++;
            }
        }
		SendFormatMessage(playerid, COLOR_LIGHTBLUE, "======= Sheriff (%ddb) =======", rabok);
	}
	else if(egyezik(param, "katonasag") || egyezik(param, "katonas�g"))
	{
		SendClientMessage(playerid, COLOR_LIGHTBLUE, "========== Katonas�g ==========");
        for(new p = 0; p < MAX_PLAYERS; p++)
        {
            if(PlayerInfo[p][pJailed] == 12 && PlayerInfo[p][pJailTime] > 0)
            {
                if(PlayerInfo[p][pOvadek] > 0)
	                format(string, sizeof(string), "N�v: %s | Ido: %dmp(%dp) | �vad�k:%s | Oka: %s", ICPlayerName(p), PlayerInfo[p][pJailTime], floatround(float(PlayerInfo[p][pJailTime] / 60)), FormatNumber( PlayerInfo[p][pOvadek], 0, ',' ), PlayerInfo[p][pJailOK]);
				else
				    format(string, sizeof(string), "N�v: %s | Ido: %dmp(%dp) | �vad�k:Nincs | Oka: %s", ICPlayerName(p), PlayerInfo[p][pJailTime], floatround(float(PlayerInfo[p][pJailTime] / 60)), PlayerInfo[p][pJailOK]);
                SendClientMessage(playerid, COLOR_YELLOW, string);
				rabok++;
            }
        }
		SendFormatMessage(playerid, COLOR_LIGHTBLUE, "======= Katonas�g (%ddb) =======", rabok);
	}
	else if(egyezik(param, "fbi"))
	{
		SendClientMessage(playerid, COLOR_LIGHTBLUE, "========== FBI ==========");
        for(new p = 0; p < MAX_PLAYERS; p++)
        {
            if(PlayerInfo[p][pJailed] == 13 && PlayerInfo[p][pJailTime] > 0)
            {
                if(PlayerInfo[p][pOvadek] > 0)
	                format(string, sizeof(string), "N�v: %s | Ido: %dmp(%dp) | �vad�k:%s | Oka: %s", ICPlayerName(p), PlayerInfo[p][pJailTime], floatround(float(PlayerInfo[p][pJailTime] / 60)), FormatNumber( PlayerInfo[p][pOvadek], 0, ',' ), PlayerInfo[p][pJailOK]);
				else
				    format(string, sizeof(string), "N�v: %s | Ido: %dmp(%dp) | �vad�k:Nincs | Oka: %s", ICPlayerName(p), PlayerInfo[p][pJailTime], floatround(float(PlayerInfo[p][pJailTime] / 60)), PlayerInfo[p][pJailOK]);
                SendClientMessage(playerid, COLOR_YELLOW, string);
				rabok++;
            }
        }
		SendFormatMessage(playerid, COLOR_LIGHTBLUE, "======= FBI (%ddb) =======", rabok);
	}
	else if(egyezik(param, "fegyenctelep") || egyezik(param, "alcatraz"))
	{
		SendClientMessage(playerid, COLOR_LIGHTBLUE, "========== Alcatraz ==========");
        for(new p = 0; p < MAX_PLAYERS; p++)
        {
            if(PlayerInfo[p][pJailed] == 14 && PlayerInfo[p][pJailTime] > 0)
            {
                if(PlayerInfo[p][pOvadek] > 0)
	                format(string, sizeof(string), "N�v: %s | Ido: %dmp(%dp) | �vad�k:%s | Oka: %s", ICPlayerName(p), PlayerInfo[p][pJailTime], floatround(float(PlayerInfo[p][pJailTime] / 60)), FormatNumber( PlayerInfo[p][pOvadek], 0, ',' ), PlayerInfo[p][pJailOK]);
				else
				    format(string, sizeof(string), "N�v: %s | Ido: %dmp(%dp) | �vad�k:Nincs | Oka: %s", ICPlayerName(p), PlayerInfo[p][pJailTime], floatround(float(PlayerInfo[p][pJailTime] / 60)), PlayerInfo[p][pJailOK]);
                SendClientMessage(playerid, COLOR_YELLOW, string);
				rabok++;
            }
        }
		SendFormatMessage(playerid, COLOR_LIGHTBLUE, "======= Alcatraz (%ddb) =======", rabok);
	}
	return 1;
}

CMD:engedgov(playerid, params[])
{
	if(!Admin(playerid, 1)) return 1;
	new player;
	if(sscanf(params, "u", player))
		return SendClientMessage(playerid, COLOR_WHITE, "Haszn�lat: /engedgov [j�t�kos]");
		
	if(!IsACop(player)) return Msg(playerid, "Csak rend�r�knek adhatsz gov enged�lyt!");
	
	GovEngedely[player] = true;
	
	Msg(playerid, "Adt�l neki enged�lyt hogy govoljon!");
	Msg(player, "Egy admin enged�lyt adott a govol�sra!");
	
	return 1;
}

CMD:tiltgov(playerid, params[])
{
	if(!Admin(playerid, 1)) return 1;
	new player;
	if(sscanf(params, "u", player))
		return SendClientMessage(playerid, COLOR_WHITE, "Haszn�lat: /tiltgov [j�t�kos]");
		
	if(!IsACop(player)) return Msg(playerid, "Csak rend�r�kt�l vehetsz el gov enged�lyt!");
	
	GovEngedely[player] = false;
	
	Msg(playerid, "Elvetted az enged�ly�t hogy govoljon!");
	Msg(player, "Elvett�k az enged�lyed hogy govolj!");
	
	return 1;
}

CMD:customhud(playerid, params[])
{
	new mit[128];
	new mire;
	if(sscanf(params, "s[128]d", mit, mire))
	{
		Msg(playerid, "/customhud [opcio] [0/1]");
		Msg(playerid, "Opci�: fegyver/weapon - a GTA:SA/models/txd mapp�ban kell lennie egy");
		Msg(playerid, "Opci�: fegyver/weapon - class_custom_weapons.txd f�jlnak (amit te csin�lsz)");
		Msg(playerid, "Opci�: fegyver/weapon - A benne tal�lhat� f�jloknak 256x256os m�ret�nek kell lenni�k");
		Msg(playerid, "Opci�: fegyver/weapon - �s a nev�k a fegyver idj�vel kell megegyezzen (+c)");
		Msg(playerid, "Opci�: fegyver/weapon - pl: 30c - AK47, 0c - �k�l stb..");
		Msg(playerid, "Opci�: fegyver/weapon - FIGYELEM!! Ha egy fegyverre nem raksz icont nem fog megjelenni!");
		
		return 1;
	}
	
	if(!egyezik(mit, "fegyver") && !egyezik(mit, "weapon")) return Msg(playerid, "Egyenl�re csak ez az 1 opci� van!");
	
	if(mire < 0 || mire > 1) return Msg(playerid, "0 vagy 1!");
	
	if(egyezik(mit, "fegyver") || egyezik(mit, "weapon"))
	{
		PlayerInfo[playerid][pCustomHudWeapon] = mire;
		
		if(mire) Msg(playerid, "Bekapcsoltad a custom iconokat a fegyverekre!");
		else Msg(playerid, "Kikapcsoltad a custom iconokat a fegyverekre!");
		
		DeleteWeaponHud(playerid);
		
		return 1;
	}
	
	return 1;
}