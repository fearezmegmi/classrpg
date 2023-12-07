// -----------------------------------------------------------------------------
//	Név:            Speciális karakterek javítása a feliratokban
//  Készítõ:        GameStar
//  Frissítve:      2012. augusztus 2.
//  Web:            sa-mp.hu
// -----------------------------------------------------------------------------
#include <a_samp>

#if defined fixchars_included
	#endinput
#endif
#define fixchars_included
#pragma library fixchars

// -----------------------------------------------------------------------------
//	Név:            Fixchar
//  Készítõ:        GameStar
//  Frissítve:      2012. augusztus 2.
//  Web:            sa-mp.hu
// -----------------------------------------------------------------------------
stock Fixchar(c)
{
	switch (c)
 	{
 	    // ß
		case 223: c = 150;

		// ä/Ä
		case 228: c = 154;
		case 196: c = 131;
	    
 	    // á/Á
  		case 225: c = 152;
        case 193: c = 128;

		// é/É
        case 233: c = 158;
        case 201: c = 135;

        // í/Í
        case 237: c = 162;
        case 205: c = 139;

        // ó/Ó
        case 243: c = 166;
        case 211: c = 143;

		// õ/Õ
		case 245: c = 167;
        case 213: c = 144;

		// ö/Õ
		case 246: c = 168;
        case 214: c = 145;

		// ú/Ú
		case 250: c = 170;
        case 218: c = 147;

        // û/Û
		case 251: c = 171;
        case 219: c = 148;

        // í/Í
		case 252: c = 172;
        case 220: c = 149;
	}
	return c;
}

// -----------------------------------------------------------------------------
//	Név:            FIXCHARS_GameTextForPlayer
//  Készítõ:        GameStar
//  Frissítve:      2012. augusztus 2.
//  Web:            sa-mp.hu
// -----------------------------------------------------------------------------
stock FIXCHARS_GameTextForPlayer(playerid,text[],time,style)
{
    for (new index, character; (character = getarg(1, index)); index++) setarg(1, index, Fixchar(character));
	return GameTextForPlayer(playerid,text,time,style);
}

#if defined _ALS_GameTextForPlayer
    #undef GameTextForPlayer
#else
    #define _ALS_GameTextForPlayer
#endif
#define GameTextForPlayer FIXCHARS_GameTextForPlayer

// -----------------------------------------------------------------------------
//	Név:            FIXCHARS_GameTextForAll
//  Készítõ:        GameStar
//  Frissítve:      2012. augusztus 2.
//  Web:            sa-mp.hu
// -----------------------------------------------------------------------------
stock FIXCHARS_GameTextForAll(text[],time,style)
{
    for (new index, character; (character = getarg(0, index)); index++) setarg(0, index, Fixchar(character));
	return GameTextForAll(text,time,style);
}

#if defined _ALS_GameTextForAll
    #undef GameTextForAll
#else
    #define _ALS_GameTextForAll
#endif
#define GameTextForAll FIXCHARS_GameTextForAll

// -----------------------------------------------------------------------------
//	Név:            FIXCHARS_TextDrawCreate
//  Készítõ:        GameStar
//  Frissítve:      2012. augusztus 2.
//  Web:            sa-mp.hu
// -----------------------------------------------------------------------------
stock Text:FIXCHARS_TextDrawCreate(Float:x, Float:y, text[])
{
	for (new index, character; (character = getarg(2, index)); index++) setarg(2, index, Fixchar(character));
	return TextDrawCreate(x,y,text);
}

#if defined _ALS_TextDrawCreate
    #undef TextDrawCreate
#else
    #define _ALS_TextDrawCreate
#endif
#define TextDrawCreate FIXCHARS_TextDrawCreate

// -----------------------------------------------------------------------------
//	Név:            FIXCHARS_CreateMenu
//  Készítõ:        GameStar
//  Frissítve:      2012. augusztus 2.
//  Web:            sa-mp.hu
// -----------------------------------------------------------------------------
stock Menu:FIXCHARS_CreateMenu(title[], columns, Float:x, Float:y, Float:col1width, Float:col2width = 0.0)
{
	for (new index, character; (character = getarg(0, index)); index++) setarg(0, index, Fixchar(character));
	return CreateMenu(title,columns,x,y,col1width,col2width);
}

