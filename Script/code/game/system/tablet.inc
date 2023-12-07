/*
************************
************************
** ADRI1 FILTERSCRIPT **
** TEXTDRAWS CREATEDS **
** WITH ZAMAROHT TEXT **
** EDITOR. EDITED  BY **
** ADRI1 VERSION SAMP **            TABLET V3.00 CREATED BY ADRI1
** 0.3E. THIS  TABLET **
** IS V3.0 CREATED BY **
** ADRI1 COMMAND  FOR **
** TEST IS:   /TABLET **
** STABLE VERSION.BYE **
************************
************************
*/
//#include <a_samp>
//#include <fixchars>

new PlayerText:TabletWin8[23];
new PlayerText:TabletWin8Start[51];
new PlayerText:TabletWin8UserLog[13];
new PlayerText:TabletWin8Pag[4];
new PlayerText:Escritorio[4];
new PlayerText:TabletPhotos[12];
new PlayerText:TabletTime[2];
new PlayerText:TabletMusicPlayer[13];
new PlayerText:TabletMP4[13];
new PlayerText:TwoBut[2];
new PlayerText:Google;
new PlayerText:MapX;
new Timer_A[MAX_PLAYERS];
new Timer_B[MAX_PLAYERS];
new Timer_C[MAX_PLAYERS];
new Timer_D[MAX_PLAYERS];
//new Timer_E[MAX_PLAYERS];
new Timer_F[MAX_PLAYERS];
new lda[MAX_PLAYERS];
new Text:gMap;
new PlayerText:pLocation;
new PlayerText:Bankszamla;
new PlayerText:BankszamlaPIN;
new PlayerText:Tovabb;
//new PlayerText:ValasztasH[2];
//new PlayerText:ValasztasSz[2];
new PlayerText:Utalas;
new PlayerText:UtalasOsszeg;
new PlayerText:UtalasMehet;

#define COL_LILA 		"{A000FA}"//	   |
#define COL_PIROS 		"{F81414}"//	   |
#define COL_VPIROS		"{FF6347}"//   	   |
#define COL_VKEK 		"{00C0FF}"//	   |
#define COL_VZOLD 		"{6EF83C}"//	   |
#define COL_FEHER 		"{FFFFFF}"//	   |
#define COL_NARANCS 	"{FA9600}"//	   |
#define COL_CITROM 		"{FAE600}"//	   |
#define COL_PINK 		"{F814E6}"//	   |
#define COL_SKEK 		"{1466F8}"//	   |
#define COL_SZURKE 		"{757167}"//	   |
#define COL_VPINK 		"{FF3E98}"//	   |
#define COL_NZOLD 		"{22F710}"//	   |
#define COL_FEKETE		"{000000}"//	   |

new bool:Bankszamlas[MAX_PLAYERS];
new bool:BankszamlasPIN[MAX_PLAYERS];

new UtalasSzamla[MAX_PLAYERS];
new UtalasOsszege[MAX_PLAYERS];

#define DIALOG_BANKSZAMLA		10000
#define DIALOG_BANKSZAMLAPIN	10001
#define DIALOG_UTALASBANKSZAMLA	10002
#define DIALOG_UTALASOSSZEG		10003
#define DIALOG_UTALASMEHET		10004

