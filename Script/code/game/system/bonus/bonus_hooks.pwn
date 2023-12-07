// ---------------------------------
// HOOK: OnPlayerEnterDynamicArea
// ---------------------------------
forward P:OnPlayerEnterDynamicArea(playerid, areaid);
public OnPlayerEnterDynamicArea(playerid, areaid)
{
	P:OnPlayerEnterDynamicArea(playerid, areaid);
	#if defined Hook_OnPlayerEnterDynamicArea
		Hook_OnPlayerEnterDynamicArea(playerid, areaid);
	#endif
	return 1;
}

#if defined _ALS_OnPlayerEnterDynamicArea
	#undef OnPlayerEnterDynamicArea
#else
	#define _ALS_OnPlayerEnterDynamicArea
#endif
#define OnPlayerEnterDynamicArea Hook_OnPlayerEnterDynamicArea

#if defined Hook_OnPlayerEnterDynamicArea
    forward Hook_OnPlayerEnterDynamicArea(playerid, areaid);
#endif

// ---------------------------------
// HOOK: OnPlayerLeaveDynamicArea
// ---------------------------------
forward P:OnPlayerLeaveDynamicArea(playerid, areaid);
public OnPlayerLeaveDynamicArea(playerid, areaid)
{
	P:OnPlayerLeaveDynamicArea(playerid, areaid);
	#if defined Hook_OnPlayerLeaveDynamicArea
		Hook_OnPlayerLeaveDynamicArea(playerid, areaid);
	#endif
	return 1;
}

#if defined _ALS_OnPlayerLeaveDynamicArea
	#undef OnPlayerLeaveDynamicArea
#else
	#define _ALS_OnPlayerLeaveDynamicArea
#endif
#define OnPlayerLeaveDynamicArea Hook_OnPlayerLeaveDynamicArea

#if defined Hook_OnPlayerLeaveDynamicArea
    forward Hook_OnPlayerLeaveDynamicArea(playerid, areaid);
#endif

// ---------------------------------
// HOOK: OnGameModeInit
// ---------------------------------
forward P:OnGameModeInit();
public OnGameModeInit()
{
	P:OnGameModeInit();
	#if defined Hook_OnGameModeInit
		Hook_OnGameModeInit();
	#endif
	return 1;
}

#if defined _ALS_OnGameModeInit
	#undef OnGameModeInit
#else
	#define _ALS_OnGameModeInit
#endif
#define OnGameModeInit Hook_OnGameModeInit

#if defined Hook_OnGameModeInit
    forward Hook_OnGameModeInit();
#endif

// ---------------------------------
// HOOK: OnPlayerConnect
// ---------------------------------
forward P:OnPlayerConnect(playerid);
public OnPlayerConnect(playerid)
{
	P:OnPlayerConnect(playerid);
	#if defined Hook_OnPlayerConnect
		Hook_OnPlayerConnect(playerid);
	#endif
	return 1;
}

#if defined _ALS_OnPlayerConnect
	#undef OnPlayerConnect
#else
	#define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect Hook_OnPlayerConnect

#if defined Hook_OnPlayerConnect
    forward Hook_OnPlayerConnect(playerid);
#endif

// ---------------------------------
// HOOK: OnPlayerDisconnect
// ---------------------------------
forward P:OnPlayerDisconnect(playerid, reason);
public OnPlayerDisconnect(playerid, reason)
{
	P:OnPlayerDisconnect(playerid, reason);
	#if defined Hook_OnPlayerDisconnect
		Hook_OnPlayerDisconnect(playerid, reason);
	#endif
	return 1;
}

#if defined _ALS_OnPlayerDisconnect
	#undef OnPlayerDisconnect
#else
	#define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect Hook_OnPlayerDisconnect

#if defined Hook_OnPlayerDisconnect
    forward Hook_OnPlayerDisconnect(playerid, reason);
#endif

// ---------------------------------
// HOOK: OnPlayerClickTextDraw
// ---------------------------------
forward P:OnPlayerClickTextDraw(playerid, Text:clickedid);
public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
	P:OnPlayerClickTextDraw(playerid, Text:clickedid);
	#if defined Hook_OnPlayerClickTextDraw
		Hook_OnPlayerClickTextDraw(playerid, Text:clickedid);
	#endif
	return 1;
}

#if defined _ALS_OnPlayerClickTextDraw
	#undef OnPlayerClickTextDraw
#else
	#define _ALS_OnPlayerClickTextDraw
#endif
#define OnPlayerClickTextDraw Hook_OnPlayerClickTextDraw

#if defined Hook_OnPlayerClickTextDraw
    forward Hook_OnPlayerClickTextDraw(playerid, Text:clickedid);
#endif

// ---------------------------------
// HOOK: OnPlayerClickPlayerTextDraw
// ---------------------------------
forward P:OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid);
public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
	P:OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid);
	#if defined H_OnPlayerClickPlayerTextDraw
		H_OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid);
	#endif
	return 1;
}

#if defined OnPlayerClickPlayerTextDraw
	#undef OnPlayerClickPlayerTextDraw
#else
	#define _ALS_OnPlayerClickPlayerTextDraw
#endif
#define OnPlayerClickPlayerTextDraw H_OnPlayerClickPlayerTextDraw

#if defined H_OnPlayerClickPlayerTextDraw
    forward H_OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid);
#endif

// ---------------------------------
// HOOK: OnPlayerLoginComplete
// ---------------------------------
forward P:OnPlayerLoginComplete(playerid);
fpublic OnPlayerLoginComplete(playerid)
{
	printf("[Hook] OnPlayerLoginComplete(playerid = %d)", playerid);
	P:OnPlayerLoginComplete(playerid);
	#if defined OnPlayerLoginComplete || defined Hook_OnPlayerLoginComplete
		Hook_OnPlayerLoginComplete(playerid);
	#endif
	return 1;
}

#if defined _ALS_OnPlayerLoginComplete
	#undef OnPlayerLoginComplete
#else
	#define _ALS_OnPlayerLoginComplete
#endif
#define OnPlayerLoginComplete Hook_OnPlayerLoginComplete

#if defined Hook_OnPlayerLoginComplete
    forward Hook_OnPlayerLoginComplete(playerid);
#endif
