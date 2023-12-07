#if defined MAX_PLAYERS
	#undef MAX_PLAYERS
#endif

#define MAX_PLAYERS (160)

//#define KELLANTICHEAT
#define KELLNPC
#define KELLBUTORRENDSZER

#define OFFICIALWEB "www.ls-rp.hu"
#define DATABASENAME "lsrp"
#define VPSIP "37.17.173.144"
#define RCON_PASSWORD "SaCica"

#define MAX_PLAYER_WEAPON (47)

#if defined KELLANTICHEAT
	#include "JunkBuster"
#endif

#if !defined FALSE
    stock bool:FALSE = false;
#endif

#define OR ||
#define AND &&

#define MAX_MYSQL_STRING (4096)
#define MAX_MYSQL_STRING_UPDATER (1024)

#define LEVEL_ALAPORA (8)

#define MAPS_TXT "maps/load.txt"

#define MAX_OBJECT_TENGELY (6)

#define VALUE_TRUE (1)
#define VALUE_FALSE (0)

//#define KELLMSGSOUND

#define SALT_NORMALPW "Kg&YwF0LNAdLyOb0(v2LCx&vTUCO(dJ(tM2q(ME)"
#define SALT_BIZTONSAGIPW "#BBgrIm_oi#W^1Z$3tO-sH624EUYxRgKhsiST30v"
#define SALT_ADMINPW "9@C0%HdqaYcI3!zciy(p#Jgpy86o30lp7MJb^g$("

/*--------------- Szerver Fõ Színei -------------*/
#define COLOR_SEEBLUE "1E90FF"
#define COLOR_SEEORANGE "F2AB00"
#define COLOR_VC "EA59AE"// rózsaszín

#define COLOR_CSELEKVES "FF69B4"// rózsaszín

#define COLOR_MSG COL_WHITE
#define COLOR_ADMIN COLOR_SEEBLUE
#define COLOR_HEX_ADMIN (0x1E90FF00)

#define FOTEXTDRAWCOLOR (16777215)

#define COLOR_POLICE (0x8d8dffAA)

#define BENZIN_AR (500)
#define DIZEL_AR (500)
#define DKEROZIN_AR (500)
#define MAX_TANKOLAS_VONAL (10)

#define ACCEPTDEATH_TIME (5)
/*--------------- HTML színek -------------*/
#define COL_SILVER "C0C0C0"
#define COL_RED "FF0000"
#define COL_LIME "FF0000"
#define COL_YELLOW "FFFF00"
#define COL_PIROS "FF0000"
#define COL_BLUE "0000FF"
#define COL_AQUA "00FFFF"
#define COL_PINK "FF00FF"
#define COL_LIGHTGREEN "00FFFF"
#define COL_WHITE "FFFFFF"
#define COL_BLACK "000000"
#define COL_GREEN "008000"
#define COL_GRAY "808080"

#define NINCS (-1)
#define VAN (1)

#define NEM (0)
#define KELL (1)

#define KI (0)
#define BE (1)

#define SPAWNID 1

#define RB_NAME 1
#define RB_IP 2
#define RB_ALL 3

/* #################################################### */

#define VEHICLE_GAMETEXT_TIME (3 * 1000)
#define VEHICLE_GAMETEXT_STYLE (5)

#define ATM_MAPICON_ID (52)
#define ATM_OBJECT_ID (19526)

//---------[ Beállítások ]--------------
#define SEGIT_TIMEUP_MIN 2000
#define SEGIT_TIMEUP_MAX 5000

#define GYART_TIMEUP_MIN 2000
#define GYART_TIMEUP_MAX 5000

#define UTJAVIT_TIMEUP_MIN 2000
#define UTJAVIT_TIMEUP_MAX 7000

#define KELLAJTO3D
//#define KELLAUTOMATACSELEKVES
#define KELLHAZPICKUP
#define KELLHOTELPICKUP

#define	MODE_THIRDPERSON 1
#define	MODE_FIRSTPERSON 2

#define KEYPAD_BANKSZEF 9999999
#define KEYPAD_BANKSZEF_ELOTT 9999998

#define BANKRABLAS_KUL 1
#define BANKRABLAS_LOT 2
#define BANKRABLAS_KASZ 3

#define STRINGTORDELES (70)

#define ARMEDBODY_USE_HEAVY_WEAPON (false)

#define NINCSKOCSIZENE_URL "N/A"

#define KellObject
//#define UgralasAnim

#define DutyKorlatozas
#define FRAKCIOKOCSIK

#define fuggveny%0(%1) forward%0(%1); public%0(%1)

#define MAX_VEHICLE_OBJECTS (500)
#define MAXTUZ 100
#define TUZINTENZIVITAS 5

#define FINDLIMIT 5

#define MAX_ISMEROS 50

#define ELVERZESIDO 10 //Perc
#define DROGNOVEKEDES_IDO 1200 //másodperc
#define MUSZAKIAR (1000) // $
#define MUSZAKIIDO 2678400 //Másodperc
#define ALLAPOTOK 3
#define ALLAPOT_GYUJTAS 0
#define ALLAPOT_KOMPRESSZIO 1
#define ALLAPOT_UZEMANYAG 2

#define TERULET_HASZON_NINCS 0
#define TERULET_HASZON_DROG 1
#define TERULET_HASZON_MATI 2
#define TERULET_HASZON_PENZ 3

