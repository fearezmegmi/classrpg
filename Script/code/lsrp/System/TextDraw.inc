stock CreatePTD(i)
{
	new playerid = i;
	
	if(TextDrawLoaded[playerid]) return Msg(playerid, "Neked már be lettek töltve a TextDrawok!");
	
	pHUD[i][0] = TextDrawCreate(520.000000, 135.000000, "");
	TextDrawBackgroundColor(pHUD[i][0], 0x000000ff);
	TextDrawFont(pHUD[i][0], 3);
	TextDrawLetterSize(pHUD[i][0], 0.40, 1.0);
	TextDrawColor(pHUD[i][0], 0xffffffff);
	TextDrawSetShadow(pHUD[i][0], 1);
	
	pHUD[i][1] = TextDrawCreate(520.000000, 144.000000, "");
	TextDrawBackgroundColor(pHUD[i][1], 0x000000ff);
	TextDrawFont(pHUD[i][1], 3);
	TextDrawLetterSize(pHUD[i][1], 0.40, 1.0);
	TextDrawColor(pHUD[i][1], 0xffffffff);
	TextDrawSetShadow(pHUD[i][1], 1);
	
	pHUD[i][2] = TextDrawCreate( 520.000000, 103.000000, "~b~Rádió Infó");
	TextDrawBackgroundColor( pHUD[i][2], 0x000000ff);
	TextDrawFont( pHUD[i][2], 3);
	TextDrawLetterSize( pHUD[i][2], 0.40, 1.0);
	TextDrawColor( pHUD[i][2], 0xffffffff);
	TextDrawSetShadow( pHUD[i][2], 1);

	pHUD[i][3] = TextDrawCreate( 520.000000, 112.000000, "~b~Csat: ~h~~g~0");
	TextDrawBackgroundColor(pHUD[i][3], 0x000000ff);
	TextDrawFont(pHUD[i][3], 3);
	TextDrawLetterSize(pHUD[i][3], 0.40, 1.0);
	TextDrawColor(pHUD[i][3], 0xffffffff);
	TextDrawSetShadow(pHUD[i][3], 1);
	
	pHUD[i][4] = TextDrawCreate( 520.000000, 121.000000, "~b~Hely: ~h~~g~1");
	TextDrawBackgroundColor(pHUD[i][4], 0x000000ff);
	TextDrawFont(pHUD[i][4], 3);
	TextDrawLetterSize(pHUD[i][4], 0.40, 1.0);
	TextDrawColor(pHUD[i][4], 0xffffffff);
	TextDrawSetShadow(pHUD[i][4], 1);
	
	/* =============================================================================== */
	
	AdminSzoliTextDraw[playerid] = TextDrawCreate(300.000000, 438.000000, "");
	TextDrawAlignment(AdminSzoliTextDraw[playerid], 2);
	TextDrawBackgroundColor(AdminSzoliTextDraw[playerid], 255);
	TextDrawFont(AdminSzoliTextDraw[playerid], 1);
	TextDrawLetterSize(AdminSzoliTextDraw[playerid], 0.300000, 1.000000);
	TextDrawColor(AdminSzoliTextDraw[playerid], -1);
	TextDrawSetOutline(AdminSzoliTextDraw[playerid], 0);
	TextDrawSetProportional(AdminSzoliTextDraw[playerid], 1);
	TextDrawSetShadow(AdminSzoliTextDraw[playerid], 1);
	
	/* =============================================================================== */
	
	JobbalsoTD[playerid] = TextDrawCreate(452.000000, 437.000000, "Web: www.ls-rp.hu    TS: ip.ls-rp.hu");
	TextDrawBackgroundColor(JobbalsoTD[playerid], 255);
	TextDrawFont(JobbalsoTD[playerid], 1);
	TextDrawLetterSize(JobbalsoTD[playerid], 0.310000, 1.000000);
	TextDrawColor(JobbalsoTD[playerid], -1);
	TextDrawSetOutline(JobbalsoTD[playerid], 0);
	TextDrawSetProportional(JobbalsoTD[playerid], 1);
	TextDrawSetShadow(JobbalsoTD[playerid], 1);
	
	TextDrawLoaded[playerid] = true;
	return 1;
}
/* ##################################################################################################################### */
#define MAX_SZEMELYIDRAW (18+1)
new Text:SzemelyiDraw[MAX_PLAYERS][MAX_SZEMELYIDRAW];

