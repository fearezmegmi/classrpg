#if defined __game_core_enum
	#endinput
#endif
#define __game_core_enum

enum
{
	NPC_TIPUS_HELYI,
	NPC_TIPUS_TAVOLI,
	NPC_DATA_NEV,
	NPC_DATA_FELVETEL,
	NPC_MEGALLO_ELOZO,
	NPC_MEGALLO_JELENLEGI,
	NPC_MEGALLO_KOVETKEZO,
	ELLENORZES_HIRDETES,
	ELLENORZES_SZIDAS,
	ELLENORZES_MINDKETTO,
	ARVERES_TIPUS_HAZ,
	ARVERES_TIPUS_KOCSI,
	INAKTIV_HAZ,
	INAKTIV_KOCSI,
	INAKTIV_GARAZS,
	JELZES_SARGA,
	JELZES_NARANCS,
	JELZES_PIROS,
	KOCSI_MOTOR,
	KOCSI_LAMPA,
	KOCSI_RIASZTO,
	KOCSI_AJTO,
	KOCSI_MOTORHAZTETO,
	KOCSI_CSOMAGTARTO,
	HP_SET,
	HP_GIVE,
	HP_GET,
	VERSENY_BEERT,
	VERSENY_SHOCK,
	VERSENY_KILEPES,
	UTZAR_KICSI,
	UTZAR_NAGY,
	UTZAR_TOROL,
	UTZAR_TOROL_MOST,
	KAPU_BETOLT,
	KAPU_BETOLT_SOR,
	KAPU_BETOLT_EX,
	KAPU_TOROL,
	KAPU_RELOAD,
	KINCS_BETOLT,
	KINCS_MENT,
	KINCS_INDIT,
	GYEMANT_BETOLT,
	GYEMANT_MENT,
	GYEMANT_FELVESZ,
	GYEMANT_LERAK,
	TUZ_BETOLT,
	TUZ_MENT,
	RADAR_E_LOVES,
	RADAR_E_ANIM,
	RADAR_E_OLES,
	FRAKCIO_LOAD,
	FRAKCIO_SAVE,
	ELLENORZES_SZEMELY
};

enum IPConnectsEnum
{
	iCim[ IP_ADDRESS_LENGTH ],
	iTime,
	iDB
};
new IPConnects[ MAX_IP_STORE ][ IPConnectsEnum ];

enum CAR_MentoInfo
{
	mCarNum[MAX_PLAYERS]
};
new CAR_Mento[69+MAX_VEHICLES][CAR_MentoInfo];

enum iInfo
{
	iAdmin[MAX_PLAYER_NAME],
	iAdminID,
	iMOTD[128],
	iPassword[128],
	iNeedPass,
	iLock,
	iPlayers,
	iIdo
};
new IRCInfo[MAXIRC][iInfo];

enum vCrime
{
	vVad[32],
	vJelento[32]
};
new VehicleCrime[MAX_VEHICLES][vCrime];

enum pCrime
{
	pVad[32],
	pJelento[32]
};
new PlayerCrime[MAX_PLAYERS][pCrime];

enum fAdatok
{
	fPenz,
	fMati,
	fKokain,
	fHeroin,
	fMinrang,
	fKaja,
	fMarihuana,
	Float:fPosX,
	Float:fPosY,
	Float:fPosZ,
	fObject,
	Float:fPosA,
	fVW,
	fObjectID,
	fDeagle[4],
	fSilenced[4],
	fMp5[4],
	fM4[4],
	fShotgun[4],
	fCombat[4],
	fSniper[4],
	fAk47[4],
	fRifle[4],
	fParachute,
	fJelszo[32],
	fFegyver[MAX_FEGYVERRAKTAR_SLOT],
	fLoszerTipus[MAX_FEGYVERRAKTAR_SLOT],
	fLoszerMennyiseg[MAX_FEGYVERRAKTAR_SLOT],
	fUtolsoTamadas,
	fTagokSzama,
	fUtolsoTagFelvetel,
	fFizetes[13],
	fMelleny[51],
	fLeaderekSzama,
	fIngyenTank,
	fTamadott,
	fRuha[50],
	fAlma,
	fRaktarRang,
	fC4,
	fHeti,
	fHavi,
	fOsszes,
	fAdo,
	fDij,
	fIngyenSzerel,
	Float:fDPosX,
	Float:fDPosY,
	Float:fDPosZ,
	Float:fDPosR,
	fDVW,
	fDINT,
	Float:fFPosX,
	Float:fFPosY,
	Float:fFPosZ,
	Float:fFPosR,
	fFVW,
	fFINT,
	fMotd[128],
};

new FrakcioInfo[MAX_FRAKCIO][fAdatok];

enum RAdatok
{
	bool:rFutam,
	bool:rInditva,
	bool:rIndit,
	rIdo,
	rNyeremenyOssz,
	rNyeremeny3,
	rNyeremeny2,
	rNyeremeny1,
	rModel,
	rJatekos,

}
new RoncsDerbi[RAdatok];
enum RDAdatok
{
	bool:rdVersenyez,
	rdModel,
	rdSlot,
	rKiesett,
	
}
new RoncsDerby[MAX_PLAYERS][RDAdatok];

enum faAdatok
{
	fRadar
};
new FrakcioAdat[MAX_FRAKCIO][faAdatok];

enum interiorsInfo
{
	iType[32],
	iNumber,
	Float:iExitX,
	Float:iExitY,
	Float:iExitZ,
	Float:iBedX,
	Float:iBedY,
	Float:iBedZ,
	Float:iBedAngle,
	Float:iCamStartPos[3],
	Float:iCamStartLookAt[3],
	Float:iCamEndPos[3],
	Float:iCamEndLookAt[3]
};
new IntInfo[MAXINT][interiorsInfo];

enum pHaul
{
	pLoad,
};

new PlayerHaul[MAX_VEHICLES][pHaul];

enum statEnum
{
	pID,
	pDatum[12],
	pRIdo,
	pIdo,
	pIdoOsszes,
	pOnduty,
	pOndutyOsszes,
	pVA,
	pPM
};
new StatInfo[MAX_PLAYERS][statEnum];


