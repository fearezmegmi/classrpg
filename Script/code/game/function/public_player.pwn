#if defined __game_function_public_player
	#endinput
#endif
#define __game_function_public_player

fpublic VisszaAllitas(playerid, jelzes)
{
	PlayerTextDrawSetString(playerid, Kellek[0], "_");
	switch(jelzes)
	{
		case 0: { PlayerTextDrawBoxColor(playerid, Jelzes[0], -2147483393); PlayerTextDrawHide(playerid, Jelzes[0]); PlayerTextDrawShow(playerid, Jelzes[0]); }
		case 1: return DeleteKeyPad(playerid);
	}
	Valtozott[playerid] = false;
	SelectTextDraw(playerid, 0xF7C25EAA);
	return true;
}

fpublic robpenzpakolas(playerid)
{
	if(GetPlayerDistanceFromPoint(playerid, -1154.985, -225.105, 14.197) > 5.0) return 1;

	new string[128];
	if(robpenzido[playerid] == 0)
	{
		format(string,sizeof(string), "* Valaki bepakolja a táskájába a pénzt.");
		ProxDetector(30.0, playerid, string, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		format(string, sizeof(string), "** Kiraboltad a bankot. Rabolt összeg: %dFt",robmoney);
		SendClientMessage(playerid,COLOR_YELLOW,string);
		BankSzef -=robmoney;
		GiveMoney(playerid, robmoney);
		robtimer = NINCS;
		Rabolt[playerid] = 300;
		TogglePlayerControllable(playerid, 1);
		ClearAnimations(playerid);
		return 1;
	}
	else
	{
	    robpenzido[playerid]--;
	    format(string, sizeof(string), "%d", robpenzido[playerid]);
     	GameTextForPlayer(playerid, string, 1000, 4);
	    SetTimerEx("robpenzpakolas", 975, false, "i", playerid);
	}
	return 1;
}

fpublic Bankkamera(playerid)
{
	CopMsg(COLOR_ALLDEPT, "Biztonsági õr: Figyelem! Valaki 3 perccel ezelõtt deaktiválta a San Fierroi bank kameráit! Vége.");
	SendClientMessage(playerid, COLOR_LIGHTGREEN, "Vigyázzatok, észrevették, hogy megbuheráltátok a kamerát! Tünés innen!");
	Hackeltkamera = false;
	return 1;
}

fpublic Mergezes(playerid)
{
		new string[256];
		if(Mergezve[playerid] < 1)
		{
			KiMergezte[playerid] = NINCS;
			Mergezve[playerid] = 0;
			return 1;
		}
		SetHealth(playerid, 0);
		if(PlayerInfo[playerid][pHeadValue] > 0)
		{
			if(IsHitman(KiMergezte[playerid]) && HitmanDuty[KiMergezte[playerid]])
			{
				SendFormatMessageToAll(COLOR_YELLOW, " <<< A bérgyilkos teljesítette a megbízó kérését - %s kinyírva >>> ", PlayerName(playerid));
				format(string,sizeof(string),"<< %s teljesítette a megbízást >>", PlayerInfo[KiMergezte[playerid]][pHitmanNev]);
				SendMessage(SEND_MESSAGE_HITMAN, string, COLOR_YELLOW);
				SendFormatMessage(KiMergezte[playerid], COLOR_LIGHTBLUE, "A megbízást teljesítetted. A cég átutalta a pénzt a számládra. (%dFt)", PlayerInfo[playerid][pHeadValue]);

				PlayerInfo[KiMergezte[playerid]][pAccount] += PlayerInfo[playerid][pHeadValue];
				PlayerInfo[playerid][pHeadValue] = 0;
				format(string, sizeof(string), "%s megmérgezte %s-t", PlayerInfo[KiMergezte[playerid]][pHitmanNev],  PlayerName(playerid));
				ABroadCast(COLOR_GREY, string, 1);
			}
		}
		KiMergezte[playerid] = NINCS;
		Mergezve[playerid] = 0;
		return 1;
}

fpublic ProxDetector2(Float:radi, string[], Float:oldposx, Float:oldposy, Float:oldposz, col1,col2,col3,col4,col5)
{
	new Float:posx, Float:posy, Float:posz;
	new Float:tempposx, Float:tempposy, Float:tempposz;
	//radi = 2.0; //Trigger Radius
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
		
			GetPlayerPos(i, posx, posy, posz);
			tempposx = (oldposx -posx);
			tempposy = (oldposy -posy);
			tempposz = (oldposz -posz);
			//printf("DEBUG: X:%f Y:%f Z:%f",posx,posy,posz);
			if (((tempposx < radi/16) && (tempposx > -radi/16)) && ((tempposy < radi/16) && (tempposy > -radi/16)) && ((tempposz < radi/16) && (tempposz > -radi/16)))
			{
				SendClientMessage(i, col1, string);
			}
			else if (((tempposx < radi/8) && (tempposx > -radi/8)) && ((tempposy < radi/8) && (tempposy > -radi/8)) && ((tempposz < radi/8) && (tempposz > -radi/8)))
			{
				SendClientMessage(i, col2, string);
			}
			else if (((tempposx < radi/4) && (tempposx > -radi/4)) && ((tempposy < radi/4) && (tempposy > -radi/4)) && ((tempposz < radi/4) && (tempposz > -radi/4)))
			{
				SendClientMessage(i, col3, string);
			}
			else if (((tempposx < radi/2) && (tempposx > -radi/2)) && ((tempposy < radi/2) && (tempposy > -radi/2)) && ((tempposz < radi/2) && (tempposz > -radi/2)))
			{
				SendClientMessage(i, col4, string);
			}
			else if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi)))
			{
				SendClientMessage(i, col5, string);
			}
		
		
		}
	}
	return 1;
}

