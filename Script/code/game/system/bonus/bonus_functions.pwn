function GiveRandomToken(playerid, reason[])
{
	GiveToken(playerid, reason, BONUS_RANDOM);
}

function GiveToken(playerid, reason[], type)
{
	new qry[512];
	Format(qry, "INSERT INTO " SQL_DB_Tokens " (Type, Created, CreatedBy, CreatedPlayer, CreatedPlayerName, PlayerID, PlayerName) VALUES('%s', FROM_UNIXTIME(%d), '%s', '%d', '%s', '%d','%s')", \
		GetStringFromTokenType(type), UnixTime, reason, PlayerInfo[playerid][pID], PlayerInfo[playerid][pNev], PlayerInfo[playerid][pID], PlayerInfo[playerid][pNev]);
		
	sql_query(qry, PS "OnGiveRandomToken", "dd", playerid, type);
}

fpublic P:OnGiveRandomToken(playerid, type)
{
	new id = GetFreeTokenSlot(playerid);
	if(id != NINCS)
	{
		TokenInfo[playerid][id][T:Valid] = true;
		TokenInfo[playerid][id][T:ID] = sql_insertid();
		TokenInfo[playerid][id][T:Type] = type;
		TokenInfo[playerid][id][T:UseType] = GetTokenUseType(type);
	}
}

function OpenToken(playerid, tokenid, bool:use)
{
	// update db
	new qry[512];
	Format(qry, "UPDATE " SQL_DB_Tokens " SET Type = '%s', Opened = FROM_UNIXTIME(%d), OpenedBy = '%d', OpenedByName = '%s' WHERE ID = '%d'", \
		GetStringFromTokenType(TokenInfo[playerid][tokenid][T:Type]), UnixTime, PlayerInfo[playerid][pID], PlayerInfo[playerid][pNev], TokenInfo[playerid][tokenid][T:ID]);
		
	doQuery(qry);
	
	if(use)
		UseToken(playerid, tokenid);
}

function UseToken(playerid, tokenid)
{
	// update db
	new qry[512];
	Format(qry, "UPDATE " SQL_DB_Tokens " SET Used = FROM_UNIXTIME(%d), UsedBy = '%d', UsedByName = '%s' WHERE ID = '%d'", \
		UnixTime, PlayerInfo[playerid][pID], PlayerInfo[playerid][pNev], TokenInfo[playerid][tokenid][T:ID]);
	doQuery(qry);
	
	TokenInfo[playerid][tokenid][T:Valid] = false;
}

function MoveToken(playerid, target, tokenid)
{
	// update db
	new qry[512];
	Format(qry, "UPDATE " SQL_DB_Tokens " SET PlayerID = '%d', PlayerName = '%s' WHERE ID = '%d'", \
		PlayerInfo[target][pID], PlayerInfo[target][pNev], TokenInfo[playerid][tokenid][T:ID]);
	doQuery(qry);
	
	// update local data for target
	new targetSlot = GetFreeTokenSlot(target);
	if(targetSlot != NINCS)
	{
		TokenInfo[target][targetSlot][T:Valid] = true;
		TokenInfo[target][targetSlot][T:ID] = TokenInfo[playerid][tokenid][T:ID];
		TokenInfo[target][targetSlot][T:Type] = TokenInfo[playerid][tokenid][T:Type];
		TokenInfo[target][targetSlot][T:UseType] = TokenInfo[playerid][tokenid][T:UseType];
	}
		
	// update local data for owner
	TokenInfo[playerid][tokenid][T:Valid] = false;
}

function GetFreeTokenSlot(playerid)
{
	for(new t = 0; t < BONUS_MAX_TOKENS; t++)
	{
		if(!IsValidToken(playerid, t))
			return t;
	}
	
	return NINCS;
}

function bool:CanUseTokenType(usetype, bool:remote)
{
	return (usetype == BONUS_TYPE_ANYWHERE || remote && usetype == BONUS_TYPE_REMOTE || !remote && usetype == BONUS_TYPE_LOCAL);
}

function bool:CanUseToken(playerid, tokenid, bool:remote)
{
	return CanUseTokenType(TokenInfo[playerid][tokenid][T:UseType], remote);
}

function CountTokens(playerid)
{
	new count;
	for(new i = 0; i < BONUS_MAX_TOKENS; i++)
	{
		if(IsValidToken(playerid, i))
			count++;
	}
	
	return count;
}

