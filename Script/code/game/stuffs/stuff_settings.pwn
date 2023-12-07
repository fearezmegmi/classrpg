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
			Format(spawnhely, "Saját lakás (%d)", PlayerInfo[playerid][pSpawnId]);
		}
		
		default:
		{
			spawnhely = "Hajléktalan szálló";
		}
	}
	
	Format(str, "{FFFFFF}Kezdõhely\t{AAFFAA}%s", spawnhely);
	
	dialogStatus[playerid] = SETTINGS_DIALOG_MAIN;
	CustomDialog(playerid, D:settings, DIALOG_STYLE_TABLIST, "Beállítások", str, "Tovább", "Mégse");
}

function ShowSpawnSettingsDialog(playerid)
{
	new str[256] = "{FFFFFF}Cím\tElhelyezkedés";
	strcat(str, "\n{FFAAAA}Hajléktalan szálló\t{AAAAFF}Los Santos");
	
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
	CustomDialog(playerid, D:settings, DIALOG_STYLE_TABLIST_HEADERS, "Kezdõhely", str, "Kiválaszt", "Mégse");
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
				// szálló
				case 0:
				{
					PlayerInfo[playerid][pSpawnType] = SPAWN_TYPE_DEFAULT;
				}
				
				// házak
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
			Msg(playerid, "Kezdõhely beállítva");
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