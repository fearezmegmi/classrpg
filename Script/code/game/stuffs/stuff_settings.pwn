#if defined __stuff_settings
	#endinput
#endif
#define __stuff_settings

#define SETTINGS_DIALOG_MAIN	(0)
#define SETTINGS_DIALOG_SPAWN	(1)

static dialogStatus[MAX_PLAYERS]; 

function ShowSettingsDialog(playerid)
{
	new str[512];
	
	// spawn hely
	new spawnhely[64];
	switch(PlayerInfo[playerid][pSpawnType])
	{
		case SPAWN_TYPE_HOUSE:
		{
			Format(spawnhely, "Saj�t lak�s (%d)", PlayerInfo[playerid][pSpawnId]);
		}
		
		default:
		{
			spawnhely = "Hajl�ktalan sz�ll�";
		}
	}
	
	Format(str, "{FFFFFF}Kezd�hely\t{AAFFAA}%s", spawnhely);
	
	dialogStatus[playerid] = SETTINGS_DIALOG_MAIN;
	CustomDialog(playerid, D:settings, DIALOG_STYLE_TABLIST, "Be�ll�t�sok", str, "Tov�bb", "M�gse");
}

function ShowSpawnSettingsDialog(playerid)
{
	new str[256] = "{FFFFFF}C�m\tElhelyezked�s";
	strcat(str, "\n{FFAAAA}Hajl�ktalan sz�ll�\t{AAAAFF}Los Santos");
	
	new hazak[3];
	hazak[0] = PlayerInfo[playerid][pPhousekey];
	hazak[1] = PlayerInfo[playerid][pPhousekey2];
	hazak[2] = PlayerInfo[playerid][pPhousekey3];
	
	for(new i = 0, l = sizeof(hazak); i < l; i++)
	{
		if(hazak[i] == NINCS)
			break;
			
		Format(str, "%s\n{AAFFAA}Class u. %d.\t{AAAAFF}%s", str, hazak[i], Haztipus(HouseInfo[hazak[i]][hTipus]));
	}
	
	dialogStatus[playerid] = SETTINGS_DIALOG_SPAWN;
	CustomDialog(playerid, D:settings, DIALOG_STYLE_TABLIST_HEADERS, "Kezd�hely", str, "Kiv�laszt", "M�gse");
}

Dialog:settings(playerid, response, listitem, inputtext[])
{
	switch(dialogStatus[playerid])
	{
		case SETTINGS_DIALOG_MAIN:
		{
			if(!response)
				return 1;
				
			ShowSpawnSettingsDialog(playerid);
		}
		
		case SETTINGS_DIALOG_SPAWN:
		{
			if(!response)
			{
				ShowSettingsDialog(playerid);
				return 1;
			}
			
			switch(listitem)
			{
				// sz�ll�
				case 0:
				{
					PlayerInfo[playerid][pSpawnType] = SPAWN_TYPE_DEFAULT;
				}
				
				// h�zak
				case 1:
				{
					PlayerInfo[playerid][pSpawnType] = SPAWN_TYPE_HOUSE;
					PlayerInfo[playerid][pSpawnId] = PlayerInfo[playerid][pPhousekey];
				}
				case 2:
				{
					PlayerInfo[playerid][pSpawnType] = SPAWN_TYPE_HOUSE;
					PlayerInfo[playerid][pSpawnId] = PlayerInfo[playerid][pPhousekey2];
				}
				case 3:
				{
					PlayerInfo[playerid][pSpawnType] = SPAWN_TYPE_HOUSE;
					PlayerInfo[playerid][pSpawnId] = PlayerInfo[playerid][pPhousekey3];
				}
			}
			
			ShowSettingsDialog(playerid);
			Msg(playerid, "Kezd�hely be�ll�tva");
		}
	}
	
	return 1;
}

ALIAS(beallitasok):settings;
ALIAS(be1ll3t1sok):settings;
CMD:settings(playerid, params[])
{
	ShowSettingsDialog(playerid);
	return 1;
}