public UpdateIphone()
{
	new Hour, Minute;
	gettime(Hour, Minute);
	new str[64];
	format(str,sizeof(str),"4G________________%02d:%02d",Hour,Minute);
	TextDrawSetString(TD_iPhone[18], str);
	format(str,sizeof(str),"%02d:%02d",Hour,Minute);
	TextDrawSetString(TD_iPhone_Clock[0], str);
	TextDrawSetString(TD_iPhone[19], str);
	
	new Year, Month, Day;
	getdate(Year, Month, Day);
	format(str,sizeof(str),"%s, %02d %d",GetMonth(Month), Day, Year);
	TextDrawSetString(TD_iPhone[20], str);
	TextDrawSetString(TD_iPhone_Clock[1], str);
	ActualizarTiempo();
	return 1;
}

stock ActualizarTiempo()
{
 	new weather[64],idwea;
	GetServerVarAsString("weather", weather, sizeof(weather));
	idwea = strval(weather);
	if(idwea >= 0 && idwea <= 7) TextDrawSetString(TD_iPhone_Time[0],"Sunny");
	else if(idwea == 8) TextDrawSetString(TD_iPhone_Time[0],"Stormy");
	else if(idwea == 9) TextDrawSetString(TD_iPhone_Time[0],"Fog");
	else if(idwea == 10) TextDrawSetString(TD_iPhone_Time[0],"Sunny");
	else if(idwea == 11) TextDrawSetString(TD_iPhone_Time[0],"Hot");
	else if(idwea >= 12 && idwea <= 15) TextDrawSetString(TD_iPhone_Time[0],"Aburro");
	else if(idwea == 16) TextDrawSetString(TD_iPhone_Time[0],"Rain");
	else if(idwea >= 17 && idwea <= 18) TextDrawSetString(TD_iPhone_Time[0],"Hot");
	else if(idwea == 19) TextDrawSetString(TD_iPhone_Time[0],"Sand");
	else if(idwea == 20) TextDrawSetString(TD_iPhone_Time[0],"Fog");
	else if(idwea == 21) TextDrawSetString(TD_iPhone_Time[0],"Very dark");
	else if(idwea == 22) TextDrawSetString(TD_iPhone_Time[0],"Very dark");
	else if(idwea >= 23 && idwea <= 26) TextDrawSetString(TD_iPhone_Time[0],"Orange");
	else if(idwea >= 27 && idwea <= 29) TextDrawSetString(TD_iPhone_Time[0],"Sunny");
	else if(idwea >= 30 && idwea <= 32) TextDrawSetString(TD_iPhone_Time[0],"Dark");
	else if(idwea == 33) TextDrawSetString(TD_iPhone_Time[0],"Dark");
	else if(idwea == 34) TextDrawSetString(TD_iPhone_Time[0],"Blue");
	else if(idwea == 35) TextDrawSetString(TD_iPhone_Time[0],"Marron");
	else if(idwea >= 36 && idwea <= 38) TextDrawSetString(TD_iPhone_Time[0],"Brillant");
	else if(idwea == 39) TextDrawSetString(TD_iPhone_Time[0],"Very brillant");
	else if(idwea >= 40 && idwea <= 42) TextDrawSetString(TD_iPhone_Time[0],"Blue/Purple");
	else if(idwea == 43) TextDrawSetString(TD_iPhone_Time[0],"Toxic");
	else if(idwea == 44) TextDrawSetString(TD_iPhone_Time[0],"Black");
	else if(idwea == 45) TextDrawSetString(TD_iPhone_Time[0],"Black");
	return 1;
}

stock GetMonth(Month)
{
    new MonthStr[15];
    switch(Month)
    {
        case 1:  MonthStr = "January";
        case 2:  MonthStr = "February";
        case 3:  MonthStr = "March";
        case 4:  MonthStr = "April";
        case 5:  MonthStr = "May";
        case 6:  MonthStr = "June";
        case 7:  MonthStr = "July";
        case 8:  MonthStr = "Agoust";
        case 9:  MonthStr = "September";
        case 10: MonthStr = "October";
        case 11: MonthStr = "November";
        case 12: MonthStr = "Dicember";
    }
    return MonthStr;
}

