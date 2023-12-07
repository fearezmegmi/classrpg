#include <a_samp>
#include <util/txd_helper>
#include <util/formatnumber>
#include <game/system/system_donate.inc>

enum donateTXD
{
	bool:dActive,
	PlayerText:dBackground,
	PlayerText:dShadow,
	PlayerText:dKredit,
	PlayerText:dButton[DONATE_BUTTONS],
	PlayerText:dCloseButton
}
new DonateTXD[MAX_PLAYERS][donateTXD];

#define DONATE_C_X_WIDTH	640 // canvas
#define DONATE_Y			100
#define DONATE_WIDTH 		470
#define DONATE_HEIGHT		250
#define DONATE_BORDER		5
#define DONATE_PADDING		10
#define DONATE_BTN_XSIZE	4.0
#define DONATE_BTN_YSIZE	12.0
#define DONATE_BTN_WIDTH	110.0
#define DONATE_BTN_HEIGHT	15
#define DONATE_BTN_DEF_COL	0xFFFFFFFF /*0xFFFFFFFF - 0xDDDDFFFF*/
#define DONATE_BTN_DEF_BCOL	0x999999FF /*0x999999FF - 0x001100FF*/
#define DONATE_BTN_SPACE	30

#define DONATE_TOP			(DONATE_Y + DONATE_PADDING)
#define DONATE_LEFT			((DONATE_C_X_WIDTH - DONATE_WIDTH) / 2)
#define DONATE_CENTER		(DONATE_C_X_WIDTH / 2)
#define DONATE_RIGHT		(DONATE_LEFT + DONATE_WIDTH)

#define DONATE_BTN_BOTTOM	(DONATE_HEIGHT + 20)
#define DONATE_BTN_CENTER	(DONATE_WIDTH/2 - DONATE_PADDING - DONATE_BTN_WIDTH/2)
#define DONATE_BTN_RIGHT	(DONATE_WIDTH - DONATE_PADDING*2 - DONATE_BTN_WIDTH)

#define FormatInt(%1)		FormatNumber(%1, 0, ',')
#define FormatFloat(%1,%2)	FormatNumber(%1, %2, ',')

new D_DialogDonate_Kredit[MAX_PLAYERS];

stock PlayerText:CreateDonateBtn(playerid, Float:x, Float:y, text[], color = DONATE_BTN_DEF_COL, boxcolor = DONATE_BTN_DEF_BCOL, Float:letterSizeX = DONATE_BTN_XSIZE, Float:letterSizeY = DONATE_BTN_YSIZE, Float:width = DONATE_BTN_WIDTH)
	return TXD_Button(playerid, DONATE_LEFT + DONATE_PADDING + x + DONATE_BTN_WIDTH/2, DONATE_Y + DONATE_PADDING + y, text, letterSizeX, letterSizeY, width, DONATE_BTN_HEIGHT, color, boxcolor);

forward ShowKreditPanel(playerid, kredit);
public ShowKreditPanel(playerid, kredit)
	return Init(playerid, kredit);
	
forward UpdateKreditPanel(playerid, kredit);
public UpdateKreditPanel(playerid, kredit)
{
	D_DialogDonate_Kredit[playerid] = kredit;
	if(DonateTXD[playerid][dActive] && DonateTXD[playerid][dKredit] != INVALID_PTEXTDRAW)
	{
		new kreditStr[32];
		format(kreditStr, 32, "Kredit~n~~y~%d", kredit);
		PlayerTextDrawSetString(playerid, DonateTXD[playerid][dKredit], kreditStr);
		return 1;
	}
	return 0;
}

