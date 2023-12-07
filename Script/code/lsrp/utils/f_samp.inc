//------------------------------------------------------------------------------
// File:	f_samp.inc (version: 1.0x u1)
//
// Leírás:	Ez a fájl megkönnyebbíti a pawn nyelv használatát. Sok gyakran használt
//          függvényt tartalmaz.
//
// Log:  	2009/06/29 (verzió: 1.0)
//				- Elsõ verzió megjelenése
//
//          2009/06/29  (verzió: 1.0x)
//              - További függvények hozzáadása.
//              - További infórmáció egyes függvényekrõl.
//
//          2009/06/29  (verzió: 1.0x u1)
//              - Hibajavítások elvégezve.
//
// Készítõ: Epsilon & [_PGB_]Spatrik
//
// Minden jog fenntartva, Copyright
//------------------------------------------------------------------------------

/*------------------------------------------------------------------------------
native Instaset(b);
native SetTeleport(tpname[] ,id ,Float:x ,Float:y ,Float:z ,Float:a ,interior);
native ClearChat(playerid);
native GetVehicleDriver(vehid);
native ClearChatToAll();
native GET_PLAYER_NAME(playerid);
native GET_PLAYER_IP(playerid);
native KillPlayer(playerid);
native ReturnUser(estr[]);
native GivePlayerScore(playerid, score);
native GivePlayerWantedLevel(playerid, level);
native InstasetEx(b)
native Cenzura(word, text);
native OnlinePlayers();
native OffMusic(id);
native OffMusicForAll();
native PlaySoundForAll(soundid);
native SetPlayerMoney( id, mani );
native DestroyAllVehicles();
native KickEx(playerid, textcolor, reason[]);
native GivePlayerHealth(id, Float:h);
native WriteFile(file[], text[]);
native fcreate(fname[], fformat[]);
native IsTeamKill(playerid, killerid);
native IsSamePlayerTeam(playerid, killerid);
native IsNumeric(string[]);
native AntiDeamx();
native PlayerToPoint(Float:radi, playerid, Float:x, Float:y, Float:z);
native strsplit(const source[], dest[][], seprator);
native strcpy(dest[], const source[], max = 255, len = -1);
native strtok(const source[], &index);
native sscanf(string[], format[], {Float,_}:...);
native OffRPName(id);
------------------------------------------------------------------------------*/

//------------------------------------------------------------------------------
// Biztonsági rés
//------------------------------------------------------------------------------
#if defined functions_include
	#endinput
#endif
#define functions_include
#define Version "1.0x"

//------------------------------------------------------------------------------
// A szabványos SA:MP függvények beágyazása
//------------------------------------------------------------------------------
#include <a_samp>

//------------------------------------------------------------------------------
// Színek definiálása
//------------------------------------------------------------------------------
#define COLOR_ORANGE 	(0xFF9900AA)
#define COLOR_RED 		(0xFF0000AA)
#define COLOR_WHITE 	(0xFFFFFFAA)
#define COLOR_GREEN 	(0x008000AA)
#define COLOR_PINK 		(0xC715FFAA)
#define COLOR_YELLOW 	(0xFFFF00AA)
#define COLOR_LIGHTBLUE (0x00FFFFAA)
#define COLOR_BLUE 		(0x0000FFAA)
#define COLOR_PURPLE    (0x9900FFAA)
#define COLOR_GREY 		(0xAFAFAFAA)


//------------------------------------------------------------------------------
// #define állandók
//------------------------------------------------------------------------------
#define dcmd(%1,%2,%3) if ((strcmp((%3)[1], #%1, true, (%2)) == 0) && ((((%3)[(%2) + 1] == 0) && (dcmd_%1(playerid, "")))||(((%3)[(%2) + 1] == 32) && (dcmd_%1(playerid, (%3)[(%2) + 2]))))) return 1
#define foreach(%1) \
		for (new %1 = 0; %1 < GetMaxPlayers(); %1++) if (IsPlayerConnected(%1))
	
