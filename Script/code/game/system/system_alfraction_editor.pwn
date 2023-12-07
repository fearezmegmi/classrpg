#if defined __game_system_system_alfraction
	#endinput
#endif
#define __game_system_system_alfraction

// fedit
#define AFEDIT_PHASE_FRACTION	1
#define AFEDIT_PHASE_FRACTION_POLICE 8707
#define AFEDIT_PHASE_OPTIONS_POLICE		2
#define AFEDIT_PHASE_NAME_POLICE		3
#define AFEDIT_PHASE_SKIN_POLICE		5
#define AFEDIT_PHASE_SKIN_EDIT_POLICE	51
#define AFEDIT_PHASE_RANG_POLICE		7
#define AFEDIT_PHASE_RANG_EDIT_POLICE	71
#define AFEDIT_PHASE_KOCSIK_POLICE	72
#define AFEDIT_PHASE_KOCSIK_EDIT_POLICE	73

#define AFEDIT_PHASE_SUCCESS			1000
#define AFEDIT_PHASE_SUCCESS_SKIN	1001
#define AFEDIT_PHASE_SUCCESS_RANG	1002

#define AFRAKCIO_EDITOR_MIN_ADMIN	(6)

#define MAX_ALFRAKCIO 6

new const AlFrakciokNeve[MAX_ALFRAKCIO][64] = {
	{"SWAT"},
	{"Szerel�k"},
	{"Aut�keresked�s"},
	{"RKA"},
	{"Police [SFPD]"},
	{"Party Service Company"}
};

new D_AlFrakcioEditor[MAX_PLAYERS]/*, D_AlFrakcioEditor_Frakcio[MAX_PLAYERS]*/, D_AlFrakcioEditor_Police[MAX_PLAYERS], D_AlFrakcioEditor_SelectedItem[MAX_PLAYERS];

