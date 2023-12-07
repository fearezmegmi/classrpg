#if defined __game_core_config
	#endinput
#endif
#define __game_core_config

/*******************
 *                 *
 *   C O N F I G   *
 *                 *
 *******************/

// on/off
#define NO_VEDELEM
//#define SEE_DEBUG
//#define TEMP_NO_IP_BAN
//#define FS_ENABLED_JUNKBUSTER
//#define PLUGIN_ENABLED_AUDIO

//Beállítások
#define SERVER_PORT 9999
#define SERVER_NEV "ClassRPG"

// dev
new devmode;
#define DEVMODE_PORT 12345
#define DEVMODE_NPC	(1)

stock const
	modnev[32] = "ClassRPG",
	mapnev[32] = "« Class City »",
	weblap[32] = "ClassRPG.net"
;
 
new BackTime = 15; //15secenként checkel - Mert ha egyszerre mentene elég durva lag lenne
new BackTimeSave = 300; //perc - Player mentés - SQL

new hirdetesidokoz = 90; //
new MinimumFizuhoz = 7200; //2óra
 
#define LAST_SHOOT_FOR_KILLER 13
new CUSTOM_HITBOX = 0; // 0 = OnPlayerGiveDamage, 1 = OnPlayerWeaponShot

#define MAIN_CIVIL_SKIN	29
 
#define STAT_MENTES_IDO 10
#define GYEMANT_HASZON_IDO 3600
#define RunOutTime 30000
#define RefuelWait 7500
#define CARRESIIDO 3600
#define GOTOSZAMA 30

#define B_Kozel 3.0
#define B_Normal 8.0
#define B_Tavol 26.0
#define B_Tavol2 50.0
#define B_Cselekves 20.0

#define BESZED_TAV_NORMAL	(20.0)

#define ADO_HAZ 250
#define ADO_JARMU 250
#define ADO_SZINT 200
#define ADO_HAZGN 400
#define ADO_HAZLS 250
#define ADO_HAZSF 200
#define ADO_HAZFALU 80
#define ADO_HAZTANYA 70
#define ADO_PENZ 0.001

#define CHANNEL_PLAYERS 10
#define CHANNEL_TIMEOUT 30
#define CUSTOMPICKUPSTIME 2900
#define RENDELES_IDO 900
#define PENZ_PIZZA 5000
#define BANK_KAMAT 30.0
#define BANK_SZAZALEK 2 // osztó
#define TELEFON_INTAKTIVIDO 2592000

#define MAX_LEADEREK 5

#define TUZ_MAX 5
#define TUZ_OBJECT 12
#define TUZ_MINTAG 2
#define TUZ_IDO_MIN 300
#define TUZ_IDO_MAX 600
#define TUZ_TAV 5.0
#define TUZ_OLTO_TAV 6.0
#define TUZ_SERULES 15.0
#define TUZ_SERULES_TAV 6.0
#define TUZ_MUTAT_TAV 3000.0

#define AKTASLOT 4
#define SISAKSLOT 4
#define MASZKSLOT 4
#define SZEMUVEGSLOT 4
#define MAXHP 150.0
#define MAXBEJELENTKEZES 15
#define MAXAFKIDO 300 // 5 perc 300
#define KAMATSZORZO 0.75 // Bankszéfbe

#define JOGSI_MOTOR 75
#define JOGSI_AUTO 75
#define JOGSI_REPULO 100
#define JOGSI_HORGASZ 100
#define JOGSI_HAJO 100
#define JOGSI_KAMION 100
#define JOGSI_KRESZ 100
#define JOGSI_ADR 100
#define JOGSI_FEGYVER 250
#define AkkuMax 100
#define KocsiLeadasMax 60