#define MAX_KOMPONENS 40 // Tuninghoz

#define MAX_UTZAR 50

#define MAX_ZONE_NAME (28)

#define MAX_INFOPICKUP 50
#define HULLAIDO (120) //Perc
#define MAX_HULLA (100)
#define BUSZMEGALLO_VARAKOZAS 30 // másodperc
//#define UCPUPDATER 5 //5 perc
#define INV_SLOT 50
#define LOGYAKORLATIDO 60
#define ELVESZLIMIT 10 //perc
#define MAX_POTKEREK 1
#define SZOLGALATIDO 1 //perc
#define FEGYVERRAKTAR_SLOT 30
#define MAX_CCTVS 100
#define MAX_CCTVMENUS 10
#define OLAJCSERE 15000 //15k Kilóméternél kell olajat cserélni
#define MEGPROBALIDO 30 //másodperc
#define MAXUVEG 5
#define JELADO_ARA 50000000
#define VILLANSZAMLA 20000
#define VISSZAKOTESIDIJ 50000
#define EROSITESIDO 600

#define CSOMAGSZALLITOLIMIT 300
#define ATMROBMIN 10000 //ATM Rabláskor Minimum Összeg
#define ATMROBMAX 50000 //ATM Rabláskor Maximum Összeg
#define ATMROBPICKUP 10
#define MAX_ATMDOBOZ 10
#define RABLASCUCC 5
#define LSROBC2 2 // azért mert NINCS az -1!
#define HOESES

#define KEREK_HATSO_BAL 0
#define KEREK_HATSO_JOBB 1
#define KEREK_ELSO_BAL 2
#define KEREK_ELSO_JOBB 3
	
#define TIPUS_UTKOZES 1
#define TIPUS_LOTTSEB 2
#define TIPUS_AJULAS 3

#define TOTAL_ALLOWED_TEARGAS 50

#define MAXTASKADROG 500
#define MAXTASKAPENZ 5000000

#define BESZED_NINCS 0
#define BESZED_TELEFON 1
#define BESZED_JARMUBEN 2
#define BESZED_JARMUBOL 3
#define BESZED_RADIO 4
#define BESZED_OOCRADIO 5
#define BESZED_OOC 6

#define RPTESZTLEHETOSEG 2
#define RPTESZTKERDES 5

#define INDEX_BAL 1
#define INDEX_JOB 2
#define INDEX_MINDD 3

#define BORTON_NINCS 0
#define BORTON_LSPD 1
#define BORTON_FEGYENCTELEP 2
#define BORTON_NAV 3
#define BORTON_NNI 4
#define BORTON_ADMIN 5
#define BORTON_ADMIN2 6

enum
{
	DIALOG_NINCS,
	DIALOG_LOGIN,

	DIALOG_VASARLAS,
	DIALOG_VASARLAS_BENZINKUT,
	DIALOG_VASARLAS_ELELMISZER,
	DIALOG_VASARLAS_MUSZAKI,
	DIALOG_VASARLAS_PATIKA,
	DIALOG_VASARLAS_EGYEB,
	DIALOG_VASARLAS_SPORT,

	DIALOG_NNI,
	DIALOG_BEP,
	DIALOG_GABI,
	DIALOG_RACETUNING,
	DIALOG_RACETUNING_2,
	DIALOG_AJSZOVEG,
	DIALOG_AUTOTOLVAJ,
	DIALOG_EMAIL,
	DIALOG_CONNECT,
	RADIODIALOG,
	DIALOG_TESZT,
	DIALOG_FELVONO,
	DIALOG_DROGSZEDES,
	DIALOG_HAZ,
	DIALOG_TELEFONVETEL,
	DIALOG_KRESZ,
	DIALOG_TELEFON_HIVAS,
	DIALOG_TELEFON,
	DIALOG_AHELP,
	DIALOG_DUTY,
	DIALOG_DUTY2,
	DIALOG_TUNING,
	DIALOG_BUYWEAPON,
	DIALOG_BUYWEAPON_SPORT,
	DIALOG_GOTO,
	DIALOG_GPS,
	DIALOG_MUNKAHELYEK,
	
	DIALOG_DIVATBOLT_SZEMUVEG,
	DIALOG_DIVATBOLT_FEJKENDO,
	DIALOG_DIVATBOLT_SVAJCISAPKA,
	DIALOG_DIVATBOLT_BASEBALLSAPKA,
	DIALOG_DIVATBOLT_KALAP,
	DIALOG_DIVATBOLT_SAPKA,
	DIALOG_DIVATBOLT_KARORA,
	DIALOG_DIVATBOLT_VALASZTAS,
	DIALOG_DIVATBOLT_EDIT,
	DIALOG_DIVATBOLT_EDIT_2,

	DIALOG_AJELSZO,
	DIALOG_TUNING2,
	DIALOG_PRIVATUZENET,
	DIALOG_KOCSIM_BELUL,
	DIALOG_KOCSIM_KIVUL,
	DIALOG_RICARDO_VILLA,
	DIALOG_ADATOK,
	DIALOG_NULLAZ,
	DIALOG_BUSZMEGALLOK,
	DIALOG_ZSEBTARTALOM,
	DIALOG_CARRESTART,