ShowAlFrakcioEditor(playerid)
{
	switch(D_AlFrakcioEditor[playerid])
	{
		case AFEDIT_PHASE_FRACTION:
		{
			tformat(256, "[1]%s", AlFrakciokNeve[0]);
			for(new i = 1; i < MAX_ALFRAKCIO; i++)
				tformat(256, "%s\n[%d]%s", _tmpString, i+1, AlFrakciokNeve[i]);
			
			CustomDialog(playerid, D:alfrakcioeditor, DIALOG_STYLE_LIST, "AlFrakci� editor", _tmpString, "Tov�bb", "M�gse");
		}
		case AFEDIT_PHASE_FRACTION_POLICE:
		{
			tformat(256, "[1]%s", PoliceAlosztaly[0][0]);
			for(new i = 1; i < MAX_POLICE_CLASS; i++)
				tformat(256, "%s\n[%d]%s", _tmpString, i+1, PoliceAlosztaly[i][0]);
			
			CustomDialog(playerid, D:alfrakcioeditor, DIALOG_STYLE_LIST, "Police aloszt�ly editor", _tmpString, "Tov�bb", "M�gse");
		}
		case AFEDIT_PHASE_OPTIONS_POLICE:
		{
			new frakcio = D_AlFrakcioEditor_Police[playerid];
			new title[64]; format(title, 64, "Aloszt�ly: %s", PoliceAlosztaly[frakcio][0]);
			
			if(Admin(playerid, AFRAKCIO_EDITOR_MIN_ADMIN))
				CustomDialog(playerid, D:alfrakcioeditor, DIALOG_STYLE_LIST, title, "N�vv�ltoztat�s\nSkinek\nRangok\nKocsik", "Tov�bb", "Vissza");
			else
				return 1;
		}
		case AFEDIT_PHASE_NAME_POLICE:
		{
			new frakcio = D_AlFrakcioEditor_Police[playerid];
			tformat(256, "A frakci� nev�t a k�vetkez� form�tumban kell megadni:\nTeljes n�v,R�vid�t�s,�kezetmentes r�vid�t�s\nPl.: Bank �rei,B�,BO\n\nJelenlegi n�v:\n%s,%s,%s", \
				ArrExt(PoliceAlosztaly[frakcio]));
				
			new title[64]; format(title, 64, "Aloszt�ly: %s", PoliceAlosztaly[frakcio][0]);
			CustomDialog(playerid, D:alfrakcioeditor, DIALOG_STYLE_INPUT, title, _tmpString, "Ment�s", "M�gse");
		}
		case AFEDIT_PHASE_SKIN_POLICE:
		{
			new frakcio = D_AlFrakcioEditor_Police[playerid];
			new list[1024];
			list = "�sszes megad�sa k�zzel";
			for(new s = 0; s < MAX_FRAKCIO_SKIN; s++)
			{
				if(PoliceSkinek[frakcio][s] != 0)
					format(list, 1024, "%s\nSkin: %d", list, PoliceSkinek[frakcio][s]);
				else
					format(list, 1024, "%s\n�res", list);
			}
				
			new title[64]; format(title, 64, "Aloszt�ly: %s", PoliceAlosztaly[frakcio][0]);
			CustomDialog(playerid, D:alfrakcioeditor, DIALOG_STYLE_LIST, title, list, "Ment�s", "M�gse");
		}
		case AFEDIT_PHASE_SKIN_EDIT_POLICE:
		{
			new frakcio = D_AlFrakcioEditor_Police[playerid];
			new item = D_FrakcioEditor_SelectedItem[playerid];
			
			if(!item)
				_tmpString = "�sszes skin megad�sa k�zzel.\nForm�tum: 13,14,15,16,17,18,...\nMaximum "#MAX_FRAKCIO_SKIN"db skin adhat� meg!";
			else
			{
				if(!PoliceSkinek[frakcio][item-1])
					_tmpString = "Az �res helyre k�v�nt skin megad�sa.\nEgy darab sz�mot adhatsz meg.";
				else
					tformat(256, "A %d skint szeretn�d lecser�lni.\nEgy darab sz�mot adhatsz meg.", PoliceSkinek[frakcio][item-1]);
			}
				
			new title[64]; format(title, 64, "Aloszt�ly: %s", PoliceAlosztaly[frakcio][0]);
			CustomDialog(playerid, D:alfrakcioeditor, DIALOG_STYLE_INPUT, title, _tmpString, "Ment�s", "M�gse");
		}
		case AFEDIT_PHASE_KOCSIK_POLICE:
		{
			new frakcio = D_AlFrakcioEditor_Police[playerid];
			new list[1024];
			list = "�sszes megad�sa k�zzel";
			for(new s = 0; s < MAX_FRAKCIO_SKIN; s++)
			{
				if(PoliceKocsik[frakcio][s] != 0)
					format(list, 1024, "%s\nKocsi: %d", list, PoliceKocsik[frakcio][s]);
				else
					format(list, 1024, "%s\n�res", list);
			}
				
			new title[64]; format(title, 64, "Aloszt�ly: %s", PoliceAlosztaly[frakcio][0]);
			CustomDialog(playerid, D:alfrakcioeditor, DIALOG_STYLE_LIST, title, list, "Ment�s", "M�gse");
		}
		case AFEDIT_PHASE_KOCSIK_EDIT_POLICE:
		{
			new frakcio = D_AlFrakcioEditor_Police[playerid];
			new item = D_FrakcioEditor_SelectedItem[playerid];
			
			if(!item)
				_tmpString = "�sszes kocsi megad�sa k�zzel.\nForm�tum: 13,14,15,16,17,18,...\nMaximum "#MAX_FRAKCIO_SKIN"db kocsi adhat� meg!";
			else
			{
				if(!PoliceKocsik[frakcio][item-1])
					_tmpString = "Az �res helyre k�v�nt kocsi megad�sa.\nEgy darab sz�mot adhatsz meg.";
				else
					tformat(256, "A %d kocsit szeretn�d lecser�lni.\nEgy darab sz�mot adhatsz meg.", PoliceKocsik[frakcio][item-1]);
			}
				
			new title[64]; format(title, 64, "Aloszt�ly: %s", PoliceAlosztaly[frakcio][0]);
			CustomDialog(playerid, D:alfrakcioeditor, DIALOG_STYLE_INPUT, title, _tmpString, "Ment�s", "M�gse");
		}
		case AFEDIT_PHASE_RANG_POLICE:
		{
			new frakcio = D_AlFrakcioEditor_Police[playerid];
			new list[1024];
			format(list, 1024, "[0]%s", PoliceRangok[frakcio][0]);
			for(new r = 1; r < MAX_FRAKCIO_RANG; r++)
			{
				format(list, 1024, "%s\n[%d]%s", list, r, PoliceRangok[frakcio][r]);
			}
				
			new title[64]; format(title, 64, "Aloszt�ly: %s", PoliceAlosztaly[frakcio][0]);
			CustomDialog(playerid, D:alfrakcioeditor, DIALOG_STYLE_LIST, title, list, "Ment�s", "M�gse");
		}
		
		case AFEDIT_PHASE_RANG_EDIT_POLICE:
		{
			new frakcio = D_AlFrakcioEditor_Police[playerid];
			new item = D_FrakcioEditor_SelectedItem[playerid];
			tformat(256, "A %d. rang nev�t szeretn�d m�dos�tani\nA jelenlegi neve: %s", item, PoliceRangok[frakcio][item]);
				
			new title[64]; format(title, 64, "Aloszt�ly: %s", PoliceAlosztaly[frakcio][0]);
			CustomDialog(playerid, D:alfrakcioeditor, DIALOG_STYLE_INPUT, title, _tmpString, "Ment�s", "M�gse");
		}
		
	}
	return 1;
}

