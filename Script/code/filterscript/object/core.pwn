#if !defined __fs_object
	#error Rossz f�jlt pr�b�lsz compilolni
#endif

#if defined __fs_object_core
	#endinput
#endif
#define __fs_object_core

/*
	C L A S S  R P G  ::  O B J E C T S
*/

/* INTERIOR LISTA
-> 100-999 -> interiorok
-> 100000-120000 -> Kocsibels�k

- 101 - Aut�sbolt
- 102 - Crooker Club
- 103 - SSS iroda
- 104 - K�rh�z
- 105 - CCOK gar�zs ez scpd
- 106 - Ment� Interior
- 107 - GSF Interior
- 108 - LCN Interior
- 109 - M�lygar�zs Interior
- 110 - �res
- 111 - CCOK interior
- 112 - Aztecas interior
- 113 - Csillagtorony
- 114 - �nkorm�nyzati iroda
- 115 - PigBen wc
- 116 - Iroda
- 117 - �res
- 118 - JOKAS inti
- 119 - Szerel� hq
- 120 - Templom
- 121 - afk
- 122 - CCOKgar�zs
- 123 - Riporter interior
- 124 - Aut�s bolt inti
- 125 - TAXI iroda
- 126 - B�rt�n de morgen
- 127 - NAV gar�zs & Konditerem
- 128 - NAV inti
- 129 - NAV HQ inti LS
- 130 - Brasco Vagyonv�delmi zrt
- 131 - �res
- 132 - Alb�n Maffia
- 133 - SFPD gar�zs
- 134 - Los Aztecas kik�pz� bels�
- 135 - Aut�sbolt 2
- 136 - Yakuza
- 137 - T�zolt� Interior
- 138 - SSS hotel
- 139 - L�t�r
- 140 - CCN Gar�zs
- 141 - Onkori k�z�s�gi hause
- 142 - SoA inti
- 143 - Katona HQ
- 144 - LSPD
- 145 - Korm�nyzat bels�
- 146 - Hajl�ktalan sz�ll�


==speci�lis==
- 242 - Ment� inti
- 242 - Mapple Springs
- 98765 - PaintBall
- 1555 LS bank inti
- 999 t�rbozott pb
- 1000 - max_kikepzo(1020)
- 123456789 WAR
- 1337 - Fegyenctelep
- 66666 - Bonusz
*/

#pragma dynamic 128000
#define FILTERSCRIPT
#define ALAPOBJECTDISTANCE 200.0
#define DEFAULT_REMOVE_RANGE 250.0

#include <a_samp>
#include <global\redefinition_samp.pwn>
#include <plugin\streamer>
#include <ysi\YSI_DATA\y_iterate>

#define FILTER_DUPES
#define OBJECTEKSZAMA 30000
#define MAX_OBJECT_REMOVE 1000
//#define WAIT_BETWEEN_BIG_REMOVE

#define INITIAL_SLEEP 0
#define TIME_BETWEEN_CYCLE 0
#define MAX_REMOVE_PER_CYCLE 250

#define NINCS -1
new
	VW = NINCS,
	Interior = NINCS,
	Player = NINCS,
	Float:Distance = 0.0,
	Iterator:Object<OBJECTEKSZAMA>
;

// T�RL�SEK
new db = -1, CF[MAX_PLAYERS], bool:Connected[MAX_PLAYERS char];
enum rEnum {rO, Float:rP[3], Float:rD};
new OR[MAX_OBJECT_REMOVE][rEnum];

#include "util.pwn"
#include "definition.pwn"
#include "object_main.pwn"
//#include "object_alcatraz.pwn" -- Fort lett helyette bet�ve
#include "object_frakcio.pwn"
#include "object_interior.pwn"
#include "object_bonusz.pwn"
#include "object_hatarok.pwn"
#include "object_benzinkutak.pwn"
#include "object_remove.pwn"


public OnFilterScriptInit() {
	Keszites_Main();
	//Keszites_Alcatraz();
	Keszites_Frakcio();
	Keszites_Interior();
	Keszites_Bonusz();
	Keszites_Benzinkutak();
	Keszites_Hatarok();
	Torlesek_Hatarok();
	Torlesek_Benzinkutak();
	Torlesek();
	
	for(new x = 0; x < MAX_PLAYERS; x++) {
		if(IsPlayerConnected(x) && !IsPlayerNPC(x) && !Connected{x})
			Initiate(x);
	}
	return 1;
}

public OnFilterScriptExit()
{
	//DestroyAllDynamicObjects();
	foreach(Object, x) DestroyDynamicObject(x);
	Iter_Clear(Object);
	return 1;
}

stock Initiate(playerid) {
	Connected{playerid} = true;
	CF[playerid] = 0;
	SetTimerEx("Do_Remove", INITIAL_SLEEP, 0, "d", playerid);
}

public OnPlayerConnect(playerid) {
	Initiate(playerid);
	return 1;
}

public OnPlayerDisconnect(playerid, reason) {
	Connected{playerid} = false;
	return 1;
}