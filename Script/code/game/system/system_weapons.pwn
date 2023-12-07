#if defined __game_system_system_weapons
	#endinput
#endif
#define __game_system_system_weapons

/*
	WeaponArm(playerid, weapon = 0) 							- fegyver el?vétel/elrakás - RETURN: true/false
	WeaponCanHave(playerid, weapon) 							- lehet-e nála ilyen fegyver - RETURN: true/false
	WeaponCanHoldWeapon(playerid, weapon, maxweapon = 1) 		- tudja e viselni a fegyvert (van-e hely, stb.) - RETURN: slot, NINCS vagy ErrorID
	WeaponCanHoldAmmo(playerid, weapon, ammo) 					- van-e hely további tölténynek - RETURN: true/false
	WeaponHaveWeapon(playerid, weapon) 							- van e ilyen fegyvere - RETURN: NINCS vagy pedig slot
	WeaponHaveAmmo(playerid, weapon, ammo) 						- van e annyi l?szere - RETURN: true/false
	WeaponGiveWeapon(playerid, weapon, ammo = 0, maxweapon = 1) - fegyveradás - RETURN: sikeres fegyveradásnál slot vagy pedig HIBA ID
	WeaponGiveAmmo(playerid, weapon, ammo) 						- töltényadás - RETURN: true/false
	WeaponTakeWeapon(playerid, weapon) 							- fegyver elvétel - RETURN: true/false
	WeaponTakeAmmo(playerid, weapon) 							- töltény elvétel - RETURN: true/false
	WeaponResetWeapons(playerid) 								- fegyverek törlése - RETURN: nincs
	WeaponResetAmmos(playerid) 									- töltények törlése - RETURN: nincs
	WeaponResetAll(playerid) 									- fegyverek és töltények törlése - RETURN: nincs
	WeaponRefreshAttachments(playerid) 							- játékoshoz csatolt fegyver objectek frissítése - RETURN: true
	WeaponProblem(playerid, problem) 							- anticheat kérések feldolgozása - RETURN: true/false
	WeaponAmmo(targetid, w)
*/

// attach slots
#define WEAPON_SLOT_MP5			0
#define WEAPON_SLOT_SHOTGUN		1
#define WEAPON_SLOT_SNIPER		2
#define WEAPON_SLOT_M4_AK47		3
#define WEAPON_SLOT_PISTOL		4

#define WEAPON_TYPE_HAND	1
#define WEAPON_TYPE_THROWN	2
#define WEAPON_TYPE_PISTOL	4
#define WEAPON_TYPE_SHOTGUN	8
#define WEAPON_TYPE_SUBGUN	16
#define WEAPON_TYPE_ARIFLE	32
#define WEAPON_TYPE_RIFLE	64
#define WEAPON_TYPE_HEAVY	128

#define MAX_AMMO_TYPES		5
#define AMMO_TYPE_NORMAL	0
#define AMMO_TYPE_EXTRA		1	// +25% sebzés
#define AMMO_TYPE_PENET		2	// pajzsot átüti, azonban csak 25%os életsebzést okoz
#define AMMO_TYPE_BLOOD		3	// találat esetén vérzést okoz, 5 másodpercig 25%/sec
#define AMMO_TYPE_SUPER		4	// +10% sebzés, pajzs átütés (10%os), találat esetén vérzés 3 másodpercig 10%/sec

enum weaponPrice
{
	wWeapon,
	wAmmo,
	wWeaponMat,
	wAmmoMat,
}

new const WeaponPrice[MAX_WEAPONS][weaponPrice] =
{
	{     0,    0,     0,    0}, //  0 - ököl
	{     0,    0,     0,    0}, //  1 - bokszer
	{     0,    0,     0,    0}, //  2 - golfüt?
	{     0,    0,     0,    0}, //  3 - gumibot
	{125000,    0,     0,    0}, //  4 - kés
	{ 50000,    0,     0,    0}, //  5 - baseball üto
	{     0,    0,     0,    0}, //  6 - ásó
	{     0,    0,     0,    0}, //  7 - dákó
	{500000,    0,     0,    0}, //  8 - katana
	{     0,    0,     0,    0}, //  9 - láncf?rész
	{     0,    0,     0,    0}, // 10 - purple dildo
	{     0,    0,     0,    0}, // 11 - short vibrator
	{     0,    0,     0,    0}, // 12 - long vibrator
	{     0,    0,     0,    0}, // 13 - white dildo
	{     0,    0,     0,    0}, // 14 - virág
	{     0,    0,     0,    0}, // 15 - sétabot
	{     0,    0,     0,    0}, // 16 - gránát
	{     0,    0,     0,    0}, // 17 - füstbomba
	{     0,    0,     0,    0}, // 18 - molotov
	{     0,    0,     0,    0}, // 19 - 
	{     0,    0,     0,    0}, // 20 - 
	{     0,    0,     0,    0}, // 21 - 
	{100000,  200,  2500,    5}, // 22 - colt
	{150000,  200,  3500,    5}, // 23 - silenced
	{250000,  400,  4500,   10}, // 24 - deagle
	{300000, 5000, 25000,  375}, // 25 - shotgun
	{     0,    0,     0,    0}, // 26 - sawn-off
	{     0,    0,     0,    0}, // 27 - combat
	{     0,    0,     0,    0}, // 28 - uzi
	{	  0,    0, 50000,  200}, // 29 - mp5
	{     0,    0,     0,  500}, // 30 - ak47
	{     0,    0,     0,    0}, // 31 - m4
	{     0,    0,     0,    0}, // 32 - tec9
	{300000, 4000, 20000,  500}, // 33 - rifle
	{     0,    0, 	   0, 	 0}, // 34 - sniper
	{     0,    0,     0,    0}, // 35 - rakÃ©ta
	{     0,    0,     0,    0}, // 36 - hÃµ rakÃ©ta
	{     0,    0,     0,    0}, // 37 - lÃ¡ngszÃ³rÃ³
	{     0,    0,     0,    0}, // 38 - minigun
	{     0,    0,     0,    0}, // 39 - c4
	{     0,    0,     0,    0}, // 40 - detonÃ¡tor
	{     0,    0,     0,    0}, // 41 - sprÃ©
	{     0,    0,     0,    0}, // 42 - poroltÃ³
	{     0,    0,     0,    0}, // 43 - kamera
	{     0,    0,     0,    0}, // 44 - Ã©jellÃ¡tÃ³
	{     0,    0,     0,    0}, // 45 - hÃµlÃ¡tÃ³
	{ 10000,    0,   500,    0}  // 46 - ejtÃµernyÃµ
};

#define WEAPON_PRICES_CASH	1
#define WEAPON_PRICES_MATS	2
stock WeaponPrices(playerid, type, color)
{
	if(type == WEAPON_PRICES_CASH)
	{
		SendFormatMessage(playerid, color, "[Ütõfegyverek] kés %sFt, baseball üt?: %sFt, katana: %sFt", \
			FormatInt(WeaponPrice[WEAPON_KNIFE][wWeapon]), FormatInt(WeaponPrice[WEAPON_BAT][wWeapon]), FormatInt(WeaponPrice[WEAPON_KATANA][wWeapon]));
			
		SendFormatMessage(playerid, color, "[Pisztoly] colt: %sFt, silenced: %sFt, deagle: %sFt", \
			FormatInt(WeaponPrice[WEAPON_COLT45][wWeapon]), FormatInt(WeaponPrice[WEAPON_SILENCED][wWeapon]), FormatInt(WeaponPrice[WEAPON_DEAGLE][wWeapon]));
			
		SendFormatMessage(playerid, color, "[Lõfegyver] shotgun: %sFt, rifle: %sFt", \
			FormatInt(WeaponPrice[WEAPON_SHOTGUN][wWeapon]), FormatInt(WeaponPrice[WEAPON_RIFLE][wWeapon]));
			
		SendFormatMessage(playerid, color, "[Lõszer] colt: %sFt, silenced: %sFt, deagle: %sFt, shotgun: %sFt, rifle: %sFt", \
			FormatInt(WeaponPrice[WEAPON_COLT45][wAmmo]), FormatInt(WeaponPrice[WEAPON_SILENCED][wAmmo]), FormatInt(WeaponPrice[WEAPON_DEAGLE][wAmmo]), \
			FormatInt(WeaponPrice[WEAPON_SHOTGUN][wAmmo]), FormatInt(WeaponPrice[WEAPON_RIFLE][wAmmo]));
			
		SendFormatMessage(playerid, color, "[Ejtõernyõ] %dFt", FormatInt(WeaponPrice[WEAPON_PARACHUTE][wAmmo]));
	}
	else if(type == WEAPON_PRICES_MATS)
	{
		SendFormatMessage(playerid, color, "[Pisztoly] colt: %sdb, silenced: %sdb, deagle: %sdb", \
			FormatInt(WeaponPrice[WEAPON_COLT45][wWeaponMat]), FormatInt(WeaponPrice[WEAPON_SILENCED][wWeaponMat]), FormatInt(WeaponPrice[WEAPON_DEAGLE][wWeaponMat]));
			
		SendFormatMessage(playerid, color, "[Lõfegyver] mp5: %sdb, shotgun: %sdb, rifle: %sdb", \
			FormatInt(WeaponPrice[WEAPON_MP5][wWeaponMat]), FormatInt(WeaponPrice[WEAPON_SHOTGUN][wWeaponMat]), FormatInt(WeaponPrice[WEAPON_RIFLE][wWeaponMat]));
			
		SendClientMessage(playerid, color, "[Lõfegyver] ak47: 2db fém");
			
		SendFormatMessage(playerid, color, "[Lõszer] colt: %sdb, silenced: %sdb, deagle: %sdb, mp5: %sdb, shotgun: %sdb", \
			FormatInt(WeaponPrice[WEAPON_COLT45][wAmmoMat]), FormatInt(WeaponPrice[WEAPON_SILENCED][wAmmoMat]), FormatInt(WeaponPrice[WEAPON_DEAGLE][wAmmoMat]), \
			FormatInt(WeaponPrice[WEAPON_MP5][wAmmoMat]), FormatInt(WeaponPrice[WEAPON_SHOTGUN][wAmmoMat]));
			
		SendFormatMessage(playerid, color, "[Lõszer] rifle: %sdb, ak47: %sdb", \
			FormatInt(WeaponPrice[WEAPON_RIFLE][wAmmoMat]), FormatInt(WeaponPrice[WEAPON_AK47][wAmmoMat]));
	}
	
	return 1;
}

