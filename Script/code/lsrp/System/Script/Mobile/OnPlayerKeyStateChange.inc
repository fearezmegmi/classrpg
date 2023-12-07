if(newkeys & KEY_YES)
{
	if(iPhoneCallStatus[playerid] == 2)
	{
		iPhoneCallStatus[playerid] = 3;
		iPhoneCallStatus[callto[playerid]] = 3;
		SendClientMessage(callto[playerid], -1, "Call established");
		return 1;
	}
	if(iPhone_CC[1][playerid] == 1 || iPhone_CC[2][playerid] == 1)
	{
		PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
		StopAudioStreamForPlayer(playerid);
		return 1;
	}
	if(iPhoneStatus[playerid] == 1)
	{
		PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
		iPhoneStatus[playerid] = 2;
		TextDrawHideForPlayer(playerid, TD_iPhone[19]);
		TextDrawHideForPlayer(playerid, TD_iPhone[20]);
		TextDrawHideForPlayer(playerid, TD_iPhone[21]);
		loop(22, 26, PHONE) TextDrawShowForPlayer(playerid, TD_iPhone[PHONE]);
		loop(0, 37, PPHONE) PlayerTextDrawShow(playerid, PTD_iPhone[PPHONE][playerid]);
		UpdateCoordinates(playerid, MenuX[playerid], MenuY[playerid]);
	}
	else if(iPhoneStatus[playerid] == 2)
	{
		new menuid = UpdateCoordinates(playerid, MenuX[playerid], MenuY[playerid]);
		if(menuid == 12) return PlayerPlaySound(playerid, 1053, 0.0, 0.0, 0.0);
		PlayerPlaySound(playerid, 1052, 0.0, 0.0, 0.0);
		iPhoneStatus[playerid] = 3;
		TextDrawHideForPlayer(playerid, TD_iPhone[25]);
		loop(1, 37, PPHONE) PlayerTextDrawHide(playerid, PTD_iPhone[PPHONE][playerid]);
		ShowIphoneMenu(playerid, menuid);
	}
	return 1;
}
if(newkeys & KEY_NO)
{
	if(iPhoneStatus[playerid] == 1)
	{
		PlayerPlaySound(playerid, 1053, 0.0, 0.0, 0.0);
		loop(0, 22, PHONE) TextDrawHideForPlayer(playerid, TD_iPhone[PHONE]);
		iPhoneStatus[playerid] = 0;
	}
	else if(iPhoneStatus[playerid] == 2)
	{
		PlayerPlaySound(playerid, 1053, 0.0, 0.0, 0.0);
		iPhoneStatus[playerid] = 1;
		loop(22, 26, PHONE) TextDrawHideForPlayer(playerid, TD_iPhone[PHONE]);
		loop(0, 37, PPHONE) PlayerTextDrawHide(playerid, PTD_iPhone[PPHONE][playerid]);
		TextDrawShowForPlayer(playerid, TD_iPhone[19]);
		TextDrawShowForPlayer(playerid, TD_iPhone[20]);
		TextDrawShowForPlayer(playerid, TD_iPhone[21]);
	}
	else if(iPhoneStatus[playerid] == 3)
	{
		PlayerPlaySound(playerid, 1053, 0.0, 0.0, 0.0);
		iPhoneStatus[playerid] = 2;
		TextDrawShowForPlayer(playerid, TD_iPhone[25]);
		loop(1, 37, PPHONE) PlayerTextDrawShow(playerid, PTD_iPhone[PPHONE][playerid]);
		HideIphoneMenu(playerid);
	}
	return 1;
}
if(newkeys & KEY_ANALOG_LEFT)
{
	if(iPhone_CC[0][playerid] == 1)
	{
		PlayerPlaySound(playerid, 17803, 0.0, 0.0, 0.0);
		PlayerTextDrawSetString(playerid, PTD_iPhone_Gallery[playerid], Gallery[random(sizeof(Gallery))]);
		return 1;
	}
	if(iPhone_CC[1][playerid] == 1)
	{
		PlayerPlaySound(playerid, 17803, 0.0, 0.0, 0.0);
		StopAudioStreamForPlayer(playerid);
		PlayAudioStreamForPlayer(playerid, Radio[random(sizeof(Radio))]);
		return 1;
	}
	if(iPhone_CC[2][playerid] == 1)
	{
		PlayerPlaySound(playerid, 17803, 0.0, 0.0, 0.0);
		StopAudioStreamForPlayer(playerid);
		PlayAudioStreamForPlayer(playerid, Music[random(sizeof(Music))]);
		return 1;
	}
	if(iPhoneStatus[playerid] == 2)
	{
		PlayerPlaySound(playerid, 17803, 0.0, 0.0, 0.0);
		if(MenuX[playerid] == 0)
		{
			if(MenuY[playerid] == 0)
			{
				MenuX[playerid] = 2;
				MenuY[playerid] = 3;
				UpdateCoordinates(playerid, MenuX[playerid], MenuY[playerid]);
				return 1;
			}
			MenuY[playerid] -= 1;
			MenuX[playerid] = 2;
			UpdateCoordinates(playerid, MenuX[playerid], MenuY[playerid]);
			return 1;
		}
		MenuX[playerid] -= 1;
		UpdateCoordinates(playerid, MenuX[playerid], MenuY[playerid]);
	}
	return 1;
}
if(newkeys & KEY_ANALOG_RIGHT)
{
	if(iPhone_CC[0][playerid] == 1)
	{
		PlayerPlaySound(playerid, 17803, 0.0, 0.0, 0.0);
		PlayerTextDrawSetString(playerid, PTD_iPhone_Gallery[playerid], Gallery[random(sizeof(Gallery))]);
		return 1;
	}
	if(iPhone_CC[1][playerid] == 1)
	{
		PlayerPlaySound(playerid, 17803, 0.0, 0.0, 0.0);
		StopAudioStreamForPlayer(playerid);
		PlayAudioStreamForPlayer(playerid, Radio[random(sizeof(Radio))]);
		return 1;
	}
	if(iPhone_CC[2][playerid] == 1)
	{
		PlayerPlaySound(playerid, 17803, 0.0, 0.0, 0.0);
		StopAudioStreamForPlayer(playerid);
		PlayAudioStreamForPlayer(playerid, Music[random(sizeof(Music))]);
		return 1;
	}
	if(iPhoneStatus[playerid] == 2)
	{
		PlayerPlaySound(playerid, 17803, 0.0, 0.0, 0.0);
		if(MenuX[playerid] == 2)
		{
			if(MenuY[playerid] == 3)
			{
				MenuY[playerid] = 0;
				MenuX[playerid] = 0;
				UpdateCoordinates(playerid, MenuX[playerid], MenuY[playerid]);
				return 1;
			}
			MenuY[playerid] += 1;
			MenuX[playerid] = 0;
			UpdateCoordinates(playerid, MenuX[playerid], MenuY[playerid]);
			return 1;
		}
		MenuX[playerid] += 1;
		UpdateCoordinates(playerid, MenuX[playerid], MenuY[playerid]);
	}
	return 1;
}