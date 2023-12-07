public P:OnGameModeInit()
{
	print("BONUS: init");
	
	// actor one
	bActorOne = CreateActor(BONUS_ACTOR_ONE_SKIN, BONUS_ACTOR_ONE_X, BONUS_ACTOR_ONE_Y, BONUS_ACTOR_ONE_Z, BONUS_ACTOR_ONE_A);
	SetActorVirtualWorld(bActorOne, BONUS_ACTOR_ONE_VW);
	
	// actor two
	bActorTwo = CreateActor(BONUS_ACTOR_TWO_SKIN, BONUS_ACTOR_TWO_X, BONUS_ACTOR_TWO_Y, BONUS_ACTOR_TWO_Z, BONUS_ACTOR_TWO_A);
	SetActorVirtualWorld(bActorTwo, BONUS_ACTOR_TWO_VW);
	
	// areas
	bAreaOutsideEnter = CreateDynamicSphere(BONUS_LOCATION_IN_X, BONUS_LOCATION_IN_Y, BONUS_LOCATION_IN_Z, BONUS_LOCATION_IN_R, 0, 0);
	bAreaLevelOneExit = CreateDynamicSphere(BONUS_LOCATION_ONE_IN_X, BONUS_LOCATION_ONE_IN_Y, BONUS_LOCATION_ONE_IN_Z, BONUS_LOCATION_ONE_IN_R, BONUS_LOCATION_ONE_IN_VW, 0);
	bAreaLevelOnePass = CreateDynamicSphere(BONUS_LOCATION_PASS_IN_X, BONUS_LOCATION_PASS_IN_Y, BONUS_LOCATION_PASS_IN_Z, BONUS_LOCATION_PASS_IN_R, BONUS_LOCATION_PASS_IN_VW, 0);
	bAreaLevelTwoExit = CreateDynamicSphere(BONUS_LOCATION_TWO_IN_X, BONUS_LOCATION_TWO_IN_Y, BONUS_LOCATION_TWO_IN_Z, BONUS_LOCATION_TWO_IN_R, BONUS_LOCATION_TWO_IN_VW, 0);
	bAreaTalkOne = CreateDynamicSphere(BONUS_LOCATION_TALK_ONE_X, BONUS_LOCATION_TALK_ONE_Y, BONUS_LOCATION_TALK_ONE_Z, BONUS_LOCATION_TALK_ONE_R, BONUS_LOCATION_TALK_ONE_VW, 0);
	bAreaTalkTwo = CreateDynamicSphere(BONUS_LOCATION_TALK_TWO_X, BONUS_LOCATION_TALK_TWO_Y, BONUS_LOCATION_TALK_TWO_Z, BONUS_LOCATION_TALK_TWO_R, BONUS_LOCATION_TALK_TWO_VW, 0);
	
	SetTimer(PS "Checker", 5000, 1);
	
	// keys
	P:InitKeys();
}

public P:OnPlayerLoginComplete(playerid)
{
	print("OnPlayerLoginComplete() called");
	
	// reset
	for(new i = 0; i < BONUS_MAX_TOKENS; i++)
		TokenInfo[playerid][i][T:Valid] = false;
	
	sql_query(TFormatInline("SELECT ID, Type, UNIX_TIMESTAMP(Created) FROM " SQL_DB_Tokens " WHERE PlayerID = '%d' AND Used IS NULL", PlayerInfo[playerid][pID]), \
		PS "OnTokenListRetrieved", "d", playerid);
}

fpublic P:OnTokenListRetrieved(playerid)
{
	new rows, fields;
	sql_data(rows, fields);
	printf("OnTokenListRetrieved() called - rows: %d, fields: %d", rows, fields);
	
	for(new i = 0; i < BONUS_MAX_TOKENS; i++)
	{
		// invalid & reset
		if(i >= rows)
		{
			TokenInfo[playerid][i][T:Valid] = false;
			continue;
		}
	
		TokenInfo[playerid][i][T:Valid] = true;
		
		// ID
		TokenInfo[playerid][i][T:ID] = sql_get_row_int(i, 0);
		
		// Type (raw)
		{
			new type[32];
			sql_get_row_str(i, 1, type);
			TokenInfo[playerid][i][T:Type] = GetTokenTypeFromString(type);
		}
		
		// Use type
		TokenInfo[playerid][i][T:UseType] = GetTokenUseType(TokenInfo[playerid][i][T:Type]);
		
		// Invalid token?
		if(TokenInfo[playerid][i][T:Type] == NINCS)
			TokenInfo[playerid][i][T:Valid] = false;
	}
}

