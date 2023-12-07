if(clickedid == TD_iPhone_Call[1])
{
	PlayerPlaySound(playerid, 17803, 0.0, 0.0, 0.0);
	strcat(called[playerid], "1");
	PlayerTextDrawSetString(playerid, PTD_iPhone_Call[playerid], called[playerid]);
}
if(clickedid == TD_iPhone_Call[2])
{
	PlayerPlaySound(playerid, 17803, 0.0, 0.0, 0.0);
	strcat(called[playerid], "2");
	PlayerTextDrawSetString(playerid, PTD_iPhone_Call[playerid], called[playerid]);
}
if(clickedid == TD_iPhone_Call[3])
{
	PlayerPlaySound(playerid, 17803, 0.0, 0.0, 0.0);
	strcat(called[playerid], "3");
	PlayerTextDrawSetString(playerid, PTD_iPhone_Call[playerid], called[playerid]);
}
if(clickedid == TD_iPhone_Call[4])
{
	PlayerPlaySound(playerid, 17803, 0.0, 0.0, 0.0);
	strcat(called[playerid], "4");
	PlayerTextDrawSetString(playerid, PTD_iPhone_Call[playerid], called[playerid]);
}
if(clickedid == TD_iPhone_Call[5])
{
	PlayerPlaySound(playerid, 17803, 0.0, 0.0, 0.0);
	strcat(called[playerid], "5");
	PlayerTextDrawSetString(playerid, PTD_iPhone_Call[playerid], called[playerid]);
}
if(clickedid == TD_iPhone_Call[6])
{
	PlayerPlaySound(playerid, 17803, 0.0, 0.0, 0.0);
	strcat(called[playerid], "6");
	PlayerTextDrawSetString(playerid, PTD_iPhone_Call[playerid], called[playerid]);
}
if(clickedid == TD_iPhone_Call[7])
{
	PlayerPlaySound(playerid, 17803, 0.0, 0.0, 0.0);
	strcat(called[playerid], "7");
	PlayerTextDrawSetString(playerid, PTD_iPhone_Call[playerid], called[playerid]);
}
if(clickedid == TD_iPhone_Call[8])
{
	PlayerPlaySound(playerid, 17803, 0.0, 0.0, 0.0);
	strcat(called[playerid], "8");
	PlayerTextDrawSetString(playerid, PTD_iPhone_Call[playerid], called[playerid]);
}
if(clickedid == TD_iPhone_Call[9])
{
	PlayerPlaySound(playerid, 17803, 0.0, 0.0, 0.0);
	strcat(called[playerid], "9");
	PlayerTextDrawSetString(playerid, PTD_iPhone_Call[playerid], called[playerid]);
}
if(clickedid == TD_iPhone_Call[10])
{
	PlayerPlaySound(playerid, 17803, 0.0, 0.0, 0.0);
	strcat(called[playerid], "0");
	PlayerTextDrawSetString(playerid, PTD_iPhone_Call[playerid], called[playerid]);
}
if(clickedid == TD_iPhone_Call[11]) //Call
{
	PlayerPlaySound(playerid, 3600, 0.0, 0.0, 0.0);
	CancelSelectTextDraw(playerid);
	loop(0, sizeof(TD_iPhone_Call), PHONE) TextDrawHideForPlayer(playerid, TD_iPhone_Call[PHONE]);
	SendClientMessage(playerid, -1, "Establishing call...");
	TextDrawShowForPlayer(playerid, TD_iPhone_CallYesNo[0]);
	TextDrawShowForPlayer(playerid, TD_iPhone_CallYesNo[1]);
	iPhoneCallStatus[playerid] = 1;
	new c;
	new ph = strval(called[playerid]);
	for(new i = 0; i != MAX_PLAYERS; i ++)
	{
		if(IsPlayerConnected(i))
		{
			if(playerid != i)
			{
				if(PlayerInfo[i][PhoneNumber] == ph)
				{
					if(iPhoneStatus[i] == 3) HideIphoneMenu(i);
					iPhoneCallStatus[playerid] = 2;
					iPhoneCallStatus[i] = 2;
					callto[playerid] = i;
					callto[i] = playerid;
					c = 1;
					PlayerPlaySound(i, 20600, 0.0, 0.0, 0.0);
					TextDrawShowForPlayer(i, TD_iPhone_CallYesNo[0]);
					TextDrawShowForPlayer(i, TD_iPhone_CallYesNo[1]);
					iPhoneStatus[i] = 3;
					TextDrawHideForPlayer(i, TD_iPhone[25]);
					loop(0, 19, PHONE) TextDrawShowForPlayer(i, TD_iPhone[PHONE]);
					loop(19, sizeof(TD_iPhone), PHONE) TextDrawHideForPlayer(i, TD_iPhone[PHONE]);
					loop(1, sizeof(PTD_iPhone), PPHONE) PlayerTextDrawHide(i, PTD_iPhone[PPHONE][i]);
					TextDrawShowForPlayer(i, TD_iPhone[22]);
					TextDrawShowForPlayer(i, TD_iPhone[23]);
					TextDrawShowForPlayer(i, TD_iPhone[24]);
					PlayerTextDrawSetString(i, PTD_iPhone[0][i], "Call");
					PlayerTextDrawShow(i, PTD_iPhone[0][i]);
					break;
				}
			}
		}
	}
	if(c == 0)
	{
		iPhoneCallStatus[playerid] = 0;
		PlayerPlaySound(playerid, 1053, 0.0, 0.0, 0.0);
		iPhoneStatus[playerid] = 2;
		HideIphoneMenu(playerid);
		TextDrawShowForPlayer(playerid, TD_iPhone[25]);
		loop(1, 37, PPHONE) PlayerTextDrawShow(playerid, PTD_iPhone[PPHONE][playerid]);
		SendClientMessage(playerid, -1, "The dialed number does not exist or is out of coverage.");
	}
	else SendClientMessage(playerid, -1, "Calling...");
}
if(clickedid == TD_iPhone_Call[12]) //Delete
{
	PlayerPlaySound(playerid, 17803, 0.0, 0.0, 0.0);
	new size = strlen(called[playerid]);
	if(size == 1) strdel(called[playerid],0,1),PlayerTextDrawSetString(playerid,PTD_iPhone_Call[playerid],"_");
	else strdel(called[playerid],size-1,size), PlayerTextDrawSetString(playerid,PTD_iPhone_Call[playerid],called[playerid]);
}
if(clickedid == TD_iPhone_Calculator[0])
{
	PlayerPlaySound(playerid, 17803, 0.0, 0.0, 0.0);
	if(!GetPVarInt(playerid, "tovar"))
	{
		strcat(var1[playerid], "0");
		PlayerTextDrawSetString(playerid, PTD_iPhone_Calculator[playerid], var1[playerid]);
	}
	else
	{
		strcat(var2[playerid], "0");
		PlayerTextDrawSetString(playerid, PTD_iPhone_Calculator[playerid], var2[playerid]);
	}
}
if(clickedid == TD_iPhone_Calculator[1])
{
	PlayerPlaySound(playerid, 17803, 0.0, 0.0, 0.0);
	if(!GetPVarInt(playerid, "tovar"))
	{
		var1[playerid] = "";
		var2[playerid] = "";
		PlayerTextDrawSetString(playerid, PTD_iPhone_Calculator[playerid], "ERROR");
	}
	else
	{
		new s = GetPVarInt(playerid, "tovar");
		switch(s)
		{
			case 1:
			{
				new str[24];
				format(str, 24, "%d", (strval(var1[playerid])/strval(var2[playerid])));
				PlayerTextDrawSetString(playerid, PTD_iPhone_Calculator[playerid], str);
			}
			case 2:
			{
				new str[24];
				format(str, 24, "%d", (strval(var1[playerid])*strval(var2[playerid])));
				PlayerTextDrawSetString(playerid, PTD_iPhone_Calculator[playerid], str);
			}
			case 3:
			{
				new str[24];
				format(str, 24, "%d", (strval(var1[playerid])-strval(var2[playerid])));
				PlayerTextDrawSetString(playerid, PTD_iPhone_Calculator[playerid], str);
			}
			case 4:
			{
				new str[24];
				format(str, 24, "%d", (strval(var1[playerid])+strval(var2[playerid])));
				PlayerTextDrawSetString(playerid, PTD_iPhone_Calculator[playerid], str);
			}
		}
		DeletePVar(playerid, "tovar");
		var1[playerid] = "";
		var2[playerid] = "";
	}
}
if(clickedid == TD_iPhone_Calculator[2])
{
	PlayerPlaySound(playerid, 17803, 0.0, 0.0, 0.0);
	if(!GetPVarInt(playerid, "tovar"))
	{
		strcat(var1[playerid], "1");
		PlayerTextDrawSetString(playerid, PTD_iPhone_Calculator[playerid], var1[playerid]);
	}
	else
	{
		strcat(var2[playerid], "1");
		PlayerTextDrawSetString(playerid, PTD_iPhone_Calculator[playerid], var2[playerid]);
	}
}
if(clickedid == TD_iPhone_Calculator[3])
{
	PlayerPlaySound(playerid, 17803, 0.0, 0.0, 0.0);
	if(!GetPVarInt(playerid, "tovar"))
	{
		strcat(var1[playerid], "2");
		PlayerTextDrawSetString(playerid, PTD_iPhone_Calculator[playerid], var1[playerid]);
	}
	else
	{
		strcat(var2[playerid], "2");
		PlayerTextDrawSetString(playerid, PTD_iPhone_Calculator[playerid], var2[playerid]);
	}
}
if(clickedid == TD_iPhone_Calculator[4])
{
	PlayerPlaySound(playerid, 17803, 0.0, 0.0, 0.0);
	if(!GetPVarInt(playerid, "tovar"))
	{
		strcat(var1[playerid], "3");
		PlayerTextDrawSetString(playerid, PTD_iPhone_Calculator[playerid], var1[playerid]);
	}
	else
	{
		strcat(var2[playerid], "3");
		PlayerTextDrawSetString(playerid, PTD_iPhone_Calculator[playerid], var2[playerid]);
	}
}
if(clickedid == TD_iPhone_Calculator[5])
{
	PlayerPlaySound(playerid, 17803, 0.0, 0.0, 0.0);
	if(!GetPVarInt(playerid, "tovar"))
	{
		strcat(var1[playerid], "4");
		PlayerTextDrawSetString(playerid, PTD_iPhone_Calculator[playerid], var1[playerid]);
	}
	else
	{
		strcat(var2[playerid], "4");
		PlayerTextDrawSetString(playerid, PTD_iPhone_Calculator[playerid], var2[playerid]);
	}
}
if(clickedid == TD_iPhone_Calculator[6])
{
	PlayerPlaySound(playerid, 17803, 0.0, 0.0, 0.0);
	if(!GetPVarInt(playerid, "tovar"))
	{
		strcat(var1[playerid], "5");
		PlayerTextDrawSetString(playerid, PTD_iPhone_Calculator[playerid], var1[playerid]);
	}
	else
	{
		strcat(var2[playerid], "5");
		PlayerTextDrawSetString(playerid, PTD_iPhone_Calculator[playerid], var2[playerid]);
	}
}
if(clickedid == TD_iPhone_Calculator[7])
{
	PlayerPlaySound(playerid, 17803, 0.0, 0.0, 0.0);
	if(!GetPVarInt(playerid, "tovar"))
	{
		strcat(var1[playerid], "6");
		PlayerTextDrawSetString(playerid, PTD_iPhone_Calculator[playerid], var1[playerid]);
	}
	else
	{
		strcat(var2[playerid], "6");
		PlayerTextDrawSetString(playerid, PTD_iPhone_Calculator[playerid], var2[playerid]);
	}
}
if(clickedid == TD_iPhone_Calculator[8])
{
	PlayerPlaySound(playerid, 17803, 0.0, 0.0, 0.0);
	if(!GetPVarInt(playerid, "tovar"))
	{
		strcat(var1[playerid], "7");
		PlayerTextDrawSetString(playerid, PTD_iPhone_Calculator[playerid], var1[playerid]);
	}
	else
	{
		strcat(var2[playerid], "7");
		PlayerTextDrawSetString(playerid, PTD_iPhone_Calculator[playerid], var2[playerid]);
	}
}
if(clickedid == TD_iPhone_Calculator[9])
{
	PlayerPlaySound(playerid, 17803, 0.0, 0.0, 0.0);
	if(!GetPVarInt(playerid, "tovar"))
	{
		strcat(var1[playerid], "8");
		PlayerTextDrawSetString(playerid, PTD_iPhone_Calculator[playerid], var1[playerid]);
	}
	else
	{
		strcat(var2[playerid], "8");
		PlayerTextDrawSetString(playerid, PTD_iPhone_Calculator[playerid], var2[playerid]);
	}
}
if(clickedid == TD_iPhone_Calculator[10])
{
	PlayerPlaySound(playerid, 17803, 0.0, 0.0, 0.0);
	if(!GetPVarInt(playerid, "tovar"))
	{
		strcat(var1[playerid], "9");
		PlayerTextDrawSetString(playerid, PTD_iPhone_Calculator[playerid], var1[playerid]);
	}
	else
	{
		strcat(var2[playerid], "9");
		PlayerTextDrawSetString(playerid, PTD_iPhone_Calculator[playerid], var2[playerid]);
	}
}
if(clickedid == TD_iPhone_Calculator[11])
{
	PlayerPlaySound(playerid, 17803, 0.0, 0.0, 0.0);
	if(!GetPVarInt(playerid, "tovar"))
	{
		SetPVarInt(playerid, "tovar", 1);
		PlayerTextDrawSetString(playerid, PTD_iPhone_Calculator[playerid], "/");
	}
	else
	{
		DeletePVar(playerid, "tovar");
		var1[playerid] = "";
		var2[playerid] = "";
		PlayerTextDrawSetString(playerid, PTD_iPhone_Calculator[playerid], "ERROR");
	}
}
if(clickedid == TD_iPhone_Calculator[12])
{
	PlayerPlaySound(playerid, 17803, 0.0, 0.0, 0.0);
	if(!GetPVarInt(playerid, "tovar"))
	{
		SetPVarInt(playerid, "tovar", 2);
		PlayerTextDrawSetString(playerid, PTD_iPhone_Calculator[playerid], "X");
	}
	else
	{
		DeletePVar(playerid, "tovar");
		var1[playerid] = "";
		var2[playerid] = "";
		PlayerTextDrawSetString(playerid, PTD_iPhone_Calculator[playerid], "ERROR");
	}
}
if(clickedid == TD_iPhone_Calculator[13])
{
	PlayerPlaySound(playerid, 17803, 0.0, 0.0, 0.0);
	if(!GetPVarInt(playerid, "tovar"))
	{
		SetPVarInt(playerid, "tovar", 3);
		PlayerTextDrawSetString(playerid, PTD_iPhone_Calculator[playerid], "-");
	}
	else
	{
		DeletePVar(playerid, "tovar");
		var1[playerid] = "";
		var2[playerid] = "";
		PlayerTextDrawSetString(playerid, PTD_iPhone_Calculator[playerid], "ERROR");
	}
}
if(clickedid == TD_iPhone_Calculator[14])
{
	PlayerPlaySound(playerid, 17803, 0.0, 0.0, 0.0);
	if(!GetPVarInt(playerid, "tovar"))
	{
		SetPVarInt(playerid, "tovar", 4);
		PlayerTextDrawSetString(playerid, PTD_iPhone_Calculator[playerid], "+");
	}
	else
	{
		DeletePVar(playerid, "tovar");
		var1[playerid] = "";
		var2[playerid] = "";
		PlayerTextDrawSetString(playerid, PTD_iPhone_Calculator[playerid], "ERROR");
	}
}