enum OEnum
{
	Float:OPosX,
	Float:OPosY,
	Float:OPosZ,
	Float:OPosRX,
	Float:OPosRY,
	Float:OPosRZ,
	bool:OSzerkeszt

};
new ObjectSzemuveg[MAX_PLAYERS][OEnum];
enum sAdatok
{
	sTipus,
	Float:sPosX,
	Float:sPosY,
	Float:sPosZ,
	Float:sPosZX,
	Float:sPosZY,
	Float:sPosA,
	sObjectID,
	sVw,
	sInt,
	Text3D:sFelirat,
};
new OBJECT[MAX_OBJECTSZ][sAdatok];
enum sTAdatok
{
	sTipus,
	Float:sPosX,
	Float:sPosY,
	Float:sPosZ,
	Float:sTav,

};
new OBJECT_TOROL[MAX_OBJECTSZ][sTAdatok];
enum pAdatok
{
	pTipus,
	Float:pPosX,
	Float:pPosY,
	Float:pPosZ,
	Float:pPosA,
	pObjectID,
};
new PICKUP[MAX_PICKUP][pAdatok];

enum parkAdatok
{
	Float:parkPosX,
	Float:parkPosY,
	Float:parkPosZ,
	parkTAV,

};
new PARKOLO[MAX_PARKOLO][parkAdatok];

enum mKocsik
{
	bool:kVan,
	kID,
	kModel,
	Float:kPos[4],
	kInt,
	kVW,
	kSzin[2],
	kMunka,
	kBerel,
	kBerelido,
};
new MunkaKocsi[MAX_MUNKA][MAX_MUNKAKOCSI][mKocsik];

enum jarmuArlista
{
	bool:jVeheto,
	jAra,
	jFrakciok[MAX_FRAKCIO]
};
new JarmuAra[MAX_JARMUARA][jarmuArlista];

enum aAdatok
{
	Float:aPosX,
	Float:aPosY,
	Float:aPosZ,
	Float:aPosA,
	aVw,
	aInt,
	aObjectID,
	aPenz
};
new ATM[MAX_ATM][aAdatok];

enum fkocsik
{
	bool:fVan,
	fID,
	fModel,
	Float:fPos[4],
	fInt,
	fVW,
	fSzin[2],
	fRang,
	fMatrica,
	fKerek,
	fKasztni,
	fHidraulika,
	Float:fKm,
	Float:fOlaj,
	Float:fGumi

};
new FrakcioKocsi[MAX_FRAKCIO+1][MAX_FRAKCIOKOCSI][fkocsik];

enum PbI
{
	pbNevezesek,
	pbNevezesTimer,
	pbNevezesIdo,
	pbMerkozesIdo[2],
	bool:pbHasznalva,
	pbNyertesOles,
	pbNyertes,
	pbSzamlalo,
	pbNyertesFegyver
};
new PaintballInfo[MAX_PBTEREM][PbI];

enum LoterI
{
	Float:lPos[2],
	Float:lTelePos[2],
	bool:lHasznalva,
	lIdo,
	lHasznalo,
	lTalalat,
	bool:lTalalt,
	lObject,
	lFegyver,
	lTimer,
	ltorolheto,
	lObjectTimer,
	bool:lLoheto,
	lLoterObjectek[2]
};
new LoterInfo[MAX_LOTER][LoterI];

enum bInfo
{
	bBNev[128],
    bOwned,
	bTulaj,
	bOwner[32],
	bMessage[128],
	bExtortion[MAX_PLAYER_NAME],
	Float:bEntranceX,
	Float:bEntranceY,
	Float:bEntranceZ,
	Float:bExitX,
	Float:bExitY,
	Float:bExitZ,
	bLevelNeeded,
	bBuyPrice,
	bEntranceCost,
	bTill,
	bLocked,
	bInterior,
	bProducts,
	bMaxProducts,
	bPriceProd,
	bVanBelso,
	bNeedUpdate,
	bAdomany,
	bBevetel,
	bVan,
	bTill2,
	bSzazalek,
	bMTulajID,
	bHeti1,
	bHavi1,
	bHeti2,
	bHavi2,
	bIdo1,
	bIdo2
};

enum bUpdateInfo
{
	bool:bBNev,
    bool:bOwned,
	bool:bTulaj,
	bool:bOwner,
	bool:bMessage,
	bool:bExtortion,
	bool:bEntranceX,
	bool:bEntranceY,
	bool:bEntranceZ,
	bool:bExitX,
	bool:bExitY,
	bool:bExitZ,
	bool:bLevelNeeded,
	bool:bBuyPrice,
	bool:bEntranceCost,
	bool:bTill,
	bool:bLocked,
	bool:bInterior,
	bool:bProducts,
	bool:bMaxProducts,
	bool:bPriceProd,
	bool:bVanBelso,
	bool:bTill2,
	bool:bSzazalek,
	bool:bMTulajID,
	bool:bAktiv,

};
new BizzInfo[MAXBIZ][bInfo], BizzUpdates[MAXBIZ][bUpdateInfo];

enum repInfo
{
	rAdmins,
	rAdminHelpers,
	rPlayers,
	rTitle[40],
	rClosed,
	rTimeOut,
	rMaxPlayers,
	rSeeing
};
new ReportChannel[MAX_CHANNEL][repInfo];

enum BenzinKutInfo
{
	Float:bPosX,
	Float:bPosY,
	Float:bPosZ,
	bTulajID,
	bBenzin,
	Float:bTav,
	bTulaj[MAX_PLAYER_NAME],
	bBenzinAra,
	bSzef,
	bNev[25],
	bKerozinAra,
	bDieselAra,
	bDiesel,
	bKerozin,
	bMelyikvan,
	bBerelheto,
	bAlapAra,
	bBerlesIdo
};
new BenzinKutak[MAX_BENZINKUT][BenzinKutInfo];

enum jatekosTankolas
{
	pTipusa[8],
	pLiter,
	pUzAr
};
new pTankolas[MAX_PLAYERS][jatekosTankolas];

enum TelefonInfo
{
	bool:tEladva,
	tTorlesIdo,
	tTulaj[MAX_PLAYER_NAME],
	tTulajID,
	tSzam,
	tSms[MAX_TAROLT_SMS],
	tEgyenleg
};
new Telefonok[MAX_TELEFON][TelefonInfo];

enum gyInfo
{
	gOID,
	gPlayer,
	gFrakcio,
	Float:gPos[3],
	gInt,
	gVW,
	gIdo
};
new Gyemant[MAX_GYEMANT][gyInfo], GyemantNala[MAX_PLAYERS];

enum igenyInfo
{
	Van,
	Nev[MAX_PLAYER_NAME],
	Belso,
	Float:iX,
	Float:iY,
	Float:iZ,
};
new HazIgenylesek[MAXIGENYLES][igenyInfo];

enum rendelinfo
{
	Van,
	Neve[MAX_PLAYER_NAME],
	Belso,
	Cim,
	Float:iX,
	Float:iY,
	Float:iZ,
	Float:iAngle,
	Mit[32],
	Indok[128],
};
new Rendeles[MAXRENDELES][rendelinfo];