public P:OnPlayerConnect(playerid)
{
	P:ResetVariables(playerid);
}

public P:OnPlayerDisconnect(playerid, reason)
{
	if(P:ActorPlayer(BONUS_ACTOR_ONE) == playerid)
		P:ResetActor(BONUS_ACTOR_ONE);
	
	if(P:ActorPlayer(BONUS_ACTOR_TWO) == playerid)
		P:ResetActor(BONUS_ACTOR_TWO);
		
	P:ResetPlayer(playerid);
	
	if(LadaKulcsMutat[playerid])
	{
		LadaKulcsMutat[playerid] = false;
		P:ShowKeysFor(playerid, false);
	}
}

public P:OnPlayerEnterDynamicArea(playerid, areaid)
{	
	if(areaid == bAreaOutsideEnter)
		Tele(playerid, BONUS_LOCATION_ONE_OUT_X, BONUS_LOCATION_ONE_OUT_Y, BONUS_LOCATION_ONE_OUT_Z, false, BONUS_LOCATION_ONE_OUT_VW, 0, BONUS_LOCATION_ONE_OUT_A);
	else if(areaid == bAreaLevelOneExit)
		Tele(playerid, BONUS_LOCATION_OUT_X, BONUS_LOCATION_OUT_Y, BONUS_LOCATION_OUT_Z, false, 0, 0, BONUS_LOCATION_OUT_A);
	else if(areaid == bAreaLevelOnePass)
	{
		if(LegalisSzervezetTagja(playerid))
			return Msg(playerid, "Ide nem j�hetsz be!");
			
		Tele(playerid, BONUS_LOCATION_TWO_OUT_X, BONUS_LOCATION_TWO_OUT_Y, BONUS_LOCATION_TWO_OUT_Z, false, BONUS_LOCATION_TWO_OUT_VW, 0, BONUS_LOCATION_TWO_OUT_A);
	}
	else if(areaid == bAreaLevelTwoExit)
		Tele(playerid, BONUS_LOCATION_PASS_OUT_X, BONUS_LOCATION_PASS_OUT_Y, BONUS_LOCATION_PASS_OUT_Z, false, BONUS_LOCATION_PASS_OUT_VW, 0, BONUS_LOCATION_PASS_OUT_A);
	else if(areaid == bAreaTalkOne)
		P:OnPlayerTalkArea(playerid, BONUS_ACTOR_ONE);
	else if(areaid == bAreaTalkTwo)
		P:OnPlayerTalkArea(playerid, BONUS_ACTOR_TWO);
		
	return 1;
}

public P:OnPlayerLeaveDynamicArea(playerid, areaid)
{
	if(areaid == bAreaTalkOne)
	{
		P:ResetActor(BONUS_ACTOR_ONE);
		P:ResetPlayer(playerid);
	}
	else if(areaid == bAreaTalkTwo)
	{
		P:ResetActor(BONUS_ACTOR_TWO);
		P:ResetPlayer(playerid);
	}
}

fpublic P:Checker()
{
	// check actor one
	{
		/*new Float:pos[3];
		GetActorPos(bActorOne, ArrExt(pos));
		
		new Float:dist = GetDistanceBetweenPoints(ArrExt(pos), BONUS_ACTOR_ONE_X, BONUS_ACTOR_ONE_Y, BONUS_ACTOR_ONE_Z);
		if(dist > 1.0)*/
			SetActorPos(bActorOne, BONUS_ACTOR_ONE_X, BONUS_ACTOR_ONE_Y, BONUS_ACTOR_ONE_Z);
	}
	
	// check actor two
	{
		/*new Float:pos[3];
		GetActorPos(bActorTwo, ArrExt(pos));
		
		new Float:dist = GetDistanceBetweenPoints(ArrExt(pos), BONUS_ACTOR_TWO_X, BONUS_ACTOR_TWO_Y, BONUS_ACTOR_TWO_Z);
		if(dist > 1.0)*/
			SetActorPos(bActorTwo, BONUS_ACTOR_TWO_X, BONUS_ACTOR_TWO_Y, BONUS_ACTOR_TWO_Z);
	}
}

