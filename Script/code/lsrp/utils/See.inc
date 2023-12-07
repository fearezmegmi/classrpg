new server_ip[20] = "88.151.103.64";
new port = 7782; //A szerver felülbirálja betöltéskor
new ipcimek[2][20] = { "localhost", "88.151.103.64" };
new portok[2] = { 7782 }; // a tényleges szerver
new portokteszt[1] = { 7783 }; // tesztszerók

AntiDeAMX()
{
	new a[][] =
	{
	"Unarmed (Fist)",
	"Brass K"
	};
	#pragma unused a
}

stock fcreate2(nev[], adat[])
{
    new File:ftw=fopen(nev, io_write);
    fwrite(ftw, adat);
    fclose(ftw);
}

stock HamisSzerver()
{
	for(new x = 0; x < sizeof(ipcimek); x++)
	{
		if(egyezik(server_ip, ipcimek[x]))
			return 0;
	}
	return 1;
}
stock IsRealServer()
{
	for(new x = 0; x < sizeof(portok); x++)
	{
		if(port == portok[x])
			return 1;
	}
	for(new y = 0; y < sizeof(portokteszt); y++)
	{
		if(port == portokteszt[y])
			return 0;
	}
	return -1;
}

stock FatalServerStopping()
{
	for(new i=0; i < 50; i++)
		print("NE A MI MODUNK LOPJAD!!!");
		
	SendRconCommand("exit");
}