//------------------------------------------------------------------------------
// Név: Instaset
// Leírás: Ki vagy bekapcsolja a szerveren az instagibet. Azaz egy lövés = halál.
// Prototípus: Instaset( 0 = ki | 1 = be )
// Készítõ: Epsilon
//------------------------------------------------------------------------------
stock Instaset(b)
{
	// Ha a betáplált érték 1 akkor,
	if(b == 1) SendRconCommand("instagib 1");
	// Ha 0 akkor pedig
		else if(b == 0) SendRconCommand("instagib 0");
	// Ha egyiksem visszatérünk nullával	
			else return 0;
	// A függvény gondnélküli lefutása után eggyel tér vissza		
	return 1;
}

//------------------------------------------------------------------------------
// Név: InstasetEx
// Leírás: Ki vagy bekapcsolja a szerveren az instagibet. Azaz egy lövés = halál. 
//                          Ezenkívül visszatér a megadott értékkel
// Prototípus: InstasetEx( 0 = ki | 1 = be )
// Készítõ: Epsilon
//------------------------------------------------------------------------------
stock InstasetEx(b)
{
	// Ha a betáplált érték 1 akkor,
	if(b == 1) SendRconCommand("instagib 1");
	// Ha 0 akkor pedig
		else if(b == 0) SendRconCommand("instagib 0");
	// Ha egyiksem visszatérünk -1el	
			else return -1;
	// A függvény gondnélküli lefutása után a megadott értékkel tér vissza		
	return b;
}

//------------------------------------------------------------------------------
// Név: SetTeleport
// Leírás: A teleportok létrehozását könnyíti meg.
// Készítõ: Epsilon, Spatrik
//------------------------------------------------------------------------------
stock SetTeleport(tpname[] , id , Float:x , Float:y , Float:z , Float:a , interior )
{	
	// Ha a játékos jármûben van és õ vezeti,
	if( GetPlayerState( playerid ) == PLAYER_STATE_DRIVER )
	{
		// Akkor elteleportáljuk a jármûvet az adott koordinátára.
		SetVehiclePos( GetPlayerVehicleID( id ) , x, y, z );

		// Beállítjuk az elfordulási szögét.
		SetVehicleZAngle( GetPlayerVehicleID( id ) , a );

		// Elehelyezzük az adott interiorba.
		LinkVehicleToInterior( GetPlayerVehicleID( id ) , interior );
	}
	// Ha a játkos nem tartózkodik jármûben vagy nem vezeti azt,
	else
	{
		// Akkor elteleportáljuk a játékost az adott koordinátára.
		SetPlayerPos( id , x , y , z );

		// Beállítjuk az elfordulási szögét.
		SetPlayerFacingAngle( id , a );

		// A kamerát a játékos mögé helyezzük.
		SetCameraBehindPlayer( id );
	}

	// Elhelyezzük a játékost az adott interiorba.
	SetPlayerInterior( id , interior );

	// 128 karaktert toroló adattároló létrehozása az üzenet számára.
	new estr[ 128 ];

	// Üzenet megformázása.
	format( estr , 128 , "%s elteleportált ide: %s" , GET_PLAYER_NAME( playerid ) , tpname );

	// Elküldjük mindenkinek az elõre megformázott üzenetet.
	SendClientMessageToAll( COLOR_YELLOW , estr );

	// Visszatérés
	return 1;
}


//------------------------------------------------------------------------------
// Név: ClearChat
// Leírás: A Chatboxot lehet vele egyszerûen törölni egy játékosnál.
// Készítõ: Epsilon
//------------------------------------------------------------------------------
stock ClearChat(playerid)
{
	// A ciklus segítsgével 51-szer elküldjük az üres üzenetet.
	for(new a = 1; a <= 51; a++) SendClientMessage(playerid, COLOR_WHITE, "\n");

	// Visszatérés
	return 1;
}

//------------------------------------------------------------------------------
// Név: ClearChatToAll
// Leírás: A Chatboxot lehet vele egyszerûen törölni, ez viszont midnenkire hat.
// Készítõ: Spatrik
//------------------------------------------------------------------------------
stock ClearChatToAll()
{
	// A ciklus segítsgével 51-szer elküldjük az üres üzenetet mindenkinek.
	for(new i = 1; i <= 51; i++) SendClientMessageToAll(COLOR_WHITE, "\n");

	// Visszatérés
	return 1;
}

