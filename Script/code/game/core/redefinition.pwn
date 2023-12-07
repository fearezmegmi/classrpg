#if defined __game_core_redefinition
	#endinput
#endif
#define __game_core_redefinition

stock ShowPlayerDialogEx(playerid, dialogid, style, caption[], info[], button1[], button2[])
{
	return (DialogID[playerid] = dialogid, DialogStyle[playerid] = style, ShowPlayerDialog(playerid, dialogid, style, caption, info, button1, button2));
}
#define ShowPlayerDialog ShowPlayerDialogEx

stock SetPlayerVirtualWorld_Ex(playerid, uj, oka[] = "-")
{
	printf("VW[%d,%d,%s]", playerid, uj, oka);
	SetPlayerVirtualWorld(playerid, uj);
}
#define SetPlayerVirtualWorld SetPlayerVirtualWorld_Ex

/*stock SetPlayerInterior_Ex(playerid, uj, oka[])
{
	printf("VW[%d,%d,%s]", playerid, uj, oka);
	SetPlayerInterior(playerid, uj);
}
#define SetPlayerInterior SetPlayerInterior_Ex*/

#if defined TEMP_NO_IP_BAN
	stock Ban_EX(playerid)
	{
		return 1;
	}
	stock BanEx_EX(playerid, const reason[])
	{
		return 1;
	}
	#define Ban Ban_EX
	#define BanEx BanEx_EX
#endif