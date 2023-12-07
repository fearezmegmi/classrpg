#if defined __fs_object_object_bonusz
	#endinput
#endif
#define __fs_object_object_bonusz

stock Keszites_Bonusz()
{
	VW = 66666;
	CivilSzint();
	IllegalisSzint();
	VW = NINCS;
	
	return 1;
}

// http://forum.sa-mp.com/showthread.php?t=483551
stock CivilSzint()
{
	//Bar
	new barfloor[128];
	barfloor[1] = CreateObject(19377, 170.02, 1748.33, 616.58,   0.00, 90.00, 0.00);
	barfloor[2] = CreateObject(19377, 170.02, 1746.73, 616.41,   0.00, 90.00, 0.00);
	barfloor[3] = CreateObject(19377, 170.02, 1745.30, 616.24,   0.00, 90.00, 0.00);
	barfloor[4] = CreateObject(19377, 164.23, 1741.27, 616.05,   0.00, 90.00, 0.00);
	barfloor[5] = CreateObject(19377, 159.68, 1731.65, 616.05,   0.00, 90.00, 0.00);
	barfloor[6] = CreateObject(19377, 153.73, 1741.27, 616.05,   0.00, 90.00, 0.00);
	barfloor[7] = CreateObject(19377, 164.23, 1750.90, 616.05,   0.00, 90.00, 0.00);
	barfloor[8] = CreateObject(19377, 143.24, 1741.27, 616.05,   0.00, 90.00, 0.00);
	barfloor[9] = CreateObject(19377, 143.24, 1750.88, 616.05,   0.00, 90.00, 0.00);
	barfloor[10] = CreateObject(19377, 153.74, 1750.88, 616.05,   0.00, 90.00, 0.00);
	for(new barfloorss = 0; barfloorss < sizeof(barfloor); barfloorss++)
	{
		new barfloors = barfloor[barfloorss];
		SetDynamicObjectMaterial(barfloors, 0, 13007, "sw_bankint", "woodfloor1", 0xFFFFFFFF);
	}
	new barfloorshadow[128];
	barfloorshadow[1] = CreateObject(19378, 170.01, 1748.32, 616.57,   0.00, 90.00, 0.00);
	barfloorshadow[2] = CreateObject(19378, 170.02, 1746.72, 616.40,   0.00, 90.00, 0.00);
	barfloorshadow[3] = CreateObject(19378, 170.01, 1745.28, 616.23,   0.00, 90.00, 0.00);
	barfloorshadow[4] = CreateObject(19450, 163.91, 1748.17, 616.16,   0.00, 90.00, 0.00);
	barfloorshadow[5] = CreateObject(19450, 156.40, 1748.22, 616.16,   0.00, 90.00, 0.00);
	barfloorshadow[6] = CreateObject(19450, 154.61, 1748.22, 616.16,   0.00, 90.00, 0.00);
	barfloorshadow[7] = CreateObject(19450, 147.84, 1741.40, 616.16,   0.00, 90.00, 0.00);
	barfloorshadow[8] = CreateObject(19450, 147.84, 1751.02, 616.16,   0.00, 90.00, 0.00);
	barfloorshadow[9] = CreateObject(19450, 162.87, 1752.06, 616.16,   0.00, 90.00, 90.00);
	for(new barfloorshadowss = 0; barfloorshadowss < sizeof(barfloorshadow); barfloorshadowss++)
	{
		new barfloorshadows = barfloorshadow[barfloorshadowss];
		SetDynamicObjectMaterial(barfloorshadows, 0, 13007, "sw_bankint", "woodfloor1", 0xFF505050);
	}
	new barwalllow[128];
	barwalllow[1] = CreateObject(19451, 169.39, 1741.22, 615.63,   0.00, 0.00, 0.00);
	barwalllow[2] = CreateObject(19451, 169.40, 1750.83, 615.63,   0.00, 0.00, 0.00);
	barwalllow[3] = CreateObject(19451, 164.83, 1748.34, 615.63,   0.00, 0.00, 0.00);
	barwalllow[4] = CreateObject(19451, 164.82, 1745.26, 615.63,   0.00, 0.00, 0.00);
	barwalllow[5] = CreateObject(19451, 169.62, 1752.74, 615.63,   0.00, 0.00, 90.00);
	barwalllow[6] = CreateObject(19451, 169.64, 1736.49, 615.63,   0.00, 0.00, 90.00);
	barwalllow[7] = CreateObject(19451, 164.89, 1731.73, 615.63,   0.00, 0.00, 0.00);
	barwalllow[8] = CreateObject(19451, 160.20, 1729.08, 615.63,   0.00, 0.00, 90.00);
	barwalllow[9] = CreateObject(19451, 155.56, 1731.73, 615.63,   0.00, 0.00, 0.00);
	barwalllow[10] = CreateObject(19451, 150.81, 1736.49, 615.63,   0.00, 0.00, 90.00);
	barwalllow[11] = CreateObject(19451, 155.56, 1748.28, 615.63,   0.00, 0.00, 0.00);
	barwalllow[12] = CreateObject(19451, 160.27, 1753.05, 615.63,   0.00, 0.00, 90.00);
	barwalllow[13] = CreateObject(19451, 146.05, 1741.24, 615.63,   0.00, 0.00, 0.00);
	barwalllow[14] = CreateObject(19451, 146.05, 1750.87, 615.63,   0.00, 0.00, 0.00);
	barwalllow[15] = CreateObject(19451, 150.84, 1753.06, 615.63,   0.00, 0.00, 90.00);
	barwalllow[16] = CreateObject(19451, 164.79, 1745.26, 615.63,   0.00, 0.00, 0.00);
	barwalllow[17] = CreateObject(19451, 164.79, 1754.90, 615.63,   0.00, 0.00, 0.00);
	barwalllow[18] = CreateObject(19451, 155.53, 1748.27, 615.63,   0.00, 0.00, 0.00);
	for(new barwalllowss = 0; barwalllowss < sizeof(barwalllow); barwalllowss++)
	{
		new barwalllows = barwalllow[barwalllowss];
		SetDynamicObjectMaterial(barwalllows, 0, 16150, "ufo_bar", "brwall_128", 0xFFFFFFFF);
	}
	new barwalllo[128];
	barwalllo[1] = CreateObject(19451, 169.39, 1741.22, 619.34,   0.00, 0.00, 0.00);
	barwalllo[2] = CreateObject(19451, 169.40, 1750.83, 619.34,   0.00, 0.00, 0.00);
	barwalllo[3] = CreateObject(19359, 164.81, 1751.90, 619.34,   0.00, 0.00, 0.00);
	barwalllo[4] = CreateObject(19359, 164.81, 1742.05, 619.34,   0.00, 0.00, 0.00);
	barwalllo[5] = CreateObject(19451, 169.62, 1752.74, 619.34,   0.00, 0.00, 90.00);
	barwalllo[6] = CreateObject(19451, 169.64, 1736.49, 619.34,   0.00, 0.00, 90.00);
	barwalllo[7] = CreateObject(19451, 164.89, 1731.73, 619.34,   0.00, 0.00, 0.00);
	barwalllo[8] = CreateObject(19451, 160.20, 1729.08, 619.34,   0.00, 0.00, 90.00);
	barwalllo[9] = CreateObject(19451, 155.56, 1731.73, 619.34,   0.00, 0.00, 0.00);
	barwalllo[10] = CreateObject(19451, 150.81, 1736.49, 619.34,   0.00, 0.00, 90.00);
	barwalllo[11] = CreateObject(19451, 160.27, 1753.05, 619.34,   0.00, 0.00, 90.00);
	barwalllo[12] = CreateObject(19451, 160.27, 1753.05, 619.34,   0.00, 0.00, 90.00);
	barwalllo[13] = CreateObject(19451, 146.05, 1741.24, 619.34,   0.00, 0.00, 0.00);
	barwalllo[14] = CreateObject(19451, 146.05, 1750.87, 619.34,   0.00, 0.00, 0.00);
	barwalllo[15] = CreateObject(19451, 150.84, 1753.06, 619.34,   0.00, 0.00, 90.00);
	for(new barwallloss = 0; barwallloss < sizeof(barwalllo); barwallloss++)
	{
		new barwalllos = barwalllo[barwallloss];
		SetDynamicObjectMaterial(barwalllos, 0, 16150, "ufo_bar", "beigehotel_128", 0xFFFFFFFF);
	}
	new barceiling[128];
	barceiling[1] = CreateObject(19377, 164.29, 1748.07, 620.10,   0.00, 90.00, 0.00);
	barceiling[2] = CreateObject(19377, 164.30, 1738.45, 620.10,   0.00, 90.00, 0.00);
	barceiling[3] = CreateObject(19377, 153.80, 1738.45, 620.10,   0.00, 90.00, 0.00);
	barceiling[4] = CreateObject(19377, 143.28, 1738.45, 620.10,   0.00, 90.00, 0.00);
	barceiling[5] = CreateObject(19377, 153.80, 1748.07, 620.10,   0.00, 90.00, 0.00);
	barceiling[6] = CreateObject(19377, 143.28, 1748.07, 620.10,   0.00, 90.00, 0.00);
	barceiling[7] = CreateObject(19377, 160.66, 1728.81, 620.10,   0.00, 90.00, 0.00);
	for(new barceilingss = 0; barceilingss < sizeof(barceiling); barceilingss++)
	{
		new barceilings = barceiling[barceilingss];
		SetDynamicObjectMaterial(barceilings, 0, 16150, "ufo_bar", "GEwhite1_64", 0xFFFFFFFF);
	}
	new barceilingp2[128];
	barceilingp2[1] = CreateObject(19378, 168.86, 1749.56, 619.94,   0.00, 90.00, 0.00);
	barceilingp2[2] = CreateObject(19378, 168.86, 1739.93, 619.94,   0.00, 90.00, 0.00);
	barceilingp2[3] = CreateObject(19378, 164.09, 1732.71, 619.93,   0.00, 90.00, 0.00);
	barceilingp2[4] = CreateObject(19378, 153.60, 1732.71, 619.93,   0.00, 90.00, 0.00);
	barceilingp2[5] = CreateObject(19378, 143.10, 1732.71, 619.93,   0.00, 90.00, 0.00);
	barceilingp2[6] = CreateObject(19378, 142.52, 1742.34, 619.93,   0.00, 90.00, 0.00);
	barceilingp2[7] = CreateObject(19378, 142.52, 1751.96, 619.93,   0.00, 90.00, 0.00);
	barceilingp2[8] = CreateObject(19378, 153.02, 1756.28, 619.93,   0.00, 90.00, 0.00);
	barceilingp2[9] = CreateObject(19378, 163.52, 1756.28, 619.93,   0.00, 90.00, 0.00);
	for(new barceilingp2ss = 0; barceilingp2ss < sizeof(barceilingp2); barceilingp2ss++)
	{
		new barceilingp2s = barceilingp2[barceilingp2ss];
		SetDynamicObjectMaterial(barceilingp2s, 0, 16150, "ufo_bar", "GEwhite1_64", 0xFF959595);
	}
	new barceilingshadow[128];
	barceilingshadow[1] = CreateObject(19375, 168.85, 1749.56, 619.95,   0.00, 90.00, 0.00);
	barceilingshadow[2] = CreateObject(19375, 168.85, 1739.93, 619.95,   0.00, 90.00, 0.00);
	barceilingshadow[3] = CreateObject(19375, 158.47, 1732.73, 619.95,   0.00, 90.00, 0.00);
	barceilingshadow[4] = CreateObject(19375, 147.97, 1732.73, 619.95,   0.00, 90.00, 0.00);
	barceilingshadow[5] = CreateObject(19375, 142.55, 1742.13, 619.95,   0.00, 90.00, 0.00);
	barceilingshadow[6] = CreateObject(19375, 142.55, 1751.74, 619.95,   0.00, 90.00, 0.00);
	barceilingshadow[7] = CreateObject(19375, 152.90, 1756.26, 619.95,   0.00, 90.00, 0.00);
	barceilingshadow[8] = CreateObject(19375, 163.36, 1756.26, 619.95,   0.00, 90.00, 0.00);
	for(new barceilingshadowss = 0; barceilingshadowss < sizeof(barceilingshadow); barceilingshadowss++)
	{
		new barceilingshadows = barceilingshadow[barceilingshadowss];
		SetDynamicObjectMaterial(barceilingshadows, 0, 16150, "ufo_bar", "GEwhite1_64", 0xFF505050);
	}
	new barcounter[128];
	barcounter[1] = CreateObject(2439, 164.32, 1734.20, 616.14,   0.00, 0.00, 180.00);
	barcounter[2] = CreateObject(2439, 163.33, 1734.20, 616.14,   0.00, 0.00, 180.00);
	barcounter[3] = CreateObject(2439, 162.33, 1734.20, 616.14,   0.00, 0.00, 180.00);
	barcounter[4] = CreateObject(2439, 161.34, 1734.20, 616.14,   0.00, 0.00, 180.00);
	barcounter[5] = CreateObject(2439, 160.34, 1734.20, 616.14,   0.00, 0.00, 180.00);
	barcounter[6] = CreateObject(2440, 159.35, 1734.20, 616.14,   0.00, 0.00, 180.00);
	barcounter[7] = CreateObject(2439, 159.32, 1733.20, 616.14,   0.00, 0.00, -90.00);
	for(new barcounterss = 0; barcounterss < sizeof(barcounter); barcounterss++)
	{
		new barcounters = barcounter[barcounterss];
		SetDynamicObjectMaterial(barcounters, 0, 12954, "sw_furniture", "CJ_WOOD5", 0xFFFFFFFF);
		SetDynamicObjectMaterial(barcounters, 1, 4600, "theatrelan2", "gm_labuld2_d", 0xFFFFFFFF);
	}
	new barcounterup[128];
	barcounterup[1] = CreateObject(2439, 164.32, 1734.20, 620.03,   0.00, 180.00, 180.00);
	barcounterup[2] = CreateObject(2439, 163.33, 1734.20, 620.03,   0.00, 180.00, 180.00);
	barcounterup[3] = CreateObject(2439, 162.33, 1734.20, 620.03,   0.00, 180.00, 180.00);
	barcounterup[4] = CreateObject(2439, 161.34, 1734.20, 620.03,   0.00, 180.00, 180.00);
	barcounterup[5] = CreateObject(2439, 160.34, 1734.20, 620.03,   0.00, 180.00, 180.00);
	barcounterup[6] = CreateObject(2440, 159.34, 1734.17, 620.03,   0.00, 180.00, -90.00);
	barcounterup[7] = CreateObject(2439, 159.33, 1733.17, 620.03,   0.00, 180.00, -90.00);
	for(new barcounterupss = 0; barcounterupss < sizeof(barcounterup); barcounterupss++)
	{
		new barcounterups = barcounterup[barcounterupss];
		SetDynamicObjectMaterial(barcounterups, 0, 12954, "sw_furniture", "CJ_WOOD5", 0xFFFFFFFF);
		SetDynamicObjectMaterial(barcounterups, 1, 12954, "sw_furniture", "CJ_WOOD5", 0xFFFFFFFF);
	}
	/*new barstool[128];
	barstool[1] = CreateObject(2723, 164.23, 1735.39, 616.48,   0.00, 0.00, 0.00);
	barstool[2] = CreateObject(2723, 163.27, 1735.39, 616.48,   0.00, 0.00, 0.00);
	barstool[3] = CreateObject(2723, 162.29, 1735.39, 616.48,   0.00, 0.00, 0.00);
	barstool[4] = CreateObject(2723, 161.31, 1735.39, 616.48,   0.00, 0.00, 0.00);
	barstool[5] = CreateObject(2723, 160.29, 1735.39, 616.48,   0.00, 0.00, 0.00);
	for(new barstoolss = 0; barstoolss < sizeof(barstool); barstoolss++)
	{
		new barstools = barstool[barstoolss];
		SetDynamicObjectMaterial(barstools, 0, 12954, "sw_furniture", "CJ_WOOD5", 0xFF909090);
		SetDynamicObjectMaterial(barstools, 1, 10226, "sfeship1", "CJ_RED_LEATHER", 0xFF808080);
	}*/
	new bardoor[64];
	bardoor[1] = CreateObject(1537, 165.76, 1752.62, 616.67,   0.00, 0.00, 180.00);
	bardoor[2] = CreateObject(1537, 167.26, 1752.64, 616.67,   0.00, 0.00, 179.82);
	SetDynamicObjectMaterial(bardoor[1], 1, 10871, "blacksky_sfse", "ws_skywinsgreen", 0xFFFFFFFF);
	SetDynamicObjectMaterial(bardoor[1], 2, 3975, "lanbloke", "p_floor3", 0xFFFFFFFF);
	SetDynamicObjectMaterial(bardoor[2], 1, 10871, "blacksky_sfse", "ws_skywinsgreen", 0xFFFFFFFF);
	SetDynamicObjectMaterial(bardoor[2], 2, 3975, "lanbloke", "p_floor3", 0xFFFFFFFF);
	new barbar[128];
	barbar[1] = CreateObject(2128, 164.32, 1729.63, 616.14,   0.00, 0.00, 180.00);
	barbar[2] = CreateObject(2414, 163.32, 1729.38, 616.14,   0.00, 0.00, 180.00);
	barbar[3] = CreateObject(2414, 161.32, 1729.38, 616.14,   0.00, 0.00, 180.00);
	barbar[4] = CreateObject(2128, 159.31, 1729.63, 616.14,   0.00, 0.00, 180.00);
	SetDynamicObjectMaterial(barbar[1], 1, 16150, "ufo_bar", "cos_beercab", 0xFFFFFFFF);
	SetDynamicObjectMaterial(barbar[4], 1, 16150, "ufo_bar", "cos_beercab", 0xFFFFFFFF);
	SetDynamicObjectMaterial(barbar[2], 2, 16150, "ufo_bar", "sa_wood07_128", 0xFFFFFFFF);
	SetDynamicObjectMaterial(barbar[3], 2, 16150, "ufo_bar", "sa_wood07_128", 0xFFFFFFFF);
	SetDynamicObjectMaterial(barbar[2], 1, 16150, "ufo_bar", "sa_wood08_128", 0xFFFFFFFF);
	SetDynamicObjectMaterial(barbar[3], 1, 16150, "ufo_bar", "sa_wood08_128", 0xFFFFFFFF);
	new barcouch[128];
	barcouch[1] = CreateObject(2639, 156.87, 1744.03, 616.86,   0.00, 0.00, 0.00);
	barcouch[2] = CreateObject(2639, 156.87, 1744.03, 616.86,   0.00, 0.00, 0.00);
	barcouch[3] = CreateObject(2639, 156.87, 1746.81, 616.86,   0.00, 0.00, 180.00);
	barcouch[4] = CreateObject(2639, 156.83, 1747.71, 616.86,   0.00, 0.00, 0.00);
	barcouch[5] = CreateObject(2639, 156.87, 1750.29, 616.86,   0.00, 0.00, 180.00);
	barcouch[6] = CreateObject(2639, 158.62, 1751.77, 616.86,   0.00, 0.00, -90.00);
	barcouch[7] = CreateObject(2639, 163.52, 1744.03, 616.86,   0.00, 0.00, 0.00);
	barcouch[8] = CreateObject(2639, 163.52, 1746.81, 616.86,   0.00, 0.00, 180.00);
	barcouch[9] = CreateObject(2639, 163.49, 1747.71, 616.86,   0.00, 0.00, 0.00);
	barcouch[10] = CreateObject(2639, 163.52, 1750.29, 616.86,   0.00, 0.00, 180.00);
	barcouch[11] = CreateObject(2639, 161.80, 1751.79, 616.86,   0.00, 0.00, 90.00);
	barcouch[12] = CreateObject(2639, 154.18, 1744.03, 616.86,   0.00, 0.00, 0.00);
	barcouch[13] = CreateObject(2639, 154.18, 1747.71, 616.86,   0.00, 0.00, 0.00);
	barcouch[14] = CreateObject(2639, 154.18, 1746.81, 616.86,   0.00, 0.00, 180.00);
	barcouch[15] = CreateObject(2639, 154.18, 1750.29, 616.86,   0.00, 0.00, 180.00);
	barcouch[16] = CreateObject(2639, 148.33, 1737.06, 616.86,   0.00, 0.00, 0.00);
	barcouch[17] = CreateObject(2639, 146.71, 1738.90, 616.86,   0.00, 0.00, -90.00);
	barcouch[18] = CreateObject(2639, 148.35, 1740.70, 616.86,   0.00, 0.00, 180.00);
	barcouch[19] = CreateObject(2639, 146.71, 1743.48, 616.86,   0.00, 0.00, -90.00);
	barcouch[20] = CreateObject(2639, 148.33, 1741.60, 616.86,   0.00, 0.00, 0.00);
	barcouch[21] = CreateObject(2639, 148.35, 1745.29, 616.86,   0.00, 0.00, 180.00);
	barcouch[22] = CreateObject(2639, 148.32, 1746.18, 616.86,   0.00, 0.00, 0.00);
	barcouch[23] = CreateObject(2639, 146.71, 1747.89, 616.86,   0.00, 0.00, -90.00);
	barcouch[24] = CreateObject(2639, 148.35, 1751.93, 616.86,   0.00, 0.00, 180.00);
	barcouch[25] = CreateObject(2639, 146.72, 1750.15, 616.86,   0.00, 0.00, -90.00);
	for(new barcouchss = 0; barcouchss < sizeof(barcouch); barcouchss++)
	{
		new barcouchs = barcouch[barcouchss];
		SetDynamicObjectMaterial(barcouchs, 1, 1250, "smashbarr", "redstuff", 0xFF505050);
	}
	new bartable[128];
	bartable[1] = CreateObject(2637, 148.32, 1748.01, 616.64,   0.00, 0.00, 90.00);
	bartable[2] = CreateObject(2637, 148.32, 1750.09, 616.64,   0.00, 0.00, 90.00);
	bartable[3] = CreateObject(2637, 148.32, 1743.40, 616.64,   0.00, 0.00, 90.00);
	bartable[4] = CreateObject(2637, 148.32, 1738.89, 616.64,   0.00, 0.00, 90.00);
	bartable[5] = CreateObject(2637, 154.18, 1748.94, 616.64,   0.00, 0.00, 0.00);
	bartable[6] = CreateObject(2637, 154.18, 1745.41, 616.64,   0.00, 0.00, 0.00);
	bartable[7] = CreateObject(2637, 163.52, 1748.94, 616.64,   0.00, 0.00, 0.00);
	bartable[8] = CreateObject(2637, 163.52, 1745.41, 616.64,   0.00, 0.00, 0.00);
	bartable[9] = CreateObject(2637, 160.27, 1751.79, 616.64,   0.00, 0.00, 90.00);
	bartable[10] = CreateObject(2637, 156.87, 1748.94, 616.64,   0.00, 0.00, 0.00);
	bartable[11] = CreateObject(2637, 156.87, 1745.41, 616.64,   0.00, 0.00, 0.00);
	for(new bartabless = 0; bartabless < sizeof(bartable); bartabless++)
	{
		new bartables = bartable[bartabless];
		SetDynamicObjectMaterial(bartables, 1, 12954, "sw_furniture", "CJ_WOOD5", 0xFFFFFFFF);
	}
	new bartv[128];
	bartv[1] = CreateObject(2267, 146.35, 1745.50, 618.83,   0.00, 0.00, 90.00);
	bartv[2] = CreateObject(2267, 155.58, 1752.90, 618.83,   0.00, 0.00, 0.00);
	bartv[3] = CreateObject(2267, 164.76, 1734.37, 618.30,   0.00, 0.00, -90.00);
	for(new bartvss = 0; bartvss < sizeof(bartv); bartvss++)
	{
		new bartvs = bartv[bartvss];
		SetDynamicObjectMaterial(bartvs, 0, 9362, "sfn_byofficeint", "CJ_TV1", 0xFFFFFFFF);
		SetDynamicObjectMaterial(bartvs, 1, 10226, "sfeship1", "CJ_TV_SCREEN", 0xFFFFFFFF);
	}
	new barpod[128];
	barpod[1] = CreateObject(19451, 163.92, 1748.18, 616.18,   0.00, 90.00, 0.00);
	barpod[2] = CreateObject(19451, 156.39, 1748.23, 616.18,   0.00, 90.00, 0.00);
	barpod[3] = CreateObject(19451, 154.62, 1748.24, 616.17,   0.00, 90.00, 0.00);
	barpod[4] = CreateObject(19451, 147.81, 1741.32, 616.17,   0.00, 90.00, 0.00);
	barpod[5] = CreateObject(19451, 147.81, 1750.94, 616.17,   0.00, 90.00, 0.00);
	barpod[6] = CreateObject(19451, 162.85, 1752.09, 616.17,   0.00, 90.00, 90.00);
	for(new barpodss = 0; barpodss < sizeof(barpod); barpodss++)
	{
		new barpods = barpod[barpodss];
		SetDynamicObjectMaterial(barpods, 0, 19379, "all_walls", "mp_shop_floor2", 0xFFFFFFFF);
	}
	SetDynamicObjectMaterial(CreateObject(2256, 162.73, 1729.22, 617.39,   0.00, 0.00, 180.00), 0, 16150, "ufo_bar", "cos_liqbots", 0xFFFFFFFF);
	SetDynamicObjectMaterial(CreateObject(2256, 160.88, 1729.22, 617.39,   0.00, 0.00, 180.00), 0, 16150, "ufo_bar", "cos_liqbots", 0xFFFFFFFF);
	SetDynamicObjectMaterial(CreateObject(2256, 160.21, 1752.89, 618.51,   0.00, 0.00, 0.00), 0, 16150, "ufo_bar", "des_intufowin", 0xFFFFFFFF);
	SetDynamicObjectMaterial(CreateObject(2256, 151.27, 1752.93, 618.51,   0.00, 0.00, 0.00), 0, 16150, "ufo_bar", "des_intufowin", 0xFFFFFFFF);
	SetDynamicObjectMaterial(CreateObject(19325, 164.77, 1746.99, 619.20,   0.00, 0.00, 0.00),  0, 16150, "ufo_bar", "des_intufowin", 0x80FFFFFF);
	SetDynamicObjectMaterial(CreateObject(2256, 169.25, 1748.44, 618.46,   0.00, 0.00, -90.00), 0, 16150, "ufo_bar", "des_intufowin", 0xFFFFFFFF);
	SetDynamicObjectMaterial(CreateObject(2256, 169.26, 1739.26, 618.46,   0.00, 0.00, -90.00), 0, 16150, "ufo_bar", "des_intufowin", 0xFFFFFFFF);
	SetDynamicObjectMaterial(CreateObject(2256, 169.28, 1743.58, 618.46,   0.00, 0.00, -90.00), 0, 16150, "ufo_bar", "des_intufowin", 0xFFFFFFFF);
	SetDynamicObjectMaterial(CreateObject(1311, 152.00, 1734.21, 619.05,   0.00, 0.00, 0.00), 1, 12954, "sw_furniture", "CJ_WOOD5", 0xFFFFFFFF);
	SetDynamicObjectMaterial(CreateObject(1569, 156.56, 1729.11, 616.08,   0.00, 0.00, 0.00), 0, 16150, "ufo_bar", "des_backdoor1", 0xFFFFFFFF);
	SetDynamicObjectMaterial(CreateObject(1569, 152.09, 1736.53, 616.08,   0.00, 0.00, 0.00), 0, 16150, "ufo_bar", "des_backdoor1", 0xFFFFFFFF);
	SetDynamicObjectMaterial(CreateObject(2011, 155.64, 1742.84, 616.14,   0.00, 0.00, 0.00), 3, 8617, "vgseflowers", "newtreeleaves128", 0xFF959595);
	SetDynamicObjectMaterial(CreateObject(2011, 164.05, 1742.85, 616.14,   0.00, 0.00, 0.00), 3, 8617, "vgseflowers", "newtreeleaves128", 0xFF959595);
	SetDynamicObjectMaterial(CreateObject(2011, 168.64, 1737.12, 616.14,   0.00, 0.00, 0.00), 3, 8617, "vgseflowers", "newtreeleaves128", 0xFF959595);
	SetDynamicObjectMaterial(CreateObject(2011, 146.55, 1737.00, 616.22,   0.00, 0.00, 0.00), 3, 8617, "vgseflowers", "newtreeleaves128", 0xFF959595);
	SetDynamicObjectMaterial(CreateObject(2011, 146.58, 1741.11, 616.22,   0.00, 0.00, 0.00), 3, 8617, "vgseflowers", "newtreeleaves128", 0xFF959595);
	SetDynamicObjectMaterial(CreateObject(2011, 146.68, 1745.70, 616.22,   0.00, 0.00, 0.00), 3, 8617, "vgseflowers", "newtreeleaves128", 0xFF959595);
	SetDynamicObjectMaterial(CreateObject(2011, 146.67, 1752.21, 616.22,   0.00, 0.00, 0.00), 3, 8617, "vgseflowers", "newtreeleaves128", 0xFF959595);
	SetDynamicObjectMaterial(CreateObject(2011, 154.75, 1752.06, 616.22,   0.00, 0.00, 0.00), 3, 8617, "vgseflowers", "newtreeleaves128", 0xFF959595);
	SetDynamicObjectMaterial(CreateObject(2011, 156.39, 1752.11, 616.22,   0.00, 0.00, 0.00), 3, 8617, "vgseflowers", "newtreeleaves128", 0xFF959595);
	SetDynamicObjectMaterial(CreateObject(2011, 164.11, 1752.32, 616.22,   0.00, 0.00, 0.00), 3, 8617, "vgseflowers", "newtreeleaves128", 0xFF959595);
	SetDynamicObjectMaterialText(CreateObject(1233, 155.54, 1743.83, 616.84,   0.00, 0.00, -90.00), 2, "z", OBJECT_MATERIAL_SIZE_256x128,\
		"Webdings", 130, 1, 0xFF810a0a, 0xFFFFFFFF, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	SetDynamicObjectMaterialText(CreateObject(1233, 155.58, 1743.81, 616.84,   0.00, 0.00, 90.00), 2, "z", OBJECT_MATERIAL_SIZE_256x128,\
		"Webdings", 130, 1, 0xFF810a0a, 0xFFFFFFFF, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
	CreateObject(18075, 158.46, 1743.77, 619.99,   0.00, 0.00, 0.00);
	CreateObject(18075, 147.23, 1743.77, 619.99,   0.00, 0.00, 0.00);
	CreateObject(2690, 154.32, 1736.58, 617.56,   0.00, 0.00, 0.00);
	CreateObject(2231, 164.75, 1752.83, 619.11,   20.00, 0.00, -45.00);
	CreateObject(2231, 146.38, 1752.94, 619.11,   20.00, 0.00, 45.00);
	CreateObject(2231, 146.08, 1736.92, 619.11,   20.00, 0.00, 135.00);
	CreateObject(2707, 164.14, 1734.39, 618.95,   0.00, 0.00, 0.00);
	CreateObject(2707, 162.87, 1734.39, 618.95,   0.00, 0.00, 0.00);
	CreateObject(2707, 161.60, 1734.39, 618.95,   0.00, 0.00, 0.00);
	CreateObject(2707, 160.29, 1734.39, 618.95,   0.00, 0.00, 0.00);
	CreateObject(1541, 163.08, 1733.82, 617.37,   0.00, 0.00, 180.00);
	CreateObject(1541, 160.96, 1733.82, 617.37,   0.00, 0.00, 180.00);
	CreateObject(19450, 169.43, 1747.85, 615.85,   0.00, 0.00, 0.00);
	CreateObject(19450, 169.43, 1738.25, 615.85,   0.00, 0.00, 0.00);
	CreateObject(19450, 169.68, 1736.45, 615.85,   0.00, 0.00, 90.00);
	CreateObject(19450, 164.92, 1731.73, 615.85,   0.00, 0.00, 0.00);
	CreateObject(19450, 160.12, 1729.06, 615.85,   0.00, 0.00, 90.00);
	CreateObject(19450, 155.54, 1731.72, 615.85,   0.00, 0.00, 0.00);
	CreateObject(19450, 150.80, 1736.47, 615.85,   0.00, 0.00, 90.00);
	CreateObject(19450, 146.03, 1741.25, 615.85,   0.00, 0.00, 0.00);
	CreateObject(19450, 146.03, 1750.89, 615.85,   0.00, 0.00, 0.00);
	CreateObject(19450, 150.80, 1753.07, 615.85,   0.00, 0.00, 90.00);
	CreateObject(19450, 160.17, 1753.07, 615.85,   0.00, 0.00, 90.00);
	CreateObject(19450, 169.71, 1752.77, 615.85,   0.00, 0.00, 90.00);
	CreateObject(19450, 164.81, 1748.39, 615.85,   0.00, 0.00, 0.00);
	CreateObject(19450, 164.80, 1745.27, 615.85,   0.00, 0.00, 0.00);
	CreateObject(19450, 155.54, 1748.30, 615.85,   0.00, 0.00, 0.00);
	CreateObject(1510, 163.84, 1734.38, 617.20,   0.00, 0.00, 0.00);
	CreateObject(1510, 160.55, 1734.21, 617.20,   0.00, 0.00, 0.00);
	CreateObject(1455, 164.08, 1734.20, 617.26,   0.00, 0.00, 0.00);
	//CreateObject(1455, 161.93, 1734.32, 617.26,   0.00, 0.00, 0.00);
}

// http://forum.sa-mp.com/showthread.php?t=463059
stock IllegalisSzint()
{
	CreateObject(19378, 543.48639, -147.19449, 1000.94000,   0.00000, 90.00000, 0.00000);
	CreateObject(19378, 533.00000, -147.23000, 1000.94000,   0.00000, 90.00000, 0.00000);
	CreateObject(19378, 532.98999, -156.67000, 1000.94000,   0.00000, 90.00000, 0.00000);
	CreateObject(19378, 543.47998, -156.67000, 1000.94000,   0.00000, 90.00000, 0.00000);
	CreateObject(19376, 527.65002, -156.67000, 1006.09998,   0.00000, 0.00000, 0.00000);
	CreateObject(19376, 527.65002, -147.03999, 1006.09998,   0.00000, 0.00000, 0.00000);
	CreateObject(19376, 532.56000, -142.31000, 1006.09998,   0.00000, 0.00000, 90.00000);
	CreateObject(19376, 542.19000, -142.31000, 1006.09998,   0.00000, 0.00000, 90.00000);
	CreateObject(19376, 551.81000, -142.31000, 1006.09998,   0.00000, 0.00000, 90.00000);
	CreateObject(19376, 548.82001, -147.22000, 1006.09998,   0.00000, 0.00000, 0.00000);
	CreateObject(19376, 548.82001, -156.85001, 1006.09998,   0.00000, 0.00000, 0.00000);
	CreateObject(19376, 543.92999, -161.58000, 1006.09998,   0.00000, 0.00000, 90.00000);
	CreateObject(19376, 534.29999, -161.58000, 1006.09998,   0.00000, 0.00000, 90.00000);
	CreateObject(19376, 524.66998, -161.58000, 1006.09998,   0.00000, 0.00000, 90.00000);
	CreateObject(19378, 543.48999, -147.21001, 1005.62000,   0.00000, 90.00000, 0.00000);
	CreateObject(19378, 532.98999, -147.21001, 1005.62000,   0.00000, 90.00000, 0.00000);
	CreateObject(19378, 529.46997, -156.84000, 1005.62000,   0.00000, 90.00000, 0.00000);
	CreateObject(19359, 527.58002, -168.16000, 1007.78003,   0.00000, 0.00000, 0.00000);
	CreateObject(19359, 540.00000, 8341.00000, -153.00000,   0.00000, 0.00000, 0.00000);
	CreateObject(19359, 542.00000, 3600.00000, -155.00000,   0.00000, 0.00000, 0.00000);
	CreateObject(1491, 536.00000, 1398.00000, -157.00000,   0.00000, 0.00000, 0.00000);
	CreateObject(1491, 536.00000, 3837.00000, -157.00000,   0.00000, 0.00000, 0.00000);
	CreateObject(1491, 536.00000, 1637.00000, -156.00000,   0.00000, 0.00000, 0.00000);
	CreateObject(1491, 532.00000, 8705.00000, -156.00000,   0.00000, 0.00000, 0.00000);
	CreateObject(1502, 532.00000, 8486.00000, -156.00000,   0.00000, 0.00000, 0.00000);
	CreateObject(6959, 537.00000, 7400.00000, -153.00000,   0.00000, 0.00000, 0.00000);
	CreateObject(19359, 539.00000, 4500.00000, -158.00000,   0.00000, 0.00000, 0.00000);
	CreateObject(19359, 540.00000, 7000.00000, -158.00000,   0.00000, 0.00000, 0.00000);
	CreateObject(19359, 540.00000, 8500.00000, -153.00000,   0.00000, 0.00000, 0.00000);
	CreateObject(19359, 539.00000, 8500.00000, -153.00000,   0.00000, 0.00000, 0.00000);
	CreateObject(19359, 538.00000, 1500.00000, -155.00000,   0.00000, 0.00000, 0.00000);
	CreateObject(19359, 541.00000, 8600.00000, -158.00000,   0.00000, 0.00000, 0.00000);
	CreateObject(2964, 544.28931, -158.21277, 1001.03003,   0.00000, 0.00000, 0.00000);
	CreateObject(2232, 528.01001, -150.66000, 1001.62000,   0.00000, 0.00000, 90.00000);
	CreateObject(2232, 528.09003, -147.61000, 1001.62000,   0.00000, 0.00000, 90.00000);
	CreateObject(1775, 529.84418, -161.01767, 1002.13000,   0.00000, 0.00000, 180.00000);
	CreateObject(956, 541.95129, -160.95511, 1001.42999,   0.00000, 0.00000, 180.00000);
	CreateObject(1661, 541.57635, -151.92299, 1005.12000,   0.00000, 0.00000, 0.00000);
	CreateObject(3034, 532.84003, -142.39999, 1003.44000,   0.01000, 0.00000, 0.00000);
	CreateObject(1786, 527.84003, -149.24001, 1001.50000,   0.00000, 0.00000, 90.00000);
	CreateObject(2313, 528.23999, -149.82001, 1001.03003,   0.00000, 0.00000, 90.00000);
	CreateObject(1726, 531.27722, -148.05334, 1001.03003,   0.00000, 0.00000, -90.00000);
	CreateObject(14891, 544.00000, 300.00000, -145.00000,   0.00000, 0.00000, 0.00000);
	CreateObject(3399, 534.00000, 7894.00000, -160.00000,   0.00000, 0.00000, 0.00000);
	CreateObject(3399, 537.00000, 6753.00000, -159.00000,   0.00000, 0.00000, 0.00000);
	CreateObject(3399, 535.00000, 7435.00000, -159.00000,   0.00000, 0.00000, 0.00000);
	CreateObject(19358, 541.00000, 5260.00000, -161.00000,   0.00000, 0.00000, 0.00000);
	CreateObject(19358, 547.00000, 1180.00000, -161.00000,   0.00000, 0.00000, 0.00000);
	CreateObject(19358, 532.00000, 9300.00000, -161.00000,   0.00000, 0.00000, 0.00000);
	CreateObject(6959, 533.02002, -155.03999, 1010.51001,   0.00000, 0.00000, 0.00000);
	CreateObject(16151, 538.17358, -143.45026, 1001.33002,   0.00000, 0.00000, 88.07320);
	CreateObject(2872, 532.38391, -161.03976, 1001.03003,   0.00000, 0.00000, 180.00000);
	CreateObject(2681, 534.92865, -161.01042, 1001.02002,   0.00000, 0.00000, 180.00000);
	CreateObject(2292, 528.21997, -142.95000, 1001.03003,   0.00000, 0.00000, 0.00000);
	CreateObject(2291, 528.75000, -142.92999, 1001.03003,   0.00000, 0.00000, 0.00000);
	CreateObject(2291, 529.75000, -142.92999, 1001.03003,   0.00000, 0.00000, 0.00000);
	CreateObject(2291, 528.25000, -144.48000, 1001.03003,   0.00000, 0.00000, 90.00000);
	CreateObject(2291, 528.25000, -145.53000, 1001.03003,   0.00000, 0.00000, 90.00000);
	CreateObject(1823, 530.28003, -145.06000, 1001.03003,   0.00000, 0.00000, 90.00000);
	CreateObject(19378, 544.96997, -156.84000, 1005.62000,   0.00000, 90.00000, 0.00000);
	CreateObject(1533, 527.78998, -157.89999, 1001.02002,   0.00000, 0.00000, 90.00000);
	CreateObject(19458, 536.46997, -153.63000, 1005.62000,   0.00000, 90.00000, 0.00000);
	CreateObject(19458, 539.93646, -153.62943, 1005.62000,   0.00000, 90.00000, 0.00000);
	CreateObject(19439, 536.45416, -159.23601, 1005.62000,   0.00000, 90.00000, 359.94501);
	CreateObject(19439, 536.45544, -160.83603, 1005.62000,   0.00000, 90.00000, 359.94501);
	CreateObject(19439, 539.91534, -160.83359, 1005.62000,   0.00000, 90.00000, 359.94501);
	CreateObject(19439, 539.93433, -159.23357, 1005.62000,   0.00000, 90.00000, 359.94501);
	CreateObject(1661, 537.46417, -145.15404, 1005.12000,   0.00000, 0.00000, 0.00000);
	CreateObject(1661, 531.86224, -151.94693, 1005.12000,   0.00000, 0.00000, 0.00000);
	CreateObject(1825, 541.96198, -148.30252, 1001.02600,   0.00000, 0.00000, 0.00000);
	CreateObject(2965, 543.75769, -158.15076, 1001.92615,   0.00000, 0.00000, 0.00000);
	CreateObject(3122, 544.93781, -158.74359, 1001.95819,   -98.27999, 9.66000, 282.96216);
	CreateObject(2799, 538.62195, -148.06909, 1001.52789,   0.00000, 0.00000, 0.00000);
	CreateObject(3034, 545.02496, -161.45229, 1003.44000,   0.01000, 0.00000, 179.91670);
	CreateObject(3034, 548.72986, -158.30330, 1003.44000,   0.01000, 0.00000, 270.06741);
	CreateObject(1825, 535.32568, -148.31828, 1001.02600,   0.00000, 0.00000, 0.00000);
	CreateObject(2800, 535.16284, -148.37068, 1001.70551,   0.00000, 0.00000, 0.00000);
	CreateObject(1670, 538.60150, -148.04800, 1001.70007,   0.00000, 0.00000, 0.00000);
	CreateObject(1670, 534.76129, -142.84683, 1001.95630,   0.00000, 0.00000, 0.00000);
	CreateObject(1667, 536.38995, -144.27190, 1002.05634,   0.00000, 0.00000, 0.00000);
	CreateObject(1485, 536.29053, -144.25259, 1001.95636,   0.00000, 0.00000, 0.00000);
	CreateObject(16152, 547.81213, -145.85387, 1001.02277,   0.00000, 0.00000, 180.10872);
	CreateObject(2640, 533.68304, -160.99242, 1001.83069,   0.00000, 0.00000, 179.52435);
	CreateObject(1216, 528.12122, -153.17690, 1001.65503,   0.00000, 0.00000, 89.36709);
	CreateObject(1235, 528.08582, -153.81528, 1001.52924,   0.00000, 0.00000, 342.12177);
	CreateObject(2048, 527.83270, -153.20656, 1003.97052,   0.00000, 0.00000, 90.02294);
	CreateObject(1736, 528.01764, -157.21617, 1004.36407,   0.00000, 0.00000, 90.79902);
	CreateObject(2232, 548.22522, -160.95624, 1001.62000,   0.00000, 0.00000, 225.86751);
	CreateObject(1738, 548.56995, -155.22720, 1001.49310,   0.00000, 0.00000, 90.35297);
	CreateObject(2226, 548.16022, -160.89110, 1002.21881,   0.00000, 0.00000, 222.50143);
	CreateObject(1778, 539.38422, -142.38142, 1001.02594,   0.00000, 0.00000, 0.00000);
	CreateObject(2112, 535.76080, -152.93524, 1001.43158,   0.00000, 0.00000, 26.82137);
	CreateObject(1805, 534.97833, -152.57329, 1001.22589,   0.00000, 0.00000, 0.00000);
	CreateObject(1805, 536.60284, -152.63696, 1001.22589,   0.00000, 0.00000, 0.00000);
	CreateObject(1805, 538.50519, -153.95923, 1001.22589,   0.00000, 0.00000, 0.00000);
	CreateObject(1805, 535.58307, -153.71326, 1001.22589,   0.00000, 0.00000, 0.00000);
	CreateObject(2112, 538.70905, -154.67618, 1001.43158,   0.00000, 0.00000, 26.82137);
	CreateObject(2112, 541.58893, -151.84476, 1001.43158,   0.00000, 0.00000, 26.82137);
	CreateObject(1805, 538.04388, -154.91884, 1001.22589,   0.00000, 0.00000, 0.00000);
	CreateObject(1805, 541.63971, -152.53860, 1001.22589,   0.00000, 0.00000, 0.00000);
	CreateObject(1805, 540.92615, -151.56662, 1001.22589,   0.00000, 0.00000, 0.00000);
	CreateObject(1743, 547.31854, -153.18671, 1001.02679,   0.00000, 0.00000, 359.68579);
	CreateObject(1520, 547.07001, -152.25537, 1002.28595,   0.00000, 0.00000, 0.00000);
	CreateObject(1520, 548.49506, -151.99135, 1002.28595,   0.00000, 0.00000, 0.00000);
	CreateObject(1669, 548.21533, -152.25725, 1002.13312,   0.00000, 0.00000, 0.00000);
	CreateObject(1667, 547.41046, -152.37971, 1002.11554,   0.00000, 0.00000, 0.00000);
	CreateObject(1670, 547.83508, -152.29413, 1002.01660,   0.00000, 0.00000, 0.00000);
	CreateObject(1543, 547.25806, -152.01530, 1002.28485,   0.00000, 0.00000, 0.00000);
	CreateObject(1951, 548.47876, -152.31483, 1002.48468,   0.00000, 0.00000, 215.66547);
	CreateObject(1544, 538.65448, -155.16718, 1001.83453,   0.00000, 0.00000, 0.00000);
	CreateObject(1543, 538.74402, -154.31432, 1001.83417,   0.00000, 0.00000, 0.00000);
	CreateObject(1544, 535.82458, -152.95052, 1001.83453,   0.00000, 0.00000, 0.00000);
	CreateObject(1543, 535.28802, -153.31702, 1001.83417,   0.00000, 0.00000, 0.00000);
	CreateObject(1543, 536.20978, -153.17798, 1001.83417,   0.00000, 0.00000, 0.00000);
	CreateObject(1543, 535.91821, -152.40906, 1001.83417,   0.00000, 0.00000, 0.00000);
	CreateObject(1543, 535.31158, -152.78287, 1001.83417,   0.00000, 0.00000, 0.00000);
	CreateObject(1494, 536.47900, -161.45049, 1000.95819,   0.00000, 0.00000, 0.00000);
	CreateObject(1713, 540.54779, -160.97849, 1001.02612,   0.00000, 0.00000, 179.89540);
	CreateObject(1756, 548.03680, -157.38309, 1001.02832,   0.00000, 0.00000, 269.32446);
	CreateObject(2942, 528.11469, -159.56485, 1001.62878,   0.00000, 0.00000, 90.46084);
	CreateObject(1886, 548.11414, -142.93372, 1005.52484,   0.00000, 0.00000, 312.94199);
	CreateObject(19174, 544.22815, -142.39922, 1003.45044,   0.00000, 0.00000, 0.00000);
	CreateObject(19173, 533.02533, -161.47714, 1004.25665,   0.00000, 0.00000, 0.00000);
}