	DIALOG_VASARLAS_MATERIAL,
	DIALOG_DIVATBOLT_KATEGORIAK,

	DIALOG_ASKEZELO,
	DIALOG_AS_FELVESZ_IDG,
	DIALOG_AS_FELVESZ_OROK,
	DIALOG_AS_ELVESZ,

	DIALOG_CHATSZIN,

	DIALOG_REPULOJEGY,
	DIALOG_NYELVTANULAS,

	/*,------------------------------------------------------------------------------------,*/
	DIALOG_FKP_FOMENU,

	DIALOG_FKP_TAGKEZELO,
	DIALOG_FKP_TAGKEZELO_FELVESZ,
	DIALOG_FKP_TAGKEZELO_KIRUG,
	DIALOG_FKP_TAGKEZELO_SETRANG_1,
	DIALOG_FKP_TAGKEZELO_SETRANG_2,

	DIALOG_FKP_JARMUKEZELO,
	DIALOG_FKP_JARMUKEZELO_MINRANG,

	DIALOG_FKP_RANGKEZELO_VALASZTAS,
	DIALOG_FKP_RANGKEZELO_UJRANG,

	DIALOG_FKP_FIZU_VALASZTAS,
	DIALOG_FKP_FIZU_UJFIZETES,
	/*,------------------------------------------------------------------------------------,*/

	DIALOG_KAMERAK,

	MAX_CSOPORTNEV_HOSSZ,
	DIALOG_CSPANEL_FOMENU,
	DIALOG_CSPANEL_TAGFELVETEL,
	DIALOG_CSPANEL_TAGKIRUGAS,
	DIALOG_CSPANEL_NEVSZERKESZTES,

	DIALOG_EXPORTFEGYVERVASARLAS,
	DIALOG_EXPORTGUN_TOLTENYSZAM,

	DIALOG_DROGNPCVASARLAS,
	DIALOG_DIALOG_DROGNPC_MENNYISEG,

	DIALOG_PASSWORDCHECK,

	HIFI_RADIODIALOG,
	DIALOG_HIFIPANEL,
	DIALOG_HIFIPANEL_SAJATURL,
	DIALOG_HIFIPANEL_YOUTUBEURL,

	DIALOG_VESZ_MASZK,

	DIALOG_JOGSIVIZSGA,

	DIALOG_SECURITYPASSWORDCHECK,

	DIALOG_RADIODIALOG_RADIO,
	DIALOG_RADIODIALOG_YT,
	DIALOG_RADIODIALOG_URL,

	DIALOG_BizTypes,
	DIALOG_BizTypePrice,
	DIALOG_BizName,

	DIALOG_TANKOLAS,

	DIALOG_ButorMain,
	DIALOG_ButorEditLista,
	DIALOG_ButorEditListaOpc,
	DIALOG_ButorVeszLista,

	MAX_BUTOR,
	MAX_BIZNAME,
	
	DIALOG_KARAKTERREG_PASS,
	
	DIALOG_AUTOKER_KAT,
	DIALOG_JARMUVASARLAS_MEGEROSIT,
	
	DIALOG_BSZ,
	DIALOG_BSZ2,
	DIALOG_BANK_JELSZO,
	DIALOG_BANK_KIVESZ,
	DIALOG_BANK_BEFIZET,
	DIALOG_BANK_UTAL_1,
	DIALOG_BANK_UTAL_2,
	DIALOG_BANK_BELEP_1,
	DIALOG_BANK_BELEP_2
}

//=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_=_
#define ELEVATOR_SPEED (5.0)   // Movement speed of the elevator.
#define DOORS_SPEED (4.0)   // Movement speed of the doors.
#define ELEVATOR_WAIT_TIME (5000)  // Time in ms that the elevator will wait in each floor before continuing with the queue.
// Be sure to give enough time for doors to open.
#define X_DOOR_CLOSED (1786.627685)
#define X_DOOR_R_OPENED (1785.027685)
#define X_DOOR_L_OPENED (1788.227685)
#define GROUND_Z_COORD (14.511476)
#define ELEVATOR_OFFSET (0.059523)
//==================================================================//
/*new JELEROSITO_ARA[4] =
{
	15000000,
	25000000,
	40000000,
	50000000
}*/

#define EFFECT_RANDOM           20
#define EFFECT_FIX_DEFAULT      10
#define EFFECT_FIX_Z            0.008
#define EFFECT_MULTIPLIER 		0.05
#define EFFECT_HELI_VEL   		0.1
#define EFFECT_EXPLOSIONTYPE    1
#define EFFECT_EXPLOSIONOFFSET  -1.2
#define EFFECT_EXPLOSIONRADIUS  2.5

#define PLANES (460, 476, 511, 512, 513, 519, 520, 553, 577, 592, 593)
#define HELIS (417, 425, 447, 469, 488, 497, 548, 563)

#define MAX_DROP_ITEMS 1000

/* ###################### Attachobject slotok ###################### */
#define SLOT_SAPKA 0
#define SLOT_SZEMUVEG 1
#define SLOT_KARORA 2

#define SLOT_MASZK (3)
#define SLOT_KEZ (4)
#define SLOT_ZSAK (5)
#define SLOT_SWATPAJZS (6)
#define SLOT_BOT (7)
#define SLOT_SISAK (8)
#define SLOT_ARMOUR (9)

