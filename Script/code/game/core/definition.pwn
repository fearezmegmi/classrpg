#if defined __game_core_definition
	#endinput
#endif
#define __game_core_definition

#define FLOATFIX	0.00000005

//#define HEX_PREFIX "#"
#define NINCS -1
#define SPAWNID 0

#define TOJAS_BETOLT 0
#define TOJAS_MENT 1

#define MAX_VEHICLE_MODELS 212

#define CAR_Tuningok 30
#define MAXTUNING 14

#define ALAPINTERIORSZAM 1
#define IDOHOZZAADAS 1 // 1h mert túl késõn sötétedik be.
#define MIN_VEHI_ID 400
#define KereskedoSpawnok 2

#define RACE_EPITES -1
#define RACE_NINCS 0
#define RACE_BETOLTVE 1
#define RACE_INDUL 2
#define RACE_ELINDULT 3
#define RACE_VEGE 4
#define RACE_CP_START -1
#define RACE_CP_CEL -2

#define TD_Info 1
#define TD_Info2 2
#define TD_Info3 3
#define TD_Info4 4
#define TD_Info_Weapons 7
#define TD_Info_Ammo 8
#define TD_Info_HUD 9
#define TD_Info_HUD_HEARTH 10
#define TD_Info_BAR_EHSEG 11
#define TD_Info_BAR_PEE 12
#define TD_Info_BAR_ARMOR 130
#define TD_Info_BAR_FOOD 14
#define TD_Info_BAR_TOILET 15
#define TD_Login1 5
#define TD_Login2 6

#define SPAWN_TYPE_FIRST_LOGIN	(0)
#define SPAWN_TYPE_DEFAULT		(1)
#define SPAWN_TYPE_HOUSE		(2)

#define KENDOSLOT 4

#define QUERY_LoadPlayer 1

#define NPC_AKCIO_START (1)
#define NPC_AKCIO_SZUNET (2)
#define NPC_AKCIO_FOLYTAT (3)
#define NPC_AKCIO_STOP (4)
#define NPC_AKCIO_NEMMALLMEG (5)

// CMD Lista
#define CMD_KAPU_BETOLT 1
#define CMD_KAPU_TOROL 2
#define CMD_KAPU_RELOAD 3
#define CMD_SZERVER_RESTART 4
#define CMD_PLAYER_KICK 5
#define CMD_UCP_RUHA 6
#define CMD_UCP_UTALAS 7

#define VAROS_LS 1
#define VAROS_SF 2
#define VAROS_LV 3

//Helyek
#define IsAt_McDonald 1
#define IsAt_Pizzazo 2
#define IsAt_Csirkes 3
#define IsAt_HotDog 9
#define IsAt_Korhaz 10
#define IsAt_Etterem 11
#define IsAt_LSPDBorton 20
#define IsAt_Fort 25
#define IsAt_KereskedoHQ 30
#define IsAt_ATM 31
//#define IsAt_Hotel 32
#define IsAt_Festo 40
#define IsAt_Haz 41
#define IsAt_HazElott 42
#define IsAt_Bank 43
#define IsAt_Buszmegallo 44
#define IsAt_Csokiautomata 45
#define IsAt_Italautomata 46
#define IsAt_Fankos 47
#define IsAt_VLA 48
#define IsAt_Telefonfulke 49
#define IsAt_Szerencsegep 50
#define IsAt_Fegyverkeszitohely 51
#define IsAt_Drogkeszitohely 52
#define IsAt_Viragoskert 53
#define IsAt_Kameraszoba 54
#define IsAt_Almafa 55
#define IsAt_Kordon 56
#define IsAt_SzereloHely 57
#define IsAt_SzereloDuty 58
#define IsAt_SignumDuty 59
#define IsAt_GrafitiTilt 60
#define IsAt_Studio 61
#define IsAt_ArrestHely 62
#define IsAt_BankRobHely 63
#define IsAt_RioMiki 64
#define IsAt_MoriartyMiki 65
#define IsAt_RioPultnal 66
#define IsAt_MoriartyPultnal 67
#define IsAt_szallitHely 68
#define IsAt_bMunkaHely 69

#define VW_HAJLEKTALAN_SZALLO		(146)

#define DrogLeado	-1856.5645, -1617.2384, 21.8472

