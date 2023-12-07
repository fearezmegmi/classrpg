new IllegalDrogActor, IllegalFegyverActor;

stock GetOnlineActors()
{
	new number = 0;
	ActorForeach(x)
	{
		if(IsValidActor(x))
		{
			number ++;
		}
	}
	return number;
}

stock LoadActors()
{
	new actor;
	/* ================================= HATÁROKNÁL ================================= */
	// LS-SF
	actor = CreateActor(280, 66.8418, -1545.0469, 5.0772, 63.2668); // ls-sf1
	ApplyActorAnimation(actor, "DEALER", "DEALER_IDLE", 4.1, 0, 1, 1, 1, 1);
	
	actor = CreateActor(281, 37.7081, -1525.5497, 5.2241, 331.6277); // ls-sf2
	ApplyActorAnimation(actor, "DEALER", "DEALER_IDLE", 4.1, 0, 1, 1, 1, 1);
	
	actor = CreateActor(280, 45.1142, -1532.6281, 5.3512, 174.1879); // ls-sf3
	ApplyActorAnimation(actor, "PED", "IDLE_taxi", 4.0, 0, 0, 0, 0, -1);
	
	actor = CreateActor(281, 57.0798, -1533.2058, 5.2401, 81.5853); // ls-sf4
	ApplyActorAnimation(actor, "COP_AMBIENT", "Coplook_loop", 4.0, 0, 1, 1, 1, -1);
	
	// LS-ALAGÚT
	actor = CreateActor(280, 628.6655, -1194.1875, 18.1169, 208.8437); // alagútbejárat
	ApplyActorAnimation(actor, "DEALER", "DEALER_IDLE", 4.1, 0, 1, 1, 1, 1);
	
	actor = CreateActor(281, 615.9117, -1197.9060, 18.5367, 18.1277); // alagútkijárat
	ApplyActorAnimation(actor, "COP_AMBIENT", "Coplook_loop", 4.0, 0, 1, 1, 1, -1);

	// LS-LV
	actor = CreateActor(280, 1738.9928, 523.2590, 27.8673, 162.6899); // lvhatár1
	ApplyActorAnimation(actor, "DEALER", "DEALER_IDLE", 4.1, 0, 1, 1, 1, 1);
	
	actor = CreateActor(281, 1742.9811, 535.4220, 27.1187, 341.8788); // lvhatár2
	ApplyActorAnimation(actor, "COP_AMBIENT", "Coplook_loop", 4.0, 0, 1, 1, 1, -1);

	// BLUEBERREY BAL
	actor = CreateActor(280, 617.6804, 345.4742, 19.1328, 210.7755); // blueberryjobboldal1
	ApplyActorAnimation(actor, "DEALER", "DEALER_IDLE", 4.1, 0, 1, 1, 1, 1);
	
	actor = CreateActor(281, 606.3577, 337.4618, 19.1328, 37.0852); // blueberryjobboldal2
	ApplyActorAnimation(actor, "COP_AMBIENT", "Coplook_loop", 4.0, 0, 1, 1, 1, -1);

	// BLUEBERREY JOBB
	actor = CreateActor(280, -192.0200, 248.9111, 12.2813, 159.2881); // blueberrybal1
	ApplyActorAnimation(actor, "DEALER", "DEALER_IDLE", 4.1, 0, 1, 1, 1, 1);
	
	actor = CreateActor(281, -205.2251, 252.7750, 12.2813, 342.1905); // blueberrybal2
	ApplyActorAnimation(actor, "COP_AMBIENT", "Coplook_loop", 4.0, 0, 1, 1, 1, -1);
	
	/* ================================= EGYÉB ================================= */
	
	actor = CreateActor(281, 1544.3260, -1631.8202, 13.3828, 89.5714); // rendõrség
	ApplyActorAnimation(actor, "DEALER", "DEALER_IDLE", 4.1, 0, 1, 1, 1, 1);
	
	actor = CreateActor(101, 1416.0767, -1655.7031, 13.5469, 6.5004); // VH mellett dolafalnak
	ApplyActorAnimation(actor, "MISC", "Plyrlean_loop", 4.0, 0, 1, 1, 1, 0);
	
	//actor = CreateActor(150, 1453.4836, -1727.4287, 1052.0149, 90.0); // VH 1
	//actor = CreateActor(150, 1453.4841, -1725.9017, 1052.0149, 90.0); // VH 2
	
	actor = CreateActor(61, 0.7724, 35.8485, 1199.6012, 2.5165); // pilóta bal
	ApplyActorAnimation(actor, "PED", "SEAT_idle", 4.0, 0, 0, 0, 1, 1);
	
	actor = CreateActor(255, 2.5419, 35.8689, 1199.5938, 359.7199); // pilóta jobb
	ApplyActorAnimation(actor, "PED", "SEAT_idle", 4.0, 0, 0, 0, 1, 1);
	/* ================================= ILLEGÁL ================================= */
	
	IllegalDrogActor = CreateActor(29, 1483.6857, -1720.2590, 7.2990, 202.8835);
	
	IllegalFegyverActor = CreateActor(294, 2123.1387, -2275.5354, 20.6719, 315.0282);
	ApplyActorAnimation(IllegalFegyverActor, "PED", "SEAT_idle", 4.0, 0, 0, 0, 1, 1);
	/* ================================= VÉGE ================================= */

	printf("Actorok betöltve! Betöltött actor: %d db.", GetOnlineActors());
	return 1;
}