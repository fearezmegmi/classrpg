/*
	ScriptPlayer Version 1.2 Include 
	Author: Pghpunkid
	Date: June 20th 2009
	Please read the ScriptPlayer License Agreement before using this software. Thanks.
*/

native SPPlayForPlayer(playerid,URL[]);
native SPPlayForAll(URL[]);
native SPStopForPlayer(playerid);
native SPStopForAll();
native SPSync(playerid,playername[]);
native SPDesync(playerid);
native SPSendInfoToPlayer(playerid,message[]);
native SPSendInfoToAll(playerid,message[]);
native SPCreate(port);
native SPClose();
native SPConnected(playerid);
forward OnSPConnect(conn);
forward OnSPDisconnect(conn);