stock Init(playerid, kredit)
{
	if(DonateTXD[playerid][dActive])
		return 0;
	
	D_DialogDonate_Kredit[playerid] = kredit;

	new kreditStr[32];
	format(kreditStr, 32, "Kredit~n~~y~%d", kredit);
	DonateTXD[playerid][dActive] = true;
	DonateTXD[playerid][dShadow] = TXD_Area(playerid, DONATE_LEFT - DONATE_BORDER, DONATE_Y - 5, DONATE_WIDTH + DONATE_BORDER * 2, DONATE_HEIGHT + DONATE_BORDER * 2 - 1, 0x00000055);
	DonateTXD[playerid][dBackground] = TXD_Area(playerid, DONATE_LEFT, DONATE_Y, DONATE_WIDTH, DONATE_HEIGHT, 0x00000055);
	DonateTXD[playerid][dKredit] = TXD_Text(playerid, DONATE_CENTER, DONATE_Y + DONATE_PADDING + 20, 5, 15, kreditStr, 0xFFFFFFFF);
	DonateTXD[playerid][dCloseButton] = CreateDonateBtn(playerid, DONATE_BTN_CENTER, DONATE_BTN_BOTTOM + 40, "Bez˜r˜s", 0xAAAAAAFF, 0x00000000); //0xFFAA33FF, 0x555555AA);
	
	// GOMBOK	
	// közép fent
	DonateTXD[playerid][dButton][DONATE_KREDIT]		= CreateDonateBtn(playerid, DONATE_BTN_CENTER, 0, "Kredit v˜s˜rl˜s", _, 0xCCAC00FF, DONATE_BTN_XSIZE * 1.1, DONATE_BTN_YSIZE * 1.1, DONATE_BTN_WIDTH * 1.4);
	DonateTXD[playerid][dButton][DONATE_PREMIUMPONT]= CreateDonateBtn(playerid, DONATE_BTN_CENTER, DONATE_BTN_SPACE*2, "Pržmiumpont v˜s˜rl˜s", _, 0xCCAC00FF, DONATE_BTN_XSIZE * 1.1, DONATE_BTN_YSIZE * 1.1, DONATE_BTN_WIDTH * 1.4);
	
	// bal
	DonateTXD[playerid][dButton][DONATE_KESZPENZ]	= CreateDonateBtn(playerid, 0, 0, "Kžszpžnz");
	DonateTXD[playerid][dButton][DONATE_KOKAIN] 	= CreateDonateBtn(playerid, 0, DONATE_BTN_SPACE, "Kokain");
	DonateTXD[playerid][dButton][DONATE_HEROIN] 	= CreateDonateBtn(playerid, 0, DONATE_BTN_SPACE*2, "Heroin");
	DonateTXD[playerid][dButton][DONATE_MARIHUANA] 	= CreateDonateBtn(playerid, 0, DONATE_BTN_SPACE*3, "Marihuana");
	DonateTXD[playerid][dButton][DONATE_MATERIAL] 	= CreateDonateBtn(playerid, 0, DONATE_BTN_SPACE*4, "Material");
	
	// jobb
	//DonateTXD[playerid][dButton][DONATE_BORTONIDO] 	= CreateDonateBtn(playerid, DONATE_BTN_RIGHT, 0, "_");
	//DonateTXD[playerid][dButton][DONATE_KAMAT] 		= CreateDonateBtn(playerid, DONATE_BTN_RIGHT, DONATE_BTN_SPACE, "_");
	//DonateTXD[playerid][dButton][DONATE_ADO] 		= CreateDonateBtn(playerid, DONATE_BTN_RIGHT, DONATE_BTN_SPACE*2, "_");
	// lent
	//DonateTXD[playerid][dButton][DONATE_FEGYVER] 	= CreateDonateBtn(playerid, 0, DONATE_BTN_BOTTOM - DONATE_BTN_SPACE, "_");
	//DonateTXD[playerid][dButton][DONATE_PANCEL] 	= CreateDonateBtn(playerid, 0, DONATE_BTN_BOTTOM, "_");
	// közép
	//DonateTXD[playerid][dButton][DONATE_ALAKIT] 	= CreateDonateBtn(playerid, DONATE_BTN_CENTER, DONATE_BTN_BOTTOM - DONATE_BTN_SPACE, "_", _, _, DONATE_BTN_XSIZE * 0.9);
	//DonateTXD[playerid][dButton][DONATE_BELSO]		= CreateDonateBtn(playerid, DONATE_BTN_CENTER, DONATE_BTN_BOTTOM, "_", _, _, DONATE_BTN_XSIZE * 0.9);
	// jobb
	//DonateTXD[playerid][dButton][DONATE_JARMU_SLOT]	= CreateDonateBtn(playerid, DONATE_BTN_RIGHT, DONATE_BTN_BOTTOM - DONATE_BTN_SPACE, "_");
	//DonateTXD[playerid][dButton][DONATE_HAZ_SLOT]	= CreateDonateBtn(playerid, DONATE_BTN_RIGHT, DONATE_BTN_BOTTOM, "_");
	
	// jobb
	DonateTXD[playerid][dButton][DONATE_BORTONIDO] 	= CreateDonateBtn(playerid, DONATE_BTN_RIGHT, 0, "B¨rt¨nid§");
	DonateTXD[playerid][dButton][DONATE_KAMAT] 		= CreateDonateBtn(playerid, DONATE_BTN_RIGHT, DONATE_BTN_SPACE, "Kamat");
	DonateTXD[playerid][dButton][DONATE_ADO] 		= CreateDonateBtn(playerid, DONATE_BTN_RIGHT, DONATE_BTN_SPACE*2, "Ad¦cs¨kkentžs", _, _, DONATE_BTN_XSIZE * 0.9);
	// lent
	//DonateTXD[playerid][dButton][DONATE_FEGYVER] 	= CreateDonateBtn(playerid, 0, DONATE_BTN_BOTTOM - DONATE_BTN_SPACE, "Fegyver");
	//DonateTXD[playerid][dButton][DONATE_PANCEL] 	= CreateDonateBtn(playerid, 0, DONATE_BTN_BOTTOM, "P˜ncžl");
	// közép
	//DonateTXD[playerid][dButton][DONATE_ALAKIT] 	= CreateDonateBtn(playerid, DONATE_BTN_CENTER, DONATE_BTN_BOTTOM - DONATE_BTN_SPACE, "J˜rm« alak¢t˜s", _, _, DONATE_BTN_XSIZE * 0.9);
	//DonateTXD[playerid][dButton][DONATE_BELSO]		= CreateDonateBtn(playerid, DONATE_BTN_CENTER, DONATE_BTN_BOTTOM, "H˜zbels§ csere", _, _, DONATE_BTN_XSIZE * 0.9);
	// jobb
	//DonateTXD[playerid][dButton][DONATE_JARMU_SLOT]	= CreateDonateBtn(playerid, DONATE_BTN_RIGHT, DONATE_BTN_BOTTOM - DONATE_BTN_SPACE, "J˜rm« slot");
	//DonateTXD[playerid][dButton][DONATE_HAZ_SLOT]	= CreateDonateBtn(playerid, DONATE_BTN_RIGHT, DONATE_BTN_BOTTOM, "H˜z slot");
	
	// aktiválás
	/*PlayerTextDrawSetSelectable(playerid, DonateTXD[playerid][dCloseButton], true);
	for(new b = 0; b < DONATE_BUTTONS; b++)
		PlayerTextDrawSetSelectable(playerid, DonateTXD[playerid][dButton][b], true);*/
	
	SelectTextDraw(playerid, 0xAAFFAAAA);
	
	return 1;
}

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
	if(clickedid == INVALID_TEXTDRAW && DonateTXD[playerid][dActive])
		return Dispose(playerid);
		
	return 0;
}