//------------------------------------------------------------------------------
// Név: GET_PLAYER_NAME
// Leírás: A játékos nevét lehet vele egyszerûen lekérni.
// Készítõ: Epsilon
//------------------------------------------------------------------------------
stock GET_PLAYER_NAME( id )
{
	// Egy adattároló létrehozása a név tárolására.
	new x[  MAX_PLAYER_NAME  ];

	// Ha a játékos csatlakozva van akkor lekérjük a nevét és elhelyezzük az x tárolóba.
	if( IsPlayerConnected( id ) ) GetPlayerName( id , x , sizeof(x) );

	// visszatérés az x értékével.
	return x;
}

//------------------------------------------------------------------------------
// Név: GET_PLAYER_IP
// Leírás: A játékos ip címét lehet vele egyszerûen lekérni.
// Készítõ: Spatrik
//------------------------------------------------------------------------------
stock GET_PLAYER_IP(playerid)
{
	// Egy adattároló létrehozása az ip tárolására.
	new ip[16];

	// Ha a játékos csatlakozva van akkor lekérjük az ip címét és elhelyezzük az ip tárolóba.
	if(IsPlayerConnected(playerid)) GetPlayerIp(playerid, ip, 16);

	// visszatérés az ip értékével.
	return ip;
}

//------------------------------------------------------------------------------
// Név: KillPlayer
// Leírás: A játékost lehet vele megölni.
// Készítõ: Spatrik
//------------------------------------------------------------------------------
stock KillPlayer(playerid)
{
	// A játékos életét 0-ra állítjuk.
	SetPlayerHealth(playerid, 0.0);
	
	// Visszatérés
	return 1;
}

//------------------------------------------------------------------------------
// Név: GivePlayerScore
// Leírás: A játékos pontjait lehet növelni.
// Készítõ: Spatrik
//------------------------------------------------------------------------------
stock GivePlayerScore(playerid, score)
{
	// Lekérjük a játékos pontjait és hozzáadjuk az adott számot.
	SetPlayerScore(playerid, GetPlayerScore(playerid) +score);
	
	// Visszatérés
	return 1;
}

//------------------------------------------------------------------------------
// Név: GivePlayerHealth
// Leírás: Gyógyítja a játékost megadott értékkel.
// Készítõ: Epsilon
//------------------------------------------------------------------------------
stock GivePlayerHealth(id, Float:h)
{
	// Lebegõpontos változó létrehozása
    new Float:hp;
	// Életpontok lekérése és tárolása
    GetPlayerHealth(id, hp);
	// "Gyógyítás"
    SetPlayerHealth(id, hp + h);
    // Visszatérés
    return 1;
}

//------------------------------------------------------------------------------
// Név: OffMusic
// Leírás: Leállít minden hanghatást az adott játékosnak.
// Készítõ: Epsilon
//------------------------------------------------------------------------------
stock OffMusic(id)
{
	// "Üres" hang lejátszása a játékosnak
	// Visszatérés
	return PlayerPlaySound(id, 1069, 0.0, 0.0, 0.0);
}
//------------------------------------------------------------------------------
// Név: OffMusicForAll
// Leírás: Leállít minden hanghatást mindenkinek.
// Készítõ: Epsilon
//------------------------------------------------------------------------------
stock OffMusicForAll()
{
		// ciklus definálása "üres" hang lejátszása
	foreach(id,200) PlayerPlaySound(id, 1069, 0.0, 0.0, 0.0);
	return 1;
}
//------------------------------------------------------------------------------
// Név: ReturnUser
// Leírás: Egy megadott névbõl visszatér a játékos azonósítószámával. ( ID )
// Készítõ: Epsilon
//------------------------------------------------------------------------------
stock ReturnUser(estr[])
{
	// ciklus létrehozása
    for(new id = 0; id <= MAX_PLAYERS; id++)
    {
	// Csatlakozásról való megbizonyosodás
        if(IsPlayerConnected(id))
	{
		// Karakterlánc létrehozása
            new ename[MAX_PLAYER_NAME];
		// Név lekérdezése és ráolása
	    GetPlayerName(id, ename, MAX_PLAYER_NAME);
		// Egyezés keresése a játékosok és a lekérdezett név között
	    if(!strcmp(ename, estr, true, strlen(estr))) return id;
	}
    }
    // Visszatérés
    return INVALID_PLAYER_ID;
}
//------------------------------------------------------------------------------
// Név: GetVehicleDriver
// Leírás: Lekéri a megadott jármû sofõrét ha van.
// Készítõ: Epsilon
//------------------------------------------------------------------------------
stock GetVehicleDriver(vehid)
{
	// Keresés és megállapítás
    for(new id; id<MAX_PLAYERS; id++) if(GetPlayerState(id) == 2) if (IsPlayerInVehicle(id, vehid)) return id;
	// Visszatérés
    return INVALID_PLAYER_ID;
}

