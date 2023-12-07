#if defined __game_system_system_tuning
	#endinput
#endif
#define __game_system_system_tuning

/**	::				::
	:: 	DEFIN�CI�K	::
	::				::	**/

#define D_TUNING_ALAP 				1
#define D_TUNING_FESTES				201
#define D_TUNING_FESTES_MEG			2011
#define D_TUNING_RIASZTO			202
#define D_TUNING_RIASZTO_MEG		2021
#define D_TUNING_NEON				203
#define D_TUNING_NEON_MEG			2031
#define D_TUNING_HIDRAULIKA			204
#define D_TUNING_HIDRAULIKA_MEG		2041
#define D_TUNING_DETEKTOR			205
#define D_TUNING_DETEKTOR_MEG		2051
#define D_TUNING_FELNI				206
#define D_TUNING_FELNI_MEG			2061
#define D_TUNING_MATRICA			207
#define D_TUNING_MATRICA_MEG		2071
#define D_TUNING_TUNINGPACK			208
#define D_TUNING_TUNINGPACK_MEG		2081
#define D_TUNING_EGYEB				209
#define D_TUNING_EGYEB_LE			2091
#define D_TUNING_EGYEB_MEG			2092
#define D_TUNING_MEGEROSIT			3
#define MAXTUNING 					14
#define UNUSED						999

/**	::				::
	::	 V�LTOZ�K	::
	::				::	**/

new D_Tuning[MAX_PLAYERS], D_Festes[MAX_PLAYERS][2], D_Tuning_SelectedItem[MAX_PLAYERS], D_Tuning_ItemCost[MAX_PLAYERS], D_Egyeb_Lista[MAX_PLAYERS][22], D_Egyeb_ListaItem[MAX_PLAYERS], bool:D_AdminTuning[MAX_PLAYERS];

