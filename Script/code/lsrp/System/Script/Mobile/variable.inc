#define loop(%0,%1,%2) for(new %2 = %0; %2 < %1; %2++)

new Text:TD_iPhone[26];
new Text:TD_iPhone_Clock[2];
new Text:TD_iPhone_Gallery;
new Text:TD_iPhone_Time[3];
new PlayerText:PTD_iPhone_Gallery[MAX_PLAYERS];
new PlayerText:PTD_iPhone[37][MAX_PLAYERS];
new Text:TD_iPhone_GPS;
new PlayerText:PTD_iPhone_GPS[MAX_PLAYERS];
new Text:TD_iPhone_Radio[2];
new Text:TD_iPhone_Music[2];
new Text:TD_iPhone_Map;
new Text:TD_iPhone_Internet[2];
new Text:TD_iPhone_Calculator[16];
new PlayerText:PTD_iPhone_Calculator[MAX_PLAYERS];
new Text:TD_iPhone_Call[13];
new PlayerText:PTD_iPhone_Call[MAX_PLAYERS];
new Text:TD_iPhone_CallYesNo[2];

new var1[MAX_PLAYERS][11];
new var2[MAX_PLAYERS][11];
new called[MAX_PLAYERS][11];
new callto[MAX_PLAYERS];

new firstperson[MAX_PLAYERS];
new iPhone_CC[4][MAX_PLAYERS];
new iPhoneStatus[MAX_PLAYERS];
new iPhoneCallStatus[MAX_PLAYERS];
new MenuX[MAX_PLAYERS];
new MenuY[MAX_PLAYERS];
new UpdateIPHONETimer;

new Gallery[][] =
{
        "loadsc1:loadsc1",
        "loadsc2:loadsc2",
        "loadsc3:loadsc3",
        "loadsc4:loadsc4",
        "loadsc5:loadsc5",
        "loadsc6:loadsc6",
        "loadsc7:loadsc7",
        "loadsc8:loadsc8",
        "loadsc9:loadsc9",
        "loadsc10:loadsc10",
        "loadsc11:loadsc11",
        "loadsc12:loadsc12",
        "loadsc13:loadsc13",
        "loadsc14:loadsc14"
        
};

new Radio[][] =
{
        "http://somafm.com/tags.pls",
		"http://bbc.co.uk/radio/listen/live/r1.asx",
		"http://www.listenlive.eu/cadenacope.m3u",
		"http://onair-ha1.krone.at/kronehit-dance.mp3.m3u",
		"http://www.m2radio.fr/pls/m2club.m3u",
		"http://mp3.kataweb.it:8000/M2O.m3u",
		"http://www.listenlive.eu/vrtklara-low.m3u",
		"http://icecast4.play.cz/evropa2-64.mp3.m3u",
		"http://broadcast.infomaniak.net/nrj-low.mp3.m3u"

};

new Music[][] =
{
        "https://dl.dropboxusercontent.com/s/nqxrnokp4zspsw5/Basto%20-%20Again%20and%20Again%20%28Original%20Mix%29.mp3",
		"https://dl.dropboxusercontent.com/s/ln10micl32ys6yj/Blasterjaxx%20%26amp%3B%20Badd%20Dimes%20-%20Titan%20%28Original%20Mix%29.mp3",
		"https://dl.dropboxusercontent.com/s/pj21s5kz5ad5k3d/DVBBS%20%26amp%3B%20Tony%20Junior%20-%20Immortal%20%28Original%20Mix%29.mp3",
		"https://dl.dropboxusercontent.com/s/g1iuqoot6z7qfn7/Martin%20Garrix%20-%20Proxy%20%28FREE%20DOWNLOAD%29.mp3",
		"https://dl.dropboxusercontent.com/s/68htnt08uzgceqr/Martin%20Garrix%20-%20Animals%20%28Original%20Mix%29.mp3",
		"https://dl.dropboxusercontent.com/s/nvzyebx9ydow2ow/Starkillers%20%26%20DJ%20BL3ND%20-%20Xception%20%28Official%20Music%20Video%29.mp3",
		"https://dl.dropboxusercontent.com/s/0iof8iei1qxdc4f/Starkillers%20%26amp%3B%20Inpetto%20-%20Game%20Over%20%28Original%20Mix%29.mp3"

};

enum zoneinfo
{
	zone_name[32],
    Float:zone_minx,
    Float:zone_miny,
    Float:zone_minz,
    Float:zone_maxx,
    Float:zone_maxy,
    Float:zone_maxz
}
new zones[][zoneinfo] = {
{ "Los Santos",                     44.60, -2892.90,  -242.90,  2997.00,  -768.00,   900.00},
{ "Las Venturas",                  869.40,   596.30,  -242.90,  2997.00,  2993.80,   900.00},
{ "Bone County",                  -480.50,   596.30,  -242.90,   869.40,  2993.80,   900.00},
{ "Tierra Robada",               -2997.40,  1659.60,  -242.90,  -480.50,  2993.80,   900.00},
{ "Tierra Robada",               -1213.90,   596.30,  -242.90,  -480.50,  1659.60,   900.00},
{ "San Fierro",                  -2997.40, -1115.50,  -242.90, -1213.90,  1659.60,   900.00},
{ "Red County",                  -1213.90,  -768.00,  -242.90,  2997.00,   596.30,   900.00},
{ "Flint County",                -1213.90, -2892.90,  -242.90,    44.60,  -768.00,   900.00},
{ "Whetstone",                   -2997.40, -2892.90,  -242.90, -1213.90, -1115.50,   900.00}
};

forward UpdateIphone();