enum weaponData
{
	wObject,
	wSlot,
	wType,
	wAmmo,
	wTiltott
}

new const WeaponData[MAX_WEAPONS][weaponData] =
{
	// object, slot, type, maxammo
	{1575,  0, WEAPON_TYPE_HAND,       0, false}, //  0 - ököl
	{ 331,  0, WEAPON_TYPE_HAND,       0, false}, //  1 - bokszer
	{ 333,  1, WEAPON_TYPE_HAND,       0, false}, //  2 - golfüt?
	{ 334,  1, WEAPON_TYPE_HAND,       0, false}, //  3 - gumibot
	{ 335,  1, WEAPON_TYPE_HAND,       0, false}, //  4 - kés
	{ 336,  1, WEAPON_TYPE_HAND,       0, false}, //  5 - baseball üt?
	{ 337,  1, WEAPON_TYPE_HAND,       0, false}, //  6 - ásó
	{ 338,  1, WEAPON_TYPE_HAND,       0, false}, //  7 - dákó
	{ 339,  1, WEAPON_TYPE_HAND,       0, false}, //  8 - katana
	{ 341,  1, WEAPON_TYPE_HAND,       0, false}, //  9 - láncf?rész
	{ 321, 10, WEAPON_TYPE_HAND,       0, false}, // 10 - purple dildo
	{ 322, 10, WEAPON_TYPE_HAND,       0, false}, // 11 - short vibrator
	{ 323, 10, WEAPON_TYPE_HAND,       0, false}, // 12 - long vibrator
	{ 324, 10, WEAPON_TYPE_HAND,       0, false}, // 13 - white dildo
	{ 325, 10, WEAPON_TYPE_HAND,       0, false}, // 14 - virág
	{ 326, 10, WEAPON_TYPE_HAND,       0, false}, // 15 - sétabot
	{ 342,  8, WEAPON_TYPE_THROWN,    50, false}, // 16 - gránát
	{ 343,  8, WEAPON_TYPE_THROWN,    50, false}, // 17 - füstbomba
	{ 344,  8, WEAPON_TYPE_THROWN,    50, false}, // 18 - molotov
	{1575,  0, 0, 0, false}, // 19 - 
	{1575,  0, 0, 0, false}, // 20 - 
	{1575,  0, 0, 0, false}, // 21 - 
	{ 346,  2, WEAPON_TYPE_PISTOL,  2000, false}, // 22 - colt
	{ 347,  2, WEAPON_TYPE_PISTOL,  2000, false}, // 23 - silenced
	{ 348,  2, WEAPON_TYPE_PISTOL,  2000, false}, // 24 - deagle
	{ 349,  3, WEAPON_TYPE_SHOTGUN, 2000, false}, // 25 - shotgun
	{ 350,  3, WEAPON_TYPE_SHOTGUN, 2000, false}, // 26 - sawn-off
	{ 351,  3, WEAPON_TYPE_SHOTGUN, 2000, true}, // 27 - combat
	{ 352,  4, WEAPON_TYPE_SUBGUN,  8000, false}, // 28 - uzi
	{ 353,  4, WEAPON_TYPE_SUBGUN,  8000, false}, // 29 - mp5
	{ 355,  5, WEAPON_TYPE_ARIFLE,  8000, false}, // 30 - ak47
	{ 356,  5, WEAPON_TYPE_ARIFLE,  8000, false}, // 31 - m4
	{ 372,  4, WEAPON_TYPE_SUBGUN,  8000, false}, // 32 - tec9
	{ 357,  6, WEAPON_TYPE_RIFLE,   2000, false}, // 33 - rifle
	{ 358,  6, WEAPON_TYPE_RIFLE,   2000, false}, // 34 - sniper
	{ 359,  7, WEAPON_TYPE_HEAVY,     25, false}, // 35 - rakéta
	{ 360,  7, WEAPON_TYPE_HEAVY,     25, false}, // 36 - h? rakéta
	{ 361,  7, WEAPON_TYPE_HEAVY,      0, false}, // 37 - lángszóró
	{ 362,  7, WEAPON_TYPE_HEAVY,      0, true}, // 38 - minigun
	{ 363,  8, WEAPON_TYPE_THROWN,     0, false}, // 39 - c4
	{ 364, 12, 0, 0, false}, // 40 - detonátor
	{ 365,  9, WEAPON_TYPE_HAND,    9000, false}, // 41 - spré
	{ 366,  9, WEAPON_TYPE_HAND,    9000, false}, // 42 - poroltó
	{ 367,  9, WEAPON_TYPE_HAND,       0, false}, // 43 - kamera
	{ 368, 11, WEAPON_TYPE_HAND,       0, false}, // 44 - éjellátó
	{ 369, 11, WEAPON_TYPE_HAND,       0, false}, // 45 - h?látó
	{ 371, 11, WEAPON_TYPE_HAND,       0, false}  // 46 - ejt?erny?
};