//------------------------------------------------------------------------------
// Név: OffRPName
// Leírás: RP szervereknél ahol kötelezõ a _ a névben hasznos.
//             Ez kiveszi a karakterláncból a _ jelet így chatben nem lesz látható vagy
//     		     fájlírásnál is segíthet.
// Készítõ: Epsilon
//------------------------------------------------------------------------------
stock OffRPName(id)
{
	// Karakterlán definálása
    new estr[MAX_PLAYER_NAME];
	// Név lekérdezése és tárolása
    GetPlayerName(id,estr,MAX_PLAYER_NAME);
	// _ karakterek lecserélése
    for(new id = 0; id < MAX_PLAYER_NAME; id++) if (estr[id] == '_') estr[id] = ' ';
	 // Visszatérés
    return estr;
}

//------------------------------------------------------------------------------
// Név: GivePlayerWantedLevel
// Leírás: A játékos pontjait lehet növelni.
// Készítõ: Spatrik
//------------------------------------------------------------------------------
stock GivePlayerWantedLevel(playerid, level)
{
	// Lekérjük a játékos körözési szintjét és hozzáadjuk az adott számot.
	SetPlayerWantedLevel(playerid, GetPlayerWantedLevel(playerid) +level);

	// Visszatérés
	return 1;
}

//------------------------------------------------------------------------------
// Név: Cenzura
// Leírás: Egy adott szót lehet vele ki csillagozni egy karakterláncból.
// Készítõ: Epsilon
//------------------------------------------------------------------------------
stock Cenzura(const b[],c[])
{
	// Szöveg átnézése betûként.
	for(new d=0; d<128; d++)
	{
		// Ha az adott szó szerepel a szövegben.
		if (strfind(c[d], b, true) == 0)
		{
			// Ha megtaláltuk az adott szót akkor megkeressük a szövegben.
			for(new a=0; a<128; a++)
			{
				// Ha megtaláltuk akkor kicsillagozzuk.
				if (a >= d && a < d+strlen(b)) c[a]='*';
			}
		}
	}
	// Visszatérés
	return 1;
}

//------------------------------------------------------------------------------
// Név: OnlinePlayers
// Leírás: Visszatér a szerveren lévõ játékosok számával.
// Készítõ: Spatrik
//------------------------------------------------------------------------------
stock OnlinePlayers()
{
	// Létrehozunk egy változót
	new players = 0;
	
	// Elindítunk egy ciklust ami 0-tól a max slotokig csinál egy eljárást.
    for(new i = 0; i < GetMaxPlayers(); i++)
    {
        // Ha az adott sloton aktív egy játékos akkor a változó értékét 1-el megnüveljük.
        if(IsPlayerConnected(i)) players++;
    }
    // Visszatérés
    return players;
}

