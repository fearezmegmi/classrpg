// HOOK: SetVehiclePos
forward OnSetVehiclePos(vehicleid, Float:x, Float:y, Float:z);
fpublic Hook_SetVehiclePos(vehicleid, Float:x, Float:y, Float:z)
{
    SetVehiclePos(vehicleid, x, y, z);
    CallLocalFunction("OnSetVehiclePos", "dfff", vehicleid, x, y, z);
}

#if defined _ALS_SetVehiclePos
    #undef SetVehiclePos
#else
    #define _ALS_SetVehiclePos
#endif
#define SetVehiclePos Hook_SetVehiclePos

// HOOK: PutPlayerInVehicle
forward OnPutPlayerInVehicle(playerid, vehicleid, seatid);
fpublic Hook_PutPlayerInVehicle(playerid, vehicleid, seatid)
{
    PutPlayerInVehicle(playerid, vehicleid, seatid);
    CallLocalFunction("OnPutPlayerInVehicle", "ddd", playerid, vehicleid, seatid);
}

#if defined _ALS_PutPlayerInVehicle
    #undef PutPlayerInVehicle
#else
    #define _ALS_PutPlayerInVehicle
#endif
#define PutPlayerInVehicle Hook_PutPlayerInVehicle

// HOOK: EditDynamicObject
fpublic Hook_EditDynamicObject(playerid, objectid)
{
	CallLocalFunction("OnEditDynamicObject", "ddd", playerid, objectid);
    EditDynamicObject(playerid, objectid);
}

#if defined _ALS_EditDynamicObject
    #undef EditDynamicObject
#else
    #define _ALS_EditDynamicObject
#endif
#define EditDynamicObject Hook_EditDynamicObject