public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
	if(DonateTXD[playerid][dActive])
	{
		if(DonateTXD[playerid][dCloseButton] == playertextid)
			Dispose(playerid), CancelSelectTextDraw(playerid);
		else
		{
			for(new b = 0; b < DONATE_BUTTONS; b++)
			{
				if(DonateTXD[playerid][dButton][b] == playertextid)
				{
					CallRemoteFunction("OnPlayerPickDonateItem", "ii", playerid, b);
					break;
				}
			}
		}
	}
	return 0;
}

stock Dispose(playerid)
{
	DonateTXD[playerid][dActive] = false;
	if(DonateTXD[playerid][dBackground] != INVALID_PTEXTDRAW) PlayerTextDrawDestroy(playerid, DonateTXD[playerid][dBackground]);
	if(DonateTXD[playerid][dShadow] != INVALID_PTEXTDRAW) PlayerTextDrawDestroy(playerid, DonateTXD[playerid][dShadow]);
	if(DonateTXD[playerid][dKredit] != INVALID_PTEXTDRAW) PlayerTextDrawDestroy(playerid, DonateTXD[playerid][dKredit]);
	if(DonateTXD[playerid][dCloseButton] != INVALID_PTEXTDRAW) PlayerTextDrawDestroy(playerid, DonateTXD[playerid][dCloseButton]);

	for(new i = 0; i < DONATE_BUTTONS; i++)
		if(DonateTXD[playerid][dButton][i] != INVALID_PTEXTDRAW)
			PlayerTextDrawDestroy(playerid, DonateTXD[playerid][dButton][i]);
	
	return 1;
}

public OnPlayerConnect(playerid)
{
	//Init(playerid);
}

public OnPlayerDisconnect(playerid)
{
	Dispose(playerid);
}

public OnFilterScriptExit()
{
	for(new i = 0, m = GetMaxPlayers(); i < m; i++)
	{
		if(IsPlayerConnected(i))
			Dispose(i);
	}
}

/* ######################################################################################################################### */
/* ######################################################################################################################### */
/* ######################################################################################################################### */

#define DEAMX_PROTECTION
main()
{
	for(new playerid, m = GetMaxPlayers(); playerid < m; playerid++)
	{
		DonateTXD[playerid][dBackground] = INVALID_PTEXTDRAW;
		DonateTXD[playerid][dShadow] = INVALID_PTEXTDRAW;
		DonateTXD[playerid][dKredit] = INVALID_PTEXTDRAW;
		DonateTXD[playerid][dCloseButton] = INVALID_PTEXTDRAW;
		
		for(new i = 0; i < DONATE_BUTTONS; i++)
			DonateTXD[playerid][dButton][i] = INVALID_PTEXTDRAW;
	}
	
	#if defined DEAMX_PROTECTION
	state de1:on;
	#endif
}

#if defined DEAMX_PROTECTION
public OnFilterScriptInit() <de1:on>
{
	print("[Kliens]I LIKE COOKIES");
	return 1;
}
#endif

#if defined DEAMX_PROTECTION
public OnFilterScriptInit() <>
#else
public OnFilterScriptInit()
#endif
{
	/********************
	 *                  *
	 *    Anti-DeAMX    *
	 *                  *
	 ********************/
	
	#if defined DEAMX_PROTECTION
	new de2[][] =
	{
		"Cukorkaáá",
		"Fáááák",
		"bolygÓ"
	};
	#pragma unused de2
	
	new de3;
	#emit load.pri de3
	#emit stor.pri de3
	#endif
	
	/********************/

	return 1;
}