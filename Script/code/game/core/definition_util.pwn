#if defined __game_core_definition_util
	#endinput
#endif
#define __game_core_definition_util

//#define fpublic%0%1(%2) forward %1(%2); public %1(%2)

/*=====================*
 *   V A R I A B L E   *
 *=====================*/
#define GunName(%1) aWeaponNames[%1]
#define Nev(%1) PlayerInfo[%1][pNev]
#define IP(%1) PlayerInfo[%1][pIP]
#define NPC(%1) NPC[%1]
#define PInfo(%1,%2) PlayerInfo[%1][p%2]
#define IsJim(%1) (PlayerInfo[%1][pClint])
#define Szint(%1) PlayerInfo[%1][pLevel] 
#define GetMoney(%1) PlayerInfo[%1][pCash]
#define SetMoney(%1,%2) PlayerInfo[%1][pCash] = %2
#define ResetMoney(%1) PlayerInfo[%1][pCash] = 0
#define GiveMoney(%1,%2) PlayerInfo[%1][pCash] += %2
#define SAdmin(%1,%2) (PlayerInfo[%1][pAdmin]>=%2)
#define IsAdmin(%1) (PlayerInfo[%1][pAdmin])
#define PlayerSQLID(%1) PlayerInfo[%1][pID]
#define SQLID(%1) PlayerInfo[%1][pID]
#define swap(%1,%2) _tmp=%1,%1=%2,%2=_tmp
#define Registered(%1) PlayerInfo[%1][pRegistered]

// Array
#define ArrSet(%0,%1,%2,%3) %0[0]=%1,%0[1]=%2,%0[2]=%3
#define ArrExt(%1) %1[0], %1[1], %1[2]
#define ArrExt2(%1) %1[0], %1[1]
#define ArrExt4(%1) %1[0], %1[1], %1[2], %1[3]
#define ArrExt6(%1) %1[0], %1[1], %1[2], %1[3], %1[4], %1[5]
#define StrToArr(%1,%2) %2[0] = floatstr(%1[0]), %2[1] = floatstr(%1[1]), %2[2] = floatstr(%1[2])
#define ArrCopy(%0,%1) %0[0]=%1[0],%0[1]=%1[1],%0[2]=%1[2]

/*===================*
 *   B O O L E A N   *
 *===================*/
#define egyezik(%1) (!strcmp(%1, true))
#define equals egyezik
#define PLAYER_MARKER_WEAPONS_WEAPONHOLD(%1)	(WeaponArmed(%1) == WEAPON_MP5 || WEAPON_SHOTGUN <= WeaponArmed(%1) <= WEAPON_SHOTGSPA || WEAPON_AK47 <= WeaponArmed(%1) <= WEAPON_M4 || WeaponArmed(%1) == WEAPON_SNIPER)
#define PLAYER_MARKER_WEAPONS_TARGET(%1)		(WeaponArmed(%1) == WEAPON_MP5 || WEAPON_SHOTGUN <= WeaponArmed(%1) <= WEAPON_SHOTGSPA || WEAPON_AK47 <= WeaponArmed(%1) <= WEAPON_M4 || WEAPON_RIFLE <= WeaponArmed(%1) <= WEAPON_SNIPER)
#define PLAYER_MARKER_WEAPONS_SHOOT(%1)			(WeaponArmed(%1) == WEAPON_COLT45 || WEAPON_DEAGLE <= WeaponArmed(%1) <= WEAPON_TEC9)
#define PLAYER_MARKER_WEAPONS_KILL(%1)			(WeaponArmed(%1) != WEAPON_SILENCED && WeaponArmed(%1) != WEAPON_SNIPER && WeaponArmed(%1) != WEAPON_RIFLE)
#define PLAYER_MARKER_IS_HIDDEN(%1)				(PlayerMarker[%1][mHidden] || ScripterDuty[%1] || AdminDuty[%1] || GetPlayerVirtualWorld(%1))
#define SemiValidVehicle(%1) (%1>=1&&%1<MAX_VEHICLES)
#define SemiValidPlayer(%1) (%1>=0&&%1<MAX_PLAYERS)
#define ValidPlayer(%1) (%1>=0&&%1<MAX_PLAYERS&&Connected[%1])
#define Szabadban(%1) (!GetPlayerVirtualWorld(%1) && !GetPlayerInterior(%1))
#define Varosban(%0,%1,%2) (CityArea[v%0][cPosX][0]<=%1<=CityArea[v%0][cPosX][1]&&CityArea[v%0][cPosY][0]<=%2<=CityArea[v%0][cPosY][1])
#define VarosbanVan(%1) (!GetPlayerVirtualWorld(%1)&&(Varosban(LS,PlayerPos[%1][0],PlayerPos[%1][1])||Varosban(SF,PlayerPos[%1][0],PlayerPos[%1][1])||Varosban(LV,PlayerPos[%1][0],PlayerPos[%1][1])))
#define LMT(%1,%2%3) %2(PlayerInfo[%1][pLeader] == (%3) || PlayerInfo[%1][pMember] == (%3))
#define AMT(%1,%2%3) %2(PlayerInfo[%1][pJob1] == (%3) || PlayerInfo[%1][pJob2] == (%3))
#define IsACop(%1) (LMT(%1, FRAKCIO_SCPD) || LMT(%1, FRAKCIO_FBI) || LMT(%1, FRAKCIO_NAV) || LMT(%1, FRAKCIO_KATONASAG) || PlayerInfo[%1][pSwattag] > 0 || LMT(%1, FRAKCIO_SFPD))
#define IsOnkentes(%1) (PlayerInfo[%1][pOnkentes] >= UnixTime)

