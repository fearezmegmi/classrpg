#if defined __game_function_function_main
	#endinput
#endif
#define __game_function_function_main

main()
{
	IdoJaras[iValtas] = true;
	IdoJaras[iMost] = 0;
	IdoJaras[iLesz] = 10;
	
	new p;
	
	for(p = 0; p < MAX_PLAYERS; p++)
	{
		for(new o = 0; o < MAX_HO_OBJECT; o++)
			HoObject[p][o] = INVALID_OBJECT_ID;
	}
	
	for(p = 0; p < MAX_VEHICLES; p++)
	{
		NeonCar[p][0] = NINCS;
		NeonCar[p][1] = NINCS;
	}
	
	getdate(DatumEv, DatumHonap, DatumNap);
	format(JelenlegiDatum, 12, "%d-%d-%d", DatumEv, DatumHonap, DatumNap);
	
	SkinDataRecalculate();
}