function P:OnPlayerTalkArea(playerid, actor)
{
	if(P:ActorPlayer(actor) != INVALID_PLAYER_ID)
		return 1;
	
	if(actor == BONUS_ACTOR_ONE && !LegalisSzervezetTagja(playerid))
	{
		//Msg(playerid, "K�rem f�radjon le az alagsorba, �nt itt nem szolg�ljuk ki");
		SendFormalMessageByActor(P:GetActorID(actor), P:GetActorName(actor), "K�rem f�radjon le az alagsorba, �nt itt nem szolg�ljuk ki", BESZED_TAV_NORMAL);
		return 1;
	}
	
	bTalkWith[playerid] = actor;
	bAlreadyOpened[playerid] = false;
	P:ActorPlayer(actor, playerid);
	P:ActorStatus(actor, BONUS_ACTION_TALK);
	P:ActorLastAction(actor, UnixTime);
	
	P:ShowTalkDialog(playerid);
	
	return 1;
}

ALIAS(b4nusz):bonusz;
CMD:bonusz(playerid, params[])
{
	new fojog = Admin(playerid, 1337);
	new cmd[32], subcmd[128];
	if(sscanf(params, "s[32] S()[128]", cmd, subcmd))
	{
		Msg(playerid, "Haszn�lata: /b�nusz [parancs]");
		Msg(playerid, "Parancs: lista - az aktu�lisan felhaszn�lhat� b�nuszaid list�ja");
		Msg(playerid, "Parancs: �zlet - az �zlet hely�nek mutat�sa a t�rk�pen");
		Msg(playerid, "Parancs: �tad - l�da �tad�sa");
		//Msg(playerid, "Parancs: �truh�z - b�nusz �truh�z�sa m�s j�t�kosra");
		return 1;
	}
	
	if(egyezik(cmd, "uzlet") || egyezik(cmd, "�zlet"))
	{
		Msg(playerid, "Az �tterem helye megjel�lve a t�rk�pen");
		SetPlayerCheckpoint(playerid, BONUS_LOCATION_IN_X, BONUS_LOCATION_IN_Y, BONUS_LOCATION_IN_Z, BONUS_LOCATION_IN_R);
	}
	else if(fojog && (egyezik(cmd, "give")))
	{
		new target;
		if(sscanf(subcmd, "r", target))
			return Msg(playerid, "Haszn�lat: /b�nusz give [player]");
			
		if(target == INVALID_PLAYER_ID)
			return Msg(playerid, "�rv�nytelen j�t�kos");
			
		GiveRandomToken(target, BONUS_REASON_ADMIN_GIVE);
		Msg(playerid, TFormatInline("Adt�l egy l�d�t neki: [%d]%s", target, PlayerName(target)));
		Msg(target, TFormatInline("Admin %s adott neked egy l�d�t", AdminName(playerid)));
		ABroadCastFormat(COLOR_LIGHTBLUE, 1, "<< Admin [%d]%s adott egy l�d�t neki: [%d]%s >>", playerid, AdminName(playerid), target, PlayerName(target));
		Log("Szef", TFormatInline("Admin %s adott neki egy l�d�t: %s", PlayerName(playerid), PlayerName(target)));
	}
	else if(egyezik(cmd, "�tad") || egyezik(cmd, "atad"))
	{
		new crates = CountUnusedTokens(playerid);
		if(crates < 1)
			return Msg(playerid, "Nincs l�d�d");
			
		new target, amount;
		if(sscanf(subcmd, "ri", target, amount))
			return Msg(playerid, "Haszn�lat: /b�nusz �tad [j�t�kos] [mennyis�g]");
			
		if(!IsValidPlayer(target) || target == playerid)
			return Msg(playerid, "Nincs ilyen j�t�kos");
		
		if(amount < 1)
			return Msg(playerid, "Minimum 1");
		
		if(amount > crates)
			return Msg(playerid, "Nincs ennyi l�d�d");
		
		new targetCrates = CountTokens(target);
		if(targetCrates >= BONUS_MAX_TOKENS)
			return Msg(playerid, "N�la nincs t�bb hely");
		
		new targetAmount = (targetCrates + amount);
		if(targetAmount > BONUS_MAX_TOKENS)
			return Msg(playerid, TFormatInline("Ennyi nem f�r el n�la - max %d darabot adhatsz �t", (BONUS_MAX_TOKENS - targetCrates)));
		
		new given;
		for(new crate = 1; crate <= amount; crate++)
		{
			new tokenid = GetPlayerToken(playerid, BONUS_RANDOM);
			if(tokenid == NINCS)
				break;
				
			MoveToken(playerid, target, tokenid);
			given++;
		}
		
		SendFormatMessage(playerid, COLOR_LIGHTBLUE, "�tadt�l %ddb l�d�t neki: %s", given, PlayerName(target));
		SendFormatMessage(target, COLOR_LIGHTBLUE, "Kapt�l %ddb l�d�t t�le: %s", given, PlayerName(playerid));
		Cselekves(playerid, "�tadott n�h�ny l�d�t");
		Log("Szef", TFormatInline("%s �tadott egy l�d�t neki: %s", PlayerName(playerid), PlayerName(target)));
	}
	else if(egyezik(cmd, "lista"))
	{
		new count = CountTokensByUseType(playerid, true);
		if(count < 1)
			return Msg(playerid, "Nincs t�volr�l aktiv�lhat� b�nuszod");
			
		P:ShowTalkListDialog(playerid);
	}
	
	return 1;
}

