public P:OnGameModeInit()
{
	print("MARK: init");
	SetTimer(PS "OnCheckPlayersTick", 10000, 1);
	return 1;
}

fpublic P:OnCheckPlayersTick()
{
	foreach(Jatekosok, p)
	{
		if(PlayerInfo[p][pMarkLevel] > 0)
		{
			if(P:IsMarkTriggered(p, true))
				P:OnPlayerWantsBan(p);
		}
	}
}

function P:OnPlayerWantsBan(playerid)
{
	new string[MAX_CLIENT_MESSAGE_LENGTH];
	
	format(string, sizeof(string), "ClassRPG: %s ki lett tiltva a rendszer által (késleltetett)", playerid);
	SendClientMessageToAll(COLOR_LIGHTRED, string);
	BanLog(string);
	
	format(string, sizeof(string), "ClassRPG: Oka: %s", PlayerInfo[playerid][pMarkReason]);
	SendClientMessageToAll(COLOR_LIGHTRED, string);
	BanLog(string);
	
	SeeBan(playerid, .oka = PlayerInfo[playerid][pMarkReason]);
}