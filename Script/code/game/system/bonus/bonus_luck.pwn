function GetRandomToken()
{
	new picked = -1;
	do
	{
		new bonusCount = BONUS_COUNT;
		new rnd = random(BONUS_COUNT);
		
		// bonus :: 100K
		if(rnd == --bonusCount)
		{
			if(BONUS_CHANCE_CASH_100K >= random(BONUS_MAX_CHANCE))
				picked = BONUS_CASH_100K;
		}
		
		// bonus :: 500K
		else if(rnd == --bonusCount)
		{
			if(BONUS_CHANCE_CASH_500K >= random(BONUS_MAX_CHANCE))
				picked = BONUS_CASH_500K;
		}
		
		// bonus :: 1M
		else if(rnd == --bonusCount)
		{
			if(BONUS_CHANCE_CASH_1M >= random(BONUS_MAX_CHANCE))
				picked = BONUS_CASH_1M;
		}
		
		// bonus :: 30M
		else if(rnd == --bonusCount)
		{
			if(BONUS_CHANCE_CASH_30M >= random(BONUS_MAX_CHANCE))
				picked = BONUS_CASH_30M;
		}
		
		// bonus :: 100M
		else if(rnd == --bonusCount)
		{
			if(BONUS_CHANCE_CASH_100M >= random(BONUS_MAX_CHANCE))
				picked = BONUS_CASH_100M;
		}
		
		// bonus :: tax (10%)
		else if(rnd == --bonusCount)
		{
			if(BONUS_CHANCE_TAX_10 >= random(BONUS_MAX_CHANCE))
				picked = BONUS_TAX_10;
		}
		
		// bonus :: tax (25%)
		else if(rnd == --bonusCount)
		{
			if(BONUS_CHANCE_TAX_25 >= random(BONUS_MAX_CHANCE))
				picked = BONUS_TAX_25;
		}
		
		// bonus :: tax (50%)
		else if(rnd == --bonusCount)
		{
			if(BONUS_CHANCE_TAX_50 >= random(BONUS_MAX_CHANCE))
				picked = BONUS_TAX_50;
		}
		
		// bonus :: tax (100%)
		else if(rnd == --bonusCount)
		{
			if(BONUS_CHANCE_TAX_100 >= random(BONUS_MAX_CHANCE))
				picked = BONUS_TAX_100;
		}
		
		// bonus :: interest (0.01%)
		else if(rnd == --bonusCount)
		{
			if(BONUS_CHANCE_INTEREST_001 >= random(BONUS_MAX_CHANCE))
				picked = BONUS_INTEREST_001;
		}
		
		// bonus :: interest (0.02%)
		else if(rnd == --bonusCount)
		{
			if(BONUS_CHANCE_INTEREST_002 >= random(BONUS_MAX_CHANCE))
				picked = BONUS_INTEREST_002;
		}
		
		// bonus :: interest (0.03%)
		else if(rnd == --bonusCount)
		{
			if(BONUS_CHANCE_INTEREST_003 >= random(BONUS_MAX_CHANCE))
				picked = BONUS_INTEREST_003;
		}
		
		// bonus :: interest (0.10%)
		else if(rnd == --bonusCount)
		{
			if(BONUS_CHANCE_INTEREST_010 >= random(BONUS_MAX_CHANCE))
				picked = BONUS_INTEREST_010;
		}
	}
	while(picked == -1);
	
	return picked;
}

function GetTokenUseType(type)
{
	switch(type)
	{
		case BONUS_CASH_100K .. BONUS_CASH_100M:
			return BONUS_TYPE_CASH;
			
		case BONUS_TAX_10 .. BONUS_TAX_100:
			return BONUS_TYPE_TAX;
			
		case BONUS_INTEREST_001 .. BONUS_INTEREST_010:
			return BONUS_TYPE_INTEREST;
	}
	
	return 0;
}