/* ###################### Fly Mode ###################### */
#define MOVE_SPEED (111.1)
#define ACCEL_RATE (0.03)

#define CAMERA_MODE_NONE 0
#define CAMERA_MODE_FLY 1

#define MOVE_FORWARD 1
#define MOVE_BACK 2
#define MOVE_LEFT 3
#define MOVE_RIGHT 4
#define MOVE_FORWARD_LEFT 5
#define MOVE_FORWARD_RIGHT 6
#define MOVE_BACK_LEFT 7
#define MOVE_BACK_RIGHT 8

#define SZT_NORMAL 1
#define SZT_TESZT 2
#define SZT_ISMERETLEN 3

#define MAXBEJELENTKEZES (5)
#define MAXAFKIDO 600 // 10 Perc
#define KAMATSZORZO 10 // Bankszéfbe

#define OKTATAS_AUTO 0
#define OKTATAS_MOTOR 1
#define OKTATAS_REPULO 2
#define OKTATAS_HORGASZ 3
#define OKTATAS_HAJO 4
#define OKTATAS_Csomagszallito 5
#define OKTATAS_FEGYVER 6

#define JOGSI_MOTOR 75
#define JOGSI_AUTO 75
#define JOGSI_REPULO 100
#define JOGSI_HORGASZ 100
#define JOGSI_HAJO 100
#define JOGSI_Csomagszallito 100
#define JOGSI_FEGYVER 50

#define MIKORRABOLHATO_BOLT 7200 // 2 óra

#define NEON_PIROS 1
#define NEON_KEK 2
#define NEON_COLOR_GREEN 3
#define NEON_COLOR_YELLOW 4
#define NEON_PINK 5
#define NEON_FEHER 6

/* ############ Ricardo féle ############ */
#define COLOR_AFK COLOR_PINK

//#define MAX_LEGALIS_FRAKCIOKOCSI 8
//#define MAX_ILLEGALIS_FRAKCIOKOCSI 5
#define MAX_FRAKCIOKOCSI (20)
#define BERLESAR (100)

#define MAX_ADMIN_LEVEL (5)

#define MINJATSZOTTORA (10)
#define MINSZINT (2)

#define RICARDOSZOVEG "Meg a jó édes anyádat.."

#define DOLLAR_ARFOLYAM (282)
#define GALLON_VALTAS (3.78541178)

#define FOADMIN (5)
#define SZUPERADMIN (FOADMIN)
/* ################################### */

#define TERULET_VARAKOZAS 1800
#define TERULET_VARAKOZAS_FRAKCIO 3600
#define WAR_VARAKOZAS 10

#define MAXIPBAN (1)

#define KOCSIHASZNALATIDO 5
#define JARMU_AFK_VW (87)
#define MAX_WIFI (10)
#define MAX_HIFI_DISTANCE (Float:15.0)
#define MAXHIFI 100
#define MAX_PLAYERTEXT (1024)
#define MAX_PASSWORD_HOSSZ (32)

#if !defined FLOAT_INFINITY
    #define FLOAT_INFINITY Float:0x7F800000
#endif

#define MAX_INT_VALUE (5000)
//#define MIN_INT_VALUE (-2147483647)

#define MAX_LOGINTIME (60)

#define VAROSTERULESWAT 3
#define VAROS_LS 0
#define VAROS_SF 1
#define VAROS_LV 2
#define MAXAUKCIO 5

#define MAX_FEGYVER 1000

#define ADO_HAZ 350
#define ADO_JARMU 350
#define ADO_SZINT 250
#define ADO_HAZGN 500
#define ADO_HAZLS 400
#define ADO_HAZSF 300
#define ADO_HAZFALU 200
#define ADO_HAZTANYA 100
#define ADO_PENZ 0.03

#define BANK_KAMAT 25.0
#define BANK_SZAZALEK 2 // mszktó

#define CUSTOMPICKUPSTIME 2900

//Az embernél MAX
#define MAXCSERJE 50
#define MAXMAK 50
#define MAXCANNABIS 50

#define MAXCSERJEMAG 100
#define MAXMAKMAG 100
#define MAXCANNABISMAG 100

#define MAXMUANYAG 5
#define MAXFEM 5

#define MAXKOKAIN 5000
#define MAXMARIHUANA 5000
#define MAXHEROIN 5000
#define MAXMATI 40000
#define MAXECSTASY 5000
#define MAXAMFETAMIN 5000

#define MAXKAJA 5
#define MAXKOTSZER 50
#define MAXORVOSSAG 5

//Bankrob:
#define MAXPENZSZALLITOPENZ (50000000/DOLLAR_ARFOLYAM)
#define MAXZSAKPENZ (5000000/DOLLAR_ARFOLYAM)

#define MAXPenzszallitoArany 50
#define MAXZSAKARANY 3
#define ARANYRUDAR 100000

