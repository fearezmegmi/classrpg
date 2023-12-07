function P:CreateTextdraws(playerid)
{
	P:DestroyTextdraws(playerid);
	
	// first line
	bTextOne[playerid] = CreatePlayerTextDraw(playerid, 100.000000, 200.000000, "1. KULCS BEHELYEZ‡SE");
	PlayerTextDrawLetterSize(playerid, bTextOne[playerid], 0.300000, 1.600000);
	PlayerTextDrawTextSize(playerid, bTextOne[playerid], 160.000000, 160.000000);
	PlayerTextDrawAlignment(playerid, bTextOne[playerid], 2);
	PlayerTextDrawColor(playerid, bTextOne[playerid], 0xFFFFFFFF);
	PlayerTextDrawUseBox(playerid, bTextOne[playerid], true);
	PlayerTextDrawBoxColor(playerid, bTextOne[playerid], 0x00000080);
	PlayerTextDrawSetShadow(playerid, bTextOne[playerid], 0);
	PlayerTextDrawSetOutline(playerid, bTextOne[playerid], 0);
	PlayerTextDrawFont(playerid, bTextOne[playerid], 2);
	PlayerTextDrawSetProportional(playerid, bTextOne[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, bTextOne[playerid], true);
	PlayerTextDrawShow(playerid, bTextOne[playerid]);
	
	// first line - progress
	bTextOneProgress[playerid] = CreatePlayerTextDraw(playerid, 20.000000, 200.000000, "_");
	PlayerTextDrawLetterSize(playerid, bTextOneProgress[playerid], 0.000000, 1.600000);
	PlayerTextDrawTextSize(playerid, bTextOneProgress[playerid], 180.000000, 200.000000);
	PlayerTextDrawAlignment(playerid, bTextOneProgress[playerid], 1);
	PlayerTextDrawColor(playerid, bTextOneProgress[playerid], 0);
	PlayerTextDrawUseBox(playerid, bTextOneProgress[playerid], true);
	PlayerTextDrawBoxColor(playerid, bTextOneProgress[playerid], 0x00FF0080);
	PlayerTextDrawSetShadow(playerid, bTextOneProgress[playerid], 0);
	PlayerTextDrawSetOutline(playerid, bTextOneProgress[playerid], 0);
	PlayerTextDrawFont(playerid, bTextOneProgress[playerid], 2);
	PlayerTextDrawShow(playerid, bTextOneProgress[playerid]);
	
	// second line
	bTextTwo[playerid] = CreatePlayerTextDraw(playerid, 100.000000, 220.000000, "2. KULCS ELFORD‹TSA");
	PlayerTextDrawLetterSize(playerid, bTextTwo[playerid], 0.300000, 1.600000);
	PlayerTextDrawTextSize(playerid, bTextTwo[playerid], 160.000000, 160.000000);
	PlayerTextDrawAlignment(playerid, bTextTwo[playerid], 2);
	PlayerTextDrawColor(playerid, bTextTwo[playerid], 0xFFFFFFFF);
	PlayerTextDrawUseBox(playerid, bTextTwo[playerid], true);
	PlayerTextDrawBoxColor(playerid, bTextTwo[playerid], 0x00000080);
	PlayerTextDrawSetShadow(playerid, bTextTwo[playerid], 0);
	PlayerTextDrawSetOutline(playerid, bTextTwo[playerid], 0);
	PlayerTextDrawFont(playerid, bTextTwo[playerid], 2);
	PlayerTextDrawSetProportional(playerid, bTextTwo[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, bTextTwo[playerid], true);
	PlayerTextDrawShow(playerid, bTextTwo[playerid]);
	
	// second line - progress
	bTextTwoProgress[playerid] = CreatePlayerTextDraw(playerid, 20.000000, 220.000000, "_");
	PlayerTextDrawLetterSize(playerid, bTextTwoProgress[playerid], 0.000000, 1.600000);
	PlayerTextDrawTextSize(playerid, bTextTwoProgress[playerid], 180.000000, 200.000000);
	PlayerTextDrawAlignment(playerid, bTextTwoProgress[playerid], 1);
	PlayerTextDrawColor(playerid, bTextTwoProgress[playerid], 0);
	PlayerTextDrawUseBox(playerid, bTextTwoProgress[playerid], true);
	PlayerTextDrawBoxColor(playerid, bTextTwoProgress[playerid], 0x00FF0080);
	PlayerTextDrawSetShadow(playerid, bTextTwoProgress[playerid], 0);
	PlayerTextDrawSetOutline(playerid, bTextTwoProgress[playerid], 0);
	PlayerTextDrawFont(playerid, bTextTwoProgress[playerid], 2);
	PlayerTextDrawShow(playerid, bTextTwoProgress[playerid]);
	
	// third line
	bTextThree[playerid] = CreatePlayerTextDraw(playerid, 100.000000, 240.000000, "3. LDA KINYITSA");
	PlayerTextDrawLetterSize(playerid, bTextThree[playerid], 0.300000, 1.600000);
	PlayerTextDrawTextSize(playerid, bTextThree[playerid], 160.000000, 160.000000);
	PlayerTextDrawAlignment(playerid, bTextThree[playerid], 2);
	PlayerTextDrawColor(playerid, bTextThree[playerid], 0xFFFFFFFF);
	PlayerTextDrawUseBox(playerid, bTextThree[playerid], true);
	PlayerTextDrawBoxColor(playerid, bTextThree[playerid], 0x00000080);
	PlayerTextDrawSetShadow(playerid, bTextThree[playerid], 0);
	PlayerTextDrawSetOutline(playerid, bTextThree[playerid], 0);
	PlayerTextDrawFont(playerid, bTextThree[playerid], 2);
	PlayerTextDrawSetProportional(playerid, bTextThree[playerid], 1);
	PlayerTextDrawSetSelectable(playerid, bTextThree[playerid], true);
	PlayerTextDrawShow(playerid, bTextThree[playerid]);
	
	// third line - progress
	bTextThreeProgress[playerid] = CreatePlayerTextDraw(playerid, 20.000000, 240.000000, "_");
	PlayerTextDrawLetterSize(playerid, bTextThreeProgress[playerid], 0.000000, 1.600000);
	PlayerTextDrawTextSize(playerid, bTextThreeProgress[playerid], 180.000000, 200.000000);
	PlayerTextDrawAlignment(playerid, bTextThreeProgress[playerid], 1);
	PlayerTextDrawColor(playerid, bTextThreeProgress[playerid], 0);
	PlayerTextDrawUseBox(playerid, bTextThreeProgress[playerid], true);
	PlayerTextDrawBoxColor(playerid, bTextThreeProgress[playerid], 0x00FF0080);
	PlayerTextDrawSetShadow(playerid, bTextThreeProgress[playerid], 0);
	PlayerTextDrawSetOutline(playerid, bTextThreeProgress[playerid], 0);
	PlayerTextDrawFont(playerid, bTextThreeProgress[playerid], 2);
	PlayerTextDrawShow(playerid, bTextThreeProgress[playerid]);
	
	P:UpdateProgress(playerid, BONUS_TEXTDRAW_ONE, 0);
	P:UpdateProgress(playerid, BONUS_TEXTDRAW_TWO, 0);
	P:UpdateProgress(playerid, BONUS_TEXTDRAW_THREE, 0);
	
	SelectTextDraw(playerid, 0xFFFFFFFF);
}

function P:UpdateProgress(playerid, row, Float:percent)
{
	new Float:start = 17.3;
	new Float:w = (start + (180.0 - start) * (floatmin(100.0, percent) / 100.0));
	
	if(row == BONUS_TEXTDRAW_ONE)
	{
		PlayerTextDrawHide(playerid, bTextOneProgress[playerid]);
		if(percent >= 1)
		{
			PlayerTextDrawTextSize(playerid, bTextOneProgress[playerid], w, 200.0);
			PlayerTextDrawShow(playerid, bTextOneProgress[playerid]);
		}
	}
	else if(row == BONUS_TEXTDRAW_TWO)
	{
		PlayerTextDrawHide(playerid, bTextTwoProgress[playerid]);
		if(percent >= 1)
		{
			PlayerTextDrawTextSize(playerid, bTextTwoProgress[playerid], w, 200.0);
			PlayerTextDrawShow(playerid, bTextTwoProgress[playerid]);
		}
	}
	else if(row == BONUS_TEXTDRAW_THREE)
	{
		PlayerTextDrawHide(playerid, bTextThreeProgress[playerid]);
		if(percent >= 1)
		{
			PlayerTextDrawTextSize(playerid, bTextThreeProgress[playerid], w, 200.0);
			PlayerTextDrawShow(playerid, bTextThreeProgress[playerid]);
		}
	}
}

function P:DestroyTextdraws(playerid, bool:cancelTextDraw = false)
{
	if(cancelTextDraw)
		CancelSelectTextDraw(playerid);
	
	if(bTextOne[playerid] != PlayerText:INVALID_TEXT_DRAW)
		PlayerTextDrawDestroy(playerid, bTextOne[playerid]);
	
	if(bTextOneProgress[playerid] != PlayerText:INVALID_TEXT_DRAW)
		PlayerTextDrawDestroy(playerid, bTextOneProgress[playerid]);
		
	if(bTextTwo[playerid] != PlayerText:INVALID_TEXT_DRAW)
		PlayerTextDrawDestroy(playerid, bTextTwo[playerid]);
	
	if(bTextTwoProgress[playerid] != PlayerText:INVALID_TEXT_DRAW)
		PlayerTextDrawDestroy(playerid, bTextTwoProgress[playerid]);
		
	if(bTextThree[playerid] != PlayerText:INVALID_TEXT_DRAW)
		PlayerTextDrawDestroy(playerid, bTextThree[playerid]);
	
	if(bTextThreeProgress[playerid] != PlayerText:INVALID_TEXT_DRAW)
		PlayerTextDrawDestroy(playerid, bTextThreeProgress[playerid]);
		
	bTextOne[playerid] = PlayerText:INVALID_TEXT_DRAW;
	bTextOneProgress[playerid] = PlayerText:INVALID_TEXT_DRAW;
	bTextTwo[playerid] = PlayerText:INVALID_TEXT_DRAW;
	bTextTwoProgress[playerid] = PlayerText:INVALID_TEXT_DRAW;
	bTextThree[playerid] = PlayerText:INVALID_TEXT_DRAW;
	bTextThreeProgress[playerid] = PlayerText:INVALID_TEXT_DRAW;
}