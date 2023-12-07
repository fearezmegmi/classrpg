#if !defined __fs_object
	#error Rossz fájlt próbálsz compilolni
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
-> 100000-120000 -> Kocsibelsõk

- 101 - Autósbolt
- 102 - Crooker Club
- 103 - SSS iroda
- 104 - Kórház
- 105 - CCOK garázs ez scpd
- 106 - Mentõ Interior
- 107 - GSF Interior
- 108 - LCN Interior
- 109 - Mélygarázs Interior
- 110 - üres
- 111 - CCOK interior
- 112 - Aztecas interior
- 113 - Csillagtorony
- 114 - Önkormányzati iroda
- 115 - PigBen wc
- 116 - Iroda
- 117 - üres
- 118 - JOKAS inti
- 119 - Szerelõ hq
- 120 - Templom
- 121 - afk
- 122 - CCOKgarázs
- 123 - Riporter interior
- 124 - Autós bolt inti
- 125 - TAXI iroda
- 126 - Börtön de morgen
- 127 - NAV garázs & Konditerem
- 128 - NAV inti
- 129 - NAV HQ inti LS
- 130 - Brasco Vagyonvédelmi zrt
- 131 - üres
- 132 - Albán Maffia
- 133 - SFPD garázs
- 134 - Los Aztecas kiképzõ belsõ
- 135 - Autósbolt 2
- 136 - Yakuza
- 137 - Tûzoltó Interior
- 138 - SSS hotel
- 139 - Lõtér
- 140 - CCN Garázs
- 141 - Onkori közöségi hause
- 142 - SoA inti
- 143 - Katona HQ
- 144 - LSPD
- 145 - Kormányzat belsõ
- 146 - Hajléktalan szálló


==speciális==
- 242 - Mentõ inti
- 242 - Mapple Springs
- 98765 - PaintBall
- 1555 LS bank inti
- 999 túrbozott pb
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

// TÖRLÉSEK
new db = -1, CF[MAX_PLAYERS], bool:Connected[MAX_PLAYERS char];
enum rEnum {rO, Float:rP[3], Float:rD};
new OR[MAX_OBJECT_REMOVE][rEnum];

#include "util.pwn"
#include "definition.pwn"
#include "object_main.pwn"
//#include "object_alcatraz.pwn" -- Fort lett helyette betéve
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