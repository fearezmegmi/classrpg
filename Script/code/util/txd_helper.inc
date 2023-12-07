/***********************************
 *                                 *
 *     Made by Clint               *
 *            for ClassRPG.net     *
 *                                 *
 **********************************/

/*
	info
		canvas: 640x480
		start: 5, end: 635 -> width: 630
*/

#if !defined INVALID_TEXTDRAW
	#define INVALID_TEXTDRAW (Text:INVALID_TEXT_DRAW)
#endif

#if !defined INVALID_PTEXTDRAW
	#define INVALID_PTEXTDRAW (PlayerText:INVALID_TEXT_DRAW)
#endif

#define TXD_LETTERSIZE_Y_MULTIPLIER	0.135 // 0.12687959

stock PlayerText:TXD_Area(playerid, Float:x, Float:y, Float:width, Float:height, color)
{
	new PlayerText:txd = CreatePlayerTextDraw(playerid, x, y, "_"); // start x,y
	PlayerTextDrawTextSize(playerid, txd, x + width, 0); // end x
	PlayerTextDrawLetterSize(playerid, txd, 0, height * TXD_LETTERSIZE_Y_MULTIPLIER); // size y
	PlayerTextDrawUseBox(playerid, txd, true);
	PlayerTextDrawBoxColor(playerid, txd, color);
	PlayerTextDrawShow(playerid, txd);
	return txd;
}

stock PlayerText:TXD_Text(playerid, Float:x, Float:y, Float:sizeX, Float:sizeY, text[], color, font = 2)
{
	new PlayerText:txd = CreatePlayerTextDraw(playerid, x, y, text);
	PlayerTextDrawLetterSize(playerid, txd, sizeX * TXD_LETTERSIZE_Y_MULTIPLIER, sizeY * TXD_LETTERSIZE_Y_MULTIPLIER);
	PlayerTextDrawAlignment(playerid, txd, 2);
	PlayerTextDrawColor(playerid, txd, color);
	PlayerTextDrawFont(playerid, txd, font);
	PlayerTextDrawShow(playerid, txd);
	return txd;
}

stock PlayerText:TXD_Button(playerid, Float:x, Float:y, text[], Float:sizeX, Float:sizeY, Float:width, Float:height, color, boxcolor = 0x999999AA, font = 1)
{
	new PlayerText:txd = CreatePlayerTextDraw(playerid, x, y, text);
	PlayerTextDrawLetterSize(playerid, txd, sizeX * TXD_LETTERSIZE_Y_MULTIPLIER, sizeY * TXD_LETTERSIZE_Y_MULTIPLIER);
	PlayerTextDrawAlignment(playerid, txd, 2);
	PlayerTextDrawColor(playerid, txd, color);
	PlayerTextDrawFont(playerid, txd, font);
	PlayerTextDrawUseBox(playerid, txd, true);
	PlayerTextDrawBoxColor(playerid, txd, boxcolor);
	PlayerTextDrawTextSize(playerid, txd, height, width);
	PlayerTextDrawSetShadow(playerid, txd, 0);
	PlayerTextDrawSetOutline(playerid, txd, -1);
	PlayerTextDrawSetProportional(playerid, txd, 1);
	PlayerTextDrawSetSelectable(playerid, txd, true);
	PlayerTextDrawShow(playerid, txd);
	return txd;
}