/*=========================*
 *   S T A T E M E N T S   *
 *=========================*/
#define SendFormatMessage(%1,%2,%3,%4) format(_tmpString, 128, (%3), %4), SendClientMessage(%1, %2, _tmpString)
#define SendFormatMessageToAll(%1,%2,%3) format(_tmpString, 128, (%2), %3), SendClientMessageToAll(%1, _tmpString)
#define SendRadioMessageFormat(%1,%2,%3,%4) format(_tmpString, 128, %3, %4), SendMessage(SEND_MESSAGE_RADIO, _tmpString, %2, %1)
#define CopMsgFormat(%1,%2,%3) format(_tmpString, 128, (%2), %3), CopMsg(%1, _tmpString)
#define tformat(%1,%2,%3) format(_tmpString,%1,%2,%3)
#define ClearAnim(%1) ApplyAnimation(%1, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0)
#define BombAnim(%1) ApplyAnimation(%1, "BOMBER","BOM_Plant_Loop",4.0,1,0,0,1,0)
#define HideDialog(%1) ShowPlayerDialog(%1, -1, DIALOG_STYLE_MSGBOX, " ", " ", "", "")
#define WKick(%1) SetTimerEx("TKickEx", 0, false, "d", %1)
#define InvisibleColor(%1) SetPlayerColor(%1, COLOR_INVISIBLE)

#define TimeDiff(%1) (UnixTime - %1)

/*===============*
 *   O T H E R   *
 *===============*/
#define fpublic%1(%2) forward %1(%2); public %1(%2)
#define fstock%1(%2) forward %1(%2); stock %1(%2)
#define function
#define elseif else if
#define For(%1,%2,%3) for(new %1 = %2; %1 < %3; %1++)

//Dialog
#define CUSTOM_DIALOG_PARAMETERS	playerid, response, listitem, inputtext[]
#define Dialog:%1(%2)				fpublic dialog_%1(%2)
#define D:							#dialog_

#define S:%1(%2) S__%1(%2)
#define floatmin(%1,%2) (%1<%2?%1:%2)
#define floatmax(%1,%2) (%1>%2?%1:%2)
#define abs(%1) ((%1)<0?-%1:%1)
#define Math_MultiFactor(%1) (100.0 / (100.0 + (%1)))
#define Rand(%1,%2) (%1+random(%2-%1+1))
#define chrtolower(%1) (((%1) > 0x40 && (%1) <= 0x5A) ? ((%1) | 0x20) : (%1))
//#define GetDistanceBetweenPoints(%1,%2,%3,%4,%5,%6) VectorSize((%1)-(%4), (%2)-(%5), (%3)-(%6))

// SQL
#define sql_get_str(%1,%2) cache_get_value_index(0,%1,%2)
#define sql_get_str_len(%1,%2,%3) cache_get_value_index(0,%1,%2,%3)
#define sql_get_int(%1) (cache_get_value_index_int(0,%1,_tmp),_tmp)
#define sql_get_float(%1) (cache_get_value_float(0,%1,_tmpFloat),_tmpFloat)
#define sql_get_row_str(%1,%2,%3) cache_get_value_index(%1,%2,%3)
#define sql_get_row_str_len(%1,%2,%3,%4) cache_get_value_index(%1,%2,%3,%4)
#define sql_get_row_int(%1,%2) (cache_get_value_int(%1,%2,_tmp),_tmp)
#define sql_get_row_float(%1,%2) (cache_get_value_float(%1,%2,_tmpFloat),_tmpFloat)
#define sql_query(%1,%2,%3,%4) mysql_tquery(sql_ID,%1,%2,%3,%4)
//#define sql_data(%1,%2) cache_get_data(%1,%2)
#define sql_data(%1,%2) (sql_rows(%1),sql_columns(%2))
#define sql_rows(%1) cache_get_row_count(%1)
#define sql_columns(%1) cache_get_field_count(%1)
#define sql_affected() cache_affected_rows()
#define sql_insertid() cache_insert_id()

#define Format(%1,%2,%3) format(%1,sizeof(%1),(%2),%3)
#define FormatInline(%1,%2,%3) (format(%1,sizeof(%1),(%2),%3),%1)
#define TFormat(%2,%3) format(_tmpString,sizeof(_tmpString),(%2),%3) // T = Temp
#define TFormatInline(%2,%3) (format(_tmpString,sizeof(_tmpString),(%2),%3),_tmpString) // T = Temp
#define CopMsg(%1,%2) SendMessage(SEND_MESSAGE_COP,%2,%1)
#define ABroadCast(%1,%2,%3) SendMessage(SEND_MESSAGE_ADMIN,%2,%1,%3)
#define ABroadCastFormat(%1,%2,%3,%4) format(_tmpString,128,(%3),%4), SendMessage(SEND_MESSAGE_ADMIN,_tmpString,%1,%2)
#define GetGunFromString(%1) (isNumeric(%1) ? strval(%1) : GetGunID(%1))
#define FormatInt(%1)		FormatNumber((%1), 0, ',')

#define FormatFloat(%1,%2)	FormatNumber((%1), (%2), ',')
#define KocsiID(%1) GetPlayerVehicleID(%1)
#define IsFallingAnimation(%1) (%1 >= 958 && %1 <= 979 || %1 == 1130 || %1 == 1195 || %1 == 1132)