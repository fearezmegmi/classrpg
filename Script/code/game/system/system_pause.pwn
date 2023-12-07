#if defined __game_system_system_pause
	#endinput
#endif
#define __game_system_system_pause

/////////////////////////////////////////////////////////
// OnPlayerPause                                       //
//    Script By Clint                                  //
//       for ClassRPG.net                              //
//                                                     //
// Description:                                        //
// - Detect when a player ESC / Tabbing                //
//                                                     //
// Callbacks:                                          //
// - OnPlayerPause( playerid, bool:paused )            //
//                                                     //
// Per-player variables:                               //
// - gPaused[playerid] (bool) - paused or not          //
// - gLastUpdate[playerid] - last update               //
/////////////////////////////////////////////////////////

#define SYSTEM_PAUSE_TIME	(3)

new gPaused[MAX_PLAYERS], gLastUpdate[MAX_PLAYERS];
forward OnPlayerPause(playerid, paused);

stock onPause_Update(playerid)
{
	if(gPaused[playerid])
	{
		CallLocalFunction("OnPlayerPause", "dd", playerid, 0);
		gPaused[playerid] = 0;
	}

	gLastUpdate[playerid] = UnixTime;
}

stock onPause_Init()
{
	SetTimer("onPause_Timer", 990, 1);
}

fpublic onPause_Timer()
{
	foreach(Jatekosok, p)
	{
		if(!gPaused[p] && (UnixTime - gLastUpdate[p]) >= SYSTEM_PAUSE_TIME)
		{
			CallLocalFunction("OnPlayerPause", "dd", p, 1);
			gPaused[p] = 1;
		}
	}
}