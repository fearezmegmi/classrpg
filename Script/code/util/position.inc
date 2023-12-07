#if defined __util_position
	#endinput
#endif
#define __util_position

stock GetXYInFrontOfVehicle(playerid,&Float:x,&Float:y,Float:dis)
{
	new currentveh;
	new Float:a, Float:z;
	currentveh = GetPlayerVehicleID(playerid);
	GetVehiclePos(currentveh, x, y, z);
	GetVehicleZAngle(currentveh, a);
	GetXYInFrontOfPoint(x, y, a,dis);
}

stock GetXYLeftOfVehicle(playerid,&Float:x,&Float:y,Float:dis)
{
	new currentveh;
	new Float:a, Float:z;
	currentveh = GetPlayerVehicleID(playerid);
	GetVehiclePos(currentveh, x, y, z);
	GetVehicleZAngle(currentveh, a);
	GetXYLeftOfPoint(x, y, a,dis);
}

stock GetXYRightOfVehicle(playerid,&Float:x,&Float:y,Float:dis)
{
	new currentveh;
	new Float:a, Float:z;
	currentveh = GetPlayerVehicleID(playerid);
	GetVehiclePos(currentveh, x, y, z);
	GetVehicleZAngle(currentveh, a);
	GetXYRightOfPoint(x, y, a,dis);
}

stock GetXYBehindVehicle(playerid,&Float:x,&Float:y,Float:dis)
{
	new currentveh;
	new Float:a, Float:z;
	currentveh = GetPlayerVehicleID(playerid);
	GetVehiclePos(currentveh, x, y, z);
	GetVehicleZAngle(currentveh, a);
	GetXYBehindPoint(x, y, a,dis);
}
//------------------------------------------------------------------------------
/*Float:DistanceCameraTargetToLocation(Float:CamX, Float:CamY, Float:CamZ, Float:ObjX, Float:ObjY, Float:ObjZ, Float:FrX, Float:FrY, Float:FrZ) {

	new Float:TGTDistance;

	TGTDistance = floatsqroot((CamX - ObjX) * (CamX - ObjX) + (CamY - ObjY) * (CamY - ObjY) + (CamZ - ObjZ) * (CamZ - ObjZ));

	new Float:tmpX, Float:tmpY, Float:tmpZ;

	tmpX = FrX * TGTDistance + CamX;
	tmpY = FrY * TGTDistance + CamY;
	tmpZ = FrZ * TGTDistance + CamZ;

	return floatsqroot((tmpX - ObjX) * (tmpX - ObjX) + (tmpY - ObjY) * (tmpY - ObjY) + (tmpZ - ObjZ) * (tmpZ - ObjZ));
}*/

stock Float:GetPointAngleToPoint(Float:x2, Float:y2, Float:X, Float:Y) {

  new Float:DX, Float:DY;
  new Float:angle;

  DX = floatabs(floatsub(x2,X));
  DY = floatabs(floatsub(y2,Y));

  if (DY == 0.0 || DX == 0.0) {
    if(DY == 0 && DX > 0) angle = 0.0;
    else if(DY == 0 && DX < 0) angle = 180.0;
    else if(DY > 0 && DX == 0) angle = 90.0;
    else if(DY < 0 && DX == 0) angle = 270.0;
    else if(DY == 0 && DX == 0) angle = 0.0;
  }
  else {
    angle = atan(DX/DY);

    if(X > x2 && Y <= y2) angle += 90.0;
    else if(X <= x2 && Y < y2) angle = floatsub(90.0, angle);
    else if(X < x2 && Y >= y2) angle -= 90.0;
    else if(X >= x2 && Y > y2) angle = floatsub(270.0, angle);
  }

  return floatadd(angle, 90.0);
}

stock IsPlayerAimingAt(playerid, Float:x, Float:y, Float:z, Float:radius)
{
	new Float:camera_x,Float:camera_y,Float:camera_z,Float:vector_x,Float:vector_y,Float:vector_z;
	GetPlayerCameraPos(playerid, camera_x, camera_y, camera_z);
	GetPlayerCameraFrontVector(playerid, vector_x, vector_y, vector_z);

	new Float:vertical, Float:horizontal;

	switch (GetPlayerWeapon(playerid))
	{
		case 34,35,36:
		{
			if(DistanceCameraTargetToLocation(camera_x, camera_y, camera_z, x, y, z, vector_x, vector_y, vector_z) < radius) return true;
			else return false;
		}
		case 30,31: {vertical = 4.0; horizontal = -1.6;}
		case 33: {vertical = 2.7; horizontal = -1.0;}
		default: {vertical = 6.0; horizontal = -2.2;}
	}

	new Float:angle = GetPointAngleToPoint(0, 0, floatsqroot(vector_x*vector_x+vector_y*vector_y), vector_z) - 270.0;
	new Float:resize_x, Float:resize_y, Float:resize_z = floatsin(angle+vertical, degrees);
	GetXYInFrontOfPoint(resize_x, resize_y, GetPointAngleToPoint(0, 0, vector_x, vector_y)+horizontal, floatcos(angle+vertical, degrees));

	if(DistanceCameraTargetToLocation(camera_x, camera_y, camera_z, x, y, z, resize_x, resize_y, resize_z) < radius) return true;
	return false;
}

