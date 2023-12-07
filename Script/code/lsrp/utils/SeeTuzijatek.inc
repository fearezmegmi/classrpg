/*
	SeeRPG TûzijátékInc By Lewis Rolee
*/
#if defined _SeeTuzijatek_included
	#endinput
#endif
#define _SeeTuzijatek_included
#pragma library SeeTuzijatek

#define MAX_TUZIJATEK 500

//------------------------------------------------------------------------------

enum TuziEnum
{
	Float:TuziMagassag,
	Float:TuziDir,
	TuziStatusz,
	TuziRobbanasTipus,
	TuziObject,
	Float:TuziRobbanasMeret,
	Float:TuziSebesseg,
	Float:TuziElforgasiSzog,
	bool:TuziHasznalatban
}

new Tuzijatek_Inc[MAX_TUZIJATEK][TuziEnum];

new SzinTipusok[] = {354, 3666};

SeeTuzi_ObjectPozValtozas(objectid)
{
	new id = GetTuzijatekID(objectid);
	if(id == -1) return 0;
	switch(Tuzijatek_Inc[id][TuziStatusz])
	{
	    case 1..4:
	    {
	        new Float:x, Float:y, Float:z;
	        GetObjectPos(objectid,x,y,z);
    		GetXYInFrontOfPosition(x,y,Tuzijatek_Inc[id][TuziDir],Tuzijatek_Inc[id][TuziElforgasiSzog] / 5);
			z += Tuzijatek_Inc[id][TuziMagassag] / 5;
    		Tuzijatek_Inc[id][TuziStatusz]++;
    		MoveDynamicObject(Tuzijatek_Inc[id][TuziObject],x,y,z,Tuzijatek_Inc[id][TuziSebesseg]);
	    }
	    default:
	    {
	        new Float:x, Float:y, Float:z;
	        GetObjectPos(objectid,x,y,z);
	        CreateExplosion(x,y,z,Tuzijatek_Inc[id][TuziRobbanasTipus],Tuzijatek_Inc[id][TuziRobbanasMeret]);
	        DestroySeeTuzijatek(id);
	    }
	}
	return 1;
}

CreateSeeTuzijatek(Float:x,Float:y,Float:z,Float:magassag,Float:dir,Float:szog,Float:sebesseg,robbanas,Float:robbanasmeret)
{
	new id = UresTuzijatekHely();
	if(id == -1) return 0;
	Tuzijatek_Inc[id][TuziObject] = CreateDynamicObject(SzinTipusok[random(sizeof(SzinTipusok))],x,y,z,0.0,0.0,0.0);
	Tuzijatek_Inc[id][TuziMagassag] = magassag;
	Tuzijatek_Inc[id][TuziDir] = dir;
	Tuzijatek_Inc[id][TuziRobbanasTipus] = robbanas;
	Tuzijatek_Inc[id][TuziSebesseg] = sebesseg;
	Tuzijatek_Inc[id][TuziElforgasiSzog] = szog;
	Tuzijatek_Inc[id][TuziRobbanasMeret] = robbanasmeret;
	Tuzijatek_Inc[id][TuziHasznalatban] = true;
    Tuzijatek_Inc[id][TuziStatusz] = 1;
    z += magassag / 5;
    GetXYInFrontOfPosition(x,y,dir,szog / 2);
    MoveDynamicObject(Tuzijatek_Inc[id][TuziObject],x,y,z,sebesseg);
    return 1;
}

stock UresTuzijatekHely()
{
	for(new i = 0; i < sizeof(Tuzijatek_Inc); i++)
	{
	    if(!Tuzijatek_Inc[i][TuziHasznalatban])
	    {
	        return i;
		}
	}
	return -1;
}

stock GetTuzijatekID(objectid)
{
	for(new i = 0; i < sizeof(Tuzijatek_Inc); i++)
	{
	    if(Tuzijatek_Inc[i][TuziObject] == objectid)
	    {
	        return i;
		}
	}
	return -1;
}

stock DestroySeeTuzijatek(id)
{
	DestroyDynamicObject(Tuzijatek_Inc[id][TuziObject]);
	Tuzijatek_Inc[id][TuziHasznalatban] = false;
}
	
stock GetXYInFrontOfPosition(&Float:x, &Float:y, Float:a, Float:distance)
{
	x += (distance * floatsin(-a, degrees));
	y += (distance * floatcos(-a, degrees));
}