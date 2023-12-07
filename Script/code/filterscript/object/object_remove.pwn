#if defined __fs_object_object_remove
	#endinput
#endif
#define __fs_object_object_remove

stock Torlesek() { //orem	
	// &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& //
	// GLOBÁLIS TÖRLÉSEK - 5000.0 RANGE - ÁLTALÁBAN STUNT, CRASHT OKOZÓ OBJECTEK //
	// &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& //
	
	RemoveBuildingForPlayer(playerid, 3664, 1960.6953, -2236.4297, 19.2813, 5000.0);
	RemoveBuildingForPlayer(playerid, 1374, 2266.8359, -2242.9219, 14.1016, 5000.0);
	RemoveBuildingForPlayer(playerid, 1373, 2283.8125, -2243.4453, 15.3125, 5000.0);
	
	// &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& //
	// EGYÉB TÖRLÉSEK - A szokásos formában: MI EZ - KI KÜLDTE - MIKOR RAKTAD BE //
	// &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& //
	
	// Boltok - Nunez - 2017-06-26
	RemoveBuildingForPlayer(playerid, 6130, 1117.5859, -1490.0078, 32.7188, 0.25);
	RemoveBuildingForPlayer(playerid, 6255, 1117.5859, -1490.0078, 32.7188, 0.25);
	RemoveBuildingForPlayer(playerid, 792, 1111.2578, -1512.3594, 15.2109, 0.25);
	RemoveBuildingForPlayer(playerid, 792, 1106.4375, -1501.3750, 15.2109, 0.25);
	RemoveBuildingForPlayer(playerid, 792, 1118.0156, -1467.4688, 15.2109, 0.25);
	RemoveBuildingForPlayer(playerid, 792, 1139.9219, -1467.4688, 15.2109, 0.25);
	RemoveBuildingForPlayer(playerid, 792, 1139.9219, -1456.4375, 15.2109, 0.25);
	RemoveBuildingForPlayer(playerid, 792, 1118.0156, -1456.4375, 15.2109, 0.25);
	RemoveBuildingForPlayer(playerid, 792, 1139.9219, -1445.1016, 15.2109, 0.25);
	RemoveBuildingForPlayer(playerid, 792, 1118.0156, -1445.1016, 15.2109, 0.25);
	RemoveBuildingForPlayer(playerid, 792, 1139.9219, -1434.0703, 15.2109, 0.25);
	RemoveBuildingForPlayer(playerid, 615, 1110.5469, -1416.7266, 13.9531, 0.25);
	RemoveBuildingForPlayer(playerid, 615, 1147.6016, -1416.8750, 13.9531, 0.25);
	
	// Katonaság HQ - Nunez - 2017-06-11
	RemoveBuildingForPlayer(playerid, 17349, -542.0078, -522.8438, 29.5938, 0.25);
	RemoveBuildingForPlayer(playerid, 17019, -606.0313, -528.8203, 30.5234, 0.25);
	RemoveBuildingForPlayer(playerid, 1278, -573.0547, -559.6953, 38.5234, 0.25);
	RemoveBuildingForPlayer(playerid, 1278, -533.5391, -559.6953, 38.5469, 0.25);
	RemoveBuildingForPlayer(playerid, 1415, -541.4297, -561.2266, 24.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 17012, -542.0078, -522.8438, 29.5938, 0.25);
	RemoveBuildingForPlayer(playerid, 1415, -513.7578, -561.0078, 24.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 1441, -503.6172, -540.5313, 25.2266, 0.25);
	RemoveBuildingForPlayer(playerid, 1415, -502.6094, -528.6484, 24.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 1440, -502.1172, -521.0313, 25.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 1441, -502.4063, -513.0156, 25.2266, 0.25);
	RemoveBuildingForPlayer(playerid, 1415, -620.4141, -490.5078, 24.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 1415, -619.6250, -473.4531, 24.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 1278, -573.0547, -479.9219, 38.5781, 0.25);
	RemoveBuildingForPlayer(playerid, 1278, -552.7656, -479.9219, 38.6250, 0.25);
	RemoveBuildingForPlayer(playerid, 1440, -553.6875, -481.6328, 25.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 1441, -554.4531, -496.1797, 25.1641, 0.25);
	RemoveBuildingForPlayer(playerid, 1441, -537.0391, -469.1172, 25.2266, 0.25);
	RemoveBuildingForPlayer(playerid, 1278, -532.4688, -479.9219, 38.6484, 0.25);
	RemoveBuildingForPlayer(playerid, 1440, -516.9453, -496.6484, 25.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 1440, -503.1250, -509.0000, 25.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 1278, -512.1641, -479.9219, 38.5938, 0.25);
	RemoveBuildingForPlayer(playerid, 1278, -491.8594, -479.9219, 38.5859, 0.25);
	RemoveBuildingForPlayer(playerid, 17020, -475.9766, -544.8516, 28.1172, 0.25);
	RemoveBuildingForPlayer(playerid, 1278, -471.5547, -479.9219, 38.6250, 0.25);
	
	//Anarchia HQ / Axel Kraint - 2017-05-22 6:44PM
	RemoveBuildingForPlayer(playerid, 13133, 299.2031, -193.6250, 3.8281, 0.25);
	RemoveBuildingForPlayer(playerid, 13203, 308.0938, -168.7266, 4.3672, 0.25);
	RemoveBuildingForPlayer(playerid, 1294, 323.7109, -203.1484, 5.0313, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, 322.3125, -188.9141, 0.7031, 0.25);
	RemoveBuildingForPlayer(playerid, 1294, 323.8828, -150.7734, 5.0313, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, 293.6250, -152.4844, 0.7031, 0.25);
	RemoveBuildingForPlayer(playerid, 1294, 291.1563, -171.5000, 5.0313, 0.25);
	RemoveBuildingForPlayer(playerid, 13190, 308.0938, -168.7266, 4.3672, 0.25);
	RemoveBuildingForPlayer(playerid, 13436, 252.3281, -28.8906, 9.1094, 0.25);
	RemoveBuildingForPlayer(playerid, 13437, 210.9375, -245.1406, 10.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 1308, 292.6641, -201.9922, 0.7031, 0.25);
	RemoveBuildingForPlayer(playerid, 1495, 293.7500, -194.6875, 0.7656, 0.25);
	RemoveBuildingForPlayer(playerid, 13132, 299.2031, -193.6250, 3.8281, 0.25);
	RemoveBuildingForPlayer(playerid, 1687, 303.9375, -194.9297, 4.3672, 0.25);
	RemoveBuildingForPlayer(playerid, 1691, 297.1016, -195.6094, 4.9453, 0.25);
	RemoveBuildingForPlayer(playerid, 1440, 312.6406, -199.8750, 1.0625, 0.25);
	RemoveBuildingForPlayer(playerid, 1440, 305.1328, -188.5625, 1.0625, 0.25);
	//Anarchia HQ / Axel Kraint - 2017-05-22 6:44PM
	
	//Új LS bank Farder T Lock - 2017.04.17.
	RemoveBuildingForPlayer(playerid, 1525, 1519.4219, -1010.9453, 24.6094, 0.25);
	RemoveBuildingForPlayer(playerid, 647, 1385.8203, -994.6953, 31.4766, 0.25);
	RemoveBuildingForPlayer(playerid, 647, 1385.8203, -989.6484, 31.3281, 0.25);
	RemoveBuildingForPlayer(playerid, 1294, 1453.5000, -1038.1484, 27.3516, 0.25);
	RemoveBuildingForPlayer(playerid, 1265, 1520.7734, -1016.2891, 23.4453, 0.25);
	RemoveBuildingForPlayer(playerid, 1265, 1519.8984, -1016.2344, 23.4453, 0.25);
	RemoveBuildingForPlayer(playerid, 1227, 1520.1563, -1018.5547, 23.8438, 0.25);
	RemoveBuildingForPlayer(playerid, 1264, 1519.9609, -1012.8984, 23.4688, 0.25);
	RemoveBuildingForPlayer(playerid, 1227, 1520.2109, -1014.6328, 23.8438, 0.25);
	//Új LS bank Farder T Lock - 2017.04.17.
	
	//Los Santos Szerelõ telep - Johnny B. Hollywood - 2017.02.14
	RemoveBuildingForPlayer(playerid, 4563, 1567.6016, -1248.6953, 102.5234, 0.25);
	RemoveBuildingForPlayer(playerid, 4566, 1567.6016, -1248.6953, 102.5234, 0.25);
	RemoveBuildingForPlayer(playerid, 728, 1530.5078, -1255.7578, 17.3359, 0.25);
	RemoveBuildingForPlayer(playerid, 4715, 1567.7188, -1248.6953, 102.5234, 0.25);
	RemoveBuildingForPlayer(playerid, 1340, 1589.6953, -1287.2656, 17.6406, 0.25);
	RemoveBuildingForPlayer(playerid, 1215, 1545.0781, -1284.9844, 16.9531, 0.25);
	RemoveBuildingForPlayer(playerid, 1280, 1548.2813, -1284.9766, 16.7891, 0.25);
	RemoveBuildingForPlayer(playerid, 1280, 1555.4453, -1284.9141, 16.7891, 0.25);
	RemoveBuildingForPlayer(playerid, 1215, 1564.1641, -1284.9297, 16.9531, 0.25);
	RemoveBuildingForPlayer(playerid, 1280, 1561.6172, -1284.8359, 16.7891, 0.25);
	RemoveBuildingForPlayer(playerid, 1215, 1532.9766, -1270.0781, 16.9531, 0.25);
	RemoveBuildingForPlayer(playerid, 1280, 1533.1875, -1266.6875, 13.8281, 0.25);
	RemoveBuildingForPlayer(playerid, 1215, 1533.3281, -1257.5078, 16.9531, 0.25);
	RemoveBuildingForPlayer(playerid, 1280, 1533.2266, -1260.6797, 13.8281, 0.25);
	RemoveBuildingForPlayer(playerid, 1280, 1533.3203, -1253.2734, 13.8281, 0.25);
	RemoveBuildingForPlayer(playerid, 1215, 1533.3281, -1244.4688, 16.9531, 0.25);
	RemoveBuildingForPlayer(playerid, 1280, 1533.3203, -1247.8906, 13.8281, 0.25);
	RemoveBuildingForPlayer(playerid, 1232, 1600.1641, -1232.7500, 19.1484, 0.25);
	
	//SignumCars - Johhny B. Hollywood 2017.02.13
	RemoveBuildingForPlayer(playerid, 4719, 1760.1641, -1127.2734, 43.6641, 0.25);
	RemoveBuildingForPlayer(playerid, 4748, 1760.1641, -1127.2734, 43.6641, 0.25);
	RemoveBuildingForPlayer(playerid, 717, 1703.9922, -1150.1484, 23.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 717, 1721.2344, -1150.1484, 23.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 1215, 1704.0234, -1142.8438, 23.6094, 0.25);
	RemoveBuildingForPlayer(playerid, 1215, 1721.1172, -1142.8438, 23.6094, 0.25);
	RemoveBuildingForPlayer(playerid, 1215, 1702.7031, -1141.2344, 23.6094, 0.25);
	RemoveBuildingForPlayer(playerid, 1215, 1702.7031, -1129.8750, 23.6094, 0.25);
	RemoveBuildingForPlayer(playerid, 1215, 1702.7031, -1118.5234, 23.6094, 0.25);
	RemoveBuildingForPlayer(playerid, 1215, 1702.7031, -1107.1641, 23.6094, 0.25);
	RemoveBuildingForPlayer(playerid, 1215, 1702.7031, -1095.8125, 23.6094, 0.25);
	RemoveBuildingForPlayer(playerid, 1215, 1704.0234, -1094.5313, 23.6094, 0.25);
	RemoveBuildingForPlayer(playerid, 1215, 1721.1172, -1094.5313, 23.6094, 0.25);
	RemoveBuildingForPlayer(playerid, 717, 1738.7813, -1150.1484, 23.0938, 0.25);
	RemoveBuildingForPlayer(playerid, 1215, 1738.2109, -1142.8438, 23.6094, 0.25);
	RemoveBuildingForPlayer(playerid, 1215, 1755.3047, -1142.8438, 23.6094, 0.25);
	RemoveBuildingForPlayer(playerid, 1215, 1772.3984, -1142.8438, 23.6094, 0.25);
	RemoveBuildingForPlayer(playerid, 1215, 1789.4922, -1142.8438, 23.6094, 0.25);
	RemoveBuildingForPlayer(playerid, 1215, 1806.5781, -1142.8438, 23.6094, 0.25);
	RemoveBuildingForPlayer(playerid, 1215, 1738.2109, -1094.5313, 23.6094, 0.25);
	RemoveBuildingForPlayer(playerid, 1215, 1755.3047, -1094.5313, 23.6094, 0.25);
	RemoveBuildingForPlayer(playerid, 4718, 1760.1641, -1127.2734, 43.6641, 0.25);
	RemoveBuildingForPlayer(playerid, 1215, 1772.3984, -1094.5313, 23.6094, 0.25);
	RemoveBuildingForPlayer(playerid, 1227, 1789.7734, -1116.0625, 23.8906, 0.25);
	RemoveBuildingForPlayer(playerid, 1227, 1789.9063, -1112.6406, 23.8906, 0.25);
	RemoveBuildingForPlayer(playerid, 1215, 1789.4922, -1094.5313, 23.6094, 0.25);
	RemoveBuildingForPlayer(playerid, 1215, 1806.5781, -1094.5313, 23.6094, 0.25);
	
	// FBI TÖRLÉSEK
	RemoveBuildingForPlayer(playerid, 1278, -1415.6641, -232.2266, 25.3359, 0.25);
	
	// LSPD Rendõrség külsõ törlések pár útban levõ fa és tábla - 2014.03.23 - John S. Gates
	RemoveBuildingForPlayer(playerid, 1266, 1538.5234, -1609.8047, 19.8438, 25.0);
	RemoveBuildingForPlayer(playerid, 4229, 1597.9063, -1699.7500, 30.2109, 0.25);
	RemoveBuildingForPlayer(playerid, 4230, 1597.9063, -1699.7500, 30.2109, 0.25);
	RemoveBuildingForPlayer(playerid, 1260, 1565.4141, -1722.3125, 25.0391, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 1541.4531, -1709.6406, 13.0469, 50.0);
	RemoveBuildingForPlayer(playerid, 1260, 1538.5234, -1609.8047, 19.8438, 0.25);
	
	//GSF HQ - Victor Gonzales - 2014.07.20
	RemoveBuildingForPlayer(playerid, 1525, 2422.9063, -1682.2969, 13.9922, 0.25);
	RemoveBuildingForPlayer(playerid, 3594, 2532.9844, -1719.4297, 13.1797, 50.0);
	RemoveBuildingForPlayer(playerid, 1211, 2495.2656, -1653.6719, 12.9141, 0.25);
	RemoveBuildingForPlayer(playerid, 1230, 2501.9297, -1650.5078, 12.9141, 0.25);
	RemoveBuildingForPlayer(playerid, 1468, 2505.1094, -1646.0391, 13.9141, 0.25);
	RemoveBuildingForPlayer(playerid, 3593, 2457.8672, -1679.6719, 12.9453, 50.0);
	RemoveBuildingForPlayer(playerid, 17971, 2484.5313, -1667.6094, 21.4375, 0.25);
	
	//LSPD Interior - Nick F Gates - 2014.02.04
	RemoveBuildingForPlayer(playerid, 2172, 217.1875, 169.9688, 1002.0234, DEFAULT_REMOVE_RANGE);
	RemoveBuildingForPlayer(playerid, 1806, 215.5625, 170.2266, 1002.0156, DEFAULT_REMOVE_RANGE);
	RemoveBuildingForPlayer(playerid, 2193, 223.2031, 170.2422, 1002.0234, DEFAULT_REMOVE_RANGE);
	RemoveBuildingForPlayer(playerid, 2166, 198.8672, 170.8672, 1002.0313, DEFAULT_REMOVE_RANGE);
	RemoveBuildingForPlayer(playerid, 2356, 211.3828, 174.2344, 1002.0234, DEFAULT_REMOVE_RANGE);
	RemoveBuildingForPlayer(playerid, 2198, 243.4766, 184.2578, 1007.1797, DEFAULT_REMOVE_RANGE);
	RemoveBuildingForPlayer(playerid, 2162, 242.9766, 189.5703, 1007.1953, DEFAULT_REMOVE_RANGE);
	RemoveBuildingForPlayer(playerid, 2161, 260.7734, 193.3750, 1007.1719, DEFAULT_REMOVE_RANGE);
	RemoveBuildingForPlayer(playerid, 14886, 268.4375, 186.9297, 1006.8828, 0.25);
	RemoveBuildingForPlayer(playerid, 2252, 301.0703, 180.3672, 1007.4531, DEFAULT_REMOVE_RANGE);
	RemoveBuildingForPlayer(playerid, 14856, 198.4688, 168.6797, 1003.8984, 0.25);
	RemoveBuildingForPlayer(playerid, 2165, 199.8594, 168.8984, 1002.0313, 0.25);
	RemoveBuildingForPlayer(playerid, 1715, 215.0078, 147.3125, 1002.0234, DEFAULT_REMOVE_RANGE);
	RemoveBuildingForPlayer(playerid, 2029, 215.9844, 149.9531, 1002.0156, 0.25);
	RemoveBuildingForPlayer(playerid, 2186, 228.8125, 162.3828, 1002.0391, 0.25);
	RemoveBuildingForPlayer(playerid, 14855, 231.4688, 163.8516, 1006.5234, 0.25);
	RemoveBuildingForPlayer(playerid, 2208, 231.3984, 166.4609, 1002.0391, 0.25);
	RemoveBuildingForPlayer(playerid, 14887, 228.3594, 167.5156, 1004.0703, 0.25);
	RemoveBuildingForPlayer(playerid, 14902, 245.0469, 168.6719, 1007.1719, 0.25);
	
	//Szeméttelep - Pedro - 2013.11.20
	RemoveBuildingForPlayer(playerid, 1454, -574.3906, -1476.8203, 10.3828, 50.0);
	RemoveBuildingForPlayer(playerid, 3425, -583.0547, -1496.7031, 19.9844, 0.25);
	RemoveBuildingForPlayer(playerid, 17457, -570.7344, -1490.3203, 15.0703, 0.25);
	
	//repülõ fa - Terno - 2013-05-24
	RemoveBuildingForPlayer(playerid, 672, -149.3359, -160.5078, 3.4688, 0.25);
		
	//vagos kerítés - terno - 2013-04-25
	RemoveBuildingForPlayer(playerid, 1410, 2488.8672, -968.4609, 81.7188, 15.0);
	RemoveBuildingForPlayer(playerid, 1407, 2493.5859, -968.5078, 81.8438, 0.25);
	
	//NAV - PedroGates - 2013.03.18.
	RemoveBuildingForPlayer(playerid, 1226, 778.8594, -1391.1563, 16.3125, 0.25);
	RemoveBuildingForPlayer(playerid, 6357, 505.0547, -1269.9375, 28.6875, 0.25);
	RemoveBuildingForPlayer(playerid, 1689, 650.8359, -1377.6641, 21.7578, DEFAULT_REMOVE_RANGE);
	RemoveBuildingForPlayer(playerid, 6516, 717.6875, -1357.2813, 18.0469, 0.25);
	RemoveBuildingForPlayer(playerid, 1415, 732.8516, -1332.8984, 12.6875, 0.25);
	RemoveBuildingForPlayer(playerid, 1439, 732.7266, -1341.7734, 12.6328, 0.25);
	
	//Repülõgép temetõ benzinkút - Tommy Block - 2013.02.22.
	RemoveBuildingForPlayer(playerid, 16598, 231.2813, 2545.7969, 20.0234, 0.25);
	RemoveBuildingForPlayer(playerid, 16599, 231.2813, 2545.7969, 20.0234, 0.25);

	//LS templomhoz - Terno - 2012-03-07
	RemoveBuildingForPlayer(playerid, 713, 2275.3906, -1438.6641, 22.5547, 0.25);
	RemoveBuildingForPlayer(playerid, 673, 2229.0234, -1411.6406, 22.9609, 50.0);
	RemoveBuildingForPlayer(playerid, 5682, 2241.4297, -1433.6719, 31.2813, 0.25);
	RemoveBuildingForPlayer(playerid, 700, 2226.5156, -1426.7656, 23.1172, 0.25);
	RemoveBuildingForPlayer(playerid, 620, 2256.4063, -1444.5078, 23.1016, 0.25);
	RemoveBuildingForPlayer(playerid, 1297, 2266.0859, -1442.0703, 26.3906, 10.0);
	RemoveBuildingForPlayer(playerid, 3593, 2261.7734, -1441.1016, 23.5000, 10.0);
	
	//Terno -LS reptér ugratók -2012-03-04
	RemoveBuildingForPlayer(playerid, 3769, 1961.4453, -2216.1719, 14.9844, 0.25);
	RemoveBuildingForPlayer(playerid, 3625, 1961.4453, -2216.1719, 14.9844, 0.25);
	
	// Kamion hq
	RemoveBuildingForPlayer(playerid, 3777, 831.9609, -1191.1406, 25.0391, DEFAULT_REMOVE_RANGE);
	RemoveBuildingForPlayer(playerid, 5926, 816.3359, -1217.1484, 26.4453, 0.25);
	RemoveBuildingForPlayer(playerid, 6005, 895.2578, -1256.9297, 31.2344, 0.25);
	RemoveBuildingForPlayer(playerid, 5836, 816.3359, -1217.1484, 26.4453, 0.25);
	RemoveBuildingForPlayer(playerid, 3776, 831.9609, -1191.1406, 25.0391, DEFAULT_REMOVE_RANGE);
	RemoveBuildingForPlayer(playerid, 5838, 895.2578, -1256.9297, 31.2344, 0.25);
	
	//Benzin HQ Terno Tommys 2012.01.20
	RemoveBuildingForPlayer(playerid, 3244, 2632.3906, -2073.6406, 12.7578, 50.0);
	RemoveBuildingForPlayer(playerid, 3683, 2684.7656, -2088.0469, 20.1172, 0.25);
	RemoveBuildingForPlayer(playerid, 3290, 2647.1016, -2073.3750, 12.4453, 50.0);
	RemoveBuildingForPlayer(playerid, 3779, 2653.9375, -2092.3359, 20.0078, 0.25);
	RemoveBuildingForPlayer(playerid, 3637, 2653.9375, -2092.3359, 20.0078, 0.25);
	RemoveBuildingForPlayer(playerid, 3636, 2684.7656, -2088.0469, 20.1172, 0.25);
	
	//zavaró helyne lévõ oszlopok kukák
	RemoveBuildingForPlayer(playerid, 1294, 1385.2422, -1766.5781, 16.9063, 0.25);
	RemoveBuildingForPlayer(playerid, 1226, 1451.6250, -1727.6719, 16.4219, 100.0);
	RemoveBuildingForPlayer(playerid, 1294, 1453.5000, -1038.1484, 27.3516, 0.25);
	RemoveBuildingForPlayer(playerid, 1297, 2076.3359, -1141.4063, 26.0859, 0.25);
	RemoveBuildingForPlayer(playerid, 1290, 1053.3750, -1842.7188, 18.2266, 0.25);
	RemoveBuildingForPlayer(playerid, 1297, 937.5547, -1213.8672, 18.5938, 0.25);
	RemoveBuildingForPlayer(playerid, 1211, 555.1563, -1251.9297, 16.6406, 0.25);
	RemoveBuildingForPlayer(playerid, 1226, 667.7266, -1058.9375, 52.1563, 0.25);
	RemoveBuildingForPlayer(playerid, 1226, -2010.7344, 158.5391, 30.5547, 0.25);
	RemoveBuildingForPlayer(playerid, 1226, -1707.1094, 681.4453, 27.7422, 0.25);
	RemoveBuildingForPlayer(playerid, 10248, -1680.9922, 683.2344, 19.0469, 0.25);
	RemoveBuildingForPlayer(playerid, 966, -1701.4297, 687.5938, 23.8828, 0.25);

	// LS határnál egy tábla kivéve, Nick által - 2012 Június 12
	RemoveBuildingForPlayer(playerid, 3336, -16.3281, -1526.5547, 1.0703, 0.25);
	
	//Terno Régi oktató SF kapi - 2012-04-17 (2017.06.27 jelenleg depó)
	RemoveBuildingForPlayer(playerid, 11372, -2076.4375, -107.9297, 36.9688, 0.25);
	RemoveBuildingForPlayer(playerid, 11014, -2076.4375, -107.9297, 36.9688, 0.25);
	
	//William - GNI-be kerítés 2012-03-14
	RemoveBuildingForPlayer(playerid, 13699, 596.2500, -1138.0078, 47.8516, 0.25);
	RemoveBuildingForPlayer(playerid, 13861, 570.3047, -1097.7656, 72.6953, 0.25);

	//Terno Tommys 2012.01.20 Oktató hq elõtt egy villanyoszlop
	RemoveBuildingForPlayer(playerid, 1297, 1052.8438, -1468.0859, 15.9375,0.25);

	//Alsó parkoló Autópálya oszlop
	RemoveBuildingForPlayer(playerid, 4097, 1605.1406, -1728.9375, 18.2734, 0.25);
	RemoveBuildingForPlayer(playerid, 4091, 1605.1406, -1728.9375, 18.2734, 0.25);
	
	//LS gyár bejáratában lévõ lámpa
	RemoveBuildingForPlayer(playerid, 1297, 2833.3047, -1593.1797, 13.3281, 0.25);

	//CCOK rutinpályához - Heller - 2012-05-09
	RemoveBuildingForPlayer(playerid, 4116, 1345.6250, -1552.9609, 48.5156, 0.25);
	RemoveBuildingForPlayer(playerid, 4113, 1345.6250, -1552.9609, 48.5156, 0.25);
	
	//Mentõ HQ - HendRoox - 2017-06-27
	RemoveBuildingForPlayer(playerid, 1529, 1098.8125, -1292.5469, 17.1406, 0.25);
	RemoveBuildingForPlayer(playerid, 5935, 1120.1563, -1303.4531, 18.5703, 0.25);
	RemoveBuildingForPlayer(playerid, 5936, 1090.0547, -1310.5313, 17.5469, 0.25);
	RemoveBuildingForPlayer(playerid, 5788, 1080.9844, -1305.5234, 16.3594, 0.25);
	RemoveBuildingForPlayer(playerid, 5787, 1090.0547, -1310.5313, 17.5469, 0.25);
	RemoveBuildingForPlayer(playerid, 5811, 1131.1953, -1380.4219, 17.0703, 0.25);
	RemoveBuildingForPlayer(playerid, 1440, 1148.6797, -1385.1875, 13.2656, 10.0);
	RemoveBuildingForPlayer(playerid, 5737, 1120.1563, -1303.4531, 18.5703, 0.25);

	//Aztec HQ Vlad D Dueno 2012.11.10
	RemoveBuildingForPlayer(playerid, 1290, 1687.3594, -2076.5703, 18.3750, 0.25);
	RemoveBuildingForPlayer(playerid, 3573, 1798.6484, -2057.9141, 14.9844, 0.25);

	//közlekedési lámpák LS Terno Tommys 2012.01.19
	RemoveBuildingForPlayer(playerid, 1283, 1335.1953, -1731.7813, 15.6250, 70.0);
	RemoveBuildingForPlayer(playerid, 1283, 1411.2188, -1872.9297, 15.6250, 70.0);
	RemoveBuildingForPlayer(playerid, 1283, 1553.9844, -1873.0703, 15.6250, 70.0);
	RemoveBuildingForPlayer(playerid, 1283, 1582.6719, -1733.1328, 15.6250, 25.0);
	RemoveBuildingForPlayer(playerid, 1283, 1736.5313, -1731.7969, 15.6250, 80.0);
	RemoveBuildingForPlayer(playerid, 1283, 1703.9063, -1593.6719, 15.6250, 80.0);
	RemoveBuildingForPlayer(playerid, 1283, 1821.0313, -1601.2344, 15.6406, 25.0);
	RemoveBuildingForPlayer(playerid, 1283, 1976.1328, -1341.8125, 26.0469, 140.0);
	RemoveBuildingForPlayer(playerid, 1283, 1846.0469, -1449.8828, 15.9375, 25.0);
	RemoveBuildingForPlayer(playerid, 1283, 1852.5391, -1272.3672, 15.5938, 25.0);
	RemoveBuildingForPlayer(playerid, 1283, 1463.3984, -1159.5156, 25.9922, 50.0);
	RemoveBuildingForPlayer(playerid, 1283, 1575.4688, -1152.5859, 26.1953, 25.0);
	RemoveBuildingForPlayer(playerid, 1283, 1707.0625, -1159.1016, 25.8359, 25.0);
	RemoveBuildingForPlayer(playerid, 1283, 1345.1641, -1269.2578, 16.0781, 60.0);
	RemoveBuildingForPlayer(playerid, 1283, 1369.2422, -1046.8672, 28.6641, 50.0);
	RemoveBuildingForPlayer(playerid, 1283, 1083.3906, -1130.2734, 25.9063, 220.0);
	RemoveBuildingForPlayer(playerid, 1283, 1260.3906, -946.7266, 44.4375, 40.0);
	RemoveBuildingForPlayer(playerid, 1283, 807.7031, -1139.5859, 25.8359, 40.0);
	RemoveBuildingForPlayer(playerid, 1283, 927.9453, -1327.8750, 15.5859, 60.0);
	RemoveBuildingForPlayer(playerid, 1283, 1244.0391, -1406.5313, 15.1641, 80.0);
	RemoveBuildingForPlayer(playerid, 1284, 633.9609, -1720.7891, 16.1953, 50.0);
	RemoveBuildingForPlayer(playerid, 1283, 1193.1328, -1851.4688, 15.6250, 40.0);
	
	//Lebegõ fák
	RemoveBuildingForPlayer(playerid, 1308, 9.0234, 15.1563, -5.7109, 0.25);
	RemoveBuildingForPlayer(playerid, 1297, -2468.6484, -2457.3828, 39.8984, 0.25);
	RemoveBuildingForPlayer(playerid, 1297, -2485.0938, -2394.8281, 34.0625, 0.25);
	RemoveBuildingForPlayer(playerid, 672, 385.1953, 80.8203, 5.9063, 0.25);
	RemoveBuildingForPlayer(playerid, 672, -399.8516, 234.8203, 10.2266, 0.25);
	RemoveBuildingForPlayer(playerid, 672, -437.3594, 237.0781, 10.6641, 0.25);
	RemoveBuildingForPlayer(playerid, 672, 34.3047, -460.2266, 7.8672, 0.25);
	RemoveBuildingForPlayer(playerid, 727, -1226.6094, -747.5703, 61.1797, 0.25);
	RemoveBuildingForPlayer(playerid, 693, -733.0391, -1297.2266, 69.9922, 0.25);
	RemoveBuildingForPlayer(playerid, 693, -705.1641, -1321.4141, 68.3750, 0.25);
	RemoveBuildingForPlayer(playerid, 790, -854.0000, -1106.1953, 94.1250, 0.25);
	
	return 1;
}