stock ShowIphoneMenu(playerid, menuid)
{
	switch(menuid)
	{
	    case 1:
	    {
	        TextDrawShowForPlayer(playerid, TD_iPhone_Clock[0]);
	        TextDrawShowForPlayer(playerid, TD_iPhone_Clock[1]);
	    }
	    case 2:
	    {
	        iPhone_CC[3][playerid] = 1;
	        firstperson[playerid] = CreateObject(19300, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
	        AttachObjectToPlayer(firstperson[playerid],playerid, 0.0, 0.12, 0.7, 0.0, 0.0, 0.0);
	        AttachCameraToObject(playerid, firstperson[playerid]);
	    }
	    case 3:
	    {
	        iPhone_CC[0][playerid] = 1;
	        TextDrawShowForPlayer(playerid, TD_iPhone_Gallery);
			PlayerTextDrawShow(playerid, PTD_iPhone_Gallery[playerid]);
	    }
	    case 4:
	    {
	        TextDrawShowForPlayer(playerid, TD_iPhone_Time[0]);
	        TextDrawShowForPlayer(playerid, TD_iPhone_Time[1]);
	        TextDrawShowForPlayer(playerid, TD_iPhone_Time[2]);
	    }
	    case 5:
	    {
	        SelectTextDraw(playerid, -1);
	        PlayerTextDrawShow(playerid, PTD_iPhone_Calculator[playerid]);
	        loop(0, sizeof(TD_iPhone_Calculator), PHONE) TextDrawShowForPlayer(playerid, TD_iPhone_Calculator[PHONE]);
	    }
	    case 6:
	    {
	        GetPlayerZone(playerid);
	        TextDrawShowForPlayer(playerid, TD_iPhone_GPS);
	        PlayerTextDrawShow(playerid, PTD_iPhone_GPS[playerid]);
	    }
	    case 7:
	    {
	        iPhone_CC[1][playerid] = 1;
	        TextDrawShowForPlayer(playerid, TD_iPhone_Radio[0]);
	        TextDrawShowForPlayer(playerid, TD_iPhone_Radio[1]);
	    }
	    case 8:
	    {
	        iPhone_CC[2][playerid] = 1;
	        TextDrawShowForPlayer(playerid, TD_iPhone_Music[0]);
	        TextDrawShowForPlayer(playerid, TD_iPhone_Music[1]);
	    }
	    case 9: TextDrawShowForPlayer(playerid, TD_iPhone_Map);
	    case 10:
	    {
	        SelectTextDraw(playerid, -1);
	        loop(0, sizeof(TD_iPhone_Call), PHONE) TextDrawShowForPlayer(playerid, TD_iPhone_Call[PHONE]);
	        PlayerTextDrawShow(playerid, PTD_iPhone_Call[playerid]);
	    }
	    case 11:
	    {
	        TextDrawShowForPlayer(playerid, TD_iPhone_Internet[0]);
	        TextDrawShowForPlayer(playerid, TD_iPhone_Internet[1]);
	    }
	}
	return 1;
}

stock HideIphoneMenu(playerid)
{
	if(iPhoneCallStatus[playerid] == 1) return 1;
	else if(iPhoneCallStatus[playerid] == 2)
	{
	    iPhoneCallStatus[playerid] = 0;
	    iPhoneCallStatus[callto[playerid]] = 0;
	    iPhoneStatus[playerid] = 0;
        iPhoneStatus[callto[playerid]] = 0;
        
        loop(0, sizeof(TD_iPhone), PHONE) TextDrawHideForPlayer(playerid, TD_iPhone[PHONE]);
	    loop(0, sizeof(PTD_iPhone), PPHONE) PlayerTextDrawHide(playerid, PTD_iPhone[PPHONE][playerid]);
	    PlayerTextDrawHide(playerid, PTD_iPhone_Call[playerid]);
     	TextDrawHideForPlayer(playerid, TD_iPhone_CallYesNo[0]);
		TextDrawHideForPlayer(playerid, TD_iPhone_CallYesNo[1]);
		
		loop(0, sizeof(TD_iPhone), PHONE) TextDrawHideForPlayer(callto[playerid], TD_iPhone[PHONE]);
	    loop(0, sizeof(PTD_iPhone), PPHONE) PlayerTextDrawHide(callto[playerid], PTD_iPhone[PPHONE][callto[playerid]]);
	    PlayerTextDrawHide(callto[playerid], PTD_iPhone_Call[callto[playerid]]);
     	TextDrawHideForPlayer(callto[playerid], TD_iPhone_CallYesNo[0]);
		TextDrawHideForPlayer(callto[playerid], TD_iPhone_CallYesNo[1]);

		SendClientMessage(callto[playerid], -1, "Not answered...");
        callto[callto[playerid]] = 0;
	    callto[playerid] = 0;
	    return 1;
	}
	else if(iPhoneCallStatus[playerid] == 3)
	{
	    iPhoneCallStatus[playerid] = 0;
	    iPhoneCallStatus[callto[playerid]] = 0;
	    iPhoneStatus[playerid] = 0;
        iPhoneStatus[callto[playerid]] = 0;

        loop(0, sizeof(TD_iPhone), PHONE) TextDrawHideForPlayer(playerid, TD_iPhone[PHONE]);
	    loop(0, sizeof(PTD_iPhone), PPHONE) PlayerTextDrawHide(playerid, PTD_iPhone[PPHONE][playerid]);
	    PlayerTextDrawHide(playerid, PTD_iPhone_Call[playerid]);
     	TextDrawHideForPlayer(playerid, TD_iPhone_CallYesNo[0]);
		TextDrawHideForPlayer(playerid, TD_iPhone_CallYesNo[1]);

		loop(0, sizeof(TD_iPhone), PHONE) TextDrawHideForPlayer(callto[playerid], TD_iPhone[PHONE]);
	    loop(0, sizeof(PTD_iPhone), PPHONE) PlayerTextDrawHide(callto[playerid], PTD_iPhone[PPHONE][callto[playerid]]);
	    PlayerTextDrawHide(callto[playerid], PTD_iPhone_Call[callto[playerid]]);
     	TextDrawHideForPlayer(callto[playerid], TD_iPhone_CallYesNo[0]);
		TextDrawHideForPlayer(callto[playerid], TD_iPhone_CallYesNo[1]);

		SendClientMessage(callto[playerid], -1, "They have hung...");
        callto[callto[playerid]] = 0;
	    callto[playerid] = 0;
	    return 1;
	}
    CancelSelectTextDraw(playerid);
	TextDrawHideForPlayer(playerid, TD_iPhone_Clock[0]);
	TextDrawHideForPlayer(playerid, TD_iPhone_Clock[1]);
	TextDrawHideForPlayer(playerid, TD_iPhone_Gallery);
	PlayerTextDrawHide(playerid, PTD_iPhone_Gallery[playerid]);
	TextDrawHideForPlayer(playerid, TD_iPhone_Time[0]);
    TextDrawHideForPlayer(playerid, TD_iPhone_Time[1]);
    TextDrawHideForPlayer(playerid, TD_iPhone_Time[2]);
    TextDrawHideForPlayer(playerid, TD_iPhone_GPS);
    PlayerTextDrawHide(playerid, PTD_iPhone_GPS[playerid]);
    TextDrawHideForPlayer(playerid, TD_iPhone_Radio[0]);
	TextDrawHideForPlayer(playerid, TD_iPhone_Radio[1]);
	TextDrawHideForPlayer(playerid, TD_iPhone_Music[0]);
 	TextDrawHideForPlayer(playerid, TD_iPhone_Music[1]);
 	TextDrawHideForPlayer(playerid, TD_iPhone_Map);
 	TextDrawHideForPlayer(playerid, TD_iPhone_Internet[0]);
  	TextDrawHideForPlayer(playerid, TD_iPhone_Internet[1]);
  	PlayerTextDrawHide(playerid, PTD_iPhone_Calculator[playerid]);
   	loop(0, sizeof(TD_iPhone_Calculator), PHONE) TextDrawHideForPlayer(playerid, TD_iPhone_Calculator[PHONE]);
   	loop(0, sizeof(TD_iPhone_Call), PHONE) TextDrawHideForPlayer(playerid, TD_iPhone_Call[PHONE]);
    PlayerTextDrawHide(playerid, PTD_iPhone_Call[playerid]);
   	var1[playerid] = "";
    var2[playerid] = "";
    called[playerid] = "";
    TextDrawHideForPlayer(playerid, TD_iPhone_CallYesNo[0]);
	TextDrawHideForPlayer(playerid, TD_iPhone_CallYesNo[1]);
    PlayerTextDrawSetString(playerid, PTD_iPhone_Call[playerid], "");
    PlayerTextDrawSetString(playerid, PTD_iPhone_Calculator[playerid], "0");
    DeletePVar(playerid,"tovar");
	iPhone_CC[0][playerid] = 0;
	iPhone_CC[1][playerid] = 0;
	iPhone_CC[2][playerid] = 0;
	if(iPhone_CC[3][playerid] == 1)
	{
	    iPhone_CC[3][playerid] = 0;
		SetCameraBehindPlayer(playerid);
		DestroyObject(firstperson[playerid]);
	}
	return 1;
}

stock ReturnPlayerZone(playerid)
{
	new playerzone[256] = "Unknown";
	for(new j; j < sizeof(zones); j++) {
		if(IsPlayerInZone(playerid,j)) {
			memcpy(playerzone, zones[j][zone_name], 0, 108);
			break;
		}
	}
    return playerzone;
}
stock IsPlayerInZone(playerid, zoneid) {
	if(zoneid == -1) return false;
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);
	if(x >= zones[zoneid][zone_minx] && x < zones[zoneid][zone_maxx] && y >= zones[zoneid][zone_miny] && y < zones[zoneid][zone_maxy] && z >= zones[zoneid][zone_minz] && z < zones[zoneid][zone_maxz] && z < 900.0) return true;
	return false;
}
stock GetPlayerZone(playerid)
{
	new string[256];
    format(string,sizeof(string),"%s",ReturnPlayerZone(playerid));
    PlayerTextDrawSetString(playerid,PTD_iPhone_GPS[playerid],string);
	return 1;
}