#define BIZ_Owned 1
#define BIZ_Tulaj 2
#define BIZ_Owner 3
#define BIZ_Message 4
#define BIZ_Extortion 5
#define BIZ_X 6
#define BIZ_Y 7
#define BIZ_Z 8
#define BIZ_ExitX 9
#define BIZ_ExitY 10
#define BIZ_ExitZ 11
#define BIZ_LevelNeeded 12
#define BIZ_BuyPrice 13
#define BIZ_EntranceCost 14
#define BIZ_Till 15
#define BIZ_Locked 16
#define BIZ_Interior 17
#define BIZ_Products 18
#define BIZ_MaxProducts 19
#define BIZ_PriceProd 20
#define BIZ_VanBelso 21
#define BIZ_BNEV 22
#define BIZ_Till2 23
#define BIZ_Szazalek 24
#define BIZ_MTulajID 25
#define BIZ_Aktivsag 26

#define TERULET_Nev 1
#define TERULET_MinX 2
#define TERULET_MaxX 3
#define TERULET_MinY 4
#define TERULET_MaxY 5
#define TERULET_Tulaj 6
//#define TERULET_HaszonMit 7
//#define TERULET_HaszonMennyit 8
#define TERULET_HaszonIdo 9
#define TERULET_Foglalva 10

#define HAZ_X 1
#define HAZ_Y 2
#define HAZ_Z 3
#define HAZ_Belso 4
#define HAZ_Health 5
#define HAZ_Armour 6
#define HAZ_Owner 7
#define HAZ_Tulaj 8
#define HAZ_Value 9
#define HAZ_Hel 10
#define HAZ_Arm 11
#define HAZ_Lock 12
#define HAZ_Owned 13
#define HAZ_Rooms 14
#define HAZ_Rent 15
#define HAZ_Rentabil 16
#define HAZ_Takings 17
#define HAZ_Date 18
#define HAZ_Csak 19
#define HAZ_Csakneki 20
#define HAZ_Kaja 21
#define HAZ_Cigi 22
#define HAZ_Kokain 23
#define HAZ_Heroin 24
#define HAZ_Marihuana 25
#define HAZ_Mati 26
#define HAZ_Tipus 27
#define HAZ_Fegyver 28
#define HAZ_Loszer 29
#define HAZ_Mellenyek 30
#define HAZ_Ruhak 31
#define HAZ_Butorok 32
#define HAZ_Alma 33
#define HAZ_Arany 34
#define HAZ_Kulcsok1 35
#define HAZ_Kulcsok2 36

#define GARAZS_Tulajid 30
#define GARAZS_Eladva 31
#define GARAZS_Tulaj 32
#define GARAZS_X 33
#define GARAZS_Y 34
#define GARAZS_Z 35
#define GARAZS_Ara 36
#define GARAZS_Lock 37
#define GARAZS_Date 38
#define GARAZS_ANGLE 39
#define GARAZS_HAZ 40
#define GARAZS_BELSO 41

#define	BODY_PART_TORSO 3
#define BODY_PART_GROIN 4
#define BODY_PART_LEFT_ARM 5
#define BODY_PART_RIGHT_ARM 6
#define BODY_PART_LEFT_LEG 7
#define BODY_PART_RIGHT_LEG 8
#define BODY_PART_HEAD 9

// SAMP
#define INVALID_3D_TEXT_ID	Text3D:(0xFFFF)
#define MAX_WEAPONS 47
#define WEAPON_COMBAT			27
#define WEAPON_NIGHT_VISION		44
#define WEAPON_THERMAL_GOGGLES	45
#define SPECIAL_ACTION_CUFFED 24
#define SPECIAL_ACTION_PISSING      68

#define INI_TYPE_USERDATA		1
#define INI_TYPE_KUTDATA		2
#define INI_TYPE_TELEFONDATA	3
#define INI_TYPE_FEGYVERRAKTAR	4
#define INI_TYPE_FRAKCIO		5
#define INI_TYPE_OBJECT			6
#define INI_TYPE_OBJECTTORLES	7
#define INI_TYPE_ALFRAKCIO_POLICE 8
#define INI_TYPE_GRAFFITI 		9

#define CAR_TYPE_NONE	0
#define CAR_TYPE_VS		1
#define CAR_TYPE_FK		2
#define CAR_TYPE_MK		3

// jail
#define JAIL_LSPD 1
#define JAIL_ADMIN	3
#define JAIL_NAV 4
#define JAIL_FBI 5
#define JAIL_ADMIN2	6
#define JAIL_FEGYENCTELEP 7

// attachment slots
// 0-5 foglalt a fegyverek miatt, szabad slotok: 6-9
#define ATTACH_SLOT_ZSAK_PAJZS_BILINCS		6
#define ATTACH_SLOT_SISAK					7
#define ATTACH_SLOT_SZEMUVEG				8
#define ATTACH_SLOT_KENDO_MASZK				9