#define GIFT_MAX_CIRCLES	6		// maximum hány körben legyen ajándék
#define GIFT_START			8		// kezdõ - az elsõ sorban hány darab ajándék legyen
#define GIFT_STEP			10		// folytatólagosan mennyi ajándékkal legyen több a következõ sorban
#define GIFT_POS_START		5.0	// kezdõ távolság a középponttól
#define GIFT_POS_STEP		4.0	// foyltatólagosan mennyivel nõjjön a távolság az elõzõ körtõl tekintve
#define MAX_GIFTS			200

// Térfigyelõ
#define PLAYER_MARKER_COLOR_ENGEDELY	0x7200c933
#define PLAYER_MARKER_COLOR_WEAPONHOLD	0xF5FCC2ff
#define PLAYER_MARKER_COLOR_TARGET		0xF3FF05ff
#define PLAYER_MARKER_COLOR_SHOOT		0xFF9705ff
#define PLAYER_MARKER_COLOR_KILL		0x8B4513ff
#define PLAYER_MARKER_COLOR_MKILL		0xE100FFff
#define PLAYER_MARKER_TIME_TARGETING	3
#define PLAYER_MARKER_TIME_WEAPONHOLD	15
#define PLAYER_MARKER_TIME_TARGET		60
#define PLAYER_MARKER_TIME_SHOOT		5
#define PLAYER_MARKER_TIME_KILL_SHOOT	10
#define PLAYER_MARKER_TIME_MKILL_SHOOT	15
#define PLAYER_MARKER_TIME_KILL			300
#define PLAYER_MARKER_TIME_MKILL		300
#define PLAYER_MARKER_STIME_SHOOT		120
#define PLAYER_MARKER_MTIME_SHOOT		180
#define PLAYER_MARKER_MTIME_KILL		600
#define PLAYER_MARKER_MTIME_MKILL		1500

#define PLAYER_MARKER_RIFLE_DISTANCE	15.0

#define TERULET_VARAKOZAS 0
#define TERULET_VARAKOZAS_FRAKCIO 7200
#define TERULET_FRAKCIO_LIMIT 30
#define TERULET_HASZON_IDO 3600

#define ALAPOBJECTDISTANCE 100.0

#define KINCS_KOD_HOSSZ 6
#define KINCS_KOD_HOSSZ_STRING "hat"

#define ADO_MIN 0
#define ADO_MAX 200

#define IP_ADDRESS_LENGTH 20
#define MAX_QUERY 1000
#define MAX_IP_STORE 100
#define SF_ROB_IDO 10800

//fegyver árak 
#define FE_SILENCED 2000
#define FE_SHOTGUN 3000
#define FE_DEAGLE 3000
#define FE_MP5 5000
#define FE_M4 8000
#define FE_SNIPER 8000
#define FE_COMBAT 7000
#define FE_RIFLE 7000
#define FE_AK47 8000
#define FE_Parachute 5000

//lõszer árak
#define LO_SILENCED 20
#define LO_SHOTGUN 30
#define LO_DEAGLE 30
#define LO_MP5 50
#define LO_M4 80
#define LO_SNIPER 80
#define LO_COMBAT 70
#define LO_RIFLE 70
#define LO_AK47 80
#define LO_Parachute 5000

//gumilövedék
#define FX_SILENCED 10
#define FX_SHOTGUN 15
#define FX_DEAGLE 15
#define FX_MP5 25
#define FX_M4 40
#define FX_SNIPER 40
#define FX_COMBAT 35
#define FX_RIFLE 35
#define FX_AK47 40
#define FX_Parachute -1

//ping kicker
#define MAX_PING 320
#define MAX_PING_WAR 200
#define MAX_PING_WARN 7
#define MAX_FPS_WAR 18

#define FPS_LIMITER_MIN_FPS		30
#define FPS_LIMITER_MAX_WARN	3
#define FPS_LIMITER_BAN_TIME	86400