function P:ShowTalkDialog(playerid)
{
	bDialogStatus[playerid] = BONUS_DIALOG_TALK;
	CustomDialog(playerid, D:bonuses, DIALOG_STYLE_LIST, P:GetActorName(bTalkWith[playerid]), "L�da nyit�sa\nFelhaszn�lhat� b�nuszok megtekint�se", "Tov�bb", "M�gse");
}

function P:ShowTalkOpenDialog(playerid)
{
	bDialogStatus[playerid] = BONUS_DIALOG_TALK_OPEN;
	CustomDialog(playerid, D:bonuses, DIALOG_STYLE_MSGBOX, P:GetActorName(bTalkWith[playerid]), "Biztosan kinyitod?", "Igen", "M�gse");
}

function P:ShowTalkListDialog(playerid)
{
	new count[BONUS_COUNT];
	new order[BONUS_COUNT] =
	{
		BONUS_CASH_100K,
		BONUS_CASH_500K,
		BONUS_CASH_1M,
		BONUS_CASH_30M,
		BONUS_CASH_100M,
		BONUS_TAX_10,
		BONUS_TAX_25,
		BONUS_TAX_50,
		BONUS_TAX_100,
		BONUS_INTEREST_001,
		BONUS_INTEREST_002,
		BONUS_INTEREST_003,
		BONUS_INTEREST_010
	};
	
	new bool:remote = (bTalkWith[playerid] == 0);
	for(new i = 0; i < BONUS_COUNT; i++)
	{
		new type = order[i];
		new usetype = GetTokenUseType(type);
		
		// filter out unusable tokens
		if(!CanUseTokenType(usetype, remote))
			continue;
		
		count[i] = CountTokensByType(playerid, type);
	}

	new msg[1024], row;
	strcat(msg, "B�nusz\tMennyis�g\n");
	for(new t = 0; t < BONUS_COUNT; t++)
	{
		bDialogRows[playerid][t] = NINCS;
		new type = order[t];
		if(count[t] > 0)
		{
			strcat(msg, TFormatInline("%s\t%d darab\n", GetTokenName(type), count[t]));	
			bDialogRows[playerid][row] = type;
			row++;
		}
	}
	
	bDialogStatus[playerid] = BONUS_DIALOG_TALK_LIST;
	CustomDialog(playerid, D:bonuses, DIALOG_STYLE_TABLIST_HEADERS, (bTalkWith[playerid] ? P:GetActorName(bTalkWith[playerid]) : "B�nuszok"), msg, "Tov�bb", "M�gse");
}

function P:ShowTalkListActionDialog(playerid)
{
	bDialogStatus[playerid] = BONUS_DIALOG_TALK_LIST_ACTION;
	CustomDialog(playerid, D:bonuses, DIALOG_STYLE_LIST, (bTalkWith[playerid] ? P:GetActorName(bTalkWith[playerid]) : "B�nuszok"), "Felhaszn�l\n�tad", "Tov�bb", "M�gse");
}

