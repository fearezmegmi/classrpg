/*
		Script Type: Include
		Script Name: Buttons Include
		Script Version: V1.0 (Initial Release)
		Script Author: SpiritEvil
		Script Description: Create Buttons using only ONE line of code!


		++++++++ | Cahgnge Log | +++++++++
		+   	       					 +
		+  *V1.0 Initial Release         +
		+                                +
		+                                +
		+                                +
		+                                +
		+                                +
		+                                +
		++++++++++++++++++++++++++++++++++
*/

/*	Natives List:

native Button:CreateButtonForPlayer(playerid, text[], Float:x, Float:y, Float:width = 72.0, Float:height = 23.0);
native ShowButtonForPlayer(playerid, Button:btnid);
native DestroyButton(Button:btnid);
native DestroyButtonForPlayer(playerid, Button:btnid);
native HideButtonForPlayer(playerid, Button:btnid);
native SetButtonTextForPlayer(playerid, Button:btnid, text[]);
native ChangeButtonColorsForPlayer(playerid, Button:btnid, strokeCol, buttonCol, textCol);
native IsValidButton(Button:btnid);
native UpdateButtonForPlayer(playerid, Button:btnid);

*/

forward OnPlayerClickButton(playerid, Button:btnid);

#include <a_samp>

#define MAX_BUTTONS 100
#define INVALID_BUTTON_ID (Button:-1)

#define HOVER_COLOR 0x1696CCFF //Change this to the color you like! (default: 0x1696CCFF)

enum buttonInfo
{
	Float:btn_x,
	Float:btn_y,
	Float:btn_w,
	Float:btn_h,
	btn_txt[200],
	btn_col_stroke,
	btn_col_bg,
	btn_col_txt,
	bool:btn_created,
};

new Buttons[MAX_BUTTONS][buttonInfo];
new PlayerText:btn_td1[MAX_BUTTONS][MAX_PLAYERS],
	PlayerText:btn_td2[MAX_BUTTONS][MAX_PLAYERS],
	PlayerText:btn_td3[MAX_BUTTONS][MAX_PLAYERS];

stock Button:CreateButtonForPlayer(playerid, text[], Float:x, Float:y, Float:width = 72.0, Float:height = 23.0)
{
	new btnid;
	for(btnid = 0; btnid <= sizeof(Buttons); btnid++)
		if(!Buttons[btnid][btn_created]) break;
	if(Buttons[btnid][btn_created] || btnid == sizeof Buttons)
		return INVALID_BUTTON_ID;

	new PlayerText:textdraw;
	textdraw = btn_td1[btnid][playerid] = CreatePlayerTextDraw(playerid, x, y, "_");
	PlayerTextDrawBackgroundColor(playerid, textdraw, 255);
	PlayerTextDrawFont(playerid, textdraw, 1);
	PlayerTextDrawLetterSize(playerid, textdraw, 0.500000, height / 10);
	PlayerTextDrawColor(playerid, textdraw, -1);
	PlayerTextDrawSetOutline(playerid, textdraw, 0);
	PlayerTextDrawSetProportional(playerid, textdraw, 1);
	PlayerTextDrawSetShadow(playerid, textdraw, 1);
	PlayerTextDrawUseBox(playerid, textdraw, 1);
	PlayerTextDrawBoxColor(playerid, textdraw, 255);
	PlayerTextDrawTextSize(playerid, textdraw, x + width, 0.000000);

	textdraw = btn_td2[btnid][playerid] = CreatePlayerTextDraw(playerid, x+2, y+3, "_");
	PlayerTextDrawBackgroundColor(playerid, textdraw, 255);
	PlayerTextDrawFont(playerid, textdraw, 1);
	PlayerTextDrawLetterSize(playerid, textdraw, 0.500000, height / 10 - 0.5);
	PlayerTextDrawColor(playerid, textdraw, -1);
	PlayerTextDrawSetOutline(playerid, textdraw, 0);
	PlayerTextDrawSetProportional(playerid, textdraw, 1);
	PlayerTextDrawSetShadow(playerid, textdraw, 1);
	PlayerTextDrawUseBox(playerid, textdraw, 1);
	PlayerTextDrawBoxColor(playerid, textdraw, -16776961);
	PlayerTextDrawTextSize(playerid, textdraw, x + width - 2, 0.000000);

	textdraw = btn_td3[btnid][playerid] = CreatePlayerTextDraw(playerid, x+8, y+3, text);
	PlayerTextDrawBackgroundColor(playerid, textdraw, 255);
	PlayerTextDrawFont(playerid, textdraw, 1);
	PlayerTextDrawLetterSize(playerid, textdraw, 0.5, height / 10 - 0.8);
	PlayerTextDrawColor(playerid, textdraw, -1);
	PlayerTextDrawSetOutline(playerid, textdraw, 1);
	PlayerTextDrawSetProportional(playerid, textdraw, 1);
	PlayerTextDrawUseBox(playerid, textdraw, 1);
	PlayerTextDrawBoxColor(playerid, textdraw, 0);
	PlayerTextDrawTextSize(playerid, textdraw, x + width - 1, height);

	PlayerTextDrawSetSelectable(playerid, textdraw, 1);

	Buttons[btnid][btn_x] = x;
	Buttons[btnid][btn_y] = y;
	Buttons[btnid][btn_h] = height;
	Buttons[btnid][btn_w] = width;
	format(Buttons[_:btnid][btn_txt], 200, "%s", text);
	Buttons[btnid][btn_col_stroke] = 255;
	Buttons[btnid][btn_col_bg] = -16776961;
	Buttons[btnid][btn_col_txt] = -1;
	Buttons[btnid][btn_created] = true;
	//printf("%i", _:btnid);
	return Button:btnid;

}