stock CheckAlFractionSkins(frakcio)
{
	new free = -1, bool:changed;
	do
	{
		free = -1;
		changed = false;
		
		for(new i = 0; i < MAX_FRAKCIO_SKIN; i++)
		{
			if(!IsValidSkin(PoliceSkinek[frakcio][i]))
				PoliceSkinek[frakcio][i] = 0;
				
			if(free == -1 && !PoliceSkinek[frakcio][i])
				free = i;
			
			if(PoliceSkinek[frakcio][i] && free != -1)
			{
				PoliceSkinek[frakcio][free] = PoliceSkinek[frakcio][i];
				PoliceSkinek[frakcio][i] = 0;
				changed = true;
				break;
			}
		}
	}
	while(changed);
}

stock CheckAlFractionKocsik(frakcio)
{
	new free = -1, bool:changed;
	do
	{
		free = -1;
		changed = false;
		
		for(new i = 0; i < MAX_FRAKCIO_SKIN; i++)
		{
			//new vehicleid = FrakcioKocsi[FRAKCIO_SFPD][PoliceKocsik[frakcio][i]][fID];
			
			//if(!IsValidVehicle(vehicleid)) PoliceKocsik[frakcio][i] = 0;
				
			if(free == -1 && !PoliceKocsik[frakcio][i])
				free = i;
			
			if(PoliceKocsik[frakcio][i] && free != -1)
			{
				PoliceKocsik[frakcio][free] = PoliceKocsik[frakcio][i];
				PoliceKocsik[frakcio][i] = 0;
				changed = true;
				break;
			}
		}
	}
	while(changed);
}