/*enum weaponOffset
{
	wBone,
	Float:wOff[3],
	Float:wRot[3],
	wIndex
}

new const WeaponOffset[MAX_WEAPONS][weaponOffset] =
{
	// bone, offset, rotation, index
	{ 0, {0.0,0.0,0.0}, {0.0,0.0,0.0}, 0}, //  0 - ököl
	{ 0, {0.0,0.0,0.0}, {0.0,0.0,0.0}, 0}, //  1 - bokszer
	{ 0, {0.0,0.0,0.0}, {0.0,0.0,0.0}, 0}, //  2 - golfüt?
	{ 0, {0.0,0.0,0.0}, {0.0,0.0,0.0}, 0}, //  3 - gumibot
	{ 0, {0.0,0.0,0.0}, {0.0,0.0,0.0}, 0}, //  4 - kés
	{ 0, {0.0,0.0,0.0}, {0.0,0.0,0.0}, 0}, //  5 - baseball üt?
	{ 0, {0.0,0.0,0.0}, {0.0,0.0,0.0}, 0}, //  6 - ásó
	{ 0, {0.0,0.0,0.0}, {0.0,0.0,0.0}, 0}, //  7 - dákó
	{ 0, {0.0,0.0,0.0}, {0.0,0.0,0.0}, 0}, //  8 - katana
	{ 0, {0.0,0.0,0.0}, {0.0,0.0,0.0}, 0}, //  9 - láncf?rész
	{ 0, {0.0,0.0,0.0}, {0.0,0.0,0.0}, 0}, // 10 - purple dildo
	{ 0, {0.0,0.0,0.0}, {0.0,0.0,0.0}, 0}, // 11 - short vibrator
	{ 0, {0.0,0.0,0.0}, {0.0,0.0,0.0}, 0}, // 12 - long vibrator
	{ 0, {0.0,0.0,0.0}, {0.0,0.0,0.0}, 0}, // 13 - white dildo
	{ 0, {0.0,0.0,0.0}, {0.0,0.0,0.0}, 0}, // 14 - virág
	{ 0, {0.0,0.0,0.0}, {0.0,0.0,0.0}, 0}, // 15 - sétabot
	{ 0, {0.0,0.0,0.0}, {0.0,0.0,0.0}, 0}, // 16 - gránát
	{ 0, {0.0,0.0,0.0}, {0.0,0.0,0.0}, 0}, // 17 - füstbomba
	{ 0, {0.0,0.0,0.0}, {0.0,0.0,0.0}, 0}, // 18 - molotov
	{ 0, {0.0,0.0,0.0}, {0.0,0.0,0.0}, 0}, // 19 - 
	{ 0, {0.0,0.0,0.0}, {0.0,0.0,0.0}, 0}, // 20 - 
	{ 0, {0.0,0.0,0.0}, {0.0,0.0,0.0}, 0}, // 21 - 
	{ 0, {0.0,0.0,0.0}, {0.0,0.0,0.0}, 0}, // 22 - colt
	{ 0, {0.0,0.0,0.0}, {0.0,0.0,0.0}, 0}, // 23 - silenced
	{ 0, {0.0,0.0,0.0}, {0.0,0.0,0.0}, 0}, // 24 - deagle
	{ BONE_SPINE,        { -0.089997, -0.228999,  0.069999}, {   0.000000, 161.199935,   16.000001}, WEAPON_SLOT_SHOTGUN }, // 25 - shotgun
	{ 0, {0.0,0.0,0.0}, {0.0,0.0,0.0}, 0}, // 26 - sawn-off
	{ BONE_LEFT_THIGHT,  { -0.133000, -0.046999, -0.171998}, { -67.500053,   2.100000,    2.099999}, WEAPON_SLOT_COMBAT }, // 27 - combat
	{ 0, {0.0,0.0,0.0}, {0.0,0.0,0.0}, 0}, // 28 - uzi
	{ BONE_RIGHT_THIGHT, {  0.000000, -0.119000,  0.174998}, { -93.099990,   0.000000,    6.799998}, WEAPON_SLOT_MP5 }, // 29 - mp5
	{ BONE_SPINE,        {  0.264999, -0.151998,  0.059999}, {  -3.700001, 169.999908,    4.299993}, WEAPON_SLOT_M4_AK47 }, // 30 - ak47
	{ BONE_SPINE,        {  0.264999, -0.151998,  0.059999}, {  -3.700001, 169.999908,    4.299993}, WEAPON_SLOT_M4_AK47 }, // 31 - m4
	{ 0, {0.0,0.0,0.0}, {0.0,0.0,0.0}, 0}, // 32 - tec9
	{ BONE_SPINE,        {  0.013999, -0.165998, -0.067999}, { 177.099990, 165.899993,    2.299994}, WEAPON_SLOT_RIFLE }, // 33 - rifle
	{ BONE_SPINE,        {  0.232999, -0.162999, -0.076999}, {  -7.199835,  14.199996, -169.800003}, WEAPON_SLOT_SNIPER }, // 34 - sniper
	{ 0, {0.0,0.0,0.0}, {0.0,0.0,0.0}, 0}, // 35 - rakéta
	{ 0, {0.0,0.0,0.0}, {0.0,0.0,0.0}, 0}, // 36 - h? rakéta
	{ 0, {0.0,0.0,0.0}, {0.0,0.0,0.0}, 0}, // 37 - lángszóró
	{ 0, {0.0,0.0,0.0}, {0.0,0.0,0.0}, 0}, // 38 - minigun
	{ 0, {0.0,0.0,0.0}, {0.0,0.0,0.0}, 0}, // 39 - c4
	{ 0, {0.0,0.0,0.0}, {0.0,0.0,0.0}, 0}, // 40 - detonátor
	{ 0, {0.0,0.0,0.0}, {0.0,0.0,0.0}, 0}, // 41 - spré
	{ 0, {0.0,0.0,0.0}, {0.0,0.0,0.0}, 0}, // 42 - poroltó
	{ 0, {0.0,0.0,0.0}, {0.0,0.0,0.0}, 0}, // 43 - kamera
	{ 0, {0.0,0.0,0.0}, {0.0,0.0,0.0}, 0}, // 44 - éjellátó
	{ 0, {0.0,0.0,0.0}, {0.0,0.0,0.0}, 0}, // 45 - h?látó
	{ 0, {0.0,0.0,0.0}, {0.0,0.0,0.0}, 0}  // 46 - ejt?erny?
};*/

// player
#define MAX_PLAYER_WEAPONS 8
enum playerWeapons
{
	pWeapon[MAX_PLAYER_WEAPONS],
	pAmmo[MAX_WEAPONS],
	pArmed,
	pArmedSlot,
	pArmedSafeTime
}
new PlayerWeapons[MAX_PLAYERS][playerWeapons];

enum playerWeaponsAC
{
	pLastProblem,
	pLastAmmo,
	pLastAmmoTimes,
	pLastOpac[3],
	pProblems
}
new PlayerWeaponsAC[MAX_PLAYERS][playerWeaponsAC];

// limit
#define WEAPONS_LIMIT_MEELE		2
#define WEAPONS_LIMIT_GUN		4
#define WEAPONS_LIMIT_ARIFLE	1
#define WEAPONS_LIMIT_PARACHUTE	1
#define WEAPONS_LIMIT_THROWN	1

#define WEAPONS_TIME_ARMED			3
#define WEAPONS_TIME_PROBLEM		3
#define WEAPONS_TIME_PROBLEM_KICK	60
#define WEAPONS_LIMIT_PROBLEM_KICK	3

// error ID
#define WEAPONS_CAN_HOLD_WEAPON_MANY	(-1)
#define WEAPONS_CAN_HOLD_WEAPON_FULL	(-2)
#define WEAPONS_CAN_HOLD_WEAPON_NO		(-3)

// anti cheat
#define WEAPONS_PROBLEM_AMMO_ARM		(1001)
#define WEAPONS_PROBLEM_AMMO_MORE		(1002)
#define WEAPONS_PROBLEM_AMMO_INFINITE	(1003)
#define WEAPONS_PROBLEM_SHOOT_ARM		(1004)
#define WEAPONS_PROBLEM_SHOOT_INFINITE	(1005)

// function
#define PlayerWeaponsResetWeapons(%1) PlayerWeapons[%1][pWeapon] = {0,0,0,0,0,0,0,0}
#define PlayerWeaponsResetAmmos(%1) PlayerWeapons[%1][pAmmo] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
#define PlayerWeaponsReset(%1) PlayerWeaponsResetWeapons(%1), PlayerWeaponsResetAmmos(%1)
#define WeaponWeapon(%1,%2) PlayerWeapons[%1][pWeapon][%2]
#define WeaponAmmo(%1,%2) PlayerWeapons[%1][pAmmo][%2]
#define WeaponType(%1) WeaponData[%1][wType]
#define WeaponSlot(%1) WeaponData[%1][wSlot]
#define WeaponMaxAmmo(%1) WeaponData[%1][wAmmo]
#define WeaponObject(%1) WeaponData[%1][wObject]
#define WeaponArmed(%1) PlayerWeapons[%1][pArmed]
#define WeaponArmedSlot(%1) PlayerWeapons[%1][pArmedSlot]

stock WeaponArm(playerid, weapon = 0) // return: true ha sikerült, máskülönben false
{
	if(weapon < 0 || weapon > MAX_WEAPONS)
		return 0;
		
	ResetPlayerWeapons(playerid);
	PlayerWeapons[playerid][pArmed] = 0;
	PlayerWeapons[playerid][pArmedSlot] = NINCS;
	PlayerWeapons[playerid][pArmedSafeTime] = gettime() + WEAPONS_TIME_ARMED;

	if(weapon)
	{
		new slot = WeaponHaveWeapon(playerid, weapon);
		if(slot == NINCS)
			return 0;
			
		/*if(PlayerWeapons[playerid][pAmmo][weapon] > 0)
		{
			PlayerWeapons[playerid][pArmed] = weapon;
			PlayerWeapons[playerid][pArmedSlot] = slot;
			GivePlayerWeapon(playerid, weapon, PlayerWeapons[playerid][pAmmo][weapon]);
		}
		else if(WeaponData[ PlayerWeapons[playerid][pAmmo][weapon] ][wType] == WEAPON_TYPE_HAND)
		{
			PlayerWeapons[playerid][pArmed] = weapon;
			PlayerWeapons[playerid][pArmedSlot] = slot;
			GivePlayerWeapon(playerid, weapon, 1);
		}*/
		
		if(GetGumiLovedek(playerid, weapon) > 0 && pGumilovedek[playerid] == weapon)
		{
			GivePlayerWeapon(playerid, weapon, GetGumiLovedek(playerid, weapon));
		}
		else
		{
			if(PlayerWeapons[playerid][pAmmo][weapon] > 0)
			GivePlayerWeapon(playerid, weapon, PlayerWeapons[playerid][pAmmo][weapon]);
			else if(WeaponData[ PlayerWeapons[playerid][pAmmo][weapon] ][wType] == WEAPON_TYPE_HAND)
			GivePlayerWeapon(playerid, weapon, 1);
		}
		
		PlayerWeapons[playerid][pArmed] = weapon;
		PlayerWeapons[playerid][pArmedSlot] = slot;
	}
	
	WeaponRefreshAttachments(playerid);
		
	return 1;
}

