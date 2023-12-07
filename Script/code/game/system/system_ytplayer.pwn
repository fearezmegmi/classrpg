#if defined __game_system_system_ytplayer
	#endinput
#endif
#define __game_system_system_ytplayer

/**	::				::
	:: 	DEFINÍCIÓK	::
	::				::	**/

#define RIPORTER 	1
#define HIFI 		2
#define MP4			3

/**	::				::
	:: 	 VÁLTOZÓK	::
	::				::	**/
	
new R_stream, R_title[48], R_duration = 0, R_inputlink[128], RiporterZeneTipus;
new H_stream[MAXHAZ], H_title[MAXHAZ][48], H_duration[MAXHAZ] = 0, H_inputlink[MAXHAZ][128], Float:H_playpos[MAXHAZ][3];

/**	::				::
	:: 	 PUBLICOK	::
	::				::	**/

fpublic OnYoutubeResponse(playerid, response_code, data[])
{
	if(response_code == 200)
	{
		new cim[48], hossz, stream[128], str[256];
        new hours,minutes,seconds;
		Format(str, "%s", str_replace(" <br/>", ";", data));
		Format(str, "%s", str_replace("Title: ", "", str));
		Format(str, "%s", str_replace("Length: ", "", str));
		Format(str, "%s", str_replace("Link: ", "", str));
		strdel(str, strlen(str)-1, strlen(str));
		sscanf(str, "p<;>s[48]ds[128]", cim, hossz, stream);
		if((LMT(playerid, FRAKCIO_RIPORTER) || Admin(playerid, 6)) && Hazbanvan[playerid] == 0 && YouTubeZeneRakas[playerid] == 1)
		{
			R_duration = hossz;
			FormatSeconds(R_duration, hours, minutes, seconds);
			R_title = cim;
			RiporterZeneVan = true;
			RiporterZene = stream;
			RiporterZeneTipus = 1;
			R_stream = UnixTime+R_duration;
 
			foreach(Jatekosok, p)
			{
				if(PlayerInfo[p][pRadio] == 1 && Logged(p) && gNews[p] == 0 && Zsebradio[p] == 0 && RiobanVan{p} == 0 && !Hifirolhallgatzenet[p])
					PlayAudioStreamForPlayer(p, RiporterZene);
			}
			
			if(!RiporterZeneVan) SendRadioMessageFormat(FRAKCIO_RIPORTER, COLOR_YELLOW, "<< %s bekapcsolta a zene streamelést! (YouTube) >>", ICPlayerName(playerid));
			else SendRadioMessageFormat(FRAKCIO_RIPORTER, COLOR_YELLOW, "<< %s zenét váltott! (YouTube) >>", ICPlayerName(playerid));
			SendRadioMessageFormat(FRAKCIO_RIPORTER, COLOR_YELLOW, "<< Zene adatok: Név: %s Hosszúság: %02d:%02d:%02d >>", R_title, hours, minutes, seconds);
			Msg(playerid, "Zene streamelés mindenkinél elindítva!");
			return 1;
		}
		if((HazabanVan(playerid) || HazabanVan2(playerid)) && YouTubeZeneRakas[playerid] == 2)
		{
			new h;
			if(HazabanVan(playerid)) h = HazabanVan(playerid);
			else if(HazabanVan2(playerid)) h = HazabanVan2(playerid);
			else
			{
				new errormsg[128], Float:x,Float:y,Float:z;
				GetPlayerPos(playerid,x,y,z);
				Format(errormsg, "[HIFI HIBA] Név: %s, pozíciója: %.3f, %.3f, %.3f, hol: OnYoutubeResponse", PlayerName(playerid),x,y,z);
				Log("Scripter", errormsg);
				Msg(playerid, "Hiba történt hifikapcsolás közben, kérlek jelezd a Scripter topicban dátummal együtt!");
				return 0;
			}
			H_duration[h] = hossz;
			FormatSeconds(H_duration[h], hours, minutes, seconds);
			H_title[h] = cim;
			H_stream[h] = UnixTime+H_duration[h];
			H_playpos[h][0] = ButorInfo[SzerkesztesButor[playerid]][butorPosX];
			H_playpos[h][1] = ButorInfo[SzerkesztesButor[playerid]][butorPosY];
			H_playpos[h][2] = ButorInfo[SzerkesztesButor[playerid]][butorPosZ];
			SzerkesztesButor[playerid] = NINCS;
			foreach(Jatekosok, p)
			{
				if(Hazban(p, h))
				{
					if(Zsebradio[p] >= 1) Zsebradio[p] = 0;
					PlayAudioStreamForPlayer(p, stream, ArrExt(H_playpos[h]), 50, 1);
					if(!HifiZene[h]) SendFormatMessage(p, COLOR_YELLOW, "<< %s bekapcsolta a hifit! (YouTube) >>", ICPlayerName(playerid));
					else SendFormatMessage(p, COLOR_YELLOW, "<< %s zenét váltott! (YouTube) >>", ICPlayerName(playerid));
					SendFormatMessage(p, COLOR_YELLOW, "<< Zene adatok: Név: %s Hosszúság: %02d:%02d:%02d >>", H_title[h], hours, minutes, seconds);
					Hifirolhallgatzenet[p] = true;
				}
			}
			HifiZene[h] = true;
			Msg(playerid, "Hifi bekapcsolva!");
			return 1;
		}
		if(!isnull(MP4YT[playerid][yLink]) && YouTubeZeneRakas[playerid] == 3)
		{
			MP4YT[playerid][yHossz] = hossz;
			FormatSeconds(MP4YT[playerid][yHossz], hours, minutes, seconds);
			MP4YT[playerid][yNev] = cim;
			MP4YT[playerid][yLejatsszik] = 1;
			MP4YT[playerid][yMeddig] = UnixTime+MP4YT[playerid][yHossz];
			MP4YT[playerid][yLink] = stream;
			PlayAudioStreamForPlayer(playerid, MP4YT[playerid][yLink]);
			GameTextForPlayer(playerid, cim, 950, 5);
			Zsebradio[playerid] = 2;
		}
		if(IsAt(playerid, IsAt_Haz) && YouTubeZeneRakas[playerid] == 4)
		{
			new h = IsAt(playerid, IsAt_Haz), inputstr[32];
			Format(inputstr, "&n=%d&x=99999", floatround(floatabs(H_stream[h]-H_duration[h]-UnixTime)));
			strcat(stream, inputstr);
			PlayAudioStreamForPlayer(playerid, stream, ArrExt(H_playpos[h]), 150.0, 1);
			Hifirolhallgatzenet[playerid] = true;
			if(Zsebradio[playerid] >= 1) Zsebradio[playerid] = 0;
		}
	}
	else
	{
		new errormsg[128];
		SendFormatMessage(playerid, COLOR_LIGHTRED, "Hiba történt a zene betöltésekor(#%d) | Hibaüzenet: %s", response_code, GetError(response_code));
		Format(errormsg, "[HIFI HIBA] Játékos: %s hibakód: %d, üzenet: %s input: %s hol: OnYoutubeResponse", PlayerName(playerid), response_code, GetError(response_code), data);
		Log("Scripter", errormsg);
		return 0;
	}
	return 1;
}