//A kocsiban MAX
#define MAXCSERJEAKOCSIBAN 50
#define MAXMAKAKOCSIBAN 50
#define MAXCANNABISAKOCSIBAN 50
#define MAXMUANYAGAKOCSIBAN 20
#define MAXPROD 150
#define MAXMATIKOCSIBAN 80000
#define MAX_FELSZERELES 5
#define MAXKOKAINKOCSIBAN 10000
#define MAXHEROINKOCSIBAN 10000
#define MAXMARIHUANAKOCSIBAN 10000
//A raktárban MAX
#define MAXRAKTARKOKAIN 500000
#define MAXRAKTARHEROIN 500000
#define MAXRAKTARMARIHUANA 500000
#define MAXRAKTARMATI 1000000
//A házban MAX
#define MAXHAZKOKAIN 76000
#define MAXHAZHEROIN 76000
#define MAXHAZMARIHUANA 76000
#define MAXHAZMATI 500000
#define MAXHAZCIGI 150
#define MAXHAZKAJA 50
#define MAXHAZORVOSSAG 10
//Egyéb
#define MAXRENDELES 10
#define MAXTERULET 32
#define MAXBIZ 23

#define MAXHAZ (300)
#define MAXHOTEL (150)
#define MAXAJTO (100)

#define MAXVSKOCSI (500)

#define RENDELES_IDO 300 //900

#define MAX_ATM (30)
#define MAX_FULKE (50)
#define MAX_PICKUP (50) // SA-MP korlát: 4096
#define MAX_MAPICON (50) // SA-MP korlát: 100

#define CHANNEL_PLAYERS 10
#define CHANNEL_TIMEOUT 30
#define MAX_BENZINKUT 20
#define MAX_BENZIN_SZALLITAS 500

//Textdrawok
#define TD_KarakterInfo 1
#define TD_JarmuInfo 2
//#define TD_Almossag 3
#define TD_LoginSystem 4
#define TD_AdminSzoli 5
#define TD_Penz 6
#define TD_Web 7
#define TD_MiniMapTextDraw 8

#define B_Kozel 3.0
#define B_Normal 8.0
#define B_Tavol 20.0
#define B_Tavol2 30.0
#define B_Cselekves 20.0

#define RACESLOTOK 3
#define RACEMAXCP 51
#define RACECPMERET 22.5
#define RACECPMERETB 22.5

#define RACE_EPITES -1
#define RACE_NINCS 0
#define RACE_BETOLTVE 1
#define RACE_INDUL 2
#define RACE_ELINDULT 3
#define RACE_VEGE 4
#define RACE_CP_START -1
#define RACE_CP_CEL -2

#define QUERY_LoadPlayer 1

#define SZALLITASOKSZAMA 6
#define KereskedoSpawnok (7)

#define MAXINT 57
#define MAXIGENYLES 7
#define MAX_KOCSIK 100
#define MIN_VEHI_ID 400
#define MAXCUCCPERSOR 3
#define ALAPINTERIORSZAM 1
#define GPS_SZAMA (11)
#define MUNKAHELY_SZAMA (3)

#define EMERGENCY_CHANNEL (911)

#define CARRESIIDO 9999999999

#define HACKER_VW (7846)

#define COLOR_GreenMoney 0x009900EE
#define COLOR_YellowMoney 0x999900EE
#define COLOR_PIROSMoney 0x990000EE
#define COLOR_GreyMoney 0xC0C0C0EE
#define COLOR_Live 0xFF6C00FF

#define BIZ_GS1 0
#define BIZ_GS2 1
#define BIZ_ETTEREM  2
#define BIZ_TUNING 3
#define BIZ_BERLES1 4
#define BIZ_BERLES2 5
#define BIZ_TMOBIL 6
#define BIZ_OLAJ 7
#define BIZ_VODAFON 8
#define BIZ_IMPORT 9
#define BIZ_HAZ 10
#define BIZ_HIRDETES 11
#define BIZ_VIDAMPARK 12
#define BIZ_247 13
#define BIZ_PB 14
#define BIZ_TELENOR 15
#define BIZ_MCDONALD 16
#define BIZ_CSIRKE 17
#define BIZ_PIZZA 18
#define BIZ_KOCSMA 19
#define BIZ_PIGPEN 20
#define BIZ_AUTOMATA 21
#define BIZ_KAVEZO 22
#define BIZ_MUANYAG 23
#define BIZ_HORGASZBOLT 24
#define BIZ_RIO 24
#define BIZ_CARPART 25
#define BIZ_GOKART 26
#define BIZ_IBIZA 27
#define BIZ_UNDERGROUND 28
#define BIZ_VERSENY 29
#define BIZ_SeeRPGCO 30
#define BIZ_PALACE 31
#define BIZ_LOTER 32

//Datepropok
#define DP_Kocsi 1
#define DP_Haz 2
#define DP_Biz 3


//Munkák folyamatai
#define M_CSERJEMAG 1
#define M_MAKMAG 2
#define M_CANNABISMAG 3

#define M_CSERJE 4
#define M_MAK 5
#define M_CANNABIS 6

#define M_KOKAIN 11
#define M_HEROIN 12
#define M_MARIHUANA 13
#define M_MATERIAL 14
#define M_MELLENY 15
#define M_KATANA 16
#define M_SEGIT 21
#define M_MOTOR 22
#define M_BELSO 23
#define M_MSEGIT 24
#define M_SEGIT_DROG 25
#define M_EKI 26