stock WeaponCanHave(playerid, weapon) // return: true ha tudja viselni, máskülönben false
{
	if(IsScripter(playerid)) return 1;
	
	if(
		(Szint(playerid) < WEAPON_MIN_LEVEL && !UtosFegyver(weapon)) || !Logged(playerid) || PlayerInfo[playerid][pFegyverTiltIdo] > 0
		|| (WEAPON_ROCKETLAUNCHER <= weapon <= WEAPON_FLAMETHROWER || WEAPON_CAMERA <= weapon <= WEAPON_THERMAL_GOGGLES || WEAPON_GRENADE == weapon || weapon == WEAPON_MOLTOV) && !Admin(playerid, 1337)
		|| weapon == WEAPON_FIREEXTINGUISHER && !LMT(playerid, FRAKCIO_TUZOLTO)
		|| weapon == WEAPON_CHAINSAW && !LMT(playerid, FRAKCIO_TUZOLTO) && !AMT(playerid, MUNKA_FAVAGO)
		|| (weapon == WEAPON_SAWEDOFF || weapon == WEAPON_UZI || weapon == WEAPON_TEC9) && !IsHitman(playerid)
	)
		return Admin(playerid, 1337);
		
	return 1;
}

stock UtosFegyver(weapon)
{
	if(WeaponData[weapon][wType] == WEAPON_TYPE_HAND) return 1;
	
	return 0;
}

stock WeaponCanHoldWeapon(playerid, weapon, maxweapon = 1) // return: szabad slot, vagy hiba esetén hiba ID
{
	if(weapon < 1 || weapon > MAX_WEAPONS)
		return WEAPONS_CAN_HOLD_WEAPON_FULL;
		
	if(!WeaponCanHave(playerid, weapon))
		return WEAPONS_CAN_HOLD_WEAPON_NO;
		
	new free = NINCS;
	new meele, gun, arifle, parachute, pieces, thrown;
	
	for(new i, w; i < MAX_PLAYER_WEAPONS; i++)
	{
		w = PlayerWeapons[playerid][pWeapon][i];
		
		if(!w)
		{
			if(free == NINCS) // szabad slot
				free = i;
			
			continue;
		}
		
		// fegyver számlálás
		if(w == WEAPON_PARACHUTE) parachute++;
		else switch(WeaponData[w][wType])
		{
			case WEAPON_TYPE_HAND: meele++;
			case WEAPON_TYPE_PISTOL, WEAPON_TYPE_SHOTGUN, WEAPON_TYPE_SUBGUN, WEAPON_TYPE_RIFLE: gun++;
			case WEAPON_TYPE_ARIFLE: arifle++;
			case WEAPON_TYPE_THROWN: thrown++;
		}
		
		if(w == weapon) // ugyanolyan fegyverek megszámlálása
			pieces++;
	}
	
	if(maxweapon > 0 && pieces >= maxweapon) // ha megvan határozva a max mennyiség, akkor ellen?rzi és megakadályozza, hogy több legyen
		return WEAPONS_CAN_HOLD_WEAPON_MANY;
	
	if(free == NINCS) // nincs szabad slot?
		return WEAPONS_CAN_HOLD_WEAPON_FULL;
	
	// limit ellen?rzés
	if(weapon == WEAPON_PARACHUTE && parachute >= WEAPONS_LIMIT_PARACHUTE) return WEAPONS_CAN_HOLD_WEAPON_MANY;
	switch(WeaponData[weapon][wType])
	{
		case WEAPON_TYPE_HAND:
			if(meele >= WEAPONS_LIMIT_MEELE)
				return WEAPONS_CAN_HOLD_WEAPON_MANY;
				
		case WEAPON_TYPE_PISTOL, WEAPON_TYPE_SHOTGUN, WEAPON_TYPE_SUBGUN, WEAPON_TYPE_RIFLE:
			if(gun >= WEAPONS_LIMIT_GUN)
				return WEAPONS_CAN_HOLD_WEAPON_MANY;
				
		case WEAPON_TYPE_ARIFLE:
			if(arifle >= WEAPONS_LIMIT_ARIFLE)
				return WEAPONS_CAN_HOLD_WEAPON_MANY;
				
		case WEAPON_TYPE_THROWN:
			if(thrown >= WEAPONS_LIMIT_THROWN)
				return WEAPONS_CAN_HOLD_WEAPON_MANY;
				
		default:
			return WEAPONS_CAN_HOLD_WEAPON_MANY;
	}
	
	return free;
}

stock WeaponCanHoldAmmo(playerid, weapon, ammo) // return: true ha tud, máskülönben false
{
	if(weapon < 1 || weapon > MAX_WEAPONS || ammo < 1)
		return 0;
		
	return (PlayerWeapons[playerid][pAmmo][weapon] + ammo) <= WeaponMaxAmmo(weapon);
}

stock WeaponHaveWeapon(playerid, weapon) // return: weapon slot, -1 ha nincs
{
	if(weapon < 1 || weapon > MAX_WEAPONS)
		return NINCS;
		
	for(new w = 0; w < MAX_PLAYER_WEAPONS; w++)
		if(PlayerWeapons[playerid][pWeapon][w] == weapon)
			return w;
	
	return NINCS;
}

stock WeaponHaveAmmo(playerid, weapon, ammo) // return: true ha van, máskülönben false
{
	if(weapon < 1 || weapon > MAX_WEAPONS || ammo < 1)
		return 0;
		
	return PlayerWeapons[playerid][pAmmo][weapon] >= ammo;
}

stock WeaponGiveWeapon(playerid, weapon, ammo = 0, maxweapon = 1) // return: sikeres fegyveradásnál slot, hiba esetén hiba ID
{
	// fegyver ellen?rzés és szabad slot lekérés
	new slot = WeaponCanHoldWeapon(playerid, weapon, maxweapon);
	
	if(slot >= 0)
	{
		PlayerWeapons[playerid][pWeapon][slot] = weapon;
		WeaponRefreshAttachments(playerid);
	}
	
	if(ammo > 0)
		WeaponGiveAmmo(playerid, weapon, ammo);
	
	return slot;
}

stock WeaponGiveAmmo(playerid, weapon, ammo) // return: siker esetén true, egyébként false
{
	if(!WeaponData[weapon][wAmmo])
		return 0;
		
	PlayerWeapons[playerid][pAmmo][weapon] = max(0, min(WeaponAmmo(playerid, weapon) + ammo, WeaponMaxAmmo(weapon)));
	
	if(PlayerWeapons[playerid][pArmed] == weapon)
		WeaponArm(playerid, PlayerWeapons[playerid][pAmmo][weapon] ? weapon : 0);
	
	return 1;
}

stock WeaponTakeWeapon(playerid, weapon) // return: siker esetén true, egyébként false
{
	if(weapon < 1 || weapon > MAX_WEAPONS)
		return 0;
		
	for(new w = 0; w < MAX_PLAYER_WEAPONS; w++)
	{
		if(PlayerWeapons[playerid][pWeapon][w] == weapon)
			return
				PlayerWeapons[playerid][pWeapon][w] = 0,
				WeaponRefreshAttachments(playerid),
				(weapon == PlayerWeapons[playerid][pArmed] ? WeaponArm(playerid, 0) : 1),
				1
			;
	}
	
	return 0;
}

stock WeaponTakeAmmo(playerid, weapon) // return: siker esetén true, egyébként false
{
	if(weapon < 1 || weapon > MAX_WEAPONS)
		return 0;
		
	if(PlayerWeapons[playerid][pAmmo][weapon])
		return
			PlayerWeapons[playerid][pAmmo][weapon] = 0,
			(weapon == PlayerWeapons[playerid][pArmed] ? WeaponArm(playerid, 0) : 1),
			1
		;
	
	return 0;
}

stock WeaponResetWeapons(playerid) // return: nincs
{
	PlayerWeaponsResetWeapons(playerid);
	WeaponArm(playerid);
}

stock WeaponResetAmmos(playerid) // return: nincs
{
	PlayerWeaponsResetAmmos(playerid);
	WeaponArm(playerid);
}

stock WeaponResetAll(playerid) // return: nincs
{
	PlayerWeaponsReset(playerid);
	WeaponArm(playerid);
}