// Városok
#define CITY_OUT			0
#define CITY_LOS_SANTOS		1
#define CITY_SAN_FIERRO		2
#define CITY_LAS_VENTURAS	3

// Térfigyelõ jelzés
#define PLAYER_MARKER_CLEAR			0
#define PLAYER_MARKER_SET			1

#define PLAYER_MARKER_NONE			0
#define PLAYER_MARKER_ENGEDELY		1
#define PLAYER_MARKER_WEAPONHOLD	2
#define PLAYER_MARKER_TARGET		3
#define PLAYER_MARKER_SHOOT			4
#define PLAYER_MARKER_KILL			5
#define PLAYER_MARKER_MKILL			6

#define PLAYER_MARKER_ON_STREAM		10
#define PLAYER_MARKER_ON_REFRESH	11
#define PLAYER_MARKER_ON_MARKER		12
#define PLAYER_MARKER_ON_MARKER_SHOW		121
#define PLAYER_MARKER_ON_MARKER_HIDDEN 		122
#define PLAYER_MARKER_ON_MARKER_CITYEXIT	123

#define PLAYER_MARKER_DEFAULT_JELZES			(PLAYER_MARKER_ENGEDELY)
#define PLAYER_MARKER_DEFAULT_JELZES_TERKEP		(PLAYER_MARKER_ENGEDELY)

// CAR
//Ha változik stock JarmuAlakitas(vs, model) itt írd át!!!
#define CAR_Owned 1
#define CAR_Tulaj 2
#define CAR_Owner 3
#define CAR_Id 4
#define CAR_Model 5
#define CAR_X 6
#define CAR_Y 7
#define CAR_Z 8
#define CAR_Angle 9
#define CAR_Int 10
#define CAR_VW 11
#define CAR_ColorOne 12
#define CAR_ColorTwo 13
#define CAR_Value 14
#define CAR_Lock 15
#define CAR_Date 16
#define CAR_Painted 17
#define CAR_Tuning 18
#define CAR_Kerek 19
#define CAR_Matrica 20
#define CAR_KM 22
#define CAR_Neon 23
#define CAR_Hidraulika 24
#define CAR_Riaszto 25
#define CAR_Olajcsere 26
#define CAR_Kulcsok1 27
#define CAR_Kulcsok2 27
#define CAR_KERESKEDO 28
#define CAR_Detektor 29
#define CAR_Tuningok 30

//index
#define VEHICLE_NONE 0
#define VEHICLE_CAR 1
#define VEHICLE_BOAT 2
#define VEHICLE_TRAIN 3
#define VEHICLE_HELI 4 
#define VEHICLE_PLANE 5
#define VEHICLE_BIKE 6
#define VEHICLE_MONSTERTRUCK 7
#define VEHICLE_QUADBIKE 8
#define VEHICLE_BMX 9
#define VEHICLE_TRAILER 10

// SendMessage
#define SEND_MESSAGE_ADMIN			1
#define SEND_MESSAGE_FRACTION		2
#define SEND_MESSAGE_JOB			3
#define SEND_MESSAGE_PLAYER			4
#define SEND_MESSAGE_SCRIPTER		5
#define SEND_MESSAGE_SSS			6
#define SEND_MESSAGE_COP			7
#define SEND_MESSAGE_IRC			8
#define SEND_MESSAGE_HITMAN			9
#define SEND_MESSAGE_TRUCK			10
#define SEND_MESSAGE_OOCOFF			11
#define SEND_MESSAGE_OOCNEWS		12
#define SEND_MESSAGE_RADIO_D		13
#define SEND_MESSAGE_RADIO			14
#define SEND_MESSAGE_RADIO_SWAT		15
#define SEND_MESSAGE_RADIO_REPULO	16
#define SEND_MESSAGE_ONKENTES		17
#define SEND_MESSAGE_DEPARTMENTS	18
#define SEND_MESSAGE_TAXI			19
#define SEND_MESSAGE_RADIO_RKA		20
#define SEND_MESSAGE_POLICE			21
#define SEND_MESSAGE_SC				22
#define SEND_MESSAGE_FAMILY			23

//0:GS1|1:GS2|2:ETTEREM|3:TUNING|4:BERLES1|5:BERLES2|6:TELEFON|7:OLAJ|8:REZSI|9:IMPORT|10:BUTOR|
//11:HIRDETES|12:FIXCAR|13:247|14:PB|15:CROOKER|16:MCDONALD|17:CSIRKE|18:PIZZA|19:KOCSMA|20:PIGPEN|
//21:AUTOMATA|22:HAJO|23:FANKOS|24:VLA|25:HOTDOG|26:RUHA|27:AUTOSBOLT|28:RIO|29:BERSZEF|30:LOTER|
//31:BIZ_ADASVETELI|32:MORIARTY | 33: RONCSDERBI

