#if defined __game_system_system_client_v2
	#endinput
#endif
#define __game_system_system_client_v2

#include "..\..\filterscript\client_api.pwn"

#define KLIENS_MOD_KOTELEZO	(0)
#define KLIENS_MOD_VALTOZO (1)

new KliensMode;

CMD:kliensmod(playerid, params[])
{
	if(!Admin(playerid, 1337))
		return 1;
	
	new mod;
	if(sscanf(params, "d", mod) || mod < 0 || mod > 1) 
	{
		Msg(playerid, "Használat: /kliensmód [0/1] - 0: mindenkinek kötelezõ, 1: változó (adatbázisban megadva)");
		Msg(playerid, TFormatInline("Kliens aktív: %d", ClassClient));
		Msg(playerid, TFormatInline("Jelenlegi mód: %d", KliensMode));
		return 1;
	}
	
	KliensMode = mod;
	SendFormatMessage(playerid, COLOR_WHITE, "Kliens mód beállítva: %d", KliensMode);
	
	SaveStuff();
	return 1;
}

public CLIENT_OnPlayerLoginRequest(connect_id, username[], password[], ip[], hwid[])
{
	new logEntry[512];
	Log("Client", FormatInline(logEntry, "OnPlayerLoginRequest() - connect_id: %d, username: %s, password: %s, ip: %s, hwid: %s", connect_id, username, password, ip, hwid));
	
	//P:RetrieveBans(ip, hwid, connect_id, username, password);
	P:RetrievePlayerInfo(username, password, connect_id);
}

stock P:RetrieveBans(ip[], hwid[], connect_id, username[], password[])
{
	sql_query(TFormatInline("SELECT ID FROM " SQL_DB_Ban " WHERE Cim IN ('%s', '%s')", ip, hwid), \
		PS "OnBansRetrieved", "dss", connect_id, username, password);
}

fpublic P:OnBansRetrieved(connect_id, username[], password[])
{
	new rows, fields;
	sql_data(rows, fields);
	
	if(rows > 0)
	{
		CLIENT_SendLoginResponse(connect_id, CLIENT_LOGIN_RESPONSE_FAILED, .fail_code = CLIENT_LOGIN_FAIL_BAN);
		return;
	}
	
	P:RetrievePlayerInfo(username, password, connect_id);
}

stock P:RetrievePlayerInfo(username[], password[], connect_id)
{
	sql_query(TFormatInline("SELECT ID FROM " SQL_DB_Player " WHERE Nev = '%s' AND Pass = '%s'", username, password), \
		PS "OnPlayerInfoRetrieved", "d", connect_id);
}

fpublic P:OnPlayerInfoRetrieved(connect_id)
{
	new rows, fields;
	sql_data(rows, fields);
	
	if(rows != 1)
	{
		CLIENT_SendLoginResponse(connect_id, CLIENT_LOGIN_RESPONSE_FAILED, .fail_code = CLIENT_LOGIN_FAIL_AUTH);
		return;
	}
	
	CLIENT_SendLoginResponse(connect_id, CLIENT_LOGIN_RESPONSE_SUCCESS, sql_get_row_int(0, 0));
}

public CLIENT_OnPlayerStatus(status, username[], unique_id, ip[], hwid[])
{
	new logEntry[512];
	Log("Client", FormatInline(logEntry, "CLIENT_OnPlayerStatus() - status: %d, username: %s, unique_id: %d, ip: %s, hwid: %s", status, username, unique_id, ip, hwid));
	OnClientStatusChange(unique_id, (status == CLIENT_PLAYER_CONNECTED ? 1 : 0), 0, hwid, ip);
}