stock ShowSzemelyi(playerid, kinekmutat, bool:show)
{
	if(show)
	{
		SzemelyiDraw[kinekmutat][0] = TextDrawCreate(436.666687, 146.993331, "usebox");
		TextDrawLetterSize(SzemelyiDraw[kinekmutat][0], 0.000000, 14.521853);
		TextDrawTextSize(SzemelyiDraw[kinekmutat][0], 199.523818, 0.000000);
		TextDrawAlignment(SzemelyiDraw[kinekmutat][0], 1);
		TextDrawColor(SzemelyiDraw[kinekmutat][0], 0);
		TextDrawUseBox(SzemelyiDraw[kinekmutat][0], true);
		TextDrawBoxColor(SzemelyiDraw[kinekmutat][0], 102);
		TextDrawSetShadow(SzemelyiDraw[kinekmutat][0], 0);
		TextDrawSetOutline(SzemelyiDraw[kinekmutat][0], 0);
		TextDrawFont(SzemelyiDraw[kinekmutat][0], 0);

		SzemelyiDraw[kinekmutat][1] = TextDrawCreate(436.285705, 146.993331, "usebox");
		TextDrawLetterSize(SzemelyiDraw[kinekmutat][1], 0.000000, -3.161111);
		TextDrawTextSize(SzemelyiDraw[kinekmutat][1], 199.523818, 0.000000);
		TextDrawAlignment(SzemelyiDraw[kinekmutat][1], 1);
		TextDrawColor(SzemelyiDraw[kinekmutat][1], 0);
		TextDrawUseBox(SzemelyiDraw[kinekmutat][1], true);
		TextDrawBoxColor(SzemelyiDraw[kinekmutat][1], -1378294017);
		TextDrawSetShadow(SzemelyiDraw[kinekmutat][1], 0);
		TextDrawSetOutline(SzemelyiDraw[kinekmutat][1], 0);
		TextDrawFont(SzemelyiDraw[kinekmutat][1], 0);

		SzemelyiDraw[kinekmutat][2] = TextDrawCreate(263.618957, 125.439987, "Személyi Igazolvány");
		TextDrawLetterSize(SzemelyiDraw[kinekmutat][2], 0.325809, 1.540266);
		TextDrawAlignment(SzemelyiDraw[kinekmutat][2], 1);
		TextDrawColor(SzemelyiDraw[kinekmutat][2], 255);
		TextDrawSetShadow(SzemelyiDraw[kinekmutat][2], 0);
		TextDrawSetOutline(SzemelyiDraw[kinekmutat][2], 0);
		TextDrawBackgroundColor(SzemelyiDraw[kinekmutat][2], 51);
		TextDrawFont(SzemelyiDraw[kinekmutat][2], 1);
		TextDrawSetProportional(SzemelyiDraw[kinekmutat][2], 1);

		SzemelyiDraw[kinekmutat][3] = TextDrawCreate(301.333496, 165.546630, "Azonosító:");
		TextDrawLetterSize(SzemelyiDraw[kinekmutat][3], 0.217618, 1.386666);
		TextDrawAlignment(SzemelyiDraw[kinekmutat][3], 1);
		TextDrawColor(SzemelyiDraw[kinekmutat][3], -1);
		TextDrawSetShadow(SzemelyiDraw[kinekmutat][3], 0);
		TextDrawSetOutline(SzemelyiDraw[kinekmutat][3], 1);
		TextDrawBackgroundColor(SzemelyiDraw[kinekmutat][3], 51);
		TextDrawFont(SzemelyiDraw[kinekmutat][3], 2);
		TextDrawSetProportional(SzemelyiDraw[kinekmutat][3], 1);

		SzemelyiDraw[kinekmutat][4] = TextDrawCreate(302.476196, 145.066680, "Név:");
		TextDrawLetterSize(SzemelyiDraw[kinekmutat][4], 0.301428, 1.279999);
		TextDrawAlignment(SzemelyiDraw[kinekmutat][4], 1);
		TextDrawColor(SzemelyiDraw[kinekmutat][4], -1);
		TextDrawSetShadow(SzemelyiDraw[kinekmutat][4], 0);
		TextDrawSetOutline(SzemelyiDraw[kinekmutat][4], 1);
		TextDrawBackgroundColor(SzemelyiDraw[kinekmutat][4], 51);
		TextDrawFont(SzemelyiDraw[kinekmutat][4], 2);
		TextDrawSetProportional(SzemelyiDraw[kinekmutat][4], 1);

		SzemelyiDraw[kinekmutat][5] = TextDrawCreate(301.714202, 214.613311, "Születési hely:");
		TextDrawLetterSize(SzemelyiDraw[kinekmutat][5], 0.189047, 1.365333);
		TextDrawAlignment(SzemelyiDraw[kinekmutat][5], 1);
		TextDrawColor(SzemelyiDraw[kinekmutat][5], -1);
		TextDrawSetShadow(SzemelyiDraw[kinekmutat][5], 0);
		TextDrawSetOutline(SzemelyiDraw[kinekmutat][5], 1);
		TextDrawBackgroundColor(SzemelyiDraw[kinekmutat][5], 51);
		TextDrawFont(SzemelyiDraw[kinekmutat][5], 2);
		TextDrawSetProportional(SzemelyiDraw[kinekmutat][5], 1);

		SzemelyiDraw[kinekmutat][6] = TextDrawCreate(301.333374, 189.866699, "Neme:");
		TextDrawLetterSize(SzemelyiDraw[kinekmutat][6], 0.328095, 1.279999);
		TextDrawAlignment(SzemelyiDraw[kinekmutat][6], 1);
		TextDrawColor(SzemelyiDraw[kinekmutat][6], -1);
		TextDrawSetShadow(SzemelyiDraw[kinekmutat][6], 0);
		TextDrawSetOutline(SzemelyiDraw[kinekmutat][6], 1);
		TextDrawBackgroundColor(SzemelyiDraw[kinekmutat][6], 51);
		TextDrawFont(SzemelyiDraw[kinekmutat][6], 2);
		TextDrawSetProportional(SzemelyiDraw[kinekmutat][6], 1);

		SzemelyiDraw[kinekmutat][7] = TextDrawCreate(302.095214, 238.079986, "Születési idõ");
		TextDrawLetterSize(SzemelyiDraw[kinekmutat][7], 0.192857, 1.386666);
		TextDrawAlignment(SzemelyiDraw[kinekmutat][7], 1);
		TextDrawColor(SzemelyiDraw[kinekmutat][7], -1);
		TextDrawSetShadow(SzemelyiDraw[kinekmutat][7], 0);
		TextDrawSetOutline(SzemelyiDraw[kinekmutat][7], 1);
		TextDrawBackgroundColor(SzemelyiDraw[kinekmutat][7], 51);
		TextDrawFont(SzemelyiDraw[kinekmutat][7], 2);
		TextDrawSetProportional(SzemelyiDraw[kinekmutat][7], 1);

		SzemelyiDraw[kinekmutat][8] = TextDrawCreate(299.142852, 147.419998, "usebox");
		TextDrawLetterSize(SzemelyiDraw[kinekmutat][8], 0.000000, 14.332221);
		TextDrawTextSize(SzemelyiDraw[kinekmutat][8], 295.142852, 0.000000);
		TextDrawAlignment(SzemelyiDraw[kinekmutat][8], 1);
		TextDrawColor(SzemelyiDraw[kinekmutat][8], -1);
		TextDrawUseBox(SzemelyiDraw[kinekmutat][8], true);
		TextDrawBoxColor(SzemelyiDraw[kinekmutat][8], -1);
		TextDrawSetShadow(SzemelyiDraw[kinekmutat][8], 0);
		TextDrawSetOutline(SzemelyiDraw[kinekmutat][8], 0);
		TextDrawFont(SzemelyiDraw[kinekmutat][8], 0);

		SzemelyiDraw[kinekmutat][9] = TextDrawCreate(303.238067, 157.440048, PlayerName(playerid));
		TextDrawLetterSize(SzemelyiDraw[kinekmutat][9], 0.258000, 1.066666);
		TextDrawAlignment(SzemelyiDraw[kinekmutat][9], 1);
		TextDrawColor(SzemelyiDraw[kinekmutat][9], -1378294017);
		TextDrawSetShadow(SzemelyiDraw[kinekmutat][9], 0);
		TextDrawSetOutline(SzemelyiDraw[kinekmutat][9], 1);
		TextDrawBackgroundColor(SzemelyiDraw[kinekmutat][9], 51);
		TextDrawFont(SzemelyiDraw[kinekmutat][9], 3);
		TextDrawSetProportional(SzemelyiDraw[kinekmutat][9], 1);

		SzemelyiDraw[kinekmutat][10] = TextDrawCreate(303.238098, 179.200042, "232562LA");
		TextDrawLetterSize(SzemelyiDraw[kinekmutat][10], 0.322761, 1.224533);
		TextDrawAlignment(SzemelyiDraw[kinekmutat][10], 1);
		TextDrawColor(SzemelyiDraw[kinekmutat][10], -1378294017);
		TextDrawSetShadow(SzemelyiDraw[kinekmutat][10], 0);
		TextDrawSetOutline(SzemelyiDraw[kinekmutat][10], 1);
		TextDrawBackgroundColor(SzemelyiDraw[kinekmutat][10], 51);
		TextDrawFont(SzemelyiDraw[kinekmutat][10], 3);
		TextDrawSetProportional(SzemelyiDraw[kinekmutat][10], 1);

		new nem[10];
		if(PlayerInfo[playerid][pSex] == 1) { nem = "Férfi"; }
		else if(PlayerInfo[playerid][pSex] == 2) { nem = "No"; }
		SzemelyiDraw[kinekmutat][11] = TextDrawCreate(302.857116, 201.813339, nem);
		TextDrawLetterSize(SzemelyiDraw[kinekmutat][11], 0.364285, 1.117866);
		TextDrawAlignment(SzemelyiDraw[kinekmutat][11], 1);
		TextDrawColor(SzemelyiDraw[kinekmutat][11], -1378294017);
		TextDrawSetShadow(SzemelyiDraw[kinekmutat][11], 0);
		TextDrawSetOutline(SzemelyiDraw[kinekmutat][11], 1);
		TextDrawBackgroundColor(SzemelyiDraw[kinekmutat][11], 51);
		TextDrawFont(SzemelyiDraw[kinekmutat][11], 3);
		TextDrawSetProportional(SzemelyiDraw[kinekmutat][11], 1);

		SzemelyiDraw[kinekmutat][12] = TextDrawCreate(301.714263, 227.413330, "Los Santos (USA)");
		TextDrawLetterSize(SzemelyiDraw[kinekmutat][12], 0.280476, 1.130666);
		TextDrawAlignment(SzemelyiDraw[kinekmutat][12], 1);
		TextDrawColor(SzemelyiDraw[kinekmutat][12], -1378294017);
		TextDrawSetShadow(SzemelyiDraw[kinekmutat][12], 0);
		TextDrawSetOutline(SzemelyiDraw[kinekmutat][12], 1);
		TextDrawBackgroundColor(SzemelyiDraw[kinekmutat][12], 51);
		TextDrawFont(SzemelyiDraw[kinekmutat][12], 3);
		TextDrawSetProportional(SzemelyiDraw[kinekmutat][12], 1);

		new year; getdate(year);
		new age2 = year-PlayerInfo[playerid][pAge], date[48];
		Format(date, "%d.05.18", age2);
		SzemelyiDraw[kinekmutat][13] = TextDrawCreate(302.476165, 250.026672, date);
		TextDrawLetterSize(SzemelyiDraw[kinekmutat][13], 0.255714, 1.109333);
		TextDrawAlignment(SzemelyiDraw[kinekmutat][13], 1);
		TextDrawColor(SzemelyiDraw[kinekmutat][13], -1378294017);
		TextDrawSetShadow(SzemelyiDraw[kinekmutat][13], 0);
		TextDrawSetOutline(SzemelyiDraw[kinekmutat][13], 1);
		TextDrawBackgroundColor(SzemelyiDraw[kinekmutat][13], 51);
		TextDrawFont(SzemelyiDraw[kinekmutat][13], 3);
		TextDrawSetProportional(SzemelyiDraw[kinekmutat][13], 1);

		SzemelyiDraw[kinekmutat][14] = TextDrawCreate(207.619049, 205.653366, "Állampolgárság:");
		TextDrawLetterSize(SzemelyiDraw[kinekmutat][14], 0.204285, 1.066666);
		TextDrawAlignment(SzemelyiDraw[kinekmutat][14], 1);
		TextDrawColor(SzemelyiDraw[kinekmutat][14], -1);
		TextDrawSetShadow(SzemelyiDraw[kinekmutat][14], 0);
		TextDrawSetOutline(SzemelyiDraw[kinekmutat][14], 1);
		TextDrawBackgroundColor(SzemelyiDraw[kinekmutat][14], 51);
		TextDrawFont(SzemelyiDraw[kinekmutat][14], 2);
		TextDrawSetProportional(SzemelyiDraw[kinekmutat][14], 1);

		SzemelyiDraw[kinekmutat][15] = TextDrawCreate(233.142852, 214.613372, "USA");
		TextDrawLetterSize(SzemelyiDraw[kinekmutat][15], 0.449999, 1.600000);
		TextDrawAlignment(SzemelyiDraw[kinekmutat][15], 1);
		TextDrawColor(SzemelyiDraw[kinekmutat][15], -1378294017);
		TextDrawSetShadow(SzemelyiDraw[kinekmutat][15], 0);
		TextDrawSetOutline(SzemelyiDraw[kinekmutat][15], 1);
		TextDrawBackgroundColor(SzemelyiDraw[kinekmutat][15], 51);
		TextDrawFont(SzemelyiDraw[kinekmutat][15], 3);
		TextDrawSetProportional(SzemelyiDraw[kinekmutat][15], 1);

		SzemelyiDraw[kinekmutat][16] = TextDrawCreate(204.190505, 236.373352, "Érvényesség ideje:");
		TextDrawLetterSize(SzemelyiDraw[kinekmutat][16], 0.189047, 1.215999);
		TextDrawAlignment(SzemelyiDraw[kinekmutat][16], 1);
		TextDrawColor(SzemelyiDraw[kinekmutat][16], -1);
		TextDrawSetShadow(SzemelyiDraw[kinekmutat][16], 0);
		TextDrawSetOutline(SzemelyiDraw[kinekmutat][16], 1);
		TextDrawBackgroundColor(SzemelyiDraw[kinekmutat][16], 51);
		TextDrawFont(SzemelyiDraw[kinekmutat][16], 2);
		TextDrawSetProportional(SzemelyiDraw[kinekmutat][16], 1);

		new szemelyi_ido[24];
		if(PlayerInfo[playerid][pSzemelyi] < 1)
			szemelyi_ido = "~r~Lejárt";
		else
			Format(szemelyi_ido, "%d nap (%d óra)", (PlayerInfo[playerid][pSzemelyi]* 10), PlayerInfo[playerid][pSzemelyi]);
		
		SzemelyiDraw[kinekmutat][17] = TextDrawCreate(206.476181, 247.040008, szemelyi_ido);
		TextDrawLetterSize(SzemelyiDraw[kinekmutat][17], 0.286190, 1.279999);
		TextDrawAlignment(SzemelyiDraw[kinekmutat][17], 1);
		TextDrawColor(SzemelyiDraw[kinekmutat][17], -1378294017);
		TextDrawSetShadow(SzemelyiDraw[kinekmutat][17], 0);
		TextDrawSetOutline(SzemelyiDraw[kinekmutat][17], 1);
		TextDrawBackgroundColor(SzemelyiDraw[kinekmutat][17], 51);
		TextDrawFont(SzemelyiDraw[kinekmutat][17], 3);
		TextDrawSetProportional(SzemelyiDraw[kinekmutat][17], 1);

		SzemelyiDraw[kinekmutat][18] = TextDrawCreate(222.000000, 145.000000, "New Textdraw");
		TextDrawBackgroundColor(SzemelyiDraw[kinekmutat][18], -1378294017);
		TextDrawFont(SzemelyiDraw[kinekmutat][18], TEXT_DRAW_FONT_MODEL_PREVIEW);
		TextDrawLetterSize(SzemelyiDraw[kinekmutat][18], 0.500000, 1.000000);
		TextDrawColor(SzemelyiDraw[kinekmutat][18], -1);
		TextDrawSetOutline(SzemelyiDraw[kinekmutat][18], 0);
		TextDrawSetProportional(SzemelyiDraw[kinekmutat][18], 1);
		TextDrawSetShadow(SzemelyiDraw[kinekmutat][18], 1);
		//TextDrawUseBox(SzemelyiDraw[kinekmutat][18], 1);
		//TextDrawBoxColor(SzemelyiDraw[kinekmutat][18], 16777215);
		TextDrawTextSize(SzemelyiDraw[kinekmutat][18], 56.000000, 55.000000);
		TextDrawSetPreviewModel(SzemelyiDraw[kinekmutat][18], PlayerInfo[playerid][pModel]);
		TextDrawSetPreviewRot(SzemelyiDraw[kinekmutat][18],  0.000000, 0.000000, 1.000000, 1.000000);
		
		for(new i=0; i < MAX_SZEMELYIDRAW; i++) 
		{ 
			TextDrawShowForPlayer(kinekmutat, SzemelyiDraw[kinekmutat][i]);
		}
	}
	else
	{
		for(new i=0; i < MAX_SZEMELYIDRAW; i++) 
		{ 
			TextDrawHideForPlayer(kinekmutat, SzemelyiDraw[kinekmutat][i]);
		}
	}
	return 1;
}