forward LoaderAnimation(playerid);
public LoaderAnimation(playerid)
{
	if(lda[playerid] == 0) PlayerTextDrawShow(playerid,TabletWin8[13]), lda[playerid] = 1;
	else if(lda[playerid] == 1) PlayerTextDrawShow(playerid,TabletWin8[14]), lda[playerid] = 2;
	else if(lda[playerid] == 2) PlayerTextDrawShow(playerid,TabletWin8[15]), lda[playerid] = 3;
	else if(lda[playerid] == 3) PlayerTextDrawShow(playerid,TabletWin8[16]), lda[playerid] = 4;
	else if(lda[playerid] == 4) PlayerTextDrawShow(playerid,TabletWin8[17]), lda[playerid] = 5;
	else if(lda[playerid] == 5) PlayerTextDrawShow(playerid,TabletWin8[18]), lda[playerid] = 6;
	else if(lda[playerid] == 6) PlayerTextDrawShow(playerid,TabletWin8[19]), lda[playerid] = 7;
	else if(lda[playerid] == 7) PlayerTextDrawShow(playerid,TabletWin8[20]), lda[playerid] = 9;
	else if(lda[playerid] == 9) PlayerTextDrawHide(playerid,TabletWin8[13]), lda[playerid] = 10;
	else if(lda[playerid] == 10) PlayerTextDrawHide(playerid,TabletWin8[14]), lda[playerid] = 11;
	else if(lda[playerid] == 11) PlayerTextDrawHide(playerid,TabletWin8[15]), lda[playerid] = 12;
	else if(lda[playerid] == 12) PlayerTextDrawHide(playerid,TabletWin8[16]), lda[playerid] = 13;
	else if(lda[playerid] == 13) PlayerTextDrawHide(playerid,TabletWin8[17]), lda[playerid] = 14;
	else if(lda[playerid] == 14) PlayerTextDrawHide(playerid,TabletWin8[18]), lda[playerid] = 15;
	else if(lda[playerid] == 15) PlayerTextDrawHide(playerid,TabletWin8[19]), lda[playerid] = 16;
	else if(lda[playerid] == 16) PlayerTextDrawHide(playerid,TabletWin8[20]), lda[playerid] = 0;
	return 1;
}
forward StartWin8(playerid);
public StartWin8(playerid)
{
    lda[playerid] = 0;
	KillTimer(Timer_A[playerid]);
	HideTabletForPlayer(playerid);
	ShowUserLogTablet(playerid);
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid,name,sizeof(name));
	PlayerTextDrawSetString(playerid,TabletWin8UserLog[6],name);
	Timer_B[playerid] = SetTimerEx("LoaderAnimation2",50,1,"i",playerid);
	Timer_F[playerid] = SetTimerEx("Win8GO",5000,0,"i",playerid);
	PlayerTextDrawShow(playerid,TabletWin8Start[0]);
	PlayerTextDrawShow(playerid,TabletWin8Start[1]);
	PlayerTextDrawShow(playerid,TabletWin8Start[2]);
	PlayerTextDrawShow(playerid,TabletWin8Start[3]);
	PlayerTextDrawShow(playerid,TabletWin8Start[4]);
	PlayerTextDrawShow(playerid,TabletWin8Start[5]);
	PlayerTextDrawShow(playerid,TabletWin8Start[6]);
	PlayerTextDrawShow(playerid,TabletWin8Start[7]);
	PlayerTextDrawShow(playerid,TabletWin8Start[8]);
	PlayerTextDrawShow(playerid,TabletWin8Start[9]);
	PlayerTextDrawShow(playerid,TabletWin8Start[10]);
	PlayerTextDrawShow(playerid,TabletWin8Start[21]);
	PlayerTextDrawShow(playerid,TabletWin8Start[22]);
	return 1;
}
forward LoaderAnimation2(playerid);
public LoaderAnimation2(playerid)
{
	if(lda[playerid] == 0) PlayerTextDrawShow(playerid,TabletWin8UserLog[1]), lda[playerid] = 1;
	else if(lda[playerid] == 1) PlayerTextDrawShow(playerid,TabletWin8UserLog[7]), lda[playerid] = 2;
	else if(lda[playerid] == 2) PlayerTextDrawShow(playerid,TabletWin8UserLog[9]), lda[playerid] = 3;
	else if(lda[playerid] == 3) PlayerTextDrawShow(playerid,TabletWin8UserLog[10]), lda[playerid] = 4;
	else if(lda[playerid] == 4) PlayerTextDrawShow(playerid,TabletWin8UserLog[11]), lda[playerid] = 5;
	else if(lda[playerid] == 5) PlayerTextDrawShow(playerid,TabletWin8UserLog[12]), lda[playerid] = 6;
	else if(lda[playerid] == 6) PlayerTextDrawHide(playerid,TabletWin8UserLog[1]), lda[playerid] = 7;
	else if(lda[playerid] == 7) PlayerTextDrawHide(playerid,TabletWin8UserLog[7]), lda[playerid] = 8;
	else if(lda[playerid] == 8) PlayerTextDrawHide(playerid,TabletWin8UserLog[9]), lda[playerid] = 9;
	else if(lda[playerid] == 9) PlayerTextDrawHide(playerid,TabletWin8UserLog[10]), lda[playerid] = 10;
	else if(lda[playerid] == 10) PlayerTextDrawHide(playerid,TabletWin8UserLog[11]), lda[playerid] = 11;
	else if(lda[playerid] == 11) PlayerTextDrawHide(playerid,TabletWin8UserLog[12]), lda[playerid] = 0;
	return 1;
}
forward Win8GO(playerid);
public Win8GO(playerid)
{
	KillTimer(Timer_B[playerid]);
	lda[playerid] = 0;
	HideUserLogTablet(playerid);
	ShowStartMenuTablet(playerid);
	SelectTextDraw(playerid,0x33AA33AA);
	return 1;
}
forward UpdateTime(playerid);
public UpdateTime(playerid)
{
	new Hour, Minute, Second;
	gettime(Hour, Minute, Second);
	new str[64];
	format(str,sizeof(str),"%d:%d",Hour,Minute);
	PlayerTextDrawSetString(playerid,Escritorio[2],str);
	return 1;
}
forward UpdateTime2(playerid);
public UpdateTime2(playerid)
{
	new Hour, Minute, Second;
	gettime(Hour, Minute, Second);
	new Year, Month, Day;
	getdate(Year, Month, Day);
	new str2[64];
	format(str2,sizeof(str2),"%d/%d/%d",Day,Month,Year);
	PlayerTextDrawSetString(playerid,TabletTime[0],str2);
	new str[64];
	format(str,sizeof(str),"%d:%d:%d",Hour,Minute,Second);
	PlayerTextDrawSetString(playerid,TabletTime[1],str);
	return 1;
}
//Tablet ON/OFF
stock ShowTabletForPlayer(playerid)
{
	for(new i = 0; i < 23; i++) PlayerTextDrawShow(playerid,TabletWin8[i]);
	PlayerTextDrawHide(playerid,TabletWin8[13]);
	PlayerTextDrawHide(playerid,TabletWin8[14]);
	PlayerTextDrawHide(playerid,TabletWin8[15]);
	PlayerTextDrawHide(playerid,TabletWin8[16]);
	PlayerTextDrawHide(playerid,TabletWin8[17]);
	PlayerTextDrawHide(playerid,TabletWin8[18]);
	PlayerTextDrawHide(playerid,TabletWin8[19]);
	PlayerTextDrawHide(playerid,TabletWin8[20]);
	return 1;
}
stock HideTabletForPlayer(playerid)
{
	for(new i = 0; i < 23; i++) PlayerTextDrawHide(playerid,TabletWin8[i]);
	return 1;
}