stock ShowButtonForPlayer(playerid, Button:btnid)
{
	if(IsPlayerConnected(playerid))
	{
		if(!Buttons[_:btnid][btn_created]) return 0;
		PlayerTextDrawShow(playerid, btn_td1[_:btnid][playerid]);
		PlayerTextDrawShow(playerid, btn_td2[_:btnid][playerid]);
		PlayerTextDrawShow(playerid, btn_td3[_:btnid][playerid]);
		SelectTextDraw(playerid, HOVER_COLOR);
		return 1;
	}
	return 0;
}

stock DestroyButton(Button:btnid)
{
	for(new playerid = 0; playerid <= GetMaxPlayers(); playerid++)
	{
		if(IsPlayerConnected(playerid))
		{
			if(btnid != INVALID_BUTTON_ID && Button:-1 < btnid < Button:MAX_BUTTONS)
			{
				if(!Buttons[_:btnid][btn_created]) return 0;

				PlayerTextDrawDestroy(playerid, btn_td1[btnid][playerid]);
				PlayerTextDrawDestroy(playerid, btn_td2[btnid][playerid]);
				PlayerTextDrawDestroy(playerid, btn_td3[btnid][playerid]);

				Buttons[btnid][btn_created] = false;
				Buttons[btnid][btn_x] = -1;
				Buttons[btnid][btn_y] = -1;
				Buttons[btnid][btn_w] = -1;
				Buttons[btnid][btn_h] = -1;
				btn_td1[btnid][playerid] = INVALID_TEXT_DRAW;
				btn_td2[btnid][playerid] = INVALID_TEXT_DRAW;
				btn_td3[btnid][playerid] = INVALID_TEXT_DRAW;
				Buttons[btnid][btn_col_stroke] = -1;
				Buttons[btnid][btn_col_bg] = -1;
				Buttons[btnid][btn_col_txt] = -1;
				return 1;
			}
		}
	}

	return 0;
}

