function bool:P:IsMarkTriggered(playerid, bool:checkMarkCount)
{
	new marks;
	if(checkMarkCount)
		marks = CountMarkedPlayers();

	new bool:trigger = true;
	new bool:anyCheck = false;
	
	// time
	if(PlayerInfo[playerid][pMarkTriggerTime] > 0)
	{
		anyCheck = true;
		if(PlayerInfo[playerid][pMarkTriggerTime] > UnixTime)
			trigger = false;
	}
	
	// min players
	if(PlayerInfo[playerid][pMarkMinPlayers] > 0)
	{
		anyCheck = true;
		if(PlayerInfo[playerid][pMarkMinPlayers] > Iter_Count(Jatekosok))
			trigger = false;
	}
	
	// min mark players
	if(checkMarkCount && PlayerInfo[playerid][pMarkMinMarkedPlayers] > 0)
	{
		anyCheck = true;
		if(PlayerInfo[playerid][pMarkMinMarkedPlayers] > marks)
			trigger = false;
	}
	
	return (anyCheck && trigger);
}

function CountMarkedPlayers(bool:triggered = true)
{
	new count;
	foreach(Jatekosok, p)
	{
		if(PlayerInfo[p][pMarkLevel] > 0 && (!triggered || P:IsMarkTriggered(p, false)))
			count++;
	}
	
	return count;
}