stock WeaponRefreshAttachments(playerid, bool:onlyremove = false) // return: true
{
	if(onlyremove)
	{
		RemovePlayerAttachedObject(playerid, WEAPON_SLOT_MP5);
		RemovePlayerAttachedObject(playerid, WEAPON_SLOT_SHOTGUN);
		RemovePlayerAttachedObject(playerid, WEAPON_SLOT_SNIPER);
		RemovePlayerAttachedObject(playerid, WEAPON_SLOT_M4_AK47);
		RemovePlayerAttachedObject(playerid, WEAPON_SLOT_PISTOL);
		return 1;
	}

	new mp5, shotgun, combat, rifle, sniper, m4, ak47, silenced, colt45, deagle;
	for(new w = 0; w < MAX_PLAYER_WEAPONS; w++)
	{
		if(PlayerWeapons[playerid][pWeapon][w]) switch(PlayerWeapons[playerid][pWeapon][w])
		{
			case WEAPON_MP5: mp5++;
			case WEAPON_SHOTGUN: shotgun++;
			case WEAPON_SHOTGSPA: combat++;
			case WEAPON_RIFLE: rifle++;
			case WEAPON_SNIPER: sniper++;
			case WEAPON_M4: m4++;
			case WEAPON_AK47: ak47++;
			case WEAPON_SILENCED: silenced++;
			case WEAPON_COLT45: colt45++;
			case WEAPON_DEAGLE: deagle++;
		}
	}
	
	if(mp5 && WeaponArmed(playerid) != WEAPON_MP5)
	{
		SetPlayerAttachedObject(playerid, WEAPON_SLOT_MP5, GetWeaponModel(WEAPON_MP5), WeaponAdjust[playerid][waBone][2],
		WeaponAdjust[playerid][waOffSetX][2], WeaponAdjust[playerid][waOffSetY][2], WeaponAdjust[playerid][waOffSetZ][2],
		WeaponAdjust[playerid][waRotSetX][2], WeaponAdjust[playerid][waRotSetY][2], WeaponAdjust[playerid][waRotSetZ][2],
		WeaponAdjust[playerid][waScaleSetX][2], WeaponAdjust[playerid][waScaleSetY][2], WeaponAdjust[playerid][waScaleSetZ][2]);
	}
	else RemovePlayerAttachedObject(playerid, WEAPON_SLOT_MP5);
	
	if(deagle && WeaponArmed(playerid) != WEAPON_DEAGLE)
	{
		SetPlayerAttachedObject(playerid, WEAPON_SLOT_PISTOL, GetWeaponModel(WEAPON_DEAGLE), WeaponAdjust[playerid][waBone][1],
		WeaponAdjust[playerid][waOffSetX][1], WeaponAdjust[playerid][waOffSetY][1], WeaponAdjust[playerid][waOffSetZ][1],
		WeaponAdjust[playerid][waRotSetX][1], WeaponAdjust[playerid][waRotSetY][1], WeaponAdjust[playerid][waRotSetZ][1],
		WeaponAdjust[playerid][waScaleSetX][1], WeaponAdjust[playerid][waScaleSetY][1], WeaponAdjust[playerid][waScaleSetZ][1]);
	}
	else if(silenced && WeaponArmed(playerid) != WEAPON_SILENCED)
	{
		SetPlayerAttachedObject(playerid, WEAPON_SLOT_PISTOL, GetWeaponModel(WEAPON_SILENCED), WeaponAdjust[playerid][waBone][1],
		WeaponAdjust[playerid][waOffSetX][1], WeaponAdjust[playerid][waOffSetY][1], WeaponAdjust[playerid][waOffSetZ][1],
		WeaponAdjust[playerid][waRotSetX][1], WeaponAdjust[playerid][waRotSetY][1], WeaponAdjust[playerid][waRotSetZ][1],
		WeaponAdjust[playerid][waScaleSetX][1], WeaponAdjust[playerid][waScaleSetY][1], WeaponAdjust[playerid][waScaleSetZ][1]);
	}
	else if(colt45 && WeaponArmed(playerid) != WEAPON_COLT45)
	{
		SetPlayerAttachedObject(playerid, WEAPON_SLOT_PISTOL, GetWeaponModel(WEAPON_COLT45), WeaponAdjust[playerid][waBone][1],
		WeaponAdjust[playerid][waOffSetX][1], WeaponAdjust[playerid][waOffSetY][1], WeaponAdjust[playerid][waOffSetZ][1],
		WeaponAdjust[playerid][waRotSetX][1], WeaponAdjust[playerid][waRotSetY][1], WeaponAdjust[playerid][waRotSetZ][1],
		WeaponAdjust[playerid][waScaleSetX][1], WeaponAdjust[playerid][waScaleSetY][1], WeaponAdjust[playerid][waScaleSetZ][1]);
	}
	else RemovePlayerAttachedObject(playerid, WEAPON_SLOT_PISTOL);
	
	if(shotgun && WeaponArmed(playerid) != WEAPON_SHOTGUN)
	{
		SetPlayerAttachedObject(playerid, WEAPON_SLOT_SHOTGUN, GetWeaponModel(WEAPON_SHOTGUN), WeaponAdjust[playerid][waBone][4],
		WeaponAdjust[playerid][waOffSetX][4], WeaponAdjust[playerid][waOffSetY][4], WeaponAdjust[playerid][waOffSetZ][4],
		WeaponAdjust[playerid][waRotSetX][4], WeaponAdjust[playerid][waRotSetY][4], WeaponAdjust[playerid][waRotSetZ][4],
		WeaponAdjust[playerid][waScaleSetX][4], WeaponAdjust[playerid][waScaleSetY][4], WeaponAdjust[playerid][waScaleSetZ][4]);
	}
	else if(combat && WeaponArmed(playerid) != WEAPON_SHOTGSPA)
	{
		SetPlayerAttachedObject(playerid, WEAPON_SLOT_SHOTGUN, GetWeaponModel(WEAPON_SHOTGSPA), WeaponAdjust[playerid][waBone][4],
		WeaponAdjust[playerid][waOffSetX][4], WeaponAdjust[playerid][waOffSetY][4], WeaponAdjust[playerid][waOffSetZ][4],
		WeaponAdjust[playerid][waRotSetX][4], WeaponAdjust[playerid][waRotSetY][4], WeaponAdjust[playerid][waRotSetZ][4],
		WeaponAdjust[playerid][waScaleSetX][4], WeaponAdjust[playerid][waScaleSetY][4], WeaponAdjust[playerid][waScaleSetZ][4]);
	}
	else RemovePlayerAttachedObject(playerid, WEAPON_SLOT_SHOTGUN);
	
	if(rifle && WeaponArmed(playerid) != WEAPON_RIFLE)
	{
		SetPlayerAttachedObject(playerid, WEAPON_SLOT_SNIPER, GetWeaponModel(WEAPON_RIFLE), WeaponAdjust[playerid][waBone][3],
		WeaponAdjust[playerid][waOffSetX][3], WeaponAdjust[playerid][waOffSetY][3], WeaponAdjust[playerid][waOffSetZ][3],
		WeaponAdjust[playerid][waRotSetX][3], WeaponAdjust[playerid][waRotSetY][3], WeaponAdjust[playerid][waRotSetZ][3],
		WeaponAdjust[playerid][waScaleSetX][3], WeaponAdjust[playerid][waScaleSetY][3], WeaponAdjust[playerid][waScaleSetZ][3]);
	}
	else if(sniper && WeaponArmed(playerid) != WEAPON_SNIPER)
	{
		SetPlayerAttachedObject(playerid, WEAPON_SLOT_SNIPER, GetWeaponModel(WEAPON_SNIPER), WeaponAdjust[playerid][waBone][3],
		WeaponAdjust[playerid][waOffSetX][3], WeaponAdjust[playerid][waOffSetY][3], WeaponAdjust[playerid][waOffSetZ][3],
		WeaponAdjust[playerid][waRotSetX][3], WeaponAdjust[playerid][waRotSetY][3], WeaponAdjust[playerid][waRotSetZ][3],
		WeaponAdjust[playerid][waScaleSetX][3], WeaponAdjust[playerid][waScaleSetY][3], WeaponAdjust[playerid][waScaleSetZ][3]);
	}
	else RemovePlayerAttachedObject(playerid, WEAPON_SLOT_SNIPER);
	
	if(m4 && WeaponArmed(playerid) != WEAPON_M4)
	{
		SetPlayerAttachedObject(playerid, WEAPON_SLOT_M4_AK47, GetWeaponModel(WEAPON_M4), WeaponAdjust[playerid][waBone][0],
		WeaponAdjust[playerid][waOffSetX][0], WeaponAdjust[playerid][waOffSetY][0], WeaponAdjust[playerid][waOffSetZ][0],
		WeaponAdjust[playerid][waRotSetX][0], WeaponAdjust[playerid][waRotSetY][0], WeaponAdjust[playerid][waRotSetZ][0],
		WeaponAdjust[playerid][waScaleSetX][0], WeaponAdjust[playerid][waScaleSetY][0], WeaponAdjust[playerid][waScaleSetZ][0]);
	}
	else if(ak47 && WeaponArmed(playerid) != WEAPON_AK47)
	{
		SetPlayerAttachedObject(playerid, WEAPON_SLOT_M4_AK47, GetWeaponModel(WEAPON_AK47), WeaponAdjust[playerid][waBone][0],
		WeaponAdjust[playerid][waOffSetX][0], WeaponAdjust[playerid][waOffSetY][0], WeaponAdjust[playerid][waOffSetZ][0],
		WeaponAdjust[playerid][waRotSetX][0], WeaponAdjust[playerid][waRotSetY][0], WeaponAdjust[playerid][waRotSetZ][0],
		WeaponAdjust[playerid][waScaleSetX][0], WeaponAdjust[playerid][waScaleSetY][0], WeaponAdjust[playerid][waScaleSetZ][0]);
	}
	else RemovePlayerAttachedObject(playerid, WEAPON_SLOT_M4_AK47);
	
	return 1;
}

