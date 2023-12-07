// ######################################### //
//    G L O B A L   -   V A R I A B L E S    //
// ######################################### //

enum tokenInfo
{
	TokenValid,
	TokenID,
	TokenType,
	TokenUseType
}

new TokenInfo[MAX_PLAYERS][BONUS_MAX_TOKENS][tokenInfo];

enum crateKeyInfo
{
	Float:CrateKeyPos[3],
	CrateKeyVW,
	CrateKeyMapID,
	CrateKeyObjectID,
	bool:CrateKeyActive
}

new CrateKeyInfo[MAX_CRATE_KEYS][crateKeyInfo];
new bool:LadaKulcsMutat[MAX_PLAYERS];

enum bonusInfo
{
	Float:BonusKamat,
	BonusKamatIdo,
	Float:BonusAdo,
	BonusAdoIdo
}

new BonusInfo[MAX_PLAYERS][bonusInfo];

// ####################################### //
//    L O C A L   -   V A R I A B L E S    //
// ####################################### //

// actor one
new bActorOne;
new bActorOnePlayer = INVALID_PLAYER_ID;
new bActorOneStatus;
new bActorOneLastAction;
new bActorOneObject = INVALID_OBJECT_ID;
new bActorOneOpenTimer;

// actor two
new bActorTwo;
new bActorTwoPlayer = INVALID_PLAYER_ID;
new bActorTwoStatus;
new bActorTwoLastAction;
new bActorTwoObject = INVALID_OBJECT_ID;
new bActorTwoOpenTimer;

// areas
new bAreaOutsideEnter;
new bAreaLevelOneExit;
new bAreaLevelOnePass;
new bAreaLevelTwoExit;
new bAreaTalkOne;
new bAreaTalkTwo;

// dialogs
new bDialogStatus[MAX_PLAYERS];
new bDialogRows[MAX_PLAYERS][BONUS_COUNT];
new bDialogSelected[MAX_PLAYERS];

// textdraws
new PlayerText:bTextOne[MAX_PLAYERS] = {PlayerText:INVALID_TEXT_DRAW, ...};
new PlayerText:bTextOneProgress[MAX_PLAYERS] = {PlayerText:INVALID_TEXT_DRAW, ...};
new PlayerText:bTextTwo[MAX_PLAYERS] = {PlayerText:INVALID_TEXT_DRAW, ...};
new PlayerText:bTextTwoProgress[MAX_PLAYERS] = {PlayerText:INVALID_TEXT_DRAW, ...};
new PlayerText:bTextThree[MAX_PLAYERS] = {PlayerText:INVALID_TEXT_DRAW, ...};
new PlayerText:bTextThreeProgress[MAX_PLAYERS] = {PlayerText:INVALID_TEXT_DRAW, ...};

// others
new bool:bAlreadyOpened[MAX_PLAYERS];
new bTalkWith[MAX_PLAYERS];
new bOpenPhase[MAX_PLAYERS];
new bool:bOpenPhaseWorking[MAX_PLAYERS];
