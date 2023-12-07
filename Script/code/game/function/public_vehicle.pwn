#if defined __game_function_public_vehicle
	#endinput
#endif
#define __game_function_public_vehicle

fpublic AlapTuning(playerid)
{
	new kocsim;
	kocsim = GetClosestVehicle(playerid);
	if(GetPlayerDistanceFromVehicle(playerid, kocsim) > 5.5) return Msg(playerid, "Nincs a közelben a jármû!");
	new kocsi;
	kocsi = GetVehicleModel(kocsim);
	new biz;
	biz = BIZ_TUNING;
	if(tuningolo[playerid] == 1)
	{
		AddVehicleComponent(kocsim, 1010);
		SendClientMessage(playerid, COLOR_LIGHTRED, "================[Tuning]================");
		SendClientMessage(playerid, COLOR_LIGHTGREEN, "10x Nitró felszerelve!");
		SendClientMessage(playerid, COLOR_LIGHTRED, "================[Tuning]================");
		BankkartyaFizet(playerid, 65000);
		BizPenz(biz, 65000);
		BizzInfo[BIZ_TUNING][bProducts] -= 10;
		tuningolo[playerid] = NINCS;
	}
	if(tuningolo[playerid] == 2)
	{
		AddVehicleComponent(kocsim, 1087);
		SendClientMessage(playerid, COLOR_LIGHTRED, "================[Tuning]================");
		SendClientMessage(playerid, COLOR_LIGHTGREEN, "Hidraulika felszerelve!");
		SendClientMessage(playerid, COLOR_LIGHTRED, "================[Tuning]================");
		BankkartyaFizet(playerid, 35000);
		BizPenz(biz, 35000);
		BizzInfo[BIZ_TUNING][bProducts] -= 15;
		tuningolo[playerid] = NINCS;
	}
	if(tuningolo[playerid] == 3)
	{
			if(kocsi == 560)
			{
				AddVehicleComponent(kocsim, 1026);
				AddVehicleComponent(kocsim, 1027);
				AddVehicleComponent(kocsim, 1032);
				AddVehicleComponent(kocsim, 1169);
				AddVehicleComponent(kocsim, 1138);
				AddVehicleComponent(kocsim, 1141);
				AddVehicleComponent(kocsim, 1028);
				SendClientMessage(playerid, COLOR_LIGHTRED, "================[Tuning]================");
				SendClientMessage(playerid, COLOR_LIGHTGREEN, "ALIEN tuning felszerelve!");
				SendClientMessage(playerid, COLOR_LIGHTRED, "================[Tuning]================");
				BankkartyaFizet(playerid, 75000);
				RepairVehicle(kocsim);
				BizPenz(biz, 75000);
				BizzInfo[BIZ_TUNING][bProducts] -= 50;
				tuningolo[playerid] = NINCS;
			}
			else if(kocsi == 562)
			{
				AddVehicleComponent(kocsim, 1034);
				AddVehicleComponent(kocsim, 1038);
				AddVehicleComponent(kocsim, 1036);
				AddVehicleComponent(kocsim, 1040);
				AddVehicleComponent(kocsim, 1147);
				AddVehicleComponent(kocsim, 1149);
	            AddVehicleComponent(kocsim, 1171);
	            SendClientMessage(playerid, COLOR_LIGHTRED, "================[Tuning]================");
				SendClientMessage(playerid, COLOR_LIGHTGREEN, "ALIEN tuning felszerelve!");
				SendClientMessage(playerid, COLOR_LIGHTRED, "================[Tuning]================");
				BankkartyaFizet(playerid, 75000);
				RepairVehicle(kocsim);
				BizPenz(biz, 75000);
				BizzInfo[BIZ_TUNING][bProducts] -= 50;
				tuningolo[playerid] = NINCS;
			}
            else if(kocsi == 559)
			{
				AddVehicleComponent(kocsim, 1065);
				AddVehicleComponent(kocsim, 1067);
				AddVehicleComponent(kocsim, 1069);
				AddVehicleComponent(kocsim, 1071);
				AddVehicleComponent(kocsim, 1159);
				AddVehicleComponent(kocsim, 1160);
	            AddVehicleComponent(kocsim, 1162);
	            SendClientMessage(playerid, COLOR_LIGHTRED, "================[Tuning]================");
				SendClientMessage(playerid, COLOR_LIGHTGREEN, "ALIEN tuning felszerelve!");
				SendClientMessage(playerid, COLOR_LIGHTRED, "================[Tuning]================");
				BankkartyaFizet(playerid, 75000);
				RepairVehicle(kocsim);
				BizPenz(biz, 75000);
				BizzInfo[BIZ_TUNING][bProducts] -= 50;
				tuningolo[playerid] = NINCS;
			}
            else if(kocsi == 558)
			{
				AddVehicleComponent(kocsim, 1088);
				AddVehicleComponent(kocsim, 1090);
				AddVehicleComponent(kocsim, 1092);
				AddVehicleComponent(kocsim, 1094);
				AddVehicleComponent(kocsim, 1164);
				AddVehicleComponent(kocsim, 1166);
	           	AddVehicleComponent(kocsim, 1168);
	 			SendClientMessage(playerid, COLOR_LIGHTRED, "================[Tuning]================");
				SendClientMessage(playerid, COLOR_LIGHTGREEN, "ALIEN tuning felszerelve!");
				SendClientMessage(playerid, COLOR_LIGHTRED, "================[Tuning]================");
				BankkartyaFizet(playerid, 75000);
				RepairVehicle(kocsim);
				BizPenz(biz, 75000);
				BizzInfo[BIZ_TUNING][bProducts] -= 50;
				tuningolo[playerid] = NINCS;
			}
			else if(kocsi == 561)
			{
				AddVehicleComponent(kocsim, 1055);
				AddVehicleComponent(kocsim, 1056);
				AddVehicleComponent(kocsim, 1058);
				AddVehicleComponent(kocsim, 1062);
				AddVehicleComponent(kocsim, 1064);
				AddVehicleComponent(kocsim, 1154);
	 			AddVehicleComponent(kocsim, 1155);
	 			SendClientMessage(playerid, COLOR_LIGHTRED, "================[Tuning]================");
				SendClientMessage(playerid, COLOR_LIGHTGREEN, "ALIEN tuning felszerelve!");
				SendClientMessage(playerid, COLOR_LIGHTRED, "================[Tuning]================");
				BankkartyaFizet(playerid, 75000);
				RepairVehicle(kocsim);
				BizPenz(biz, 75000);
				BizzInfo[BIZ_TUNING][bProducts] -= 50;
				tuningolo[playerid] = NINCS;
			}
			else if(kocsi == 565)
			{
				AddVehicleComponent(kocsim, 1046);
				AddVehicleComponent(kocsim, 1047);
				AddVehicleComponent(kocsim, 1049);
				AddVehicleComponent(kocsim, 1051);
				AddVehicleComponent(kocsim, 1054);
				AddVehicleComponent(kocsim, 1150);
				AddVehicleComponent(kocsim, 1153);
	            SendClientMessage(playerid, COLOR_LIGHTRED, "================[Tuning]================");
				SendClientMessage(playerid, COLOR_LIGHTGREEN, "ALIEN tuning felszerelve!");
				SendClientMessage(playerid, COLOR_LIGHTRED, "================[Tuning]================");
				BankkartyaFizet(playerid, 75000);
				RepairVehicle(kocsim);
				BizPenz(biz, 75000);
				BizzInfo[BIZ_TUNING][bProducts] -= 50;
				tuningolo[playerid] = NINCS;
			}
			else
			{
	            SendClientMessage(playerid, COLOR_LIGHTRED, "================[Tuning]================");
	            SendClientMessage(playerid, COLOR_LIGHTBLUE, "Sultan,Jester,Uranus,Flash,Stratum,Elegy kocsikra!");
	            SendClientMessage(playerid, COLOR_LIGHTRED, "================[Tuning]================");
				tuningolo[playerid] = NINCS;
	            return 1;
			}
	}
	if(tuningolo[playerid] == 4)
	{
			if(kocsi == 560)
			{
				AddVehicleComponent(kocsim, 1029);
				AddVehicleComponent(kocsim, 1030);
				AddVehicleComponent(kocsim, 1031);
				AddVehicleComponent(kocsim, 1133);
				AddVehicleComponent(kocsim, 1139);
				AddVehicleComponent(kocsim, 1140);
				AddVehicleComponent(kocsim, 1170);
				SendClientMessage(playerid, COLOR_LIGHTRED, "================[Tuning]================");
				SendClientMessage(playerid, COLOR_LIGHTGREEN, "XFLOW tuning felszerelve!");
				SendClientMessage(playerid, COLOR_LIGHTRED, "================[Tuning]================");
				BankkartyaFizet(playerid, 75000);
				RepairVehicle(kocsim);
				BizPenz(biz, 75000);
				BizzInfo[BIZ_TUNING][bProducts] -= 50;
				tuningolo[playerid] = NINCS;
			}
			else if(kocsi == 562)
			{
				AddVehicleComponent(kocsim, 1035);
				AddVehicleComponent(kocsim, 1037);
				AddVehicleComponent(kocsim, 1039);
				AddVehicleComponent(kocsim, 1041);
				AddVehicleComponent(kocsim, 1146);
				AddVehicleComponent(kocsim, 1148);
	            AddVehicleComponent(kocsim, 1172);
	            SendClientMessage(playerid, COLOR_LIGHTRED, "================[Tuning]================");
				SendClientMessage(playerid, COLOR_LIGHTGREEN, "XFLOW tuning felszerelve!");
				SendClientMessage(playerid, COLOR_LIGHTRED, "================[Tuning]================");
				BankkartyaFizet(playerid, 75000);
				RepairVehicle(kocsim);
				BizPenz(biz, 75000);
				BizzInfo[BIZ_TUNING][bProducts] -= 50;
				tuningolo[playerid] = NINCS;
			}
            else if(kocsi == 559)
			{
				AddVehicleComponent(kocsim, 1066);
				AddVehicleComponent(kocsim, 1068);
				AddVehicleComponent(kocsim, 1070);
				AddVehicleComponent(kocsim, 1072);
				AddVehicleComponent(kocsim, 1158);
				AddVehicleComponent(kocsim, 1161);
	            AddVehicleComponent(kocsim, 1173);
	            SendClientMessage(playerid, COLOR_LIGHTRED, "================[Tuning]================");
				SendClientMessage(playerid, COLOR_LIGHTGREEN, "XFLOW tuning felszerelve!");
				SendClientMessage(playerid, COLOR_LIGHTRED, "================[Tuning]================");
				BankkartyaFizet(playerid, 75000);
				RepairVehicle(kocsim);
				BizPenz(biz, 75000);
				BizzInfo[BIZ_TUNING][bProducts] -= 50;
				tuningolo[playerid] = NINCS;
			}
            else if(kocsi == 558)
			{
				AddVehicleComponent(kocsim, 1089);
				AddVehicleComponent(kocsim, 1091);
				AddVehicleComponent(kocsim, 1093);
				AddVehicleComponent(kocsim, 1095);
				AddVehicleComponent(kocsim, 1163);
				AddVehicleComponent(kocsim, 1165);
	 			AddVehicleComponent(kocsim, 1167);
	 			SendClientMessage(playerid, COLOR_LIGHTRED, "================[Tuning]================");
				SendClientMessage(playerid, COLOR_LIGHTGREEN, "XFLOW tuning felszerelve!");
				SendClientMessage(playerid, COLOR_LIGHTRED, "================[Tuning]================");
				BankkartyaFizet(playerid, 75000);
				RepairVehicle(kocsim);
				BizPenz(biz, 75000);
				BizzInfo[BIZ_TUNING][bProducts] -= 50;
				tuningolo[playerid] = NINCS;
			}
			else if(kocsi == 561)
			{
				AddVehicleComponent(kocsim, 1057);
				AddVehicleComponent(kocsim, 1059);
				AddVehicleComponent(kocsim, 1050);
				AddVehicleComponent(kocsim, 1061);
				AddVehicleComponent(kocsim, 1063);
				AddVehicleComponent(kocsim, 1156);
	            AddVehicleComponent(kocsim, 1157);
	            SendClientMessage(playerid, COLOR_LIGHTRED, "================[Tuning]================");
				SendClientMessage(playerid, COLOR_LIGHTGREEN, "XFLOW tuning felszerelve!");
				SendClientMessage(playerid, COLOR_LIGHTRED, "================[Tuning]================");
				BankkartyaFizet(playerid, 75000);
				RepairVehicle(kocsim);
				BizPenz(biz, 75000);
				BizzInfo[BIZ_TUNING][bProducts] -= 50;
				tuningolo[playerid] = NINCS;
			}
			else if(kocsi == 565)
			{
				AddVehicleComponent(kocsim, 1045);
				AddVehicleComponent(kocsim, 1048);
				AddVehicleComponent(kocsim, 1050);
				AddVehicleComponent(kocsim, 1052);
				AddVehicleComponent(kocsim, 1053);
				AddVehicleComponent(kocsim, 1151);
	            AddVehicleComponent(kocsim, 1152);
	            SendClientMessage(playerid, COLOR_LIGHTRED, "================[Tuning]================");
				SendClientMessage(playerid, COLOR_LIGHTGREEN, "XFLOW tuning felszerelve!");
				SendClientMessage(playerid, COLOR_LIGHTRED, "================[Tuning]================");
				BankkartyaFizet(playerid, 75000);
				RepairVehicle(kocsim);
				BizPenz(biz, 75000);
				BizzInfo[BIZ_TUNING][bProducts] -= 50;
				tuningolo[playerid] = NINCS;
			}
			else
			{
	            SendClientMessage(playerid, COLOR_LIGHTRED, "================[Tuning]================");
	            SendClientMessage(playerid, COLOR_LIGHTBLUE, "Sultan,Jester,Uranus,Flash,Stratum,Elegy kocsikra tudok csak!");
	            SendClientMessage(playerid, COLOR_LIGHTRED, "================[Tuning]================");
				tuningolo[playerid] = NINCS;
	            return 1;
			}
	}
	if(tuningolo[playerid] == 5)
	{
		SetVehicleColor(kocsim, Tszin[playerid], Tszin[playerid]);
		//RepairVehicle(kocsim);
		SendClientMessage(playerid, COLOR_LIGHTRED, "================[Tuning]================");
		SendClientMessage(playerid, COLOR_LIGHTGREEN, "Kocsi átfestve!");
		SendClientMessage(playerid, COLOR_LIGHTRED, "================[Tuning]================");
		BankkartyaFizet(playerid, 5000);
		BizPenz(biz, 5000);
		BizzInfo[BIZ_TUNING][bProducts] -= 20;
		Tszin[playerid] = NINCS;
		tuningolo[playerid] = NINCS;
	}
	if(tuningolo[playerid] == 6)
	{
		AddVehicleComponent(kocsim, Tkerek[playerid]);
		SendClientMessage(playerid, COLOR_LIGHTRED, "================[Tuning]================");
		SendClientMessage(playerid, COLOR_LIGHTGREEN, "Új kerék felrakva!");
		SendClientMessage(playerid, COLOR_LIGHTRED, "================[Tuning]================");
		BankkartyaFizet(playerid, 7000);
		BizPenz(biz, 7000);
		BizzInfo[BIZ_TUNING][bProducts] -= 5;
		Tkerek[playerid] = NINCS;
		tuningolo[playerid] = NINCS;
	}
	return 1;
}

