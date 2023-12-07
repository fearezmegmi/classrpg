#if defined __game_system_system_clothes
	#endinput
#endif
#define __game_system_system_clothes

#define MAX_SKIN 			(312)
#define MAX_FRAKCIO_SKIN 	16

#define RUHA_ARA	30000

// frakció
new LeaderSkinek[MAX_FRAKCIO][2];
new Skinek[MAX_FRAKCIO][MAX_FRAKCIO_SKIN];
new PoliceSkinek[MAX_POLICE_CLASS][MAX_FRAKCIO_SKIN];
new PoliceKocsik[MAX_POLICE_CLASS][MAX_FRAKCIO_SKIN];

// skin type
#define SKIN_DATA_VALID			(0)
#define SKIN_DATA_INVALID		(1)
#define SKIN_DATA_PLAYER		(2)
#define SKIN_DATA_FRACTION		(4)
#define SKIN_DATA_JOB			(8)
new SkinData[MAX_SKIN], SkinOwner[MAX_SKIN];

#define T true
new bool:SkinMale[MAX_SKIN] =
{
				   /*0*/  /*1*/  /*2*/  /*3*/  /*4*/  /*5*/  /*6*/  /*7*/  /*8*/  /*9*/ /*10*/ /*11*/ /*12*/ /*13*/ /*14*/ /*15*/ /*16*/ /*17*/ /*18*/ /*19*/
	/*   0- 19 */  true,  true,  true,  true,  true,  true,  true,  true,  true, false, false, false, false, false,  true,  true,  true,  true,  true,  true,
	/*  20- 39 */  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true, false,  true,  true,  true,  true,  true,  true, false, false,
	/*  40- 59 */ false, false,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true, false, false, false, false,  true,  true,  true,
	/*  60- 79 */  true,  true,  true, false, false, false,  true,  true,  true, false,  true,  true,  true,  true, T/**/, false, false, false,  true,  true,
	/*  80- 99 */  true,  true,  true,  true,  true, false,  true, false, false, false, false, false, false, false,  true,  true,  true,  true,  true,  true,
	/* 100-119 */  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,
	/* 120-139 */  true,  true,  true,  true,  true,  true,  true,  true,  true, false, false, false,  true,  true,  true,  true,  true,  true, false, false,
	/* 140-159 */ false, false,  true,  true,  true, false,  true,  true, false,  true, false, false, false,  true,  true,  true,  true, false,  true,  true,
	/* 160-179 */  true,  true,  true,  true,  true,  true,  true,  true,  true, false,  true,  true, false,  true,  true,  true,  true,  true, false,  true,
	/* 180-199 */  true,  true,  true,  true,  true,  true,  true,  true,  true,  true, false, false, false, false, false, false, false, false, false, false,
	/* 200-219 */  true, false,  true,  true,  true, false,  true, false,  true,  true,  true, false,  true,  true, false, false, false,  true, false, false,
	/* 220-239 */  true,  true,  true,  true, false, false, false,  true,  true,  true,  true, false, false, false,  true,  true,  true, false, false,  true,
	/* 240-259 */  true,  true,  true, false, false, false, false,  true,  true,  true,  true, false,  true,  true,  true,  true, false, false,  true,  true,
	/* 260-279 */  true,  true,  true, false,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,
	/* 280-299 */  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true, false,  true,
	/* 300-311 */  true,  true,  true,  true,  true,  true,  false,  false,  false,  false,  true,  true
};
#undef T

stock PlayerCanUseSkinByProtection(playerid, skin)
	return (SkinData[skin] ^ SKIN_DATA_PLAYER || SkinData[skin] & SKIN_DATA_PLAYER && SkinOwner[skin] == PlayerInfo[playerid][pID]) ? 1 : 0;

stock bool:PlayerCanUseSkinBySex(playerid, skin)
	return (PlayerInfo[playerid][pSex] == 1 && SkinMale[skin] || PlayerInfo[playerid][pSex] == 2 && !SkinMale[skin]);

stock bool:IsValidSkin(skin)
	return (1 <= skin < MAX_SKIN && skin != 74);

