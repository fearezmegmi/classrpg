#if defined __game_old_fbi_pda
	#endinput
#endif
#define __game_old_fbi_pda

stock ShowPDA(playerid)
{
	SendClientMessage(playerid, Pink, "| ============== PDA ==============");
	SendClientMessage(playerid, Pink2,"| Clearplayer          Clearvehicle");
	SendClientMessage(playerid, Pink, "| Aktiválás             Deaktiválás");
	SendClientMessage(playerid, Pink2,"| Bankszámla              Adatnézés");
	SendClientMessage(playerid, Pink, "| Lehallgatás            Lenyomozás");
	if(Munkarang(playerid, 2))SendClientMessage(playerid, Pink2,"| Telefonlehallgatás  	   Betilt");
		else SendClientMessage(playerid, Pink2,"| Telefonlehallgatás        		  ");
	if(Munkarang(playerid, 1))SendClientMessage(playerid,Pink, "| Álnév                  Zárolások");
		else SendClientMessage(playerid, Pink,"|             Zárolások 			 ");
	if(Munkarang(playerid, 3))SendClientMessage(playerid,Pink2,"| Beépülés         Poloska [be/ki]");
	if(Munkarang(playerid, 6))SendClientMessage(playerid,Pink, "|        Rendõrfelfüggesztés       ");
	if(Munkarang(playerid, 3))SendClientMessage(playerid,Pink2,"|                            Logout");
		else SendClientMessage(playerid, Pink,"|                            Logout");
	SendClientMessage(playerid, Pink, "| ============== PDA ==============");
/*
	P | ============== PDA ==============
	P2| Clearplayer     -    Clearvehicle
	P | Aktiválás       -     Deaktiválás
	P2| Bankszámla      -       Adatnézés
	P | Lehallgatás     -      Lenyomozás
	P2| Telefonlehallgatás  	           
   XP | Álnév           -       Zárolások
   XP2| Beépülés        - Poloska [be/ki]
   XP |        Rendõrfelfüggesztés       
	P2|                            Logout
	P | ============== PDA ==============
*/
}

fpublic Fbikapcsolodas(playerid)
{
	ShowPDA(playerid);
	FbiBelepve[playerid] = 1;
	return 0;
}

