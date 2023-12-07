#if defined __util_player
	#endinput
#endif
#define __util_player

stock IsPlayerInWater(playerid)
{
	new anim = GetPlayerAnimationIndex(playerid);
    return (anim >= 1538 && anim <= 1544 && anim != 1542);
}