#define MAX_JOGSIDRAW (14+1)
new Text:JogsiDraw[MAX_PLAYERS][MAX_JOGSIDRAW];

stock ShowJogsi(playerid, kinekmutat, bool:show)
{
	if(show)
	{
		JogsiDraw[kinekmutat][0] = TextDrawCreate(424.095214, 164.059982, "usebox");
		TextDrawLetterSize(JogsiDraw[kinekmutat][0], 0.000000, 11.855184);
		TextDrawTextSize(JogsiDraw[kinekmutat][0], 223.523757, 0.000000);
		TextDrawAlignment(JogsiDraw[kinekmutat][0], 1);
		TextDrawColor(JogsiDraw[kinekmutat][0], 0);
		TextDrawUseBox(JogsiDraw[kinekmutat][0], true);
		TextDrawBoxColor(JogsiDraw[kinekmutat][0], 102);
		TextDrawSetShadow(JogsiDraw[kinekmutat][0], 0);
		TextDrawSetOutline(JogsiDraw[kinekmutat][0], 0);
		TextDrawFont(JogsiDraw[kinekmutat][0], 0);

		JogsiDraw[kinekmutat][1] = TextDrawCreate(424.095214, 163.633331, "usebox");
		TextDrawLetterSize(JogsiDraw[kinekmutat][1], 0.000000, -2.592221);
		TextDrawTextSize(JogsiDraw[kinekmutat][1], 223.142837, 0.000000);
		TextDrawAlignment(JogsiDraw[kinekmutat][1], 1);
		TextDrawColor(JogsiDraw[kinekmutat][1], 0);
		TextDrawUseBox(JogsiDraw[kinekmutat][1], true);
		TextDrawBoxColor(JogsiDraw[kinekmutat][1], 102);
		TextDrawSetShadow(JogsiDraw[kinekmutat][1], 0);
		TextDrawSetOutline(JogsiDraw[kinekmutat][1], 0);
		TextDrawFont(JogsiDraw[kinekmutat][1], 0);

		JogsiDraw[kinekmutat][2] = TextDrawCreate(422.952362, 163.633331, "usebox");
		TextDrawLetterSize(JogsiDraw[kinekmutat][2], 0.000000, -0.316666);
		TextDrawTextSize(JogsiDraw[kinekmutat][2], 223.142868, 0.000000);
		TextDrawAlignment(JogsiDraw[kinekmutat][2], 1);
		TextDrawColor(JogsiDraw[kinekmutat][2], 0);
		TextDrawUseBox(JogsiDraw[kinekmutat][2], true);
		TextDrawBoxColor(JogsiDraw[kinekmutat][2], -1378294017);
		TextDrawSetShadow(JogsiDraw[kinekmutat][2], 0);
		TextDrawSetOutline(JogsiDraw[kinekmutat][2], 0);
		TextDrawFont(JogsiDraw[kinekmutat][2], 0);

		JogsiDraw[kinekmutat][3] = TextDrawCreate(231.238128, 145.493362, "Vezetõi engedély");
		TextDrawLetterSize(JogsiDraw[kinekmutat][3], 0.449999, 1.600000);
		TextDrawAlignment(JogsiDraw[kinekmutat][3], 1);
		TextDrawColor(JogsiDraw[kinekmutat][3], -1);
		TextDrawSetShadow(JogsiDraw[kinekmutat][3], 0);
		TextDrawSetOutline(JogsiDraw[kinekmutat][3], 1);
		TextDrawBackgroundColor(JogsiDraw[kinekmutat][3], 51);
		TextDrawFont(JogsiDraw[kinekmutat][3], 2);
		TextDrawSetProportional(JogsiDraw[kinekmutat][3], 1);

		JogsiDraw[kinekmutat][4] = TextDrawCreate(231.238021, 177.493347, PlayerName(playerid));
		TextDrawLetterSize(JogsiDraw[kinekmutat][4], 0.321238, 1.053866);
		TextDrawAlignment(JogsiDraw[kinekmutat][4], 1);
		TextDrawColor(JogsiDraw[kinekmutat][4], -5963521);
		TextDrawSetShadow(JogsiDraw[kinekmutat][4], 0);
		TextDrawSetOutline(JogsiDraw[kinekmutat][4], 1);
		TextDrawBackgroundColor(JogsiDraw[kinekmutat][4], 51);
		TextDrawFont(JogsiDraw[kinekmutat][4], 3);
		TextDrawSetProportional(JogsiDraw[kinekmutat][4], 1);

		JogsiDraw[kinekmutat][5] = TextDrawCreate(230.476135, 167.253341, "Név:");
		TextDrawLetterSize(JogsiDraw[kinekmutat][5], 0.192857, 1.023999);
		TextDrawAlignment(JogsiDraw[kinekmutat][5], 1);
		TextDrawColor(JogsiDraw[kinekmutat][5], -1);
		TextDrawSetShadow(JogsiDraw[kinekmutat][5], 0);
		TextDrawSetOutline(JogsiDraw[kinekmutat][5], 1);
		TextDrawBackgroundColor(JogsiDraw[kinekmutat][5], 51);
		TextDrawFont(JogsiDraw[kinekmutat][5], 2);
		TextDrawSetProportional(JogsiDraw[kinekmutat][5], 1);

		JogsiDraw[kinekmutat][6] = TextDrawCreate(229.714218, 191.573379, "Születési idõ:");
		TextDrawLetterSize(JogsiDraw[kinekmutat][6], 0.168095, 1.066666);
		TextDrawAlignment(JogsiDraw[kinekmutat][6], 1);
		TextDrawColor(JogsiDraw[kinekmutat][6], -1);
		TextDrawSetShadow(JogsiDraw[kinekmutat][6], 0);
		TextDrawSetOutline(JogsiDraw[kinekmutat][6], 1);
		TextDrawBackgroundColor(JogsiDraw[kinekmutat][6], 51);
		TextDrawFont(JogsiDraw[kinekmutat][6], 2);
		TextDrawSetProportional(JogsiDraw[kinekmutat][6], 1);

		JogsiDraw[kinekmutat][7] = TextDrawCreate(229.333419, 217.600006, "Születési hely:");
		TextDrawLetterSize(JogsiDraw[kinekmutat][7], 0.150952, 1.130666);
		TextDrawAlignment(JogsiDraw[kinekmutat][7], 1);
		TextDrawColor(JogsiDraw[kinekmutat][7], -1);
		TextDrawSetShadow(JogsiDraw[kinekmutat][7], 0);
		TextDrawSetOutline(JogsiDraw[kinekmutat][7], 1);
		TextDrawBackgroundColor(JogsiDraw[kinekmutat][7], 51);
		TextDrawFont(JogsiDraw[kinekmutat][7], 2);
		TextDrawSetProportional(JogsiDraw[kinekmutat][7], 1);

		JogsiDraw[kinekmutat][8] = TextDrawCreate(227.809478, 243.626663, "Engedély típusa:");
		TextDrawLetterSize(JogsiDraw[kinekmutat][8], 0.190952, 0.938666);
		TextDrawAlignment(JogsiDraw[kinekmutat][8], 1);
		TextDrawColor(JogsiDraw[kinekmutat][8], -1);
		TextDrawSetShadow(JogsiDraw[kinekmutat][8], 0);
		TextDrawSetOutline(JogsiDraw[kinekmutat][8], 1);
		TextDrawBackgroundColor(JogsiDraw[kinekmutat][8], 51);
		TextDrawFont(JogsiDraw[kinekmutat][8], 2);
		TextDrawSetProportional(JogsiDraw[kinekmutat][8], 1);

		JogsiDraw[kinekmutat][9] = TextDrawCreate(281.143096, 164.693435, "Érvényes:");
		TextDrawLetterSize(JogsiDraw[kinekmutat][9], 0.175714, 0.959999);
		TextDrawAlignment(JogsiDraw[kinekmutat][9], 1);
		TextDrawColor(JogsiDraw[kinekmutat][9], -1);
		TextDrawSetShadow(JogsiDraw[kinekmutat][9], 0);
		TextDrawSetOutline(JogsiDraw[kinekmutat][9], 1);
		TextDrawBackgroundColor(JogsiDraw[kinekmutat][9], 51);
		TextDrawFont(JogsiDraw[kinekmutat][9], 2);
		TextDrawSetProportional(JogsiDraw[kinekmutat][9], 1);

		JogsiDraw[kinekmutat][10] = TextDrawCreate(229.333435, 203.093353, "1980.06.01");
		TextDrawLetterSize(JogsiDraw[kinekmutat][10], 0.338761, 1.177600);
		TextDrawAlignment(JogsiDraw[kinekmutat][10], 1);
		TextDrawColor(JogsiDraw[kinekmutat][10], -5963521);
		TextDrawSetShadow(JogsiDraw[kinekmutat][10], 0);
		TextDrawSetOutline(JogsiDraw[kinekmutat][10], 1);
		TextDrawBackgroundColor(JogsiDraw[kinekmutat][10], 51);
		TextDrawFont(JogsiDraw[kinekmutat][10], 3);
		TextDrawSetProportional(JogsiDraw[kinekmutat][10], 1);

		JogsiDraw[kinekmutat][11] = TextDrawCreate(227.809585, 229.120025, "Washington USA");
		TextDrawLetterSize(JogsiDraw[kinekmutat][11], 0.285428, 1.139199);
		TextDrawAlignment(JogsiDraw[kinekmutat][11], 1);
		TextDrawColor(JogsiDraw[kinekmutat][11], -5963521);
		TextDrawSetShadow(JogsiDraw[kinekmutat][11], 0);
		TextDrawSetOutline(JogsiDraw[kinekmutat][11], 1);
		TextDrawBackgroundColor(JogsiDraw[kinekmutat][11], 51);
		TextDrawFont(JogsiDraw[kinekmutat][11], 3);
		TextDrawSetProportional(JogsiDraw[kinekmutat][11], 1);

		JogsiDraw[kinekmutat][12] = TextDrawCreate(228.952362, 254.720001, "B kategória");
		TextDrawLetterSize(JogsiDraw[kinekmutat][12], 0.302952, 1.117866);
		TextDrawAlignment(JogsiDraw[kinekmutat][12], 1);
		TextDrawColor(JogsiDraw[kinekmutat][12], -5963521);
		TextDrawSetShadow(JogsiDraw[kinekmutat][12], 0);
		TextDrawSetOutline(JogsiDraw[kinekmutat][12], 1);
		TextDrawBackgroundColor(JogsiDraw[kinekmutat][12], 51);
		TextDrawFont(JogsiDraw[kinekmutat][12], 3);
		TextDrawSetProportional(JogsiDraw[kinekmutat][12], 1);

		JogsiDraw[kinekmutat][13] = TextDrawCreate(326.856964, 164.693344, "2023.06.01 ((még 335 óra))");
		TextDrawLetterSize(JogsiDraw[kinekmutat][13], 0.190952, 1.023999);
		TextDrawAlignment(JogsiDraw[kinekmutat][13], 1);
		TextDrawColor(JogsiDraw[kinekmutat][13], -5963521);
		TextDrawSetShadow(JogsiDraw[kinekmutat][13], 0);
		TextDrawSetOutline(JogsiDraw[kinekmutat][13], 1);
		TextDrawBackgroundColor(JogsiDraw[kinekmutat][13], 51);
		TextDrawFont(JogsiDraw[kinekmutat][13], 3);
		TextDrawSetProportional(JogsiDraw[kinekmutat][13], 1);

		JogsiDraw[kinekmutat][14] = TextDrawCreate(339.000000, 183.000000, "New Textdraw");
		TextDrawBackgroundColor(JogsiDraw[kinekmutat][14], 51);
		TextDrawFont(JogsiDraw[kinekmutat][14], TEXT_DRAW_FONT_MODEL_PREVIEW);
		TextDrawLetterSize(JogsiDraw[kinekmutat][14], 0.500000, 1.000000);
		TextDrawColor(JogsiDraw[kinekmutat][14], -1);
		TextDrawSetOutline(JogsiDraw[kinekmutat][14], 0);
		TextDrawSetProportional(JogsiDraw[kinekmutat][14], 1);
		TextDrawSetShadow(JogsiDraw[kinekmutat][14], 1);
		TextDrawUseBox(JogsiDraw[kinekmutat][14], 1);
		TextDrawBoxColor(JogsiDraw[kinekmutat][14], 255);
		TextDrawTextSize(JogsiDraw[kinekmutat][14], 59.000000, 60.000000);
		TextDrawSetPreviewModel(JogsiDraw[kinekmutat][14], PlayerInfo[playerid][pModel]);
		TextDrawSetPreviewRot(JogsiDraw[kinekmutat][14],  0.000000, 0.000000, 1.000000, 1.000000);

		for(new i=0; i < MAX_JOGSIDRAW; i++) 
		{ 
			TextDrawShowForPlayer(kinekmutat, JogsiDraw[kinekmutat][i]);
		}
	}
	else
	{
		for(new i=0; i < MAX_JOGSIDRAW; i++) 
		{ 
			TextDrawHideForPlayer(kinekmutat, JogsiDraw[kinekmutat][i]);
		}
	}
	return 1;
}

/* ##################################################################################################################### */

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
    return 1;
}

/* ##################################################################################################################### */
stock DeleteAllTextDraw(playerid)
{
	if(!TextDrawLoaded[playerid]) return 1;
	
	new i = 0;
	
	for(i = 0; i < MAXTD_PHUD; i++) TextDrawDestroy(pHUD[playerid][i]);
	
	TextDrawDestroy(AdminSzoliTextDraw[playerid]);
	TextDrawDestroy(JobbalsoTD[playerid]);
	
	TextDrawLoaded[playerid] = false;
	return 1;
}