function P:ShowTalkGiveDialog(playerid)
{
	bDialogStatus[playerid] = BONUS_DIALOG_TALK_GIVE;
	CustomDialog(playerid, D:bonuses, DIALOG_STYLE_INPUT, (bTalkWith[playerid] ? P:GetActorName(bTalkWith[playerid]) : "B�nuszok"), "Kinek szeretn�d �tadni?", "Tov�bb", "M�gse");
}

Dialog:bonuses(playerid, response, listitem, inputtext[])
{
	// talk
	if(bDialogStatus[playerid] == BONUS_DIALOG_TALK)
	{
		if(!response)
		{
			P:ResetActor(bTalkWith[playerid]);
			P:ResetPlayer(playerid);
			return 1;
		}
		
		// talk - open
		if(listitem == 0)
		{
			if(!CheckCrateAndKey(playerid))
			{
				P:ShowTalkDialog(playerid);
				return 1;
			}
			
			P:ShowTalkOpenDialog(playerid);
		}
		
		// talk - list
		else if(listitem == 1)
		{
			if(CountUsableTokens(playerid) == 0)
			{
				P:ShowTalkDialog(playerid);
				Msg(playerid, "Nincs haszn�lhat� b�nuszod");
				return 1;
			}
			
			P:ShowTalkListDialog(playerid);
		}
			
		return 1;
	}
	
	// talk open
	else if(bDialogStatus[playerid] == BONUS_DIALOG_TALK_OPEN)
	{
		if(!response)
		{
			P:ShowTalkDialog(playerid);
			return 1;
		}
		
		if(!CheckCrateAndKey(playerid))
		{
			P:ShowTalkDialog(playerid);
			return 1;
		}
		
		if(!bAlreadyOpened[playerid])
		{
			switch(bTalkWith[playerid])
			{
				case BONUS_ACTOR_ONE:
				{
					switch(random(3))
					{
						case 0: SendFormalMessageByPlayer(playerid, "�dv! Csomagot venn�k �t.", BESZED_TAV_NORMAL);
						case 1: SendFormalMessageByPlayer(playerid, "Hello! A csomagom�rt j�ttem.", BESZED_TAV_NORMAL);
						case 2: SendFormalMessageByPlayer(playerid, "Hali! A csomagomat venn�m �t.", BESZED_TAV_NORMAL);
					}
				}
				case BONUS_ACTOR_TWO:
				{
					switch(random(3))
					{
						case 0: SendFormalMessageByPlayer(playerid, "Cs�! Csomag?", BESZED_TAV_NORMAL);
						case 1: SendFormalMessageByPlayer(playerid, "Yo! Csomagot ide!", BESZED_TAV_NORMAL);
						case 2: SendFormalMessageByPlayer(playerid, "Tes� dobd a cuccost!", BESZED_TAV_NORMAL);
					}
				}
			}
		}
		else
		{
			switch(bTalkWith[playerid])
			{
				case BONUS_ACTOR_ONE:
				{
					switch(random(2))
					{
						case 0: SendFormalMessageByPlayer(playerid, "K�rem a k�vetkez�t", BESZED_TAV_NORMAL);
						case 1: SendFormalMessageByPlayer(playerid, "J�het m�g", BESZED_TAV_NORMAL);
					}
				}
				case BONUS_ACTOR_TWO:
				{
					switch(random(3))
					{
						case 0: SendFormalMessageByPlayer(playerid, "Adjad a k�vetkez�t!", BESZED_TAV_NORMAL);
						case 1: SendFormalMessageByPlayer(playerid, "Rem�lem van m�g!", BESZED_TAV_NORMAL);
						case 2: SendFormalMessageByPlayer(playerid, "M������g!", BESZED_TAV_NORMAL);
					}
				}
			}
		}
		
		bOpenPhase[playerid] = BONUS_OPEN_PHASE_ONE;
		bOpenPhaseWorking[playerid] = false;
		P:CreateTextdraws(playerid);
		P:LadaObject(bTalkWith[playerid], true);
		P:Interpolate(playerid, bTalkWith[playerid]);
		Streamer_Update(playerid);
		
		return 1;
	}
	
	// just opened
	else if(bDialogStatus[playerid] == BONUS_DIALOG_TALK_OPEN_MSG)
	{
		P:ShowTalkDialog(playerid);
	}
	
	// just used
	else if(bDialogStatus[playerid] == BONUS_DIALOG_TALK_USE_MSG)
	{
		P:ShowTalkDialog(playerid);
	}
	
	// talk list
	else if(bDialogStatus[playerid] == BONUS_DIALOG_TALK_LIST)
	{
		if(!response)
		{
			if(bTalkWith[playerid])
				P:ShowTalkDialog(playerid);
				
			return 1;
		}
		
		bDialogSelected[playerid] = bDialogRows[playerid][listitem];
		if(!bDialogSelected[playerid])
		{
			P:ShowTalkListDialog(playerid);
			return 1;
		}
		
		P:ShowTalkListActionDialog(playerid);
	}
	
	// talk list action
	else if(bDialogStatus[playerid] == BONUS_DIALOG_TALK_LIST_ACTION)
	{
		if(!response)
		{
			P:ShowTalkListDialog(playerid);
			return 1;
		}
		
		new type = bDialogSelected[playerid];
		if(type == NINCS)
			return Msg(playerid, "Nincs ilyen b�nuszod");
			
		new token = GetPlayerToken(playerid, type);
		if(token == NINCS)
			return Msg(playerid, "Nincs ilyen b�nuszod!");
			
		new bool:remote = (bTalkWith[playerid] == 0);
		
		// use
		if(listitem == 0)
		{
			if(!CanUseToken(playerid, token, remote))
			{
				if(remote)
					Msg(playerid, "A b�nusz haszn�lat�hoz az �letbe kell menned");
				else
					Msg(playerid, "A b�nusz nem haszn�lhat� az �zletben");
					
				return 1;
			}
			
			P:OnPlayerUseToken(playerid, token);
		}
		
		// give
		else if(listitem == 1)
		{
			P:ShowTalkGiveDialog(playerid);
		}
	}
	
	// talk give
	else if(bDialogStatus[playerid] == BONUS_DIALOG_TALK_GIVE)
	{
		if(!response)
		{
			P:ShowTalkListActionDialog(playerid);
			return 1;
		}
		
		new target;
		if(sscanf(inputtext, "r", target) || !IsValidPlayer(target) || playerid == target)
		{
			Msg(playerid, "Nincs ilyen j�t�kos!");
			P:ShowTalkListActionDialog(playerid);
			return 1;
		}
		
		new type = bDialogSelected[playerid];
		if(type == NINCS)
			return Msg(playerid, "Nincs ilyen b�nuszod");
			
		new token = GetPlayerToken(playerid, type);
		if(token == NINCS)
			return Msg(playerid, "Nincs ilyen b�nuszod!");
		
		MoveToken(playerid, target, token);
		SendFormatMessage(playerid, COLOR_LIGHTBLUE, "%s �tadott neked egy b�nuszt: %s", PlayerName(playerid), GetTokenName(type));
		SendFormatMessage(target, COLOR_LIGHTBLUE, "�tadt�l neki egy b�nuszt (%s) neki: %s", GetTokenName(type), PlayerName(target));
		Log("Szef", TFormatInline("%s �tadott egy b�nuszt (%s) neki: %s", PlayerName(playerid), GetTokenName(type), PlayerName(target)));
		P:ShowTalkListDialog(playerid);
	}
	
	return 1;
}