//DiscoItallap
#define ITALLAP_RIO 1
#define ITALLAP_MORIARTY 2
#define ITALLAP_KOCSMA 3

#define GPS_SZEMELYES 1
#define GPS_BOLTOK 2
#define GPS_EGYEB 3
#define GPS_BIZNISZEK 4

#define ActorBartender 1 //CreateActor(250, -54.6497,-1138.3451,1.0781, 341.5132);

#define BIZ_GS1 0
#define BIZ_GS2 1
#define BIZ_ETTEREM 2
#define BIZ_TUNING 3
#define BIZ_BERLES1 4
#define BIZ_BERLES2 5
#define BIZ_TELEFON 6
#define BIZ_OLAJ 7
#define BIZ_REZSI 8
#define BIZ_IMPORT 9
#define BIZ_BUTOR 10
#define BIZ_HIRDETES 11
#define BIZ_FIXCAR 12
#define BIZ_247 13
#define BIZ_PB 14
#define BIZ_CROOKER 15
#define BIZ_MCDONALD 16
#define BIZ_CSIRKE 17
#define BIZ_PIZZA 18
#define BIZ_KOCSMA 19
#define BIZ_PIGPEN 20
#define BIZ_AUTOMATA 21
#define BIZ_HAJO 22
#define BIZ_FANKOS 23
#define BIZ_VLA 24
#define BIZ_HOTDOG 25
#define BIZ_RUHA 26
#define BIZ_AUTOSBOLT 27
#define BIZ_RIO 28
#define BIZ_BERSZEF 29
#define BIZ_LOTER 30
#define BIZ_ADASVETELI 31
#define BIZ_MORIARTY 32
#define BIZ_RONCSDERBI 33