// pénz
#define MUNKA_PENZ_SZORZO 4				// farmer / kukás / postás / úttisztító pénzszorzó
#define BANK_KEZELESI_KOLTSEG 8				// %
#define BANK_KEZELESI_KOLTSEG_FLOAT 0.08	// BANK_KEZELESI_KOLTSEG float formában
#define ADO_ONKORMANYZAT_RESZE_FLOAT 0.3	// 0.2 = 20%
#define ONKORMANYZAT_FRAKCIO_ADO_SZORZO 0.5
#define ADASVETELI_ADO 0.008 // Adásvételi biznisz
#define ARANY_KAMAT 0.007

#define MAX_HOUSE_PER_PLAYER	3
#define WEAPON_MIN_LEVEL		3 // minimum szint a fegyver használathoz

#define AHEAD_OF_CAR_DISTANCE 	9.0
#define SCAN_RADIUS             9.0

// flymode
#define MOVE_SPEED              210.0
#define ACCEL_RATE              0.03

#define VERZES 0.2

#define RACE_VIRTUAL_WORLD	5000

//kórház
#define K_OLES_IDO 90
#define K_LAB_IDO 60

// x / kg
#define P_MAX_MATI 50
#define P_MAX_KOKAIN 200
#define P_MAX_HEROIN 300
#define P_MAX_MARISKA 400

#define RK_FIGYELO_IDO 1800 //30 perc
#define NYELVTANULAS_IDO 1800
#define MAX_ELDOBOTTCUCC_IDO 3600
#define HETI_AKTIVITAS_WAR 3
#define HAVI_AKTIVITAS_WAR 7

//Kocsi Romlások
#define KOCSIROMLAS_MAX 2500.0
#define KOCSIROMLAS_NAGY 2000.0
#define KOCSIROMLAS_KOZEPES 1600.0
#define KOCSIROMLAS_KICSI 1200.0
#define KOCSIROMLAS_TOLAS 350.0

//#define RadarKell
#define KELLAJTOEXTRA
#define KELLNPC
#define KELLBUSZNPC

#define FEGYVERSZALLITO_FRAKCIO FRAKCIO_KATONASAG

new const LegalisFrakciok[11] = {1, 2, 4, 7, 9, 10, 12, 13, 16, 20, 14};

new const SzervezetLimit[22] = {
	25, //	LSPD 		1
	14, //	FBI 		2
	14, //	SoA 		3
	30, //	Mentõ 		4
	14, //	LCN 		5
	14, //	Yakuza 		6
	30, //	Kormány		7
	14, //	Aztecas		8
	30, //	Riporter	9
	30, //	TAXI		10
	14, //	Vagos 		11
	30, //	Tûzoltóság 	12
	19, //	Katonaság 	13
	25,	//	SFPD(NINCS)	14
	0, 	//	NINCS 		15
	30, //	Oktató 		16
	14, //	GSF 		17
	0, 	//	NINCS 		18
	0, 	//	NINCS 		19
	25, //	NAV 		20
	22	//	Turkey 		21
};

new const SzervezetSzinek[21] = 
{
	NINCS, // SCPD
	NINCS, // FBI
	TEAM_BALLAS_COLOR & 0xD900D388, // Ballas
	NINCS, // OMSZ
	COLOR_WHITE & 0xFFFFFFAA, // LCN
	COLOR_BLACK & 0xFFFFFFAA, // Yakuza
	NINCS, // Kormány
	COLOR_LIGHTBLUE & 0xFFFFFFAA, // Aztec
	NINCS, // Riporter
	NINCS, // Taxi
	COLOR_YELLOW & 0xFFFFFFAA, // Vagos
	NINCS, // Tûzoltó
	NINCS, // Katonaság
	NINCS, // SFPD
	COLOR_BROWN & 0xFFFFFFAA, // Régi SFPD - TÖRÖLT
	NINCS, // Oktatók
	0xB41212 & 0xFFFFFFAA, // GSF
	NINCS, // SF Taxi - TÖRÖLT
	NINCS, // SFMD - TÖRÖLT
	NINCS, // NAV
	COLOR_RED & 0xFFFFFFAA// Turkey
};

