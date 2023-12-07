#if defined __game_system_system_damage
	#endinput
#endif
#define __game_system_system_damage

#define VEHICLE_ARMORED_HEALTH	(100000.0)

#define BODYPART_SYSTEM_ENABLED

new
	Float: Health[MAX_PLAYERS],
	Float: Armour[MAX_PLAYERS],
	//LastVehicleDamage[MAX_PLAYERS],
	LastDamager[MAX_PLAYERS],
	LastDamagerDamage[MAX_PLAYERS],
	LastDamagerType[MAX_PLAYERS],
	LastDamage[MAX_PLAYERS],
	NextAvailableNoDamage[MAX_PLAYERS],
	LabTalalat[MAX_PLAYERS]
	//LastShot[MAX_PLAYERS],
	//LastShotFast[MAX_PLAYERS]
;

// CLIENT HEALTH & ARMOUR //
stock SetClientHealth(playerid, Float: health)
	return SetPlayerHealth(playerid, health);

stock GetClientHealth(playerid, &Float: health)
	return GetPlayerHealth(playerid, health);

stock SetClientArmour(playerid, Float: armour)
	return SetPlayerArmour(playerid, armour);

stock GetClientArmour(playerid, &Float: armour)
	return GetPlayerArmour(playerid, armour);

// SCRIPTED HEALTH //
stock GetPlayerHealth_Ex(playerid, &Float: val)
	return val = Health[playerid], 0;

stock SetPlayerHealth_Ex(playerid, Float: val)
{
	Health[playerid] = val;
	
	if(Health[playerid] < 0.0)
		Health[playerid] = 0.0;
	else if(Health[playerid] > MAXHP)
		Health[playerid] = MAXHP;
		
	SetPlayerHealth(playerid, Health[playerid]);
}
	
stock AddPlayerHealth_Ex(playerid, Float: val)
	return Health[playerid] += val, SetPlayerHealth_Ex(playerid, Health[playerid]);
	
stock SubPlayerHealth_Ex(playerid, Float: hp)
	return Health[playerid] -= val, SetPlayerHealth_Ex(playerid, Health[playerid]);

#define GetPlayerHealth GetPlayerHealth_Ex
#define SetPlayerHealth SetPlayerHealth_Ex
#define AddPlayerHealth AddPlayerHealth_Ex
#define SubPlayerHealth SubPlayerHealth_Ex
	
// SCRIPTED ARMOUR //
stock GetPlayerArmour_Ex(playerid, &Float: val)
	return val = Armour[playerid], 0;

stock SetPlayerArmour_Ex(playerid, Float: val)
{
	Armour[playerid] = val;
	
	if(Armour[playerid] < 0.0)
		Armour[playerid] = 0.0;
	else if(Armour[playerid] > MAXHP)
		Armour[playerid] = MAXHP;
		
	SetPlayerArmour(playerid, Armour[playerid]);
}
	
stock AddPlayerArmour_Ex(playerid, Float: val)
	return Armour[playerid] += val, SetPlayerArmour_Ex(playerid, Armour[playerid]);
	
stock SubPlayerArmour_Ex(playerid, Float: val)
	return Armour[playerid] -= val, SetPlayerArmour_Ex(playerid, Armour[playerid]);
	
#define GetPlayerArmour GetPlayerArmour_Ex
#define SetPlayerArmour SetPlayerArmour_Ex
#define AddPlayerArmour AddPlayerArmour_Ex
#define SubPlayerArmour SubPlayerArmour_Ex

/*#define GetPlayerHealth(%1,%2) (%2=Health[%1],1)
#define SetPlayerHealth(%1,%2) (Health[%1]=%2,SetClientHealth(%1,%2),1)
#define AddPlayerHealth(%1,%2) (Health[%1]+=%2,SetClientHealth(%1,Health[%1]),1)
#define SubPlayerHealth(%1,%2) (Health[%1]-=%2,SetClientHealth(%1,Health[%1]),1)

#define GetPlayerArmour(%1,%2) (%2=Armour[%1],1)
#define SetPlayerArmour(%1,%2) (Armour[%1]=%2,SetClientArmour(%1,%2),1)
#define AddPlayerArmour(%1,%2) (Armour[%1]+=%2,SetClientArmour(%1,Armour[%1]),1)
#define SubPlayerArmour(%1,%2) (Armour[%1]-=%2,SetClientArmour(%1,Armour[%1]),1)*/

#define WEAPON_DAMAGE_TYPES	55
#define DAMAGE_VEHICLE		49
#define DAMAGE_HELICOPTER	50
#define DAMAGE_EXPLOSION	51
#define DAMAGE_DROWN		53
#define DAMAGE_FALL			54

#define DAMAGE_UNKNOWN		-1
#define DAMAGE_DEFAULT		0
#define DAMAGE_OVERWRITE	1
#define DAMAGE_MULTIPLIER	2
#define DAMAGE_NULL			3
#define DAMAGE_NEUTRAL		4

#define LOG_DAMAGE_TAKE		0
#define LOG_DAMAGE_GIVE		1