//Dialog
#define DIALOG_NINCS				(0)
#define DIALOG_CUSTOM				(32765)
#define DIALOG_REGISTRATION 		(10)
#define DIALOG_LOGIN 				(11)
#define DIALOG_MUNKA_LEGALIS 		(12)
#define DIALOG_MUNKA_ILLEGALIS 		(13)
#define DIALOG_BELSO 				(14)
#define DIALOG_GOTO 				(15)
#define DIALOG_CAR 					(16)
//#define DIALOG_ADO 				(17)
#define DIALOG_VESZ 				(18)
//#define DIALOG_KOCSI 				(19)
#define DIALOG_FBI 					(19)
#define DIALOG_BEP 					(20)
#define DIALOG_GABI 				(21)
#define DIALOG_RACETUNING 			(22)
#define DIALOG_RACETUNING_2 		(23)
#define DIALOG_AJSZOVEG 			(24)
#define DIALOG_AUTOTOLVAJ 			(25)
#define DIALOG_NEON 				(26)
#define DIALOG_KINCS 				(27)
#define DIALOG_C4 					(28)
#define DIALOG_NYELV_HASZNAL 		(29)
#define DIALOG_NYELV_TANUL 			(30)
#define DIALOG_ITEMS 				(31)
#define DIALOG_PIAC 				(32)
#define DIALOG_AVESZ 				(33)
#define DIALOG_PARANCSOK 			(34)
#define DIALOG_FEJLESZTESEK 		(35)
#define DIALOG_BBSZ 				(36)
#define DIALOG_ABSZ 				(37)
#define DIALOG_BBSZ_BELEPES 		(38)
#define DIALOG_BBSZ_KIJELZES 		(39)
#define DIALOG_BBSZ_BEFIZETES 		(40)
#define DIALOG_BBSZ_KIVETEL 		(41)
#define DIALOG_BBSZ_UTALAS_1 		(42)
#define DIALOG_BBSZ_UTALAS_2 		(43)
#define DIALOG_ABSZ_BELEPES 		(44)
#define DIALOG_ABSZ_KIJELZES 		(45)
#define DIALOG_ABSZ_KIVETEL 		(46)
#define DIALOG_BBSZ_JELSZOVALTAS	(47)
#define DIALOG_CCOK_SZERZODES		(48)
#define DIALOG_URES					(49)
#define DIALOG_ADMIN_UZENET			(50)
#define KOCSIRADIO_SAJAT			(51)
#define KOCSIRADIO_SAJATURL			(52)
#define KERESKEDO_INFO				(53)
#define DIALOG_BBSZ_SMS				(54)
#define DIALOG_DERBI_KOCSIVALASZT	(55)
#define DIALOG_DERBI_KOCSIMODEL		(56)
#define DIALOG_DERBI_BELEPES		(57)
#define DIALOG_DERBI_FKOCSIMODEL	(58)
#define DIALOG_GOTO_MENU			(59)
#define DIALOG_GYVESZ				(60)
#define DIALOG_SHORT_VEDELEM		(61)
#define DIALOG_PAINTBALL_FEGYVEREK	(62)
#define DIALOG_PAINTBALL_FVALASZT 	(63)
#define DIALOG_KAMION 				(70)
#define DIALOG_FRISSITES_UZENET 	(71)
#define DIALOG_ADJUSTWEAPONS 		(72)
#define DIALOG_ADJUSTWEAPONS_A 		(73)
#define DIALOG_ADJUSTWEAPONS_P 		(74)
#define DIALOG_ADJUSTWEAPONS_M 		(75)
#define DIALOG_ADJUSTWEAPONS_SR 	(76)
#define DIALOG_ADJUSTWEAPONS_S 		(77)
#define MP4_YOUTUBEURL 				(78)
#define DIALOG_GRAFFITI				(79)
#define DIALOG_GRAFFITI_KESZIT		(80)
#define DIALOG_GRAFFITI_SZIN		(81)
#define DIALOG_GRAFFITI_TIPUS		(82)
#define DIALOG_GRAFFITI_IDO			(83)
#define DIALOG_GRAFFITI_GRAFFITIK	(84)
#define DIALOG_GRAFFITI_ADMIN		(85)
#define DIALOG_GRAFFITI_INFO		(86)
#define DIALOG_GRAFFITI_SZERKESZT	(87)
#define DIALOG_HELP					(88)
#define DIALOG_HELP_MUNKA			(89)
#define DIALOG_GPS					(90)
#define DIALOG_GPS_LISTA			(91)
#define DIALOG_GPS_LISTA_FUNK		(92)
#define DIALOG_GPS_ADMIN			(93)
#define DIALOG_GPS_ADMIN_VALASZT	(94)
#define DIALOG_GPS_ADMIN_NEV		(95)
#define DIALOG_GPS_POZ				(96)
#define DIALOG_GPS_ADMIN_TOROL		(97)
#define DIALOG_GPS_HAZ				(98)
#define DIALOG_GPS_POZICIO			(99)
#define DIALOG_GPS_KOCSIM			(100)
#define DIALOG_GPS_GARAZS			(101)
#define DIALOG_GPS_BIZNISZ			(102)
#define DIALOG_GPS_BENZINKUT		(103)
#define DIALOG_GPS_RACE				(104)


#define DIALOG_ZSEBRADIO 			(6234) //MP4 dialogja
#define DIALOG_KOCSIRADIO 			(6474) //Kocsirádió dialogja
#define DIALOG_APANEL 				(6475)
#define DIALOG_BUTOR_PREMIUM		(9877)
#define DIALOG_BUTOR				(9878)
#define DIALOG_SZABAD_BUTOROK 		(9879)
#define DIALOG_BUTOR_VETEL	 		(9880)
#define	DIALOG_BUTOR_SZERKESZTES	(9881)
#define DIALOG_BUTOR_KATEGORIA		(9882)
#define DIALOG_BUTOR_ASZTAL			(9883)
#define DIALOG_SZABAD_BUTOROK_LISTA	(9884)
#define DIALOG_BUTOR_MEGVETEL		(9885)
#define DIALOG_BUTOR_TORLES			(9886)
#define DIALOG_KAPU_STATISZTIKA		(9887)
#define DIALOG_KAPU_MODEL			(9888)
#define DIALOG_KAPU_TAVOLSAG		(9889)
#define DIALOG_KAPU_FRAKCIO			(9890)
#define DIALOG_KAPU_SZERKESZTES		(9891)
#define DIALOG_KAPU_TORLES			(9892)
#define DIALOG_KAPU_POZICIO			(9893)
#define DIALOG_KAPU_SEBESSEG		(9894)
#define DIALOG_KAPU_FRAKCIO_SZERK	(9895)
#define DIALOG_KAPU_NEV				(9896)
#define DIALOG_KAPU_NEV_SZERKESZTES	(9897)
#define DIALOG_KAPU_TAV_SZERKESZTES	(9898)
#define DIALOG_KAPU_VALASZTAS		(9899)
#define DIALOG_KAPU_KOD				(9900)
#define DIALOG_KAPU_KOD_SZERKESZTES	(9901)
#define DIALOG_KALAKIT_MEGEROSIT	(9902)
#define DIALOG_KALAKITAR_MEGEROSIT	(9903)
#define DIALOG_MSGINFO				(9904) //Mindennek ami csak infót ír ki.
#define DIALOG_OBJECT_TORLES		(9905)
#define DIALOG_TEXTDRAW_COLOR		(9906)
#define DIALOG_KAPU_NYIT_SZERK 		(9907)
#define DIALOG_KAPU_NYITAS			(9908)

