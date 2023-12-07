#if defined __game_system_system_fraction_e
	#endinput
#endif
#define __game_system_system_fraction_e

// fedit
#define FEDIT_PHASE_FRACTION	1
#define FEDIT_PHASE_OPTIONS		2
#define FEDIT_PHASE_NAME		3
#define FEDIT_PHASE_LSKIN		4
#define FEDIT_PHASE_SKIN		5
#define FEDIT_PHASE_SKIN_EDIT	51
#define FEDIT_PHASE_MAXRANG		6
#define FEDIT_PHASE_RANG		7
#define FEDIT_PHASE_RANG_EDIT	71
#define FEDIT_PHASE_DUTY		8
#define FEDIT_PHASE_FEGYVER		9

#define FEDIT_PHASE_SUCCESS			1000
#define FEDIT_PHASE_SUCCESS_SKIN	1001
#define FEDIT_PHASE_SUCCESS_RANG	1002

#define FRAKCIO_EDITOR_MIN_ADMIN	(6)

new D_FrakcioEditor[MAX_PLAYERS], D_FrakcioEditor_Frakcio[MAX_PLAYERS], D_FrakcioEditor_SelectedItem[MAX_PLAYERS];

ShowFrakcioEditor(playerid)
{
	switch(D_FrakcioEditor[playerid])
	{
		case FEDIT_PHASE_FRACTION:
		{
			tformat(256, "[1]%s", Szervezetneve[0][2]);
			for(new i = 1; i < (MAX_FRAKCIO - 1); i++)
				tformat(256, "%s\n[%d]%s", _tmpString, i+1, Szervezetneve[i][2]);
			
			CustomDialog(playerid, D:frakcioeditor, DIALOG_STYLE_LIST, "Frakció editor", _tmpString, "Tovább", "Mégse");
		}
		case FEDIT_PHASE_OPTIONS:
		{
			new frakcio = D_FrakcioEditor_Frakcio[playerid];
			new title[64]; format(title, 64, "Frakció: %s", Szervezetneve[frakcio - 1][0]);
			
			if(Admin(playerid, FRAKCIO_EDITOR_MIN_ADMIN))
				CustomDialog(playerid, D:frakcioeditor, DIALOG_STYLE_LIST, title, "Névváltoztatás\nLeader skinek\nSkinek\nMaximum rang\nRangok\nDuty\nFegyver szállítás", "Tovább", "Vissza");
			else
				CustomDialog(playerid, D:frakcioeditor, DIALOG_STYLE_LIST, title, "-\n-\n-\nMaximum rang\nRangok", "Tovább", "Vissza");
		}
		case FEDIT_PHASE_NAME:
		{
			new frakcio = D_FrakcioEditor_Frakcio[playerid];
			tformat(256, "A frakció nevét a következõ formátumban kell megadni:\nTeljes név,Rövidítés,Ékezetmentes rövidítés\nPl.: Bank Õrei,BÕ,BO\n\nJelenlegi név:\n%s,%s,%s", \
				ArrExt(Szervezetneve[frakcio - 1]));
				
			new title[64]; format(title, 64, "Frakció: %s", Szervezetneve[frakcio - 1][0]);
			CustomDialog(playerid, D:frakcioeditor, DIALOG_STYLE_INPUT, title, _tmpString, "Mentés", "Mégse");
		}
		case FEDIT_PHASE_LSKIN:
		{
			new frakcio = D_FrakcioEditor_Frakcio[playerid];
			tformat(256, "A leader skineket a következõ formátumban kell megadni:\nFérfiSkin,NõiSkin\nPl.: 209,210\n\nJelenlegi leaderskinek:\n%d,%d", ArrExt2(LeaderSkinek[frakcio-1]));
				
			new title[64]; format(title, 64, "Frakció: %s", Szervezetneve[frakcio - 1][0]);
			CustomDialog(playerid, D:frakcioeditor, DIALOG_STYLE_INPUT, title, _tmpString, "Mentés", "Mégse");
		}
		case FEDIT_PHASE_SKIN:
		{
			new frakcio = D_FrakcioEditor_Frakcio[playerid];
			new list[1024];
			list = "Összes megadása kézzel";
			for(new s = 0; s < MAX_FRAKCIO_SKIN; s++)
			{
				if(Skinek[frakcio-1][s] != 0)
					format(list, 1024, "%s\nSkin: %d", list, Skinek[frakcio-1][s]);
				else
					format(list, 1024, "%s\nÜres", list);
			}
				
			new title[64]; format(title, 64, "Frakció: %s", Szervezetneve[frakcio - 1][0]);
			CustomDialog(playerid, D:frakcioeditor, DIALOG_STYLE_LIST, title, list, "Mentés", "Mégse");
		}
		case FEDIT_PHASE_SKIN_EDIT:
		{
			new frakcio = D_FrakcioEditor_Frakcio[playerid];
			new item = D_FrakcioEditor_SelectedItem[playerid];
			
			if(!item)
				_tmpString = "Összes skin megadása kézzel.\nFormátum: 13,14,15,16,17,18,...\nMaximum "#MAX_FRAKCIO_SKIN"db skin adható meg!";
			else
			{
				if(!Skinek[frakcio-1][item-1])
					_tmpString = "Az üres helyre kívánt skin megadása.\nEgy darab számot adhatsz meg.";
				else
					tformat(256, "A %d skint szeretnéd lecserélni.\nEgy darab számot adhatsz meg.", Skinek[frakcio-1][item-1]);
			}
				
			new title[64]; format(title, 64, "Frakció: %s", Szervezetneve[frakcio - 1][0]);
			CustomDialog(playerid, D:frakcioeditor, DIALOG_STYLE_INPUT, title, _tmpString, "Mentés", "Mégse");
		}
		case FEDIT_PHASE_MAXRANG:
		{
			new frakcio = D_FrakcioEditor_Frakcio[playerid];
			tformat(256, "A frakció rangjainak a számát adhatod meg.\nJelenleg: %d", OsszRang[frakcio]);
				
			new title[64]; format(title, 64, "Frakció: %s", Szervezetneve[frakcio - 1][0]);
			CustomDialog(playerid, D:frakcioeditor, DIALOG_STYLE_INPUT, title, _tmpString, "Mentés", "Mégse");
		}
		case FEDIT_PHASE_RANG:
		{
			new frakcio = D_FrakcioEditor_Frakcio[playerid];
			new list[1024];
			format(list, 1024, "[0]%s", Rangok[frakcio-1][0]);
			for(new r = 1; r < MAX_FRAKCIO_RANG; r++)
			{
				format(list, 1024, "%s\n[%d]%s", list, r, Rangok[frakcio-1][r]);
			}
				
			new title[64]; format(title, 64, "Frakció: %s", Szervezetneve[frakcio - 1][0]);
			CustomDialog(playerid, D:frakcioeditor, DIALOG_STYLE_LIST, title, list, "Mentés", "Mégse");
		}
		
		case FEDIT_PHASE_RANG_EDIT:
		{
			new frakcio = D_FrakcioEditor_Frakcio[playerid];
			new item = D_FrakcioEditor_SelectedItem[playerid];
			tformat(256, "A %d. rang nevét szeretnéd módosítani\nA jelenlegi neve: %s", item, Rangok[frakcio-1][item]);
				
			new title[64]; format(title, 64, "Frakció: %s", Szervezetneve[frakcio - 1][0]);
			CustomDialog(playerid, D:frakcioeditor, DIALOG_STYLE_INPUT, title, _tmpString, "Mentés", "Mégse");
		}
		case FEDIT_PHASE_DUTY:
		{
			new frakcio = D_FrakcioEditor_Frakcio[playerid];
			
			tformat(256, "[%s frakció]Duty sugara FLOAT (Pl.: 10.0)!", Szervezetneve[frakcio - 1][0]);
				
			new title[64]; format(title, 64, "Frakció duty:");
			CustomDialog(playerid, D:frakcioeditor, DIALOG_STYLE_INPUT, title, _tmpString, "Mentés", "Mégse");
		
		}
		case FEDIT_PHASE_FEGYVER:
		{
			new frakcio = D_FrakcioEditor_Frakcio[playerid];
			
			tformat(256, "[%s frakció]Lead hely sugara FLOAT (Pl.: 10.0)!", Szervezetneve[frakcio - 1][0]);
				
			new title[64]; format(title, 64, "Frakció fegyver lead hely:");
			CustomDialog(playerid, D:frakcioeditor, DIALOG_STYLE_INPUT, title, _tmpString, "Mentés", "Mégse");
		
		}
		
	}
}