enum ajtoInfo
{
	Van,
	Nev[64],
	Float:BeX,
	Float:BeY,
	Float:BeZ,
	BeInt,
	BeVW,
	Float:KiX,
	Float:KiY,
	Float:KiZ,
	Float:BeAngle,
	Float:KiAngle,
	KiInt,
	KiVW,
	Zarva,
	Freezel,
	Kocsi,
	PickupBe,
	PickupKi,
	PickupKocsiBe,
	PickupKocsiKi,
	bool:PickupKocsiBeRe,
	bool:PickupKocsiKiRe,
	Text3D:TextBe,
	Text3D:TextKi
};
new Ajtok[MAXAJTO][ajtoInfo];

enum terInfo
{
	Van,
	tZone,
	tArea,
	tNev[40],
	Float:tMinX,
	Float:tMaxX,
	Float:tMinY,
	Float:tMaxY,
	tTulaj,
	tHaszon[5],
	tHaszonMennyi[5],
	tHaszonIdo,
	
	bool:tHarc,
	tLofegyver,
	tHarcolok[2],
	tVarakozasIdo,
	
	tFoglalva,
	bool:tNeedUpdate
};

enum tUpdateInfo
{
	bool:tNev,
	bool:tMinX,
	bool:tMaxX,
	bool:tMinY,
	bool:tMaxY,
	bool:tTulaj,
	bool:tHaszon,
	bool:tHaszonMennyi,
	bool:tHaszonIdo,
	bool:tFoglalva
};
new TeruletInfo[MAXTERULET][terInfo], TeruletUpdates[MAXTERULET][tUpdateInfo];

enum kincsInfo
{
	Float:kPos[3],
	Float:kAngle,
	kMapID,
	kVaros,
	kEsely
};
new Kincs[MAX_KINCS][kincsInfo];

enum szemetinfo
{
	gId,
	bool:tHazSzemet,
	bool:tSzemet,
	Float:tSzemetPos[3],
	tSzemetObject,
	Text3D:tSzemetLabel,
};
new TrashInfo[MAXSZEMET][szemetinfo];

enum fortCellaInfo
{
	cId,
	bool:cVan,
};
new CellaInfo[MAXCELLA][fortCellaInfo];

enum GraffitiInfo
{
	gId,
	gVId,
	gNev[128],
	gSzoveg[128],
	gColor[24],
	gFont[16],
	gSize,
	gObject,
	gIdo,
	bool:gVan,
	Float:gPosX,
	Float:gPosY,
	Float:gPosZ,
	Float:gPosRX,
	Float:gPosRY,
	Float:gPosRZ,
};
new Graffiti[MAXGRAFFITI][GraffitiInfo];

enum GPSLista
{
	gNev[128],
	bool:gVan,
	Float:gPosX,
	Float:gPosY,
	Float:gPosZ,
	gKategoria,
};
new GPS[MAXGPS][GPSLista];

enum cInfo
{
	Van,
	cId,
	cModel,
	Float:cLocationx,
	Float:cLocationy,
	Float:cLocationz,
	Float:cAngle,
	cInt,
	cVW,
	cColorOne,
	cColorTwo,
	cOwned,
	cOwner[MAX_PLAYER_NAME],
	cTulaj,
	cValue,
	cLock,
	cDate,
	cPainted,
	cTuning,
	cKerek,
	cNeedUpdate,
	cMatrica,
	cKm,
	cNeon,
	cHidraulika,
	cRiaszto,
	cOnline,
	Text3D:cFelirat,
	//cOlajcsere,
	cKulcsok[2],
	cKereskedo,
	cDetektor,
	cCodeRiaszto[6],
	cTuningok[15]
};

enum cUpdateInfo
{
	bool:cOwned,
	bool:cOwner,
	bool:cTulaj,
	bool:cId,
	bool:cModel,
	bool:cLocationx,
	bool:cLocationy,
	bool:cLocationz,
	bool:cInt,
	bool:cVW,
	bool:cAngle,
	bool:cColorOne,
	bool:cColorTwo,
	bool:cValue,
	bool:cLock,
	bool:cDate,
	bool:cPainted,
	bool:cTuning,
	bool:cKerek,
	bool:cMatrica,
	bool:cKm,
	bool:cNeon,
	bool:cHidraulika,
	bool:cRiaszto,
	//bool:cOlajcsere,
	bool:cKulcsok[2],
	bool:cKereskedo,
	bool:cDetektor,
	bool:cTuningok
};
new CarInfo[MAXVSKOCSI][cInfo], CarUpdates[MAXVSKOCSI][cUpdateInfo];

enum wifidetails
{
	wID,
    Float:wPos[3],
	wVw,
	wInt,
    wNev[128]
};
new WifiPont[MAXWIFI][wifidetails];

enum targyInfo
{
	tType,
	tDB,
	tE1,
	tE2,
	tE3
};
new Items[MAX_PLAYERS][MAX_TARGY][targyInfo];