public P:OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{	
	if(bOpenPhaseWorking[playerid])
		return 1;
		
	if(playertextid == bTextOne[playerid] && bOpenPhase[playerid] == BONUS_OPEN_PHASE_ONE
		|| playertextid == bTextTwo[playerid] && bOpenPhase[playerid] == BONUS_OPEN_PHASE_TWO
		|| playertextid == bTextThree[playerid] && bOpenPhase[playerid] == BONUS_OPEN_PHASE_THREE)
		P:StartOpenPhase(playerid);
	
	return 1;
}

public P:OnPlayerClickTextDraw(playerid, Text:clickedid)
{
	if(clickedid == Text:INVALID_TEXT_DRAW)
	{
		P:DestroyTextdraws(playerid);
		P:KillActorTimer(bTalkWith[playerid]);
		//P:ShowTalkDialog(playerid);
		SetCameraBehindPlayer(playerid);
		return 1;
	}
	
	return 1;
}

function P:StartOpenPhase(playerid)
{
	bOpenPhaseWorking[playerid] = true;
	P:OpenPhaseWorker(playerid, 0);
}

fpublic P:OpenPhaseWorker(playerid, percent)
{
	new row;
	switch(bOpenPhase[playerid])
	{
		case BONUS_OPEN_PHASE_ONE: row = BONUS_TEXTDRAW_ONE;
		case BONUS_OPEN_PHASE_TWO: row = BONUS_TEXTDRAW_TWO;
		case BONUS_OPEN_PHASE_THREE: row = BONUS_TEXTDRAW_THREE;
	}
	
	P:UpdateProgress(playerid, row, percent);
	
	if(percent < 100)
		P:ActorOpenTimer(bTalkWith[playerid], SetTimerEx(PS "OpenPhaseWorker", 50, false, "dd", playerid, percent + 2));
	else
	{
		bOpenPhaseWorking[playerid] = false;
		
		switch(bOpenPhase[playerid])
		{
			case BONUS_OPEN_PHASE_ONE:
				bOpenPhase[playerid] = BONUS_OPEN_PHASE_TWO;
			
			case BONUS_OPEN_PHASE_TWO:
				bOpenPhase[playerid] = BONUS_OPEN_PHASE_THREE;
				
			case BONUS_OPEN_PHASE_THREE:
			{
				P:DestroyTextdraws(playerid, true);
				P:OnOpenComplete(playerid);
				P:LadaObject(bTalkWith[playerid], false);
				SetCameraBehindPlayer(playerid);
			}
		}
	}
}