fpublic Erositeslemond(playerid)
{
	if(!Erosites[playerid]) return false;
	SendClientMessage(playerid, COLOR_LIGHTBLUE, "Lejárt az erõsítésed! Ha még szükséged van rá, hívj újra!");
	Erosites[playerid] = false;
	CopMsgFormat(COLOR_LIGHTGREEN, "%s erõsítés kérése lejárt.", ICPlayerName(playerid));
	foreach(Jatekosok, x)
	{
		if(IsACop(x)) SetPlayerMarkerForPlayer(x, playerid, COLOR_INVISIBLE);
	}
	return 1;
}

fpublic ErositeslemondCsalad(playerid)
{
	if(!CsaladBK[playerid]) return false;
	SendClientMessage(playerid, COLOR_LIGHTBLUE, "Lejárt az erõsítésed! Ha még szükséged van rá, hívj újra!");
	CsaladBK[playerid] = false;
	new string[128];
	format(string, sizeof(string), "**[Vincenzo] %s erõsítés kérése lejárt.", ICPlayerName(playerid));
	SendMessage(SEND_MESSAGE_FAMILY, string, COLOR_DBLUE, 2);
	foreach(Jatekosok, x)
	{
		if(VincenzoTag(x)) SetPlayerMarkerForPlayer(x, playerid, COLOR_INVISIBLE);
	}
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	if(source != CLICK_SOURCE_SCOREBOARD) return 1;
	if(!Admin(playerid, 3) && !IsScripter(playerid)) return 1;
	if(clickedplayerid == INVALID_PLAYER_ID || clickedplayerid == playerid) return 1;
	if(PlayerInfo[clickedplayerid][pAdmin] > PlayerInfo[playerid][pAdmin] && !GOTOenged[clickedplayerid] && !IsScripter(playerid)) return SendFormatMessage(playerid, COLOR_GREY, "[Goto] %s nem engedélyezi hogy goto-z hozzá!", PlayerName(clickedplayerid));
	else if(PlayerInfo[clickedplayerid][pAdmin] > PlayerInfo[playerid][pAdmin] && !IsScripter(playerid) && !Admin(playerid, 1337)) SendFormatMessage(clickedplayerid, COLOR_GREY, "[Goto] %s teleportált hozzád!", PlayerName(playerid));
	new Float:pos[3];
	GetPlayerPos(clickedplayerid, ArrExt(pos));
	Tele(playerid, pos[0]-1.0, pos[1], pos[2], (GetPlayerState(playerid) == PLAYER_STATE_DRIVER ? true : false), GetPlayerVirtualWorld(clickedplayerid), GetPlayerInterior(clickedplayerid));
	SendClientMessage(playerid, COLOR_GRAD1, "Sikeres teleportálás");
	tformat(96, "[%d] %s - /goto %s", playerid, Nev(playerid), Nev(clickedplayerid));
	CommandLog(_tmpString);
	return 1;
}