stock UpdateCoordinates(playerid, aMenuX, aMenuY)
{
	switch(aMenuX)
	{
	    case 0:
	    {
	        switch(aMenuY)
	        {
	            case 0:
	            {
	                PlayerTextDrawSetString(playerid, PTD_iPhone[0][playerid], "Clock");
	                loop(1, 13, i)
					{
						PlayerTextDrawColor(playerid, PTD_iPhone[i][playerid], -256);
						PlayerTextDrawShow(playerid, PTD_iPhone[i][playerid]);
					}
	                PlayerTextDrawColor(playerid, PTD_iPhone[1][playerid], -1);
	                PlayerTextDrawShow(playerid, PTD_iPhone[1][playerid]);
					return 1;
	            }
	            case 1:
	            {
	                PlayerTextDrawSetString(playerid, PTD_iPhone[0][playerid], "Weather");
	                loop(1, 13, i)
					{
						PlayerTextDrawColor(playerid, PTD_iPhone[i][playerid], -256);
						PlayerTextDrawShow(playerid, PTD_iPhone[i][playerid]);
					}
	                PlayerTextDrawColor(playerid, PTD_iPhone[4][playerid], -1);
	                PlayerTextDrawShow(playerid, PTD_iPhone[4][playerid]);
					return 4;
	            }
	            case 2:
	            {
	                PlayerTextDrawSetString(playerid, PTD_iPhone[0][playerid], "Radio");
	                loop(1, 13, i)
					{
						PlayerTextDrawColor(playerid, PTD_iPhone[i][playerid], -256);
						PlayerTextDrawShow(playerid, PTD_iPhone[i][playerid]);
					}
	                PlayerTextDrawColor(playerid, PTD_iPhone[7][playerid], -1);
	                PlayerTextDrawShow(playerid, PTD_iPhone[7][playerid]);
					return 7;
	            }
	            case 3:
	            {
	                PlayerTextDrawSetString(playerid, PTD_iPhone[0][playerid], "Call");
	                loop(1, 13, i)
					{
						PlayerTextDrawColor(playerid, PTD_iPhone[i][playerid], -256);
						PlayerTextDrawShow(playerid, PTD_iPhone[i][playerid]);
					}
	                PlayerTextDrawColor(playerid, PTD_iPhone[10][playerid], -1);
	                PlayerTextDrawShow(playerid, PTD_iPhone[10][playerid]);
					return 10;
	            }
	        }
	    }
	    case 1:
	    {
	        switch(aMenuY)
	        {
	            case 0:
	            {
	                PlayerTextDrawSetString(playerid, PTD_iPhone[0][playerid], "Camera");
	                loop(1, 13, i)
					{
						PlayerTextDrawColor(playerid, PTD_iPhone[i][playerid], -256);
						PlayerTextDrawShow(playerid, PTD_iPhone[i][playerid]);
					}
	                PlayerTextDrawColor(playerid, PTD_iPhone[2][playerid], -1);
	                PlayerTextDrawShow(playerid, PTD_iPhone[2][playerid]);
					return 2;
	            }
	            case 1:
	            {
	                PlayerTextDrawSetString(playerid, PTD_iPhone[0][playerid], "Calculator");
	                loop(1, 13, i)
					{
						PlayerTextDrawColor(playerid, PTD_iPhone[i][playerid], -256);
						PlayerTextDrawShow(playerid, PTD_iPhone[i][playerid]);
					}
	                PlayerTextDrawColor(playerid, PTD_iPhone[5][playerid], -1);
	                PlayerTextDrawShow(playerid, PTD_iPhone[5][playerid]);
					return 5;
	            }
	            case 2:
	            {
	                PlayerTextDrawSetString(playerid, PTD_iPhone[0][playerid], "Music");
	                loop(1, 13, i)
					{
						PlayerTextDrawColor(playerid, PTD_iPhone[i][playerid], -256);
						PlayerTextDrawShow(playerid, PTD_iPhone[i][playerid]);
					}
	                PlayerTextDrawColor(playerid, PTD_iPhone[8][playerid], -1);
	                PlayerTextDrawShow(playerid, PTD_iPhone[8][playerid]);
					return 8;
	            }
	            case 3:
	            {
	                PlayerTextDrawSetString(playerid, PTD_iPhone[0][playerid], "Internet");
	                loop(1, 13, i)
					{
						PlayerTextDrawColor(playerid, PTD_iPhone[i][playerid], -256);
						PlayerTextDrawShow(playerid, PTD_iPhone[i][playerid]);
					}
	                PlayerTextDrawColor(playerid, PTD_iPhone[11][playerid], -1);
	                PlayerTextDrawShow(playerid, PTD_iPhone[11][playerid]);
					return 11;
	            }
	        }
	    }
	    case 2:
	    {
	        switch(aMenuY)
	        {
	            case 0:
	            {
	                PlayerTextDrawSetString(playerid, PTD_iPhone[0][playerid], "Gallery");
	                loop(1, 13, i)
					{
						PlayerTextDrawColor(playerid, PTD_iPhone[i][playerid], -256);
						PlayerTextDrawShow(playerid, PTD_iPhone[i][playerid]);
					}
	                PlayerTextDrawColor(playerid, PTD_iPhone[3][playerid], -1);
	                PlayerTextDrawShow(playerid, PTD_iPhone[3][playerid]);
					return 3;
	            }
	            case 1:
	            {
	                PlayerTextDrawSetString(playerid, PTD_iPhone[0][playerid], "GPS");
	                loop(1, 13, i)
					{
						PlayerTextDrawColor(playerid, PTD_iPhone[i][playerid], -256);
						PlayerTextDrawShow(playerid, PTD_iPhone[i][playerid]);
					}
	                PlayerTextDrawColor(playerid, PTD_iPhone[6][playerid], -1);
	                PlayerTextDrawShow(playerid, PTD_iPhone[6][playerid]);
					return 6;
	            }
	            case 2:
	            {
	                PlayerTextDrawSetString(playerid, PTD_iPhone[0][playerid], "Map");
	                loop(1, 13, i)
					{
						PlayerTextDrawColor(playerid, PTD_iPhone[i][playerid], -256);
						PlayerTextDrawShow(playerid, PTD_iPhone[i][playerid]);
					}
	                PlayerTextDrawColor(playerid, PTD_iPhone[9][playerid], -1);
	                PlayerTextDrawShow(playerid, PTD_iPhone[9][playerid]);
					return 9;
	            }
	            case 3:
	            {
	                PlayerTextDrawSetString(playerid, PTD_iPhone[0][playerid], "SMS");
	                loop(1, 13, i)
					{
						PlayerTextDrawColor(playerid, PTD_iPhone[i][playerid], -256);
						PlayerTextDrawShow(playerid, PTD_iPhone[i][playerid]);
					}
	                PlayerTextDrawColor(playerid, PTD_iPhone[12][playerid], -1);
	                PlayerTextDrawShow(playerid, PTD_iPhone[12][playerid]);
					return 12;
	            }
	        }
	    }
	}
	return 0;
}

