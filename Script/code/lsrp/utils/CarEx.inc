#if defined _CarEx_included
   #endinput
 #endif
#define _CarEx_included

#include <    a_samp    >

  #pragma tabsize 0 

/*
native EnableVehicleExplosion(); ~ Bekapcsolás
native DisableVehicleExplosion(); ~ Kikapcsolás
*/

#define MAX_CAR_HEALTH 250

new Float: V_Phealth;
new Float: p_X, Float:p_Y, Float:p_Z;

new EnableExplosion = 0;

forward CarRestart( vehicleid );
forward P_OnPlayerWeaponShot( playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ );

public OnPlayerWeaponShot( playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ )
    {
	 if( EnableExplosion == 1 )
	    {
            switch( hittype )
              {
               case BULLET_HIT_TYPE_VEHICLE:
                 {
                     GetVehicleHealth(hitid, V_Phealth);
                     for(new i = 0; i < MAX_PLAYERS; i++ )
                         {
                         if(V_Phealth >= 0 )
                            {
                                 if( weaponid == 22 ) SetVehicleHealth(hitid, V_Phealth -25);
                                 if( weaponid == 23 ) SetVehicleHealth(hitid, V_Phealth -40);
                                 if( weaponid == 24 ) SetVehicleHealth(hitid, V_Phealth -60);
                                 if( weaponid == 25 ) SetVehicleHealth(hitid, V_Phealth -60);
                                 if( weaponid == 26 ) SetVehicleHealth(hitid, V_Phealth -80);
                                 if( weaponid == 27 ) SetVehicleHealth(hitid, V_Phealth -60);
                                 if( weaponid == 28 ) SetVehicleHealth(hitid, V_Phealth -20);
                                 if( weaponid == 29 ) SetVehicleHealth(hitid, V_Phealth -25);
                                 if( weaponid == 30 ) SetVehicleHealth(hitid, V_Phealth -30);
                                 if( weaponid == 31 ) SetVehicleHealth(hitid, V_Phealth -35);
                                 if( weaponid == 32 ) SetVehicleHealth(hitid, V_Phealth -20);
                                 if( weaponid == 33 ) SetVehicleHealth(hitid, V_Phealth -75);
                                 if( weaponid == 34 ) SetVehicleHealth(hitid, V_Phealth -125);
                                 if( weaponid == 35 ) SetVehicleHealth(hitid, V_Phealth -1000);
                                 if( weaponid == 36 ) SetVehicleHealth(hitid, V_Phealth -1000);
                                 if( weaponid == 37 ) SetVehicleHealth(hitid, V_Phealth -200);
                                 if( weaponid == 38 ) SetVehicleHealth(hitid, V_Phealth -100);

			    if(V_Phealth == MAX_CAR_HEALTH)
                            {
                                GetVehiclePos(hitid, p_X, p_Y, p_Z );
                                CreateExplosion(p_X, p_Y, p_Y, 1, 5);
                                SetTimerEx("CarRestart", 10000, 0, "i", hitid);
                              }
                            }
        
			  }
		      } 
		    }
		 }
		           return CallLocalFunction("P_OnPlayerWeaponShot","iiiiiii",playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ);
              }
                      
public CarRestart( vehicleid )
	{
        SetVehicleToRespawn( vehicleid );
	  return 1;
   }

stock EnableVehicleExplosion()
  {
       EnableExplosion = 1;
	 return 1;
  }
  
stock DisableVehicleExplosion()
  {
       EnableExplosion = 0;
	 return 1;
  }
  
#if defined _NLS_OnPlayerWeaponShot
	#undef OnPlayerWeaponShot
  #else
	#define _NLS_OnPlayerWeaponShot
 #endif
#define OnPlayerWeaponShot P_OnPlayerWeaponShot
                      