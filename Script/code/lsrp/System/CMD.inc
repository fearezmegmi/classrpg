public OnPlayerCommandText(playerid, cmdtext[])
{
	if(!IsValidPlayerID(playerid))
	{
		Msg(playerid, "Valami hiba történt!");
		return 0;
	}
	
	if(strlen(cmdtext) < 1) return 1;
	
	AFKIdo[playerid] = 0;
	new string[256];
	new playermoney;
	new sendername[MAX_PLAYER_NAME];
	new giveplayer[MAX_PLAYER_NAME];
	new playername[MAX_PLAYER_NAME];
	new cmd[256];
	new tmp[256];
	//new backupask;
	new giveplayerid, moneys, idx;
	new veh = -1, pveh = -1;

	new params = Parameterek(cmdtext);
	new param[10][32];

	if(params > 0)
	{
		new params_szamlalo = 1;
		while(params_szamlalo <= params && params_szamlalo < sizeof(param))
		{
			param[params_szamlalo] = GetParam(cmdtext, params_szamlalo);
			params_szamlalo++;
		}
	}

	#pragma unused pveh

	cmd = strtok(cmdtext, idx);
	
	strmid(UtolsoCMD[playerid], cmd, 0, strlen(cmd));
	
	DebugMessage("%s beírta a következõ parancsot: %s", PlayerName(playerid), cmdtext);
	
	if(IsPlayerInAnyVehicle(playerid))
	{
		veh = GetPlayerVehicleID(playerid);
		pveh = GetVehicleModel(veh);
	}
	if(egyezik(cmd, "/login"))
		format(string, sizeof(string), "%s - /login", PlayerName(playerid));
	else
		format(string, sizeof(string), "%s - %s", PlayerName(playerid), cmdtext);
		
	CommandLog(string);

	if(!Logged(playerid))
	{
		new NemLoginParancs = 0;
		new NemLoginParancsok[2][] = 
		{
			"/login", "/pm"
		};

		for(new parancs = 0; parancs < sizeof(NemLoginParancsok); parancs++)
		{
			if(!strcmp(cmd, NemLoginParancsok[parancs], true))
			{
				NemLoginParancs = 1;
				break;
			}
		}
		if(!NemLoginParancs)
		{
			return Msg(playerid, "Elõbb be kell jelentkezned!");
		}
	}
	
	if(AFK[playerid] && !egyezik(cmd, "/afk"))
	{
		Msg(playerid, "AFK módban vagy, elõbb kapcsold ki! (/afk)");
		return 1;
	}
	
	/*################################################################################################################################################################
	################################################################################################################################################################
	################################################################################################################################################################*/
	
	if(egyezik(cmd, "/stopzene"))
	{
		StopZene(playerid);
		Msg(playerid, "StopZene aktiválva!");
		return 1;
	}
	
	if(egyezik(cmd, "/prisongate"))
	{
		new 
			Float:EnterRadiusz = 5.0,
			kocsi = GetPlayerVehicleID(playerid)
		;
		
		if(!IsACop(playerid)) return Msg(playerid, "Csak rendvédelmi tagok számára!");
		
		if(PlayerToPoint(EnterRadiusz, playerid, 1827.6140, -1540.6327, 13.1930))
		{
			if(GetPlayerState(playerid) == 2) 
			{
				SetVehiclePos(kocsi, 1818.6265,-1537.0571,13.1111);
				SetVehicleZAngle(kocsi, 86.0424);
			} 
			else {
				SetPlayerPos(playerid, 1818.6265,-1537.0571,13.1111);
			}
		}
		else if(PlayerToPoint(EnterRadiusz, playerid, 1818.6265,-1537.0571,13.1111))
		{
			if(GetPlayerState(playerid) == 2) 
			{
				SetVehiclePos(kocsi, 1827.6140, -1540.6327, 13.1930);
				SetVehicleZAngle(kocsi, 162.9418);
			} 
			else {
				SetPlayerPos(playerid, 1827.6140, -1540.6327, 13.1930);
			}
		}
		else {
			Msg(playerid, "Nem vagy a börtön garázsa elõtt!");
		}
		return 1;
	}
	
	if(egyezik(cmd, "/eradio") || egyezik(cmd, "/er"))
	{
	    if(!Bortonben(playerid))
	    {
			if(ElvettRadio[playerid][rFrakcio] == NINCS) return Msg(playerid, "Nincs elvett rádiód!");
			if(Kezenlove[playerid]) return Msg(playerid, "Nem tudsz rádiózni, mert meglõtték a kezed!");
			if(FrakcioInfo[ElvettRadio[playerid][rFrakcio]][fJelado] == 0 && IsMafia(ElvettRadio[playerid][rFrakcio]) && IsBanda(ElvettRadio[playerid][rFrakcio])) return Msg(playerid, "Nincs jeladótok! ((Leader vehet, /jeladó))");
			//if(RadioElveve[playerid]) return Msg(playerid, "Elvették a rádiódat, nem tudsz beszélni!");
			if(!HatoSugaronBelul(playerid) && IsMafia(ElvettRadio[playerid][rFrakcio]) && IsBanda(ElvettRadio[playerid][rFrakcio])) return Msg(playerid, "Nem vagy a frakció jeladójának sugarán belül!");
			if(Csendvan) return Msg(playerid, "Most nem beszélhetsz!");
			new length = strlen(cmdtext);
			while ((idx < length) && (cmdtext[idx] <= ' '))
			{
				idx++;
			}
			new offset = idx;
			new result[128];
			while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
			{
				result[idx - offset] = cmdtext[idx];
				idx++;
			}
			result[idx - offset] = EOS;
			if(!strlen(result))
			{
				Msg(playerid, "(/er)adio [radio chat]");
				return 1;
			}

			if(SzovegEllenorzes(playerid, result, "/er"))
				return 1;

			if(PlayerInfo[playerid][pMember] > 0)
			{
				format(string, sizeof(string), "** %s %s: *ismeretlen hang*%s **", GetPlayerRangNev(playerid), ElvettRadio[playerid][rNev], result);
				
				if(ElvettRadio[playerid][rFrakcio] == LMUNKA_FBI)
					SendFamilyMessage(ElvettRadio[playerid][rFrakcio], COLOR_LILA, string);
				else if(ElvettRadio[playerid][rFrakcio] == LMUNKA_LSPD)
					SendFamilyMessage(ElvettRadio[playerid][rFrakcio], COLOR_LILA, string);
				else if(ElvettRadio[playerid][rFrakcio] == LMUNKA_SZERELO)
					SendFamilyMessage(ElvettRadio[playerid][rFrakcio], COLOR_LIMEGREEN, string);
				else if(ElvettRadio[playerid][rFrakcio] == LMUNKA_SWAT)
					SendFamilyMessage(ElvettRadio[playerid][rFrakcio], COLOR_ORANGE, string);
				else if(ElvettRadio[playerid][rFrakcio] == LMUNKA_MENTO)
					SendFamilyMessage(ElvettRadio[playerid][rFrakcio], COLOR_YELLOW, string);
				else if(ElvettRadio[playerid][rFrakcio] == LMUNKA_GSF)
					SendFamilyMessage(ElvettRadio[playerid][rFrakcio], TEAM_Surenos_COLOR, string);
				else if(ElvettRadio[playerid][rFrakcio] == LMUNKA_BALLAS)
					SendFamilyMessage(ElvettRadio[playerid][rFrakcio], COLOR_LILA, string);
				else if(ElvettRadio[playerid][rFrakcio] == LMUNKA_GSF)
					SendFamilyMessage(ElvettRadio[playerid][rFrakcio], 0xA300ff00, string);
				else if(ElvettRadio[playerid][rFrakcio] == LMUNKA_UM)
					SendFamilyMessage(ElvettRadio[playerid][rFrakcio], COLOR_WHITE, string);
				else if(ElvettRadio[playerid][rFrakcio] == LMUNKA_CAMORRA)
					SendFamilyMessage(ElvettRadio[playerid][rFrakcio], 0xA38D5DFF, string);
				else
					SendFamilyMessage(ElvettRadio[playerid][rFrakcio], TEAM_BLUE_COLOR, string);

				printf("%s", string);
				Beszed(20.0, playerid, result,BESZED_RADIO);
				SetPlayerChatBubble(playerid, "* Beszélt valamit...", COLOR_PURPLE, 5, 2000);
				return 1;
			}
			else
			{
				Msg(playerid, "Nem vagy szervezet tagja!");
				return 1;
			}
		}
		else
			Msg(playerid, "Börtönben nem lehet!");

		return 1;
	}
	
	if(egyezik(cmd, "/eradiob") || egyezik(cmd, "/erb"))
	{
	    if(!Bortonben(playerid))
	    {
			if(ElvettRadio[playerid][rFrakcio] == NINCS) return Msg(playerid, "Nincs elvett rádiód!");
			if(Kezenlove[playerid]) return Msg(playerid, "Nem tudsz rádiózni, mert meglõtték a kezed!");
			if(FrakcioInfo[ElvettRadio[playerid][rFrakcio]][fJelado] == 0 && IsMafia(ElvettRadio[playerid][rFrakcio]) && IsBanda(ElvettRadio[playerid][rFrakcio])) return Msg(playerid, "Nincs jeladótok! ((Leader vehet, /jeladó))");
			//if(RadioElveve[playerid]) return Msg(playerid, "Elvették a rádiódat, nem tudsz beszélni!");
			if(!HatoSugaronBelul(playerid) && IsMafia(ElvettRadio[playerid][rFrakcio]) && IsBanda(ElvettRadio[playerid][rFrakcio])) return Msg(playerid, "Nem vagy a frakció jeladójának sugarán belül!");
			if(Csendvan) return Msg(playerid, "Most nem beszélhetsz!");
			new length = strlen(cmdtext);
			while ((idx < length) && (cmdtext[idx] <= ' '))
			{
				idx++;
			}
			new offset = idx;
			new result[128];
			while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
			{
				result[idx - offset] = cmdtext[idx];
				idx++;
			}
			result[idx - offset] = EOS;
			if(!strlen(result))
			{
				Msg(playerid, "(/er)adio(b) [radio chat]");
				return 1;
			}

			if(SzovegEllenorzes(playerid, result, "/erb"))
				return 1;

			if(PlayerInfo[playerid][pMember] > 0)
			{
				format(string, sizeof(string), "(( %s %s OOC: *ismeretlen hang*%s )) **", GetPlayerRangNev(playerid), ElvettRadio[playerid][rNev], result);
				
				if(ElvettRadio[playerid][rFrakcio] == LMUNKA_FBI)
					SendFamilyMessage(ElvettRadio[playerid][rFrakcio], COLOR_LILA, string);
				else if(ElvettRadio[playerid][rFrakcio] == LMUNKA_LSPD)
					SendFamilyMessage(ElvettRadio[playerid][rFrakcio], COLOR_LILA, string);
				else if(ElvettRadio[playerid][rFrakcio] == LMUNKA_SZERELO)
					SendFamilyMessage(ElvettRadio[playerid][rFrakcio], COLOR_LIMEGREEN, string);
				else if(ElvettRadio[playerid][rFrakcio] == LMUNKA_SWAT)
					SendFamilyMessage(ElvettRadio[playerid][rFrakcio], COLOR_ORANGE, string);
				else if(ElvettRadio[playerid][rFrakcio] == LMUNKA_MENTO)
					SendFamilyMessage(ElvettRadio[playerid][rFrakcio], COLOR_YELLOW, string);
				else if(ElvettRadio[playerid][rFrakcio] == LMUNKA_GSF)
					SendFamilyMessage(ElvettRadio[playerid][rFrakcio], TEAM_Surenos_COLOR, string);
				else if(ElvettRadio[playerid][rFrakcio] == LMUNKA_BALLAS)
					SendFamilyMessage(ElvettRadio[playerid][rFrakcio], COLOR_LILA, string);
				else if(ElvettRadio[playerid][rFrakcio] == LMUNKA_GSF)
					SendFamilyMessage(ElvettRadio[playerid][rFrakcio], 0xA300ff00, string);
				else if(ElvettRadio[playerid][rFrakcio] == LMUNKA_UM)
					SendFamilyMessage(ElvettRadio[playerid][rFrakcio], COLOR_WHITE, string);
				else if(ElvettRadio[playerid][rFrakcio] == LMUNKA_CAMORRA)
					SendFamilyMessage(ElvettRadio[playerid][rFrakcio], 0xA38D5DFF, string);
				else
					SendFamilyMessage(ElvettRadio[playerid][rFrakcio], TEAM_BLUE_COLOR, string);

				printf("%s", string);
				Beszed(20.0, playerid, result,BESZED_OOCRADIO);
				SetPlayerChatBubble(playerid, "* Beszélt valamit...", COLOR_PURPLE, 5, 2000);
				return 1;
			}
			else
			{
				Msg(playerid, "Nem vagy szervezet tagja!");
				return 1;
			}
		}
		else
			Msg(playerid, "Börtönben nem lehet!");

		return 1;
	}
	
	if(egyezik(cmd, "/ed"))
	{
	    if(IsValidPlayerID(playerid))
	    {
			if(ElvettRadio[playerid][rFrakcio] == NINCS) return Msg(playerid, "Nincs elvett rádiód!");
			if(Kezenlove[playerid]) return Msg(playerid, "Nem tudsz rádiózni, mert meglõtték a kezed!");
			new rName[256];
			rName = PlayerName(playerid);
				
			new length = strlen(cmdtext);
			while ((idx < length) && (cmdtext[idx] <= ' '))
			{
				idx++;
			}
			new offset = idx;
			new result[128];
			while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
			{
				result[idx - offset] = cmdtext[idx];
				idx++;
			}
			result[idx - offset] = EOS;
			if(!strlen(result))
			{
				Msg(playerid, "(/ed)epartments [üzeneted]");
				return 1;
			}
			//if(IsOOC(result)) return Msg(playerid, "Nincs /d ooc!");
			
			format(string, sizeof(string), "** %s %s: *ismeretlen hang*%s **", GetPlayerRangNev(playerid), ElvettRadio[playerid][rNev], result);
			
			SendTeamMessage(LMUNKA_LSPD, COLOR_ALLDEPT, string);
			SendTeamMessage(LMUNKA_FBI, COLOR_ALLDEPT, string);
			SendTeamMessage(LMUNKA_MENTO, COLOR_ALLDEPT, string);
			SendTeamMessage(LMUNKA_KATONA, COLOR_ALLDEPT, string);
			SendTeamMessage(LMUNKA_NAV, COLOR_ALLDEPT, string);
			SendTeamMessage(LMUNKA_SWAT, COLOR_ALLDEPT, string);
			SendTeamMessage(LMUNKA_ALLAM, COLOR_ALLDEPT, string);
			SendTeamMessage(LMUNKA_TUZOLTO, COLOR_ALLDEPT, string);
			PlayerForeach(x)
			{
				if(!IsACop(x) && !LMT(x, LMUNKA_ALLAM) && !LMT(x, LMUNKA_MENTO) && PlayerInfo[x][pSWATTag] > 0)
					SendClientMessage(x, COLOR_ALLDEPT, string);
				else if(!IsACop(x) && !LMT(x, LMUNKA_ALLAM) && !LMT(x, LMUNKA_MENTO) && PlayerInfo[x][pNIDTag] > 0)
					SendClientMessage(x, COLOR_ALLDEPT, string);
				else if(!IsACop(x) && !LMT(x, LMUNKA_ALLAM) && !LMT(x, LMUNKA_MENTO) && PlayerInfo[x][pSWATTag] > 0 && PlayerInfo[x][pNIDTag] > 0)
					SendClientMessage(x, COLOR_ALLDEPT, string);
			}
			printf("%s", string);
			
		}
		return 1;
	}
	
	if(egyezik(cmd, "/edb"))
	{
	    if(IsValidPlayerID(playerid))
	    {
			if(ElvettRadio[playerid][rFrakcio] == NINCS) return Msg(playerid, "Nincs elvett rádiód!");
			if(Kezenlove[playerid]) return Msg(playerid, "Nem tudsz rádiózni, mert meglõtték a kezed!");
			new rName[256];
			rName = PlayerName(playerid);
				
			new length = strlen(cmdtext);
			while ((idx < length) && (cmdtext[idx] <= ' '))
			{
				idx++;
			}
			new offset = idx;
			new result[128];
			while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
			{
				result[idx - offset] = cmdtext[idx];
				idx++;
			}
			result[idx - offset] = EOS;
			if(!strlen(result))
			{
				Msg(playerid, "/(ed)epartments(b) [üzeneted]");
				return 1;
			}
			//if(IsOOC(result)) return Msg(playerid, "Nincs /d ooc!");
			
			format(string, sizeof(string), "(( %s %s OOC: *ismeretlen hang*%s )) **", GetPlayerRangNev(playerid), ElvettRadio[playerid][rNev], result);
			
			SendTeamMessage(LMUNKA_LSPD, COLOR_ALLDEPT, string);
			SendTeamMessage(LMUNKA_FBI, COLOR_ALLDEPT, string);
			SendTeamMessage(LMUNKA_MENTO, COLOR_ALLDEPT, string);
			SendTeamMessage(LMUNKA_KATONA, COLOR_ALLDEPT, string);
			SendTeamMessage(LMUNKA_NAV, COLOR_ALLDEPT, string);
			SendTeamMessage(LMUNKA_SWAT, COLOR_ALLDEPT, string);
			SendTeamMessage(LMUNKA_ALLAM, COLOR_ALLDEPT, string);
			SendTeamMessage(LMUNKA_TUZOLTO, COLOR_ALLDEPT, string);
			PlayerForeach(x)
			{
				if(!IsACop(x) && !LMT(x, LMUNKA_ALLAM) && !LMT(x, LMUNKA_MENTO) && PlayerInfo[x][pSWATTag] > 0)
					SendClientMessage(x, COLOR_ALLDEPT, string);
				else if(!IsACop(x) && !LMT(x, LMUNKA_ALLAM) && !LMT(x, LMUNKA_MENTO) && PlayerInfo[x][pNIDTag] > 0)
					SendClientMessage(x, COLOR_ALLDEPT, string);
				else if(!IsACop(x) && !LMT(x, LMUNKA_ALLAM) && !LMT(x, LMUNKA_MENTO) && PlayerInfo[x][pSWATTag] > 0 && PlayerInfo[x][pNIDTag] > 0)
					SendClientMessage(x, COLOR_ALLDEPT, string);
			}
			printf("%s", string);
			if(!Kamera[playerid])
			{
				format(string, sizeof(string), "(( [OOC-R] %s mondja: %s ))", rName, result);
				ProxDetector(20.0, playerid, string,COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5);
			}
		}
		return 1;
	}
	
		
	if(egyezik(cmd, "/vizsga"))
	{
		if(!PlayerToPoint(5.0, playerid, 2309.1904, -8.3566, 26.7422))
		{
			Msg(playerid, "Nem vagy a Driving Schoolban!");
			return 1;
		}
		if(JogsiJarmuID[playerid] != 0) return Msg(playerid, "Neked már van vizsgajármûved!");
		ShowPlayerDialog(playerid, DIALOG_JOGSIVIZSGA, DIALOG_STYLE_LIST, "Jogosítvány Kategóriák", "Személygépjármû\nMotorkerékpár", "Elkezd", "Bezár");
		return 1;
	}
	
	if(egyezik(cmd, "/vizsgakezd"))
	{
		if(jatekosJogsiCPStatusz[playerid] != 0) return Msg(playerid, "Neked már megy a vizsgád!");
		if(JogsiJarmuID[playerid] == 0) return Msg(playerid, "Nincs vizsgajármûved! (/vizsga)");
		if(!IsPlayerInAnyVehicle(playerid)) return Msg(playerid, "Nem vagy jármûben!");
		if(GetPlayerVehicleID(playerid) != JogsiJarmuID[playerid])
		{
			new Float:vehx, Float:vehy, Float:vehz;
			GetVehiclePos(JogsiJarmuID[playerid], vehx, vehy, vehz);
			Msg(playerid, "Ez nem a te vizsgajármûved! Megjelöltük a GPS-eden!");
			SetPlayerCheckpoint(playerid, vehx, vehy, vehz, 5.0);
			return 1;
		}
	
		SetPlayerCheckpoint(playerid, 1106.3140, -1743.1893, 12.9870, 5.0);
		jatekosJogsiCPStatusz[playerid] = 1;	
		return 1;
	}
	
	if(egyezik(cmd, "/apartment") OR egyezik(cmd, "/apartman"))
	{
		if(params < 1)
		{
			if(PlayerInfo[playerid][pHotelSzoba] == NINCS)
				Msg(playerid, "Használat: /apartment [Foglal]");
			else if(PlayerInfo[playerid][pHotelSzoba] != NINCS)
				Msg(playerid, "Használat: /apartment [Lemond / Nyit / Széf]");
			return 1;
		}
		if(egyezik(param[1], "foglal"))
		{
			new hotel = sizeof(HotelInfo);
			for(new h = 0; h < hotel; h++)
			{
				if(PlayerToPoint(2.0, playerid, HotelInfo[h][hEntranceX], HotelInfo[h][hEntranceY], HotelInfo[h][hEntranceZ]) && HotelInfo[h][hEladva] == 0)
				{
					if(PlayerInfo[playerid][pHotelSzoba] != NINCS)
					{
						Msg(playerid, "Már lefoglaltál egy szobát...");
						return 1;
					}
					if(GetMoney(playerid) >= HotelInfo[h][hAra])
					{
						PlayerInfo[playerid][pHotelSzoba] = h;
						HotelInfo[h][hEladva] = 1;
						strmid(HotelInfo[h][hTulaj], PlayerName(playerid), 0, strlen(PlayerName(playerid)), MAX_PLAYER_NAME+1);
						GiveMoney(playerid, -HotelInfo[h][hAra]);

						new HotelBelso = HotelInfo[h][hBelso];
						SetPlayerInterior(playerid, IntInfo[HotelBelso][iNumber]);
						SetPlayerPos(playerid, IntInfo[HotelBelso][iExitX], IntInfo[HotelBelso][iExitY], IntInfo[HotelBelso][iExitZ]);
						SetPlayerVirtualWorld(playerid, ALAPHOTELVW+h);
						GameTextForPlayer(playerid, "~w~Üdv a hotel szobádban", 5000, 3);
						PlayerInfo[playerid][pLocal] = ALAPHOTELVW+h;
						Msg(playerid, "Gratulálunk, lefoglaltad a hotelszobát!");
						Msg(playerid, "Ha szeretnél több infót /apartmenthelp");
						PlayerUpdate(playerid, "HotelSzoba='%d'", h);
						HotelUpdate(h, HOTEL_Tulaj, HOTEL_Eladva);
						
						#if defined KELLHOTELPICKUP
							OnHotelPickupUpdate(h);
						#endif
						
						return 1;
					}
					else
					{
						MsgFormat(playerid, "Nincs elég pénzed! Még $%d kell! Bérlés Ára: $%d", (HotelInfo[h][hAra] - GetMoney(playerid)), HotelInfo[h][hAra]);
						return 1;
					}
				}
			}
			return 1;
		}
		else if(egyezik(param[1], "lemond"))
		{
			new hotel = sizeof(HotelInfo);
			for(new h = 0; h < hotel; h++)
			{
				if(PlayerToPoint(2.0, playerid, HotelInfo[h][hEntranceX], HotelInfo[h][hEntranceY], HotelInfo[h][hEntranceZ]) && HotelInfo[h][hEladva] == 1 && egyezik(HotelInfo[h][hTulaj], PlayerName(playerid)))
				{
					if(PlayerInfo[playerid][pHotelSzoba] == NINCS)
					{
						Msg(playerid, "Nincs lefoglalva szobád...");
						return 1;
					}
					PlayerInfo[playerid][pHotelSzoba] = NINCS;
					HotelInfo[h][hEladva] = 0;
					strmid(HotelInfo[h][hTulaj], "Nincs_Tulaj", 0, strlen("Nincs_Tulaj"),MAX_PLAYER_NAME+1);
					Msg(playerid, "Sikeresen lemondtad a hotelszobát!");
					PlayerUpdate(playerid, "HotelSzoba='%d'", NINCS);
					HotelUpdate(h, HOTEL_Tulaj, HOTEL_Eladva);
					
					#if defined KELLHOTELPICKUP
						OnHotelPickupUpdate(h);
					#endif
					
					return 1;
				}
			}
			return 1;
		}
		else if(egyezik(param[1], "nyit") || egyezik(param[1], "zár"))
		{
			new hotel = HoteleElottVan(playerid);
			if(hotel == NINCS)
				hotel = HotelebenVan(playerid);

			if(hotel != NINCS || PlayerToPoint(20.0,playerid, 210.0833,252.9767,902.3516) || PlayerToPoint(20.0,playerid,616.9026,-76.5984,997.9922))
			{
				if(PlayerToPoint(20.0,playerid, 210.0833,252.9767,902.3516))
					hotel = PlayerInfo[playerid][pLocal];
				else if(PlayerToPoint(20.0,playerid,616.9026,-76.5984,997.9922))
					hotel = GetPlayerVirtualWorld(playerid);

				if(HotelInfo[hotel][hZarva] == 1)
				{
					HotelInfo[hotel][hZarva] = 0;
					HotelUpdate(hotel, HOTEL_Zarva);
					GameTextForPlayer(playerid, "~w~Ajtó ~g~nyitva", 5000, 6);
					PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
					format(string, sizeof(string), "* Valaki kinyitotta a hotelszoba ajtaját.");
					ProxDetector(30.0, playerid,string , COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
					return 1;
				}
				else if(HotelInfo[hotel][hZarva] == 0)
				{
					HotelInfo[hotel][hZarva] = 1;
					HotelUpdate(hotel, HOTEL_Zarva);
					GameTextForPlayer(playerid, "~w~Ajtó ~r~zárva", 5000, 6);
					PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
					format(string, sizeof(string), "* Valaki bezárta a hotelszoba ajtaját.");
					ProxDetector(30.0, playerid,string , COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
					return 1;
				}
			}
		}
		else if(egyezik(param[1], "széf"))
		{
			if(params < 2) return Msg(playerid, "Használat: /apartment széf [Berak / Kivesz / Megnéz]");
			
			if(egyezik(param[2], "megnéz") || egyezik(param[2], "megnez"))
			{
				if(Nincsbelepve(playerid)) return 1;

				if(NincsHotele(playerid)) return Msg(playerid, "Nincs apartmanod!");

				if(HotelebenVan(playerid) == NINCS) return Msg(playerid, "Nem vagy a apartmanodban!");

				new hotel = HotelebenVan(playerid);
				new penz, kaja, cigis, kokain, heroin, marihuana, material,orvossag;
				penz = HotelInfo[hotel][hPenz];
				cigis = HotelInfo[hotel][hCigi];
				kaja = HotelInfo[hotel][hKaja];
				kokain = HotelInfo[hotel][hKokain];
				heroin = HotelInfo[hotel][hHeroin];
				marihuana = HotelInfo[hotel][hMarihuana];
				material = HotelInfo[hotel][hMati];
				orvossag = HotelInfo[hotel][hGyogyszer];
				SendClientMessage(playerid, COLOR_YELLOW, ValasztoVonal("Apartman széf"));
				SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Pénz: $%d | Kaja: %ddb/%ddb | Cigi: %ddb/%ddb | Material: %ddb/%ddb", penz, MAXHAZKAJA, kaja, MAXHAZCIGI, cigis, MAXHAZMATI, material);
				SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Kokain: %dg/%dg | Heroin: %dg/%dg | Marihuana: %dg/%dg", MAXHAZKOKAIN, kokain, MAXHAZHEROIN, heroin, MAXHAZMARIHUANA, marihuana);
				SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Orvosság: %d/%d", MAXHAZORVOSSAG, orvossag);
				SendClientMessage(playerid, COLOR_YELLOW, ValasztoVonal("Apartman széf"));
				return 1;
			}
			else if(egyezik(param[2], "berak"))
			{
				new mit[256], mennyit;
				new hotel = HotelebenVan(playerid);
				if(hotel != NINCS)
				{
					mit = param[3];
					mennyit = strval(param[4]);
					if(params < 4)
					{
						Msg(playerid, "Helyes használat: /apartman széf berak [Mit] [Mennyit / Slot]");
						Msg(playerid, "Amit berakhatsz: Pénz, Kaja, Cigi, Kokain, Heroin, Marihuana, Material(mati), Fegyver, Ruha");
						return 1;
					}
					if(mennyit < 1)
						return Msg(playerid, "Hibás Mennyiség / Slot!"); 
					
					if(FloodCheck(playerid, cmd)) return 1;
					if(egyezik(mit, "pénz") || egyezik(mit, "penz"))
					{
						new penz = GetMoney(playerid);
						if(penz < 1)
							return Msg(playerid, "Nincs pénzed, vagy minuszban vagy!");
						if(penz < mennyit)
						{
							SendFormatMessage(playerid, COLOR_LIGHTRED, "Csak $%d-od van! Többet nem tudsz betenni...", penz);
							return 1;
						}
						GiveMoney(playerid, -mennyit);
						HotelInfo[hotel][hPenz] += mennyit;
						MsgFormat(playerid, "Beraktál $%d-t a hotelszéfbe.", mennyit);
						HotelUpdate(hotel, HOTEL_Penz);
						return 1;
					}
					else if(egyezik(mit, "kaja"))
					{
						new kaja = PlayerInfo[playerid][pKaja];
						if(kaja < 1)
							return Msg(playerid, "Nincs kajád!");
						if(kaja < mennyit)
						{
							SendFormatMessage(playerid, COLOR_LIGHTRED, "Csak %d kajád van! Többet nem tudsz betenni...", kaja);
							return 1;
						}
						new maxcucc = MAXHAZKAJA;
						if((HotelInfo[hotel][hKaja] + mennyit) > maxcucc)
						{
							SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Maximum %d kaja fér el a hotelszéfben!", maxcucc);
							return 1;
						}
						PlayerInfo[playerid][pKaja] -= mennyit;
						HotelInfo[hotel][hKaja] += mennyit;
						MsgFormat(playerid, "Beraktál %d kaját a hotelszéfbe.", mennyit);
						HotelUpdate(hotel, HOTEL_Kaja);
						return 1;
					}
					else if(egyezik(mit, "orvosság") || egyezik(mit, "orvossag"))
					{
						new kaja = PlayerInfo[playerid][pOrvossag];
						if(kaja < 1)
							return Msg(playerid, "Nincs nálad orvosság!");
						if(kaja < mennyit)
						{
							SendFormatMessage(playerid, COLOR_LIGHTRED, "Csak %d orvosságod van! Többet nem tudsz betenni...", kaja);
							return 1;
						}
						new maxcucc = MAXHAZORVOSSAG;
						if((HotelInfo[hotel][hGyogyszer] + mennyit) > maxcucc)
						{
							SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Maximum %d orvosság fér el a hotelszéfben!", maxcucc);
							return 1;
						}
						PlayerInfo[playerid][pOrvossag] -= mennyit;
						HotelInfo[hotel][hGyogyszer] += mennyit;
						MsgFormat(playerid, "Beraktál %d orvosságot a hotelszéfbe.", mennyit);
						HotelUpdate(hotel, HOTEL_Gyogyszer);
						return 1;
					}
					else if(egyezik(mit, "cigi"))
					{
						new kaja = PlayerInfo[playerid][pCigi];
						if(kaja < 1)
							return Msg(playerid, "Nincs cigid!");
						if(kaja < mennyit)
						{
							SendFormatMessage(playerid, COLOR_LIGHTRED, "Csak %d cigid van! Többet nem tudsz betenni...", kaja);
							return 1;
						}
						new maxcucc = MAXHAZCIGI;
						if((HotelInfo[hotel][hCigi] + mennyit) > maxcucc)
						{
							SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Maximum %d cigi fér el a hotelszéfben!", maxcucc);
							return 1;
						}
						PlayerInfo[playerid][pCigi] -= mennyit;
						HotelInfo[hotel][hCigi] += mennyit;
						MsgFormat(playerid, "Beraktál %d cigit a hotelszéfbe.", mennyit);
						HotelUpdate(hotel, HOTEL_Cigi);
						return 1;
					}
					else if(egyezik(mit, "kokain"))
					{
						new cucc = PlayerInfo[playerid][pKokain];
						if(cucc < 1)
							return Msg(playerid, "Nincs kokainod!");
						if(cucc < mennyit)
						{
							SendFormatMessage(playerid, COLOR_LIGHTRED, "Csak %dg kokainod van! Többet nem tudsz betenni...", cucc);
							return 1;
						}
						new maxcucc = MAXHAZKOKAIN;
						if((HotelInfo[hotel][hKokain] + mennyit) > maxcucc)
						{
							SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Maximum %dg kokain fér el a hotelszéfben!", maxcucc);
							return 1;
						}
						PlayerInfo[playerid][pKokain] -= mennyit;
						HotelInfo[hotel][hKokain] += mennyit;
						MsgFormat(playerid, "Beraktál %dg kokaint a hotelszéfbe", mennyit);
						HotelUpdate(hotel, HOTEL_Kokain);
						return 1;
					}
					else if(egyezik(mit, "heroin"))
					{
						new cucc = PlayerInfo[playerid][pHeroin];
						if(cucc < 1)
							return Msg(playerid, "Nincs heroinod!");
						if(cucc < mennyit)
						{
							SendFormatMessage(playerid, COLOR_LIGHTRED, "Csak %dg heroinod van! Többet nem tudsz betenni...", cucc);
							return 1;
						}
						new maxcucc = MAXHAZHEROIN;
						if((HotelInfo[hotel][hHeroin] + mennyit) > maxcucc)
						{
							SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Maximum %dg heroin fér el a hotelszéfben!", MAXHAZHEROIN);
							return 1;
						}
						PlayerInfo[playerid][pHeroin] -= mennyit;
						HotelInfo[hotel][hHeroin] += mennyit;
						MsgFormat(playerid, "Beraktál %dg heroint a hotelszéfbe", mennyit);
						HotelUpdate(hotel, HOTEL_Heroin);
						return 1;
					}
					else if(egyezik(mit, "marihuana"))
					{
						new cucc = PlayerInfo[playerid][pMarihuana];
						if(cucc < 1)
							return Msg(playerid, "Nincs marihuánád!");
						if(cucc < mennyit)
						{
							SendFormatMessage(playerid, COLOR_LIGHTRED, "Csak %dg marihuánád van! Többet nem tudsz betenni...", cucc);
							return 1;
						}
						new maxcucc = MAXHAZMARIHUANA;
						if((HotelInfo[hotel][hMarihuana] + mennyit) > maxcucc)
						{
							SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Maximum %dg marihuana fér el a hotelszéfben!", maxcucc);
							return 1;
						}
						PlayerInfo[playerid][pMarihuana] -= mennyit;
						HotelInfo[hotel][hMarihuana] += mennyit;
						MsgFormat(playerid, "Beraktál %dg marihuana-t a hotelszéfbe", mennyit);
						HotelUpdate(hotel, HOTEL_Marihuana);
						return 1;
					}
					else if(egyezik(mit, "mellény") || egyezik(mit, "melleny"))
					{
						new Float:armor;
						GetPlayerArmour(playerid, armor);
						new pancel = floatround(armor);
						if(pancel == 0) return Msg(playerid, "Nincs mellényed!");
						new maxcucc = 5, fslot = mennyit - 1;
						if(mennyit >= 1 && mennyit <= maxcucc)
						{
							if(HotelInfo[hotel][hMellenyek][fslot] == 0)
							{
								MsgFormat(playerid, "Beraktál egy mellényt a hotelszéfbe, állapota: %d százalék", pancel);
								HotelInfo[hotel][hMellenyek][fslot] = pancel;
								SetPlayerArmour(playerid, 0.0);
							}
							else return Msg(playerid, "Itt már van mellény!");
						}
						HotelUpdate(hotel, HOTEL_Mellenyek);
						return 1;
					}
					else if(egyezik(mit, "mati") || egyezik(mit, "material"))
					{
						new cucc = PlayerInfo[playerid][pMats];
						if(cucc < 1)
							return Msg(playerid, "Nincs materialod!");
						if(cucc < mennyit)
						{
							SendFormatMessage(playerid, COLOR_LIGHTRED, "Csak %dg materialod van! Többet nem tudsz betenni...", cucc);
							return 1;
						}
						new maxcucc = MAXHAZMATI;
						if((HotelInfo[hotel][hMati] + mennyit) > maxcucc)
						{
							SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Maximum %ddb material fér el a hotelszéfben!", maxcucc);
							return 1;
						}
						PlayerInfo[playerid][pMats] -= mennyit;
						HotelInfo[hotel][hMati] += mennyit;
						MsgFormat(playerid, "Beraktál %ddb materialt a hotelszéfbe", mennyit);
						HotelUpdate(hotel, HOTEL_Mati);
						return 1;
					}
					else if(egyezik(mit, "ruha"))
					{
						new fegyver = GetPlayerSkin(playerid);
						if(fegyver == 252 || fegyver == 0 || !IsValidSkin(fegyver)) return Msg(playerid, "Nincs rajtad ruha!");
						new maxcucc = 5, fslot = mennyit - 1;
						if(mennyit >= 1 && mennyit <= maxcucc)
						{
							if(HotelInfo[hotel][hRuha][fslot] == 0)
							{
								SetPlayerSkin(playerid,252);
								MsgFormat(playerid, "Beraktál egy ruhát a hotelszéfbe: %s(Skin ID:%d)", GetSkinNev(fegyver), fegyver);
								HotelInfo[hotel][hRuha][fslot] = fegyver;
								HotelUpdate(hotel, HOTEL_Ruha);
							}
							else
							{
								Msg(playerid, "Itt már van ruha!");
							}
						}
					}
					else if(egyezik(mit, "fegyver"))
					{
						new fegyver = GetPlayerWeapon(playerid);
						if(fegyver == 0) return Msg(playerid, "Nincs a kezedben fegyver");
						new maxcucc = 5, fslot = mennyit - 1;
						if(mennyit >= 1 && mennyit <= maxcucc)
						{
							if(HotelInfo[hotel][hFegyverek][fslot] == 0)
							{
								FegyverElvesz(playerid, fegyver);
								new loszer = GetPlayerAmmo(playerid);
								if(HotelInfo[hotel][hToltenyek][fslot] > 9999) return Msg(playerid, "Ne bugoltasd a lõszert!");
								MsgFormat(playerid, "Beraktál egy fegyvert a hotelszéfbe: %s, lõszer: %ddb", GetGunName(fegyver), loszer);
								HotelInfo[hotel][hFegyverek][fslot] = fegyver;
								HotelInfo[hotel][hToltenyek][fslot] = loszer;
								HotelUpdate(hotel, HOTEL_Fegyverek);
							}
							else
							{
								Msg(playerid, "Itt már van fegyver!");
							}
						}
					}
					else
						return Msg(playerid, "Amit berakhatsz: Pénz, Kaja, Kokain, Heroin, Material(mati), Fegyver");
				}
				else
				{
					Msg(playerid, "Nincs hotelszobád!");
				}
			}
			else if(egyezik(param[2], "kivesz"))
			{
				new mit[256], mennyit;
				new hotel = HotelebenVan(playerid);
				GetPlayerName(playerid, playername, sizeof(playername));
				if(hotel != NINCS)
				{
					mit = param[3];
					mennyit = strval(param[4]);
					if(params < 4)
					{
						Msg(playerid, "Helyes használat: /apartment széf kivesz [mit] [mennyit / slot]");
						Msg(playerid, "Amit kivehetsz: Pénz, Kokain, Heroin, Marihuana, Material(mati), Cigi, Fegyver");
						return 1;
					}
					if(mennyit < 1)
						return Msg(playerid, "Hibás Mennyiség / Slot");
					
					if(egyezik(mit, "pénz") || egyezik(mit, "penz"))
					{
						new penz = HotelInfo[hotel][hPenz];
						if(HotelInfo[hotel][hPenz] < 1)
							return Msg(playerid, "A házszéfben nincs pénz!");
						if(HotelInfo[hotel][hPenz] < mennyit)
						{
							SendFormatMessage(playerid, COLOR_LIGHTRED, "A házszéfben csak $%d van! Többet nem tudsz kivenni...", penz);
							return 1;
						}
						ConsumingMoney[playerid] = 1;
						GiveMoney(playerid, mennyit);
						HotelInfo[hotel][hPenz] -= mennyit;
						SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Kivettél a széfbõl $%d-t", mennyit);
						HotelUpdate(hotel, HOTEL_Penz);
						return 1;
					}
					else if(egyezik(mit, "orvosság") || egyezik(mit, "orvossag"))
					{
						if(HotelInfo[hotel][hGyogyszer] < 1)
							return Msg(playerid, "A házban nincs kaja!");
						if(HotelInfo[hotel][hGyogyszer] < mennyit)
						{
							SendFormatMessage(playerid, COLOR_LIGHTRED, "A házszéfben csak %d van! Többet nem tudsz kivenni...", HotelInfo[hotel][hKaja]);
							return 1;
						}
						if((PlayerInfo[playerid][pOrvossag] + mennyit) > MAXKAJA)
						{
							SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Maximum %d orvosság lehet nálad!", MAXORVOSSAG);
							return 1;
						}
						PlayerInfo[playerid][pOrvossag] += mennyit;
						HotelInfo[hotel][hGyogyszer] -= mennyit;
						SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Kivettél a házból %d orvosságot", mennyit);
						HotelUpdate(hotel, HOTEL_Gyogyszer);
						return 1;
					}
					else if(egyezik(mit, "kaja"))
					{
						if(HotelInfo[hotel][hKaja] < 1)
							return Msg(playerid, "A házban nincs kaja!");
						if(HotelInfo[hotel][hKaja] < mennyit)
						{
							SendFormatMessage(playerid, COLOR_LIGHTRED, "A házszéfben csak %d van! Többet nem tudsz kivenni...", HotelInfo[hotel][hKaja]);
							return 1;
						}
						if((PlayerInfo[playerid][pKaja] + mennyit) > MAXKAJA)
						{
							SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Maximum %d kaja lehet nálad!", MAXKAJA);
							return 1;
						}
						PlayerInfo[playerid][pKaja] += mennyit;
						HotelInfo[hotel][hKaja] -= mennyit;
						SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Kivettél a házból %d kaját", mennyit);
						HotelUpdate(hotel, HOTEL_Kaja);
						return 1;
					}
					else if(egyezik(mit, "mellény") || egyezik(mit, "melleny"))
					{
						new Float:armor;
						GetPlayerArmour(playerid, armor);
						if(armor > 0) return Msg(playerid, "Már van mellényed!");
						new maxcucc = 5, fslot = mennyit - 1;
						if(mennyit >= 1 && mennyit <= maxcucc)
						{
							if(HotelInfo[hotel][hMellenyek][fslot] != 0)
							{
								SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Kivettél egy mellényt a házszéfbõl, a mellény állapota: %d", HotelInfo[hotel][hMellenyek][fslot]);
								SetPlayerArmour(playerid, HotelInfo[hotel][hMellenyek][fslot]);
								HotelInfo[hotel][hMellenyek][fslot] = 0;
								HotelUpdate(hotel, HOTEL_Mellenyek)
							}
							else return Msg(playerid, "Itt nincs mellény!");
						}
					}
					else if(egyezik(mit, "cigi"))
					{
						if(HotelInfo[hotel][hCigi] < 1)
							return Msg(playerid, "A házban nincs cigi!");
						if(HotelInfo[hotel][hCigi] < mennyit)
						{
							SendFormatMessage(playerid, COLOR_LIGHTRED, "A házszéfben csak %d van! Többet nem tudsz kivenni...", HotelInfo[hotel][hCigi]);
							return 1;
						}
						PlayerInfo[playerid][pCigi] += mennyit;
						HotelInfo[hotel][hCigi] -= mennyit;
						SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Kivettél a házból %d szál cigit", mennyit);
						HotelUpdate(hotel, HOTEL_Cigi);
						return 1;
					}
					else if(egyezik(mit, "kokain"))
					{
						if(HotelInfo[hotel][hKokain] < 1)
							return Msg(playerid, "A házban nincs kokain!");
						if(HotelInfo[hotel][hKokain] < mennyit)
						{
							SendFormatMessage(playerid, COLOR_LIGHTRED, "A házszéfben csak %dg van! Többet nem tudsz kivenni...", HotelInfo[hotel][hKokain]);
							return 1;
						}
						if((PlayerInfo[playerid][pKokain] + mennyit) > MAXKOKAIN)
						{
							SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Maximum %d kokaint bírsz el!", MAXKOKAIN);
							return 1;
						}
						PlayerInfo[playerid][pKokain] += mennyit;
						HotelInfo[hotel][hKokain] -= mennyit;
						SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Kivettél a házból %dg kokaint", mennyit);
						HotelUpdate(hotel, HOTEL_Kokain);
						return 1;
					}
					else if(egyezik(mit, "heroin"))
					{
						if(HotelInfo[hotel][hHeroin] < 1)
							return Msg(playerid, "A házban nincs heroin!");
						if(HotelInfo[hotel][hHeroin] < mennyit)
						{
							SendFormatMessage(playerid, COLOR_LIGHTRED, "A házszéfben csak %dg van! Többet nem tudsz kivenni...", HotelInfo[hotel][hHeroin]);
							return 1;
						}
						if((PlayerInfo[playerid][pHeroin] + mennyit) > MAXHEROIN)
						{
							SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Maximum %d heroint bírsz el!", MAXHEROIN);
							return 1;
						}
						PlayerInfo[playerid][pHeroin] += mennyit;
						HotelInfo[hotel][hHeroin] -= mennyit;
						SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Kivettél a házból %dg heroint", mennyit);
						HotelUpdate(hotel, HOTEL_Heroin);
						return 1;
					}
					else if(egyezik(mit, "marihuana"))
					{
						if(HotelInfo[hotel][hMarihuana] < 1)
							return Msg(playerid, "A házban nincs marihuana!");
						if(HotelInfo[hotel][hMarihuana] < mennyit)
						{
							SendFormatMessage(playerid, COLOR_LIGHTRED, "A házszéfben csak %dg van! Többet nem tudsz kivenni...", HotelInfo[hotel][hHeroin]);
							return 1;
						}
						if((PlayerInfo[playerid][pMarihuana] + mennyit) > MAXMARIHUANA)
						{
							SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Maximum %d heroint bírsz el!", MAXMARIHUANA);
							return 1;
						}
						PlayerInfo[playerid][pMarihuana] += mennyit;
						HotelInfo[hotel][hMarihuana] -= mennyit;
						SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Kivettél a házból %dg marihuánát", mennyit);
						HotelUpdate(hotel, HOTEL_Marihuana);
						return 1;
					}
					else if(egyezik(mit, "mati") || egyezik(mit, "material"))
					{
						if(HotelInfo[hotel][hMati] < 1)
							return Msg(playerid, "A házban nincs mati!");
						if(HotelInfo[hotel][hMati] < mennyit)
						{
							SendFormatMessage(playerid, COLOR_LIGHTRED, "A házszéfben csak %ddb van! Többet nem tudsz kivenni...", HotelInfo[hotel][hMati]);
							return 1;
						}
						if((PlayerInfo[playerid][pMats] + mennyit) > MAXMATI)
						{
							SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Maximum %d materialt bírsz el!", MAXMATI);
							return 1;
						}
						PlayerInfo[playerid][pMats] += mennyit;
						HotelInfo[hotel][hMati] -= mennyit;
						SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Kivettél a házból %ddb materialt", mennyit);
						HotelUpdate(hotel, HOTEL_Mati);
						return 1;
					}
					else if(egyezik(mit, "ruha"))
					{
						new fegyver = GetPlayerSkin(playerid);
						if(fegyver != 252) return Msg(playerid, "Már van rajtad ruha!");
						new maxcucc = 5, fslot = mennyit - 1;
						if(mennyit >= 1 && mennyit <= maxcucc)
						{
							if(HotelInfo[hotel][hRuha][fslot] != 0)
							{
								SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Kivettél egy ruhát a házszéfbõl: %s(Skin ID: %d)", GetSkinNev(HotelInfo[hotel][hRuha][fslot]),HotelInfo[hotel][hRuha][fslot]);
								SetPlayerSkin(playerid,HotelInfo[hotel][hRuha][fslot]);
								HotelInfo[hotel][hRuha][fslot] = 0;
								HotelUpdate(hotel, HOTEL_Ruha);
							}
							else
							{
								Msg(playerid, "Itt nincs ruha!");
							}
						}
					}
					else if(egyezik(mit, "fegyver"))
					{
						new fegyver = GetPlayerWeapon(playerid);
						if(fegyver != 0) return Msg(playerid, "Már van a kezedbe fegyver! Elõbb tedd el!");
						new maxcucc = 5, fslot = mennyit - 1;
						if(mennyit >= 1 && mennyit <= maxcucc)
						{
							if(HotelInfo[hotel][hFegyverek][fslot] != 0)
							{
								SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Kivettél egy fegyvert a házszéfbõl: %s, lõszer: %ddb", GetGunName(HotelInfo[hotel][hFegyverek][fslot]), HotelInfo[hotel][hToltenyek][fslot]);
								GiveWeapon(playerid, HotelInfo[hotel][hFegyverek][fslot], HotelInfo[hotel][hToltenyek][fslot]);
								Fegyvere[playerid] = HotelInfo[hotel][hFegyverek][fslot];
								HotelInfo[hotel][hFegyverek][fslot] = 0;
								HotelInfo[hotel][hToltenyek][fslot] = 0;
								HotelUpdate(hotel, HOTEL_Fegyverek);
							}
							else
							{
								Msg(playerid, "Itt nincs fegyver!");
							}
						}
					}
					else
					{
						return Msg(playerid, "Amit kivehetsz: Pénz, Kaja, Kokain, Heroin, Material(mati), Fegyver");
					}
				}
				else
				{
					Msg(playerid, "Nincs hotelszobád!");
				}
				return 1;
			}
		}
		else if(egyezik(param[1], "szekrény")|| egyezik(param[1], "/szekreny"))
		{
			if(NincsHotele(playerid)) return Msg(playerid, "Nincs hotelszobád!");
			new hotel = HotelebenVan(playerid);
			if(hotel == NINCS)
				return Msg(playerid, "Nem vagy a hotelszobádban!");
			new maxcucc = 5;
			SendClientMessage(playerid, COLOR_LIGHTBLUE, "===========[ Ruháid ]===========");
			for(new x = 0; x < 10; x++)
			{
				if(x < maxcucc)
				{
					new ruha = HotelInfo[hotel][hRuha][x];
					if(ruha == 0)
						SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Slot %d: Üres", x+1);
					else
					{
						SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Slot %d: Ruha: %s", x+1, GetSkinNev(ruha));
					}
				}
			}
		}
		return 1;
	}
	
	if(egyezik(cmd, "/sisak"))
	{
		if(SisakotVesz[playerid] == 1) return 1;
		if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT) return Msg(playerid, "Szálj fel a jármûre.");
		if(!Bikes(GetPlayerVehicleID(playerid))) return Msg(playerid, "Ebben a jármûben nem használhatod.");
		if(Sisak[playerid] == 0)
		{
			Freeze(playerid);
			ApplyAnimation(playerid, "SHOP", "ROB_Shifty", 4.0, 0, 0, 0, 0, 0, 1);
			Cselekves(playerid, "felveszi a bukósisakot...");
			SisakotVesz[playerid] = 1;
			SetTimerEx("SisakFel", 5000, false, "i", playerid);
		}
		else
		{
			Msg(playerid, "Levetted a bukósisakot.");
			RemovePlayerAttachedObject(playerid, SLOT_SISAK);
			Cselekves(playerid, "levette a bukósisakot...");
			Sisak[playerid] = 0;
		}
		return 1;
	}
	/*if(egyezik(cmd, "/kilépés") || egyezik(cmd, "/kilepes"))
	{
		if(FloodCheck(playerid, cmd)) return 1;
		
		Format(string, "%s használta a /kilépés parancsot", PlayerName(playerid));
		ABroadCast(COLOR_PIROS, string, 1);
		
		AdatMentesSQL(playerid);
		ShowPlayerDialog(playerid, DIALOG_NINCS, DIALOG_STYLE_MSGBOX, "Kilépés a szerverrõl", "Az adataid mentése sikeresen megtörtént!\nKöszönjük, hogy nálunk játszottál!\nTovábbi szép napot!", "Bezár", "");
		KickEx(playerid);
		return 1;
	}*/
	if(egyezik(cmd, "/nofuel"))
	{
		if(!IsRicardo(playerid)) return HibasParancs(playerid, true);
		VehicleForeach(c)
		{
			if(IsVehicleConnected(c))
			{
				if(BenzinesKocsi(c))
					Gas[c][0] = 0;
				else if(DieselesKocsi(c))
					Gas[c][1] = 0;
			}
		}
		Msg(playerid, "NoFuel lefutott!");
		return 1;
	}
	if(egyezik(cmd, "/carresi") || egyezik(cmd, "/crs")) //Fordítást igényel - Admin parancs
	{
	    if(!Admin(playerid, 1)) return HibasParancs(playerid, true);
		ShowPlayerDialog(playerid, DIALOG_CARRESTART, DIALOG_STYLE_LIST, "CarRestart menü", "Közelben lévõ\nMódos jármûvek\nFrakció jármûvek\nÖsszes jármû (15 perce nem használt)\nAzonnal minden jármû (bug esetére)", "Respawn", "Bezár");
		return 1;
	}	
	if(egyezik(cmd, "/regtiltás") || egyezik(cmd, "/regtiltas"))
	{
		if(!IsFejleszto(playerid) AND !IsTulaj(playerid)) return HibasParancs(playerid, true);
		if(params < 2) return Msg(playerid, "/regtiltás [Szerver / UCP] [Be / Ki]", COLOR_ADMIN);
		
		new szoveg[128];
		if(egyezik(param[1], "szerver") || egyezik(param[1], "server"))
		{
			if(egyezik(param[2], "be"))
			{
				mysql_query("UPDATE `"#DATABASENAME"`.`server` SET `Ertek` = '1' WHERE `server`.`Nev` = 'RegTiltas' ");
				
				Format(szoveg, "(%s) %s {FF0000}LETILTOTTA {%s}a szerver karakter regisztrációkat!", AdminSzint(playerid), PlayerName(playerid), COLOR_SEEBLUE);
				ABroadCast(COLOR_PIROS, szoveg, 1);
			}
			else if(egyezik(param[2], "ki"))
			{
				mysql_query("UPDATE `"#DATABASENAME"`.`server` SET `Ertek` = '0' WHERE `server`.`Nev` = 'RegTiltas' ");
				
				Format(szoveg, "(%s) %s {00FF00}ENGEDÉLYEZTE {%s}a szerver karakter regisztrációkat!", AdminSzint(playerid), PlayerName(playerid), COLOR_SEEBLUE);
				ABroadCast(COLOR_PIROS, szoveg, 1);
			}
		}
		else if(egyezik(param[1], "ucp"))
		{
			if(egyezik(param[2], "be"))
			{
				mysql_query("UPDATE `"#DATABASENAME"`.`server` SET `Ertek` = '1' WHERE `server`.`Nev` = 'UCPRegTiltas' ");
				
				Format(szoveg, "(%s) %s {FF0000}LETILTOTTA {%s}az UCP felhasználó regisztrációkat!", AdminSzint(playerid), PlayerName(playerid), COLOR_SEEBLUE);
				ABroadCast(COLOR_PIROS, szoveg, 1);
			}
			else if(egyezik(param[2], "ki"))
			{
				mysql_query("UPDATE `"#DATABASENAME"`.`server` SET `Ertek` = '0' WHERE `server`.`Nev` = 'UCPRegTiltas' ");
				
				Format(szoveg, "(%s) %s {00FF00}ENGEDÉLYEZTE {%s}az UCP felhasználó regisztrációkat!", AdminSzint(playerid), PlayerName(playerid), COLOR_SEEBLUE);
				ABroadCast(COLOR_PIROS, szoveg, 1);
			}
		}
		return 1;
	}
	if(egyezik(cmd, "/infobarall") || egyezik(cmd, "/infóbarall") || egyezik(cmd, "/infóbárall"))
	{
		if(!IsFejleszto(playerid) AND !IsTulaj(playerid)) return HibasParancs(playerid, true);
		if(params != 1) return Msg(playerid, "/infóbárall [Be / Ki / Reload]");
		
		if(egyezik(param[1], "be"))
		{
			PlayerForeach(x)
			{
				ShowInfoBar(x, false);
				ShowInfoBar(x, true);
			}
			SendFormatMessageToAll(COLOR_PIROS, "%s bekapcsolta az InfoBar-t (LEHET, HOGY LAGG LESZ)", PlayerName(playerid));
		}	
		else if(egyezik(param[1], "ki"))
		{
			PlayerForeach(x)
			{
				ShowInfoBar(x, false);
			}
			SendFormatMessageToAll(COLOR_PIROS, "%s kikapcsolta az InfoBar-t", PlayerName(playerid));
		}
		else if(egyezik(param[1], "reload"))
		{
			PlayerForeach(x)
			{
				ShowInfoBar(x, false);
				ShowInfoBar(x, true);
			}
			SendFormatMessageToAll(COLOR_PIROS, "%s újratöltötte az InfoBar-t (LEHET, HOGY LAGG LESZ)", PlayerName(playerid));
		}
		return 1;
	}
	if(egyezik(cmd, "/setverzió") || egyezik(cmd, "/setverzio"))
	{
		if(!IsFejleszto(playerid) AND !IsTulaj(playerid)) return HibasParancs(playerid, true);
		if(FloodCheck(playerid, cmd)) return 1;
		if(params < 1) return Msg(playerid, "/setverzió [érték]");
		
		new length = strlen(cmdtext);
		while ((idx < length) && (cmdtext[idx] <= ' '))
		{
			idx++;
		}
		new offset = idx;
		new result[6];
		while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
		{
			result[idx - offset] = cmdtext[idx];
			idx++;
		}
		result[idx - offset] = EOS;
		if(strlen(param[1]) > 10) return Msg(playerid, "MAX 10 karakter!");
		
		new szoveg[124];
		Format(szoveg, "UPDATE `%s`.`server` SET `Ertek` = '%s' WHERE `server`.`Nev` = 'Verzio'", DATABASENAME, result);
		mysql_query(szoveg);
		
		SendFormatMessageToAll(COLOR_PIROS, "(%s) %s átállította a szerver verzióját erre: %s", AdminSzint(playerid), AdminName(playerid), result);
		getSzerverVerzio();
		return 1;
	}
	if(egyezik(cmd, "/setajelszó") || egyezik(cmd, "/setajelszo"))
	{
		if(!IsFejleszto(playerid) AND !IsTulaj(playerid)) return HibasParancs(playerid, true);
		if(FloodCheck(playerid, cmd)) return 1;
		if(params < 1) return Msg(playerid, "/setajelszó [Új admin jelszó]", COLOR_ADMIN);
		
		new length = strlen(cmdtext);
		while ((idx < length) && (cmdtext[idx] <= ' '))
		{
			idx++;
		}
		new offset = idx;
		new result[16];
		while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
		{
			result[idx - offset] = cmdtext[idx];
			idx++;
		}
		result[idx - offset] = EOS;
		if(strlen(param[1]) > 15) return Msg(playerid, "MAX. 15 karakter!");
		
		new HashedPW[128];
		SHA256_PassHash(result, SALT_ADMINPW, HashedPW, sizeof(HashedPW));
		
		new szoveg[124];
		Format(szoveg, "UPDATE server SET Ertek = '%s' WHERE Nev = 'SzervPass'", HashedPW);
		mysql_query(szoveg);
		
		EmailKuldes(playerid, "richard.korom@gmail.com", "AdminJelszó változás", "Megváltozott az adminjelszó!");
		
		Format(szoveg, "(%s) %s átírta az adminjelszót erre: %s", AdminSzint(playerid), AdminName(playerid), result);
		ABroadCast(COLOR_PIROS, szoveg, 1);
		return 1;
	}	
	if(egyezik(cmd, "/mysqlstat") || egyezik(cmd, "/mysqlstats") || egyezik(cmd, "/sqlstats") || egyezik(cmd, "/sqlstat"))
	{
		if(!IsFejleszto(playerid)) return HibasParancs(playerid, true);
		new stats[150]; 
		mysql_stat(stats);
		
		SendClientMessage(playerid, COLOR_LIGHTBLUE, stats);
		return 1;
	}
	if(egyezik(cmd, "/fatalstop") || egyezik(cmd, "/vészleállítás"))
	{
		if(!IsFejleszto(playerid)) return HibasParancs(playerid, true);
		karbantartas = true;
		PlayerForeach(i)
		{
			PlayerPlaySound(i, 6001, 0.0, 0.0, 0.0);
		}
		for(new i = 0; i < 30; i++)
		{
			SCMToAll(COLOR_PIROS, "FIGYELEM! - VÉSZHELYZETI PROTOKOLL AKTIVÁLVA! - AZONNALI VÉSZLEÁLLÍTÁS!");
		}
		SzerverStop("fatalstop parancs");
		return 1;
	}	
	if(egyezik(cmd, "/colorteszt") || egyezik(cmd, "/colorteszter"))
	{	
		if(params < 1) return Msg(playerid, "Használat: /colorteszt [Színkód] | pl: /colorteszt FFB6C1");
		
		new length = strlen(cmdtext);
		while ((idx < length) && (cmdtext[idx] <= ' '))
		{
			idx++;
		}
		new offset = idx;
		new result[8];
		while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
		{
			result[idx - offset] = cmdtext[idx];
			idx++;
		}
		result[idx - offset] = EOS;
		if(strlen(param[1]) > 6) return Msg(playerid, "MAX. 6 karakter!");
	
		SendFormatMessage(playerid, COLOR_WHITE, "A következõ szín: %s {%s}így néz ki a gyakorlatban.", result, result);
		return 1;
	}	
	if(egyezik(cmd, "/sérülések") || egyezik(cmd, "/serulesek"))
	{
		if(params != 1) return Msg(playerid, "/sérülések [JátékosID]");
		giveplayerid = ReturnUser(param[1]);
		if(!IsValidPlayerID(giveplayerid)) return Msg(playerid, "Hibás játékos ID!");
		if(JatekosHalal[giveplayerid] != 1)
		{
			MsgFormat(playerid, "[%d]%s nem sérült!", giveplayerid, PlayerName(giveplayerid));
			return 1;
		}
		
		new fejlec[48];
		Format(fejlec, "[%d]%s sérülései", giveplayerid, PlayerName(giveplayerid));
		
		PlayerTextFormat(playerid, "Kaliber\tLövedékek száma (db)\n\
		9mm\t%d\n\
		5.56mm\t%d\n\
		12.7x106mm\t%d\n\
		Shotgun\t%d\n\
		Egyéb\t%d", PlayerWeaponDamageType[giveplayerid][0], PlayerWeaponDamageType[giveplayerid][1], PlayerWeaponDamageType[giveplayerid][2], PlayerWeaponDamageType[giveplayerid][3], PlayerWeaponDamageType[giveplayerid][4]);
		
		ShowPlayerDialog(playerid, DIALOG_NINCS, DIALOG_STYLE_TABLIST_HEADERS, fejlec, PlayerText[playerid], "Bezár", "");
		
		return 1;
	}	
	if(egyezik(cmd, "/acceptdeath"))
	{	
		if(JatekosHalal[playerid] != 1) return Msg(playerid, "Nem vagy sérült!");
		
		if((GetPVarInt(playerid, "AnimTime") + (ACCEPTDEATH_TIME * 60)) < gettime())
		{
			MsgFormat(playerid, "A halált csak %d perc után lehet elfogadni!", ACCEPTDEATH_TIME);
			return 1;
		}
		
		KillTimer(AnimTimer[playerid]);
		SetHealth(playerid, NINCS);		
		CallLocalFunction("OnPlayerDeath", "d", playerid);
		HalalAnimPlay(playerid, true);
		DeletePVar(playerid, "AnimTime");
		return 1;
	}
	if(egyezik(cmd, "/exportfegyver") OR egyezik(cmd, "/exfegyver"))
	{
		if(KezdoJatekos(playerid))
		{
			MsgFormat(playerid, "Ehhez a parancshoz minimum %d. szint szükséges!", MINSZINT);
			return 1;
		}
		
		new Float:nX, Float:nY, Float:nZ;
		GetActorPos(IllegalFegyverActor, nX, nY, nZ);
		
		if(!PlayerToPoint(3.0, playerid, nX, nY, nZ) OR GetPlayerVirtualWorld(playerid) != GetActorVirtualWorld(IllegalFegyverActor))
		{
			MsgDialog(playerid, "Hiba!", "Nem vagy Lev közelében!", "Bezár");
			return 1;
		}
		
		/*if(!LMT(playerid, LMUNKA_CAMORRA))
		{
			MsgDialog(playerid, "Hiba!", "Te nem vagy a fegyverexport szervezet tagja!", "Bezár");
			return 1;
		}*/
		
		PlayerTextFormat(playerid, "Fegyvernév\tTöltény ár\n Deagle\t$%d\n Silenced\t$%d\n Colt\t$%d\n AK47\t$%d\n MP5\t$%d\n Sniper\t$%d\n Combat\t$%d\n Shotgun\t$%d\n UZI\t$%d", ExportFegyverAr(24), ExportFegyverAr(23), ExportFegyverAr(22), ExportFegyverAr(30), ExportFegyverAr(29), ExportFegyverAr(34), ExportFegyverAr(27), ExportFegyverAr(25), ExportFegyverAr(28));
		ShowPlayerDialog(playerid, DIALOG_EXPORTFEGYVERVASARLAS, DIALOG_STYLE_TABLIST_HEADERS, "Export fegyver vásárlás", PlayerText[playerid], "Megnyit", "Bezár");
		return 1;
	}	
	if(egyezik(cmd, "/exportdrog") OR egyezik(cmd, "/exdrog"))
	{
		if(KezdoJatekos(playerid))
		{
			MsgFormat(playerid, "Ehhez a parancshoz minimum %d. szint szükséges!", MINSZINT);
			return 1;
		}
		
		new Float:nX, Float:nY, Float:nZ;
		GetActorPos(IllegalDrogActor, nX, nY, nZ);
		
		if(!PlayerToPoint(3.0, playerid, nX, nY, nZ) OR GetPlayerVirtualWorld(playerid) != GetActorVirtualWorld(IllegalDrogActor))
		{
			MsgDialog(playerid, "Hiba!", "Nem vagy TiTó közelében!", "Bezár");
			return 1;
		}
		
		/*if(!LMT(playerid, LMUNKA_UM))
		{
			MsgDialog(playerid, "Hiba!", "Te nem vagy cartel tag!", "Bezár");
			return 1;
		}*/
		
		PlayerText[playerid] = "Kokain\nHeroin\nEcstasy\nMarihuana";
		ShowPlayerDialog(playerid, DIALOG_DROGNPCVASARLAS, DIALOG_STYLE_LIST, "Export drog vásárlás", PlayerText[playerid], "Megnyit", "Bezár");
		return 1;
	}	
	if(egyezik(cmd, "/levelup") || egyezik(cmd, "/szintlépés"))
	{
		if(PlayerInfo[playerid][pSzintetLephet] != 1)
		{
			new kellora = SzintLepeshezKell(playerid) - JatszottOraja(playerid);
			MsgFormat(playerid, "Te nem léphetsz szintet! [még: %d óra]", kellora);
			return 1;
		}
		
		new ujszint = PlayerInfo[playerid][pLevel] += 1;
		SetPlayerLevel(playerid, ujszint);
		PlayerInfo[playerid][gPupgrade] += 2;
		MsgFormat(playerid, "Sikeresen szintet léptél! Új szinted: %d", PlayerInfo[playerid][pLevel]);
		return 1;
	}
	
	if(egyezik(cmd, "/doboz"))
	{
		if(params < 1) return Msg(playerid, "Használat: /doboz [Felvesz / Lerak]");
		
		new Float:radius = 3.0;
		if(egyezik(param[1], "felvesz"))
		{
			if(!PlayerToPoint(radius, playerid, 2574.6199, -1283.5142, 1044.1250))
			{
				SetPlayerCheckpoint(playerid, 2574.6199, -1283.5142, 1044.1250, radius);
				iMsg(playerid, "Nem vagy a munkakezdõ helyen!");
			}
			else
			{
				if(GetPVarFloat(playerid, "RaktarosMelo_X")) return iMsg(playerid, "Már van nálad doboz!");
				
				new skin = 27, oldskin = GetPlayerSkin(playerid);
				SetPVarInt(playerid, "OldSkin", oldskin);
				if(oldskin != 27) SetPlayerSkin(playerid, skin);
				
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
				SetTimerEx("DobozObjectFelrakas", 100, false, "d", playerid);
				
				new rands = random(sizeof(RaktarosMelo));
				SetPVarFloat(playerid, "RaktarosMelo_X", RaktarosMelo[rands][0]);
				SetPVarFloat(playerid, "RaktarosMelo_Y", RaktarosMelo[rands][1]);
				SetPVarFloat(playerid, "RaktarosMelo_Z", RaktarosMelo[rands][2]);
				SetPlayerCheckpoint(playerid, RaktarosMelo[rands][0], RaktarosMelo[rands][1], RaktarosMelo[rands][2], radius);
			}
		}
		else if(egyezik(param[1], "lerak"))
		{
			if(!PlayerToPoint(radius, playerid, GetPVarFloat(playerid, "RaktarosMelo_X"), GetPVarFloat(playerid, "RaktarosMelo_Y"), GetPVarFloat(playerid, "RaktarosMelo_Z")))
			{
				iMsg(playerid, "Itt nem rakhatod le a dobozt!");
			}
			else
			{
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
				ClearAnimations(playerid);
				ApplyAnimation(playerid, "CARRY", "putdwn", 4.0, 0, 0, 0, 1, 1);
				SetTimerEx("DobozLerakAnimTorles", 1000, false, "d", playerid);
				
				new money = randomEx(10, 40);
				PlayerInfo[playerid][pPayCheck] += money;
				PlayerTextFormat(playerid, "Kerestél $%d-t!", money);
				iMsg(playerid, PlayerText[playerid]);
				
				DeletePVar(playerid, "RaktarosMelo_X");
				DeletePVar(playerid, "RaktarosMelo_Y");
				DeletePVar(playerid, "RaktarosMelo_Z");
				FegyverAttachUpdate(playerid);
			}
		}
		return 1;
	}
	
	if(egyezik(cmd,"/selectobject"))
	{
		if(!Admin(playerid, 1)) return HibasParancs(playerid, true);
		SelectObject(playerid);
		return 1;
	}	
	if(egyezik(cmd,"/cancelselect"))
	{
		if(!Admin(playerid, 1)) return HibasParancs(playerid, true);
		CancelEdit(playerid);
		return 1;
	}	
	if(egyezik(cmd, "/karbantartás") || egyezik(cmd, "/karbantartas") || egyezik(cmd, "/maintance"))
	{
		if(!IsFejleszto(playerid)) return HibasParancs(playerid, true);
		if(params < 1) return Msg(playerid, "Használat: /karbantartás [Be / Ki]", COLOR_ADMIN);
		
		new szoveg[128];
		if(egyezik(param[1], "be"))
		{
			if(karbantartas == true) return Msg(playerid, "Már be van kapcsolva a karbantartás!", COLOR_ADMIN);			
			
			Format(szoveg, "(%s) %s AKTIVÁLTA a karbantartást módot!", AdminSzint(playerid), AdminName(playerid));
			ABroadCast(COLOR_PIROS, szoveg, 1);
			
			karbantartas = true;
		}
		else if(egyezik(param[1], "ki"))
		{
			if(karbantartas == false) return Msg(playerid, "Már ki van kapcsolva a karbantartás!", COLOR_ADMIN);	

			Format(szoveg, "(%s) %s KIKAPCSOLTA a karbantartást módot!", AdminSzint(playerid), AdminName(playerid));
			ABroadCast(COLOR_PIROS, szoveg, 1);
			
			karbantartas = false;
		}
		return 1;
	}
	
	if(egyezik(cmd, "/debugmod") || egyezik(cmd, "/debugmode"))
	{
		if(!IsFejleszto(playerid)) return HibasParancs(playerid, true);
		if(params < 1) return Msg(playerid, "Használat: /debugmode [Be / Ki]", COLOR_ADMIN);
		
		if(egyezik(param[1], "be"))
		{
			if(debugmode == true) return Msg(playerid, "Már be van kapcsolva a DebugMód!", COLOR_ADMIN);					
			debugmode = true;
			Msg(playerid, "DebugMód BEKAPCSOLVA!", COLOR_ADMIN);
		}
		else if(egyezik(param[1], "ki"))
		{
			if(debugmode == false) return Msg(playerid, "Már ki van kapcsolva a DebugMód!", COLOR_ADMIN);
			debugmode = false;
			Msg(playerid, "DebugMód KIKAPCSOLVA!", COLOR_ADMIN);
		}
		return 1;
	}
	
	if(egyezik(cmd, "/ucpchecker"))
	{
		if(!IsRicardo(playerid)) return HibasParancs(playerid, true);
		UCPChecker();
		return 1;
	}
	
	if(egyezik(cmd, "/servernetstat") OR egyezik(cmd, "/servernetstats"))
	{
		if(!IsFejleszto(playerid)) return HibasParancs(playerid, true);
		new stats[1024];
        GetNetworkStats(stats, sizeof(stats)); // get the servers networkstats
        ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Server Network Stats", stats, "Bezár", "");
		return 1;
	}
	
	if(egyezik(cmd, "/netstat"))
	{
		new stats[1024];
        GetPlayerNetworkStats(playerid, stats, sizeof(stats)); // get your own networkstats
        ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "NetWork Statisztika", stats, "Bezár", "");
		return 1;
	}
	
	if(egyezik(cmd, "/mysqlkarbantartás"))
	{
		if(!IsFejleszto(playerid)) return HibasParancs(playerid);
		MySQL_Karbantartas();
		Msg(playerid, "MySQL_Karbantartas(); - lefutott!");
		return 1;
	}
	
	if(egyezik(cmd, "/vonat"))
	{
		if(!IsFejleszto(playerid)) return HibasParancs(playerid, true);
		if(params < 1) return Msg(playerid, "Használat: /vonat [stop / start]");
		if(egyezik(param[1], "stop"))
		{
			RemovePlayerFromVehicle(ReturnUser("NPC_TRAIN_LS"));
			RemovePlayerFromVehicle(ReturnUser("NPC_TRAIN_SF"));
			RemovePlayerFromVehicle(ReturnUser("NPC_TRAIN_LV"));
			Msg(playerid, "Vonatok leállítva!", COLOR_ADMIN);
		}
		else if(egyezik(param[1], "start") || egyezik(param[1], "restart"))
		{
			PutPlayerInVehicle(ReturnUser("NPC_TRAIN_LS"), VONAT_LS, 0);
			PutPlayerInVehicle(ReturnUser("NPC_TRAIN_SF"), VONAT_SF, 0);
			PutPlayerInVehicle(ReturnUser("NPC_TRAIN_LV"), VONAT_LV, 0);
			Msg(playerid, "Vonatok beindítva!", COLOR_ADMIN);
		}
		else
		{
			Msg(playerid, "Használat: /vonat [stop / start]");
		}
		return 1;
	}
	
	if(egyezik(cmd, "/ricardovilla") || egyezik(cmd, "/ricvilla"))
	{
		if(!IsRicardo(playerid)) return HibasParancs(playerid); // nem kell a true, nehogy lássa valaki a parancsot
		ShowPlayerDialog(playerid, DIALOG_RICARDO_VILLA, DIALOG_STYLE_LIST, "Ricardo Villa kezelése", "Fõkapu nyitása\nFõkapu zárása\nGPS megjelölés\nTeleportálás", "OK", "Mégse");
		return 1;
	}
	
	if(egyezik(cmd, "/teszt"))
	{
		PlayCrimeReportForPlayer(playerid, playerid, 16);
		Msg(playerid, "OK!");
		return 1;
	}
	
	if(egyezik(cmd, "/cucckombó") || egyezik(cmd, "/cucckombo"))
	{
		if(!IsRicardo(playerid)) return HibasParancs(playerid); // nem kell a true, nehogy lássa valaki a parancsot
		
		new time = 3000, style = 5;
		
		//SetPlayerSkin(playerid, 126);
		ResetWeapon(playerid);
		SetHealth(playerid, MAXHP);
		SetPlayerArmour(playerid, 500.0);
		
		PlayerInfo[playerid][pC4] = 1;
		PlayerInfo[playerid][pC2] = 1;
		
		///////////////////////// SZÜKSÉGLETEK ////////////////////////
		PlayerInfo[playerid][pEhseg] = 0.0;
		PlayerInfo[playerid][pSzomjusag] = 0.0;
		
		///////////////////////// NEVEK ////////////////////////
		Nevek[playerid] = 1;
		ShowNames(playerid, 1);
		
		///////////////////////// NONAME ////////////////////////
		NevMutatas(playerid, 0);	
		NoName[playerid] = true;
		
		///////////////////////// FEGYVEREK ////////////////////////
		if(IsACop(playerid))
		{
			//GiveWeapon(playerid, 31, 5000); // M4
			GiveWeapon(playerid, 34, 250); // Sniper
			GiveWeapon(playerid, 31, 3000); // M4
			//GiveWeapon(playerid, 27, 500); // Combat
			GiveWeapon(playerid, 24, 2500); // Desert Eagle
			GiveWeapon(playerid, 43, 150); //  Fényképezõ
			//GiveWeapon(playerid, 4, 1); //kés

			OnDuty[playerid] = 1;
			Helyszinel[playerid] = true;
			VanKB[playerid] = true; // kerékbilincs
			PlayerChannel[playerid] = EMERGENCY_CHANNEL;
			GameTextForPlayer(playerid, "Rendvédelmi cucckombó leaddolva!", time, style);
		}
		else if(Civil(playerid))
		{
			GiveWeapon(playerid, 24, 100); // Desert Eagle
			GameTextForPlayer(playerid, "Nem vagy frakcióban ezért csak deaglet kapsz!", time, style);
		}
		else
		{
			//GiveWeapon(playerid, 30, 5000); // AK47
			GiveWeapon(playerid, 28, 3000); // UZI
			GiveWeapon(playerid, 25, 500); //shotgun
			GiveWeapon(playerid, 23, 1000); // Silenced Colt
			GiveWeapon(playerid, 18, 30); // Molotov
			GiveWeapon(playerid, 4, 1); //kés
			
			new szam = 10;
			PlayerInfo[playerid][pCigi] = szam;
			PlayerInfo[playerid][pGyujto] = szam;
			
			GameTextForPlayer(playerid, "Illegális cucckombó leaddolva!", time, style);
		}		
		FegyverElrak(playerid);	
		return 1;
	}
	
	if(egyezik(cmd, "/crash"))
	{
		if(!IsRicardo(playerid)) return HibasParancs(playerid);
		if(params < 1) return Msg(playerid, "Használat: /crash [JátékosID/NévRészlet]");
		new player = ReturnUser(param[1]);
		if(!Logged(player)) return 1;
		Crash(player);
		Msg(playerid, "Kész!");
		return 1;
	}
	
	if(egyezik(cmd, "/swat"))
	{
		if(PlayerInfo[playerid][pSWATTag] == 0 && !IsFejleszto(playerid)) return Msg(playerid, "Nem vagy SWAT Tag!");
		if(params < 1)
		{
			if(PlayerInfo[playerid][pSWATTag] == 1 && PlayerInfo[playerid][pSWATRang] == 0 || PlayerInfo[playerid][pSWATRang] == 1)
				Msg(playerid, "Használat: /SWAT [Felszerelés]");
			else if(PlayerInfo[playerid][pSWATTag] == 1 && PlayerInfo[playerid][pSWATRang] > 1)
				Msg(playerid, "Használat: /swat [Tagok / Felszerelés]");
			else if(PlayerInfo[playerid][pSWATTag] == 2)
				Msg(playerid, "Használat: /swat [Felvesz / Kirúg / Rang / Tagok / Felszerelés]");
			
			if(IsFejleszto(playerid))
				Msg(playerid, "Használat: /swat [Leader]");
			return 1;
		}
		if(egyezik(param[1], "tagok"))
		{
			if(PlayerInfo[playerid][pSWATRang] < 2) return 1;
			SendClientMessage(playerid, COLOR_LIGHTBLUE, "===============[SWAT Tagok]===============");
			PlayerForeach(i)
			{
				if(IsValidPlayerID(i))
				{
					if(PlayerInfo[i][pSWATTag] == 1)
					{
						SendFormatMessage(playerid, COLOR_LIGHTRED, "[ID:%d]%s - %s[%d]", i, PlayerName(i), SWATRangok[PlayerInfo[i][pSWATRang]], PlayerInfo[i][pSWATRang]);
					}
					if(PlayerInfo[i][pSWATTag] == 2)
					{
						SendFormatMessage(playerid, COLOR_LIGHTRED, "[ID:%d]%s - %s[%d] - Leader", i, PlayerName(i), SWATRangok[PlayerInfo[i][pSWATRang]], PlayerInfo[i][pSWATRang]);
					}
				}
			}
		}
		else if(egyezik(param[1], "felvesz"))
		{
			if(PlayerInfo[playerid][pSWATTag] != 2) return 1;
			if(params < 2) return Msg(playerid, "Használat: /swat Felvesz [JátékosID/NévRészlet]");
			new player = ReturnUser(param[2]);
			if(!Logged(player)) return Msg(playerid, "Nincs ilyen játékos!");
			if(PlayerInfo[player][pSWATTag] != 0) return Msg(playerid, "Ez a játékos már SWAT Tag!");
			
			SendClientMessage(playerid, COLOR_LIGHTBLUE, "Felvetted a SWAT Egységhez!");
			SendClientMessage(player, COLOR_LIGHTBLUE, "Felvettek a SWAT Egységhez!");
			SendClientMessage(player, COLOR_LIGHTBLUE, "SWAT Rádió: /tradio (/tr)");
			SendClientMessage(player, COLOR_LIGHTBLUE, "SWAT VezérParancsnok: Eric Butcher");
			SendClientMessage(player, COLOR_LIGHTBLUE, "Mostantól felveheted az SWAT felszerelést!");
			PlayerInfo[player][pSWATTag] = 1;
			PlayerInfo[player][pSWATRang] = 0;
			return 1;
		}
		else if(egyezik(param[1], "kirúg"))
		{
			if(PlayerInfo[playerid][pSWATTag] != 2) return 1;
			if(params < 2) return Msg(playerid, "Használat: /swat Kirúg [JátékosID/NévRészlet]");
			new player = ReturnUser(param[2]);
			if(!Logged(player)) return Msg(playerid, "Nincs ilyen játékos!");
			if(PlayerInfo[player][pSWATTag] != 1) return Msg(playerid, "Ez a játékos nem SWAT Tag!");
			
			SendClientMessage(playerid, COLOR_LIGHTBLUE, "Kirúgtad a SWAT egységtõl!");
			SendClientMessage(player, COLOR_LIGHTBLUE, "Kirúgtak a SWAT Egységtõl!");
			SendClientMessage(player, COLOR_LIGHTBLUE, "Mostantól nem tudod felvenni a SWAT felszerelést!");
			PlayerInfo[player][pSWATTag] = 0;
			PlayerInfo[player][pSWATRang] = 0;
			return 1;
		}
		else if(egyezik(param[1], "rang"))
		{
			if(PlayerInfo[playerid][pSWATTag] != 2) return 1;
			if(params < 3) return Msg(playerid, "Használat: /swat Rang [JátékosID/NévRészlet] [Rang 0-14]");
			new player = ReturnUser(param[2]);
			if(!Logged(player)) return Msg(playerid, "Nincs ilyen játékos!");
			if(PlayerInfo[player][pSWATTag] == 0) return Msg(playerid, "Ez a játékos nem SWAT Tag!");
			new rang = strval(param[3]);
			if(rang < 0 || rang > 14) return Msg(playerid, "0-14-ig legyen a rang!");
			
			PlayerInfo[player][pSWATRang] = rang;
			format(string, sizeof(string), "A SWAT Egységben új rangot(%d) adtál neki: %s", rang, PlayerName(player));
			SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
			format(string, sizeof(string), "A SWAT Egységben új rangot kaptál!", rang);
			SendClientMessage(player, COLOR_LIGHTBLUE, string);
			format(string, sizeof(string), "Új rang: (%d)%s", rang, SWATRangok[rang]);
			SendClientMessage(player, COLOR_LIGHTBLUE, string);
			return 1;
		}
		else if(egyezik(param[1], "leader"))
		{
			if(!IsFejleszto(playerid)) return HibasParancs(playerid, true);
			if(params < 2) return Msg(playerid, "Használat: /swat Leader [JátékosID/NévRészlet]");
			new player = ReturnUser(param[2]);
			if(!Logged(player)) return Msg(playerid, "Nincs ilyen játékos!");
			
			if(PlayerInfo[player][pSWATTag] != 2)
			{
				PlayerInfo[player][pSWATTag] = 2;
				PlayerInfo[player][pSWATRang] = 0;
				SendClientMessage(playerid, COLOR_LIGHTBLUE, "Kinevezted a SWAT Vezetõjévé!");
				SendClientMessage(player, COLOR_LIGHTBLUE, "Kineveztek a SWAT Vezetõjévé!");
				return 1;
			}
			if(PlayerInfo[player][pSWATTag] == 2)
			{
				PlayerInfo[player][pSWATTag] = 0;
				PlayerInfo[player][pSWATRang] = 0;
				SendClientMessage(playerid, COLOR_LIGHTBLUE, "Elvetted a SWAT Leaderét!");
				SendClientMessage(player, COLOR_LIGHTBLUE, "Elvették a SWAT Leaderedet!");
				return 1;
			}
			return 1;
		}
		else if(egyezik(param[1], "nulláz"))
		{
			if(!IsRicardo(playerid)) return HibasParancs(playerid, true);
			
			PlayerForeach(x)
			{
				if(Logged(x))
				{
					if(PlayerInfo[x][pSWATTag] > 0)
					{
						PlayerInfo[x][pSWATTag] = 0;
						PlayerInfo[x][pSWATRang] = 0;
					}
				}
			}
			
			mysql_query("UPDATE playerek SET Swat='0', SwatRang='0' WHERE Swat > 0");
			mysql_free_result();			
			Msg(playerid, "Nulláztad a SWAT-et!");
			return 1;
		}
		else if(egyezik(param[1], "felszerelés") || egyezik(param[1], "felszereles"))
	    {
	        if(params < 2)
	        {
	            Msg(playerid, "/swat Felszerelés [Szám]");
	            Msg(playerid, "1: S.W.A.T. tömegoszlató felszerelés | 2: S.W.A.T. bevetési felszerelés  | 3: SWAT felszerelés leadása");
				return 1;
	        }
			//if(OnDuty[playerid] != 1) return Msg(playerid, "Nem vetted fel az alapszolgálatot!");
		    if(PlayerToPoint(5, playerid, FrakcioDuty[LMUNKA_SWAT][dX], FrakcioDuty[LMUNKA_SWAT][dY], FrakcioDuty[LMUNKA_SWAT][dZ]))
			{
			    new id = strval(param[2]);
			    if(id == 1)
			    {
			        ResetWeapon(playerid);
					OnDuty[playerid] = 1;
					SetHealth(playerid, MAXHP);
					SetPlayerArmour(playerid, MAXARMOUR);
					SetPlayerSkin(playerid, 285);
					
					GiveWeapon(playerid, 41, 5000);
					GiveWeapon(playerid, 17, 50);
					GiveWeapon(playerid, 3, 1);
					GiveWeapon(playerid,24,250);
					GiveWeapon(playerid,29,500);
					GiveWeapon(playerid, 46, 1);
					
					format(string, sizeof(string), "* Valaki felvette az alap SWAT felszerelést.");
					ProxDetector(30.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
			    }
			    else if(id == 2)
			    {
			        ResetWeapon(playerid);
					OnDuty[playerid] = 1;
					SetHealth(playerid, MAXHP);
					SetPlayerArmour(playerid, MAXARMOUR);
					SetPlayerSkin(playerid, 285);
					
					GiveWeapon(playerid, 41, 950);
					GiveWeapon(playerid,45,1); //Éjjellátó
					GiveWeapon(playerid,31,500);
					GiveWeapon(playerid, 17, 80);
					GiveWeapon(playerid,34,100);
					GiveWeapon(playerid,24,500);
					GiveWeapon(playerid,27,500);
					GiveWeapon(playerid,29,500);					
					GiveWeapon(playerid, 46, 1);
					
					format(string, sizeof(string), "* Valaki felvette a Támadó SWAT felszerelést.");
					ProxDetector(30.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
			    }
			    else if(id == 3/* && OnDuty[playerid] == 1*/)
			    {
					ResetWeapon(playerid);
					Munkaruha(playerid, 1);
					format(string, sizeof(string), "* Valaki leadta a SWAT felszerelést.");
					ProxDetector(30.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
				}
			    else
			    {
			        Msg(playerid, "/swat Felszerelés [Szám]");
	            	Msg(playerid, "1: Alap SWAT felszerelés | 2: Támadó SWAT felszerelés | 3: SWAT felszerelés leadása");
			    }
			    
			}
			else
				return Msg(playerid, "Hol akarod felvenni?!");
		}
		return 1;
	}
	
	if(egyezik(cmd, "/fkp"))
	{
		if(PlayerInfo[playerid][pLeader] == 0) return Msg(playerid, "Nem vagy frakció leader!");
		
		new lekeres = PlayerInfo[playerid][pLeader];
		new cim[48]; 
		Format(cim, "'%s' frakció kezelõ panel", Szervezetneve[lekeres-1][2]);
		
		ShowPlayerDialog(playerid, DIALOG_FKP_FOMENU, DIALOG_STYLE_LIST, cim, "Tag kezelés\nJármû kezelés\nRangok szerkesztése\nFizetések szerkesztése", "Megnyit", "Bezár");
		return 1;
	}
	
	if(egyezik(cmd, "/cskp") OR egyezik(cmd, "/cspanel"))
	{
		new CsoportID = PlayerInfo[playerid][pCsoport];
		if(CsoportID == 0)
		{
			PlayerTextFormat(playerid, "Nem vagy egyetlen csoport tagja sem!\
			\n\nAmennyiben csoportot szeretnél létrehozni ezt megteheted a UserCP-n!", COLOR_MSG);
			MsgDialog(playerid, "Csoport Kezelõ Panel", PlayerText[playerid], "Bezárás");
		}
		else
		{
			PlayerTextFormat(playerid, "'%s' csoport kezelõ panel", CsoportInfo[CsoportID][CsNev]);

			//new opciok[128] = "Tag felvétel\nTag kirugás\nOnline tagok megtekintése\nCsoport nevének szerkesztése";
			new opciok[128] = "Tag felvétel\nTag kirugás\nOnline tagok megtekintése";
			ShowPlayerDialog(playerid, DIALOG_CSPANEL_FOMENU, DIALOG_STYLE_LIST, PlayerText[playerid], opciok, "Megnyit", "Bezár");
		}
		return 1;
	}
	
	/*if(egyezik(cmd, "/csrb"))
	{		
		//if(Kezenlove[playerid]) return Msg(playerid, "Nem tudsz rádiózni, mert meglõtték a kezed!");
		if(Csendvan) return Msg(playerid, "Most nem beszélhetsz!");
		//if(RadioElveve[playerid]) return Msg(playerid, "Elvették a rádiódat, nem tudsz beszélni!");
		new length = strlen(cmdtext);
		while ((idx < length) && (cmdtext[idx] <= ' '))
		{
			idx++;
		}
		new offset = idx;
		new result[64];
		while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
		{
			result[idx - offset] = cmdtext[idx];
			idx++;
		}
		result[idx - offset] = EOS;
		if(!strlen(result)) return Msg(playerid, "Csoport OOC rádió | Használat: /csrb [üzenet]");

		if(SzovegEllenorzes(playerid, result, "/csrb", ELLENORZES_HIRDETES)) return 1;
		
		new 
			szoveg[128],
			CsoportID = PlayerInfo[playerid][pCsoport]
		;
		
		Format(szoveg, "(( [OOC-R] %s: %s ))", PlayerName(playerid), result);
		PlayerForeach(x)
		{
			if(PlayerInfo[x][pCsoport] == CsoportID)
			{
				SendClientMessage(x, COLOR_LILA, szoveg);
			}
		}		
		return 1;
	}*/
	if(egyezik(cmd, "/vwbug") || egyezik(cmd, "/vw"))
	{
		if(!Admin(playerid, 1) && !IsAS(playerid)) return 1;
		if(params != 1) return Msg(playerid, "/vwbug [JátékosID/NévRészlet]");
		new jatekos = ReturnUser(param[1]);
		if(IsPlayerNPC(jatekos)) return Msg(playerid, "Hagyd békén az NPC-t!");
		if(jatekos == INVALID_PLAYER_ID) return Msg(playerid, "Nincs ilyen játékos!");
		if(PlayerInfo[jatekos][pTutorial] == 0) return Msg(playerid, "A játékos számára még nem engedélyezett a játék!");
		ABroadCastFormat(COLOR_LIGHTRED, 1, "(%s) %s átállította %s VW-jét és Int-jét!", AdminSzint(playerid), PlayerName(playerid), PlayerName(jatekos));
		
		ResetVW(jatekos);
		return 1;
	}
	
	if(egyezik(cmd,"/td") || egyezik(cmd,"/infobar"))
	{
		if(egyezik(param[1], "be")) ShowInfoBar(playerid, true);
		else if(egyezik(param[1], "ki")) ShowInfoBar(playerid, false);
		else Msg(playerid, "/infobar [Be/Ki]");
		return 1;
	}
	
	if(egyezik(cmd,"/kiegészítõk") || egyezik(cmd,"/kiegeszitok"))
	{
		if(!IsRicardo(playerid)) return Msg(playerid, "Hamarosan..");
		ShowPlayerDialog(playerid, DIALOG_DIVATBOLT_KATEGORIAK, DIALOG_STYLE_LIST, "Divatbolt", "Új kiegészítõ\nKiegészítõk szerkesztése", "Tovább", "Mégse");
		return 1;
	}

	if(egyezik(cmd, "/kdebug"))
	{
		if(!IsRicardo(playerid)) return HibasParancs(playerid, true);
		if(kdebug[playerid] == 1)
		{
			Msg(playerid, "Kapu Debug kikapcsolva!")
			kdebug[playerid] = 0;
		}
		else
		{
			Msg(playerid, "Kapu Debug bekapcsolva!")
			kdebug[playerid] = 1;
		}
	}
	
	if(egyezik(cmd, "/checkban"))
	{
		if(!Admin(playerid, 1)) return HibasParancs(playerid, true);
		if(params != 1) return Msg(playerid, "/checkban [Játékos Teljes IG Neve, Vagy IP]");
		if(strlen(param[1]) > MAX_PLAYER_NAME) return Msg(playerid, "A Név max 24 karakter te low");
		CheckBan(playerid, param[1]);
		return 1;
	}
	
	if(egyezik(cmd, "/dutypos"))
	{
		if(!Admin(playerid, 4)) return HibasParancs(playerid, true);
		if(params < 2) return Msg(playerid, "Használat: /dutypos [Go / Set] [Frakció ID]");
		if(egyezik(param[1], "set"))
		{
			new frakcio = strval(param[2]);
			if(frakcio < 1 && frakcio > MAX_FRAKCIO) return Msg(playerid, "Nincs ilyen frakció!");
			new Float:X, Float:Y, Float:Z;
			GetPlayerPos(playerid, X, Y, Z);
			FrakcioDuty[frakcio][dX] = X;
			FrakcioDuty[frakcio][dY] = Y;
			FrakcioDuty[frakcio][dZ] = Z;
			DutyUpdate(frakcio, "x='%f',y='%f',z='%f'", X, Y, Z);
			new kiiras[128];
			format(kiiras, 128, "%s Duty Poziciója áthelyezve! (X: %f | Y: %f | Z: %f)", Szervezetneve[frakcio-1][0], X, Y, Z);
			Msg(playerid, kiiras);
			return 1;
		}
		else if(egyezik(param[1], "go"))
		{
			new frakcio = strval(param[2]);
			if(frakcio < 1 && frakcio > MAX_FRAKCIO) return Msg(playerid, "Nincs ilyen frakció!");
			SetPlayerPos(playerid, FrakcioDuty[frakcio][dX], FrakcioDuty[frakcio][dY], FrakcioDuty[frakcio][dZ]);
			new kiiras[128];
			format(kiiras, 128, "%s Duty Poziciójára teleportáltál! (X: %f | Y: %f | Z: %f)", Szervezetneve[frakcio-1][0], FrakcioDuty[frakcio][dX], FrakcioDuty[frakcio][dY], FrakcioDuty[frakcio][dZ]);
			Msg(playerid, kiiras);
			return 1;
		}		
		return 1;
	}
	
	/* ############################# Animrendszer ############################# */
	if(egyezik(cmd, "/anims") || egyezik(cmd, "/animlist"))
	{
		new anim_string[1800];
		
		SendClientMessage(playerid, COLOR_GREEN, "_______________________________________");
		SendClientMessage(playerid, COLOR_GREEN, "__________| Karakter Animációk |_________");
		SendClientMessage(playerid, COLOR_WHITE, "[Ülés/Lazulás] /msit /fsit /sit [1-2] /lay [1-3]");
		SendClientMessage(playerid, COLOR_WHITE, "[Jelzések] /gangsign [1-5] /wave");
		SendClientMessage(playerid, COLOR_WHITE, "[Kommunikáció] /chat [1-9] /deal [1-2]");
		SendClientMessage(playerid, COLOR_WHITE, "[Kommunikáció] /yes /greet /thankyou /invite1 /invite2");
		SendClientMessage(playerid, COLOR_WHITE, "[Kommunikáció] /gang1 /gang2 /gang3 /cry1 /cry2 /fucku");
		SendClientMessage(playerid, COLOR_WHITE, "[Kommunikáció] /lookout /chant /angry /ghand1 /ghand2");
		SendClientMessage(playerid, COLOR_WHITE, "[Fizikai Akciók] /box /akick /bat1 /bat2 /taichi");
		
		strcat(anim_string, "| /crack | /handsup | /slapass | /seat | /drunk | /laugh |\n");
		strcat(anim_string, "| /plant | /vomit | | /reload | /lift | /cover | /put |\n");
		strcat(anim_string, "| /cpr | /hitchhike  | /drink | /tired | /throw | /checkout |\n");
		strcat(anim_string, "| /pee | /cellin  | /cellout | /shakehead | /benddown |\n");
		strcat(anim_string, "| /bj | /bj2 | /bj3 | /bj4 | /piss | /follow | /greet |\n");
		strcat(anim_string, "| /stand | /hitch | /bitchslap /kiss1 | /chairsit |\n");
		strcat(anim_string, "| /slapped | /skate | /gwalk | /gwalk2 | /limp | /eatsit |\n");
		strcat(anim_string, "| /celebrate | /win | /win2 | /yes | /thankyou | /invite1 |\n");
		strcat(anim_string, "| /invite2 | /celebrate2 | /scratch | /bomb | /getarrested |\n");
		strcat(anim_string, "| /lookout | /robman | /eat | /wave | /smokem | /smokef |\n");
		strcat(anim_string, "| /msit | /fsit | /fucku | /taichi | /relax | /bat1 | /bat2 |\n");
		strcat(anim_string, "| /bat3 | /bat4 | /bat5 | /nod | /gang1 | /gang2 | /gang3 |\n");
		strcat(anim_string, "| /gang4 | /gang5 | /gang6 | /gang7 | /cry1 | /cry2 | /bed1 |\n");
		strcat(anim_string, "| /bed2 | /bed3 | /bed4 | /kiss2 | /kiss3 | /kiss4 | /kiss5 |\n");
		strcat(anim_string, "| /kiss6 | /kiss7 | /kiss8 | /carsit | /carsit2 | /fwalk |\n");
		strcat(anim_string, "| /mwalk | /stretch |/chant | /angry | /crack2 | /ghand1 |\n");
		strcat(anim_string, "| /ghand2 | /ghand3 | /ghand4 | /ghand5 | /exhausted | /carsmoke |\n");
		strcat(anim_string, "| /getup | /basket1 | /basket2 | /basket3 | /basket4 | /basket5 |\n");
		strcat(anim_string, "| /basket6 | /akick | /box | /cockgun | /bar1 | /bar2 | /bar3 |\n");
		strcat(anim_string, "| /bar4 | /lay2 | /liftup | /putdown | /joint | /die | /die2 |\n");
		strcat(anim_string, "\n \n");
		strcat(anim_string, "| /smoke [1-2] | /lean [1-2] | /dance [1-15] | /rap [1-3] | /gangsign [1-5] |\n");
		strcat(anim_string, "| /strip [1-7] | /lay [1-3] | /sit [1-2] | /aim [1-7] | /fall [1-6] | /injured [1-2] |\n");
		strcat(anim_string, "| /chat [1-9] | /ball [1-7] | /friskanim [1-2] | /deal [1-2] | /crossarms [1-5] |\n");
		
		ShowPlayerDialog(playerid, DIALOG_NINCS, DIALOG_STYLE_LIST, "Egyéb Animációk", anim_string, "O", "K");
		return 1;
	}
	
	if(egyezik(cmd, "/stopanim"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		Cselekves(playerid, "használta a /stopanim parancsot", 0, true);
		
		if(IsPlayerInAnyVehicle(playerid))
		{
			ClearAnim(playerid);
		}
		else
		{
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
			ClearAnimations(playerid);
		}
		
		iMsg(playerid, "StopAnim aktiválva lett!");
	    return 1;
	}

	/////////////////////////////////////////////////////////////////////ANIMS WITHOUT PARAMETER/////////////////////////////////////////////////////////////////////
	if(egyezik(cmd, "/chat"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		if(params != 1) return Msg(playerid, "Használat: /chat [1-9]");
		new aimid = strval(param[1]);
		switch(aimid)
		{
			case 1: ApplyAnimation(playerid,"PED","IDLE_CHAT", 4.0,0,0,0,1,1);
			case 2: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkA", 4.0,0,0,0,1,1);
			case 3: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkB", 4.0,0,0,0,1,1);
			case 4: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkC", 4.0,0,0,0,1,1);
			case 5: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkD", 4.0,0,0,0,1,1);
			case 6: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkE", 4.0,0,0,0,1,1);
			case 7: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkF", 4.0,0,0,0,1,1);
			case 8: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkG", 4.0,0,0,0,1,1);
			case 9: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkH", 4.0,0,0,0,1,1);
			default: Msg(playerid, "Használat: /chat [1-9]");
		}
		return 1;
	}
	if(egyezik(cmd, "/pee"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"PAULNMAC","Piss_loop", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/cellin"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		SetPlayerSpecialAction(playerid,SPECIAL_ACTION_USECELLPHONE);
		return 1;
	}

	if(egyezik(cmd, "/cellout"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
		return 1;
	}

	if(egyezik(cmd, "/crack"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid, "CRACK", "crckdeth2", 4.0,0,0,0,1,1);
		return 1;
	}

	if(egyezik(cmd, "/handsup"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid, "ROB_BANK", "SHP_HandsUp_Scr", 4.0,0,0,0,1,1);
		return 1;
	}

	if(egyezik(cmd, "/slapass"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"SWEET","sweet_ass_slap", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/seat"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"PED","SEAT_idle", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/drunk"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"PED","WALK_DRUNK", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/laugh"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid, "RAPPING", "Laugh_01", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/cpr"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"MEDIC","CPR", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/hitchhike"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"MISC","Hiker_Pose", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/plant"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/vomit"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid, "FOOD", "EAT_Vomit_P", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/drink"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid, "GANGS", "drnkbr_prtl", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/tired"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"FAT","IDLE_tired", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/reload"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid, "SILENCED", "Silence_reload", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/throw"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid, "GRENADE", "WEAPON_throw", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/lift"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid, "CARRY", "liftup", 4.0, 0, 0, 0, 1, 1);
		return 1;
	}
	if(egyezik(cmd, "/put"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid, "CARRY", "putdwn", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/cover"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid, "ped", "cower", 3.0, 1, 0, 0, 0, 1);
		return 1;
	}
	if(egyezik(cmd, "/bj"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"BLOWJOBZ","BJ_COUCH_START_P", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/bj2"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"BLOWJOBZ","BJ_COUCH_START_W", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/bj3"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"BLOWJOBZ","BJ_COUCH_LOOP_P", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/bj4"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"BLOWJOBZ","BJ_COUCH_LOOP_W", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/piss"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		SetPlayerSpecialAction(playerid, 68);
		return 1;
	}
	if(egyezik(cmd, "/follow"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"WUZI","Wuzi_follow", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/greet"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"WUZI","Wuzi_Greet_Wuzi", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/stand"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"WUZI","Wuzi_stand_loop", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/hitch"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"MISC","Hiker_Pose", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/bitchslap"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"MISC","bitchslap", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/kiss1"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"KISSING","gift_give", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/chairsit"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"PED","SEAT_idle", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/slapped"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"SWEET","ho_ass_slapped", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/skate"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"SKATE","skate_run", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/gwalk"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"PED","WALK_gang1", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/gwalk2"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"PED","WALK_gang2", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/limp"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"PED","WALK_old", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/eatsit"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"FOOD","FF_Sit_Loop", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/celebrate"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"benchpress","gym_bp_celebrate", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/win"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"CASINO","cards_win", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/win2"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"CASINO","Roulette_win", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/yes"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"CLOTHES","CLO_Buy", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/thankyou"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"FOOD","SHP_Thank", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/invite1"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"GANGS","Invite_Yes", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/invite2"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"GANGS","Invite_No", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/celebrate2"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"GYMNASIUM","gym_tread_celebrate", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/scratch"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"MISC","Scratchballs_01", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/bomb"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ClearAnimations(playerid);
		ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0,0,0,0,1,1); // Place Bomb
		return 1;
	}
	if(egyezik(cmd, "/getarrested"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"ped", "ARRESTgun", 4.0,0,0,0,1,1); // Gun Arrest
		return 1;
	}
	if(egyezik(cmd, "/lookout"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid, "SHOP", "ROB_Shifty", 4.0,0,0,0,1,1); // Rob Lookout
		return 1;
	}
	if(egyezik(cmd, "/robman"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid, "SHOP", "ROB_Loop_Threat", 4.0,0,0,0,1,1); // Rob
		return 1;
	}
	if(egyezik(cmd, "/eat")){
		ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.0,0,0,0,1,1); // Eat Burger
		return 1;
	}
	if(egyezik(cmd, "/wave"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid, "ON_LOOKERS", "wave_loop", 4.0,0,0,0,1,1); // Wave
		return 1;
	}
	if(egyezik(cmd, "/smokem"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"SMOKING", "M_smklean_loop", 4.0,0,0,0,1,1); // Smoke
		return 1;
	}
	if(egyezik(cmd, "/smokef"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid, "SMOKING", "F_smklean_loop", 4.0,0,0,0,1,1); // Female Smoking
		return 1;
	}
	if(egyezik(cmd, "/msit"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"BEACH", "ParkSit_M_loop", 4.0,0,0,0,1,1); // Male Sit
		return 1;
	}
	if(egyezik(cmd, "/fsit"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"BEACH", "ParkSit_W_loop", 4.0,0,0,0,1,1); // Female Sit
		return 1;
	}
	if(egyezik(cmd, "/fucku"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"PED","fucku", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/taichi"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"PARK","Tai_Chi_Loop", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/relax"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"BEACH","Lay_Bac_Loop", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/bat1"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"BASEBALL","Bat_IDLE", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/bat2"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"BASEBALL","Bat_M", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/bat3"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"BASEBALL","BAT_PART", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/bat4"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"CRACK","Bbalbat_Idle_01", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/bat5"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"CRACK","Bbalbat_Idle_02", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/nod"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"COP_AMBIENT","Coplook_nod", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/gang1"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"GANGS","hndshkaa", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/gang2"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"GANGS","hndshkba", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/gang3"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"GANGS","hndshkca", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/gang4"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"GANGS","hndshkcb", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/gang5"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"GANGS","hndshkda", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/gang6"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"GANGS","hndshkea", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/gang7"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"GANGS","hndshkfa", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/cry1"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"GRAVEYARD","mrnF_loop", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/cry2"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"GRAVEYARD","mrnM_loop", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/bed1"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"INT_HOUSE","BED_In_L", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/bed2"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"INT_HOUSE","BED_In_R", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/bed3"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"INT_HOUSE","BED_Loop_L", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/bed4"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"INT_HOUSE","BED_Loop_R", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/kiss2"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"BD_FIRE","Grlfrd_Kiss_03", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/kiss3"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"KISSING","Grlfrd_Kiss_01", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/kiss4"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"KISSING","Grlfrd_Kiss_02", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/kiss5"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"KISSING","Grlfrd_Kiss_03", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/kiss6"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"KISSING","Playa_Kiss_01", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/kiss7"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"KISSING","Playa_Kiss_02", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/kiss8"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"KISSING","Playa_Kiss_03", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/carsit"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"CAR","Tap_hand", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/carsit2"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"LOWRIDER","Sit_relaxed", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/fwalk"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"ped","WOMAN_walksexy", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/mwalk"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"ped","WALK_player", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/stretch"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"PLAYIDLES","stretch", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/chant"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"RIOT","RIOT_CHANT", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/angry"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"RIOT","RIOT_ANGRY", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/crack2"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid, "CRACK", "crckidle2", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/ghand1"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"GHANDS","gsign1LH", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/ghand2"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"GHANDS","gsign2LH", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/ghand3"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"GHANDS","gsign3LH", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/ghand4"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"GHANDS","gsign4LH", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/ghand5"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"GHANDS","gsign5LH", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/exhausted"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"FAT","IDLE_tired", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/carsmoke"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"PED","Smoke_in_car", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/getup"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"PED","getup", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/basket1"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"BSKTBALL","BBALL_def_loop", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/basket2"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"BSKTBALL","BBALL_idleloop", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/basket3"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"BSKTBALL","BBALL_pickup", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/basket4"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"BSKTBALL","BBALL_Jump_Shot", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/basket5"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"BSKTBALL","BBALL_Dnk", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/basket6"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"BSKTBALL","BBALL_run", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/akick"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"FIGHT_E","FightKick", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/box"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"GYMNASIUM","gym_shadowbox", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/cockgun"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid, "SILENCED", "Silence_reload", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/bar1"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid, "BAR", "Barcustom_get", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/bar2"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid, "BAR", "Barcustom_order", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/bar3"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid, "BAR", "Barserve_give", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/bar4"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid, "BAR", "Barserve_glass", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/lay2"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"BEACH", "SitnWait_loop_W", 4.0,0,0,0,1,1); // Lay down
		return 1;
	}
	if(egyezik(cmd, "/liftup"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid, "CARRY", "liftup", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/putdown"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid, "CARRY", "putdwn", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/joint"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"GANGS","smkcig_prtl", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/die"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid,"KNIFE","KILL_Knife_Ped_Die", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/shakehead"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid, "MISC", "plyr_shkhead", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/die2"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid, "PARACHUTE", "FALL_skyDive_DIE", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/benddown"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid, "BAR", "Barserve_bottle", 4.0,0,0,0,1,1);
		return 1;
	}
	if(egyezik(cmd, "/checkout"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		ApplyAnimation(playerid, "GRAFFITI", "graffiti_Chkout", 4.0,0,0,0,1,1);
		return 1;
	}
	/* ########################################################################################## */
	
	if(egyezik(cmd, "/poloska"))
	{
		if(!Admin(playerid,FOADMIN) && !LMT(playerid,LMUNKA_FBI) && PlayerInfo[playerid][pNIDTag] == 0 && PlayerInfo[playerid][pHitman] == 0) return Msg(playerid, "Nem használhatod!");
		if(params < 1) return Msg(playerid, "/poloska [Deaktivál/Hallgat]");
		else if(egyezik(param[1], "deaktivál") || egyezik(param[1], "deaktival"))
		{
			if(Poloska[playerid] == NINCS) return Msg(playerid, "Nincs aktív poloskád!");
			Poloska[playerid] = NINCS;
			Msg(playerid, "Poloska deaktiválva!");
		}
		else if(egyezik(param[1], "hallgat"))
		{
			if(Poloska[playerid] == NINCS) return Msg(playerid, "Nincs aktív poloskád!");
			if(PoloskaHallgat[playerid])
			{
				PoloskaHallgat[playerid] = false;
				Msg(playerid, "Poloska hallgatása kikapcsolva!");
			}
			else
			{
				PoloskaHallgat[playerid] = true;
				Msg(playerid, "Poloska hallgatása bekapcsolva!");
			}
		}
	}
	
	if(egyezik(cmd, "/adatnézés") || egyezik(cmd, "/adatnezes"))
	{
		if(!LMT(playerid, LMUNKA_LSPD) && !LMT(playerid, LMUNKA_FBI) && PlayerInfo[playerid][pNIDTag] == 0)
		{
			return Msg(playerid, "Nem-nem!");
		}
		if(params < 1)	return Msg(playerid, "Használat: /adatnézés [játékos | jármû | ház] [ID]");
		if(egyezik(param[1], "játékos") || egyezik(param[1], "jatekos"))
		{
			tmp = param[2];
			new player = ReturnUser(tmp);
			if(!strlen(tmp)) return Msg(playerid, "Adatnézés játékos [JátékosID/NévRészlet]");
			if(PlayerInfo[player][pArrested] < 1) return Msg(playerid, "Róla nincs akta, mivel még nem volt lecsukva.");
			if(player == INVALID_PLAYER_ID) return Msg(playerid, "Hibás név!");
			Akta(playerid, player);
			return 1;
		}
		if(egyezik(tmp, "jármû") || egyezik(tmp, "jarmu"))
		{
			tmp = param[2];
			if(!strlen(tmp))	return Msg(playerid, "adatnézés jármû [KocsiID]");
			new car = strval(tmp);
			SendFormatMessage(playerid, COLOR_YELLOW, "Rendszám: SeeRPG-%d | Tulajdonos: %s | Tipus: %s | Szine(1): %d | Szine(2): %d", car, CarInfo[car][cOwner], GetVehicleModelName(GetVehicleModel(CarInfo[car][cId])), CarInfo[CarInfo[car][cId]][cColorOne], CarInfo[CarInfo[car][cId]][cColorTwo]);
		}
		if(egyezik(tmp, "ház") || egyezik(tmp, "haz"))
		{
			tmp = param[2];
			if(!strlen(tmp)) return Msg(playerid, "adatnézés haz [HázID]");
			new haz = strval(tmp);
			SendFormatMessage(playerid, COLOR_YELLOW, "Házszám: Los Santos str. %d | Tulajdonos: %s | Belsõ: %s", haz, HouseInfo[haz][hOwner], HouseInfo[haz][hBelso]);
		}
	}
	
	if(egyezik(cmd, "/bsz") || egyezik(cmd, "/bankszamla") || egyezik(cmd, "/bankszámla"))
	{
		new atmnel = ATMnelVan(playerid);
	    if(!Bankban(playerid) && atmnel == NINCS) return Msg(playerid, "Nem vagy bankban vagy ATM-nél!");
	    //if(!Bankban(playerid) && ATMnelVan(playerid) && PlayerInfo[playerid][pBankKartya] != 1) return Msg(playerid, "Ahhoz, hogy használd az ATM-et szükséged van bankkártyára!");
		if(atmnel != -1 && ATM[atmnel][aKirabolva] != 0) return Msg(playerid, "Ez az ATM nem használható!");
		if(IsPlayerInAnyVehicle(playerid)) return Msg(playerid, "Jármûbõl akarod használni az ATM-et?");
        ShowBankDialog(playerid, true);		
		return 1;
	}
	
	if(egyezik(cmd, "/táska") || egyezik(cmd, "/taska") || egyezik(cmd, "/satchel"))
	{
		if(params < 1)
		{
			Msg(playerid, "/táska [Lerak / Felvesz / Átnéz / Kivesz / Berak]");
			return 1;
		}
		if(egyezik(param[1], "lerak") || egyezik(param[1], "Takedown"))//
		{
			if(TaskaKezbe[playerid] == NINCS && TaskaVan[playerid] == 0)
			{
				Msg(playerid, "Nincs táska a kezedben!");
				return 1;
			}
			new Float:Poz[3];
			GetPlayerPos(playerid,Poz[0],Poz[1],Poz[2]);
			if(TaskaVan[playerid] != 0)
			{
				TaskaLerak(playerid,Poz[0],Poz[1],Poz[2],GetPlayerInterior(playerid),GetPlayerVirtualWorld(playerid));
				Cselekves(playerid, "lerakott egy táskát",1);
				TaskaVan[playerid] = 0;
				return 1;
			}
			if(TaskaKezbe[playerid] != NINCS)
			{
				new Int = GetPlayerInterior(playerid);
				new VW = GetPlayerVirtualWorld(playerid);
				TaskaInfo[TaskaKezbe[playerid]][Van] = 1;
				TaskaInfo[TaskaKezbe[playerid]][tPos][0] = Poz[0];
				TaskaInfo[TaskaKezbe[playerid]][tPos][1] = Poz[1];
				TaskaInfo[TaskaKezbe[playerid]][tPos][2] = Poz[2];
				TaskaInfo[TaskaKezbe[playerid]][tInt] = Int;
				TaskaInfo[TaskaKezbe[playerid]][tVW] = VW;
				TaskaInfo[TaskaKezbe[playerid]][tObject] = CreateDynamicObject(1210, Poz[0], Poz[1], Poz[2]-0.8, 0.0, 0.0, 0.0, VW, Int);
				KezObject_Torol(playerid);
				TaskaKezbe[playerid] = NINCS;
				Cselekves(playerid, "lerakott egy táskát",1);
				return 1;
			}
			return 1;
		}
		else if(egyezik(param[1], "felvesz") || egyezik(param[1], "Takeup"))
		{
			if(TaskaKezbe[playerid] != NINCS || TaskaVan[playerid] != 0) return Msg(playerid, "Már van a kezedbe táska!");
			new taska = GetClosestTaska(playerid);
			new Float:tav = GetDistanceToTaska(playerid,taska);
			if(tav > 2.0) return Msg(playerid, "Nincs a közelben táska");
			//KezObject_Felrak(playerid,1210, "bal");
			SetPlayerAttachedObject(playerid, SLOT_KEZ,1210,5,0.3,0.1,0.0,0.0,270.0,0.0);
			TaskaInfo[taska][tPos][0] = 0.0
			TaskaInfo[taska][tPos][1] = 0.0
			TaskaInfo[taska][tPos][2] = 0.0
			DestroyDynamicObject(TaskaInfo[taska][tObject]);
			TaskaInfo[taska][tObject] = NINCS;
			Cselekves(playerid, "felvette a táskát a földrõl");
			TaskaKezbe[playerid] = taska;
			return 1;
		}
		else if(egyezik(param[1], "átnéz") || egyezik(param[1], "atnez") || egyezik(param[1], "review"))
		{
			new taska = GetClosestTaska(playerid);
			new Float:tav = GetDistanceToTaska(playerid,taska);
			if(tav > 2.0) return Msg(playerid, "Nincs a közelben táska");
			SendFormatMessage(playerid,COLOR_LIGHTGREEN, "Kokain: %d/%d | Heroin %d/%d | Marihuana: %d/%d",TaskaInfo[taska][tKokain],MAXTASKADROG,TaskaInfo[taska][tHeroin],MAXTASKADROG,TaskaInfo[taska][tMarihuana],MAXTASKADROG);
			SendFormatMessage(playerid,COLOR_LIGHTGREEN, "Pénz: %d/$%d",TaskaInfo[taska][tPenz],MAXTASKAPENZ);
			if(TaskaInfo[taska][tFegyver][0] > 0 && TaskaInfo[taska][tFegyver][1] > 0)
			{
				SendFormatMessage(playerid,COLOR_LIGHTGREEN, "Fegyver: %s - %d",aWeaponNames[TaskaInfo[taska][tFegyver][0]],TaskaInfo[taska][tFegyver][1]);
			}
			Cselekves(playerid, "átnézte a táskát");
			return 1;
		}
		else if(egyezik(param[1], "kivesz") || egyezik(param[1], "Takeout"))
		{
			new taska = GetClosestTaska(playerid);
			new Float:tav = GetDistanceToTaska(playerid,taska);
			if(tav > 2.0) return Msg(playerid, "Nincs a közelben táska");
			if(params < 2 && !egyezik(param[2], "fegyver")) return Msg(playerid, "/táska kivesz [Mit] [Mennyit]");
			new mennyit = strval(param[3]);
			if(egyezik(param[2], "kokain"))
			{
				if(params < 3) return Msg(playerid, "/táska kivesz [Mit] [Mennyit]");
				if(mennyit < 1) return Msg(playerid, "-.-");
				if(TaskaInfo[taska][tKokain] < mennyit) return Msg(playerid, "Nincs benne ennyi kokain!");
				PlayerInfo[playerid][pKokain] += mennyit;
				TaskaInfo[taska][tKokain] -= mennyit;
				SendFormatMessage(playerid,COLOR_LIGHTBLUE, "Kivettél %d gramm kokaint a táskából!",mennyit);
				Cselekves(playerid, "kivett valamit az aktatáskából",1);
				return 1;
			}
			else if(egyezik(param[2], "heroin"))
			{
				if(params < 3) return Msg(playerid, "/táska kivesz [Mit] [Mennyit]");
				if(mennyit < 1) return Msg(playerid, "-.-");
				if(TaskaInfo[taska][tHeroin] < mennyit) return Msg(playerid, "Nincs benne ennyi heroin!");
				PlayerInfo[playerid][pHeroin] += mennyit;
				TaskaInfo[taska][tHeroin] -= mennyit;
				SendFormatMessage(playerid,COLOR_LIGHTBLUE, "Kivettél %d gramm heroint a táskából!",mennyit);
				Cselekves(playerid, "kivett valamit az aktatáskából",1);
				return 1;
			}
			else if(egyezik(param[2], "marihuana"))
			{
				if(params < 3) return Msg(playerid, "/táska kivesz [Mit] [Mennyit]");
				if(mennyit < 1) return Msg(playerid, "-.-");
				if(TaskaInfo[taska][tMarihuana] < mennyit) return Msg(playerid, "Nincs benne ennyi marihuana!");
				PlayerInfo[playerid][pMarihuana] += mennyit;
				TaskaInfo[taska][tMarihuana] -= mennyit;
				SendFormatMessage(playerid,COLOR_LIGHTBLUE, "Kivettél %d gramm marihuana-t a táskából!",mennyit);
				Cselekves(playerid, "kivett valamit az aktatáskából",1);
			}
			else if(egyezik(param[2], "pénz") || egyezik(param[2], "penz") || egyezik(param[2], "money"))
			{
				if(params < 3) return Msg(playerid, "/táska kivesz [Mit] [Mennyit]");
				if(mennyit < 1) return Msg(playerid, "-.-");
				if(TaskaInfo[taska][tPenz] < mennyit) return Msg(playerid, "Nincs benne ennyi pénz!");
				TaskaInfo[taska][tPenz] -= mennyit;
				SendFormatMessage(playerid,COLOR_LIGHTBLUE, "Kivettél $%d-t a táskából!",mennyit);
				Cselekves(playerid, "kivett valamit az aktatáskából",1);
				GiveMoney(playerid,mennyit);
				return 1;
			}
			/*else if( egyezik(param[2], "ecstasy") )
			{
				if(params < 3) return Msg(playerid, "/táska kivesz [Mit] [Mennyit]");
				if(mennyit < 1) return Msg(playerid, "-.-");
				if(TaskaInfo[taska][tEki] < mennyit) return Msg(playerid, "Nincs benne ennyi ecstasy!");
				if( (PlayerInfo[playerid][pEki] + mennyit) > 20 ) return Msg(playerid, "Nem fér el ennyi ecstasy nálad!");
				PlayerInfo[playerid][pEki] += mennyit;
				TaskaInfo[taska][tEki] -= mennyit;
				SendFormatMessage(playerid,COLOR_LIGHTBLUE, "Kivettél %d darab ecstasy-t a táskából!",mennyit);
				Cselekves(playerid, "kivett valamit az aktatáskából",1);
			}*/
			else if(egyezik(param[2], "fegyver"))
			{
				//if(GetPlayerWeapon(playerid) == 0) return Msg(playerid, "Nincs nálad fegyver!");
				if(TaskaInfo[taska][tFegyver][0] == 0 || TaskaInfo[taska][tFegyver][1] == 0) return Msg(playerid, "Nincs benne fegyver!");
				GiveWeapon(playerid, TaskaInfo[taska][tFegyver][0], TaskaInfo[taska][tFegyver][1]);
				Fegyvere[playerid] = TaskaInfo[taska][tFegyver][0];
				SetPlayerArmedWeapon(playerid, TaskaInfo[taska][tFegyver][0]);
				TaskaInfo[taska][tFegyver][0] = 0;
				TaskaInfo[taska][tFegyver][1] = 0;
				Cselekves(playerid, "kivett valamit az aktatáskából",1);
				return 1;
			}
		}
		else if(egyezik(param[1], "berak") || egyezik(param[1], "takein"))
		{
			new taska = GetClosestTaska(playerid);
			new Float:tav = GetDistanceToTaska(playerid,taska);
			if(tav > 2.0) return Msg(playerid, "Nincs a közelben táska");
			if(params < 2) return Msg(playerid, "/táska berak [Mit] [Mennyit]");
			new mennyit = strval(param[3]);
			if(egyezik(param[2], "kokain"))
			{
				if(params < 3) return Msg(playerid, "/táska berak [Mit] [Mennyit]");
				if(mennyit < 1) return Msg(playerid, "-.-");
				if(TaskaInfo[taska][tKokain]+mennyit > MAXTASKADROG) return Msg(playerid, "Ennyi nem fér bele");
				if(PlayerInfo[playerid][pKokain] < mennyit) return Msg(playerid, "Nincs nálad ennyi!");
				PlayerInfo[playerid][pKokain] -= mennyit;
				TaskaInfo[taska][tKokain] += mennyit;
				SendFormatMessage(playerid,COLOR_LIGHTBLUE, "Beraktál %d gramm kokaint a táskába!",mennyit);
				Cselekves(playerid, "berakott valamit az aktatáskába",1);
				return 1;
			}
			else if(egyezik(param[2], "c4"))
			{
				if(C4Lerakva[playerid] == 1) return Msg(playerid, "Már raktál le valahova c4et, robbantsd fel elõbb az!");
				if(TaskaInfo[taska][tC4] > 0) return Msg(playerid, "Ebbe a táskába már van C4!");
				if(PlayerInfo[playerid][pC4] < 1) return Msg(playerid, "Nincs nálad C4!");
				PlayerInfo[playerid][pC4] -= 0;
				TaskaInfo[taska][tC4] = 1;
				new Float:x, Float:y, Float:z;
				GetPlayerPos(playerid, x, y, z);
				C4Lerakva[playerid] = 1;
				C4Taska[playerid] = taska;
				SendClientMessage(playerid,COLOR_LIGHTBLUE, "Beraktál egy C4et a táskába! (Felrobbanthatod a /c4 robbantparanccsal)");
				Cselekves(playerid, "berakott valamit az aktatáskába",1);
				return 1;
			}
			else if(egyezik(param[2], "heroin"))
			{
				if(params < 3) return Msg(playerid, "/táska berak [Mit] [Mennyit]");
				if(mennyit < 1) return Msg(playerid, "-.-");
				if(TaskaInfo[taska][tHeroin]+mennyit > MAXTASKADROG) return Msg(playerid, "Ennyi nem fér bele");
				if(PlayerInfo[playerid][pHeroin] < mennyit) return Msg(playerid, "Nincs nálad ennyi!");
				PlayerInfo[playerid][pHeroin] -= mennyit;
				TaskaInfo[taska][tHeroin] += mennyit;
				SendFormatMessage(playerid,COLOR_LIGHTBLUE, "Beraktál %d gramm heroint a táskába!",mennyit);
				Cselekves(playerid, "berakott valamit az aktatáskába",1);
				return 1;
			}
			else if(egyezik(param[2], "marihuana"))
			{
				if(params < 3) return Msg(playerid, "/táska berak [Mit] [Mennyit]");
				if(mennyit < 1) return Msg(playerid, "-.-");
				if(TaskaInfo[taska][tMarihuana]+mennyit > MAXTASKADROG) return Msg(playerid, "Ennyi nem fér bele");
				if(PlayerInfo[playerid][pMarihuana] < mennyit) return Msg(playerid, "Nincs nálad ennyi!");
				PlayerInfo[playerid][pMarihuana] -= mennyit;
				TaskaInfo[taska][tMarihuana] += mennyit;
				SendFormatMessage(playerid,COLOR_LIGHTBLUE, "Beraktál %d gramm marihuana-t a táskába!",mennyit);
				Cselekves(playerid, "berakott valamit az aktatáskába",1);
				return 1;
			}
			else if(egyezik(param[2], "pénz") || egyezik(param[2], "penz") || egyezik(param[2], "money"))
			{
				if(params < 3) return Msg(playerid, "/táska berak [Mit] [Mennyit]");
				if(mennyit < 1) return Msg(playerid, "-.-");
				if(TaskaInfo[taska][tPenz]+mennyit > MAXTASKAPENZ) return Msg(playerid, "Ennyi nem fér bele");
				if(GetMoney(playerid) < mennyit) return Msg(playerid, "Nincs nálad ennyi!");
				GiveMoney(playerid,-mennyit);
				TaskaInfo[taska][tPenz] += mennyit;
				SendFormatMessage(playerid,COLOR_LIGHTBLUE, "Beraktál $%d-t a táskába!",mennyit);
				Cselekves(playerid, "berakott valamit az aktatáskába",1);
				return 1;
			}
			else if(egyezik(param[2], "fegyver"))
			{
			    if(PlayerToPoint(20.0,playerid,293.1098,-26.5718,1001.5156)) return Msg(playerid, "Lõtéren nem!");
				if(GetPlayerWeapon(playerid) == 0) return Msg(playerid, "Nincs nálad fegyver!");
				if(TaskaInfo[taska][tFegyver][0] == 0 || TaskaInfo[taska][tFegyver][1] == 0)
				{
					new FegyverID;
					FegyverID = GetPlayerWeapon(playerid);
					new FegyverTolteny;
					FegyverTolteny = GetPlayerAmmo(playerid);
					
					TaskaInfo[taska][tFegyver][0] = FegyverID;
					TaskaInfo[taska][tFegyver][1] = FegyverTolteny;
					FegyverElvesz(playerid,FegyverID);
					
					Cselekves(playerid, "berakott valamit az aktatáskába",1);
				}
				else
				{
					Msg(playerid, "Már van benne fegyver!");
				}
			}
		}
		return 1;
	}

	if(egyezik(cmd, "/uptime"))
	{
		if(!Admin(playerid, 1)) return HibasParancs(playerid, true);
		PlayerTextFormat(playerid, "A szerver utolsó indítása óta eltelt idõ: %s", FutasIdo());
		Msg(playerid, PlayerText[playerid], COLOR_ADMIN);
		return 1;
	}
		
	if(egyezik(cmd, "/dutyresi"))
	{
	    if(!Admin(playerid, 1)) return HibasParancs(playerid, true);
	    if(params != 1) return Msg(playerid, "/dutyresi [JátékosID/NévRészlet]");
	    new player = ReturnUser(param[1]);
	    if(player != INVALID_PLAYER_ID)
	    {
	        DutyIdo[player] = 0;
	        Msg(player, "Egy admin visszaállította a Duty idõd, most szolgálatba tudsz állni!");
	        Msg(playerid, "Visszállítottad a Duty idejét!");
	        return 1;
	    }
	    else {
	        Msg(playerid, "Nincs ilyen játékos!");
		}
		return 1;
	}
	
	if(egyezik(cmd, "/felcserél") || egyezik(cmd, "/felcserel"))
	{
		if(params != 1) return Msg(playerid, "/felcserél [Ház/Kocsi]");
		if(egyezik(param[1], "Kocsi"))
		{
		    if(PlayerInfo[playerid][pPcarkey] == NINCS && PlayerInfo[playerid][pPcarkey2] == NINCS)
		        return Msg(playerid, "Nincs jármûved!");

			if(PlayerInfo[playerid][pPcarkey] != NINCS && PlayerInfo[playerid][pPcarkey2] == NINCS)
			    return Msg(playerid, "Csak egy jármûved van!");

			new kocsi[2];
			kocsi[0] = PlayerInfo[playerid][pPcarkey];
			kocsi[1] = PlayerInfo[playerid][pPcarkey2];

			PlayerInfo[playerid][pPcarkey] = kocsi[1];
			PlayerInfo[playerid][pPcarkey2] = kocsi[0];
			Msg(playerid, "Jármûvek felcserélve!");
			return 1;
		}
		else if(egyezik(param[1], "ház") || egyezik(param[1], "haz"))
		{
		    if(PlayerInfo[playerid][pPhousekey] == NINCS && PlayerInfo[playerid][pPhousekey2] == NINCS)
		        return Msg(playerid, "Nincs házad!");

			if(PlayerInfo[playerid][pPhousekey] != NINCS && PlayerInfo[playerid][pPhousekey2] == NINCS)
			    return Msg(playerid, "Csak egy házad van!");

			new haz[2];
			haz[0] = PlayerInfo[playerid][pPhousekey];
			haz[1] = PlayerInfo[playerid][pPhousekey2];

			PlayerInfo[playerid][pPhousekey] = haz[1];
			PlayerInfo[playerid][pPhousekey2] = haz[0];
			Msg(playerid, "Házak felcserélve!");
			return 1;
		}
		return 1;
	}	
	if(egyezik(cmd, "/help"))
	{
		#define COLOR_CIM "FFD700"
		#define COLOR_TARTALOM "F8F8FF"		
		new torzs[1024];
		
		strcat(torzs, "{"COLOR_CIM"}Alapvetõ parancsok:{"COLOR_TARTALOM"} | /jelszóváltás | /stats | /anims | /inventory | /admins |\n");
		strcat(torzs, "{"COLOR_CIM"}Jármû parancsok:{"COLOR_TARTALOM"} | /v | /tankol |\n");
		strcat(torzs, "{"COLOR_CIM"}Ház parancsok:{"COLOR_TARTALOM"} | /ajtó | /ds(hout) | /ddo |\n");
		strcat(torzs, "{"COLOR_CIM"}Biznisz parancsok:{"COLOR_TARTALOM"} | /üzletvásárlás | /buy | /ajtó |\n");
		strcat(torzs, "{"COLOR_CIM"}Segítség kérés:{"COLOR_TARTALOM"} | /report | /pm |\n");
		strcat(torzs, "{"COLOR_CIM"}Interakció parancsok:{"COLOR_TARTALOM"} | /me | /do | /megpróbál | /s | /w |\n");
		strcat(torzs, "{"COLOR_CIM"}Pénzügyek:{"COLOR_TARTALOM"} | /pay | /bsz |\n");
		
		strcat(torzs, "\n{"COLOR_CIM"}Munkaparancsok:{"COLOR_TARTALOM"}\n");
		strcat(torzs, "{"COLOR_CIM"}Raktáros munka:{"COLOR_TARTALOM"} | /doboz felvesz |\n");
		strcat(torzs, "{"COLOR_CIM"}Csomagszállító:{"COLOR_TARTALOM"} | /menetlevél | /csomagszállító |\n");
		strcat(torzs, "{"COLOR_CIM"}Pizzafutár:{"COLOR_TARTALOM"} | /étel |\n");
		
		strcat(torzs, "\n{"COLOR_CIM"}Weboldalunk címe:{"COLOR_TARTALOM"} "OFFICIALWEB);
		ShowPlayerDialog(playerid, DIALOG_NINCS, DIALOG_STYLE_MSGBOX, "Segítség", torzs, "Bezárás", "");
		
		#undef COLOR_CIM
		#undef COLOR_TARTALOM
		return 1;
	}
	if(egyezik(cmd, "/pénzváltó") || egyezik(cmd, "/penzvalto"))
	{
		if(params < 2)
		{
			Msg(playerid, "/pénzváltó [Összeg] [Eredeti pénznem]");
			Msg(playerid, "Példa: /pénzváltó 650 Ft vagy /pénzváltó 500 $");
			Msg(playerid, "Ügyelj rá, hogy az összeg és a pénzem között KELL, hogy legyen szóköz! (pl: 500 Ft)");
			return 1;
		}
		
		new szoveg[124];
		new arfolyam = DOLLAR_ARFOLYAM;
		new osszeg = strval(param[1]);
		
		if(osszeg < 1/* || osszeg > MAX_INT_VALUE*/) return Msg(playerid, "Hibás összeg!");
		
		if(egyezik(param[2], "$") || egyezik(param[2], "dollár") || egyezik(param[2], "dollar"))
		{
			new muvelet = osszeg*arfolyam;
			Format(szoveg, "Sikeres átváltás! ($ -> Ft) $%s = %sFt (árfolyam: %d)", PenzTordeles(osszeg), PenzTordeles(muvelet), arfolyam);
		}		
		if(egyezik(param[2], "ft") || egyezik(param[2], "forint"))
		{
			new muvelet = osszeg/arfolyam;
			Format(szoveg, "Sikeres átváltás! (Ft -> $) %sFt = $%s (kerekítve) (árfolyam: %d)", PenzTordeles(osszeg), PenzTordeles(muvelet), arfolyam);
		}	
		Msg(playerid, szoveg);
		return 1;
	}
	
	if(egyezik(cmd, "/biztonságirendszer") || egyezik(cmd, "/biztonsagirendszer") || egyezik(cmd, "/br"))
	{
		if(params < 1) return Msg(playerid, "/biztonságirendszer [Telepít / Aktivál / Deaktivál / Adat / Jelszó]");

		if(egyezik(param[1], "jelszó") || egyezik(param[1], "jelszo"))
		{
			if(params < 2) return Msg(playerid, "/biztonságirendszer Jelszó [kód]");
			new kocsi = GetClosestVehicle(playerid);
			if(GetDistanceToVehicle(playerid, kocsi) > 5.0) return Msg(playerid, "Nincs a közeledben jármû!");
			new vs = IsAVsKocsi(kocsi);
			if(vs == NINCS) return Msg(playerid, "Ez a jármû a módba van beleírva!");
			if(CarInfo[vs][cOwned] != 1) return 1;
			if(CarInfo[vs][cBRendszer] == 0) return Msg(playerid, "Ebben a jármûben nincs telepítve a biztonsági rendszer.");
			if(BRendszerRossz[kocsi] == 1) return Msg(playerid, "Deaktiválni kell a rendszert, hibás jelszó lett megadva.");
			new pw = strval(param[2]);
			if(strlen(param[2]) < 5) return Msg(playerid, "5 karakterbõl áll a kód.");
			if(CarInfo[vs][cBRendszerKod] != pw)
			{
				Msg(playerid, "** Biztonsági Rendszer **");
				Msg(playerid, "- Hiba: A jelszó nem egyezik.");
				Msg(playerid, "- A rendõrség értesítve, GPS koordínáták elküldve.");
			
				BRendszerRossz[kocsi] = 1;
				return 1;
			}
			Msg(playerid, "** Biztonsági Rendszer **");
			Msg(playerid, "- Jelszó elfogadva, a motor indítható.");
			BRendszerAktiv[kocsi] = 1;
		}

		if(egyezik(param[1], "telepít") || egyezik(param[1], "telepit"))
		{
			if(!Admin(playerid, 5555) && !LMT(playerid, LMUNKA_SZERELO)) return Msg(playerid, "Nem vagy szerelõ.");
			if(!Admin(playerid, 5555) && !Muhelyben(playerid)) return Msg(playerid, "Nem vagy szerelõmûhelyben!");
			new kocsi = GetClosestVehicle(playerid);
			if(GetDistanceToVehicle(playerid, kocsi) > 5.0) return Msg(playerid, "Nincs a közeledben jármû!");
			new vs = IsAVsKocsi(kocsi);
			if(vs == NINCS) return Msg(playerid, "Ez a jármû a módba van beleírva!");
			if(CarInfo[vs][cOwned] != 1) return 1;
			if(BRendszer[playerid] > 0) return Msg(playerid, "Már telepíted ...");
			if(params < 2) return Msg(playerid, "/biztonságirendszer Telepít [5 számjegyû kód]");
			if(CarInfo[vs][cBRendszer] == 1) return Msg(playerid, "Ebben a jármûben már telepítve van a biztonsági rendszer.");
			if(strlen(param[2]) != 5) return Msg(playerid, "A kódnak 5 számjegybõl kell állnia.");
			BRendszer[playerid] = 10;
			BRKod[playerid] = strval(param[2]);
			Freeze(playerid);
			Msg(playerid, "** Biztonsági Rendszer Telepítése Folyamatban... **");
			Cselekves(playerid, "telepíti a biztonsági rendszert...");
		}

		if(egyezik(param[1], "aktivál") || egyezik(param[1], "aktival"))
		{
			new kocsi = GetClosestVehicle(playerid);
			if(GetDistanceToVehicle(playerid, kocsi) > 5.0) return Msg(playerid, "Nincs a közeledben jármû!");
			new vs = IsAVsKocsi(kocsi);
			if(vs == NINCS) return Msg(playerid, "Ez a jármû a módba van beleírva!");
			if(CarInfo[vs][cOwned] != 1) return 1;
			if(CarInfo[vs][cBRendszer] == 0) return Msg(playerid, "Ebben a jármûben nincs telepítve a biztonsági rendszer.");
			if(!egyezik(CarInfo[vs][cOwner], PlayerName(playerid, true)) && JarmuKulcs[playerid] != vs && (PlayerInfo[playerid][pLeader] != CarInfo[vs][cFrakcio] && CarInfo[vs][cFrakcio] != 0)) return Msg(playerid, "Ez nem a tied!");
			if(CarInfo[vs][cBRendszerAktiv] == 1) return Msg(playerid, "A rendszer már aktiválva van.");
			if(BRendszer2[playerid] > 0) return Msg(playerid, "Az aktiválás már folyamatban van, várj egy kicsit...");
			Msg(playerid, "** Biztonsági Rendszer Aktiválása Folyamatban... **");
			BRendszer2[playerid] = 5;
			Cselekves(playerid, "aktiválja a biztonsági rendszert...");
		}

		if(egyezik(param[1], "deaktivál") || egyezik(param[1], "deaktival"))
		{
			new kocsi = GetClosestVehicle(playerid);
			if(GetDistanceToVehicle(playerid, kocsi) > 5.0) return Msg(playerid, "Nincs a közeledben jármû!");
			if(!SajatKocsi(playerid, kocsi)) return Msg(playerid, "Másnak a Biztonsági rendszerét akarod deaktiválni?");
			new vs = IsAVsKocsi(kocsi);
			if(vs == NINCS) return Msg(playerid, "Ez a jármû a módba van beleírva!");
			if(CarInfo[vs][cOwned] != 1) return 1;
			if(CarInfo[vs][cBRendszer] == 0) return Msg(playerid, "Ebben a jármûben nincs telepítve a biztonsági rendszer.");
			if(!egyezik(CarInfo[vs][cOwner], PlayerName(playerid, true)) && JarmuKulcs[playerid] != vs && (PlayerInfo[playerid][pLeader] != CarInfo[vs][cFrakcio] && CarInfo[vs][cFrakcio] != 0)) return Msg(playerid, "Ez nem a tied!");
			if(CarInfo[vs][cBRendszerAktiv] == 0) return Msg(playerid, "A rendszer nincs aktiválva.");
			if(BRendszer3[playerid] > 0) return Msg(playerid, "A deaktiválás már folyamatban van, várj egy kicsit...");
			Msg(playerid, "** Biztonsági Rendszer Deaktiválása Folyamatban... **");
			BRendszer3[playerid] = 5;
			Cselekves(playerid, "deaktiválja a biztonsági rendszert...");
			if(BRendszerRossz[kocsi] == 1)
			{
				Format(string, "** Biztonsági Rendszer értesítés: SeeRPG - %d rendszámú jármû tulaja deaktiválta a rendszert.", kocsi);
				SendRadioMessage(LMUNKA_LSPD, COLOR_LIGHTGREEN, string);
				new Float:x, Float:y, Float:z;
				GetVehiclePos(kocsi, x, y, z);
				PlayerForeach(i)
				{
					if(!LMT(i, LMUNKA_LSPD)) continue;
					DisablePlayerCheckpoint(i);
				}
				BRendszerRossz[kocsi] = 0;
			}
		}

		if(egyezik(param[1], "adat"))
		{
			if(!Admin(playerid, 5555) && !LMT(playerid, LMUNKA_SZERELO)) return Msg(playerid, "Nem vagy szerelõ.");
			if(!Admin(playerid, 5555) && !Muhelyben(playerid)) return Msg(playerid, "Nem vagy szerelõmûhelyben!");
			new kocsi = GetClosestVehicle(playerid);
			if(GetDistanceToVehicle(playerid, kocsi) > 5.0) return Msg(playerid, "Nincs a közeledben jármû!");
			new vs = IsAVsKocsi(kocsi);
			if(vs == NINCS) return Msg(playerid, "Ez a jármû a módba van beleírva!");
			if(CarInfo[vs][cOwned] != 1) return 1;
			if(CarInfo[vs][cBRendszer] == 0) return Msg(playerid, "Nincs rendszer telepítve...");
			if(params < 2) return Msg(playerid, "/biztonságirendszer Adat [Ellenõrzés / Vált]");
			if(egyezik(param[2], "ellenõrzés") || egyezik(param[2], "ellenorzes"))
			{
				Msg(playerid, "** Biztonsági Rendszer Adatlekérõ **");
				SendFormatMessage(playerid, COLOR_YELLOW, "- Jármû tulaja: %s", CarInfo[vs][cOwner]);
				SendFormatMessage(playerid, COLOR_YELLOW, "- Jármû rendszáma: SeeRPG - %d", kocsi);
				if(CarInfo[vs][cBRendszerAktiv] == 1) {
					Msg(playerid, "- A rendszer aktív");
				} else {
					Msg(playerid, "- A rendszer kikapcsolva");
				}
				Msg(playerid, "- Biztonsági kód: %d", CarInfo[vs][cBRendszerKod]);
				Cselekves(playerid, "lekérte a biztonsági rendszer adatait...");
			}
			if(egyezik(param[2], "vált") || egyezik(param[2], "valt"))
			{
				if(params < 3) return Msg(playerid, "/biztonságirendszer adat vált [új kód]");
				if(strlen(param[3]) != 5) return Msg(playerid, "A kódnak 5 számjegybõl kell állnia.");
				CarInfo[vs][cBRendszerKod] = strval(param[3]);
				CarUpdate(vs, CAR_BRendszerKod);
				Msg(playerid, "** Biztonsági Rendszer **");
				SendFormatMessage(playerid, COLOR_YELLOW, "- Biztonsági kód szerkesztve: %d", strval(param[3]));
				new tulaj = ReturnUser(CarInfo[vs][cOwner]);
				if(tulaj != INVALID_PLAYER_ID)
				{
					SendFormatMessage(playerid, COLOR_YELLOW, "- Jármû tulaja értesítve (%s)", CarInfo[vs][cOwner]);
					SendClientMessage(tulaj, COLOR_LIGHTRED, "** Biztonsági Rendszer **");
					SendClientMessage(tulaj, COLOR_YELLOW, "- Értesítés: Egy autószerelõ megváltoztatta a kódot.");
				}
			}
		}
		return 1;
	}
	if(egyezik(cmd, "/kerék") || egyezik(cmd, "/kerék"))
	{
	    if(params != 1) return Msg(playerid, "/kerék [Kivesz / Berak / Felrak]");
		if(egyezik(param[1], "Kivesz"))
		{
			new kocsi = GetClosestCar(playerid);
			if(GetDistanceToCar(playerid,kocsi) > 5.0) return Msg(playerid, "Nincs a közelben jármû!");
			if(Bikes(kocsi) || IsAPlane(kocsi) || IsABoat(kocsi)) return Msg(playerid, "Csak személygépjármûveken, és Csomagszallitookon!");
			if(KocsiMogottVan(playerid,kocsi))
			{
				new vs = IsAVsKocsi(kocsi);
				if(vs == NINCS) return Msg(playerid, "Csak V-s jármûveken használható!");
				if(GetJarmu(kocsi, KOCSI_CSOMAGTARTO) != 1) return Msg(playerid, "Nyisd fel a csomagtartót!");
				if(PotKerek[playerid] != 0) return Msg(playerid, "Már van nálad pótkerék!");
				if(CarInfo[vs][cPotKerek] < 1) return Msg(playerid, "A jármûben nincs pótkerék!");
				ApplyAnimation(playerid, "GANGS", "shake_cara",4.0,0,0,0,0,0,0);
				Cselekves(playerid, "kiveszi a pótkereket a csomagtartóból.");
				KezObject_Felrak(playerid,1098, "jobb");
				Msg(playerid, "Kivetted a pótkereket! Menj a kerék mellé, és rakd fel(/kerék felrak)");
				PotKerek[playerid] = 1;
				CarInfo[vs][cPotKerek] --;
				CarUpdate(vs, CAR_PotKerek);
				return 1;
			}
			else
			{
				Msg(playerid, "Nem vagy jármû mögött!");
				return 1;
			}
		}
		else if(egyezik(param[1], "megnéz") || egyezik(param[1], "megnez"))
		{
			new kocsi = GetClosestCar(playerid);
			if(GetDistanceToCar(playerid,kocsi) > 5.0) return Msg(playerid, "Nincs a közelben jármû!");
			if(Bikes(kocsi) || IsAPlane(kocsi) || IsABoat(kocsi)) return Msg(playerid, "Csak személygépjármûveken, és Csomagszallitookon!");
			if(KocsiMogottVan(playerid,kocsi))
			{
				new vs = IsAVsKocsi(kocsi);
				if(vs == NINCS) return Msg(playerid, "Csak V-s jármûveken használható!");
				if(GetJarmu(kocsi, KOCSI_CSOMAGTARTO) != 1) return Msg(playerid, "Nyisd fel a csomagtartót!");
				Cselekves(playerid, "belenéz a csomagtartóba...");
				SendFormatMessage(playerid,COLOR_YELLOW, "A Jármû csomagterében van %d db pótkerék (Max.: %d)",CarInfo[vs][cPotKerek], MAX_POTKEREK);
			}
			else
			{
				Msg(playerid, "Nem vagy jármû mögött!");
				return 1;
			}
		}
		else if(egyezik(param[1], "Berak"))
		{
			new kocsi = GetClosestCar(playerid);
			if(GetDistanceToCar(playerid,kocsi) > 5.0) return Msg(playerid, "Nincs a közelben jármû!");
			if(Bikes(kocsi) || IsAPlane(kocsi) || IsABoat(kocsi)) return Msg(playerid, "Csak személygépjármûveken, és Csomagszallitookon!");
			if(KocsiMogottVan(playerid,kocsi))
			{
				new vs = IsAVsKocsi(kocsi);
				if(vs == NINCS) return Msg(playerid, "Csak V-s jármûveken használható!");
				if(GetJarmu(kocsi, KOCSI_CSOMAGTARTO) != 1) return Msg(playerid, "Nyisd fel a csomagtartót!");
				if(PotKerek[playerid] == 0) return Msg(playerid, "Nem is vettél ki pótkereket!");
				if(CarInfo[vs][cPotKerek]+1 > MAX_POTKEREK) return Msg(playerid, "Több pótkerék nem fér bele!");
				ApplyAnimation(playerid, "GANGS", "shake_cara",4.0,0,0,0,0,0,0);
				Cselekves(playerid, "visszarakja a pótkereket a csomagtartóba.");
				KezObject_Torol(playerid);
				Msg(playerid, "Visszaraktad a Pótkereket!");
				PotKerek[playerid] = 0;
				CarInfo[vs][cPotKerek] ++;
				CarUpdate(vs, CAR_PotKerek);
				return 1;
			}
			else
			{
				Msg(playerid, "Nem vagy jármû mögött!");
				return 1;
			}
		}
		else if(egyezik(param[1], "felrak"))
		{
			if(MunkaFolyamatban[playerid] != 0) return Msg(playerid, "Már szereled baszki -.-'");
			if(IsPlayerInAnyVehicle(playerid)) return Msg(playerid, "Jármûbõl? O_o");
			new kocsi = GetClosestCar(playerid);
			if(GetDistanceToCar(playerid,kocsi) > 5.0) return Msg(playerid, "Nincs a közelben jármû!");
			if(Bikes(kocsi) || IsAPlane(kocsi) || IsABoat(kocsi)) return Msg(playerid, "Csak személygépjármûveken, és Csomagszallitookon!");
			if(PotKerek[playerid] == 0) return Msg(playerid, "Vedd ki a kereket a csomagtartóból!");
			new kerek = GetKerek(playerid,kocsi);
			if(kerek == NINCS) return Msg(playerid, "Nem vagy a keréknél!");
			MunkaFolyamatban[playerid] = 1;
			Format(string, "elkezdi kicserélni a jármû %s kerekét",GetKerekNev(kerek));
			Cselekves(playerid,string);
			KezObject_Torol(playerid);
			MunkaFolyamatban[playerid] = 1;
			SetTimerEx("KerekCsere",20000,0, "ddd",playerid,kocsi,kerek);
			Freeze(playerid,20000);
			ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop",4.0,1,0,0,1,0);
		}
		return 1;
	}
	if(egyezik(cmd, "/kerékbilincs") || egyezik(cmd, "/kerekbilincs"))
	{
		if(!IsRicardo(playerid))
		if(params < 1) return Msg(playerid, "/kerékbilincs [kivesz / felszerel / leszerel]");
		if(egyezik(param[1], "kivesz"))
		{
			if(!IsACop(playerid)) return Msg(playerid, "Nem tartozol egy rendvédelmi szervezethez sem!");
			if(IsACop(playerid) && PlayerInfo[playerid][pRank] < 5) return Msg(playerid, "Minimum 5-ös rang!");
			if(VanKB[playerid] == 1) return Msg(playerid, "Már van nálad kerékbilincs.");
			if(IsPlayerInAnyVehicle(playerid)) return Msg(playerid, "Csomagtartóból vedd ki.");
			new kocsi = GetClosestVehicle(playerid);
			if(GetDistanceToVehicle(playerid, kocsi) > 4.0) return Msg(playerid, "Nincs a közeledben jármû!");
			if(!RendorKocsi(kocsi)) return Msg(playerid, "Csak rendõrségi jármûbõl lehet kivenni!");
			if(GetJarmu(kocsi, KOCSI_CSOMAGTARTO) != 1) return Msg(playerid, "Nyisd fel a csomagtartót!");
			Msg(playerid, "Kerékbilincs kivéve.");
			Cselekves(playerid, "kivett egy kerékbilincset a csomagtartóból.");
			VanKB[playerid] = true;
		}
		if(egyezik(param[1], "felszerel"))
		{
			if(!IsACop(playerid)) return Msg(playerid, "Nem tartozol egy rendvédelmi szervezethez sem!");
			if(IsACop(playerid) && PlayerInfo[playerid][pRank] < 5) return Msg(playerid, "Minimum 5-ös rang!");
			if(VanKB[playerid] == 0) return Msg(playerid, "Nincs nálad kerékbilincs.");
			new kocsi = GetClosestVehicle(playerid);
			if(GetDistanceToVehicle(playerid, kocsi) > 4.0) return Msg(playerid, "Nincs a közeledben jármû!");
			if(KerekBilincs[kocsi] == 1) return Msg(playerid, "Ezen már van kerékbilincs.");
			Freeze(playerid);
			KBWait[playerid] = 20;
			Msg(playerid, "Kerékbilincs felszerelése...");
			Cselekves(playerid, "felszereli a kerékbilincset és megírja a cédulát...");
			ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop",4.0,1,0,0,1,0);
		}
		if(egyezik(param[1], "leszerel"))
		{
			if(!IsACop(playerid)) return Msg(playerid, "Nem tartozol egy rendvédelmi szervezethez sem!");
			if(IsACop(playerid) && PlayerInfo[playerid][pRank] < 5) return Msg(playerid, "Minimum 5-ös rang!");
			new kocsi = GetClosestVehicle(playerid);
			if(GetDistanceToVehicle(playerid, kocsi) > 4.0) return Msg(playerid, "Nincs a közeledben jármû!");
			if(KerekBilincs[kocsi] == 0) return Msg(playerid, "Nincs is rajta kerékbilincs...");
			Freeze(playerid);
			KBWait2[playerid] = 20;
			Msg(playerid, "Kerékbilincs leszerelése...");
			Cselekves(playerid, "leszereli a kerékbilincset...");
			ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop",4.0,1,0,0,1,0);
		}
		return 1;
	}

	if(egyezik(cmd, "/törlés") || egyezik(cmd, "/torles"))
	{
		if(!Admin(playerid, FOADMIN)) return HibasParancs(playerid, true);
		
		if(params < 1) 
		{
			Msg(playerid, "/törlés [Funkció] [ID]", COLOR_ADMIN);
			Msg(playerid, "Funkciók: Ház / Csoport / Kocsi / Játékos / Ajtó / Kapu / ATM / Fülke / Hotel / Pickup", COLOR_ADMIN);
			return 1;
		}
		
		new id = strval(param[2]);
		//if(id == 0 && !IsRicardo(playerid)) return Msg(playerid, "A 0-ás ID-jû dolgokat ne töröld különben bug lesz!", COLOR_ADMIN);
		if(id < 0) return Msg(playerid, "Az ID nem lehet kevesebb mint 0!", COLOR_ADMIN);
		
		if(egyezik(param[1], "ház") || egyezik(param[1], "haz"))
		{
			if(params != 2) return Msg(playerid, "/törlés Ház [ID]", COLOR_ADMIN);
			if(HouseInfo[id][Van] != 1) return Msg(playerid, "Nincs ilyen ház!", COLOR_ADMIN);
			
			#if defined KELLHAZPICKUP
				DestroyDynamicPickup(HazPickup[id]);
				HazPickup[id] = NINCS;
			#endif
			HouseInfo[id][Van] = 0;
			
			format(string, 128, "DELETE FROM %s WHERE ID='%d'", SQL_DB_Hazak, id);
			mysql_query(string);
			
			#if defined KELLBUTORRENDSZER
				format(string, 128, "DELETE FROM %s WHERE Haz='%d'", SQL_DB_Butorok, id);
				mysql_query(string);
			#endif
			
			ABroadCastFormat(COLOR_LIGHTGREEN, 1, "(%s) %s törölt egy házat. Házszám: %d", AdminSzint(playerid), PlayerName(playerid), id);
			HazakSzamaOsszesen --;
		}
		else if(egyezik(param[1], "hotel"))
		{
			if(params != 2) return Msg(playerid, "/törlés Hotel [ID]", COLOR_ADMIN);
			if(HotelInfo[id][Van] != 1) return Msg(playerid, "Nincs ilyen hotelszoba!", COLOR_ADMIN);
			DestroyDynamicPickup(HotelPickup[id]);
			HotelPickup[id] = NINCS;
			HotelInfo[id][Van] = 0;
			format(string, 128, "DELETE FROM %s WHERE ID='%d'", SQL_DB_Hotelek, id);
			mysql_query(string);
			ABroadCastFormat(COLOR_LIGHTGREEN, 1, "(%s) %s törölt egy hotelszobát. Hotelszoba: %d", AdminSzint(playerid), PlayerName(playerid), id);
			HotelekSzamaOsszesen --;
		}
		else if(egyezik(param[1], "csoport"))
		{
			if(params != 2) return Msg(playerid, "/törlés csoport [ID]", COLOR_ADMIN);
			
			format(string, 128, "id='%d'", id);
			if(Mysql_Num("csoportok", string) != 1) return Msg(playerid, "Nincs ilyen csoport!", COLOR_ADMIN);
			
			PlayerForeach(x) 
			{
				if(PlayerInfo[x][pCsoport] == id) 
				{
					PlayerInfo[x][pCsoport] = 0;
				}
			}
			
			format(string, 128, "DELETE FROM csoportok WHERE ID='%d'", id);
			mysql_query(string);
			
			format(string, 128, "UPDATE playerek SET Csoport='0' WHERE Csoport='%d'", id); 
			mysql_query(string);
			
			ABroadCastFormat(COLOR_LIGHTGREEN, 1, "(%s) %s törölt egy csoportot.", AdminSzint(playerid), PlayerName(playerid));
			ABroadCastFormat(COLOR_LIGHTGREEN, 1, "Csoport ID: %d | Csoport név: %s", id, CsoportInfo[id][CsNev]);
		}
		else if(egyezik(param[1], "kapu"))
		{
			if(params != 2) return Msg(playerid, "/törlés Kapu [ID]", COLOR_ADMIN);
			
			if(KapuInfo[id][Van] != 1) return Msg(playerid, "Nincs ilyen kapu!", COLOR_ADMIN);
			DestroyDynamicObject(KapuInfo[id][kObject]);
			KapuInfo[id][kObject] = NINCS;
			KapuInfo[id][Van] = 0;
			format(string, 128, "DELETE FROM %s WHERE ID='%d'", SQL_DB_Kapuk, id);
			mysql_query(string);
			ABroadCastFormat(COLOR_LIGHTGREEN, 1, "(%s) %s törölt egy kaput. ID: %d", AdminSzint(playerid), PlayerName(playerid), id);
		}
		else if(egyezik(param[1], "ajtó") || egyezik(param[1], "ajto"))
		{
			if(params != 2) return Msg(playerid, "/törlés ajtó [Ajtószám]", COLOR_ADMIN);
			new ajtoszama= id;
			
			if(ajtoszama < 0 || ajtoszama >= sizeof(Ajtok)) return Msg(playerid, "Nincs ilyen ajtó!", COLOR_ADMIN);
			if(Ajtok[ajtoszama][Van] != 1) return Msg(playerid, "Nincs ilyen ajtó!", COLOR_ADMIN);
			
			if(Ajtok[ajtoszama][Vedelem] == 1) return Msg(playerid, "Ez az ajtó védve van ezért nem törölheted!", COLOR_ADMIN)
			
			Ajtok[ajtoszama][Van] = 0;
	        strmid(Ajtok[ajtoszama][Csak] , "All", 0, strlen("All"), 20);
			strmid(Ajtok[ajtoszama][Nev] , "Nincs", 0, strlen("Nincs"), 20);
	        Ajtok[ajtoszama][BeX] = 0.000000;
	        Ajtok[ajtoszama][BeY] = 0.000000;
	        Ajtok[ajtoszama][BeZ] = 0.000000;
	        Ajtok[ajtoszama][BeInt] = 0;
	        Ajtok[ajtoszama][BeVW] = 0;
	        Ajtok[ajtoszama][KiX] = 0.000000;
	        Ajtok[ajtoszama][KiY] = 0.000000;
	        Ajtok[ajtoszama][KiZ] = 0.000000;
	        Ajtok[ajtoszama][KiInt] = 0;
	        Ajtok[ajtoszama][KiVW] = 0;
	        Ajtok[ajtoszama][Zarva] = 0;
	        Ajtok[ajtoszama][Vedelem] = 0;
			DestroyDynamicArea(Ajtok[ajtoszama][TeruletBent]);
			DestroyDynamicArea(Ajtok[ajtoszama][TeruletKint]);
			
			#if defined KELLAJTO3D
				DestroyDynamicPickup(Ajtok[ajtoszama][PickupBent]);
				DestroyDynamicPickup(Ajtok[ajtoszama][PickupKint]);
			#endif
			ABroadCastFormat(COLOR_LIGHTGREEN, 1, "(%s) %s törölt egy Ajtót. Ajtó száma: %d", AdminSzint(playerid), PlayerName(playerid), ajtoszama);
		}
		else if(egyezik(param[1], "kocsi"))
		{
			//if(!IsRicardo(playerid)) return Msg(playerid, "Kiszedve bugjavítás miatt!");
		
			if(params != 2) return Msg(playerid, "/törlés Kocsi [ID]", COLOR_ADMIN);
			new kocsi = IsAVsKocsi(id);
			new vs = IsAVsKocsi(id);
			if(vs == NINCS) return Msg(playerid, "Ez a jármû a módba van beleírva!", COLOR_ADMIN);
			DestroyVehicle(CarInfo[vs][cId]);
			CarInfo[vs][Van] = 0;
			format(string, 128, "DELETE FROM kocsik WHERE Id='%d'", kocsi);
			mysql_query(string);
			//UpdatePerSec[uKocsi] = 20;
			ABroadCastFormat(COLOR_LIGHTGREEN, 1, "(%s) %s törölt egy kocsit. Rendszám: %d", AdminSzint(playerid), PlayerName(playerid), id);
		}
		else if(egyezik(param[1], "játékos") || egyezik(param[1], "jatekos"))
		{
			if(!IsRicardo(playerid)) return Msg(playerid, "Meg anyukádat töröld.. :D");
			if(params != 2) return Msg(playerid, "/törlés Játékos [Jatekos_IG_Neve]", COLOR_ADMIN);
			
			if(KarakterTorles(param[2]))
				ABroadCastFormat(COLOR_LIGHTGREEN, 1, "(%s) %s törölt egy játékost! Név: %s", AdminSzint(playerid), PlayerName(playerid), param[2]);
			else
				Msg(playerid, "Valami hiba történt!");
		}
		else if(egyezik(param[1], "hirdetés") || egyezik(param[1], "hirdetes"))
		{
			if(params != 2) return Msg(playerid, "/törlés Hirdetés [Hír ID]", COLOR_ADMIN);
			new hirid = id;
			if(HirInfo[hirid][hirVan] == 0) return Msg(playerid, "Nincs ilyen Hír!");
			HirTorles(hirid);
			ABroadCastFormat(COLOR_LIGHTGREEN, 1, "(%s) %s törölt egy hírt! ID: %d", AdminSzint(playerid), PlayerName(playerid), hirid);
			return 1;
		}
		else if(egyezik(param[1], "kapu"))
		{
			if(params != 2) return Msg(playerid, "/törlés Kapu [ID]", COLOR_ADMIN);
			if(KapuInfo[id][Van] != 1) return Msg(playerid, "Nincs ilyen kapu!", COLOR_ADMIN);
			DestroyDynamicObject(KapuInfo[id][kObject]);
			KapuInfo[id][kObject] = NINCS;
			KapuInfo[id][Van] = 0;
			format(string, 128, "DELETE FROM %s WHERE ID='%d'", SQL_DB_Kapuk, id);
			mysql_query(string);
			ABroadCastFormat(COLOR_LIGHTGREEN, 1, "(%s) %s törölt egy kaput. ID: %d", AdminSzint(playerid), PlayerName(playerid), id);
			return 1;
		}		
		else if(egyezik(param[1], "atm"))
		{
			if(params != 2) return Msg(playerid, "/törlés ATM [ID]", COLOR_ADMIN);
			if(ATM[id][Van] != 1) return Msg(playerid, "Nincs ilyen ATM!", COLOR_ADMIN);
			
			DestroyObject(ATM[id][aObjectID]);
			ATM[id][aObjectID] = NINCS;
			
			DestroyDynamicMapIcon(ATM[id][aMapIcon]);
			ATM[id][aMapIcon] = NINCS;
			ATM[id][Van] = 0;
			
			format(string, 128, "DELETE FROM %s WHERE ID='%d'", SQL_DB_ATM, id);
			mysql_query(string);
			ABroadCastFormat(COLOR_LIGHTGREEN, 1, "(%s) %s törölt egy ATM-et. ID: %d", AdminSzint(playerid), PlayerName(playerid), id);
			return 1;
		}
		else if(egyezik(param[1], "fülke") OR egyezik(param[1], "fulke"))
		{
			if(params != 2)
			{
				Msg(playerid, "/törlés fülke [ID]", COLOR_ADMIN);
			
				Msg(playerid, ValasztoVonal("Legközelebbi fülke"));
				new Float:PPos[3], Float:legkozelebb = 5000.0, Float:tav, ajto;
				GetPlayerPos(playerid, PPos[0], PPos[1], PPos[2]);
				for(new x = 0; x < sizeof(Fulke); x++)
				{
					if(Fulke[x][Van] != 1) continue;
					tav = GetDistance(PPos[0], PPos[1], PPos[2], Fulke[x][fPosX], Fulke[x][fPosY], Fulke[x][fPosZ]);
					if(tav < legkozelebb)
					{
						legkozelebb = tav;
						ajto = x;
					}
				}
				MsgFormat(playerid, "ID: %d", ajto);
				MsgFormat(playerid, "Táv: %f", legkozelebb);			
				return 1;
			}
			
			if(Fulke[id][Van] != 1) return Msg(playerid, "Nincs ilyen fülke!", COLOR_ADMIN);
			
			Fulke3DText(id, false);
			Fulke[id][Van] = 0;
			
			format(string, 128, "DELETE FROM %s WHERE ID='%d'", SQL_DB_Fulke, id);
			mysql_query(string);
			ABroadCastFormat(COLOR_LIGHTGREEN, 1, "(%s) %s törölt egy fülkét. ID: %d", AdminSzint(playerid), PlayerName(playerid), id);
			return 1;
		}
		else if(egyezik(param[1], "pickup"))
		{
			if(params != 2) return Msg(playerid, "/törlés pickup [ID]", COLOR_ADMIN);
			if(Pickup[id][Van] != 1) return Msg(playerid, "Nincs ilyen pickup!", COLOR_ADMIN);
			Pickup[id][Van] = 0;
			
			DestroyDynamicPickup(Pickup[id][iPickupObject]);
			Pickup[id][iPickupObject] = NINCS;
			
			format(string, 128, "DELETE FROM %s WHERE ID='%d'", SQL_DB_Pickup, id);
			mysql_query(string);
			ABroadCastFormat(COLOR_LIGHTGREEN, 1, "(%s) %s törölt egy pickuppot. ID: %d", AdminSzint(playerid), PlayerName(playerid), id);
			return 1;
		}
		return 1;
	}
	
	if(egyezik(cmd, "/noname"))
	{
		if(!IsRicardo(playerid)) return HibasParancs(playerid, true);

		if(NoName[playerid])
		{
			NoName[playerid] = false;
			Msg(playerid, "Névmutatás Bekapcsolva!");

			NevMutatas(playerid, 1);
		}
		else
		{
			NoName[playerid] = true;
			Msg(playerid, "Névmutatás Kikapcsolva!");

			NevMutatas(playerid, 0);
		}

		return 1;
	}

	if(egyezik(cmd, "/felfüggeszt") || egyezik(cmd, "/felfuggeszt"))
	{
		if(!MunkaLeader(playerid, LMUNKA_LSPD) && !MunkaLeader(playerid, LMUNKA_FBI) && !MunkaLeader(playerid, LMUNKA_ALLAM)) return 1;

		if(params < 2) return Msg(playerid, "/felfüggeszt [JátékosID/NévRészlet] [oka]");

		new player = ReturnUser(param[1]);
		if(player == INVALID_PLAYER_ID) return Msg(playerid, "Nincs ilyen játékos");

		strtok(cmdtext, idx);
		new length = strlen(cmdtext);
		while ((idx < length) && (cmdtext[idx] <= ' '))
		{
			idx++;
		}
		new offset = idx;
		new result[128];
		while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
		{
			result[idx - offset] = cmdtext[idx];
			idx++;
		}
		result[idx - offset] = EOS;
		if(!strlen(result)) return Msg(playerid, "/felfüggeszt [JátékosID/NévRészlet] [oka]");

		switch(PlayerInfo[playerid][pMember])
		{
			case LMUNKA_LSPD:
			{
				switch(PlayerInfo[player][pMember])
				{
					case LMUNKA_MENTO, LMUNKA_ALLAM, LMUNKA_RIPORTER, LMUNKA_TAXI, LMUNKA_KATONA, LMUNKA_OKTATO, LMUNKA_NAV:
					{
						SendFormatMessageToAll(COLOR_LIGHTRED, "%s felfüggesztve %s által | Oka: %s", PlayerName(player), PlayerName(playerid), result);
						Msg(playerid, "Sikeres felfüggesztés");

						PlayerInfo[player][pMember] = 0;
						PlayerInfo[player][pLeader] = 0;
					}
					default: Msg(playerid, "Nem lehet felfüggeszteni");
				}
			}
			case LMUNKA_FBI:
			{
				switch(PlayerInfo[player][pMember])
				{
					case LMUNKA_LSPD, LMUNKA_MENTO, LMUNKA_ALLAM, LMUNKA_RIPORTER, LMUNKA_TAXI, LMUNKA_KATONA, LMUNKA_OKTATO, LMUNKA_NAV:
					{
						SendFormatMessageToAll(COLOR_LIGHTRED, "%s felfüggesztve %s által | Oka: %s", PlayerName(player), PlayerName(playerid), result);
						Msg(playerid, "Sikeres felfüggesztés");

						PlayerInfo[player][pMember] = 0;
						PlayerInfo[player][pLeader] = 0;
					}
					default: Msg(playerid, "Nem lehet felfüggeszteni");
				}
			}
			case LMUNKA_ALLAM:
			{
				switch(PlayerInfo[player][pMember])
				{
					case LMUNKA_LSPD, LMUNKA_FBI:
					{
						SendFormatMessageToAll(COLOR_LIGHTRED, "%s felfüggesztve %s által | Oka: %s", PlayerName(player), PlayerName(playerid), result);
						Msg(playerid, "Sikeres felfüggesztés");

						PlayerInfo[player][pMember] = 0;
						PlayerInfo[player][pLeader] = 0;
					}
					default: Msg(playerid, "Nem lehet felfüggeszteni");
				}
			}
		}

		return 1;
	}

	if(egyezik(cmd, "/stick") || egyezik(cmd, "/szögesdrót"))
	{
		if(!IsACop(playerid)) return Msg(playerid, "Nem vagy rendõr!");
		if(params < 1)
			return Msg(playerid, "Használata: /stick [ lerak / felvesz]");

		if(egyezik(param[1], "lerak"))
		{
			if(Utzarak[playerid][uVan])
				return Msg(playerid, "Már raktál le egy útzárat! Elõbb azt vedd fel!");
			if(params < 2)
				return Msg(playerid, "Használata: /stick lerak [ kicsi / nagy ]");

			if(egyezik(param[2], "kicsi"))
			{
				if(FloodCheck(playerid, cmd)) return 1;
				if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
					return Msg(playerid, "Csak gyalog rakhatsz le!");

				Msg(playerid, "Leraksz egy kicsi útzárat...");
				Cselekves(playerid, "lerak egy kicsi útzárat...");

				Freeze(playerid);
				ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop",4.0,1,0,0,1,0);

				SetTimerEx("Utzar", 3000, false, "dd", playerid, UTZAR_KICSI);
			}
			else if(egyezik(param[2], "nagy"))
			{
				if(FloodCheck(playerid, cmd)) return 1;
				if(GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
					return Msg(playerid, "Csak gyalog rakhatsz le!");

				Msg(playerid, "Leraksz egy nagy útzárat...");
				Cselekves(playerid, "lerak egy nagy útzárat...");

				Freeze(playerid);
				ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop",4.0,1,0,0,1,0);

				SetTimerEx("Utzar", 3000, false, "dd", playerid, UTZAR_NAGY);
			}
			else
				Msg(playerid, "Használata: /stick lerak [ kicsi / nagy ]");
		}
		else if(egyezik(param[1], "felvesz"))
		{
			if(!Utzarak[playerid][uVan])
				return Msg(playerid, "Nem raktál le egy útzárat sem! Elõbb azt rakj le!");

			if(!PlayerToPoint(3.0, playerid, Utzarak[playerid][uHely][0], Utzarak[playerid][uHely][1], Utzarak[playerid][uHely][2]) || GetPlayerState(playerid) != PLAYER_STATE_ONFOOT)
				return Msg(playerid, "Nem vagy az útzárad mellett!");

			if(FloodCheck(playerid, cmd)) return 1;

			Freeze(playerid);
			ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop",4.0,1,0,0,1,0);

			SetTimerEx("Utzar", 3000, false, "dd", playerid, UTZAR_TOROL);
			Msg(playerid, "Felveszed az útzárad...");
			Cselekves(playerid, "felveszi az útzárát...");

		}
		else
			Msg(playerid, "Használata: /szögesdrót [ lerak / felvesz]");

		return 1;
	}
	if(egyezik(cmd, "/sziréna") || egyezik(cmd, "/szirena"))
	{
		if(!IsPlayerInAnyVehicle(playerid)) return Msg(playerid, "Nem vagy jármûben!");
		if(!IsACop(playerid) || PlayerInfo[playerid][pRank] < 3) return Msg(playerid, "Csak a rendõrség tagjainak rang 3-tól!");
		//if(!IsACop(playerid) || OnDuty[playerid] < 1) return Msg(playerid, "Nem vagy szolgálatban!");
		//if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return Msg(playerid, "Nem te vagy sofõr!");
		if(IsABicikli(veh) || IsAMotor(veh) || IsAHeli(veh)) return Msg(playerid, "Csak autóra rakhatsz szirénát!");
		
		if(SzirenaObject[veh] == 0)
		{
			new 
				type = strval(param[1]),
				object = 0
			;
			
			if((params < 1) || (1 < type > 3) && !egyezik(param[1], "load"))
			{
				Msg(playerid, "Használat: /sziréna [típus (1-3)] | legutolsó sziréna betöltése '/sziréna load'");
				return 1;
			}
			
			if(IsNumeric(param[1]))
			{
				switch(type)
				{
					case 1: object = 18646;
					case 2: object = 19419;
					case 3: object = 19620;
				}
			}
		
			if(egyezik(param[1], "load"))
			{
				if(SavedSzirenaPos[playerid][0] == 0) return Msg(playerid, "Még nem tettél fel szirénát!");
				SzirenaObject[veh] = CreateObject(GetPVarInt(playerid, "SzirenaObjectID"), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
				AttachObjectToVehicle(SzirenaObject[veh], veh, SavedSzirenaPos[playerid][0], SavedSzirenaPos[playerid][1], SavedSzirenaPos[playerid][2], SavedSzirenaPos[playerid][3], SavedSzirenaPos[playerid][4], SavedSzirenaPos[playerid][5]);
			}
			else
			{
				if(JatekosSebessege(playerid) != 0) return Msg(playerid, "Csak álló helyzetben!");
				
				Freeze(playerid);
				
				new Float:X, Float:Y, Float:Z, Float:A;	
				GetPlayerPos(playerid, X, Y, Z);
				GetPlayerFacingAngle(playerid, A);
				SzirenaObject[veh] = CreateObject(object, X, Y, Z, 0.0, 0.0, A, 0.0);
				
				SetPVarInt(playerid, "KocsiID", veh);
				SetPVarInt(playerid, "SzirenaObjectID", object);
				SetPVarString(playerid, "MelyikObjectetSzerkeszti", "sziréna");
				EditObject(playerid, SzirenaObject[veh]);
			}
			BlinkingLights(veh, true);
		}
		else
		{
			SzirenaTorles(veh);
			Cselekves(playerid, "levette a megkülönböztetõ jelzést a jármûrõl");
		}
		return 1;
	}
	if(egyezik(cmd, "/kocsiba") || egyezik(cmd, "/entercar"))
	{
		if(!Admin(playerid, 3)) return HibasParancs(playerid, true);
		if(params < 3) return Msg(playerid, "Használata: /kocsiba [JátékosID/NévRészlet] [kocsi] [ülõhely 0-3]");

		new player = ReturnUser(param[1]);
		if(player == INVALID_PLAYER_ID) return Msg(playerid, "Nincs ilyen játékos");
		if(IsPlayerNPC(player)) return Msg(playerid, "Hagyd békén az NPC-t!");
		
		new kocsi = strval(param[2]);
		if(!IsVehicleConnected(kocsi)) return Msg(playerid, "Hibás kocsi!");

		new ules = strval(param[3]);
		if(ules < 0 || ules > 3) return Msg(playerid, "Hibás ülés!");

		PutPlayerInVehicle(player, kocsi, ules);
		return 1;
	}
	if(strcmp(cmd, "/saveall", true) == 0)
	{
		if(!IsFejleszto(playerid)) return HibasParancs(playerid, true);
		if(FloodCheck(playerid, cmd)) return 1;
		
		new szoveg[124];
		Format(szoveg, "(%s) %s használta a /saveall parancsot", AdminSzint(playerid), AdminName(playerid));
		ABroadCast(COLOR_PIROS, szoveg, 1);
		
		AdminCMD("Azonnali adatbázis mentés van folyamatban ezért LEHET, HOGY LAGG LESZ!");
		
		Msg(playerid, "MySQL: Adatok mentése folyamatban!", COLOR_ADMIN);
		SaveAccounts();
		OnAjtoUpdate();
		OnIntsUpdate();
		UpdatePerSec[uHaz] = 20;
		UpdatePerSec[uKocsi] = 20;
		UpdatePerSec[uBiz] = 20;
		UpdatePerSec[uRaktar] = 20;
		UpdatePerSec[uButor] = 20;
		UpdatePerSec[uHotel] = 20;
		MySQLUpdater();
		Msg(playerid, "MySQL: Adatok sikeresen mentve!", COLOR_ADMIN);
		return 1;
	}
	if(strcmp(cmd, "/coin", true) == 0 || strcmp(cmd, "/erme", true) == 0 || strcmp(cmd, "/érme", true) == 0)
	{
		new coin = random(2)+1;
		new coinname[20];
		if(coin == 1) { coinname = "fej"; }
		else { coinname = "írás"; }
		format(string, sizeof(string), "* %s feldobott egy érmét, ami %s lett, mikor leérkezett.", PlayerName(playerid),coinname);
		ProxDetector(10.0, playerid, string, COLOR_CHAT1,COLOR_CHAT2,COLOR_CHAT3,COLOR_CHAT4,COLOR_CHAT5);
	}
	if(egyezik(cmd, "/csomagtartó") || egyezik(cmd, "/csomagtarto") || egyezik(cmd, "/cst"))
	{
		veh = GetClosestVehicle(playerid);
		if(GetDistanceToVehicle(playerid, veh) > 5.5 && !PlayerToPoint(10.0,playerid,1659.5399,221.7910,-82.2500)) return Msg(playerid, "A közeledben nincs jármû!");
		if(!KocsiMogottVan(playerid,veh) && !PlayerToPoint(10.0,playerid,1659.5399,221.7910,-82.2500)) return Msg(playerid, "Nem vagy a kocsi hátamögött!");
		if(!VanBenneCsomagtarto(veh) && !PlayerToPoint(10.0,playerid,1659.5399,221.7910,-82.2500)) return Msg(playerid, "A jármûvön nincs csomagtartó!!");
		if(Locked(veh))	return Msg(playerid, "A jármû zárva!");
		if(params < 1) return Msg(playerid, "/csomagtartó [ Enter / Exit / Berak / Kiszed]");
		else if(egyezik(param[1], "kiszed"))
		{
			if(GetPlayerVirtualWorld(playerid) != 0 || GetPlayerInterior(playerid) != 0) return Msg(playerid, "Csak 0ás INT és 0ás VW!");
			
			new kivanbenne = NINCS;
			PlayerForeach(i)
			{
				if(GetPlayerVirtualWorld(i) == veh && PlayerToPoint(10.0,i,1659.5399,221.7910,-82.2500))
				{
					kivanbenne = i;
					break;
				}
			}
			if(kivanbenne == NINCS) return Msg(playerid, "Nincs senki a csomagtartóban!");
			
		    if(GetJarmu(veh, KOCSI_CSOMAGTARTO) == 1)
		    {
				veh = GetPlayerVirtualWorld(kivanbenne);
				new Float:Poz[3];
				GetVehiclePos(veh,Poz[0],Poz[1],Poz[2]);
				GetXYBehindVehicle(veh,Poz[0],Poz[1],4.0);
				SetPlayerPos(kivanbenne,Poz[0],Poz[1],Poz[2]);
				SetPlayerInterior(kivanbenne,0);
				SetPlayerVirtualWorld(kivanbenne,0);
				Cselekves(playerid, "kirángatta a személyt a csomagtartóból",1);
			}
			else
			{
			    Msg(playerid, "A csomagtartó zárva van!");
			}
		}
		else if(egyezik(param[1], "berak"))
		{
			if(params !=  2) return Msg(playerid, "/csomagtartó Berak [JátékosID/NévRészlet]");
			new jatekos = ReturnUser(param[2]);
			if(!Logged(jatekos) || jatekos == INVALID_PLAYER_ID) return Msg(playerid, "Nincs ilyen játékos!");
			
			if(PlayerCuffed[jatekos] != 2 && !Leutve[jatekos])
				return Msg(playerid, "A játékos nincs megbilincselve / leütve");
				
		    if(GetJarmu(veh, KOCSI_CSOMAGTARTO) == 1)
		    {
				Cselekves(playerid, "berakott valakit a csomagtartóba");
				Freeze(jatekos,5000);
				SetPlayerInterior(jatekos,1);
				SetPlayerVirtualWorld(jatekos,veh);
				SetPlayerPos(jatekos,1659.5399,221.7910,-82.2500);
				ApplyAnimation(jatekos, "CRACK", "crckdeth2",4.1,0,1,1,1,0);
			}
			else
			{
			    Msg(playerid, "A csomagtartó zárva van!");
			}
		}
		else if(egyezik(param[1], "enter"))
		{
			Msg(playerid, "Javítás alatt...");
			/*if(GetPlayerVirtualWorld(playerid) != 0 || GetPlayerInterior(playerid) != 0) return Msg(playerid, "Csak 0ás INT és 0ás VW!");
		    if(GetJarmu(veh, KOCSI_CSOMAGTARTO) == 1)
		    {
				Cselekves(playerid, "bemászott a csomagtartóba");
				Freeze(playerid, 5000);
				SetPlayerInterior(playerid,1);
				SetPlayerVirtualWorld(playerid,veh);
				SetPlayerPos(playerid,1659.5399,221.7910,-82.2500);
				ApplyAnimation(playerid, "CRACK", "crckdeth2",4.1,0,1,1,1,0);
			}
			else
			{
			    Msg(playerid, "A csomagtartó zárva van!");
			}*/
		}
		else if(egyezik(param[1], "exit"))
		{
		    if(!PlayerToPoint(10.0,playerid,1659.5399,221.7910,-82.2500)) return Msg(playerid, "Nem vagy csomagtartóban!");
		    veh = GetPlayerVirtualWorld(playerid);
			
		    if(GetJarmu(veh, KOCSI_CSOMAGTARTO) == 1)
		    {
				new Float:Poz[3];
				GetVehiclePos(veh,Poz[0],Poz[1],Poz[2]);
				GetXYBehindVehicle(veh,Poz[0],Poz[1],4.0);
				SetPlayerPos(playerid,Poz[0],Poz[1],Poz[2]);
				Cselekves(playerid, "kimászott a csomagtartóból");
				SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid,0);
			}
			else
			{
			    Msg(playerid, "A csomagtartó zárva van!");
			}
		}
		return 1;
	}
	if(egyezik(cmd, "/beköt") || egyezik(cmd, "/bekot"))
	{
		//if(Szint(playerid) < 5) return Msg(playerid, "5-ös szinttõl!");
		if(params < 2) return Msg(playerid, "/beköt [száj / szem] [JátékosID/NévRészlet]");
		new p = ReturnUser(param[2]);
		if(p == INVALID_PLAYER_ID) return Msg(playerid, "Nincs ilyen játékos");
		if(egyezik(param[1], "száj") || egyezik(param[1], "szaj"))
		{
		    if(!ProxDetectorS(4.0,playerid,p)) return Msg(playerid, "Nincs a közeledben!");
			if(!Leutve[p] && !PlayerTied[p]) return Msg(playerid, "A játékos nincs leütve / megkötözve.");
			if(!SzajBekotve[p])
			{
				Msg(playerid, "Bekötötted a száját.");
				Msg(p, "Bekötötték a szádat, így nem tudsz beszélni.");
				SzajBekotve[p] = 1;
				Cselekves(playerid, "bekötötte a valakinek a száját", 1);
				return 1;
			}
			Msg(playerid, "Levetted a kötést a szájáról.");
			Msg(p, "Levették a kötést a szádról, újra tudsz beszélni.");
			SzajBekotve[p] = 0;
			Cselekves(playerid, "levette valakinek a kötést a szájáról", 1);
			return 1;
		}
		if(egyezik(param[1], "szem"))
		{
		    if(!ProxDetectorS(4.0,playerid,p)) return Msg(playerid, "Nincs a közeledben!");
			if(!Leutve[p] && !PlayerTied[p]) return Msg(playerid, "A játékos nincs leütve / megkötözve.");
			if(!SzemBekotve[p])
			{
				Msg(playerid, "Bekötötted a szemét.");
				Msg(p, "Bekötötték a szemed, így nem látsz semmit.");
				SzemBekotve[p] = 1;
				Feketeseg(p, true,0);
				Cselekves(playerid, "bekötötte a valakinek a szemét", 1);
				return 1;
			}
			Msg(playerid, "Levetted a kötést a szemérõl.");
			Msg(p, "Levették a kötést a szemedrõl, újra látsz.");
			SzemBekotve[p] = 0;
			Feketeseg(p, false,0);
			Cselekves(playerid, "levette valakinek a kötést a szemérõl", 1);
			return 1;
		}
		return 1;
	}

	/*if(egyezik(cmd, "/sebességkorlát") || egyezik(cmd, "/sebessegkorlat") || egyezik(cmd, "/sk"))
	{
		if(params < 1)
			return Msg(playerid, "Használata: /sebességkorlát [40-180 vagy 0]");

		if(IsABicikli(GetPlayerVehicleID(playerid))) return Msg(playerid, "Azt hitted mi?!");

		new seb = strval(param[1]);
		if(seb < 40 && seb != 0 || seb > 180)
			return Msg(playerid, "Használata: /sebességkorlát [40-180 vagy 0]");

		if(seb != 0)
		{
			SebessegKorlat[playerid] = seb-30;
		}
		if(seb == 0)
		{
			SebessegKorlat[playerid] = 0;
		}
		SendFormatMessage(playerid, COLOR_LIGHTRED, "* Sebességkorlát beállítva: %d MPH", seb);
		return 1;
	}*/

	if(egyezik(cmd, "/elvesz"))
	{
        if(Bortonben(playerid)) return Msg(playerid, "Börtönben nem használhatod ezt a parancsot!");
		if(params < 1)
		{
			Msg(playerid, "/elvesz [Mit]");
			Msg(playerid, "Kaja, Kokain, Heroin, Mati, Cigi, Kötszer, Fegyver, Armor, Detonátor, Ruha, Rádió, Telefon");
			//SendClientMessage(playerid,COLOR_GREEN, "Cannabismag, Mákmag, Kokacserjemag");
			return 1;
		}
		new p = GetClosestPlayer(playerid);
		if(Szunet[p]) return Msg(playerid, "Épp ESC-el várj mire visszatér!");
		if(Animban[playerid] != 0) return Msg(playerid, "Animban?");

		if(GetDistanceBetweenPlayers(playerid, p) > 2.0) return Msg(playerid, "Nincs senki a közeledbe.");
		if(p == playerid) return Msg(playerid, "Há micsinálsz hülyevagy?");
		if(!Leutve[p] && !PlayerTied[p] && Animban[p] == 0) return Msg(playerid, "A játékos nincs leütve / megkötözve / animban.");
		
		if(AdminDuty[p]) return SeeRPGKick(playerid, "Adminszolisnak akarod elvenni a cuccait? Gratulálok...", NINCS);

		if(PlayerInfo[playerid][pJailed] == BORTON_ADMIN || PlayerInfo[playerid][pJailed] == BORTON_ADMIN2)
		{
			Cselekves(playerid, "rabolni akart adminjailban, de kapott +15perc idõt :)", 0, true);
			PlayerInfo[playerid][pJailTime] += 900;
			return 1;
		}

		if(FloodCheck(playerid, cmd)) return 1;
		if(egyezik(param[1], "rádió") || egyezik(param[1], "radio"))
		{
			Msg(playerid, "Hamarosan..");
			
			/*if(PlayerInfo[p][pVokitoki] == 0) return Msg(playerid, "Nincs rádiója!");
			if(RadioElveve[p]) return Msg(playerid, "Már elvette valaki a rádióját!");
			
			RadioElveve[p] = true;
			PlayerInfo[p][pVokitoki] = 0;
			
			GetPlayerName(p, sendername, sizeof(sendername));
			
			strmid(ElvettRadio[p][rNev], sendername, 0, strlen(sendername), 25);
			ElvettRadio[p][rFrakcio] = NINCS;
			ElvettRadio[p][rRang] = NINCS;
			
			strmid(ElvettRadio[playerid][rNev], sendername, 0, strlen(sendername), 25);
			ElvettRadio[playerid][rFrakcio] = PlayerInfo[p][pMember];
			ElvettRadio[playerid][rRang] = PlayerInfo[p][pRank];
			
			Cselekves(playerid, "elvette valakitõl a rádióját",1);*/
		} 
		/*if(egyezik(param[1], "ruha"))
		{
		    if(IsAt(playerid,IsAt_Haz) == NINCS) return Msg(playerid, "IRL is az utcán vetkõztetsz le egy embert? Menj inkább egy házba!");
		    new skin = GetPlayerSkin(p);
		    if(skin == 252) return Msg(playerid, "Ígyis alsógatyába van szegény...");
		    SetPlayerSkin(p,252);
		    SetPlayerSkin(playerid,skin);
		    Msg(playerid, "* Elvetted a ruháját. (Visszaöltözni a /visszaöltöz paranccsal tudsz!)");
			SendClientMessage(p, COLOR_LIGHTBLUE, "* Elvették a ruhád.");
		    Cselekves(playerid, "elvette valakinek a ruháit");
		    RuhatElvett[playerid] = 1;
		}*/
		if(egyezik(param[1], "detonátor") || egyezik(param[1], "detonator"))
		{
		    if(C4Lerakva[p] != 0)
			{
			    C4Lerakva[playerid] = C4Lerakva[p];
		 		C4Kocsiban[playerid] = C4Kocsiban[p];
		 		C4Generatoron[playerid] = C4Generatoron[p];
		 		C4X[playerid] = C4X[p];
				C4Y[playerid] = C4Y[p];
				C4Z[playerid] = C4Z[p];
				PlayerInfo[playerid][pC4] = PlayerInfo[p][pC4];
				C4Object[playerid] = C4Object[p];
		 		C4Lerakva[p] = 0;
		 		C4Kocsiban[p] = NINCS;
		 		C4Generatoron[p] = NINCS;
		 		C4X[p] = 0.000000;
				C4Y[p] = 0.000000;
				C4Z[p] = 0.000000;
				PlayerInfo[p][pC4] = 0;
				C4Object[p] = NINCS;

				Cselekves(playerid, "elvette valakitõl a detonátort",1);
			}
			else
			{
			    Msg(playerid, "Nincs nála Detonátor!");
			}
		}
		if(egyezik(param[1], "fegyver") || egyezik(param[1], "weapon"))
		{
			if(!IsRicardo(playerid)) return Msg(playerid, "Bugoltatás miatt kiszedve. Ügyesek vagytok (y)");
		    if(ElveszIdo[playerid] > 0)
			{
				SendFormatMessage(playerid,COLOR_LIGHTRED, "Várj még kb %d percet",ElveszIdo[playerid]/60);
				return 1;
			}
			if(params < 2) return Msg(playerid, "/elvesz fegyver [mit]");
			
			new slot, id, fegyo, ammo;
			id = GetGunID(param[2]);
			if(id == 0)
				return Msg(playerid, "Nincs ilyen fegyver");
				
			slot = GetGunSlot(id);
			GetPlayerWeaponData(p, slot, fegyo, ammo);

			if(fegyo != id || ammo == 0) return Msg(playerid, "Nincs ilyen fegyvere!");
				
            SendClientMessage(p, COLOR_LIGHTBLUE, "* Elvettek tõled egy fegyvert!");
			Cselekves(playerid, "elvett valakitõl egy fegyvert!");
			GiveWeapon(playerid,fegyo,ammo);
			FegyverElvesz(p,fegyo);
			ElveszIdo[playerid] = ELVESZLIMIT*60;
		}
		if(egyezik(param[1], "pénz") || egyezik(param[1], "penz"))
		{
			new penz = GetMoney(p);
			if(penz < 1) return Msg(playerid, "A játékosnál nincs pénz.");
			GiveMoney(playerid,penz);
			GiveMoney(p,-penz);
			SendFormatMessage(playerid, COLOR_LIGHTBLUE, "* Elvettél $%d-t tõle", penz);
			SendFormatMessage(p, COLOR_LIGHTBLUE, "* Elvettek tõled $%d-t", penz);
			Cselekves(playerid, "elvette valakinek a pénzzét");
		}
		if(egyezik(param[1], "material") || egyezik(param[1], "mati"))
		{
			new pmats = PlayerInfo[p][pMats];
			new mats = PlayerInfo[playerid][pMats];
			if(pmats < 1) return Msg(playerid, "A játékosnál nincs material.");
			if(mats >= MAXMATI) return Msg(playerid, "Nem lehet nálad több material.");
			PlayerInfo[playerid][pMats] += pmats;
			PlayerInfo[p][pMats] -= pmats;
			SendFormatMessage(playerid, COLOR_LIGHTBLUE, "* Elvettél %ddb materialt tõle", pmats);
			SendFormatMessage(p, COLOR_LIGHTBLUE, "* Elvettek tõled %ddb materialt.", pmats);
			Cselekves(playerid, "elvette valakinek a materialjait");
		}
		if(egyezik(param[1], "kokain"))
		{
			new felesleg, volt;
			if(PlayerInfo[p][pKokain] < 1)
				return Msg(playerid, "A játékosnál nincs kokain.");

			volt = PlayerInfo[p][pKokain];
			PlayerInfo[playerid][pKokain] += PlayerInfo[p][pKokain];
			PlayerInfo[p][pKokain] = 0;

			if(PlayerInfo[playerid][pKokain] > MAXKOKAIN)
			{
				felesleg = PlayerInfo[playerid][pKokain] - MAXKOKAIN;
				PlayerInfo[playerid][pKokain] = MAXKOKAIN;
			}

			if(felesleg == 0)
			{
				SendFormatMessage(playerid, COLOR_LIGHTBLUE, "* Elvettél %dg kokaint tõle", volt);
				SendFormatMessage(p, COLOR_LIGHTBLUE, "* Elvettek tõled %dg kokaint.", volt);
			}
			else
			{
				SendFormatMessage(playerid, COLOR_LIGHTBLUE, "* Elvettél %dg kokaint tõle, de mivel csak %d lehet nálad ezért itthagysz %d grammot.", volt, MAXKOKAIN, felesleg);
				SendFormatMessage(p, COLOR_LIGHTBLUE, "* Elvettek tõled %dg kokaint.", volt);
			}
			Cselekves(playerid, "elvette valakinek a kokainjait");
		}
		if(egyezik(param[1], "heroin"))
		{
			new felesleg, volt;
			if(PlayerInfo[p][pHeroin] < 1)
				return Msg(playerid, "A játékosnál nincs heroin.");

			volt = PlayerInfo[p][pHeroin];
			PlayerInfo[playerid][pHeroin] += PlayerInfo[p][pHeroin];
			PlayerInfo[p][pHeroin] = 0;

			if(PlayerInfo[playerid][pHeroin] > MAXHEROIN)
			{
				felesleg = PlayerInfo[playerid][pHeroin] - MAXHEROIN;
				PlayerInfo[playerid][pHeroin] = MAXHEROIN;
			}

			if(felesleg == 0)
			{
				SendFormatMessage(playerid, COLOR_LIGHTBLUE, "* Elvettél %dg heroint tõle", volt);
				SendFormatMessage(p, COLOR_LIGHTBLUE, "* Elvettek tõled %dg heroint.", volt);
			}
			else
			{
				SendFormatMessage(playerid, COLOR_LIGHTBLUE, "* Elvettél %dg heroint tõle, de mivel csak %d lehet nálad ezért itthagysz %d grammot.", volt, MAXHEROIN, felesleg);
				SendFormatMessage(p, COLOR_LIGHTBLUE, "* Elvettek tõled %dg heroint.", volt);
			}
			Cselekves(playerid, "elvette valakinek a heroinjait");
		}
		if(egyezik(param[1], "marihuana"))
		{
			new felesleg, volt;
			if(PlayerInfo[p][pMarihuana] < 1)
				return Msg(playerid, "A játékosnál nincs marihuána.");

			volt = PlayerInfo[p][pMarihuana];
			PlayerInfo[playerid][pMarihuana] += PlayerInfo[p][pMarihuana];
			PlayerInfo[p][pMarihuana] = 0;

			if(PlayerInfo[playerid][pMarihuana] > MAXHEROIN)
			{
				felesleg = PlayerInfo[playerid][pMarihuana] - MAXMARIHUANA;
				PlayerInfo[playerid][pMarihuana] = MAXMARIHUANA;
			}

			if(felesleg == 0)
			{
				SendFormatMessage(playerid, COLOR_LIGHTBLUE, "* Elvettél %dg maruhiánát tõle", volt);
				SendFormatMessage(p, COLOR_LIGHTBLUE, "* Elvettek tõled %dg maruhiánát.", volt);
			}
			else
			{
				SendFormatMessage(playerid, COLOR_LIGHTBLUE, "* Elvettél %dg maruhiánát tõle, de mivel csak %d lehet nálad ezért itthagysz %d grammot.", volt, MAXMARIHUANA, felesleg);
				SendFormatMessage(p, COLOR_LIGHTBLUE, "* Elvettek tõled %dg maruhiánát.", volt);
			}
			Cselekves(playerid, "elvette valakinek a maruhiánáját");
		}
		
		if(egyezik(param[1], "cigi"))
		{
			new pcigi = PlayerInfo[p][pCigi];
			if(PlayerInfo[p][pCigi] < 1) return Msg(playerid, "A játékosnál nincs cigi.");
			PlayerInfo[playerid][pCigi] += pcigi;
			PlayerInfo[p][pCigi] -= pcigi;
			SendFormatMessage(playerid, COLOR_LIGHTBLUE, "* Elvettél %ddb cigit tõle", pcigi);
			SendFormatMessage(p, COLOR_LIGHTBLUE, "* Elvettek tõled %ddb cigit.", pcigi);
			Cselekves(playerid, "elvette valakinek a cigieit");
		}
		if(egyezik(param[1], "armor"))
		{
			new Float:armor;
			new Float:armor2;
			GetPlayerArmour(playerid, armor);
			GetPlayerArmour(p, armor2);
			if(armor != 0) return Msg(playerid, "Van mellényed!");
			if(armor2 == 0) return Msg(playerid, "Nincs mellénye!");
			SetPlayerArmour(playerid, armor2);
			SetPlayerArmour(p, 0);
			SendClientMessage(playerid, COLOR_LIGHTBLUE, "Elvetted az armorát");
		    SendClientMessage(p, COLOR_LIGHTBLUE, "Elvették az armorod");
			Cselekves(playerid, "elvette valakinek az armorját");
		}
		if(egyezik(param[1], "kötszer") || egyezik(param[1], "kotszer"))
		{
			new felesleg, volt;
			if(PlayerInfo[p][pKotszer] < 1)
				return Msg(playerid, "A játékosnál nincs kötszer.");

			volt = PlayerInfo[p][pKotszer];
			PlayerInfo[playerid][pKotszer] += PlayerInfo[p][pKotszer];
			PlayerInfo[p][pKotszer] = 0;

			if(PlayerInfo[playerid][pKotszer] > MAXKOTSZER)
			{
				felesleg = PlayerInfo[playerid][pKotszer] - MAXKOTSZER;
				PlayerInfo[playerid][pKotszer] = MAXKOTSZER;
			}

			if(felesleg == 0)
			{
				SendFormatMessage(playerid, COLOR_LIGHTBLUE, "* Elvettél %ddb kötszert tõle", volt);
				SendFormatMessage(p, COLOR_LIGHTBLUE, "* Elvettek tõled %ddb kötszert.", volt);
			}
			else
			{
				SendFormatMessage(playerid, COLOR_LIGHTBLUE, "* Elvettél %ddb kötszert tõle, de mivel csak %d lehet nálad ezért itthagysz %d darabot.", volt, MAXKOTSZER, felesleg);
				SendFormatMessage(p, COLOR_LIGHTBLUE, "* Elvettek tõled %ddb kötszert.", volt);
			}
			Cselekves(playerid, "elvette valakinek a kötszereit");
		}
		return 1;
	}
	if(egyezik(cmd, "/kulcs"))
	{
		if(params < 1) return Msg(playerid, "/kulcs [jármû]");
		new p;
		//new haz;
		new jarmu;
		
		if(egyezik(param[1], "jármû") || egyezik(param[1], "jarmu"))
		{
			if(PlayerInfo[playerid][pPcarkey] == NINCS && PlayerInfo[playerid][pPcarkey2] == NINCS) return Msg(playerid, "Nincs jármûved.");
			if(PlayerInfo[playerid][pPcarkey] != NINCS && PlayerInfo[playerid][pPcarkey2] != NINCS)
			{
				if(params < 3) return Msg(playerid, "/kulcs jármû [1/2] [JátékosID/NévRészlet]");
				new melyik = strval(param[2]);
				p = ReturnUser(param[3]);
				if(p == INVALID_PLAYER_ID) return Msg(playerid, "Nincs ilyen játékos.");
				if(melyik == 1)
					jarmu = PlayerInfo[playerid][pPcarkey];
				if(melyik == 2)
					jarmu = PlayerInfo[playerid][pPcarkey2];

				if(GetDistanceBetweenPlayers(playerid, p) > 2) return Msg(playerid, "Nincs a közeledben a játékos.");
				JarmuKulcs[p] = jarmu;
			}
			else
			{
				if(params < 2) return Msg(playerid, "/kulcs jármû [JátékosID/NévRészlet]");
				p = ReturnUser(param[2]);
				if(p == -1) return Msg(playerid, "Nincs ilyen játékos.");
				if(GetDistanceBetweenPlayers(playerid, p) > 2) return Msg(playerid, "Nincs a közeledben a játékos.");
				jarmu = PlayerInfo[playerid][pPcarkey];
				JarmuKulcs[p] = jarmu;
			}
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Átadtad a jármûved kulcsait neki: %s", PlayerName(p));
			SendFormatMessage(p, COLOR_LIGHTGREEN, "* %s oda adta a jármûve kulcsait.", PlayerName(playerid));
			Cselekves(playerid, "átad egy kulcsot valakinek...");
		}
	}
	if(egyezik(cmd, "/trafipax") || egyezik(cmd, "/trafi"))
	{
		if(!IsACop(playerid)) return Msg(playerid, "Csak Rendõr trafipaxozhat.");
		if(!OnDuty[playerid]) return Msg(playerid, "Ahoz, hogy trafipaxozhass, szolgálatban kell lenned!");
		if(PlayerInfo[playerid][pRank] < 1) return Msg(playerid, "Csak 1, vagy nagyobb rangú Rendõr trafipaxozhat!");
		if(LMT(playerid, LMUNKA_SWAT) && PlayerInfo[playerid][pRank] < 6) return Msg(playerid, "Katonaságon minimum 6. Rang szükséges a trafipaxozáshoz!");
		if(!TrafiPax[playerid][tAktiv])
		{
			if(params < 2) return Msg(playerid, "Használata: /trafipax [Bûntetés] [Maximum sebesség]");
			new buntetes = strval(param[1]), sebesseg = strval(param[2]), nemlathato;
			if(params > 2 && IsNumeric(param[3]))
				nemlathato = strval(param[3]);
			else
				nemlathato = 0;
			if(nemlathato == 1 && PlayerInfo[playerid][pRank] < 6) return Msg(playerid, "Csak 6-os Rangtól rakhatsz le láthatatlan trafipaxot!");
			
			if(buntetes < 20 || buntetes > 1000) return Msg(playerid, "Minimum összeg: $20, maximum: $1000");
			if(sebesseg < 30 || sebesseg > 130) return Msg(playerid, "Minimum megadható korlát: 30MPH, maximum: 130MPH");
			if(!IsPlayerInAnyVehicle(playerid))
			{
				Cselekves(playerid, "lerakott egy Trafipaxot.");
				TrafiPax[playerid][tAktiv] = true;
				TrafiPax[playerid][tSebesseg] = sebesseg;
				TrafiPax[playerid][tBuntetes] = buntetes;
				
				new Float:x, Float:y, Float:z;
				GetPlayerPos(playerid, x, y, z);
				
				TrafiPax[playerid][tPosX] = x;
				TrafiPax[playerid][tPosY] = y;
				TrafiPax[playerid][tPosZ] = z;
				
				new szoveg[64]; format(szoveg, 64, "TRAFIPAX!\nSebességkorlát: %dMPH\nBüntetés: $%d", sebesseg, buntetes);
				if(nemlathato == 0) TrafiPax[playerid][t3D] = CreateDynamic3DTextLabel(szoveg, COLOR_YELLOW, 0.0, 0.0, 0.7, 40.0, playerid);
				else TrafiPax[playerid][t3D] = CreateDynamic3DTextLabel(szoveg, COLOR_YELLOW, 0.0, 0.0, 0.7, 3.0, playerid);
				//Attach3DTextLabelToPlayer(TrafiPax[playerid][t3D], playerid, 0.0, 0.0, 0.7);
			}
			else
			{
				Cselekves(playerid, "elõvette a Trafipaxot.");
				TrafiPax[playerid][tAktiv] = true;
				TrafiPax[playerid][tSebesseg] = sebesseg;
				TrafiPax[playerid][tBuntetes] = buntetes;
				
				new Float:x, Float:y, Float:z, car = GetPlayerVehicleID(playerid);
				GetVehiclePos(car, x, y, z);
				
				TrafiPax[playerid][tPosX] = x;
				TrafiPax[playerid][tPosY] = y;
				TrafiPax[playerid][tPosZ] = z;

				new szoveg[64]; format(szoveg, 64, "TRAFIPAX\nSebességkorlát: %dMPH\nBüntetés: $%d", sebesseg, buntetes);
				if(nemlathato == 0) TrafiPax[playerid][t3D] = CreateDynamic3DTextLabel(szoveg, COLOR_YELLOW, 0.0, 0.0, 2.0, 40.0, INVALID_PLAYER_ID, car);
				else TrafiPax[playerid][t3D] = CreateDynamic3DTextLabel(szoveg, COLOR_YELLOW, 0.0, 0.0, 2.0, 3.0, INVALID_PLAYER_ID, car);
				//Attach3DTextLabelToVehicle(TrafiPax[playerid][t3D], car, 0.0, 0.0, 2.0);
			}
		}
		else
		{
			Cselekves(playerid, "elrakta a trafipaxot");
			TrafiPax[playerid][tAktiv] = false;
			DestroyDynamic3DTextLabel(TrafiPax[playerid][t3D]);
		}
		return 1;
	}
	
	if(egyezik(cmd, "/vhspawn"))
	{
		if(!Admin(playerid, 1) && !IsAS(playerid)) return HibasParancs(playerid, true);
		if(params < 1) return Msg(playerid, "Használata: /vhspawn [JátékosID/NévRészlet]", COLOR_ADMIN);
		new player = ReturnUser(param[1]);
		if(player == INVALID_PLAYER_ID) return Msg(playerid, "Nincs ilyen játékos!", COLOR_ADMIN);
		if(IsPlayerNPC(player)) return Msg(playerid, "Hagyd békén az NPC-t!", COLOR_ADMIN);
		if(PlayerInfo[player][pTutorial] == 0) return Msg(playerid, "A játékos számára még nem engedélyezett a játék!");
		if(RicardoVedelem(playerid, player)) return 1;		
		if(PlayerInfo[player][pJailed] > 0) return Msg(playerid, "A játékos AdminJailben/Börtönben van!", COLOR_ADMIN);
		if(MedicTime[player] > 0) return Msg(playerid, "A játékos kórházban van!", COLOR_ADMIN);
		
		ABroadCastFormat(COLOR_LIGHTRED, 1, "(%s) %s elteleportálta %s-t a városházához ", AdminSzint(playerid), PlayerName(playerid), PlayerName(player));
		ResetVW(player);
		SetPlayerPos(player, 1478.9479, -1741.8082, 13.5469);
		//SetHealth(player, MAXHP);
		//SetPlayerArmour(player, 0);
		HalalAnimPlay(player, false);
		DeleteAllPlayerAttachObject(playerid);
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
		ClearAnimations(player);
		//ResetWeapon(player);
		UnFreeze(player);
		return 1;
	}
	
	if(egyezik(cmd, "/shotgun"))
	{
		if(FloodCheck(playerid, cmd)) return 1;
		if(!IsACop(playerid)) return Msg(playerid, "Nem vagy rendõr!");
		if(!OnDuty[playerid]) return Msg(playerid, "Nem vagy szolgálatban!");
		
		new kocsi = GetClosestVehicle(playerid);
		if(GetDistanceToVehicle(playerid, kocsi) > 5.0) return Msg(playerid, "Nincs jármû a közeledben!");
		if(!RendorKocsi(kocsi)) return Msg(playerid, "Csak rendõrségi jármûbõl lehet kivenni!");
		
		new 
			FegyverID = 25,
			Loszer = 50,
			GetFegyverID,
			GetLoszer,
			CselekvesString[128]
		;
		
		GetPlayerWeaponData(playerid, 3, GetFegyverID, GetLoszer);
		
		if(GetFegyverID == FegyverID)
		{
			FegyverElvesz(playerid, FegyverID);
			Format(CselekvesString, "{%s}* %s visszarakta a szolgálati jármûbe a Remington 750-est.", COLOR_CSELEKVES, PlayerName(playerid));
		}
		else
		{
			GiveWeapon(playerid, FegyverID, Loszer);
			Format(CselekvesString, "{%s}* %s kivette a szolgálati jármûbõl a Remington 750-est.", COLOR_CSELEKVES, PlayerName(playerid));
		}
		ProxDetector(B_Cselekves, playerid, CselekvesString, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
		return 1;
	}
	
	if(egyezik(cmd, "/send"))
	{
		if(!IsRicardo(playerid)) return HibasParancs(playerid, true);
		if(FloodCheck(playerid, cmd)) return 1;
		
		if(params < 2) return Msg(playerid, "Használata: /send [RCON / SQL] [Paraméterek]");
		
		new result[256];
		if(egyezik(param[1], "rcon"))
		{
			strtok(cmdtext, idx);
			new length = strlen(cmdtext);
			while ((idx < length) && (cmdtext[idx] <= ' '))
			{
				idx++;
			}
			new offset = idx;
			while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
			{
				result[idx - offset] = cmdtext[idx];
				idx++;
			}
			result[idx - offset] = EOS;
			
			PlayerTextFormat(playerid, "RCON parancs lefuttatva: '%s'", result);
			Msg(playerid, PlayerText[playerid], COLOR_ADMIN);
			SendRconCommand(result);
		}
		/*else if(egyezik(param[1], "sql") || egyezik(param[1], "mysql"))
		{
			strtok(cmdtext, idx);
			new length = strlen(cmdtext);
			while ((idx < length) && (cmdtext[idx] <= ' '))
			{
				idx++;
			}
			new offset = idx;
			while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
			{
				result[idx - offset] = cmdtext[idx];
				idx++;
			}
			result[idx - offset] = EOS;
			
			ABroadCastFormat(COLOR_LIGHTRED, 5, "(%s) %s lefuttatta a következõ MySQL parancsot: %s", AdminSzint(playerid), PlayerName(playerid), result);
			//SendFormatMessage(playerid, COLOR_LIGHTRED, "Parancs futtatva: %s", result);
			mysql_query(result);
		}*/
		return 1;
	}
	
	if(strcmp(cmd, "/pm", true) == 0)
	{
		if(PlayerInfo[playerid][pMuted] == 1) return Msg(playerid, "Le vagy némítva ezért nem reportolhatsz!");
	    if(IsValidPlayerID(playerid))
		if(FloodCheck(playerid,cmd)) return 1;
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp)) return Msg(playerid,"/pm [JátékosID/NévRészlet] [Üzenet]");

		giveplayerid = ReturnUser(tmp);
		if(IsValidPlayerID(giveplayerid))
		{
			if(giveplayerid != INVALID_PLAYER_ID)
			{
				if(IsPlayerNPC(giveplayerid)) return Msg(playerid, "NPC-nek nem küldhetsz PM-et!");
				if(giveplayerid == playerid) return Msg(playerid, "Saját magadnak nem küldhetsz PM-et!");
				
				/*if(IsAdminSzolis(giveplayerid, NINCS))
				{
					PlayerText[playerid] = "Nyomd meg a 'TAB' gombot majd keress egy szolgálatban lévõ Admint! \
					\nHa ez megvan akkor kattints 2x a nevére az egér bal gombjával! \
					\n\
					\nHa nincs szolgálatban admin használd a /report parancsot! \n";
					ShowPlayerDialog(playerid, DIALOG_NINCS, DIALOG_STYLE_MSGBOX, "Adminnak privát üzenet", PlayerText[playerid], "Bezár", "");
					return 1;
				}*/

				new length = strlen(cmdtext);
				while ((idx < length) && (cmdtext[idx] <= ' '))
				{
					idx++;
				}
				new offset = idx;
				new result[128];
				while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
				{
					result[idx - offset] = cmdtext[idx];
					idx++;
				}
				result[idx - offset] = EOS;
				if(!strlen(result)) return Msg(playerid, "/pm [JátékosID/NévRészlet] [Üzenet]");
				
				if(HidePM[giveplayerid] == 1)
				{
					MsgFormat(playerid, "%s-nak/nek tiltva vannak a PM fogadások!", PlayerName(giveplayerid));
					return 1;
				}
				
				Format(string, "{ECCD2D}(( PM tõle [%d]%s: %s ))", playerid, PlayerName(playerid), (result));				
				SCM(giveplayerid, COLOR_WHITE, string);
				Format(string, "{EEE854}(( PM küldés neki [%d]%s: %s ))", giveplayerid,  PlayerName(giveplayerid), (result));
				SCM(playerid, COLOR_WHITE, string);
				return 1;
			}
		}
		else
		{
			format(string, sizeof(string), "Nem aktív játékos.");
			SendClientMessage(playerid, COLOR_GRAD1, string);
		}
		return 1;
	}
	
	if(egyezik(cmd, "/report"))
	{
		if(PlayerInfo[playerid][pMuted] == 1) return Msg(playerid, "Le vagy némítva ezért nem reportolhatsz!");
		new length = strlen(cmdtext);
		while ((idx < length) && (cmdtext[idx] <= ' '))
		{
			idx++;
		}
		new offset = idx;
		new result[120];
		while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
		{
			result[idx - offset] = cmdtext[idx];
			idx++;
		}

		result[idx - offset] = EOS;
		
		if(!strlen(result))
		{
			Msg(playerid, "/report [üzenet]");
			Msg(playerid, "Fontos, hogy csak a lényeget írd le! Nem baj ha nem köszönsz!");
			return 1;
		}
		
		if(ReportElkuldve[playerid]) return Msg(playerid, "Te már küldtél egy jelentést, várd meg míg válaszolnak!");
		
		if(SzovegEllenorzes(playerid, result, "/jelentés")) return 1;
		
		PlayerForeach(x)
		{
			if(Admin(x, 1) || IsAS(x))
			{
				if(gReport[x] == 0)
				{
					SendFormatMessage(x, COLOR_YELLOW, "[%d]%s panasza: %s", playerid, PlayerName(playerid), result);	
					//SendFormatMessage(x, COLOR_YELLOW, "Válaszoláshoz /vá %d [válasz] | Ha zavarnak a reportok /togreport!", playerid);
				}
			}
		}
		
		Msg(playerid, "Az üzeneted kézbesítve lett az összes Adminisztrátornak!");
		MsgFormat(playerid, "Üzeneted: %s", result);
		ReportElkuldve[playerid] = true;
		return 1;
	}

	if(egyezik(cmd, "/maxhp"))
	{
		if(!IsRicardo(playerid)) return HibasParancs(playerid, true);
		if(params < 1) 
			SendFormatMessage(playerid,COLOR_YELLOW, "MAXHP értéke: %3.f", MAXHP);
		else
			MAXHP = floatstr(param[1]);
		return 1;
	}
	
	if(egyezik(cmd, "/hifi"))
	{
		if(PlayerInfo[playerid][pJailed] > 0) return Msg(playerid, "Börtönben/AdminJail-ben nem...");
		if(MedicTime[playerid] > 0) return Msg(playerid, "Kórházban nem...");
		
		new opciok[128] = "Letesz\nFelvesz\nZene lejátszás rádióból\nZene lejátszás URL-bõl\nKikapcsol";
		
		ShowPlayerDialog(playerid, DIALOG_HIFIPANEL, DIALOG_STYLE_LIST, "HiFi kezelõ panel", opciok, "Megnyit", "Bezár");
		return 1;
	}
	
	if(egyezik(cmd, "/debug"))
	{
		if(!IsFejleszto(playerid) && !IsTulaj(playerid)) return HibasParancs(playerid, true);
		if(params < 1)
		{
			Msg(playerid, "/debug [funkció] [paraméter]");
			Msg(playerid, "Funkciók: Sql / Prod / Objektmaterial / Objektmodel / Objectselect / Objekt / Bankrob / Usercp / Kocsikerek / Terulettulaj");
			Msg(playerid, "Funkciók: Alkatresz / Szovetse / Surfing / Padatok / Tuz / Padatok / Zangl / Time / Ccc / Minimumfuzihoz / Saveaccounts");
			Msg(playerid, "Funkciók: Gettime / Numplayers / Aszoli3d / Csoportok / exportnpc / Hifi / Fizu");
			return 1;
		}
		if(egyezik(param[1], "fizu"))
		{
			FizuNullazas();
			Msg(playerid, "FizuNullazas(); - lefutott!")
		}
		if(egyezik(param[1], "aszoli3d"))
		{
			PlayerForeach(x)
			{
				AdminSzoli3DChecker(x);
			}
			Msg(playerid, "AdminSzoli3DChecker(x); - lefutott!")
		}
		else if(egyezik(param[1], "hifi"))
		{
			for(new i = 1; i < MAXHIFI; i++)
			{
				if(HifiInfo[i][hVan] != 0)
				{
					HifiInfo[i][hVan] = 0;
					HifiInfo[i][hX] = 0;
					HifiInfo[i][hY] = 0;
					HifiInfo[i][hZ] = -50;
					DestroyDynamicObject(HifiInfo[i][hObject]);
				}
			}
			Msg(playerid, "HiFi-k törölve!");
		}
		else if(egyezik(param[1], "exportnpc"))
		{
			SpawnExportNPC();
			Msg(playerid, "SpawnExportNPC(); - lefutott!")
		}
		else if(egyezik(param[1], "csoportok"))
		{
			LoadCsoportok();
			Msg(playerid, "Csoportok betöltve!")
		}
		else if(egyezik(param[1], "sql"))
		{
			MysqlKapcsolodas(true);
			Msg(playerid, "MysqlKapcsolodas(true); - lefutott!")
		}
		else if(egyezik(param[1], "prod"))
		{
			Production();
			Msg(playerid, "Production(); - lefutott!")
		}
		else if(egyezik(param[1], "numplayers"))
		{
			NumPlayersDebug();
			Msg(playerid, "NumPlayersDebug(); - lefutott!");
		}
		else if(egyezik(param[1], "objektselect"))
		{
			SelectObject(playerid);
		}
		else if(egyezik(param[1], "bankrob"))
		{
			KaszinoSzef = false;
			Cselekves(playerid, "beír egy kódot és kinyitotta a széfet.", 0);
			VisszaKRobbol = 50;
			SetTimerEx("kBankrobRiaszt", 60000, false, "d", kBankrober[playerid]);
		}
		else if(egyezik(param[1], "kocsikerek"))
		{
			if(params < 2) return 1;
			new kocsi = strval(param[2]);
			if(kocsi < 1 || kocsi >= MAX_VEHICLES || !IsVehicleConnected(kocsi)) return 1;

			new panels, doors, lights, tires;
			GetVehicleDamageStatus(kocsi, panels, doors, lights, tires);
			if(tires == 15)
			{
				UpdateVehicleDamageStatus(kocsi, panels, doors, lights, 0);
				Msg(playerid, "Kerék megjavitva");
			}
			else
			{
				UpdateVehicleDamageStatus(kocsi, panels, doors, lights, 15);
				Msg(playerid, "Kerék kilyukasztva");
			}
		}	
		else if(egyezik(param[1], "usercp"))
		{
			if(params != 2) return Msg(playerid, "/debug usercp [adminstat]");
			if(egyezik(param[2], "adminstat"))
			{
				Msg(playerid, "UCP Adminstat update elindítva!");
				__UCP(NINCS, "adminstat");
				Msg(playerid, "UCP Adminstat update kész!");
			}
		}
		else if(egyezik(param[1], "alkatresz"))
		{
		    if(!IsPlayerInAnyVehicle(playerid)) return Msg(playerid, "Csak kocsiban");
		    new vkocsi = IsAVsKocsi(GetPlayerVehicleID(playerid));
		    if(vkocsi == NINCS) return false;
			if(params != 3) return Msg(playerid, "/debug alkatrész [gyújtás / kompresszió / üzemanyag] [Szám]");
			new mennyi = strval(param[3]);
			if(egyezik(param[2], "kompresszió"))
		   	 	CarInfo[vkocsi][cAllapot][ALLAPOT_KOMPRESSZIO] = mennyi;
			else if(egyezik(param[2], "gyújtás"))
		   	 	CarInfo[vkocsi][cAllapot][ALLAPOT_GYUJTAS] = mennyi;
			else if(egyezik(param[2], "üzemanyag"))
		   	 	CarInfo[vkocsi][cAllapot][ALLAPOT_UZEMANYAG] = mennyi;
			else return Msg(playerid, "Nincs ilyen alkatrész ÉKEZETTEL ÍRTAD?");
			
			Msg(playerid, "Kész!");
		}
		else if(egyezik(param[1], "szovetseg"))
		{
		    for(new f1=1; f1 < MAX_FRAKCIO; f1++)
		    {
		        for(new f2=1; f2 < MAX_FRAKCIO; f2++)
		    	{
		    		if(FrakcioInfo[f1][fSzovetseges][f2] == 1 && FrakcioInfo[f2][fSzovetseges][f1] != 1 || FrakcioInfo[f1][fSzovetseges][f2] != 1 && FrakcioInfo[f2][fSzovetseges][f1] == 1)
		    		{
		    		    FrakcioInfo[f1][fSzovetseges][f2] = 0;
		    		    FrakcioInfo[f2][fSzovetseges][f1] = 0;
		    		}
				}
			}
		}
		else if(egyezik(param[1], "surfing"))
		{
		    if(params != 2) return Msg(playerid, "/debug surfing [obj / veh]");
		    if(egyezik(param[2], "obj"))
	   			SendFormatMessage(playerid,COLOR_WHITE, "GetPlayerSurfingObjectID: %d",GetPlayerSurfingObjectID(playerid));
			else if(egyezik(param[2], "veh"))
			    SendFormatMessage(playerid,COLOR_WHITE, "GetPlayerSurfingVehicleID: %d",GetPlayerSurfingVehicleID(playerid));
		}
		else if(egyezik(param[1], "tuz"))
		{
			RandomTuz();
		 	Msg(playerid, "Kész");
		 	return 1;
		}
		else if(egyezik(param[1], "padatok"))
		{
			new Float:Pos[3]
			GetPlayerPos(playerid,Pos[0],Pos[1],Pos[2]);
          	SendFormatMessage(playerid, 0xFFFFFFFF, "VW: %d",GetPlayerVirtualWorld(playerid));
			SendFormatMessage(playerid, 0xFFFFFFFF, "Int: %d",GetPlayerInterior(playerid));
			SendFormatMessage(playerid, 0xFFFFFFFF, "X: %f | Y: %f | Z: %f",Pos[0],Pos[1],Pos[2]);
          	return 1;
		}
		else if(egyezik(param[1], "zangle"))
		{
	   		new currentveh,
          		Float:z_rot;

          	currentveh = GetPlayerVehicleID(playerid);
          	GetVehicleZAngle(currentveh, z_rot);
          	SendFormatMessage(playerid, 0xFFFFFFFF, "Jármû Nézési Szöge: %f",z_rot);
          	return 1;
		}
		else if(egyezik(param[1], "time"))
		{
			Msg(playerid, "Kész");
			SyncTime();
		}
		else if(egyezik(param[1], "respawncars"))
		{
			for(new car = 1; car < MAX_VEHICLES; car++)
			{
				if(IsVehicleConnected(car))
					DestroyVehicle(car);
			}
			AllCarSpawn();
		}
		else if(egyezik(param[1], "saveaccounts"))
		{
			if(FloodCheck(playerid, cmd)) return 1;
			SaveAccounts();
			Msg(playerid, "Mentés elindult... kb. 10-20mp");
		}
		else if(egyezik(param[1], "ccc"))
		{
			if(params < 2) return Msg(playerid, "HP?");
			new hp = strval(param[2]);

			if(hp < 0 || hp > 100000) return Msg(playerid, "Érvénytelen szám");

			if(IsPlayerInAnyVehicle(playerid))
				SetVehicleHealth(GetPlayerVehicleID(playerid), float(hp));
			else
				Msg(playerid, "Nem vagy kocsiban!");
		}
		else if(egyezik(param[1], "frakciolimit"))
		{
			if(params < 3) return Msg(playerid, "Frakció és limit?");
			new frakcio = strval(param[2]), limit = strval(param[3]);
			FrakcioInfo[frakcio][fLimit] = limit;
			Msg(playerid, "Beállítva!");
			FrakcioUpdate(frakcio, FRAKCIO_Limit);
		}
		#if defined War_System
			else if(egyezik(param[1], "terulettulaj"))
			{
				if(params != 2) return Msg(playerid, "Frakció?");
				new frakcio = strval(param[2]);
				new terulet = NINCS;
				for(new x = 0; x < MAXTERULET; x++)
				{
					if(!TeruletInfo[x][Van]) continue;
					if(IsPlayerInDynamicArea(playerid, TeruletInfo[x][tArea]))
					{
						terulet = x;
						break;
					}
				}
				
				if(terulet == NINCS)
					return Msg(playerid, "Nem vagy egy területnél sem!");
				
				TeruletInfo[terulet][tTulaj] = frakcio;
				Msg(playerid, "Beállítva!");
				TeruletUpdate(terulet, TERULET_Tulaj);
				TeruletFrissites();
			}
		#endif
		else if(egyezik(param[1], "spectateveh"))
		{
			if(params < 2) {TogglePlayerSpectating(playerid, 0); return 1; }
			TogglePlayerSpectating(playerid, 1);
			PlayerSpectateVehicle(playerid, strval(param[2]));
			Msg(playerid, "Spectate!");
		}
		else if(egyezik(param[1], "idojaras"))
		{
			IdojarasValtozas();
			Msg(playerid, "Kész!");
		}
		else if(egyezik(param[1], "villany"))
		{
			if(params < 2) return Msg(playerid, "Használat: /debug villany [ház]");
			new hazszam = strval(param[2]);
			
			if(hazszam < 0 || hazszam >= sizeof(HouseInfo))
			{
				SendClientMessage(playerid, COLOR_PIROS, "Nincs ilyen ház");
				return 1;
			}
			if(HouseInfo[hazszam][Van] != 1)
			{
				SendClientMessage(playerid, COLOR_PIROS, "Nincs ilyen ház");
				return 1;
			}
			HouseInfo[hazszam][hVillanyFizetve] = 1;
			HouseInfo[hazszam][hVillanySzamla] = 0;
			HouseInfo[hazszam][hLekapcsolva] = 0;
			Msg(playerid, "Ház resettelve!");
		}
		
		else if(egyezik(param[1], "fekete"))
		{
			if(params < 3) return Msg(playerid, "Használat: /debug fekete [JátékosID/NévRészlet] [0/1]");
			new user = ReturnUser(param[2]);
			if(user == INVALID_PLAYER_ID)
				return Msg(playerid, "Nincs ilyen játékos!");

			new igennem = strval(param[3]);
			if(igennem == 1)
			{
				Feketeseg(user, true,0);
				return Msg(playerid, "Sötétség!");
			}
			else if(igennem == 0)
			{
				Feketeseg(user, false,0);
				return Msg(playerid, "Fény!");
			}
			else
				return Msg(playerid, "0 vagy 1!");
		}
		else if(egyezik(param[1], "CorrectPlayerDatas"))
		{
			if(params < 2) return Msg(playerid, "Név?");
			new user = ReturnUser(param[2]);
			if(user == INVALID_PLAYER_ID)
				return Msg(playerid, "Nincs ilyen játékos!");

			CorrectPlayerDatas(user);
			Msg(playerid, "Kész!");
		}
		else if(egyezik(param[1], "gettime"))
			SendFormatMessage(playerid, COLOR_WHITE, "gettime() = %d", gettime());
		else if(egyezik(param[1], "getdate"))
			SendFormatMessage(playerid, COLOR_WHITE, "getdate() = %d", getdate());
		else if(egyezik(param[1], "LVHatar"))
			SendFormatMessage(playerid, COLOR_WHITE, "Határ() = %d", LVHatar);
		else if(egyezik(param[1], "sound"))
		{
			if(params < 2)
				return Msg(playerid, "/debug sound [hang]");
			PlayerPlaySound(playerid, strval(param[2]), 0.0, 0.0, 0.0);
		}
		else if(egyezik(param[1], "payday"))
		{
			if(params < 2)
				return Msg(playerid, "/debug payday [idõ - percben!]");
			PlayerInfo[playerid][pPayDay] = strval(param[2]) * 60;
			SendFormatMessage(playerid, COLOR_WHITE, "PayDay: %dmp", strval(param[2]) * 60);
		}
		else if(egyezik(param[1], "adokitoltve"))
		{
			PlayerInfo[playerid][pAdoKitoltve] = 0;
			Msg(playerid, "Adó kitöltve 0ra téve");
		}
		else if(egyezik(param[1], "csomagtartocheck"))
		{
			new bool:ment;
			for(new x = 0; x < sizeof(CuccokAKocsiban); x++)
			{
				ment = false;
				for(new y = 0; y < 10; y++)
				{
					if(CuccokAKocsiban[x][y] < 0)
					{
						if(!ment)
						{
							MsgFormat(playerid, "Kocsi %d resettelve mert minusz volt benne", x);
							ment = true;
						}
						CuccokAKocsiban[x][y] = 0;
					}
				}
			}
			//CsomagTartoMentes();
			Msg(playerid, "Kész");
		}
		else if(egyezik(param[1], "mysqlupdater"))
		{
			MySQLUpdater();
			Msg(playerid, "MySQLUpdater Futtatva");
		}
		else if(egyezik(param[1], "report"))
		{
			if(params < 2) return Msg(playerid, "Név?");
			new player = ReturnUser(param[2]);
			if(player == INVALID_PLAYER_ID)
				return Msg(playerid, "Nincs ilyen játékos!");

			SendFormatMessage(playerid, COLOR_WHITE, "%s reportváltozójának az értéke: %d", PlayerName(player), TudReportolni[player]);
		}
		else if(egyezik(param[1], "csomagtarto"))
		{
			if(params < 2) return Msg(playerid, "/debug csomagtarto [minusz / plus]");
			if(egyezik(param[2], "minusz"))
			{
				new m = 0;
				VehicleForeach(v)
				{
					for(new cucc = 0; cucc < 17; cucc++)
					{
						if(CuccokAKocsiban[v][cucc] < 0)
						{
							CuccokAKocsiban[v][cucc] = 0;
							m++;
						}
					}
				}
				SendFormatMessage(playerid, COLOR_LIGHTRED, "* Összesen %d jármûben volt MINUSZ cucc", m);
			}
			if(egyezik(param[2], "plus"))
			{
				new m = 0;
				VehicleForeach(v)
				{
					for(new cucc = 0; cucc < 16; cucc++)
					{
						if(CuccokAKocsiban[v][cucc] > 10000)
						{
							CuccokAKocsiban[v][cucc] = 0;
							m++;
						}
					}
				}
				SendFormatMessage(playerid, COLOR_LIGHTRED, "* Összesen %d jármûben volt PLUS(10.000) cucc", m);
			}
		}

		return 1;
	}
	if(egyezik(cmd, "/atm"))
	{
		if(!Admin(playerid, FOADMIN)) return 1;
		if(params < 1)
		{
			Msg(playerid, " ");
			Msg(playerid, "/atm [Lerak / Pos / Go]", COLOR_ADMIN);
			Msg(playerid, "====[ Legközelebbi ATM ]=====", COLOR_ADMIN);
			new Float:PPos[3], Float:legkozelebb = 5000.0, Float:tav, ajto;
			GetPlayerPos(playerid, PPos[0], PPos[1], PPos[2]);
			for(new x = 0; x < sizeof(ATM); x++)
			{
				if(ATM[x][Van] != 1) continue;
				tav = GetDistance(PPos[0], PPos[1], PPos[2], ATM[x][aPosX], ATM[x][aPosY], ATM[x][aPosZ]);
				if(tav < legkozelebb)
				{
					legkozelebb = tav;
					ajto = x;
				}
			}
			MsgFormat(playerid, "ID: %d", ajto);
			MsgFormat(playerid, "Táv: %f", legkozelebb);
			return 1;
		}
		if(egyezik(param[1], "go"))
		{
			if(params < 2) return Msg(playerid, "/atm go [ATM ID]");
			new atmid = strval(param[2]);
			if(atmid < 0 || atmid > MAX_ATM) return Msg(playerid, "Hibás ATM ID.");
			if(ATM[atmid][Van] != 1) return Msg(playerid, "Nincs ilyen ATM!");
			SetPlayerPos(playerid, ATM[atmid][aPosX], ATM[atmid][aPosY], ATM[atmid][aPosZ]);
			SendFormatMessage(playerid,  COLOR_LIGHTGREEN, "* Teleportáltál az ATM-hez. (ID: %d - Koordínáta: X: %f | Y: %f | Z: %f) ", atmid, ATM[atmid][aPosX], ATM[atmid][aPosY], ATM[atmid][aPosZ]);
		}
		else if(egyezik(param[1], "pos"))
		{
			for(new a = 0; a < MAX_ATM; a++)
			{				
				new Float:PPos[3], Float:legkozelebb = 5.0, Float:tav;
				GetPlayerPos(playerid, PPos[0], PPos[1], PPos[2]);
				for(new x = 0; x < sizeof(ATM); x++)
				{
					if(ATM[x][Van] != 1) continue;
					tav = GetDistance(PPos[0], PPos[1], PPos[2], ATM[x][aPosX], ATM[x][aPosY], ATM[x][aPosZ]);
					if(tav < legkozelebb)
					{
						PlayerNumber[playerid] = ATM[x][aID];
						EditObject(playerid, ATM[x][aObjectID]);
					}
				}
			}
		}
		else if(egyezik(param[1], "lerak"))
		{
			for(new a = 0; a < MAX_ATM; a++)
			{
				if(ATM[a][Van] == 1 && PlayerToPoint(3, playerid, ATM[a][aPosX], ATM[a][aPosY], ATM[a][aPosZ]))
				{
					Msg(playerid, "Itt már van egy ATM!");
					return 1;
				}
			}
			new atmszama = UresATMHely();
			if(atmszama == -1){
				Msg(playerid, "Nem rakható le több ATM!");
				return 1;
			}
			new Float:x, Float:y, Float:z;
			GetPlayerPos(playerid, x, y, z);
			ATM[atmszama][aID] = atmszama;
			ATM[atmszama][Van] = 1;
			ATM[atmszama][aPosX] = x;
			ATM[atmszama][aPosY] = y;
			ATM[atmszama][aPosZ] = z;
			
			ATM[atmszama][aObjectID] = CreateObject(ATM_OBJECT_ID, ATM[atmszama][aPosX], ATM[atmszama][aPosY], ATM[atmszama][aPosZ], 0.0, 0.0, 0.0);
			ATM[atmszama][aMapIcon] = CreateDynamicMapIcon(ATM[atmszama][aPosX],ATM[atmszama][aPosY],ATM[atmszama][aPosZ], ATM_MAPICON_ID, 0, NINCS, NINCS, NINCS, 300.0);
			
			new nevek[100], adatok[256];

			nevek = "id, PosX, PosY, PosZ, fRotX, fRotY, fRotZ, ObjectID";
			format(adatok, 256, "%d, %f, %f, %f, 0.0, 0.0, 0.0, %d",\
			ATM[atmszama][aID],
			ATM[atmszama][aPosX],
			ATM[atmszama][aPosY],
			ATM[atmszama][aPosZ],
			ATM_OBJECT_ID);
			Mysql_Insert(SQL_DB_ATM, nevek, adatok);
			SendFormatMessage(playerid,COLOR_GREEN, "Új ATM lerakva! (ID: %d)", atmszama);
			
			SetPlayerPos(playerid, x, y, z+2.0);
			
			PlayerNumber[playerid] = ATM[atmszama][aID];
			SetPVarString(playerid, "MelyikObjectetSzerkeszti", "ATM");
			EditObject(playerid, ATM[atmszama][aObjectID]);
		}
		return 1;
	}
	if(egyezik(cmd, "/kapu"))
	{
		new adminszintkell = 4;
		if(params < 1)
		{
			if(!Admin(playerid, adminszintkell))
		 		Msg(playerid, "/kapu [Jelszó/Tulaj/Zár]");
			else
			{
			    Msg(playerid, "Alap: /kapu [Jelszó / Tulaj / Automata]");
			    Msg(playerid, "Admin: /kapu [Lerak / Pos / Id / Tulaj / Frakció / Go]", COLOR_ADMIN);
			}
			return 1;
		}
		else if(egyezik(param[1], "jelszó") || egyezik(param[1], "jelszo"))
		{
		   	new kapu = IsAt(playerid, IsAt_Kapu);
			if(kapu == NINCS) return Msg(playerid, "Nem vagy kapu közelében!");
			//if(!egyezik(KapuInfo[kapu][kTulaj], PlayerName(playerid)) && !IsAdmin(playerid)) return Msg(playerid, "Ez nem a te kapud!");
			if(!egyezik(KapuInfo[kapu][kTulaj], PlayerName(playerid)) && (egyezik(KapuInfo[kapu][kTulaj], "Nincs") && KapuInfo[kapu][kFrakcio] != PlayerInfo[playerid][pLeader]) && !Admin(playerid, FOADMIN)) return Msg(playerid, "Ez nem a te kapud!");
			if(params < 2) return Msg(playerid, "/kapu jelszó [Új jelszó]");
			strtok(cmdtext, idx);
			new length = strlen(cmdtext);
			while ((idx < length) && (cmdtext[idx] <= ' '))
			{
				idx++;
			}
			new offset = idx;
			new result[24];
			while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
			{
				result[idx - offset] = cmdtext[idx];
				idx++;
			}
			result[idx - offset] = EOS;
			if(strlen(result) > MAX_PLAYER_NAME) return Msg(playerid, "MAX. 24 karakter!");
			if(!IsNumeric(result)) return Msg(playerid, "Számokat használj!");
			format(KapuInfo[kapu][kJelszo],32, "%s",result);// = result;
			KapuUpdate(kapu, "Zarva='%s'",result);
		}
		else if(egyezik(param[1], "lerak"))
		{
			if(!Admin(playerid, adminszintkell)) return 1;
			if(params < 4)
			{
				Msg(playerid, " ", COLOR_ADMIN);
				Msg(playerid, "/kapu lerak [Típus] [Tulaj(Ha frakció, írd be: Nincs)] [Frakció ID (0 = Nem frakció)]", COLOR_ADMIN);
				Msg(playerid, "Garázs(Fel le): 3037", COLOR_ADMIN);
				Msg(playerid, "Nagy kapu (Fel le): 980", COLOR_ADMIN);
				Msg(playerid, "Kis Kapu (Oldalra): 969", COLOR_ADMIN);
				return 1;
			}
			new tipus = strval(param[2]);
			new frakcio = strval(param[4]);
			if(strlen(param[3]) > 24) return Msg(playerid, "Max 24 karakter!", COLOR_ADMIN);
			if(tipus != 980 && tipus != 969 && tipus != 3037) return Msg(playerid, "Hibás Kapu típus!", COLOR_ADMIN);
			new Float:jPos[3], Float:Angle;
			GetPlayerPos(playerid, jPos[0], jPos[1], jPos[2]);
			GetPlayerFacingAngle(playerid, Angle);

			if(tipus == 9593)
			{
				jPos[2] -= 0.9;
				new Float:pZarva[2];
				pZarva[0] = jPos[0];
				pZarva[1] = jPos[1];
				GetXYLeftOfPoint(pZarva[0],pZarva[1], Angle,4.0);
				GetXYRightOfPoint(jPos[0], jPos[1], Angle,4.0);
				UjKapu(jPos[0], jPos[1], jPos[2], 0.0,0.0,Angle, pZarva[0], pZarva[1], jPos[2], 0.0, 0.0, Angle, tipus, param[3], frakcio);
			}
			else
				UjKapu(jPos[0], jPos[1], jPos[2], 0.0,0.0,Angle, jPos[0], jPos[1], jPos[2]-6, 0.0, 0.0, Angle, tipus, param[3], frakcio);

			SendFormatMessage(playerid,COLOR_LIGHTGREEN, "Új kapu lerakva! Frakció: %d, Tulaj: %s",frakcio,param[3]);
		}
		else if(egyezik(param[1], "pos"))
		{
			if(!Admin(playerid)) return 1;
			if(params < 2) return Msg(playerid, "/kapu pos");
			new kapuid = strval(param[2]);
			if(kapuid < 0 || kapuid > MAX_KAPU) return Msg(playerid, "Hibás Kapu ID.");
			if(KapuInfo[kapuid][Van] != 1) return Msg(playerid, "Nincs ilyen Kapu!");
			new Float:X, Float:Y, Float:Z, Float:A;
			GetPlayerPos(playerid, X, Y, Z);
			GetPlayerFacingAngle(playerid, A);
			
			if(KapuInfo[kapuid][kObjectID] == 9593)
			{
				X -= 0.9;
			    new Float:X2,Float:Y2;
			    X2 = X;
			    Y2 = Y;
			    GetXYLeftOfPoint(X2,Y2, A,4.0);
				GetXYRightOfPoint(X,Y, A,4.0);
			    
				KapuInfo[kapuid][kPos][0] = X;
				KapuInfo[kapuid][kPos][1] = Y;
				KapuInfo[kapuid][kPos][2] = Z;

				KapuInfo[kapuid][kAngle][0] = 0.0;
				KapuInfo[kapuid][kAngle][1] = 0.0;
				KapuInfo[kapuid][kAngle][2] = A;

				KapuInfo[kapuid][kNyitottPos][0] = X2;
				KapuInfo[kapuid][kNyitottPos][1] = Y2;
				KapuInfo[kapuid][kNyitottPos][2] = Z;

				KapuInfo[kapuid][kNyitottAngle][0] = 0.0;
				KapuInfo[kapuid][kNyitottAngle][1] = 0.0;
				KapuInfo[kapuid][kNyitottAngle][2] = A;
				
				if(IsValidDynamicObject(KapuInfo[kapuid][kObject])){
					DestroyDynamicObject(KapuInfo[kapuid][kObject]);
					KapuInfo[kapuid][kObject] = NINCS;
				}
					
				KapuInfo[kapuid][kObject] = CreateDynamicObject(KapuInfo[kapuid][kObjectID], X, Y, Z-0.9, 0.0, 0.0, A);
				KapuUpdate(kapuid, "PosX='%f', PosY='%f', PosZ='%f', RotX='%f', RotY='%f', RotZ='%f'",KapuInfo[kapuid][kPos][0],KapuInfo[kapuid][kPos][1],KapuInfo[kapuid][kPos][2],KapuInfo[kapuid][kAngle][0],KapuInfo[kapuid][kAngle][1],KapuInfo[kapuid][kAngle][2]);
				KapuUpdate(kapuid, "zPosX='%f', zPosY='%f', zPosZ='%f', zRotX='%f', zRotY='%f', zRotZ='%f'",KapuInfo[kapuid][kNyitottPos][0],KapuInfo[kapuid][kNyitottPos][1],KapuInfo[kapuid][kNyitottPos][2],KapuInfo[kapuid][kNyitottAngle][0],KapuInfo[kapuid][kNyitottAngle][1],KapuInfo[kapuid][kNyitottAngle][2]);
			}
			else if(KapuInfo[kapuid][kObjectID] == 3037)
			{
				Z += 90;
				KapuInfo[kapuid][kPos][0] = X;
				KapuInfo[kapuid][kPos][1] = Y;
				KapuInfo[kapuid][kPos][2] = Z;

				KapuInfo[kapuid][kAngle][0] = 0.0;
				KapuInfo[kapuid][kAngle][1] = 0.0;
				KapuInfo[kapuid][kAngle][2] = A;

				KapuInfo[kapuid][kNyitottPos][0] = X;
				KapuInfo[kapuid][kNyitottPos][1] = Y;
				KapuInfo[kapuid][kNyitottPos][2] = Z-6;

				KapuInfo[kapuid][kNyitottAngle][0] = 0.0;
				KapuInfo[kapuid][kNyitottAngle][1] = 0.0;
				KapuInfo[kapuid][kNyitottAngle][2] = A;
				
				if(IsValidDynamicObject(KapuInfo[kapuid][kObject])){
					DestroyDynamicObject(KapuInfo[kapuid][kObject]);
					KapuInfo[kapuid][kObject] = NINCS;
				}
				
				KapuInfo[kapuid][kObject] = CreateDynamicObject(KapuInfo[kapuid][kObjectID], X, Y, Z, 0.0, 0.0, A);
				KapuUpdate(kapuid, "PosX='%f', PosY='%f', PosZ='%f', RotX='%f', RotY='%f', RotZ='%f'",KapuInfo[kapuid][kPos][0],KapuInfo[kapuid][kPos][1],KapuInfo[kapuid][kPos][2],KapuInfo[kapuid][kAngle][0],KapuInfo[kapuid][kAngle][1],KapuInfo[kapuid][kAngle][2]);
				KapuUpdate(kapuid, "zPosX='%f', zPosY='%f', zPosZ='%f', zRotX='%f', zRotY='%f', zRotZ='%f'",KapuInfo[kapuid][kNyitottPos][0],KapuInfo[kapuid][kNyitottPos][1],KapuInfo[kapuid][kNyitottPos][2],KapuInfo[kapuid][kNyitottAngle][0],KapuInfo[kapuid][kNyitottAngle][1],KapuInfo[kapuid][kNyitottAngle][2]);
			}
			else
			{
			    KapuInfo[kapuid][kPos][0] = X;
				KapuInfo[kapuid][kPos][1] = Y;
				KapuInfo[kapuid][kPos][2] = Z;

				KapuInfo[kapuid][kAngle][0] = 0.0;
				KapuInfo[kapuid][kAngle][1] = 0.0;
				KapuInfo[kapuid][kAngle][2] = A;

				KapuInfo[kapuid][kNyitottPos][0] = X;
				KapuInfo[kapuid][kNyitottPos][1] = Y;
				KapuInfo[kapuid][kNyitottPos][2] = Z-6;

				KapuInfo[kapuid][kNyitottAngle][0] = 0.0;
				KapuInfo[kapuid][kNyitottAngle][1] = 0.0;
				KapuInfo[kapuid][kNyitottAngle][2] = A;
				
				if(IsValidDynamicObject(KapuInfo[kapuid][kObject])){
					DestroyDynamicObject(KapuInfo[kapuid][kObject]);
					KapuInfo[kapuid][kObject] = NINCS;
				}
				
				KapuInfo[kapuid][kObject] = CreateDynamicObject(KapuInfo[kapuid][kObjectID], X, Y, Z, 0.0, 0.0, A);
				KapuUpdate(kapuid, "PosX='%f', PosY='%f', PosZ='%f', RotX='%f', RotY='%f', RotZ='%f'",KapuInfo[kapuid][kPos][0],KapuInfo[kapuid][kPos][1],KapuInfo[kapuid][kPos][2],KapuInfo[kapuid][kAngle][0],KapuInfo[kapuid][kAngle][1],KapuInfo[kapuid][kAngle][2]);
				KapuUpdate(kapuid, "zPosX='%f', zPosY='%f', zPosZ='%f', zRotX='%f', zRotY='%f', zRotZ='%f'",KapuInfo[kapuid][kNyitottPos][0],KapuInfo[kapuid][kNyitottPos][1],KapuInfo[kapuid][kNyitottPos][2],KapuInfo[kapuid][kNyitottAngle][0],KapuInfo[kapuid][kNyitottAngle][1],KapuInfo[kapuid][kNyitottAngle][2]);
			}
			SendFormatMessage(playerid,  COLOR_LIGHTGREEN, "* Kapu áthelyezve. (ID: %d)", kapuid);
		}
		else if(egyezik(param[1], "id"))
		{
			if(!Admin(playerid, adminszintkell)) return 1;
			new kapu = IsAt(playerid,IsAt_Kapu);
			if(kapu == NINCS) return Msg(playerid, "Nem vagy kapu közelében!");
			SendFormatMessage(playerid,COLOR_LIGHTRED, "Kapu ID-je: %d", kapu);
		}
		else if(egyezik(param[1], "tulaj") || egyezik(param[1], "owner"))
		{
			new kapu = IsAt(playerid, IsAt_Kapu);
			if(kapu == NINCS) return Msg(playerid, "Nem vagy kapu közelében!");
			//if(!egyezik(KapuInfo[kapu][kTulaj], PlayerName(playerid)) && !IsAdmin(playerid)) return Msg(playerid, "Ez nem a te kapud!");
			if(!egyezik(KapuInfo[kapu][kTulaj], PlayerName(playerid)) && (egyezik(KapuInfo[kapu][kTulaj], "Nincs") && KapuInfo[kapu][kFrakcio] != PlayerInfo[playerid][pLeader]) && !Admin(playerid, FOADMIN)) return Msg(playerid, "Ez nem a te kapud!");
			if(params < 2) return Msg(playerid, "/kapu tulaj [Név]");
			strtok(cmdtext, idx);
			new length = strlen(cmdtext);
			while ((idx < length) && (cmdtext[idx] <= ' '))
			{
				idx++;
			}
			new offset = idx;
			new result[24];
			while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
			{
				result[idx - offset] = cmdtext[idx];
				idx++;
			}
			result[idx - offset] = EOS;
			if(strlen(result) > MAX_PLAYER_NAME) return Msg(playerid, "MAX. 24 karakter!");
			KapuInfo[kapu][kTulaj] = result;
			SendFormatMessage(playerid,COLOR_LIGHTGREEN, "Új tulaj megadva: %s",KapuInfo[kapu][kTulaj]);
		}
		else if(egyezik(param[1], "go"))
		{
			if(!Admin(playerid, adminszintkell)) return 1;
			if(params < 2) return Msg(playerid, "/kapu go [Kapu ID]");
			new kapuid = strval(param[2]);
			if(kapuid < 0 || kapuid > MAX_KAPU) return Msg(playerid, "Hibás Kapu ID.");
			if(KapuInfo[kapuid][Van] != 1) return Msg(playerid, "Nincs ilyen Kapu!");
			
			new rand = Rand(1,3);
			
			SetPlayerPos(playerid, KapuInfo[kapuid][kPos][0]+rand, KapuInfo[kapuid][kPos][1]+rand, KapuInfo[kapuid][kPos][2]+rand);
		}
		else if(egyezik(param[1], "automata"))
		{	   
			new kapu = IsAt(playerid, IsAt_Kapu);
			if(kapu == NINCS) return Msg(playerid, "Nem vagy kapu közelében!");
			if(!egyezik(KapuInfo[kapu][kTulaj], PlayerName(playerid)) && (egyezik(KapuInfo[kapu][kTulaj], "Nincs") && KapuInfo[kapu][kFrakcio] != PlayerInfo[playerid][pLeader]) && !Admin(playerid, FOADMIN)) return Msg(playerid, "Ez nem a te kapud!");
			if(params < 2) return Msg(playerid, "/kapu automata [0 = Nem automata(/zár-ral záródik) | 5-nél nagyobb = Ennyi másodperc után záródik automatikusan]");               
			new ido = strval(param[2])
			if(ido > 20 || ido < 5 && ido != 0) return Msg(playerid, "Csak 0, 5, és 20 közötti számot adhatsz meg!");
			KapuInfo[kapu][kAutomata] = ido;
			KapuUpdate(kapu, "Automata='%d'", ido);
			if(ido != 0)
				SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Kapu automatikus záródás beállítva %d másodpercre", ido);
			else 
				SendClientMessage(playerid, COLOR_LIGHTGREEN, "Kapu automatikus záródás kikapcsolva");
			return 1;
		}
		return 1;
	}
	if(egyezik(cmd, "/nevek"))
	{
		//if(!Admin(playerid, 1)) return HibasParancs(playerid, true);

		if(Nevek[playerid] == 1)
		{
			Nevek[playerid] = 0;
			ShowNames(playerid, 0);
			Msg(playerid, "Nevek kikapcsolva!");
		}
		else
		{
			Nevek[playerid] = 1;
			ShowNames(playerid, 1);
			Msg(playerid, "Nevek bekapcsolva!");
		}

		return 1;
	}

	if(egyezik(cmd, "/alock"))
	{
		if(!Admin(playerid, 1)) return HibasParancs(playerid, true);

		new kocsi = GetClosestVehicle(playerid);

		if(GetDistanceToVehicle(playerid, kocsi) > 6.0) return Msg(playerid, "Nincs a közeledben jármû!");

		if(!Locked(kocsi))
		{
			LockCar(kocsi);
			PlayerTextFormat(playerid, "Kocsi bezárva! [ID: %d]", kocsi);
		}
		else
		{
			UnLockCar(kocsi);
			PlayerTextFormat(playerid, "Kocsi nyitva! [ID: %d]", kocsi);
		}
		Msg(playerid, PlayerText[playerid], COLOR_ADMIN);
		return 1;
	}

	if(egyezik(cmd, "/gotopos"))
	{
		if(!Admin(playerid, FOADMIN)) return HibasParancs(playerid, true);
		if(params < 3) return Msg(playerid, "/gotopos [X] [Y] [Z] [A]", COLOR_ADMIN);

		new Float:tpos[4];
		tpos[0] = floatstr(param[1]);
		tpos[1] = floatstr(param[2]);
		tpos[2] = floatstr(param[3]);
		tpos[3] = floatstr(param[4]);
		
		Tele(playerid, tpos[0], tpos[1], tpos[2], false);
		SetPlayerFacingAngle(playerid, tpos[3]);
		
		PlayerTextFormat(playerid, "Teleportálva ide: X:%f, Y:%f, Z:%f, A:%f", tpos[0], tpos[1], tpos[2], tpos[3]);
		Msg(playerid, PlayerText[playerid], COLOR_ADMIN);
		
		return 1;
	}

	if(egyezik(cmd, "/aláír") || egyezik(cmd, "/alair"))
	{
		if(AdasVeteliNeki[playerid] == NINCS) return Msg(playerid, "Nem adtak neked szerzõdést!");

		new player = AdasVeteliNeki[playerid];

		new cucc, nev[MAX_PLAYER_NAME], ara, Float:tav;		
		Format(nev, "%s", PlayerName(player, true));		
		ara = AdasVeteliAra[playerid];
		tav = GetDistanceBetweenPlayers(playerid, player);

		if(tav > 2.0) return Msg(playerid, "Nincs a közeledben!");

		if(AdasVeteliTipus[playerid] == 0)
		{
			if(PlayerInfo[player][pPhousekey] != NINCS)
			{
				PlayerInfo[player][pPremiumPont] -= 1800;
				Msg(player, "1800 Prémiumpont levonva!");
			}

			cucc = AdasVeteliCucc[playerid];
			strmid(HouseInfo[cucc][hOwner], nev, 0, strlen(nev), MAX_PLAYER_NAME);
			//HazUpdate(cucc, "Tulaj='%s'", nev);
			HazUpdate(cucc, HAZ_Owner);
			PlayerInfo[playerid][pPhousekey] = NINCS;
			PlayerInfo[playerid][pLakcimkartya] = 0;

			Cselekves(playerid, "aláírta az adásvételi szerzõdést");
			//BizPenz(BIZ_HAZ, 100, playerid);
			//BizPenz(BIZ_HAZ, 100, player);
			FrakcioInfo[LMUNKA_ALLAM][fPenz] += 100;
			SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Aláírtad a szerzõdést. Eladtad a Los Santos str. %d. szám alatt lévõ házt, és a bank átutalta a pénzt ($%d)", cucc, ara);
			SendFormatMessage(player, COLOR_LIGHTBLUE, "%s aláírta a szerzõdést, ezáltal tied a Los Santos str. %d. szám alatt lévõ ház, és átutaltad neki a pénzt ($%d)", PlayerName(playerid), cucc, ara);
			PlayerInfo[player][pAccount] -= ara;
			if(PlayerInfo[playerid][pBankSzamlaSzam] != 0) PlayerInfo[playerid][pAccount] += ara;
			else GiveMoney(playerid, ara);
		}
		else if(AdasVeteliTipus[playerid] == 1)
		{
			cucc = AdasVeteliCucc[playerid];
			strmid(CarInfo[cucc][cOwner], nev, 0, strlen(nev), MAX_PLAYER_NAME);
			//CarUpdate(cucc, "Tulaj='%s'", nev);
			CarUpdate(cucc, CAR_Owner);

			Cselekves(playerid, "aláírta az adásvételi szerzõdést");
			
			//BizPenz(BIZ_IMPORT, 100, playerid);
			//BizPenz(BIZ_IMPORT, 100, player);
			FrakcioInfo[LMUNKA_ALLAM][fPenz] += 100;
			Msg(playerid, "$100 adó levonva!");
			Msg(player, "$100 adó levonva!");
			SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Aláírtad a szerzõdést. Eladtad a %d rendszámû jármûvedet, és a bank átutalta a pénzt ($%d)", cucc, ara);
			SendFormatMessage(player, COLOR_LIGHTBLUE, "%s aláírta a szerzõdést, ezáltal tied a %d rendszámú jármû, és átutaltad neki a pénzt ($%d)", PlayerName(playerid), cucc, ara);
			PlayerInfo[player][pAccount] -= ara;
			if(PlayerInfo[playerid][pBankSzamlaSzam] != 0) PlayerInfo[playerid][pAccount] += ara;
			else GiveMoney(playerid, ara);
		}

		AdasVeteliNeki[playerid] = NINCS;

		CorrectPlayerDatas(playerid);
		CorrectPlayerDatas(player);

		return 1;
	}

	if(egyezik(cmd, "/adasveteli") || egyezik(cmd, "/adásvételi"))
	{
		new player = GetClosestPlayer(playerid), Float:tav = GetDistanceBetweenPlayers(playerid, player);

		if(tav > 2.0) return Msg(playerid, "A közeledben nincs senki!");
		if(AdasVeteliNeki[player] != NINCS) return Msg(playerid, "Neki már adtak egy adásvételi szerzõdést!");

		if(params < 2)
		{
			Msg(playerid, "Használata: /adásvételi [mit] [mennyiért]");
			Msg(playerid, "Lehet: kocsi, ház, biznisz");
			return 1;
		}

		new ara = strval(param[2]);
		if(ara > PlayerInfo[playerid][pAccount]) return Msg(playerid, "Nincs ennyi pénz a bankszámládon!");

		if(egyezik(param[1], "ház") || egyezik(param[1], "haz"))
		{
		    if(ara < 500) return Msg(playerid, "Minimum $500!");
			if(ara > 90000)	return Msg(playerid, "Maximum $90.000!");
			
			if(PlayerInfo[playerid][pPhousekey] != NINCS AND PlayerInfo[playerid][pPhousekey2] != NINCS) return Msg(playerid, "Maximum 2 házad lehet!");

			new haz = IsAt(playerid, IsAt_Haz);
			if(haz == NINCS) return Msg(playerid, "Nem vagy egy házban sem!");

			if(!egyezik(PlayerName(player, true), HouseInfo[haz][hOwner]))
			{
				Msg(playerid, "Szép próba!");
				Msg(playerid, "[Vevõ]Bugot akarsz kihasználni?(Ház)");
				Msg(player, "Ez nem a te házad!");
				Msg(player, "[Tulaj]Bugot akarsz kihasználni?(Ház)");
				return 1;
			}

			if(VanHaza(playerid) == 1)
			{
				if(Biztos[playerid] != 1)
				{
					Msg(playerid, "Biztos vagy benne, hogy megveszed második házként? Vehetsz második kocsit is. Ha biztos vagy benne, írd be újra a parancsot!");
					Biztos[playerid] = 1;
					return 1;
				}
			}

			new szoveg[64];
			Format(szoveg, "átnyújtja az adásvételi szerzõdést neki: %s", PlayerName(player));
			Cselekves(playerid, szoveg);

			AdasVeteliNeki[player] = playerid;
			AdasVeteliTipus[player] = 0;
			AdasVeteliAra[player] = ara;
			AdasVeteliCucc[player] = haz;
			Msg(playerid, "Átadtad neki a szerõzdést.");
			//BizPenz(BIZ_HAZ, 100, playerid);
			//BizPenz(BIZ_HAZ, 100, player);
			SendFormatMessage(player, COLOR_LIGHTBLUE, "%s megvenné a házadat $%dért - A szerzõdés aláírása: /alair - Visszautasítás: /cancel adasveteli", PlayerName(playerid), ara);
		}
		else if(egyezik(param[1], "kocsi"))
		{
		    if(ara < 500) return Msg(playerid, "Minimum $500!");
			if(ara > 90000)	return Msg(playerid, "Maximum $90.000!");

			if(PlayerInfo[playerid][pPcarkey] != NINCS AND PlayerInfo[playerid][pPcarkey2] != NINCS) return Msg(playerid, "Maximum 2 kocsid lehet!");				
			if(PlayerInfo[player][pPcarkey] == NINCS AND PlayerInfo[player][pPcarkey2] == NINCS) return Msg(playerid, "Neki nincs saját jármûve!");

			new kocsi = GetClosestVehicle(playerid);
			if(GetDistanceToVehicle(playerid, kocsi) > 5.5)	return Msg(playerid, "Nincs jármû a közeledben");

			new vs = IsAVsKocsi(kocsi);
			if(vs == NINCS) return Msg(playerid, "Ez a jármû a módba van beleírva!");
			if(CarInfo[vs][cOwned] != 1) return Msg(playerid, "Ez egy kereskedõ jármû...");
			if(!egyezik(CarInfo[vs][cOwner], PlayerName(player, true))) return Msg(playerid, "Ez nem az övé!");

			if(PlayerInfo[playerid][pPcarkey] != NINCS)
			{
				if(Biztos[playerid] != 1)
				{
					Msg(playerid, "Biztos vagy benne, hogy megveszed második jármûként? Vehetsz második házat is. Ha biztos vagy benne, írd be újra a parancsot!");
					Biztos[playerid] = 1;
					return 1;
				}
			}

			new szoveg[64];
			Format(szoveg, "átnyújtja az adásvételi szerzõdést neki: %s", PlayerName(player));
			Cselekves(playerid, szoveg);

			AdasVeteliNeki[player] = playerid;
			AdasVeteliTipus[player] = 1;
			AdasVeteliAra[player] = ara;
			AdasVeteliCucc[player] = vs;
			Msg(playerid, "Átadtad neki a szerõzdést.");
			SendFormatMessage(player, COLOR_LIGHTBLUE, "%s megvenné a jármûvedet $%dért - A szerzõdés aláírása: /alair - Visszautasítás: /cancel adasveteli", PlayerName(playerid), ara);
		}
		else if(egyezik(param[1], "biznisz"))
		{
			if(PlayerInfo[playerid][pPbiskey] != NINCS) return Msg(playerid, "Már van bizniszed!");
			if(PlayerInfo[player][pPbiskey] == NINCS) return Msg(playerid, "Neki nincs biznisze!");

			new szoveg[64];
			Format(szoveg, "átnyújtja az adásvételi szerzõdést neki: %s", PlayerName(player));
			Cselekves(playerid, szoveg);

			AdasVeteliNeki[player] = playerid;
			AdasVeteliTipus[player] = 2;
			AdasVeteliAra[player] = ara;
			Msg(playerid, "Átadtad neki a szerõzdést.");
			//BizPenz(BIZ_HAZ, 100, player);
			//BizPenz(BIZ_HAZ, 100, player);
			SendFormatMessage(player, COLOR_LIGHTBLUE, "%s megvenné a bizniszedet $%dért - A szerzõdés aláírása: /alair - Visszautasítás: /cancel adasveteli", PlayerName(playerid), ara);
		}
		else
		{
			Msg(playerid, "Használata: /adásvételi [kitõl] [mit] [mennyiért]");
			Msg(playerid, "Lehet: kocsi, ház, biznisz");
			return 1;
		}

		return 1;
	}
	
	if(egyezik(cmd, "/gps"))
	{
		new kocsi = GetPlayerVehicleID(playerid);
		
		if(PlayerInfo[playerid][pPnumber] == 0)
		{
			ShowPlayerDialog(playerid, DIALOG_NINCS, DIALOG_STYLE_MSGBOX, "{FF0000}Hiba!", "{FFFFFF}Neked nincs telefonod!", "Bezárás", "");
			return 1;
		}
		
	    //new vs = IsAVsKocsi(veh);
		new f[32], hazszam = NINCS;

		if(params >= 1)
			strmid(f, param[1], 0, strlen(param[1]));
		if(params >= 2)
		{
			if(strlen(param[2]) < 5)
				hazszam = strval(param[2]);
		}
		if(params < 1)
		{
			new gotostring[1024];
			for(new g = 0; g < GPS_SZAMA; g++)
			{
				if(g == 0)
					Format(gotostring, "%s", GPSNev[0][0]);
				else
					Format(gotostring, "%s\n%s", gotostring, GPSNev[g][0]);
			}
			ShowPlayerDialog(playerid, DIALOG_GPS, DIALOG_STYLE_LIST, "Navigációs rendszer", gotostring, "Beállít", "Mégse");
			return 1;
		}
		if(IsPlayerInAnyVehicle(playerid) || egyezik(param[1], "kocsim") || egyezik(param[1], "házam") || egyezik(param[1], "ház") || egyezik(param[1], "hazam") || egyezik(param[1], "haz"))
		{
			if(egyezik(f, "töröl") || egyezik(f, "torol"))
			{
				DisablePlayerCheckpoint(playerid);
				SendClientMessage(playerid, COLOR_YELLOW2, "A jel törölve!");
				return 1;
			}
			else if(egyezik(f, "ház") || egyezik(f, "haz"))
			{
				if(params < 2 || hazszam == NINCS) return Msg(playerid, "Használata: /gps ház [házszám]");

				if(hazszam < 0 || hazszam >= sizeof(HouseInfo)) return Msg(playerid, "Nincs ilyen ház");
				if(HouseInfo[hazszam][Van] != 1) return Msg(playerid, "Nincs ilyen ház");

				GpsBekapcsol(playerid, HouseInfo[hazszam][hEntrancex], HouseInfo[hazszam][hEntrancey], HouseInfo[hazszam][hEntrancez]);
				return 1;
			}
			else if(egyezik(f, "házam") || egyezik(f, "hazam"))
			{
				if(PlayerInfo[playerid][pPhousekey] != NINCS)
					GpsBekapcsol(playerid,HouseInfo[PlayerInfo[playerid][pPhousekey]][hEntrancex], HouseInfo[PlayerInfo[playerid][pPhousekey]][hEntrancey], HouseInfo[PlayerInfo[playerid][pPhousekey]][hEntrancez]);
				else
					GameTextForPlayer(playerid, "~w~Nincs házad", 3000, 1);
				return 1;
			}
			else if(egyezik(f, "kocsim"))
			{
				new kocsi2 = PlayerInfo[playerid][pPcarkey2];
				kocsi = PlayerInfo[playerid][pPcarkey];

				new kell = 1;
				if(kocsi2 != NINCS)
				{
					if(params < 2)
						return Msg(playerid, "Használata: /gps kocsim [1/2]");

					kell = strval(param[2]);
					if(kell != 1 && kell != 2)
						return Msg(playerid, "Használata: /gps kocsim [1/2]");
				}

				if(kell == 1)
				{
					if(Lopott[kocsi] == true) return Msg(playerid, "A kocsidat ellopták!");
					new Float:x, Float:y, Float:z;
					GetVehiclePos(CarInfo[kocsi][cId], x, y, z);
					GpsBekapcsol(playerid, x, y, z);

					Msg(playerid, "Megjelölve a radaron");
				}
				else if(kell == 2)
				{
					if(Lopott[kocsi2] == true) return Msg(playerid, "A kocsidat ellopták!");
					new Float:x, Float:y, Float:z;
					GetVehiclePos(CarInfo[kocsi2][cId], x, y, z);
					GpsBekapcsol(playerid, x, y, z);

					Msg(playerid, "Megjelölve a radaron");
				}
				else
					GameTextForPlayer(playerid, "~w~Nincs kocsid", 3000, 1);
				return 1;
			}
			else
			{
				Msg(playerid, "Nem találom a helyet az adatbázisban...");
			}
		}
		return 1;
	}
	
	if(egyezik(cmd, "/munkahelyek"))
	{
		new gotostring[512];
		for(new g = 0; g < sizeof(MunkahelyPos); g++)
		{
			if(g == 0)
				Format(gotostring, "%s", MunkahelyNev[0][0]);
			else
				Format(gotostring, "%s\n%s", gotostring, MunkahelyNev[g][0]);
		}
		ShowPlayerDialog(playerid, DIALOG_MUNKAHELYEK, DIALOG_STYLE_LIST, "Navigációs rendszer", gotostring, "Beállít", "Mégse");
		Hazbanvan[playerid] = 0;
		return 1;
	}

	if(egyezik(cmd, "/tele"))
	{
		if(!Admin(playerid, 1)) return HibasParancs(playerid, true);
		if(!IsAdminSzolis(playerid)) return Msg(playerid, "Ezt a parancsot csak AdminSzolgálatban használhatod!", COLOR_ADMIN);
		
		new gotostring[512];
		for(new g = 0; g < sizeof(GPSPos); g++)
		{
			if(g == 0)
				Format(gotostring, "%s", GPSNev[0][0]);
			else
				Format(gotostring, "%s\n%s", gotostring, GPSNev[g][0]);
		}
		ShowPlayerDialog(playerid, DIALOG_GOTO, DIALOG_STYLE_LIST, "Admin Teleportálás", gotostring, "Teleport!", "Mégse");
		Hazbanvan[playerid] = 0;
		return 1;
	}

	if(egyezik(cmd, "/ajelszó") || egyezik(cmd, "/ajelszo"))
	{
		if(AdminEllenorzes[playerid][0] == 0) return HibasParancs(playerid);
		AdminJelszo(playerid);
		return 1;
	}
	
	if(egyezik(cmd, "/impresszum") || egyezik(cmd, "/credits"))
	{
		new credits[512];
		
		credits = "Név\tBeosztás\n";
		strcat(credits, "Ricardo Mardel\tVezetõ Fejlesztõ\n");
		strcat(credits, "Steve Mardel\tSegédFejlesztõ\n");
		strcat(credits, "Brian Salvadore\tSegédFejlesztõ\n");
		strcat(credits, "Ricardo Alvarez\tSegédFejlesztõ\n");
		strcat(credits, "Laszl0w\tBiztonsági fejlesztõ\n");
		strcat(credits, "Slayno\tBiztonsági fejlesztõ\n");
		strcat(credits, "Erik\tTeszter\n");
		
		PlayTarhelySound(playerid, "MissionCompleted.mp3");
		ShowPlayerDialog(playerid, DIALOG_NINCS, DIALOG_STYLE_TABLIST_HEADERS, "Szerver fejlesztésében közremûködtek", credits, "Bezár", "");
		return 1;
	}
	
	if(egyezik(cmd, "/adminelvesz"))
	{
		if(!Admin(playerid, 1)) return HibasParancs(playerid, true);
		if(AdminElvesz(playerid))
		{
			Msg(playerid, "Sajnáljuk, hogy így döntöttél. Ne lepõdj meg, a szerver kickel a biztonság érdekében!");
			KickEx(playerid);
		}
		return 1;
	}

	if(egyezik(cmd, "/adminálnév") || egyezik(cmd, "/adminalnev"))
	{
		if(!Admin(playerid, 2)) return HibasParancs(playerid, true);
		
		if(params < 1) return Msg(playerid, "Használat: /adminálnév [Be / Ki / Szerkeszt]", COLOR_ADMIN);
		
		if(egyezik(param[1], "ki"))
		{
			PlayerInfo[playerid][pAdminAlnevBe] = 0;
			Msg(playerid, "Adminálnév kikapcsolva!", COLOR_ADMIN);
		}
		else if(egyezik(param[1], "be"))
		{
			PlayerInfo[playerid][pAdminAlnevBe] = 1;
			Msg(playerid, "Adminálnév bekapcsolva!", COLOR_ADMIN);
		}
		else if(egyezik(param[1], "szerkeszt"))
		{
			if(params < 2) return Msg(playerid, "Használat: /adminálnév szerkeszt [Álnév]", COLOR_ADMIN);
			
			strtok(cmdtext, idx);
			new length = strlen(cmdtext);
			while ((idx < length) && (cmdtext[idx] <= ' '))
			{
				idx++;
			}
			new offset = idx;
			new result[64];
			while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
			{
				result[idx - offset] = cmdtext[idx];
				idx++;
			}
			result[idx - offset] = EOS;
			
			if(strlen(result) > MAX_PLAYER_NAME)
			{
				SendFormatMessage(playerid, COLOR_GRAD1, "Maximum %d karakter!", MAX_PLAYER_NAME);
				return 1;
			}
			
			//if(!IsValidNameFromString(result) OR !EngedelyezettKarakterek(result) OR VanBenneSzam(result)) return Msg(playerid, "Ez nem RP-s név!");
			if(!EngedelyezettKarakterek(result)) return Msg(playerid, "Hibás karakterek az adminálnevedben!", COLOR_ADMIN);
			
			strmid(PlayerInfo[playerid][pAdminAlnev], result, 0, strlen(result), 25);
			format(string, sizeof(string), "Az új AdminÁlneved mostantól %s!", result);
			Msg(playerid, string, COLOR_ADMIN);
		}
		return 1;
	}
	
    if(egyezik(cmd, "/aranks"))
	{
		if(!Admin(playerid, 1)) return HibasParancs(playerid, true);

		if(params != 1) return Msg(playerid, "/aranks [FRAKCIÓ ID]");

		new leader;

		leader = strval(param[1]) - 1;

		if(leader < 0 || leader >= sizeof(Szervezetneve))// || (leader+1) == LMUNKA_HITMAN)
			return Msg(playerid, "Nincs ilyen szervezet!");

		Msg(playerid, ValasztoVonal(Szervezetneve[leader][0]));
		PlayerForeach(x)
		{
			if(!IsValidPlayerID(x) || IsPlayerNPC(x) || PlayerInfo[x][pMember] != (leader+1)) continue;
			MsgFormat(playerid, "[%d]%s - %s (%d)", x, PlayerName(x), GetPlayerRangNev(x), PlayerInfo[x][pRank]);
		}
		
		Msg(playerid, ValasztoVonal(Szervezetneve[leader][0]));
		return 1;
	}
	
	if(egyezik(cmd, "/checkvá") || egyezik(cmd, "/checkva"))
	{
	    if(!Admin(playerid, FOADMIN)) return HibasParancs(playerid, true);
	    if(params < 1) return Msg(playerid, "/checkvá [JátékosID/NévRészlet]");
	    new jatekos = ReturnUser(param[1]);
		if(jatekos == INVALID_PLAYER_ID) return 1;
	    SendFormatMessage(playerid,COLOR_LIGHTGREEN, "(%s) %s %d alkalommal válaszolt valakinek!", AdminSzint(jatekos), PlayerName(jatekos), PlayerInfo[jatekos][pVA]);
		return 1;
	}
	
	if(egyezik(cmd, "/válasz") || egyezik(cmd, "/valasz") || egyezik(cmd, "/vsz") || egyezik(cmd, "/vá"))
	{
		if(!Admin(playerid, 1) && !IsAS(playerid)) return HibasParancs(playerid, true);
		if(params < 2) return Msg(playerid, "/válasz [JátékosID/NévRészlet] [üzenet]", COLOR_ADMIN);

		new player = ReturnUser(strtok(cmdtext, idx));
		if(player == INVALID_PLAYER_ID) return Msg(playerid, "Nincs ilyen játékos!");
		if(IsPlayerNPC(player)/* && !IsFejleszto(playerid)*/) return Msg(playerid, "Hagyd békén az NPC-t!", COLOR_ADMIN);
		if(Admin(player, 1) && !IsFejleszto(playerid))	return Msg(playerid, "Adminnak miért akarsz válaszolni?", COLOR_ADMIN);

		new length = strlen(cmdtext);
		while ((idx < length) && (cmdtext[idx] <= ' ')) { idx++; }
		new offset = idx;
		new result[128];
		while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
		{
			result[idx - offset] = cmdtext[idx];
			idx++;
		}
		result[idx - offset] = EOS;
		
		if(playerid == player) return Msg(playerid, "Magadnak ne válaszolj már..", COLOR_ADMIN);

		if(!strlen(result)) return Msg(playerid, "/válasz [JátékosID/NévRészlet] [üzenet]", COLOR_ADMIN);

        SzovegEllenorzes(playerid, result, "/vá");
		
		SendFormatMessage(player, COLOR_LIGHTGREEN, "(%s) %s: %s", AdminSzint(playerid), AdminName(playerid), (result));
		ReportElkuldve[player] = false;
		
		Format(tmp, "{%s}%s válaszolt neki: %s | Üzenet: %s", COLOR_SEEBLUE, AdminName(playerid), PlayerName(player), (result));		
		
		PlayerForeach(x)
		{
			if(IsAS(playerid) AND Admin(x, 1))
			{
				SendClientMessage(x, COLOR_YELLOW, tmp)
			}
			else if(Admin(playerid, 1) AND Admin(x, 1))			
			{
				if(PlayerInfo[x][pAdmin] >= PlayerInfo[playerid][pAdmin])
					SendClientMessage(x, COLOR_YELLOW, tmp)
			}
		}
		
		PlayerInfo[playerid][pVA] ++;
		return 1;
	}
	if(egyezik(cmd, "/jail"))
	{
		if(!Admin(playerid, 1)) return HibasParancs(playerid, true);
		if(params < 4) 
		{
			Msg(playerid, "/jail [JátékosID/NévRészlet] [börtön] [Idõ(perc)] [Oka]", COLOR_ADMIN);
			Msg(playerid, "Börtöntípus: [LSPD / Admin / Admin2]");
			return 1;
		}
		
		new player = ReturnUser(param[1]);
		new ido = strval(param[3]);
		strtok(cmdtext, idx); strtok(cmdtext, idx); strtok(cmdtext, idx);

		new length = strlen(cmdtext);
		while ((idx < length) && (cmdtext[idx] <= ' '))
		{
			idx++;
		}
		new offset = idx;
		new result[128];
		while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
		{
			result[idx - offset] = cmdtext[idx];
			idx++;
		}
		result[idx - offset] = EOS;
		
		//if(playerid == player && !Admin(playerid, FOADMIN)) return Msg(playerid, "Saját magadat nem szedheted ki!");
		
		if(strlen(result) > 80) return Msg(playerid, "Maximum 80 karakter hossz! Fogalmazz röviden!");
		if(ido > 240 && !IsRicardo(playerid)) return Msg(playerid, "A jail idõ maximum 2 óra azaz 240 perc lehet!");
		
		if(player == INVALID_PLAYER_ID) return Msg(playerid, "Nincs ilyen játékos!");
		if(IsTulaj(player) && !IsTulaj(playerid)) return Msg(playerid, RICARDOSZOVEG);
		if(RicardoVedelem(playerid, giveplayerid)) return 1;
		if(IsPlayerNPC(player)) return Msg(playerid, "Hagyd békén az NPC-t!");
		if(egyezik(param[2], "LSPD"))
		{
			//SendFormatMessage(player, COLOR_LIGHTRED, "Egy Adminisztrátor bezárt a börtönbe - Oka: %s", result);
			/*SendClientMessage(player, COLOR_LIGHTBLUE, "{15FF00}================== {0059FF}[ LSPD Jail ]{15FF00}================== ");
			SendFormatMessage(player,COLOR_YELLOW, "Oka: %s",result);
			SendFormatMessage(player,COLOR_YELLOW, "Jailt Adta: %s",PlayerName(playerid));
			SendFormatMessage(player,COLOR_YELLOW, "Idõ: %d perc",ido);
			SendClientMessage(player, COLOR_LIGHTBLUE, "{15FF00}================== {0059FF}[ LSPD Jail ]{15FF00}================== ");*/
			strmid(PlayerInfo[player][pJailtAdta], PlayerName(playerid), 0, strlen(PlayerName(playerid)), 32);
			Msg(playerid, "Bezártad a játékost a börtönbe!");
			Format(string, "%s bezárta %s-t (LSPD) Idõ: %d perc | Oka: %s", AdminName(playerid), PlayerName(player), ido, result);
			ABroadCast(COLOR_LIGHTRED, string, 1);
			Jail(player, "set", ido*60, "LSPD", EkezetMentes(result));
			return 1;
		}
		else if(egyezik(param[2], "admin"))
		{
			/*SendClientMessage(player, COLOR_LIGHTBLUE, "{15FF00}================== {0059FF}[ AdminJail ]{15FF00}================== ");
			SendFormatMessage(player,COLOR_YELLOW, "Oka: %s",result);
			SendFormatMessage(player,COLOR_YELLOW, "Jailt Adta: %s",PlayerName(playerid));
			SendFormatMessage(player,COLOR_YELLOW, "Idõ: %d p",ido);
			SendClientMessage(player, COLOR_LIGHTBLUE, "{15FF00}================== {0059FF}[ AdminJail ]{15FF00}================== ");*/
			strmid(PlayerInfo[player][pJailtAdta], PlayerName(playerid), 0, strlen(PlayerName(playerid)), 32);
			Msg(playerid, "Bezártad a játékost a börtönbe!");
			/*Format(string, "%s bezárta %s-t (Admin) Idõ: %dp | Oka: %s", AdminName(playerid), PlayerName(player), ido, result);
			ABroadCast(COLOR_LIGHTRED, string, 1); */
			Jail(player, "set", ido*60, "ajail", EkezetMentes(result));
			if(ido >= 1)
			{
				PlayerTextFormat(playerid, "(%s) %s %d perc AdminJailt adott %s-nak/nek", AdminSzint(playerid), PlayerName(playerid), ido, PlayerName(player));
				AdminCMD(PlayerText[playerid]);
				PlayerTextFormat(playerid, "Oka: %s", result);
				AdminCMD(PlayerText[playerid]);
			}
			else
			{
				PlayerTextFormat(playerid, "(%s) %s kiengedte %s-t az AdminJailbõl!", AdminSzint(playerid), AdminName(playerid), PlayerName(player));
				AdminCMD(PlayerText[playerid]);
			}
			return 1;
		}
		else if(egyezik(param[2], "admin2"))
		{
			/*SendClientMessage(player, COLOR_LIGHTBLUE, "{15FF00}================== {0059FF}[ AdminJail ]{15FF00}================== ");
			SendFormatMessage(player,COLOR_YELLOW, "Oka: %s",result);
			SendFormatMessage(player,COLOR_YELLOW, "Jailt Adta: %s",PlayerName(playerid));
			SendFormatMessage(player,COLOR_YELLOW, "Idõ: %d p",ido);
			SendClientMessage(player, COLOR_LIGHTBLUE, "{15FF00}================== {0059FF}[ AdminJail ]{15FF00}================== ");*/
			strmid(PlayerInfo[player][pJailtAdta], PlayerName(playerid), 0, strlen(PlayerName(playerid)), 32);
			Msg(playerid, "Bezártad a játékost a börtönbe!");
			/*Format(string, "%s bezárta %s-t (admin 2) Idõ: %dp | Oka: %s", AdminName(playerid), PlayerName(player), ido, result);
			ABroadCast(COLOR_LIGHTRED, string, 1); */
			Jail(player, "set", ido*60, "ajail2", EkezetMentes(result));
			if(ido >= 1)
			{
				
				SendFormatMessageToAll(COLOR_LIGHTBLUE, "(%s) %s %d perc ÍROGATÓS AdminJailt adott %s-nak/nek", AdminSzint(playerid), PlayerName(playerid), ido, PlayerName(player));
				SendFormatMessageToAll(COLOR_LIGHTBLUE, "Oka: %s", result);
			}
			else
			{
				SendFormatMessageToAll(COLOR_LIGHTBLUE, "(%s) %s kiengedte %s-t az írogatós AdminJailbõl!", AdminSzint(playerid), AdminName(playerid), PlayerName(player));
			}
			return 1;
		}

		return 1;
	}

	if(egyezik(cmd, "/set"))
	{
		if(!Admin(playerid, 1)) return HibasParancs(playerid, true);
		if(params < 4) return Msg(playerid, "/set [Jármû / Játékos] [Int / VW] [Szám] [PlayerID / Rendszám]");
		if(egyezik(param[1], "játékos") || egyezik(param[1], "jatekos"))
		{
			new player = ReturnUser(param[4]);
			if(IsPlayerNPC(player)) return Msg(playerid, "Hagyd békén az NPC-t!");
			if(player == INVALID_PLAYER_ID) return Msg(playerid, "Nincs ilyen játékos");
			if(egyezik(param[2], "inti") || egyezik(param[2], "int"))
			{
				new inti = strval(param[3]);
				if(inti < 0) return 1;
				SetPlayerInterior(player, inti);
				ABroadCastFormat(COLOR_LIGHTRED, 1, "%s átállította az Interiorját(%d) neki: %s", AdminName(playerid), inti, PlayerName(player));
			}
			if(egyezik(param[2], "vw"))
			{
				new vw = strval(param[3]);
				if(vw < 0) return 1;
				SetPlayerVirtualWorld(player, vw);
				ABroadCastFormat(COLOR_LIGHTRED, 1, "%s átállította a VWjét(%d) neki: %s", AdminName(playerid), vw, PlayerName(player));
			}
		}
		if(egyezik(param[1], "Jármû") || egyezik(param[1], "Jarmu"))
		{
			new kocsi = strval(param[4]);
			if(!IsVehicleConnected(kocsi)) return Msg(playerid, "Nincs ilyen jármû");
			if(egyezik(param[2], "inti") || egyezik(param[2], "int"))
			{
				new inti = strval(param[3]);
				if(inti < 0) return 1;
				SetVehicleInterior(kocsi, inti);
				ABroadCastFormat(COLOR_LIGHTRED, 1, "%s átállította %d rendszámú jármû Interiorját erre: %d", AdminName(playerid), kocsi, inti);
			}
			if(egyezik(param[2], "vw"))
			{
				new vw = strval(param[3]);
				if(vw < 0) return 1;
				SetVehicleVW(kocsi, vw);
				ABroadCastFormat(COLOR_LIGHTRED, 1, "%s átállította %d rendszámú jármû VWjét erre: %d", AdminName(playerid), kocsi, vw);
			}
			if(egyezik(param[2], "diesel"))
			{
				new vw = strval(param[3]);
				if(vw < 0) return 1;
				Gas[kocsi][UZEMANYAGTIPUS_DIESEL] = vw;
				Msg(playerid, "Diesel átírva!");
			}
			if(egyezik(param[2], "benzin"))
			{
				new vw = strval(param[3]);
				if(vw < 0) return 1;
				Gas[kocsi][UZEMANYAGTIPUS_BENZIN] = vw;
				Msg(playerid, "Benzin átírva!");
			}
		}
		return 1;
	}

	if(egyezik(cmd, "/auncuff"))
	{
		if(!Admin(playerid, 4)) return HibasParancs(playerid, true);
		if(params < 1) return Msg(playerid, "/auncuff [JátékosID/NévRészlet]");
		new player = ReturnUser(param[1]);
		if(player == INVALID_PLAYER_ID) return Msg(playerid, "Nincs ilyen játékos.");
		if(PlayerCuffed[player] == 0) return Msg(playerid, "A játékos nincs megbilincselve.");
		Bilincs(player, 0);
		ABroadCastFormat(COLOR_LIGHTRED, 1, "%s levette a bilincset róla: %s", AdminName(playerid), PlayerName(player));
		GameTextForPlayer(player, "~w~~n~~n~~n~~n~~n~~n~~n~~n~~n~Az admin levette a bilincsed!", 3000, 3);
		return 1;
	}
	
	if(egyezik(cmd, "/aunvisz"))
	{
		if(!Admin(playerid, 3)) return HibasParancs(playerid, true);
		if(params < 1) return Msg(playerid, "/aunvisz [JátékosID/NévRészlet]");
		new player = ReturnUser(param[1]);
		if(player == INVALID_PLAYER_ID) return Msg(playerid, "Nincs ilyen játékos.");
		if(Visz[player] == 0) return Msg(playerid, "A játékos nem visz senkit.");
		if(Visz[player] != NINCS)
		{
			SendClientMessage(playerid, COLOR_LIGHTBLUE, "Elengedted!");
			Visz[player] = NINCS;
			return 1;
		}
		return 1;
	}
	if(egyezik(cmd, "/jelvény") || egyezik(cmd, "/jelveny"))
	{
		if(!IsACop(playerid) && !LMT(playerid,LMUNKA_MENTO))  return Msg(playerid, "Nem vagy rendõr, vagy mentõs.");
		//if(OnDuty[playerid] < 1) return Msg(playerid, "Nem vagy szolgálatban!");
		if(params < 1) return Msg(playerid, "/Jelvény [Felmutat / Megnéz]");
		new player = ReturnUser(param[2]);
		if(egyezik(param[1], "felmutat"))
		{
			if(params < 2) return Msg(playerid, "/Jelvény Felmutat [JátékosID/NévRészlet]");
			if(player == INVALID_PLAYER_ID) return Msg(playerid, "Nincs ilyen játékos.");
			if(GetDistanceBetweenPlayers(playerid,player) > 3) return Msg(playerid, "Õ nincs a közeledben!");
			new szneve[32];
			
			if(PlayerInfo[playerid][pMember] > 0)
			{
				new szam = PlayerInfo[playerid][pMember] - 1;
				szneve = Szervezetneve[szam][0];
			}
			
			MsgFormat(playerid, "* Felmutattad a jelvényed neki: %s", PlayerName(player));
			
			new torzs[256];
			format(torzs, 256, "{"#COLOR_MSG"}Név: {FFFFFF}%s\
			\n{"#COLOR_MSG"}Szervezet: {FFFFFF}%s\
			\n{"#COLOR_MSG"}Rendfokozat: {FFFFFF}%s\n", PlayerName(playerid), szneve, GetPlayerRangNev(playerid));					
			ShowPlayerDialog(player, DIALOG_NINCS, DIALOG_STYLE_MSGBOX, "{"#COLOR_MSG"}Jelvény", torzs, "Bezárás", "");
				
			Cselekves(playerid, "felmutatta a jelvényét valakinek...");
			return 1;
		}
	}
	if(egyezik(cmd, "/szonda"))
	{
		if(params != 1) return Msg(playerid, "/szonda [JátékosID/NévRészlet]");

		new player = ReturnUser(param[1]);
		new Jatekos = playerid;

		if(player == INVALID_PLAYER_ID) return Msg(playerid, "Nincs ilyen játékos!");
		if(player == playerid) return Msg(playerid, "Magadat??");

		if(!IsACop(playerid)) return Msg(playerid, "Nem vagy rendõr!");

        if(GetDistanceBetweenPlayers(playerid,player) > 3) return Msg(playerid, "Õ nincs a közeledben!");

        if(IsACop(player)) return Msg(playerid, "Zsarut akarsz szondáztatni?");

        Szondaztat[player] = Jatekos;
		format(string, sizeof(string), "Megkérted %s-t hogy fújja meg a szondát!", PlayerName(player));
		Msg(playerid, string);
		format(string, sizeof(string), "%s megkért hogy fújd meg a szondát, ha nem fújod meg bevihet!(/fúj)", PlayerName(playerid));
		SendClientMessage(player, COLOR_LIGHTRED, string);
		Cselekves(playerid, "elõvette a szondát...");

		return 1;
	}
	if(egyezik(cmd, "/fúj") || egyezik(cmd, "/fuj"))
	{
		if(Szondaztat[playerid] == NINCS) return Msg(playerid, "Nem adtak át szondát...Mit akarsz megfújni?");
		if(Szondaztat[playerid] == INVALID_PLAYER_ID)
		{
			Msg(playerid, "Már nincs ilyen játékos");
			Szondaztat[playerid] = NINCS;
			return 1;
		}

        if(GetDistanceBetweenPlayers(playerid,Szondaztat[playerid]) > 3) return Msg(playerid, "Õ nincs a közeledben!");

		format(string, sizeof(string), "Megfújtad a szondát!");
		Msg(playerid, string);
		format(string, sizeof(string), "%s megfújta a szondát!", PlayerName(playerid));
		SendClientMessage(Szondaztat[playerid], COLOR_LIGHTRED, string);
		if(PlayerDrunk[playerid] > 3)
		{
		    Msg(Szondaztat[playerid], "Eredmény: Ittas");
		}
		else Msg(Szondaztat[playerid], "Eredmény: Józan");
		Szondaztat[playerid] = NINCS;

		return 1;
	}
	if(egyezik(cmd, "/mellény") ||egyezik(cmd, "/melleny"))
	{
		if(params != 2) return Msg(playerid, "/mellény [berak / kivesz / megnéz] [Slot (1-3)]");
		if(FloodCheck(playerid, cmd)) return 1;
        new kocsi;
        kocsi = GetClosestVehicle(playerid);
		new Float:tav = GetDistanceToVehicle(playerid, kocsi);
        new ferohely;
		ferohely= strval(param[2]);
		if(ferohely < 1 || ferohely > 3) return Msg(playerid, "Slot 1-3");
		if(tav >= 3) return Msg(playerid, "Nincs a közeledbe jármû...");
		if(egyezik(param[1], "berak"))
		{
		    new Float:armor;
			GetPlayerArmour(playerid, armor);
			new pancel;
			pancel = floatround(armor);
			if(pancel == 0) return Msg(playerid, "Nincs mellényed!");
			new x = ferohely + 16;
			if(CuccokAKocsiban[kocsi][x] != 0) return Msg(playerid, "A jármûben már van mellény!");
			if(Locked(kocsi)) return Msg(playerid, "A jármû zárva");
			if(IsABicikli(kocsi)) return Msg(playerid, "Biciklin?");
			CuccokAKocsiban[kocsi][x] = pancel;
			Msg(playerid, "Beraktál egy mellényt a jármûbe");
			Cselekves(playerid, "elrejtett egy mellényt a jármûbe...");
			SetPlayerArmour(playerid, 0.0);
			CsomagTartoMentes();
			return 1;
		}
		else if(egyezik(param[1], "kivesz"))
		{
			new x = ferohely + 16;
			if(Locked(kocsi)) return Msg(playerid, "A jármû zárva");
			if(IsABicikli(kocsi)) return Msg(playerid, "Biciklin?");
			if(CuccokAKocsiban[kocsi][x] == 0) return Msg(playerid, "A jármûben már van mellény!");
			new pancel = CuccokAKocsiban[kocsi][x];
			Msg(playerid, "Kivettél egy mellényt a jármûbõl");
			Cselekves(playerid, "kivett egy mellényt a jármûbõl...");
			SetPlayerArmour(playerid, pancel);
			CuccokAKocsiban[kocsi][x] = 0;
			CsomagTartoMentes();
			return 1;
		}
		else if(egyezik(param[1], "megnéz") || egyezik(param[1], "megnez"))
		{
			new x = ferohely + 16;
			if(Locked(kocsi)) return Msg(playerid, "A jármû zárva");
			if(IsABicikli(kocsi)) return Msg(playerid, "Biciklin?");
			if(CuccokAKocsiban[kocsi][x] == 0) return Msg(playerid, "Itt nincs mellény!");
			new pancel = CuccokAKocsiban[kocsi][x];
			SendFormatMessage(playerid, COLOR_LIGHTRED, "* Mellény állapota: %d százalék", pancel);
			Cselekves(playerid, "bele nézett a csomagtartóba.", 1);
			return 1;
		}
		else
			Msg(playerid, "/mellény [berak / kivesz / megnéz] [Slot (1-3)]");
		return 1;
	}
	if(egyezik(cmd, "/weapon"))
	{
		if(params != 2) return Msg(playerid, "/weapon [berak / kivesz / megnéz] [Slot (1-3)]");
		if(FloodCheck(playerid, cmd)) return 1;
        new kocsi;
        kocsi = GetClosestVehicle(playerid);
		new Float:tav = GetDistanceToVehicle(playerid, kocsi);
        new ferohely;
		ferohely= strval(param[2]);
		if(ferohely < 1 || ferohely > 3) return Msg(playerid, "Slot 1-3");
		if(egyezik(param[1], "berak"))
		{
		    new FegyverID;
			FegyverID = GetPlayerWeapon(playerid);
	        new FegyverTolteny;
			FegyverTolteny = GetPlayerAmmo(playerid);

		    if(tav >= 3) return Msg(playerid, "Nincs a közeledbe jármû...");
			if(IsABicikli(kocsi)) return Msg(playerid, "Biciklibel?");
			if(IsPlayerInAnyVehicle(playerid)) return Msg(playerid, "Jármûben nem...");
			if(GetJarmu(kocsi, KOCSI_CSOMAGTARTO) != 1) return Msg(playerid, "Nyisd fel a csomagtartót!");
			if(Locked(kocsi)) return SendClientMessage(playerid, COLOR_YELLOW, "Ez a kocsi zárva van!");
			if(ferohely == 1)
			{
				if(FegyverID != 0 && FegyverTolteny != 0)
				{
					if(CuccokAKocsiban[kocsi][4] != 0 && CuccokAKocsiban[kocsi][5] != 0) return Msg(playerid, "A jármûben már van fegyver!");

					CuccokAKocsiban[kocsi][4] = FegyverID;
					CuccokAKocsiban[kocsi][5] = FegyverTolteny;
					Msg(playerid, "Beraktál egy fegyvert a jármûbe");
					Cselekves(playerid, "elrejtett egy fegyvert a jármûbe...");
					FegyverElvesz(playerid, FegyverID);
					CsomagTartoMentes();
				}
				else
				{
					Msg(playerid, "Nincs fegyver nálad");
				}
			}
			else if(ferohely == 2)
			{
				if(FegyverID != 0 && FegyverTolteny != 0)
				{
					if(CuccokAKocsiban[kocsi][6] != 0 && CuccokAKocsiban[kocsi][7] != 0) return Msg(playerid, "A jármûben már van fegyver!");

					CuccokAKocsiban[kocsi][6] = FegyverID;
					CuccokAKocsiban[kocsi][7] = FegyverTolteny;
					Msg(playerid, "Beraktál egy fegyvert a jármûbe");
					Cselekves(playerid, "elrejtett egy fegyvert a jármûbe...");
					FegyverElvesz(playerid, FegyverID);
					CsomagTartoMentes();
				}
				else
				{
					Msg(playerid, "Nincs fegyver nálad");
				}
			}
			else if(ferohely == 3)
			{
				if(FegyverID != 0 && FegyverTolteny != 0)
				{
					if(CuccokAKocsiban[kocsi][8] != 0 && CuccokAKocsiban[kocsi][9] != 0) return Msg(playerid, "A jármûben már van fegyver!");

					CuccokAKocsiban[kocsi][8] = FegyverID;
					CuccokAKocsiban[kocsi][9] = FegyverTolteny;
					Msg(playerid, "Beraktál egy fegyvert a jármûbe");
					Cselekves(playerid, "elrejtett egy fegyvert a jármûbe...");
					FegyverElvesz(playerid, FegyverID);
					CsomagTartoMentes();
				}
				else
				{
					Msg(playerid, "Nincs fegyver nálad");
				}
			}
			if(FegyverID == 16 || FegyverID == 26 || FegyverID == 27 || FegyverID == 34 || FegyverID == 35 || FegyverID == 36)
			{
				new uzenet[200];
				Format(uzenet, "%s %s-t(%d töltény) rakott egy jármûbe(ID: %d)", PlayerName(playerid), aWeaponNames[FegyverID], FegyverTolteny, kocsi);
				ABroadCast(COLOR_LIGHTRED, uzenet, 1);
			}
			return 1;
		}
		else if(egyezik(param[1], "kivesz"))
		{
			if(tav >= 3) return Msg(playerid, "Nincs a közeledbe jármû...");
			if(IsABicikli(kocsi)) return Msg(playerid, "Biciklibel?");
			if(IsPlayerInAnyVehicle(playerid)) return Msg(playerid, "Jármûben nem...");
			if(GetJarmu(kocsi, KOCSI_CSOMAGTARTO) != 1) return Msg(playerid, "Nyisd fel a csomagtartót!");
			if(Locked(kocsi)) return SendClientMessage(playerid, COLOR_YELLOW, "Ez a kocsi zárva van!");

			if(ferohely == 1)
			{
				if(CuccokAKocsiban[kocsi][4] != 0 && CuccokAKocsiban[kocsi][5] != 0)
				{
					new FegyverID;
					FegyverID = CuccokAKocsiban[kocsi][4];
					new FegyverTolteny;
					FegyverTolteny = CuccokAKocsiban[kocsi][5];
					Msg(playerid, "Kivettél egy fegyvert a jármûbõl");
					Cselekves(playerid, "kivett egy fegyvert a jármûbõl...");
					GiveWeapon(playerid, FegyverID, FegyverTolteny);
					CuccokAKocsiban[kocsi][4] = 0;
					CuccokAKocsiban[kocsi][5] = 0;
					CsomagTartoMentes();
					return 1;
				}
				else
				{
					Msg(playerid, "Itt nincs fegyver");
				}
			}
			else if(ferohely == 2)
			{
				if(CuccokAKocsiban[kocsi][6] != 0 && CuccokAKocsiban[kocsi][7] != 0)
				{
					new FegyverID;
					FegyverID = CuccokAKocsiban[kocsi][6];
					new FegyverTolteny;
					FegyverTolteny = CuccokAKocsiban[kocsi][7];
					Msg(playerid, "Kivettél egy fegyvert a jármûbõl");
					Cselekves(playerid, "kivett egy fegyvert a jármûbõl...");
					GiveWeapon(playerid, FegyverID, FegyverTolteny);
					CuccokAKocsiban[kocsi][6] = 0;
					CuccokAKocsiban[kocsi][7] = 0;
					CsomagTartoMentes();
					return 1;
				}
				else
				{
					Msg(playerid, "Itt nincs fegyver");
				}
			}
			else if(ferohely == 3)
			{
				if(CuccokAKocsiban[kocsi][8] != 0 && CuccokAKocsiban[kocsi][9] != 0)
				{
					new FegyverID;
					FegyverID = CuccokAKocsiban[kocsi][8];
					new FegyverTolteny;
					FegyverTolteny = CuccokAKocsiban[kocsi][9];
					Msg(playerid, "Kivettél egy fegyvert a jármûbõl");
					Cselekves(playerid, "kivett egy fegyvert a jármûbõl...");
					GiveWeapon(playerid, FegyverID, FegyverTolteny);
					CuccokAKocsiban[kocsi][8] = 0;
					CuccokAKocsiban[kocsi][9] = 0;
					CsomagTartoMentes();
					return 1;
				}
				else
				{
					Msg(playerid, "Itt nincs fegyver");
				}
			}
		}
		else if(egyezik(param[1], "megnéz") || egyezik(param[1], "megnez"))
		{
				if(tav >= 3) return Msg(playerid, "Nincs a közeledbe jármû...");
				if(IsABicikli(kocsi)) return Msg(playerid, "Biciklibel?");
				if(IsPlayerInAnyVehicle(playerid)) return Msg(playerid, "Jármûben nem...");
				if(GetJarmu(kocsi, KOCSI_CSOMAGTARTO) != 1) return Msg(playerid, "Nyisd fel a csomagtartót!");
				if(Locked(kocsi)) return SendClientMessage(playerid, COLOR_YELLOW, "Ez a kocsi zárva van!");
				if(ferohely == 1)
				{
					if(CuccokAKocsiban[kocsi][4] != 0 && CuccokAKocsiban[kocsi][5] != 0)
					{
						new FegyverID;
						FegyverID = CuccokAKocsiban[kocsi][4];
						new FegyverTolteny;
						FegyverTolteny = CuccokAKocsiban[kocsi][5];
						SendFormatMessage(playerid, COLOR_LIGHTRED, "* Fegyver Név: %s, Töltény: %d", aWeaponNames[FegyverID], FegyverTolteny);
						Cselekves(playerid, "bele nézett a csomagtartóba.", 1);
						return 1;
					}
					else
					{
						Msg(playerid, "Itt nincs fegyver");
					}
				}
				else if(ferohely == 2)
				{
					if(CuccokAKocsiban[kocsi][6] != 0 && CuccokAKocsiban[kocsi][7] != 0)
					{
						new FegyverID;
						FegyverID = CuccokAKocsiban[kocsi][6];
						new FegyverTolteny;
						FegyverTolteny = CuccokAKocsiban[kocsi][7];
						SendFormatMessage(playerid, COLOR_LIGHTRED, "* Fegyver Név: %s, Töltény: %d", aWeaponNames[FegyverID], FegyverTolteny);
						Cselekves(playerid, "bele nézett a csomagtartóba.", 1);
						return 1;
					}
					else
					{
						Msg(playerid, "Itt nincs fegyver");
					}
				}
				else if(ferohely == 3)
				{
					if(CuccokAKocsiban[kocsi][8] != 0 && CuccokAKocsiban[kocsi][9] != 0)
					{
						new FegyverID;
						FegyverID = CuccokAKocsiban[kocsi][8];
						new FegyverTolteny;
						FegyverTolteny = CuccokAKocsiban[kocsi][9];
						SendFormatMessage(playerid, COLOR_LIGHTRED, "* Fegyver Név: %s, Töltény: %d", aWeaponNames[FegyverID], FegyverTolteny);
						Cselekves(playerid, "bele nézett a csomagtartóba.", 1);
						return 1;
					}
					else
					{
						Msg(playerid, "Itt nincs fegyver");
					}
				}
		}
		else
			Msg(playerid, "/weapon [berak / kivesz / megnéz] [Slot (1-3)]");

		return 1;
	}
	if(egyezik(cmd, "/csere"))
	{
		if(params < 1) return Msg(playerid, "/Csere [Ház, Jármû, Biznisz]");
		if(FloodCheck(playerid, cmd)) return 1;
		if(egyezik(param[1], "elfogad"))
		{
			if(MitCsere[playerid] != NINCS)
			{
				if(Csere[playerid] == INVALID_PLAYER_ID)
				{
					Msg(playerid, "A játékos már nem online.");
					Csere[playerid] = NINCS;
					MitCsere[playerid] = NINCS;
				}
				new player = Csere[playerid];
				if(MitCsere[playerid] == 1)
				{
					if(PlayerInfo[playerid][pPcarkey] == NINCS)
					{
						MitCsere[playerid] = NINCS;
						Csere[playerid] = NINCS;
						return 1;
					}
					if(PlayerInfo[Csere[playerid]][pPcarkey] == NINCS)
					{
						MitCsere[playerid] = NINCS;
						Csere[playerid] = NINCS;
						return 1;
					}
					new nev[MAX_PLAYER_NAME], nev2[MAX_PLAYER_NAME];
					Format(nev, "%s", PlayerName(playerid, true));
					Format(nev2, "%s", PlayerName(player, true));
					strmid(CarInfo[PlayerInfo[player][pPcarkey]][cOwner], nev, 0, strlen(nev), 25);
					strmid(CarInfo[PlayerInfo[playerid][pPcarkey]][cOwner], nev2, 0, strlen(nev2), 25);
					CarUpdate(PlayerInfo[player][pPcarkey], CAR_Owner);
					CarUpdate(PlayerInfo[playerid][pPcarkey], CAR_Owner);

					CorrectPlayerDatas(playerid);
					CorrectPlayerDatas(player);

					SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Elcserélted a jármûved vele: %s", PlayerName(player));
					SendFormatMessage(player, COLOR_LIGHTGREEN, "* Elcserélted a jármûved vele: %s", PlayerName(playerid));
					Msg(playerid, "$100 adó levonva!");
					Msg(player, "$100 adó levonva!");
					
					//BizPenz(BIZ_IMPORT, 100, player);
					//BizPenz(BIZ_IMPORT, 100, playerid);
					MitCsere[playerid] = NINCS;
					Csere[playerid] = NINCS;
				}
				if(MitCsere[playerid] == 2)
				{
					if(PlayerInfo[playerid][pPcarkey2] == NINCS)
					{
						MitCsere[playerid] = NINCS;
						Csere[playerid] = NINCS;
						return 1;
					}
					if(PlayerInfo[Csere[playerid]][pPcarkey2] == NINCS)
					{
						MitCsere[playerid] = NINCS;
						Csere[playerid] = NINCS;
						return 1;
					}
					new nev[MAX_PLAYER_NAME], nev2[MAX_PLAYER_NAME];
					Format(nev, "%s", PlayerName(playerid, true));
					Format(nev2, "%s", PlayerName(player, true));
					strmid(CarInfo[PlayerInfo[player][pPcarkey2]][cOwner], nev, 0, strlen(nev), 25);
					strmid(CarInfo[PlayerInfo[playerid][pPcarkey2]][cOwner], nev2, 0, strlen(nev2), 25);
					CarUpdate(PlayerInfo[player][pPcarkey2], CAR_Owner);
					CarUpdate(PlayerInfo[playerid][pPcarkey2], CAR_Owner);

					CorrectPlayerDatas(playerid);
					CorrectPlayerDatas(player);

					SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Elcserélted a jármûved vele: %s", PlayerName(player));
					SendFormatMessage(player, COLOR_LIGHTGREEN, "* Elcserélted a jármûved vele: %s", PlayerName(playerid));
					Msg(playerid, "$100 adó levonva!");
					Msg(player, "$100 adó levonva!");
					
					//BizPenz(BIZ_IMPORT, 100, player);
					//BizPenz(BIZ_IMPORT, 100, playerid);
					MitCsere[playerid] = NINCS;
					Csere[playerid] = NINCS;
				}
				if(MitCsere[playerid] == 3)
				{
					if(PlayerInfo[playerid][pPhousekey] == NINCS)
					{
						MitCsere[playerid] = NINCS;
						Csere[playerid] = NINCS;
						return 1;
					}
					if(PlayerInfo[Csere[playerid]][pPhousekey] == NINCS)
					{
						MitCsere[playerid] = NINCS;
						Csere[playerid] = NINCS;
						return 1;
					}
					new nev[MAX_PLAYER_NAME], nev2[MAX_PLAYER_NAME];
					Format(nev, "%s", PlayerName(playerid, true));
					Format(nev2, "%s", PlayerName(player, true));
					strmid(HouseInfo[PlayerInfo[player][pPhousekey]][hOwner], nev, 0, strlen(nev), MAX_PLAYER_NAME);
					strmid(HouseInfo[PlayerInfo[playerid][pPhousekey]][hOwner], nev2, 0, strlen(nev2), MAX_PLAYER_NAME);
					HazUpdate(PlayerInfo[player][pPhousekey], HAZ_Owner);
					HazUpdate(PlayerInfo[playerid][pPhousekey], HAZ_Owner);

					CorrectPlayerDatas(playerid);
					CorrectPlayerDatas(player);

					SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Elcserélted a házad vele: %s", PlayerName(player));
					SendFormatMessage(player, COLOR_LIGHTGREEN, "* Elcserélted a házad vele: %s", PlayerName(playerid));
					Msg(playerid, "$1000 adó levonva!");
					Msg(player, "$1000 adó levonva!");
					
					//BizPenz(BIZ_HAZ, 1000, player);
					//BizPenz(BIZ_HAZ, 1000, playerid);
					MitCsere[playerid] = NINCS;
					Csere[playerid] = NINCS;
				}
				if(MitCsere[playerid] == 4)
				{
					if(PlayerInfo[playerid][pPhousekey2] == NINCS)
					{
						MitCsere[playerid] = NINCS;
						Csere[playerid] = NINCS;
						return 1;
					}
					if(PlayerInfo[Csere[playerid]][pPhousekey2] == NINCS)
					{
						MitCsere[playerid] = NINCS;
						Csere[playerid] = NINCS;
						return 1;
					}
					new nev[MAX_PLAYER_NAME], nev2[MAX_PLAYER_NAME];
					Format(nev, "%s", PlayerName(playerid, true));
					Format(nev2, "%s", PlayerName(player, true));
					strmid(HouseInfo[PlayerInfo[player][pPhousekey2]][hOwner], nev, 0, strlen(nev), MAX_PLAYER_NAME);
					strmid(HouseInfo[PlayerInfo[playerid][pPhousekey2]][hOwner], nev2, 0, strlen(nev2), MAX_PLAYER_NAME);
					HazUpdate(PlayerInfo[player][pPhousekey2], HAZ_Owner);
					HazUpdate(PlayerInfo[playerid][pPhousekey2], HAZ_Owner);

					CorrectPlayerDatas(playerid);
					CorrectPlayerDatas(player);

					SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Elcserélted a házad vele: %s", PlayerName(player));
					SendFormatMessage(player, COLOR_LIGHTGREEN, "* Elcserélted a házad vele: %s", PlayerName(playerid));
					Msg(playerid, "$1000 adó levonva!");
					Msg(player, "$1000 adó levonva!");

					//BizPenz(BIZ_HAZ, 1000, player);
					//BizPenz(BIZ_HAZ, 1000, playerid);
					MitCsere[playerid] = NINCS;
					Csere[playerid] = NINCS;
				}
				if(MitCsere[playerid] == 5)
				{
					if(PlayerInfo[playerid][pPbiskey] == NINCS)
					{
						MitCsere[playerid] = NINCS;
						Csere[playerid] = NINCS;
						return 1;
					}
					if(PlayerInfo[Csere[playerid]][pPbiskey] == NINCS)
					{
						MitCsere[playerid] = NINCS;
						Csere[playerid] = NINCS;
						return 1;
					}
					new nev[MAX_PLAYER_NAME], nev2[MAX_PLAYER_NAME];
					Format(nev, "%s", PlayerName(playerid, true));
					Format(nev2, "%s", PlayerName(player, true));
					BizUpdate(PlayerInfo[player][pPbiskey], BIZ_Owner);
					BizUpdate(PlayerInfo[playerid][pPbiskey], BIZ_Owner);

					CorrectPlayerDatas(playerid);
					CorrectPlayerDatas(player);

					SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Elcserélted a bizniszed vele: %s", PlayerName(player));
					SendFormatMessage(player, COLOR_LIGHTGREEN, "* Elcserélted a bizniszed vele: %s", PlayerName(playerid));
					Msg(playerid, "$1000 adó levonva!");
					Msg(player, "$1000 adó levonva!");
					
					//BizPenz(BIZ_HAZ, 1000, player);
					//BizPenz(BIZ_HAZ, 1000, playerid);
					MitCsere[playerid] = NINCS;
					Csere[playerid] = NINCS;
				}
				Cselekves(playerid, "elcserélt valamit", 1);
			}
			else return Msg(playerid, "Nem ajánlottak cserét.");
		}
		if(egyezik(param[1], "Jármû") || egyezik(param[1], "Jarmu"))
		{
			if(PlayerInfo[playerid][pPcarkey2] != NINCS)
			{
				if(params < 2) return Msg(playerid, "/Csere Jármû [1/2]");
			}
			new melyik = strval(param[2]);
			new player;
			player = GetClosestPlayer(playerid);

			if(GetDistanceBetweenPlayers(playerid, player) > 2) return Msg(playerid, "A közeledben nincs senki!");

			if(IsPlayerNPC(player)) return Msg(playerid, "NPC...");

			if(!Logged(player)) return Msg(playerid, "Nincs belépve!");

			if(PlayerInfo[playerid][pPcarkey] == NINCS) return Msg(playerid, "Neked nincs jármûved.");
			if(PlayerInfo[player][pPcarkey] == NINCS) return Msg(playerid, "Neki nincs jármûve.");
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Elszeretnéd cserélni vele(%s) a jármûveteket.", PlayerName(player));
			SendFormatMessage(player, COLOR_LIGHTGREEN, "* %s elszeretné cserélni a jármûveteket. (Elfogadás:(/csere elfogad))", PlayerName(playerid));
			Cselekves(playerid, "elszeretné cserélni a jármûvét valakivel.", 1);
			Csere[player] = playerid;
			if(PlayerInfo[playerid][pPcarkey2] != NINCS)
			{
				if(melyik < 1 || melyik > 2) return 1;
				if(melyik == 1)
					MitCsere[player] = 1;
				else
					MitCsere[player] = 2;

				return 1;
			}
			MitCsere[player] = 1;
		}
		if(egyezik(param[1], "Ház") || egyezik(param[1], "Haz"))
		{
			if(PlayerInfo[playerid][pPhousekey2] != NINCS)
			{
				if(params < 2) return Msg(playerid, "/Csere Ház [1/2]");
			}
			new melyik = strval(param[2]);
			new player;
			player = GetClosestPlayer(playerid);

			if(GetDistanceBetweenPlayers(playerid, player) > 2) return Msg(playerid, "A közeledben nincs senki!");

			if(IsPlayerNPC(player)) return Msg(playerid, "NPC...");

			if(!Logged(player)) return Msg(playerid, "Nincs belépve!");

			if(PlayerInfo[playerid][pPhousekey] == NINCS && PlayerInfo[playerid][pPhousekey2] == NINCS) return Msg(playerid, "Neked nincs házad.");
			if(PlayerInfo[player][pPhousekey] == NINCS && PlayerInfo[playerid][pPhousekey2] == NINCS) return Msg(playerid, "Neki nincs háza.");
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Elszeretnéd cserélni vele(%s) a házatok.", PlayerName(player));
			SendFormatMessage(player, COLOR_LIGHTGREEN, "* %s elszeretné cserélni a házatok. (Elfogadás:(/csere elfogad))", PlayerName(playerid));
			Cselekves(playerid, "elszeretné cserélni a házát valakivel.", 1);
			Csere[player] = playerid;
			if(PlayerInfo[playerid][pPhousekey2] != NINCS)
			{
				if(melyik < 1 || melyik > 2) return 1;
				if(melyik == 1)
					MitCsere[player] = 3;
				else
					MitCsere[player] = 4;

				return 1;
			}
			MitCsere[player] = 3;

		}
		if(egyezik(param[1], "Biznisz"))
		{
			new player;
			player = GetClosestPlayer(playerid);

			if(GetDistanceBetweenPlayers(playerid, player) > 2) return Msg(playerid, "A közeledben nincs senki!");

			if(IsPlayerNPC(player)) return Msg(playerid, "NPC...");

			if(!Logged(player)) return Msg(playerid, "Nincs belépve!");

			if(PlayerInfo[playerid][pPbiskey] == NINCS) return Msg(playerid, "Neked nincs bizniszed.");
			if(PlayerInfo[player][pPbiskey] == NINCS) return Msg(playerid, "Neki nincs biznisze.");
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Elszeretnéd cserélni vele(%s) a bizniszeteket.", PlayerName(player));
			SendFormatMessage(player, COLOR_LIGHTGREEN, "* %s elszeretné cserélni a bizniszeteket. (Elfogadás:(/csere elfogad))", PlayerName(playerid));
			Cselekves(playerid, "elszeretné cserélni a bizniszét valakivel.", 1);
			Csere[player] = playerid;
			MitCsere[player] = 5;
		}
	}
	if(egyezik(cmd, "/széf") || egyezik(cmd, "/szef"))
	{
		if(Civil(playerid) && !Admin(playerid, SZUPERADMIN) && !IsFejleszto(playerid) && !IsTulaj(playerid)) return Msg(playerid, "Nem tartozol frakcióhoz.");
		
		if(params < 1)
		{
			Msg(playerid, "/Széf [Be / Ki / Minrang / Megnéz]");
			if(Admin(playerid, 1)) Msg(playerid, "ADMIN: Pos / Amegnéz / Go / Objectnulla / Resi / Nulláz]");
			return 1;
		}
		new szefid = SzefnelVan(playerid);
		if(egyezik(param[1], "engedély"))
		{
			if(!IsFejleszto(playerid) && !Admin(playerid,2012)) return 1;
			if(params < 2) return Msg(playerid, "/Széf Engedély [JátékosID/NévRészlet]");
			new jatekos = ReturnUser(param[2]);
			if(jatekos == INVALID_PLAYER_ID) return Msg(playerid, "Nincs ilyen játékos.");
			if(!Admin(jatekos, 5)) return Msg(playerid, "A játékosnak legalább 5-ös szintû adminnak kell lennie.");
			if(SzefEngedely[jatekos] == 0)
			{
				SzefEngedely[jatekos] = 1;
				SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Engedélyezted %s-nak/nek.", PlayerName(jatekos));
				SendFormatMessage(jatekos, COLOR_LIGHTGREEN, "* Engedélyt kaptál a széfekhez %s-tõl", PlayerName(playerid));
			}
			else
			{
				SzefEngedely[jatekos] = 0;
				SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Tiltottad %s-nak/nek.", PlayerName(jatekos));
				SendFormatMessage(jatekos, COLOR_LIGHTGREEN, "* %s elvette az engedélyed a széfektõl.", PlayerName(playerid));
			}
		}
		if(egyezik(param[1], "Resi"))
		{
			if(!Admin(playerid, SZUPERADMIN) && SzefEngedely[playerid] != 1) return 1;
			SzefToltes();
			Msg(playerid, "Széf objectek újra töltve.");
		}
		/*if(egyezik(param[1], "Létrehoz"))
		{
			if(params < 2)
			{
				Msg(playerid, "/Széf Létrehoz [Új Frakció Szám]");
				SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Jelenlegi Frakció Szám: %d", FrakcioSzam);
				return 1;
			}
			new szam = strval(param[2]);
			if(szam < 1) return Msg(playerid, "Hát lehet hogy ezt nem kéne...");
			FrakcioSzam = szam;
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Frakció Szám átírva! Régi: %d, Új: %d", (FrakcioSzam - szam), FrakcioSzam);
		}*/
		if(egyezik(param[1], "Go"))
		{
			if(!Admin(playerid, SZUPERADMIN) && SzefEngedely[playerid] != 1) return 1;
			if(params < 2) return Msg(playerid, "/Széf Go [FRAKCIÓ ID]");
			new munka = strval(param[2]);
			SetPlayerPos(playerid, FrakcioInfo[munka][fPosX], FrakcioInfo[munka][fPosY], FrakcioInfo[munka][fPosZ]);
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Teleportálva a %d számú széfhez. Pos: %f, %f, %f", munka, FrakcioInfo[munka][fPosX], FrakcioInfo[munka][fPosY], FrakcioInfo[munka][fPosZ]);
		}
		if(egyezik(param[1], "Amegnéz") || egyezik(param[1], "Amegnez"))
		{
			if(!Admin(playerid, SZUPERADMIN)) return 1;
			if(params < 2) return Msg(playerid, "/Széf Amegnéz [FRAKCIÓ ID]");
			new munka = strval(param[2]);
			SendClientMessage(playerid, COLOR_LIGHTBLUE, "===========[Széf Tartalma]===========");
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Pénz: $%s - Kaja: %ddb", PenzTordeles(FrakcioInfo[munka][fPenz]), FrakcioInfo[munka][fKaja]);
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Material: %ddb - Heroin: %dg", FrakcioInfo[munka][fMati], FrakcioInfo[munka][fHeroin]);
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Kokain: %dg - Marihuana: %dg", FrakcioInfo[munka][fKokain], FrakcioInfo[munka][fMarihuana]);
			//SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Gyémánt: %ddb", FrakcioInfo[munka][fGyemant]);
		}
		if(egyezik(param[1], "Megnéz")  || egyezik(param[1], "Megnez"))
		{
			if(szefid == NINCS) return Msg(playerid, "Nem vagy a széf közelében.");
			if(!LMT(playerid,szefid)) return Msg(playerid, "Ehhez a széfhez nincs hozzáférésed!");
			new Melo = szefid;
			SendClientMessage(playerid, COLOR_LIGHTBLUE, "===========[Széf Tartalma]===========");
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Pénz: $%s - Kaja: %ddb", PenzTordeles(FrakcioInfo[Melo][fPenz]), FrakcioInfo[Melo][fKaja]);
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Material: %ddb - Heroin: %dg", FrakcioInfo[Melo][fMati], FrakcioInfo[Melo][fHeroin]);
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Kokain: %dg - Marihuana: %dg", FrakcioInfo[Melo][fKokain], FrakcioInfo[Melo][fMarihuana]);
			//SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Gyémánt: %ddb", FrakcioInfo[Melo][fGyemant]);
			Cselekves(playerid, "megnézte a széfet...", 1);
		}
		if(egyezik(param[1], "nulláz"))
		{
			if(!Admin(playerid, SZUPERADMIN)) return 1;
			if(params < 2) return Msg(playerid, "/Széf nulláz [FRAKCIÓ ID]");
			new munka = strval(param[2]);
			FrakcioInfo[munka][fPenz] = 0;
			FrakcioInfo[munka][fKaja] = 0;
			FrakcioInfo[munka][fMati] = 0;
			FrakcioInfo[munka][fHeroin] = 0;
			FrakcioInfo[munka][fKokain] = 0;
			FrakcioInfo[munka][fMarihuana] = 0;
			Msg(playerid, "Sikeresen lenulláztad a frakció széfjét!");
		}
		if(egyezik(param[1], "Pos"))
		{
			if(!Admin(playerid, SZUPERADMIN) && SzefEngedely[playerid] != 1 && !IsTulaj(playerid)) return 1;
			if(params < 3) return Msg(playerid, "/Széf Pos [FRAKCIÓ ID] [Object Legyen? (0 - nem, 1 - igen)]");
			new munka = strval(param[2]);
			new objectlegyen = strval(param[3]);
			if(munka > MAX_FRAKCIO) return 1;
			if(objectlegyen < 0 || objectlegyen > 1) return 1;
			new Float:X, Float:Y, Float:Z, Float:A;
			GetPlayerPos(playerid, X, Y, Z);
			GetPlayerFacingAngle(playerid, A);
			FrakcioInfo[munka][fObject] = objectlegyen;
			FrakcioInfo[munka][fPosX] = X;
			FrakcioInfo[munka][fPosY] = Y;
			FrakcioInfo[munka][fPosZ] = Z;
			FrakcioInfo[munka][fPosA] = A+180;

			if(objectlegyen) SzefToltes();
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Széf átrakva. Munka: %d, Object: %d, Pos: %f, %f, %f", munka, objectlegyen, X, Y, Z);
			FrakcioUpdate(munka,FRAKCIO_PosX,FRAKCIO_PosY,FRAKCIO_PosZ,FRAKCIO_PosA);
		}
		if(egyezik(param[1], "Minrang"))
		{
			if(PlayerInfo[playerid][pLeader] < 1) return Msg(playerid, "Kizárólag Leadernek!");
			new Melo = PlayerInfo[playerid][pLeader];
			if(params < 2)
			{
				SendFormatMessage(playerid, COLOR_LIGHTRED, "/széf minrang [0-%d]", MAX_FRAKCIO_RANG);

				SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Jelenleg %d rangtól lehet kivenni.", FrakcioInfo[Melo][fMinrang]);
				return 1;
			}
			new rang = strval(param[2]);
			if(rang < 0 || rang > MAX_FRAKCIO_RANG)
			{
				SendFormatMessage(playerid, COLOR_LIGHTRED, "0-%d", MAX_FRAKCIO_RANG);
				return 1;
			}
			FrakcioInfo[Melo][fMinrang] = rang;
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* A széfbõl mostantól %d rangtól lehet kivenni.", rang);
			FrakcioUpdate(Melo,FRAKCIO_MinRang);
		}
		if(egyezik(param[1], "széfinfo") || egyezik(param[1], "szefinfo"))
		{
		    if(PlayerInfo[playerid][pLeader] == 0) return Msg(playerid, "Nem használhatod!");
		    if(!SzefInfok[playerid])
		    {
		    	SzefInfok[playerid] = true;
		    	Msg(playerid, "Széf információk bekapcsolva!");
			}
			else
			{
			    SzefInfok[playerid] = false;
			    Msg(playerid, "Széf információk kikapcsolva!");
			}
		}
		if(egyezik(param[1], "Be"))
		{
		    if(szefid == NINCS) return Msg(playerid, "Nem vagy a széf közelében.");
			if(!LMT(playerid,szefid)) return Msg(playerid, "Ehhez a széfhez nincs hozzáférésed!");
			if(params < 3)
			{
				Msg(playerid, "/Széf Be [Mit] [Mennyit]");
				Msg(playerid, "Amiket lehet: Pénz, Material(Mati), Heroin, Kokain, Marihuana, Ecstasy, Kaja");
				return 1;
			}
			new Melo = szefid;
			new Mennyit = strval(param[3]);
			new Mati = PlayerInfo[playerid][pMats];
			new Heroin = PlayerInfo[playerid][pHeroin];
			new Kokain = PlayerInfo[playerid][pKokain];
			new Marihuana = PlayerInfo[playerid][pMarihuana];
			new Ecstasy = PlayerInfo[playerid][pEcstasy];
			new Kaja = PlayerInfo[playerid][pKaja];
			new Penz = GetMoney(playerid);
			if(Mennyit < 1) return Msg(playerid, "Minuszt?");

			if(egyezik(param[2], "Pénz") || egyezik(param[2], "Penz"))
			{
				if(Penz < Mennyit) return Msg(playerid, "Nincs elég pénzed.");
				GiveMoney(playerid, -Mennyit);
				FrakcioInfo[Melo][fPenz] += Mennyit;
				SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Beraktál %d$ a széfbe.", Mennyit);
				if(!IsRicardo(playerid))
					Format(string, "(( %s berakott $%s a széfbe! ))",PlayerName(playerid),PenzTordeles(Mennyit));
				SendSzefInfo(Melo,string);
			}
			if(egyezik(param[2], "Material") || egyezik(param[2], "Mati"))
			{
				if(Mati < Mennyit) return Msg(playerid, "Nincs elég materialod.");
				PlayerInfo[playerid][pMats] -= Mennyit;
				FrakcioInfo[Melo][fMati] += Mennyit;
				SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Beraktál %ddb Materialt a széfbe.", Mennyit);
				if(!IsRicardo(playerid))
					Format(string, "(( %s berakott %d db materialt a széfbe! ))",PlayerName(playerid),Mennyit);
				SendSzefInfo(Melo,string);
			}
			if(egyezik(param[2], "Heroin"))
			{
				if(Heroin < Mennyit) return Msg(playerid, "Nincs elég heroinod!");
				PlayerInfo[playerid][pHeroin] -= Mennyit;
				FrakcioInfo[Melo][fHeroin] += Mennyit;
				SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Beraktál %dg Heroint a széfbe.", Mennyit);
				if(!IsRicardo(playerid))
					Format(string, "(( %s berakott %d g heroint a széfbe! ))",PlayerName(playerid),Mennyit);
				SendSzefInfo(Melo,string);
			}
			if(egyezik(param[2], "Kokain"))
			{
				if(Kokain < Mennyit) return Msg(playerid, "Nincs elég kokainod!");
				PlayerInfo[playerid][pKokain] -= Mennyit;
				FrakcioInfo[Melo][fKokain] += Mennyit;
				SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Beraktál %dg Kokaint a széfbe.", Mennyit);
				if(!IsRicardo(playerid))
					Format(string, "(( %s berakott %d g kokaint a széfbe! ))",PlayerName(playerid),Mennyit);
				SendSzefInfo(Melo,string);
			}
			if(egyezik(param[2], "Marihuana"))
			{
				if(Marihuana < Mennyit) return Msg(playerid, "Nincs elég marihuanád!");
				PlayerInfo[playerid][pMarihuana] -= Mennyit;
				FrakcioInfo[Melo][fMarihuana] += Mennyit;
				SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Beraktál %dg Marihuanát a széfbe.", Mennyit);
				if(!IsRicardo(playerid))
					Format(string, "(( %s berakott %d g marihuana-t a széfbe! ))",PlayerName(playerid),Mennyit);
				SendSzefInfo(Melo,string);
			}
			if(egyezik(param[2], "Ecstasy"))
			{
				if(Ecstasy < Mennyit) return Msg(playerid, "Nincs elég ecstasy-d!");
				PlayerInfo[playerid][pMarihuana] -= Mennyit;
				FrakcioInfo[Melo][fMarihuana] += Mennyit;
				SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Beraktál %ddb ecstasy-t a széfbe.", Mennyit);
				if(!IsRicardo(playerid))
					Format(string, "(( %s berakott %ddb ecstasy-t a széfbe! ))",PlayerName(playerid),Mennyit);
				SendSzefInfo(Melo,string);
			}
			if(egyezik(param[2], "Kaja"))
			{
				if(Kaja < Mennyit) return Msg(playerid, "Nincs elég kajád.");
				PlayerInfo[playerid][pKaja] -= Mennyit;
				FrakcioInfo[Melo][fKaja] += Mennyit;
				SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Beraktál %ddb Kaját a széfbe.", Mennyit);
				if(!IsRicardo(giveplayerid))
                Format(string, "(( %s berakott %d db kaját a széfbe! ))",PlayerName(playerid),Mennyit);
				SendSzefInfo(Melo,string);
			}
			FrakcioUpdate(Melo,FRAKCIO_Cuccok);
		}
		if(egyezik(param[1], "Ki"))
		{
		    if(szefid == NINCS) return Msg(playerid, "Nem vagy a széf közelében.");
			if(!LMT(playerid,szefid)) return Msg(playerid, "Ehhez a széfhez nincs hozzáférésed!");
			new Melo = szefid;
			if(PlayerInfo[playerid][pRank] < FrakcioInfo[Melo][fMinrang])
			{
				SendFormatMessage(playerid, COLOR_LIGHTRED, "* Nem elég nagy a rangod, minimum rang: %d", FrakcioInfo[Melo][fMinrang]);
				return 1;
			}
			if(params < 3)
			{
				Msg(playerid, "/Széf Ki [Mit] [Mennyit]");
				Msg(playerid, "Amiket lehet: Pénz, Material(Mati), Heroin, Kokain, Marihuana, Kaja");
				return 1;
			}
			new Mennyit = strval(param[3]);
			new Mati = FrakcioInfo[Melo][fMati];
			new Heroin = FrakcioInfo[Melo][fHeroin];
			new Kokain = FrakcioInfo[Melo][fKokain];
			new Marihuana = FrakcioInfo[Melo][fMarihuana];
			new Kaja = FrakcioInfo[Melo][fKaja];
			new Penz = FrakcioInfo[Melo][fPenz];
			if(Mennyit < 1) return Msg(playerid, "Minuszt?");
			if(!PlayerToPoint(3, playerid, FrakcioInfo[Melo][fPosX], FrakcioInfo[Melo][fPosY], FrakcioInfo[Melo][fPosZ])) return Msg(playerid, "Nem vagy a széf közelében.");
			if(egyezik(param[2], "Pénz") || egyezik(param[2], "Penz"))
			{
				if(Penz < Mennyit) return Msg(playerid, "Nincs elég pénz a széfben.");
				GiveMoney(playerid, Mennyit);
				FrakcioInfo[Melo][fPenz] -= Mennyit;
				SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Kivettél $%d-ot a széfbõl.", Mennyit);
				if(!IsRicardo(giveplayerid))
                Format(string, "(( %s kivett $%d-t a széfbõl! ))",PlayerName(playerid),Mennyit);
				SendSzefInfo(Melo,string);
			}
			if(egyezik(param[2], "Material") || egyezik(param[2], "Mati"))
			{
				if(Mati < Mennyit) return Msg(playerid, "Nincs elég material a széfben.");
				if((PlayerInfo[playerid][pMats] + Mennyit) > MAXMATI) return Msg(playerid, "Nem fér el nálad.");
				PlayerInfo[playerid][pMats] += Mennyit;
				FrakcioInfo[Melo][fMati] -= Mennyit;
				SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Kivettél %ddb Materialt a széfbõl.", Mennyit);
				if(!IsRicardo(giveplayerid))
                Format(string, "(( %s kivett %d db materialt a széfbõl! ))",PlayerName(playerid),Mennyit);
				SendSzefInfo(Melo,string);
			}
			if(egyezik(param[2], "Heroin"))
			{
				if(Heroin < Mennyit) return Msg(playerid, "Nincs elég heroin a széfben.");
				if((PlayerInfo[playerid][pHeroin] + Mennyit) > MAXHEROIN) return Msg(playerid, "Nem fér el nálad.");
				PlayerInfo[playerid][pHeroin] += Mennyit;
				FrakcioInfo[Melo][fHeroin] -= Mennyit;
				SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Kivettél %dg Heroint a széfbõl.", Mennyit);
				if(!IsRicardo(giveplayerid))
                Format(string, "(( %s kivett %d g heroint a széfbõl! ))",PlayerName(playerid),Mennyit);
				SendSzefInfo(Melo,string);
			}
			if(egyezik(param[2], "Kokain"))
			{
				if(Kokain < Mennyit) return Msg(playerid, "Nincs elég kokain a széfben.");
				if((PlayerInfo[playerid][pKokain] + Mennyit) > MAXKOKAIN) return Msg(playerid, "Nem fér el nálad.");
				PlayerInfo[playerid][pKokain] += Mennyit;
				FrakcioInfo[Melo][fKokain] -= Mennyit;
				SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Kivettél %dg Kokaint a széfbõl.", Mennyit);
				if(!IsRicardo(giveplayerid))
                Format(string, "(( %s kivett %d g kokaint a széfbõl! ))",PlayerName(playerid),Mennyit);
				SendSzefInfo(Melo,string);
			}
			if(egyezik(param[2], "Marihuana"))
			{
				if(Marihuana < Mennyit) return Msg(playerid, "Nincs elég marihuána a széfben.");
				if((PlayerInfo[playerid][pMarihuana] + Mennyit) > MAXMARIHUANA) return Msg(playerid, "Nem fér el nálad.");
				PlayerInfo[playerid][pMarihuana] += Mennyit;
				FrakcioInfo[Melo][fMarihuana] -= Mennyit;
				SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Kivettél %dg Marihuanát a széfbõl.", Mennyit);
				if(!IsRicardo(giveplayerid))
                Format(string, "(( %s kivett %d g marihuana-t a széfbõl! ))",PlayerName(playerid),Mennyit);
				SendSzefInfo(Melo,string);
			}
			if(egyezik(param[2], "Kaja"))
			{
				if(Kaja < Mennyit) return Msg(playerid, "Nincs elég kaja a széfben.");
				if((PlayerInfo[playerid][pKaja] + Mennyit) > MAXKAJA) return Msg(playerid, "Nem fér el nálad.");
				PlayerInfo[playerid][pKaja] += Mennyit;
				FrakcioInfo[Melo][fKaja] -= Mennyit;
				SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Kivettél %ddb Kaját a széfbõl.", Mennyit);
				if(!IsRicardo(giveplayerid))
                Format(string, "(( %s kivett %d g kaját a széfbõl! ))",PlayerName(playerid),Mennyit);
				SendSzefInfo(Melo,string);
			}
			FrakcioUpdate(Melo,FRAKCIO_Cuccok);
		}
		return 1;
	}
	if(egyezik(cmd, "/határ"))
	{
		if(FloodCheck(playerid, cmd)) return 1;
		
		new 
			Float:MaxTav = 8.0,
			CloseTime = 5 * 1000,
			HatarAtkeloDij = 25
		;
		
		if(GetMoney(playerid) < HatarAtkeloDij)
		{
			MsgFormat(playerid, "A határátkelés díja $%d!", HatarAtkeloDij);
			return 1;
		}
		
		if(PlayerToPoint(MaxTav, playerid, 39.2373, -1521.5503, 5.2052)) // LS-SF kijárat
		{
			SetDynamicObjectRot(HatarSorompo[0], 0.00000, 0.00000, 91.00000);
			SetTimerEx("CloseSorompo", CloseTime, false, "ifff", 0, 0.00000, 90.00000, 91.00000);
		}
		else if(PlayerToPoint(MaxTav, playerid, 63.8567, -1539.4918, 5.0424)) // LS-SF bejárat
		{
			SetDynamicObjectRot(HatarSorompo[1], 0.00000, 0.00000, 269.0000);
			SetTimerEx("CloseSorompo", CloseTime, false, "ifff", 1, 0.00000, 89.98000, 269.00000);
		}
		else if(PlayerToPoint(MaxTav, playerid, 634.1098, -1195.9039, 18.1094)) // LS alagút bejárat
		{
			SetDynamicObjectRot(HatarSorompo[2], 0.00000, 0.00000, 269.0000);
			SetTimerEx("CloseSorompo", CloseTime, false, "ifff", 2, 0.00000, -90.00000, 205.00000);
		}
		else if(PlayerToPoint(MaxTav, playerid, 607.7025, -1197.4120, 18.6446)) // LS alagút kijárat
		{
			SetDynamicObjectRot(HatarSorompo[3], 0.00000, 0.00000, 269.0000);
			SetTimerEx("CloseSorompo", CloseTime, false, "ifff", 3, 0.00000, -90.00000, 19.00000);
		}
		else if(PlayerToPoint(MaxTav, playerid, 617.4741, 339.5045, 19.1226)) // kishid1 kijarat
		{
			SetDynamicObjectRot(HatarSorompo[4], 0.00000, 0.00000, 34.99000);
			SetTimerEx("CloseSorompo", CloseTime, false, "ifff", 4, 0.00000, 270.00000, 34.99000);
		}
		else if(PlayerToPoint(MaxTav, playerid, 607.8223, 342.2892, 18.9297)) // kishid1 bejárat
		{
			SetDynamicObjectRot(HatarSorompo[5], 0.00000, 0.00000, 35.95000);
			SetTimerEx("CloseSorompo", CloseTime, false, "ifff", 5, 0.00000, 90.00000, 35.95000);
		}		
		else if(PlayerToPoint(MaxTav, playerid, -196.6605, 245.5021, 12.0711)) // kishid2 kijárat
		{
			SetDynamicObjectRot(HatarSorompo[6], 0.00000, 0.00000, 344.89999);
			SetTimerEx("CloseSorompo", CloseTime, false, "ifff", 6, 0.00000, 270.00000, 344.89999);
		}
		else if(PlayerToPoint(MaxTav, playerid, -200.9090, 254.7924, 12.0781)) // kishid2 bejárat
		{
			SetDynamicObjectRot(HatarSorompo[7], 0.00000, 0.00000, 344.98999);
			SetTimerEx("CloseSorompo", CloseTime, false, "ifff", 7, 0.00000, 90.00000, 344.98999);
		}
		else if(PlayerToPoint(MaxTav, playerid, 1748.4714, 529.3116, 26.4141)) // LS-LV kijárat
		{
			SetDynamicObjectRot(HatarSorompo[8], 0.00000, 0.00000, -18.0000);
			SetTimerEx("CloseSorompo", CloseTime, false, "ifff", 8, 0.00000, 90.00000, -18.00000);
		}
		else if(PlayerToPoint(MaxTav, playerid, 1733.1355, 529.8027, 26.6691)) // LS-LV bejárat
		{
			SetDynamicObjectRot(HatarSorompo[9], 0.00000, 0.00000, -19.00000);
			SetTimerEx("CloseSorompo", CloseTime, false, "ifff", 9, 0.00000, -90.00000, -19.00000);
		}
		else
		{
			iMsg(playerid, "Nem vagy határsorompó közelében!");
			return 1;
		}
		
		PlayerPlaySound(playerid, 1085, 0.0, 0.0, 0.0);
		GiveMoney(playerid, -HatarAtkeloDij);
		SCM(playerid, COLOR_GREY, "Határõr: Köszönjük! Vezessen óvatosan!");
		
		return 1;
	}
	if(egyezik(cmd, "/szerel"))
	{
	    if(!LMT(playerid, LMUNKA_SZERELO)) return Msg(playerid, "Nem vagy autószerelõ!");
	    if(!Muhelyben(playerid)) return Msg(playerid, "Nem vagy szerelõmûhelyben!");

		new kocsi = GetClosestCar(playerid);
		if(GetDistanceToCar(playerid,kocsi) < 5.0)
		{
  			new vs = IsAVsKocsi(kocsi);
		    //if(vs == NINCS) return Msg(playerid, "Ez nem Vs jármû!");
		    if(params != 1) return Msg(playerid, "/szerel [Kompresszió / Gyújtás / Üzemanyagcsövek");
			new ido;
		    if(egyezik(param[1], "kompresszió") || egyezik(param[1], "kompresszio"))
		    {
		        if(CarInfo[vs][cAllapot][ALLAPOT_KOMPRESSZIO] >= 90) return Msg(playerid, "Az állapota jobb mint 90%%, nem kell javítani!");
		        Cselekves(playerid, "elkezdte a szerelést...",0);
				ido = (100-CarInfo[vs][cAllapot][ALLAPOT_KOMPRESSZIO]*100);
		        SetTimerEx("AlkatreszSzerel",(10000+ido), false, "ddd",playerid,vs,ALLAPOT_KOMPRESSZIO);
		        Freeze(playerid,(10000+ido));
				ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop",4.0,1,0,0,1,0);
		    }
		    else if(egyezik(param[1], "Gyújtás") || egyezik(param[1], "gyujtas"))
		    {
		        if(CarInfo[vs][cAllapot][ALLAPOT_GYUJTAS] >= 90) return Msg(playerid, "Az állapota jobb mint 90%%, nem kell javítani!");
		        Cselekves(playerid, "elkezdte a szerelést...",0);
				ido = (100-CarInfo[vs][cAllapot][ALLAPOT_GYUJTAS]*100);
	         	SetTimerEx("AlkatreszSzerel",(10000+ido), false, "ddd",playerid,vs,ALLAPOT_GYUJTAS);
	         	Freeze(playerid,(10000+ido));
				ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop",4.0,1,0,0,1,0);
		    }
		    else if(egyezik(param[1], "Üzemanyagcsövek") || egyezik(param[1], "Uzemanyagcsovek"))
		    {
		        if(CarInfo[vs][cAllapot][ALLAPOT_UZEMANYAG] >= 90) return Msg(playerid, "Az állapota jobb mint 90%%, nem kell javítani!");
				Cselekves(playerid, "elkezdte a szerelést...",0);
				ido = (100-CarInfo[vs][cAllapot][ALLAPOT_UZEMANYAG]*100);
			 	SetTimerEx("AlkatreszSzerel",(10000+ido), false, "ddd",playerid,vs,ALLAPOT_UZEMANYAG);
			 	Freeze(playerid,(10000+ido));
				ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop",4.0,1,0,0,1,0);
				
		    }
		}
		else
		    Msg(playerid, "A közeledben nincs jármû!");
		    
		return 1;
	}
	if(egyezik(cmd, "/nulláz") || egyezik(cmd, "/nullaz"))
	{
	    if(!IsRicardo(playerid)) return HibasParancs(playerid, true);
		
		new szoveg[512];
		format(szoveg, sizeof(szoveg), "Drog: Zseb \
		\nDrog: Ház \
		\nDrog: Frakciók \
		\nJátszott óra/Szint\
		\nInaktív játékosok (30 nap) \
		\nPénz \
		\nLeader \
		\nHitman \
		\nAdmin \
		\nBan \
		\nBiztulaj \
		\nVs kocsik \n");
		
		ShowPlayerDialog(playerid, DIALOG_NULLAZ, DIALOG_STYLE_LIST, "Nullázás", szoveg, "Bezárás", "");
		return 1;
	}
	if(egyezik(cmd, "/atuning"))
	{
		if(!Admin(playerid, FOADMIN)) return HibasParancs(playerid, true);
		if(!IsAdminSzolis(playerid)) return Msg(playerid, "Ezt a parancsot csak AdminSzolgálatban használhatod!", COLOR_ADMIN);
		if(IsPlayerInAnyVehicle(playerid)) return Msg(playerid, "A jármû mellett kell állnod");
		if(params < 1) return Msg(playerid, "/atuning [Szin / Kerék / Matrica / Hidraulika / EMP / Neon / Nitro / Levesz]");
		if(egyezik(param[1], "nitro"))
		{
			new kocsi, vs;
			kocsi = GetClosestVehicle(playerid);
			
			vs = IsAVsKocsi(kocsi); 
			if(vs == NINCS) return Msg(playerid, "Ez a jármû a módba van beleírva!");
			
			if(GetDistanceToVehicle(playerid, kocsi) > 5.5) return Msg(playerid, "Nincs a közelben a jármû!");
			if(GetVehicleComponentInSlot(kocsi, CARMODTYPE_NITRO) == 1010)
			{
				return Msg(playerid, "Már van benne nitro!");
			}
			else
			{
				TuningFelrak(playerid,kocsi, 1010);
				return Msg(playerid, "Beszerelve!");
			}
		}
		else if(egyezik(param[1], "kerék") || egyezik(param[1], "kerek"))
		{
			new kocsi, vs;
			kocsi = GetClosestVehicle(playerid);
			if(GetDistanceToVehicle(playerid, kocsi) > 5.5) return Msg(playerid, "Nincs a közelben a jármû!");

			vs = IsAVsKocsi(kocsi); 
			if(vs == NINCS) return Msg(playerid, "Ez a jármû a módba van beleírva!");

			if(CarInfo[vs][cFrakcio] != 0) return Msg(playerid, "Nem-nem... Frakciókocsit nem tuningolunk!");
		
			if(params < 2) return Msg(playerid, "/atuning kerék [1-13]");
			new kerek = strval(param[2]);
			if(kerek < 1 || kerek > 13) return Msg(playerid, "Kerék csak 1-13 lehet.");
			Msg(playerid, "Kerék felrakva!");
			
			new k = kerek+1072;
			
			TuningFelrak(playerid, kocsi, k);
			
			CarInfo[vs][cKerek] = k;
			CarUpdate(vs, CAR_Kerek);
		}
		else if(egyezik(param[1], "hidraulika"))
		{
			new kocsi, vs;
			kocsi = GetClosestVehicle(playerid);
			if(GetDistanceToVehicle(playerid, kocsi) > 5.5) return Msg(playerid, "Nincs a közelben a jármû!");

			vs = IsAVsKocsi(kocsi);
			if(vs == NINCS) return Msg(playerid, "Ez a jármû a módba van beleírva!");

			if(CarInfo[vs][cFrakcio] != 0) return Msg(playerid, "Nem-nem... Frakciókocsit nem tuningolunk!");
			
			if(GetVehicleComponentInSlot(vs, CARMODTYPE_HYDRAULICS) == 1087) return Msg(playerid, "Már van benne hidraulika!");

			AddVehicleComponent(vs, 1087);
			
			Msg(playerid, "Hidraulika felrakva!");

			CarInfo[vs][cHidraulika] = 1;
			CarUpdate(vs, CAR_Hidraulika);
		}
		else if(egyezik(param[1], "levesz"))
		{
			if(params < 2) return Msg(playerid, "/atuning levesz [Kerék / Kasztni / Matrica / Hidraulika / Tuning]");
			new kocsi, vs;
			kocsi = GetClosestVehicle(playerid);
			if(GetDistanceToVehicle(playerid, kocsi) > 5.5) return Msg(playerid, "Nincs a közelben a jármû!");

			vs = IsAVsKocsi(kocsi);
			if(vs == NINCS) return Msg(playerid, "Ez a jármû a módba van beleírva!");
			
			if(CarInfo[vs][cFrakcio] != 0) return Msg(playerid, "Nem-nem... Frakciókocsit nem tuningolunk!");
			
			if(egyezik(param[2], "Matrica"))
			{
				ChangeVehiclePaintjob(CarInfo[idx][cId], 3);
				CarInfo[vs][cMatrica] = 0;
				CarUpdate(vs, CAR_Matrica);
				Msg(playerid, "Matrica leszedve.");
			}
			if(egyezik(param[2], "Neon"))
			{
				CarInfo[vs][cNeon] = 0;
				CarUpdate(vs, CAR_Neon);
				Msg(playerid, "Neon leszedve.");
			}
			if(egyezik(param[2], "Kerék"))
			{
				CarInfo[vs][cKerek] = 0;
				CarUpdate(vs, CAR_Kerek);
				Msg(playerid, "Kerék leszedve.");
			}
			if(egyezik(param[2], "tuning"))
			{
				RemoveVehicleComponents(kocsi);
				Msg(playerid, "Tuning leszerelve! (/park, vagy Kocsiresi után lesz levéve)");
			}
		}
		else if(egyezik(param[1], "color") || egyezik(param[1], "szin") || egyezik(param[1], "szín"))
  		{
			new kocsi, vs;
			kocsi = GetClosestVehicle(playerid);
			if(GetDistanceToVehicle(playerid, kocsi) > 5.5)
				return Msg(playerid, "A közeledben nincs jármû!");

			vs = IsAVsKocsi(kocsi);
			if(vs == NINCS)
				return Msg(playerid, "Ez a jármû a módba van beleírva!");

		/*	#if defined FRAKCIOKOCSI
			if(CarInfo[vs][cFrakcio] != 0) return Msg(playerid, "Nem-nem... Frakciókocsit nem tuningolunk!");
			#endif*/
	       	if(params < 3) return Msg(playerid, "Használata: /atuning szin [szín1] [szín2]");

			new color1 = strval(param[2]);
			if(color1 < 0 && color1 > 126) return Msg(playerid, "A szín minimum 0 és max 126 lehet!");
			new color2 = strval(param[3]);
			if(color2 < 0 && color2 > 126) return Msg(playerid, "A szín minimum 0 és max 126 lehet!");

			if(CarInfo[vs][cColorOne] != color1 || CarInfo[vs][cColorTwo] != color2)
				CarInfo[vs][cPainted] = 1;
			else
				CarInfo[vs][cPainted] = 0;

			CarInfo[vs][cColorOne] = color1;
			CarInfo[vs][cColorTwo] = color2;
			SetVehicleColor(kocsi, color1, color2);

			//CarUpdate(vs, "Szin1='%d', Szin2='%d'", color1, color2);
			CarUpdate(vs, CAR_ColorOne, CAR_ColorTwo);

			return 1;
    	}
    	else if(egyezik(param[1], "EMP"))
		{
			new kocsi, vs;
			kocsi = GetClosestVehicle(playerid);
			if(GetDistanceToVehicle(playerid, kocsi) > 5.5) return Msg(playerid, "Nincs a közelben a jármû!");

			vs = IsAVsKocsi(kocsi);
			if(vs == NINCS) return Msg(playerid, "Ez a jármû a módba van beleírva!");
			
			if(CarInfo[vs][cFrakcio] != 0) return Msg(playerid, "Nem-nem... Frakciókocsit nem tuningolunk!");
			
			CarInfo[vs][cEMP] = 1;
			CarUpdate(vs, CAR_EMP);
		}
		else if(egyezik(param[1], "matrica"))
		{
			if(params < 2)
			{
				Msg(playerid, "/atuning matrica [1-4] - 4 = leveszi a matricát.");
				Msg(playerid, "Figyelmeztetés: Csak lowrider és tuning kocsikra, ha másra rakod a pénzt nem kapod vissza!");
				return 1;
			}
			new matrica = strval(param[2]);
			if(matrica < 1 || matrica > 4) return Msg(playerid, "1-4 legyen a matrica száma.");
			new kocsi, vs;
			kocsi = GetClosestVehicle(playerid);
			if(GetDistanceToVehicle(playerid, kocsi) > 5.5) return Msg(playerid, "Nincs a közelben a jármû!");

			vs = IsAVsKocsi(kocsi);
			if(vs == NINCS) return Msg(playerid, "Ez a jármû a módba van beleírva!");
			
			if(CarInfo[vs][cFrakcio] != 0) return Msg(playerid, "Nem-nem... Frakciókocsit nem tuningolunk!");
			
			if(matrica == 4)
			{
				ChangeVehiclePaintjob(kocsi, 3);
				CarInfo[vs][cMatrica] = 0;
				CarUpdate(vs, CAR_Matrica);
			}
			else
			{
				ChangeVehiclePaintjob(kocsi, matrica-1);
				CarInfo[vs][cMatrica] = strval(param[2]);
				CarUpdate(vs, CAR_Matrica);
			}
			Msg(playerid, "Matrica felrakva.");
		}
		else if(egyezik(param[1], "neon") || egyezik(param[1], "neon"))
		{
			if(params != 2) return Msg(playerid, "/atuning neon [Piros/Kék/Zöld/Sárga/Pink/Fehér]");
			new kocsi, vs;
			kocsi = GetClosestVehicle(playerid);
			if(GetDistanceToVehicle(playerid, kocsi) > 5.5) return Msg(playerid, "Nincs a közelben a jármû!");
			if(Bikes(kocsi)) return Msg(playerid, "Erre akarsz neont rakni, ne röhögtess már!");
			if(!LehetRaNeontRakni(kocsi))
			{
				SendClientMessage(playerid,COLOR_LIGHTRED, "Erre a jármûre nem lehet neont szerelni!");
				return 1;
			}
			vs = IsAVsKocsi(kocsi);
			if(vs == NINCS) return Msg(playerid, "Ez a jármû a módba van beleírva!");
			#if defined FRAKCIOKOCSI
			if(CarInfo[vs][cFrakcio] != 0) return Msg(playerid, "Nem-nem... Frakciókocsit nem tuningolunk!");
			#endif
			if(egyezik(param[2], "piros"))
			{
				CarInfo[vs][cNeon] = NEON_PIROS;
				Msg(playerid, "Piros Neon Felszerelve! (/park, vagy Kocsiresi után rajta lesz!)");
			}
			else if(egyezik(param[2], "kék") || egyezik(param[2], "kek"))
			{
				CarInfo[vs][cNeon] = NEON_KEK;
				Msg(playerid, "Kék Neon Felszerelve! (/park, vagy Kocsiresi után rajta lesz!)");
			}
			else if(egyezik(param[2], "COLOR_GREEN") || egyezik(param[2], "zöld"))
			{
				CarInfo[vs][cNeon] = NEON_COLOR_GREEN;
				Msg(playerid, "Zöld Neon Felszerelve! (/park, vagy Kocsiresi után rajta lesz!)");
			}
			else if(egyezik(param[2], "sárga") || egyezik(param[2], "COLOR_YELLOW"))
			{
				CarInfo[vs][cNeon] = NEON_COLOR_YELLOW;
				Msg(playerid, "Sárga Neon Felszerelve! (/park, vagy Kocsiresi után rajta lesz!)");
			}
			else if(egyezik(param[2], "pink"))
			{
				CarInfo[vs][cNeon] = NEON_PINK;
				Msg(playerid, "Pink Neon Felszerelve! (/park, vagy Kocsiresi után rajta lesz!)");
			}
			else if(egyezik(param[2], "fehér") || egyezik(param[2], "feher"))
			{
				CarInfo[vs][cNeon] = NEON_FEHER;
				Msg(playerid, "Fehér Neon Felszerelve! (/park, vagy Kocsiresi után rajta lesz!)");
			}
			CarUpdate(vs, CAR_Neon);
		}
		return 1;
	}
	if(egyezik(cmd, "/tuning"))
	{
		if(!Muhelyben(playerid)) return Msg(playerid, "Nem vagy szerelõmûhelyben!");
		if(!IsPlayerInAnyVehicle(playerid)) return Msg(playerid, "Nem vagy kocsiban!");
		if(!LMT(playerid, LMUNKA_SZERELO)) return Msg(playerid, "Nem vagy szerelõ!");
        new vehiclemodel = GetVehicleModel(GetPlayerVehicleID(playerid));
		new kocsi = GetClosestVehicle(playerid);
		if(kocsi == NINCS) return Msg(playerid, "Ez a jármû a módba van beleírva!");
		if(vehiclemodel < 400 || vehiclemodel > 611) return Msg(playerid, "Ezt a kocsit nem tuningolhatod!");
		new tuningstr[1024];
	    new component;
	 	TuningSzamolo[playerid] = 1;
	    while(GetVehicleCompatibleUpgrades(vehiclemodel, TuningSzamolo[playerid], component))
	    {
			if(TuningSzamolo[playerid] <= MAX_KOMPONENS)
			{
				if(TuningSzamolo[playerid] == 1) format(tuningstr, sizeof(tuningstr), "%s", GetComponentName(component));
				else format(tuningstr, sizeof(tuningstr), "%s\n%s", tuningstr, GetComponentName(component));
				KomponensID[playerid][TuningSzamolo[playerid]-1] = component;
				TuningSzamolo[playerid] ++;
			}
			else break;
	    }
		new cim[80];
		Format(cim, ":: Elérhetõ Tuning alkatrészek a jármûhöz {FF6400}(%d)", GetVehicleModelName(vehiclemodel-400));
		ShowPlayerDialog(playerid, DIALOG_TUNING, DIALOG_STYLE_LIST, cim, tuningstr, "Felszerel", "Mégse");
		return 1;
	}
	if(egyezik(cmd, "/atuning2"))
	{
		if(!Admin(playerid, FOADMIN)) return HibasParancs(playerid, true);
		new kocsi = GetClosestVehicle(playerid);
		if(kocsi == NINCS) return Msg(playerid, "Ez a jármû a módba van beleírva!");
		if(GetDistanceToVehicle(playerid, kocsi) > 5.5) return Msg(playerid, "Nincs a közelben a jármû!");
		//if(CarInfo[vs][cFrakcio] != 0) return Msg(playerid, "Nem-nem... Frakciókocsit nem tuningolunk!");
        new vehiclemodel = GetVehicleModel(GetPlayerVehicleID(playerid));
		if(vehiclemodel < 400 || vehiclemodel > 611) return Msg(playerid, "Ezt a kocsit nem tuningolhatod!");
		new tuningstr[1024];
	    new component;
	 	TuningSzamolo[playerid] = 1;
	    while(GetVehicleCompatibleUpgrades(vehiclemodel, TuningSzamolo[playerid], component))
	    {
			if(TuningSzamolo[playerid] <= MAX_KOMPONENS)
			{
				if(TuningSzamolo[playerid] == 1) format(tuningstr, sizeof(tuningstr), "%s", GetComponentName(component));
				else format(tuningstr, sizeof(tuningstr), "%s\n%s", tuningstr, GetComponentName(component));
				KomponensID[playerid][TuningSzamolo[playerid]-1] = component;
				TuningSzamolo[playerid]++;
			}
			else break;
	    }
		new cim[80];
		Format(cim, ":: Elérhetõ Tuning alkatrészek a jármûhöz {FF6400}(%d)", GetVehicleModelName(vehiclemodel-400));
		ShowPlayerDialog(playerid, DIALOG_TUNING2, DIALOG_STYLE_LIST, cim, tuningstr, "Felszerel", "Mégse");
		return 1;
	}
	if(egyezik(cmd, "/útzár") || egyezik(cmd, "/utzar") || egyezik(cmd, "/roadblock"))
	{
	    if(!IsACop(playerid) && !Admin(playerid,FOADMIN)) return Msg(playerid, "Nem tartozol egy rendvédelmi szervezethez sem!");
		if(OnDuty[playerid]!=1 && !Admin(playerid,FOADMIN)) return Msg(playerid, "Nem vagy szolgálatba.");
		if(!Munkarang(playerid, 6) && !LMT(playerid, LMUNKA_FBI) && !Admin(playerid, FOADMIN)) return Msg(playerid, "Minimum 6-os rang.");
		if(params < 1)
		{
			Msg(playerid, "/útzár [Lerak / Felvesz]");
			return 1;
		}
		if(egyezik(param[1], "lerak"))
		{
			new kocsi = GetClosestVehicle(playerid);
			if(GetDistanceToVehicle(playerid,kocsi) <= 3.0)
			{
				if(GetVehicleModel(kocsi) != 552) return Msg(playerid, "Utility van közelében kell lenned!");
			}
			else
			{
				Msg(playerid, "Nincs a közelben jármû!");
			}
		    if(params != 2)
		    {
		        Msg(playerid, "Használat: /crb [Útzár ID]");
				SendClientMessage(playerid, COLOR_LIGHTBLUE, "Lerakható útzárak:");
				Msg(playerid, "| 1: Kicsi útzár | 2: Közepes útzár |");
				Msg(playerid, "| 3: Nagy útzár | 4: Útelterelés Jelzés |");
				Msg(playerid, "| 5: Figyelmeztetõ tábla | 6: Sáv lezárás jelzés |");
				return 1;
		    }
	   		new rb = strval(param[2]);
	   		new Float:plocx,Float:plocy,Float:plocz,Float:ploca;
	   		if(rb == 1)
			{
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
		        GetPlayerPos(playerid, plocx, plocy, plocz);
		        GetPlayerFacingAngle(playerid,ploca);
		        UtzarLerak(1459,plocx,plocy,plocz,ploca);
		        Msg(playerid, "Útzár lerakva!");
				return 1;
			}
			else if(rb == 2)
			{
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
		        GetPlayerPos(playerid, plocx, plocy, plocz);
		        GetPlayerFacingAngle(playerid,ploca);
		        UtzarLerak(978, plocx, plocy, plocz+0.6, ploca);
		        Msg(playerid, "Útzár lerakva!");
				return 1;
			}
			else if(rb == 3)
			{
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
		        GetPlayerPos(playerid, plocx, plocy, plocz);
		        GetPlayerFacingAngle(playerid,ploca);
		        UtzarLerak(9605, plocx, plocy, plocz+0.9, ploca+180);
		        Msg(playerid, "Útzár lerakva!");
				return 1;
			}
			else if(rb == 4)
			{
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
		        GetPlayerPos(playerid, plocx, plocy, plocz);
		        GetPlayerFacingAngle(playerid,ploca);
		        UtzarLerak(1238, plocx, plocy, plocz+0.2, ploca);
		        Msg(playerid, "Útzár lerakva!");
				return 1;
			}
			else if(rb == 5)
			{
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
		        GetPlayerPos(playerid, plocx, plocy, plocz);
		        GetPlayerFacingAngle(playerid,ploca);
		        UtzarLerak(1425,plocx,plocy,plocz+0.6,ploca);
		        Msg(playerid, "Útzár lerakva!");
				return 1;
			}
			else if(rb == 6)
			{
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
		        GetPlayerPos(playerid, plocx, plocy, plocz);
		        GetPlayerFacingAngle(playerid,ploca);
		        UtzarLerak(3091,plocx,plocy,plocz+0.5,ploca+180);
				Msg(playerid, "Útzár lerakva!");
				return 1;
			}
		}
		else if(egyezik(param[1], "felvesz"))
		{
		    UtzarTorol(playerid);
	        GameTextForPlayer(playerid, "~w~Útzár ~r~Felvéve!",3000,1);
		}
	    return 1;
	}
	if(egyezik(cmd, "/molotov"))
	{
		//if(Szint(playerid) < 18) return Msg(playerid, "18-as szinttõl!");
		if(params < 1) return Msg(playerid, "/Molotov [Készít] [Darab]");
		if(egyezik(param[1], "készít") || egyezik(param[1], "keszit"))
		{
			if(PlayerInfo[playerid][pFuel][UZEMANYAGTIPUS_BENZIN] < 2) return Msg(playerid, "Nincs a kannádban elég benzin!");
			if(params != 2)
			{
				Msg(playerid, "/Molotov Készít [Darab]");
				Msg(playerid, "1db molotov koktélhoz 2 liter benzin kell és 1db gyújto.");
				return 1;
			}
			new menyit = strval(param[2]);
			new menyikell = menyit*2;
			if(menyikell > PlayerInfo[playerid][pFuel][UZEMANYAGTIPUS_BENZIN])
			{
				SendFormatMessage(playerid, COLOR_LIGHTRED, "* Enyi molotov koktélhoz %d Liter benzin kell, neked csak %d liter van.", menyikell, PlayerInfo[playerid][pFuel][UZEMANYAGTIPUS_BENZIN]);
				return 1;
			}
			if(UresUveg[playerid] < menyit)
			{
				SendFormatMessage(playerid, COLOR_LIGHTRED, "* Nincs elég üres üveged!(%d van csak), %d kell. (Úgy szerezhetsz, ha megiszol valamilyen italt!)", UresUveg[playerid], menyit);
				return 1;
			}
			new gyujto = PlayerInfo[playerid][pGyujto] - menyit;
			if(gyujto < 0) return Msg(playerid, "Nincs elég gyújtód.");
			UresUveg[playerid] -= menyit;
			PlayerInfo[playerid][pFuel][UZEMANYAGTIPUS_BENZIN] -= menyikell;
			PlayerInfo[playerid][pGyujto] -= menyit;

			GiveWeapon(playerid, 18, menyit);
			SendFormatMessage(playerid, COLOR_LIGHTBLUE, "* Csináltál %d üveg molotov koktélt.", menyit);
			Cselekves(playerid, "csinált egy molotov koktélt", 1);
		}
		return 1;
	}
	if(egyezik(cmd, "/lehallgat"))
	{
		if(!IsHitman(playerid) && !LMT(playerid, LMUNKA_FBI)) return 1;
		if(LMT(playerid, LMUNKA_FBI) && !PlayerToPoint(30.0, playerid, 285.105, 182.403, 1007.179) && !IsHitman(playerid)) return Msg(playerid, "Az NNI Fõépületében kell lenned.");
		if(LMT(playerid, LMUNKA_FBI) && !IsHitman(playerid)) return Msg(playerid, "/pda..");
		if(LMT(playerid, LMUNKA_FBI) && !Munkarang(playerid, 4)) return Msg(playerid, "Minimum 4-es rang.");
		if(params != 2) return Msg(playerid, "/lehallgat [Rádió] [Állomás]");
		if(egyezik(param[1], "rádió") || egyezik(param[1], "radio"))
		{
			new Allomas = strval(param[2]);
			if(egyezik(param[2], "kikapcsol") || egyezik(param[2], "off"))
			{
				Msg(playerid, "Kikapcsolva");
				RadioHallgatas[playerid] = NINCS;
				return 1;
			}
			if(Allomas < 1 || Allomas > MAX_FRAKCIO)
			{
				SendFormatMessage(playerid, COLOR_LIGHTRED, "* Rádió állomások: 1-%d", MAX_FRAKCIO);
				return 1;
			}
			RadioHallgatas[playerid] = Allomas;
			SendFormatMessage(playerid, COLOR_LIGHTBLUE, "* Csatlakozás sikeres. Állomás: %d", Allomas);
			Msg(playerid, "=============[Rádió Adatok]=============");
			
			new szneve[32];
			new szam = RadioHallgatas[playerid] - 1;
			szneve = Szervezetneve[szam][0];
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Szervezet Neve: %s", szneve);
			new menyien = 0;
            PlayerForeach(oj)
			{
				if(PlayerInfo[oj][pMember] == RadioHallgatas[playerid] || PlayerInfo[oj][pLeader] == RadioHallgatas[playerid]) menyien++;
			}
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* A rádiót %d-an/en hallgatják.", menyien);
			SendClientMessage(playerid, COLOR_YELLOW, "* Kikapcsoláshoz: /lehallgat rádió kikapcsol");
			Cselekves(playerid, "átkapcsolt a rádióján.", 1);
		}
		return 1;
	}
	if(strcmp(cmd, "/robbant", true) == 0)
	{
		if(IsValidPlayerID(playerid))
	    {
			if(!IsRicardo(playerid)) return HibasParancs(playerid, true);
			if(params < 1)
			{
				Msg(playerid, "/robbant [JátékosID/NévRészlet]");
				return 1;
			}
			new playa = ReturnUser(param[1]);
			{
			    if(IsValidPlayerID(playa))
			    {
			        if(playa != INVALID_PLAYER_ID)
			        {
						if(IsPlayerNPC(playa)) return Msg(playerid, "Hagyd békén az NPC-t!");
						
						if(IsRicardo(playa))
						{
							playa = playerid;
							Msg(playerid, "Kurva anyád!");
						}
						
						SetHealth(playa, 0);
						new Float:x, Float:y, Float:z;
						GetPlayerPos(playa, x, y, z);
						CreateExplosion(x, y, z, 7, 10);
						PlayerForeach(i)
						{
							if(PlayerToPoint(10, i, x, y, z))
							{
								SetHealth(i, 0);
							}
						}
						Msg(playerid, "Kábummm");
					}
				}
			}
		}
		return 1;
	}
	if(egyezik(cmd, "/kresz"))
	{
		if(params < 1) return Msg(playerid, "Használat: /kresz [Vizsga / Megnéz / Felmutat]");
		if(egyezik(param[1], "vizsga"))
		{
			if(!PlayerToPoint(1, playerid, -2035.0790, -117.5484, 1035.1719)) return Msg(playerid, "Nem vagy a számítógép elõtt!");
			if(PlayerInfo[playerid][pKresz] == 1) return Msg(playerid, "Már meg van a kresz vizsgád.");
			new vizsgaar = 150;
			if(GetMoney(playerid) < vizsgaar)
			{
				format(string, sizeof(string), "Nincs elég pénzed! A kresz vizsga ára $%s!", PenzTordeles(vizsgaar)); 
				Msg(playerid, string);
				return 1;
			}
			GiveMoney(playerid, -vizsgaar);
			FrakcioInfo[LMUNKA_OKTATO][fPenz] += vizsgaar;
			Kresz[playerid] = 1;
			format(string, sizeof(string), "Elkezdted a kresz vizsgát! 1 hiba bukás! $%s vizsgadíj levonva!", PenzTordeles(vizsgaar)); Msg(playerid, string);
			ShowPlayerDialog(playerid, DIALOG_KRESZ, DIALOG_STYLE_LIST, KreszKerdesek[Kresz[playerid]-1][0], KreszKerdesek[Kresz[playerid]-1][1], "Tovább", "Mégse");
		}
		else if(egyezik(param[1], "megnéz") || egyezik(param[1], "megnez"))
		{
			SendClientMessage(playerid, COLOR_YELLOW, ValasztoVonal("Kresz engedély"));
			if(PlayerInfo[playerid][pKresz] == 1) {
				Msg(playerid, "A kresz engedélyed érvényes!");
			} else {
				Msg(playerid, "A kresz engedélyed nem érvényes!");
			}
			SendClientMessage(playerid, COLOR_YELLOW, ValasztoVonal("Kresz engedély"));
		}
		else if(egyezik(param[1], "felmutat"))
		{
			if(PlayerInfo[playerid][pKresz] == 0) return Msg(playerid, "Nincs kresz engedélyed.");
			if(params != 2) return Msg(playerid, "Használat: /kresz felmutat [JátékosID/NévRészlet]");
			new Player = ReturnUser(param[2]);
			if(Player == INVALID_PLAYER_ID) return Msg(playerid, "Nincs ilyen játékos");
			if(playerid == Player) return Msg(playerid, "/kresz megnéz");
			if(!ProxDetectorS(1.5, playerid, Player)) return Msg(playerid, "Nincs a közeledben!");
			SendFormatMessage(Player, COLOR_YELLOW, "============= [ %s Kresz engedélye ] =============", PlayerName(playerid));
			SendFormatMessage(Player, COLOR_WHITE, "%s Kresz engedélye érvényes!", PlayerName(playerid));
			SendFormatMessage(Player, COLOR_YELLOW, "============= [ %s Kresz engedélye ] =============", PlayerName(playerid));
			Cselekves(playerid, "felmutatta a kresz engedélyét");
		}
		else Msg(playerid, "Használat: /kresz [Vizsga / Megnéz / Felmutat]");
		return 1;
	}
    if(egyezik(cmd, "/felvesz"))
	{
		if(params < 1) return Msg(playerid, "/felvesz [Fizetés / Mûanyag / Fém / Fegyver / Materials / Heroin / Kokain / Marihuana]");

		if(FloodCheck(playerid, cmd)) return 1;

		if(egyezik(param[1], "Fizetés") || egyezik(param[1], "Fizetes"))
		{
			if(PlayerInfo[playerid][pBankSzamla] != 0) return Msg(playerid, "Van bankszámlád, a fizetést oda kapod...");
			if(!Bankban(playerid)) return Msg(playerid, "Nem vagy bankbann!");
			if(PlayerInfo[playerid][pPayCheck] < 50) return Msg(playerid, "A fizetésednek minimum $50-nak kell lennie!");
			GiveMoney(playerid, PlayerInfo[playerid][pPayCheck]);
			FrakcioInfo[LMUNKA_ALLAM][fPenz] -= PlayerInfo[playerid][pPayCheck];
			SendFormatMessage(playerid, COLOR_LIGHTRED, "Fizetés felvéve! Összeg: $%d", PlayerInfo[playerid][pPayCheck]);
            PlayerInfo[playerid][pPayCheck] = 0;
            Cselekves(playerid, "felvette a fizetését...");
			return 1;
		}
		else if(egyezik(param[1], "nyeremény") || egyezik(param[1], "nyeremeny"))
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.0,1956.0851,1017.4251,992.4688))
			{
				SendFormatMessage(playerid,COLOR_GREEN, "Felvetted a nyereményt: $%d",KaszinoCsekk[playerid]);
				GiveMoney(playerid,KaszinoCsekk[playerid]);
				FrakcioInfo[LMUNKA_ALLAM][fPenz] -= KaszinoCsekk[playerid];
				KaszinoCsekk[playerid] = 0;
				Cselekves(playerid, "felvette a nyereményét.",0);
				return 1;
			}
		}
		else if(egyezik(param[1], "doboz"))
		{
			for(new i = 0; i < sizeof(PenzDropInfo); i++)
			{
				if(IsPlayerInRangeOfPoint(playerid, 2.0,ATMDrop[i][aPoz][0],ATMDrop[i][aPoz][1],ATMDrop[i][aPoz][2]) && GetPlayerVirtualWorld(playerid) == ATMDrop[i][aVW] && GetPlayerInterior(playerid) == ATMDrop[i][aInt])
				{
					ApplyAnimation(playerid, "MISC", "pickup_box",4.0,0,0,1,0,0);
					DestroyDynamicObject(ATMDrop[i][aObject]);
					ATMDrop[i][aObject] = NINCS;
					ATMDrop[i][aPoz][0] = 0.0;
					ATMDrop[i][aPoz][0]= 0.0;
					ATMDrop[i][aPoz][0] = 0.0;
					Doboz[playerid] = 1;
					//Cselekves(playerid, "felvett egy dobozt a földrõl.",0);
					return 1;
				}
			}
		}
		else if(egyezik(param[1], "pénz") || egyezik(param[1], "penz"))
		{
			for(new i = 0; i < sizeof(PenzDropInfo); i++)
			{
				if(IsPlayerInRangeOfPoint(playerid, 2.0,PenzDropInfo[i][PenzX],PenzDropInfo[i][PenzY],PenzDropInfo[i][PenzZ]) && GetPlayerVirtualWorld(playerid) == PenzDropInfo[i][PenzVW] && GetPlayerInterior(playerid) == PenzDropInfo[i][PenzInt])
				{
					ApplyAnimation(playerid, "MISC", "pickup_box",4.0,0,0,1,0,0);
					DestroyDynamicObject(EldobottPenzObject[i]);
					EldobottPenzObject[i] = NINCS;
					GiveMoney(playerid,PenzDropInfo[i][PenzOsszeg]);
					PenzDropInfo[i][PenzX] = 0.0;
					PenzDropInfo[i][PenzY] = 0.0;
					PenzDropInfo[i][PenzZ] = 0.0;
					PenzDropInfo[i][PenzOsszeg] = 0;
					//Cselekves(playerid, "felvett egy kis pénzt a földrõl.",0);
					return 1;
				}
			}
		}
		else if(egyezik(param[1], "fegyver"))
		{
		    //if(Szint(playerid) < FEGYVERHASZNALATSZINT) return Msg(playerid, "Nem használhatsz fegyvert!");
			for(new i = 0; i < sizeof(DropInfo); i++)
			{
				if(IsPlayerInRangeOfPoint(playerid, 1.0,DropInfo[i][FegyverEldobPosX],DropInfo[i][FegyverEldobPosY],DropInfo[i][FegyverEldobPosZ]) && GetPlayerVirtualWorld(playerid) == DropInfo[i][FegyverEldobVWorld] && GetPlayerInterior(playerid) == DropInfo[i][FegyverEldobInterior])
				{
					DestroyDynamicObject(EldobottFegyverObject[i]);
					EldobottFegyverObject[i] = NINCS;
					ApplyAnimation(playerid, "MISC", "pickup_box",4.0,0,0,1,0,0);
					GiveWeapon(playerid, DropInfo[i][FegyverEldobAmmount][0], DropInfo[i][FegyverEldobAmmount][1]);
					DropInfo[i][FegyverEldobPosX] = 0.0;
					DropInfo[i][FegyverEldobPosY] = 0.0;
					DropInfo[i][FegyverEldobPosZ] = 0.0;
					DropInfo[i][FegyverEldobAmmount][0] = 0;
					DropInfo[i][FegyverEldobAmmount][1] = 0;
					//Cselekves(playerid, "felvett egy fegyvert a földrõl.",0);
					FegyverElrak(playerid);
					return 1;
				}
			}
		}
		else if(egyezik(param[1], "Mûanyag") || egyezik(param[1], "Muanyag"))
		{
			if(!PlayerToPoint(3, playerid, 90.638587, -183.727081, 1.484375) && !PlayerToPoint(3, playerid, 1204.882, 252.871, 19.554)) return Msg(playerid, "Nem vagy mûanyag felvevõ helyen!");

			if(PlayerInfo[playerid][pMuanyag] >= MAXMUANYAG) return Msg(playerid, "Enyi mûanyagot nem bírsz el!");

	    	if(GetMoney(playerid) < 500) return Msg(playerid, "Nincs elég pénzed! (500Ft)");
    		GameTextForPlayer(playerid, "~w~~n~~n~~n~~n~~n~~n~~n~~n~~n~Felvettel 1 mûanyagdobozt...", 3000, 3);
			PlayerInfo[playerid][pMuanyag]++;
			GiveMoney(playerid, -500);
			//BizPenz(BIZ_MUANYAG, 500);
			Cselekves(playerid, "felvett egy mûanyagdobozt...");
			return 1;
		}
		else if(egyezik(param[1], "fém") || egyezik(param[1], "fem"))
		{
			if(PlayerInfo[playerid][pFem] >= MAXFEM) return Msg(playerid, "Nem fér el nálad ennyi fém!");
			if(!PlayerToPoint(5, playerid, 321.2111,-45.0681,1.5693))
			{
				Msg(playerid, "Nem itt kell felvenni(térképen jelöltük)");
				SetPlayerCheckpoint(playerid, 321.2111,-45.0681,1.5693, 5);
				return 1;
			}
			if(GetMoney(playerid) < 6000) return Msg(playerid, "6000 forint...");
			PlayerInfo[playerid][pFem]++;
			Cselekves(playerid, "felvett egy fémdarabot.", 0);
			GiveMoney(playerid, -6000);
			//BizPenz(BIZ_MUANYAG, 6000);
			return 1;
		}
		else if(egyezik(param[1], "materials") || egyezik(param[1], "mati"))
		{
		    for(new i = 0; i < sizeof(DrogInfo); i++)
			{
				if(IsPlayerInRangeOfPoint(playerid, 1.0,DrogInfo[i][DrogEldobPosX],DrogInfo[i][DrogEldobPosY],DrogInfo[i][DrogEldobPosZ]) && GetPlayerVirtualWorld(playerid) == DrogInfo[i][DrogEldobVWorld] && GetPlayerInterior(playerid) == DrogInfo[i][DrogEldobInterior] && DrogInfo[i][DrogEldobObject] == 2040)
				{
					DestroyDynamicObject(DrogObject[i]);
					DrogObject[i] = NINCS;
					ApplyAnimation(playerid, "MISC", "pickup_box",4.0,0,0,1,0,0);
					PlayerInfo[playerid][pMats] += DrogInfo[i][DrogEldobDarab];
					DrogInfo[i][DrogEldobPosX] = 0.0;
					DrogInfo[i][DrogEldobPosY] = 0.0;
					DrogInfo[i][DrogEldobPosZ] = 0.0;
					DrogInfo[i][DrogEldobDarab] = 0;
					Cselekves(playerid, "felvett néhány matit a földrõl.",0);
					return 1;
				}
			}
		}
		else if(egyezik(param[1], "heroin"))
		{
		    for(new i = 0; i < sizeof(DrogInfo); i++)
			{
				if(IsPlayerInRangeOfPoint(playerid, 1.0,DrogInfo[i][DrogEldobPosX],DrogInfo[i][DrogEldobPosY],DrogInfo[i][DrogEldobPosZ]) && GetPlayerVirtualWorld(playerid) == DrogInfo[i][DrogEldobVWorld] && GetPlayerInterior(playerid) == DrogInfo[i][DrogEldobInterior] && DrogInfo[i][DrogEldobObject] == 1577)
				{
					DestroyDynamicObject(DrogObject[i]);
					DrogObject[i] = NINCS;
					ApplyAnimation(playerid, "MISC", "pickup_box",4.0,0,0,1,0,0);
					PlayerInfo[playerid][pHeroin] += DrogInfo[i][DrogEldobDarab];
					DrogInfo[i][DrogEldobPosX] = 0.0;
					DrogInfo[i][DrogEldobPosY] = 0.0;
					DrogInfo[i][DrogEldobPosZ] = 0.0;
					DrogInfo[i][DrogEldobDarab] = 0;
					Cselekves(playerid, "felvett néhány heroint a földrõl.",0);
					return 1;
				}
			}
		}
		else if(egyezik(param[1], "kokain"))
		{
		    for(new i = 0; i < sizeof(DrogInfo); i++)
			{
				if(IsPlayerInRangeOfPoint(playerid, 1.0,DrogInfo[i][DrogEldobPosX],DrogInfo[i][DrogEldobPosY],DrogInfo[i][DrogEldobPosZ]) && GetPlayerVirtualWorld(playerid) == DrogInfo[i][DrogEldobVWorld] && GetPlayerInterior(playerid) == DrogInfo[i][DrogEldobInterior] && DrogInfo[i][DrogEldobObject] == 1575)
				{
					DestroyDynamicObject(DrogObject[i]);
					DrogObject[i] = NINCS;
					ApplyAnimation(playerid, "MISC", "pickup_box",4.0,0,0,1,0,0);
					PlayerInfo[playerid][pKokain] += DrogInfo[i][DrogEldobDarab];
					DrogInfo[i][DrogEldobPosX] = 0.0;
					DrogInfo[i][DrogEldobPosY] = 0.0;
					DrogInfo[i][DrogEldobPosZ] = 0.0;
					DrogInfo[i][DrogEldobDarab] = 0;
					Cselekves(playerid, "felvett néhány kokaint a földrõl.",0);
					return 1;
				}
			}
		}
		else if(egyezik(param[1], "marihuana"))
		{
		    for(new i = 0; i < sizeof(DrogInfo); i++)
			{
				if(IsPlayerInRangeOfPoint(playerid, 1.0,DrogInfo[i][DrogEldobPosX],DrogInfo[i][DrogEldobPosY],DrogInfo[i][DrogEldobPosZ]) && GetPlayerVirtualWorld(playerid) == DrogInfo[i][DrogEldobVWorld] && GetPlayerInterior(playerid) == DrogInfo[i][DrogEldobInterior] && DrogInfo[i][DrogEldobObject] == 1578)
				{
					DestroyDynamicObject(DrogObject[i]);
					DrogObject[i] = NINCS;
					ApplyAnimation(playerid, "MISC", "pickup_box",4.0,0,0,1,0,0);
					PlayerInfo[playerid][pMarihuana] += DrogInfo[i][DrogEldobDarab];
					DrogInfo[i][DrogEldobPosX] = 0.0;
					DrogInfo[i][DrogEldobPosY] = 0.0;
					DrogInfo[i][DrogEldobPosZ] = 0.0;
					DrogInfo[i][DrogEldobDarab] = 0;
					Cselekves(playerid, "felvett néhány marihuanát a földrõl.",0);
					return 1;
				}
			}
		}
		else
			Msg(playerid, "/felvesz [Fizetés / Mûanyag / Fém / Fegyver / Materials / Heroin / Kokain / Marihuana]");

		return 1;
	}
	if(egyezik(cmd, "/jelszóváltás") || egyezik(cmd, "/jelszovaltas"))
	{
		if(Nincsbelepve(playerid)) return 1;
		if(params != 1) return Msg(playerid, "Használata: /jelszóváltás [jelszó] | FONTOS: A jelszó ne tartalmazzon ékezetet,szóközt,és speciális karaktereket.");

		if(strlen(param[1]) > MAX_PASSWORD_HOSSZ)
		{
			MsgFormat(playerid, "Maximum %d karakter!", MAX_PASSWORD_HOSSZ);	
			return 1;
		}
		
		if(!real_escape_string(param[1])) return Msg(playerid, "Tiltott karakterek a jelszóban!");
		
		new buf[145];
		SHA256_PassHash(param[1], SALT_NORMALPW, buf, sizeof(buf));
		strmid(PlayerInfo[playerid][pKey], buf, 0, strlen(buf));
		SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Új Jelszavad a Szerveren: %s", param[1]);
		PlayerUpdate(playerid, "Pass='%s'", buf);
		new uzenet[100];
		Format(uzenet, "%s jelszót változtatott a karakterén", PlayerName(playerid));
		ABroadCast(COLOR_LIGHTRED, uzenet, 1);
		return 1;
	}
	if(egyezik(cmd, "/alefoglal"))
	{
		if(!Admin(playerid, 1)) return HibasParancs(playerid, true);
		if(!IsAdminSzolis(playerid)) return Msg(playerid, "Ezt a parancsot csak AdminSzolgálatban használhatod!", COLOR_ADMIN);
		new kocsi = GetClosestVehicle(playerid);
		
		if(GetDistanceToVehicle(playerid, kocsi) > 5) return iMsg(playerid, "Nincs a közelben jármû");
		
		/*if(!IsRicardo(playerid)) {
			ABroadCastFormat(COLOR_LIGHTRED, 1, "%s lefoglalt egy jármûvet! Rendszám: %d / Model: %s", PlayerName(playerid), kocsi, GetVehicleModelName(kocsi, true));
		}*/
		
		PutPlayerInVehicle(playerid, kocsi, 0);
		Lefoglalt[playerid] = 1;
		
		engineOn[kocsi] = 1;
		SetJarmu(kocsi, KOCSI_MOTOR, true);
		
		//Msg(playerid, "Lefoglaltad a jármûvet és beindítottad a motorját!");
		PlayerTextFormat(playerid, "~g~Jármû lefoglalva!~n~ID: ~w~%d", kocsi);
		GameTextForPlayer(playerid, PlayerText[playerid], 3*1000, 3);
		
		return 1;
	}
	if(egyezik(cmd, "/vontat"))
	{
		if(Nincsbelepve(playerid)) return 1;
		if(veh == -1) return Msg(playerid, "Nem vagy kocsiban!");
		if(Bikes(veh)) return Msg(playerid, "Persze...");
		new Vontatokocsi;
		for(new x = 0; x < sizeof(Vontatokocsik); x++){ if(pveh == Vontatokocsik[x]) {Vontatokocsi = 1; break;} }
		new kocsi = GetClosestVehicle(playerid, false);
		
		if(GetDistanceToVehicle(playerid, kocsi) > 10) return Msg(playerid, "A közelben nincs jármû!");
		if(!Vontatokocsi && GetVehicleModel(veh) != 531 && GetVehicleModel(kocsi) != 610 && GetVehicleTrailer(veh) == 0) return Msg(playerid, "Ezzel a kocsival nem lehet vontatni!");
		
		if(GetVehicleTrailer(veh) == 0)
			AttachTrailerToVehicle(kocsi, veh);
		else
			DetachTrailerFromVehicle(veh);
		
		return 1;
	}
    if(egyezik(cmd, "/eldob"))
	{
		if(NemMozoghat(playerid)) return Msg(playerid, "Jelenleg nem dobhatsz el semmit!");
		if(LoterenGyakorol[playerid] == 1) return Msg(playerid, "Te most a lõtéren gyakorolsz ezért nem használhatod ezt a parancsot!");
		if(KezdoJatekos(playerid))
		{
			MsgFormat(playerid, "Ehhez a parancshoz minimum %d. szint szükséges!", MINSZINT);	
			return 1;
		}	
		if(params < 1)
		{
			SCM(playerid, COLOR_LIGHTBLUE, ValasztoVonal("Eldobható tárgyak listája"));
			Msg(playerid, "Használat: /eldob [mit]");
			Msg(playerid, "pénz, mûanyag, telefon, gyémánt, cannabismag, mákmag, kokacserjemag, kevlar, rádió, erádió");
			Msg(playerid, "fegyver (mennyit), materials (mennyit), heroin (mennyit), kokain (mennyit), marihuana (mennyit)");
			SCM(playerid, COLOR_LIGHTBLUE, ValasztoVonal("Eldobható tárgyak listája"));
			return 1;
		}
		if(egyezik(param[1], "erádió") || egyezik(param[1], "eradio"))
		{
		    if(PlayerInfo[playerid][pVokitoki] == 0) return Msg(playerid, "Nincs rádiója!");
			
			PlayerInfo[playerid][pVokitoki] = 0;
			
			GetPlayerName(playerid, sendername, sizeof(sendername));
			
			strmid(ElvettRadio[playerid][rNev], sendername, 0, strlen(sendername), 25);
			ElvettRadio[playerid][rFrakcio] = NINCS;
			ElvettRadio[playerid][rRang] = NINCS;
			
			Cselekves(playerid, "eldobta a rádióját",1);
		}
		if(egyezik(param[1], "rádió") || egyezik(param[1], "radio"))
		{
		    if(PlayerInfo[playerid][pVokitoki] == 0) return Msg(playerid, "Nincs rádiója!");
			
			PlayerInfo[playerid][pVokitoki] = 0;
			
			/*GetPlayerName(playerid, sendername, sizeof(sendername));
			
			strmid(ElvettRadio[playerid][rNev], sendername, 0, strlen(sendername), 25);
			ElvettRadio[playerid][rFrakcio] = NINCS;
			ElvettRadio[playerid][rRang] = NINCS;*/
			
			Cselekves(playerid, "eldobta a rádióját",1);
		}
		if(egyezik(param[1], "pénz") || egyezik(param[1], "penz"))
		{
			//if(Szint(playerid) < FEGYVERHASZNALATSZINT) return Msg(playerid, "Nem használhatsz fegyvert!");
			new Float:X,Float:Y,Float:Z;
			new Penzze = GetMoney(playerid);
			if(Penzze <= 0) return Msg(playerid, "Nincs nálad pénz!");
			GetPlayerPos(playerid, X, Y, Z);
			PenzEldob(Penzze, X, Y, Z, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
 			Cselekves(playerid,  "eldobott valamennyi pénzt", 0);
			ResetMoney(playerid);
			return 1;
		}
		if(egyezik(param[1], "fegyver"))
		{
			//if(!IsRicardo(playerid)) return Msg(playerid, "Bugoltatás miatt kiszedve. Ügyesek vagytok (y)");
		    if(FloodCheck(playerid,cmd, 3)) return 1;
			new Float:X,Float:Y,Float:Z;
			new GunID = GetPlayerWeapon(playerid);
			if(GunID == 0) return Msg(playerid, "Nincs a kezedben fegyver!");
			//if(params != 2) return Msg(playerid, "/eldob fegyver (mennyit)");
			//new GunAmmo = strval(param[2]);
			new GunAmmo;
			if(params == 2)
				GunAmmo = strval(param[2]);
			else
				GunAmmo = GetPlayerAmmo(playerid);
			if(GunAmmo <= 0) return Msg(playerid, "Minimum 1-et el kell dobnod...");
			if(GetPlayerAmmo(playerid) < GunAmmo)
			{
				SendClientMessage(playerid, COLOR_LIGHTGREEN, "Nincs ennyi lõszered!");
				return 1;
			}
			GetPlayerPos(playerid, X, Y, Z);
			FegyverEldob(GunID, GunAmmo, X, Y, Z, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
 			Cselekves(playerid,  "eldobta a kezében levõ fegyvert", 0);
			//FegyverElvesz(playerid,GunID);
			//GiveWeapon(playerid, GunID, GetPlayerAmmo(playerid) - GunAmmo);
			GiveWeapon(playerid, GunID, -GunAmmo);
			return 1;
		}
		if(egyezik(param[1], "fém") || egyezik(param[1], "fem"))
		{
			PlayerInfo[playerid][pFem] = 0;
			Cselekves(playerid, "eldobja a nála lévõ fémdarabokat", 1);
			return 1;
		}
		if(egyezik(param[1], "telefon"))
		{
			if(PlayerInfo[playerid][pPnumber] == 0)	return Msg(playerid, "Már eldobtad a telefonod!");
			PlayerInfo[playerid][pPnumber] = 0;
			Cselekves(playerid,  "eldobja a telefonját.", 0);
			PlayerForeach(x)
			{
				if(!IsValidPlayerID(x) || IsPlayerNPC(x) || !Logged(x)) continue;
				SetPlayerMarkerForPlayer(x, playerid, 0xFFFFFF00);
			}
			return 1;
		}
		if(egyezik(param[1], "cserje"))
		{
			PlayerInfo[playerid][pCserje] = 0;
 			Cselekves(playerid,  "eldobja a cserjéit.");
			return 1;
		}
		if(egyezik(param[1], "mák") || egyezik(param[1], "mak"))
		{
			PlayerInfo[playerid][pMak] = 0;
 			Cselekves(playerid,  "eldobja a mákjait.");
			return 1;
		}
		if(egyezik(param[1], "cannabis"))
		{
			PlayerInfo[playerid][pCannabis] = 0;
 			Cselekves(playerid,  "eldobja a cannabist a zsebébõl.", 0);
			return 1;
		}
		else if(egyezik(param[1], "mûanyag") || egyezik(param[1], "muanyag"))
		{
			PlayerInfo[playerid][pMuanyag] = 0;
 			Cselekves(playerid,  "eldobja a mûanyagokat.", 0);
			return 1;
		}
		else if(egyezik(param[1], "mákmag"))
		{
			PlayerInfo[playerid][pMakMag] = 0;
			Cselekves(playerid,  "eldobja a mák magjait.", 0);
			return 1;
		}
		else if(egyezik(param[1], "cannabismag"))
		{
			PlayerInfo[playerid][pCannabisMag] = 0;
			Cselekves(playerid,  "eldobja a cannabis magjait.", 0);
			return 1;
		}
		else if(egyezik(param[1], "cserjemag"))
		{
			PlayerInfo[playerid][pCserjeMag] = 0;
			Cselekves(playerid,  "eldobja a kokacserje magjait.", 0);
			return 1;
		}
		else if(egyezik(param[1], "materials") || egyezik(param[1], "mati"))
		{
            //if(params != 2) return Msg(playerid, "/eldob materials (mennyit)");
			//new db = strval(param[2]);
			new db;
			if(params == 2)
				db = strval(param[2]);
			else
				db = PlayerInfo[playerid][pMats];
			if(db <= 0) return Msg(playerid, "Minimum 1-et el kell dobnod...");
			if(PlayerInfo[playerid][pMats] < db)
			{
				SendClientMessage(playerid, COLOR_LIGHTGREEN, "Nincs ennyi Matid!");
				return 1;
			}
				
			PlayerInfo[playerid][pMats] -= db;
			new Float:X,Float:Y,Float:Z;
			GetPlayerPos(playerid, X, Y, Z);
			DrogLerak(2040, db, X, Y, Z, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
			Cselekves(playerid, "eldob néhány materialt.", 0);
			return 1;
		}
		else if(egyezik(param[1], "heroin"))
		{
            //if(params != 2) return Msg(playerid, "/eldob heroin (mennyit)");
			//new db = strval(param[2]);
			new db;
			if(params == 2)
				db = strval(param[2]);
			else
				db = PlayerInfo[playerid][pHeroin];
			if(db <= 0) return Msg(playerid, "Minimum 1-et el kell dobnod...");
			if(PlayerInfo[playerid][pHeroin] < db)
			{
				SendClientMessage(playerid, COLOR_LIGHTGREEN, "Nincs ennyi heroinod!");
				return 1;
			}
			
			PlayerInfo[playerid][pHeroin] -= db;
			new Float:X,Float:Y,Float:Z;
			GetPlayerPos(playerid, X, Y, Z);
			DrogLerak(1577, db, X, Y, Z, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
			Cselekves(playerid, "eldob egy kis heroint.", 0);
			return 1;
		}
		else if(egyezik(param[1], "kokain"))
		{
            //if(params != 2) return Msg(playerid, "/eldob kokain (mennyit)");
			//new db = strval(param[2]);
			new db;
			if(params == 2)
				db = strval(param[2]);
			else
				db = PlayerInfo[playerid][pKokain];
			if(db <= 0) return Msg(playerid, "Minimum 1-et el kell dobnod...");
			if(PlayerInfo[playerid][pKokain] < db)
			{
				SendClientMessage(playerid, COLOR_LIGHTGREEN, "Nincs ennyi kokainod!");
				return 1;
			}
			
			PlayerInfo[playerid][pKokain] -= db;
			new Float:X,Float:Y,Float:Z;
			GetPlayerPos(playerid, X, Y, Z);
			DrogLerak(1575, db, X, Y, Z, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
			Cselekves(playerid, "eldob egy kis kokaint.", 0);
			return 1;
		}
		else if(egyezik(param[1], "marihuana"))
		{
            //if(params != 2) return Msg(playerid, "/eldob marihuana (mennyit)");
			//new db = strval(param[2]);
			new db;
			if(params == 2)
				db = strval(param[2]);
			else
				db = PlayerInfo[playerid][pMarihuana];
			if(db <= 0) return Msg(playerid, "Minimum 1-et el kell dobnod...");
			if(PlayerInfo[playerid][pMarihuana] < db)
			{
				SendClientMessage(playerid, COLOR_LIGHTGREEN, "Nincs ennyi marihuanád!");
				return 1;
			}
			
			PlayerInfo[playerid][pMarihuana] -= db;
			new Float:X,Float:Y,Float:Z;
			GetPlayerPos(playerid, X, Y, Z);
			DrogLerak(1578, db, X, Y, Z, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
			Cselekves(playerid, "eldob egy kis marihuanát.", 0);
			return 1;
		}
		else if(egyezik(param[1], "kevlar") || egyezik(param[1], "mellény") || egyezik(param[1], "melleny"))
		{
			SetPlayerArmour(playerid, 0.0);
			Cselekves(playerid,  "eldobja a golyóálló mellényét.", 0);
			return 1;
		}
	}
	if(egyezik(cmd, "/visz"))
	{
		if(Nincsbelepve(playerid)) return 1;
		if(Tevezik[playerid] != NINCS) return Msg(playerid, "Szerinted miért nem mûködik neked a /gethere parancs? -.-");
		if(Visz[playerid] != NINCS)
		{
			SendClientMessage(playerid, COLOR_LIGHTBLUE, "Elengedted");
			Visz[playerid] = NINCS;
			return 1;
		}
		new jatekos;
		if(params > 0)
			jatekos = strval(param[1]);
		else
			jatekos = GetClosestPlayer(playerid);

		if(IsPlayerNPC(jatekos) && !IsFejleszto(playerid)) return Msg(playerid, "Hagyd békén az NPC-t!");
		if(PlayerCuffed[jatekos] == 2 && !IsACop(playerid))
			return Msg(playerid, "Nem vagy rendõr!");

		if(Bortonben(jatekos)) return Msg(playerid, "Nem kéne...igy a rácsokon keresztül...");
		if(PlayerToPoint(20.0,playerid,293.1098,-26.5718,1001.5156)) return Msg(playerid, "Lõtéren nem!");
		if(PlayerCuffed[jatekos] != 2 && !PlayerTied[jatekos] && !Leutve[jatekos] && Animban[jatekos] == 0)
			return Msg(playerid, "A játékos nincs megbilincselve / megkötözve / leütve / Animban");

		if(!IsValidPlayerID(jatekos)) return 1;

		if(ProxDetectorS(5, playerid, jatekos))
		{
			Visz[playerid] = jatekos;
			Msg(playerid, "Megfogtad és viszed...");
			TogglePlayerControllable(jatekos, false);

			if(!Leutve[jatekos])
				ApplyAnimation(jatekos, "SWORD", "sword_block",50.0,0,1,1,1,1);
		}
		else
			Msg(playerid, "Nincs senki a közeledben!");
		return 1;
	}
	
	#if defined FRAKCIOKOCSIK
	if(egyezik(cmd, "/frakciókocsi") || egyezik(cmd, "/frakciokocsi") || egyezik(cmd, "/fk"))
	{
	    if(Logged(playerid))
	    {
	        if(Civil(playerid)) return Msg(playerid, "Civil vagy...");
		    if(params < 1)
	     	{
	      		Msg(playerid, "Használata: /frakciókocsi [funkció]");
	      		Msg(playerid, "Funkciók: park, zár, szin, elad, vesz, Lista");
	      		return 1;
	      	}
			if(egyezik(param[1], "lista"))
			{
			    if(PlayerInfo[playerid][pMember] != 0)
			    {
				    new h, eddig, osszeselado;
				    SCM(playerid, COLOR_LIGHTBLUE, ValasztoVonal("Frakció jármûvek"));
				    format(string, sizeof(string), "");
				    for(h = 0; h < MAXVSKOCSI; h++)
				    {
				        if(CarInfo[h][Van] == 1)
				        {
				            if(CarInfo[h][cOwned] != 0 && PlayerInfo[playerid][pMember] == CarInfo[h][cFrakcio])
				            {
				                eddig++;
				                osszeselado++;
				                format(string, sizeof(string), "%s %d[%s]", string,CarInfo[h][cId],GetVehicleModelName(GetVehicleModel(CarInfo[h][cId])-400));

				                if(eddig == MAXCUCCPERSOR)
				                {
					                Msg(playerid, string);
					                format(string, sizeof(string), "");
					                eddig = 0;
				                }
				            }
				        }

			            if((h+1) == MAXVSKOCSI)
			            {
			                if(osszeselado == 0)
			                	Msg(playerid, "A frakciónak nincs tulajdonába jármû!");
							else if(eddig > 0)
			    				Msg(playerid, string);
            			}
				    }
					//SCM(playerid, COLOR_LIGHTBLUE, ValasztoVonal("Frakció jármûvek"));
				}
			}
			else if(egyezik(param[1], "minrang"))
	        {
	            new vs = IsAVsKocsi(GetPlayerVehicleID(playerid));
	            if(PlayerInfo[playerid][pLeader] < 1) return Msg(playerid, "Csak Leader!");
	            if(!IsPlayerInAnyVehicle(playerid)) return Msg(playerid, "Nem vagy jármûben!");
				if(CarInfo[vs][cFrakcio] != PlayerInfo[playerid][pLeader]) return Msg(playerid, "Ez nem a te frakciód jármûve!");
	            if(params < 2)
				{
					SendFormatMessage(playerid, COLOR_LIGHTRED, "/fk minrang [0-%d]", MAX_FRAKCIO_RANG);

					SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Jelenleg %d rangtól lehet elvinni.", CarInfo[vs][cMinRang]);
					return 1;
				}
				new rang = strval(param[2]);
				if(rang < 0 || rang > MAX_FRAKCIO_RANG)
				{
					SendFormatMessage(playerid, COLOR_LIGHTRED, "0-%d", MAX_FRAKCIO_RANG);
					return 1;
				}
				CarInfo[vs][cMinRang] = rang;
				SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* A jármûvet mostantól %d rangtól lehet elvinni.", rang);
				CarUpdate(vs,CAR_MinRang);
	        }
	      	else if(egyezik(param[1], "park"))
	        {
	            if(PlayerInfo[playerid][pLeader] < 1) return Msg(playerid, "Csak Leader!");
	            new Float:x, Float:y, Float:z, Float:a, carid;

				carid = GetClosestVehicle(playerid);
				if(GetDistanceToVehicle(playerid, carid) > 5.5)
					return Msg(playerid, "A közeledben nincs jármû!");

				new kocsi = IsAVsKocsi(carid);
				if(kocsi == NINCS)
					return Msg(playerid, "Ez nem V-s jármû!");

                if(CarInfo[kocsi][cFrakcio] == 0) return Msg(playerid, "Ez nem frakciókocsi!");
				if(CarInfo[kocsi][cFrakcio] != PlayerInfo[playerid][pLeader])
					return Msg(playerid, "Ez nem a te frakciód kocsija!");

               	new Melo = PlayerInfo[playerid][pLeader];
				if(!PlayerToPoint(150, playerid, FrakcioInfo[Melo][fPosX], FrakcioInfo[Melo][fPosY], FrakcioInfo[Melo][fPosZ])) return Msg(playerid, "HQ-ra parkold a jármûveket! (ha a széf intibe van, rakasd át!)");

				GetVehiclePos(carid, x, y, z);
				GetVehicleZAngle(carid, a);

				format(string, sizeof(string), "~n~~g~Leparkoltad");
				GameTextForPlayer(playerid, string, 10000, 3);

                GetDamageStat(carid);

				ParkCar(kocsi,  x, y, z, a, GetPlayerVirtualWorld(playerid),GetPlayerInterior(playerid));
				if(IsPlayerInVehicle(playerid, carid))
				{
					TogglePlayerControllable(playerid, 1);
					SetPlayerPos(playerid, x, y, z + 1);
				}

				return 1;
	        }
	        else if(egyezik(param[1], "zár") || egyezik(param[1], "zar") || egyezik(param[1], "lock"))
	        {
                new carid;
				carid = GetClosestVehicle(playerid);
				if(GetDistanceToVehicle(playerid, carid) > 5.5)
					return Msg(playerid, "A közeledben nincs jármû!");

				new vs;
				vs = IsAVsKocsi(carid);

				if(vs == NINCS) return Msg(playerid, "Ez a jármû a módba van beleírva!");
				if(CarInfo[vs][cFrakcio] == 0) return Msg(playerid, "Ez nem frakciókocsi!");
				if(!LMT(playerid,CarInfo[vs][cFrakcio])) return Msg(playerid, "Ez nem a te frakciód kocsija!");
				if(CarInfo[vs][cMinRang] > PlayerInfo[playerid][pRank]) return Msg(playerid, "Nincs elég rangod!");

				if(CarInfo[vs][cLock] == 1)
				{
					UnLockCar(carid);
					format(string, sizeof(string), "~w~Jármû~n~~g~nyitva");
					GameTextForPlayer(playerid, string, 4000, 3);
					CarInfo[vs][cLock] = 0;

					Cselekves(playerid, "kinyitotta a jármûvét.",0);
				}
				else
				{
					LockCar(carid);
					format(string, sizeof(string), "~w~Jármû~n~~r~zárva");
					GameTextForPlayer(playerid, string, 4000, 3);
					CarInfo[vs][cLock] = 1;
					Cselekves(playerid, "bezárta a jármûvét.", 0);
				}
				CarUpdate(vs, CAR_Lock);
				return 1;
	        }
	        else if(egyezik(param[1], "color") || egyezik(param[1], "szin") || egyezik(param[1], "szín"))
	        {
	            //if(PlayerInfo[playerid][pLeader] < 1) return Msg(playerid, "Csak Leader!");
				if(!IsAt(playerid, IsAt_Festo)) return Msg(playerid, "Nem vagy egy festõnél sem! (Pay 'n' Spray)");
				if(PlayerInfo[playerid][pSzerelo] == 0) return Msg(playerid, "Nem vagy szerelõ!");

				new kocsi, vs;
				kocsi = GetClosestVehicle(playerid);
				if(GetDistanceToVehicle(playerid, kocsi) > 5.5)
					return Msg(playerid, "A közeledben nincs jármû!");

				vs = IsAVsKocsi(kocsi);
				if(vs == NINCS)
					return Msg(playerid, "Ez a jármû a módba van beleírva!");

				if(CarInfo[vs][cFrakcio] == 0) return Msg(playerid, "Ez nem frakciókocsi!");
				//if(!LMT(playerid,CarInfo[vs][cFrakcio])) return Msg(playerid, "Ez nem a te frakciód kocsija!");

	        	if(GetMoney(playerid) < 50000) return Msg(playerid, "Nincs elég pénzed! A festés ra 50,000Ft");

	        	if(params < 3) return Msg(playerid, "Használata: /fk szin [szín1] [szín2] - A színek megtekinthetõek a wikipédián!");

				new color1 = strval(param[2]);
				if(color1 < 0 && color1 > 126) return Msg(playerid, "A szín minimum 0 és max 126 lehet!");

				new color2 = strval(param[3]);
				if(color2 < 0 && color2 > 126) return Msg(playerid, "A szín minimum 0 és max 126 lehet!");

				if(CarInfo[vs][cColorOne] != color1 || CarInfo[vs][cColorTwo] != color2)
					CarInfo[vs][cPainted] = 1;
				else
					CarInfo[vs][cPainted] = 0;

       			CarInfo[vs][cColorOne] = color1;
                CarInfo[vs][cColorTwo] = color2;
				GiveMoney(playerid, -50000);
				//BizPenz(BIZ_TUNING, 50000);
                GameTextForPlayer(playerid, "~w~Ujrafestve!~n~~r~-50,000Ft", 5000, 1);
				SetVehicleColor(kocsi, color1, color2);

				CarUpdate(vs, CAR_ColorOne, CAR_ColorTwo);

				return 1;
	        }
	        else
	        {
	            Msg(playerid, "Használata: /frakciókocsi [funkció]");
	      		Msg(playerid, "Funkciók: park, zár, szin, elad, vesz");
	      		return 1;
	        }
		}
		return 1;
	}
	#endif
	if(egyezik(cmd, "/v") || egyezik(cmd, "/vehicle"))
	{
	    if(Nincsbelepve(playerid)) return 1;
		if(params < 1)
		{
			Msg(playerid, "Használata: (/v)ehicle [funkció]");
			Msg(playerid, "Funkciók: Vesz / Park / Repair");
			return 1;
		}

		if(egyezik(param[1], "info") OR egyezik(param[1], "infó"))
		{
			if(!Admin(playerid, 1)) return HibasParancs(playerid, true);
			new kocsistring[256], kocsitulaj[64];
			new carid = GetClosestVehicle(playerid);
			if(GetDistanceToVehicle(playerid, carid) > 5.5) return Msg(playerid, "A közeledben nincs jármû!", COLOR_ADMIN);

			new kocsi = IsAVsKocsi(carid);

			if(kocsi == NINCS) return Msg(playerid, "Ez a jármû a módba van beleírva!", COLOR_ADMIN);
			
			if(CarInfo[kocsi][cFrakcio] == 0) {
				Format(kocsitulaj, "%s", CarInfo[kocsi][cOwner]);
			} else {
				Format(kocsitulaj, "%s", Szervezetneve[CarInfo[kocsi][cFrakcio] - 1][0]);
			}
			
			Format(kocsistring, "Tulajdonos: %s | SQL ID: %d | Model: %s | Model ID: %d | Vehicle ID: %d", kocsitulaj, kocsi, GetVehicleModelName(GetVehicleModel(CarInfo[kocsi][cId])) , CarInfo[kocsi][cModel], carid);
			
			Msg(playerid, kocsistring, COLOR_ADMIN);
		}
		else if(egyezik(param[1], "vesz"))
		{
			if(!PlayerToPoint(3.0, playerid, -2033.4347, -117.5662, 1035.1719))
			{
				Msg(playerid, "Nem vagy a kereskedõ telepen!");
				SetPlayerCheckpoint(playerid, 2125.5576, -1132.1130, 24.4757, 5.0);
				return 1;
			}
			
			if(PlayerInfo[playerid][pPcarkey] != NINCS AND PlayerInfo[playerid][pPcarkey2] != NINCS) return Msg(playerid, "Maximum 2 kocsid lehet!");
			
			new kocsiid = -1;
			for(new c = 0; c < MAXVSKOCSI; c++)
			{
			    if(CarInfo[c][Van] != 1 && kocsiid == -1)
				{
			        kocsiid = c;
					break;
				}
			}
			
			if(kocsiid == -1)
			{
			   	MsgFormat(playerid, "Jelenleg elérte a szerver a jármûvek maximálás számának korlátját (%d)!", MAXVSKOCSI);
			   	return 1;
		   	}
			
			new kategoriak[128] = "Motorkerékpár\nIpari\nLowrider\nTerepjáró\nFurgon\nSedan\nKombi\nSport";
			ShowPlayerDialog(playerid, DIALOG_AUTOKER_KAT, DIALOG_STYLE_LIST, "Jármû vásárlási kategóriák", kategoriak, "Megnyit", "Mégse");
		}
		else if(egyezik(param[1], "repair"))
		{
			if(!IsPlayerInAnyVehicle(playerid)) return Msg(playerid, "Nem vagy jármûben!");
			if(!PlayerToPoint(5.0, playerid, PAYNSPRAYELOTT))
			{
				Msg(playerid, "Nem vagy a mûhely elõtt!");
				SetPlayerCheckpoint(playerid, PAYNSPRAYELOTT, 5.0);
				return 1;
			}
			
			if(PayNSprayHasznalva)
			{
				Msg(playerid, "Most éppen használja valaki, várj egy kicsit!");
				return 1;
			}
			
			new 
				vehicleid = GetPlayerVehicleID(playerid),
				javitaskoltseg = 1500
			;
			
			if(GetMoney(playerid) < javitaskoltseg)
			{
				MsgFormat(playerid, "A javítás $%s-ba kerül amelyre neked nincs elég pénzed!", PenzTordeles(javitaskoltseg));
				return 1;
			}
			
			PayNSprayHasznalva = true;
			SetVehiclePos(vehicleid, PAYNSPRAYBEN);
			SetVehicleZAngle(vehicleid, PAYNSPRAYBENZ);
			RepairVehicle(vehicleid);
			GiveMoney(playerid, -javitaskoltseg);
			
			SetTimerEx("PayNSprayTimer", 4 * 1000, false, "i", vehicleid);
		}
		else if(egyezik(param[1], "park"))
		{
			return Msg(playerid, "Szólj egy adminnak, majd õ leparkolja!");
			new Float:x, Float:y, Float:z, Float:a, carid;
			carid = GetClosestVehicle(playerid);
			if(GetDistanceToVehicle(playerid, carid) > 5.5) return Msg(playerid, "A közeledben nincs jármû!");
			new kocsi = IsAVsKocsi(carid);
			if(kocsi == NINCS) return Msg(playerid, "Ez nem V-s jármû!");
			
			if(CarInfo[kocsi][cOwned] != 1 || !egyezik(CarInfo[kocsi][cOwner], PlayerName(playerid, true))) return Msg(playerid, "Ez nem a tied!");
			//if(TilosIttParkolni(playerid)) return Msg(playerid, "Itt nem parkolhatod le!");
			
			if(IsAPlane(carid) || IsAHeli(carid))
			{
			    if(!IsAt(playerid,IsAt_Repter)) return Msg(playerid, "Légi jármûveket a reptérre parkold!");
			}
			
			GetVehiclePos(carid, x, y, z);
			GetVehicleZAngle(carid, a);
			format(string, sizeof(string), "~n~~g~Sikeresen leparkoltad!");
			GameTextForPlayer(playerid, string, 10000, 3);
			GetDamageStat(carid);
			ParkCar(kocsi, x, y, z, a, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
			if(IsPlayerInVehicle(playerid, carid))
			{
				TogglePlayerControllable(playerid, 1);
				SetPlayerPos(playerid, x, y, z+2.0);
			}
        }
        else if(egyezik(param[1], "zár") || egyezik(param[1], "zar") || egyezik(param[1], "lock"))
        {
			new carid;
			carid = GetClosestVehicle(playerid);
			if(GetDistanceToVehicle(playerid, carid) > 5.5)
				return Msg(playerid, "A közeledben nincs jármû!");
			new vs;
			vs = IsAVsKocsi(carid);
			if(vs == NINCS)	return Msg(playerid, "Ez a jármû a módba van beleírva!");
			if(CarInfo[vs][cOwned] != 1 || !egyezik(CarInfo[vs][cOwner], PlayerName(playerid, true)) && JarmuKulcs[playerid] != vs) return Msg(playerid, "Ez nem a tied!");
			if(CarInfo[vs][cLock] == 1)
			{
				UnLockCar(carid);
				format(string, sizeof(string), "~w~Jármû~n~~g~nyitva");
				GameTextForPlayer(playerid, string, 4000, 3);
				CarInfo[vs][cLock] = 0;
				Cselekves(playerid, "kinyitotta a jármûvét.",0);
				//ProxDetector(B_Cselekves, playerid, "* Pity-pity", COLOR_ORANGE,COLOR_ORANGE,COLOR_ORANGE,COLOR_ORANGE,COLOR_ORANGE);
			}
			else
			{
				LockCar(carid);
				format(string, sizeof(string), "~w~Jármû~n~~r~zárva");
				GameTextForPlayer(playerid, string, 4000, 3);
				CarInfo[vs][cLock] = 1;
				Cselekves(playerid, "bezárta a jármûvét.", 0);
				//ProxDetector(B_Cselekves, playerid, "* Pity-pity", COLOR_ORANGE,COLOR_ORANGE,COLOR_ORANGE,COLOR_ORANGE,COLOR_ORANGE);
			}
			//CarUpdate(vs, "Zarva='%d'", CarInfo[vs][cLock]);
			CarUpdate(vs, CAR_Lock);
        }
		else if(egyezik(param[1], "color") || egyezik(param[1], "szin") || egyezik(param[1], "szín"))
		{
			if(!IsPlayerInAnyVehicle(playerid)) return Msg(playerid, "Nem vagy jármûben!");
			if(!PlayerToPoint(5.0, playerid, PAYNSPRAYELOTT))
			{
				Msg(playerid, "Nem vagy a mûhely elõtt!");
				SetPlayerCheckpoint(playerid, PAYNSPRAYELOTT, 5.0);
				return 1;
			}
			
			if(PayNSprayHasznalva)
			{
				Msg(playerid, "Most éppen használja valaki, várj egy kicsit!");
				return 1;
			}
			
			new 
				vehicleid = GetPlayerVehicleID(playerid),
				javitaskoltseg = 1000
			;
			
			if(GetMoney(playerid) < javitaskoltseg)
			{
				MsgFormat(playerid, "A festés $%s-ba kerül amelyre neked nincs elég pénzed!", PenzTordeles(javitaskoltseg));
				return 1;
			}
				
			new vs = IsAVsKocsi(vehicleid);
			if(vs == NINCS) return Msg(playerid, "Ez a jármû a módba van beleírva!");
				
			if(!egyezik(CarInfo[vs][cOwner], PlayerName(playerid, true))) return Msg(playerid, "Ez nem a tied!");
        	if(params < 3) return Msg(playerid, "Használata: /v szín [szín1] [szín2] - A színek megtekinthetõek a wikipédián!");
			new color1 = strval(param[2]);
			if(color1 < 0 && color1 > 126) return Msg(playerid, "A szín minimum 0 és max 126 lehet!");
			new color2 = strval(param[3]);
			if(color2 < 0 && color2 > 126) return Msg(playerid, "A szín minimum 0 és max 126 lehet!");
			
			if(CarInfo[vs][cColorOne] != color1 || CarInfo[vs][cColorTwo] != color2)
				CarInfo[vs][cPainted] = 1;
			else
				CarInfo[vs][cPainted] = 0;
				
			PayNSprayHasznalva = true;
			SetTimerEx("PayNSprayTimer", 4 * 1000, false, "i", vehicleid);
			SetVehiclePos(vehicleid, PAYNSPRAYBEN);
			SetVehicleZAngle(vehicleid, PAYNSPRAYBENZ);
			GiveMoney(playerid, -javitaskoltseg);
			
			CarInfo[vs][cColorOne] = color1;
			CarInfo[vs][cColorTwo] = color2;
			SetVehicleColor(vehicleid, color1, color2);
			CarUpdate(vs, CAR_ColorOne, CAR_ColorTwo);
        }
        else
        {
			Msg(playerid, "Használata: (/v)ehicle [funkció]");
			Msg(playerid, "Funkciók: Vesz / Szín / Repair");
        }
		return 1;
	}
	if(egyezik(cmd, "/motor") || egyezik(cmd, "/engine") || egyezik(cmd, "/lámpa") || egyezik(cmd, "/lampa") || egyezik(cmd, "/ablak"))
	{
		Msg(playerid, "Nyomd meg az 'N' betût a jármûben!");
		return 1;
	}
	if(egyezik(cmd, "/rendszám") || egyezik(cmd, "/rendszam"))
	{
	    if(Nincsbelepve(playerid)) return 1;
	    if(params != 1) return Msg(playerid, "/rendszám [Megnéz / Készít / Leszerel / Felszerel]");
	    if(egyezik(param[1], "megnéz") || egyezik(param[1], "megnez"))
	 	{
		    if(!IsPlayerInAnyVehicle(playerid))
			{
				veh = GetClosestVehicle(playerid);
				if(GetDistanceToVehicle(playerid, veh) > 5.0)
					return Msg(playerid, "Nincs jármû a közeledben");
			}
			else
			    return Msg(playerid, "Jármûbõl akarod megnézni?");

            MsgFormat(playerid, "A kocsi rendszáma: %s", GetVehicleNumberPlate(veh));
		}
	    if(egyezik(param[1], "leszerel"))
	 	{
			if(PlayerInfo[playerid][pMember] != LMUNKA_LSPD) return Msg(playerid, "Nem vagy Rendõr!");
			if(PlayerInfo[playerid][pRank] < 2) return Msg(playerid, "Minimum 2-es rang szükséges!");
			veh = GetClosestVehicle(playerid);
			new kocsi = IsAVsKocsi(veh);
		    if(!IsPlayerInAnyVehicle(playerid))
			{
				if(GetDistanceToVehicle(playerid, veh) > 5.0)
					return Msg(playerid, "Nincs jármû a közeledben");
			} else { 
			    return Msg(playerid, "Jármûbõl akarod leszedni?");
			}
			
			if(!KocsiMogottVan(playerid,veh)) {
				return Msg(playerid, "Nem vagy a jármû mögött!");
			} if(CarInfo[kocsi][cRegisztralva] != 1) {
				return Msg(playerid, "Nincs érvényes rendszáma! Így nem szerelheted le!");
			}
			CarInfo[kocsi][cRegisztralva] = 0;
			SetVehicleNumberPlate(veh, "");
			new Float:Pos[4];
			GetVehiclePos(veh,Pos[0],Pos[1],Pos[2]);
			GetVehicleZAngle(veh,Pos[3]);
			GetDamageStat(veh);
			KocsiRespawnWR(veh);
			SetVehiclePos(veh,Pos[0],Pos[1],Pos[2]);
			SetVehicleZAngle(veh,Pos[3]);
			OnVehicleStreamIn(veh, playerid);
			Cselekves(playerid, "Rendõr leszerelte egy gépjármû rendszámtábláját!", 0);
            MsgFormat(playerid, "A kocsi rendszámtáblája: %s leszedve", GetVehicleNumberPlate(veh));
			CarUpdate(kocsi,CAR_Regisztracio);
		}
	    if(egyezik(param[1], "felszerel"))
	 	{
			if(PlayerInfo[playerid][pMember] != LMUNKA_LSPD) return Msg(playerid, "Nem vagy Rendõr!");
			if(PlayerInfo[playerid][pRank] < 2) return Msg(playerid, "Minimum 2-es rang szükséges!");
			veh = GetClosestVehicle(playerid);
			new kocsi = IsAVsKocsi(veh);
		    if(!IsPlayerInAnyVehicle(playerid))
			{
				if(GetDistanceToVehicle(playerid, veh) > 5.0)
					return Msg(playerid, "Nincs jármû a közeledben");
			}
			else
			    return Msg(playerid, "Jármûbõl akarod visszaszerelni?");
			
			if(!KocsiMogottVan(playerid,veh))
				return Msg(playerid, "Nem vagy a jármû mögött!");
				
			if(CarInfo[kocsi][cRegisztralva] != 0)
				return Msg(playerid, "Már visszavan szerelve a rendszámtábla!");
				
			if(strlen(CarInfo[kocsi][cRendszam]) < 7)
				return Msg(playerid, "Nincs rendszáma!");
			
			CarInfo[kocsi][cRegisztralva] = 1;
			SetVehicleNumberPlate(veh, CarInfo[kocsi][cRendszam]);
			new Float:Pos[4];
			GetVehiclePos(veh,Pos[0],Pos[1],Pos[2]);
			GetVehicleZAngle(veh,Pos[3]);
			GetDamageStat(veh);
			KocsiRespawnWR(veh);
			SetVehiclePos(veh,Pos[0],Pos[1],Pos[2]);
			SetVehicleZAngle(veh,Pos[3]);
			OnVehicleStreamIn(veh, playerid);
			Cselekves(playerid, "Rendõr visszaszerelte egy gépjármû rendszámtábláját!", 0);
            MsgFormat(playerid, "A kocsi rendszámtáblája: %s visszaszerelve", GetVehicleNumberPlate(veh));
			CarUpdate(kocsi,CAR_Regisztracio);
		}
		else if(egyezik(param[1], "készít") || egyezik(param[1], "keszit"))
		{
		    if(!LMT(playerid,LMUNKA_SZERELO)) return Msg(playerid, "Nem vagy szerelõ!");
		    if(!Muhelyben(playerid)) return Msg(playerid, "Nem vagy szerelõmûhelyben");
		    new car = NINCS;
           	if(IsPlayerInAnyVehicle(playerid)) return Msg(playerid, "Jármûben nem használhatod!");
        	car = GetClosestVehicle(playerid);
        	
			new vs = IsAVsKocsi(car);
			if(vs == NINCS) return Msg(playerid, "Ez a jármû a módba van beleírva!");
		   	if(GetDistanceToVehicle(playerid, car) < 5.0)
		   	{
				new regirendszam[12];
				regirendszam = CarInfo[vs][cRendszam];
				UjRendszam(car, "random");
		   	    SendFormatMessage(playerid, COLOR_GRAD1, "Rendszám kész! [id:%d / Régi rendszám: %s / Új rendszám: %s]", car, regirendszam, CarInfo[vs][cRendszam]);
				new Float:Pos[4];
				GetVehiclePos(car,Pos[0],Pos[1],Pos[2]);
				GetVehicleZAngle(car,Pos[3]);
				KocsiRespawnWR(car);
				SetVehiclePos(car,Pos[0],Pos[1],Pos[2]);
				SetVehicleZAngle(car,Pos[3]);
				OnVehicleStreamIn(car, playerid);
			}
			else
				return Msg(playerid, "A közeledben nincs jármû!");

			if(IsPlayerInAnyVehicle(playerid))
				UnFreeze(playerid);
		}
	    
	    return 1;
	}
	if(egyezik(cmd, "/getint") || egyezik(cmd, "/getvw") || egyezik(cmd, "/getinti"))
	{
		if(!Admin(playerid, 1)) return HibasParancs(playerid, true);
		if(params != 1) return Msg(playerid, "/getint [JátékosID/NévRészlet]", COLOR_ADMIN);
		
		new player = ReturnUser(param[1]);
		new vw = GetPlayerVirtualWorld(player);
		new inti = GetPlayerInterior(player);
		
		PlayerTextFormat(playerid, "%s jelenlegi Interiorja: %d, VirtualWord-je: %d", PlayerName(player), inti, vw);
		Msg(playerid, PlayerText[playerid], COLOR_ADMIN);
	}	
	if(egyezik(cmd, "/getmypos") || egyezik(cmd, "/getmyvw") || egyezik(cmd, "/getmyint"))
	{
		new
			Float:x,
			Float:y,
			Float:z,
			Float:A
		;
		
		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, A);
		
		PlayerTextFormat(playerid, "X: %f | Y: %f | Z: %f | A: %f | INT: %d | VW: %d", x, y, z, A, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));
		Msg(playerid, PlayerText[playerid]);
		return 1;
	}	
	if(egyezik(cmd, "/getip"))
	{
		if(Nincsbelepve(playerid)) return 1;
		if(!Admin(playerid, FOADMIN)) return HibasParancs(playerid, true);

		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp)) return Msg(playerid, "Használata: /getip [JátékosID/NévRészlet]");

		new playa = ReturnUser(tmp);
		if(IsValidPlayerID(playa))
	    {
	        if(playa != INVALID_PLAYER_ID)
	        {
				if(RicardoVedelem(playerid, giveplayerid)) return 1;
				if(PlayerInfo[playerid][pAdmin] < PlayerInfo[giveplayerid][pAdmin] && PlayerInfo[giveplayerid][pAdmin] < FOADMIN && !IsTulaj(playerid))
				{
					SendFormatMessageToAll(COLOR_LIGHTRED, "%s kirúgva a rendszer által | Oka: Nagyobb admin ip-jét akarod megtudni? -.-", AdminName(playerid));
					Kick(giveplayerid);
					return 1;
				}

				PlayerTextFormat(playerid, "%s IP címe: %s", PlayerName(playa), PlayerIP(playa));
				Msg(playerid, PlayerText[playerid], COLOR_ADMIN);
				return 1;
			}
	    }

	    return 1;
	}
	if(egyezik(cmd, "/játékengedély") || egyezik(cmd, "/jatekengedely"))
	{
		if(!Admin(playerid, 1)) return HibasParancs(playerid, true);
		if(params != 1) return Msg(playerid, "/játékengedély [JátékosID/NévRészlet]", COLOR_ADMIN);
		
		new player = ReturnUser(param[1]);
		if(IsPlayerNPC(player)) return Msg(playerid, "Az NPC-t hagyd már!", COLOR_ADMIN);
		if(PlayerInfo[player][pTutorial] == 1) return Msg(playerid, "Ennek a játékosnak már engedélyezve van a játék!", COLOR_ADMIN);
		PlayerInfo[player][pTutorial] = 1;
		ResetVW(player);	
		SetPlayerPos(player, 1478.9479, -1741.8082, 13.5469);
		AdatMentesSQL(player);
		
		Msg(player, "Egy Adminisztrátor engedélyezte számodra a játékot! Jó szórakozást!", COL_PIROS);
		ABroadCastFormat(COLOR_LIGHTRED, 1, "(%s) %s engedélyezte [%d]%s számára a játékot!", AdminSzint(playerid), AdminName(playerid), player, PlayerName(player));
		
		return 1;
	}
	if(egyezik(cmd, "/getskin2"))
	{
		if(Nincsbelepve(playerid)) return 1;
		if(!IsHitman(playerid) && !Admin(playerid, 1))
			return Msg(playerid, "Nem vagy hitman!");

		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp))
		    return Msg(playerid, "Használata: /getskin2 [JátékosID/NévRészlet]");

		new playa = ReturnUser(tmp);
		if(IsValidPlayerID(playa))
	    {
	        if(playa != INVALID_PLAYER_ID)
	        {
	            new skin = GetPlayerSkin(playa);
	            SetPlayerSkin(playerid, skin);
				SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Ezen az emberen ez a skin van: %d | És automatikusan átöltöztél ebbe!", skin);
				return 1;
			}
	    }

	    return 1;
	}
	if(egyezik(cmd, "/getskin"))
	{
		if(Nincsbelepve(playerid)) return 1;
		if(!IsHitman(playerid) && !Admin(playerid, 1))
			return Msg(playerid, "Nem vagy hitman!");

		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp))
		    return Msg(playerid, "Használata: /getskin [JátékosID/NévRészlet]");

		new playa = ReturnUser(tmp);
		if(IsValidPlayerID(playa))
	    {
	        if(playa != INVALID_PLAYER_ID)
	        {
	            new skin = GetPlayerSkin(playa);
				SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Ezen az emberen ez a skin van: %d", skin);
				return 1;
			}
	    }

	    return 1;
	}
	if(egyezik(cmd, "/kiszed"))
	{
		if(Nincsbelepve(playerid)) return 1;

		new playa = GetClosestPlayer(playerid);

		if(params > 0)
			playa = ReturnUser(param[1]);

		if(IsValidPlayerID(playa))
	    {
	        if(playa != INVALID_PLAYER_ID)
	        {
				if(IsPlayerNPC(playa)) return Msg(playerid, "NPC-t nem!");

	            if(ProxDetectorS(2.5, playerid, playa))
	            {
					if(IsPlayerInAnyVehicle(playerid)) return Msg(playerid, "Kocsiban vagy!");
					if(PlayerToPoint(100, playerid, 1477.1985,-1804.2847,13.5469) && !IsACop(playerid))
					{
						Msg(playerid, "Parlament környékén akarsz kocsit lopni?");
						return 1;
					}
					else if(PlayerToPoint(80, playerid, 1596.8505,-1677.9633,5.8906) && !IsACop(playerid))
					{
						Msg(playerid, "LSPD környékén akarsz kocsit lopni?");
						return 1;
					}
					else if(PlayerToPoint(50, playerid, 1214.0414,-1324.4862,13.5670) && !IsACop(playerid))
					{
						Msg(playerid, "Kórház elõtt akarsz kocsit lopni?");
						return 1;
					}
					else if(PlayerToPoint(250, playerid, 175.1913,1904.2084,18.2397) && !IsACop(playerid))
					{
						Msg(playerid, "Fort környékén akarsz kocsit lopni?");
						return 1;
					}
					if(IsPlayerInAnyVehicle(playa))
					{
						new kocsi = GetClosestVehicle(playa);
						if(Locked(kocsi)) return Msg(playerid, "A jármû zárva");
						if(IsKocsi(kocsi, "Csomagszallito") || IsKocsi(kocsi, "Fatelepes") || IsKocsi(kocsi, "Uttisztito") || IsKocsi(kocsi, "Farmer") || IsKocsi(kocsi, "Prod") || IsKocsi(kocsi, "Taxi")) return Msg(playerid, "Nem rángatod ki munkakocsiból!");
						if(GetVehicleModel(kocsi) == 427 && PlayerInfo[playa][pJailed] == BORTON_FEGYENCTELEP)
						{
							PlayerInfo[playa][pJailed] = BORTON_NINCS;
							PlayerInfo[playa][pJailTime] = 0;
						}
                        new sebesseg = JatekosSebessege(playa);
						if(sebesseg > 8) return Msg(playerid, "Mozgó jármûbõl? O_o");
						
						new Float:x, Float:y, Float:z;
						GetPlayerPos(playerid, x, y, z);
						Tele(playa, x + 0.5, y + 0.5, z, false);
						Animbanemrakhato[playa] = 0;
						format(string, sizeof(string), "* Valakit kirángattak a jármûbõl");

						if(GetPlayerState(playa) == PLAYER_STATE_DRIVER)
							UnFreeze(playa);

						ProxDetector(30.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
					}
					else
						Msg(playerid, "Nincs kocsiban!");
				}
				else
					Msg(playerid, "Nincs senki a közelben!");
			}
	    }

	    return 1;
	}
	if(egyezik(cmd, "/knévváltás") || egyezik(cmd, "/knevvaltas"))
	{
		if(!Admin(playerid, 3)) return HibasParancs(playerid, true);
		
		if(params != 2) return Msg(playerid, "Használata: /knevvaltas [kinek] [újnév]");

		new id = ReturnUser(GetParam(cmdtext, 1));

		if(id == INVALID_PLAYER_ID) return Msg(playerid, "Nincs ilyen játékos!");
		if(RicardoVedelem(playerid, id)) return 1;
		
		if(PlayerInfo[playerid][pAdmin] < PlayerInfo[giveplayerid][pAdmin] && PlayerInfo[giveplayerid][pAdmin] < FOADMIN && !IsTulaj(playerid))
		{
			SendFormatMessageToAll(COLOR_LIGHTRED, "%s kirúgva a rendszer által | Oka: Nagyobb admint akarsz bannolni?", AdminName(playerid));
			Kick(giveplayerid);
			return 1;
		}

		new nev[MAX_PLAYER_NAME];
		nev = GetParam(cmdtext, 2);

		if(!IsValidNameFromString(nev) || !EngedelyezettKarakterek(nev) || VanBenneSzam(nev)) return Msg(playerid, "Ez nem RP-s név!");

		if(strlen(nev) > MAX_PLAYER_NAME)
		{
		    SendFormatMessage(playerid, COLOR_LIGHTRED, "Max %d karakter!", MAX_PLAYER_NAME);
			return 1;
		}
		
		if(RegisztraltSQLUser(nev)) return Msg(playerid, "Foglalt!");

		new reginev[MAX_PLAYER_NAME];
		reginev = PlayerName(id);
		if(!IsHitman(id) && !IsFejleszto(id))
		{
			format(string, sizeof(string), "[K]%s -> %s", reginev, nev);
			NevLog(string);
			format(string, sizeof(string), "[Kényszerített névváltás]%s átírta %s nevét erre: %s", AdminName(playerid), reginev, nev);
			ABroadCast(COLOR_LIGHTBLUE, string, 1);
		}

		Nevvaltas(id, nev);

		SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Átírtad %s nevét erre: %s", reginev, nev);
		SendFormatMessage(id, COLOR_LIGHTBLUE, "Az admin átírta a neved. Új neved: %s", nev);

		return 1;
	}
	if(egyezik(cmd, "/asegit") || egyezik(cmd, "/asegít"))
	{
	    if(Nincsbelepve(playerid)) return 1;
	    if(!Admin(playerid, 1)) return HibasParancs(playerid, true);
		if(!IsAdminSzolis(playerid)) return Msg(playerid, "Ezt a parancsot csak AdminSzolgálatban használhatod!", COLOR_ADMIN);

		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp)) return Msg(playerid, "Használata: /asegit [név]", COLOR_ADMIN);

		new jatekos = ReturnUser(tmp);
		if(!Logged(jatekos) || jatekos == INVALID_PLAYER_ID) return Msg(playerid, "Nincs ilyen játékos!");
	    if(Animban[jatekos] != 0 || HalalAnim[jatekos])
	    {
			GetPlayerName(jatekos, giveplayer, sizeof(giveplayer));
			GetPlayerName(playerid, sendername, sizeof(sendername));
 			Animban[jatekos] = 0;
			//TextDrawHideForPlayer(jatekos, FeketesegTD);
			SetPlayerDrunkLevel(jatekos, 0);
	        GetPlayerName(jatekos, playername, sizeof(playername));
		    GameTextForPlayer(jatekos, "~w~~n~~n~~n~~n~~n~~n~~n~~n~~n~Az admin felsegített!", 3000, 3);
			
			PlayerTextFormat(playerid, "Felsegítetted %s-t!", playername);
		    Msg(playerid, PlayerText[playerid], COLOR_ADMIN);
			
			HalalAnimPlay(jatekos, false);
			ClearAnimations(jatekos);
			SetHealth(jatekos, MAXHP);
			ClearAnim(jatekos);
			UnFreeze(jatekos);
			format(string, sizeof(string), "(%s) %s felsegítette %s-t!", AdminSzint(playerid), AdminName(playerid), PlayerName(jatekos));
			if(!IsRicardo(playerid)) {
				ABroadCast(COLOR_LIGHTRED, string, 1);
			}
		}
		else
		{
			PlayerTextFormat(playerid, "%s nem szorul segítségre!", PlayerName(jatekos));
		    Msg(playerid, PlayerText[playerid], COLOR_ADMIN);
		}

		return 1;
	}
    if(egyezik(cmd, "/vontatokotel") || egyezik(cmd, "/vontatókötél"))
	{
	    if(PlayerInfo[playerid][pVontatoKotel] == 1)
	    {
     		if(Nincsbelepve(playerid)) return 1;
			if(veh == -1) return Msg(playerid, "Nem vagy kocsiban!");
			if(Bikes(veh) || IsKocsi(veh, "Gokart")) return Msg(playerid, "Persze...");

			new kocsi = GetClosestVehicle(playerid, false);
			if(Bikes(kocsi) || IsKocsi(kocsi, "Gokart")) return Msg(playerid, "Persze...");

			if(GetDistanceToVehicle(playerid, kocsi) > 10) return Msg(playerid, "A közelben nincs jármû!");

			if(GetVehicleTrailer(veh) == 0)
				AttachTrailerToVehicle(kocsi, veh);
			else
				DetachTrailerFromVehicle(veh);
		}
		else return Msg(playerid, "Vegyél vontató kötelet a 24/7-ben.");
		
		return 1;
	}
	
	if(egyezik(cmd, "/heroin"))
	{
		if(FloodCheck(playerid, cmd)) return 1;
		if(params < 1)
			return Msg(playerid, "Használat: /heroin [oldat | felszívás | belövés]");
		if(egyezik(param[1], "oldat"))
		{
			if(PlayerInfo[playerid][pHeroin] < 5)
				return Msg(playerid, "Nincs nálad elég heroin(5g)");
			if(Kanal[playerid] == 1)
				return Msg(playerid, "Már van a kanaladban oldat!");
			if(PlayerInfo[playerid][pGyujto] == 0)
				return Msg(playerid, "Nincs nálad öngyújtó!");
			Kanal[playerid] = 1;
			PlayerInfo[playerid][pGyujto] --;
			PlayerInfo[playerid][pHeroin] -= 5;
			Cselekves(playerid, "elõvesz egy kanalat és belerak egy kis heroint");
			Cselekves(playerid, "elõvesz egy öngyújtot és elkezdi melegíteni a kanalat");
			ApplyAnimation(playerid, "SMOKING", "M_smk_tap",3.0,0,0,0,0,0);
			ProxDetector(B_Cselekves, playerid, "* A kanálban lévõ heroinból egy oldat keletkezik.", COLOR_ORANGE,COLOR_ORANGE,COLOR_ORANGE,COLOR_ORANGE,COLOR_ORANGE);
		}
		if(egyezik(param[1], "felszívás") || egyezik(param[1], "felszivas"))
		{
			if(Kanal[playerid] != 1) return Msg(playerid, "Nincs a kanaladban oldat!");
			if(Fecskendo[playerid] == 0) return Msg(playerid, "Nincs nálad fecskendõ!");
			if(Fecskendo[playerid] == 2) return Msg(playerid, "Már van a fecskendõben oldat!");
			Kanal[playerid] = 0;
			Fecskendo[playerid] = 2;
			Cselekves(playerid, "elõvesz egy fecskendõt");
			Cselekves(playerid, "felszívja a kanálból az oldatot");
			ApplyAnimation(playerid, "FOOD", "EAT_Burger", 3.0, 0, 0, 0, 0, 0);
		}
		if(egyezik(param[1], "belövés"))
		{
			if(Fecskendo[playerid] != 2)
				return Msg(playerid, "Nincs nálad fecskendõ! / Nincs a fecskendõdbe oldat!");
			new Float:Armor; GetPlayerArmour(playerid, Armor);
			if(Armor + (KokainSzort[playerid]*10) > 100.0) {
				SetPlayerArmour(playerid, MAXARMOUR);
			} else {
				SetPlayerArmour(playerid, Armor + (KokainSzort[playerid]*10));
			}
			if(HeroinBelott[playerid] == 0)
				HeroinTimer[playerid] = SetTimerEx("HeroinNulla", 360000, false, "i", playerid);
			HeroinBelott[playerid] ++;
			Fecskendo[playerid] = 1;
			Cselekves(playerid, "belõvi magát egy fecskendõnyi heroin oldattal");
			SetPlayerWeather(playerid, 190);
			ApplyAnimation(playerid, "GANGS", "drnkbr_prtl_F", 4.000000, 0, 1, 1, 1, -1);
			SetPlayerDrunkLevel(playerid, (GetPlayerDrunkLevel(playerid)+300));
			if(HeroinBelott[playerid] >= 6)
			{
				ApplyAnimation(playerid, "CRACK", "crckdeth2", 4.0, 1, 0, 0, 1, 0);
				TogglePlayerControllable(playerid, false);
				HeroinTimer2[playerid] = SetTimerEx("HeroinRosszullet", 540000, false, "i", playerid);
				HeroinRossz[playerid] = 1;
				SendClientMessage(playerid, COLOR_PIROS, "Túladagoltad magad Heroinnal!");
			}
		}
	}
		
	if(egyezik(cmd, "/kokain"))
	{
		if(FloodCheck(playerid, cmd)) return 1;
		if(params < 1)
			return Msg(playerid, "Használat: /kokain [kártya | kiszór | felszív]");
		if(egyezik(param[1], "kártya") || egyezik(param[1], "kartya"))
		{
			if(params < 2)
				return Msg(playerid, "Használat: /kokain kártya [személyi | jogsi | bankkártya]");
			if(egyezik(param[2], "személyi") || egyezik(param[2], "szemelyi"))
			{
				if(PlayerInfo[playerid][pSzemelyi] != 1)
					return Msg(playerid, "Nincs nálad személyi!");
				KokainKartya[playerid] = 1;
				Cselekves(playerid, "elõvette a személyiét");
			}
			if(egyezik(param[2], "jogsi"))
			{
				if(PlayerInfo[playerid][pCarLic] == 0)
					return Msg(playerid, "Nincs nálad jogsi!");
				KokainKartya[playerid] = 2;
				Cselekves(playerid, "elõvette a jogosítványát");
			}
			if(egyezik(param[2], "bankkártya") || egyezik(param[2], "bankkartya"))
			{
				if(PlayerInfo[playerid][pBankKartya] == 0)
					return Msg(playerid, "Nincs nálad bankkártya!");
				KokainKartya[playerid] = 3;
				Cselekves(playerid, "elõvette a bankkártyáját");
			}
		}
		if(egyezik(param[1], "kiszór") || egyezik(param[1], "kiszor"))
		{
			if(params < 2)
				return Msg(playerid, "Használat: /kokain kiszór [mennyi(gramm)]");
			if(PlayerInfo[playerid][pKokain] == 0)
				return Msg(playerid, "Nincs nálad kokain!");
			new Kokain = strval(param[2]);
			if(Kokain < 1)	return Msg(playerid, "Minimum 1 grammot!");
			if(PlayerInfo[playerid][pKokain] < Kokain)
				return Msg(playerid, "Nincs nálad ennyi kokain!");
			switch(KokainKartya[playerid])
			{
				case 0:
				{
					return Msg(playerid, "Még nem vettél elõ kártyát! (/kokain kártya)");
				}
				case 1:
				{
					KokainSzort[playerid] = Kokain;
					PlayerInfo[playerid][pKokain] -= Kokain;
					Cselekves(playerid, "rászór egy adag kokaint a személyiére!");
					return 1;
				}
				case 2:
				{
					KokainSzort[playerid] = Kokain;
					PlayerInfo[playerid][pKokain] -= Kokain;
					Cselekves(playerid, "rászór egy adag kokaint a jogosítványára!");
					return 1;
				}
				case 3:
				{
					KokainSzort[playerid] = Kokain;
					PlayerInfo[playerid][pKokain] -= Kokain;
					Cselekves(playerid, "rászór egy adag kokaint a bankkártyájára!");
					return 1;
				}
			}
		}
		if(egyezik(param[1], "felszív") || egyezik(param[1], "felsziv"))
		{
			if(KokainKartya[playerid] == 0)
				return Msg(playerid, "Még nem vettél elõ kártyát! (/kokain kártya)");
			switch(KokainSzort[playerid])
			{
				case 0:
				{
					return Msg(playerid, "Még nem szórtál a kártyára kokaint! (/kokain kiszór)");
				}
				case 1 .. 5:
				{
					new Float:Armor;GetPlayerArmour(playerid, Armor);
					if(Armor+(KokainSzort[playerid]*10) > 100)
						SetPlayerArmour(playerid, MAXARMOUR);
					else
						SetPlayerArmour(playerid, Armor+(KokainSzort[playerid]*10));
					new Float:hp; GetPlayerHealth(playerid, hp);
					if(MAXHP < hp+(KokainSzort[playerid]*10))
						SetHealth(playerid, MAXHP);
					else
						SetHealth(playerid, hp+(KokainSzort[playerid]*10));
					SetPlayerWeather(playerid, 178);
					SetPlayerDrunkLevel(playerid, (GetPlayerDrunkLevel(playerid)+250));
					if(KokainFelszivott[playerid] == 0)
						KokainTimer[playerid] = SetTimerEx("KokainNulla", 600000, false, "i", playerid);
					KokainFelszivott[playerid] += KokainSzort[playerid];
					KokainSzort[playerid] = 0;
					KokainKartya[playerid] = 0;
					ApplyAnimation(playerid, "GHETTO_DB", "GDB_Car_SMO",4.0,0,1,1,1,0);
					Cselekves(playerid, "felszívott egy adag kokaint");
				}
				default:
				{
					SetPlayerWeather(playerid, 178);
					SetPlayerDrunkLevel(playerid, (GetPlayerDrunkLevel(playerid)+250));
					if(KokainFelszivott[playerid] == 0)
						KokainTimer[playerid] = SetTimerEx("KokainNulla", 600000, false, "i", playerid);
					KokainFelszivott[playerid] += KokainSzort[playerid];
					KokainSzort[playerid] = 0;
					KokainKartya[playerid] = 0;
					ApplyAnimation(playerid, "POLICE", "crm_drgbst_01",4.0,0,1,1,1,0);
					ApplyAnimation(playerid, "POLICE", "crm_drgbst_01",4.0,0,1,1,1,0);
					Cselekves(playerid, "felszívott egy adag kokaint");
				}
			}
			if(KokainFelszivott[playerid] >= 15)
			{
				SetPlayerWeather(playerid, 178);
				SetPlayerDrunkLevel(playerid, 50000);
				ApplyAnimation(playerid, "CRACK", "crckdeth2", 4.0, 1, 0, 0, 1, 0);
				KokainTimer2[playerid] = SetTimerEx("KokainRosszullet", 5000, false, "i", playerid);
				KokainRossz[playerid] = 1;
				SendClientMessage(playerid, COLOR_PIROS, "Túladagoltad magad Kokainnal!");
				Freeze(playerid, 540000);
				return 1;
			}
			return 1;
		}
	}
	
	if(egyezik(cmd, "/joint"))
	{
		if(params < 1) return Msg(playerid, "Használat: /joint [Csiga / CP / Morzsol / Teker / Gyújt / Szív / Átad]");
			
		if(egyezik(param[1], "csiga"))
		{
			if(Csiga[playerid] == 1)
			{
				return Msg(playerid, "Már van nálad csiga!");
			}
			Csiga[playerid] = 1;
			/*format(string, sizeof(string), "* Valaki tekert egy csigát.");
			ProxDetector(30.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);*/
			Msg(playerid, "Feltekertél egy csigát.")
			return 1;
		}
		if(egyezik(param[1], "cp"))
		{
			if(Cp[playerid] == 1)
			{
				return Msg(playerid, "Már van nálad Cigipapír!");
			}
			if(PlayerInfo[playerid][pCp] == 0)
			{
				return Msg(playerid, "Nincs nálad Cigipapír! (Tudsz venni 24/7be)");
			}
			PlayerInfo[playerid][pCp] --;
			Cp[playerid] = 1;
			/*format(string, sizeof(string), "* Valaki letépett egy darab cigipapírt.");
			ProxDetector(30.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);*/
			Msg(playerid, "Letéptél egy cigipapírt.")
			return 1;
		}
		if(egyezik(param[1], "morzsol"))
		{
			if(Morzsolas[playerid] == 1)
			{
				return Msg(playerid, "Már összemorzsoltad a dohányt a fûvel!");
			}
			if(PlayerInfo[playerid][pCigi] == 0)
			{
				return Msg(playerid, "Nincs nálad Cigi! (Tudsz venni 24/7be)");
			}
			if(PlayerInfo[playerid][pMarihuana] == 0)
			{
				return Msg(playerid, "Nincs nálad fû!");
			}
			PlayerInfo[playerid][pCigi] --;
			PlayerInfo[playerid][pMarihuana] --;
			Morzsolas[playerid] = 1;
			/*format(string, sizeof(string), "* Valaki összemorzsolt egy szál cigit és valami mást.");
			ProxDetector(30.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);*/
			Msg(playerid, "Összemorzsoltál egy szál cigit és valami mást.")
			return 1;
		}
		if(egyezik(param[1], "teker"))
		{
			if(Tekerve[playerid] == 1)
			{
				return Msg(playerid, "Már van nálad Tekerve!");
			}
			if(Csiga[playerid] == 0)
			{
				return Msg(playerid, "Nincs Csigád! (/joint csiga)");
			}
			if(Cp[playerid] == 0)
			{
				return Msg(playerid, "Nincs Cigipapirod! (/joint cp)");
			}
			if(Morzsolas[playerid] == 0)
			{
				return Msg(playerid, "Nem morzsoltad még össze a dohányt a fûvel! (/joint morzsol)");
			}
			new esely = random(100);
			if(esely < 80)
			{
				Tekerve[playerid] = 1;
				format(string, sizeof(string), "* Valaki megtekert egy cigit.");
				ProxDetector(30.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
			}
			else
			{
				Tekerve[playerid] = 0;
				format(string, sizeof(string), "* Valaki elbaszott egy tekerést.");
				ProxDetector(30.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
			}
			Csiga[playerid] = 0;
			Cp[playerid] = 0;
			Morzsolas[playerid] = 0;
			return 1;
		}
		if(egyezik(param[1], "gyújt") || egyezik(param[1], "gyujt"))
		{
			if(Joint[playerid] == 1)
			{
				Msg(playerid, "Már van nálad Joint!");
				return 1;
			}
			if(PlayerInfo[playerid][pGyujto] == 0)
			{
				Msg(playerid, "Nem tudod mivel meggyújtani!");
				return 1;
			}
			if(Tekerve[playerid] == 0)
			{
				Msg(playerid, "Nincs nálad tekerve joint");
				return 1;
			}
			PlayerInfo[playerid][pGyujto] --;
			Tekerve[playerid] = 0;
			Joint[playerid] = 1;
			JointIdo[playerid] = 300;
			//format(string, sizeof(string), "* Valaki begyújtott egy cigit.");
			ApplyAnimation(playerid, "SMOKING", "M_smk_in", 3.0, 0, 0, 0, 0, 0);
			//ProxDetector(30.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
			Msg(playerid, "Begyújtottál egy cigit.")
			return 1;
		}
		if(egyezik(param[1], "szív") || egyezik(param[1], "sziv"))
		{
		    if(Harcol[playerid]) return Msg(playerid, "Nah!");
			if(Drogozott[playerid] != 0)
			{
				Msg(playerid, "Ez túl sok egyszerre, kicsit pihenj...");
				return 1;
			}
			if(Joint[playerid] == 0)
			{
				Msg(playerid, "Nincs nálad Joint");
				return 1;
			}
			new Float: Elet, Float: Armor;
			GetPlayerHealth(playerid, Elet);
			GetPlayerArmour(playerid, Armor);
			if((Elet + 2.0) < MAXHP)
			{
				SetPlayerHealth(playerid, Elet+2.0);
			}
			if((Armor + 2.0) < 100)
			{
				SetPlayerArmour(playerid, Armor+2.0);
			}
			Drogozott[playerid] = 1;
			PlayerInfo[playerid][pDrogido] += 5;
			JointIdo[playerid] -= 5;
			if(JointIdo[playerid] <= 0)
			{
				JointIdo[playerid] = 0;
				Joint[playerid] = 0;
				//ProxDetector(30.0, playerid, "* Valakinek a jointja elfogyott.", COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
				Msg(playerid, "Elfogyott a jointod.")
			}
			
			SetPlayerWeather(playerid, 177);
			ApplyAnimation(playerid, "GANGS", "drnkbr_prtl_F", 4.000000, 0, 1, 1, 1, -1);
			SetPlayerDrunkLevel(playerid, (GetPlayerDrunkLevel(playerid)+500));
			return 1;
		}
		if(egyezik(param[1], "átad") || egyezik(param[1], "átad"))
		{
			if(Joint[playerid] == 0)
			{
				Msg(playerid, "Nincs nálad Joint");
				return 1;
			}
			if(params < 2)
			{
				Msg(playerid, "Használat: /joint átad [JátékosID/NévRészlet]");
				return 1;
			}
			new jatekos = ReturnUser(param[2]);
			if(Joint[jatekos] == 1)
			{
				Msg(playerid, "Már van nála joint!");
				return 1;
			}
		    if(GetDistanceBetweenPlayers(playerid,jatekos) > 5)
	        {
		        Msg(playerid, "Õ nincs a közeledben!");
		        return 1;
	        }
			Joint[playerid] = 0;
			JointIdo[jatekos] = JointIdo[playerid];
			JointIdo[playerid] = 0;
			Joint[jatekos] = 1;
			OnePlayAnim(playerid, "DEALER", "DEALER_DEAL", 4.0, 0, 0, 0, 0, 0);
			OnePlayAnim(jatekos, "DEALER", "DEALER_DEAL", 4.0, 0, 0, 0, 0, 0);
			SendFormatMessage(playerid, COLOR_WHITE, "Átadtad a jointot neki: %s", PlayerName(jatekos));
			SendFormatMessage(jatekos, COLOR_WHITE, "%s Átadott a jointot neked", PlayerName(playerid));
			/*format(string, sizeof(string), "* Valaki átpasszolta valakinek a cigit.");
			ProxDetector(30.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);*/
			return 1;
		}
		return 1;
	}
	
	if(egyezik(cmd, "/cigi"))
	{
	    if(Harcol[playerid]) return Msg(playerid, "Nah!");
	    if(PlayerInfo[playerid][pCigi] != 0)
	    {
		    if(PlayerInfo[playerid][pGyujto] != 0)
		    {
	  			PlayerInfo[playerid][pCigi] --;
				PlayerInfo[playerid][pGyujto] --;
	   			PlayerInfo[playerid][pCigiUsed]++;
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_SMOKE_CIGGY);
				/*format(string, sizeof(string), "* Valaki elõveszi a gyújtót.");
				ProxDetector(30.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
				format(string, sizeof(string), "* Valaki rágyújtott egy cigire.");
				ProxDetector(30.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
				format(string, sizeof(string), "* Valaki elteszi a gyújtót.");
				ProxDetector(30.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);*/
				OnePlayAnim(playerid, "SMOKING", "M_smk_in",3.0,0,0,0,0,0);
				return 1;
			}
			else
			{
				SendClientMessage(playerid, COLOR_PIROS, "Nincs gyújtód...Akkor hogy akarsz rágyújtani?!");
			}
		}
		else
		{
  			SendClientMessage(playerid, COLOR_YELLOW, "Nincs cigid");
		}
		return 1;
	}
    if(strcmp(cmd, "/nikotin", true) == 0)
	{
	    if(PlayerInfo[playerid][pNikotin] != 0)
	    {
     		if(PlayerInfo[playerid][pCigiFuggoseg] == 0)
	        {
	            SendClientMessage(playerid, COLOR_PIROS, "Minek neked nikotin tapasz, amikor nem vagy függõ?");
	        }
	        else
	        {
		        PlayerInfo[playerid][pNikotin] --;
	   			PlayerInfo[playerid][pCigiFuggoseg] = 0;
	   			SendClientMessage(playerid, COLOR_YELLOW, "Feltettél egy nikotin tapaszt a kezedre! Most már nem vagy függõ.");
				format(string, sizeof(string), "* Valaki feltesz egy nikotin tapaszt.");
				ProxDetector(30.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
				return 1;
	        }
		}
		else
		{
  			SendClientMessage(playerid, COLOR_YELLOW, "Nincs nikotin tapaszod! Vegyél a 24/7-be!");
		}
		return 1;
	}
	if(egyezik(cmd, "/kézfogás") || egyezik(cmd, "/kezetfog"))
	{
		if(params < 2) return Msg(playerid, "/Kezetfog [Tipus(1-3)] [JátékosID/NévRészlet] [poloska (1-igen 0 -nem)");
		new t = strval(param[1]);
		if(t < 1 || t > 3) return Msg(playerid, "Tipus 1-3");
		new p = ReturnUser(param[2]);
		if(p == INVALID_PLAYER_ID) return Msg(playerid, "Nincs ilyen játékos!");
		if(GetDistanceBetweenPlayers(playerid,p) > 1) return Msg(playerid, "Nincs a közeledben a játékos!");
		new bool:poloska = false;
		if(strval(param[3]) == 1)
			poloska = true;
			
		if(poloska)
		{
			if(!Admin(playerid,FOADMIN) && !LMT(playerid,LMUNKA_FBI) && PlayerInfo[playerid][pNIDTag] == 0) return Msg(playerid, "Nincs poloskád!");
			if(Poloska[playerid] != NINCS) return Msg(playerid, "Már van egy nem deaktivált poloskád valakin!");
			Poloska[playerid] = p;
		}

		if(t == 1)
		{
			OnePlayAnim(playerid, "GANGS", "hndshkba",4.0,0,0,0,0,0);
			OnePlayAnim(p, "GANGS", "hndshkba",4.0,0,0,0,0,0);
		}
		if(t == 2)
		{
			OnePlayAnim(playerid, "GANGS", "hndshkda",4.0,0,0,0,0,0);
			OnePlayAnim(p, "GANGS", "hndshkda",4.0,0,0,0,0,0);
		}
		if(t == 3)
		{
			OnePlayAnim(playerid, "GANGS", "hndshkfa_swt",4.0,0,0,0,0,0);
			OnePlayAnim(p, "GANGS", "hndshkfa_swt",4.0,0,0,0,0,0);
		}
		if(!poloska)
		{
			if(PlayerInfo[p][pHamisNev] != 0)
			{
				SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Kezetfogtál vele: %s.", PlayerInfo[p][pHamisNev]);
			}
			else
			{
				SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Kezetfogtál vele: %s.", PlayerName(p));
			}
			if(PlayerInfo[playerid][pHamisNev] != 0)
			{
				SendFormatMessage(p, COLOR_LIGHTGREEN, "* Kezetfogtál vele: %s.", PlayerInfo[playerid][pHamisNev]);
			}
			else
			{
				SendFormatMessage(p, COLOR_LIGHTGREEN, "* Kezetfogtál vele: %s.", PlayerName(playerid));
			}
		}
		else
		{
			if(PlayerInfo[p][pHamisNev] != 0)
			{
				SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Kezetfogtál vele: %s. És ráraktál egy poloskát.", PlayerInfo[p][pHamisNev]);
			}
			else
			{
				SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Kezetfogtál vele: %s. És ráraktál egy poloskát.", PlayerName(p));
			}
			if(PlayerInfo[playerid][pHamisNev] != 0)
			{
				SendFormatMessage(p, COLOR_LIGHTGREEN, "* Kezetfogtál vele: %s.", PlayerInfo[playerid][pHamisNev]);
			}
			else
			{
				SendFormatMessage(p, COLOR_LIGHTGREEN, "* Kezetfogtál vele: %s.", PlayerName(playerid));
			}
		}
		Cselekves(playerid, "kezetfogott valakivel.", 1);
		return 1;
	}
	if(egyezik(cmd, "/segít") || egyezik(cmd, "/segit"))
	{
	    if(Nincsbelepve(playerid)) return 1;

		new jatekos = GetClosestPlayer(playerid);
		if(ProxDetectorS(5, playerid, jatekos))
		{
		    if(PlayerInfo[playerid][pKotszer] != 0)
		    {
			    if(Animban[jatekos] != 0 || HalalAnim[jatekos])
			    {
					if(NemMozoghat(playerid)) return Msg(playerid, "Gondoltad mi?");
					if(Segitik[jatekos] != 0) return Msg(playerid, "Valaki már segíti!");
					if(Animban[jatekos] == TIPUS_LOTTSEB && !LMT(playerid, LMUNKA_MENTO) && OnkentesMentos[playerid] == 0) 
					{
						Msg(playerid, "Csak egy mentõs tud ellátni egy lõtt sebet. Inkább hívd a 911-et!");
						return 1;
					}
					if(MentoHivas[playerid] != 0)
					{
						PlayerForeach(p)
						{
							if(KiertMegy[p] == jatekos)
							{
								Msg(p, "A személyt, akihez mész, felsegítik!");
								SetPlayerMarkerForPlayer(p, jatekos, 0xFFFFFF00);
								KiertMegy[p] = NINCS;
							}
						}
					}
					MentoHivas[jatekos] = 0;
	   				MunkaFolyamatban[playerid] = 1;
	   				Segitik[jatekos] = 1;
					TogglePlayerControllable(playerid, false);
					TogglePlayerControllable(jatekos, false);
					ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop", 4.0, 1, 0, 0, 1, 0);
					ApplyAnimation(jatekos, "SWEET", "Sweet_injuredloop", 4.0, 1, 0, 0, 0, 0);
					
                    new kovibillentyu = random(sizeof(BillentyuInfo));
					SegitBillentyu[playerid] = BillentyuInfo[kovibillentyu][0][0];
					
					Msg(playerid, "Elkezdted felsegíteni! (3-7 másodperced van reagálni a feladatokra)");
					MsgFormat(playerid, "Nyomd meg a(z) %s billentyût!", BillentyuInfo[kovibillentyu][1]);
					
					SegitStep[playerid] = 10;
					KitSegit[playerid] = jatekos;
					SegitTimer[playerid] = SetTimerEx("SegitTimeUP", Rand(SEGIT_TIMEUP_MIN,SEGIT_TIMEUP_MAX), false, "ii", playerid, jatekos);
					Megnyomta[playerid] = false;
					PlayerInfo[playerid][pKotszer] --;
					Cselekves(playerid, "elõveszi a kötszert és elkezdi bekötözni a sebeket...");
				}
				else
				{
			    	Msg(playerid, "Ez a játékos nem szorul segítségre!");
				}
			}
			else
			{
			    Msg(playerid, "Nincs kötszered! Vegyél a 24/7-be!");
			}
		}
		else
		{
		    Msg(playerid, "Nincs senki a közeledben...");
		}
		return 1;
	}
	if(egyezik(cmd, "/msegit"))
	{
		if(Animban[playerid] == 0) return SendClientMessage(playerid, COLOR_YELLOW, "Nem szorulsz segítségre!");
		if(Animban[playerid] == TIPUS_LOTTSEB) return Msg(playerid, "Lõtt sebre? Biztos hogy nem!");
		if(Medics > 0 && !LMT(playerid, LMUNKA_MENTO) && OnkentesMentos[playerid] == 0) return Msg(playerid, "Van fennt mentõs! Hívj segítséget > /call 911");
		if(PlayerInfo[playerid][pKotszer] < 2) return SendClientMessage(playerid, COLOR_YELLOW, "Nincs kötszered! Vegyél a 24/7-be! (2 kötszer kell!)");
   		MunkaFolyamatban[playerid] = 1;
		GameTextForPlayer(playerid, "~w~~n~~n~~n~~n~~n~~n~~n~~n~~n~Ellátod a sebeidet...", 60000, 3);
		TogglePlayerControllable(playerid, false);
		ApplyAnimation(playerid, "BOMBER", "BOM_Plant_Loop",4.0,1,0,0,1,0);
		SetTimerEx("Munkavege", 60000, false, "ddd", playerid, M_MSEGIT, 0);
		PlayerInfo[playerid][pKotszer] -= 2;
		Cselekves(playerid, "ellátja a sebeit...");
		return 1;
	}
	if(strcmp(cmd, "/clearchat", true) == 0 || egyezik(cmd, "/cc"))
	{
		if(Nincsbelepve(playerid)) return 1;
		if(Admin(playerid, 5))
		{
			PlayerForeach(x)
			{
				ClearChat(x, 100);
				Msg(x, "Egy Adminisztrátor kiürítette a ChatBoxot!", COL_PIROS);
			}
			
			format(string, sizeof(string), "(%s) %s megtisztította a ChatBox-ot", AdminSzint(playerid), AdminName(playerid));
			ABroadCast(COLOR_LIGHTRED, string, 1);
		}
		return 1;
	}
	if(strcmp(cmd, "/berak", true) == 0)
	{
	    new mit[256], mennyit;
		new house = HazabanVan(playerid);
		if(house != NINCS)
		{
		    //if(HouseInfo[house][hSzef] != 1) return Msg(playerid, "Nincs a házban széf!");
			if(HouseInfo[house][hLekapcsolva] != 0) return Msg(playerid, "Nincs áram, ezért nem tudod kinyitni a széfet!");
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				Msg(playerid, "Helyes használat: /berak [mit] [mennyit / slot]");
				Msg(playerid, "Amit berakhatsz: Pénz, Kaja, Cigi, Kokain, Heroin, Marihuana, Material(mati), Fegyver, Ruha");
				return 1;
			}
			mit = tmp;
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				Msg(playerid, "Helyes használat: /berak [mit] [mennyit / slot]");
				Msg(playerid, "Amit berakhatsz: Pénz, Kaja, Cigi, Kokain, Heroin, Marihuana, Material(mati), Fegyver, Ruha");
				return 1;
			}
			mennyit = strval(tmp);
			if(mennyit < 1)
			    return Msg(playerid, "Hibás mennyiség / slot"); 
			if(FloodCheck(playerid, cmd)) return 1;
			if(strcmp(mit, "pénz", true) == 0 || strcmp(mit, "penz", true) == 0)
			{
			    new penz = GetMoney(playerid);
			    if(penz < 1)
					return Msg(playerid, "Nincs pénzed, vagy minuszban vagy!");
				if(penz < mennyit)
				{
				    SendFormatMessage(playerid, COLOR_LIGHTRED, "Csak $%d-od van! Többet nem tudsz betenni...", penz);
				    return 1;
	   			}
				GiveMoney(playerid, -mennyit);
				HouseInfo[house][hTakings] += mennyit;
				MsgFormat(playerid, "Beraktál $%d-t a széfbe", mennyit);
				//HazUpdate(house, "Penz='%d'", HouseInfo[house][hTakings]);
				HazUpdate(house, HAZ_Takings);
				return 1;
			}
			else if(strcmp(mit, "kaja", true) == 0)
			{
				new kaja = PlayerInfo[playerid][pKaja];
			    if(kaja < 1)
				return Msg(playerid, "Nincs kajád!");
				if(kaja < mennyit)
				{
				    SendFormatMessage(playerid, COLOR_LIGHTRED, "Csak %d kajád van! Többet nem tudsz betenni...", kaja);
				    return 1;
    			}
				new maxcucc = MAXHAZKAJA;
				if(PlayerInfo[playerid][pPremiumCsomag] >= 400)
				{
					switch(PlayerInfo[playerid][pPremiumCsomag])
					{
						case 400: maxcucc += floatround(MAXHAZKAJA * 0.05);
						case 800: maxcucc += floatround(MAXHAZKAJA * 0.1);
						case 1600: maxcucc += floatround(MAXHAZKAJA * 0.25);
					}
				}
				if((HouseInfo[house][hKaja] + mennyit) > maxcucc)
				{
				    SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Maximum %d kaja fér el a házban!", maxcucc);
				    return 1;
    			}
				PlayerInfo[playerid][pKaja] -= mennyit;
				HouseInfo[house][hKaja] += mennyit;
				MsgFormat(playerid, "Beraktál %d kaját a házba", mennyit);
				//HazUpdate(house, "Kaja='%d'", HouseInfo[house][hKaja]);
				HazUpdate(house, HAZ_Kaja);
				return 1;
			}
			else if(strcmp(mit, "orvosság", true) == 0 || strcmp(mit, "orvossag", true) == 0)
			{
				new kaja = PlayerInfo[playerid][pOrvossag];
				if(kaja < 1)
					return Msg(playerid, "Nincs nálad orvosság!");
				if(kaja < mennyit)
				{
					SendFormatMessage(playerid, COLOR_LIGHTRED, "Csak %d orvosságod van! Többet nem tudsz betenni...", kaja);
					return 1;
				}
				new maxcucc = MAXHAZORVOSSAG;
				if((HouseInfo[house][hGyogyszer] + mennyit) > maxcucc)
				{
					SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Maximum %d orvosság fér el a házban!", maxcucc);
					return 1;
				}
				PlayerInfo[playerid][pOrvossag] -= mennyit;
				HouseInfo[house][hGyogyszer] += mennyit;
				MsgFormat(playerid, "Beraktál %d orvosságot a házba", mennyit);
				//HazUpdate(house, "Cigi='%d'", HouseInfo[house][hCigi]);
				HazUpdate(house, HAZ_Gyogyszer);
				return 1;
			}
			else if(strcmp(mit, "cigi", true) == 0)
			{
				new kaja = PlayerInfo[playerid][pCigi];
				if(kaja < 1)
					return Msg(playerid, "Nincs cigid!");
				if(kaja < mennyit)
				{
					SendFormatMessage(playerid, COLOR_LIGHTRED, "Csak %d cigid van! Többet nem tudsz betenni...", kaja);
					return 1;
				}
				new maxcucc = MAXHAZCIGI;
				if((HouseInfo[house][hCigi] + mennyit) > maxcucc)
				{
					SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Maximum %d cigi fér el a házban!", maxcucc);
					return 1;
				}
				PlayerInfo[playerid][pCigi] -= mennyit;
				HouseInfo[house][hCigi] += mennyit;
				MsgFormat(playerid, "Beraktál %d cigit a házba", mennyit);
				//HazUpdate(house, "Cigi='%d'", HouseInfo[house][hCigi]);
				HazUpdate(house, HAZ_Cigi);
				return 1;
			}
			else if(strcmp(mit, "kokain", true) == 0)
			{
				new cucc = PlayerInfo[playerid][pKokain];
				if(cucc < 1)
					return Msg(playerid, "Nincs kokainod!");
				if(cucc < mennyit)
				{
					SendFormatMessage(playerid, COLOR_LIGHTRED, "Csak %dg kokainod van! Többet nem tudsz betenni...", cucc);
					return 1;
				}
				new maxcucc = MAXHAZKOKAIN;
				if(PlayerInfo[playerid][pPremiumCsomag] >= 400)
				{
					switch(PlayerInfo[playerid][pPremiumCsomag])
					{
						case 400: maxcucc += floatround(MAXHAZKOKAIN * 0.05);
						case 800: maxcucc += floatround(MAXHAZKOKAIN * 0.1);
						case 1600: maxcucc += floatround(MAXHAZKOKAIN * 0.25);
					}
				}
				if((HouseInfo[house][hKokain] + mennyit) > maxcucc)
				{
					SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Maximum %dg kokain fér el a házszéfbe!", maxcucc);
					return 1;
				}
				PlayerInfo[playerid][pKokain] -= mennyit;
				HouseInfo[house][hKokain] += mennyit;
				MsgFormat(playerid, "Beraktál %dg kokaint a házszéfbe", mennyit);
				//HazUpdate(house, "Kokain='%d'", HouseInfo[house][hKokain]);
				HazUpdate(house, HAZ_Kokain);
				return 1;
			}
			else if(strcmp(mit, "heroin", true) == 0)
			{
				new cucc = PlayerInfo[playerid][pHeroin];
				if(cucc < 1)
					return Msg(playerid, "Nincs heroinod!");
				if(cucc < mennyit)
				{
					SendFormatMessage(playerid, COLOR_LIGHTRED, "Csak %dg heroinod van! Többet nem tudsz betenni...", cucc);
					return 1;
				}
				new maxcucc = MAXHAZHEROIN;
				if(PlayerInfo[playerid][pPremiumCsomag] >= 400)
				{
					switch(PlayerInfo[playerid][pPremiumCsomag])
					{
						case 400: maxcucc += floatround(MAXHAZHEROIN * 0.05);
						case 800: maxcucc += floatround(MAXHAZHEROIN * 0.1);
						case 1600: maxcucc += floatround(MAXHAZHEROIN * 0.25);
					}
				}
				if((HouseInfo[house][hHeroin] + mennyit) > maxcucc)
				{
					SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Maximum %dg heroin fér el a házszéfbe!", MAXHAZHEROIN);
					return 1;
				}
				PlayerInfo[playerid][pHeroin] -= mennyit;
				HouseInfo[house][hHeroin] += mennyit;
				MsgFormat(playerid, "Beraktál %dg heroint a házszéfbe", mennyit);
				//HazUpdate(house, "Heroin='%d'", HouseInfo[house][hHeroin]);
				HazUpdate(house, HAZ_Heroin);
				return 1;
			}
			else if(strcmp(mit, "marihuana", true) == 0)
			{
				new cucc = PlayerInfo[playerid][pMarihuana];
				if(cucc < 1)
					return Msg(playerid, "Nincs marihuánád!");
				if(cucc < mennyit)
				{
					SendFormatMessage(playerid, COLOR_LIGHTRED, "Csak %dg marihuánád van! Többet nem tudsz betenni...", cucc);
					return 1;
				}
				new maxcucc = MAXHAZMARIHUANA;
				if(PlayerInfo[playerid][pPremiumCsomag] >= 400)
				{
					switch(PlayerInfo[playerid][pPremiumCsomag])
					{
						case 400: maxcucc += floatround(MAXHAZMARIHUANA * 0.05);
						case 800: maxcucc += floatround(MAXHAZMARIHUANA * 0.1);
						case 1600: maxcucc += floatround(MAXHAZMARIHUANA * 0.25);
					}
				}
				if((HouseInfo[house][hMarihuana] + mennyit) > maxcucc)
				{
					SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Maximum %dg marihuana fér el a házszéfbe!", maxcucc);
					return 1;
				}
				PlayerInfo[playerid][pMarihuana] -= mennyit;
				HouseInfo[house][hMarihuana] += mennyit;
				MsgFormat(playerid, "Beraktál %dg marihuana-t a házszéfbe", mennyit);
				//HazUpdate(house, "Marihuana='%d'", HouseInfo[house][hMarihuana]);
				HazUpdate(house, HAZ_Marihuana);
				return 1;
			}
			else if(strcmp(mit, "mellény", true) == 0 || strcmp(mit, "melleny", true) == 0)
			{
				new Float:armor;
				GetPlayerArmour(playerid, armor);
				new pancel = floatround(armor);
				if(pancel == 0) return Msg(playerid, "Nincs mellényed!");
				new maxcucc = 5, fslot = mennyit - 1;
				if(PlayerInfo[playerid][pPremiumCsomag] >= 400)
				{
					switch(PlayerInfo[playerid][pPremiumCsomag])
					{
						case 400: maxcucc += 1;
						case 800: maxcucc += 2;
						case 1600: maxcucc += 5;
					}
				}
				if(mennyit >= 1 && mennyit <= maxcucc)
				{
					if(HouseInfo[house][hMellenyek][fslot] == 0)
					{
						MsgFormat(playerid, "Beraktál egy mellényt a házszéfbe, állapota: %d százalék", pancel);
						HouseInfo[house][hMellenyek][fslot] = pancel;
						SetPlayerArmour(playerid, 0.0);
					}
					else return Msg(playerid, "Itt már van mellény!");
				}
				HazUpdate(house, HAZ_Mellenyek);
				return 1;
			}
			else if(strcmp(mit, "mati", true) == 0 || strcmp(mit, "material", true) == 0)
			{
				new cucc = PlayerInfo[playerid][pMats];
				if(cucc < 1)
					return Msg(playerid, "Nincs materialod!");
				if(cucc < mennyit)
				{
					SendFormatMessage(playerid, COLOR_LIGHTRED, "Csak %dg materialod van! Többet nem tudsz betenni...", cucc);
					return 1;
				}
				new maxcucc = MAXHAZMATI;
				if(PlayerInfo[playerid][pPremiumCsomag] >= 400)
				{
					switch(PlayerInfo[playerid][pPremiumCsomag])
					{
						case 400: maxcucc += floatround(MAXHAZMATI * 0.05);
						case 800: maxcucc += floatround(MAXHAZMATI * 0.1);
						case 1600: maxcucc += floatround(MAXHAZMATI * 0.25);
					}
				}
				if((HouseInfo[house][hMati] + mennyit) > maxcucc)
				{
					SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Maximum %ddb material fér el a házszéfbe!", maxcucc);
					return 1;
				}
				PlayerInfo[playerid][pMats] -= mennyit;
				HouseInfo[house][hMati] += mennyit;
				MsgFormat(playerid, "Beraktál %ddb materialt a házszéfbe", mennyit);
				//HazUpdate(house, "Material='%d'", HouseInfo[house][hMati]);
				HazUpdate(house, HAZ_Mati);
				return 1;
			}
			else if(strcmp(mit, "ruha", true) == 0 )
			{
				new fegyver = GetPlayerSkin(playerid);
				if(fegyver == 252 || fegyver == 0 || !IsValidSkin(fegyver)) return Msg(playerid, "Nincs rajtad ruha!");
				new maxcucc = 5, fslot = mennyit - 1;
				if(PlayerInfo[playerid][pPremiumCsomag] >= 400)
				{
					switch(PlayerInfo[playerid][pPremiumCsomag])
					{
						case 400: maxcucc += 1;
						case 800: maxcucc += 2;
						case 1600: maxcucc += 5;
					}
				}
				if(mennyit >= 1 && mennyit <= maxcucc)
				{
					if(HouseInfo[house][hRuha][fslot] == 0)
					{
						SetPlayerSkin(playerid,252);
						MsgFormat(playerid, "Beraktál egy ruhát a házszéfbe: %s(Skin ID:%d)", GetSkinNev(fegyver), fegyver);
						HouseInfo[house][hRuha][fslot] = fegyver;
						HazUpdate(house, HAZ_Ruha);
					}
					else
					{
						Msg(playerid, "Itt már van fegyver!");
					}
				}
				else if(mennyit >= 1 && mennyit <= 10 && mennyit > maxcucc)
				{
					Msg(playerid, "Ez prémium slot!");
				}
			}
			else if(strcmp(mit, "fegyver", true) == 0 )
			{
				new fegyver = GetPlayerWeapon(playerid);
				if(fegyver == 0) return Msg(playerid, "Nincs a kezedbe fegyver");
				new maxcucc = 5, fslot = mennyit - 1;
				if(PlayerInfo[playerid][pPremiumCsomag] >= 400)
				{
					switch(PlayerInfo[playerid][pPremiumCsomag])
					{
						case 400: maxcucc += 1;
						case 800: maxcucc += 2;
						case 1600: maxcucc += 5;
					}
				}
				if(mennyit >= 1 && mennyit <= maxcucc)
				{
					if(HouseInfo[house][hFegyverek][fslot] == 0)
					{
						FegyverElvesz(playerid, fegyver);
						new loszer = GetPlayerAmmo(playerid);
						if(HouseInfo[house][hToltenyek][fslot] > 9999) return Msg(playerid, "Ne bugoltasd a lõszert!");
						MsgFormat(playerid, "Beraktál egy fegyvert a házszéfbe: %s, lõszer: %ddb", GetGunName(fegyver), loszer);
						HouseInfo[house][hFegyverek][fslot] = fegyver;
						HouseInfo[house][hToltenyek][fslot] = loszer;
						HazUpdate(house, HAZ_Fegyverek);
					}
					else
					{
						Msg(playerid, "Itt már van fegyver!");
					}
				}
				else if(mennyit >= 1 && mennyit <= 10 && mennyit > maxcucc)
				{
					Msg(playerid, "Ez prémium slot!");
				}
			}
			else
				return Msg(playerid, "Amit berakhatsz: Pénz, Kaja, Kokain, Heroin, Material(mati), Fegyver");
		}
		else
		{
			Msg(playerid, "Nincs házad");
		}
	}
	
	if(egyezik(cmd, "/bútoraim") || egyezik(cmd, "/butoraim"))
	{
		new hid = NINCS;			
		hid = CheckPos(playerid, "HÁZBEJÁRATELÕTT");
		if(hid == NINCS && HazabanVan(playerid) == NINCS) return Msg(playerid, "Nem vagy a házad elõtt/ban!");
		
		ShowPlayerDialog(playerid, DIALOG_ButorMain, DIALOG_STYLE_LIST, "Bútorkezelés", "A házban található bútorok listája\nÚj bútor vásárlásása", "Kiválaszt", "Kilép");
		return 1;
	}

	if(egyezik(cmd, "/menetlevél") || egyezik(cmd, "/menetlevel"))
	{
		//if(!AMT(playerid, MUNKA_CSOMAGSZALLITO)) return Msg(playerid, "Nem vagy csomagszállító!");
		if(!PlayerToPoint(5.0, playerid, 1490.28, 1305.5, 1093.3)) return Msg(playerid, "Nem vagy az irodában!");
		if(CsomagszallitoKocsiID[playerid] != 0)
		{
			new Float:vehx, Float:vehy, Float:vehz;
			GetVehiclePos(CsomagszallitoKocsiID[playerid], vehx, vehy, vehz);
			Msg(playerid, "Te már megkaptad csomagszállító jármûved! (a GPS-eden megjelöltük)");
			SetPlayerCheckpoint(playerid, vehx, vehy, vehz, 5.0);
			return 1;
		}
		
		new 
			//npc = ReturnUser("NPC_Csomagszallito"),
			model = 0, 
			szin1 = Rand(0, 255), 
			szin2 = szin1, 
			munkaskill = PlayerInfo[playerid][pCsomagszallitoSkill]
		;
		
		switch(munkaskill)
		{
			case 1: model = 418;
			case 2: model = 413;
			case 3: model = 499;
			case 4: model = 414;
			case 5: model = 456;
			default: model = 418;
		}
		
		if(IsValidCar(model)) 
		{
			SpawnPozicio[playerid] = random(sizeof(CsomagszallitoSpawn));
			CsomagszallitoKocsiID[playerid] = UjKocsi(model, CsomagszallitoSpawn[SpawnPozicio[playerid]][0], CsomagszallitoSpawn[SpawnPozicio[playerid]][1], CsomagszallitoSpawn[SpawnPozicio[playerid]][2], 180.0000, RandomVehicleColor(), RandomVehicleColor());
			UnLockCar(CsomagszallitoKocsiID[playerid]);
			
			MsgFormat(playerid, "Megkaptad a skillednek [%d] megfelelõ jármûvet amit kint a garázs elõtt találsz!", munkaskill);
			SetPlayerCheckpoint(playerid, CsomagszallitoSpawn[SpawnPozicio[playerid]][0], CsomagszallitoSpawn[SpawnPozicio[playerid]][1], CsomagszallitoSpawn[SpawnPozicio[playerid]][2], 8.0);
		} 
		else {
			Msg(playerid, "Valami hiba történt, szólj egy adminnak!");
		}
		return 1;
	}
	
	if(egyezik(cmd, "/afk"))
	{
	    if(PlayerCuffed[playerid] == 2)return Msg(playerid, "Bilincsben vagy!!");
		if(IsPlayerInAnyVehicle(playerid)) return Msg(playerid, "Jármûben nem!");
		if(AFK[playerid] == 0)
		{
			ShowPlayerDialog(playerid, DIALOG_NINCS, DIALOG_STYLE_MSGBOX, "Away From Keyboard [AFK]", "{FFFFFF}AFK mód {00FF00}bekapcsolva{FFFFFF}!\nMostantól nem telik a játszott órád!", "Bezárás", "");
			TogglePlayerControllable(playerid, 0);
			SetPlayerVirtualWorld(playerid, 97865);
			SetPlayerColor(playerid, COLOR_BLACK);
			AFK[playerid] = 1;
		}
		else
		{
			AFK[playerid] = 0;
			Msg(playerid, "Mostmár nem vagy AFK!");
			TogglePlayerControllable(playerid, true);
			SetPlayerToTeamColor(playerid);
			ResetVW(playerid);
		}
		return 1;
	}
	
 	if(egyezik(cmd, "/csomagszállítás") || egyezik(cmd, "/csomagszállító") || egyezik(cmd, "/csomagszallito"))
	{
		if(params != 1) return Msg(playerid, "Használata: /csomagszállító [Felpakol / Lepakol]");
		
		new model = GetVehicleModel(GetPlayerVehicleID(playerid));
		if(model != 418 AND model != 413 AND model != 499 AND model != 414 AND model != 456) return Msg(playerid, "Ez nem csomagszállító jármû! (/menetlevél)");
		
		if(egyezik(param[1], "felpakol"))
		{
			if(PlayerToPoint(50.0, playerid, -538.0696, -517.2651, 34.7816))
			{
				if(MunkaFolyamatban[playerid] == 1) return Msg(playerid, "Már végzel munkát!");
				MunkaFolyamatban[playerid] = 1;
				Cselekves(playerid, "elkezdte feltölteni a csomagszállítót áruval...",1);
				TogglePlayerControllable(playerid, 0);
				SetTimerEx("CsomagszallitoPakolas", 10000, 0, "dd", playerid, 1);
				GameTextForPlayer(playerid, "~w~~n~~n~~n~~n~~n~~n~~n~~n~~n~Áru feltöltése...", 10000, 3);
				CsomagszallitoIdo[playerid] = CSOMAGSZALLITOLIMIT;
			}
			else
			{
				Msg(playerid, "Nem vagy a csomagszállító telephelyen!");
				SetPlayerCheckpoint(playerid, -492.4875, -561.6605, 24.5019, 20.0);
			}
		}
		else if(egyezik(param[1], "lepakol"))
		{
			if(SzallitasPozicio[playerid] == NINCS) return Msg(playerid, "Nincs bejegyzett szállítás!");
			if(PlayerToPoint(10, playerid, CsomagszallitoHely[SzallitasPozicio[playerid]][0], CsomagszallitoHely[SzallitasPozicio[playerid]][1], CsomagszallitoHely[SzallitasPozicio[playerid]][2]))
			{
				if(szallit[playerid] > 0)
				{
					if(MunkaFolyamatban[playerid] == 1) return Msg(playerid, "Már végzel munkát!");
					MunkaFolyamatban[playerid] = 1;
					TogglePlayerControllable(playerid,0);
					GameTextForPlayer(playerid, "~w~~n~~n~~n~~n~~n~~n~~n~~n~~n~Áru kipakolása...", 15000, 3);
					SetTimerEx("CsomagszallitoPakolas", 10000, 0, "dd", playerid, 2);
					CsomagszallitoIdo[playerid] = CSOMAGSZALLITOLIMIT;
				}
				else
				{
					Msg(playerid, "Nem kezdtél el szállítani! (/csomagszállító felpkaol)");
				}
			}
			else
			{
				Msg(playerid, "Menj a kijelölt helyre!");
				SetPlayerCheckpoint(playerid, CsomagszallitoHely[SzallitasPozicio[playerid]][0],CsomagszallitoHely[SzallitasPozicio[playerid]][1],CsomagszallitoHely[SzallitasPozicio[playerid]][2], 3);
				return 1;
			}
		}
		return 1;
	}
	if(strcmp(cmd, "/quitjob", true) == 0 || strcmp(cmd, "/felmond", true) == 0)
	{
		new npc = ReturnUser("NPC_Munkaugyis");
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp)) return Msg(playerid, "Használata: /felmond [1/2]");
		new munka = strval(tmp);
		if(munka == 1)
		{
			if(!IllegalisMunka(PlayerInfo[playerid][pJob1]))
			{
				if(!PlayerToPoint(5.0, playerid, 361.9459, 173.5823, 1008.3828)) return Msg(playerid, "Nem vagy a Munkaügyi Központban!");
				if(VanOttValaki(5.0, 361.9459, 173.5823, 1008.3828) != NINCS && VanOttValaki(5.0, 361.9459, 173.5823, 1008.3828) != playerid)
				{
					Msg(playerid, "Nem látod, hogy már áll ott valaki? Állj szépen sorba...");
					return 1;
				}
				if(PlayerInfo[playerid][pJob1] > 0)
				{
					if(PlayerInfo[playerid][pContractTime] < 9000 && !Admin(playerid, FOADMIN))
					{
						new meg = floatround((9000 - PlayerInfo[playerid][pContractTime]) / 60);
						Format(string, "Munkaügyintézõ mondja: Sajnálom, kedves %s, a szerzõdés még %d napig((perc)) érvényes. Keressen fel egy ügyvédet!",VezetekNev(playerid),meg);
						ProxDetector(B_Normal, npc, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5);
						Format(string, "Sajnálom, kedves %s, a szerzõdés még %d napig((perc)) érvényes. Keressen fel egy ügyvédet!",VezetekNev(playerid),meg);
						SetPlayerChatBubble(npc,string, COLOR_WHITE, B_Normal, 5000);
						return 1;
					}
					else
					{
						PlayerInfo[playerid][pJob1] = 0;
						//PlayerInfo[playerid][pChar] = 0;
						PlayerInfo[playerid][pContractTime] = 0;
						Format(string, "Munkaügyintézõ mondja: Rendben, tisztelt %s, a szerzõdést sikeresen felbontottuk! Ön újra munkanélküli!",VezetekNev(playerid));
						ProxDetector(B_Normal, npc, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5);
						Format(string, "Rendben, tisztelt %s, a szerzõdést sikeresen felbontottuk! Ön újra munkanélküli!",VezetekNev(playerid));
						SetPlayerChatBubble(npc,string, COLOR_WHITE, B_Normal, 5000);
						return 1;
					}
				}
				else
				{
					Format(string, "Munkaügyintézõ mondja: Kedves %s, önnek nincs munkája!!",VezetekNev(playerid));
					ProxDetector(B_Normal, npc, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5);
					Format(string, "Kedves %s, önnek nincs munkája!!",VezetekNev(playerid));
					SetPlayerChatBubble(npc,string, COLOR_WHITE, B_Normal, 5000);
					return 1;
				}
			}
			else
			{
				if(PlayerInfo[playerid][pJob1] > 0)
				{
					if(PlayerInfo[playerid][pContractTime] < 9000 && !Admin(playerid, FOADMIN))
					{
						new meg = floatround((9000 - PlayerInfo[playerid][pContractTime]) / 60);
						SendFormatMessage(playerid, COLOR_LIGHTBLUE, "* Még %d percet le kell dolgoznod, hogy kiléphess!", meg);
						return 1;
					}
					else
					{
						PlayerInfo[playerid][pJob1] = 0;
						//PlayerInfo[playerid][pChar] = 0;
						PlayerInfo[playerid][pContractTime] = 0;
						SendClientMessage(playerid, COLOR_LIGHTBLUE, "* Kiléptél a fõmunkádból.");
					}
				}
				else
				{
					Msg(playerid, "Nincs fõmunkád!");
				}
			}
		}
		if(munka == 2)
		{
			if(!IllegalisMunka(PlayerInfo[playerid][pJob2]))
			{
				if(!PlayerToPoint(5.0, playerid, 361.9459, 173.5823, 1008.3828)) return Msg(playerid, "Nem vagy a Munkaügyi Központban!");
				if(VanOttValaki(5.0, 361.9459, 173.5823, 1008.3828) != NINCS && VanOttValaki(5.0, 361.9459, 173.5823, 1008.3828) != playerid)
				{
					Msg(playerid, "Nem látod, hogy már áll ott valaki? Állj szépen sorba...");
					return 1;
				}
				if(PlayerInfo[playerid][pJob2] > 0)
				{
					if(PlayerInfo[playerid][pContractTime2] < 9000 && !Admin(playerid, FOADMIN))
					{
						new meg = floatround((9000 - PlayerInfo[playerid][pContractTime2]) / 60);
						Format(string, "Munkaügyintézõ mondja: Sajnálom, kedves %s, a szerzõdés még %d napig((perc)) érvényes. Keressen fel egy ügyvédet!",VezetekNev(playerid),meg);
						ProxDetector(B_Normal, npc, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5);
						Format(string, "Sajnálom, kedves %s, a szerzõdés még %d napig((perc)) érvényes. Keressen fel egy ügyvédet!",VezetekNev(playerid),meg);
						SetPlayerChatBubble(npc, string, COLOR_WHITE, B_Normal, 5000);
						return 1;
					}
					else
					{
						PlayerInfo[playerid][pJob2] = 0;
						//PlayerInfo[playerid][pChar] = 0;
						PlayerInfo[playerid][pContractTime2] = 0;
						Format(string, "Munkaügyintézõ mondja: Rendben, tisztelt %s, a szerzõdést sikeresen felbontottuk! Ön újra munkanélküli!",VezetekNev(playerid));
						ProxDetector(B_Normal, npc, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5);
						Format(string, "Rendben, tisztelt %s, a szerzõdést sikeresen felbontottuk! Ön újra munkanélküli!",VezetekNev(playerid));
						SetPlayerChatBubble(npc, string, COLOR_WHITE, B_Normal, 5000);
						return 1;
					}
				}
				else
				{
					Format(string, "Munkaügyintézõ mondja: Kedves %s, önnek nincs másodmunkája!!",VezetekNev(playerid));
					ProxDetector(B_Normal, npc, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5);
					Format(string, "Kedves %s, önnek nincs másodmunkája!!",VezetekNev(playerid));
					SetPlayerChatBubble(npc,string, COLOR_WHITE, B_Normal, 5000);
					return 1;
				}
			}
			else
			{
				if(PlayerInfo[playerid][pJob2] > 0)
				{
					if(PlayerInfo[playerid][pContractTime2] < 9000 && !Admin(playerid, FOADMIN))
					{
						new meg = floatround((9000 - PlayerInfo[playerid][pContractTime2]) / 60);
						SendFormatMessage(playerid, COLOR_LIGHTBLUE, "* Még %d percet le kell dolgoznod, hogy kiléphess!", meg);
						return 1;
					}
					else
					{
						PlayerInfo[playerid][pJob2] = 0;
						//PlayerInfo[playerid][pChar] = 0;
						PlayerInfo[playerid][pContractTime2] = 0;
						SendClientMessage(playerid, COLOR_LIGHTBLUE, "* Kiléptél a másodmunkádból.");
					}
				}
				else
				{
					Msg(playerid, "Nincs másodmunkád!");
				}
			}
		}
	}
	if(strcmp(cmd, "/átad", true) == 0 || strcmp(cmd, "/atad", true) == 0)
	{
	    if(Nincsbelepve(playerid)) return 1;
		if(Animban[playerid] != 0) return Msg(playerid, "Ezt a parancsot nem használhatod animban!");
		
	    new neki, mit[256], db;

		if(LoterenGyakorol[playerid] == 1) return Msg(playerid, "Te most a lõtéren gyakorolsz ezért nem használhatod ezt a parancsot!");
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp))
		{
			Msg(playerid, "Használata: /átad [JátékosID/NévRészlet] [Mit] [Mennyit]");
			Msg(playerid, "Amiket átadhatsz: /átad lista");
			
			return 1;
		}
		
		if(egyezik(tmp, "lista"))
		{
			SCM(playerid, COLOR_LIGHTBLUE, ValasztoVonal("Amiket átadhatsz"));
			Msg(playerid, "Kaja, Cserje, Mák, Mûanyag, Cannabis, Kokain, Heroin");
			Msg(playerid, "Marihuana, Ecstasy, Mati, Cigi, Kötszer, Fegyver, Mellény, Gyémánt");
			Msg(playerid, "Cannabismag, Mákmag, Kokacserjemag");
			SCM(playerid, COLOR_LIGHTBLUE, ValasztoVonal("Amiket átadhatsz"));
			return 1;
		}

		neki = ReturnUser(tmp);

		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp)) return Msg(playerid, "Használata: /átad [JátékosID/NévRészlet] [Mit] [Mennyit]");
		mit = tmp;

		new kuldo[MAX_PLAYER_NAME], kinek[MAX_PLAYER_NAME];

		GetPlayerName(neki, playername, sizeof(playername));
		GetPlayerName(playerid, sendername, sizeof(sendername));

		GetPlayerName(neki, kinek, sizeof(kinek));
		GetPlayerName(playerid, kuldo, sizeof(kuldo));
		if(neki == INVALID_PLAYER_ID || !Logged(neki)) return Msg(playerid, "Nincs ilyen játékos!");
		if(egyezik(mit, "fém") || egyezik(mit, "fem"))
		{
			tmp = strtok(cmdtext, idx);
		    if(!strlen(tmp)) return Msg(playerid, "És mennyit?");
			if(db < 0) return Msg(playerid, "Szerinted...");
			if(db > PlayerInfo[playerid][pFem]) return Msg(playerid, "Nincs nálad ennyi fém!");
			if(PlayerInfo[neki][pFem] + db > MAXFEM) return Msg(playerid, "Ennyi nem fér el nála!");
			PlayerInfo[playerid][pFem] -= db;
		    PlayerInfo[neki][pFem] += db;
		    SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Átadtál neki %ddb fémet neki: %s", db, kinek);
		    SendFormatMessage(neki, COLOR_LIGHTBLUE, "%s átadott neked %ddb fémet", kuldo, db);
		    return 1;
		}
		if(egyezik(mit, "zsák") || egyezik(mit, "zsak"))
		{
		    if(JatekosZsak[playerid][2] == 0)
				return Msg(playerid, "Nincs zsákod");

		    if(JatekosZsak[neki][2] != 0)
				return Msg(playerid, "Neki már van zsákja!");

		    if(GetDistanceBetweenPlayers(playerid,neki) > 5)
	        {
		        Msg(playerid, "Õ nincs a közeledben!");
		        return 1;
	        }
		    JatekosZsak[neki][0] = JatekosZsak[playerid][0];
		    JatekosZsak[neki][1] = JatekosZsak[playerid][1];
		    JatekosZsak[neki][2] = 1;
		    
			JatekosZsak[playerid][0] = 0;
            JatekosZsak[playerid][1] = 0;
            JatekosZsak[playerid][2] = 0;
            
		    SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Átadtál neki egy zsákot, a tartalma $%d és %d darab aranyrúd", JatekosZsak[neki][0],JatekosZsak[neki][1]);
		    SendFormatMessage(neki, COLOR_LIGHTBLUE, "%s átadott neked egy zsákot, a tartalma $%d és %d darab aranyrúd", kuldo, JatekosZsak[neki][0],JatekosZsak[neki][1]);
		    return 1;
		}
		if(strcmp(mit, "mákmag", true) == 0 || strcmp(mit, "makmag", true) == 0)
		{
		    tmp = strtok(cmdtext, idx);
		    if(!strlen(tmp))
		    {
		        SendClientMessage(playerid, COLOR_YELLOW, "És mennyit?");
		        return 1;
		    }
		    db = strval(tmp);
			if(db < 0) return Msg(playerid, "Szerinted...");
		    if(PlayerInfo[playerid][pMakMag] < db)
		    {
		        SendClientMessage(playerid, COLOR_YELLOW, "Nincs ennyi mák magod!");
		        return 1;
		    }
		    if((PlayerInfo[neki][pMakMag] + db) > MAXMAKMAG)
		    {
		        SendClientMessage(playerid, COLOR_YELLOW, "Ennyi nem fér el nála!");
		        return 1;
		    }
		    if(GetDistanceBetweenPlayers(playerid,neki) > 5)
	        {
		        Msg(playerid, "Õ nincs a közeledben!");
		        return 1;
	        }
		    PlayerInfo[playerid][pMakMag] -= db;
		    PlayerInfo[neki][pMakMag] += db;
		    SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Átadtál %ddb mák magot neki: %s", db, playername);
		    SendFormatMessage(neki, COLOR_LIGHTBLUE, "%s átadott neked %ddb mák magot", sendername, db);
		    return 1;
		}
		if(strcmp(mit, "cannabismag", true) == 0)
		{
		    tmp = strtok(cmdtext, idx);
		    if(!strlen(tmp))
		    {
		        SendClientMessage(playerid, COLOR_YELLOW, "És mennyit?");
		        return 1;
		    }
		    db = strval(tmp);
			if(db < 0) return Msg(playerid, "Szerinted...");
		    if(PlayerInfo[playerid][pCannabisMag] < db)
		    {
		        SendClientMessage(playerid, COLOR_YELLOW, "Nincs ennyi cannabisod!");
		        return 1;
		    }
		    if((PlayerInfo[neki][pCannabisMag] + db) > MAXCANNABISMAG)
		    {
		        SendClientMessage(playerid, COLOR_YELLOW, "Ennyi nem fér el nála!");
		        return 1;
		    }
		    if(GetDistanceBetweenPlayers(playerid,neki) > 5)
	        {
		        Msg(playerid, "Õ nincs a közeledben!");
		        return 1;
	        }
		    PlayerInfo[playerid][pCannabisMag] -= db;
		    PlayerInfo[neki][pCannabisMag] += db;
		    SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Átadtál %ddb cannabis magot neki: %s", db, playername);
		    SendFormatMessage(neki, COLOR_LIGHTBLUE, "%s átadott neked %ddb cannabis magot", sendername, db);
		    return 1;
		}
		if(strcmp(mit, "cserjemag", true) == 0)
		{
		    tmp = strtok(cmdtext, idx);
		    if(!strlen(tmp))
		    {
		        SendClientMessage(playerid, COLOR_YELLOW, "És mennyit?");
		        return 1;
		    }
		    db = strval(tmp);
			if(db < 0) return Msg(playerid, "Szerinted...");
		    if(PlayerInfo[playerid][pCserjeMag] < db)
		    {
		        SendClientMessage(playerid, COLOR_YELLOW, "Nincs ennyi kokacserje magod!");
		        return 1;
		    }
		    if((PlayerInfo[neki][pCserjeMag] + db) > MAXCSERJEMAG)
		    {
		        SendClientMessage(playerid, COLOR_YELLOW, "Ennyi nem fér el nála!");
		        return 1;
		    }
		    if(GetDistanceBetweenPlayers(playerid,neki) > 5)
	        {
		        Msg(playerid, "Õ nincs a közeledben!");
		        return 1;
	        }
		    PlayerInfo[playerid][pCserjeMag] -= db;
		    PlayerInfo[neki][pCserjeMag] += db;
		    SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Átadtál neki %ddb kokacserje magot neki: %s", db, kinek);
		    SendFormatMessage(neki, COLOR_LIGHTBLUE, "%s átadott neked %ddb kokacserje magot", kuldo, db);
		    return 1;
		}
		if(strcmp(mit, "cserje", true) == 0)
		{
		    tmp = strtok(cmdtext, idx);
		    if(!strlen(tmp))
		    {
		        SendClientMessage(playerid, COLOR_YELLOW, "És mennyit?");
		        return 1;
		    }
		    db = strval(tmp);
			if(db < 0) return Msg(playerid, "Szerinted...");
		    if(PlayerInfo[playerid][pCserje] < db)
		    {
		        SendClientMessage(playerid, COLOR_YELLOW, "Nincs ennyi kokacserjéd!");
		        return 1;
		    }
		    if((PlayerInfo[neki][pCserje] + db) > MAXCSERJE)
		    {
		        SendClientMessage(playerid, COLOR_YELLOW, "Ennyi nem fér el nála!");
		        return 1;
		    }
		    if(GetDistanceBetweenPlayers(playerid,neki) > 5)
	        {
		        Msg(playerid, "Õ nincs a közeledben!");
		        return 1;
	        }
		    PlayerInfo[playerid][pCserje] -= db;
		    PlayerInfo[neki][pCserje] += db;
		    SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Átadtál neki %ddb kokacserjét neki: %s", db, kinek);
		    SendFormatMessage(neki, COLOR_LIGHTBLUE, "%s átadott neked %ddb kokacserjét", kuldo, db);
		    return 1;
		}
		if(strcmp(mit, "kevlar", true) == 0 || strcmp(mit, "mellény", true) == 0 || strcmp(mit, "melleny", true) == 0)
		{
			if(GetDistanceBetweenPlayers(playerid,neki) > 5)
	        {
		        Msg(playerid, "Õ nincs a közeledben!");
		        return 1;
	        }
			new Float:armor;
			new Float:armor2;
			GetPlayerArmour(playerid, armor);
			GetPlayerArmour(neki, armor2);
			if(armor == 0)
			{
				Msg(playerid, "Nincs mellényed!");
				return 1;
			}
			if(armor2 != 0)
			{
				Msg(playerid, "Neki már van mellénye!");
				return 1;
			}
			SetPlayerArmour(neki, armor);
			SetPlayerArmour(playerid, 0.0);
			SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Átadtál egy golyóállót neki: %s", kinek);
		    SendFormatMessage(neki, COLOR_LIGHTBLUE, "%s átadott neked 1 golyóállót!", kuldo);
		}
		if(strcmp(mit, "cigi", true) == 0)
		{
		    tmp = strtok(cmdtext, idx);
		    if(!strlen(tmp))
		    {
		        SendClientMessage(playerid, COLOR_YELLOW, "És mennyit?");
		        return 1;
		    }
		    db = strval(tmp);
			if(db < 0) return Msg(playerid, "Szerinted...");
		    if(PlayerInfo[playerid][pCigi] < db)
		    {
		        SendClientMessage(playerid, COLOR_YELLOW, "Nincs ennyi cigid!");
		        return 1;
		    }
		    if(GetDistanceBetweenPlayers(playerid,neki) > 5)
	        {
		        Msg(playerid, "Õ nincs a közeledben!");
		        return 1;
	        }
		    PlayerInfo[playerid][pCigi] -= db;
		    PlayerInfo[neki][pCigi] += db;
		    SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Átadtál neki %ddb cigit neki: %s", db, kinek);
		    SendFormatMessage(neki, COLOR_LIGHTBLUE, "%s átadott neked %ddb cigit", kuldo, db);
		    return 1;
		}
		if(strcmp(mit, "fegyver", true) == 0)
		{
			//if(!IsRicardo(playerid)) return Msg(playerid, "Bugoltatás miatt kiszedve. Ügyesek vagytok (y)");
	 		if(GetDistanceBetweenPlayers(playerid,neki) > 2)
	        {
		        Msg(playerid, "Õ nincs a közeledben!");
		        return 1;
	        }
	        //if(Szint(neki) < FEGYVERHASZNALATSZINT) return Msg(playerid, "Õ nem használhat fegyvert!");
			new FegyverID;
			FegyverID = GetPlayerWeapon(playerid);
			
			new GunAmmo;
			if(params == 4) {
				GunAmmo = strval(param[4]);
			} else {
				GunAmmo = GetPlayerAmmo(playerid);
			}
			
			if(GunAmmo <= 0) return Msg(playerid, "Minimum 1-et el kell dobnod...");
			if(GetPlayerAmmo(playerid) < GunAmmo)
			{
				SendClientMessage(playerid, COLOR_LIGHTGREEN, "Nincs ennyi lõszered!");
				return 1;
			}
			
			if(FegyverID != 0 && GunAmmo != 0)
			{
				Msg(playerid, "Átadtál egy fegyvert.");
				Msg(neki, "Átadtak egy fegyvert.");
				//OnePlayAnim(playerid, "DEALER", "DEALER_DEAL", 4.0, 0, 0, 0, 0, 0);
				//OnePlayAnim(neki, "DEALER", "DEALER_DEAL", 4.0, 0, 0, 0, 0, 0);
				OnePlayAnim(playerid, "GANGS", "shake_cara", 4.0, 0, 0, 0, 0, 0);
				OnePlayAnim(neki, "GANGS", "shake_cara", 4.0, 0, 0, 0, 0, 0);
				FegyverElvesz(playerid, FegyverID);
				GiveWeapon(neki, FegyverID, GunAmmo);
				Cselekves(playerid, "átadott egy fegyvert valakinek...");

				new fegyoatadas[128];
				Format(fegyoatadas, "[Fegyver] %s átadott neki: %s, egy %s-t, lõszer: %d", PlayerName(playerid), PlayerName(neki), GetGunName(FegyverID), GunAmmo);
				EgyebLog(fegyoatadas);
				return 1;
			}
			else
			{
				Msg(playerid, "Nincs nálad fegyver!");

			}
		}
		if(strcmp(mit, "kötszer", true) == 0)
		{
		    tmp = strtok(cmdtext, idx);
		    if(!strlen(tmp))
		    {
		        SendClientMessage(playerid, COLOR_YELLOW, "És mennyit?");
		        return 1;
		    }
		    db = strval(tmp);
			if(db < 0) return Msg(playerid, "Szerinted...");
		    if(PlayerInfo[playerid][pKotszer] < db)
		    {
		        SendClientMessage(playerid, COLOR_YELLOW, "Nincs ennyi kötszered!");
		        return 1;
		    }
		    if(GetDistanceBetweenPlayers(playerid,neki) > 5)
	        {
		        Msg(playerid, "Õ nincs a közeledben!");
		        return 1;
	        }
		    PlayerInfo[playerid][pKotszer] -= db;
		    PlayerInfo[neki][pKotszer] += db;
		    SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Átadtál %d kötszert neki: %s", db, kinek);
		    SendFormatMessage(neki, COLOR_LIGHTBLUE, "%s átadott neked %d kötszert.", kuldo, db);
		    return 1;
		}

		if(strcmp(mit, "mák", true) == 0 || strcmp(mit, "mak", true) == 0)
		{
		    tmp = strtok(cmdtext, idx);
		    if(!strlen(tmp))
		    {
		        SendClientMessage(playerid, COLOR_YELLOW, "És mennyit?");
		        return 1;
		    }
		    db = strval(tmp);
			if(db < 0) return Msg(playerid, "Szerinted...");
		    if(PlayerInfo[playerid][pMak] < db)
		    {
		        SendClientMessage(playerid, COLOR_YELLOW, "Nincs ennyi mákleveled!");
		        return 1;
		    }
		    if((PlayerInfo[neki][pMak] + db) > MAXMAK)
		    {
		        SendClientMessage(playerid, COLOR_YELLOW, "Ennyi nem fér el nála!");
		        return 1;
		    }
		    if(GetDistanceBetweenPlayers(playerid,neki) > 5)
	        {
		        Msg(playerid, "Õ nincs a közeledben!");
		        return 1;
	        }
		    PlayerInfo[playerid][pMak] -= db;
		    PlayerInfo[neki][pMak] += db;
		    SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Átadtál %ddb máklevelet neki: %s", db, playername);
		    SendFormatMessage(neki, COLOR_LIGHTBLUE, "%s átadott neked %ddb máklevelet", sendername, db);
		    return 1;
		}

		if(strcmp(mit, "cannabis", true) == 0)
		{
		    tmp = strtok(cmdtext, idx);
		    if(!strlen(tmp))
		    {
		        SendClientMessage(playerid, COLOR_YELLOW, "És mennyit?");
		        return 1;
		    }
		    db = strval(tmp);
			if(db < 0) return Msg(playerid, "Szerinted...");
		    if(PlayerInfo[playerid][pCannabis] < db)
		    {
		        SendClientMessage(playerid, COLOR_YELLOW, "Nincs ennyi cannabisod!");
		        return 1;
		    }
		    if((PlayerInfo[neki][pCannabis] + db) > MAXCANNABIS)
		    {
		        SendClientMessage(playerid, COLOR_YELLOW, "Ennyi nem fér el nála!");
		        return 1;
		    }
		    if(GetDistanceBetweenPlayers(playerid,neki) > 5)
	        {
		        Msg(playerid, "Õ nincs a közeledben!");
		        return 1;
	        }
		    PlayerInfo[playerid][pCannabis] -= db;
		    PlayerInfo[neki][pCannabis] += db;
		    SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Átadtál %ddb cannabist neki: %s", db, playername);
		    SendFormatMessage(neki, COLOR_LIGHTBLUE, "%s átadott neked %ddb cannabist", sendername, db);
		    return 1;
		}

		if(strcmp(mit, "mûanyag", true) == 0 || strcmp(mit, "muanyag", true) == 0)
		{
		    tmp = strtok(cmdtext, idx);
		    if(!strlen(tmp))
		    {
		        SendClientMessage(playerid, COLOR_YELLOW, "És mennyit?");
		        return 1;
		    }
		    db = strval(tmp);
			if(db < 0) return Msg(playerid, "Szerinted...");
		    if(PlayerInfo[playerid][pMuanyag] < db)
		    {
		        SendClientMessage(playerid, COLOR_YELLOW, "Nincs ennyi mûanyagod!");
		        return 1;
		    }
		    if((PlayerInfo[neki][pMuanyag] + db) > MAXMUANYAG)
		    {
		        SendClientMessage(playerid, COLOR_YELLOW, "Ennyi nem fér el nála!");
		        return 1;
		    }
		    if(GetDistanceBetweenPlayers(playerid,neki) > 5)
	        {
		        Msg(playerid, "Õ nincs a közeledben!");
		        return 1;
	        }
		    PlayerInfo[playerid][pMuanyag] -= db;
		    PlayerInfo[neki][pMuanyag] += db;
		    SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Átadtál %ddb mûanyagot neki: %s", db, playername);
		    SendFormatMessage(neki, COLOR_LIGHTBLUE, "%s átadott neked %ddb mûanyagot", sendername, db);
		    return 1;
		}

		if(strcmp(mit, "kokain", true) == 0)
		{
		    tmp = strtok(cmdtext, idx);
		    if(!strlen(tmp))
		    {
		        SendClientMessage(playerid, COLOR_YELLOW, "És mennyit?");
		        return 1;
		    }
		    db = strval(tmp);
			if(db < 0) return Msg(playerid, "Szerinted...");
		    if(PlayerInfo[playerid][pKokain] < db)
		    {
		        SendClientMessage(playerid, COLOR_YELLOW, "Nincs ennyi kokainod!");
		        return 1;
		    }
		    if((PlayerInfo[neki][pKokain] + db) > MAXKOKAIN)
		    {
		        SendClientMessage(playerid, COLOR_YELLOW, "Ennyi nem fér el nála!");
		        return 1;
		    }
		    if(GetDistanceBetweenPlayers(playerid,neki) > 5)
	        {
		        Msg(playerid, "Õ nincs a közeledben!");
		        return 1;
	        }
		    PlayerInfo[playerid][pKokain] -= db;
		    PlayerInfo[neki][pKokain] += db;
		    SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Átadtál %dg kokaint neki: %s", db, playername);
		    SendFormatMessage(neki, COLOR_LIGHTBLUE, "%s átadott neked %dg kokaint", sendername, db);
		    return 1;
		}
		
		if(strcmp(mit, "ecstasy", true) == 0)
		{
		    tmp = strtok(cmdtext, idx);
		    if(!strlen(tmp))
		    {
		        SendClientMessage(playerid, COLOR_YELLOW, "És mennyit?");
		        return 1;
		    }
		    db = strval(tmp);
			if(db < 0) return Msg(playerid, "Szerinted...");
		    if(PlayerInfo[playerid][pEcstasy] < db)
		    {
		        SendClientMessage(playerid, COLOR_YELLOW, "Nincs ennyi kokainod!");
		        return 1;
		    }
		    if((PlayerInfo[neki][pEcstasy] + db) > MAXECSTASY)
		    {
		        SendClientMessage(playerid, COLOR_YELLOW, "Ennyi nem fér el nála!");
		        return 1;
		    }
		    if(GetDistanceBetweenPlayers(playerid,neki) > 5)
	        {
		        Msg(playerid, "Õ nincs a közeledben!");
		        return 1;
	        }
		    PlayerInfo[playerid][pEcstasy] -= db;
		    PlayerInfo[neki][pEcstasy] += db;
		    SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Átadtál %ddb kokaint neki: %s", db, playername);
		    SendFormatMessage(neki, COLOR_LIGHTBLUE, "%s átadott neked %ddb kokaint", sendername, db);
		    return 1;
		}

		if(strcmp(mit, "heroin", true) == 0)
		{
		    tmp = strtok(cmdtext, idx);
		    if(!strlen(tmp))
		    {
		        SendClientMessage(playerid, COLOR_YELLOW, "És mennyit?");
		        return 1;
		    }
		    db = strval(tmp);
			if(db < 0) return Msg(playerid, "Szerinted...");
		    if(PlayerInfo[playerid][pHeroin] < db)
		    {
		        SendClientMessage(playerid, COLOR_YELLOW, "Nincs ennyi heroinod!");
		        return 1;
		    }
		    if((PlayerInfo[neki][pHeroin] + db) > MAXHEROIN)
		    {
		        SendClientMessage(playerid, COLOR_YELLOW, "Ennyi nem fér el nála!");
		        return 1;
		    }
		    if(GetDistanceBetweenPlayers(playerid,neki) > 5)
	        {
		        Msg(playerid, "Õ nincs a közeledben!");
		        return 1;
	        }
		    PlayerInfo[playerid][pHeroin] -= db;
		    PlayerInfo[neki][pHeroin] += db;
		    SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Átadtál %dg heroint neki: %s", db, playername);
		    SendFormatMessage(neki, COLOR_LIGHTBLUE, "%s átadott neked %dg heroint", sendername, db);
		    return 1;
		}

		if(strcmp(mit, "marihuana", true) == 0)
		{
		    tmp = strtok(cmdtext, idx);
		    if(!strlen(tmp))
		    {
		        SendClientMessage(playerid, COLOR_YELLOW, "És mennyit?");
		        return 1;
		    }
		    db = strval(tmp);
			if(db < 0) return Msg(playerid, "Szerinted...");
		    if(PlayerInfo[playerid][pMarihuana] < db)
		    {
		        SendClientMessage(playerid, COLOR_YELLOW, "Nincs ennyi marihuánád!");
		        return 1;
		    }
		    if((PlayerInfo[neki][pMarihuana] + db) > MAXMARIHUANA)
		    {
		        SendClientMessage(playerid, COLOR_YELLOW, "Ennyi nem fér el nála!");
		        return 1;
		    }
		    if(GetDistanceBetweenPlayers(playerid,neki) > 5)
	        {
		        Msg(playerid, "Õ nincs a közeledben!");
		        return 1;
	        }
		    PlayerInfo[playerid][pMarihuana] -= db;
		    PlayerInfo[neki][pMarihuana] += db;
		    SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Átadtál %dg marihuánát neki: %s", db, playername);
		    SendFormatMessage(neki, COLOR_LIGHTBLUE, "%s átadott neked %dg marihuánát", sendername, db);
		    return 1;
		}

		if(strcmp(mit, "mati", true) == 0 || strcmp(mit, "materials", true) == 0)
		{
		    tmp = strtok(cmdtext, idx);
		    if(!strlen(tmp))
		    {
		        SendClientMessage(playerid, COLOR_YELLOW, "És mennyit?");
		        return 1;
		    }
		    db = strval(tmp);
			if(db < 0) return Msg(playerid, "Szerinted...");
		    if(PlayerInfo[playerid][pMats] < db)
		    {
		        SendClientMessage(playerid, COLOR_YELLOW, "Nincs ennyi materialod!");
		        return 1;
		    }
		    if((PlayerInfo[neki][pMats] + db) > MAXMATI)
		    {
		        SendClientMessage(playerid, COLOR_YELLOW, "Ennyi nem fér el nála!");
		        return 1;
		    }
		    if(GetDistanceBetweenPlayers(playerid,neki) > 5)
	        {
		        Msg(playerid, "Õ nincs a közeledben!");
		        return 1;
	        }
		    PlayerInfo[playerid][pMats] -= db;
		    PlayerInfo[neki][pMats] += db;
		    SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Átadtál %ddb materialt neki: %s", db, playername);
		    SendFormatMessage(neki, COLOR_LIGHTBLUE, "%s átadott neked %ddb materialt", sendername, db);
		    return 1;
		}

		if(strcmp(mit, "kaja", true) == 0)
		{
		    tmp = strtok(cmdtext, idx);
		    if(!strlen(tmp))
		    {
		        SendClientMessage(playerid, COLOR_YELLOW, "És mennyit?");
		        return 1;
		    }
		    db = strval(tmp);
			if(db < 0) return Msg(playerid, "Szerinted...");
		    if(PlayerInfo[playerid][pKaja] < db)
		    {
		        SendClientMessage(playerid, COLOR_YELLOW, "Nincs ennyi kajád!");
		        return 1;
		    }
		    if((PlayerInfo[neki][pKaja] + db) > MAXKAJA)
		    {
		        SendClientMessage(playerid, COLOR_YELLOW, "Ennyi nem fér el nála!");
		        return 1;
		    }
		    if(GetDistanceBetweenPlayers(playerid,neki) > 5)
	        {
		        Msg(playerid, "Õ nincs a közeledben!");
		        return 1;
	        }
		    PlayerInfo[playerid][pKaja] -= db;
		    PlayerInfo[neki][pKaja] += db;
		    SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Átadtál %ddb kaját neki: %s", db, playername);
		    SendFormatMessage(neki, COLOR_LIGHTBLUE, "%s átadott neked %ddb kaját", sendername, db);
		    return 1;
		}

		return 1;
	}
	if(strcmp(cmd, "/walk", true) == 0)
	{
	    if(NemMozoghat(playerid)) return Msg(playerid, "Na hova-hova?!");
		tmp = strtok(cmdtext,idx);

		if(!strlen(tmp))
			return SendClientMessage(playerid,COLOR_LIGHTRED, "Használat: /walk [id(0-13)]");

		new stilus = strval(tmp);

		SetPlayerWalkingStyle(playerid, stilus);
		SendFormatMessage(playerid, COLOR_WHITE, "Sétálási stílusod: %d", strval(tmp));
		return 1;
	}
	if(egyezik(cmd, "/házinfó") OR egyezik(cmd, "/hazinfo"))
	{
		new 
			Haz = IsAt(playerid, IsAt_HazElott),
			szoveg[512]
		;
	    if(Haz == NINCS) return Msg(playerid, "Nem vagy ház elõtt!");
		
		if(HouseInfo[Haz][hOwned] == 0)
		{
			format(szoveg, sizeof(szoveg), "Körzet: %s\
			\nHázszám: %d\
			\n————————————\
			\nEladó: igen\nÁra: $%s\n(( Megvételhez: /buyhouse ))", GetPlayerZoneName(playerid), Haz, PenzTordeles(HouseInfo[Haz][hValue]));
		}
		else
		{
			new berlesinfo[48];
			if(HouseInfo[Haz][hRentabil] == 1) {
				Format(berlesinfo, "Bérelhetõ: igen\nÁra: $%d/nap", HouseInfo[Haz][hRentabil]);
			} else {
				berlesinfo = "Bérelhetõ: nem";
			}
			
			format(szoveg, sizeof(szoveg), "Körzet: %s\
			\nHázszám: %d\
			\n———————————————\
			\nTulajdonos: %s\
			\n%s", GetPlayerZoneName(playerid), Haz, HouseInfo[Haz][hOwner], berlesinfo);
		}
		
		MsgDialog(playerid, "Házinformáció", szoveg, "Bezárás");		
		return 1;
	}
	if(egyezik(cmd, "/apartmentinfo") OR egyezik(cmd, "/apartmaninfo"))
	{
		Msg(playerid, "Hamarosan...");
		return 1;
	}
	if(egyezik(cmd, "/ház"))
	{
		if(!LMT(playerid, LMUNKA_FBI) && !LMT(playerid,LMUNKA_SWAT) && !LMT(playerid, LMUNKA_NAV) && PlayerInfo[playerid][pSWATTag] == 0) {
			Msg(playerid, "Nem vagy egy rendvédelmi szervezet tagja sem!");
			return 1;
		}

		//if(LMT(playerid, LMUNKA_NAV) && PlayerInfo[playerid][pRank] < 6)
		//	return Msg(playerid, "Minimum 6-os NAV rang!");
		if(LMT(playerid, LMUNKA_NAV) && !NAV_lefoglalasi_engedely[playerid])
			return Msg(playerid, "Nincs lefoglalási engedélyed!");

		if(LMT(playerid, LMUNKA_FBI) && PlayerInfo[playerid][pRank] < 1) return Msg(playerid, "Minimum 1-es FBI rang!");

		new house = IsAt(playerid, IsAt_Haz);
		if(house == NINCS) return Msg(playerid, "Nem vagy házban.");
		if(!Online(HouseInfo[house][hOwner])) return Msg(playerid, "Nincs fennt a ház tulaja!");
		if(params < 1) return Msg(playerid, "/ház [átnéz / lefoglal]");
		if(egyezik(param[1], "lefoglal"))
		{
			if(!LMT(playerid, LMUNKA_FBI) && !LMT(playerid, LMUNKA_NAV) || !Munkarang(playerid, 4)) return Msg(playerid, "Nem foglalhatsz le.");
			if(params < 3) return Msg(playerid, "/ház lefoglal [mit] [mennyit]");
			new mennyit = strval(param[3]);
			if(mennyit < 1) return 1;
			if(strcmp(param[2], "pénz", true) == 0 || strcmp(param[2], "penz", true) == 0)
			{
				new penz = HouseInfo[house][hTakings];

				if(HouseInfo[house][hTakings] < 1)
					return Msg(playerid, "A házszéfben nincs pénz!");

				if(HouseInfo[house][hTakings] < mennyit)
				{
					SendFormatMessage(playerid, COLOR_LIGHTRED, "A házszéfben csak $%d van! Többet nem tudsz kivenni...", penz);
					return 1;
				}

				ConsumingMoney[playerid] = 1;
				GiveMoney(playerid, mennyit);
				HouseInfo[house][hTakings] -= mennyit;
				SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Kivettél a széfbõl $%d-t", mennyit);

				//HazUpdate(house, "Penz='%d'", HouseInfo[house][hTakings]);
				HazUpdate(house, HAZ_Takings);
				return 1;
			}

			else if(strcmp(param[2], "kaja", true) == 0)
			{

				if(HouseInfo[house][hKaja] < 1)
					return Msg(playerid, "A házban nincs kaja!");

				if(HouseInfo[house][hKaja] < mennyit)
				{
					SendFormatMessage(playerid, COLOR_LIGHTRED, "A házszéfben csak %d van! Többet nem tudsz kivenni...", HouseInfo[house][hKaja]);
					return 1;
				}

				if((PlayerInfo[playerid][pKaja] + mennyit) > MAXKAJA)
				{
					SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Maximum %d kaja lehet nálad!", MAXKAJA);
					return 1;
				}

				PlayerInfo[playerid][pKaja] += mennyit;
				HouseInfo[house][hKaja] -= mennyit;
				SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Kivettél a házból %d kaját", mennyit);

				//HazUpdate(house, "Kaja='%d'", HouseInfo[house][hKaja]);
				HazUpdate(house, HAZ_Kaja);
				return 1;
			}

			else if(strcmp(param[2], "cigi", true) == 0)
			{

				if(HouseInfo[house][hCigi] < 1)
					return Msg(playerid, "A házban nincs cigi!");

				if(HouseInfo[house][hCigi] < mennyit)
				{
					SendFormatMessage(playerid, COLOR_LIGHTRED, "A házszéfben csak %d van! Többet nem tudsz kivenni...", HouseInfo[house][hCigi]);
					return 1;
				}

				PlayerInfo[playerid][pCigi] += mennyit;
				HouseInfo[house][hCigi] -= mennyit;
				SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Kivettél a házból %d szál cigit", mennyit);

				//HazUpdate(house, "Cigi='%d'", HouseInfo[house][hCigi]);
				HazUpdate(house, HAZ_Cigi);
				return 1;
			}

			else if(strcmp(param[2], "kokain", true) == 0)
			{

				if(HouseInfo[house][hKokain] < 1)
					return Msg(playerid, "A házban nincs kokain!");

				if(HouseInfo[house][hKokain] < mennyit)
				{
					SendFormatMessage(playerid, COLOR_LIGHTRED, "A házszéfben csak %dg van! Többet nem tudsz kivenni...", HouseInfo[house][hKokain]);
					return 1;
				}

				if((PlayerInfo[playerid][pKokain] + mennyit) > MAXKOKAIN)
				{
					SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Maximum %d kokaint bírsz el!", MAXKOKAIN);
					return 1;
				}

				PlayerInfo[playerid][pKokain] += mennyit;
				HouseInfo[house][hKokain] -= mennyit;
				SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Kivettél a házból %dg kokaint", mennyit);

				//HazUpdate(house, "Kokain='%d'", HouseInfo[house][hKokain]);
				HazUpdate(house, HAZ_Kokain);
				return 1;
			}

			else if(strcmp(param[2], "heroin", true) == 0)
			{

				if(HouseInfo[house][hHeroin] < 1)
					return Msg(playerid, "A házban nincs heroin!");

				if(HouseInfo[house][hHeroin] < mennyit)
				{
					SendFormatMessage(playerid, COLOR_LIGHTRED, "A házszéfben csak %dg van! Többet nem tudsz kivenni...", HouseInfo[house][hHeroin]);
					return 1;
				}

				if((PlayerInfo[playerid][pHeroin] + mennyit) > MAXHEROIN)
				{
					SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Maximum %d heroint bírsz el!", MAXHEROIN);
					return 1;
				}

				PlayerInfo[playerid][pHeroin] += mennyit;
				HouseInfo[house][hHeroin] -= mennyit;
				SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Kivettél a házból %dg heroint", mennyit);

				//HazUpdate(house, "Heroin='%d'", HouseInfo[house][hHeroin]);
				HazUpdate(house, HAZ_Heroin);
				return 1;
			}

			else if(strcmp(param[2], "marihuana", true) == 0)
			{

				if(HouseInfo[house][hMarihuana] < 1)
					return Msg(playerid, "A házban nincs marihuana!");

				if(HouseInfo[house][hMarihuana] < mennyit)
				{
					SendFormatMessage(playerid, COLOR_LIGHTRED, "A házszéfben csak %dg van! Többet nem tudsz kivenni...", HouseInfo[house][hHeroin]);
					return 1;
				}

				if((PlayerInfo[playerid][pMarihuana] + mennyit) > MAXMARIHUANA)
				{
					SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Maximum %d heroint bírsz el!", MAXMARIHUANA);
					return 1;
				}

				PlayerInfo[playerid][pMarihuana] += mennyit;
				HouseInfo[house][hMarihuana] -= mennyit;
				SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Kivettél a házból %dg marihuánát", mennyit);

				//HazUpdate(house, "Marihuana='%d'", HouseInfo[house][hMarihuana]);
				HazUpdate(house, HAZ_Marihuana);
				return 1;
			}

			else if(strcmp(param[2], "mati", true) == 0 || strcmp(param[2], "material", true) == 0)
			{

				if(HouseInfo[house][hMati] < 1)
					return Msg(playerid, "A házban nincs mati!");

				if(HouseInfo[house][hMati] < mennyit)
				{
					SendFormatMessage(playerid, COLOR_LIGHTRED, "A házszéfben csak %ddb van! Többet nem tudsz kivenni...", HouseInfo[house][hMati]);
					return 1;
				}

				if((PlayerInfo[playerid][pMats] + mennyit) > MAXMATI)
				{
					SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Maximum %d materialt bírsz el!", MAXMATI);
					return 1;
				}

				PlayerInfo[playerid][pMats] += mennyit;
				HouseInfo[house][hMati] -= mennyit;
				SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Kivettél a házból %ddb materialt", mennyit);

				//HazUpdate(house, "Material='%d'", HouseInfo[house][hMati]);
				HazUpdate(house, HAZ_Mati);
				return 1;
			}
			return 1;
		}
		if(egyezik(param[1], "átnéz") || egyezik(param[1], "atnez"))
		{
			new penz, kaja, cigis, kokain, heroin, marihuana, material;
			penz = HouseInfo[house][hTakings];
			cigis = HouseInfo[house][hCigi];
			kaja = HouseInfo[house][hKaja];
			kokain = HouseInfo[house][hKokain];
			heroin = HouseInfo[house][hHeroin];
			marihuana = HouseInfo[house][hMarihuana];
			material = HouseInfo[house][hMati];
			SendFormatMessage(playerid, COLOR_YELLOW, "===== Los Santos str. %d =====", house);
			SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Pénz: $%d | Kaja: %ddb/%ddb | Cigi: %ddb/%ddb | Material: %ddb/%ddb", penz, MAXHAZKAJA, kaja, MAXHAZCIGI, cigis, MAXHAZMATI, material);
			SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Kokain: %dg/%dg | Heroin: %dg/%dg | Marihuana: %dg/%dg", MAXHAZKOKAIN, kokain, MAXHAZHEROIN, heroin, MAXHAZMARIHUANA, marihuana);
			SendClientMessage(playerid, COLOR_YELLOW, "=================================");
			Cselekves(playerid, "átnézte a házat", 1);
		}
		return 1;
	}
    if(egyezik(cmd, "/átnéz") || egyezik(cmd, "/atnez"))
	{
		if(params < 1)
		{
			Msg(playerid, "Használat: /átnéz [mit]");
    		Msg(playerid, "Használható: jármû");
			return 1;
		}
		if(egyezik(param[1], "jarmu") || egyezik(param[1], "jármû"))
		{
            veh = GetClosestVehicle(playerid);
			new Float:tav = GetDistanceToVehicle(playerid, veh);
			if(tav >= 3) return Msg(playerid, "Nincs a közeledben jármû.");
			if(IsABicikli(veh)) return Msg(playerid, "Biciklit?");
	   		if(Locked(veh)) return Msg(playerid, "A jármû zárva.");
			if(GetJarmu(veh, KOCSI_CSOMAGTARTO) != 1) return Msg(playerid, "Nyisd fel a csomagtartót!");

			Msg(playerid, "============================[ Csomagtartó Tartalma ]============================");
			SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Cserje: %d/%d | Mák: %d/%d", CuccokAKocsiban[veh][1], MAXCSERJEAKOCSIBAN,CuccokAKocsiban[veh][2],MAXMAKAKOCSIBAN);
			SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Cannabis: %d/%d | Mûanyag: %d/%d", CuccokAKocsiban[veh][3],MAXCANNABISAKOCSIBAN, CuccokAKocsiban[veh][0],MAXMUANYAGAKOCSIBAN);
			SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Material: %d/%d | Heroin: %d/%d", CuccokAKocsiban[veh][12],MAXMATIKOCSIBAN, CuccokAKocsiban[veh][13],MAXHEROINKOCSIBAN);
			SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Felszerelés: %d/%d | Kokain: %d/%d", CuccokAKocsiban[veh][20], MAX_FELSZERELES, CuccokAKocsiban[veh][14], MAXKOKAINKOCSIBAN);
			SendFormatMessage(playerid, COLOR_LIGHTBLUE, "Marihuana: %d/%d", CuccokAKocsiban[veh][15], MAXMARIHUANAKOCSIBAN);
			SendClientMessage(playerid, COLOR_LIGHTBLUE, "Fegyver: /weapon megnéz");
			Msg(playerid, "============================[ Csomagtartó Tartalma ]============================");
			Cselekves(playerid, "átnézett egy jármûvet.", 0);
			return 1;
		}
		return 1;
	}
	if(egyezik(cmd, "/ajtó") || egyezik(cmd, "/ajto"))
	{
		/* ####################################### ENTER ####################################### */
		if(MedicTime[playerid] > 1) return iMsg(playerid, "Nem mehetsz ki a kórházból!");
		if(NemMozoghat(playerid)) return iMsg(playerid, "Most nem!");
		if(Bortonben(playerid)) return iMsg(playerid, "Börtönben nem!");
		BementIdo[playerid] = 3;
		new hazak = sizeof(HouseInfo);
		new hotelek = sizeof(HotelInfo);
		new PlayerVW = GetPlayerVirtualWorld(playerid), PlayerInt = GetPlayerInterior(playerid);
		/*new kocsi = GetClosestCar(playerid);
		if(GetDistanceToCar(playerid, kocsi) < 5.0)
		{
			if(KocsiMogottVan(playerid, kocsi))
			{
				Msg(playerid, "Bemásztál a csomagtartóba");
				Cselekves(playerid, "bemászott a csomagtartóba");
			}
		}*/
		
		if(pajzsnala[playerid] != 0)
		{
			Pajzs_Hatra(playerid);
			Pajzs_Kezbe(playerid);
		}
		
		DebugMessage("%s -> for(new i = 0; i < hazak; i++) -> START", "/ajtó");
		for(new i = 0; i < hazak; i++)
		{
			new HazBelso = HouseInfo[i][hBelso];
			if(PlayerToPoint(3, playerid,HouseInfo[i][hEntrancex], HouseInfo[i][hEntrancey], HouseInfo[i][hEntrancez])) // bejárat
			{
				if(HouseInfo[i][hLock] == 0)
				{
					HotelElottiInti[playerid] = GetPlayerInterior(playerid);
					SetPlayerInterior(playerid,IntInfo[HazBelso][iNumber]);
					SetPlayerPos(playerid, IntInfo[HazBelso][iExitX], IntInfo[HazBelso][iExitY], IntInfo[HazBelso][iExitZ]);
					SetPlayerVirtualWorld(playerid, i);
					
					//PlayerTextFormat(playerid, "Üdvözöllek %s házában!", HouseInfo[HazBelso][hOwner]);
					GameTextForPlayer(playerid, "~w~Üdvözöllek a házban!", 5000, 1);
					
					PlayerInfo[playerid][pLocal] = i;
					Hazbanvan[playerid] = i;
					new zseka = nnios[playerid];
					SendFormatMessage(zseka, Pink, "PDA Üzenet: %s bement a %d számú házba.", PlayerName(playerid), i)
					SetPlayerMarkerForPlayer(zseka, playerid, COLOR_INVISIBLE);
				}
				else
				{
					GameTextForPlayer(playerid, "~r~Zárva", 5000, 1);
					return 1;
				}
				return 1;
			}
			else if(PlayerToPoint(5, playerid,IntInfo[HazBelso][iExitX], IntInfo[HazBelso][iExitY], IntInfo[HazBelso][iExitZ]) && GetPlayerVirtualWorld(playerid) == i && GetPlayerInterior(playerid) == IntInfo[HazBelso][iNumber]) // kijárat
			{
				if(HouseInfo[i][hLock] != 0) return GameTextForPlayer(playerid, "~r~Zárva", 5000, 1);
				
				new haz = GetPlayerVirtualWorld(playerid);
				SetPlayerInterior(playerid, HotelElottiInti[playerid]);
				SetPlayerPos(playerid,HouseInfo[i][hEntrancex],HouseInfo[i][hEntrancey],HouseInfo[i][hEntrancez]);
				SetPlayerVirtualWorld(playerid, 0);
				PlayerInfo[playerid][pLocal] = NINCS;
				Hazbanvan[playerid] = 0;
				new zseka = nnios[playerid];
				SendFormatMessage(zseka, Pink, "PDA Üzenet: %s kiment a %d számú házból.", PlayerName(playerid), haz)
				SetPlayerMarkerForPlayer(zseka, playerid, Pink);
				Freeze(playerid, 5000);
				//Msg(playerid, "Interior betöltése folyamatban...");
				return 1;
			}
		}
		DebugMessage("%s -> for(new i = 0; i < hazak; i++) -> END", "/ajtó");
		
		new bid = NINCS;			
		bid = CheckPos(playerid, "ÜZLETELÕTT");
		if(bid != NINCS)
		{
			if(egyezik(bInfo[bid][bExPosInt], "Eladó")) return Msg(playerid, "Ez az üzlethelység kiadó, tehát még nem tartalmaz interiort!");
			SetPlayerInterior(playerid, bInfo[bid][bExPosInt]);
			SetPlayerVirtualWorld(playerid, bInfo[bid][bExPosVW]);
			SetPlayerPos(playerid, bInfo[bid][bExPos][0], bInfo[bid][bExPos][1], bInfo[bid][bExPos][2]);
			return 1;
		}
		bid = CheckPos(playerid, "ÜZLETBEN");
		if(bid != NINCS)
		{
			SetPlayerInterior(playerid, bInfo[bid][bEnPosInt]);
			SetPlayerVirtualWorld(playerid, bInfo[bid][bEnPosVW]);
			SetPlayerPos(playerid, bInfo[bid][bEnPos][0], bInfo[bid][bEnPos][1], bInfo[bid][bEnPos][2]);
			return 1;
		}
		
		DebugMessage("%s -> for(new i = 0; i < hotelek; i++) -> START", "/ajtó");
		for(new i = 0; i < hotelek; i++)
		{
			new HotelBelso = HotelInfo[i][hBelso];
			if(PlayerToPoint(3, playerid, HotelInfo[i][hEntranceX], HotelInfo[i][hEntranceY], HotelInfo[i][hEntranceZ])) // bejárat
			{
				if(HotelInfo[i][hZarva] == 0)
				{
					HotelElottiInti[playerid] = GetPlayerInterior(playerid);
					SetPlayerInterior(playerid, IntInfo[HotelBelso][iNumber]);
					SetPlayerPos(playerid, IntInfo[HotelBelso][iExitX], IntInfo[HotelBelso][iExitY], IntInfo[HotelBelso][iExitZ]);
					SetPlayerVirtualWorld(playerid, ALAPHOTELVW+i);
					GameTextForPlayer(playerid, "~w~Üdv itt!", 5000, 1);
					PlayerInfo[playerid][pLocal] = ALAPHOTELVW+i;
				}
				else
				{
					GameTextForPlayer(playerid, "~r~Zárva", 5000, 1);
				}
				return 1;
			}
			else if(PlayerToPoint(5, playerid, IntInfo[HotelBelso][iExitX], IntInfo[HotelBelso][iExitY], IntInfo[HotelBelso][iExitZ]) && PlayerVW == ALAPHOTELVW+i && PlayerInt == IntInfo[HotelBelso][iNumber]) // kijárat
			{
				if(HotelInfo[i][hZarva] != 0) return GameTextForPlayer(playerid, "~r~Zárva", 5000, 1);
				
				SetPlayerInterior(playerid, HotelElottiInti[playerid]);
				SetPlayerPos(playerid, HotelInfo[i][hEntranceX], HotelInfo[i][hEntranceY], HotelInfo[i][hEntranceZ]);
				SetPlayerVirtualWorld(playerid, 0);
				PlayerInfo[playerid][pLocal] = NINCS;
				Freeze(playerid, 3000);
				iMsg(playerid, "Interior betöltése folyamatban...");
				return 1;
			}
		}
		DebugMessage("%s -> for(new i = 0; i < hotelek; i++) -> END", "/ajtó");
		
		DebugMessage("%s -> for(new i = 0; i < MAXAJTO; i++) -> START", "/ajtó");
		for(new i = 0; i < MAXAJTO; i++)
		{
			if(Ajtok[i][Van] != 1) continue;
			if(PlayerToPoint(3.0, playerid, Ajtok[i][BeX], Ajtok[i][BeY], Ajtok[i][BeZ]) && PlayerVW == Ajtok[i][BeVW] && PlayerInt == Ajtok[i][BeInt])
			{
				if(Ajtok[i][Zarva] == 0 || Ajtok[i][Zarva] == 1 && IsAdmin(playerid))
				{
					SetPlayerPos(playerid, Ajtok[i][KiX], Ajtok[i][KiY], Ajtok[i][KiZ]);
					SetPlayerVirtualWorld(playerid, Ajtok[i][KiVW]);
					SetPlayerInterior(playerid,Ajtok[i][KiInt]);
					
					//if(Ajtok[i][Freezel] != 0) Freeze(playerid, Ajtok[i][Freezel]);
					Freeze(playerid, 3*1000);
					
					GameTextForPlayer(i, Ajtok[i][Nev], 4000, 1);
				}
				else
				{
					GameTextForPlayer(playerid, "~r~Zárva", 5000, 1);
				}
				return 1;
			}
			else if(PlayerToPoint(3.0, playerid, Ajtok[i][KiX], Ajtok[i][KiY], Ajtok[i][KiZ]) && PlayerVW == Ajtok[i][KiVW] && PlayerInt == Ajtok[i][KiInt])
			{
				SetPlayerPos(playerid, Ajtok[i][BeX], Ajtok[i][BeY], Ajtok[i][BeZ]);
				SetPlayerVirtualWorld(playerid, Ajtok[i][BeVW]);
				SetPlayerInterior(playerid,Ajtok[i][BeInt]);
				Freeze(playerid, 2 * 1000);
				
				if(GetPVarInt(playerid, "OldSkin"))
				{
					SetPlayerSkin(playerid, GetPVarInt(playerid, "OldSkin"));
					DeletePVar(playerid, "OldSkin");
				}
				//Msg(playerid, "Interior betöltése folyamatban...");
				return 1;
			}
		}
		DebugMessage("%s -> for(new i = 0; i < MAXAJTO; i++) -> END", "/ajtó");
		/* ####################################### SAJÁT POZÍCIÓK ####################################### */
		if(!NemMozoghat(playerid))
		{
			new k = GetPlayerVehicleID(playerid);
			new m = GetVehicleModel(k);
			if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_PASSENGER)
			{
				if(m == 483 || m == 508)
				{
					SetPlayerInterior(playerid, 1);
					SetPlayerVirtualWorld(playerid, (k+100));
					SetPlayerPos(playerid, 2513.154, -1729.182, 778.637);
					Freeze(playerid, 5000);
					Cselekves(playerid, "hátra ment...", 1);
				}
				if(m == 427)
				{
					SetPlayerInterior(playerid, 1);
					SetPlayerVirtualWorld(playerid, (k+100));
					SetPlayerPos(playerid, -26.5658, 42.4889, 1000.3384);
					Freeze(playerid, 5000);
					Cselekves(playerid, "hátra ment...", 1);
				}
			}
		}
		return 1;
	}
	if(strcmp(cmd, "/aajtó", true) == 0 || strcmp(cmd, "/aajto", true) == 0)
	{
	    if(IsValidPlayerID(playerid))
	    {
			if(!Admin(playerid, FOADMIN)) return HibasParancs(playerid, true);

			if(params < 2)
			{		
				Msg(playerid, "{FF0000}Használat: /aajtó [Ajtó ID] [Funkció]");
				Msg(playerid, "Funkciók: Bejárat, Kijárat, Név, Open, Védelem, Freeztime, Gotoenter, Gotoexit, Pickup");
				
			    Msg(playerid, "====[ Legközelebbi ajtó ]=====");
				new Float:PPos[3], Float:legkozelebb = 5000.0, Float:tav, ajto;
				GetPlayerPos(playerid, PPos[0], PPos[1], PPos[2]);
				for(new x = 0; x < sizeof(Ajtok); x++)
				{
					if(Ajtok[x][Van] != 1) continue;
					tav = GetDistance(PPos[0], PPos[1], PPos[2], Ajtok[x][BeX], Ajtok[x][BeY], Ajtok[x][BeZ]);
					if(tav < legkozelebb)
					{
						legkozelebb = tav;
						ajto = x;
					}
				}
				MsgFormat(playerid, "ID: %d", ajto);
				MsgFormat(playerid, "Név: %s", Ajtok[ajto][Nev]);
				MsgFormat(playerid, "Táv: %f", legkozelebb);
			    return 1;
			}

			new ajtoszama = strval(param[1]);

			if(ajtoszama < 0 || ajtoszama >= sizeof(Ajtok)) return Msg(playerid, "Nincs ilyen ajtó!");
			if(Ajtok[ajtoszama][Van] != 1) return Msg(playerid, "Nincs ilyen ajtó!");

			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
			    SetPlayerCheckpoint(playerid, Ajtok[ajtoszama][BeX], Ajtok[ajtoszama][BeY], Ajtok[ajtoszama][BeZ], 1);
			    return 1;
			}

	        new Float:x, Float:y, Float:z, Interior, VW;
			GetPlayerPos(playerid, x, y, z);
			Interior = GetPlayerInterior(playerid);
			VW = GetPlayerVirtualWorld(playerid);

			if(egyezik(param[2], "gotoenter"))
			{
				Tele(playerid, Ajtok[ajtoszama][BeX], Ajtok[ajtoszama][BeY], Ajtok[ajtoszama][BeZ], false, Ajtok[ajtoszama][BeVW], Ajtok[ajtoszama][BeInt]);
				MsgFormat(playerid, "Teleportálva a %d. számú ajtó bejáratához!", ajtoszama);
				BementIdo[playerid] = 3;
			}
			else if(egyezik(param[2], "gotoexit"))
			{
				Tele(playerid, Ajtok[ajtoszama][KiX], Ajtok[ajtoszama][KiY], Ajtok[ajtoszama][KiZ], false, Ajtok[ajtoszama][KiVW], Ajtok[ajtoszama][KiInt]);
				MsgFormat(playerid, "Teleportálva a %d. számú ajtó kijáratához!", ajtoszama);
				BementIdo[playerid] = 3;
			}
			else if(egyezik(param[2], "bejárat") OR egyezik(param[2], "bejarat"))
			{
				if(Ajtok[ajtoszama][Vedelem] == 1) return Msg(playerid, "Ez az ajtó védve van ezért nem módosíthatod!");
		        Ajtok[ajtoszama][BeX] = x;
		        Ajtok[ajtoszama][BeY] = y;
	    	    Ajtok[ajtoszama][BeZ] = z;
	        	Ajtok[ajtoszama][BeInt] = Interior;
		        Ajtok[ajtoszama][BeVW] = VW;

				#if defined KELLAJTO3D
					UpdateAjto3D(ajtoszama);
				#endif

				format(string, sizeof(string), "Ajtó %d bejárata átrakva!", ajtoszama);
				DestroyDynamicArea(Ajtok[ajtoszama][TeruletKint]);
				Ajtok[ajtoszama][TeruletKint] = CreateDynamicCircle(Ajtok[ajtoszama][BeX],Ajtok[ajtoszama][BeY], 1.5);
				
			}
			else if(egyezik(param[2], "kijárat") OR egyezik(param[2], "kijarat"))
			{
				if(Ajtok[ajtoszama][Vedelem] == 1) return Msg(playerid, "Ez az ajtó védve van ezért nem módosíthatod!");
		        Ajtok[ajtoszama][KiX] = x;
	    	    Ajtok[ajtoszama][KiY] = y;
	        	Ajtok[ajtoszama][KiZ] = z;
		        Ajtok[ajtoszama][KiInt] = Interior;
		        Ajtok[ajtoszama][KiVW] = VW;
	    	    format(string, sizeof(string), "Ajtó %d kijárata átrakva!", ajtoszama);
				DestroyDynamicArea(Ajtok[ajtoszama][TeruletBent]);
				Ajtok[ajtoszama][TeruletBent] = CreateDynamicCircle(Ajtok[ajtoszama][KiX],Ajtok[ajtoszama][KiY], 1.5);
				#if defined KELLAJTO3D
					UpdateAjto3D(ajtoszama);
				#endif
			}
			else if(egyezik(param[2], "open") OR egyezik(param[2], "close"))
			{
				if(Ajtok[ajtoszama][Vedelem] == 1) return Msg(playerid, "Ez az ajtó védve van ezért nem módosíthatod!");
			    if(Ajtok[ajtoszama][Zarva] != 1)
				{
		    	    Ajtok[ajtoszama][Zarva] = 1;
		    	    format(string, sizeof(string), "Ajtó %d zárva!");
    			}
    			else
    			{
    			    Ajtok[ajtoszama][Zarva] = 0;
    			    format(string, sizeof(string), "Ajtó %d nyitva!");
    			}
			}
			else if(egyezik(param[2], "freeztime"))
			{
				if(Ajtok[ajtoszama][Vedelem] == 1) return Msg(playerid, "Ez az ajtó védve van ezért nem módosíthatod!");
				tmp = strtok(cmdtext, idx);
				new szam = strval(tmp);
				if(szam < 0 OR szam > 10) return Msg(playerid, "0mp a kikapcsoláshoz | a maximum 10mp")
				Ajtok[ajtoszama][Freezel] = szam*1000;
				format(string, sizeof(string), "Ajtó %d a freeze idõ átírva %d másodpercre!", ajtoszama, szam);
			}
			else if(egyezik(param[2], "pickup"))
			{
				if(Ajtok[ajtoszama][Vedelem] == 1) return Msg(playerid, "Ez az ajtó védve van ezért nem módosíthatod!");
				SetPVarInt(playerid, "EditedAjtoID", ajtoszama);
				ShowModelSelectionMenu(playerid, pickuplista, "Ajtó pickup szerkesztése", DIALOG_BG_COLOR, PREV_BG_COLOR, PREV_BG_COLOR2);
				return 1;
			}
			else if(egyezik(param[2], "név") OR egyezik(param[2], "nev"))
			{
				if(Ajtok[ajtoszama][Vedelem] == 1) return Msg(playerid, "Ez az ajtó védve van ezért nem módosíthatod!");
				
				strtok(cmdtext, idx);
				new length = strlen(cmdtext);
				while ((idx < length) && (cmdtext[idx] <= ' '))
				{
					idx++;
				}
				new offset = idx, result[32];
				while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
				{
					result[idx - offset] = cmdtext[idx];
					idx++;
				}
				result[idx - offset] = EOS;

				if(!strlen(result)) return Msg(playerid, "/ajtó [Ajtó ID] név [Új név]", COLOR_ADMIN);
				
				Ajtok[ajtoszama][Nev] = result;
				format(string, sizeof(string), "Ajtó %d új neve: %s", ajtoszama, result);
			}
			else if(egyezik(param[2], "védelem") OR egyezik(param[2], "vedelem"))
			{
				if(!IsTulaj(playerid) AND !IsFejleszto(playerid)) return Msg(playerid, "Csak tulajdonos/fejlesztõ állíthatja egy ajtó védelmét!")
			    if(Ajtok[ajtoszama][Vedelem] != 1)
				{
		    	    Ajtok[ajtoszama][Vedelem] = 1;
		    	    format(string, sizeof(string), "Ajtó %d védelme bekapcsolva!", ajtoszama);
    			}
    			else
    			{
    			    Ajtok[ajtoszama][Vedelem] = 0;
    			    format(string, sizeof(string), "Ajtó %d védelme kikapcsolva!", ajtoszama);
    			}
			}
	        Msg(playerid, string, COLOR_ADMIN);
			OnAjtoUpdate();
		}
		return 1;
	}
	if(strcmp(cmd, "/újajtó", true) == 0 || strcmp(cmd, "/ujajto", true) == 0)
	{
		if(!Admin(playerid, 4)) return HibasParancs(playerid, true);

		for(new p = 0; p < MAXAJTO; p++)
		{
			if(Ajtok[p][Van] == 1 && PlayerToPoint(5, playerid, Ajtok[p][BeX],Ajtok[p][BeY],Ajtok[p][BeZ]))
			{
				SendClientMessage(playerid, COLOR_PIROS, "Itt már van egy ajtó!");
				return 1;
			}
		}
		
		if(params < 1) return Msg(playerid, "Használat: /újajtó [Ajtó neve]");
		
		
		new ajtoszama = NINCS;
		for(new o = 0; o < MAXAJTO; o++)
		{
			if(ajtoszama == NINCS && Ajtok[o][Van] == 0)
				ajtoszama = o;
		}

		if(ajtoszama == NINCS)
		{
			Msg(playerid, "Az ajtók száma elérte a maximumot!", COLOR_ADMIN);
			return 1;
		}

		new length = strlen(cmdtext);
		while ((idx < length) && (cmdtext[idx] <= ' '))
		{
			idx++;
		}
		new offset = idx;
		new result[32];
		while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
		{
			result[idx - offset] = cmdtext[idx];
			idx++;
		}
		result[idx - offset] = EOS;

		new alap[16];
		alap = "All";

		new nev[32];
		nev = "Bejarat";
		if(!strlen(result))
			result = nev;

		new Float:x, Float:y, Float:z;
		GetPlayerPos(playerid, x, y, z);

		Ajtok[ajtoszama][Van] = 1;
		Ajtok[ajtoszama][Csak] = alap;
		Ajtok[ajtoszama][Nev] = result;
		Ajtok[ajtoszama][BeX] = x;
		Ajtok[ajtoszama][BeY] = y;
		Ajtok[ajtoszama][BeZ] = z;
		Ajtok[ajtoszama][BeInt] = GetPlayerInterior(playerid);
		Ajtok[ajtoszama][BeVW] = GetPlayerVirtualWorld(playerid);
		Ajtok[ajtoszama][KiX] = 0.000000;
		Ajtok[ajtoszama][KiY] = 0.000000;
		Ajtok[ajtoszama][KiZ] = 0.000000;
		Ajtok[ajtoszama][KiInt] = 0;
		Ajtok[ajtoszama][KiVW] = 0;
		Ajtok[ajtoszama][Zarva] = 0;
		Ajtok[ajtoszama][Vedelem] = 0;
		Ajtok[ajtoszama][PickupID] = 1239;
		
		#if defined KELLAJTO3D
			UpdateAjto3D(ajtoszama);
		#endif

		format(string, sizeof(string), "Sikeresen leraktál egy ajtót! A másik felét is add meg: '/aajtó %d kijárat'", ajtoszama);
		SendClientMessage(playerid, COLOR_GREEN, string);
		OnAjtoUpdate();
		return 1;
	}

    if(strcmp(cmd, "/uzenet2", true) == 0)
	{
	    if(IsValidPlayerID(playerid))
	    {
	    	tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				Msg(playerid, "Használata: /uzenet2 [stilus(0-6)] [üzeneted]");
				return 1;
			}
			new stilus = strval(tmp);
			if(PlayerInfo[playerid][pAdmin] >= 2)
			{
				new length = strlen(cmdtext);
				while ((idx < length) && (cmdtext[idx] <= ' '))
				{
					idx++;
				}
				new offset = idx;
				new result[128];
				while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
				{
					result[idx - offset] = cmdtext[idx];
					idx++;
				}
				result[idx - offset] = EOS;
				if(!strlen(result))
				{
					Msg(playerid, "Használata: /uzenet2 [stilus(0-6)] [üzeneted]");
					return 1;
				}
				if(stilus == 2) return Msg(playerid, "A 2-es stílus bugos, nem tûnik el tehát nem használhatod!")
				GameTextForAll(result, 6000, stilus);
				return 1;
			}
		}
		return 1;
	}

	if(strcmp(cmd, "/újbelsõ", true) == 0 || strcmp(cmd, "/ujbelso", true) == 0)
	{
	    if(Admin(playerid, FOADMIN))
	    {
			new hazszam, belso;
			if(params == 1)
			{
				hazszam = NINCS;
				for(new i = 0; i < sizeof(HouseInfo); i++)
				{
					if(PlayerToPoint(3, playerid,HouseInfo[i][hEntrancex], HouseInfo[i][hEntrancey], HouseInfo[i][hEntrancez]))
						hazszam = i;
				}

				if(hazszam == NINCS){
					SendClientMessage(playerid, COLOR_PIROS, "Nem vagy a ház bejáratánál! Távolról is átállíthatod: /ujbelso [házszám] [belsõ]");
					return 1;
				}
				belso = strval(param[1]);
			}
			else if(params == 2)
			{
				hazszam = strval(param[1]);
				belso = strval(param[2]);
				if(hazszam >= MAXHAZ || hazszam < 0 || HouseInfo[hazszam][Van] != 1)
					return Msg(playerid, "Nincs ilyen ház!");
			}
			else
				return Msg(playerid, "Használata: /ujbelso [belsõ], vagy távolról: /ujbelso [ház] [belsõ]");

			if(belso < 1 || belso > MAXINT)
			{
				MsgFormat(playerid, "A maximum interior ID: %d", MAXINT);
				return 1;
			}

			HouseInfo[hazszam][hBelso] = belso;

			format(string, sizeof(string), "Ház %d belseje lecserélve! (Belsõ:%d)",hazszam,belso);
			SendClientMessage(playerid, COLOR_GREEN, string);
			//HazUpdate(hazszam, "Belso='%d'", belso);
			HazUpdate(hazszam, HAZ_Belso);
	    } else HibasParancs(playerid, true);
	    return 1;
  	}

	if(strcmp(cmd, "/újadatok", true) == 0 || strcmp(cmd, "/ujadatok", true) == 0)
	{
	    if(!Admin(playerid, FOADMIN)) return HibasParancs(playerid, true);
		
		new hazak = sizeof(HouseInfo), hazszam = -1;
		for(new i = 0; i < hazak; i++)
		{
			if(PlayerToPoint(3, playerid,HouseInfo[i][hEntrancex], HouseInfo[i][hEntrancey], HouseInfo[i][hEntrancez]))
				hazszam = i;
		}

		if(hazszam == NINCS)
		{
			SendClientMessage(playerid, COLOR_PIROS, "Nem vagy a ház bejáratánál!");
			return 1;
		}

		tmp = strtok(cmdtext, idx);
		if(strlen(tmp) == 0) return Msg(playerid, "/ujadatok [ára] [csak(0-1)] [csakneki(név)]");
		new ara = strval(tmp);

		tmp = strtok(cmdtext, idx);
		if(strlen(tmp) == 0) return Msg(playerid, "/ujadatok [ára] [csak(0-1)] [csakneki(név)]");
		new csak = strval(tmp);

		new csakneki[MAX_PLAYER_NAME];

		if(csak == 1)
		{
			new length = strlen(cmdtext);
			while ((idx < length) && (cmdtext[idx] <= ' '))
			{
				idx++;
			}
			new offset = idx;
			while ((idx < length) && ((idx - offset) < (sizeof(csakneki) - 1)))
			{
				csakneki[idx - offset] = cmdtext[idx];
				idx++;
			}
			csakneki[idx - offset] = EOS;
			if(!strlen(csakneki))
			{
				Msg(playerid, "/ujadatok [ára] [csak(0-1)] [csakneki(név)]");
				return 1;
			}
		}
		else
			csakneki = "Nemigenyles";

		HouseInfo[hazszam][hValue] = ara;
		HouseInfo[hazszam][hCsak] = csak;
		HouseInfo[hazszam][hCsakneki] = csakneki;

		if(csak == 0)
			format(string, sizeof(string), "Ház %d adatai átállitva! (Ára: $%s)",hazszam, PenzTordeles(ara));
		else
			format(string, sizeof(string), "Ház %d adatai átállitva! (Ára: $%s | Csak neki: %s)",hazszam, PenzTordeles(ara), csakneki);
		SendClientMessage(playerid, COLOR_GREEN, string);
		//HazUpdate(hazszam, "Ara='%d', Csak='%d', Neki='%s'", ara, csak, csakneki);
		HazUpdate(hazszam, HAZ_Value, HAZ_Csak, HAZ_Csakneki);
		
	    return 1;
  	}

	if(strcmp(cmd, "/ujbejarat", true) == 0 OR strcmp(cmd, "/újbejárat", true) == 0)
	{
	    if(!Admin(playerid, FOADMIN)) return HibasParancs(playerid, true);

		if(params < 2)
		{
			Msg(playerid, "Használata: /ujbejarat [ház] [típus]");
			Msg(playerid, "1: Los Santos, 2: Las Venturas");
			Msg(playerid, "3: GazdagNegyed, 4: Falu, 5: Tanya");
			return 1;
		}

		new hazszam = strval(param[1]), tipus = strval(param[2]);

		if(hazszam < 0 || hazszam >= MAXHAZ || HouseInfo[hazszam][Van] != 1)
		    return SendClientMessage(playerid, COLOR_RED, "Nincs ilyen ház");

		if(tipus < 1 || tipus > 5)
			return Msg(playerid, "Hibás típus!");

		new Float:x, Float:y, Float:z;
		GetPlayerPos(playerid,x,y,z);
		HouseInfo[hazszam][hEntrancex] = x;
		HouseInfo[hazszam][hEntrancey] = y;
		HouseInfo[hazszam][hEntrancez] = z;
		HouseInfo[hazszam][hTipus] = tipus;
		
		#if defined KELLHAZPICKUP
			OnHousePickupUpdate(hazszam);
		#endif

		format(string, sizeof(string), "Ház %d bejárata átrakva!",hazszam);
		Msg(playerid, string, COLOR_ADMIN);
		
		//HazUpdate(hazszam, "X='%f', Y='%f', Z='%f'", x, y, z);
		HazUpdate(hazszam, HAZ_X, HAZ_Y, HAZ_Z);
	    return 1;
  	}
	
	if(egyezik(cmd, "/ujhaz") || egyezik(cmd, "/újház"))
	{
	    if(Admin(playerid, 4))
	    {
			
	        if(UresHazKereses() == -1)
	        {
				format(string, sizeof(string), "Max %d a megengedett ház!", sizeof(HouseInfo));
				Msg(playerid, string, COLOR_ADMIN);
				return 1;
			}
			
			if(params < 2) return Msg(playerid, "/újház [Belsõ (1-37)] [Ára]", COLOR_ADMIN);
			
			new 
				ureshaz = UresHazKereses(),
				interior = strval(param[1]),
				cost = strval(param[2]),
				Float:x, Float:y, Float:z,
				nev[MAX_PLAYER_NAME] = "Nincs_Tulaj"
			;
			
			if(interior < 1 || interior > 37)
			{
				Msg(playerid, "1-37 legyen az inti szám!", COLOR_ADMIN);
				return 1;
			}
			
   			GetPlayerPos(playerid, x, y, z);

			HouseInfo[ureshaz][Van] = 1;
			HouseInfo[ureshaz][Uj] = 1;

			HouseInfo[ureshaz][hEntrancex] = x;
			HouseInfo[ureshaz][hEntrancey] = y;
			HouseInfo[ureshaz][hEntrancez] = z;
			HouseInfo[ureshaz][hBelso] = interior;
			HouseInfo[ureshaz][hHealth] = 0;
			HouseInfo[ureshaz][hArmour] = 0;
			HouseInfo[ureshaz][hOwner] = nev;
			HouseInfo[ureshaz][hValue] = cost;
			HouseInfo[ureshaz][hHel] = 0;
			HouseInfo[ureshaz][hArm] = 0;
			HouseInfo[ureshaz][hLock] = 0;
			HouseInfo[ureshaz][hOwned] = 0;
			HouseInfo[ureshaz][hRooms] = 0;
			HouseInfo[ureshaz][hRent] = 500;
			HouseInfo[ureshaz][hRentabil] = 0;
			HouseInfo[ureshaz][hTakings] = 0;
			HouseInfo[ureshaz][hDate] = 0;
			HouseInfo[ureshaz][hCsak] = 0;
			HouseInfo[ureshaz][hCsakneki] = nev;
			HouseInfo[ureshaz][hCigi] = 0;
			HouseInfo[ureshaz][hKaja] = 0;
			HouseInfo[ureshaz][hKokain] = 0;
			HouseInfo[ureshaz][hHeroin] = 0;
			HouseInfo[ureshaz][hMati] = 0;

			format(string, sizeof(string), "Az új ház elkészült! ID: %d (belsõ: %d, ára: $%d)", ureshaz, interior, cost);
			Msg(playerid, string, COLOR_ADMIN);

			/*SetPlayerPos(playerid, IntInfo[interior][iExitX], IntInfo[interior][iExitY], IntInfo[interior][iExitZ]);
			SetPlayerInterior(playerid, IntInfo[interior][iNumber]);
			SetPlayerVirtualWorld(playerid, ureshaz);*/
			
			#if defined KELLHAZPICKUP
				OnHousePickupUpdate(ureshaz);
			#endif

			new nevek[128], adatok[256];
			nevek = "ID, Eladva, Tulaj, X, Y, Z, Ara, Belso";
			Format(adatok, "'%d', '0', 'Nincs_Tulaj', '%f', '%f', '%f', '%d', '%d'", ureshaz, x, y, z, cost, interior);
			Mysql_Insert(SQL_DB_Hazak, nevek, adatok);
            HazakSzamaOsszesen ++;
	    }
	    return 1;
	}
	
	if(egyezik(cmd, "/újhotel") || egyezik(cmd, "/ujhotel"))
	{
	    if(Admin(playerid, FOADMIN))
	    {
			new ureshotel = UresHotelKereses();
	        if(ureshotel == NINCS) return Msg(playerid, "Max %d a megengedett hotel!", COLOR_ADMIN);
			if(params < 2) return Msg(playerid, "/újhotel [Belsõ(1-37)] [Ára]", COLOR_ADMIN);
			new interior = strval(param[1]);
			new ara = strval(param[2]);
			if(interior < 1 || interior > 37)
			{
				Msg(playerid, "1-37 legyen az inti szám!", COLOR_ADMIN);
				return 1;
			}

			new nev[MAX_PLAYER_NAME] = "Nincs_Tulaj";

			new Float:x, Float:y, Float:z;
   			GetPlayerPos(playerid, x, y, z);

			HotelInfo[ureshotel][Van] = 1;
			HotelInfo[ureshotel][hEntranceX] = x;
			HotelInfo[ureshotel][hEntranceY] = y;
			HotelInfo[ureshotel][hEntranceZ] = z;
			HotelInfo[ureshotel][hBelso] = interior;
			HotelInfo[ureshotel][hTulaj] = nev;
			HotelInfo[ureshotel][hHel] = 0;
			HotelInfo[ureshotel][hArm] = 0;
			HotelInfo[ureshotel][hZarva] = 0;
			HotelInfo[ureshotel][hEladva] = 0;
			HotelInfo[ureshotel][hAra] = ara;
			HotelInfo[ureshotel][hPenz] = 0;
			HotelInfo[ureshotel][hDate] = 0;
			HotelInfo[ureshotel][hCigi] = 0;
			HotelInfo[ureshotel][hKaja] = 0;
			HotelInfo[ureshotel][hKokain] = 0;
			HotelInfo[ureshotel][hHeroin] = 0;
			HotelInfo[ureshotel][hMati] = 0;

			MsgFormat(playerid, "Az új apartman elkészült! ID: %d! (Belsõ %d, Ára: $%d)", ureshotel, interior, ara);

			/*SetPlayerPos(playerid, IntInfo[interior][iExitX], IntInfo[interior][iExitY], IntInfo[interior][iExitZ]);
			SetPlayerInterior(playerid, IntInfo[interior][iNumber]);
			SetPlayerVirtualWorld(playerid, ALAPHOTELVW+ureshotel);*/
			
			#if defined KELLHOTELPICKUP
				OnHotelPickupUpdate(ureshotel);
			#endif
			
			new nevek[128], adatok[256];
			nevek = "ID, Eladva, Tulaj, X, Y, Z, Ara, Belso";
			Format(adatok, "'%d', '0', 'Nincs_Tulaj', '%f', '%f', '%f', '%d', '%d'", ureshotel, x, y, z, ara, interior);
			Mysql_Insert(SQL_DB_Hotelek, nevek, adatok);
            HotelekSzamaOsszesen++;
	    }
	    return 1;
	}

	if(strcmp(cmd, "/park", true) == 0)
	{
	    if(IsValidPlayerID(playerid))
		{
            if(!Admin(playerid, 1)) return HibasParancs(playerid, true);
			{
	            new Float:x,Float:y,Float:z, Float:a;
				new carid;

				carid = GetClosestVehicle(playerid);
				if(GetDistanceToVehicle(playerid, carid) > 5.5)
					return Msg(playerid, "A közeledben nincs jármû!");

				new kocsi = IsAVsKocsi(carid);

				if(kocsi == NINCS) return Msg(playerid, "Ez a jármû a módba van beleírva!", COLOR_ADMIN);

				GetVehiclePos(carid, x, y, z);
				GetVehicleZAngle(carid, a);

	            GetDamageStat(carid);
				
				engineOn[carid] = 0;
				SetJarmu(carid, KOCSI_MOTOR, false);

				ParkCar(kocsi, x, y, z, a, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));

				if(CarInfo[kocsi][cOwned]) {
					format(string, sizeof(string), "~n~~g~V-s kocsi %d leparkolva~n~Tulaj: %s", kocsi, CarInfo[kocsi][cOwner]);
				} else {
					format(string, sizeof(string), "~n~~g~V-s kocsi %d leparkolva~n~Tulaj: Nincs", kocsi);
				}
				
				GameTextForPlayer(playerid, string, 10000, 3);

				if(IsPlayerInVehicle(playerid, carid))
				{
					SetPlayerPos(playerid,x,y,z+1);
					TogglePlayerControllable(playerid, 1);
				}
			}
		}
		return 1;
	}

	if(egyezik(cmd, "/újmodel") || egyezik(cmd, "/ujmodel"))
	{
	    if(IsValidPlayerID(playerid))
		{
			if(!Admin(playerid, 4)) return HibasParancs(playerid, true);
			
			new kocsi = GetClosestVehicle(playerid), vs = IsAVsKocsi(kocsi);			
			if(GetDistanceToVehicle(playerid, kocsi) > 5.0) return Msg(playerid, "Nincs jármû a közeledben!");
			if(vs == NINCS && !Admin(playerid, SZUPERADMIN)) return Msg(playerid, "Ez a jármû a módba van beleírva!");
			
			if(params < 1)
			{
				Msg(playerid, "Ha tudod a jármû nevét vagy ID-jét akkor használd ezt: /újmodel [Jármû név/Jármû ID]", COLOR_ADMIN);
				ShowModelSelectionMenu(playerid, osszesjarmulista, "New Vehicle Model", DIALOG_BG_COLOR, PREV_BG_COLOR, PREV_BG_COLOR2);
			}
			else
			{
				new modelid = NINCS;
				if(IsNumeric(param[1]))
					{ modelid = strval(param[1]); }
				else
					{ modelid = GetVehicleModelIDFromName(param[1]); }

				if(!IsValidCar(modelid)) return Msg(playerid, "Ismeretlen jármû név/Hibás jármû ID!", COLOR_ADMIN);
	
				UjJarmuModel(playerid, modelid);
			}
			
			//if(!IsRicardo(playerid))
				//ABroadCastFormat(COLOR_LIGHTRED, 1, "%s átalakította a %s-as/es rendszámú jármûvet erre:", PlayerName(playerid), kocsi, CAR_Model);
			return 1;
		}
		return 1;
	}
	if(egyezik(cmd, "/delmycar"))
	{
		if(!Admin(playerid, 1)) return HibasParancs(playerid, true);
		
		new carid = AdminKocsiID[playerid];
		if(carid == NINCS) return Msg(playerid, "Nincs lekért jármûved! (/veh)", COLOR_ADMIN);
		PlayerForeach(x)
		{
			if(IsPlayerInVehicle(x, carid))
			{
				RemovePlayerFromVehicle(x);
				Msg(x, "Ez egy Adminjármû amely törlésre kerül.");
			}
		}
		AdminJarmu[carid] = 0;
		SzirenaTorles(carid);
		DestroyVehicle(carid);
		AdminKocsiID[playerid] = NINCS;
		Msg(playerid, "A lekért jármûved törölve lett!", COLOR_ADMIN);
		return 1;
	}
	
	if(egyezik(cmd, "/veh"))
	{
		if(!Admin(playerid, 4)) return HibasParancs(playerid, true);
		if(!IsAdminSzolis(playerid)) return Msg(playerid, "Ezt a parancsot csak AdminSzolgálatban használhatod!", COLOR_ADMIN);
		
		if(AdminKocsiID[playerid] != NINCS) 
		{
			PlayerTextFormat(playerid, "Te már kértél le jármûvet amelynek az ID-je %d! Törléshez /delmycar", AdminKocsiID[playerid]);
			Msg(playerid, PlayerText[playerid], COLOR_ADMIN);
			return 1;
		}
		
		if(params < 1)
		{
			Msg(playerid, "Ha tudod a jármû nevét vagy ID-jét akkor használd ezt: /veh [Jármû név/Jármû ID]", COLOR_ADMIN);
			ShowModelSelectionMenu(playerid, osszesjarmulista, "Admin Vehicle", DIALOG_BG_COLOR, PREV_BG_COLOR, PREV_BG_COLOR2);
		}
		else
		{
			new modelid = NINCS;
			if(IsNumeric(param[1])) { 
				modelid = strval(param[1]); 
			} else {
				modelid = GetVehicleModelIDFromName(param[1]); 
			}

			if(!IsValidCar(modelid)) return Msg(playerid, "Ismeretlen Jármû Név/Hibás jármû ID!", COLOR_ADMIN);
			
			UjAdminJarmu(playerid, modelid, strval(param[2]), strval(param[3]));
		}
		return 1;
	}
	if(egyezik(cmd, "/vehlist"))
	{
		ShowModelSelectionMenu(playerid, osszesjarmulista, "Vehicle Price List", DIALOG_BG_COLOR, PREV_BG_COLOR, PREV_BG_COLOR2);
		return 1;
	}
	if(strcmp(cmd, "/újfrkocsi", true) == 0 || strcmp(cmd, "/ujfrkocsi", true) == 0)
	{
	    if(!Admin(playerid, 4)) return HibasParancs(playerid, true);
		if(!IsAdminSzolis(playerid)) return Msg(playerid, "Ezt a parancsot csak AdminSzolgálatban használhatod!", COLOR_ADMIN);
		
		new kocsiid = -1;
		for(new c = 0; c < MAXVSKOCSI; c++)
		{
			if(CarInfo[c][Van] != 1 && kocsiid == -1)
			{
				kocsiid = c;
				break;
			}
		}
		
		if(kocsiid == -1)
		{
			SendFormatMessage(playerid, COLOR_LIGHTRED, "Több kocsit nem tudsz lerakni! A maximum %d!", MAXVSKOCSI);
			return 1;
		}
	
		if(params < 2) return Msg(playerid, "Használat: /újfrkocsi [Frakció ID] [Jármû ID] [Szín1] [Szín2]", COLOR_ADMIN);
		
		new frakcio = strval(param[1]);
		new model = strval(param[2]);
		new szin1 = strval(param[3]);
		new szin2 = strval(param[4]);
		
		if(!IsValidCar(model))
		{
			SendClientMessage(playerid, COLOR_PIROS, "Hibás jármû ID!");
			return 1;
		}
		
		if(FrakcioInfo[frakcio][fJarmuvekSzama] >= MAX_FRAKCIOKOCSI && !IsRicardo(playerid)) 
		{
			SendFormatMessage(playerid, COLOR_PIROS, "A LEGÁLIS szervezeteknek maximum %d kocsijuk lehet", MAX_FRAKCIOKOCSI);
			return 1;
		}	
		
		new Float:x, Float:y, Float:z, Float:a;
		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, a);
	
		UjFrakcioJarmu(frakcio, x, y, z, a, model, szin1, szin2);
		
		SetPlayerPos(playerid, x, y, z+1);
		
		new car = NINCS;
		if(!IsPlayerInAnyVehicle(playerid)) {
			car = GetClosestVehicle(playerid);
		} else {
			car = GetPlayerVehicleID(playerid);
		}
		
		if(GetDistanceToVehicle(playerid, car) < 5.0) MaxUzemanyag(car);
		
		SendClientMessage(playerid, COLOR_GREEN, "Új kocsi lerakva!");
		
		return 1;
	}

	if(strcmp(cmd, "/deleteint", true) == 0)
	{
	    if(IsValidPlayerID(playerid))
		{
	    	new jatekosneve[MAX_PLAYER_NAME];
			GetPlayerName(playerid, jatekosneve, sizeof(jatekosneve));
		    if(IsFejleszto(playerid))
		    {
				tmp = strtok(cmdtext, idx);
				if(!strlen(tmp))
				{
					Msg(playerid, "/deleteint [szám]");
					return 1;
				}

                new ii = strval(tmp);

                if(ii >= IntekSzama())
				{
                    SendClientMessage(playerid, COLOR_PIROS, "Nincs ilyen interior!");
					return 1;
                }

				IntInfo[ii][iType] = 0;

				format(string, sizeof(string), "Interior %d torolve cimket kapott", ii, IntInfo[ii][iType]);
                GameTextForPlayer(playerid, string, 2500, 3);
			}
		}
		return 1;
	}

	if(strcmp(cmd, "/editint", true) == 0)
	{
	    if(IsValidPlayerID(playerid))
		{
		    if(IsFejleszto(playerid))
		    {
				tmp = strtok(cmdtext, idx);
				if(!strlen(tmp)) return Msg(playerid, "/editint [szám]");

                new ii = strval(tmp);

                if(ii >= IntekSzama())
				{
                    Msg(playerid, "Nincs ilyen interior!");
					return 1;
                }

				new Float:x, Float:y, Float:z;
				GetPlayerPos(playerid, x, y, z);
				IntInfo[ii][iNumber] = GetPlayerInterior(playerid);
				IntInfo[ii][iExitX] = x;
				IntInfo[ii][iExitY] = y;
				IntInfo[ii][iExitZ] = z;

				format(string, sizeof(string), "Interior %d szerkesztve", ii, IntInfo[ii][iType]);
                GameTextForPlayer(playerid, string, 2500, 3);

                format(string, sizeof(string), "Interior %d szerkesztve (%d, %f, %f, %f)",ii, IntInfo[ii][iType], IntInfo[ii][iNumber],IntInfo[ii][iExitX], IntInfo[ii][iExitY], IntInfo[ii][iExitZ]);
				SendClientMessage(playerid, COLOR_GREEN, string);
			}
		}
		return 1;
	}

	if(strcmp(cmd, "/goint", true) == 0 || strcmp(cmd, "/gotoint", true) == 0)
	{
	    if(IsValidPlayerID(playerid))
		{
		    if(PlayerInfo[playerid][pAdmin] >= FOADMIN)
		    {
				tmp = strtok(cmdtext, idx);
				if(!strlen(tmp))
				{
					Msg(playerid, "/goint [szám]");
					return 1;
				}

                new ii = strval(tmp);

                if(ii > IntekSzama()){
                    SendClientMessage(playerid, COLOR_PIROS, "Nincs ilyen interior!");
					return 1;
                }

				SetPlayerInterior(playerid, IntInfo[ii][iNumber]);
				SetPlayerPos(playerid, IntInfo[ii][iExitX], IntInfo[ii][iExitY], IntInfo[ii][iExitZ]);

				format(string, sizeof(string), "Interior %d %s", ii, IntInfo[ii][iType]);
                GameTextForPlayer(playerid, string, 2500, 3);

                format(string, sizeof(string), "Interior %d/%s (%d, %f, %f, %f)",ii, IntInfo[ii][iType], IntInfo[ii][iNumber],IntInfo[ii][iExitX], IntInfo[ii][iExitY], IntInfo[ii][iExitZ]);
				SendClientMessage(playerid, COLOR_GREEN, string);
			}
		}
		return 1;
	}
	if(strcmp(cmd, "/poz2", true) == 0)
	{
	    if(IsValidPlayerID(playerid))
	    {
			new Float:posx, Float:posy, Float:posz, Float:angle;

			GetPlayerPos(playerid, posx, posy, posz);

			GetPlayerFacingAngle(playerid, angle);

			format(string, sizeof(string), "Poziciód: (X:%.3f | Y:%.3f | Z:%.3f | Angle: %.3f | Int:%d | VW:%d)", posx, posy, posz, angle, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));
			Msg(playerid, string);
			new Float:vposx, Float:vposy, Float:vposz;
			GetPlayerCameraFrontVector(playerid, vposx, vposy, vposz);
			format(string, sizeof(string), "KameraVektor: (X:%.3f | Y:%.3f | Z:%.3f )", vposx, vposy, vposz);
			Msg(playerid, string);
		}
		return 1;
	}
	if(strcmp(cmd, "/poz", true) == 0 OR strcmp(cmd, "/pos", true) == 0)
	{
	    if(IsValidPlayerID(playerid))
	    {
			new Float:posx, Float:posy, Float:posz, Float:angle;
			new kocsi = NINCS;
			if(IsPlayerInAnyVehicle(playerid))
			{
				kocsi = GetPlayerVehicleID(playerid);
				GetVehiclePos(kocsi, posx, posy, posz);
			}
			else
				GetPlayerPos(playerid, posx, posy, posz);
			if(kocsi == NINCS)
			{
				GetPlayerFacingAngle(playerid, angle);
				format(string, sizeof(string), "Poziciód: (X:%.3f | Y:%.3f | Z:%.3f | Angle: %.3f | Int:%d | VW:%d)", posx, posy, posz, angle, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));
			}
			else
			{
				GetVehicleZAngle(kocsi, angle);
				format(string, sizeof(string), "Poziciód: (X:%.3f | Y:%.3f | Z:%.3f | Angle: %.3f | Int:%d | VW:%d)", posx, posy, posz, angle, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));
			}
			Msg(playerid, string);
		}

		return 1;
	}
	if(strcmp(cmd, "/leaderek", true) == 0) // Leaderek
    {
		new count = 0;
		Msg(playerid, ValasztoVonal("Frakció leaderek"));
		PlayerForeach(i)
		{
			if(IsValidPlayerID(i))
			{
				if(PlayerInfo[i][pLeader] > 0)
				{
					new nev[32], mehet = 0;
					if(PlayerInfo[i][pLeader] != 0 && PlayerInfo[i][pLeader] < MAX_FRAKCIO)
						nev = Szervezetneve[PlayerInfo[i][pLeader]-1][0];
					else
						mehet = 5;

					if(mehet == 0)
					{
						GetPlayerName(i, sendername, sizeof(sendername));
						format(string, 64, "%s: %s", nev, sendername);
						Msg(playerid, string);
						//ShowPlayerDialog(playerid, DIALOG_NINCS, DIALOG_STYLE_MSGBOX, "Frakció leaderek", string, "Bezárás", "");
						count ++;
					}
				}
			}
		}
		if(count == 0) Msg(playerid, "Nincs fent leader");
		Msg(playerid, ValasztoVonal("Frakció leaderek"));
		return 1;
    }
	if(egyezik(cmd, "/asay"))
    {
		if(!Admin(playerid, 1)) return HibasParancs(playerid, true);
		GetPlayerName(playerid, sendername, sizeof(sendername));
   	    new result[200];
		new length = strlen(cmdtext);
		while ((idx < length) && (cmdtext[idx] <= ' '))
		{
			idx++;
		}
		new offset = idx;
		while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
		{
			result[idx - offset] = cmdtext[idx];
			idx++;
		}
		result[idx - offset] = EOS;
       	if(!strlen(result)) return Msg(playerid, "Használat: /asay [üzenet]", COLOR_ADMIN);
		
		if(strlen(result) > 128) return Msg(playerid, "San Andreas-ban a maximum karakterek száma maximum 128 lehet!");
		
		
		PlayerTextFormat(playerid, "(%s) %s: %s", AdminSzint(playerid), AdminName(playerid), result);
		PlayerForeach(x)
		{
			SCM(x, COLOR_PIROS, PlayerText[playerid]);
		}
		
		printf("%s\n", string);
		
		return 1;
    }
	if(strcmp(cmd, "/agivelicense", true) == 0 || strcmp(cmd, "/agl", true) == 0)
	{
	    if(IsValidPlayerID(playerid))
	    {
	        if(PlayerInfo[playerid][pAdmin] >= 5)
	        {
				if(params < 2)
				{
				    Msg(playerid, "Használat: /agl [Engedély] [JátékosID/NévRészlet]");
				    Msg(playerid, "Jogosítványok: autó, motor, repülõ, Csomagszallito, horgász, hajó, fegyver");
				    Msg(playerid, "Engedélyek: személyi, útlevél, munkavállalási(munka)");
					return 1;
				}
				if(egyezik(param[1], "motor"))
				{
					new p = ReturnUser(param[2]);
					if(p == INVALID_PLAYER_ID) return 1;
					Msg(playerid, "Adtál egy motor jogsit neki.");
					Msg(p, "Kaptál egy motor jogsit.");
					PlayerInfo[p][pMotorJogsi] = JOGSI_MOTOR;
				}
				else if(egyezik(param[1], "Csomagszallito"))
				{
					new p = ReturnUser(param[2]);
					if(p == INVALID_PLAYER_ID) return 1;
					Msg(playerid, "Adtál egy Csomagszallito jogsit neki.");
					Msg(p, "Kaptál egy Csomagszallito jogsit.");
					PlayerInfo[p][pCsomagszallitoJogsi] = JOGSI_Csomagszallito;
				}
				else if(egyezik(param[1], "hajo") || egyezik(param[1], "hajó"))
				{
					new p = ReturnUser(param[2]);
					if(p == INVALID_PLAYER_ID) return 1;
					Msg(playerid, "Adtál egy hajó jogsit neki.");
					Msg(p, "Kaptál egy hajó jogsit.");
					PlayerInfo[p][pBoatLic] = JOGSI_HAJO;
				}
				else if(egyezik(param[1], "horgasz") || egyezik(param[1], "horgász"))
				{
					new p = ReturnUser(param[2]);
					if(p == INVALID_PLAYER_ID) return 1;
					Msg(playerid, "Adtál egy horgász engedélyt neki.");
					Msg(p, "Kaptál egy horgász engedélyt.");
					PlayerInfo[p][pFishLic] = JOGSI_HORGASZ;
				}
				else if(egyezik(param[1], "auto") || egyezik(param[1], "autó"))
				{
					new p = ReturnUser(param[2]);
					if(p == INVALID_PLAYER_ID) return 1;
					Msg(playerid, "Adtál egy autó jogsit neki.");
					Msg(p, "Kaptál egy autó jogsit.");
					PlayerInfo[p][pCarLic] = JOGSI_AUTO;
				}
				else if(egyezik(param[1], "repulo") || egyezik(param[1], "repülõ"))
				{
					new p = ReturnUser(param[2]);
					if(p == INVALID_PLAYER_ID) return 1;
					Msg(playerid, "Adtál egy repülõ jogsit neki.");
					Msg(p, "Kaptál egy repülõ jogsit.");
					PlayerInfo[p][pFlyLic] = JOGSI_REPULO;
				}
				else if(egyezik(param[1], "fegyver"))
				{
					new p = ReturnUser(param[2]);
					if(p == INVALID_PLAYER_ID) return 1;
					Msg(playerid, "Adtál egy fegyver engedélyt neki.");
					Msg(p, "Kaptál egy fegyver engedélyt.");
					PlayerInfo[p][pGunLic] = JOGSI_FEGYVER;
				}
				else if(egyezik(param[1], "személyi") || egyezik(param[1], "szemelyi"))
				{
					new p = ReturnUser(param[2]);
					if(p == INVALID_PLAYER_ID) return 1;
					Msg(playerid, "Adtál egy személyit neki.");
					Msg(p, "Kaptál egy személyit.");
					PlayerInfo[p][pSzemelyi] = 50;
				}
				else if(egyezik(param[1], "útlevél") || egyezik(param[1], "utlevel"))
				{
					new p = ReturnUser(param[2]);
					if(p == INVALID_PLAYER_ID) return 1;
					Msg(playerid, "Adtál egy személyit neki.");
					Msg(p, "Kaptál egy személyit.");
					PlayerInfo[p][pUtlevel] = 50;
				}
				else if(egyezik(param[1], "munkavállalási") || egyezik(param[1], "munkavallalasi") || egyezik(param[1], "munka"))
				{
					new p = ReturnUser(param[2]);
					if(p == INVALID_PLAYER_ID) return 1;
					Msg(playerid, "Adtál egy személyit neki.");
					Msg(p, "Kaptál egy személyit.");
					PlayerInfo[p][pMunkaVallalasi] = 50;
				}
				else
					Msg(playerid, "Hibás engedély!");
	        }
	    }
	    return 1;
	}
	if(strcmp(cmd, "/arendszám", true)== 0 || egyezik(cmd, "/arendszam"))
	{
		if(Admin(playerid, SZUPERADMIN))
		{
		    if(params != 1) return Msg(playerid, "/arendszám [Új rendszám] (random - véletlenszerû)");
			if(!egyezik(param[1], "random"))
			{
				if(strlen(param[1]) > 12 || strlen(param[1]) < 7) return Msg(playerid, "Min 7, Max 12 karakter");
			}
			
			new car = NINCS;
           	if(!IsPlayerInAnyVehicle(playerid))
        		car = GetClosestVehicle(playerid);
			else
				car = GetPlayerVehicleID(playerid);
			new vs = IsAVsKocsi(car);
			if(vs == NINCS) return Msg(playerid, "Ez a jármû a módba van beleírva!");
		   	if(GetDistanceToVehicle(playerid, car) < 5.0)
		   	{
		   	    SendFormatMessage(playerid, COLOR_GRAD1, "Rendszám átírva! [id:%d / Régi: %s / Új rendszám: %s]", car, CarInfo[vs][cRendszam],param[1]);
				
				if(egyezik(param[1], "random"))
					UjRendszam(car, "random");
				else
				    UjRendszam(car, param[1]);
				new Float:Pos[4];
				GetVehiclePos(car,Pos[0],Pos[1],Pos[2]);
				GetVehicleZAngle(car,Pos[3]);
				KocsiRespawnWR(car);
				SetVehiclePos(car,Pos[0],Pos[1],Pos[2]);
				SetVehicleZAngle(car,Pos[3]);
				
				OnVehicleStreamIn(car, playerid);
			}
			else
				return Msg(playerid, "A közeledben nincs jármû!");

			if(IsPlayerInAnyVehicle(playerid))
				UnFreeze(playerid);
	        return 1;
		}
		else
		{
			Msg(playerid, "Nem vagy admin/nincs elég rangod hozzá...");
		}
		return 1;
	}
	if(strcmp(cmd, "/rendezvény", true) == 0 || strcmp(cmd, "/rendezveny", true) == 0)
	{
	    if(IsValidPlayerID(playerid))
	    {
			GetPlayerName(playerid, sendername, sizeof(sendername));
			new length = strlen(cmdtext);
			while ((idx < length) && (cmdtext[idx] <= ' '))
			{
				idx++;
			}
			new offset = idx;
			new result[80];
			while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
			{
				result[idx - offset] = cmdtext[idx];
				idx++;
			}
			result[idx - offset] = EOS;
			if(!strlen(result))
			{
				Msg(playerid, "/rendezvény [szöveg]");
				return 1;
			}
			SzovegEllenorzes(playerid, result, "/rendezveny", ELLENORZES_HIRDETES);
			if(LMT(playerid, LMUNKA_ALLAM) || IsAdmin(playerid))
			{
				OOCOff(COLOR_RENDEZVENY, ValasztoVonal("RENDEZVÉNY"));
				format(string, sizeof(string), "%s", result);
				OOCOff(COLOR_WHITE, string);
				OOCOff(COLOR_RENDEZVENY, ValasztoVonal("RENDEZVÉNY"));
				printf("%s\n", string);
				format(string, sizeof(string), "%s használta a /rendezvény parancsot", AdminName(playerid));
				ABroadCast(COLOR_LIGHTRED, string, 1);
			}
		}
		return 1;
	}
	if(!strcmp(cmd, "/ellop", true) || egyezik(cmd, "/steal"))
	{
		if(KezdoJatekos(playerid))
		{
			MsgFormat(playerid, "Ehhez a parancshoz minimum %d. szint szükséges!", MINSZINT);
			return 1;
		}
		
	    new tmpcar = GetPlayerVehicleID(playerid);
	    if(IsBerelhetoJarmu(tmpcar))
	    {
			return Msg(playerid, "Ne lopd már el a bérelhetõ jármûveket! -.-");
	    }
		if(IsKocsi(tmpcar, "Gokart"))	
		{
			return Msg(playerid, "Ne lopd már el a gokartot!");
		}
		if(!IsPlayerInAnyVehicle(playerid))
		{
			return Msg(playerid, "Nem vagy jármûben!");
		}
		if(IsABicikli(GetPlayerVehicleID(playerid)))
		{
			return Msg(playerid, "Ez egy bicikli, a biciklin nincs motor...");
		}
		if(GetPlayerState(playerid) == PLAYER_STATE_PASSENGER) return 1;

		new car = IsAVsKocsi(GetPlayerVehicleID(playerid));
		if(car != -1)
		{
		    if(CarInfo[car][cOwned] == 0) return 1;
			if(CarInfo[car][cBRendszerAktiv] == 1)
			{
				return Msg(playerid, "Biztonsági rendszer van telepítve a jármûben.");
			}
		}
		new kocsi = GetPlayerVehicleID(playerid);
		if(RendorKocsi(kocsi)) return Msg(playerid, "Rendvédelmi jármûvet?! Észenvagy?!");
		if(engineOn[kocsi] == 0)
		{
			if(KocsiElet(kocsi) <= 350)
			{
				Msg(playerid, "A jármû elromlott! (/v repair)");
				engineOn[kocsi] = 0;
				SetJarmu(kocsi, KOCSI_MOTOR, false);
				return 1;
			}
			if(Gas[kocsi][0] <= 0 && Gas[kocsi][1] <= 0)
			{
				return Msg(playerid, "Nincs elég üzemanyag!");
			}
			if(!AMT(playerid, MUNKA_AUTOTOLVAJ)) return Msg(playerid, "Nem vagy autótolvaj!");
	        if(MunkaFolyamatban[playerid] == 1) return 1;
			if(PlayerToPoint(100, playerid, 1477.1985,-1804.2847,13.5469) ||
				PlayerToPoint(80, playerid, 1596.8505,-1677.9633,5.8906) ||
				PlayerToPoint(50, playerid, 1214.0414,-1324.4862,13.5670) ||
				PlayerToPoint(250, playerid, 175.1913,1904.2084,18.2397) ||
				PlayerToPoint(140, playerid, -1593.2107,727.9420,-4.9063))
			{
				Msg(playerid, "Itt akarsz kocsit lopni?! Nem félsz hogy észrevesznek?");
				return 1;
			}
			if(HazKozelebe(playerid, 20.0) != NINCS)
			{
				Msg(playerid, "Ne lopd már el a háza elõl...");
				return 1;
			}

			MunkaFolyamatban[playerid] = 1;
		 	SendClientMessage(playerid, COLOR_GREEN, "Szétszeded a mûszerfalat...");
			Cselekves(playerid, "kicsavarozza a mûszerfal csavarjait",0);
			SetTimerEx("KocsiLopas",10000,0, "dd",playerid,0);
			GameTextForPlayer(playerid, "~w~Csavarozod a mûszerfalat...",10000,3);
			return 1;
		}
	}
	if(strcmp(cmd, "/erõsítés", true)==0 || strcmp(cmd, "/bk", true)==0)
	{	
	    if(NemMozoghat(playerid)) return Msg(playerid, "Most nem kérhetsz erõsítést!");
		if(OnDuty[playerid] == 0) return Msg(playerid, "Nem vagy szolgálatban!");
		if(Erosites[playerid] == true) return Msg(playerid, "Már hívtál erõsítést!");
		new length = strlen(cmdtext);
		while ((idx < length) && (cmdtext[idx] <= ' '))
		{
			idx++;
		}
		new offset = idx;
		new result[70];
		while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
		{
			result[idx - offset] = cmdtext[idx];
			idx++;
		}
		
		result[idx - offset] = EOS;
		GetPlayerName(playerid, sendername, sizeof(sendername));
		/*format(string, sizeof(string), "* Valaki erõsítést kért");
		ProxDetector(30.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);*/
		printf("%s\n", string);
		format(string, sizeof(string), "HQ: Minden egységnek! %s 10-0H 10-20 %s, Code 3", PlayerName(playerid), GetPlayerZoneName(playerid));
		Erosites[playerid] = true;
		ErositesIdo[playerid] = EROSITESIDO;
		PlayerForeach(x)
		{
			if(IsACop(x))
			{
				SendClientMessage(x, COLOR_DBLUE, string);
				SetPlayerMarkerForPlayer(x, playerid, COLOR_DBLUE);
			}
		}
		return 1;
	}

	if(strcmp(cmd, "/erõsítéslemond", true)==0 || strcmp(cmd, "/cbk", true)==0)
	{
		if(IsValidPlayerID(playerid))
		{
			if(OnDuty[playerid] == 0) return Msg(playerid, "Nem vagy szolgálatban!");
			if(Erosites[playerid] == false) return Msg(playerid, "Nem hívtál erõsítést!");
			{
				/*format(string, sizeof(string), "* Valaki lemondta az erõsítést.");
				ProxDetector(30.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);*/
				printf("%s\n", string);
				format(string, sizeof(string), "** %s lemondta az erõsítést!", PlayerName(playerid));		
				SendTeamMessage(LMUNKA_LSPD, COLOR_DBLUE, string);
				SendTeamMessage(LMUNKA_FBI, COLOR_DBLUE, string);
				SendTeamMessage(LMUNKA_KATONA, COLOR_DBLUE, string);
				SendTeamMessage(LMUNKA_SWAT, COLOR_DBLUE, string);
				PlayerForeach(x)
				{
					if(!IsACop(x) && PlayerInfo[x][pSWATTag] > 0)
						SendClientMessage(x, COLOR_DBLUE, string);
					else if(!IsACop(x) && PlayerInfo[x][pNIDTag] > 0)
						SendClientMessage(x, COLOR_DBLUE, string);
					else if(!IsACop(x) && PlayerInfo[x][pSWATTag] > 0 && PlayerInfo[x][pNIDTag] > 0)
						SendClientMessage(x, COLOR_DBLUE, string);
				}
				Erosites[playerid] = false;
				ErositesIdo[playerid] = 0;
				PlayerForeach(x)
				{
					if(IsACop(x))
						SetPlayerMarkerForPlayer(x, playerid, COLOR_INVISIBLE);
				}
				return 1;
			}
		}
	}
	
	if(strcmp(cmd, "/setskin", true) == 0)
	{
		if(Admin(playerid, 3))
		{
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				Msg(playerid,"/setskin [JátékosID/NévRészlet] [skinid]");
				return 1;
			}
			new player1 = ReturnUser(tmp);
			tmp = strtok(cmdtext, idx);

			if(!strlen(tmp))
			{
				Msg(playerid,"/setskin [JátékosID/NévRészlet] [skinid]");
				return 1;
			}

			new SkinID;
			SkinID = strval(tmp);
			if(IsValidSkin(SkinID))
			{

				tmp = strtok(cmdtext, idx);

				GetPlayerName(playerid, sendername, sizeof(sendername));
				
				if(player1 != playerid) {
					MsgFormat(player1, "(%s) %s átállította a skined erre: %d", AdminSzint(playerid), sendername, SkinID);
				}
				
				PlayerTextFormat(playerid, "Átállítottad [%d]%s skinét erre: %d", player1, PlayerName(player1), SkinID);
				Msg(playerid, PlayerText[playerid], COLOR_ADMIN);
				
				SetPlayerSkin(player1, SkinID);
				PlayerInfo[player1][pModel] = SkinID;
			}
			else
			{
				SendClientMessage(playerid, COLOR_GRAD2, "ERROR: Incorrect skin id");
				return 1;
			}
		}
		else
			SendClientMessage(playerid,COLOR_GRAD2,"ERROR: You are not a high enough level to use this command");

		return 1;
	}
	if(strcmp(cmd, "/megpróbál", true) == 0 || strcmp(cmd, "/megprobal", true) == 0 OR strcmp(cmd, "/try", true) == 0)
	{
	    if(PlayerCuffed[playerid] == 2) return Msg(playerid, "Bilincsben nincs megpróbál!");
	    if(Animban[playerid] != 0) return Msg(playerid, "Animban nincs megpróbál!");
		if(Megprobal[playerid] != 0) return Msg(playerid, "Nem próbálkozhatsz ilyen sûrûn!");
		if(Csendvan && PlayerInfo[playerid][pAdmin] == 0) return Msg(playerid, "Most nem beszélhetsz!");
		new length = strlen(cmdtext);
		while ((idx < length) && (cmdtext[idx] <= ' '))
		{
			idx++;
		}
		new offset = idx;
		new result[128], jatekosnev[124];
		while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
		{
			result[idx - offset] = cmdtext[idx];
			idx++;
		}
		result[idx - offset] = EOS;
		if(FloodCheck(playerid, cmd)) return 1;
		
		if(!strlen(result)) return Msg(playerid, "Használat: /megpróbál [akció]");
		else
		{
			if(Maszk[playerid] != 0) {
				jatekosnev = MaszkString(playerid);
			} else {
				jatekosnev = PlayerName(playerid);
			}
		
			switch(random(2))
			{
				case 1:
				{
					if(PlayerInfo[playerid][pHamisNev] == 0)
					{
						format(string, sizeof(string), "** %s megpróbál %s és sikerül neki", jatekosnev, result);
						ProxDetector(30.0, playerid, string, COLOR_GREEN,COLOR_GREEN,COLOR_GREEN,COLOR_GREEN,COLOR_GREEN);
						printf("%s\n", string);
					}
					else
					{
						format(string, sizeof(string), "** %s megpróbál %s és sikerül neki", PlayerInfo[playerid][pHamisNev], result);
						ProxDetector(30.0, playerid, string, COLOR_GREEN,COLOR_GREEN,COLOR_GREEN,COLOR_GREEN,COLOR_GREEN);
						printf("%s\n", string);
					}
				}
				default:
				{
					if(PlayerInfo[playerid][pHamisNev] == 0)
					{
						format(string, sizeof(string), "** %s megpróbál %s, de sajnos nem sikerül neki", jatekosnev, result);
						ProxDetector(30.0, playerid, string, COLOR_PIROS,COLOR_PIROS,COLOR_PIROS,COLOR_PIROS,COLOR_PIROS);
						printf("%s\n", string);
					}
					else
					{
						GetPlayerName(playerid, playername, sizeof(playername));
						format(string, sizeof(string), "** %s megpróbál %s, de sajnos nem sikerül neki", PlayerInfo[playerid][pHamisNev], result);
						ProxDetector(30.0, playerid, string, COLOR_PIROS,COLOR_PIROS,COLOR_PIROS,COLOR_PIROS,COLOR_PIROS);
						printf("%s\n", string);
					}
				}
			}
			Megprobal[playerid] = MEGPROBALIDO;
  		}
        return 1;
    }
	if(strcmp(cmd, "/adminszoli", true) == 0 || strcmp(cmd, "/aszoli", true) == 0)
	{
		if(!Admin(playerid, 1)) return HibasParancs(playerid, true);
		if(FloodCheck(playerid, cmd)) return 1;
		
		/*if(AszoliIdo[playerid] != 0 && !Admin(playerid, FOADMIN))
		{
			new szoveg[124];
			Format(szoveg, "3 percenként állhatsz AdminSzolgálatba! (még %d perc, %d mp)", AszoliIdo[playerid]/60, AszoliIdo[playerid]%60);
			Msg(playerid, szoveg);
			return 1;
		}*/
		
		if(!AdminDuty[playerid])
		{
			AdminDuty[playerid] = true;
			DMOff[playerid] = 1;
			SetHealth(playerid, MAXHP);
			
			Nevek[playerid] = 1;
			ShowNames(playerid, 1);
			
			if(IsFejleszto(playerid)) {
				HidePM[playerid] = 1;
			}
			
			PhoneOnline[playerid] = 1; // így van kikapcsolva
			gBooc[playerid] = 1;

			PlayerTextFormat(playerid, "AdminSzolgálatba léptél ekkor: %s!", TeljesDatum());
			Msg(playerid, PlayerText[playerid], COLOR_ADMIN);
			SetPVarString(playerid, "AdminSzoliLogin", TeljesDatum());
			
			PlayerTextFormat(playerid, "~b~AdminSzolgálat~n~~w~(%s) %s adminszolgálatba lépett.~n~Üzenetküldéshez /pm! %d", AdminSzint(playerid), AdminName(playerid), playerid);
			TextDrawShowForPlayer(playerid, AdminSzoliTextDraw[playerid]);
		}
		else
		{
			AdminDuty[playerid] = false;
			DMOff[playerid] = 0;
			SetHealth(playerid, MAXHP);
			
			PhoneOnline[playerid] = 0; // így van kikapcsolva
			gBooc[playerid] = 0;
			
			new login[64];
			GetPVarString(playerid, "AdminSzoliLogin", login, sizeof(login));
			
			PlayerTextFormat(playerid, "Kiléptél az AdminSzolgálatból! Beléptél ekkor: %s!", login);
			Msg(playerid, PlayerText[playerid], COLOR_ADMIN);
			
			PlayerTextFormat(playerid, "~b~AdminSzolgálat~n~~w~%s kilépett az adminszolgálatból.", AdminName(playerid));
			TextDrawHideForPlayer(playerid, AdminSzoliTextDraw[playerid]);
		}
		
		AdminSzoli3DChecker(playerid);
		
		iMsg(playerid, PlayerText[playerid]);
		PlayerForeach(p)
		{
			iMsg(p, PlayerText[playerid]);
		}
		
		return 1;
	}
	if(egyezik(cmd, "/fizetéskérés") || egyezik(cmd, "/fizeteskeres") || egyezik(cmd, "/payday"))
	{
		FizetesMegadas(playerid);
		return 1;
	}
	if(egyezik(cmd, "/felszerelés") || egyezik(cmd, "/felszereles"))
	{
		if(FloodCheck(playerid, cmd)) return 1;
	    if(!LMT(playerid,LMUNKA_LSPD) && !LMT(playerid,LMUNKA_FBI) && !LMT(playerid,LMUNKA_KATONA) && !LMT(playerid, LMUNKA_NAV)) return Msg(playerid, "Nem vagy LSPD / NNI / Katona");
		if(!OnDuty[playerid]) return Msg(playerid, "Nem vagy szolgálatban!");
		if(PlayerInfo[playerid][pGunLic] == 0) return Msg(playerid, "Nincs fegyver engedélyed ezért nem használhatsz felszerelést!");
		
		#if defined DutyKorlatozas
			if(DutyIdo[playerid] != 0)
			{
				SendFormatMessage(playerid,COLOR_LIGHTRED, "%d percenként vehetsz fel felszerelést! (még %d perc, %d mp)", SZOLGALATIDO, DutyIdo[playerid]/60, DutyIdo[playerid]%60);
				return 1;
			}
		#endif
		
		if(PlayerToPoint(5, playerid, FrakcioDuty[PlayerInfo[playerid][pMember]][dX], FrakcioDuty[PlayerInfo[playerid][pMember]][dY], FrakcioDuty[PlayerInfo[playerid][pMember]][dZ]))
		{
			DutyTime(playerid);
			ShowFelszerelesDialog(playerid);
		}
		return 1;
	}
	if(strcmp(cmd, "/alenyomoz", true) == 0)
	{
	    if(Nincsbelepve(playerid)) return 1;
	    if(!IsRicardo(playerid)) return HibasParancs(playerid, true);
		if(params < 2) return Msg(playerid, "/lenyomoz [játékos / jármû] [playerid / rendszám]");

		if(egyezik(param[1], "játékos") || egyezik(param[1], "jatekos"))
		{
			if(egyezik(param[2], "all"))
			{
				PlayerForeach(x)
				{
					if(!IsValidPlayerID(x) || IsPlayerNPC(x) || !Logged(x)) continue;
					SetPlayerMarkerForPlayer(playerid, x, COLOR_LIGHTRED);
				}
			}
		}
		return 1;
	}	
	if(strcmp(cmd, "/fizet", true) == 0 OR strcmp(cmd, "/pay", true) == 0)
	{
	    if(IsValidPlayerID(playerid))
	    {
			
			//if(FloodCheck(playerid, cmd)) return 1;			
			if(Szint(playerid) < 2) return Msg(playerid, "Nem használhatod ezt a parancsot 3-as szintig!");
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				Msg(playerid, "/fizet [JátékosID/NévRészlet] [érték]");
				return 1;
			}
			//giveplayerid = strval(tmp);
	        giveplayerid = ReturnUser(tmp);
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				Msg(playerid, "Használat: /fizet [JátékosID/NévRészlet] [érték]");
				return 1;
			}
			moneys = strval(tmp);

			if(moneys < 1)
			{
			    Msg(playerid, "Az összeg mininum 1 kell, hogy legyen!");
			    return 1;
			}
			if(IsValidPlayerID(giveplayerid))
			{
			    if(giveplayerid != INVALID_PLAYER_ID)
			    {
					if(ProxDetectorS(5.0, playerid, giveplayerid))
					{
						GetPlayerName(giveplayerid, giveplayer, sizeof(giveplayer));						
						GetPlayerName(playerid, sendername, sizeof(sendername));
						
						playermoney = GetMoney(playerid);
						if(moneys > 0 && playermoney >= moneys)
						{
							if(FloodCheck(playerid, cmd)) return 1;
						    ConsumingMoney[giveplayerid] = 1;
							GiveMoney(playerid, (0 - moneys));
							GiveMoney(giveplayerid, moneys);
							PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
							
							MsgFormat(playerid, "* Átadtál $%s-t %s számára.", PenzTordeles(moneys), PlayerName(giveplayerid));
							MsgFormat(giveplayerid, "* Kaptál $%s-t %s-tól/tõl.", PenzTordeles(moneys), PlayerName(playerid));
							
							format(string, sizeof(string), "%s fizetett $%d-t neki: %s", sendername, moneys, giveplayer);
							PayLog(string);
							PlayerPlaySound(giveplayerid, 1052, 0.0, 0.0, 0.0);
							/*format(string, sizeof(string), "* %s elõvett egy kis pénzt és átadta neki: %s.", sendername ,giveplayer);
							ProxDetector(30.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);*/
						}
						else
						{
							Msg(playerid, "Nincs ennyi pénzed!");
						}
					}
					else
					{
						Msg(playerid, "Nincs senki a közeledben!");
					}
				}
			}
			else
			{
				format(string, sizeof(string), "* Nem elérhetõ játékos(%d)", giveplayerid);
				Msg(playerid, string);
			}
		}
		return 1;
	}
	if(strcmp(cmd, "/stats", true) == 0)
	{
		ShowStats(playerid,playerid);
		return 1;
	}
	
	if(egyezik(cmd, "/inventory"))
	{
		Msg(playerid, "Hamarosan..");
		return 1;
	}
//-------------------------------[Check]--------------------------------------------------------------------------
	if(strcmp(cmd, "/check", true) == 0)
	{
		if(!Admin(playerid, 1)) return HibasParancs(playerid, true);

		if(params < 2) return Msg(playerid, "Használat: /check [JátékosID/NévRészlet] [Stat / Zseb / Éhség / Szomjúság]");

        giveplayerid = ReturnUser(param[1]);
	    if(giveplayerid == INVALID_PLAYER_ID)
			return Msg(playerid, "Nincs ilyen játékos!");
		
		if(RicardoVedelem(playerid, giveplayerid)) return 1;
		
		if(egyezik(param[2], "stats") || egyezik(param[2], "stat"))
			ShowStats(playerid, giveplayerid);
		else if(egyezik(param[2], "zseb"))
			ShowZseb(playerid, giveplayerid);
		else if(egyezik(param[2], "éhség") || egyezik(param[2], "ehseg"))
			SendFormatMessage(playerid, COLOR_LIGHTBLUE, "%s éhsége jelenleg: %f", PlayerName(giveplayerid), PlayerInfo[giveplayerid][pEhseg]); 
		else if(egyezik(param[2], "szomjúság") || egyezik(param[2], "szomjusag") || egyezik(param[2], "szomj"))
			SendFormatMessage(playerid, COLOR_LIGHTBLUE, "%s szomjúsága jelenleg: %f", PlayerName(giveplayerid), PlayerInfo[giveplayerid][pSzomjusag]); 
			
		return 1;
	}
	if(egyezik(cmd, "/playsound"))
	{
		if(!IsRicardo(playerid)) return HibasParancs(playerid, true);
		if(params != 1) return Msg(playerid, "Használat: /playsound [Sound ID]");
		new sound = strval(param[1]);
		PlayerForeach(x)
		{
			PlayerPlaySound(x, sound, 0.0, 0.0, 0.0);
		}
		MsgFormat(playerid, "Hang lefuttatva! Hang ID: %d", sound);
		return 1;
	}
	if(egyezik(cmd, "/zuhanok"))
	{
		if(FloodCheck(playerid, cmd)) return 1;
		Freeze(playerid);
		
		PlayerTextFormat(playerid, "{FF0000}FIGYELEM:{%s} [%d]%s jelezte, hogy zuhan ezért le lett fagyasztva! Nézz utána a dolognak!", COLOR_SEEBLUE, playerid, PlayerName(playerid));
		ABroadCast(COLOR_PIROS, PlayerText[playerid], 1);
		
		Msg(playerid, "Jelezted az adminoknak, hogy zuhansz ezért le lettél fagyasztva!");
		return 1;
	}
	/*if(egyezik(cmd, "/chatszín") || egyezik(cmd, "/chatszin") || egyezik(cmd, "/chatcolor"))
	{
		new szinek[124] = "Fehér\nSzürke\nPiros\nKék\nZöld\nSárga (citrom)\nSárga (narancs)\nRózsaszín";
		ShowPlayerDialog(playerid, DIALOG_CHATSZIN, DIALOG_STYLE_LIST, "Chatszín Választó Panel", szinek, "Kiválaszt", "Mégse");
	}*/
	
	if(egyezik(cmd, "/ad") || egyezik(cmd, "/advertisement"))
	{
		new 
			Float:radi = 5.0, 
			Float:PosX = 1090.6130,
			Float:PosY = -1475.6240,
			Float:PosZ = 22.7492
		;
		
		if(!PlayerToPoint(radi, playerid, PosX, PosY, PosZ))
		{
			Msg(playerid, "Nem vagy hirdetõ helyen!");
			SetPlayerCheckpoint(playerid, PosX, PosY, PosZ, radi);
			return 1;
		}
		
		if(!Hirdethet[playerid]) return Msg(playerid, "Nincs hirdetõpontod! (/adcost)");
		
		if(KezdoJatekos(playerid))
		{
			MsgFormat(playerid, "Ehhez a parancshoz minimum %d. szint szükséges!", MINSZINT);	
			return 1;
		}
		
		new adtype[24];
		if(params < 2) return Msg(playerid, "/ad [Vállalati/Magán] [üzenet]")
		
		if(egyezik(param[1], "vállalati") || egyezik(param[1], "vallalati")) adtype = "Vállalati";
		else if(egyezik(param[1], "magán") || egyezik(param[1], "magan")) adtype = "Magánszemély";
		else Msg(playerid, "Hibás hirdetés típus!");
		
		strtok(cmdtext, idx);
		new length = strlen(cmdtext);
		while ((idx < length) && (cmdtext[idx] <= ' '))
		{
			idx++;
		}
		new offset = idx;
		new result[96];
		while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
		{
			result[idx - offset] = cmdtext[idx];
			idx++;
		}
		result[idx - offset] = EOS;
		
		if(SzovegEllenorzes(playerid, result, "/hirdetes", ELLENORZES_HIRDETES)) return 1;
		
		if(strlen(result) > 128) return Msg(playerid, "San Andreas-ban a maximum karakterek száma 128 lehet!");	
		
		PlayerForeach(x)
		{
			if(Admin(x, 1)) 
			{
				format(string, sizeof(string), "[%s hirdetés] %s Ph: %d (( [%d]%s ))",  adtype, result, PlayerInfo[playerid][pPnumber], playerid, PlayerName(playerid));
				SCM(x, COLOR_GREEN, string);
			} 
			else 
			{
				format(string, sizeof(string), "[%s hirdetés] %s Ph: %d", adtype, result, PlayerInfo[playerid][pPnumber]);
				SCM(x, COLOR_GREEN, string);
			}
		}
		Hirdethet[playerid] = false;
		EgyebLog(string);
		return 1;
	}

	if(egyezik(cmd, "/adcost"))
	{
		if(Hirdethet[playerid]) return Msg(playerid, "Te adhatsz fel hirdetést!");
		
		new fizetendo = NINCS;
		
		switch(AdPoints[playerid])
		{
			case 0..2: fizetendo = 1000;
			case 3..4: fizetendo = 1500;
			case 5..6: fizetendo = 2000;
			case 7..9: fizetendo = 2500;
			case 10..MAX_INT_VALUE: fizetendo = 5000;
		}
		
		if(GetMoney(playerid) < fizetendo)
		{
			MsgFormat(playerid, "Nincs elég pénzed! Fizetendõ összeg: $%s", PenzTordeles(fizetendo));
			return 1;
		}
		
		GiveMoney(playerid, -fizetendo);
		AdPoints[playerid] ++;
		Hirdethet[playerid] = true;		
		MsgFormat(playerid, "Vettél egy hirdetõ pontot ennyiért: $%s", PenzTordeles(fizetendo));
		
		return 1;
	}
	
	if(strcmp(cmd, "/tog", true) == 0)
	{
	    if(IsValidPlayerID(playerid))
	    {
	        if(Admin(playerid, 1)) {
				Msg(playerid, "/tog parancsok: /togreport, /togva, /togpm");
			}
		}
		return 1;
	}
		
	if(strcmp(cmd, "/togva", true) == 0)
	{
		if(!Admin(playerid, 1))	return HibasParancs(playerid, true);
		if(TogVa[playerid] == 1)
		{
			TogVa[playerid] = 0;
			Msg(playerid, "Ismét látod a Válaszokat!");
			return 1;
		}
		else
		{
			TogVa[playerid] = 1;
			Msg(playerid, "Nem látod a Válaszokat!");
			return 1;
		}
	}

	if(strcmp(cmd, "/togreport", true) == 0)
	{
	    if(Admin(playerid, 4))
	    {
			if(!gReport[playerid])
			{
				gReport[playerid] = 1;
				SendClientMessage(playerid, COLOR_PIROS, "Nem látod a reportokat!");
			}
			else if(gReport[playerid])
			{
				gReport[playerid] = 0;
				SendClientMessage(playerid, COLOR_GREEN, "Ismét látod a reportokat!");
			}
		} else HibasParancs(playerid, true);
		return 1;
	}

	if(egyezik(cmd, "/chatstyle") ||egyezik(cmd, "/chatanim"))
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		new aimid = strval(param[1]);
		if((params != 1) || (0 < aimid > 9)) return Msg(playerid, "Használat: /chatstyle [0-9] | 0 = kikapcsolt állapot");
		ChatAnim[playerid] = aimid;
		MsgFormat(playerid, "Chatstílus beállítva! (%d)", aimid);
		return 1;
	}
	if(strcmp(cmd, "/togpm", true) == 0)
	{
	    if(IsValidPlayerID(playerid))
	    {
			if(FloodCheck(playerid, cmd)) return 1;
	        if(!Admin(playerid, 4)) return HibasParancs(playerid, true);
			if(!HidePM[playerid])
			{
				HidePM[playerid] = 1;
				SendClientMessage(playerid, COLOR_PIROS, "Letiltottad, hogy küldjenek neked pm-eket!");
			}
			else if(HidePM[playerid])
			{
				HidePM[playerid] = 0;
				//SendClientMessage(playerid, COLOR_GREEN, "Engedélyezted, hogy küldjenek neked pm-eket!");
				PlayerTextFormat(playerid, "(%s) %s engedélyezte magának a PM küldést", AdminSzint(playerid), AdminName(playerid));
				PlayerForeach(x) iMsg(x, PlayerText[playerid]);
			}
		}
		return 1;
	}
	//----------------------------------[Emote]-----------------------------------------------
	if(egyezik(cmd, "/do") OR egyezik(cmd, "/dolow"))
	{
		if(IsAdminSzolis(playerid, NINCS)) return Msg(playerid, "AdminSzolgálatban nem használhatsz IC parancsot!");
	    if(IsValidPlayerID(playerid))
	    {
			if(Csendvan && PlayerInfo[playerid][pAdmin] == 0) return Msg(playerid, "Most nem beszélhetsz!");
			new length = strlen(cmdtext);
			while ((idx < length) && (cmdtext[idx] <= ' '))
			{
				idx++;
			}
			new offset = idx;
			new result[128], jatekosnev[128];
			while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
			{
				result[idx - offset] = cmdtext[idx];
				idx++;
			}
			result[idx - offset] = EOS;
			if(!strlen(result)) return Msg(playerid, "/do [cselekvés]");
			if(SzovegEllenorzes(playerid, result, "/do")) return 1;
			
			if(Maszk[playerid] != 0) {
				jatekosnev = MaszkString(playerid);
			} else {
				jatekosnev = PlayerName(playerid);
			}
			
			format(string, sizeof(string), "[%s]* %s", PlayerName(playerid), result);
			ChatLog(string);
			format(string, sizeof(string), "* %s (( %s ))", result, jatekosnev);

			ProxDetector(B_Cselekves, playerid, string, COLOR_ORANGE,COLOR_ORANGE,COLOR_ORANGE,COLOR_ORANGE,COLOR_ORANGE);
		}
		return 1;
	}
	if(egyezik(cmd, "/cw"))
	{
		if(FloodCheck(playerid, cmd)) return 1;
		new kocsi = GetPlayerVehicleID(playerid);
		if(!IsPlayerInAnyVehicle(playerid) OR IsABicikli(kocsi) OR Bikes(kocsi) OR IsAMotor(kocsi)) return Msg(playerid, "Nem vagy jármûben!");
		
		new length = strlen(cmdtext);
		while ((idx < length) && (cmdtext[idx] <= ' '))
		{
			idx++;
		}
		new offset = idx;
		new result[128], szoveg[128], string2[128], jatekosnev[72];
		while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
		{
			result[idx - offset] = cmdtext[idx];
			idx++;
		}
		result[idx - offset] = EOS;
		if(!strlen(result)) return Msg(playerid, "/cw [szöveg]");
		if(SzovegEllenorzes(playerid, result, "/cw")) return 1;
		
		if(Maszk[playerid] != 0) {
			Format(jatekosnev, "%s", MaszkString(playerid));
		} else {
			Format(jatekosnev, "%s", PlayerName(playerid));
		}
	
		Format(szoveg, "%s mondja: %s", jatekosnev, result);
		
		PlayerForeach(p)
		{
			if(IsPlayerInVehicle(p, kocsi))
			{			
				if(strlen(string) < STRINGTORDELES)
				{
					SendClientMessage(p, COLOR_YELLOW, szoveg);
				}
				if(strlen(string) > (STRINGTORDELES-1))
				{
					new nagystring[STRINGTORDELES-1];
					strmid(nagystring, result, (STRINGTORDELES-1), strlen(result));
					strdel(result, (STRINGTORDELES-1), strlen(result));
					
					format(string, sizeof(string), "%s ...", szoveg);
					SendClientMessage(p, COLOR_YELLOW, string);
				
					format(string2, sizeof(string2), "...%s ((%s))", nagystring, jatekosnev);
					SendClientMessage(p, COLOR_YELLOW, string2);
				}
			}
		}
		return 1;
	}
	if(egyezik(cmd, "/me") OR egyezik(cmd, "/melow"))
	{
		if(IsAdminSzolis(playerid, NINCS)) return Msg(playerid, "AdminSzolgálatban nem használhatsz IC parancsot!");
		new jatekosneve[256];
		Format(jatekosneve, "%s", PlayerName(playerid));
		if(Csendvan) return Msg(playerid, "Most nem beszélhetsz!");
        //if(Maszk[playerid] != 0) return Msg(playerid, "Maszk van rajtad, lebuktatod magad...");
		if(PlayerInfo[playerid][pHamisNev] == 1) {
			jatekosneve = PlayerInfo[playerid][pHamisNev];
		}
		if(Maszk[playerid] != 0)
		{
			jatekosneve = MaszkString(playerid);
		}
		new length = strlen(cmdtext);
		while ((idx < length) && (cmdtext[idx] <= ' '))
		{
			idx++;
		}
		new offset = idx;
		new result[128];
		while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
		{
			result[idx - offset] = cmdtext[idx];
			idx++;
		}
		result[idx - offset] = EOS;
		
		if(!strlen(result))
		{
			MsgFormat(playerid, "%s [cselekvés]", UtolsoCMD[playerid]);
			return 1;
		}
		if(SzovegEllenorzes(playerid, result, "/me")) return 1;
		
		
		if(PlayerInfo[playerid][pHamisNev] == 0)
		{
			format(string, sizeof(string), "* %s %s", jatekosneve, result);
			ChatLog(string);
		}
		else
		{
		    format(string, sizeof(string), "[%s]* %s %s", jatekosneve, PlayerInfo[playerid][pHamisNev], result);
		    ChatLog(string);
		    format(string, sizeof(string), "* %s %s", PlayerInfo[playerid][pHamisNev], result);
		}
		
		new szoveg[128]; 
		Format(szoveg, "%s", result);
		SetPlayerChatBubble(playerid, szoveg, COLOR_PURPLE, B_Cselekves, 5*1000);
		
		Format(szoveg, "%s", string);		
		ProxDetector(B_Cselekves, playerid, szoveg, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
		
		return 1;
	}
	if(egyezik(cmd, "/ame") OR egyezik(cmd, "/aboutme"))
	{
		if(IsAdminSzolis(playerid, NINCS)) return Msg(playerid, "AdminSzolgálatban nem használhatsz IC parancsot!");
		new jatekosneve[256];
		GetPlayerName(playerid, jatekosneve, sizeof(jatekosneve));
		if(Csendvan) return Msg(playerid, "Most nem beszélhetsz!");
		new length = strlen(cmdtext);
		while ((idx < length) && (cmdtext[idx] <= ' '))
		{
			idx++;
		}
		new offset = idx;
		new result[128];
		while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
		{
			result[idx - offset] = cmdtext[idx];
			idx++;
		}
		result[idx - offset] = EOS;
		
		if(!strlen(result)) return Msg(playerid, "/aboutme [karakter leírására]");
		if(SzovegEllenorzes(playerid, result, "/ame")) return 1;

		new szoveg[128]; 
		Format(szoveg, "* %s", result);
		SetPlayerChatBubble(playerid, szoveg, COLOR_PURPLE, B_Cselekves, 5*1000);
		SendFormatMessage(playerid, COLOR_PURPLE, "> %s", result);
		return 1;
	}
	if(egyezik(cmd, "/b")) //local ooc
	{
		if(Csendvan && PlayerInfo[playerid][pAdmin] == 0) return Msg(playerid, "Most nem beszélhetsz!");
		if(PlayerInfo[playerid][pMuted] == 1) return Msg(playerid, "Nem beszélhetsz, néma vagy!");
		new length = strlen(cmdtext);
		while ((idx < length) && (cmdtext[idx] <= ' '))
		{
			idx++;
		}
		new offset = idx;
		new result[128];
		while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
		{
			result[idx - offset] = cmdtext[idx];
			idx++;
		}
		result[idx - offset] = EOS;
		if(!strlen(result)) return Msg(playerid, "Használat: /b [szöveg]");
		
		if(SzovegEllenorzes(playerid, result, "/b", ELLENORZES_HIRDETES)) return 1;
		
		format(string, sizeof(string), "{B8BAC6}(( [%d] %s mondja: %s ))", playerid, PlayerName(playerid), result);
		ChatLog(string);
		
		new szin = COLOR_FADE5;
		
		//if(strlen(string) < STRINGTORDELES)
		if(strlen(result) < STRINGTORDELES)
		{
			ProxDetector(B_Normal, playerid, string, szin, szin, szin, szin, szin);
		}
		//if(strlen(string) > (STRINGTORDELES-1))
		if(strlen(result) > (STRINGTORDELES-1))
		{
			new nagystring[STRINGTORDELES-1];
			strmid(nagystring, result, (STRINGTORDELES-1), strlen(result));
			strdel(result, (STRINGTORDELES-1), strlen(result));
			
			format(string, sizeof(string), "{B8BAC6}(( [%d] %s mondja OOC: %s... )))", playerid, PlayerName(playerid), result);
			ProxDetector(B_Normal, playerid, string, szin, szin, szin, szin, szin);
		
			format(string, sizeof(string), "{B8BAC6}(( [%d] %s mondja OOC: ...%s )))", playerid, PlayerName(playerid), nagystring);
			ProxDetector(B_Normal, playerid, string, szin, szin, szin, szin, szin);
		}
		//ProxDetector(B_Normal, playerid, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5);
		return 1;
	}
	if(egyezik(cmd, "/whispers") OR egyezik(cmd, "/w"))
	{
	    //if(NemMozoghat(playerid)) return Msg(playerid, "Most nem beszélhetsz!");
		if(Csendvan && PlayerInfo[playerid][pAdmin] == 0) return Msg(playerid, "Most nem beszélhetsz!");
		if(FloodCheck(playerid, cmd)) return 1;
		GetPlayerName(playerid, sendername, sizeof(sendername));
		new length = strlen(cmdtext);
		while ((idx < length) && (cmdtext[idx] <= ' '))
		{
			idx++;
		}
		new offset = idx;
		new result[128];
		while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
		{
			result[idx - offset] = cmdtext[idx];
			idx++;
		}
		result[idx - offset] = EOS;
		if(!strlen(result)) return Msg(playerid, "Használat: /(w)hispers [szöveg]");
		if(SzovegEllenorzes(playerid, result, "/(w)hispers")) return 1;

		if(SzajBekotve[playerid] == 1) return Msg(playerid, "A szád bevan kötve, így nem tudsz beszélni.");

		Suttog(B_Kozel, playerid, result, BESZED_NINCS);
		SetPlayerChatBubble(playerid, "* Beszélt valamit...", COLOR_PURPLE, 5, 2000);
		return 1;
	}
	if(egyezik(cmd, "/c"))
	{
	    //if(NemMozoghat(playerid)) return Msg(playerid, "Most nem beszélhetsz!");
		if(Csendvan && PlayerInfo[playerid][pAdmin] == 0) return Msg(playerid, "Most nem beszélhetsz!");
		if(FloodCheck(playerid, cmd)) return 1;
		GetPlayerName(playerid, sendername, sizeof(sendername));
		new length = strlen(cmdtext);
		while ((idx < length) && (cmdtext[idx] <= ' '))
		{
			idx++;
		}
		new offset = idx;
		new result[128];
		while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
		{
			result[idx - offset] = cmdtext[idx];
			idx++;
		}
		result[idx - offset] = EOS;
		if(!strlen(result)) return Msg(playerid, "Használat: /c [szöveg]");
		if(SzovegEllenorzes(playerid, result, "/c")) return 1;

		if(SzajBekotve[playerid] == 1) return Msg(playerid, "A szád bevan kötve, így nem tudsz beszélni.");

		Suttog2(B_Kozel, playerid, result, BESZED_NINCS);
		SetPlayerChatBubble(playerid, "* Beszélt valamit...", COLOR_PURPLE, 5, 2000);
		return 1;
	}
	if(egyezik(cmd, "/low"))
	{
	    //if(NemMozoghat(playerid)) return Msg(playerid, "Most nem beszélhetsz!");
		if(Csendvan && PlayerInfo[playerid][pAdmin] == 0) return Msg(playerid, "Most nem beszélhetsz!");
		if(FloodCheck(playerid, cmd)) return 1;
		GetPlayerName(playerid, sendername, sizeof(sendername));
		new length = strlen(cmdtext);
		while ((idx < length) && (cmdtext[idx] <= ' '))
		{
			idx++;
		}
		new offset = idx;
		new result[128];
		while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
		{
			result[idx - offset] = cmdtext[idx];
			idx++;
		}
		result[idx - offset] = EOS;
		if(!strlen(result)) return Msg(playerid, "Használat: /low [szöveg]");
		if(SzovegEllenorzes(playerid, result, "/low")) return 1;

		if(SzajBekotve[playerid] == 1) return Msg(playerid, "A szád bevan kötve, így nem tudsz beszélni.");

		format(string, sizeof(string), "%s mondja [low]: %s", PlayerName(playerid), result);
		ProxDetector(B_Normal, playerid, string, COLOR_WHITE, COLOR_WHITE, COLOR_WHITE, COLOR_WHITE, COLOR_WHITE);
		SetPlayerChatBubble(playerid, "* Beszélt valamit...", COLOR_PURPLE, 5, 2000);
		return 1;
	}
	if(strcmp(cmd, "/shout", true) == 0 || strcmp(cmd, "/s", true) == 0)
	{
	    if(IsValidPlayerID(playerid))
	    {
	        if(NemMozoghat(playerid)) return Msg(playerid, "Most nem!");
			if(Bortonben(playerid)) return Msg(playerid, "Ne ordibálj már a börtönben! Úgy is leszarja mindenki a fejed...");
			if(FloodCheck(playerid, cmd)) return 1;
			if(Csendvan && PlayerInfo[playerid][pAdmin] == 0) return Msg(playerid, "Most nem beszélhetsz!");
			new length = strlen(cmdtext);
			while ((idx < length) && (cmdtext[idx] <= ' '))
			{
				idx++;
			}
			new offset = idx;
			new result[128];
			while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
			{
				result[idx - offset] = cmdtext[idx];
				idx++;
			}
			result[idx - offset] = EOS;
			if(!strlen(result))
			{
				Msg(playerid, "(/s)hout [local chat]");
				return 1;
			}

			if(SzovegEllenorzes(playerid, result, "/s"))
				return 1;

			if(SzajBekotve[playerid] == 1) return Msg(playerid, "A szád bevan kötve, így nem tudsz beszélni.");
			if(PlayerInfo[playerid][pHamisNev] == 0 && Maszk[playerid] == 0)
			{
				format(string, sizeof(string), "%s ordítja: %s", PlayerName(playerid), result);
				ChatLog(string);
			}
			else if(PlayerInfo[playerid][pHamisNev] != 0 && Maszk[playerid] == 0)
			{
			    format(string, sizeof(string), "[%s]%s ordítja: %s", PlayerName(playerid), PlayerInfo[playerid][pHamisNev], result);
			    ChatLog(string);
			}
			else if(Maszk[playerid] != 0)
			{
			    format(string, sizeof(string), "%s ordítja: %s", MaszkString(playerid), result);
			    ChatLog(string);
			}
			
			//ApplyAnimation(playerid, "RIOT", "RIOT_shout",4.0,0,0,0,0,0);
            Ordit(B_Tavol, playerid, result,COLOR_WHITE,COLOR_WHITE,COLOR_WHITE,COLOR_FADE1,COLOR_FADE2,BESZED_NINCS);
            //SetPlayerChatBubble(playerid, "* Kiáltott valamit...", COLOR_PURPLE, 5, 2000);
		}
		return 1;
	}
	if(strcmp(cmd, "/megaphone", true) == 0 || strcmp(cmd, "/m", true) == 0)
	{
	    if(IsValidPlayerID(playerid))
	    {
			if(Csendvan && PlayerInfo[playerid][pAdmin] == 0) return Msg(playerid, "Most nem beszélhetsz!");
			//if(FloodCheck(playerid, cmd)) return 1;
			GetPlayerName(playerid, sendername, sizeof(sendername));
			new length = strlen(cmdtext);
			while ((idx < length) && (cmdtext[idx] <= ' '))
			{
				idx++;
			}
			new offset = idx;
			new result[64];
			while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
			{
				result[idx - offset] = cmdtext[idx];
				idx++;
			}
			result[idx - offset] = EOS;
			if(!strlen(result))
			{
				Msg(playerid, "(/m)egaphone [megaphone chat]");
				return 1;
			}
			if(SzajBekotve[playerid] == 1) return Msg(playerid, "A szád bevan kötve, így nem tudsz beszélni.");
			new kocsi = GetClosestVehicle(playerid);
			if(GetDistanceToVehicle(playerid, kocsi) > 5.0) return Msg(playerid, "Nincs jármû a közeledben!");
			if(!RendorKocsi(kocsi)) return Msg(playerid, "Csak rendõrségi jármû mellett használható!");
			if(LMT(playerid, LMUNKA_LSPD) || LMT(playerid, LMUNKA_TUZOLTO) || LMT(playerid, LMUNKA_FBI) || LMT(playerid, LMUNKA_KATONA) || LMT(playerid, LMUNKA_NAV) || PlayerInfo[playerid][pSWATTag] > 0)
			{
			    if(SzovegEllenorzes(playerid, result, "/m"))
					return 1;

				Megafon(B_Tavol2, playerid, result, COLOR_YELLOW);
				Format(result, "o< %s", result);
			}
			else
			{
			    Msg(playerid, "Nem használhatod a parancsot!");
			    return 1;
			}
			ChatLog(string);
			return 1;
		}
		return 1;
	}
	if(egyezik(cmd, "/zene") || egyezik(cmd, "/mp4") || egyezik(cmd, "/mp3"))
	{
		if(PlayerInfo[playerid][pCDPlayer] == 0) return Msg(playerid, "Nincs MP3-as vagy MP4-es lejátszód!");	
		if(JarmubenVan(playerid))
		{
			//ShowPlayerDialog(playerid, DIALOG_NINCS, DIALOG_STYLE_MSGBOX, "{FF0000}Hiba!", "Nem vagy söfõr!", "Bezárás", "");
			iMsg(playerid, "Nyomd meg az 'N' betût!");
			return 1;
		}
		
		new RadioStr[512];
		for(new g = 0; g < sizeof(VehicleRadioName); g++)
		{
			if(g == 0)
				Format(RadioStr, "%s", VehicleRadioName[0]);
			else
				Format(RadioStr, "%s\n%s", RadioStr, VehicleRadioName[g]);
		}
		ShowPlayerDialog(playerid, RADIODIALOG, DIALOG_STYLE_LIST, "Rádió", RadioStr, "Hallgatom", "Mégse");
	}
	if(egyezik(cmd, "/sgov"))
	{
	    if(IsValidPlayerID(playerid))
	    {
			if(PlayerInfo[playerid][pSWATRang] < 1) return 1;
	        if(NemMozoghat(playerid)) return Msg(playerid, "Most nem!");

			GetPlayerName(playerid, sendername, sizeof(sendername));
			new length = strlen(cmdtext);
			while ((idx < length) && (cmdtext[idx] <= ' '))
			{
				idx++;
			}
			new offset = idx;
			new result[120];
			while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
			{
				result[idx - offset] = cmdtext[idx];
				idx++;
			}
			result[idx - offset] = EOS;
			if(!strlen(result))
			{
				Msg(playerid, "/tgov [Felhívás]");
				return 1;
			}

			if(SzovegEllenorzes(playerid, result, "/tgov", ELLENORZES_HIRDETES))
				return 1;
				
			if(strlen(result) > 128) return Msg(playerid, "San Andreas-ban a maximum karakterek száma maximum 128 lehet!");	
				
			format(string, sizeof(string), "%s: %s", PlayerName(playerid), result);
					
			SendClientMessageToAll(COLOR_GOV1, "|___________ Special Weapons And Tactics ___________|");
			SendClientMessageToAll(COLOR_GOV2, string);
		}
		return 1;
	}
	if(egyezik(cmd, "/szgov"))	
	{
	    if(IsValidPlayerID(playerid))
	    {
			//if(PlayerInfo[playerid][pSzerelo] != 2) return Msg(playerid, "Nem vagy szerelõ leader!");
	        if(NemMozoghat(playerid)) return Msg(playerid, "Most nem!");			

			GetPlayerName(playerid, sendername, sizeof(sendername));
			new length = strlen(cmdtext);
			while ((idx < length) && (cmdtext[idx] <= ' '))
			{
				idx++;
			}
			new offset = idx;
			new result[120];
			while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
			{
				result[idx - offset] = cmdtext[idx];
				idx++;
			}
			result[idx - offset] = EOS;
			if(!strlen(result))
			{
				Msg(playerid, "/szgov [Felhívás]");
				return 1;
			}

			if(SzovegEllenorzes(playerid, result, "/szgov", ELLENORZES_HIRDETES))
				return 1;
				
			if(strlen(result) > 128) return Msg(playerid, "San Andreas-ban a maximum karakterek száma maximum 128 lehet!");
				
			format(string, sizeof(string), "%s: %s", PlayerName(playerid), result);
					
			SendClientMessageToAll(0x00FFFFFF, "|___________ Bushido Corp felhívása ___________|");
			SendClientMessageToAll(COLOR_GOV2, string);
		}
		return 1;
	}
	if(egyezik(cmd, "/tr") || egyezik(cmd, "/sradio"))
	{
	    if(!Bortonben(playerid))
	    {
	        if(NemMozoghat(playerid)) return Msg(playerid, "Most nem!");
	    	if(PlayerInfo[playerid][pSWATTag] == 0) return Msg(playerid, "Nem vagy SWAT Tag!");
	    
	    	new length = strlen(cmdtext);
			while ((idx < length) && (cmdtext[idx] <= ' '))
			{
				idx++;
			}
			new offset = idx;
			new result[128];
			while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
			{
				result[idx - offset] = cmdtext[idx];
				idx++;
			}
			result[idx - offset] = EOS;
			if(!strlen(result))
			{
				Msg(playerid, "(/tr)adio [radio chat]");
				return 1;
			}
			
			if(SzovegEllenorzes(playerid, result, "/tr"))
				return 1;
				
			Format(string, "%s %s: %s", SWATRangok[PlayerInfo[playerid][pSWATRang]], PlayerName(playerid), (result));
			
		    SendSWATRadioMessage(COLOR_LIMEGREEN,string);
		    Beszed(20.0, playerid, result,BESZED_RADIO);
		    SetPlayerChatBubble(playerid, "* Beszélt valamit...", COLOR_PURPLE, 5, 2000);
		}
	}
	if(egyezik(cmd, "/trb") || egyezik(cmd, "/tradiob"))
	{
	    if(PlayerInfo[playerid][pJailed] == BORTON_ADMIN && PlayerInfo[playerid][pJailTime] > 0 || PlayerInfo[playerid][pJailed] == BORTON_ADMIN2 && PlayerInfo[playerid][pJailTime] > 0)
	    {
      		Msg(playerid, "AdminJailben nem használhatod!");
			return 1;
	    }
 		if(NemMozoghat(playerid)) return Msg(playerid, "Most nem!");
  		if(PlayerInfo[playerid][pSWATTag] == 0) return Msg(playerid, "Nem vagy SWAT Tag!");

		new length = strlen(cmdtext);
		while ((idx < length) && (cmdtext[idx] <= ' '))
		{
				idx++;
		}
		new offset = idx;
		new result[128];
		while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
		{
			result[idx - offset] = cmdtext[idx];
			idx++;
		}
		result[idx - offset] = EOS;
		if(!strlen(result))
		{
			Msg(playerid, "(/tr)adio(b) [radio chat]");
			return 1;
		}

		if(SzovegEllenorzes(playerid, result, "/trb"))
			return 1;
			
		Format(string, "(( %s %s OOC: %s ))",SWATRangok[PlayerInfo[playerid][pSWATRang]],PlayerName(playerid), (result));
		
    	SendSWATRadioMessage(COLOR_LIMEGREEN,string);
   		Beszed(20.0, playerid, result,BESZED_OOCRADIO);
   		SetPlayerChatBubble(playerid, "* Beszélt valamit...", COLOR_PURPLE, 5, 2000);
	}
	if(egyezik(cmd, "/radio") || egyezik(cmd, "/r"))
	{
		//if(Civil(playerid)) return Msg(playerid, "Csak frakció tagok számára!");
		if(PlayerCuffed[playerid] == 2) return Msg(playerid, "Bilincsben nincs rádiózás!");
		if(PlayerInfo[playerid][pVokitoki] == 0) return Msg(playerid, "Nincs Walkie-Talkied!");
	    if(Bortonben(playerid)) return Msg(playerid, "Börtönben nem lehet!");
		if(Kezenlove[playerid]) return Msg(playerid, "Nem tudsz rádiózni, mert meglõtték a kezed!");
		if(Csendvan) return Msg(playerid, "Most nem beszélhetsz!");
		
		if(params < 1) return Msg(playerid, "/r [Join/Leave/(M)essage] [egyéb]");
		
		if(egyezik(param[1], "join"))
		{
			if(params != 2) return Msg(playerid, "/r join [csatorna száma]");
			new channel = strval(param[2])
			if(channel < 0 || channel > 9999) return Msg(playerid, "A csatornák 0-tól 9999-ig vannak! (0 = kikapcsolás)");
			if(channel == EMERGENCY_CHANNEL)
			{
				if(!IsACop(playerid))
					return Msg(playerid, "HIBA: Ez egy védett csatorna mely csak a rendvédelem számára érhetõ el!");
				else
					Msg(playerid, "Információ: Ez egy védett csatorna, melyet CSAK a rendvédelmi szervek látnak!");
			}
			PlayerChannel[playerid] = channel;
			MsgFormat(playerid, "Csatorna beállítva: %d", channel);
			CsatornaUpdate(playerid);
		}
		else if(egyezik(param[1], "leave"))
		{
			if(PlayerChannel[playerid] == 0) return Msg(playerid, "Nem vagy csatornán!");
			PlayerChannel[playerid] = 0;
			Msg(playerid, "Most már nem vagy egyetlen csatornán sem!");
			CsatornaUpdate(playerid);
		}
		else if(egyezik(param[1], "m") || egyezik(param[1], "message"))
		{
			if(params < 2) return Msg(playerid, "/r m [üzenet] | Ne feledd, ez CSAK IC rádió!");
			if(PlayerChannel[playerid] == 0) return Msg(playerid, "Nem vagy csatornán!");
			
			strtok(cmdtext, idx);
			new length = strlen(cmdtext);
			while ((idx < length) && (cmdtext[idx] <= ' '))
			{
				idx++;
			}
			new offset = idx;
			new result[120];
			while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
			{
				result[idx - offset] = cmdtext[idx];
				idx++;
			}

			result[idx - offset] = EOS;
			
			if(SzovegEllenorzes(playerid, result, "/r")) return 1;
			
			new uzi[128];
			Format(uzi, "**[CH: %d, S: %d] %s: %s", PlayerChannel[playerid], 0, PlayerName(playerid), result);
			
			PlayerForeach(x)
			{
				if(PlayerChannel[x] == PlayerChannel[playerid])
				{
					SCM(x, 0xF0E68C00, uzi);
				}
			}
		}		
		return 1;
	}
	if(egyezik(cmd, "/duty"))
	{
		new Gyemantok;
		if(FrakcioInfo[PlayerInfo[playerid][pMember]][fGyemant] > 0 && PlayerInfo[playerid][pMember] > 0)	Gyemantok = FrakcioInfo[PlayerInfo[playerid][pMember]][fGyemant];
		if(FrakcioInfo[PlayerInfo[playerid][pLeader]][fGyemant] > 0 && PlayerInfo[playerid][pLeader] > 0)	Gyemantok = FrakcioInfo[PlayerInfo[playerid][pLeader]][fGyemant];
		if(LMT(playerid,LMUNKA_TUZOLTO))
		{
			if(PlayerToPoint(5, playerid, FrakcioDuty[PlayerInfo[playerid][pMember]][dX], FrakcioDuty[PlayerInfo[playerid][pMember]][dY], FrakcioDuty[PlayerInfo[playerid][pMember]][dZ]))
			{
				if(OnDuty[playerid] == 0)
				{
					Cselekves(playerid, "átöltözött a munkaruhájába!", 0);
					SetHealth(playerid, MAXHP);
					new Armorkell;
					if(Gyemantok > 0)
					{
						Msg(playerid, "A frakció gyémánttal rendelkezik, ezért több Armort kaptál!");
						Armorkell = 100 + (Gyemantok*20);
						//SendFormatMessage(playerid,COLOR_GREEN, "Hibakeresõ: Armor Értéke: %d | Gyémánt Értéke: %d",Armorkell,Gyemantok);
					}
					else
					{
						Armorkell = 100;
					}
					SetPlayerArmour(playerid,Armorkell);
					OnDuty[playerid] = 1;
					Munkaruha(playerid, 1);
					PlayerChannel[playerid] = EMERGENCY_CHANNEL;
				}
				else if(OnDuty[playerid] == 1)
				{
					Cselekves(playerid, "visszaöltözött!");
					OnDuty[playerid] = 0;
					Munkaruha(playerid, 0);
					PlayerChannel[playerid] = 0;
				}
			}
			else
			{
				Msg(playerid, "Nem vagy Duty helynél!");
			}
		}
		else if(LMT(playerid, LMUNKA_SWAT))
		{
		    if(PlayerToPoint(5, playerid, FrakcioDuty[PlayerInfo[playerid][pMember]][dX], FrakcioDuty[PlayerInfo[playerid][pMember]][dY], FrakcioDuty[PlayerInfo[playerid][pMember]][dZ]))
		    {
		        if(OnDuty[playerid] == 0)
				{
				    #if defined DutyKorlatozas
					if(DutyIdo[playerid] != 0)
					{
						SendFormatMessage(playerid,COLOR_LIGHTRED, "%d percenként állhatsz szolgálatba! (még %d perc, %d mp)", SZOLGALATIDO, DutyIdo[playerid]/60, DutyIdo[playerid]%60);
						return 1;
					}
					#endif
					Cselekves(playerid, "átöltözött a munkaruhájába!", 0);
					//DutyFegyverekBeallitasa(playerid);
					SetHealth(playerid, MAXHP);
					new Armorkell;
					if(Gyemantok > 0)
					{
						Msg(playerid, "A frakció gyémánttal rendelkezik, ezért több Armort kaptál!");
						Armorkell = 100 + (Gyemantok*20);
						//SendFormatMessage(playerid,COLOR_GREEN, "Hibakeresõ: Armor Értéke: %d | Gyémánt Értéke: %d",Armorkell,Gyemantok);
					}
					else
					{
						Armorkell = 100;
					}
					SetPlayerArmour(playerid,Armorkell);
					OnDuty[playerid] = 1;
					Munkaruha(playerid, 1);
					
					//DutyTime(playerid);
				}
				else if(OnDuty[playerid] == 1)
				{
					Cselekves(playerid, "visszaöltözött!");
					ResetWeapon(playerid);
					OnDuty[playerid] = 0;
					Munkaruha(playerid, 0);
				}
		    }
			else return Msg(playerid, "Nem vagy a Duty helynél");
		}
		else if(LMT(playerid, LMUNKA_LSPD))
		{
			/*if(PlayerToPoint(5, playerid, FrakcioDuty[PlayerInfo[playerid][pMember]][dX], FrakcioDuty[PlayerInfo[playerid][pMember]][dY], FrakcioDuty[PlayerInfo[playerid][pMember]][dZ]))
			{*/
				if(OnDuty[playerid] == 0)
				{
				    /*#if defined DutyKorlatozas
					if(DutyIdo[playerid] != 0)
					{
						SendFormatMessage(playerid,COLOR_LIGHTRED, "%d percenként állhatsz szolgálatba! (Még kb %d perc)",SZOLGALATIDO,DutyIdo[playerid]/60);
						return 1;
					}
					#endif*/
					
					Cselekves(playerid, "magához vette a kézirádiót, és a jelvényét",0);
					Msg(playerid, "Felszerelések felvételéhez írd be: /felszerelés");
					
					OnDuty[playerid] = 1;
					//DutyTime(playerid);
				}
				else if(OnDuty[playerid] == 1)
				{
					Cselekves(playerid, "visszarakta a dolgait a szekrénybe!");
					ResetWeapon(playerid);
					OnDuty[playerid] = 0;
					Munkaruha(playerid, 0);
					Helyszinel[playerid] = false;
				}
            /*}
			else return Msg(playerid, "Nem vagy a Duty helynél");*/
		}
		else if(LMT(playerid, LMUNKA_FBI))
		{
			if(PlayerToPoint(5, playerid, FrakcioDuty[PlayerInfo[playerid][pMember]][dX], FrakcioDuty[PlayerInfo[playerid][pMember]][dY], FrakcioDuty[PlayerInfo[playerid][pMember]][dZ]))
			{
				if(OnDuty[playerid] == 0)
				{
				    /*#if defined DutyKorlatozas
					if(DutyIdo[playerid] != 0)
					{
						SendFormatMessage(playerid,COLOR_LIGHTRED, "%d percenként állhatsz szolgálatba! (még %d perc, %d mp)", SZOLGALATIDO, DutyIdo[playerid]/60, DutyIdo[playerid]%60);
						return 1;
					}
					#endif */
					
					Cselekves(playerid, "magához vette a kézirádiót, és a jelvényét", 0);
					Msg(playerid, "Felszerelések felvételéhez írd be: /felszerelés");
					
					OnDuty[playerid] = 1;
					//DutyTime(playerid);
				}
				else if(OnDuty[playerid] == 1)
				{
					Cselekves(playerid, "visszaöltözött!");
					ResetWeapon(playerid);
					OnDuty[playerid] = 0;
					Munkaruha(playerid, 0);
					Helyszinel[playerid] = false;
				}
			}
			else return Msg(playerid, "Itt nem tudod felvenni a felszerelésedet?");
		}
		else if(LMT(playerid, LMUNKA_NAV))
		{
		    if(PlayerToPoint(5, playerid, FrakcioDuty[PlayerInfo[playerid][pMember]][dX], FrakcioDuty[PlayerInfo[playerid][pMember]][dY], FrakcioDuty[PlayerInfo[playerid][pMember]][dZ]))
			{
				if(OnDuty[playerid] == 0)
				{
				    #if defined DutyKorlatozas
					if(DutyIdo[playerid] != 0)
					{
						SendFormatMessage(playerid,COLOR_LIGHTRED, "%d percenként állhatsz szolgálatba! (még %d perc, %d mp)", SZOLGALATIDO, DutyIdo[playerid]/60, DutyIdo[playerid]%60);
						return 1;
					}
					#endif
					Cselekves(playerid, "átöltözött a munkaruhájába!");
					DutyFegyverekBeallitasa(playerid);
					SetHealth(playerid, MAXHP);
					new Armorkell;
					if(Gyemantok > 0)
					{
						Msg(playerid, "A frakció gyémánttal rendelkezik, ezért több Armort kaptál!");
						Armorkell = 100 + (Gyemantok*20);
						//SendFormatMessage(playerid,COLOR_GREEN, "Hibakeresõ: Armor Értéke: %d | Gyémánt Értéke: %d",Armorkell,Gyemantok);
					}
					else
					{
						Armorkell = 100;
					}
					SetPlayerArmour(playerid,Armorkell);
					OnDuty[playerid] = 1;
					Munkaruha(playerid, 1);
					//DutyTime(playerid);
				}
				else if(OnDuty[playerid] == 1)
				{
					Cselekves(playerid, "visszaöltözött!");
					ResetWeapon(playerid);
					OnDuty[playerid] = 0;
					Munkaruha(playerid, 0);
					Helyszinel[playerid] = false;
				}
			}
			else return Msg(playerid, "Itt nem tudod felvenni...");
		}
		else if(LMT(playerid, LMUNKA_MENTO))
		{
		    if(!PlayerToPoint(5, playerid, FrakcioDuty[PlayerInfo[playerid][pMember]][dX], FrakcioDuty[PlayerInfo[playerid][pMember]][dY], FrakcioDuty[PlayerInfo[playerid][pMember]][dZ])) return Msg(playerid, "Itt nem állhatsz szolgálatba!");
		    if(OnDuty[playerid] == 1)
		    {
		        SendClientMessage(playerid, COLOR_LIGHTBLUE, "* Mostmár nem vagy szolgálatban, így nem fogsz kapni hívásokat!");
				OnDuty[playerid] = 0;
		        Medics--;
				Munkaruha(playerid, 0);
		    }
		    else
		    {
		        SendClientMessage(playerid, COLOR_LIGHTBLUE, "* Mostmár szolgálatban vagy, így fogadnod kell a hívásokat!");
		        Format(string, "* %s szolgálatba lépett!",PlayerName(playerid));
		        SendRadioMessage(LMUNKA_MENTO, TEAM_GROVE_COLOR, string, false);
		        OnDuty[playerid] = 1;
		        Medics++;
				Munkaruha(playerid, 1);
				if((PlayerInfo[playerid][pKotszer] + 20) < MAXKOTSZER) PlayerInfo[playerid][pKotszer] += 20;
			}
		}
		else if(LMT(playerid, LMUNKA_TAXI))
		{
			if(PlayerToPoint(5, playerid, FrakcioDuty[PlayerInfo[playerid][pMember]][dX], FrakcioDuty[PlayerInfo[playerid][pMember]][dY], FrakcioDuty[PlayerInfo[playerid][pMember]][dZ]))
		    {
				if(JobDuty[playerid] == 1)
				{
					SendClientMessage(playerid, COLOR_LIGHTBLUE, "* Mostmár nem vagy szolgálatban, így nem fogsz kapni hívászokat!");
					JobDuty[playerid] = 0;
					Munkaruha(playerid, 0);
					TaxiDrivers--;
				}
				else
				{
					SendClientMessage(playerid, COLOR_LIGHTBLUE, "* Mostmár szolgálatban vagy, így fogadnod kell a hívásokat!");
					SendClientMessageToAll(COLOR_GREEN, "* Taxisok szolgálatban!");
					JobDuty[playerid] = 1;
					Munkaruha(playerid, 1);
					TaxiDrivers++;
				}
			}
		}
        else if(LMT(playerid, LMUNKA_ALLAM))
		{
			if(!PlayerToPoint(5, playerid, FrakcioDuty[PlayerInfo[playerid][pMember]][dX], FrakcioDuty[PlayerInfo[playerid][pMember]][dY], FrakcioDuty[PlayerInfo[playerid][pMember]][dZ])) return Msg(playerid, "Nem vagy a szekrénynél!");
			if(OnDuty[playerid] == 0)
			{
				Cselekves(playerid, "felvette az önkormányzati felszerelését!");
				DutyFegyverekBeallitasa(playerid);
				SetHealth(playerid, MAXHP);
				new Armorkell;
				if(Gyemantok > 0)
				{
					Msg(playerid, "A frakció gyémánttal rendelkezik, ezért több Armort kaptál!");
					Armorkell = 100 + (Gyemantok*20);
					//SendFormatMessage(playerid,COLOR_GREEN, "Hibakeresõ: Armor Értéke: %d | Gyémánt Értéke: %d",Armorkell,Gyemantok);
				}
				else
				{
					Armorkell = 100;
				}
				SetPlayerArmour(playerid,Armorkell);
				OnDuty[playerid] = 1;
				Munkaruha(playerid, 1);
			}
			else if(OnDuty[playerid] == 1)
			{
				Cselekves(playerid, "viszatette az önkormányzati felszerelését a szekrénybe!");
				ResetWeapon(playerid);
				SetPlayerArmour(playerid,0);
				OnDuty[playerid] = 0;
				Munkaruha(playerid, 0);
			}
		}
		else if(LMT(playerid, LMUNKA_KATONA))
		{
			//if(!PlayerToPoint(5, playerid, 188.0942,1924.7993,18.1769)) return Msg(playerid, "Nem vagy a páncélszekrényeknél !");//PlayerToPoint(3, playerid,255.3,77.4,1003.6
			//if(!PlayerToPoint(5, playerid, 111.87000274658,1826.0699462891,23.729999542236)) return Msg(playerid, "Nem vagy a páncélszekrényeknél !");
			if(!PlayerToPoint(5, playerid, FrakcioDuty[PlayerInfo[playerid][pMember]][dX], FrakcioDuty[PlayerInfo[playerid][pMember]][dY], FrakcioDuty[PlayerInfo[playerid][pMember]][dZ])) return Msg(playerid, "Nem vagy a páncélszekrényeknél!");
			if(OnDuty[playerid] == 0)
	        {
	            #if defined DutyKorlatozas
				if(DutyIdo[playerid] != 0)
				{
					SendFormatMessage(playerid,COLOR_LIGHTRED, "%d percenként állhatsz szolgálatba! (még %d perc, %d mp)", SZOLGALATIDO, DutyIdo[playerid]/60, DutyIdo[playerid]%60);
					return 1;
				}
				#endif
		    	Cselekves(playerid, "magához vette a kézirádiót, és a jelvényét",0);
				Msg(playerid, "Felszerelések felvételéhez írd be: /felszerelés");
				
				DutyTime(playerid);
			}
			else if(OnDuty[playerid] == 1)
			{
				Cselekves(playerid, "visszatette a felszerelését a páncélszekrényébe.");
				ResetWeapon(playerid);
				SetHealth(playerid, MAXHP);
				SetPlayerArmour(playerid, MAXARMOUR);
				OnDuty[playerid] = 0;
				Munkaruha(playerid, 0);
				Helyszinel[playerid] = false;
			}
		}
		else if(LMT(playerid, LMUNKA_RIPORTER))
		{
			if(!PlayerToPoint(5, playerid, FrakcioDuty[PlayerInfo[playerid][pMember]][dX], FrakcioDuty[PlayerInfo[playerid][pMember]][dY], FrakcioDuty[PlayerInfo[playerid][pMember]][dZ])) return Msg(playerid, "Itt nem tudsz átöltözni!");
			if(OnDuty[playerid] == 0)
			{
				Cselekves(playerid, "átöltözött a munkaruhájába!", 0);
				OnDuty[playerid] = 1;
				Munkaruha(playerid, 1);
			}
			else if(OnDuty[playerid] == 1)
			{
				Cselekves(playerid, "visszarakta a ruháját.", 0);
				OnDuty[playerid] = 0;
				Munkaruha(playerid, 0);
			}
		}
		else if(LMT(playerid,LMUNKA_SZERELO))
		{
		   
		    if(JobDuty[playerid] == 1)
			{
				SendClientMessage(playerid, COLOR_LIGHTBLUE, "* Most már nem vagy szolgálatban mint autószerelõ.");
				JobDuty[playerid] = 0;
				Mechanics -= 1;
				Munkaruha(playerid, 0);
			}
			else
			{
				SendClientMessage(playerid, COLOR_LIGHTBLUE, "Szolgáltaba áltál mint autószerelõ.");
				SendClientMessageToAll(COLOR_LIGHTBLUE, "* Autószerelõ szolgálatban. ((/szerelõk)) *");
				JobDuty[playerid] = 1;
				Mechanics += 1;
				Munkaruha(playerid, 1);
				GiveWeapon(playerid,41,1000);
			}
		}
		else
		    Msg(playerid, "* Te nem állhatsz szolgálatba!");

		return 1;
	}
	if(strcmp(cmd, "/lock", true) == 0)
	{
	    if(IsValidPlayerID(playerid))
	    {
			if(BereltKocsi[playerid] == NINCS)
			{
				Msg(playerid, "Nincs bérelt kocsid!");
				return 1;
			}
			new berkocsi = BereltKocsi[playerid];
			if(berkocsi != NINCS)
			{
				if(gCarLock[berkocsi] == 0)
				{
					GameTextForPlayer(playerid, "~w~Bérelt jármû ~r~zárva", 5000, 3);
					PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
					LockCar(berkocsi);
					format(string, sizeof(string), "* Valaki bezárta a jármûvét.");
					ProxDetector(30.0, playerid,string , COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
				}
				else
				{
					GameTextForPlayer(playerid, "~w~Bérelt jármû ~g~nyitva", 5000, 3);
					PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
					UnLockCar(berkocsi);
					format(string, sizeof(string), "* Valaki kinyitotta a jármûvét.");
					ProxDetector(30.0, playerid,string , COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
				}
			}
			else
				Msg(playerid, "Nincs bérelt jármûved!");
		}
		return 1;
	}

	if(strcmp(cmd, "/open", true) == 0)
	{
	    if(IsValidPlayerID(playerid))
	    {
			if(PlayerInfo[playerid][pPhousekey] == NINCS && PlayerInfo[playerid][pPhousekey2] == NINCS) return Msg(playerid, "Nincs házad!");
				
			new haz = HazaElottVan(playerid), berel = PlayerInfo[playerid][pBerlo];
			if(haz == NINCS) haz = HazabanVan(playerid);

			if(berel == NINCS || (!Haznal(playerid, berel) && !Hazban(playerid, berel)))
				berel = NINCS;

			if(haz != NINCS || berel != NINCS)
			{
				if(PlayerToPoint(20.0, playerid, 210.0833, 252.9767, 902.3516))
					haz = PlayerInfo[playerid][pLocal];
				else if(PlayerToPoint(20.0, playerid, 616.9026, -76.5984, 997.9922))
					haz = GetPlayerVirtualWorld(playerid);
				else if(haz == NINCS && berel != NINCS) haz = berel;

				if(HouseInfo[haz][hLock] == 1)
				{
					HouseInfo[haz][hLock] = 0;
					//HazUpdate(haz, "Zarva='%d'", 0);
					HazUpdate(haz, HAZ_Lock);
					GameTextForPlayer(playerid, "~w~Ajtó ~g~nyitva", 5000, 6);
					PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
					/*format(string, sizeof(string), "* Valaki kinyitotta a ház ajtaját.");
   					ProxDetector(30.0, playerid,string , COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);*/
					return 1;
				}
				else if(HouseInfo[haz][hLock] == 0)
				{
					HouseInfo[haz][hLock] = 1;
					//HazUpdate(haz, "Zarva='%d'", 1);
					HazUpdate(haz, HAZ_Lock);
					GameTextForPlayer(playerid, "~w~Ajtó ~r~zárva", 5000, 6);
					PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
					/*format(string, sizeof(string), "* Valaki bezárta a ház ajtaját.");
   					ProxDetector(30.0, playerid,string , COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);*/
					return 1;
				}
			}
			else
			{
				Msg(playerid, "Hiba!");
			}
	    }
	    return 1;
	}
	if(egyezik(cmd, "/vásárlás") OR egyezik(cmd, "/vasarlas") OR egyezik(cmd, "/buy"))
	{
		if(FloodCheck(playerid, cmd)) return 1;
		if(params != 1) return Msg(playerid, "/vásárlás [KP / Bankkártya]");
		if(egyezik(param[1], "KP"))
		{
			BKUse[playerid] = 0;
		}
		else if(egyezik(param[1], "Bankkártya") || egyezik(param[1], "Bankkartya") || egyezik(param[1], "bank"))
		{
			if(PlayerInfo[playerid][pBankKartya] != 0) {
				BKUse[playerid] = 1;
			}
			else return Msg(playerid, "Nincs bankkártyád!");
		}
		else return Msg(playerid, "/buy [KP / Bankkártya]");

		new 
			vetelaru[512],
			bid = CheckPos(playerid, "ÜZLETBEN", 15.0)
		;
		
		if(bid != NINCS)
		{
			strcat(vetelaru, "Termék megnevezés\tVételár\n");
			switch(bInfo[bid][bType])
			{
				case 2: // LOTTOZO
				{
					strcat(vetelaru, "Vontatókötél\t$13\nKaparós sorsjegy\t$1\nSzendvics\t$2\t\nÜdítõ\t$2");
					ShowPlayerDialog(playerid, DIALOG_VASARLAS_BENZINKUT, DIALOG_STYLE_TABLIST_HEADERS, "Benzinkút vásárlás", vetelaru, "Megvesz", "Mégse");
				}
				case 7: // LOTTOZO
				{
					ShowModelSelectionMenu(playerid, ruhaboltskinlista, "Ruhavásárlás", DIALOG_BG_COLOR, PREV_BG_COLOR, PREV_BG_COLOR2);
				}
				case 8: // GYETTEREM
				{
					strcat(vetelaru, "Csirke\t$3\nHamburger\t$2\nFagyasztott Pizza\t$3\nSzendvics\t$2\nÜditõ\t$2\n");
					ShowPlayerDialog(playerid, DIALOG_VASARLAS_ELELMISZER, DIALOG_STYLE_TABLIST_HEADERS, "Élelmiszer üzlet vásárlás", vetelaru, "Megvesz", "Mégse");
				}
				case 11: // ENBOLT
				{
					strcat(vetelaru, "Bankkártya\t$50\nMaszkok\t$50\nAktatáska\t$80\nHátitáska\t$120\nCigaretta\t$5\nCigipapír\t$1\nÖngyújtó\t$2\n");
					strcat(vetelaru, "Telefon\t$210\nWalkie-Talkie\t$43\nKamera\t$50\nMP3\t$65\nHiFi\t$100\nGyógyszer\t$50");
					ShowPlayerDialog(playerid, DIALOG_VASARLAS_MUSZAKI, DIALOG_STYLE_TABLIST_HEADERS, "Vegyes üzlet vásárlás", vetelaru, "Megvesz", "Mégse");
				}
				default:
				{
					iMsg(playerid, "Ebben az üzletben nem vásárolhatsz semmit!");
				}
			}
		}
		else
		{
			iMsg(playerid, "Nem vagy egyetlen boltban sem!");
		}

		return 1;
	}
	if(strcmp(cmd, "/kocka", true) == 0)
 	{
	    if(IsValidPlayerID(playerid))
		{
		    if(PlayerToPoint(8.0, playerid, 1871.4955, -1711.7728, 1286.0610))
	  		{
				GiveMoney(playerid, -800);
				//BizPenz(BIZ_247, 800);
				gDice[playerid] = 1;
				Msg(playerid, "Kocka megvéve. A /kockahelp parancsban sok segítséget találsz");
				return 1;
			}
		}
		else
		{
		    Msg(playerid, "Nem vagy a kaszinó bárjánál!");
		}
		return 1;
	}
	if(strcmp(cmd, "/buyhouse", true) == 0)
	{
	    if(IsValidPlayerID(playerid))
	    {
			if(PlayerInfo[playerid][pPhousekey] != NINCS AND PlayerInfo[playerid][pPhousekey2] != NINCS) return Msg(playerid, "Maximum 2 házad lehet!");
			
			GetPlayerName(playerid, playername, sizeof(playername));
			new hazak = sizeof(HouseInfo);
			for(new h = 0; h < hazak; h++)
			{
				if(PlayerToPoint(2.0, playerid, HouseInfo[h][hEntrancex], HouseInfo[h][hEntrancey], HouseInfo[h][hEntrancez]) && HouseInfo[h][hOwned] == 0)
				{
					if(GetMoney(playerid) >= HouseInfo[h][hValue])
					{
					    new neki[MAX_PLAYER_NAME];
						neki = "Nemigenyles";

						HouseInfo[h][hOwned] = 1;
						HouseInfo[h][hCsak] = 0;

						GetPlayerName(playerid, sendername, sizeof(sendername));
						strmid(HouseInfo[h][hOwner], sendername, 0, strlen(sendername), 255);

						GiveMoney(playerid, -HouseInfo[h][hValue]);

						new HazBelso = HouseInfo[h][hBelso];

						SetPlayerInterior(playerid,IntInfo[HazBelso][iNumber]);
						SetPlayerPos(playerid, IntInfo[HazBelso][iExitX], IntInfo[HazBelso][iExitY], IntInfo[HazBelso][iExitZ]);
						SetPlayerVirtualWorld(playerid, h);
						PlayerInfo[playerid][pLocal] = h;

						if(PlayerInfo[playerid][pPhousekey] == NINCS)
						{
							PlayerInfo[playerid][pPhousekey] = h;
							Msg(playerid, "Gratulálok! Megvetted új házadat! [SLOT: 1]");
						} 
						else if(PlayerInfo[playerid][pPhousekey2] == NINCS)
						{
							PlayerInfo[playerid][pPhousekey2] = h;
							Msg(playerid, "Gratulálok! Megvetted új házadat! [SLOT: 2]");
						}
						else
						{
							Msg(playerid, "Elérted a házak számának korlátját!");
						}

						Msg(playerid, "A /help paranncsal több infóra is lelsz, a házzal kapcsolatban!");
						
						#if defined KELLHAZPICKUP
							OnHousePickupUpdate(h);
						#endif

						//HazUpdate(h, "Eladva='1', Tulaj='%s', Csak='0'", sendername);
						HazUpdate(h, HAZ_Owned, HAZ_Owner, HAZ_Csak);
						//BizPenz(BIZ_HAZ, HouseInfo[h][hValue]);

						DateProp(playerid, DP_Haz);
						PlayerUpdate(playerid, "House='%d'", h);
						return 1;
					}
					else
					{
					    format(string, sizeof(string), "Nincs elég pénzed a ház megvételére! Még $%d KP kell! A ház ára $%d", (HouseInfo[h][hValue] - GetMoney(playerid)), HouseInfo[h][hValue]);
						Msg(playerid, string);
						return 1;
					}
				}
			}
		}
		return 1;
	}
	if(egyezik(cmd, "/rentcar"))
	{
		new berkocsi = BereltKocsi[playerid], Float:radi = 5.0;
		if(BereltKocsi[playerid] != NINCS)
		{
			MsgFormat(playerid, "Neked már van bérelt jármûved! [ID: %d]", berkocsi);
			new Float:vehx, Float:vehy, Float:vehz;
			GetVehiclePos(berkocsi, vehx, vehy, vehz);
			SetPlayerCheckpoint(playerid, vehx, vehy, vehz, 8.0);
		}
		else if(!PlayerToPoint(radi, playerid, 1810.4703, -1896.1841, 13.5797))
		{
			Msg(playerid, "Nem vagy az autóbérlõnél!");
			SetPlayerCheckpoint(playerid, 1810.4703, -1896.1841, 13.5797, radi);
		}
		else
		{
			ShowModelSelectionMenu(playerid, jarmuberleslista, "Jármû bérlése", DIALOG_BG_COLOR, PREV_BG_COLOR, PREV_BG_COLOR2);
		}
		return 1;
	}
	if(strcmp(cmd, "/asellhouse", true) == 0)
	{
	    if(IsValidPlayerID(playerid))
		{
			GetPlayerName(playerid, playername, sizeof(playername));
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				Msg(playerid, "Használat: /asellhouse [houseid]");
				return 1;
			}
			new house = strval(tmp);
			if(PlayerInfo[playerid][pAdmin] >= FOADMIN)
			{
				HouseInfo[house][hHel] = 0;
				HouseInfo[house][hArm] = 0;
				HouseInfo[house][hLock] = 0;
				HouseInfo[house][hOwned] = 0;
				PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
				format(string, sizeof(string), "~w~Eladtad a hazat", HouseInfo[house][hValue]);
				GameTextForPlayer(playerid, string, 10000, 3);
				
				#if defined KELLHAZPICKUP
					OnHousePickupUpdate(house);
				#endif
				
				//HazUpdate(house, "Eladva='%d', Tulaj='Nincs_Tulaj', Zarva='0', Elet='0', Pajzs='0'", HouseInfo[house][hOwned]);
				HazUpdate(house, HAZ_Owned, HAZ_Owner, HAZ_Lock, HAZ_Hel, HAZ_Arm);
				PlayerForeach(x)
				{
					if(PlayerInfo[x][pPhousekey] == house)
						PlayerInfo[x][pPhousekey] = NINCS;
					
					if(PlayerInfo[x][pPhousekey2] == house)
						PlayerInfo[x][pPhousekey2] = NINCS;
				}
				return 1;
			}
			else
			{
				Msg(playerid, "Nem használhatod ezt a parancsot.");
			}
		}
		return 1;
	}
	if(egyezik(cmd, "/ujfulke") || egyezik(cmd, "/újfülke"))
	{
		if(!Admin(playerid, FOADMIN)) return HibasParancs(playerid, true);
		
		for(new a = 0; a < MAX_FULKE; a++)
		{
			if(Fulke[a][Van] == 1 && PlayerToPoint(3.0, playerid, Fulke[a][fPosX], Fulke[a][fPosY], Fulke[a][fPosZ]))
			{
				Msg(playerid, "Itt már van egy fülke!");
				return 1;
			}
		}
		
		new fulkeszama = UresFulkeHely();
		if(fulkeszama == -1){
			Msg(playerid, "Nem rakható le több fülke!");
			return 1;
		}
		
		new Float:x, Float:y, Float:z;
		GetPlayerPos(playerid, x, y, z);
		
		Fulke[fulkeszama][fID] = fulkeszama;
		Fulke[fulkeszama][fPosX] = x;
		Fulke[fulkeszama][fPosY] = y;
		Fulke[fulkeszama][fPosZ] = z;
		Fulke3DText(fulkeszama, true);
		Fulke[fulkeszama][Van] = 1;
		
		new nevek[100], adatok[256];
		nevek = "id, PosX, PosY, PosZ";
		format(adatok, 256, "%d, %f, %f, %f",\
		Fulke[fulkeszama][fID],
		Fulke[fulkeszama][fPosX],
		Fulke[fulkeszama][fPosY],
		Fulke[fulkeszama][fPosZ]);
		Mysql_Insert(SQL_DB_Fulke, nevek, adatok);
		SendFormatMessage(playerid,COLOR_GREEN, "Új fülke lerakva! (ID: %d)", fulkeszama);
		return 1;
	}
	if(strcmp(cmd, "/callbox", true) == 0)
	{
		new fulkenelvan = NINCS;
		for(new a = 0; a < MAX_FULKE; a++)
		{
			if(Fulke[a][Van] == 1 && PlayerToPoint(3.0, playerid, Fulke[a][fPosX], Fulke[a][fPosY], Fulke[a][fPosZ]))
			{
				fulkenelvan = 1;
			}
		}
		if(fulkenelvan == NINCS) return Msg(playerid, "Nem vagy telefonfülke közelében!");
		if(PlayerCuffed[playerid] == 2) return Msg(playerid,"Bilincsben nincs telefonálás!");
		if(Kezenlove[playerid]) return Msg(playerid, "Nem tudsz hívni, mert meglõtték a kezed!");
	    if(!Bortonben(playerid))
		{
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				Msg(playerid,"/callbox [Telefonszám]");
				return 1;
			}
			new phonenumb = strval(tmp);
			if(phonenumb == PlayerInfo[playerid][pPnumber])
			{
				Msg(playerid, "Saját magadat nem hívhatod fel..");
				return 1;
			}
			if(Mobile[playerid] != NINCS) Mobile[playerid] = NINCS;

			GetPlayerName(playerid, sendername, sizeof(sendername));

			if(phonenumb == 911)
			{
				Msg(playerid,  "Sürgõsségi: Kit szeretnél hívni? Rendõrség, mentõ vagy tûzoltó?");
				Msg(playerid,  "Kérjük adja meg a pontos helyzetét is!");
				Mobile[playerid] = 911;
				
				return 1;
			}
			PlayerForeach(i)
			{
				if(IsValidPlayerID(i))
				{
					if(PlayerInfo[i][pPnumber] == phonenumb && phonenumb != 0)
					{
						giveplayerid = i;
						Mobile[playerid] = giveplayerid; //caller connecting
						
				        new Hivasara = 5;
						
						if(GetMoney(playerid) < Hivasara)
						{
							Msg(playerid, "Nem áll rendelkezésre elegendõ összeg a hívás kapcsolásához.");
							return 1;
						}
						
						if(AdminDuty[giveplayerid]) return Msg(playerid, "AdminSzolgálatost ne hívj már fel..");

						if(PlayerInfo[giveplayerid][pJailed] != BORTON_NINCS) return Msg(playerid, "Börtönben van!");

				        if(PhoneOnline[giveplayerid] > 0)
				        {
							Msg(playerid, "A hívott szám jelenleg nem kapcsolható..");
				            return 1;
				        }
						if(Mobile[giveplayerid] == -1)
						{
						    new hivo = PlayerInfo[playerid][pPnumber];

							if(!Rejtett[playerid])
								format(string, sizeof(string), "Csörög a telefonod! Hívó: %d (/telefon)", hivo);
							else if(PlayerInfo[giveplayerid][pAdmin] > 1)
								format(string, sizeof(string), "Csörög a telefonod! Hívó: Ismeretlen (/telefon) - %d", hivo);
							else
								format(string, sizeof(string), "Csörög a telefonod! Hívó: Ismeretlen (/telefon)");
		

							SendClientMessage(giveplayerid, COLOR_YELLOW, string);
							GetPlayerName(giveplayerid, sendername, sizeof(sendername));
							RingTone[giveplayerid] = 10;
							format(string, sizeof(string), "* Valakinek csörög a telefonja", sendername);
							ProxDetector(30.0, i, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
							CellTime[playerid] = 1;

							return 1;
						}
						else {
							Msg(playerid, "Foglalt... Hívásban van...");
						}
					}
				}
			}
			Msg(playerid, "Nincs ilyen telefonszám.");
		}
		else
			Msg(playerid, "Börtönben nem lehet!");
		return 1;
	}
	if(strcmp(cmd, "/call", true) == 0)
	{
		//if(PlayerInfo[playerid][pKezTores] == KEZLAB_TOROTT)	return Msg(playerid, "Nem tudsz hívni mert elvan törve a kezed!");
		if(PlayerCuffed[playerid] == 2) return Msg(playerid,"Bilincsben nincs telefonálás!");
		if(Kezenlove[playerid]) return Msg(playerid, "Nem tudsz hívni, mert meglõtték a kezed!");
	    if(!Bortonben(playerid))
		{
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				Msg(playerid,"/call [Telefonszám]");
				
				new torzs[512];
				strcat(torzs, "Leírás\tTelefonszám\n");
				strcat(torzs, "Segélyhívó\t911\n");
				strcat(torzs, "Rendõrségi nem segélyhívó\t991\n");
				strcat(torzs, "Taxi szolgálat\t544\n");
				strcat(torzs, "Autómentõ szolgálat\t555\n");
				strcat(torzs, "Impounder\t533\n");
				strcat(torzs, "Börtön\t1-800-PRISON\n");
				strcat(torzs, "San Andreas Network\t1-800-SAN\n");
				strcat(torzs, "Kormányhivatal\t1-800-GOV\n");
				strcat(torzs, "Igazságügyi minisztérium\t1-800-JUSTICE\n");
				
				ShowPlayerDialog(playerid, DIALOG_NINCS, DIALOG_STYLE_TABLIST_HEADERS, "Alapvetõ telefonszámok", torzs, "Bezár", "");
				return 1;
			}
			if(PlayerInfo[playerid][pPnumber] == 0)
			{
				Msg(playerid, "Nincs telefonod!");
				return 1;
			}
			new phonenumb = strval(tmp);
			if(phonenumb == PlayerInfo[playerid][pPnumber])
			{
				Msg(playerid, "Saját magadat nem hívhatod fel..");
				return 1;
			}
			if(Mobile[playerid] != -1)
			{
				Msg(playerid, "Már hívásban vagy...");
				return 1;
			}

			GetPlayerName(playerid, sendername, sizeof(sendername));

			if(phonenumb == 911)
			{
				Msg(playerid,  "Sürgõsségi: Kit szeretnél hívni? Rendõrség, mentõ vagy tûzoltó?");
				Msg(playerid,  "Kérjük adja meg a pontos helyzetét is!");
				Mobile[playerid] = 911;
				
				SetPlayerAttachedObject(playerid, SLOT_KEZ, 18865, 6, 0.115999, 0.005999, -0.000999, -104.700004, -11.600001, 156.200042, 1.000000, 1.000000, 1.000000);
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USECELLPHONE);
				
				return 1;
			}
			PlayerForeach(i)
			{
				if(IsValidPlayerID(i))
				{
					if(PlayerInfo[i][pPnumber] == phonenumb && phonenumb != 0)
					{
						giveplayerid = i;
						Mobile[playerid] = giveplayerid; //caller connecting
						
				        new Hivasara = 5;
						
						if(PlayerInfo[playerid][pTeloEgyenleg] < Hivasara)
						{
							Msg(playerid, "Nem áll rendelkezésre elegendõ összeg a hívás kapcsolásához. Feltöltés: /egyenleg feltölt");
							return 1;
						}
						
						if(AdminDuty[giveplayerid]) return Msg(playerid, "AdminSzolgálatost ne hívj már fel..");

						if(PlayerInfo[giveplayerid][pJailed] != BORTON_NINCS)
							return Msg(playerid, "Börtönben van!");

				        if(PhoneOnline[giveplayerid] > 0)
				        {
							Msg(playerid, "A hívott szám jelenleg nem kapcsolható..");
				            return 1;
				        }
						if(Mobile[giveplayerid] == -1)
						{
						    new hivo = PlayerInfo[playerid][pPnumber];

							if(!Rejtett[playerid])
								format(string, sizeof(string), "Csörög a telefonod! Hívó: %d (/telefon)", hivo);
							else if(PlayerInfo[giveplayerid][pAdmin] > 1)
								format(string, sizeof(string), "Csörög a telefonod! Hívó: Ismeretlen (/telefon) - %d", hivo);
							else
								format(string, sizeof(string), "Csörög a telefonod! Hívó: Ismeretlen (/telefon)");
		

							SendClientMessage(giveplayerid, COLOR_YELLOW, string);
							GetPlayerName(giveplayerid, sendername, sizeof(sendername));
							RingTone[giveplayerid] = 10;
							format(string, sizeof(string), "* Valakinek csörög a telefonja", sendername);
							ProxDetector(30.0, i, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
							CellTime[playerid] = 1;
							
							SetPlayerAttachedObject(playerid, SLOT_KEZ, 18865, 6, 0.115999, 0.005999, -0.000999, -104.700004, -11.600001, 156.200042, 1.000000, 1.000000, 1.000000);
							SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USECELLPHONE);

							return 1;
						}
						else {
							Msg(playerid, "Foglalt... Hívásban van...");
						}
					}
				}
			}
			Msg(playerid, "Nincs ilyen telefonszám.");
		}
		else
			Msg(playerid, "Börtönben nem lehet!");
		return 1;
	}
	if(strcmp(cmd, "/telefon", true) == 0)
	{
		/*if(iPhoneStatus[playerid] == 0)
		{
			loop(0, 22, PHONE) TextDrawShowForPlayer(playerid, TD_iPhone[PHONE]);
            iPhoneStatus[playerid] = 1;
		}
		else
		{
		    loop(0, sizeof(TD_iPhone), PHONE) TextDrawHideForPlayer(playerid, TD_iPhone[PHONE]);
		    loop(0, sizeof(PTD_iPhone), PPHONE) PlayerTextDrawHide(playerid, PTD_iPhone[PPHONE][playerid]);
		    HideIphoneMenu(playerid);
		    iPhoneStatus[playerid] = 0;
		}*/
	}
	if(strcmp(cmd, "/sms", true) == 0)
	{
		if(FloodCheck(playerid,cmd)) return 1;
	    if(!Bortonben(playerid))
		{
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				Msg(playerid, "/sms [telefonszám] [SMS szövege]");
				return 1;
			}
			if(PlayerInfo[playerid][pPnumber] == 0)
			{
				Msg(playerid, "Nincs telefonod! 24/7-ben lehet venni!");
				return 1;
			}
			if(PhoneOnline[playerid] > 0)
   			{
				Msg(playerid, "A telefonod kivan kapcsolva...");
				return 1;
	        }
			if(Kezenlove[playerid]) return Msg(playerid, "Nem tudsz SMS-t küldeni, mert meglõtték a kezed!");
			new phonenumb = strval(tmp);
			new length = strlen(cmdtext);
			while ((idx < length) && (cmdtext[idx] <= ' '))
			{
				idx++;
			}
			new offset = idx;
			new result[128];
			while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
			{
				result[idx - offset] = cmdtext[idx];
				idx++;
			}
			result[idx - offset] = EOS;
			if(!strlen(result))
			{
				Msg(playerid, "/sms [Telefonszám] [SMS szövege]");
				Msg(playerid, "103[Riporter]");
				return 1;
			}

			if(SzovegEllenorzes(playerid, result, "/sms")) return 1;

			new ara = 2;

			new egyenleg = PlayerInfo[playerid][pTeloEgyenleg];

			if(egyenleg < ara)
			{
	            format(string, sizeof(string), "[%s]SMS: Egy SMS ára $%d! Kérjük töltse fel egyenlegét!",SzolgaltatoNev(playerid),ara);
	            SendClientMessage(playerid, COLOR_YELLOW, string);
	            return 1;
			}
			PlayerForeach(i)
			{
				if(IsValidPlayerID(i))
				{
					if(PlayerInfo[i][pPnumber] == phonenumb)
					{
						giveplayerid = i;
						Mobile[playerid] = giveplayerid;
						if(IsValidPlayerID(giveplayerid))
						{
						    if(giveplayerid != INVALID_PLAYER_ID)
						    {
								if(PlayerInfo[giveplayerid][pPnumber] == 0)
								{
									Msg(playerid, "A játékosnak nincs telefonja!");
									return 1;
								}
						        if(PhoneOnline[giveplayerid] > 0)
						        {
						            Msg(playerid, "A játékos telefonja kivan kapcsolva!");
						            return 1;
						        }
								if(Bortonben(giveplayerid))
									return Msg(playerid, "Õ börtönben van!");

								format(string, sizeof(string), "SMS: %s | Telefonszám: [%d]", result,PlayerInfo[playerid][pPnumber]);
								GetPlayerName(giveplayerid, sendername, sizeof(sendername));
								//format(string, sizeof(string), "* %s's phone beeps.", sendername);
								RingTone[giveplayerid] = 20;
								Msg(playerid, "Üzenet elküldve!");
								SendClientMessage(giveplayerid, COLOR_YELLOW, string);
								SendClientMessage(playerid,  COLOR_YELLOW, string);
								GetPlayerName(playerid, sendername, sizeof(sendername));
								format(string, sizeof(string), "* Valaki elõvette a telefonját, és írt egy sms-t.");
								ProxDetector(30.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
								format(string, sizeof(string), "~r~-$%d", ara);
								GameTextForPlayer(playerid, string, 5000, 1);
								PlayerInfo[playerid][pTeloEgyenleg] = PlayerInfo[playerid][pTeloEgyenleg] - ara;
					           	PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
					           	Mobile[playerid] = -1;
								return 1;
							}
						}
					}
				}
			}
			Msg(playerid, "Üzenet elküldése sikertelen...");
		}
		else
			Msg(playerid, "Börtönben nem lehet!");
		return 1;
	}
	//----------------------------------[TIME]-----------------------------------------------
	if(strcmp(cmd, "/time", true) == 0)
	{
		if(FloodCheck(playerid, cmd)) return 1;
	    if(IsValidPlayerID(playerid))
		{
		    new mtext[20];
			new year, month, day;
			getdate(year, month, day);
			if(month == 1) { mtext = "Január"; }
			else if(month == 2) { mtext = "Február"; }
			else if(month == 3) { mtext = "Március"; }
			else if(month == 4) { mtext = "Április"; }
			else if(month == 5) { mtext = "Május"; }
			else if(month == 6) { mtext = "Június"; }
			else if(month == 7) { mtext = "Július"; }
			else if(month == 8) { mtext = "Augusztus"; }
			else if(month == 9) { mtext = "Szeptember"; }
			else if(month == 10) { mtext = "Október"; }
			else if(month == 11) { mtext = "November"; }
			else if(month == 12) { mtext = "December"; }
			new hour, minuite, second;
			gettime(hour, minuite, second);
			ApplyAnimation(playerid, "COP_AMBIENT", "Coplook_watch", 4.1, 0, 0, 0, 0, -1);
			if(minuite < 10)
			{
				if(PlayerInfo[playerid][pJailTime] > 0)
				{
					format(string, sizeof(string), "~y~%s %d~n~~g~|~w~%d:0%d~g~|~n~~w~Börtön: %dmp", mtext, day, hour, minuite, PlayerInfo[playerid][pJailTime]);
				}
				else
				{
					format(string, sizeof(string), "~y~%s %d~n~~g~|~w~%d:0%d~g~|", mtext, day, hour, minuite);
				}
			}
			else
			{
				if(PlayerInfo[playerid][pJailTime] > 0)
				{
					format(string, sizeof(string), "~y~%s %d~n~~g~|~w~%d:%d~g~|~n~~w~Börtön: %dmp", mtext, day, hour, minuite, PlayerInfo[playerid][pJailTime]);
				}
				else
				{
					format(string, sizeof(string), "~y~%s %d~n~~g~|~w~%d:%d~g~|", mtext, day, hour, minuite);
				}
			}
			GameTextForPlayer(playerid, string, 5000, 1);
			/*format(string, sizeof(string), "* Valaki megnézte az óráját");
			ProxDetector(30.0, playerid,string , COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);*/
		}
		return 1;
	}
//----------------------{HOUSES}-------------------
	if(strcmp(cmd, "/house", true) == 0)
	{
	    if(IsValidPlayerID(playerid))
		{
		    if(PlayerInfo[playerid][pAdmin] >= FOADMIN)
		    {
				tmp = strtok(cmdtext, idx);
				if(!strlen(tmp))
				{
					Msg(playerid, "/house [housenumber]");
					return 1;
				}
				new housenum = strval(tmp);
				if(HouseInfo[housenum][Van] != 1)
				{
				    SendClientMessage(playerid, COLOR_PIROS, "Nincs ilyen ház");
				    return 1;
				}
				new HazBelso = HouseInfo[housenum][hBelso];
				SetPlayerInterior(playerid,IntInfo[HazBelso][iNumber]);
				SetPlayerPos(playerid,IntInfo[HazBelso][iExitX],IntInfo[HazBelso][iExitY],IntInfo[HazBelso][iExitZ]);
				SetPlayerVirtualWorld(playerid, housenum);
				GameTextForPlayer(playerid, "~w~Mindjárt ottvagyunk", 5000, 1);
				PlayerInfo[playerid][pLocal] = housenum;
			}
		}
		return 1;
	}
	if(egyezik(cmd, "/houseo"))
	{
	    if(IsValidPlayerID(playerid))
		{
		    if(PlayerInfo[playerid][pAdmin] >= FOADMIN)
		    {
				tmp = strtok(cmdtext, idx);
				if(!strlen(tmp))
				{
					Msg(playerid, "/houseo [housenumber]");
					return 1;
				}
				new housenum = strval(tmp);
				if(HouseInfo[housenum][Van] != 1)
				{
				    SendClientMessage(playerid, COLOR_PIROS, "Nincs ilyen ház");
				    return 1;
				}
				SetPlayerPos(playerid,HouseInfo[housenum][hEntrancex],HouseInfo[housenum][hEntrancey],HouseInfo[housenum][hEntrancez]);
				SetPlayerVirtualWorld(playerid, 0);
				SetPlayerInterior(playerid, 0);
				GameTextForPlayer(playerid, "~w~Mindjárt ottvagyunk", 5000, 1);
			}
		}
		return 1;
	}
	if(egyezik(cmd, "/nyit"))
	{
		new length = strlen(cmdtext);
		while ((idx < length) && (cmdtext[idx] <= ' '))
		{
			idx++;
		}
		new offset = idx;
		new result[128];
		while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
		{
			result[idx - offset] = cmdtext[idx];
			idx++;
		}
		result[idx - offset] = EOS;

		if(strlen(result) > 32)
		{
			return Msg(playerid, "A jelszó maximum 32 karakter!");
		}
        new kapu = IsAt(playerid,IsAt_Kapu);
        if(kapu != NINCS)
        {
			SeeRPGKeypad(playerid, kapu, KapuInfo[kapu][kJelszo]);
		}
		else if(PlayerToPoint(10.0, playerid, 1589.01868, -1637.91931, 14.67790))
		{
			if(!egyezik(FrakcioInfo[LMUNKA_LSPD][fJelszo],"NoPW") && (egyezik(result,FrakcioInfo[LMUNKA_LSPD][fJelszo])) && strlen(result) > 1 || LMT(playerid,LMUNKA_LSPD) || LMT(playerid,LMUNKA_FBI) || IsAdmin(playerid))
			{
				MoveDynamicObject(LSPDKAPU, 1589.01868, -1637.91931, 9.14000, 3.0);
			}
			else {
			    return Msg(playerid, "Nincs távirányítód ehhez a kapuhoz!");
			}
			if(kdebug[playerid] == 1)
			{
				Msg(playerid, "Definíció: \"LSPDKAPU\"");
				Msg(playerid, "Tulaj: LAPD Frakció");
			}
		}
		else Msg(playerid, "Nem vagy kapu közelében!");
		return 1;
	}
	if(egyezik(cmd, "/zar") || egyezik(cmd, "/zár"))
	{
		new length = strlen(cmdtext);
		while ((idx < length) && (cmdtext[idx] <= ' '))
		{
			idx++;
		}
		new offset = idx;
		new result[128];
		while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
		{
			result[idx - offset] = cmdtext[idx];
			idx++;
		}
		result[idx - offset] = EOS;

		if(strlen(result) > 32) return Msg(playerid, "A jelszó maximum 32 karakter!");

        new kapu = IsAt(playerid,IsAt_Kapu);
        if(kapu != NINCS)
        {
			MoveDynamicObject(KapuInfo[kapu][kObject], KapuInfo[kapu][kPos][0], KapuInfo[kapu][kPos][1], KapuInfo[kapu][kPos][2], 5);
		}
		else if(PlayerToPoint(10.0, playerid, 1589.01868, -1637.91931, 14.67790))
		{
			if(!egyezik(FrakcioInfo[LMUNKA_LSPD][fJelszo],"NoPW") && (egyezik(result,FrakcioInfo[LMUNKA_LSPD][fJelszo])) && strlen(result) > 1 || LMT(playerid,LMUNKA_LSPD) || LMT(playerid,LMUNKA_FBI) || IsAdmin(playerid))
			{
				MoveDynamicObject(LSPDKAPU, 1589.01868, -1637.91931, 14.67790, 3.0);
			}
			else {
			    return Msg(playerid, "Nincs távirányítód ehhez a kapuhoz!");
			}
			if(kdebug[playerid] == 1)
			{
				Msg(playerid, "Definíció: \"LSPDKAPU\"");
				Msg(playerid, "Tulaj: LAPD Frakció");
			}
		}
		return 1;
	}
//-----------------------------------[HEAL]-------------------------------------------------------------------------
    if(egyezik(cmd, "/életmentés"))
	{
		if(IsValidPlayerID(playerid))
		{
		    if(params < 1) return Msg(playerid, "/életmentés [JátékosID/NévRészlet]");
		    new player = ReturnUser(param[1]);
		    new mentokocsi = GetClosestCar(playerid);
		    if(player != playerid)
		    {
			    if(LMT(playerid,LMUNKA_MENTO) || OnkentesMentos[playerid] != 0)
			    {
			        if(GetDistanceToCar(playerid, mentokocsi) < 3)
			        {
						if(IsAnAmbulance(mentokocsi))
						{
							ClearAnimations(player);
							PutPlayerInVehicle(player, mentokocsi, 2);
						}
						else
						{
							Msg(playerid, "Nincs a közelben mentõszolgálati eszközökkel ellátott jármû!");
						}
			        }
			        else
			        {
			            Msg(playerid, "Nincs a közelben mentõszolgálati eszközökkel ellátott jármû!");
			        }
			    }
			    else
			    {
			        Msg(playerid, "Nem vagy Mentõs!");
			        return 1;
			    }
			}
			else
			{
			    Msg(playerid, "Magadat? O_o");
			    return 1;
			}
  		}
  		return 1;
	}
	if(egyezik(cmd, "/bead"))
	{
	    if(IsValidPlayerID(playerid))
	    {
	        if(params < 2) return Msg(playerid, "/bead [JátékosID/NévRészlet] [Orvosság]");
			new player = ReturnUser(param[1]);
			if(egyezik(param[2], "Orvosság") || egyezik(param[2], "Orvossag"))
			{ 
			    if(LMT(playerid, LMUNKA_MENTO) || OnkentesMentos[playerid] != 0)
			    {
				    if(ProxDetectorS(4.0, playerid, player))
					{
						Msg(player, "A mentõs Beadta neked a gyógyszert!");
						Animbanemrakhato[player] = 1;
					    SetHealth(player, MAXHP);
					    Cselekves(playerid, "Beadja a betegnek az orvosságot");
					}
					if(playerid == giveplayerid)
					{
						Msg(playerid, "Magadnak nem adhatod be!");
						return 1;
					}
				}
				else
				{
				    Msg(playerid, "Orvosságot csak mentõs adhat be!");
				    return 1;
				}
			}
			else
			    return Msg(playerid, "/bead [JátékosID/NévRészlet] [Orvosság]");
		}
		return 1;
	}
	if(strcmp(cmd, "/heal", true) == 0)
	{
	    if(IsValidPlayerID(playerid))
		{
			tmp = strtok(cmdtext, idx);
			GetPlayerName(playerid, sendername, sizeof(sendername));
			if(!strlen(tmp))
			{
				new x, haz = NINCS, HazBelso;
				for(x = 0; x < sizeof(HouseInfo); x++)
				{
					if(HouseInfo[x][Van] == 1)
					{
						HazBelso = HouseInfo[x][hBelso];
						if(PlayerToPoint(200, playerid, IntInfo[HazBelso][iExitX], IntInfo[HazBelso][iExitY], IntInfo[HazBelso][iExitZ]) && GetPlayerVirtualWorld(playerid) == x && GetPlayerInterior(playerid) == IntInfo[HazBelso][iNumber])
						{
							haz = x;
							break;
						}
					}
				}

				if(haz != NINCS)
				{
					if(HouseInfo[haz][hArm] == 1)
					{
						if(IsACop(playerid))
						{
							format(string, sizeof(string), "* Valaki felvett egy golyóálló mellényt.");
							ProxDetector(30.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
							SetPlayerArmour(playerid, MAXARMOUR);
						}
						else Msg(playerid, "Nem vagy rendvédelmis, ezért nem veheted fel a mellényt...");
					}
					else
					{
						format(string, sizeof(string), "Ezen a helyen nincs golyóálló mellény.");
						SendClientMessage(playerid, TEAM_GREEN_COLOR,string);
					}
					if(HouseInfo[haz][hHel] == 1)
					{
						if(HouseInfo[haz][hKaja] >= 1)
							HouseInfo[haz][hKaja] --;
						else
							return Msg(playerid, "A hûtõ üres...");

						new Float:tempheal;
						GetPlayerHealth(playerid,tempheal);
						if(tempheal < 149.0)
						{
							SetHealth(playerid, 150.0);

							PlayerPlaySound(playerid, 1150, 0.0, 0.0, 0.0);
							format(string, sizeof(string), "* %s megevett egy szendvicset, amit a hûtõben talált.", sendername);
							ProxDetector(30.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
						}
						else
							SendClientMessage(playerid, TEAM_GREEN_COLOR, "Tele vagy... nem bírsz többet enni.");
					}
					else
					{
						format(string, sizeof(string), "Ezen a helyen nincs hûtõ.");
						SendClientMessage(playerid, TEAM_GREEN_COLOR,string);
					}
					return 1;
				}
				else
				{
					//Msg(playerid, "/heal [JátékosID/NévRészlet]");
					Msg(playerid, "Nem vagy házban! (Ha mentõs vagy, a parancs /bead)");
					return 1;
				}
			}
		}
		return 1;
	}
//----------------------------------[HQ]-----------------------------------------------
	if(strcmp(cmd, "/hq", true) && playerid == NINCS)
	{
	    if(IsValidPlayerID(playerid))
	    {
			GetPlayerName(playerid, sendername, sizeof(sendername));
			new length = strlen(cmdtext);
			while ((idx < length) && (cmdtext[idx] <= ' '))
			{
				idx++;
			}
			new offset = idx;
			new result[64];
			while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
			{
				result[idx - offset] = cmdtext[idx];
				idx++;
			}
			result[idx - offset] = EOS;
			if(!strlen(result))
			{
				Msg(playerid, "/hq [hq text]");
				return 1;
			}
			format(string, sizeof(string), "HQ: %s, vége.", result);
			// blabla át kell írni, gteam kiszedve
			printf("HQ: %s", result);
		}
		return 1;
	}
	if(strcmp(cmd, "/bigears", true) == 0 && PlayerInfo[playerid][pAdmin] >= 5)
	{
	    if(IsValidPlayerID(playerid))
	    {
			if(!BigEar[playerid])
			{
				BigEar[playerid] = 1;
				Msg(playerid, "* Hallod, amit távol mondanak!");
			}
			else if(BigEar[playerid])
			{
				(BigEar[playerid] = 0);
				Msg(playerid, "* Újra normális a hallásod.");
			}
		}
		return 1;
	}
	
	if(strcmp(cmd, "/id", true) == 0)
	{
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp)) return Msg(playerid, "/ID [JátékosID/NévRészlet]");
		new target;
		target = ReturnUser(tmp);
		new sstring[60];
		if(target == INVALID_PLAYER_ID/* || IsFejleszto(target)*/) return Msg(playerid, "Nincs ilyen játékos");
		GetPlayerName(target, giveplayer, sizeof(giveplayer));
		format(sstring, sizeof(sstring), "ID: [%d]%s", target, giveplayer);
		Msg(playerid, sstring);
		return 1;
	}

	if(strcmp(cmd, "/tv", true) == 0 || strcmp(cmd, "/megfigyel", true) == 0)
	{
	    if(IsAS(playerid) || Admin(playerid))
	    {	
			tmp = strtok(cmdtext, idx);

			giveplayerid = ReturnUser(tmp);
			
			if(!strlen(tmp) || egyezik(tmp, "off"))
			{
			    if(Tevezik[playerid] != NINCS)
			    {
					//Spectate[playerid] = 253;

					TogglePlayerSpectating(playerid, 0);
					
					GameTextForPlayer(playerid, "~w~TV~n~~r~Ki", 5000, 6);
					PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
					GetPlayerName(playerid, sendername, sizeof(sendername));
					
					/*if(TvEngedely[playerid] == 1)
					{
						format(string, sizeof(string), "AdminSegéd %s befejezte %s figyelését!", sendername, PlayerName(Tevezik[playerid]));
						ABroadCast(COLOR_LIGHTRED, string, 0);
					}*/
						
					if(PlayerInfo[Tevezik[playerid]][pAdmin] == 0 || PlayerInfo[playerid][pAdmin] <= PlayerInfo[Tevezik[playerid]][pAdmin])
					{
						/*format(string, sizeof(string), "%s %s befejezte %s figyelését!", AdminSzint(playerid), AdminName(playerid), PlayerName(Tevezik[playerid]));
						if(PlayerInfo[playerid][pAdmin] <= FOADMIN)
							ABroadCast(COLOR_LIGHTRED, string, 1);*/
					}
					//ShowInfoBar(playerid, true);
					Tevezve[Tevezik[playerid]] = NINCS;
					Tevezik[playerid] = NINCS;
					
					MostLepettBe[playerid] = 1;
					OnPlayerSpawn(playerid);
					PlayerInfo[playerid][pPosX] = 0.0;
					
					return 1;
				}
				else
				{
				    Msg(playerid, "Jelenleg nem TV-zel");
				    return 1;
				}
			}
			if(Admin(playerid, 1) || IsAS(playerid))
			{
				if(IsAS(playerid) AND ASDuty[playerid] == 0) return Msg(playerid, "Csak AdminSegéd szolgálatban használhatod!");
				giveplayerid = ReturnUser(tmp);
			    if(giveplayerid != INVALID_PLAYER_ID)
			    {
					if(IsPlayerNPC(giveplayerid) AND !Admin(playerid, FOADMIN)) return Msg(playerid, "Hagyd békén az NPC-t!");
					if(GetPVarType(giveplayerid, "FlyMode")) return Msg(playerid, "Õ most éppen FlyModeban van, várj egy kicsit!");
					
					if(RicardoVedelem(playerid, giveplayerid)) return 1;
					
					if(PlayerInfo[playerid][pAdmin] < PlayerInfo[giveplayerid][pAdmin] && PlayerInfo[giveplayerid][pAdmin] < FOADMIN && !IsTulaj(playerid))
					{
						Msg(playerid, "Nagyobb Admint ne akarj TV-zni!!");
						SendFormatMessage(giveplayerid, COLOR_GREY, "%s TV-zni akart téged!", PlayerName(playerid));
						return 1;
					}

					if(Tevezik[playerid] == NINCS)
					{
						/*for(new x = 0; x < 12; x++) {
							GetPlayerWeaponData(playerid, x, PlayerInfo[playerid][pFegyver][x], PlayerInfo[playerid][pTolteny][x]);
						}*/
						GetPlayerPos(playerid, PlayerInfo[playerid][pPosX], PlayerInfo[playerid][pPosY], PlayerInfo[playerid][pPosZ]);
						PlayerInfo[playerid][pInt] = GetPlayerInterior(playerid);
						PlayerInfo[playerid][pLocal] = GetPlayerVirtualWorld(playerid);
						GetPlayerHealth(playerid, PlayerInfo[playerid][pCelet]);
						GetPlayerArmour(playerid, PlayerInfo[playerid][pCpajzs]);
						//GetPlayerSkin(playerid, PlayerInfo[playerid][pModel]);
					}
					else {
						Tevezve[Tevezik[playerid]] = NINCS;
					}
					
					Tevezik[playerid] = giveplayerid;
					TogglePlayerSpectating(playerid, 1);

					if(!IsPlayerInAnyVehicle(giveplayerid))
						PlayerSpectatePlayer(playerid, giveplayerid);
					else
						PlayerSpectateVehicle(playerid, GetPlayerVehicleID(giveplayerid));

					SetPlayerInterior(playerid, GetPlayerInterior(giveplayerid));
					SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(giveplayerid));
					GetPlayerName(playerid, sendername, sizeof(sendername));
					GetPlayerName(giveplayerid, giveplayer, sizeof(giveplayer));

					/*if(TvEngedely[playerid] == 1)
					{
						format(string, sizeof(string), "AdminSegéd %s megfigyeli %s-t!", sendername, giveplayer);
						ABroadCast(COLOR_LIGHTRED, string, 1);
					}
					else
					{
						if(PlayerInfo[giveplayerid][pAdmin] == 0 || PlayerInfo[playerid][pAdmin] <= PlayerInfo[giveplayerid][pAdmin])
						{
							format(string, sizeof(string), "Admin %s megfigyeli %s-t!", AdminName(playerid), giveplayer);
							if(PlayerInfo[playerid][pAdmin] <= FOADMIN)
								ABroadCast(COLOR_LIGHTRED, string, 1);
						}
					}	*/
					
					if(PlayerInfo[giveplayerid][pAdmin] == 0 || PlayerInfo[playerid][pAdmin] <= PlayerInfo[giveplayerid][pAdmin])
					{
						format(string, sizeof(string), "(%s) %s megfigyeli %s-t!", AdminSzint(playerid), AdminName(playerid), giveplayer);
						if(PlayerInfo[playerid][pAdmin] <= FOADMIN)
							ABroadCast(COLOR_LIGHTRED, string, 1);
					} 
					//ShowInfoBar(playerid, false);
					Tevezik[playerid] = giveplayerid;
					Tevezve[giveplayerid] = playerid;
				}
			}
			else
				SendClientMessage(playerid, COLOR_GREEN, "Nem vagy admin, vagy nincs TV engedélyed!");
		} else HibasParancs(playerid, true);
		return 1;
	}
	if(strcmp(cmd, "/a", true) == 0 || strcmp(cmd, "/ac", true) == 0)
	{
	    if(IsValidPlayerID(playerid))
	    {
			if(!Admin(playerid, 1)) return HibasParancs(playerid, true);
			
			if(noachat == 1 && !IsTulaj(playerid)) return Msg(playerid, "Az Admin chat le van tiltva.", COLOR_ADMIN);

			GetPlayerName(playerid, sendername, sizeof(sendername));
			new length = strlen(cmdtext);
			while ((idx < length) && (cmdtext[idx] <= ' '))
			{
				idx++;
			}
			new offset = idx;
			new result[96];
			while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
			{
				result[idx - offset] = cmdtext[idx];
				idx++;
			}
			result[idx - offset] = EOS;
			if(!strlen(result))
			{
				Msg(playerid, "(/a)dmin [üzenet]", COLOR_ADMIN);
				return 1;
			}

			PlayerForeach(x)
			{
			    if(Admin(x, 1))
				{
			        //SendFormatMessage(x, COLOR_LIGHTBLUE, "{FF0000}STAFF: {00BFFF}%s %s: %s", AdminSzint(playerid), AdminName(playerid), result);
			        SendFormatMessage(x, COLOR_GREEN, "(%s) %s: %s", AdminSzint(playerid), AdminName(playerid), result);
				}
			}
		}
		return 1;
	}
	
	if(egyezik(cmd, "/sa"))
	{
		if(!IsFejleszto(playerid)) return HibasParancs(playerid, true);

		GetPlayerName(playerid, sendername, sizeof(sendername));
		new length = strlen(cmdtext);
		while ((idx < length) && (cmdtext[idx] <= ' '))
		{
			idx++;
		}
		new offset = idx;
		new result[96];
		while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
		{
			result[idx - offset] = cmdtext[idx];
			idx++;
		}
		result[idx - offset] = EOS;
		if(!strlen(result))
		{
			Msg(playerid, "/sa [üzenet]");
			return 1;
		}
			
		format(string, sizeof(string), "STAFF: (%s) %s: %s", AdminSzint(playerid), AdminName(playerid), result);
		SendSAdminMessage(COLOR_LIGHTRED, string);
		return 1;
	}
	if(egyezik(cmd, "/settime") || egyezik(cmd, "/tod"))
	{
		if(!IsFejleszto(playerid)) return HibasParancs(playerid, true);
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp)) return Msg(playerid, "/settime [Idõ] (0-23)");
		
		new ido = strval(tmp);
		if(0 < ido > 23) return Msg(playerid, "0-23 óra közöttit adj meg!");
		
		new hour = ido;
		SetWorldTime(hour);
		format(string, sizeof(string), "Az idõ átírva. Új idõ: %d óra.", hour);
		Msg(playerid, string, COLOR_ADMIN);
		return 1;
	}
//-----------------------------------editstat---------------------------------------
	if(egyezik(cmd, "/setstat"))
	{
		if(!Admin(playerid, FOADMIN)) return HibasParancs(playerid, true);
		if(params < 3)
		{
			new szin = COLOR_WHITE;
			Msg(playerid, ValasztoVonal("Játékos adatok"));
			SendClientMessage(playerid, szin, "{"#COLOR_SEEBLUE"}Használat: /setstat [Játékos ID/ Név] [Kód] [Érték]");
			SendClientMessage(playerid, szin, "1 Bankszámla pénz | 2 Telefonszám | 3 Házkulcs | 4 Bizniszkulcs");
			SendClientMessage(playerid, szin, "5 Detektív Skill | 6 Ügyvéd Skill | 7 szerelõ Skill | 8 Riporter Skill");
			SendClientMessage(playerid, szin, "9 Autólopás Skill | 10 Drogárus Skill | 11 Box Skill | 12 Hacker Skill");
			SendClientMessage(playerid, szin, "13 Nem | 14 Életkor | 15 Fõmunka | 16 Másodmunka");
			SendClientMessage(playerid, szin, "17 Materialok | 18 Marihuana | 19 Kokain | 20 Heroin");
			SendClientMessage(playerid, szin, "21 Kocsikulcs | 22 2. Kocsi | 23 Bankszámlaszám | 24 Házasság");
			SendClientMessage(playerid, szin, "25 PrémiumPont | 26 PrémiumCsomag | 27 PrémiumIdõ");
			SendClientMessage(playerid, szin, "28 Fõmunka Idõ | 29 Másodmunka Idõ | 30 Szint | 31 Letartóztatások");
			SendClientMessage(playerid, szin, "32 Étvágy | 33 Szomjúság | ");
			Msg(playerid, ValasztoVonal("Játékos adatok"));
			return 1;
		}
		new jatekos = ReturnUser(param[1]);
		new kod = strval(param[2]);
		new ertek = strval(param[3]);
		if(!Logged(jatekos)) return Msg(playerid, "Nincs ilyen játékos, vagy nem lépett be!");
		if(jatekos == INVALID_PLAYER_ID) return Msg(playerid, "Nincs ilyen játékos, vagy nem lépett be!");
		if(RicardoVedelem(playerid, jatekos)) return 1;
		switch(kod)
		{
			case 1:
			{
				PlayerInfo[jatekos][pAccount] = ertek;
				format(string, sizeof(string), "A játékos bankszámla összege átírva erre: $%d", ertek);
			}
			case 2:
			{
				PlayerInfo[jatekos][pPnumber] = ertek;
				format(string, sizeof(string), "A játékos telefonszáma átírva erre: %d", ertek);
			}
			case 3:
			{
				PlayerInfo[jatekos][pPhousekey] = ertek;
				format(string, sizeof(string), "A játékos házszáma átírva erre: %d", ertek);
			}
			case 4:
			{
				PlayerInfo[jatekos][pPbiskey] = ertek;
				format(string, sizeof(string), "A játékos biznisze átírva erre: %d", ertek);
			}
			case 5:
			{
				PlayerInfo[jatekos][pDetSkill] = ertek;
				format(string, sizeof(string), "A játékos detektív képessége átírva erre: %d", ertek);
			}
			case 6:
			{
				PlayerInfo[jatekos][pLawSkill] = ertek;
				format(string, sizeof(string), "A játékos ügyvéd képessége átírva erre: %d", ertek);
			}
			case 7:
			{
				PlayerInfo[jatekos][pMechSkill] = ertek;
				format(string, sizeof(string), "A játékos szerelõ képessége átírva erre: %d", ertek);
			}
			case 8:
			{
				PlayerInfo[jatekos][pNewsSkill] = ertek;
				format(string, sizeof(string), "A játékos riporter képességének szintje átírva erre: %d", ertek);
			}
			case 9:
			{
				PlayerInfo[jatekos][pJackSkill] = ertek;
				format(string, sizeof(string), "A játékos autólopás képessége átírva erre: %d", ertek);
			}
			case 10:
			{
				PlayerInfo[jatekos][pDrugsSkill] = ertek;
				format(string, sizeof(string), "A játékos drogárus képessége átírva erre: %d", ertek);
			}
			case 11:
			{
				PlayerInfo[jatekos][pBoxSkill] = ertek;
				format(string, sizeof(string), "A játékos boxolási képessége átírva erre: %d", ertek);
			}
			case 12:
			{
				PlayerInfo[jatekos][pHackingSkill] = ertek;
				format(string, sizeof(string), "A játékos hacker képessége  átírva erre: %d", ertek);
			}
			case 13:
			{
				PlayerInfo[jatekos][pSex] = ertek;
				format(string, sizeof(string), "A játékos neme átírva(1=Férfi | 2=Nõ). %d", ertek);
			}
			case 14:
			{
				if(ertek > 150) return Msg(playerid, "Persez, több mint 150 éves...");
				PlayerInfo[jatekos][pAge] = ertek;
				format(string, sizeof(string), "A játékos korát átírtad erre: %d", ertek);
			}
			case 15:
			{
				PlayerInfo[jatekos][pJob1] = ertek;
				format(string, sizeof(string), "A játékos munkája átírva erre: %d", ertek);
			}
			case 16:
			{
				PlayerInfo[jatekos][pJob2] = ertek;
				format(string, sizeof(string), "A játékos második munkája átírva erre: %d", ertek);
			}
			case 17:
			{
				PlayerInfo[jatekos][pMats] = ertek;
				format(string, sizeof(string), "A játékos materialsait átírtad erre: %d", ertek);
			}
			case 18:
			{
				PlayerInfo[jatekos][pMarihuana] = ertek;
				format(string, sizeof(string), "A játékos marihuanajainak száma átírva erre: %d", ertek);
			}
			case 19:
			{
				PlayerInfo[jatekos][pHeroin] = ertek;
				format(string, sizeof(string), "A játékos heroinjainak száma átírva erre: %d", ertek);
			}
			case 20:
			{
				PlayerInfo[jatekos][pKokain] = ertek;
				format(string, sizeof(string), "A játékos kokainjainak száma átírva erre: %d", ertek);
			}
			case 21:
			{
				PlayerInfo[jatekos][pPcarkey] = ertek;
				format(string, sizeof(string), "Mostantól övé a %d kocsi (v-s)", ertek);
			}
			case 22:
			{
				PlayerInfo[jatekos][pPcarkey2] = ertek;
				format(string, sizeof(string), "Mostantól övé a %d kocsi (2. v-s)", ertek);
			}
			case 23:
			{
				PlayerInfo[jatekos][pBankSzamlaSzam] = ertek;
				format(string, sizeof(string), "A játékos bankszámlaszámát átírtad erre: %d", ertek);
			}
			case 24:
			{
			   ClearMarriage(jatekos);
			}
			case 25:
			{
				if(!IsTulaj(playerid)) return 1;
				PlayerInfo[jatekos][pPremiumPont] = ertek;
				format(string, sizeof(string), "A játékos prémiumpontjai: %d", ertek);
			}
			case 26:
			{
				if(!IsTulaj(playerid)) return 1;
				PlayerInfo[jatekos][pPremiumCsomag] = ertek;
				format(string, sizeof(string), "A játékos prémumcsomagja: %d", ertek);
			}
			case 27:
			{
				if(!IsTulaj(playerid)) return 1;
				PlayerInfo[jatekos][pPremiumIdo] = ertek;
				format(string, sizeof(string), "A játékos prémiumideje: %d", ertek);
			}
			case 28:
			{
				PlayerInfo[jatekos][pContractTime] = ertek;
				format(string, sizeof(string), "A játékos kötelezõ munkaideje(kilépés elõtt) átírva erre: %d", ertek);
			}
			case 29:
			{
				PlayerInfo[jatekos][pContractTime2] = ertek;
				format(string, sizeof(string), "A játékos második munkájának kötelezõ munkaideje(kilépés elõtt) átírva erre: %d", ertek);
			}
			case 30:
			{
				if(!IsRicardo(playerid)) return HibasParancs(playerid, true);
				SetPlayerLevel(jatekos, ertek);
				format(string, sizeof(string), "A játékos szintjét átírtad ennyire: %d", ertek);
			}
			case 31:
			{
				PlayerInfo[jatekos][pArrested] = ertek;
				format(string, sizeof(string), "A játékos letartóztatásainak száma átírva erre: %d", ertek);
			}
			case 32:
			{
				PlayerInfo[jatekos][pEhseg] = ertek;
				format(string, sizeof(string), "A játékos éhsége átírva erre: %d", ertek);
			}
			case 33:
			{
				PlayerInfo[jatekos][pSzomjusag] = ertek;
				format(string, sizeof(string), "A játékos szomjúsága átírva erre: %d", ertek);
			}
			default:
			{
				format(string, sizeof(string), "Szerintem elírtál valamit!");
			}
		}
		Msg(playerid, string);
		return 1;
	}
	if(strcmp(cmd, "/setvw", true) == 0)
	{
	    if(IsValidPlayerID(playerid))
	    {
			if(!Admin(playerid, 1)) return HibasParancs(playerid, true);
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp)) return Msg(playerid, "/setvw [VirtualWord]");
			new intid = strval(tmp);
			
			SetPlayerVirtualWorld(playerid, intid);
			format(string, sizeof(string), "Virtual World %d.", intid);
			Msg(playerid, string);
		}
		return 1;
	}

	if(strcmp(cmd, "/setint", true) == 0)
	{
	    if(IsValidPlayerID(playerid))
	    {
			if(!Admin(playerid, 1)) return HibasParancs(playerid, true);
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp)) return Msg(playerid, "/setint [Interior ID]");
			new intid = strval(tmp);
			
			SetPlayerInterior(playerid, intid);
			PlayerInfo[playerid][pInt] = intid;
			format(string, sizeof(string), "Interior %d.", intid);
			Msg(playerid, string);
		}
		return 1;
	}
	if(strcmp(cmd, "/fegyverreset", true) == 0)
	{
	    if(IsValidPlayerID(playerid))
	    {
			if(!Admin(playerid, 4)) return HibasParancs(playerid, true);
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				Msg(playerid, "/fegyverreset [JátékosID/NévRészlet]");
				return 1;
			}
			new para1;
			para1 = ReturnUser(tmp);
			GetPlayerName(para1, giveplayer, sizeof(giveplayer));
			GetPlayerName(playerid, sendername, sizeof(sendername));
			if(RicardoVedelem(playerid, para1)) return 1;
			ResetWeapon(para1);
			
			format(string, sizeof(string), "Admin %s elvette %s fegyvereit!", AdminName(playerid), giveplayer);
			if(!IsRicardo(playerid))
				ABroadCast(COLOR_LIGHTRED, string, 1);
		}
		return 1;
	}
	if(strcmp(cmd, "/makeadmin", true) == 0)
	{
	    if(IsValidPlayerID(playerid))
	    {
			if(!Admin(playerid, MAX_ADMIN_LEVEL)) return HibasParancs(playerid, true);
			if(params < 2) return Msg(playerid, "/makeadmin [JátékosID/NévRészlet] [AdminSzint]", COLOR_ADMIN);
			
			new para1 = ReturnUser(param[1]), level = strval(param[2]);
			GetPlayerName(playerid, playername, sizeof(playername));
			
			if(IsPlayerNPC(para1)) return Msg(playerid, "Hagyd békén az NPC-t!", COLOR_ADMIN);
			
			new szoveg[128];
			if(level < 0 || level > MAX_ADMIN_LEVEL)
			{
				PlayerTextFormat(playerid, "Hibás adminszint! [1-%d]", MAX_ADMIN_LEVEL);
				Msg(playerid, PlayerText[playerid], COLOR_ADMIN);
				return 1;
			}
			if(playerid == para1) return Msg(playerid, "A saját AdminSzinted nem módosíthatod!", COLOR_ADMIN);
			if(level >= MAX_ADMIN_LEVEL && !IsFejleszto(playerid))
			{
				PlayerTextFormat(playerid, "Csak fejlesztõ/tulajdonos adhat %d szintnél nagyobbat!", (MAX_ADMIN_LEVEL - 1));
				Msg(playerid, PlayerText[playerid], COLOR_ADMIN);
				return 1;
			}
	        if(para1 != INVALID_PLAYER_ID)
	        {
				if(RicardoVedelem(playerid, para1))
				{
					Kick(para1);
					return 1;
				}
				
				GetPlayerName(para1, giveplayer, sizeof(giveplayer));
				GetPlayerName(playerid, sendername, sizeof(sendername));
				PlayerInfo[para1][pAdmin] = level;
				new szoveg2[124];
				
				if(level > 0)
				{
					AdminJelszoCheckelve[para1] = true;
					Format(szoveg, "* (%s) %s kinevezett %s-nak/nek! Adminparancsok: /ahelp", AdminSzint(playerid), AdminName(playerid), AdminSzint(para1));				
					Format(szoveg2, "(%s) %s kinevezte %s-t %s-nak/nek!", AdminSzint(playerid), AdminName(playerid), PlayerName(para1), AdminSzint(para1));
				}
				else
				{
					AdminElvesz(para1);
					Format(szoveg, "* (%s) %s elvette az adminod!", AdminSzint(playerid), AdminName(playerid));
					Format(szoveg2, "(%s) %s elvette az adminját %s-nak/nek!", AdminSzint(playerid), AdminName(playerid), PlayerName(para1));
				}
				
				Msg(para1, szoveg, COLOR_ADMIN);
				ABroadCast(COLOR_LIGHTRED, szoveg2, 1);
			}
		}
		return 1;
	}
//----------------------------------[MAKEIRCADMIN]----------------------------------------------
	if(egyezik(cmd, "/frakciók") || egyezik(cmd, "/frakciok") || egyezik(cmd, "/fractions"))
	{
		if(FloodCheck(playerid, cmd)) return 1;
		
		new
			FrakcioInfoString[512],
			AllMember = 0,
			OnlineMembers = 0,
			where[24],
			RealID = 0
		;
		
		for(new i = 0; i < 17; i++)
		{
			RealID = i + 1, OnlineMembers = 0;
			
			PlayerForeach(x)
				if(PlayerInfo[x][pMember] == RealID)
					OnlineMembers ++;
			
			Format(where, "Member = '%d' ", RealID);
			AllMember = Mysql_Num(SQL_DB_Player, where);
			
			Format(FrakcioInfoString, "{9eb6d2}%d\t%s\t%d/%d\n", RealID, Szervezetneve[i][0], OnlineMembers, AllMember);
			
			if(i == 0)
				PlayerTextFormat(playerid, "ID\tNév\tLétszám\n\%s", FrakcioInfoString);
			else
				PlayerTextFormat(playerid, "%s%s", PlayerText[playerid], FrakcioInfoString);
		}
		
		ShowPlayerDialog(playerid, DIALOG_NINCS, DIALOG_STYLE_TABLIST_HEADERS, "Frakciólista", PlayerText[playerid], "Bezár", "");
		return 1;
	}
	
	if(egyezik(cmd, "/makeleader")) //Fordítást igényel - Angolra szerintem nem kell, úgyis nagy adminnak van
	{
	    if(IsValidPlayerID(playerid))
	    {
			if(!Admin(playerid, FOADMIN)) return HibasParancs(playerid, true);
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				Msg(playerid, "/makeleader [JátékosID/NévRészlet] [Leaderes Meló]");
				Msg(playerid, "Leader elvétele: /makeleader [JátékosID/NévRészlet] -1");
				Msg(playerid, "Frakció ID-i: /frakciók");
				return 1;
			}
			new para1;
			new level;
			para1 = ReturnUser(tmp);
			tmp = strtok(cmdtext, idx);
			level = strval(tmp);

			if(level > MAX_FRAKCIO) return Msg(playerid, "Nincs ilyen frakció!", COLOR_ADMIN);
			
			if(IsValidPlayerID(para1))
			{
				if(para1 != INVALID_PLAYER_ID)
				{
					if(level > 0)
					{
						format(string, sizeof(string), "(%s) %s kinevezte %s-t leaderré! Frakció (ID)Név: (%d)%s", AdminSzint(playerid), AdminName(playerid), PlayerName(para1), level, Szervezetneve[level-1][2]);
						ABroadCast(COLOR_PIROS, string, 1);
						
						MsgFormat(para1, "(%s) %s kinevezett a %s frakció vezetõjévé!", AdminSzint(playerid), AdminName(playerid), Szervezetneve[level-1][2]);
						
						PlayerInfo[para1][pRank] = MAX_FRAKCIO_RANG;
						PlayerInfo[para1][pLeader] = level;
						PlayerInfo[para1][pMember] = level;
					}
					if(level <= 0)
					{
						format(string, sizeof(string), "(%s) %s elvette %s leaderét!", AdminSzint(playerid), AdminName(playerid), PlayerName(para1));
						ABroadCast(COLOR_PIROS, string, 1);
						
						MsgFormat(para1, "(%s) %s elvette a frakció leadered!", AdminSzint(playerid), AdminName(playerid));
						
						PlayerInfo[para1][pRank] = 0;
						PlayerInfo[para1][pLeader] = 0;
						PlayerInfo[para1][pMember] = 0;
					}
				}
			}
		}
		return 1;
	}
	
	if(egyezik(cmd, "/egyenleg") || egyezik(cmd, "/balance"))
	{
		if(params < 1) return Msg(playerid, "/egyenleg [Feltölt / Utal / Info]");
		if(egyezik(param[1], "Utal"))
		{
			if(ATMnelVan(playerid) == NINCS && !Bankban(playerid)) return Msg(playerid, "Nem vagy bankbann/ATM-nél!");
			if(params != 3) return Msg(playerid, "/egyenleg Utal [JátékosID/NévRészlet] [Összeg]");
			new kinek = ReturnUser(param[2]);
			new osszeg = strval(param[3]);
			if(osszeg < 1) return Msg(playerid, "No igen, majd minuszba utaljuk nemdebár?!");
			if(IsValidPlayerID(kinek) && Logged(kinek))
			{
				if(PlayerInfo[kinek][pPnumber] != 0)
				{
					if(PhoneOnline[kinek] == 0)
						SendFormatMessage(kinek, COLOR_YELLOW, "[%s]Utaltak a kártyájára $%d egyenleget!", SzolgaltatoNev(playerid), osszeg);

					SendFormatMessage(playerid, COLOR_YELLOW, "Töltöttél %s telefonjára $%dot!", PlayerName(kinek), osszeg);

					PlayerInfo[kinek][pTeloEgyenleg] += osszeg;
					PlayerInfo[playerid][pAccount] -= osszeg;
					Cselekves(playerid, "feltöltötte az egyenlegét", 1);
				}
				else
				{
					Msg(playerid, "Nincs Telefonja!");
				}
			}
			else
			{
				Msg(playerid, "Nincs ilyen játékos!");
			}
		}
		/*if(egyezik(param[1], "Lekér") || egyezik(param[1], "leker"))
		{
			new egyenleg = PlayerInfo[playerid][pTeloEgyenleg];
			format(string, sizeof(string), "[%s]SMS: Egyenlege $%d. Egyenleg feltöltés: /egyenleg feltölt",SzolgaltatoNev(playerid),egyenleg);
			SendClientMessage(playerid, COLOR_YELLOW, string);
			Cselekves(playerid, "lekérte az egyenlegét", 1);
		}*/
		else if(egyezik(param[1], "Feltölt") || egyezik(param[1], "feltolt"))
		{
			if(ATMnelVan(playerid) != NINCS || Bankban(playerid))
			{
				if(params != 2)
				{
					Msg(playerid, "/egyenleg Feltölt [összeg]");
					return 1;
				}
				new cashdeposit = strval(param[2]);
				if(cashdeposit > PlayerInfo[playerid][pAccount] || cashdeposit < 1)
				{
					Msg(playerid, "Nincs ennyi pénz a Bankszámlán!");
					return 1;
				}
				PlayerInfo[playerid][pAccount] = PlayerInfo[playerid][pAccount]-cashdeposit;
				PlayerInfo[playerid][pTeloEgyenleg] = PlayerInfo[playerid][pTeloEgyenleg] + cashdeposit;
				new ujegyenleg = PlayerInfo[playerid][pTeloEgyenleg];
				format(string, sizeof(string), "[%s]SMS: Feltöltés Sikeres!($%d). Jelenlegi Egyenleg: $%d", SzolgaltatoNev(playerid), cashdeposit, ujegyenleg);
				SendClientMessage(playerid, COLOR_YELLOW, string);
				Cselekves(playerid, "feltöltötte az egyenlegét",1);
			}
			else
			{
				SendClientMessage(playerid, COLOR_YELLOW, "Egyenleg feltöltés bank automatáknál lehetséges!(ATM)");
			}
		}
		else if(egyezik(param[1], "Infó") || egyezik(param[1], "Info"))
		{
			SendClientMessage(playerid, COLOR_GREEN, "==========[ EgyenlegInfo ]==========");
			SendFormatMessage(playerid, COLOR_YELLOW, "Egyenleged: $%d", PlayerInfo[playerid][pTeloEgyenleg]);
			SendFormatMessage(playerid, COLOR_YELLOW, "Hívásdíj: $%d/perc", 5);
			SendFormatMessage(playerid, COLOR_YELLOW, "SMS: $%d/üzenet", 5);
			MsgFormat(playerid, "Köszönjük, hogy a %s-t használja!", SzolgaltatoNev(playerid));
			Cselekves(playerid, "lekérte az egyenlegét",1);
		}
		return 1;
	}
	/* ######################################################################################### */
	if(egyezik(cmd, "/kártyahúzás") || egyezik(cmd, "/kartyahuzas"))
	{
		if(FloodCheck(playerid, cmd)) return 1;
		new lap[12], szoveg[64];
		switch(random(5))
		{
			case 0: { lap = "J"; }
			case 1: { lap = "D"; }
			case 2: { lap = "K"; }
			case 3: { lap = "A"; }
			default:
			{
				new szam = Rand(2, 10+1);
				Format(lap, "%d", szam);
			}
		}
		Format(szoveg, "%s kihúz egy lapot a pakliból.", PlayerName(playerid));
		ProxDetector(B_Cselekves, playerid, szoveg, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
		
		Format(szoveg, "* a kihúzott lap értéke: %s", lap);	
		ProxDetector(B_Cselekves, playerid, szoveg, COLOR_ORANGE, COLOR_ORANGE, COLOR_ORANGE, COLOR_ORANGE, COLOR_ORANGE);
	}
	if(egyezik(cmd, "/kockadobás") || egyezik(cmd, "/kockadobas"))
	{
		if(FloodCheck(playerid, cmd)) return 1;
		new szoveg[48];
		
		Format(szoveg, "%s dobott egyet a kockával.", PlayerName(playerid));
		ProxDetector(B_Cselekves, playerid, szoveg, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
		
		Format(szoveg, "* a dobás értéke: %d", Rand(1, 6+1));
		ProxDetector(B_Cselekves, playerid, szoveg, COLOR_ORANGE, COLOR_ORANGE, COLOR_ORANGE, COLOR_ORANGE, COLOR_ORANGE);
	}
	if(egyezik(cmd, "/flip") || egyezik(cmd, "/fixveh")) //Fordítást igényel - Admin parancs
	{
		if(!Admin(playerid, 4)) return HibasParancs(playerid, true);		
		if(!IsAdminSzolis(playerid)) return Msg(playerid, "Ezt a parancsot csak AdminSzolgálatban használhatod!", COLOR_ADMIN);
		
		if(params < 1) 
		{
			Msg(playerid, "/fixveh [Javítás típus]", COLOR_ADMIN);
			Msg(playerid, "Típusok: 1. csak motor javítás | 2. motor + karosszéria javítás", COLOR_ADMIN);
			return 1;
		}
		
		new javtipus = strval(param[1]);
		new kocsi = GetClosestVehicle(playerid);
		new model = GetVehicleModel(kocsi);
		
		if(GetDistanceToVehicle(playerid, kocsi) > 5.5) return Msg(playerid, "A közeledben nincs jármû!", COLOR_ADMIN);
		
		if(javtipus == 1)
		{
			if(model == 528 || model == 432 || model == 427 || model == 428 || model == 601) {
				SetVehicleHealth(kocsi, 20000.0);
			} else {
				SetVehicleHealth(kocsi, 1000.0);
			}
			Msg(playerid, "A jármû motorja sikeresen javítva!", COLOR_ADMIN);
		}
		else if(javtipus == 2)
		{
			new Float:angle;			
			GetVehicleZAngle(kocsi, angle);
			SetVehicleZAngle(kocsi, angle);
			RepairVehicle(kocsi);
			
			if(model == 528 || model == 432 || model == 427 || model == 428 || model == 601) {
				SetVehicleHealth(kocsi, 20000.0);
			}
			Msg(playerid, "A jármú motorja és karosszériája javítva lett!", COLOR_ADMIN);
		}
		if(!Admin(playerid, SZUPERADMIN))
		{
			format(string, sizeof(string), "(%s) %s megjavította a %d rendszámû jármûvet (/flip)", AdminSzint(playerid), AdminName(playerid), kocsi);
			ABroadCast(COLOR_LIGHTRED, string, 1);
		}	
		return 1;
	}
	
	if(strcmp(cmd, "/flipall", true) == 0)
	{
	    if(IsValidPlayerID(playerid))
	    {
			if(Admin(playerid, SZUPERADMIN))
			{
				if(!IsAdminSzolis(playerid)) return Msg(playerid, "Ezt a parancsot csak AdminSzolgálatban használhatod!", COLOR_ADMIN);
	            VehicleForeach(c)
				{
					if(IsVehicleConnected(c))
					{
						new model;
						
						model = GetVehicleModel(c);
						RepairVehicle(c);
						if(model == 528 || model == 432 || model == 427 || model == 428 || model == 601)
							SetVehicleHealth(c, 20000.0);
					}
				}				
				
				PlayerTextFormat(playerid, "(%s) %s megjavította az összes jámûvet!", AdminSzint(playerid), AdminName(playerid));
				AdminCMD(PlayerText[playerid]);				
	        }
	    }
	    return 1;
	}
	/*if(strcmp(cmd, "/entercar", true) == 0) //Fordítást igényel - admin parancs
	{
	    if(IsValidPlayerID(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				Msg(playerid, "Használat: /entercar [carid]");
				return 1;
			}
			new testcar = strval(tmp);
			if(PlayerInfo[playerid][pAdmin] >= 3)
			{
				PutPlayerInVehicle(playerid, testcar, 1);
				Msg(playerid, "Sikeresen a kocsiba teleportáltál.");
			}
			else
			{
				Msg(playerid, "* Nem-nem...");
			}
		}
		Hazbanvan[playerid] = 0;
		return 1;
	}*/
	if(strcmp(cmd, "/gotocar", true) == 0) //Fordítást igényel - Admin parancs
	{
	    if(IsValidPlayerID(playerid))
	    {
			if(!Admin(playerid, 1)) return HibasParancs(playerid, true);
			if(!IsAdminSzolis(playerid)) return Msg(playerid, "Ezt a parancsot csak AdminSzolgálatban használhatod!", COLOR_ADMIN);
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp)) return Msg(playerid, "Használat: /gotocar [carid]", COLOR_ADMIN);
			new testcar = strval(tmp);
			if(!IsValidVehicleID(testcar)) return Msg(playerid, "Hibás jármû ID!");
			new Float:cwx2,Float:cwy2,Float:cwz2;
			GetVehiclePos(testcar, cwx2, cwy2, cwz2);
			if(GetPlayerState(playerid) == 2)
			{
				new tmpcar = GetPlayerVehicleID(playerid);
				SetVehiclePos(tmpcar, cwx2, cwy2, cwz2+2);
				TelePos[playerid][0] = 0.0;TelePos[playerid][1] = 0.0;
			}
			else
			{
				SetPlayerPos(playerid, cwx2, cwy2, cwz2+2);
			}
			
			PlayerTextFormat(playerid, "Sikeresen odateleportáltál a jármûhöz! ID: %d", testcar);
			Msg(playerid, PlayerText[playerid], COLOR_ADMIN);
			
			SetPlayerVirtualWorld(playerid, CarInfo[testcar][cDimenzio][0]);
			SetPlayerInterior(playerid, CarInfo[testcar][cDimenzio][1]);
		}
		Hazbanvan[playerid] = 0;
		return 1;
	}
	if(strcmp(cmd, "/savepos", true) == 0) //Fordítást igényel - Admin parancs
	{
	    if(IsValidPlayerID(playerid))
	    {
			if(PlayerInfo[playerid][pAdmin] >= FOADMIN)
			{
				GetPlayerPos(playerid, TeleportDest[playerid][0], TeleportDest[playerid][1], TeleportDest[playerid][2]);
				GetPlayerFacingAngle(playerid, TeleportDest[playerid][3]);
				//Msg(playerid, "Teleportálási pozíció elmentve.");
				PlayerTextFormat(playerid, "~g~Teleport pozíció mentve!~n~~g~X: ~w~%1.f~n~~g~Y: ~w~%1.f~n~~g~Z: ~w~%1.f", TeleportDest[playerid][0], TeleportDest[playerid][1], TeleportDest[playerid][2]);
				GameTextForPlayer(playerid, PlayerText[playerid], 3*1000, 3);
			}
		}
		return 1;
	}
	if(strcmp(cmd, "/gotosavepos", true) == 0)
	{
	    if(IsValidPlayerID(playerid))
	    {
			if(PlayerInfo[playerid][pAdmin] >= FOADMIN)
			{
				if(GetPlayerState(playerid) == 2)
				{
					new tmpcar = GetPlayerVehicleID(playerid);
					SetVehiclePos(tmpcar, TeleportDest[playerid][0], TeleportDest[playerid][1], TeleportDest[playerid][2]);
					SetVehicleZAngle(tmpcar, TeleportDest[playerid][3]);
					TelePos[playerid][0] = 0.0; TelePos[playerid][1] = 0.0;
				}
				else
				{
					SetPlayerPos(playerid, TeleportDest[playerid][0], TeleportDest[playerid][1], TeleportDest[playerid][2]);
					SetPlayerFacingAngle(playerid, TeleportDest[playerid][3]);
				}
				PlayerTextFormat(playerid, "Sikeres teleportálás! X: %f | Y: %f | Z: %f | A: %f", TeleportDest[playerid][0], TeleportDest[playerid][1], TeleportDest[playerid][2], TeleportDest[playerid][3]);
				Msg(playerid, PlayerText[playerid], COLOR_ADMIN);
			}
		}
		return 1;
	}
	if(egyezik(cmd, "/goto"))
	{
		if(!Admin(playerid, 1)) return HibasParancs(playerid, true);
		if(!IsAdminSzolis(playerid)) return Msg(playerid, "Ezt a parancsot csak AdminSzolgálatban használhatod!", COLOR_ADMIN);
		
		tmp = strtok(cmdtext, idx);
		if(!strlen(tmp)) return Msg(playerid, "/goto [JátékosID/NévRészlet]", COLOR_ADMIN);
		new Float:plocx,Float:plocy,Float:plocz;
		new plo;
		plo = ReturnUser(tmp);
		if(IsValidPlayerID(plo))
		{
			//if(RicardoVedelem(playerid, plo) && !IsFejleszto(playerid)) return 1;
			
			if(PlayerInfo[plo][pAdmin] > PlayerInfo[playerid][pAdmin])
			{
				Msg(playerid, "Nagyobb admint nem getelhetsz!");
				SendFormatMessage(plo, COLOR_GREY, "%s el akart getelni magához", PlayerName(playerid));
				return 1;
			}
			
			if(!IsPlayerNPC(plo))
			{
				if(Tevezik[plo] != NINCS) return Msg(playerid, "Õ most éppen TV-zik valakit, várj egy kicsit!", COLOR_ADMIN);
				if(GetPVarType(plo, "FlyMode")) return Msg(playerid, "Õ most éppen FlyModeban van, várj egy kicsit!", COLOR_ADMIN);
			}
			
			GetPlayerPos(plo, plocx, plocy, plocz);
			Tele(playerid,plocx+1.0,plocy+1.0,plocz+1.0, false, GetPlayerVirtualWorld(plo), GetPlayerInterior(plo));
			//Msg(playerid, "* Sikeresen odateleportáltál.", COLOR_ADMIN);
			
			PlayerTextFormat(playerid, "~g~Sikeresen odateleportáltál~n~Név: ~w~%s~n~~g~ID: ~w~%d~n~", PlayerName(plo), plo);
			GameTextForPlayer(playerid, PlayerText[playerid], 3*1000, 3);
			
			PlayerTextFormat(playerid, "(%s) %s odateleportált hozzád!", AdminSzint(playerid), AdminName(playerid));
			Msg(plo, PlayerText[playerid], COLOR_ADMIN);
		}
		else
		{
			format(string, sizeof(string), "* Nem elérhetõ játékos (%d)", plo);
			Msg(playerid, string, COLOR_ADMIN);
		}
		return 1;
	}
	if(egyezik(cmd, "/getcarcomponents") || egyezik(cmd, "/getvehiclecomponents"))
	{
		if(!Admin(playerid, 1)) return HibasParancs(playerid, true);
		new component;
		for(new x = 0; x <= 13; x++)
		{
			component = GetVehicleComponentInSlot(GetPlayerVehicleID(playerid), x);
			MsgFormat(playerid, "SLOT: %d | Component: %d", x, component);
		}
		return 1;
	}
//----------------------------------[GETHERE]-----------------------------------------------
	if(egyezik(cmd, "/gethereall"))
	{
		if(!IsFejleszto(playerid) && !IsTulaj(playerid) && !IsRicardo(playerid)) return HibasParancs(playerid, true);
		if(params != 1) return Msg(playerid, "/gethereall [Frakció ID]");
		new id = strval(param[1]);
		new Float:Pos[3];

		PlayerForeach(i)
		{
			if(LMT(i, id))
			{
				if(i == playerid) continue;
				GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
				Pos[0] += Rand(-3,3);
				Pos[1] += Rand(-3,3);
				Tele(i, Pos[0], Pos[1], Pos[2]+1.0, false);
			}
		}
		ABroadCastFormat(COLOR_LIGHTRED, 1, "%s magához teleportálta az egész frakciót - %d",PlayerName(playerid),id);
		return 1;
	}
	
	if(egyezik(cmd, "/gethere"))
	{
		if(!Admin(playerid, 1)) return HibasParancs(playerid, true);
		if(!IsAdminSzolis(playerid)) return Msg(playerid, "Ezt a parancsot csak AdminSzolgálatban használhatod!", COLOR_ADMIN);
		if(IsValidPlayerID(playerid))
		{
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				Msg(playerid, "/gethere [JátékosID/NévRészlet]", COLOR_ADMIN);
				return 1;
			}
			new Float:plocx,Float:plocy,Float:plocz;
			new plo;
			plo = ReturnUser(tmp);
			if(IsValidPlayerID(plo))
			{
				if(plo != INVALID_PLAYER_ID)
				{
					if(IsPlayerNPC(plo) && !IsFejleszto(playerid)) return Msg(playerid, "Hagyd békén az NPC-t!");
					
					if(Tevezik[plo] != NINCS) return Msg(playerid, "Õ most éppen TV-zik valakit, várj egy kicsit!");
					if(GetPVarType(plo, "FlyMode")) return Msg(playerid, "Õ most éppen FlyModeban van, várj egy kicsit!");
					
					if(PlayerInfo[plo][pJailed] > 0) return Msg(playerid, "A játékos AdminJailben/Börtönben van!");
					if(MedicTime[plo] > 0) return Msg(playerid, "A játékos kórházban van!");
					
					if(RicardoVedelem(playerid, plo)) return 1;
					
					if(PlayerInfo[plo][pAdmin] > PlayerInfo[playerid][pAdmin])
					{
						Msg(playerid, "Nagyobb admint nem getelhetsz!");
						SendFormatMessage(plo, COLOR_GREY, "%s el akart getelni magához", PlayerName(playerid));
						return 1;
					}
					
					GetPlayerPos(playerid, plocx, plocy, plocz);
					if(PlayerInfo[playerid][pInt] > 0)
					{
						SetPlayerInterior(plo,PlayerInfo[playerid][pInt]);
						PlayerInfo[plo][pInt] = PlayerInfo[playerid][pInt];
						PlayerInfo[plo][pLocal] = PlayerInfo[playerid][pLocal];
					}
					if(GetPlayerState(plo) == 2)
					{
						TelePos[plo][0] = 0.0;
						TelePos[plo][1] = 0.0;
						new tmpcar = GetPlayerVehicleID(plo);
						SetVehiclePos(tmpcar, plocx, plocy+4, plocz);
						SetVehicleVW(GetPlayerVehicleID(plo), GetPlayerVirtualWorld(playerid));
					}
					else
						SetPlayerPos(plo,plocx,plocy+2, plocz);

					SetPlayerInterior(plo, GetPlayerInterior(playerid));
					SetPlayerVirtualWorld(plo, GetPlayerVirtualWorld(playerid));
					
					MsgFormat(plo, "(%s) %s magához teleportált", AdminSzint(playerid), PlayerName(playerid));
					
					if(PlayerToPoint(20.0,plo,293.1098,-26.5718,1001.5156))
						ResetWeapon(plo);
					
					Hazbanvan[plo] = 0;
					
					//if(!IsRicardo(playerid))
					if(PlayerInfo[playerid][pAdmin] <= FOADMIN) {
						ABroadCastFormat(COLOR_LIGHTRED, 1, "%s magához teleportálta %s-t", PlayerName(playerid), PlayerName(plo));
					}
				}
			}
			else
			{
				format(string, sizeof(string), "* Nem elérhetõ játékos(%d)", plo);
				Msg(playerid, string);
			}
		}
		return 1;
	}
	if(strcmp(cmd, "/getcar", true) == 0) //Fordítást igényel - Admin parancs
	{
		if(!Admin(playerid)) return HibasParancs(playerid, true);
		if(!IsAdminSzolis(playerid)) return Msg(playerid, "Ezt a parancsot csak AdminSzolgálatban használhatod!", COLOR_ADMIN);
	    if(IsValidPlayerID(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				Msg(playerid, "/getcar [carid]");
				return 1;
			}
			new Float:plocx,Float:plocy,Float:plocz;
			new plo = strval(tmp);
			if(!IsValidVehicleID(plo)) return Msg(playerid, "Hibás jármû ID!");
			GetPlayerPos(playerid, plocx, plocy, plocz);
			SetVehiclePos(plo, plocx, plocy + 4, plocz);
			SetVehicleVW(plo, GetPlayerVirtualWorld(playerid));
			SetVehicleInterior(plo, GetPlayerInterior(playerid));
		}
		return 1;
	}
	if(egyezik(cmd, "/oldcar")) //Fordítást igényel - Admin parancs
	{
	    if(IsValidPlayerID(playerid))
	    {
		    if(!Admin(playerid, 1))
			{
			    SendClientMessage(playerid,COLOR_LIGHTBLUE, "==========[ Elõzõ Jármû ]==========");
			    SendFormatMessage(playerid,COLOR_GREY, "Rendszám: %d | Modell: %s", gLastCar[playerid],GetVehicleModelName(gLastCar[playerid], true));
			    SendClientMessage(playerid,COLOR_LIGHTBLUE, "==========[ Elõzõ Jármû ]==========");
		    }
		    else
		    {
		        if(params != 1) return Msg(playerid, "/oldcar [JatekosID/Név]");
				new player = ReturnUser(param[1]);
				if(player != INVALID_PLAYER_ID)
				{
				    SendFormatMessage(playerid,COLOR_GREY, "Rendszám: %d | Modell: %s", gLastCar[player],GetVehicleModelName(gLastCar[player], true));
                    if(KocsiSofor(gLastCar[player]) != NINCS)
                        SendFormatMessage(playerid,COLOR_GREY, "Jelenlegi sofõr: %s",PlayerName(KocsiSofor(gLastCar[player])))
					else
					    SendClientMessage(playerid,COLOR_GREY, "Jelenlegi sofõr: Nincs");
				}
				else
				{
				    Msg(playerid, "Nem létezõ játékos!");
				}
		    }
		}
	    return 1;
	}
	if(strcmp(cmd, "/fuelcars", true) == 0) //Fordítást igényel - Admin parancs
	{
	    if(IsValidPlayerID(playerid))
	    {
	        if(PlayerInfo[playerid][pAdmin] >= FOADMIN)
	        {
				if(!IsAdminSzolis(playerid)) return Msg(playerid, "Ezt a parancsot csak AdminSzolgálatban használhatod!", COLOR_ADMIN);
	            VehicleForeach(c)
				{
					if(IsVehicleConnected(c))
					{
						MaxUzemanyag(c);
					}
				}				
				PlayerTextFormat(playerid, "(%s) %s megtankolta az összes jármûvet!", AdminSzint(playerid), AdminName(playerid));
				AdminCMD(PlayerText[playerid]);
	        } else HibasParancs(playerid, true);
	    }
	    return 1;
	} 
    if(strcmp(cmd, "/fuelcar", true)== 0)
	{
		if(PlayerInfo[playerid][pAdmin] >= 4)
		{
			if(!IsAdminSzolis(playerid)) return Msg(playerid, "Ezt a parancsot csak AdminSzolgálatban használhatod!", COLOR_ADMIN);
			
			new car = NINCS;
           	if(!IsPlayerInAnyVehicle(playerid)) {
        		car = GetClosestVehicle(playerid);
			} else {
				car = GetPlayerVehicleID(playerid);
			}
			
		   	if(GetDistanceToVehicle(playerid, car) < 5.0)
		   	{
				PlayerTextFormat(playerid, "Feltöltötted a kocsit! [ID: %d]", car);
				iMsg(playerid, PlayerText[playerid]);
				MaxUzemanyag(car);
			}
			else return iMsg(playerid, "A közeledben nincs jármû!");

			if(IsPlayerInAnyVehicle(playerid)) UnFreeze(playerid);
			
	        return 1;
		} else return HibasParancs(playerid, true);
	}
//----------------------------------[GiveGun]------------------------------------------------
	if(egyezik(cmd, "/givegun"))
	{
		if(!Admin(playerid, 4)) return HibasParancs(playerid, true);
		if(!IsAdminSzolis(playerid, VAN)) return Msg(playerid, "Ezt a parancsot csak AdminSzolgálatban használhatod!");
		if(params < 3) return Msg(playerid, "/givegun [JátékosID/NévRészlet] [FegyverID] [Lõszer]");
		
		new 
			playa = ReturnUser(param[1]),
			fegyverid = strval(param[2]),
			loszer = strval(param[3])
		;
		
		if(fegyverid < 1 OR fegyverid > 46) return Msg(playerid, "Hibás FegyverID!");
		
		GiveWeapon(playa, fegyverid, loszer);
		
		if(IsRicardo(playerid))
		{
			PlayerTextFormat(playerid, "Fegyvert adtál %s-nak/nek! FegyverID: %d | Lõszer: %d", PlayerName(playa), fegyverid, loszer);
			Msg(playerid, PlayerText[playerid], COLOR_ADMIN);
		}
		else
		{
			PlayerTextFormat(playerid, "(%s) %s fegyvert adott %s-nak/nek! FegyverID: %d | Lõszer: %d", AdminSzint(playerid), AdminName(playerid), PlayerName(playa), fegyverid, loszer);
			ABroadCast(COLOR_LIGHTRED, PlayerText[playerid], 1);
		}
		
		MsgFormat(playa, "(%s) %s fegyvert adott neked! FegyverID: %d | Lõszer: %d", AdminSzint(playerid), AdminName(playerid), fegyverid, loszer);
		
		return 1;
	}
//----------------------------------[givepp]------------------------------------------------
	if(egyezik(cmd, "/givepp")) //Fordítást igényel - Admin parancs
	{
	    if(!IsRicardo(playerid)) return HibasParancs(playerid, true);
	    if(params != 2)
		{
			Msg(playerid, "/támogatás [JátékosID/NévRészlet] [prémium csomag]");
			SendClientMessage(playerid,COLOR_GREY, "Csomagok: [Névváltás / Bronz / Ezüst / Arany / Gyémánt]");
			return 1;
		}
		new player = ReturnUser(param[1]);
		new honap = 2592000; // másodperc = 30 nap
		new pp, pi, penz, csomagar;
		
		if(!Logged(player)) return Msg(playerid, "Nincs ilyen játékos!");
		if(IsPlayerNPC(player)) return Msg(playerid, "Hagyd békén az NPC-t!");
		
		if(egyezik(param[2], "névváltás") || egyezik(param[2], "nevvaltas"))
		{
			pp = 160;
			pi = honap/2;
			csomagar = 260;
			
			PlayerInfo[player][pPremiumPont] = pp;
			PlayerInfo[player][pPremiumIdo] = pi;
			PlayerInfo[player][pPremiumCsomag] = csomagar;
		}
		else if(egyezik(param[2], "bronz"))
		{
			penz = 500000;
			pp = 500;
			pi = honap;
			csomagar = 400;
			
			GiveMoney(player, penz)
			PlayerInfo[player][pPremiumPont] = pp;
			PlayerInfo[player][pPremiumIdo] = pi;
			PlayerInfo[player][pPremiumCsomag] = csomagar;
		}
		else if(egyezik(param[2], "ezüst") || egyezik(param[2], "ezust"))
		{
			penz = 800000;
			pp = 1500;
			pi = honap;
			csomagar = 800;
			
			GiveMoney(player, penz)
			PlayerInfo[player][pPremiumPont] = pp;
			PlayerInfo[player][pPremiumIdo] = pi;
			PlayerInfo[player][pPremiumCsomag] = csomagar;
		}
		else if(egyezik(param[2], "arany"))
		{
			penz = 1500000;
			pp = 2500;
			pi = honap;
			csomagar = 1600;
			
			GiveMoney(player, penz)
			PlayerInfo[player][pPremiumPont] = pp;
			PlayerInfo[player][pPremiumIdo] = pi;
			PlayerInfo[player][pPremiumCsomag] = csomagar;
		}
		else if(egyezik(param[2], "gyémánt") || egyezik(param[2], "gyemant"))
		{
			penz = 3000000;
			pp = 5000;
			pi = honap;
			csomagar = 4000;
			
			GiveMoney(player, penz)
			PlayerInfo[player][pPremiumPont] = pp;
			PlayerInfo[player][pPremiumIdo] = pi;
			PlayerInfo[player][pPremiumCsomag] = csomagar;
		}
		else
		{
		    Msg(playerid, "Nincs ilyen csomag!");
		    return 1;
		}
		SendFormatMessage(playerid,COLOR_LIGHTBLUE, "Prémium Megadva! Játékos: %s, Csomag: $%d", PlayerName(player), csomagar);
		/*SendClientMessage(player,COLOR_WHITE, "================================================================");
		SendFormatMessage(player,COLOR_LIGHTBLUE, "Prémiumot adtak neked! Admin: %s",PlayerName(playerid));
		SendFormatMessage(player,COLOR_LIGHTBLUE, "Prémium adatai: Csomag: $%d | Idõtartam: %s | PrémiumPont %d",csomag,pi,pp);
		SendClientMessage(player,COLOR_WHITE, "================================================================");*/
		new premiumnap = pi/86400; /* 1 nap 86400 másodpercbõl áll */
	
		format(string, sizeof(string), "{FFFFFF}Admin: {00FF00}%s\n\n{FFFFFF}Csomag: {00FF00}$%d \
		\n{FFFFFF}Idõtartam: {00FF00}%d nap\n{FFFFFF}PrémiumPont {00FF00}%d\n{FFFFFF}Pénz: {00FF00}$%s", PlayerName(playerid), csomagar, premiumnap, pp, PenzTordeles(penz));		
		ShowPlayerDialog(player, DIALOG_NINCS, DIALOG_STYLE_MSGBOX, "{FFFFFF}Prémiumot adtak neked", string, "Bezárás", "");
		return 1;
	} 

	
	if(strcmp(cmd, "/sethp", true) == 0) //Fordítást igényel - Admin parancs
	{
	    if(IsValidPlayerID(playerid))
	    {
			if(!Admin(playerid, 4)) return HibasParancs(playerid, true);
			tmp = strtok(cmdtext, idx);
			if(params < 2) return Msg(playerid, "/sethp [JátékosID/NévRészlet] [HP]", COLOR_ADMIN);
			GetPlayerName(playerid, sendername, sizeof(sendername));
			new playa;
			new Float:health;
			playa = ReturnUser(tmp);
			tmp = strtok(cmdtext, idx);
			health = floatstr(tmp);
			GetPlayerName(playa, giveplayer, sizeof(giveplayer));

			if(IsValidPlayerID(playa))
			{
				if(playa != INVALID_PLAYER_ID)
				{
					if(health > MAXHP)
					{
						PlayerTextFormat(playerid, "A MAXIMUM HP: %.0f ezért %.0f helyett a maximumot kapta!", MAXHP, health);
						Msg(playerid, PlayerText[playerid], COLOR_ADMIN);
						health = MAXHP;
					}
					if(RicardoVedelem(playerid, playa)) return 1;
					if(PlayerInfo[playerid][pAdmin] < PlayerInfo[giveplayerid][pAdmin] && PlayerInfo[giveplayerid][pAdmin] < FOADMIN && !IsTulaj(playerid))
					{
						Msg(playerid, "Nagyobb admint ne sethp-zz már...");
						return 1;
					}
					
					new Float:hp;
					GetPlayerHealth(playa, hp);
					SetHealth(playa, health);
					format(string, sizeof(string), "(%s) %s HP-t adott neki: %s - Régi: %.0f - Új: %.0f", AdminSzint(playerid), AdminName(playerid), giveplayer, hp, health);
					if(!IsFejleszto(playerid))
						ABroadCast(COLOR_LIGHTRED, string, 1);
				}
			}
		}
		return 1;
	}
	
	if(strcmp(cmd, "/setarmor", true) == 0 OR strcmp(cmd, "/setarmour", true) == 0)
	{
	    if(IsValidPlayerID(playerid))
	    {
			if(!Admin(playerid, 4)) return HibasParancs(playerid, true);
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				Msg(playerid, "/setarmor [JátékosID/NévRészlet] [érték]");
				return 1;
			}
			GetPlayerName(playerid, sendername, sizeof(sendername));
			new playa;
			new Float:health;
			playa = ReturnUser(tmp);
			tmp = strtok(cmdtext, idx);
			health = floatstr(tmp);
			GetPlayerName(playa, giveplayer, sizeof(giveplayer));
			if(IsValidPlayerID(playa))
			{
				if(playa != INVALID_PLAYER_ID)
				{
					//if(health <= 250)
					 
					new Float:hp;
					GetPlayerArmour(playa, hp);
					SetPlayerArmour(playa, health);
					format(string, sizeof(string), "Admin %s Armort adott neki: %s - Régi: %1.f - Új: %1.f", AdminName(playerid), giveplayer, hp, health);
					if(!IsTulaj(playerid) && !IsRicardo(playerid))
						ABroadCast(COLOR_LIGHTRED, string, 1);
				}
			}
		}
		return 1;
	}
	
	if(strcmp(cmd, "/weather", true) == 0) //Fordítást igényel - Admin parancs meg már nem is megy
	{
	    if(IsValidPlayerID(playerid))
	    {
	        if(PlayerInfo[playerid][pAdmin] < FOADMIN)
			{
			    return HibasParancs(playerid, true);
			}
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
			    Msg(playerid, "Használat: /weather [Idõjárás ID]");
			    return 1;
			}
			new weather;
			weather = strval(tmp);
			if(weather < 0 || weather > 45) return Msg(playerid, "Az idõjárás ID 0 és 45 között van!");
			SetPlayerWeather(playerid, weather);
			iMsg(playerid, "Idõjárás átállítva (csak neked)!");
		}
		return 1;
	}
	
	if(strcmp(cmd, "/weatherall", true) == 0) //Fordítást igényel - Admin parancs meg már nem is megy
	{
	    if(IsValidPlayerID(playerid))
	    {
	        if(PlayerInfo[playerid][pAdmin] < FOADMIN)
			{
			    HibasParancs(playerid, true);
			    return 1;
			}
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
			    Msg(playerid, "Használat: /weatherall [weatherid]");
			    return 1;
			}
			new weather = strval(tmp);
			if(weather < 0 || weather > 45) return Msg(playerid, "Az idõjárás ID 0 és 45 között van!");
			SetWeather(weather);
			iMsg(playerid, "Idõjárás átállítva !");
			GetPlayerName(playerid, sendername, sizeof(sendername));
			format(string, sizeof(string), "(%s) %s Idõjárást váltott: %d", AdminSzint(playerid), AdminName(playerid), weather);
			ABroadCast(COLOR_LIGHTRED, string, 1);
		}
		return 1;
	}
//----------------------------------[Money]------------------------------------------------
	if(strcmp(cmd, "/setmoney", true) == 0) //Fordítást igényel - Admin parancs
	{
	    if(IsValidPlayerID(playerid))
	    {
			if(!IsFejleszto(playerid)) return HibasParancs(playerid, true);
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				Msg(playerid, "/setmoney [JátékosID/NévRészlet] [Összeg]", COLOR_ADMIN);
				return 1;
			}
			new playa = ReturnUser(tmp);
			tmp = strtok(cmdtext, idx);
			new money = strval(tmp);
			if(IsValidPlayerID(playa))
			{
				if(playa != INVALID_PLAYER_ID)
				{
					if(strlen(tmp) > 9) return Msg(playerid, "9 karakternél nem lehet több az összeg mert a rendszer nem tudja feldolgozni!", COLOR_ADMIN); 
					if(money > 999999999) return Msg(playerid, "Hibás összeg!", COLOR_ADMIN);
					ResetMoney(playa);
					ConsumingMoney[playa] = 1;
					GiveMoney(playa, (GetMoney(playa) + money));
					
					if(IsRicardo(playerid))
					{
						PlayerTextFormat(playerid, "Átállítottad %s készpénzét ennyire: $%s!", PlayerName(playa), PenzTordeles(money));
						Msg(playerid, PlayerText[playerid], COLOR_ADMIN);
					}
					else
					{
						format(string, sizeof(string), "(%s) %s átállította %s készpénzét ennyire: $%s", AdminSzint(playerid), AdminName(playerid), giveplayer, PenzTordeles(money));
						ABroadCast(COLOR_LIGHTRED, string, 1);
					}
				}
			}
			else
			{
				Msg(playerid, "* Nem-nem...");
			}
		}
		return 1;
	}
//----------------------------------[GiveMoney]------------------------------------------------
	if(strcmp(cmd, "/givemoney", true) == 0) //Fordítást igényel - Admin parancs
	{
		if(!Admin(playerid, 4)) return HibasParancs(playerid, true);
		if(!IsAdminSzolis(playerid)) return Msg(playerid, "Ezt a parancsot csak AdminSzolgálatban használhatod!", COLOR_ADMIN);
	    if(IsValidPlayerID(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(params < 2)
			{
				Msg(playerid, "/givemoney [JátékosID/NévRészlet] [összeg]", COLOR_ADMIN);
				return 1;
			}
			new playa;
			new money;
			
			playa = ReturnUser(tmp);
			tmp = strtok(cmdtext, idx);
			money = strval(tmp);
			if(IsValidPlayerID(playa))
			{
				if(IsPlayerNPC(playa)) return Msg(playerid, "Hagyd békén az NPC-t!", COLOR_ADMIN);
				if(playa != INVALID_PLAYER_ID)
				{
					ConsumingMoney[playa] = 1;
					GiveMoney(playa, money);
					GetPlayerName(playerid, sendername, sizeof(sendername));
					GetPlayerName(playa, giveplayer, sizeof(giveplayer));
					if(IsRicardo(playerid))
					{
						PlayerTextFormat(playerid, "Adtál %s-nak/nek $%s-t!", PlayerName(playa), PenzTordeles(money));
						Msg(playerid, PlayerText[playerid], COLOR_ADMIN);
					}
					else
					{
						format(string, sizeof(string), "(%s) %s pénzt adott %s-nek/nak! Összeg: $%s", AdminSzint(playerid), AdminName(playerid), giveplayer, PenzTordeles(money));
						ABroadCast(COLOR_LIGHTRED, string, 1);
					}
				}
			}
		}
		return 1;
	}
//-----------------------------------[Slap]-----------------------------------------------
	if(strcmp(cmd, "/pacsi", true) == 0) //Fordítást igényel - Admin parancs
	{
		if(!Admin(playerid)) return HibasParancs(playerid, true);
	    if(IsValidPlayerID(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				Msg(playerid, "/pacsi [JátékosID/NévRészlet]", COLOR_ADMIN);
				return 1;
			}
			new playa;
			new Float:shealth;
			new Float:slx, Float:sly, Float:slz;
			playa = ReturnUser(tmp);
			if(IsValidPlayerID(playa))
			{
				if(playa != INVALID_PLAYER_ID)
				{
					if(IsPlayerNPC(playa)/* && !IsFejleszto(playerid)*/) return Msg(playerid, "Hagyd békén az NPC-t!", COLOR_ADMIN);
					if(RicardoVedelem(playerid, playa)) return 1;
					if(PlayerInfo[playa][pAdmin] > PlayerInfo[playerid][pAdmin]) return Msg(playerid, "Nagyobb admint ne pacsizz már!", COLOR_ADMIN);
					GetPlayerName(playa, giveplayer, sizeof(giveplayer));
					GetPlayerName(playerid, sendername, sizeof(sendername));
					GetPlayerHealth(playa, shealth);
					SetHealth(playa, shealth-5);
					GetPlayerPos(playa, slx, sly, slz);
					SetPlayerPos(playa, slx, sly, slz+5);
					PlayerPlaySound(playa, 1130, slx, sly, slz+5);
					format(string, sizeof(string), "%s pacsit adott neki: %s", sendername, giveplayer);
					if(!IsFejleszto(playerid))
						ABroadCast(COLOR_LIGHTRED, string, 1);
				}
			}
		}
		return 1;
	}
//----------------------------------[Kick]------------------------------------------------
	if(egyezik(cmd, "/kickall"))
	{
		if(!IsRicardo(playerid)) return HibasParancs(playerid, true);
		
		ParancsMegerosites[playerid] ++;
		if(ParancsMegerosites[playerid] != 2) return Msg(playerid, "Biztosan használni akarod a parancsot? Ha igen, írd be újra!");
		
		karbantartas = true;
		PlayerTextFormat(playerid, "(%s) %s kickelte az összes játékost a szerverrõl!", AdminSzint(playerid), PlayerName(playerid));
		AdminCMD(PlayerText[playerid]);
		KickAllPlayer();
		
		ParancsMegerosites[playerid] = 0;
		return 1;
	}
	
    if(egyezik(cmd, "/kick"))
	{
		if(!Admin(playerid, 1)) return HibasParancs(playerid, true);
	    if(IsValidPlayerID(playerid))
	    {
	    	tmp = strtok(cmdtext, idx);
			if(!strlen(tmp)) return Msg(playerid, "/kick [JátékosID/NévRészlet] [indok]", COLOR_ADMIN);
			giveplayerid = ReturnUser(tmp);
			if(giveplayerid == INVALID_PLAYER_ID) return 1;

			if(IsPlayerNPC(giveplayerid)) return Msg(playerid, "Hagyd békén az NPC-t!", COLOR_ADMIN);
			if(RicardoVedelem(playerid, giveplayerid))
			{
				BanEx(playerid, "Ricardo bannolásával való próbálkozás");
				return 1;
			}
			if(PlayerInfo[playerid][pAdmin] < PlayerInfo[giveplayerid][pAdmin])
			{
				//SendFormatMessageToAll(COLOR_LIGHTRED, "%s kirúgva a rendszer által | Oka: Nagyobb admint akarsz kirúgni?", AdminName(playerid));
				SeeRPGKick(playerid, "Nagyobb admint akarsz kickelni?", NINCS);
				return 1;
			}
			if(playerid == giveplayerid)
			{
				Msg(playerid, "Ne villogjál, nem arra való!", COLOR_ADMIN);
				return 1;
			}
			if(IsValidPlayerID(giveplayerid))
			{
				GetPlayerName(giveplayerid, giveplayer, sizeof(giveplayer));
				GetPlayerName(playerid, sendername, sizeof(sendername));
				new length = strlen(cmdtext);
				while ((idx < length) && (cmdtext[idx] <= ' '))
				{
					idx++;
				}
				new offset = idx;
				new result[64];
				while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
				{
					result[idx - offset] = cmdtext[idx];
					idx++;
				}
				result[idx - offset] = EOS;
				if(!strlen(result)) return Msg(playerid, "/kick [JátékosID/NévRészlet] [reason]", COLOR_ADMIN);
				if(PlayerInfo[playerid][pAdmin] < PlayerInfo[giveplayerid][pAdmin])
				{
					Msg(playerid, "LSRP: Mekkora egy kretén vagy... Nagyobb admint akarsz kirugni? -.-''");
					return 1;
				}
				new year, month,day, ora, perc, mp;
				getdate(year, month, day);
				gettime(ora, perc, mp);
				
				format(string, sizeof(string), "LSRP: %s ki lett rugva %s által | Oka: %s (%d-%d-%d)", giveplayer, sendername, (result),month,day,year, ora, perc, mp);
				KickLog(string);
				
				format(string, sizeof(string), "%s kickelve lett (%s) %s által", giveplayer, AdminSzint(playerid), sendername);
				AdminCMD(string);
				format(string, sizeof(string), "Oka: %s", (result), month,day,year, ora, perc, mp);
				AdminCMD(string);
				
				KickEx(giveplayerid);
				return 1;
			}
		}
		return 1;
	}
	
	if(strcmp(cmd, "/warn", true) == 0 || strcmp(cmd, "/figyelmeztet", true) == 0)
	{
	    if(IsValidPlayerID(playerid))
	    {
	    	tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				Msg(playerid, "/warn [JátékosID/NévRészlet] [reason]");
				return 1;
			}
			giveplayerid = ReturnUser(tmp);
			if(giveplayerid == INVALID_PLAYER_ID) return 1;
			if(giveplayerid == playerid) 
			{
				Msg(playerid, "Magadat nem /warn-olod!");
				return 1;
			}

			if(IsPlayerNPC(giveplayerid)) return Msg(playerid, "Hagyd békén az NPC-t!");
			if(RicardoVedelem(playerid, giveplayerid)) return 1;
			if(PlayerInfo[playerid][pAdmin] < PlayerInfo[giveplayerid][pAdmin])
			{
				SendFormatMessageToAll(COLOR_LIGHTRED, "%s kirúgva a rendszer által | Oka: Mekkora egy kretén vagy... nagyobb admint akarsz kirugni? -.-''", PlayerName(playerid));
				KickEx(playerid);
				//Kick(playerid);
				return 1;
			}

			if(Admin(playerid, 1) || IsAS(playerid))
			{
			    if(IsValidPlayerID(giveplayerid))
			    {
			        if(giveplayerid != INVALID_PLAYER_ID)
			        {

					    GetPlayerName(giveplayerid, giveplayer, sizeof(giveplayer));
						GetPlayerName(playerid, sendername, sizeof(sendername));
						new length = strlen(cmdtext);
						while ((idx < length) && (cmdtext[idx] <= ' '))
						{
							idx++;
						}
						new offset = idx;
						new result[64];
						while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
						{
							result[idx - offset] = cmdtext[idx];
							idx++;
						}
						result[idx - offset] = EOS;
						if(!strlen(result))
						{
							Msg(playerid, "/warn [JátékosID/NévRészlet] [reason]");
							return 1;
						}
						
						format(string, sizeof(string), "(%s) %s figyelmeztette %s-t", AdminSzint(playerid), sendername, giveplayer);
						AdminCMD(string);							
						format(string, sizeof(string), "Oka: %s", result);
						AdminCMD(string);
						
						new warns = PlayerInfo[giveplayerid][pKWarns];
						new maxwarns = 3;
						
						format(string, sizeof(string), "Figyelmeztetéseid száma: %d (még %d figyelmeztetés és kickelve leszel)", warns, maxwarns-warns);
						Msg(giveplayerid, string);
						
						PlayerInfo[giveplayerid][pKWarns] += 1;
						if(warns >= maxwarns)
						{
						    PlayerInfo[giveplayerid][pKWarns] = 0;
						    /*new year, month, day;
							getdate(year, month, day);
							format(string, sizeof(string), "%s kirúgva egy AdminSegéd(%s) által | Oka: %s (%d-%d-%d)", giveplayer, sendername, (result),month,day,year);
							KickLog(string);
							
							SeeRPGKick(giveplayerid, "Elérte a maximális figyelmeztetések számát", NINCS);*/
							
							new ido = 30; // perc
							Jail(giveplayerid, "set", (ido * 60), "ajail", "Elérte a maximális figyelmeztetések számát!");
							
							format(string, sizeof(string), "%s %d perc AdminJailt kapott a rendszer által!", PlayerName(giveplayerid), ido);
							AdminCMD(string);
							format(string, sizeof(string), "Oka: Elérte a maximális figyelmeztetések számát! (%d)", maxwarns);
							AdminCMD(string);
							
							return 1;
						}
					}
				}
				else
				{
					format(string, sizeof(string), "* Nem elérhetõ játékos(%d)", giveplayerid);
					Msg(playerid, string);
				}//not connected
			}
		}
		return 1;
	}

	if(strcmp(cmd, "/bwarn", true) == 0)
	{
		if(!Admin(playerid, 2)) return HibasParancs(playerid, true);
	    if(IsValidPlayerID(playerid))
	    {
	    	tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				Msg(playerid, "/bwarn [JátékosID/NévRészlet] [reason]");
				return 1;
			}
			giveplayerid = ReturnUser(tmp);
			if(giveplayerid == INVALID_PLAYER_ID) return 1;
			if(giveplayerid == playerid) 
			{
				Msg(playerid, "Magadat nem /bwarn-olod!");
				return 1;
			}
			if(IsPlayerNPC(giveplayerid)) return Msg(playerid, "Hagyd békén az NPC-t!");
			if(RicardoVedelem(playerid, giveplayerid)) return 1;
			if(PlayerInfo[playerid][pAdmin] < PlayerInfo[giveplayerid][pAdmin])
			{
				SendFormatMessageToAll(COLOR_LIGHTRED, "%s kirúgva a rendszer által | Oka: Mekkora egy kretén, nagyobb admint akar bannolni...", PlayerName(playerid));
				KickEx(playerid);
				//Kick(playerid);
				return 1;
			}

			if(PlayerInfo[playerid][pAdmin] >= 1)
			{
			    if(IsValidPlayerID(giveplayerid))
			    {
			        if(giveplayerid != INVALID_PLAYER_ID)
			        {
					    GetPlayerName(giveplayerid, giveplayer, sizeof(giveplayer));
						GetPlayerName(playerid, sendername, sizeof(sendername));
						new length = strlen(cmdtext);
						while ((idx < length) && (cmdtext[idx] <= ' '))
						{
							idx++;
						}
						new offset = idx;
						new result[64];
						while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
						{
							result[idx - offset] = cmdtext[idx];
							idx++;
						}
						result[idx - offset] = EOS;
						if(!strlen(result))
						{
							Msg(playerid, "/bwarn [JátékosID/NévRészlet] [reason]");
							return 1;
						}
						PlayerInfo[giveplayerid][pWarns] += 1;
						format(string, sizeof(string), "Figyelmeztetted %s-t, Oka: %s", giveplayer, (result));
						Msg(playerid, string);
						format(string, sizeof(string), "[Ban]%s figyelmeztette %s-t | Oka: %s", sendername, giveplayer, (result));
						ABroadCast(COLOR_LIGHTRED, string, 1);
						format(string, sizeof(string), "*Admin %s figyelmeztetett! Oka: %s", sendername, (result)); // Admin %s has warned you! Reason: %s
						SendClientMessage(giveplayerid, COLOR_LIGHTRED, string);
						if(PlayerInfo[giveplayerid][pWarns] >= 3)
						{
							PlayerInfo[giveplayerid][pWarns] = 0;
						    new year, month, day;
							getdate(year, month, day);
							format(string, sizeof(string), "%s bannolva %s által(5 figyelmeztetése megvolt) | Oka: %s (%d-%d-%d)", giveplayer, sendername, (result),month,day,year);
							BanLog(string);
							format(string, sizeof(string), "%s bannolva %s által(5 figyelmeztetése megvolt) | Oka: %s", giveplayer, sendername, (result)); // %s has been banned by %s(had 5 warnings). | Reason: %s
							SendClientMessageToAll(COLOR_LIGHTBLUE, string);
							format(string, sizeof(string), "5 figyelmeztetés - Ok: %s", (result));
							SeeRPGBan(giveplayerid, 0, playerid, string);
							return 1;
						}
						return 1;
					}
				}//not connected
			}
			else
			{
				format(string, sizeof(string), "* Nem elérhetõ játékos(%d)", giveplayerid);
				Msg(playerid, string);
			}
		}
		return 1;
	}
	
	if(egyezik(cmd, "/unban"))
	{
	    if(!Admin(playerid, 3)) return HibasParancs(playerid, true);
		if(params != 1) return Msg(playerid, "/unban [Játékos Teljes IG Neve, Vagy IP]");
		if(strlen(param[1]) > MAX_PLAYER_NAME) return Msg(playerid, "A Név max 24 karakter te low ");
		new parancs[64];
		if(BannolvaVan(param[1]))
		{
			Format(parancs, "DELETE FROM bans WHERE Cim='%s' ",param[1]);
			mysql_query(parancs);
			mysql_free_result();
			
			PlayerTextFormat(playerid, "%s unbannolva!", param[1]);
			Msg(playerid, PlayerText[playerid], COLOR_ADMIN);
			
			ABroadCastFormat(COLOR_LIGHTRED, 1, "(%s) %s unbannolt egy játékost - %s", AdminSzint(playerid), PlayerName(playerid), param[1]);
		}
		else
		{
			Msg(playerid, "Nincs ilyen bannolt játékos!");
			return 1;
		}
	    return 1;
	}
	
	if(egyezik(cmd, "/iban"))
	{
		if(!Admin(playerid, 3)) return HibasParancs(playerid, true);
	    if(IsValidPlayerID(playerid))
	    {
	    	tmp = strtok(cmdtext, idx);
			if(!strlen(tmp)) return Msg(playerid, "Használat: /iban [JátékosID/NévRészlet] [Oka]", COLOR_ADMIN);

			giveplayerid = ReturnUser(tmp);
			if(giveplayerid == INVALID_PLAYER_ID) return 1;
			if(IsPlayerNPC(giveplayerid)) return Msg(playerid, "Hagyd békén az NPC-t!");
			if(RicardoVedelem(playerid, giveplayerid))
			{
				BanEx(playerid, "Ricardo IP bannolásával való próbálkozás");
				return 1;
			}
			if(PlayerInfo[playerid][pAdmin] < PlayerInfo[giveplayerid][pAdmin] && PlayerInfo[giveplayerid][pAdmin] < FOADMIN && !IsTulaj(playerid))
			{
				SendFormatMessageToAll(COLOR_LIGHTRED, "%s kirúgva a rendszer által | Oka: Nagyobb admint akarsz bannolni? -.-", AdminName(playerid));
				Kick(giveplayerid);
				return 1;
			}
			if(giveplayerid == playerid) return Msg(playerid, "Magadat??");
			if(PlayerInfo[playerid][pAdmin] < PlayerInfo[giveplayerid][pAdmin]) return Msg(playerid, "Nagyobb admint mint te? Hülye vagy?");

			if(Admin(playerid, 1))
			{
			    if(IsValidPlayerID(giveplayerid))
			    {
			        if(giveplayerid != INVALID_PLAYER_ID)
			        {
					    GetPlayerName(giveplayerid, giveplayer, sizeof(giveplayer));
						GetPlayerName(playerid, sendername, sizeof(sendername));
						new length = strlen(cmdtext);
						while ((idx < length) && (cmdtext[idx] <= ' '))
						{
							idx++;
						}
						new offset = idx;
						new result[128];
						while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
						{
							result[idx - offset] = cmdtext[idx];
							idx++;
						}
						result[idx - offset] = EOS;
						if(!strlen(result))
							return Msg(playerid, "Használat: /iban [JátékosID/NévRészlet] [Oka]");

						format(string, sizeof(string), "%s IP bannolva (%s) %s által!", PlayerName(giveplayerid), AdminSzint(playerid), AdminName(playerid)); BanLog(string);
						AdminCMD(string);

						format(string, sizeof(string), "Oka: %s", (result)); BanLog(string);
						AdminCMD(string);

						//SeeRPGBan(giveplayerid, 0, playerid, (result), true); // eredeti
						SeeRPGBan(giveplayerid, 0, playerid, (result), true, false); // maga az IP -ban
						SeeRPGBan(giveplayerid, 0, playerid, (result), false, true); // + karakter ban (ebben a kick is benne van)
						return 1;
					}
				}
			}
			else
			{
				format(string, sizeof(string), "%d nincs fent a szerveren.", giveplayerid);
				Msg(playerid, string);
			}
		}
		return 1;
	}
	
	if(egyezik(cmd, "/kban"))
	{
		if(!Admin(playerid, 2)) return HibasParancs(playerid, true);
	    if(IsValidPlayerID(playerid))
	    {
	    	tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
				return Msg(playerid, "Használat: /kban [JátékosID/NévRészlet] [Oka]");

			giveplayerid = ReturnUser(tmp);
			if(giveplayerid == INVALID_PLAYER_ID) return 1;
			if(IsPlayerNPC(giveplayerid)) return Msg(playerid, "Hagyd békén az NPC-t!");
			if(RicardoVedelem(playerid, giveplayerid))
			{
				BanEx(playerid, "Ricardo örök bannolásával való próbálkozás");
				return 1;
			}
			if(PlayerInfo[playerid][pAdmin] < PlayerInfo[giveplayerid][pAdmin])
			{
				SeeRPGKick(playerid, "Nagyobb admint akarsz bannolni?", NINCS);
				return 1;
			}
			if(giveplayerid == playerid) return Msg(playerid, "Magadat??");
			if(PlayerInfo[playerid][pAdmin] < PlayerInfo[giveplayerid][pAdmin]) return Msg(playerid, "Nagyobb admint mint te? Hülye vagy?");

			if(Admin(playerid, 1))
			{
			    if(IsValidPlayerID(giveplayerid))
			    {
			        if(giveplayerid != INVALID_PLAYER_ID)
			        {
					    GetPlayerName(giveplayerid, giveplayer, sizeof(giveplayer));
						GetPlayerName(playerid, sendername, sizeof(sendername));
						new length = strlen(cmdtext);
						while ((idx < length) && (cmdtext[idx] <= ' '))
						{
							idx++;
						}
						new offset = idx;
						new result[128];
						while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
						{
							result[idx - offset] = cmdtext[idx];
							idx++;
						}
						result[idx - offset] = EOS;
						if(!strlen(result)) return Msg(playerid, "Használat: /kban [JátékosID/NévRészlet] [Oka]");
						
						format(string, sizeof(string), "%s örök bannolva lett (%s) %s által!", PlayerName(giveplayerid), AdminSzint(playerid), AdminName(playerid)); BanLog(string);
						AdminCMD(string);
						
						format(string, sizeof(string), "Oka: %s", (result)); BanLog(string);
						AdminCMD(string);
						
						SeeRPGBan(giveplayerid, 0, playerid, (result));
						return 1;
					}
				}
			}
			else
			{
				format(string, sizeof(string), "%d nincs fent a szerveren.", giveplayerid);
				Msg(playerid, string);
			}
		}
		return 1;
	}
	
	if(egyezik(cmd, "/étel"))
	{
		if(params != 1) return Msg(playerid, "/étel [Hordás / Lead]");
		if(egyezik(param[1], "hordás") || egyezik(param[1], "hordas"))
		{
			if(Munkaban[playerid] != MUNKA_PIZZA)
			{
				if(!PlayerToPoint(3.0, playerid, 375.5369, -116.4163, 1001.4922)) return Msg(playerid, "Nem vagy a kajáldában!");
				Munkaban[playerid] = MUNKA_PIZZA;
				new haz = random(HazakSzamaOsszesen);
				PizzaSzallitasHaz[playerid] = haz;
				SetPlayerCheckpoint(playerid, HouseInfo[PizzaSzallitasHaz[playerid]][hEntrancex], HouseInfo[PizzaSzallitasHaz[playerid]][hEntrancey], HouseInfo[PizzaSzallitasHaz[playerid]][hEntrancez], 5);
				SendClientMessage(playerid, COLOR_LIGHTGREEN, "Felvetted az ételt! Szállítsd ki a megadott címre!");
			}
			else
			{
				Munkaban[playerid] = NINCS;
				MunkaCheckpoint[playerid] = NINCS;
				PizzaSzallitasHaz[playerid] = NINCS;
				DisablePlayerCheckpoint(playerid);

				SendClientMessage(playerid, COLOR_LIGHTGREEN, "Befejezted a munkát!");
				return 1;
			}
		}
		else if(egyezik(param[1], "lead"))
		{
			if(Nincsbelepve(playerid)) return 1;
			if(IsPlayerInAnyVehicle(playerid)) return Msg(playerid, "Jármûben nem adhatod le..");
		    if(Munkaban[playerid] != MUNKA_PIZZA) return Msg(playerid, "Nem álltál munkába! (/étel hordás)");
		    if(!PlayerToPoint(5.0,playerid, HouseInfo[PizzaSzallitasHaz[playerid]][hEntrancex],HouseInfo[PizzaSzallitasHaz[playerid]][hEntrancey],HouseInfo[PizzaSzallitasHaz[playerid]][hEntrancez])) return Msg(playerid, "Nem vagy a Checkpointnál!");
   			new haz = random(HazakSzamaOsszesen);
			PizzaSzallitasHaz[playerid] = haz;
			SetPlayerCheckpoint(playerid, HouseInfo[PizzaSzallitasHaz[playerid]][hEntrancex], HouseInfo[PizzaSzallitasHaz[playerid]][hEntrancey], HouseInfo[PizzaSzallitasHaz[playerid]][hEntrancez], 5.0);
   			new penz = Rand(5, 10);
			MsgFormat(playerid, "Leadtad a ételt, és kaptál $%d-t!", penz);
			GiveMoney(playerid, penz);
			FrakcioInfo[LMUNKA_ALLAM][fPenz] -= penz;
			return 1;
		}
		return 1;
	}
	
	if(egyezik(cmd, "/serialban"))
	{
		if(!IsFejleszto(playerid)) return HibasParancs(playerid, true);
		
		if(params < 1) return Msg(playerid, "/serialban [JátékosID/NévRészlet]", COLOR_ADMIN);
		
		giveplayerid = ReturnUser(param[1]);
		if(IsRicardo(giveplayerid)) return 1;
		
		if(IsValidPlayerID(giveplayerid))
		{
			if(giveplayerid != INVALID_PLAYER_ID)
			{
				new adatok[256], gpciserial[48];
				gpci(playerid, gpciserial, sizeof(gpciserial));
				Format(adatok, "%s, %s, %s, %d", PlayerName(giveplayerid), gpciserial, PlayerIP(playerid), gettime());
				Mysql_Insert("gpci_banlist", "PlayerName, Serial, IP, Datum", adatok);
				KickEx(giveplayerid);
				
				MsgFormat(playerid, "[%d]%s GPCI bannolva lett!", giveplayerid, PlayerName(giveplayerid));
			}
		}
		return 1;
	}
	
	if(strcmp(cmd, "/ban", true) == 0)
	{
		if(!Admin(playerid, 2)) return HibasParancs(playerid, true);
	    if(IsValidPlayerID(playerid))
	    {
	    	tmp = strtok(cmdtext, idx);
			if(!strlen(tmp)) return Msg(playerid, "Használat: /ban [JátékosID/NévRészlet] [idõ - óra] [oka]");

			giveplayerid = ReturnUser(tmp);
			if(giveplayerid == INVALID_PLAYER_ID) return 1;

			if(IsPlayerNPC(giveplayerid)) return Msg(playerid, "Hagyd békén az NPC-t!");
			
			if(RicardoVedelem(playerid, giveplayerid))
			{
				BanEx(playerid, "Ricardo bannolásával való próbálkozás");
				return 1;
			}
			if(PlayerInfo[playerid][pAdmin] < PlayerInfo[giveplayerid][pAdmin])
			{
				SeeRPGKick(playerid, "Nagyobb admint akarsz bannolni?", NINCS);
				return 1;
			}
			
			if(playerid == giveplayerid)
			{
				SendFormatMessageToAll(COLOR_LIGHTRED, "%s ki lett bannolva a rendszer által | Oka: Magadat bannolod? Akkor így is maradsz!", PlayerName(playerid));
				SeeRPGBan(giveplayerid, 0, playerid, "/ban");
				return 1;
			}

			if(PlayerInfo[playerid][pAdmin] >= 1)
			{
			    if(IsValidPlayerID(giveplayerid))
			    {
			        if(giveplayerid != INVALID_PLAYER_ID)
			        {
						new ido;
						ido = strval(strtok(cmdtext, idx));

					    GetPlayerName(giveplayerid, giveplayer, sizeof(giveplayer));
						GetPlayerName(playerid, sendername, sizeof(sendername));
						new length = strlen(cmdtext);
						while ((idx < length) && (cmdtext[idx] <= ' '))
						{
							idx++;
						}
						new offset = idx;
						new result[128];
						while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
						{
							result[idx - offset] = cmdtext[idx];
							idx++;
						}
						result[idx - offset] = EOS;
						if(!strlen(result))	return Msg(playerid, "Használat: /ban [JátékosID/NévRészlet] [idõ - óra] [oka]");

						if(!IsNumeric(param[2]) && !egyezik(param[2], "örök") && !egyezik(param[2], "orok") || IsNumeric(param[2]) && strval(param[2]) <= 0)
							return Msg(playerid, "Helyesen kell megadnod az idõtartamot! (Szám vagy \"örök\"!)");

						new meddig[128];
						if(ido < 24) Format(meddig, "%d órára", ido);
						else if(ido >= 24 && ido < (24*7))
						{
							if(ido % 24 == 0)
								Format(meddig, "%d napra", (ido / 24));
							else
								Format(meddig, "%d napra és %d órára", floatround(ido/24, floatround_floor), (ido%24));
						}
						else if(ido >= (24*7))// && ido < (24*7*4))
						{
							if(ido % (24*7) == 0)
								Format(meddig, "%d hétre", (ido/24/7));
							else
							{
								if(ido % 24 == 0)
									Format(meddig, "%d hétre és %d napra", floatround(ido/24/7, floatround_floor), floatround((ido/24)%7, floatround_floor));
								else
									Format(meddig, "%d hétre, %d napra, és %d órára", floatround(ido/24/7, floatround_floor), floatround((ido/24)%7, floatround_floor), (ido%24));
							}
						}

						ido = gettime() + (60*60*ido);

						if(egyezik(param[2], "örök") || egyezik(param[2], "orok"))
						{
							PlayerTextFormat(playerid, "/kban %d %s", giveplayer, result);
							ParancsKuldes(playerid, PlayerText[playerid]);
						}
						else
						{
							format(string, sizeof(string), "%s bannolva lett (%s) %s által %s!", giveplayer, AdminSzint(playerid), AdminName(playerid), meddig); BanLog(string);
							AdminCMD(string);

							format(string, sizeof(string), "Oka: %s", (result)); BanLog(string);
							AdminCMD(string);
							
							SeeRPGBan(giveplayerid, ido, playerid, (result));
						}
						return 1;
					}
				}//not connected
			}
			else
			{
				format(string, sizeof(string), "%d nincs fent a szerveren.", giveplayerid);
				Msg(playerid, string);
			}
		}
		return 1;
	}
//----------------------------------[Freeze]------------------------------------------------
	if(strcmp(cmd, "/jégkocka", true) == 0 || strcmp(cmd, "/freeze", true) == 0) //Fordítást igényel - admin parancs
	{
		if(!Admin(playerid)) return HibasParancs(playerid, true);
	    if(IsValidPlayerID(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				Msg(playerid, "/freeze [JátékosID/NévRészlet]");
				return 1;
			}
			new playa;
			playa = ReturnUser(tmp);
			if(IsValidPlayerID(playa))
			{
				if(playa != INVALID_PLAYER_ID)
				{
					if(RicardoVedelem(playerid, playa)) return 1;
					if(IsPlayerNPC(playa)) return Msg(playerid, "Hagyd békén az NPC-t!");
					if(RicardoVedelem(playerid, giveplayerid)) return 1;
					GetPlayerName(playa, giveplayer, sizeof(giveplayer));
					GetPlayerName(playerid, sendername, sizeof(sendername));
					TogglePlayerControllable(playa, 0);
					format(string, sizeof(string), "AdminParancs: %s Freezes %s",sendername, giveplayer);
					printf("%s",string);
					format(string, sizeof(string), "(%s) %s lefagyasztotta %s-t", AdminSzint(playerid), AdminName(playerid), giveplayer);
					ABroadCast(COLOR_LIGHTRED,string, 1);
				}
			}
		}
		return 1;
	}

//----------------------------------[unfreeze]------------------------------------------------
	if(strcmp(cmd, "/unfreeze", true) == 0) //Fordítást igényel - admin parancs
	{
		if(!Admin(playerid)) return HibasParancs(playerid, true);
	    if(IsValidPlayerID(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				Msg(playerid, "/unfreeze [playerid]");
				return 1;
			}
			new playa;
			playa = ReturnUser(tmp);
			if(PlayerInfo[playerid][pAdmin] >= 1 || IsAS(playerid))
			{
			    if(IsValidPlayerID(playa))
			    {
			        if(playa != INVALID_PLAYER_ID)
			        {
			            if(IsPlayerNPC(playa) && !IsRicardo(playerid)) return Msg(playerid, "Hagyd békén az NPC-t!");
			    	    GetPlayerName(playa, giveplayer, sizeof(giveplayer));
						GetPlayerName(playerid, sendername, sizeof(sendername));
						TogglePlayerControllable(playa, 1);
						format(string, sizeof(string), "AdminParancs: %s felolvasztotta %s-t",sendername,  giveplayer);
						printf("%s",string);
						format(string, sizeof(string), "(%s) %s kiolvasztotta %s-t", AdminSzint(playerid), AdminName(playerid), giveplayer);
						ABroadCast(COLOR_LIGHTRED,string,1);
					}
				}
			}
		}
		return 1;
	}
	
	if(egyezik(cmd, "/flycam") || egyezik(cmd, "/flymode") || egyezik(cmd, "/fly"))
	{
		if(!Admin(playerid, 1)) return HibasParancs(playerid, true);
		//if(!IsAdminSzolis(playerid)) return Msg(playerid, "Ezt a parancsot csak AdminSzolgálatban használhatod!", COLOR_ADMIN);
		
		new time = 2*1000; // xy*1000 = xy másodperc
		if(GetPVarType(playerid, "FlyMode"))
		{
			OnplayerSpawnLefutott[playerid] = false;
			GetPlayerPos(playerid, PlayerInfo[playerid][pPosX], PlayerInfo[playerid][pPosY], PlayerInfo[playerid][pPosZ]);
			CancelFlyMode(playerid);
			GameTextForPlayer(playerid, "~w~FlyMode~n~~r~Off", time, 1);
		}
		else 
		{
			if(Tevezik[playerid] != NINCS) return Msg(playerid, "TV-zés közben nem aktiválhatod a FlyMódot!", COLOR_ADMIN);
			if(IsPlayerInAnyVehicle(playerid)) return Msg(playerid, "Jármûben nem aktiválhatod a FlyMódot!", COLOR_ADMIN);
			
			/*for(new x = 0; x < 12; x++) {
				GetPlayerWeaponData(playerid, x, PlayerInfo[playerid][pFegyver][x], PlayerInfo[playerid][pTolteny][x]);
			}*/
		
			if(!IsAdminSzolis(playerid))
			{
				ABroadCastFormat(COLOR_LIGHTRED, 1, "(%s) %s AdminSzolgálaton kívül lépett be FlyMode-ba", AdminSzint(playerid), PlayerName(playerid));
			}
			FlyMode(playerid);
			GameTextForPlayer(playerid, "~w~FlyMode~n~~g~On", time, 1);
		}
		return 1;
	}

//----------------------------------[GMX]-----------------------------------------------

	if(strcmp(cmd, "/szerver", true) == 0)
	{
	    if(IsValidPlayerID(playerid))
	    {
			if(IsFejleszto(playerid) || IsTulaj(playerid))
			{
				if(params != 2)
				{
					Msg(playerid, "Használata: /szerver [funkció] [idõ]");
					Msg(playerid, "Funkciók: gmx, stop");
					return 1;
				}

				tmp = GetParam(cmdtext, 1);
				new ido = strval(param[2]);

				if(ido < 10 || ido > 300) return Msg(playerid, "Minimum 10 mp, max 5 perc (300) másodperc!");

				if(strcmp(tmp, "gmx", true) == 0)
				{
					/*ParancsMegerosites[playerid] ++;
					if(ParancsMegerosites[playerid] != 2) return Msg(playerid, "Biztosan használni akarod a parancsot? Ha igen, írd be újra!");
					
					SCMToAll(COLOR_WHITE, ValasztoVonal("Szerver restart"));
					SendFormatMessageToAll(COLOR_WHITE, "{%s}• A szerver újraindul kb. %d másodperc múlva •", COLOR_SEEBLUE, ido);

					PlayerForeach(i)
					{
						GameTextForPlayer(i, "~r~~h~================~n~Restart!~n~~r~~h~================", 3000, 5);
					}

					SetTimer("Restart", ((ido*1000)+1000), false);

					SCMToAll(COLOR_WHITE, "{"#COLOR_SEEBLUE"}MySQL: Adatok Mentése Folyamatban");
					SaveAccounts();
					OnAjtoUpdate();
					OnIntsUpdate();
					UpdatePerSec[uHaz] = 20;
					UpdatePerSec[uKocsi] = 20;
					UpdatePerSec[uBiz] = 20;
                    UpdatePerSec[uRaktar] = 20;
					UpdatePerSec[uButor] = 20;                    
					UpdatePerSec[uHotel] = 20;
					MySQLUpdater();
					SCMToAll(COLOR_WHITE, "{"#COLOR_SEEBLUE"}MySQL: Adatok Sikeresen Mentve");
					SCMToAll(COLOR_WHITE, ValasztoVonal("Szerver restart"));
					resivan = 1;
					ParancsMegerosites[playerid] = 0;*/
				}
				else if(strcmp(tmp, "stop", true) == 0)
				{
					ParancsMegerosites[playerid] ++;
					if(ParancsMegerosites[playerid] != 2) return Msg(playerid, "Biztosan használni akarod a parancsot? Ha igen, írd be újra!");
					
					karbantartas = true;
					
					SCMToAll(COLOR_WHITE, ValasztoVonal("Szerver leállás"));
					SendFormatMessageToAll(COLOR_LIGHTBLUE, "• A szerver leáll %d másodperc múlva •", ido);
					
					PlayerForeach(i)
					{
						PlayerPlaySound(i, 6001, 0.0, 0.0, 0.0);
						GameTextForPlayer(i, "~r~~h~==============~n~Szerver leállás!~n~~r~~h~==============", 3000, 5);
					}

					SetTimerEx("SzerverStop", ido*1000, false, "s", "/szerver stop parancs");
					
					Msg(playerid, "MySQL: Adatok mentése folyamatban!", COLOR_ADMIN);
					SaveAccounts();
					OnAjtoUpdate();
					OnIntsUpdate();
					UpdatePerSec[uHaz] = 20;
					UpdatePerSec[uKocsi] = 20;
					UpdatePerSec[uBiz] = 20;
					UpdatePerSec[uRaktar] = 20;
					UpdatePerSec[uButor] = 20;
					UpdatePerSec[uHotel] = 20;
					MySQLUpdater();
					Msg(playerid, "MySQL: Adatok sikeresen mentve!", COLOR_ADMIN);
					SCMToAll(COLOR_WHITE, ValasztoVonal("Szerver leállás"));
					
					ParancsMegerosites[playerid] = 0;
				}
				else
				{
					Msg(playerid, "Használata: /szerver [funkció] [idõ]");
					Msg(playerid, "Funkciók: gmx, stop");
				}
			} else HibasParancs(playerid, true);
		}
		return 1;
	}
	if(strcmp(cmd, "/admins", true) == 0)
    {
		if(!Admin(playerid)) return HibasParancs(playerid, true);
		
		new
			count = 0,
			AdminInfo[128],
			szoliban[6]
		;
		
		PlayerForeach(i)
		{
			if(Admin(i, 1) && !IsPlayerNPC(i) && IsValidPlayerID(i))
			{
				if(IsAdminSzolis(i, NINCS)) szoliban = "Igen"; else szoliban = "Nem";
				Format(AdminInfo, "%d\t%s\t%s\t%s\n", i, PlayerName(i), AdminSzint(i), szoliban);
				
				if(count == 0)
					PlayerTextFormat(playerid, "ID\tNév\tBeosztás\tSzolgálatban\n\%s", AdminInfo);
				else
					PlayerTextFormat(playerid, "%s%s", PlayerText[playerid], AdminInfo);
					
				count ++;
			}
		}
		if(count != 0)
		{
			new fejlec[32];
			Format(fejlec, "Online adminok listája [%d]", count);
			ShowPlayerDialog(playerid, DIALOG_NINCS, DIALOG_STYLE_TABLIST_HEADERS, fejlec, PlayerText[playerid], "Bezár", "");
		}
		else Msg(playerid, "Nincs elérhetõ admin!");
		
		return 1;
    }
	if(egyezik(cmd, "/ahelp") || egyezik(cmd, "/ah"))
	{
		if(!Admin(playerid, 1)) return HibasParancs(playerid, true);
		
		new commandlist[2048];
		
		strcat(commandlist, "Parancs\tMinimum szint\tMegjegyzés\n");
		strcat(commandlist, "/aszoli\t1\tAdminszolgálatba lépés\n");
		strcat(commandlist, "/asay\t1\tSzerverüzenet kiírása\n");
		strcat(commandlist, "/a\t1\tAdminChat\n");
		strcat(commandlist, "/vhspawn\t1\tJátékos VH-ra spawnolása\n");
		strcat(commandlist, "/tv\t1\tJátékos megfigyelése\n");
		
		strcat(commandlist, "/warn\t1\tJátékos figyelmeztetése [3. = kick]\n");
		strcat(commandlist, "/kick\t1\tJátékos kirúgása\n");
		strcat(commandlist, "/ban\t2\tJátékos idõre tiltása\n");
		strcat(commandlist, "/kban\t2\tJátékos örök tiltása\n");
		strcat(commandlist, "/iban\t3\tJátékos IP tiltása\n");
		strcat(commandlist, "/unban\t3\tJátékos tiltás feloldása\n");		
		strcat(commandlist, "/checkban\t1\tJátékos tiltás információja\n");
		
		strcat(commandlist, "/ajailosok\t1\tAdminJailben lévõ játékosok\n");
		strcat(commandlist, "/goto\t1\tJátékoshoz odateleportálás\n/gethere\t1\tJátékos elteleportálása\n");
		strcat(commandlist, "/gotocar\t1\tJármûhöz odateleportálás\n/getcar\t1\tJármû elteleportálása\n");
		strcat(commandlist, "/oldcar\t1\tJátékos utolsó jármûvének megtekintése\n");
		strcat(commandlist, "/tele\t1\tTeleportálás a fõbb helyekre\n");
		strcat(commandlist, "/freeze\t1\tJátékos lefagyasztása\n/unfreeze\t1\tJátékos kifagyasztása\n");
		strcat(commandlist, "/park\t1\tJármû leparkolása\n");
		strcat(commandlist, "/jail\t1\tJátékos börtönbe zárása\n");
		strcat(commandlist, "/crs\t1\tJármû respawnolása\n");
		strcat(commandlist, "/admins\t1\tOnline adminok megtekintése\n");
		strcat(commandlist, "/aranks\t1\tFrakciótagok megtekintése\n");
		strcat(commandlist, "/uptime\t1\tSzerver futási ideje\n");
		strcat(commandlist, "/togreport\t4\tReportok kikapcsolása\n");
		strcat(commandlist, "/togpm\t4\tPM-ek kikapcsolása\n");
		strcat(commandlist, "/veh\t4\tAdminjármû lekérése\n");
		strcat(commandlist, "/asegit\t1\tJátékos felsegítése\n");
		strcat(commandlist, "/frakciók\t1\tFrakciólista megtekintése\n");
		strcat(commandlist, "/flip\t4\tJármû megjavítása\n");
		strcat(commandlist, "/fuelcar\t4\tJármû megtankolása\n");
		strcat(commandlist, "/setskin\t3\tJátékos model átállítása\n");
		strcat(commandlist, "/fegyverreset\t1\tJátékos fegyvereinek elvétele\n");
		strcat(commandlist, "/sethp\t4\tJátékos HP beállítása\n");
		strcat(commandlist, "/setarmour\t4\tJátékos armor beállítása\n");
		strcat(commandlist, "/setstat\t5\tJátékos stat átállítása\n");
		strcat(commandlist, "/givegun\t4\tJátékosnak fegyver adás\n");
		strcat(commandlist, "/givemoney\t4\tJátékosnak pénz adás\n");
		strcat(commandlist, "/adminálnév\t2\tAdmin álnév beállítása\n");
		strcat(commandlist, "/törlés\t5\tATM, kapu, fülke, stb. törlése\n");
		strcat(commandlist, "/újfülke\t5\tÚj telefonfülke lerakása\n");
		strcat(commandlist, "/újmodel\t4\tJármû modeljének átállítása\n");
		strcat(commandlist, "/újház\t4\tÚj ház lerakása\n");
		strcat(commandlist, "/újajtó\t4\tÚj ajtó lerakása\n/aajtó\t1\tAjtók kezelése\n");
		strcat(commandlist, "/atuning\t5\tAdmin tuning\n");
		strcat(commandlist, "/knevvaltas\t3\tJátékos nevének átírása\n");
		strcat(commandlist, "/újfrkocsi\t4\tÚj frakció jármû lerakása\n");
		strcat(commandlist, "/kapu\t4\tKapuk kezelése\n");
		strcat(commandlist, "/makeadmin\t5\tJátékos adminszintjének átállítása\n");
		strcat(commandlist, "/abiz\t5\tBiznisz kezelése\n");
		strcat(commandlist, "/dutypos\t4\tFrakció dutyhely átállítása\n");
		strcat(commandlist, "/setajelszó\tTulajdonos\tAdminjelszó átállítása\n");
		strcat(commandlist, "/karbantartás\tTulajdonos\tKarbantartás üzemmód állítása\n");
		strcat(commandlist, "/settime\tTulajdonos\tSzerveridõ átállítása\n");
		
		ShowPlayerDialog(playerid, DIALOG_NINCS, DIALOG_STYLE_TABLIST_HEADERS, "Adminparancsok listája", commandlist, "Bezár", "");
		return 1;
	}
	if(strcmp(cmd, "/szefbe", true)==0)
    {
		if(playerid != INVALID_PLAYER_ID) return 1;
        if(IsValidPlayerID(playerid))
	    {
	        if(LMT(playerid, LMUNKA_ALLAM) && Munkarang(playerid, 6) || Admin(playerid, FOADMIN))
	        {
	            new penze = GetMoney(playerid);
		        if(penze < 1)
				{
				    Msg(playerid, "Nincs pénzed!");
					return 1;
				}
				tmp = strtok(cmdtext, idx);

				if(!strlen(tmp))
				    return Msg(playerid, "Használata: /szefbe [pénz]");

				new penz = strval(tmp);

				if(penz > penze)
				{
                    MsgFormat(playerid, "Nincs $%d-od!", penz);
                    return 1;
    			}

				GiveMoney(playerid, -penz);
				Tax += penz;

				SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Beraktál a kasszába $%d-t! $%d van benne!", penz, Tax);
			}
			else
			    return Msg(playerid, "Nem vagy Elnök!");
		}
		return 1;
	}

	if(strcmp(cmd, "/szefki", true)==0) //Fordítást igényel - Külön kell a bevándorlóknak
    {
		if(playerid != INVALID_PLAYER_ID) return 1;
        if(IsValidPlayerID(playerid))
	    {

	        if(Admin(playerid, FOADMIN))
	        {
		        if(Tax < 1)
				{
				    Msg(playerid, "A kasszában nincs pénz!");
					return 1;
				}
				tmp = strtok(cmdtext, idx);

				if(!strlen(tmp))
				    return Msg(playerid, "Használata: /szefki [pénz]");

				new penz = strval(tmp);

				if(penz > Tax)
				{
                    MsgFormat(playerid, "A kasszában csak $%d van!", Tax);
                    return 1;
    			}

				GiveMoney(playerid, penz);
				Tax -= penz;

				SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Kivettél a kasszából $%d-t! Még $%d van benne!", penz, Tax);
			}
			else
			    return Msg(playerid, "Nem vagy Elnök!");
		}
		return 1;
	}
	if(egyezik(cmd, "/büntetésem") || egyezik(cmd, "/buntetesem"))
	{
	    if(Bortonben(playerid))
	    {
			new valaszto[128] = "{FFFFFF}—————————————[ {"#COLOR_MSG"}Büntetés infó{FFFFFF} ]—————————————";
	        Msg(playerid, valaszto);
			SendFormatMessage(playerid,COLOR_WHITE, "{"#COLOR_SEEBLUE"}Oka: %s",PlayerInfo[playerid][pJailOK]);
			SendFormatMessage(playerid,COLOR_WHITE, "{"#COLOR_SEEBLUE"}Jailt adta: %s",PlayerInfo[playerid][pJailtAdta]);
			SendFormatMessage(playerid,COLOR_WHITE, "{"#COLOR_SEEBLUE"}Idõ: %d mp",PlayerInfo[playerid][pJailTime]);
			Msg(playerid, valaszto);
	    }
	    else
	    {
	        Msg(playerid, "Nem vagy börtönben!");
	    }
		return 1;
	}
	if(strcmp(cmd, "/ajailosok", true) == 0)
	{
    	if(IsValidPlayerID(playerid))
	    {
	        if(!Admin(playerid, 1)) return 1;

			string = "Játékos\tIdõ\tOka\tAdmin\n";
			new idgstring[128];
	        PlayerForeach(p)
	        {
				if(!IsValidPlayerID(p) || !Logged(p)) continue;
	            if(PlayerInfo[p][pJailed] == BORTON_ADMIN && PlayerInfo[p][pJailTime] > 0)
	            {
	               Format(idgstring, "[%d]%s\t%dmp (~%dp)\t%s\t%s\n", p, PlayerName(p), PlayerInfo[p][pJailTime], floatround(float(PlayerInfo[p][pJailTime] / 60)), PlayerInfo[p][pJailOK], PlayerInfo[p][pJailtAdta]);
				   strcat(string, idgstring);
	            }
	        }
			ShowPlayerDialog(playerid, DIALOG_NINCS, DIALOG_STYLE_TABLIST_HEADERS, "AdminJail lista", string, "Bezár", "");
	    }
	    return 1;
 	}

	if(strcmp(cmd, "/a2jailosok", true) == 0)
	{
        if(!Admin(playerid, 1)) return HibasParancs(playerid, true);

        SendClientMessage(playerid, COLOR_LIGHTBLUE, "{15FF00}[========== {0059FF} Magánzárkások {15FF00}==========]");
        PlayerForeach(p)
        {
			if(!IsValidPlayerID(p) || !Logged(p)) continue;
            if(PlayerInfo[p][pJailed] == BORTON_ADMIN2 && PlayerInfo[p][pJailTime] > 0)
                SendFormatMessage(playerid, COLOR_YELLOW, "Név: %s | Idõ: %dmp(~%dp) | Oka: %s", PlayerName(p), PlayerInfo[p][pJailTime], floatround(float(PlayerInfo[p][pJailTime] / 60)), PlayerInfo[p][pJailOK]);
        }
		return 1;
 	}
 	if(egyezik(cmd, "/twt"))
    {
        if(IsValidPlayerID(playerid))
	    {
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, 0xFF2F00FF, "Segítség: /twt [funkció]");
				SendClientMessage(playerid, 0xFF2F00FF, "FIGYELEM: Csak SWAT-es kocsi mellett használjátok, csak RPsen!");
				SendClientMessage(playerid, 0xFF2F00FF, "FIGYELEM: Ha intibe mentek frissítsétek a parancsot, töröljétek a pajzsot majd vegyétek elõ újra.");
				SendClientMessage(playerid, 0xFF2F00FF, "FIGYELEM: Halál után töröld a SWAT pajzsot mert bajok lesznek.");
				SendClientMessage(playerid, 0xFF2F00FF, "FIGYELEM: Amint elõveszed a Pajzsot írd be: /cop.");
				SendClientMessage(playerid, 0xFFAE00FF, "Használat(Rang 1): p1, p2, p3");
				SendClientMessage(playerid, 0xFFAE00FF, "Törlés(Rang 1): t1, t2, t3");
				SendClientMessage(playerid, 0xFFAE00FF, "Újratöltés(Rang 1): r1, r2, r3");
				SendClientMessage(playerid, 0xFF2F00FF, "Engedélyezés(Rang 3): engedélyezés, betiltás");
				SendClientMessage(playerid, 0xFF2F00FF, "Bugos object esetén(Rang 4): újratöltés");
				return 1;
			}
			if(strcmp(tmp, "p1", true) == 0)
			{
				if(IsValidPlayerID(playerid))
				{
					if(pajzs1 == 0)
					{
					    if(swatpajzs == 1)
					    {
					    	if(PlayerInfo[playerid][pSWATTag] >= 1 && PlayerInfo[playerid][pSWATRang]  >= 1)
							{
								if(pajzsnala[playerid] == 0)
								{
									Cselekves(playerid, "elõvette az 1-es S.W.A.T. Pajzsot.");
									new Float:x, Float:y, Float:z;
									GetPlayerPos(playerid, x, y, z);
									pajzsnala[playerid] = 1;
									spajzs1 = CreateObject(1555,x,y,z,0,0,0);
									AttachObjectToPlayer(spajzs1,playerid,0.7,0.5,1,0,180,0);
									pajzs1 = 1;
									Swat3D[playerid] = CreateDynamic3DTextLabel("SWAT PAJZS", COLOR_WHITE, 0.0, 0.0, 0.5, 40.0, playerid);
									return 1;
								}
							}
							else
							{
								SendClientMessage(playerid, 0xFF2F00FF, "Nincs engedélyezve a S.W.A.T. Pajzs!");
								return 1;
							}
						}
					}
				}
			}
			if(strcmp(tmp, "p2", true) == 0)
			{
				if(IsValidPlayerID(playerid))
				{
					if(pajzs2 == 0)
					{
						if(swatpajzs == 1)
						{
							if(PlayerInfo[playerid][pSWATTag] >= 1 && PlayerInfo[playerid][pSWATRang]  >= 1)
							{
								if(pajzsnala[playerid] == 0)
								{
									Cselekves(playerid, "elõvette a 2-es S.W.A.T. Pajzsot.");
									new Float:x, Float:y, Float:z;
									GetPlayerPos(playerid, x, y, z);
									spajzs2 = CreateObject(1555,x,y,z,0,0,0);
									AttachObjectToPlayer(spajzs2,playerid,0.7,0.5,1,0,180,0);
									pajzs2 = 1;
									pajzsnala[playerid] = 2;
									Swat3D[playerid] = CreateDynamic3DTextLabel("SWAT PAJZS", COLOR_WHITE, 0.0, 0.0, 0.5, 40.0, playerid);
									return 1;
								}
							}
							else
							{
								SendClientMessage(playerid, 0xFF2F00FF, "Nincs engedélyezve a S.W.A.T. Pajzs!");
								return 1;
							}
						}
					}
				}
			}
			if(strcmp(tmp, "p3", true) == 0)
			{
				if(IsValidPlayerID(playerid))
				{
					if(pajzs3 == 0)
					{
					    if(swatpajzs == 1)
		 				{
			            	if(PlayerInfo[playerid][pSWATTag] >= 1 && PlayerInfo[playerid][pSWATRang]  >= 1)
							{
								if(pajzsnala[playerid] == 0)
								{
									Cselekves(playerid, "elõvette a 3-as S.W.A.T. Pajzsot.");
									new Float:x, Float:y, Float:z;
									GetPlayerPos(playerid, x, y, z);
									spajzs3 = CreateObject(1555,x,y,z,0,0,0);
									AttachObjectToPlayer(spajzs3,playerid,0.7,0.5,1,0,180,0);
									pajzs3 = 1;
									pajzsnala[playerid] = 3;
									Swat3D[playerid] = CreateDynamic3DTextLabel("SWAT PAJZS", COLOR_WHITE, 0.0, 0.0, 0.5, 40.0, playerid);
									return 1;
								}
							}
							else
							{
								SendClientMessage(playerid, 0xFF2F00FF, "Nincs engedélyezve a S.W.A.T. Pajzs!");
								return 1;
							}
						}
					}
				}
   			}
			if(strcmp(tmp, "t1", true) == 0)
			{
				if(IsValidPlayerID(playerid))
				{
					if(pajzs1 == 1)
					{
		            	if(PlayerInfo[playerid][pSWATTag] >= 1 && PlayerInfo[playerid][pSWATRang]  >= 1)
						{
							if(pajzsnala[playerid] == 1)
							{
								Cselekves(playerid, "eltette az 1-es S.W.A.T. Pajzsot.");
								DestroyObject(spajzs1);
								pajzs1 = 0;
								pajzsnala[playerid] = 0;
								if(IsValidDynamic3DTextLabel(Swat3D[playerid]))
									DestroyDynamic3DTextLabel(Swat3D[playerid]);
							//	Swat3D[playerid] = NINCS;
								return 1;
							}
						}
					}
		  		}
			}
			if(strcmp(tmp, "t2", true) == 0)
			{
				if(IsValidPlayerID(playerid))
				{
					if(pajzs2 == 1)
					{
						if(PlayerInfo[playerid][pSWATTag] >= 1 && PlayerInfo[playerid][pSWATRang]  >= 1)
						{
							if(pajzsnala[playerid] == 2)
							{
								Cselekves(playerid, "eltette a 2-es S.W.A.T. Pajzsot.");
								DestroyObject(spajzs2);
								pajzs2 = 0;
								pajzsnala[playerid] = 0;
								if(IsValidDynamic3DTextLabel(Swat3D[playerid]))
									DestroyDynamic3DTextLabel(Swat3D[playerid]);
							//	Swat3D[playerid] = NINCS;
								return 1;
							}
						}
					}
		  		}
			}
			if(strcmp(tmp, "t3", true) == 0)
			{
				if(IsValidPlayerID(playerid))
				{
					if(pajzs3 == 1)
					{
						if(PlayerInfo[playerid][pSWATTag] >= 1 && PlayerInfo[playerid][pSWATRang]  >= 1)
						{
							if(pajzsnala[playerid] == 3)
							{
								Cselekves(playerid, "eltette a 3-as S.W.A.T. Pajzsot.");
								DestroyObject(spajzs3);
								pajzs3 = 0;
								pajzsnala[playerid] = 0;
								if(IsValidDynamic3DTextLabel(Swat3D[playerid]))
									DestroyDynamic3DTextLabel(Swat3D[playerid]);
						//		Swat3D[playerid] = NINCS;
								return 1;
							}
						}
					}
		  		}
			}
			if(strcmp(tmp, "r1", true) == 0)
			{
				if(IsValidPlayerID(playerid))
				{
					if(pajzsnala[playerid] == 1)
					{
						Cselekves(playerid, "elõvette az 1-es S.W.A.T. Pajzsot.");
						new Float:x, Float:y, Float:z;
						GetPlayerPos(playerid, x, y, z);
						AttachObjectToPlayer(spajzs1,playerid,0.7,0.5,1,0,180,0);
						pajzs1 = 1;
						pajzsnala[playerid] = 1;
						Swat3D[playerid] = CreateDynamic3DTextLabel("SWAT PAJZS", COLOR_WHITE, 0.0, 0.0, 0.5, 40.0, playerid);
						return 1;
					}
				}
			}
			if(strcmp(tmp, "r2", true) == 0)
			{
				if(IsValidPlayerID(playerid))
				{
					if(pajzsnala[playerid] == 2)
					{
						Cselekves(playerid, "elõvette a 2-es S.W.A.T. Pajzsot.");
						new Float:x, Float:y, Float:z;
						GetPlayerPos(playerid, x, y, z);
						AttachObjectToPlayer(spajzs2,playerid,0.7,0.5,1,0,180,0);
						pajzs2 = 1;
						pajzsnala[playerid] = 2;
						Swat3D[playerid] = CreateDynamic3DTextLabel("SWAT PAJZS", COLOR_WHITE, 0.0, 0.0, 0.5, 40.0, playerid);
						return 1;
					}
				}
			}
			if(strcmp(tmp, "r3", true) == 0)
			{
				if(IsValidPlayerID(playerid))
				{
					if(pajzsnala[playerid] == 3)
					{
						Cselekves(playerid, "elõvette a 3-as S.W.A.T. Pajzsot.");
						new Float:x, Float:y, Float:z;
						GetPlayerPos(playerid, x, y, z);
						AttachObjectToPlayer(spajzs3,playerid,0.7,0.5,1,0,180,0);
						pajzs3 = 1;
						pajzsnala[playerid] = 3;
						Swat3D[playerid] = CreateDynamic3DTextLabel("SWAT PAJZS", COLOR_WHITE, 0.0, 0.0, 0.5, 40.0, playerid);
						return 1;
					}
				}
			}
			if(strcmp(tmp, "engedélyezés", true) == 0)
			{
            	if(PlayerInfo[playerid][pSWATTag] >= 1 && PlayerInfo[playerid][pSWATRang]  >= 3)
				{
					GetPlayerName(playerid, sendername, sizeof(sendername));
					format(string, sizeof(string), "** %s engedélyezte a S.W.A.T. Pajzsok használatát! **", sendername);
					SendSWATRadioMessage(TEAM_ORANGE_COLOR, string);
					DestroyObject(spajzs1);
					pajzs1 = 0;
					DestroyObject(spajzs2);
					pajzs2 = 0;
					DestroyObject(spajzs3);
					pajzs3 = 0;
					swatpajzs = 1;
					return 1;
				}
			}
			if(strcmp(tmp, "betiltás", true) == 0)
			{
				if(PlayerInfo[playerid][pSWATTag] >= 1 && PlayerInfo[playerid][pSWATRang]  >= 3)
				{
					GetPlayerName(playerid, sendername, sizeof(sendername));
					format(string, sizeof(string), "** %s betiltotta a S.W.A.T. Pajzsok használatát! **", sendername);
					SendSWATRadioMessage(TEAM_ORANGE_COLOR, string);
					DestroyObject(spajzs1);
					pajzs1 = 0;
					DestroyObject(spajzs2);
					pajzs2 = 0;
					DestroyObject(spajzs3);
					pajzs3 = 0;
					swatpajzs = 0;
					PlayerForeach(i)
					{
						if(IsValidPlayerID(i))
						{
							if(PlayerInfo[playerid][pSWATTag]  == 1)
							{
								pajzsnala[i] = 0;
								if(IsValidDynamic3DTextLabel(Swat3D[i]))
									DestroyDynamic3DTextLabel(Swat3D[i]);
					//			Swat3D[i] = NINCS;
							}
						}
					}
				}
			}
		}
		return 1;
	}
	if(egyezik(cmd, "/pajzs"))
	{
		//if(!IsACop(playerid)) return Msg(playerid, "Nem vagy rendõr!");
		if(PlayerInfo[playerid][pSWATTag] == 0 && !IsFejleszto(playerid)) return Msg(playerid, "Nem vagy SWAT Tag!");
		if(params < 1) return Msg(playerid, "/pajzs [Kivesz / Visszarak]");
		if(egyezik(param[1], "kivesz"))
		{
			new kocsi = GetClosestVehicle(playerid);
			if(GetDistanceToVehicle(playerid,kocsi) <= 3.0)
			{
				if(GetVehicleModel(kocsi) != 427) return Msg(playerid, "Enforcer közelében kell lenned!");

				Cselekves(playerid, "kivett egy pajzsot az enforcerbõl",1);
				Msg(playerid, "Kivetted a pajzsot a enforcerbõl! Elõvétel: /f e pajzs | Elrakás: /f k pajzs");
				PajzsFelrakva[playerid] = 1;

				Pajzs_Hatra(playerid);
			}
			else
			{
				Msg(playerid, "Nincs a közelben jármû!");
			}
		}
		else if(egyezik(param[1], "visszarak"))
		{
			new kocsi = GetClosestVehicle(playerid);
			if(GetDistanceToVehicle(playerid,kocsi) <= 3.0)
			{
				if(GetVehicleModel(kocsi) != 427) return Msg(playerid, "Enforcer közelében kell lenned!");

				Cselekves(playerid, "visszarakta a pajzsot az enforcerbe",1);
				RemovePlayerAttachedObject(playerid,SLOT_SWATPAJZS);
				PajzsFelrakva[playerid] = 0;
			}
			else
			{
				Msg(playerid, "Nincs a közelben jármû!");
			}
		}
		return 1;
	}
	
	if(egyezik(cmd, "/abiz"))
	{
		if(!Admin(playerid, 5)) return HibasParancs(playerid, true);
		if(params < 1) return Msg(playerid, "/abiznisz [Lerak/Töröl/Áthelyez/Infó]", COLOR_ADMIN);
		new query[MAX_MYSQL_STRING];
		if(egyezik(param[1], "lerak"))
		{
			if(params < 2) return Msg(playerid, "/biznisz lerak [ár]", COLOR_ADMIN);
			
			new 
				biznum = UresBizniszHely(),
				ar = strval(param[2]), 
				Float:ppos[3]
			;
		
			if(biznum == NINCS) return Msg(playerid, "Nem rakható le több biznisz!");			
			GetPlayerPos(playerid, ppos[0], ppos[1], ppos[2]);
			
			Format(query, "INSERT INTO `biz` (`bid`,`ar`,`enposx`,`enposy`,`enposz`,`enposint`,`enposvw`) VALUES('%i','%i','%f','%f','%f','%i','%i')", biznum, ar, ppos[0], ppos[1], ppos[2], GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));
			mysql_query(query);
			
			CreateBiznisz(biznum);
			
			PlayerTextFormat(playerid, "(%s) %s lerakott egy üzlethelységet. Ára: $%s", AdminSzint(playerid), PlayerName(playerid), PenzTordeles(ar));
			ABroadCast(COLOR_LIGHTRED, PlayerText[playerid], 1);
		}
		else if(egyezik(param[1], "töröl"))
		{
			if(params < 2) return Msg(playerid, "/biznisz töröl [ID]", COLOR_ADMIN);
			new bid = strval(param[2]);
			if(bInfo[bid][bID] == -1 || bid < 0) return Msg(playerid,"Nincs ilyen üzletID!");
			Format(query, "DELETE FROM `biz` WHERE `bid`='%i'", bInfo[bid][bID]);
			mysql_query(query);
			bInfo[bid][bID] = NINCS;
			DestroyDynamicPickup(bInfo[bid][bPick]);
			
			PlayerTextFormat(playerid, "(%s) %s törölt egy %s nevû bizniszt. BizniszID: %d", AdminSzint(playerid), PlayerName(playerid), bInfo[bid][bNev], bid);
			ABroadCast(COLOR_LIGHTRED, PlayerText[playerid], 1);
		}
		else if(egyezik(param[1], "infó") || egyezik(param[1], "info"))
		{
			new bid = CheckPos(playerid, "ÜZLETELÕTT");
			if(bid == NINCS) return Msg(playerid, "Nem vagy biznisz elõtt!", COLOR_ADMIN);
			
			PlayerTextFormat(playerid, "Biznisz ID: %d | Tulajdonos %s | Típus: ", bid, bInfo[bid][bTulaj]);
			Msg(playerid, PlayerText[playerid], COLOR_ADMIN);
		}
		return 1;
	}
	if(egyezik(cmd, "/üzletvásárlás") || egyezik(cmd, "/uzletvasarlas"))
	{
		new bid = CheckPos(playerid, "ÜZLETELÕTT");
		if(bid == NINCS || !egyezik(bInfo[bid][bTulaj], "Eladó")) return Msg(playerid, "Nem vagy egy eladó üzlethelységnél sem!");
		if(bInfo[bid][bAr] > GetMoney(playerid))
		{
			MsgFormat(playerid, "Ez az üzlethelység $%s-ba kerül amelyre neked nincs elég pénzed!", PenzTordeles(bInfo[bid][bAr]));
			return 1;
		}
		SetPVarInt(playerid, "BBuyID", bid);
		ShowPlayerDialog(playerid, DIALOG_BizTypes, DIALOG_STYLE_LIST, "Milyen kategóriában szeretnél üzletet nyitni?", BIZTYPEDIALOG, "Választ", "Mégse");
		return 1;
	}
	if(egyezik(cmd, "/vásárlóhely") || egyezik(cmd, "/vásárláshely") || egyezik(cmd, "/vasarlohely"))
	{
		if(!Admin(playerid, 3)) return HibasParancs(playerid, true);
		if(params < 1) return Msg(playerid, "/vásárlóhely [Lerak/Töröl/Infó]", COLOR_ADMIN);
		if(egyezik(param[1], "lerak"))
		{
			if(params < 2) return Msg(playerid, "/vásárlóhely lerak [Üzlet amelyhez hozzákötöd]", COLOR_ADMIN);
			new bid = strval(param[2]);
			if(bInfo[bid][bID] == NINCS || bid < 0) return Msg(playerid, "Nincs ilyen ÜzletID!", COLOR_ADMIN);
			
			new 
				Float:pos[3], 
				query[MAX_MYSQL_STRING],
				id = UresVasarlasHely()
			;
			GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
			
			Format(query, "INSERT INTO `buys` (`bid`,`type`,`biz`,`posx`,`posy`,`posz`,`vw`,`int`) VALUES('%i','%i','%i','%f','%f','%f','%i','%i')", id, bInfo[bid][bType], bInfo[bid][bID], pos[0], pos[1], pos[2], GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
			mysql_query(query);
			
			CreateVasarlasHely(id);
			
			PlayerTextFormat(playerid, "(%s) %s lerakott egy vásárlóhelyet. ID: %d", AdminSzint(playerid), PlayerName(playerid), bid);
			ABroadCast(COLOR_LIGHTRED, PlayerText[playerid], 1);
		}
		else if(egyezik(param[1], "töröl"))
		{
			new bid = strval(param[2]);
			if(buInfo[bid][bID] == NINCS || bid < 0) return Msg(playerid, "Nincs ilyen ÜzletID!", COLOR_ADMIN);
			
			if(buInfo[bid][bID] == -1 || bid < 0) return Msg(playerid, "Nincs ilyen üzletID!");
			new query[MAX_MYSQL_STRING];
			Format(query, "DELETE FROM `buys` WHERE `bid`='%i'", buInfo[bid][buID]);
			mysql_query(query);
			buInfo[bid][buID] = NINCS;
			DestroyDynamicPickup(buInfo[bid][buPick]);
			
			PlayerTextFormat(playerid, "(%s) %s törölt egy vásárlóhelyet. ID: %d", AdminSzint(playerid), PlayerName(playerid), bid);
			ABroadCast(COLOR_LIGHTRED, PlayerText[playerid], 1);
		}
		else if(egyezik(param[1], "infó"))
		{
			new vid = CheckPos(playerid, "VÁSÁRLÓHELY");
			if(vid == NINCS) return Msg(playerid, "Nem vagy vásárlóhely elõtt!", COLOR_ADMIN);
			
			PlayerTextFormat(playerid, "Vásárlóhely ID: %d | Tulajdonos biz.: %s | Típus: %d", vid, buInfo[vid][buBiz], buInfo[vid][buType]);
			Msg(playerid, PlayerText[playerid], COLOR_ADMIN);
		}
		return 1;
	}
	if(egyezik(cmd, "/frakcioskin") || egyezik(cmd, "/frakcióskin")/* || egyezik(cmd, "/clothes")*/)
	{
		new frakcio = PlayerInfo[playerid][pMember];
	    if(frakcio < 1) return Msg(playerid, "Nem vagy frakció tagja!");
	    if(!IsAtClothShop(playerid)) return Msg(playerid, "Nem vagy ruhaboltban!");
		
		new 
			cim[14] = "Frakció skin",
			Float:PrewX = -25.0000,
			Float:PrewY = 0.0000,
			Float:PrewZ = 0.0000
		;
		
		switch(frakcio)
		{
			case 1: // LSPD
			{ 
				new FrakcioSkinList[10] = {280, 281, 282, 283, 284, 285, 286, 288, 300, 302}; 
				ShowModelSelectionMenuEx(playerid, FrakcioSkinList, sizeof(FrakcioSkinList), cim, FrakcioSkinValaszto, PrewX, PrewY, PrewZ);
			}
			case 4: // LSFD
			{ 
				new FrakcioSkinList[8] = {70, 71, 274, 275, 276, 277, 279, 280};
				ShowModelSelectionMenuEx(playerid, FrakcioSkinList, sizeof(FrakcioSkinList), cim, FrakcioSkinValaszto, PrewX, PrewY, PrewZ);				
			}
			default:
			{
				Msg(playerid, "Nincsenek a frakcióhoz skinek párosítva!");
			}
		}
	    return 1;
	}
	if(egyezik(cmd, "/taxicall"))
	{
		if(params < 1) return Msg(playerid, "Használat: /taxicall [célállomás]");
		
		new result[200];
		new length = strlen(cmdtext);
		while ((idx < length) && (cmdtext[idx] <= ' '))
		{
			idx++;
		}
		new offset = idx;
		while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
		{
			result[idx - offset] = cmdtext[idx];
			idx++;
		}
		result[idx - offset] = EOS;
		
		new s[128], taxisok = 0;
		PlayerForeach(i)
		{
			if(IsValidPlayerID(i))
			{
				if(GetPVarInt(i, "TaxiLicense") == 100)
				{
					if(GetPVarInt(i, "taxi_job_duty") == 1)
					{
						SendClientMessage(i, COLOR_YELLOW, "|____________Taxi Hívás____________|");
						format(s, 128, "** [%d]%s hívott egy taxit.", playerid, PlayerName(playerid));
						SendClientMessage(i, COLOR_YELLOW, s);
						format(s, 128, "Célállomás: %s", result);
						SendClientMessage(i, COLOR_YELLOW, s);
						SendClientMessage(i, COLOR_YELLOW, "** /taxi accept ID, hogy elfogadd a missziót! **");

						SetPVarInt(playerid, "taxi_call_accepted", 1);
						SetPVarString(playerid, "taxi_call_destination", result);
						
						taxisok ++;
					}
				}
			}
		}
		
		if(taxisok == 0)
			Msg(playerid, "Sajnos nincs elérhetõ taxis a szerveren!");
		else
			SendClientMessage(playerid, COLOR_YELLOW, "Sikeresen hívtál egy taxit!");
			
		return 1;
	}
	if(egyezik(cmd, "/licenseexam"))
	{
		if(GetPVarInt(playerid, "TaxiLicense") < 1)
		{
			taxi_exam_newcp(playerid);

			SendClientMessage(playerid, COLOR_LIGHTRED, "__________Fõ Vezetési szabályok[Taxi]:__________");
			SendClientMessage(playerid, COLOR_LIGHTRED, "1) Az út jobb oldalán közlekedj!");
			SendClientMessage(playerid, COLOR_LIGHTRED, "2) Ne vezess túl gyorsan!");
			SendClientMessage(playerid, COLOR_LIGHTRED, "3) Tiszteld a többi sofõrt az utakon!");
			SendClientMessage(playerid, COLOR_GREEN, "Most menj bele a jelzésbe majd menj végig az útvonalon!");
			SendClientMessage(playerid, COLOR_GREEN, "Ne vezess túl gyorsan, mert balesetet okozhatsz az utakon!");

		} else SendClientMessage(playerid, COLOR_LIGHTRED, "Már elkezdted a taxis vizsgát!");
		return 1;
	}
	if(egyezik(cmd, "/saveattach"))
	{
		if(!IsFejleszto(playerid)) return HibasParancs(playerid, true);
		
		if(!AttacheInfoSave)
		{
			AttacheInfoSave = true;
			Msg(playerid, "AttacheInfo mentés bekapcsolva!");
		}
		else
		{
			AttacheInfoSave = false;
			Msg(playerid, "AttacheInfo mentés kikapcsolva!");
		}
		
		return 1;
	}
	if(egyezik(cmd, "/take"))
	{
        if(!IsACop(playerid) && PlayerInfo[playerid][pAdmin] < FOADMIN) return Msg(playerid, "Nem vagy rendõr!");
        if(!LMT(playerid, LMUNKA_FBI) && PlayerInfo[playerid][pRank] < 1 && PlayerInfo[playerid][pAdmin] < FOADMIN && !LMT(playerid,LMUNKA_SWAT) && PlayerInfo[playerid][pSWATTag] == 0) return Msg(playerid, "Minimum 1-es rangúnak kell lenned!");

		if(PlayerInfo[playerid][pJailed] != 0) return 1;

		if(params < 1)
		{
			Msg(playerid, "|__________________ Elvehetõ dolgok __________________|");
			Msg(playerid, "Használat: /take [mit] [JátékosID/NévRészlet]");
			Msg(playerid, "Engedélyek: Autó, Motor, Csomagszallito, Repülõ, Hajó, Fegyverengedély");
	 		Msg(playerid, "|--------------------Tárgyaknál nem kell név------------|");
	 		Msg(playerid, "Tárgyak: Fegyver, Drog(Heroin,Kokain, Marihuana), Mati");
			Msg(playerid, "|___________________________________________________|");
			return 1;
		}
	    if(egyezik(param[1], "autó") || egyezik(param[1], "auto"))
		{
			if(params < 2) return Msg(playerid, "Használat: /take autó [JátékosID/NévRészlet]");
			giveplayerid = ReturnUser(param[2]);
			if(!IsValidPlayerID(giveplayerid) || giveplayerid == INVALID_PLAYER_ID) return Msg(playerid, "Nem online játékos!");
			if(!ProxDetectorS(8.0, playerid, giveplayerid)) return Msg(playerid, "Nincs a közeledben!");
			SendFormatMessage(playerid, COLOR_LIGHTBLUE, "* Elvetted %s autó jogositványát", PlayerName(giveplayerid));
			SendClientMessage(giveplayerid, COLOR_LIGHTBLUE, "Elvették a kocsijogsid");
			PlayerInfo[giveplayerid][pCarLic] = 0;
			return 1;
		}
		else if(egyezik(param[1], "Motor"))
		{
			if(params < 2) return Msg(playerid, "Használat: /take motor [JátékosID/NévRészlet]");
			giveplayerid = ReturnUser(param[2]);
			if(!IsValidPlayerID(giveplayerid) || giveplayerid == INVALID_PLAYER_ID) return Msg(playerid, "Nem online játékos!");
			if(!ProxDetectorS(8.0, playerid, giveplayerid)) return Msg(playerid, "Nincs a közeledben!");
			SendFormatMessage(playerid, COLOR_LIGHTBLUE, "* Elvetted %s motor jogositványát", PlayerName(giveplayerid));
			SendClientMessage(giveplayerid, COLOR_LIGHTBLUE, "Elvették a motor jogsid");
			PlayerInfo[giveplayerid][pMotorJogsi] = 0;
			return 1;
		}
		else if(egyezik(param[1], "Csomagszallito"))
		{
			if(params < 2) return Msg(playerid, "Használat: /take Csomagszallito [JátékosID/NévRészlet]");
			giveplayerid = ReturnUser(param[2]);
			if(!IsValidPlayerID(giveplayerid) || giveplayerid == INVALID_PLAYER_ID) return Msg(playerid, "Nem online játékos!");
			if(!ProxDetectorS(8.0, playerid, giveplayerid)) return Msg(playerid, "Nincs a közeledben!");
			SendFormatMessage(playerid, COLOR_LIGHTBLUE, "* Elvetted %s Csomagszallito jogositványát", PlayerName(giveplayerid));
			SendClientMessage(giveplayerid, COLOR_LIGHTBLUE, "Elvették a Csomagszallito jogsid");
			PlayerInfo[giveplayerid][pCsomagszallitoJogsi] = 0;
			return 1;
		}
		else if(egyezik(param[1], "repülõ") || egyezik(param[1], "repulo"))
		{
			if(params < 2) return Msg(playerid, "Használat: /take repülõ [JátékosID/NévRészlet]");
			giveplayerid = ReturnUser(param[2]);
			if(!IsValidPlayerID(giveplayerid) || giveplayerid == INVALID_PLAYER_ID) return Msg(playerid, "Nem online játékos!");
			if(!ProxDetectorS(8.0, playerid, giveplayerid)) return Msg(playerid, "Nincs a közeledben!");
			SendFormatMessage(playerid, COLOR_LIGHTBLUE, "* Elvetted %s repülõengedélyét", PlayerName(giveplayerid));
			SendClientMessage(giveplayerid, COLOR_LIGHTBLUE, "Elvették a repülõengedélyed");
			PlayerInfo[giveplayerid][pFlyLic] = 0;
			return 1;
		}
		else if(egyezik(param[1], "fegyverengedély") || egyezik(param[1], "fegyverengedely"))
		{
			if(params < 2) return Msg(playerid, "Használat: /take fegyverengedély [JátékosID/NévRészlet]");
			giveplayerid = ReturnUser(param[2]);
			if(!IsValidPlayerID(giveplayerid) || giveplayerid == INVALID_PLAYER_ID) return Msg(playerid, "Nem online játékos!");
			if(!ProxDetectorS(8.0, playerid, giveplayerid)) return Msg(playerid, "Nincs a közeledben!");
			SendFormatMessage(playerid, COLOR_LIGHTBLUE, "* Elvetted %s fegyverengedélyét", PlayerName(giveplayerid));
			SendClientMessage(giveplayerid, COLOR_LIGHTBLUE, "Elvették a fegyverengedélyed");
			PlayerInfo[giveplayerid][pGunLic] = 0;
			return 1;
		}
		else if(egyezik(param[1], "hajó") || egyezik(param[1], "hajo"))
		{
			if(params < 2) return Msg(playerid, "Használat: /take hajó [JátékosID/NévRészlet]");
			giveplayerid = ReturnUser(param[2]);
			if(!IsValidPlayerID(giveplayerid) || giveplayerid == INVALID_PLAYER_ID) return Msg(playerid, "Nem online játékos!");
			if(!ProxDetectorS(8.0, playerid, giveplayerid)) return Msg(playerid, "Nincs a közeledben!");
			SendFormatMessage(playerid, COLOR_LIGHTBLUE, "* Elvetted %s hajóengedélyét", PlayerName(giveplayerid));
			SendClientMessage(giveplayerid, COLOR_LIGHTBLUE, "Elvették a hajóengedélyed");
			PlayerInfo[giveplayerid][pBoatLic] = 0;
			return 1;
		}
		else if(egyezik(param[1], "fegyver"))
		{
			giveplayerid = GetClosestPlayer(playerid);
			if(!IsValidPlayerID(giveplayerid) || giveplayerid == INVALID_PLAYER_ID) return Msg(playerid, "Nem online játékos!");
			if(!ProxDetectorS(8.0, playerid, giveplayerid)) return Msg(playerid, "Nincs a közeledben!");
			SendFormatMessage(playerid, COLOR_LIGHTBLUE, "* Elvetted %s fegyvereit", PlayerName(giveplayerid));
			SendClientMessage(giveplayerid, COLOR_LIGHTBLUE, "Elvették a fegyvereidet");
			ResetWeapon(giveplayerid);
			SetPlayerArmedWeapon(giveplayerid, 0);
			return 1;
		}
		else if(egyezik(param[1], "drog"))
		{
			giveplayerid = GetClosestPlayer(playerid);
			if(!IsValidPlayerID(giveplayerid) || giveplayerid == INVALID_PLAYER_ID) return Msg(playerid, "Nem online játékos!");
			if(!ProxDetectorS(8.0, playerid, giveplayerid)) return Msg(playerid, "Nincs a közeledben!");
		    SendFormatMessage(playerid, COLOR_LIGHTBLUE, "* Elvetted %s összes drogját (kokain/heroin)", PlayerName(giveplayerid));
			SendClientMessage(giveplayerid, COLOR_LIGHTBLUE, "Elvették a drogjaid (kokain/heroin)");
			PlayerInfo[giveplayerid][pKokain] = 0;
			PlayerInfo[giveplayerid][pHeroin] = 0;
			PlayerInfo[giveplayerid][pMarihuana] = 0;
			return 1;
		}
		else if(egyezik(param[1], "mati"))
		{
			giveplayerid = GetClosestPlayer(playerid);
			if(!IsValidPlayerID(giveplayerid) || giveplayerid == INVALID_PLAYER_ID) return Msg(playerid, "Nem online játékos!");
			if(!ProxDetectorS(8.0, playerid, giveplayerid)) return Msg(playerid, "Nincs a közeledben!");
			SendFormatMessage(playerid, COLOR_LIGHTBLUE, "* Elvetted %s minden matiját", PlayerName(giveplayerid));
			SendClientMessage(giveplayerid, COLOR_LIGHTBLUE, "Elvették a matijaid");
			PlayerInfo[giveplayerid][pMats] = 0;
			return 1;
		}
		else return Msg(playerid, "Szerintem elírtál valamit !");
	}
 	if(strcmp(cmd, "/showlicenses", true)==0 || strcmp(cmd, "/engedelyek", true)==0 || strcmp(cmd, "/engedélyek", true)==0)
    {
        if(IsValidPlayerID(playerid))
	    {
	        tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				Msg(playerid, "Használat: /engedélyek [JátékosID/NévRészlet]");
				return 1;
			}
			giveplayerid = ReturnUser(tmp);
			if(IsValidPlayerID(giveplayerid))
			{
				if(giveplayerid != INVALID_PLAYER_ID)
				{
				    if(ProxDetectorS(8.0, playerid, giveplayerid))
					{
					   //if(giveplayerid == playerid) { Msg(playerid, "Magadnak nem tudod megmutatni! Használd a /licenses parancsot!"); return 1; }
					    GetPlayerName(giveplayerid, giveplayer, sizeof(giveplayer));
						GetPlayerName(playerid, sendername, sizeof(sendername));
					    new text1[20];
				        new text2[20];
				        new text3[20];
				        new text4[20];
				        new text5[20];
						new text6[20];
				        new text7[20];
						if(PlayerInfo[playerid][pCarLic] > 0) { text1 = "Van"; } else { text1 = "Nincs"; }
                        if(PlayerInfo[playerid][pFlyLic] > 0) { text4 = "Van"; } else { text4 = "Nincs"; }
						if(PlayerInfo[playerid][pBoatLic] > 0) { text2 = "Van"; } else { text2 = "Nincs"; }
				        if(PlayerInfo[playerid][pFishLic] > 0) { text3 = "Van"; } else { text3 = "Nincs"; }
				        if(PlayerInfo[playerid][pGunLic] > 0) { text5 = "Van"; } else { text5 = "Nincs"; }
						if(PlayerInfo[playerid][pMotorJogsi] > 0) { text6 = "Van"; } else { text6 = "Nincs"; }
				        if(PlayerInfo[playerid][pCsomagszallitoJogsi] > 0) { text7 = "Van"; } else { text7 = "Nincs"; }
						
						if(PlayerInfo[playerid][pHamisNev] == 0)
							format(string, sizeof(string), "|__________%s Engedélyei __________|", sendername);
						else
							SendFormatMessage(giveplayerid, COLOR_GRAD2, "|__________%s Engedélyei __________|", PlayerInfo[playerid][pHamisNev]);

				        SendClientMessage(giveplayerid, COLOR_WHITE, string);
						if(PlayerInfo[playerid][pCarLic] > 0)
							format(string, sizeof(string), "** Autó jogsi: %s - Lejár: %d hónap((óra)) múlva.", text1, PlayerInfo[playerid][pCarLic]);
						else
							format(string, sizeof(string), "** Autó jogsi: %s - Lejár: lejárt.", text1);
						SendClientMessage(giveplayerid, COLOR_GREY, string);
						if(PlayerInfo[playerid][pMotorJogsi] > 0)
							format(string, sizeof(string), "** Motor jogsi: %s - Lejár: %d hónap((óra)) múlva.", text6, PlayerInfo[playerid][pMotorJogsi]);
						else
							format(string, sizeof(string), "** Motor jogsi: %s - Lejár: lejárt.", text6);
						SendClientMessage(giveplayerid, COLOR_GREY, string);

						if(PlayerInfo[playerid][pHamisNev] == 0)
				        format(string, sizeof(string), "%s megmutatta neked az engedélyeit.", sendername);
						else
							SendFormatMessage(giveplayerid, COLOR_GRAD2, "%s megmutatta neked az engedélyeit.", PlayerInfo[playerid][pHamisNev]);
						SendClientMessage(giveplayerid, COLOR_LIGHTBLUE, string);
						format(string, sizeof(string), "* Megmutattad az engedélyeidet neki: %s.", giveplayer);
						SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
						format(string, sizeof(string), "* Valaki elõvette az egyik iratát és felmutatta...");
						ProxDetector(30.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);

					}
					else
					{
					    Msg(playerid, "Ez a játékos nincs a közelben!");
					    return 1;
					}
				}
			}
	        else
	        {
	            Msg(playerid, "A játékos nincs fennt!");
	            return 1;
	        }
		}
	    return 1;
 	}

	if(egyezik(cmd, "/lakcímkártya") || egyezik(cmd, "/lakcimkartya"))
    {
		if(params < 1) return Msg(playerid, "/lakcimkartya [Csináltat / Felmutat / Megnéz]");
		if(egyezik(param[1], "felmutat"))
		{
			if(PlayerInfo[playerid][pLakcimkartya] < 1) return Msg(playerid, "Nincs lakcímkártyád!");
			if(params < 2) return Msg(playerid, "/lakcímkártya felmutat [JátékosID/NévRészlet]");
			giveplayerid = ReturnUser(param[2]);
			if(!IsValidPlayerID(giveplayerid)) return Msg(playerid, "A játékos nincs fennt!");
			if(!ProxDetectorS(8.0, playerid, giveplayerid)) return Msg(playerid, "Ez a játékos nincs a közelben!");
			//if(playerid == giveplayerid) return Msg(playerid, "Saját magadnak ne mutasd fel! Használd a /iratok parancsot!");
			
			Cselekves(playerid, "elõvette az egyik iratát és felmutatta...", 0);
			Msg(giveplayerid, "Az elrakáshoz használd a /lakcímkártya elrak parancsot!");

			Cselekves(playerid, "elõvette az egyik iratát és felmutatta...", 1);
		}
		else if(egyezik(param[1], "elrak") OR egyezik(param[1], "eltesz"))
		{
			Msg(playerid, "Lakcímkártya elrakva!");
		}
		else if(egyezik(param[1], "csináltat") || egyezik(param[1], "csinaltat"))
		{
			if(!PlayerToPoint(2.0, playerid, 2232.5579, 1678.3125, 1008.4016))
			{
				ShowPlayerDialog(playerid, DIALOG_NINCS, DIALOG_STYLE_MSGBOX, "Információ", "Ön jelenleg nem tartózkodik az okmányirodában!", "Bezárás", "");
				return 1;
			}
			new npc = ReturnUser("NPC_VH_Ugyintezo");
			if(PlayerInfo[playerid][pLakcimkartya] > 0) 
			{
				Format(string, "Ügyintézõ mondja: Tisztelt %s önnek már van Lakcímet Igazoló Hatósági Igazolványa!", VezetekNev(playerid));
				ProxDetector(B_Normal, npc, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5);
				Format(string, "Tisztelt %s önnek már van Lakcímet Igazoló Hatósági Igazolványa!",VezetekNev(playerid));
				SetPlayerChatBubble(npc, string, COLOR_WHITE, B_Normal, 5000);
				return 1;
			}
			new ar = 20;
			if(GetMoney(playerid) < ar)
			{
				Format(string, "Ügyintézõ mondja: Tisztelt %s egy Lakcímet Igazoló Hatósági Igazolvány ára $%s!", VezetekNev(playerid), PenzTordeles(ar));
				ProxDetector(B_Normal, npc, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5);
				Format(string, "Tisztelt %s egy Lakcímet Igazoló Hatósági Igazolvány ára $%s!",VezetekNev(playerid), PenzTordeles(ar));
				SetPlayerChatBubble(npc, string, COLOR_WHITE, B_Normal, 5000);
				return 1;
			}
			
			IratKeszites(playerid, 0);
			
			FrakcioInfo[LMUNKA_ALLAM][fPenz] += ar;
			PlayerInfo[playerid][pLakcimkartya] = 50;
			GiveMoney(playerid, -ar);
			return 1;
		}
		else if(egyezik(param[1], "megnéz") || egyezik(param[1], "megnez"))
		{
			if(PlayerInfo[playerid][pLakcimkartya] < 1) return Msg(playerid, "Nincs lakcímkártyád!");
			new neme[32];
			if(PlayerInfo[playerid][pSex] == 1)
				neme = "Férfi";
			else if(PlayerInfo[playerid][pSex] == 2)
				neme = "Nõ";
			else
				neme = "Semleges ((??))";
			Msg(playerid, "====== Lakcímkártyád ======");
			SendFormatMessage(giveplayerid, COLOR_GRAD2, "Neve: %s", PlayerName(playerid));
			if(PlayerInfo[playerid][pPhousekey] != NINCS) SendFormatMessage(playerid, COLOR_GRAD2, "Ház: Los Santos str. %d", PlayerInfo[playerid][pPhousekey]);
			if(PlayerInfo[playerid][pPhousekey2] != NINCS) SendFormatMessage(playerid, COLOR_GRAD2, "Ház: Los Santos str. %d", PlayerInfo[playerid][pPhousekey2]);
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "Érvényes: %d hónapig((óráig))!", PlayerInfo[playerid][pLakcimkartya]);
			Cselekves(playerid, "elõvette az egyik iratát és felmutatta...", 0);
		}
		else return Msg(playerid, "Funkciók: Vesz, Felmutat");
	    return 1;
 	}
	if(egyezik(cmd, "/személyi") || egyezik(cmd, "/szemelyi"))
    {
		if(params < 1) return Msg(playerid, "/személyi [Csináltat / Felmutat]");
		if(egyezik(param[1], "felmutat"))
		{
			//if(PlayerInfo[playerid][pSzemelyi] < 1) return Msg(playerid, "Nincs személyid!");
			if(params < 2) return Msg(playerid, "/személyi felmutat [JátékosID/NévRészlet]");
			giveplayerid = ReturnUser(param[2]);
			if(!IsValidPlayerID(giveplayerid)) return Msg(playerid, "A játékos nincs fennt!");
			if(!ProxDetectorS(8.0, playerid, giveplayerid)) return Msg(playerid, "Ez a játékos nincs a közelben!");
			//if(playerid == giveplayerid) return Msg(playerid, "Saját magadnak ne mutasd fel! Használd a /iratok parancsot!");
			
			ShowSzemelyi(playerid, giveplayerid, false);
			ShowSzemelyi(playerid, giveplayerid, true);
			
			new SoundID = 1058;
			PlayerPlaySound(playerid, SoundID, 0.0, 0.0, 0.0);
			PlayerPlaySound(giveplayerid, SoundID, 0.0, 0.0, 0.0);
			
			Cselekves(playerid, "elõvette az egyik iratát és felmutatta...", 0);
			MsgFormat(playerid, "Felmutattad a személyi igazolványod neki: [%d]%s", giveplayerid, PlayerName(giveplayerid));
			Msg(giveplayerid, "Az elrakáshoz használd a /személyi elrak parancsot!");
		}
		else if(egyezik(param[1], "elrak") || egyezik(param[1], "eltesz"))
		{
			ShowSzemelyi(playerid, playerid, false);
			iMsg(playerid, "Személyi elrakva!");
		}
		else if(egyezik(param[1], "csináltat") || egyezik(param[1], "csinaltat"))
		{
			if(!PlayerToPoint(2.0, playerid, 1455.0922,-1726.6500,1052.0149))
			{
				ShowPlayerDialog(playerid, DIALOG_NINCS, DIALOG_STYLE_MSGBOX, "Információ", "Ön jelenleg nem tartózkodik az okmányirodában!", "Bezárás", "");
				return 1;
			}
			new ar = 60;
			if(PlayerInfo[playerid][pSzemelyi] > 0) 
			{
				Format(string, "Ügyintézõ mondja: Tisztelt %s önnek már van Személyazonosító Igazolványa!", VezetekNev(playerid));
				Msg(playerid, string);
				Format(string, "Tisztelt %s önnek már van Személyazonosító Igazolványa!",VezetekNev(playerid));
				Msg(playerid, string);
				return 1;
			}
			if(GetMoney(playerid) < ar)
			{
				Format(string, "Ügyintézõ mondja: Tisztelt %s egy Személyazonosító Igazolvány ára $%d!", VezetekNev(playerid), ar);
				Msg(playerid, string);
				Format(string, "Tisztelt %s egy Személyazonosító Igazolvány ára $%d!",VezetekNev(playerid), ar);
				Msg(playerid, string);
				return 1;
			}
			
			PlayerInfo[playerid][pAge] = Rand(18, 50);
			PlayerInfo[playerid][pSzemelyi] = 50;
			GiveMoney(playerid, -ar);
			FrakcioInfo[LMUNKA_ALLAM][fPenz] += ar;
			Msg(playerid, "Elkészült az Ön igazolványa!");
		}
		return 1;
 	}
	if(egyezik(cmd, "/mûszaki"))
	{
		if(params < 1) return Msg(playerid, "/mûszaki [Vizsga / Ár]");
		if(!LMT(playerid,LMUNKA_SZERELO)) return Msg(playerid, "Nem vagy szerelõ!");
		if(egyezik(param[1], "vizsga"))
		{
		    new kocsi = GetClosestCar(playerid);
		    if(GetDistanceToCar(playerid, kocsi) < 5.0)
		    {
		        new vs = IsAVsKocsi(kocsi);
		        if(vs == NINCS) return Msg(playerid, "Ez a jármû a módba van beleírva!");
		    	if(GetMoney(playerid) < MUSZAKIAR) return Msg(playerid, "Nincs elég pénzed!");
		    	GiveMoney(playerid,-MUSZAKIAR);
				FrakcioInfo[LMUNKA_SZERELO][fPenz] += MUSZAKIAR-500;
		    	CarInfo[vs][cMuszakiIdo] = MUSZAKIIDO;
		    	Msg(playerid, "Mûszaki vizsga kész!");
			}
			else
			{
			    Msg(playerid, "Nincs a közelben jármû!");
			}
		}
		else if(egyezik(param[1], "ár") || egyezik(param[1], "ar"))
		{
		    SendFormatMessage(playerid,COLOR_LIGHTGREEN, "Mûzsaki vizsga ára: $%d", MUSZAKIAR);
		}
		return 1;
	}
	if(strcmp(cmd, "/forgalmi", true)==0)
    {
        if(IsValidPlayerID(playerid))
	    {
	        tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				Msg(playerid, "Használat: /forgalmi [JátékosID/NévRészlet]");
				return 1;
			}
			if(!IsPlayerInAnyVehicle(playerid)) return Msg(playerid, "Csak jármûbõl!");
			giveplayerid = ReturnUser(tmp);
			if(IsValidPlayerID(giveplayerid))
			{
				if(giveplayerid != INVALID_PLAYER_ID)
				{
				    if(ProxDetectorS(8.0, playerid, giveplayerid))
					{
					    GetPlayerName(giveplayerid, giveplayer, sizeof(giveplayer));
						GetPlayerName(playerid, sendername, sizeof(sendername));
						new kocsi = GetPlayerVehicleID(playerid);

						format(string, sizeof(string), "=== %d rendszámú jármû forgalmi engedélye ===", kocsi);
						SendClientMessage(giveplayerid, COLOR_LIGHTBLUE, string);
						new cid = IsAVsKocsi(kocsi);
						SendFormatMessage(giveplayerid,COLOR_LIGHTGREEN, "Jármû Rendszáma: %d", veh);
						//SendFormatMessage(giveplayerid,COLOR_LIGHTGREEN, "Jármû Modell: %d", GetVehicleModelName(kocsi -400));
						if(cid != NINCS)
							SendFormatMessage(giveplayerid,COLOR_LIGHTGREEN, "Jármû Tulajdonosa: %s",CarInfo[cid][cOwner]);
						else
							SendFormatMessage(giveplayerid,COLOR_LIGHTGREEN, "Jármû Tulajdonosa: %s", "Frakció/Munkahelyi Tulajdon");

						if(SajatKocsi(playerid,kocsi))
						    SendClientMessage(giveplayerid,COLOR_LIGHTGREEN, "A személynek {1F7300}VAN {009900}kulcsa ehhez a jármûhöz!");
						else
						    SendClientMessage(giveplayerid,COLOR_LIGHTGREEN, "A személynek {FF0000}NINCS {009900}kulcsa ehhez a jármûhöz!");
	
						SendFormatMessage(giveplayerid,COLOR_GREEN, "Megtett Km: %d", CarInfo[veh][cMegtettKM]);
						if(CarInfo[cid][cMuszakiIdo] > 1)
						    SendFormatMessage(giveplayerid,COLOR_LIGHTGREEN, "Mûszaki vizsga: Érvényes! Lejár: %s",FormatTime(CarInfo[cid][cMuszakiIdo]));
						else
						    SendClientMessage(giveplayerid,COLOR_LIGHTGREEN, "Mûszaki vizsga: {FF0000}Lejárt!");

						if(BenzinesKocsi(cid))
							SendClientMessage(giveplayerid,COLOR_LIGHTGREEN, "Hajtóanyag: Benzin");
						else
							SendClientMessage(giveplayerid,COLOR_LIGHTGREEN, "Hajtóanyag: Dízel");

						format(string, sizeof(string), "Megmutattad a jármû forgalmiját neki: %s", giveplayer);
						SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
						format(string, sizeof(string), "* Valaki kiveszi a kesztyûtartóból a forgalmit és felmutatja...");
						ProxDetector(30.0, playerid, string, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE, COLOR_PURPLE);
					}
					else
					{
					    Msg(playerid, "Ez a játékos nincs a közelben!");
					    return 1;
					}
				}
			}
	        else
	        {
	            Msg(playerid, "A játékos nincs fennt!");
	            return 1;
	        }
		}
	    return 1;
 	}
	if(egyezik(cmd, "/handsup"))
	{
		if(NemMozoghat(playerid) || Mobile[playerid] != -1 || Rabol[playerid] != 0 || PlayerCuffed[playerid] || PlayerTied[playerid] || Leutve[playerid] || Animban[playerid] != 0 ) return Msg(playerid, "Most nem!");
	    new allapot = GetPlayerSpecialAction(playerid);
		if(allapot != SPECIAL_ACTION_HANDSUP)
		{
		    //Cselekves(playerid, "felemelte a kezét / raised his/her hands",1);
		    SetPlayerSpecialAction(playerid,SPECIAL_ACTION_HANDSUP);
		}
		else
		{
		    //Cselekves(playerid, "letette a kezét / put his/her hands",1);
		    SetPlayerSpecialAction(playerid,SPECIAL_ACTION_NONE);
			ClearAnim(playerid);
		}
	}
 	if(strcmp(cmd, "/frisk", true)==0 || strcmp(cmd, "/motoz", true)==0)
    {
        if(IsValidPlayerID(playerid))
	    {
			if(FloodCheck(playerid, cmd)) return 1;
			giveplayerid = GetClosestPlayer(playerid);
			if(IsValidPlayerID(giveplayerid) || giveplayerid != INVALID_PLAYER_ID)
			{
			    if(ProxDetectorS(2.0, playerid, giveplayerid))
				{
				    if(giveplayerid == playerid) return Msg(playerid, "Magadat ne motozd már meg..");

					if(GetPlayerSpecialAction(giveplayerid) != SPECIAL_ACTION_HANDSUP && !NemMozoghat(giveplayerid))
					    return Msg(playerid, "Az illetõnek nincs felemelve a keze/nincs bilincsben/megkötözve/animban");

					new siker = random(100);
					new bool:sikerul;
					switch(siker)
					{
					    case 0..50: sikerul = true;
					}

					OnePlayAnim(playerid, "SPRAYCAN", "spraycan_full",4.0,0,0,0,0,0);
					OnePlayAnim(playerid, "SPRAYCAN", "spraycan_full",4.0,0,0,0,0,0);
					new inv = false;
					if(egyezik(param[1], "inv") && params > 0)
						inv = true;

					if(!inv)
					{
						Msg(playerid, "|__________ Tárgyak a személynél __________|");
						if(sikerul)
						{
							new drogok;
							if(PlayerInfo[giveplayerid][pKokain] > 0)
								drogok += PlayerInfo[giveplayerid][pKokain];
							if(PlayerInfo[giveplayerid][pHeroin] > 0)
								drogok += PlayerInfo[giveplayerid][pHeroin];
							if(PlayerInfo[giveplayerid][pMarihuana] > 0)
								drogok += PlayerInfo[giveplayerid][pMarihuana];

							if(PlayerInfo[giveplayerid][pKokain] > 0 || PlayerInfo[giveplayerid][pHeroin] > 0 || PlayerInfo[giveplayerid][pMarihuana] > 0)
								Msg(playerid, "- Drog");

							if(PlayerInfo[giveplayerid][pMats] > 0)
								Msg(playerid, "- Material");

							if(PlayerInfo[giveplayerid][pPhoneBook] > 0)
								Msg(playerid, "- Telefonkönyv");

							if(PlayerInfo[giveplayerid][pCDPlayer] > 0)
								Msg(playerid, "- MP4");

							if(PlayerInfo[giveplayerid][pCigi] > 0)
								Msg(playerid, "- Cigaretta");

							if(PlayerInfo[giveplayerid][pPia] > 0)
								Msg(playerid, "- Üdítõ");

							if(PlayerInfo[giveplayerid][pGyujto] > 0)
								Msg(playerid, "- Gyujtó");

							if(PlayerInfo[giveplayerid][pVokitoki] > 0)
								Msg(playerid, "- Walkie - Talkie");

							if(PlayerInfo[giveplayerid][pFishes] > 0)
								Msg(playerid, "- Hal");

							new fegyverek[96], fegyverek2[96], fegyok, fegyo, ammo, ammo2[8];
							for(new x = 0; x < 13; x++)
							{
								GetPlayerWeaponData(giveplayerid, x, fegyo, ammo);
								if(x == 0 && fegyo != 1) continue;

								if(ammo > 0) Format(ammo2, "[%d]", ammo);
								else ammo2[0] = EOS;

								if(ammo != 0)
								{
									fegyok++;
									if(fegyok < 6)
										if(fegyok == 1)
											Format(fegyverek, "Fegyverek: (%d)%s%s", fegyo, aWeaponNames[fegyo], ammo2);
										else
											Format(fegyverek, "%s, (%d)%s%s", fegyverek, fegyo, aWeaponNames[fegyo], ammo2);
									else
										if(fegyok == 6)
											Format(fegyverek2, "Fegyverek: (%d)%s%s", fegyo, aWeaponNames[fegyo], ammo2);
										else
											Format(fegyverek2, "%s, (%d)%s%s", fegyverek2, fegyo, aWeaponNames[fegyo], ammo2);
								}
							}

							if(fegyok > 0)
								SendClientMessage(playerid, COLOR_GRAD3, fegyverek);

							if(fegyok >= 6)
								SendClientMessage(playerid, COLOR_GRAD4, fegyverek2);
						}
						else
						{
							Msg(playerid, "- Nem találtál nála semmit.");
						}
					}
					else
					{
						Msg(playerid, "|__________ Tárgyak a személynél __________|");
						if(sikerul)
						{
							new drogok;
							if(PlayerInfo[giveplayerid][pKokain] > 0)
								drogok += PlayerInfo[giveplayerid][pKokain];
							if(PlayerInfo[giveplayerid][pHeroin] > 0)
								drogok += PlayerInfo[giveplayerid][pHeroin];
							if(PlayerInfo[giveplayerid][pMarihuana] > 0)
								drogok += PlayerInfo[giveplayerid][pMarihuana];

							if(PlayerInfo[giveplayerid][pKokain] > 0 || PlayerInfo[giveplayerid][pHeroin] > 0 || PlayerInfo[giveplayerid][pMarihuana] > 0)
								Msg(playerid, "- Drog");

							if(PlayerInfo[giveplayerid][pMats] > 0)
								Msg(playerid, "- Material");

							if(PlayerInfo[giveplayerid][pPhoneBook] > 0)
								Msg(playerid, "- Telefonkönyv");

							if(PlayerInfo[giveplayerid][pCDPlayer] > 0)
								Msg(playerid, "- MP4");

							
							if(PlayerInfo[giveplayerid][pCigi] > 0)
								Msg(playerid, "- Cigaretta");

							if(PlayerInfo[giveplayerid][pPia] > 0)
								Msg(playerid, "- Üdítõ");

							if(PlayerInfo[giveplayerid][pGyujto] > 0)
								Msg(playerid, "- Gyujtó");

							if(PlayerInfo[giveplayerid][pVokitoki] > 0)
								Msg(playerid, "- Walkie - Talkie");

							if(PlayerInfo[giveplayerid][pFishes] > 0)
								Msg(playerid, "- Hal");

							new fegyverek[96], fegyverek2[96], fegyok, fegyo, ammo, ammo2[8];
							for(new x = 0; x < 13; x++)
							{
								GetPlayerWeaponData(giveplayerid, x, fegyo, ammo);
								if(x == 0 && fegyo != 1) continue;

								if(ammo > 0) Format(ammo2, "[%d]", ammo);
								else ammo2[0] = EOS;

								if(ammo != 0)
								{
									fegyok++;
									if(fegyok < 6)
										if(fegyok == 1)
											Format(fegyverek, "Fegyverek: (%d)%s%s", fegyo, aWeaponNames[fegyo], ammo2);
										else
											Format(fegyverek, "%s, (%d)%s%s", fegyverek, fegyo, aWeaponNames[fegyo], ammo2);
									else
										if(fegyok == 6)
											Format(fegyverek2, "Fegyverek: (%d)%s%s", fegyo, aWeaponNames[fegyo], ammo2);
										else
											Format(fegyverek2, "%s, (%d)%s%s", fegyverek2, fegyo, aWeaponNames[fegyo], ammo2);
								}
							}

							if(fegyok > 0)
								SendClientMessage(playerid, COLOR_GRAD3, fegyverek);

							if(fegyok >= 6)
								SendClientMessage(playerid, COLOR_GRAD4, fegyverek2);
						}
						else
						{
							Msg(playerid, "- Nem találtál nála semmit.");
						}
						if(inv)
						{
							for(new i =0; i < INV_SLOT; i++)
							{
								if(PlayerInfo[playerid][pInventory][i] == NINCS)
									SendFormatMessage(playerid,COLOR_GREY, "Slot %d: Üres",i);
								else
									SendFormatMessage(playerid,COLOR_GREY, "Slot %d: %s",Targyak[PlayerInfo[playerid][pInventory][i]][0]);
							}
						}
					}
					if(!inv)
						 Msg(playerid, "Ha szeretnéd átkutatni a táskáját is, /frisk inv");

					Cselekves(playerid, "átkutatott valakit");
				}
				else
				{
				    Msg(playerid, "* Nincs a közeledben a játékos!");
				    return 1;
				}
			}
	        else
	        {
	            Msg(playerid, "Nincs ilyen játékos a szerveren!");
	            return 1;
	        }
		}
	    return 1;
 	}
	if(egyezik(cmd, "/tankol"))
	{
		if(FloodCheck(playerid, cmd)) return 1;
		if(Tankol[playerid][0] != 0)
		{
			DestroyDynamic3DTextLabel(Tankolas3D[GetPVarInt(playerid, "Tankolas_CarID")]);
			Tankol[playerid][0] = 0;
			Cselekves(playerid, "befejezte a tankolást");
			UnFreeze(playerid);
			return 1;
		}
		new kut = IsAtGasStation(playerid); 
		if(kut == NINCS) return Msg(playerid, "Nem vagy benzinkútnál");

		if(IsPlayerInAnyVehicle(playerid)) return Msg(playerid, "Elõbb szállj ki a jármûbõl!");
		new kocsi = GetClosestVehicle(playerid);
		if(GetDistanceToVehicle(playerid, kocsi) > 5.0) return Msg(playerid, "Nincs melletted jármû!");
		
		new 
			tankolasinfo[248],
			formattedszoveg[72],
			uzemanyagtipus[8],
			tankolaskoltseg,
			uzemanyagtype
		;
		
		if(BenzinesKocsi(kocsi))
		{
			uzemanyagtype = UZEMANYAGTIPUS_BENZIN;
			uzemanyagtipus = "Benzin";
			tankolaskoltseg = BENZIN_AR;
		}
		else
		{
			uzemanyagtype = UZEMANYAGTIPUS_DIESEL;
			uzemanyagtipus = "Dízel";
			tankolaskoltseg = DIZEL_AR;
		}
		
		SetPVarInt(playerid, "Tankolas_GasType", uzemanyagtype);
		SetPVarInt(playerid, "Tankolas_CarID", kocsi);
		tankolaskoltseg = 2;
		SetPVarInt(playerid, "Tankolas_UzemanyagAr", tankolaskoltseg);
		
		Format(formattedszoveg, "Jármû rendszáma\t%s\n", GetVehicleNumberPlate(kocsi));
		strcat(tankolasinfo, formattedszoveg);
		
		Format(formattedszoveg, "Üzemanyag típusa\t%s\n", uzemanyagtipus);
		strcat(tankolasinfo, formattedszoveg);
		
		Format(formattedszoveg, "Üzemanyagszint\t%dL/%dL\n", MaxBenzin(kocsi), Gas[kocsi][uzemanyagtype]);
		strcat(tankolasinfo, formattedszoveg);
		
		Format(formattedszoveg, "Tankolható még\t%dL\n", MaxBenzin(kocsi) - Gas[kocsi][uzemanyagtype]);
		strcat(tankolasinfo, formattedszoveg);
		
		Format(formattedszoveg, "Tankolás költsége\t$%s/L", PenzTordeles(tankolaskoltseg));
		strcat(tankolasinfo, formattedszoveg);
		
		ShowPlayerDialog(playerid, DIALOG_TANKOLAS, DIALOG_STYLE_TABLIST, "Tankolás információ", tankolasinfo, "Tankol", "Bezár");
		return 1;
	}
	if(egyezik(cmd, "/detain"))
	{
		if(params < 2) return Msg(playerid, "/detain [JátékosID/NévRészlet] [Ülés(1-3)]");
		new player;
		player = ReturnUser(param[1]);
		new ules;
		ules = strval(param[2]);
		if(player == INVALID_PLAYER_ID) return Msg(playerid, "Nincs ilyen játékos");
		if(IsPlayerInAnyVehicle(playerid)) return Msg(playerid, "Jármûbõl nem használhatod!");
		if(ules < 1 || ules > 3) return Msg(playerid, "Ülés csak 1-3 lehet.");
		if(GetDistanceBetweenPlayers(playerid,player) > 5) return Msg(playerid, "A játékos nincs a közelben.");
		if(playerid == player) return Msg(playerid, "Idióta, magadat?-.-");
		if(IsPlayerInAnyVehicle(player)) return Msg(playerid, "A játékos jármûben van, elöször szedd ki onnan!");
		if(!NemMozoghat(player)) return Msg(playerid, "A játékos nincs megbilincselve / Megkötözve / Leütve / Animban!");
		new kocsi;
		kocsi = GetClosestVehicle(playerid);
		if(GetDistanceToVehicle(playerid, kocsi) > 5) return Msg(playerid, "A közeledben nincs jármû!");
		SendFormatMessage(playerid, COLOR_LIGHTRED, "* %s-t beraktad a jármûbe.", PlayerName(player));
		SendClientMessage(player, COLOR_LIGHTRED, "* Beraktak egy jármûbe.");
		Cselekves(playerid, "berakta a célszemélyt a jármûbe.");
		ClearAnimations(player);
		TogglePlayerControllable(player, 0);
		PutPlayerInVehicle(player, kocsi, ules);
	}
	
	if(egyezik(cmd, "/tazer") || egyezik(cmd, "/sokk"))
	{
		if(FloodCheck(playerid, cmd)) return 1;
		if(!IsACop(playerid) || OnDuty[playerid] < 1) return Msg(playerid, "Nem vagy szolgálatban!");
		
		new GetFegyverID, GetLoszer;		
		GetPlayerWeaponData(playerid, 2, GetFegyverID, GetLoszer);
		
		if(SokkoloAktivalva[playerid])
		{
			FegyverElvesz(playerid, GetFegyverID);
			GiveWeapon(playerid, 24, 90);
			SokkoloAktivalva[playerid] = false;
		}
		else
		{
			FegyverElvesz(playerid, GetFegyverID);
			GiveWeapon(playerid, 23, 9999);
			SokkoloAktivalva[playerid] = true;
		}
		
		return 1;
	}
	
	if(egyezik(cmd, "/cuff") || egyezik(cmd, "/bilincs"))
	{
		if(!IsACop(playerid) || OnDuty[playerid] < 1) return Msg(playerid, "Nem vagy szolgálatban!");
		if(IsPlayerInAnyVehicle(playerid)) return Msg(playerid, "Autóban nem bilincselhetsz !");
		if(params > 0) giveplayerid = strval(param[1]);
		else giveplayerid = GetClosestPlayer(playerid);
		if(IsPlayerNPC(giveplayerid) && !IsFejleszto(playerid)) return Msg(playerid, "Hagyd békén az NPC-t!");
		if(playerid == giveplayerid) return 1;
		if(!IsValidPlayerID(giveplayerid) || giveplayerid == INVALID_PLAYER_ID) return Msg(playerid, "Nem online!");
        if(PlayerCuffed[giveplayerid] == 2) return Msg(playerid, "Már meg van bilincselve");
		if(!ProxDetectorS(8.0, playerid, giveplayerid)) return Msg(playerid, "Nincs senki a közeledben");
		if(giveplayerid == playerid) return Msg(playerid, "Vadállat, magadat megbilincselni?! Ilyen perverz vagy?!");
		
		if(AdminDuty[giveplayerid])
		{
			SeeRPGKick(playerid, "Adminszolist akarsz megbilincselni? Bátor cselekedet...", NINCS);
			return 1;
		}
		
		new fegyo = GetPlayerWeapon(giveplayerid);
		if(fegyo > 0) return Msg(playerid, "Ha van a kezébe fegyver, hogyan akarod megbilincselni?");
		if(Rabol[playerid] != 0) Rabol[playerid] = 0;
		SendClientMessage(giveplayerid, COLOR_LIGHTBLUE, "* Rendõr megbilincselt jó szorosan.");
		SendClientMessage(playerid, COLOR_LIGHTBLUE, "* Megbilincselted a személyt.");
		Cselekves(playerid, "megbilincseli a célszemélyt.", 0);
		GameTextForPlayer(giveplayerid, "~r~Megbilincseltek", 2500, 3);
		Freeze(giveplayerid, 0);
		Bilincs(giveplayerid, 2);
		FegyverElrak(giveplayerid);
		return 1;
	}
	if(strcmp(cmd, "/uncuff", true) == 0)
	{
	    if(IsValidPlayerID(playerid))
	    {
			if(IsACop(playerid) && OnDuty[playerid] == 1)
			{
				if(params > 0)
					giveplayerid = strval(param[1]);
				else
					giveplayerid = GetClosestPlayer(playerid);

				if(playerid == giveplayerid) return 1;

				if(IsValidPlayerID(giveplayerid))
				{
					if(giveplayerid != INVALID_PLAYER_ID)
					{
					    if(ProxDetectorS(8.0, playerid, giveplayerid))
						{
						    if(giveplayerid == playerid) { Msg(playerid, "Magadat nem tudod uncuffolni"); return 1; }
							if(PlayerCuffed[giveplayerid])
							{
							    GetPlayerName(giveplayerid, giveplayer, sizeof(giveplayer));
								GetPlayerName(playerid, sendername, sizeof(sendername));
							    format(string, sizeof(string), "* Rendõr levette rólad a bilincseket");
								SendClientMessage(giveplayerid, COLOR_LIGHTBLUE, string);
								format(string, sizeof(string), "* Levetted a személy bilincseit");
								SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
								GameTextForPlayer(giveplayerid, "~g~Bilincs leveve", 2500, 3);
								Bilincs(giveplayerid, 0);
								UnFreeze(giveplayerid);
								TogglePlayerControllable(playerid, true);
								ClearAnimations(giveplayerid);
							}
							else
							{
							    Msg(playerid, "Nincs megbilincselve");
								Bilincs(giveplayerid, 0);
							    return 1;
							}
						}
						else
						{
						    Msg(playerid, "A közeledben nincs senki");
						    return 1;
						}
					}
				}
			}
			else
				Msg(playerid, "Nem vagy rendõr!");
		}//not connected
		return 1;
	}
	if(egyezik(cmd, "/armor") || egyezik(cmd, "/armour"))
	{
		if(params < 1) return Msg(playerid, "Használat: /armour [Felvesz / Mozgat /Levesz]");		
		if(!IsACop(playerid)) return Msg(playerid, "Nem vagy egy rendvédelmi szervezet tagja sem!");
		if(OnDuty[playerid] != 1) return Msg(playerid, "Nem vagy szolgálatban.");
		
		PlayerText[playerid] = "Most már elhelyezheted a golyóállómellényt! Ne feledd, csak reális helyre teheted!";
		
		if(egyezik(param[1], "felvesz"))
		{
			if(ArmourFelveve[playerid]) return Msg(playerid, "Te már vettél fel golyóállómellényt!");
			
			SetPlayerAttachedObject(playerid, SLOT_ARMOUR, 19142, 1);
			EditAttachedObject(playerid, SLOT_ARMOUR);
			
			Msg(playerid, PlayerText[playerid]);
			ArmourFelveve[playerid] = true;
		}
		else if(egyezik(param[1], "mozgat"))
		{
			if(!ArmourFelveve[playerid]) return Msg(playerid, "Te még nem vettél fel golyóállómellényt!");
			EditAttachedObject(playerid, SLOT_ARMOUR);
			Msg(playerid, PlayerText[playerid]);
		}
		else if(egyezik(param[1], "levesz"))
		{
			if(!ArmourFelveve[playerid]) return Msg(playerid, "Te még nem vettél fel golyóállómellényt!");
			if(IsPlayerAttachedObjectSlotUsed(playerid, SLOT_ARMOUR)) RemovePlayerAttachedObject(playerid, SLOT_ARMOUR);
			ArmourFelveve[playerid] = false;
		}
		return 1;
	}
	
	/*if(egyezik(cmd, "/hátizsák") || egyezik(cmd, "/hatizsak"))
	{
		if(params < 1) return Msg(playerid, "Használat: /hátizsák [Felvesz / Mozgat /Levesz]");		
		
		PlayerText[playerid] = "Most már elhelyezheted a hátizsákot! Ne feledd, csak reális helyre teheted!";
		
		if(egyezik(param[1], "felvesz"))
		{
			if(IsPlayerAttachedObjectSlotUsed(playerid, SLOT_ARMOUR)) return Msg(playerid, "Már van rajtad hátizsák!");
			SetPlayerAttachedObject(playerid, SLOT_ARMOUR, 3026, 1, 0.120999, 0.038999, 0.000000, 0.000000, 0.000000, 0.000000, 1.000000, 1.000000, 1.000000, 0, 0);
		}
		else if(egyezik(param[1], "mozgat"))
		{
			if(!IsPlayerAttachedObjectSlotUsed(playerid, SLOT_ARMOUR)) return Msg(playerid, "Nincs rajtad hátizsák!");
			EditAttachedObject(playerid, SLOT_ARMOUR);
			Msg(playerid, PlayerText[playerid]);
		}
		else if(egyezik(param[1], "levesz"))
		{
			if(IsPlayerAttachedObjectSlotUsed(playerid, SLOT_ARMOUR)) RemovePlayerAttachedObject(playerid, SLOT_ARMOUR);
		}
		return 1;
	}*/
	
	if(egyezik(cmd, "/maszk"))
	{
		if(params < 1) return Msg(playerid, "Használat: /maszk [Felvesz / Mozgat /Levesz]");		
		
		PlayerText[playerid] = "Most már elhelyezheted a maszkot! Ne feledd, csak reális helyre teheted!";
		
		if(egyezik(param[1], "felvesz"))
		{
			if(Maszk[playerid] == 1) return Msg(playerid, "Már vettél fel maszkot!");
			
			new ObjectID = PlayerInfo[playerid][pMaszk];		
			
			if(ObjectID >= 19036 AND ObjectID <= 19037) { // maszkok
				SetPlayerAttachedObject(playerid, SLOT_MASZK, ObjectID, 2, 0.094000, 0.043000, 0.003999, 93.099967, 87.600013, 0.300001, 1.000000, 1.000000, 1.000000, 0, 0);
			}
			else if(ObjectID >= 18912 AND ObjectID <= 18918) { // kendõk
				SetPlayerAttachedObject(playerid, SLOT_MASZK, ObjectID, 2, 0.087999, 0.034000, 0.000999, -89.399993, 0.000000, 87.999954, 1.064999, 1.054000, 1.130000, 0, 0);
			} else {
				SetPlayerAttachedObject(playerid, SLOT_MASZK, ObjectID, 2);
			}
			
			EditAttachedObject(playerid, SLOT_MASZK);
			
			Msg(playerid, PlayerText[playerid]);
			Maszk[playerid] = 1;
		}
		else if(egyezik(param[1], "mozgat"))
		{
			if(Maszk[playerid] == 0) return Msg(playerid, "Nincs rajtad maszk!");
			EditAttachedObject(playerid, SLOT_MASZK);
			Msg(playerid, PlayerText[playerid]);
		}
		else if(egyezik(param[1], "levesz"))
		{
			if(Maszk[playerid] == 0) return Msg(playerid, "Nincs rajtad maszk!");
			if(IsPlayerAttachedObjectSlotUsed(playerid, SLOT_MASZK)) RemovePlayerAttachedObject(playerid, SLOT_MASZK);
			Maszk[playerid] = 0;
		}
		return 1;
	}	
	if(egyezik(cmd, "/sign") || egyezik(cmd, "/carsign"))
	{
		if(params < 1) return Msg(playerid, "Használat: /carsign [Szerkeszt / Ki]");		
		if(!IsACop(playerid) AND !Admin(playerid, 3)) return Msg(playerid, "Nem vagy egy rendvédelmi szervezet tagja sem!");
		if(IsACop(playerid) AND PlayerInfo[playerid][pRank] < 2) return Msg(playerid, "Minimum 2-es rang!");
		
		if(!Sofor(playerid)) return Msg(playerid, "Csak sofõr!");
		new kocsi = GetPlayerVehicleID(playerid);
		
		if(GetVehicleModel(kocsi) != 596 AND GetVehicleModel(kocsi) != 597 AND GetVehicleModel(kocsi) != 598) {
			return Msg(playerid, "Erre a jármûre nem rakhatsz CarSign-t!");
		}
		
		if(egyezik(param[1], "szerkeszt"))
		{
			if(params < 2) return Msg(playerid, "Használat: /carsign [Szerkeszt] [Szöveg]");
			
			strtok(cmdtext, idx);
			new length = strlen(cmdtext);
			while ((idx < length) && (cmdtext[idx] <= ' '))
			{
				idx++;
			}
			new offset = idx, result[12];
			while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
			{
				result[idx - offset] = cmdtext[idx];
				idx++;
			}
			result[idx - offset] = EOS;
			
			if(SzovegEllenorzes(playerid, result, "/carsign")) return 1;
			
			DestroyDynamic3DTextLabel(CarSign[kocsi]);
			CarSign[kocsi] = CreateDynamic3DTextLabel(result, -1, -0.599999, -3.099999, -0.100000, 50.0, _, kocsi);
			//MsgFormat(playerid, "CarSign átírva: {%s}%s{FFFFFF}", COLOR_MSG, result);
		}
		else if(egyezik(param[1], "ki") OR egyezik(param[1], "off"))
		{			
			DestroyDynamic3DTextLabel(CarSign[kocsi]);
			iMsg(playerid, "CarSign törölve!");
		}
		return 1;
	}
	if(strcmp(cmd, "/repair", true) == 0 || strcmp(cmd, "/javít", true) == 0 || strcmp(cmd, "/javit", true) == 0)
	{
	    if(IsValidPlayerID(playerid))
	    {
		    if(!LMT(playerid, LMUNKA_SZERELO) && PlayerInfo[playerid][pSzerszamoslada] == 0)
		    {
		        Msg(playerid, "Nem vagy autószerelõ/nincs szerszámos ládád!");
		        return 1;
		    }
			if(!Muhelyben(playerid)) return Msg(playerid, "Nem vagy szerelõmûhelyben!");
			new kocsi = GetClosestCar(playerid);
			if(GetDistanceToCar(playerid,kocsi) > 4.0) return Msg(playerid, "Nincs a közeledben jármû!");
			
			new minosszeg = 150;
			if(GetMoney(playerid) < minosszeg)
			{
				MsgFormat(playerid, "A javítás minimum $%s!", PenzTordeles(minosszeg));
				return 1;
			}
			SetTimerEx("Kocsijavit", 10000, 0, "dd",playerid,kocsi);
			TogglePlayerControllable(playerid, false);
			/*Cselekves(playerid, "elkezdte szerelni a jármûvet",1);
			Cselekves(playerid, "megnézi a sérüléseket",1);
			Cselekves(playerid, "leszereli a sérült elemeket",1);
			Cselekves(playerid, "felszereli az új alkatrészeket",1);*/
			
			GiveMoney(playerid, -minosszeg);
			
			PlayerInfo[playerid][pSzerszamoslada] --;
		}
		return 1;
	}
	if(strcmp(cmd, "/eject", true) == 0)
	{
	    if(IsValidPlayerID(playerid))
	   	{
	        new State;
	        if(IsPlayerInAnyVehicle(playerid))
	        {
         		State=GetPlayerState(playerid);
		        if(State!=PLAYER_STATE_DRIVER)
		        {
		        	SendClientMessage(playerid,COLOR_GREY, "Csak a vezetõ dobhat ki utast a kocsiból!");
		            return 1;
		        }
				tmp = strtok(cmdtext, idx);
				if(!strlen(tmp))
				{
					Msg(playerid, "/eject [JátékosID/NévRészlet]");
					return 1;
				}
				new playa;
				playa = ReturnUser(tmp);
				new test;
				test = GetPlayerVehicleID(playerid);
				if(IsValidPlayerID(playa))
				{
				    if(playa != INVALID_PLAYER_ID)
				    {
				        if(playa == playerid) { Msg(playerid, "Magadat hogy dobod ki?"); return 1; }
				        if(IsPlayerInVehicle(playa,test))
				        {
							new PName[MAX_PLAYER_NAME];
							GetPlayerName(playerid,PName,sizeof(PName));
							GetPlayerName(playa, giveplayer, sizeof(giveplayer));
							format(string, sizeof(string), "* Kidobtad a kocsiból: {008000}%s", giveplayer);
							SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
							format(string, sizeof(string), "* A sofõr kidobott a kocsiból");
							SendClientMessage(playa, COLOR_LIGHTBLUE, string);
							RemovePlayerFromVehicle(playa);
						}
						else
						{
						    Msg(playerid, "Õ nincs a kocsiban!");
						    return 1;
						}
					}
				}
				else
				{
					Msg(playerid, "Hibás JátékosID/NévRészlet");
				}
			}
			else
			{
			    Msg(playerid, "Nem vagy jármûben!");
			}
		}
		return 1;
	}
	if(strcmp(cmd, "/bail", true) == 0 || strcmp(cmd, "/óvadék", true) == 0)
	{
	    if(IsValidPlayerID(playerid))
	   	{
			if(Bortonben(playerid))
			{
				if(PlayerInfo[playerid][pJailed] == BORTON_ADMIN || PlayerInfo[playerid][pJailed] == BORTON_ADMIN2) return Msg(playerid, "A-a!");
			    if(PlayerInfo[playerid][pOvadek] > 0)
			    {
			        if(PlayerInfo[playerid][pJailTime] > 900) return Msg(playerid, "Neked még több mint 15perc idõd van, nem engedünk még ki!");
     				if(PlayerInfo[playerid][pAccount] < PlayerInfo[playerid][pOvadek]) return Msg(playerid, "Nem tudod kifizetni!");
					format(string, sizeof(string), "Kifizetted az óvadékot! ($%d)", PlayerInfo[playerid][pOvadek]);
					SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
					PlayerInfo[playerid][pOvadek] = 0;
					Format(string, "%s kifizette az óvadékot!", PlayerName(playerid));
					PlayerInfo[playerid][pAccount] -= PlayerInfo[playerid][pOvadek];
					CopMsg(COLOR_LIGHTGREEN, string);
					WantLawyer[playerid] = 0;
					CallLawyer[playerid] = 0;
					PlayerInfo[playerid][pJailTime] = 1;
			    }
			    else
			    {
			        Msg(playerid, "Nincs óvadék!");
			    }
			}
			else
			{
			    Msg(playerid, "Nem vagy börtönben!");
			}
		}
		return 1;
	}
	if(egyezik(cmd, "/fegyvertartási") || egyezik(cmd, "/fegyvertartasi") || egyezik(cmd, "/fegyverengedély"))
	{
		if(FloodCheck(playerid, cmd)) return 1;
		if(params < 2) return Msg(playerid, "/fegyvertartási [Ad / Elvesz] [JátékosID/NévRészlet]");
		new engedelyar = 130000/DOLLAR_ARFOLYAM;
		if(egyezik(param[1], "ad"))
		{
			if(!LMT(playerid, LMUNKA_LSPD)) return Msg(playerid, "Nem az LSPD-nál dolgozol!");
			if(LMT(playerid, LMUNKA_LSPD) && PlayerInfo[playerid][pRank] < 3) return Msg(playerid, "Minimum 3-as rang!");
			if(OnDuty[playerid] != 1) return Msg(playerid, "Nem vagy szolgálatban.");
			
			new player = ReturnUser(param[2]);
			if(player == INVALID_PLAYER_ID) return 1;
			
			//if(playerid == player) return Msg(playerid, "Magadnak nem adhatsz!");
			if(GetDistanceBetweenPlayers(playerid, player) > 5) return Msg(playerid, "Õ nincs a közeledben!");
			
			if(GetMoney(player) < engedelyar) 
			{
				SendFormatMessage(playerid, COLOR_LIGHTBLUE, "A játékosnak nincs elég pénze! A fegyverengedély ára $%s", PenzTordeles(engedelyar));
				SendFormatMessage(player, COLOR_PIROS, "Nincs elég pénzed! A fegyverengedély ára $%s", PenzTordeles(engedelyar));
				return 1;
			}
			
			Msg(playerid, "Fegyvertartási megadva! Az engedély ára levonásra került!");
			Msg(player, "Kaptál egy fegyvertartási engedélyt! Az engedély ára levonásra került!");
			
			GiveMoney(player, - engedelyar);
			FrakcioInfo[LMUNKA_LSPD][fPenz] += engedelyar;			
			PlayerInfo[player][pGunLic] = JOGSI_FEGYVER;
		}
		else if(egyezik(param[1], "elvesz"))
		{
			if(!IsACop(playerid)) return Msg(playerid, "Nem tartozol egy rendvédelmi szervezethez sem!");
			new p = ReturnUser(param[2]);
			if(p == INVALID_PLAYER_ID) return 1;
			
			if(PlayerInfo[p][pGunLic] == 0) return Msg(playerid, "Neki nincs fegyverengedélye ezért nem tudod elvenni...");
			if(GetDistanceBetweenPlayers(playerid, p) > 5) return Msg(playerid, "Õ nincs a közeledben!");
			
			Msg(playerid, "Elvetted a fegyvertartásid!");
			Msg(p, "Elvették a fegyvertartásid!");
			PlayerInfo[p][pGunLic] = 0;
		}
	}
	if(strcmp(cmd, "/ticket", true) == 0)
	{
	    if(IsValidPlayerID(playerid))
		if(FloodCheck(playerid, cmd)) return 1;
	    {
	        if(!IsACop(playerid)) return Msg(playerid, "Nem vagy egy rendvédelmi szervezet tagja sem!");
	        if(OnDuty[playerid] != 1) return Msg(playerid, "Nem vagy szolgálatban!");

	    	tmp = strtok(cmdtext, idx);
			if(!strlen(tmp)) return Msg(playerid, "/ticket [JátékosID/NévRészlet] [bírság] [oka]");

			giveplayerid = ReturnUser(tmp);
            tmp = strtok(cmdtext, idx);
			
			if(!strlen(tmp)) return Msg(playerid, "/ticket [JátékosID/NévRészlet] [bírság] [oka]");
			
			moneys = strval(tmp);
			
			new MinBirsag = 3500/DOLLAR_ARFOLYAM, MaxBirsag = 1000000/DOLLAR_ARFOLYAM;
			
			if(moneys < MinBirsag || moneys > MaxBirsag) 
			{
				MsgFormat(playerid, "A minimum bírság $%d, a maximum pedig $%d!", MinBirsag, MaxBirsag);
				return 1; 
			}
			
			if(IsValidPlayerID(giveplayerid))
			{
			    if(giveplayerid != INVALID_PLAYER_ID)
			    {
			        if(ProxDetectorS(8.0, playerid, giveplayerid))
					{
					    GetPlayerName(giveplayerid, giveplayer, sizeof(giveplayer));
						GetPlayerName(playerid, sendername, sizeof(sendername));
						new length = strlen(cmdtext);
						while ((idx < length) && (cmdtext[idx] <= ' '))
						{
							idx++;
						}
						new offset = idx;
						new result[64];
						while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
						{
							result[idx - offset] = cmdtext[idx];
							idx++;
						}
						result[idx - offset] = EOS;
						if(!strlen(result))
						{
							Msg(playerid, "/ticket [JátékosID/NévRészlet] [bírság] [oka]");
							return 1;
						}

						format(string, sizeof(string), "* Megbûntetted %s -t (összeg: $%d), Oka: %s", giveplayer, moneys, (result));
						Msg(playerid, string);
						format(string, sizeof(string), "* %s megbírságolt. Fizetendõ összeg: $%d, Oka: %s", sendername, moneys, (result));
						Msg(giveplayerid, string);
						Msg(giveplayerid, "* '/accept ticket', hogy befizesd.");
						TicketOffer[giveplayerid] = playerid;
						TicketMoney[giveplayerid] = moneys;
						return 1;
					}
					else
					{
						Msg(playerid, "Ez a játékos nincs hozzád közel!");
						return 1;
					}
				}
			}
			else
			{
			    Msg(playerid, "Nincs ilyen játékos a szerveren!");
			    return 1;
			}
		}
		return 1;
	}
	if(egyezik(cmd, "/arrest"))
	{
		if(!IsACop(playerid)) return Msg(playerid, "Nem tartozol egy rendvédelmi szervezethez sem!");
		if(FloodCheck(playerid, cmd)) return 1;
		if(OnDuty[playerid] != 1) return Msg(playerid, "Nem vagy szolgálatban.");
		new bortonnel = ArrestHelyenVan(playerid);
		if(bortonnel == BORTON_NINCS) return Msg(playerid, "Itt nem tudod lecsukni!");
		if(params < 4) return Msg(playerid, "/arrest [Bírság] [idõ (perc)] [Óvadék] [Vád]");
		moneys = strval(param[1]);
		new time = strval(param[2]);
		new bailprice = strval(param[3]);
		strtok(cmdtext, idx); strtok(cmdtext, idx); strtok(cmdtext, idx);

		new length = strlen(cmdtext);
		while ((idx < length) && (cmdtext[idx] <= ' '))
		{
			idx++;
		}
		new offset = idx;
		new result[90];
		while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
		{
			result[idx - offset] = cmdtext[idx];
			idx++;
		}
		result[idx - offset] = EOS;

		if(moneys < 0 || moneys > 25000) return Msg(playerid, "A minimum bírság $0, maximum $25000!");
		if(time < 5 || time > 180) return Msg(playerid, "A börtönidõnek minimum 5 percnek kell lennie, és maximum 180 perc-nek!");
		if(bailprice > 0 && bailprice < 50 || bailprice > 250000) return Msg(playerid, "A minimum óvadékösszeg $50, maximum $250.000!");
		new suspect = GetClosestPlayer(playerid);
		if(GetDistanceBetweenPlayers(playerid, suspect) > 3.0) return Msg(playerid, "Nincs a közeledben");

		if(strlen(result) > 60) return Msg(playerid, "Maximum 60 karakter hossz! Fogalmazz röviden!");
		if(!EngedelyezettKarakterek(result)) return Msg(playerid, "Helytelen karakterek a szövegben!");

		SendFormatMessage(playerid, COLOR_LIGHTBLUE, "* Letartóztattad %s-t, oka: %s", PlayerName(suspect), result);
		GiveMoney(suspect, -moneys);
		FrakcioInfo[LMUNKA_LSPD][fPenz] += moneys;
		SendFormatMessage(suspect, COLOR_LIGHTRED, "Letartóztatott %s, oka: %s", PlayerName(playerid), result);
		ResetWeapon(suspect);

		if(bortonnel == BORTON_LSPD)
		{
			//if(time > 30) return Msg(playerid, "A fogdába maximum 30 percre zárhatsz el valakit! Szállítsd át a börtönbe!");
			Jail(suspect, "+", (time * 60), "LSPD", result);
			format(string, sizeof(string), "%s elhelyezte %s-t a LSPD börtönébe.", PlayerName(playerid), PlayerName(suspect));
			SendRadioMessage(LMUNKA_FBI, TEAM_BLUE_COLOR, string);
			SendRadioMessage(LMUNKA_KATONA, TEAM_BLUE_COLOR, string);
			SendRadioMessage(LMUNKA_LSPD, TEAM_BLUE_COLOR, string);
			SendRadioMessage(LMUNKA_NAV, TEAM_BLUE_COLOR, string);
			FrakcioInfo[LMUNKA_LSPD][fPenz] += moneys;
			strmid(PlayerInfo[suspect][pJailtAdta], PlayerName(playerid), 0, strlen(PlayerName(playerid)), 32);
		}

		if(bailprice > 0)
		{
			PlayerInfo[suspect][pOvadek] = bailprice;
			format(string, sizeof(string), "%d másodpercre börtönbe kerültél. Óvadék: $%d", PlayerInfo[suspect][pJailTime], PlayerInfo[suspect][pOvadek]);
			Bilincs(suspect, 0);
			SendClientMessage(suspect, COLOR_LIGHTBLUE, string);
		}
		else
		{
			PlayerInfo[suspect][pOvadek] = 0;
			format(string, sizeof(string), "%d másodpercre börtönbe kerültél. Óvadék: Nincs", PlayerInfo[suspect][pJailTime]);
			Bilincs(suspect, 0);
			SendClientMessage(suspect, COLOR_LIGHTBLUE, string);
		}
		PlayerInfo[suspect][pArrested] += 1;
		SetPlayerFree(suspect,playerid, "Letartóztatva.");
		WantedPoints[suspect] = 0;
		WantedLevel[suspect] = 0;
		WantLawyer[suspect] = 1;
		LSPDmoney += 10000;
		Visz[playerid] = NINCS;
		PlayerInfo[playerid][pKokain] = 0;
		PlayerInfo[playerid][pHeroin] = 0;
		PlayerInfo[playerid][pMarihuana] = 0;
	//	PlayerInfo[playerid][pLaptop] = 0;
	//	if(time > 15) Msg(playerid, "Mivel 15 percnél többre csuktad le, kötelezõ átszállítani!");
		return 1;
	}
	
	//return 1;
	return HibasParancs(playerid);
}