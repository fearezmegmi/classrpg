/*
Anti CBug | Gun22™

Ez az include lehetõvé teszi, hogy megszakítsa a lövések szinkronizálását
automatikusan, és meghívja az OnPlayerCBug eljárást, mikor észleli a CBugot.
*/

#if (!defined VectorSize)
	#error "Az Anti-CBug include-hoz minimum SA-MP 0.3z RC3 kell!"
#endif



//A minimum intervallum két lövés között.
#define CBUG_INTERVALLUM_COMBATSG	340
#define CBUG_INTERVALLUM_DESERT		700
#define CBUG_INTERVALLUM_SNIPER 	850
#define CBUG_INTERVALLUM_RIFLE		850
#define CBUG_INTERVALLUM_SHOTGUN	1000


//A lövén intervallum tárolásához
new utolsoLoves[MAX_PLAYERS];

//Ha '1', a CBug lövések szinkronizálása automatikusan megszakad
new szinkrKi = 1;
//Ha '1', az OnPlayerCBug meg lesz hívva CBug-oláskor
new kellHivas = 1;


forward OnPlayerCBug(playerid, weaponid, interval);

public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
	//Autóból történõ hamis riasztások elkerülése
	if (!IsPlayerInAnyVehicle(playerid) && (szinkrKi || kellHivas))
	{
		new interval = 0;
		switch (weaponid)
		{
			case 24: interval = CBUG_INTERVALLUM_DESERT;
			case 25: interval = CBUG_INTERVALLUM_SHOTGUN;
			case 27: interval = CBUG_INTERVALLUM_COMBATSG;
			case 33: interval = CBUG_INTERVALLUM_RIFLE;
			case 34: interval = CBUG_INTERVALLUM_SNIPER;
		}

		//Ellenõrzi, hogy CBug-fegyver-e
		if (interval > 0) {
			//Ellenõrzi, hogy az idõ-különbség pozitív, elkerülve a GetTickCount-nullázás hamis riasztásait
			if (GetTickCount() - utolsoLoves[playerid] < interval && GetTickCount() - utolsoLoves[playerid] >= 0)
			{
				if (kellHivas) CallLocalFunction("OnPlayerCBug", "iii", playerid, weaponid, GetTickCount() - utolsoLoves[playerid]);
				return !szinkrKi;
			}
			utolsoLoves[playerid] = GetTickCount();
		}
	}
	#if defined ACBUG_OnPlayerWeaponShot
		return ACBUG_OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ);
	#else
		return 1;
	#endif
}
#if defined _ALS_OnPlayerWeaponShot
	#undef OnPlayerWeaponShot
#else
	#define _ALS_OnPlayerWeaponShot
#endif
#define OnPlayerWeaponShot ACBUG_OnPlayerWeaponShot
#if defined ACBUG_OnPlayerWeaponShot
    forward ACBUG_OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ);
#endif