//UserLogin
stock ShowUserLogTablet(playerid)
{
	for(new i = 0; i < 13; i++) PlayerTextDrawShow(playerid,TabletWin8UserLog[i]);
	PlayerTextDrawHide(playerid,TabletWin8UserLog[1]);
	PlayerTextDrawHide(playerid,TabletWin8UserLog[7]);
	PlayerTextDrawHide(playerid,TabletWin8UserLog[9]);
	PlayerTextDrawHide(playerid,TabletWin8UserLog[10]);
    PlayerTextDrawHide(playerid,TabletWin8UserLog[11]);
    PlayerTextDrawHide(playerid,TabletWin8UserLog[12]);
	return 1;
}
stock HideUserLogTablet(playerid)
{
	for(new i = 0; i < 13; i++) PlayerTextDrawHide(playerid,TabletWin8UserLog[i]);
	return 1;
}

//StartMenu
stock ShowStartMenuTablet(playerid)
{
	for(new i = 0; i < 51; i++) PlayerTextDrawShow(playerid,TabletWin8Start[i]);
	return 1;
}
stock HideStartMenuTablet(playerid)
{
	for(new i = 0; i < 51; i++) PlayerTextDrawHide(playerid,TabletWin8Start[i]);
	return 1;
}

//PagForItem
stock ShowPagForItems(playerid)
{
	for(new i = 0; i < 4; i++) PlayerTextDrawShow(playerid,TabletWin8Pag[i]);
	return 1;
}
stock HidePagForItems(playerid)
{
	for(new i = 0; i < 4; i++) PlayerTextDrawHide(playerid,TabletWin8Pag[i]);
	return 1;
}