//Munkák folyamatai
#define M_CSERJE 1
#define M_MAK 2
#define M_CANNABIS 3
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
#define M_RUHACSERE 25
#define M_RUHAELVESZ 26
#define M_HATASTALANIT 27
#define M_NYELVTANULAS 28
#define M_JARMUJAVITAS 29
#define M_KAMION 30
#define M_SZEREL 31
#define M_FELJAVIT 32
#define M_LSRABOL 33
#define M_HARCVEGE 33
#define M_BICIKLI 34
#define M_KISZAL 35
#define M_KISZALELL 36
#define M_FLY 37
#define M_IDK 38
#define M_FELTOLT 39
#define M_UGRALOS 40
#define M_NEON 41
#define M_GUMICSERE 42
#define M_VHKAPU1 43
#define M_VHKAPU2 44
#define M_RIASZTO 45
#define M_ELLAT 46
#define M_KOCSIDEATH 47
#define M_BENZINTRAILER 48
#define M_TVVEGE 49
#define M_PILOTAKEZD 50
#define M_PILOTAVEGE 51
#define M_BOLTRABLAS 52
#define M_ELLAT2 53
#define M_OLAJCSERE 54
#define M_SZEMETLERAKAS 55
#define M_LAPTOP_KIBE 56
#define M_WIFICONNECT 57
#define M_OZELLATAS 58
#define M_Object_Torol 59
#define M_CSOMAGLEPAKOL 60
#define M_CSOMAGFELPAKOL 61
#define M_BANYASZ_SZALLIT_VEGE 62
#define M_BANYASZ_SZALLIT_KEZD 63
#define M_BANYASZ_KO 64
#define M_BANYASZ_FELDOLGOZ 65
#define M_VILLANYSZERELO_VIZSGAL 66
#define M_VILLANYSZERELO_OSZLOP 67
#define M_SZOKTET 68
#define M_BBANYASZ 69
#define M_BTAKARITO 70
#define M_GRAFFITI 71

// Key state definitions
#define MOVE_FORWARD    		1
#define MOVE_BACK       		2
#define MOVE_LEFT       		3
#define MOVE_RIGHT      		4
#define MOVE_FORWARD_LEFT       5
#define MOVE_FORWARD_RIGHT      6
#define MOVE_BACK_LEFT          7
#define MOVE_BACK_RIGHT         8

#define MUNKA_BENZIN 800
//Alapmunkák
#define MAX_MUNKAKOCSI 100
#define MAX_MUNKA 30
#define MUNKA_BARKI 0
#define MUNKA_DETEKTIV 1
#define MUNKA_PROSTI 2
#define MUNKA_DROG 3
#define MUNKA_AUTOTOLVAJ 4
#define MUNKA_SZERELO 5
#define MUNKA_FEGYVER 6
#define MUNKA_PILOTA 7
#define MUNKA_UTTISZTITO 8
#define MUNKA_BUS 9
#define MUNKA_HACKER 10
#define MUNKA_KAMIONOS 11
#define MUNKA_FARMER 12
#define MUNKA_FUNYIRO 13
#define MUNKA_PANCEL 14
#define MUNKA_KUKAS 15
#define MUNKA_FAVAGO 16
#define MUNKA_HULLA 17
#define MUNKA_TAXI 18 //nincs
#define MUNKA_SWAT 19
#define MUNKA_BEREL1 20
#define MUNKA_BEREL2 21
#define MUNKA_BEREL3 22
#define MUNKA_SSS 23
#define MUNKA_CROSS 24
#define MUNKA_PENZ 25
#define MUNKA_ONKENTES 26
#define MUNKA_VADASZ 27
#define MUNKA_BANYASZ 28
#define MUNKA_VILLANYSZERELO 29
//börtön munka
#define MUNKA_BTAKARITO 50
#define MUNKA_BBANYASZ 51

