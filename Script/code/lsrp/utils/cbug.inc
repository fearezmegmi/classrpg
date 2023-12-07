/*
Anti CBug | Gun22�

Ez az include lehet�v� teszi, hogy megszak�tsa a l�v�sek szinkroniz�l�s�t
automatikusan, �s megh�vja az OnPlayerCBug elj�r�st, mikor �szleli a CBugot.
*/

#if (!defined VectorSize)
	#error "Az Anti-CBug include-hoz minimum SA-MP 0.3z RC3 kell!"
#endif



//A minimum intervallum k�t l�v�s k�z�tt.
#define CBUG_INTERVALLUM_COMBATSG	340
#define CBUG_INTERVALLUM_DESERT		700
#define CBUG_INTERVALLUM_SNIPER 	850
#define CBUG_INTERVALLUM_RIFLE		850
#define CBUG_INTERVALLUM_SHOTGUN	1000


//A l�v�n intervallum t�rol�s�hoz
new utolsoLoves[MAX_PLAYERS];

//Ha '1', a CBug l�v�sek szinkroniz�l�sa automatikusan megszakad
new szinkrKi = 1;
//Ha '1', az OnPlayerCBug meg lesz h�vva CBug-ol�skor
new kellHivas = 1;


forward OnPlayerCBug(playerid, weaponid, interval);

public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
	//Aut�b�l t�rt�n� hamis riaszt�sok elker�l�se
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

		//Ellen�rzi, hogy CBug-fegyver-e
		if (interval > 0) {
			//Ellen�rzi, hogy az id�-k�l�nbs�g pozit�v, elker�lve a GetTickCount-null�z�s hamis riaszt�sait
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