//Escritorio
stock ShowEscritorioForPlayer(playerid)
{
	for(new i = 0; i < 4; i++) PlayerTextDrawShow(playerid,Escritorio[i]);
	Timer_C[playerid] = SetTimerEx("UpdateTime",1000,1,"i",playerid);
	return 1;
}
stock HideEscritorioForPlayer(playerid)
{
	for(new i = 0; i < 4; i++) PlayerTextDrawHide(playerid,Escritorio[i]);
	KillTimer(Timer_C[playerid]);
	return 1;
}

//Photos
stock ShowPhotosForPlayer(playerid)
{
	for(new i = 0; i < 12; i++) PlayerTextDrawShow(playerid,TabletPhotos[i]);
	return 1;
}
stock HidePhotosForPlayer(playerid)
{
	for(new i = 0; i < 12; i++) PlayerTextDrawHide(playerid,TabletPhotos[i]);
	return 1;
}
//Relog
stock ShowClockForPlayer(playerid)
{
	for(new i = 0; i < 2; i++) PlayerTextDrawShow(playerid,TabletTime[i]);
	Timer_D[playerid] = SetTimerEx("UpdateTime2",1000,1,"i",playerid);
	return 1;
}
stock HideClockForPlayer(playerid)
{
	for(new i = 0; i < 2; i++) PlayerTextDrawHide(playerid,TabletTime[i]);
	KillTimer(Timer_D[playerid]);
	return 1;
}