enum pInfo
{
	pID,
	pAspirin,
	pVeletlen,
	pCataflan,
	pBID,
	pForgalomTime,
	pMaszk,
	pMunkaBenzin,
	pElajult,
	pMunkaAra,
	pMunkaRendszam,
	pChatNev[MAX_PLAYER_NAME],
	pLaptopChat,
	pSwatKituntetes,
	pRegistered,
	bool:pVizsgal,
	pNev[MAX_PLAYER_NAME],
	pIP[32],
	pKey[40],
	pLevel,
	pNyelv[MAX_NYELV+1],
	pANyelv,
	pAdmin,
	pBankkartya,
	pSzerszamoslada,
	pConnectTime,
	pSex,
	pAge,
	pAkkuTolto,
	pOrigin,
	pMuted,
	pExp,
	pCash,
	pAccount,
	pCrimes,
	pArrested,
	pPhoneBook,
	pLottoNr,
	pFishes,
	pBiggestFish,
	pJob1,
	pJob2,
	pPayCheck,
	pTojas,
	pHeadValue,
	pJailed,
	pJailTime,
	pMats,
	pKokain,
	pHeroin,
	pMarihuana,
	pLeader,
	pMember,
	pRank,
	pChar,
	pCrossido,
	pBicikli,
	pDetSkill,
	pSexSkill,
	pBetoroSkill,
	pLawSkill,
	pMechSkill,
	pJackSkill,
	pCarSkill,
	pAlakitIdo,
	pNewsSkill,
	pDrugsSkill,
	pCookSkill,
	pFishSkill,
	pHackingSkill,
	pRiasztoSkill,
	//Float:pHealth,
	pInt,
	pLocal,
	pModel,
	pPnumber,
	pPhousekey,
	pGarazs,
	pPhousekey2,
	pPhousekey3,
	pBerlo,
	pPbiskey,
	Float:pPos_x,
	Float:pPos_y,
	Float:pPos_z,
	pCarLic,
	pFlyLic,
	pHeliLic,
	pJogsiTiltOk[128],
	pJogsiTiltIdo,
	pFrakcioTiltOk[128],
	pAsTilt,
	pAsTiltOk[128],
	pFrakcioTiltIdo,
	pLeaderTilt,
	pLeaderoka[128],
	pFegyverTiltOk[128],
	pFegyverTiltIdo,
	pReportTilt,
	pReportTiltOk[100],
	pBoatLic,
	pFishLic,
	pGunLic,
	pMotorJogsi,
	pKamionJogsi,
	pKreszJogsi,
	pAdrJogsi,
	pCarTime,
	pPayDay,
	pRepSkill,
	pKamiSkill,
	pAutmotSkill,
	pHajoSkill,
	pFegySkill,
	pAdrSkill,
	pPayDayHad,
	pCDPlayer,
	pWins,
	pLoses,
	pAlcoholPerk,
	pDrugPerk,
	pMiserPerk,
	pPainPerk,
	pTraderPerk,
	pTut,
	pMegbizas,
	pWarns,
	pKWarns,
	pFuel,
	pKredit,
	pMarried,
	pMarriedTo[MAX_PLAYER_NAME],
	pLokator,
	pHamisNev[MAX_PLAYER_NAME],
	//pNyomkovetes,
	//pNyomkoveto,
	pSpawned,
	bool:pGPS,
	pMuanyag,
	pCserje,
	pMak,
	pCannabis,
	pKaja,
	pDrogido,
	pAS,
	Float:pCPosX,
	Float:pCPosY,
	Float:pCPosZ,
	pCVW,
	pCInt,
	pCrash,
	pFegyver[12],
	pLoszer[12],
	Float:pCelet,
	Float:pCpajzs,
	pPcarkey,
	pPcarkey2,
	pPcarkey3,
	pCigiUsed,
	pCigiFuggoseg,
	pCigi,
	pNikotin,
	pGyujto,
	pPia,
	pSwattag,
	pSwatRang,
	pKituntetes,
	pSzallitott,
	pSpawnchange,
	pTeloEgyenleg,
	pAdminAlnev[MAX_PLAYER_NAME],
	pAdminAlnevBe,
	pClint,
	pKotszer,
	pUtlevel,
	pStilus,
	pBankSzamla,
	pBankSzamlaSzam,
	pBankSzamlaJelszo,
	pC4,
	pHitman,
	pHitmanIdo,
	pHitmanNev[MAX_PLAYER_NAME],
	pPremiumCsomag,
	pPremiumIdo,
	pPremiumPont,
	pPower,
	pReportChannel,
	pViewReportChannel,
	pReportTiltva,
	pAdoHaz,
	pAdoHazHol,
	pAdoSzint,
	pAdoJarmu,
	pAdoKitoltve,
	pAdoFizetve,
	pAdo,
	pAdoEllenorizve,
	pElozoParancs,
	pFlood,
	pHitel,
	pFelvettHitel,
	pHitelOra,
	pHitelElteltOra,
	pZarolva,
	pJegy,
	pSSS,
	pKiesetKocsi,
	pJailOK[128],
	pAdovan[5],
	pJelzes,
	pJelzesTerkep,
	pVirgacs,
	pLkocsi,
	pLkocsiar,
	pFem,
	pSzemelyi,
	pLakcimkartya,
	pOvadek,
	pHack,
	pLaptop,
	pSzokesJelzes,
	pHackProba,
	pValaszok,
	pSzajkendo,
	pKatonaRang,
	pSzemuveg,
	bool:pRadioHallgat,
	pRadioID,
	pRadioHID,
	pRadioHangero,
	pCsali,
	pHorgaszBot,
	pRadio,
	pCsipogo,
	pGarazskey,
	pFekvoflood,
	pAutoker,
	pAlma,
	pSzerelo,
	pTaxiEngedely,
	bool:pTaxiDuty,
	pSzerelt,
	bool:pMegbotlott,
	bool:pFavagozik,
	pFavagoMunkaCP,
	bool:pFavagoMunkazik,
	pFavagoMunkaTimer,
	pFureszelt,
	pVontatokotel,
 	pVK,
 	pJarmubenUlt,
 	bool:pHullaMutat,
 	pHullaIcon[MAX_HULLA],
	/*pMikulasSapka,
	pMikulasCsomag,*/
	pLoves,
	pEllatva,
	pBSA,
	pVeszHivo,
	bool:pBSADuty,
	pBikazoKabel,
	pKormanyKituntetes,
	pBizniszKulcs,
	bool:pIndexQE,
	bool:pIndexSzam,
	pUtolsoBelepes,
	pFuelTipus,
	pElhasznaltUzemanyag[3],
	pFegyverSkillek[11],
	pHetiAktivitas,
	pHaviAktivitas,
	pBenzinkut,
	pTelefon,
	pHackIdo,
	pSSSValaszok,
	pFelvetel,
	pAdminUzenet,
	pAdminUzenetOk[300],
	pOlesIdo,
	pKliensAktiv,
	pKliensIdo,
	pKliensLastStatus,
	pKliensLastStatusRequest,
	pKliensDisconnectTime,
	pKliensDisconnectWarn,
	pKliensLastWarn,
	pLoginTryNext,
	pLoginTries,
	pCode[40],
	pCodeBanned,
	pFPSlimiter,
	pFPSlimiterWarn,
	pTorleszto,
	pReszegKeselteto,
	pHitelHatralek,
	pMotorolaj,
	plecsukta,
	pMostlepetbeTime,
	pOnkentes,
	bool:pMegad,
	bool:pLaptopBe,
	pArany,
	pAranyBank,
	pTextdrawszin,
	pMobilnet,
	pKozmunka,
	pKozmunkaIdo,
	pAjandekUnixtime,
	pAjandek,
	pJelveny,
	bool:pSMS,
	pPaintballKitiltva,
	pVadaszEngedely,
	pKulcsok[3],
	Float:pSpecialJogsiKm,
	pSpecialJogsiNev[128],
	pTextDrawKeseltet,
	pPBFegyver[4],
	pPluszBer,
	pPluszBerMeddig[32],
	pMegfigyelve,
	pMegfigyelveOK[128],
	pBuntetopont,
	pTrafik,
	pTrafiOsszeg,
	pHazKulcsok[3],
	pAdokIdo,
	pAdokOsszeg,
	pMentobenvan,
	//pTeleportAlatt,
	//Float:pCPos_x,
	//Float:pCPos_y,
	//Float:pCPos_z,
	//Float:pCTav[MAX_PLAYERS],
	//pCFigyelm,
	//pCFalsePositive,
	pFrissitesUzenetVan,
	pFrissitesUzenet[500],
	pRKA,
	pRKARang,
	pPoliceAlosztaly[3],
	pPoliceAlosztalyFo,
	pPoliceRuha[3],
	pCsaladTagja,
	pCsaladLeader,
	pCsaladRang,
	pMoriartySzalag,
	pMoriartySzalagIdo,
	pLadaKulcs,
	pKliens,
	phTojas,
	pMarkLevel,
	pMarkTriggerTime,
	pMarkMinPlayers,
	pMarkMinMarkedPlayers,
	pMarkReason[128],
	pReportCooldown,
	pReportPlayer,
	pReportReason[128],
	pSzen, // bányász
	pVas,
	pAranym,
	pGyemant,
	pSzenP,
	pVasP,
	pAranymP,
	pGyemantP,
	pDrogozott,
	pBmunka,
	pCustomHudWeapon,
	bool:pAdoAuto,
	pSpawnType,
	pSpawnId
};
new PlayerInfo[MAX_PLAYERS][pInfo];