#define dcmd(%1,%2,%3) if((strcmp((%3)[1], #%1, true, (%2)) == 0) && ((((%3)[(%2) + 1] == 0) && (dcmd_%1(playerid, "")))||(((%3)[(%2) + 1] == 32) && (dcmd_%1(playerid, (%3)[(%2) + 2]))))) return 1
#define SendFormatMessage(%1,%2,%3,%4) do{new sendfstring[128];format(sendfstring,128,(%3),%4);SendClientMessage(%1,(%2),sendfstring);}while(FALSE)
#define SendFormatMessageToAll(%1,%2,%3) do{new sendfstring[128];format(sendfstring,128,(%2),%3);SendClientMessageToAll((%1),sendfstring);}while(FALSE)
//#define Format(%1,%2,%3) do{ format(%1,sizeof(%1),(%2),%3); } while(FALSE)

#define Format(%1,%2,%3) format(%1,sizeof(%1),(%2),%3)
#define PlayerTextFormat(%1,%2,%3) format(PlayerText[%1], MAX_PLAYERTEXT, (%2), %3)

#define ABroadCastFormat(%1,%2,%3,%4) do{new sendfstring[128];format(sendfstring,128,(%3),%4);ABroadCast(%1,sendfstring,%2);}while(FALSE)
#define MsgFormat(%1,%2,%3) do{ new sendfstring[128]; format(sendfstring,128,(%2),%3); Msg(%1,sendfstring);} while(FALSE)

#define ClearAnim(%1) ApplyAnimation(%1, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0)
#define HideDialog(%1) ShowPlayerDialog(%1, -1, DIALOG_STYLE_MSGBOX, "", "", "", "")
#define strcpy(%0,%1,%2) strcat((%0[0] = '\0', %0), %1, %2)

#define PlayerSQLID(%1) PlayerInfo[%1][pID]
#define SQLID(%1) PlayerInfo[%1][pID]

#define agetmint(%1,%2) %2 = cache_get_field_content_int(0,%1)
#define agetmfloat(%1,%2) %2 = cache_get_field_content_float(0,%1)
stock agetmstring(hol[], mibe[]) { new get[128]; cache_get_field_content(0, hol, get); format(mibe, 128, "%s", get); }

#define getmint(%0,%1,%2) %2 = cache_get_field_content_int(%0,%1)
#define getmfloat(%0,%1,%2) %2 = cache_get_field_content_float(%0,%1)
stock getmstring(row, hol[], mibe[]) { new get[128]; cache_get_field_content(row, hol, get); format(mibe, 128, "%s", get); }

#define PlayerUpdate(%1,%2,%3) do { new datastring[256],wherestring[32]; format(datastring,256,(%2),%3); format(wherestring,32, "id='%d'",PlayerSQLID(%1)); Mysql_Set(SQL_DB_Player, datastring, wherestring); } while(FALSE)
//#define UCPUpdate(%1,%2,%3) do { new datastring[256],wherestring[32]; format(datastring,256,(%2),%3); format(wherestring,32, "ID='%d'",PlayerSQLID(%1)); Mysql_Set(SQL_DB_UCP, datastring, wherestring); } while(FALSE)
#define ATMUpdate(%1,%2,%3) do { new datastring[256],wherestring[32]; format(datastring,256,(%2),%3); format(wherestring,32, "id='%d'",%1); Mysql_Set(SQL_DB_ATM, datastring, wherestring); } while(FALSE)
#define PickupUpdate(%1,%2,%3) do { new datastring[256],wherestring[32]; format(datastring,256,(%2),%3); format(wherestring,32,"id='%d'",%1); Mysql_Set(SQL_DB_Pickup, datastring, wherestring); } while(FALSE)
#define FulkeUpdate(%1,%2,%3) do { new datastring[256],wherestring[32]; format(datastring,256,(%2),%3); format(wherestring,32, "id='%d'",%1); Mysql_Set(SQL_DB_Fulke, datastring, wherestring); } while(FALSE)
#define KapuUpdate(%1,%2,%3) do { new datastring[256],wherestring[32]; format(datastring,256,(%2),%3); format(wherestring,32, "id='%d'",%1); Mysql_Set(SQL_DB_Kapuk, datastring, wherestring); } while(FALSE)
#define DutyUpdate(%1,%2,%3) do { new datastring[256],wherestring[32]; format(datastring,256,(%2),%3); format(wherestring,32, "id='%d'",%1); Mysql_Set(SQL_DB_Duty, datastring, wherestring); } while(FALSE)
//#define TAGUpdate(%1,%2,%3) do { new datastring[256],wherestring[32]; format(datastring,256,(%2),%3); format(wherestring,32, "id='%d'",%1); Mysql_Set("firkak", datastring, wherestring); } while(FALSE)
#define HOLDING(%0) ((newkeys & (%0)) == (%0))
#define PRESSED(%0) (((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))
#define RELEASED(%0) (((newkeys & (%0)) != (%0)) && ((oldkeys & (%0)) == (%0)))

#define PlayerForeach(%1) for(new %1 = 0, poolsize_%1 = GetPlayerPoolSize(); %1 <= poolsize_%1; %1++)
#define VehicleForeach(%1) for(new %1 = 1, poolsize_%1 = GetVehiclePoolSize(); %1 <= poolsize_%1; %1++) // a kocsi ID-k 1-tõl kezdõdnek, nem 0-tól!
#define ActorForeach(%1) for(new %1 = 0, poolsize_%1 = GetActorPoolSize(); %1 <= poolsize_%1; %1++)

#define SCM SendClientMessage
#define SCMToAll SendClientMessageToAll

#define KEY_AIM (128)
	