enum customDamage
{
	wType,
	Float:wDamage
}
new const CustomDamage[WEAPON_DAMAGE_TYPES][customDamage] =
{
	// KÖZELHARCI FEGYVEREK
	{   DAMAGE_DEFAULT,  20.0}, //  0  ököl
	{   DAMAGE_DEFAULT,  40.0}, //  1  bokszer
	{   DAMAGE_DEFAULT,  30.0}, //  2  golf club
	{   DAMAGE_DEFAULT,  30.0}, //  3  nightstick
	{   DAMAGE_DEFAULT,  70.0}, //  4  kés
	{   DAMAGE_DEFAULT,  50.0}, //  5  bézbózütõ
	{   DAMAGE_DEFAULT,  50.0}, //  6  ásó
	{   DAMAGE_DEFAULT,  30.0}, //  7  dákó
	{   DAMAGE_DEFAULT, 100.0}, //  8  katana
	{        DAMAGE_NULL,   0.0}, //  9  láncfûrész
	{   DAMAGE_DEFAULT,   5.0}, // 10  kétvégû dildo
	{   DAMAGE_DEFAULT,   5.0}, // 11  dildo
	{   DAMAGE_DEFAULT,  10.0}, // 12  vibrátor
	{   DAMAGE_DEFAULT,  10.0}, // 13  ezüst vibrátor
	{   DAMAGE_DEFAULT,   3.0}, // 14  virág
	{   DAMAGE_DEFAULT,  20.0}, // 15  bot
	
	// DOBÓFEGYVER
	{     DAMAGE_DEFAULT,	0.0}, // 16  gránát
	{     DAMAGE_DEFAULT,	0.0}, // 17  füstgránát
	{     DAMAGE_DEFAULT,	0.0}, // 18  molotov
	
	// ???
	{     DAMAGE_UNKNOWN,	0.0}, // 19  ?
	{     DAMAGE_UNKNOWN,	0.0}, // 20  ?
	{     DAMAGE_UNKNOWN,	0.0}, // 21  ?
	
	// LÕFEGYVEREK - PISZTOLY
	{   DAMAGE_DEFAULT,  15.0}, // 22  colt
	{   DAMAGE_DEFAULT,  40.0}, // 23  silenced
	{   DAMAGE_DEFAULT,  70.0}, // 24  deagle
	
	// LÕFEGYVEREK - SHOTGUN
	{     DAMAGE_DEFAULT,	0.0}, // 25  shotgun
	{     DAMAGE_DEFAULT,	0.0}, // 26  shawnoff
	{     DAMAGE_DEFAULT,	0.0}, // 27  combat
	
	// LÕFEGYVEREK - AUTOMATA
	{	DAMAGE_DEFAULT,	8.0}, // 28  uzi
	{   DAMAGE_DEFAULT,  10.0}, // 29  mp5
	{   DAMAGE_DEFAULT,  25.0}, // 30  ak47
	{   DAMAGE_DEFAULT,  25.0}, // 31  m4
	{   DAMAGE_DEFAULT,	8.0}, // 32  tec9
	
	// KARABÉLY
	{   DAMAGE_DEFAULT,  50.0}, // 33  rifle
	{   DAMAGE_DEFAULT,  90.0}, // 34  sniper
	
	// NAGY KALIBERÛ
	{     DAMAGE_DEFAULT,	0.0}, // 35  rakéta
	{     DAMAGE_DEFAULT,	0.0}, // 36  hõkövetõ rakáta
	{     DAMAGE_DEFAULT,	0.0}, // 37  lángszóró
	{     DAMAGE_DEFAULT,	0.0}, // 38  minigun
	
	// EGYÉB
	{     DAMAGE_DEFAULT,	0.0}, // 39  c4
	{     DAMAGE_DEFAULT,	0.0}, // 40  detonátor
	{     DAMAGE_DEFAULT,	0.0}, // 41  spré
	{     DAMAGE_DEFAULT,	0.0}, // 42  poroltó
	{     DAMAGE_DEFAULT,	0.0}, // 43  kamera
	{     DAMAGE_DEFAULT,	0.0}, // 44  éjjellátó
	{     DAMAGE_DEFAULT,	0.0}, // 45  hõlátó
	{     DAMAGE_DEFAULT,	0.0}, // 46  ejtõernyõ
	{     DAMAGE_DEFAULT,	0.0}, // 47  fake pistol (?)
	{     DAMAGE_UNKNOWN,	0.0}, // 48  ?
	
	// SEBZÉSTÍPUSOK
	{        DAMAGE_NULL,   0.0}, // 49  jármû
	{        DAMAGE_NULL,	0.0}, // 50  helikopter
	{     DAMAGE_DEFAULT,	0.0}, // 51  robbanás
	{     DAMAGE_UNKNOWN,	0.0}, // 52  ?
	{     DAMAGE_NEUTRAL,	0.0}, // 53  fulladás
	{     DAMAGE_NEUTRAL,	0.0}  // 54  esés
};

////////////
// CONFIG //
////////////
// fej és láblövés, ha a támadott nem "érzékeli" vagy épp godemodeozik / laggol
// akkor biztosÃ­tott a láb, fejlövés, bizonyos mennyiség után
#define SHOOT_MIN_FEJ 8
#define SHOOT_MIN_LAB 6

stock GetDamageName(id)
{
	new nev[32];
	if(0 <= id < MAX_WEAPONS)
	{
		strmid(nev, aWeaponNames[id], 0, strlen(aWeaponNames[id]));
		return nev;
	}
		
	switch(id)
	{
		case DAMAGE_VEHICLE:
			nev = "Jarmu";
		case DAMAGE_HELICOPTER:
			nev = "Heli";
		case DAMAGE_EXPLOSION:
			nev = "Robbanas";
		case DAMAGE_DROWN:
			nev = "Fulladas";
		case DAMAGE_FALL:
			nev = "Zuhanas";
		default:
			nev = "Ismeretlen";
	}
	return nev;	
}

public OnPlayerTakeDamage(playerid, issuerid, Float: amount, weaponid, bodypart)
{
	//OnPlayerHit(playerid, issuerid, weaponid, amount, bodypart);
	return 1;
}