function GetTokenName(type)
{
	new str[32];
	if(type == BONUS_RANDOM)
		strcat(str, "Láda");
	
	else if(type == BONUS_CASH_100K) strcat(str, "100,000Ft készpénz");
	else if(type == BONUS_CASH_500K) strcat(str, "500,000Ft készpénz");
	else if(type == BONUS_CASH_1M) strcat(str, "1,000,000Ft készpénz");
	else if(type == BONUS_CASH_30M) strcat(str, "30,000,000Ft készpénz");
	else if(type == BONUS_CASH_100M) strcat(str, "100,000,000Ft készpénz");
		
	else if(type == BONUS_TAX_10) strcat(str, "-10%% adócsökkentés");
	else if(type == BONUS_TAX_25) strcat(str, "-25%% adócsökkentés");
	else if(type == BONUS_TAX_50) strcat(str, "-50%% adócsökkentés");
	else if(type == BONUS_TAX_100) strcat(str, "-100%% adócsökkentés");
		
	else if(type == BONUS_INTEREST_001) strcat(str, "+0.01%% kamat");
	else if(type == BONUS_INTEREST_002) strcat(str, "+0.02%% kamat");
	else if(type == BONUS_INTEREST_003) strcat(str, "+0.03%% kamat");
	else if(type == BONUS_INTEREST_010) strcat(str, "+0.10%% kamat");
	
	else
		strcat(str, "Ismeretlen");
	
	return str;
}

function GetTokenTypeFromString(type[])
{
	if(strlen(type) == 0)
		return NINCS;
		
	if(egyezik(type, BONUS_KEY_RANDOM)) return BONUS_RANDOM;
		
	if(egyezik(type, BONUS_KEY_CASH_100K)) return BONUS_CASH_100K;
	if(egyezik(type, BONUS_KEY_CASH_500K)) return BONUS_CASH_500K;
	if(egyezik(type, BONUS_KEY_CASH_1M)) return BONUS_CASH_1M;
	if(egyezik(type, BONUS_KEY_CASH_30M)) return BONUS_CASH_30M;
	if(egyezik(type, BONUS_KEY_CASH_100M)) return BONUS_CASH_100M;
	
	if(egyezik(type, BONUS_KEY_TAX_10)) return BONUS_TAX_10;
	if(egyezik(type, BONUS_KEY_TAX_25)) return BONUS_TAX_25;
	if(egyezik(type, BONUS_KEY_TAX_50)) return BONUS_TAX_50;
	if(egyezik(type, BONUS_KEY_TAX_100)) return BONUS_TAX_100;
	
	if(egyezik(type, BONUS_KEY_INTEREST_001)) return BONUS_INTEREST_001;
	if(egyezik(type, BONUS_KEY_INTEREST_002)) return BONUS_INTEREST_002;
	if(egyezik(type, BONUS_KEY_INTEREST_003)) return BONUS_INTEREST_003;
	if(egyezik(type, BONUS_KEY_INTEREST_010)) return BONUS_INTEREST_010;
		
	return NINCS;
}

function GetStringFromTokenType(type)
{
	new str[32];
	switch(type)
	{
		case BONUS_RANDOM: strcat(str, BONUS_KEY_RANDOM);
		
		case BONUS_CASH_100K: strcat(str, BONUS_KEY_CASH_100K);
		case BONUS_CASH_500K: strcat(str, BONUS_KEY_CASH_500K);
		case BONUS_CASH_1M: strcat(str, BONUS_KEY_CASH_1M);
		case BONUS_CASH_30M: strcat(str, BONUS_KEY_CASH_30M);
		case BONUS_CASH_100M: strcat(str, BONUS_KEY_CASH_100M);
		
		case BONUS_TAX_10: strcat(str, BONUS_KEY_TAX_10);
		case BONUS_TAX_25: strcat(str, BONUS_KEY_TAX_25);
		case BONUS_TAX_50: strcat(str, BONUS_KEY_TAX_50);
		case BONUS_TAX_100: strcat(str, BONUS_KEY_TAX_100);
		
		case BONUS_INTEREST_001: strcat(str, BONUS_KEY_INTEREST_001);
		case BONUS_INTEREST_002: strcat(str, BONUS_KEY_INTEREST_002);
		case BONUS_INTEREST_003: strcat(str, BONUS_KEY_INTEREST_003);
		case BONUS_INTEREST_010: strcat(str, BONUS_KEY_INTEREST_010);
	}
	
	return str;
}