enum hInfo
{
	Van,
	Uj,
	Float:hEntrancex,
	Float:hEntrancey,
	Float:hEntrancez,
	hBelso,
	hHealth,
	hArmour,
	hOwner[MAX_PLAYER_NAME],
	hTulaj,
	hValue,
	hHel,
	hArm,
	hLock,
	hOwned,
	hRooms,
	hRent,
	hRentabil,
	hTakings,
	hDate,
	hCsak,
	hCsakneki[MAX_PLAYER_NAME],
	hKaja,
	hAlma,
	hCigi,
	hKokain,
	hHeroin,
	hMarihuana,
	hMati,
	hTipus,
	hFegyver[10],
	hLoszerTipus[10],
	hLoszerMennyiseg[10],
	hMellenyek[10],
	hRuhak[10],
	Butorok,
	hArany,
	bool:hNeedUpdate,
	hKulcsVan[2]
};

enum hUpdateInfo
{
	bool:hEntrancex,
	bool:hEntrancey,
	bool:hEntrancez,
	bool:hBelso,
	bool:hHealth,
	bool:hArmour,
	bool:hOwner,
	bool:hTulaj,
	bool:hValue,
	bool:hHel,
	bool:hArm,
	bool:hLock,
	bool:hOwned,
	bool:hRooms,
	bool:hRent,
	bool:hRentabil,
	bool:hTakings,
	bool:hDate,
	bool:hCsak,
	bool:hCsakneki,
	bool:hKaja,
	bool:hAlma,
	bool:hCigi,
	bool:hKokain,
	bool:hHeroin,
	bool:hMarihuana,
	bool:hMati,
	bool:hTipus,
	bool:hFegyver,
	bool:hLoszer,
	bool:hMellenyek,
	bool:hRuhak,
	bool:Butorok,
	bool:hArany,
	bool:hKulcsVan[2]
};
new HouseInfo[MAXHAZ][hInfo], HouseUpdates[MAXHAZ][hUpdateInfo], HazakSzamaOsszesen;

enum garInfo
{
	Van,
	Uj,
	Float:hEntrancex,
	Float:hEntrancey,
	Float:hEntrancez,
	Float:hAngle,
	hBelso,
	hOwner[MAX_PLAYER_NAME],
	hTulajid,
	hRentabil,
	hLock,
	hRooms,
	hRent,
	hDate,
	hCsak,
	hCsakneki[MAX_PLAYER_NAME],
	hEladva,
	hAra,
	hHaz,
	bool:hNeedUpdate
};

enum gUpdateInfo
{
	bool:Van,
	bool:Uj,
	bool:hEntrancex,
	bool:hEntrancey,
	bool:hEntrancez,
	bool:hBelso,
	bool:hOwner,
	bool:hTulajid,
	bool:hRentabil,
	bool:hLock,
	bool:hRooms,
	bool:hRent,
	bool:hDate,
	bool:hCsak,
	bool:hCsakneki,
	bool:hEladva,
	bool:hAra,
	bool:hNeedUpdate,
	bool:hAngle,
	bool:hHaz
};
new GarazsInfo[MAXGARAZS][garInfo], GarazsUpdates[MAXGARAZS][gUpdateInfo];

enum tInfo
{
	bool:tAktiv,
	tSebesseg,
	tBuntetes,
	tBuntetheto,
	Float:tPosX,
	Float:tPosY,
	Float:tPosZ
	//Text3D:t3D
}
new TrafiPax[MAX_PLAYERS][tInfo];

enum radioInfo
{
	bool:rVan,
	rNev[32],
	rURL[128]
}
new /*bool:RadioVan,*/ Radio[MAX_RADIO][radioInfo];
enum kLlista
{
	Kmodel,
	Kara

}
new KocsiLopasLista[15][9][kLlista];
enum taxiInfo
{
	bool:tDuty,
	Float:tKm,
	tUtas,
	bool:tHivas,
	tJarmu,
	tFizetes,
	tAra,
	tHivasokValt,
	Float:tOKmValt,
	tHivasok,
	Float:tOKm,
}
new Taxi[MAX_PLAYERS][taxiInfo];

enum kapuInfo
{
	kNev[32],
	bool:kVan,
	bool:kSzerkeszt,
	kUID,
	kModel,
	Float:kTav,
	Float:kSpeed,
	Float:kPos[3],
	Float:kNPos[3],
	Float:kNRPos[3],
	Float:kZPos[3],
	Float:kZRPos[3],
	bool:kBarki,
	kHasznalo[MAX_KAPU_HASZNALO],
	bool:kMozgo,
	nyit,
	Vw,
	kOID,
	kKod
}
new Kapu[MAX_KAPU][kapuInfo];

enum hNews
{
	hTaken1,
	hTaken2,
	hTaken3,
	hTaken4,
	hTaken5,
	hAdd1[128],
	hAdd2[128],
	hAdd3[128],
	hAdd4[128],
	hAdd5[128],
	hContact1[128],
	hContact2[128],
	hContact3[128],
	hContact4[128],
	hContact5[128],
};
new News[hNews];

/*enum eCars
{
	model_id,
	Float:pos_x,
	Float:pos_y,
	Float:pos_z,
	Float:z_angle,
};*/

