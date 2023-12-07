// plugin natives

native ModelStartListening(port);
native ModelSocketClose();
native CheckFiles();
native ModelPlayerConnect(playerid,name[],ip[]);
native ModelPlayerDisconnect(playerid);
native PlayerReplaceCar(playerid,vehicleid);
native ReturnCar(vehicleid);

// plugin callbacks


forward OnFileTransfer(playerid);
forward ModelOnPlayerConnect(playerid);
forward OnStartCopyFiles(playerid);
forward OnTimer();
forward OnTimer1MS();