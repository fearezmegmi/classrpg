#include <a_samp>
#include <a_http>

#define YSI_VERSION_RESPO               2

#define YSI_VERSION_MAJOR               1
#define YSI_VERSION_MINOR               02
#define YSI_VERSION_BUILD               0012

#define YSI_VERSION                     #YSI_VERSION_MAJOR "." #YSI_VERSION_MINOR "." #YSI_VERSION_BUILD

forward YVers_Callback(index, code, data[]);

#if defined FILTERSCRIPT
	public OnFilterScriptInit()
#else
	public OnGameModeInit()
#endif
{
	print(" ");
	print(" ======================================= ");
	print(" |                                     | ");
	print(" |        YSI " YSI_VERSION "          | ");
	print(" |    By Alex \"Y_Less\" Betoltese...  | ");
	print(" |                                     | ");
	print(" ======================================= ");
	print(" ");
	HTTP(0, HTTP_GET, "ysi-version.y-less.com/index.php?c=" #YSI_VERSION_RESPO "&v=" YSI_VERSION, "", "YVers_Callback");
	CallLocalFunction("YVers_OnScriptInit", "");
	return 1;
}

#if defined FILTERSCRIPT
	#if defined _ALS_OnFilterScriptInit
		#undef OnFilterScriptInit
	#else
		#define _ALS_OnFilterScriptInit
	#endif
	#define OnFilterScriptInit YVers_OnScriptInit
#else
	#if defined _ALS_OnGameModeInit
		#undef OnGameModeInit
	#else
		#define _ALS_OnGameModeInit
	#endif
	#define OnGameModeInit YVers_OnScriptInit
#endif
forward YVers_OnScriptInit();

public YVers_Callback(index, code, data[])
{
	print(" ====================================== ");
	print(" |                                    | ");
	print(" | A Szerver a legujabb YSI verzioval | "); 
	print(" |				Fut  				 | ");
	print(" |                                    | ");
	print(" ====================================== ");
	print(" ");
}