public OnPlayerGiveDamage(playerid, damagedid, Float: amount, weaponid, bodypart)
{
	/*new firstcheck = true, secondcheck = true, slot = WeaponHaveWeapon(playerid, weaponid);
	if(slot == NINCS)
		firstcheck = false;
	if(PlayerWeapons[playerid][pArmed] != weaponid || PlayerWeapons[playerid][pArmedSlot] != slot || slot == NINCS) secondcheck = false;
	if(!firstcheck || !secondcheck)
	{
		if(CGBanned[playerid] == 0)
		{
			CGBanned[playerid] = 1;
			SendFormatMessageToAll(COLOR_LIGHTRED, "ClassRPG: %s ki lett bannolva a ClassGuard által | Oka: Fegyver cheat", PlayerName(playerid));
			SeeBan(playerid, 0, NINCS, "[CG] Fegyver cheat");
		}	
	}*/
	
	if(CUSTOM_HITBOX != 0) return 1;
	if(0 <= weaponid < WEAPON_DAMAGE_TYPES) switch(CustomDamage[weaponid][wType])
	{
		case DAMAGE_DEFAULT, DAMAGE_OVERWRITE, DAMAGE_MULTIPLIER:
			LogDamage(LOG_DAMAGE_GIVE, damagedid, playerid, weaponid, amount);
	}
	
	OnPlayerHit(damagedid, playerid, weaponid,amount, bodypart);
	
	//OnPlayerHit(damagedid, playerid, weaponid, amount, bodypart);
	bodypart = BODY_PART_TORSO;
	
	//SendFormatMessageToAll(COLOR_WHITE, "OPGD(playerid: %d, damagedid: %d, amount: %.2f, weaponid: %d)", playerid, damagedid, amount, playerid);
/*    if(damagedid != INVALID_PLAYER_ID)
    {
	
		new str[200], Float:hp, Float:armor, Float:tav;
		
		GetPlayerHealth(damagedid, hp);
		GetPlayerArmour(damagedid, armor);
		tav = GetDistanceBetweenPlayers(playerid, damagedid);
		
		new testresz[8], esc[10];
		
		switch(bodypart)
		{
			case BODY_PART_HEAD:
			{
				testresz = " (fej)";
				
				if(!Animban[damagedid])
				{
					Shoot2[damagedid][0] += 2;
					if(Shoot2[damagedid][0] >= SHOOT_MIN_FEJ)
					{
						//OnPlayerHit(damagedid, playerid, bodypart, weaponid, amount);
						Shoot2[damagedid][0] = 0;
					}
				}
			}
			case BODY_PART_LEFT_LEG, BODY_PART_RIGHT_LEG:
			{
				testresz = " (lab)";
				
				if(!Animban[damagedid])
				{
					Shoot2[damagedid][1] += 2;
					if(Shoot2[damagedid][1] >= SHOOT_MIN_LAB)
					{
						//OnPlayerHit(damagedid, playerid, bodypart, weaponid, amount);
						Shoot2[damagedid][1] = 0;
					}
				}
			}
		}
		
		if(SzunetIdo[damagedid])
			format(esc, 10, " (%ds)", SzunetIdo[damagedid]);
		else
			Shoot[damagedid][1]++;
		
		format(str, 200, "%s meglotte ot: %s%s%s | fegyver: %s(%d) | Elet/Pancel: %.0f/%.0f (%.0f) | Tav: %0.1f", Nev(playerid), Nev(damagedid), esc, testresz, GetGunName(weaponid), GetPlayerAmmo(playerid), hp, armor, amount, tav);
		
		Log("Shoot2", str);
    }*/
    return 1;
}

stock LogDamage(type, playerid, attacker, damageType, Float: damage)
{
	new
		Float: cHealth, Float: cArmour
	;
	
	GetPlayerHealth(playerid, cHealth);
	GetPlayerArmour(playerid, cArmour);
	
	if(attacker != INVALID_PLAYER_ID)
		tformat(256, "%s sebzest kapott tole: %s | sebzes: %s (-%.1f) | E/P: %.1f/%.1f (S: %.1f/%.1f) | Tav: %.1f", \
			PlayerName(playerid), PlayerName(attacker), GetDamageName(damageType), damage, cHealth, cArmour, Health[playerid], Armour[playerid], GetDistanceBetweenPlayers(playerid, attacker));
	else
		tformat(256, "%s sebzest kapott | sebzes: %s (-%.1f) | E/P: %.1f/%.1f (S: %.1f/%.1f)", \
			PlayerName(playerid), GetDamageName(damageType), damage, cHealth, cArmour, Health[playerid], Armour[playerid]);
			
	Log( (type == LOG_DAMAGE_TAKE) ? ("Damage") : ("DamageEx"), _tmpString );
}