//------------------------------------------------------------------------------
// Név: PlaySoundForAll
// Leírás: Minden játékosnak lejátszik egy adott hangot.
// Készítõ: Spatrik
//------------------------------------------------------------------------------
stock PlaySoundForAll(soundid)
{
	// Egy ciklus segítségével az összes játékosnak elindítjuk az adott hangot.
	for(new i = 0; i < OnlinePlayers(); i++) PlayerPlaySound(i, soundid, 0.0, 0.0, 0.0);

	// Visszatérés
	return 1;
}
//------------------------------------------------------------------------------
// Név: IsSamePlayerTeam
// Leírás: Megállapítja, hogy TeamKill történt-e.
// Készítõ: Spatrik
//------------------------------------------------------------------------------
stock IsSamePlayerTeam(playerid, killerid)
{
	// Ha a gyilkos csapata egyezik az áldozat csapatával akkor visszatérünk az "igaz" értékkel.
	if(GetPlayerTeam(playerid) == GetPlayerTeam(killerid)) return true;
	
	// Ha nem egyezik akkor visszatérünk a "hamis" értékkel.
	return false;
}
//------------------------------------------------------------------------------
// Név: DestroyAllVehicles
// Leírás: Törli az összes jármûvet.
// Készítõ: Spatrik
//------------------------------------------------------------------------------
stock DestroyAllVehicles()
{
	// Egy ciklus segítségével töröljük a jármûveket.
	for(new v = 0; v > MAX_VEHICLES; v++) DestroyVehicle(v);

	// Visszatérés
	return 1;
}
//------------------------------------------------------------------------------
// Név: IsTeamKill
// Leírás: Megállapítja, hogy TeamKill történt-e.
// Figyelmeztetés: Használd az OnPLayerDeath() eljárás alatt!
//                    Máshol az IsSamePlayerTeam fgv.-t használd!
// Készítõ: Spatrik
//------------------------------------------------------------------------------
stock IsTeamKill(playerid, killerid)
{
	// Ha a gyilkos csapata egyezik az áldozat csapatával akkor visszatérünk az "igaz" értékkel.
	if(SamePlayerTeam(playerid,killerid) return true;
	
	// Ha nem egyezik akkor visszatérünk a "hamis" értékkel.
	return false;
}



//------------------------------------------------------------------------------
// Név: KickEx
// Leírás: Kirugja a játékost + üzenetet ír mindenkinek.
// Készítõ: Spatrik
//------------------------------------------------------------------------------
stock KickEx(playerid, textcolor, reason[])
{
	// Tároló létrehozása.
	new kickmsg[128];
	
	// A szétküldendõ üzenet megformázása.
	format(kickmsg, 128, "%s kickelve lett a szerverrõl! (ok: %s)", GET_PLAYER_NAME(playerid), reason);
	
	// Megformázott üzenet szétküldése.
	SendClientMessageToAll(textcolor, kickmsg);
	
	// Majd a játékos kirugása.
	Kick(playerid);

	// Visszatérés
	return 1;
}

//------------------------------------------------------------------------------
// Név: WriteFile
// Leírás: A fájlba lehet egyszerûen írni.
// Készítõ: Spatrik
//------------------------------------------------------------------------------
stock WriteFile(file[], text[])
{
	// Létrehozunk egy tárolót.
	new File: WriteFile;
	
	// A tárolónak értéket adunk.
	WriteFile = fopen(file, io_append);
	
	// Ha a fájl nem létezik,
	if(!WriteFile)
	{
	    // Akkor létrehozzuk.
	    new File: CreateFile;
		CreateFile = fopen(file, io_write);
		fclose(CreateFile);
		WriteFile = fopen(file, io_append);
	}
	// Beleírjuk az adatokat.
   	fwrite(WriteFile, text);
   	
   	// Majd a fájlt bezárjuk.
	fclose(WriteFile);

	// Visszatérés
	return 1;
}

//------------------------------------------------------------------------------
// Név: fcreate
// Leírás: Fájlt lehet vele létrehozni.
// Készítõ: Spatrik
//------------------------------------------------------------------------------
stock fcreate(fname[], fformat[])
{
	// Tároló létehozása.
	new fstring[256];
	
	// Fájlnév megformázása.
	format(fstring, 128, "%s.%s", fname, fformat);
	
	// Ha a fájl létezik akkor visszatérünk egy hibaüzenettel.
	if(fexist(fstring)) return printf("[HIBA]: A fajl mar letezik!");
	
	// Fájl megnyitása írásra
  	new File: f = fopen(fstring, io_write);
  	
  	// Ha a fájl sikeresen létrejött,
	if(f)
	{
	    // Akkor bezárjuk,
		fclose(f);
		
		// és egy üzenetet küldünk el.
		printf( "[SUCCES]: '%s.%s' nevu fajl letrehozva!", fname, fformat);
		
		// Visszatérés
		return 1;
	}
	// Ha a fájl továbbra sem létezik
	else
	{
	    // Akkor egy hibaüzenetet küldünk
		printf( "[HIBA]: '%s.%s' nevu fajl letrehozasa sikertelen!", fname, fformat);
	}
	// Majd kilépünk az eljárásból.
	return 0;
}

//------------------------------------------------------------------------------
// Név: IsNumeric
// Leírás: Lellenörzi, hogy az adott szöveg számjegy-e.
//------------------------------------------------------------------------------
stock IsNumeric(string[])
{
	// Egy ciklus segítségével lellenõrizzük a szöveget.
	for (new i = 0, j = strlen(string); i < j; i++)
	{
	    // Ha a szöveg nem számból áll akkor visszatérés a "hamis" értékkel.
		if (string[i] > '9' || string[i] < '0') return false;
	}
	// Ha a szöveg szám akkor visszatérés az "igaz" értékkel.
	return true;
}

//------------------------------------------------------------------------------
// Név: AntiDeamx
// Leírás: Ezt nem tudja értelmezni a deamx fordító ezért a scriptet nem lehet visszafordítani amelyben ez szerepel.
//------------------------------------------------------------------------------
stock AntiDeamx()
{
	new a[][15] =
	{ "?","?" };
	#pragma unused a
}

//------------------------------------------------------------------------------
// Név: PlayerToPoint
// Leírás: Ha a játékos egy adott ponthoz közel lép akkor egy eljárást lehet indítani vele.
//------------------------------------------------------------------------------
stock PlayerToPoint(Float:radi, playerid, Float:x, Float:y, Float:z)
{
    if(IsPlayerConnected(playerid))
	{
		new Float:oldposx, Float:oldposy, Float:oldposz;
		new Float:tempposx, Float:tempposy, Float:tempposz;
		GetPlayerPos(playerid, oldposx, oldposy, oldposz);
		tempposx = (oldposx -x);
		tempposy = (oldposy -y);
		tempposz = (oldposz -z);
		if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi)))
			return 1;
	}
	return 0;
}