#define chrtolower(%1) \
	(((%1) > 0x40 && (%1) <= 0x5A) ? ((%1) | 0x20) : (%1))

#define STREAM_OBJECT_OUT(%0)                                										\
	DestroyObject(Jarmu_Streamer[(%0)][object_objectid]);          										\
	Jarmu_Streamer[(%0)][object_objectid] = 0

#define STREAM_SeeRPGOBJECT_OUT(%0)                                										\
	DestroyObject(SeeRPGStreamer[(%0)][object_objectid]);          										\
	SeeRPGStreamer[(%0)][object_objectid] = 0
//Alapmunkák
#define MUNKA_DESWATTIV 1
#define MUNKA_UGYVED 2
#define MUNKA_PROSTI 3
#define MUNKA_DROG 4
#define MUNKA_AUTOTOLVAJ 5
#define MUNKA_TOLMACS 6
#define MUNKA_TESTOR 7
#define MUNKA_FEGYVER 8
//#define MUNKA_autokereskedes 9
#define MUNKA_KEMENYSEPRO 9
#define MUNKA_UTTISZTITO 10
#define MUNKA_BOXOLO 11
#define MUNKA_BUS 12
#define MUNKA_UJSAGOS 13
#define MUNKA_HACKER 14
#define MUNKA_CSOMAGSZALLITO 15
#define MUNKA_FARMER 16
#define MUNKA_FUNYIRO 17
#define MUNKA_EPITESZ 18
#define MUNKA_PANCEL 19
#define MUNKA_KUKAS 20
#define MUNKA_BETORO 21
#define MUNKA_PIZZA 22
#define MUNKA_FAVAGO 23
#define MUNKA_TARGONCA 24
#define MUNKA_UTKARBANTARTO 25

#define OSSZMUNKA 26 // MINDIG UTOLSÓ MUNKA IDJE +1!!!!

//FRAKCIÓ IDk
#define LMUNKA_LSPD (1)
#define LMUNKA_FBI (2)
#define LMUNKA_BALLAS (3)
#define LMUNKA_MENTO (4)
#define LMUNKA_CAMORRA (5)
#define LMUNKA_ALLAM (6)
#define LMUNKA_RIPORTER 7
#define LMUNKA_TAXI 8
#define LMUNKA_LK 9
#define LMUNKA_SURENOS 10
#define LMUNKA_KATONA 11
#define LMUNKA_OKTATO 12
#define LMUNKA_GSF 13
#define LMUNKA_SZERELO (14)
#define LMUNKA_NAV 15
#define LMUNKA_UM (16)
#define LMUNKA_TUZOLTO LMUNKA_MENTO
#define LMUNKA_SWAT 18

#define MAX_FRAKCIO (19)
#define MAX_CSOPORT (50)
//Helyek
#define IsAt_McDonald 0
#define IsAt_Pizzazo 1
#define IsAt_Csirkes 2
#define IsAt_HotDog 3
#define IsAt_Korhaz 4
#define IsAt_Etterem 5
#define IsAt_LSPDBorton 6
#define IsAt_Fort 7
#define IsAt_SzereloTelep 8
#define IsAt_Hajlektalan 9
#define IsAt_Festo 10
#define IsAt_Haz 11
#define IsAt_HazElott 12
#define IsAt_Bank 13
#define IsAt_Buszmegallo 14
#define IsAt_Csokiautomata 15
#define IsAt_Pickup 16
#define IsAt_Repter 17
#define IsAt_Kapu 18
#define IsAt_HazElott_Park 15
#define IsAt_HotelElott 16
//Színek, egyebek
#define COLOUR_INFO	0x00CC33FF
//GOV
#define COLOR_KGOV 997744        //katona

