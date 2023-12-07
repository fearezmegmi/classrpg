public OnPlayerModelSelection(playerid, response, listid, modelid)
{
	if(listid == ruhaboltskinlista)
	{
		if(response)
	    {
			new ruhaar = 50;
			if(GetMoney(playerid) < ruhaar) 
			{
				MsgFormat(playerid,  "Nincs elég pénzed! Egy ruha ára $%d!",  ruhaar);
				return 1;
			}
			else
			{
				iMsg(playerid,  "Vettél egy ruhát");
				Cselekves(playerid,  "vett egy ruhát");
				SetPlayerSkin(playerid,  modelid);
				PlayerInfo[playerid][pModel] = modelid;
				GiveMoney(playerid,  -ruhaar, true);
			}
		}
	}
	else if(listid == osszesjarmulista)
	{
	    if(response)
	    {
			if(egyezik(UtolsoCMD[playerid],  "/veh"))
			{
				UjAdminJarmu(playerid,  modelid);
			}
			else if(egyezik(UtolsoCMD[playerid],  "/újmodel"))
			{
				UjJarmuModel(playerid,  modelid);
			}
			else if(egyezik(UtolsoCMD[playerid],  "/vehlist"))
			{
				new kocsiar = KereskedesArlista(modelid);				
				MsgFormat(playerid,  "Jármû model ID: %d | Ára: $%d | Típus: %s",  modelid,  kocsiar,  GetVehicleModelName(modelid));
			}
		}
	}
	else if(listid == pickuplista)
	{
	    if(response)
	    {
			new ajtoszama = GetPVarInt(playerid,  "EditedAjtoID");
			if(!IsValidPickupObject(modelid)) { MsgFormat(playerid,  "Hibás PickupID! [%d]",  modelid); return 1; }
			Ajtok[ajtoszama][PickupID] = modelid;
			UpdateAjto3D(ajtoszama);
			Msg(playerid,  "Ajtó Pickup-ja módosítva!",  COLOR_ADMIN);
		}
	}
	else if(listid == jarmuberleslista)
	{
	    if(response)
	    {
			new berlesar;
			if(Szint(playerid) > 3) berlesar = 1500;
			else berlesar = 250;
			
			if(GetMoney(playerid) < berlesar) 
			{
				MsgFormat(playerid,  "Nincs elég pénzed a jármû bérléséhez! (szükséges: $%d)!",  berlesar);
				return 1;
			}
			else
			{
				GiveMoney(playerid,  -berlesar);
				SpawnPozicio[playerid] = random(sizeof(BerelhetoKocsiSpawn));
				BereltKocsi[playerid] = UjKocsi(modelid, BerelhetoKocsiSpawn[SpawnPozicio[playerid]][0], BerelhetoKocsiSpawn[SpawnPozicio[playerid]][1], BerelhetoKocsiSpawn[SpawnPozicio[playerid]][2], BerelhetoKocsiSpawn[SpawnPozicio[playerid]][3], RandomVehicleColor(), RandomVehicleColor());
				SetPlayerCheckpoint(playerid, BerelhetoKocsiSpawn[SpawnPozicio[playerid]][0], BerelhetoKocsiSpawn[SpawnPozicio[playerid]][1], BerelhetoKocsiSpawn[SpawnPozicio[playerid]][2], 8.0);
				UnLockCar(BereltKocsi[playerid]);
				iMsg(playerid, "Sikeresen kibérelted a jármûvet!");
			}
		}
	}
	else if(listid == autokereskedes_motorkerekpar || listid == autokereskedes_ipari || listid == autokereskedes_lowrider ||
	listid == autokereskedes_terepjaro || listid == autokereskedes_furgon || listid == autokereskedes_sedan ||
	listid == autokereskedes_kombi || listid == autokereskedes_sport)
	{
	    if(response)
	    {
			PlayerNumber[playerid] = modelid;
			PlayerTextFormat(playerid,  "Model ID:\t%d\n\
			Jármû neve:\t%s\n\
			Üzemanyagtank:\t%d liter\n\
			Fizetendõ összeg:\t$%s",  modelid, GetVehicleModelName(modelid), Max_Benzin[modelid - 400], PenzTordeles(KereskedesArlista(modelid)));
			ShowPlayerDialog(playerid,  DIALOG_JARMUVASARLAS_MEGEROSIT,  DIALOG_STYLE_TABLIST,  "Jármûvásárlás információs lap",  PlayerText[playerid],  "Megvesz",  "Mégse");
		}
	}
	return 1;
}