stock IsPlayerAimingAtPlayer(playerid, targetplayerid) {
  new Float:x, Float:y, Float:z;
  GetPlayerPos(targetplayerid, x, y, z);
  return IsPlayerAimingAt(playerid, x, y, z, 1.1);
}

stock GetXYInFrontOfPoint(&Float:x, &Float:y, Float:angle, Float:distance) {
	x += (distance * floatsin(-angle, degrees));
	y += (distance * floatcos(-angle, degrees));
}

stock GetXYBehindPoint(&Float:x, &Float:y, Float:angle, Float:distance) {
	x -= (distance * floatsin(-angle, degrees));
	y -= (distance * floatcos(-angle, degrees));
}

stock GetXYLeftOfPoint(&Float:x, &Float:y, Float:angle, Float:distance) {
	x -= (distance * floatsin(-angle - 90.0, degrees));
	y -= (distance * floatcos(-angle - 90.0, degrees));
}

stock GetXYRightOfPoint(&Float:x, &Float:y, Float:angle, Float:distance) {
	x -= (distance * floatsin(-angle + 90.0, degrees));
	y -= (distance * floatcos(-angle + 90.0, degrees));
}

stock GetXYZInFrontOfPlayer(playerid, &Float:x, &Float:y, &Float:z, Float:dis)
{
	new Float:a;
	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid,a);
	GetXYInFrontOfPoint(x, y, a, dis);
}

stock GetXYInFrontOfPlayer(playerid,&Float:x,&Float:y,Float:dis)
{
	new Float:a, Float:z;
	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid,a);
	GetXYInFrontOfPoint(x, y, a, dis);
}

stock GetXYBehindPlayer(playerid,&Float:x,&Float:y,Float:dis)
{
	new Float:a, Float:z;
	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid,a);
	GetXYBehindPoint(x, y, a, dis);
}

stock PlayerToPoint(Float:radi, playerid, Float:x, Float:y, Float:z, virtualworld = -1, interior = -1)
{
	if(virtualworld != -1 && GetPlayerVirtualWorld(playerid) != virtualworld)
		return 0;
	if(interior != -1 && GetPlayerInterior(playerid) != interior)
		return 0;
			
	return IsPlayerInRangeOfPoint(playerid, radi, x, y, z);
}

stock CarToPoint(Float:radi, carid, Float:x, Float:y, Float:z)
{
	new Float:oldposx, Float:oldposy, Float:oldposz;
	new Float:tempposx, Float:tempposy, Float:tempposz;
	GetVehiclePos(carid, oldposx, oldposy, oldposz);
	tempposx = (oldposx -x);
	tempposy = (oldposy -y);
	tempposz = (oldposz -z);
	if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi))) return 1;
	return 0;
}

stock Float:GetPlayerDistanceFromVehicle(playerid, vehicleid)
{
	new Float:x1, Float:y1, Float:z1;
	GetVehiclePos(vehicleid, x1,y1,z1);
	return GetPlayerDistanceFromPoint(playerid, x1,y1,z1);
}

stock Float:GetDistanceBetweenPlayers(p1, p2)
{
	if(!IsPlayerConnected(p1) || !IsPlayerConnected(p2))
		return -1.00;
		
	if(GetPlayerVirtualWorld(p1) != GetPlayerVirtualWorld(p2) || GetPlayerInterior(p1) != GetPlayerInterior(p2))
		return 10000.00;
		
	new Float: x, Float: y, Float: z;
	GetPlayerPos(p2, x, y, z);
	return GetPlayerDistanceFromPoint(p1, x, y, z);
}

stock Float:GetDistanceBetweenPoints(Float: x1, Float: y1, Float: z1, Float: x2, Float: y2, Float: z2)
	return VectorSize(x1-x2, y1-y2, z1-z2);