stock SkinDataRecalculate()
{
	for(new i = 1; i < MAX_SKIN; i++)
		SkinData[i] = 0, SkinOwner[i] = 0;
	
	for(new f = 1; f < MAX_FRAKCIO; f++)
	{
		for(new s = 0; s < MAX_FRAKCIO_SKIN; s++)
		{
			new skin = Skinek[f-1][s];
			if(IsValidSkin(skin))
				SkinData[skin] = SKIN_DATA_FRACTION;
			
			if(s <= 1 && IsValidSkin(LeaderSkinek[f][s]))
				SkinData[ LeaderSkinek[f][s] ] = SKIN_DATA_FRACTION;
		}
	}
	
	// Invalid skins
	SkinData[0] = SKIN_DATA_INVALID;
	SkinData[74] = SKIN_DATA_INVALID;
	
	// Protected
	SkinData[50]  = SKIN_DATA_JOB;			// Szerelõ
	SkinData[69]  = SKIN_DATA_JOB;			// Szerelõ nõi
	SkinData[262] = SKIN_DATA_FRACTION;		// SWAT vagy NAV
	SkinData[285] = SKIN_DATA_FRACTION;		// SWAT vagy NAV
	
	// Védett skinek
	SkinData[33]  = -6876;		// Denaro
	//SkinData[47]  = -8177822; 	// Nick
	//SkinData[48]  = -4038; 		// Franklin
	//SkinData[76]  = -8175074;   // Lily
	//SkinData[94]  = -6122; 		// John
	SkinData[149] = -8183335;		// Dominic
	SkinData[217] = -666; 		// Clint
	SkinData[289] = -234; 		// Terno
	//SkinData[299] = -5637; 		// Dolph
	//SkinData[299] = -1; 		// Jim

	
	for(new i = 1; i < MAX_SKIN; i++)
	{
		if(SkinData[i] < 0)
		{
			SkinOwner[i] = SkinData[i] * -1;
			SkinData[i] = SKIN_DATA_PLAYER;
		}
	}
}

#define MSELECTOR_CLOTHES_CIVIL_SHOP		(1)
#define MSELECTOR_CLOTHES_FRACTION_SHOP		(2)
#define MSELECTOR_CLOTHES_FRACTION			(3)
#define MSELECTOR_CLOTHES_POLICE_SHOP_1			(4)
#define MSELECTOR_CLOTHES_POLICE_SHOP_2			(5)
#define MSELECTOR_CLOTHES_POLICE_SHOP_3			(6)

stock ShowPlayerModelSelector(playerid, type)
{
	if(type == MSELECTOR_CLOTHES_CIVIL_SHOP)
	{
		new db, skins[MAX_SKIN];
		for(new i = 0; i < MAX_SKIN; i++)
		{
			if(!SkinData[i] && PlayerCanUseSkinBySex(playerid, i))
			{
				skins[db] = i;
				db++;
			}
		}
		
		if(!db)
			return 0;
			
		ShowModelSelectionMenuEx(playerid, skins, db, "Ruhabolt", MSELECTOR_CLOTHES_CIVIL_SHOP, 0.0, 0.0, 0.0, 0.9);
		return 1;
	}
	else if(type == MSELECTOR_CLOTHES_FRACTION_SHOP || type == MSELECTOR_CLOTHES_FRACTION)
	{
		new frakcio = PlayerInfo[playerid][pMember];
			
		new db, skins[MAX_FRAKCIO_SKIN];
		for(new i = 0; i < MAX_FRAKCIO_SKIN; i++)
		{
			if(Skinek[frakcio-1][i] && IsValidSkin(Skinek[frakcio-1][i]))
			{
				skins[db] = Skinek[frakcio-1][i];
				db++;
			}
		}
		
		if(!db)
			return 0;
			
		ShowModelSelectionMenuEx(playerid, skins, db, (type == MSELECTOR_CLOTHES_FRACTION_SHOP) ? ("Ruhabolt") : ("Ruha"), type, 0.0, 0.0, 0.0, 0.9);
		return 1;
	}
	else if(type == MSELECTOR_CLOTHES_POLICE_SHOP_1 || type == MSELECTOR_CLOTHES_POLICE_SHOP_2 || type == MSELECTOR_CLOTHES_POLICE_SHOP_3)
	{
			
		new db, skins[MAX_FRAKCIO_SKIN], alosztaly;
		
		switch(type)
		{
			case MSELECTOR_CLOTHES_POLICE_SHOP_1: alosztaly = 0;
			case MSELECTOR_CLOTHES_POLICE_SHOP_2: alosztaly = 1;
			case MSELECTOR_CLOTHES_POLICE_SHOP_3: alosztaly = 2;
		}
		
		for(new i = 0; i < MAX_FRAKCIO_SKIN; i++)
		{
			if(PoliceSkinek[alosztaly][i] && IsValidSkin(PoliceSkinek[alosztaly][i]))
			{
				skins[db] = PoliceSkinek[alosztaly][i];
				db++;
			}
		}
		
		if(!db)
			return 0;
			
		ShowModelSelectionMenuEx(playerid, skins, db, "Ruha", type, 0.0, 0.0, 0.0, 0.9);
		return 1;
	}
	
	return 0;
}

