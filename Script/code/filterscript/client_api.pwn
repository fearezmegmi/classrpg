#define CLIENT_PLAYER_DISCONNECTED		(0)
#define CLIENT_PLAYER_CONNECTED			(1)

#define CLIENT_LOGIN_RESPONSE_FAILED	(0)
#define CLIENT_LOGIN_RESPONSE_SUCCESS	(1)

#define CLIENT_LOGIN_FAIL_AUTH			(1)
#define CLIENT_LOGIN_FAIL_BAN			(2)

// connect_id = egyedi kapcsolodasi azonosito (minden bejelentkezeskor uj generalodik)
// unique_id = felhasznalo egyedi, szerveroldali azonositoja (SQL ID)
// username = login nev (karakter)
// password = jelszo (md5 hash)
// ip = ip cim
// hwid = felhasznalo egyedi szamitogep azonosito (nem valtozik)
// status = kliens aktív (CLIENT_PLAYER_CONNECTED) vagy nem (CLIENT_PLAYER_DISCONNECTED)
// response = a játékos adatai helyesek, beléphet a kliensbe (CLIENT_LOGIN_RESPONSE_SUCCESS) vagy nem (CLIENT_LOGIN_RESPONSE_FAILED)

forward CLIENT_OnPlayerLoginRequest(connect_id, username[], password[], ip[], hwid[]);
forward CLIENT_OnPlayerStatus(status, username[], unique_id, ip[], hwid[]);
	
stock CLIENT_SendLoginResponse(connect_id, response, unique_id = -1, fail_code = 0)
	return CallRemoteFunction("CAPI_SendLoginResponse", "iiii", connect_id, response, unique_id, fail_code);

stock CLIENT_CheckPlayerStatus(username[], ip[])
	return CallRemoteFunction("CAPI_CheckPlayerStatus", "ss", username, ip);
	
stock CLIENT_IsActive()
	return CallRemoteFunction("CAPI_IsActive", "");
