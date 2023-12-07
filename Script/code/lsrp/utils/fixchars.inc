// ----------------------------------
// Magyar karakterek megjelen�t�s�nek automatikus jav�t�sa
// Haszn�lathoz csak be kell �gyazni: #include <fixchars>
// K�sz�tette GameStar 2010 (friss�tve 2012 �prilis)
// Weboldal: www.gtaforum.hu
//
// + RICARDO mSelection bugjav�t�s
// ----------------------------------
#include <a_samp>

#if defined fixchars_included
	#endinput
#endif
#define fixchars_included

stock fixchar(chr)
{
	switch(chr)
	{
	    case '�': return '�';
	    case '�': return '�';
	    case '�': return '�';
	    case '�': return '�';
	    case '�': return '�';
	    case '�': return '�';
	    case '�': return '�';
	    case '�': return '�';
	    case '�': return '�';
	    case '�': return '�';
	    case '�': return '�';
	    case '�': return '�';
	    case '�': return '�';
	    case '�': return '�';
	    case '�': return '�';
	    case '�': return '�';
	    case '�': return '�';
	    case '�': return '�';
	}
	return chr;
}

stock fixchars(string[])
{
	new chr;
	while(string[chr])
	{
	    string[chr] = fixchar(string[chr]);
	    chr ++;
	}
	return 1;
}

stock unfixchar(chr)
{
	switch(chr)
	{
	    case '�': return '�';
	    case '�': return '�';
	    case '�': return '�';
	    case '�': return '�';
	    case '�': return '�';
	    case '�': return '�';
	    case '�': return '�';
	    case '�': return '�';
	    case '�': return '�';
	    case '�': return '�';
	    case '�': return '�';
	    case '�': return '�';
	    case '�': return '�';
	    case '�': return '�';
	    case '�': return '�';
	    case '�': return '�';
	    case '�': return '�';
	    case '�': return '�';
	}
	return chr;
}

stock unfixchars(string[])
{
	new chr;
	while(string[chr])
	{
	    string[chr] = unfixchar(string[chr]);
	    chr ++;
	}
	return 1;
}

stock fixchars_GameTextForPlayer(playerid,text[],time,style)
{
    fixchars(text);
	return GameTextForPlayer(playerid,text,time,style);
}
#define GameTextForPlayer fixchars_GameTextForPlayer

stock fixchars_GameTextForAll(text[],time,style)
{
    fixchars(text);
	return GameTextForAll(text,time,style);
}
#define GameTextForAll fixchars_GameTextForAll

stock Text:fixchars_TextDrawCreate(Float:x, Float:y, text[])
{
    fixchars(text);
	return TextDrawCreate(x,y,text);
}
#define TextDrawCreate fixchars_TextDrawCreate

stock Menu:fixchars_CreateMenu(title[], columns, Float:x, Float:y, Float:col1width, Float:col2width = 0.0)
{
    fixchars(title);
	return CreateMenu(title,columns,x,y,col1width,col2width);
}
#define CreateMenu fixchars_CreateMenu

stock fixchars_SetMenuColumnHeader(Menu:menuid, column, columnheader[])
{
    fixchars(columnheader);
	return SetMenuColumnHeader(menuid, column, columnheader);
}
#define SetMenuColumnHeader fixchars_SetMenuColumnHeader

stock fixchars_AddMenuItem(Menu:menuid, column, menutext[])
{
    fixchars(menutext);
 	return AddMenuItem(menuid, column, menutext);
}
#define AddMenuItem fixchars_AddMenuItem

stock fixchars_TextDrawSetString(Text:text, string[])
{
    fixchars(string);
	return TextDrawSetString(text,string);
}
#define TextDrawSetString fixchars_TextDrawSetString

// 0.3e
#if defined CreatePlayerTextDraw
	stock PlayerText:fixchars_CreatePlayerTextDraw(playerid, Float:x, Float:y, text[])
	{
		fixchars(text);
		return CreatePlayerTextDraw(playerid, x, y, text);
	}

	#define CreatePlayerTextDraw fixchars_CreatePlayerTextDraw
#endif

#if defined PlayerTextDrawSetString
	stock fixchars_PlayerTextDrawSetS(playerid, PlayerText:text, string[])
	{
		fixchars(string);
		return PlayerTextDrawSetString(playerid,text,string);
	}

	#define PlayerTextDrawSetString fixchars_PlayerTextDrawSetS
#endif

#if defined ShowModelSelectionMenu
	stock fixchars_ShowModelSelectionMenu(playerid, ListID, header_text[], dialogBGcolor = 0x4A5A6BBB, previewBGcolor = 0x88888899, tdSelectionColor = 0xFFFF00AA)
	{
		fixchars(header_text);
		return ShowModelSelectionMenu(playerid, ListID, header_text, dialogBGcolor, previewBGcolor, tdSelectionColor);
	}
	#define ShowModelSelectionMenu fixchars_ShowModelSelectionMenu
#endif

#if defined ShowModelSelectionMenuEx
	stock fixchars_SMSMEx(playerid, items_array[], item_amount, header_text[], extraid, Float:Xrot = 0.0, Float:Yrot = 0.0, Float:Zrot = 0.0, Float:mZoom = 1.0, dialogBGcolor = 0x4A5A6BBB, previewBGcolor = 0x88888899, tdSelectionColor = 0xFFFF00AA)
	{
		fixchars(header_text);
		return ShowModelSelectionMenuEx(playerid, items_array, item_amount, header_text, extraid, Xrot, Yrot, Zrot, mZoom, dialogBGcolor, previewBGcolor, tdSelectionColor);
	}
	#define ShowModelSelectionMenuEx fixchars_SMSMEx
#endif