function P:OnOpenComplete(playerid)
{
	new token = GetPlayerToken(playerid, BONUS_RANDOM);
	if(token == NINCS)
		return 1;
	
	bAlreadyOpened[playerid] = true;
	
	new type = GetRandomToken();
	TokenInfo[playerid][token][T:Type] = type;
	PlayerInfo[playerid][pLadaKulcs]--;
	
	new bool:autouse;
	switch(type)
	{
		case BONUS_CASH_100K: P:OnOpenCash(playerid, 100000), autouse = true;
		case BONUS_CASH_500K: P:OnOpenCash(playerid, 500000), autouse = true;
		case BONUS_CASH_1M: P:OnOpenCash(playerid, 1000000), autouse = true;
		case BONUS_CASH_30M: P:OnOpenCash(playerid, 30000000), autouse = true;
		case BONUS_CASH_100M: P:OnOpenCash(playerid, 100000000), autouse = true;
		
		case BONUS_TAX_10: P:OnOpenTax(playerid, 10);
		case BONUS_TAX_25: P:OnOpenTax(playerid, 25);
		case BONUS_TAX_50: P:OnOpenTax(playerid, 50);
		case BONUS_TAX_100: P:OnOpenTax(playerid, 100);
		
		case BONUS_INTEREST_001: P:OnOpenInterest(playerid, 0.01);
		case BONUS_INTEREST_002: P:OnOpenInterest(playerid, 0.02);
		case BONUS_INTEREST_003: P:OnOpenInterest(playerid, 0.03);
		case BONUS_INTEREST_010: P:OnOpenInterest(playerid, 0.10);
	}
	
	OpenToken(playerid, token, autouse);
	
	Cselekves(playerid, "kinyitott egy l�d�t");
	return 1;
}

function P:OnOpenCash(playerid, cash)
{
	Log("Szef", TFormatInline("%s nyitott egy l�d�t, tartalma: %sFt", PlayerName(playerid), FormatNumber(cash, 0, ',')));
	GiveMoney(playerid, cash);
	
	bDialogStatus[playerid] = BONUS_DIALOG_TALK_OPEN_MSG;
	CustomDialog(playerid, D:bonuses, DIALOG_STYLE_MSGBOX, (bTalkWith[playerid] ? P:GetActorName(bTalkWith[playerid]) : "B�nuszok"), \
		TFormatInline("A l�da tartalma: %s Ft", FormatNumber(cash, 0, ',')), "OK", "");
}

