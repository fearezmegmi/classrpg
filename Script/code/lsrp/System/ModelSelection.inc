public OnPlayerModelSelection(playerid, response, listid, modelid)
{
	if(listid == ruhaboltskinlista)
	{
		if(response)
	    {
			new ruhaar = 50;
			if(GetMoney(playerid) < ruhaar) 
			{
				MsgFormat(playerid,  "Nincs el�g p�nzed! Egy ruha �ra $%d!",  ruhaar);
				return 1;
			}
			else
			{
				iMsg(playerid,  "Vett�l egy ruh�t");
				Cselekves(playerid,  "vett egy ruh�t");
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
			else if(egyezik(UtolsoCMD[playerid],  "/�jmodel"))
			{
				UjJarmuModel(playerid,  modelid);
			}
			else if(egyezik(UtolsoCMD[playerid],  "/vehlist"))
			{
				new kocsiar = KereskedesArlista(modelid);				
				MsgFormat(playerid,  "J�rm� model ID: %d | �ra: $%d | T�pus: %s",  modelid,  kocsiar,  GetVehicleModelName(modelid));
			}
		}
	}
	else if(listid == pickuplista)
	{
	    if(response)
	    {
			new ajtoszama = GetPVarInt(playerid,  "EditedAjtoID");
			if(!IsValidPickupObject(modelid)) { MsgFormat(playerid,  "Hib�s PickupID! [%d]",  modelid); return 1; }
			Ajtok[ajtoszama][PickupID] = modelid;
			UpdateAjto3D(ajtoszama);
			Msg(playerid,  "Ajt� Pickup-ja m�dos�tva!",  COLOR_ADMIN);
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
				MsgFormat(playerid,  "Nincs el�g p�nzed a j�rm� b�rl�s�hez! (sz�ks�ges: $%d)!",  berlesar);
				return 1;
			}
			else
			{
				GiveMoney(playerid,  -berlesar);
				SpawnPozicio[playerid] = random(sizeof(BerelhetoKocsiSpawn));
				BereltKocsi[playerid] = UjKocsi(modelid, BerelhetoKocsiSpawn[SpawnPozicio[playerid]][0], BerelhetoKocsiSpawn[SpawnPozicio[playerid]][1], BerelhetoKocsiSpawn[SpawnPozicio[playerid]][2], BerelhetoKocsiSpawn[SpawnPozicio[playerid]][3], RandomVehicleColor(), RandomVehicleColor());
				SetPlayerCheckpoint(playerid, BerelhetoKocsiSpawn[SpawnPozicio[playerid]][0], BerelhetoKocsiSpawn[SpawnPozicio[playerid]][1], BerelhetoKocsiSpawn[SpawnPozicio[playerid]][2], 8.0);
				UnLockCar(BereltKocsi[playerid]);
				iMsg(playerid, "Sikeresen kib�relted a j�rm�vet!");
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
			J�rm� neve:\t%s\n\
			�zemanyagtank:\t%d liter\n\
			Fizetend� �sszeg:\t$%s",  modelid, GetVehicleModelName(modelid), Max_Benzin[modelid - 400], PenzTordeles(KereskedesArlista(modelid)));
			ShowPlayerDialog(playerid,  DIALOG_JARMUVASARLAS_MEGEROSIT,  DIALOG_STYLE_TABLIST,  "J�rm�v�s�rl�s inform�ci�s lap",  PlayerText[playerid],  "Megvesz",  "M�gse");
		}
	}
	return 1;
}

public OnPlayerModelSelectionEx(playerid, response, extraid, modelid)
{
	if(!response) 
	{
		/*if(extraid == RBRuha) return ShowDialog(playerid, Show:<RuhaBoltMain>, DIALOG_STYLE_LIST, "{33aa33}V�laszd ki mit szeretn�l v�s�rolni.", "Ruh�k [$100/db]\nMaszkok,  arckend�k [$25/db]\nFejkend�k [$17/db]\nKalapok �s sapk�k [$33/db]\nKar�r�k [$75/db]\nNapszem�vegek [$16/db]\nT�sk�k", "V�laszt", "M�gse");
		else if(extraid == RBMaszk) return ShowDialog(playerid, Show:<RBMMaszk>, DIALOG_STYLE_LIST, "Maszkok,  arckend�k", "Arckend�k\nHokimaszkok", "V�laszt", "Vissza");
		else if(extraid == RBFKendo) return ShowDialog(playerid, Show:<RuhaBoltMain>, DIALOG_STYLE_LIST, "{33aa33}V�laszd ki mit szeretn�l v�s�rolni.", "Ruh�k [$100/db]\nMaszkok,  arckend�k [$25/db]\nFejkend�k [$17/db]\nKalapok �s sapk�k [$33/db]\nKar�r�k [$75/db]\nNapszem�vegek [$16/db]\nT�sk�k", "V�laszt", "M�gse");
		else if(extraid == RBKSapka) return ShowDialog(playerid, Show:<RBMSKalap>, DIALOG_STYLE_LIST, "Sapk�k,  kalapok", "Sv�jci sapk�k\nSnapbackek\nFullcapek\nBaseball sapk�k\nCowboy kalapok\nKem�ny kalapok\nNy�lt sapk�k\nCilinder [Egyb�l oda adja]", "V�laszt", "Vissza");
		else if(extraid == RBKOra) return ShowDialog(playerid, Show:<RuhaBoltMain>, DIALOG_STYLE_LIST, "{33aa33}V�laszd ki mit szeretn�l v�s�rolni.", "Ruh�k [$100/db]\nMaszkok,  arckend�k [$25/db]\nFejkend�k [$17/db]\nKalapok �s sapk�k [$33/db]\nKar�r�k [$75/db]\nNapszem�vegek [$16/db]\nT�sk�k", "V�laszt", "M�gse");
		else if(extraid == RBNSzem) return ShowDialog(playerid, Show:<RuhaBoltMain>, DIALOG_STYLE_LIST, "{33aa33}V�laszd ki mit szeretn�l v�s�rolni.", "Ruh�k [$100/db]\nMaszkok,  arckend�k [$25/db]\nFejkend�k [$17/db]\nKalapok �s sapk�k [$33/db]\nKar�r�k [$75/db]\nNapszem�vegek [$16/db]\nT�sk�k", "V�laszt", "M�gse");*/
		return 1;
	}
	else 
	{
		switch(extraid)
		{
			/*case RBRuha:
			{
				if(GetMoney(playerid) < 100) return Msg(playerid, "Nincs n�lad el�g p�nz!");
				iMsg(playerid, "Vett�l egy ruh�t $100-�rt.");
				PlayerInfo[playerid][pCSkin] = modelid;
				SetPlayerSkin(playerid, modelid);
				GiveMoney(playerid, -100);
			}
			case RBMaszk:
			{
				if(GetMoney(playerid) < 25) return Msg(playerid, "Nincs n�lad el�g p�nz!");
				if(CheckFull("ZSEB", playerid)) return Msg(playerid, "Nem f�r el n�lad t�bb t�rgy. Haszn�lj t�sk�t!");
				iMsg(playerid, "Vett�l egy ruhadarabot $25-�rt.");
				AddItem("ZSEB", playerid, GetRItemID("MASZK"), 1, modelid);
				GiveMoney(playerid, -25);
			}
			case RBFKendo:
			{
				if(GetMoney(playerid) < 17) return Msg(playerid, "Nincs n�lad el�g p�nz!");
				if(CheckFull("ZSEB", playerid)) return Msg(playerid, "Nem f�r el n�lad t�bb t�rgy. Haszn�lj t�sk�t!");
				iMsg(playerid, "Vett�l egy ruhadarabot $17-�rt.");
				AddItem("ZSEB", playerid, GetRItemID("FKENDO"), 1, modelid);
				GiveMoney(playerid, -17);
			}
			case RBKSapka:
			{
				if(GetMoney(playerid) < 33) return Msg(playerid, "Nincs n�lad el�g p�nz!");
				if(CheckFull("ZSEB", playerid)) return Msg(playerid, "Nem f�r el n�lad t�bb t�rgy. Haszn�lj t�sk�t!");
				iMsg(playerid, "Vett�l egy ruhadarabot $33-�rt.");
				AddItem("ZSEB", playerid, GetRItemID("SKALAP"), 1, modelid);
				GiveMoney(playerid, -33);
			}
			case RBKOra:
			{
				if(GetMoney(playerid) < 75) return Msg(playerid, "Nincs n�lad el�g p�nz!");
				if(CheckFull("ZSEB", playerid)) return Msg(playerid, "Nem f�r el n�lad t�bb t�rgy. Haszn�lj t�sk�t!");
				iMsg(playerid, "Vett�l egy kar�r�t $75-�rt.");
				AddItem("ZSEB", playerid, GetRItemID("ORA"), 1, modelid);
				GiveMoney(playerid, -75);
			}
			case RBNSzem:
			{
				if(GetMoney(playerid) < 16) return Msg(playerid, "Nincs n�lad el�g p�nz!");
				if(CheckFull("ZSEB", playerid)) return Msg(playerid, "Nem f�r el n�lad t�bb t�rgy. Haszn�lj t�sk�t!");
				iMsg(playerid, "Vett�l egy napszem�veget $16-�rt.");
				AddItem("ZSEB", playerid, GetRItemID("NSZEM"), 1, modelid);
				GiveMoney(playerid, -16);
			}*/
			case FrakcioSkinValaszto:
			{
				PlayerInfo[playerid][pChar] = modelid;
				Msg(playerid, "Frakci�skin sikeresen �t�ll�tva!");
			}
			case BVAsztal:
			{
				if(GetMoney(playerid) < 140) return Msg(playerid, "Nincs n�lad el�g p�nz!");
				iMsg(playerid, "Vett�l egy asztalt $140-�rt.");
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
				if(GetMoney(playerid) < 55) return Msg(playerid, "Nincs n�lad el�g p�nz!");
				iMsg(playerid, "Vett�l egy sz�ket $55-�rt.");
				GiveMoney(playerid, -55);
				new Float:pos[3];
				GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
				new obj = CreateDynamicObject(modelid, pos[0], pos[1], pos[2], 0.0, 0.0, 0.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
				PlayerInfo[playerid][pBObjID] = modelid;
				format(PlayerInfo[playerid][pBTipus], 50, "Sz�k");
				EditDynamicObject(playerid, obj);
			}
			case BVFotelKanape:
			{
				if(GetMoney(playerid) < 320) return Msg(playerid, "Nincs n�lad el�g p�nz!");
				iMsg(playerid, "Vett�l egy fotelt/kanap�t $320-�rt.");
				GiveMoney(playerid, -320);
				new Float:pos[3];
				GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
				new obj = CreateDynamicObject(modelid, pos[0], pos[1], pos[2], 0.0, 0.0, 0.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
				PlayerInfo[playerid][pBObjID] = modelid;
				format(PlayerInfo[playerid][pBTipus], 50, "Fotel,  vagy kanap�");
				EditDynamicObject(playerid, obj);
			}
			case BVSzekreny:
			{
				if(GetMoney(playerid) < 370) return Msg(playerid, "Nincs n�lad el�g p�nz!");
				iMsg(playerid, "Vett�l egy szekr�nyt $370-�rt.");
				GiveMoney(playerid, -370);
				new Float:pos[3];
				GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
				new obj = CreateDynamicObject(modelid, pos[0], pos[1], pos[2], 0.0, 0.0, 0.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
				PlayerInfo[playerid][pBObjID] = modelid;
				format(PlayerInfo[playerid][pBTipus], 50, "Szekr�ny");
				EditDynamicObject(playerid, obj);
			}
			case BVAgyak:
			{
				if(GetMoney(playerid) < 350) return Msg(playerid, "Nincs n�lad el�g p�nz!");
				iMsg(playerid, "Vett�l egy �gyat $350-�rt.");
				GiveMoney(playerid, -350);
				new Float:pos[3];
				GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
				new obj = CreateDynamicObject(modelid, pos[0], pos[1], pos[2], 0.0, 0.0, 0.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
				PlayerInfo[playerid][pBObjID] = modelid;
				format(PlayerInfo[playerid][pBTipus], 50, "�gy");
				EditDynamicObject(playerid, obj);
			}
			case BVIroasztalok:
			{
				if(GetMoney(playerid) < 120) return Msg(playerid, "Nincs n�lad el�g p�nz!");
				iMsg(playerid, "Vett�l egy �r�asztalt $120-�rt.");
				GiveMoney(playerid, -120);
				new Float:pos[3];
				GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
				new obj = CreateDynamicObject(modelid, pos[0], pos[1], pos[2], 0.0, 0.0, 0.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
				PlayerInfo[playerid][pBObjID] = modelid;
				format(PlayerInfo[playerid][pBTipus], 50, "�r�asztal");
				EditDynamicObject(playerid, obj);
			}
			case BVAjtok:
			{
				if(GetMoney(playerid) < 260) return Msg(playerid, "Nincs n�lad el�g p�nz!");
				iMsg(playerid, "Vett�l egy ajt�t $260-�rt.");
				GiveMoney(playerid, -260);
				new Float:pos[3];
				GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
				new obj = CreateDynamicObject(modelid, pos[0], pos[1], pos[2], 0.0, 0.0, 0.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
				PlayerInfo[playerid][pBObjID] = modelid;
				format(PlayerInfo[playerid][pBTipus], 50, "Ajt�");
				EditDynamicObject(playerid, obj);
			}
			case BVDekTargy:
			{
				if(GetMoney(playerid) < 70) return Msg(playerid, "Nincs n�lad el�g p�nz!");
				iMsg(playerid, "Vett�l egy dekor�ci�s t�rgyat $70-�rt.");
				GiveMoney(playerid, -70);
				new Float:pos[3];
				GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
				new obj = CreateDynamicObject(modelid, pos[0], pos[1], pos[2], 0.0, 0.0, 0.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
				PlayerInfo[playerid][pBObjID] = modelid;
				format(PlayerInfo[playerid][pBTipus], 50, "Dekor�ci�s t�rgy");
				EditDynamicObject(playerid, obj);
			}
			case BVFestmenyek:
			{
				if(GetMoney(playerid) < 260) return Msg(playerid, "Nincs n�lad el�g p�nz!");
				iMsg(playerid, "Vett�l egy festm�nyt $260-�rt.");
				GiveMoney(playerid, -260);
				new Float:pos[3];
				GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
				new obj = CreateDynamicObject(modelid, pos[0], pos[1], pos[2], 0.0, 0.0, 0.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
				PlayerInfo[playerid][pBObjID] = modelid;
				format(PlayerInfo[playerid][pBTipus], 50, "Festm�ny");
				EditDynamicObject(playerid, obj);
			}
			case BVPadSzonyeg:
			{
				if(GetMoney(playerid) < 90) return Msg(playerid, "Nincs n�lad el�g p�nz!");
				iMsg(playerid, "Vett�l egy padl�sz�nyeget $90-�rt.");
				GiveMoney(playerid, -90);
				new Float:pos[3];
				GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
				new obj = CreateDynamicObject(modelid, pos[0], pos[1], pos[2], 0.0, 0.0, 0.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
				PlayerInfo[playerid][pBObjID] = modelid;
				format(PlayerInfo[playerid][pBTipus], 50, "Padl� d�sz�t�,  sz�nyeg");
				EditDynamicObject(playerid, obj);
			}
			case BVLampak:
			{
				if(GetMoney(playerid) < 150) return Msg(playerid, "Nincs n�lad el�g p�nz!");
				iMsg(playerid, "Vett�l egy l�mp�t $150-�rt.");
				GiveMoney(playerid, -150);
				new Float:pos[3];
				GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
				new obj = CreateDynamicObject(modelid, pos[0], pos[1], pos[2], 0.0, 0.0, 0.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
				PlayerInfo[playerid][pBObjID] = modelid;
				format(PlayerInfo[playerid][pBTipus], 50, "L�mpa");
				EditDynamicObject(playerid, obj);
			}
			case BVHangTechRadio:
			{
				if(GetMoney(playerid) < 380) return Msg(playerid, "Nincs n�lad el�g p�nz!");
				iMsg(playerid, "Vett�l egy hangtechnikai eszk�zt $380-�rt.");
				GiveMoney(playerid, -380);
				new Float:pos[3];
				GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
				new obj = CreateDynamicObject(modelid, pos[0], pos[1], pos[2], 0.0, 0.0, 0.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
				PlayerInfo[playerid][pBObjID] = modelid;
				format(PlayerInfo[playerid][pBTipus], 50, "Hangtechnikai eszk�z");
				EditDynamicObject(playerid, obj);
			}
			case BVHangszerek:
			{
				if(GetMoney(playerid) < 470) return Msg(playerid, "Nincs n�lad el�g p�nz!");
				iMsg(playerid, "Vett�l egy hangszert $470-�rt.");
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
				if(GetMoney(playerid) < 220) return Msg(playerid, "Nincs n�lad el�g p�nz!");
				iMsg(playerid, "Vett�l egy elektronikai eszk�zt $220-�rt.");
				GiveMoney(playerid, -220);
				new Float:pos[3];
				GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
				new obj = CreateDynamicObject(modelid, pos[0], pos[1], pos[2], 0.0, 0.0, 0.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
				PlayerInfo[playerid][pBObjID] = modelid;
				format(PlayerInfo[playerid][pBTipus], 50, "Elektronikai eszk�z");
				EditDynamicObject(playerid, obj);
			}
			case BVFurdoSzoba:
			{
				if(GetMoney(playerid) < 390) return Msg(playerid, "Nincs n�lad el�g p�nz!");
				iMsg(playerid, "Vett�l egy f�rd�szobai berendez�st $390-�rt.");
				GiveMoney(playerid, -390);
				new Float:pos[3];
				GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
				new obj = CreateDynamicObject(modelid, pos[0], pos[1], pos[2], 0.0, 0.0, 0.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
				PlayerInfo[playerid][pBObjID] = modelid;
				format(PlayerInfo[playerid][pBTipus], 50, "F�rd�szobai berendez�s");
				EditDynamicObject(playerid, obj);
			}
			case BVKonyha:
			{
				if(GetMoney(playerid) < 450) return Msg(playerid, "Nincs n�lad el�g p�nz!");
				iMsg(playerid, "Vett�l egy konyhai berendez�st $450-�rt.");
				GiveMoney(playerid, -450);
				new Float:pos[3];
				GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
				new obj = CreateDynamicObject(modelid, pos[0], pos[1], pos[2], 0.0, 0.0, 0.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
				PlayerInfo[playerid][pBObjID] = modelid;
				format(PlayerInfo[playerid][pBTipus], 50, "Konyhai berendez�s");
				EditDynamicObject(playerid, obj);
			}
			case BVNovenyek:
			{
				if(GetMoney(playerid) < 60) return Msg(playerid, "Nincs n�lad el�g p�nz!");
				iMsg(playerid, "Vett�l egy n�v�nyt $60-�rt.");
				GiveMoney(playerid, -60);
				new Float:pos[3];
				GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
				new obj = CreateDynamicObject(modelid, pos[0], pos[1], pos[2], 0.0, 0.0, 0.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
				PlayerInfo[playerid][pBObjID] = modelid;
				format(PlayerInfo[playerid][pBTipus], 50, "N�v�ny");
				EditDynamicObject(playerid, obj);
			}
			case BVEdzogepek:
			{
				if(GetMoney(playerid) < 370) return Msg(playerid, "Nincs n�lad el�g p�nz!");
				iMsg(playerid, "Vett�l egy edz�g�pet $370-�rt.");
				GiveMoney(playerid, -370);
				new Float:pos[3];
				GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
				new obj = CreateDynamicObject(modelid, pos[0], pos[1], pos[2], 0.0, 0.0, 0.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
				PlayerInfo[playerid][pBObjID] = modelid;
				format(PlayerInfo[playerid][pBTipus], 50, "Edz�g�p");
				EditDynamicObject(playerid, obj);
			}
			case BVFutes: 
			{
				if(GetMoney(playerid) < 170) return Msg(playerid, "Nincs n�lad el�g p�nz!");
				iMsg(playerid, "Vett�l egy l�gkondicion�l�t $170-�rt.");
				GiveMoney(playerid, -170);
				new Float:pos[3];
				GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
				new obj = CreateDynamicObject(modelid, pos[0], pos[1], pos[2], 0.0, 0.0, 0.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
				PlayerInfo[playerid][pBObjID] = modelid;
				format(PlayerInfo[playerid][pBTipus], 50, "F�t�s,  l�gkondicion�l�");
				EditDynamicObject(playerid, obj);
			}
			case BVKandallo: 
			{
				if(GetMoney(playerid) < 190) return Msg(playerid, "Nincs n�lad el�g p�nz!");
				iMsg(playerid, "Vett�l egy kandall�t $190-�rt.");
				GiveMoney(playerid, -190);
				new Float:pos[3];
				GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
				new obj = CreateDynamicObject(modelid, pos[0], pos[1], pos[2], 0.0, 0.0, 0.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
				PlayerInfo[playerid][pBObjID] = modelid;
				format(PlayerInfo[playerid][pBTipus], 50, "Kandall�");
				EditDynamicObject(playerid, obj);
			}
			case BVTelevizio: 
			{
				if(GetMoney(playerid) < 170) return Msg(playerid, "Nincs n�lad el�g p�nz!");
				iMsg(playerid, "Vett�l egy telev�zi�t $170-�rt.");
				GiveMoney(playerid, -170);
				new Float:pos[3];
				GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
				new obj = CreateDynamicObject(modelid, pos[0], pos[1], pos[2], 0.0, 0.0, 0.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
				PlayerInfo[playerid][pBObjID] = modelid;
				format(PlayerInfo[playerid][pBTipus], 50, "Telev�zi�");
				EditDynamicObject(playerid, obj);
			}
		}
	}
	return 1;
}