fpublic JarmuFeltores(playerid)
{
	if(PlayerCuffed[playerid] == 2) return 1;
	
	MunkaFolyamatban[playerid] = 0;
	UnFreeze(playerid);
	
	if(IsPlayerInAnyVehicle(playerid))
		return 1;
		
	new kozelbenlevojarmu = GetClosestVehicle(playerid);
	new level = SkillLevel(PlayerInfo[playerid][pJackSkill]);
	PlayerInfo[playerid][pJackSkill]++;
	
	if(GetPlayerDistanceFromVehicle(playerid, kozelbenlevojarmu) > 3.0)
		return Msg(playerid, "Nagyon közel kell lenned a jármûhöz.");
		
	if(IsABicikli(kozelbenlevojarmu))
		return Msg(playerid, "Biciklit??-.-");
		
	new sofor = KocsiSofor(kozelbenlevojarmu);
	if(sofor != NINCS)
		return Msg(playerid, "Ha ülnek benne, hogy akarod feltörni??");
		
	if(!Locked(kozelbenlevojarmu))
		return Msg(playerid, "A jármû nyitva, nem kell feltörni.");
		
	new model = GetVehicleModel(kozelbenlevojarmu);
	
		
	new kocsiara = JarmuAra[model-400][jAra];
	
	
	if(kocsiara >= level*KOCSI_LOPAS_SZORZO) return Msg(playerid, "Ehhez a jármûhöz még nem értesz!");
	if(IsARepulo(kozelbenlevojarmu)) return Msg(playerid, "EZ nem KOCSI!");
	if(kocsiara >= 100000000) return Msg(playerid, "Ez meghaladja a tudásod, vagy nem is kocsi?!");
	
	switch(random(4))
	{
		case 1..2:
		{
			SendClientMessage(playerid, COLOR_LIGHTRED, "* A jármû feltörve!");
			UnLockCar(kozelbenlevojarmu);
		}
		default:
		{
			SendClientMessage(playerid, COLOR_LIGHTRED, "* A jármûvet nem sikerült feltörni!");
		}
	}

	
	new vs = IsAVsKocsi(kozelbenlevojarmu);
	if(vs != NINCS)
	{
		new tulajid=OnlineUID(CarInfo[vs][cTulaj]);
		if(KocsiRiaszto[kozelbenlevojarmu] == 1)
		{
			if(CarInfo[vs][cRiaszto] == 1)
			{
				Msg(playerid, "Bekapcsolt a riasztó!");
				Cselekves(playerid, "Megszóltalt egy riasztó...", 2);
				SetJarmu(kozelbenlevojarmu, KOCSI_RIASZTO, 1);
				SetTimerEx("JarmuRiasztoBe", 5000, false, "i", kozelbenlevojarmu);
			}
			else if(CarInfo[vs][cRiaszto] == 2)
			{
				Msg(playerid, "Bekapcsolt a riasztó!");
				Cselekves(playerid, "Megszóltalt egy riasztó...", 2);
				SendFormatMessage(tulajid,COLOR_LIGHTRED,">>[Riasztó]: A CLS - %d rendszámú kocsi riasztója bekapcsolt...",kozelbenlevojarmu);
				SetJarmu(kozelbenlevojarmu, KOCSI_RIASZTO, 1);
				SetTimerEx("JarmuRiasztoBe", 5000, false, "i", kozelbenlevojarmu);
			}
			else if(CarInfo[vs][cRiaszto] == 3)
			{
				Msg(playerid, "Bekapcsolt a riasztó!");
				Cselekves(playerid, "Megszóltalt egy riasztó...", 2);
				new string[90];
				format(string, sizeof(string), ">>[Biztonsági központ]: A CLS - %d rendszámú jármûnek megszólalt a riasztója!<<", kozelbenlevojarmu);
				CopMsg(TEAM_BLUE_COLOR, string);
				SendFormatMessage(tulajid,COLOR_LIGHTRED,">>[Riasztó]: A CLS - %d rendszámú kocsi riasztója bekapcsolt...",kozelbenlevojarmu);
				SetJarmu(kozelbenlevojarmu, KOCSI_RIASZTO, 1);
				SetTimerEx("JarmuRiasztoBe", 5000, false, "i", kozelbenlevojarmu);
			}
			else if(CarInfo[vs][cRiaszto] == 4 && CarInfo[vs][cCodeRiaszto][0] < UnixTime)
			{
				Msg(playerid, "Bekapcsolt a riasztó!");
				Cselekves(playerid, "Megszóltalt egy riasztó...", 2);
				SendFormatMessage(tulajid,COLOR_LIGHTRED,">>[Riasztó]: A CLS - %d rendszámú kocsi riasztója és indításgátlója bekapcsolt!",kozelbenlevojarmu);
				SetJarmu(kozelbenlevojarmu, KOCSI_RIASZTO, 1);
				SetTimerEx("JarmuRiasztoBe", 5000, false, "i", kozelbenlevojarmu);
				Inditasgatlo[kozelbenlevojarmu] = 1;
			}	
			else if(CarInfo[vs][cRiaszto] == 4 && CarInfo[vs][cCodeRiaszto][0] > UnixTime)
			{
				Msg(playerid, "Bekapcsolt a riasztó!");
				Cselekves(playerid, "Megszóltalt egy riasztó...", 2);
				new string[90];
				format(string, sizeof(string), ">>[Biztonsági központ]: A CLS - %d rendszámú jármûnek megszólalt a riasztója!<<", kozelbenlevojarmu);
				CopMsg(TEAM_BLUE_COLOR, string);
				SendFormatMessage(tulajid,COLOR_LIGHTRED,">>[Riasztó]: A CLS - %d rendszámú kocsi riasztója bekapcsolt, de az indításgátlót blokkolták..",kozelbenlevojarmu);
				SetJarmu(kozelbenlevojarmu, KOCSI_RIASZTO, 1);
				SetTimerEx("JarmuRiasztoBe", 5000, false, "i", kozelbenlevojarmu);
			}
		}
	}
	
	return 1;
}