enum pFishing
{
	pFish1[20],
	pFish2[20],
	pFish3[20],
	pFish4[20],
	pFish5[20],
	pWeight1,
	pWeight2,
	pWeight3,
	pWeight4,
	pWeight5,
	pFid1,
	pFid2,
	pFid3,
	pFid4,
	pFid5,
	pLastFish,
	pFishID,
	pLastWeight,
};
new Fishes[MAX_PLAYERS][pFishing];

enum pCooking
{
	pCook1[20],
	pCook2[20],
	pCook3[20],
	pCook4[20],
	pCook5[20],
	pCWeight1,
	pCWeight2,
	pCWeight3,
	pCWeight4,
	pCWeight5,
	pCookID1,
	pCookID2,
	pCookID3,
	pCookID4,
	pCookID5,
};
new Cooking[MAX_PLAYERS][pCooking];

enum pGroceries
{
	pChickens,
	pChicken,
	pHamburgers,
	pHamburger,
	pPizzas,
	pPizza,
};
new Groceries[MAX_PLAYERS][pGroceries];

enum pSpec
{
	Float:Coords[3],
	sVW,
	sINT
};
new Unspec[MAX_PLAYERS][pSpec];

/*enum zInfo
{
	zOwner[64],
	zColor[20],
    Float:zMinX,
    Float:zMinY,
    Float:zMaxX,
    Float:zMaxY,
};
new TurfInfo[6][zInfo];
new Turfs[6];*/

/*enum KocsiEnum
{
	kUttisztito,
	kSzerelo,
	kProd,
	kRepulo,
	kKamion,
	kFarmer,
	kFunyiro,
	kGokart,
	kKukas,
	kPostas,
	kPizza,
	kPilota,
	kSzabad,
	kTaxi,
	kFavago,
	kHulla
}
new Kocsik[KocsiEnum][2];*/

enum SavePlayerPosEnum
{
    Float:LastX,
    Float:LastY,
    Float:LastZ
}
new SavePlayerPos[MAX_PLAYERS][SavePlayerPosEnum];

enum markpos
{
	Float:Markx,
	Float:Marky,
	Float:Markz,
	MarkVW,
	MarkINT
}
new MarkPos[MAX_PLAYERS][MAXGOTOMARK][markpos];

enum PilotaInfo
{
	Float:PilotaX,
	Float:PilotaY,
	Float:PilotaZ,
	Float:PilotaHP,
	Float:PilotaTavolsag,
	Float:PilotaSzorzo,
	PilotaRepulo,
	PilotaFizetes,
	PilotaCel[200],
	PilotaKezd[200]
}
new PilotaMunkaPos[MAX_PLAYERS][PilotaInfo];

enum PilotaMunkaInfo
{
	munkaneve[128],
    Float:munkax,
    Float:munkay,
    Float:munkaz,
	Float:munkaertek
}

enum kikepzoinfo
{
	bool:kVan,
	kIdo,
	kVw,
	kBelso,
	kKod
}
new Kikepzo[MAX_KIKEPZO][kikepzoinfo];

enum KamionUtInto
{
	Float:KamX,
	Float:KamY,
	Float:KamZ,
	Float:KamElet,
	Float:KamTavolsag,
	Float:KamSzorzo,
	KamRendszam,
	KamPotRendszam,
	KamFizetes,
	KamCel[200],
	KamKezd[200]
}
new KamionStartPoz[MAX_PLAYERS][KamionUtInto];

enum Kamionmunkainfo
{
    MissionName[200],
    MissionPay,
    Float:loadx,
    Float:loady,
    Float:loadz,
	Float:Ertek,
}

enum rkAdat
{
	Float:RKx,
	Float:RKy,
	Float:RKz,
	RKido,
	Text3D:RKid,
	RKWeapon[32],
	RKnamekill[MAX_PLAYER_NAME],
}
new RKFigyelo[MAX_PLAYERS][rkAdat];

enum bolyaInfo
{
	Float:bPos[3],
	bObject
}
new Bolya[MAX_PLAYERS][MAX_BOLYA][bolyaInfo];

enum xinfo
{
	xVersenyen,
	xCP,
	xKoviCP,
	xIdo,
	xEpites,
	xEpitesLoad,
	xEpitesCP,
	xHelyezes,
	xKocsi
}
new PlayerRaceInfo[MAX_PLAYERS][xinfo];

enum xtinfo
{
	bool:tNitroVolt,
	bool:tHidrVolt,
	tNitro,
	tNitroIdo,
	tUjito,
	bool:tOrvos,
	tSegitIdo,
	tEMP
}
new PlayerRaceTuning[MAX_PLAYERS][xtinfo];

enum rinfo
{
	rStatusz,
	rEpitesAlatt,
	rCP,
	rInditotta,
	rIndul,
	rElindult,
	rNev[60],
	rSaveNev[32],
	rDij,
	Float:rSzorzo,
	rNyeremeny,
	rEngedelyezettKocsik[25],
	rBeert,
	rVersenyIdo,
	rVw,
	rHelyezes[6]
}
new RaceInfo[RACESLOTOK][rinfo];

enum btav
{
	Kozel,
	Normal,
	Tavol
}

enum szinfo
{
	szCombat[3],
	szM4[3],
	szSniper[3],
	szDeagle[3],
	szMP5[3],
	szColt[3],
	szShoutgun[3],
	szRifle[3],
	szAk47[3],
	szSilenced[3],
	szParachute,
}
new Szallito[MAX_VEHICLES][szinfo];

enum utzarInfo
{
	bool:uVan,
	uTipus,
	Float:uHely[4],
	uObject,
	uPickup[4],
	Text3D:uText
}
new Utzarak[MAX_PLAYERS][utzarInfo];

enum npcinfo
{
	bool:nConnected,
	nNeve[40],
	nID,
	nKocsi,
	nNev[80],
	Text3D:nLeirasID,
	nFelvetelNev[40],
	nHolTart,
	nMegallokSzama,
	bool:nMegallt,
	bool:nMegallitva,
	bool:nSzamolas,
	nSzamolasTimer,
	nSzamolasIdo,
	nMenetIdo,
	nIndit,
	nDuplaIndit
};
new NPC_Vezetok[MAX_NPC_SOFOR][npcinfo];

enum vVarosok
{
	vLS,
	vSF,
	vLV
}
new Varosok[vVarosok];

enum cityArea
{
	Float:cPosX[2],
	Float:cPosY[2]
}
new CityArea[vVarosok][cityArea];

enum aInfo
{
	bool:aElinditva,
	aVarakozas,
	aIdo,
	aTipus,
	aID,
	aLicitalok[3],
	aLicitek[3],
	aLicit,
	aLicitalo,
	aLicitaloVolt[MAX_PLAYER_NAME],
	aKezdoLicit,
	aKezdo
}
new Aukcio[aInfo];