stock OnPlayerHit(playerid, attacker, damageType, Float:amount, bodypart)
{
	#if !defined BODYPART_SYSTEM_ENABLED
	bodypart = BODY_PART_TORSO;
	#endif

	// prevent vehicle damage
	if(damageType == DAMAGE_VEHICLE)
		return 0;
		
	// anti vehicle flood
	/*if(damageType == DAMAGE_VEHICLE)
	{
		if(LastVehicleDamage[playerid] == UnixTime)
			return 0;
		else
			LastVehicleDamage[playerid] = UnixTime;
	}*/
	
	////////////////////
	// PREVENT DAMAGE //
	////////////////////
	if(IsPlayerNPC(playerid) || Ajtozott[playerid] > 0 || AdminDuty[playerid] || Warozott[playerid] >= UnixTime || NoDamage[playerid] || SpawnVedelem[playerid]
		|| PlayerVehicle[playerid] != NINCS && ArmoredVehicle[PlayerVehicle[playerid]]
		|| attacker != INVALID_PLAYER_ID && ( NemMozoghat(attacker) || AdminDuty[attacker] )
		|| PlayerBulletProof[playerid]
	)
		return 0;
	
	/////////////////////
	// DAMAGE MODIFIER //
	/////////////////////
	new Float:damage;
	if(0 <= damageType < WEAPON_DAMAGE_TYPES) switch(CustomDamage[damageType][wType])
	{
		case DAMAGE_DEFAULT, DAMAGE_NEUTRAL:
			damage = amount;
		case DAMAGE_OVERWRITE:
			damage = CustomDamage[damageType][wDamage];
		case DAMAGE_MULTIPLIER:
			damage = amount * CustomDamage[damageType][wDamage];
		//case DAMAGE_NULL, DAMAGE_NEUTRAL:
		//	damage = 0;
		//default:
		//	damage = 0;
	}
	
	///////////
	// SKILL //
	///////////
	if(damageType == WEAPON_COLT45)
	{
		new skill = PlayerInfo[attacker][pFegyverSkillek][WEAPONSKILL_PISTOL];
		if(skill >= 600)
			damage += 15;
			
		if(skill >= 1000)
			damage += 15;
	}
	
/*	///////////////////////
	// BODYPART MODIFIER //
	///////////////////////
	switch(bodypart)
	{
		//////////////
		// HEADSHOT //
		//////////////
		case BODY_PART_HEAD:
		{
			damage *= 2.0;
		}
		
		//////////////
		// ARM SHOT //
		//////////////
		case BODY_PART_LEFT_ARM, BODY_PART_RIGHT_ARM:
			damage *= 0.75;
		
		//////////////
		// LEG SHOT //
		//////////////
		case BODY_PART_LEFT_LEG, BODY_PART_RIGHT_LEG:
		{
			damage *= 0.75;
		}
		
	}

	////////////////////
	// POST MODIFIERS //
	////////////////////
	*/
	if(PlayerSkin[playerid] == 285 && PajzsNala[playerid]) // swat
		damage *= 0.75;

	if(pGumilovedek[attacker] != NINCS)
		damage *= 0.5;
		
	//if(PajzsNala[playerid] && PlayerSkin[playerid] == 285)
	//	damage *= 0.75;
 
	////////////////////
	// PREVENT DAMAGE //
	////////////////////
	////////////////////
	if(damage <= 0.0) //
		return 0;	  //
	////////////////////
	
	LogDamage(LOG_DAMAGE_TAKE, playerid, attacker, damageType, damage);
	
	if(22 <= damageType <= 38)
	{
		PlayerInfo[playerid][pLoves] = UnixTime + 120;
		PlayerInfo[playerid][pEllatva] = true;
		//Shooted[playerid][issuerid] = UnixTime;
	}
	
	////////////////
	// TÉRFIGYELÕ //
	////////////////
	if(attacker != INVALID_PLAYER_ID
		&& 22 <= damageType <= 38 && !PLAYER_MARKER_IS_HIDDEN(attacker) && !PlayerMarker[attacker][mHidden] && !IsACop(attacker) && PlayerMarker[attacker][mLastShoot] != UnixTime
		&& (PLAYER_MARKER_WEAPONS_SHOOT(attacker)
			|| (WeaponArmed(attacker) == WEAPON_RIFLE || WeaponArmed(attacker) == WEAPON_SNIPER) && GetDistanceBetweenPlayers(attacker, playerid) <= PLAYER_MARKER_RIFLE_DISTANCE)
	)
	{
		PlayerMarker[attacker][mLastShoot] = UnixTime;
		
		switch(PlayerMarker[attacker][mType])
		{
			case PLAYER_MARKER_SHOOT:
			{
				if((PlayerMarker[attacker][mTime] + PLAYER_MARKER_TIME_SHOOT) > PLAYER_MARKER_MTIME_SHOOT)
					PlayerMarker[attacker][mTime] = PLAYER_MARKER_MTIME_SHOOT;
				else
					PlayerMarker[attacker][mTime] += PLAYER_MARKER_TIME_SHOOT;
			}
			case PLAYER_MARKER_KILL:
			{
				if((PlayerMarker[attacker][mTime] + PLAYER_MARKER_TIME_KILL_SHOOT) > PLAYER_MARKER_MTIME_KILL)
					PlayerMarker[attacker][mTime] = PLAYER_MARKER_MTIME_KILL;
				else
					PlayerMarker[attacker][mTime] += PLAYER_MARKER_TIME_KILL_SHOOT;
			}
			case PLAYER_MARKER_MKILL:
			{
				if((PlayerMarker[attacker][mTime] + PLAYER_MARKER_TIME_MKILL_SHOOT) > PLAYER_MARKER_MTIME_MKILL)
					PlayerMarker[attacker][mTime] = PLAYER_MARKER_MTIME_MKILL;
				else
					PlayerMarker[attacker][mTime] += PLAYER_MARKER_TIME_MKILL_SHOOT;
			}
			default:
			{
				MarkerAction(attacker, PLAYER_MARKER_SET, PLAYER_MARKER_SHOOT);
			}
		}
	}
	
	new bool:kikerulve = (random(100)+1) <= Gyemantjai[playerid];
	if(kikerulve)
		return !Msg(playerid, "[Gyémánt] Hála az ügyességednek, kikerültél egy találatot");
		
	///////////////////////////////
	// NEW TAZER SYSTEM BY PEDRO //
	///////////////////////////////
	
	if(IsACop(attacker) && Tazer[attacker] && Sokkolt[attacker] == 0 && (WeaponArmed(attacker) == WEAPON_DEAGLE || WeaponArmed(attacker) == WEAPON_SILENCED) && OnDuty[attacker] && GetPlayerState(attacker) == PLAYER_STATE_ONFOOT)
	{
		new fail, chancetofail = random(100);
		switch(chancetofail)
		{
			case 0..35: fail = 1;
			default: fail = 0;
		}
		if(IsPlayerInWater(attacker) || IsPlayerInWater(playerid)) { Msg(attacker, "VÃ­zben lévõt akarsz lesokkolni? Az áram agyonüt titeket!"); fail = 1; }
		if(GetDistanceBetweenPlayers(attacker, playerid) > 25.0 || IsPlayerNPC(playerid)) { Msg(attacker, "Nincs a közeledben senki, vagy odáig nem ér el a sokkoló feje!"); fail = 1; }
		if(fail)
		{
			SendClientMessage(playerid, COLOR_LIGHTBLUE, "* Majdnem lesokkolt egy rendõr! Vigyázz!");
			SendClientMessage(attacker, COLOR_LIGHTBLUE, "* Nem tudtad lesokkolni a célszemélyt!");
			Cselekves(attacker, "lõ a sokkolóval, de nem tudja lesokkolni a célszemélyt", 1);
			GameTextForPlayer(playerid, "~r~Majdnem lesokkoltak!", 2500, 3);
			Sokkolt[attacker] = 5;
			return 1;
		}

		if(Rabol[playerid] == 1) Rabol[playerid] = 0;
		if(Tazer[playerid]) Tazer[playerid] = false;
		SendClientMessage(playerid, COLOR_LIGHTBLUE, "* Lesokkolt egy rendõr, és 60 másodpercig megbénultál.");
		SendClientMessage(attacker, COLOR_LIGHTBLUE, "* Lesokkoltad 60 másodpercre.");
		Cselekves(attacker, "lõ a sokkolóval, és lesokkolja a célszemélyt", 1);
		GameTextForPlayer(playerid, "~r~Sokkoltak", 2500, 3);
		Bilincs(playerid, 1);
		ApplyAnimation(playerid,"CRACK","crckdeth2",4.1,0,1,1,1,0);
		WeaponArm(playerid);
		Sokkolt[attacker] = 15;
		return 1;
	}
		
	//////////////////////////
	// DEAL THE REAL DAMAGE //
	//////////////////////////
	new Float: newhp = Health[playerid], Float: newarmour = Armour[playerid];
	
	if(attacker != INVALID_PLAYER_ID)
	{
		newarmour -= damage;
		if(newarmour < 0)
		{
			newhp += newarmour;
			newarmour = 0;
		}
	}
	else
		newhp -= damage;
		
	if(!Animban[playerid] && !Paintballozik[playerid] && !Kikepzoben[playerid] && newhp < 15.0 && NextAvailableNoDamage[playerid] < UnixTime && bodypart != BODY_PART_HEAD)
	{
		NoDamage[playerid] = 3;
		newhp = 15.0;
		AnimbaRak(playerid);
		NextAvailableNoDamage[playerid] = UnixTime + 30;
	}
	if(damageType == DAMAGE_FALL && !Animban[playerid] && !Paintballozik[playerid] && !Kikepzoben[playerid] && NextAvailableNoDamage[playerid] < UnixTime && damage >= 15.0)
	{
		NoDamage[playerid] = 3;
		newhp -= 50.0;
		AnimbaRak(playerid);
		NextAvailableNoDamage[playerid] = UnixTime + 30;
	}
	
	SetPlayerHealth(playerid, newhp);
	SetPlayerArmour(playerid, newarmour);
	
	LastDamage[playerid] = UnixTime;
	if(attacker != INVALID_PLAYER_ID)
	{
		ScriptShoot[playerid] = true;
		Shooted[playerid][attacker] = UnixTime;
		LastDamager[playerid] = attacker;
		LastDamagerDamage[playerid] = UnixTime;
		LastDamagerType[playerid] = damageType;
	}
	
	if(PlayerSkin[playerid] == 285 && Armour[playerid] >= 100.0) return 0; //SWAT
	//if(PlayerSkin[playerid] == 285 && PajzsNala[playerid] && Armour[playerid] >= 100.0) return 0; //SWAT pajzs
	
	////////////
	// SNIPER //
	////////////
	if(damageType == 34 && Armour[playerid] <= 0.0 && !Paintballozik[playerid]) // sniper = 1 lövés anim
	{
		if(pGumilovedek[attacker] != NINCS)
		{
			SendFormatMessage(playerid, COLOR_LIGHTRED, "Sérülés: Sniperrel meglõttek, ezért összeestél (#%d)", PlayerInfo[attacker][pBID]);
			SendClientMessage(playerid, COLOR_LIGHTRED, "ClassRPG: fél perc múlva feltudsz kelni. Ha kikepzés van menj biztonságba és ne zavard a többieket!");
			Msg(attacker, "Eltaláltad, ezért nem tud mozogni, de hamarosan magához tér.");
			Freeze(playerid, 30*1000);
			ApplyAnimation(playerid, "SWEET", "Sweet_injuredloop", 4.0, 1, 0, 0, 0, 0);
			return 0;
		}
		SendFormatMessage(playerid, COLOR_LIGHTRED, "Sérülés: Sniperrel meglõttek, ezért súlyosan megsérültél (#%d)", PlayerInfo[attacker][pBID]);
		Msg(attacker, "Eltaláltad, ezért nem tud mozogni.");
		AnimbaRak(playerid, false);
		new sniplog[128]; format(sniplog, 128, "%s sniperrel meglõtte õt: %s", PlayerName(attacker), PlayerName(playerid)); Log("Kill", sniplog);
		PlayerInfo[playerid][pLoves] = UnixTime + 600;
		PlayerInfo[playerid][pEllatva] = true;
	}
	///////////
	// RIFLE //
	///////////
	else if(damageType == 33 && Armour[playerid] <= 0.0 && !Paintballozik[playerid]) // rifle = 2 lövés 10 másodpercen belül = anim
	{			
		if(RifleTalalat[playerid] > 0)
		{
			if(pGumilovedek[attacker] != NINCS)
			{
				SendFormatMessage(playerid, COLOR_LIGHTRED, "Sérülés: Többször is meglõttek Riflevel, ezért összeestél (#%d)", PlayerInfo[attacker][pBID]);
				SendClientMessage(playerid, COLOR_LIGHTRED, "ClassRPG: fél perc múlva feltudsz kelni. Ha kikepzés van menj biztonságba és ne zavard a többieket!");
				Msg(attacker, "Többször is meglõtted Riflevel, de hamarosan magához tér.");
				Freeze(playerid, 30*1000);
				ApplyAnimation(playerid, "SWEET", "Sweet_injuredloop", 4.0, 1, 0, 0, 0, 0);
				return 0;
			}
			SendFormatMessage(playerid, COLOR_LIGHTRED, "Sérülés: Többször is meglõttek Riflevel, ezért súlyosan megsérültél (#%d)", PlayerInfo[attacker][pBID]);
			Msg(attacker, "Többször is meglõtted Riflevel, ezért súlyosan megsérült.");
			AnimbaRak(playerid, false);
			new riflelog[128]; format(riflelog, 128, "%s riflevel animba lõtte õt õt: %s", PlayerName(attacker), PlayerName(playerid)); Log("Kill", riflelog);
			PlayerInfo[playerid][pLoves] = UnixTime+300;
			PlayerInfo[playerid][pEllatva] = true;
		}
		RifleTalalat[playerid] = 10;
	}
	
	#if defined BODYPART_SYSTEM_ENABLED
	else if(bodypart == BODY_PART_HEAD)
	{
		if(Paintballozik[playerid])
		{
			NoDamage[playerid] = 5;
			if(damageType == 22) PlayerInfo[attacker][pFegyverSkillek][0] += PBSKILL_FEJ, SendClientMessage(attacker, COLOR_YELLOW, "A Colt45 skilled emelkedett "#PBSKILL_FEJ" ponttal");
			if(damageType == 23) PlayerInfo[attacker][pFegyverSkillek][1] += PBSKILL_FEJ, SendClientMessage(attacker, COLOR_YELLOW, "A Silenced skilled emelkedett "#PBSKILL_FEJ" ponttal");
			if(damageType == 24) PlayerInfo[attacker][pFegyverSkillek][2] += PBSKILL_FEJ, SendClientMessage(attacker, COLOR_YELLOW, "A Deagle skilled emelkedett "#PBSKILL_FEJ" ponttal");
			if(damageType == 25) PlayerInfo[attacker][pFegyverSkillek][3] += PBSKILL_FEJ, SendClientMessage(attacker, COLOR_YELLOW, "A Shotgun skilled emelkedett "#PBSKILL_FEJ" ponttal");
			if(damageType == 27) PlayerInfo[attacker][pFegyverSkillek][5] += PBSKILL_FEJ, SendClientMessage(attacker, COLOR_YELLOW, "A Combat skilled emelkedett "#PBSKILL_FEJ" ponttal");
			if(damageType == 29) PlayerInfo[attacker][pFegyverSkillek][7] += PBSKILL_FEJ, SendClientMessage(attacker, COLOR_YELLOW, "Az MP5 skilled emelkedett "#PBSKILL_FEJ" ponttal");
			if(damageType == 30) PlayerInfo[attacker][pFegyverSkillek][8] += PBSKILL_FEJ, SendClientMessage(attacker, COLOR_YELLOW, "Az AK47 skilled emelkedett "#PBSKILL_FEJ" ponttal");
			if(damageType == 31) PlayerInfo[attacker][pFegyverSkillek][9] += PBSKILL_FEJ, SendClientMessage(attacker, COLOR_YELLOW, "Az M4 skilled emelkedett "#PBSKILL_FEJ" ponttal");
			FegyverSkillFrissites(attacker);
			Msg(playerid, "Fejen lõttek, ezért kiestél, hamarosan újraéledsz");
			Msg(attacker, "Fejen lõtted, ezért kiesett");
			new Float:hp; GetPlayerHealth(attacker, hp);
			SetPlayerHealth(attacker, hp+random(100));
			PlayerPlaySound(attacker, 17802, 0.0, 0.0, 0.0);
			SetPlayerHealth(playerid, 0.0);
			return 0;
		}

		if(pGumilovedek[attacker] != NINCS)
		{
			SendFormatMessage(playerid, COLOR_LIGHTRED, "ClassRPG: Fejen lõttek, ezért eszméletedet vesztetted (#%d)", PlayerInfo[attacker][pBID]);
			SendClientMessage(playerid, COLOR_LIGHTRED, "ClassRPG: fél perc múlva feltudsz kelni. Ha kikepzés van menj biztonságba és ne zavard a többieket!");
			Msg(attacker, "Fejen lõtted, ezért eszméletét vesztette, de hamarosan magához tér.");
			Freeze(playerid, 30*1000);
			ApplyAnimation(playerid, "SWEET", "Sweet_injuredloop", 4.0, 1, 0, 0, 0, 0);
			return 0;
		}
		
		if(!Paintballozik[playerid] && !Kikepzoben[playerid] && !Halal[playerid])
		{
			SendFormatMessage(playerid, COLOR_LIGHTRED, "ClassRPG: Fejen lõttek, ezért eszméletedet vesztetted (#%d)", PlayerInfo[attacker][pBID]);
			Msg(attacker, "Fejen lõtted, ezért eszméletét vesztette.");
			PlayerInfo[playerid][pEllatva] = false;
			/*PlayerInfo[attacker][pOlesIdo] += K_OLES_IDO;
			tformat(128, "%s plusz kórház jail ideje %d másodpercre nõtt (+"#K_OLES_IDO"mp)", PlayerName(attacker), PlayerInfo[attacker][pOlesIdo]);
			KillLog(_tmpString, 0);*/
		}
		if(Harcol[playerid])
			HarcKieses(playerid, "Fejen lõtték");
		else
			SetPlayerHealth(playerid, 0.0);
		
		tformat(128, "%s fejen lõtte õt: %s", PlayerName(attacker), PlayerName(playerid)); Log("Kill", _tmpString);
	}
	else if(bodypart == BODY_PART_LEFT_LEG || bodypart == BODY_PART_RIGHT_LEG)
	{			
		if(Paintballozik[playerid])
	    {
			NoDamage[playerid] = 5;
			if(damageType == 22) PlayerInfo[attacker][pFegyverSkillek][0] += PBSKILL_LAB, SendClientMessage(attacker, COLOR_YELLOW, "A Colt45 skilled emelkedett "#PBSKILL_LAB" ponttal");
			if(damageType == 23) PlayerInfo[attacker][pFegyverSkillek][1] += PBSKILL_LAB, SendClientMessage(attacker, COLOR_YELLOW, "A Silenced skilled emelkedett "#PBSKILL_LAB" ponttal");
			if(damageType == 24) PlayerInfo[attacker][pFegyverSkillek][2] += PBSKILL_LAB, SendClientMessage(attacker, COLOR_YELLOW, "A Deagle skilled emelkedett "#PBSKILL_LAB" ponttal");
			if(damageType == 25) PlayerInfo[attacker][pFegyverSkillek][3] += PBSKILL_LAB, SendClientMessage(attacker, COLOR_YELLOW, "A Shotgun skilled emelkedett "#PBSKILL_LAB" ponttal");
			if(damageType == 27) PlayerInfo[attacker][pFegyverSkillek][5] += PBSKILL_LAB, SendClientMessage(attacker, COLOR_YELLOW, "A Combat skilled emelkedett "#PBSKILL_LAB" ponttal");
			if(damageType == 29) PlayerInfo[attacker][pFegyverSkillek][7] += PBSKILL_LAB, SendClientMessage(attacker, COLOR_YELLOW, "Az MP5 skilled emelkedett "#PBSKILL_LAB" ponttal");
			if(damageType == 30) PlayerInfo[attacker][pFegyverSkillek][8] += PBSKILL_LAB, SendClientMessage(attacker, COLOR_YELLOW, "Az AK47 skilled emelkedett "#PBSKILL_LAB" ponttal");
			if(damageType == 31) PlayerInfo[attacker][pFegyverSkillek][9] += PBSKILL_LAB, SendClientMessage(attacker, COLOR_YELLOW, "Az M4 skilled emelkedett "#PBSKILL_LAB" ponttal");
			FegyverSkillFrissites(attacker);
			new Float:hp; GetPlayerHealth(attacker, hp);
			SetPlayerHealth(attacker, hp+random(50));
			Msg(playerid,"Lábon lõttek, ezért kiestél, hamarosan újraéledsz");
			Msg(attacker,"Lábon lõtted, ezért kiesett");
			SetHealth(playerid, 0.0);
			PlayerPlaySound(attacker, 17802, 0.0, 0.0, 0.0);
			return 0;
		}

		if(pGumilovedek[attacker] != NINCS)
		{
			SendFormatMessage(playerid, COLOR_LIGHTRED, "ClassRPG: Lábon lÅ‘ttek, ezért összeestél (#%d)", PlayerInfo[attacker][pBID]);
			SendClientMessage(playerid, COLOR_LIGHTRED, "ClassRPG: fél perc múlva feltudsz kelni. Ha kikepzés van menj biztonságba és ne zavard a többieket!");
			Msg(attacker, "Lábon lÅ‘tted, ezért összeesett, de hamarosan felkel.");
			Freeze(playerid, 30*1000);
			ApplyAnimation(playerid, "SWEET", "Sweet_injuredloop", 4.0, 1, 0, 0, 0, 0);
			return 0;
		}
		
		LabTalalat[playerid] ++;
		if(LabTalalat[playerid] >= 2)
		{
			SendFormatMessage(playerid, COLOR_LIGHTRED, "ClassRPG: Lábon lõttek, ezért súlyosan megsebesültél (#%d)", PlayerInfo[attacker][pBID]);
			Msg(attacker, "Lábon lõtted, ezért megsebesült.");
			if(!AdminDuty[attacker] && !Harcol[attacker] && !Paintballozik[attacker] && !Kikepzoben[attacker] && !Halal[attacker])
			{
				PlayerInfo[attacker][pOlesIdo] +=K_LAB_IDO;
				tformat(128, "%s plusz kórház jail ideje %d másodpercre nõtt (+"#K_LAB_IDO"mp)", PlayerName(attacker), PlayerInfo[attacker][pOlesIdo]);
				KillLog(_tmpString, 0);
			}
			AnimbaRak(playerid, false);
			PlayerInfo[playerid][pLoves] = UnixTime+300;
			PlayerInfo[playerid][pEllatva] = true;
			LabTalalat[playerid] = 0;
			tformat(128, "%s lábon lõtte õt: %s", PlayerName(attacker), PlayerName(playerid)); Log("Kill", _tmpString);
		}
		//SendFormatMessage(playerid, COLOR_WHITE, "[Debug] Lábon lõttek, ez a %d. lábtalálatod", LabTalalat[playerid]);
		//SendFormatMessage(attacker, COLOR_WHITE, "[Debug] Lábon lõtted, ez a %d. lábtalálata", LabTalalat[playerid]);
	}
	#endif // bodypart system enabled

	return 1;
}

public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
	/*new firstcheck = true, secondcheck = true, slot = WeaponHaveWeapon(playerid, weaponid);
	if(slot == NINCS)
		firstcheck = false;
	if(PlayerWeapons[playerid][pArmed] != weaponid || PlayerWeapons[playerid][pArmedSlot] != slot || slot == NINCS) secondcheck = false;
	if(!firstcheck || !secondcheck)
	{
		if(CGBanned[playerid] == 0)
		{
			CGBanned[playerid] = 1;
			SendFormatMessageToAll(COLOR_LIGHTRED, "ClassRPG: %s ki lett bannolva a ClassGuard által | Oka: Fegyver cheat", PlayerName(playerid));
			SeeBan(playerid, 0, NINCS, "[CG] Fegyver cheat");
		}
	}*/
	
	if(CUSTOM_HITBOX != 1) return 1;
	
	if(hittype == BULLET_HIT_TYPE_PLAYER)
	{
		if(!IsPlayerConnected(hitid)) return 1;
		
		new model = GetPlayerSkin(hitid);
		new talalat = GetHitBox(model, fX, fY, fZ);
		
		//if(talalat == NINCS) return Msg(playerid, "Nem jó valami");
		
		//if(talalat != 9) return Msg(playerid, "Még mindig nem jó valami");
		if(talalat == NINCS) talalat = BODY_PART_TORSO;
		
		//new Float:amount = CustomDamage[weaponid][wDamage];
		new Float:amount = 20;
		OnPlayerHit(hitid, playerid, weaponid, amount, talalat);
		
		return 1;
	}
	/*switch(hittype)
	{
		case BULLET_HIT_TYPE_VEHICLE:
		{
			if(!ArmoredVehicle[hitid])
			{
				new Float: hp;
				GetVehicleHealth(hitid, hp);
				if(hp < 250.0)
					SetVehicleHealth(hitid, 250.0);
				else if(hp > 250.0)
				{
					hp -= 30.0;
				
					if(hp < 250.0)
						SetVehicleHealth(hitid, 250.0);
					else
						SetVehicleHealth(hitid, hp);
				}
			}
			return 0;
		}
	}*/
	return 1;
}
fpublic LoadHitboxes()
{
	new fajl[64];
	new keres = NINCS;
	new model = NINCS;
	for(new i;i<312;i++) //MAX_SKIN
	{
		model = i;
		for(new kereses;kereses<3;kereses++)
		{
			switch(kereses)
			{
				case 0: keres = BODY_PART_HEAD;
				case 1: keres = BODY_PART_LEFT_LEG;
				case 2: keres = BODY_PART_RIGHT_LEG;
				default: keres = BODY_PART_TORSO;
			}
			format(fajl, sizeof(fajl), "data/hitbox/%d-%d.cfg", model, keres);
			new File: file = fopen(fajl, io_read);
			if(!file)
			{
				format(fajl, sizeof(fajl), "data/hitbox/default-%d.cfg", keres);
				new File: file2 = fopen(fajl, io_read);
				if(!file2) return CUSTOM_HITBOX = 0;
			}
			
			new arrCoords[7][64];
			new strFromFile2[256];
			
			new idx;
			while (idx < MAX_HITBOX_DATA)
			{
				fread(file, strFromFile2);
				split(strFromFile2, arrCoords, ',');
				HitBoxData[model][idx][ePos][0] = floatstr(arrCoords[0]);
				HitBoxData[model][idx][ePos][1] = floatstr(arrCoords[1]);
				HitBoxData[model][idx][ePos][2] = floatstr(arrCoords[2]);
				HitBoxData[model][idx][eTalalat] = keres;
				idx++;
			}
			fclose(file);
			
		}
	}
	return 1;
}

stock GetHitBox(model, Float:fX, Float:fY, Float:fZ)
{
		new talalat = NINCS;
		for(new i=0; i<MAX_HITBOX_DATA;i++)
		{
			if((HitBoxData[model][i][ePos][0] > fX-0.4 && HitBoxData[model][i][ePos][0] < fX+0.2)
			&& (HitBoxData[model][i][ePos][1] > fY-0.4 && HitBoxData[model][i][ePos][1] < fY+0.2)
			&& (HitBoxData[model][i][ePos][2] > fZ-0.4 && HitBoxData[model][i][ePos][2] < fZ+0.2))
			{
				talalat = HitBoxData[model][i][eTalalat];
				break;
			}
		}
		
		if(talalat != BODY_PART_HEAD && talalat != BODY_PART_LEFT_LEG && talalat != BODY_PART_RIGHT_LEG) talalat = NINCS;
		return talalat;
}

public OnPlayerShootDynamicObject(playerid, weaponid, objectid, Float:x, Float:y, Float:z)
{
	for(new a = 0; a < MAX_DEER; a++)
	{
		if(DeerInfo[a][dObject] != objectid) continue;
		if(weaponid != 25 && weaponid != 33 && weaponid != 34) return 0;
		if(DeerInfo[a][dKilled]) break;
		new Float:pos[3]; new Float:playerpos[3];
		GetPlayerPos(playerid, ArrExt(playerpos));
		GetObjectPos(objectid, ArrExt(pos));
		DeerInfo[a][dDistance] = GetDistanceBetweenPoints(ArrExt(pos), ArrExt(playerpos));
		SetObjectRot(objectid, 90, 0, 0);
		SetObjectPos(objectid, pos[0], pos[1], pos[2]-0.4);
		Msg(playerid, "Eltaláltál egy õzet");
		DeerInfo[a][dKilled] = true;
		DeerInfo[a][dSupplied] = false;
		DeerInfo[a][dHealth] = 100;
		DeerInfo[a][dWeaponType] = weaponid;
		DeerInfo[a][dKiller] = ICPlayerName(playerid);
		tformat(128, "[Õz] Egészség: %d százalék\nMegölte: %s (ezzel: %s)\nMég nincs ellátva", DeerInfo[a][dHealth], DeerInfo[a][dKiller], GunName(weaponid));
		UpdateDynamic3DTextLabelText(DeerInfo[a][dLabel], 0x8B4513EE, _tmpString);
		break;
	}
	if(Loterben[playerid] != NINCS && LoterInfo[Loterben[playerid]][lTalalt] == false)
	{
		new l = Loterben[playerid], szoveg[200];
		if(LoterInfo[l][lObject] == objectid)
		{
			if(LoterInfo[l][lLoheto] == false)
			{
				SendClientMessage(playerid,COLOR_LIGHTRED,"[Lõtér] Rálõttél egy túszra! [2 HIBAPONT]");
				KillTimer(LoterInfo[l][lObjectTimer]);
				KillTimer(LoterInfo[l][lTimer]);
				format(szoveg,200,"A játékos(%d) rálõtt a túszra a lõtérben(%d)",playerid,l);
				if(IsValidDynamicObject(LoterInfo[l][lObject])) DestroyDynamicObject(LoterInfo[l][lObject]), LoterInfo[l][lObject]=INVALID_OBJECT_ID;
				Streamer_Update(playerid);
				LoterInfo[l][lTalalat] -= 2;
				LoterInfo[l][lObjectTimer] = SetTimerEx("LoterGyakorlat", 1000, false, "dd", l, playerid);
				LoterInfo[l][lTalalt] = true;
			}
			else
			{
				KillTimer(LoterInfo[l][lObjectTimer]);
				KillTimer(LoterInfo[l][lTimer]);
				SendClientMessage(playerid,COLOR_LIGHTGREEN,"[Lõtér] Lelõttél egy ellenséget! [5 PONT]");
				format(szoveg,200,"A játékos(%d) lelõtte az ellenséget a lõtérben(%d)",playerid,l);
				if(IsValidDynamicObject(LoterInfo[l][lObject])) DestroyDynamicObject(LoterInfo[l][lObject]), LoterInfo[l][lObject]=INVALID_OBJECT_ID;
				LoterInfo[l][lTalalat] +=5;
				Streamer_Update(playerid);
				LoterInfo[l][lObjectTimer] = SetTimerEx("LoterGyakorlat", 1000, false, "dd", l, playerid);
				LoterInfo[l][lTalalt] = true;
			}
		}
		else
		{
			KillTimer(LoterInfo[l][lObjectTimer]);
			KillTimer(LoterInfo[l][lTimer]);
			SendClientMessage(playerid,COLOR_LIGHTRED,"[Lõtér] Mellé lõttél! [1 HIBAPONT]");
			format(szoveg,200,"A játékos(%d) mellé lõtt a lõtérben(%d)",playerid,l);
			LoterInfo[l][lTalalat] --;
			if(IsValidDynamicObject(LoterInfo[l][lObject])) DestroyDynamicObject(LoterInfo[l][lObject]), LoterInfo[l][lObject]=INVALID_OBJECT_ID;
			Streamer_Update(playerid);
			LoterInfo[l][lObjectTimer] = SetTimerEx("LoterGyakorlat", 1000, false, "dd", l, playerid);
			LoterInfo[l][lTalalt] = true;
		}
		LoterUzenet(szoveg);
	}
	return 1;
}

CMD:godmode(playerid, params[])
{
	if(IsScripter(playerid))
	{
		if(NoDamage[playerid])
			Msg(playerid, "Godmode deaktiválva"), NoDamage[playerid] = 0;
		else
			Msg(playerid, "Godmode aktiválva"), NoDamage[playerid] = -1;
	}
}

CMD:hpdebug(playerid, params[])
{
	if(IsScripter(playerid))
	{
		new Float:hp, Float:armour;
		if(sscanf(params, "ff", hp, armour))
			SendFormatMessage(playerid, COLOR_WHITE, "hp: %f, armour: %f", Health[playerid], Armour[playerid]);
		else
			Health[playerid] = hp, Armour[playerid] = armour;
	}
}