function P:OnOpenTax(playerid, Float:amount)
{
	Log("Szef", TFormatInline("%s nyitott egy l�d�t, tartalma: ad�cs�kkent�s (%.0f%%)", PlayerName(playerid), amount + FLOATFIX));
	
	bDialogStatus[playerid] = BONUS_DIALOG_TALK_OPEN_MSG;
	CustomDialog(playerid, D:bonuses, DIALOG_STYLE_MSGBOX, (bTalkWith[playerid] ? P:GetActorName(bTalkWith[playerid]) : "B�nuszok"), \
		TFormatInline("A l�da tartalma: ad�cs�kkent�s (%.0f%%)", amount + FLOATFIX), "OK", "");
}

function P:OnOpenInterest(playerid, Float:amount)
{
	Log("Szef", TFormatInline("%s nyitott egy l�d�t, tartalma: kamat (%.2f%%)", PlayerName(playerid), amount + FLOATFIX));
	
	bDialogStatus[playerid] = BONUS_DIALOG_TALK_OPEN_MSG;
	CustomDialog(playerid, D:bonuses, DIALOG_STYLE_MSGBOX, (bTalkWith[playerid] ? P:GetActorName(bTalkWith[playerid]) : "B�nuszok"), \
		TFormatInline("A l�da tartalma: kamat (%.2f%%)", amount + FLOATFIX), "OK", "");
}

function P:OnPlayerUseToken(playerid, tokenid)
{
	new type = TokenInfo[playerid][tokenid][T:Type];
	switch(type)
	{
		case BONUS_TAX_10: P:OnPlayerUseTax(playerid, 10, BONUS_TIME_TAX_10);
		case BONUS_TAX_25: P:OnPlayerUseTax(playerid, 25, BONUS_TIME_TAX_25);
		case BONUS_TAX_50: P:OnPlayerUseTax(playerid, 50, BONUS_TIME_TAX_50);
		case BONUS_TAX_100: P:OnPlayerUseTax(playerid, 100, BONUS_TIME_TAX_100);
		
		case BONUS_INTEREST_001: P:OnPlayerUseInterest(playerid, 0.01, BONUS_TIME_INTEREST_001);
		case BONUS_INTEREST_002: P:OnPlayerUseInterest(playerid, 0.02, BONUS_TIME_INTEREST_002);
		case BONUS_INTEREST_003: P:OnPlayerUseInterest(playerid, 0.03, BONUS_TIME_INTEREST_003);
		case BONUS_INTEREST_010: P:OnPlayerUseInterest(playerid, 0.10, BONUS_TIME_INTEREST_010);
	}
	
	UseToken(playerid, tokenid);
}

function P:OnPlayerUseTax(playerid, Float:amount, time)
{
	Log("Szef", TFormatInline("%s felhaszn�lt egy ad�cs�kkent�s b�nuszt (%.0f%% - %d fizet�sig)", PlayerName(playerid), amount + FLOATFIX, time));
	
	bDialogStatus[playerid] = BONUS_DIALOG_TALK_USE_MSG;
	CustomDialog(playerid, D:bonuses, DIALOG_STYLE_MSGBOX, (bTalkWith[playerid] ? P:GetActorName(bTalkWith[playerid]) : "B�nuszok"), \
		"Ad�cs�kkent�s b�nusz felhaszn�lva!", "OK", "");
		
	if(BonusInfo[playerid][B:Ado] != amount)
	{
		BonusInfo[playerid][B:Ado] = amount;
		BonusInfo[playerid][B:AdoIdo] = time;
	}
	else
		BonusInfo[playerid][B:AdoIdo] += time;
}

function P:OnPlayerUseInterest(playerid, Float:amount, time)
{
	Log("Szef", TFormatInline("%s felhaszn�lt egy kamat b�nuszt (%.2f%% - %d fizet�sig)", PlayerName(playerid), amount + FLOATFIX, time));
	
	bDialogStatus[playerid] = BONUS_DIALOG_TALK_USE_MSG;
	CustomDialog(playerid, D:bonuses, DIALOG_STYLE_MSGBOX, (bTalkWith[playerid] ? P:GetActorName(bTalkWith[playerid]) : "B�nuszok"), \
		"Kamat b�nusz felhaszn�lva!", "OK", "");
		
	if(BonusInfo[playerid][B:Kamat] != amount)
	{
		BonusInfo[playerid][B:Kamat] = amount;
		BonusInfo[playerid][B:KamatIdo] = time;
	}
	else
		BonusInfo[playerid][B:KamatIdo] += time;
}