stock DestroyButtonForPlayer(playerid, Button:btnid)
{
	if(btnid != INVALID_BUTTON_ID && Button:-1 < btnid < Button:MAX_BUTTONS)
	{
		if(!Buttons[_:btnid][btn_created]) return 0;

		PlayerTextDrawDestroy(playerid, btn_td1[_:btnid][playerid]);
		PlayerTextDrawDestroy(playerid, btn_td2[_:btnid][playerid]);
		PlayerTextDrawDestroy(playerid, btn_td3[_:btnid][playerid]);

		Buttons[_:btnid][btn_created] = false;
		Buttons[_:btnid][btn_x] = -1;
		Buttons[_:btnid][btn_y] = -1;
		Buttons[_:btnid][btn_w] = -1;
		Buttons[_:btnid][btn_h] = -1;
		btn_td1[_:btnid][playerid] = PlayerText:-1;
		btn_td2[_:btnid][playerid] = PlayerText:-1;
		btn_td3[_:btnid][playerid] = PlayerText:-1;
		Buttons[_:btnid][btn_col_stroke] = -1;
		Buttons[_:btnid][btn_col_bg] = -1;
		Buttons[_:btnid][btn_col_txt] = -1;
		//Buttons[btnid][btn_txt] = "_";
		return 1;
	}
	return 0;
}

stock HideButtonForPlayer(playerid, Button:btnid)
{
	if(btnid != INVALID_BUTTON_ID && Button:-1 < btnid < Button:MAX_BUTTONS)
	{
		if(!Buttons[_:btnid][btn_created]) return 0;
		PlayerTextDrawHide(playerid, btn_td1[_:btnid][playerid]);
		PlayerTextDrawHide(playerid, btn_td2[_:btnid][playerid]);
		PlayerTextDrawHide(playerid, btn_td3[_:btnid][playerid]);
		return 1;
	}
	return 0;
}

stock SetButtonTextForPlayer(playerid, Button:btnid, text[])
{
	if(btnid != INVALID_BUTTON_ID && Button:-1 < btnid < Button:MAX_BUTTONS)
	{
		if(!Buttons[_:btnid][btn_created]) return 0;
		PlayerTextDrawSetString(playerid, btn_td3[_:btnid][playerid], text);
		format(Buttons[_:btnid][btn_txt], 200, "%s", text);
		return 1;
	}
	return 0;
}

stock ChangeButtonColorsForPlayer(playerid, Button:btnid, strokeCol, buttonCol, textCol)
{
	if(btnid != INVALID_BUTTON_ID && Button:-1 < btnid < Button:MAX_BUTTONS)
	{
		if(!Buttons[_:btnid][btn_created]) return 0;
		Buttons[_:btnid][btn_col_stroke] = strokeCol;
		Buttons[_:btnid][btn_col_bg] = buttonCol;
		Buttons[_:btnid][btn_col_txt] = textCol;
		PlayerTextDrawBoxColor(playerid, btn_td1[_:btnid][playerid], strokeCol);
		PlayerTextDrawBoxColor(playerid, btn_td2[_:btnid][playerid], buttonCol);
		PlayerTextDrawColor(playerid, btn_td3[_:btnid][playerid], textCol);
		return 1;
	}
	return 0;
}

stock IsValidButton(Button:btnid)
{
	if(btnid != INVALID_BUTTON_ID && Button:-1 < btnid < Button:MAX_BUTTONS)
	{
		if(!Buttons[_:btnid][btn_created]) return false;
		else return true;
	}
	return false;
}

stock UpdateButtonForPlayer(playerid, Button:btnid)
{
	if(btnid != INVALID_BUTTON_ID && Button:-1 < btnid < Button:MAX_BUTTONS)
	{
		if(!Buttons[_:btnid][btn_created]) return 0;
		HideButtonForPlayer(playerid, btnid);
		ShowButtonForPlayer(playerid, btnid);
		return 1;
	}
	return 0;
}

stock B_OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
	for(new i; i <= MAX_BUTTONS; i++)
	{
		if(Buttons[i][btn_created])
		{
			if(playertextid == btn_td3[i][playerid])
			{
				OnPlayerClickButton(playerid, Button:i);
			}
		}
	}
	return 1;
}