//------------------------------------------------------------------------------
// Név: strsplit
// Leírás: A forrássztringet a megadott elválasztók mentén egy célkaraktertömbben helyezi el.
//------------------------------------------------------------------------------
stock strsplit( const source[  ], dest[  ][  ], seprator )
{
	new aNum, len, li, i;
	while( i < strlen( source ) ){
	    if( source[ i ] == seprator || !source[ i ] ){
	        len = strmid( dest[ aNum ], source, li, i, 255 );
	        dest[ aNum ][ len ] = 0;
	        aNum++, li = i + 1;
	    }
	    i++;
	}
}

//------------------------------------------------------------------------------
// Név: strcpy
// Leírás: A forrássztringet átmásolja a célsztringbe.
//------------------------------------------------------------------------------
stock strcpy( dest[  ], const source[  ], max = 255, len = -1 )
{
	new i;
	if( len == -1 ) len = strlen( source );
	while( i < len && i < max && ( dest[ i ] = source[ i ] ) ) i++;
	dest[ i == max ? i - 1 : i ] = 0;
}

//------------------------------------------------------------------------------
// Név: strtok
// Leírás: Részekre osztja a forrássztringet a whitespace karakterek mentén.
//------------------------------------------------------------------------------
stock strtok( const source[  ], &index )
{
	new length = strlen( source );
	while( index < length && source[ index ] <= ' ' ) index++;
	new offset = index,
	    result[ 255 ];
	while( index < length && source[ index ] > ' ' && ( index - offset ) < sizeof( result ) ){
	    result[ index ] = source[ index - offset ];
	    index++;
	}
	result[ index - offset ] = 0;
	return result;
}

