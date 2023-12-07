#if defined __game_old_fbi_pda
	#endinput
#endif
#define __game_old_fbi_pda

stock ShowPDA(playerid)
{
	SendClientMessage(playerid, Pink, "| ============== PDA ==============");
	SendClientMessage(playerid, Pink2,"| Clearplayer          Clearvehicle");
	SendClientMessage(playerid, Pink, "| Aktiv�l�s             Deaktiv�l�s");
	SendClientMessage(playerid, Pink2,"| Banksz�mla              Adatn�z�s");
	SendClientMessage(playerid, Pink, "| Lehallgat�s            Lenyomoz�s");
	if(Munkarang(playerid, 2))SendClientMessage(playerid, Pink2,"| Telefonlehallgat�s  	   Betilt");
		else SendClientMessage(playerid, Pink2,"| Telefonlehallgat�s        		  ");
	if(Munkarang(playerid, 1))SendClientMessage(playerid,Pink, "| �ln�v                  Z�rol�sok");
		else SendClientMessage(playerid, Pink,"|             Z�rol�sok 			 ");
	if(Munkarang(playerid, 3))SendClientMessage(playerid,Pink2,"| Be�p�l�s         Poloska [be/ki]");
	if(Munkarang(playerid, 6))SendClientMessage(playerid,Pink, "|        Rend�rfelf�ggeszt�s       ");
	if(Munkarang(playerid, 3))SendClientMessage(playerid,Pink2,"|                            Logout");
		else SendClientMessage(playerid, Pink,"|                            Logout");
	SendClientMessage(playerid, Pink, "| ============== PDA ==============");
/*
	P | ============== PDA ==============
	P2| Clearplayer     -    Clearvehicle
	P | Aktiv�l�s       -     Deaktiv�l�s
	P2| Banksz�mla      -       Adatn�z�s
	P | Lehallgat�s     -      Lenyomoz�s
	P2| Telefonlehallgat�s  	           
   XP | �ln�v           -       Z�rol�sok
   XP2| Be�p�l�s        - Poloska [be/ki]
   XP |        Rend�rfelf�ggeszt�s       
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
	if(egyezik(tmp, "�ln�v") || egyezik(tmp, "alnev"))
	{
		if(!Munkarang(playerid, 1) && !FBIAlnev) return !Msg(playerid, "Access Denied. 1-es rang sz�ks�ges.");
	
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
		
		if(EmlegetesEllenorzes(playerid, result, "�ln�v", ELLENORZES_SZEMELY))
			
		if(!strlen(result) && PlayerInfo[playerid][pHamisNev] == 0)
		{
			Msg(playerid,"Haszn�lat: �lnev [�jn�v]");
			return 0;
		}
		if(!strlen(result) && PlayerInfo[playerid][pHamisNev] != 0)
		{
			SendClientMessage(playerid, COLOR_GRAD1, "�jra a r�gi neved van!");
			PlayerInfo[playerid][pHamisNev] = 0;
			return 0;
		}

		if(strlen(result) > MAX_PLAYER_NAME)
		{
			SendFormatMessage(playerid, COLOR_GRAD1, "Maximum %d karakter!", MAX_PLAYER_NAME);
			return 0;
		}
		PlayerInfo[playerid][pHamisNev] = result;
		format(string, sizeof(string), "Az �j �lneved mostant�l %s!", result);
		SendClientMessage(playerid, COLOR_LIGHTBLUE, string);
		return 0;
	}
	else if(egyezik(tmp, "banksz�mla") || egyezik(tmp, "bankszamla"))
	{
		tmp = strtok(text, idx);
		if(!strlen(tmp)) return !Msg(playerid, "banksz�mla [sz�mlasz�m/n�v]");
		//new uzenet[100];
		new bsz = strval(tmp);
		new player;
		if(BankSzamla(bsz) != NINCS) 
			player = BankSzamla(bsz);
		else
			player=ReturnUser(tmp);
		
		if(player == INVALID_PLAYER_ID)
			return Msg(playerid, "Nincs ilyen banksz�mlasz�m/n�v");
			
		if(PlayerInfo[player][pZarolva] == 1)
		{
			Msg(playerid, "Feloldottad a z�rol�st a sz�ml�r�l.");
			//Format(uzenet, "PDA �zenet: %s feloldotta a z�rol�st egy banksz�ml�r�l(Sz�mlasz�m: %d)", PlayerName(playerid), bsz);
			if(Munkarang(playerid, 1))SendRadioMessageFormat(FRAKCIO_FBI, Pink, "PDA �zenet: %s feloldotta a z�rol�st egy banksz�ml�r�l. Sz�mlasz�m: %d (ID: %d)", ICPlayerName(playerid),PlayerInfo[player][pBankSzamlaSzam], bsz);
			PlayerInfo[player][pZarolva] = 0;
			Msg(player, "Az FBI feloldotta a z�rol�st a sz�ml�dr�l.");
			return 0;
		}
		if(PlayerInfo[player][pZarolva] == 0)
		{
			Msg(playerid, "Lez�roltad a sz�ml�t.");
			//Format(uzenet, "PDA �zenet: %s lez�rt egy sz�ml�t(Sz�mlasz�m: %d)", PlayerName(playerid), bsz);
			if(Munkarang(playerid, 1))SendRadioMessageFormat(FRAKCIO_FBI, Pink, "PDA �zenet: %s lez�rt egy sz�ml�t. Sz�mlasz�m: %d (ID: %d)", ICPlayerName(playerid),PlayerInfo[player][pBankSzamlaSzam], bsz);
			PlayerInfo[player][pZarolva] = 1;
			Msg(player, "Az FBI lez�rolta a sz�ml�d.");
			return 0;
		}
	}
	else if(egyezik(tmp, "z�rol�sok") || egyezik(tmp, "zarolasok"))
	{
		SendClientMessage(playerid, COLOR_GREEN, "==[ Z�rolt Sz�ml�k List�ja ]==");
		foreach(Jatekosok, i)
		{
			if(PlayerInfo[i][pZarolva] == 1)
			{
				SendFormatMessage(playerid,COLOR_NAR,"N�v: %s - Sz�mlasz�m: %d", ICPlayerName(i), PlayerInfo[i][pBankSzamlaSzam]);
			}
		}
		return 0;
	}
	else if(egyezik(tmp, "betilt") || egyezik(tmp, "besz�ntet") || egyezik(tmp, "beszuntet"))
	{
		if(!strlen(tmp)) return !Msg(playerid, "betilt [ad�s/hat�r]");
		if(egyezik(tmp, "ad�s") || egyezik(tmp, "adas"))
		{
			return 0;
		}
		else if(egyezik(tmp, "hatar") || egyezik(tmp, "hat�r"))
		{
			return 0;
		}
		return 0;
	}
	else if(egyezik(tmp, "be�p�l�s") || egyezik(tmp, "beepules"))
	{
		tmp = strtok(text, idx);
		if(!Munkarang(playerid, 3) && !FBIBeepules) return !Msg(playerid, "Access Denied. 3-mas rang sz�ks�ges.");
		if(!strlen(tmp)) return !Msg(playerid, "be�p�l�s [ruha]");
		new ruha = strval(tmp);
		new kocsi = GetClosestVehicle(playerid);
		if(GetPlayerDistanceFromVehicle(playerid, kocsi) > 3.0) return !Msg(playerid, "Csak Szolg�lati J�rm� mellet.");
		if(!IsValidSkin(ruha)) return !Msg(playerid, "Nincs ilyen ruha!");
		SetPlayerSkin(playerid, ruha);
		SendClientMessage(playerid, Pink, "Be�p�l�s Sikeres.");
		//new uzi[128];
		//Format(uzi, "PDA �zenet: %s felvett egy �lruh�t.", PlayerName(playerid));
		SendRadioMessageFormat(FRAKCIO_FBI, Pink, "PDA �zenet: %s felvett egy �lruh�t.", ICPlayerName(playerid));
		return 0;
	}
	else if(egyezik(tmp, "deaktiv�l�s") || egyezik(tmp, "deaktivalas"))
	{
		if(Fbibelepes != 1 && Fbibelepes != 3) return !Msg(playerid, "Nem volt Behatol�s / A rendszer nincs Aktiv�lva.");
		Fbibelepes = 0;
		MoveDynamicObject(Fbilezaro1, 1786.58167, -1301.24500, 9.00000, 4);
		MoveDynamicObject(Fbilezaro2, 1790.85022, -1295.70972, 5.00000, 4);
		MoveDynamicObject(Fbilezaro3, 1799.87952, -1295.73022, 5.33860, 4);
		if(Fbibelepes == 1)
		{
			//format(string, sizeof(string), "PDA �zenet: System Deactivated!");
			SendMessage(SEND_MESSAGE_RADIO, "PDA �zenet: System Deactivated!", Pink, FRAKCIO_FBI);
		}
		Msg(playerid, "System Deactivated.");
		return 0;
	}
	else if(egyezik(tmp, "aktiv�l�s") || egyezik(tmp, "aktivalas"))
	{
		if(Fbibelepes == 3) return !Msg(playerid, "A rendszer aktiv�lva van.");
		MoveDynamicObject(Fbilezaro1, 1786.58167, -1301.24500, 12.78430, 4);
		MoveDynamicObject(Fbilezaro2, 1790.85022, -1295.70972, 12.33860, 4);
		MoveDynamicObject(Fbilezaro3, 1799.87952, -1295.73022, 12.33860, 4);
		Fbibelepes = 3;
		Msg(playerid, "System Activated");
		return 0;
	}
	else if(egyezik(tmp, "rend�rfelf�ggeszt�s") || egyezik(tmp, "rendorfelfuggesztes"))
	{
		tmp = strtok(text, idx);
		if(!Munkarang(playerid, 6)) return !Msg(playerid, "Access Denied. 6os rang sz�ks�ges.");
		if(!strlen(tmp)) return !Msg(playerid, "Rend�rfelf�ggeszt�s [N�v/ID]");
		new zseka = ReturnUser(tmp);
		if(zseka == INVALID_PLAYER_ID) return !Msg(playerid, "Hib�s n�v!");
		if(!IsACop(zseka)) return !Msg(playerid, "A J�t�kos nem Rend�r!");
		SendClientMessage(zseka, COLOR_LIGHTBLUE, "Az FBI felf�ggesztett! Ism�t civil vagy.");
		PlayerInfo[zseka][pLeader] = 0;
		PlayerInfo[zseka][pMember] = 0;
		PlayerInfo[zseka][pRank] = 0;
		PlayerInfo[zseka][pChar] = 0;
		PlayerInfo[zseka][pSwattag] = 0;
		PlayerInfo[zseka][pSwatRang] = 0;

		strcpy(PlayerInfo[zseka][pFrakcioTiltOk], "Felf�ggeszt�s hat�s�g �ltal", 64);
		PlayerInfo[zseka][pFrakcioTiltIdo]=25;

		new rand = random(sizeof(CIV));
		SetSpawnInfo(zseka, SPAWNID, PlayerInfo[zseka][pModel],0.0,0.0,0.0,0,0,0,0,0,0,0);
		PlayerInfo[zseka][pModel] = CIV[rand];
			
		SpawnPlayer(zseka);
		SendFormatMessage(playerid, Pink, "%s felf�ggesztve!", ICPlayerName(zseka));
		//new uzi[128];
		//Format(uzi, "PDA �zenet: %s felf�ggesztette %s.", PlayerName(playerid), PlayerName(zseka));
		SendRadioMessageFormat(FRAKCIO_FBI, Pink, "PDA �zenet: %s felf�ggesztette %s.", ICPlayerName(playerid), ICPlayerName(zseka));
		return 0;
	}
	/*else if(egyezik(tmp, "jelsz�") || egyezik(tmp, "jelszo"))
	{
		SendFormatMessage(playerid, Pink, "A jelsz� most %s.", FrakcioInfo[FRAKCIO_FBI][fJelszo]);
		return 0;
	}*/
	else if(egyezik(tmp, "logout"))
	{
		SendFormatMessage(playerid, Pink, "Server Disconnected. J� munk�t %s �gyn�k.", ICPlayerName(playerid));
		FbiBelepve[playerid] = 0;
		return 0;
	}
	else if(egyezik(tmp, "lenyomoz�s") || egyezik(tmp, "lenyomozas"))
	{
		tmp = strtok(text, idx);
		if(!strlen(tmp)) return !Msg(playerid, "Lenyomoz�s [N�v/ID/Kikapcsol]");
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
		if(player == INVALID_PLAYER_ID) return !Msg(playerid, "Hib�s n�v!");
		
		if(PlayerInfo[player][pPnumber] == 0 && !PlayerInfo[player][pLaptop] || PlayerInfo[player][pLaptop] && !PlayerInfo[player][pLaptopBe] || PlayerInfo[player][pPnumber] != 0 && PhoneOnline[player])
			return !Msg(playerid, "Ezt a j�t�kost nem lehet lenyomozni!");
		
		if(Tevezik[player] != NINCS) return 1;
		new vw = GetPlayerVirtualWorld(player);
		new inti = GetPlayerInterior(player);
		if(vw != 0 || inti != 0)
		{
			if(Hazbanvan[player] == 0)
			{
				if(inti == 18)
				{
					SendClientMessage(playerid, Pink, "C�lszem�ly az egyik 24/7 be van!");
					Fbios[player] = playerid;
					return 0;
				}
				else if(inti == 3)
				{
					if(PlayerToPoint(30, player, 296.919982,-108.071998,1001.515625))
					{
						SendClientMessage(playerid, Pink, "C�lszem�ly LS GS be van!");
						Fbios[player] = playerid;
						return 0;
					}
					else if(PlayerToPoint(100, player, 384.808624,173.804992,1008.382812))
					{
						SendClientMessage(playerid, Pink, "C�lszem�ly V�rosh�z�n van!");
						Fbios[player] = playerid;
						return 0;
					}
					else if(PlayerToPoint(100, player, 369.8337,162.5357,1014.1893))
					{
						SendClientMessage(playerid, Pink, "C�lszem�ly V�rosh�z�n van!");
						Fbios[player] = playerid;
						return 0;
					}
					else if(PlayerToPoint(100, player, 368.2852,162.4965,1019.9844))
					{
						SendClientMessage(playerid, Pink, "C�lszem�ly V�rosh�z�n van!");
						Fbios[player] = playerid;
						return 0;
					}
					else if(PlayerToPoint(100, player, 370.1142,163.1876,1025.7891))
					{
						SendClientMessage(playerid, Pink, "C�lszem�ly V�rosh�z�n van!");
						Fbios[player] = playerid;
						return 0;
					}
					else if(PlayerToPoint(50, player, 833.269775,10.588416,1004.179687))
					{
						SendClientMessage(playerid, Pink, "C�lszem�ly a Lottoz�ban van!");
						Fbios[player] = playerid;
						return 0;
					}
					else if(PlayerToPoint(50, player, 207.054992,-138.804992,1003.507812))
					{
						SendClientMessage(playerid, Pink, "C�lszem�ly a Bincoban van!");
						Fbios[player] = playerid;
						return 0;
					}
					else if(PlayerToPoint(50, player, 288.745971,169.350997,1007.171875))
					{
						SendClientMessage(playerid, Pink, "C�lszem�ly az FBI HQ-n van!");
						Fbios[player] = playerid;
						return 0;
					}
					else if(PlayerToPoint(50, player, 1494.325195,1304.942871,1093.289062))
					{
						SendClientMessage(playerid, Pink, "C�lszem�ly az Oktat� HQ-n van!");
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
					SendClientMessage(playerid, Pink, "C�lszem�ly SF GS be van!");
					Fbios[player] = playerid;
					return 0;
				}
				else if(inti == 5)
				{
					if(PlayerToPoint(50, player, 72.111999,-3.898649,1000.728820))
					{
						SendClientMessage(playerid, Pink, "C�lszem�ly LS Edz�terembe van!");
						Fbios[player] = playerid;
						return 0;
					}
					else if(PlayerToPoint(50, player, 373.825653,-117.270904,1001.499511))
					{
						SendClientMessage(playerid, Pink, "C�lszem�ly az egyik pizz�z�ban van!");
						Fbios[player] = playerid;
						return 0;
					}
				}
				else if(inti == 6)
				{
					if(PlayerToPoint(50, player, 774.213989,-48.924297,1000.585937))
					{
						SendClientMessage(playerid, Pink, "C�lszem�ly Cobra Edz�terembe van!");
						Fbios[player] = playerid;
						return 0;
					}
					else if(PlayerToPoint(100, player, 246.783996,63.900199,1003.640625))
					{
						SendClientMessage(playerid, Pink, "C�lszem�ly LSPD-n van!");
						Fbios[player] = playerid;
						return 0;
					}
				}
				else if(inti == 9)
				{
					SendClientMessage(playerid, Pink, "C�lszem�ly az egyik csirk�sbe van!");
					Fbios[player] = playerid;
					return 0;
				}
				else if(inti == 10)
				{
					if(PlayerToPoint(50, player, 375.962463,-65.816848,1001.507812))
					{
						SendClientMessage(playerid, Pink, "C�lszem�ly az egyik Burger Shotba van!");
						Fbios[player] = playerid;
						return 0;
					}
					else if(PlayerToPoint(200, player, -975.975708,1060.983032,1345.671875))
					{
						SendClientMessage(playerid, Pink, "C�lszem�ly az RC Gyakorlop�ly�n van!");
						Fbios[player] = playerid;
						return 0;
					}
					else if(PlayerToPoint(200, player, 246.375991,109.245994,1003.218750))
					{
						if(vw == 20)
						{
							SendClientMessage(playerid, Pink, "C�lszem�ly NAV HQ-n van!");
							Fbios[player] = playerid;
							return 0;
						}
						else
						{
							SendClientMessage(playerid, Pink, "C�lszem�ly SAPD HQ-n van!");
							Fbios[player] = playerid;
							return 0;
						}
					}
				}
				else if(inti == 1)
				{
					SendClientMessage(playerid, Pink, "C�lszem�ly a H�sfeldolgoz�ban van!((Valameik Maffia Inti))");
					Fbios[player] = playerid;
					return 0;
				}
				else if(inti == 17)
				{
					SendClientMessage(playerid, Pink, "C�lszem�ly Alhambr�ba van!");
					Fbios[player] = playerid;
					return 0;
				}
				else if(inti == 2)
				{
					Msg(playerid, "Gy�rban van, de csak OOC tudod!");
					Fbios[player] = playerid;
					return 0;
				}
				else if(inti == 11)
				{
					SendClientMessage(playerid, Pink, "C�lszem�ly Groove Kocsm�ban van!");
					Fbios[player] = playerid;
					return 0;
				}
			}
			else
			{
				SendFormatMessage(playerid, Pink, "C�lszem�ly Class utca %d sz�m alatt tartozkodik!", vw);
				Fbios[player] = playerid;
				return 0;
			}
		}
		new Float:X,Float:Y,Float:Z;
		GetPlayerPos(player, X,Y,Z);
		SetPlayerMarkerForPlayer(playerid, player, Pink);
		SendClientMessage(playerid, Pink, "C�lszem�ly Lenyomozva!");
		SendClientMessage(playerid, Pink, "* Kikapcsol�shoz: lenyomoz�s kikapcsol");
		Fbicelpont[playerid] = player;
		Fbios[player] = playerid;
		return 0;
	}
	else if(egyezik(tmp, "lehallgat�s"))
	{
		tmp = strtok(text, idx);
		new Allomas = strval(tmp);
		if(!strlen(tmp)) return !Msg(playerid, "lehallgat�s [r�di��llom�s]");
		if(egyezik(tmp, "kikapcsol") || egyezik(tmp, "off"))
		{
			Msg(playerid, "Kikapcsolva");
			RadioHallgatas[playerid] = NINCS;
			return 0;
		}
		if(Allomas < 1 || Allomas > MAX_FRAKCIO)
		{
			SendFormatMessage(playerid, Pink, "* R�di� �llom�sok: 1-%d", MAX_FRAKCIO);
			return 0;
		}
		RadioHallgatas[playerid] = Allomas;
		SendFormatMessage(playerid, Pink, "* Csatlakoz�s sikeres. �llom�s: %d", Allomas);
		SendClientMessage(playerid, COLOR_LIGHTGREEN, "=============[R�di� Adatok]=============");
		new szneve[32];
		new szam = RadioHallgatas[playerid] - 1;
		szneve = Szervezetneve[szam][0];
		SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* Szervezet Neve: %s", szneve);
		new menyien = 0;
		for(new oj = 0; oj < MAX_PLAYERS; oj++)
		{
			if(PlayerInfo[oj][pMember] == RadioHallgatas[playerid] || PlayerInfo[oj][pLeader] == RadioHallgatas[playerid]) menyien++;
		}
		SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* A r�di�t %d-an/en hallgatj�k.", menyien);
		SendClientMessage(playerid, Pink, "* Kikapcsol�shoz: lehallgat�s kikapcsol");
		return 0;
	}
	else if(egyezik(tmp, "adatn�z�s") || egyezik(tmp, "adatnezes"))
	{
		tmp = strtok(text, idx);
		new player = ReturnUser(tmp);
		if(!strlen(tmp)) return !Msg(playerid, "Adatn�z�s [N�v/ID]");
		if(player == INVALID_PLAYER_ID) return !Msg(playerid, "Hib�s n�v!");
		if(PlayerInfo[player][pArrested] < 1) return !Msg(playerid, "R�la nincs akta, mivel m�g nem volt lecsukva.");
		Akta(playerid, player);
		return 0;
	}
	else if(egyezik(tmp, "clearplayer"))
	{
		tmp = strtok(text, idx);
		if(!strlen(tmp)) return !Msg(playerid, "Clearplayer [N�v/ID]");
		new player = ReturnUser(tmp);
		if(player == INVALID_PLAYER_ID) return !Msg(playerid, "Hib�s n�v!");
		if(player == playerid) return !Msg(playerid, "Magadr�l nem!");
		SendFormatMessage(playerid, Pink, "ClassRPG: Sikeresen t�r�lted %s k�r�z�s�t!", ICPlayerName(player));
		ClearPlayerCrime(player);
		Msg(player, "Az FBI t�r�lte r�lad a k�r�z�st.");
		return 0;
	}
	else if(egyezik(tmp, "clearvehicle"))
	{
		tmp = strtok(text, idx);
		if(!strlen(tmp)) return !Msg(playerid, "Clearvehicle [N�v/ID]");
		new car = strval(tmp);
		if(car == INVALID_VEHICLE_ID) return !Msg(playerid, "Hib�s n�v!");
		SendFormatMessage(playerid, Pink, "ClassRPG: Sikeresen t�r�lted a CLS-%d rendsz�m� j�rm� k�r�z�s�t!", car);
		ClearVehicleCrime(car);
		return 0;
	}
	else if(egyezik(tmp, "telefonlehallgat�s"))
	{
		tmp = strtok(text, idx);
		if(!strlen(tmp)) return !Msg(playerid, "Telefonlehallgat�s [N�v/ID]");
		new player = ReturnUser(tmp);
		if(egyezik(tmp, "kikapcsol") || egyezik(tmp, "off"))
		{
			Msg(playerid, "Kikapcsolva");
			Lehallgat[playerid] = NINCS;
			return 0;
		}
		if(player == INVALID_PLAYER_ID) return !Msg(playerid, "Hib�s n�v!");
		if(player == playerid) return !Msg(playerid, "-.-'");
		Lehallgat[playerid] = player;
		SendClientMessage(playerid, Pink, "Mostant�l ha telefon�l, hallani fogod!");
		return 0;
	}
	else if(egyezik(tmp, "bezaras") || egyezik(tmp, "bez�r�s"))
	{
		if(!Munkarang(playerid, 10)) return !Msg(playerid, "Access Denied. 10es rang sz�ks�ges.");
		if(Fbibelepes != 0) return !Msg(playerid, "Z�rva van vagy behatol�s t�rt�nt(haszn�ld a deaktiv�l�st).");
		Fbibelepes = 2;
		Msg(playerid, "Bez�rva.");
		return 0;
	}
	else if(egyezik(tmp, "nyitas") || egyezik(tmp, "nyit�s"))
	{
		if(!Munkarang(playerid, 10)) return !Msg(playerid, "Access Denied. 10es rang sz�ks�ges.");
		if(Fbibelepes != 2) return !Msg(playerid, "Nyitva van vagy Behatol�s t�rt�nt(haszn�ld a deaktiv�l�st).");
		Fbibelepes = 0;
		Msg(playerid, "Nyitva.");
		return 0;
	}
	else if(egyezik(tmp, "poloska"))
	{
		tmp = strtok(text, idx);
		new player = ReturnUser(tmp);
		if(!Munkarang(playerid, 3)) return !Msg(playerid, "Access Denied. 3as rang sz�ks�ges.");
		if(player == INVALID_PLAYER_ID || player == playerid) return !Msg(playerid, "Hib�s n�v!");
		if(GetDistanceBetweenPlayers(playerid, player) > 2) return !Msg(playerid, "Nagyon k�zelnek kell lenned a c�lponthoz!");
		if(!strlen(tmp)) return !Msg(playerid, "Poloska [N�v/ID]");
		if(!Poloskazott[player])
		{
			Poloskazott[player] = true;
			Poloskazta[playerid] = player;
			Msg(playerid, "Sikeresen r�raktad a polosk�t a c�lpontra!");
			Cselekves(playerid, "csin�lt valamit...", 1);
		}
		else
		{
			Poloskazott[player] = false;
			Poloskazta[playerid] = NINCS;
			Msg(playerid, "Sikeresen levetted a polosk�t a c�lpontr�l!");
			Cselekves(playerid, "csin�lt valamit...", 1);
		}
		return 0;
	}
	else if(egyezik(tmp, "poloskabe"))
	{
		if(!Munkarang(playerid, 3)) return !Msg(playerid, "Access Denied. 3as rang sz�ks�ges.");
		if(Poloskazta[playerid] == NINCS) return !Msg(playerid, "Senkire sem rakt�l polosk�t!");
		Msg(playerid, "Poloska bekapcsolva!");
		Poloska[playerid] = true;
		return 0;
	}
	else if(egyezik(tmp, "poloskaki"))
	{
		if(!Munkarang(playerid, 3)) return !Msg(playerid, "Access Denied. 3as rang sz�ks�ges.");
		if(Poloskazta[playerid] == NINCS) return !Msg(playerid, "Senkire sem rakt�l polosk�t!");
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