#if defined __game_old_old_text
	#endinput
#endif
#define __game_old_old_text

public OnPlayerText(playerid, text[]) //opt
{

	if(!IsPlayerConnected(playerid)) return 0;
	if(IsPlayerNPC(playerid)) { NPC_Uzenet(playerid, text); return 0; }
	if(Csendvan && PlayerInfo[playerid][pAdmin] == 0)
	{
		Msg(playerid, "Most nem beszélhetsz!");
		return 0;
	}
	if(Alszik[playerid] != 0) return !Msg(playerid, "Alszol, ilyenkor nem beszélhetsz!");
	AFKIdo[playerid] = 0;
	//new giver[MAX_PLAYER_NAME];
	new sendername[MAX_PLAYER_NAME];
	new giveplayer[MAX_PLAYER_NAME];
	new tmp[256];
	new string[256];
	//new giveplayerid;
	
	if(KorhazIdo[playerid] > 0) return !Msg(playerid, "Most nem beszélhetsz!");

	if(PlayerInfo[playerid][pMuted] == 1)
	{
		SendClientMessage(playerid, TEAM_CYAN_COLOR, "A hangszálaiddal játszanak, ilyenkor nehéz!");
		return 0;
	}
	if(PlayerCuffed[playerid] == 1)
		return !Msg(playerid, "Sokkolva vagy, nem tudsz beszélni!");
	if(Leutve[playerid])
	{
		Msg(playerid, "El vagy ájulva ember én nem beszélnék a helyedben..");
		return 0;
	}
	if(AFK[playerid] == 1)
	{
		if(strcmp(text, "classrpg", true) == 0)
		{
			AFK[playerid] = 0;
			SendClientMessage(playerid, COLOR_LIGHTRED, "===============[AFK]===============");
			SendClientMessage(playerid, COLOR_LIGHTBLUE, "Mostmár nem vagy AFK!");
			SendClientMessage(playerid, COLOR_LIGHTRED, "===============[AFK]===============");
			TogglePlayerControllable(playerid, true);
			InvisibleColor(playerid);
			return 0;
		}
		else
		{
			SendClientMessage(playerid, COLOR_WHITE, "Ha szeretnél visszatérni az AFKból írd be, hogy \"ClassRPG\"");
			return 0;
		}
	}
	if(FbiBelepve[playerid] == 1)
	{
		FBI_PDA(playerid, text);
		return 0;
	}
	if(Autocp[playerid] == 22)
	{
		if(egyezik(text, "igen"))
		{
			Msg(playerid, "Rendben végeztetek az órával, a tanítvány megkapja a jogosítványát.");
			Autocp[playerid] = 0;

			new tanulo = OnlineUID(Jogsineki[playerid]);
			
			if(Vizsgafajta[tanulo] == 5)
			{
				Msg(tanulo, "Gratulálunk! Megkaptad az Engedélyed!");
			}
			else
			{
				Msg(tanulo, "Gratulálunk! Megkaptad a Jogosítványodat!");
			}
			Autocp[tanulo] = 0;
			VizsgaAjanlat[tanulo] = NINCS;
			TakingLesson[tanulo] = 0;
			Oktat[playerid] = 0;
			if(Vizsgafajta[tanulo] == 1)
			{
				PlayerInfo[tanulo][pCarLic] = JOGSI_AUTO;
			}
			else if(Vizsgafajta[tanulo] == 2)
			{
				PlayerInfo[tanulo][pMotorJogsi] = JOGSI_MOTOR;
			}
			else if(Vizsgafajta[tanulo] == 3)
			{
				PlayerInfo[tanulo][pKamionJogsi] = JOGSI_KAMION;
			}
			else if(Vizsgafajta[tanulo] == 4)
			{
				PlayerInfo[tanulo][pBoatLic] = JOGSI_HAJO;
			}
			else if(Vizsgafajta[tanulo] == 5)
			{
				PlayerInfo[tanulo][pGunLic] = JOGSI_FEGYVER;
				PlayerInfo[playerid][pFegySkill] ++;
			}
			else if(Vizsgafajta[tanulo] == 9)
			{
				PlayerInfo[tanulo][pHeliLic] = JOGSI_REPULO;
			}
			else if(Vizsgafajta[tanulo] == 8)
			{
				PlayerInfo[tanulo][pAdrJogsi] = JOGSI_ADR;
			}
			else if(Vizsgafajta[tanulo] == 7)
			{
				PlayerInfo[tanulo][pFlyLic] = JOGSI_REPULO;
			}
			Vizsgafajta[tanulo] = 0;
			TakingLesson[playerid] = 0;
			return 0;
		}
		else if(egyezik(text, "nem"))
		{
			Msg(playerid, "Rendben végeztetek az órával, a tanítvány nem fog jogosítványt kapni.");
			Vizsgafajta[playerid] = 0;
			Autocp[playerid] = 0;
			new tanulo = OnlineUID(Jogsineki[playerid]);
			Msg(tanulo, "Sajnos nem mentél át a vizsgán! Legközelebb 2 hónap((óra)) múlva vizsgázhatsz!!");
			strmid(PlayerInfo[tanulo][pJogsiTiltOk], "Oktatás: vizsgán való bukás", 0, strlen("Oktatás: vizsgán való bukás"), 128);
			PlayerInfo[tanulo][pJogsiTiltIdo]=2;
			Autocp[tanulo] = 0;
			Oktat[playerid] = 0;
			TakingLesson[tanulo] = 0;
			PlayerInfo[playerid][pAccount] -= Tanulofelpenz[tanulo];
			new uo = (Tanulofelpenz[tanulo] / 2);
			PlayerInfo[tanulo][pAccount] += uo;
			FrakcioInfo[FRAKCIO_OKTATO][fPenz] += uo;
			VizsgaAjanlat[tanulo] = NINCS;
			return 0;

		}
		else
		{
			Msg(playerid, "Mondom igen vagy nem!");
			return 0;
		}
	}
	if(MarriageCeremoney[playerid] > 0)
	{
	    new idx;
	    tmp = strtok(text, idx);
	    if ((strcmp("igen", tmp, true, strlen(tmp)) == 0) && (strlen(tmp) == strlen("igen")))
		{
		    if(GotProposedBy[playerid] < 999)
		    {
			    if(IsPlayerConnected(GotProposedBy[playerid]))
				{
					GetPlayerName(playerid, sendername, sizeof(sendername));
					GetPlayerName(GotProposedBy[playerid], giveplayer, sizeof(giveplayer));
				    format(string, sizeof(string), "Pap: %s elfogadod %s-t feleségedért? (írd 'igen'.", giveplayer,sendername);
					SendClientMessage(GotProposedBy[playerid], COLOR_WHITE, string);
					MarriageCeremoney[GotProposedBy[playerid]] = 1;
					MarriageCeremoney[playerid] = 0;
					GotProposedBy[playerid] = 999;
				    return 1;
			    }
			    else
			    {
			        MarriageCeremoney[playerid] = 0;
			        GotProposedBy[playerid] = 999;
			        return 0;
			    }
			}
			else if(ProposedTo[playerid] < 999)
			{
			    if(IsPlayerConnected(ProposedTo[playerid]))
				{
					GetPlayerName(playerid, sendername, sizeof(sendername));
					GetPlayerName(ProposedTo[playerid], giveplayer, sizeof(giveplayer));
					if(PlayerInfo[playerid][pSex] == 1 && PlayerInfo[ProposedTo[playerid]][pSex] == 2)
					{
						format(string, sizeof(string), "Pap: %s és %s házastársaknak nyilványítalak titeket...Férj & Feleség, megcsókolhatod.", sendername, giveplayer);
						SendClientMessage(playerid, COLOR_WHITE, string);
				   		format(string, sizeof(string), "Pap: %s és %s házastársaknak nyilványítalak titeket...Férj & Feleség, megcsókolhatod.", giveplayer, sendername);
						SendClientMessage(ProposedTo[playerid], COLOR_WHITE, string);
						format(string, sizeof(string), "Házasság: Van egy új házaspárunk, %s & %s összeházasodott.", sendername, giveplayer);
						SendClientMessageToAll(COLOR_WHITE, string);
					}
					else if(PlayerInfo[playerid][pSex] == 1 && PlayerInfo[ProposedTo[playerid]][pSex] == 1)
					{
					    format(string, sizeof(string), "Pap: %s és %s meleg társaknak nyilványítalak titeket...Férj & Férj, megcsókolhatod.", sendername, giveplayer);
						SendClientMessage(playerid, COLOR_WHITE, string);
				   		format(string, sizeof(string), "Pap: %s és %s meleg társaknak nyilványítalak titeket...Férj & Férj, megcsókolhatod.", giveplayer, sendername);
						SendClientMessage(ProposedTo[playerid], COLOR_WHITE, string);
						format(string, sizeof(string), "Házasság: Van egy új meleg párunk, %s & %s összeházasodott.", sendername, giveplayer);
						SendClientMessageToAll(COLOR_WHITE, string);
					}
					else if(PlayerInfo[playerid][pSex] == 2 && PlayerInfo[ProposedTo[playerid]][pSex] == 2)
					{
					    format(string, sizeof(string), "Pap: %s és %s meleg társaknak nyilványítalak titeket...Feleség & Feleség, megcsókolhatod.", sendername, giveplayer);
						SendClientMessage(playerid, COLOR_WHITE, string);
				   		format(string, sizeof(string), "Pap: %s és %s meleg társaknak nyilványítalak titeket...Feleség & Feleség, megcsókolhatod.", giveplayer, sendername);
						SendClientMessage(ProposedTo[playerid], COLOR_WHITE, string);
						format(string, sizeof(string), "Házasság: Van egy új leszbikus pársunk, %s & %s összeházasodott.", sendername, giveplayer);
						SendClientMessageToAll(COLOR_WHITE, string);
					}
					//MarriageCeremoney[ProposedTo[playerid]] = 1;
					MarriageCeremoney[ProposedTo[playerid]] = 0;
					MarriageCeremoney[playerid] = 0;
					format(string, sizeof(string), "%s", sendername);
					strmid(PlayerInfo[ProposedTo[playerid]][pMarriedTo], string, 0, strlen(string), 255);
					format(string, sizeof(string), "%s", giveplayer);
					strmid(PlayerInfo[playerid][pMarriedTo], string, 0, strlen(string), 255);
					GiveMoney(playerid, - 100000);
					PlayerInfo[playerid][pMarried] = 1;
					PlayerInfo[ProposedTo[playerid]][pMarried] = 1;
					PlayerInfo[ProposedTo[playerid]][pPhousekey] = PlayerInfo[playerid][pPhousekey];
					PlayerInfo[ProposedTo[playerid]][pPbiskey] = PlayerInfo[playerid][pPbiskey];
					ProposedTo[playerid] = 999;
					MarriageCeremoney[playerid] = 0;
				    return 1;
			    }
			    else
			    {
			        MarriageCeremoney[playerid] = 0;
			        ProposedTo[playerid] = 999;
			        return 0;
			    }
			}
		}
		else if ((strcmp("nem", tmp, true, strlen(tmp)) == 0) && (strlen(tmp) == strlen("nem")))
		{
		    if(GotProposedBy[playerid] < 999)
		    {
				if(IsPlayerConnected(GotProposedBy[playerid]))
				{
					GetPlayerName(playerid, sendername, sizeof(sendername));
					GetPlayerName(GotProposedBy[playerid], giveplayer, sizeof(giveplayer));
					format(string, sizeof(string), "* Nem akarod házastársul %s, nem 'igen'-t irtál.",giveplayer);
				    SendClientMessage(playerid, COLOR_YELLOW, string);
				    format(string, sizeof(string), "* %s nem akart elvenni, nem 'igen'-t írt.",sendername);
				    SendClientMessage(GotProposedBy[playerid], COLOR_YELLOW, string);
				    return 1;
			    }
			    else
			    {
			        MarriageCeremoney[playerid] = 0;
			        GotProposedBy[playerid] = 999;
			        return 0;
			    }
		    }
		    else if(ProposedTo[playerid] < 999)
			{
			    if(IsPlayerConnected(ProposedTo[playerid]))
				{
					GetPlayerName(playerid, sendername, sizeof(sendername));
					GetPlayerName(ProposedTo[playerid], giveplayer, sizeof(giveplayer));
					format(string, sizeof(string), "* Nem akarod házastársul %s, nem 'igen'-t irtál.",giveplayer);
				    SendClientMessage(playerid, COLOR_YELLOW, string);
				    format(string, sizeof(string), "* %s nem akart elvenni, nem 'igen'-t írt.",sendername);
				    SendClientMessage(ProposedTo[playerid], COLOR_YELLOW, string);
				    return 1;
			    }
			    else
			    {
			        MarriageCeremoney[playerid] = 0;
			        ProposedTo[playerid] = 999;
			        return 0;
			    }
			}
		}
	    return 0;
	}
	if(ConnectedToPC[playerid] == 255)
	{
		new idx;
	    tmp = strtok(text, idx);
		if(egyezik(tmp, "versenyzõk") || egyezik(tmp, "versenyzok"))
		{
			if(!IsHitman(playerid)) return 1;

			SendFormatMessage(playerid, COLOR_WHITE, "Versenyzõk száma: %d | Hátralévõ idõ: %d másodperc(%d Perc)", BVJatekosok, BVIdo, BVIdo/60);

			new loszer, weapon[13], ammo[13], Float:elet, Float:pajzs;
			for(new x = 0; x < MAX_PLAYERS; x++)
			{
				if(!IsPlayerConnected(x) || !Logged(x) || IsPlayerNPC(x) || BViadal[x] != 1) continue;

				for(new y = 0; y < 13; y++)
				{
					GetPlayerWeaponData(x, y, weapon[y], ammo[y]);
					if(weapon[y] == GetPlayerWeapon(x))
					{
						loszer = ammo[y];
						break;
					}
				}

				GetPlayerHealth(x, elet);
				GetPlayerArmour(x, pajzs);

				SendFormatMessage(playerid, COLOR_WHITE, "Név: %s | Fegyver: %s | Lõszer: %d | Élet: %.1f | Pajzs: %.1f", PlayerName(x), aWeaponNames[GetPlayerWeapon(x)], loszer, elet, pajzs);
			}

			return 0;
		}
	    if(egyezik(tmp, "vérdíjak") || egyezik(tmp, "verdijak"))
		{
			new fejpenz, emberek, txt[128];
			for(new x = 0; x < MAX_PLAYERS; x++)
			{
				if(x != playerid && IsPlayerConnected(x) && Logged(x) && !IsHitman(x))
				{
					fejpenz = PlayerInfo[x][pHeadValue];
					if(fejpenz > 0)
					{
						emberek++;
						if(emberek % 4 != 0)
						{
							if(emberek % 4 == 1)
								format(txt, sizeof(txt), "%s [%d]", PlayerName(x), fejpenz);
							else
								format(txt, sizeof(txt), "%s, %s [%d]", txt, PlayerName(x), fejpenz);
						}
						else
						{
							format(txt, sizeof(txt), "%s, %s [%d]", txt, PlayerName(x), fejpenz);
							SendClientMessage(playerid, COLOR_GREY, txt);
						}
					}
				}
				if(x == (MAX_PLAYERS - 1) && emberek % 4 != 0)
					SendClientMessage(playerid, COLOR_GREY, txt);
			}
			if(emberek < 1)
				return !Msg(playerid, "Nincs vérdíj senkin", false, COLOR_GREY);
			return 0;
		}
		
		if(egyezik(tmp, "bilincs"))
		{
			Bilincs(playerid, 0);
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
			RemovePlayerAttachedObject(playerid, ATTACH_SLOT_ZSAK_PAJZS_BILINCS);
			Cselekves(playerid, "matat a kezével", 1);
			Msg(playerid, "Bilincs levéve");
			return 0;
		}

		if(egyezik(tmp, "cian"))
		{
			Msg(playerid, "Megmérgezted magad");
			SetHealth(playerid, 0);
			return 0;
		}

		if(egyezik(tmp, "célpontok") || egyezik(tmp, "celpontok"))
		{
			new emberek;
			for(new x = 0; x < MAX_PLAYERS; x++)
			{
				if(!IsPlayerConnected(x) || !Logged(x) || IsPlayerNPC(x) || x == playerid) continue;
				if(PlayerInfo[x][pHeadValue] > 0)
				{
					emberek++;
					SetPlayerMarkerForPlayer(playerid, x, 0x00FF00AA);
				}
			}
			if(emberek < 1) SendClientMessage(playerid, COLOR_GREY,"Nincs vérdíj senkin");
			return 0;
		}

		if(egyezik(tmp, "tagok"))
		{
		    SendClientMessage(playerid, COLOR_WHITE, "=============[Hitman Tagok]=============");
		    for(new x = 0; x < MAX_PLAYERS; x++)
			{
   				if(IsHitman(x))
		    	{
		    	    if(IsDirector(playerid))
			    	{
						new time = UnixTime;
						if(PlayerInfo[x][pHitmanIdo] != 0 && PlayerInfo[x][pHitmanIdo] > time)
							SendFormatMessage(playerid, COLOR_LIGHTRED, "- [%d]%s [%s] - még %d óráig",x, PlayerName(x), PlayerInfo[x][pHitmanNev], floatround( (PlayerInfo[x][pHitmanIdo] - time ) / 3600 , floatround_ceil));
						else
							SendFormatMessage(playerid, COLOR_LIGHTRED, "- [%d]%s [%s]",x, PlayerName(x), PlayerInfo[x][pHitmanNev]);
					}
					else
					{
					    SendFormatMessage(playerid, COLOR_LIGHTRED, "- %s", PlayerInfo[x][pHitmanNev]);
					}
				}
			}
			SendClientMessage(playerid, COLOR_WHITE, "=============[Hitman Tagok]=============");
			return 0;
		}
		if(egyezik(tmp, "bombatavol"))
		{
		    if(TavoliBomba[playerid]) {
				Msg(playerid, "A bomba hatástalanítva");
				TavoliBomba[playerid] = 0;
				return 0;
			}
			new kocsim = GetClosestVehicle(playerid);
			new Float:tav = GetPlayerDistanceFromVehicle(playerid, kocsim);
			if(tav >= 4)
			{
				SendClientMessage(playerid, COLOR_LIGHTRED, "A közeledben nincs jármû!");
				return 0;
			}
			if(TavoliBomba[playerid] != 0) return !Msg(playerid, "Ebbõl a bombából csak egyett használhatsz!");
			Msg(playerid, "Bomba telepítve! Robbantáshoz /élesít");
			TavoliBomba[playerid] = kocsim;
			return 0;
		}
		if(egyezik(tmp, "bomba"))
		{
			new kocsim = GetClosestVehicle(playerid);
			new Float:tav = GetPlayerDistanceFromVehicle(playerid, kocsim);
			if(tav >= 4)
			{
			SendClientMessage(playerid, COLOR_LIGHTRED, "A közeledben nincs jármû!");
			return 0;
			}
			if(VanBombaBenne[kocsim] != NINCS) return !Msg(playerid, "Ebben a jármûben már van bomba.");
			Msg(playerid, "Bomba telepítve, ha beindítják a motort robban!");
			VanBombaBenne[kocsim] = playerid;
			return 0;
		}

		if(egyezik(tmp, "munka"))
		{
			new uzi[128];
			if(HitmanDuty[playerid])
			{
				//hitide
				Format(uzi, "<< %s befejezte a melót >>", PlayerInfo[playerid][pHitmanNev]);
				HitmanDuty[playerid] = 0;
				NoName[playerid] = false;
			}
			else
			{
				Format(uzi, "<< %s munkába állt >>", PlayerInfo[playerid][pHitmanNev]);
				HitmanDuty[playerid] = 1;
				NoName[playerid] = true;
			}
			SendMessage(SEND_MESSAGE_HITMAN, uzi, COLOR_YELLOW);
			return 0;
		}


		if(egyezik(tmp, "ruha"))
		{
			tmp = strtok(text, idx);

			if(!strlen(tmp))
				return !Msg(playerid, "ruha [ruhaid]");

			new skin = strval(tmp);

			if(!IsValidSkin(skin))
				return !Msg(playerid, "Nincs ilyen ruha!");

			SetPlayerSkin(playerid,skin);
			PlayerInfo[playerid][pModel] = skin;

			return 0;
		}

		if(egyezik(tmp, "Hírdetés") || egyezik(tmp, "Hirdetes"))
		{
		    SendClientMessageToAll(COLOR_LIGHTRED, "Hitman: Gondod van valakivel? Talán félsz a zsaruktól? Bízd ránk! Gyors és Spéci munka!((/contract))");

			return 0;
		}

		if(egyezik(tmp, "alnev") || egyezik(tmp, "álnév"))
		{
			new length = strlen(text);
			while ((idx < length) && (text[idx] <= ' '))
			{
				idx++;
			}
			new offset = idx;
			new result[MAX_PLAYER_NAME];
			while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
			{
				result[idx - offset] = text[idx];
				idx++;
			}
			result[idx - offset] = EOS;

			if(!strlen(result) && PlayerInfo[playerid][pHamisNev] == 0)
			{
				SendClientMessage(playerid, COLOR_GRAD1, "Használat: alnev [újnév]");
				return 0;
			}

			if(!strlen(result) && PlayerInfo[playerid][pHamisNev] != 0)
			{
				SendClientMessage(playerid, COLOR_GRAD1, "Újra a régi neved van!");
				PlayerInfo[playerid][pHamisNev] = 0;
				return 0;
			}

			if(strlen(result) > MAX_PLAYER_NAME)
			{
				SendFormatMessage(playerid, COLOR_GRAD1, "Maximum %d karakter!", MAX_PLAYER_NAME);
				return 0;
			}

			PlayerInfo[playerid][pHamisNev] = result;
			format(string, sizeof(string), "Az új álneved mostantól %s!", result);
			SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
			return 0;
		}
		else if(egyezik(tmp, "lenyomoz") || egyezik(tmp, "lenyomozas"))
		{
			tmp = strtok(text, idx);
			if(!strlen(tmp)) return !Msg(playerid, "Lenyomoz [Név/ID/Kikapcsol]");
			if(egyezik(tmp, "kikapcsol"))
			{
				SendClientMessage(playerid, Pink, "Lenyomoz Kikapcsolva!");
				foreach(Jatekosok, x)
				{
					SetPlayerMarkerForPlayer(playerid, x, COLOR_INVISIBLE);
					Fbicelpont[playerid] = NINCS;
					Fbios[x] = NINCS;
					return 0;
				}
			}
			new player = ReturnUser(tmp);
			if(player == INVALID_PLAYER_ID) return !Msg(playerid, "Hibás név!");
			if(PlayerInfo[player][pPnumber] == 0) return !Msg(playerid, "Nincs telefonja!");
			new vw = GetPlayerVirtualWorld(player);
			new inti = GetPlayerInterior(player);
			if(vw != 0 || inti != 0)
			{
				if(Hazbanvan[player] == 0)
				{
					if(inti == 18)
					{
						SendClientMessage(playerid, Pink, "Célszemély az egyik 24/7 be van!");
						Fbios[player] = playerid;
						return 0;
					}
					else if(inti == 3)
					{
						if(PlayerToPoint(30, player, 296.919982,-108.071998,1001.515625))
						{
							SendClientMessage(playerid, Pink, "Célszemély LS GS be van!");
							Fbios[player] = playerid;
							return 0;
						}
						else if(PlayerToPoint(100, player, 384.808624,173.804992,1008.382812))
						{
							SendClientMessage(playerid, Pink, "Célszemély Városházán van!");
							Fbios[player] = playerid;
							return 0;
						}
						else if(PlayerToPoint(100, player, 369.8337,162.5357,1014.1893))
						{
							SendClientMessage(playerid, Pink, "Célszemély Városházán van!");
							Fbios[player] = playerid;
							return 0;
						}
						else if(PlayerToPoint(100, player, 368.2852,162.4965,1019.9844))
						{
							SendClientMessage(playerid, Pink, "Célszemély Városházán van!");
							Fbios[player] = playerid;
							return 0;
						}
						else if(PlayerToPoint(100, player, 370.1142,163.1876,1025.7891))
						{
							SendClientMessage(playerid, Pink, "Célszemély Városházán van!");
							Fbios[player] = playerid;
							return 0;
						}
						else if(PlayerToPoint(50, player, 833.269775,10.588416,1004.179687))
						{
							SendClientMessage(playerid, Pink, "Célszemély a Lottozóban van!");
							Fbios[player] = playerid;
							return 0;
						}
						else if(PlayerToPoint(50, player, 207.054992,-138.804992,1003.507812))
						{
							SendClientMessage(playerid, Pink, "Célszemély a Bincoban van!");
							Fbios[player] = playerid;
							return 0;
						}
						else if(PlayerToPoint(50, player, 288.745971,169.350997,1007.171875))
						{
							SendClientMessage(playerid, Pink, "Célszemély az FBI HQ-n van!");
							Fbios[player] = playerid;
							return 0;
						}
						else if(PlayerToPoint(50, player, 1494.325195,1304.942871,1093.289062))
						{
							SendClientMessage(playerid, Pink, "Célszemély az Oktató HQ-n van!");
							Fbios[player] = playerid;
							return 0;
						}
						else if(PlayerToPoint(50, player, 942.171997,-16.542755,1000.929687))
						{
							Msg(playerid, "Adminjail.");
							Fbios[player] = playerid;
							return 0;
						}
					}
					else if(inti == 4)
					{
						SendClientMessage(playerid, Pink, "Célszemély SF GS be van!");
						Fbios[player] = playerid;
						return 0;
					}
					else if(inti == 5)
					{
						if(PlayerToPoint(50, player, 72.111999,-3.898649,1000.728820))
						{
							SendClientMessage(playerid, Pink, "Célszemély LS Edzõterembe van!");
							Fbios[player] = playerid;
							return 0;
						}
						else if(PlayerToPoint(50, player, 373.825653,-117.270904,1001.499511))
						{
							SendClientMessage(playerid, Pink, "Célszemély az egyik pizzázóban van!");
							Fbios[player] = playerid;
							return 0;
						}
					}
					else if(inti == 6)
					{
						if(PlayerToPoint(50, player, 774.213989,-48.924297,1000.585937))
						{
							SendClientMessage(playerid, Pink, "Célszemély Cobra Edzõterembe van!");
							Fbios[player] = playerid;
							return 0;
						}
						else if(PlayerToPoint(100, player, 246.783996,63.900199,1003.640625))
						{
							SendClientMessage(playerid, Pink, "Célszemély LSPD-n van!");
							Fbios[player] = playerid;
							return 0;
						}
					}
					else if(inti == 9)
					{
						SendClientMessage(playerid, Pink, "Célszemély az egyik csirkésbe van!");
						Fbios[player] = playerid;
						return 0;
					}
					else if(inti == 10)
					{
						if(PlayerToPoint(50, player, 375.962463,-65.816848,1001.507812))
						{
							SendClientMessage(playerid, Pink, "Célszemély az egyik Burger Shotba van!");
							Fbios[player] = playerid;
							return 0;
						}
						else if(PlayerToPoint(200, player, -975.975708,1060.983032,1345.671875))
						{
							SendClientMessage(playerid, Pink, "Célszemély az RC Gyakorlopályán van!");
							Fbios[player] = playerid;
							return 0;
						}
						else if(PlayerToPoint(200, player, 246.375991,109.245994,1003.218750))
						{
							if(vw == 20)
							{
								SendClientMessage(playerid, Pink, "Célszemély VPOP HQ-n van!");
								Fbios[player] = playerid;
								return 0;
							}
							else
							{
								SendClientMessage(playerid, Pink, "Célszemély SFPD HQ-n van!");
								Fbios[player] = playerid;
								return 0;
							}
						}
					}
					else if(inti == 1)
					{
						SendClientMessage(playerid, Pink, "Célszemély a Húsfeldolgozóban van!((Valameik Maffia Inti))");
						Fbios[player] = playerid;
						return 0;
					}
					else if(inti == 17)
					{
						SendClientMessage(playerid, Pink, "Célszemély Alhambrába van!");
						Fbios[player] = playerid;
						return 0;
					}
					else if(inti == 2)
					{
						Msg(playerid, "Gyárban van, de csak OOC tudod!");
						Fbios[player] = playerid;
						return 0;
					}
					else if(inti == 11)
					{
						SendClientMessage(playerid, Pink, "Célszemély Groove Kocsmában van!");
						Fbios[player] = playerid;
						return 0;
					}
				}
				else
				{
					SendFormatMessage(playerid, Pink, "Célszemély Class utca %d szám alatt tartozkodik!", vw);
					Fbios[player] = playerid;
					return 0;
				}
			}
			new Float:X,Float:Y,Float:Z;
			GetPlayerPos(player, X,Y,Z);
			SetPlayerMarkerForPlayer(playerid, player, Pink);
			SendClientMessage(playerid, Pink, "Célszemély Lenyomozva!");
			SendClientMessage(playerid, Pink, "* Kikapcsoláshoz: lenyomozás kikapcsol");
			return 0;
		}
		else if ((strcmp("Rendelés", tmp, true, strlen(tmp)) == 0) && (strlen(tmp) == strlen("Rendelés")) || (strcmp("Rendeles", tmp, true, strlen(tmp)) == 0) && (strlen(tmp) == strlen("Rendeles")))
		{
			if(!PlayerToPoint(5.0, playerid, -1446.7, -1544.3, 101.9))
			{
				SetPlayerCheckpoint(playerid, -1446.7, -1544.3, 101.9, 3);
				Msg(playerid, "Nem vagy a rendelõhelyen");
				return 0;
			}
		    tmp = strtok(text, idx);
			if(!strlen(tmp))
			{
			    SendClientMessage(playerid, COLOR_WHITE, "|__________________ Fegyver csomagok __________________|");
				SendClientMessage(playerid, COLOR_GREY, "|(1) (90,000Ft) Kés, Deagle, MP5, Shotgun");
				SendClientMessage(playerid, COLOR_GREY, "|(2) (125,000Ft) Péncél, Kés, Deagle, M4, MP5, Shotgun");
				SendClientMessage(playerid, COLOR_GREY, "|(3) (150,000Ft) Péncél, Kés, Deagle, AK47, MP5, Shotgun");
				SendClientMessage(playerid, COLOR_GREY, "|(4) (200,000Ft) Péncél, Kés, Deagle, M4, MP5, Shotgun, Távcsöves");
				SendClientMessage(playerid, COLOR_GREY, "|(5) (225,000Ft) Péncél, Kés, Deagle, AK47, MP5, Shotgun, Távcsöves");
				SendClientMessage(playerid, COLOR_GREY, "|(6) (250,000Ft) Süti, Péncél, Kés, Deagle, M4, MP5, Shotgun, Távcsöves");
				SendClientMessage(playerid, COLOR_GREY, "|(7) (275,000Ft) Süti, Péncél, Kés, Hangtompitós, AK47, MP5, Shotgun, Távcsöves");
				SendClientMessage(playerid, COLOR_GREY, "|(8) (300,000Ft) Süti, Péncél, Kés, Hangtompitós, AK47, Tec 9, Shotgun, Távcsöves");
				SendClientMessage(playerid, COLOR_GREY, "|(9) (325,000Ft) Süti, Péncél, Kés, Hangtompitós, AK47, Tec 9, Shotgun, Távcsöves");
				SendClientMessage(playerid, COLOR_GREY, "|(10) (350,000Ft) Süti, Péncél, Kés, Hangtompitós, AK47, Tec 9, Sörétes, Távcsöves");
				SendClientMessage(playerid, COLOR_GREY, "|(X) (30000Ft) Süti, Péncél + Egyéni fegyver > \"rendelés x [fegyver]\"");
			    SendClientMessage(playerid, COLOR_WHITE, "|________________________________________________________|");
				return 0;
			}
			new rendeles = strval(tmp);
			switch (rendeles)
			{
				case 1:
				{
					if(GetMoney(playerid) < 90000) return !Msg(playerid, "Ehhez 90,000Ft kell!");

					WeaponGiveWeapon(playerid, 24, 100); WeaponGiveWeapon(playerid, 29, 300); WeaponGiveWeapon(playerid, 25, 100); WeaponGiveWeapon(playerid, 4, 1);
					GiveMoney(playerid, - 90000);
					SendClientMessage(playerid, COLOR_LIGHTBLUE, "* Felvetted a megrendelt csomagot!");
				}
				case 2:
				{
					if(GetMoney(playerid) < 125000) return !Msg(playerid, "Ehhez 125,000Ft kell!");

					SetPlayerArmour(playerid, 150.0);
					WeaponGiveWeapon(playerid, 24, 100); WeaponGiveWeapon(playerid, 29, 300); WeaponGiveWeapon(playerid, 25, 100); WeaponGiveWeapon(playerid, 31, 500); WeaponGiveWeapon(playerid, 4, 1);
					GiveMoney(playerid, - 125000);
					SendClientMessage(playerid, COLOR_LIGHTBLUE, "* Felvetted a megrendelt csomagot!");
				}
				case 3:
				{
					if(GetMoney(playerid) < 150000) return !Msg(playerid, "Ehhez 150,000Ft kell!");

					SetPlayerArmour(playerid, 150.0);
					WeaponGiveWeapon(playerid, 24, 100); WeaponGiveWeapon(playerid, 29, 300); WeaponGiveWeapon(playerid, 25, 100); WeaponGiveWeapon(playerid, 30, 500); WeaponGiveWeapon(playerid, 4, 1);
					GiveMoney(playerid, - 150000);
					SendClientMessage(playerid, COLOR_LIGHTBLUE, "* Felvetted a megrendelt csomagot!");
				}
				case 4:
				{
					if(GetMoney(playerid) < 200000) return !Msg(playerid, "Ehhez 200,000Ft kell!");

					SetPlayerArmour(playerid, 150.0);
					WeaponGiveWeapon(playerid, 24, 100); WeaponGiveWeapon(playerid, 29, 300); WeaponGiveWeapon(playerid, 25, 100); WeaponGiveWeapon(playerid, 31, 500); WeaponGiveWeapon(playerid, 4, 1); WeaponGiveWeapon(playerid, 34, 100);
					GiveMoney(playerid, - 200000);
					SendClientMessage(playerid, COLOR_LIGHTBLUE, "* Felvetted a megrendelt csomagot!");
				}
				case 5:
				{
					if(GetMoney(playerid) < 225000) return !Msg(playerid, "Ehhez 225,000Ft kell!");

					SetPlayerArmour(playerid, 150.0);
					WeaponGiveWeapon(playerid, 24, 100); WeaponGiveWeapon(playerid, 29, 300); WeaponGiveWeapon(playerid, 25, 100); WeaponGiveWeapon(playerid, 30, 500); WeaponGiveWeapon(playerid, 4, 1); WeaponGiveWeapon(playerid, 34, 100);
					GiveMoney(playerid, - 225000);
					SendClientMessage(playerid, COLOR_LIGHTBLUE, "* Felvetted a megrendelt csomagot!");
				}
				case 6:
				{
					if(GetMoney(playerid) < 250000) return !Msg(playerid, "Ehhez 250,000Ft kell!");

					SetPlayerArmour(playerid, 150.0); SetHealth(playerid, MAXHP);
					WeaponGiveWeapon(playerid, 24, 100); WeaponGiveWeapon(playerid, 29, 300); WeaponGiveWeapon(playerid, 27, 100); WeaponGiveWeapon(playerid, 31, 500); WeaponGiveWeapon(playerid, 4, 1); WeaponGiveWeapon(playerid, 34, 100);
					GiveMoney(playerid, - 250000);
					SendClientMessage(playerid, COLOR_LIGHTBLUE, "* Felvetted a megrendelt csomagot!");
				}
				case 7:
				{
					if(GetMoney(playerid) < 275000) return !Msg(playerid, "Ehhez 275,000Ft kell!");

					SetPlayerArmour(playerid, 150.0); SetHealth(playerid, MAXHP);
					WeaponGiveWeapon(playerid, 23, 100); WeaponGiveWeapon(playerid, 29, 300); WeaponGiveWeapon(playerid, 25, 100); WeaponGiveWeapon(playerid, 30, 500); WeaponGiveWeapon(playerid, 4, 1); WeaponGiveWeapon(playerid, 34, 100);
					GiveMoney(playerid, - 275000);
					SendClientMessage(playerid, COLOR_LIGHTBLUE, "* Felvetted a megrendelt csomagot!");
				}
				case 8:
				{
					if(GetMoney(playerid) < 300000) return !Msg(playerid, "Ehhez 300,000 kell!");

					SetPlayerArmour(playerid, 150.0); SetHealth(playerid, MAXHP);
					WeaponGiveWeapon(playerid, 23, 100); WeaponGiveWeapon(playerid, 32, 300); WeaponGiveWeapon(playerid, 25, 10); WeaponGiveWeapon(playerid, 30, 500); WeaponGiveWeapon(playerid, 4, 1); WeaponGiveWeapon(playerid, 34, 100);
					GiveMoney(playerid, - 300000);
					SendClientMessage(playerid, COLOR_LIGHTBLUE, "* Felvetted a megrendelt csomagot!");
				}
				case 9:
				{
					if(GetMoney(playerid) < 325000) return !Msg(playerid, "Ehhez 325,000 kell!");

					SetPlayerArmour(playerid, 150.0); SetHealth(playerid, MAXHP);
					WeaponGiveWeapon(playerid, 23, 100); WeaponGiveWeapon(playerid, 32, 300); WeaponGiveWeapon(playerid, 25, 100); WeaponGiveWeapon(playerid, 30, 500); WeaponGiveWeapon(playerid, 4, 1); WeaponGiveWeapon(playerid, 34, 100);
					GiveMoney(playerid, - 325000);
					SendClientMessage(playerid, COLOR_LIGHTBLUE, "* Felvetted a megrendelt csomagot!");
				}
				case 10:
				{
					if(GetMoney(playerid) < 350000) return !Msg(playerid, "Ehhez 350,000Ft kell!");

					SetPlayerArmour(playerid, 150.0); SetHealth(playerid, MAXHP);
					WeaponGiveWeapon(playerid, 23, 100); WeaponGiveWeapon(playerid, 32, 300); WeaponGiveWeapon(playerid, 26, 100); WeaponGiveWeapon(playerid, 30, 500); WeaponGiveWeapon(playerid, 4, 1); WeaponGiveWeapon(playerid, 34, 100);
					GiveMoney(playerid, - 350000);
					SendClientMessage(playerid, COLOR_LIGHTBLUE, "* Felvetted a megrendelt csomagot!");
				}
				case 0:
				{
					if(GetMoney(playerid) < 30000) return !Msg(playerid, "Ehhez 30,000Ft kell!");

					tmp = strtok(text, idx);
					if(!strlen(tmp))
						return !Msg(playerid, "Használata: rendelés 0 [fegyvernév]");

					new f = NINCS;
					for(new x = 1; x <= 46; x++)
					{
						if(strfind(aWeaponNames[x], tmp, true) != -1)
							f = x;
					}

					new loszer = 1;
					switch(f)
					{
						// Tiltottak
						case NINCS, 18..21, 35..40, 43..45:
							return !SendClientMessage(playerid, COLOR_LIGHTBLUE, "Ilyen fegyver nincs, vagy tiltott!");

						// Gránátok
						case 16, 17: loszer = 15;

						// Pisztolyok
						case 22..24: loszer = 100;

						// Shotgunok, rifle, sniper
						case 25..27, 33, 34: loszer = 100;

						// Közepes gépfegyverek (mp5, tec9, uzi)
						case 28, 29, 32: loszer = 300;

						// Nagy gépfegyverek (m4, ak47)
						case 30, 31: loszer = 500;

						// Sok lõszeresek: spré, poroltó
						case 41, 42: loszer = 1000;
					}

					SetPlayerArmour(playerid, 150.0); SetHealth(playerid, MAXHP);
					WeaponGiveWeapon(playerid, f, loszer);
					GiveMoney(playerid, - 30000);
					SendFormatMessage(playerid, COLOR_LIGHTBLUE, "* Felvetted a megrendelt fegyvert: %s", aWeaponNames[f]);
				}
				default:
					Msg(playerid, "Nincs ilyen csomag");
			}
			return 0;
		}
		else if((strcmp("Kikapcsol", tmp, true, strlen(tmp)) == 0) && (strlen(tmp) == strlen("Kikapcsol")))
		{
		    SendClientMessage(playerid, COLOR_LIGHTBLUE, "* Kikapcsoltad a laptopodat.");
      		ConnectedToPC[playerid] = 0;
		    return 0;
		}
		else
		{
			HitmanLaptop(playerid);
		    return 0;
		}

	}
	if(TalkingLive[playerid] != 255)
	{
		GetPlayerName(playerid, sendername, sizeof(sendername));
		if(RiporterAlive[playerid] ==1){sendername="Névtelen";}
	    format(string, sizeof(string), "~~~ *ÉLÕ* %s: %s ~~~", sendername, text);
		SendMessage(SEND_MESSAGE_OOCNEWS, string, COLOR_Live);
		return 0;
	}
	if(Mobile[playerid] != 255)
	{
		//telefon beszéd
		new idx;
		tmp = strtok(text, idx);
		GetPlayerName(playerid, sendername, sizeof(sendername));
		format(string, sizeof(string), "[Telefon] Valaki (%s) mondja: %s", NemVizsgalat(PlayerInfo[playerid][pSex]), text);
		ProxDetector(20.0, playerid, string,COLOR_FADE1,COLOR_FADE2,COLOR_FADE3,COLOR_FADE4,COLOR_FADE5);
		foreach(Jatekosok, p)
		{
			if(Poloska[p] && Poloskazott[playerid] && Poloskazta[p] == playerid)
				SendFormatMessage(p, COLOR_DORANGE, "<< Poloska (telefon): %s: %s >>", sendername, text);
		}

		if(Mobile[playerid] == 1004)
		{
			strmid(Mento[playerid], text, 0, strlen(text), 64);
			SendClientMessage(playerid, COLOR_ALLDEPT, "Mentõszolgálat: Kérem röviden mondja el, hogy hol történt az eset!");
			Mobile[playerid] = 1041;
			return 0;
		}
		if(Mobile[playerid] == 1041)
		{
			strmid(MentoHelyszin[playerid], text, 0, strlen(text), 64);
			SendClientMessage(playerid, COLOR_ALLDEPT, "Mentõszolgálat: Szüksége van légiegységre? [igen]");
			Mobile[playerid] = 1042;
			return 0;
		}
		if(Mobile[playerid] == 1042)
		{
			if(egyezik(text, "igen")) MentoLegi[playerid] = 1;
			else if(egyezik(text, "nem")) MentoLegi[playerid] = 2;
			else
			{
				SendClientMessage(playerid, COLOR_ALLDEPT, "Mentõszolgálat: Igen vagy nem?");
				return 0;
			}
			SendRadioMessageFormat(FRAKCIO_MENTO, TEAM_AZTECAS_COLOR, "** %s mentõt hívott - Ahhoz hogy elfogadd, /accept medic %d", ICPlayerName(playerid), playerid);
			new szoveg[6];
			if(MentoLegi[playerid] == 2) szoveg = " nem ";
			SendRadioMessageFormat(FRAKCIO_MENTO, TEAM_AZTECAS_COLOR, "** Információk: Légiegység: %skell  Történt: %s Helyszín: %s   ", szoveg, Mento[playerid], MentoHelyszin[playerid]);
			if(OnlineTagok(FRAKCIO_MENTO) < 1)
			{
				tformat(128, "** %s mentõt hívott - Ahhoz hogy elfogadd, /accept medic %d", ICPlayerName(playerid), playerid); 
				SendMessage(SEND_MESSAGE_ONKENTES, _tmpString, TEAM_BLUE_COLOR);
				tformat(128, "** Információk: Légiegység: %skell  Történt: %s Helyszín: %s   ", szoveg, Mento[playerid], MentoHelyszin[playerid]); 
				SendMessage(SEND_MESSAGE_ONKENTES, _tmpString, TEAM_BLUE_COLOR);
			}
			Mobile[playerid] = 255;
			SendClientMessage(playerid, COLOR_ALLDEPT, "Mentõszolgálat: Azonnal indulunk! ((Várj türelmesen, ha már nem kell mentõ akkor pedig /cancel medic ))");
			SendClientMessage(playerid, COLOR_GRAD2, "Lerakták.");
			MentoHivas[playerid] = 1;
			return 0;
		}


		if(Mobile[playerid] == 1005)
		{
			strmid(CallTuzOk[playerid], text, 0, strlen(text), 128);
			SendRadioMessageFormat(FRAKCIO_TUZOLTO, TEAM_AZTECAS_COLOR, "** %s tûzoltót hívott, látod a radaron!", ICPlayerName(playerid));
			SendRadioMessageFormat(FRAKCIO_TUZOLTO, TEAM_AZTECAS_COLOR, "** Oka: %s", CallTuzOk[playerid]);

			foreach(Jatekosok, x)
				if(LMT(x, FRAKCIO_TUZOLTO)) SetPlayerMarkerForPlayer(x, playerid, COLOR_LIGHTGREEN);

			//SendClientMessage(playerid, COLOR_LIGHTBLUE, "* Hívtál mentõt, várj a válaszra.");
			Mobile[playerid] = 255;
			CallTuz[playerid] = 300;
			SendClientMessage(playerid, COLOR_ALLDEPT, "Tûzoltók: Azonnal indulunk!");
			SendClientMessage(playerid, COLOR_LIGHTBLUE, "* Hívtál tûzoltót, várj a válaszra.");
			SendClientMessage(playerid, COLOR_GRAD2, "Lerakták.");
			return 0;
		}
		
		if(Mobile[playerid] == 1003 && OnAirID == playerid)
		{
			if(strcmp(RadioMusorNev,"NINCS") == 0)
				format(_tmpString, sizeof(_tmpString), "Betelefonáló %s: %s", ICPlayerName(playerid), text);
			else
				format(_tmpString, sizeof(_tmpString), "%s - Betelefonáló %s: %s", RadioMusorNev, ICPlayerName(playerid), text);
			SendMessage(SEND_MESSAGE_OOCNEWS, _tmpString, COLOR_NEWS);
			return 0;
		}


		if(Mobile[playerid] == 912)
		{
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_ALLDEPT, "911: Elnézést de nem értem.");
				return 0;
			}
			strmid(Bejelent[playerid], text, 0, strlen(text), 255);
			SendClientMessage(playerid, COLOR_DBLUE, "Rendõrség: Tudja az elkövetõ nevét? Ha nem csak mondja: ''nem''.");
			Mobile[playerid] = 913;
			return 0;
		}

		if(Mobile[playerid] == 913)
		{
			if(!strlen(tmp))
			{
				SendClientMessage(playerid, COLOR_ALLDEPT, "Rendõrség: Sajnálom... nem értem");
				return 0;
			}

			//new wanted[128];

			if(strcmp("nem", tmp, true) == 0)
			{
				new turner[MAX_PLAYER_NAME];
				GetPlayerName(playerid, turner, sizeof(turner));
				SendClientMessage(playerid, COLOR_DBLUE, "Rendõrség: Minden egység riasztva. Köszönjük bejelentését!");

				CopMsg(COLOR_DBLUE, "=========== BEJELENTÉS ===========");
				if(TelefonTipus[playerid]==1)
				{
					turner="Nyílvános telefon";
					CopMsgFormat(COLOR_DBLUE, "HQ: Minden egységnek! Bejelentõ: %s | Tettes: Ismeretlen",turner);
				}
				else
				{
					CopMsgFormat(COLOR_DBLUE, "HQ: Minden egységnek! Bejelentõ: %s | Tettes: Ismeretlen",turner);
				}
				
				CopMsgFormat(COLOR_DBLUE, "HQ: Bûncselekmény: %s",Bejelent[playerid]);
				SendClientMessage(playerid, COLOR_GRAD2, "Lerakták.");
				
				Mobile[playerid] = 255;
				return 0;
			}
			new badguy;

			badguy = ReturnUser(tmp);
			if (IsPlayerConnected(badguy))
			{
			    if(badguy != INVALID_PLAYER_ID)
			    {
					SendClientMessage(playerid, COLOR_DBLUE, "Rendõrség: Minden egység riasztva. Köszönjük bejelentését!");


					CopMsg(COLOR_DBLUE, "=========== BEJELENTÉS ===========");
					if(TelefonTipus[playerid]==1)
					{
						CopMsgFormat(COLOR_DBLUE, "HQ: Minden egységnek! Bejelentõ: Nyílvános telefon | Tettes: %s",ICPlayerName(badguy));
					}
					else
					{
						CopMsgFormat(COLOR_DBLUE, "HQ: Minden egységnek! Bejelentõ: %s | Tettes: %s", ICPlayerName(playerid), ICPlayerName(badguy));
					}

					CopMsgFormat(COLOR_DBLUE, "HQ: Bûncselekmény: %s",Bejelent[playerid]);
					
					
					if(!egyezik(Bejelent[playerid],"Hackerkedés!") &&  !egyezik(Bejelent[playerid],"Elsõfokú Gyilkos"))
						SetPlayerCriminal(badguy,playerid,Bejelent[playerid]);

					SendClientMessage(playerid, COLOR_GRAD2, "Lerakták.");
					Mobile[playerid] = 255;
					return 0;
				}//invalid id
				return 0;
			}//not connected
			else
			{
				SendFormatMessage(playerid, COLOR_DBLUE, "Rendõrség: Sajnálom, nincs információnk errõl a személyrõl: %s. Biztos jó név?", tmp);
				return 0;
			}
		}

		if(IsPlayerConnected(Mobile[playerid]))
		{
		    if(Mobile[Mobile[playerid]] == playerid)
			{
				SendClientMessage(Mobile[playerid], COLOR_YELLOW,string);
				new szoveg[300];
				format(szoveg,sizeof(szoveg),"[TELEFON]%s mondja %s-nek: %s",PlayerName(playerid),PlayerName(Mobile[playerid]),text);
				Log("Chat", szoveg);
			}	
			foreach(Jatekosok, x)
			{
				if(Lehallgat[x] == playerid)
				{
					new idx2;
					tmp = strtok(text, idx2);
					SendFormatMessage(x, COLOR_LIGHTBLUE,"[Lehallgatott Telefon(%s)] Valaki mondja: %s", FormatNumber(PlayerInfo[x][pPnumber], 0, '-' ),text);
				}
				if(Lehallgat[x] == Mobile[playerid])
				{
					new idx3;
					tmp = strtok(text, idx3);
					SendFormatMessage(x, COLOR_LIGHTBLUE,"[Lehallgatott Telefon(%s)] Valaki mondja: %s",FormatNumber(PlayerInfo[x][pPnumber], 0, '-' ),text);
				}
			}
		}

		else
			SendClientMessage(playerid, COLOR_YELLOW,"Nincs senki a vonalban...((kilépet nem online))");
		return 0;
	}

	if(PlayerRaceInfo[playerid][xEpites] != NINCS)
	{
		new params = Parameterek(text);
		new param[3][32];
		new idx;

		if(params > 0)
		{
			new params_szamlalo = 1;
			while(params_szamlalo <= params && params_szamlalo < sizeof(param))
			{
				param[params_szamlalo] = GetParam(text, params_szamlalo);
				params_szamlalo++;
			}
		}

		new funkcio[32];
		funkcio = strtok(text, idx);

		new slot = PlayerRaceInfo[playerid][xEpites];

		if(egyezik(funkcio, "start"))
		{
			new Float:x, Float:y, Float:z;
			GetPlayerPos(playerid, x, y, z);
			SetPlayerRaceCheckpoint(playerid, 2, x, y, z, 0.0, 0.0, 0.0, RACECPMERETB);
			RaceStart[slot][0] = x;
			RaceStart[slot][1] = y;
			RaceStart[slot][2] = z;

			Msg(playerid, "Start checkpoint lerakva", false);
		}
		else if(egyezik(funkcio, "finish"))
		{
			new Float:x, Float:y, Float:z;
			GetPlayerPos(playerid, x, y, z);
			SetPlayerRaceCheckpoint(playerid, 2, x, y, z, 0.0, 0.0, 0.0, RACECPMERETB);
			RaceCel[slot][0] = x;
			RaceCel[slot][1] = y;
			RaceCel[slot][2] = z;

			Msg(playerid, "Finish checkpoint lerakva", false);
		}
		/*else if(egyezik(funkcio, "CP"))
		{
			if(params < 1)
			{
				Msg(playerid, "Használata: cp [szám]", false);
				return 0;
			}

			new cp = strval(param[1]);
			if(cp < 0 || cp >= RACEMAXCP)
				Msg(playerid, "Nincs ilyen CP!", false);

			PlayerRaceInfo[playerid][xEpitesCP] = cp;
			SendFormatMessage(playerid, COLOR_LIGHTRED, "Az építés a %d CPtõl folytatódik", cp);
		}*/
		else if(egyezik(funkcio, "next"))
		{
			if(PlayerRaceInfo[playerid][xEpitesCP] >= RACEMAXCP)
			{
				Msg(playerid, "Elérted a maximális CP számát! Rakd le a Finish-t!", false);
				return 0;
			}

			new Float:x, Float:y, Float:z;
			GetPlayerPos(playerid, x, y, z);
			SetPlayerRaceCheckpoint(playerid, 2, x, y, z, 0.0, 0.0, 0.0, RACECPMERETB);

			PlayerRaceInfo[playerid][xEpitesCP]++;
			new cp = PlayerRaceInfo[playerid][xEpitesCP];
			RaceCP[slot][cp][0] = x;
			RaceCP[slot][cp][1] = y;
			RaceCP[slot][cp][2] = z;

			SendFormatMessage(playerid, COLOR_LIGHTRED, "Ez volt a %d. CP, még %d CP-t rakhatsz le!", cp, (RACEMAXCP - cp));
		}
		else if(egyezik(funkcio, "back"))
		{
			new cp = PlayerRaceInfo[playerid][xEpitesCP];
			if(cp == 0)
			{
				Msg(playerid, "Hova akarsz már visszamenni? Ez a nulladik... -.-\"", false);
				return 0;
			}
			new Float:x, Float:y, Float:z;
			x = RaceCP[slot][cp-1][0];
			y = RaceCP[slot][cp-1][1];
			z = RaceCP[slot][cp-1][2];

			SetPlayerRaceCheckpoint(playerid, 2, x, y, z, 0.0, 0.0, 0.0, RACECPMERETB);
			PlayerRaceInfo[playerid][xEpitesCP] = cp - 1;
			SendFormatMessage(playerid, COLOR_LIGHTRED, "Visszaugrottál a %d. CPre", (cp-1));
		}
		else if(egyezik(funkcio, "save"))
		{
			if(RaceNameBuild == NINCS) return Msg(playerid,"Nincs megadva a race neve, elõbb add meg!");
			if(RaceStart[slot][0] == 0.0 || RaceStart[slot][1] == 0.0 || RaceStart[slot][2] == 0.0 || RaceCel[slot][0] == 0.0 || RaceCel[slot][1] == 0.0 || RaceCel[slot][2] == 0.0)
			{
				Msg(playerid, "Nincs megadva Start vagy Cél pozíció!", false);
				return 0;
			}

			if(!strlen(RaceInfo[slot][rNev]))
			{
				Msg(playerid, "A Racenek nincs neve, adnod kell egy nevet neki > nev [név]", false);
				return 0;
			}

			if(!strlen(RaceNameBuildText))
			{
				Msg(playerid, "A Racenek nincs neve, adnod kell egy nevet neki > nev [név]", false);
				return 0;
			}
			
			new where[64];
		
			

			new query[350], setdata[40], start[40], cel[40];
			Format(start, "%.2f,%.2f,%.2f", RaceStart[slot][0], RaceStart[slot][1], RaceStart[slot][2]);
			Format(cel, "%.2f,%.2f,%.2f", RaceCel[slot][0], RaceCel[slot][1], RaceCel[slot][2]);

			
			Format(where, "SNev='%s'", RaceNameBuildText);
			/*format( _tmpString, 128, "SELECT * FROM %s WHERE %s", SQL_DB_Verseny,where);
			printf("SELECT * FROM %s WHERE %s", SQL_DB_Verseny,where);
			doQuery( _tmpString , SQL_RACE_SAVE );*/
			
			new rows, fields;
			sql_data(rows, fields);
			
			if(RaceNameBuild == 1)
			{
				Format(query, "INSERT INTO %s (SNev, Nev, Start, Cel) VALUES('%s', '%s', '%s', '%s')", SQL_DB_Verseny, RaceNameBuildText, RaceInfo[slot][rNev], start, cel);
				printf("INSERT INTO %s (SNev, Nev, Start, Cel) VALUES('%s', '%s', '%s', '%s')", SQL_DB_Verseny, RaceNameBuildText, RaceInfo[slot][rNev], start, cel);
			}
			elseif(RaceNameBuild == 2)
			{
				Format(query, "UPDATE %s SET SNev='%s', Nev='%s', Start='%s', Cel='%s' WHERE %s", SQL_DB_Verseny, RaceNameBuildText, RaceInfo[slot][rNev], start, cel, where);
				printf("UPDATE %s SET SNev='%s', Nev='%s', Start='%s', Cel='%s' WHERE %s", SQL_DB_Verseny, RaceNameBuildText, RaceInfo[slot][rNev], start, cel, where);
			}
			else
				return Msg(playerid, "HIBA");
				
			doQuery( query );

			new cp;
			for(new x = 0; x < RACEMAXCP; x++)
			{
				if(RaceCP[slot][x][0] == 0.0 || RaceCP[slot][x][1] == 0.0 || RaceCP[slot][x][2] == 0.0) continue;

				Format(setdata, "%f,%f,%f", RaceCP[slot][x][0], RaceCP[slot][x][1], RaceCP[slot][x][2]);
				Format(query, "UPDATE %s SET CK%d = '%s' WHERE %s", SQL_DB_Verseny, cp, setdata, where);
				printf("UPDATE %s SET CK%d = '%s' WHERE %s", SQL_DB_Verseny, cp, setdata, where);
				doQuery( query );
				cp++;
			}
			Format(query, "UPDATE %s SET Checkpointok='%d' WHERE %s", SQL_DB_Verseny, cp, where);
			printf("UPDATE %s SET Checkpointok='%d' WHERE %s", SQL_DB_Verseny, cp, where);
			doQuery( query );

			SendFormatMessage(playerid, COLOR_YELLOW, "%s mentve - CPk száma %d", RaceNameBuildText, cp);
			Msg(playerid, "A race-t ujra kell loadolnod, ha újra szerkeszteni szeretnéd v. indítani", false);
			RaceInfo[slot][rStatusz] = RACE_NINCS;
			PlayerRaceInfo[playerid][xEpites] = NINCS;
			DisablePlayerRaceCheckpoint(playerid);
			RaceNameBuild=NINCS;
		}
		else if(egyezik(funkcio, "nev"))
		{
			new parancs[4];
			if(sscanf(text, "s[3] s[32] s[128]", parancs, RaceNameBuildText, RaceInfo[slot][rNev]))
			{
				Msg(playerid, "nev rövidnév hosszúnév");
				Msg(playerid, "Használata: save [savenév] - NEM tartalmazhat space-t!");
				return 0;
			}

			SendFormatMessage(playerid, COLOR_LIGHTRED, "A Race neve beállítva: parancs: %s Teljes név: %s", RaceNameBuildText,RaceInfo[slot][rNev]);
			RaceNameBuild=true;
			
			sql_query(TFormatInline("SELECT * FROM %s WHERE SNev='%s'",SQL_DB_Verseny,RaceNameBuildText),"Race_Lista_Build", "d", playerid);
			
			
		}
		else
		{
			Msg(playerid, "Funkciók: start, finish, next, back, save", false);
			Msg(playerid, "Info: Start > start pozíció lerakása | Finish > cél pozícíó megadása | Nev [betöltnév] [név] > A race neve", false);
			Msg(playerid, "Info: Next > Lerakja a következõ CP-t | Back > Egy CPvel visszamegy | Save [név] > Mentés", false);
		}

		return 0;
	}

	if(realchat)
	{
	    if(gPlayerLogged[playerid] == 0)
	    {
	        return 0;
      	}
		GetPlayerName(playerid, sendername, sizeof(sendername));

		if(!gBooc[playerid])
		{
			if(SzajBekotve[playerid] == 1)
				return !Msg(playerid, "A szád bevan kötve, így nem tudsz beszélni.");
				
			if(strfind(text, ":D", true) != -1 || strfind(text, "xD", true) != -1)
			{
				ApplyAnimation(playerid, "RAPPING", "Laugh_01", 4.0, 0, 0, 0, 0, 0);

				Cselekves(playerid, "nevet.");
				return 0;
			}

			if(strfind(text, ":)", true) != -1)
				return !Cselekves(playerid, "mosolyog.");

			if(strfind(text, ":(", true) != -1)
				return !Cselekves(playerid, "szomorú.");

			if(strfind(text, ":P", true) != -1)
				return !Cselekves(playerid, "nyelvet ölt.");

			if(strfind(text, ";)", true) != -1)
				return !Cselekves(playerid, "kacsint.");

			if(strfind(text, ":@", true) != -1)
				return !Cselekves(playerid, "ideges.");

			if(strfind(text, ":O", true) != -1)
				return !Cselekves(playerid, "csodálkozik.");

			if(strfind(text, ":S", true) != -1)
				return !Cselekves(playerid, "rosszul van.");

			if(strfind(text, ":$", true) != -1)
				return !Cselekves(playerid, "elpirul.");

			if(strfind(text, ":/", true) != -1)
				return !Cselekves(playerid, "elkeseredett.");
		}



		if(!gBooc[playerid])
		{
			strrep(sendername, '_', ' '); // IC Üzenetben nem jelenik meg alsóvonal

			foreach(Jatekosok, p)
			{
				if(Poloska[p] && Poloskazott[playerid] && Poloskazta[p] == playerid)
					SendFormatMessage(p, COLOR_DORANGE, "<< Poloska: %s: %s >>", sendername, text);
			}

			new kocsiszoveg, kocsi;
			kocsi = GetPlayerVehicleID(playerid);
			if(IsPlayerInAnyVehicle(playerid) && !IsABicikli(kocsi) && !Bikes(kocsi) && !IsAMotor(kocsi))
			{
				if(!AblakLent[kocsi]) kocsiszoveg = 1;
				else kocsiszoveg = 2;
			}
			if(Szajkendo[playerid] || Maszk[playerid])
				kocsiszoveg = 3;

			if(!PlayerInfo[playerid][pANyelv])
			{
				if(PlayerInfo[playerid][pHamisNev] == 0)
				{
					switch(kocsiszoveg)
					{
						case 1: format(string, 128, "[Jármûben] %s mondja: %s", sendername, text);
						case 2: format(string, 128, "[Jármûbõl] %s mondja: %s", sendername, text);
						case 3: format(string, 128, "[Kendõ/Maszk] %s mondja: %s", sendername, text);
						default: format(string, 128, "%s mondja: %s", sendername, text);
					}

					ChatLog(string);
				}
				else
				{
					format(string, sizeof(string), "[%s]%s mondja: %s", sendername, PlayerInfo[playerid][pHamisNev], text);
					ChatLog(string);

					switch(kocsiszoveg)
					{
						case 1: format(string, 128, "[Jármûben] %s mondja: %s", ICPlayerNameString(PlayerInfo[playerid][pHamisNev]), text);
						case 2: format(string, 128, "[Jármûbõl] %s mondja: %s", ICPlayerNameString(PlayerInfo[playerid][pHamisNev]), text);
						case 3: format(string, 128, "[Kendõ/Maszk] %s mondja: %s", ICPlayerNameString(PlayerInfo[playerid][pHamisNev]), text);
						default: format(string, 128, "%s mondja: %s", ICPlayerNameString(PlayerInfo[playerid][pHamisNev]), text);
					}
				}
				ProxDetector(20.0, playerid, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5, (kocsiszoveg == 1) ? true : false);
				SetPlayerChatBubble(playerid, text, COLOR_WHITE, 5, 5000);
			}
			else
			{
				if(PlayerInfo[playerid][pHamisNev] == 0)
				{
					switch(kocsiszoveg)
					{
						case 1: format(string, 128, "[Jármûben] %s mondja%%s: %%s", sendername);
						case 2: format(string, 128, "[Jármûbõl] %s mondja%%s: %%s", sendername);
						case 3: format(string, 128, "[Kendõ/Maszk] %s mondja%%s: %%s", sendername);
						default: format(string, 128, "%s mondja%%s: %%s", sendername);
					}

					ChatLog(string);
				}
				else
				{
					format(string, sizeof(string), "[%s]%s mondja: %s", sendername, PlayerInfo[playerid][pHamisNev], text);
					ChatLog(string);

					switch(kocsiszoveg)
					{
						case 1: format(string, 128, "[Jármûben] %s mondja%%s: %%s", ICPlayerNameString(PlayerInfo[playerid][pHamisNev]));
						case 2: format(string, 128, "[Jármûbõl] %s mondja%%s: %%s", ICPlayerNameString(PlayerInfo[playerid][pHamisNev]));
						case 3: format(string, 128, "[Kendõ/Maszk] %s mondja%%s: %%s", ICPlayerNameString(PlayerInfo[playerid][pHamisNev]));
						default: format(string, 128, "%s mondja%%s: %%s", ICPlayerNameString(PlayerInfo[playerid][pHamisNev]));
					}
				}
				ProxDetector(20.0, playerid, string, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5, (kocsiszoveg == 1) ? true : false, text);
			}
		}
		else
		{
			if(HirdetesSzidasEllenorzes(playerid, text, "IC(OOC)", ELLENORZES_MINDKETTO)) return 0;
			if(EmlegetesEllenorzes(playerid, text, "IC(OOC)", ELLENORZES_SZEMELY)) return 0;

			if(FloodCheck(playerid) && !Admin(playerid, 4)) return 0;
			if(PlayerInfo[playerid][pHamisNev] == 0)
			{
				format(string, sizeof(string), "%s mondja OOC: (( %s ))", sendername, text);
				ChatLog(string);
			}
			else
			{
				format(string, sizeof(string), "[%s]%s mondja OOC: (( %s ))", sendername, PlayerInfo[playerid][pHamisNev], text);
				ChatLog(string);
				format(string, sizeof(string), "%s mondja OOC: (( %s ))", PlayerInfo[playerid][pHamisNev], text);
			}
			if(!gOColor[playerid]) ProxDetector(20.0, playerid, string,COLOR_FADE1,COLOR_FADE2,COLOR_FADE3,COLOR_FADE4,COLOR_FADE5);
			else ProxDetector(20.0, playerid, string,COLOR_RED,COLOR_RED,COLOR_RED,COLOR_RED,COLOR_RED);
			//SetPlayerChatBubble(playerid, text, COLOR_WHITE, 5, 5000);
		}
		return 0;
	}
	return 1;
} //optveg