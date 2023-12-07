#if defined __core_hookable_methods
	#endinput
#endif
#define __core_hookable_methods

stock CallOnPlayerLoginComplete(playerid)
{
	OnPlayerLoginComplete(playerid);
}