//TabletMusicPlayer
stock ShowTabletMusicPlayer(playerid)
{
	for(new i = 0; i < 13; i++) PlayerTextDrawShow(playerid,TabletMusicPlayer[i]);
	return 1;
}
stock HideTabletMusicPlayer(playerid)
{
	for(new i = 0; i < 13; i++) PlayerTextDrawHide(playerid,TabletMusicPlayer[i]);
	//StopAudioStreamForPlayer(playerid);
	return 1;
}
stock ShowTabletMP4(playerid)
{
	for(new i = 0; i < 13; i++) PlayerTextDrawShow(playerid,TabletMP4[i]);
	return 1;
}
stock HideTabletMP4(playerid)
{
	for(new i = 0; i < 13; i++) PlayerTextDrawHide(playerid,TabletMP4[i]);
	//StopAudioStreamForPlayer(playerid);
	return 1;
}
//Only for menu no bug
stock ShowPage(playerid, page)
{
    HideStartMenuTablet(playerid);
	PlayerTextDrawShow(playerid,TabletWin8Start[0]);
	PlayerTextDrawShow(playerid,TabletWin8Start[1]);
	PlayerTextDrawShow(playerid,TabletWin8Start[2]);
	PlayerTextDrawShow(playerid,TabletWin8Start[3]);
	PlayerTextDrawShow(playerid,TabletWin8Start[4]);
	PlayerTextDrawShow(playerid,TabletWin8Start[5]);
	PlayerTextDrawShow(playerid,TabletWin8Start[6]);
	PlayerTextDrawShow(playerid,TabletWin8Start[7]);
	PlayerTextDrawShow(playerid,TabletWin8Start[8]);
	PlayerTextDrawShow(playerid,TabletWin8Start[9]);
	PlayerTextDrawShow(playerid,TabletWin8Start[10]);
	PlayerTextDrawShow(playerid,TabletWin8Start[21]);
	PlayerTextDrawShow(playerid,TabletWin8Start[22]);
	if(page == 0)PlayerTextDrawSetString(playerid,TabletWin8Pag[1],"EMAIL");
	else if(page == 1)PlayerTextDrawSetString(playerid,TabletWin8Pag[1],"CONTACTS");
	else if(page == 2)PlayerTextDrawSetString(playerid,TabletWin8Pag[1],"MESSAGES");
	else if(page == 3)return ShowEscritorioForPlayer(playerid);
	else if(page == 4)return PlayerTextDrawSetString(playerid,TabletWin8Pag[1],"CLOCK"),ShowClockForPlayer(playerid),ShowPagForItems(playerid),PlayerTextDrawHide(playerid,TabletWin8Pag[2]);
	else if(page == 5)return PlayerTextDrawSetString(playerid,TabletWin8Pag[1],"PHOTOS"),ShowPhotosForPlayer(playerid),ShowPagForItems(playerid),PlayerTextDrawHide(playerid,TabletWin8Pag[2]);
	else if(page == 6)
	{
		return
			PlayerTextDrawSetString(playerid,TabletWin8Pag[1],"BEJELENTKEZÉS"),
			ShowPagForItems(playerid),
			PlayerTextDrawHide(playerid,TabletWin8Pag[2]),
			PlayerTextDrawShow(playerid, Bankszamla),
			PlayerTextDrawShow(playerid, BankszamlaPIN);
	}
	else if(page == 7)PlayerTextDrawSetString(playerid,TabletWin8Pag[1],"WEATHER");
	else if(page == 8)PlayerTextDrawSetString(playerid,TabletWin8Pag[1],"INTERNET~n~EXPLORER");
	else if(page == 9)
	{
		HidePagForItems(playerid);
//		ShowPagForItems
		HideTabletForPlayer(playerid);
		//HidePhotosForPlayer(playerid);
		//HideClockForPlayer(playerid);
		//HideTabletMusicPlayer(playerid);
		HideStartMenuTablet(playerid);
		//HideUserLogTablet(playerid);
		//HideEscritorioForPlayer(playerid);
		PlayerTextDrawHide(playerid,TwoBut[0]);
		PlayerTextDrawHide(playerid,TwoBut[1]);
		
		new Float:X,
			Float:Y,
			Float:Z;
			
		TextDrawShowForPlayer(playerid, gMap);
		PlayerTextDrawShow(playerid, Google);
		PlayerTextDrawShow(playerid, MapX);
		
		if(!IsPlayerInAnyVehicle(playerid)) GetPlayerPos(playerid, X, Y, Z);
		else GetVehiclePos(GetPlayerVehicleID(playerid), X, Y, Z);

		X = 320.0 + (X * 0.0583);
		Y = (220.0 - (Y * 0.0583)) - 2.5;

		pLocation = CreatePlayerTextDraw(playerid, X, Y, ".");
		PlayerTextDrawBackgroundColor(playerid, pLocation, 255);
		PlayerTextDrawFont(playerid, pLocation, 1);
		PlayerTextDrawLetterSize(playerid, pLocation, 0.500000, 1.000000);
		PlayerTextDrawColor(playerid, pLocation, 0xFF0000FF);
		PlayerTextDrawSetOutline(playerid, pLocation, 1);
		PlayerTextDrawSetProportional(playerid, pLocation, 1);
		PlayerTextDrawShow(playerid, pLocation);
		SelectTextDraw(playerid, 0x33AA33AA);
		return true;
	}
	else if(page == 10)PlayerTextDrawSetString(playerid,TabletWin8Pag[1],"SPORT");
	else if(page == 11)PlayerTextDrawSetString(playerid,TabletWin8Pag[1],"HÍREK");
	else if(page == 12)PlayerTextDrawSetString(playerid,TabletWin8Pag[1],"ÜZLET");
	else if(page == 13)PlayerTextDrawSetString(playerid,TabletWin8Pag[1],"SkyDrive");
	else if(page == 14)PlayerTextDrawSetString(playerid,TabletWin8Pag[1],"BING");
	else if(page == 15)PlayerTextDrawSetString(playerid,TabletWin8Pag[1],"UTAZÁSOK");
	else if(page == 16)PlayerTextDrawSetString(playerid,TabletWin8Pag[1],"JÁTÉKOK");
	else if(page == 17)PlayerTextDrawSetString(playerid,TabletWin8Pag[1],"KAMERA");
	else if(page == 18)return PlayerTextDrawSetString(playerid,TabletWin8Pag[1],"ZENE"),ShowTabletMusicPlayer(playerid),ShowPagForItems(playerid),PlayerTextDrawHide(playerid,TabletWin8Pag[2]);
	else if(page == 19)return PlayerTextDrawSetString(playerid,TabletWin8Pag[1],"RÁDIÓ"), ShowTabletMP4(playerid),ShowPagForItems(playerid),PlayerTextDrawHide(playerid,TabletWin8Pag[2]);
    ShowPagForItems(playerid);
	return 1;
}