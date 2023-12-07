#if defined __game_system_system_donate
	#endinput
#endif
#define __game_system_system_donate

#include "system_donate.inc"

enum premiumInfo
{
	Float:pKamat,
	pKamatIdo,
	Float:pAdo,
	pAdoIdo
}
new PremiumInfo[MAX_PLAYERS][premiumInfo];

#define PREMIUM_KAMAT_IDO	15
#define PREMIUM_ADO_IDO		15

// prices - amount per kredit
new Float:Amount[DONATE_BUTTONS] =
{
	   0.00001,	// kredit
	5000.0    ,	// k�szp�nz
	   5.0    ,	// kokain
	   4.0    ,	// heroin
	   2.5    ,	// marihuana
	  30.0	  ,	// material
	   0.1	  ,	// b�rt�nid�
	   0.00002, // kamat
	   0.005  , // ad�
	   0.00125 // pr�miumpont
};
#define DONATE_PRICE_KREDIT_DB	9
new Float:Price_Kredit[DONATE_PRICE_KREDIT_DB][2] =
{
	{      100000.0, 1.000 },
	{      500000.0, 1.025 },
	{     1000000.0, 1.050 },
	{     5000000.0, 1.075 },
	{    10000000.0, 1.100 },
	{    50000000.0, 1.125 },
	{   100000000.0, 1.150 },
	{   500000000.0, 1.175 },
	{  1000000000.0, 1.200 }
};
#define DONATE_PRICE_DB		9
new Float:Price[DONATE_PRICE_DB][2] =
{
	{    10.0, 1.00 },
	{    50.0, 1.05 },
	{   100.0, 1.10 },
	{   500.0, 1.15 },
	{  1000.0, 1.20 },
	{  2500.0, 1.30 },
	{  5000.0, 1.50 },
	{  7500.0, 1.75 },
	{ 10000.0, 2.00 }
};
#define DONATE_PRICE_PREMIUMPONT_DB	10
new Float:Price_Premiumpont[DONATE_PRICE_PREMIUMPONT_DB][2] =
{
	{	800.0,  1.0	},	// 0% megtakar�t�s
	{	1580.0, 2.0	},	// 0,025% megtakar�t�s
	{	2360.0, 3.0	},	// 0,050% megtakar�t�s
	{	3140.0, 4.0	},	// 0,075% megtakar�t�s
	{	3920.0, 5.0	},	// 0,100% megtakar�t�s
	{	4700.0, 6.0	},	// 0,0125% megtakar�t�s
	{	5480.0, 7.0	},	// 0,0150% megtakar�t�s
	{	6260.0, 8.0	},	// 0,0175% megtakar�t�s
	{	7040.0, 9.0	},	// 0,200% megtakar�t�s
	{	7600.0, 10.0}	// 0,500% megtakar�t�s
};

#define DONATE_NO		0
#define DONATE_CONFIRM	1
#define DONATE_PICK 	2
#define DONATE_BUY		3

new
	D_DialogDonate[MAX_PLAYERS],
	D_DialogDonate_Phase[MAX_PLAYERS],
	D_DialogDonate_Item[MAX_PLAYERS],
	Float:D_DialogDonate_PriceMultiplier[MAX_PLAYERS]
;

stock ShowKreditPanel(playerid)
	return CallRemoteFunction("ShowKreditPanel", "ii", playerid, PlayerInfo[playerid][pKredit]);
	
stock UpdateKreditPanel(playerid)
	return CallRemoteFunction("UpdateKreditPanel", "ii", playerid, PlayerInfo[playerid][pKredit]);

stock GiveBonusKredit(playerid, kredit, source[], bool:me = false, bool:anonMe = false)
{
	if(playerid != -1)
		return 1;
	PlayerInfo[playerid][pKredit] += kredit;
	SendFormatMessage(playerid, COLOR_WHITE, "Kapt�l %ddb kreditet", kredit);
	tformat(256, "[kredit][%d]%s kapott %d b�nusz kreditet (%s)", playerid, PlayerName(playerid), kredit, source), Log("Egyeb", _tmpString);
	
	if(me)
		Cselekves(playerid, "b�nusz kreditet kapott", (anonMe ? 1 : 0), true);
		
	return 1;
}

