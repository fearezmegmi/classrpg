#if !defined __fs_bonus_simulator
	#error Nem ezeket a droidokat akarod kompilálni
#endif

#define ITERATIONS (10000)
new result[ITERATIONS];

public OnFilterScriptInit()
{
	print("Bonus Simulator started");
	DoIt();
	PrintResults();
}

stock DoIt()
{
	for(new i = 0; i < ITERATIONS; i++)
	{
		result[i] = Simulate();
	}
}

stock Simulate()
{
	return GetRandomToken();
}

stock PrintResults()
{
	new 
		cash100k,
		cash500k,
		cash1m,
		cash30m,
		cash100m,
		tax10,
		tax25,
		tax50,
		tax100,
		interest001,
		interest002,
		interest003,
		interest010
	;
		
	for(new i = 0; i < ITERATIONS; i++)
	{
		if(result[i] == BONUS_CASH_100K) cash100k++;
		else if(result[i] == BONUS_CASH_500K) cash500k++;
		else if(result[i] == BONUS_CASH_1M) cash1m++;
		else if(result[i] == BONUS_CASH_30M) cash30m++;
		else if(result[i] == BONUS_CASH_100M) cash100m++;
		else if(result[i] == BONUS_TAX_10) tax10++;
		else if(result[i] == BONUS_TAX_25) tax25++;
		else if(result[i] == BONUS_TAX_50) tax50++;
		else if(result[i] == BONUS_TAX_100) tax100++;
		else if(result[i] == BONUS_INTEREST_001) interest001++;
		else if(result[i] == BONUS_INTEREST_002) interest002++;
		else if(result[i] == BONUS_INTEREST_003) interest003++;
		else if(result[i] == BONUS_INTEREST_010) interest010++;
	}
	
	printf("Cash 100K: %d/%d (%.2f%%)", cash100k, ITERATIONS, float(cash100k) / float(ITERATIONS) * 100);
	printf("Cash 500K: %d/%d (%.2f%%)", cash500k, ITERATIONS, float(cash500k) / float(ITERATIONS) * 100);
	printf("Cash 1M: %d/%d (%.2f%%)", cash1m, ITERATIONS, float(cash1m) / float(ITERATIONS) * 100);
	printf("Cash 30M: %d/%d (%.2f%%)", cash30m, ITERATIONS, float(cash30m) / float(ITERATIONS) * 100);
	printf("Cash 100M: %d/%d (%.2f%%)", cash100m, ITERATIONS, float(cash100m) / float(ITERATIONS) * 100);
	printf("Tax 10%%: %d/%d (%.2f%%)", tax10, ITERATIONS, float(tax10) / float(ITERATIONS) * 100);
	printf("Tax 25%%: %d/%d (%.2f%%)", tax25, ITERATIONS, float(tax25) / float(ITERATIONS) * 100);
	printf("Tax 50%%: %d/%d (%.2f%%)", tax50, ITERATIONS, float(tax50) / float(ITERATIONS) * 100);
	printf("Tax 100%%: %d/%d (%.2f%%)", tax100, ITERATIONS, float(tax100) / float(ITERATIONS) * 100);
	printf("Interest 0.01%%: %d/%d (%.2f%%)", interest001, ITERATIONS, float(interest001) / float(ITERATIONS) * 100);
	printf("Interest 0.02%%: %d/%d (%.2f%%)", interest002, ITERATIONS, float(interest002) / float(ITERATIONS) * 100);
	printf("Interest 0.03%%: %d/%d (%.2f%%)", interest003, ITERATIONS, float(interest003) / float(ITERATIONS) * 100);
	printf("Interest 0.10%%: %d/%d (%.2f%%)", interest010, ITERATIONS, float(interest010) / float(ITERATIONS) * 100);
}