enum avInfo
{
	bool:vVan,
	vTipus,
	vID,
	vKezdoLicit
}
new AukcioVarolista[MAXAUKCIO][avInfo];

enum idoInfo
{
	iVolt,
	iMost,
	iLesz,
	bool:iValtas
}
new IdoJaras[idoInfo];

enum piacInfo
{
	bool:pVan,
	pID,
	pFeladta,
	pNev[MAX_PLAYER_NAME],
	pAra,
	pEladva,
	pDB
}
new Piac[8][MAX_PIAC_CUCC][piacInfo];

enum uInfo
{
	uPlayer,
	uHaz,
	uKocsi,
	uBiz,
	uTerulet,
	uGarazs
};
new UpdatePerSec[uInfo], UpdateFolytatodik[uInfo];

enum tuzInfo
{
	bool:tuzAktiv,
	Float:tPoz[3],
	Text3D:tFelirat,
	tObject[ TUZ_OBJECT ],
	tMap,
	tMaxHP,
	tHP
}
new Tuz[TUZ_MAX][tuzInfo];

enum tuzInfo2
{
	Float:tPoz[3],
	tMapID
}
new TuzPoz[TUZ_MAX_POZ][tuzInfo2];

enum fszinf
{
    bool:fszVan,
	fszNev[MAX_PLAYER_NAME],
	fszCombat[3],
	fszM4[3],
	fszSniper[3],
	fszDeagle[3],
	fszMP5[3],
	fszColt[3],
	fszShoutgun[3],
	fszRifle[3],
	fszAk47[3],
	fszSilenced[3],
	fszParachute,
	fszFrakcio,
	fszTipus
};
new FszInfo[MAX_FSZ_RENDELES][fszinf];

/*enum index2
{
	obj1,
	obj2,
	obj3,
	elakad3,
	elakad4,
	elakad5,
	bool:elakadt,
	bool:indextrailer,
	bool:indexing
}*/

enum noclipenum
{
	cameramode,
	flyobject,
	mode,
	lrold,
	udold,
	lastmove,
	Float:accelmul
}
new noclipdata[MAX_PLAYERS][noclipenum];

enum flyadat
{
	Float:Fposx,
	Float:Fposy,
	Float:Fposz,
	Finti,
	Fvw
}
new FlyVege[MAX_PLAYERS][flyadat];

enum berszef
{
	bTulajid,
	bMati,
	bMarihuana,
	bHeroin,
	bKokain,
	bPenz,
	bIdo,
	bKaja,
	bCigi,
	bRuha,
	bArany,
	bool:bHasznalva
};
new BerSzef[MAX_BSZEF][berszef];

enum puzem
{
	ptanker,
	ptipus,
	pliter,
	
};
new Uzemanyag[MAX_PLAYERS][puzem];

enum Eldobas
{
	Tipus,
	Mennyiseg,
	eldobobject,
	Text3D:texteldob,
	Float:eldobposx,
	Float:eldobposy,
	Float:eldobposz,
	bool:eldobhasznalva,
	eInt,
	eVw,
	EVan,
	eIdo
};
new Eldob[MAX_ELDOBAS][Eldobas];

enum pdData
{
    PenzOsszeg,
    Float:PenzX,
    Float:PenzY,
    Float:PenzZ,
    PenzVW,
    PenzInt,
	PVan,
	PenzIdo
};
new PenzDropInfo[MAX_DROP_ITEMS][pdData];

enum aratasEnum
{
	aratasObject,
	aratasPickup,
	Text3D:aratasText
};
new AratasInfo[568][aratasEnum];

enum butorInfo
{
	Float:butorPosX,
	Float:butorPosY,
	Float:butorPosZ,
	Float:butorPosRX,
	Float:butorPosRY,
	Float:butorPosRZ,
	butorModel,
	butorVW,
	butorInterior,
	bool:butorHasznalva,
	bool:butorMegveve,
	butorObject,
	butorTipus,
	butorListitem
}
new ButorInfo[MAXHAZ * MAXBUTOR][butorInfo];

enum butorEnum {
    butorID,
    butorNEV[48],
    butorAR
}

enum markerHiddenArea
{
	bool:mExists,
	Float:mMinX,
	Float:mMinY,
	Float:mMaxX,
	Float:mMaxY
}
new MarkerHiddenArea[MAX_HIDDEN_AREA][markerHiddenArea];

enum playerPlace
{
	pCity,
	pHiding,
	pWarArea
}
new PlayerPlace[MAX_PLAYERS][playerPlace];

enum hullaInfo
{
	bool:Hvan,
	Hido,
	Float:Hpos[4],
	Hobject[5],
	Text3D:Htext3d,
	Hoka,
	Hkie[MAX_PLAYER_NAME],
	Hkieid,
	Hmegolte[MAX_PLAYER_NAME],
	Hmegolteid,
	Htimer,
	Hperc,
	Hallapot,
	Hvw,
	HHeroin,
	HKokain,
	HMati,
	HMariska,
	HPenz,
	Hactor
};
new HullaInfo[MAX_HULLA][hullaInfo];

enum vehicleIndexInfo
{
	JobbIndex1,
	JobbIndex2,
	JobbTrailer1,
	JobbTrailer2,
	BalIndex1,
	BalIndex2,
	BalTrailer1,
	BalTrailer2,
	BalIndex,
	JobbIndex,
	Kozos
};
new VehicleInfo[MAX_VEHICLES][vehicleIndexInfo];

enum Faadatok
{
	Float:faposx,
	Float:faposy,
	Float:faposz,
	faplayerid,
	Text3D:falabel,
	bool:fahasznalva
};
new FaAdatok[MAX_FA][Faadatok];

enum ObjectAdatok
{
	_OBJECT_TREE_1_,
	_OBJECT_TREE_2_,
	_OBJECT_TREE_3_,
	_OBJECT_TREE_4_,
	_OBJECT_TREE_5_,
	_OBJECT_TREE_6_,
	_TREE_NUM_,
	/**/
	_OBJECT_DEER_1_,
	_OBJECT_DEER_2_,
	_OBJECT_DEER_3_,
	_OBJECT_DEER_4_,
	_OBJECT_DEER_5_,
	_DEER_NUM_,
	_DEER_HEALTH_1_,
	_DEER_HEALTH_2_,
	_DEER_HEALTH_3_,
	_DEER_HEALTH_4_,
	_DEER_HEALTH_5_,
	_DEER_GUN_1_,
	_DEER_GUN_2_,
	_DEER_GUN_3_,
	_DEER_GUN_4_,
	_DEER_GUN_5_,
	Float:_DEER_DISTANCE_1_,
	Float:_DEER_DISTANCE_2_,
	Float:_DEER_DISTANCE_3_,
	Float:_DEER_DISTANCE_4_,
	Float:_DEER_DISTANCE_5_
};
new VehicleAdatok[MAX_VEHICLES][ObjectAdatok];