#if defined _ALS_CreateMenu
    #undef CreateMenu
#else
    #define _ALS_CreateMenu
#endif
#define CreateMenu FIXCHARS_CreateMenu

// -----------------------------------------------------------------------------
//	Név:            FIXCHARS_SetMenuColumnHeader
//  Készítõ:        GameStar
//  Frissítve:      2012. augusztus 2.
//  Web:            sa-mp.hu
// -----------------------------------------------------------------------------
stock FIXCHARS_SetMenuColumnHeader(Menu:menuid, column, columnheader[])
{
    for (new index, character; (character = getarg(2, index)); index++) setarg(2, index, Fixchar(character));
	return SetMenuColumnHeader(menuid, column, columnheader);
}

#if defined _ALS_SetMenuColumnHeader
    #undef SetMenuColumnHeader
#else
    #define _ALS_SetMenuColumnHeader
#endif
#define SetMenuColumnHeader FIXCHARS_SetMenuColumnHeader

// -----------------------------------------------------------------------------
//	Név:            FIXCHARS_AddMenuItem
//  Készítõ:        GameStar
//  Frissítve:      2012. augusztus 2.
//  Web:            sa-mp.hu
// -----------------------------------------------------------------------------
stock FIXCHARS_AddMenuItem(Menu:menuid, column, menutext[])
{
    for (new index, character; (character = getarg(2, index)); index++) setarg(2, index, Fixchar(character));
	return AddMenuItem(menuid, column, menutext);
}

#if defined _ALS_AddMenuItem
    #undef AddMenuItem
#else
    #define _ALS_AddMenuItem
#endif
#define AddMenuItem FIXCHARS_AddMenuItem

// -----------------------------------------------------------------------------
//	Név:            FIXCHARS_TextDrawSetString
//  Készítõ:        GameStar
//  Frissítve:      2012. augusztus 2.
//  Web:            sa-mp.hu
// -----------------------------------------------------------------------------
stock FIXCHARS_TextDrawSetString(Text:text, string[])
{
    for (new index, character; (character = getarg(1, index)); index++) setarg(1, index, Fixchar(character));
	return TextDrawSetString(text,string);
}

#if defined _ALS_TextDrawSetString
    #undef TextDrawSetString
#else
    #define _ALS_TextDrawSetString
#endif
#define TextDrawSetString FIXCHARS_TextDrawSetString

// -----------------------------------------------------------------------------
//	Név:            FIXCHARS_CreatePlayerTextDraw
//  Készítõ:        GameStar
//  Frissítve:      2012. augusztus 2.
//  Web:            sa-mp.hu
// -----------------------------------------------------------------------------
#if defined CreatePlayerTextDraw
	stock PlayerText:FIXCHARS_CreatePlayerTextDraw(playerid, Float:x, Float:y, text[])
	{
		for (new index, character; (character = getarg(3, index)); index++) setarg(3, index, Fixchar(character));
		return CreatePlayerTextDraw(playerid, x, y, text);
	}
	
	#if defined _ALS_CreatePlayerTextDraw
    #undef CreatePlayerTextDraw
	#else
	    #define _ALS_CreatePlayerTextDraw
	#endif
	#define CreatePlayerTextDraw FIXCHARS_CreatePlayerTextDraw
#endif

// -----------------------------------------------------------------------------
//	Név:            FIXCHARS_PlayerTextDrawSetS
//  Készítõ:        GameStar
//  Frissítve:      2012. augusztus 2.
//  Web:            sa-mp.hu
// -----------------------------------------------------------------------------
#if defined PlayerTextDrawSetString
	stock FIXCHARS_PlayerTextDrawSetS(playerid, PlayerText:text, string[])
	{
		for (new index, character; (character = getarg(2, index)); index++) setarg(2, index, Fixchar(character));
		return PlayerTextDrawSetString(playerid,text,string);
	}
	
	#if defined _ALS_PlayerTextDrawSetString
    #undef PlayerTextDrawSetString
	#else
	    #define _ALS_PlayerTextDrawSetString
	#endif
	#define PlayerTextDrawSetString FIXCHARS_PlayerTextDrawSetS
#endif
