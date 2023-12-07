#if defined __game_system_commands
	#endinput
#endif
#define __game_system_commands

/****************************
 *           cmdk           *
 *    á: 1   ó: 4   ú: 7    *
 *    é: 2   ö: 5   ü: 8    *
 *    í: 3   õ: 6   u: 9    *  
 ****************************/
CMD:editint(playerid, params[])
{
	if (!IsScripter(playerid))
		return 1;
	
	new number, sub[32];
	if(sscanf(params, "is[32]", number, sub))
	{
		Msg(playerid, "Használata: /editint [szám] [bejárat / spawn / camstart / camend]");
		return 1;
	}
	
	if(number < 0 || number >= IntekSzama())
	{
		Msg(playerid, "Érvénytelen interior szám!");
		return 1;
	}
	
	if(egyezik(sub, "bejarat") || egyezik(sub, "bejárat"))
	{
		new Float:pos[3];
		GetPlayerPos(playerid, ArrExt(pos));
		IntInfo[number][iExitX] = pos[0];
		IntInfo[number][iExitY] = pos[1];
		IntInfo[number][iExitZ] = pos[2];
		IntInfo[number][iNumber] = GetPlayerInterior(playerid);
		OnIntsUpdate();
		Msg(playerid, "Interior bejárata sikeresen szerkesztve! (mentéshez: /saveint)");
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
		Msg(playerid, "Interior spawn sikeresen szerkesztve! (mentéshez: /saveint)");
	}
	else if(egyezik(sub, "camstart"))
	{
		GetPlayerCameraPos(playerid, ArrExt(IntInfo[number][iCamStartPos]));
		GetPlayerCameraLookAt(playerid, ArrExt(IntInfo[number][iCamStartLookAt]));
		OnIntsUpdate();
		Msg(playerid, "Interior camstart sikeresen szerkesztve! (mentéshez: /saveint)");
	}
	else if(egyezik(sub, "camend"))
	{
		GetPlayerCameraPos(playerid, ArrExt(IntInfo[number][iCamEndPos]));
		GetPlayerCameraLookAt(playerid, ArrExt(IntInfo[number][iCamEndLookAt]));
		OnIntsUpdate();
		Msg(playerid, "Interior camend sikeresen szerkesztve! (mentéshez: /saveint)");
	}
	
	return 1;
}

ALIAS(ad4):ado;
CMD:ado(playerid, params[])
{
	new param[32];
	new func[256];
	
	if(sscanf(params, "s[32]S()[256]", param, func)) return Msg(playerid, "/adó [befizet / automata]");
	if(egyezik(param,"befizet"))
	{
		
		if(PlayerInfo[playerid][pAdokIdo] >= 10) return Msg(playerid, "Most vallottad be az adódat, legközelebb a következo fizetés után tudod!");
		if(!PlayerToPoint(3.0, playerid, 361.829,173.766, 1008.382, 0, 3)) //Városháza inti szembe földszint
		{
			SetPlayerCheckpoint(playerid, 361.829,173.766, 1008.382, 3.0);
			Msg(playerid, "Nem vagy a városháza földszintjén a szemben lévo asztalnál!");
			return 1;
		}
		
		new osszeg = PlayerInfo[playerid][pAdokOsszeg];
		
		if(!BankkartyaFizet(playerid, PlayerInfo[playerid][pAdokOsszeg]))
		{
			return SendFormatMessage(playerid, COLOR_RED, "Nincs ennyi pénzed, %sFt kell! Kérlek gyüjtsd össze mihamarabb a pénzt!", FormatNumber(osszeg, 0, ',' ));
		}
		
		PlayerInfo[playerid][pAdokIdo] = 10;
		FrakcioSzef(FRAKCIO_ONKORMANYZAT, osszeg, 57);
		SendClientMessage(playerid, COLOR_LIGHTGREEN, "Sikeresen befizetted az adót! A következot 10 fizetésen belül kell!");
		
		new navstring[128];
		format(navstring, sizeof(navstring), "<< [ADÓBEVALLÁS] %s bevallotta az adóját %sFt-t >>", PlayerName(playerid), FormatNumber(osszeg, 0, ',' ));
		SendMessage(SEND_MESSAGE_FRACTION, navstring, COLOR_RED, FRAKCIO_SCPD);
		
		PlayerInfo[playerid][pAdokOsszeg] = 0;
	}
	if(egyezik(param,"automata"))
	{
		if(PlayerInfo[playerid][pAdoAuto])
			PlayerInfo[playerid][pAdoAuto]=false,Msg(playerid,"Kikapcsoltad az automatikus adó fizetésedet!");
		else
			PlayerInfo[playerid][pAdoAuto]=true,Msg(playerid,"Automatikusra állítottad az adó fizetésedet!");
		
	}
	return 1;
}
CMD:engedtv(playerid, params[])
{
	if(!Admin(playerid, 1)) return 1;
	
	if(Tvenged[playerid])
	{
		Tvenged[playerid]=false;
		Msg(playerid, "Tíltottad hogy a kisebb adminok tv-zenek téged");
	}
	else
	{
		Msg(playerid, "Engedélyezted hogy a kisebb adminok tv-zenek téged");
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
		return SendClientMessage(playerid, COLOR_GRAD2, "Használata: /tvengedély [Játékos] [IRL óra]");

	
		
	GetPlayerName(nev, playername, sizeof(playername));
	GetPlayerName(playerid, sendername, sizeof(sendername));

	if(Adminseged[nev] != 1 && !IsAS(nev)) return SendClientMessage(playerid, COLOR_YELLOW, "Ez a játékos nem AS!");
	
	if(ido < 1) return Msg(playerid, "Az idõ túl kicsi!");
	
	if(TvEngedely[nev] < UnixTime)
	{
		
		format(string, sizeof(string), "<< Engedélyezted a TVzést %s -nak %d órára>>", playername,ido);
		SendClientMessage(playerid, COLOR_YELLOW, string);
		format(string, sizeof(string), "<< Admin %s engedélyezte neked a TVzést %d órára! >>", AdminName(playerid),ido);
		SendClientMessage(nev, COLOR_YELLOW, string);
		format(string, sizeof(string), "<< Admin %s engedélyezte %s -nak a TVzést %d órára! >>", AdminName(playerid), playername,ido);
		ABroadCast(COLOR_LIGHTRED, string, 1);
		TvEngedely[nev] = (ido*3600)+UnixTime;
	}
	else
	{
		format(string, sizeof(string), "<< Tiltottad a TVzést neki: %s! >>", playername);
		SendClientMessage(playerid, COLOR_YELLOW, string);
		format(string, sizeof(string), "<< Admin %s tiltotta neked a TVzést! >>", AdminName(playerid));
		SendClientMessage(nev, COLOR_YELLOW, string);
		format(string, sizeof(string), "<< Admin %s tiltotta neki: %s a TVzést! >>", AdminName(playerid), playername);
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
			Msg(playerid, "Használat: /cheat [játékos név / ID / BID] [oka]", false, COLOR_LIGHTBLUE);
			Msg(playerid, "Ha úgy látod, hogy valaki csal, ezzel a paranccsal jelezheted nekünk!", false, COLOR_LIGHTBLUE);
			Msg(playerid, "A parancs használatához nem szükséges online adminisztrátor, késõbb is utána tudunk nézni!", false, COLOR_LIGHTBLUE);
			Msg(playerid, "Figyelem! A paranccsal történõ visszaélést tiltással jutalmazzuk!", false, COLOR_LIGHTBLUE);
			Msg(playerid, "Ezért csak abban az esetben jelezd, ha valóban úgy érzed, hogy csalót láttál!", false, COLOR_LIGHTBLUE);
			Msg(playerid, "==========[ /cheat ]==========", false, COLOR_LIGHTBLUE);
			return 1;
		}
		
		target = FindPlayerByBID(target);
	}
	
	if(target == INVALID_PLAYER_ID)
		return Msg(playerid, "Nincs ilyen játékos");
	
	if(strlen(reason) < 10)
		return Msg(playerid, "Ennél azért bõvebben... de maximum 128 karakter!");
	
	if(PlayerInfo[playerid][pReportCooldown] > UnixTime)
		return Msg(playerid, "Ilyen gyorsan nem jelenthetsz! Türelem!");
	
	PlayerInfo[playerid][pReportPlayer] = target;
	strmid(PlayerInfo[playerid][pReportReason], reason, 0, strlen(reason), 128);
	
	ReportPlayer(playerid);
	return 1;
}

CMD:walk(playerid, params[])
{
	new id;
	if(Animban[playerid]) return Msg(playerid, "Animban nem mész sehova. :) /kúszás");
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
		default: Msg(playerid,"Használat: /walk [1-13]");
	}
	SendFormatMessage(playerid, COLOR_WHITE, "Sétálási stílusod: %d", id);
	return 1;
}

CMD:devmode(playerid, params[])
{
	if(!devmode || !IsScripter(playerid))
		return 1;
		
	new cmd[32], subcmd[128];
	if(sscanf(params, "s[32] s[128]", cmd, subcmd))
	{
		Msg(playerid, "Használat: /devmode [parancs]");
		//Msg(playerid, "Parancsok: setNextCrate");
		return 1;
	}
	
	return 1;
}

ALIAS(b4nuszok):bonuszok;
CMD:bonuszok(playerid, params[])
{
	Msg(playerid, "===[ Bónuszok ]===", false, COLOR_LIGHTBLUE);
	
	// kamat
	new Float:kamat, kamatDb;
	
	new Float:premiumKamat = GetInterestFromPremiumPack(playerid);
	if(premiumKamat > 0)
	{
		SendFormatMessage(playerid, COLOR_WHITE, "Kamat: %.2f százalék - forrás: prémium", premiumKamat + FLOATFIX);
		kamat += premiumKamat;
		kamatDb++;
	}
	
	if(PremiumInfo[playerid][pKamat] > 0 && PremiumInfo[playerid][pKamatIdo] > 0)
	{
		SendFormatMessage(playerid, COLOR_WHITE, "Kamat: %.2f százalék (még %d fizetésig) - forrás: kredit", PremiumInfo[playerid][pKamat] + FLOATFIX, PremiumInfo[playerid][pKamatIdo]);
		kamat += PremiumInfo[playerid][pKamat];
		kamatDb++;
	}
	
	#if defined SYSTEM_BONUS
	if(BonusInfo[playerid][B:Kamat] > 0 && BonusInfo[playerid][B:KamatIdo] > 0)
	{
		SendFormatMessage(playerid, COLOR_WHITE, "Kamat: %.2f százalék (még %d fizetésig) - forrás: bónusz", BonusInfo[playerid][B:Kamat] + FLOATFIX, BonusInfo[playerid][B:KamatIdo]);
		kamat += BonusInfo[playerid][B:Kamat];
		kamatDb++;
	}
	#endif
	
	if(kamat == 0)
		SendClientMessage(playerid, COLOR_WHITE, "Kamat: nincs");
	else if(kamatDb > 1)
		SendFormatMessage(playerid, COLOR_WHITE, "Kamat összesen: %.2f százalék", kamat);
	
	// ado
	new Float:ado, adoDb;
	if(PremiumInfo[playerid][pAdo] > 0 && PremiumInfo[playerid][pAdoIdo] > 0)
	{
		SendFormatMessage(playerid, COLOR_WHITE, "Adócsökkentés: %.2f százalék (még %d fizetésig) - forrás: kredit", PremiumInfo[playerid][pAdo] + FLOATFIX, PremiumInfo[playerid][pAdoIdo]);
		ado += PremiumInfo[playerid][pAdo];
		adoDb++;
	}
	
	#if defined SYSTEM_BONUS
	if(BonusInfo[playerid][B:Ado] > 0 && BonusInfo[playerid][B:AdoIdo] > 0)
	{
		SendFormatMessage(playerid, COLOR_WHITE, "Adócsökkentés: %.0f százalék (még %d fizetésig) - forrás: bónusz", BonusInfo[playerid][B:Ado] + FLOATFIX, BonusInfo[playerid][B:AdoIdo]);
		ado += BonusInfo[playerid][B:Ado];
		adoDb++;
	}
	#endif
	
	if(ado == 0)
		SendClientMessage(playerid, COLOR_WHITE, "Adócsökkentés: nincs");
	else if(adoDb > 1)
		SendFormatMessage(playerid, COLOR_WHITE, "Adócsökkentés összesen: %.0f százalék", ado);
		
	return 1;
}

CMD:lemond(playerid, params[])
{
	if(!LMT(playerid, FRAKCIO_MENTO)) return Msg(playerid, "Csak mentõs használhatja!");
	if(MentoSegit[playerid] != 0) 
	{
		SendClientMessage(playerid,COLOR_YELLOW,"Újra elérhetõ vagy!");
		MentoSegit[playerid] = 0;
	}
	else
		SendClientMessage(playerid,COLOR_YELLOW,"Eddig is elérhetõ voltál!"),MentoSegit[playerid] = 0;

	return 1;
}
CMD:fkmotd(playerid, params[])
{
	if(!PlayerInfo[playerid][pLeader] && !IsScripter(playerid) && !IsAmos(playerid)) return Msg(playerid, "Nem vagy leader");
	new frakcio = PlayerInfo[playerid][pMember];
	new felhivas[32];
	if(sscanf(params, "s[32]", felhivas))
		return SendClientMessage(playerid, COLOR_WHITE, "Használat: /fkmotd [Üzeneted]");

	SendRadioMessageFormat(frakcio, COLOR_YELLOW, "<<< Frakció felhívás: %s >>>", felhivas);

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
		Msg(playerid, "/robhely [funkció]");
		Msg(playerid, "Funkciók: [Go | uj | mod | üres | töröl | közel | tulaj | biztonság]");
		Msg(playerid, "mod= módósít");
		return 1;
	}
	if(egyezik(param, "go") || egyezik(param, "menj"))
	{
		new robhelyid;
		if(sscanf(func, "d", robhelyid)) return Msg(playerid, "/robhely go [ROBHELY ID]");
		if(robhelyid < 0 || robhelyid > MAX_BANKROBHELY) return Msg(playerid, "Hibás ROBHELY ID.");
		SetPlayerPos(playerid, ROBHELY[robhelyid][roPosX], ROBHELY[robhelyid][roPosY], ROBHELY[robhelyid][roPosZ]);
		SendFormatMessage(playerid,  COLOR_LIGHTGREEN, "* Teleportáltál az robhely-hez. (ID: %d - Koordínáta: X: %f | Y: %f | Z: %f) ", robhelyid,ROBHELY[robhelyid][roPosX], ROBHELY[robhelyid][roPosY], ROBHELY[robhelyid][roPosZ]);
	}
    if(egyezik(param, "tulaj"))
    {
        new ujtulaj[32], robhelyid;
        if(sscanf(func, "ds[32]",robhelyid, ujtulaj)) return Msg(playerid, "/robhely tulaj [robhelyid] [név]");
 
        if(!strlen(ujtulaj)) return Msg(playerid, "Fejbecsapjalak?");
        if(robhelyid < 0 || robhelyid > MAX_BANKROBHELY) return Msg(playerid, "Hibás ROBHELY ID.");
 
        SendFormatMessage(playerid,  COLOR_LIGHTGREEN, "* Széf: [%d] Régi tulaj: %s | Új tulaj: %s", robhelyid, ROBHELY[robhelyid][roTulaj], ujtulaj);
        format(ROBHELY[robhelyid][roTulaj], 32, "%s", ujtulaj);
        return 1;
    }
	if(egyezik(param, "lezárás") || egyezik(param, "zár") || egyezik(param, "close"))
	{
		
		new power, robhelyid;
		if(sscanf(func, "d",robhelyid,power)) return Msg(playerid, "/robhely zár [ROBHELYID]");
		
		if(ROBHELY[robhelyid][roLezarva] == 0)
		{
			ROBHELY[robhelyid][roLezarva] = 1;
			Msg(playerid, "ROBELY LEZÁRVA");
		}
		if(ROBHELY[robhelyid][roLezarva] == 1)
		{
			ROBHELY[robhelyid][roLezarva] = 0;
			Msg(playerid, "ROBELY KINYITVA");
		}
		SendFormatMessage(playerid,  COLOR_LIGHTGREEN, "* ID: %d Lezárva: %d", robhelyid,ROBHELY[robhelyid][roLezarva]);
	}
	if(egyezik(param, "biztonság") || egyezik(param, "biztonsag") || egyezik(param, "szint"))
	{
		
		new power, robhelyid;
		if(sscanf(func, "dd",robhelyid,power)) return Msg(playerid, "/robhely biztonság [ROBHELYID] [BIZTONSÁGI SZINT]");
		
		if(power < 0 || power > 5) return Msg(playerid, "Hibás BIZTONSÁGI SZINT");
		if(robhelyid < 0 || robhelyid > MAX_BANKROBHELY) return Msg(playerid, "Hibás ROBHELY ID.");
		ROBHELY[robhelyid][roBiztonsag] = power;
		SendFormatMessage(playerid,  COLOR_LIGHTGREEN, "* ID: %d Biztonság: %d", robhelyid,ROBHELY[robhelyid][roBiztonsag]);
	}
	if(egyezik(param, "help"))
	{
			if(IsScripter(playerid))
			{
				Msg(playerid,"Bankrablás poziciókat tudsz lerakni az object lerakás rendszeréhez hasonlatosan:");
				Msg(playerid,"/robhely go id - A megadott id-re rakott bankrablási pozicióra visz.");
				Msg(playerid,"/robhely uj [ls(1)/sf(2)] - A megadott típusban új bankrablási pozíciót helyez le. (Fontos, hogy ne keverd)");
				Msg(playerid,"/robhely vw - Ahogyan az objectek esetében is van, ennek is tudod a vw-jét állítani.");
				Msg(playerid,"/robhely mod - Ugyan az, mint az objectnél, a pozició módosítható!");
				Msg(playerid,"/robhely közel - Megmutatja a közeli ROBHELY-et!");
				Msg(playerid,"/robhely töröl - Törli ROBHELY-et!");
				Msg(playerid,"/robhely tulaj - Beállítja a tulajt (Pl: Bank)");
				Msg(playerid,"/robhely biztonság - Beállítja a biztonsági szintet (1-5)");
				return 1;
			}
			return 1;	
	}
	if(egyezik(param, "uj") || egyezik(param, "új"))
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
		
		if(id < 0 || id >= MAX_BANKROBHELY) return Msg(playerid, "Nincs üres hely!");

		new Float:X, Float:Y, Float:Z, Float:A;
		GetPlayerPos(playerid, X, Y, Z);
		GetPlayerFacingAngle(playerid, A);
		
		id=UresObject();
		if(id == NINCS) return Msg(playerid, "Nincs üres hely");

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

		if(tipus == 1) SendFormatMessage(playerid,  COLOR_LIGHTGREEN, "* BANKROB lerakva. (ID: %d - Típus: LS Koordínáta: X: %.2f | Y: %.2f | Z: %.2f | A: %.2f | VW: %d | INT: %d) ", id, ROBHELY[id][roPosX], ROBHELY[id][roPosY], ROBHELY[id][roPosZ], ROBHELY[id][roPosA], ROBHELY[id][roVw],ROBHELY[id][roInt]);
		if(tipus == 2) SendFormatMessage(playerid,  COLOR_LIGHTGREEN, "* BANKROB lerakva. (ID: %d - Típus: SF Koordínáta: X: %.2f | Y: %.2f | Z: %.2f | A: %.2f | VW: %d | INT: %d) ", id, ROBHELY[id][roPosX], ROBHELY[id][roPosY], ROBHELY[id][roPosZ], ROBHELY[id][roPosA], ROBHELY[id][roVw],ROBHELY[id][roInt]);
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
	if(egyezik(param, "töröl"))
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
		
		if(id < 0 || id >= MAX_BANKROBHELY) return Msg(playerid, "Hibás SORSZÁM ID.");

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
		SendFormatMessage(playerid,  COLOR_LIGHTGREEN, "Törölve ROBHELY: %d",id);
		
		SaveRobHelyek();
	}
	if(egyezik(param, "üres"))
	{
		new szamlalo;
		for(new r = 0; r < MAX_BANKROBHELY; r++)
		{
			if(ROBHELY[r][roRobId] == 0)
			{
				SendFormatMessage(playerid,  COLOR_LIGHTGREEN, "*Üres ROBHELY: %d ",r);
				szamlalo++;
				if(szamlalo > 6) return 1;
			}
		}
	}
	if(egyezik(param, "közel"))
	{
		SendClientMessage(playerid, COLOR_WHITE, "====[ Legközelebbi RobHely ]=====");
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

		if(legkozelebb == 5000.0) return Msg(playerid, "Nincs találat");

		SendFormatMessage(playerid, COLOR_LIGHTBLUE, "ID: %d TÍPUS: %d VW: %d INT: %d", kozel,ROBHELY[kozel][roLsVagySf],ROBHELY[kozel][roVw],ROBHELY[kozel][roInt]);
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
	if(!Admin(playerid, 1) && !IsAS(playerid)) return Msg(playerid, "Nem vagy Admin / Adminsegéd.");
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
	SendClientMessage(playerid, COLOR_LIGHTRED,"A szabályzatot a weboldalon találod!");
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
	SendClientMessage(playerid, COLOR_GREEN, "------------[ Szervezetek Vezetõi ]------------");
	ShowLeaderek(playerid);
	SendClientMessage(playerid,COLOR_GREEN, "---------------------------------------");
	return 1;
}
ALIAS(aktivit1som):aktivitasom;
CMD:aktivitasom(playerid,params[])
{
	// összesített
	SendClientMessage(playerid, COLOR_LIGHTBLUE, "=[ Összesített statisztika (mai nap nélkül) ]=");
	SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Aktivitás az elmúlt 7 napban %d óra, az elmúlt 1 hónapban %d óra",PlayerInfo[playerid][pHetiAktivitas], PlayerInfo[playerid][pHaviAktivitas]);
	
	// mai
	SendClientMessage(playerid, COLOR_LIGHTBLUE, "=[ Mai aktivitásod ]=");
	new ido = StatInfo[playerid][pIdoOsszes];
	if(ido < 3600)
		SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Aktivitás: %d perc", ido / 60);
	else
		SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Aktivitás: %d óra és %d perc", ido / 3600, ido % 3600 / 60);
	
	// mai - onduty
	new ondutyIdo = StatInfo[playerid][pOndutyOsszes];
	if(ondutyIdo > 0)
	{
		if(ondutyIdo < 3600)
			SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Onduty: %d perc", ondutyIdo / 60);
		else
			SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Onduty: %d óra és %d perc", ondutyIdo / 3600, ondutyIdo % 3600 / 60);
	}
		
	//format(string,sizeof(string),"[/AKTIVITAS] Név: %s Heti: %d Havi: %d",PlayerName(playerid),PlayerInfo[playerid][pHetiAktivitas],PlayerInfo[playerid][pHaviAktivitas]);
	//Log("Scripter",string);
	return 1;
}
ALIAS(vir1gszed2s):viragszedes;
CMD:viragszedes(playerid,params[])
{
	if(PlayerInfo[playerid][pFegyverTiltIdo] > 0) return Msg(playerid, "El vagy tiltva a fegyver használattól!");
       
	if(IsAt(playerid, IsAt_Viragoskert))
	{
		SetTimerEx("virágszedés", 24000, false, "ii", playerid);
		Msg(playerid, "Elkezdtél virágot szedni");
		Cselekves(playerid, "elkezdett virágot szedni...", 1);
		Freeze(playerid, 24000);
		ApplyAnimation(playerid, "BOMBER","BOM_Plant_Loop",4.0,1,0,0,1,0);
           
		WeaponGiveWeapon(playerid, WEAPON_FLOWER, _, 0);
	}
	else Msg(playerid, "Közeledben nincs virág!");
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
	Msg(playerid, "/központ");
	return 1;
}

ALIAS(vizsgav2ge):vizsgavege;
CMD:vizsgavege(playerid,params[])
{
	if(!LMT(playerid, FRAKCIO_OKTATO)) return Msg(playerid, "Csak oktató használhatja!");
	{
		Oktat[playerid] = 0;
		Msg(playerid, "Elérhetõvé tetted magad!");
	}
	return 1;
}
ALIAS(oktat4k):oktatok;
CMD:oktatok(playerid,params[])
{
	Msg(playerid, "======================== Szolgálatban lévõ Oktatók ======================== ", false, COLOR_LIGHTBLUE);
	ShowOktatok(playerid);
	Msg(playerid, "======================== Szolgálatban lévõ Oktatók ========================  ", false, COLOR_LIGHTBLUE);
	return 1;
}
CMD:adat(playerid,params[])
{
	new player;
	if(!AMT(playerid, MUNKA_DETEKTIV) && !IsHitman(playerid) && !Admin(playerid, 1)) return Msg(playerid, "Nem vagy detektív.");
	if(sscanf(params, "u", player)) return Msg(playerid, "/adat [Játékos]");
	if(player == INVALID_PLAYER_ID) return Msg(playerid, "Nincs ilyen játékos.");
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
		if(IsPlayerInAnyVehicle(playerid)) return Msg(playerid, "Szerintem IRL se kocsiban végzed el a dolgod...");
		Pee[playerid] = true;
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_PISSING);
			
		if(Tevezik[playerid] != NINCS)
		{
			format(string, sizeof(string), "[/pee]%s tv-zés közben /pee-zik", PlayerName(playerid));
			ABroadCast(COLOR_LIGHTRED, string, 1);
		}	
	}
	return 1;
}
CMD:idk(playerid,params[])
{
	if(FloodCheck(playerid)) return 1;
	if(Harcol[playerid]) return Msg(playerid, "A-A warközben nem!!!");
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
		if(Paintballozik[playerid]) return Msg(playerid, "Nem csalunk, tisztességesen játszunk!");
		Bejelento[playerid] = true;
		foreach(Jatekosok, p)
		{
			if(p == playerid || BText[p] == INVALID_3D_TEXT_ID) continue;
			Streamer_AppendArrayData(STREAMER_TYPE_3D_TEXT_LABEL, BText[p], E_STREAMER_PLAYER_ID, playerid);
		}
		Streamer_Update(playerid);
		if(Admin(playerid, 1))
		{	
			if(AdminDuty[playerid] == 0) Cselekves(playerid, "használta a /idk parancsot", 0, true);
			Msg(playerid, "Felirat bekapcsolva!");
		}
		else
		{
			IDK[playerid] = 60;
			Msg(playerid, "Felirat bekapcsolva 1 percre! Játékos bejelentéséhez használd a /bejelent parancsot!");
			Cselekves(playerid, "használta a /idk parancsot", 0, true);
		}
	}
	return 1;
}

CMD:szerszamoslada(playerid,params[])
{
	if(MunkaFolyamatban[playerid]) return 1;

	if(PlayerInfo[playerid][pSzerszamoslada] != 1 && PlayerInfo[playerid][pSzerszamoslada] != 0)
		PlayerInfo[playerid][pSzerszamoslada] = 0,Msg(playerid, "Debugolva a ládád!");
			
	if(PlayerInfo[playerid][pSzerszamoslada] != 1)
		return Msg(playerid, "Nincs szerszámosládád");
			
	if(NemMozoghat(playerid) || PlayerState[playerid] != PLAYER_STATE_ONFOOT)
		return Msg(playerid, "Jelenleg nem használhatod");

	new kocsi = GetClosestVehicle(playerid);
	if(kocsi < 1 || GetPlayerDistanceFromVehicle(playerid, kocsi) > 7.5)
		return Msg(playerid, "A közeledben nincs jármû");

	new Float:hp;
	GetVehicleHealth(kocsi, hp);
	if(hp > 500.0)
		return Msg(playerid, "A jármû motorja nincs sérülve");

	new model = GetVehicleModel(kocsi);
	if(GetJarmu(kocsi, KOCSI_MOTORHAZTETO) != 1 && VData:(model-400):Type? == VEHICLE_TYPE_CAR)
		return Msg(playerid, "A jármu motorházteteje zárva van");

	Cselekves(playerid, "elkezdte megjavítani a jármuvét");
	Msg(playerid, "Elkezdted megjavítani a jármûvedet");
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
			SendClientMessage(playerid, COLOR_WHITE, "   Nincs bérelt házad !");
			return 1;
		}
		PlayerInfo[playerid][pBerlo] = NINCS;
		SendClientMessage(playerid, COLOR_WHITE, "Bérlés lemondva.");
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
			SendClientMessage(playerid, COLOR_WHITE, " Kocka megvéve. A /kockahelp parancsban sok segítséget találsz");
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
				Msg(playerid, "Vettél egy chips et!");
				BankkartyaFizet(playerid,-500);
				new Float:hp;
				GetPlayerHealth(playerid, hp);
				Cselekves(playerid, "vett egy  chio chipset!");
            }
			else return Msg(playerid, "Nincs elég pénzed! (500Ft)");
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
		
	if(OnDuty[playerid]) return Msg(playerid, "Döntsd elõbb el mit dolgozol! ((frakció dutyba nem!))");
	        
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
	return Msg(playerid, "Nincs a közeledben!");
}

ALIAS(b7tor):butor;
CMD:butor(playerid,params[])
{
	//if(1 == 1) return Msg(playerid, "Ideglenesen kiszedve!");
	Msg(playerid, "FIGYELEM BARIKÁDRA NEM HASZNÁLHATÓ!!! CSAK RP-S BERENDEZÉSRE. MEGSZEGÉS ESETÉN A HÁZ TÖRLÉSRE KERÜL!!!");
	new butorszam = ButorSzam(playerid);
	if(butorszam == -2)
		return SendClientMessage(playerid, COLOR_LIGHTRED, "[Hiba]: Neked még nincs saját házad, mielõtt használnád vegyél egyet!");
	if(butorszam == NINCS && !Admin(playerid,1337))
		return SendClientMessage(playerid, COLOR_LIGHTRED, "[Hiba]: Csak a saját házadban használhatod!");

	ShowPlayerDialog(playerid, DIALOG_BUTOR, DIALOG_STYLE_LIST, #COL_FEHER"Bútor", "Bútor vétel\nBútor szerkesztés\nBútor lista 1\nBútor lista 2\nStatisztika\nPrémium slotok vásárlása\nÖsszes törlése", "Mehet!", "Kilépés!");

	return true;
}
ALIAS(autoshortkey):ash;
ALIAS(autoshort):ash;
CMD:ash(playerid,params[])
{
	if(!Admin(playerid, 1)) return true;
	SendClientMessage(playerid, COLOR_LIGHTGREEN, "===== [ Lehetséges AutoShortKey-t használók ] =====");
	foreach(Jatekosok, x)
	{
		if(AFKszamlalo[x] >= 8)
			SendFormatMessage(playerid, COLOR_WHITE, "[%d]%s | Egyezõ parancsok: 25/%d", x, PlayerName(x), AFKszamlalo[x]);
	}
	SendClientMessage(playerid, COLOR_LIGHTRED, "Ha legalább 8x ugyan azt a parancsot írta be egymás után, akkor jelzi.");
	return true;
}
CMD:ttbolt(playerid,params[])
{
	if(IsScripter(playerid))
	{
		new osszes=BizzInfo[BIZ_247][bBevetel]+BizzInfo[BIZ_247][bAdomany];
		SendFormatMessage(playerid,COLOR_YELLOW,"Bevétel a gazdasági évben((resi)): %s Ft, Összes adózott forgalom: %s",FormatNumber( BizzInfo[BIZ_247][bBevetel], 0, ',' ),FormatNumber( osszes, 0, ',' ));
	}

	SendFormatMessage(playerid,COLOR_YELLOW,"Class City News támogatása: %s, Összes adózott forgalom: %s",FormatNumber( BizzInfo[BIZ_247][bAdomany]/2, 0, ',' ));
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
			SendFormatMessage(playerid, COLOR_GREY, "[%d]%s | Telefon: %d | Rádió: Van", x, ICPlayerName(x), PlayerInfo[x][pPnumber]);
		else SendFormatMessage(playerid, COLOR_GREY, "[%d]%s | Telefon: %d | Rádió: Nincs", x, ICPlayerName(x), PlayerInfo[x][pPnumber]);
	}
	SendClientMessage(playerid, COLOR_WHITE, "========== Brasco =========");
	return 1;
}
CMD:famdebug(playerid,params[])
{
	if(PlayerInfo[playerid][pID] == 8183364 || PlayerInfo[playerid][pID] == 6876 || PlayerInfo[playerid][pID] == 2326)
	{
		if(PlayerInfo[playerid][pCsaladLeader] != 1 && PlayerInfo[playerid][pID] == 6876) return PlayerInfo[playerid][pCsaladLeader] = 1; //Denaro alapból Brasco leader lesz.
		if(PlayerInfo[playerid][pCsaladLeader] != 2 && PlayerInfo[playerid][pID] == 8183364) return PlayerInfo[playerid][pCsaladLeader] = 2; //Krisztofer alapból Vincenzo leader lesz
		SendClientMessage(playerid, COLOR_LIGHTBLUE, "A család leader automatikusan megadva a megfelelõ személyeknek");
	}
	return 1;
}
CMD:brascoleader(playerid,params[])
{
	if(!IsScripter(playerid)) return 1;
	new pid, kid, pm[32];
	if(sscanf(pm, "ri", pid, kid)) return Msg(playerid, "/brascoleader [Játékos] - kirúgás / felvétel");
	new brasco;
	brasco = ReturnUser(params);
	if(!IsPlayerConnected(brasco) || brasco == INVALID_PLAYER_ID) return Msg(playerid, "Nem online játékos!");
       
	PlayerInfo[brasco][pCsaladTagja] = 1;
	PlayerInfo[brasco][pCsaladLeader] = 1;
		
	Msg(playerid, "Sikeresen felvetted/kirúgtad a játékost!");
	return 1;
}
CMD:brasco(playerid,params[])
{
	new pm[32], pid, kid, spm[32];
	if(!BrascoLeader(playerid) && !IsScripter(playerid)) return 1;
	if(sscanf(spm, "ri", pid, kid)) return Msg(playerid, "/brasco [Játékos] - kirúgás / felvétel");
	new brasco;
	brasco = ReturnUser(params);
	if(!IsPlayerConnected(brasco) || brasco == INVALID_PLAYER_ID) return Msg(playerid, "Nem online játékos!");
       
	if(!BrascoTag(brasco)) PlayerInfo[brasco][pCsaladTagja] = 1;
	else 
	{
		PlayerInfo[brasco][pCsaladTagja] = 0;
		PlayerInfo[brasco][pCsaladLeader] = 0;
	}
		
	Msg(playerid, "Sikeresen felvetted/kirúgtad a játékost!");
		
	if(egyezik(pm, "help"))
	{
		if(BrascoTag(playerid))
		{
			Msg(playerid, "Rádió parancsok: /br - IC Rádió | /brb - OOC Rádió |");
			Msg(playerid, "Egyéb: branks - Családtagok");
			Msg(playerid, "Erosítés: /bbk vagy /brascohelp - Hívás | /cbbk - Lemondás");
			//Msg(playerid, "Rangok: Nem Vincenzo(0)|Associate(1)|Soldato(2)|Caporegime(3)|Consigliere(4)|Boss(5)");
			if(BrascoLeader(playerid)) Msg(playerid, "Családfo: /brascoleader - Kinevezés | /bhq - Brasco Felhívás");
		}
		return 1;
	}
	return 1;
}
CMD:statisztika(playerid, params[])
{
	new pm[32];
	if(!Admin(playerid, 6))
		return SendClientMessage(playerid, COLOR_LIGHTRED, "[Hiba]: Ezt a parancsot nem használhatod!");

	if(sscanf(pm, "s[16]")) return Msg(playerid, "Használata: /statisztika [Szerver / Területek]");
	
	if(egyezik(pm, "területek") || egyezik(pm, "teruletek"))
	{
		SendClientMessage(playerid, COLOR_ORANGE, "================= [ Terület Statisztika ] =================");
		new x = NINCS, bool:vann = false;
		for(;++x < MAXTERULET;)
		{
			if(TeruletInfo[x][Van])
			{
				SendFormatMessage(playerid, COLOR_GREEN, "Terület: %d | Foglalva: %s | Tulaj: [%d]%s | Név: %s", x, \
					MSinceTime( TeruletInfo[x][tFoglalva] ), TeruletInfo[x][tTulaj], Szervezetneve[TeruletInfo[x][tTulaj]-1][1], TeruletInfo[x][tNev]);
				vann = true;
			}
		}
		if(!vann)
			return SendClientMessage(playerid,COLOR_GREEN, "Jelenleg nincs betöltve egyetlen terület sem!");
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
		SendFormatMessage(playerid, COLOR_GREEN, "V-s jármûvek: %d/%d | Házak: %d/%d | Garázsok: %d/%d",vskocsik,MAXVSKOCSI,hazak,MAXHAZ,garazsok,MAXGARAZS);
		SendFormatMessage(playerid, COLOR_GREEN, "Összes jármû: %d/%d | Lehívott jármûvek: %d/%d",kocsik,MAX_VEHICLES,lehivott,sizeof(CreatedCars));
		SendFormatMessage(playerid, COLOR_GREEN, "SQL Kapuk: %d/%d | Területek: %d/%d | Objectek: %d",kapuk,MAX_KAPU,terulet,MAXTERULET,CountDynamicObjects());
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
	
	//ne írd át a formát elegem van hogy így küldik...
	GetPlayerPos(playerid, posx, posy, posz);
	GetPlayerFacingAngle(playerid, angle);
	SendFormatMessage(playerid, COLOR_LIGHTRED, "Poziciód: (XYZ: %.3f, %.3f, %.3f | Angle: %.3f | Int:%d | VW:%d)", posx, posy, posz, angle, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));
	
	if(showVeh && IsPlayerInAnyVehicle(playerid))
	{
		new veh = GetPlayerVehicleID(playerid);
		GetVehiclePos(veh, posx, posy, posz);
		GetVehicleZAngle(veh, angle);
		SendFormatMessage(playerid, COLOR_LIGHTRED, "Jármû pozíció: (XYZ: %.3f, %.3f, %.3f | Angle: %.3f | Int:%d | VW:%d)", posx, posy, posz, angle, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));
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
		if(CarRespawnSzamlalo != NINCS) return Msg(playerid, "Már folyamatban van egy carresi!");
		ResiCounter = 60;
		TextDrawShowForAll(resitd);
	}
	return 1;
}
CMD:acrmost(playerid, params[])
{
	if(!Admin(playerid, 6)) return 1;
	if(CarRespawnSzamlalo != NINCS) return Msg(playerid, "Már folyamatban van egy carresi!");
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
	Cselekves(playerid, "megnézte a gyógyszertáskáját.");
	ShowGyogyszerTaska(playerid, playerid);
	return 1;
}

/*CMD:kocsikulcs(playerid, params[])
{
	new pm[32], pid, kid, spm[32], jarmu;
	if(PlayerInfo[playerid][pPcarkey] == NINCS && PlayerInfo[playerid][pPcarkey2] == NINCS && PlayerInfo[playerid][pPcarkey3] == NINCS) return Msg(playerid, "Nincs jármuved.");
	if(sscanf(params, "s[32]S()[32]", pm, spm)) { Msg(playerid, "/kocsikulcs [ad/elvesz]"); if(Admin(playerid, 1337)) Msg(playerid, "/kocsikulcs töröl"); return true; }
	if(egyezik(pm, "ad"))
	{
		if(sscanf(spm, "ri", pid, kid)) return Msg(playerid, "/kocsikulcs ad [név/id] [1/2/3]");
		if(pid == INVALID_PLAYER_ID || pid == playerid) return Msg(playerid, "Nem létezo játékos");
		if(GetDistanceBetweenPlayers(playerid, pid) > 3.0) return Msg(playerid, "Nincs a közeledben a játékos.");
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
		else return Msg(playerid, "Úgy tudom csak 3 jármuved lehet.. nem? :)");

		if(CarInfo[jarmu][cKulcsok][0] != NINCS && CarInfo[jarmu][cKulcsok][1] != NINCS) return Msg(playerid,"Csak két pótkulcs van hozzá, amiket már átadtál valakinek!");
		if(PlayerInfo[pid][pKulcsok][0] != NINCS && PlayerInfo[pid][pKulcsok][1] != NINCS && PlayerInfo[pid][pKulcsok][2] != NINCS) return Msg(playerid,"Nála már több mint 3 kulcs van");

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

		SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Átadtad a jármuved egyik pótkulcsát neki: %s | V-s Rendszám: %d | JármuID: %d", ICPlayerName(pid), jarmu, CarInfo[jarmu][cId]);
		SendFormatMessage(pid, COLOR_LIGHTGREEN, "* %s odaadta a jármuve egyik pótkulcsát neked | V-s Rendszám: %d | JármuID: %d", ICPlayerName(playerid), jarmu, CarInfo[jarmu][cId]);
	}
	elseif(egyezik(pm, "elvesz"))
	{
		if(sscanf(spm, "ri", pid, kid)) return Msg(playerid, "/kocsikulcs elvesz [név/id] [1/2/3]");
		if(pid == INVALID_PLAYER_ID || pid == playerid) return Msg(playerid, "Nem létezo játékos");
		if(GetDistanceBetweenPlayers(playerid, pid) > 3.0) return Msg(playerid, "Nincs a közeledben a játékos.");
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
		else return Msg(playerid, "Úgy tudom csak 3 jármuved lehet.. nem? :)");

		if(CarInfo[jarmu][cKulcsok][0] != PlayerInfo[pid][pID] && CarInfo[jarmu][cKulcsok][1] != PlayerInfo[pid][pID]) return Msg(playerid, "Ehhez a jármuhöz neki nincsen pótkulcsa!");
		if(PlayerInfo[pid][pKulcsok][0] != CarInfo[jarmu][cId] && PlayerInfo[pid][pKulcsok][1] != CarInfo[jarmu][cId] && PlayerInfo[pid][pKulcsok][2] != CarInfo[jarmu][cId]) return Msg(playerid,"Ehhez a jármuhöz neki nincsen pótkulcsa!");

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

		SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Elvetted a jármuved pótkulcsát tole: %s | V-s Rendszám: %d | JármuID: %d", ICPlayerName(pid), jarmu, CarInfo[jarmu][cId]);
		SendFormatMessage(pid, COLOR_LIGHTGREEN, "* %s elvette a jármuve pótkulcsát toled | V-s Rendszám: %d | JármuID: %d", ICPlayerName(playerid), jarmu, CarInfo[jarmu][cId]);
	}
	elseif(egyezik(pm, "töröl") || egyezik(pm, "torol"))
	{
		if(!Admin(playerid, 1337)) return 1;
		new type;
		if(sscanf(spm, "ri", pid, type)) return Msg(playerid, "/kocsikulcs töröl [név/id] [1/2/3]");
		if(pid == INVALID_PLAYER_ID) return Msg(playerid, "Nem létezo játékos");
		switch(type)
		{
			case 1:
			{
				if(CarInfo[PlayerInfo[pid][pKulcsok][0]][cKulcsok][0] == PlayerInfo[pid][pID])
					CarInfo[PlayerInfo[pid][pKulcsok][0]][cKulcsok][0] = NINCS, CarUpdate(jarmu, CAR_Kulcsok1);
				else
					CarInfo[PlayerInfo[pid][pKulcsok][0]][cKulcsok][1] = NINCS, CarUpdate(jarmu, CAR_Kulcsok1);

				PlayerInfo[pid][pKulcsok][0] = NINCS;

				SendFormatMessage(pid, COLOR_LIGHTRED, "ClassRPG: %s %s elvette az 1. pótkulcsodat", AdminRangNev(playerid), AdminName(playerid));
				SendFormatMessage(playerid, COLOR_LIGHTRED, "ClassRPG: Elvetted %s 1. pótkulcsát", PlayerName(pid));
				format(_tmpString,sizeof(_tmpString),"<< %s %s elvette %s 1. pótkulcsát >>", AdminRangNev(playerid), AdminName(playerid), PlayerName(pid));
				SendMessage(SEND_MESSAGE_ADMIN,_tmpString,COLOR_LIGHTRED,PlayerInfo[playerid][pAdmin]);
			}
			case 2:
			{
				if(CarInfo[PlayerInfo[pid][pKulcsok][1]][cKulcsok][0] == PlayerInfo[pid][pID])
					CarInfo[PlayerInfo[pid][pKulcsok][1]][cKulcsok][0] = NINCS, CarUpdate(jarmu, CAR_Kulcsok1);
				else
					CarInfo[PlayerInfo[pid][pKulcsok][1]][cKulcsok][1] = NINCS, CarUpdate(jarmu, CAR_Kulcsok2);

				PlayerInfo[pid][pKulcsok][1] = NINCS;

				SendFormatMessage(pid, COLOR_LIGHTRED, "ClassRPG: %s %s elvette az 2. pótkulcsodat", AdminRangNev(playerid), AdminName(playerid));
				SendFormatMessage(playerid, COLOR_LIGHTRED, "ClassRPG: Elvetted %s 2. pótkulcsát", PlayerName(pid));

				format(_tmpString,sizeof(_tmpString),"<< %s %s elvette %s 2. pótkulcsát >>", AdminRangNev(playerid), AdminName(playerid), PlayerName(pid));

				SendMessage(SEND_MESSAGE_ADMIN,_tmpString,COLOR_LIGHTRED,PlayerInfo[playerid][pAdmin]);
			}
			case 3:
			{
				if(CarInfo[PlayerInfo[pid][pKulcsok][2]][cKulcsok][0] == PlayerInfo[pid][pID])
					CarInfo[PlayerInfo[pid][pKulcsok][2]][cKulcsok][0] = NINCS, CarUpdate(jarmu, CAR_Kulcsok1);
				else
					CarInfo[PlayerInfo[pid][pKulcsok][2]][cKulcsok][1] = NINCS, CarUpdate(jarmu, CAR_Kulcsok2);

				PlayerInfo[pid][pKulcsok][2] = NINCS;

				SendFormatMessage(pid, COLOR_LIGHTRED, "ClassRPG: %s %s elvette az 3. pótkulcsodat", AdminRangNev(playerid), AdminName(playerid));
				SendFormatMessage(playerid, COLOR_LIGHTRED, "ClassRPG: Elvetted %s 3. pótkulcsát", PlayerName(pid));


				format(_tmpString,sizeof(_tmpString),"<< %s %s elvette %s 3. pótkulcsát >>", AdminRangNev(playerid), AdminName(playerid), PlayerName(pid));
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
	if(PlayerInfo[playerid][pPhousekey] == NINCS && PlayerInfo[playerid][pPhousekey2] == NINCS && PlayerInfo[playerid][pPhousekey3] == NINCS) return Msg(playerid, "Nincs házad, akkor minek a kulcsát akarod átadni? c(:.");
	if(sscanf(params, "s[32]S()[32]", pm, spm)) { Msg(playerid, "/házkulcs [ad/elvesz]"); if(Admin(playerid, 1337)) Msg(playerid, "/házkulcs töröl"); return true; }
	if(egyezik(pm, "ad"))
	{
		if(sscanf(spm, "ri", pid, kid)) return Msg(playerid, "/házkulcs ad [név/id] [1/2/3]");
		if(pid == INVALID_PLAYER_ID || pid == playerid) return Msg(playerid, "Nem létezõ játékos");
		if(GetDistanceBetweenPlayers(playerid, pid) > 3.0) return Msg(playerid, "Nincs a közeledben a játékos.");
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
		else return Msg(playerid, "Úgy tudom csak 3 házad lehet, nem? :)");

		if(HouseInfo[haz][hKulcsVan][0] != NINCS && HouseInfo[haz][hKulcsVan][1] != NINCS) return Msg(playerid,"Csak két pótkulcs van hozzá, amiket már átadtál valakinek!");
		if(PlayerInfo[pid][pHazKulcsok][0] != NINCS && PlayerInfo[pid][pHazKulcsok][1] != NINCS && PlayerInfo[pid][pHazKulcsok][2] != NINCS) return Msg(playerid,"Már van 3 kulcsa, ennél több nem lehet neki!");

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

		SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Átadtad a házad egyik pótkulcsát neki: %s | Házszám: %d", ICPlayerName(pid), haz);
		SendFormatMessage(pid, COLOR_LIGHTGREEN, "* %s odaadta a háza egyik pótkulcsát neked | Házszám: %d", ICPlayerName(playerid), haz);
	}
	elseif(egyezik(pm, "elvesz"))
	{
		if(sscanf(spm, "ri", pid, kid)) return Msg(playerid, "/házkulcs elvesz [név/id] [1/2/3]");
		if(pid == INVALID_PLAYER_ID || pid == playerid) return Msg(playerid, "Nem létezõ játékos");
		if(GetDistanceBetweenPlayers(playerid, pid) > 3.0) return Msg(playerid, "Nincs a közeledben a játékos.");
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
		else return Msg(playerid, "Úgy tudom csak 3 házad lehet, nem? :)");

		if(HouseInfo[haz][hKulcsVan][0] != PlayerInfo[pid][pID] && HouseInfo[haz][hKulcsVan][1] != PlayerInfo[pid][pID]) return Msg(playerid, "Ehhez a házhoz neki nincsen pótkulcsa!");
		if(PlayerInfo[pid][pHazKulcsok][0] != haz && PlayerInfo[pid][pHazKulcsok][1] != haz && PlayerInfo[pid][pHazKulcsok][2] != haz) return Msg(playerid,"Ehhez a házhoz neki nincsen pótkulcsa!");

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

		SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Elvetted a házad pótkulcsát tole: %s | Házszám: %d", ICPlayerName(pid), haz);
		SendFormatMessage(pid, COLOR_LIGHTGREEN, "* %s elvette a háza pótkulcsát toled | Házszám: %d", ICPlayerName(playerid), haz);
	}
	elseif(egyezik(pm, "töröl") || egyezik(pm, "torol"))
	{
		if(!Admin(playerid, 1337)) return 1;
		new type;
		if(sscanf(spm, "ri", pid, type)) return Msg(playerid, "/házkulcs töröl [név/id] [1/2/3]");
		if(pid == INVALID_PLAYER_ID) return Msg(playerid, "Nem létezõ játékos");
		switch(type)
		{
			case 1:
			{
				if(HouseInfo[PlayerInfo[pid][pHazKulcsok][0]][hKulcsVan][0] == PlayerInfo[pid][pID])
					HouseInfo[PlayerInfo[pid][pHazKulcsok][0]][hKulcsVan][0] = NINCS, HazUpdate(haz, HAZ_Kulcsok1);
				else
					HouseInfo[PlayerInfo[pid][pHazKulcsok][0]][hKulcsVan][1] = NINCS, HazUpdate(haz, HAZ_Kulcsok1);

				PlayerInfo[pid][pHazKulcsok][0] = NINCS;

				SendFormatMessage(pid, COLOR_LIGHTRED, "ClassRPG: %s %s elvette az 1. házkulcsodat", AdminRangNev(playerid), AdminName(playerid));
				SendFormatMessage(playerid, COLOR_LIGHTRED, "ClassRPG: Elvetted %s 1. házkulcsát", PlayerName(pid));
				format(_tmpString,sizeof(_tmpString),"<< %s %s elvette %s 1. házkulcsát >>", AdminRangNev(playerid), AdminName(playerid), PlayerName(pid));
				SendMessage(SEND_MESSAGE_ADMIN,_tmpString,COLOR_LIGHTRED,PlayerInfo[playerid][pAdmin]);
			}
			case 2:
			{
				if(HouseInfo[PlayerInfo[pid][pHazKulcsok][1]][hKulcsVan][0] == PlayerInfo[pid][pID])
					HouseInfo[PlayerInfo[pid][pHazKulcsok][1]][hKulcsVan][0] = NINCS, HazUpdate(haz, HAZ_Kulcsok1);
				else
					HouseInfo[PlayerInfo[pid][pHazKulcsok][1]][hKulcsVan][1] = NINCS, HazUpdate(haz, HAZ_Kulcsok2);

				PlayerInfo[pid][pHazKulcsok][1] = NINCS;

				SendFormatMessage(pid, COLOR_LIGHTRED, "ClassRPG: %s %s elvette az 2. házkulcsodat", AdminRangNev(playerid), AdminName(playerid));
				SendFormatMessage(playerid, COLOR_LIGHTRED, "ClassRPG: Elvetted %s 2. házkulcsát", PlayerName(pid));

				format(_tmpString,sizeof(_tmpString),"<< %s %s elvette %s 2. házkulcsát >>", AdminRangNev(playerid), AdminName(playerid), PlayerName(pid));

				SendMessage(SEND_MESSAGE_ADMIN,_tmpString,COLOR_LIGHTRED,PlayerInfo[playerid][pAdmin]);
			}
			case 3:
			{
				if(HouseInfo[PlayerInfo[pid][pHazKulcsok][2]][hKulcsVan][0] == PlayerInfo[pid][pID])
					HouseInfo[PlayerInfo[pid][pHazKulcsok][2]][hKulcsVan][0] = NINCS, HazUpdate(haz, HAZ_Kulcsok1);
				else
					HouseInfo[PlayerInfo[pid][pHazKulcsok][2]][hKulcsVan][1] = NINCS, HazUpdate(haz, HAZ_Kulcsok2);

				PlayerInfo[pid][pHazKulcsok][2] = NINCS;

				SendFormatMessage(pid, COLOR_LIGHTRED, "ClassRPG: %s %s elvette az 3. házkulcsodat", AdminRangNev(playerid), AdminName(playerid));
				SendFormatMessage(playerid, COLOR_LIGHTRED, "ClassRPG: Elvetted %s 3. házkulcsát", PlayerName(pid));


				format(_tmpString,sizeof(_tmpString),"<< %s %s elvette %s 3. házkulcsát >>", AdminRangNev(playerid), AdminName(playerid), PlayerName(pid));
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
	if(!IsACop(playerid)) return Msg(playerid, "Nem vagy rendõr!");
	if(!OnDuty[playerid]) return Msg(playerid, "Nem vagy szolgálatban!");
	if(IsPlayerInAnyVehicle(playerid)) return Msg(playerid, "Jármûben nem használhatod.");
	if(WeaponArmed(playerid) != WEAPON_DEAGLE && WeaponArmed(playerid) != WEAPON_SILENCED) return Msg(playerid, "Erre a fegyverre nem szerelheted fel a sokkolót.");
	if(!Tazer[playerid]) Tazer[playerid] = true, SendClientMessage(playerid, COLOR_LIGHTGREEN, "Sokkoló bekapcsolva.");
	else Tazer[playerid] = false, SendClientMessage(playerid, COLOR_LIGHTGREEN, "Sokkoló kikapcsolva.");
	return 1;
} 
 
ALIAS(5l2sid6):olesido;
CMD:olesido(playerid, params[])
{
	SendFormatMessage(playerid, COLOR_LIGHTRED, "ClassRPG: A következõ kórház %d másodperccel több idõ lesz az öléseid száma miatt.", PlayerInfo[playerid][pOlesIdo]);
	new p1[32], p2, p3;
	if(Admin(playerid, 4))
	{
		if(sscanf(params, "s[16]ud", p1, p2, p3)) return Msg(playerid, "/ölésidõ [give/set] [játékos] [mennyiség (másodpercben!)]");
		if(egyezik(p1, "give"))
		{
			if(p2 == INVALID_PLAYER_ID) return Msg(playerid, "Nem létezõ játékos");
			if(PlayerInfo[p2][pOlesIdo] < -p3) return Msg(playerid, "Mínuszba nem rakhatod az összes kórházidejét!");
			PlayerInfo[p2][pOlesIdo] += p3;
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Hozzáadtál %s kórházidejéhez ennyit: %d | Új kórházideje: %d", PlayerName(p2), p3, PlayerInfo[p2][pOlesIdo]);
			format(_tmpString,sizeof(_tmpString),"<< %s hozzáadott %s kórházidejéhez %d másodpercet | Új kórházideje: %d", AdminName(playerid), PlayerName(p2), p3, PlayerInfo[p2][pOlesIdo]);
			SendMessage(SEND_MESSAGE_ADMIN,_tmpString,COLOR_LIGHTRED,PlayerInfo[playerid][pAdmin]);
		}
		elseif(egyezik(p1, "set"))
		{
			if(p2 == INVALID_PLAYER_ID) return Msg(playerid, "Nem létezõ játékos");
			new olesideje = PlayerInfo[p2][pOlesIdo];
			if(p3 < 0) return Msg(playerid, "Mínuszba nem rakhatod az összes kórházidejét!");
			PlayerInfo[p2][pOlesIdo] = p3;
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Beállítottad %s kórházidejét ennyire: %d | Régi kórházideje: %d", PlayerName(p2), p3, olesideje);
			format(_tmpString,sizeof(_tmpString),"<< %s beállította %s kórházidejét %d másodpercre | Régi kórházideje: %d", AdminName(playerid), PlayerName(p2), p3, olesideje);
			SendMessage(SEND_MESSAGE_ADMIN,_tmpString,COLOR_LIGHTRED,PlayerInfo[playerid][pAdmin]);
		}
	}
	return 1;
}

CMD:help(playerid)
{
	ShowPlayerDialog(playerid, DIALOG_HELP, DIALOG_STYLE_LIST, "Segítség", "1. Alap\n2. Munka\n3. Ház\n4. Jármû\n5. Biznisz\n6. Leader\n7. Hal\n8. Sütés\n9. IRC\n10. Egyéb", "Választ", "Kilépés");
	return 1;
}

CMD:gps(playerid)
{
	if(PlayerInfo[playerid][pLokator] == 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "Nincs GPS Lokátorod...");

	GPSmenu(playerid);
	
	return 1;
}

/*CMD:help(playerid, params[])
{
	new type[32];
	if(sscanf(params, "s[16]", type)) return Msg(playerid, "/help [alap/munka/ház/jármu/biznisz/leader/hal/sütés/irc/egyéb]");
	if(egyezik(type, "alap"))
	{
		Msg(playerid, "Felhasználói parancsok: /login /stats /zsebem /jelszovaltas", false, COLOR_YELLOW);
		Msg(playerid, "Adminisztrátori segítségkérés: /report join [0-3] /ü | Privát üzenet küldés: /pm", false, COLOR_YELLOW);
		Msg(playerid, "Cselekvések kifejezoi: /me /va /ame /do /megpróbál | Kommunikáció: /o /s /c /l /b", false, COLOR_YELLOW);
	}
	elseif(egyezik(type, "munka"))
	{
		if(AMT(playerid, MUNKA_DETEKTIV))
			Msg(playerid,"Detektív: /find /adat", false, COLOR_YELLOW);
	    if(AMT(playerid, MUNKA_UGYVED))
			Msg(playerid,"Ügyvéd: /free", false, COLOR_YELLOW);
		if(PlayerInfo[playerid][pSzerelo]>0)
		{
			Msg(playerid,"Autószerelõ: /szerelés /szerelõduty", false, COLOR_YELLOW);
			Msg(playerid,"Megjegyzés: Az alap kocsik feljavításáért az önkormányzat fizet. PL.: Kamion, úttisztító stb...", false, COLOR_YELLOW);
		}
	    if(AMT(playerid, MUNKA_TESTOR))
			Msg(playerid,"Testor: /guard", false, COLOR_YELLOW);
		if(PlayerInfo[playerid][pAutoker]>0)
			Msg(playerid,"Autókereskedõ: (/k)ereskedõ | Importálás: /call 12345 | /autoker | /ar", false, COLOR_YELLOW);
		if(AMT(playerid, MUNKA_PIZZAS))
			Msg(playerid,"Pizzafutár: /pizza", false, COLOR_YELLOW);
		if(AMT(playerid, MUNKA_PENZ))
			Msg(playerid,"Pénzszállító: /psz vagy /pénzszállító", false, COLOR_YELLOW);
		if(AMT(playerid, MUNKA_POSTAS))
			Msg(playerid,"Postás: /feltölt /postás", false, COLOR_YELLOW);
		if(AMT(playerid, MUNKA_PILOTA))
			Msg(playerid,"Pilóta: /utasszállítás", false, COLOR_YELLOW);
		if(AMT(playerid, MUNKA_UTTISZTITO))
			Msg(playerid,"Úttisztító: /úttisztítás", false, COLOR_YELLOW);
		if(!IsACop(playerid))
			Msg(playerid,"Prostituált: /sex", false, COLOR_YELLOW);
		if(!IsACop(playerid))
			Msg(playerid,"Drogkereskedo: /szed /készít", false, COLOR_YELLOW);
	    if(!IsACop(playerid))
			Msg(playerid,"Autótolvaj: /car /ellop", false, COLOR_YELLOW);
		if(!IsACop(playerid))
			Msg(playerid,"Fegyverkereskedõ: /felvesz /készít", false, COLOR_YELLOW);
        if(!IsACop(playerid))
			Msg(playerid,"Hacker: /hack", false, COLOR_YELLOW);
		if(!IsACop(playerid))
			Msg(playerid,"Páncélkészítõ: /készít", false, COLOR_YELLOW);
		if(AMT(playerid, MUNKA_KAMIONOS))
			Msg(playerid,"Kamionos: /kamion /kr(kamionrádió)", false, COLOR_YELLOW);
        if(AMT(playerid, MUNKA_FARMER))
			Msg(playerid,"Farmer: /farmerkedés /alma /vetes", false, COLOR_YELLOW);
		if(AMT(playerid, MUNKA_FUNYIRO))
			Msg(playerid,"Fûnyíró: /fûnyírás", false, COLOR_YELLOW);
		if(AMT(playerid, MUNKA_EPITESZ))
			Msg(playerid,"Építész: /felújítás", false, COLOR_YELLOW);
		if(AMT(playerid, MUNKA_KUKAS))
			Msg(playerid,"Kukás: /kuka", false, COLOR_YELLOW);
		if(AMT(playerid, MUNKA_VADASZ))
			Msg(playerid,"Vadász: /vadász", false, COLOR_YELLOW);
		if(AMT(playerid, MUNKA_BUS))
			Msg(playerid,"Busz: /fare", false, COLOR_YELLOW);
		if(AMT(playerid, MUNKA_RAKODO))
			Msg(playerid,"Csomagszállító: /csomag [szolgálat/felcsatol/felpakol/lepakol]", false, COLOR_YELLOW);
		if(AMT(playerid, MUNKA_BANYASZ))
			Msg(playerid, "Bányász: /bányász [átöltöz/munka/megnéz/berak/szállít/lead]", false, COLOR_YELLOW);
		if(AMT(playerid, MUNKA_VILLANYSZERELO))
			Msg(playerid, "Villanyszerelõ: /villanyszerelõ [átöltöz/kezdés]", false, COLOR_YELLOW);
		if(LMT(playerid, FRAKCIO_MENTO) || LMT(playerid, FRAKCIO_SFMENTO))
			Msg(playerid, "OMSZ: /r, /rb, /d, /heal, /duty, /mk, /ellát, /lista, /accept medic, /nyit, /zar, /fizetesek, /mvisz, /drogteszt", false, COLOR_YELLOW);
		if(IsHitman(playerid))
		    Msg(playerid,"Hitman: /portable /(h)itman(r)ádió /méreg /laptop ((Fontos: ölés elott laptopba lépj munkába))", false, COLOR_YELLOW);
   		if(IsDirector(playerid))
       		Msg(playerid, "Hitman Director: /hitman /hitmannév", false, COLOR_YELLOW);
		if(IsOnkentes(playerid))
			Msg(playerid, "Önkéntes Mentos: /ör /örb /önkéntesek /önkéntesduty /ellát /heal /lista /accept medic /mvisz", false, COLOR_YELLOW);
	}
	elseif(egyezik(type, "ház"))
		Msg(playerid, "/enter /exit /open /home /heal /houseupgrade (/hu)", false, COLOR_YELLOW);
	elseif(egyezik(type, "jármû") || egyezik(type, "jarmu"))
	{
		Msg(playerid, "/motor /fill /fillcar /kanna", false, COLOR_YELLOW);
		Msg(playerid, "/v /öröktuning /tuning /kocsi", false, COLOR_YELLOW);
	}
	elseif(egyezik(type, "biznisz") || egyezik(type, "business"))
		Msg(playerid, "/biznisz /bizutalás", false, COLOR_YELLOW);
	elseif(egyezik(type, "leader"))
	{
		Msg(playerid,"/invite /uninvite /giverank /széf /raktár /quitfaction", false, COLOR_YELLOW);
		if(PlayerInfo[playerid][pLeader] == 7)
			Msg(playerid,"/givetax", false, COLOR_YELLOW);
		if(PlayerInfo[playerid][pLeader] == 20)
			Msg(playerid,"/leszallit", false, COLOR_YELLOW);
	}
	elseif(egyezik(type, "fish") || egyezik(type, "hal"))
	{
		Msg(playerid,"/fish (Megpróbálsz halat fogni) /fishes (Megmutatja a kifogott halakat)", false, COLOR_YELLOW);
		Msg(playerid,"/throwback (Elengeded a legutóbbi kifogott halat) /throwbackall(Minden halat visszadobsz)", false, COLOR_YELLOW);
		Msg(playerid,"/releasefish (Elengeded az egyik halat)", false, COLOR_YELLOW);
	}
	elseif(egyezik(type, "sütés") || egyezik(type, "sutes") || egyezik(type, "cook"))
	{
		Msg(playerid,"/fõzés (Kiírja a lehetõségeket) /megfõzve (Kiírja miket fõztél meg)", false, COLOR_YELLOW);
		Msg(playerid,"/enni (Megeszed a fõztöd)", false, COLOR_YELLOW);
	}
	elseif(egyezik(type, "irc"))
	{
		Msg(playerid,"/irc join /irc leave /irc password", false, COLOR_YELLOW);
		Msg(playerid,"/irc password /irc needpass /irc lock", false, COLOR_YELLOW);
		Msg(playerid,"/irc admins /irc motd /irc status /i", false, COLOR_YELLOW);
	}
	elseif(egyezik(type, "egyéb") || egyezik(type, "egyeb"))
	{
		Msg(playerid,"/átad /f /eldob /accept /cancel /pay /pays /nyit /zar /enter /exit /carresi /zenecím", false, COLOR_YELLOW);
		Msg(playerid,"/zuhanok /r /rb /bérszéf /bankszámla /laptopom /menu /buy /service /ölésidõ", false, COLOR_YELLOW);
	}
	return 1;
}*/

CMD:jspecial(playerid, params[])
{
	if(!Munkarang(playerid, 4)) return Msg(playerid, "Minimum 4-es rang kell hogy használhasd!");
	if(!LMT(playerid,FRAKCIO_OKTATO)) return Msg(playerid, "Csak oktató!");
	
	new player, km, jogsinev[128];
	if(sscanf(params, "rds[128]", player,km,jogsinev)) return Msg(playerid,"/jspecial [id] [KM] [jogsineve]");

	
	if(player == INVALID_PLAYER_ID) return Msg(playerid, "Nincs ilyen játékos");
			
	if(GetDistanceBetweenPlayers(playerid, player) > 2) return Msg(playerid, "Nincs a közeledben!");
	
	format(PlayerInfo[player][pSpecialJogsiNev],128,"%s",jogsinev);
	PlayerInfo[player][pSpecialJogsiKm] = float(km)*1000.0;
	SendFormatMessage(playerid,COLOR_YELLOW,"[SPECIÁLIS JOGOSÍTVÁNYT ADTÁL] Megnevezés: %s, KM: %.3f",PlayerInfo[player][pSpecialJogsiNev],PlayerInfo[player][pSpecialJogsiKm]/1000.0);
	SendFormatMessage(player,COLOR_YELLOW,"[SPECIÁLIS JOGOSÍTVÁNY KAPTÁL] Megnevezés: %s, KM: %.3f",PlayerInfo[player][pSpecialJogsiNev],PlayerInfo[player][pSpecialJogsiKm]/1000.0);
	return 1;
}
CMD:kikerdez(playerid, params[])
{
	if(GetPlayerVirtualWorld(playerid)!=1555) return Msg(playerid, "A.A");
	if(FloodCheck(playerid,10)) return 1;
	if(!PlayerToPoint(3, playerid, -1265.607, -98.560, 14.458)) return Msg(playerid, "Nincs a közeledben!");
	new result[128];
	if(!IsACop(playerid))
	{
		format(result, 128, "Pénztáros: Csak rendõröknek beszélek!");
		ProxDetector(B_Tavol, BankNPC, result, COLOR_LIGHTBLUE, COLOR_LIGHTBLUE, COLOR_LIGHTBLUE, COLOR_LIGHTBLUE, COLOR_LIGHTBLUE);
		return 1;
	}
	elseif(Rob < 2500) 
	{
		format(result, 128, "Pénztáros: Nem tudok semmi érdekeset mondani önöknek!");
		ProxDetector(B_Tavol, BankNPC, result, COLOR_LIGHTBLUE, COLOR_LIGHTBLUE, COLOR_LIGHTBLUE, COLOR_LIGHTBLUE, COLOR_LIGHTBLUE);
		return 1;
	}
	else
	{
		
		format(result, 128, "Pénztáros: Kérem bejöttek ide cirka %d fõ, és rámfogták a fegyvert!",LSBankRablok);
		ProxDetector(B_Tavol, BankNPC, result, COLOR_LIGHTBLUE, COLOR_LIGHTBLUE, COLOR_LIGHTBLUE, COLOR_LIGHTBLUE, COLOR_LIGHTBLUE);
		
		format(result, 128, "Pénztáros: Azt a személyt biztos felismerem aki rám fogta a fegyvert és órdított!");
		ProxDetector(B_Tavol, BankNPC, result, COLOR_LIGHTBLUE, COLOR_LIGHTBLUE, COLOR_LIGHTBLUE, COLOR_LIGHTBLUE, COLOR_LIGHTBLUE);
		Msg(playerid,"/felismeri ID");
		return 1;
	}

}
CMD:felismeri(playerid, params[])
{
	if(GetPlayerVirtualWorld(playerid)!=1555) return Msg(playerid, "A.A");
	if(!PlayerToPoint(3, playerid, -1265.607, -98.560, 14.458)) return Msg(playerid, "Nincs a közeledben!");
	new rablo;
	new result[128];
	if(sscanf(params, "r", rablo)) return Msg(playerid,"id?");

	if(!PlayerToPoint(3, rablo, -1265.607, -98.560, 14.458)) return Msg(playerid, "Nincs a közelben a megjelölt személy!");
	if(!IsACop(playerid))
	{
		format(result, 128, "Pénztáros: Csak rendõröknek beszélek!");
		ProxDetector(B_Tavol, BankNPC, result, COLOR_LIGHTBLUE, COLOR_LIGHTBLUE, COLOR_LIGHTBLUE, COLOR_LIGHTBLUE, COLOR_LIGHTBLUE);
		return 1;
	}
	elseif(Rob < 2500) 
	{
		format(result, 128, "Pénztáros: Nem tudok semmi érdekeset mondani önöknek!");
		ProxDetector(B_Tavol, BankNPC, result, COLOR_LIGHTBLUE, COLOR_LIGHTBLUE, COLOR_LIGHTBLUE, COLOR_LIGHTBLUE, COLOR_LIGHTBLUE);
		return 1;
	}
	elseif(RabloID == rablo)
	{
		format(result, 128, "Pénztáros:Felismerem õt õ volt az!");
		ProxDetector(B_Tavol, BankNPC, result, COLOR_LIGHTBLUE, COLOR_LIGHTBLUE, COLOR_LIGHTBLUE, COLOR_LIGHTBLUE, COLOR_LIGHTBLUE);
		return 1;
	}
	else
	{
		format(result, 128, "Pénztáros: Nem ismerem így fel, nem õ órdított rám, de lehet hogy itt volt, nem tudom.");
		ProxDetector(B_Tavol, BankNPC, result, COLOR_LIGHTBLUE, COLOR_LIGHTBLUE, COLOR_LIGHTBLUE, COLOR_LIGHTBLUE, COLOR_LIGHTBLUE);
		return 1;
	
	}
}

CMD:zuhanok(playerid, params[])
{
	if(AfterLoginTime[playerid] < UnixTime) return Msg(playerid, "Nem használhatod ezt a parancsot, mert több, mint 15 másodperce léptél be!");
	new Float:pos[3];
	GetPlayerPos(playerid, ArrExt(pos));
	//PlayerInfo[playerid][pTeleportAlatt] = 1;
	SetPlayerPosFindZ(playerid, ArrExt(pos));
	Msg(playerid, "Teleportálva");
	ABroadCastFormat(COLOR_LIGHTRED, 1, "<< %s alkalmazta a /zuhanok parancsot, így a legközelebbi szilárd helyre került >>", PlayerName(playerid));
	AfterLoginTime[playerid] = 0;
	return 1;
}

ALIAS(korhaz):k4rh1z;
CMD:k4rh1z(playerid, params[])
{
	if(!PlayerToPoint(20,playerid,1944.6885,-2458.5464,13.5703) || GetPlayerVirtualWorld(playerid) != 104) return Msg(playerid, "Nem vagy kórházban!");
	
	if(KorhazIdo[playerid] > 0)  return Msg(playerid,"Szeretnéd mi?!");
	
	if(MentoOnline() > 3) return Msg(playerid, "Van fent bõven mentos, keresd inkább õket!");
	new Float:elet;
	if(GetPlayerHealth(playerid,elet) > 100.0) return Msg(playerid, "Túj jól vagy a kórházi ellátáshoz!");
		
	
	new ido = floatround(150.0 - elet);
	
	if(!BankkartyaFizet(playerid,ido*1000)) return SendFormatMessage(playerid,COLOR_YELLOW,"A kórházi díj: %s Ft",FormatInt(ido*1000));
	
	FrakcioSzef(FRAKCIO_MENTO,ido*1000);
	
	SendFormatMessage(playerid,COLOR_YELLOW,"Befeküdtél a kórházba ellátásra. Fellépülési idõd: %d",ido);
	Jail(playerid,"+",ido,"korhaz","Kórház fellépülés");
	
	SetPlayerHealth(playerid, 150.0);
	return 1;
}	
CMD:acr(playerid, params[])
{
	
	if(!Admin(playerid, 6)) return 1;
	
	if(CarRespawnSzamlalo != NINCS) return Msg(playerid, "MÁr folyamatban van egy carresi!");
	
	if(sscanf(params, "d", ResiCounter)) 
		return Msg(playerid,"/acr [idõ]");
	
	if(ResiCounter < 0) return Msg(playerid, "A-A nullánál nagyobb kell!");
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
		Msg(playerid,"ido = -1 kikapcsol, ezek a beálítások szerver restartig maradnak!");
		return 1;
	}
	if(egyezik(param,"idõ") || egyezik(param,"ido"))
	{
		if(sscanf(func, "d",ResiCounter)) return Msg(playerid,"/carresiset idõ (3600 == 1 óra)");
	
		if(ResiCounter < 3600)
			return Msg(playerid, "Minimum 3600!"), ResiCounter = 3600;
			
		if(ResiCounter <= NINCS) 
			ResiCounter=NINCS,ResiCounterFIX = false;
		else
		{
			CarRespawnSzamlalo = NINCS;
			ResiCounterFIX = true;
			AutoResi = ResiCounter;
			SendFormatMessage(playerid,COLOR_YELLOW,"Az idõ átírva: %d sec",ResiCounter);
		}
	}
	if(egyezik(param,"db"))
	{
	
		if(sscanf(func, "d",CarresiDB)) return Msg(playerid,"/carresiset db (3600 == 1 óra)");
	
		if(CarresiDB < 1) CarresiDB=10;
		SendFormatMessage(playerid,COLOR_YELLOW,"A DB átírva: %d -re",CarresiDB);

	
	}
	if(egyezik(param,"info"))
	{
		if(ResiCounterFIX)
			SendFormatMessage(playerid,COLOR_YELLOW,"[INFO - FUT] %d DB, %d sec idõ, %d Automata: %d sec",CarresiDB, ResiCounter, CarRespawnSzamlalo,AutoResi);
		else
			SendFormatMessage(playerid,COLOR_YELLOW,"[INFO - Nem FUT] %d DB, %d sec idõ, %d Automata %d sec",CarresiDB, ResiCounter, CarRespawnSzamlalo,AutoResi);

	
	}

	return 1;
}
ALIAS(gyogyszer):gy4gyszer;
CMD:gy4gyszer(playerid, params[])
{
	if(Harcol[playerid]) return SeeKick(playerid, "[WAR] Gyógyszer war közben!");
	
	new param[32];
	
	if(GyogyszerTime[playerid] > 0) return SendFormatMessage(playerid,COLOR_LIGHTRED,"A-A ez túl sûrû! %d sec",GyogyszerTime[playerid]);
	
	if(sscanf(params, "s[32]", param)) 
	{
		Msg(playerid,"/gyógyszer [aspirin / cataflan / info /]");
		
		return 1;
	}
	if(egyezik(param, "info"))
	{
		Msg(playerid, "Hogy ne lehessen használni õket lövöldözés közben, akit meglõttek nem tudha használni a termékeket!");
		Msg(playerid,"Aspirin: 10 hp-t tölt /db-ja. Kizárólag akkor használható ha a HP-d több mint 70!");
		Msg(playerid,"Cataflan: 15 HP-t tölt /db-ja. Kizárólag akkor használható ha a HP-d 50 - 80 között van!");
		return 1;
	}
	if(PlayerInfo[playerid][pLoves] > UnixTime)	return SendFormatMessage(playerid,COLOR_LIGHTRED,"Nem használhatod nem rég meglõttek: %d sec",PlayerInfo[playerid][pLoves]-UnixTime);
	if(egyezik(param, "aspirin"))
	{
		if(PlayerInfo[playerid][pAspirin] < 1) return Msg(playerid, "Nincs aspirined!");
		new Float:hp;
		GetPlayerHealth(playerid,hp);
		if(hp < 70.0) return Msg(playerid, "Ez a gyógyszer már kevés!");
		
		Cselekves(playerid,"bevett egy gyógyszert!");
		
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
		if(hp < 50.0) return Msg(playerid, "Ez a gyógyszer már kevés!");
		if(hp > 80.0) return Msg(playerid, "Ez a gyószer már erõs, ehhez túl jól vagy!");
		
		Cselekves(playerid,"bevett egy gyógyszert!");
		
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
		Msg(playerid, "/taxi [lista / fogad / lemond / díj / duty]");
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
			Cselekves(playerid, "visszaöltözött!");
			return 1;
		}
		else
		{
			Taxi[playerid][tDuty] = true;
			OnDuty[playerid] = true;
			
			Taxi[playerid][tFizetes] = 0;
			new string[128];
			format(string, sizeof(string), "Taxi Sofõr %s szolgálatban van, viteldíj: %dFt/Km", ICPlayerName(playerid), FrakcioInfo[FRAKCIO_TAXI][fDij]);
			SendClientMessageToAll(TEAM_GROVE_COLOR,string);
			Msg(playerid, "/taxi lista");
			
			Cselekves(playerid, "átöltözött a munkaruhájába", 0);
			
			Munkaruha(playerid, 1);
			Taxi[playerid][tDuty] = true;
			return 1;
		}
		
	}
	if(egyezik(param, "lista"))
	{
		

		SendClientMessage(playerid, COLOR_WHITE, "======= [Híváslista] =======");
		foreach(Jatekosok, x)
			if(TaxiHivas[x] == 1) SendFormatMessage(playerid, COLOR_GREY, "[%d][%s]", x, ICPlayerName(x));
		SendClientMessage(playerid, COLOR_WHITE, "======= [Híváslista] =======");
		
		return 1;
	}
	if(egyezik(param, "fogad"))
	{
	
		if(Taxi[playerid][tHivas]) return Msg(playerid, "Már fogadtál hívást! Vond vissza ha nem kell! /taxi lemond");
		if(!Taxi[playerid][tDuty]) return Msg(playerid, "Nem  vagy szolgálatban!");
		
		new jatekos;
		foreach(Jatekosok, x)
			if(TaxiHivas[x] == 1) jatekos = x;

		if(TaxiHivas[jatekos] != 1) return Msg(playerid, "Nem hívott taxit!");
		TaxiHivas[jatekos] = 2;
		foreach(Jatekosok, x)
		{
			if(AdminDuty[x] == 0 && ScripterDuty[x] == 0)
				SetPlayerMarkerForPlayer(playerid, x, COLOR_INVISIBLE);
		}
		SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Fogadtad %s hívását!", ICPlayerName(jatekos));
		SendFormatMessage(jatekos, COLOR_LIGHTGREEN, "%s fogadta a hívásod!", ICPlayerName(playerid));
		SendFormatMessageToAll(COLOR_GREEN, "Taxi sofõr %s fogadta %s hívását", ICPlayerName(playerid), ICPlayerName(jatekos));
		SetPlayerMarkerForPlayer(playerid, jatekos, COLOR_YELLOW);
		SetPlayerMarkerForPlayer(jatekos, playerid, COLOR_YELLOW);
		
		TaxiHivasJelzes[playerid] = jatekos;
		Taxi[playerid][tHivas] = true;
		
		new taxiszoveg[64];
		format(taxiszoveg, 64, "Taxisofõr HÍVÁSRA MEGY\nViteldíj: %d Ft / KM",FrakcioInfo[FRAKCIO_TAXI][fDij]);
		
		new vehicleid = GetPlayerVehicleID(playerid);
		if(IsValidDynamic3DTextLabel(TAXITEXT[vehicleid])) DestroyDynamic3DTextLabel(TAXITEXT[vehicleid]), TAXITEXT[vehicleid]=INVALID_3D_TEXT_ID;
		TAXITEXT[vehicleid] = CreateDynamic3DTextLabel(taxiszoveg, COLOR_YELLOW_TAXI, 0.0, 0.0, 2.0, 20.0, INVALID_PLAYER_ID, vehicleid, 1);
		
		return 1;
	
	}
	if(egyezik(param, "lemond"))
	{
		if(!Taxi[playerid][tHivas]) return Msg(playerid, "Nincs mit lemondani!");
		
		Taxi[playerid][tHivas] = false;
		SendFormatMessage(TaxiHivasJelzes[playerid], COLOR_LIGHTGREEN, "Taxisofõr %s lemondta a szállítást, nem megy érted!",ICPlayerName(playerid));
		SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Lemondtad %s hívását!",ICPlayerName(TaxiHivasJelzes[playerid]));
		TaxiHivasJelzes[playerid] = NINCS;
		
		SetPlayerMarkerForPlayer(playerid, TaxiHivasJelzes[playerid], COLOR_INVISIBLE);
		SetPlayerMarkerForPlayer(TaxiHivasJelzes[playerid], playerid, COLOR_INVISIBLE);
		return 1;
	}
	if(egyezik(param, "díj") || egyezik(param,"dij"))
	{
		if(!PlayerInfo[playerid][pLeader]) return Msg(playerid, "Csak leader!");
		if(sscanf(func, "d", FrakcioInfo[FRAKCIO_TAXI][fDij])) return Msg(playerid, "/taxi díj [ára]");
	
		SendFormatMessage(playerid,COLOR_YELLOW,"Egységes díj átírva: %s Ft",FormatInt(FrakcioInfo[FRAKCIO_TAXI][fDij]));
		
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
		Msg(playerid, "/object [funkció]");
		Msg(playerid, "Funkciók: [Go | uj | mod | help | üres | töröl | közel | objecttorles | tábla | mod | felirat | otabla |]");
		Msg(playerid, "mod= módósít");
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
		
		if(atmid < 0 || atmid > MAX_OBJECTSZ) return Msg(playerid, "Hibás object ID.");
		//PlayerInfo[playerid][pTeleportAlatt] = 1;
		SetPlayerPos(playerid, OBJECT[atmid][sPosX], OBJECT[atmid][sPosY], OBJECT[atmid][sPosZ]+1.5);
		SendFormatMessage(playerid,  COLOR_LIGHTGREEN, "* Teleportáltál az object-hez. (ID: %d - Koordínáta: X: %f | Y: %f | Z: %f) ", atmid, OBJECT[atmid][sPosX], OBJECT[atmid][sPosY], OBJECT[atmid][sPosZ]);
	}
	if(egyezik(param, "help"))
	{
			if(IsScripter(playerid))
			{
				Msg(playerid,"11.808-11.999 (19901 kivételével)");
				Msg(playerid,"Robbano: 1225 Sebeség korlátok: 30: 11878 50: 11880 90: 11884 130:11888 Övezet30: 11893 / 11895");
				Msg(playerid,"Bukkanó: 11.915 Villamos: 11.936 Vasút:11.937 Busz: 11.946 Autópálya: 11.808/11.809 Magasság: 11.867");
				Msg(playerid,"kötelezo haladási irány elore: 11.818 elõlre-jobbra: 11.819 elõlre-balra: 11.820 balra: 11.821 jobbra: 11.822");
				Msg(playerid,"Hotdog: 1340 | Italautomata: 1775 | Csokiautomata: 1776 | Szerencsegép: 2754 | Telefon: 1216");
				Msg(playerid,"Szerelõhely: 19898 | SzerelõDuty: 19627 | SignumCars Duty: 11705 |");
				Msg(playerid,"Kameranézõ: 19894 | GraffitiTilt: 19177 | Jegyautomata: 19526 | ArrestHely: 19234 |");
				return 1;
			}
			return 1;	
	}
	if(egyezik(param, "uj"))
	{
		new tipus;
		
		
		if(sscanf(func, "d", tipus))
		{
			Msg(playerid, "/object uj [típus]");
			Msg(playerid, "Hotdog: 1340, | Italautomata: 1775 | Csokiautomata: 1776 | Szerencsegép: 2754 | Telefon: 1216");
			Msg(playerid, "Ha nem írsz id-t automata üresra rakja.");
		}
		new id = NINCS;
		
		if(!IsTerno(playerid))
			Msg(playerid, "HQ-t és NAGY mappokat NE EZZEL CSINÁLJATOK PLEASE!!!");
		
		if(tipus == 11977 || tipus == 11901) return Msg(playerid, "Ez a model nem használható!");
		
		for(new a = 0; a < MAX_OBJECTSZ; a++)
		{
			if(OBJECT[a][sTipus] == 0)
			{
				id = a;
				break;
			}
		}
		
		if(id < 0 || id >= MAX_OBJECTSZ) return Msg(playerid, "Nincs üres hely!");

		new Float:X, Float:Y, Float:Z, Float:A;
		GetPlayerPos(playerid, X, Y, Z);
		GetPlayerFacingAngle(playerid, A);
		
		id=UresObject();
		if(id == NINCS) return Msg(playerid, "Nincs üres hely");

	
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

		SendFormatMessage(playerid,  COLOR_LIGHTGREEN, "* OBJECT lerakva. (ID: %d - Típus: %d Koordínáta: X: %.2f | Y: %.2f | Z: %.2f | A: %.2f | VW: %d | INT: %d) ", id, tipus, OBJECT[id][sPosX], OBJECT[id][sPosY], OBJECT[id][sPosZ], OBJECT[id][sPosA], OBJECT[id][sVw],OBJECT[id][sInt]);
		Streamer_Update(playerid);
		//PlayerInfo[playerid][pTeleportAlatt] = 1;
		SetPlayerPos(playerid, X, Y, Z+3.0);
		
		
		EditDynamicObject(playerid, OBJECT[id][sObjectID]);
		
		ObjectSzerkeszt[playerid] = id;
		
	}
	if(egyezik(param,"otabla"))
	{
		if(!IsTerno(playerid)) return Msg(playerid,"A-A nem kell ennyiszer lerakni, megtalálod õket a reptéren a 155 VW-ben!");
		
	
		
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
			
			if(id < 0 || id >= MAX_OBJECTSZ) return Msg(playerid, "Nincs üres hely!");

			
		
			id=UresObject();
			if(id == NINCS) return Msg(playerid, "Nincs üres hely");

		
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

			//SendFormatMessage(playerid,  COLOR_LIGHTGREEN, "* OBJECT lerakva. (ID: %d - Típus: %d Koordínáta: X: %.2f | Y: %.2f | Z: %.2f | A: %.2f | VW: %d | INT: %d) ", id, tipus, OBJECT[id][sPosX], OBJECT[id][sPosY], OBJECT[id][sPosZ], OBJECT[id][sPosA], OBJECT[id][sVw],OBJECT[id][sInt]);
			Streamer_Update(playerid);
		
			
		
			tolas--;
			INI_Save(INI_TYPE_OBJECT, id);
		}
		Msg(playerid,"Táblák lerakva reptéren az 155-ös VW-ben, felirat: /object felirat");
		return 1;
	}
	if(egyezik(param, "lista"))
	{
		new Float:Stav;
		new Float:PPos[3];
		new Float:tav;
		new torol;
		if(sscanf(func, "fd", Stav,torol)) return Msg(playerid,"/object lista [táv] [töröl =1]");	
	
		if(torol < 0 || torol >1) return Msg(playerid,"töröl 1 nem töröl 0");
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
							SendFormatMessage(playerid,  COLOR_LIGHTGREEN, "Törölve Object: %d",a);
							
							INI_Save(INI_TYPE_OBJECT, a);
						
						
						}
					}
				
				}
			}
		}
	
		Msg(playerid,"Kiírva a közelben lévõ objectek. A chatlogból ki tudod másolni!!!!");
	}
	if(egyezik(param, "felirat"))
	{
	
		new Float:Stav;
		new Float:PPos[3];
		new Float:tav;
		new bool:kikapcsol=false;
		if(sscanf(func, "f", Stav)) return Msg(playerid,"/object felirat [táv]");	
	
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
	if(egyezik(param, "töröl"))
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
		
		if(id < 0 || id >= MAX_OBJECTSZ) return Msg(playerid, "Hibás SORSZÁM ID.");
		
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
		SendFormatMessage(playerid,  COLOR_LIGHTGREEN, "Törölve Object: %d",id);
		
		INI_Save(INI_TYPE_OBJECT, id);
		//SaveOBJECT();
	}
	if(egyezik(param, "üres"))
	{
		new szamlalo;
		for(new a = 0; a < MAX_OBJECTSZ; a++)
		{
			if(OBJECT[a][sTipus] == 0)
			{
				SendFormatMessage(playerid,  COLOR_LIGHTGREEN, "*Üres Object: ID: %d ",a);
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
		Msg(playerid,"a-a nincs KÉSZ");
		
	}
	if(egyezik(param, "közel"))
	{
		SendClientMessage(playerid, COLOR_WHITE, "====[ Legközelebbi object ]=====");
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

		if(legkozelebb == 5000.0) return Msg(playerid, "Nincs találat");

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
	if(PlayerInfo[playerid][pPcarkey] == NINCS && PlayerInfo[playerid][pPcarkey2] == NINCS && PlayerInfo[playerid][pPcarkey3] == NINCS) return Msg(playerid, "Nincs jármûved.");
	if(sscanf(params, "s[32]S()[32]", pm, spm)) { Msg(playerid, "/örökkulcs [ad/elvesz]"); if(Admin(playerid, 1337)) Msg(playerid, "/örökkulcs töröl"); return true; }
	if(egyezik(pm, "ad"))
	{
		if(sscanf(spm, "ri", pid, kid)) return Msg(playerid, "/örökkulcs ad [név/id] [1/2/3]");
		if(pid == INVALID_PLAYER_ID || pid == playerid) return Msg(playerid, "Nem létezõ játékos");
		if(GetDistanceBetweenPlayers(playerid, pid) > 3.0) return Msg(playerid, "Nincs a közeledben a játékos.");
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
		else return Msg(playerid, "Úgy tudom csak 3 jármûved lehet.. nem? :)");
		
		if(CarInfo[jarmu][cKulcsok][0] != NINCS && CarInfo[jarmu][cKulcsok][1] != NINCS) return Msg(playerid,"Csak két pótkulcs van hozzá, amiket már átadtál valakinek!");
		if(PlayerInfo[pid][pKulcsok][0] != NINCS && PlayerInfo[pid][pKulcsok][1] != NINCS && PlayerInfo[pid][pKulcsok][2] != NINCS) return Msg(playerid,"Nála már több mint 3 kulcs van");
		
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
		
		SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Átadtad a jármûved egyik pótkulcsát neki: %s | V-s Rendszám: %d | JármûID: %d", ICPlayerName(pid), jarmu, CarInfo[jarmu][cId]);
		SendFormatMessage(pid, COLOR_LIGHTGREEN, "* %s odaadta a jármûve egyik pótkulcsát neked | V-s Rendszám: %d | JármûID: %d", ICPlayerName(playerid), jarmu, CarInfo[jarmu][cId]);
	}
	elseif(egyezik(pm, "elvesz"))
	{
		if(sscanf(spm, "ri", pid, kid)) return Msg(playerid, "/örökkulcs ad [név/id] [1/2/3]");
		if(pid == INVALID_PLAYER_ID || pid == playerid) return Msg(playerid, "Nem létezõ játékos");
		if(GetDistanceBetweenPlayers(playerid, pid) > 3.0) return Msg(playerid, "Nincs a közeledben a játékos.");
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
		else return Msg(playerid, "Úgy tudom csak 3 jármûved lehet.. nem? :)");
		
		if(CarInfo[jarmu][cKulcsok][0] != PlayerInfo[pid][pID] && CarInfo[jarmu][cKulcsok][1] != PlayerInfo[pid][pID]) return Msg(playerid, "Ehhez a jármuhöz neki nincsen pótkulcsa!");
		if(PlayerInfo[pid][pKulcsok][0] != CarInfo[jarmu][cId] && PlayerInfo[pid][pKulcsok][1] != CarInfo[jarmu][cId] && PlayerInfo[pid][pKulcsok][2] != CarInfo[jarmu][cId]) return Msg(playerid,"Ehhez a jármuhöz neki nincsen pótkulcsa!");
		
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
			
		SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Elvetted a jármuved pótkulcsát tõle: %s | V-s Rendszám: %d | JármuID: %d", ICPlayerName(pid), jarmu, CarInfo[jarmu][cId]);
		SendFormatMessage(pid, COLOR_LIGHTGREEN, "* %s elvette a jármuve pótkulcsát tõled | V-s Rendszám: %d | JármuID: %d", ICPlayerName(playerid), jarmu, CarInfo[jarmu][cId]);
	}
	elseif(egyezik(pm, "töröl") || egyezik(pm, "torol"))
	{
		if(!Admin(playerid, 1337) && !IsScripter(playerid)) return 1;
		new type;
		if(sscanf(spm, "ri", pid, type)) return Msg(playerid, "/örökkulcs töröl [név/id] [1/2/3]");
		if(pid == INVALID_PLAYER_ID) return Msg(playerid, "Nem létezõ játékos");
		switch(type)
		{
			case 1:
			{
				if(CarInfo[PlayerInfo[pid][pKulcsok][0]][cKulcsok][0] == PlayerInfo[pid][pID])
					CarInfo[PlayerInfo[pid][pKulcsok][0]][cKulcsok][0] = NINCS, CarUpdate(PlayerInfo[pid][pKulcsok][0], CAR_Kulcsok1);
				else
					CarInfo[PlayerInfo[pid][pKulcsok][0]][cKulcsok][1] = NINCS, CarUpdate(PlayerInfo[pid][pKulcsok][0], CAR_Kulcsok2);
					
				PlayerInfo[pid][pKulcsok][0] = NINCS;
				
				SendFormatMessage(pid, COLOR_LIGHTRED, "ClassRPG: %s %s elvette az 1. pótkulcsodat", AdminRangNev(playerid), AdminName(playerid));
				SendFormatMessage(playerid, COLOR_LIGHTRED, "ClassRPG: Elvetted %s 1. pótkulcsát", PlayerName(pid));
				format(_tmpString,sizeof(_tmpString),"<< %s %s elvette %s 1. pótkulcsát >>", AdminRangNev(playerid), AdminName(playerid), PlayerName(pid));
				SendMessage(SEND_MESSAGE_ADMIN,_tmpString,COLOR_LIGHTRED,PlayerInfo[playerid][pAdmin]);
			}
			case 2:
			{
				if(CarInfo[PlayerInfo[pid][pKulcsok][1]][cKulcsok][0] == PlayerInfo[pid][pID])
					CarInfo[PlayerInfo[pid][pKulcsok][1]][cKulcsok][0] = NINCS, CarUpdate(PlayerInfo[pid][pKulcsok][1], CAR_Kulcsok1);
				else
					CarInfo[PlayerInfo[pid][pKulcsok][1]][cKulcsok][1] = NINCS, CarUpdate(PlayerInfo[pid][pKulcsok][1], CAR_Kulcsok2);
					
				PlayerInfo[pid][pKulcsok][1] = NINCS;
				
				SendFormatMessage(pid, COLOR_LIGHTRED, "ClassRPG: %s %s elvette az 2. pótkulcsodat", AdminRangNev(playerid), AdminName(playerid));
				SendFormatMessage(playerid, COLOR_LIGHTRED, "ClassRPG: Elvetted %s 2. pótkulcsát", PlayerName(pid));
				
				format(_tmpString,sizeof(_tmpString),"<< %s %s elvette %s 2. pótkulcsát >>", AdminRangNev(playerid), AdminName(playerid), PlayerName(pid));
				
				SendMessage(SEND_MESSAGE_ADMIN,_tmpString,COLOR_LIGHTRED,PlayerInfo[playerid][pAdmin]);
			}
			case 3:
			{
				if(CarInfo[PlayerInfo[pid][pKulcsok][2]][cKulcsok][0] == PlayerInfo[pid][pID])
					CarInfo[PlayerInfo[pid][pKulcsok][2]][cKulcsok][0] = NINCS, CarUpdate(PlayerInfo[pid][pKulcsok][2], CAR_Kulcsok1);
				else
					CarInfo[PlayerInfo[pid][pKulcsok][2]][cKulcsok][1] = NINCS, CarUpdate(PlayerInfo[pid][pKulcsok][2], CAR_Kulcsok2);
					
				PlayerInfo[pid][pKulcsok][2] = NINCS;
				
				SendFormatMessage(pid, COLOR_LIGHTRED, "ClassRPG: %s %s elvette az 3. pótkulcsodat", AdminRangNev(playerid), AdminName(playerid));
				SendFormatMessage(playerid, COLOR_LIGHTRED, "ClassRPG: Elvetted %s 3. pótkulcsát", PlayerName(pid));
			
				
				format(_tmpString,sizeof(_tmpString),"<< %s %s elvette %s 3. pótkulcsát >>", AdminRangNev(playerid), AdminName(playerid), PlayerName(pid));
				SendMessage(SEND_MESSAGE_ADMIN,_tmpString,COLOR_LIGHTRED,PlayerInfo[playerid][pAdmin]);
			}
			default: Msg(playerid, "1/2/3");
		}
	}
	elseif(egyezik(pm, "törölv") || egyezik(pm, "torolv"))
	{
		if(!Admin(playerid, 1337) && !IsScripter(playerid)) return 1;
		new type;
		if(sscanf(spm, "ii", pid, type)) return Msg(playerid, "/örökkulcs törölv [jármûid] [1/2]");
		if(pid == INVALID_VEHICLE_ID) return Msg(playerid, "Nem létezõ jármû");
		
		jarmu = IsAVsKocsi(pid);
		
		if(jarmu == NINCS) return Msg(playerid, "Ez nem egy V-s kocsi!");
		
		switch(type)
		{
			case 1:
			{
				
				CarInfo[jarmu][cKulcsok][0] = NINCS, CarUpdate(jarmu, CAR_Kulcsok1);
				
				SendFormatMessage(playerid, COLOR_LIGHTRED, "ClassRPG: %d (VSID: %d) jármûhöz rendelt kulcsok nullázva", pid, jarmu);
				format(_tmpString,sizeof(_tmpString),"<< %s %d (VSID: %d) jármûhöz rendelt kulcsok nullázva >>", AdminName(playerid), pid, jarmu);
				SendMessage(SEND_MESSAGE_ADMIN,_tmpString,COLOR_LIGHTRED,PlayerInfo[playerid][pAdmin]);
			}
			case 2:
			{
				CarInfo[jarmu][cKulcsok][0] = NINCS, CarUpdate(jarmu, CAR_Kulcsok2);
				
				SendFormatMessage(playerid, COLOR_LIGHTRED, "ClassRPG: %d (VSID: %d) jármûhöz rendelt kulcsok nullázva", pid, jarmu);
				format(_tmpString,sizeof(_tmpString),"<< %s %d (VSID: %d) jármûhöz rendelt kulcsok nullázva >>", AdminName(playerid), pid, jarmu);
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
	if(sscanf(params, "s[32]S()[32]", a, b)) return Msg(playerid, "/vadászengedély [kivált/megnéz]");
	if(egyezik(a, "kivált") || egyezik(a, "kivalt"))
	{
		if(!PlayerToPoint(2, playerid, 362.3623,209.2845,1008.3828)) return Msg(playerid, "Városházán elsõ iroda jobbra! 300,000Ft; 24 hónapig érvényes ((óra))");
		if(PlayerInfo[playerid][pVadaszEngedely] > 0) return Msg(playerid,"Neked van engedélyed!");
		if(!BankkartyaFizet(playerid, 300000)){ Msg(playerid, "A vadászengedély ára: 300,000Ft"); return 1; }
		PlayerInfo[playerid][pVadaszEngedely] = 24;
		Cselekves(playerid, "kiváltott egy vadászengedélyt.");
		Msg(playerid, "Kiváltottad az engedélyt, mostmár mehetsz vadászni!");
	}
	elseif(egyezik(a, "megnéz") || egyezik(a, "megnez"))
	{
		if(PlayerInfo[playerid][pVadaszEngedely] < 1) return Msg(playerid, "Nincs engedélyed!");

		SendClientMessage(playerid, COLOR_GREEN, "====== Vadászlicenc ======");
		SendFormatMessage(playerid, COLOR_GRAD6, "Név: %s", ICPlayerName(playerid));
		SendFormatMessage(playerid, COLOR_GRAD5, "Érvényes: %d hónapig ((óráig))", PlayerInfo[playerid][pVadaszEngedely]);
		Cselekves(playerid, "elõvette az egyik iratát, és megnézte.", 0);
	}
	return 1;
}


ALIAS(vad1sz):vadasz;
CMD:vadasz(playerid, params[])
{
	new a[64];
	if(!AMT(playerid, MUNKA_VADASZ)) return Msg(playerid, "Nem vagy vadász!");
	if(OnDuty[playerid]) return Msg(playerid, "Döntsd elobb el mit dolgozol! ((frakció dutyba nem!))");
	if(sscanf(params, "s[32]", a)) return Msg(playerid, "/vadász [munka/segítség]");
	if(egyezik(a, "munka"))
	{
		if(!IsPlayerInAnyVehicle(playerid))
		{
			if(!PlayerToPoint(5.0, playerid, -1633.1276, -2238.6843, 31.4766))
			{
				SetPlayerCheckpoint(playerid, -1633.1276, -2238.6843, 31.4766, 5.0);
				Msg(playerid, "Nem vagy a vadásztelepen!");
				return 1;
			}
			if(Munkaban[playerid] != MUNKA_VADASZ)
			{
				if(PlayerInfo[playerid][pVadaszEngedely] == 0) return Msg(playerid, "Nincs vadászengedélyed!");
				if(PlayerInfo[playerid][pPayCheck] > 1700000) return Msg(playerid, "Túl sok vadat lõttél már ki, nem adhatsz le többet!");
				
				Munkaban[playerid] = MUNKA_VADASZ;
				if(PlayerInfo[playerid][pSex] == 2) SetPlayerSkin(playerid, 201);
				else SetPlayerSkin(playerid, 161);
				Msg(playerid, "Felvetted a ruhádat, így munkába álltál. A munka végzéséhez segítség: /vadász segítség");
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
				Msg(playerid, "Visszavetted a civil ruhádat, így már nem dolgozol.");
			}
		}
		else Msg(playerid, "Jármûben NEM!");
		return 1;
	}
	elseif(egyezik(a, "segitseg") || egyezik(a, "segítség"))
	{
		SendClientMessage(playerid, COLOR_GREEN, "=====[ Vadászat munka használati útmutató ]=====");
		SendClientMessage(playerid, COLOR_WHITE, "A munkát elkezdeni a /vadász munka paranccsal tudod.");
		SendClientMessage(playerid, COLOR_WHITE, "A munkához fegyvert neked kell vásárolnod, ami rifle vagy shotgun lehet.");
		SendClientMessage(playerid, COLOR_GRAD6, "A munkához vadászengedély szükséges, amit az Oktatóktól tudsz kiváltani 48 játszott órára 150.000 Ft-ért, vagy 300.000 Ft-ért 24 játszott órára a városházán.");
		SendClientMessage(playerid, COLOR_GRAD6, "Egyszerre 25db õz található az erdõben.");
		SendClientMessage(playerid, COLOR_GRAD5, "Új õz akkor kerül elõ, ha egy új vadász áll munkába; automatikusan 10 percenként spawnol egy õz.");
		SendClientMessage(playerid, COLOR_GRAD5, "Miután elejtettük az õzt, 5 perc áll rendelkezésre, hogy a talált golyót eltávolítsuk belõle. (Y gomb)");
		SendClientMessage(playerid, COLOR_GRAD4, "Miután eltávolítottuk a lövedéket, az állatot lehetõségünk van felpakolni egy Yosemite-ra (Y gomb), amire egyszerre 5 állat fér.");
		SendClientMessage(playerid, COLOR_GRAD4, "Az állat elszállítására korlátlan idõ áll rendelkezésre, de továbbra is csak maximum 25 õz lesz megtalálható.");
		SendClientMessage(playerid, COLOR_GRAD3, "Az állatokat ezután egy megadott GPS pontra kell elvinni, ahol az erdészeten átveszik az állatokat. (Y gomb)");
		SendClientMessage(playerid, COLOR_GRAD3, "A fizetés az állat sérülési állapotától, és a fegyver lövedékének fajtájától függ, és a lövés távolságától.");
		SendClientMessage(playerid, COLOR_GRAD2, "Vigyázz! Ha túl közel mész egy állathoz, akkor az elszalad!");
		SendClientMessage(playerid, COLOR_GRAD2, "Vigyázz! Az elejtett õzeket bárki el tudja szállítani saját profitjára!");
		SendClientMessage(playerid, COLOR_GRAD2, "Figyelem! Ha 'N' gombot megnyomod kocsiban akkor megmutatja hova kell vinni az õzeket!");
	}
	elseif(egyezik(a, "go"))
	{
		if(!IsScripter(playerid)) return 1;
		new kac_kac_kukac = GetClosestDeer(playerid);
		SetPlayerCheckpoint(playerid, ArrExt(DeerInfo[kac_kac_kukac][dPos]), 2.0);
		SendFormatMessage(playerid, -1, "Megjelölve a(z) #%d számú õzhöz (te lusta disznó! :P)", kac_kac_kukac);
	}
	elseif(egyezik(a, "create"))
	{
		if(!IsScripter(playerid)) return 1;
		CreateDeer();
		SendClientMessage(playerid, -1, "Kész");
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
		Msg(playerid, "Frakción kívüli karakterskin beállítva - bekapcsolva");
	}
	else
	{
		AdminDutySkin[playerid] = 0;
		if(PlayerInfo[playerid][pChar] > 0 && OnDuty[playerid] || PlayerInfo[playerid][pChar] > 0 && !LegalisSzervezetTagja(playerid) && !Civil(playerid))
			SetPlayerSkin(playerid, PlayerInfo[playerid][pChar]);
		else
			SetPlayerSkin(playerid, PlayerInfo[playerid][pModel]);
		Msg(playerid, "Frakciós karakterskin beállítva - kikapcsolva");
	}
	return 1;
}

ALIAS(korm1ny):kormany;
CMD:kormany(playerid, params[])
{
	new func[10];
	new func2[60];

	if(sscanf(params, "s[12]S()[60]", func,func2)) return Msg(playerid,"/kormány [stat / frakcióadó / akitüntetés / rendezvény / settax / givetax / adók]");

	if(!LMT(playerid, FRAKCIO_ONKORMANYZAT) && !Admin(playerid, 1337)) return SendClientMessage(playerid, COLOR_GREY, "Nem vagy (Al)Elnök!");
			
			
	if(egyezik(func,"adók"))
	{
		if(!Munkarang(playerid,8)) return Msg(playerid, "A-A");
		
		
		new message[128];
		new osszeg;
		SendClientMessage(playerid,COLOR_RED,"<< ========== (Be nem fizetett adók) ========== >>");
		
		foreach(Jatekosok, s)
		{
				
			if(!IsPlayerConnected(s) || IsPlayerNPC(s) || PlayerInfo[s][pAdokIdo] > 1) continue;
			
			osszeg = PlayerInfo[s][pAdokOsszeg];
			format(message, sizeof(message), "%s befizetési határidõ: %d fizetés Összeg: %sFt", ICPlayerName(s), PlayerInfo[s][pAdokIdo], FormatNumber(osszeg, 0, ',' ));
			SendFormatMessage(playerid,COLOR_RED,"%s", message);
		}
		SendClientMessage(playerid,COLOR_RED,"<<========== (Be nem fizetett adók) ========== >>");	
		
		
		return 1;
	}
	if(egyezik(func,"stat"))
	{
		if(!Munkarang(playerid,10)) return Msg(playerid, "A-A");
		//FrakcioAdoStat();
		
		SendClientMessage(playerid,COLOR_WHITE,"============= Frakció adó bevételek =================");
		new heti,havi,ossz;
		for(new yx; yx < MAX_ADO_FRAKCIO; yx++)
		{
			new id=AdozoFrakciok[yx];
			SendFormatMessage(playerid, COLOR_YELLOW, "[%d]%s Heti: %s Ft, Havi %s Ft, Összes: %s Ft",id,Szervezetneve[id-1][0], FormatInt(FrakcioInfo[id][fHeti]),FormatInt(FrakcioInfo[id][fHavi]),FormatInt(FrakcioInfo[id][fOsszes]));
			heti +=FrakcioInfo[id][fHeti];
			havi +=FrakcioInfo[id][fHavi];
			ossz +=FrakcioInfo[id][fOsszes];
		}
		SendFormatMessage(playerid, COLOR_YELLOW, "Összesen: Heti %s Ft, Havi %s Ft, Összesen: %s Ft",FormatInt(heti),FormatInt(havi),FormatInt(ossz));
		SendClientMessage(playerid,COLOR_WHITE,"Heti: Vasárnap 23:44 - 59-között, Havi: Minden hó utolsó nap 23:44 -59 -között => nullázódik");
	}
	if(egyezik(func,"givetax"))
    {
		new string[128];
		if(PlayerInfo[playerid][pLeader] != FRAKCIO_ONKORMANYZAT) return SendClientMessage(playerid, COLOR_GREY, "Nem vagy az Elnök!");

		if(FrakcioInfo[FRAKCIO_ONKORMANYZAT][fPenz] < 1) return SendClientMessage(playerid, COLOR_GREY, "A kasszában nincs pénz!");

		new penz,frakcio;
		if(sscanf(func2, "dd", frakcio,penz))
		{
		
			SendClientMessage(playerid, COLOR_GREY, "Használata: /kormány givetax [frakcióID] [pénz]");
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
			
			
			SendFormatMessage(playerid, COLOR_GREY, "Speciális: 30: Civil[%d Fõ], 31: SWAT[%d Fõ], 32: Kisebbség[%d Fõ]",civil,swatos,kisebsegi);
			SendFormatMessage(playerid, COLOR_GREY, "Kassza: %s Ft", FormatNumber( FrakcioInfo[FRAKCIO_ONKORMANYZAT][fPenz] , 0, ',' ));
			return 1;
		}
	
		if(penz > FrakcioInfo[FRAKCIO_ONKORMANYZAT][fPenz])
		{
			SendFormatMessage(playerid, COLOR_GREY, "A kasszában nincs % sFt, csak %s Ft!", FormatNumber( penz , 0, ',' ), FormatNumber( FrakcioInfo[FRAKCIO_ONKORMANYZAT][fPenz], 0, ',' ));
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
					format(string, sizeof(string), "* A nagylelkû (al)elnök átutalta az adók egy részét a %s számára! %s Ft került a széfbe!", Szervezetneve[frakcio-1][0],FormatInt(penz));
					SendClientMessage(i, COLOR_LIGHTBLUE, string);
				}
			}

			FrakcioInfo[frakcio][fPenz] += penz;
			
			FrakcioInfo[FRAKCIO_ONKORMANYZAT][fPenz] -= penz;
			SendFormatMessage(playerid, COLOR_GREY, " Átutaltál %s Ft-ot a %s számára.", FormatInt(penz),Szervezetneve[frakcio-1][0]);
			SendClientMessageToAll(COLOR_GOV1, "|___________ Class City Kormány felhívása ___________|");
			SendFormatMessageToAll(COLOR_GOV2,"%s: A kormány támogata a(z) %s szervezetet %s Ft-al!", ICPlayerName(playerid),Szervezetneve[frakcio-1][0],FormatInt(penz));

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
				if(penz*Tagok > FrakcioInfo[FRAKCIO_ONKORMANYZAT][fPenz]) return SendFormatMessage(playerid, COLOR_YELLOW,"Nincs elég pénz a kaszzában: %s FT",FormatNumber(FrakcioInfo[FRAKCIO_ONKORMANYZAT][fPenz]));

				foreach(Jatekosok, i)
				{
					if(IsPlayerConnected(i))
					{

						if(LMT(i, FRAKCIO_SONSOFANARCHY) || LMT(i, FRAKCIO_COSANOSTRA) || LMT(i, FRAKCIO_YAKUZA) || LMT(i, FRAKCIO_VAGOS) || LMT(i, FRAKCIO_AZTEC) || LMT(i, FRAKCIO_GSF))
						{
							format(string, sizeof(string), "* A nagylelkû (al)elnök segélyt küldött a kisebbség számára. A részed: %s Ft",FormatInt(penz));
							SendClientMessage(i, COLOR_LIGHTBLUE, string);
							GiveMoney(i, penz);
							FrakcioInfo[FRAKCIO_ONKORMANYZAT][fPenz] -= penz;
						}
					}
				}
				SendClientMessageToAll(COLOR_GOV1, "|___________ Class City Kormány felhívása ___________|");
				SendFormatMessageToAll(COLOR_GOV2,"%s: A kormány támogatott %d fõ kisebbségi-t, fejenként %s Ft-al!", ICPlayerName(playerid),Tagok,FormatInt(penz));
			}
			else
			{
				SendClientMessage(playerid, COLOR_GREY, "Nincs fennt Bandás/Mafiás!");
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
				if(penz*Tagok > FrakcioInfo[FRAKCIO_ONKORMANYZAT][fPenz]) return SendFormatMessage(playerid, COLOR_YELLOW,"Nincs elég pénz a kaszzában: %s FT",FormatNumber(FrakcioInfo[FRAKCIO_ONKORMANYZAT][fPenz]));
				foreach(Jatekosok, i)
				{
					
					if(PlayerInfo[i][pSwattag] == 1)
					{
						format(string, sizeof(string), "* A nagylelkû (al)elnök átutalta az adók egy részét a SWAT számára. A részed: %s Ft",FormatInt(penz));
						SendClientMessage(i, COLOR_LIGHTBLUE, string);
						GiveMoney(i, penz);
						FrakcioInfo[FRAKCIO_ONKORMANYZAT][fPenz] -= penz;
					}
					
				}
			
				SendClientMessageToAll(COLOR_GOV1, "|___________ Class City Kormány felhívása ___________|");
				SendFormatMessageToAll(COLOR_GOV2,"%s: A kormány támogatott %d fõ SWAT-ost, fejenként %s Ft-al!", ICPlayerName(playerid),Tagok,FormatInt(penz));

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
				if(penz*Tagok > FrakcioInfo[FRAKCIO_ONKORMANYZAT][fPenz]) return SendFormatMessage(playerid, COLOR_YELLOW,"Nincs elég pénz a kaszzában: %s FT",FormatNumber(FrakcioInfo[FRAKCIO_ONKORMANYZAT][fPenz]));
				
				foreach(Jatekosok, i)
				{
					if(!PlayerInfo[i][pMember] && !PlayerInfo[i][pLeader])
					{
						format(string, sizeof(string), "* A nagylelkû (al)elnök átutalta az adók egy részét a civilek számára. A részed: %s Ft",FormatInt(penz));
						SendClientMessage(i, COLOR_LIGHTBLUE, string);
						GiveMoney(i, penz);
						FrakcioInfo[FRAKCIO_ONKORMANYZAT][fPenz] -= penz;
					}
				}
				SendClientMessageToAll(COLOR_GOV1, "|___________ Class City Kormány felhívása ___________|");
				SendFormatMessageToAll(COLOR_GOV2,"%s: A kormány támogatott %d fõ civilt, fejenként %s Ft-al!", ICPlayerName(playerid),Tagok,FormatInt(penz));
			}
			else
			{
				SendClientMessage(playerid, COLOR_GREY, "Nincs fennt civil!");
				return 1;
			}
		}
		else Msg(playerid,"Hibás ID!");
		
		return 1;
	}
	if(egyezik(func, "settax"))
    {
		if(!Admin(playerid, 5555)) return Msg(playerid,"Súlyos vissza  élések miatt tiltva");
		if(!LMT(playerid, FRAKCIO_ONKORMANYZAT))
			return SendClientMessage(playerid, COLOR_GREY, "Nem vagy (Al)Elnök!");

		//if(!Munkarang(playerid, 5))
		//	return SendClientMessage(playerid, COLOR_GREY, "Minimum Alelnöki rang szükséges!");

		new ado;
		if(sscanf(func2, "d", ado))
			return SendFormatMessage(playerid, COLOR_LIGHTRED, "Használat: /kormány settax [adó (50 = normál, 100 = kétszeres, stb...] - Jelenlegi adó: %d", TaxValue), 1;

		//if(ado < 0 || ado > 100)
		//	return Msg(playerid, "Min. 0, max 100 - A normál adó az 50, a 100 az adó kétszerese, 0 esetén nincs adó");

		if(ado < ADO_MIN || ado > ADO_MAX)
		{
			SendFormatMessage(playerid, COLOR_LIGHTRED, "%s: Minimum %d, maximum %d - A normál adó 50, a kétszerese 100, másfélszerese 75, stb.", SERVER_NEV, ADO_MIN, ADO_MAX);
			return 1;
		}

		if(ado >= 100 && !IsJim(playerid))
			return Msg(playerid, "Csak 75ig állíthatod - ha ennél nagyobbra szeretnéd, szólj Clintnek");

		SendFormatMessage(playerid, COLOR_LIGHTBLUE, "* Az új adó mostmár %d! (A régi %d volt)", ado, TaxValue);
		TaxValue = ado;
	    return 1;
	}
	if(egyezik(func, "rendezvény"))
	{
		if(FloodCheck(playerid)) return 1;
		new result[128];
		new string[128];
		if(sscanf(func2, "s[128]", result))
			return SendClientMessage(playerid, COLOR_WHITE, "Használat: /kormány rendezvény [Szöveg]");

		if(HirdetesSzidasEllenorzes(playerid, result, "/rendezvény", ELLENORZES_MINDKETTO)) return 1;

		if(LMT(playerid, FRAKCIO_ONKORMANYZAT) || IsAdmin(playerid))
		{
			format(string, sizeof(string), "[%d] **Rendezvény** %s", playerid, result);
			SendMessage(SEND_MESSAGE_OOCOFF, string, COLOR_RENDEZVENY);
			printf("%s\n", string);
		}
		
		return 1;
	}
	if(egyezik(func, "akituntetes") || egyezik(func, "akitüntetés"))
	{
	    new player;
		new szam;
		new string[128];
		if(sscanf(func2, "rd", player, szam))
		{
			Msg(playerid,"Használata: /kormány akitüntetés [Név / ID] [1-6]");
			SendFormatMessage(playerid,COLOR_RED,"Kitüntetések: 1. %s | 2. %s | 3. %s ",KormanyKituntetes[1],KormanyKituntetes[2],KormanyKituntetes[3]);
			SendFormatMessage(playerid,COLOR_RED,"Kitüntetések: 4. %s | 5. %s | 6. %s",KormanyKituntetes[4],KormanyKituntetes[5],KormanyKituntetes[6]);
			return 1;
		}	
		
		if(player == INVALID_PLAYER_ID) return Msg(playerid, "Nincs ilyen játékos.");
		if(player == playerid) return Msg(playerid, "Nana..");
		if(GetDistanceBetweenPlayers(playerid,player) > 3) return Msg(playerid, "Õ nincs a közeledben!");
		
		if(!LMT(player, FRAKCIO_ONKORMANYZAT)) return Msg(playerid, "Õ nem tag!");
		if(szam > 6 || szam < 1) return Msg(playerid,"A kitüntetés száma 1 és 6 között lehet!");
		SendFormatMessage(player, COLOR_LIGHTBLUE, "Kitünetést kaptál tõle: %s", ICPlayerName(playerid));
		SendFormatMessage(player, COLOR_LIGHTBLUE, "Kitüntetésed: %s", KormanyKituntetes[szam]);
		format(string, sizeof(string), "Rádió: %s kitüntette %s -t | Kitüntetése: %s **", ICPlayerName(playerid), ICPlayerName(player), KormanyKituntetes[szam]);
		SendMessage(SEND_MESSAGE_RADIO, string, COLOR_RED, FRAKCIO_ONKORMANYZAT);
		PlayerInfo[player][pKormanyKituntetes] = szam;
		
		return 1;
	}
	if(egyezik(func,"frakcióadó") || egyezik(func,"frakcioado"))
	{
		if(!Munkarang(playerid, 5))
			return SendClientMessage(playerid, COLOR_GREY, "Minimum Alelnöki rang szükséges!");
			
		new ado;
		new szam;
		if(sscanf(func2, "dd", szam, ado))
		{
			Msg(playerid, "Használat: /frakcióadó [frakció száma] [szorzó]");
			
			SendClientMessage(playerid, COLOR_LIGHTRED,"=================Frakciók adói=================");
			for(new yx; yx < MAX_ADO_FRAKCIO; yx++)
			{
				new id=AdozoFrakciok[yx];
				new string[128];
				format(string,sizeof(string),"[%d] %s || Jelenlegi adója: %d %% || Széf: %s Ft",id,Szervezetneve[id-1][0], FrakcioInfo[id][fAdo],FormatInt(FrakcioInfo[id][fPenz]));
				SendFormatMessage(playerid, COLOR_LIGHTRED, "%s", string);
			
			}	
			SendClientMessage(playerid, COLOR_LIGHTRED,"=================Frakciók adói=================");
			return 1;
		}

		new bool:ellen;
		for(new x; x < MAX_ADO_FRAKCIO; x++)
		{	
			if(AdozoFrakciok[x] == szam) 
				ellen=true;
		}
		if(!ellen) return Msg(playerid, "Ez a frakció nem adózik!");
		
		if(ado < 0 || ado > 30)
		{
			Msg(playerid,"Az adónak 0-30 % között kell lenni-e!");
			return 1;
		}
		
			
		SendFormatMessage(playerid, COLOR_LIGHTBLUE, "A(z) %s adója: %d ", Szervezetneve[szam-1][0], ado);
		FrakcioInfo[szam][fAdo] = ado;
		return 1;
	}

	return 1;
}
ALIAS(pil4taradar):pilotaradar;
CMD:pilotaradar(playerid, params[])
{
	new veh = GetPlayerVehicleID(playerid), pilotak = 0;
	if(!AMT(playerid, MUNKA_PILOTA)) return Msg(playerid, "Nem vagy pilóta!");
	if(!IsAPRepulo(veh)) return Msg(playerid, "Nem utasszállító gépben ülsz!");
	if(Repul[playerid] == 0) return Msg(playerid, "Nincs leszerzõdtetett szállításod, így nem kérheted le a többi pilóta helyzetét!");
	if(!PilotaRadar[playerid])
	{
		foreach(Jatekosok, p)
		{
			new allveh = GetPlayerVehicleID(p);
			if(AMT(p, MUNKA_PILOTA) && IsAPRepulo(allveh) && Repul[p] == 1)
				SetPlayerMarkerForPlayer(playerid, p, 0xFFFFFF44), pilotak++;
		}
		PilotaRadar[playerid] = 1;
		SendFormatMessage(playerid, COLOR_GREEN, "Pilótaradar bekapcsolva, összesen %d pilóta van a légtérben!", pilotak);
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
		SendClientMessage(playerid, COLOR_GREEN, "Pilótaradar kikapcsolva");
	}
	return 1;
}

CMD:roncsderbi(playerid, params[])
{
	if(RoncsDerbi[rInditva]) return Msg(playerid, "Jelenleg foglalt a pálya!");
	
	if(!PlayerToPoint(5,playerid,-2110.9934,-444.3106,38.7344,0,0)) return Msg(playerid, "Nem vagy San Fiero stadion bejáratánál! ((az i betunél))");
	
	if(RoncsDerbi[rIndit]) return Msg(playerid, "Várj egy kicsit még, most indít valaki!");
	
	if(!RoncsDerbi[rFutam])
	{
		if(!BankkartyaFizet(playerid,DERBI_ARA,false)) return SendFormatMessage(playerid, COLOR_YELLOW,"A verseny ára %s Ft!",FormatInt(DERBI_ARA));
		RoncsDerbi[rIndit] = true;
		ShowPlayerDialog(playerid, DIALOG_DERBI_KOCSIVALASZT, DIALOG_STYLE_LIST, "Roncsderbi, szabad a kocsi választás?!", "IGEN - a csatlakozó játékos adja meg milyen kocsival lesz.\nNEM - Te adod meg milyen kocsival legyenek a játékosok.", "Tovább","Mégse");
	}
	else
	{
		if(RoncsDerbi[rJatekos] >= 20) return Msg(playerid, "A versenyen maximum 20-an lehetnek, betelt a pálya!");
		if(RoncsDerbi[rModel] == NINCS)
		{
			if(!BankkartyaFizet(playerid,DERBI_ARA,false)) return SendFormatMessage(playerid, COLOR_YELLOW,"A verseny ára %s Ft!",FormatInt(DERBI_ARA));
			ShowPlayerDialog(playerid, DIALOG_DERBI_KOCSIMODEL, DIALOG_STYLE_INPUT, "Roncsderbi", "Milyen jármûvel akarsz indulni? ((model ID vagy NÉV))", "Tovább", "Mégse");

		}
		else
		{
			if(!BankkartyaFizet(playerid,DERBI_ARA,false)) return SendFormatMessage(playerid, COLOR_YELLOW,"A verseny ára %s Ft!",FormatInt(DERBI_ARA));
			
			new string[256];
			format(string,sizeof(string),"RoncsDerbi futam információk / szabályok\nMindenki azonos típusú kocsival indul\nKocsiból kiszálni tilos!\nSzerencsés futamot!");
			ShowPlayerDialog(playerid, DIALOG_DERBI_BELEPES, DIALOG_STYLE_MSGBOX, "DERBI INFÓ", string, "Kezdés", "");
			
		
		}
	}

	return 1;
}


ALIAS(mulat1s):mulatas;
CMD:mulatas(playerid, params[])
{
	if(SQLID(playerid) == 1 || SQLID(playerid) == 5637 || SQLID(playerid) == 8172424 || IsTerno(playerid) || IsAmos(playerid) || IsJim(playerid))
	{
		if(MulatasTime > UnixTime) return SendFormatMessage(playerid, COLOR_LIGHTRED, "ClassRPG: Pihenj kicsit, még nem mulathatsz! Legközelebb %d másodperc múlva kezdhetsz el mulatozni", MulatasTime-UnixTime);
		MulatasTime = UnixTime+3600;
		ABroadCastFormat(Pink, 1, "<< %s mulatós császár jelen van - mulatás elkezdve! >>", AdminName(playerid));
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
	if(sscanf(params, "u", who)) return Msg(playerid, "/tiltások [Név/ID]");
	SendFormatMessage(playerid, COLOR_ADD, "==========[ %s tiltásai ]==========", PlayerName(who));
	if(PlayerInfo[who][pFrakcioTiltIdo] >0) SendFormatMessage(playerid,COLOR_YELLOW,"El van tiltva a frakcióktól %d órára! Oka: %s",PlayerInfo[who][pFrakcioTiltIdo],PlayerInfo[who][pFrakcioTiltOk]), count++;
	if(PlayerInfo[who][pJogsiTiltIdo] >0 && !egyezik(PlayerInfo[who][pJogsiTiltOk],"NINCS")) SendFormatMessage(playerid,COLOR_YELLOW,"El van tiltva a vizsgáztatástól %d órára! Oka: %s",PlayerInfo[who][pJogsiTiltIdo],PlayerInfo[who][pJogsiTiltOk]), count++;
	if(PlayerInfo[who][pFegyverTiltIdo] >0) SendFormatMessage(playerid,COLOR_YELLOW,"El van tiltva a fegyver használattól %d órára! Oka: %s",PlayerInfo[who][pFegyverTiltIdo],PlayerInfo[who][pFegyverTiltOk]), count++;
	if(PlayerInfo[who][pAsTilt] == 1) SendFormatMessage(playerid, COLOR_YELLOW, "El van tiltva az adminsegédtõl! Oka: %s", PlayerInfo[who][pAsTiltOk]), count++;
	if(PlayerInfo[who][pLeaderTilt] == 1) SendFormatMessage(playerid, COLOR_YELLOW, "El van tiltva a leaderségtõl! Oka: %s", PlayerInfo[who][pLeaderoka]), count++;
	if(PlayerInfo[who][pReportTilt] == 1) SendFormatMessage(playerid, COLOR_YELLOW, "El van tiltva a reportolástól! Oka: %s", PlayerInfo[who][pReportTiltOk]), count++;
	if(count == 0) SendFormatMessage(playerid, COLOR_WHITE, "%s-nak/nek nincs egyetlen tiltása sem.", PlayerName(who));
	else SendFormatMessage(playerid, COLOR_ADD, "==========[ %s tiltásai ]==========", PlayerName(who));
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
		return SeeBan(playerid, 0, NINCS, "Cufolva vagy viszbe Paintbalba menés!" );
	new pm[32], subpm[32], teremid, jatekido, ido;
	if(!PlayerToPoint(15, playerid, BizzInfo[BIZ_PB][bEntranceX], BizzInfo[BIZ_PB][bEntranceY], BizzInfo[BIZ_PB][bEntranceZ])) return Msg(playerid,"Nem vagy Paintball Terem elott!");
	if(sscanf(params, "s[32]S()[32]", pm,subpm)) return Msg(playerid, "/paintball [indítás/nevezés/termek/indítások/fegyverek]");
	if(PlayerInfo[playerid][pPaintballKitiltva] == 1) return Msg(playerid, "Te el vagy tiltva a paintballozástól!");
	if(BizzInfo[BIZ_PB][bLocked] == 1) return Msg(playerid, "Jelenleg zárva vagyunk!");
	if(egyezik(pm,"indítás") || egyezik(pm,"inditas"))
	{
		if(sscanf(subpm, "ddd", teremid,ido,jatekido)) return Msg(playerid,"Használata: /pb indítás [Terem ID] [Nevezési Idõ(percben)] [Játékidõ(percben)]");
		if(teremid < 1 || teremid > 4) return Msg(playerid, "A teremid minimum 1-es idjû, maximum 4-es idjû!");
		if(PaintballInfo[teremid][pbMerkozesIdo] >= UnixTime && PaintballInfo[teremid][pbHasznalva]) return Msg(playerid, "Ez a terem foglalt!");
		if(PaintballInfo[teremid][pbNevezesIdo] > 0) return Msg(playerid,"Már van nevezés folyamatban erre a teremre!");
		if(ido < 1 || ido > 5) return Msg(playerid,"A nevezési idõ, legalább 1 perc és maximum 5 perc!");
		if(jatekido < 1 || jatekido > 30) return Msg(playerid, "A játékidõ minimum 1 perc, maximum 30 perc!");
		if(!BankkartyaFizet(playerid, BizzInfo[BIZ_PB][bEntranceCost], false)) return Msg(playerid,"Nemtudod kifezetni a mérkõzés árát");
		PaintballInfo[teremid][pbNevezesek] = 1;
		PaintballInfo[teremid][pbNevezesIdo] = ido*60;
		PaintballInfo[teremid][pbMerkozesIdo][1] = jatekido;
		Paintballnevezve[playerid] = true;
		PBTerem[playerid] = teremid;
		
		SendClientMessage(playerid,COLOR_LIGHTRED,"Paintball: Globális nevezést indítottál! Ha eltávolodsz a bejárattól, akkor a nevezésed megszûnik!");
		foreach(Jatekosok, p)
		{
			if(gPB[p] == 0) continue;
			SendClientMessage(p,COLOR_DYELLOW,"=====[ Paintball ]=====");
			SendClientMessage(p,COLOR_WHITE,"Hamarosan paintball mérkõzés indul, részletek a terem bejárata elõtt!");
			SendFormatMessage(p,COLOR_WHITE,"TeremID: %d | Nevezési díj: %s Ft | Játékidõ: %d perc | Nevezettek száma: %d db | Nevezni lehet még: %d másodpercig", teremid, FormatInt(BizzInfo[BIZ_PB][bEntranceCost]*PaintballInfo[teremid][pbMerkozesIdo][1]), jatekido, PaintballInfo[teremid][pbNevezesek],PaintballInfo[teremid][pbNevezesIdo]);
		}
	}
	elseif(egyezik(pm,"nevezés") || egyezik(pm,"nevezes"))	
	{
		if(sscanf(subpm, "d", teremid)) return Msg(playerid,"Használata /pb nevezés [teremid]");
		if(teremid < 1 || teremid > 4) return Msg(playerid, "A teremid minimum 1-es idjû, maximum 4-es idjû!");
		if(PaintballInfo[teremid][pbNevezesek] == 0) return Msg(playerid,"Jelenleg nincs nevezés folyamatban!");
		if(Paintballnevezve[playerid] || PBTerem[playerid] != 0) return Msg(playerid, "Te már nevezve vagy!");
		if(!BankkartyaFizet(playerid, BizzInfo[BIZ_PB][bEntranceCost], false)) return Msg(playerid,"Nemtudod kifezetni a mérkõzés árát");
		PaintballInfo[teremid][pbNevezesek]++;
		Paintballnevezve[playerid] = true;
		PBTerem[playerid] = teremid;
		SendFormatMessage(playerid,COLOR_LIGHTRED,"Paintball: Neveztél a mérkõzésre, jelenleg %d ember van benevezve. Ha eltávolodsz a bejárattól, akkor a nevezésed megszûnik!",PaintballInfo[teremid][pbNevezesek]);
		foreach(Jatekosok, p)
		{
			if(Paintballnevezve[p])
				SendFormatMessage(p,COLOR_LIGHTRED,"Paintball: Egy ember nevezett a mérkõzésre, jelenleg %d ember van benevezve.",PaintballInfo[teremid][pbNevezesek]);
		}
		
		
	}
	elseif(egyezik(pm, "termek"))
	{
		SendClientMessage(playerid, COLOR_DYELLOW, "=====[ Paintball Termek ]=====");
		SendFormatMessage(playerid, COLOR_WHITE, "1: Hagyományos, RC Battlefieldes terem (%s"COL_FEHER")", (PaintballInfo[1][pbHasznalva]) ? (""COL_PIROS"Foglalt") : (""COL_VZOLD"Szabad"));
		SendFormatMessage(playerid, COLOR_WHITE, "2: Sivatagi, elhagyatott, kis falu (%s"COL_FEHER")", (PaintballInfo[2][pbHasznalva]) ? (""COL_PIROS"Foglalt") : (""COL_VZOLD"Szabad"));
		SendFormatMessage(playerid, COLOR_WHITE, "3: Sivatagi, nagy méretû terem (%s"COL_FEHER")", (PaintballInfo[3][pbHasznalva]) ? (""COL_PIROS"Foglalt") : (""COL_VZOLD"Szabad"));
		SendFormatMessage(playerid, COLOR_WHITE, "4: Elhagyatott Area51-es terem (%s"COL_FEHER")", (PaintballInfo[4][pbHasznalva]) ? (""COL_PIROS"Foglalt") : (""COL_VZOLD"Szabad"));
	}
	elseif(egyezik(pm, "indítások"))
	{
		SendClientMessage(playerid, COLOR_DYELLOW, "=====[ Paintball termek, ahová lehet nevezni ]=====");
		for(new teremidk = 1; teremidk < sizeof(PaintballInfo); teremidk++)
		{
			if(PaintballInfo[teremidk][pbNevezesek] > 0)
				SendFormatMessage(playerid, COLOR_WHITE, "TeremID: %d | Nevezési díj: %s Ft | Játékidõ: %d perc | Nevezettek száma: %d db | Nevezni lehet még: %d másodpercig", teremidk, FormatInt(BizzInfo[BIZ_PB][bEntranceCost]*PaintballInfo[teremidk][pbMerkozesIdo][1]), jatekido, PaintballInfo[teremidk][pbNevezesek],PaintballInfo[teremidk][pbNevezesIdo]);
			else continue;
		}
	}
	elseif(egyezik(pm, "fegyverek"))
	{
		Msg(playerid, "Állítsd be, hogy milyen fegyverekkel szeretnél játszani!", true, COLOR_DYELLOW);
		tformat(256, "Pisztoly (Jelenleg: "COL_CITROM"%s"COL_FEHER")\nKönnyû lõfegyver (Jelenleg: "COL_CITROM"%s"COL_FEHER")\nSörétes puska (Jelenleg: "COL_CITROM"%s"COL_FEHER")\nNehéz lofegyver (Jelenleg: "COL_CITROM"%s"COL_FEHER")", GunName(PlayerInfo[playerid][pPBFegyver][0]), GunName(PlayerInfo[playerid][pPBFegyver][1]), GunName(PlayerInfo[playerid][pPBFegyver][2]), GunName(PlayerInfo[playerid][pPBFegyver][3]));
		ShowPlayerDialog(playerid, DIALOG_PAINTBALL_FEGYVEREK, DIALOG_STYLE_LIST, "Paintball", _tmpString, "Kiválaszt", "Mégse");
		Freeze(playerid);
	}
	elseif(egyezik(pm, "kitilt") && (PlayerInfo[playerid][pPbiskey] == BIZ_PB || PlayerInfo[playerid][pBizniszKulcs] == BIZ_PB))
	{
		new jatekos, ok[128];
		if(sscanf(subpm, "rs[128]", jatekos, ok)) return Msg(playerid, "/paintball kitilt [Név/ID] [Oka]");
		if(jatekos == INVALID_PLAYER_ID) return Msg(playerid, "Nem létezõ név/id");
		if(PlayerInfo[playerid][pPaintballKitiltva] == 0)
		{
			PlayerInfo[jatekos][pPaintballKitiltva] = 1;
			SendFormatMessage(playerid, COLOR_LIGHTRED, "%s eltiltva a paintballozástól!", ICPlayerName(jatekos));
			SendFormatMessage(jatekos, COLOR_LIGHTRED, "%s eltiltott a paintballozástól, oka: %s", ICPlayerName(playerid), ok);
		}
		else
		{
			PlayerInfo[jatekos][pPaintballKitiltva] = 0;
			SendFormatMessage(playerid, COLOR_LIGHTRED, "%s tiltása feloldva, újra paintballozhat!", ICPlayerName(jatekos));
			SendFormatMessage(jatekos, COLOR_LIGHTRED, "%s feloldotta a tiltást, ismét paintballozhatsz! Oka: %s", ICPlayerName(playerid), ok);
		}
	}
	return 1;
}

CMD:setweaponskill(playerid, params[])
{
	if(!Admin(playerid, 1337) && !IsScripter(playerid)) return 1;
	new kinek, mit[32], mennyire, skill;
	if(sscanf(params, "rs[32]d", kinek,mit,mennyire)) return Msg(playerid,"Használata: /setweaponskill [Játékos/ID] [Pisztoly/Silenced/Deagle/Shotgun/Combat/Mp5/AK47/M4/Sniper] [Érték]");
	if(!IsPlayerConnected(kinek) || kinek == INVALID_PLAYER_ID) return Msg(playerid,"Nincs ilyen játékos");
	if(egyezik(mit,"pisztoly")) skill = 0; 
	else if(egyezik(mit,"silenced")) skill = 1;
	else if(egyezik(mit,"deagle")) skill= 2; 
	else if(egyezik(mit,"shotgun")) skill = 3;
	else if(egyezik(mit,"combat")) skill = 5;
	else if(egyezik(mit,"mp5")) skill = 7;
	else if(egyezik(mit,"ak47")) skill= 8;
	else if(egyezik(mit,"m4")) skill = 9;
	else if(egyezik(mit,"sniper")) skill = 10;
	else return Msg(playerid, "/setweaponskill [Játékos/ID] [Pisztoly/Silenced/Deagle/Shotgun/Combat/Mp5/AK47/M4/Sniper] [Érték]");
	PlayerInfo[kinek][pFegyverSkillek][skill] = mennyire;
	FegyverSkillFrissites(kinek);
	SendFormatMessage(kinek,COLOR_LIGHTBLUE,"%s átírta a fegyver tapasztalatod! Fegyver: %s - Beállított érték: %d", AdminName(playerid), mit, PlayerInfo[kinek][pFegyverSkillek][skill]);
	SendFormatMessage(playerid,COLOR_LIGHTBLUE,"Átírtad %s fegyver tapasztalatát! Fegyver: %s - Beállított érték: %d", PlayerName(kinek), mit, PlayerInfo[kinek][pFegyverSkillek][skill]);
	
	format(_tmpString,sizeof(_tmpString),"<< %s átírta %s fegyverskilljét - Fegyver: %s - Beállított érték: %d >>", AdminName(playerid), PlayerName(kinek), mit, PlayerInfo[kinek][pFegyverSkillek][skill]);
	
	SendMessage(SEND_MESSAGE_ADMIN,_tmpString,COLOR_LIGHTRED,PlayerInfo[playerid][pAdmin]);
	return 1;
}

ALIAS(idgscripter):ideiglenesscripter;
CMD:ideiglenesscripter(playerid, params[])
{
	new kit;
	if(!IsScripter(playerid)) return 1;
	if(IdgScripter[playerid]) return Msg(playerid, "Ugye nem gondoltad komolyan, hogy te fogsz másokat kinevezni?");
	if(sscanf(params, "u", kit)) return Msg(playerid, "/ideiglenesscripter [Név/ID] - Ezt a jogot csak relogig kapja meg!");
	if(kit == INVALID_PLAYER_ID) return Msg(playerid, "Hibás név/id");
	if(IsScripter(kit) && !IdgScripter[kit]) return Msg(playerid, "Õ scripter, nem nevezheted ki!");
	if(!Admin(kit, 1337)) return Msg(playerid, "Nem adhatsz neki scripter jogot, mert az adminszintje kisebb, mint 1337!");
	if(IdgScripter[kit])
	{
		IdgScripter[kit] = false;
		SendFormatMessage(playerid, COLOR_LIGHTRED, "ClassRPG: Elvetted %stõl az ideiglenes scripter jogosultságot", PlayerName(kit));
		SendFormatMessage(kit, COLOR_LIGHTRED, "ClassRPG: %s elvette tõled az ideiglenes scripter jogosultságot", PlayerName(playerid));
	}
	else
	{
		IdgScripter[kit] = true;
		SendFormatMessage(playerid, COLOR_LIGHTRED, "ClassRPG: Kinevezted %st ideiglenes scripternek - ez a jogosultságot relogig kapja meg", PlayerName(kit));
		SendFormatMessage(kit, COLOR_LIGHTRED, "ClassRPG: %s kinevezett ideiglenes scripternek, így használhatod a scripter jogait", PlayerName(playerid));
		SendClientMessage(kit, COLOR_LIGHTRED, "ClassRPG: Ezt a jogosultságot csak relogig használhatod, vagy amíg el nem veszi tõled egy scripter");
	}
	return 1;
}

ALIAS(k5zmunk1sok):kozmunkasok;
CMD:kozmunkasok(playerid, params[])
{
	if(!IsACop(playerid) && !Admin(playerid, 1)) return Msg(playerid, "Nem vagy rendõr!");
	new c = 0;
	SendClientMessage(playerid, COLOR_ADD, "=====[ Közmunkán lévõ emberek ]=====");
	foreach(Jatekosok, x)
	{
		if(PlayerInfo[x][pKozmunka] != 0)
		{
			if(PlayerInfo[x][pKozmunkaIdo] != 0)
				SendFormatMessage(playerid, COLOR_GREEN, "[%d]%s | Hátralévõ játszott órák: %d | Hátralévõ letöltendõ büntetés: %d másodperc", x, ICPlayerName(x), PlayerInfo[x][pKozmunkaIdo], PlayerInfo[x][pJailTime]);
			else
			{
				SendFormatMessage(playerid, COLOR_RED, "[%d]%s | Elhalasztotta a közmunkát | Körözés kiadva", x, ICPlayerName(x));
				if(!egyezik(PlayerCrime[x][pVad], "Közmunka elhalasztása")) SetPlayerCriminal(x, 255, "Közmunka elhalasztása");
			}
			c++;
		}
	}
	if(c == 0) SendClientMessage(playerid, COLOR_WHITE, "Jelenleg nincs közmunkán lévõ ember.");
	return 1;
}

CMD:carresi(playerid, params[])
{
	if(CarRespawnSzamlalo != NINCS) return Msg(playerid, "Épp folyamatban van egy carresi!");
	SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Legközelebb %d mp múlva lesz car resi.", ResiCounter);
	if(Admin(playerid, 6)) Msg(playerid, "Carresihez parancsok: /acrmost /acr /acr30");
	return 1;
}

ALIAS(l6szerek):loszerek;
CMD:loszerek(playerid, params[])
{
	if(!MunkaLeader(playerid, FRAKCIO_SCPD) && !MunkaLeader(playerid, FRAKCIO_SFPD) && !MunkaLeader(playerid, FRAKCIO_FBI) && !MunkaLeader(playerid, FRAKCIO_KATONASAG) && !MunkaLeader(playerid, FRAKCIO_NAV) && !Admin(playerid, 1)) return 1;
	
	new frakcio;
	SendClientMessage(playerid, COLOR_LIGHTGREEN, "================================ LÕSZEREK ================================");
	
	if(PlayerInfo[playerid][pLeader] == FRAKCIO_NAV || Admin(playerid, 1))
	{
		frakcio=FRAKCIO_SCPD;
		SendFormatMessage(playerid, COLOR_WHITE, "[LSPD] Deagle: %d | Silenced: %d | Mp5: %d | M4: %d | Shotgun: %d",FrakcioInfo[frakcio][fDeagle][1], FrakcioInfo[frakcio][fSilenced][1], FrakcioInfo[frakcio][fMp5][1], FrakcioInfo[frakcio][fM4][1], FrakcioInfo[frakcio][fShotgun][1]);
		SendFormatMessage(playerid, COLOR_WHITE, "[LSPD] Sniper: %d | Combat: %d | Rifle: %d | Ejtõernyõ: %d",FrakcioInfo[frakcio][fSniper][1], FrakcioInfo[frakcio][fCombat][1],FrakcioInfo[frakcio][fRifle][1],FrakcioInfo[frakcio][fParachute]);
		//
		frakcio=FRAKCIO_SFPD;
		SendFormatMessage(playerid, COLOR_WHITE, "[SFPD] Deagle: %d | Silenced: %d | Mp5: %d | M4: %d | Shotgun: %d",FrakcioInfo[frakcio][fDeagle][1], FrakcioInfo[frakcio][fSilenced][1], FrakcioInfo[frakcio][fMp5][1], FrakcioInfo[frakcio][fM4][1], FrakcioInfo[frakcio][fShotgun][1]);
		SendFormatMessage(playerid, COLOR_WHITE, "[SFPD] Sniper: %d | Combat: %d | Rifle: %d | Ejtõernyõ: %d",FrakcioInfo[frakcio][fSniper][1], FrakcioInfo[frakcio][fCombat][1],FrakcioInfo[frakcio][fRifle][1],FrakcioInfo[frakcio][fParachute]);
		//
		frakcio=FRAKCIO_FBI;
		SendFormatMessage(playerid, COLOR_WHITE, "[FBI] Deagle: %d | Silenced: %d | Mp5: %d | M4: %d | Shotgun: %d",FrakcioInfo[frakcio][fDeagle][1], FrakcioInfo[frakcio][fSilenced][1], FrakcioInfo[frakcio][fMp5][1], FrakcioInfo[frakcio][fM4][1], FrakcioInfo[frakcio][fShotgun][1]);
		SendFormatMessage(playerid, COLOR_WHITE, "[FBI] Sniper: %d | Combat: %d | Rifle: %d | Ejtõernyõ: %d",FrakcioInfo[frakcio][fSniper][1], FrakcioInfo[frakcio][fCombat][1],FrakcioInfo[frakcio][fRifle][1],FrakcioInfo[frakcio][fParachute]);
		//
		frakcio=FRAKCIO_NAV;
		SendFormatMessage(playerid, COLOR_WHITE, "[NAV] Deagle: %d | Silenced: %d | Mp5: %d | M4: %d | Shotgun: %d",FrakcioInfo[frakcio][fDeagle][1], FrakcioInfo[frakcio][fSilenced][1], FrakcioInfo[frakcio][fMp5][1], FrakcioInfo[frakcio][fM4][1], FrakcioInfo[frakcio][fShotgun][1]);
		SendFormatMessage(playerid, COLOR_WHITE, "[NAV] Sniper: %d | Combat: %d | Rifle: %d | Ejtõernyõ: %d",FrakcioInfo[frakcio][fSniper][1], FrakcioInfo[frakcio][fCombat][1],FrakcioInfo[frakcio][fRifle][1],FrakcioInfo[frakcio][fParachute]);
		//
		frakcio=FRAKCIO_KATONASAG;
		SendFormatMessage(playerid, COLOR_WHITE, "[CCMF] Deagle: %d | Silenced: %d | Mp5: %d | M4: %d | Shotgun: %d",FrakcioInfo[frakcio][fDeagle][1], FrakcioInfo[frakcio][fSilenced][1], FrakcioInfo[frakcio][fMp5][1], FrakcioInfo[frakcio][fM4][1], FrakcioInfo[frakcio][fShotgun][1]);
		SendFormatMessage(playerid, COLOR_WHITE, "[CCMF] Sniper: %d | Combat: %d | Rifle: %d | Ejtõernyõ: %d",FrakcioInfo[frakcio][fSniper][1], FrakcioInfo[frakcio][fCombat][1],FrakcioInfo[frakcio][fRifle][1],FrakcioInfo[frakcio][fParachute]);
	}
	else
	{
		switch(PlayerInfo[playerid][pLeader])
		{
			case FRAKCIO_SCPD:
			{
				frakcio=FRAKCIO_SCPD;
				SendFormatMessage(playerid, COLOR_WHITE, "[LSPD] Deagle: %d | Silenced: %d | Mp5: %d | M4: %d | Shotgun: %d",FrakcioInfo[frakcio][fDeagle][1], FrakcioInfo[frakcio][fSilenced][1], FrakcioInfo[frakcio][fMp5][1], FrakcioInfo[frakcio][fM4][1], FrakcioInfo[frakcio][fShotgun][1]);
				SendFormatMessage(playerid, COLOR_WHITE, "[LSPD] Sniper: %d | Combat: %d | Rifle: %d | Ejtõernyõ: %d",FrakcioInfo[frakcio][fSniper][1], FrakcioInfo[frakcio][fCombat][1],FrakcioInfo[frakcio][fRifle][1],FrakcioInfo[frakcio][fParachute]);
			}
			case FRAKCIO_SFPD:
			{
				frakcio=FRAKCIO_SFPD;
				SendFormatMessage(playerid, COLOR_WHITE, "[SFPD] Deagle: %d | Silenced: %d | Mp5: %d | M4: %d | Shotgun: %d",FrakcioInfo[frakcio][fDeagle][1], FrakcioInfo[frakcio][fSilenced][1], FrakcioInfo[frakcio][fMp5][1], FrakcioInfo[frakcio][fM4][1], FrakcioInfo[frakcio][fShotgun][1]);
				SendFormatMessage(playerid, COLOR_WHITE, "[SFPD] Sniper: %d | Combat: %d | Rifle: %d | Ejtõernyõ: %d",FrakcioInfo[frakcio][fSniper][1], FrakcioInfo[frakcio][fCombat][1],FrakcioInfo[frakcio][fRifle][1],FrakcioInfo[frakcio][fParachute]);
			}
			case FRAKCIO_FBI:
			{
				frakcio=FRAKCIO_FBI;
				SendFormatMessage(playerid, COLOR_WHITE, "[FBI] Deagle: %d | Silenced: %d | Mp5: %d | M4: %d | Shotgun: %d",FrakcioInfo[frakcio][fDeagle][1], FrakcioInfo[frakcio][fSilenced][1], FrakcioInfo[frakcio][fMp5][1], FrakcioInfo[frakcio][fM4][1], FrakcioInfo[frakcio][fShotgun][1]);
				SendFormatMessage(playerid, COLOR_WHITE, "[FBI] Sniper: %d | Combat: %d | Rifle: %d | Ejtõernyõ: %d",FrakcioInfo[frakcio][fSniper][1], FrakcioInfo[frakcio][fCombat][1],FrakcioInfo[frakcio][fRifle][1],FrakcioInfo[frakcio][fParachute]);
			}
			case FRAKCIO_NAV:
			{
				frakcio=FRAKCIO_NAV;
				SendFormatMessage(playerid, COLOR_WHITE, "[NAV] Deagle: %d | Silenced: %d | Mp5: %d | M4: %d | Shotgun: %d",FrakcioInfo[frakcio][fDeagle][1], FrakcioInfo[frakcio][fSilenced][1], FrakcioInfo[frakcio][fMp5][1], FrakcioInfo[frakcio][fM4][1], FrakcioInfo[frakcio][fShotgun][1]);
				SendFormatMessage(playerid, COLOR_WHITE, "[NAV] Sniper: %d | Combat: %d | Rifle: %d | Ejtõernyõ: %d",FrakcioInfo[frakcio][fSniper][1], FrakcioInfo[frakcio][fCombat][1],FrakcioInfo[frakcio][fRifle][1],FrakcioInfo[frakcio][fParachute]);
			}
			case FRAKCIO_KATONASAG:
			{
				frakcio=FRAKCIO_KATONASAG;
				SendFormatMessage(playerid, COLOR_WHITE, "[KATONASÁG] Deagle: %d | Silenced: %d | Mp5: %d | M4: %d | Shotgun: %d",FrakcioInfo[frakcio][fDeagle][1], FrakcioInfo[frakcio][fSilenced][1], FrakcioInfo[frakcio][fMp5][1], FrakcioInfo[frakcio][fM4][1], FrakcioInfo[frakcio][fShotgun][1]);
				SendFormatMessage(playerid, COLOR_WHITE, "[KATONASÁG] Sniper: %d | Combat: %d | Rifle: %d | Ejtõernyõ: %d",FrakcioInfo[frakcio][fSniper][1], FrakcioInfo[frakcio][fCombat][1],FrakcioInfo[frakcio][fRifle][1],FrakcioInfo[frakcio][fParachute]);
			}
		}
	}
	SendClientMessage(playerid, COLOR_LIGHTGREEN,"================================ LÕSZEREK ================================");
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
		SendFormatMessage(playerid, COLOR_WHITE, "[LSPD] Sniper: %d | Combat: %d | Rifle: %d | Ejtõernyõ: %d",FrakcioInfo[frakcio][fSniper][0], FrakcioInfo[frakcio][fCombat][0],FrakcioInfo[frakcio][fRifle][0],FrakcioInfo[frakcio][fParachute]);
		//
		frakcio=FRAKCIO_SFPD;
		SendFormatMessage(playerid, COLOR_WHITE, "[SFPD] Deagle: %d | Silenced: %d | Mp5: %d | M4: %d | Shotgun: %d",FrakcioInfo[frakcio][fDeagle][0], FrakcioInfo[frakcio][fSilenced][0], FrakcioInfo[frakcio][fMp5][0], FrakcioInfo[frakcio][fM4][0], FrakcioInfo[frakcio][fShotgun][0]);
		SendFormatMessage(playerid, COLOR_WHITE, "[SFPD] Sniper: %d | Combat: %d | Rifle: %d | Ejtõernyõ: %d",FrakcioInfo[frakcio][fSniper][0], FrakcioInfo[frakcio][fCombat][0],FrakcioInfo[frakcio][fRifle][0],FrakcioInfo[frakcio][fParachute]);
		//
		frakcio=FRAKCIO_FBI;
		SendFormatMessage(playerid, COLOR_WHITE, "[FBI] Deagle: %d | Silenced: %d | Mp5: %d | M4: %d | Shotgun: %d",FrakcioInfo[frakcio][fDeagle][0], FrakcioInfo[frakcio][fSilenced][0], FrakcioInfo[frakcio][fMp5][0], FrakcioInfo[frakcio][fM4][0], FrakcioInfo[frakcio][fShotgun][0]);
		SendFormatMessage(playerid, COLOR_WHITE, "[FBI] Sniper: %d | Combat: %d | Rifle: %d | Ejtõernyõ: %d",FrakcioInfo[frakcio][fSniper][0], FrakcioInfo[frakcio][fCombat][0],FrakcioInfo[frakcio][fRifle][0],FrakcioInfo[frakcio][fParachute]);
		//
		frakcio=FRAKCIO_NAV;
		SendFormatMessage(playerid, COLOR_WHITE, "[NAV] Deagle: %d | Silenced: %d | Mp5: %d | M4: %d | Shotgun: %d",FrakcioInfo[frakcio][fDeagle][0], FrakcioInfo[frakcio][fSilenced][0], FrakcioInfo[frakcio][fMp5][0], FrakcioInfo[frakcio][fM4][0], FrakcioInfo[frakcio][fShotgun][0]);
		SendFormatMessage(playerid, COLOR_WHITE, "[NAV] Sniper: %d | Combat: %d | Rifle: %d | Ejtõernyõ: %d",FrakcioInfo[frakcio][fSniper][0], FrakcioInfo[frakcio][fCombat][0],FrakcioInfo[frakcio][fRifle][0],FrakcioInfo[frakcio][fParachute]);
		//
		frakcio=FRAKCIO_KATONASAG;
		SendFormatMessage(playerid, COLOR_WHITE, "[CCMF] Deagle: %d | Silenced: %d | Mp5: %d | M4: %d | Shotgun: %d",FrakcioInfo[frakcio][fDeagle][0], FrakcioInfo[frakcio][fSilenced][0], FrakcioInfo[frakcio][fMp5][0], FrakcioInfo[frakcio][fM4][0], FrakcioInfo[frakcio][fShotgun][0]);
		SendFormatMessage(playerid, COLOR_WHITE, "[CCMF] Sniper: %d | Combat: %d | Rifle: %d | Ejtõernyõ: %d",FrakcioInfo[frakcio][fSniper][0], FrakcioInfo[frakcio][fCombat][0],FrakcioInfo[frakcio][fRifle][0],FrakcioInfo[frakcio][fParachute]);
	}
	else
	{
		switch(PlayerInfo[playerid][pLeader])
		{
			case FRAKCIO_SCPD:
			{
				frakcio=FRAKCIO_SCPD;
				SendFormatMessage(playerid, COLOR_WHITE, "[LSPD] Deagle: %d | Silenced: %d | Mp5: %d | M4: %d | Shotgun: %d",FrakcioInfo[frakcio][fDeagle][0], FrakcioInfo[frakcio][fSilenced][0], FrakcioInfo[frakcio][fMp5][0], FrakcioInfo[frakcio][fM4][0], FrakcioInfo[frakcio][fShotgun][0]);
				SendFormatMessage(playerid, COLOR_WHITE, "[LSPD] Sniper: %d | Combat: %d | Rifle: %d | Ejtõernyõ: %d",FrakcioInfo[frakcio][fSniper][0], FrakcioInfo[frakcio][fCombat][0],FrakcioInfo[frakcio][fRifle][0],FrakcioInfo[frakcio][fParachute]);
			}
			case FRAKCIO_SFPD:
			{
				frakcio=FRAKCIO_SFPD;
				SendFormatMessage(playerid, COLOR_WHITE, "[SFPD] Deagle: %d | Silenced: %d | Mp5: %d | M4: %d | Shotgun: %d",FrakcioInfo[frakcio][fDeagle][0], FrakcioInfo[frakcio][fSilenced][0], FrakcioInfo[frakcio][fMp5][0], FrakcioInfo[frakcio][fM4][0], FrakcioInfo[frakcio][fShotgun][0]);
				SendFormatMessage(playerid, COLOR_WHITE, "[SFPD] Sniper: %d | Combat: %d | Rifle: %d | Ejtõernyõ: %d",FrakcioInfo[frakcio][fSniper][0], FrakcioInfo[frakcio][fCombat][0],FrakcioInfo[frakcio][fRifle][0],FrakcioInfo[frakcio][fParachute]);
			}
			case FRAKCIO_FBI:
			{
				frakcio=FRAKCIO_FBI;
				SendFormatMessage(playerid, COLOR_WHITE, "[FBI] Deagle: %d | Silenced: %d | Mp5: %d | M4: %d | Shotgun: %d",FrakcioInfo[frakcio][fDeagle][0], FrakcioInfo[frakcio][fSilenced][0], FrakcioInfo[frakcio][fMp5][0], FrakcioInfo[frakcio][fM4][0], FrakcioInfo[frakcio][fShotgun][0]);
				SendFormatMessage(playerid, COLOR_WHITE, "[FBI] Sniper: %d | Combat: %d | Rifle: %d | Ejtõernyõ: %d",FrakcioInfo[frakcio][fSniper][0], FrakcioInfo[frakcio][fCombat][0],FrakcioInfo[frakcio][fRifle][0],FrakcioInfo[frakcio][fParachute]);
			}
			case FRAKCIO_NAV:
			{
				frakcio=FRAKCIO_NAV;
				SendFormatMessage(playerid, COLOR_WHITE, "[NAV] Deagle: %d | Silenced: %d | Mp5: %d | M4: %d | Shotgun: %d",FrakcioInfo[frakcio][fDeagle][0], FrakcioInfo[frakcio][fSilenced][0], FrakcioInfo[frakcio][fMp5][0], FrakcioInfo[frakcio][fM4][0], FrakcioInfo[frakcio][fShotgun][0]);
				SendFormatMessage(playerid, COLOR_WHITE, "[NAV] Sniper: %d | Combat: %d | Rifle: %d | Ejtõernyõ: %d",FrakcioInfo[frakcio][fSniper][0], FrakcioInfo[frakcio][fCombat][0],FrakcioInfo[frakcio][fRifle][0],FrakcioInfo[frakcio][fParachute]);
			}
			case FRAKCIO_KATONASAG:
			{
				frakcio=FRAKCIO_KATONASAG;
				SendFormatMessage(playerid, COLOR_WHITE, "[KATONASÁG] Deagle: %d | Silenced: %d | Mp5: %d | M4: %d | Shotgun: %d",FrakcioInfo[frakcio][fDeagle][0], FrakcioInfo[frakcio][fSilenced][0], FrakcioInfo[frakcio][fMp5][0], FrakcioInfo[frakcio][fM4][0], FrakcioInfo[frakcio][fShotgun][0]);
				SendFormatMessage(playerid, COLOR_WHITE, "[KATONASÁG] Sniper: %d | Combat: %d | Rifle: %d | Ejtõernyõ: %d",FrakcioInfo[frakcio][fSniper][0], FrakcioInfo[frakcio][fCombat][0],FrakcioInfo[frakcio][fRifle][0],FrakcioInfo[frakcio][fParachute]);
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
	SendClientMessage(playerid, COLOR_LIGHTGREEN, "================================ GUMILÖVEDÉKEK ================================");
	
	if(PlayerInfo[playerid][pLeader] == FRAKCIO_NAV || Admin(playerid, 1))
	{
		frakcio=FRAKCIO_SCPD;
		SendFormatMessage(playerid, COLOR_WHITE, "[LSPD] Deagle: %d | Silenced: %d | Mp5: %d | M4: %d | Shotgun: %d",FrakcioInfo[frakcio][fDeagle][3], FrakcioInfo[frakcio][fSilenced][3], FrakcioInfo[frakcio][fMp5][3], FrakcioInfo[frakcio][fM4][3], FrakcioInfo[frakcio][fShotgun][3]);
		SendFormatMessage(playerid, COLOR_WHITE, "[LSPD] Sniper: %d | Combat: %d | Rifle: %d | Ejtõernyõ: %d",FrakcioInfo[frakcio][fSniper][3], FrakcioInfo[frakcio][fCombat][3],FrakcioInfo[frakcio][fRifle][3],FrakcioInfo[frakcio][fParachute]);
		//
		frakcio=FRAKCIO_SFPD;
		SendFormatMessage(playerid, COLOR_WHITE, "[SFPD] Deagle: %d | Silenced: %d | Mp5: %d | M4: %d | Shotgun: %d",FrakcioInfo[frakcio][fDeagle][3], FrakcioInfo[frakcio][fSilenced][3], FrakcioInfo[frakcio][fMp5][3], FrakcioInfo[frakcio][fM4][3], FrakcioInfo[frakcio][fShotgun][3]);
		SendFormatMessage(playerid, COLOR_WHITE, "[SFPD] Sniper: %d | Combat: %d | Rifle: %d | Ejtõernyõ: %d",FrakcioInfo[frakcio][fSniper][3], FrakcioInfo[frakcio][fCombat][3],FrakcioInfo[frakcio][fRifle][3],FrakcioInfo[frakcio][fParachute]);
		//
		frakcio=FRAKCIO_FBI;
		SendFormatMessage(playerid, COLOR_WHITE, "[FBI] Deagle: %d | Silenced: %d | Mp5: %d | M4: %d | Shotgun: %d",FrakcioInfo[frakcio][fDeagle][3], FrakcioInfo[frakcio][fSilenced][3], FrakcioInfo[frakcio][fMp5][3], FrakcioInfo[frakcio][fM4][3], FrakcioInfo[frakcio][fShotgun][3]);
		SendFormatMessage(playerid, COLOR_WHITE, "[FBI] Sniper: %d | Combat: %d | Rifle: %d | Ejtõernyõ: %d",FrakcioInfo[frakcio][fSniper][3], FrakcioInfo[frakcio][fCombat][3],FrakcioInfo[frakcio][fRifle][3],FrakcioInfo[frakcio][fParachute]);
		//
		frakcio=FRAKCIO_NAV;
		SendFormatMessage(playerid, COLOR_WHITE, "[NAV] Deagle: %d | Silenced: %d | Mp5: %d | M4: %d | Shotgun: %d",FrakcioInfo[frakcio][fDeagle][3], FrakcioInfo[frakcio][fSilenced][3], FrakcioInfo[frakcio][fMp5][3], FrakcioInfo[frakcio][fM4][3], FrakcioInfo[frakcio][fShotgun][3]);
		SendFormatMessage(playerid, COLOR_WHITE, "[NAV] Sniper: %d | Combat: %d | Rifle: %d | Ejtõernyõ: %d",FrakcioInfo[frakcio][fSniper][3], FrakcioInfo[frakcio][fCombat][3],FrakcioInfo[frakcio][fRifle][3],FrakcioInfo[frakcio][fParachute]);
		//
		frakcio=FRAKCIO_KATONASAG;
		SendFormatMessage(playerid, COLOR_WHITE, "[CCMF] Deagle: %d | Silenced: %d | Mp5: %d | M4: %d | Shotgun: %d",FrakcioInfo[frakcio][fDeagle][3], FrakcioInfo[frakcio][fSilenced][3], FrakcioInfo[frakcio][fMp5][3], FrakcioInfo[frakcio][fM4][3], FrakcioInfo[frakcio][fShotgun][3]);
		SendFormatMessage(playerid, COLOR_WHITE, "[CCMF] Sniper: %d | Combat: %d | Rifle: %d | Ejtõernyõ: %d",FrakcioInfo[frakcio][fSniper][3], FrakcioInfo[frakcio][fCombat][3],FrakcioInfo[frakcio][fRifle][3],FrakcioInfo[frakcio][fParachute]);
	}
	else
	{
		switch(PlayerInfo[playerid][pLeader])
		{
			case FRAKCIO_SCPD:
			{
				frakcio=FRAKCIO_SCPD;
				SendFormatMessage(playerid, COLOR_WHITE, "[LSPD] Deagle: %d | Silenced: %d | Mp5: %d | M4: %d | Shotgun: %d",FrakcioInfo[frakcio][fDeagle][3], FrakcioInfo[frakcio][fSilenced][3], FrakcioInfo[frakcio][fMp5][3], FrakcioInfo[frakcio][fM4][3], FrakcioInfo[frakcio][fShotgun][3]);
				SendFormatMessage(playerid, COLOR_WHITE, "[LSPD] Sniper: %d | Combat: %d | Rifle: %d | Ejtõernyõ: %d",FrakcioInfo[frakcio][fSniper][3], FrakcioInfo[frakcio][fCombat][3],FrakcioInfo[frakcio][fRifle][3],FrakcioInfo[frakcio][fParachute]);
			}
			case FRAKCIO_SFPD:
			{
				frakcio=FRAKCIO_SFPD;
				SendFormatMessage(playerid, COLOR_WHITE, "[SFPD] Deagle: %d | Silenced: %d | Mp5: %d | M4: %d | Shotgun: %d",FrakcioInfo[frakcio][fDeagle][3], FrakcioInfo[frakcio][fSilenced][3], FrakcioInfo[frakcio][fMp5][3], FrakcioInfo[frakcio][fM4][3], FrakcioInfo[frakcio][fShotgun][3]);
				SendFormatMessage(playerid, COLOR_WHITE, "[SFPD] Sniper: %d | Combat: %d | Rifle: %d | Ejtõernyõ: %d",FrakcioInfo[frakcio][fSniper][3], FrakcioInfo[frakcio][fCombat][3],FrakcioInfo[frakcio][fRifle][3],FrakcioInfo[frakcio][fParachute]);
			}
			case FRAKCIO_FBI:
			{
				frakcio=FRAKCIO_FBI;
				SendFormatMessage(playerid, COLOR_WHITE, "[FBI] Deagle: %d | Silenced: %d | Mp5: %d | M4: %d | Shotgun: %d",FrakcioInfo[frakcio][fDeagle][3], FrakcioInfo[frakcio][fSilenced][3], FrakcioInfo[frakcio][fMp5][3], FrakcioInfo[frakcio][fM4][3], FrakcioInfo[frakcio][fShotgun][3]);
				SendFormatMessage(playerid, COLOR_WHITE, "[FBI] Sniper: %d | Combat: %d | Rifle: %d | Ejtõernyõ: %d",FrakcioInfo[frakcio][fSniper][3], FrakcioInfo[frakcio][fCombat][3],FrakcioInfo[frakcio][fRifle][3],FrakcioInfo[frakcio][fParachute]);
			}
			case FRAKCIO_NAV:
			{
				frakcio=FRAKCIO_NAV;
				SendFormatMessage(playerid, COLOR_WHITE, "[NAV] Deagle: %d | Silenced: %d | Mp5: %d | M4: %d | Shotgun: %d",FrakcioInfo[frakcio][fDeagle][3], FrakcioInfo[frakcio][fSilenced][3], FrakcioInfo[frakcio][fMp5][3], FrakcioInfo[frakcio][fM4][3], FrakcioInfo[frakcio][fShotgun][3]);
				SendFormatMessage(playerid, COLOR_WHITE, "[NAV] Sniper: %d | Combat: %d | Rifle: %d | Ejtõernyõ: %d",FrakcioInfo[frakcio][fSniper][3], FrakcioInfo[frakcio][fCombat][3],FrakcioInfo[frakcio][fRifle][3],FrakcioInfo[frakcio][fParachute]);
			}
			case FRAKCIO_KATONASAG:
			{
				frakcio=FRAKCIO_KATONASAG;
				SendFormatMessage(playerid, COLOR_WHITE, "[KATONASÁG] Deagle: %d | Silenced: %d | Mp5: %d | M4: %d | Shotgun: %d",FrakcioInfo[frakcio][fDeagle][3], FrakcioInfo[frakcio][fSilenced][3], FrakcioInfo[frakcio][fMp5][3], FrakcioInfo[frakcio][fM4][3], FrakcioInfo[frakcio][fShotgun][3]);
				SendFormatMessage(playerid, COLOR_WHITE, "[KATONASÁG] Sniper: %d | Combat: %d | Rifle: %d | Ejtõernyõ: %d",FrakcioInfo[frakcio][fSniper][3], FrakcioInfo[frakcio][fCombat][3],FrakcioInfo[frakcio][fRifle][3],FrakcioInfo[frakcio][fParachute]);
			}
		}
	}
	SendClientMessage(playerid, COLOR_LIGHTGREEN,"================================ GUMILÖVEDÉKEK ================================");
	return 1;
}

ALIAS(rakt1r):raktar;
CMD:raktar(playerid, params[])
{
	new pm[32], subpm[64], subby[64], mit[32], mennyit, melo = PlayerInfo[playerid][pMember], fkid, szeflog[256], hour;
	gettime(hour);
	if(FloodCheck(playerid)) return 1;
	if(Civil(playerid) && !IsScripter(playerid)) return Msg(playerid, "Nem tartozol frakcióhoz.");
	if(sscanf(params, "s[32]S()[64]", pm, subpm))
	{
		if(!Admin(playerid, 1337) && !IsScripter(playerid)) return Msg(playerid, "/raktár [Megnéz/Berak/Kivesz/Minrang(leadernek)]");
		Msg(playerid, "/raktár [Megnéz/Berak/Kivesz/Minrang/Érték/Nulláz/Amegnéz]");
		return 1;
	}
	if(egyezik(pm, "megnéz") || egyezik(pm, "megnez"))
	{
		if(!PlayerToPoint(3, playerid, FrakcioInfo[melo][fPosX], FrakcioInfo[melo][fPosY], FrakcioInfo[melo][fPosZ])) return Msg(playerid, "Nem vagy a széf közelében.");
		SendClientMessage(playerid, COLOR_LIGHTBLUE, "===========[ Raktár Tartalma ]===========");
		SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Kaja: %ddb - Alma: %ddb", FrakcioInfo[melo][fKaja], FrakcioInfo[melo][fAlma]);
		SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Material: %sdb - Heroin: %sg", FormatNumber( FrakcioInfo[melo][fMati], 0, ',' ), FormatNumber( FrakcioInfo[melo][fHeroin], 0, ',' ));
		SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Kokain: %sg - Marihuana: %sg", FormatNumber( FrakcioInfo[melo][fKokain], 0, ',' ), FormatNumber( FrakcioInfo[melo][fMarihuana], 0, ',' ));
		SendFormatMessage(playerid, COLOR_LIGHTGREEN, "C4: %ddb", FrakcioInfo[melo][fC4]);
		SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Ruhatár(1-10): %d,%d,%d,%d,%d,%d,%d,%d,%d,%d", FrakcioInfo[melo][fRuha][0],FrakcioInfo[melo][fRuha][1],FrakcioInfo[melo][fRuha][2],FrakcioInfo[melo][fRuha][3],FrakcioInfo[melo][fRuha][4],FrakcioInfo[melo][fRuha][5],FrakcioInfo[melo][fRuha][6],FrakcioInfo[melo][fRuha][7],FrakcioInfo[melo][fRuha][8],FrakcioInfo[melo][fRuha][9]);
		SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Ruhatár(11-20): %d,%d,%d,%d,%d,%d,%d,%d,%d,%d", FrakcioInfo[melo][fRuha][10],FrakcioInfo[melo][fRuha][11],FrakcioInfo[melo][fRuha][12],FrakcioInfo[melo][fRuha][13],FrakcioInfo[melo][fRuha][14],FrakcioInfo[melo][fRuha][15],FrakcioInfo[melo][fRuha][16],FrakcioInfo[melo][fRuha][17],FrakcioInfo[melo][fRuha][18],FrakcioInfo[melo][fRuha][19]);
		SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Ruhatár(21-30): %d,%d,%d,%d,%d,%d,%d,%d,%d,%d", FrakcioInfo[melo][fRuha][20],FrakcioInfo[melo][fRuha][21],FrakcioInfo[melo][fRuha][22],FrakcioInfo[melo][fRuha][23],FrakcioInfo[melo][fRuha][24],FrakcioInfo[melo][fRuha][25],FrakcioInfo[melo][fRuha][26],FrakcioInfo[melo][fRuha][27],FrakcioInfo[melo][fRuha][28],FrakcioInfo[melo][fRuha][29]);
		SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Ruhatár(31-40): %d,%d,%d,%d,%d,%d,%d,%d,%d,%d", FrakcioInfo[melo][fRuha][30],FrakcioInfo[melo][fRuha][31],FrakcioInfo[melo][fRuha][32],FrakcioInfo[melo][fRuha][33],FrakcioInfo[melo][fRuha][34],FrakcioInfo[melo][fRuha][35],FrakcioInfo[melo][fRuha][36],FrakcioInfo[melo][fRuha][37],FrakcioInfo[melo][fRuha][38],FrakcioInfo[melo][fRuha][39]);
		SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Ruhatár(41-50): %d,%d,%d,%d,%d,%d,%d,%d,%d,%d", FrakcioInfo[melo][fRuha][40],FrakcioInfo[melo][fRuha][41],FrakcioInfo[melo][fRuha][42],FrakcioInfo[melo][fRuha][43],FrakcioInfo[melo][fRuha][44],FrakcioInfo[melo][fRuha][45],FrakcioInfo[melo][fRuha][46],FrakcioInfo[melo][fRuha][47],FrakcioInfo[melo][fRuha][48],FrakcioInfo[melo][fRuha][49]);
		Cselekves(playerid, "megnézte a raktárat...", 1);
	}
	elseif(egyezik(pm, "amegnéz") || egyezik(pm, "amegnez"))
	{
		if(!Admin(playerid, 1337) && !IsScripter(playerid)) return 1;
		if(sscanf(subpm, "d", fkid)) return SendClientMessage(playerid, COLOR_LIGHTRED, "ClassRPG: /raktár amegnéz [FrakcióID]");
		SendClientMessage(playerid, COLOR_LIGHTBLUE, "===========[ Raktár Tartalma ]===========");
		SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Kaja: %ddb - Alma: %ddb", FrakcioInfo[fkid][fKaja], FrakcioInfo[fkid][fAlma]);
		SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Material: %sdb - Heroin: %sg", FormatNumber( FrakcioInfo[fkid][fMati], 0, ',' ), FormatNumber( FrakcioInfo[fkid][fHeroin], 0, ',' ));
		SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Kokain: %sg - Marihuana: %sg", FormatNumber( FrakcioInfo[fkid][fKokain], 0, ',' ), FormatNumber( FrakcioInfo[fkid][fMarihuana], 0, ',' ));
		SendFormatMessage(playerid, COLOR_LIGHTGREEN, "C4: %ddb", FrakcioInfo[fkid][fC4]);
		SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Ruhatár(1-10): %d,%d,%d,%d,%d,%d,%d,%d,%d,%d", FrakcioInfo[fkid][fRuha][0],FrakcioInfo[fkid][fRuha][1],FrakcioInfo[fkid][fRuha][2],FrakcioInfo[fkid][fRuha][3],FrakcioInfo[fkid][fRuha][4],FrakcioInfo[fkid][fRuha][5],FrakcioInfo[fkid][fRuha][6],FrakcioInfo[fkid][fRuha][7],FrakcioInfo[fkid][fRuha][8],FrakcioInfo[fkid][fRuha][9]);
		SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Ruhatár(11-20): %d,%d,%d,%d,%d,%d,%d,%d,%d,%d", FrakcioInfo[fkid][fRuha][10],FrakcioInfo[fkid][fRuha][11],FrakcioInfo[fkid][fRuha][12],FrakcioInfo[fkid][fRuha][13],FrakcioInfo[fkid][fRuha][14],FrakcioInfo[fkid][fRuha][15],FrakcioInfo[fkid][fRuha][16],FrakcioInfo[fkid][fRuha][17],FrakcioInfo[fkid][fRuha][18],FrakcioInfo[fkid][fRuha][19]);
		SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Ruhatár(21-30): %d,%d,%d,%d,%d,%d,%d,%d,%d,%d", FrakcioInfo[fkid][fRuha][20],FrakcioInfo[fkid][fRuha][21],FrakcioInfo[fkid][fRuha][22],FrakcioInfo[fkid][fRuha][23],FrakcioInfo[fkid][fRuha][24],FrakcioInfo[fkid][fRuha][25],FrakcioInfo[fkid][fRuha][26],FrakcioInfo[fkid][fRuha][27],FrakcioInfo[fkid][fRuha][28],FrakcioInfo[fkid][fRuha][29]);
		SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Ruhatár(31-40): %d,%d,%d,%d,%d,%d,%d,%d,%d,%d", FrakcioInfo[fkid][fRuha][30],FrakcioInfo[fkid][fRuha][31],FrakcioInfo[fkid][fRuha][32],FrakcioInfo[fkid][fRuha][33],FrakcioInfo[fkid][fRuha][34],FrakcioInfo[fkid][fRuha][35],FrakcioInfo[fkid][fRuha][36],FrakcioInfo[fkid][fRuha][37],FrakcioInfo[fkid][fRuha][38],FrakcioInfo[fkid][fRuha][39]);
		SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Ruhatár(41-50): %d,%d,%d,%d,%d,%d,%d,%d,%d,%d", FrakcioInfo[fkid][fRuha][40],FrakcioInfo[fkid][fRuha][41],FrakcioInfo[fkid][fRuha][42],FrakcioInfo[fkid][fRuha][43],FrakcioInfo[fkid][fRuha][44],FrakcioInfo[fkid][fRuha][45],FrakcioInfo[fkid][fRuha][46],FrakcioInfo[fkid][fRuha][47],FrakcioInfo[fkid][fRuha][48],FrakcioInfo[fkid][fRuha][49]);
		SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Frakció: %d | Neve: %s", fkid, Szervezetneve[fkid-1][1]);
	}
	elseif(egyezik(pm, "berak"))
	{
		if(!PlayerToPoint(3, playerid, FrakcioInfo[melo][fPosX], FrakcioInfo[melo][fPosY], FrakcioInfo[melo][fPosZ])) return Msg(playerid, "Nem vagy a széf közelében.");
		if(sscanf(subpm, "s[32]S()[64]", mit, subby)) return Msg(playerid, "/raktár berak [Kaja/Alma/Mati/Heroin/Marihuana/Kokain/Ruha/C4] [Mennyit/RaktárID]");
		new mati = PlayerInfo[playerid][pMats];
		new heroin = PlayerInfo[playerid][pHeroin];
		new kokain = PlayerInfo[playerid][pKokain];
		new marihuana = PlayerInfo[playerid][pMarihuana];
		new kaja = PlayerInfo[playerid][pKaja];
		new alma = PlayerInfo[playerid][pAlma];
		if(egyezik(mit, "kaja"))
		{
			if(sscanf(subby, "d", mennyit)) return Msg(playerid, "/raktár berak kaja [mennyit]");
			if(mennyit < 1) return Msg(playerid, "Legalább egy darabot rakj be.");
			if(kaja < mennyit) return Msg(playerid, "Nincs elég kajád.");
			PlayerInfo[playerid][pKaja] -= mennyit;
			FrakcioInfo[melo][fKaja] += mennyit;
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Beraktál %ddb kaját a raktárba.", mennyit);
			format(szeflog, 256, "[%d. frakció (%s)]%s berakott a raktárba %d db kaját",melo, Szervezetneve[melo - 1][2],PlayerName(playerid), mennyit); Log("Szef", szeflog);
		}
		elseif(egyezik(mit, "alma"))
		{
			if(sscanf(subby, "d", mennyit)) return Msg(playerid, "/raktár berak alma [mennyit]");
			if(mennyit < 1) return Msg(playerid, "Legalább egy darabot rakj be.");
			if(alma < mennyit) return Msg(playerid, "Nincs elég almád.");
			PlayerInfo[playerid][pAlma] -= mennyit;
			FrakcioInfo[melo][fAlma] += mennyit;
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Beraktál %ddb almát a raktárba.", mennyit);
			format(szeflog, 256, "[%d. frakció (%s)]%s berakott a raktárba %d db almát",melo, Szervezetneve[melo - 1][2],PlayerName(playerid), mennyit); Log("Szef", szeflog);
		}
		elseif(egyezik(mit, "mati") || egyezik(mit, "material"))
		{
			if(hour == 4) return Msg(playerid, "A rendszer visszaélések miatt letiltotta a berakást");
			if(sscanf(subby, "d", mennyit)) return Msg(playerid, "/raktár berak mati [mennyit]");
			if(mennyit < 1) return Msg(playerid, "Legalább egy darabot rakj be.");
			if(mati < mennyit) return Msg(playerid, "Nincs elég matid.");
			PlayerInfo[playerid][pMats] -= mennyit;
			FrakcioInfo[melo][fMati] += mennyit;
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Beraktál %ddb matit a raktárba.", mennyit);
			format(szeflog, 256, "[%d. frakció (%s)]%s berakott a raktárba %d db matit",melo, Szervezetneve[melo - 1][2],PlayerName(playerid), mennyit); Log("Szef", szeflog);
		}
		elseif(egyezik(mit, "heroin"))
		{
			if(hour == 4) return Msg(playerid, "A rendszer visszaélések miatt letiltotta a berakást");
			if(sscanf(subby, "d", mennyit)) return Msg(playerid, "/raktár berak heroin [mennyit]");
			if(mennyit < 1) return Msg(playerid, "Legalább egy darabot rakj be.");
			if(heroin < mennyit) return Msg(playerid, "Nincs elég heroinod.");
			PlayerInfo[playerid][pHeroin] -= mennyit;
			FrakcioInfo[melo][fHeroin] += mennyit;
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Beraktál %dg heroint a raktárba.", mennyit);
			format(szeflog, 256, "[%d. frakció (%s)]%s berakott a raktárba %d db heroint",melo, Szervezetneve[melo - 1][2],PlayerName(playerid), mennyit); Log("Szef", szeflog);
		}
		elseif(egyezik(mit, "kokain"))
		{
			if(hour == 4) return Msg(playerid, "A rendszer visszaélések miatt letiltotta a berakást");
			if(sscanf(subby, "d", mennyit)) return Msg(playerid, "/raktár berak kokain [mennyit]");
			if(mennyit < 1) return Msg(playerid, "Legalább egy darabot rakj be.");
			if(kokain < mennyit) return Msg(playerid, "Nincs elég kokainod.");
			PlayerInfo[playerid][pKokain] -= mennyit;
			FrakcioInfo[melo][fKokain] += mennyit;
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Beraktál %dg kokaint a raktárba.", mennyit);
			format(szeflog, 256, "[%d. frakció (%s)]%s berakott a raktárba %d db kokaint",melo, Szervezetneve[melo - 1][2],PlayerName(playerid), mennyit); Log("Szef", szeflog);
		}
		elseif(egyezik(mit, "marihuana"))
		{
			if(hour == 4) return Msg(playerid, "A rendszer visszaélések miatt letiltotta a berakást");
			if(sscanf(subby, "d", mennyit)) return Msg(playerid, "/raktár berak marihuana [mennyit]");
			if(mennyit < 1) return Msg(playerid, "Legalább egy darabot rakj be.");
			if(marihuana < mennyit) return Msg(playerid, "Nincs elég marihuanád.");
			PlayerInfo[playerid][pMarihuana] -= mennyit;
			FrakcioInfo[melo][fMarihuana] += mennyit;
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Beraktál %dg marihuanát a raktárba.", mennyit);
			format(szeflog, 256, "[%d. frakció (%s)]%s berakott a raktárba %d db marihuanát",melo, Szervezetneve[melo - 1][2],PlayerName(playerid), mennyit); Log("Szef", szeflog);
		}
		elseif(egyezik(mit, "ruha"))
		{
			if(sscanf(subby, "d", mennyit)) return Msg(playerid, "/raktár berak ruha [slot]");
			if(GetPlayerSkin(playerid) == 252) return Msg(playerid, "Még az alsógatyádat is a raktárba akarod rakni?..");
			if(mennyit < 0 || mennyit > 49) return Msg(playerid, "0-49");
			if(FrakcioInfo[melo][fRuha][mennyit] != 252 && FrakcioInfo[melo][fRuha][mennyit] != 0) return Msg(playerid, "Ezen a sloton már van valami!");
			FrakcioInfo[melo][fRuha][mennyit] = GetPlayerSkin(playerid);
			SetPlayerSkin(playerid, 252);
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Beraktad a ruhádat a raktárba (slot: %d).", mennyit);
			format(szeflog, 256, "[%d. frakció (%s)]%s berakott a raktárba a %d skint, a %d slotra", melo, Szervezetneve[melo - 1][2],PlayerName(playerid), FrakcioInfo[melo][fRuha][mennyit], mennyit); Log("Szef", szeflog);
		}
		elseif(egyezik(mit, "C4"))
		{
			if(PlayerInfo[playerid][pC4] == 0) return Msg(playerid, "Nincs C4 nálad.");
			PlayerInfo[playerid][pC4] --;
			FrakcioInfo[melo][fC4] ++;
			SendClientMessage(playerid, COLOR_LIGHTGREEN, "* Beraktál 1 darab C4 robbanószert a raktárba.");
			format(szeflog, 256, "[%d. frakció (%s)]%s berakott a raktárba 1db C4-t", melo, Szervezetneve[melo - 1][2],PlayerName(playerid)); Log("Szef", szeflog);
		}
		INI_Save(INI_TYPE_FRAKCIO, melo);
	}
	elseif(egyezik(pm, "kivesz"))
	{
		if(!PlayerToPoint(3, playerid, FrakcioInfo[melo][fPosX], FrakcioInfo[melo][fPosY], FrakcioInfo[melo][fPosZ])) return Msg(playerid, "Nem vagy a széf közelében.");
		if(PlayerInfo[playerid][pRank] < FrakcioInfo[melo][fRaktarRang]) return SendFormatMessage(playerid, COLOR_LIGHTRED, "ClassRPG: Nem elég nagy a rangod, minimum rang: %d", FrakcioInfo[melo][fRaktarRang]);
		if(sscanf(subpm, "s[32]S()[64]", mit, subby)) return Msg(playerid, "/raktár kivesz [Kaja/Alma/Mati/Heroin/Marihuana/Kokain/Ruha/C4] [Mennyit/RaktárID]");
		new mati = FrakcioInfo[melo][fMati];
		new heroin = FrakcioInfo[melo][fHeroin];
		new kokain = FrakcioInfo[melo][fKokain];
		new marihuana = FrakcioInfo[melo][fMarihuana];
		new kaja = FrakcioInfo[melo][fKaja];
		new alma = FrakcioInfo[melo][fAlma];
		new c4 = FrakcioInfo[melo][fC4];
		if(egyezik(mit, "kaja"))
		{
			if(sscanf(subby, "d", mennyit)) return Msg(playerid, "/raktár kivesz kaja [mennyit]");
			if(mennyit < 1) return Msg(playerid, "Legalább egy darabot vegyél ki.");
			if(kaja < mennyit) return Msg(playerid, "Nincs elég kaja a széfben.");
			if((PlayerInfo[playerid][pKaja] + mennyit) > MAXKAJA) return Msg(playerid, "Ennyi nem fér el nálad.");
			PlayerInfo[playerid][pKaja] += mennyit;
			FrakcioInfo[melo][fKaja] -= mennyit;
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Kivettél %ddb kaját a raktárból.", mennyit);
			format(szeflog, 256, "[%d. frakció (%s)]%s kivett a raktárból %d db kaját",melo, Szervezetneve[melo - 1][2],PlayerName(playerid), mennyit); Log("Szef", szeflog);
		}
		elseif(egyezik(mit, "alma"))
		{
			if(sscanf(subby, "d", mennyit)) return Msg(playerid, "/raktár kivesz alma [mennyit]");
			if(mennyit < 1) return Msg(playerid, "Legalább egy darabot vegyél ki.");
			if(alma < mennyit) return Msg(playerid, "Nincs elég alma a széfben.");
			if((PlayerInfo[playerid][pAlma] + mennyit) > MAXALMA) return Msg(playerid, "Ennyi nem fér el nálad.");
			PlayerInfo[playerid][pAlma] += mennyit;
			FrakcioInfo[melo][fAlma] -= mennyit;
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Kivettél %ddb almát a raktárból.", mennyit);
			format(szeflog, 256, "[%d. frakció (%s)]%s kivett a raktárból %d db almát",melo, Szervezetneve[melo - 1][2],PlayerName(playerid), mennyit); Log("Szef", szeflog);
		}
		elseif(egyezik(mit, "mati") || egyezik(mit, "material"))
		{
			if(hour == 3) return Msg(playerid, "A rendszer visszaélések miatt letiltotta a kivételt");
			if(sscanf(subby, "d", mennyit)) return Msg(playerid, "/raktár kivesz mati [mennyit]");
			if(mennyit < 1) return Msg(playerid, "Legalább egy darabot vegyél ki.");
			if(mati < mennyit) return Msg(playerid, "Nincs elég mati a széfben.");
			if((PlayerInfo[playerid][pMats] + mennyit) > MAXMATI) return Msg(playerid, "Ennyi nem fér el nálad.");
			PlayerInfo[playerid][pMats] += mennyit;
			FrakcioInfo[melo][fMati] -= mennyit;
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Kivettél %ddb matit a raktárból.", mennyit);
			format(szeflog, 256, "[%d. frakció (%s)]%s kivett a raktárból %d db matit",melo, Szervezetneve[melo - 1][2],PlayerName(playerid), mennyit); Log("Szef", szeflog);
		}
		elseif(egyezik(mit, "heroin"))
		{
			if(hour == 3) return Msg(playerid, "A rendszer visszaélések miatt letiltotta a kivételt");
			if(sscanf(subby, "d", mennyit)) return Msg(playerid, "/raktár kivesz heroin [mennyit]");
			if(mennyit < 1) return Msg(playerid, "Legalább egy darabot vegyél ki.");
			if(heroin < mennyit) return Msg(playerid, "Nincs elég heroin a széfben.");
			if((PlayerInfo[playerid][pHeroin] + mennyit) > MAXHEROIN) return Msg(playerid, "Ennyi nem fér el nálad.");
			PlayerInfo[playerid][pHeroin] += mennyit;
			FrakcioInfo[melo][fHeroin] -= mennyit;
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Kivettél %dg heroint a raktárból.", mennyit);
			format(szeflog, 256, "[%d. frakció (%s)]%s kivett a raktárból %d db heroint",melo, Szervezetneve[melo - 1][2],PlayerName(playerid), mennyit); Log("Szef", szeflog);
		}
		elseif(egyezik(mit, "kokain"))
		{
			if(hour == 3) return Msg(playerid, "A rendszer visszaélések miatt letiltotta a kivételt");
			if(sscanf(subby, "d", mennyit)) return Msg(playerid, "/raktár kivesz kokain [mennyit]");
			if(mennyit < 1) return Msg(playerid, "Legalább egy darabot vegyél ki.");
			if(kokain < mennyit) return Msg(playerid, "Nincs elég kokain a széfben.");
			if((PlayerInfo[playerid][pKokain] + mennyit) > MAXKOKAIN) return Msg(playerid, "Ennyi nem fér el nálad.");
			PlayerInfo[playerid][pKokain] += mennyit;
			FrakcioInfo[melo][fKokain] -= mennyit;
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Kivettél %ddb kokaint a raktárból.", mennyit);
			format(szeflog, 256, "[%d. frakció (%s)]%s kivett a raktárból %d db kokaint",melo, Szervezetneve[melo - 1][2],PlayerName(playerid), mennyit); Log("Szef", szeflog);
		}
		elseif(egyezik(mit, "marihuana"))
		{
			if(hour == 3) return Msg(playerid, "A rendszer visszaélések miatt letiltotta a kivételt");
			if(sscanf(subby, "d", mennyit)) return Msg(playerid, "/raktár kivesz marihuana [mennyit]");
			if(mennyit < 1) return Msg(playerid, "Legalább egy darabot vegyél ki.");
			if(marihuana < mennyit) return Msg(playerid, "Nincs elég marihuana a széfben.");
			if((PlayerInfo[playerid][pMarihuana] + mennyit) > MAXMARIHUANA) return Msg(playerid, "Ennyi nem fér el nálad.");
			PlayerInfo[playerid][pMarihuana] += mennyit;
			FrakcioInfo[melo][fMarihuana] -= mennyit;
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Kivettél %ddb marihuanát a raktárból.", mennyit);
			format(szeflog, 256, "[%d. frakció (%s)]%s kivett a raktárból %d db marihuanat",melo, Szervezetneve[melo - 1][2],PlayerName(playerid), mennyit); Log("Szef", szeflog);
		}
		elseif(egyezik(mit, "ruha"))
		{
			if(sscanf(subby, "d", mennyit)) return Msg(playerid, "/raktár kivesz ruha [slot]");
			if(GetPlayerSkin(playerid) != 252) return Msg(playerid, "Már fel vagy öltözve!");
			if(mennyit < 0 || mennyit > 49) return Msg(playerid, "0-50");
			if(FrakcioInfo[melo][fRuha][mennyit] == 252) return Msg(playerid, "Ezen a slot üres!");
			SetPlayerSkin(playerid, FrakcioInfo[melo][fRuha][mennyit]);
			FrakcioInfo[melo][fRuha][mennyit] = 252;
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Beraktad a ruhádat a raktárból (slot: %d).", mennyit);
			format(szeflog, 256, "[%d. frakció (%s)]%s kivett a raktárból a %d skint, a %d slotról", melo, Szervezetneve[melo - 1][2],PlayerName(playerid), FrakcioInfo[melo][fRuha][mennyit], mennyit); Log("Szef", szeflog);
		}
		elseif(egyezik(mit, "C4"))
		{
			if(c4 < 1) return Msg(playerid, "Nincs C4 a széfben!");
			if(PlayerInfo[playerid][pC4] == 1) return Msg(playerid, "Már van nálad C4!");
			PlayerInfo[playerid][pC4] = 1;
			FrakcioInfo[melo][fC4]--;
			SendClientMessage(playerid, COLOR_LIGHTGREEN, "* Kivettél 1db C4 robbanószert a raktárból.");
			format(szeflog, 256, "[%d. frakció (%s)]%s kivett a raktárból 1db C4-et", melo, Szervezetneve[melo - 1][2],PlayerName(playerid)); Log("Szef", szeflog);
		}
		INI_Save(INI_TYPE_FRAKCIO, melo);
	}
	elseif(egyezik(pm, "minrang"))
	{
		if(PlayerInfo[playerid][pLeader] == 0) return Msg(playerid, "Kizárólag Leadernek!");
		if(sscanf(subpm, "d", mennyit))
		{
			SendFormatMessage(playerid, COLOR_LIGHTRED, "/raktár minrang [0-%d]", OsszRang[PlayerInfo[playerid][pLeader]]);
			SendFormatMessage(playerid, COLOR_LIGHTRED, "Jelenlegi szükséges rang: %d", FrakcioInfo[melo][fRaktarRang]);
			return 1;
		}
		if(mennyit < 0 || mennyit > OsszRang[PlayerInfo[playerid][pLeader]]) return SendFormatMessage(playerid, COLOR_LIGHTRED, "ClassRPG: 0-%d", OsszRang[PlayerInfo[playerid][pLeader]]);
		format(szeflog, 256, "[%d. frakció (%s) - info]%s átírta a raktárnak min. rangját errõl: %d, erre: %d", melo, Szervezetneve[melo - 1][2],PlayerName(playerid), FrakcioInfo[melo][fRaktarRang], mennyit); Log("Szef", szeflog);

		FrakcioInfo[melo][fRaktarRang] = mennyit;
		SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* A raktárból mostantól %d rangtól lehet kivenni.", mennyit);
		INI_Save(INI_TYPE_FRAKCIO, melo);
	}
	elseif(egyezik(pm, "érték") || egyezik(pm, "ertek"))
	{
		if(!Admin(playerid, 1337) && !IsScripter(playerid)) return 1;
		if(sscanf(subpm, "ds[32]d", fkid, mit, mennyit))
		{
			SendClientMessage(playerid, COLOR_LIGHTRED, "/raktár érték [FrakcióID] [Mit] [Mennyire]");
			SendClientMessage(playerid, COLOR_LIGHTRED, "Paraméterek: Kaja, Alma, Mati, Heroin, Marihuana, Kokain, C4");
			return 1;
		}
		if(mennyit < 0) return Msg(playerid, "Mínuszt?");
		new mati = FrakcioInfo[fkid][fMati];
		new heroin = FrakcioInfo[fkid][fHeroin];
		new kokain = FrakcioInfo[fkid][fKokain];
		new marihuana = FrakcioInfo[fkid][fMarihuana];
		new kaja = FrakcioInfo[fkid][fKaja];
		new alma = FrakcioInfo[fkid][fAlma];
		new c4 = FrakcioInfo[fkid][fC4];
		if(egyezik(mit, "material") || egyezik(mit, "mati"))
		{
			
			format(_tmpString,sizeof(_tmpString),"<< %s beállította a(z) (%d)%s frakció széfének tartalmát! Adat: Mati | Új: %s | Régi: %s >>", PlayerName(playerid), fkid, Szervezetneve[fkid-1][1], FormatNumber( mennyit, 0, ',' ), FormatNumber( mati, 0, ',' ));
			SendMessage(SEND_MESSAGE_ADMIN,_tmpString,COLOR_LIGHTRED,PlayerInfo[playerid][pAdmin]);
			
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Széf tartalma beállítva: %sdb Mati | Régi: %s", FormatNumber( mennyit, 0, ',' ), FormatNumber(mati, 0, ','));
			format(szeflog, 256, "%s beállította a %d. frakció (%s) raktárának materialtartalmát errõl: %s erre: %s", PlayerName(playerid), fkid, Szervezetneve[fkid-1][2], mati, mennyit), Log("Szef", szeflog);
			FrakcioInfo[fkid][fMati] = mennyit;
		}
		elseif(egyezik(mit, "heroin"))
		{
			format(_tmpString,sizeof(_tmpString),"<< %s beállította a(z) (%d)%s frakció széfének tartalmát! Adat: Heroin | Új: %s | Régi: %s >>", PlayerName(playerid), fkid, Szervezetneve[fkid-1][1], FormatNumber( mennyit, 0, ',' ), FormatNumber( heroin, 0, ',' ));
			
			SendMessage(SEND_MESSAGE_ADMIN,_tmpString,COLOR_LIGHTRED,PlayerInfo[playerid][pAdmin]);
			
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Széf tartalma beállítva: %sg Heroin | Régi: %s", FormatNumber( mennyit, 0, ',' ), FormatNumber( heroin, 0, ',' ));
			format(szeflog, 256, "%s beállította a %d. frakció (%s) raktárának herointartalmát errõl: %s erre: %s", PlayerName(playerid), fkid, Szervezetneve[fkid-1][2], heroin, mennyit), Log("Szef", szeflog);
			FrakcioInfo[fkid][fHeroin] = mennyit;
		}
		elseif(egyezik(mit, "kokain"))
		{
			
			format(_tmpString,sizeof(_tmpString),"<< %s beállította a(z) (%d)%s frakció széfének tartalmát! Adat: Kokain | Új: %s | Régi: %s  >>", PlayerName(playerid), fkid, Szervezetneve[fkid-1][1], FormatNumber( mennyit, 0, ',' ), FormatNumber( kokain, 0, ',' ));
			
			SendMessage(SEND_MESSAGE_ADMIN,_tmpString,COLOR_LIGHTRED,PlayerInfo[playerid][pAdmin]);
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Széf tartalma beállítva: %sg Kokain | Régi: %s", FormatNumber( mennyit, 0, ',' ), FormatNumber( kokain, 0, ',' ));
			format(szeflog, 256, "%s beállította a %d. frakció (%s) raktárának kokaintartalmát errõl: %s erre: %s", PlayerName(playerid), fkid, Szervezetneve[fkid-1][2], kokain, mennyit), Log("Szef", szeflog);
			FrakcioInfo[fkid][fKokain] = mennyit;
		}
		elseif(egyezik(mit, "marihuana"))
		{
			format(_tmpString,sizeof(_tmpString),"<< %s beállította a(z) (%d)%s frakció széfének tartalmát! Adat: Marihuana | Új: %s | Régi: %s >>", PlayerName(playerid), fkid, Szervezetneve[fkid-1][1], FormatNumber( mennyit, 0, ',' ), FormatNumber( marihuana, 0, ','));
		
			SendMessage(SEND_MESSAGE_ADMIN,_tmpString,COLOR_LIGHTRED,PlayerInfo[playerid][pAdmin]);
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Széf tartalma beállítva: %sg Marihuana | Régi: %s", FormatNumber( mennyit, 0, ',' ), FormatNumber( marihuana, 0, ',' ));
			format(szeflog, 256, "%s beállította a %d. frakció (%s) raktárának marihuanatartalmát errõl: %s erre: %s", PlayerName(playerid), fkid, Szervezetneve[fkid-1][2], marihuana, mennyit), Log("Szef", szeflog);
			FrakcioInfo[fkid][fMarihuana] = mennyit;
		}
		elseif(egyezik(mit, "kaja"))
		{
			format(_tmpString,sizeof(_tmpString),"<< %s beállította a(z) (%d)%s frakció széfének tartalmát! Adat: Kaja | Új: %s | Régi: %s >>", PlayerName(playerid), fkid, Szervezetneve[fkid-1][1], FormatNumber( mennyit, 0, ',' ), FormatNumber( kaja, 0, ',' ));
			
			SendMessage(SEND_MESSAGE_ADMIN,_tmpString,COLOR_LIGHTRED,PlayerInfo[playerid][pAdmin]);
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Széf tartalma beállítva: %sdb Kaja | Régi: %s", FormatNumber( mennyit, 0, ',' ), FormatNumber( mennyit, 0, ',' ), FormatNumber( kaja, 0, ',' ));
			format(szeflog, 256, "%s beállította a %d. frakció (%s) raktárának kajatartalmát errõl: %s erre: %s", PlayerName(playerid), fkid, Szervezetneve[fkid-1][2], kaja, mennyit), Log("Szef", szeflog);
			FrakcioInfo[fkid][fKaja] = mennyit;
		}
		elseif(egyezik(mit, "alma"))
		{
			format(_tmpString,sizeof(_tmpString),"<< %s beállította a(z) (%d)%s frakció széfének tartalmát! Adat: Alma | Új: %s | Régi: %s >>", PlayerName(playerid), fkid, Szervezetneve[fkid-1][1], FormatNumber( mennyit, 0, ',' ),  FormatNumber( alma, 0, ',' ));
	
			SendMessage(SEND_MESSAGE_ADMIN,_tmpString,COLOR_LIGHTRED,PlayerInfo[playerid][pAdmin]);
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Széf tartalma beállítva: %sdb Alma | Régi: %s", FormatNumber( mennyit, 0, ',' ), FormatNumber( alma, 0, ',' ));
			format(szeflog, 256, "%s beállította a %d. frakció (%s) raktárának almatartalmát errõl: %s erre: %s", PlayerName(playerid), fkid, Szervezetneve[fkid-1][2], alma, mennyit), Log("Szef", szeflog);
			FrakcioInfo[fkid][fAlma] = mennyit;
		}
		elseif(egyezik(mit, "C4"))
		{
			format(_tmpString,sizeof(_tmpString),"<< %s beállította a(z) (%d)%s frakció széfének tartalmát! Adat: C4 | Új: %s | Régi: %s >>", PlayerName(playerid), fkid, Szervezetneve[fkid-1][1], FormatNumber( mennyit, 0, ',' ),  FormatNumber( c4, 0, ',' ));
			
			SendMessage(SEND_MESSAGE_ADMIN,_tmpString,COLOR_LIGHTRED,PlayerInfo[playerid][pAdmin]);
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Széf tartalma beállítva: %sdb C4 | Régi: %s", FormatNumber( mennyit, 0, ',' ), FormatNumber( c4, 0, ',' ));
			format(szeflog, 256, "%s beállította a %d. frakció (%s) raktárának C4 tartalmát errõl: %s erre: %s", PlayerName(playerid), fkid, Szervezetneve[fkid-1][2], c4, mennyit), Log("Szef", szeflog);
			FrakcioInfo[fkid][fC4] = mennyit;
		}
		INI_Save(INI_TYPE_FRAKCIO, fkid);
	}
	elseif(egyezik(pm, "nulláz") || egyezik(pm, "nullaz"))
	{
		if(!Admin(playerid, 1337) && !IsScripter(playerid)) return 1;
		if(sscanf(subpm, "ds[32]", mit))
		{
			SendClientMessage(playerid, COLOR_LIGHTRED, "/raktár nulláz [FrakcióID] [Mit]");
			SendClientMessage(playerid, COLOR_LIGHTRED, "Paraméterek: Kaja, Alma, Mati, Heroin, Marihuana, Kokain, C4");
			return 1;
		}
		if(mennyit < 0) return Msg(playerid, "Mínuszt?");
		new mati = FrakcioInfo[fkid][fMati];
		new heroin = FrakcioInfo[fkid][fHeroin];
		new kokain = FrakcioInfo[fkid][fKokain];
		new marihuana = FrakcioInfo[fkid][fMarihuana];
		new kaja = FrakcioInfo[fkid][fKaja];
		new alma = FrakcioInfo[fkid][fAlma];
		new c4 = FrakcioInfo[fkid][fC4];
		if(egyezik(mit, "material") || egyezik(mit, "mati"))
		{
			ABroadCastFormat(COLOR_LIGHTRED, PlayerInfo[playerid][pAdmin], "<< %s %s nullázta a(z) (%d)%s frakció raktárának tartalmát! Adat: Mati | Régi: %s >>",AdminRangNev(playerid), PlayerName(playerid), fkid, Szervezetneve[fkid-1][1], FormatNumber( mati, 0, ',' ));
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Raktár tartalma (Material) nullázva | Régi: %s", FormatNumber( mati, 0, ',' ));
			format(szeflog, 256, "%s nullázta a %d. frakció (%s) raktárának materialtartalmát - eredeti mennyiség: %s", PlayerName(playerid), fkid, Szervezetneve[fkid-1][2], mati), Log("Szef", szeflog);
			FrakcioInfo[fkid][fMati] = 0;
		}
		elseif(egyezik(mit, "heroin"))
		{
			ABroadCastFormat(COLOR_LIGHTRED, PlayerInfo[playerid][pAdmin], "<< %s %s nullázta a(z) (%d)%s frakció raktárának tartalmát! Adat: Heroin | Régi: %s >>",AdminRangNev(playerid), PlayerName(playerid), fkid, Szervezetneve[fkid-1][1], FormatNumber( heroin, 0, ',' ));
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Raktár tartalma (Heroin) nullázva | Régi: %s", FormatNumber( heroin, 0, ',' ));
			format(szeflog, 256, "%s nullázta a %d. frakció (%s) raktárának herointartalmát - eredeti mennyiség: %s", PlayerName(playerid), fkid, Szervezetneve[fkid-1][2], heroin), Log("Szef", szeflog);
			FrakcioInfo[fkid][fHeroin] = 0;
		}
		elseif(egyezik(mit, "kokain"))
		{
			ABroadCastFormat(COLOR_LIGHTRED, PlayerInfo[playerid][pAdmin], "<< %s %s nullázta a(z) (%d)%s frakció raktárának tartalmát! Adat: Kokain | Régi: %s >>",AdminRangNev(playerid), PlayerName(playerid), fkid, Szervezetneve[fkid-1][1], FormatNumber( kokain, 0, ',' ));
			
			
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Raktár tartalma (Kokain) nullázva | Régi: %s", FormatNumber( kokain, 0, ',' ));
			format(szeflog, 256, "%s nullázta a %d. frakció (%s) raktárának kokaintartalmát - eredeti mennyiség: %s", PlayerName(playerid), fkid, Szervezetneve[fkid-1][2], kokain), Log("Szef", szeflog);
			FrakcioInfo[fkid][fKokain] = 0;
		}
		elseif(egyezik(mit, "marihuana"))
		{
			ABroadCastFormat(COLOR_LIGHTRED, PlayerInfo[playerid][pAdmin], "<< %s %s nullázta a(z) (%d)%s frakció raktárának tartalmát! Adat: Marihuana | Régi: %s >>",AdminRangNev(playerid), PlayerName(playerid), fkid, Szervezetneve[fkid-1][1], FormatNumber( marihuana, 0, ',' ));
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Raktár tartalma (Marihuana) nullázva | Régi: %s", FormatNumber( marihuana, 0, ',' ));
			format(szeflog, 256, "%s nullázta a %d. frakció (%s) raktárának marihuanatartalmát - eredeti mennyiség: %s", PlayerName(playerid), fkid, Szervezetneve[fkid-1][2], marihuana), Log("Szef", szeflog);
			FrakcioInfo[fkid][fMarihuana] = 0;
		}
		elseif(egyezik(mit, "kaja"))
		{
			ABroadCastFormat(COLOR_LIGHTRED, PlayerInfo[playerid][pAdmin], "<< %s %s nullázta a(z) (%d)%s frakció raktárának tartalmát! Adat: Kaja | Régi: %s >>",AdminRangNev(playerid), PlayerName(playerid), fkid, Szervezetneve[fkid-1][1], FormatNumber( kaja, 0, ',' ));
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Raktár tartalma (Kaja) nullázva | Régi: %s", FormatNumber( kaja, 0, ',' ));
			format(szeflog, 256, "%s nullázta a %d. frakció (%s) raktárának kajatartalmát - eredeti mennyiség: %s", PlayerName(playerid), fkid, Szervezetneve[fkid-1][2], kaja), Log("Szef", szeflog);
			FrakcioInfo[fkid][fKaja] = 0;
		}
		elseif(egyezik(mit, "alma"))
		{
			ABroadCastFormat(COLOR_LIGHTRED, PlayerInfo[playerid][pAdmin], "<< %s %s nullázta a(z) (%d)%s frakció raktárának tartalmát! Adat: Alma | Régi: %s >>",AdminRangNev(playerid), PlayerName(playerid), fkid, Szervezetneve[fkid-1][1], FormatNumber( alma, 0, ',' ));
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Raktár tartalma (Alma) nullázva | Régi: %s", FormatNumber( alma, 0, ',' ));
			format(szeflog, 256, "%s nullázta a %d. frakció (%s) raktárának materialtartalmát - eredeti mennyiség: %s", PlayerName(playerid), fkid, Szervezetneve[fkid-1][2], alma), Log("Szef", szeflog);
			FrakcioInfo[fkid][fAlma] = 0;
		}
		elseif(egyezik(mit, "ruha"))
		{
			for(new s = 0; s < 49; s++) if(FrakcioInfo[fkid][fRuha][s] != 0) FrakcioInfo[fkid][fRuha][s] = 0;
			ABroadCastFormat(COLOR_LIGHTRED, PlayerInfo[playerid][pAdmin], "<< %s %s nullázta a(z) (%d)%s frakció raktárának tartalmát! Adat: Ruha >>",AdminRangNev(playerid), PlayerName(playerid), fkid, Szervezetneve[fkid-1][1]);
			SendClientMessage(playerid, COLOR_LIGHTGREEN, "* Raktár tartalma (Ruha) nullázva");
			format(szeflog, 256, "%s nullázta a %d. frakció (%s) raktárának ruhatartalmát", PlayerName(playerid), fkid, Szervezetneve[fkid-1][2]), Log("Szef", szeflog);
		}
		elseif(egyezik(mit, "c4"))
		{
			ABroadCastFormat(COLOR_LIGHTRED, PlayerInfo[playerid][pAdmin], "<< %s %s nullázta a(z) (%d)%s frakció raktárának tartalmát! Adat: C4 | Régi: %s >>",AdminRangNev(playerid), PlayerName(playerid), fkid, Szervezetneve[fkid-1][1], FormatNumber( c4, 0, ',' ));
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Raktár tartalma (C4) nullázva | Régi: %s", FormatNumber( c4, 0, ',' ));
			format(szeflog, 256, "%s nullázta a %d. frakció (%s) raktárának materialtartalmát - eredeti mennyiség: %d", PlayerName(playerid), fkid, Szervezetneve[fkid-1][2], c4), Log("Szef", szeflog);
			FrakcioInfo[fkid][fC4] = 0;
		}
		INI_Save(INI_TYPE_FRAKCIO, fkid);
	}
	return 1;
}

ALIAS(k5zmunka):kozmunka;
CMD:kozmunka(playerid, params[])
{
	if(PInfo(playerid,Jailed) != 14) return Msg(playerid, "Nem a fegyenctelepen vagy elhelyezve, ezért nem kérhetsz közmunkás enyhítést!");
	if(JailTime[playerid] >= 1200) return Msg(playerid, "Nem kérhetsz közmunkát, mivel 20 évet ((percet)) vagy annál többet kell leülnöd!");
	if(PInfo(playerid,JailTime) > 900) return Msg(playerid, "A büntetésed még több, mint 15 év ((perc))!");
	if(PInfo(playerid,Kozmunka) != 0) return Msg(playerid, "Te már kérvényeztél valamilyen közmunkát!");
	new munka[32];
	if(sscanf(params, "s[32]", munka)) return Msg(playerid, "/közmunka [Fûnyírás/Úttisztítás]");
	new Float:yay[3];
	if(egyezik(munka, "fûnyírás") || egyezik(munka, "funyiras"))
	{
		CopMsgFormat(COLOR_ALLDEPT, "[Fegyenctelep] Figyelem: %s közmunkás enyhítést kért", ICPlayerName(playerid));
		CopMsgFormat(COLOR_ALLDEPT, "[Fegyenctelep] ezt a vádat enyhíti: %s - ezzel enyhíti a vádat: fûnyírás", PlayerInfo[playerid][pJailOK]);
		SendClientMessage(playerid, COLOR_LIGHTBLUE, "* Menj egy fûnyíró traktorhoz, ülj rá, és a /fûnyírás paranccsal kezdd el ledolgozni az idõdet.");
		SendClientMessage(playerid, COLOR_LIGHTBLUE, "* Figyelem: A közmunka letöltésére 3 játszott óra lehetõséged van.");
		SendClientMessage(playerid, COLOR_LIGHTBLUE, "* Ez idõ alatt nem vehetsz elõ fegyvert, és nem warozhatsz.");
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0, "unjail7_kozmunkafunyiras");
		SetPlayerWorldBounds(playerid,20000.0000,-20000.0000,20000.0000,-20000.0000);
	 	//PlayerInfo[playerid][pTeleportAlatt] = 1;
		SetPlayerPos(playerid, 2029.5023, -1404.1078, 17.2503);
		PlayerInfo[playerid][pJailed] = 0;
		PlayerInfo[playerid][pKozmunka] = MUNKA_FUNYIRO;
		PlayerInfo[playerid][pKozmunkaIdo] = 3;
		GetPlayerPos(playerid, ArrExt(yay));
		KozmunkasFelirat[playerid] = CreateDynamic3DTextLabel("Közmunkás\nFûnyírás", 0x640000FF, 0.0, 0.0, 0.15, 25.0, playerid, INVALID_VEHICLE_ID);
	}
	elseif(egyezik(munka, "úttisztítás") || egyezik(munka, "uttisztitas"))
	{
		CopMsgFormat(COLOR_ALLDEPT, "[Fegyenctelep] Figyelem: %s közmunkás enyhítést kért", ICPlayerName(playerid));
		CopMsgFormat(COLOR_ALLDEPT, "[Fegyenctelep] ezt a vádat enyhíti: %s - ezzel enyhíti a vádat: úttisztítás", PlayerInfo[playerid][pJailOK]);
		SendClientMessage(playerid, COLOR_LIGHTBLUE, "* Menj egy úttisztítós kocsihoz, ülj bele, és a /úttisztítás paranccsal kezd el ledolgozni az idõdet.");
		SendClientMessage(playerid, COLOR_LIGHTBLUE, "* Figyelem: A közmunka letöltésére 3 játszott óra lehetõséged van.");
		SendClientMessage(playerid, COLOR_LIGHTBLUE, "* Ez idõ alatt nem vehetsz elõ fegyvert, és nem warozhatsz.");
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0, "unjail7_kozmunkauttisztitas");
		SetPlayerWorldBounds(playerid,20000.0000,-20000.0000,20000.0000,-20000.0000);
	 	//PlayerInfo[playerid][pTeleportAlatt] = 1;
		SetPlayerPos(playerid, 2029.5023, -1404.1078, 17.2503);
		PlayerInfo[playerid][pJailed] = 0;
		PlayerInfo[playerid][pKozmunka] = MUNKA_UTTISZTITO;
		PlayerInfo[playerid][pKozmunkaIdo] = 3;
		GetPlayerPos(playerid, ArrExt(yay));
		KozmunkasFelirat[playerid] = CreateDynamic3DTextLabel("Közmunkás\nÚttisztító", 0x640000FF, 0.0, 0.0, 0.15, 25.0);
	}
	return 1;
}

CMD:koszt(playerid, params[])
{
	if(FloodCheck(playerid)) return 1;
	if(IsACop(playerid)) return Msg(playerid, "Megéheztél? :-D");
	if(Evett[playerid] > UnixTime) return SendFormatMessage(playerid, COLOR_LIGHTRED, "ClassRPG: Legközelebb %d másodperc múlva kérhetsz kosztot!", Evett[playerid]-UnixTime);
	//if(PInfo(playerid,Jailed) != 7) return Msg(playerid, "Nem a fegyenctelepen vagy elhelyezve, így nem kérhetsz kosztot!");
	
	new bool:ehet;
	
	// jail
	if(PInfo(playerid,Jailed))
		ehet = true;
		
	// hajléktalan szálló
	if(GetPlayerDistanceFromPoint(playerid, 1160.227, 2561.498, 10.992) < 10.0 && GetPlayerVirtualWorld(playerid) == 146) 
		ehet = true;
	
	if(!ehet)
		return Msg(playerid, "Itt nem ehetsz!");
	
	new kaja[32];
	if(sscanf(params, "s[32]", kaja)) return Msg(playerid, "/koszt [bableves/tojásleves/sertéspörkölt/rántotthús/borsófozelék/krumplifõzelék]");
	if(egyezik(kaja, "bableves"))
		Szukseglet(playerid, -7.5, -2.5),Cselekves(playerid, "kért egy adag bablevest.");
	elseif(egyezik(kaja, "tojásleves") || egyezik(kaja, "tojasleves"))
		Szukseglet(playerid, -2.5, -5.0),Cselekves(playerid, "kért egy adag tojáslevest.");
	elseif(egyezik(kaja, "sertéspörkölt") || egyezik(kaja, "sertesporkolt") || egyezik(kaja, "pörkölt") || egyezik(kaja, "porkolt"))
		Szukseglet(playerid, -10.0),Cselekves(playerid, "kért egy adag sertéspörköltet.");
	elseif(egyezik(kaja, "rántotthús") || egyezik(kaja, "rantotthus"))
		Szukseglet(playerid, -9.0, -1.0),Cselekves(playerid, "kért egy adag rántotthúst.");
	elseif(egyezik(kaja, "borsófozelék") || egyezik(kaja, "borsofozelek"))
		Szukseglet(playerid, -8.5, -1.5),Cselekves(playerid, "kért egy adag borsófõzeléket.");
	elseif(egyezik(kaja, "krumplifõzelék") || egyezik(kaja, "krumplifozelek"))
		Szukseglet(playerid, -4.5, -5.5),Cselekves(playerid, "kért egy adag krumplifõzeléket.");
	else return Msg(playerid,"Nincs ilyen koszt.");
	
	Evett[playerid] = UnixTime+30;
	ApplyAnimation(playerid, "FOOD", "EAT_Burger", 3.0, 0, 0, 0, 0, 0);
	//SendClientMessage(playerid, COLOR_GREEN, "Kértél egy menüt, nem kell sietned, öt percenként szolgálnak ki újra! Jó étvágyat!");
	return 1;
}

CMD:adatforgalom(playerid, params[])
{
	new ertek;
	if(PlayerInfo[playerid][pPbiskey] != BIZ_TELEFON && !Admin(playerid, 1337)) return Msg(playerid, "Ez a parancs csak a telefonszolgáltató tulajdonosának érhetõ el!");
	if(AdatforgalomValtoztatas > UnixTime) return SendFormatMessage(playerid, COLOR_LIGHTRED, "ClassRPG: Nem módosíthatod az adatforgalmat, egy héten csak egyszer szabad! Legközelebb %d nap múlva lehet", (AdatforgalomValtoztatas-UnixTime)/3600);
	if(sscanf(params, "d", ertek)) return Msg(playerid, "/adatforgalom [ár]");
	if(ertek < 0 || ertek > 100) return Msg(playerid, "0-100 közötti értéket adj meg!");
	AdatforgalomAr = ertek;
	AdatforgalomValtoztatas = UnixTime+604800;
	SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Adatforgalom ár átírva ennyire: %d Ft - Ez 1 kb adatforgalom ára!", ertek);
	return 1;
}

CMD:mobilnet(playerid, params[])
{
	new wp[32];
	if(PlayerInfo[playerid][pMobilnet] == NINCS) return Msg(playerid, "Nincs mobilnet szerzodésed!");
	if(sscanf(params, "s[32]", wp)) return Msg(playerid, "/mobilnet [Adatforgalmam/Lemond/Ár]");
	if(egyezik(wp, "adatforgalmam"))
		SendFormatMessage(playerid, COLOR_DARKYELLOW, "[ClassTel] Önnek jelenleg %d kb elhasznált adatforgalma van.", PlayerInfo[playerid][pMobilnet]);
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
			SendFormatMessage(playerid, COLOR_DARKYELLOW, "[ClassTel] Ön sikeresen lemondta mobilnet szerzõdését, a szerzõdésbontás miatt %d forintot fizetett (20000 Ft + elhasznált adatforgalom)!", ar+20000);
		}
		else
		{
			BizPenz(BIZ_TELEFON, 20000);
			if(PlayerInfo[playerid][pBankSzamla] > 0)
				PlayerInfo[playerid][pAccount] -= 20000;
			else
				GiveMoney(playerid, -20000);
			SendClientMessage(playerid, COLOR_DARKYELLOW, "[ClassTel] Ön sikeresen lemondta mobilnet szerzõdését, a szerzõdésbontás miatt 20000 Forintot fizetett!");
		}
		PlayerInfo[playerid][pMobilnet] = NINCS;
	}
	elseif(egyezik(wp, "ár") || egyezik(wp, "ar"))
		SendFormatMessage(playerid, COLOR_DARKYELLOW, "[ClassTel] A jelenlegi adatforgalom ár: %d Ft/kb", AdatforgalomAr);
	return 1;
}

CMD:wifi(playerid, params[])
{
	new param[32], sparam[32];
	if(FloodCheck(playerid)) return 1;
	if(PlayerInfo[playerid][pLaptop] == 0) return Msg(playerid, "Nincs laptopod!");
	if(sscanf(params, "s[32]S()[32]", param, sparam)) return Msg(playerid, "Használata: /wifi [csatlakozás/lecsatlakozás/közel/pontok]");
	if(egyezik(param, "csatlakozás") || egyezik(param, "csatlakozas") || egyezik(param, "connect"))
	{
		new wifipont = GetClosestWifiPoint(playerid), wifierosseg = GetWifiSignal(playerid, wifipont);
		if(wifierosseg < 10) return Msg(playerid, "Nincs közeledben wifi pont!");
		SendFormatMessage(playerid, COLOR_LIGHTGREEN, "... Csatlakozás ehhez a hotspothoz: {FFFFFF}%s {9ACD32}...", WifiPont[wifipont][wNev]);
		MunkaFolyamatban[playerid] = 1;
		SetTimerEx("Munkavege", 5000, false, "ddd", playerid, M_WIFICONNECT, wifipont);
	}
	elseif(egyezik(param, "közel") || egyezik(param, "kozel"))
	{
		new Float:tavolsag, Float:s[3], wifipont = 0;
		GetPlayerPos(playerid, ArrExt(s));
		SendClientMessage(playerid, COLOR_DARKYELLOW, "===[ Közelben található Wifi Hotspot(ok) ]===");
		for(new a = 0; a < sizeof(WifiPont); a++)
		{
			tavolsag = GetDistanceBetweenPoints(ArrExt(s), ArrExt(WifiPont[a][wPos]));
			if(tavolsag <= 100.0 && GetPlayerVirtualWorld(playerid) == WifiPont[a][wVw] && GetPlayerInterior(playerid) == WifiPont[a][wInt])
			{
				new wifi = GetWifiSignal(playerid, a);
				wifipont++;
				SendFormatMessage(playerid, COLOR_WHITE, "%s - Jelerõsség: %d százalék - HotSpot ID: %d", WifiPont[a][wNev], wifi, WifiPont[a][wID]);
			}
		}
		if(wifipont < 1) return Msg(playerid, "A közelben nincs egyetlen wifi hotspot sem!");
	}
	elseif(egyezik(param, "lecsatlakozás") || egyezik(param, "lecsatlakozas") || egyezik(param, "disconnect"))
	{
		if(!LaptopConnected[playerid]) return Msg(playerid, "Nem csatlakoztál hotspothoz!");
		
		SendFormatMessage(playerid, COLOR_LIGHTGREEN, "... Lecsatlakozva errõl a hotspotról: {FFFFFF}%s {9ACD32}...", WifiPont[LaptopIP[playerid]][wNev]);
		LaptopIP[playerid] = NINCS;
		LaptopConnected[playerid] = false;
	}
	elseif(egyezik(param, "pontok"))
	{
		new wifipont = 0;
		SendClientMessage(playerid, COLOR_DARKYELLOW, "===[ Wifi Hotspotok listája ]===");
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
		if(sscanf(sparam, "s[32]", nev)) return Msg(playerid, "/wifi lerak [Wifipont neve - ClassHotSpot_név]");
		new Float:p[3], int = GetPlayerInterior(playerid), vw = GetPlayerVirtualWorld(playerid);
		GetPlayerPos(playerid, ArrExt(p));
		CreateWifi(ArrExt(p), vw, int, nev);
		SendFormatMessage(playerid, COLOR_LIGHTRED, "ClassRPG: Wifi hotspot lerakva, neve: ClassHotSpot_%s", nev);
		Format(_tmpString, "%s lerakott egy wifi hotspotot, név: ClassHotSpot_%s", nev);
		Log("Scripter", _tmpString);
	}
	return 1;
}

ALIAS(tdsz3n):textdrawszin;
ALIAS(tdszin):textdrawszin;
ALIAS(textdrawsz3n):textdrawszin;
CMD:textdrawszin(playerid, params[])
{
	ShowPlayerDialog(playerid, DIALOG_TEXTDRAW_COLOR, DIALOG_STYLE_LIST, "Textdrawháttér szín választása", "{505055}Fekete\n{FFFFFF}Fehér\n{22AAFF}Kék\n{111133}Sötétkék\n{00D900}Világoszöld\n{33AA33}Sötétzöld\n{AA0000}Piros\n{FFFF00}Sárga\n{FF1493}Pink\nÁtlátszó", "Kiválaszt", "Mégse");
	SendClientMessage(playerid, COLOR_SPEC, "Válaszd ki azt a színt, amelyet textdraw háttérként szeretnél használni!");
	return 1;
}

CMD:arany(playerid, params[])
{
	new pm[32], spm[32];
	if(FloodCheck(playerid)) return 1;
	if(!IsAt(playerid, IsAt_Bank)) return Msg(playerid, "Csak bankban használható!");
	if(sscanf(params, "s[32]S()[32]", pm, spm)) return Msg(playerid, "Használata: /arany [vétel/berak/kivesz/elad/információ]");
	/*if(egyezik(pm, "vétel") || egyezik(pm,"vetel") || egyezik(pm, "vesz"))
	{
		new db;
		if(sscanf(spm, "d", db)) return Msg(playerid, "Használata: /arany vétel [darab]");
		if(db < 1 || db > 5) return Msg(playerid, "Egyszerre maximum 5 darabot tudunk eloállítani! A minimális vásárlási mennyiség: 1 db");
		if(!BankkartyaFizet(playerid, db*50000000)) return SendFormatMessage(playerid, COLOR_LIGHTRED, "%d darab arany %s Forintba kerül, ennyit nem bír kifizetni!", db, FormatInt(db*50000000));
		if(Biztos[playerid] != 1)
		{
			SendClientMessage(playerid, COLOR_DARKYELLOW, "=====[ Banki üzenet ]=====");
			SendClientMessage(playerid, COLOR_WHITE, "Kérem gondolja át alaposan, hogy befekteti-e pénzét aranyba!");
			SendFormatMessage(playerid, COLOR_WHITE, "%d darab arany megvásárlása után %s Ft marad egyenlegén!", db, FormatInt(PlayerInfo[playerid][pAccount] - 50000000*db));
			SendClientMessage(playerid, COLOR_WHITE, "A muvelet nem visszavonható, így ha ténylegesen meg szeretné válaszolni, írja be mégegyszer a parancsot!");
			Biztos[playerid] = 1;
		}
		else
		{
			PlayerInfo[playerid][pArany] += db;
			BankSzef += db*10000000;
			SendClientMessage(playerid, COLOR_DARKYELLOW, "=====[ Banki üzenet ]=====");
			SendFormatMessage(playerid, COLOR_WHITE, "Sikeres vásárlás! Egyenlegérol levontunk %s Ft-t, így maradt %s Ft!", FormatInt(50000000*db), FormatInt(PlayerInfo[playerid][pAccount]));
			SendClientMessage(playerid, COLOR_WHITE, "Köszönjük, hogy minket választott! Aranyait berakhatja bankba, mellyel aranyai után "#ARANY_KAMAT"%%-os kamathoz juthat!");
			Biztos[playerid] = 0;
		}
	}
	else*/
	/*
	if(egyezik(pm, "berak") || egyezik(pm, "befektet"))
	{
		new db;
		if(PlayerInfo[playerid][pArany] == 0) return Msg(playerid, "Nincs arany Önnél!");
		if(sscanf(spm, "d", db)) return Msg(playerid, "Használata: /arany befektet [darab]");
		if(db < 1) return Msg(playerid, "Persze..");
		if(PlayerInfo[playerid][pArany] < db) return Msg(playerid, "Nincs ennyi arany Önnél!");
		if(Biztos[playerid] != 1)
		{
			SendClientMessage(playerid, COLOR_DARKYELLOW, "=====[ Banki üzenet ]=====");
			SendClientMessage(playerid, COLOR_WHITE, "Kérem gondolja át alaposan, hogy befekteti-e az aranyait!");
			SendFormatMessage(playerid, COLOR_WHITE, "%d darab arany befektetése után %.3f százalék kamatot kap!", db, db*ARANY_KAMAT);
			SendClientMessage(playerid, COLOR_WHITE, "Amennyiben tényleg ezt szeretné, írja be mégegyszer a parancsot!");
			Biztos[playerid] = 1;
		}
		else
		{
			PlayerInfo[playerid][pArany] -= db;
			PlayerInfo[playerid][pAranyBank] += db;
			SendClientMessage(playerid, COLOR_DARKYELLOW, "=====[ Banki üzenet ]=====");
			SendFormatMessage(playerid, COLOR_WHITE, "Sikeres befektetés! %d darab aranyt fektetett be bankunkba, mely után %.3f%% kamatot kap!", db, db*ARANY_KAMAT);
			SendClientMessage(playerid, COLOR_WHITE, "Köszönjük, hogy minket választott! ClassBank Zrt.");
			Biztos[playerid] = 0;
		}
	}*/
	else if(egyezik(pm, "kivesz"))
	{
		new db;
		if(PlayerInfo[playerid][pAranyBank] == 0) return Msg(playerid, "Ön még nem fektetett be aranyat a bankba!");
		if(sscanf(spm, "d", db)) return Msg(playerid, "Használata: /arany kivesz [darab]");
		if(db < 1) return Msg(playerid, "Persze..");
		if(PlayerInfo[playerid][pAranyBank] < db) return Msg(playerid, "Nincs ennyi aranya a bankban!");
		if(Biztos[playerid] != 1)
		{
			SendClientMessage(playerid, COLOR_DARKYELLOW, "=====[ Banki üzenet ]=====");
			SendClientMessage(playerid, COLOR_WHITE, "Kérem gondolja át alaposan, hogy megszünteti-e befektetését!");
			SendFormatMessage(playerid, COLOR_WHITE, "%d darab arany kivétele után %.3f%% kamattól esik el!", db, db*ARANY_KAMAT);
			SendClientMessage(playerid, COLOR_WHITE, "Amennyiben tényleg ezt szeretné, írja be mégegyszer a parancsot!");
			Biztos[playerid] = 1;
		}
		else
		{
			PlayerInfo[playerid][pArany] += db;
			PlayerInfo[playerid][pAranyBank] -= db;
			SendClientMessage(playerid, COLOR_DARKYELLOW, "=====[ Banki üzenet ]=====");
			SendFormatMessage(playerid, COLOR_WHITE, "Sikeres kivétel! %d darab aranyt vett ki bankunkból, így %.3f%% kamattól esett el!", db, db*ARANY_KAMAT);
			SendClientMessage(playerid, COLOR_WHITE, "Köszönjük, hogy minket választott! ClassBank Zrt.");
			Biztos[playerid] = 0;
		}
	}
	else if(egyezik(pm, "info") || egyezik(pm, "infó") || egyezik(pm, "információ") || egyezik(pm, "informacio"))
	{
		SendClientMessage(playerid, COLOR_DARKYELLOW, "=====[ Banki üzenet ]=====");
		SendFormatMessage(playerid, COLOR_WHITE, "Jelenleg %ddb aranya van, mely után %.3f%% kamatot kap.", PlayerInfo[playerid][pAranyBank], PlayerInfo[playerid][pAranyBank] * ARANY_KAMAT);
		SendClientMessage(playerid, COLOR_WHITE, "Jelenleg egy darab aranyrúd ára: 50,000,000 Ft.");
		SendClientMessage(playerid, COLOR_WHITE, "Banki befektetés esetén a befektetett aranyak száma után "#ARANY_KAMAT"%% kamatot kap aranyrudanként.");
		SendClientMessage(playerid, COLOR_WHITE, "Az arany használható fizetoeszközként, illetve befektetésként is.");
	}
	else if(egyezik(pm, "elad"))
	{
		//if(UnixTime > 1391990399)
		//	return Msg(playerid, "Már nincs lehetoség arany eladására");
			
		new db;
		if(PlayerInfo[playerid][pAranyBank] == 0) return Msg(playerid, "Ön még nem fektetett be aranyat a bankba!");
		if(sscanf(spm, "d", db)) return Msg(playerid, "Használata: /arany elad [darab]");
		if(db < 1) return Msg(playerid, "Persze..");
		if(PlayerInfo[playerid][pAranyBank] < db) return Msg(playerid, "Nincs ennyi aranya a bankban!");
		if(Biztos[playerid] != 1)
		{
			SendClientMessage(playerid, COLOR_DARKYELLOW, "=====[ Banki üzenet ]=====");
			SendClientMessage(playerid, COLOR_WHITE, "Kérem gondolja át alaposan, hogy eladja-e aranyait a banknak!");
			SendClientMessage(playerid, COLOR_WHITE, "Egy aranyrudat 49 millió forintért vásárol vissza a bank!");
			SendFormatMessage(playerid, COLOR_WHITE, "%d darab arany eladásáért %d forintot fog érte kapni!", db, db*49000000);
			SendClientMessage(playerid, COLOR_WHITE, "Amennyiben tényleg ezt szeretné, írja be mégegyszer a parancsot!");
			Biztos[playerid] = 1;
		}
		else
		{
			PlayerInfo[playerid][pAranyBank] -= db;
			PlayerInfo[playerid][pAccount] += 49000000*db;
			SendClientMessage(playerid, COLOR_DARKYELLOW, "=====[ Banki üzenet ]=====");
			SendFormatMessage(playerid, COLOR_WHITE, "Sikeres kivétel! %d darab aranyt adott el, mely után %s Ft-t kapott!", db, FormatInt(49000000*db));
			SendClientMessage(playerid, COLOR_WHITE, "Köszönjük, hogy minket választott! ClassBank Zrt.");
			Biztos[playerid] = 0;
		}
	}
	else if(egyezik(pm, "set"))
	{
		new uid, type[32], amount, zseb = PlayerInfo[uid][pArany], bank = PlayerInfo[uid][pAranyBank];
		if(!IsScripter(playerid)) return 1;
		if(IdgScripter[playerid]) return Msg(playerid, "Csak a rendes scripterek használhatják!");
		if(sscanf(spm, "rs[32]d", uid, type, amount)) return Msg(playerid, "Használata: /arany set [Név/ID] [Zseb/Bank] [Mennyiség]");
		if(uid == INVALID_PLAYER_ID) return Msg(playerid, "Nem létezo játékos");
		if(amount < 0) return Msg(playerid, "A minimum érték 0!");
		if(egyezik(type, "zseb"))
		{
			ABroadCastFormat(COLOR_LIGHTRED, PlayerInfo[playerid][pAdmin], "<< %s %s beállította %s zsebében lévo aranyának mennyiségét! Új: %s | Régi: %s >>",AdminRangNev(playerid), PlayerName(playerid), PlayerName(uid), FormatNumber( amount, 0, ',' ), FormatNumber( zseb, 0, ',' ));
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* %s zsebe beállítva: %sdb Arany | Régi: %s", PlayerName(uid), FormatNumber( amount, 0, ',' ), FormatNumber( zseb, 0, ',' ));
			PlayerInfo[uid][pArany] = amount;
		}
		elseif(egyezik(type, "bank"))
		{
			ABroadCastFormat(COLOR_LIGHTRED, PlayerInfo[playerid][pAdmin], "<< %s %s beállította %s bankban lévo aranyának mennyiségét! Új: %s (%.3f%%) | Régi: %s (%.3f%%) >>",AdminRangNev(playerid), PlayerName(playerid), PlayerName(uid), FormatNumber( amount, 0, ',' ), amount*ARANY_KAMAT, FormatNumber( bank, 0, ',' ), zseb*ARANY_KAMAT);
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* %s zsebe beállítva: %sdb (%.3f%%) Arany | Régi: %s (%.3f%%)", PlayerName(uid), FormatNumber( amount, 0, ',' ), amount*ARANY_KAMAT, FormatNumber( bank, 0, ',' ), bank*ARANY_KAMAT);
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
		Msg(playerid, "KIkapcsoltad a havazást!");
		return 1;
	}
	else
	{
	
		if(IdoJaras[iMost] == NINCS)
			IdojarasValt(playerid, NINCS);
		
		Havazas[playerid]=true;		
		Msg(playerid, "BEkapcsoltad a havazást! A következo havazásnál havazni fog!");
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
	
	if(sscanf(params, "s[9]S()[32]", func,func2)) return Msg(playerid,"/kupon [megnéz / töröl / saját / megmutat]");
	
	if(egyezik(func,"megnéz") || egyezik(func,"saját") || egyezik(func,"megmutat"))
	{
		if(egyezik(func,"megnéz"))
		{
			if(!Admin(playerid,1337)) return Msg(playerid, "Csak foadmin!");
			if(sscanf(func2, "u", player)) return Msg(playerid,"/kupon megnéz [id]");
			if(player == INVALID_PLAYER_ID) return Msg(playerid,"Nincs ilyen játékos!");
			SendFormatMessage(playerid,COLOR_LIGHTRED,"==== %s kuponja====",PlayerName(player));
		}
		else if(egyezik(func,"megmutat"))
		{
			if(player == INVALID_PLAYER_ID) return Msg(playerid,"Nincs ilyen játékos!");
			if(GetDistanceBetweenPlayers(playerid, player) > 3) return Msg(playerid, "Nincs a közeledben!");
			if(sscanf(func2, "u", player)) return Msg(playerid,"/kupon megmutat [id]");
			Msg(playerid, "Megmutattad a kuponodat!");
			Cselekves(playerid, "megmutatta a kuponját!");
			SendFormatMessage(player,COLOR_LIGHTRED,"==== %s kuponja====",PlayerName(playerid));
			
			switch(PlayerInfo[playerid][pAjandek])
			{
				case 1: Msg(player,"Neked/neki egy ingyen kocs alakítása van. ((/alakit))");
				case 2: Msg(player,"Neked/neki egy ingyen ház áthelyezése van.");
				case 3: Msg(player,"Neked/neki egy ingyen ház belso alakítása van.");
				case 4: Msg(player,"Neked/neki egy ingyen öröktuningod van!");
				default: Msg(player,"Neked/neki nincs kuponod!");
			}
			return 1;
		}
		else
			player=playerid;
			
		switch(PlayerInfo[player][pAjandek])
		{
			case 1: Msg(playerid,"Neked/neki egy ingyen kocs alakítása van. ((/alakit))");
			case 2: Msg(playerid,"Neked/neki egy ingyen ház áthelyezése van.");
			case 3: Msg(playerid,"Neked/neki egy ingyen ház belso alakítása van.");
			case 4: Msg(playerid,"Neked/neki egy ingyen öröktuningod van!");
			default: Msg(playerid,"Neked/neki nincs kupond!");
		}
		return 1;
	}
	if(egyezik(func,"töröl"))
	{
		
		if(!Admin(playerid,1337)) return Msg(playerid, "Csak foadmin!");
		if(sscanf(func2, "u",player)) return Msg(playerid,"/kupon töröl [id]");
		if(player == INVALID_PLAYER_ID) return Msg(playerid,"Nincs ilyen játékos!");
		if(PlayerInfo[player][pAjandek] == NINCS) return Msg(playerid, "nincs neki kuponja");
		SendFormatMessage(playerid,COLOR_YELLOW,"Törölted a kuponját %s",PlayerName(player));
		Msg(player,"Törölték a kuponodat!");
		PlayerInfo[player][pAjandek] = NINCS;
		format(log,sizeof(log),"[ajandek]%s törölte %s kuponját",PlayerName(playerid),PlayerName(player));
		Log("Egyeb",log);
		return 1;
	
	}
	

	return 1;
}
/*ALIAS(aj1nd2k):ajandek;
CMD:ajandek(playerid, params[])
{
	
	if(PlayerInfo[playerid][pAjandekUnixtime] > 1) return Msg(playerid, "Már kaptál ajándékot!");
	
	if(PlayerInfo[playerid][pBID] > 8187279) return Msg(playerid, "Csak a karácsonyig létrehozott karakterek kapnak ajándékot!");
	
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
	if(id == NINCS) return Msg(playerid, "Ez nem a te csomagod próbálj másikat!");
	
	
	
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
		
		Msg(playerid, "Kinyitottad az ajándékodat! Az ajándékod 1.000.000 Ft volt! Boldog karácsonyt kívánunk!");
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
						Msg(playerid,"Kinyitottad az ajándékodat! Az ajándékod egy ingyen kocsi alakítás egy olyan modelre aminek UCP ára nem éri el a 80.000.000 FT-ott");
						Msg(playerid,"Ezt az ajándékot oda is adhatod másnak a /átad ajándék parancsal!");
						Msg(playerid, "Ha meg van a választott model, menj lecserélni! ((/alakit))");
						Msg(playerid, "A kuponok nem átválthatóak PÉNZRE adminok által!!!");
						format(log,sizeof(log),"[ajandek] %s kapott egy ingyen kocsi alakítást!",PlayerName(playerid));
						Log("Egyeb",log);
						PlayerInfo[playerid][pAjandek] = 1;
						return 1;
					}
				case 1:
					{
						Msg(playerid,"Kinyitottad az ajándékodat! Az ajándékod egy ingyen házáthelyezés!");
						Msg(playerid,"Ezt az ajándékot oda is adhatod másnak a /átad ajándék parancsal!");
						Msg(playerid, "Ha meg van a választott helyszín, keres fel egy foadmint!");
						PlayerInfo[playerid][pAjandek] = 2;
						Msg(playerid, "A kuponok nem átválthatóak PÉNZRE adminok által!!!");
						format(log,sizeof(log),"[ajandek] %s kapott egy ingyen hátáthelyezést!",PlayerName(playerid));
						Log("Egyeb",log);
						return 1;
					}
				case 2:
					{
						Msg(playerid,"Kinyitottad az ajándékodat! Az ajándékod egy ingyen belso csere!");
						Msg(playerid,"Ezt az ajándékot oda is adhatod másnak a /átad ajándék parancsal!");
						Msg(playerid, "Ha meg van a választott belso, keres fel egy foadmint!");
						format(log,sizeof(log),"[ajandek] %s kapott egy ingyen belso alakítást!",PlayerName(playerid));
						Log("Egyeb",log);
						Msg(playerid, "A kuponok nem átválthatóak PÉNZRE adminok által!!!");
						PlayerInfo[playerid][pAjandek] = 3;
						return 1;
					
					}
				case 3:
					{
						Msg(playerid,"Kinyitottad az ajándékodat! Az ajándékod egy ingyen örök tuning!");
						Msg(playerid,"Ezt az ajándékot oda is adhatod másnak a /átad ajándék parancsal!");
						Msg(playerid, "Ha meg van a választott örök tuning, menj keres fel egy garázst és rakd fel a választottad!");
						PlayerInfo[playerid][pAjandek] = 4;
						Msg(playerid, "A kuponok nem átválthatóak PÉNZRE adminok által!!!");
						format(log,sizeof(log),"[ajandek] %s kapott egy ingyen öröktuningot!",PlayerName(playerid));
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
						Msg(playerid,"Kinyitottad az ajándékodat! Az ajándékod egy ingyen kocsi alakítás egy olyan modelre aminek UCP ára nem éri el a 80.000.000 FT-ott");
						Msg(playerid,"Ezt az ajándékot oda is adhatod másnak a /átad ajándék parancsal!");
						Msg(playerid, "Ha meg van a választott model, menj lecserélni! ((/alakit))");
						PlayerInfo[playerid][pAjandek] = 1;
						Msg(playerid, "A kuponok nem átválthatóak PÉNZRE adminok által!!!");
						format(log,sizeof(log),"[ajandek] %s kapott egy ingyen kocsi alakítást!",PlayerName(playerid));
						Log("Egyeb",log);
						return 1;
					}
				case 1:
					{
						Msg(playerid,"Kinyitottad az ajándékodat! Az ajándékod egy ingyen örök tuning!");
						Msg(playerid,"Ezt az ajándékot oda is adhatod másnak a /átad ajándék parancsal!");
						Msg(playerid, "Ha meg van a választott örök tuning, menj keres fel egy garázst és rakd fel a választottad!");
						PlayerInfo[playerid][pAjandek] = 4;
						Msg(playerid, "A kuponok nem átválthatóak PÉNZRE adminok által!!!");
						format(log,sizeof(log),"[ajandek] %s egy ingyen örök tuningot",PlayerName(playerid));
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
						Msg(playerid,"Kinyitottad az ajándékodat! Az ajándékod egy ingyen házáthelyezés!");
						Msg(playerid,"Ezt az ajándékot oda is adhatod másnak a /átad ajándék parancsal!");
						Msg(playerid, "Ha meg van a választott helyszín, keres fel egy foadmint!");
						PlayerInfo[playerid][pAjandek] = 2;
						Msg(playerid, "A kuponok nem átválthatóak PÉNZRE adminok által!!!");
						format(log,sizeof(log),"[ajandek] %s kapott egy ingyen házáthelyezést",PlayerName(playerid));
						Log("Egyeb",log);
						return 1;
					}
				case 1:
					{
						Msg(playerid,"Kinyitottad az ajándékodat! Az ajándékod egy ingyen belso csere!");
						Msg(playerid,"Ezt az ajándékot oda is adhatod másnak a /átad ajándék parancsal!");
						Msg(playerid, "Ha meg van a választott belso, keres fel egy foadmint!");
						PlayerInfo[playerid][pAjandek] = 3;
						Msg(playerid, "A kuponok nem átválthatóak PÉNZRE adminok által!!!");
						format(log,sizeof(log),"[ajandek] %s kapott egy ingyen belso cserét!",PlayerName(playerid));
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
						Msg(playerid,"Kinyitottad az ajándékodat! Az ajándékod egy aranyrúd!");
						PlayerInfo[playerid][pArany] = 1;
						format(log,sizeof(log),"[ajandek] %s kapott egy aranyrudat",PlayerName(playerid));
						Log("Egyeb",log);
						return 1;
					}
				case 1:
					{
						if(PlayerInfo[playerid][pLaptop] == 0)
						{
						
							Msg(playerid,"Kinyitottad az ajándékodat! Az ajándékod egy laptop!");
							PlayerInfo[playerid][pLaptop] = 1;
							format(log,sizeof(log),"[ajandek] %s kapott egy laptopot",PlayerName(playerid));
							Log("Egyeb",log);
							return 1;
						
						}
						else
						{
							Msg(playerid,"Kinyitottad az ajándékodat! Az ajándékod egy aranyrúd!");
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
						Msg(playerid,"Kinyitottad az ajándékodat! Az ajándékod egy ingyen kocsi alakítás egy olyan modelre aminek UCP ára nem éri el a 80.000.000 FT-ott");
						Msg(playerid,"Ezt az ajándékot oda is adhatod másnak a /átad ajándék parancsal!");
						Msg(playerid, "Ha meg van a választott model, menj lecserélni! ((/alakit))");
						format(log,sizeof(log),"[ajandek] %s kapott egy ingyen kocsi alakítást!",PlayerName(playerid));
						Log("Egyeb",log);
						PlayerInfo[playerid][pAjandek] = 1;
						Msg(playerid, "A kuponok nem átválthatóak PÉNZRE adminok által!!!");
						return 1;
						
					}
				case 1:
					{
						Msg(playerid,"Kinyitottad az ajándékodat! Az ajándékod egy ingyen házáthelyezés!");
						Msg(playerid,"Ezt az ajándékot oda is adhatod másnak a /átad ajándék parancsal!");
						Msg(playerid, "Ha meg van a választott helyszín, keres fel egy foadmint!");
						PlayerInfo[playerid][pAjandek] = 2;
						format(log,sizeof(log),"[ajandek] %s kapott egy ingyen hátáthelyezést!",PlayerName(playerid));
						Log("Egyeb",log);
						Msg(playerid, "A kuponok nem átválthatóak PÉNZRE adminok által!!!");
						return 1;
					}
				case 2:
					{
						Msg(playerid,"Kinyitottad az ajándékodat! Az ajándékod egy ingyen belso csere!");
						Msg(playerid,"Ezt az ajándékot oda is adhatod másnak a /átad ajándék parancsal!");
						Msg(playerid, "Ha meg van a választott belso, keres fel egy foadmint!");
						format(log,sizeof(log),"[ajandek] %s kapott egy ingyen belso alakítást!",PlayerName(playerid));
						Log("Egyeb",log);
						Msg(playerid, "A kuponok nem átválthatóak PÉNZRE adminok által!!!");
						PlayerInfo[playerid][pAjandek] = 3;
						return 1;
					
					}
				case 3:
					{
						Msg(playerid,"Kinyitottad az ajándékodat! Az ajándékod egy ingyen örök tuning!");
						Msg(playerid,"Ezt az ajándékot oda is adhatod másnak a /átad ajándék parancsal!");
						Msg(playerid, "Ha meg van a választott örök tuning, menj keres fel egy garázst és rakd fel a választottad!");
						PlayerInfo[playerid][pAjandek] = 4;
						format(log,sizeof(log),"[ajandek] %s kapott egy ingyen öröktuningot!",PlayerName(playerid));
						Log("Egyeb",log);
						Msg(playerid, "A kuponok nem átválthatóak PÉNZRE adminok által!!!");
						return 1;

					}
				case 4:
					{
						Msg(playerid,"Kinyitottad az ajándékodat! Az ajándékod 1500g heroin!");
						PlayerInfo[playerid][pHeroin] +=1500;
						format(log,sizeof(log),"[ajandek] %s kapott 1500g heroint!",PlayerName(playerid));
						Log("Egyeb",log);
						return 1;
					}
				case 5:
					{
						Msg(playerid,"Kinyitottad az ajándékodat! Az ajándékod 2000g Kokain!");
						PlayerInfo[playerid][pKokain] +=2000;
						format(log,sizeof(log),"[ajandek] %s kapott 2000g kokaint!",PlayerName(playerid));
						Log("Egyeb",log);
						return 1;
					}
				case 6:
					{
						Msg(playerid,"Kinyitottad az ajándékodat! Az ajándékod 30.000db material!");
						PlayerInfo[playerid][pMats] +=30000;
						format(log,sizeof(log),"[ajandek] %s kapott 30.000db materialt",PlayerName(playerid));
						Log("Egyeb",log);
						return 1;
					}
				case 7:
					{
						Msg(playerid,"Kinyitottad az ajándékodat! Az ajándékod 1000g Marihuana!");
						PlayerInfo[playerid][pMarihuana] +=1000;
						format(log,sizeof(log),"[ajandek] %s kapott 1000g marihuanat",PlayerName(playerid));
						Log("Egyeb",log);
						return 1;
					}
				case 8:
					{
						Msg(playerid,"Kinyitottad az ajándékodat! Az ajándékod egy Sniper és 100 loszer hozzá!");
						WeaponGiveWeapon(playerid, WEAPON_SNIPER, .maxweapon = 0);
						WeaponGiveAmmo(playerid, WEAPON_SNIPER, 100);
						format(log,sizeof(log),"[ajandek] %s kapott egy Sniper-t 1000 loszerrel!",PlayerName(playerid));
						Log("Egyeb",log);
						return 1;
					}
				case 9:
					{
						Msg(playerid,"Kinyitottad az ajándékodat! Az ajándékod egy M4-es 500 loszerrel!");
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
						Msg(playerid,"Kinyitottad az ajándékodat! Az ajándékod egy ingyen kocsi alakítás egy olyan modelre aminek UCP ára nem éri el a 80.000.000 FT-ott");
						Msg(playerid,"Ezt az ajándékot oda is adhatod másnak a /átad ajándék parancsal!");
						Msg(playerid, "Ha meg van a választott model, menj lecserélni! ((/alakit))");
						PlayerInfo[playerid][pAjandek] = 1;
						format(log,sizeof(log),"[ajandek] %s kapott egy ingyen kocsi alakítást!",PlayerName(playerid));
						Log("Egyeb",log);
						return 1;
					}
				case 1:
					{
						Msg(playerid,"Kinyitottad az ajándékodat! Az ajándékod egy ingyen örök tuning!");
						Msg(playerid,"Ezt az ajándékot oda is adhatod másnak a /átad ajándék parancsal!");
						Msg(playerid, "Ha meg van a választott örök tuning, menj keres fel egy garázst és rakd fel a választottad!");
						PlayerInfo[playerid][pAjandek] = 4;
						format(log,sizeof(log),"[ajandek] %s egy ingyen örök tuningot",PlayerName(playerid));
						Log("Egyeb",log);
						return 1;

					}
				case 2:
					{
						Msg(playerid,"Kinyitottad az ajándékodat! Az ajándékod 1500g heroin!");
						PlayerInfo[playerid][pHeroin] +=1500;
						format(log,sizeof(log),"[ajandek] %s kapott 1500g heroint!",PlayerName(playerid));
						Log("Egyeb",log);
						return 1;
					}
				case 3:
					{
						Msg(playerid,"Kinyitottad az ajándékodat! Az ajándékod 2000g Kokain!");
						PlayerInfo[playerid][pKokain] +=2000;
						format(log,sizeof(log),"[ajandek] %s kapott 2000g kokaint!",PlayerName(playerid));
						Log("Egyeb",log);
						return 1;
					}
				case 4:
					{
						Msg(playerid,"Kinyitottad az ajándékodat! Az ajándékod 30.000db material!");
						PlayerInfo[playerid][pMats] +=30000;
						format(log,sizeof(log),"[ajandek] %s kapott 30.000db materialt",PlayerName(playerid));
						Log("Egyeb",log);
						return 1;
					}
				case 5:
					{
						Msg(playerid,"Kinyitottad az ajándékodat! Az ajándékod 1000g Marihuana!");
						PlayerInfo[playerid][pMarihuana] +=1000;
						format(log,sizeof(log),"[ajandek] %s kapott 1000g marihuanat",PlayerName(playerid));
						Log("Egyeb",log);
						return 1;
					}
				case 6:
					{
						Msg(playerid,"Kinyitottad az ajándékodat! Az ajándékod egy Sniper és 100 loszer hozzá!");
						WeaponGiveWeapon(playerid, WEAPON_SNIPER, .maxweapon = 0);
						WeaponGiveAmmo(playerid, WEAPON_SNIPER, 100);
						format(log,sizeof(log),"[ajandek] %s kapott egy Sniper-t 1000 loszerrel!",PlayerName(playerid));
						Log("Egyeb",log);
						return 1;
					}
				case 7:
					{
						Msg(playerid,"Kinyitottad az ajándékodat! Az ajándékod egy M4-es 500 loszerrel!");
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
						Msg(playerid,"Kinyitottad az ajándékodat! Az ajándékod egy ingyen házáthelyezés!");
						Msg(playerid,"Ezt az ajándékot oda is adhatod másnak a /átad ajándék parancsal!");
						Msg(playerid, "Ha meg van a választott helyszín, keres fel egy foadmint!");
						PlayerInfo[playerid][pAjandek] = 2;
						format(log,sizeof(log),"[ajandek] %s kapott egy ingyen házáthelyezést",PlayerName(playerid));
						Log("Egyeb",log);
						return 1;
					}
				case 1:
					{
						Msg(playerid,"Kinyitottad az ajándékodat! Az ajándékod egy ingyen belso csere!");
						Msg(playerid,"Ezt az ajándékot oda is adhatod másnak a /átad ajándék parancsal!");
						Msg(playerid, "Ha meg van a választott belso, keres fel egy foadmint!");
						PlayerInfo[playerid][pAjandek] = 3;
						format(log,sizeof(log),"[ajandek] %s kapott egy ingyen belso cserét!",PlayerName(playerid));
						Log("Egyeb",log);
						return 1;
					
					}
				case 2:
					{
						Msg(playerid,"Kinyitottad az ajándékodat! Az ajándékod 1500g heroin!");
						PlayerInfo[playerid][pHeroin] +=1500;
						format(log,sizeof(log),"[ajandek] %s kapott 1500g heroint!",PlayerName(playerid));
						Log("Egyeb",log);
						return 1;
					}
				case 3:
					{
						Msg(playerid,"Kinyitottad az ajándékodat! Az ajándékod 2000g Kokain!");
						PlayerInfo[playerid][pKokain] +=2000;
						format(log,sizeof(log),"[ajandek] %s kapott 2000g kokaint!",PlayerName(playerid));
						Log("Egyeb",log);
						return 1;
					}
				case 4:
					{
						Msg(playerid,"Kinyitottad az ajándékodat! Az ajándékod 30.000db material!");
						PlayerInfo[playerid][pMats] +=30000;
						format(log,sizeof(log),"[ajandek] %s kapott 30.000db materialt",PlayerName(playerid));
						Log("Egyeb",log);
						return 1;
					}
				case 5:
					{
						Msg(playerid,"Kinyitottad az ajándékodat! Az ajándékod 1000g Marihuana!");
						PlayerInfo[playerid][pMarihuana] +=1000;
						format(log,sizeof(log),"[ajandek] %s kapott 1000g marihuanat",PlayerName(playerid));
						Log("Egyeb",log);
						return 1;
					}
				case 6:
					{
						Msg(playerid,"Kinyitottad az ajándékodat! Az ajándékod egy Sniper és 100 loszer hozzá!");
						WeaponGiveWeapon(playerid, WEAPON_SNIPER, .maxweapon = 0);
						WeaponGiveAmmo(playerid, WEAPON_SNIPER, 100);
						format(log,sizeof(log),"[ajandek] %s kapott egy Sniper-t 1000 loszerrel!",PlayerName(playerid));
						Log("Egyeb",log);
						return 1;
					}
				case 7:
					{
						Msg(playerid,"Kinyitottad az ajándékodat! Az ajándékod egy M4-es 500 loszerrel!");
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
						Msg(playerid,"Kinyitottad az ajándékodat! Az ajándékod 1500g heroin!");
						PlayerInfo[playerid][pHeroin] +=1500;
						format(log,sizeof(log),"[ajandek] %s kapott 1500g heroint!",PlayerName(playerid));
						Log("Egyeb",log);
						return 1;
					}
				case 1:
					{
						Msg(playerid,"Kinyitottad az ajándékodat! Az ajándékod 2000g Kokain!");
						PlayerInfo[playerid][pKokain] +=2000;
						format(log,sizeof(log),"[ajandek] %s kapott 2000g kokaint!",PlayerName(playerid));
						Log("Egyeb",log);
						return 1;
					}
				case 2:
					{
						Msg(playerid,"Kinyitottad az ajándékodat! Az ajándékod 30.000db material!");
						PlayerInfo[playerid][pMats] +=30000;
						format(log,sizeof(log),"[ajandek] %s kapott 30.000db materialt",PlayerName(playerid));
						Log("Egyeb",log);
						return 1;
					}
				case 3:
					{
						Msg(playerid,"Kinyitottad az ajándékodat! Az ajándékod 1000g Marihuana!");
						PlayerInfo[playerid][pMarihuana] +=1000;
						format(log,sizeof(log),"[ajandek] %s kapott 1000g marihuanat",PlayerName(playerid));
						Log("Egyeb",log);
						return 1;
					}
				case 4:
					{
						Msg(playerid,"Kinyitottad az ajándékodat! Az ajándékod egy Sniper és 100 loszer hozzá!");
						WeaponGiveWeapon(playerid, WEAPON_SNIPER, .maxweapon = 0);
						WeaponGiveAmmo(playerid, WEAPON_SNIPER, 100);
						format(log,sizeof(log),"[ajandek] %s kapott egy Sniper-t 1000 loszerrel!",PlayerName(playerid));
						Log("Egyeb",log);
						return 1;
					}
				case 5:
					{
						Msg(playerid,"Kinyitottad az ajándékodat! Az ajándékod egy M4-es 500 loszerrel!");
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
	if(sscanf(params, "ds[128]", fkid, uzi)) return Msg(playerid, "/fvá [frakcióid] [üzenet]");
	if(fkid < 0 || fkid > 22) return Msg(playerid, "Hibás frakcióid");
	Format(_tmpString, "%s írt a(z) %s frakciónak | Üzenet: %s", PlayerName(playerid), Szervezetneve[fkid-1][1], uzi);
	foreach(Jatekosok, i)
	{
		if(PlayerInfo[i][pAdmin] >= 1 && TogVa[i] == 0)
			SendClientMessage(i, COLOR_YELLOW, _tmpString);
	}
	if(TogVa[playerid] == 1)
		SendClientMessage(playerid, COLOR_YELLOW, _tmpString);
	Format(_tmpString, "[Frakció] %s %s üzeni: %s", AdminRangNev(playerid), AdminName(playerid), uzi);
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
		Msg(playerid, "Most már nem látod, hogy kik lépnek be a közeledben.");
	}
	else
	{
		Belepesek[playerid] = true;
		Msg(playerid, "Most már látod, hogy kik lépnek be a közeledben.");
	}
	return 1;
}

CMD:detektor(playerid, params[])
{
	new v = GetPlayerVehicleID(playerid), vs = IsAVsKocsi(v), m[32];
	if(!IsPlayerInAnyVehicle(playerid)) return Msg(playerid, "Csak jármûben használható!");
	if(vs == NINCS) return Msg(playerid, "Ebben a jármûben nincs detektor! (vs)");
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return Msg(playerid, "Sofõrként kell vezetned!");
	if(CarInfo[vs][cDetektor] == 0) return Msg(playerid, "Ebben a jármûben nincs detektor!");
	if(sscanf(params, "s[32]", m))
	{
		if(Detektor[v])
		{
			Detektor[v] = false;
			Msg(playerid, "Detektor kikapcsolva, vigyázz, ismét elkaphat a traffipax!");
			Cselekves(playerid, "babrál valamit az ülése alatt...", 1);
		}
		else
		{
			Detektor[v] = true;
			Msg(playerid, "Detektor bekapcsolva, vigyázz, ha a rendor észreveszi, lecsukhat érte!");
			Cselekves(playerid, "babrál valamit az ülése alatt...", 1);
		}
	}
	else if(!sscanf(params, "s[32]", m)) SendFormatMessage(playerid, COLOR_ADD, "Ebben a jármûben %d-as szintû detektor van", CarInfo[vs][cDetektor]);
	return 1;
}

ALIAS(szem2t):szemet;
CMD:szemet(playerid, params[])
{
	new mitakarvele[32];
	if(sscanf(params, "s[32]", mitakarvele))
	{
		if(Admin(playerid, 1)) Msg(playerid, "Adminparancs: /szemét mennyi");
		return Msg(playerid, "/szemét [felvesz/lerak]");
	}
	if(egyezik(mitakarvele, "felvesz"))
	{
		if(VanSzemetNala[playerid]) return Msg(playerid, "Nálad már van szemét, elobb azt rakd le!");
		for(new k = 0; k < sizeof(TrashInfo); k++)
		{
			if(PlayerToPoint(2.0, playerid, ArrExt(TrashInfo[k][tSzemetPos])) && TrashInfo[k][tSzemet] && (TrashInfo[k][gId] == PlayerInfo[playerid][pPhousekey] || TrashInfo[k][gId] == PlayerInfo[playerid][pPhousekey2] || TrashInfo[k][gId] == PlayerInfo[playerid][pPhousekey3] || Admin(playerid, 4) || Munkaban[playerid] == MUNKA_KUKAS))
			{
				kuka[playerid] = k;
				break;
			}
		}
		if(kuka[playerid] == NINCS) return Msg(playerid, "Nem vagy szemét közelében vagy ez nem a te szemeted!");
		if(Admin(playerid, 4) && Munkaban[playerid] != MUNKA_KUKAS && !(TrashInfo[kuka[playerid]][gId] == PlayerInfo[playerid][pPhousekey] || TrashInfo[kuka[playerid]][gId] == PlayerInfo[playerid][pPhousekey2] || TrashInfo[kuka[playerid]][gId] == PlayerInfo[playerid][pPhousekey3]))
			Msg(playerid, "Ezt a szemetet azért tudtad felvenni mert admin vagy!");
		
		VanSzemetNala[playerid] = true;
		SetPlayerAttachedObject(playerid, ATTACH_SLOT_ZSAK_PAJZS_BILINCS, 1265, 6, 0.189000, -0.236000, 0.011999, -55.500057, 0.000000, 110.500022);
		if(IsValidDynamicObject(TrashInfo[kuka[playerid]][tSzemetObject])) DestroyDynamicObject(TrashInfo[kuka[playerid]][tSzemetObject]);
		if(IsValidDynamic3DTextLabel(TrashInfo[kuka[playerid]][tSzemetLabel])) DestroyDynamic3DTextLabel(TrashInfo[kuka[playerid]][tSzemetLabel]), TrashInfo[kuka[playerid]][tSzemetLabel] = INVALID_3D_TEXT_ID;
		Streamer_Update(playerid);
		Msg(playerid, "Szemét felvéve");
	}
	if(egyezik(mitakarvele, "lerak"))
	{
		if(!VanSzemetNala[playerid]) return Msg(playerid, "Nincs nálad szemét!");
		new Float:pozicio[3], vw = GetPlayerVirtualWorld(playerid), int = GetPlayerInterior(playerid);
		GetPlayerPos(playerid, ArrExt(pozicio));
		if(vw != 0 || int != 0) return Msg(playerid, "Csak a szabadban helyezheted el a szemetet! (0-s vw és 0-s interior)");
		if(kuka[playerid] == NINCS) 
			return Msg(playerid, "Nincs nálad szemét!");
		
		TrashInfo[kuka[playerid]][tSzemetPos][0] = pozicio[0];
		TrashInfo[kuka[playerid]][tSzemetPos][1] = pozicio[1];
		TrashInfo[kuka[playerid]][tSzemetPos][2] = pozicio[2] - 0.5;
		VanSzemetNala[playerid] = false;
		if(!IsValidDynamicObject(TrashInfo[kuka[playerid]][tSzemetObject]))
			TrashInfo[kuka[playerid]][tSzemetObject] = CreateDynamicObject(1265, TrashInfo[kuka[playerid]][tSzemetPos][0], TrashInfo[kuka[playerid]][tSzemetPos][1], TrashInfo[kuka[playerid]][tSzemetPos][2], 0.0, 0.0, 0.0);
		tformat(64, "ID:%d\nSzemét\nLerakta:%s", TrashInfo[kuka[playerid]][gId], ICPlayerName(playerid));
		if(!IsValidDynamic3DTextLabel(TrashInfo[kuka[playerid]][tSzemetLabel])) TrashInfo[kuka[playerid]][tSzemetLabel] = CreateDynamic3DTextLabel(_tmpString, 0xFFC801AA, ArrExt(TrashInfo[kuka[playerid]][tSzemetPos]), 25.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, 0, 0);
		RemovePlayerAttachedObject(playerid, ATTACH_SLOT_ZSAK_PAJZS_BILINCS);
		Streamer_Update(playerid);
		Msg(playerid, "Szemét lerakva");
		kuka[playerid] = NINCS;
	}
	if(egyezik(mitakarvele, "debug"))
	{
		if(!SzemetDebug[playerid]) return 1;
		VanSzemetNala[playerid] = false;
		SzemetDebug[playerid] = false;
		RemovePlayerAttachedObject(playerid, ATTACH_SLOT_ZSAK_PAJZS_BILINCS);
		Streamer_Update(playerid);
		Msg(playerid, "Szemét debugolva");
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
		
		Msg(playerid, "Ha a szemét több mint a ház írj HendRooxnak!");
		SendFormatMessage(playerid, COLOR_GRAD1, "Szemét: %d Ház: %d", mennyisz, mennyih);
	}
	return 1;
}

CMD:rk(playerid, params[])
{
	if(!Admin(playerid,1)) return Msg(playerid, "Csak admin!");
	
	Msg(playerid, "Piros: 30 percnél kevesebb | Sárga 30 percnél régebben");
	foreach(Jatekosok, x)
	{
		if(IsValidDynamic3DTextLabel(RKFigyelo[x][RKid]))
		{
			if(RKFigyelo[x][RKido] > UnixTime)
				SendFormatMessage(playerid,COLOR_RED,"[x]%s Haláltól eltelt idõ: %d sec Megölte: %s Ezzel: %s Halál helye: %f,%f,%f",x,PlayerName(x),UnixTime-(RKFigyelo[x][RKido]-RK_FIGYELO_IDO),RKFigyelo[x][RKnamekill],RKFigyelo[playerid][RKWeapon],RKFigyelo[x][RKx],RKFigyelo[x][RKy],RKFigyelo[x][RKz]);
			else
				SendFormatMessage(playerid,COLOR_YELLOW,"[x]%s Haláltól eltelt idõ: %d sec Megölte: %s Ezzel: %s Halál helye: %f,%f,%f",x,PlayerName(x),UnixTime-RKFigyelo[x][RKido],RKFigyelo[x][RKnamekill],RKFigyelo[playerid][RKWeapon],RKFigyelo[x][RKx],RKFigyelo[x][RKy],RKFigyelo[x][RKz]);
		}
	
	}
	Msg(playerid, "Piros: 30 percnél kevesebb | Sárga 30 percnél régebben");
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
				SendFormatMessage(playerid,COLOR_YELLOW,"[Hívásra megy][%d]%s Díjszabás:%d FT [Szállítások: %d, Km: %.3f]",id,ICPlayerName(id),FrakcioInfo[FRAKCIO_TAXI][fDij],Taxi[id][tHivasok], Taxi[id][tOKm]/1000.0);
			}
			elseif(Taxi[id][tUtas] == NINCS)
			{
				GetPlayerPos(id, xx,yy,zz);
				new Float:tavolsag = GetDistanceBetweenPoints(x, y, z, xx, yy, zz);
				SendFormatMessage(playerid,COLOR_GREEN,"[Szabad][%d]%s Díjszabás:%d FT távolság: %.3f [Szállítások: %d, Km: %.3f]",id,ICPlayerName(id),FrakcioInfo[FRAKCIO_TAXI][fDij],tavolsag,Taxi[id][tHivasok], Taxi[id][tOKm]/1000.0);
			}
			else
				SendFormatMessage(playerid,COLOR_LIGHTRED,"[Foglalt][%d]%s Díjszabás:%d FT [Szállítások: %d, Km: %.3f]",id,ICPlayerName(id),FrakcioInfo[FRAKCIO_TAXI][fDij],Taxi[id][tHivasok], Taxi[id][tOKm]/1000.0);
		
		
		}
	}
	Msg(playerid, "/service taxi [id]");
	return 1;
}

ALIAS(kukas):kuka;
ALIAS(kuk1s):kuka;
CMD:kuka(playerid, params[])
{
	if(OnDuty[playerid]) return Msg(playerid, "Döntsd elobb el mit dolgozol! ((frakció dutyba nem!))");
	new parameter[64];
	if(!AMT(playerid, MUNKA_KUKAS)) return Msg(playerid, "Nem vagy kukás!");
	if(sscanf(params, "s[64]", parameter)) return Msg(playerid, "/kuka [munka/hely/segítség]");
	if(egyezik(parameter, "munka") || egyezik(parameter, "szolgalat") || egyezik(parameter, "szolgálat"))
	{
		if(!PlayerToPoint(2.5, playerid, -586.7446,-1501.2863,10.3250))
		{
			SetPlayerCheckpoint(playerid, -586.7446,-1501.2863,10.3250, 2.5);
			Msg(playerid, "Nem vagy a szeméttelepen!");
			return 1;
		}
		if(Munkaban[playerid] != MUNKA_KUKAS)
		{
			Munkaban[playerid] = MUNKA_KUKAS;
			if(PlayerInfo[playerid][pSex] == 2) SetPlayerSkin(playerid, 157);
			else SetPlayerSkin(playerid, 8);
			Msg(playerid, "Felvetted a ruhádat, így munkába álltál. A munka végzéséhez segítség: /kuka segítség");
			
		}
		else if(Munkaban[playerid] == MUNKA_KUKAS)
		{
			Munkaban[playerid] = NINCS;
			if(!LegalisSzervezetTagja(playerid) && !Civil(playerid))
				SetPlayerSkin(playerid, PlayerInfo[playerid][pChar]);
			else
				SetPlayerSkin(playerid, PlayerInfo[playerid][pModel]);
				
			Msg(playerid, "Visszavetted a civil ruhádat, így már nem dolgozol.");
		}
	}
	else if(egyezik(parameter, "hely"))
	{
		if(Munkaban[playerid] != MUNKA_KUKAS) return Msg(playerid, "Nem kukásként dolgozol!");
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
		if(legkozelebb == 5000.0) return Msg(playerid, "Jelenleg nincs elszállításra váró kuka.");
		SetPlayerCheckpoint(playerid, ArrExt(TrashInfo[kukac][tSzemetPos]), 2.0);
		Msg(playerid, "Az irányító ügynökség megjelölte a számodra legközelebbi elszállítatlan szemetet.");
	}
	else if(egyezik(parameter, "segítség") || egyezik(parameter, "segitseg") || egyezik(parameter, "help"))
	{
		SendClientMessage(playerid, COLOR_GREEN, "=====[ Kukás munka használati útmutató ]=====");
		SendClientMessage(playerid, COLOR_WHITE, "A munkát elkezdeni a /kuka munka paranccsal tudod.");
		SendClientMessage(playerid, COLOR_GRAD6, "Miután beleültél egy kukáskocsiba, egy házhoz kell menned, ahol fel kell venned a szemetet.");
		SendClientMessage(playerid, COLOR_GRAD5, "Ezt a kukáskocsihoz állva bele kell tenned a szemétmegsemmisítõbe az Y megnyomásával.");
		SendClientMessage(playerid, COLOR_GRAD4, "Egy kukáskocsiba maximum 20 szemét fér, így ha ez megtelik, el kell vinni a szeméttelepre.");
		SendClientMessage(playerid, COLOR_GRAD3, "Ott a szemétlerakó széléhez kell állni, ahol az Y megnyomása után egy kis idõ elteltével kiürül a tartály.");
		SendClientMessage(playerid, COLOR_GRAD2, "Ekkor jóváíródik a fizetésedhez a szemetekért kapott pénz, majd folytathatod a munkát, vagy befejezheted.");
		SendClientMessage(playerid, COLOR_GRAD1, "A játékosok házai elõtt a szemetek a játékosok fizetéseikor újra lerakódnak.");
	}
	return 1;
}

CMD:news(playerid, params[])
{
	new szoveg[128], jarmu = GetPlayerVehicleID(playerid);
	if(FloodCheck(playerid)) return 1;
	if(!LMT(playerid, FRAKCIO_RIPORTER)) return Msg(playerid, "Ez a parancs nem elérhetõ számodra");
	if(IsFrakcioKocsi(jarmu) != 9 && !IsAt(playerid, IsAt_Studio)) return Msg(playerid, "Riporter jármûben kell lenned vagy a stúdióban!");
	if(!Munkarang(playerid, 1)) return Msg(playerid, "Ez a parancs nem elérhetõ számodra");
	if(sscanf(params, "s[128]", szoveg)) return Msg(playerid, "/news [szöveg]");
	if(strlen(szoveg) > 100) return Msg(playerid, "Maximum 100 karakter!");
	if(HirdetesSzidasEllenorzes(playerid, szoveg, "/news", ELLENORZES_HIRDETES)) return 1;
	
	if(strcmp(RadioMusorNev,"NINCS") == 0)
		format(_tmpString, sizeof(_tmpString), "Rádiós %s: %s", ICPlayerName(playerid), szoveg);
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
	if(!LMT(playerid, FRAKCIO_RIPORTER)) return Msg(playerid, "Ez a parancs nem elérhetõ számodra");
	//if(FBIadastiltas == 1) return Msg(playerid, "Az FBI betiltotta az adásokat!");
	if(IsFrakcioKocsi(jarmu) != 9 && !IsAt(playerid, IsAt_Studio)) return Msg(playerid, "Riporter jármûben kell lenned vagy a stúdióban!");
	if(!Munkarang(playerid, 1)) return Msg(playerid, "Ez a parancs nem elérhetõ számodra");
	if(PlayerInfo[playerid][pNewsSkill] < 101) return Msg(playerid, "A parancs használatához minimum 3-as ripoter skill szükséges");
	if(sscanf(params, "s[64]", musorcime)) return Msg(playerid, "/mûsornév [Mûsor neve]");
	if(strlen(musorcime) > 32) return Msg(playerid, "Maximum 32 karakteres lehet a mûsor címe!");
	if(HirdetesSzidasEllenorzes(playerid, musorcime, "/mûsornév", ELLENORZES_HIRDETES)) return 1;
	if(egyezik(musorcime, "ki") || egyezik(musorcime, "NINCS"))
	{
		RadioMusorNev = "NINCS";
		Msg(playerid, "Rádió mûsornév kikapcsolva!");
		RadioAktivsag = UnixTime+300;
		PlayerInfo[playerid][pNewsSkill] ++;
		if(PlayerInfo[playerid][pNewsSkill] == 200)
			SendClientMessage(playerid, COLOR_YELLOW, "* A riporter skilled elérte a 4es szintet! Mostmár tudsz repülni a riporter helikopterrel!");
		else if(PlayerInfo[playerid][pNewsSkill] == 400)
			SendClientMessage(playerid, COLOR_YELLOW, "* A riporter skilled elérte az 5ös szintet! Mostmár tudsz felkérni másokat, hogy élõ adásban szerepeljen, illetve tudsz zenét indítani!");
		format(_tmpString, 128, "<< %s kikapcsolta a mûsornevek használatát >>", PlayerName(playerid), musorcime);
		SendMessage(SEND_MESSAGE_FRACTION, _tmpString, COLOR_LIGHTRED, 9);
		EgyebLog(_tmpString);
		return 1;
	}
	RadioMusorNev = musorcime;
	SendFormatMessage(playerid, COLOR_GREEN, "Az új mûsornév: %s, kikapcsoláshoz: /mûsornév ki", musorcime);
	RadioAktivsag = UnixTime+300;
	PlayerInfo[playerid][pNewsSkill] ++;
	if(PlayerInfo[playerid][pNewsSkill] == 200)
		SendClientMessage(playerid, COLOR_YELLOW, "* A riporter skilled elérte a 4es szintet! Mostmár tudsz repülni a riporter helikopterrel!");
	else if(PlayerInfo[playerid][pNewsSkill] == 400)
		SendClientMessage(playerid, COLOR_YELLOW, "* A riporter skilled elérte a 5ös szintet! Mostmár tudsz felkérni másokat, hogy élõ adásban szerepeljen, illetve tudsz zenét indítani!");
	format(_tmpString, 128, "<< %s megváltoztatta a mûsornevet erre: %s >>", PlayerName(playerid), musorcime);
	SendMessage(SEND_MESSAGE_FRACTION, _tmpString, COLOR_LIGHTRED, 9);
	EgyebLog(_tmpString);
	return 1;
}

ALIAS(handsup):megad;
CMD:megad(playerid, params[])
{
	if(FloodCheck(playerid)) return 1;
	if(NemMozoghat(playerid)) return Msg(playerid, "Már késõ, nem gondolod?");
	if(!PlayerInfo[playerid][pMegad])
	{
		PlayerInfo[playerid][pMegad] = true;
		Cselekves(playerid, "megadta magát");
		Msg(playerid, "Megadtad magadat. Kikapcsoláshoz írd be ismét a parancsot: /megad");
		
		ApplyAnimation(playerid, "ROB_BANK","SHP_HandsUp_Scr", 4.0, 0, 0, 0, 0, 1);
	}
	else
	{
		PlayerInfo[playerid][pMegad] = false;
		Msg(playerid, "Már nem adod meg magadat. Bekapcsoláshoz írd be ismét a parancsot: /megad");
		ClearAnim(playerid);
	}
	return 1;
}

CMD:uninvite(playerid, params[])
{
	new target, reason[128], str[128];
	if(!PlayerInfo[playerid][pLeader]) return Msg(playerid, "Nem vagy leader");
	if(sscanf(params, "us[128]", target, reason)) return Msg(playerid, "/uninvite [Név/ID] [Oka]");
	if(target == INVALID_PLAYER_ID) return Msg(playerid, "Nem létezõ játékos");
	if(PlayerInfo[playerid][pMember] != PlayerInfo[target][pMember]) return Msg(playerid, "Õ nem a te tagod");
	if(PlayerInfo[target][pLeader] > 0) return Msg(playerid, "Nem rúghatod ki, mivel leader");
	if(FrakcioInfo[ PlayerInfo[playerid][pLeader] ][fUtolsoTagFelvetel] > (UnixTime - 300)) return SendFormatMessage(playerid, COLOR_LIGHTRED, "ClassRPG: Csak 5percenként lehet tagot felvenni / kirúgni, még %dmp van hátra", FrakcioInfo[ PlayerInfo[playerid][pLeader] ][fUtolsoTagFelvetel] - (UnixTime - 300));
	
	FrakcioInfo[PlayerInfo[playerid][pLeader]][fUtolsoTagFelvetel] = UnixTime;
	FrakcioInfo[PlayerInfo[playerid][pLeader]][fTagokSzama]--;
	SendFormatMessage(playerid, COLOR_GREEN, "ClassRPG: Kirúgtad %s-t a frakcióból, oka: %s", PlayerName(target), reason);
	SendFormatMessage(target, COLOR_GREEN, "ClassRPG: %s kirúgott a frakcióból, oka: %s", PlayerName(playerid), reason);
	format(str, 128, "<< ClassRPG: %s kirúgta %s-t a frakcióból - Oka: %s >>", PlayerName(playerid), PlayerName(target), reason);
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
	if(sscanf(params, "u", target)) return Msg(playerid, "/invite [Név/ID]");
	if(target == INVALID_PLAYER_ID) return Msg(playerid, "Nem létezõ játékos");
	if(PlayerInfo[target][pMember] > 0) return Msg(playerid, "Õ már tag valahol");
	if(PlayerInfo[target][pLeader] > 0) return Msg(playerid, "Õ már leader valahol");
	if(PlayerInfo[target][pFrakcioTiltIdo]) return SendFormatMessage(playerid, COLOR_LIGHTRED, "ClassRPG: Õ el van tiltva a frakcióktól, oka: %s, még %d óráig", PlayerInfo[target][pFrakcioTiltOk], PlayerInfo[target][pFrakcioTiltIdo]);
	if(PlayerInfo[playerid][pLeader] < 1 || PlayerInfo[playerid][pLeader] > sizeof(Szervezetneve)) return 1;
	if(FrakcioInfo[ PlayerInfo[playerid][pLeader] ][fUtolsoTagFelvetel] > (UnixTime - 300)) return SendFormatMessage(playerid, COLOR_LIGHTRED, "ClassRPG: Csak 5percenként lehet tagot felvenni / kirúgni, még %dmp van hátra", FrakcioInfo[ PlayerInfo[playerid][pLeader] ][fUtolsoTagFelvetel] - (UnixTime - 300));
	if(FrakcioInfo[ PlayerInfo[playerid][pLeader] ][fTagokSzama] >= SzervezetLimit[ PlayerInfo[playerid][pLeader] - 1 ]) return Msg(playerid, "A frakció tele van");
	if(Invitejog[target]) return Msg(playerid, "Õ már meg van hívva valahova, így nem tudsz meghívást küldeni neki");
	
	Invitejog[target] = PlayerInfo[playerid][pMember];
	SendFormatMessage(playerid, COLOR_GREEN, "ClassRPG: Meghívtad %s-t, hogy csatlakozzon hozzátok, ha elfogadja, taggá válik", PlayerName(target));
	SendFormatMessage(target, COLOR_LIGHTBLUE, "ClassRPG: %s meghívott téged, hogy csatlakozz a(z) %s frakcióhoz.", PlayerName(playerid), Szervezetneve[PlayerInfo[playerid][pLeader] - 1][1]);
	SendClientMessage(target, COLOR_LIGHTBLUE, "ClassRPG: Elfogadáshoz használd a /accept invite parancsot, elutasításhoz pedig a /cancel invite parancsot.");
	format(str, 128, "<< ClassRPG: %s meghívta %s-t a frakcióba, ha elfogadja, taggá válik >>", PlayerName(playerid), PlayerName(target));
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
		return Msg(playerid, "Nem vagy tuzoltó!");
	if(Visz[playerid] != NINCS)
	{
		SendClientMessage(playerid, COLOR_LIGHTBLUE, "Elengedted");
		Visz[playerid] = NINCS;
		return 1;
	}
		
	if(!IsPlayerConnected(jatekos)) 
		return 1;
	
	if(GetDistanceBetweenPlayers(playerid, jatekos) > 3)
		return Msg(playerid, "Nincs a közeledben!");
	
	for(new t = 0; t < TUZ_MAX; t++)
	{
		if(!Tuz[t][tuzAktiv])
			continue;
		
		if(!PlayerToPoint(TUZ_SERULES_TAV, jatekos, ArrExt( Tuz[t][tPoz] )))
			return Msg(playerid, "Õ nincs a tuzben!");
			
		Visz[playerid] = jatekos;
		Msg(playerid, "Megfogtad és elkezdted húzni õt, siess, nehogy komolyabb baja essen!", false, COLOR_LIGHTBLUE);
		Cselekves(playerid, "elkezdett valakit kihúzni a lángok közül");
	}
	
	return 1;
}

CMD:aszint(playerid, params[])
{
	if(!Admin(playerid, 1337)) return 1;
	new szint;
	if(sscanf(params, "d", szint)) return Msg(playerid, "/aszint [szint] - Saját szint megváltoztatása IDEIGLENESEN!!");
	
	SetPlayerScore(playerid, szint);
	ASzint[playerid] = szint;
	SendFormatMessage(playerid, COLOR_LIGHTRED, "Szinted átírva ideiglenesen ennyire: %d, ne feledd, ez csak relogig jó!", szint);
	return 1;
}

ALIAS(anev):an2v;
CMD:an2v(playerid, params[])
{
	if(!Admin(playerid,1337)) return 1;

	new namee[MAX_PLAYER_NAME];
	if(sscanf(params, "s[25]", namee)) return Msg(playerid, "/anev [név]");
	
	switch(SetPlayerName(playerid, namee))
    {
        case -1: SendClientMessage(playerid, 0xFF0000FF, "Hiba érvénytelen!");
        case 0: SendClientMessage(playerid, 0xFF0000FF, "Már ez a neved most is!");
        case 1: SendClientMessage(playerid, 0x00FF00FF, "Neved átírva"), PlayerInfo[playerid][pHamisNev]=namee;
    }

	return 1;
}

ALIAS(mobiledatacomputer):mdc;
CMD:mdc(playerid, params[])
{
	new type[16], subtype[32];
	if(!IsACop(playerid)) return Msg(playerid, "Nem vagy rendõr!");
	if(OnDuty[playerid] != 1 && AdminDuty[playerid] != 1) return Msg(playerid, "Nem vagy szolgálatban!");
	if(sscanf(params, "s[16]S()[32]", type, subtype)) return Msg(playerid, "/mdc [játékos/jármû]");
	if(egyezik(type, "játékos") || egyezik(type, "jatekos") || egyezik(type, "player"))
	{
		new target;
		if(sscanf(subtype, "u", target)) return Msg(playerid, "/mdc játékos [Név/ID]");
		if(target == INVALID_PLAYER_ID) return Msg(playerid, "Nincs ilyen játékos!");
		SendClientMessage(playerid, TEAM_BLUE_COLOR, "==========[ MOBILE DATA COMPUTER ]==========");
		SendFormatMessage(playerid, COLOR_WHITE, "Név: %s", ICPlayerName(target));
		SendFormatMessage(playerid, COLOR_WHITE, "Bûn: %s", PlayerCrime[target][pVad]);
		SendFormatMessage(playerid, COLOR_WHITE, "Jelentõ: %s", PlayerCrime[target][pJelento]);
		SendClientMessage(playerid, TEAM_BLUE_COLOR,"==========[ MOBILE DATA COMPUTER ]==========");
	}
	else if(egyezik(type, "jármû") || egyezik(type, "jarmu") || egyezik(type, "vehicle"))
	{
		new target;
		if(sscanf(subtype, "i", target)) return Msg(playerid, "/mdc jármû [Rendszám]");
		if(target == INVALID_VEHICLE_ID) return Msg(playerid, "Nincs ilyen jármû");
		SendClientMessage(playerid, TEAM_BLUE_COLOR, "==========[ MOBILE DATA COMPUTER ]==========");
		SendFormatMessage(playerid, COLOR_WHITE, "Rendszám: CLS-%d", target);
		SendFormatMessage(playerid, COLOR_WHITE, "Jármû típus: %s", GetVehicleModelName(GetVehicleModel(target)-400));
		SendFormatMessage(playerid, COLOR_WHITE, "Bûn: %s", VehicleCrime[target][vVad]);
		SendFormatMessage(playerid, COLOR_WHITE, "Jelentõ: %s", VehicleCrime[target][vJelento]);
		SendClientMessage(playerid, TEAM_BLUE_COLOR,"==========[ MOBILE DATA COMPUTER ]==========");
	}
	return 1;
}

ALIAS(su):suspect;
CMD:suspect(playerid, params[])
{
	new type[16], subtype[32];
	if(!IsACop(playerid)) return Msg(playerid, "Nem vagy rendõr!");
	if(OnDuty[playerid] != 1) return Msg(playerid, "Nem vagy szolgálatban!");
	if(sscanf(params, "s[16]S()[32]", type, subtype)) return Msg(playerid, "/suspect [játékos/jármû]");
	if(egyezik(type, "játékos") || egyezik(type, "jatekos") || egyezik(type, "player"))
	{
		new target, crime[128];
		if(sscanf(subtype, "us[128]", target, crime)) return Msg(playerid, "/suspect játékos [Név/ID] [Bûntett]");
		if(target == INVALID_PLAYER_ID) return Msg(playerid, "Nincs ilyen játékos!");
		if(IsACop(target)) return Msg(playerid, "Rendõrt nem lehet feljelenteni!");
		SendFormatMessage(playerid, COLOR_LIGHTRED, "ClassRPG: Sikeresen feljelentetted %s-t!", ICPlayerName(target));
		SetPlayerCriminal(target, playerid, crime);
	}
	if(egyezik(type, "jármû") || egyezik(type, "jarmu") || egyezik(type, "vehicle"))
	{
		new target, crime[128];
		if(sscanf(subtype, "is[128]", target, crime)) return Msg(playerid, "/suspect jármû [Rendszám] [Bûntett]");
		if(target == INVALID_VEHICLE_ID) return Msg(playerid, "Nincs ilyen jármû");
		if(IsACopCar(target)) return Msg(playerid, "Rendõrkocsit nem lehet feljelenteni!");
		SendFormatMessage(playerid, COLOR_LIGHTRED, "ClassRPG: Sikeresen feljelentetted a CLS-%d rendszámú jármûvet!", target);
		SetVehicleCriminal(target, playerid, crime);
	}
	return 1;
}

CMD:karszalag(playerid, params[])
{
	if(FloodCheck(playerid, 1, 3)) return 1;

	new type[16], subtype[32];
	new time = UnixTime;
	if(sscanf(params, "s[16]S()[32]", type, subtype)) Msg(playerid, "Használata: /karszalag [megnéz / vesz / mutat]");

	if(egyezik(type, "megnéz") || egyezik(type, "megnez"))
	{
		if(PlayerInfo[playerid][pMoriartySzalag] == 1 && PlayerInfo[playerid][pMoriartySzalagIdo] > time)
		{
			new kulonbseg, ora, perc;
			kulonbseg = PlayerInfo[playerid][pMoriartySzalagIdo] - UnixTime;
			ora = floatround((float(kulonbseg) / 3600.0), floatround_floor);
			perc = floatround((float(kulonbseg) / 60.0), floatround_floor) % 60;
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Szalag: Van - Még %dóra és %dpercig érvényes", ora, perc);
			Cselekves(playerid, "megnézte a szalagját.");
		}
		if(PlayerInfo[playerid][pMoriartySzalag] == 1 && PlayerInfo[playerid][pMoriartySzalagIdo] < time) 
		{
			Msg(playerid, "Szalag: Érvénytelen");
			Cselekves(playerid, "megnézte a szalagját.");
		}
		if(PlayerInfo[playerid][pMoriartySzalag] == 0)
		{
			Msg(playerid, "Szalag: Nincs");
			Cselekves(playerid, "megnézte a szalagját.");
		}
	}
	else if(egyezik(type, "megmutat"))
	{
		if(PlayerInfo[playerid][pMoriartySzalag] == 0)
			return Msg(playerid, "Nincs szalagod!");

		new player;
		
		if(sscanf(subtype, "u", player)) return Msg(playerid, "/karszalag megmutat [Név / ID]");

		if(player == INVALID_PLAYER_ID)
			return Msg(playerid, "Nincs ilyen játékos");
		if(GetDistanceBetweenPlayers(player, playerid) > 3.0)
			return Msg(playerid, "Nincs a közeledben");
			
		if(PlayerInfo[playerid][pMoriartySzalag] == 1 && PlayerInfo[playerid][pMoriartySzalagIdo] > time)
		{
			new kulonbseg, ora, perc;
			kulonbseg = PlayerInfo[playerid][pJegy] - time;
			ora = floatround((float(kulonbseg) / 3600.0), floatround_floor);
			perc = floatround((float(kulonbseg) / 60.0), floatround_floor) % 60;
			SendFormatMessage(player, COLOR_LIGHTGREEN, "%s Szalagja: Van - Még %dóra és %dpercig érvényes", ICPlayerName(playerid), ora, perc);
			Msg(playerid, "Megmutattad a szalagod valakinek");
			Cselekves(playerid, "Megmutatta a szalagját valakinek");
		}
		if(PlayerInfo[playerid][pMoriartySzalag] == 1 && PlayerInfo[playerid][pMoriartySzalagIdo] < time) 
		{
			Msg(player, "Szalag: Érvénytelen");
			Msg(playerid, "Megmutattad a szalagod valakinek");
			Cselekves(playerid, "Megmutatta a szalagját valakinek");
		}
	}
	else if(egyezik(type, "vesz"))
	{
		if(PlayerInfo[playerid][pMoriartySzalag] > 0)
			return Msg(playerid, "Már van szalagod");

		if(!PlayerToPoint(2, playerid, BizzInfo[BIZ_MORIARTY][bEntranceX] , BizzInfo[BIZ_MORIARTY][bEntranceY] , BizzInfo[BIZ_MORIARTY][bEntranceZ]))
			return SendFormatMessage(playerid, COLOR_LIGHTRED, "Nem vagy a(z) %s elött!", BizzInfo[BIZ_MORIARTY][bMessage]);
				
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
	if(!IsPlayerInAnyVehicle(playerid)) return Msg(playerid, "A szervizkönyv a kocsiban van");
	if(sscanf(params, "u", target)) return Msg(playerid, "/szervizkönyv [Név/ID]");
	if(target == INVALID_PLAYER_ID) return Msg(playerid, "Nincs ilyen játékos");
	if(GetDistanceBetweenPlayers(playerid, target) > 4.0) return Msg(playerid, "Nincs a közeledben");
	if(IsABicikli(car)) return Msg(playerid, "Ennek nincs szervizkönyve");
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
			
	SendFormatMessage(target, COLOR_GREEN, "=====[ CLS-%d jármu szervizkönyve ]=====", car);
	if(tulaj != NINCS)
		SendFormatMessage(target, COLOR_LIGHTGREEN, "Jármû tulajdonosa: %s", CarInfo[tulaj][cOwner]);
	else
		SendClientMessage(target, COLOR_LIGHTGREEN, "Jármû tulajdonosa: Céges tulajdon");
	SendFormatMessage(target, COLOR_LIGHTGREEN, "Jármû típusa: %s", GetVehicleModelName(GetVehicleModel(car)-400));
	if(tulaj != NINCS)
		SendFormatMessage(target,COLOR_WHITE,"Jármû színkódja: %d & %d",CarInfo[tulaj][cColorOne], CarInfo[tulaj][cColorTwo]);
	else if(id != NINCS)
		SendFormatMessage(target,COLOR_WHITE,"Jármû színkódja: %d & %d",FrakcioKocsi[frakcio][id][fSzin][0], FrakcioKocsi[frakcio][id][fSzin][1]);
	else	
		SendClientMessage(target,COLOR_WHITE,"Jármû színkódja: Nincs bejegyezve");
	SendFormatMessage(target, COLOR_WHITE, "Futott kilométer: %.2f km", KmSzamol[car]/1000);
	SendFormatMessage(target, COLOR_WHITE, "Kerekek: %.2f százalékban elhasználódott", CarPart[car][cKerekek]);
	SendFormatMessage(target, COLOR_WHITE, "Motorolaj: %.2f százalékban elhasználódott", CarPart[car][cMotorolaj]);
	SendFormatMessage(target, COLOR_WHITE, "Akkumulátor töltöttsége: %.2f százalék", CarPart[car][cAkkumulator]);
	SendFormatMessage(target, COLOR_WHITE, "Motor: %.2f százalékban elhasználódott", CarPart[car][cMotor]/5); // Valós értéket mutasson, ne azt h pl. 300%-ban elhasználódott
	SendFormatMessage(target, COLOR_WHITE, "Fék: %.2f százalékban elhasználódott", CarPart[car][cFek]);
	SendFormatMessage(target, COLOR_WHITE, "Elektronika: %.2f százalékban elhasználódott", CarPart[car][cElektronika]);
	SendFormatMessage(target, COLOR_WHITE, "Karosszéria: %d alkalommal volt cserélve", CarPart[car][cKarosszeria]);
	SendFormatMessage(target, COLOR_WHITE, "Karosszéria: %.0f százalékban károsodott", serules);
	if(legutoljara > 250)
		SendClientMessage(target, COLOR_LIGHTGREEN, "A jármû még nem volt szervizben");
	else
		SendFormatMessage(target, COLOR_LIGHTGREEN, "A jármû legutoljára szervizben volt: %d napja", legutoljara);
		
	if(target == playerid)
		Cselekves(playerid, "elõvette az autó szervizkönyvét, és megnézte.");
	else
		Cselekves(playerid, "elõvette az autó szervizkönyvét, és megmutatta valakinek.");
	
	return 1;
}

ALIAS(repair):szereles;
ALIAS(szerel2s):szereles;
CMD:szereles(playerid, params[])
{
	new target, mit[32], sub[64], mennyiert, car = GetClosestVehicle(playerid);
	if(PlayerInfo[playerid][pSzerelo] < 1) return Msg(playerid, "Nem vagy szerelõ");
	if(OnDuty[playerid]) return Msg(playerid, "Döntsd elõbb el mit dolgozol! ((frakció dutyba nem!))");
	
	if(IsPlayerInAnyVehicle(playerid)) return Msg(playerid,"Kocsiban nem tudsz szerelni");
	if(GetPlayerDistanceFromVehicle(playerid, car) > 10) return Msg(playerid, "Nincs a közeledben jármû");
	
	if((IsAPRepulo(car) || IsAMotor(car) || IsARepulo(car) || IsAPlane(car)) && !IsAt(playerid, IsAt_SzereloHely))
	{
		new szkocsi=GetClosestVehicle(playerid, false, 525);
		if(GetPlayerDistanceFromVehicle(playerid, szkocsi) > 10) return Msg(playerid, "Nincs a közeledben szerelõ kocsi!");
	}
	
	if(!IsAt(playerid, IsAt_SzereloHely) && !(IsAPRepulo(car) || IsAMotor(car) || IsARepulo(car) || IsAPlane(car))) return Msg(playerid, "Itt nem tudsz javítani");
		
	if(sscanf(params, "s[32]S()[64]", mit, sub))
	{
		Msg(playerid, "/szerelés [Kerekek/Motorolaj/Akkumulátor/Motor/Elektronika/Fék/Karosszéria] [Név/ID] [Ár]");
		Msg(playerid, "Jármu állapotfelmérése: /szerelés állapot");
		return 1;
	}
	if(IsABicikli(car)) return Msg(playerid, "Ezt nem lehet megjavítani");
	if(egyezik(mit, "Kerekek"))
	{
		if(sscanf(sub, "ui", target, mennyiert)) return Msg(playerid, "/szerelés kerekek [Név/ID] [Ára]");
		if(target == playerid)
		{
			new panels, doors, lights, tires;
			if(!BankkartyaFizet(playerid, 150000)) return Msg(playerid, "ClassRPG: Nincs elég pénzed, a garnitúra gumi ára: 150,000Ft!");
			Cselekves(playerid,"kicserélte a jármûvén az abroncsokat.",0);
			GetVehicleDamageStatus(car, panels, doors, lights, tires);
			UpdateVehicleDamageStatus(car, panels, doors, lights, 0);
			SendClientMessage(playerid, COLOR_LIGHTBLUE, "Kicserélted a gumikat, a gumi ára: 150,000Ft");
			BizPenz(BIZ_AUTOSBOLT, 150000);
			CarPart[car][cKerekek] = 0.0;
			CarPart[car][cSzervizdatum] = UnixTime;
		}
		else
		{
			if(target == INVALID_PLAYER_ID) return Msg(playerid, "Nem létezõ játékos");
			if(GumitCserel[target]) return Msg(playerid, "Már fel lett ajánlva neki!");
			if(mennyiert < 150000 || mennyiert > 300000) return Msg(playerid, "Az ára minimum 150 000 Ft, max 300 000 Ft lehet!");
			if(GetDistanceBetweenPlayers(playerid, target) > 8.0) return Msg(playerid, "Nincs a közeledben!");
			if(!IsPlayerInAnyVehicle(target)) return Msg(playerid, "Nem ül jármûben!");
			SendFormatMessage(playerid, COLOR_LIGHTBLUE, "* Felajánlottad %s-nak, hogy kicseréled a gumikat %dFT-ért", ICPlayerName(target), mennyiert);
			SendFormatMessage(target, COLOR_LIGHTBLUE, "* Autószerelõ %s felajánlotta, hogy kicseréli a gumikat %dFT-ért.", ICPlayerName(playerid), mennyiert);
			SendClientMessage(target, COLOR_LIGHTBLUE, "Ha el akarod fogadni /accept repair");
			JavitasAra[target] += mennyiert;
			GumitCserel[target] = true;
			AlkatreszAr[target] += 150000;
			NekiSzerel[target] = playerid;
		}
	}
	if(egyezik(mit, "Motorolaj"))
	{
		if(sscanf(sub, "ui", target, mennyiert)) return Msg(playerid, "/szerelés motorolaj [Név/ID] [Ára]");
		if(target == playerid)
		{
			if(!BankkartyaFizet(playerid, 25000)) return Msg(playerid, "Nincs elég pénzed, az olaj ára: 25,000Ft!");
			Cselekves(playerid,"kicserélte a jármuvében az olajat.",0);
			SendClientMessage(playerid, COLOR_LIGHTBLUE, "Kicserélted az olajat, az ára: 25,000Ft");
			BizPenz(BIZ_AUTOSBOLT, 25000);
			CarPart[car][cMotorolaj] = 0.0;
			CarPart[car][cSzervizdatum] = UnixTime;
		}
		else
		{
			if(target == INVALID_PLAYER_ID) return Msg(playerid, "Nem létezõ játékos");
			if(OlajatCserel[target]) return Msg(playerid, "Már fel lett ajánlva neki!");
			if(mennyiert < 25000 || mennyiert > 50000) return Msg(playerid, "Az ára minimum 25 000 Ft, max 50 000 Ft lehet!");
			if(GetDistanceBetweenPlayers(playerid, target) > 8.0) return Msg(playerid, "Nincs a közeledben!");
			if(!IsPlayerInAnyVehicle(target)) return Msg(playerid, "Nem ül jármuben!");
			SendFormatMessage(playerid, COLOR_LIGHTBLUE, "* Felajánlottad %s-nak, hogy kicseréled az olajat %dFT-ért", ICPlayerName(target), mennyiert);
			SendFormatMessage(target, COLOR_LIGHTBLUE, "* Autószerelõ %s felajánlotta, hogy kicseréli az olajat %dFT-ért.", ICPlayerName(playerid), mennyiert);
			SendClientMessage(target, COLOR_LIGHTBLUE, "Ha el akarod fogadni /accept repair");
			JavitasAra[target] += mennyiert;
			OlajatCserel[target] = true;
			AlkatreszAr[target] += 25000;
			NekiSzerel[target] = playerid;
		}
	}
	if(egyezik(mit, "Akkumulátor") || egyezik(mit, "Akkumulator") || egyezik(mit, "Akku"))
	{
		if(sscanf(sub, "ui", target, mennyiert)) return Msg(playerid, "/szerelés akkumulátor [Név/ID] [Ára]");
		if(target == playerid)
		{
			if(!BankkartyaFizet(playerid, 25000)) return Msg(playerid, "ClassRPG: Nincs elég pénzed, az akku ára: 25,000Ft!");
			Cselekves(playerid,"kicserélte a jármûvében az akkumulátort.",0);
			SendClientMessage(playerid, COLOR_LIGHTBLUE, "Kicserélted az akkut, az ára: 25,000Ft");
			BizPenz(BIZ_AUTOSBOLT, 25000);
			CarPart[car][cAkkumulator] = 100.0;
			CarPart[car][cSzervizdatum] = UnixTime;
		}
		else
		{
			if(target == INVALID_PLAYER_ID) return Msg(playerid, "Nem létezõ játékos");
			if(AkkutCserel[target]) return Msg(playerid, "Már fel lett ajánlva neki!");
			if(mennyiert < 25000 || mennyiert > 55000) return Msg(playerid, "Az ára minimum 25 000 Ft, max 55 000 Ft lehet!");
			if(target == INVALID_PLAYER_ID) return Msg(playerid, "Nem létezõ játékos");
			if(GetDistanceBetweenPlayers(playerid, target) > 8.0) return Msg(playerid, "Nincs a közeledben!");
			if(!IsPlayerInAnyVehicle(target)) return Msg(playerid, "Nem ül jármuben!");
			SendFormatMessage(playerid, COLOR_LIGHTBLUE, "* Felajánlottad %s-nak, hogy kicseréled az akkut %dFT-ért", ICPlayerName(target), mennyiert);
			SendFormatMessage(target, COLOR_LIGHTBLUE, "* Autószerelõ %s felajánlotta, hogy kicseréli az akkumulátort %dFT-ért.", ICPlayerName(playerid), mennyiert);
			SendClientMessage(target, COLOR_LIGHTBLUE, "Ha el akarod fogadni /accept repair");
			JavitasAra[target] += mennyiert;
			AkkutCserel[target] = true;
			AlkatreszAr[target] += 25000;
			NekiSzerel[target] = playerid;
		}
	}
	if(egyezik(mit, "Motor"))
	{
		if(sscanf(sub, "ui", target, mennyiert)) return Msg(playerid, "/szerelés motor [Név/ID] [Ára]");
		if(target == playerid)
		{
			if(!BankkartyaFizet(playerid, 300000)) return Msg(playerid, "ClassRPG: Nincs elég pénzed, a motor ára: 300,000Ft!");
			Cselekves(playerid,"kicserélte a jármûvében a motort.",0);
			SendClientMessage(playerid, COLOR_LIGHTBLUE, "Kicserélted a motort, az ára: 300,000Ft");
			BizPenz(BIZ_AUTOSBOLT, 300000);
			CarPart[car][cMotor] = 0.0;
			SetVehicleHealth(car, 1000);
			CarPart[car][cSzervizdatum] = UnixTime;
		}
		else
		{
			if(target == INVALID_PLAYER_ID) return Msg(playerid, "Nem létezõ játékos");
			if(MotortCserel[target]) return Msg(playerid, "Már fel lett ajánlva neki!");
			if(mennyiert < 300000 || mennyiert > 600000) return Msg(playerid, "Az ára minimum 300 000 Ft, max 600 000 Ft lehet!");
			if(GetDistanceBetweenPlayers(playerid, target) > 8.0) return Msg(playerid, "Nincs a közeledben!");
			if(!IsPlayerInAnyVehicle(target)) return Msg(playerid, "Nem ül jármuben!");
			SendFormatMessage(playerid, COLOR_LIGHTBLUE, "* Felajánlottad %s-nak, hogy kicseréled a motort %dFT-ért", ICPlayerName(target), mennyiert);
			SendFormatMessage(target, COLOR_LIGHTBLUE, "* Autószerelõ %s felajánlotta, hogy kicseréli a motort %dFT-ért.", ICPlayerName(playerid), mennyiert);
			SendClientMessage(target, COLOR_LIGHTBLUE, "Ha el akarod fogadni /accept repair");
			JavitasAra[target] += mennyiert;
			MotortCserel[target] = true;
			AlkatreszAr[target] += 300000;
			NekiSzerel[target] = playerid;
		}
	}
	if(egyezik(mit, "Elektronika"))
	{
		if(sscanf(sub, "ui", target, mennyiert)) return Msg(playerid, "/szerelés elektronika [Név/ID] [Ára]");
		if(target == playerid)
		{
			if(!BankkartyaFizet(playerid, 70000)) return Msg(playerid, "ClassRPG: Nincs elég pénzed, az elektronika ára: 70,000Ft!");
			Cselekves(playerid,"kicserélte a jármûvében az elektronikát.",0);
			SendClientMessage(playerid, COLOR_LIGHTBLUE, "Kicserélted az elektronikát, az ára: 70,000Ft");
			BizPenz(BIZ_AUTOSBOLT, 70000);
			CarPart[car][cElektronika] = 0.0;
			CarPart[car][cSzervizdatum] = UnixTime;
		}
		else
		{
			if(target == INVALID_PLAYER_ID) return Msg(playerid, "Nem létezõ játékos");
			if(ElektronikatCserel[target]) return Msg(playerid, "Már fel lett ajánlva neki!");
			if(mennyiert < 70000 || mennyiert > 140000) return Msg(playerid, "Az ára minimum 70 000 Ft, max 140 000 Ft lehet!");
			if(GetDistanceBetweenPlayers(playerid, target) > 8.0) return Msg(playerid, "Nincs a közeledben!");
			if(!IsPlayerInAnyVehicle(target)) return Msg(playerid, "Nem ül jármuben!");
			SendFormatMessage(playerid, COLOR_LIGHTBLUE, "* Felajánlottad %s-nak, hogy kicseréled az elektronikát %dFT-ért", ICPlayerName(target), mennyiert);
			SendFormatMessage(target, COLOR_LIGHTBLUE, "* Autószerelõ %s felajánlotta, hogy kicseréli az elektronikát %dFT-ért.", ICPlayerName(playerid), mennyiert);
			SendClientMessage(target, COLOR_LIGHTBLUE, "Ha el akarod fogadni /accept repair");
			JavitasAra[target] += mennyiert;
			ElektronikatCserel[target] = true;
			AlkatreszAr[target] += 70000;
			NekiSzerel[target] = playerid;
		}
	}
	if(egyezik(mit, "Fék") || egyezik(mit, "Fek"))
	{
		if(sscanf(sub, "ui", target, mennyiert)) return Msg(playerid, "/szerelés fék [Név/ID] [Ára]");
		if(target == playerid)
		{
			if(!BankkartyaFizet(playerid, 40000)) return Msg(playerid, "ClassRPG: Nincs elég pénzed, a fékbetét ára: 40,000Ft!");
			Cselekves(playerid,"kicserélte a jármûvében a fékbetétet.",0);
			SendClientMessage(playerid, COLOR_LIGHTBLUE, "Kicserélted a féket, az ára: 40,000Ft");
			BizPenz(BIZ_AUTOSBOLT, 40000);
			CarPart[car][cFek] = 0.0;
			CarPart[car][cSzervizdatum] = UnixTime;
		}
		else
		{
			if(target == INVALID_PLAYER_ID) return Msg(playerid, "Nem létezõ játékos");
			if(FeketCserel[target]) return Msg(playerid, "Már fel lett ajánlva neki!");
			if(mennyiert < 40000 || mennyiert > 100000) return Msg(playerid, "Az ára minimum 40 000 Ft, max 100 000 Ft lehet!");
			if(GetDistanceBetweenPlayers(playerid, target) > 8.0) return Msg(playerid, "Nincs a közeledben!");
			if(!IsPlayerInAnyVehicle(target)) return Msg(playerid, "Nem ül jármuben!");
			SendFormatMessage(playerid, COLOR_LIGHTBLUE, "* Felajánlottad %s-nak, hogy kicseréled a féket %dFT-ért", ICPlayerName(target), mennyiert);
			SendFormatMessage(target, COLOR_LIGHTBLUE, "* Autószerelõ %s felajánlotta, hogy kicseréli a fékbetétet %dFT-ért.", ICPlayerName(playerid), mennyiert);
			SendClientMessage(target, COLOR_LIGHTBLUE, "Ha el akarod fogadni /accept repair");
			JavitasAra[target] += mennyiert;
			FeketCserel[target] = true;
			AlkatreszAr[target] += 40000;
			NekiSzerel[target] = playerid;
		}
	}
	if(egyezik(mit, "Karosszéria") || egyezik(mit, "Karosszeria"))
	{
		if(sscanf(sub, "ui", target, mennyiert)) return Msg(playerid, "/szerelés karosszeria [Név/ID] [Ára]");
		if(target == playerid)
		{
			if(!BankkartyaFizet(playerid, 10000)) return Msg(playerid, "ClassRPG: Nincs elég pénzed, a karosszériacsere ára: 10,000Ft!");
			Cselekves(playerid,"kicserélte a jármûvén a karosszériát.",0);
			SendClientMessage(playerid, COLOR_LIGHTBLUE, "Kicserélted a karosszériát, az ára: 10,000Ft");
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
			if(target == INVALID_PLAYER_ID) return Msg(playerid, "Nem létezõ játékos");
			if(KarosszeriatCserel[target]) return Msg(playerid, "Már fel lett ajánlva neki!");
			if(mennyiert < 10000 || mennyiert > 100000) return Msg(playerid, "Az ára minimum 10 000 Ft, max 100 000 Ft lehet!");
			if(GetDistanceBetweenPlayers(playerid, target) > 8.0) return Msg(playerid, "Nincs a közeledben!");
			if(!IsPlayerInAnyVehicle(target)) return Msg(playerid, "Nem ül jármuben!");
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
			SendFormatMessage(playerid, COLOR_LIGHTBLUE, "* Felajánlottad %s-nak, hogy kicseréled a karosszériát %dFT-ért. Alkatrészek ára: %s Ft", ICPlayerName(target), mennyiert, FormatInt(AlkatreszAr[target]));
			SendFormatMessage(target, COLOR_LIGHTBLUE, "* Autószerelõ %s felajánlotta, hogy kicseréli a karosszériát %dFT-ért. Az alkatrészek ára: %s Ft", ICPlayerName(playerid), mennyiert, FormatInt(AlkatreszAr[target]));
			SendClientMessage(target, COLOR_LIGHTBLUE, "Ha el akarod fogadni /accept repair");
		}
	}
	if(egyezik(mit, "állapot") || egyezik(mit, "allapot"))
	{
		if(sscanf(sub, "u", target)) return Msg(playerid, "/szerelés állapot [Név/ID]");
		if(target == INVALID_PLAYER_ID) return Msg(playerid, "Nem létezõ játékos");
		if(GetDistanceBetweenPlayers(playerid, target) > 8.0) return Msg(playerid, "Nincs a közeledben!");
		new Float:serules = (1000.0 - KocsiElete[car]) / 6.5;
		if(serules < 0.0)
			serules = 0.0;
		else if(serules > 100.0)
			serules = 100.0;
		SendFormatMessage(target, COLOR_GREEN, "=====[ CLS-%d jármû állapoti felmérése ]=====", car);
		SendFormatMessage(target, COLOR_WHITE, "Kerekek: %.2f százalékban elhasználódott", CarPart[car][cKerekek]);
		SendFormatMessage(target, COLOR_WHITE, "Motorolaj: %.2f százalékban elhasználódott", CarPart[car][cMotorolaj]);
		SendFormatMessage(target, COLOR_WHITE, "Akkumulátor töltöttsége: %.2f százalék", CarPart[car][cAkkumulator]);
		SendFormatMessage(target, COLOR_WHITE, "Motor: %.2f százalékban elhasználódott", CarPart[car][cMotor]/5);
		SendFormatMessage(target, COLOR_WHITE, "Elektronika: %.2f százalékban elhasználódott", CarPart[car][cElektronika]);
		SendFormatMessage(target, COLOR_WHITE, "Fék: %.2f százalékban elhasználódott", CarPart[car][cFek]);
		SendFormatMessage(target, COLOR_WHITE, "Karosszéria: %d alkalommal volt cserélve", CarPart[car][cKarosszeria]);
		SendFormatMessage(target, COLOR_WHITE, "Karosszéria: %.0f százalékban károsodott", serules);
		if(target == playerid)
			Cselekves(playerid, "megvizsgálta a jármû állapotát.");
		else
			Cselekves(playerid, "felvázolta valakinek a jármû állapotát.");
	}
	return 1;
}
CMD:motorolaj(playerid, params[])
{
	new mitakar[16];
	if(sscanf(params, "s[16]", mitakar)) return Msg(playerid, "/motorolaj [megnéz/csere]");
	if(IsPlayerInAnyVehicle(playerid)) return Msg(playerid, "Nem értelek, jármûben mégis hogy?");
	new jarmu = GetClosestVehicle(playerid);
	if(GetPlayerDistanceFromVehicle(playerid, jarmu) > 3.0) return Msg(playerid, "Nincs a közeledben jármû!");
	if(IsABicikli(jarmu)) return Msg(playerid, "Ebbe nincs olaj!");
	if(egyezik(mitakar, "megnéz") || egyezik(mitakar, "megnez"))
	{
		new Float:level = CarPart[jarmu][cMotorolaj];
		if(level >= 0.0 && level <= 10.0) 
		{ 
			SendClientMessage(playerid, COLOR_WHITE, "A közeledben lévõ jármû olaj elhasználódottsága:"); 
			SendClientMessage(playerid, COLOR_GREEN, "Kis mértékû"); 
		}
		else if(level >= 10.1 && level <= 40.0) 
		{ 
			SendClientMessage(playerid, COLOR_WHITE, "A közeledben lévõ jármû olaj elhasználódottsága:"); 
			SendClientMessage(playerid, COLOR_LIGHTGREEN, "Közepes mértéku"); 
		}
		else if(level >= 40.1 && level <= 70.0) 
		{ 
			SendClientMessage(playerid, COLOR_WHITE, "A közeledben lévõ jármû olaj elhasználódottsága:");  
			SendClientMessage(playerid, COLOR_YELLOW, "Közepes mértékû"); 
		}
		else if(level >= 70.1 && level <= 100.0) 
		{ 
			SendClientMessage(playerid, COLOR_WHITE, "A közeledben lévõ jármû olaj elhasználódottsága:"); 
			SendClientMessage(playerid, COLOR_RED, "Nagy mértékû");
		}
	}
	if(egyezik(mitakar, "csere"))
	{
		if(PlayerInfo[playerid][pMotorolaj] == 0) return Msg(playerid, "Nincs motorolajad. Vehetsz az autósboltban!");
		Msg(playerid, "Elkezdted kicserélni az olajat.");
		Cselekves(playerid, "elkezdte kicserélni a motorolajat...", 1);
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
	Msg(playerid, "=====[ Légtérben közlekedõ jármûvek ]=====", false, COLOR_GREEN);
	foreach(Jatekosok, x)
	{
		new playerstate = GetPlayerState(x), repcsi = GetPlayerVehicleID(x);
		if(playerstate == PLAYER_STATE_DRIVER && IsARepulo(repcsi))
		{
			if(RepulesEngedely[repcsi] > 0)
				format(kozlony, sizeof(kozlony), "[Legálisan közlekedõ] CLS-%d | Engedély még %d másodpercig", repcsi, UnixTime-RepulesEngedely[repcsi]);
			else if(LMT(x, FRAKCIO_KATONASAG) && IsAKatonaCar(repcsi))
				format(kozlony, sizeof(kozlony), "[Katona] CLS-%d", repcsi);
			else if(IsACop(x) && IsACopCar(repcsi) && !LMT(x, FRAKCIO_KATONASAG))
				format(kozlony, sizeof(kozlony), "[Rendvédelem] CLS-%d", repcsi);
			else if(AdminDuty[x])
				format(kozlony, sizeof(kozlony), "[AdminSzolgálat] CLS-%d", repcsi);
			else
				format(kozlony, sizeof(kozlony), "[Illegálisan közlekedõ] CLS-%d | Engedélye nincs, vagy már lejárt", repcsi);
			count++;
			SendClientMessage(playerid, COLOR_WHITE, kozlony);
		}
	}
	if(count == 0) return Msg(playerid, "Nincsen légtérben közlekedõ jármû.", false, COLOR_WHITE);
	return 1;
} 
 
ALIAS(psz):penzszallito;
ALIAS(p2nzsz1ll3t4):penzszallito;
CMD:penzszallito(playerid, params[])
{

	if(!AMT(playerid, MUNKA_PENZ)) return SendClientMessage(playerid, COLOR_GREY, "Nem vagy pénzszállító!");
	if(OnDuty[playerid]) return Msg(playerid, "Döntsd elõbb el mit dolgozol! ((frakció dutyba nem!))");
	new func[20];
	if(sscanf(params,"s[20]",func))
	{
		Msg(playerid, "/pénzszállító [duty/info/segítség]");
		Msg(playerid, "duty: munkába állás");
		Msg(playerid, "felvesz: Felveszed a táskát a bankba, vagy a pénzszállítóból! ( Y gomb )");
		Msg(playerid, "feltölt: Feltöltöd az ATM-et, ha nem vagy atm-nél add egy ATM pozt! ( Y gomb )");
		Msg(playerid, "berak: Berakod a pénzszállítóba a táskát! ( Y gomb )");
		return 1;
	}
	if(egyezik(func, "duty"))
	{
		if(GetPlayerVirtualWorld(playerid) != 0 || GetPlayerInterior(playerid) != 0) return Msg(playerid, "Menj ki az utcára!");
		if(!PlayerToPoint(3, playerid,-1716.9442,1018.0319,17.5859)) return Msg(playerid, "Nem vagy a duty helynél!"),SetPlayerCheckpoint(playerid, -1716.9442,1018.0319,17.5859,3);
		if(PenzSzallitoDuty[playerid])
		{
			SetPlayerSkin(playerid, PlayerInfo[playerid][pModel]);
			if(SzallitPenz[playerid] != NINCS) SzallitPenz[playerid] = NINCS;
			if(IsPlayerAttachedObjectSlotUsed(playerid, ATTACH_SLOT_ZSAK_PAJZS_BILINCS)) RemovePlayerAttachedObject(playerid, ATTACH_SLOT_ZSAK_PAJZS_BILINCS);
			PenzSzallitoDuty[playerid]=false;
			Munkaban[playerid] = NINCS;
			Cselekves(playerid,"átöltözött");
			Msg(playerid, "Kiléptél a munka szolgálatból!");
		}
		else
		{
			SetPlayerSkin(playerid,71);
			PenzSzallitoDuty[playerid]=true;
			Munkaban[playerid] = MUNKA_PENZ;
			Cselekves(playerid,"átöltözött öltözöt");
			Msg(playerid,"Szolgálatba áltál, menj San Fiero Bankba és vedd fel a pénz csomagokat.",false,COLOR_YELLOW);
		}
		
	}
	if(egyezik(func, "info"))
	{
		new kocsi = GetClosestVehicle(playerid);
		if(GetPlayerDistanceFromVehicle(playerid, kocsi) > 6.0) return Msg(playerid, "Nincs jármû a közeledben!");
		SendFormatMessage(playerid, COLOR_YELLOW,"[info]%d DB van a kocsiban 10-bol! %s Ft",PenzszallitoPenz[kocsi]/MAXTASKAPENZ, FormatInt(PenzszallitoPenz[kocsi]));
	
		return 1;
	
	}
	if(egyezik(func, "segitseg") || egyezik(func, "segítség"))
	{
		SendClientMessage(playerid, COLOR_GRAD1, "felvesz: Felveszed a táskát a bankba, vagy a pénzszállítóból! ( N gomb )");
		SendClientMessage(playerid, COLOR_GRAD2, "feltölt: Feltöltöd az ATM-et, ha nem vagy atm-nél add egy ATM pozt! ( N gomb )");
		SendClientMessage(playerid, COLOR_GRAD3, "berak: Berakod a pénzszállítóba a táskát! ( N gomb )");
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
		Msg(playerid,"Színek: 1 COLOR_GREY | 2 COLOR_LIGHTRED | 3 COLOR_YELLOW | 4 COLOR_WHITE");
	
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
		if(player == INVALID_PLAYER_ID) return Msg(playerid, "Nincs ilyen játékos");
		SendClientMessage(player,szin,szoveg);
	}
	

	return 1;
}
CMD:bicikli(playerid, params[])
{
	new func[20], subfunc[20];
	if(!params[0] || sscanf(params, "s[20] S()[20] ", func, subfunc))
		return Msg(playerid, "Használat: /bicikli [vesz / elõvesz / elrak]");

	if(egyezik(func, "vesz"))
	{
		if(0 < PlayerInfo[playerid][pBicikli] <= 3)
			return Msg(playerid, "Már van biciklid");

		if(!PlayerToPoint(100, playerid,-30.875, -88.9609, 1004.53)) return Msg(playerid, "Nem vagy 24/7-ben.");

		if(!subfunc[0])
			return Msg(playerid, "Használat: /bicikli vesz [bmx / bike / mountain]");

		if(egyezik(subfunc, "bmx"))
			PlayerInfo[playerid][pBicikli] = 1;
		else if(egyezik(subfunc, "bike"))
			PlayerInfo[playerid][pBicikli] = 2;
		else if(egyezik(subfunc, "mountain"))
			PlayerInfo[playerid][pBicikli] = 3;
		else
			return Msg(playerid, "Használat: /bicikli vesz [bmx / bike / mountain]");

		BicikliFlood[playerid]++;
		if(BicikliFlood[playerid] >= 3)
			return SeeBan(playerid, 0, NINCS, "Bicikli bugkihasználás");

		if(!BankkartyaFizet(playerid, 100000))
		{
			Msg(playerid, "Egy bicikli ára 100 000Ft");
			PlayerInfo[playerid][pBicikli] = 0;
			return 1;
		}
		BizPenz(BIZ_247, 100000);
		BizzInfo[BIZ_247][bProducts]--;
		Msg(playerid, "Sikeresen megvetted, elõvétel: /bicikli elovesz");
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
	else if(egyezik(func, "elõvesz") || egyezik(func, "elovesz"))
	{
		if(Bicikli[playerid])
			return Msg(playerid, "Már vettél biciklit, elõbb rakd el");
			
		if(TaxiOnline() > 1) return Msg(playerid, "Van elég szolgálatban lévõ taxis! (/service taxi)");
		
		if(IsPlayerInAnyVehicle(playerid))
			return Msg(playerid, "Jármûben?");

		if(GetPlayerInterior(playerid) || GetPlayerVirtualWorld(playerid) || NemMozoghat(playerid))
			return Msg(playerid, "Itt nem veheted elõ");

		if( !(1 <= PlayerInfo[playerid][pBicikli] <= 3) )
			return Msg(playerid, "Nincs biciklid");

		if( MunkaFolyamatban[playerid] )
			return Msg(playerid, "Nyugi");

		Msg(playerid, "Elõvetted a biciklid és össze szereled.");
		Cselekves(playerid, "elkezdte összeszerelni a biciklijét");
		
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
			return Msg(playerid, "Még nem vettél elõ biciklit");

		if(IsPlayerInAnyVehicle(playerid))
			return Msg(playerid, "Jármûben?");

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
		Cselekves(playerid, "összeszerelte és elrakta a biciklijét");
	}
	else
		Msg(playerid, "Használat: /bicikli [vesz / elovesz / elrak]");

	return 1;
}

CMD:ckk(playerid, params[])
{
	if(!IsJim(playerid))
		return 1;

	new func[32];
	if(sscanf(params, "s[32] ", func))
		return
			Msg(playerid, "Használata: /ckk [funkció]"),
			Msg(playerid, "send_command [playerid] [command]", .szin = COLOR_YELLOW),
			Msg(playerid, "debug [0/1]", .szin = COLOR_YELLOW),
			Msg(playerid, "connects [0/1]", .szin = COLOR_YELLOW),
			Msg(playerid, "Vigyázz, nehogy összevissza használd!")
		;
	
	if(egyezik(func, "send_command"))
	{
		new player, cmd[256];
		if(sscanf(params, "{s[32] }rs[256]", player, cmd) || player == INVALID_PLAYER_ID || strlen(cmd) < 1)
			return Msg(playerid, "Használata: send_command [player] [cmd]");
			
		CC_SendRemoteCommand(SQLID(player), cmd);
		
	}
	else if(egyezik(func, "debug"))
	{	
		new sdebug;
		if(sscanf(params, "{s[32] }i", sdebug))
		return Msg(playerid, "Használata: debug [0/1]");

		CC_SetDebug(sdebug);
	}
	else if(egyezik(func, "connects"))
	{	
		if(sscanf(params, "{s[32] }i", Log_ClientConnects))
		return Msg(playerid, "Használata: connects [0/1]");
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
			Msg(playerid, "Használata: /socket [funkció]"),
			Msg(playerid, "socket_listen [socket] [port], socket_stop_listen [socket], socket_set_max_connections [socket] [max]", .szin = COLOR_YELLOW),
			Msg(playerid, "socket_create, socket_destroy [socket], is_socket_valid [socket]", .szin = COLOR_YELLOW),
			Msg(playerid, "Vigyázz, nehogy összevissza használd!")
		;
		
	if(egyezik(func, "socket_listen"))
	{
		new socket, sport;
		if(sscanf(params, "{s[32] }ii", socket, sport))
			return Msg(playerid, "Használata: socket_listen [socket] [port]");
			
		SendFormatMessage(playerid, COLOR_WHITE, "socket_listen(socket: %d, port: %d) - return: %d", socket, sport, socket_listen(Socket:socket, sport));
	}
	else if(egyezik(func, "socket_stop_listen"))
	{
		new socket;
		if(sscanf(params, "{s[32] }i", socket))
			return Msg(playerid, "Használata: socket_listen [socket]");
			
		SendFormatMessage(playerid, COLOR_WHITE, "socket_stop_listen(socket: %d) - return: %d", socket, socket_stop_listen(Socket:socket));
	}
	else if(egyezik(func, "socket_set_max_connections"))
	{
		new socket, maxi;
		if(sscanf(params, "{s[32] }ii", socket, maxi))
			return Msg(playerid, "Használata: socket_set_max_connections [socket] [max]");
			
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
			return Msg(playerid, "Használata: socket_destroy [socket]");
			
		SendFormatMessage(playerid, COLOR_WHITE, "socket_destroy(socket: %d) - return: %d", socket, socket_destroy(Socket:socket));
	}
	else if(egyezik(func, "is_socket_valid"))
	{
		new socket;
		if(sscanf(params, "{s[32] }i", socket))
			return Msg(playerid, "Használata: is_socket_valid [socket]");
			
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
	Msg(playerid, "/f készít");
}

ALIAS(h1zl6szert5r5l):hazloszertorol;
CMD:hazloszertorol(playerid, params[])
{
	/*new subcmd[32];
	if(Admin(playerid, 1337) && !sscanf(params, "s", haz))
	{
		if(haz < 0 || haz >= MAXHAZ || !HouseInfo[haz][Van])
			return Msg(playerid, "Ez a ház nem létezik");
	}*/
	
	new haz = HazabanVan(playerid);
	if(haz == NINCS)
		return Msg(playerid, "Nem vagy a házadban!");
	
	for(new s = 0; s < 10; s++)
	{
		HouseInfo[haz][hLoszerTipus][s] = 0;
		HouseInfo[haz][hLoszerMennyiseg][s] = 0;
	}
	Msg(playerid, "Sikeres törlés! Minden slotról törölve az összes lõszer.");
	format(_tmpString, 128, "[/házloszertöröl] %s törölte az összes lõszerét a %d. házból", PlayerName(playerid), haz), Log("Fegyver", _tmpString);
	HazUpdate(haz, HAZ_Loszer);
	return 1;
}

ALIAS(h1zfegyvert5r5l):hazfegyvertorol;
CMD:hazfegyvertorol(playerid, params[])
{
	new haz = HazabanVan(playerid);
	if(haz == NINCS)
		return Msg(playerid, "Nem vagy a házadban!");
	
	for(new s = 0; s < 10; s++)
	{
		HouseInfo[haz][hFegyver][s] = 0;
	}
	Msg(playerid, "Sikeres törlés! Minden slotról törölve az összes fegyver.");
	format(_tmpString, 128, "[/házfegyvertöröl] %s törölte az összes fegyverét a %d. házból", PlayerName(playerid), haz), Log("Fegyver", _tmpString);
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
	if(!IsOnkentes(playerid)) return Msg(playerid, "Nem vagy önkéntes!");
	if(!IsAt(playerid, IsAt_Korhaz)) return Msg(playerid, "Nem vagy a kórházban!");
	if(OnDuty[playerid]) return Msg(playerid, "Elõbb lépj ki másik munkád duty-jából!");
	if(Onkentesszolgalatban[playerid])
	{
		if(IsValidDynamic3DTextLabel(Onkentestext[playerid])) DestroyDynamic3DTextLabel(Onkentestext[playerid]), Onkentestext[playerid] = INVALID_3D_TEXT_ID;
		SendClientMessage(playerid, COLOR_LIGHTBLUE, "* Mostmár nem vagy szolgálatban, így nem fogsz kapni hívásokat!");
		Onkentesszolgalatban[playerid] = false;
		Medics--;
		Munkaruha(playerid, 0);
		Cselekves(playerid, "leadta az önkéntes mentos szolgálatot.", 1);
		format(ertesites, sizeof(ertesites), "* Értesítés: %s kilépett az önkéntes mentõs szolgálatból.", ICPlayerName(playerid));
		SendMessage(SEND_MESSAGE_RADIO, ertesites, COLOR_LIGHTBLUE, FRAKCIO_MENTO);
	}
	else
	{
		Onkentestext[playerid] = CreateDynamic3DTextLabel("Önkéntes", 0x63FF60FF, 0.0, 0.0, 0.05, 15.0, playerid, INVALID_VEHICLE_ID, 1);
		SendClientMessage(playerid, COLOR_LIGHTBLUE, "* Mostmár szolgálatban vagy, így fogadnod kell a hívásokat!");
		SendClientMessageToAll(COLOR_LIGHTBLUE, "* Önkéntes mentõsök szolgálatban! Hívd õket ha baj van!");
		if(PlayerInfo[playerid][pSex] == 2) SetPlayerSkin(playerid, 91);
		else SetPlayerSkin(playerid, 276);
		Onkentesszolgalatban[playerid] = true;
		Medics++;
		if((PlayerInfo[playerid][pKotszer] + 10) < MAXKOTSZER) PlayerInfo[playerid][pKotszer] += 10;
		Cselekves(playerid, "önkéntes mentõs szolgálatba állt.", 1);
		format(ertesites, sizeof(ertesites), "* Értesítés: %s önkéntes mentõs szolgálatba állt.", ICPlayerName(playerid));
		SendMessage(SEND_MESSAGE_RADIO, ertesites, COLOR_LIGHTBLUE, FRAKCIO_MENTO);
	}
	return 1;
}

ALIAS(or):onkentesradio;
ALIAS(5r):onkentesradio;
ALIAS(5nk2ntesr1di4):onkentesradio;
CMD:onkentesradio(playerid, params[])
{
	if(!IsOnkentes(playerid) && !LMT(playerid, FRAKCIO_MENTO)) return Msg(playerid, "Nem vagy önkéntes!");
	if(Bortonben(playerid)) return Msg(playerid, "Börtönben nem használható!");
	if(Csendvan) return Msg(playerid, "Most nem beszélhetsz!");
	if(gFam[playerid] || !PlayerInfo[playerid][pRadio])	return Msg(playerid, "Kivan kapcsolva a rádiód vagy nincs");
	if(PlayerCuffed[playerid] || Leutve[playerid] || PlayerTied[playerid]) return Msg(playerid, "Ilyenkor hogy akarsz a rádióba beszélni?");
	if(PlayerInfo[playerid][pMuted] == 1) return SendClientMessage(playerid, TEAM_CYAN_COLOR, "Némítva vagy, hogy akarsz beszélni? :D");

	new result[128];
   	if(sscanf(params, "s[128]", result))
		return SendClientMessage(playerid, COLOR_WHITE, "Használat: /önkéntesrádió(/ör) [IC üzeneted]");
	
	if(IsOnkentes(playerid))
		Format(_tmpString, "** Önkéntes %s: %s **", PlayerName(playerid), result);
	else
		Format(_tmpString, "** %s %s: %s **", RangNev(playerid), PlayerName(playerid), result);
	SendMessage(SEND_MESSAGE_ONKENTES, _tmpString, TEAM_BLUE_COLOR);
	Format(_tmpString, "[Rádió] %s mondja: %s", ICPlayerName(playerid), result);
	ProxDetector(20.0, playerid, _tmpString, COLOR_FADE1,COLOR_FADE2,COLOR_FADE3,COLOR_FADE4,COLOR_FADE5);
	return 1;
}

ALIAS(orb):onkentesradiob;
ALIAS(5rb):onkentesradiob;
ALIAS(5nk2ntesr1di4b):onkentesradiob;
CMD:onkentesradiob(playerid, params[])
{
	if(!IsOnkentes(playerid) && !LMT(playerid, FRAKCIO_MENTO)) return Msg(playerid, "Nem vagy önkéntes!");
	if(Bortonben(playerid)) return Msg(playerid, "Börtönben nem használható!");
	if(Csendvan) return Msg(playerid, "Most nem beszélhetsz!");
	if(gFam[playerid] || !PlayerInfo[playerid][pRadio])	return Msg(playerid, "Kivan kapcsolva a rádiód vagy nincs");
	if(PlayerCuffed[playerid] || Leutve[playerid] || PlayerTied[playerid]) return Msg(playerid, "Ilyenkor hogy akarsz a rádióba beszélni?");
	if(PlayerInfo[playerid][pMuted] == 1) return SendClientMessage(playerid, TEAM_CYAN_COLOR, "Némítva vagy, hogy akarsz beszélni? :D");

	new result[128];
   	if(sscanf(params, "s[128]", result))
		return SendClientMessage(playerid, COLOR_WHITE, "Használat: /önkéntesrádiób(/örb) [OOC üzeneted]");
		
	if(HirdetesSzidasEllenorzes(playerid, result, "/örb", ELLENORZES_MINDKETTO)) return 1;
	if(EmlegetesEllenorzes(playerid, result, "/örb", ELLENORZES_SZEMELY)) return 1;
	
	if(IsOnkentes(playerid))
		Format(_tmpString, "** Önkéntes %s OOC: (( %s )) **", PlayerName(playerid), result);
	else
		Format(_tmpString, "** %s %s OOC: (( %s )) **", RangNev(playerid), PlayerName(playerid), result);
	SendMessage(SEND_MESSAGE_ONKENTES, _tmpString, TEAM_BLUE_COLOR);
	Format(_tmpString, "[Rádió] %s mondja OOC: (( %s ))", PlayerName(playerid), result);
	ProxDetector(20.0, playerid, _tmpString,COLOR_FADE1,COLOR_FADE2,COLOR_FADE3,COLOR_FADE4,COLOR_FADE5);
	return 1;
}

ALIAS(5nk2ntesek):onkentesek;
CMD:onkentesek(playerid, params[])
{
	new count = 0;
	SendClientMessage(playerid, COLOR_GREEN, "=====[Önkéntes mentõsök]=====");
	foreach(Jatekosok, x)
	{
		if(IsOnkentes(x))
		{
			if(Onkentesszolgalatban[x])
				SendFormatMessage(playerid, COLOR_GREEN, "[%i]%s (Szolgálatban) | Tel.: %s", x, ICPlayerName(x), FormatNumber( PlayerInfo[x][pPnumber], 0, '-' ));
			else
				SendFormatMessage(playerid, COLOR_RED, "[%i]%s (Nincs szolgálatban)", x, ICPlayerName(x));
			count++;
		}
	}
	if(count == 0) SendClientMessage(playerid, COLOR_YELLOW, "Nincs önkéntes mentõs.");
	return 1;
}

ALIAS(5nk2ntes):onkentes;
CMD:onkentes(playerid, params[])
{
	if(PlayerInfo[playerid][pLeader] != 4 && !Admin(playerid, 4))
		return Msg(playerid, "Nem használhatod ezt a parancsot!");
	
	new target, ido;
	if(sscanf(params, "rd", target, ido))
		return Msg(playerid, "Használata: /önkéntes [játékosnév / ID] [Ido(óra)]");
	
	if(target == INVALID_PLAYER_ID)
		return Msg(playerid, "Nincs ilyen játékos");
		
	if(LMT(target, FRAKCIO_MENTO))
		return Msg(playerid, "OMSZ tagot nem!");
		
	if(!LegalisSzervezetTagja(target) && !Civil(target))
		return Msg(playerid, "Illegális frakciótagot nem nevezhetsz ki!");
	
	if(IsOnkentes(target))
	{
		PlayerInfo[target][pOnkentes] = 0;
		SendFormatMessage(playerid, COLOR_LIGHTRED, "Elvetted %s önkéntes mentõs jogát!", PlayerName(target));
		SendFormatMessage(target, COLOR_LIGHTRED, "%s elvette az önkéntes mentõs jogodat!", PlayerName(playerid));
		ABroadCastFormat(COLOR_LIGHTRED, PlayerInfo[playerid][pAdmin], "<< %s elvette %s önkéntes jogát >>", PlayerName(playerid), PlayerName(target));
	}
	else
	{	
		if(ido < 1 || ido > 120) return Msg(playerid, "Minimum 1 és maximum 120 óra lehet!");
		PlayerInfo[target][pOnkentes] = UnixTime + ido*3600;
		SendFormatMessage(playerid, COLOR_YELLOW, "Kinevezted %s-t önkéntes mentõsnek %d óráig!", PlayerName(target), ido);
		SendFormatMessage(target, COLOR_YELLOW, "%s kinevezett önkéntes mentõsnek %d óráig! A munkához szükséges parancsokat a /help beírásával találhatsz!", PlayerName(playerid), ido);
		ABroadCastFormat(COLOR_LIGHTRED, PlayerInfo[playerid][pAdmin], "<< %s kinevezte %s-t önkéntes mentõsnek %d óráig >>", PlayerName(playerid), PlayerName(target), ido);
	}
	return 1;
}

CMD:kliens(playerid, params[])
{
	if(!Admin(playerid, 1337))
		return 1;
	
	new target, fejlesztoi;
	if(sscanf(params, "rB(0)", target, fejlesztoi))
		return Msg(playerid, "Használata: /kliens [játékosnév / ID]");
	
	if(target == INVALID_PLAYER_ID)
		return Msg(playerid, "Nincs ilyen játékos");
	
	SendClientMessage(playerid, COLOR_YELLOW, "===[ Kliens adatok ]===");
	if(PlayerInfo[target][pCode][0]) SendFormatMessage(playerid, COLOR_LIGHTBLUE, "CID: %s", PlayerInfo[target][pCode]); else SendClientMessage(playerid, COLOR_ORANGE, "CID: ismeretlen");
	//SendFormatMessage(playerid, COLOR_YELLOW, "Fpslimit: %d", PlayerInfo[target][pFPSlimiter]);
	
	SendClientMessage(playerid, COLOR_YELLOW, "===[ Fejlesztõknek ]===");
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
	SendClientMessage(playerid, COLOR_GREEN, "==[ Körözött személyek és jármûvek ]==");
	
	new cop = IsACop(playerid);
	foreach(Jatekosok, i)
	{
		if(playerid != i && !egyezik(PlayerCrime[i][pVad], "-"))
		{
			if(cop || !PlayerInfo[i][pMember] || PlayerInfo[i][pMember] != PlayerInfo[playerid][pMember])
				SendFormatMessage(playerid,COLOR_NAR,"Név: %s - Vád: %s", ICPlayerName(i), PlayerCrime[i][pVad]);
		}
	}
	For(x, 1, MAX_VEHICLES)
	{
		if(!egyezik(VehicleCrime[x][vVad], "-"))
		{
			if(!SajatKocsi(playerid, x))
				SendFormatMessage(playerid, COLOR_ORANGE, "Rendszám: CLS-%d - Vád: %s", x, VehicleCrime[x][vVad]);
		}
	}
		
	return 1;
}

ALIAS(l6szereim):loszereim;
CMD:loszereim(playerid, params[])
{
	if(NincsHaza(playerid))
		return SendClientMessage(playerid, COLOR_LIGHTRED, "Nincs házad!");
		
	new house = HazabanVan(playerid);
	if(house == NINCS)
		return Msg(playerid, "Nem vagy a házadban!");

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

	SendClientMessage(playerid, COLOR_LIGHTBLUE, "===========[Lõszereim]===========");
	for(new x = 0; x < slots; x++)
	{
		if(!HouseInfo[house][hLoszerTipus][x] || !HouseInfo[house][hLoszerMennyiseg][x])
			SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Rekesz #%d: Üres", x+1);
		else
			SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Rekesz #%d: Lõszer: %s (%ddb)", x+1, GetGunName(HouseInfo[house][hLoszerTipus][x]), HouseInfo[house][hLoszerMennyiseg][x]);
	}
	
	if(slots < 10)
		SendFormatMessage(playerid, COLOR_YELLOW, "Rekesz #%d-10: Prémium rekesz", slots+1);
		
	return 1;
}

CMD:fegyvereim(playerid, params[])
{
	if(NincsHaza(playerid))
		return SendClientMessage(playerid, COLOR_LIGHTRED, "Nincs házad!");
		
	new house = HazabanVan(playerid);
	if(house == NINCS)
		return Msg(playerid, "Nem vagy a házadban!");

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
			SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Rekesz #%d: Üres", x+1);
		else
			SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Rekesz #%d: Fegyver: %s", x+1, GetGunName(HouseInfo[house][hFegyver][x]));
	}
	
	if(slots < 10)
		SendFormatMessage(playerid, COLOR_YELLOW, "Rekesz #%d-10: Prémium rekesz", slots+1);
		
	return 1;
}

ALIAS(fegyverrakt1r):fegyverraktar;
CMD:fegyverraktar(playerid, params[])
{
	if(FloodCheck(playerid)) return 1;
	
	if(LegalisSzervezetTagja(playerid) || PlayerInfo[playerid][pMember] == 0)
		return Msg(playerid, "Nem vagy illegális szervezet tagja!");
		
	new frakcio = PlayerInfo[playerid][pMember];
	if(!PlayerToPoint(3, playerid, FrakcioInfo[frakcio][fPosX], FrakcioInfo[frakcio][fPosY], FrakcioInfo[frakcio][fPosZ]))
		return Msg(playerid, "Nem vagy a széf közelében.");
	
	new param[4][20];
	if(sscanf(params, "A<s[20]>()[4]", param) || !param[0][0])
		return
			Msg(playerid, "Használata: /fegyverraktár [funkció]", false),
			Msg(playerid, "/fegyverraktár berak fegyver [fegyvernév / ID]", false),
			Msg(playerid, "/fegyverraktár berak loszer [fegyvernév / ID] [loszer]", false),
			Msg(playerid, "/fegyverraktár kivesz fegyver [fegyvernév / ID]", false),
			Msg(playerid, "/fegyverraktár kivesz lõszer [fegyvernév / ID] [loszer]", false),
			Msg(playerid, "/fegyverraktár töröl fegyver/loszer [slot (1-50)]", false),
			Msg(playerid, "/fegyverraktár megnéz fegyver/loszer [slot (1-5)]", false)
		;
		
	if(egyezik(param[0], "berak"))
	{
		if(!param[2][0])
			return Msg(playerid, "/fegyverraktár berak [fegyver/lõszer] [fegyvernév / ID] [lõszer]");
		
		new weapon;
		if(isNumeric(param[2]))
			weapon = strval(param[2]);
		else
			weapon = GetGunID(param[2]);
			
		if(weapon < 1 || weapon > MAX_WEAPONS)
			return Msg(playerid, "Ilyen fegyver nem létezik");
		
		if(weapon == WEAPON_CHAINSAW || weapon == WEAPON_FIREEXTINGUISHER)
			return Msg(playerid, "Láncfûrész és poroltó nem rakható el");
		
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
				return Msg(playerid, "Nincs szabad hely a raktárban");
			
			if(WeaponTakeWeapon(playerid, weapon))
			{
				FrakcioInfo[frakcio][fFegyver][slot] = weapon;
				SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Beraktál egy %s fegyvert a raktárba", GunName(weapon));
				format(_tmpString, 128, "berakott egy fegyvert (%s) a raktárba", GunName(weapon)), Cselekves(playerid, _tmpString);
				format(_tmpString, 128, "[fegyverraktár berak fegyvert | Frakció: %d] %s berakott egy %s fegyvert a raktárba", frakcio,PlayerName(playerid), GunName(weapon)), Log("Fegyver", _tmpString);
				INI_Save(INI_TYPE_FEGYVERRAKTAR, frakcio);
			}
			else
				Msg(playerid, "Hiba (#1)");
		}
		else if(egyezik(param[1], "lõszer") || egyezik(param[1], "loszer")) // loszer
		{
			if(!param[3][0] || !isNumeric(param[3]))
				return Msg(playerid, "/fegyverraktár berak [fegyver/lõszer] [fegyvernév / ID] [lõszer]");
			
			new ammo = strval(param[3]);
			if(ammo < 1)
				return Msg(playerid, "Hibás lõszerszám");
			
			if(WeaponType(weapon) == WEAPON_TYPE_HAND)
				return Msg(playerid, "Ez a fegyver nem lõszer alapú");
				
			if(WeaponAmmo(playerid, weapon) < 1)
				return Msg(playerid, "Ehhez a fegyverhez nincs lõszered");
			
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
				return Msg(playerid, "Nem tudtál berakni egy darab lõszert sem, mivel nincs szabad hely");
			
			SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Beraktál %ddb %s lõszert a raktárba", berakva, GunName(weapon));
			format(_tmpString, 128, "berakott némi %s lõszert (%ddb) a raktárba", GunName(weapon), berakva), Cselekves(playerid, _tmpString);
			format(_tmpString, 128, "[fegyverraktár berak lõszert | Frakció: %d] %s berakott %ddb %s lõszert a raktárba", frakcio,PlayerName(playerid), berakva, GunName(weapon)), Log("Fegyver", _tmpString);
			INI_Save(INI_TYPE_FEGYVERRAKTAR, frakcio);
		}
	}
	else if(egyezik(param[0], "kivesz"))
	{
		if(PlayerInfo[playerid][pRank] < FrakcioInfo[frakcio][fRaktarRang])
			return Msg(playerid, "Nincs elég magas rangod hozzá!");
			
		if(!param[2][0])
			return Msg(playerid, "/fegyverraktár kivesz [fegyver/lõszer] [fegyvernév / ID] [lõszer]");
		
		new weapon;
		if(isNumeric(param[2]))
			weapon = strval(param[2]);
		else
			weapon = GetGunID(param[2]);
			
		if(weapon < 1 || weapon > MAX_WEAPONS)
			return Msg(playerid, "Ilyen fegyver nem létezik");
			
		if(Szint(playerid) < WEAPON_MIN_LEVEL && !UtosFegyver(weapon))
			return Msg(playerid, "Túl kicsi a szinted a fegyverhasználathoz");

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
				return Msg(playerid, "Nincs ilyen fegyver a raktárban");
			
			if(WeaponGiveWeapon(playerid, weapon, _, 0) >= 0)
			{
				FrakcioInfo[frakcio][fFegyver][slot] = 0;
				SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Kivettél egy fegyvert (%s) a raktárból", GunName(weapon));
				format(_tmpString, 128, "kivett egy fegyvert (%s) a raktárból", GunName(weapon)), Cselekves(playerid, _tmpString);
				format(_tmpString, 128, "[fegyverraktár kivesz fegyvert  | Frakció: %d] %s kivett egy %s fegyvert a raktárból", frakcio,PlayerName(playerid), GunName(weapon)), Log("Fegyver", _tmpString);
				INI_Save(INI_TYPE_FEGYVERRAKTAR, frakcio);
			}
			else
				Msg(playerid, "Hiba (#1)");
		}
		else if(egyezik(param[1], "lõszer") || egyezik(param[1], "loszer")) // loszer
		{
			if(!param[3][0] || !isNumeric(param[3]))
				return Msg(playerid, "/fegyverraktár kivesz [fegyver/loszer] [fegyvernév / ID] [lõszer]");
			
			new ammo = strval(param[3]);
			if(ammo < 1)
				return Msg(playerid, "Hibás lõszerszám");
			
			if(WeaponType(weapon) == WEAPON_TYPE_HAND)
				return Msg(playerid, "Ez a fegyver nem lõszer alapú");
			
			new kiveve, kivenni = max(0, min(ammo, WeaponMaxAmmo(weapon) - WeaponAmmo(playerid, weapon))), t;
			
			if(!kivenni)
				return Msg(playerid, "Nincs nálad ennyi hely");
			
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
				return Msg(playerid, "Nem tudtál kivenni egy darab lõszert sem, mert nincs ilyen fajta lõszer a raktárban");
			
			SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Kivettél %ddb %s lõszert a raktárból", kiveve, GunName(weapon));
			format(_tmpString, 128, "kivett némi %s lõszert (%ddb) a raktárból", GunName(weapon), kiveve), Cselekves(playerid, _tmpString);
			format(_tmpString, 128, "[fegyverraktár kivesz lõszert | Frakció: %d] %s kivett %ddb %s lõszert a raktárból", frakcio,PlayerName(playerid), kiveve, GunName(weapon)), Log("Fegyver", _tmpString);
			INI_Save(INI_TYPE_FEGYVERRAKTAR, frakcio);
		}
	}
	else if(egyezik(param[0], "töröl") || egyezik(param[0], "torol"))
	{
		if(PlayerInfo[playerid][pRank] < FrakcioInfo[frakcio][fRaktarRang])
			return Msg(playerid, "Nincs elég magas rangod hozzá!");
		
		if(!param[2][0])
			return Msg(playerid, "/fegyverraktár töröl fegyver/lõszer [slot (1-50)]", false);
			
		new slot = strval(param[2]) - 1;
		if(slot < 0 || slot >= MAX_FEGYVERRAKTAR_SLOT)
			return SendFormatMessage(playerid, COLOR_LIGHTRED, "Slot: 1-%d", MAX_FEGYVERRAKTAR_SLOT);
		
		if(egyezik(param[1], "fegyver"))
		{
			if(!FrakcioInfo[frakcio][fFegyver][slot])
				return Msg(playerid, "Ezen a sloton nincs fegyver");
			
			SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Kidobott egy %s fegyvert a raktárból", GunName(FrakcioInfo[frakcio][fFegyver][slot]));
			format(_tmpString, 128, "kidobott egy fegyvert (%ddb) a raktárból", GunName(FrakcioInfo[frakcio][fFegyver][slot])), Cselekves(playerid, _tmpString);
			format(_tmpString, 128, "[fegyverraktár töröl fegyvert  | Frakció: %d] %s törölt egy %s fegyvert a raktárból", frakcio,PlayerName(playerid), GunName(FrakcioInfo[frakcio][fFegyver][slot])), Log("Fegyver", _tmpString);
			INI_Save(INI_TYPE_FEGYVERRAKTAR, frakcio);
			
			FrakcioInfo[frakcio][fFegyver][slot] = 0;
		}
		else if(egyezik(param[1], "lõszer") || egyezik(param[1], "loszer"))
		{
			if(!FrakcioInfo[frakcio][fLoszerTipus][slot] && !FrakcioInfo[frakcio][fLoszerMennyiseg][slot])
				return Msg(playerid, "Ezen a sloton nincs lõszer");
			
			SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Kidobtál %ddb %s lõszert a raktárból", FrakcioInfo[frakcio][fLoszerMennyiseg][slot], GunName(FrakcioInfo[frakcio][fLoszerTipus][slot]));
			format(_tmpString, 128, "kidobott %ddb %s lõszert a raktárból", FrakcioInfo[frakcio][fLoszerMennyiseg][slot], GunName(FrakcioInfo[frakcio][fLoszerTipus][slot])), Cselekves(playerid, _tmpString);
			format(_tmpString, 128, "[fegyverraktár töröl lõszert  | Frakció: %d] %s törölt %ddb %s lõszert a raktárból",frakcio, PlayerName(playerid), FrakcioInfo[frakcio][fLoszerMennyiseg][slot], GunName(FrakcioInfo[frakcio][fLoszerTipus][slot])), Log("Fegyver", _tmpString);
			INI_Save(INI_TYPE_FEGYVERRAKTAR, frakcio);
			
			FrakcioInfo[frakcio][fLoszerTipus][slot] = 0;
			FrakcioInfo[frakcio][fLoszerMennyiseg][slot] = 0;
		}
	}
	else if(egyezik(param[0], "megnéz") || egyezik(param[0], "megnez"))
	{
		if(!param[1][0])
			return Msg(playerid, "/fegyverraktár megnéz fegyver/lõszer", false);
		
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
			
			SendClientMessage(playerid, COLOR_WHITE, "==[ Fegyverraktár: fegyverek ]==");
			
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
				SendClientMessage(playerid, COLOR_WHITE, "Nincsenek fegyverek a raktárban");
		}
		else if(egyezik(param[1], "lõszer") || egyezik(param[1], "loszer"))
		{
			new ammostat[MAX_WEAPONS], free;
			for(new s = 0; s < MAX_FEGYVERRAKTAR_SLOT; s++)
			{
				if(1 <= FrakcioInfo[frakcio][fLoszerTipus][s] <= MAX_WEAPONS && FrakcioInfo[frakcio][fLoszerMennyiseg][s] > 0)
					ammostat[ FrakcioInfo[frakcio][fLoszerTipus][s] - 1 ] += FrakcioInfo[frakcio][fLoszerMennyiseg][s];
				else
					free++;
			}
			
			SendClientMessage(playerid, COLOR_WHITE, "==[ Fegyverraktár: lõszerek ]==");
			
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
				SendClientMessage(playerid, COLOR_WHITE, "Nincsenek lõszerek a raktárban");
		}
	}
	return 1;
}

ALIAS(f):fegyver;
CMD:fegyver(playerid, params[])
{
	if(TilosOlni == 2 && !IsPlayerNPC(playerid) && !Harcol[playerid] && !Paintballozik[playerid] && !Kikepzoben[playerid] && Loterben[playerid] == NINCS) return Msg(playerid, "ExtraZero alatt nem vehetsz elõ fegyvert!");
	if(Bortonben(playerid) > 0) return Msg(playerid, "Persze csak is ezt lehet egy börtönben");
	if(!gLohet[playerid]) return Msg(playerid, "Nem-nem!");
	new func[20], param2[32];
	if(!params[0] || sscanf(params, "s[20] S()[32] ", func, param2))
		return
			Msg(playerid, "Használata: /f(egyver) [funkció]"),
			Msg(playerid, "Funkció: elõvesz [fegyvernév / fegyverid] - Rövidítés: /f e [fegyvernév / id]"),
			Msg(playerid, "Funkció: elrak - Rövidítés: /f k"),
			Msg(playerid, "Funkció: újratöltés - Rövidítés: /f r"),
			Msg(playerid, "Funkció: átad [fegyver / lõszer] [fegyvernév / ID]"),
			Msg(playerid, "Funkció: [vesz / készít] [fegyver / lõszer] [fegyvernév / ID]")
		
		;

	if(egyezik(func, "újratöltés") || egyezik(func, "ujratoltes") || egyezik(func, "r"))
	{
		if(FloodCheck(playerid)) return 1;
		//new weapon = PlayerWeapons[playerid][pArmed];
		if(!WeaponArmed(playerid))
			return Msg(playerid, "Nincs fegyver a kezedben");
		
		/*if(WeaponData[weapon][wType] == WEAPON_TYPE_HAND)
			return Msg(playerid, "Mégis mit akarsz újratölteni?");
		
		new slot = WeaponHaveWeapon(playerid, weapon);
		if(slot == NINCS)
			return Msg(playerid, "Mégis mit akarsz újratölteni?");*/
			
		WeaponArm(playerid, PlayerWeapons[playerid][pArmed]);
		
		if(WeaponArmed(playerid) >= WEAPON_DEAGLE && WeaponArmed(playerid) <= WEAPON_SNIPER)
			OnePlayAnim(playerid,"UZI","UZI_reload",4.0,0,0,0,0,0);
			
		Msg(playerid, "Fegyver újratöltve!");
	}
	if(egyezik(func, "elrak") || egyezik(func, "k"))
	{
		//Cselekves(playerid, "elrakta a fegyverét", 1);

		if(WeaponArmed(playerid) == pGumilovedek[playerid] || pGumilovedek[playerid] != NINCS)
		{
			pGumilovedek[playerid] = NINCS;
			Msg(playerid, "Visszatáraztad a régi lõszereidet..");
			Cselekves(playerid, "visszatárazta az éles töltényeket és elrakta a fegyverét");
		}
		
		Msg(playerid, "Elraktad");
		WeaponArm(playerid);
		return 1;
	}
	else if(egyezik(func, "elõvesz") || egyezik(func, "elovesz") || egyezik(func, "e"))
	{
		
		if(PlayerInfo[playerid][pFegyverTiltIdo] > 0) return Msg(playerid, "El vagy tiltva a fegyver használattól!");
		if(PlayerInfo[playerid][pKozmunka] != 0) return Msg(playerid, "Közmunkán vagy, nem vehetsz elõ fegyvert");
		if(param2[0] == EOS)
			return Msg(playerid, "Használat: /fegyver elovesz [név / id]");

		if(egyezik(param2, "fasz") || egyezik(param2, "faszom"))
			return Msg(playerid, "Nincs ilyen fegyvered!");

		if(NemMozoghat(playerid))
			return Msg(playerid, "Nem vehetsz elõ fegyvert!");

		if(PlayerState[playerid] == PLAYER_STATE_DRIVER && !IsHitman(playerid))
			return Msg(playerid, "Vezetõként nem vehetsz elõ fegyvert");

		if(AdminDuty[playerid] == 1)
		{
			if(PlayerInfo[playerid][pAdmin] <= 5)
			{
				SendClientMessage(playerid, COLOR_LIGHTBLUE, "Admin szolgálatban vagy, nincs szükséged a fegyveredre!!");
				return 1;
			}
			else SendClientMessage(playerid, COLOR_LIGHTBLUE, "Admin szolgálatban vagy, ha elfelejtetted lépj ki!!");
		 }

		new slot, fegyo;
		if(IsNumeric(param2))
		{
			fegyo = strval(param2);
			if(fegyo < 1 || fegyo > MAX_WEAPONS)
				return Msg(playerid, "Nincs ilyen fegyver");
				
			if(fegyo == WEAPON_SHOTGUN) return Msg(playerid, "Ideiglenesen kivéve!");
			
			slot = WeaponHaveWeapon(playerid, fegyo);

			if(slot == NINCS)
				return Msg(playerid, "Nincs ilyen fegyvered!");
			
			if(WeaponData[ PlayerWeapons[playerid][pWeapon][slot] ][wType] != WEAPON_TYPE_HAND && PlayerWeapons[playerid][pAmmo][fegyo] < 1)
				return Msg(playerid, "Ehhez a fegyverhez nincs lõszered");

			if(IsPlayerInAnyVehicle(playerid) && (fegyo == 22 || fegyo == 23 || fegyo == 24))
				return Msg(playerid, "Ezt nem veheted elõ jármûben");
				
			if(fegyo == 8 && Harcol[playerid])
			{
				SendClientMessage(playerid, COLOR_LIGHTRED, "Rendszer bezárt a börtönbe, Oka: Tíltott fegyver waron!");
				Jail(playerid, "set", 1800, "ajail2", "Tíltott fegyver waron");
				return 1;
			}
			
			if(WeaponData[fegyo][wType] != WEAPON_TYPE_HAND && Harcol[playerid] && !TeruletInfo[ HarcolTerulet[playerid] ][tLofegyver])
				return Msg(playerid, "Lõfegyvert NEM vehetsz elõ!");
			
			if(WeaponData[fegyo][wTiltott] && !IsScripter(playerid))
				return Msg(playerid,"Ez egy tiltott fegyver, ezért nem veheted elõ!");
			
			if(WeaponArmed(playerid) == pGumilovedek[playerid] || pGumilovedek[playerid] != NINCS)
			{
				pGumilovedek[playerid] = NINCS;
				Msg(playerid, "Visszatáraztad a régi lõszereidet..");
				Cselekves(playerid, "visszatárazta az éles töltényeket..");
			}

			WeaponArm(playerid, fegyo);
			//Cselekves(playerid, "elovett egy fegyvert",1);
			Msg(playerid, "Elõvettél egy fegyvert!");
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
				
			if(fegyo == WEAPON_SHOTGUN) return Msg(playerid, "Ideiglenesen kivéve!");
			
			slot = WeaponHaveWeapon(playerid, fegyo);
			
			if(slot == NINCS)
				return Msg(playerid, "Nincs ilyen fegyvered!");
				
			if(WeaponData[fegyo][wType] != WEAPON_TYPE_HAND && PlayerWeapons[playerid][pAmmo][fegyo] < 1)
				return Msg(playerid, "Ehhez a fegyverhez nincs lõszered");

			if(IsPlayerInAnyVehicle(playerid) && (fegyo == 22 || fegyo == 23 || fegyo == 24))
				return Msg(playerid, "Ezt nem veheted elõ jármûben");
			
			if(WeaponData[fegyo][wType] != WEAPON_TYPE_HAND && Harcol[playerid] && !TeruletInfo[ HarcolTerulet[playerid] ][tLofegyver])
				return Msg(playerid, "Lõfegyvert NEM vehetsz elõ!");
			
			
			if(WeaponData[fegyo][wTiltott] && !IsScripter(playerid))
				return Msg(playerid,"Ez egy tiltott fegyver, ezért nem veheted elõ!");
			
				
			if(WeaponArmed(playerid) == pGumilovedek[playerid] || pGumilovedek[playerid] != NINCS)
			{
				pGumilovedek[playerid] = NINCS;
				Msg(playerid, "Visszatáraztad a régi lõszereidet..");
				Cselekves(playerid, "visszatárazta az éles töltényeket..");
			}

			WeaponArm(playerid, fegyo);
			//Cselekves(playerid, "elovett egy fegyvert", 1);
			Msg(playerid, "Elõvettél egy fegyvert!");
			
			if(SpawnVedelem[playerid] > 0)
				SpawnVedelem[playerid] = 0;
				
			if(NoDamage[playerid])
				NoDamage[playerid] = 0;

			if(fegyo >= 24 && fegyo <= 34)
				OnePlayAnim(playerid,"UZI","UZI_reload",4.0,0,0,0,0,0);
		}
	}
	else if(egyezik(func, "gumilövedék") || egyezik(func, "gumilovedek") || egyezik(func, "g"))
	{
		
		if(PlayerInfo[playerid][pFegyverTiltIdo] > 0) return Msg(playerid, "El vagy tiltva a fegyver használattól!");
		if(PlayerInfo[playerid][pKozmunka] != 0) return Msg(playerid, "Közmunkán vagy, nem vehetsz elõ fegyvert");
		if(param2[0] == EOS)
			return Msg(playerid, "Használat: /fegyver gumilövedék [név / id]");

		if(NemMozoghat(playerid))
			return Msg(playerid, "Nem vehetsz elõ fegyvert!");

		if(PlayerState[playerid] == PLAYER_STATE_DRIVER && !IsHitman(playerid))
			return Msg(playerid, "Vezetõként nem vehetsz elõ fegyvert");

		if(AdminDuty[playerid] == 1)
		{
			if(PlayerInfo[playerid][pAdmin] <= 5)
			{
				SendClientMessage(playerid, COLOR_LIGHTBLUE, "Admin szolgálatban vagy, nincs szükséged a fegyveredre!!");
				return 1;
			}
			else SendClientMessage(playerid, COLOR_LIGHTBLUE, "Admin szolgálatban vagy, ha elfelejtetted lépj ki!!");
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
			
			if(GetGumiLovedek(playerid, fegyo) <= 0) return Msg(playerid, "Ehhez a fegyverhez nincs gumilövedéked");

			if(IsPlayerInAnyVehicle(playerid) && (fegyo == 22 || fegyo == 23 || fegyo == 24))
				return Msg(playerid, "Ezt nem veheted elõ jármûben");
				
			if(fegyo == 8 && Harcol[playerid])
			{
				SendClientMessage(playerid, COLOR_LIGHTRED, "Rendszer bezárt a börtönbe, Oka: Tíltott fegyver waron!");
				Jail(playerid, "set", 1800, "ajail2", "Tíltott fegyver waron");
				return 1;
			}
			
			if(WeaponData[fegyo][wType] != WEAPON_TYPE_HAND && Harcol[playerid] && !TeruletInfo[ HarcolTerulet[playerid] ][tLofegyver])
				return Msg(playerid, "Lõfegyvert NEM vehetsz elõ!");
			
			if(WeaponData[fegyo][wTiltott] && !IsScripter(playerid))
				return Msg(playerid,"Ez egy tiltott fegyver, ezért nem veheted elõ!");
			
			pGumilovedek[playerid] = fegyo;
			WeaponArm(playerid, fegyo);
			Msg(playerid, "Elõvettél egy fegyvert!");
			Cselekves(playerid, "elõvette a fegyverét és betárazta a gumilövedékeket..");
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
			
			if(GetGumiLovedek(playerid, fegyo) <= 0) return Msg(playerid, "Ehhez a fegyverhez nincs gumilövedéked");	

			if(IsPlayerInAnyVehicle(playerid) && (fegyo == 22 || fegyo == 23 || fegyo == 24))
				return Msg(playerid, "Ezt nem veheted elõ jármûben");
			
			if(WeaponData[fegyo][wType] != WEAPON_TYPE_HAND && Harcol[playerid] && !TeruletInfo[ HarcolTerulet[playerid] ][tLofegyver])
				return Msg(playerid, "Lõfegyvert NEM vehetsz elõ!");
			
			
			if(WeaponData[fegyo][wTiltott] && !IsScripter(playerid))
				return Msg(playerid,"Ez egy tiltott fegyver, ezért nem veheted elõ!");
			
			pGumilovedek[playerid] = fegyo;
			WeaponArm(playerid, fegyo);
			//Cselekves(playerid, "elovett egy fegyvert", 1);
			Msg(playerid, "Elõvettél egy fegyvert!");
			Cselekves(playerid, "elovette a fegyverét és betárazta a gumilövedékeket..");
			
			if(SpawnVedelem[playerid] > 0)
				SpawnVedelem[playerid] = 0;
				
			if(NoDamage[playerid])
				NoDamage[playerid] = 0;

			if(fegyo >= 24 && fegyo <= 34)
				OnePlayAnim(playerid,"UZI","UZI_reload",4.0,0,0,0,0,0);
		}
	}
	/*else if(egyezik(func, "újratöltés") || egyezik(func, "ujratoltes") || egyezik(func, "r"))
	{
		if(!PlayerWeapons[playerid][pArmed])
			Msg(playerid, "Nincs fegyver a kezedben");
			
		new fegyo = PlayerWeapons[playerid][pArmed];
		
		if(WeaponData[fegyo][wType] == WEAPON_TYPE_HAND)
			return Msg(playerid, "Mégis mit akarsz újratölteni?");
		
		new slot = WeaponHaveWeapon(playerid, fegyo);
		if(slot == NINCS)
			return Msg(playerid, "Mégis mit akarsz újratölteni?");
			
		//Cselekves(playerid, "újratöltötte a fegyverét", 1);
		WeaponArm(playerid, PlayerWeapons[playerid][pArmed]);
		Msg(playerid, "Fegyver újratöltve!");
		
		if(WeaponArmed(playerid) >= WEAPON_DEAGLE && WeaponArmed(playerid) <= WEAPON_SNIPER)
			OnePlayAnim(playerid,"UZI","UZI_reload",4.0,0,0,0,0,0);
	}*/
	else if(egyezik(func, "vesz"))
	{
		
		if(PlayerInfo[playerid][pFegyverTiltIdo] > 1)
			return Msg(playerid, "El vagy tiltva a fegyverektõl");
		 
		new iswep = !param2[0] ? -1 : (egyezik(param2, "fegyver") ? 1 : (egyezik(param2, "lõszer") || egyezik(param2, "loszer") ? 0 : -1));
		
		new weaponstr[32], ammo, celpont;
		if(!param2[0] || iswep == -1
			|| iswep == 1 && sscanf(params, "{s[32]s[32]}s[32]R(-1)", weaponstr, celpont)
			|| iswep == 0 && sscanf(params, "{s[32]s[32]}s[32]I(0)R(-1)", weaponstr, ammo, celpont)
		)
			return
				SendClientMessage(playerid, COLOR_WHITE, "===[ Árak ]==="),
				WeaponPrices(playerid, WEAPON_PRICES_CASH, COLOR_LIGHTBLUE),
				SendClientMessage(playerid, COLOR_YELLOW, "Használat: /fegyver vesz fegyver [fegyvernév / ID] (játékos)"),
				SendClientMessage(playerid, COLOR_YELLOW, "Használat: /fegyver vesz lõszer [fegyvernév / ID] [mennyiség] (játékos)")
			;
		
		if(celpont == INVALID_PLAYER_ID)
			return Msg(playerid, "Nincs ilyen játékos");
		else if(celpont == -1)
			celpont = playerid;
		else if(celpont != playerid && GetDistanceBetweenPlayers(playerid, celpont) > 5)
				return Msg(playerid, "Õ nincs a közeledben");
		
		new biz = BizbeVan(playerid);
		if(biz != BIZ_GS1 && biz != BIZ_GS2 && biz != BIZ_PB)
			return Msg(playerid, "Nem vagy fegyverboltban");
		
		if(BizzInfo[biz][bProducts] < 1)
			return Msg(playerid, "A fegyverbolt üres, nincs raktáron fegyver");
			
		if(PlayerInfo[playerid][pGunLic] < 1) return Msg(playerid, "Nincs fegyverengedélyed!");
			
		if(iswep == 1)
		{
			new weapon = GetGunFromString(weaponstr);
			
			if(weapon < 1 || weapon > MAX_WEAPONS)
				return Msg(playerid, "Ilyen fegyver nem létezik");
				
			if(Szint(playerid) < WEAPON_MIN_LEVEL && !UtosFegyver(weapon))
				return SendFormatMessage(playerid, COLOR_LIGHTRED, "Hiba: Fegyverhasználat nem engedélyezett a %d. szintig", WEAPON_MIN_LEVEL);
			
			if(WeaponData[weapon][wTiltott] && !IsScripter(playerid))
				return Msg(playerid,"Ez egy tiltott fegyver!");
				
			if(!WeaponPrice[weapon][wWeapon])
				return Msg(playerid, "Ilyen fegyver nem vehetõ a fegyverboltban");
			
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
				SendFormatMessage(playerid, COLOR_WHITE, "Vettél egy %s-t", GunName(weapon));
			}
			else
			{
				format(_tmpString, 128, "vett egy %s-t neki: %s", GunName(weapon), PlayerName(celpont)), Cselekves(playerid, _tmpString);
				SendFormatMessage(playerid, COLOR_WHITE, "Vettél egy %s-t neki: %s", GunName(weapon), PlayerName(celpont));
				SendFormatMessage(celpont, COLOR_WHITE, "%s vett neked egy %s-t", PlayerName(playerid), GunName(weapon));
			}
		}
		else if(iswep == 0)
		{
			new weapon = GetGunFromString(weaponstr);
			if(weapon < 1 || weapon > MAX_WEAPONS)
				return Msg(playerid, "Ilyen fegyver nem létezik");
			
			if(WeaponData[weapon][wTiltott] && !IsScripter(playerid))
				return Msg(playerid,"Ez egy tiltott fegyver, ezért ehhez nem vehetsz lõszert!");
				
			if(!WeaponPrice[weapon][wAmmo])
				return Msg(playerid, "Ilyen lõszer nem vehetõ a fegyverboltban");
			
			if(ammo < 1)
				return Msg(playerid, "Hibás lõszer mennyiség");
				
			new venni = max(0, min(ammo, WeaponMaxAmmo(weapon) - WeaponAmmo(celpont, weapon)));
			if(!venni)
				return Msg(playerid, "Nincs hely lõszernek");
			
			new koltseg = venni * WeaponPrice[weapon][wAmmo];
			if(!BankkartyaFizet(playerid, koltseg))
				return Msg(playerid, "Ezt nem tudod kifizetni");
				
			BizPenz(biz, koltseg);
			BizzInfo[biz][bProducts]--;
			BizUpdate(biz, BIZ_Products);
			
			WeaponGiveAmmo(celpont, weapon, venni);
			
			if(celpont == playerid)
			{
				format(_tmpString, 128, "vett némi %s lõszert", GunName(weapon)), Cselekves(playerid, _tmpString);
				SendFormatMessage(playerid, COLOR_WHITE, "Vettél %ddb %s lõszert", venni, GunName(weapon));
			}
			else
			{
				format(_tmpString, 128, "vett némi %s lõszert neki: %s", GunName(weapon), PlayerName(celpont)), Cselekves(playerid, _tmpString);
				SendFormatMessage(playerid, COLOR_WHITE, "Vettél %ddb %s lõszert neki: %s", venni, GunName(weapon), PlayerName(celpont));
				SendFormatMessage(celpont, COLOR_WHITE, "%s vett neked %ddb %s lõszert", PlayerName(playerid), venni, GunName(weapon));
			}
		}
		else
			Msg(playerid, "Hibás opció (fegyver / lõszer)");
	}
	else if(egyezik(func, "készít") || egyezik(func, "keszit"))
	{
		if(Szint(playerid) < WEAPON_MIN_LEVEL)
			return SendFormatMessage(playerid, COLOR_LIGHTRED, "Hiba: Fegyverhasználat nem engedélyezett a %d. szintig", WEAPON_MIN_LEVEL);
		
		if(PlayerInfo[playerid][pFegyverTiltIdo] > 1)
			return Msg(playerid, "El vagy tiltva a fegyverektõl");
		
		new iswep = !param2[0] ? -1 : (egyezik(param2, "fegyver") ? 1 : (egyezik(param2, "lõszer") || egyezik(param2, "loszer") ? 0 : -1));
		
		new weaponstr[32], ammo, celpont;
		if(!param2[0] || iswep == -1
			|| iswep == 1 && sscanf(params, "{s[32]s[32]}s[32]R(-1)", weaponstr, celpont)
			|| iswep == 0 && sscanf(params, "{s[32]s[32]}s[32]I(0)R(-1)", weaponstr, ammo, celpont)
		)
			return
				SendClientMessage(playerid, COLOR_WHITE, "===[ Árak ]==="),
				WeaponPrices(playerid, WEAPON_PRICES_MATS, COLOR_LIGHTBLUE),
				SendClientMessage(playerid, COLOR_YELLOW, "Használat: /fegyver készít fegyver [fegyvernév / ID] (játékos)"),
				SendClientMessage(playerid, COLOR_YELLOW, "Használat: /fegyver készít lõszer [fegyvernév / ID] [mennyiség] (játékos)")
			;
		
		if(celpont == INVALID_PLAYER_ID)
			return Msg(playerid, "Nincs ilyen játékos");
		else if(celpont == -1)
			celpont = playerid;
		else if(celpont != playerid && GetDistanceBetweenPlayers(playerid, celpont) > 5)
			return Msg(playerid, "Õ nincs a közeledben");
		
		if(iswep == 1)
		{
			new weapon = GetGunFromString(weaponstr);
			if(weapon < 1 || weapon > MAX_WEAPONS)
				return Msg(playerid, "Ilyen fegyver nem létezik");
			
			if(weapon == WEAPON_AK47)
			{
				if(PlayerInfo[playerid][pFem] < 2) return Msg(playerid, "Nincs elég fémed, minimum 2db!");
				
				PlayerInfo[playerid][pFem] -= 2;
				
				WeaponGiveWeapon(celpont, WEAPON_AK47, .maxweapon = 0);
				
				if(celpont == playerid)
				{
					format(_tmpString, 128, "készített egy %s-t", GunName(weapon)), Cselekves(playerid, _tmpString);
					SendFormatMessage(playerid, COLOR_WHITE, "Készítettél egy %s-t", GunName(weapon));
				}
				else
				{
					format(_tmpString, 128, "készített egy %s-t neki: %s", GunName(weapon), PlayerName(celpont)), Cselekves(playerid, _tmpString);
					SendFormatMessage(playerid, COLOR_WHITE, "Készítettél egy %s-t neki: %s", GunName(weapon), PlayerName(celpont));
					SendFormatMessage(celpont, COLOR_WHITE, "%s készített neked egy %s-t", PlayerName(playerid), GunName(weapon));
				}
				
				return 1;
				
			}
			
			if(!WeaponPrice[weapon][wWeaponMat])
				return Msg(playerid, "Ilyen fegyver nem készíthetõ");
			
			if(WeaponCanHoldWeapon(celpont, weapon, 0) < 0)
				return Msg(playerid, "Ilyen fegyvert nem tudsz készíteni");
			
			if(PlayerInfo[playerid][pMats] < WeaponPrice[weapon][wWeaponMat])
				return Msg(playerid, "Nincs ennyi materialod");
			
			PlayerInfo[playerid][pMats] -= WeaponPrice[weapon][wWeaponMat];
			
			WeaponGiveWeapon(celpont, weapon, .maxweapon = 0);
			
			if(celpont == playerid)
			{
				format(_tmpString, 128, "készített egy %s-t", GunName(weapon)), Cselekves(playerid, _tmpString);
				SendFormatMessage(playerid, COLOR_WHITE, "Készítettél egy %s-t", GunName(weapon));
			}
			else
			{
				format(_tmpString, 128, "készített egy %s-t neki: %s", GunName(weapon), PlayerName(celpont)), Cselekves(playerid, _tmpString);
				SendFormatMessage(playerid, COLOR_WHITE, "Készítettél egy %s-t neki: %s", GunName(weapon), PlayerName(celpont));
				SendFormatMessage(celpont, COLOR_WHITE, "%s készített neked egy %s-t", PlayerName(playerid), GunName(weapon));
			}
		}
		else if(iswep == 0)
		{
			new weapon = GetGunFromString(weaponstr);
			if(weapon < 1 || weapon > MAX_WEAPONS)
				return Msg(playerid, "Ilyen fegyver nem létezik");
			
			if(!WeaponPrice[weapon][wAmmoMat])
				return Msg(playerid, "Ilyen lõszer nem készíthetõ");
			
			if(ammo < 1)
				return Msg(playerid, "Hibás lõszer mennyiség");
				
			new venni = max(0, min(ammo, WeaponMaxAmmo(weapon) - WeaponAmmo(celpont, weapon)));
			if(!venni)
				return Msg(playerid, "Nincs hely lõszernek");
			
			new koltseg = venni * WeaponPrice[weapon][wAmmoMat];
			if(PlayerInfo[playerid][pMats] < koltseg)
				return Msg(playerid, "Nincs ennyi materialod");
				
			PlayerInfo[playerid][pMats] -= koltseg;
			
			WeaponGiveAmmo(celpont, weapon, venni);
			
			if(celpont == playerid)
			{
				format(_tmpString, 128, "készített némi %s lõszert", GunName(weapon)), Cselekves(playerid, _tmpString);
				SendFormatMessage(playerid, COLOR_WHITE, "Készítettél %ddb %s lõszert", venni, GunName(weapon));
			}
			else
			{
				format(_tmpString, 128, "készített némi %s lõszert neki: %s", GunName(weapon), PlayerName(celpont)), Cselekves(playerid, _tmpString);
				SendFormatMessage(playerid, COLOR_WHITE, "Készítettél %ddb %s lõszert neki: %s", venni, GunName(weapon), PlayerName(celpont));
				SendFormatMessage(celpont, COLOR_WHITE, "%s készített neked %ddb %s lõszert", PlayerName(playerid), venni, GunName(weapon));
			}
		}
		else
			Msg(playerid, "Hibás opció (fegyver / lõszer)");
	}
	else if(egyezik(func, "átad") || egyezik(func, "atad"))
	{
		if(Paintballozik[playerid])
			return Msg(playerid, "Paintball alatt nem lehetséges");
			
		new celpont, weaponstr[32], ammo;
		if(!param2[0] || sscanf(params, "{s[32] s[32] }rs[32] I(0)", celpont, weaponstr, ammo))
			return
				SendClientMessage(playerid, COLOR_YELLOW, "Használat: /f átad fegyver [játékos név / ID] [fegyvernév / ID]"),
				SendClientMessage(playerid, COLOR_YELLOW, "Használat: /f átad lõszer [játékos név / ID] [fegyvernév / ID] [mennyiség]")
			;
		
		if(celpont == INVALID_PLAYER_ID)
			return Msg(playerid, "Nem létezõ játékos");
		
		if(GetDistanceBetweenPlayers(playerid, celpont) > 2)
			return Msg(playerid, "Õ nincs a közeledben");
		
		if(PlayerState[playerid] != PLAYER_STATE_ONFOOT || PlayerState[celpont] != PLAYER_STATE_ONFOOT)
			return Msg(playerid, "Kocsiban nem lehet");
		
		if(PlayerInfo[playerid][pFegyverTiltIdo] > 0 || PlayerInfo[celpont][pFegyverTiltIdo] > 0 )
			return Msg(playerid, "Egyikõtök el van tiltva a fegyvertõl!");
		
		new weapon = GetGunFromString(weaponstr);
		if(weapon < 1 || weapon > MAX_WEAPONS)
			return Msg(playerid, "Ilyen fegyver nem létezik");
			
		if((Szint(playerid) < WEAPON_MIN_LEVEL && !UtosFegyver(weapon)) || (Szint(celpont) < WEAPON_MIN_LEVEL && !UtosFegyver(weapon)))
			return Msg(playerid, "Túl kicsi a szinted vagy az õ szintje a fegyverhasználathoz");
		
		if(egyezik(param2, "fegyver"))
		{
			if((weapon == WEAPON_CHAINSAW || weapon == WEAPON_FIREEXTINGUISHER) && !LMT(celpont, FRAKCIO_TUZOLTO))
				return Msg(playerid, "Poroltó és láncfûrész nem adható át, csak tûzoltónak!");
			
			if(WeaponHaveWeapon(playerid, weapon) < 0)
				return Msg(playerid, "Nincs ilyen fegyvered");
			
			if(WeaponCanHoldWeapon(celpont, weapon, 0) < 0)
				return Msg(playerid, "Nincs hely a fegyvernek");
			
			WeaponTakeWeapon(playerid, weapon);
			WeaponGiveWeapon(celpont, weapon, 0);
			SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Átadtál neki egy %s-t", GunName(weapon));
			SendFormatMessage(celpont, COLOR_LIGHTBLUE, "Átadtak neked egy %s-t", GunName(weapon));
			
			OnePlayAnim(playerid, "GANGS", "shake_cara", 4.0, 0, 0, 0, 0, 0);
			OnePlayAnim(celpont, "GANGS", "shake_cara", 4.0, 0, 0, 0, 0, 0);
			
			if(!PlayerInfo[playerid][pMember])
				if(!PlayerInfo[celpont][pMember])
					format(_tmpString, 128, "[Átad][Civil]%s átadott neki: [Civil]%s, egy %s-t", PlayerName(playerid), PlayerName(celpont), GunName(weapon)), Log("Fegyver", _tmpString);
				else
					format(_tmpString, 128, "[Átad][Civil]%s átadott neki: [%s]%s, egy %s-t", PlayerName(playerid), Szervezetneve[ PlayerInfo[celpont][pMember] - 1 ], PlayerName(celpont), GunName(weapon)), Log("Fegyver", _tmpString);
			else
				if(!PlayerInfo[celpont][pMember])
					format(_tmpString, 128, "[Átad][%s]%s átadott neki: [Civil]%s, egy %s-t", Szervezetneve[ PlayerInfo[playerid][pMember] - 1 ], PlayerName(playerid), PlayerName(celpont), GunName(weapon)), Log("Fegyver", _tmpString);
				else
					format(_tmpString, 128, "[Átad][%s]%s átadott neki: [%s]%s, egy %s-t", Szervezetneve[ PlayerInfo[playerid][pMember] - 1 ], PlayerName(playerid), Szervezetneve[ PlayerInfo[celpont][pMember] - 1 ], PlayerName(celpont), GunName(weapon)), Log("Fegyver", _tmpString);
		}
		else if(egyezik(param2, "lõszer") || egyezik(param2, "loszer"))
		{
			if(ammo < 1)
				return Msg(playerid, "Hibás lõszer mennyiség");
			
			new atadni = max(0, min(ammo, min(WeaponAmmo(playerid, weapon), WeaponMaxAmmo(weapon) - WeaponAmmo(celpont, weapon))));
			if(!atadni)
				return Msg(playerid, "Nincs hely nála");
			
			if(WeaponAmmo(playerid, weapon) < 0)
				return Msg(playerid, "Nincs ilyen fegyvered");
			
			if(WeaponCanHoldWeapon(celpont, weapon, 0) < 0)
				return Msg(playerid, "Nincs hely a fegyvernek");
			
			WeaponGiveAmmo(playerid, weapon, -atadni);
			WeaponGiveAmmo(celpont, weapon, atadni);
			SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Átadtál neki egy %ddb %s lõszert", atadni, GunName(weapon));
			SendFormatMessage(celpont, COLOR_LIGHTBLUE, "%s átadott neked %ddb %s lõszert", PlayerName(playerid), atadni, GunName(weapon));
			
			OnePlayAnim(playerid, "GANGS", "shake_cara", 4.0, 0, 0, 0, 0, 0);
			OnePlayAnim(celpont, "GANGS", "shake_cara", 4.0, 0, 0, 0, 0, 0);
			
			if(!PlayerInfo[playerid][pMember])
				if(!PlayerInfo[celpont][pMember])
					format(_tmpString, 128, "[Átad][Civil]%s átadott neki: [Civil]%s, %ddb %s lõszert", PlayerName(playerid), PlayerName(celpont), atadni, GunName(weapon)), Log("Fegyver", _tmpString);
				else
					format(_tmpString, 128, "[Átad][Civil]%s átadott neki: [%s]%s, %ddb %s lõszert", PlayerName(playerid), Szervezetneve[ PlayerInfo[celpont][pMember] - 1 ], PlayerName(celpont), atadni, GunName(weapon)), Log("Fegyver", _tmpString);
			else
				if(!PlayerInfo[celpont][pMember])
					format(_tmpString, 128, "[Átad][%s]%s átadott neki: [Civil]%s, %ddb %s lõszert", Szervezetneve[ PlayerInfo[playerid][pMember] - 1 ], PlayerName(playerid), PlayerName(celpont), atadni, GunName(weapon)), Log("Fegyver", _tmpString);
				else
					format(_tmpString, 128, "[Átad][%s]%s átadott neki: [%s]%s, %ddb %s lõszert", Szervezetneve[ PlayerInfo[playerid][pMember] - 1 ], PlayerName(playerid), Szervezetneve[ PlayerInfo[celpont][pMember] - 1 ], PlayerName(celpont), atadni, GunName(weapon)), Log("Fegyver", _tmpString);
		}
	}
	
	return 1;
}

CMD:ammo(playerid, params[])
{
	if(!Admin(playerid, 5)) return 1;

	if(params[0] == EOS)
		return
			SendClientMessage(playerid, COLOR_LIGHTRED, "Használat: /ammo [Játékos] [FegyverID] [Lõszer] | /ammo töröl [Játékos]"),
			SendClientMessage(playerid, COLOR_GRAD4, "3(Club) 4(knife) 5(bat) 6(Shovel) 7(Cue) 8(Katana) 10-13(Dildo) 14(Flowers) 16(Grenades) 18(Molotovs) 22(Pistol) 23(SPistol)"),
			SendClientMessage(playerid, COLOR_GRAD3, "24(Eagle) 25(shotgun) 29(MP5) 30(AK47) 31(M4) 33(Rifle) 34(Sniper) 37(Flamethrower) 41(spray) 42(exting) 43(Camera) 46(Parachute)")
		;
	
	new param[10], player;
	if(!sscanf(params, "s[10]r", param, player))
	{
		if(egyezik(param, "töröl"))
		{
			if(player == INVALID_PLAYER_ID)
				return Msg(playerid, "Nem létezõ játékos");

			WeaponResetAmmos(player);
			ABroadCastFormat(COLOR_LIGHTRED, PlayerInfo[playerid][pAdmin], "<< %s törölte %s zsebében lévõ lõszereit (fegyvert nem) >>", AdminName(playerid), PlayerName(player));
			
			return 1;
		}
	}
	
	new weaponstr[32], ammo;
	if(sscanf(params, "rs[32] i", player, weaponstr, ammo))
		return
			SendClientMessage(playerid, COLOR_LIGHTRED, "Használat: /ammo [Játékos] [FegyverID] [Lõszer] | /ammo töröl [Játékos]"),
			SendClientMessage(playerid, COLOR_GRAD4, "3(Club) 4(knife) 5(bat) 6(Shovel) 7(Cue) 8(Katana) 10-13(Dildo) 14(Flowers) 16(Grenades) 18(Molotovs) 22(Pistol) 23(SPistol)"),
			SendClientMessage(playerid, COLOR_GRAD3, "24(Eagle) 25(shotgun) 29(MP5) 30(AK47) 31(M4) 33(Rifle) 34(Sniper) 37(Flamethrower) 41(spray) 42(exting) 43(Camera) 46(Parachute)")
		;
			
	
	if(player == INVALID_PLAYER_ID)
		return Msg(playerid, "Nem létezõ játékos");
	
	new weapon = GetGunFromString(weaponstr);
	if(weapon < 1 || weapon > MAX_WEAPONS)
		return Msg(playerid, "Hibás fegyver! 1-47");
		
	if(Szint(player) < WEAPON_MIN_LEVEL && !UtosFegyver(weapon))
		return SendFormatMessage(playerid, COLOR_LIGHTRED, "Fegyver csak a %d. szinttõl engedélyezett, a játékos szintje %d", WEAPON_MIN_LEVEL, Szint(player));
	
	if(!WeaponData[weapon][wAmmo])
		return Msg(playerid, "Ehhez a fegyverhez nem lehet lõszert adni");
	
	if(ammo < 1 || ammo > WeaponData[weapon][wAmmo])
		return SendFormatMessage(playerid, COLOR_LIGHTRED, "A lõszer minimum 1db, maximum %ddb lehet", WeaponData[weapon][wAmmo]);

	new oldammo = PlayerWeapons[player][pAmmo][weapon];
	if(!WeaponGiveAmmo(player, weapon, ammo))
		return Msg(playerid, "Ehhez a fegyverhez nem lehet lõszert adni");
	
	ABroadCastFormat(COLOR_LIGHTRED, PlayerInfo[playerid][pAdmin], "<< Admin %s %ddb %s lõszert adott neki: %s - régi: %ddb, új: %ddb >>", AdminName(playerid), ammo, GetGunName(weapon), PlayerName(player), oldammo, WeaponAmmo(player, weapon));
	tformat(128, "[/ammo]%s adott %ddb %s lõszert neki: %s", Nev(playerid), ammo, GunName(weapon), Nev(player));
	return 1;
}

CMD:gun(playerid, params[])
{
	if(!Admin(playerid, 5)) return 1;

	if(params[0] == EOS)
		return
			SendClientMessage(playerid, COLOR_LIGHTRED, "Használat: /gun [Játékos] [FegyverID] | /gun töröl [Játékos]"),
			SendClientMessage(playerid, COLOR_GRAD4, "3(Club) 4(knife) 5(bat) 6(Shovel) 7(Cue) 8(Katana) 10-13(Dildo) 14(Flowers) 16(Grenades) 18(Molotovs) 22(Pistol) 23(SPistol)"),
			SendClientMessage(playerid, COLOR_GRAD3, "24(Eagle) 25(shotgun) 29(MP5) 30(AK47) 31(M4) 33(Rifle) 34(Sniper) 37(Flamethrower) 41(spray) 42(exting) 43(Camera) 46(Parachute)")
		;
	
	new param[10], player;
	if(!sscanf(params, "s[10]r", param, player))
	{
		if(egyezik(param, "töröl"))
		{
			if(player == INVALID_PLAYER_ID)
				return Msg(playerid, "Nem létezõ játékos");

			WeaponResetWeapons(player);
			ABroadCastFormat(COLOR_LIGHTRED, PlayerInfo[playerid][pAdmin], "<< %s törölte %s zsebében lévõ fegyvereit (lõszert nem) >>", AdminName(playerid), PlayerName(player));
			
			return 1;
		}
	}
	
	new weaponstr[32];
	if(sscanf(params, "rs[32] ", player, weaponstr))
		return
			SendClientMessage(playerid, COLOR_LIGHTRED, "Használat: /gun [Játékos] [Fegyvernév/ID] | /gun töröl [Játékos]"),
			SendClientMessage(playerid, COLOR_GRAD4, "3(Club) 4(knife) 5(bat) 6(Shovel) 7(Cue) 8(Katana) 10-13(Dildo) 14(Flowers) 16(Grenades) 18(Molotovs) 22(Pistol) 23(SPistol)"),
			SendClientMessage(playerid, COLOR_GRAD3, "24(Eagle) 25(shotgun) 29(MP5) 30(AK47) 31(M4) 33(Rifle) 34(Sniper) 37(Flamethrower) 41(spray) 42(exting) 43(Camera) 46(Parachute)")
		;
			
	
	if(player == INVALID_PLAYER_ID)
		return Msg(playerid, "Nem létezõ játékos");
	
	new weapon = GetGunFromString(weaponstr);
	if(weapon < 1 || weapon > MAX_WEAPONS)
		return Msg(playerid, "Hibás fegyver! 1-47");
		
	if(Szint(player) < WEAPON_MIN_LEVEL && !UtosFegyver(weapon))
		return SendFormatMessage(playerid, COLOR_LIGHTRED, "Fegyver csak a %d. szinttol engedélyezett, a játékos szintje %d", WEAPON_MIN_LEVEL, Szint(player));

	new slot = WeaponGiveWeapon(player, weapon, _, 0);
	
	if(slot == WEAPONS_CAN_HOLD_WEAPON_FULL)
		return Msg(playerid, "Nála már nincs több hely!");
	else if(slot == WEAPONS_CAN_HOLD_WEAPON_MANY)
		return Msg(playerid, "Ebbõl a fegyverbõl nem adhatsz neki");
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
		return SendClientMessage(playerid, COLOR_WHITE, "Használata: /térfigyelõ [jelzések / jelzés / térkép / utolsópozíció]");
	
	if(egyezik(sub, "jelzes") || egyezik(sub, "jelzés"))
	{
		new jelzes;
		if(sscanf(subparams, "i", jelzes))
		{
			SendClientMessage(playerid, COLOR_LIGHTRED, "Használata: /térfigyelo jelzés [jelzés szint]");
			SendClientMessage(playerid, COLOR_WHITE, "Jelzések: 0 = kikapcsolva, 1 = fegyverviselés, 2 = célzás + fegyverviselés, stb.");
			SendClientMessage(playerid, COLOR_WHITE, "Jelzések megtekinthetõek a wikipédián: wiki.classrpg.net/Térfigyelõ");
			return 1;
		}
		
		if(jelzes < 0 || jelzes > PLAYER_MARKER_MKILL)
			return SendClientMessage(playerid, COLOR_LIGHTRED, "Jelzés: Minimum 0, maximum 5");
			
		PlayerInfo[playerid][pJelzes] = jelzes;
		
		switch(jelzes)
		{
			case PLAYER_MARKER_ENGEDELY: Msg(playerid, "Jelzések: engedély, fegyverviselés, fenyegetés, testisértés, emberölés, többszörös emberölés");
			case PLAYER_MARKER_WEAPONHOLD: Msg(playerid, "Jelzések: fegyverviselés, fenyegetés, testisértés, emberölés, többszörös emberölés");
			case PLAYER_MARKER_TARGET: Msg(playerid, "Jelzések: fenyegetés, testisértés, emberölés, többszörös emberölés");
			case PLAYER_MARKER_SHOOT: Msg(playerid, "Jelzések: testisértés, emberölés, többszörös emberölés");
			case PLAYER_MARKER_KILL: Msg(playerid, "Jelzések: emberölés, többszörös emberölés");
			case PLAYER_MARKER_MKILL: Msg(playerid, "Jelzések: többszörös emberölés");
			default: Msg(playerid, "Jelzés kikapcsolva - most már nem fogja chatben írni az új bûnözõket");
		}
	}
	elseif(egyezik(sub, "terkep") || egyezik(sub, "térkép"))
	{
		new jelzes;
		if(sscanf(subparams, "i", jelzes))
		{
			SendClientMessage(playerid, COLOR_LIGHTRED, "Használata: /térfigyelõ térkép [jelzés szint]");
			SendClientMessage(playerid, COLOR_WHITE, "Jelzések: 0 = kikapcsolva, 1 = fegyverviselés, 2 = célzás + fegyverviselés, stb.");
			SendClientMessage(playerid, COLOR_WHITE, "Jelzések megtekinthetoek a wikipédián: wiki.classrpg.net/Térfigyelõ");
			return 1;
		}
		
		if(jelzes < 0 || jelzes > PLAYER_MARKER_MKILL)
			return SendClientMessage(playerid, COLOR_LIGHTRED, "Jelzés: Minimum 0, maximum 5");
			
		PlayerInfo[playerid][pJelzesTerkep] = jelzes;
		
		switch(jelzes)
		{
			case PLAYER_MARKER_ENGEDELY: Msg(playerid, "Térkép jelzések: engedély, fegyverviselés, fenyegetés, testisértés, emberölés, többszörös emberölés");
			case PLAYER_MARKER_WEAPONHOLD: Msg(playerid, "Térkép jelzések: fegyverviselés, fenyegetés, testisértés, emberölés, többszörös emberölés");
			case PLAYER_MARKER_TARGET: Msg(playerid, "Térkép jelzések: fenyegetés, testisértés, emberölés, többszörös emberölés");
			case PLAYER_MARKER_SHOOT: Msg(playerid, "Térkép jelzések: testisértés, emberölés, többszörös emberölés");
			case PLAYER_MARKER_KILL: Msg(playerid, "Térkép jelzések: emberölés, többszörös emberölés");
			case PLAYER_MARKER_MKILL: Msg(playerid, "Térkép jelzések: többszörös emberölés");
			default: Msg(playerid, "Jelzés kikapcsolva - most már nem fogja chatben írni az új bûnözõket");
		}
		
		MarkerAction(playerid, PLAYER_MARKER_ON_REFRESH);
	}
	elseif(egyezik(sub, "utolsopozicio") || egyezik(sub, "utolsópozíció"))
	{
		new bid;
		if(sscanf(subparams, "i", bid))
			return SendClientMessage(playerid, COLOR_LIGHTRED, "Használata: /térfigyelo utolsópozíció [egyedi ID (pl.: 1234)]");
		
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
			return Msg(playerid, "Utolsó pozíció nem ismert");
			
		SetPlayerCheckpoint(playerid, ArrExt(PlayerMarker[player][mLastPos]), 3.0);
		SendFormatMessage(playerid, COLOR_LIGHTRED, "Térfigyelõ: %d jelezve a térképen", PlayerInfo[player][pBID]);
	}
	elseif(egyezik(sub, "jelzesek") || egyezik(sub, "jelzések"))
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
						SendFormatMessage(playerid, PLAYER_MARKER_COLOR_ENGEDELY, "[Térfigyelõ: engedély] #%d - %dmp", PlayerInfo[p][pBID], PlayerMarker[p][mTime]);
					case PLAYER_MARKER_WEAPONHOLD:
						SendFormatMessage(playerid, PLAYER_MARKER_COLOR_WEAPONHOLD, "[Térfigyelõ: fegyverviselés] #%d - %dmp", PlayerInfo[p][pBID], PlayerMarker[p][mTime]);
					case PLAYER_MARKER_TARGET:
						SendFormatMessage(playerid, PLAYER_MARKER_COLOR_TARGET, "[Térfigyelõ: célzás] #%d - %dmp", PlayerInfo[p][pBID], PlayerMarker[p][mTime]);
					case PLAYER_MARKER_SHOOT:
						SendFormatMessage(playerid, PLAYER_MARKER_COLOR_SHOOT, "[Térfigyelõ: testisértés] #%d - %dmp", PlayerInfo[p][pBID], PlayerMarker[p][mTime]);
					case PLAYER_MARKER_KILL:
						SendFormatMessage(playerid, PLAYER_MARKER_COLOR_KILL, "[Térfigyelõ: emberölés] #%d - %dmp", PlayerInfo[p][pBID], PlayerMarker[p][mTime]);
					case PLAYER_MARKER_MKILL:
						SendFormatMessage(playerid, PLAYER_MARKER_COLOR_MKILL, "[Térfigyelõ: többszörös emberölés] #%d - %dmp", PlayerInfo[p][pBID], PlayerMarker[p][mTime]);
				}
				
				found = true;
			}
		}
		
		if(!found)
			Msg(playerid, "Jelenleg nincs jelzés senkire");
	}
	
	return 1;
}

ALIAS(ater8let):aterulet;
CMD:aterulet(playerid, params[])
{
	if(!Admin(playerid, 1337) && !IsScripter(playerid)) return 1;
	new sub[32], subparams[64], tid, fid;
	if(sscanf(params, "s[32]S()[64]", sub, subparams))
		return SendClientMessage(playerid, COLOR_WHITE, "Használata: /aterület [foglalható/várakozás/tulaj]");
	if(egyezik(sub, "foglalható") || egyezik(sub, "foglalhato"))
	{
		if(sscanf(subparams, "i", tid))
			return SendClientMessage(playerid, COLOR_LIGHTRED, "Használata: /aterület foglalható [Terület ID]");
		
		if(tid < 0 || tid > MAXTERULET)
			return SendClientMessage(playerid, COLOR_LIGHTRED, "Nincs ilyen Terület ID!");
		
		TeruletInfo[tid][tFoglalva] = 0;
		SendFormatMessage(playerid, COLOR_GREEN, "%s[%d] terület várakozási ideje nullázva!", TeruletInfo[tid][tNev], tid);
		TeruletUpdate(tid, TERULET_Foglalva);
		TeruletFrissites();
	}
	elseif(egyezik(sub, "várakozás") || egyezik(sub, "varakozas"))
	{
		if(sscanf(subparams, "i", fid))
			return SendClientMessage(playerid, COLOR_LIGHTRED, "Használata: /aterület várakozás [Frakció ID]");
			
		if(fid != 3 && fid != 5 && fid != 6 && fid != 8 && fid != 11 && fid != 17 && fid != 21)
			return SendClientMessage(playerid, COLOR_LIGHTRED, "Illegális FrakcióID-k: 3(Sons of Anarchy), 5(LCN), 6(Yakuza), 8(Aztec), 11(Vagos), 17(GSF), 21(Turkey)");
		
		FrakcioInfo[fid][fUtolsoTamadas]= 0;
		SendFormatMessage(playerid, COLOR_GREEN, "Engedélyezted a %s[%d] frakciónak a támadást!", Szervezetneve[fid-1][1], fid);
	}
	elseif(egyezik(sub, "tulaj"))
	{
		if(sscanf(subparams, "ii", tid, fid))
			return SendClientMessage(playerid, COLOR_WHITE, "Használata: /aterület tulaj [Terület ID] [Frakció ID]");
			
		if(tid < 0 || tid > MAXTERULET)
			return SendClientMessage(playerid, COLOR_LIGHTRED, "Nincs ilyen Terület ID!");
			
		if(fid != 3 && fid != 5 && fid != 6 && fid != 8 && fid != 11 && fid != 17 && fid != 21)
			return SendClientMessage(playerid, COLOR_LIGHTRED, "Illegális FrakcióID-k: 3(Sons of Anarchy), 5(LCN), 6(Yakuza), 8(Aztec), 11(Vagos), 17(GSF), 21(Turkey)");
		
		SendFormatMessage(playerid, COLOR_GREEN, "Terület %s[%d] hozzárendelve a(z) %s[%d] Frakcióhoz!", TeruletInfo[tid][tNev], tid, Szervezetneve[fid-1][1], fid);
		TeruletInfo[tid][tTulaj] = fid;
		TeruletUpdate(tid, TERULET_Tulaj);
		TeruletFrissites();
	}
	return 1;
}

CMD:askill(playerid, params[]) // Franklin kérése
{
	if(!Admin(playerid, 1337) && !IsScripter(playerid)) return 1;
	new sub[32], spms[64], amount, skill;
	if(sscanf(params, "s[32]S()[64]", sub, spms))
		return SendClientMessage(playerid, COLOR_LIGHTRED, "Használata: /askill [Pisztoly / Silenced / Deagle / Combat / Shotgun / Mp5 / AK47 / M4 / Sniper] [Mennyit]");
	
	if(egyezik(sub, "pisztoly"))
	{
		skill = 0;
		if(sscanf(spms, "i", amount))
			return SendClientMessage(playerid, COLOR_LIGHTRED, "Használata: /askill pisztoly [mennyiség]");
		
		if(amount < 1 || amount > 1600)
			return SendClientMessage(playerid, COLOR_RED, "1-1600 válassz mennyiséget!");
			
		new price = amount * 3125;			
		if(!BankkartyaFizet(playerid, price)){ SendFormatMessage(playerid, COLOR_LIGHTRED, "%d forintba kerül, neked nincs ennyid!", price); return 1; }
			
		SendFormatMessage(playerid, COLOR_GREEN, "Vásároltál %d mennyiségû skillt magadnak a következõ fegyverre: %s", amount, sub);
		PlayerInfo[playerid][pFegyverSkillek][skill] += amount;
		
		if(PlayerInfo[playerid][pFegyverSkillek][skill] >= MAX_SKILLFEGYVER)
			PlayerInfo[playerid][pFegyverSkillek][skill] = MAX_SKILLFEGYVER;
		
		FegyverSkillFrissites(playerid);
	}
	elseif(egyezik(sub, "silenced"))
	{
		skill = 1;
		if(sscanf(spms, "i", amount))
			return SendClientMessage(playerid, COLOR_LIGHTRED, "Használata: /askill silenced [mennyiség]");
		
		if(amount < 1 || amount > 1600)
			return SendClientMessage(playerid, COLOR_RED, "1-1600 válassz mennyiséget!");
		
		new price = amount * 3125;			
		if(!BankkartyaFizet(playerid, price)){ SendFormatMessage(playerid, COLOR_LIGHTRED, "%d forintba kerül, neked nincs ennyid!", price); return 1; }
			
		SendFormatMessage(playerid, COLOR_GREEN, "Vásároltál %d mennyiségû skillt magadnak a következõ fegyverre: %s", amount, sub);
		PlayerInfo[playerid][pFegyverSkillek][skill] += amount;
		
		if(PlayerInfo[playerid][pFegyverSkillek][skill] >= MAX_SKILLFEGYVER)
			PlayerInfo[playerid][pFegyverSkillek][skill] = MAX_SKILLFEGYVER;
		
		FegyverSkillFrissites(playerid);
	}
	elseif(egyezik(sub, "deagle"))
	{
		skill = 2;
		if(sscanf(spms, "i", amount))
			return SendClientMessage(playerid, COLOR_LIGHTRED, "Használata: /askill deagle [mennyiség]");
		
		if(amount < 1 || amount > 1600)
			return SendClientMessage(playerid, COLOR_RED, "1-1600 válassz mennyiséget!");
		
		new price = amount * 3125;			
		if(!BankkartyaFizet(playerid, price)){ SendFormatMessage(playerid, COLOR_LIGHTRED, "%d forintba kerül, neked nincs ennyid!", price); return 1; }
			
		SendFormatMessage(playerid, COLOR_GREEN, "Vásároltál %d mennyiségû skillt magadnak a következõ fegyverre: %s", amount, sub);
		PlayerInfo[playerid][pFegyverSkillek][skill] += amount;
		
		if(PlayerInfo[playerid][pFegyverSkillek][skill] >= MAX_SKILLFEGYVER)
			PlayerInfo[playerid][pFegyverSkillek][skill] = MAX_SKILLFEGYVER;
		
		FegyverSkillFrissites(playerid);
	}
	elseif(egyezik(sub, "combat"))
	{
		skill = 5;
		if(sscanf(spms, "i", amount))
			return SendClientMessage(playerid, COLOR_LIGHTRED, "Használata: /askill combat [mennyiség]");
		
		if(amount < 1 || amount > 1600)
			return SendClientMessage(playerid, COLOR_RED, "1-1600 válassz mennyiséget!");
		
		new price = amount * 3125;			
		if(!BankkartyaFizet(playerid, price)){ SendFormatMessage(playerid, COLOR_LIGHTRED, "%d forintba kerül, neked nincs ennyid!", price); return 1; }
		
		SendFormatMessage(playerid, COLOR_GREEN, "Vásároltál %d mennyiségû skillt magadnak a következõ fegyverre: %s", amount, sub);
		PlayerInfo[playerid][pFegyverSkillek][skill] += amount;
		
		if(PlayerInfo[playerid][pFegyverSkillek][skill] >= MAX_SKILLFEGYVER)
			PlayerInfo[playerid][pFegyverSkillek][skill] = MAX_SKILLFEGYVER;
		
		FegyverSkillFrissites(playerid);
	}
	elseif(egyezik(sub, "shotgun"))
	{
		skill = 3;
		if(sscanf(spms, "i", amount))
			return SendClientMessage(playerid, COLOR_LIGHTRED, "Használata: /askill shotgun [mennyiség]");
		
		if(amount < 1 || amount > 1600)
			return SendClientMessage(playerid, COLOR_RED, "1-1600 válassz mennyiséget!");
		
		new price = amount * 3125;			
		if(!BankkartyaFizet(playerid, price)){ SendFormatMessage(playerid, COLOR_LIGHTRED, "%d forintba kerül, neked nincs ennyid!", price); return 1; }
			
		SendFormatMessage(playerid, COLOR_GREEN, "Vásároltál %d mennyiségû skillt magadnak a következõ fegyverre: %s", amount, sub);
		PlayerInfo[playerid][pFegyverSkillek][skill] += amount;
		
		if(PlayerInfo[playerid][pFegyverSkillek][skill] >= MAX_SKILLFEGYVER)
			PlayerInfo[playerid][pFegyverSkillek][skill] = MAX_SKILLFEGYVER;
			
		FegyverSkillFrissites(playerid);
	}
	elseif(egyezik(sub, "mp5"))
	{
		skill = 7;
		if(sscanf(spms, "i", amount))
			return SendClientMessage(playerid, COLOR_LIGHTRED, "Használata: /askill mp5 [mennyiség]");
		
		if(amount < 1 || amount > 1600)
			return SendClientMessage(playerid, COLOR_RED, "1-1600 válassz mennyiséget!");
		
		new price = amount * 3125;			
		if(!BankkartyaFizet(playerid, price)){ SendFormatMessage(playerid, COLOR_LIGHTRED, "%d forintba kerül, neked nincs ennyid!", price); return 1; }		
			
		SendFormatMessage(playerid, COLOR_GREEN, "Vásároltál %d mennyiségû skillt magadnak a következõ fegyverre: %s", amount, sub);
		PlayerInfo[playerid][pFegyverSkillek][skill] += amount;
		if(PlayerInfo[playerid][pFegyverSkillek][skill] >= MAX_SKILLFEGYVER)
			PlayerInfo[playerid][pFegyverSkillek][skill] = MAX_SKILLFEGYVER;
			
		FegyverSkillFrissites(playerid);
	}
	elseif(egyezik(sub, "ak47"))
	{
		skill = 8;
		if(sscanf(spms, "i", amount))
			return SendClientMessage(playerid, COLOR_LIGHTRED, "Használata: /askill ak47 [mennyiség]");
		
		if(amount < 1 || amount > 1600)
			return SendClientMessage(playerid, COLOR_RED, "1-1600 válassz mennyiséget!");
		
		new price = amount * 3125;			
		if(!BankkartyaFizet(playerid, price)){ SendFormatMessage(playerid, COLOR_LIGHTRED, "%d forintba kerül, neked nincs ennyid!", price); return 1; }		
			
		SendFormatMessage(playerid, COLOR_GREEN, "Vásároltál %d mennyiségû skillt magadnak a következõ fegyverre: %s", amount, sub);
		PlayerInfo[playerid][pFegyverSkillek][skill] += amount;
		
		if(PlayerInfo[playerid][pFegyverSkillek][skill] >= MAX_SKILLFEGYVER)
			PlayerInfo[playerid][pFegyverSkillek][skill] = MAX_SKILLFEGYVER;
		
		FegyverSkillFrissites(playerid);
	}
	elseif(egyezik(sub, "m4"))
	{
		skill = 9;
		if(sscanf(spms, "i", amount))
			return SendClientMessage(playerid, COLOR_LIGHTRED, "Használata: /askill m4 [mennyiség]");
		
		if(amount < 1 || amount > 1600)
			return SendClientMessage(playerid, COLOR_RED, "1-1600 válassz mennyiséget!");
		
		new price = amount * 3125;			
		if(!BankkartyaFizet(playerid, price)){ SendFormatMessage(playerid, COLOR_LIGHTRED, "%d forintba kerül, neked nincs ennyid!", price); return 1; }
			
		SendFormatMessage(playerid, COLOR_GREEN, "Vásároltál %d mennyiségû skillt magadnak a következõ fegyverre: %s", amount, sub);
		PlayerInfo[playerid][pFegyverSkillek][skill] += amount;
		
		if(PlayerInfo[playerid][pFegyverSkillek][skill] >= MAX_SKILLFEGYVER)
			PlayerInfo[playerid][pFegyverSkillek][skill] = MAX_SKILLFEGYVER;
		
		FegyverSkillFrissites(playerid);
	}
	elseif(egyezik(sub, "sniper"))
	{
		skill = 10;
		if(sscanf(spms, "i", amount))
			return SendClientMessage(playerid, COLOR_LIGHTRED, "Használata: /askill sniper [mennyiség]");
		
		if(amount < 1 || amount > 1600)
			return SendClientMessage(playerid, COLOR_RED, "1-1600 válassz mennyiséget!");
		
		new price = amount * 3125;			
		if(!BankkartyaFizet(playerid, price)){ SendFormatMessage(playerid, COLOR_LIGHTRED, "%d forintba kerül, neked nincs ennyid!", price); return 1; }
		
		SendFormatMessage(playerid, COLOR_GREEN, "Vásároltál %d mennyiségû skillt magadnak a következõ fegyverre: %s", amount, sub);
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
	if(sscanf(params, "i", target)) return Msg(playerid, "/clearvehicle [név/id]");
	if(target == INVALID_VEHICLE_ID) return Msg(playerid, "Nem létezõ jármû");
	CarWantedLevel[target] = 0;
	ClearVehicleCrime(target);
	SendClientMessage(playerid, COLOR_LIGHTRED, "Körözés Törölve!");
	return 1;
}
CMD:clearplayer(playerid, params[])
{
	new player;
	if(!Admin(playerid, 2)) return 1;
	if(sscanf(params, "u", player)) return Msg(playerid, "/clearplayer [név/id]");
	WantedLevel[player] = 0;
	ClearPlayerCrime(player);
	SendClientMessage(playerid, COLOR_LIGHTRED, "Körözés Törölve!");
	Msg(player, "Egy admin törölte rólad a körözést!");
	return 1;
}
CMD:clearado(playerid, params[])
{
	new player;
	if(!Admin(playerid, 1337)) return 1;
	if(sscanf(params, "u", player)) return Msg(playerid, "/clearado [név/id]");
	PlayerInfo[playerid][pAdokIdo] = 10;
	PlayerInfo[playerid][pAdokOsszeg] = 0;
	SendClientMessage(playerid, COLOR_LIGHTRED, "Adó Törölve!");
	Msg(player, "Egy admin törölte rólad az adótartozást!");
	return 1;
}
ALIAS(abanksz1mla):abankszamla;
ALIAS(absz):abankszamla;
CMD:abankszamla(playerid, params[])
{
	new player;
	if(!Admin(playerid, 4)) return 1;
	if(sscanf(params, "u", player)) return Msg(playerid, "/abankszámla [név/id]");
	if(PlayerInfo[player][pZarolva] == 0) return Msg(playerid, "Neki nincs lezárva!");
	PlayerInfo[player][pZarolva] = 0;
	SendClientMessage(playerid, COLOR_LIGHTRED, "Zárolás feloldva!");
	Msg(player, "Egy admin feloldotta a bankszámládról a zárolást!");
	return 1;
}
ALIAS(sajt4):sajto;
CMD:sajto(playerid, params[])
{
	if(!LMT(playerid, FRAKCIO_RIPORTER)) return Msg(playerid, "Nem vagy riporter!");
	if(PlayerInfo[playerid][pNewsSkill] < 101) return Msg(playerid, "A parancs használatához minimum 3-as ripoter skill szükséges");
	if(IsValidDynamic3DTextLabel(SajtoIgazolvany[playerid]))
	{
		DestroyDynamic3DTextLabel(SajtoIgazolvany[playerid]), SajtoIgazolvany[playerid] = INVALID_3D_TEXT_ID;
		Cselekves(playerid, "levette a nyakából a sajtóigazolványt.");
	}
	else
	{
		SajtoIgazolvany[playerid] = CreateDynamic3DTextLabel("Sajtó", COLOR_DYELLOW, 0.0, 0.0, 0.25, 10.0, playerid, INVALID_VEHICLE_ID, 1);
		Cselekves(playerid, "felrakta a nyakába a sajtóigazolványt.");
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
			return Msg(playerid, "Rejtõzködik, õ nem jelezhetõ");
		else if(PlayerPlace[player][pWarArea] != NINCS)
			return Msg(playerid, "War területen van, nem jelezhetõ");
			
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
		
		GameTextForPlayer(player, "•¤¶§!$$%&'()*+,-./01~!@#$^&*()_-+={[}]:;'<,>.?/", 1000, 0);
		GameTextForPlayer(player, "•¤¶§!$$%&'()*+,-./01~!@#$^&*()_-+={[}]:;'<,>.?/", 2000, 1);
		GameTextForPlayer(player, "•¤¶§!$$%&'()*+,-./01~!@#$^&*()_-+={[}]:;'<,>.?/", 3000, 2);
		GameTextForPlayer(player, "•¤¶§!$$%&'()*+,-./01~!@#$^&*()_-+={[}]:;'<,>.?/", 4000, 3);
		GameTextForPlayer(player, "•¤¶§!$$%&'()*+,-./01~!@#$^&*()_-+={[}]:;'<,>.?/", 5000, 4);
		GameTextForPlayer(player, "•¤¶§!$$%&'()*+,-./01~!@#$^&*()_-+={[}]:;'<,>.?/", 6000, 5);
		GameTextForPlayer(player, "•¤¶§!$$%&'()*+,-./01~!@#$^&*()_-+={[}]:;'<,>.?/", 7000, 6);
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
CMD:poke(playerid, params[])//Ha nem akarod kickelni, de azért mégis figyelmeztetnéd.
{
		if(!Admin(playerid, 1))
			return SendClientMessage(playerid, COLOR_LIGHTRED, "[Hiba]: Ezt a parancsot nem használhatod!");
			
        new jatekos, oka[64];
        if(sscanf(params, "us[64]", jatekos, oka))
            return SendClientMessage(playerid, COLOR_WHITE, "Használata: /lwarn [Játékos] [Oka]");
			
		if(jatekos == INVALID_PLAYER_ID || IsPlayerNPC(jatekos))
			return SendClientMessage(playerid, COLOR_LIGHTRED, "[Hiba]: Nincs ilyen játékos!");
			
		SendFormatMessage(playerid, COLOR_LIGHTRED, "Figyelmeztetted %s-t, Oka: %s", PlayerName(jatekos), oka);
		SendFormatMessage(jatekos, COLOR_LIGHTRED, "[LWARN] %s figyelmeztetett | Oka: %s", PlayerName(playerid), oka);
			

		return 1;
}

ALIAS(adafk):adminafk;//Megfigyelésre van!! Nem tudom minek kellet átalakítani fölösleges paranccsá!
CMD:adminafk(playerid, params[])
{
	if(!Admin(playerid, 4) && !IsScripter(playerid)) return 1;
	if(AdminDuty[playerid]) return Msg(playerid, "Adminszoliba elrejtõzni? Nehéz lesz.. :D");
	{
		if(GetPlayerColor(playerid) == COLOR_INVISIBLE)
		{
			SetPlayerColor(playerid, COLOR_BLACK);
			Msg(playerid, "Bekapcsolva!");
			Msg(playerid, "CSAK MEGFIGYELÉSRE HASZNÁLHATÓ!! Ha másra használod, vagy kiadod másnak, akkor SÚLYOS büntetésre számíts!!!", false, COLOR_YELLOW);
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
		return Msg(playerid, "Ezt a parancsot csak leader használhatja");
	
	new func[32];
	if(sscanf(params, "s[32] ", func))
		return Msg(playerid, "Használata: /terület átad [játékos]");
	
	if(egyezik(func, "átad") || egyezik(func, "atad"))
	{
		new player;
		if(sscanf(params, "{s[32]}r", player) || player == INVALID_PLAYER_ID)
			return Msg(playerid, "Használat: /terület átad [játékos]");
		
		if(!PlayerInfo[player][pMember] || PlayerInfo[player][pMember] == PlayerInfo[playerid][pMember] || LegalisSzervezetTagja(player) || Civil(player))
			return Msg(playerid, "Neki nem adhatod át");
		
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
			return Msg(playerid, "A területre kell menned, hogy átadhasd");
		
		if(TeruletInfo[area][tTulaj] != PlayerInfo[playerid][pLeader])
			return Msg(playerid, "Ez nem a ti területetek");
			
		if(db >= TERULET_FRAKCIO_LIMIT)
			return Msg(playerid, "Nekik már túl sok területük van");
		
		FrakcioInfo[PlayerInfo[playerid][pMember]][fPenz] -= 1000000;
		TeruletInfo[area][tTulaj] = PlayerInfo[player][pMember];
		TeruletUpdate(area, TERULET_Tulaj);
		TeruletFrissites();
		
		new msg1[128], msg2[128];
		format(msg1, 128, "<< Átadtátok a %s területet nekik: %s, az átruházási díj 1.000.000 Ft volt >>", TeruletInfo[area][tNev], Szervezetneve[ PlayerInfo[player][pMember] - 1][2]);
		format(msg2, 128, "<< Megkaptátok a %s területet tolük: %s >>", TeruletInfo[area][tNev], Szervezetneve[ PlayerInfo[playerid][pLeader] - 1][2]);
		foreach(Jatekosok, p)
		{
			if(PlayerInfo[p][pMember] == PlayerInfo[playerid][pMember])
				SendClientMessage(p, COLOR_YELLOW, msg1);
			else if(PlayerInfo[p][pMember] == PlayerInfo[player][pMember])
				SendClientMessage(p, COLOR_YELLOW, msg2);
		}
		format(_tmpString, 200, "[%s]%s átadta a %s területet nekik: %s", Szervezetneve[ PlayerInfo[playerid][pLeader] - 1][2], PlayerName(playerid), TeruletInfo[area][tNev], Szervezetneve[ PlayerInfo[player][pMember] - 1][2]), Log("Egyeb", _tmpString);
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
						SendFormatMessage(playerid, COLOR_GREEN, "[Info]: A kapu jelszava a következõ: %d | {FF0000}Ha visszaélsz vele a büntetés nem marad el!", Kapu[k][kKod]);
						SendClientMessage(playerid, COLOR_LIGHTRED, "[Info]: Ha a kapu nem a te tulajdonodban áll, a jelszavát nem mondhatod el senkinek se!");
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
		// nem csinál semmit
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
	//vége
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
			SendClientMessage(playerid, COLOR_YELLOW, "Nem vagy autószerelõ!");
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
		    SendClientMessage(playerid, COLOR_YELLOW, "Nem vagy rendõr.");
	}*/
//SWAT1
	else if(PlayerToPoint(20, playerid, 1626.2834472656, -1856.1879882813, 12.547634124756))
	{
	    if(PlayerInfo[playerid][pSwattag] == 1 || IsAdmin(playerid))
		{
	    	MoveDynamicObject(swatkapu1,1621.47375, -1856.35315, 8.78574, 3);
		}
		else
			SendClientMessage(playerid, COLOR_YELLOW, "Nem vagy a SWAT Egység tagja!");
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

			SendMessage(SEND_MESSAGE_RADIO, "FBI HQ: Figyelem minden egység! Illetéktelen behatolási kísérlet!", COLOR_RED, FRAKCIO_FBI);
			
			Fbibelepes = 1;
			HolTart[playerid] = NINCS;
			return 1;
		
		}
	}
	else
		SendClientMessage(playerid, COLOR_RED, "Nem vagy kapu közelében!");

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
				Msg(playerid, "Ezt a kaput nem zárhatod be");

			van = true;
			break;
		}
	}

	if(van)
	{
		// Nem csinál semmit
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
	//vlé
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
			SendClientMessage(playerid, COLOR_YELLOW, "Nem vagy az Oktatók tagja!");
	}*/
	else if(PlayerToPoint(7, playerid, -1917.303833, 301.403687, 40.874542))
	{
		if(PlayerInfo[playerid][pSzerelo]>0 || IsAdmin(playerid))
			MoveDynamicObject(AutoSzereloKapu, -1917.303833, 301.403687, 40.874542, 2);
		else
			SendClientMessage(playerid, COLOR_YELLOW, "Nem vagy autószerelõ!");
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
		    SendClientMessage(playerid, COLOR_YELLOW, "Nem vagy rendõr.");
	}*/
//SWAT1
	else if(PlayerToPoint(20, playerid, 1626.2834472656, -1856.1879882813, 12.547634124756))
	{
	    if(PlayerInfo[playerid][pSwattag] == 1 || IsAdmin(playerid))
		{
	    	MoveDynamicObject(swatkapu1,1621.47375, -1856.35315, 16.36366, 3);
		}
		else
			SendClientMessage(playerid, COLOR_YELLOW, "Nem vagy a SWAT Egység tagja!");
	}

	else if(PlayerToPoint(10, playerid, -1696.796997, 22.362562, 3.554687))
	{
	    if(PlayerInfo[playerid][pAutoker]>0 || IsAdmin(playerid))
		{
	    	MoveDynamicObject(KereskedoKapu, -1697.0, 23.0, 5.3280787467957, 2);
		}
		else
			SendClientMessage(playerid, COLOR_YELLOW, "Nem zárhatod be ezt a kaput!");
	}

	else if(PlayerToPoint(5, playerid, -2017.732178, -261.280273, 37.093704))
	{
	    if(PlayerInfo[playerid][pPhousekey] == 171)
		{
	    	MoveDynamicObject(KereskedoKapuHQn, -2017.732178, -261.280273, 37.093704, 2);
		}
		else
			SendClientMessage(playerid, COLOR_YELLOW, "Nem zárhatod be ezt a kaput!");
	}

	else
	    SendClientMessage(playerid, COLOR_RED, "Nem vagy kapu közelében!");

	return 1;
}
CMD:graffiti(playerid, params[])
{
	if(GetPlayerVirtualWorld(playerid) != 0 || GetPlayerInterior(playerid) != 0) return Msg(playerid, "Graffiti: Csak a szabadban!", false, COLOR_WHITE);
	if(AdminGraffiti[playerid] != NINCS || SzerkesztGraffiti[playerid] != NINCS) return Msg(playerid, "Graffiti: Elsõnek fejezd be a szerkesztést!", false, COLOR_WHITE);
	
	ShowPlayerDialog(playerid, DIALOG_GRAFFITI, DIALOG_STYLE_LIST, "Graffiti Kezelõ", "Készít\nLista", "Kész", "Mégse");
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
				if(FrakcioInfo[FRAKCIO_NAV][fDeagle] < 1) Msg(playerid, "Nincs deagle raktáron!");
				else
				{
						
					WeaponGiveWeapon(playerid, WEAPON_DEAGLE, 100);
					FrakcioInfo[FRAKCIO_NAV][fDeagle]--;
				}
			}
				
			WeaponGiveWeapon(playerid, WEAPON_SPRAYCAN, 900);
			new string[128];
			format(string, sizeof(string), "* Valaki felvette a határõröknek járó felszerelést.");
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
    SendClientMessage(playerid, COLOR_GRAD1, "A-A... Ilyet nem játszunk.. Magad nem fogod megölni.");
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
		format(string, sizeof(string), "* Valaki megnézte a zsebét.");
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
	return SendClientMessage(playerid, COLOR_WHITE, "Használat: /kormány rendezvény [Szöveg]");
}

ALIAS(leaderlemond):quitfaction;
CMD:quitfaction(playerid, params[])
{
	if(PlayerInfo[playerid][pLeader] == 0) return SendClientMessage(playerid, COLOR_GREY, "Nem vagy leader!");
	FrakcioInfo[PlayerInfo[playerid][pLeader]][fLeaderekSzama]--;
	new string[128];
	format(string, sizeof(string), "<< %s lemondta a Leaderségét | Frakció: %s (%d) >>", PlayerName(playerid),Szervezetneve[PlayerInfo[playerid][pMember]-1][2], PlayerInfo[playerid][pLeader]);
	ABroadCast(COLOR_LIGHTRED, string, 1);
    PlayerInfo[playerid][pMember] = 0;
	PlayerInfo[playerid][pRank] = 0;
	PlayerInfo[playerid][pLeader] = 0;
	SendClientMessage(playerid, COLOR_GREY, "Lemondtad a Leaderséged!");
	SetPlayerSkin(playerid, PlayerInfo[playerid][pModel]);
    return 1;

}
CMD:gumi(playerid, params[])
{
	new kocsi = GetClosestVehicle(playerid);
	new Float:tav = GetPlayerDistanceFromVehicle(playerid, kocsi);
	if(tav >= 3) return SendClientMessage(playerid, COLOR_LIGHTRED, "A közeledben nincs jármu!");
	if(IsPlayerInAnyVehicle(playerid)) return Msg(playerid, "Nem látod innen a gumit");
	if(IsABoat(kocsi) || IsABicikli(kocsi) || IsARepulo(kocsi)) return Msg(playerid,"Ezen nincs gumi ami elkopjon!");
	new Float:allapot=CarPart[kocsi][cKerekek];
	SendFormatMessage(playerid, COLOR_YELLOW, "Állapot infó: Az abroncsok %.2f százalékban elhasználtak!",allapot);
	return 1;
}
//=================================Engine====================================

ALIAS(gy7jt1s):gyujtas;
CMD:gyujtas(playerid, params[])
{
	new vid = GetPlayerVehicleID(playerid);
	if(!IsPlayerInAnyVehicle(playerid)) return Msg(playerid, "Nem vagy jármûben!");
	if(IsKocsi(vid, "Gokart"))	return 1;
	if(IsABicikli(vid)) return Msg(playerid, "Biciklin nem lehet");
	if(GetPlayerState(playerid) == PLAYER_STATE_PASSENGER) return Msg(playerid, "Csak sofõr!");
	if(!KocsibanVan[playerid]) return Msg(playerid, "Nem vagy jármûben!");
	if(engineOn[vid]) return Msg(playerid, "Már be van indítva a motor!");
	if(CarPart[vid][cElektronika] >= 100.0) return Msg(playerid, "Az elektronika tönkrement, így nem tudod bekapcsolni!");
	new car = IsAVsKocsi(vid);
	if(car != -1)
	{
		if(CarInfo[car][cOwned] == 0 && (PlayerInfo[playerid][pAutoker]<1 && AutokerKulcs[playerid] != 1 && !Lefoglalt[playerid]))
		{
		//	format(string, sizeof(string), "Carinfo %d ==0 és (%d <1 és  %d != 1)", CarInfo[car][cOwned], PlayerInfo[playerid][pAutoker], AutokerKulcs[playerid]);
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
	if(!IsPlayerInAnyVehicle(playerid)) return Msg(playerid, "Mégis mit akarsz beinditani?");
	if(IsKocsi(vid, "Gokart")) return 1;
	if(IsABicikli(vid)) return Msg(playerid, "Biciklin motor? Ez modern bicikli lehet... :)");
	if(GetPlayerState(playerid) == PLAYER_STATE_PASSENGER) return Msg(playerid, "Csak sofõr!");
	if(!KocsibanVan[playerid]) return Msg(playerid, "Nem vagy jármûben!");

	new car = IsAVsKocsi(vid);
	if(car != -1)
	{
		if(CarInfo[car][cOwned] == 0 && (PlayerInfo[playerid][pAutoker]<1 && AutokerKulcs[playerid] !=1 && !Lefoglalt[playerid]))
		{
		//	format(string, sizeof(string), "Carinfo %d ==0 és (%d <1 és  %d != 1)", CarInfo[car][cOwned], PlayerInfo[playerid][pAutoker], AutokerKulcs[playerid]);
		//	SendClientMessage(playerid, COLOR_YELLOW, string);
			return 1;
		}
	}

	if(Tankolaskozben[vid]) return Msg(playerid,"Ebbe a kocsiba már tankolnak!");
	if(engineOn[vid] == 0)
	{
		if(KocsiElet(vid) <= 350)
			return Msg(playerid, "A jármû elromlott! Hívj szerelõt!");
		if(CarPart[vid][cMotorolaj] >= 100.0) return Msg(playerid,"Az olaj nagyon elhasználódott, az elektronika letiltotta a kocsi mûködését, hívj szerelõt");
		if(CarPart[vid][cMotor] >= 500.0) return Msg(playerid, "A motorblokk tönkrement! Hívj szerelõt, hogy megjavíthassa a jármûvet!");
		if(Inditasgatlo[vid] == 1 && !Lefoglalt[playerid]) return Msg(playerid,"Az indításgátló lezárta a kocsi motorját nem tudod elvinni(Ha tiéd a kocsi zárd be majd nyisd ki)");
		if(Almaszedeskozbe[vid] == 1) return Msg(playerid,"A kocsiba éppen almát szednek, ne vidd el!!");
		if(Gas[vid] <= 0)
			return Msg(playerid, "Nincs üzemanyag!");
		if(KocsiSokkolva[vid])
			return Msg(playerid, "A jármû sokkolva van");
		if(bikazott[vid] == 0 && CarPart[vid][cAkkumulator] < 4.1) return Msg(playerid, "Lemerült az akkumulátor!");
		
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
			    SendClientMessage(playerid, COLOR_LIGHTGREEN, "Beindítod a jármuvet...");
				KocsiHasznal[vid]=PlayerName(playerid);
				SetTimerEx("Munkavege", ido, false, "ddd", playerid, M_MOTOR, 0);
				MunkaFolyamatban[playerid] = 1;
				return 1;
			} 
			else
			    SendClientMessage(playerid, COLOR_YELLOW, "Ha szeretnél mutatványozni írd be, hogy /cross");
		}
		if(SajatKocsi(playerid, vid) || car != -1 && CarInfo[car][cOwned] == 0 || JarmuKulcs[playerid] == vid || Slot==1)
		{
			if(MunkaFolyamatban[playerid] == 1) return 1;
			new kocsiserules, ido, Float:kocsielet;
			GetVehicleHealth(vid, kocsielet);
			kocsiserules = 1000 - floatround(kocsielet);
			ido = 1000 + (kocsiserules * 5);
			SendClientMessage(playerid, COLOR_GREEN, "Beindítod a jármuvet...");
			KocsiHasznal[vid]=PlayerName(playerid);
			SetTimerEx("Munkavege", ido, false, "ddd", playerid, M_MOTOR, 0);
			MunkaFolyamatban[playerid] = 1;
			if(CarPart[vid][cMotorolaj] >= 70.0)
				Msg(playerid,"Lassan olajat kell cserélni, keress fel egy szerelõt!");
			if(CarPart[vid][cFek] >= 100.0)
				Msg(playerid, "A fékbetét elhasználódott, így nehezebb lesz fékezni!");
			if(CarPart[vid][cElektronika] >= 100.0)
				Msg(playerid, "Az elektronika tönkrement, így nem tudsz semmilyen elektronikus eszközt használni!");
			CarPart[vid][cAkkumulator] -= 4.0;
		}
		else
			SendClientMessage(playerid, COLOR_LIGHTRED, "Nincs kulcsod ehhez a jármuhöz! El kell lopnod. (( /ellop ))");
	}
	else
	{
		engineOn[vid] = 0;
		Gyujtas[vid] = false;
		//TogglePlayerControllable(playerid, false);
		SetJarmu(vid, KOCSI_MOTOR, false);
		SendClientMessage(playerid, COLOR_GREEN, "Jármû leállítva!");
		ProxDetector(30.0, playerid, "* Valaki leállította a jármûvét.", COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		
		if(RoncsDerby[playerid][rdVersenyez])
			Msg(playerid,"Mivel leállítottad a motort, feladtad a versenyt!");
			
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
			SendClientMessage(playerid, COLOR_GRAD2, "(( Nincs bekapcsolva a Globális OOC Chat ))");
			return 1;
		}
		if(PlayerInfo[playerid][pMuted] == 1)
		{
			SendClientMessage(playerid, TEAM_CYAN_COLOR, "   Némítva vagy, hogy akarsz beszélni? :D");
			return 1;
		}
		new result[128], string[128];
		if(sscanf(params, "s[128]", result))
			return SendClientMessage(playerid, COLOR_WHITE, "Használat: /o [Globál OOC Üzeneted]");

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
	 	SendClientMessageToAll(COLOR_GRAD2, "(( A Globális OOC Chat le lett tiltva! ))");
	}
	else if(noooc)
	{
		noooc = 0;
		SendClientMessageToAll(COLOR_GRAD2, "(( A Globális OOC Chat engedélyezve lett! Használata: /o | Helyi kikapcsolása: /togooc ))");
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
	 	SendClientMessage(playerid, COLOR_GRAD2, "OOC szín bekapcsolva!");
	}
	else if(gOColor[playerid])
	{
		gOColor[playerid] = 0;
		SendClientMessage(playerid, COLOR_GRAD2, "OOC szín kikapcsolva!");
	}
	return 1;
}
ALIAS(hat1rellen6rz2s):hatarellenorzes;
CMD:hatarellenorzes(playerid, params[])
{
	if(!MunkaLeader(playerid, FRAKCIO_NAV) && !LMT(playerid, FRAKCIO_FBI) && !LMT(playerid, FRAKCIO_KATONASAG)) return Msg(playerid, "Nem vagy NAV Leader / FBI / Katona!");
	if(LMT(playerid, FRAKCIO_KATONASAG) && !Munkarang(playerid, 6)) return Msg(playerid, "Katonaságban rang 6tól engedélyezett a határellenõrzés!");
	if(hatar != 1)
	{
		hatar = 1;
		SendClientMessageToAll(COLOR_GOV2, "A NAV / FBI / Katonaság befejezte az ellenõrzést a határon!");
		//SetDynamicObjectRot(hatar1, 0, 0, 173.04718017578); // 173.04718017578
		//SetDynamicObjectRot(hatar2, 0, 0, 173.04718017578); // 173.04718017578
		return 1;
	}
	else
	{
		hatar = 0;
		SendClientMessageToAll(COLOR_GOV2, "A NAV / FBI / Katonaság ellenõrzést tart a határon!");
		//SetDynamicObjectRot(hatar1, 0.000000, 270.000000, 90.000000);
		//SetDynamicObjectRot(hatar2, 0, 90, 90.0000); // 173.04718017578
		return 1;
	}
}
CMD:lezertest(playerid, params[])
{
	if(!IsScripter(playerid)) return 1;
	new mit[32];
	if(sscanf(params, "s[32]", mit)) return Msg(playerid, "/lézertest ki/be");
	
	if(egyezik(mit, "ki"))
	{
		DestroyLaser();
		LezerDeaktivalva = true;
		
		Msg(playerid, "Lézer deaktiválva");
		return 1;
	}
	
	if(egyezik(mit, "be"))
	{
		CreateLaser();
		LezerDeaktivalva = false;
		
		Msg(playerid, "Lézer aktiválva");
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
		
		Msg(playerid, "Ajtó deaktiválva");
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

	if(WeaponArmed(playerid) == 0) return Msg(playerid, "Fegyver nélkül? Hagyjuk már..");
	
	new player = GetClosestPlayer(playerid);

	if(playerid == player) return 1;

	if(player == INVALID_PLAYER_ID) return Msg(playerid, "Nincs senki a közeledben!");
	
	if(GetDistanceBetweenPlayers(playerid, player) > 8.0) return SendClientMessage(playerid, COLOR_GREY, "A közeledben nincs senki");
	
	if(!PlayerCuffed[player]) return SendClientMessage(playerid, COLOR_GREY, "Nincs megbilincselve");
	
	new string[128];

	if(FloodMegprobal[playerid]>0)
	{
		SendFormatMessage(playerid, COLOR_YELLOW, "A-A ez túl sûrûn van. Legközelebb %d s múlva lehet!",FloodMegprobal[playerid]);
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
					format(string, sizeof(string), "** %s megpróbálja szétlõni a bilincset és sikerül neki", ICPlayerName(playerid));
				else
					format(string, sizeof(string), "** %s megpróbálja szétlõni a bilincset és sikerül neki", ICPlayerNameString(PlayerInfo[playerid][pHamisNev]));
				ProxDetector(30.0, playerid, string, COLOR_GREEN,COLOR_GREEN,COLOR_GREEN,COLOR_GREEN,COLOR_GREEN);
				printf("%s\n", string);
				
				Bilincs(player, 0);
				SetPlayerSpecialAction(player, SPECIAL_ACTION_NONE);
				RemovePlayerAttachedObject(player, ATTACH_SLOT_ZSAK_PAJZS_BILINCS);
				GameTextForPlayer(player, "~g~Bilincs levéve", 2500, 3);
			}
			default:
			{
				FloodMegprobal[playerid]=45;
				if(PlayerInfo[playerid][pHamisNev] == 0)
					format(string, sizeof(string), "** %s megpróbálja szétlõni a bilincset, de sajnos nem sikerül neki", ICPlayerName(playerid));
				else
					format(string, sizeof(string), "** %s megpróbálja szétlõni a bilincset, de sajnos nem sikerül neki", ICPlayerNameString(PlayerInfo[playerid][pHamisNev]));
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
		Msg(playerid, "/htojas [funkció]");
		Msg(playerid, "Funkciók: [Go | uj | töröl]");
		return 1;
	}
	if(egyezik(param, "go"))
	{
		
		new atmid;
		if(sscanf(func, "d", atmid)) return Msg(playerid, "/htojas go [TOJÁS ID]");
		
		if(atmid < 0 || atmid > MAX_TOJAS) return Msg(playerid, "Hibás tojás ID.");
		SetPlayerPos(playerid, Tojas[atmid][tjPos][0], Tojas[atmid][tjPos][1], Tojas[atmid][tjPos][2]+1.5);
		SendFormatMessage(playerid,  COLOR_LIGHTGREEN, "* Teleportáltál a tojáshoz. (ID: %d - Koordínáta: X: %f | Y: %f | Z: %f) ", atmid, Tojas[atmid][tjPos][0], Tojas[atmid][tjPos][1], Tojas[atmid][tjPos][2]);
	}
	if(egyezik(param, "uj") || egyezik(param, "új"))
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
		
		if(id < 0 || id >= MAX_TOJAS) return Msg(playerid, "Nincs üres hely!");

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

		SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Tojás lerakva. (ID: %d - Koordínáta: X: %.2f | Y: %.2f | Z: %.2f | VW: %d | INT: %d) ", id, ArrExt(Tojas[id][tjPos]), Tojas[id][tjVW], Tojas[id][tjInt]);
		Streamer_Update(playerid);
		SetPlayerPos(playerid, Tojas[id][tjPos][0], Tojas[id][tjPos][1], Tojas[id][tjPos][2]+3.0);
		
		TojasAkcio(TOJAS_MENT);
		
		return 1;
	}
	if(egyezik(param, "töröl"))
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
		
		if(id < 0 || id >= MAX_TOJAS) return Msg(playerid, "Hibás SORSZÁM ID.");
		
		if(IsValidDynamicObject(Tojas[id][tjID])) DestroyDynamicObject(Tojas[id][tjID]),Tojas[id][tjID]=INVALID_OBJECT_ID;

		Tojas[id][tjPos][0] = 0.0;
		Tojas[id][tjPos][1] = 0.0;
		Tojas[id][tjPos][2] = 0.0;
		Tojas[id][tjVW] = 0;
		Tojas[id][tjInt] = 0;
		Tojas[id][tjVan] = false;
		Tojas[id][tjKiosztva] = false;
		SendFormatMessage(playerid,  COLOR_LIGHTGREEN, "Törölve tojás: %d",id);
		
		TojasAkcio(TOJAS_MENT);
		
		return 1;
	}
	if(egyezik(param, "aktival") || egyezik(param, "aktivál"))
	{
		if(SQLID(playerid) != 8183364) return 1;
		
		HusvetiEvent = true;
		SendClientMessage(playerid, COLOR_LIGHTGREEN, "Húsvéti event elindítva!");
		new husvet[128];
		Format(husvet, "<< %s elindította a húsvéti eventet, az event szerda éjféléig tart. >>", PlayerName(playerid));
		SendMessage(SEND_MESSAGE_ADMIN, husvet, COLOR_RED, 1);
		return 1;
	}
	if(egyezik(param, "deaktival") || egyezik(param, "deaktivál"))
	{
		if(SQLID(playerid) != 8183364) return 1;
		
		HusvetiEvent = false;
		SendClientMessage(playerid, COLOR_LIGHTGREEN, "Húsvéti event deaktiválva!");
		new husvet[128];
		Format(husvet, "<< %s deaktiválta a húsvéti eventet >>", PlayerName(playerid));
		SendMessage(SEND_MESSAGE_ADMIN, husvet, COLOR_RED, 1);
		return 1;
	}
	if(egyezik(param, "nulláz"))
	{
		for(new a = 0; a < MAX_TOJAS; a++)
		{
			if(!Tojas[a][tjVan]) continue;
			Tojas[a][tjKiosztva] = false;
		}
		
		SendClientMessage(playerid, COLOR_LIGHTGREEN, "Húsvéti tojások foglalva nullázva!");
		
		return 1;
	}
	return 1;
}

ALIAS(husv2t):husvet;
ALIAS(h7sv2t):husvet;
ALIAS(h7svet):husvet;
CMD:husvet(playerid, params[])
{
	if(!HusvetiEvent) return Msg(playerid, "Majd húsvétkor!");
	new id = PlayerInfo[playerid][phTojas];
	if(id == -2) return Msg(playerid, "Te már kinyitottad a te tojásodat!");
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
	
	if(legkozelebb > 3.0) return Msg(playerid, "Nincs a közeledben tojás!");
	
	if(id != kozel)
	{
		Msg(playerid, "Sajnálom, de ez nem a te tojásod!");
				
		new Float:hol = GetDistanceBetweenPoints(PPos[0], PPos[1], PPos[2], Tojas[id][tjPos][0], Tojas[id][tjPos][1], Tojas[id][tjPos][2]);
		if(hol >= 500.0)
			Msg(playerid, "Segítség: Nagyon hideg :'(");
		else if(500.0 > hol >= 300.0)
			Msg(playerid, "Segítség: Hideg :()");
		else if(300.0 > hol >= 100.0)
			Msg(playerid, "Segítség: Melegszik :)");
		else if(100.0 > hol >= 50.0)
			Msg(playerid, "Segítség: Meleg :D");
		else if(50.0 > hol >= 25.0)
			Msg(playerid, "Segítség: Nagyon meleg c(:");
		else if(25.0 > hol >= 10.0)
			Msg(playerid, "Segítség: Fú de forró");
		else
			Msg(playerid, "Segítség: Boldog húsvétot! Remélem most már megtaláltad :P");
		
		return 1;
	}
	
	TojasNyit(playerid);
		
	return 1;
}
CMD:fixtrafi(playerid, params[])
{
	if(!LMT(playerid, FRAKCIO_SCPD) && !Admin(playerid, 1)) return Msg(playerid, "Nem vagy rendõr!");
	if(!OnDuty[playerid] && !Admin(playerid, 1)) return Msg(playerid, "Nem vagy szolgálatban!");

	new param[32];
	new func[256];
	
	if(sscanf(params, "s[32]S()[256]", param, func)) 
	{
		Msg(playerid, "/fixtrafi [funkció]");
		Msg(playerid, "Funkciók: [lerak | felvesz]");
		Msg(playerid, "Lerak: [5, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 130, 140]");
		return 1;
	}
	if(egyezik(param, "lerak") && OnDuty[playerid] && LMT(playerid, FRAKCIO_SCPD))
	{
		
		new sebesseg;
		if(sscanf(func, "d", sebesseg)) return Msg(playerid, "/fixtrafi [lerak] [sebesség]");

		if(sebesseg != 5 && sebesseg != 10 && sebesseg != 20 && sebesseg != 30 && sebesseg != 40 && sebesseg != 50 && sebesseg != 60 && sebesseg != 70 && sebesseg != 80 && sebesseg != 90 && sebesseg != 100 && sebesseg != 110 && sebesseg != 120 && sebesseg != 130 && sebesseg != 140)
			return Msg(playerid, "A sebeség érték 5, 10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 130, vagy 140 lehet");

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
		
		if(legkozelebb < 25.0) return Msg(playerid, "A környéken van már fixtrafi lerakva!");
		if(slot == NINCS) return Msg(playerid, "Úgytûnik nincs slot..");

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
		Format(labelinfo, "FixTrafipax\n(( %s ))\nMég %d percig aktív", PlayerName(playerid), floatround(float(FixTrafi[a][fxErvenyes]-UnixTime)/60.0));
		FixTrafi[a][fxLabel] = CreateDynamic3DTextLabel(labelinfo, COLOR_GREEN, FixTrafi[a][fxPos][0], FixTrafi[a][fxPos][1], FixTrafi[a][fxPos][2]+5.0, 10.0);
		SendClientMessage(playerid, COLOR_RED, "Fixtrafipax sikeresen lehelyezve! A Fixtrafipax félóráig lesz elérhetõ szóval néha csekkold le!");
		SendFormatMessage(playerid, COLOR_RED, "%d km/h Max sebességre állítottad a fixtrafit.. Sok sikert a vadászathoz kolléga!", sebesseg);
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
		if(legkozelebb > 5.0) return Msg(playerid, "Nincs a közeledben fixtrafi!");

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

		SendClientMessage(playerid, COLOR_RED, "Fixtrafipax sikeresen felvéve!");
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
		Msg(playerid, "Visszatáraztad a régi lõszereidet..");
		Cselekves(playerid, "visszatárazta az éles töltényeket..");
		return 1;
	}

	if(WeaponArmed(playerid) == WEAPON_MP5) 
	{
		if(Gumilovedek[playerid][fxMP5] <= 0) return Msg(playerid, "Ehhez a fegyverhez nincs gumilövedéked!");
		pGumilovedek[playerid] = WEAPON_MP5;
	}
	else if(WeaponArmed(playerid) == WEAPON_AK47) 
	{
		if(Gumilovedek[playerid][fxAK47] <= 0) return Msg(playerid, "Ehhez a fegyverhez nincs gumilövedéked!");
		pGumilovedek[playerid] = WEAPON_AK47;
	}
	else if(WeaponArmed(playerid) == WEAPON_M4) 
	{
		if(Gumilovedek[playerid][fxM4A1] <= 0) return Msg(playerid, "Ehhez a fegyverhez nincs gumilövedéked!");
		pGumilovedek[playerid] = WEAPON_M4;
	}
	else if(WeaponArmed(playerid) == WEAPON_SHOTGUN) 
	{
		if(Gumilovedek[playerid][fxShotgun] <= 0) return Msg(playerid, "Ehhez a fegyverhez nincs gumilövedéked!");
		pGumilovedek[playerid] = WEAPON_SHOTGUN;
	}
	else if(WeaponArmed(playerid) == WEAPON_SHOTGSPA) 
	{
		if(Gumilovedek[playerid][fxCombat] <= 0) return Msg(playerid, "Ehhez a fegyverhez nincs gumilövedéked!");
		pGumilovedek[playerid] = WEAPON_SHOTGSPA;
	}
	else if(WeaponArmed(playerid) == WEAPON_DEAGLE) 
	{
		if(Gumilovedek[playerid][fxDeagle] <= 0) return Msg(playerid, "Ehhez a fegyverhez nincs gumilövedéked!");
		pGumilovedek[playerid] = WEAPON_DEAGLE;
	}
	else if(WeaponArmed(playerid) == WEAPON_COLT45) 
	{
		if(Gumilovedek[playerid][fxColt45] <= 0) return Msg(playerid, "Ehhez a fegyverhez nincs gumilövedéked!");
		pGumilovedek[playerid] = WEAPON_COLT45;
	}
	else if(WeaponArmed(playerid) == WEAPON_SILENCED) 
	{
		if(Gumilovedek[playerid][fxSilencedColt45] <= 0) return Msg(playerid, "Ehhez a fegyverhez nincs gumilövedéked!");
		pGumilovedek[playerid] = WEAPON_SILENCED;
	}
	else if(WeaponArmed(playerid) == WEAPON_RIFLE) 
	{
		if(Gumilovedek[playerid][fxRifle] <= 0) return Msg(playerid, "Ehhez a fegyverhez nincs gumilövedéked!");
		pGumilovedek[playerid] = WEAPON_RIFLE;
	}
	else if(WeaponArmed(playerid) == WEAPON_SNIPER) 
	{
		if(Gumilovedek[playerid][fxSniper] <= 0) return Msg(playerid, "Ehhez a fegyverhez nincs gumilövedéked!");
		pGumilovedek[playerid] = WEAPON_SNIPER;
	}
	else return Msg(playerid, "Ehhez a fegyverhez nincs gumilövedék!");

	Msg(playerid, "Betáraztad a gumilövedékeket..");
	Cselekves(playerid, "betárazza a gumilövedékeket..");
	OnePlayAnim(playerid,"UZI","UZI_reload",4.0,0,0,0,0,0);

	return 1;
}*/

CMD:costa(playerid, params[])
{
	if(SQLID(playerid) != 8176593 && !IsScripter(playerid) && !Admin(playerid, 1)) return 1;
	Msg(playerid, "Costa haszontalan");
	Msg(playerid, "Ha Costa vagy és ezt az üzenetet olvasod valószínûleg");
	Msg(playerid, "13 órája adminszoliban vagy és floodolod a /costa parancsot");
	Msg(playerid, "miközben a röhögéseddel nem csak a ház lakóit de még a szomszédok");
	Msg(playerid, "szomszédait is akaratlanul felkelted!");
	Msg(playerid, "ui: Munkád 0 szóval vissza dolgozni <3");
	return 1;
}

CMD:adjustweapons(playerid, params[])
{
	if(PlayerCuffed[playerid] != 0) return Msg(playerid, "Majd ha nem leszel megbilincselve..");
	if(Bortonben(playerid) > 0) return Msg(playerid, "Persze csak is ezt lehet egy börtönben");
	if(NemMozoghat(playerid)) return Msg(playerid, "Leütve / megkötözve / animban nem lehet!");
	if(!gLohet[playerid]) return Msg(playerid, "Nem-nem!");
	if(MunkaFolyamatban[playerid]) return Msg(playerid, "Elõbb fejezd be amit csinálsz!");
	Freeze(playerid, 0);
	
	new szoveg[128];
	for(new i=0; i<MAX_FVALASZTAS_L; i++)
	{
		if(!strlen(szoveg)) Format(szoveg, "%s", FValasztasLehetosegek[i]);
		else Format(szoveg, "%s\n%s", szoveg, FValasztasLehetosegek[i]);
	}
	ShowPlayerDialog(playerid, DIALOG_ADJUSTWEAPONS, DIALOG_STYLE_LIST, "Fegyverállítás", szoveg, "Kiválaszt", "Mégse");
	return 1;
}

CMD:hvisz(playerid, params[])
{
	if(!AMT(playerid, MUNKA_HULLA) && !LMT(playerid, FRAKCIO_MENTO)) return Msg(playerid, "Te nem vagy Hullaszállító!");
	if(PlayerCuffed[playerid] != 0) return Msg(playerid, "Majd ha nem leszel megbilincselve..");
	if(Bortonben(playerid) > 0) return Msg(playerid, "Persze csak is ezt lehet egy börtönben");
	if(NemMozoghat(playerid)) return Msg(playerid, "Leütve / megkötözve / animban nem lehet!");
	if(!gLohet[playerid]) return Msg(playerid, "Nem-nem!");
	if(MunkaFolyamatban[playerid]) return Msg(playerid, "Elõbb fejezd be amit csinálsz!");
	
	if(HVisz[playerid] != NINCS) return HVisz[playerid] = NINCS, Msg(playerid, "Elengedted!");
	new hulla = GetClosestHulla(playerid);
	 
	if(GetDistanceToHulla(playerid, hulla) > 5.0) return SendClientMessage(playerid, COLOR_LIGHTRED, "Nincs a közeledben hulla!");
	if(HullaInfo[hulla][Hvw] != GetPlayerVirtualWorld(playerid)) return SendClientMessage(playerid, COLOR_LIGHTRED, "Nincs a közeledben hulla!");
	
	HVisz[playerid] = hulla;
	Msg(playerid, "Megfogtad és viszed..");
			
	return 1;
}
CMD:ame(playerid, params[])
{
	if(Csendvan && PlayerInfo[playerid][pAdmin] == 0) return Msg(playerid, "Most nem beszélhetsz!");
	new result[128];
	if(sscanf(params, "s[128]", result))
		return SendClientMessage(playerid, COLOR_WHITE, "Használat: /ame [karakter leírása]");

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
	if(OnDuty[playerid]) return Msg(playerid, "Döntsd el mit dolgozol...");
	if(!AMT(playerid, MUNKA_BANYASZ)) return Msg(playerid, "Nem vagy bányász!", false, COLOR_RED);
	if(FloodCheck(playerid)) return 1;
	if(sscanf(params, "s[32]S()[32]", type, func))
	{
		if(Admin(playerid, 5))
			Msg(playerid, "Adminparancs: /bányász give [mit] [mennyit]");
		
		Msg(playerid, "Használata: /bányász [átöltöz/megnéz/berak] -- portához", false, COLOR_WHITE);
		Msg(playerid, "Használata: /bányász [szállít/lemond] -- szállításhoz", false, COLOR_WHITE);
		return Msg(playerid, "Segítség: /bányász [segítség]", false, COLOR_WHITE);
	}
	
	//Csákány a hatán
	//SetPlayerAttachedObject(playerid, ATTACH_SLOT_SISAK, 1636, 1, 0.125999, -0.119999, -0.129999, 0.000000, -67.199996, 0.000000);
	
	//Csákány a kézben
	//SetPlayerAttachedObject(playerid, ATTACH_SLOT_SISAK, 1636, 6, 0.014000, 0.010000, 0.133999);
	
	if(egyezik(type, "átöltöz") || egyezik(type, "atoltoz")) {
		if(banyaszbsz[playerid])
			return Msg(playerid, "Szállítás közben nem... Ha le akarod mondani /bányász lemond...");
		if(!PlayerToPoint(1, playerid, 816.882, 856.506, 12.789))
		{
			DisablePlayerCheckpoint(playerid);
			SetPlayerCheckpoint(playerid, 816.882, 856.506, 12.789, 1.0);
			return Msg(playerid, "Menj a munkahelyedre és ott öltözz át! (( GPS-en megjelölve. ))");
		}

		if(Munkaban[playerid] != MUNKA_BANYASZ)
		{
			// 27 - férfi 192- nõi
			if(PlayerInfo[playerid][pSex] == 1)
				SetPlayerSkin(playerid, 27);
			else
				SetPlayerSkin(playerid, 192);
			
			Msg(playerid, "Átöltöztél a munkaruhádba, menj a bányába és kezdj dolgozni!", false, COLOR_LIGHTGREEN);
			Cselekves(playerid, "átöltözött a munkaruhájába.");
			SetPlayerAttachedObject(playerid, ATTACH_SLOT_SISAK, 1636, 1, 0.125999, -0.119999, -0.129999, 0.000000, -67.199996, 0.000000);
			Munkaban[playerid] = MUNKA_BANYASZ;
			DisablePlayerCheckpoint(playerid);
		}
		else
		{
			SetPlayerSkin(playerid, PlayerInfo[playerid][pModel]);
			
			Msg(playerid, "Levetted a munkaruhád!", false, COLOR_LIGHTGREEN);
			Cselekves(playerid, "levette a munkaruháját.");
			RemovePlayerAttachedObject(playerid, ATTACH_SLOT_SISAK);
			Munkaban[playerid] = NINCS;
			DisablePlayerCheckpoint(playerid);
		}
	}
	else if(egyezik(type, "megnéz") || egyezik(type, "megnez"))
	{
		if(banyaszbsz[playerid])
			return Msg(playerid, "Szállítás közben nem... Elsõnek szállítsd le...");
		if(!PlayerToPoint(1, playerid, 816.882, 856.506, 12.789))
		{
			DisablePlayerCheckpoint(playerid);
			SetPlayerCheckpoint(playerid, 816.882, 856.506, 12.789, 1.0);
			return Msg(playerid, "Itt nem tudod megnézni. Menj el a portára! (GPS-en megjelölve)", false, COLOR_LIGHTRED);
		}

		new stringinfo[256];
		SendClientMessage(playerid, COLOR_GREEN,"================================[ Bányász porta ]================================");
		SendClientMessage(playerid, COLOR_GREEN,"  Õrizetben lévõ dolgaid:");

		format(stringinfo, sizeof(stringinfo), "Szén: %d/%dg | Vas: %d/%dg | Arany: %d/%dg | Gyémánt: %d/%dg", PMAXSZEN, PlayerInfo[playerid][pSzenP], PMAXVAS, PlayerInfo[playerid][pVasP], PMAXARANY, PlayerInfo[playerid][pAranymP], PMAXGYEMANT, PlayerInfo[playerid][pGyemantP]);
		SendClientMessage(playerid, COLOR_GRAD1, stringinfo);
		Cselekves(playerid, "megnézte a portán lévõ értékeit.");

	}
	else if(egyezik(type, "berak"))
	{
		if(banyaszbsz[playerid])
			return Msg(playerid, "Szállítás közben nem... Elsõnek szállítsd le...");
		if(!PlayerToPoint(1, playerid, 816.882, 856.506, 12.789))
		{
			DisablePlayerCheckpoint(playerid);
			SetPlayerCheckpoint(playerid, 816.882, 856.506, 12.789, 1.0);
			return Msg(playerid, "Itt nem tudod leadni. Menj fel a portára! (GPS-en megjelölve)", false, COLOR_LIGHTRED);
		}
		
		new type2[32];
		new mennyi = 0;
		if(sscanf(func, "s[32]d", type2, mennyi)) return Msg(playerid, "Használata: /bányász berak [mit] [mennyit]", false, COLOR_WHITE);
		
		new string[64];
		if(egyezik(type2, "szen") || egyezik(type2, "szén"))
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
				return Msg(playerid, "Ennyi nem fér be a raktárba!", false, COLOR_LIGHTRED);
			}
			else
			{
				PlayerInfo[playerid][pSzen] -= mennyi;
				PlayerInfo[playerid][pSzenP] += mennyi;
				format(string, sizeof(string), "Sikeresen beraktál %dg szenet! Még %dg szén fér!", mennyi, (PMAXSZEN - PlayerInfo[playerid][pSzenP]));
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
				return Msg(playerid, "Ennyi nem fér be a raktárba!", false, COLOR_LIGHTRED);
			else
			{
				PlayerInfo[playerid][pVas] -= mennyi;
				PlayerInfo[playerid][pVasP] += mennyi;
				format(string, sizeof(string), "Sikeresen beraktál %dg vasat! Még %dg vas fér!", mennyi, (PMAXVAS - PlayerInfo[playerid][pVasP]));
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
				return Msg(playerid, "Ennyi nem fér be a raktárba!", false, COLOR_LIGHTRED);
			else
			{
				PlayerInfo[playerid][pAranym] -= mennyi;
				PlayerInfo[playerid][pAranymP] += mennyi;
				format(string, sizeof(string), "Sikeresen beraktál %dg aranyat! Még %dg arany fér!", mennyi, (PMAXARANY - PlayerInfo[playerid][pAranymP]));
				SendClientMessage(playerid, COLOR_GREEN, string);
			}
		}
		else if(egyezik(type2, "gyemant") || egyezik(type2, "gyémánt"))
		{
			if(mennyi < 1)
				return Msg(playerid, "Na persze...", false, COLOR_LIGHTRED);
			else if(PlayerInfo[playerid][pGyemant] < mennyi)
				return Msg(playerid, "Nincs ennyi gyémántod!", false, COLOR_LIGHTRED);
			else if(PlayerInfo[playerid][pGyemantP] + mennyi > PMAXGYEMANT)
				return Msg(playerid, "Ennyi nem fér be a raktárba!", false, COLOR_LIGHTRED);
			else
			{
				PlayerInfo[playerid][pGyemant] -= mennyi;
				PlayerInfo[playerid][pGyemantP] += mennyi;
				format(string, sizeof(string), "Sikeresen beraktál %dg gyémántot! Még %dg gyémánt fér!", mennyi, (PMAXGYEMANT - PlayerInfo[playerid][pGyemantP]));
				SendClientMessage(playerid, COLOR_GREEN, string);
			}
		}
		else
			return Msg(playerid, "Ilyen érc nem létezik...", false, COLOR_LIGHTRED);
		
		Cselekves(playerid, "berakott valamit a portára.");
	}
	else if(egyezik(type, "szállít") || egyezik(type, "szallit"))
	{
		if(Munkaban[playerid] != MUNKA_BANYASZ)
				return Msg(playerid, "Menj a munkahelyedre és öltözz át! ((/bányász átöltöz)).");
		if(banyaszbsz[playerid])
			return Msg(playerid, "Már szállítasz... Elsõnek szállítsd le ezt...");
		if(!PlayerToPoint(10, playerid, 819.849, 869.462, 12.226))
		{
			DisablePlayerCheckpoint(playerid);
			SetPlayerCheckpoint(playerid, 819.849, 869.462, 12.226, 10.0);
			return Msg(playerid, "Itt nem tudod elkezdeni a szállítást. Menj fel a portára és állj be a kocsival! (GPS-en megjelölve)", false, COLOR_LIGHTRED);
		}
		if(!IsKocsi(GetPlayerVehicleID(playerid), "Banyasz"))
			return Msg(playerid, "Csak munkakocsival(Yosemite) tudod elszállítani az árút!");
		
		
		MunkaFolyamatban[playerid] = 1;
		SendClientMessage(playerid, COLOR_LIGHTGREEN, "Elkezdték felpakolni az árút. Légy türelemmel...");
		Cselekves(playerid, "bejelentkezik a portára és várakozik amíg felpakolják az árút.");
		TogglePlayerControllable(playerid, false);
		banyaszbsz[playerid] = true;
		MunkaTimerID[playerid]=SetTimerEx("Munkavege", (MunkaIdo[13]*3), false, "dd", playerid, M_BANYASZ_SZALLIT_KEZD);

	}
	else if(egyezik(type, "lemond"))
	{
		if(!banyaszbsz[playerid])
			return Msg(playerid, "Nem vagy szállítás közben!");
		if(!PlayerToPoint(10, playerid, 819.849, 869.462, 12.226))
		{
			DisablePlayerCheckpoint(playerid);
			SetPlayerCheckpoint(playerid, 819.849, 869.462, 12.226, 10.0);
			Msg(playerid, "Épp szállítasz, ha le akarod mondani menj a portára.");
			return Msg(playerid, "Ha lemondod büntetést kapsz! 15%% - Szén, Vas | 50%% - Arany, Gyémánt vesztéssel jár!");
		}
		if(!IsKocsi(GetPlayerVehicleID(playerid), "Banyasz"))
			return Msg(playerid, "Csak a munkakocsiddal tudod lemondani!");
		if(MunkaFolyamatban[playerid] == 1)
			return Msg(playerid, "Nyugi van... Még el sem kezdted!");
		
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
		
		Msg(playerid, "Mivel lemondtad a szállítást a büntetésed megkaptad.");
	}
	else if(egyezik(type, "give"))
	{
		if(Admin(playerid, 5))
		{
			new type2[32];
			new player, mennyi;
			if(sscanf(func, "rs[32]d", player, type2, mennyi)) return Msg(playerid, "Használata: /bányász give [id] [mit] [mennyit]", false, COLOR_WHITE);
			if(player == INVALID_PLAYER_ID) return Msg(playerid, "Nincs ilyen játékos");
			
			if(egyezik(type2, "szen") || egyezik(type2, "szén"))
			{
				if(mennyi < 1)
					return Msg(playerid, "Na persze...", false, COLOR_LIGHTRED);
				else if(PlayerInfo[playerid][pSzen] + mennyi > MAXSZEN)
					return Msg(playerid, "Ennyi nem fér el a zsebében!", false, COLOR_LIGHTRED);
				else
				{
					new string[64];
					PlayerInfo[playerid][pSzen] += mennyi;
					format(string, sizeof(string), "Adtál %dg szenet! Neki: %s", mennyi, PlayerName(player));
					SendClientMessage(playerid, COLOR_RED, string);
					return SendFormatMessage(player, COLOR_YELLOW,"Admin: %s adott neked %dg szenet.", ICPlayerName(playerid), mennyi);
				}
			}
			else if(egyezik(type2, "vas"))
			{
				if(mennyi < 1)
					return Msg(playerid, "Na persze...", false, COLOR_LIGHTRED);
				else if(PlayerInfo[playerid][pVas] + mennyi > MAXVAS)
					return Msg(playerid, "Ennyi nem fér el a zsebében!", false, COLOR_LIGHTRED);
				else
				{
					new string[64];
					PlayerInfo[playerid][pVas] += mennyi;
					format(string, sizeof(string), "Adtál %dg vasat! Neki: %s", mennyi, PlayerName(player));
					SendClientMessage(playerid, COLOR_RED, string);
					return SendFormatMessage(player,COLOR_YELLOW,"Admin: %s adott neked %dg vasat.", ICPlayerName(playerid), mennyi);
				}
			}
			else if(egyezik(type2, "arany"))
			{
				if(mennyi < 1)
					return Msg(playerid, "Na persze...", false, COLOR_LIGHTRED);
				else if(PlayerInfo[playerid][pAranym] + mennyi > MAXARANY)
					return Msg(playerid, "Ennyi nem fér el a zsebében!", false, COLOR_LIGHTRED);
				else
				{
					new string[64];
					PlayerInfo[playerid][pAranym] += mennyi;
					format(string, sizeof(string), "Adtál %dg aranyat! Neki: %s", mennyi, PlayerName(player));
					SendClientMessage(playerid, COLOR_RED, string);
					return SendFormatMessage(player,COLOR_YELLOW,"Admin: %s adott neked %dg aranyat.", ICPlayerName(playerid), mennyi);
				}
			}
			else if(egyezik(type2, "gyemant") || egyezik(type2, "gyémánt"))
			{
				if(mennyi < 1)
					return Msg(playerid, "Na persze...", false, COLOR_LIGHTRED);
				else if(PlayerInfo[playerid][pGyemant] + mennyi > MAXGYEMANT)
					return Msg(playerid, "Ennyi nem fér el a zsebében!", false, COLOR_LIGHTRED);
				else
				{
					new string[64];
					PlayerInfo[playerid][pGyemant] += mennyi;
					format(string, sizeof(string), "Adtál %dg gyémántot! Neki: %s", mennyi, PlayerName(player));
					SendClientMessage(playerid, COLOR_RED, string);
					return SendFormatMessage(player,COLOR_YELLOW,"Admin: %s adott neked %dg gyémántot.", ICPlayerName(playerid), mennyi);
				}
			}
		}
		else
			return Msg(playerid, "Csak Adminoknak(5)!");
	}
	else if(egyezik(type, "segítség") || egyezik(type, "segitseg"))
	{
		SendClientMessage(playerid, COLOR_GRAD1, "ALT gomb: Kõ bányászása és Kõ feldolgozása");
		SendClientMessage(playerid, COLOR_GRAD2, "Kapsz egy nagydarab követ a kezedbe amit elkell vinni a feldolgozóhoz!");
		SendClientMessage(playerid, COLOR_GRAD3, "A feldolgozó elõtt ALT gomb és elkezdõdik a feldolgozás.");
		SendClientMessage(playerid, COLOR_GRAD4, "Ezután mehetsz vissza követ bányászni megint!");
	}

	return 1;
}

ALIAS(villanyszerel6):villanyszerelo;
ALIAS(vsz):villanyszerelo;
CMD:villanyszerelo(playerid, params[])
{
	if(OnDuty[playerid])
		return Msg(playerid, "Döntsd el mit dolgozol...");
	if(!AMT(playerid, MUNKA_VILLANYSZERELO))
		return Msg(playerid, "Nem vagy villanyszerelõ!");
	new func[8];
	if(sscanf(params, "s[8]", func))
		return Msg(playerid, "Használata: /villanyszerelõ [átöltöz/kezdés]", false, COLOR_WHITE);
	
	if(egyezik(func, "átöltöz") || egyezik(func, "atoltoz"))
	{
		if(!PlayerToPoint(2, playerid, 1657.926, -1394.764, 13.546))
		{
			DisablePlayerCheckpoint(playerid);
			SetPlayerCheckpoint(playerid, 1657.926, -1394.764, 13.546, 2.0);
			return Msg(playerid, "Itt nem tudsz átöltözni! Menj a munkahelyedre és ott megteheted (( GPS-en jelölve ))", false, COLOR_BLUE);
		}
		
		if(Munkaban[playerid] != MUNKA_VILLANYSZERELO)
		{
			if(PlayerInfo[playerid][pSex] == 1)
				SetPlayerSkin(playerid, 27);
			else
				SetPlayerSkin(playerid, 192);
				
			Msg(playerid, "Átöltöztél a munkaruhádba, menj fogj egy munkakocsit!", false, COLOR_GREEN);
			Cselekves(playerid, "átöltözött a munkaruhájába.");
			Munkaban[playerid] = MUNKA_VILLANYSZERELO;
		}
		else
		{
			Msg(playerid, "Levetted a munkaruhádat!", false, COLOR_GREEN);
			Cselekves(playerid, "levette a munkaruháját!");
			SetPlayerSkin(playerid, PlayerInfo[playerid][pModel]);
			Munkaban[playerid] = NINCS;
			vmunk[playerid] = false;
		}
	}
	else if (egyezik(func, "kezdés") || egyezik(func, "kezdes"))
	{
		if(Munkaban[playerid] != MUNKA_VILLANYSZERELO)
			return Msg(playerid, "Nem vagy munkában! (( /villanyszerelõ átöltöz ))");
		if(!IsKocsi(GetPlayerVehicleID(playerid), "Villanyszerelo") || GetVehicleModel(GetPlayerVehicleID(playerid)) != 552)
			return Msg(playerid, "Nem vagy Villanyszerelõ kocsiban!", false, COLOR_LIGHTBLUE);
		if(vmunk[playerid])
			return Msg(playerid, "Már dolgozol...", false, COLOR_LIGHTBLUE);
		
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
		return Msg(playerid, "Nem vagy mentõs!");
	if(sscanf(params, "r", player))
		return Msg(playerid, "Használata: /drogteszt [id/név]", false, COLOR_WHITE);
	if(player == INVALID_PLAYER_ID)
		return Msg(playerid, "Nincs ilyen játékos");
	if(GetDistanceBetweenPlayers(playerid,player) > 3)
		return Msg(playerid, "Õ nincs a közeledben!");
	if(playerid == player)
		return Msg(playerid, "Magadat nem...");
	if((GetPlayerDistanceFromVehicle(playerid, GetClosestVehicle(playerid, false, 416)) > 5) && GetPlayerVirtualWorld(playerid) != 104)
		return Msg(playerid, "Nincs a közeledben mentõautó vagy nem vagy kórházban!");
	
	format(string, sizeof(string), "Drogtesztet szeretne csináltatni veled: %s | Elfogadás: /accept drogteszt", ICPlayerName(playerid));
	SendClientMessage(player, COLOR_YELLOW, string);
	format(string, sizeof(string), "Drogtesztet szeretnél csináltatni vele: %s", ICPlayerName(player));
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
		format(string, sizeof(string), "(( OOC: Még %d percig mutatható ki a drog. ))", ((PlayerInfo[playerid][pDrogozott] - UnixTime) / 60));
		SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
	}
	else
		return Msg(playerid, "(( OOC: Nem állsz droghatás alatt. ))", false, COLOR_GREY);
	return 1;
}

ALIAS(sz5ktet):szoktet;
CMD:szoktet(playerid, params[])
{
	if(IsACop(playerid)) return Msg(playerid, "Na persze...");
	
	new player;
	if(sscanf(params, "r", player)) return Msg(playerid, "Használata: /szöktet [id]", false, COLOR_WHITE);
	
	if(player == INVALID_PLAYER_ID) return Msg(playerid, "Nincs ilyen játékos");
	if(playerid == player) return Msg(playerid, "Magadat???");
	if(GetDistanceBetweenPlayers(playerid, player) > 5.0) return Msg(playerid, "Nincs a közeledben");
	if(PlayerInfo[player][pJailed] == 0) return Msg(playerid, "Õ nincs börtönben!");
	if(szallit[player] == NINCS) return Msg(playerid, "Õt nem szállítják");
	if(GetVehicleModel(GetPlayerVehicleID(player)) != 427) return Msg(playerid, "Õ már meg van szöktetve!");
	if(MunkaFolyamatban[playerid] == 1) return Msg(playerid, "Nyugi már...");
	
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
	if(!IsACop(playerid)) return Msg(playerid, "Csak rendõrök tudnak átszállítani!");
	if(!OnDuty[playerid]) return Msg(playerid, "Nem vagy szolgálatban!");
	
	new param[32], func[256];
	if(sscanf(params, "s[32]S()[256]", param, func)) return Msg(playerid, "Használata: /szállít [kezd/vége]", false, COLOR_WHITE);
	
	if(egyezik(param, "kezd"))
	{
		new player, oka[128];
		if(sscanf(func, "rs[256]", player, oka)) return Msg(playerid, "/szállít kezd [id] [oka]", false, COLOR_WHITE);
		if(player == INVALID_PLAYER_ID) return Msg(playerid, "Nincs ilyen játékos.");
		if(playerid == player) return Msg(playerid, "Magadat hová szállítanád?");
		if(PlayerInfo[player][pJailed] <= 10 && PlayerInfo[player][pJailed] >= 13) return Msg(playerid, "Õ nincs börtönben!");
		if(PlayerInfo[player][pJailTime] / 60 <= 10) return Msg(playerid, "Neki már kevesebb mint 10 perce van!");
		if(szallit[player] != NINCS) return Msg(playerid, "Õt már szállítják!");
		if(szallitasz[playerid]) return Msg(playerid, "Te már szállítasz!");
		if(!IsAt(playerid, IsAt_szallitHely)) return Msg(playerid, "Itt nem tudsz szállítani!");
		if(!IsPlayerInAnyVehicle(playerid)) return Msg(playerid, "Nem vagy kocsiban!");
		if(GetVehicleModel(GetPlayerVehicleID(playerid)) != 427) return Msg(playerid, "Ezzel a kocsival nem tudsz szállítani!");
		
		cella[playerid] = szabadCella();
		cella[player] = cella[playerid];
		if(szabadCella() == NINCS) return Msg(playerid, "Nincs szabad hely az Alcatrazba! Nem tudsz szállítani!");
		
		new rang = PlayerInfo[playerid][pRank];
		if(LMT(playerid, FRAKCIO_SCPD) && rang >= 5) // LSPD 10
		{
			if(PlayerInfo[player][pJailed] != 10) return Msg(playerid, "Õ nem a ti börtönötökben van!");
		}
		else if(LMT(playerid, FRAKCIO_SFPD) && rang >= 5) // SHERIFF 11
		{
			if(PlayerInfo[player][pJailed] != 11) return Msg(playerid, "Õ nem a ti börtönötökben van!");
		}
		else if(LMT(playerid, FRAKCIO_KATONASAG) && rang >= 5) // KATONASÁG 12
		{
			// Mindenhonnan tud szállítani // lesz még valami csak sietek munkába, kövi resi
		}
		else if(LMT(playerid, FRAKCIO_FBI)) // FBI 13
		{
			// Mindenhonnan tud szállítani // lesz még valami csak sietek munkába, kövi resi
		}
		else
			return Msg(playerid, "Te nem tudsz szállítani!");
		
		CopMsgFormat(TEAM_BLUE_COLOR, "** %s %s elkezdte szállítani %s rabot az Alcatrazba! **", ICPlayerName(playerid), PlayerInfo[playerid][pRank], ICPlayerName(player));
		CopMsgFormat(TEAM_BLUE_COLOR, "** Oka: %s **", oka);
		SendClientMessage(player, TEAM_BLUE_COLOR, "Elkezdtek átszállítani az Alcatraz fegyenctelepre!");
		SendClientMessageToAll(TEAM_BLUE_COLOR, "** Egy rabot elkezdtek átszállítani az Alcatraz fegyenctelepre! **");
		szallit[player] = playerid;
		szallitasz[playerid] = true;
				
		CellaInfo[cella[playerid]][cId] = player;
		CellaInfo[cella[playerid]][cVan] = true;
		SetPlayerInterior(player, 0);
		SetPlayerVirtualWorld(player, 0);
		PutPlayerInVehicle(player, GetPlayerVehicleID(playerid), 3);
	}
	if(egyezik(param, "vége") || egyezik(param, "vege"))
	{
		new player;
		if(sscanf(func, "r", player)) return Msg(playerid, "Használata: /szállít vége [id]");
		if(player == INVALID_PLAYER_ID) return Msg(playerid, "Ilyen játékos nem létezik");
		
		if(szallit[player] == NINCS) return Msg(playerid, "Õt nem szállítod!");
		
		if(!PlayerToPoint(5.0, playerid, 215.050, 1862.741, 13.140)) return Msg(playerid, "Itt nem tudod leadni!");
		
		PlayerInfo[player][pJailed] = 14;
		SetPlayerInterior(player, 0);
		SetPlayerVirtualWorld(player, 126, "jail14");
		Freeze(player, 5000);
		SetPlayerPos(player, fortCellak[cella[playerid]][0], fortCellak[cella[playerid]][1], fortCellak[cella[playerid]][2]);
		SetPlayerSpecialAction(player, SPECIAL_ACTION_NONE);
		
		CopMsgFormat(TEAM_BLUE_COLOR, "** %s leszállította %s rabot az Alcatrazba! **", ICPlayerName(playerid), ICPlayerName(player));
		SendClientMessage(player, TEAM_BLUE_COLOR, "Átszállítottak!");
		SendClientMessageToAll(TEAM_BLUE_COLOR, "** A rabot átszállították az Alcatraz fegyenctelepre! **");
		szallit[player] = NINCS;
		szallitasz[playerid] = false;
	}
	
	return 1;
}

ALIAS(fi):figyelem;
CMD:figyelem(playerid, params[])
{
	if(!LMT(playerid, FRAKCIO_KATONASAG)) return Msg(playerid, "Te nem vagy katona");
	if(!PlayerToPoint(5, playerid, 1339.330, 1511.309, 14.990)) return Msg(playerid, "Itt nem tudod használni!");
	
	new uzenet[256];
	if(sscanf(params, "s[256]", uzenet)) return Msg(playerid, "Használata: /fi [üzenet]", false, COLOR_WHITE);
	
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
	if(!PlayerToPoint(5, playerid, 1339.330, 1511.309, 14.990)) return Msg(playerid, "Itt nem tudod használni!");
	
	new param[32];
	if(sscanf(params, "s[32]", param)) return Msg(playerid, "Használata: /udvar [nyit/zár]", false, COLOR_WHITE);
	
	if(egyezik(param, "nyit"))
	{
		MoveDynamicObject(audvar, 1382.17554, 1503.19678, 13.9860, 1);

		CopMsgFormat(COLOR_LIGHTRED, "** [Alcatraz] Figyelem %s kinyitotta az udvar ajtaját! **", ICPlayerName(playerid));
		for(new i = 0; i < MAX_PLAYERS; i++)
		{
			if(PlayerInfo[i][pJailed] == 14)
				SendClientMessage(playerid, COLOR_LIGHTRED, "** [Alcatraz] Figyelem! Az udvarra a kijárás engedélyezett! **");
		}
	}
	else if(egyezik(param, "zár") || egyezik(param, "zar"))
	{
		MoveDynamicObject(audvar, 1382.17554, 1503.19678, 10.97000, 1);
		
		CopMsgFormat(COLOR_LIGHTRED, "** [Alcatraz] Figyelem %s bezárta az udvar ajtaját! **", ICPlayerName(playerid));
	}
	
	return 1;
}

CMD:cella(playerid, params[])
{
	if(!LMT(playerid, FRAKCIO_KATONASAG)) return Msg(playerid, "Te nem vagy katona!");
	if(!PlayerToPoint(5, playerid, 1339.330, 1511.309, 14.990)) return Msg(playerid, "Itt nem tudod használni!");
	
	new param[32];
	if(sscanf(params, "s[32]", param)) return Msg(playerid, "Használata: /cella [nyit/zár]", false, COLOR_WHITE);
	
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
		
		CopMsgFormat(COLOR_LIGHTRED, "** [Alcatraz] Figyelem %s kinyitotta a cellák ajtaját! **", ICPlayerName(playerid));
	}
	else if(egyezik(param, "zár") || egyezik(param, "zar"))
	{
		for(new i=0; i<sizeof(fortKapuBal); i++)
		{
			MoveDynamicObject(fortKapuBalObj[i], fortKapuBal[i][0], fortKapuBal[i][1], fortKapuBal[i][2], 1);
		}
		for(new i=0; i<sizeof(fortKapuJobb); i++)
		{
			MoveDynamicObject(fortKapuJobbObj[i], fortKapuJobb[i][0], fortKapuJobb[i][1], fortKapuJobb[i][2], 1);
		}
		
		CopMsgFormat(COLOR_LIGHTRED, "** [Alcatraz] Figyelem %s bezárta a cellák ajtaját! **", ICPlayerName(playerid));
	}
	
	return 1;
}

CMD:bmunka(playerid, params[])
{
	if(PlayerInfo[playerid][pJailed] != 14) return Msg(playerid, "Nem vagy az Alcatraz börtönben!");
	if(!IsAt(playerid, IsAt_bMunkaHely)) return Msg(playerid, "Itt nem tudod elkezdeni egyik munkát sem");
	
	new param[32];
	if(sscanf(params, "s[32]", param)) return Msg(playerid, "Használata: /bmunka [takarító/bányász/felmond/segitseg]");
	
	//if(PlayerInfo[playerid][pBmunka] != NINCS) SendFormatMessage(playerid, COLOR_RED, "Már van munkád: %s", PlayerInfo[playerid][pBmunka]);
	
	if(egyezik(param, "takarító") || egyezik(param, "takarito"))
	{
		Msg(playerid, "Elkezdted a munkát: Takarító");
			
		PlayerInfo[playerid][pBmunka] = MUNKA_BTAKARITO;
		Msg(playerid, "Felvetted a Takarító munkát! Kezdj el takarítani!");
		
		RemovePlayerAttachedObject(playerid, ATTACH_SLOT_SISAK);
		
		btakaritok = random(sizeof(bTakarito));
		SetPlayerCheckpoint(playerid, bTakarito[btakaritok][0], bTakarito[btakaritok][1], bTakarito[btakaritok][2], 1.0);
	}
	else if(egyezik(param, "bányász") || egyezik(param, "banyasz"))
	{
		Msg(playerid, "Elkezdted a munkát: Bányász");
			
		PlayerInfo[playerid][pBmunka] = MUNKA_BBANYASZ;
		Msg(playerid, "Felvetted a Bányász munkát! Kezdj el bányászni!");
		
		SetPlayerAttachedObject(playerid, ATTACH_SLOT_SISAK, 1636, 1, 0.125999, -0.119999, -0.129999, 0.000000, -67.199996, 0.000000);
		
		bbanyaszk = random(sizeof(bBanyasz));
		SetPlayerCheckpoint(playerid, bBanyasz[bbanyaszk][0], bBanyasz[bbanyaszk][1], bBanyasz[bbanyaszk][2], 3);
	}
	else if(egyezik(param, "felmond"))
	{
		PlayerInfo[playerid][pBmunka] = NINCS;
		return Msg(playerid, "Felmondtál!");
	}
	else if(egyezik(param, "help") || egyezik(param, "segítség") || egyezik(param, "segitseg"))
	{
		Msg(playerid, "========== [ Takarító ] ==========", false, COLOR_WHITE);
		Msg(playerid, "HendRoox ne felejtsd el kitölteni! :D", false, COLOR_WHITE);
		Msg(playerid, "========== [  Bányász ] ==========", false, COLOR_WHITE);
		Msg(playerid, "HendRoox ne felejtsd el kitölteni! :D", false, COLOR_WHITE);
	}
	else
		return Msg(playerid, "Nincs ilyen parancs!");
	
	
	return 1;
}

CMD:rabok(playerid, params[])
{
	if(!IsACop(playerid) && !Admin(playerid, 1)) return Msg(playerid, "Nem vagy rendvédelmi szervezet tagja.");
	
	// LSPD SHERIFF KATONASÁG FBI
	new param[32];
	if(sscanf(params, "s[32]", param)) return Msg(playerid, "Használata: /rabok [LSPD / FBI / Sheriff / Katonaság / Fegyenctelep]");
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
	                format(string, sizeof(string), "Név: %s | Ido: %dmp(%dp) | Óvadék:%s | Oka: %s", ICPlayerName(p), PlayerInfo[p][pJailTime], floatround(float(PlayerInfo[p][pJailTime] / 60)), FormatNumber( PlayerInfo[p][pOvadek], 0, ',' ), PlayerInfo[p][pJailOK]);
				else
				    format(string, sizeof(string), "Név: %s | Ido: %dmp(%dp) | Óvadék:Nincs | Oka: %s", ICPlayerName(p), PlayerInfo[p][pJailTime], floatround(float(PlayerInfo[p][pJailTime] / 60)), PlayerInfo[p][pJailOK]);
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
	                format(string, sizeof(string), "Név: %s | Ido: %dmp(%dp) | Óvadék:%s | Oka: %s", ICPlayerName(p), PlayerInfo[p][pJailTime], floatround(float(PlayerInfo[p][pJailTime] / 60)), FormatNumber( PlayerInfo[p][pOvadek], 0, ',' ), PlayerInfo[p][pJailOK]);
				else
				    format(string, sizeof(string), "Név: %s | Ido: %dmp(%dp) | Óvadék:Nincs | Oka: %s", ICPlayerName(p), PlayerInfo[p][pJailTime], floatround(float(PlayerInfo[p][pJailTime] / 60)), PlayerInfo[p][pJailOK]);
                SendClientMessage(playerid, COLOR_YELLOW, string);
				rabok++;
            }
        }
		SendFormatMessage(playerid, COLOR_LIGHTBLUE, "======= Sheriff (%ddb) =======", rabok);
	}
	else if(egyezik(param, "katonasag") || egyezik(param, "katonaság"))
	{
		SendClientMessage(playerid, COLOR_LIGHTBLUE, "========== Katonaság ==========");
        for(new p = 0; p < MAX_PLAYERS; p++)
        {
            if(PlayerInfo[p][pJailed] == 12 && PlayerInfo[p][pJailTime] > 0)
            {
                if(PlayerInfo[p][pOvadek] > 0)
	                format(string, sizeof(string), "Név: %s | Ido: %dmp(%dp) | Óvadék:%s | Oka: %s", ICPlayerName(p), PlayerInfo[p][pJailTime], floatround(float(PlayerInfo[p][pJailTime] / 60)), FormatNumber( PlayerInfo[p][pOvadek], 0, ',' ), PlayerInfo[p][pJailOK]);
				else
				    format(string, sizeof(string), "Név: %s | Ido: %dmp(%dp) | Óvadék:Nincs | Oka: %s", ICPlayerName(p), PlayerInfo[p][pJailTime], floatround(float(PlayerInfo[p][pJailTime] / 60)), PlayerInfo[p][pJailOK]);
                SendClientMessage(playerid, COLOR_YELLOW, string);
				rabok++;
            }
        }
		SendFormatMessage(playerid, COLOR_LIGHTBLUE, "======= Katonaság (%ddb) =======", rabok);
	}
	else if(egyezik(param, "fbi"))
	{
		SendClientMessage(playerid, COLOR_LIGHTBLUE, "========== FBI ==========");
        for(new p = 0; p < MAX_PLAYERS; p++)
        {
            if(PlayerInfo[p][pJailed] == 13 && PlayerInfo[p][pJailTime] > 0)
            {
                if(PlayerInfo[p][pOvadek] > 0)
	                format(string, sizeof(string), "Név: %s | Ido: %dmp(%dp) | Óvadék:%s | Oka: %s", ICPlayerName(p), PlayerInfo[p][pJailTime], floatround(float(PlayerInfo[p][pJailTime] / 60)), FormatNumber( PlayerInfo[p][pOvadek], 0, ',' ), PlayerInfo[p][pJailOK]);
				else
				    format(string, sizeof(string), "Név: %s | Ido: %dmp(%dp) | Óvadék:Nincs | Oka: %s", ICPlayerName(p), PlayerInfo[p][pJailTime], floatround(float(PlayerInfo[p][pJailTime] / 60)), PlayerInfo[p][pJailOK]);
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
	                format(string, sizeof(string), "Név: %s | Ido: %dmp(%dp) | Óvadék:%s | Oka: %s", ICPlayerName(p), PlayerInfo[p][pJailTime], floatround(float(PlayerInfo[p][pJailTime] / 60)), FormatNumber( PlayerInfo[p][pOvadek], 0, ',' ), PlayerInfo[p][pJailOK]);
				else
				    format(string, sizeof(string), "Név: %s | Ido: %dmp(%dp) | Óvadék:Nincs | Oka: %s", ICPlayerName(p), PlayerInfo[p][pJailTime], floatround(float(PlayerInfo[p][pJailTime] / 60)), PlayerInfo[p][pJailOK]);
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
		return SendClientMessage(playerid, COLOR_WHITE, "Használat: /engedgov [játékos]");
		
	if(!IsACop(player)) return Msg(playerid, "Csak rendõröknek adhatsz gov engedélyt!");
	
	GovEngedely[player] = true;
	
	Msg(playerid, "Adtál neki engedélyt hogy govoljon!");
	Msg(player, "Egy admin engedélyt adott a govolásra!");
	
	return 1;
}

CMD:tiltgov(playerid, params[])
{
	if(!Admin(playerid, 1)) return 1;
	new player;
	if(sscanf(params, "u", player))
		return SendClientMessage(playerid, COLOR_WHITE, "Használat: /tiltgov [játékos]");
		
	if(!IsACop(player)) return Msg(playerid, "Csak rendõröktõl vehetsz el gov engedélyt!");
	
	GovEngedely[player] = false;
	
	Msg(playerid, "Elvetted az engedélyét hogy govoljon!");
	Msg(player, "Elvették az engedélyed hogy govolj!");
	
	return 1;
}

CMD:customhud(playerid, params[])
{
	new mit[128];
	new mire;
	if(sscanf(params, "s[128]d", mit, mire))
	{
		Msg(playerid, "/customhud [opcio] [0/1]");
		Msg(playerid, "Opció: fegyver/weapon - a GTA:SA/models/txd mappában kell lennie egy");
		Msg(playerid, "Opció: fegyver/weapon - class_custom_weapons.txd fájlnak (amit te csinálsz)");
		Msg(playerid, "Opció: fegyver/weapon - A benne található fájloknak 256x256os méretûnek kell lenniük");
		Msg(playerid, "Opció: fegyver/weapon - és a nevük a fegyver idjével kell megegyezzen (+c)");
		Msg(playerid, "Opció: fegyver/weapon - pl: 30c - AK47, 0c - ököl stb..");
		Msg(playerid, "Opció: fegyver/weapon - FIGYELEM!! Ha egy fegyverre nem raksz icont nem fog megjelenni!");
		
		return 1;
	}
	
	if(!egyezik(mit, "fegyver") && !egyezik(mit, "weapon")) return Msg(playerid, "Egyenlõre csak ez az 1 opció van!");
	
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