stock CheckFractionSkins(frakcio)
{
	new free = -1, bool:changed;
	do
	{
		free = -1;
		changed = false;
		
		for(new i = 0; i < MAX_FRAKCIO_SKIN; i++)
		{
			if(!IsValidSkin(Skinek[frakcio-1][i]))
				Skinek[frakcio-1][i] = 0;
				
			if(free == -1 && !Skinek[frakcio-1][i])
				free = i;
			
			if(Skinek[frakcio-1][i] && free != -1)
			{
				Skinek[frakcio-1][free] = Skinek[frakcio-1][i];
				Skinek[frakcio-1][i] = 0;
				changed = true;
				break;
			}
		}
	}
	while(changed);
}

Dialog:frakcioeditor(playerid, response, listitem, inputtext[])
{
	if(!response)
	{
		switch(D_FrakcioEditor[playerid])
		{
			case FEDIT_PHASE_FRACTION, FEDIT_PHASE_SUCCESS:
				return 1;
			case FEDIT_PHASE_OPTIONS:
			{
				if(Admin(playerid, FRAKCIO_EDITOR_MIN_ADMIN))
				{
					D_FrakcioEditor[playerid] = FEDIT_PHASE_FRACTION;
					ShowFrakcioEditor(playerid);
				}
				return 1;
			}
			case FEDIT_PHASE_NAME, FEDIT_PHASE_LSKIN, FEDIT_PHASE_SKIN, FEDIT_PHASE_MAXRANG, FEDIT_PHASE_DUTY,FEDIT_PHASE_FEGYVER,FEDIT_PHASE_RANG:
			{
				D_FrakcioEditor[playerid] = FEDIT_PHASE_OPTIONS;
				ShowFrakcioEditor(playerid);
				return 1;
			}
			case FEDIT_PHASE_SKIN_EDIT:
			{
				D_FrakcioEditor[playerid] = FEDIT_PHASE_SKIN;
				ShowFrakcioEditor(playerid);
				return 1;
			}
			case FEDIT_PHASE_RANG_EDIT:
			{
				D_FrakcioEditor[playerid] = FEDIT_PHASE_RANG;
				ShowFrakcioEditor(playerid);
				return 1;
			}
		}
	}

	if(D_FrakcioEditor[playerid] == FEDIT_PHASE_FRACTION)
	{
		D_FrakcioEditor_Frakcio[playerid] = listitem + 1;
		D_FrakcioEditor[playerid] = FEDIT_PHASE_OPTIONS;
		
		ShowFrakcioEditor(playerid);
	}
	else if(D_FrakcioEditor[playerid] == FEDIT_PHASE_OPTIONS)
	{
		switch(listitem)
		{
			case 0: // Névváltás
			{
				if(Admin(playerid, FRAKCIO_EDITOR_MIN_ADMIN))
				{
					D_FrakcioEditor[playerid] = FEDIT_PHASE_NAME;
					ShowFrakcioEditor(playerid);
				}
				else
				{
					Msg(playerid, "Ehhez nincs jogod");
					ShowFrakcioEditor(playerid);
				}
			}
			case 1: // Leader skinek
			{
				if(Admin(playerid, FRAKCIO_EDITOR_MIN_ADMIN))
				{
					D_FrakcioEditor[playerid] = FEDIT_PHASE_LSKIN;
					ShowFrakcioEditor(playerid);
				}
				else
				{
					Msg(playerid, "Ehhez nincs jogod");
					ShowFrakcioEditor(playerid);
				}
			}
			case 2: // Skinek
			{
				if(Admin(playerid, FRAKCIO_EDITOR_MIN_ADMIN))
				{
					D_FrakcioEditor[playerid] = FEDIT_PHASE_SKIN;
					ShowFrakcioEditor(playerid);
				}
				else
				{
					Msg(playerid, "Ehhez nincs jogod");
					ShowFrakcioEditor(playerid);
				}
			}
			case 3: // Max rang
			{
				D_FrakcioEditor[playerid] = FEDIT_PHASE_MAXRANG;
				ShowFrakcioEditor(playerid);
			}
			case 4: // Rangok
			{
				D_FrakcioEditor[playerid] = FEDIT_PHASE_RANG;
				ShowFrakcioEditor(playerid);
			}
			case 5: //duty
			{
				if(Admin(playerid, FRAKCIO_EDITOR_MIN_ADMIN))
				{
					D_FrakcioEditor[playerid] = FEDIT_PHASE_DUTY;
					ShowFrakcioEditor(playerid);
				}
				else
				{
					Msg(playerid, "Ehhez nincs jogod");
					ShowFrakcioEditor(playerid);
				}
			}
			case 6: //fegyver lead
			{
				if(Admin(playerid, FRAKCIO_EDITOR_MIN_ADMIN))
				{
					D_FrakcioEditor[playerid] = FEDIT_PHASE_FEGYVER;
					ShowFrakcioEditor(playerid);
				}
				else
				{
					Msg(playerid, "Ehhez nincs jogod");
					ShowFrakcioEditor(playerid);
				}
			}
			
		}
	}
	else if(D_FrakcioEditor[playerid] == FEDIT_PHASE_NAME)
	{
		new frakcio = D_FrakcioEditor_Frakcio[playerid];
		if(!sscanf(inputtext, "p<,>s[32]s[32]s[32]", ArrExt(Szervezetneve[frakcio-1])))
		{
			INI_SAVE_FrakcioAdat(frakcio);
			D_FrakcioEditor[playerid] = FEDIT_PHASE_SUCCESS;
			new title[64]; format(title, 64, "Frakció: %s", Szervezetneve[frakcio - 1][0]);
			CustomDialog(playerid, D:frakcioeditor, DIALOG_STYLE_MSGBOX, title, "Sikeresen módosítottad a frakció nevét", "Tovább", "Befejezés");
		}
		else
		{
			ShowFrakcioEditor(playerid);
		}
	}
	else if(D_FrakcioEditor[playerid] == FEDIT_PHASE_LSKIN)
	{
		new frakcio = D_FrakcioEditor_Frakcio[playerid];
		if(!sscanf(inputtext, "p<,>ii", ArrExt2(LeaderSkinek[frakcio-1])))
		{
			INI_SAVE_FrakcioAdat(frakcio);
			D_FrakcioEditor[playerid] = FEDIT_PHASE_SUCCESS;
			new title[64]; format(title, 64, "Frakció: %s", Szervezetneve[frakcio - 1][0]);
			CustomDialog(playerid, D:frakcioeditor, DIALOG_STYLE_MSGBOX, title, "Sikeresen módosítottad a frakció leaderskinejeit", "Tovább", "Befejezés");
		}
		else
		{
			ShowFrakcioEditor(playerid);
		}
	}
	else if(D_FrakcioEditor[playerid] == FEDIT_PHASE_SKIN)
	{
		D_FrakcioEditor_SelectedItem[playerid] = listitem;
		D_FrakcioEditor[playerid] = FEDIT_PHASE_SKIN_EDIT;
		ShowFrakcioEditor(playerid);
	}
	else if(D_FrakcioEditor[playerid] == FEDIT_PHASE_SKIN_EDIT)
	{
		new frakcio = D_FrakcioEditor_Frakcio[playerid];
		new item = D_FrakcioEditor_SelectedItem[playerid];
		if(item && !sscanf(inputtext, "i", Skinek[frakcio-1][item-1]))
		{
			CheckFractionSkins(frakcio);
			INI_SAVE_FrakcioAdat(frakcio);
			D_FrakcioEditor[playerid] = FEDIT_PHASE_SUCCESS_SKIN;
			new title[64]; format(title, 64, "Frakció: %s", Szervezetneve[frakcio - 1][0]);
			CustomDialog(playerid, D:frakcioeditor, DIALOG_STYLE_MSGBOX, title, "Sikeresen módosítottad a frakció egyik skinjét", "Tovább", "Befejezés");
			SkinDataRecalculate();
		}
		else if(!item && !sscanf(inputtext, "p<,>A<i>(0)["#MAX_FRAKCIO_SKIN"]", Skinek[frakcio-1]))
		{
			CheckFractionSkins(frakcio);
			INI_SAVE_FrakcioAdat(frakcio);
			D_FrakcioEditor[playerid] = FEDIT_PHASE_SUCCESS_SKIN;
			new title[64]; format(title, 64, "Frakció: %s", Szervezetneve[frakcio - 1][0]);
			CustomDialog(playerid, D:frakcioeditor, DIALOG_STYLE_MSGBOX, title, "Sikeresen módosítottad a frakció skinjeit", "Tovább", "Befejezés");
			SkinDataRecalculate();
		}
		else
		{
			ShowFrakcioEditor(playerid);
		}
	}
	else if(D_FrakcioEditor[playerid] == FEDIT_PHASE_MAXRANG)
	{
		new frakcio = D_FrakcioEditor_Frakcio[playerid];
		if(!sscanf(inputtext, "i", OsszRang[frakcio]) && 1 <= OsszRang[frakcio] < MAX_FRAKCIO_RANG)
		{
			INI_SAVE_FrakcioAdat(frakcio);
			D_FrakcioEditor[playerid] = FEDIT_PHASE_SUCCESS;
			new title[64]; format(title, 64, "Frakció: %s", Szervezetneve[frakcio - 1][0]);
			CustomDialog(playerid, D:frakcioeditor, DIALOG_STYLE_MSGBOX, title, "Sikeresen módosítottad a frakció rangjainak a számát", "Tovább", "Befejezés");
		}
		else
		{
			ShowFrakcioEditor(playerid);
		}
	}
	
	else if(D_FrakcioEditor[playerid] == FEDIT_PHASE_DUTY)
	{
		new frakcio = D_FrakcioEditor_Frakcio[playerid];
		
		if(!sscanf(inputtext, "f", FrakcioInfo[frakcio][fDPosR]) && FrakcioInfo[frakcio][fDPosR] > 0 && FrakcioInfo[frakcio][fDPosR] < 20)
		{
		
			GetPlayerPos(playerid,FrakcioInfo[frakcio][fDPosX],FrakcioInfo[frakcio][fDPosY],FrakcioInfo[frakcio][fDPosZ]);
			
			FrakcioInfo[frakcio][fDVW] = GetPlayerVirtualWorld(playerid);
			FrakcioInfo[frakcio][fDINT] = GetPlayerInterior(playerid);
			SendFormatMessage(playerid,COLOR_YELLOW,"%.2f, %.2f, %.2f - R: %.2f VW: %d INT: %d",FrakcioInfo[frakcio][fDPosX],FrakcioInfo[frakcio][fDPosY],FrakcioInfo[frakcio][fDPosZ],FrakcioInfo[frakcio][fDPosR],FrakcioInfo[frakcio][fDVW],FrakcioInfo[frakcio][fDINT]);
			INI_SAVE_FrakcioAdat(frakcio);
			D_FrakcioEditor[playerid] = FEDIT_PHASE_SUCCESS;
			new title[64]; format(title, 64, "Frakció: %s", Szervezetneve[frakcio - 1][0]);
			CustomDialog(playerid, D:frakcioeditor, DIALOG_STYLE_MSGBOX, title, "Sikeresen módosítottad a frakció duty helyét!", "Tovább", "Befejezés");
		}
		else
		{
			ShowFrakcioEditor(playerid);
		}
	}
	else if(D_FrakcioEditor[playerid] == FEDIT_PHASE_FEGYVER)
	{
		new frakcio = D_FrakcioEditor_Frakcio[playerid];
		
		if(!sscanf(inputtext, "f", FrakcioInfo[frakcio][fFPosR]) && FrakcioInfo[frakcio][fDPosR] > 0 && FrakcioInfo[frakcio][fFPosR] < 20)
		{
		
			GetPlayerPos(playerid,FrakcioInfo[frakcio][fFPosX],FrakcioInfo[frakcio][fFPosY],FrakcioInfo[frakcio][fFPosZ]);
			
			FrakcioInfo[frakcio][fFVW] = GetPlayerVirtualWorld(playerid);
			FrakcioInfo[frakcio][fFINT] = GetPlayerInterior(playerid);
			
			INI_SAVE_FrakcioAdat(frakcio);
			D_FrakcioEditor[playerid] = FEDIT_PHASE_SUCCESS;
			new title[64]; format(title, 64, "Frakció: %s", Szervezetneve[frakcio - 1][0]);
			SendFormatMessage(playerid,COLOR_YELLOW,"%.2f, %.2f, %.2f - R: %.2f VW:%d INT:%d",FrakcioInfo[frakcio][fFPosX],FrakcioInfo[frakcio][fFPosY],FrakcioInfo[frakcio][fFPosZ],FrakcioInfo[frakcio][fFPosR],FrakcioInfo[frakcio][fFVW],FrakcioInfo[frakcio][fFINT]);
			CustomDialog(playerid, D:frakcioeditor, DIALOG_STYLE_MSGBOX, title, "Sikeresen módosítottad a fegyver leadó helyet!", "Tovább", "Befejezés");
		}
		else
		{
			
			ShowFrakcioEditor(playerid);
		}
	}
	else if(D_FrakcioEditor[playerid] == FEDIT_PHASE_RANG)
	{
		D_FrakcioEditor_SelectedItem[playerid] = listitem;
		D_FrakcioEditor[playerid] = FEDIT_PHASE_RANG_EDIT;
		ShowFrakcioEditor(playerid);
	}
	else if(D_FrakcioEditor[playerid] == FEDIT_PHASE_RANG_EDIT)
	{
		new frakcio = D_FrakcioEditor_Frakcio[playerid];
		new item = D_FrakcioEditor_SelectedItem[playerid];
		
		new rang[32], bool:ok;
		ok = !sscanf(inputtext, "s[32]", rang);
		
		/*if(ok) for(new i = 0, l = strlen(rang); i < l; i++)
		{
			if( !('a' <= rang[i] <= 'z' || 'A' <= rang[i] <= 'Z' || '0' <= rang[i] <= '9' || rang[i] == 'á' || rang) )
			
		}*/
		if(ok)
			ok = !!EngedelyezettKarakterek(rang, "áéíóöõúüûÁÉÍÓÖÕÚÜÛ ");
		
		if(ok)
		{
			strmid(Rangok[frakcio-1][item], rang, 0, strlen(rang), 32);
			INI_SAVE_FrakcioAdat(frakcio);
			D_FrakcioEditor[playerid] = FEDIT_PHASE_SUCCESS_RANG;
			new title[64]; format(title, 64, "Frakció: %s", Szervezetneve[frakcio - 1][0]);
			CustomDialog(playerid, D:frakcioeditor, DIALOG_STYLE_MSGBOX, title, "Sikeresen módosítottad a frakció egyik rangját", "Tovább", "Befejezés");
		}
		else
		{
			ShowFrakcioEditor(playerid);
		}
	}
	
	// siker
	else if(D_FrakcioEditor[playerid] == FEDIT_PHASE_SUCCESS)
	{
		D_FrakcioEditor[playerid] = FEDIT_PHASE_OPTIONS;
		ShowFrakcioEditor(playerid);
	}
	else if(D_FrakcioEditor[playerid] == FEDIT_PHASE_SUCCESS_SKIN)
	{
		D_FrakcioEditor[playerid] = FEDIT_PHASE_SKIN;
		ShowFrakcioEditor(playerid);
	}
	else if(D_FrakcioEditor[playerid] == FEDIT_PHASE_SUCCESS_RANG)
	{
		D_FrakcioEditor[playerid] = FEDIT_PHASE_RANG;
		ShowFrakcioEditor(playerid);
	}
	
	return 1;
}

CMD:frakcio(playerid, params[])
{
	if(Admin(playerid, FRAKCIO_EDITOR_MIN_ADMIN))
	{
		D_FrakcioEditor[playerid] = FEDIT_PHASE_FRACTION;
		ShowFrakcioEditor(playerid);
	}
	/*else if(PlayerInfo[playerid][pLeader] > 0)
	{
		D_FrakcioEditor_Frakcio[playerid] = PlayerInfo[playerid][pLeader];
		
		D_FrakcioEditor[playerid] = FEDIT_PHASE_OPTIONS;
		ShowFrakcioEditor(playerid);
	}*/
		
	return 1;
}

fpublic INI_LOAD_FrakcioAdat(frakcio, name[], value[])
{
	new mentesnev[16];
	INI_Int("OsszRang", OsszRang[frakcio]);
	INI_Custom("LeaderSkinek", "p<,>a<i>[2]", LeaderSkinek[frakcio-1]);
	INI_Custom("SzervezetNeve", "p<,>s[32]s[32]s[32]", ArrExt(Szervezetneve[frakcio-1]));
	
	INI_Custom("Skinek", "p<,>A<i>(0)[" #MAX_FRAKCIO_SKIN "]", Skinek[frakcio-1]); // definicióban nem használható a stringizer (#)
	//if(egyezik(frakcio, "Skinek") && !sscanf(value, "p<,>A<i>(0)[" #MAX_FRAKCIO_SKIN "]", Skinek[frakcio-1])) return 1;
	
	// rangok
	for(new rang = 0; rang < MAX_FRAKCIO_RANG; rang++)
	{
		format(mentesnev, 16, "RangNev_%d", rang);
		INI_String(mentesnev, Rangok[frakcio-1][rang], 32);
	}
	
	INI_Custom("duty", "p<,>ffffdd",FrakcioInfo[frakcio][fDPosX],FrakcioInfo[frakcio][fDPosY],FrakcioInfo[frakcio][fDPosZ],FrakcioInfo[frakcio][fDPosR],FrakcioInfo[frakcio][fDVW],FrakcioInfo[frakcio][fDINT]);
	INI_Custom("fegyverszallitas", "p<,>ffffdd",FrakcioInfo[frakcio][fFPosX],FrakcioInfo[frakcio][fFPosY],FrakcioInfo[frakcio][fFPosZ],FrakcioInfo[frakcio][fFPosR],FrakcioInfo[frakcio][fDVW],FrakcioInfo[frakcio][fDINT]);

	return 0;
}

fpublic INI_SAVE_FrakcioAdat(frakcio)
{
	new fName[128];
	format(fName, 128, "data/frakcio/frakcio_adat_%d.ini", frakcio);
	
	new INI:ini = INI_Open(fName);
	
	INI_WriteInt(ini,"OsszRang", OsszRang[frakcio]);
	
	tformat(128, "%d,%d", ArrExt2(LeaderSkinek[frakcio-1]));
	INI_WriteString(ini,"LeaderSkinek", _tmpString);
	
	// skin
	tformat(256, "%d", (0 < Skinek[frakcio-1][0] < MAX_SKIN) ? Skinek[frakcio-1][0] : 0);
	for(new skin = 1; skin < MAX_FRAKCIO_SKIN; skin++)
	{
		if(0 < Skinek[frakcio-1][skin] < MAX_SKIN)
			tformat(256, "%s,%d", _tmpString, Skinek[frakcio-1][skin]);
	}
	INI_WriteString(ini, "Skinek", _tmpString);
	
	tformat(128, "%s,%s,%s", ArrExt(Szervezetneve[frakcio-1]));
	INI_WriteString(ini, "SzervezetNeve", _tmpString);
	
	for(new rang = 0; rang < MAX_FRAKCIO_RANG; rang++)
	{
		tformat(64, "RangNev_%d", rang);
		INI_WriteString(ini, _tmpString, Rangok[frakcio-1][rang]);
	}
	
	
	tformat(sizeof(_tmpString),"%f,%f,%f,%f,%d,%d",FrakcioInfo[frakcio][fDPosX],FrakcioInfo[frakcio][fDPosY],FrakcioInfo[frakcio][fDPosZ],FrakcioInfo[frakcio][fDPosR],FrakcioInfo[frakcio][fDVW],FrakcioInfo[frakcio][fDINT]);
	INI_WriteString(ini,"duty",_tmpString);
		
	tformat(sizeof(_tmpString),"%f,%f,%f,%f,%d,%d",FrakcioInfo[frakcio][fFPosX],FrakcioInfo[frakcio][fFPosY],FrakcioInfo[frakcio][fFPosZ],FrakcioInfo[frakcio][fFPosR],FrakcioInfo[frakcio][fDVW],FrakcioInfo[frakcio][fDINT]);
	INI_WriteString(ini,"fegyverszallitas",_tmpString);
	
	INI_Close(ini);
}