#define COLOR_LILA 0x9900FFFF
#define COLOR_CHAT1 0xF9B7FFAA
#define COLOR_CHAT2 0xE6A9ECAA
#define COLOR_CHAT3 0xC38EC7AA
#define COLOR_CHAT4 0xD2B9D3AA
#define COLOR_CHAT5 0xC6AEC7AA
#define COLOR_INVISIBLE 0xFFFFFF00
#define COLOR_PIROS 0xFF0000FF
#define COLOR_PINK 0xFF80FFC7
#define COLOR_SKEK 0x2641FEAA
#define COLOR_LIGHTBROWN 0x8B4513FF
#define COLOR_ORANGE 0xFF8C00AA
#define Checkpoint_NONE 0
#define Checkpoint_HOME 12
#define COLOR_BLACK 0x050505AA 
#define COLOR_GRAD1 0xB4B5B7FF
#define COLOR_GRAD2 0xBFC0C2FF
#define COLOR_GRAD3 0xCBCCCEFF
#define COLOR_GRAD4 0xD8D8D8FF
#define COLOR_GRAD5 0xE3E3E3FF
#define COLOR_GRAD6 0xF0F0F0FF
#define COLOR_GREY 0xAFAFAFAA
#define COLOR_GREEN 0x009900FF
#define COLOR_RED 0xFF0000
#define COLOR_PIROS2 0xAA0000AA
#define COLOR_BLUE 0x4661FEAA
#define COLOR_DBLUE 0x2641FEAA
#define COLOR_LIGHTRED 0xFF6347AA
#define COLOR_LIGHTBLUE 0x33CCFFAA
#define COLOR_LIGHTGREEN 0x9ACD32AA
#define COLOR_LIMEGREEN 0x32CD32AA
#define COLOR_YELLOW 0xFFFF00AA
#define COLOR_SPRINGGREEN 0x00FF7FAA
#define COLOR_YELLOW2 0xF5DEB3AA
#define COLOR_WHITE 0xFFFFFFFF
#define COLOR_INFOBAR COLOR_WHITE /*16777215*/
#define COLOR_FADE1 0xE6E6E6E6
#define COLOR_FADE2 0xC8C8C8C8
#define COLOR_FADE3 0xAAAAAAAA
#define COLOR_FADE4 0x8C8C8C8C
#define COLOR_FADE5 0x6E6E6E6E
#define COLOR_PURPLE 0xC2A2DAAA
#define COLOR_ALLDEPT 0xFF8282AA
#define COLOR_NEWS 0xFFA500AA
#define COLOR_OOC 0xE0FFFFAA
#define TEAM_CYAN 1
#define TEAM_BLUE 2
#define TEAM_GREEN 3
#define TEAM_ORANGE 4
#define TEAM_COR 5
#define TEAM_BAR 6
#define TEAM_TAT 7
#define TEAM_CUN 8
#define TEAM_STR 9
#define TEAM_HIT 10
#define TEAM_ADMIN 11
#define OBJECTIVE_COLOR 0x64000064
#define TEAM_GREEN_COLOR 0xFFFFFFAA
#define TEAM_JOB_COLOR 0xFFB6C1AA
#define TEAM_BLUE_COLOR 0x8D8DFF00
#define COLOR_ADD 0x63FF60AA
#define TEAM_GROVE_COLOR 0x00D900C8
#define TEAM_LK_COLOR 0xFFC801C8
#define TEAM_BALLAS_COLOR 0xD900D3C8
#define TEAM_Surenos_COLOR 0x01FCFFC8
#define TEAM_CYAN_COLOR 0xFF8282AA
#define TEAM_ORANGE_COLOR 0xFF830000
#define TEAM_COR_COLOR 0x39393900
#define TEAM_BAR_COLOR 0x00D90000
#define TEAM_TAT_COLOR 0xBDCB9200
#define TEAM_CUN_COLOR 0xD900D300
#define TEAM_STR_COLOR 0x01FCFF00
#define TEAM_ADMIN_COLOR 0x00808000
#define COLOR_INVIS 0xAFAFAF00
#define COLOR_SPEC 0xBFC0C200
#define COLOR_ULTRAPIROS 0xE60000FF
#define COLOR_UJIRC 0x00A2FFFF
#define COLOR_GOV1 0xFF8800FF
#define COLOR_GOV2 0xEA0000FF
#define COLOR_RENDEZVENY 0x00C79DFF
#define Pink 0xFF00FFFF
#define Pink2 0xFF1493FF

#define VEHETOFEGYVER 6

#define VEHETOSPORTCUCC 4

#define MAX_NYELV 20

#define NYELV_MAGYAR 0

#define KIEGESZITO_SAPKA 0
#define KIEGESZITO_SZEMUVEG 1
#define KIEGESZITO_KARORA 2

#define LSBANK_LIFT_STATUSZ_NINCS -1
#define LSBANK_LIFT_STATUSZ_FEL 0
#define LSBANK_LIFT_STATUSZ_LE 1

#define MAXLEVELINPUTTEXT 50

#define RBRuha 0
#define RBMaszk 1
#define RBFKendo 2
#define RBKSapka 3
#define RBKOra 4
#define RBNSzem 5

#define BVAsztal 6
#define BVSzek 7
#define BVFotelKanape 8
#define BVSzekreny 9
#define BVAgyak 10
#define BVIroasztalok 11
#define BVAjtok 12
#define BVDekTargy 13
#define BVFestmenyek 14
#define BVPadSzonyeg 15
#define BVLampak 16
#define BVHangTechRadio 17
#define BVHangszerek 18
#define BVEgyElEszk 19
#define BVFurdoSzoba 20
#define BVKonyha 21
#define BVNovenyek 22
#define BVEdzogepek 23
#define BVFutes 24
#define BVKandallo 25
#define BVTelevizio 26

#define FrakcioSkinValaszto 27

#define PAYNSPRAYELOTT 2076.2610, -1831.1194, 13.2963
#define PAYNSPRAYBEN 2066.2393, -1831.6442, 13.3786
#define PAYNSPRAYBENZ 89.9833
/* ========================================================= */
#define MAXTD_PHUD (4 + 1)

#define MAX_LOGINDRAW (16 + 1)
/* ========================================================= */

#define BIZTYPEDIALOG "Vegyesbolt\nRuhabolt\nÉtterem\nKajálda, avagy büfé\nKonditerem\nSzexbolt\nSzórakozóhely\nKocsma, avagy Bár\nSztriptíz Klub\nFodrász Üzlet\nTetováló Szalon\nLottózó\nStudió"
#define KONDI "1"
#define LOTTOZO "2"
#define SZTRIPTIZ "3"
#define FODRASZ "4"
#define TETOVALO "5"
#define DISCO "6"
#define RUHA "7"
#define GYETTEREM "8"
#define BAR "9"
#define SEXBOLT "10"
#define ENBOLT "11"
#define ETTEREM "12"
#define STUDIO "13"