enum Fa
{
	Float:fax,
	Float:fay,
	Float:faz,
	faallapot
};

enum aarea
{
	AVan,
	Float:Aangle,
	Float:Ax,
	Float:Ay,
	Float:Az,
	Float:As,
	Aid,
}
new AreaForgalom[MAX_AREA_HELY][aarea];

enum carTrunk
{
	cMuanyag,
	cCserje,
	cMak,
	cCannabis,
	cFegyver[MAX_JARMU_WEAPON_SLOT],
	cLoszerTipus[MAX_JARMU_WEAPON_SLOT],
	cLoszerMennyiseg[MAX_JARMU_WEAPON_SLOT],
	cMaterial,
	cHeroin,
	cKokain,
	cMarihuana,
	//???
	Float:cMelleny[5],
	cFegyverCsomag,
	cAlma,
	cTolto,
	cKaja,
	cOlaj
}
new CarTrunk[MAX_VEHICLES][carTrunk];

enum kereskedovetel
{
	kUID,
	kKOCSI[120],
	kAra

}
new KeredkedoVetel[MAX_KERESKEDO][kereskedovetel];

enum playerMarker
{
	mType,
	mTime,
	mTargetTime,
	mLastShoot,
	mHidden,
	Float:mLastPos[3]
};
new PlayerMarker[MAX_PLAYERS][playerMarker];

enum radio
{
	rnev[128],
	rurl[128],
}
new SajatRadio[MAX_PLAYERS][radio];

enum youtubeinfok
{
	yNev[48],
	yLink[128],
	yLejatsszik,
	yHossz,
	yMeddig,
}
new MP4YT[MAX_PLAYERS][youtubeinfok];

enum aratasInfo
{
	aratasID,
	Float:aratasX,
	Float:aratasY,
	Float:aratasZ,
	Float:aratasRX,
	Float:aratasRY,
	Float:aratasRZ,
	bool:aratasLearatva
};

enum carparts
{
	Float:cKerekek,
	Float:cMotorolaj,
	Float:cAkkumulator,
	Float:cMotor,
	Float:cElektronika,
	Float:cFek,
	cKarosszeria,
	cSzervizdatum
}
new CarPart[MAX_VEHICLES][carparts];

enum deerdetails
{
	dObject,
	bool:dCreated,
	bool:dKilled,
	bool:dSupplied,
	Float:dPos[6],
	Float:dDistance,
	dWeaponType,
	dKiller[MAX_PLAYER_NAME],
	dHealth,
	Text3D:dLabel,
}
new DeerInfo[MAX_DEER][deerdetails];

enum hunting
{
	dAmount,
	dLastJoiner,
	dSpawnTime
}
new HuntInfo[hunting];

enum ctunklimit
{
	cCserje,
	cMak,
	cCannabis,
	cMuanyag,
	cMati,
	cKokain,
	cHeroin,
	cMarihuana,
	cFelszereles,
	cAlma,
	cTolto,
	cKaja,
	cOlaj
}

enum kordonInfo
{
    Float:korPos[3],
    korObject
}

new Kordon[MAX_PLAYERS][MAX_KORDON][kordonInfo];

enum eHitBox
{
	Float:ePos[3],
	eTalalat
}

new HitBoxData[312][MAX_HITBOX_DATA][eHitBox]; //MAX_SKIN

enum RobHelyAdat
{
	roLezarva,
	Float:roPosX,
	Float:roPosY,
	Float:roPosZ,
	Float:roPosZX,
	Float:roPosZY,
	Float:roPosA,
	roRobId,
	roVw,
	roInt,
	roLsVagySf,
	roSzefPenz,
	roTulaj[32],
	roJelszo[6],
	roBiztonsag
};
new ROBHELY[MAX_BANKROBHELY][RobHelyAdat];

enum TojasInfo
{
	tjID,
	bool:tjVan,
	bool:tjKiosztva,
	Float:tjPos[3],
	tjVW,
	tjInt
};
new Tojas[MAX_TOJAS][TojasInfo];

enum FixTrafiInfo
{
	fxID,
	fxLerakta[128],
	Float:fxPos[3],
	Float:fxAngle,
	fxInt,
	fxVW,
	fxErvenyes,
	fxSebesseg,
	Text3D:fxLabel
};
new FixTrafi[MAX_FIXTRAFI][FixTrafiInfo];

enum GumiLovedekInfo
{
	fxMP5,
	fxAK47,
	fxM4A1,
	fxShotgun,
	fxDeagle,
	fxSniper,
	fxCombat,
	fxColt45,
	fxSilencedColt45,
	fxRifle
};
new Gumilovedek[MAX_PLAYERS][GumiLovedekInfo];

enum ReportInfo
{
	rID,
	rNev[MAX_PLAYER_NAME],
	rSzoveg[128],
	rChannel,
	rSQLID
};
new Report[MAX_REPORTS][ReportInfo];

enum WeaponAdjustInfo {
	waNev[128],
	waBone,
	Float:waOffSetD[3],
    Float:waRotSetD[3],
	Float:waOffSetK[3],
	Float:waRotSetK[3],
	Float:waOffSetV[3],
	Float:waRotSetV[3],
	Float:waScaleSet[3]
};

#define MAX_WEAPONS_ADJUST 5

enum WeaponRealAdjustInfo {
	waID[MAX_WEAPONS_ADJUST],
	waBone[MAX_WEAPONS_ADJUST],
	Float:waOffSetX[MAX_WEAPONS_ADJUST],
    Float:waOffSetY[MAX_WEAPONS_ADJUST],
	Float:waOffSetZ[MAX_WEAPONS_ADJUST],
	Float:waRotSetX[MAX_WEAPONS_ADJUST],
	Float:waRotSetY[MAX_WEAPONS_ADJUST],
	Float:waRotSetZ[MAX_WEAPONS_ADJUST],
	Float:waScaleSetX[MAX_WEAPONS_ADJUST],
	Float:waScaleSetY[MAX_WEAPONS_ADJUST],
	Float:waScaleSetZ[MAX_WEAPONS_ADJUST]
};

new WeaponAdjust[MAX_PLAYERS][WeaponRealAdjustInfo];

/*enum TextDrawPosInfo
{
	Float:tdWeapon[3],
	Float:tdAmmo[3]
}
new TextDrawPos[MAX_PLAYERS][TextDrawPosInfo];*/