fpublic SisakFel(playerid)
{
	UnFreeze(playerid);
	SisakotVesz[playerid] = 0;
	if(!IsPlayerInAnyVehicle(playerid)) return 1;
	if(IsPlayerAttachedObjectSlotUsed(playerid, ATTACH_SLOT_SISAK)) RemovePlayerAttachedObject(playerid, ATTACH_SLOT_SISAK);
	switch(GetPlayerSkin(playerid))
	{
		#define SPAO{%0,%1,%2,%3,%4,%5} SetPlayerAttachedObject(playerid, ATTACH_SLOT_SISAK, 18645, 2, (%0), (%1), (%2), (%3), (%4), (%5));
		case 0, 65, 74, 149, 208, 273:  SPAO{0.070000, 0.000000, 0.000000, 88.000000, 75.000000, 0.000000}
		case 1..6, 8, 14, 16, 22, 27, 29, 33, 41..49, 82..84, 86, 87, 119, 289: SPAO{0.070000, 0.000000, 0.000000, 88.000000, 77.000000, 0.000000}
		case 7, 10: SPAO{0.090000, 0.019999, 0.000000, 88.000000, 90.000000, 0.000000}
		case 9: SPAO{0.059999, 0.019999, 0.000000, 88.000000, 90.000000, 0.000000}
		case 11..13: SPAO{0.070000, 0.019999, 0.000000, 88.000000, 90.000000, 0.000000}
		case 15: SPAO{0.059999, 0.000000, 0.000000, 88.000000, 82.000000, 0.000000}
		case 17..21: SPAO{0.059999, 0.019999, 0.000000, 88.000000, 82.000000, 0.000000}
		case 23..26, 28, 30..32, 34..39, 57, 58, 98, 99, 104..118, 120..131: SPAO{0.079999, 0.019999, 0.000000, 88.000000, 82.000000, 0.000000}
		case 40: SPAO{0.050000, 0.009999, 0.000000, 88.000000, 82.000000, 0.000000}
		case 50, 100..103, 148, 150..189, 222: SPAO{0.070000, 0.009999, 0.000000, 88.000000, 82.000000, 0.000000}
		case 51..54: SPAO{0.100000, 0.009999, 0.000000, 88.000000, 82.000000, 0.000000}
		case 55, 56, 63, 64, 66..73, 75, 76, 78..81, 133..143, 147, 190..207, 209..219, 221, 247..272, 274..288, 290..293: SPAO{0.070000, 0.019999, 0.000000, 88.000000, 82.000000, 0.000000}
		case 59..62: SPAO{0.079999, 0.029999, 0.000000, 88.000000, 82.000000, 0.000000}
		case 77: SPAO{0.059999, 0.019999, 0.000000, 87.000000, 82.000000, 0.000000}
		case 85, 88, 89: SPAO{0.070000, 0.039999, 0.000000, 88.000000, 82.000000, 0.000000}
		case 90..97: SPAO{0.050000, 0.019999, 0.000000, 88.000000, 82.000000, 0.000000}
		case 132: SPAO{0.000000, 0.019999, 0.000000, 88.000000, 82.000000, 0.000000}
		case 144..146: SPAO{0.090000, 0.000000, 0.000000, 88.000000, 82.000000, 0.000000}
		case 220: SPAO{0.029999, 0.019999, 0.000000, 88.000000, 82.000000, 0.000000}
		case 223, 246: SPAO{0.070000, 0.050000, 0.000000, 88.000000, 82.000000, 0.000000}
		case 224..245: SPAO{0.070000, 0.029999, 0.000000, 88.000000, 82.000000, 0.000000}
		case 294: SPAO{0.070000, 0.019999, 0.000000, 91.000000, 84.000000, 0.000000}
		case 295: SPAO{0.050000, 0.019998, 0.000000, 86.000000, 82.000000, 0.000000}
		case 296..298: SPAO{0.064999, 0.009999, 0.000000, 88.000000, 82.000000, 0.000000}
		case 299: SPAO{0.064998, 0.019999, 0.000000, 88.000000, 82.000000, 0.000000}
		case 300..311: SPAO{0.070000, 0.019999, 0.000000, 88.000000, 82.000000, 0.000000}
	}
	Sisak[playerid] = 1;
	Msg(playerid, "Felvetted a bukósisakot.");
	Cselekves(playerid, "felvette a bukósisakot...");
	return 1;
}