/**	::				::
	:: 	 STOCKOK	::
	::				::	**/

stock PlayYoutubeForPlayerFromStart(playerid, url[], id)
{
	new get[128];
	format(get, 128, "youtubeinmp3.com/fetch/?format=text&video=%s", url);
	HTTP(playerid, HTTP_GET, get, "", "OnYoutubeResponse");
	YouTubeZeneRakas[playerid] = id;
	printf("%s", url);
}

stock PlayYoutubeForPlayer(playerid, url[])
{
	new get[128];
	format(get, 128, "youtubeinmp3.com/fetch/?format=text&video=%s", url);
	HTTP(playerid, HTTP_GET, get, "", "OnYoutubeResponse");
	YouTubeZeneRakas[playerid] = 4;
}

stock ContainsYoutubeURL(url[])
{
	if(strfind(url, "youtube.com", true) != NINCS && strfind(url, "watch?v=", true) != NINCS)
		return 1;
	else
		return 0;
}
 
stock GetError(val)
{
	new error[32];
	switch(val)
	{
		case 1: error = "Bad host";
		case 2: error = "No socket";
		case 3: error = "Can't connect";
		case 4: error = "Can't write";
		case 5: error = "Content too big";
		case 6: error = "Malformed response";
		case 300..308: error = "Redirection";
		case 400..499: error = "Client error";
		case 500..599: error = "Server error";
		default: error = "???";
	}
	return error;
}
 