function CountUnusedTokens(playerid)
{
	new count;
	for(new i = 0; i < BONUS_MAX_TOKENS; i++)
	{
		if(IsValidToken(playerid, i) && TokenInfo[playerid][i][T:Type] == BONUS_RANDOM)
			count++;
	}
	
	return count;
}

function CountUsableTokens(playerid)
{
	new count;
	for(new i = 0; i < BONUS_MAX_TOKENS; i++)
	{
		if(IsValidToken(playerid, i) && TokenInfo[playerid][i][T:Type] != BONUS_RANDOM)
			count++;
	}
	
	return count;
}

function CountTokensByType(playerid, type)
{
	new count;
	for(new i = 0; i < BONUS_MAX_TOKENS; i++)
	{
		if(IsValidToken(playerid, i) && TokenInfo[playerid][i][T:Type] == type)
			count++;
	}
	
	return count;
}

function CountTokensByUseType(playerid, bool:remote)
{
	new count;
	for(new i = 0; i < BONUS_MAX_TOKENS; i++)
	{
		if(IsValidToken(playerid, i) && TokenInfo[playerid][i][T:Type] != BONUS_RANDOM && CanUseToken(playerid, i, remote))
			count++;
	}
	
	return count;
}

function GetPlayerToken(playerid, type)
{
	for(new i = 0; i < BONUS_MAX_TOKENS; i++)
	{
		if(IsValidToken(playerid, i) && TokenInfo[playerid][i][T:Type] == type)
			return i;
	}
	
	return NINCS;
}

function P:GetActorID(actor)
{
	if(actor == BONUS_ACTOR_ONE)
		return bActorOne;
	else if(actor == BONUS_ACTOR_TWO)
		return bActorTwo;
	
	return INVALID_ACTOR_ID;
}

function P:GetActorName(actor)
{
	new str[32];
	if(actor == BONUS_ACTOR_ONE)
		strcat(str, BONUS_ACTOR_ONE_NAME);
	else if(actor == BONUS_ACTOR_TWO)
		strcat(str, BONUS_ACTOR_TWO_NAME);
		
	return str;
}

function P:LadaObject(actor, bool:show)
{
	if(show)
	{
		P:LadaObject(actor, false);
		switch(actor)
		{
			case BONUS_ACTOR_ONE:
				bActorOneObject = CreateDynamicObject(BONUS_OBJECT_BOX_ONE_MODEL, BONUS_OBJECT_BOX_ONE_X, BONUS_OBJECT_BOX_ONE_Y, BONUS_OBJECT_BOX_ONE_Z, 0.0, 0.0, 0.0, BONUS_OBJECT_BOX_ONE_VW);
			
			case BONUS_ACTOR_TWO:
				bActorTwoObject = CreateDynamicObject(BONUS_OBJECT_BOX_TWO_MODEL, BONUS_OBJECT_BOX_TWO_X, BONUS_OBJECT_BOX_TWO_Y, BONUS_OBJECT_BOX_TWO_Z, 0.0, 0.0, 0.0, BONUS_OBJECT_BOX_TWO_VW);
		}
	}
	else
	{
		switch(actor)
		{
			case BONUS_ACTOR_ONE:
			{
				if(bActorOneObject != INVALID_OBJECT_ID)
				{
					DestroyDynamicObject(bActorOneObject);
					bActorOneObject = INVALID_OBJECT_ID;
				}
			}
			
			case BONUS_ACTOR_TWO:
			{
				if(bActorTwoObject != INVALID_OBJECT_ID)
				{
					DestroyDynamicObject(bActorTwoObject);
					bActorTwoObject = INVALID_OBJECT_ID;
				}
			}
		}
	}
}

