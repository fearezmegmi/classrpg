/* ================ *\
    ClassRPG - NPC
\* ================ */

#include <a_npc>
#include <a_samp>

new bool:gStoppedForTraffic = false;
new bool:vege=true;
new bool:megy=true;
#define NINCS -1
#define MAX_NPC 4
new NPCkocsik[MAX_NPC];
new id;
new NPCelott=NINCS;
main(){}

#define NPC_AKCIO_START (1)
#define NPC_AKCIO_SZUNET (2)
#define NPC_AKCIO_FOLYTAT (3) 
#define NPC_AKCIO_STOP (4)
#define NPC_AKCIO_NEMMALLMEG (5)

#define AHEAD_OF_CAR_DISTANCE 	10.0

#define NUMBER_OF_SCANS			(5)
#define SCAN_RADIUS             (4.5)
#define SCAN_DISTANCE_DIFF		(3.0)

stock GetXYInfrontOfMe(Float:distance, &Float:x, &Float:y)
{
    new Float:z, Float:angle;
    GetMyPos(x,y,z);
    GetMyFacingAngle(angle);
    x += (distance * floatsin(-angle, degrees));
    y += (distance * floatcos(-angle, degrees));
}

public OnNPCModeInit()
{
	SetTimer("ScanTimer", 500, 1);
	SetTimer("Indit", 2000, 1);
}


stock LookForAReasonToPause()
{
  	new Float:X, Float:Y, Float:Z;

	GetMyPos(X,Y,Z);
	
	new Float:scans[NUMBER_OF_SCANS][2];
	for(new i = 0; i < NUMBER_OF_SCANS; i++)
	{
		GetXYInfrontOfMe(AHEAD_OF_CAR_DISTANCE + (i * SCAN_DISTANCE_DIFF), scans[i][0], scans[i][1]);
	}

	if(vege)
	{
		for(new x = 0; x < MAX_PLAYERS; x++)
		{
			if(IsPlayerConnected(x) && IsPlayerStreamedIn(x))
			{
				if(GetPlayerState(x) == PLAYER_STATE_DRIVER || GetPlayerState(x) == PLAYER_STATE_ONFOOT)
				{
					for(new i = 0; i < NUMBER_OF_SCANS; i++)
					{
						if(IsPlayerInRangeOfPoint(x, SCAN_RADIUS, scans[i][0], scans[i][1], Z))
						{
							NPCelott = x;
							return true;
						}
					}
				}
			} 
		}
	}
	return false;
}
forward Indit();
public Indit()
{
	if(NPCelott > NINCS)
	{
		new szoveg[30];
		format(szoveg, 30,"NPCPARANCSMEGALLT:%d", NPCelott);
		SendChat(szoveg);
		NPCelott = NINCS;
	}	

}
forward ScanTimer();
public ScanTimer()
{
	new ReasonToPause = LookForAReasonToPause();

	if(ReasonToPause && !gStoppedForTraffic)
	{
		if(megy)
		{
			PauseRecordingPlayback();
			megy=false;
			gStoppedForTraffic = true;
		}
	}
	else if(!ReasonToPause && gStoppedForTraffic)
	{
		if(!megy)
		{
			ResumeRecordingPlayback();
			megy=true;
			gStoppedForTraffic = false;
		}
	}
}

public OnNPCEnterVehicle(vehicleid, seatid)
{
	SendChat("kocsiba");
	new szoveg[64];
	
	NPCkocsik[id] = vehicleid;
	
	format(szoveg, 64,"NPC kocsik  ID: %d ", NPCkocsik[id]);
	id++;
	SendChat(szoveg);
	return 1;
}
public OnNPCExitVehicle()
{
	SendChat("Nem kocsiba!");
	StopRecordingPlayback();
	return 1;
}

public OnRecordingPlaybackEnd()
{
	vege=false;
	SendChat("vege");
	return 1;
}

public OnClientMessage(color, text[])
{
	if(strcmp("NPCPARANCS ", text, false, 11)) return 1;
	
	new akcio, felvetel[128];
	new darab[3][64];
	
	split(text, darab, ' ');
	if(!strlen(darab[1])) return 1;

	akcio = strval(darab[1]);
	felvetel = darab[2];
	
	if(strlen(felvetel))
		Akcio(akcio, felvetel);
	else
		Akcio(akcio);
	
	return 1;
}

stock Akcio(akcio, extra[] = "")
{
	switch(akcio)
	{
		case NPC_AKCIO_START: StartRecordingPlayback(1, extra), vege=true, megy=true;
		case NPC_AKCIO_SZUNET:if(megy) PauseRecordingPlayback(), megy=false;
		case NPC_AKCIO_FOLYTAT: if(!megy)ResumeRecordingPlayback(),gStoppedForTraffic = false, megy=true;
		case NPC_AKCIO_NEMMALLMEG: vege=false;
	}
	return 1;
}


split(const strsrc[], strdest[][], delimiter)
{
	new i, li,aNum,len;
	while(i <= strlen(strsrc))
	{
	    if(strsrc[i]==delimiter || i==strlen(strsrc))
		{
	        len = strmid(strdest[aNum], strsrc, li, i, 128);
	        strdest[aNum][len] = 0;
	        li = i+1;
	        aNum++;
		}
		i++;
	}
	return aNum;
}

stock strtok(const string[], &index)
{
	new length = strlen(string);
	while ((index < length) && (string[index] <= ' '))
	{
		index++;
	}

	new offset = index;
	new result[64];
	while ((index < length) && (string[index] > ' ') && ((index - offset) < (sizeof(result) - 1)))
	{
		result[index - offset] = string[index];
		index++;
	}
	result[index - offset] = EOS;
	return result;
}
