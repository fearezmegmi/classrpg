#include <a_samp>
#include <plugin/streamer>
#include <util/ccmd>
#include <plugin/sscanf2>
#include <a_http>

#define VERSION "0.1"

#define SMALL_QUAKE 500

#define fpublic%1(%2) forward %1(%2); public %1(%2)
#define egyezik(%1) (!strcmp(%1, true))

//new Actor = -1;
//new testresz = 9;

public OnFilterScriptInit()
{
	printf("Generate Offset by Krisztofer Vincenzo loaded. VER: %s", VERSION);
	return 1;
}

public OnFilterScriptExit()
{
	return 1;
}

/*public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
	if(hittype == BULLET_HIT_TYPE_PLAYER)
	{
		new hitstr[128];
		format(hitstr, sizeof(hitstr), "%f,%f,%f\n", fX, fY, fZ);
		LogHit(hitstr, GetPlayerSkin(hitid), testresz);
		return 0;
	}
	return 1;
}

fpublic LogHit(string[], skinid, part)
{
	new entry[256], fajl[64];

	format(fajl, sizeof(fajl), "data/hitbox/%d-%d.cfg", skinid, part);
	format(entry, sizeof(entry), "%s", string);

	new File:hFile;
	hFile = fopen(fajl, io_append);
	fwrite(hFile, entry);
	fclose(hFile);
	
	return 1;
}*/

forward MyHttpResponse(index, response_code, data[]);

public OnCommandPreProcess(playerid, cmdtext[])
{
	return 1;
}

public OnCommandProcess(playerid, cmdtext[], status, response)
{
	return 1;
}

CMD:hello(playerid, params[])
{
    HTTP(playerid, HTTP_GET, "ucp.classrpg.net/teszt.php?var=https://www.youtube.com/watch?v=uB_jz-xLwio", "", "MyHttpResponse");
    return 1;
}
 
public MyHttpResponse(index, response_code, data[])
{
    // In this callback "index" would normally be called "playerid" ( if you didn't get it already :) )
    new
        buffer[ 128 ];
    if(response_code == 200) //Did the request succeed?
    {
        //Yes!
        format(buffer, sizeof(buffer), "The URL replied: %s", data);
        SendClientMessage(index, 0xFFFFFFFF, buffer);
    }
    else
    {
        //No!
        format(buffer, sizeof(buffer), "The request failed! The response code was: %d", response_code);
        SendClientMessage(index, 0xFFFFFFFF, buffer);
    }
}

CMD:startearthquakerightnow(playerid, params[])
{
	new nev[MAX_PLAYER_NAME];
	GetPlayerName(playerid, nev, MAX_PLAYER_NAME);
	if(!egyezik(nev, "Krisztofer_Vincenzo")) return SendClientMessage(playerid, -1, "A-a");
	
 	new many, interval;
	if(sscanf(params, "dd", many, interval)) return SendClientMessage(playerid, -1, "many interval (-1 = mindenki)");
	
	if(interval == -1)
	{
		for(new i=0; i<MAX_PLAYERS; i++)
		{
			SetPlayerEarthquakeEffect(i, many);
		}
	}
	else
	{
		if(INVALID_PLAYER_ID == interval) return 1;
		
		SetPlayerEarthquakeEffect(interval, many);
	}
	new string[128];
	format(string, sizeof(string), "OMG EARTHQUAKE!!");
	SendClientMessage(playerid, -1, string);
	
	return 1;
}

new AmountOfShakes[ MAX_PLAYERS ];
forward SetPlayerEarthquakeEffect   ( playerid, amount_of_shakes );
forward EarthquakeEffects         ( playerid, interval, bool:status );
public SetPlayerEarthquakeEffect( playerid, amount_of_shakes ){
   if( amount_of_shakes < AmountOfShakes[ playerid ] )
      return 0;
   AmountOfShakes[ playerid ] = amount_of_shakes;
   new vehicleid = GetPlayerVehicleID( playerid );
   if( vehicleid ){
      if(amount_of_shakes <= SMALL_QUAKE+200 ){
         SetVehicleAngularVelocity( vehicleid, 0.09, 0.033, 0.05 );
      } else SetVehicleAngularVelocity( vehicleid, 0.03, 0.03, 0.03 );
   }
   return EarthquakeEffects( playerid, 10, false );
}
public EarthquakeEffects( playerid, interval, bool:status ){
   if( AmountOfShakes[ playerid ] <= 0 )
      return SetPlayerDrunkLevel( playerid, 0 );
   if( !(AmountOfShakes[ playerid ]%5) ){
      new vehicleid = GetPlayerVehicleID( playerid );
      if(AmountOfShakes[ playerid ] <= SMALL_QUAKE+200 ){
         SetVehicleAngularVelocity( vehicleid, 0.03, 0.03, 0.03 );
      } else SetVehicleAngularVelocity( vehicleid, 0.015, 0.015, 0.015 );
   }
   if( status ){
       SetPlayerDrunkLevel( playerid, 3000 );
   } else SetPlayerDrunkLevel( playerid, 50000 );
   AmountOfShakes[ playerid ]--;
   return SetTimerEx( "EarthquakeEffects", interval, false, "iii", playerid, interval, !status );
}

/*CMD:actor(playerid, params[])
{
	new skin = 285;
	if(sscanf(params, "d", skin)) return SendClientMessage(playerid, -1, "/actor [skin id]");
	
	if(!IsValidSkin(skin)) return SendClientMessage(playerid, "/actor [skin id]");
	
	new Float:Pos[3];
	GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);
	
	if(IsValidActor(Actor)) DestroyActor(Actor);
    Actor = CreateActor(skin, Pos[0]-5, Pos[1], Pos[2], 0.0);
	
	SendClientMessage(playerid, -1, "Actor Lerakva!");
	
	return 1;
}*/
