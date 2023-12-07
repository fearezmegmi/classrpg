// ---------------------------------
// HOOK: OnGameModeInit
// ---------------------------------
forward P:OnGameModeInit();
public OnGameModeInit()
{
	P:OnGameModeInit();
	#if defined MH_OnGameModeInit
		MH_OnGameModeInit();
	#endif
	return 1;
}

#if defined _ALS_OnGameModeInit
	#undef OnGameModeInit
#else
	#define _ALS_OnGameModeInit
#endif
#define OnGameModeInit MH_OnGameModeInit

#if defined MH_OnGameModeInit
    forward MH_OnGameModeInit();
#endif

/*
// ---------------------------------
// HOOK: OnPlayerConnect
// ---------------------------------
forward P:OnPlayerConnect(playerid);
public OnPlayerConnect(playerid)
{
	P:OnPlayerConnect(playerid);
	#if defined MH_OnPlayerConnect
		MH_OnPlayerConnect(playerid);
	#endif
	return 1;
}

#if defined _ALS_OnPlayerConnect
	#undef OnPlayerConnect
#else
	#define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect MH_OnPlayerConnect

#if defined MH_OnPlayerConnect
    forward MH_OnPlayerConnect(playerid);
#endif

// ---------------------------------
// HOOK: OnPlayerDisconnect
// ---------------------------------
forward P:OnPlayerDisconnect(playerid, reason);
public OnPlayerDisconnect(playerid, reason)
{
	P:OnPlayerDisconnect(playerid, reason);
	#if defined MH_OnPlayerDisconnect
		MH_OnPlayerDisconnect(playerid, reason);
	#endif
	return 1;
}

#if defined _ALS_OnPlayerDisconnect
	#undef OnPlayerDisconnect
#else
	#define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect MH_OnPlayerDisconnect

#if defined MH_OnPlayerDisconnect
    forward MH_OnPlayerDisconnect(playerid, reason);
#endif

// ---------------------------------
// HOOK: OnPlayerLoginComplete
// ---------------------------------
forward P:OnPlayerLoginComplete(playerid);
fpublic OnPlayerLoginComplete(playerid)
{
	printf("[Hook] OnPlayerLoginComplete(playerid = %d)", playerid);
	P:OnPlayerLoginComplete(playerid);
	#if defined OnPlayerLoginComplete || defined MH_OnPlayerLoginComplete
		MH_OnPlayerLoginComplete(playerid);
	#endif
	return 1;
}

#if defined _ALS_OnPlayerLoginComplete
	#undef OnPlayerLoginComplete
#else
	#define _ALS_OnPlayerLoginComplete
#endif
#define OnPlayerLoginComplete MH_OnPlayerLoginComplete

#if defined MH_OnPlayerLoginComplete
    forward MH_OnPlayerLoginComplete(playerid);
#endif
*/