//------------------------------------------------------------------------------
// Név: sscanf
// Leírás: Az strtok-hoz hasonlóan részekre osztja a forrássztringet de nem csak sztringeket kezel.
//------------------------------------------------------------------------------
stock sscanf(string[], format[], {Float,_}:...)
{
	#if defined isnull
		if (isnull(string))
	#else
		if (string[0] == 0 || (string[0] == 1 && string[1] == 0))
	#endif
		{
			return format[0];
		}
	#pragma tabsize 4
	new
		formatPos = 0,
		stringPos = 0,
		paramPos = 2,
		paramCount = numargs(),
		delim = ' ';
	while (string[stringPos] && string[stringPos] <= ' ')
	{
		stringPos++;
	}
	while (paramPos < paramCount && string[stringPos])
	{
		switch (format[formatPos++])
		{
			case '\0':
			{
				return 0;
			}
			case 'i', 'd':
			{
				new
					neg = 1,
					num = 0,
					ch = string[stringPos];
				if (ch == '-')
				{
					neg = -1;
					ch = string[++stringPos];
				}
				do
				{
					stringPos++;
					if ('0' <= ch <= '9')
					{
						num = (num * 10) + (ch - '0');
					}
					else
					{
						return -1;
					}
				}
				while ((ch = string[stringPos]) > ' ' && ch != delim);
				setarg(paramPos, 0, num * neg);
			}
			case 'h', 'x':
			{
				new
					ch,
					num = 0;
				while ((ch = string[stringPos]) > ' ' && ch != delim)
				{
					switch (ch)
					{
						case 'x', 'X':
						{
							num = 0;
							continue;
						}
						case '0' .. '9':
						{
							num = (num << 4) | (ch - '0');
						}
						case 'a' .. 'f':
						{
							num = (num << 4) | (ch - ('a' - 10));
						}
						case 'A' .. 'F':
						{
							num = (num << 4) | (ch - ('A' - 10));
						}
						default:
						{
							return -1;
						}
					}
				}
				setarg(paramPos, 0, num);
			}
			case 'c':
			{
				setarg(paramPos, 0, string[stringPos++]);
			}
			case 'f':
			{
				setarg(paramPos, 0, _:floatstr(string[stringPos]));
			}
			case 'p':
			{
				delim = format[formatPos++];
				continue;
			}
			case '\'':
			{
				new
					end = formatPos - 1,
					ch;
				while ((ch = format[++end]) && ch != '\'') {}
				if (!ch)
				{
					return -1;
				}
				format[end] = '\0';
				if ((ch = strfind(string, format[formatPos], false, stringPos)) == -1)
				{
					if (format[end + 1])
					{
						return -1;
					}
					return 0;
				}
				format[end] = '\'';
				stringPos = ch + (end - formatPos);
				formatPos = end + 1;
			}
			case 'u':
			{
				new
					end = stringPos - 1,
					id = 0,
					bool:num = true,
					ch;
				while ((ch = string[++end]) && ch != delim)
				{
					if (num)
					{
						if ('0' <= ch <= '9')
						{
							id = (id * 10) + (ch - '0');
						}
						else
						{
							num = false;
						}
					}
				}
				if (num && IsPlayerConnected(id))
				{
					setarg(paramPos, 0, id);
				}
				else
				{
					string[end] = '\0';
					num = false;
					new
						name[MAX_PLAYER_NAME];
					id = end - stringPos;

					foreach (playerid)
					{
						GetPlayerName(playerid, name, sizeof (name));
						if (!strcmp(name, string[stringPos], true, id))
						{
							setarg(paramPos, 0, playerid);
							num = true;
							break;
						}
					}
					if (!num)
					{
						setarg(paramPos, 0, INVALID_PLAYER_ID);
					}
					string[end] = ch;
				}
				stringPos = end;
			}
			case 's', 'z':
			{
				new
					i = 0,
					ch;
				if (format[formatPos])
				{
					while ((ch = string[stringPos++]) && ch != delim)
					{
						setarg(paramPos, i++, ch);
					}
					if (!i)
					{
						return -1;
					}
				}
				else
				{
					while ((ch = string[stringPos++]))
					{
						setarg(paramPos, i++, ch);
					}
				}
				stringPos--;
				setarg(paramPos, i, '\0');
			}
			default:
			{
				continue;
			}
		}
		while (string[stringPos] && string[stringPos] != delim && string[stringPos] > ' ')
		{
			stringPos++;
		}
		while (string[stringPos] && (string[stringPos] == delim || string[stringPos] <= ' '))
		{
			stringPos++;
		}
		paramPos++;
	}
	do
	{
		if ((delim = format[formatPos++]) > ' ')
		{
			if (delim == '\'')
			{
				while ((delim = format[formatPos++]) && delim != '\'') {}
			}
			else if (delim != 'z')
			{
				return delim;
			}
		}
	}
	while (delim > ' ');
	return 0;
}

//------------------------------------------------------------------------------
// Név: SetPlayerMoney
// Leírás: Átírja a játékos vagyonát.
// Készítõ: Epsilon
//------------------------------------------------------------------------------
stock SetPlayerMoney( id, mani )
{
	// Játékos vagynonának nullázása
    ResetPlayerMoney( id );
	//Új pénzösszeg "utalása"
    GivePlayerMoney( id , mani );
	//Visszatérés
    return 1;
}