Dialog:alfrakcioeditor(playerid, response, listitem, inputtext[])
{
	if(!response)
	{
		switch(D_AlFrakcioEditor[playerid])
		{
			case AFEDIT_PHASE_FRACTION, AFEDIT_PHASE_SUCCESS:
				return 1;
			case AFEDIT_PHASE_OPTIONS_POLICE, AFEDIT_PHASE_FRACTION_POLICE:
			{
				if(Admin(playerid, AFRAKCIO_EDITOR_MIN_ADMIN))
				{
					D_AlFrakcioEditor[playerid] = AFEDIT_PHASE_FRACTION;
					ShowAlFrakcioEditor(playerid);
				}
				return 1;
			}
			case AFEDIT_PHASE_NAME_POLICE, AFEDIT_PHASE_SKIN_POLICE, AFEDIT_PHASE_RANG_POLICE:
			{
				D_AlFrakcioEditor[playerid] = AFEDIT_PHASE_OPTIONS_POLICE;
				ShowAlFrakcioEditor(playerid);
				return 1;
			}
			case AFEDIT_PHASE_SKIN_EDIT_POLICE:
			{
				D_AlFrakcioEditor[playerid] = AFEDIT_PHASE_SKIN_POLICE;
				ShowAlFrakcioEditor(playerid);
				return 1;
			}
			case AFEDIT_PHASE_RANG_EDIT_POLICE:
			{
				D_AlFrakcioEditor[playerid] = AFEDIT_PHASE_RANG_POLICE;
				ShowAlFrakcioEditor(playerid);
				return 1;
			}
			case AFEDIT_PHASE_KOCSIK_POLICE:
			{
				D_AlFrakcioEditor[playerid] = AFEDIT_PHASE_OPTIONS_POLICE;
				ShowAlFrakcioEditor(playerid);
				return 1;
			}
			case AFEDIT_PHASE_KOCSIK_EDIT_POLICE:
			{
				D_AlFrakcioEditor[playerid] = AFEDIT_PHASE_KOCSIK_POLICE;
				ShowAlFrakcioEditor(playerid);
				return 1;
			}
		}
	}

	if(D_AlFrakcioEditor[playerid] == AFEDIT_PHASE_FRACTION)
	{
		if(listitem != 4) return Msg(playerid, "Jelenleg nem el�rhet�!");
		//D_AlFrakcioEditor_Frakcio[playerid] = listitem + 1;
		//D_AlFrakcioEditor[playerid] = AFEDIT_PHASE_OPTIONS;
		
		//D_AlFrakcioEditor_Frakcio[playerid] = listitem + 1;
		D_AlFrakcioEditor[playerid] = AFEDIT_PHASE_FRACTION_POLICE;
		ShowAlFrakcioEditor(playerid);
	}
	else if(D_AlFrakcioEditor[playerid] == AFEDIT_PHASE_FRACTION_POLICE)
	{
		//D_AlFrakcioEditor_Frakcio[playerid] = listitem + 1;
		//D_AlFrakcioEditor[playerid] = AFEDIT_PHASE_OPTIONS;
		
		D_AlFrakcioEditor_Police[playerid] = listitem;
		D_AlFrakcioEditor[playerid] = AFEDIT_PHASE_OPTIONS_POLICE;
		ShowAlFrakcioEditor(playerid);
	}
	else if(D_AlFrakcioEditor[playerid] == AFEDIT_PHASE_OPTIONS_POLICE)
	{
		switch(listitem)
		{
			case 0: // N�vv�lt�s
			{
				if(Admin(playerid, AFRAKCIO_EDITOR_MIN_ADMIN))
				{
					D_AlFrakcioEditor[playerid] = AFEDIT_PHASE_NAME_POLICE;
					ShowAlFrakcioEditor(playerid);
				}
				else
				{
					Msg(playerid, "Ehhez nincs jogod");
					ShowAlFrakcioEditor(playerid);
				}
			}
			case 1: // Skinek
			{
				if(Admin(playerid, AFRAKCIO_EDITOR_MIN_ADMIN))
				{
					D_AlFrakcioEditor[playerid] = AFEDIT_PHASE_SKIN_POLICE;
					ShowAlFrakcioEditor(playerid);
				}
				else
				{
					Msg(playerid, "Ehhez nincs jogod");
					ShowAlFrakcioEditor(playerid);
				}
			}
			case 2: // Rangok
			{
				D_AlFrakcioEditor[playerid] = AFEDIT_PHASE_RANG_POLICE;
				ShowAlFrakcioEditor(playerid);
			}
			case 3: // Kocsik
			{
				D_AlFrakcioEditor[playerid] = AFEDIT_PHASE_KOCSIK_POLICE;
				ShowAlFrakcioEditor(playerid);
			}
			
		}
	}
	else if(D_AlFrakcioEditor[playerid] == AFEDIT_PHASE_NAME_POLICE)
	{
		new frakcio = D_AlFrakcioEditor_Police[playerid];
		if(!sscanf(inputtext, "p<,>s[32]s[32]s[32]", ArrExt(PoliceAlosztaly[frakcio])))
		{
			INI_SAVE_AlFrakcioAdatPolice(frakcio);
			D_AlFrakcioEditor[playerid] = AFEDIT_PHASE_SUCCESS;
			new title[64]; format(title, 64, "Frakci�: %s", PoliceAlosztaly[frakcio][0]);
			CustomDialog(playerid, D:alfrakcioeditor, DIALOG_STYLE_MSGBOX, title, "Sikeresen m�dos�tottad az aloszt�ly nev�t", "Tov�bb", "Befejez�s");
		}
		else
		{
			ShowAlFrakcioEditor(playerid);
		}
	}
	else if(D_AlFrakcioEditor[playerid] == AFEDIT_PHASE_SKIN_POLICE)
	{
		D_AlFrakcioEditor_SelectedItem[playerid] = listitem;
		D_AlFrakcioEditor[playerid] = AFEDIT_PHASE_SKIN_EDIT_POLICE;
		ShowAlFrakcioEditor(playerid);
	}
	else if(D_AlFrakcioEditor[playerid] == AFEDIT_PHASE_SKIN_EDIT_POLICE)
	{
		new frakcio = D_AlFrakcioEditor_Police[playerid];
		new item = D_AlFrakcioEditor_SelectedItem[playerid];
		if(item && !sscanf(inputtext, "i", PoliceSkinek[frakcio][item-1]))
		{
			CheckAlFractionSkins(frakcio);
			INI_SAVE_AlFrakcioAdatPolice(frakcio);
			D_AlFrakcioEditor[playerid] = AFEDIT_PHASE_SUCCESS_SKIN;
			new title[64]; format(title, 64, "Aloszt�ly: %s", PoliceAlosztaly[frakcio][0]);
			CustomDialog(playerid, D:alfrakcioeditor, DIALOG_STYLE_MSGBOX, title, "Sikeresen m�dos�tottad az aloszt�ly egyik skinj�t", "Tov�bb", "Befejez�s");
			SkinDataRecalculate();
		}
		else if(!item && !sscanf(inputtext, "p<,>A<i>(0)["#MAX_FRAKCIO_SKIN"]", PoliceSkinek[frakcio]))
		{
			CheckAlFractionSkins(frakcio);
			INI_SAVE_AlFrakcioAdatPolice(frakcio);
			D_AlFrakcioEditor[playerid] = AFEDIT_PHASE_SUCCESS_SKIN;
			new title[64]; format(title, 64, "Aloszt�ly: %s", PoliceAlosztaly[frakcio][0]);
			CustomDialog(playerid, D:alfrakcioeditor, DIALOG_STYLE_MSGBOX, title, "Sikeresen m�dos�tottad az aloszt�ly skinjeit", "Tov�bb", "Befejez�s");
			SkinDataRecalculate();
		}
		else
		{
			ShowAlFrakcioEditor(playerid);
		}
	}
	else if(D_AlFrakcioEditor[playerid] == AFEDIT_PHASE_RANG_POLICE)
	{
		D_AlFrakcioEditor_SelectedItem[playerid] = listitem;
		D_AlFrakcioEditor[playerid] = AFEDIT_PHASE_RANG_EDIT_POLICE;
		ShowAlFrakcioEditor(playerid);
	}
	else if(D_AlFrakcioEditor[playerid] == AFEDIT_PHASE_RANG_EDIT_POLICE)
	{
		new frakcio = D_AlFrakcioEditor_Police[playerid];
		new item = D_AlFrakcioEditor_SelectedItem[playerid];
		
		new rang[32], bool:ok;
		ok = !sscanf(inputtext, "s[32]", rang);
		
		/*if(ok) for(new i = 0, l = strlen(rang); i < l; i++)
		{
			if( !('a' <= rang[i] <= 'z' || 'A' <= rang[i] <= 'Z' || '0' <= rang[i] <= '9' || rang[i] == '�' || rang) )
			
		}*/
		if(ok)
			ok = !!EngedelyezettKarakterek(rang, "������������������ ");
		
		if(ok)
		{
			strmid(PoliceRangok[frakcio][item], rang, 0, strlen(rang), 32);
			INI_SAVE_AlFrakcioAdatPolice(frakcio);
			D_AlFrakcioEditor[playerid] = AFEDIT_PHASE_SUCCESS_RANG;
			new title[64]; format(title, 64, "Aloszt�ly: %s", PoliceAlosztaly[frakcio][0]);
			CustomDialog(playerid, D:alfrakcioeditor, DIALOG_STYLE_MSGBOX, title, "Sikeresen m�dos�tottad az aloszt�ly egyik rangj�t", "Tov�bb", "Befejez�s");
		}
		else
		{
			ShowAlFrakcioEditor(playerid);
		}
	}
	else if(D_AlFrakcioEditor[playerid] == AFEDIT_PHASE_KOCSIK_POLICE)
	{
		D_AlFrakcioEditor_SelectedItem[playerid] = listitem;
		D_AlFrakcioEditor[playerid] = AFEDIT_PHASE_KOCSIK_EDIT_POLICE;
		ShowAlFrakcioEditor(playerid);
	}
	else if(D_AlFrakcioEditor[playerid] == AFEDIT_PHASE_KOCSIK_EDIT_POLICE)
	{
		new frakcio = D_AlFrakcioEditor_Police[playerid];
		new item = D_AlFrakcioEditor_SelectedItem[playerid];
		if(item && !sscanf(inputtext, "i", PoliceKocsik[frakcio][item-1]))
		{
			CheckAlFractionKocsik(frakcio);
			INI_SAVE_AlFrakcioAdatPolice(frakcio);
			D_AlFrakcioEditor[playerid] = AFEDIT_PHASE_SUCCESS_SKIN;
			new title[64]; format(title, 64, "Aloszt�ly: %s", PoliceAlosztaly[frakcio][0]);
			CustomDialog(playerid, D:alfrakcioeditor, DIALOG_STYLE_MSGBOX, title, "Sikeresen m�dos�tottad az aloszt�ly egyik kocsij�t", "Tov�bb", "Befejez�s");
		}
		else if(!item && !sscanf(inputtext, "p<,>A<i>(0)["#MAX_FRAKCIO_SKIN"]", PoliceKocsik[frakcio]))
		{
			CheckAlFractionKocsik(frakcio);
			INI_SAVE_AlFrakcioAdatPolice(frakcio);
			D_AlFrakcioEditor[playerid] = AFEDIT_PHASE_SUCCESS_SKIN;
			new title[64]; format(title, 64, "Aloszt�ly: %s", PoliceAlosztaly[frakcio][0]);
			CustomDialog(playerid, D:alfrakcioeditor, DIALOG_STYLE_MSGBOX, title, "Sikeresen m�dos�tottad az aloszt�ly kocsijait", "Tov�bb", "Befejez�s");
		}
		else
		{
			ShowAlFrakcioEditor(playerid);
		}
	}
	
	// siker
	else if(D_AlFrakcioEditor[playerid] == AFEDIT_PHASE_SUCCESS)
	{
		D_AlFrakcioEditor[playerid] = AFEDIT_PHASE_OPTIONS_POLICE;
		ShowAlFrakcioEditor(playerid);
	}
	else if(D_AlFrakcioEditor[playerid] == AFEDIT_PHASE_SUCCESS_SKIN)
	{
		D_AlFrakcioEditor[playerid] = AFEDIT_PHASE_OPTIONS_POLICE;
		ShowAlFrakcioEditor(playerid);
	}
	else if(D_AlFrakcioEditor[playerid] == AFEDIT_PHASE_SUCCESS_RANG)
	{
		D_AlFrakcioEditor[playerid] = AFEDIT_PHASE_OPTIONS_POLICE;
		ShowAlFrakcioEditor(playerid);
	}
	
	return 1;
}

CMD:alfrakcio(playerid, params[])
{
	if(Admin(playerid, AFRAKCIO_EDITOR_MIN_ADMIN))
	{
		D_AlFrakcioEditor[playerid] = AFEDIT_PHASE_FRACTION;
		ShowAlFrakcioEditor(playerid);
	}
	/*else if(PlayerInfo[playerid][pLeader] > 0)
	{
		D_FrakcioEditor_Frakcio[playerid] = PlayerInfo[playerid][pLeader];
		
		D_FrakcioEditor[playerid] = FEDIT_PHASE_OPTIONS;
		ShowFrakcioEditor(playerid);
	}*/
		
	return 1;
}

fpublic INI_LOAD_AlFrakcioAdatPolice(frakcio, name[], value[])
{
	new mentesnev[16];
	INI_Custom("PoliceAlosztaly", "p<,>s[32]s[32]s[32]", ArrExt(PoliceAlosztaly[frakcio]));
	
	INI_Custom("PoliceSkinek", "p<,>A<i>(0)[" #MAX_FRAKCIO_SKIN "]", PoliceSkinek[frakcio]); // definici�ban nem haszn�lhat� a stringizer (#)
	//if(egyezik(frakcio, "Skinek") && !sscanf(value, "p<,>A<i>(0)[" #MAX_FRAKCIO_SKIN "]", Skinek[frakcio-1])) return 1;
	
	// rangok
	for(new rang = 0; rang < MAX_FRAKCIO_RANG; rang++)
	{
		format(mentesnev, 16, "PoliceRangNev_%d", rang);
		INI_String(mentesnev, PoliceRangok[frakcio][rang], 32);
	}
	
	INI_Custom("PoliceKocsik", "p<,>A<i>(0)[" #MAX_FRAKCIO_SKIN "]", PoliceKocsik[frakcio]); // definici�ban nem haszn�lhat� a stringizer (#)
	
	return 0;
}

fpublic INI_SAVE_AlFrakcioAdatPolice(frakcio)
{
	new fName[128];
	format(fName, 128, "data/alfrakcio/alfrakcio_adat_police_%d.ini", frakcio);
	
	new INI:ini = INI_Open(fName);
	
	tformat(128, "%s,%s,%s", ArrExt(PoliceAlosztaly[frakcio]));
	INI_WriteString(ini, "PoliceAlosztaly", _tmpString);
	
	// skin
	tformat(256, "%d", (0 < PoliceSkinek[frakcio][0] < MAX_SKIN) ? PoliceSkinek[frakcio][0] : 0);
	for(new skin = 1; skin < MAX_FRAKCIO_SKIN; skin++)
	{
		if(0 < PoliceSkinek[frakcio][skin] < MAX_SKIN)
			tformat(256, "%s,%d", _tmpString, PoliceSkinek[frakcio][skin]);
	}
	INI_WriteString(ini, "PoliceSkinek", _tmpString);
	
	for(new rang = 0; rang < MAX_FRAKCIO_RANG; rang++)
	{
		tformat(64, "PoliceRangNev_%d", rang);
		INI_WriteString(ini, _tmpString, PoliceRangok[frakcio][rang]);
	}
	
	tformat(256, "%d", (0 < PoliceKocsik[frakcio][0] < MAX_VEHICLES) ? PoliceKocsik[frakcio][0] : 0);
	for(new skin = 1; skin < MAX_FRAKCIO_SKIN; skin++)
	{
		if(0 < PoliceKocsik[frakcio][skin] < MAX_VEHICLES)
			tformat(256, "%s,%d", _tmpString, PoliceKocsik[frakcio][skin]);
	}
	INI_WriteString(ini, "PoliceKocsik", _tmpString);
	
	INI_Close(ini);
}