stock FormatSeconds(seconds, &hours_left, &minutes_left, &seconds_left)
{
    hours_left = seconds/60/60;
    minutes_left = (seconds - hours_left*60*60)/60;
    seconds_left = (seconds - hours_left*60*60 - minutes_left*60);
}

/**	::				::
	:: 	 PARANCSOK	::
	::				::	**/

ALIAS(magn4):hifi;
ALIAS(magno):hifi;
CMD:hifi(playerid, params[])
{
	new p1[128], p2[128], h;
	if(!Hazbanvan[playerid]) return Msg(playerid, "Nem vagy egyetlen házban sem!");
	if(HazabanVan(playerid)) h = HazabanVan(playerid);
	else if(HazabanVan2(playerid)) h = HazabanVan2(playerid);
	else return Msg(playerid, "Hogy használhasd ezt a parancsot, a saját házadban kell lenned!");
	SzerkesztesButor[playerid] = NINCS;
	for(new b = 0; b < MAXBUTORSZAM; b++)
	{
		if(ButorInfo[b][butorVW] != h && !ButorInfo[b][butorHasznalva]) continue;
		if(ButorInfo[b][butorModel] != 2099 && ButorInfo[b][butorModel] != 2100 && ButorInfo[b][butorModel] != 2226 && ButorInfo[b][butorModel] != 1839 && ButorInfo[b][butorModel] != 1809 && ButorInfo[b][butorModel] != 2227 && ButorInfo[b][butorModel] != 2225) continue;
		if(!PlayerToPoint(3.0, playerid, ButorInfo[b][butorPosX], ButorInfo[b][butorPosY], ButorInfo[b][butorPosZ])) continue;
		SzerkesztesButor[playerid] = b;
		break;
	}
	if(SzerkesztesButor[playerid] == NINCS) return Msg(playerid, "Nem vagy hifilejátszó elõtt!");
	if(sscanf(params, "s[128] ", p1)) return Msg(playerid, "/hifi [rádió/youtube] [link] - kikapcsoláshoz: /hifi kikapcsol");
	if(egyezik(p1, "kikapcsol") || egyezik(p1, "off"))
	{
		foreach(Jatekosok, p)
		{
			if(Hazban(p, h))
			{
				StopAudioStreamForPlayer(p);
				Hifirolhallgatzenet[p] = false;
				SendFormatMessage(p, COLOR_YELLOW, "<< %s kikapcsolta a hifit! >>", ICPlayerName(playerid));
			}
		}
		HifiZene[h] = false;
		return 1;
	}
	
	if(egyezik(p1, "youtube") || egyezik(p1, "yt"))
	{
		if(sscanf(params, "{s[128] }s[128]", p2)) return Msg(playerid, "/hifi [rádió/youtube] [link] - kikapcsoláshoz: /hifi kikapcsol");
		if(strlen(p2) >= 128) return Msg(playerid, "Túl hosszú a link!");
		PlayYoutubeForPlayerFromStart(playerid, p2, HIFI);
		H_inputlink[h] = p2;
		Msg(playerid, "Kérlek vedd figyelembe, hogy lejátszáskor a magyar ékezetes betûk rosszul fognak megjelenni!");
	}
	else if(egyezik(p1, "rádió") || egyezik(p1, "radio"))
	{
		if(sscanf(params, "{s[128] }s[128]", p2)) return Msg(playerid, "/hifi [rádió/youtube] [link] - kikapcsoláshoz: /hifi kikapcsol");
		if(strlen(p2) >= 128) return Msg(playerid, "Túl hosszú a link!");
		foreach(Jatekosok, p)
		{
			if(Hazban(p, h))
			{
				PlayAudioStreamForPlayer(p, p2);
				if(HifiZene[h]) SendFormatMessage(p, COLOR_YELLOW, "<< %s bekapcsolta a hifit! (MP3) >>", ICPlayerName(playerid));
			}
		}
		Msg(playerid, "Hifi bekapcsolva!");
		print("Megy zene!");
	}
	else return Msg(playerid, "/hifi [rádió/youtube] [link] - kikapcsoláshoz: /hifi kikapcsol");
	return 1;
}