fpublic JarmuRiasztoBe(carid)
{
	if(GetJarmu(carid, KOCSI_RIASZTO) == 1)
	{
		SetJarmu(carid, KOCSI_RIASZTO, 1);
		SetTimerEx("JarmuRiasztoBe", 5000, false, "i", carid);
	}
}

fpublic JarmuRiaszto(playerid)
{
		UnFreeze(playerid);
		if(!IsPlayerInAnyVehicle(playerid)) return 1;
		SendClientMessage(playerid, COLOR_LIGHTRED, "* Riasztó kikapcsolva!");
		if(KocsiRiaszto[GetPlayerVehicleID(playerid)] == 1)
			KocsiRiaszto[GetPlayerVehicleID(playerid)] = 0;
		SetJarmu(GetPlayerVehicleID(playerid), KOCSI_RIASZTO, 0);
		return 1;
}

fpublic Startup(playerid, vehicleid)
{
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return 1;

	if(IsABicikli(vehicleid)) SetJarmu(vehicleid, KOCSI_MOTOR, 1);
	else if(engineOn[vehicleid]) SetJarmu(vehicleid, KOCSI_MOTOR, 1);
	else if(IsKocsi(vehicleid, "Gokart"))	return SendClientMessage(playerid, COLOR_YELLOW, "Bérelhetõ Gokart! ((/gokartozás indít");
	else
	{
		SetJarmu(vehicleid, KOCSI_MOTOR, 0);
		SendClientMessage(playerid, COLOR_YELLOW, "A motort a /motor paranccsal, vagy a SPACE lenyomásával indíthatod, vagy ha nincs kulcsod /ellop");
	}

	return 1;
}

fpublic EngineBreak()
{
	foreach(Jatekosok, player)
	{
		if(!IsPlayerInAnyVehicle(player)) continue;
		new Float:vHealth, car;
		car = GetPlayerVehicleID(player);
		GetVehicleHealth(car, vHealth);
		if(IsPlayerInAnyVehicle(player))
		if(vHealth < 350)
		{
			if(RoncsDerby[player][rdVersenyez])
				RoncsDerbiKieses(player);
			else
			{
				SetVehicleHealth(car, 350);
				Msg(player, "Elromlott a jármûved, hívj szerelõt! (/service mechanic)");
				engineOn[car] = 0;
				Gyujtas[car] = false;
				SetJarmu(car, KOCSI_MOTOR, 0);
			}
		}
	}

	return 1;
}