new const FrakcioBicikliSzin[MAX_FRAKCIO] =
{
	-1,			// 0 NINCS
	-1,			// 1 Rendõrség
	-1,			// 2 FBI
	79,			// 3 SoA
	-1,			// 4 OMSZ
	1,			// 5 LCN
	0,			// 6 Yakuza
	-1,			// 7 Kormány
	7,			// 8 Aztec
	-1,			// 9 CCN
	-1,			// 10 NINCS
	6,			// 11 Vagos
	-1,			// 12 CCFD
	-1,			// 13 Katonaság
	-1,			// 14 NINCS
	-1,			// 15 NINCS
	-1,			// 16 COK
	226,		// 17 GSF
	-1,			// 18 NINCS
	-1,			// 19 NINCS
	-1,			// 20 NAV
	-1,			// 21 NINCS
};


new IllegalisMunkak[6] = {
	3,//{MUNKA_FEGYVER, "Fegyverkereskedõ", 8}, //0
	2,//{MUNKA_PROSTI, "Prostituált", 3}, //1
	1,//{MUNKA_DROG, "Drogdíler", 5}, //2
	7,//{MUNKA_AUTOTOLVAJ, "Autótolvaj", 7}, //3
	9,//{MUNKA_HACKER, "Hacker", 9}, //4
	3,//{MUNKA_PANCEL, "Páncélkészítõ", 12}
};

new LegalisMunkak[12][3][20] = {
	//{MUNKA_DETEKTIV, "Detektív", 3},
	{MUNKA_FAVAGO, "Favágó", 3},
	{MUNKA_PILOTA, "Pilóta", 12},
	{MUNKA_UTTISZTITO, "Úttisztító", 1},
	{MUNKA_BUS, "Buszsofõr", 2},
	{MUNKA_KAMIONOS, "Kamionos", 3},
	{MUNKA_FARMER, "Farmer", 2},
	{MUNKA_FUNYIRO, "Fûnyíró", 1},
	{MUNKA_KUKAS, "Kukás", 2},
	{MUNKA_HULLA, "Hullaszállító", 3},
	{MUNKA_PENZ, "PénzSzállító", 1},
	{MUNKA_VADASZ, "Vadász", 15},
	{MUNKA_BANYASZ, "Bányász", 3}
	//{MUNKA_VILLANYSZERELO, "Villanyszerelõ", 5}
};

new const VersenySzorzo[8] = { //Százalékban
	35,		//1.
	30,		//2.
	25,		//3.
	20,		//4.
	15,		//5.
	10,		//6.
	 7,		//7.
	 5		//8.
};

new const BelsoArak[1+36] = {
	0,
	50000, 50000, 60000, 70000, 100000,
	130000, 130000, 150000, 200000, 700000,
	160000, 220000, 150000, 100000, 100000,
	250000, 210000, 300000, 220000, 500000,
	510000, 600000, 220000, 400000, 1500000,
	1200000, 1700000, 1600000, 900000, 1400000,
	1600000, 2600000, 3000000, 3300000, 3500000,
	3200000
};

new const MaxTalalas[12] = {
//Maximum cuccok
7,		//Kokacserje kereséskor max ennyit kap
6,		//Máklevél kereséskor max ennyit kap
3,		//Cannabis kereséskor max ennyit kap
10,		//Kokain készítéskor (Kokacserje * ennyi) + 1-et kaphat max
7,		//Heroin készítéskor (Máklevél * ennyi) + 1-et kaphat max
5,		//Marihuana készítéskor (Cannabis * ennyi) + 1-et kaphat max
150,	//Mati készítéskor (Mûanyag * ennyi) + 1-et kaphat max
2,	    //Alma szedésnél
2,		//Arany találásnál // gyémánt automatikusan 1 //bánya
10,		//Vas találásnál
15,		//Szén találásnál
5,		//Kõ találásnál
};