function P:Interpolate(playerid, actor)
{
	switch(actor)
	{
		case BONUS_ACTOR_ONE:
		{
			InterpolateCameraPos(playerid, BONUS_CAMERA_ONE_POS_FX, BONUS_CAMERA_ONE_POS_FY, BONUS_CAMERA_ONE_POS_FZ, BONUS_CAMERA_ONE_POS_TX, BONUS_CAMERA_ONE_POS_TY, BONUS_CAMERA_ONE_POS_TZ, BONUS_CAMERA_ONE_POS_SPEED);
			InterpolateCameraLookAt(playerid, BONUS_CAMERA_ONE_AT_FX, BONUS_CAMERA_ONE_AT_FY, BONUS_CAMERA_ONE_AT_FZ, BONUS_CAMERA_ONE_AT_TX, BONUS_CAMERA_ONE_AT_TY, BONUS_CAMERA_ONE_AT_TZ, BONUS_CAMERA_ONE_AT_SPEED);
		}
		
		case BONUS_ACTOR_TWO:
		{
			InterpolateCameraPos(playerid, BONUS_CAMERA_TWO_POS_FX, BONUS_CAMERA_TWO_POS_FY, BONUS_CAMERA_TWO_POS_FZ, BONUS_CAMERA_TWO_POS_TX, BONUS_CAMERA_TWO_POS_TY, BONUS_CAMERA_TWO_POS_TZ, BONUS_CAMERA_TWO_POS_SPEED);
			InterpolateCameraLookAt(playerid, BONUS_CAMERA_TWO_AT_FX, BONUS_CAMERA_TWO_AT_FY, BONUS_CAMERA_TWO_AT_FZ, BONUS_CAMERA_TWO_AT_TX, BONUS_CAMERA_TWO_AT_TY, BONUS_CAMERA_TWO_AT_TZ, BONUS_CAMERA_TWO_AT_SPEED);
		}
	}
}

function P:ResetActor(actor)
{
	P:ActorPlayer(actor, INVALID_PLAYER_ID);
	P:ActorStatus(actor, 0);
	P:ActorLastAction(actor, 0);
	P:LadaObject(actor, false);
	P:KillActorTimer(actor);
}

function P:ResetPlayer(playerid)
{
	bOpenPhase[playerid] = 0;
	bOpenPhaseWorking[playerid] = false;
	bTalkWith[playerid] = 0;
	HideDialog(playerid);
	P:DestroyTextdraws(playerid);
}

function P:KillActorTimer(actor)
{
	KillTimer(P:ActorOpenTimer(actor));
}

function CheckCrateAndKey(playerid)
{
	if(CountUnusedTokens(playerid) < 1) 
	{
		Msg(playerid, "Nincs egy ládád sem");
		return 0;
	}
	
	if(PlayerInfo[playerid][pLadaKulcs] < 1)
	{
		Msg(playerid, "A láda kinyitásához kulcs szükséges");
		return 0;
	}
	
	return 1;
}

function P:ActorOpenTimer(actor, set = NINCS)
{
	if(actor == BONUS_ACTOR_ONE)
	{
		if(set != NINCS)
			bActorOneOpenTimer = set;
		else
			return bActorOneOpenTimer;
	}
	
	else if(actor == BONUS_ACTOR_TWO)
	{
		if(set != NINCS)
			bActorTwoOpenTimer = set;
		else
			return bActorTwoOpenTimer;
	}
	
	return 1;
}

function P:ActorPlayer(actor, set = NINCS)
{
	if(actor == BONUS_ACTOR_ONE)
	{
		if(set != NINCS)
			bActorOnePlayer = set;
		else
			return bActorOnePlayer;
	}
	
	else if(actor == BONUS_ACTOR_TWO)
	{
		if(set != NINCS)
			bActorTwoPlayer = set;
		else
			return bActorTwoPlayer;
	}
	
	return 1;
}

function P:ActorStatus(actor, set = NINCS)
{
	if(actor == BONUS_ACTOR_ONE)
	{
		if(set != NINCS)
			bActorOneStatus = set;
		else
			return bActorOneStatus;
	}
	
	else if(actor == BONUS_ACTOR_TWO)
	{
		if(set != 0)
			bActorTwoStatus = set;
		else
			return bActorTwoStatus;
	}
	
	return 1;
}

function P:ActorLastAction(actor, set = NINCS)
{
	if(actor == BONUS_ACTOR_ONE)
	{
		if(set != NINCS)
			bActorOneLastAction = set;
		else
			return bActorOneLastAction;
	}
	
	else if(actor == BONUS_ACTOR_TWO)
	{
		if(set != NINCS)
			bActorTwoLastAction = set;
		else
			return bActorTwoLastAction;
	}
	
	return 1;
}

function P:ResetVariables(playerid)
{
	BonusInfo[playerid][B:Kamat] = 0;
	BonusInfo[playerid][B:KamatIdo] = 0;
	BonusInfo[playerid][B:Ado] = 0;
	BonusInfo[playerid][B:AdoIdo] = 0;
}