stock CreatePlayerIphone(playerid)
{
	PTD_iPhone[0][playerid] = CreatePlayerTextDraw(playerid, 550.133544, 233.225967, "Not selected");
	PlayerTextDrawLetterSize(playerid, PTD_iPhone[0][playerid], 0.276333, 1.346963);
	PlayerTextDrawAlignment(playerid, PTD_iPhone[0][playerid], 2);
	PlayerTextDrawColor(playerid, PTD_iPhone[0][playerid], -1);
	PlayerTextDrawSetShadow(playerid, PTD_iPhone[0][playerid], 0);
	PlayerTextDrawSetOutline(playerid, PTD_iPhone[0][playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, PTD_iPhone[0][playerid], 255);
	PlayerTextDrawFont(playerid, PTD_iPhone[0][playerid], 1);
	PlayerTextDrawSetProportional(playerid, PTD_iPhone[0][playerid], 1);

	PTD_iPhone[1][playerid] = CreatePlayerTextDraw(playerid, 516.600280, 254.681549, "ld_poke:cd1d");
	PlayerTextDrawLetterSize(playerid, PTD_iPhone[1][playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, PTD_iPhone[1][playerid], 19.000009, 23.644432);
	PlayerTextDrawAlignment(playerid, PTD_iPhone[1][playerid], 1);
	PlayerTextDrawColor(playerid, PTD_iPhone[1][playerid], -256);
	PlayerTextDrawSetShadow(playerid, PTD_iPhone[1][playerid], 0);
	PlayerTextDrawSetOutline(playerid, PTD_iPhone[1][playerid], 0);
	PlayerTextDrawFont(playerid, PTD_iPhone[1][playerid], 4);

	PTD_iPhone[2][playerid] = CreatePlayerTextDraw(playerid, 540.866333, 254.681549, "ld_poke:cd1d");
	PlayerTextDrawLetterSize(playerid, PTD_iPhone[2][playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, PTD_iPhone[2][playerid], 19.000009, 23.644432);
	PlayerTextDrawAlignment(playerid, PTD_iPhone[2][playerid], 1);
	PlayerTextDrawColor(playerid, PTD_iPhone[2][playerid], -256);
	PlayerTextDrawSetShadow(playerid, PTD_iPhone[2][playerid], 0);
	PlayerTextDrawSetOutline(playerid, PTD_iPhone[2][playerid], 0);
	PlayerTextDrawFont(playerid, PTD_iPhone[2][playerid], 4);

	PTD_iPhone[3][playerid] = CreatePlayerTextDraw(playerid, 565.599304, 254.681549, "ld_poke:cd1d");
	PlayerTextDrawLetterSize(playerid, PTD_iPhone[3][playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, PTD_iPhone[3][playerid], 19.000009, 23.644432);
	PlayerTextDrawAlignment(playerid, PTD_iPhone[3][playerid], 1);
	PlayerTextDrawColor(playerid, PTD_iPhone[3][playerid], -256);
	PlayerTextDrawSetShadow(playerid, PTD_iPhone[3][playerid], 0);
	PlayerTextDrawSetOutline(playerid, PTD_iPhone[3][playerid], 0);
	PlayerTextDrawFont(playerid, PTD_iPhone[3][playerid], 4);

	PTD_iPhone[4][playerid] = CreatePlayerTextDraw(playerid, 516.600280, 284.445159, "ld_poke:cd1d");
	PlayerTextDrawLetterSize(playerid, PTD_iPhone[4][playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, PTD_iPhone[4][playerid], 19.000009, 23.644432);
	PlayerTextDrawAlignment(playerid, PTD_iPhone[4][playerid], 1);
	PlayerTextDrawColor(playerid, PTD_iPhone[4][playerid], -256);
	PlayerTextDrawSetShadow(playerid, PTD_iPhone[4][playerid], 0);
	PlayerTextDrawSetOutline(playerid, PTD_iPhone[4][playerid], 0);
	PlayerTextDrawFont(playerid, PTD_iPhone[4][playerid], 4);

	PTD_iPhone[5][playerid] = CreatePlayerTextDraw(playerid, 540.866333, 284.445159, "ld_poke:cd1d");
	PlayerTextDrawLetterSize(playerid, PTD_iPhone[5][playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, PTD_iPhone[5][playerid], 19.000009, 23.644432);
	PlayerTextDrawAlignment(playerid, PTD_iPhone[5][playerid], 1);
	PlayerTextDrawColor(playerid, PTD_iPhone[5][playerid], -1);
	PlayerTextDrawSetShadow(playerid, PTD_iPhone[5][playerid], 0);
	PlayerTextDrawSetOutline(playerid, PTD_iPhone[5][playerid], 0);
	PlayerTextDrawFont(playerid, PTD_iPhone[5][playerid], 4);

	PTD_iPhone[6][playerid] = CreatePlayerTextDraw(playerid, 565.599304, 284.445159, "ld_poke:cd1d");
	PlayerTextDrawLetterSize(playerid, PTD_iPhone[6][playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, PTD_iPhone[6][playerid], 19.000009, 23.644432);
	PlayerTextDrawAlignment(playerid, PTD_iPhone[6][playerid], 1);
	PlayerTextDrawColor(playerid, PTD_iPhone[6][playerid], -256);
	PlayerTextDrawSetShadow(playerid, PTD_iPhone[6][playerid], 0);
	PlayerTextDrawSetOutline(playerid, PTD_iPhone[6][playerid], 0);
	PlayerTextDrawFont(playerid, PTD_iPhone[6][playerid], 4);

	PTD_iPhone[7][playerid] = CreatePlayerTextDraw(playerid, 516.600280, 314.208770, "ld_poke:cd1d");
	PlayerTextDrawLetterSize(playerid, PTD_iPhone[7][playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, PTD_iPhone[7][playerid], 19.000009, 23.644432);
	PlayerTextDrawAlignment(playerid, PTD_iPhone[7][playerid], 1);
	PlayerTextDrawColor(playerid, PTD_iPhone[7][playerid], -256);
	PlayerTextDrawSetShadow(playerid, PTD_iPhone[7][playerid], 0);
	PlayerTextDrawSetOutline(playerid, PTD_iPhone[7][playerid], 0);
	PlayerTextDrawFont(playerid, PTD_iPhone[7][playerid], 4);

	PTD_iPhone[8][playerid] = CreatePlayerTextDraw(playerid, 540.866333, 314.208770, "ld_poke:cd1d");
	PlayerTextDrawLetterSize(playerid, PTD_iPhone[8][playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, PTD_iPhone[8][playerid], 19.000009, 23.644432);
	PlayerTextDrawAlignment(playerid, PTD_iPhone[8][playerid], 1);
	PlayerTextDrawColor(playerid, PTD_iPhone[8][playerid], -256);
	PlayerTextDrawSetShadow(playerid, PTD_iPhone[8][playerid], 0);
	PlayerTextDrawSetOutline(playerid, PTD_iPhone[8][playerid], 0);
	PlayerTextDrawFont(playerid, PTD_iPhone[8][playerid], 4);

	PTD_iPhone[9][playerid] = CreatePlayerTextDraw(playerid, 565.599304, 314.208770, "ld_poke:cd1d");
	PlayerTextDrawLetterSize(playerid, PTD_iPhone[9][playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, PTD_iPhone[9][playerid], 19.000009, 23.644432);
	PlayerTextDrawAlignment(playerid, PTD_iPhone[9][playerid], 1);
	PlayerTextDrawColor(playerid, PTD_iPhone[9][playerid], -256);
	PlayerTextDrawSetShadow(playerid, PTD_iPhone[9][playerid], 0);
	PlayerTextDrawSetOutline(playerid, PTD_iPhone[9][playerid], 0);
	PlayerTextDrawFont(playerid, PTD_iPhone[9][playerid], 4);

	PTD_iPhone[10][playerid] = CreatePlayerTextDraw(playerid, 516.600280, 348.338378, "ld_poke:cd1d");
	PlayerTextDrawLetterSize(playerid, PTD_iPhone[10][playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, PTD_iPhone[10][playerid], 19.000009, 23.644432);
	PlayerTextDrawAlignment(playerid, PTD_iPhone[10][playerid], 1);
	PlayerTextDrawColor(playerid, PTD_iPhone[10][playerid], -256);
	PlayerTextDrawSetShadow(playerid, PTD_iPhone[10][playerid], 0);
	PlayerTextDrawSetOutline(playerid, PTD_iPhone[10][playerid], 0);
	PlayerTextDrawFont(playerid, PTD_iPhone[10][playerid], 4);

	PTD_iPhone[11][playerid] = CreatePlayerTextDraw(playerid, 540.866333, 348.338378, "ld_poke:cd1d");
	PlayerTextDrawLetterSize(playerid, PTD_iPhone[11][playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, PTD_iPhone[11][playerid], 19.000009, 23.644432);
	PlayerTextDrawAlignment(playerid, PTD_iPhone[11][playerid], 1);
	PlayerTextDrawColor(playerid, PTD_iPhone[11][playerid], -256);
	PlayerTextDrawSetShadow(playerid, PTD_iPhone[11][playerid], 0);
	PlayerTextDrawSetOutline(playerid, PTD_iPhone[11][playerid], 0);
	PlayerTextDrawFont(playerid, PTD_iPhone[11][playerid], 4);

	PTD_iPhone[12][playerid] = CreatePlayerTextDraw(playerid, 565.599304, 348.338378, "ld_poke:cd1d");
	PlayerTextDrawLetterSize(playerid, PTD_iPhone[12][playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, PTD_iPhone[12][playerid], 19.000009, 23.644432);
	PlayerTextDrawAlignment(playerid, PTD_iPhone[12][playerid], 1);
	PlayerTextDrawColor(playerid, PTD_iPhone[12][playerid], -256);
	PlayerTextDrawSetShadow(playerid, PTD_iPhone[12][playerid], 0);
	PlayerTextDrawSetOutline(playerid, PTD_iPhone[12][playerid], 0);
	PlayerTextDrawFont(playerid, PTD_iPhone[12][playerid], 4);
	
	PTD_iPhone[13][playerid] = CreatePlayerTextDraw(playerid, 517.000122, 255.526031, "ld_poke:cd1d");
	PlayerTextDrawLetterSize(playerid, PTD_iPhone[13][playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, PTD_iPhone[13][playerid], 18.333343, 22.399990);
	PlayerTextDrawAlignment(playerid, PTD_iPhone[13][playerid], 1);
	PlayerTextDrawColor(playerid, PTD_iPhone[13][playerid], 255);
	PlayerTextDrawSetShadow(playerid, PTD_iPhone[13][playerid], 0);
	PlayerTextDrawSetOutline(playerid, PTD_iPhone[13][playerid], 0);
	PlayerTextDrawFont(playerid, PTD_iPhone[13][playerid], 4);

	PTD_iPhone[14][playerid] = CreatePlayerTextDraw(playerid, 541.266174, 255.526031, "ld_poke:cd1d");
	PlayerTextDrawLetterSize(playerid, PTD_iPhone[14][playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, PTD_iPhone[14][playerid], 18.333343, 22.399990);
	PlayerTextDrawAlignment(playerid, PTD_iPhone[14][playerid], 1);
	PlayerTextDrawColor(playerid, PTD_iPhone[14][playerid], 255);
	PlayerTextDrawSetShadow(playerid, PTD_iPhone[14][playerid], 0);
	PlayerTextDrawSetOutline(playerid, PTD_iPhone[14][playerid], 0);
	PlayerTextDrawFont(playerid, PTD_iPhone[14][playerid], 4);

	PTD_iPhone[15][playerid] = CreatePlayerTextDraw(playerid, 565.999145, 255.526031, "ld_poke:cd1d");
	PlayerTextDrawLetterSize(playerid, PTD_iPhone[15][playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, PTD_iPhone[15][playerid], 18.333343, 22.399990);
	PlayerTextDrawAlignment(playerid, PTD_iPhone[15][playerid], 1);
	PlayerTextDrawColor(playerid, PTD_iPhone[15][playerid], 255);
	PlayerTextDrawSetShadow(playerid, PTD_iPhone[15][playerid], 0);
	PlayerTextDrawSetOutline(playerid, PTD_iPhone[15][playerid], 0);
	PlayerTextDrawFont(playerid, PTD_iPhone[15][playerid], 4);

	PTD_iPhone[16][playerid] = CreatePlayerTextDraw(playerid, 517.000122, 285.289642, "ld_poke:cd1d");
	PlayerTextDrawLetterSize(playerid, PTD_iPhone[16][playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, PTD_iPhone[16][playerid], 18.333343, 22.399990);
	PlayerTextDrawAlignment(playerid, PTD_iPhone[16][playerid], 1);
	PlayerTextDrawColor(playerid, PTD_iPhone[16][playerid], 255);
	PlayerTextDrawSetShadow(playerid, PTD_iPhone[16][playerid], 0);
	PlayerTextDrawSetOutline(playerid, PTD_iPhone[16][playerid], 0);
	PlayerTextDrawFont(playerid, PTD_iPhone[16][playerid], 4);

	PTD_iPhone[17][playerid] = CreatePlayerTextDraw(playerid, 541.266174, 285.289642, "ld_poke:cd1d");
	PlayerTextDrawLetterSize(playerid, PTD_iPhone[17][playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, PTD_iPhone[17][playerid], 18.333343, 22.399990);
	PlayerTextDrawAlignment(playerid, PTD_iPhone[17][playerid], 1);
	PlayerTextDrawColor(playerid, PTD_iPhone[17][playerid], 255);
	PlayerTextDrawSetShadow(playerid, PTD_iPhone[17][playerid], 0);
	PlayerTextDrawSetOutline(playerid, PTD_iPhone[17][playerid], 0);
	PlayerTextDrawFont(playerid, PTD_iPhone[17][playerid], 4);

	PTD_iPhone[18][playerid] = CreatePlayerTextDraw(playerid, 565.999145, 285.289642, "ld_poke:cd1d");
	PlayerTextDrawLetterSize(playerid, PTD_iPhone[18][playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, PTD_iPhone[18][playerid], 18.333343, 22.399990);
	PlayerTextDrawAlignment(playerid, PTD_iPhone[18][playerid], 1);
	PlayerTextDrawColor(playerid, PTD_iPhone[18][playerid], 255);
	PlayerTextDrawSetShadow(playerid, PTD_iPhone[18][playerid], 0);
	PlayerTextDrawSetOutline(playerid, PTD_iPhone[18][playerid], 0);
	PlayerTextDrawFont(playerid, PTD_iPhone[18][playerid], 4);

	PTD_iPhone[19][playerid] = CreatePlayerTextDraw(playerid, 517.000122, 315.053253, "ld_poke:cd1d");
	PlayerTextDrawLetterSize(playerid, PTD_iPhone[19][playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, PTD_iPhone[19][playerid], 18.333343, 22.399990);
	PlayerTextDrawAlignment(playerid, PTD_iPhone[19][playerid], 1);
	PlayerTextDrawColor(playerid, PTD_iPhone[19][playerid], 255);
	PlayerTextDrawSetShadow(playerid, PTD_iPhone[19][playerid], 0);
	PlayerTextDrawSetOutline(playerid, PTD_iPhone[19][playerid], 0);
	PlayerTextDrawFont(playerid, PTD_iPhone[19][playerid], 4);

	PTD_iPhone[20][playerid] = CreatePlayerTextDraw(playerid, 541.266174, 315.053253, "ld_poke:cd1d");
	PlayerTextDrawLetterSize(playerid, PTD_iPhone[20][playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, PTD_iPhone[20][playerid], 18.333343, 22.399990);
	PlayerTextDrawAlignment(playerid, PTD_iPhone[20][playerid], 1);
	PlayerTextDrawColor(playerid, PTD_iPhone[20][playerid], 255);
	PlayerTextDrawSetShadow(playerid, PTD_iPhone[20][playerid], 0);
	PlayerTextDrawSetOutline(playerid, PTD_iPhone[20][playerid], 0);
	PlayerTextDrawFont(playerid, PTD_iPhone[20][playerid], 4);

	PTD_iPhone[21][playerid] = CreatePlayerTextDraw(playerid, 565.999145, 315.053253, "ld_poke:cd1d");
	PlayerTextDrawLetterSize(playerid, PTD_iPhone[21][playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, PTD_iPhone[21][playerid], 18.333343, 22.399990);
	PlayerTextDrawAlignment(playerid, PTD_iPhone[21][playerid], 1);
	PlayerTextDrawColor(playerid, PTD_iPhone[21][playerid], 255);
	PlayerTextDrawSetShadow(playerid, PTD_iPhone[21][playerid], 0);
	PlayerTextDrawSetOutline(playerid, PTD_iPhone[21][playerid], 0);
	PlayerTextDrawFont(playerid, PTD_iPhone[21][playerid], 4);

	PTD_iPhone[22][playerid] = CreatePlayerTextDraw(playerid, 517.000122, 349.182861, "ld_poke:cd1d");
	PlayerTextDrawLetterSize(playerid, PTD_iPhone[22][playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, PTD_iPhone[22][playerid], 18.333343, 22.399990);
	PlayerTextDrawAlignment(playerid, PTD_iPhone[22][playerid], 1);
	PlayerTextDrawColor(playerid, PTD_iPhone[22][playerid], 255);
	PlayerTextDrawSetShadow(playerid, PTD_iPhone[22][playerid], 0);
	PlayerTextDrawSetOutline(playerid, PTD_iPhone[22][playerid], 0);
	PlayerTextDrawFont(playerid, PTD_iPhone[22][playerid], 4);

	PTD_iPhone[23][playerid] = CreatePlayerTextDraw(playerid, 541.266174, 349.182861, "ld_poke:cd1d");
	PlayerTextDrawLetterSize(playerid, PTD_iPhone[23][playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, PTD_iPhone[23][playerid], 18.333343, 22.399990);
	PlayerTextDrawAlignment(playerid, PTD_iPhone[23][playerid], 1);
	PlayerTextDrawColor(playerid, PTD_iPhone[23][playerid], 255);
	PlayerTextDrawSetShadow(playerid, PTD_iPhone[23][playerid], 0);
	PlayerTextDrawSetOutline(playerid, PTD_iPhone[23][playerid], 0);
	PlayerTextDrawFont(playerid, PTD_iPhone[23][playerid], 4);

	PTD_iPhone[24][playerid] = CreatePlayerTextDraw(playerid, 565.999145, 349.182861, "ld_poke:cd1d");
	PlayerTextDrawLetterSize(playerid, PTD_iPhone[24][playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, PTD_iPhone[24][playerid], 18.333343, 22.399990);
	PlayerTextDrawAlignment(playerid, PTD_iPhone[24][playerid], 1);
	PlayerTextDrawColor(playerid, PTD_iPhone[24][playerid], 255);
	PlayerTextDrawSetShadow(playerid, PTD_iPhone[24][playerid], 0);
	PlayerTextDrawSetOutline(playerid, PTD_iPhone[24][playerid], 0);
	PlayerTextDrawFont(playerid, PTD_iPhone[24][playerid], 4);
	
	PTD_iPhone[25][playerid] = CreatePlayerTextDraw(playerid, 518.700134, 257.085144, "ld_grav:timer");
	PlayerTextDrawLetterSize(playerid, PTD_iPhone[25][playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, PTD_iPhone[25][playerid], 14.999999, 17.422224);
	PlayerTextDrawAlignment(playerid, PTD_iPhone[25][playerid], 1);
	PlayerTextDrawColor(playerid, PTD_iPhone[25][playerid], -1);
	PlayerTextDrawSetShadow(playerid, PTD_iPhone[25][playerid], 0);
	PlayerTextDrawSetOutline(playerid, PTD_iPhone[25][playerid], 0);
	PlayerTextDrawFont(playerid, PTD_iPhone[25][playerid], 4);

	PTD_iPhone[26][playerid] = CreatePlayerTextDraw(playerid, 543.000000, 258.140777, "hud:radar_gym");
	PlayerTextDrawLetterSize(playerid, PTD_iPhone[26][playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, PTD_iPhone[26][playerid], 14.999999, 17.422224);
	PlayerTextDrawAlignment(playerid, PTD_iPhone[26][playerid], 1);
	PlayerTextDrawColor(playerid, PTD_iPhone[26][playerid], -1);
	PlayerTextDrawSetShadow(playerid, PTD_iPhone[26][playerid], 0);
	PlayerTextDrawSetOutline(playerid, PTD_iPhone[26][playerid], 0);
	PlayerTextDrawFont(playerid, PTD_iPhone[26][playerid], 4);

	PTD_iPhone[27][playerid] = CreatePlayerTextDraw(playerid, 567.699951, 257.611114, "hud:radar_enemyattack");
	PlayerTextDrawLetterSize(playerid, PTD_iPhone[27][playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, PTD_iPhone[27][playerid], 14.999999, 17.422224);
	PlayerTextDrawAlignment(playerid, PTD_iPhone[27][playerid], 1);
	PlayerTextDrawColor(playerid, PTD_iPhone[27][playerid], -1);
	PlayerTextDrawSetShadow(playerid, PTD_iPhone[27][playerid], 0);
	PlayerTextDrawSetOutline(playerid, PTD_iPhone[27][playerid], 0);
	PlayerTextDrawFont(playerid, PTD_iPhone[27][playerid], 4);

	PTD_iPhone[28][playerid] = CreatePlayerTextDraw(playerid, 518.500183, 287.118560, "hud:radar_fire");
	PlayerTextDrawLetterSize(playerid, PTD_iPhone[28][playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, PTD_iPhone[28][playerid], 14.999999, 17.422224);
	PlayerTextDrawAlignment(playerid, PTD_iPhone[28][playerid], 1);
	PlayerTextDrawColor(playerid, PTD_iPhone[28][playerid], -1);
	PlayerTextDrawSetShadow(playerid, PTD_iPhone[28][playerid], 0);
	PlayerTextDrawSetOutline(playerid, PTD_iPhone[28][playerid], 0);
	PlayerTextDrawFont(playerid, PTD_iPhone[28][playerid], 4);

	PTD_iPhone[29][playerid] = CreatePlayerTextDraw(playerid, 542.966796, 287.288879, "hud:radar_modgarage");
	PlayerTextDrawLetterSize(playerid, PTD_iPhone[29][playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, PTD_iPhone[29][playerid], 14.999999, 17.422224);
	PlayerTextDrawAlignment(playerid, PTD_iPhone[29][playerid], 1);
	PlayerTextDrawColor(playerid, PTD_iPhone[29][playerid], -1);
	PlayerTextDrawSetShadow(playerid, PTD_iPhone[29][playerid], 0);
	PlayerTextDrawSetOutline(playerid, PTD_iPhone[29][playerid], 0);
	PlayerTextDrawFont(playerid, PTD_iPhone[29][playerid], 4);

	PTD_iPhone[30][playerid] = CreatePlayerTextDraw(playerid, 567.633361, 287.359222, "hud:arrow");
	PlayerTextDrawLetterSize(playerid, PTD_iPhone[30][playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, PTD_iPhone[30][playerid], 14.999999, 17.422224);
	PlayerTextDrawAlignment(playerid, PTD_iPhone[30][playerid], 1);
	PlayerTextDrawColor(playerid, PTD_iPhone[30][playerid], -1);
	PlayerTextDrawSetShadow(playerid, PTD_iPhone[30][playerid], 0);
	PlayerTextDrawSetOutline(playerid, PTD_iPhone[30][playerid], 0);
	PlayerTextDrawFont(playerid, PTD_iPhone[30][playerid], 4);

	PTD_iPhone[31][playerid] = CreatePlayerTextDraw(playerid, 518.900207, 316.781402, "hud:radar_flag");
	PlayerTextDrawLetterSize(playerid, PTD_iPhone[31][playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, PTD_iPhone[31][playerid], 14.999999, 17.422224);
	PlayerTextDrawAlignment(playerid, PTD_iPhone[31][playerid], 1);
	PlayerTextDrawColor(playerid, PTD_iPhone[31][playerid], -1);
	PlayerTextDrawSetShadow(playerid, PTD_iPhone[31][playerid], 0);
	PlayerTextDrawSetOutline(playerid, PTD_iPhone[31][playerid], 0);
	PlayerTextDrawFont(playerid, PTD_iPhone[31][playerid], 4);

	PTD_iPhone[32][playerid] = CreatePlayerTextDraw(playerid, 542.866943, 317.151763, "hud:radar_datedisco");
	PlayerTextDrawLetterSize(playerid, PTD_iPhone[32][playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, PTD_iPhone[32][playerid], 14.999999, 17.422224);
	PlayerTextDrawAlignment(playerid, PTD_iPhone[32][playerid], 1);
	PlayerTextDrawColor(playerid, PTD_iPhone[32][playerid], -1);
	PlayerTextDrawSetShadow(playerid, PTD_iPhone[32][playerid], 0);
	PlayerTextDrawSetOutline(playerid, PTD_iPhone[32][playerid], 0);
	PlayerTextDrawFont(playerid, PTD_iPhone[32][playerid], 4);

	PTD_iPhone[33][playerid] = CreatePlayerTextDraw(playerid, 567.500305, 317.007293, "hud:radar_light");
	PlayerTextDrawLetterSize(playerid, PTD_iPhone[33][playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, PTD_iPhone[33][playerid], 14.999999, 17.422224);
	PlayerTextDrawAlignment(playerid, PTD_iPhone[33][playerid], 1);
	PlayerTextDrawColor(playerid, PTD_iPhone[33][playerid], -1);
	PlayerTextDrawSetShadow(playerid, PTD_iPhone[33][playerid], 0);
	PlayerTextDrawSetOutline(playerid, PTD_iPhone[33][playerid], 0);
	PlayerTextDrawFont(playerid, PTD_iPhone[33][playerid], 4);

	PTD_iPhone[34][playerid] = CreatePlayerTextDraw(playerid, 518.566955, 351.092498, "hud:radar_propertyg");
	PlayerTextDrawLetterSize(playerid, PTD_iPhone[34][playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, PTD_iPhone[34][playerid], 14.999999, 17.422224);
	PlayerTextDrawAlignment(playerid, PTD_iPhone[34][playerid], 1);
	PlayerTextDrawColor(playerid, PTD_iPhone[34][playerid], -1);
	PlayerTextDrawSetShadow(playerid, PTD_iPhone[34][playerid], 0);
	PlayerTextDrawSetOutline(playerid, PTD_iPhone[34][playerid], 0);
	PlayerTextDrawFont(playerid, PTD_iPhone[34][playerid], 4);

	PTD_iPhone[35][playerid] = CreatePlayerTextDraw(playerid, 543.100280, 351.103698, "hud:radar_locosyndicate");
	PlayerTextDrawLetterSize(playerid, PTD_iPhone[35][playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, PTD_iPhone[35][playerid], 14.999999, 17.422224);
	PlayerTextDrawAlignment(playerid, PTD_iPhone[35][playerid], 1);
	PlayerTextDrawColor(playerid, PTD_iPhone[35][playerid], -1);
	PlayerTextDrawSetShadow(playerid, PTD_iPhone[35][playerid], 0);
	PlayerTextDrawSetOutline(playerid, PTD_iPhone[35][playerid], 0);
	PlayerTextDrawFont(playerid, PTD_iPhone[35][playerid], 4);

	PTD_iPhone[36][playerid] = CreatePlayerTextDraw(playerid, 567.566833, 351.147979, "hud:radar_propertyr");
	PlayerTextDrawLetterSize(playerid, PTD_iPhone[36][playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, PTD_iPhone[36][playerid], 14.999999, 17.422224);
	PlayerTextDrawAlignment(playerid, PTD_iPhone[36][playerid], 1);
	PlayerTextDrawColor(playerid, PTD_iPhone[36][playerid], -1);
	PlayerTextDrawSetShadow(playerid, PTD_iPhone[36][playerid], 0);
	PlayerTextDrawSetOutline(playerid, PTD_iPhone[36][playerid], 0);
	PlayerTextDrawFont(playerid, PTD_iPhone[36][playerid], 4);
	
	PTD_iPhone_Gallery[playerid] = CreatePlayerTextDraw(playerid, 511.266784, 249.677749, "loadsc1:loadsc1");
	PlayerTextDrawLetterSize(playerid, PTD_iPhone_Gallery[playerid], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, PTD_iPhone_Gallery[playerid], 78.666625, 70.518501);
	PlayerTextDrawAlignment(playerid, PTD_iPhone_Gallery[playerid], 1);
	PlayerTextDrawColor(playerid, PTD_iPhone_Gallery[playerid], -1);
	PlayerTextDrawSetShadow(playerid, PTD_iPhone_Gallery[playerid], 0);
	PlayerTextDrawSetOutline(playerid, PTD_iPhone_Gallery[playerid], 0);
	PlayerTextDrawFont(playerid, PTD_iPhone_Gallery[playerid], 4);
	
	PTD_iPhone_GPS[playerid] = CreatePlayerTextDraw(playerid, 548.666931, 266.481384, "Los Santos");
	PlayerTextDrawLetterSize(playerid, PTD_iPhone_GPS[playerid], 0.253666, 1.322074);
	PlayerTextDrawAlignment(playerid, PTD_iPhone_GPS[playerid], 2);
	PlayerTextDrawColor(playerid, PTD_iPhone_GPS[playerid], -5963521);
	PlayerTextDrawSetShadow(playerid, PTD_iPhone_GPS[playerid], 0);
	PlayerTextDrawSetOutline(playerid, PTD_iPhone_GPS[playerid], 1);
	PlayerTextDrawBackgroundColor(playerid, PTD_iPhone_GPS[playerid], 255);
	PlayerTextDrawFont(playerid, PTD_iPhone_GPS[playerid], 1);
	PlayerTextDrawSetProportional(playerid, PTD_iPhone_GPS[playerid], 1);
	
	PTD_iPhone_Calculator[playerid] = CreatePlayerTextDraw(playerid, 583.899963, 268.370300, "0");
	PlayerTextDrawLetterSize(playerid, PTD_iPhone_Calculator[playerid], 0.267999, 1.599999);
	PlayerTextDrawAlignment(playerid, PTD_iPhone_Calculator[playerid], 3);
	PlayerTextDrawColor(playerid, PTD_iPhone_Calculator[playerid], -1);
	PlayerTextDrawSetShadow(playerid, PTD_iPhone_Calculator[playerid], 0);
	PlayerTextDrawSetOutline(playerid, PTD_iPhone_Calculator[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, PTD_iPhone_Calculator[playerid], 51);
	PlayerTextDrawFont(playerid, PTD_iPhone_Calculator[playerid], 2);
	PlayerTextDrawSetProportional(playerid, PTD_iPhone_Calculator[playerid], 1);
	
	PTD_iPhone_Call[playerid] = CreatePlayerTextDraw(playerid, 586.666870, 264.651885, "_");
	PlayerTextDrawLetterSize(playerid, PTD_iPhone_Call[playerid], 0.333332, 1.239110);
	PlayerTextDrawAlignment(playerid, PTD_iPhone_Call[playerid], 3);
	PlayerTextDrawColor(playerid, PTD_iPhone_Call[playerid], -1);
	PlayerTextDrawSetShadow(playerid, PTD_iPhone_Call[playerid], 0);
	PlayerTextDrawSetOutline(playerid, PTD_iPhone_Call[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, PTD_iPhone_Call[playerid], 51);
	PlayerTextDrawFont(playerid, PTD_iPhone_Call[playerid], 1);
	PlayerTextDrawSetProportional(playerid, PTD_iPhone_Call[playerid], 1);
	return 1;
}

stock DestroyPlayerIphone(playerid)
{
	loop(0, 37, PHONE) PlayerTextDrawDestroy(playerid, PTD_iPhone[PHONE][playerid]);
	PlayerTextDrawDestroy(playerid, PTD_iPhone_Gallery[playerid]);
	PlayerTextDrawDestroy(playerid, PTD_iPhone_GPS[playerid]);
	PlayerTextDrawDestroy(playerid, PTD_iPhone_Calculator[playerid]);
	PlayerTextDrawDestroy(playerid, PTD_iPhone_Call[playerid]);
	DestroyObject(firstperson[playerid]);
	return 1;
}
