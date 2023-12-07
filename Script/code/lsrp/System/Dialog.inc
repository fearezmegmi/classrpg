public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	new string[1024];
	if(dialogid == DIALOG_KOCSIM_BELUL)
	{
		new veh = GetPlayerVehicleID(playerid);
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if(!Sofor(playerid)) return iMsg(playerid, "Csak sofõr!");
					if(IsABicikli(GetPlayerVehicleID(playerid))) return iMsg(playerid, "Ez egy bicikli, a biciklin nincs motor...");
					if(IsKocsi(GetPlayerVehicleID(playerid), "Gokart"))	return 1;
					new car = IsAVsKocsi(GetPlayerVehicleID(playerid));
					new kocsi = GetPlayerVehicleID(playerid);
					if(KerekBilincs[kocsi] == 1) return Msg(playerid, "Kerékbilincs van a jármûn, nem bírod elvinni...");
					if(KocsiElet(kocsi) <= 350) return Msg(playerid, "A jármû elromlott! (/v repair)");
					if(engineOn[kocsi] == 0)
					{
						if(car != -1)
						{
							if(CarInfo[car][cFrakcio] == 0 && CarInfo[car][cBRendszerAktiv] == 1 && BRendszerAktiv[kocsi] == 0 && Lefoglalt[playerid] != 1) return Msg(playerid, "** Figyelmeztetés: Írd be a jelszót! (( /br jelszó [Kód] )) ** ");
						}

						if(BenzinesKocsi(kocsi) && Gas[kocsi][0] <= 0)
						{
							engineOn[kocsi] = 0;
							SetJarmu(kocsi, KOCSI_MOTOR, false);
							Msg(playerid, "Nincs elég benzin!");
							return 1;
						}
						else if(DieselesKocsi(kocsi) && Gas[kocsi][1] <= 0)
						{
							engineOn[kocsi] = 0;
							SetJarmu(kocsi, KOCSI_MOTOR, false);
							Msg(playerid, "Nincs elég diesel!");
							return 1;
						}
						
						if(SajatKocsi(playerid, kocsi) || car != -1 && CarInfo[car][cOwned] == 0)
						{
							if(MunkaFolyamatban[playerid] == 1) return Msg(playerid, "Már elkezdtél valamilyen munkafolyamatot.");
							new kocsiserules, ido, Float:kocsielet;
							GetVehicleHealth(kocsi, kocsielet);
							kocsiserules = 1000 - floatround(kocsielet);
							ido = 1000 + (kocsiserules * 5);
							GameTextForPlayer(playerid, "Motor indítása...", VEHICLE_GAMETEXT_TIME, VEHICLE_GAMETEXT_STYLE);
							SetTimerEx("Munkavege", ido, false, "ddd", playerid, M_MOTOR, 0);
							MunkaFolyamatban[playerid] = 1;
						}
						else
						{
							if(IsBerelhetoJarmu(kocsi))
							{	
								new szoveg[128]; Format(szoveg, "Ez egy bérelhetõ jármû amelynek az ára $%s! Bérléshez: /rentcar", PenzTordeles(BERLESAR));	
								Msg(playerid, szoveg);						
							}
							else
							{
								iMsg(playerid, "Nincs kulcsod ehhez a jármûhöz!");
							}
						}
					}
					else
					{
						BRendszerAktiv[kocsi] = 0;
						engineOn[kocsi] = 0;
						SetJarmu(kocsi, KOCSI_MOTOR, false);
						iMsg(playerid, "Motor ~r~leállítva", false);
					}
				}
				case 1:
				{
					if(!Sofor(playerid)) return iMsg(playerid, "Csak sofõr!");
					new model = GetVehicleModel(veh);
					if(IsAPlane(veh) || IsABoat(veh) || IsABicikli(veh) && model != 481 && model != 510 && model != 509) return Msg(playerid, "A jármûvön nincs lámpa!");

					if(GetJarmu(veh, KOCSI_LAMPA) == 1)
					{
						BlinkingLights(veh, false);
						SetJarmu(veh, KOCSI_LAMPA, 0);
						DestroyVehicleObject(BicajLampa[veh][0]);
						DestroyVehicleObject(BicajLampa[veh][1]);
						iMsg(playerid, "Lámpák ~r~kikapcsolva", false);
					}
					else
					{
						SetJarmu(veh, KOCSI_LAMPA, 1);
						if(model == 481)
						{
							BicajLampa[veh][0] = CreateVehicleObject(19280, veh, 0.01, 0.44, 0.38, 0.00, 0.00, 0.00, 50);
							BicajLampa[veh][1] = CreateVehicleObject(19282, veh, 0.00, -0.28, 0.10,   0.00, 0.00, 0.00, 50);
						}
						else if(model == 510)
						{
							BicajLampa[veh][0] = CreateVehicleObject(19280, veh, 0.01, 0.46, 0.18, 0.00, 0.00, 0.00, 50);
							BicajLampa[veh][1] = CreateVehicleObject(19282, veh, 0.00, -0.26, 0.10,   0.00, 0.00, 0.00, 50);
						}
						else if(model == 509)
						{
							BicajLampa[veh][0] = CreateVehicleObject(19280, veh, 0.00, 0.40, 0.42,   0.00, 0.00, 0.00, 50);
							BicajLampa[veh][1] = CreateVehicleObject(19282, veh,0.00, -0.74, 0.28,   0.00, 0.00, 0.00, 50);
						}
						iMsg(playerid, "Lámpák ~g~bekapcsolva", false);
					}
				}
				case 2:
				{
					if(!IsPlayerInAnyVehicle(playerid)) return Msg(playerid, "Nem vagy jármûben!");
					if(IsAPlane(veh) || IsABoat(veh) || Bikes(veh)) return Msg(playerid, "A jármûvön nincs csomagtartó!!");
					if(GetJarmu(veh, KOCSI_MOTORHAZTETO) == 1)
					{
						Msg(playerid, "Nyitva van már! (kívülrõl tudod becsukni ugyan úgy az 'N' betûvel");
					}
					else
					{
						SetJarmu(veh, KOCSI_MOTORHAZTETO, 1);
						Cselekves(playerid, "kinyitotta a motorháztetõt");
					}
				}
				case 3:
				{
					if(!Sofor(playerid)) return iMsg(playerid, "Csak sofõr!");
					PlayerText[playerid] = "Zene lejátszás rádióból\nZene lejátszás URL-bõl\nZene lejátszás YT linkbõl\nKikapcsol";
					ShowPlayerDialog(playerid, RADIODIALOG, DIALOG_STYLE_LIST, "Jármû rádiója", PlayerText[playerid], "Megnyit", "Mégse");
				}
				case 4:
				{
					if(!IsPlayerInAnyVehicle(playerid)) return Msg(playerid, "Nem vagy jármûben!");
					if(IsAPlane(veh) || IsABoat(veh) || Bikes(veh)) return Msg(playerid, "A jármûvön nincs csomagtartó!!");
					if(KocsiIndexStat[veh] == INDEX_MINDD)
					{
						IndexKi(GetPlayerVehicleID(playerid));
						Cselekves(playerid, "kikapcsolta az elakadásjelzõt",1);
					}
					else
					{
						IndexLampa(GetPlayerVehicleID(playerid),INDEX_MINDD);
						Cselekves(playerid, "bekapcsolta az elakadásjelzõt",1);
					}
				}
				case 5:
				{
					if(!IsPlayerInAnyVehicle(playerid)) return Msg(playerid, "Nem vagy jármûben!");
					//if(!IsACop(playerid)) return Msg(playerid, "Nem vagy egy rendvédelmi szervezet tagja sem!");
					
					if(Villogo[veh][2] == 1)
						JarmuFenyhid(veh, false);
					else
					{
						if(!JarmuFenyhid(veh, true))
						{
							iMsg(playerid, "Ezen a jármûvön nincs megkülönböztetõ jelzés!");
						}
					}
				}
				case 6:
				{
					if(!IsPlayerInAnyVehicle(playerid)) return Msg(playerid, "Nem vagy jármûben.");
					if(!IsABicikli(GetPlayerVehicleID(playerid)) && !Bikes(GetPlayerVehicleID(playerid)) && !IsAMotor(GetPlayerVehicleID(playerid)))
					{
						if(!AblakLent[GetPlayerVehicleID(playerid)])
						{
							SetVehicleParamsCarWindows(GetPlayerVehicleID(playerid), false, false, false, false);
							iMsg(playerid, "Ablak lehúzva.");
							AblakLent[GetPlayerVehicleID(playerid)] = true;
							Cselekves(playerid, "lehúzta a jármû ablakát.");
							return 1;
						}
						iMsg(playerid, "Ablak felhúzva.");
						AblakLent[GetPlayerVehicleID(playerid)] = false;
						Cselekves(playerid, "felhúzta a jármû ablakát.");
						SetVehicleParamsCarWindows(GetPlayerVehicleID(playerid), true, true, true, true);
						return 1;
					}
					else return Msg(playerid, "Ennek a jármûnek nincs ablaka.");	
				}
				case 7:
				{
					Msg(playerid, "Hamarosan!");	
				}
			}
		}
	}
	else if(dialogid == DIALOG_KOCSIM_KIVUL)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: // csomagtartó
				{
					new veh = GetClosestCar(playerid);
					if(GetDistanceToVehicle(playerid,veh) < 5.5)
					{
						if(GetJarmu(veh, KOCSI_CSOMAGTARTO) == 1)
						{
							SetJarmu(veh, KOCSI_CSOMAGTARTO, 0);
							Cselekves(playerid, "bezárta a csomagtartót");
						}
						else
						{
							SetJarmu(veh, KOCSI_CSOMAGTARTO, 1);
							Cselekves(playerid, "kinyitotta a csomagtartót");
						}
					}
				}
				case 1: // motorháztetõ
				{
					new veh = GetClosestCar(playerid);
					if(GetDistanceToVehicle(playerid,veh) < 5.5)
					{
						if(IsAPlane(veh) || IsABoat(veh) || Bikes(veh)) return Msg(playerid, "A jármûvön nincs csomagtartó!!");
						if(GetJarmu(veh, KOCSI_MOTORHAZTETO) == 1)
						{
							SetJarmu(veh, KOCSI_MOTORHAZTETO, 0);
							Cselekves(playerid, "bezárta a motorháztetõt");
						}
						else
						{	
							Msg(playerid, "Zárva van már!");	
						}
					}
				}
				case 2:
				{
					Msg(playerid, "Ideiglenesen: /v zár, /lock, /fk zár");
					/*new carid = GetClosestVehicle(playerid);				
					new vs = IsAVsKocsi(carid);

					if(!LMT(playerid,CarInfo[vs][cFrakcio]))
						return Msg(playerid, "Ez nem a te frakciód kocsija!");
					
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
					}*/
					
					/*new berkocsi = carid;
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
					}*/
				}
			}
		}
	}
	else if(dialogid == DIALOG_KARAKTERREG_PASS)
	{
		if(response)
		{
			new pass[256];
			SHA256_PassHash(inputtext, SALT_NORMALPW, pass, sizeof(pass));
			strmid(PlayerInfo[playerid][pKey], pass, 0, strlen(pass), 256);
			KarakterRegisztracio(playerid, 2);
		}
	}
	else if(dialogid == DIALOG_TELEFON)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: // hívás
				{
					ShowPlayerDialog(playerid, DIALOG_TELEFON_HIVAS, DIALOG_STYLE_INPUT, "Sony XPERIA Z", "{FFFFFF}Kérlek írd be a felhívni kívánt telefonszámot!\n{00FF00}", "Hívás", "Mégse");
				}
				case 1: // hívás felvétele
				{
					new sendername[MAX_PLAYER_NAME];
					if(PlayerTied[playerid] == 1) return Msg(playerid, "Megkötözve nincs telefonálás!");
					if(PlayerCuffed[playerid] == 2) return Msg(playerid, "Bilincsben nincs telefonálás!");
					if(IsPlayerConnected(playerid))
					{
						if(Mobile[playerid] != -1) return Msg(playerid, "Már hívásban vagy...");
						PlayerForeach(i)
						{
							if(IsPlayerConnected(i))
							{
								if(Mobile[i] == playerid)
								{
									Mobile[playerid] = i;
									Msg(i, "Felvették a telefont.");
									GetPlayerName(playerid, sendername, sizeof(sendername));
									Cselekves(playerid, "felvette a telefonját");
									
									SetPlayerAttachedObject(playerid, SLOT_KEZ, 18865, 6, 0.115999, 0.005999, -0.000999, -104.700004, -11.600001, 156.200042, 1.000000, 1.000000, 1.000000);
									SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USECELLPHONE);
									
									RingTone[playerid] = 0;
								}
							}
						}
					}
					return 1;
				}
				case 2: // hívás kinyomása
				{
					new caller = Mobile[playerid];
					if(IsPlayerConnected(caller))
					{
						if(caller != INVALID_PLAYER_ID)
						{
							if(caller != -1)
							{
								if(caller > -1)
								{
									Msg(caller, "Lerakták.");
									
									if(IsPlayerAttachedObjectSlotUsed(caller, SLOT_KEZ)) RemovePlayerAttachedObject(caller, SLOT_KEZ);
									SetPlayerSpecialAction(caller, SPECIAL_ACTION_STOPUSECELLPHONE);
									
									CellTime[caller] = 0;
									CellTime[playerid] = 0;
									Msg(playerid, "Leraktad");
									Cselekves(playerid, "kinyomta a hívást", 1);
									Mobile[caller] = -1;
								}
								Mobile[playerid] = -1;
								CellTime[playerid] = 0;
								RingTone[playerid] = 0;
								
								if(IsPlayerAttachedObjectSlotUsed(playerid, SLOT_KEZ)) RemovePlayerAttachedObject(playerid, SLOT_KEZ);
								SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
								
								return 1;
							}
						}
					}
					else
					{
						if(caller != INVALID_PLAYER_ID)
						{
							if(caller != -1)
							{
								if(caller > -1)
								{
									CellTime[playerid] = 0;
									SendClientMessage(playerid,  COLOR_GRAD2, "Leraktad");
								}
								Mobile[playerid] = -1;
								CellTime[playerid] = 0;
								RingTone[playerid] = 0;
								
								if(IsPlayerAttachedObjectSlotUsed(playerid, SLOT_KEZ)) RemovePlayerAttachedObject(playerid, SLOT_KEZ);								
								SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
								return 1;
							}
						}
					}
					return 1;
				}
				case 3: // SMS küldés
				{
					Msg(playerid, "Egyenlõre használd a /sms parancsot!");
				}
				case 4: // egyenleg lekérdezése
				{
					new egyenleg = PlayerInfo[playerid][pTeloEgyenleg];
					format(string, sizeof(string), "[%s]SMS: Egyenlege $%d. Egyenleg feltöltés: /egyenleg feltölt",SzolgaltatoNev(playerid),egyenleg);
					SendClientMessage(playerid, COLOR_YELLOW, string);
					Cselekves(playerid, "lekérte az egyenlegét", 1);
				}
				case 5: // Ki / Be kapcsolás
				{
					if(!PhoneOnline[playerid])
					{
						PhoneOnline[playerid] = 1;
						ShowPlayerDialog(playerid, DIALOG_NINCS, DIALOG_STYLE_MSGBOX, "Sony XPERIA Z", "{FFFFFF}Sikeresen {FF0000}kikapcsoltad{FFFFFF} a telefonod!", "Bezárás", "");
						Cselekves(playerid, "kikapcsolta a telefonját.", 1);
					}
					else if(PhoneOnline[playerid])
					{
						PhoneOnline[playerid] = 0;
						ShowPlayerDialog(playerid, DIALOG_NINCS, DIALOG_STYLE_MSGBOX, "Sony XPERIA Z", "{FFFFFF}Sikeresen {00FF00}bekapcsoltad{FFFFFF} a telefonod!", "Bezárás", "");
						Cselekves(playerid, "bekapcsolta a telefonját.",1);
					}
				}
			}
		}
	}
	else if(dialogid == DIALOG_AUTOKER_KAT)
	{
		if(response)
		{
			new type;
			switch(listitem)
			{
				case 0:	type = autokereskedes_motorkerekpar;
				case 1: type = autokereskedes_ipari;
				case 2: type = autokereskedes_lowrider;				
				case 3: type = autokereskedes_terepjaro;
				case 4: type = autokereskedes_furgon;
				case 5: type = autokereskedes_sedan;
				case 6: type = autokereskedes_kombi;
				case 7: type = autokereskedes_sport;
			}
			ShowModelSelectionMenu(playerid, type, "Vehicle Purchase", DIALOG_BG_COLOR, PREV_BG_COLOR, PREV_BG_COLOR2);
		}
	}
	else if(dialogid == DIALOG_JARMUVASARLAS_MEGEROSIT)
	{
		if(response)
		{
			new model = PlayerNumber[playerid], kocsiar = KereskedesArlista(model);
			new szin1 = Rand(0, 255), szin2 = szin1;
			
			if(kocsiar <= 0)
			{
				MsgFormat(playerid, "A(z) %d ID-jû jármû számodra nem rendelhetõ meg!", model);
				return 1;
			}
			
			if(GetMoney(playerid) < kocsiar)
			{
				MsgFormat(playerid, "Ez a jármû $%s amelyre neked nincs pénzed!", PenzTordeles(kocsiar));
				return 1;
			}
			
			new hely = random(sizeof(KereskedoSpawn));
			Automatakereskedo(playerid, KereskedoSpawn[hely][0], KereskedoSpawn[hely][1], KereskedoSpawn[hely][2], KereskedoSpawn[hely][3], model, szin1, szin2);
			
			GiveMoney(playerid, -kocsiar);
			
			MsgFormat(playerid, "Sikeresen vettél egy jármûvet! Ára: $%s", PenzTordeles(kocsiar));
			SetPlayerCheckpoint(playerid, KereskedoSpawn[hely][0], KereskedoSpawn[hely][1], KereskedoSpawn[hely][2], 5.0);
		}
		return 1;
	}
	else if(dialogid == DIALOG_TANKOLAS && response)
	{
		iMsg(playerid, "Elkezdted megtankolni a jármûvedet.");

		if(GetMoney(playerid) < GetPVarInt(playerid, "Tankolas_UzemanyagAr"))
		{
			Msg(playerid, "Sajnos nincs elég pénzed!");
			return 1;
		}
		
		new 
			uzemanyagtipus = GetPVarInt(playerid, "Tankolas_GasType"),
			vehicleid = GetPVarInt(playerid, "Tankolas_CarID")
		;
		
		Gas[vehicleid][uzemanyagtipus] ++;
		//Freeze(playerid);
		Tankol[playerid][0] = 1;
		
		DestroyDynamic3DTextLabel(Tankolas3D[vehicleid]);
		Tankolas3D[vehicleid] = CreateDynamic3DTextLabel("(( ..... ))\nTANKOLÁS", COLOR_GREEN, 0.0, 0.0, 0.0, 50.0, _, vehicleid);
		
		SetTimerEx("BenzinTankolas", 1000, false, "ddd", playerid, uzemanyagtipus);
	}
	else if(dialogid == DIALOG_CARRESTART)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: // Közelben lévõ
				{
					new car = NINCS;
					if(!IsPlayerInAnyVehicle(playerid))
						car = GetClosestVehicle(playerid);
					else
						car = GetPlayerVehicleID(playerid);

					if(GetDistanceToVehicle(playerid, car) < 5.0)
					{
						GetDamageStat(car);
						SendFormatMessage(playerid, COLOR_GRAD1, "Helyre tetted a kocsit! [ID: %d]", car);
						engineOn[car] = 0;
						SetJarmu(car, KOCSI_MOTOR, 0);
						KocsiRespawn(car);
					}
					else return iMsg(playerid, "A közeledben nincs jármû!");

					if(IsPlayerInAnyVehicle(playerid))
						UnFreeze(playerid);
				}
				case 1: // Módos jármûvek
				{
					if(!Admin(playerid, FOADMIN)) return Msg(playerid, "Nem vagy FõAdmin!");
					
					VehicleForeach(x)
					{
						//if(!IsValidVehicleID(x)) continue;
						if(IsAVsKocsi(x) == NINCS)
						{
							if(KocsiSofor(x) == NINCS)
							{
								KocsiRespawn(x);
								MaxUzemanyag(x);
								
								RepairVehicle(x);
								new model = GetVehicleModel(x);
								if(model == 528 || model == 432 || model == 427 || model == 428 || model == 601)
									SetVehicleHealth(x, 20000.0);
								
								engineOn[x] = 0;
								SetJarmu(x, KOCSI_MOTOR, false);
							}
						}
					}
					SendFormatMessageToAll(COLOR_YELLOW, "{009900}• {FFFF00}(%s) %s respawnolta a munka és bérelhetõ jármûveket {009900}•", AdminSzint(playerid), AdminName(playerid));	
				}
				case 2: // Frakció jármûvek
				{
					if(!Admin(playerid, FOADMIN)) return Msg(playerid, "Nem vagy FõAdmin!");
					
					VehicleForeach(x)
					{				
						new car = GetPlayerVehicleID(x);
						new vkocsi = IsAVsKocsi(car);
						
						if(CarInfo[vkocsi][cFrakcio] != 0)
						{
							GetDamageStat(x);
							KocsiRespawn(x);
						}
					}
					
					PlayerTextFormat(playerid, "(%s) %s respawnolta az összes frakció jármûvet", AdminSzint(playerid), AdminName(playerid));
					AdminCMD(PlayerText[playerid]);
				}
				case 3: // Összes jármû
				{
					if(!Admin(playerid, FOADMIN)) return Msg(playerid, "Nem vagy FõAdmin!");
					
					SendFormatMessageToAll(COLOR_YELLOW, "{009900}• {FFFF00}(%s) %s respawnolta a 15 perce nem használt jármûveket {009900}•", AdminSzint(playerid), AdminName(playerid));	
					//TextDrawShowForAll(resitd);
				}
				case 4: // Összes jármû bug esetén
				{
					if(!Admin(playerid, FOADMIN)) return Msg(playerid, "Nem vagy FõAdmin!");
					VehicleForeach(x)
					{
						if(!IsValidVehicleID(x)) continue;
						if(KocsiSofor(x) == NINCS)
						{
							GetDamageStat(x);
							KocsiRespawn(x);
						}
					}
					
					PlayerTextFormat(playerid, "(%s) %s respawnolta az összes jármûvet", AdminSzint(playerid), AdminName(playerid));
					AdminCMD(PlayerText[playerid]);
				}
			}
		}
	}
	/* ################################################################################################################# */
	else if(dialogid == DIALOG_CSPANEL_FOMENU)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: // Új tag felvétele
				{
					if(!CsoportLeader(playerid))
					{
						MsgDialog(playerid, "Hiba!", "Nem vagy egyetlen csoport vezetõje sem!", "Bezárás");
						return 1;
					}
					ShowPlayerDialog(playerid, DIALOG_CSPANEL_TAGFELVETEL, DIALOG_STYLE_INPUT, "Új tag felvétele", "Írd be a játékos nevét vagy ID-jét!", "Felvesz", "Mégse");
				}
				case 1: // Tag kirúgása
				{
					if(!CsoportLeader(playerid))
					{
						MsgDialog(playerid, "Hiba!", "Nem vagy egyetlen csoport vezetõje sem!", "Bezárás");
						return 1;
					}
					ShowPlayerDialog(playerid, DIALOG_CSPANEL_TAGKIRUGAS, DIALOG_STYLE_INPUT, "Tag kirúgása", "Írd be a játékos nevét vagy ID-jét!", "Kirúg", "Mégse");
				}
				case 2: // Online tagok
				{
					new CsoportID = PlayerInfo[playerid][pCsoport];
					Msg(playerid, ValasztoVonal(CsoportInfo[CsoportID][CsNev]));
					new jail[48], count;
					PlayerForeach(x)
					{
						if(!IsPlayerConnected(x) || IsPlayerNPC(x) || PlayerInfo[x][pCsoport] != PlayerInfo[playerid][pCsoport]) continue;
						if(PlayerInfo[x][pJailed] == BORTON_ADMIN && PlayerInfo[x][pJailTime] > 0 || PlayerInfo[x][pJailed] == BORTON_ADMIN2 && PlayerInfo[x][pJailTime] > 0)
						{
							jail="- {FF0000}!!! ADMIN JAIL !!!";
						}
						else jail = "";
						
						if(PlayerSQLID(playerid) == CsoportInfo[CsoportID][CsLeader]) {
							MsgFormat(playerid, "[%d]%s - LEADER - %s", x, PlayerName(x), jail);
						} else {
							MsgFormat(playerid, "[%d]%s %s", x, PlayerName(x), jail);
						}
						
						count++;
					}
					if(count == 0) Msg(playerid, "Nincs online tag!");
					Msg(playerid, ValasztoVonal(CsoportInfo[CsoportID][CsNev]));
				}
				case 3: // Csoport nevének szerkesztése
				{
					if(!CsoportLeader(playerid))
					{
						MsgDialog(playerid, "Hiba!", "Nem vagy egyetlen csoport vezetõje sem!", "Bezárás");
						return 1;
					}
					PlayerTextFormat(playerid, "Írd be a csoport új nevét!\nMaximum %d karakter lehet!", MAX_CSOPORTNEV_HOSSZ);
					ShowPlayerDialog(playerid, DIALOG_CSPANEL_NEVSZERKESZTES, DIALOG_STYLE_INPUT, "Csoport nevének szerkesztése", PlayerText[playerid], "Átír", "Mégse");
				}
			}
		}
		return 1;
	}
	else if(dialogid == DIALOG_CSPANEL_TAGFELVETEL)
	{
		if(response)
		{
			new para1 = ReturnUser(inputtext), playername[MAX_PLAYER_NAME], sendername[MAX_PLAYER_NAME], szoveg[124];
			GetPlayerName(para1, playername, sizeof(playername));
			GetPlayerName(playerid, sendername, sizeof(sendername));
			
			new CsoportID = PlayerInfo[playerid][pCsoport];
			
			if(para1 == INVALID_PLAYER_ID) 
			{
				MsgDialog(playerid, "Hiba!", "Hibás JátékosID/NévRészlet!", "Bezárás");
				return 1;
			}
			
			if(!Civil(para1)) return MsgDialog(playerid, "Hiba!", "A játékos frakcióban van ezért nem veheted fel a csoportodba!", "Bezár");
			if(PlayerInfo[para1][pCsoport] != 0) return MsgDialog(playerid, "Hiba!", "A játékosnak már van csoportja!", "Bezár");
			
			CsoportInfo[CsoportID][CsMembers] ++;
			
			Format(szoveg, "Sikeresen felvetted hozzátok %s-t tagnak!", PlayerName(para1));
			MsgDialog(playerid, "CSPANEL: Új tag felvétel", szoveg, "Bezár");
			
			Format(szoveg, "Sikeresen csatlakoztál a következõ csoporthoz: %s", CsoportInfo[CsoportID][CsNev]);
			MsgDialog(para1, "CSPANEL: Új tag felvétel", szoveg, "Bezár");
			
			GetPlayerPos(playerid, ChangePos[para1][0],ChangePos[para1][1],ChangePos[para1][2]);
			ChangePos2[para1][0] = GetPlayerInterior(playerid);
			ChangePos2[para1][1] = GetPlayerVirtualWorld(playerid);

			PlayerInfo[para1][pCsoport] = CsoportID;
			PlayerUpdate(para1, "Csoport = '%d' ", CsoportID);
		}
	}
	else if(dialogid == DIALOG_CSPANEL_TAGKIRUGAS)
	{
		if(response)
		{
			new para1 = ReturnUser(inputtext), playername[MAX_PLAYER_NAME], sendername[MAX_PLAYER_NAME], szoveg[124];
			GetPlayerName(para1, playername, sizeof(playername));
			GetPlayerName(playerid, sendername, sizeof(sendername));
			
			new CsoportID = PlayerInfo[playerid][pCsoport];
			
			if(para1 == INVALID_PLAYER_ID) 
			{
				MsgDialog(playerid, "Hiba!", "Hibás JátékosID/NévRészlet!", "Bezárás");
				return 1;
			}
			
			if(PlayerInfo[para1][pCsoport] != PlayerInfo[playerid][pCsoport])
			{
				Format(szoveg, "%s nem a te csoportod tagja ezért nem rúghatod ki!", PlayerName(playerid));
				MsgDialog(playerid, "Hiba!", szoveg, "Bezár");
				return 1;
			}
			
			CsoportInfo[CsoportID][CsMembers] --;
			
			Format(szoveg, "Sikeresen kirúgtad %s-t tõletek!", PlayerName(para1));
			MsgDialog(playerid, "Tag sikeresen kirúgva", szoveg, "Bezár");
			
			Format(szoveg, "Kirúgtak a(z) %s nevû csoportból!", CsoportInfo[CsoportID][CsNev]);
			MsgDialog(para1, "CSPANEL: Tag kirúgás eltávolítás", szoveg, "Bezár");

			PlayerInfo[para1][pCsoport] = 0;
			PlayerUpdate(para1, "Csoport = '%d' ", 0);
		}
	}
	else if(dialogid == DIALOG_CSPANEL_NEVSZERKESZTES)
	{	
		if(response)
		{			
			if(strlen(inputtext) > 1)
			{		
				new 
					szoveg[124], 
					query[124], 
					CsoportID = PlayerInfo[playerid][pCsoport]
				;
				
				if(strlen(inputtext) > MAX_CSOPORTNEV_HOSSZ)
				{
					Format(szoveg, "A csoport neve maximum %d karakter lehet!", MAX_CSOPORTNEV_HOSSZ); 
					HibaDialog(playerid, szoveg, DIALOG_CSPANEL_NEVSZERKESZTES);
					return 1;
				}
				
				//if(SpecKarakterek(inputtext, ",")) return MsgDialog(playerid, "{FF0000}Hiba!", "{FFFFFF}A rang neve nem tartalmazhat vesszõt (,)!", "Bezár");
				
				strmid(CsoportInfo[CsoportID][CsNev], inputtext, 0, strlen(inputtext), MAX_CSOPORTNEV_HOSSZ);
				
				Format(query, "UPDATE csoportok SET Nev = '%s' WHERE ID = '%d' ", inputtext, CsoportID);
				mysql_query(query);
				
				Format(szoveg, "Sikeresen a módosítottad csoport nevét!\n\nA csoport új neve: {%s}%s", COLOR_MSG, inputtext);
				MsgDialog(playerid, "CSPANEL: Csoportnév szerkesztés", szoveg, "Bezár");
			}
			else
			{
				HibaDialog(playerid, "Ne hagyd üresen!");
				return 1;
			}
		}
	}
	/* ##################################################################################################### */
	else if(dialogid == DIALOG_ButorMain)
	{
		if(!response) return 1;
	
		switch(listitem)
		{
			case 0: 
			{
				PlayerInfo[playerid][pBUj] = false;
				new diastr[2048];
				strcat(diastr, "Bútor típus\tBútor modelid");
				new hid = PlayerInfo[playerid][pBHaz], lid = 0;
				for(new i = 1; i < MAX_BUTOR; i++) 
				{
					if(ButorInfo[i][butID] == -1 || ButorInfo[i][butHaz] != hid) continue;
					ButorEditLID[playerid][lid] = i;
					Format(diastr, "%s\n%s\t%i", diastr, ButorInfo[i][butTipus], ButorInfo[i][butButor]);
					lid ++;
				}
				ShowPlayerDialog(playerid, DIALOG_ButorEditLista, DIALOG_STYLE_TABLIST_HEADERS,"Bútorlista", diastr, "Kiválaszt","Kilép");
			}
			case 1: 
			{
				new str[512];
				strcat(str, "Bútor típus\tBútor típus ára\nAsztalok\t$140\nSzékek\t$55\nFotelok és kanapék\t$320\nSzekrények\t$370\nÁgyak\t$350\nTelevíziók\t$170");
				Format(str, "%s\nÍróasztalok\t$120\nAjtók\t$260\nDekorációs tárgyak\t$70\nFestmények\t$260\nPadló díszítõk, szõnyegek\t$90\nLámpák\t$150\nHangteknikai eszközök, rádiók\t$380\nHangszerek\t$470\nEgyéb elektronikai eszközök\t$220\nFürdõszobai berendezések\t$390\nKonyhai berendezések\t$450\nNövények\t$60\nEdzõgépek\t$370\nFûtés, és légkondicionálók\t$170\nKandallók\t$190\nSzéf\t$510",str);
				PlayerInfo[playerid][pBUj] = true;
				ShowPlayerDialog(playerid, DIALOG_ButorVeszLista, DIALOG_STYLE_TABLIST_HEADERS,"Vehetõ bútorok", str, "Kiválaszt","Vissza");
			}
		}
		return 1;
	}
	else if(dialogid == DIALOG_ButorEditLista)
	{
		if(!response) return 1;
		new bid = ButorEditLID[playerid][listitem];
		ButorEditSEL[playerid] = bid;
		ShowPlayerDialog(playerid, DIALOG_ButorEditListaOpc, DIALOG_STYLE_LIST, "Kiválasztott bútor opciók", "Pozíció módosítás\n{ff0000}Bútor törlése", "Kiválaszt", "Kilép");
		return 1;
	}
	else if(dialogid == DIALOG_ButorEditListaOpc)
	{
		if(!response) return 1;
		new bid = ButorEditSEL[playerid];
		switch(listitem)
		{
			case 0: 
			{
				if(GetPlayerVirtualWorld(playerid) != ButorInfo[bid][butVW]) return Msg(playerid, "Nem látod a bútort.");
				EditDynamicObject(playerid, ButorInfo[bid][butObj]);
			}
			case 1: 
			{
				//DeleteButor(bid);
				Msg(playerid, "Kitörölted a bútort, viszont nem kaptad vissza az árát.");
			}
		}
		return 1;
	}
	else if(dialogid == DIALOG_ButorVeszLista)
	{
		if(!response)
		{
			ShowPlayerDialog(playerid, DIALOG_ButorMain, DIALOG_STYLE_LIST, "Bútorkezelés", "A házban található bútorok listája\nÚj bútor vásárlásása", "Kiválaszt", "Kilép");
			return 1;
		}
		
		switch(listitem)
		{
			case 0: ShowModelSelectionMenuEx(playerid, Asztalok, sizeof(Asztalok), "Asztalok", BVAsztal, -25.0000, 0.0000, 0.0000, 1.0, 0x1f1e1eAA);
			case 1: ShowModelSelectionMenuEx(playerid, Szekek, sizeof(Szekek), "Székek", BVSzek, 0.0000, 0.0000, 0.0000, 1.0, 0x1f1e1eAA);
			case 2: ShowModelSelectionMenuEx(playerid, FotelKanape, sizeof(FotelKanape), "Fotelok és kanapék", BVFotelKanape, 0.0000, 0.0000, 0.0000, 1.0, 0x1f1e1eAA);
			case 3: ShowModelSelectionMenuEx(playerid, Szekreny, sizeof(Szekreny), "Szekrények", BVSzekreny, 0.0000, 0.0000, 0.0000, 1.0, 0x1f1e1eAA);
			case 4: ShowModelSelectionMenuEx(playerid, Agyak, sizeof(Agyak), "Ágyak", BVAgyak, 0.0000, 0.0000, 0.0000, 1.0, 0x1f1e1eAA);
			case 5: ShowModelSelectionMenuEx(playerid, Televizio, sizeof(Televizio), "Televíziók", BVTelevizio, 0.0000, 0.0000, 0.0000, 1.0, 0x1f1e1eAA);
			case 6: ShowModelSelectionMenuEx(playerid, Iroasztalok, sizeof(Iroasztalok), "Íróasztalok", BVIroasztalok, 0.0000, 0.0000, 0.0000, 1.0, 0x1f1e1eAA);
			case 7: ShowModelSelectionMenuEx(playerid, ButorAjtok, sizeof(ButorAjtok), "Ajtók", BVAjtok, 0.0000, 0.0000, 0.0000, 1.0, 0x1f1e1eAA);
			case 8: ShowModelSelectionMenuEx(playerid, DekTargy, sizeof(DekTargy), "Dekor˜˜ciós tá˜rgyak", BVDekTargy, 0.0000, 0.0000, 0.0000, 1.0, 0x1f1e1eAA);
			case 9: ShowModelSelectionMenuEx(playerid, Festmenyek, sizeof(Festmenyek), "Festmények", BVFestmenyek, 0.0000, 0.0000, 0.0000, 1.0, 0x1f1e1eAA);
			case 10: ShowModelSelectionMenuEx(playerid, PadSzonyeg, sizeof(PadSzonyeg), "Padló szõnyegek", BVPadSzonyeg, 0.0000, 0.0000, 0.0000, 1.0, 0x1f1e1eAA);
			case 11: ShowModelSelectionMenuEx(playerid, Lampak, sizeof(Lampak), "Lámpák", BVLampak, 0.0000, 0.0000, 0.0000, 1.0, 0x1f1e1eAA);
			case 12: ShowModelSelectionMenuEx(playerid, HangTechRadio, sizeof(HangTechRadio), "Hangteknikai eszközök, rádiók", BVHangTechRadio, 0.0000, 0.0000, 0.0000, 1.0, 0x1f1e1eAA);
			case 13: ShowModelSelectionMenuEx(playerid, Hangszerek, sizeof(Hangszerek), "Hangszerek", BVHangszerek, 0.0000, 0.0000, 0.0000, 1.0, 0x1f1e1eAA);
			case 14: ShowModelSelectionMenuEx(playerid, EgyElEszk, sizeof(EgyElEszk), "Egyéb elektronikai eszközök", BVEgyElEszk, 0.0000, 0.0000, 0.0000, 1.0, 0x1f1e1eAA);
			case 15: ShowModelSelectionMenuEx(playerid, FurdoSzoba, sizeof(FurdoSzoba), "Fürdõszobai berendezések", BVFurdoSzoba, 0.0000, 0.0000, 0.0000, 1.0, 0x1f1e1eAA);
			case 16: ShowModelSelectionMenuEx(playerid, Konyha, sizeof(Konyha), "Konyhai berendezések", BVKonyha, 0.0000, 0.0000, 0.0000, 1.0, 0x1f1e1eAA);
			case 17: ShowModelSelectionMenuEx(playerid, Novenyek, sizeof(Novenyek), "Növények", BVNovenyek, 0.0000, 0.0000, 0.0000, 1.0, 0x1f1e1eAA);
			case 18: ShowModelSelectionMenuEx(playerid, Edzogepek, sizeof(Edzogepek), "Edzõgépek", BVEdzogepek, 0.0000, 0.0000, 0.0000, 1.0, 0x1f1e1eAA);
			case 19: ShowModelSelectionMenuEx(playerid, Futes, sizeof(Futes), "Fûtõ, légkondícionáló eszközök", BVFutes, 0.0000, 0.0000, 0.0000, 1.0, 0x1f1e1eAA);
			case 20: ShowModelSelectionMenuEx(playerid, Kandallo, sizeof(Kandallo), "Kandallók", BVKandallo, 0.0000, 0.0000, 0.0000, 1.0, 0x1f1e1eAA);
			case 21: 
			{
				if(GetMoney(playerid) < 510) return Msg(playerid,"Nincs nálad elég pénz!");
				//ShowDialog(playerid,Show:<ButorVeszSzefPIN>,DIALOG_STYLE_INPUT,"{ff8c00}Széf PIN kódjának kiválasztása","A listáról a széfet választottad ki.\nHogy megvehesd elõször be kell állítani a kódját ami nyitja a széfet.\nKérlek írj be egy NÉGY jegyû tetszõleges számot.","Megad","Kilép");
			}
		}
		return 1;
	}
	/* ##################################################################################################### */
	else if(dialogid == DIALOG_FKP_FOMENU)
	{
		if(response)
		{
			new opciok[124];
			switch(listitem)
			{
				case 0:
				{
					opciok = "Új tag felvétele\nTag kirúgása\nTag rangjának módosítása\nOnline tagok megtekintése";
					ShowPlayerDialog(playerid, DIALOG_FKP_TAGKEZELO, DIALOG_STYLE_LIST, "Frakció tagok kezelése", opciok, "Megnyit", "Mégse");
				}
				case 1:
				{
					opciok = "Jármû minrang állítása\nJármû leparkolása\nJármû lista";
					ShowPlayerDialog(playerid, DIALOG_FKP_JARMUKEZELO, DIALOG_STYLE_LIST, "Frakció jármûvek kezelése", opciok, "Megnyit", "Mégse");
				}
				case 2:
				{
					new munka = PlayerInfo[playerid][pMember];
					ShowPlayerDialog(playerid, DIALOG_FKP_RANGKEZELO_VALASZTAS, DIALOG_STYLE_LIST, "Rangok szerkesztése", GetAllFrakcioRang(munka), "Kiválaszt", "Mégse");
				}
				case 3:
				{
					new munka = PlayerInfo[playerid][pMember];
					
					new rangok[1024], x = munka;
					format(rangok, 1024, "Rang 0 (%s) -  $%d\nRang 1 (%s) -  $%d\nRang 2 (%s) -  $%d\nRang 3 (%s) -  $%d\
					\nRang 4 (%s) -  $%d\nRang 5 (%s) -  $%d\nRang 6 (%s) -  $%d\nRang 7 (%s) -  $%d\nRang 8 (%s) -  $%d\
					\nRang 9 (%s) -  $%d\nRang 10 (%s) -  $%d\nRang 11 (%s) -  $%d\nRang 12 (%s) -  $%d\nRang 13 (%s) -  $%d\
					\nRang 14 (%s) -  $%d\nRang 15 (%s) -  $%d\n", 	
					FrakcioRangInfo[x][0][rNev], FrakcioInfo[x][fFizetes][0], FrakcioRangInfo[x][1][rNev], FrakcioInfo[x][fFizetes][1],
					FrakcioRangInfo[x][2][rNev], FrakcioInfo[x][fFizetes][2], FrakcioRangInfo[x][3][rNev], FrakcioInfo[x][fFizetes][3],
					FrakcioRangInfo[x][4][rNev], FrakcioInfo[x][fFizetes][4], FrakcioRangInfo[x][5][rNev], FrakcioInfo[x][fFizetes][5],
					FrakcioRangInfo[x][6][rNev], FrakcioInfo[x][fFizetes][6], FrakcioRangInfo[x][7][rNev], FrakcioInfo[x][fFizetes][7],
					FrakcioRangInfo[x][8][rNev], FrakcioInfo[x][fFizetes][8], FrakcioRangInfo[x][9][rNev], FrakcioInfo[x][fFizetes][9],
					FrakcioRangInfo[x][10][rNev], FrakcioInfo[x][fFizetes][10], FrakcioRangInfo[x][11][rNev], FrakcioInfo[x][fFizetes][11],
					FrakcioRangInfo[x][12][rNev], FrakcioInfo[x][fFizetes][12], FrakcioRangInfo[x][13][rNev], FrakcioInfo[x][fFizetes][13],
					FrakcioRangInfo[x][14][rNev], FrakcioInfo[x][fFizetes][14], FrakcioRangInfo[x][15][rNev], FrakcioInfo[x][fFizetes][15]);
					
					ShowPlayerDialog(playerid, DIALOG_FKP_FIZU_VALASZTAS, DIALOG_STYLE_LIST, "Fizetés szerkesztõ", rangok, "Kiválaszt", "Mégse");
				}
			}	
		}
	}
	else if(dialogid == DIALOG_FKP_TAGKEZELO)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: // új tag felvétele
				{
					ShowPlayerDialog(playerid, DIALOG_FKP_TAGKEZELO_FELVESZ, DIALOG_STYLE_INPUT, "Új tag felvétele", "Írd be a játékos nevét vagy ID-jét!", "Felvesz", "Mégse");
				}
				case 1: // tag kirúgása
				{
					ShowPlayerDialog(playerid, DIALOG_FKP_TAGKEZELO_KIRUG, DIALOG_STYLE_INPUT, "Tag kirúgása", "Írd be a játékos nevét vagy ID-jét!", "Kirúg", "Mégse");
				}
				case 2: // rang módosítása
				{
					ShowPlayerDialog(playerid, DIALOG_FKP_TAGKEZELO_SETRANG_2, DIALOG_STYLE_INPUT, "Játékos rangjának módosítása", "Írd be a játékos nevét vagy ID-jét!", "Módosít", "Mégse");
				}			
				case 3: // online tagok
				{
					Msg(playerid, ValasztoVonal(Szervezetneve[PlayerInfo[playerid][pMember]-1][0]));
					new rang, count = 0, jail[32];
					new opperator[10];
					PlayerForeach(x)
					{
						if(!IsPlayerConnected(x) || IsPlayerNPC(x) || PlayerInfo[x][pMember] != PlayerInfo[playerid][pMember]) continue;
						rang = PlayerInfo[x][pRank];
						if(PlayerInfo[x][pJailed] == BORTON_ADMIN && PlayerInfo[x][pJailTime] > 0 || PlayerInfo[x][pJailed] == BORTON_ADMIN2 && PlayerInfo[x][pJailTime] > 0)
						{
							jail="{FF0000}!!! ADMIN JAIL !!!";
						}
						else jail = "";
						
						if(PlayerInfo[x][pOperator] == 1 && PlayerInfo[x][pMember] == 1)
						{
							opperator = "(OP)";
						}
						else opperator = "";
						  
						if(IsACop(x))
						{
							switch(PlayerInfo[x][pKituntetes])
							{
								case 0:	MsgFormat(playerid, "%s [%d]%s %s - %s (%d)", jail, x, PlayerName(x), opperator, GetPlayerRangNev(x), rang);
								case 1:	MsgFormat(playerid, "%s [%d]%s %s - %s (%d){CCFFAA} - Bronz Csillag kitüntetés",jail, x, PlayerName(x), opperator, GetPlayerRangNev(x), rang);
								case 2:	MsgFormat(playerid, "%s [%d]%s %s - %s (%d){CCFFAA} - Bronz Medál kitüntetés",jail, x, PlayerName(x), opperator, GetPlayerRangNev(x), rang);
								case 3:	MsgFormat(playerid, "%s [%d]%s %s - %s (%d){CCFFAA} - Ezüst Csillag kitüntetés",jail, x, PlayerName(x), opperator, GetPlayerRangNev(x), rang);
								case 4:	MsgFormat(playerid, "%s [%d]%s %s - %s (%d){CCFFAA} - Ezüst Medál kitüntetés",jail, x, PlayerName(x), opperator, GetPlayerRangNev(x), rang);
								case 5:	MsgFormat(playerid, "%s [%d]%s %s - %s (%d){CCFFAA} - Arany Csillag kitüntetés",jail, x, PlayerName(x), opperator, GetPlayerRangNev(x), rang);
								case 6:	MsgFormat(playerid, "%s [%d]%s %s - %s (%d){CCFFAA} - Arany Medál kitüntetés",jail, x, PlayerName(x), opperator, GetPlayerRangNev(x), rang);
							}
						}
						else
						{
							MsgFormat(playerid, "%s [%d]%s - %s (%d)", jail, x, PlayerName(x), GetPlayerRangNev(x), rang);
						}
						count++;
					}
					if(count == 0) Msg(playerid, "Nincs online tag!");
					Msg(playerid, ValasztoVonal(Szervezetneve[PlayerInfo[playerid][pMember]-1][0]));
				}
			}
		}
	}
	else if(dialogid == DIALOG_FKP_TAGKEZELO_FELVESZ)
	{
		if(response)
		{
			new para1 = ReturnUser(inputtext), playername[MAX_PLAYER_NAME], sendername[MAX_PLAYER_NAME], szoveg[124];
			GetPlayerName(para1, playername, sizeof(playername));
			GetPlayerName(playerid, sendername, sizeof(sendername));
			
			if(para1 == INVALID_PLAYER_ID) 
			{
				MsgDialog(playerid, "Hiba!", "Hibás JátékosID/NévRészlet!", "Bezárás");
				return 1;
			}
			
			if(!Civil(para1)) return MsgDialog(playerid, "Hiba!", "A játékosnak már van frakciója!", "Bezár");
			
			if(PlayerInfo[para1][pCsoport] != 0) return MsgDialog(playerid, "Hiba!", "A játékos egy csoport tagja ezért nem lehet frakcióban!", "Bezár");
			
			if(PlayerInfo[playerid][pLeader] < 1 || PlayerInfo[playerid][pLeader] > sizeof(Szervezetneve)) return 1;
			
			if(FrakcioInfo[ PlayerInfo[playerid][pLeader] ][fTagokSzama] >= FrakcioInfo[ PlayerInfo[playerid][pLeader]][fLimit]) return MsgDialog(playerid, "Hiba!", "A frakció elérte a maximális létszámot!", "Bezár");
			
			FrakcioInfo[PlayerInfo[playerid][pLeader] ][fTagokSzama] ++;
		
			PlayerInfo[para1][pMember] = PlayerInfo[playerid][pLeader];
			PlayerInfo[para1][pRank] = 0;
			
			new szt = PlayerInfo[playerid][pLeader];
			
			printf("AdminParancs: %s has invited %s to join %s.", sendername, para1, Szervezetneve[szt-1][0]);
			
			Format(szoveg, "Sikeresen felvetted hozzátok %s-t tagnak!", PlayerName(para1));
			MsgDialog(playerid, "Új tag felvétel", szoveg, "Bezár");
			
			Format(szoveg, "Sikeresen csatlakoztál a következõ frakcióhoz: %s", Szervezetneve[szt-1][0]);
			MsgDialog(para1, "Új tag felvétel", szoveg, "Bezár");
			
			GetPlayerPos(playerid, ChangePos[para1][0],ChangePos[para1][1],ChangePos[para1][2]);
			ChangePos2[para1][0] = GetPlayerInterior(playerid);
			ChangePos2[para1][1] = GetPlayerVirtualWorld(playerid);

			PlayerUpdate(para1, "Member = '%d' ", PlayerInfo[playerid][pLeader]);
			
			if(PlayerInfo[para1][pGunLic] == 0 && IsACop(para1))
			{
				PlayerInfo[para1][pGunLic] = JOGSI_FEGYVER;
			}		
		}
	}
	else if(dialogid == DIALOG_FKP_TAGKEZELO_KIRUG)
	{
		if(response)
		{
			new para1 = ReturnUser(inputtext), playername[MAX_PLAYER_NAME], sendername[MAX_PLAYER_NAME], szoveg[124];
			if(PlayerInfo[para1][pMember] > 0)
			{				
				if(PlayerInfo[para1][pLeader] == PlayerInfo[playerid][pLeader]) return MsgDialog(playerid, "Hiba!", "Õ is leader ezért nem rúghatod ki!", "Bezár");
				
				FrakcioInfo[ PlayerInfo[playerid][pLeader] ][fTagokSzama] --;
				
				printf("AdminParancs: %s has uninvited %s.", playername, sendername);
				PlayerInfo[para1][pMember] = 0;
				PlayerInfo[para1][pRank] = 0;
				PlayerInfo[para1][pChar] = 0;
				PlayerInfo[para1][pKituntetes] = 0;
				
				Format(szoveg, "Sikeresen kirúgtad õt: %s", PlayerName(para1));
				MsgDialog(playerid, "Tag kirúgása", szoveg, "Bezár");
				
				MsgDialog(para1, "Kirúgtak", "A leader kirúgott a frakcióból!", "Bezár");

				new queryx[128];
				format(queryx, 128, "UPDATE %s SET Member='%d' WHERE ID='%d'", SQL_DB_Player, PlayerInfo[playerid][pLeader], SQLID(para1));
				mysql_query(queryx);
			}
			else {
				MsgDialog(playerid, "Hiba!", "Nem azonos szervezethez tartoztok ezért nem rúghatod ki..", "Bezár");
			}
		}
	}
	else if(dialogid == DIALOG_FKP_TAGKEZELO_SETRANG_2)
	{
		if(response)
		{
			new para1 = ReturnUser(inputtext), playername[MAX_PLAYER_NAME], sendername[MAX_PLAYER_NAME], szoveg[124];
			GetPlayerName(para1, playername, sizeof(playername));
			GetPlayerName(playerid, sendername, sizeof(sendername));
			
			if(para1 == INVALID_PLAYER_ID) 
			{
				MsgDialog(playerid, "Hiba!", "Hibás JátékosID/NévRészlet!", "Bezárás");
				return 1;
			}
			
			if(GetPlayerFrakcio(playerid) != GetPlayerFrakcio(para1))
			{
				Format(szoveg, "%s nem a te frakciód tagja!", PlayerName(para1));
				MsgDialog(playerid, "Hiba!", szoveg, "Bezár");
				return 1;
			}
			
			SetPlayerNewFrakcioRang[playerid] = para1;
			
			new munka = PlayerInfo[playerid][pMember];
			Format(szoveg, "%s rangjának módosítása (most rang %d - %s)", PlayerName(para1), munka, GetPlayerRangNev(para1));
			ShowPlayerDialog(playerid, DIALOG_FKP_TAGKEZELO_SETRANG_1, DIALOG_STYLE_LIST, szoveg, GetAllFrakcioRang(munka), "Kiválaszt", "Mégse");
		}
	}
	else if(dialogid == DIALOG_FKP_TAGKEZELO_SETRANG_1)
	{
		if(response)
		{
			new rang = listitem, jatekos = SetPlayerNewFrakcioRang[playerid];

			
			PlayerInfo[jatekos][pRank] = rang;
			
			new szoveg[124];
			Format(szoveg, "Sikeresen módosítottad %s rangját!\nAz új rangja: %d (%s)", PlayerName(jatekos), rang, GetPlayerRangNev(jatekos));
			MsgDialog(playerid, "Játékos rangjának módosítása", szoveg, "Bezár");
		}
	}
	else if(dialogid == DIALOG_FKP_JARMUKEZELO)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: // minrang állítása
				{
					new munka = GetPlayerFrakcio(playerid);
					ShowPlayerDialog(playerid, DIALOG_FKP_JARMUKEZELO_MINRANG, DIALOG_STYLE_LIST, "Jármû minrang átállítása", GetAllFrakcioRang(munka), "Módosít", "Mégse");
				}
				case 1: // parkolás
				{
					new Float:x, Float:y, Float:z, Float:a, carid;
		
					carid = GetClosestVehicle(playerid);
					if(GetDistanceToVehicle(playerid, carid) > 5.5) return MsgDialog(playerid, "Hiba!", "Nincs a közeledben jármû!", "Bezár");
					
					new kocsi = IsAVsKocsi(carid);
					if(kocsi == NINCS) return MsgDialog(playerid, "Hiba!", "Ez a jármû a módba van beleírva!", "Bezár");
						
					if(CarInfo[kocsi][cFrakcio] == 0) return MsgDialog(playerid, "Hiba!", "Ez a jármû nem frakció jármû!", "Bezár");
					if(CarInfo[kocsi][cFrakcio] != PlayerInfo[playerid][pLeader]) return MsgDialog(playerid, "Hiba!", "Ez nem a te frakciód jármûve!", "Bezár");
					
					new Melo = PlayerInfo[playerid][pLeader];
					if(!PlayerToPoint(150, playerid, FrakcioInfo[Melo][fPosX], FrakcioInfo[Melo][fPosY], FrakcioInfo[Melo][fPosZ]))
					{
						MsgDialog(playerid, "Hiba!", "HQ-ra kell parkolnod a jármûveket!\n(ha a széfetek intiben van akkor szóljatok egy adminnak)", "Bezár");
						return 1;
					}
					
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
				}
				case 2: // jármû lista
				{
					if(PlayerInfo[playerid][pMember] != 0)
					{
						new h, eddig, osszeselado;
						SendClientMessage(playerid, COLOR_LIGHTBLUE, "================ Frakció jármûvei ================");
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
										SendClientMessage(playerid, COLOR_LIGHTGREEN, string);
										format(string, sizeof(string), "");
										eddig = 0;
									}
								}
							}
							
							if((h+1) == MAXVSKOCSI)
							{
								if(osszeselado == 0)
									return MsgDialog(playerid, "Hoppá!", "A frakciónak nincs a tulajdonában jármû!", "Bezár");
								else if(eddig > 0)
									SendClientMessage(playerid, COLOR_LIGHTGREEN, string);
							}
						}
					}
				}
			}
		}
	}
	else if(dialogid == DIALOG_FKP_JARMUKEZELO_MINRANG)
	{
		if(response)
		{
			if(!IsPlayerInAnyVehicle(playerid)) return MsgDialog(playerid, "Hiba!", "Nem vagy jármûben!", "Bezár");
			
			new vs = IsAVsKocsi(GetPlayerVehicleID(playerid));
			if(CarInfo[vs][cFrakcio] != PlayerInfo[playerid][pLeader]) return MsgDialog(playerid, "Hiba!", "Ez nem a te frakciód jármûve!", "Bezár");
			
			new rang;
			switch(listitem)
			{
				case 0: { rang = 0; } case 1: { rang = 1; }
				case 2: { rang = 2; } case 3: { rang = 3; }
				case 4: { rang = 4; } case 5: { rang = 5; }
				case 6: { rang = 6; } case 7: { rang = 7; }
				case 8: { rang = 8; } case 9: { rang = 9; }
				case 10: { rang = 10; } case 11: { rang = 11; }
				case 12: { rang = 12; } case 13: { rang = 13; }
				case 14: { rang = 14; } case 15: { rang = 15; }
			}
			
			CarInfo[vs][cMinRang] = rang;
			SendFormatMessage(playerid, COLOR_LIGHTGREEN, "* A jármûvet mostantól %d rangtól lehet elvinni.", rang);
			CarUpdate(vs,CAR_MinRang);
		}
	}
	else if(dialogid == DIALOG_FKP_RANGKEZELO_VALASZTAS)
	{
		if(response)
		{			
			new rang = listitem;
			
			MelyikRangotSzerkeszti[playerid] = rang;
			
			new x = GetPlayerFrakcio(playerid);
			new rangnev[48], szoveg[248];
			Format(rangnev, "Rang %d (%s) nevének szerkesztése", rang, FrakcioRangInfo[x][rang][rNev]);
			
			szoveg = "Kérlek írd be az új nevét a rangnak!\n\n{FF0000}A rangokat csak 2 óránként szerkesztheted és nem tartalmazhat vesszõt a nevük!"
			
			ShowPlayerDialog(playerid, DIALOG_FKP_RANGKEZELO_UJRANG, DIALOG_STYLE_INPUT, rangnev, szoveg, "Módosít", "Mégse");
		}
	}
	else if(dialogid == DIALOG_FKP_RANGKEZELO_UJRANG)
	{
		if(response)
		{			
			if(strlen(inputtext) > 1)
			{
				new szoveg[124];
				new rang = MelyikRangotSzerkeszti[playerid];
				new munka = GetPlayerFrakcio(playerid);
				
				if(strlen(inputtext) > MAX_FRAKCIO_RANG_HOSSZ)
				{
					Format(szoveg, "{FFFFFF}A rang neve maximum %d karakter lehet!", MAX_FRAKCIO_RANG_HOSSZ); 
					MsgDialog(playerid, "{FF0000}Hiba!", szoveg, "Bezár");
					return 1;
				}
				
				if(SpecKarakterek(inputtext, "'") OR SpecKarakterek(inputtext, ",") OR SpecKarakterek(inputtext, ",")) 
				return MsgDialog(playerid, "{FF0000}Hiba!", "{FFFFFF}A rang neve nem tartalmazhatja a következõ karaktereket: ' , ", "Bezár");
				
				strmid(FrakcioRangInfo[munka][rang][rNev], inputtext, 0, strlen(inputtext), MAX_FRAKCIO_RANG_HOSSZ);
				FrakcioUpdate(munka, FRAKCIO_Rangok);
				
				Format(szoveg, "Sikeresen átírtad a rang %d nevét erre: %s!", rang, inputtext); 
				MsgDialog(playerid, "Frakció rang szerkesztés", szoveg, "Bezár");
			}
			else
			{
				HibaDialog(playerid, "Ne hagyd üresen!");
				return 1;
			}
		}
	}
	else if(dialogid == DIALOG_FKP_FIZU_VALASZTAS)
	{
		if(response)
		{			
			new rang = listitem;
			
			MelyikRangotSzerkeszti[playerid] = rang;
			
			new maxosszeg = 800000/DOLLAR_ARFOLYAM;
			new x = GetPlayerFrakcio(playerid);
			new rangnev[48], szoveg[124];
			Format(rangnev, "Rang %d (%s) fizetésének módosítása", rang, FrakcioRangInfo[x][rang][rNev]);
			
			Format(szoveg, "Kérlek írd be az új fizetését a rangnak!\nHa szükséges használj pénzváltót! (/pénzváltó)\n\nA maximum fizetés $%s", PenzTordeles(maxosszeg));
			
			ShowPlayerDialog(playerid, DIALOG_FKP_FIZU_UJFIZETES, DIALOG_STYLE_INPUT, rangnev, szoveg, "Módosít", "Mégse");
		}
	}
	else if(dialogid == DIALOG_FKP_FIZU_UJFIZETES)
	{
		if(response)
		{
			new szoveg[124];
			new ujfizetes = strval(inputtext);	
			new rang = MelyikRangotSzerkeszti[playerid];
			new munka = GetPlayerFrakcio(playerid);
			
			new maxosszeg = 800000/DOLLAR_ARFOLYAM;
			
			if(ujfizetes < 0)
			{
				MsgDialog(playerid, "Hiba", "Hibás összeg!\nA minimum fizetés $0!", "Bezár");
				return 1;
			}
			
			if(ujfizetes > maxosszeg && !IsRicardo(playerid))
			{
				Format(szoveg, "Hibás összeg!\nA maximum fizetés $%s!", PenzTordeles(maxosszeg));
				MsgDialog(playerid, "Hiba", szoveg, "Bezár");
				return 1;
			}				
			
			FrakcioInfo[munka][fFizetes][rang] = ujfizetes;
			FrakcioUpdate(PlayerInfo[playerid][pMember], FRAKCIO_Fizetes);
			
			Format(szoveg, "Új fizetés sikeresen beállítva!\nRang %d fizetése mostantól $%s", rang, PenzTordeles(ujfizetes)); 
			MsgDialog(playerid, "Rang fizetés szerkesztõ", szoveg, "Bezár");
		}
	}
	
	/* ################################################################################################################# */
	else if(dialogid == DIALOG_EXPORTFEGYVERVASARLAS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: { ExportFegyverID[playerid] = 24; } case 1: { ExportFegyverID[playerid] = 23; }
				case 2: { ExportFegyverID[playerid] = 22; } case 3: { ExportFegyverID[playerid] = 30; } 
				case 4: { ExportFegyverID[playerid] = 29; } case 5: { ExportFegyverID[playerid] = 34; } 
				case 6: { ExportFegyverID[playerid] = 27; }	case 7: { ExportFegyverID[playerid] = 25; }
				case 8: { ExportFegyverID[playerid] = 28; }
			}
			
			if(!FegyverKaliberhezMinSzint(playerid, ExportFegyverID[playerid])) return 0;
			
			PlayerText[playerid] = "Fegyver típus sikeresen kiválasztva!\n\nAdd meg, hogy hány darab lõszerre lenne szükséged!"			
			ShowPlayerDialog(playerid, DIALOG_EXPORTGUN_TOLTENYSZAM, DIALOG_STYLE_INPUT, "Export fegyver vásárlás", PlayerText[playerid], "Vásárlás", "Mégse");
		}
	}
	else if(dialogid == DIALOG_EXPORTGUN_TOLTENYSZAM)
	{
		if(response)
		{
			new 
				loszer = strval(inputtext),
				MaxLoszer = 10000,
				FegyverID = ExportFegyverID[playerid],
				ToltenyAr = ExportFegyverAr(FegyverID)
			;
			
			if(loszer > MaxLoszer OR loszer < 1)
			{
				PlayerTextFormat(playerid, "Maximum %sdb lõszert vehetsz egyszerre!", PenzTordeles(MaxLoszer));
				MsgDialog(playerid, "Hiba!", PlayerText[playerid], "Bezár");
				return 1;
			}
			
			new szorzas = loszer * ToltenyAr;
			
			if(GetMoney(playerid) < szorzas)
			{
				PlayerTextFormat(playerid, "Nincs elég pénzed! %ddb lõszer $%s! ($%d/töltény)", loszer, PenzTordeles(szorzas), ToltenyAr);
				MsgDialog(playerid, "Hiba!", PlayerText[playerid], "Bezár");
				return 1;
			}
			
			PlayerTextFormat(playerid, "Sikeresen megvásároltad a kívánt fegyvert!\n\
			\nFegyver ID: %d\nLõszer: %d\nTöltény Ár/db: $%d/db\nFizetett összeg: $%s", FegyverID, loszer, ToltenyAr, PenzTordeles(szorzas));
			MsgDialog(playerid, "Export fegyver vásárlás", PlayerText[playerid], "Bezár");
			
			GiveWeapon(playerid, FegyverID, loszer);
			GiveMoney(playerid, -szorzas);
		}
	}
	else if(dialogid == DIALOG_DROGNPCVASARLAS)
	{
		if(response)
		{
			ExportDrogTipus[playerid] = (listitem + 1);
			PlayerText[playerid] = "Drog típus sikeresen kiválasztva!\n\nAdd meg, hogy mekkora adagra (gramm) lenne szükséged!"			
			ShowPlayerDialog(playerid, DIALOG_DIALOG_DROGNPC_MENNYISEG, DIALOG_STYLE_INPUT, "Export drog vásárlás", PlayerText[playerid], "Vásárlás", "Mégse");
		}
	}
	else if(dialogid == DIALOG_DIALOG_DROGNPC_MENNYISEG)
	{
		if(response)
		{
			new GrammAr, gramm = strval(inputtext), DrogType = ExportDrogTipus[playerid];
			
			if(DrogType == 1) { GrammAr = 40; } // Kokain
			else if(DrogType == 2) { GrammAr = 35; } // Heroin
			else if(DrogType == 3) { GrammAr = 30; } // Ecstasy
			else if(DrogType == 4) { GrammAr = 15; } // Marihuana
			
			new szorzas = gramm * GrammAr;
			
			new mibemennyiseg[4];
			if(DrogType == 1 OR DrogType == 2 OR DrogType == 4) { mibemennyiseg = "g"; }
			else { mibemennyiseg = "db"; }
			
			if(gramm > gramm OR gramm < 1)
			{
				PlayerTextFormat(playerid, "Maximum %s%s lõszert vehetsz egyszerre!", PenzTordeles(gramm), mibemennyiseg);
				MsgDialog(playerid, "Hiba!", PlayerText[playerid], "Bezár");
				return 1;
			}
			
			if(GetMoney(playerid) < szorzas)
			{
				PlayerTextFormat(playerid, "Nincs elég pénzed! %d%s $%d! ($%d/%s)", gramm, mibemennyiseg, szorzas, GrammAr, mibemennyiseg);
				MsgDialog(playerid, "Hiba!", PlayerText[playerid], "Bezár");
				return 1;
			}
			
			PlayerTextFormat(playerid, "Sikeresen megvásároltad a kívánt drogot!\n\
			\nMennyiség: %d%s\nMennyiség Ár/%s: $%d/%s\nFizetett összeg: $%d", gramm, mibemennyiseg, mibemennyiseg, GrammAr, mibemennyiseg, szorzas);
			MsgDialog(playerid, "Export drog vásárlás", PlayerText[playerid], "Bezár");
			
			if(DrogType == 1) { PlayerInfo[playerid][pKokain] = gramm; }
			else if(DrogType == 2) { PlayerInfo[playerid][pHeroin] = gramm; }
			else if(DrogType == 3) { PlayerInfo[playerid][pEcstasy] = gramm; }
			else if(DrogType == 4) { PlayerInfo[playerid][pMarihuana] = gramm; }
			
			GiveMoney(playerid, -szorzas);
		}
	}
	/* ################################################################################################################# */
	else if(dialogid == DIALOG_RICARDO_VILLA)
	{
		if(response)
		{
			new Float:sebesseg = 1.0;
			switch(listitem)
			{
				case 0: // fõkapu nyitása
				{ 
					MoveObject(RicardoVilla, 267.92029, -1330.71484, 49.13200, sebesseg);
					SetTimerEx("RicardoVillaKapuZar", (30 * 1000), false, "f", sebesseg);
					PlayerPlaySound(playerid, 1035, 0.0, 0.0, 0.0);
					iMsg(playerid, "A Villa Fõkapuja kinyitva!");
				}
				case 1: // fõkapu zárása
				{ 
					RicardoVillaKapuZar(sebesseg);
					PlayerPlaySound(playerid, 1035, 0.0, 0.0, 0.0);
					iMsg(playerid, "A Villa Fõkapuja bezárva!");
				}
				case 2: // GPS megjelölés
				{
					SetPlayerCheckpoint(playerid, 240.8380, -1379.9518, 54.5439, 3.0);
					iMsg(playerid, "Sikeres megjelölés!");
				}
				case 3: // tele a villába
				{
					if(GetPlayerState(playerid) == 2)
					{
						new tmpcar = GetPlayerVehicleID(playerid);
						SetVehiclePos(tmpcar, 259.2269, -1357.9611, (52.8696 + 1.5));
						SetVehicleZAngle(tmpcar, 327.8622);
					}
					else
					{
						SetPlayerPos(playerid, 240.8380, -1379.9518, 54.5439);
						SetPlayerFacingAngle(playerid, 304.0534);
					}
					ResetVW(playerid);
				}
			}
		}
	}
	else if(dialogid == DIALOG_NULLAZ)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: // drog-zseb
				{
					SendFormatMessageToAll(COLOR_LIGHTRED, "MySQL: %s nullázta a playerek illegális anyag készletét!(Lehet, hogy Lagg lesz, ne floodolj!!!)", PlayerName(playerid));
					PlayerForeach(all){ PlayerInfo[all][pMuanyag] = 0; PlayerInfo[all][pMats] = 0; PlayerInfo[all][pMarihuana] = 0; PlayerInfo[all][pHeroin] = 0; PlayerInfo[all][pKokain] = 0; PlayerInfo[all][pCserje] = 0; PlayerInfo[all][pCannabis] = 0; PlayerInfo[all][pMak] = 0; }
					mysql_query("UPDATE playerek SET Cuccok='0,0,0,0,0,0,0,0'");
					return 1;
				}
				case 1: // drog-ház
				{
					SendFormatMessageToAll(COLOR_LIGHTRED, "MySQL: %s nullázta a házak drog készletét!(Lehet, hogy Lagg lesz, ne floodolj!!!)", PlayerName(playerid));
					for(new all=0; all < sizeof(HouseInfo); all++ )
					{  
						if(HouseInfo[all][Van] == 0) continue;
						HouseInfo[all][hKokain] = 0; 
						HouseInfo[all][hHeroin] = 0; 
						HouseInfo[all][hMarihuana] = 0; 
						HouseInfo[all][hMati] = 0; 
					}
					mysql_query("UPDATE hazak SET Kokain='0',Heroin='0',Marihuana='0',Material='0'");
					return 1;
				}
				case 2: // drog-frakciók
				{
					SendFormatMessageToAll(COLOR_LIGHTRED, "MySQL: %s nullázta a frakciók drog készletét!(Lehet, hogy Lagg lesz, ne floodolj!!!)", PlayerName(playerid));
					for(new all=1; all < MAX_FRAKCIO;all++)
					{
						FrakcioInfo[all][fMati] = 0; 
						FrakcioInfo[all][fKokain] = 0; 
						FrakcioInfo[all][fHeroin] = 0; 
						FrakcioInfo[all][fMarihuana] = 0; 
					}
					mysql_query("UPDATE frakciok SET Cuccok='0,0,0,0,0,0'");
					return 1;
				}
				case 3: // játszott órák
				{
					SendFormatMessageToAll(COLOR_LIGHTRED, "MySQL: %s nullázta a playerek játszott óráját!(Lehet, hogy Lagg lesz, ne floodolj!!!)", PlayerName(playerid));
					PlayerForeach(all)
					{ 
						SetPlayerLevel(all, 1);
					}
					mysql_query("UPDATE playerek SET ConnectedTime = '0', Szint = '1' ");
					return 1;
				}
				case 4: // játékosok
                {
                    SendFormatMessageToAll(COLOR_LIGHTRED, "MySQL: %s nullázta az inaktív játékosokat!(Lehet, hogy Lagg lesz, ne floodolj!!!)", PlayerName(playerid));
                }
				case 5: // pénz
				{
					SendFormatMessageToAll(COLOR_LIGHTRED, "MySQL: %s nullázta a playerek pénzét!(Lehet, hogy Lagg lesz, ne floodolj!!!)", PlayerName(playerid));
					PlayerForeach(all)
					{
						PlayerInfo[all][pCash] = 0; 
						PlayerInfo[all][pAccount] = 0; 					
					}
					mysql_query("UPDATE playerek SET Bank='0', Money='0' ");
					return 1;
				}
				case 6: // leader jog
				{
					SendFormatMessageToAll(COLOR_LIGHTRED, "MySQL: %s nullázta a playerek Leaderjét!(Lehet, hogy Lagg lesz, ne floodolj!!!)", PlayerName(playerid));
					PlayerForeach(all){ if(PlayerInfo[all][pLeader] != 0) PlayerInfo[all][pLeader] = 0; PlayerInfo[all][pMember] = 0; PlayerInfo[all][pRank] = 0;}
					mysql_query("UPDATE playerek SET Leader='0',Member='0',Rank='0'");
					return 1;
				}
				case 7: // hitman jog
				{
					SendFormatMessageToAll(COLOR_LIGHTRED, "MySQL: %s nullázta a playerek Hitman jogát(Lehet, hogy Lagg lesz, ne floodolj!!!)", PlayerName(playerid));
					PlayerForeach(all){ PlayerInfo[all][pHitman] = 0; }
					mysql_query("UPDATE playerek SET Hitman='0'");
					return 1;
				}
				case 8: // adminszint
				{
					SendFormatMessageToAll(COLOR_LIGHTRED, "MySQL: %s nullázta a playerek Adminszintjét!(Lehet, hogy Lagg lesz, ne floodolj!!!)", PlayerName(playerid));
					PlayerForeach(all){ PlayerInfo[all][pAdmin] = 0; }
					mysql_query("UPDATE playerek SET Admin='0'");
					return 1;
				}
				case 9: // ban
				{
					SendFormatMessageToAll(COLOR_LIGHTRED, "MySQL: %s nullázta a bans táblát!(Lehet, hogy Lagg lesz, ne floodolj!!!)", PlayerName(playerid));
					mysql_query("TRUNCATE TABLE bans");
					return 1;
				}
				case 10: // biznisz tulajok
				{
					SendFormatMessageToAll(COLOR_LIGHTRED, "MySQL: %s nullázta a bizniszek tulaját!(Lehet, hogy Lagg lesz, ne floodolj!!!)", PlayerName(playerid));
					mysql_query("UPDATE playerek SET Bizz='-1'");
					mysql_query("UPDATE bizek SET Eladva='0',Tulaj='No-one',Extortion='No-one''");			
					return 1;
				}
				case 11: // vs kocsik
				{
					SendFormatMessageToAll(COLOR_LIGHTRED, "MySQL: %s Törölte az összes v-s jármûvet!!(Lehet, hogy Lagg lesz, ne floodolj!!!)", PlayerName(playerid));
					PlayerForeach(all){ PlayerInfo[all][pPcarkey] = NINCS; PlayerInfo[all][pPcarkey2] = NINCS; }
					mysql_query("TRUNCATE TABLE kocsik");
					mysql_query("UPDATE playerek SET Kocsikulcs='-1'");
					return 1;
				}
			}
		}
	}
	else if(dialogid == DIALOG_BizTypes)
	{
		if(!response)
		{ 
			DeletePVar(playerid, "BBuyID"); 
			return 1; 
		}
		
		new type;
		switch(listitem)
		{
			case 0: type = strval(ENBOLT); 
			case 1: type = strval(RUHA);
			case 2: type = strval(ETTEREM);
			case 3: type = strval(GYETTEREM);
			case 4: type = strval(KONDI);
			case 5: type = strval(SEXBOLT);
			case 6: type = strval(DISCO);
			case 7: type = strval(BAR);
			case 8: type = strval(SZTRIPTIZ);
			case 9: type = strval(FODRASZ);
			case 10: type = strval(TETOVALO);
			case 11: type = strval(LOTTOZO);
			case 12: type = strval(STUDIO);
		}
		
		new diastr[2048], mlt = 0;
		format(diastr, sizeof(diastr), "Ár\tMinõség");
		for(new i = 0; i < sizeof(BusinessInfos); i++) 
		{
			if(type == strval(BusinessInfos[i][2]))
			{
				format(diastr, sizeof(diastr),"%s\n $%s\t%s", diastr, PenzTordeles(strval(BusinessInfos[i][3])), BusinessInfos[i][0]);
				NBArlt[playerid][mlt] = strval(BusinessInfos[i][3]);
				NBIdlt[playerid][mlt] = i;
				SetPVarInt(playerid,"BuyBizType",type);
				mlt ++;
			}
		}
		ShowPlayerDialog(playerid, DIALOG_BizTypePrice, DIALOG_STYLE_TABLIST_HEADERS, "Milyen belteret (interiort) szeretnél az üzlethelységnek?", diastr, "Választ", "Mégse");
		return 1;
	}
	else if(dialogid == DIALOG_BizTypePrice)
	{
		if(!response) return 1;
		
		new bid = GetPVarInt(playerid,"BBuyID");
		new bar = NBArlt[playerid][listitem];
		new osszar = bInfo[bid][bAr] + bar;
		if(GetMoney(playerid) < osszar)
		{
			MsgFormat(playerid,"Nincs nálad elegendõ pénz! Szükséges: $%s", PenzTordeles(osszar));
			return 1;
		}
		SetPVarInt(playerid, "BBuyPr", osszar);
		SetPVarInt(playerid, "BBuyLT", NBIdlt[playerid][listitem]);
		
		ShowPlayerDialog(playerid, DIALOG_BizName,DIALOG_STYLE_INPUT, "Mi legyen az üzlethelység neve?","\t\t\t\t\t\t\t\n", "Megad", "Vissza");
		return 1;
	}
	else if(dialogid == DIALOG_BizName)
	{
		if(!response)
		{
			DeletePVar(playerid, "BBuyID");
			DeletePVar(playerid, "BBuyLT");
			return 1;
		}
		
		new bid = GetPVarInt(playerid,"BBuyID"), blt = GetPVarInt(playerid,"BBuyLT");
		
		if(strlen(inputtext) <= 1 || strlen(inputtext) > MAX_BIZNAME)
		{
			MsgFormat(playerid, "Minimum 1, maximum %D karakter lehet!", MAX_BIZNAME);
			return 1;
		}
		
		format(bInfo[bid][bNev], 64, "%s", inputtext);
		format(bInfo[bid][bTulaj], MAX_PLAYER_NAME, "%s", PlayerName(playerid, true));
		bInfo[bid][bExPos][0] = floatstr(BusinessInfos[blt][4]);
		bInfo[bid][bExPos][1] = floatstr(BusinessInfos[blt][5]);
		bInfo[bid][bExPos][2] = floatstr(BusinessInfos[blt][6]);
		bInfo[bid][bExPosVW] = bid;
		bInfo[bid][bExPosInt] = strval(BusinessInfos[blt][7]);
		bInfo[bid][bLvl] = strval(BusinessInfos[blt][1]);
		bInfo[bid][bType] = GetPVarInt(playerid,"BuyBizType");
		OnBizniszPickupUpdate(bid);
		GiveMoney(playerid, -GetPVarInt(playerid,"BBuyPr"));
		
		DeletePVar(playerid, "BBuyPr");
		DeletePVar(playerid, "BBuyLT");
		DeletePVar(playerid, "BBuyID");
		DeletePVar(playerid, "BuyBizType");
		
		BizniszSQLUpdate(bid);
		Msg(playerid, "Sikeresen megvetted az üzletet.");
		return 1;
	}
	else if(dialogid == DIALOG_KRESZ && Kresz[playerid] > 0)
	{
		if(response)
		{
			new valasz = KreszKerdesek[Kresz[playerid]-1][2][0];
			if(listitem != valasz)
			{
				Msg(playerid, "Rossz válasz! Megbuktál!");
				Kresz[playerid] = 0;
			}
			else
			{
				if(Kresz[playerid] == 10)
				{
					Msg(playerid, "Sikeresen kitöltötted a kresz vizsgát! Megkaptad a kresz engedélyt!");
					PlayerInfo[playerid][pKresz] = 1;
				}
				else Kresz[playerid]++, ShowPlayerDialog(playerid, DIALOG_KRESZ, DIALOG_STYLE_LIST, KreszKerdesek[Kresz[playerid]-1][0], KreszKerdesek[Kresz[playerid]-1][1], "Tovább", "Mégse");
			}
		}
	}
	else if(dialogid == DIALOG_DIVATBOLT_SZEMUVEG && response)
	{
		new ara = DivatBolt_SZEMUVEG[listitem][2][0];
		if(GetMoney( playerid ) < ara) return Msg(playerid,"Nincs elég pénzed!");
		new objectid = DivatBolt_SZEMUVEG[listitem][3][0];
		new slotid = DivatBolt_SZEMUVEG[listitem][4][0];
		SetPlayerAttachedObject(playerid,slotid,objectid,2);
		EditAttachedObject(playerid,slotid);
		Msg(playerid, "Mozgasd a cuccot oda ahova szeretnéd, és ha végeztél, nyomj rá a mentés(FLOPI JEL) gombra");
		Msg(playerid, "Megjegyzés: ha SPACE-t nyomod (SPRINT GOMB) akkor tudod forgatni a kamerádat :)");
		return 1;
	}
	else if(dialogid == DIALOG_DIVATBOLT_FEJKENDO && response)
	{
		new ara = DivatBolt_FEJKENDO[listitem][2][0];
		if(GetMoney( playerid ) < ara) return Msg(playerid,"Nincs elég pénzed!");
		new objectid = DivatBolt_FEJKENDO[listitem][3][0];
		new slotid = DivatBolt_FEJKENDO[listitem][4][0];
		SetPlayerAttachedObject(playerid,slotid,objectid,2);
		EditAttachedObject(playerid,slotid);
		Msg(playerid, "Mozgasd a cuccot oda ahova szeretnéd, és ha végeztél, nyomj rá a mentés(FLOPI JEL) gombra");
		Msg(playerid, "Megjegyzés: ha SPACE-t nyomod (SPRINT GOMB) akkor tudod forgatni a kamerádat :)");
		return 1;
	}
	else if(dialogid == DIALOG_DIVATBOLT_SVAJCISAPKA && response)
	{
		new ara = DivatBolt_SVAJCISAPKA[listitem][2][0];
		if(GetMoney( playerid ) < ara) return Msg(playerid,"Nincs elég pénzed!");
		new objectid = DivatBolt_SVAJCISAPKA[listitem][3][0];
		new slotid = DivatBolt_SVAJCISAPKA[listitem][4][0];
		SetPlayerAttachedObject(playerid,slotid,objectid,2);
		EditAttachedObject(playerid,slotid);
		Msg(playerid, "Mozgasd a cuccot oda ahova szeretnéd, és ha végeztél, nyomj rá a mentés(FLOPI JEL) gombra");
		Msg(playerid, "Megjegyzés: ha SPACE-t nyomod (SPRINT GOMB) akkor tudod forgatni a kamerádat :)");
		return 1;
	}
	else if(dialogid == DIALOG_DIVATBOLT_BASEBALLSAPKA && response)
	{
		new ara = DivatBolt_BASEBALLSAPKA[listitem][2][0];
		if(GetMoney( playerid ) < ara) return Msg(playerid,"Nincs elég pénzed!");
		new objectid = DivatBolt_BASEBALLSAPKA[listitem][3][0];
		new slotid = DivatBolt_BASEBALLSAPKA[listitem][4][0];
		SetPlayerAttachedObject(playerid,slotid,objectid,2);
		EditAttachedObject(playerid, slotid);
		Msg(playerid, "Mozgasd a cuccot oda ahova szeretnéd, és ha végeztél, nyomj rá a mentés(FLOPI JEL) gombra");
		Msg(playerid, "Megjegyzés: ha SPACE-t nyomod (SPRINT GOMB) akkor tudod forgatni a kamerádat :)");
		return 1;
	}
	else if(dialogid == DIALOG_DIVATBOLT_KALAP && response)
	{
		new ara = DivatBolt_KALAP[listitem][2][0];
		if(GetMoney( playerid ) < ara) return Msg(playerid,"Nincs elég pénzed!");
		new objectid = DivatBolt_KALAP[listitem][3][0];
		new slotid = DivatBolt_KALAP[listitem][4][0];
		SetPlayerAttachedObject(playerid,slotid,objectid,2);
		EditAttachedObject(playerid,slotid);
		Msg(playerid, "Mozgasd a cuccot oda ahova szeretnéd, és ha végeztél, nyomj rá a mentés(FLOPI JEL) gombra");
		Msg(playerid, "Megjegyzés: ha SPACE-t nyomod (SPRINT GOMB) akkor tudod forgatni a kamerádat :)");
		return 1;
	}
	else if(dialogid == DIALOG_DIVATBOLT_SAPKA && response)
	{
		new ara = DivatBolt_SAPKA[listitem][2][0];
		if(GetMoney( playerid ) < ara) return Msg(playerid,"Nincs elég pénzed!");
		new objectid = DivatBolt_SAPKA[listitem][3][0];
		new slotid = DivatBolt_SAPKA[listitem][4][0];
		SetPlayerAttachedObject(playerid,slotid,objectid,2);
		EditAttachedObject(playerid,slotid);
		Msg(playerid, "Mozgasd a cuccot oda ahova szeretnéd, és ha végeztél, nyomj rá a mentés(FLOPI JEL) gombra");
		Msg(playerid, "Megjegyzés: ha SPACE-t nyomod (SPRINT GOMB) akkor tudod forgatni a kamerádat :)");
		return 1;
	}
	else if(dialogid == DIALOG_DIVATBOLT_KARORA && response)
	{
		new ara = DivatBolt_KARORA[listitem][2][0];
		if(GetMoney( playerid ) < ara) return Msg(playerid,"Nincs elég pénzed!");
		new objectid = DivatBolt_KARORA[listitem][3][0];
		new slotid = DivatBolt_KARORA[listitem][4][0];
		SetPlayerAttachedObject(playerid,slotid,objectid,13);
		EditAttachedObject(playerid,slotid);
		Msg(playerid, "Mozgasd a cuccot oda ahova szeretnéd, és ha végeztél, nyomj rá a mentés(FLOPI JEL) gombra");
		Msg(playerid, "Megjegyzés: ha SPACE-t nyomod (SPRINT GOMB) akkor tudod forgatni a kamerádat :)");
		return 1;
	}
	else if(dialogid == DIALOG_DIVATBOLT_EDIT_2)
	{
		if(response)
		{
			if(listitem == 0)
			{
				if(IsPlayerAttachedObjectSlotUsed(playerid,MitModosit[playerid]))
				{
					EditAttachedObject(playerid, MitModosit[playerid]);
					Msg(playerid, "Mozgasd a cuccot oda ahova szeretnéd, és ha végeztél, nyomj rá a mentés(FLOPI JEL) gombra");
					Msg(playerid, "Megjegyzés: ha SPACE-t nyomod (SPRINT GOMB) akkor tudod forgatni a kamerádat :)");
				}
				else
					Msg(playerid,"Nincs mit módosítani!");
			}
			else if(listitem == 1)
			{
				if(MitModosit[playerid] == SLOT_SAPKA)
					PlayerUpdate(playerid, "Divat_Sapka = '0,0.000,0.000,0.000,0.000,0.000,0.000,0.000,0.000,0.000,0' ", 1);
				else if(MitModosit[playerid] == SLOT_SZEMUVEG)
					PlayerUpdate(playerid, "Divat_Szemuveg = '0,0.000,0.000,0.000,0.000,0.000,0.000,0.000,0.000,0.000,0' ", 1);
				else if(MitModosit[playerid] == SLOT_KARORA)
					PlayerUpdate(playerid, "Divat_Karora = '0,0.000,0.000,0.000,0.000,0.000,0.000,0.000,0.000,0.000,0' ", 1);
					
				RemovePlayerAttachedObject(playerid, MitModosit[playerid]);
				MitModosit[playerid] = NINCS;
			}
		}
		else
			MitModosit[playerid] = NINCS;
	}
	else if(dialogid == DIALOG_DIVATBOLT_EDIT)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: MitModosit[playerid] = SLOT_SAPKA;
				case 1: MitModosit[playerid] = SLOT_SZEMUVEG;
				case 2: MitModosit[playerid] = SLOT_KARORA;
			}
			ShowPlayerDialog(playerid, DIALOG_DIVATBOLT_EDIT_2, DIALOG_STYLE_LIST, "Mit szeretnél?", "Módosítás\nEltávolítás", "Ok", "Mégse");
		}
		else
			MitModosit[playerid] = NINCS;
	}
	else if(dialogid == DIALOG_DIVATBOLT_KATEGORIAK)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: // Új létrehozása
				{
					if(!IsAtClothShop(playerid))
					{
						ShowPlayerDialog(playerid, DIALOG_NINCS, DIALOG_STYLE_LIST, "Hiba!", "Nem vagy ruhaboltban!", "Bezár", "");
						return 1;
					}
					ShowPlayerDialog(playerid, DIALOG_DIVATBOLT_VALASZTAS, DIALOG_STYLE_LIST, "Új kiegészítõ", "Szemüvegek\nFejkendõk\nSvájci Sapkák\nBaseball Sapkák\nKalapok\nSapkák\nKarórák", "Tovább", "Mégse");
				}
				case 1: // Szerkeszt
				{
					ShowPlayerDialog(playerid, DIALOG_DIVATBOLT_EDIT, DIALOG_STYLE_LIST, "Kiegészítõk szerkesztése", "Sapka/Kalap\nSzemüveg\nKaróra", "Módosítás", "Mégse");
				}
			}
		}
	}
	else if(dialogid == DIALOG_DIVATBOLT_VALASZTAS)
	{
		if(response)
		{
			new cuccid = 0;
			switch(listitem)
			{
				case 0: //Szemüvegek
				{
					for(cuccid=0; cuccid < sizeof(DivatBolt_SZEMUVEG); cuccid++)
					{
						if(cuccid == 0)
							Format(string, "%s ($%d)", DivatBolt_SZEMUVEG[0][1], DivatBolt_SZEMUVEG[0][2][0]);
						else
							Format(string, "%s\n%s ($%d)", string, DivatBolt_SZEMUVEG[cuccid][1],DivatBolt_SZEMUVEG[cuccid][2][0]);
					}
					ShowPlayerDialog(playerid, DIALOG_DIVATBOLT_SZEMUVEG, DIALOG_STYLE_LIST, "Lista", string,"Megvesz", "Vissza");
				}
				case 1://Fejkendõk
				{
					for(cuccid=0; cuccid < sizeof(DivatBolt_FEJKENDO); cuccid++)
					{
						if(cuccid == 0)
							Format(string, "%s ($%d)", DivatBolt_FEJKENDO[0][1], DivatBolt_FEJKENDO[0][2][0]);
						else
							Format(string, "%s\n%s ($%d)", string, DivatBolt_FEJKENDO[cuccid][1],DivatBolt_FEJKENDO[cuccid][2][0]);
					}
					ShowPlayerDialog(playerid, DIALOG_DIVATBOLT_FEJKENDO, DIALOG_STYLE_LIST, "Lista", string,"Megvesz", "Vissza");
				}
				case 2://Svájci Sapkák
				{
					for(cuccid=0; cuccid < sizeof(DivatBolt_SVAJCISAPKA); cuccid++)
					{
						if(cuccid == 0)
							Format(string, "%s ($%d)", DivatBolt_SVAJCISAPKA[0][1], DivatBolt_SVAJCISAPKA[0][2][0]);
						else
							Format(string, "%s\n%s ($%d)", string, DivatBolt_SVAJCISAPKA[cuccid][1],DivatBolt_SVAJCISAPKA[cuccid][2][0]);
					}
					ShowPlayerDialog(playerid, DIALOG_DIVATBOLT_SVAJCISAPKA, DIALOG_STYLE_LIST, "Lista", string,"Megvesz", "Vissza");
				}
				case 3://Baseball sapkák
				{
					for(cuccid=0; cuccid < sizeof(DivatBolt_BASEBALLSAPKA); cuccid++)
					{
						if(cuccid == 0)
							Format(string, "%s ($%d)", DivatBolt_BASEBALLSAPKA[0][1], DivatBolt_BASEBALLSAPKA[0][2][0]);
						else
							Format(string, "%s\n%s ($%d)", string, DivatBolt_BASEBALLSAPKA[cuccid][1],DivatBolt_BASEBALLSAPKA[cuccid][2][0]);
					}
					ShowPlayerDialog(playerid, DIALOG_DIVATBOLT_BASEBALLSAPKA, DIALOG_STYLE_LIST, "Lista", string,"Megvesz", "Vissza");
				}
				case 4://Kalapok
				{
					for(cuccid=0; cuccid < sizeof(DivatBolt_KALAP); cuccid++)
					{
						if(cuccid == 0)
							Format(string, "%s ($%d)", DivatBolt_KALAP[0][1], DivatBolt_KALAP[0][2][0]);
						else
							Format(string, "%s\n%s ($%d)", string, DivatBolt_KALAP[cuccid][1],DivatBolt_KALAP[cuccid][2][0]);
					}
					ShowPlayerDialog(playerid, DIALOG_DIVATBOLT_KALAP, DIALOG_STYLE_LIST, "Lista", string,"Megvesz", "Vissza");
				}
				case 5://Sapkák
				{
					for(cuccid=0; cuccid < sizeof(DivatBolt_SAPKA); cuccid++)
					{
						if(cuccid == 0)
							Format(string, "%s ($%d)", DivatBolt_SAPKA[0][1], DivatBolt_SAPKA[0][2][0]);
						else
							Format(string, "%s\n%s ($%d)", string, DivatBolt_SAPKA[cuccid][1],DivatBolt_SAPKA[cuccid][2][0]);
					}
					ShowPlayerDialog(playerid, DIALOG_DIVATBOLT_SAPKA, DIALOG_STYLE_LIST, "Lista", string,"Megvesz", "Vissza");
				}
				case 6://Karórák
				{
					for(cuccid=0; cuccid < sizeof(DivatBolt_KARORA); cuccid++)
					{
						if(cuccid == 0)
							Format(string, "%s ($%d)", DivatBolt_KARORA[0][1], DivatBolt_KARORA[0][2][0]);
						else
							Format(string, "%s\n%s ($%d)", string, DivatBolt_KARORA[cuccid][1],DivatBolt_KARORA[cuccid][2][0]);
					}
					ShowPlayerDialog(playerid, DIALOG_DIVATBOLT_KARORA, DIALOG_STYLE_LIST, "Lista", string,"Megvesz", "Vissza");
				}
			}
			return 1;
		}
		return 1;
	}
	else if(dialogid == DIALOG_PRIVATUZENET)
	{
		if(response)
		{
			if(strlen(inputtext) > 1)
			{
				new sendername[128];
				new sendername2[MAX_PLAYER_NAME];
				
				new clickedplayerid = KinekKuldUzit[playerid];
				
				GetPlayerName(clickedplayerid, sendername, sizeof(sendername));
				GetPlayerName(playerid, sendername2, sizeof(sendername2));
				
				//format(string, sizeof(string), "[%d]%s üzeni: %s", playerid, sendername, (inputtext));
				Format(string, "[%d]%s üzeni: %s", playerid, PlayerName(playerid), (inputtext));
				SendClientMessage(clickedplayerid, COLOR_LIGHTBLUE, string);
				
				new szoveg[120];
				Format(sendername, "Üzeneted neki: %s", sendername);
				Format(szoveg, "%s\nÜzenet szövege: %s", sendername, (inputtext));
				ShowPlayerDialog(playerid, DIALOG_NINCS, DIALOG_STYLE_MSGBOX, "Üzenet elküldve!", szoveg, "Rendben", "");
			}
			else
			{
				MsgDialog(playerid, "{FF0000}Hiba!", "{FFFFFF}Ne hagyd üresen!", "Bezár");
				return 1;
			}
		}
		return 1;
	}
	else if(dialogid == DIALOG_AJELSZO)
	{
		if(response)
		{
			if(strlen(inputtext) < 3)
			{
				ShowPlayerDialog(playerid, DIALOG_AJELSZO, DIALOG_STYLE_INPUT, "Admin kód", "Azért írj be valamit!", "Beír", "");
				return 0;
			}	
				
			new HashedPW[128];
			SHA256_PassHash(inputtext, SALT_ADMINPW, HashedPW, sizeof(HashedPW));
			
			if(egyezik(adminjelszo, HashedPW))
			{
				PlayerInfo[playerid][pAdmin] = AdminEllenorzes[playerid][1];
				AdminEllenorzes[playerid][0] = 0;
				AdminJelszoCheckelve[playerid] = true;
				
				new adminszint;
				if(IsTulaj(playerid))
				{
					adminszint = (MAX_ADMIN_LEVEL + 2);
					PlayerInfo[playerid][pAdmin] = adminszint;
				}
				else if(IsSegedFejleszto(playerid))
				{
					adminszint = (MAX_ADMIN_LEVEL + 1);
					PlayerInfo[playerid][pAdmin] = adminszint;
				}
				
				if(PlayerInfo[playerid][pAdmin] > MAX_ADMIN_LEVEL && !IsRicardo(playerid) && !IsTulaj(playerid) && !IsFejleszto(playerid))
				{
					AdminElvesz(playerid);
					MsgFormat(playerid, "Neked nem lehet %s AdminSzinted mivel nem vagy a módban!", AdminSzint(playerid));
					BlockPlayerIP(playerid, 30);
					return 0;
				}
				
				PlayerTextFormat(playerid, "'%s' AdminSzint megadva! [%d]", AdminSzint(playerid), adminszint);
				Msg(playerid, PlayerText[playerid], COLOR_ADMIN);
			}
			else
			{
				ElrontottAjelszo[playerid] ++;
				
				if(ElrontottAjelszo[playerid] < 3)
				{
					ShowPlayerDialog(playerid, DIALOG_AJELSZO, DIALOG_STYLE_INPUT, "Admin kód", "Elrontottad az AdminJelszót!\nKérlek írd be újra!", "Beír", "Mégse");
				}
				else
				{
					AdminEllenorzes[playerid][0] = 1;
					AdminElvesz(playerid);
					Msg(playerid, "Elrontottad az admin jelszót többször ezért ki lettél tiltva 15 percre!");
					BlockPlayerIP(playerid, 15);
				}
			}
		}
		return 1;
	}
	else if(dialogid == DIALOG_NINCS)
	{
	    if(AFKDialogShowing[playerid] != 0)
	    {
	        if(response)
	        {
		        KillTimer(AFKTimer[playerid]);
		        AFKDialogShowing[playerid] = 0;
		        AFKIdo[playerid] = 0;
				GetPlayerPos(playerid,AFKPos[playerid][0],AFKPos[playerid][1],AFKPos[playerid][2]);
				Msg(playerid, "Rendben!");
				return 1;
			}
			else
			{
			    KillTimer(AFKTimer[playerid]);
		        AFKDialogShowing[playerid] = 0;
		        AFKIdo[playerid] = 0;
				GetPlayerPos(playerid,AFKPos[playerid][0],AFKPos[playerid][1],AFKPos[playerid][2]);
				Msg(playerid, "Rendben!");
				return 1;
			}
	    }
		if(IsPlayerInRangeOfPoint(playerid, 3.0,2769.6865,-1602.6698,10.9219))
		{
			if(BetoroCucc[playerid] >= RABLASCUCC)
			{
				GiveMoney(playerid,20000);
				BetoroCucc[playerid] = 0;
				Msg(playerid, "Megkaptad a 20.000 Ft-t!");
				BetorPos[playerid][0] = 0.0;
				BetorPos[playerid][1] = 0.0;
				BetorPos[playerid][2] = 0.0;
				Kuldetesben[playerid] = 0;
			}
			else if(response == 1 && Kuldetesben[playerid] == 0)
			{ 
				SendClientMessage(playerid,COLOR_WHITE, "Oké fater, menj, törj be egy házba és hozd amit tudsz!");
				SendClientMessage(playerid,COLOR_WHITE, "Ha lebuksz, te viszed a balhét! Ha kész vagy, hozd vissza és én adom a lóvét!");
				Kuldetesben[playerid] = 1;
			}
			else
				return 1;
		}
		else
			return 1;
	}
	else if(dialogid == DIALOG_JOGSIVIZSGA)
	{
	    if(response)
	    {
			new 
				JarmuModel = -1,
				szin1 = Rand(0, 255),
				JogsiAr = 9999999,
				szin2 = szin1
			;
		
			switch(listitem)
			{
			    case 0:
				{
					if(PlayerInfo[playerid][pCarLic] > 0) return Msg(playerid, "Neked már van jogosítványod személygépjármûre!");
				
					jatekosMilyenJogsitCsinal[playerid] = OKTATAS_AUTO;
					JarmuModel = 507;
					JogsiAr = 1250;
				}
			    case 1:
				{
					if(PlayerInfo[playerid][pMotorJogsi] > 0) return Msg(playerid, "Neked már van jogosítványod motorra!");
					
					jatekosMilyenJogsitCsinal[playerid] = OKTATAS_MOTOR;
					JarmuModel = 521;
					JogsiAr = 800;
				}
			}
			
			if(GetMoney(playerid) < JogsiAr)
			{
				PlayerTextFormat(playerid, "Ez a jogosítvány $%s-ba kerül amelyre neked nincs pénzed!", PenzTordeles(JogsiAr));
				HibaDialog(playerid, PlayerText[playerid]);
				return 1;
			}

			if(IsValidCar(JarmuModel)) 
			{
				SpawnPozicio[playerid] = random(sizeof(VizsgaJarmuSpawn));
				JogsiJarmuID[playerid] = UjKocsi(JarmuModel, VizsgaJarmuSpawn[SpawnPozicio[playerid]][0], VizsgaJarmuSpawn[SpawnPozicio[playerid]][1], VizsgaJarmuSpawn[SpawnPozicio[playerid]][2], VizsgaJarmuSpawn[SpawnPozicio[playerid]][3], szin1, szin2);
				Msg(playerid, "Menj ki a vizsgajármûhöz! (/vizsgakezd)");
				SetPlayerCheckpoint(playerid, VizsgaJarmuSpawn[SpawnPozicio[playerid]][0], VizsgaJarmuSpawn[SpawnPozicio[playerid]][1], VizsgaJarmuSpawn[SpawnPozicio[playerid]][2], 8.0);
				jatekosJogsitCsinal[playerid] = 1, jatekosJogsiCPStatusz[playerid] = 0;
				GiveMoney(playerid, -JogsiAr);
			} 
			else {
				Msg(playerid, "Valami hiba történt, szólj egy adminnak!");
			}
	    }
		return 1;
	}
	/* ############################################################################################################################# */
	else if(dialogid == DIALOG_VASARLAS_BENZINKUT)
	{
		new DIALOG_VESZ = DIALOG_VASARLAS_BENZINKUT;
		new uzletnev[48] = "SHELL benzinkút üzletláncolat";
		if(response)
		{
			switch(listitem)
			{
				case 0: // Vontatókötél
				{
					if(GetMoney(playerid, true) < 13)
					{
						format(string, sizeof(string), "Ezt nem tudod kifizetni! \n");
						ShowPlayerDialog(playerid, DIALOG_NINCS, DIALOG_STYLE_MSGBOX, uzletnev, string, "Bezárás", "");
						TogglePlayerControllable(playerid, true);
						return 1;
					}
					if(PlayerInfo[playerid][pVontatoKotel] == 1)
					{
						format(string, sizeof(string), "Már van ilyened! \n");
						ShowPlayerDialog(playerid, DIALOG_NINCS, DIALOG_STYLE_MSGBOX, uzletnev, string, "Bezárás", "");
						TogglePlayerControllable(playerid, true);
						return 1;
					}
					GiveMoney(playerid, 13, true);
					PlayerInfo[playerid][pVontatoKotel] = 1;
					format(string, sizeof(string), "Vettél egy vontatókötelet!\n");
					ShowPlayerDialog(playerid, DIALOG_VESZ, DIALOG_STYLE_MSGBOX, uzletnev, string, "Bezárás", "");
					Cselekves(playerid, "vett egy vontató kötelet", 1);
					//BizzInfo[BIZ_247][bProducts] --;
					TogglePlayerControllable(playerid, true);
				}
				case 1: // kaparós sorsjegy
				{
					if(GetMoney(playerid, true) < 1)
					{
						format(string, sizeof(string), "Ezt nem tudod kifizetni!\n");
						ShowPlayerDialog(playerid, DIALOG_NINCS, DIALOG_STYLE_MSGBOX, uzletnev, string, "Bezárás", "");
						TogglePlayerControllable(playerid, true);
						return 1;
					}
					GiveMoney(playerid, -1, true);
					//BizzInfo[BIZ_247][bProducts] --;
					TogglePlayerControllable(playerid, true);
					new nyero = Rand(50, 500);
					if(nyero == 1)
					{
						new menyit = Rand(50, 500);
						GiveMoney(playerid, menyit);
						format(string, sizeof(string), "Vettél egy kaparós sorsjegyet!\nNyertél $%d-ot\n!", menyit);
						ShowPlayerDialog(playerid, DIALOG_VESZ, DIALOG_STYLE_MSGBOX, uzletnev, string, "Bezárás", "");
					}
					else
					{
						format(string, sizeof(string), "Vettél egy kaparós sorsjegyet!\nNem nyertél semmit.\n");
						ShowPlayerDialog(playerid, DIALOG_VESZ, DIALOG_STYLE_MSGBOX, uzletnev, string, "Bezárás", "");
					}
					Cselekves(playerid, "vett egy kaparós sorsjegyet", 1);
				}
				case 2: // szendvics
				{
					if(GetMoney(playerid, true) < 2)
					{
						format(string, sizeof(string), "Ezt nem tudod kifizetni! \n");
						ShowPlayerDialog(playerid, DIALOG_NINCS, DIALOG_STYLE_MSGBOX, uzletnev, string, "Bezárás", "");
						TogglePlayerControllable(playerid, true);
						return 1;
					}
					if(PlayerInfo[playerid][pKaja] < MAXKAJA)
					{
						GiveMoney(playerid, -2, true);
						PlayerInfo[playerid][pKaja] ++;
						format(string, sizeof(string), "Vettél egy szendvicset!\nMost %ddb van nálad", PlayerInfo[playerid][pKaja]);
						ShowPlayerDialog(playerid, DIALOG_VESZ, DIALOG_STYLE_MSGBOX, uzletnev, string, "Bezárás", "");
						//BizzInfo[BIZ_247][bProducts] --;
						TogglePlayerControllable(playerid, true);
					}
					else
					{
						format(string, sizeof(string), "Ennyi szendvicset nem tudok hova rakni...\n");
						ShowPlayerDialog(playerid, DIALOG_NINCS, DIALOG_STYLE_MSGBOX, uzletnev, string, "Bezárás", "");
						TogglePlayerControllable(playerid, true);
					}
				}
				case 3: // üdítõ
				{
					if(GetMoney(playerid, true) < 2)
					{
						format(string, sizeof(string), "Ezt nem tudod kifizetni! \n");
						ShowPlayerDialog(playerid, DIALOG_NINCS, DIALOG_STYLE_MSGBOX, uzletnev, string, "Bezárás", "");
						TogglePlayerControllable(playerid, true);
						return 1;
					}
					GiveMoney(playerid, -2, true);
					PlayerInfo[playerid][pPia]++;
					format(string, sizeof(string), "Vettél egy üveg üditõt!\n");
					ShowPlayerDialog(playerid, DIALOG_VESZ, DIALOG_STYLE_MSGBOX, uzletnev, string, "Bezárás", "");
					Cselekves(playerid, "vett egy üveg üditõt", 1);
					//BizzInfo[BIZ_247][bProducts] --;
					TogglePlayerControllable(playerid, true);
				}
			}
		}
		return 1;
	}
	/* ############################################################## */
	else if(dialogid == DIALOG_VASARLAS_ELELMISZER)
	{
		new DIALOG_VESZ = DIALOG_VASARLAS_ELELMISZER;
		new uzletnev[48] = "Élelmiszer üzletláncolat";
		if(response)
		{
			switch(listitem)
			{
				case 0: // csirke
				{
					if(GetMoney(playerid, true) < 3)
					{
						format(string, sizeof(string), "Ezt nem tudod kifizetni! \n");
						ShowPlayerDialog(playerid, DIALOG_NINCS, DIALOG_STYLE_MSGBOX, uzletnev, string, "Bezárás", "");
						TogglePlayerControllable(playerid, true);
						return 1;
					}
					GiveMoney(playerid, -3, true);
					new rand = random(15);
					Groceries[playerid][pChickens] += 1;
					Groceries[playerid][pChicken] += rand;
					PlayerInfo[playerid][pKaja] ++;
					format(string, sizeof(string), "Vettél egy csirkét!\n");
					ShowPlayerDialog(playerid, DIALOG_VESZ, DIALOG_STYLE_MSGBOX, uzletnev, string, "Bezárás", "");
					Cselekves(playerid, "vett egy csirkét", 1);
					//BizzInfo[BIZ_247][bProducts] --;
					TogglePlayerControllable(playerid, true);
				}
				case 1: // hamburger
				{
					if(GetMoney(playerid, true) < 2)
					{
						format(string, sizeof(string), "Ezt nem tudod kifizetni! \n");
						ShowPlayerDialog(playerid, DIALOG_NINCS, DIALOG_STYLE_MSGBOX, uzletnev, string, "Bezárás", "");
						TogglePlayerControllable(playerid, true);
						return 1;
					}
					GiveMoney(playerid, -2, true);
					new rand = random(15);
					Groceries[playerid][pHamburgers] += 1;
					Groceries[playerid][pHamburger] += rand;
					PlayerInfo[playerid][pKaja] ++;
					format(string, sizeof(string), "Vettél egy hamburgert!\n");
					ShowPlayerDialog(playerid, DIALOG_VESZ, DIALOG_STYLE_MSGBOX, uzletnev, string, "Bezárás", "");
					Cselekves(playerid, "vett egy hamburgert", 1);
					//BizzInfo[BIZ_247][bProducts] --;
					TogglePlayerControllable(playerid, true);
				}
				case 2: // pizza
				{
					if(GetMoney(playerid, true) < 3)
					{
						format(string, sizeof(string), "Ezt nem tudod kifizetni! \n");
						ShowPlayerDialog(playerid, DIALOG_NINCS, DIALOG_STYLE_MSGBOX, uzletnev, string, "Bezárás", "");
						TogglePlayerControllable(playerid, true);
						return 1;
					}
					GiveMoney(playerid, -3, true);
					new rand = random(15);
					Groceries[playerid][pPizzas] += 1;
					Groceries[playerid][pPizza] += rand;
					PlayerInfo[playerid][pKaja] ++;
					format(string, sizeof(string), "Vettél egy fagyasztott pizzát\n");
					ShowPlayerDialog(playerid, DIALOG_VESZ, DIALOG_STYLE_MSGBOX, uzletnev, string, "Bezárás", "");
					Cselekves(playerid, "vett egy fagyasztott pizzát", 1);
					//BizzInfo[BIZ_247][bProducts] --;
					TogglePlayerControllable(playerid, true);
				}
				case 3:// szendvics
				{
					if(GetMoney(playerid, true) < 2)
					{
						format(string, sizeof(string), "Ezt nem tudod kifizetni! \n");
						ShowPlayerDialog(playerid, DIALOG_NINCS, DIALOG_STYLE_MSGBOX, uzletnev, string, "Bezárás", "");
						TogglePlayerControllable(playerid, true);
						return 1;
					}
					if(PlayerInfo[playerid][pKaja] < MAXKAJA)
					{
						GiveMoney(playerid, -2, true);
						PlayerInfo[playerid][pKaja] ++;
						format(string, sizeof(string), "Vettél egy szendvicset!\nMost %ddb van nálad", PlayerInfo[playerid][pKaja]);
						ShowPlayerDialog(playerid, DIALOG_NINCS, DIALOG_STYLE_MSGBOX, uzletnev, string, "Bezárás", "");
						//BizzInfo[BIZ_247][bProducts] --;
						TogglePlayerControllable(playerid, true);
					}
					else
					{
						format(string, sizeof(string), "Ennyi szendvicset nem tudok hova rakni...\n");
						ShowPlayerDialog(playerid, DIALOG_NINCS, DIALOG_STYLE_MSGBOX, uzletnev, string, "Bezárás", "");
						TogglePlayerControllable(playerid, true);
					}
				}
				case 4:// üdítõ
				{
					if(GetMoney(playerid, true) < 2)
					{
						format(string, sizeof(string), "Ezt nem tudod kifizetni! \n");
						ShowPlayerDialog(playerid, DIALOG_NINCS, DIALOG_STYLE_MSGBOX, uzletnev, string, "Bezárás", "");
						TogglePlayerControllable(playerid, true);
						return 1;
					}
					GiveMoney(playerid, -2, true);
					PlayerInfo[playerid][pPia]++;
					format(string, sizeof(string), "Vettél egy üveg üditõt!\n");
					ShowPlayerDialog(playerid, DIALOG_VESZ, DIALOG_STYLE_MSGBOX, uzletnev, string, "Bezárás", "");
					Cselekves(playerid, "vett egy üveg üditõt", 1);
					//BizzInfo[BIZ_247][bProducts] --;
					TogglePlayerControllable(playerid, true);
				}
			}
		}
		return 1;
	}
	else if(dialogid == DIALOG_BSZ && response)
	{
	        switch(listitem)
	        {
	            case 0:
	            {
                    if(PlayerInfo[playerid][pBankSzamla] != 0) return ShowBankDialog(playerid, false, "Már van bankszámlád!");
					if(!Bankban(playerid)) return Msg(playerid, "Nem vagy bankban!");
					if(GetMoney(playerid) < 50) return ShowBankDialog(playerid, false, "A banszámla nyitáshoz $50 szükséges!");
					new SzamlaSzam = 10000 + random(89999);
					new SzamlaSzamJelszo = 1000 + random(8999);
					SendFormatMessage(playerid, COLOR_LIGHTGREEN, "VC Bank: Bankszámla nyitás sikeres! SzámlaSzámod: %d | Jelszó: %d", SzamlaSzam, SzamlaSzamJelszo);
					PlayerInfo[playerid][pBankSzamla] = 1;
					PlayerInfo[playerid][pBankSzamlaSzam] = SzamlaSzam;
					PlayerInfo[playerid][pBankSzamlaJelszo] = SzamlaSzamJelszo;
					GiveMoney(playerid, -50);
					BankSzef += 50;
					Cselekves(playerid, "nyitott egy bankszámlát...");
					return 1;
	            }
			 	case 1:
			 	{
			 	    //if(CsatlakozottSzamla[playerid] == NINCS) return ShowBankDialog(playerid, false, "Elõször be kell lépned egy számlára!!");
			 	    if(ATMnelVan(playerid) != NINCS) ApplyAnimation(playerid, "MISC", "pickup_box",4.0,0,0,1,0,0);
                    ShowPlayerDialog(playerid, DIALOG_BANK_UTAL_1, DIALOG_STYLE_INPUT, "Bankszámla utalás", "Kérem adja meg a számlaszámot, ahová utalni kiván:", "Tovább", "Mégse");
			 	}
			 	case 2:
			 	{
					new atmnel = ATMnelVan(playerid);
					if(atmnel != NINCS) return Msg(playerid, "ATM-nél nem lehet befizetni!");
			 	    //if(CsatlakozottSzamla[playerid] == NINCS) return ShowBankDialog(playerid, false, "Elõször be kell lépned egy számlára!!");
			 	    ShowPlayerDialog(playerid, DIALOG_BANK_BEFIZET, DIALOG_STYLE_INPUT, "Bankszámla befizetés", "Kérem adja meg az összeget:", "Tovább", "Mégse");
			 	}
			 	case 3:
			 	{
			 	    //if(CsatlakozottSzamla[playerid] == NINCS) return ShowBankDialog(playerid, false, "Elõször be kell lépned egy számlára!!");
			 	    if(ATMnelVan(playerid) != NINCS) ApplyAnimation(playerid, "MISC", "pickup_box",4.0,0,0,1,0,0);
			 	    ShowPlayerDialog(playerid, DIALOG_BANK_KIVESZ, DIALOG_STYLE_INPUT, "Bankszámla kivétel", "Kérem adja meg az összeget:", "Tovább", "Mégse");
			 	}
			 	case 4:
			 	{
			 	    //if(CsatlakozottSzamla[playerid] == NINCS) return ShowBankDialog(playerid, false, "Elõször be kell lépned egy számlára!!");
			 	    if(ATMnelVan(playerid) != NINCS) ApplyAnimation(playerid, "MISC", "pickup_box",4.0,0,0,1,0,0);
			 	    ShowPlayerDialog(playerid, DIALOG_BANK_JELSZO, DIALOG_STYLE_INPUT, "Jelszóváltás", "Kérem adja meg az új jelszavát(SZÁM):", "Tovább", "Mégse");
			 	}
				case 5:
			 	{
			 	    //if(CsatlakozottSzamla[playerid] == NINCS) return ShowBankDialog(playerid, false, "Elõször be kell lépned egy számlára!!");
			 	    if(ATMnelVan(playerid) != NINCS) ApplyAnimation(playerid, "MISC", "pickup_box",4.0,0,0,1,0,0);
					new MegadottSzamlaSzam = Bankszamla_Belep[playerid][0];
					new player = BankSzamla(MegadottSzamlaSzam);
			 	    Format(string, "Számlán található összeg: $%d", PlayerInfo[player][pAccount]);
					ShowBankDialog(playerid, false, string);
			 	}
			}
	    }
	    else if(dialogid == (DIALOG_BANK_BELEP_1) && response)
	    {
	        if(ATMnelVan(playerid) != NINCS)
	            ApplyAnimation(playerid, "MISC", "pickup_box",4.0,0,0,1,0,0);
	            
	        new MegadottSzamlaSzam;
			MegadottSzamlaSzam = strval(inputtext);

			new player = BankSzamla(MegadottSzamlaSzam);
			if(player == NINCS || MegadottSzamlaSzam == 0)
				return ShowPlayerDialog(playerid, DIALOG_BANK_BELEP_1, DIALOG_STYLE_INPUT, "Bankszámla belépés", "Nincs ilyen bankszámlaszám! Adja meg a számot újra:", "Tovább", "Mégse");
			if(PlayerInfo[playerid][pZarolva] == 1)	return Msg(playerid, "Zárolva!");
			Bankszamla_Belep[playerid][0] = MegadottSzamlaSzam;
			
			ShowPlayerDialog(playerid, DIALOG_BANK_BELEP_2, DIALOG_STYLE_INPUT, "Bankszámla belépés", "Számlaszám elfogadva!\n Kérem adja meg a bankszámla jelszavát:", "Tovább", "Mégse");
		}
		else if(dialogid == (DIALOG_BANK_BELEP_2) && response)
	    {
	        if(ATMnelVan(playerid) != NINCS)
	            ApplyAnimation(playerid, "MISC", "pickup_box",4.0,0,0,1,0,0);
	            
	        new MegadottSzamlaJelszo, MegadottSzamlaSzam, player;
			MegadottSzamlaJelszo = strval(inputtext);
			MegadottSzamlaSzam = Bankszamla_Belep[playerid][0];
            player = BankSzamla(MegadottSzamlaSzam);
				
		    if(PlayerInfo[player][pBankSzamlaJelszo] == MegadottSzamlaJelszo)
		    {
				if(player != playerid)
				{
					ShowBankDialog(playerid, false, "Ne lépj be más számlájára!");
					return 1;
				}
				Format(string, "Belépés sikeres!\n Számlán található összeg: $%d", PlayerInfo[player][pAccount]);
				ShowBankDialog(playerid, false,string);
				CsatlakozottSzamla[playerid] = MegadottSzamlaSzam;
				Cselekves(playerid, "belépett egy bankszámlára...");
			}
			else
			{
			    ShowPlayerDialog(playerid, DIALOG_BANK_BELEP_2, DIALOG_STYLE_INPUT, "Bankszámla belépés", "Hiba Történt!\nA jelszó nem megfelelõ!\nAdja meg újra:", "Tovább", "Mégse");
			    return 1;
			}
	    }
	    else if(dialogid == DIALOG_BANK_JELSZO && response)
	    {
	        if(ATMnelVan(playerid) != NINCS)
	            ApplyAnimation(playerid, "MISC", "pickup_box",4.0,0,0,1,0,0);
	            
     		if(GetMoney(playerid) < 85) return ShowBankDialog(playerid, false, "A jelszóváltáshoz $85 (Kézpénz)");
			new UjJelszo = 1000 + random(8999);
			PlayerInfo[playerid][pBankSzamlaJelszo] = UjJelszo;
			GiveMoney(playerid, -85);
			BankSzef += 85;
			Format(string, "Jelszóváltás sikeres!\nÚj jelszó: %d", UjJelszo);
			ShowBankDialog(playerid, false,string);
			Cselekves(playerid, "jelszót váltott a számláján...");
	    }
	    else if(dialogid == DIALOG_BANK_KIVESZ && response)
	    {
	        if(ATMnelVan(playerid) != NINCS)
	            ApplyAnimation(playerid, "MISC", "pickup_box",4.0,0,0,1,0,0);
	            
	        new KivettOsszeg;
			KivettOsszeg = strval(inputtext);
			if(KivettOsszeg < 5) return ShowBankDialog(playerid, false, "Minimum $5");
			new player = BankSzamla(CsatlakozottSzamla[playerid]);
			//if(BankSzamla(CsatlakozottSzamla[playerid]) == NINCS) return ShowBankDialog(playerid, false, "Hiba Történt!");

   			if(PlayerInfo[playerid][pAccount] < KivettOsszeg) return ShowBankDialog(playerid, false, "Nincs ennyi pénz a számlán!");

			new UjOsszeg, RegiOsszeg, koltseg;
			koltseg = floatround(float(KivettOsszeg) * 0.01);
			if(koltseg < 2) koltseg = 2;
			BankSzef += koltseg;

			PlayerInfo[playerid][pAccount]-= KivettOsszeg;

			UjOsszeg = PlayerInfo[playerid][pAccount];
			RegiOsszeg = PlayerInfo[playerid][pAccount] + KivettOsszeg;
			GiveMoney(playerid, KivettOsszeg);
			
			Format(string, "Régi összeg:\t$%s\nÚj összeg:\t$%s\nKezelési költség:\t$%d (1%%)", PenzTordeles(RegiOsszeg), PenzTordeles(UjOsszeg), koltseg);
			ShowPlayerDialog(playerid, DIALOG_NINCS, DIALOG_STYLE_TABLIST, "Számlakivétel bizonylat", string, "Bezár", "");
			return 1;
	    }
	    else if(dialogid == DIALOG_BANK_BEFIZET && response)
		{
		    if(ATMnelVan(playerid) != NINCS)
	            ApplyAnimation(playerid, "MISC", "pickup_box",4.0,0,0,1,0,0);
	            
		    new BefizetendoOsszeg;
			BefizetendoOsszeg = strval(inputtext);
			if(BefizetendoOsszeg < 5) return ShowBankDialog(playerid, false, "Minimum $5");
            //if(BankSzamla(CsatlakozottSzamla[playerid]) == NINCS) return ShowBankDialog(playerid, false, "Hiba Történt!");

			if(GetMoney(playerid) < BefizetendoOsszeg) return ShowBankDialog(playerid, false, "Nincs nálad enyi pénz!");

			new UjOsszeg, RegiOsszeg, koltseg;
			koltseg = floatround(float(BefizetendoOsszeg) * 0.01);
			if(koltseg < 2) koltseg = 2;

			PlayerInfo[playerid][pAccount] += (BefizetendoOsszeg - koltseg);
			UjOsszeg = PlayerInfo[playerid][pAccount];
			RegiOsszeg = PlayerInfo[playerid][pAccount] - BefizetendoOsszeg;
			GiveMoney(playerid, -BefizetendoOsszeg);
			
			Format(string, "Régi összeg:\t$%s\nÚj összeg:\t$%s\nKezelési költség:\t$%d (1%%)", PenzTordeles(RegiOsszeg), PenzTordeles(UjOsszeg), koltseg);
			ShowPlayerDialog(playerid, DIALOG_NINCS, DIALOG_STYLE_TABLIST, "Számlakivétel bizonylat", string, "Bezár", "");
			return 1;
		}
	    else if(dialogid == (DIALOG_BANK_UTAL_1) && response)
	    {
	        if(ATMnelVan(playerid) != NINCS)
	            ApplyAnimation(playerid, "MISC", "pickup_box",4.0,0,0,1,0,0);
	            
	        new Szamla = strval(inputtext);
	        
	        new player = BankSzamla(Szamla);
			if(player == NINCS && Szamla != 0102 || Szamla == 0)
				return ShowBankDialog(playerid, false, "Nincs ilyen számla!");
				
	        UtalasSzamla[playerid] = Szamla;
         	ShowPlayerDialog(playerid, DIALOG_BANK_UTAL_2, DIALOG_STYLE_INPUT, "Bankszámla utalás", "Számlaszám elfogadva! Utalás összege:", "Tovább", "Mégse");
		}
	    else if(dialogid == (DIALOG_BANK_UTAL_2) && response)
	    {
	        if(ATMnelVan(playerid) != NINCS)
	            ApplyAnimation(playerid, "MISC", "pickup_box",4.0,0,0,1,0,0);
	            
	        new osszeg = strval(inputtext);
         	if(osszeg < 5) return ShowPlayerDialog(playerid, DIALOG_BANK_UTAL_2, DIALOG_STYLE_INPUT, "Bankszámla utalás", "Minimum $5!\nUtalás összege:", "Tovább", "Mégse");
         	if(osszeg > 100000000) return ShowPlayerDialog(playerid, DIALOG_BANK_UTAL_2, DIALOG_STYLE_INPUT, "Bankszámla utalás", "Max 100000000 Ft!\nUtalás összege:", "Tovább", "Mégse");
			new sajatszamla = BankSzamla(CsatlakozottSzamla[playerid]);
            if(PlayerInfo[sajatszamla][pAccount] < osszeg) return ShowBankDialog(playerid, false, "Ez kicsit sok lenne...");

			new koltseg;
			koltseg = floatround(float(osszeg) * 0.01);
			if(koltseg < 2) koltseg = 2;
			BankSzef += koltseg;
			new player = BankSzamla(UtalasSzamla[playerid]);
			PlayerInfo[player][pAccount] += osszeg;
			PlayerInfo[sajatszamla][pAccount] -= osszeg;
			Format(string, "Utaltál $%d-ot neki: %s.\nkezelési költség $%d (1%%)", osszeg, PlayerName(player), koltseg);
			ShowBankDialog(playerid, false,string);
            SendFormatMessage(player, COLOR_LIGHTRED, "FIGYELEM: %s utalt %s-nak/nek, $%s-t!", PlayerName(playerid), PlayerName(player), PenzTordeles(osszeg));
			if(osszeg > 20000)
			{
			    Format(string, "FIGYELEM: %s utalt %s-nak/nek, $%s-t!", PlayerName(playerid), PlayerName(player), PenzTordeles(osszeg));
				ABroadCast(COLOR_LIGHTRED, string, 1);
			}
			UtalasSzamla[playerid] = NINCS;
			return 1;
	    }
	    else if(dialogid == DIALOG_BSZ2)
		{
			ShowBankDialog(playerid);
			return 1;
		}
	/* ############################################################## */
	else if(dialogid == DIALOG_VASARLAS_MUSZAKI)
	{
		new DIALOG_VESZ = DIALOG_VASARLAS_MUSZAKI;
		new uzletnev[48] = "Media Markt üzletláncolat";
		if(response)
		{
			listitem ++;
			switch(listitem)
			{
				case 1: // bankkártya
				{
					if(PlayerInfo[playerid][pBankSzamla] == 0)
					{
						format(string, sizeof(string), "Nincs bankszámlád! Hogy akarsz kártyát hozzá?\n");
						ShowPlayerDialog(playerid, DIALOG_VESZ, DIALOG_STYLE_MSGBOX,"Hiba", string, "Bezár", "");
						TogglePlayerControllable(playerid, true);
						return 1;
					}
					new ar = 50;
					if(GetMoney(playerid, true) < ar)
					{
						format(string, sizeof(string), "Ezt nem tudom kifizetni\n");
						ShowPlayerDialog(playerid, DIALOG_VESZ, DIALOG_STYLE_MSGBOX,"Hiba", string, "Bezár", "");
						TogglePlayerControllable(playerid, true);
						return 1;
					}
					if(PlayerInfo[playerid][pBankKartya] == 1)
					{
						format(string, sizeof(string), "Már van ilyenem...\n");
						ShowPlayerDialog(playerid, DIALOG_VESZ, DIALOG_STYLE_MSGBOX,"Hiba", string, "Bezár", "");
						TogglePlayerControllable(playerid, true);
						return 1;
					}
					GiveMoney(playerid, -ar, true);
					PlayerInfo[playerid][pBankKartya] = 1;
					format(string, sizeof(string), "Vettél egy bankkártyát!\n");
					ShowPlayerDialog(playerid, DIALOG_VESZ, DIALOG_STYLE_MSGBOX, uzletnev, string, "Bezár", "");
					Cselekves(playerid, "vett egy bankkártyát", 1);
					TogglePlayerControllable(playerid, true);
				}
				case 2: // maszk
				{
					new opciok[248] = "Fekete bandana\nFeketés szükrés bandana\nZöld bandana\nKék bandana\
					\nPiros hokimaszk\nZöld hokimaszk\nFehér hokimaszk";
					ShowPlayerDialog(playerid, DIALOG_VESZ_MASZK, DIALOG_STYLE_LIST, uzletnev, opciok, "Megvesz", "Bezár");
				}
				case 3: // Aktatáska
				{
					Msg(playerid, "Hamarosan..");
					/*if(GetMoney(playerid, true) < 80)
					{
						format(string, sizeof(string), "Ezt nem tudom kifizetni\n");
						ShowPlayerDialog(playerid, DIALOG_VESZ, DIALOG_STYLE_MSGBOX,"Hiba", string, "Bezár", "");
						TogglePlayerControllable(playerid, true);
						return 1;
					}
					GiveMoney(playerid, -80, true);
					BizPenz(BIZ_247, 80);
					TaskaVan[playerid] = 1;
					format(string, sizeof(string), "Vettél egy Aktatáskát!\n");
					ShowPlayerDialog(playerid, DIALOG_VESZ, DIALOG_STYLE_MSGBOX, uzletnev, string, "Bezár", "");
					Cselekves(playerid, "vett egy aktatáskát", 1);
					TogglePlayerControllable(playerid, true);
					SetPlayerAttachedObject(playerid, SLOT_KEZ, 1210, 5, 0.3, 0.1, 0.0, 0.0, 270.0, 0.0);*/
				}
				case 4: // hátitáska
				{
					Msg(playerid, "Hamarosan..");
				}
				case 5: // Cigaretta
				{
					if(GetMoney(playerid, true) < 5)
					{
						format(string, sizeof(string), "Ezt nem tudom kifizetni\n");
						ShowPlayerDialog(playerid, DIALOG_VESZ, DIALOG_STYLE_MSGBOX,"Hiba", string, "Bezár", "");
						TogglePlayerControllable(playerid, true);
						return 1;
					}
					GiveMoney(playerid, -5, true);
					BizPenz(BIZ_247, 5);
					PlayerInfo[playerid][pCigi] += 12;
					format(string, sizeof(string), "Vettél egy doboz cigit (12 szál)!\n");
					ShowPlayerDialog(playerid, DIALOG_VESZ, DIALOG_STYLE_MSGBOX, uzletnev, string, "Bezár", "");
					Cselekves(playerid, "vett egy doboz cigit", 1);
					TogglePlayerControllable(playerid, true);
				}
				case 6: // Cigipapír
				{
					if(GetMoney(playerid, true) < 1)
					{
						format(string, sizeof(string), "Ezt nem tudom kifizetni\n");
						ShowPlayerDialog(playerid, DIALOG_VESZ, DIALOG_STYLE_MSGBOX, "Hiba", string, "Bezár", "");
						TogglePlayerControllable(playerid, true);
						return 1;
					}
					GiveMoney(playerid, -1, true);
					format(string, sizeof(string), "Vettél egy csomag cigaretta papírt!\n");
					ShowPlayerDialog(playerid, DIALOG_VESZ, DIALOG_STYLE_MSGBOX, uzletnev, string, "Bezár", "");
					Cselekves(playerid, "vett egy csomagcigarettapapírt", 1);
					PlayerInfo[playerid][pCp] += 10;
					TogglePlayerControllable(playerid, true);
				}
				case 7: // Öngyújtó
				{
					if(GetMoney(playerid, true) < 2)
					{
						format(string, sizeof(string), "Ezt nem tudom kifizetni\n");
						ShowPlayerDialog(playerid, DIALOG_VESZ, DIALOG_STYLE_MSGBOX, "Hiba", string, "Bezár", "");
						TogglePlayerControllable(playerid, true);
						return 1;
					}
					GiveMoney(playerid, -2, true);
					PlayerInfo[playerid][pGyujto] += 12;
					format(string, sizeof(string), "Vettél egyöngyújtót!\n");
					ShowPlayerDialog(playerid, DIALOG_VESZ, DIALOG_STYLE_MSGBOX, uzletnev, string, "Bezár", "");
					Cselekves(playerid, "vett egy vihar gyújtót", 1);
					TogglePlayerControllable(playerid, true);
				}
				case 8: // telefon
				{
					if(GetMoney(playerid, true) < 213)
					{
						format(string, sizeof(string), "Ezt nem tudod kifizetni! \n");
						ShowPlayerDialog(playerid, DIALOG_NINCS, DIALOG_STYLE_MSGBOX, uzletnev, string, "Bezárás", "");
						TogglePlayerControllable(playerid, true);
						return 1;
					}
					if(PlayerInfo[playerid][pPnumber] != 0)
					{
						format(string, sizeof(string), "Már van ilyened! \n");
						ShowPlayerDialog(playerid, DIALOG_NINCS, DIALOG_STYLE_MSGBOX, uzletnev, string, "Bezárás", "");
						TogglePlayerControllable(playerid, true);
						return 1;
					}
					GiveMoney(playerid, -213, true);
					new randphone = 10000 + random(89999);
					PlayerInfo[playerid][pPnumber] = randphone;
					format(string, sizeof(string), "Megvetted a telefont, a számod: %d\n", randphone);
					ShowPlayerDialog(playerid, DIALOG_VESZ, DIALOG_STYLE_MSGBOX, uzletnev, string, "Bezárás", "");
					Cselekves(playerid, "vett egy telefont", 1);
					
					TogglePlayerControllable(playerid, true);//false
				}
				case 9: // Walkie-Talkie
				{
					if(GetMoney(playerid, true) < 43)
					{
						format(string, sizeof(string), "Ezt nem tudod kifizetni! \n");
						ShowPlayerDialog(playerid, DIALOG_NINCS, DIALOG_STYLE_MSGBOX, uzletnev, string, "Bezárás", "");
						TogglePlayerControllable(playerid, true);
						return 1;
					}
					if(PlayerInfo[playerid][pVokitoki] == 1)
					{
						format(string, sizeof(string), "Már van ilyened! \n");
						ShowPlayerDialog(playerid, DIALOG_NINCS, DIALOG_STYLE_MSGBOX, uzletnev, string, "Bezárás", "");
						TogglePlayerControllable(playerid, true);
						return 1;
					}
					GiveMoney(playerid, -43, true);
					PlayerInfo[playerid][pVokitoki] = 1;
					format(string, sizeof(string), "Vettél egy Walkie-Talkie-t!\n");
					ShowPlayerDialog(playerid, DIALOG_VESZ, DIALOG_STYLE_MSGBOX, uzletnev, string, "Bezárás", "");
					Cselekves(playerid, "vett egy Walkie-Talkie-t", 1);
					TogglePlayerControllable(playerid, true);
				}
				case 10: // kamera
				{
					if(GetMoney(playerid, true) < 50)
					{
						format(string, sizeof(string), "Ezt nem tudod kifizetni! \n");
						ShowPlayerDialog(playerid, DIALOG_NINCS, DIALOG_STYLE_MSGBOX, uzletnev, string, "Bezárás", "");
						TogglePlayerControllable(playerid, true);
					}
					else
					{
						GiveWeapon(playerid, 43, 100);
					}
				}
				case 11: // MP3
				{
					if(GetMoney(playerid, true) < 64)
					{
						format(string, sizeof(string), "Ezt nem tudod kifizetni! \n");
						ShowPlayerDialog(playerid, DIALOG_NINCS, DIALOG_STYLE_MSGBOX, uzletnev, string, "Bezárás", "");
						TogglePlayerControllable(playerid, true);
						return 1;
					}
					if(PlayerInfo[playerid][pCDPlayer] == 1)
					{
						format(string, sizeof(string), "Már van ilyened! \n");
						ShowPlayerDialog(playerid, DIALOG_NINCS, DIALOG_STYLE_MSGBOX, uzletnev, string, "Bezárás", "");
						TogglePlayerControllable(playerid, true);
						return 1;
					}
					GiveMoney(playerid, -64, true);
					BizPenz(BIZ_247, 64);
					PlayerInfo[playerid][pCDPlayer] = 1;
					format(string, sizeof(string), "Vettél egy MP3 lejátszót!\n");
					ShowPlayerDialog(playerid, DIALOG_VESZ, DIALOG_STYLE_MSGBOX, uzletnev, string, "Bezárás", "");
					Cselekves(playerid, "vett egy MP3 lejátszót", 1);
					TogglePlayerControllable(playerid, true);
				}
				case 12: // Hifi
				{
					if(GetMoney(playerid, true) < 100)
					{
						format(string, sizeof(string), "Ezt nem tudod kifizetni! \n");
						ShowPlayerDialog(playerid, DIALOG_NINCS, DIALOG_STYLE_MSGBOX, uzletnev, string, "Bezárás", "");
						TogglePlayerControllable(playerid, true);
						return 1;
					}
					if(PlayerInfo[playerid][pHifi] >= 1)
					{
						format(string, sizeof(string), "Már van ilyened! \n");
						ShowPlayerDialog(playerid, DIALOG_NINCS, DIALOG_STYLE_MSGBOX, uzletnev, string, "Bezárás", "");
						TogglePlayerControllable(playerid, true);
						return 1;
					}
					GiveMoney(playerid, -100, true);
					PlayerInfo[playerid][pHifi] = 1;
					format(string, sizeof(string), "Vettél egy Hifi-t!\n");
					ShowPlayerDialog(playerid, DIALOG_VESZ, DIALOG_STYLE_MSGBOX, uzletnev, string, "Bezárás", "");
					Cselekves(playerid, "vett egy HiFI lejátszót", 1);
					TogglePlayerControllable(playerid, true);
				}
				case 13: // Gyógyszer
				{
					if(GetMoney(playerid, true) < 50)
					{
						format(string, sizeof(string), "Ezt nem tudod kifizetni! \n");
						ShowPlayerDialog(playerid, DIALOG_NINCS, DIALOG_STYLE_MSGBOX, uzletnev, string, "Bezárás", "");
						TogglePlayerControllable(playerid, true);
						return 1;
					}
					GiveMoney(playerid, -50, true);
					orvossaghp(playerid);
					format(string, sizeof(string), "Vettél egy gyógyszert!\n");
					ShowPlayerDialog(playerid, DIALOG_VESZ, DIALOG_STYLE_MSGBOX, uzletnev, string, "Bezárás", "");
					Cselekves(playerid, "vett egy gyógyszert", 1);
					TogglePlayerControllable(playerid, true);
				}
			}
		}
		return 1;
	}
	/* ############################################################## */
	else if(dialogid == DIALOG_VASARLAS_PATIKA)
	{
		new DIALOG_VESZ = DIALOG_VASARLAS_PATIKA
		new uzletnev[48] = "Pingvin patika";
		if(response)
		{
			switch(listitem)
			{
				case 0: // Kötszer
				{
					if(GetMoney(playerid, true) < 5)
					{
						format(string, sizeof(string), "Ezt nem tudom kifizetni\n");
						ShowPlayerDialog(playerid, DIALOG_NINCS, DIALOG_STYLE_MSGBOX, "{FF0000}Hiba", string, "Bezár", "");
						TogglePlayerControllable(playerid, true);
						return 1;
					}
					if(PlayerInfo[playerid][pKotszer] < MAXKOTSZER)
					{
						PlayerInfo[playerid][pKotszer] += 3;
						format(string, sizeof(string), "Vettél egy kötszeres dobozt\n");
						ShowPlayerDialog(playerid, DIALOG_VESZ, DIALOG_STYLE_MSGBOX, uzletnev, string, "Bezár", "");
						Cselekves(playerid, "vett egy kötszeres dobozt", 1);
						//BizzInfo[BIZ_247][bProducts] --;
						GiveMoney(playerid, -5, true);
						TogglePlayerControllable(playerid, true);
					}
					else
					{
						format(string, sizeof(string), "Ennyi kötszert nem bírok elrakni...\n");
						ShowPlayerDialog(playerid, DIALOG_NINCS, DIALOG_STYLE_MSGBOX, "{FF0000}Hiba", string, "Bezár", "");
						TogglePlayerControllable(playerid, true);
					}
				}
				case 1: // Injekciós tû
				{
					if(Fecskendo[playerid] != 0)
					{
						ShowPlayerDialog(playerid, DIALOG_NINCS, DIALOG_STYLE_MSGBOX, uzletnev, "Neked már van injekciós tûd!", "Bezár", "");
						return 1;
					}
					if(GetMoney(playerid, true) < 4)
					{
						format(string, sizeof(string), "Ezt nem tudom kifizetni\n");
						ShowPlayerDialog(playerid, DIALOG_NINCS, DIALOG_STYLE_MSGBOX, "{FF0000}Hiba", string, "Bezár", "");
						TogglePlayerControllable(playerid, true);
						return 1;
					}
					Cselekves(playerid, "vett egy fecskendõt");
					Fecskendo[playerid] = 1;
					GiveMoney(playerid, -4);
					FrakcioInfo[LMUNKA_MENTO][fPenz] += 4;
					ShowPlayerDialog(playerid, DIALOG_VESZ, DIALOG_STYLE_MSGBOX, uzletnev, string, "Bezár", "");
				}
			}
		}
		return 1;
	}
	else if(dialogid == DIALOG_VASARLAS_SPORT)
	{
		new EszkozAr, EszkozID;
		if(response)
		{
			switch(listitem)
			{
				case 0: { EszkozAr = 40; EszkozID = 5; }
				case 1: { EszkozAr = 55; EszkozID = 2; }
				case 2: { EszkozAr = 45; EszkozID = 6; }
				case 3: { EszkozAr = 50; EszkozID = 7; }
			}
			
			if(GetMoney(playerid) < EszkozAr)
			{
				PlayerTextFormat(playerid, "Nincs elég pénzed!\nEz az eszköz $%s!", PenzTordeles(EszkozAr));
				HibaDialog(playerid, PlayerText[playerid], DIALOG_VASARLAS_SPORT);
				return 1;
			}
			
			GiveMoney(playerid, -EszkozAr);
			GiveWeapon(playerid, EszkozID, 1);
			MsgFormat(playerid, "Sikeresen megvetted az eszközt melynek az ára $%s volt!", PenzTordeles(EszkozAr));
		}
		return 1;
	}
	else if(dialogid == DIALOG_VASARLAS_EGYEB)
	{
		new DIALOG_VESZ = DIALOG_VASARLAS_EGYEB;
		new uzletnev[48] = "Egyéb árucikkek";
		if(response)
		{
			switch(listitem)
			{
				case 0: // Bankkártya
				{
					new ar = 50;
					if(GetMoney(playerid, true) < ar)
					{
						format(string, sizeof(string), "Ezt nem tudom kifizetni\n");
						ShowPlayerDialog(playerid, DIALOG_VESZ, DIALOG_STYLE_MSGBOX,"Hiba", string, "Bezár", "");
						TogglePlayerControllable(playerid, true);
						return 1;
					}
					if(PlayerInfo[playerid][pBankKartya] == 1)
					{
						format(string, sizeof(string), "Már van ilyenem...\n");
						ShowPlayerDialog(playerid, DIALOG_VESZ, DIALOG_STYLE_MSGBOX,"Hiba", string, "Bezár", "");
						TogglePlayerControllable(playerid, true);
						return 1;
					}
					GiveMoney(playerid, -ar, true);
					PlayerInfo[playerid][pBankKartya] = 1;
					format(string, sizeof(string), "Vettél egy bankkártyát!\n");
					ShowPlayerDialog(playerid, DIALOG_VESZ, DIALOG_STYLE_MSGBOX, uzletnev, string, "Bezár", "");
					Cselekves(playerid, "vett egy bankkártyát", 1);
					//BizzInfo[BIZ_247][bProducts] --;
					TogglePlayerControllable(playerid, true);
				}
				case 1: // Maszk
				{
					new opciok[248] = "Fekete bandana\nFeketés szükrés bandana\nZöld bandana\nKék bandana\
					\nPiros hokimaszk\nZöld hokimaszk\nFehér hokimaszk";
					ShowPlayerDialog(playerid, DIALOG_VESZ_MASZK, DIALOG_STYLE_LIST, uzletnev, opciok, "Megvesz", "Bezár");
				}
				case 2: // Aktatáska
				{
					if(GetMoney(playerid, true) < 80)
					{
						format(string, sizeof(string), "Ezt nem tudom kifizetni\n");
						ShowPlayerDialog(playerid, DIALOG_VESZ, DIALOG_STYLE_MSGBOX,"Hiba", string, "Bezár", "");
						TogglePlayerControllable(playerid, true);
						return 1;
					}
					GiveMoney(playerid, -80, true);
					BizPenz(BIZ_247, 80);
					TaskaVan[playerid] = 1;
					format(string, sizeof(string), "Vettél egy Aktatáskát!\n");
					ShowPlayerDialog(playerid, DIALOG_VESZ, DIALOG_STYLE_MSGBOX, uzletnev, string, "Bezár", "");
					Cselekves(playerid, "vett egy aktatáskát", 1);
					//BizzInfo[BIZ_247][bProducts] --;
					TogglePlayerControllable(playerid, true);
					SetPlayerAttachedObject(playerid, SLOT_KEZ, 1210, 5, 0.3, 0.1, 0.0, 0.0, 270.0, 0.0);
				}
				case 3: // Hátitáska
				{
					Msg(playerid, "Hamarosan..");
				}
				case 4: // Cigi
				{
					if(GetMoney(playerid, true) < 5)
					{
						format(string, sizeof(string), "Ezt nem tudom kifizetni\n");
						ShowPlayerDialog(playerid, DIALOG_VESZ, DIALOG_STYLE_MSGBOX,"Hiba", string, "Bezár", "");
						TogglePlayerControllable(playerid, true);
						return 1;
					}
					GiveMoney(playerid, -5, true);
					BizPenz(BIZ_247, 5);
					PlayerInfo[playerid][pCigi] += 12;
					format(string, sizeof(string), "Vettél egy doboz cigit (12 szál)!\n");
					ShowPlayerDialog(playerid, DIALOG_VESZ, DIALOG_STYLE_MSGBOX, uzletnev, string, "Bezár", "");
					Cselekves(playerid, "vett egy doboz cigit", 1);
					//BizzInfo[BIZ_247][bProducts] --;
					TogglePlayerControllable(playerid, true);
				}
				case 5: // Cigipapír
				{
					if(GetMoney(playerid, true) < 1)
					{
						format(string, sizeof(string), "Ezt nem tudom kifizetni\n");
						ShowPlayerDialog(playerid, DIALOG_VESZ, DIALOG_STYLE_MSGBOX, "Hiba", string, "Bezár", "");
						TogglePlayerControllable(playerid, true);
						return 1;
					}
					GiveMoney(playerid, -1, true);
					BizPenz(BIZ_247, 1);
					format(string, sizeof(string), "Vettél egy csomag cigaretta papírt!\n");
					ShowPlayerDialog(playerid, DIALOG_VESZ, DIALOG_STYLE_MSGBOX, uzletnev, string, "Bezár", "");
					Cselekves(playerid, "vett egy csomagcigarettapapírt", 1);
					//BizzInfo[BIZ_247][bProducts] --;
					PlayerInfo[playerid][pCp] += 10;
					TogglePlayerControllable(playerid, true);
				}
				case 6: // Öngyújtó
				{
					if(GetMoney(playerid, true) < 2)
					{
						format(string, sizeof(string), "Ezt nem tudom kifizetni\n");
						ShowPlayerDialog(playerid, DIALOG_VESZ, DIALOG_STYLE_MSGBOX, "Hiba", string, "Bezár", "");
						TogglePlayerControllable(playerid, true);
						return 1;
					}
					GiveMoney(playerid, -2, true);
					BizPenz(BIZ_247, 2);
					PlayerInfo[playerid][pGyujto] += 12;
					format(string, sizeof(string), "Vettél egyöngyújtót!\n");
					ShowPlayerDialog(playerid, DIALOG_VESZ, DIALOG_STYLE_MSGBOX, uzletnev, string, "Bezár", "");
					Cselekves(playerid, "vett egy vihar gyújtót", 1);
					//BizzInfo[BIZ_247][bProducts] --;
					TogglePlayerControllable(playerid, true);
				}
			}
		}
		return 1;
	}
	else if(dialogid == DIALOG_VESZ_MASZK)
	{
		if(response)
		{
			new ar = 5, ObjectID = NINCS;
			if(GetMoney(playerid, true) < ar)
			{
				format(string, sizeof(string), "Ezt nem tudom kifizetni\n");
				ShowPlayerDialog(playerid, DIALOG_VASARLAS_EGYEB, DIALOG_STYLE_MSGBOX, "Hiba", string, "Bezár", "");
				TogglePlayerControllable(playerid, true);
				return 1;
			}

			switch(listitem)
			{
				case 0: { ObjectID = 18912; } // Fekete bandana
				case 1: { ObjectID = 18918; } // Feketés szükrés bandana
				case 2: { ObjectID = 18913; } // Zöld bandana
				case 3: { ObjectID = 18917; } // Kék bandana
				
				case 4: { ObjectID = 19037; } // Piros hokimaszk
				case 5: { ObjectID = 19038; } // Zöld hokimaszk
				case 6: { ObjectID = 19036; } // Fehér hokimaszk
			}
			
			PlayerInfo[playerid][pMaszk] = ObjectID;
			Msg(playerid, "Sikeresen megvetted a maszkot!");
		}
		return 1;
	}
	/* ############################################################################################################################# */
	/*else if(dialogid == DIALOG_HALAL)
	{
		if(response)
		{
			ShowPlayerDialog(playerid, DIALOG_HALAL2, DIALOG_STYLE_INPUT, "Meghaltál!", "1 pár szóba írd le, hogy hol, milyen körülmények között, esetleg a legnagyobb segítség a neve lenne", "Elküld", "Mégse!");
		}
		else
		{
			ShowPlayerDialog(playerid, DIALOG_NINCS, DIALOG_STYLE_MSGBOX, "Meghaltál!", "Rendben, csak érdeklõdtünk, hogy RP-s volt-e a szituáció, további jó játékot! :)", "Oksa!", "");
		}
	}
	else if(dialogid == DIALOG_HALAL2)
	{
		if(response)
		{
			new length = strlen(inputtext), idx;
			while ((idx < length) && (inputtext[idx] <= ' '))
			{
				idx++;
			}
			new offset = idx;
			new result[256];
			while ((idx < length) && ((idx - offset) < (sizeof(result) - 1)))
			{
				result[idx - offset] = inputtext[idx];
				idx++;
			}
			result[idx - offset] = EOS;
			if(!strlen(result))
			{
				ShowPlayerDialog(playerid, DIALOG_HALAL2, DIALOG_STYLE_INPUT, "Meghaltál!", "1 pár szóba írd le, hogy hol, milyen körülmények között, esetleg a legnagyobb segítség a neve lenne", "Elküld", "Mégse!");
				return 1;
			}
			ABroadCast(COLOR_LIGHTRED, "============[ DM REPORT ]============", 1);
			ABroadCast(COLOR_LIGHTRED, "", 1);
			ABroadCastFormat(COLOR_PIROS, 1, "%s-t (%d) le dm-elték, az alábbi leírást adta: %s", PlayerName(playerid), playerid, result);
			ABroadCast(COLOR_PIROS, "Valaki foglalkozzon az üggyel-MOST!", 1);
			ABroadCast(COLOR_LIGHTRED, "", 1);
			ABroadCast(COLOR_LIGHTRED, "============[ DM REPORT ]============", 1);
		}
		else
		{
			ShowPlayerDialog(playerid, 9999, DIALOG_STYLE_MSGBOX, "Meghaltál!", "Rendben, csak érdeklõdtünk, hogy RP-s volt-e a szituáció, további jó játékot! :)", "Oksa!", "");
		}
	} */
	if(response == 1)
	{
		if(dialogid == DIALOG_TUNING)
		{
		    for(new i=0;i<=TuningSzamolo[playerid];i++)
		    {
				if(listitem == i)
				{
					if(IsVehicleUpgradeCompatible(GetVehicleModel(GetPlayerVehicleID(playerid)), KomponensID[playerid][i]))
					{
						new ara = KomponensAra(KomponensID[playerid][i])/DOLLAR_ARFOLYAM;
						if(GetMoney(playerid) >= ara)
						{
						    new kocsi = GetPlayerVehicleID(playerid);
						    TuningFelrak(playerid,kocsi, KomponensID[playerid][i]);
							//AddVehicleComponent(GetPlayerVehicleID(playerid), KomponensID[playerid][i]);
							//TuningMent(GetPlayerVehicleID(playerid),KomponensID[playerid][i]);

							new tuningstr[128];
							format(tuningstr, sizeof(tuningstr), "{FF6400}%s {FFFFFF}felszerelve!", GetComponentName(KomponensID[playerid][i]));
							SendClientMessage(playerid,COLOR_YELLOW,tuningstr);
							GiveMoney(playerid,-ara);
							BizPenz(BIZ_TUNING, ara);
						}
						else
						{
							MsgFormat(playerid, "Ez az alkatrész $%s amelyre nincs pénzed!", PenzTordeles(ara));
						}
						return ParancsKuldes(playerid, "/tuning");
					}
					else Msg(playerid, "Ezt az alkatrészt nem lehet felszerelni erre a kocsira!");
				}
			}
			return 1;
		}
		if(dialogid == DIALOG_TUNING2)
		{
		    for(new i=0;i<=TuningSzamolo[playerid];i++)
		    {
				if(listitem == i)
				{
					if(IsVehicleUpgradeCompatible(GetVehicleModel(GetPlayerVehicleID(playerid)),KomponensID[playerid][i]))
					{
						new kocsi = GetPlayerVehicleID(playerid);
						TuningFelrak(playerid,kocsi, KomponensID[playerid][i]);
						//AddVehicleComponent(GetPlayerVehicleID(playerid), KomponensID[playerid][i]);
						//TuningMent(GetPlayerVehicleID(playerid),KomponensID[playerid][i]);

						new tuningstr[128];
						format(tuningstr, sizeof(tuningstr), "{FF6400}%s {FFFFFF}felszerelve!", GetComponentName(KomponensID[playerid][i]));
						SendClientMessage(playerid,COLOR_YELLOW,tuningstr);
						return ParancsKuldes(playerid, "/atuning2");
					}
					else Msg(playerid, "Ezt az alkatrészt nem lehet felszerelni erre a kocsira!");
				}
			}
		}
		if(dialogid == DIALOG_DUTY)
		{
		    if(LMT(playerid, LMUNKA_LSPD))
		    {
	 			switch(listitem)
				{
				    case 0:
				    {
				        Cselekves(playerid, "felvette az alap felszerelést",0);
				        Munkaruha(playerid, 1);
				        ResetWeapon(playerid);
						
						GiveWeapon(playerid, 24,100);
						GiveWeapon(playerid, 43, 50);
				        GiveWeapon(playerid, 3, 1);
				        GiveWeapon(playerid, 41, 2000);
				    }
				    case 1:
				    {
						Cselekves(playerid, "felvette a golyóálló mellényt és evett egy fánkot",0);
						PlayerInfo[playerid][pEhseg] = 0.0;
						SetPlayerArmour(playerid, MAXARMOUR);
						SetHealth(playerid, MAXHP);
				    }
				    case 2:
				    {
				        if(PlayerInfo[playerid][pRank] < 1) return ShowFelszerelesDialog(playerid, false, "1-es rangtól!");
						if(PlayerInfo[playerid][pMotorJogsi] == 0) return Msg(playerid, "Nincs motorra jogosítványod ezért nem használhatod ezt a felszerelést!");
				        Cselekves(playerid, "felvette a motoros felszerelést",0);
						GiveWeapon(playerid, 3, 1);						
						GiveWeapon(playerid,24,100);						
						GiveWeapon(playerid,41,2000);
						SetPlayerSkin(playerid, 284);
				    }
				    case 3:
				    {
				        if(PlayerInfo[playerid][pRank] < 6) return ShowFelszerelesDialog(playerid, false, "6-os rangtól!");
				        Cselekves(playerid, "felvette a magas szintû felszerelést",0);
						//SetPlayerSkin(playerid, 285);
						//GiveWeapon(playerid, 3, 1);
						GiveWeapon(playerid, 24, 100);
						GiveWeapon(playerid, 41, 2000);
						GiveWeapon(playerid, 29, 100);
						GiveWeapon(playerid, 25, 100);
				    }
				}
		    }
			else if(LMT(playerid,LMUNKA_NAV))
		    {
	 			switch(listitem)
				{
				    case 0:
				    {
				        Cselekves(playerid, "felvette az alap felszerelést",0);
				         Munkaruha(playerid, 1);
				        ResetWeapon(playerid);
						
						GiveWeapon(playerid,24,100);
				        GiveWeapon(playerid,3,1);
				        GiveWeapon(playerid,41,2000);
				    }
				    case 1:
				    {
						Cselekves(playerid, "felvette a golyóálló mellényt és evett egy fánkot",0);
						PlayerInfo[playerid][pEhseg] = 0.0;
						SetPlayerArmour(playerid, MAXARMOUR);
						SetHealth(playerid, MAXHP);
				    }
				    case 2:
				    {
						Cselekves(playerid, "átöltözött az alkalmi ruhába",0);
						ResetWeapon(playerid);
						SetPlayerSkin(playerid, 194);
						GiveWeapon(playerid,41,2000);
				    }
				    case 3:
				    {
				        if(PlayerInfo[playerid][pRank] < 2) return ShowFelszerelesDialog(playerid, false, "2-as rangtól!");
						SetPlayerSkin(playerid, PlayerInfo[playerid][pModel]);
						Cselekves(playerid, "átöltözött az nyomozoi ruhába",0);
						GiveWeapon(playerid, 43, 200);						
						GiveWeapon(playerid,24,100);
				    }
				    case 4:
				    {
				        Cselekves(playerid, "felvette a határõrségi felszerelést",0);
						GiveWeapon(playerid, 3, 1);						
						GiveWeapon(playerid,24,100);						
						GiveWeapon(playerid,41,2000);
						SetPlayerSkin(playerid, 71);
				    }
				    case 5:
				    {
				        if(PlayerInfo[playerid][pRank] < 6) return ShowFelszerelesDialog(playerid, false, "6-os rangtól!");
				        Cselekves(playerid, "felvette a magas szintû felszerelést",0);
						
						GiveWeapon(playerid, 3, 1);
						GiveWeapon(playerid,24,100);
						GiveWeapon(playerid,41,2000);
						GiveWeapon(playerid,29,100);
						GiveWeapon(playerid,25,100);
				    }
				    case 6:
				    {
				        if(PlayerInfo[playerid][pRank] < 6) return ShowFelszerelesDialog(playerid, false, "6-as rangtól!");
				        Cselekves(playerid, "nézelõdik a szekrényében",0);
						format(string, sizeof(string), "Ird be melyik skint szeretnéd felvenni.\n", PlayerName(playerid));
						ShowPlayerDialog(playerid, DIALOG_BEP, DIALOG_STYLE_INPUT, "Beépített", string, "Tovább", "Mégse");
						HolTart[playerid] = 1;
				    }
				}
		    }
		    else if(LMT(playerid,LMUNKA_FBI))
		    {
			 	switch(listitem)
				{
				    case 0:
				    {
				        Cselekves(playerid, "felvette az alap felszerelést",0);
				         Munkaruha(playerid, 1);
						GiveWeapon(playerid,24,100);
						GiveWeapon(playerid,29,250);
				        GiveWeapon(playerid,43,200);
						if(PlayerInfo[playerid][pKotszer]+2 < MAXKOTSZER)
							PlayerInfo[playerid][pKotszer] += 2;
						Helyszinel[playerid] = false;
				    }
				    case 1:
				    {
						Cselekves(playerid, "felvette a golyóálló mellényt és evett egy fánkot",0);
						PlayerInfo[playerid][pEhseg] = 0.0;
						SetPlayerArmour(playerid, MAXARMOUR);
						SetHealth(playerid, MAXHP);
				    }			
				    case 2:
				    {
				        if(PlayerInfo[playerid][pRank] < 3) return ShowFelszerelesDialog(playerid, false, "3-es rangtól!");
				        Cselekves(playerid, "nézelõdik a szekrényében",0);
						format(string, sizeof(string), "Ird be melyik skint szeretnéd felvenni.\n", PlayerName(playerid));
						ShowPlayerDialog(playerid, DIALOG_BEP, DIALOG_STYLE_INPUT, "Beépített", string, "Tovább", "Mégse");
						HolTart[playerid] = 1;
						Helyszinel[playerid] = false;
				    }
				    case 3:
				    {
				        if(PlayerInfo[playerid][pRank] < 2) return ShowFelszerelesDialog(playerid, false, "2-es rangtól!");
				        Cselekves(playerid, "felvette a magas szintû felszerelést",0);
						SetPlayerArmour(playerid, MAXARMOUR);
						GiveWeapon(playerid,31,300);
						GiveWeapon(playerid,24,100);
						GiveWeapon(playerid,29,100);
						GiveWeapon(playerid,25,100);
						GiveWeapon(playerid,34,25);
						Helyszinel[playerid] = false;
						}
				   case 4:
				    {
						if(PlayerInfo[playerid][pRank] < 1) return ShowFelszerelesDialog(playerid, false, "1-es rangtól!");
						Cselekves(playerid, "magához vette a helyszinelõ felszerelését");
						Helyszinel[playerid] = true;
						SetHealth(playerid, MAXHP);
						SetPlayerSkin(playerid, 286);
						GiveWeapon(playerid, 22, 500);
						GiveWeapon(playerid, 43, 400);
						GiveWeapon(playerid, 41, 3000);
					}
				}
		    }
			else if(LMT(playerid,LMUNKA_KATONA))
			{
				switch(listitem)
				{
				    case 0:
				    {
						Cselekves(playerid, "felvette az alap felszerelést",0);
						Munkaruha(playerid, 1);
						ResetWeapon(playerid);
						GiveWeapon(playerid,41,2000);
						GiveWeapon(playerid,24,100);
						GiveWeapon(playerid,30,200);
						GiveWeapon(playerid,46,1);
				    }
				    case 1:
				    {
						Cselekves(playerid, "felvette a golyóálló mellényt és evett egy fánkot",0);
						PlayerInfo[playerid][pEhseg] = 0.0;
						SetPlayerArmour(playerid, MAXARMOUR);
						SetHealth(playerid, MAXHP);
				    }
				    case 2:
				    {
						Cselekves(playerid, "átöltözött az alkalmi ruhába",0);
						ResetWeapon(playerid);
						SetPlayerSkin(playerid, 61);
						GiveWeapon(playerid,41,2000);
				    }
				    case 3:
				    {
						if(PlayerInfo[playerid][pRank] < 3) return ShowFelszerelesDialog(playerid, false, "3-as rangtól!");
				        Cselekves(playerid, "nézelõdik a szekrényében",0);
						format(string, sizeof(string), "Ird be melyik skint szeretnéd felvenni.\n", PlayerName(playerid));
						ShowPlayerDialog(playerid, DIALOG_BEP, DIALOG_STYLE_INPUT, "Beépített", string, "Tovább", "Mégse");
						HolTart[playerid] = 1;
				    }
				    case 4:
				    {
				        if(PlayerInfo[playerid][pRank] < 8) return ShowFelszerelesDialog(playerid, false, "10-es rangtól!");
						Cselekves(playerid, "felvette az alap taktikai felszerelést",0);
						GiveWeapon(playerid,31,200);
						GiveWeapon(playerid,46,1);
						GiveWeapon(playerid,24,100);
						GiveWeapon(playerid,16,3);
				    }
				    case 5:
				    {
				        if(PlayerInfo[playerid][pRank] < 6) return ShowFelszerelesDialog(playerid, false, "6-os rangtól!");
						Cselekves(playerid, "felvette a nehéz taktikai felszerelést",0);
				    }
				    case 6:
				    {
				        if(PlayerInfo[playerid][pRank] < 4) return ShowFelszerelesDialog(playerid, false, "4-es rangtól!");
						Cselekves(playerid, "felvette a mesterlövész felszerelést",0);
						ResetWeapon(playerid);
						GiveWeapon(playerid,34,50);
				    }
				    case 7:
				    {
				        if(PlayerInfo[playerid][pRank] < 1) return ShowFelszerelesDialog(playerid, false, "1-es rangtól!");
						Cselekves(playerid, "felvette a légi felszerelést",0);
						ResetWeapon(playerid);
						GiveWeapon(playerid,46,1);
				    }
				    case 8:
				    {
				        if(PlayerInfo[playerid][pRank] < 6) return ShowFelszerelesDialog(playerid, false, "6-os rangtól!");
						Cselekves(playerid, "felvette a magasszintû felszerelést",0);
						ResetWeapon(playerid);
						GiveWeapon(playerid,41,2000);
						GiveWeapon(playerid,22,100);
						GiveWeapon(playerid,30,200);
						GiveWeapon(playerid,25,50);
						GiveWeapon(playerid,29,150);
				    }
				}
			}
		}
		else if(dialogid == DIALOG_DUTY2)
		{
		    ShowFelszerelesDialog(playerid);
		}
		else if(dialogid == DIALOG_AJSZOVEG)
		{
		    if(strlen(inputtext) > 0 && !egyezik(inputtext, JailSzovegek[AJSzoveg[playerid]][0]) && !egyezik(inputtext, EkezetMentes(JailSzovegek[AJSzoveg[playerid]][0])))
			{
				if(strlen(inputtext) > 1)
				{
					AJSzovegHiba[playerid]++;
					if(AJSzovegHiba[playerid] < 3)
					{
						new ido = 20 + strlen( JailSzovegek[ AJSzoveg[playerid] ][0] ) / 6;
						new szoveg[256];
						format(szoveg, 256, "Hibáztál!\nÍrd be a következõ szöveget, betûre pontosan!\n\n\"%s\"\n\nHa beírod, az idõd csökken %d másodperccel", JailSzovegek[ AJSzoveg[playerid] ][0], ido);
						ShowPlayerDialog(playerid, DIALOG_AJSZOVEG, DIALOG_STYLE_INPUT, "Adminjail", szoveg, "Mehet", "");
					}
					else
					{
						ShowPlayerDialog(playerid, DIALOG_NINCS, DIALOG_STYLE_MSGBOX, "Adminjail", "Sajnos túl sokat hibáztál, ezért az idõd nem csökkent\nLegközelebb talán sikerül :)", "OK", "");
						AJSzovegIdo[playerid] = 20;
					}
				}
				else
				{
					ShowPlayerDialog(playerid, DIALOG_NINCS, DIALOG_STYLE_MSGBOX, "Adminjail", "Ne hagyd üresen.. +20mp :)", "OK", "");
					AJSzovegIdo[playerid] = 20;
				}
			}
			else
			{
				new ido = 20 + strlen( JailSzovegek[ AJSzoveg[playerid] ][0] ) / 6;
				if(PlayerInfo[playerid][pJailTime] <= ido)
				{
					PlayerInfo[playerid][pJailTime] = 0;
					PlayerInfo[playerid][pJailed] = BORTON_NINCS;
					ResetVW(playerid);
				   	SetPlayerPos(playerid, 1480.612548, -1743.773803, 13.546875);
					new szoveg[120];
					format(szoveg, 120, "Az adminjail idõd letelt\nReméljük, hogy legközelebb átgondolod, mielõtt rosszat teszel!");
					ShowPlayerDialog(playerid, DIALOG_NINCS, DIALOG_STYLE_MSGBOX, "Adminjail", szoveg, "OK", "");
				}
				else
				{
					new szoveg[90];
					format(szoveg, 90, "Az idõd csökkent %d másodperccel, csak így tovább! :)", ido);
					ShowPlayerDialog(playerid, DIALOG_NINCS, DIALOG_STYLE_MSGBOX, "Adminjail", szoveg, "OK", "");
					PlayerInfo[playerid][pJailTime] -= ido;
					AJSzovegIdo[playerid] = 20;
				}
			}
			return 1;
		}
		else if(dialogid == RADIODIALOG)
		{
			if(!Sofor(playerid)) return 1;
			switch(listitem)
			{
				case 0: // Zene lejátszás rádióból
				{
					new RadioStr[512];
					for(new g = 0; g < sizeof(VehicleRadioName); g++)
					{
						if(g == 0) {
							Format(RadioStr, "%s", VehicleRadioName[0]);
						} else {
							Format(RadioStr, "%s\n%s", RadioStr, VehicleRadioName[g]);
						}
					}
					
					ShowPlayerDialog(playerid, DIALOG_RADIODIALOG_RADIO, DIALOG_STYLE_LIST, "Rádiócsatornák", RadioStr, "Hallgatom", "Mégse");
				}
				case 1: // Zene lejátszás URL-bõl
				{
					PlayerText[playerid] = "Írd be a zene URL címét!\n\nEngedélyezett kiterjesztések: .mp3, .ogg";					
					ShowPlayerDialog(playerid, DIALOG_RADIODIALOG_URL, DIALOG_STYLE_INPUT, "Saját zene lejátszása", PlayerText[playerid], "Lejátszás", "Mégse");
				}
				case 2: // Zene lejátszás YT linkbõl
				{
					PlayerText[playerid] = "Írd be a videó URL címét!\n\nPélda: https://www.youtube.com/watch?v=h7UCUHCNcXc";					
					ShowPlayerDialog(playerid, DIALOG_RADIODIALOG_YT, DIALOG_STYLE_INPUT, "Saját zene lejátszása", PlayerText[playerid], "Lejátszás", "Mégse");
				}
				case 3: // Kikapcsol
				{
					new kocsi = GetPlayerVehicleID(playerid);
					ApplyAnimation(playerid, "ped", "CAR_tune_radio",4.0,0,0,1,0,0);
					Cselekves(playerid, "kikapcsolta a rádiót.", 0);
					VehicleRadio[kocsi] = 0;
					
					strmid(KocsiZeneURL[kocsi], NINCSKOCSIZENE_URL, 0, strlen(NINCSKOCSIZENE_URL), 256);
					
					PlayerForeach(x)
					{
						if(IsPlayerInVehicle(x, kocsi))
						{
							StopAudioStreamForPlayer(x);
						}
					}
				}
			}
		}
		else if(dialogid == DIALOG_RADIODIALOG_RADIO)
		{
			new kocsi = GetPlayerVehicleID(playerid);
			ApplyAnimation(playerid, "ped", "CAR_tune_radio",4.0,0,0,1,0,0);
			MsgFormat(playerid, "Csatorna átváltva! Csatorna: %s", VehicleRadioName[listitem]);
			Cselekves(playerid, "átkapcsolta a rádiót egy másik csatornára.", 0);
			VehicleRadio[kocsi] = listitem;
			
			strmid(KocsiZeneURL[kocsi], ZeneURL[VehicleRadio[kocsi]], 0, strlen(ZeneURL[VehicleRadio[kocsi]]), 256);
			
			PlayerForeach(i)
			{
				if(IsPlayerInVehicle(i, kocsi))
				{
					if(TogRadio[i] == 0)
					{
						StopAudioStreamForPlayer(i);
						SetTimerEx("StartRadio", 500, false, "d", i);
					}
				}
			}
		}
		else if(dialogid == DIALOG_RADIODIALOG_URL)
		{
			new kocsi = GetPlayerVehicleID(playerid);
			ApplyAnimation(playerid, "ped", "CAR_tune_radio",4.0,0,0,1,0,0);
			Cselekves(playerid, "átkapcsolta a rádiót egy másik csatornára.", 0);
			//VehicleRadio[kocsi] = inputtext;
			
			strmid(KocsiZeneURL[kocsi], inputtext, 0, strlen(inputtext), 256);
			
			PlayerForeach(x)
			{
				if(IsPlayerInVehicle(x, kocsi))
				{
					StopAudioStreamForPlayer(x);
					PlayAudioStreamForPlayer(x, inputtext);
				}
			}
		}
		else if(dialogid == HIFI_RADIODIALOG)
		{
			new h = -1;
			for(new i=1;i<MAXHIFI;i++)
			{
				if(IsPlayerInRangeOfPoint(playerid, 6, HifiInfo[i][hX], HifiInfo[i][hY], HifiInfo[i][hZ]))
				{
					h = i;
					break;
				}
			}
			if(h == -1) return Msg(playerid,"Nem vagy hifi mellett!");
			
			PlayerForeach(x)
			{
				if(IsPlayerInRangeOfPoint(x, MAX_HIFI_DISTANCE, HifiInfo[h][hX], HifiInfo[h][hY], HifiInfo[h][hZ]))
				{
					StopAudioStreamForPlayer(x);
					PlayAudioStreamForPlayer(x, ZeneURL[listitem], HifiInfo[h][hX], HifiInfo[h][hY], HifiInfo[h][hZ], MAX_HIFI_DISTANCE, 1);
					strmid(HifiZene[x], ZeneURL[listitem], 0, strlen(ZeneURL[listitem]), 256);
					strmid(HifiInfo[h][hURL], ZeneURL[listitem], 0, strlen(ZeneURL[listitem]), 256);
				}
			}
			new cselekves[72];
			Format(cselekves, "átállította a Hifi-n a rádiófrekvenciát a következõre: %s", VehicleRadioName[listitem]);
			Cselekves(playerid, cselekves, 0);
		}
		else if(dialogid == DIALOG_RACETUNING)
		{
			if(PlayerRaceInfo[playerid][xVersenyen] == NINCS || GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return 1;
			listitem++;
		//	new kocsi = GetPlayerVehicleID(playerid);
			switch(listitem)
			{
				case 1:
				{
					Msg(playerid, "Kiszedve!");
				}
				case 2:
				{
					Msg(playerid, "Kiszedve!");
				}
				case 3:
				{
					Msg(playerid, "Kiszedve!");
				}
				case 4:
				{
					Msg(playerid, "Kiszedve!");
				}
				case 5:
				{
					if(PlayerRaceTuning[playerid][tKasztni] >= 1)
						return ShowTuningDialog(playerid, false, "Hiba: Már van alap kasztni erõsítés ezen a jármûvön!");
					else if(!PenzLevesz(playerid, 1000000))
						return ShowTuningDialog(playerid, false, "Hiba: Ez a fejlesztés 1,000,000Ftba kerül");
					
					PlayerRaceTuning[playerid][tKasztni] = 1;
					SetVehicleHealth(GetPlayerVehicleID(playerid), 2000.0);
					ShowTuningDialog(playerid, false, "Sikeresen megvásároltad: Alap Kasztni erõsítés");
					Cselekves(playerid, "vett egy alap kasztni erõsítést");
				}
				case 6:
				{
					if(PlayerRaceTuning[playerid][tKasztni] == 2)
						return ShowTuningDialog(playerid, false, "Hiba: Már van fejlett kasztni erõsítés ezen a jármûvön!");
					else if(!PenzLevesz(playerid, 5000000))
						return ShowTuningDialog(playerid, false, "Hiba: Ez a fejlesztés 5,000,000Ftba kerül");
					
					PlayerRaceTuning[playerid][tKasztni] = 2;
					SetVehicleHealth(GetPlayerVehicleID(playerid), 5000.0);
					RepairVehicle(GetPlayerVehicleID(playerid));
					ShowTuningDialog(playerid, false, "Sikeresen megvásároltad: Fejlett Kasztni erõsítés");
					Cselekves(playerid, "vett egy fejlett kasztni erõsítést");
				}
				case 7:
				{
					if(PlayerRaceTuning[playerid][tKasztni] == 3)
						return ShowTuningDialog(playerid, false, "Hiba: Már van extra kasztni erõsítés a jármûvön!");
					else if(!PenzLevesz(playerid, 10000000))
						return ShowTuningDialog(playerid, false, "Hiba: Ez a fejlesztés 10,000,000Ftba kerül");
					
					PlayerRaceTuning[playerid][tKasztni] = 3;
					SetVehicleHealth(GetPlayerVehicleID(playerid), 10000.0);
					RepairVehicle(GetPlayerVehicleID(playerid));
					ShowTuningDialog(playerid, false, "Sikeresen megvásároltad: Extra Kasztni erõsítés");
					Cselekves(playerid, "vett egy extra kasztni erõsítést");
				}
				case 8:
				{
					if(PlayerRaceTuning[playerid][tEMP] >= 1)
						return ShowTuningDialog(playerid, false, "Hiba: Már van ilyen vagy erõsebb Trafipax védelem a kocsidon!");
					else if(!PenzLevesz(playerid, 250000))
						return ShowTuningDialog(playerid, false, "Hiba: Ez a fejlesztés 250,000Ftba kerül");
					
					PlayerRaceTuning[playerid][tEMP] = 1;
					ShowTuningDialog(playerid, false, "Sikeresen megvásároltad: Minimális Trafipax védelem");
					Cselekves(playerid, "vett egy minimális EMP védelmet");
				}
				case 9:
				{
					if(PlayerRaceTuning[playerid][tEMP] >= 2)
						return ShowTuningDialog(playerid, false, "Hiba: Már van ilyen vagy erõsebb Trafipax védelem a kocsidon!");
					else if(!PenzLevesz(playerid, 500000))
						return ShowTuningDialog(playerid, false, "Hiba: Ez a fejlesztés 500,000Ftba kerül");
					
					PlayerRaceTuning[playerid][tEMP] = 2;
					ShowTuningDialog(playerid, false, "Sikeresen megvásároltad: Közepes Trafipax védelem");
					Cselekves(playerid, "vett egy közepes EMP védelmet");
				}
				case 10:
				{
					if(PlayerRaceTuning[playerid][tEMP] == 3)
						return ShowTuningDialog(playerid, false, "Hiba: Már van ilyen Trafipax védelem a kocsidon!");
					else if(!PenzLevesz(playerid, 1000000))
						return ShowTuningDialog(playerid, false, "Hiba: Ez a fejlesztés 1,000,000Ftba kerül");
					
					PlayerRaceTuning[playerid][tEMP] = 3;
					ShowTuningDialog(playerid, false, "Sikeresen megvásároltad: Felett Trafipax védelem");
					Cselekves(playerid, "vett egy fejlett EMP védelmet");
				}
			}
		}
		else if(dialogid == DIALOG_RACETUNING_2)
		{
			ShowTuningDialog(playerid);
			return 1;
		}
		/*else if(dialogid == DIALOG_VESZ_AUTOS)
		{
			listitem++;
			switch(listitem)
			{
				case 1:
				{
					if(GetMoney(playerid, true) < 20000)
					{
						format(string, sizeof(string), "Ezt nem tudod kifizetni! \n");
						ShowPlayerDialog(playerid, DIALOG_VESZ_AUTOS, DIALOG_STYLE_MSGBOX, "{FF0000}Hiba", string, "Bezár", "");
						TogglePlayerControllable(playerid, true);
						return 1;
					}
					if(Felni[playerid] != 0)
					{
						format(string, sizeof(string), "Már van ilyened! \n");
						ShowPlayerDialog(playerid, DIALOG_VESZ_AUTOS, DIALOG_STYLE_MSGBOX, "{FF0000}Hiba", string, "Bezár", "");
						TogglePlayerControllable(playerid, true);
						return 1;
					}
					GiveMoney(playerid, -20000, true);
					BizPenz(BIZ_CARPART, 20000);
					Felni[playerid] = 1;
					format(string, sizeof(string), "Vettél egy Felnit, felszerelés: /tuning parancs!\n");
					ShowPlayerDialog(playerid, DIALOG_VESZ_AUTOS, DIALOG_STYLE_MSGBOX, "24/7", string, "Bezár", "");
					Cselekves(playerid, "vett egy felnit", 1);
					TogglePlayerControllable(playerid, true);
					//BizzInfo[BIZ_CARPART][bProducts] --;
				}
				case 2:
				{
					if(GetMoney(playerid, true) < 1000000)
					{
						format(string, sizeof(string), "Ezt nem tudod kifizetni! \n");
						//format(gondolat, sizeof(gondolat), "%s gondolja...", PlayerName(playerid));
						ShowPlayerDialog(playerid, DIALOG_VESZ_AUTOS, DIALOG_STYLE_MSGBOX, "{FF0000}Hiba", string, "Bezár", "");
						TogglePlayerControllable(playerid, true);
						return 1;
					}
					if(BuyedMatrica[playerid] != 0)
					{
						format(string, sizeof(string), "Már van ilyened! \n");
						//format(gondolat, sizeof(gondolat), "%s gondolja...", PlayerName(playerid));
						ShowPlayerDialog(playerid, DIALOG_VESZ_AUTOS, DIALOG_STYLE_MSGBOX, "{FF0000}Hiba", string, "Bezár", "");
						TogglePlayerControllable(playerid, true);
						return 1;
					}
					GiveMoney(playerid, -1000000, true);
					BizPenz(BIZ_CARPART, 1000000);
					BuyedMatrica[playerid] = 1;
					format(string, sizeof(string), "Vettél egy Matricát, felszerelés: /tuning parancs!\n");
					ShowPlayerDialog(playerid, DIALOG_VESZ_AUTOS, DIALOG_STYLE_MSGBOX, "24/7", string, "Bezár", "");
					Cselekves(playerid, "vett egy matricát", 1);
					TogglePlayerControllable(playerid, true);
					//BizzInfo[BIZ_CARPART][bProducts] --;
				}
				case 3:
				{
					if(GetMoney(playerid, true) < 500000)
					{
						format(string, sizeof(string), "Ezt nem tudod kifizetni! \n");
						//format(gondolat, sizeof(gondolat), "%s gondolja...", PlayerName(playerid));
						ShowPlayerDialog(playerid, DIALOG_VESZ_AUTOS, DIALOG_STYLE_MSGBOX, "{FF0000}Hiba", string, "Bezár", "");
						TogglePlayerControllable(playerid, true);
						return 1;
					}
					if(NeOn[playerid] != 0)
					{
						format(string, sizeof(string), "Már van ilyened! \n");
						//format(gondolat, sizeof(gondolat), "%s gondolja...", PlayerName(playerid));
						ShowPlayerDialog(playerid, DIALOG_VESZ_AUTOS, DIALOG_STYLE_MSGBOX, "{FF0000}Hiba", string, "Bezár", "");
						TogglePlayerControllable(playerid, true);
						return 1;
					}
					GiveMoney(playerid, -500000, true);
					BizPenz(BIZ_CARPART, 500000);
					NeOn[playerid] = 1;
					format(string, sizeof(string), "Vettél egy Neon készletet, felszerelés: /tuning parancs!\n");
					ShowPlayerDialog(playerid, DIALOG_VESZ_AUTOS, DIALOG_STYLE_MSGBOX, "24/7", string, "Bezár", "");
					Cselekves(playerid, "vett egy neont", 1);
					TogglePlayerControllable(playerid, true);
					//BizzInfo[BIZ_CARPART][bProducts] --;
				}
				case 4:
				{
					if(GetMoney(playerid, true) < 12500)
					{
						format(string, sizeof(string), "Ezt nem tudod kifizetni! \n");
						//format(gondolat, sizeof(gondolat), "%s gondolja...", PlayerName(playerid));
						ShowPlayerDialog(playerid, DIALOG_VESZ, DIALOG_STYLE_MSGBOX, uzletnev, string, "Bezárás", "");
						TogglePlayerControllable(playerid, true);
						return 1;
					}
					if(PotKerek[playerid] == 1)
					{
						format(string, sizeof(string), "Már van ilyened! \n");
						//format(gondolat, sizeof(gondolat), "%s gondolja...", PlayerName(playerid));
						ShowPlayerDialog(playerid, DIALOG_VESZ, DIALOG_STYLE_MSGBOX, uzletnev, string, "Bezárás", "");
						TogglePlayerControllable(playerid, true);
						return 1;
					}
					GiveMoney(playerid, -12500, true);
					BizPenz(BIZ_CARPART, 12500);
					PotKerek[playerid] = 1;
					KezObject_Felrak(playerid,1098, "jobb");
					format(string, sizeof(string), "Vettél egy pótkereket!\n");
					ShowPlayerDialog(playerid, DIALOG_VESZ, DIALOG_STYLE_MSGBOX, uzletnev, string, "Bezárás", "");
					Cselekves(playerid, "vett egy pótkereket", 1);
					//BizzInfo[BIZ_CARPART][bProducts] --;
					TogglePlayerControllable(playerid, true);

				}
				case 5:
				{
				    if(GetMoney(playerid, true) < 50000)
					{
						format(string, sizeof(string), "Ezt nem tudod kifizetni! \n");
						//format(gondolat, sizeof(gondolat), "%s gondolja...", PlayerName(playerid));
						ShowPlayerDialog(playerid, DIALOG_VESZ, DIALOG_STYLE_MSGBOX, uzletnev, string, "Bezárás", "");
						TogglePlayerControllable(playerid, true);
						return 1;
					}
					if(PlayerInfo[playerid][pLokator] == 1)
					{
						format(string, sizeof(string), "Már van ilyened! \n");
						//format(gondolat, sizeof(gondolat), "%s gondolja...", PlayerName(playerid));
						ShowPlayerDialog(playerid, DIALOG_VESZ, DIALOG_STYLE_MSGBOX, uzletnev, string, "Bezárás", "");
						TogglePlayerControllable(playerid, true);
						return 1;
					}
					GiveMoney(playerid, -50000, true);
					BizPenz(BIZ_CARPART, 50000);
					PlayerInfo[playerid][pLokator] = 1;
					format(string, sizeof(string), "Vettél egy GPS Lokátort!\n");
					ShowPlayerDialog(playerid, DIALOG_VESZ, DIALOG_STYLE_MSGBOX, uzletnev, string, "Bezárás", "");
					Cselekves(playerid, "vett egy GPS Lokátort", 1);
					//BizzInfo[BIZ_CARPART][bProducts] --;
					TogglePlayerControllable(playerid, true);
				}
				case 6:
				{
				    if(GetMoney(playerid, true) < 50000)
					{
						format(string, sizeof(string), "Ezt nem tudod kifizetni! \n");
						//format(gondolat, sizeof(gondolat), "%s gondolja...", PlayerName(playerid));
						ShowPlayerDialog(playerid, DIALOG_VESZ, DIALOG_STYLE_MSGBOX, uzletnev, string, "Bezárás", "");
						TogglePlayerControllable(playerid, true);
						return 1;
					}
					if(PlayerInfo[playerid][pSzerszamoslada] > 0)
					{
						format(string, sizeof(string), "Már van ilyened! \n");
						//format(gondolat, sizeof(gondolat), "%s gondolja...", PlayerName(playerid));
						ShowPlayerDialog(playerid, DIALOG_VESZ, DIALOG_STYLE_MSGBOX, uzletnev, string, "Bezárás", "");
						TogglePlayerControllable(playerid, true);
						return 1;
					}
					GiveMoney(playerid, -50000, true);
					BizPenz(BIZ_CARPART, 50000);
					PlayerInfo[playerid][pSzerszamoslada] = 10;
					format(string, sizeof(string), "Vettél egy szerszámos ládát!\n");
					ShowPlayerDialog(playerid, DIALOG_VESZ, DIALOG_STYLE_MSGBOX, uzletnev, string, "Bezárás", "");
					Cselekves(playerid, "vett egy szerszámos ládát", 1);
					//BizzInfo[BIZ_CARPART][bProducts] --;
					TogglePlayerControllable(playerid, true);
				}
			}
		}
		else if(dialogid == DIALOG_VESZ_HALAS)
		{

			listitem++;
			switch(listitem)
			{
				case 1:
				{
					if(GetMoney(playerid, true) < 15000)
					{
						format(string, sizeof(string), "Ezt nem tudod kifizetni! \n");
						//format(gondolat, sizeof(gondolat), "%s gondolja...", PlayerName(playerid));
						ShowPlayerDialog(playerid, DIALOG_VESZ_HALAS, DIALOG_STYLE_MSGBOX, "{FF0000}Hiba", string, "Bezár", "");
						TogglePlayerControllable(playerid, true);
						return 1;
					}
					if(PlayerInfo[playerid][pBot] != 0)
					{
						format(string, sizeof(string), "Már van ilyened! \n");
						//format(gondolat, sizeof(gondolat), "%s gondolja...", PlayerName(playerid));
						ShowPlayerDialog(playerid, DIALOG_VESZ_HALAS, DIALOG_STYLE_MSGBOX, "{FF0000}Hiba", string, "Bezár", "");
						TogglePlayerControllable(playerid, true);
						return 1;
					}
					GiveMoney(playerid, -15000, true);
					BizPenz(BIZ_HORGASZBOLT, 15000);
					PlayerInfo[playerid][pBot] = 1;
					Cselekves(playerid, "vett egy horgászbotot", 1);
					TogglePlayerControllable(playerid, true);
					//BizzInfo[BIZ_HORGASZBOLT][bProducts] --;
				}
				case 2:
				{
					if(GetMoney(playerid, true) < 5000)
					{
						format(string, sizeof(string), "Ezt nem tudod kifizetni! \n");
						//format(gondolat, sizeof(gondolat), "%s gondolja...", PlayerName(playerid));
						ShowPlayerDialog(playerid, DIALOG_VESZ_HALAS, DIALOG_STYLE_MSGBOX, "{FF0000}Hiba", string, "Bezár", "");
						TogglePlayerControllable(playerid, true);
						return 1;
					}
					GiveMoney(playerid, -5000, true);
					BizPenz(BIZ_HORGASZBOLT, 5000);
					PlayerInfo[playerid][pDamil] += 10;
					Cselekves(playerid, "vett egy 10méteres damil tekercset", 1);
					TogglePlayerControllable(playerid, true);
					//BizzInfo[BIZ_HORGASZBOLT][bProducts] --;
				}
				case 3:
				{
					if(GetMoney(playerid, true) < 7000)
					{
						format(string, sizeof(string), "Ezt nem tudod kifizetni! \n");
						//format(gondolat, sizeof(gondolat), "%s gondolja...", PlayerName(playerid));
						ShowPlayerDialog(playerid, DIALOG_VESZ_HALAS, DIALOG_STYLE_MSGBOX, "{FF0000}Hiba", string, "Bezár", "");
						TogglePlayerControllable(playerid, true);
						return 1;
					}
					GiveMoney(playerid, -7000, true);
					BizPenz(BIZ_HORGASZBOLT, 7000);
					PlayerInfo[playerid][pDamil] += 20;
					Cselekves(playerid, "vett egy 20méteres damil tekercset", 1);
					TogglePlayerControllable(playerid, true);
					//BizzInfo[BIZ_HORGASZBOLT][bProducts] --;
				}
				case 4:
				{
					if(GetMoney(playerid, true) < 12000)
					{
						format(string, sizeof(string), "Ezt nem tudod kifizetni! \n");
						//format(gondolat, sizeof(gondolat), "%s gondolja...", PlayerName(playerid));
						ShowPlayerDialog(playerid, DIALOG_VESZ_HALAS, DIALOG_STYLE_MSGBOX, "{FF0000}Hiba", string, "Bezár", "");
						TogglePlayerControllable(playerid, true);
						return 1;
					}
					GiveMoney(playerid, -12000, true);
					BizPenz(BIZ_HORGASZBOLT, 12000);
					PlayerInfo[playerid][pDamil] += 30
					Cselekves(playerid, "vett egy 30méteres damil tekercset", 1);
					TogglePlayerControllable(playerid, true);
					//BizzInfo[BIZ_HORGASZBOLT][bProducts] --;
				}
				case 5:
				{
					if(GetMoney(playerid, true) < 1000)
					{
						format(string, sizeof(string), "Ezt nem tudod kifizetni! \n");
						//format(gondolat, sizeof(gondolat), "%s gondolja...", PlayerName(playerid));
						ShowPlayerDialog(playerid, DIALOG_VESZ_HALAS, DIALOG_STYLE_MSGBOX, "{FF0000}Hiba", string, "Bezár", "");
						TogglePlayerControllable(playerid, true);
						return 1;
					}
					GiveMoney(playerid, -1000, true);
					BizPenz(BIZ_HORGASZBOLT, 1000);
					PlayerInfo[playerid][pCsali] += 5;
					Cselekves(playerid, "vett egy small csalicsomagot", 1);
					TogglePlayerControllable(playerid, true);
					//BizzInfo[BIZ_HORGASZBOLT][bProducts] --;
				}
				case 6:
				{
					if(GetMoney(playerid, true) < 1750)
					{
						format(string, sizeof(string), "Ezt nem tudod kifizetni! \n");
						//format(gondolat, sizeof(gondolat), "%s gondolja...", PlayerName(playerid));
						ShowPlayerDialog(playerid, DIALOG_VESZ_HALAS, DIALOG_STYLE_MSGBOX, "{FF0000}Hiba", string, "Bezár", "");
						TogglePlayerControllable(playerid, true);
						return 1;
					}
					GiveMoney(playerid, -1750, true);
					BizPenz(BIZ_HORGASZBOLT, 1750);
					PlayerInfo[playerid][pCsali] += 10;
					Cselekves(playerid, "vett egy medium csalicsomagot", 1);
					TogglePlayerControllable(playerid, true);
					//BizzInfo[BIZ_HORGASZBOLT][bProducts] --;
				}
				case 7:
				{
					if(GetMoney(playerid, true) < 3000)
					{
						format(string, sizeof(string), "Ezt nem tudod kifizetni! \n");
						//format(gondolat, sizeof(gondolat), "%s gondolja...", PlayerName(playerid));
						ShowPlayerDialog(playerid, DIALOG_VESZ_HALAS, DIALOG_STYLE_MSGBOX, "{FF0000}Hiba", string, "Bezár", "");
						TogglePlayerControllable(playerid, true);
						return 1;
					}
					GiveMoney(playerid, -3000, true);
					BizPenz(BIZ_HORGASZBOLT, 3000);
					PlayerInfo[playerid][pCsali] += 20;
					Cselekves(playerid, "vett egy extra csalicsomagot", 1);
					TogglePlayerControllable(playerid, true);
					//BizzInfo[BIZ_HORGASZBOLT][bProducts] --;
				}
			}
		}
		else if(dialogid == DIALOG_VESZ_ILLEGAL)
		{
			listitem++;
			switch(listitem)
			{
			    case 1:
			    {
					if(PlayerInfo[playerid][pCsavarhuzo] != 0)
					{
						Msg(playerid, "Már van csavarhúzód!");
					}
					else if(GetMoney(playerid) >= 13000)
					{
						Cselekves(playerid, "vett egy csavarhúzót",1);
						PlayerInfo[playerid][pCsavarhuzo] = 1;
						GiveMoney(playerid, -13000);
						BizPenz(BIZ_247, 13000);
					}
					else
					{
						Msg(playerid, "Nincs elég pénzed!");
						UnFreeze(playerid);
					}
				}
			}
		}*/
		else if(dialogid == DIALOG_PASSWORDCHECK)
		{			
			format(LoginPassword[playerid], MAX_PASSWORD_HOSSZ, "%s", inputtext);			
			Login2(playerid, DIALOG_PASSWORDCHECK);
			return 1;
		}
		else if(dialogid == DIALOG_SECURITYPASSWORDCHECK)
		{		
			if(strlen(inputtext) < 1)
			{
				PlayerText[playerid] = "Bejelentkezés\nTúl rövid jelszó! (Ne legyen 0 karakter)\nÍrd be újra!\n\nBiztonsági jelszó:";
		
				ShowPlayerDialog(playerid, DIALOG_SECURITYPASSWORDCHECK, DIALOG_STYLE_PASSWORD , "Bejelentkezõ panel", PlayerText[playerid], "Beír", "Kilépés");
				return 1;				
			}
			
			format(LoginPassword[playerid], MAX_PASSWORD_HOSSZ, "%s", inputtext);
			
			Login2(playerid, DIALOG_SECURITYPASSWORDCHECK);
			return 1;
		}
		else if(dialogid == DIALOG_HIFIPANEL)
		{
			new szoveg[128];
			switch(listitem)
			{
				case 0: // Lerak
				{
					if(PlayerInfo[playerid][pHifi] < 1) return Msg(playerid, "Nincs Hifid!");
					new Float:X, Float:Y, Float:Z;
					GetPlayerPos(playerid, X, Y, Z);
					HifiObjectLerakas[playerid] = CreateDynamicObject(2226, X, Y, Z, 0, 0, 0);
					PlayerInfo[playerid][pHifi] --;
					EditDynamicObject(playerid, HifiObjectLerakas[playerid]);
					Msg(playerid, "Most már elhelyezheted a Hifit! Ne feledd, csak reális helyre teheted!");
					
				}
				case 1: // Felvesz
				{
					new h = -1;
					for(new i=1;i<MAXHIFI;i++)
					{
						if(IsPlayerInRangeOfPoint(playerid, 6, HifiInfo[i][hX], HifiInfo[i][hY], HifiInfo[i][hZ]))
						{
							h = i;
							break;
						}
					}
					if(h == -1) return HibaDialog(playerid, "Nincs a közeledben Hifi!", DIALOG_HIFIPANEL);
					
					if(PlayerInfo[playerid][pHifi] >= 1) return HibaDialog(playerid, "Maximum 1 Hifi-d lehet!", DIALOG_HIFIPANEL);
					
					PlayerForeach(x)
					{
						if(IsPlayerInRangeOfPoint(x, 6.0, HifiInfo[h][hX], HifiInfo[h][hY], HifiInfo[h][hZ]))
						{
							StopAudioStreamForPlayer(x);
							strmid(HifiZene[x], "-", 0, strlen("-"), 256);
						}
					}
					HifiInfo[h][hVan] = 0;
					HifiInfo[h][hX] = 0;
					HifiInfo[h][hY] = 0;
					HifiInfo[h][hZ] = -50;
					DestroyDynamicObject(HifiInfo[h][hObject]);
					
					/*new command[128];
					Format(command, "DELETE FROM `"#MYSQL_HIFI_TABLE"` WHERE ID='%d'",HifiInfo[h][hID]);
					mysql_query(command);*/
					Msg(playerid,"Felvetted a Hifi-t!");
					PlayerInfo[playerid][pHifi] ++;
					
				}
				case 2: // Zene lejátszás rádióból
				{
					new h = -1;
					for(new i = 1;i < MAXHIFI; i++)
					{
						if(IsPlayerInRangeOfPoint(playerid, 6, HifiInfo[i][hX], HifiInfo[i][hY], HifiInfo[i][hZ]))
						{
							h = i;
							break;
						}
					}
					if(h == -1) return HibaDialog(playerid, "Nincs a közeledben Hifi!", DIALOG_HIFIPANEL);
					
					new RadioStr[512];
					for(new g = 0; g < sizeof(VehicleRadioName); g++)
					{
						if(g == 0) {
							Format(RadioStr, "%s", VehicleRadioName[0]);
						} else {
							Format(RadioStr, "%s\n%s", RadioStr, VehicleRadioName[g]);
						}
					}

					ShowPlayerDialog(playerid, HIFI_RADIODIALOG, DIALOG_STYLE_LIST, "Sony SRFM55S.CE9 Rádió", RadioStr, "Hallgatom", "Mégse");
				}
				case 3: // Zene lejátszás URL-bõl
				{
					new h = -1;
					for(new i=1;i<MAXHIFI;i++)
					{
						if(IsPlayerInRangeOfPoint(playerid, 6, HifiInfo[i][hX], HifiInfo[i][hY], HifiInfo[i][hZ]))
						{
							h = i;
							break;
						}
					}
					if(h == -1) return HibaDialog(playerid, "Nincs a közeledben Hifi!", DIALOG_HIFIPANEL);
					
					szoveg = "Írd be a videó URL címét!\n\nEngedélyezett kiterjesztések: .mp3, .ogg";
					
					ShowPlayerDialog(playerid, DIALOG_HIFIPANEL_SAJATURL, DIALOG_STYLE_INPUT, "Saját zene lejátszása", szoveg, "Lejátszás", "Mégse");
				}
				case 4: // Kikapcsol
				{
					new h = -1;
					for(new i=1;i<MAXHIFI;i++)
					{
						if(IsPlayerInRangeOfPoint(playerid, 6, HifiInfo[i][hX], HifiInfo[i][hY], HifiInfo[i][hZ]))
						{
							h = i;
							break;
						}
					}
					if(h == -1) return HibaDialog(playerid, "Nincs a közeledben Hifi!", DIALOG_HIFIPANEL);
					
					PlayerForeach(x)
					{
						if(IsPlayerInRangeOfPoint(x, 6.0, HifiInfo[h][hX],HifiInfo[h][hY],HifiInfo[h][hZ]))
						{
							StopAudioStreamForPlayer(x);
							strmid(HifiZene[x],"-", 0, strlen("-"), 256);
							strmid(HifiInfo[h][hURL], "-", 0, strlen("-"), 256);
						}
					}
					Cselekves(playerid, "kikapcsolta a Hifi-t", 0);
				}
			}
			return 1;
		}
		else if(dialogid == DIALOG_HIFIPANEL_SAJATURL)
		{
			if(response)
			{
				new h = -1;
				for(new i=1;i<MAXHIFI;i++)
				{
					if(IsPlayerInRangeOfPoint(playerid, 6, HifiInfo[i][hX], HifiInfo[i][hY], HifiInfo[i][hZ]))
					{
						h = i;
						break;
					}
				}
				if(h == -1) return HibaDialog(playerid, "Nincs a közeledben Hifi!", DIALOG_HIFIPANEL);
				
				PlayerForeach(x)
				{
					if(IsPlayerInRangeOfPoint(x, MAX_HIFI_DISTANCE, HifiInfo[h][hX], HifiInfo[h][hY], HifiInfo[h][hZ]))
					{
						StopAudioStreamForPlayer(x);
						PlayAudioStreamForPlayer(x, inputtext, HifiInfo[h][hX], HifiInfo[h][hY], HifiInfo[h][hZ], MAX_HIFI_DISTANCE, 1);
						strmid(HifiZene[x], inputtext, 0, strlen(inputtext), 256);
						strmid(HifiInfo[h][hURL], inputtext, 0, strlen(inputtext), 256);
					}
				}
				Cselekves(playerid,"berakott egy CD-t a Hifibe.");
			}
			return 1;
		}
		else if(dialogid == DIALOG_HIFIPANEL_YOUTUBEURL)
		{
			if(response)
			{
				new h = -1;
				for(new i=1;i<MAXHIFI;i++)
				{
					if(IsPlayerInRangeOfPoint(playerid, 6, HifiInfo[i][hX], HifiInfo[i][hY], HifiInfo[i][hZ]))
					{
						h = i;
						break;
					}
				}
				if(h == -1) return HibaDialog(playerid, "Nincs a közeledben Hifi!", DIALOG_HIFIPANEL);
				
				new videoid[128], mp3link[128];
				strmid(videoid, inputtext, strfind(inputtext,"v=")+2, strfind(inputtext,"v=")+15);
				Format(mp3link, "http://youtubeinmp3.com/fetch/?video=http://www.youtube.com/watch?v=%s", videoid);
				
				PlayerForeach(x)
				{
					if(IsPlayerInRangeOfPoint(x, MAX_HIFI_DISTANCE, HifiInfo[h][hX], HifiInfo[h][hY], HifiInfo[h][hZ]))
					{
						StopAudioStreamForPlayer(x);						
						PlayAudioStreamForPlayer(x, mp3link, HifiInfo[h][hX], HifiInfo[h][hY], HifiInfo[h][hZ], MAX_HIFI_DISTANCE, 1);
						strmid(HifiZene[x], mp3link, 0, strlen(mp3link), 256);
						strmid(HifiInfo[h][hURL], mp3link, 0, strlen(mp3link), 256);
					}
				}
				Cselekves(playerid,"berakott egy CD-t a Hifibe.");
			}
			return 1;
		}
		else if(dialogid == DIALOG_GOTO)
		{
			Tele(playerid, GPSPos[listitem][0], GPSPos[listitem][1], GPSPos[listitem][2], true, 0, 0);
			PlayerTextFormat(playerid, "~g~Teleportálva ide:~n~~w~%s", GPSNev[listitem][0]);
			GameTextForPlayer(playerid, PlayerText[playerid], 3*1000, 3);
			return 1;
		}
		else if(dialogid == DIALOG_GPS)
		{
			SetPlayerCheckpoint(playerid, GPSPos[listitem][0], GPSPos[listitem][1], GPSPos[listitem][2], 3.0);
			PlayerTextFormat(playerid, "~g~GPS cél beállítva:~n~~w~%s", GPSNev[listitem][0]);
			GameTextForPlayer(playerid, PlayerText[playerid], (3 * 1000), 3);
			return 1;
		}
		else if(dialogid == DIALOG_MUNKAHELYEK)
		{
			SetPlayerCheckpoint(playerid, MunkahelyPos[listitem][0], MunkahelyPos[listitem][1], MunkahelyPos[listitem][2], 3.0);
			PlayerTextFormat(playerid, "~g~GPS cél beállítva:~n~~w~%s", MunkahelyNev[listitem][0]);
			GameTextForPlayer(playerid, PlayerText[playerid], (3 * 1000), 3);
			return 1;
		}
	}
	else //resp0!
	{
		if(dialogid == DIALOG_PASSWORDCHECK || dialogid == DIALOG_SECURITYPASSWORDCHECK)
		{
			//ClearChat(playerid);
			Msg(playerid, "Bezártad a bejelentkezõ panelt, ezért ki lettél rúgva!");
			KickEx(playerid);
			return 1;
		}
		
		if(dialogid == DIALOG_AJSZOVEG)
		{
			AJSzovegIdo[playerid] = 20;
			return 1;
		}
	}
	return 0;
}