ALIAS(yt):youtube;
CMD:youtube(playerid, params[])
{
	if(!LMT(playerid, FRAKCIO_RIPORTER) && !Admin(playerid, 6))
		return SendClientMessage(playerid, COLOR_LIGHTRED, "[Hiba]: Te nem vagy Riporter vagy nincs elegendõ rangod!");
			
	if(!Munkarang(playerid, 1) && !Admin(playerid, 6))
		return SendClientMessage(playerid, COLOR_GREY, "Neked nem! (Minimum rang 1)");
				
	if(PlayerInfo[playerid][pNewsSkill] < 401 && !Admin(playerid, 6))
		return SendClientMessage(playerid, COLOR_GREY, "Nem vagy elég tapasztalt! (Minimum skill 5)");
		
	new urlcim[128];
	if(sscanf(params, "s[128]", urlcim))
		return Msg(playerid, "Használat: /youtube [Streamelhetõ Youtube URL cím (pl. https://www.youtube.com/watch?v=z7Bjasi12mE) | Kikapcsolás: /zeneki]");
	
	if(strlen(urlcim) >= 128)
		return Msg(playerid, "Túl hosszú a link!");
		
	if(!ContainsYoutubeURL(urlcim))
		return Msg(playerid, "Ez nem Youtube URL cím! Helyes használathoz példa: https://www.youtube.com/watch?v=z7Bjasi12mE | Kikapcsoláshoz használd a /zeneki parancsot");
	
	new newcar = GetPlayerVehicleID(playerid);
	new kocsi = GetClosestVehicle(playerid);
	if(GetVehicleModel(newcar) == 488 || GetVehicleModel(newcar) == 582 || PlayerToPoint(6, playerid, 1429.8469,-2448.7258,13.5629) || PlayerToPoint(2, playerid, -1821.3152,323.6341,-41.7493) || IsFrakcioKocsi(kocsi) == 9 || Admin(playerid, 6))
	{
		PlayYoutubeForPlayerFromStart(playerid, urlcim, RIPORTER);
		R_inputlink = urlcim;
	}
	else return Msg(playerid, "Nem vagy riporter jármû közelében vagy a bázison!");
	return 1;
}

CMD:zene(playerid, params[])
{
	if(!LMT(playerid, FRAKCIO_RIPORTER) && !Admin(playerid, 6))
		return SendClientMessage(playerid, COLOR_LIGHTRED, "[Hiba]: Te nem vagy Riporter vagy nincs elegendõ rangod!");
			
	if(!Munkarang(playerid, 1) && !Admin(playerid, 6))
		return SendClientMessage(playerid, COLOR_GREY, "Neked nem! (Minimum rang 1)");
				
	if(PlayerInfo[playerid][pNewsSkill] < 401 && !Admin(playerid, 6))
		return SendClientMessage(playerid, COLOR_GREY, "Nem vagy elég tapasztalt! (Minimum skill 5)");
		
	new urlcim[128];
	if(sscanf(params, "s[128]", urlcim))
		return Msg(playerid, "Használat: /zene [Streamelhetõ .mp3 vagy .pls URL cím | Kikapcsolás: /zeneki]");
	
	if(strlen(urlcim) >= 128)
		return Msg(playerid, "Túl hosszú a link!");
		
	new newcar = GetPlayerVehicleID(playerid);
	new kocsi = GetClosestVehicle(playerid);
	if(GetVehicleModel(newcar) == 488 || GetVehicleModel(newcar) == 582 || PlayerToPoint(6, playerid, 1429.8469,-2448.7258,13.5629) || PlayerToPoint(2, playerid, -1821.3152,323.6341,-41.7493) || IsFrakcioKocsi(kocsi) == 9 || Admin(playerid, 6))
	{
		RiporterZene = urlcim;
		RiporterZeneTipus = 0;
		foreach(Jatekosok, p)
		{
			if(PlayerInfo[p][pRadio] == 1 && Logged(p) && gNews[p] == 0 && Zsebradio[p] == 0 && RiobanVan{p} == 0 && !Hifirolhallgatzenet[p])
				PlayAudioStreamForPlayer(p, RiporterZene);
		}
		RiporterZeneVan = true;
		SendRadioMessageFormat(FRAKCIO_RIPORTER, COLOR_YELLOW, "<< %s bekapcsolta a zene streamelést! (MP3) >>", PlayerName(playerid));
		Msg(playerid, "Zene streamelés mindenkinél elindítva!");
	}
	else return Msg(playerid, "Nem vagy riporter jármû közelében vagy a bázison!");
	return 1;
}