stock FBI_PDA(playerid, text[])
{
	new tmp[256];
	new string[256];

	new idx;
	tmp = strtok(text, idx);
	if(egyezik(tmp, "álnév") || egyezik(tmp, "alnev"))
	{
		if(!Munkarang(playerid, 1) && !FBIAlnev) return !Msg(playerid, "Access Denied. 1-es rang szükséges.");
	
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
		
		if(EmlegetesEllenorzes(playerid, result, "álnév", ELLENORZES_SZEMELY))
			
		if(!strlen(result) && PlayerInfo[playerid][pHamisNev] == 0)
		{
			Msg(playerid,"Használat: álnev [újnév]");
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
	else if(egyezik(tmp, "bankszámla") || egyezik(tmp, "bankszamla"))
	{
		tmp = strtok(text, idx);
		if(!strlen(tmp)) return !Msg(playerid, "bankszámla [számlaszám/név]");
		//new uzenet[100];
		new bsz = strval(tmp);
		new player;
		if(BankSzamla(bsz) != NINCS) 
			player = BankSzamla(bsz);
		else
			player=ReturnUser(tmp);
		
		if(player == INVALID_PLAYER_ID)
			return Msg(playerid, "Nincs ilyen bankszámlaszám/név");
			
		if(PlayerInfo[player][pZarolva] == 1)
		{
			Msg(playerid, "Feloldottad a zárolást a számláról.");
			//Format(uzenet, "PDA Üzenet: %s feloldotta a zárolást egy bankszámláról(Számlaszám: %d)", PlayerName(playerid), bsz);
			if(Munkarang(playerid, 1))SendRadioMessageFormat(FRAKCIO_FBI, Pink, "PDA Üzenet: %s feloldotta a zárolást egy bankszámláról. Számlaszám: %d (ID: %d)", ICPlayerName(playerid),PlayerInfo[player][pBankSzamlaSzam], bsz);
			PlayerInfo[player][pZarolva] = 0;
			Msg(player, "Az FBI feloldotta a zárolást a számládról.");
			return 0;
		}
		if(PlayerInfo[player][pZarolva] == 0)
		{
			Msg(playerid, "Lezároltad a számlát.");
			//Format(uzenet, "PDA Üzenet: %s lezárt egy számlát(Számlaszám: %d)", PlayerName(playerid), bsz);
			if(Munkarang(playerid, 1))SendRadioMessageFormat(FRAKCIO_FBI, Pink, "PDA Üzenet: %s lezárt egy számlát. Számlaszám: %d (ID: %d)", ICPlayerName(playerid),PlayerInfo[player][pBankSzamlaSzam], bsz);
			PlayerInfo[player][pZarolva] = 1;
			Msg(player, "Az FBI lezárolta a számlád.");
			return 0;
		}
	}
	else if(egyezik(tmp, "zárolások") || egyezik(tmp, "zarolasok"))
	{
		SendClientMessage(playerid, COLOR_GREEN, "==[ Zárolt Számlák Listája ]==");
		foreach(Jatekosok, i)
		{
			if(PlayerInfo[i][pZarolva] == 1)
			{
				SendFormatMessage(playerid,COLOR_NAR,"Név: %s - Számlaszám: %d", ICPlayerName(i), PlayerInfo[i][pBankSzamlaSzam]);
			}
		}
		return 0;
	}
	else if(egyezik(tmp, "betilt") || egyezik(tmp, "beszüntet") || egyezik(tmp, "beszuntet"))
	{
		if(!strlen(tmp)) return !Msg(playerid, "betilt [adás/határ]");
		if(egyezik(tmp, "adás") || egyezik(tmp, "adas"))
		{
			return 0;
		}
		else if(egyezik(tmp, "hatar") || egyezik(tmp, "határ"))
		{
			return 0;
		}
		return 0;
	}
	else if(egyezik(tmp, "beépülés") || egyezik(tmp, "beepules"))
	{
		tmp = strtok(text, idx);
		if(!Munkarang(playerid, 3) && !FBIBeepules) return !Msg(playerid, "Access Denied. 3-mas rang szükséges.");
		if(!strlen(tmp)) return !Msg(playerid, "beépülés [ruha]");
		new ruha = strval(tmp);
		new kocsi = GetClosestVehicle(playerid);
		if(GetPlayerDistanceFromVehicle(playerid, kocsi) > 3.0) return !Msg(playerid, "Csak Szolgálati Jármû mellet.");
		if(!IsValidSkin(ruha)) return !Msg(playerid, "Nincs ilyen ruha!");
		SetPlayerSkin(playerid, ruha);
		SendClientMessage(playerid, Pink, "Beépülés Sikeres.");
		//new uzi[128];
		//Format(uzi, "PDA Üzenet: %s felvett egy álruhát.", PlayerName(playerid));
		SendRadioMessageFormat(FRAKCIO_FBI, Pink, "PDA Üzenet: %s felvett egy álruhát.", ICPlayerName(playerid));
		return 0;
	}
	else if(egyezik(tmp, "deaktiválás") || egyezik(tmp, "deaktivalas"))
	{
		if(Fbibelepes != 1 && Fbibelepes != 3) return !Msg(playerid, "Nem volt Behatolás / A rendszer nincs Aktiválva.");
		Fbibelepes = 0;
		MoveDynamicObject(Fbilezaro1, 1786.58167, -1301.24500, 9.00000, 4);
		MoveDynamicObject(Fbilezaro2, 1790.85022, -1295.70972, 5.00000, 4);
		MoveDynamicObject(Fbilezaro3, 1799.87952, -1295.73022, 5.33860, 4);
		if(Fbibelepes == 1)
		{
			//format(string, sizeof(string), "PDA Üzenet: System Deactivated!");
			SendMessage(SEND_MESSAGE_RADIO, "PDA Üzenet: System Deactivated!", Pink, FRAKCIO_FBI);
		}
		Msg(playerid, "System Deactivated.");
		return 0;
	}
	else if(egyezik(tmp, "aktiválás") || egyezik(tmp, "aktivalas"))
	{
		if(Fbibelepes == 3) return !Msg(playerid, "A rendszer aktiválva van.");
		MoveDynamicObject(Fbilezaro1, 1786.58167, -1301.24500, 12.78430, 4);
		MoveDynamicObject(Fbilezaro2, 1790.85022, -1295.70972, 12.33860, 4);
		MoveDynamicObject(Fbilezaro3, 1799.87952, -1295.73022, 12.33860, 4);
		Fbibelepes = 3;
		Msg(playerid, "System Activated");
		return 0;
	}
	else if(egyezik(tmp, "rendõrfelfüggesztés") || egyezik(tmp, "rendorfelfuggesztes"))
	{
		tmp = strtok(text, idx);
		if(!Munkarang(playerid, 6)) return !Msg(playerid, "Access Denied. 6os rang szükséges.");
		if(!strlen(tmp)) return !Msg(playerid, "Rendõrfelfüggesztés [Név/ID]");
		new zseka = ReturnUser(tmp);
		if(zseka == INVALID_PLAYER_ID) return !Msg(playerid, "Hibás név!");
		if(!IsACop(zseka)) return !Msg(playerid, "A Játékos nem Rendõr!");
		SendClientMessage(zseka, COLOR_LIGHTBLUE, "Az FBI felfüggesztett! Ismét civil vagy.");
		PlayerInfo[zseka][pLeader] = 0;
		PlayerInfo[zseka][pMember] = 0;
		PlayerInfo[zseka][pRank] = 0;
		PlayerInfo[zseka][pChar] = 0;
		PlayerInfo[zseka][pSwattag] = 0;
		PlayerInfo[zseka][pSwatRang] = 0;

		strcpy(PlayerInfo[zseka][pFrakcioTiltOk], "Felfüggesztés hatóság által", 64);
		PlayerInfo[zseka][pFrakcioTiltIdo]=25;

		new rand = random(sizeof(CIV));
		SetSpawnInfo(zseka, SPAWNID, PlayerInfo[zseka][pModel],0.0,0.0,0.0,0,0,0,0,0,0,0);
		PlayerInfo[zseka][pModel] = CIV[rand];
			
		SpawnPlayer(zseka);
		SendFormatMessage(playerid, Pink, "%s felfüggesztve!", ICPlayerName(zseka));
		//new uzi[128];
		//Format(uzi, "PDA Üzenet: %s felfüggesztette %s.", PlayerName(playerid), PlayerName(zseka));
		SendRadioMessageFormat(FRAKCIO_FBI, Pink, "PDA Üzenet: %s felfüggesztette %s.", ICPlayerName(playerid), ICPlayerName(zseka));
		return 0;
	}
	/*else if(egyezik(tmp, "jelszó") || egyezik(tmp, "jelszo"))
	{
		SendFormatMessage(playerid, Pink, "A jelszó most %s.", FrakcioInfo[FRAKCIO_FBI][fJelszo]);
		return 0;
	}*/
	else if(egyezik(tmp, "logout"))
	{
		SendFormatMessage(playerid, Pink, "Server Disconnected. Jó munkát %s Ügynök.", ICPlayerName(playerid));
		FbiBelepve[playerid] = 0;
		return 0;
	}
	else if(egyezik(tmp, "lenyomozás") || egyezik(tmp, "lenyomozas"))
	{
		tmp = strtok(text, idx);
		if(!strlen(tmp)) return !Msg(playerid, "Lenyomozás [Név/ID/Kikapcsol]");
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
		
		if(PlayerInfo[player][pPnumber] == 0 && !PlayerInfo[player][pLaptop] || PlayerInfo[player][pLaptop] && !PlayerInfo[player][pLaptopBe] || PlayerInfo[player][pPnumber] != 0 && PhoneOnline[player])
			return !Msg(playerid, "Ezt a játékost nem lehet lenyomozni!");
		
		if(Tevezik[player] != NINCS) return 1;
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
							SendClientMessage(playerid, Pink, "Célszemély NAV HQ-n van!");
							Fbios[player] = playerid;
							return 0;
						}
						else
						{
							SendClientMessage(playerid, Pink, "Célszemély SAPD HQ-n van!");
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
		Fbicelpont[playerid] = player;
		Fbios[player] = playerid;
		return 0;
	}
	else if(egyezik(tmp, "lehallgatás"))
	{
		tmp = strtok(text, idx);
		new Allomas = strval(tmp);
		if(!strlen(tmp)) return !Msg(playerid, "lehallgatás [rádióállomás]");
		if(egyezik(tmp, "kikapcsol") || egyezik(tmp, "off"))
		{
			Msg(playerid, "Kikapcsolva");
			RadioHallgatas[playerid] = NINCS;
			return 0;
		}
		if(Allomas < 1 || Allomas > MAX_FRAKCIO)
		{
			SendFormatMessage(playerid, Pink, "* Rádió állomások: 1-%d", MAX_FRAKCIO);
			return 0;
		}
		RadioHallgatas[playerid] = Allomas;
		SendFormatMessage(playerid, Pink, "* Csatlakozás sikeres. Állomás: %d", Allomas);
		SendClientMessage(playerid, COLOR_LIGHTGREEN, "=============[Rádió Adatok]=============");
		new szneve[32];
		new szam = RadioHallgatas[playerid] - 1;
		szneve = Szervezetneve[szam][0];
		SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Szervezet Neve: %s", szneve);
		new menyien = 0;
		for(new oj = 0; oj < MAX_PLAYERS; oj++)
		{
			if(PlayerInfo[oj][pMember] == RadioHallgatas[playerid] || PlayerInfo[oj][pLeader] == RadioHallgatas[playerid]) menyien++;
		}
		SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* A rádiót %d-an/en hallgatják.", menyien);
		SendClientMessage(playerid, Pink, "* Kikapcsoláshoz: lehallgatás kikapcsol");
		return 0;
	}
	else if(egyezik(tmp, "adatnézés") || egyezik(tmp, "adatnezes"))
	{
		tmp = strtok(text, idx);
		new player = ReturnUser(tmp);
		if(!strlen(tmp)) return !Msg(playerid, "Adatnézés [Név/ID]");
		if(player == INVALID_PLAYER_ID) return !Msg(playerid, "Hibás név!");
		if(PlayerInfo[player][pArrested] < 1) return !Msg(playerid, "Róla nincs akta, mivel még nem volt lecsukva.");
		Akta(playerid, player);
		return 0;
	}
	else if(egyezik(tmp, "clearplayer"))
	{
		tmp = strtok(text, idx);
		if(!strlen(tmp)) return !Msg(playerid, "Clearplayer [Név/ID]");
		new player = ReturnUser(tmp);
		if(player == INVALID_PLAYER_ID) return !Msg(playerid, "Hibás név!");
		if(player == playerid) return !Msg(playerid, "Magadról nem!");
		SendFormatMessage(playerid, Pink, "ClassRPG: Sikeresen törölted %s körözését!", ICPlayerName(player));
		ClearPlayerCrime(player);
		Msg(player, "Az FBI törölte rólad a körözést.");
		return 0;
	}
	else if(egyezik(tmp, "clearvehicle"))
	{
		tmp = strtok(text, idx);
		if(!strlen(tmp)) return !Msg(playerid, "Clearvehicle [Név/ID]");
		new car = strval(tmp);
		if(car == INVALID_VEHICLE_ID) return !Msg(playerid, "Hibás név!");
		SendFormatMessage(playerid, Pink, "ClassRPG: Sikeresen törölted a CLS-%d rendszámú jármû körözését!", car);
		ClearVehicleCrime(car);
		return 0;
	}
	else if(egyezik(tmp, "telefonlehallgatás"))
	{
		tmp = strtok(text, idx);
		if(!strlen(tmp)) return !Msg(playerid, "Telefonlehallgatás [Név/ID]");
		new player = ReturnUser(tmp);
		if(egyezik(tmp, "kikapcsol") || egyezik(tmp, "off"))
		{
			Msg(playerid, "Kikapcsolva");
			Lehallgat[playerid] = NINCS;
			return 0;
		}
		if(player == INVALID_PLAYER_ID) return !Msg(playerid, "Hibás név!");
		if(player == playerid) return !Msg(playerid, "-.-'");
		Lehallgat[playerid] = player;
		SendClientMessage(playerid, Pink, "Mostantól ha telefonál, hallani fogod!");
		return 0;
	}
	else if(egyezik(tmp, "bezaras") || egyezik(tmp, "bezárás"))
	{
		if(!Munkarang(playerid, 10)) return !Msg(playerid, "Access Denied. 10es rang szükséges.");
		if(Fbibelepes != 0) return !Msg(playerid, "Zárva van vagy behatolás történt(használd a deaktiválást).");
		Fbibelepes = 2;
		Msg(playerid, "Bezárva.");
		return 0;
	}
	else if(egyezik(tmp, "nyitas") || egyezik(tmp, "nyitás"))
	{
		if(!Munkarang(playerid, 10)) return !Msg(playerid, "Access Denied. 10es rang szükséges.");
		if(Fbibelepes != 2) return !Msg(playerid, "Nyitva van vagy Behatolás történt(használd a deaktiválást).");
		Fbibelepes = 0;
		Msg(playerid, "Nyitva.");
		return 0;
	}
	else if(egyezik(tmp, "poloska"))
	{
		tmp = strtok(text, idx);
		new player = ReturnUser(tmp);
		if(!Munkarang(playerid, 3)) return !Msg(playerid, "Access Denied. 3as rang szükséges.");
		if(player == INVALID_PLAYER_ID || player == playerid) return !Msg(playerid, "Hibás név!");
		if(GetDistanceBetweenPlayers(playerid, player) > 2) return !Msg(playerid, "Nagyon közelnek kell lenned a célponthoz!");
		if(!strlen(tmp)) return !Msg(playerid, "Poloska [Név/ID]");
		if(!Poloskazott[player])
		{
			Poloskazott[player] = true;
			Poloskazta[playerid] = player;
			Msg(playerid, "Sikeresen ráraktad a poloskát a célpontra!");
			Cselekves(playerid, "csinált valamit...", 1);
		}
		else
		{
			Poloskazott[player] = false;
			Poloskazta[playerid] = NINCS;
			Msg(playerid, "Sikeresen levetted a poloskát a célpontról!");
			Cselekves(playerid, "csinált valamit...", 1);
		}
		return 0;
	}
	else if(egyezik(tmp, "poloskabe"))
	{
		if(!Munkarang(playerid, 3)) return !Msg(playerid, "Access Denied. 3as rang szükséges.");
		if(Poloskazta[playerid] == NINCS) return !Msg(playerid, "Senkire sem raktál poloskát!");
		Msg(playerid, "Poloska bekapcsolva!");
		Poloska[playerid] = true;
		return 0;
	}
	else if(egyezik(tmp, "poloskaki"))
	{
		if(!Munkarang(playerid, 3)) return !Msg(playerid, "Access Denied. 3as rang szükséges.");
		if(Poloskazta[playerid] == NINCS) return !Msg(playerid, "Senkire sem raktál poloskát!");
		Msg(playerid, "Poloska kikapcsolva!");
		Poloska[playerid] = false;
		return 0;
	}
	else
	{
		ShowPDA(playerid);
		return 0;
	}
	return 0;
}