//Tárgy mûveletek
#define ITEM_LOAD 1
#define ITEM_SAVE 2
#define ITEM_ADD 3
#define ITEM_REMOVE 4
#define ITEM_DELETE 5
#define ITEM_CHECK 6
#define ITEM_NAME 7
#define ITEM_DATA 8
	#define ITEM_DATA_TYPE 1
	#define ITEM_DATA_COUNT 2
	#define ITEM_DATA_E1 3 
	#define ITEM_DATA_E2 4
	#define ITEM_DATA_E3 5
	
//Nyelvek
#define NYELV_ANGOL 1
#define NYELV_NEMET 2
#define NYELV_OROSZ 3
#define NYELV_OLASZ 4
#define NYELV_JAPAN 5
#define NYELV_KINAI 6
#define NYELV_SPANYOL 7
#define NYELV_TOROK 8
#define NYELV_SZLOVAK 9
#define NYELV_LENGYEL 10
#define NYELV_HOLLAND 11

//Örök jó tanács sose akarj id 0-át by terno	
//Leaderes melók
#define FRAKCIO_SCPD 1
#define FRAKCIO_FBI 2
#define FRAKCIO_SONSOFANARCHY 3
#define FRAKCIO_MENTO 4
#define FRAKCIO_COSANOSTRA 5
#define FRAKCIO_YAKUZA 6
#define FRAKCIO_ONKORMANYZAT 7
#define FRAKCIO_AZTEC 8
#define FRAKCIO_RIPORTER 9
#define FRAKCIO_TAXI 10
#define FRAKCIO_VAGOS 11
#define FRAKCIO_TUZOLTO 12
#define FRAKCIO_KATONASAG 13
#define FRAKCIO_SFPD 14
#define FRAKCIO_NEMHASZ 15
#define FRAKCIO_OKTATO 16
#define FRAKCIO_GSF 17
#define FRAKCIO_SFTAXI 18
#define FRAKCIO_SFMENTO 19
#define FRAKCIO_NAV 20
#define FRAKCIO_TURKEY 21

// Bone IDs
#define BONE_SPINE				1
#define BONE_HEAD				2
#define BONE_LEFT_UPPER_ARM		3
#define BONE_RIGHT_UPPER_ARM	4
#define BONE_LEFT_HAND			5
#define BONE_RIGHT_HAND			6
#define BONE_LEFT_THIGHT		7
#define BONE_RIGHT_THIGHT		8
#define BONE_LEFT_FOOT			9
#define BONE_RIGHT_FOOT			10
#define BONE_RIGHT_CALF			11
#define BONE_LEFT_CALF			12
#define BONE_LEFT_FOREARM		13
#define BONE_RIGHT_FOREARM		14
#define BONE_LEFT_CLAVICLE		15
#define BONE_RIGHT_CLAVICLE		16
#define BONE_NECK				17
#define BONE_JAW				18

// Barok
#define BAR_EHSEG 1
#define BAR_SZUKSEGLET 2

#define VEHICLE_TYPES_START		400
#define VEHICLE_TYPES_END		611
#define VEHICLE_TYPES 			(VEHICLE_TYPES_END - VEHICLE_TYPES_START + 1)

#define VEHICLE_TYPE_BIKE 		1
#define VEHICLE_TYPE_MOTOR		2
#define VEHICLE_TYPE_CAR 		4
#define VEHICLE_TYPE_TRAIN		8
#define VEHICLE_TYPE_BOAT		16
#define VEHICLE_TYPE_HELI		32
#define VEHICLE_TYPE_PLANE		64
#define VEHICLE_TYPE_MINI		128
#define VEHICLE_TYPE_TRAILER	256

// SQL-Types
#define SQL_LOAD_HOUSE 11
#define SQL_LOAD_CAR 12
#define SQL_LOAD_BIZ 13
#define SQL_LOAD_GARAZS 14
#define SQL_LOAD_TERULET 15
#define SQL_LOAD_CARPRICE 16
#define SQL_LOAD_RACE 17
#define SQL_LOAD_CMD 18
#define SQL_LOAD_CMD2 19
#define SQL_LOAD_BERSZEF 96
#define SQL_LOAD_BUTOROK 98

#define SQL_SYSTEM_KAPU 21
#define SQL_SYSTEM_VERSION 22
#define SQL_SYSTEM_UCP 23

#define SQL_FRACTION_COUNT_LEADER 31
#define SQL_FRACTION_COUNT_MEMBER 32

#define SQL_PLAYER_LOGIN 41
#define SQL_PLAYER_STAT 42
#define SQL_PLAYER_PRECONFIGURE 43
#define SQL_KAPU_IDTOLTES 44
#define SQL_ADATLEKERES 45