stock WeaponProblem(playerid, problem) // return: probléma feldolgozása esetén true, egyébként false
{
	new time = gettime();
	
	if(PlayerWeapons[playerid][pArmedSafeTime] > time || PlayerWeaponsAC[playerid][pLastProblem] > time)
		return 0;
	
	if(PlayerWeaponsAC[playerid][pLastProblem] >= (time - WEAPONS_TIME_PROBLEM_KICK))
	{
		PlayerWeaponsAC[playerid][pLastProblem]++;
		if(PlayerWeaponsAC[playerid][pLastProblem] >= WEAPONS_LIMIT_PROBLEM_KICK)
			return Kick(playerid);
	}
	else
		PlayerWeaponsAC[playerid][pLastProblem] = 1;
	
	PlayerWeaponsAC[playerid][pLastProblem] = time + WEAPONS_TIME_PROBLEM;
	
	new msg[256];
	switch(problem)
	{
		case WEAPONS_PROBLEM_AMMO_ARM:
		{
			if(GetPlayerWeapon(playerid) == WEAPON_PARACHUTE) return 1;
			format(msg, 128, "<< Nem vett elõ fegyvert, mégis van nála: [%d]%s - %s[%d] >>", playerid, PlayerName(playerid), GetGunName(GetPlayerWeapon(playerid)), GetPlayerAmmo(playerid));
			SendMessage(SEND_MESSAGE_ADMIN, msg, COLOR_YELLOW, 1);
			Log("Cheat", msg);
			
			WeaponArm(playerid);
		}
			
		case WEAPONS_PROBLEM_AMMO_MORE:
		{
			format(msg, 128, "<< Több lõszere van a kelleténél: [%d]%s - %s: kellene: %d, van: %d >>", playerid, PlayerName(playerid), GetGunName(PlayerWeapons[playerid][pArmed]), PlayerWeapons[playerid][pAmmo][ PlayerWeapons[playerid][pArmed] ], GetPlayerAmmo(playerid));
			SendMessage(SEND_MESSAGE_ADMIN, msg, COLOR_YELLOW, 1);
			Log("Cheat", msg);
			
			WeaponArm(playerid);
		}
		
		case WEAPONS_PROBLEM_AMMO_INFINITE:
		{
			format(msg, 128, "<< Úgy tûnik végtelen l?szere van: [%d]%s - %s[%d:%d] >>", playerid, PlayerName(playerid), GetGunName(GetPlayerWeapon(playerid)), PlayerWeaponsAC[playerid][pLastOpac][0], PlayerWeaponsAC[playerid][pLastOpac][1]);
			SendMessage(SEND_MESSAGE_ADMIN, msg, COLOR_YELLOW, 1);
			Log("Cheat", msg);
			
			WeaponArm(playerid);
		}
		
		case WEAPONS_PROBLEM_SHOOT_ARM:
		{
			format(msg, 128, "<< Nem azzal a fegyverrel lõ, amit elõvett: [%d]%s, kellene: %s, van: %s >>", playerid, PlayerName(playerid), GetGunName(PlayerWeapons[playerid][pArmed]), GetGunName(GetPlayerWeapon(playerid)));
			SendMessage(SEND_MESSAGE_ADMIN, msg, COLOR_YELLOW, 1);
			Log("Cheat", msg);
			
			WeaponArm(playerid);
		}
		
		case WEAPONS_PROBLEM_SHOOT_INFINITE:
		{
			format(msg, 128, "<< Úgy tûnik végtelen lõszere van: [%d]%s, fegyver: %s[%ddb] >>", playerid, PlayerName(playerid), GetGunName(PlayerWeapons[playerid][pArmed]), PlayerWeapons[playerid][pAmmo][ PlayerWeapons[playerid][pArmed] ]);
			SendMessage(SEND_MESSAGE_ADMIN, msg, COLOR_YELLOW, 1);
			Log("Cheat", msg);
			
			WeaponArm(playerid);
		}
	}
	
	return 1;
}

stock GetWeaponOffset(weaponid)
{
	switch(weaponid)
	{
		case WEAPON_MP5: return WEAPON_SLOT_MP5;
		case WEAPON_SHOTGUN: return WEAPON_SLOT_SHOTGUN;
		case WEAPON_SHOTGSPA: return WEAPON_SLOT_SHOTGUN;
		case WEAPON_RIFLE: return WEAPON_SLOT_SNIPER;
		case WEAPON_SNIPER: return WEAPON_SLOT_SNIPER;
		case WEAPON_M4, WEAPON_AK47: return WEAPON_SLOT_M4_AK47;
		default: return NINCS;
	}
}

stock GetWeaponModel(weaponid)
{
	switch(weaponid)
	{
	    case 1:
	        return 331;

		case 2..8:
		    return weaponid+331;

        case 9:
		    return 341;

		case 10..15:
			return weaponid+311;

		case 16..18:
		    return weaponid+326;

		case 22..29:
		    return weaponid+324;

		case 30,31:
		    return weaponid+325;

		case 32:
		    return 372;

		case 33..45:
		    return weaponid+324;

		case 46:
		    return 371;
	}
	return 0;
}

stock GetSkinType(skinid = NINCS)
{
	switch(skinid)
	{
		case 5, 10, 15, 39, 50, 65, 77, 79, 82, 87, 89, 91, 100, 103, 105, 111,
		112, 113, 127, 130, 142, 143, 146, 148, 149, 151, 156, 157, 163,
		168, 173, 174, 175, 176, 177, 180, 195, 205, 215, 216, 217, 218, 221, 227,
		228, 232, 237, 238, 242, 245, 246, 249, 258, 264, 269, 272, 277, 278, 279, 306, 307, 308, 309: return 0;
		
		case 3, 4, 32, 46, 49, 53, 57, 59, 119, 120, 126, 129, 132, 133, 134, 136,
		137, 160, 162, 165, 166, 167, 171, 186, 189, 196, 206, 209, 210, 212, 223,
		230, 234, 252, 253, 261, 268, 289, 290, 291, 292, 294, 295, 298, 299: return 1;
		
		case 1, 2, 6, 7, 8, 9, 11, 12, 13, 14, 16, 17, 18, 19, 20, 21, 22, 23, 24,
		25, 26, 27, 28, 29, 30, 31, 33, 34, 35, 36, 37, 38, 40, 41, 42, 43, 44, 45,
		47, 48, 51, 52, 54, 55,  56, 58, 60, 61, 62, 63, 64, 66, 67, 68, 69, 70, 71,
		72, 73, 75, 76, 78, 80, 81, 83, 84, 85, 86, 88,  90,92, 93, 94, 95, 96, 97, 98,
		99,  101, 102, 104, 106, 107, 108, 109, 110, 114, 115, 116, 117, 118, 121, 122,
		123, 124, 125, 128, 131, 135, 138, 139, 140, 141, 144, 145, 147, 150, 152, 153,
		154, 155, 158, 159, 161, 164, 169, 170, 172, 178, 179, 181, 182, 183, 184, 185,
		187, 188, 190, 191, 192, 193, 194, 197, 198, 199, 200, 201, 202,  203,  204, 207,
		208, 211, 213, 214, 219, 220, 222, 224, 225, 226, 229, 231, 233, 235, 236, 239,
		240, 241, 243, 244, 247, 248, 250, 251, 254, 255, 256, 257, 259, 260, 262, 263,
		265, 266, 267, 270, 271, 273, 274, 275, 276, 280, 281, 282, 283, 284, 285, 286,
		287, 288, 293, 296, 297, 300, 301, 302, 303, 304, 305, 310, 311: return 2;
		
		default: return 1;
	}
	return NINCS;
}