new legalmods[48][22] = {
    {400, 1024,1021,1020,1019,1018,1013,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
    {401, 1145,1144,1143,1142,1020,1019,1017,1013,1007,1006,1005,1004,1003,1001,0000,0000,0000,0000},
    {404, 1021,1020,1019,1017,1016,1013,1007,1002,1000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
    {405, 1023,1021,1020,1019,1018,1014,1001,1000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
    {410, 1024,1023,1021,1020,1019,1017,1013,1007,1003,1001,0000,0000,0000,0000,0000,0000,0000,0000},
    {415, 1023,1019,1018,1017,1007,1003,1001,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
    {418, 1021,1020,1016,1006,1002,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
    {420, 1021,1019,1005,1004,1003,1001,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
    {421, 1023,1021,1020,1019,1018,1016,1014,1000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
    {422, 1021,1020,1019,1017,1013,1007,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
    {426, 1021,1019,1006,1005,1004,1003,1001,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
    {436, 1022,1021,1020,1019,1017,1013,1007,1006,1003,1001,0000,0000,0000,0000,0000,0000,0000,0000},
    {439, 1145,1144,1143,1142,1023,1017,1013,1007,1003,1001,0000,0000,0000,0000,0000,0000,0000,0000},
    {477, 1021,1020,1019,1018,1017,1007,1006,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
    {478, 1024,1022,1021,1020,1013,1012,1005,1004,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
    {489, 1024,1020,1019,1018,1016,1013,1006,1005,1004,1002,1000,0000,0000,0000,0000,0000,0000,0000},
    {491, 1145,1144,1143,1142,1023,1021,1020,1019,1018,1017,1014,1007,1003,0000,0000,0000,0000,0000},
    {492, 1016,1006,1005,1004,1000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
    {496, 1143,1142,1023,1020,1019,1017,1011,1007,1006,1003,1002,1001,0000,0000,0000,0000,0000,0000},
    {500, 1024,1021,1020,1019,1013,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
    {516, 1021,1020,1019,1018,1017,1016,1015,1007,1004,1002,1000,0000,0000,0000,0000,0000,0000,0000},
    {517, 1145,1144,1143,1142,1023,1020,1019,1018,1017,1016,1007,1003,1002,0000,0000,0000,0000,0000},
    {518, 1145,1144,1143,1142,1023,1020,1018,1017,1013,1007,1006,1005,1003,1001,0000,0000,0000,0000},
    {527, 1021,1020,1018,1017,1015,1014,1007,1001,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
    {529, 1023,1020,1019,1018,1017,1012,1011,1007,1006,1003,1001,0000,0000,0000,0000,0000,0000,0000},
    {534, 1185,1180,1179,1178,1127,1126,1125,1124,1123,1122,1106,1101,1100,0000,0000,0000,0000,0000},
    {535, 1121,1120,1119,1118,1117,1116,1115,1114,1113,1110,1109,0000,0000,0000,0000,0000,0000,0000},
    {536, 1184,1183,1182,1181,1128,1108,1107,1105,1104,1103,0000,0000,0000,0000,0000,0000,0000,0000},
    {540, 1145,1144,1143,1142,1024,1023,1020,1019,1018,1017,1007,1006,1004,1001,0000,0000,0000,0000},
    {542, 1145,1144,1021,1020,1019,1018,1015,1014,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
    {546, 1145,1144,1143,1142,1024,1023,1019,1018,1017,1007,1006,1004,1002,1001,0000,0000,0000,0000},
    {547, 1143,1142,1021,1020,1019,1018,1016,1003,1000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
    {549, 1145,1144,1143,1142,1023,1020,1019,1018,1017,1012,1011,1007,1003,1001,0000,0000,0000,0000},
    {550, 1145,1144,1143,1142,1023,1020,1019,1018,1006,1005,1004,1003,1001,0000,0000,0000,0000,0000},
    {551, 1023,1021,1020,1019,1018,1016,1006,1005,1003,1002,0000,0000,0000,0000,0000,0000,0000,0000},
    {558, 1168,1167,1166,1165,1164,1163,1095,1094,1093,1092,1091,1090,1089,1088,0000,0000,0000,0000},
    {559, 1173,1162,1161,1160,1159,1158,1072,1071,1070,1069,1068,1067,1066,1065,0000,0000,0000,0000},
    {560, 1170,1169,1141,1140,1139,1138,1033,1032,1031,1030,1029,1028,1027,1026,0000,0000,0000,0000},
    {561, 1157,1156,1155,1154,1064,1063,1062,1061,1060,1059,1058,1057,1056,1055,1031,1030,1027,1026},
    {562, 1172,1171,1149,1148,1147,1146,1041,1040,1039,1038,1037,1036,1035,1034,0000,0000,0000,0000},
    {565, 1153,1152,1151,1150,1054,1053,1052,1051,1050,1049,1048,1047,1046,1045,0000,0000,0000,0000},
    {567, 1189,1188,1187,1186,1133,1132,1131,1130,1129,1102,0000,0000,0000,0000,0000,0000,0000,0000},
    {575, 1177,1176,1175,1174,1099,1044,1043,1042,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
    {576, 1193,1192,1191,1190,1137,1136,1135,1134,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
    {580, 1023,1020,1018,1017,1007,1006,1001,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000,0000},
    {589, 1145,1144,1024,1020,1018,1017,1016,1013,1007,1006,1005,1004,1000,0000,0000,0000,0000,0000},
    {600, 1022,1020,1018,1017,1013,1007,1006,1005,1004,0000,0000,0000,0000,0000,0000,0000,0000,0000},
    {603, 1145,1144,1143,1142,1024,1023,1020,1019,1018,1017,1007,1006,1001,0000,0000,0000,0000,0000}
};

enum tuninglista
{
	tID,
	tNev[96]
}
new TuningComponent[194][tuninglista] =
{
	{1000,"1000 - Pro Spoiler"},
	{1001,"1001 - Win Spoiler"},
	{1002,"1002 - Drag Spoiler"},
	{1003,"1003 - Alpha Spoiler"},
	{1004,"1004 - Champ Motorh�ztet�"},
	{1005,"1005 - Fury Motorh�ztet�"},
	{1006,"1006- Tet�szell�z�"},
	{1007,"1007 - Jobb oldalszoknya"},
	{1008,"1008 - 5xNitro (tiltott)"},
	{1009,"1009 - 2xNitro (tiltott)"},
	{1010,"1010 - 10xNitro (tiltott)"},
	{1011,"1011 - Race Motorh�ztet�"},
	{1012,"1012 - Worx Motorh�ztet�"},
	{1013,"1013 - K�r alak� k�dl�mpa"},
	{1014,"1014 - Champ Spoiler"},
	{1015,"1015 - Race Spoiler"},
	{1016,"1016 - Worx Spoiler"},
	{1017,"1017 - Bal oldalszoknya"},
	{1018,"1018 - �velt kipufog�"},
	{1019,"1019 - Dupla kipufog�"},
	{1020,"1020 - Nagy kipufog�"},
	{1021,"1021 - K�zepes kipufog�"},
	{1022,"1022 - Kicsi kipufog�"},
	{1023,"1023 - Fury Spoiler"},
	{1024,"1024 - N�gyzetes k�dl�mpa"},
	{1025,"1025 - Offroad ker�k"},
	{1026,"1026 - Jobb Alien oldalszoknya"},
	{1027,"1027 - Bal Alien oldalszoknya"},
	{1028,"1028 - Alien kipufog�"},
	{1029,"1029 - X-Flow kipufog�"},
	{1030,"1030 - Bal X-Flow oldalszoknya"},
	{1031,"1031 - Jobb X-Flow oldalszoknya"},
	{1032,"1032 - Alien Tet�szell�z�"},
	{1033,"1033 - X-Flow Tet�szell�z�"},
	{1034,"1034 - Alien kipufog�"},
	{1035,"1035 - X-Flow tet�szell�z�"},
	{1036,"1036 - Jobb Alien oldalszoknya"},
	{1037,"1037 - X-Flow kipufog�"},
	{1038,"1038 - Alien tet�szell�z�"},
	{1039,"1039 - Bal X-Flow oldalszoknya"},
	{1040,"1040 - Jobb X-Flow oldalszoknya"},
	{1041,"1041 - Jobb X-Flow oldalszoknya"},
	{1042,"1042 - Jobb Chrome oldalszoknya"},
	{1043,"1043 - Slamin kipufog�"},
	{1044,"1044 - Chrome kipufog�"},
	{1045,"1045 - X-Flow kipufog�"},
	{1046,"1046 - Alien kipufog�"},
	{1047,"1047 - Jobb Alien oldalszoknya"},
	{1048,"1048 - Jobb X-Flow oldalszoknya"},
	{1049,"1049 - Alien spoiler"},
	{1050,"1050 - X-Flow spoiler"},
	{1051,"1051 - Bal Alien oldalszoknya"},
	{1052,"1052 - Bal X-Flow oldalszoknya"},
	{1053,"1053 - X-Flow tet�szell�z�"},
	{1054,"1054 - Alien tet�szell�z�"},
	{1055,"1055 - Alien tet�szell�z�"},
	{1056,"1056 - Jobb Alien oldalszoknya"},
	{1057,"1057 - Jobb X-Flow oldalszoknya"},
	{1058,"1058 - Alien spoiler"},
	{1059,"1059 - X-Flow kipufog�"},
	{1060,"1060 - X-Flow spoiler"},
	{1061,"1061 - X-Flow tet�szell�z�"},
	{1062,"1062 - Bal Alien oldalszoknya"},
	{1063,"1063 - Bal X-Flow oldalszoknya"},
	{1064,"1064 - Alien kipufog�"},
	{1065,"1065 - Alien kipufog�"},
	{1066,"1066 - X-Flow kipufog�"},
	{1067,"1067 - Alien tet�szell�z�"},
	{1068,"1068 - X-Flow tet�szell�z�"},
	{1069,"1069 - Jobb Alien oldalszoknya"},
	{1070,"1070 - Jobb X-Flow oldalszoknya"},
	{1071,"1071 - Bal Alien oldalszoknya"},
	{1072,"1072 - Bal X-Flow oldalszoknya"},
	{1073,"1073 - Shadow felni"},
	{1074,"1074 - Mega felni"},
	{1075,"1075 - Rimshine felni"},
	{1076,"1076 - Wires felni"},
	{1077,"1077 - Classic felni"},
	{1078,"1078 - Twist felni"},
	{1079,"1079 - Cutter felni"},
	{1080,"1080 - Switch felni"},
	{1081,"1081 - Grove felni"},
	{1082,"1082 - Import felni"},
	{1083,"1083 - Dollar felni"},
	{1084,"1084 - Trance felni"},
	{1085,"1085 - Atomic Felni"},
	{1086,"1086 - Sztere� (tiltott)"},
	{1087,"1087 - Hidraulika (tiltott)"},
	{1088,"1088 - Alien tet�szell�z�"},
	{1089,"1089 - X-Flow kipufog�"},
	{1090,"1090 - Jobb Alien oldalszoknya"},
	{1091,"1091 - X-Flow tet�szell�z�"},
	{1092,"1092 - Alien kipufog�"},
	{1093,"1093 - Bal X-Flow oldalszoknya"},
	{1094,"1094 - Bal Alien oldalszoknya"},
	{1095,"1095 - Jobb X-Flow oldalszoknya"},
	{1096,"1096 - Ahab felni"},
	{1097,"1097 - Virtual felni"},
	{1098,"1098 - Access felni"},
	{1099,"1099 - Bal Chrome oldalszoknya"},
	{1100,"1100 - Chrome Grill d�sz"},
	{1101,"1101 - Bal Chrome Flames oldalszoknya"},
	{1102,"1102 - Bal Chrome Strip oldalszoknya"},
	{1103,"1103 - Covertible tet�szell�z�"},
	{1104,"1104 - Chrome kipufog�"},
	{1105,"1105 - Slamin kipufog�"},
	{1106,"1106 - Jobb Chrome Arches oldalszoknya"},
	{1107,"1107 - Bal Chrome Strip oldalszoknya"},
	{1108,"1108 - Jobb Chrome Strip oldalszoknya"},
	{1109,"1109 - Chrome h�ts� d�sz"},
	{1110,"1110 - Slamin h�ts� d�sz"},
	{1111,"1111 - ??? (tiltott)"},
	{1112,"1112 - ??? (tiltott)"},
	{1113,"1113 - Chrome kipufog�"},
	{1114,"1114 - Slamin kipufog�"},
	{1115,"1115 - Chrome d�sz"},
	{1116,"1116 - Slamin d�sz"},
	{1117,"1117 - Chrome el�ls� l�kh�r�t�"},
	{1118,"1118 - Jobb Chrome Trim oldalszoknya"},
	{1119,"1119 - Jobb Wheelcovers oldalszoknya"},
	{1120,"1120 - Bal Chrome Trim oldalszoknya"},
	{1121,"1121 - Bal Wheelcovers oldalszoknya"},
	{1122,"1122 - Jobb Chrome Flames oldalszoknya"},
	{1123,"1123 - Chrome d�sz"},
	{1124,"1124 - Bal Chrome Arches oldalszoknya"},
	{1125,"1125 - Chrome l�mpad�sz"},
	{1126,"1126 - Chrome kipufog�"},
	{1127,"1127 - Slamin kipufog�"},
	{1128,"1128 - Vinyl kem�ny tet�szell�z�"},
	{1129,"1129 - Chrome kipufog�"},
	{1130,"1130 - Kem�ny tet�szell�z�"},
	{1131,"1131 - Puha tet�szell�z�"},
	{1132,"1132 - Slamin kipufog�"},
	{1133,"1133 - Jobb Chrome Strip oldalszoknya"},
	{1134,"1134 - Jobb Chrome Strip oldalszoknya"},
	{1135,"1135 - Slamin kipufog�"},
	{1136,"1136 - Chrome kipufog�"},
	{1137,"1137 - Bal Chrome Strip oldalszoknya"},
	{1138,"1138 - Alien spoiler"},
	{1139,"1139 - X-Flow spoiler"},
	{1140,"1140 - X-Flow h�ts� l�kh�r�t�"},
	{1141,"1141 - Alien h�ts� l�kh�r�t�"},
	{1142,"1142 - Bal ov�lis szell�z�ny�l�s"},
	{1143,"1143 - Jobb ov�lis szell�z�ny�l�s"},
	{1144,"1144 - Bal sz�gletes szell�z�ny�l�s"},
	{1145,"1145 - Jobb sz�gletes szell�z�ny�l�s"},
	{1146,"1146 - X-Flow spoiler"},
	{1147,"1147 - Alien spoiler"},
	{1148,"1148 - X-Flow h�ts� l�kh�r�t�"},
	{1149,"1149 - Alien h�ts� l�kh�r�t�"},
	{1150,"1150 - Alien h�ts� l�kh�r�t�"},
	{1151,"1151 - X-Flow h�ts� l�kh�r�t�"},
	{1152,"1152 - X-Flow el�ls� l�kh�r�t�"},
	{1153,"1153 - Alien el�ls� l�kh�r�t�"},
	{1154,"1154 - Alien h�ts� l�kh�r�t�"},
	{1155,"1155 - Alien el�ls� l�kh�r�t�"},
	{1156,"1156 - X-Flow h�ts� l�kh�r�t�"},
	{1157,"1157 - X-Flow el�ls� l�kh�r�t�"},
	{1158,"1158 - X-Flow spoiler"},
	{1159,"1159 - Alien h�ts� l�kh�r�t�"},
	{1160,"1160 - Alien el�ls� l�kh�r�t�"},
	{1161,"1161 - X-Flow h�ts� l�kh�r�t�"},
	{1162,"1162 - Alien spoiler"},
	{1163,"1163 - X-Flow spoiler"},
	{1164,"1164 - Alien spoiler"},
	{1165,"1165 - X-Flow el�ls� l�kh�r�t�"},
	{1166,"1166 - Alien el�ls� l�kh�r�t�"},
	{1167,"1167 - X-Flow h�ts� l�kh�r�t�"},
	{1168,"1168 - Alien h�ts� l�kh�r�t�"},
	{1169,"1169 - Alien el�ls� l�kh�r�t�"},
	{1170,"1170 - X-Flow el�ls� l�kh�r�t�"},
	{1171,"1171 - Alien el�ls� l�kh�r�t�"},
	{1172,"1172 - X-Flow el�ls� l�kh�r�t�"},
	{1173,"1173 - X-Flow el�ls� l�kh�r�t�"},
	{1174,"1174 - Chrome el�ls� l�kh�r�t�"},
	{1175,"1175 - Slamin h�ts� l�kh�r�t�"},
	{1176,"1176 - Chrome el�ls� l�kh�r�t�"},
	{1177,"1177 - Slamin h�ts� l�kh�r�t�"},
	{1178,"1178 - Slamin h�ts� l�kh�r�t�"},
	{1179,"1179 - Chrome el�ls� l�kh�r�t�"},
	{1180,"1180 - Chrome h�ts� l�kh�r�t�"},
	{1181,"1181 - Slamin el�ls� l�kh�r�t�"},
	{1182,"1182 - Chrome el�ls� l�kh�r�t�"},
	{1183,"1183 - Slamin h�ts� l�kh��rt�"},
	{1184,"1184 - Chrome h�ts� l�kh�r�t�"},
	{1185,"1185 - Slamin el�ls� l�kh�r�t�"},
	{1186,"1186 - Slamin h�ts� l�kh�r�t�"},
	{1187,"1187 - Chrome h�ts� l�kh�r�t�"},
	{1188,"1188 - Slamin el�ls� l�kh�r�t�"},
	{1189,"1189 - Chrome el�ls� l�kh�r�t�"},
	{1190,"1190 - Slamin el�ls� l�kh�r�t�"},
	{1191,"1191 - Chrome el�ls� l�kh�r�t�"},
	{1192,"1192 - Chrome h�ts� l�kh�r�t�"},
	{1193,"1193 - Slamin h�ts� l�kh�r�t�"}
};

/**	::			::
	:: 	STOCK	::
	::			::	**/

stock ResetTuningVariables(playerid)
{
	D_Tuning[playerid] = D_TUNING_ALAP;
	D_Festes[playerid][0] = UNUSED;
	D_Festes[playerid][1] = UNUSED;
	D_Tuning_SelectedItem[playerid] = UNUSED;
	D_Tuning_ItemCost[playerid] = 0;
	D_Egyeb_ListaItem[playerid] = UNUSED;
	for(new i = 0; i < 21; i++) D_Egyeb_Lista[playerid][i] = UNUSED;
}

stock bool:IsALocoLowCoCar(vehicleid)
{
	new model = GetVehicleModel(vehicleid);
	new validcars[8] = { 536, 575, 534, 567, 535, 566, 576, 412 };
	
	for(new num = 0; num < sizeof(validcars); num++)
	{
		if(validcars[num] == model)
			return true;
	}		
	return false;
}

stock bool:IsAWheelArchAngelCar(vehicleid)
{
	new model = GetVehicleModel(vehicleid);
	new validcars[6] = { 562, 565, 559, 561, 560, 558 };
	
	for(new num = 0; num < sizeof(validcars); num++)
	{
		if(validcars[num] == model)
			return true;
	}		
	return false;
}



/**	::			::
	:: 	DIALOG	::
	::			::	**/
	
ShowVehicleEditor(playerid)
{
	new lista[750], elsosor, vehicle = GetPlayerVehicleID(playerid), modelid = GetVehicleModel(vehicle), vs = IsAVsKocsi(vehicle);
	switch(D_Tuning[playerid])
	{
		case D_TUNING_ALAP:					CustomDialog(playerid, D:tuning, DIALOG_STYLE_LIST, "Tuningol�s", "J�rm� �tfest�se\nRiaszt� felszerel�se\nNeon felszerel�se\nHidraulika felszerel�se\nDetektor felszerel�se\nFelni felszerel�se\nMatrica felragaszt�sa\nKomplett tuningpackok felszerel�se\nEgy�b komponensek felszerel�se\nEgy�b komponensek leszerel�se", "Kiv�laszt", "M�gse");
		case D_TUNING_FESTES: 			{	tformat(256, "A j�rm�ved �j sz�neit a k�vetkez� form�tumban kell megadni:\nEls� sz�n,M�sodik sz�n\nPl.: 76,132\n\nJelenlegi sz�nek:\n%d,%d", CarInfo[vs][cColorOne], CarInfo[vs][cColorTwo]); CustomDialog(playerid, D:tuning, DIALOG_STYLE_INPUT, "J�rm� �tfest�se", _tmpString, "�tfest�s", "M�gse"); }
		case D_TUNING_FESTES_MEG:			CustomDialog(playerid, D:tuning, DIALOG_STYLE_MSGBOX, "�tfest�s meger�s�t�se", "Vess egy pillant�st a j�rm�vedre, �gy n�zne ki az �j sz�nekkel!\nVal�ban �t szeretn�d f�jatni a j�rm�vet?\nA m�velet 150.000 Ft-ba fog ker�lni!", "Meger�s�t�s", "M�gse");
		case D_TUNING_RIASZTO:				CustomDialog(playerid, D:tuning, DIALOG_STYLE_LIST, "Riaszt� kiv�laszt�sa", "0. szint� riaszt� (leszerel�s)\n1. szint� riaszt� (Csak dud�l - 100.000FT)\n2. szint� riaszt� (Dud�l �s jelez a tulajnak - 300.000FT)\n3. szint� riaszt� (Dud�l, jelez a tulajnak �s a rend�rs�gnek - 500.000FT)\n4. szint� riaszt� (G�tolja a kocsi ind�t�s�t, lop�sbiztos - 2.000.000FT)", "Kiv�laszt", "M�gse");
		case D_TUNING_RIASZTO_MEG:		{	tformat(256, "Val�ban fel szeretn�d szerelni a j�rm�re a k�vetkez�t: Riaszt�?\nA m�velet %s forintba fog ker�lni!", FormatInt(D_Tuning_ItemCost[playerid])); CustomDialog(playerid, D:tuning, DIALOG_STYLE_MSGBOX, "Meger�s�t�s", _tmpString, "Meger�s�t�s", "M�gse"); PlayerPlaySound(playerid,1133,0.0,0.0,0.0); }
		case D_TUNING_NEON:					CustomDialog(playerid, D:tuning, DIALOG_STYLE_LIST, "Neon kiv�laszt�sa", "Leszerel�s\nK�k\nPiros\nR�zsasz�n\nFeh�r\nZ�ld\nS�rga", "Kiv�laszt", "M�gse");
		case D_TUNING_NEON_MEG: 		{	tformat(256, "Vess egy pillant�st a j�rm�vedre, �gy n�zne ki, ha felszereln�d a tuning cuccot!\nVal�ban fel szeretn�d szerelni a j�rm�re a k�vetkez�t: Neon?\nA m�velet %s forintba fog ker�lni!", FormatInt(D_Tuning_ItemCost[playerid])); CustomDialog(playerid, D:tuning, DIALOG_STYLE_MSGBOX, "Kin�zet", _tmpString, "Meger�s�t�s", "M�gse"); PlayerPlaySound(playerid,1133,0.0,0.0,0.0); }
		case D_TUNING_HIDRAULIKA: 		{   tformat(256, "Val�ban felszeretn�d szerelni a hidraulik�t a j�rm�vedre?\nA m�velet %s Ft-ba fog ker�lni!", FormatInt(D_Tuning_ItemCost[playerid])); CustomDialog(playerid, D:tuning, DIALOG_STYLE_MSGBOX, "Hidraulika felszerel�se", _tmpString, "Meger�s�t�s", "M�gse"); }
		case D_TUNING_HIDRAULIKA_MEG:	{	tformat(256, "K�sz�nj�k a v�s�rl�st!\n\nFizetett �sszeg: %s Ft", FormatInt(D_Tuning_ItemCost[playerid])); CustomDialog(playerid, D:tuning, DIALOG_STYLE_MSGBOX, "Nyugta", _tmpString, "Rendben", ""); PlayerPlaySound(playerid,1054,0.0,0.0,0.0); }
		case D_TUNING_DETEKTOR:				CustomDialog(playerid, D:tuning, DIALOG_STYLE_LIST, "Detektor kiv�laszt�sa", "0. szint� detektor (leszerel�s)\n1. szint� detektor (Csak blokkolja a bem�r�st - 5.000.000 Ft)\n2. szint� detektor (Csak bejelez a vezet�nek, ha 100 m�teres k�rzetben traffipax tal�lhat� - 7.500.000 Ft)\n3. szint� detektor (Bejelez a vezet�nek, ha 100 m�teres k�rzetben traffipax tal�lhat� �s blokkolja a bem�r�st - 10.000.000 Ft)", "Kiv�laszt", "M�gse");
		case D_TUNING_DETEKTOR_MEG:		{	tformat(256, "Val�ban fel szeretn�d szerelni a j�rm�re a k�vetkez�t: Detektor?\nA m�velet %s forintba fog ker�lni!", FormatInt(D_Tuning_ItemCost[playerid])); CustomDialog(playerid, D:tuning, DIALOG_STYLE_MSGBOX, "Kin�zet", _tmpString, "Meger�s�t�s", "M�gse"); PlayerPlaySound(playerid,1133,0.0,0.0,0.0); }
		case D_TUNING_FELNI:				CustomDialog(playerid, D:tuning, DIALOG_STYLE_LIST, "Felni felszerel�se", "Leszerel�s\nOffroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar", "Kiv�laszt", "M�gse");
		case D_TUNING_FELNI_MEG: 		{	tformat(256, "Vess egy pillant�st a j�rm�vedre, �gy n�zne ki, ha felszereln�d a tuning cuccot!\nVal�ban fel szeretn�d szerelni a j�rm�re a k�vetkez�t: Felni?\nA m�velet %s forintba fog ker�lni!", FormatInt(D_Tuning_ItemCost[playerid])); CustomDialog(playerid, D:tuning, DIALOG_STYLE_MSGBOX, "Kin�zet", _tmpString, "Meger�s�t�s", "M�gse"); PlayerPlaySound(playerid,1133,0.0,0.0,0.0); }
		case D_TUNING_MATRICA:				CustomDialog(playerid, D:tuning, DIALOG_STYLE_LIST, "Matrica felragaszt�sa", "1. st�lus\n2. st�lus\n3. st�lus\nLeszed�s", "Meger�s�t�s", "M�gse");
		case D_TUNING_MATRICA_MEG:		{	tformat(256, "Vess egy pillant�st a j�rm�vedre, �gy n�zne ki, ha felszereln�d a tuning cuccot!\nVal�ban fel szeretn�d szerelni a j�rm�re a k�vetkez�t: Matrica?\nA m�velet %s forintba fog ker�lni!", FormatInt(D_Tuning_ItemCost[playerid])); CustomDialog(playerid, D:tuning, DIALOG_STYLE_MSGBOX, "Kin�zet", _tmpString, "Meger�s�t�s", "M�gse"); PlayerPlaySound(playerid,1133,0.0,0.0,0.0); }
		case D_TUNING_TUNINGPACK:			CustomDialog(playerid, D:tuning, DIALOG_STYLE_LIST, "Tuningpack felszerel�se", "Leszed�s\nAlien\nX-Flow", "Meger�s�t�s", "M�gse");
		case D_TUNING_TUNINGPACK_MEG:	{	tformat(256, "Vess egy pillant�st a j�rm�vedre, �gy n�zne ki, ha felszereln�d a tuning cuccot!\nVal�ban fel szeretn�d szerelni a j�rm�re a k�vetkez�t: Tuningpack?\nA m�velet %s forintba fog ker�lni!\n\nFigyelem! A m�velet ut�n minden m�s egyedi tuningkomponenst nem rakhatsz a kocsira!", FormatInt(D_Tuning_ItemCost[playerid])); CustomDialog(playerid, D:tuning, DIALOG_STYLE_MSGBOX, "Kin�zet", _tmpString, "Meger�s�t�s", "M�gse"); PlayerPlaySound(playerid,1133,0.0,0.0,0.0); }
		case D_TUNING_EGYEB:			{ 		
											new count;
											for(new i = 0; i < 47; i++)
											{
												if(legalmods[i][0] == modelid)
												{
													for(new x = 1; x < 22; x++)
													{
														if(legalmods[i][x] == 0000) continue;
														for(new z = 0; z < sizeof(TuningComponent); z++)
														{
															if(legalmods[i][x] != TuningComponent[z][tID]) continue;
															if(elsosor == 0) format(lista, 750, "%s", TuningComponent[z][tNev]);
															else format(lista, 750, "%s\n%s", lista, TuningComponent[z][tNev]);
															elsosor = 1;
															D_Egyeb_Lista[playerid][x-1] = TuningComponent[z][tID];
															count++;
														}
													}
												}
											}
											if(!count) { Msg(playerid, "Erre a j�rm�re nem rakhat� egyedi tuningkomponens."); D_Tuning[playerid] = D_TUNING_ALAP; ShowVehicleEditor(playerid); return 1; }
											CustomDialog(playerid, D:tuning, DIALOG_STYLE_LIST, "Egy�b komponensek", lista, "Kiv�laszt", "M�gse");
										}
		case D_TUNING_EGYEB_LE:			{ 	
											new vanvalami;
											for(new id = 0; id < MAXTUNING; id++)
											{
												if(CarInfo[vs][cTuningok][id] == 0) continue;
												if(elsosor == 0) { elsosor = 1; vanvalami = 1; format(lista, 750, "%s", TuningComponent[CarInfo[vs][cTuningok][id]-1000][tNev]); }
												else format(lista, 750, "%s\n%s", lista, TuningComponent[CarInfo[vs][cTuningok][id]-1000][tNev]);
											}
											if(!vanvalami) { Msg(playerid, "Nincsen egy darab egyedi komponens se felszerelve"); D_Tuning[playerid] = D_TUNING_ALAP; ShowVehicleEditor(playerid); return 1; }
											Msg(playerid, "Kattints arra a komponensre, amit le szeretn�l szerelni!");
											CustomDialog(playerid, D:tuning, DIALOG_STYLE_LIST, "Felszerelt komponensek", lista, "Kiv�laszt", "M�gse");
										}
		case D_TUNING_EGYEB_MEG:		{	tformat(256, "Vess egy pillant�st a j�rm�vedre, �gy n�zne ki, ha felszereln�d a tuning cuccot!\nVal�ban fel szeretn�d szerelni a j�rm�re a k�vetkez�t: %s?\nA m�velet %s forintba fog ker�lni!\n\nFigyelem! A m�velet ut�n minden m�s egyedi tuning elt�nik, �s m�s tuningot nem rakhatsz a kocsira!", TuningComponent[D_Egyeb_ListaItem[playerid]-1000][tNev], FormatInt(D_Tuning_ItemCost[playerid])); CustomDialog(playerid, D:tuning, DIALOG_STYLE_MSGBOX, "Kin�zet", _tmpString, "Meger�s�t�s", "M�gse"); }
		case D_TUNING_MEGEROSIT: 		{	tformat(256, "K�sz�nj�k a v�s�rl�st!\n\nFizetett �sszeg: %s Ft", FormatInt(D_Tuning_ItemCost[playerid])); CustomDialog(playerid, D:tuning, DIALOG_STYLE_MSGBOX, "Nyugta", _tmpString, "Rendben", ""); PlayerPlaySound(playerid,1054,0.0,0.0,0.0); }
	}
	return 1;
}

Dialog:tuning(playerid, response, listitem, inputtext[])
{
	new vehicle;
	if(IsPlayerInAnyVehicle(playerid))
		vehicle = GetPlayerVehicleID(playerid);
	elseif(GetClosestVehicle(playerid))
		vehicle = GetClosestVehicle(playerid);
	else
		return 1;
		
	new vs = IsAVsKocsi(vehicle);
	new model = CarInfo[vs][cModel];
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return 1;
	if(!response)
	{
		switch(D_Tuning[playerid])
		{
			case D_TUNING_ALAP, D_TUNING_MEGEROSIT, D_TUNING_HIDRAULIKA_MEG: { ResetTuningVariables(playerid), D_AdminTuning[playerid] = false; return 1; }
			case D_TUNING_FESTES, D_TUNING_RIASZTO, D_TUNING_NEON, D_TUNING_HIDRAULIKA, D_TUNING_DETEKTOR, D_TUNING_FELNI, D_TUNING_MATRICA, D_TUNING_TUNINGPACK, D_TUNING_EGYEB, D_TUNING_EGYEB_LE:
			{
				ResetTuningVariables(playerid);
				ShowVehicleEditor(playerid);
				return 1;
			}
			case D_TUNING_FESTES_MEG: 		{ 	ResetTuningVariables(playerid); D_Tuning[playerid] = D_TUNING_FESTES; ShowVehicleEditor(playerid); SetVehicleColor(vehicle, CarInfo[vs][cColorOne], CarInfo[vs][cColorTwo]); D_Tuning_ItemCost[playerid] = 0; return 1; 		}
			case D_TUNING_RIASZTO_MEG: 		{ 	ResetTuningVariables(playerid); D_Tuning[playerid] = D_TUNING_RIASZTO; ShowVehicleEditor(playerid); return 1; 		}
			case D_TUNING_NEON_MEG: 		{ 	ResetTuningVariables(playerid); D_Tuning[playerid] = D_TUNING_NEON; ShowVehicleEditor(playerid); if(IsValidDynamicObject(NeonCar[vehicle][0])) DestroyDynamicObject(NeonCar[vehicle][0]), NeonCar[vehicle][0]=INVALID_OBJECT_ID; if(IsValidDynamicObject(NeonCar[vehicle][1])) DestroyDynamicObject(NeonCar[vehicle][1]), NeonCar[vehicle][1]=INVALID_OBJECT_ID; Neon[vehicle] = 0; return 1; 			}
			case D_TUNING_DETEKTOR_MEG: 	{ 	ResetTuningVariables(playerid); D_Tuning[playerid] = D_TUNING_DETEKTOR; ShowVehicleEditor(playerid); return 1; 		}
			case D_TUNING_FELNI_MEG: 		{	ResetTuningVariables(playerid); D_Tuning[playerid] = D_TUNING_FELNI; ShowVehicleEditor(playerid); AddVehicleComponent(vehicle, CarInfo[vs][cKerek]); return 1; 		}
			case D_TUNING_MATRICA_MEG: 		{	ResetTuningVariables(playerid); D_Tuning[playerid] = D_TUNING_MATRICA; ShowVehicleEditor(playerid); ChangeVehiclePaintjob(vehicle, CarInfo[vs][cMatrica]); return 1; 		}
			case D_TUNING_TUNINGPACK_MEG: 	{ 	ResetTuningVariables(playerid); D_Tuning[playerid] = D_TUNING_TUNINGPACK; ShowVehicleEditor(playerid); JarmuTuning(vehicle); D_Tuning_ItemCost[playerid] = 0; return 1; 	}
			case D_TUNING_EGYEB_MEG: 		{ 	ResetTuningVariables(playerid); D_Tuning[playerid] = D_TUNING_EGYEB; ShowVehicleEditor(playerid); JarmuTuning(vehicle); D_Tuning_ItemCost[playerid] = 0; return 1; 	}
		}
	}
	if(D_Tuning[playerid] == D_TUNING_ALAP)
	{
		switch(listitem)
		{
			case 0:
			{
				if(vs == NINCS) { Msg(playerid, "Ez nem V-s j�rm�!"); ShowVehicleEditor(playerid); return 1; }
				if(!D_AdminTuning[playerid])
				{
					if(!IsAt(playerid, IsAt_Festo)) { Msg(playerid,"Nem vagy egy fest�n�l sem! (Pay 'n' Spray)"); ShowVehicleEditor(playerid); return 1; }
					if(CarInfo[vs][cTulaj] != PlayerInfo[playerid][pID] && CarInfo[vs][cKereskedo] !=  PlayerInfo[playerid][pID]) { Msg(playerid, "Ez nem a te j�rm�ved!"); ShowVehicleEditor(playerid); return 1; }
				}
				new Float:hp;
				GetVehicleHealth(vehicle, hp);
				if(hp < 970) { Msg(playerid, "Nagyon �ssze van t�rve a j�rm�, �gy sajnos nem tudjuk �tfesteni!"); ShowVehicleEditor(playerid); return 1; }
				
				D_Tuning[playerid] = D_TUNING_FESTES;
				ShowVehicleEditor(playerid);
			}
			case 1: //Riaszt�
			{
				if(vs == NINCS) { Msg(playerid, "Ez nem V-s j�rm�!"); ShowVehicleEditor(playerid); return 1; }
				if(!D_AdminTuning[playerid])
				{
					if(!IsAt(playerid, IsAt_SzereloHely)) { Msg(playerid, "Nem vagy egy tuningm�helyben sem!"); ShowVehicleEditor(playerid); return 1; }
					if(CarInfo[vs][cTulaj] != PlayerInfo[playerid][pID] && CarInfo[vs][cKereskedo] !=  PlayerInfo[playerid][pID]) { Msg(playerid, "Ez nem a te j�rm�ved!"); ShowVehicleEditor(playerid); return 1; }
				}
				
				D_Tuning[playerid] = D_TUNING_RIASZTO;
				ShowVehicleEditor(playerid);
			}
			case 2: //Neon
			{
				if(vs == NINCS) { Msg(playerid, "Ez nem V-s j�rm�!"); ShowVehicleEditor(playerid); return 1; }
				if(!D_AdminTuning[playerid])
				{
					if(!IsAt(playerid, IsAt_SzereloHely)) { Msg(playerid, "Nem vagy egy tuningm�helyben sem!"); ShowVehicleEditor(playerid); return 1; }
					if(CarInfo[vs][cTulaj] != PlayerInfo[playerid][pID] && CarInfo[vs][cKereskedo] !=  PlayerInfo[playerid][pID]) { Msg(playerid, "Ez nem a te j�rm�ved!"); ShowVehicleEditor(playerid); return 1; }
				}
				
				D_Tuning[playerid] = D_TUNING_NEON;
				ShowVehicleEditor(playerid);
			}
			case 3: //Hidraulika
			{
				if(vs == NINCS) { Msg(playerid, "Ez nem V-s j�rm�!"); ShowVehicleEditor(playerid); return 1; }
				if(!D_AdminTuning[playerid])
				{
					if(!IsAt(playerid, IsAt_SzereloHely)) { Msg(playerid, "Nem vagy egy tuningm�helyben sem!"); ShowVehicleEditor(playerid); return 1; }
					if(CarInfo[vs][cTulaj] != PlayerInfo[playerid][pID] && CarInfo[vs][cKereskedo] !=  PlayerInfo[playerid][pID]) { Msg(playerid, "Ez nem a te j�rm�ved!"); ShowVehicleEditor(playerid); return 1; }
				}
				
				if(CarInfo[vs][cHidraulika] == 0)
				{
					if(D_AdminTuning[playerid]) D_Tuning_ItemCost[playerid] = 0;
					else D_Tuning_ItemCost[playerid] = 2000000;
				}
				else D_Tuning_ItemCost[playerid] = 0;
				D_Tuning[playerid] = D_TUNING_HIDRAULIKA;
				ShowVehicleEditor(playerid);
			}
			case 4: //Detektor
			{
				if(vs == NINCS) { Msg(playerid, "Ez nem V-s j�rm�!"); ShowVehicleEditor(playerid); return 1; }
				if(!D_AdminTuning[playerid])
				{
					if(!IsAt(playerid, IsAt_SzereloHely)) { Msg(playerid, "Nem vagy egy tuningm�helyben sem!"); ShowVehicleEditor(playerid); return 1; }
					if(CarInfo[vs][cTulaj] != PlayerInfo[playerid][pID] && CarInfo[vs][cKereskedo] !=  PlayerInfo[playerid][pID]) { Msg(playerid, "Ez nem a te j�rm�ved!"); ShowVehicleEditor(playerid); return 1; }
				}
				
				D_Tuning[playerid] = D_TUNING_DETEKTOR;
				ShowVehicleEditor(playerid);
			}
			case 5: //Felni
			{
				if(vs == NINCS) { Msg(playerid, "Ez nem V-s j�rm�!"); ShowVehicleEditor(playerid); return 1; }
				if(!D_AdminTuning[playerid])
				{
					if(!IsAt(playerid, IsAt_SzereloHely)) { Msg(playerid, "Nem vagy egy tuningm�helyben sem!"); ShowVehicleEditor(playerid); return 1; }
					if(CarInfo[vs][cTulaj] != PlayerInfo[playerid][pID] && CarInfo[vs][cKereskedo] !=  PlayerInfo[playerid][pID]) { Msg(playerid, "Ez nem a te j�rm�ved!"); ShowVehicleEditor(playerid); return 1; }
				}
				
				D_Tuning[playerid] = D_TUNING_FELNI;
				ShowVehicleEditor(playerid);
			}
			case 6: //Matrica
			{
				if(vs == NINCS) { Msg(playerid, "Ez nem V-s j�rm�!"); ShowVehicleEditor(playerid); return 1; }
				if(!D_AdminTuning[playerid])
				{
					if(!IsAt(playerid, IsAt_SzereloHely)) { Msg(playerid, "Nem vagy egy tuningm�helyben sem!"); ShowVehicleEditor(playerid); return 1; }
					if(CarInfo[vs][cTulaj] != PlayerInfo[playerid][pID] && CarInfo[vs][cKereskedo] !=  PlayerInfo[playerid][pID]) { Msg(playerid, "Ez nem a te j�rm�ved!"); ShowVehicleEditor(playerid); return 1; }
				}
				
				D_Tuning[playerid] = D_TUNING_MATRICA;
				ShowVehicleEditor(playerid);
			}
			case 7: //Tuningpack (Alien/Xflow)
			{
				if(vs == NINCS) { Msg(playerid, "Ez nem V-s j�rm�!"); ShowVehicleEditor(playerid); return 1; }
				if(!D_AdminTuning[playerid])
				{
					if(!IsAt(playerid, IsAt_SzereloHely)) { Msg(playerid, "Nem vagy egy tuningm�helyben sem!"); ShowVehicleEditor(playerid); return 1; }
					if(CarInfo[vs][cTulaj] != PlayerInfo[playerid][pID] && CarInfo[vs][cKereskedo] !=  PlayerInfo[playerid][pID]) { Msg(playerid, "Ez nem a te j�rm�ved!"); ShowVehicleEditor(playerid); return 1; }
				}
				
				for(new i = 0; i < MAXTUNING; i++)
				{
					if(CarInfo[vs][cTuningok][i] != 0)
					{
						Msg(playerid, "Ezen a j�rm�v�n m�r van egyedi tuning, el�bb azokat szereld le!");
						ShowVehicleEditor(playerid);
						return 1;
					}
				}
				
				D_Tuning[playerid] = D_TUNING_TUNINGPACK;
				ShowVehicleEditor(playerid);
			}
			case 8: //Egyebek
			{
				if(vs == NINCS) { Msg(playerid, "Ez nem V-s j�rm�!"); ShowVehicleEditor(playerid); return 1; }
				if(!D_AdminTuning[playerid])
				{
					if(!IsAt(playerid, IsAt_SzereloHely)) { Msg(playerid, "Nem vagy egy tuningm�helyben sem!"); ShowVehicleEditor(playerid); return 1; }
					if(CarInfo[vs][cTulaj] != PlayerInfo[playerid][pID] && CarInfo[vs][cKereskedo] !=  PlayerInfo[playerid][pID]) { Msg(playerid, "Ez nem a te j�rm�ved!"); ShowVehicleEditor(playerid); return 1; }
				}
				
				D_Tuning[playerid] = D_TUNING_EGYEB;
				ShowVehicleEditor(playerid);
			}
			case 9: // Egy�b leszerel�s
			{
				if(vs == NINCS) { Msg(playerid, "Ez nem V-s j�rm�!"); ShowVehicleEditor(playerid); return 1; }
				if(!D_AdminTuning[playerid])
				{
					if(!IsAt(playerid, IsAt_SzereloHely)) { Msg(playerid, "Nem vagy egy tuningm�helyben sem!"); ShowVehicleEditor(playerid); return 1; }
					if(CarInfo[vs][cTulaj] != PlayerInfo[playerid][pID] && CarInfo[vs][cKereskedo] !=  PlayerInfo[playerid][pID]) { Msg(playerid, "Ez nem a te j�rm�ved!"); ShowVehicleEditor(playerid); return 1; }
				}
				
				D_Tuning[playerid] = D_TUNING_EGYEB_LE;
				ShowVehicleEditor(playerid);
			}
		}
	}
	elseif(D_Tuning[playerid] == D_TUNING_FESTES)
	{
		new szin[2];
		if(!sscanf(inputtext, "p<,>dd", szin[0], szin[1]))
		{
			if(szin[0] < 0 && szin[0] > 255) return ShowVehicleEditor(playerid);
			if(szin[1] < 0 && szin[1] > 255) return ShowVehicleEditor(playerid);
			
			SetVehicleColor(vehicle, szin[0], szin[1]);
			PlayerPlaySound(playerid, 1134, 0.0, 0.0, 0.0);
			
			D_Festes[playerid][0] = szin[0];
			D_Festes[playerid][1] = szin[1];
			D_Tuning[playerid] = D_TUNING_FESTES_MEG;
			if(D_AdminTuning[playerid]) D_Tuning_ItemCost[playerid] = 0;
			else D_Tuning_ItemCost[playerid] = 150000;
			ShowVehicleEditor(playerid);
		}
		else ShowVehicleEditor(playerid);
	}
	elseif(D_Tuning[playerid] == D_TUNING_FESTES_MEG)
	{
		if(!BankkartyaFizet(playerid, 150000, false)) { Msg(playerid,"Nincs el�g p�nzed! 1 fest�s �ra 150.000 Ft!"); ShowVehicleEditor(playerid); return 1; }
		if(CarInfo[vs][cColorOne] != D_Festes[playerid][0] || CarInfo[vs][cColorTwo] != D_Festes[playerid][1])
			CarInfo[vs][cPainted] = 1;
		else
			CarInfo[vs][cPainted] = 0;
	
		CarInfo[vs][cColorOne] = D_Festes[playerid][0];
		CarInfo[vs][cColorTwo] = D_Festes[playerid][1];
		CarUpdate(vs, CAR_ColorOne, CAR_ColorTwo);
		
		BizPenz(BIZ_FIXCAR, 150000);
		BankkartyaFizet(playerid, 150000);
		
		D_Tuning[playerid] = D_TUNING_MEGEROSIT;
		ShowVehicleEditor(playerid);
	}
	elseif(D_Tuning[playerid] == D_TUNING_RIASZTO)
	{
		switch(listitem)
		{
			case 0:
			{
				if(CarInfo[vs][cRiaszto] == 0) return ShowVehicleEditor(playerid);
				D_Tuning[playerid] = D_TUNING_RIASZTO_MEG;
				D_Tuning_SelectedItem[playerid] = listitem;
				D_Tuning_ItemCost[playerid] = 0;
				ShowVehicleEditor(playerid);
			}
			case 1:
			{
				D_Tuning[playerid] = D_TUNING_RIASZTO_MEG;
				D_Tuning_SelectedItem[playerid] = listitem;
				if(D_AdminTuning[playerid]) D_Tuning_ItemCost[playerid] = 0;
				else D_Tuning_ItemCost[playerid] = 100000;
				ShowVehicleEditor(playerid);
			}
			case 2:
			{
				D_Tuning[playerid] = D_TUNING_RIASZTO_MEG;
				D_Tuning_SelectedItem[playerid] = listitem;
				if(D_AdminTuning[playerid]) D_Tuning_ItemCost[playerid] = 0;
				else D_Tuning_ItemCost[playerid] = 300000;
				ShowVehicleEditor(playerid);
			}
			case 3:
			{
				D_Tuning[playerid] = D_TUNING_RIASZTO_MEG;
				D_Tuning_SelectedItem[playerid] = listitem;
				if(D_AdminTuning[playerid]) D_Tuning_ItemCost[playerid] = 0;
				else D_Tuning_ItemCost[playerid] = 500000;
				ShowVehicleEditor(playerid);
			}
			case 4:
			{
				D_Tuning[playerid] = D_TUNING_RIASZTO_MEG;
				D_Tuning_SelectedItem[playerid] = listitem;
				if(D_AdminTuning[playerid]) D_Tuning_ItemCost[playerid] = 0;
				else D_Tuning_ItemCost[playerid] = 2000000;
				ShowVehicleEditor(playerid);
			}
		}
	}
	elseif(D_Tuning[playerid] == D_TUNING_RIASZTO_MEG)
	{
		if(!BankkartyaFizet(playerid, D_Tuning_ItemCost[playerid], false)) { SendFormatMessage(playerid, COLOR_LIGHTRED, "ClassRPG: Nincs el�g p�nzed! A tuning �ra %s Ft!", FormatInt(D_Tuning_ItemCost[playerid])); D_Tuning[playerid] = D_TUNING_RIASZTO; D_Tuning_ItemCost[playerid] = 0; ShowVehicleEditor(playerid); JarmuTuning(vehicle); return 1; }
		CarInfo[vs][cRiaszto] = D_Tuning_SelectedItem[playerid];
		CarUpdate(vs, CAR_Riaszto);
		
		BizPenz(BIZ_TUNING, D_Tuning_ItemCost[playerid]);
		BankkartyaFizet(playerid, D_Tuning_ItemCost[playerid]);
		
		D_Tuning[playerid] = D_TUNING_MEGEROSIT;
		ShowVehicleEditor(playerid);
	}
	elseif(D_Tuning[playerid] == D_TUNING_NEON)
	{
		switch(listitem)
		{
			case 0:
			{
				if(CarInfo[vs][cNeon] == 0) return ShowVehicleEditor(playerid);
				D_Tuning[playerid] = D_TUNING_NEON_MEG;
				D_Tuning_SelectedItem[playerid] = listitem;
				D_Tuning_ItemCost[playerid] = 0;
				ShowVehicleEditor(playerid);
			}
			case 1..6:
			{
				D_Tuning[playerid] = D_TUNING_NEON_MEG;
				D_Tuning_SelectedItem[playerid] = listitem;
				if(D_AdminTuning[playerid]) D_Tuning_ItemCost[playerid] = 0;
				else D_Tuning_ItemCost[playerid] = 1000000;
				ShowVehicleEditor(playerid);
			}
		}
		new neonid = listitem;
		switch(neonid)
		{
			case 1: // k�k
			{
				Neon[vehicle] = 1;
				NeonCar[vehicle][0]=CreateDynamicObject(18648,0,0,0,0,0,0);
				NeonCar[vehicle][1]=CreateDynamicObject(18648,0,0,0,0,0,0);
				AttachDynamicObjectToVehicle(NeonCar[vehicle][0], vehicle, -0.70, 0.06, -0.58,   0.00, 0.00, 0.00);
				AttachDynamicObjectToVehicle(NeonCar[vehicle][1], vehicle, 0.72, 0.05, -0.60,   0.00, 0.00, 0.00);
				Streamer_Update(playerid);
			}
			case 2: // piros
			{
				Neon[vehicle] = 1;
				NeonCar[vehicle][0]=CreateDynamicObject(18647,0,0,0,0,0,0);
				NeonCar[vehicle][1]=CreateDynamicObject(18647,0,0,0,0,0,0);
				AttachDynamicObjectToVehicle(NeonCar[vehicle][0], vehicle, -0.70, 0.06, -0.58,   0.00, 0.00, 0.00);
				AttachDynamicObjectToVehicle(NeonCar[vehicle][1], vehicle, 0.72, 0.05, -0.60,   0.00, 0.00, 0.00);
				Streamer_Update(playerid);
			}
			case 3: // r�zsasz�n
			{
				Neon[vehicle] = 1;
				NeonCar[vehicle][0]=CreateDynamicObject(18651,0,0,0,0,0,0);
				NeonCar[vehicle][1]=CreateDynamicObject(18651,0,0,0,0,0,0);
				AttachDynamicObjectToVehicle(NeonCar[vehicle][0], vehicle, -0.70, 0.06, -0.58,   0.00, 0.00, 0.00);
				AttachDynamicObjectToVehicle(NeonCar[vehicle][1], vehicle, 0.72, 0.05, -0.60,   0.00, 0.00, 0.00);
				Streamer_Update(playerid);
			}
			case 4: // feh�r
			{
				Neon[vehicle] = 1;
				NeonCar[vehicle][0]=CreateDynamicObject(18652,0,0,0,0,0,0);
				NeonCar[vehicle][1]=CreateDynamicObject(18652,0,0,0,0,0,0);
				AttachDynamicObjectToVehicle(NeonCar[vehicle][0], vehicle, -0.70, 0.06, -0.58,   0.00, 0.00, 0.00);
				AttachDynamicObjectToVehicle(NeonCar[vehicle][1], vehicle, 0.72, 0.05, -0.60,   0.00, 0.00, 0.00);
				Streamer_Update(playerid);
			}
			case 5: // z�ld
			{
				Neon[vehicle] = 1;
				NeonCar[vehicle][0]=CreateDynamicObject(18649,0,0,0,0,0,0);
				NeonCar[vehicle][1]=CreateDynamicObject(18649,0,0,0,0,0,0);
				AttachDynamicObjectToVehicle(NeonCar[vehicle][0], vehicle, -0.70, 0.06, -0.58,   0.00, 0.00, 0.00);
				AttachDynamicObjectToVehicle(NeonCar[vehicle][1], vehicle, 0.72, 0.05, -0.60,   0.00, 0.00, 0.00);
				Streamer_Update(playerid);
			}
			case 6: // s�rga
			{
				Neon[vehicle] = 1;
				NeonCar[vehicle][0]=CreateDynamicObject(18650,0,0,0,0,0,0);
				NeonCar[vehicle][1]=CreateDynamicObject(18650,0,0,0,0,0,0);
				AttachDynamicObjectToVehicle(NeonCar[vehicle][0], vehicle, -0.70, 0.06, -0.58,   0.00, 0.00, 0.00);
				AttachDynamicObjectToVehicle(NeonCar[vehicle][1], vehicle, 0.72, 0.05, -0.60,   0.00, 0.00, 0.00);
				Streamer_Update(playerid);
			}
		}
	}
	elseif(D_Tuning[playerid] == D_TUNING_NEON_MEG)
	{
		if(!BankkartyaFizet(playerid, D_Tuning_ItemCost[playerid], false)) { SendFormatMessage(playerid, COLOR_LIGHTRED, "ClassRPG: Nincs el�g p�nzed! A tuning �ra %s Ft!", FormatInt(D_Tuning_ItemCost[playerid])); D_Tuning[playerid] = D_TUNING_NEON; D_Tuning_ItemCost[playerid] = 0; ShowVehicleEditor(playerid); JarmuTuning(vehicle); return 1; }
		CarInfo[vs][cNeon] = D_Tuning_SelectedItem[playerid];
		CarUpdate(vs, CAR_Neon);
		
		BizPenz(BIZ_TUNING, D_Tuning_ItemCost[playerid]);
		BankkartyaFizet(playerid, D_Tuning_ItemCost[playerid]);
		
		D_Tuning[playerid] = D_TUNING_MEGEROSIT;
		ShowVehicleEditor(playerid);
	}
	elseif(D_Tuning[playerid] == D_TUNING_HIDRAULIKA)
	{
		if(CarInfo[vs][cHidraulika] == 0)
		{
			D_Tuning[playerid] = D_TUNING_HIDRAULIKA_MEG;
			D_Tuning_SelectedItem[playerid] = 1;
			if(D_AdminTuning[playerid]) D_Tuning_ItemCost[playerid] = 0;
			else D_Tuning_ItemCost[playerid] = 2000000;
			ShowVehicleEditor(playerid);
		}
		else
		{
			D_Tuning[playerid] = D_TUNING_HIDRAULIKA_MEG;
			D_Tuning_SelectedItem[playerid] = 0;
			D_Tuning_ItemCost[playerid] = 0;
			ShowVehicleEditor(playerid);
		}
	}
	elseif(D_Tuning[playerid] == D_TUNING_HIDRAULIKA_MEG)
	{
		if(!BankkartyaFizet(playerid, D_Tuning_ItemCost[playerid], false)) { SendFormatMessage(playerid, COLOR_LIGHTRED, "ClassRPG: Nincs el�g p�nzed! A tuning �ra %s Ft!", FormatInt(D_Tuning_ItemCost[playerid])); D_Tuning[playerid] = D_TUNING_HIDRAULIKA; D_Tuning_ItemCost[playerid] = 0; ShowVehicleEditor(playerid); JarmuTuning(vehicle); return 1; }
		
		if(CarInfo[vs][cHidraulika] == 1)
			RemoveVehicleComponent(vehicle, 1087);
		else
			AddVehicleComponent(vehicle, 1087);
			
		CarInfo[vs][cHidraulika] = D_Tuning_SelectedItem[playerid];
		CarUpdate(vs, CAR_Hidraulika);
		
		BizPenz(BIZ_TUNING, D_Tuning_ItemCost[playerid]);
		BankkartyaFizet(playerid, D_Tuning_ItemCost[playerid]);
		
		D_Tuning[playerid] = D_TUNING_ALAP;
		ShowVehicleEditor(playerid);
		SendFormatMessage(playerid, COLOR_GREEN, "V�s�rl�s meger�s�tve! Tuning t�pus: Hidraulika | Fizetett �sszeg: %s Ft", FormatInt(D_Tuning_ItemCost[playerid]));
	}
	elseif(D_Tuning[playerid] == D_TUNING_DETEKTOR)
	{
		switch(listitem)
		{
			case 0:
			{
				if(CarInfo[vs][cDetektor] == 0) return ShowVehicleEditor(playerid);
				D_Tuning[playerid] = D_TUNING_DETEKTOR_MEG;
				D_Tuning_SelectedItem[playerid] = 0;
				ShowVehicleEditor(playerid);
			}
			case 1:
			{
				D_Tuning[playerid] = D_TUNING_DETEKTOR_MEG;
				D_Tuning_SelectedItem[playerid] = listitem;
				if(D_AdminTuning[playerid]) D_Tuning_ItemCost[playerid] = 0;
				else D_Tuning_ItemCost[playerid] = 5000000;
				ShowVehicleEditor(playerid);
			}
			case 2:
			{
				D_Tuning[playerid] = D_TUNING_DETEKTOR_MEG;
				D_Tuning_SelectedItem[playerid] = listitem;
				if(D_AdminTuning[playerid]) D_Tuning_ItemCost[playerid] = 0;
				else D_Tuning_ItemCost[playerid] = 7500000;
				ShowVehicleEditor(playerid);
			}
			case 3:
			{
				D_Tuning[playerid] = D_TUNING_DETEKTOR_MEG;
				D_Tuning_SelectedItem[playerid] = listitem;
				if(D_AdminTuning[playerid]) D_Tuning_ItemCost[playerid] = 0;
				else D_Tuning_ItemCost[playerid] = 10000000;
				ShowVehicleEditor(playerid);
			}
		}
	}
	elseif(D_Tuning[playerid] == D_TUNING_DETEKTOR_MEG)
	{
		if(!BankkartyaFizet(playerid, D_Tuning_ItemCost[playerid], false)) { SendFormatMessage(playerid, COLOR_LIGHTRED, "ClassRPG: Nincs el�g p�nzed! A tuning �ra %s Ft!", FormatInt(D_Tuning_ItemCost[playerid])); D_Tuning[playerid] = D_TUNING_DETEKTOR; D_Tuning_ItemCost[playerid] = 0; ShowVehicleEditor(playerid); JarmuTuning(vehicle); return 1; }
		CarInfo[vs][cDetektor] = D_Tuning_SelectedItem[playerid];
		CarUpdate(vs, CAR_Detektor);
		
		BizPenz(BIZ_TUNING, D_Tuning_ItemCost[playerid]);
		BankkartyaFizet(playerid, D_Tuning_ItemCost[playerid]);
		
		D_Tuning[playerid] = D_TUNING_MEGEROSIT;
		ShowVehicleEditor(playerid);
	}
	elseif(D_Tuning[playerid] == D_TUNING_FELNI)
	{
		switch(listitem)
		{
			case 0:
			{
				if(CarInfo[vs][cKerek] == 0) return ShowVehicleEditor(playerid);
				D_Tuning[playerid] = D_TUNING_FELNI_MEG;
				D_Tuning_SelectedItem[playerid] = listitem;
				D_Tuning_ItemCost[playerid] = 0;
				ShowVehicleEditor(playerid);
			}
			case 1..17:
			{
				D_Tuning[playerid] = D_TUNING_FELNI_MEG;
				if(D_AdminTuning[playerid]) D_Tuning_ItemCost[playerid] = 0;
				else D_Tuning_ItemCost[playerid] = 100000;
				ShowVehicleEditor(playerid);
				
				new k, kerek = listitem;
				if(kerek < 14) k = kerek+1072;
				else
				{
					switch(kerek)
					{
						case 14: k=1025;
						case 15: k=1096;
						case 16: k=1097;
						case 17: k=1098;
					}
				}
				AddVehicleComponent(vehicle, k);
				D_Tuning_SelectedItem[playerid] = k;
			}
		}
	}
	elseif(D_Tuning[playerid] == D_TUNING_FELNI_MEG)
	{
		if(!BankkartyaFizet(playerid, D_Tuning_ItemCost[playerid], false)) { SendFormatMessage(playerid, COLOR_LIGHTRED, "ClassRPG: Nincs el�g p�nzed! A tuning �ra %s Ft!", FormatInt(D_Tuning_ItemCost[playerid])); D_Tuning[playerid] = D_TUNING_FELNI; D_Tuning_ItemCost[playerid] = 0; ShowVehicleEditor(playerid); JarmuTuning(vehicle); return 1; }
		CarInfo[vs][cKerek] = D_Tuning_SelectedItem[playerid];
		CarUpdate(vs, CAR_Kerek);
		
		BizPenz(BIZ_TUNING, D_Tuning_ItemCost[playerid]);
		BankkartyaFizet(playerid, D_Tuning_ItemCost[playerid]);
		
		D_Tuning[playerid] = D_TUNING_MEGEROSIT;
		ShowVehicleEditor(playerid);
	}
	elseif(D_Tuning[playerid] == D_TUNING_MATRICA)
	{
		switch(listitem)
		{
			case 0..2:
			{
				if((!IsALocoLowCoCar(vehicle) && !IsAWheelArchAngelCar(vehicle)) || model == 566 || model == 412) { Msg(playerid, "Erre a j�rm�re nem rakhatsz ilyen tuningot"); D_Tuning[playerid] = D_TUNING_ALAP; D_Tuning_ItemCost[playerid] = 0; ShowVehicleEditor(playerid); JarmuTuning(vehicle); return 1; }
				D_Tuning[playerid] = D_TUNING_MATRICA_MEG;
				D_Tuning_SelectedItem[playerid] = listitem;
				if(D_AdminTuning[playerid]) D_Tuning_ItemCost[playerid] = 0;
				else D_Tuning_ItemCost[playerid] = 10000000;
				ShowVehicleEditor(playerid);
				ChangeVehiclePaintjob(vehicle, listitem);
			}
			case 3:
			{
				if(CarInfo[vs][cMatrica] == 3) return ShowVehicleEditor(playerid);
				D_Tuning[playerid] = D_TUNING_MATRICA_MEG;
				D_Tuning_SelectedItem[playerid] = listitem;
				D_Tuning_ItemCost[playerid] = 0;
				ShowVehicleEditor(playerid);
				ChangeVehiclePaintjob(vehicle, listitem);
			}
		}
	}
	elseif(D_Tuning[playerid] == D_TUNING_MATRICA_MEG)
	{
		if(!BankkartyaFizet(playerid, D_Tuning_ItemCost[playerid], false)) { SendFormatMessage(playerid, COLOR_LIGHTRED, "ClassRPG: Nincs el�g p�nzed! A tuning �ra %s Ft!", FormatInt(D_Tuning_ItemCost[playerid])); D_Tuning[playerid] = D_TUNING_MATRICA; D_Tuning_ItemCost[playerid] = 0; ShowVehicleEditor(playerid); JarmuTuning(vehicle); return 1; }
		CarInfo[vs][cMatrica] = D_Tuning_SelectedItem[playerid];
		CarUpdate(vs, CAR_Matrica);
		
		BizPenz(BIZ_TUNING, D_Tuning_ItemCost[playerid]);
		BankkartyaFizet(playerid, D_Tuning_ItemCost[playerid]);
		
		D_Tuning[playerid] = D_TUNING_MEGEROSIT;
		ShowVehicleEditor(playerid);
	}
	elseif(D_Tuning[playerid] == D_TUNING_TUNINGPACK)
	{
		if((!IsALocoLowCoCar(vehicle) && !IsAWheelArchAngelCar(vehicle)) || model == 566 || model == 412) { Msg(playerid, "Erre a j�rm�re nem rakhatsz ilyen tuningot"); D_Tuning[playerid] = D_TUNING_ALAP; D_Tuning_ItemCost[playerid] = 0; ShowVehicleEditor(playerid); return 1; }
		switch(listitem)
		{
			case 0:
			{
				if(CarInfo[vs][cTuning] == 0) return ShowVehicleEditor(playerid);
				D_Tuning[playerid] = D_TUNING_TUNINGPACK_MEG;
				D_Tuning_SelectedItem[playerid] = listitem;
				D_Tuning_ItemCost[playerid] = 0;
				ShowVehicleEditor(playerid);
			}
			case 1:
			{
				if(model == 560)
				{
					AddVehicleComponent(vehicle, 1026);
					AddVehicleComponent(vehicle, 1027);
					AddVehicleComponent(vehicle, 1032);
					AddVehicleComponent(vehicle, 1169);
					AddVehicleComponent(vehicle, 1138);
					AddVehicleComponent(vehicle, 1141);
					AddVehicleComponent(vehicle, 1028);
				}
				if(model == 562)
				{
					AddVehicleComponent(vehicle, 1034);
					AddVehicleComponent(vehicle, 1038);
					AddVehicleComponent(vehicle, 1036);
					AddVehicleComponent(vehicle, 1040);
					AddVehicleComponent(vehicle, 1147);
					AddVehicleComponent(vehicle, 1149);
					AddVehicleComponent(vehicle, 1171);
				}
				if(model == 559)
				{
					AddVehicleComponent(vehicle, 1065);
					AddVehicleComponent(vehicle, 1067);
					AddVehicleComponent(vehicle, 1069);
					AddVehicleComponent(vehicle, 1071);
					AddVehicleComponent(vehicle, 1159);
					AddVehicleComponent(vehicle, 1160);
					AddVehicleComponent(vehicle, 1162);
				}
				if(model == 560)
				{
					AddVehicleComponent(vehicle, 1026);
					AddVehicleComponent(vehicle, 1027);
					AddVehicleComponent(vehicle, 1032);
					AddVehicleComponent(vehicle, 1169);
					AddVehicleComponent(vehicle, 1138);
					AddVehicleComponent(vehicle, 1141);
					AddVehicleComponent(vehicle, 1028);
				}
				if(model == 558)
				{
					AddVehicleComponent(vehicle, 1088);
					AddVehicleComponent(vehicle, 1090);
					AddVehicleComponent(vehicle, 1092);
					AddVehicleComponent(vehicle, 1094);
					AddVehicleComponent(vehicle, 1164);
					AddVehicleComponent(vehicle, 1166);
					AddVehicleComponent(vehicle, 1168);
				}
				if(model == 561)
				{
					AddVehicleComponent(vehicle, 1055);
					AddVehicleComponent(vehicle, 1056);
					AddVehicleComponent(vehicle, 1058);
					AddVehicleComponent(vehicle, 1062);
					AddVehicleComponent(vehicle, 1064);
					AddVehicleComponent(vehicle, 1154);
					AddVehicleComponent(vehicle, 1155);
				}
				if(model == 565)
				{
					AddVehicleComponent(vehicle, 1046);
					AddVehicleComponent(vehicle, 1047);
					AddVehicleComponent(vehicle, 1049);
					AddVehicleComponent(vehicle, 1051);
					AddVehicleComponent(vehicle, 1054);
					AddVehicleComponent(vehicle, 1150);
					AddVehicleComponent(vehicle, 1153);
				}
				D_Tuning[playerid] = D_TUNING_TUNINGPACK_MEG;
				D_Tuning_SelectedItem[playerid] = listitem;
				D_Tuning_ItemCost[playerid] = 5000000;
				ShowVehicleEditor(playerid);
			}
			case 2:
			{
				D_Tuning[playerid] = D_TUNING_TUNINGPACK_MEG;
				D_Tuning_SelectedItem[playerid] = listitem;
				D_Tuning_ItemCost[playerid] = 5000000;
				ShowVehicleEditor(playerid);
				
				if(model == 560)
				{
					AddVehicleComponent(vehicle, 1029);
					AddVehicleComponent(vehicle, 1030);
					AddVehicleComponent(vehicle, 1031);
					AddVehicleComponent(vehicle, 1133);
					AddVehicleComponent(vehicle, 1139);
					AddVehicleComponent(vehicle, 1140);
					AddVehicleComponent(vehicle, 1170);
				}
				if(model == 562)
				{
					AddVehicleComponent(vehicle, 1035);
					AddVehicleComponent(vehicle, 1037);
					AddVehicleComponent(vehicle, 1039);
					AddVehicleComponent(vehicle, 1041);
					AddVehicleComponent(vehicle, 1146);
					AddVehicleComponent(vehicle, 1148);
					AddVehicleComponent(vehicle, 1172);
				}
				if(model == 559)
				{
					AddVehicleComponent(vehicle, 1066);
					AddVehicleComponent(vehicle, 1068);
					AddVehicleComponent(vehicle, 1070);
					AddVehicleComponent(vehicle, 1072);
					AddVehicleComponent(vehicle, 1158);
					AddVehicleComponent(vehicle, 1161);
					AddVehicleComponent(vehicle, 1173);
				}
				if(model == 558)
				{
					AddVehicleComponent(vehicle, 1089);
					AddVehicleComponent(vehicle, 1091);
					AddVehicleComponent(vehicle, 1093);
					AddVehicleComponent(vehicle, 1095);
					AddVehicleComponent(vehicle, 1163);
					AddVehicleComponent(vehicle, 1165);
					AddVehicleComponent(vehicle, 1167);
				}
				if(model == 561)
				{
					AddVehicleComponent(vehicle, 1057);
					AddVehicleComponent(vehicle, 1059);
					AddVehicleComponent(vehicle, 1050);
					AddVehicleComponent(vehicle, 1061);
					AddVehicleComponent(vehicle, 1063);
					AddVehicleComponent(vehicle, 1156);
					AddVehicleComponent(vehicle, 1157);
				}
				if(model == 565)
				{
					AddVehicleComponent(vehicle, 1045);
					AddVehicleComponent(vehicle, 1048);
					AddVehicleComponent(vehicle, 1050);
					AddVehicleComponent(vehicle, 1052);
					AddVehicleComponent(vehicle, 1053);
					AddVehicleComponent(vehicle, 1151);
					AddVehicleComponent(vehicle, 1152);
				}
			}
		}
	}
	elseif(D_Tuning[playerid] == D_TUNING_TUNINGPACK_MEG)
	{
		if(!BankkartyaFizet(playerid, D_Tuning_ItemCost[playerid], false)) { SendFormatMessage(playerid, COLOR_LIGHTRED, "ClassRPG: Nincs el�g p�nzed! A tuning �ra %s Ft!", FormatInt(D_Tuning_ItemCost[playerid])); D_Tuning[playerid] = D_TUNING_TUNINGPACK; D_Tuning_ItemCost[playerid] = 0; ShowVehicleEditor(playerid); return 1; }
		CarInfo[vs][cTuning] = D_Tuning_SelectedItem[playerid];
		CarUpdate(vs, CAR_Tuning);
		JarmuTuning(vehicle);
		
		BizPenz(BIZ_TUNING, D_Tuning_ItemCost[playerid]);
		BankkartyaFizet(playerid, D_Tuning_ItemCost[playerid]);
		
		D_Tuning[playerid] = D_TUNING_MEGEROSIT;
		ShowVehicleEditor(playerid);
	}
	elseif(D_Tuning[playerid] == D_TUNING_EGYEB)
	{
		if(CarInfo[vs][cTuning] != 0) { Msg(playerid, "Ezen a j�rm�v�n m�r van egyedi tuning, el�bb azokat szereld le!"); ShowVehicleEditor(playerid); return 1; }
		AddVehicleComponent(vehicle, D_Egyeb_Lista[playerid][listitem]);
		D_Egyeb_ListaItem[playerid] = D_Egyeb_Lista[playerid][listitem];
		D_Tuning[playerid] = D_TUNING_EGYEB_MEG;
		if(D_AdminTuning[playerid]) D_Tuning_ItemCost[playerid] = 0;
		else D_Tuning_ItemCost[playerid] = 1000000;
		ShowVehicleEditor(playerid);
	}
	elseif(D_Tuning[playerid] == D_TUNING_EGYEB_MEG)
	{
		if(!BankkartyaFizet(playerid, D_Tuning_ItemCost[playerid], false)) { SendFormatMessage(playerid, COLOR_LIGHTRED, "ClassRPG: Nincs el�g p�nzed! A tuning �ra %s Ft!", FormatInt(D_Tuning_ItemCost[playerid])); D_Tuning[playerid] = D_TUNING_TUNINGPACK; D_Tuning_ItemCost[playerid] = 0; ShowVehicleEditor(playerid); return 1; }
		for(new q = 0; q < MAXTUNING; q++)
		{
			if(CarInfo[vs][cTuningok][q] != 0) continue;
			CarInfo[vs][cTuningok][q] = D_Egyeb_ListaItem[playerid];
			break;
		}
		CarUpdate(vs, CAR_Tuningok);
		
		BizPenz(BIZ_TUNING, D_Tuning_ItemCost[playerid]);
		BankkartyaFizet(playerid, D_Tuning_ItemCost[playerid]);
		
		D_Tuning[playerid] = D_TUNING_MEGEROSIT;
		ShowVehicleEditor(playerid);
	}
	elseif(D_Tuning[playerid] == D_TUNING_EGYEB_LE)
	{
		if(CarInfo[vs][cTuningok][listitem] == 0) return ShowVehicleEditor(playerid);
		RemoveVehicleComponent(vehicle, CarInfo[vs][cTuningok][listitem]);
		CarInfo[vs][cTuningok][listitem] = 0;
		D_Tuning[playerid] = D_TUNING_MEGEROSIT;
		D_Tuning_ItemCost[playerid] = 0;
		ShowVehicleEditor(playerid);
	}
	elseif(D_Tuning[playerid] == D_TUNING_MEGEROSIT)
	{
		SendFormatMessage(playerid, COLOR_GREEN, "V�s�rl�s meger�s�tve! Fizetett �sszeg: %s Ft", FormatInt(D_Tuning_ItemCost[playerid]));
		ResetTuningVariables(playerid);
		ShowVehicleEditor(playerid);
	}
	return 1;
}

/**	::				::
	::	 COMMANDS	::
	::				::	**/

ALIAS(tuningol1s):tuningolas;
CMD:tuningolas(playerid, params[])
{
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return Msg(playerid, "Nem a vezet� �l�sen �lsz!");
	ResetTuningVariables(playerid);
	ShowVehicleEditor(playerid);
	return 1;
}

ALIAS(atuningol1s):atuningolas;
CMD:atuningolas(playerid, params[])
{
	new jarmu = GetClosestVehicle(playerid);
	if(!Admin(playerid, 1337)) return 1;
	if(!IsPlayerInAnyVehicle(playerid) && GetPlayerDistanceFromVehicle(playerid, jarmu) > 3.0) return Msg(playerid, "Nincs k�zeledben j�rm�");
	ResetTuningVariables(playerid);
	D_AdminTuning[playerid] = true;
	ShowVehicleEditor(playerid);
	return 1;
}


/**	::				::
	::	OLD TUNING	::
	::	  SYSTEM	::
	::				::	**/


//NE T�R�LD KI! LEHET, HOGY K�S�BB M�G SZ�KS�G LESZ R�... EZ A TUNINGRENDSZER 1. V�LTOZATA, 85-90 SZ�ZAL�KOS �LLAPOT�BAN
/*
new D_Tuning_Item[15][64] =
{
	"�tfest�s",
	"Riaszt�",
	"Neon",
	"Hidraulika",
	"Detektor",
	"Felni",
	"Matrica",
	"Tuningpack",
	"Motorh�ztet�",
	"Szell�z�",
	"L�mpa",
	"Kipufog�",
	"Tet� szell�z�",
	"Spoiler",
	"D�sz"
};

stock IsALegalCarMod(modelid, componentid) 
{
	//printf("[system_tuning debug] start; model = %d componentid = %d", modelid, componentid);
	new ok = false;
	for(new i = 0; i < 47; i++)
	{
		if(legalmods[i][0] == modelid)
		{
			for(new x = 1; x < 22; x++)
			{
				if(legalmods[i][x] == componentid)
					ok = true;
			}
		}
	}
	//printf("[system_tuning debug] ok = %d; modelid = %d componentid = %d", ok, modelid, componentid);
    return ok;
}

ShowVehicleEditor_Old(playerid)
{
	switch(D_Tuning[playerid])
	{
		case D_TUNING_ALAP: 				CustomDialog(playerid, D:tuning, DIALOG_STYLE_LIST, "Tuningol�s", "J�rm� �tfest�se\nRiaszt� felszerel�se\nNeon felszerel�se\nHidraulika felszerel�se\nDetektor felszerel�se\nFelni felszerel�se\nMatrica felragaszt�sa\nKomplett tuningpackok felszerel�se\nMotorh�ztet�k felszerel�se\nSzell�z�k\nL�mp�k\nKipufog�k\nTet�\nSpoilerek\nD�szek", "Kiv�laszt", "M�gse");
		case D_TUNING_FESTES: 			{	new vehicle = GetPlayerVehicleID(playerid); new vs = IsAVsKocsi(vehicle); tformat(256, "A j�rm�ved �j sz�neit a k�vetkez� form�tumban kell megadni:\nEls� sz�n,M�sodik sz�n\nPl.: 76,132\n\nJelenlegi sz�nek:\n%d,%d", CarInfo[vs][cColorOne], CarInfo[vs][cColorTwo]); CustomDialog(playerid, D:tuning, DIALOG_STYLE_INPUT, "J�rm� �tfest�se", _tmpString, "�tfest�s", "M�gse"); }
		case D_TUNING_FESTES_MEG:			CustomDialog(playerid, D:tuning, DIALOG_STYLE_MSGBOX, "�tfest�s meger�s�t�se", "Vess egy pillant�st a j�rm�vedre, �gy n�zne ki az �j sz�nekkel!\nVal�ban �t szeretn�d f�jatni a j�rm�vet?\nA m�velet 150.000 Ft-ba fog ker�lni!", "Meger�s�t�s", "M�gse");
		case D_TUNING_RIASZTO:				CustomDialog(playerid, D:tuning, DIALOG_STYLE_LIST, "Riaszt� kiv�laszt�sa", "0. szint� riaszt� (leszerel�s)\n1. szint� riaszt� (Csak dud�l - 100.000FT)\n2. szint� riaszt� (Dud�l �s jelez a tulajnak - 300.000FT)\n3. szint� riaszt� (Dud�l, jelez a tulajnak �s a rend�rs�gnek - 500.000FT)\n4. szint� riaszt� (G�tolja a kocsi ind�t�s�t, lop�sbiztos - 2.000.000FT)", "Kiv�laszt", "M�gse");
		case D_TUNING_RIASZTO_MEG:		{	tformat(256, "Val�ban fel szeretn�d szerelni a j�rm�re a k�vetkez�t: %s?\nA m�velet %s forintba fog ker�lni!", D_Tuning_Item[D_Tuning_SelectedItem[playerid][1]], FormatInt(D_Tuning_ItemCost[playerid])); CustomDialog(playerid, D:tuning, DIALOG_STYLE_MSGBOX, "Meger�s�t�s", _tmpString, "Meger�s�t�s", "M�gse"); }
		case D_TUNING_NEON:					CustomDialog(playerid, D:tuning, DIALOG_STYLE_LIST, "Neon kiv�laszt�sa", "Leszerel�s\nK�k\nPiros\nR�zsasz�n\nFeh�r\nZ�ld\nS�rga", "Kiv�laszt", "M�gse");
		case D_TUNING_NEON_MEG: 		{	tformat(256, "Vess egy pillant�st a j�rm�vedre, �gy n�zne ki, ha felszereln�d a tuning cuccot!\nVal�ban fel szeretn�d szerelni a j�rm�re a k�vetkez�t: %s?\nA m�velet %s forintba fog ker�lni!", D_Tuning_Item[D_Tuning_SelectedItem[playerid][1]], FormatInt(D_Tuning_ItemCost[playerid])); CustomDialog(playerid, D:tuning, DIALOG_STYLE_MSGBOX, "Kin�zet", _tmpString, "Meger�s�t�s", "M�gse"); }
		case D_TUNING_HIDRAULIKA: 			CustomDialog(playerid, D:tuning, DIALOG_STYLE_MSGBOX, "Hidraulika felszerel�se", "Val�ban felszeretn�d szerelni a hidraulik�t a j�rm�vedre?\nA m�velet 2.000.000 Ft-ba fog ker�lni!", "Meger�s�t�s", "M�gse");
		case D_TUNING_DETEKTOR:				CustomDialog(playerid, D:tuning, DIALOG_STYLE_LIST, "Detektor kiv�laszt�sa", "0. szint� detektor (leszerel�s)\n1. szint� detektor (Csak blokkolja a bem�r�st - 5.000.000 Ft)\n2. szint� detektor (Csak bejelez a vezet�nek, ha 100 m�teres k�rzetben traffipax tal�lhat� - 7.500.000 Ft)\n3. szint� detektor (Bejelez a vezet�nek, ha 100 m�teres k�rzetben traffipax tal�lhat� �s blokkolja a bem�r�st - 10.000.000 Ft)", "Kiv�laszt", "M�gse");
		case D_TUNING_DETEKTOR_MEG:		{	tformat(256, "Val�ban fel szeretn�d szerelni a j�rm�re a k�vetkez�t: %s?\nA m�velet %s forintba fog ker�lni!", D_Tuning_Item[D_Tuning_SelectedItem[playerid][1]], FormatInt(D_Tuning_ItemCost[playerid])); CustomDialog(playerid, D:tuning, DIALOG_STYLE_MSGBOX, "Kin�zet", _tmpString, "Meger�s�t�s", "M�gse"); }
		case D_TUNING_FELNI:				CustomDialog(playerid, D:tuning, DIALOG_STYLE_LIST, "Felni felszerel�se", "Leszerel�s\nOffroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar", "Kiv�laszt", "M�gse");
		case D_TUNING_FELNI_MEG: 		{	tformat(256, "Vess egy pillant�st a j�rm�vedre, �gy n�zne ki, ha felszereln�d a tuning cuccot!\nVal�ban fel szeretn�d szerelni a j�rm�re a k�vetkez�t: %s?\nA m�velet %s forintba fog ker�lni!", D_Tuning_Item[D_Tuning_SelectedItem[playerid][1]], FormatInt(D_Tuning_ItemCost[playerid])); CustomDialog(playerid, D:tuning, DIALOG_STYLE_MSGBOX, "Kin�zet", _tmpString, "Meger�s�t�s", "M�gse"); }
		case D_TUNING_MATRICA:				CustomDialog(playerid, D:tuning, DIALOG_STYLE_LIST, "Matrica felragaszt�sa", "1. st�lus\n2. st�lus\n3. st�lus\nLeszed�s", "Meger�s�t�s", "M�gse");
		case D_TUNING_MATRICA_MEG:		{	tformat(256, "Vess egy pillant�st a j�rm�vedre, �gy n�zne ki, ha felszereln�d a tuning cuccot!\nVal�ban fel szeretn�d szerelni a j�rm�re a k�vetkez�t: %s?\nA m�velet %s forintba fog ker�lni!", D_Tuning_Item[D_Tuning_SelectedItem[playerid][1]], FormatInt(D_Tuning_ItemCost[playerid])); CustomDialog(playerid, D:tuning, DIALOG_STYLE_MSGBOX, "Kin�zet", _tmpString, "Meger�s�t�s", "M�gse"); }
		case D_TUNING_TUNINGPACK:			CustomDialog(playerid, D:tuning, DIALOG_STYLE_LIST, "Tuningpack felszerel�se", "Leszed�s\nAlien\nX-Flow", "Meger�s�t�s", "M�gse");
		case D_TUNING_TUNINGPACK_MEG:	{	tformat(256, "Vess egy pillant�st a j�rm�vedre, �gy n�zne ki, ha felszereln�d a tuning cuccot!\nVal�ban fel szeretn�d szerelni a j�rm�re a k�vetkez�t: %s?\nA m�velet %s forintba fog ker�lni!\n\nFigyelem! A m�velet ut�n minden m�s egyedi tuning elt�nik, �s m�s tuningot nem rakhatsz a kocsira!", D_Tuning_Item[D_Tuning_SelectedItem[playerid][1]], FormatInt(D_Tuning_ItemCost[playerid])); CustomDialog(playerid, D:tuning, DIALOG_STYLE_MSGBOX, "Kin�zet", _tmpString, "Meger�s�t�s", "M�gse"); }
		case D_TUNING_MOTORHAZTETO:			CustomDialog(playerid, D:tuning, DIALOG_STYLE_LIST, "Motorh�ztet� felszerel�se", "Leszed�s\nFury\nChamp\nRace\nWorx", "Meger�s�t�s", "M�gse");
		case D_TUNING_MOTORHAZTETO_MEG:	{	tformat(256, "Vess egy pillant�st a j�rm�vedre, �gy n�zne ki, ha felszereln�d a tuning cuccot!\nVal�ban fel szeretn�d szerelni a j�rm�re a k�vetkez�t: %s?\nA m�velet %s forintba fog ker�lni!", D_Tuning_Item[D_Tuning_SelectedItem[playerid][1]], FormatInt(D_Tuning_ItemCost[playerid])); CustomDialog(playerid, D:tuning, DIALOG_STYLE_MSGBOX, "Kin�zet", _tmpString, "Meger�s�t�s", "M�gse"); }
		case D_TUNING_SZELLOZO:				CustomDialog(playerid, D:tuning, DIALOG_STYLE_LIST, "Szell�z� felszerel�se", "Leszed�s\nOv�lis\nN�gyzetes", "Meger�s�t�s", "M�gse");
		case D_TUNING_SZELLOZO_MEG:		{	tformat(256, "Vess egy pillant�st a j�rm�vedre, �gy n�zne ki, ha felszereln�d a tuning cuccot!\nVal�ban fel szeretn�d szerelni a j�rm�re a k�vetkez�t: %s?\nA m�velet %s forintba fog ker�lni!", D_Tuning_Item[D_Tuning_SelectedItem[playerid][1]], FormatInt(D_Tuning_ItemCost[playerid])); CustomDialog(playerid, D:tuning, DIALOG_STYLE_MSGBOX, "Kin�zet", _tmpString, "Meger�s�t�s", "M�gse"); }
		case D_TUNING_LAMPA:				CustomDialog(playerid, D:tuning, DIALOG_STYLE_LIST, "L�mpast�lus felszerel�se", "Leszed�s\nK�r alak�\nN�gyzetes", "Meger�s�t�s", "M�gse");
		case D_TUNING_LAMPA_MEG: 		{	tformat(256, "Vess egy pillant�st a j�rm�vedre, �gy n�zne ki, ha felszereln�d a tuning cuccot!\nVal�ban fel szeretn�d szerelni a j�rm�re a k�vetkez�t: %s?\nA m�velet %s forintba fog ker�lni!", D_Tuning_Item[D_Tuning_SelectedItem[playerid][1]], FormatInt(D_Tuning_ItemCost[playerid])); CustomDialog(playerid, D:tuning, DIALOG_STYLE_MSGBOX, "Kin�zet", _tmpString, "Meger�s�t�s", "M�gse"); }
		case D_TUNING_KIPUFOGO:				CustomDialog(playerid, D:tuning, DIALOG_STYLE_LIST, "Kipufog� felszerel�se", "Leszed�s\nTransfender Nagy kipufog�\nTransfender K�zepes kipufog�\nTransfender Kicsi kipufog�\nTransfender Dupla kipufog�\nTransfender �velt kipufog�", "Meger�s�t�s", "M�gse");
		case D_TUNING_KIPUFOGO_MEG:		{	tformat(256, "Vess egy pillant�st a j�rm�vedre, �gy n�zne ki, ha felszereln�d a tuning cuccot!\nVal�ban fel szeretn�d szerelni a j�rm�re a k�vetkez�t: %s?\nA m�velet %s forintba fog ker�lni!", D_Tuning_Item[D_Tuning_SelectedItem[playerid][1]], FormatInt(D_Tuning_ItemCost[playerid])); CustomDialog(playerid, D:tuning, DIALOG_STYLE_MSGBOX, "Kin�zet", _tmpString, "Meger�s�t�s", "M�gse"); }
		case D_TUNING_TETO:					CustomDialog(playerid, D:tuning, DIALOG_STYLE_LIST, "Tet�szell�z� felszerel�se", "Leszed�s\nWheel Arc. Alien tet�szell�z�\nWheel Arc. X-Flow tet�szell�z�\nLow Co. sz�nsz�las tet�szell�z�\nLow Co. sz�vet tet�szell�z�\nTransfender tet�szell�z�", "Meger�s�t�s", "M�gse");
		case D_TUNING_TETO_MEG:			{	tformat(256, "Vess egy pillant�st a j�rm�vedre, �gy n�zne ki, ha felszereln�d a tuning cuccot!\nVal�ban fel szeretn�d szerelni a j�rm�re a k�vetkez�t: %s?\nA m�velet %s forintba fog ker�lni!", D_Tuning_Item[D_Tuning_SelectedItem[playerid][1]], FormatInt(D_Tuning_ItemCost[playerid])); CustomDialog(playerid, D:tuning, DIALOG_STYLE_MSGBOX, "Kin�zet", _tmpString, "Meger�s�t�s", "M�gse"); }
		case D_TUNING_SPOILER:				CustomDialog(playerid, D:tuning, DIALOG_STYLE_LIST, "Spoiler felszerel�se", "Leszed�s\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Drag Spoiler", "Meger�s�t�s", "M�gse");
		case D_TUNING_SPOILER_MEG:		{	tformat(256, "Vess egy pillant�st a j�rm�vedre, �gy n�zne ki, ha felszereln�d a tuning cuccot!\nVal�ban fel szeretn�d szerelni a j�rm�re a k�vetkez�t: %s?\nA m�velet %s forintba fog ker�lni!", D_Tuning_Item[D_Tuning_SelectedItem[playerid][1]], FormatInt(D_Tuning_ItemCost[playerid])); CustomDialog(playerid, D:tuning, DIALOG_STYLE_MSGBOX, "Kin�zet", _tmpString, "Meger�s�t�s", "M�gse"); }
		case D_TUNING_DISZ:					CustomDialog(playerid, D:tuning, DIALOG_STYLE_LIST, "J�rm�d�sz felszerel�se", "Leszed�s\nLocos Chrome Grill\nLocos Chrome Bars\nLocos Chrome Lights\nLocos Chrome Bullbar", "Meger�s�t�s", "M�gse");
		case D_TUNING_DISZ_MEG:			{	tformat(256, "Vess egy pillant�st a j�rm�vedre, �gy n�zne ki, ha felszereln�d a tuning cuccot!\nVal�ban fel szeretn�d szerelni a j�rm�re a k�vetkez�t: %s?\nA m�velet %s forintba fog ker�lni!", D_Tuning_Item[D_Tuning_SelectedItem[playerid][1]], FormatInt(D_Tuning_ItemCost[playerid])); CustomDialog(playerid, D:tuning, DIALOG_STYLE_MSGBOX, "Kin�zet", _tmpString, "Meger�s�t�s", "M�gse"); }
		case D_TUNING_MEGEROSIT: 		{	tformat(256, "K�sz�nj�k a v�s�rl�st!\n\nV�s�rolt elem: %s\nFizetett �sszeg: %s Ft", D_Tuning_Item[D_Tuning_SelectedItem[playerid][1]], FormatInt(D_Tuning_ItemCost[playerid])); CustomDialog(playerid, D:tuning, DIALOG_STYLE_MSGBOX, "Nyugta", _tmpString, "Rendben", ""); }
	}
	return 1;
}

Dialog:tuning_old(playerid, response, listitem, inputtext[])
{
	new vehicle = GetPlayerVehicleID(playerid);
	new vs = IsAVsKocsi(vehicle);
	new model = CarInfo[vs][cModel];
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return 1;
	if(!response)
	{
		switch(D_Tuning[playerid])
		{
			case D_TUNING_ALAP, D_TUNING_MEGEROSIT, D_TUNING_HIDRAULIKA_MEG: return 1;
			case D_TUNING_FESTES, D_TUNING_RIASZTO, D_TUNING_NEON, D_TUNING_HIDRAULIKA, D_TUNING_DETEKTOR, D_TUNING_FELNI, D_TUNING_MATRICA, D_TUNING_TUNINGPACK, D_TUNING_MOTORHAZTETO, D_TUNING_SZELLOZO, D_TUNING_LAMPA, D_TUNING_KIPUFOGO, D_TUNING_TETO, D_TUNING_SPOILER, D_TUNING_DISZ:
			{
				D_Tuning[playerid] = D_TUNING_ALAP;
				D_Tuning_ItemCost[playerid] = 0;
				ShowVehicleEditor(playerid);
				return 1;
			}
			case D_TUNING_FESTES_MEG: 		{ 	D_Tuning[playerid] = D_TUNING_FESTES; ShowVehicleEditor(playerid); SetVehicleColor(vehicle, CarInfo[vs][cColorOne], CarInfo[vs][cColorTwo]); D_Tuning_ItemCost[playerid] = 0; return 1; 		}
			case D_TUNING_RIASZTO_MEG: 		{ 	D_Tuning[playerid] = D_TUNING_RIASZTO; ShowVehicleEditor(playerid); D_Tuning_ItemCost[playerid] = 0; return 1; 		}
			case D_TUNING_NEON_MEG: 		{ 	D_Tuning[playerid] = D_TUNING_NEON; ShowVehicleEditor(playerid); if(IsValidDynamicObject(NeonCar[vehicle][0])) DestroyDynamicObject(NeonCar[vehicle][0]), NeonCar[vehicle][0]=INVALID_OBJECT_ID; if(IsValidDynamicObject(NeonCar[vehicle][1])) DestroyDynamicObject(NeonCar[vehicle][1]), NeonCar[vehicle][1]=INVALID_OBJECT_ID; Neon[vehicle] = 0; D_Tuning_ItemCost[playerid] = 0; return 1; 			}
			case D_TUNING_DETEKTOR_MEG: 	{ 	D_Tuning[playerid] = D_TUNING_DETEKTOR; ShowVehicleEditor(playerid); D_Tuning_ItemCost[playerid] = 0; return 1; 		}
			case D_TUNING_FELNI_MEG: 		{	D_Tuning[playerid] = D_TUNING_FELNI; ShowVehicleEditor(playerid); AddVehicleComponent(vehicle, CarInfo[vs][cKerek]); D_Tuning_ItemCost[playerid] = 0; return 1; 		}
			case D_TUNING_MATRICA_MEG: 		{	D_Tuning[playerid] = D_TUNING_MATRICA; ShowVehicleEditor(playerid); ChangeVehiclePaintjob(vehicle, CarInfo[vs][cMatrica]); D_Tuning_ItemCost[playerid] = 0; return 1; 		}
			case D_TUNING_TUNINGPACK_MEG: 	{ 	D_Tuning[playerid] = D_TUNING_TUNINGPACK; ShowVehicleEditor(playerid); JarmuTuning(vehicle); D_Tuning_ItemCost[playerid] = 0; return 1; 	}
			case D_TUNING_MOTORHAZTETO_MEG: { 	D_Tuning[playerid] = D_TUNING_MOTORHAZTETO; ShowVehicleEditor(playerid); JarmuTuning(vehicle); D_Tuning_ItemCost[playerid] = 0; return 1; 	}
			case D_TUNING_SZELLOZO_MEG: 	{	D_Tuning[playerid] = D_TUNING_SZELLOZO; ShowVehicleEditor(playerid); JarmuTuning(vehicle); D_Tuning_ItemCost[playerid] = 0; return 1; 		}
			case D_TUNING_LAMPA_MEG: 		{ 	D_Tuning[playerid] = D_TUNING_LAMPA; ShowVehicleEditor(playerid); JarmuTuning(vehicle); D_Tuning_ItemCost[playerid] = 0; return 1; 		}
			case D_TUNING_KIPUFOGO_MEG: 	{	D_Tuning[playerid] = D_TUNING_KIPUFOGO; ShowVehicleEditor(playerid); JarmuTuning(vehicle); D_Tuning_ItemCost[playerid] = 0; return 1; 		}
			case D_TUNING_TETO_MEG: 		{ 	D_Tuning[playerid] = D_TUNING_TETO; ShowVehicleEditor(playerid); JarmuTuning(vehicle); D_Tuning_ItemCost[playerid] = 0; return 1; 			}
			case D_TUNING_SPOILER_MEG: 		{ 	D_Tuning[playerid] = D_TUNING_SPOILER; ShowVehicleEditor(playerid); JarmuTuning(vehicle); D_Tuning_ItemCost[playerid] = 0; return 1; 		}
			case D_TUNING_DISZ_MEG: 		{ 	D_Tuning[playerid] = D_TUNING_DISZ; ShowVehicleEditor(playerid); JarmuTuning(vehicle); D_Tuning_ItemCost[playerid] = 0; return 1; 			}
		}
	}
	if(D_Tuning[playerid] == D_TUNING_ALAP)
	{
		switch(listitem)
		{
			case 0: //�tfest�s
			{
				if(!IsAt(playerid, IsAt_Festo)) { Msg(playerid,"Nem vagy egy fest�n�l sem! (Pay 'n' Spray)"); ShowVehicleEditor(playerid); return 1; }
				if(!BankkartyaFizet(playerid, 150000, false)) { Msg(playerid,"Nincs el�g p�nzed! 1 fest�s �ra 150.000 Ft!"); ShowVehicleEditor(playerid); return 1; }
				if(vs == NINCS) { Msg(playerid, "Ez nem V-s j�rm�!"); ShowVehicleEditor(playerid); return 1; }
				if(CarInfo[vs][cTulaj] != PlayerInfo[playerid][pID] && CarInfo[vs][cKereskedo] !=  PlayerInfo[playerid][pID]) { Msg(playerid, "Ez nem a te j�rm�ved!"); ShowVehicleEditor(playerid); return 1; }
				new Float:hp;
				GetVehicleHealth(vehicle, hp);
				if(hp < 970) { Msg(playerid, "Nagyon �ssze van t�rve a j�rm�, �gy sajnos nem tudjuk �tfesteni!"); ShowVehicleEditor(playerid); return 1; }
				
				D_Tuning[playerid] = D_TUNING_FESTES;
				ShowVehicleEditor(playerid);
			}
			case 1: //Riaszt�
			{
				if(	!PlayerToPoint(10, playerid, 2165.5876,-2160.5959,13.5469) && // szerel� hq
					!PlayerToPoint(10, playerid, 2156.8228,-2170.3474,13.5469) && // szerel� hq
					!PlayerToPoint(10, playerid, 2146.8403,-2179.5872,13.5469) && // szerel� hq
					!PlayerToPoint(3, playerid, -1917.3201,304.5225,41.0469) && //SF
					!PlayerToPoint(8, playerid, 1341.788, -1834.169, 13.579) && // �j szerel� hq
					!PlayerToPoint(8, playerid, 1357.7452,-1825.3757,13.5837) && // �j szerel� hq
					!PlayerToPoint(10, playerid, 1344.162,-1834.484,13.670) && // ???
					!PlayerToPoint(10, playerid, 2136.6711,-2189.3591,13.5544)) // Szerel� HQ
					{ Msg(playerid, "Nem vagy egy tuningm�helyben sem!"); ShowVehicleEditor(playerid); return 1; }
				if(vs == NINCS) { Msg(playerid, "Ez nem V-s j�rm�!"); ShowVehicleEditor(playerid); return 1; }
				if(CarInfo[vs][cTulaj] != PlayerInfo[playerid][pID] && CarInfo[vs][cKereskedo] !=  PlayerInfo[playerid][pID]) { Msg(playerid, "Ez nem a te j�rm�ved!"); ShowVehicleEditor(playerid); return 1; }
				
				D_Tuning[playerid] = D_TUNING_RIASZTO;
				ShowVehicleEditor(playerid);
			}
			case 2: //Neon
			{
				if(	!PlayerToPoint(10, playerid, 2165.5876,-2160.5959,13.5469) && // szerel� hq
					!PlayerToPoint(10, playerid, 2156.8228,-2170.3474,13.5469) && // szerel� hq
					!PlayerToPoint(10, playerid, 2146.8403,-2179.5872,13.5469) && // szerel� hq
					!PlayerToPoint(3, playerid, -1917.3201,304.5225,41.0469) && //SF
					!PlayerToPoint(8, playerid, 1341.788, -1834.169, 13.579) && // �j szerel� hq
					!PlayerToPoint(8, playerid, 1357.7452,-1825.3757,13.5837) && // �j szerel� hq
					!PlayerToPoint(10, playerid, 1344.162,-1834.484,13.670) && // ???
					!PlayerToPoint(10, playerid, 2136.6711,-2189.3591,13.5544)) // Szerel� HQ
					{ Msg(playerid, "Nem vagy egy tuningm�helyben sem!"); ShowVehicleEditor(playerid); return 1; }
				if(vs == NINCS) { Msg(playerid, "Ez nem V-s j�rm�!"); ShowVehicleEditor(playerid); return 1; }
				if(CarInfo[vs][cTulaj] != PlayerInfo[playerid][pID] && CarInfo[vs][cKereskedo] !=  PlayerInfo[playerid][pID]) { Msg(playerid, "Ez nem a te j�rm�ved!"); ShowVehicleEditor(playerid); return 1; }
				
				D_Tuning[playerid] = D_TUNING_NEON;
				ShowVehicleEditor(playerid);
			}
			case 3: //Hidraulika
			{
				if(	!PlayerToPoint(10, playerid, 2165.5876,-2160.5959,13.5469) && // szerel� hq
					!PlayerToPoint(10, playerid, 2156.8228,-2170.3474,13.5469) && // szerel� hq
					!PlayerToPoint(10, playerid, 2146.8403,-2179.5872,13.5469) && // szerel� hq
					!PlayerToPoint(3, playerid, -1917.3201,304.5225,41.0469) && //SF
					!PlayerToPoint(8, playerid, 1341.788, -1834.169, 13.579) && // �j szerel� hq
					!PlayerToPoint(8, playerid, 1357.7452,-1825.3757,13.5837) && // �j szerel� hq
					!PlayerToPoint(10, playerid, 1344.162,-1834.484,13.670) && // ???
					!PlayerToPoint(10, playerid, 2136.6711,-2189.3591,13.5544)) // Szerel� HQ
					{ Msg(playerid, "Nem vagy egy tuningm�helyben sem!"); ShowVehicleEditor(playerid); return 1; }
				if(vs == NINCS) { Msg(playerid, "Ez nem V-s j�rm�!"); ShowVehicleEditor(playerid); return 1; }
				if(CarInfo[vs][cTulaj] != PlayerInfo[playerid][pID] && CarInfo[vs][cKereskedo] !=  PlayerInfo[playerid][pID]) { Msg(playerid, "Ez nem a te j�rm�ved!"); ShowVehicleEditor(playerid); return 1; }
				
				D_Tuning[playerid] = D_TUNING_HIDRAULIKA;
				ShowVehicleEditor(playerid);
			}
			case 4: //Detektor
			{
				if(	!PlayerToPoint(10, playerid, 2165.5876,-2160.5959,13.5469) && // szerel� hq
					!PlayerToPoint(10, playerid, 2156.8228,-2170.3474,13.5469) && // szerel� hq
					!PlayerToPoint(10, playerid, 2146.8403,-2179.5872,13.5469) && // szerel� hq
					!PlayerToPoint(3, playerid, -1917.3201,304.5225,41.0469) && //SF
					!PlayerToPoint(8, playerid, 1341.788, -1834.169, 13.579) && // �j szerel� hq
					!PlayerToPoint(8, playerid, 1357.7452,-1825.3757,13.5837) && // �j szerel� hq
					!PlayerToPoint(10, playerid, 1344.162,-1834.484,13.670) && // ???
					!PlayerToPoint(10, playerid, 2136.6711,-2189.3591,13.5544)) // Szerel� HQ
					{ Msg(playerid, "Nem vagy egy tuningm�helyben sem!"); ShowVehicleEditor(playerid); return 1; }
				if(vs == NINCS) { Msg(playerid, "Ez nem V-s j�rm�!"); ShowVehicleEditor(playerid); return 1; }
				if(CarInfo[vs][cTulaj] != PlayerInfo[playerid][pID] && CarInfo[vs][cKereskedo] !=  PlayerInfo[playerid][pID]) { Msg(playerid, "Ez nem a te j�rm�ved!"); ShowVehicleEditor(playerid); return 1; }
				
				D_Tuning[playerid] = D_TUNING_DETEKTOR;
				ShowVehicleEditor(playerid);
			}
			case 5: //Felni
			{
				if(	!PlayerToPoint(10, playerid, 2165.5876,-2160.5959,13.5469) && // szerel� hq
					!PlayerToPoint(10, playerid, 2156.8228,-2170.3474,13.5469) && // szerel� hq
					!PlayerToPoint(10, playerid, 2146.8403,-2179.5872,13.5469) && // szerel� hq
					!PlayerToPoint(3, playerid, -1917.3201,304.5225,41.0469) && //SF
					!PlayerToPoint(8, playerid, 1341.788, -1834.169, 13.579) && // �j szerel� hq
					!PlayerToPoint(8, playerid, 1357.7452,-1825.3757,13.5837) && // �j szerel� hq
					!PlayerToPoint(10, playerid, 1344.162,-1834.484,13.670) && // ???
					!PlayerToPoint(10, playerid, 2136.6711,-2189.3591,13.5544)) // Szerel� HQ
					{ Msg(playerid, "Nem vagy egy tuningm�helyben sem!"); ShowVehicleEditor(playerid); return 1; }
				if(vs == NINCS) { Msg(playerid, "Ez nem V-s j�rm�!"); ShowVehicleEditor(playerid); return 1; }
				if(CarInfo[vs][cTulaj] != PlayerInfo[playerid][pID] && CarInfo[vs][cKereskedo] !=  PlayerInfo[playerid][pID]) { Msg(playerid, "Ez nem a te j�rm�ved!"); ShowVehicleEditor(playerid); return 1; }
				
				D_Tuning[playerid] = D_TUNING_FELNI;
				ShowVehicleEditor(playerid);
			}
			case 6: //Matrica
			{
				if(	!PlayerToPoint(10, playerid, 2165.5876,-2160.5959,13.5469) && // szerel� hq
					!PlayerToPoint(10, playerid, 2156.8228,-2170.3474,13.5469) && // szerel� hq
					!PlayerToPoint(10, playerid, 2146.8403,-2179.5872,13.5469) && // szerel� hq
					!PlayerToPoint(3, playerid, -1917.3201,304.5225,41.0469) && //SF
					!PlayerToPoint(8, playerid, 1341.788, -1834.169, 13.579) && // �j szerel� hq
					!PlayerToPoint(8, playerid, 1357.7452,-1825.3757,13.5837) && // �j szerel� hq
					!PlayerToPoint(10, playerid, 1344.162,-1834.484,13.670) && // ???
					!PlayerToPoint(10, playerid, 2136.6711,-2189.3591,13.5544)) // Szerel� HQ
					{ Msg(playerid, "Nem vagy egy tuningm�helyben sem!"); ShowVehicleEditor(playerid); return 1; }
				if(vs == NINCS) { Msg(playerid, "Ez nem V-s j�rm�!"); ShowVehicleEditor(playerid); return 1; }
				if(CarInfo[vs][cTulaj] != PlayerInfo[playerid][pID] && CarInfo[vs][cKereskedo] !=  PlayerInfo[playerid][pID]) { Msg(playerid, "Ez nem a te j�rm�ved!"); ShowVehicleEditor(playerid); return 1; }
				
				D_Tuning[playerid] = D_TUNING_MATRICA;
				ShowVehicleEditor(playerid);
			}
			case 7: //Tuningpack (Alien/Xflow)
			{
				if(	!PlayerToPoint(10, playerid, 2165.5876,-2160.5959,13.5469) && // szerel� hq
					!PlayerToPoint(10, playerid, 2156.8228,-2170.3474,13.5469) && // szerel� hq
					!PlayerToPoint(10, playerid, 2146.8403,-2179.5872,13.5469) && // szerel� hq
					!PlayerToPoint(3, playerid, -1917.3201,304.5225,41.0469) && //SF
					!PlayerToPoint(8, playerid, 1341.788, -1834.169, 13.579) && // �j szerel� hq
					!PlayerToPoint(8, playerid, 1357.7452,-1825.3757,13.5837) && // �j szerel� hq
					!PlayerToPoint(10, playerid, 1344.162,-1834.484,13.670) && // ???
					!PlayerToPoint(10, playerid, 2136.6711,-2189.3591,13.5544)) // Szerel� HQ
					{ Msg(playerid, "Nem vagy egy tuningm�helyben sem!"); ShowVehicleEditor(playerid); return 1; }
				if(vs == NINCS) { Msg(playerid, "Ez nem V-s j�rm�!"); ShowVehicleEditor(playerid); return 1; }
				if(CarInfo[vs][cTulaj] != PlayerInfo[playerid][pID] && CarInfo[vs][cKereskedo] !=  PlayerInfo[playerid][pID]) { Msg(playerid, "Ez nem a te j�rm�ved!"); ShowVehicleEditor(playerid); return 1; }
				
				D_Tuning[playerid] = D_TUNING_TUNINGPACK;
				ShowVehicleEditor(playerid);
			}
			case 8: //Motorh�ztet�
			{
				if(	!PlayerToPoint(10, playerid, 2165.5876,-2160.5959,13.5469) && // szerel� hq
					!PlayerToPoint(10, playerid, 2156.8228,-2170.3474,13.5469) && // szerel� hq
					!PlayerToPoint(10, playerid, 2146.8403,-2179.5872,13.5469) && // szerel� hq
					!PlayerToPoint(3, playerid, -1917.3201,304.5225,41.0469) && //SF
					!PlayerToPoint(8, playerid, 1341.788, -1834.169, 13.579) && // �j szerel� hq
					!PlayerToPoint(8, playerid, 1357.7452,-1825.3757,13.5837) && // �j szerel� hq
					!PlayerToPoint(10, playerid, 1344.162,-1834.484,13.670) && // ???
					!PlayerToPoint(10, playerid, 2136.6711,-2189.3591,13.5544)) // Szerel� HQ
					{ Msg(playerid, "Nem vagy egy tuningm�helyben sem!"); ShowVehicleEditor(playerid); return 1; }
				if(vs == NINCS) { Msg(playerid, "Ez nem V-s j�rm�!"); ShowVehicleEditor(playerid); return 1; }
				if(CarInfo[vs][cTulaj] != PlayerInfo[playerid][pID] && CarInfo[vs][cKereskedo] !=  PlayerInfo[playerid][pID]) { Msg(playerid, "Ez nem a te j�rm�ved!"); ShowVehicleEditor(playerid); return 1; }
				
				D_Tuning[playerid] = D_TUNING_MOTORHAZTETO;
				ShowVehicleEditor(playerid);
			}
			case 9: // Szell�z�
			{
				if(	!PlayerToPoint(10, playerid, 2165.5876,-2160.5959,13.5469) && // szerel� hq
					!PlayerToPoint(10, playerid, 2156.8228,-2170.3474,13.5469) && // szerel� hq
					!PlayerToPoint(10, playerid, 2146.8403,-2179.5872,13.5469) && // szerel� hq
					!PlayerToPoint(3, playerid, -1917.3201,304.5225,41.0469) && //SF
					!PlayerToPoint(8, playerid, 1341.788, -1834.169, 13.579) && // �j szerel� hq
					!PlayerToPoint(8, playerid, 1357.7452,-1825.3757,13.5837) && // �j szerel� hq
					!PlayerToPoint(10, playerid, 1344.162,-1834.484,13.670) && // ???
					!PlayerToPoint(10, playerid, 2136.6711,-2189.3591,13.5544)) // Szerel� HQ
					{ Msg(playerid, "Nem vagy egy tuningm�helyben sem!"); ShowVehicleEditor(playerid); return 1; }
				if(vs == NINCS) { Msg(playerid, "Ez nem V-s j�rm�!"); ShowVehicleEditor(playerid); return 1; }
				if(CarInfo[vs][cTulaj] != PlayerInfo[playerid][pID] && CarInfo[vs][cKereskedo] !=  PlayerInfo[playerid][pID]) { Msg(playerid, "Ez nem a te j�rm�ved!"); ShowVehicleEditor(playerid); return 1; }
				
				D_Tuning[playerid] = D_TUNING_SZELLOZO;
				ShowVehicleEditor(playerid);
			}
			case 10: //L�mpa
			{
				if(	!PlayerToPoint(10, playerid, 2165.5876,-2160.5959,13.5469) && // szerel� hq
					!PlayerToPoint(10, playerid, 2156.8228,-2170.3474,13.5469) && // szerel� hq
					!PlayerToPoint(10, playerid, 2146.8403,-2179.5872,13.5469) && // szerel� hq
					!PlayerToPoint(3, playerid, -1917.3201,304.5225,41.0469) && //SF
					!PlayerToPoint(8, playerid, 1341.788, -1834.169, 13.579) && // �j szerel� hq
					!PlayerToPoint(8, playerid, 1357.7452,-1825.3757,13.5837) && // �j szerel� hq
					!PlayerToPoint(10, playerid, 1344.162,-1834.484,13.670) && // ???
					!PlayerToPoint(10, playerid, 2136.6711,-2189.3591,13.5544)) // Szerel� HQ
					{ Msg(playerid, "Nem vagy egy tuningm�helyben sem!"); ShowVehicleEditor(playerid); return 1; }
				if(vs == NINCS) { Msg(playerid, "Ez nem V-s j�rm�!"); ShowVehicleEditor(playerid); return 1; }
				if(CarInfo[vs][cTulaj] != PlayerInfo[playerid][pID] && CarInfo[vs][cKereskedo] !=  PlayerInfo[playerid][pID]) { Msg(playerid, "Ez nem a te j�rm�ved!"); ShowVehicleEditor(playerid); return 1; }
				
				D_Tuning[playerid] = D_TUNING_LAMPA;
				ShowVehicleEditor(playerid);
			}
			case 11: //Kipufog�
			{
				if(	!PlayerToPoint(10, playerid, 2165.5876,-2160.5959,13.5469) && // szerel� hq
					!PlayerToPoint(10, playerid, 2156.8228,-2170.3474,13.5469) && // szerel� hq
					!PlayerToPoint(10, playerid, 2146.8403,-2179.5872,13.5469) && // szerel� hq
					!PlayerToPoint(3, playerid, -1917.3201,304.5225,41.0469) && //SF
					!PlayerToPoint(8, playerid, 1341.788, -1834.169, 13.579) && // �j szerel� hq
					!PlayerToPoint(8, playerid, 1357.7452,-1825.3757,13.5837) && // �j szerel� hq
					!PlayerToPoint(10, playerid, 1344.162,-1834.484,13.670) && // ???
					!PlayerToPoint(10, playerid, 2136.6711,-2189.3591,13.5544)) // Szerel� HQ
					{ Msg(playerid, "Nem vagy egy tuningm�helyben sem!"); ShowVehicleEditor(playerid); return 1; }
				if(vs == NINCS) { Msg(playerid, "Ez nem V-s j�rm�!"); ShowVehicleEditor(playerid); return 1; }
				if(CarInfo[vs][cTulaj] != PlayerInfo[playerid][pID] && CarInfo[vs][cKereskedo] !=  PlayerInfo[playerid][pID]) { Msg(playerid, "Ez nem a te j�rm�ved!"); ShowVehicleEditor(playerid); return 1; }
				
				D_Tuning[playerid] = D_TUNING_KIPUFOGO;
				ShowVehicleEditor(playerid);
			}
			case 12: //Tet�
			{
				if(	!PlayerToPoint(10, playerid, 2165.5876,-2160.5959,13.5469) && // szerel� hq
					!PlayerToPoint(10, playerid, 2156.8228,-2170.3474,13.5469) && // szerel� hq
					!PlayerToPoint(10, playerid, 2146.8403,-2179.5872,13.5469) && // szerel� hq
					!PlayerToPoint(3, playerid, -1917.3201,304.5225,41.0469) && //SF
					!PlayerToPoint(8, playerid, 1341.788, -1834.169, 13.579) && // �j szerel� hq
					!PlayerToPoint(8, playerid, 1357.7452,-1825.3757,13.5837) && // �j szerel� hq
					!PlayerToPoint(10, playerid, 1344.162,-1834.484,13.670) && // ???
					!PlayerToPoint(10, playerid, 2136.6711,-2189.3591,13.5544)) // Szerel� HQ
					{ Msg(playerid, "Nem vagy egy tuningm�helyben sem!"); ShowVehicleEditor(playerid); return 1; }
				if(vs == NINCS) { Msg(playerid, "Ez nem V-s j�rm�!"); ShowVehicleEditor(playerid); return 1; }
				if(CarInfo[vs][cTulaj] != PlayerInfo[playerid][pID] && CarInfo[vs][cKereskedo] !=  PlayerInfo[playerid][pID]) { Msg(playerid, "Ez nem a te j�rm�ved!"); ShowVehicleEditor(playerid); return 1; }
				
				D_Tuning[playerid] = D_TUNING_TETO;
				ShowVehicleEditor(playerid);
			}
			case 13: //Spoiler
			{
				if(	!PlayerToPoint(10, playerid, 2165.5876,-2160.5959,13.5469) && // szerel� hq
					!PlayerToPoint(10, playerid, 2156.8228,-2170.3474,13.5469) && // szerel� hq
					!PlayerToPoint(10, playerid, 2146.8403,-2179.5872,13.5469) && // szerel� hq
					!PlayerToPoint(3, playerid, -1917.3201,304.5225,41.0469) && //SF
					!PlayerToPoint(8, playerid, 1341.788, -1834.169, 13.579) && // �j szerel� hq
					!PlayerToPoint(8, playerid, 1357.7452,-1825.3757,13.5837) && // �j szerel� hq
					!PlayerToPoint(10, playerid, 1344.162,-1834.484,13.670) && // ???
					!PlayerToPoint(10, playerid, 2136.6711,-2189.3591,13.5544)) // Szerel� HQ
					{ Msg(playerid, "Nem vagy egy tuningm�helyben sem!"); ShowVehicleEditor(playerid); return 1; }
				if(vs == NINCS) { Msg(playerid, "Ez nem V-s j�rm�!"); ShowVehicleEditor(playerid); return 1; }
				if(CarInfo[vs][cTulaj] != PlayerInfo[playerid][pID] && CarInfo[vs][cKereskedo] !=  PlayerInfo[playerid][pID]) { Msg(playerid, "Ez nem a te j�rm�ved!"); ShowVehicleEditor(playerid); return 1; }
				
				D_Tuning[playerid] = D_TUNING_SPOILER;
				ShowVehicleEditor(playerid);
			}
			case 14: //D�sz
			{
				if(	!PlayerToPoint(10, playerid, 2165.5876,-2160.5959,13.5469) && // szerel� hq
					!PlayerToPoint(10, playerid, 2156.8228,-2170.3474,13.5469) && // szerel� hq
					!PlayerToPoint(10, playerid, 2146.8403,-2179.5872,13.5469) && // szerel� hq
					!PlayerToPoint(3, playerid, -1917.3201,304.5225,41.0469) && //SF
					!PlayerToPoint(8, playerid, 1341.788, -1834.169, 13.579) && // �j szerel� hq
					!PlayerToPoint(8, playerid, 1357.7452,-1825.3757,13.5837) && // �j szerel� hq
					!PlayerToPoint(10, playerid, 1344.162,-1834.484,13.670) && // ???
					!PlayerToPoint(10, playerid, 2136.6711,-2189.3591,13.5544)) // Szerel� HQ
					{ Msg(playerid, "Nem vagy egy tuningm�helyben sem!"); ShowVehicleEditor(playerid); return 1; }
				if(vs == NINCS) { Msg(playerid, "Ez nem V-s j�rm�!"); ShowVehicleEditor(playerid); return 1; }
				if(CarInfo[vs][cTulaj] != PlayerInfo[playerid][pID] && CarInfo[vs][cKereskedo] !=  PlayerInfo[playerid][pID]) { Msg(playerid, "Ez nem a te j�rm�ved!"); ShowVehicleEditor(playerid); return 1; }
				
				D_Tuning[playerid] = D_TUNING_DISZ;
				ShowVehicleEditor(playerid);
			}
		}
	}
	elseif(D_Tuning[playerid] == D_TUNING_FESTES)
	{
		new szin[2];
		if(!sscanf(inputtext, "p<,>dd", szin[0], szin[1]))
		{
			if(szin[0] < 0 && szin[0] > 255) return ShowVehicleEditor(playerid);
			if(szin[1] < 0 && szin[1] > 255) return ShowVehicleEditor(playerid);
			
			SetVehicleColor(vehicle, szin[0], szin[1]);
			PlayerPlaySound(playerid, 1134, 0.0, 0.0, 0.0);
			
			D_Festes[playerid][0] = szin[0];
			D_Festes[playerid][1] = szin[1];
			D_Tuning[playerid] = D_TUNING_FESTES_MEG;
			D_Tuning_ItemCost[playerid] = 150000;
			ShowVehicleEditor(playerid);
		}
		else ShowVehicleEditor(playerid);
	}
	elseif(D_Tuning[playerid] == D_TUNING_FESTES_MEG)
	{
		if(CarInfo[vs][cColorOne] != D_Festes[playerid][0] || CarInfo[vs][cColorTwo] != D_Festes[playerid][1])
			CarInfo[vs][cPainted] = 1;
		else
			CarInfo[vs][cPainted] = 0;
	
		CarInfo[vs][cColorOne] = D_Festes[playerid][0];
		CarInfo[vs][cColorTwo] = D_Festes[playerid][1];
		CarUpdate(vs, CAR_ColorOne, CAR_ColorTwo);
		
		BizPenz(BIZ_FIXCAR, 150000);
		BankkartyaFizet(playerid, 150000);
		
		D_Tuning[playerid] = D_TUNING_MEGEROSIT;
		D_Tuning_SelectedItem[playerid][0] = 0;
		D_Tuning_SelectedItem[playerid][1] = 0;
		ShowVehicleEditor(playerid);
	}
	elseif(D_Tuning[playerid] == D_TUNING_RIASZTO)
	{
		switch(listitem)
		{
			case 0:
			{
				if(CarInfo[vs][cRiaszto] == 0) return ShowVehicleEditor(playerid);
				D_Tuning[playerid] = D_TUNING_MEGEROSIT;
				D_Tuning_SelectedItem[playerid][0] = listitem;
				D_Tuning_SelectedItem[playerid][1] = 1;
				D_Tuning_ItemCost[playerid] = 0;
				ShowVehicleEditor(playerid);
			}
			case 1:
			{
				D_Tuning[playerid] = D_TUNING_RIASZTO_MEG;
				D_Tuning_SelectedItem[playerid][0] = listitem;
				D_Tuning_SelectedItem[playerid][1] = 1;
				D_Tuning_ItemCost[playerid] = 100000;
				ShowVehicleEditor(playerid);
			}
			case 2:
			{
				D_Tuning[playerid] = D_TUNING_RIASZTO_MEG;
				D_Tuning_SelectedItem[playerid][0] = listitem;
				D_Tuning_SelectedItem[playerid][1] = 1;
				D_Tuning_ItemCost[playerid] = 300000;
				ShowVehicleEditor(playerid);
			}
			case 3:
			{
				D_Tuning[playerid] = D_TUNING_RIASZTO_MEG;
				D_Tuning_SelectedItem[playerid][0] = listitem;
				D_Tuning_SelectedItem[playerid][1] = 1;
				D_Tuning_ItemCost[playerid] = 500000;
				ShowVehicleEditor(playerid);
			}
			case 4:
			{
				D_Tuning[playerid] = D_TUNING_RIASZTO_MEG;
				D_Tuning_SelectedItem[playerid][0] = listitem;
				D_Tuning_SelectedItem[playerid][1] = 1;
				D_Tuning_ItemCost[playerid] = 2000000;
				ShowVehicleEditor(playerid);
			}
		}
	}
	elseif(D_Tuning[playerid] == D_TUNING_RIASZTO_MEG)
	{
		if(!BankkartyaFizet(playerid, D_Tuning_ItemCost[playerid], false)) { SendFormatMessage(playerid, COLOR_LIGHTRED, "ClassRPG: Nincs el�g p�nzed! A tuning �ra %s Ft!", FormatInt(D_Tuning_ItemCost[playerid])); D_Tuning[playerid] = D_TUNING_RIASZTO; D_Tuning_ItemCost[playerid] = 0; ShowVehicleEditor(playerid); return 1; }
		CarInfo[vs][cRiaszto] = D_Tuning_SelectedItem[playerid][0];
		CarUpdate(vs, CAR_Riaszto);
		
		BizPenz(BIZ_TUNING, D_Tuning_ItemCost[playerid]);
		BankkartyaFizet(playerid, D_Tuning_ItemCost[playerid]);
		
		D_Tuning[playerid] = D_TUNING_MEGEROSIT;
		ShowVehicleEditor(playerid);
	}
	elseif(D_Tuning[playerid] == D_TUNING_NEON)
	{
		switch(listitem)
		{
			case 0:
			{
				if(CarInfo[vs][cNeon] == 0) return ShowVehicleEditor(playerid);
				D_Tuning[playerid] = D_TUNING_MEGEROSIT;
				D_Tuning_SelectedItem[playerid][0] = listitem;
				D_Tuning_SelectedItem[playerid][1] = 2;
				ShowVehicleEditor(playerid);
			}
			case 1..6:
			{
				D_Tuning[playerid] = D_TUNING_NEON_MEG;
				D_Tuning_SelectedItem[playerid][0] = listitem;
				D_Tuning_SelectedItem[playerid][1] = 2;
				D_Tuning_ItemCost[playerid] = 1000000;
				ShowVehicleEditor(playerid);
			}
		}
		new neonid = listitem;
		switch(neonid)
		{
			case 1: // k�k
			{
				Neon[vehicle] = 1;
				NeonCar[vehicle][0]=CreateDynamicObject(18648,0,0,0,0,0,0);
				NeonCar[vehicle][1]=CreateDynamicObject(18648,0,0,0,0,0,0);
				AttachDynamicObjectToVehicle(NeonCar[vehicle][0], vehicle, -0.70, 0.06, -0.58,   0.00, 0.00, 0.00);
				AttachDynamicObjectToVehicle(NeonCar[vehicle][1], vehicle, 0.72, 0.05, -0.60,   0.00, 0.00, 0.00);
			}
			case 2: // piros
			{
				Neon[vehicle] = 1;
				NeonCar[vehicle][0]=CreateDynamicObject(18647,0,0,0,0,0,0);
				NeonCar[vehicle][1]=CreateDynamicObject(18647,0,0,0,0,0,0);
				AttachDynamicObjectToVehicle(NeonCar[vehicle][0], vehicle, -0.70, 0.06, -0.58,   0.00, 0.00, 0.00);
				AttachDynamicObjectToVehicle(NeonCar[vehicle][1], vehicle, 0.72, 0.05, -0.60,   0.00, 0.00, 0.00);
			}
			case 3: // r�zsasz�n
			{
				Neon[vehicle] = 1;
				NeonCar[vehicle][0]=CreateDynamicObject(18651,0,0,0,0,0,0);
				NeonCar[vehicle][1]=CreateDynamicObject(18651,0,0,0,0,0,0);
				AttachDynamicObjectToVehicle(NeonCar[vehicle][0], vehicle, -0.70, 0.06, -0.58,   0.00, 0.00, 0.00);
				AttachDynamicObjectToVehicle(NeonCar[vehicle][1], vehicle, 0.72, 0.05, -0.60,   0.00, 0.00, 0.00);
			}
			case 4: // feh�r
			{
				Neon[vehicle] = 1;
				NeonCar[vehicle][0]=CreateDynamicObject(18652,0,0,0,0,0,0);
				NeonCar[vehicle][1]=CreateDynamicObject(18652,0,0,0,0,0,0);
				AttachDynamicObjectToVehicle(NeonCar[vehicle][0], vehicle, -0.70, 0.06, -0.58,   0.00, 0.00, 0.00);
				AttachDynamicObjectToVehicle(NeonCar[vehicle][1], vehicle, 0.72, 0.05, -0.60,   0.00, 0.00, 0.00);
			}
			case 5: // z�ld
			{
				Neon[vehicle] = 1;
				NeonCar[vehicle][0]=CreateDynamicObject(18649,0,0,0,0,0,0);
				NeonCar[vehicle][1]=CreateDynamicObject(18649,0,0,0,0,0,0);
				AttachDynamicObjectToVehicle(NeonCar[vehicle][0], vehicle, -0.70, 0.06, -0.58,   0.00, 0.00, 0.00);
				AttachDynamicObjectToVehicle(NeonCar[vehicle][1], vehicle, 0.72, 0.05, -0.60,   0.00, 0.00, 0.00);
			}
			case 6: // s�rga
			{
				Neon[vehicle] = 1;
				NeonCar[vehicle][0]=CreateDynamicObject(18650,0,0,0,0,0,0);
				NeonCar[vehicle][1]=CreateDynamicObject(18650,0,0,0,0,0,0);
				AttachDynamicObjectToVehicle(NeonCar[vehicle][0], vehicle, -0.70, 0.06, -0.58,   0.00, 0.00, 0.00);
				AttachDynamicObjectToVehicle(NeonCar[vehicle][1], vehicle, 0.72, 0.05, -0.60,   0.00, 0.00, 0.00);
			}
		}
	}
	elseif(D_Tuning[playerid] == D_TUNING_NEON_MEG)
	{
		if(!BankkartyaFizet(playerid, D_Tuning_ItemCost[playerid], false)) { SendFormatMessage(playerid, COLOR_LIGHTRED, "ClassRPG: Nincs el�g p�nzed! A tuning �ra %s Ft!", FormatInt(D_Tuning_ItemCost[playerid])); D_Tuning[playerid] = D_TUNING_NEON; D_Tuning_ItemCost[playerid] = 0; ShowVehicleEditor(playerid); return 1; }
		CarInfo[vs][cNeon] = D_Tuning_SelectedItem[playerid][0];
		CarUpdate(vs, CAR_Neon);
		
		BizPenz(BIZ_TUNING, D_Tuning_ItemCost[playerid]);
		BankkartyaFizet(playerid, D_Tuning_ItemCost[playerid]);
		
		D_Tuning[playerid] = D_TUNING_MEGEROSIT;
		ShowVehicleEditor(playerid);
	}
	elseif(D_Tuning[playerid] == D_TUNING_HIDRAULIKA)
	{
		if(CarInfo[vs][cHidraulika] == 0)
		{
			D_Tuning[playerid] = D_TUNING_HIDRAULIKA_MEG;
			D_Tuning_SelectedItem[playerid][0] = 1;
			D_Tuning_SelectedItem[playerid][1] = 3;
			D_Tuning_ItemCost[playerid] = 2000000;
			ShowVehicleEditor(playerid);
		}
		else
		{
			D_Tuning[playerid] = D_TUNING_MEGEROSIT;
			D_Tuning_SelectedItem[playerid][0] = 0;
			D_Tuning_SelectedItem[playerid][1] = 3;
			ShowVehicleEditor(playerid);
		}
	}
	elseif(D_Tuning[playerid] == D_TUNING_HIDRAULIKA_MEG)
	{
		if(!BankkartyaFizet(playerid, D_Tuning_ItemCost[playerid], false)) { SendFormatMessage(playerid, COLOR_LIGHTRED, "ClassRPG: Nincs el�g p�nzed! A tuning �ra %s Ft!", FormatInt(D_Tuning_ItemCost[playerid])); D_Tuning[playerid] = D_TUNING_HIDRAULIKA; D_Tuning_ItemCost[playerid] = 0; ShowVehicleEditor(playerid); return 1; }
		
		if(CarInfo[vs][cHidraulika] == 1)
			RemoveVehicleComponent(vehicle, 1087);
		
		CarInfo[vs][cHidraulika] = D_Tuning_SelectedItem[playerid][0];
		CarUpdate(vs, CAR_Hidraulika);
		
		BizPenz(BIZ_TUNING, D_Tuning_ItemCost[playerid]);
		BankkartyaFizet(playerid, D_Tuning_ItemCost[playerid]);
		D_Tuning_ItemCost[playerid] = 0;
		
		D_Tuning[playerid] = D_TUNING_MEGEROSIT;
		ShowVehicleEditor(playerid);
		SendFormatMessage(playerid, COLOR_GREEN, "V�s�rl�s meger�s�tve! Tuning t�pus: %s | Fizetett �sszeg: %s Ft", D_Tuning_Item[D_Tuning_SelectedItem[playerid][1]], FormatInt(D_Tuning_ItemCost[playerid]));
		PlayerPlaySound(playerid,1054,0.0,0.0,0.0);
	}
	elseif(D_Tuning[playerid] == D_TUNING_DETEKTOR)
	{
		switch(listitem)
		{
			case 0:
			{
				if(CarInfo[vs][cDetektor] == 0) return ShowVehicleEditor(playerid);
				D_Tuning[playerid] = D_TUNING_MEGEROSIT;
				D_Tuning_SelectedItem[playerid][1] = 4;
				D_Tuning_SelectedItem[playerid][0] = listitem;
				ShowVehicleEditor(playerid);
			}
			case 1:
			{
				D_Tuning[playerid] = D_TUNING_DETEKTOR_MEG;
				D_Tuning_SelectedItem[playerid][0] = listitem;
				D_Tuning_SelectedItem[playerid][1] = 4;
				D_Tuning_ItemCost[playerid] = 5000000;
				ShowVehicleEditor(playerid);
			}
			case 2:
			{
				D_Tuning[playerid] = D_TUNING_DETEKTOR_MEG;
				D_Tuning_SelectedItem[playerid][0] = listitem;
				D_Tuning_SelectedItem[playerid][1] = 4;
				D_Tuning_ItemCost[playerid] = 7500000;
				ShowVehicleEditor(playerid);
			}
			case 3:
			{
				D_Tuning[playerid] = D_TUNING_DETEKTOR_MEG;
				D_Tuning_SelectedItem[playerid][0] = listitem;
				D_Tuning_SelectedItem[playerid][1] = 4;
				D_Tuning_ItemCost[playerid] = 10000000;
				ShowVehicleEditor(playerid);
			}
		}
	}
	elseif(D_Tuning[playerid] == D_TUNING_DETEKTOR_MEG)
	{
		if(!BankkartyaFizet(playerid, D_Tuning_ItemCost[playerid], false)) { SendFormatMessage(playerid, COLOR_LIGHTRED, "ClassRPG: Nincs el�g p�nzed! A tuning �ra %s Ft!", FormatInt(D_Tuning_ItemCost[playerid])); D_Tuning[playerid] = D_TUNING_DETEKTOR; D_Tuning_ItemCost[playerid] = 0; ShowVehicleEditor(playerid); return 1; }
		CarInfo[vs][cDetektor] = D_Tuning_SelectedItem[playerid][0];
		CarUpdate(vs, CAR_Detektor);
		
		BizPenz(BIZ_TUNING, D_Tuning_ItemCost[playerid]);
		BankkartyaFizet(playerid, D_Tuning_ItemCost[playerid]);
		
		D_Tuning[playerid] = D_TUNING_MEGEROSIT;
		ShowVehicleEditor(playerid);
	}
	elseif(D_Tuning[playerid] == D_TUNING_FELNI)
	{
		switch(listitem)
		{
			case 0:
			{
				if(CarInfo[vs][cKerek] == 0) return ShowVehicleEditor(playerid);
				D_Tuning[playerid] = D_TUNING_MEGEROSIT;
				D_Tuning_SelectedItem[playerid][1] = 5;
				D_Tuning_SelectedItem[playerid][0] = listitem;
				ShowVehicleEditor(playerid);
			}
			case 1..17:
			{
				D_Tuning[playerid] = D_TUNING_FELNI_MEG;
				D_Tuning_SelectedItem[playerid][1] = 5;
				D_Tuning_ItemCost[playerid] = 60000;
				ShowVehicleEditor(playerid);
				
				new k, kerek = listitem;
				if(kerek < 14) k = kerek+1072;
				else
				{
					switch(kerek)
					{
						case 14: k=1025;
						case 15: k=1096;
						case 16: k=1097;
						case 17: k=1098;
					}
				}
				AddVehicleComponent(vehicle, k);
				PlayerPlaySound(playerid,1133,0.0,0.0,0.0);
				D_Tuning_SelectedItem[playerid][0] = k;
			}
		}
	}
	elseif(D_Tuning[playerid] == D_TUNING_FELNI_MEG)
	{
		if(!BankkartyaFizet(playerid, D_Tuning_ItemCost[playerid], false)) { SendFormatMessage(playerid, COLOR_LIGHTRED, "ClassRPG: Nincs el�g p�nzed! A tuning �ra %s Ft!", FormatInt(D_Tuning_ItemCost[playerid])); D_Tuning[playerid] = D_TUNING_FELNI; D_Tuning_ItemCost[playerid] = 0; ShowVehicleEditor(playerid); return 1; }
		CarInfo[vs][cKerek] = D_Tuning_SelectedItem[playerid][0];
		CarUpdate(vs, CAR_Kerek);
		
		BizPenz(BIZ_TUNING, D_Tuning_ItemCost[playerid]);
		BankkartyaFizet(playerid, D_Tuning_ItemCost[playerid]);
		
		D_Tuning[playerid] = D_TUNING_MEGEROSIT;
		ShowVehicleEditor(playerid);
	}
	elseif(D_Tuning[playerid] == D_TUNING_MATRICA)
	{
		switch(listitem)
		{
			case 0..2:
			{
				if((!IsALocoLowCoCar(vehicle) && !IsAWheelArchAngelCar(vehicle)) || model == 566 || model == 412) { Msg(playerid, "Erre a j�rm�re nem rakhatsz ilyen tuningot"); D_Tuning[playerid] = D_TUNING_ALAP; D_Tuning_ItemCost[playerid] = 0; ShowVehicleEditor(playerid); return 1; }
				D_Tuning[playerid] = D_TUNING_MATRICA_MEG;
				D_Tuning_SelectedItem[playerid][0] = listitem;
				D_Tuning_SelectedItem[playerid][1] = 6;
				D_Tuning_ItemCost[playerid] = 15000000;
				ShowVehicleEditor(playerid);
				ChangeVehiclePaintjob(vehicle, listitem);
			}
			case 3:
			{
				if(CarInfo[vs][cMatrica] == 3) return ShowVehicleEditor(playerid);
				D_Tuning[playerid] = D_TUNING_MEGEROSIT;
				D_Tuning_SelectedItem[playerid][0] = listitem;
				D_Tuning_SelectedItem[playerid][1] = 6;
				D_Tuning_ItemCost[playerid] = 0;
				ShowVehicleEditor(playerid);
			}
		}
	}
	elseif(D_Tuning[playerid] == D_TUNING_MATRICA_MEG)
	{
		if(!BankkartyaFizet(playerid, D_Tuning_ItemCost[playerid], false)) { SendFormatMessage(playerid, COLOR_LIGHTRED, "ClassRPG: Nincs el�g p�nzed! A tuning �ra %s Ft!", FormatInt(D_Tuning_ItemCost[playerid])); D_Tuning[playerid] = D_TUNING_MATRICA; D_Tuning_ItemCost[playerid] = 0; ShowVehicleEditor(playerid); return 1; }
		CarInfo[vs][cMatrica] = D_Tuning_SelectedItem[playerid][0];
		CarUpdate(vs, CAR_Matrica);
		
		BizPenz(BIZ_TUNING, D_Tuning_ItemCost[playerid]);
		BankkartyaFizet(playerid, D_Tuning_ItemCost[playerid]);
		
		D_Tuning[playerid] = D_TUNING_MEGEROSIT;
		ShowVehicleEditor(playerid);
	}
	elseif(D_Tuning[playerid] == D_TUNING_TUNINGPACK)
	{
		if((!IsALocoLowCoCar(vehicle) && !IsAWheelArchAngelCar(vehicle)) || model == 566 || model == 412) { Msg(playerid, "Erre a j�rm�re nem rakhatsz ilyen tuningot"); D_Tuning[playerid] = D_TUNING_ALAP; D_Tuning_ItemCost[playerid] = 0; ShowVehicleEditor(playerid); return 1; }
		switch(listitem)
		{
			case 0:
			{
				if(CarInfo[vs][cTuning] == 0) return ShowVehicleEditor(playerid);
				D_Tuning[playerid] = D_TUNING_MEGEROSIT;
				D_Tuning_SelectedItem[playerid][0] = listitem;
				D_Tuning_SelectedItem[playerid][1] = 7;
				ShowVehicleEditor(playerid);
			}
			case 1:
			{
				if(model == 560)
				{
					AddVehicleComponent(vehicle, 1026);
					AddVehicleComponent(vehicle, 1027);
					AddVehicleComponent(vehicle, 1032);
					AddVehicleComponent(vehicle, 1169);
					AddVehicleComponent(vehicle, 1138);
					AddVehicleComponent(vehicle, 1141);
					AddVehicleComponent(vehicle, 1028);
				}
				if(model == 562)
				{
					AddVehicleComponent(vehicle, 1034);
					AddVehicleComponent(vehicle, 1038);
					AddVehicleComponent(vehicle, 1036);
					AddVehicleComponent(vehicle, 1040);
					AddVehicleComponent(vehicle, 1147);
					AddVehicleComponent(vehicle, 1149);
					AddVehicleComponent(vehicle, 1171);
				}
				if(model == 559)
				{
					AddVehicleComponent(vehicle, 1065);
					AddVehicleComponent(vehicle, 1067);
					AddVehicleComponent(vehicle, 1069);
					AddVehicleComponent(vehicle, 1071);
					AddVehicleComponent(vehicle, 1159);
					AddVehicleComponent(vehicle, 1160);
					AddVehicleComponent(vehicle, 1162);
				}
				if(model == 560)
				{
					AddVehicleComponent(vehicle, 1026);
					AddVehicleComponent(vehicle, 1027);
					AddVehicleComponent(vehicle, 1032);
					AddVehicleComponent(vehicle, 1169);
					AddVehicleComponent(vehicle, 1138);
					AddVehicleComponent(vehicle, 1141);
					AddVehicleComponent(vehicle, 1028);
				}
				if(model == 558)
				{
					AddVehicleComponent(vehicle, 1088);
					AddVehicleComponent(vehicle, 1090);
					AddVehicleComponent(vehicle, 1092);
					AddVehicleComponent(vehicle, 1094);
					AddVehicleComponent(vehicle, 1164);
					AddVehicleComponent(vehicle, 1166);
					AddVehicleComponent(vehicle, 1168);
				}
				if(model == 561)
				{
					AddVehicleComponent(vehicle, 1055);
					AddVehicleComponent(vehicle, 1056);
					AddVehicleComponent(vehicle, 1058);
					AddVehicleComponent(vehicle, 1062);
					AddVehicleComponent(vehicle, 1064);
					AddVehicleComponent(vehicle, 1154);
					AddVehicleComponent(vehicle, 1155);
				}
				if(model == 565)
				{
					AddVehicleComponent(vehicle, 1046);
					AddVehicleComponent(vehicle, 1047);
					AddVehicleComponent(vehicle, 1049);
					AddVehicleComponent(vehicle, 1051);
					AddVehicleComponent(vehicle, 1054);
					AddVehicleComponent(vehicle, 1150);
					AddVehicleComponent(vehicle, 1153);
				}
				D_Tuning[playerid] = D_TUNING_TUNINGPACK_MEG;
				D_Tuning_SelectedItem[playerid][0] = listitem;
				D_Tuning_SelectedItem[playerid][1] = 7;
				D_Tuning_ItemCost[playerid] = 5000000;
				ShowVehicleEditor(playerid);
			}
			case 2:
			{
				D_Tuning[playerid] = D_TUNING_TUNINGPACK_MEG;
				D_Tuning_SelectedItem[playerid][0] = listitem;
				D_Tuning_SelectedItem[playerid][1] = 7;
				D_Tuning_ItemCost[playerid] = 5000000;
				ShowVehicleEditor(playerid);
				
				if(model == 560)
				{
					AddVehicleComponent(vehicle, 1029);
					AddVehicleComponent(vehicle, 1030);
					AddVehicleComponent(vehicle, 1031);
					AddVehicleComponent(vehicle, 1133);
					AddVehicleComponent(vehicle, 1139);
					AddVehicleComponent(vehicle, 1140);
					AddVehicleComponent(vehicle, 1170);
				}
				if(model == 562)
				{
					AddVehicleComponent(vehicle, 1035);
					AddVehicleComponent(vehicle, 1037);
					AddVehicleComponent(vehicle, 1039);
					AddVehicleComponent(vehicle, 1041);
					AddVehicleComponent(vehicle, 1146);
					AddVehicleComponent(vehicle, 1148);
					AddVehicleComponent(vehicle, 1172);
				}
				if(model == 559)
				{
					AddVehicleComponent(vehicle, 1066);
					AddVehicleComponent(vehicle, 1068);
					AddVehicleComponent(vehicle, 1070);
					AddVehicleComponent(vehicle, 1072);
					AddVehicleComponent(vehicle, 1158);
					AddVehicleComponent(vehicle, 1161);
					AddVehicleComponent(vehicle, 1173);
				}
				if(model == 558)
				{
					AddVehicleComponent(vehicle, 1089);
					AddVehicleComponent(vehicle, 1091);
					AddVehicleComponent(vehicle, 1093);
					AddVehicleComponent(vehicle, 1095);
					AddVehicleComponent(vehicle, 1163);
					AddVehicleComponent(vehicle, 1165);
					AddVehicleComponent(vehicle, 1167);
				}
				if(model == 561)
				{
					AddVehicleComponent(vehicle, 1057);
					AddVehicleComponent(vehicle, 1059);
					AddVehicleComponent(vehicle, 1050);
					AddVehicleComponent(vehicle, 1061);
					AddVehicleComponent(vehicle, 1063);
					AddVehicleComponent(vehicle, 1156);
					AddVehicleComponent(vehicle, 1157);
				}
				if(model == 565)
				{
					AddVehicleComponent(vehicle, 1045);
					AddVehicleComponent(vehicle, 1048);
					AddVehicleComponent(vehicle, 1050);
					AddVehicleComponent(vehicle, 1052);
					AddVehicleComponent(vehicle, 1053);
					AddVehicleComponent(vehicle, 1151);
					AddVehicleComponent(vehicle, 1152);
				}
			}
		}
	}
	elseif(D_Tuning[playerid] == D_TUNING_TUNINGPACK_MEG)
	{
		if(!BankkartyaFizet(playerid, D_Tuning_ItemCost[playerid], false)) { SendFormatMessage(playerid, COLOR_LIGHTRED, "ClassRPG: Nincs el�g p�nzed! A tuning �ra %s Ft!", FormatInt(D_Tuning_ItemCost[playerid])); D_Tuning[playerid] = D_TUNING_TUNINGPACK; D_Tuning_ItemCost[playerid] = 0; ShowVehicleEditor(playerid); return 1; }
		CarInfo[vs][cTuning] = D_Tuning_SelectedItem[playerid][0];
		CarUpdate(vs, CAR_Tuning);
		
		BizPenz(BIZ_TUNING, D_Tuning_ItemCost[playerid]);
		BankkartyaFizet(playerid, D_Tuning_ItemCost[playerid]);
		
		D_Tuning[playerid] = D_TUNING_MEGEROSIT;
		ShowVehicleEditor(playerid);
	}
	elseif(D_Tuning[playerid] == D_TUNING_MOTORHAZTETO)
	{
		switch(listitem)
		{
			case 0:
			{
				if(CarInfo[vs][cTuningok][0] == 0) return ShowVehicleEditor(playerid);
				D_Tuning[playerid] = D_TUNING_MEGEROSIT;
				D_Tuning_SelectedItem[playerid][0] = listitem;
				D_Tuning_SelectedItem[playerid][1] = 8;
				ShowVehicleEditor(playerid);
			}
			case 1:
			{
				if(!IsALegalCarMod(model, 1005)) { Msg(playerid, "Erre a j�rm�re nem rakhatsz ilyen tuningot"); D_Tuning[playerid] = D_TUNING_ALAP; D_Tuning_ItemCost[playerid] = 0; ShowVehicleEditor(playerid); return 1; }
				AddVehicleComponent(vehicle, 1005);
				D_Tuning[playerid] = D_TUNING_MOTORHAZTETO_MEG;
				D_Tuning_SelectedItem[playerid][0] = listitem;
				D_Tuning_SelectedItem[playerid][1] = 8;
				ShowVehicleEditor(playerid);
			}
			case 2:
			{
				if(!IsALegalCarMod(model, 1004)) { Msg(playerid, "Erre a j�rm�re nem rakhatsz ilyen tuningot"); D_Tuning[playerid] = D_TUNING_ALAP; D_Tuning_ItemCost[playerid] = 0; ShowVehicleEditor(playerid); return 1; }
				AddVehicleComponent(vehicle, 1004);
				D_Tuning[playerid] = D_TUNING_MOTORHAZTETO_MEG;
				D_Tuning_SelectedItem[playerid][0] = listitem;
				D_Tuning_SelectedItem[playerid][1] = 8;
				ShowVehicleEditor(playerid);
			}
			case 3:
			{
				if(!IsALegalCarMod(model, 1011)) { Msg(playerid, "Erre a j�rm�re nem rakhatsz ilyen tuningot"); D_Tuning[playerid] = D_TUNING_ALAP; D_Tuning_ItemCost[playerid] = 0; ShowVehicleEditor(playerid); return 1; }
				AddVehicleComponent(vehicle, 1011);
				D_Tuning[playerid] = D_TUNING_MOTORHAZTETO_MEG;
				D_Tuning_SelectedItem[playerid][0] = listitem;
				D_Tuning_SelectedItem[playerid][1] = 8;
				ShowVehicleEditor(playerid);
			}
			case 4:
			{
				if(!IsALegalCarMod(model, 1012)) { Msg(playerid, "Erre a j�rm�re nem rakhatsz ilyen tuningot"); D_Tuning[playerid] = D_TUNING_ALAP; D_Tuning_ItemCost[playerid] = 0; ShowVehicleEditor(playerid); return 1; }
				AddVehicleComponent(vehicle, 1012);
				D_Tuning[playerid] = D_TUNING_MOTORHAZTETO_MEG;
				D_Tuning_SelectedItem[playerid][0] = listitem;
				D_Tuning_SelectedItem[playerid][1] = 8;
				ShowVehicleEditor(playerid);
			}
		}
	}
	elseif(D_Tuning[playerid] == D_TUNING_MOTORHAZTETO_MEG)
	{
		if(!BankkartyaFizet(playerid, D_Tuning_ItemCost[playerid], false)) { SendFormatMessage(playerid, COLOR_LIGHTRED, "ClassRPG: Nincs el�g p�nzed! A tuning �ra %s Ft!", FormatInt(D_Tuning_ItemCost[playerid])); D_Tuning[playerid] = D_TUNING_MOTORHAZTETO; D_Tuning_ItemCost[playerid] = 0; ShowVehicleEditor(playerid); return 1; }
		CarInfo[vs][cTuningok][0] = D_Tuning_SelectedItem[playerid][0];
		CarUpdate(vs, CAR_Tuningok);
		
		BizPenz(BIZ_TUNING, D_Tuning_ItemCost[playerid]);
		BankkartyaFizet(playerid, D_Tuning_ItemCost[playerid]);
		
		D_Tuning[playerid] = D_TUNING_MEGEROSIT;
		ShowVehicleEditor(playerid);
	}
	elseif(D_Tuning[playerid] == D_TUNING_SZELLOZO)
	{
		switch(listitem)
		{
			case 0:
			{
				if(CarInfo[vs][cTuningok][1] == 0) return ShowVehicleEditor(playerid);
				D_Tuning[playerid] = D_TUNING_MEGEROSIT;
				D_Tuning_SelectedItem[playerid][0] = listitem;
				D_Tuning_SelectedItem[playerid][1] = 9;
				ShowVehicleEditor(playerid);
			}
			case 1:
			{
				if(!IsALegalCarMod(model, 1142) && !IsALegalCarMod(model, 1143)) { Msg(playerid, "Erre a j�rm�re nem rakhatsz ilyen tuningot"); D_Tuning[playerid] = D_TUNING_ALAP; D_Tuning_ItemCost[playerid] = 0; ShowVehicleEditor(playerid); return 1; }
				AddVehicleComponent(vehicle, 1142);
				AddVehicleComponent(vehicle, 1143);
				D_Tuning[playerid] = D_TUNING_SZELLOZO_MEG;
				D_Tuning_SelectedItem[playerid][0] = listitem;
				D_Tuning_SelectedItem[playerid][1] = 9;
				ShowVehicleEditor(playerid);
			}
			case 2:
			{
				if(!IsALegalCarMod(model, 1144) && !IsALegalCarMod(model, 1145)) { Msg(playerid, "Erre a j�rm�re nem rakhatsz ilyen tuningot"); D_Tuning[playerid] = D_TUNING_ALAP; D_Tuning_ItemCost[playerid] = 0; ShowVehicleEditor(playerid); return 1; }
				AddVehicleComponent(vehicle, 1144);
				AddVehicleComponent(vehicle, 1145);
				D_Tuning[playerid] = D_TUNING_SZELLOZO_MEG;
				D_Tuning_SelectedItem[playerid][0] = listitem;
				D_Tuning_SelectedItem[playerid][1] = 9;
				ShowVehicleEditor(playerid);
			}
		}
	}
	elseif(D_Tuning[playerid] == D_TUNING_SZELLOZO_MEG)
	{
		if(!BankkartyaFizet(playerid, D_Tuning_ItemCost[playerid], false)) { SendFormatMessage(playerid, COLOR_LIGHTRED, "ClassRPG: Nincs el�g p�nzed! A tuning �ra %s Ft!", FormatInt(D_Tuning_ItemCost[playerid])); D_Tuning[playerid] = D_TUNING_SZELLOZO; D_Tuning_ItemCost[playerid] = 0; ShowVehicleEditor(playerid); return 1; }
		CarInfo[vs][cTuningok][1] = D_Tuning_SelectedItem[playerid][0];
		CarUpdate(vs, CAR_Tuningok);
		
		BizPenz(BIZ_TUNING, D_Tuning_ItemCost[playerid]);
		BankkartyaFizet(playerid, D_Tuning_ItemCost[playerid]);
		
		D_Tuning[playerid] = D_TUNING_MEGEROSIT;
		ShowVehicleEditor(playerid);
	}
	elseif(D_Tuning[playerid] == D_TUNING_LAMPA)
	{
		switch(listitem)
		{
			case 0:
			{
				if(CarInfo[vs][cTuningok][2] == 0) return ShowVehicleEditor(playerid);
				D_Tuning[playerid] = D_TUNING_MEGEROSIT;
				D_Tuning_SelectedItem[playerid][0] = listitem;
				D_Tuning_SelectedItem[playerid][1] = 10;
				ShowVehicleEditor(playerid);
			}
			case 1:
			{
				if(!IsALegalCarMod(model, 1013)) { Msg(playerid, "Erre a j�rm�re nem rakhatsz ilyen tuningot"); D_Tuning[playerid] = D_TUNING_ALAP; D_Tuning_ItemCost[playerid] = 0; ShowVehicleEditor(playerid); return 1; }
				AddVehicleComponent(vehicle, 1013);
				D_Tuning[playerid] = D_TUNING_LAMPA_MEG;
				D_Tuning_SelectedItem[playerid][0] = listitem;
				D_Tuning_SelectedItem[playerid][1] = 10;
				ShowVehicleEditor(playerid);
			}
			case 2:
			{
				if(!IsALegalCarMod(model, 1024)) { Msg(playerid, "Erre a j�rm�re nem rakhatsz ilyen tuningot"); D_Tuning[playerid] = D_TUNING_ALAP; D_Tuning_ItemCost[playerid] = 0; ShowVehicleEditor(playerid); return 1; }
				AddVehicleComponent(vehicle, 1024);
				D_Tuning[playerid] = D_TUNING_LAMPA_MEG;
				D_Tuning_SelectedItem[playerid][0] = listitem;
				D_Tuning_SelectedItem[playerid][1] = 10;
				ShowVehicleEditor(playerid);
			}
		}
	}
	elseif(D_Tuning[playerid] == D_TUNING_LAMPA_MEG)
	{
		if(!BankkartyaFizet(playerid, D_Tuning_ItemCost[playerid], false)) { SendFormatMessage(playerid, COLOR_LIGHTRED, "ClassRPG: Nincs el�g p�nzed! A tuning �ra %s Ft!", FormatInt(D_Tuning_ItemCost[playerid])); D_Tuning[playerid] = D_TUNING_LAMPA; D_Tuning_ItemCost[playerid] = 0; ShowVehicleEditor(playerid); return 1; }
		CarInfo[vs][cTuningok][2] = D_Tuning_SelectedItem[playerid][0];
		CarUpdate(vs, CAR_Tuningok);
		
		BizPenz(BIZ_TUNING, D_Tuning_ItemCost[playerid]);
		BankkartyaFizet(playerid, D_Tuning_ItemCost[playerid]);
		
		D_Tuning[playerid] = D_TUNING_MEGEROSIT;
		ShowVehicleEditor(playerid);
	}
	elseif(D_Tuning[playerid] == D_TUNING_KIPUFOGO)
	{
		switch(listitem)
		{
			case 0:
			{
				if(CarInfo[vs][cTuningok][3] == 0) return ShowVehicleEditor(playerid);
				D_Tuning[playerid] = D_TUNING_MEGEROSIT;
				D_Tuning_SelectedItem[playerid][0] = listitem;
				D_Tuning_SelectedItem[playerid][1] = 11;
				ShowVehicleEditor(playerid);
			}
			case 1:
			{
				if(!IsALegalCarMod(model, 1022)) { Msg(playerid, "Erre a j�rm�re nem rakhatsz ilyen tuningot"); D_Tuning[playerid] = D_TUNING_ALAP; D_Tuning_ItemCost[playerid] = 0; ShowVehicleEditor(playerid); return 1; }
				AddVehicleComponent(vehicle, 1022);
				D_Tuning[playerid] = D_TUNING_KIPUFOGO_MEG;
				D_Tuning_SelectedItem[playerid][0] = listitem;
				D_Tuning_SelectedItem[playerid][1] = 11;
				ShowVehicleEditor(playerid);
			}
			case 2:
			{
				if(!IsALegalCarMod(model, 1021)) { Msg(playerid, "Erre a j�rm�re nem rakhatsz ilyen tuningot"); D_Tuning[playerid] = D_TUNING_ALAP; D_Tuning_ItemCost[playerid] = 0; ShowVehicleEditor(playerid); return 1; }
				AddVehicleComponent(vehicle, 1021);
				D_Tuning[playerid] = D_TUNING_KIPUFOGO_MEG;
				D_Tuning_SelectedItem[playerid][0] = listitem;
				D_Tuning_SelectedItem[playerid][1] = 11;
				ShowVehicleEditor(playerid);
			}
			case 3:
			{
				if(!IsALegalCarMod(model, 1020)) { Msg(playerid, "Erre a j�rm�re nem rakhatsz ilyen tuningot"); D_Tuning[playerid] = D_TUNING_ALAP; D_Tuning_ItemCost[playerid] = 0; ShowVehicleEditor(playerid); return 1; }
				AddVehicleComponent(vehicle, 1020);
				D_Tuning[playerid] = D_TUNING_KIPUFOGO_MEG;
				D_Tuning_SelectedItem[playerid][0] = listitem;
				D_Tuning_SelectedItem[playerid][1] = 11;
				ShowVehicleEditor(playerid);
			}
			case 4:
			{
				if(!IsALegalCarMod(model, 1019)) { Msg(playerid, "Erre a j�rm�re nem rakhatsz ilyen tuningot"); D_Tuning[playerid] = D_TUNING_ALAP; D_Tuning_ItemCost[playerid] = 0; ShowVehicleEditor(playerid); return 1; }
				AddVehicleComponent(vehicle, 1019);
				D_Tuning[playerid] = D_TUNING_KIPUFOGO_MEG;
				D_Tuning_SelectedItem[playerid][0] = listitem;
				D_Tuning_SelectedItem[playerid][1] = 11;
				ShowVehicleEditor(playerid);
			}
			case 5:
			{
				if(!IsALegalCarMod(model, 1018)) { Msg(playerid, "Erre a j�rm�re nem rakhatsz ilyen tuningot"); D_Tuning[playerid] = D_TUNING_ALAP; D_Tuning_ItemCost[playerid] = 0; ShowVehicleEditor(playerid); return 1; }
				AddVehicleComponent(vehicle, 1018);
				D_Tuning[playerid] = D_TUNING_KIPUFOGO_MEG;
				D_Tuning_SelectedItem[playerid][0] = listitem;
				D_Tuning_SelectedItem[playerid][1] = 11;
				ShowVehicleEditor(playerid);
			}
		}
	}
	elseif(D_Tuning[playerid] == D_TUNING_KIPUFOGO_MEG)
	{
		if(!BankkartyaFizet(playerid, D_Tuning_ItemCost[playerid], false)) { SendFormatMessage(playerid, COLOR_LIGHTRED, "ClassRPG: Nincs el�g p�nzed! A tuning �ra %s Ft!", FormatInt(D_Tuning_ItemCost[playerid])); D_Tuning[playerid] = D_TUNING_KIPUFOGO; D_Tuning_ItemCost[playerid] = 0; ShowVehicleEditor(playerid); return 1; }
		CarInfo[vs][cTuningok][3] = D_Tuning_SelectedItem[playerid][0];
		CarUpdate(vs, CAR_Tuningok);
		
		BizPenz(BIZ_TUNING, D_Tuning_ItemCost[playerid]);
		BankkartyaFizet(playerid, D_Tuning_ItemCost[playerid]);
		
		D_Tuning[playerid] = D_TUNING_MEGEROSIT;
		ShowVehicleEditor(playerid);
	}
	elseif(D_Tuning[playerid] == D_TUNING_TETO)
	{
		switch(listitem)
		{
			case 0:
			{
				if(CarInfo[vs][cTuningok][6] == 0) return ShowVehicleEditor(playerid);
				D_Tuning[playerid] = D_TUNING_MEGEROSIT;
				D_Tuning_SelectedItem[playerid][0] = listitem;
				D_Tuning_SelectedItem[playerid][1] = 12;
				ShowVehicleEditor(playerid);
			}
			case 1..5:
			{
				D_Tuning[playerid] = D_TUNING_TETO_MEG;
				D_Tuning_SelectedItem[playerid][0] = listitem;
				D_Tuning_SelectedItem[playerid][1] = 12;
				ShowVehicleEditor(playerid);
			}
		}
	}
	elseif(D_Tuning[playerid] == D_TUNING_TETO_MEG)
	{
		if(!BankkartyaFizet(playerid, D_Tuning_ItemCost[playerid], false)) { SendFormatMessage(playerid, COLOR_LIGHTRED, "ClassRPG: Nincs el�g p�nzed! A tuning �ra %s Ft!", FormatInt(D_Tuning_ItemCost[playerid])); D_Tuning[playerid] = D_TUNING_TETO; D_Tuning_ItemCost[playerid] = 0; ShowVehicleEditor(playerid); return 1; }
		CarInfo[vs][cTuningok][6] = D_Tuning_SelectedItem[playerid][0];
		CarUpdate(vs, CAR_Tuningok);
		
		BizPenz(BIZ_TUNING, D_Tuning_ItemCost[playerid]);
		BankkartyaFizet(playerid, D_Tuning_ItemCost[playerid]);
		
		D_Tuning[playerid] = D_TUNING_MEGEROSIT;
		ShowVehicleEditor(playerid);
	}
	elseif(D_Tuning[playerid] == D_TUNING_SPOILER)
	{
		switch(listitem)
		{
			case 0:
			{
				if(CarInfo[vs][cTuningok][7] == 0) return ShowVehicleEditor(playerid);
				D_Tuning[playerid] = D_TUNING_MEGEROSIT;
				D_Tuning_SelectedItem[playerid][0] = listitem;
				D_Tuning_SelectedItem[playerid][1] = 13;
				ShowVehicleEditor(playerid);
			}
			case 1:
			{
				if(!IsALegalCarMod(model, 1001)) { Msg(playerid, "Erre a j�rm�re nem rakhatsz ilyen tuningot"); D_Tuning[playerid] = D_TUNING_ALAP; D_Tuning_ItemCost[playerid] = 0; ShowVehicleEditor(playerid); return 1; }
				AddVehicleComponent(vehicle, 1001);
				D_Tuning[playerid] = D_TUNING_SPOILER_MEG;
				D_Tuning_SelectedItem[playerid][0] = listitem;
				D_Tuning_SelectedItem[playerid][1] = 13;
				ShowVehicleEditor(playerid);
			}
			case 2:
			{
				if(!IsALegalCarMod(model, 1023)) { Msg(playerid, "Erre a j�rm�re nem rakhatsz ilyen tuningot"); D_Tuning[playerid] = D_TUNING_ALAP; D_Tuning_ItemCost[playerid] = 0; ShowVehicleEditor(playerid); return 1; }
				AddVehicleComponent(vehicle, 1023);
				D_Tuning[playerid] = D_TUNING_SPOILER_MEG;
				D_Tuning_SelectedItem[playerid][0] = listitem;
				D_Tuning_SelectedItem[playerid][1] = 13;
				ShowVehicleEditor(playerid);
			}
			case 3:
			{
				if(!IsALegalCarMod(model, 1021)) { Msg(playerid, "Erre a j�rm�re nem rakhatsz ilyen tuningot"); D_Tuning[playerid] = D_TUNING_ALAP; D_Tuning_ItemCost[playerid] = 0; ShowVehicleEditor(playerid); return 1; }
				AddVehicleComponent(vehicle, 1021);
				D_Tuning[playerid] = D_TUNING_SPOILER_MEG;
				D_Tuning_SelectedItem[playerid][0] = listitem;
				D_Tuning_SelectedItem[playerid][1] = 13;
				ShowVehicleEditor(playerid);
			}
			case 4:
			{
				if(!IsALegalCarMod(model, 1003)) { Msg(playerid, "Erre a j�rm�re nem rakhatsz ilyen tuningot"); D_Tuning[playerid] = D_TUNING_ALAP; D_Tuning_ItemCost[playerid] = 0; ShowVehicleEditor(playerid); return 1; }
				AddVehicleComponent(vehicle, 1003);
				D_Tuning[playerid] = D_TUNING_SPOILER_MEG;
				D_Tuning_SelectedItem[playerid][0] = listitem;
				D_Tuning_SelectedItem[playerid][1] = 13;
				ShowVehicleEditor(playerid);
			}
			case 5:
			{
				if(!IsALegalCarMod(model, 1000)) { Msg(playerid, "Erre a j�rm�re nem rakhatsz ilyen tuningot"); D_Tuning[playerid] = D_TUNING_ALAP; D_Tuning_ItemCost[playerid] = 0; ShowVehicleEditor(playerid); return 1; }
				AddVehicleComponent(vehicle, 1000);
				D_Tuning[playerid] = D_TUNING_SPOILER_MEG;
				D_Tuning_SelectedItem[playerid][0] = listitem;
				D_Tuning_SelectedItem[playerid][1] = 13;
				ShowVehicleEditor(playerid);
			}
			case 6:
			{
				if(!IsALegalCarMod(model, 1014)) { Msg(playerid, "Erre a j�rm�re nem rakhatsz ilyen tuningot"); D_Tuning[playerid] = D_TUNING_ALAP; D_Tuning_ItemCost[playerid] = 0; ShowVehicleEditor(playerid); return 1; }
				AddVehicleComponent(vehicle, 1014);
				D_Tuning[playerid] = D_TUNING_SPOILER_MEG;
				D_Tuning_SelectedItem[playerid][0] = listitem;
				D_Tuning_SelectedItem[playerid][1] = 13;
				ShowVehicleEditor(playerid);
			}
			case 7:
			{
				if(!IsALegalCarMod(model, 1002)) { Msg(playerid, "Erre a j�rm�re nem rakhatsz ilyen tuningot"); D_Tuning[playerid] = D_TUNING_ALAP; D_Tuning_ItemCost[playerid] = 0; ShowVehicleEditor(playerid); return 1; }
				AddVehicleComponent(vehicle, 1002);
				D_Tuning[playerid] = D_TUNING_SPOILER_MEG;
				D_Tuning_SelectedItem[playerid][0] = listitem;
				D_Tuning_SelectedItem[playerid][1] = 13;
				ShowVehicleEditor(playerid);
			}
		}
	}
	elseif(D_Tuning[playerid] == D_TUNING_SPOILER_MEG)
	{
		if(!BankkartyaFizet(playerid, D_Tuning_ItemCost[playerid], false)) { SendFormatMessage(playerid, COLOR_LIGHTRED, "ClassRPG: Nincs el�g p�nzed! A tuning �ra %s Ft!", FormatInt(D_Tuning_ItemCost[playerid])); D_Tuning[playerid] = D_TUNING_TETO; D_Tuning_ItemCost[playerid] = 0; ShowVehicleEditor(playerid); return 1; }
		CarInfo[vs][cTuningok][7] = D_Tuning_SelectedItem[playerid][0];
		CarUpdate(vs, CAR_Tuningok);
		
		BizPenz(BIZ_TUNING, D_Tuning_ItemCost[playerid]);
		BankkartyaFizet(playerid, D_Tuning_ItemCost[playerid]);
		
		D_Tuning[playerid] = D_TUNING_MEGEROSIT;
		ShowVehicleEditor(playerid);
	}
	elseif(D_Tuning[playerid] == D_TUNING_DISZ)
	{
		switch(listitem)
		{
			case 0:
			{
				if(CarInfo[vs][cTuningok][9] == 0) return ShowVehicleEditor(playerid);
				D_Tuning[playerid] = D_TUNING_MEGEROSIT;
				D_Tuning_SelectedItem[playerid][0] = listitem;
				D_Tuning_SelectedItem[playerid][1] = 14;
				ShowVehicleEditor(playerid);
			}
			case 1:
			{
				if(!IsALegalCarMod(model, 1100)) { Msg(playerid, "Erre a j�rm�re nem rakhatsz ilyen tuningot"); D_Tuning[playerid] = D_TUNING_ALAP; D_Tuning_ItemCost[playerid] = 0; ShowVehicleEditor(playerid); return 1; }
				AddVehicleComponent(vehicle, 1100);
				D_Tuning[playerid] = D_TUNING_DISZ_MEG;
				D_Tuning_SelectedItem[playerid][0] = listitem;
				D_Tuning_SelectedItem[playerid][1] = 14;
				ShowVehicleEditor(playerid);
			}
			case 2:
			{
				if(!IsALegalCarMod(model, 1123)) { Msg(playerid, "Erre a j�rm�re nem rakhatsz ilyen tuningot"); D_Tuning[playerid] = D_TUNING_ALAP; D_Tuning_ItemCost[playerid] = 0; ShowVehicleEditor(playerid); return 1; }
				AddVehicleComponent(vehicle, 1123);
				D_Tuning[playerid] = D_TUNING_DISZ_MEG;
				D_Tuning_SelectedItem[playerid][0] = listitem;
				D_Tuning_SelectedItem[playerid][1] = 14;
				ShowVehicleEditor(playerid);
			}
			case 3:
			{
				if(!IsALegalCarMod(model, 1125)) { Msg(playerid, "Erre a j�rm�re nem rakhatsz ilyen tuningot"); D_Tuning[playerid] = D_TUNING_ALAP; D_Tuning_ItemCost[playerid] = 0; ShowVehicleEditor(playerid); return 1; }
				AddVehicleComponent(vehicle, 1125);
				D_Tuning[playerid] = D_TUNING_DISZ_MEG;
				D_Tuning_SelectedItem[playerid][0] = listitem;
				D_Tuning_SelectedItem[playerid][1] = 14;
				ShowVehicleEditor(playerid);
			}
			case 4:
			{
				if(!IsALegalCarMod(model, 1117)) { Msg(playerid, "Erre a j�rm�re nem rakhatsz ilyen tuningot"); D_Tuning[playerid] = D_TUNING_ALAP; D_Tuning_ItemCost[playerid] = 0; ShowVehicleEditor(playerid); return 1; }
				AddVehicleComponent(vehicle, 1117);
				D_Tuning[playerid] = D_TUNING_DISZ_MEG;
				D_Tuning_SelectedItem[playerid][0] = listitem;
				D_Tuning_SelectedItem[playerid][1] = 14;
				ShowVehicleEditor(playerid);
			}
		}
	}
	elseif(D_Tuning[playerid] == D_TUNING_DISZ_MEG)
	{
		if(!BankkartyaFizet(playerid, D_Tuning_ItemCost[playerid], false)) { SendFormatMessage(playerid, COLOR_LIGHTRED, "ClassRPG: Nincs el�g p�nzed! A tuning �ra %s Ft!", FormatInt(D_Tuning_ItemCost[playerid])); D_Tuning[playerid] = D_TUNING_DISZ; D_Tuning_ItemCost[playerid] = 0; ShowVehicleEditor(playerid); return 1; }
		CarInfo[vs][cTuningok][9] = D_Tuning_SelectedItem[playerid][0];
		CarUpdate(vs, CAR_Tuningok);
		
		BizPenz(BIZ_TUNING, D_Tuning_ItemCost[playerid]);
		BankkartyaFizet(playerid, D_Tuning_ItemCost[playerid]);
		
		D_Tuning[playerid] = D_TUNING_MEGEROSIT;
		ShowVehicleEditor(playerid);
	}
	elseif(D_Tuning[playerid] == D_TUNING_MEGEROSIT)
	{
		SendFormatMessage(playerid, COLOR_GREEN, "V�s�rl�s meger�s�tve! Tuning t�pus: %s | Fizetett �sszeg: %s Ft", D_Tuning_Item[D_Tuning_SelectedItem[playerid][1]], FormatInt(D_Tuning_ItemCost[playerid]));
		PlayerPlaySound(playerid,1054,0.0,0.0,0.0);
		D_Tuning_ItemCost[playerid] = 0;
	}
	return 1;
}*/