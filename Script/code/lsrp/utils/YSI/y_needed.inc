forward PlayerIsAdmin(playerid, arg1, arg2);
public PlayerIsAdmin(playerid, arg1, arg2)
{
	if(arg1 >= arg2)
	{
		return 1;
	}
	return 0;
}

stock IsAdmin(playerid)
{
	return CallRemoteFunction("PlayerIsAdmin", "ddd", playerid, PlayerInfo[playerid][pAdmin], 1);
}

stock Admin(playerid, szint = 1)
{
	if(!IsPlayerNPC(playerid)){
		new valasz = CallRemoteFunction("PlayerIsAdmin", "ddd",playerid, PlayerInfo[playerid][pAdmin], szint);
		if(IsScripter(playerid) || IsRolee(playerid) || IsFanatik(playerid))
			return true;
		else
			return valasz;
	}
	else
	{
		return true;
	}
}