stock AdjustPlayerWeapons(playerid, weap = NINCS, id)
{
	if(weap == NINCS) return 1;
	
	new listitem = id;
	new type = GetSkinType(GetPlayerSkin(playerid));
	new Float:offset[3];
	new Float:rotset[3];
	new Float:sizeset[3];
	new bone;
	
	switch(weap)
	{
		case WEAPON_AK47, WEAPON_M4:
		{
			
			switch(type)
			{
				case 0:
				{
					offset[0] = FValasztM4AK47[listitem][waOffSetD][0];
					offset[1] = FValasztM4AK47[listitem][waOffSetD][1];
					offset[2] = FValasztM4AK47[listitem][waOffSetD][2];
					
					rotset[0] = FValasztM4AK47[listitem][waRotSetD][0];
					rotset[1] = FValasztM4AK47[listitem][waRotSetD][1];
					rotset[2] = FValasztM4AK47[listitem][waRotSetD][2];
					
				}
				case 1:
				{
					offset[0] = FValasztM4AK47[listitem][waOffSetK][0];
					offset[1] = FValasztM4AK47[listitem][waOffSetK][1];
					offset[2] = FValasztM4AK47[listitem][waOffSetK][2];
					
					rotset[0] = FValasztM4AK47[listitem][waRotSetK][0];
					rotset[1] = FValasztM4AK47[listitem][waRotSetK][1];
					rotset[2] = FValasztM4AK47[listitem][waRotSetK][2];
					
				}
				case 2:
				{
					offset[0] = FValasztM4AK47[listitem][waOffSetV][0];
					offset[1] = FValasztM4AK47[listitem][waOffSetV][1];
					offset[2] = FValasztM4AK47[listitem][waOffSetV][2];
					
					rotset[0] = FValasztM4AK47[listitem][waRotSetV][0];
					rotset[1] = FValasztM4AK47[listitem][waRotSetV][1];
					rotset[2] = FValasztM4AK47[listitem][waRotSetV][2];
					
				}
				default:
				{
					offset[0] = FValasztM4AK47[listitem][waOffSetK][0];
					offset[1] = FValasztM4AK47[listitem][waOffSetK][1];
					offset[2] = FValasztM4AK47[listitem][waOffSetK][2];
					
					rotset[0] = FValasztM4AK47[listitem][waRotSetK][0];
					rotset[1] = FValasztM4AK47[listitem][waRotSetK][1];
					rotset[2] = FValasztM4AK47[listitem][waRotSetK][2];
					
				}
			}
			sizeset[0] = FValasztM4AK47[listitem][waScaleSet][0];
			sizeset[1] = FValasztM4AK47[listitem][waScaleSet][1];
			sizeset[2] = FValasztM4AK47[listitem][waScaleSet][2];
			bone = FValasztM4AK47[listitem][waBone];
			
			if(offset[0] == F_NINCSERTEK || offset[1] == F_NINCSERTEK || offset[2] == F_NINCSERTEK ||
			rotset[0] == F_NINCSERTEK || rotset[1] == F_NINCSERTEK || rotset[2] == F_NINCSERTEK) return Msg(playerid, "Ehhez a skinhez nem!");
			
			WeaponAdjust[playerid][waOffSetX][0] = offset[0];
			WeaponAdjust[playerid][waOffSetY][0] = offset[1];
			WeaponAdjust[playerid][waOffSetZ][0] = offset[2];
			WeaponAdjust[playerid][waRotSetX][0] = rotset[0];
			WeaponAdjust[playerid][waRotSetY][0] = rotset[1];
			WeaponAdjust[playerid][waRotSetZ][0] = rotset[2];
			WeaponAdjust[playerid][waScaleSetX][0] = sizeset[0];
			WeaponAdjust[playerid][waScaleSetY][0] = sizeset[1];
			WeaponAdjust[playerid][waScaleSetZ][0] = sizeset[2];
			WeaponAdjust[playerid][waBone][0] = bone;
			
			WeaponAdjust[playerid][waID][0] = listitem;
		
			WeaponRefreshAttachments(playerid);
			Freeze(playerid, 1000);
			
			return 1;
		}
		case WEAPON_DEAGLE, WEAPON_SILENCED, WEAPON_COLT45:
		{
			
			switch(type)
			{
				case 0:
				{
					offset[0] = FValasztPisztoly[listitem][waOffSetD][0];
					offset[1] = FValasztPisztoly[listitem][waOffSetD][1];
					offset[2] = FValasztPisztoly[listitem][waOffSetD][2];
					
					rotset[0] = FValasztPisztoly[listitem][waRotSetD][0];
					rotset[1] = FValasztPisztoly[listitem][waRotSetD][1];
					rotset[2] = FValasztPisztoly[listitem][waRotSetD][2];
					
				}
				case 1:
				{
					offset[0] = FValasztPisztoly[listitem][waOffSetK][0];
					offset[1] = FValasztPisztoly[listitem][waOffSetK][1];
					offset[2] = FValasztPisztoly[listitem][waOffSetK][2];
					
					rotset[0] = FValasztPisztoly[listitem][waRotSetK][0];
					rotset[1] = FValasztPisztoly[listitem][waRotSetK][1];
					rotset[2] = FValasztPisztoly[listitem][waRotSetK][2];
					
				}
				case 2:
				{
					offset[0] = FValasztPisztoly[listitem][waOffSetV][0];
					offset[1] = FValasztPisztoly[listitem][waOffSetV][1];
					offset[2] = FValasztPisztoly[listitem][waOffSetV][2];
					
					rotset[0] = FValasztPisztoly[listitem][waRotSetV][0];
					rotset[1] = FValasztPisztoly[listitem][waRotSetV][1];
					rotset[2] = FValasztPisztoly[listitem][waRotSetV][2];
					
				}
				default:
				{
					offset[0] = FValasztPisztoly[listitem][waOffSetK][0];
					offset[1] = FValasztPisztoly[listitem][waOffSetK][1];
					offset[2] = FValasztPisztoly[listitem][waOffSetK][2];
					
					rotset[0] = FValasztPisztoly[listitem][waRotSetK][0];
					rotset[1] = FValasztPisztoly[listitem][waRotSetK][1];
					rotset[2] = FValasztPisztoly[listitem][waRotSetK][2];
					
				}
			}
			sizeset[0] = FValasztPisztoly[listitem][waScaleSet][0];
			sizeset[1] = FValasztPisztoly[listitem][waScaleSet][1];
			sizeset[2] = FValasztPisztoly[listitem][waScaleSet][2];
			bone = FValasztPisztoly[listitem][waBone];
			
			if(offset[0] == F_NINCSERTEK || offset[1] == F_NINCSERTEK || offset[2] == F_NINCSERTEK ||
			rotset[0] == F_NINCSERTEK || rotset[1] == F_NINCSERTEK || rotset[2] == F_NINCSERTEK) return Msg(playerid, "Ehhez a skinhez nem!");
			
			WeaponAdjust[playerid][waOffSetX][1] = offset[0];
			WeaponAdjust[playerid][waOffSetY][1] = offset[1];
			WeaponAdjust[playerid][waOffSetZ][1] = offset[2];
			WeaponAdjust[playerid][waRotSetX][1] = rotset[0];
			WeaponAdjust[playerid][waRotSetY][1] = rotset[1];
			WeaponAdjust[playerid][waRotSetZ][1] = rotset[2];
			WeaponAdjust[playerid][waScaleSetX][1] = sizeset[0];
			WeaponAdjust[playerid][waScaleSetY][1] = sizeset[1];
			WeaponAdjust[playerid][waScaleSetZ][1] = sizeset[2];
			WeaponAdjust[playerid][waBone][1] = bone;
			
			WeaponAdjust[playerid][waID][1] = listitem;
			
			WeaponRefreshAttachments(playerid);
			Freeze(playerid, 1000);
			
			return 1;
		}
		case WEAPON_MP5:
		{
			
			switch(type)
			{
				case 0:
				{
					offset[0] = FValasztMP5[listitem][waOffSetD][0];
					offset[1] = FValasztMP5[listitem][waOffSetD][1];
					offset[2] = FValasztMP5[listitem][waOffSetD][2];
					
					rotset[0] = FValasztMP5[listitem][waRotSetD][0];
					rotset[1] = FValasztMP5[listitem][waRotSetD][1];
					rotset[2] = FValasztMP5[listitem][waRotSetD][2];
					
				}
				case 1:
				{
					offset[0] = FValasztMP5[listitem][waOffSetK][0];
					offset[1] = FValasztMP5[listitem][waOffSetK][1];
					offset[2] = FValasztMP5[listitem][waOffSetK][2];
					
					rotset[0] = FValasztMP5[listitem][waRotSetK][0];
					rotset[1] = FValasztMP5[listitem][waRotSetK][1];
					rotset[2] = FValasztMP5[listitem][waRotSetK][2];
					
				}
				case 2:
				{
					offset[0] = FValasztMP5[listitem][waOffSetV][0];
					offset[1] = FValasztMP5[listitem][waOffSetV][1];
					offset[2] = FValasztMP5[listitem][waOffSetV][2];
					
					rotset[0] = FValasztMP5[listitem][waRotSetV][0];
					rotset[1] = FValasztMP5[listitem][waRotSetV][1];
					rotset[2] = FValasztMP5[listitem][waRotSetV][2];
					
				}
				default:
				{
					offset[0] = FValasztMP5[listitem][waOffSetK][0];
					offset[1] = FValasztMP5[listitem][waOffSetK][1];
					offset[2] = FValasztMP5[listitem][waOffSetK][2];
					
					rotset[0] = FValasztMP5[listitem][waRotSetK][0];
					rotset[1] = FValasztMP5[listitem][waRotSetK][1];
					rotset[2] = FValasztMP5[listitem][waRotSetK][2];
					
				}
			}
			sizeset[0] = FValasztMP5[listitem][waScaleSet][0];
			sizeset[1] = FValasztMP5[listitem][waScaleSet][1];
			sizeset[2] = FValasztMP5[listitem][waScaleSet][2];
			bone = FValasztMP5[listitem][waBone];
			
			if(offset[0] == F_NINCSERTEK || offset[1] == F_NINCSERTEK || offset[2] == F_NINCSERTEK ||
			rotset[0] == F_NINCSERTEK || rotset[1] == F_NINCSERTEK || rotset[2] == F_NINCSERTEK) return Msg(playerid, "Ehhez a skinhez nem!");
			
			WeaponAdjust[playerid][waOffSetX][2] = offset[0];
			WeaponAdjust[playerid][waOffSetY][2] = offset[1];
			WeaponAdjust[playerid][waOffSetZ][2] = offset[2];
			WeaponAdjust[playerid][waRotSetX][2] = rotset[0];
			WeaponAdjust[playerid][waRotSetY][2] = rotset[1];
			WeaponAdjust[playerid][waRotSetZ][2] = rotset[2];
			WeaponAdjust[playerid][waScaleSetX][2] = sizeset[0];
			WeaponAdjust[playerid][waScaleSetY][2] = sizeset[1];
			WeaponAdjust[playerid][waScaleSetZ][2] = sizeset[2];
			WeaponAdjust[playerid][waBone][2] = bone;
			
			WeaponAdjust[playerid][waID][2] = listitem;
			
			WeaponRefreshAttachments(playerid);
			Freeze(playerid, 1000);
			
			return 1;
		}
		case WEAPON_RIFLE, WEAPON_SNIPER:
		{
			
			switch(type)
			{
				case 0:
				{
					offset[0] = FValasztSniperRifle[listitem][waOffSetD][0];
					offset[1] = FValasztSniperRifle[listitem][waOffSetD][1];
					offset[2] = FValasztSniperRifle[listitem][waOffSetD][2];
					
					rotset[0] = FValasztSniperRifle[listitem][waRotSetD][0];
					rotset[1] = FValasztSniperRifle[listitem][waRotSetD][1];
					rotset[2] = FValasztSniperRifle[listitem][waRotSetD][2];
					
				}
				case 1:
				{
					offset[0] = FValasztSniperRifle[listitem][waOffSetK][0];
					offset[1] = FValasztSniperRifle[listitem][waOffSetK][1];
					offset[2] = FValasztSniperRifle[listitem][waOffSetK][2];
					
					rotset[0] = FValasztSniperRifle[listitem][waRotSetK][0];
					rotset[1] = FValasztSniperRifle[listitem][waRotSetK][1];
					rotset[2] = FValasztSniperRifle[listitem][waRotSetK][2];
					
				}
				case 2:
				{
					offset[0] = FValasztSniperRifle[listitem][waOffSetV][0];
					offset[1] = FValasztSniperRifle[listitem][waOffSetV][1];
					offset[2] = FValasztSniperRifle[listitem][waOffSetV][2];
					
					rotset[0] = FValasztSniperRifle[listitem][waRotSetV][0];
					rotset[1] = FValasztSniperRifle[listitem][waRotSetV][1];
					rotset[2] = FValasztSniperRifle[listitem][waRotSetV][2];
					
				}
				default:
				{
					offset[0] = FValasztSniperRifle[listitem][waOffSetK][0];
					offset[1] = FValasztSniperRifle[listitem][waOffSetK][1];
					offset[2] = FValasztSniperRifle[listitem][waOffSetK][2];
					
					rotset[0] = FValasztSniperRifle[listitem][waRotSetK][0];
					rotset[1] = FValasztSniperRifle[listitem][waRotSetK][1];
					rotset[2] = FValasztSniperRifle[listitem][waRotSetK][2];
					
				}
			}
			sizeset[0] = FValasztSniperRifle[listitem][waScaleSet][0];
			sizeset[1] = FValasztSniperRifle[listitem][waScaleSet][1];
			sizeset[2] = FValasztSniperRifle[listitem][waScaleSet][2];
			bone = FValasztSniperRifle[listitem][waBone];
			
			if(offset[0] == F_NINCSERTEK || offset[1] == F_NINCSERTEK || offset[2] == F_NINCSERTEK ||
			rotset[0] == F_NINCSERTEK || rotset[1] == F_NINCSERTEK || rotset[2] == F_NINCSERTEK) return Msg(playerid, "Ehhez a skinhez nem!");
			
			WeaponAdjust[playerid][waOffSetX][3] = offset[0];
			WeaponAdjust[playerid][waOffSetY][3] = offset[1];
			WeaponAdjust[playerid][waOffSetZ][3] = offset[2];
			WeaponAdjust[playerid][waRotSetX][3] = rotset[0];
			WeaponAdjust[playerid][waRotSetY][3] = rotset[1];
			WeaponAdjust[playerid][waRotSetZ][3] = rotset[2];
			WeaponAdjust[playerid][waScaleSetX][3] = sizeset[0];
			WeaponAdjust[playerid][waScaleSetY][3] = sizeset[1];
			WeaponAdjust[playerid][waScaleSetZ][3] = sizeset[2];
			WeaponAdjust[playerid][waBone][3] = bone;
			
			WeaponAdjust[playerid][waID][3] = listitem;
			
			WeaponRefreshAttachments(playerid);
			Freeze(playerid, 1000);
			
			return 1;
		}
		case WEAPON_SHOTGUN, WEAPON_SHOTGSPA:
		{
			
			switch(type)
			{
				case 0:
				{
					offset[0] = FValasztShotgun[listitem][waOffSetD][0];
					offset[1] = FValasztShotgun[listitem][waOffSetD][1];
					offset[2] = FValasztShotgun[listitem][waOffSetD][2];
					
					rotset[0] = FValasztShotgun[listitem][waRotSetD][0];
					rotset[1] = FValasztShotgun[listitem][waRotSetD][1];
					rotset[2] = FValasztShotgun[listitem][waRotSetD][2];
					
				}
				case 1:
				{
					offset[0] = FValasztShotgun[listitem][waOffSetK][0];
					offset[1] = FValasztShotgun[listitem][waOffSetK][1];
					offset[2] = FValasztShotgun[listitem][waOffSetK][2];
					
					rotset[0] = FValasztShotgun[listitem][waRotSetK][0];
					rotset[1] = FValasztShotgun[listitem][waRotSetK][1];
					rotset[2] = FValasztShotgun[listitem][waRotSetK][2];
					
				}
				case 2:
				{
					offset[0] = FValasztShotgun[listitem][waOffSetV][0];
					offset[1] = FValasztShotgun[listitem][waOffSetV][1];
					offset[2] = FValasztShotgun[listitem][waOffSetV][2];
					
					rotset[0] = FValasztShotgun[listitem][waRotSetV][0];
					rotset[1] = FValasztShotgun[listitem][waRotSetV][1];
					rotset[2] = FValasztShotgun[listitem][waRotSetV][2];
					
				}
				default:
				{
					offset[0] = FValasztShotgun[listitem][waOffSetK][0];
					offset[1] = FValasztShotgun[listitem][waOffSetK][1];
					offset[2] = FValasztShotgun[listitem][waOffSetK][2];
					
					rotset[0] = FValasztShotgun[listitem][waRotSetK][0];
					rotset[1] = FValasztShotgun[listitem][waRotSetK][1];
					rotset[2] = FValasztShotgun[listitem][waRotSetK][2];
					
				}
			}
			sizeset[0] = FValasztShotgun[listitem][waScaleSet][0];
			sizeset[1] = FValasztShotgun[listitem][waScaleSet][1];
			sizeset[2] = FValasztShotgun[listitem][waScaleSet][2];
			bone = FValasztShotgun[listitem][waBone];
			
			if(offset[0] == F_NINCSERTEK || offset[1] == F_NINCSERTEK || offset[2] == F_NINCSERTEK ||
			rotset[0] == F_NINCSERTEK || rotset[1] == F_NINCSERTEK || rotset[2] == F_NINCSERTEK) return Msg(playerid, "Ehhez a skinhez nem!");
			
			WeaponAdjust[playerid][waOffSetX][4] = offset[0];
			WeaponAdjust[playerid][waOffSetY][4] = offset[1];
			WeaponAdjust[playerid][waOffSetZ][4] = offset[2];
			WeaponAdjust[playerid][waRotSetX][4] = rotset[0];
			WeaponAdjust[playerid][waRotSetY][4] = rotset[1];
			WeaponAdjust[playerid][waRotSetZ][4] = rotset[2];
			WeaponAdjust[playerid][waScaleSetX][4] = sizeset[0];
			WeaponAdjust[playerid][waScaleSetY][4] = sizeset[1];
			WeaponAdjust[playerid][waScaleSetZ][4] = sizeset[2];
			WeaponAdjust[playerid][waBone][4] = bone;
			
			WeaponAdjust[playerid][waID][4] = listitem;
			
			WeaponRefreshAttachments(playerid);
			Freeze(playerid, 1000);
			
			return 1;
		}
	}
	return 1;
}