new const MunkaIdo[15] =
{
	5		*	1100,		// Kokacserje 0
	5		*	1100,		// Máklevél 1
	5		*	1100,		// Cannabis 2
	1		*	1000,		// Kokain 3
	2		*	1000,		// Heroin 4
	3		*	1000,   	// Marihuana 5
	10		*	1000,   	// Material 6
	120		*	1000, 		// Belsõcsere 7
	150		*	1100, 		// Katana készítés 8
	15		*	1000, 		// Ruha elvétel 9
	15		*	1000, 		// C4 hatástalanitás 10
	30		*	1000, 		// Nyelvtanulás 11
	30		*	1000, 		// Jármûjavítás 12
	5		*	1000,		// bánya 13
	10		*	1000,		// villanyszerelo 14
};

new const Vontatokocsik[7] = {
	427, 508, 525, 596, 597, 598, 599
};

new EladasIdo[3] = {
	30, // Ház eladási ideje		|	Alapértelmezett: 30 nap (1 hónap)
	30, // Kocsi eladási ideje		|	Alapértelmezett: 30 nap (1 hónap)
	30, // Biz eladási ideje		|	Alapértelmezett: 30 nap (1 hónap)
};

//bánya
new const BanyaFizu[4] = {
	250,	//Szén
	400,	//Vas
	20000,	//Arany
	90000,	//Gyémánt
};