#define SQL_CC_LOGIN	101
#define SQL_CC_DETECT	102
#define SQL_CC_BAN		103
#define SQL_RACE_SAVE	104
#define SQL_RACE_LISTA	105

#define SQL_CMD_CHEAT	201

//type
#define EVENT_TYPE_RIO 1
#define EVENT_TYPE_USERDATA 2
#define EVENT_TYPE_MORIARTY 3
//action
#define EVENT_ACTION_ENTER 1
#define EVENT_ACTION_EXIT 2
#define EVENT_ACTION_LOAD 3
#define EVENT_ACTION_SAVE 4

#define SKIN_MIN			1
#define SKIN_MAX			311
#define SKIN_COUNT			(SKIN_MAX - SKIN_MIN + 1)
#define SKIN_ZAROLT_MAX 	30
#define SKIN_FRAKCIO_MAX	30

#define ITEM_ALMA	1

// Players Mode
#define CAMERA_MODE_NONE    	0
#define CAMERA_MODE_FLY     	1

//Datepropok
#define DP_Kocsi 1
#define DP_Haz 2
#define DP_Biz 3
#define DP_Garazs 4

#define AKTASLOT 4

// Piac
#define P_LOAD 0
#define P_SAVE 1
#define P_KI_KOKAIN 0
#define P_KI_HEROIN 1
#define P_KI_MARIHUANA 2
#define P_KI_MATERIAL 3
#define P_KE_KOKAIN 4
#define P_KE_HEROIN 5
#define P_KE_MARIHUANA 6
#define P_KE_MATERIAL 7
#define P_ALL -1

//stockos funkciók
#define STOCK_Ellenoriz 1

//Adatbetöltés
#define ADAT_TYPE_AKTIVITAS 1

#define STAT_ACTIVITY_IDO		(1)
#define STAT_ACTIVITY_ONDUTY	(2)

// deldeldel
#endinput
#define Skin:%0:%1 			Skin_%0[%1]
new Skin_Civil[SKIN_COUNT] = {0, ...};
new Skin_Zarolt[SKIN_ZAROLT_MAX] = {0, ...};
new Skin_Frakcio[MAX_FRAKCIO][SKIN_FRAKCIO_MAX] = {
	/*FRAKCIO_SCPD     - 1  */ {2},
	/*FRAKCIO_FBI      - 2  */ {3},
	/*FRAKCIO_BALLAS   - 3  */ {4},
	/*FRAKCIO_MENTO    - 4  */ {5},
	/*FRAKCIO_ALBAN    - 5  */ {6},
	/*FRAKCIO_YAKUZA   - 6  */ {7},
	/*FRAKCIO_KORMANY  - 7  */ {8},
	/*FRAKCIO_AZTEC    - 8  */ {9},
	/*FRAKCIO_RIPORTER - 9  */ {1},
	/*FRAKCIO_TAXI     - 10 */ {2},
	/*FRAKCIO_VAGOS    - 11 */ {3},
	/*FRAKCIO_TUZOLTO  - 12 */ {4},
	/*FRAKCIO_         - 13 */ {5},
	/*FRAKCIO_SFPD     - 14 */ {6},
	/*FRAKCIO_         - 15 */ {7},
	/*FRAKCIO_OKTATO   - 16 */ {8},
	/*FRAKCIO_GSF      - 17 */ {9},
	/*FRAKCIO_         - 18 */ {1},
	/*FRAKCIO_         - 19 */ {2},
	/*FRAKCIO_NAV      - 20 */ {3},
	/*FRAKCIO_TURKEY   - 21 */ {4}
};

#define SKIN_CIVIL		1
#define SKIN_LSPD		2
#define SKIN_FBI		4
#define SKIN_BALLAS		8
#define SKIN_MENTO		16
#define SKIN_ALBAN		32
#define SKIN_YAKUZA		64
#define SKIN_KORMANY	128
#define SKIN_AZTEC		256
#define SKIN_RIPORTER	512
#define SKIN_TAXI		1024
#define SKIN_VAGOS		1
#define SKIN_TUZOLTO	1
#define SKIN_VALAMI_A	1
#define SKIN_SFPD		1
#define SKIN_VALAMI_B	1
#define SKIN_OKTATO		1
#define SKIN_GSF		1
#define SKIN_VALAMI_C	1
#define SKIN_VALAMI_D	1
#define SKIN_NAV		1
#define SKIN_TURKEY		1

stock Float:floatrand(Float:min, Float:max)
{
	new imin = floatround(min);
	return floatdiv(float(random((floatround(max)-imin)*100)+(imin*100)),100.0);
}