public OnPlayerModelSelectionEx(playerid, response, extraid, modelid)
{
    if(extraid == MSELECTOR_CLOTHES_CIVIL_SHOP)
    {
		if(!response)
			return 0;
		
		if(BankkartyaFizet(playerid, RUHA_ARA))
		{
			BizPenz(BIZ_RUHA, RUHA_ARA);
			BizUpdate(BIZ_RUHA, BIZ_Till);
			PlayerInfo[playerid][pModel] = modelid;
			SetPlayerSkin(playerid, modelid);
			
			Cselekves(playerid, "vett egy ruhát");
			Msg(playerid, "Új ruhát vettél");
		}
		else
			Msg(playerid, "Nincs rá pénzed, egy ruha ára "#RUHA_ARA"Ft");
    }
	else if(extraid == MSELECTOR_CLOTHES_FRACTION_SHOP)
    {
		if(!response)
			return 0;
		
		if(BankkartyaFizet(playerid, RUHA_ARA))
		{
			BizPenz(BIZ_RUHA, RUHA_ARA);
			BizUpdate(BIZ_RUHA, BIZ_Till);
			PlayerInfo[playerid][pChar] = modelid;
			SetPlayerSkin(playerid, modelid);
			
			Cselekves(playerid, "vett egy ruhát");
			Msg(playerid, "Új ruhát vettél");
		}
		else
			Msg(playerid, "Nincs rá pénzed, egy ruha ára "#RUHA_ARA"Ft");
    }
	else if(extraid == MSELECTOR_CLOTHES_FRACTION)
    {
		if(!response)
			return 0;
		
		PlayerInfo[playerid][pChar] = modelid;
		SetPlayerSkin(playerid, modelid);
		
		Cselekves(playerid, "kiválasztotta a frakció ruháját");
		Msg(playerid, "Kiválasztottad a frakció ruhádat");
    }
	else if(extraid == MSELECTOR_CLOTHES_POLICE_SHOP_1 || extraid == MSELECTOR_CLOTHES_POLICE_SHOP_2 || extraid == MSELECTOR_CLOTHES_POLICE_SHOP_3)
    {
		if(!response)
			return 0;
		
		if(BankkartyaFizet(playerid, RUHA_ARA))
		{
			BizPenz(BIZ_RUHA, RUHA_ARA);
			BizUpdate(BIZ_RUHA, BIZ_Till);
			switch(extraid)
			{
				case MSELECTOR_CLOTHES_POLICE_SHOP_1: PlayerInfo[playerid][pPoliceRuha][0] = modelid;
				case MSELECTOR_CLOTHES_POLICE_SHOP_2: PlayerInfo[playerid][pPoliceRuha][1] = modelid;
				case MSELECTOR_CLOTHES_POLICE_SHOP_3: PlayerInfo[playerid][pPoliceRuha][2] = modelid;
			}
			SetPlayerSkin(playerid, modelid);
			
			Cselekves(playerid, "vett egy ruhát");
			Msg(playerid, "Új ruhát vettél");
		}
		else
			Msg(playerid, "Nincs rá pénzed, egy ruha ára "#RUHA_ARA"Ft");
    }
    return 1;
}

ALIAS(clothes):ruha;
CMD:ruha(playerid, params[])
{
	if(!IsAtClothShop(playerid))
		return SendClientMessage(playerid, COLOR_GRAD2, "Nem vagy ruhaboltban!");
	
	new skin, subcmd[32];
	if(!sscanf(params, "d", skin)) // civil skin
	{
		if(skin < 1 || skin >= MAX_SKIN || skin == 74)
			return Msg(playerid, "Hibás skin");
		
		if(SkinData[skin] & SKIN_DATA_FRACTION || PlayerInfo[playerid][pMember] > 0 && !LegalisFrakcio(PlayerInfo[playerid][pMember]))
			return Msg(playerid, "Frakció ruha vásárlásához használd az \"/ruha frakció\" parancsot (idézõjelek nélkül)");
		
		if(!PlayerCanUseSkinByProtection(playerid, skin))
			return Msg(playerid, "Ezt a skint nem veheted fel");
		
		if(!PlayerCanUseSkinBySex(playerid, skin))
			return Msg(playerid, PlayerInfo[playerid][pSex] == 1 ? ("Miért vennél fel nõi skint, ha férfi vagy?") : ("Miért vennél fel férfi skint, ha nõ vagy?"));
		
		if(SkinData[skin] & SKIN_DATA_JOB)
			return Msg(playerid, "Itt nem lehet munka ruhát venni");
			
		if(BankkartyaFizet(playerid, 30000))
		{
			BizPenz(BIZ_RUHA, 30000);
			BizUpdate(BIZ_RUHA, BIZ_Till);
			PlayerInfo[playerid][pModel] = skin;
			SetPlayerSkin(playerid, skin);
			
			Cselekves(playerid, "vett egy ruhát");
			Msg(playerid, "Új ruhát vettél");
		}
		else
			Msg(playerid, "A ruha ára "#RUHA_ARA"Ft");
	}
	else if(!sscanf(params, "s[32]", subcmd))
	{
		if(egyezik(subcmd, "frakció") || egyezik(subcmd, "frakcio"))
		{
			if(PlayerInfo[playerid][pMember] < 1)
				return Msg(playerid, "Nem vagy frakció tagja");

			if(!ShowPlayerModelSelector(playerid, MSELECTOR_CLOTHES_FRACTION_SHOP))
				return Msg(playerid, "A frakciótoknak nincs egy ruhája sem");
		}
		else if(egyezik(subcmd, "police"))
		{
			if(!PoliceAlosztalyban(playerid))
				return Msg(playerid, "Nem vagy alosztály tagja");
				
			if(PlayerInfo[playerid][pPoliceAlosztalyFo] <= 0)
				return Msg(playerid, "Nem állítottál be fõ alosztályt!");
				
			switch(PlayerInfo[playerid][pPoliceAlosztalyFo])
			{
				case 1:
				{
					if(!ShowPlayerModelSelector(playerid, MSELECTOR_CLOTHES_POLICE_SHOP_1))
						return Msg(playerid, "Az alosztálynak nincs egy ruhája sem");
				}
				case 2:
				{
					if(!ShowPlayerModelSelector(playerid, MSELECTOR_CLOTHES_POLICE_SHOP_2))
						return Msg(playerid, "Az alosztálynak nincs egy ruhája sem");
				}
				case 3:
				{
					if(!ShowPlayerModelSelector(playerid, MSELECTOR_CLOTHES_POLICE_SHOP_3))
						return Msg(playerid, "Az alosztálynak nincs egy ruhája sem");
				}				
				default: return 1;
			}
			
		}
		else if(egyezik(subcmd, "leader"))
		{
			if(PlayerInfo[playerid][pLeader] < 1)
				return Msg(playerid, "Nem vagy frakció tagja");
			
			if(BankkartyaFizet(playerid, 30000))
			{
				new leader = PlayerInfo[playerid][pLeader];
				
				BizPenz(BIZ_RUHA, 30000);
				BizUpdate(BIZ_RUHA, BIZ_Till);
				PlayerInfo[playerid][pChar] = (PlayerInfo[playerid][pSex] == 2) ? LeaderSkinek[leader-1][1] : LeaderSkinek[leader-1][0];
				SetPlayerSkin(playerid, PlayerInfo[playerid][pChar]);
				
				Cselekves(playerid, "vett egy ruhát");
				Msg(playerid, "Új ruhát vettél");
			}
			else
				Msg(playerid, "A ruha ára "#RUHA_ARA"Ft");
		}
	}
	else
	{
		if(PlayerInfo[playerid][pMember] > 0 && !LegalisFrakcio(PlayerInfo[playerid][pMember]))
			return Msg(playerid, "Frakció ruha vásárlásához használd az \"/ruha frakció\" parancsot (idézõjelek nélkül)");
		if(!ShowPlayerModelSelector(playerid, MSELECTOR_CLOTHES_CIVIL_SHOP))
			return Msg(playerid, "Nincs egy civil ruha sem");
	}
	
	return 1;
}