new const Max_Benzin[212] = {
	60, //Landstalker (400)
	60, //Bravura (401)
	60, //Buffalo (402)
	300, //Linerunner (403)
	60, //Perenail (404)
	60, //Sentinel (405)
	60, //Dumper (406)
	100, //Firetruck (407)
	100, //Trashmaster (408)
	60, //Stretch (409)
	60, //Manana (410)
	80, //Infernus (411)
	60, //Voodoo (412)
	60, //Pony (413)
	100, //Mule (414)
	60, //Cheetah (415)
	120, //Ambulance (416)
	60, //Leviathan (417)
	60, //Moonbeam (418)
	60, //Esperanto (419)
	60, //Taxi (420)
	60, //Washington (421)
	60, //Bobcat (422)
	60, //Mr Whoopee (423)
	60, //BF Injection (424)
	100, //Hunter (425)
	60, //Premier (426)
	100, //Enforcer (427)
	100, //Securicar (428)
	60, //Banshee (429)
	60, //Predator (430)
	120, //Bus (431)
	120, //Rhino (432)
	150, //Barracks (433)
	60, //Hotknife (434)
	60, //Artic trailer 1 (435)
	60, //Previon (436)
	100, //Coach (437)
	60, //Cabbie (438)
	60, //Stallion (439)
	60, //Rumpo (440)
	60, //RC Bandit (441)
	60, //Romero (442)
	80, //Packer (443)
	60, //Monster (444)
	60, //Admiral (445)
	60, //Squalo (446)
	60, //Seasparrow (447)
	30, //Pizza boy (448)
	60, //Tram (449)
	60, //Artic trailer 2 (450)
	60, //Turismo (451)
	60, //Speeder (452)
	60, //Reefer (453)
	60, //Tropic (454)
	100, //Flatbed (455)
	100, //Yankee (456)
	30, //Caddy (457)
	60, //Solair (458)
	60, //Top fun (459)
	60, //Skimmer (460)
	60, //PCJ 600 (461)
	30, //Faggio (462)
	60, //Freeway (463)
	60, //RC Baron (464)
	60, //RC Raider (465)
	60, //Glendale (466)
	60, //Oceanic (467)
	40, //Sanchez (468)
	60, //Sparrow (469)
	80, //Patriot (470)
	30, //Quad (471)
	60, //Coastguard (472)
	60, //Dinghy (473)
	60, //Hermes (474)
	60, //Sabre (475)
	60, //Rustler (476)
	60, //ZR 350 (477)
	60, //Walton (478)
	60, //Regina (479)
	60, //Comet (480)
	60, //BMX (481)
	60, //Burrito (482)
	60, //Camper (483)
	60, //Marquis (484)
	60, //Baggage (485)
	60, //Dozer (486)
	120, //Maverick (487)
	120, //VCN Maverick (488)
	80, //Rancher (489)
	80, //FBI Rancher (490)
	60, //Virgo (491)
	60, //Greenwood (492)
	60, //Jetmax (493)
	60, //Hotring (494)
	60, //Sandking (495)
	60, //Blista Compact (496)
	120, //Police Maverick (497)
	60, //Boxville (498)
	60, //Benson (499)
	60, //Mesa (500)
	60, //RC Goblin (501)
	60, //Hotring A (502)
	60, //Hotring B (503)
	60, //Blood ring banger (504)
	60, //Rancher(lure) (505)
	60, //Super GT (506)
	60, //Elegant (507)
	100, //Journey (508)
	60, //Bike (509)
	60, //Mountain Bike (510)
	60, //Beagle (511)
	60, //Cropduster (512)
	60, //Stuntplane (513)
	300, //Petrol (514)
	300, //Roadtrain (515)
	60, //Nebula (516)
	60, //Majestic (517)
	60, //Buccaneer (518)
	100, //Shamal (519)
	60, //Hydra (520)
	40, //FCR 900 (521)
	40, //NRG 500 (522)
	40, //HPV 1000 (523)
	60, //Cement Truck (524)
	60, //Towtruck (525)
	60, //Fortune (526)
	60, //Cadrona (527)
	80, //FBI Truck (528)
	60, //Williard (529)
	60, //Fork lift (530)
	40, //Tractor (531)
	60, //Combine (532)
	60, //Feltzer (533)
	60, //Remington (534)
	60, //Slamvan (535)
	60, //Blade (536)
	60, //Freight (537)
	500, //Streak (538)
	60, //Vortex (539)
	60, //Vincent (540)
	60, //Bullet (541)
	60, //Clover (542)
	60, //Sadler (543)
	60, //Firetruck LA (544)
	60, //Hustler (545)
	60, //Intruder (546)
	60, //Primo (547)
	200, //Cargobob (548)
	60, //Tampa (549)
	60, //Sunrise (550)
	60, //Merit (551)
	60, //Utility van (552)
	60, //Nevada (553)
	60, //Yosemite (554)
	60, //Windsor (555)
	60, //Monster A (556)
	60, //Monster B (557)
	60, //Uranus (558)
	60, //Jester (559)
	60, //Sultan (560)
	60, //Stratum (561)
	60, //Elegy (562)
	150, //Raindance (563)
	60, //RC Tiger (564)
	60, //Flash (565)
	60, //Tahoma (566)
	60, //Savanna (567)
	60, //Bandito (568)
	60, //Freight flat (569)
	60, //Streak (570)
	60, //Kart (571)
	15, //Mower (572)
	100, //Duneride (573)
	40, //Sweeper (574)
	60, //Broadway (575)
	60, //Tornado (576)
	60, //AT 400 (577)
	100, //DFT 30 (578)
	60, //Huntley (579)
	60, //Stafford (580)
	60, //BF 400 (581)
	80, //News Van (582)
	60, //Tug (583)
	60, //Petrol tanker (584)
	60, //Emperor (585)
	60, //Wayfarer (586)
	60, //Euros (587)
	80, //Hotdog (588)
	60, //Club (589)
	60, //Freight box (590)
	60, //Artic trailer 3 (591)
	300, //Andromada (592)
	60, //Dodo (593)
	60, //RC Cam (594)
	60, //Launch (595)
	60, //Cop car LS (596)
	60, //Cop car SF (597)
	60, //Cop car LV (598)
	80, //Ranger (599)
	60, //Picador (600)
	150, //SWAT Tank (601)
	60, //Alpha (602)
	60, //Phoenix (603)
	60, //Glendale(damaged) (604)
	60, //Sadler(damaged) (605)
	60, //Bag box A (606)
	60, //Bag box B (607)
	60, //Stairs (608)
	100, //Boxville (609)
	60, //Farm trailer (610)
	60 //Utility van trailer (611)
};