public OnPlayerModelSelectionEx(playerid, response, extraid, modelid)
{
	if(!response) 
	{
		/*if(extraid == RBRuha) return ShowDialog(playerid, Show:<RuhaBoltMain>, DIALOG_STYLE_LIST, "{33aa33}Válaszd ki mit szeretnél vásárolni.", "Ruhák [$100/db]\nMaszkok,  arckendõk [$25/db]\nFejkendõk [$17/db]\nKalapok és sapkák [$33/db]\nKarórák [$75/db]\nNapszemüvegek [$16/db]\nTáskák", "Választ", "Mégse");
		else if(extraid == RBMaszk) return ShowDialog(playerid, Show:<RBMMaszk>, DIALOG_STYLE_LIST, "Maszkok,  arckendõk", "Arckendõk\nHokimaszkok", "Választ", "Vissza");
		else if(extraid == RBFKendo) return ShowDialog(playerid, Show:<RuhaBoltMain>, DIALOG_STYLE_LIST, "{33aa33}Válaszd ki mit szeretnél vásárolni.", "Ruhák [$100/db]\nMaszkok,  arckendõk [$25/db]\nFejkendõk [$17/db]\nKalapok és sapkák [$33/db]\nKarórák [$75/db]\nNapszemüvegek [$16/db]\nTáskák", "Választ", "Mégse");
		else if(extraid == RBKSapka) return ShowDialog(playerid, Show:<RBMSKalap>, DIALOG_STYLE_LIST, "Sapkák,  kalapok", "Svájci sapkák\nSnapbackek\nFullcapek\nBaseball sapkák\nCowboy kalapok\nKemény kalapok\nNyúlt sapkák\nCilinder [Egybõl oda adja]", "Választ", "Vissza");
		else if(extraid == RBKOra) return ShowDialog(playerid, Show:<RuhaBoltMain>, DIALOG_STYLE_LIST, "{33aa33}Válaszd ki mit szeretnél vásárolni.", "Ruhák [$100/db]\nMaszkok,  arckendõk [$25/db]\nFejkendõk [$17/db]\nKalapok és sapkák [$33/db]\nKarórák [$75/db]\nNapszemüvegek [$16/db]\nTáskák", "Választ", "Mégse");
		else if(extraid == RBNSzem) return ShowDialog(playerid, Show:<RuhaBoltMain>, DIALOG_STYLE_LIST, "{33aa33}Válaszd ki mit szeretnél vásárolni.", "Ruhák [$100/db]\nMaszkok,  arckendõk [$25/db]\nFejkendõk [$17/db]\nKalapok és sapkák [$33/db]\nKarórák [$75/db]\nNapszemüvegek [$16/db]\nTáskák", "Választ", "Mégse");*/
		return 1;
	}
	else 
	{
		switch(extraid)
		{
			/*case RBRuha:
			{
				if(GetMoney(playerid) < 100) return Msg(playerid, "Nincs nálad elég pénz!");
				iMsg(playerid, "Vettél egy ruhát $100-ért.");
				PlayerInfo[playerid][pCSkin] = modelid;
				SetPlayerSkin(playerid, modelid);
				GiveMoney(playerid, -100);
			}
			case RBMaszk:
			{
				if(GetMoney(playerid) < 25) return Msg(playerid, "Nincs nálad elég pénz!");
				if(CheckFull("ZSEB", playerid)) return Msg(playerid, "Nem fér el nálad több tárgy. Használj táskát!");
				iMsg(playerid, "Vettél egy ruhadarabot $25-ért.");
				AddItem("ZSEB", playerid, GetRItemID("MASZK"), 1, modelid);
				GiveMoney(playerid, -25);
			}
			case RBFKendo:
			{
				if(GetMoney(playerid) < 17) return Msg(playerid, "Nincs nálad elég pénz!");
				if(CheckFull("ZSEB", playerid)) return Msg(playerid, "Nem fér el nálad több tárgy. Használj táskát!");
				iMsg(playerid, "Vettél egy ruhadarabot $17-ért.");
				AddItem("ZSEB", playerid, GetRItemID("FKENDO"), 1, modelid);
				GiveMoney(playerid, -17);
			}
			case RBKSapka:
			{
				if(GetMoney(playerid) < 33) return Msg(playerid, "Nincs nálad elég pénz!");
				if(CheckFull("ZSEB", playerid)) return Msg(playerid, "Nem fér el nálad több tárgy. Használj táskát!");
				iMsg(playerid, "Vettél egy ruhadarabot $33-ért.");
				AddItem("ZSEB", playerid, GetRItemID("SKALAP"), 1, modelid);
				GiveMoney(playerid, -33);
			}
			case RBKOra:
			{
				if(GetMoney(playerid) < 75) return Msg(playerid, "Nincs nálad elég pénz!");
				if(CheckFull("ZSEB", playerid)) return Msg(playerid, "Nem fér el nálad több tárgy. Használj táskát!");
				iMsg(playerid, "Vettél egy karórát $75-ért.");
				AddItem("ZSEB", playerid, GetRItemID("ORA"), 1, modelid);
				GiveMoney(playerid, -75);
			}
			case RBNSzem:
			{
				if(GetMoney(playerid) < 16) return Msg(playerid, "Nincs nálad elég pénz!");
				if(CheckFull("ZSEB", playerid)) return Msg(playerid, "Nem fér el nálad több tárgy. Használj táskát!");
				iMsg(playerid, "Vettél egy napszemüveget $16-ért.");
				AddItem("ZSEB", playerid, GetRItemID("NSZEM"), 1, modelid);
				GiveMoney(playerid, -16);
			}*/
			case FrakcioSkinValaszto:
			{
				PlayerInfo[playerid][pChar] = modelid;
				Msg(playerid, "Frakcióskin sikeresen átállítva!");
			}
			case BVAsztal:
			{
				if(GetMoney(playerid) < 140) return Msg(playerid, "Nincs nálad elég pénz!");
				iMsg(playerid, "Vettél egy asztalt $140-ért.");
				GiveMoney(playerid, -140);
				new Float:pos[3];
				GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
				new obj = CreateDynamicObject(modelid, pos[0], pos[1], pos[2], 0.0, 0.0, 0.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
				PlayerInfo[playerid][pBObjID] = modelid;
				format(PlayerInfo[playerid][pBTipus], 50, "Asztal");
				EditDynamicObject(playerid, obj);
			}
			case BVSzek:
			{
				if(GetMoney(playerid) < 55) return Msg(playerid, "Nincs nálad elég pénz!");
				iMsg(playerid, "Vettél egy széket $55-ért.");
				GiveMoney(playerid, -55);
				new Float:pos[3];
				GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
				new obj = CreateDynamicObject(modelid, pos[0], pos[1], pos[2], 0.0, 0.0, 0.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
				PlayerInfo[playerid][pBObjID] = modelid;
				format(PlayerInfo[playerid][pBTipus], 50, "Szék");
				EditDynamicObject(playerid, obj);
			}
			case BVFotelKanape:
			{
				if(GetMoney(playerid) < 320) return Msg(playerid, "Nincs nálad elég pénz!");
				iMsg(playerid, "Vettél egy fotelt/kanapét $320-ért.");
				GiveMoney(playerid, -320);
				new Float:pos[3];
				GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
				new obj = CreateDynamicObject(modelid, pos[0], pos[1], pos[2], 0.0, 0.0, 0.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
				PlayerInfo[playerid][pBObjID] = modelid;
				format(PlayerInfo[playerid][pBTipus], 50, "Fotel,  vagy kanapé");
				EditDynamicObject(playerid, obj);
			}
			case BVSzekreny:
			{
				if(GetMoney(playerid) < 370) return Msg(playerid, "Nincs nálad elég pénz!");
				iMsg(playerid, "Vettél egy szekrényt $370-ért.");
				GiveMoney(playerid, -370);
				new Float:pos[3];
				GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
				new obj = CreateDynamicObject(modelid, pos[0], pos[1], pos[2], 0.0, 0.0, 0.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
				PlayerInfo[playerid][pBObjID] = modelid;
				format(PlayerInfo[playerid][pBTipus], 50, "Szekrény");
				EditDynamicObject(playerid, obj);
			}
			case BVAgyak:
			{
				if(GetMoney(playerid) < 350) return Msg(playerid, "Nincs nálad elég pénz!");
				iMsg(playerid, "Vettél egy ágyat $350-ért.");
				GiveMoney(playerid, -350);
				new Float:pos[3];
				GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
				new obj = CreateDynamicObject(modelid, pos[0], pos[1], pos[2], 0.0, 0.0, 0.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
				PlayerInfo[playerid][pBObjID] = modelid;
				format(PlayerInfo[playerid][pBTipus], 50, "Ágy");
				EditDynamicObject(playerid, obj);
			}
			case BVIroasztalok:
			{
				if(GetMoney(playerid) < 120) return Msg(playerid, "Nincs nálad elég pénz!");
				iMsg(playerid, "Vettél egy íróasztalt $120-ért.");
				GiveMoney(playerid, -120);
				new Float:pos[3];
				GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
				new obj = CreateDynamicObject(modelid, pos[0], pos[1], pos[2], 0.0, 0.0, 0.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
				PlayerInfo[playerid][pBObjID] = modelid;
				format(PlayerInfo[playerid][pBTipus], 50, "Íróasztal");
				EditDynamicObject(playerid, obj);
			}
			case BVAjtok:
			{
				if(GetMoney(playerid) < 260) return Msg(playerid, "Nincs nálad elég pénz!");
				iMsg(playerid, "Vettél egy ajtót $260-ért.");
				GiveMoney(playerid, -260);
				new Float:pos[3];
				GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
				new obj = CreateDynamicObject(modelid, pos[0], pos[1], pos[2], 0.0, 0.0, 0.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
				PlayerInfo[playerid][pBObjID] = modelid;
				format(PlayerInfo[playerid][pBTipus], 50, "Ajtó");
				EditDynamicObject(playerid, obj);
			}
			case BVDekTargy:
			{
				if(GetMoney(playerid) < 70) return Msg(playerid, "Nincs nálad elég pénz!");
				iMsg(playerid, "Vettél egy dekorációs tárgyat $70-ért.");
				GiveMoney(playerid, -70);
				new Float:pos[3];
				GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
				new obj = CreateDynamicObject(modelid, pos[0], pos[1], pos[2], 0.0, 0.0, 0.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
				PlayerInfo[playerid][pBObjID] = modelid;
				format(PlayerInfo[playerid][pBTipus], 50, "Dekorációs tárgy");
				EditDynamicObject(playerid, obj);
			}
			case BVFestmenyek:
			{
				if(GetMoney(playerid) < 260) return Msg(playerid, "Nincs nálad elég pénz!");
				iMsg(playerid, "Vettél egy festményt $260-ért.");
				GiveMoney(playerid, -260);
				new Float:pos[3];
				GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
				new obj = CreateDynamicObject(modelid, pos[0], pos[1], pos[2], 0.0, 0.0, 0.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
				PlayerInfo[playerid][pBObjID] = modelid;
				format(PlayerInfo[playerid][pBTipus], 50, "Festmény");
				EditDynamicObject(playerid, obj);
			}
			case BVPadSzonyeg:
			{
				if(GetMoney(playerid) < 90) return Msg(playerid, "Nincs nálad elég pénz!");
				iMsg(playerid, "Vettél egy padlószõnyeget $90-ért.");
				GiveMoney(playerid, -90);
				new Float:pos[3];
				GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
				new obj = CreateDynamicObject(modelid, pos[0], pos[1], pos[2], 0.0, 0.0, 0.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
				PlayerInfo[playerid][pBObjID] = modelid;
				format(PlayerInfo[playerid][pBTipus], 50, "Padló díszítõ,  szõnyeg");
				EditDynamicObject(playerid, obj);
			}
			case BVLampak:
			{
				if(GetMoney(playerid) < 150) return Msg(playerid, "Nincs nálad elég pénz!");
				iMsg(playerid, "Vettél egy lámpát $150-ért.");
				GiveMoney(playerid, -150);
				new Float:pos[3];
				GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
				new obj = CreateDynamicObject(modelid, pos[0], pos[1], pos[2], 0.0, 0.0, 0.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
				PlayerInfo[playerid][pBObjID] = modelid;
				format(PlayerInfo[playerid][pBTipus], 50, "Lámpa");
				EditDynamicObject(playerid, obj);
			}
			case BVHangTechRadio:
			{
				if(GetMoney(playerid) < 380) return Msg(playerid, "Nincs nálad elég pénz!");
				iMsg(playerid, "Vettél egy hangtechnikai eszközt $380-ért.");
				GiveMoney(playerid, -380);
				new Float:pos[3];
				GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
				new obj = CreateDynamicObject(modelid, pos[0], pos[1], pos[2], 0.0, 0.0, 0.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
				PlayerInfo[playerid][pBObjID] = modelid;
				format(PlayerInfo[playerid][pBTipus], 50, "Hangtechnikai eszköz");
				EditDynamicObject(playerid, obj);
			}
			case BVHangszerek:
			{
				if(GetMoney(playerid) < 470) return Msg(playerid, "Nincs nálad elég pénz!");
				iMsg(playerid, "Vettél egy hangszert $470-ért.");
				GiveMoney(playerid, -470);
				new Float:pos[3];
				GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
				new obj = CreateDynamicObject(modelid, pos[0], pos[1], pos[2], 0.0, 0.0, 0.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
				PlayerInfo[playerid][pBObjID] = modelid;
				format(PlayerInfo[playerid][pBTipus], 50, "Hangszer");
				EditDynamicObject(playerid, obj);
			}
			case BVEgyElEszk:
			{
				if(GetMoney(playerid) < 220) return Msg(playerid, "Nincs nálad elég pénz!");
				iMsg(playerid, "Vettél egy elektronikai eszközt $220-ért.");
				GiveMoney(playerid, -220);
				new Float:pos[3];
				GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
				new obj = CreateDynamicObject(modelid, pos[0], pos[1], pos[2], 0.0, 0.0, 0.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
				PlayerInfo[playerid][pBObjID] = modelid;
				format(PlayerInfo[playerid][pBTipus], 50, "Elektronikai eszköz");
				EditDynamicObject(playerid, obj);
			}
			case BVFurdoSzoba:
			{
				if(GetMoney(playerid) < 390) return Msg(playerid, "Nincs nálad elég pénz!");
				iMsg(playerid, "Vettél egy fürdõszobai berendezést $390-ért.");
				GiveMoney(playerid, -390);
				new Float:pos[3];
				GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
				new obj = CreateDynamicObject(modelid, pos[0], pos[1], pos[2], 0.0, 0.0, 0.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
				PlayerInfo[playerid][pBObjID] = modelid;
				format(PlayerInfo[playerid][pBTipus], 50, "Fürdõszobai berendezés");
				EditDynamicObject(playerid, obj);
			}
			case BVKonyha:
			{
				if(GetMoney(playerid) < 450) return Msg(playerid, "Nincs nálad elég pénz!");
				iMsg(playerid, "Vettél egy konyhai berendezést $450-ért.");
				GiveMoney(playerid, -450);
				new Float:pos[3];
				GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
				new obj = CreateDynamicObject(modelid, pos[0], pos[1], pos[2], 0.0, 0.0, 0.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
				PlayerInfo[playerid][pBObjID] = modelid;
				format(PlayerInfo[playerid][pBTipus], 50, "Konyhai berendezés");
				EditDynamicObject(playerid, obj);
			}
			case BVNovenyek:
			{
				if(GetMoney(playerid) < 60) return Msg(playerid, "Nincs nálad elég pénz!");
				iMsg(playerid, "Vettél egy növényt $60-ért.");
				GiveMoney(playerid, -60);
				new Float:pos[3];
				GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
				new obj = CreateDynamicObject(modelid, pos[0], pos[1], pos[2], 0.0, 0.0, 0.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
				PlayerInfo[playerid][pBObjID] = modelid;
				format(PlayerInfo[playerid][pBTipus], 50, "Növény");
				EditDynamicObject(playerid, obj);
			}
			case BVEdzogepek:
			{
				if(GetMoney(playerid) < 370) return Msg(playerid, "Nincs nálad elég pénz!");
				iMsg(playerid, "Vettél egy edzõgépet $370-ért.");
				GiveMoney(playerid, -370);
				new Float:pos[3];
				GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
				new obj = CreateDynamicObject(modelid, pos[0], pos[1], pos[2], 0.0, 0.0, 0.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
				PlayerInfo[playerid][pBObjID] = modelid;
				format(PlayerInfo[playerid][pBTipus], 50, "Edzõgép");
				EditDynamicObject(playerid, obj);
			}
			case BVFutes: 
			{
				if(GetMoney(playerid) < 170) return Msg(playerid, "Nincs nálad elég pénz!");
				iMsg(playerid, "Vettél egy légkondicionálót $170-ért.");
				GiveMoney(playerid, -170);
				new Float:pos[3];
				GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
				new obj = CreateDynamicObject(modelid, pos[0], pos[1], pos[2], 0.0, 0.0, 0.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
				PlayerInfo[playerid][pBObjID] = modelid;
				format(PlayerInfo[playerid][pBTipus], 50, "Fûtés,  légkondicionáló");
				EditDynamicObject(playerid, obj);
			}
			case BVKandallo: 
			{
				if(GetMoney(playerid) < 190) return Msg(playerid, "Nincs nálad elég pénz!");
				iMsg(playerid, "Vettél egy kandallót $190-ért.");
				GiveMoney(playerid, -190);
				new Float:pos[3];
				GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
				new obj = CreateDynamicObject(modelid, pos[0], pos[1], pos[2], 0.0, 0.0, 0.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
				PlayerInfo[playerid][pBObjID] = modelid;
				format(PlayerInfo[playerid][pBTipus], 50, "Kandalló");
				EditDynamicObject(playerid, obj);
			}
			case BVTelevizio: 
			{
				if(GetMoney(playerid) < 170) return Msg(playerid, "Nincs nálad elég pénz!");
				iMsg(playerid, "Vettél egy televíziót $170-ért.");
				GiveMoney(playerid, -170);
				new Float:pos[3];
				GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
				new obj = CreateDynamicObject(modelid, pos[0], pos[1], pos[2], 0.0, 0.0, 0.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
				PlayerInfo[playerid][pBObjID] = modelid;
				format(PlayerInfo[playerid][pBTipus], 50, "Televízió");
				EditDynamicObject(playerid, obj);
			}
		}
	}
	return 1;
}