CMD:zeneki(playerid, params[])
{
	if(!LMT(playerid, FRAKCIO_RIPORTER) && !Admin(playerid, 6))
		return SendClientMessage(playerid, COLOR_LIGHTRED, "[Hiba]: Te nem vagy Riporter vagy nincs elegendõ rangod!");
			
	if(!Munkarang(playerid, 1) && !Admin(playerid, 6))
		return SendClientMessage(playerid, COLOR_GREY, "Neked nem! (Minimum rang 1)");
				
	if(PlayerInfo[playerid][pNewsSkill] < 401 && !Admin(playerid, 6))
		return SendClientMessage(playerid, COLOR_GREY, "Nem vagy elég tapasztalt! (Minimum skill 5)");
	
	new newcar = GetPlayerVehicleID(playerid);
	new kocsi = GetClosestVehicle(playerid);
	if(GetVehicleModel(newcar) == 488 || GetVehicleModel(newcar) == 582 || PlayerToPoint(6, playerid, 1429.8469,-2448.7258,13.5629) || PlayerToPoint(2, playerid, -1821.3152,323.6341,-41.7493) || IsFrakcioKocsi(kocsi) == 9 || Admin(playerid, 6))
	{
		foreach(Jatekosok, p)
		{
			if(PlayerInfo[p][pRadio] == 1 && Logged(p) && gNews[p] == 0 && Zsebradio[p] == 0 && RiobanVan{p} == 0 && Hazbanvan[p] == 0 && !Hifirolhallgatzenet[p])
				StopAudioStreamForPlayer(p);
		}
		RiporterZeneVan = false;
	}
	else return Msg(playerid, "Nem vagy riporter jármû közelében vagy a bázison!");
	return 1;
}

ALIAS(zenec3m):zenecim;
CMD:zenecim(playerid, params[])
{
	if(!RiporterZeneVan) 
		return Msg(playerid, "Jelenleg nem játszanak le zenét a riporterek!");
		
	if(!RiporterZeneTipus)
		return Msg(playerid, "Jelenleg a riporterek nem a YouTube-n keresztül játszák le a zenét!");
		
	if(PlayerInfo[playerid][pTeloEgyenleg] < 25000) 
		return Msg(playerid, "Nem tudod kifizetni a zene adatainak lekérését!");
	
	new hours,minutes,seconds;
	FormatSeconds(R_duration, hours, minutes, seconds);
	
	tformat(256, "Köszönjük, hogy a CCN-t hallgatja!\n\nCím: %s\nHosszúság: %02d:%02d:%02d (%d másodperc)\nYoutube link: %s", R_title, hours, minutes, seconds, R_duration, R_inputlink);
	CustomDialog(playerid, D:zenecim, DIALOG_STYLE_MSGBOX, "Class City News", _tmpString, "Rendben", "");
	return 1;
}

/**	::				::
	:: 	  DIALOG	::
	::				::	**/

Dialog:zenecim(playerid, response, listitem, inputtext[])
{
	PlayerInfo[playerid][pTeloEgyenleg] -= 25000;
	FrakcioSzef(FRAKCIO_RIPORTER, 25000, 35);
	SendClientMessage(playerid, COLOR_ORANGE, "CCN - Mert a zene érted szól!");
	return 1;
}