forward OnPlayerPickDonateItem(playerid, type);
public OnPlayerPickDonateItem(playerid, type)
{
	D_DialogDonate[playerid] = type;
	D_DialogDonate_Phase[playerid] = DONATE_PICK;
	
	switch(type)
	{
		case DONATE_KAMAT:
		{
			if(PremiumInfo[playerid][pKamat] > 0 && PremiumInfo[playerid][pKamatIdo] > 0)
				D_DialogDonate_Phase[playerid] = DONATE_CONFIRM;
		}
		case DONATE_ADO:
		{
			if(PremiumInfo[playerid][pAdo] > 0 && PremiumInfo[playerid][pAdoIdo] > 0)
				D_DialogDonate_Phase[playerid] = DONATE_CONFIRM;
		}
	}
	
	ShowDialogDonate(playerid);
}

forward ShowDialogDonate(playerid);
public ShowDialogDonate(playerid)
{
	new type = D_DialogDonate[playerid], phase = D_DialogDonate_Phase[playerid];
	if(phase == DONATE_CONFIRM) switch(type)
	{
		case DONATE_KAMAT:
		{
			CustomDialog(playerid, D:donate, DIALOG_STYLE_MSGBOX, "Kamat", \
				"Jelenleg m�r van kamat b�nuszod.\nHa most tov�bbl�psz, fel�l�r�dik a jelenlegi b�nuszod.\n(Nem ad�dik hozz� a jelenlegi b�nuszodhoz a kamat �s id�)", \
				"Meg�rtettem", "Vissza");
		}
		case DONATE_ADO:
		{
			CustomDialog(playerid, D:donate, DIALOG_STYLE_MSGBOX, "Ad�", \
				"Jelenleg m�r van ad�cs�kkent�s b�nuszod.\nHa most tov�bbl�psz, fel�l�r�dik a jelenlegi b�nuszod.\n(Nem ad�dik hozz� a jelenlegi b�nuszodhoz az ad�cs�kkent�s �s id�)", \
				"Meg�rtettem", "Vissza");
		}
	}
	else if(phase == DONATE_PICK) switch(type)
	{
		case DONATE_KREDIT:
		{
			new str[512], cash, kredit, Float:bonus;
			for(new i = 0; i < DONATE_PRICE_KREDIT_DB; i++)
			{
				cash = floatround(Price_Kredit[i][0]);
				kredit = floatround(Price_Kredit[i][0] * Price_Kredit[i][1] * Amount[type]);
				bonus = (Price_Kredit[i][1] - 1.0) * 100 + FLOATFIX;
				
				if(str[0]) format(str, 512, "%s\n%sFt => %s kredit (+%.1f%%)", str, FormatInt(cash), FormatInt(kredit), bonus);
				else format(str, 512, "%sFt => %s kredit", FormatInt(cash), FormatFloat(kredit, 1));
			}
			
			CustomDialog(playerid, D:donate, DIALOG_STYLE_LIST, "Kredit", str, "Megveszem", "Vissza");
		}
		case DONATE_KESZPENZ:
		{
			new str[512], kredit, amount, bonus;
			for(new i = 0; i < DONATE_PRICE_DB; i++)
			{
				kredit = floatround(Price[i][0]);
				amount = floatround(Price[i][0] * Price[i][1] * Amount[type]);
				bonus = floatround((Price[i][1] - 1.0) * 100.0);
				
				if(str[0]) format(str, 512, "%s\n%s kredit => %sFt (+%d%%)", str, FormatInt(kredit), FormatInt(amount), bonus);
				else format(str, 512, "%s kredit => %sFt", FormatInt(kredit), FormatInt(amount));
			}
			
			CustomDialog(playerid, D:donate, DIALOG_STYLE_LIST, "K�szp�nz", str, "Megveszem", "Vissza");
		}
		case DONATE_KOKAIN:
		{
			new str[512], kredit, amount, bonus;
			for(new i = 0; i < DONATE_PRICE_DB; i++)
			{
				kredit = floatround(Price[i][0]);
				amount = floatround(Price[i][0] * Price[i][1] * Amount[type]);
				bonus = floatround((Price[i][1] - 1.0) * 100.0);
				
				if(str[0]) format(str, 512, "%s\n%s kredit => %sg kokain (+%d%%)", str, FormatInt(kredit), FormatInt(amount), bonus);
				else format(str, 512, "%s kredit => %sg kokain", FormatInt(kredit), FormatInt(amount));
			}
			
			CustomDialog(playerid, D:donate, DIALOG_STYLE_LIST, "Kokain", str, "Megveszem", "Vissza");
		}
		case DONATE_HEROIN:
		{
			new str[512], kredit, amount, bonus;
			for(new i = 0; i < DONATE_PRICE_DB; i++)
			{
				kredit = floatround(Price[i][0]);
				amount = floatround(Price[i][0] * Price[i][1] * Amount[type]);
				bonus = floatround((Price[i][1] - 1.0) * 100.0);
				
				if(str[0]) format(str, 512, "%s\n%s kredit => %sg heroin (+%d%%)", str, FormatInt(kredit), FormatInt(amount), bonus);
				else format(str, 512, "%s kredit => %sg heroin", FormatInt(kredit), FormatInt(amount));
			}
			
			CustomDialog(playerid, D:donate, DIALOG_STYLE_LIST, "Heroin", str, "Megveszem", "Vissza");
		}
		case DONATE_MARIHUANA:
		{
			new str[512], kredit, amount, bonus;
			for(new i = 0; i < DONATE_PRICE_DB; i++)
			{
				kredit = floatround(Price[i][0]);
				amount = floatround(Price[i][0] * Price[i][1] * Amount[type]);
				bonus = floatround((Price[i][1] - 1.0) * 100.0);
				
				if(str[0]) format(str, 512, "%s\n%s kredit => %sg marihuana (+%d%%)", str, FormatInt(kredit), FormatInt(amount), bonus);
				else format(str, 512, "%s kredit => %sg marihuana", FormatInt(kredit), FormatInt(amount));
			}
			
			CustomDialog(playerid, D:donate, DIALOG_STYLE_LIST, "Marihuana", str, "Megveszem", "Vissza");
		}
		case DONATE_MATERIAL:
		{
			new str[512], kredit, amount, bonus;
			for(new i = 0; i < DONATE_PRICE_DB; i++)
			{
				kredit = floatround(Price[i][0]);
				amount = floatround(Price[i][0] * Price[i][1] * Amount[type]);
				bonus = floatround((Price[i][1] - 1.0) * 100.0);
				
				if(str[0]) format(str, 512, "%s\n%s kredit => %sdb material (+%d%%)", str, FormatInt(kredit), FormatInt(amount), bonus);
				else format(str, 512, "%s kredit => %sdb material", FormatInt(kredit), FormatInt(amount));
			}
			
			CustomDialog(playerid, D:donate, DIALOG_STYLE_LIST, "Material", str, "Megveszem", "Vissza");
		}
		case DONATE_BORTONIDO:
		{
			new Float:szorzo;
			switch(PlayerInfo[playerid][pJailed])
			{
				case JAIL_LSPD, JAIL_NAV, JAIL_FBI, JAIL_FEGYENCTELEP:
					szorzo = 1.0;
				case JAIL_ADMIN:
					szorzo = 2.0;
				case JAIL_ADMIN2:
					szorzo = 4.0;
			}
			
			if(szorzo == 0)
			{
				D_DialogDonate_Phase[playerid] = DONATE_NO;
				CustomDialog(playerid, D:donate, DIALOG_STYLE_MSGBOX, "B�rt�nid�", "Jelenleg nem vagy b�rt�nben", "Vissza", "");
				return 1;
			}
			
			D_DialogDonate_PriceMultiplier[playerid] = szorzo;
			
			new str[512], kredit, amount, bonus;
			for(new i = 0; i < DONATE_PRICE_DB; i++)
			{
				kredit = floatround(Price[i][0] * szorzo);
				amount = floatround(Price[i][0] * Price[i][1] * Amount[type]);
				bonus = floatround((Price[i][1] - 1.0) * 100.0);
				
				if(str[0]) format(str, 512, "%s\n%s kredit => -%s perc (+%d%%)", str, FormatInt(kredit), FormatInt(amount), bonus);
				else format(str, 512, "%s kredit => -%s perc", FormatInt(kredit), FormatInt(amount));
			}
			
			CustomDialog(playerid, D:donate, DIALOG_STYLE_LIST, "B�rt�nid�", str, "Megveszem", "Vissza");
		}
		case DONATE_KAMAT:
		{
			new str[512], kredit, Float:amount, bonus;
			for(new i = 0; i < DONATE_PRICE_DB; i++)
			{
				kredit = floatround(Price[i][0]);
				amount = Price[i][0] * Price[i][1] * Amount[type] + FLOATFIX;
				bonus = floatround((Price[i][1] - 1.0) * 100.0);
				
				if(str[0]) format(str, 512, "%s\n%s kredit => +%s%% kamat (+%d%%) "#PREMIUM_KAMAT_IDO" fizet�sig", str, FormatInt(kredit), FormatFloat(amount, 5), bonus);
				else format(str, 512, "%s kredit => +%s%% kamat "#PREMIUM_KAMAT_IDO" fizet�sig", FormatInt(kredit), FormatFloat(amount, 5));
			}
			
			CustomDialog(playerid, D:donate, DIALOG_STYLE_LIST, "Kamat", str, "Megveszem", "Vissza");
		}
		case DONATE_ADO:
		{
			new str[512], kredit, Float:amount, bonus;
			for(new i = 0; i < DONATE_PRICE_DB; i++)
			{
				kredit = floatround(Price[i][0]);
				amount = Price[i][0] * Price[i][1] * Amount[type] + FLOATFIX;
				bonus = floatround((Price[i][1] - 1.0) * 100.0);
				
				if(str[0]) format(str, 512, "%s\n%s kredit => %s%% ad�cs�kkent�s (+%d%%) "#PREMIUM_ADO_IDO" fizet�sig", str, FormatInt(kredit), FormatFloat(amount, 5), bonus);
				else format(str, 512, "%s kredit => %s%% ad�cs�kkent�s "#PREMIUM_ADO_IDO" fizet�sig", FormatInt(kredit), FormatFloat(amount, 5));
			}
			
			CustomDialog(playerid, D:donate, DIALOG_STYLE_LIST, "Ad�", str, "Megveszem", "Vissza");
		}
		case DONATE_PREMIUMPONT:
		{
			new str[512], kredit, amount;
			for(new i = 0; i < DONATE_PRICE_PREMIUMPONT_DB; i++)
			{
				kredit = floatround(Price_Premiumpont[i][0]);
				amount = floatround(Price_Premiumpont[i][1]);
				
				if(str[0]) format(str, 512, "%s\n%s kredit => %sdb pr�miumpont", str, FormatInt(kredit), FormatInt(amount));
				else format(str, 512, "%s kredit => %sdb pr�miumpont", FormatInt(kredit), FormatInt(amount));
			}
			
			CustomDialog(playerid, D:donate, DIALOG_STYLE_LIST, "Pr�miumpont", str, "Megveszem", "Vissza");
		}
	}
	
	return 1;
}

Dialog:donate(playerid, response, listitem, inputtext[])
{
	printf("dialog_donate(%d,%d,%d,%s)", playerid, response, listitem, inputtext);
	new	type = D_DialogDonate[playerid], phase = D_DialogDonate_Phase[playerid];
	if(phase == DONATE_NO)
		ShowKreditPanel(playerid);
	else if(phase == DONATE_CONFIRM)
	{
		if(!response)
		{
			ShowKreditPanel(playerid);
			return 1;
		}
		
		D_DialogDonate_Phase[playerid] = DONATE_PICK;
		ShowDialogDonate(playerid);
	}
	else if(phase == DONATE_PICK)
	{
		if(!response)
		{
			ShowKreditPanel(playerid);
			return 1;
		}
		
		switch(type)
		{
			case DONATE_KREDIT, DONATE_KESZPENZ, DONATE_KOKAIN, DONATE_HEROIN, DONATE_MARIHUANA, DONATE_MATERIAL,
					DONATE_BORTONIDO, DONATE_KAMAT, DONATE_ADO, DONATE_PREMIUMPONT:
			{
				new Float:price, Float:amount;
				
				if(type == DONATE_KREDIT)
				{
					price = Price_Kredit[listitem][0];
					amount = Price_Kredit[listitem][0] * Price_Kredit[listitem][1] * Amount[type];
				}
				else if(type == DONATE_PREMIUMPONT)
				{
					price = Price_Premiumpont[listitem][0];
					amount = Price_Premiumpont[listitem][1];
				}
				else
				{
					price = Price[listitem][0];
					amount = Price[listitem][0] * Price[listitem][1] * Amount[type];
				}
				
				if(type == DONATE_BORTONIDO)
					price *= D_DialogDonate_PriceMultiplier[playerid];
					
				amount += FLOATFIX;
				
				D_DialogDonate_Item[playerid] = listitem;
				OnPlayerBuyPremiumStuff(playerid, type, floatround(price), amount);
			}
		}
	}
	else if(D_DialogDonate_Phase[playerid] == DONATE_BUY)
	{
		if(!response)
		{
			ShowKreditPanel(playerid);
			return 1;
		}
		
		switch(type)
		{
			case DONATE_KAMAT, DONATE_ADO:
			{
				ShowKreditPanel(playerid);
				return 1;
			}
		}
		
		D_DialogDonate_Phase[playerid] = DONATE_PICK;
		ShowDialogDonate(playerid);
	}
	
	return 1;
}

forward OnPlayerBuyPremiumStuff(playerid, type, price, Float:amountFlt);
public OnPlayerBuyPremiumStuff(playerid, type, price, Float:amountFlt)
{
	if(type != DONATE_KREDIT && PlayerInfo[playerid][pKredit] < price)
	{
		CustomDialog(playerid, D:donate, DIALOG_STYLE_MSGBOX, "Kredit", "Nincs ennyi kredited", "Vissza", "Befejez�s");
		return 0;
	}
	else if(type == DONATE_KREDIT && !BankkartyaFizet(playerid, price, false))
	{
		CustomDialog(playerid, D:donate, DIALOG_STYLE_MSGBOX, "Kredit", "Nincs ennyi p�nzed", "Vissza", "Befejez�s");
		return 0;
	}
	
	new amount = floatround(amountFlt);
	
	switch(type)
	{
		case DONATE_KREDIT:
			OnPlayerBuyKredit(playerid, price, amount);
		case DONATE_KESZPENZ:
			OnPlayerBuyKeszpenz(playerid, price, amount);
		case DONATE_KOKAIN:
			OnPlayerBuyKokain(playerid, price, amount);
		case DONATE_HEROIN:
			OnPlayerBuyHeroin(playerid, price, amount);
		case DONATE_MARIHUANA:
			OnPlayerBuyMarihuana(playerid, price, amount);
		case DONATE_MATERIAL:
			OnPlayerBuyMaterial(playerid, price, amount);
		case DONATE_BORTONIDO:
			OnPlayerBuyBortonido(playerid, price, amount);
		case DONATE_KAMAT:
			OnPlayerBuyKamat(playerid, price, amountFlt);
		case DONATE_ADO:
			OnPlayerBuyAdo(playerid, price, amountFlt);
		case DONATE_PREMIUMPONT:
			OnPlayerBuyPremiumpont(playerid, price, amount);
	}
	return 0;
}

fpublic OnPlayerBuyKredit(playerid, price, amount)
{
	BankkartyaFizet(playerid, price);
	PlayerInfo[playerid][pKredit] += amount;
	UpdateKreditPanel(playerid);
	
	tformat(256, "[kredit][%d]%s vett %d kreditet %dFt�rt", playerid, PlayerName(playerid), amount, price), Log("Egyeb", _tmpString);
	tformat(128, "Megvett�l %d kreditet %dFt�rt", amount, price);
	
	D_DialogDonate_Phase[playerid] = DONATE_BUY;
	CustomDialog(playerid, D:donate, DIALOG_STYLE_MSGBOX, "V�s�rl�s", _tmpString, "Vissza", "Befejez�s");
}

fpublic OnPlayerBuyKeszpenz(playerid, price, amount)
{
	PlayerInfo[playerid][pKredit] -= price;
	GiveMoney(playerid, amount);
	UpdateKreditPanel(playerid);
	
	tformat(256, "[kredit][%d]%s bev�ltott %d kreditet %dFt�rt", playerid, PlayerName(playerid), price, amount), Log("Egyeb", _tmpString);
	tformat(128, "Bev�ltott�l %d kreditet %dFt�rt", price, amount);
	
	D_DialogDonate_Phase[playerid] = DONATE_BUY;
	CustomDialog(playerid, D:donate, DIALOG_STYLE_MSGBOX, "V�s�rl�s", _tmpString, "Vissza", "Befejez�s");
}

fpublic OnPlayerBuyKokain(playerid, price, amount)
{
	PlayerInfo[playerid][pKredit] -= price;
	PlayerInfo[playerid][pKokain] += amount;
	UpdateKreditPanel(playerid);
	
	tformat(256, "[kredit][%d]%s bev�ltott %d kreditet %dg kokain�rt", playerid, PlayerName(playerid), price, amount), Log("Egyeb", _tmpString);
	tformat(128, "Bev�ltott�l %d kreditet %dg kokain�rt", price, amount);
	
	D_DialogDonate_Phase[playerid] = DONATE_BUY;
	CustomDialog(playerid, D:donate, DIALOG_STYLE_MSGBOX, "V�s�rl�s", _tmpString, "Vissza", "Befejez�s");
}

fpublic OnPlayerBuyHeroin(playerid, price, amount)
{
	PlayerInfo[playerid][pKredit] -= price;
	PlayerInfo[playerid][pHeroin] += amount;
	UpdateKreditPanel(playerid);
	
	tformat(256, "[kredit][%d]%s bev�ltott %d kreditet %dg heroin�rt", playerid, PlayerName(playerid), price, amount), Log("Egyeb", _tmpString);
	tformat(128, "Bev�ltott�l %d kreditet %dg heroin�rt", price, amount);
	
	D_DialogDonate_Phase[playerid] = DONATE_BUY;
	CustomDialog(playerid, D:donate, DIALOG_STYLE_MSGBOX, "V�s�rl�s", _tmpString, "Vissza", "Befejez�s");
}

fpublic OnPlayerBuyMarihuana(playerid, price, amount)
{
	PlayerInfo[playerid][pKredit] -= price;
	PlayerInfo[playerid][pMarihuana] += amount;
	UpdateKreditPanel(playerid);
	
	tformat(256, "[kredit][%d]%s bev�ltott %d kreditet %dg marihuana�rt", playerid, PlayerName(playerid), price, amount), Log("Egyeb", _tmpString);
	tformat(128, "Bev�ltott�l %d kreditet %dg marihuana�rt", price, amount);
	
	D_DialogDonate_Phase[playerid] = DONATE_BUY;
	CustomDialog(playerid, D:donate, DIALOG_STYLE_MSGBOX, "V�s�rl�s", _tmpString, "Vissza", "Befejez�s");
}

fpublic OnPlayerBuyMaterial(playerid, price, amount)
{
	PlayerInfo[playerid][pKredit] -= price;
	PlayerInfo[playerid][pMats] += amount;
	UpdateKreditPanel(playerid);
	
	tformat(256, "[kredit][%d]%s bev�ltott %d kreditet %ddb material�rt", playerid, PlayerName(playerid), price, amount), Log("Egyeb", _tmpString);
	tformat(128, "Bev�ltott�l %d kreditet %ddb material�rt", price, amount);
	
	D_DialogDonate_Phase[playerid] = DONATE_BUY;
	CustomDialog(playerid, D:donate, DIALOG_STYLE_MSGBOX, "V�s�rl�s", _tmpString, "Vissza", "Befejez�s");
}

fpublic OnPlayerBuyBortonido(playerid, price, amount)
{
	PlayerInfo[playerid][pKredit] -= price;
	PlayerInfo[playerid][pJailTime] = max(1, PlayerInfo[playerid][pJailTime] - amount * 60);
	UpdateKreditPanel(playerid);
	
	tformat(256, "[kredit][%d]%s bev�ltott %d kreditet -%d perc b�rt�nid��rt", playerid, PlayerName(playerid), price, amount), Log("Egyeb", _tmpString);
	tformat(128, "Bev�ltott�l %d kreditet -%d perc b�rt�nid��rt", price, amount);
	
	D_DialogDonate_Phase[playerid] = DONATE_BUY;
	CustomDialog(playerid, D:donate, DIALOG_STYLE_MSGBOX, "V�s�rl�s", _tmpString, "Vissza", "Befejez�s");
}

fpublic OnPlayerBuyKamat(playerid, price, Float:amount)
{
	PlayerInfo[playerid][pKredit] -= price;
	PremiumInfo[playerid][pKamat] = amount;
	PremiumInfo[playerid][pKamatIdo] = PREMIUM_KAMAT_IDO;
	UpdateKreditPanel(playerid);
	
	tformat(256, "[kredit][%d]%s bev�ltott %d kreditet +%f%% kamatra "#PREMIUM_KAMAT_IDO" fizet�sig", playerid, PlayerName(playerid), price, amount), Log("Egyeb", _tmpString);
	tformat(128, "Bev�ltott�l %d kreditet +%.5f%% kamatra "#PREMIUM_KAMAT_IDO" fizet�sig", price, amount);
	
	D_DialogDonate_Phase[playerid] = DONATE_BUY;
	CustomDialog(playerid, D:donate, DIALOG_STYLE_MSGBOX, "V�s�rl�s", _tmpString, "Befejez�s", "");
}

fpublic OnPlayerBuyAdo(playerid, price, Float:amount)
{
	PlayerInfo[playerid][pKredit] -= price;
	PremiumInfo[playerid][pAdo] = amount;
	PremiumInfo[playerid][pAdoIdo] = PREMIUM_ADO_IDO;
	UpdateKreditPanel(playerid);
	
	tformat(256, "[kredit][%d]%s bev�ltott %d kreditet %f%% ad�cs�kkent�sre "#PREMIUM_ADO_IDO" fizet�sig", playerid, PlayerName(playerid), price, amount), Log("Egyeb", _tmpString);
	tformat(128, "Bev�ltott�l %d kreditet %.5f%% ad�cs�kkent�sre "#PREMIUM_ADO_IDO" fizet�sig", price, amount);
	
	D_DialogDonate_Phase[playerid] = DONATE_BUY;
	CustomDialog(playerid, D:donate, DIALOG_STYLE_MSGBOX, "V�s�rl�s", _tmpString, "Befejez�s", "");
}

fpublic OnPlayerBuyPremiumpont(playerid, price, amount)
{
	PlayerInfo[playerid][pKredit] -= price;
	PlayerInfo[playerid][pPremiumPont] += amount;
	UpdateKreditPanel(playerid);
	
	tformat(256, "[kredit][%d]%s bev�ltott %d kreditet %ddb pr�miumpont�rt", playerid, PlayerName(playerid), price, amount), Log("Egyeb", _tmpString);
	tformat(128, "Bev�ltott�l %d kreditet %ddb pr�miumpont�rt", price, amount);
	
	D_DialogDonate_Phase[playerid] = DONATE_BUY;
	CustomDialog(playerid, D:donate, DIALOG_STYLE_MSGBOX, "V�s�rl�s", _tmpString, "Vissza", "Befejez�s");
}

CMD:kredit(playerid, params[])
{
	ShowKreditPanel(playerid);
	return 1;
}

/*CMD:premiumpont(playerid, params[])
{
	new subcmd[32];
	if(!sscanf(params, "s[32]"))
	{
		if(egyezik(subcmd, "elad"))
		{
			new amount;
			if(!sscanf(params, "{s[32]}i", amount))
			{
				#error befejezni
			}
			else
				return Msg(playerid, "/pr�mium elad [mennyis�g]"), Msg(playerid, "Egy ppont elad�si �ra: 1,000 kredit")
		}
	}
	
	Msg("Haszn�lata: /pr�miumpont [elad]");
	return 1;
}*/