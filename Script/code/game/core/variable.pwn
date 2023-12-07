#if defined __game_core_variable
	#endinput
#endif
#define __game_core_variable

stock
	_tmp,
	Float:_tmpFloat,
	bool:_tmpBool,
	_tmpString[256] // nehogy lecsökkentsd a _tmpString méretét!
;

new ServerPort;

new PickedSpawnSpot[MAX_PLAYERS];
new SkipRealSpawn[MAX_PLAYERS];
new CanWakeUpAfter[MAX_PLAYERS];
new ForceSleepAnimation[MAX_PLAYERS];

new AnimClearBlockedUntil[MAX_PLAYERS];
new bool:PlayerBulletProof[MAX_PLAYERS];
new AdminDutySkin[MAX_PLAYERS];
new OnAirID = 255;
new PilotaRadar[MAX_PLAYERS];

new RaceNameBuild=NINCS;
new RaceNameBuildText[128];

new LSBankRablok;
new RabloID;
new DerbiKocsi[MAX_DERBI_KOCSI];

//new CGBanned[MAX_PLAYERS];
new FloodKuszas[MAX_PLAYERS];
new FloodKalap[MAX_PLAYERS];

new Float: VehiclePos[MAX_VEHICLES][3], bool:VehiclePosUpdated[MAX_PLAYERS];
new LastID; new Rabolt[MAX_PLAYERS];
new RifleTalalat[MAX_PLAYERS];
new LastDeath[MAX_PLAYERS];
new seo_carEnterTime[MAX_PLAYERS], seo_carFlood[MAX_PLAYERS], seo_carFloodTime[MAX_PLAYERS];
new seo_carTeleportFlood[MAX_PLAYERS], seo_carTeleportTime[MAX_PLAYERS];
new seo_carEntering[MAX_PLAYERS];
new seo_fakekillCount[MAX_PLAYERS], seo_fakekillTime[MAX_PLAYERS];
//Bugkihasználás ellen

new BicikliFlood[MAX_PLAYERS];
new UtoljaraHasznalta[MAX_VEHICLES][32];
new ClassClient;
new bool:Poloskazott[MAX_PLAYERS]; // Le van-e poloskázva az illetõ
new Poloskazta[MAX_PLAYERS]; // Ki poloskázta le õt
new bool:Poloska[MAX_PLAYERS]; // Be van-e kapcsolva a poloska
new Invitejog[MAX_PLAYERS];
new bool:ResiKukaFrissites;
new bool:FBIBeepules;
new bool:FBIAlnev;
new ASzint[MAX_PLAYERS];
new bool:Loginspawnolas[MAX_PLAYERS];
new bool:Jelvenytloptak[MAX_PLAYERS]; // Akitõl ellopták
new bool:Jelvenytlopott[MAX_PLAYERS]; // Aki ellopta
new JelvenyNeve[MAX_PLAYERS][MAX_PLAYER_NAME]; // Akitõl ellopták annak a neve
new JelvenySzervezet[MAX_PLAYERS]; // Akitõl ellopták annak a frakciójának a neve
new JelvenyRangnev[MAX_PLAYERS]; // Akitõl ellopták annak a rangja
new JelvenytLopta[MAX_PLAYERS]; //Aki ellopta, annak az IDje
new LaptopIP[MAX_PLAYERS];
new bool:LaptopConnected[MAX_PLAYERS];
new Evett[MAX_PLAYERS];

new KincsTimer[MAX_PLAYERS];
new KincsSzamlalo[MAX_PLAYERS];
new KincsKozte[MAX_PLAYERS];

new JailTime[MAX_PLAYERS]; // Ez ahhoz kell, ha a büntetése nagyobb volt, mint 25 perc, akkor nem engedi õt közmunkára
new bool:IdgScripter[MAX_PLAYERS];
new MulatasTime;
//new bool:Meghalt[MAX_PLAYERS];
new Warozott[MAX_PLAYERS];
new bool:ScriptShoot[MAX_PLAYERS], Shooted[MAX_PLAYERS][MAX_PLAYERS];
new Alszik[MAX_PLAYERS];
new PlayerVehicle[MAX_PLAYERS];
new bool:ArmoredVehicle[MAX_VEHICLES];
new PlayerSkin[MAX_PLAYERS];
new NoDamage[MAX_PLAYERS];
new bool:DontWriteJustLoggedIn[MAX_PLAYERS];
new Log_ClientConnects;
new bool:Log_Command = true;
new Bejelent[MAX_PLAYERS][32];
new JelenlegiDatum[12], DatumEv, DatumHonap, DatumNap, UnixTime;
new PBTerem[MAX_PLAYERS];
new Telefonok_UtolsoSMS[MAX_TELEFON][MAX_TAROLT_SMS][MAX_SMS_HOSSZ char];
new KincsAktiv = NINCS, Text3D:KincsObject, KincsKod[12], bool:KincsMutat[MAX_PLAYERS], KincsIdo, KincsUtolsoNyitas, KincsUtolsoNyitasNev[MAX_PLAYER_NAME];
new AdatforgalomAr = 34;
new AdatforgalomValtoztatas;
new bool:HarcVan;
new GarazsokSzamaOsszesen;
new TaxiHivasJelzes[MAX_PLAYERS];
new bool:VanAccountja[MAX_PLAYERS];
new SpeedMode = 1;
new UpdateSeconds = 1;
new Gas[MAX_VEHICLES];
new Benzin[MAX_VEHICLES];
new Diesel[MAX_VEHICLES];
new Kerozin[MAX_VEHICLES];
new RosszGas[MAX_VEHICLES];
new MunkaFolyamatban[MAX_PLAYERS];
new Posta[MAX_PLAYERS];
new Oktato[MAX_PLAYERS];
new Float:VizsgaRacePoint[MAX_PLAYERS][3];
new UserDataBeallit[MAX_PLAYERS];
new Float:EletRelog[MAX_PLAYERS];
new Float:EhsegRelog[MAX_PLAYERS];
new Float:VizeletRelog[MAX_PLAYERS];
new BoltRablasVW;
new AFKstring[MAX_PLAYERS][256];
new AFKszamlalo[MAX_PLAYERS];
new DLlast[MAX_PLAYERS] = 0;
new FPS2[MAX_PLAYERS] = 0;
new MentoSegit[MAX_PLAYERS];//mento
new KocsiHasznal[MAX_VEHICLES][32];
new TogVa[MAX_PLAYERS];
new Szirena[MAX_VEHICLES] = { NINCS, ... };//ujszirena
new Nkszirena[MAX_VEHICLES] = { NINCS, ... };//ujszirena
//new Nbszirena[MAX_VEHICLES] = { NINCS, ... };//ujszirena
new NeonCar[MAX_VEHICLES][2];//ujszirena
new JarmuLopas[MAX_VEHICLES][MAX_PLAYERS];
new FloodMegprobal[MAX_PLAYERS];
new SSSinfo[MAX_PLAYERS];
new KamionUtvonal[MAX_PLAYERS];
new PilotaUtvonal[MAX_PLAYERS];
new bikazott[MAX_VEHICLES];
new ACrs[MAX_VEHICLES];
new KamionRandom[12];
new KamionUtvaltas[12];
new KamionUtvaltasTime[12];
new PotkocsiSzamlalo[MAX_PLAYERS];
new bool:CigiFuggo[MAX_PLAYERS];
new SkinVed=1;
new LSSzefKod;
new Float:KmSzamol[MAX_VEHICLES];
new Float:KmCleo[MAX_VEHICLES];
new BankSzovegSzamLs[MAX_PLAYERS];
new BankSzovegSzamSf[MAX_PLAYERS];
//new AkkumlatorAllapot[MAX_VEHICLES];
//new Float:KocsiAllapot[MAX_VEHICLES];
//new Float:KocsiGumi[MAX_VEHICLES];
//new KocsiHibas[MAX_VEHICLES];
new Float:Kmx[MAX_PLAYERS], Float:Kmy[MAX_PLAYERS], Float:Kmz[MAX_PLAYERS];
new Float:PlayerPos[MAX_PLAYERS][3];
new rtelo = 1;
new TanultStilus[MAX_PLAYERS];
new Edzik[MAX_PLAYERS];
new Szondaztat[MAX_PLAYERS];
new CsatlakozottSzamla[MAX_PLAYERS];
/*new
	bool:AntiFegyverCheat = true,
	bool:FegyverVan[MAX_PLAYERS][12],
	Fegyver[MAX_PLAYERS][12],
	Loszer[MAX_PLAYERS][12],
	AC_Figyelmeztetes[MAX_PLAYERS];*/
new BejelentkezokSzama;
new bool:JarmuValtozasok[MAX_VEHICLES][2];
new engineOn[MAX_VEHICLES];
new bool:Gyujtas[MAX_VEHICLES] = false;
new CreatedCars[100];
//new Text3D:RoncsderbiFelirat[1500];
//new Float:RoncsFelSerul[MAX_PLAYERS];
new PenzszallitoPenz[MAX_VEHICLES];
new JatekosZsak[MAX_PLAYERS];
new SisakotVesz[MAX_PLAYERS];
new Sisak[MAX_PLAYERS];
new KalapbanVan[MAX_PLAYERS];
new BankSzef = 500000;
new BankSzefRablas = NINCS;
new BankTulaj[20];
new BankMasodTulaj[20];
new Tax = 500000;
new TaxValue = 5000;
new Jackpot = 0;
new Nyeroszam = 0;
new IgenylesEngedelyezve = 1;
new FBISzef = 10000000;
new Autojogsi = 0;
new Motorjogsi = 0;
new Kamionjogsi = 0;
new Adrjogsi = 0;
new Repulojogsi = 0;
new Helijogsi = 0;
new Hajojogsi = 0;
new Horgaszjogsi = 0;
new Fegyverjogsi = 0;
new Rejtett[MAX_PLAYERS];
new Tanulofelpenz[MAX_PLAYERS] = 0;
new ModBetoltve = 0;
new Csere[MAX_PLAYERS] = NINCS;
new MitCsere[MAX_PLAYERS] = NINCS;
new StartingKartRound = 0;
new EndingKartRound = 0;
new AnnouncedKartRound = 0;
new KartingPlayers = 0;
new KartingRound = 0;
new FirstKartWinner = 999;
new SecondKartWinner = 999;
new ThirdKartWinner = 999;
new Medics = 0;
new MedicCallTime[MAX_PLAYERS];
new Mechanics = 0, bool:Mechanikus[MAX_PLAYERS];
//new MechanicCall = 999;
new MechanicCallTime[MAX_PLAYERS];
//new TaxiCall = 999;
new TaxiCallTime[MAX_PLAYERS];
new TaxiAccepted[MAX_PLAYERS];
new BusDrivers = 0;
new BusCall = 999;
new BusCallTime[MAX_PLAYERS];
new BusAccepted[MAX_PLAYERS];
new TransportDuty[MAX_PLAYERS];
new TransportValue[MAX_PLAYERS];
new TransportMoney[MAX_PLAYERS];
new TransportTime[MAX_PLAYERS];
new TransportCost[MAX_PLAYERS];
new TransportDriver[MAX_PLAYERS];
new JobDuty[MAX_PLAYERS];
new FarmerDuty[MAX_PLAYERS];
new RegistrationStep[MAX_PLAYERS];
new OnCK[MAX_PLAYERS];
new bool:Paintballozik[MAX_PLAYERS];
new bool:Paintballnevezve[MAX_PLAYERS];
new PaintballOlesek[MAX_PLAYERS];
new PlayerPaintballKills[MAX_PLAYERS];
new PlayerKarting[MAX_PLAYERS];
new PlayerInKart[MAX_PLAYERS];
new TakingLesson[MAX_PLAYERS];
new UsedFind[MAX_PLAYERS];
new PlayersChannel[MAX_PLAYERS];
new PlayerOnMission[MAX_PLAYERS];
new MissionCheckpoint[MAX_PLAYERS];
new Tevezik[MAX_PLAYERS], Tevezve[MAX_PLAYERS];
new DivorceOffer[MAX_PLAYERS];
new MarriageCeremoney[MAX_PLAYERS];
new ProposeOffer[MAX_PLAYERS];
new ProposedTo[MAX_PLAYERS];
new GotProposedBy[MAX_PLAYERS];
new MarryWitness[MAX_PLAYERS];
new MarryWitnessOffer[MAX_PLAYERS];
new TicketOffer[MAX_PLAYERS];
new PlayerStoned[MAX_PLAYERS];
new ConsumingMoney[MAX_PLAYERS];
new FishCount[MAX_PLAYERS];
new PlayerDrunk[MAX_PLAYERS];
new FindTimePoints[MAX_PLAYERS];
new FindTime[MAX_PLAYERS];
new GyogyszerTime[MAX_PLAYERS];
new ConnectedToPC[MAX_PLAYERS];
new KorhazIdo[MAX_PLAYERS];
new UresHely; //sql-ben üres hely, nem törölhetõ mert elcsúsznának az adatok
new PlayerTied[MAX_PLAYERS];
new PlayerCuffed[MAX_PLAYERS];
new PlayerCuffedTime[MAX_PLAYERS];
new LiveOffer[MAX_PLAYERS];
new TalkingLive[MAX_PLAYERS];
/*new SelectChar[MAX_PLAYERS];
new SelectCharPlace[MAX_PLAYERS];*/
new SkinValasztoban[MAX_PLAYERS];
new SkinValasztas[MAX_PLAYERS];
new ChosenSkin[MAX_PLAYERS];
new CurrentMoney[MAX_PLAYERS];
new KickPlayer[MAX_PLAYERS];
new Robbed[MAX_PLAYERS];
new RobbedTime[MAX_PLAYERS];
new CP[MAX_PLAYERS];
new MoneyMessage[MAX_PLAYERS];
new Condom[MAX_PLAYERS];
new STDPlayer[MAX_PLAYERS];
new SexOffer[MAX_PLAYERS];
new SexPrice[MAX_PLAYERS];
new WantedLevel[MAX_PLAYERS];
new CarWantedLevel[MAX_VEHICLES];
new OnDuty[MAX_PLAYERS];
new ScripterDuty[MAX_PLAYERS];
new Swatduty[MAX_PLAYERS];
new HitmanDuty[MAX_PLAYERS];
new bool:Onkentesszolgalatban[MAX_PLAYERS];
new Felberelve[MAX_PLAYERS], FelberelveOsszeg[MAX_PLAYERS];
new gPlayerCheckpointStatus[MAX_PLAYERS];
new gPlayerLogged[MAX_PLAYERS];
new gLastCar[MAX_PLAYERS];
//new gReport[MAX_PLAYERS];
new gInfo[MAX_PLAYERS];
new gOoc[MAX_PLAYERS];
new gBooc[MAX_PLAYERS];
new gBoocszidas[MAX_PLAYERS];
new gBemlegetes[MAX_PLAYERS];
new gNews[MAX_PLAYERS];
new gFam[MAX_PLAYERS];
new bool:BigEar[MAX_PLAYERS];
new CellTime[MAX_PLAYERS];
new StartTime[MAX_PLAYERS];
new HireCar[MAX_PLAYERS];
new HidePM[MAX_PLAYERS];
new HidePMAsztal[MAX_PLAYERS];
new ReportDuty[MAX_PLAYERS];
new bool:PhoneOnline[MAX_PLAYERS];
new gDice[MAX_PLAYERS];
//new gSpentCash[MAX_PLAYERS];
new FirstSpawn[MAX_PLAYERS];
new Fixr[MAX_PLAYERS];
new Locator[MAX_PLAYERS];
new Mobile[MAX_PLAYERS];
new RingTone[MAX_PLAYERS];
new CallCost[MAX_PLAYERS];
new gCarLock[MAX_VEHICLES];
new KocsiSzinek[MAX_VEHICLES][2];
new bool:KocsibanVan[MAX_PLAYERS];
new bool:Kikepzoben[MAX_PLAYERS];
new bool:Hackeltkamera = false;
new Carblock[MAX_VEHICLES];
new noooc = 1;
new hatar = 1;
//new vk = 0;
new bool:ResiVan[3] = false;
new ssschat = 1;
new noas = 0;
new addtimer = 30000;
new laddtimer = 30000;
new Float:rx2, Float:ry2, Float:rz2;
new gdate = -1;
new ghour = 1;
new gminute = 0;
new gsecond = 0;
new realtime = 1;
new wtime = 15;
new realchat = 1;
new shifthour;
new LezartUtat[MAX_PLAYERS];
new Float:LezartUtX[MAX_PLAYERS], Float:LezartUtY[MAX_PLAYERS], Float:LezartUtZ[MAX_PLAYERS];
new DialogIDk[MAX_PLAYERS][MAX_PLAYERS];
new PMBlock[MAX_PLAYERS][MAX_PLAYERS];
new Timerek[32] = -1;
new robtimer = -1;
new RendeltKocsik, RendelesDatum, RendelesAlatt, RendelesPenz, RendelesIdo, RendelesModel, RendelesAzon;
new KereskedoKocsiElad[MAX_PLAYERS], KereskedoKocsiVetel[MAX_PLAYERS], KereskedoKocsi[MAX_PLAYERS], KereskedoKocsiCsere[MAX_PLAYERS];
new levelexp = 4;
new cchargetime = 60;
new pickups;
//new Float:PlayerPos[MAX_PLAYERS][6];
new Float:TelePos[MAX_PLAYERS][6];
new SzefEngedely[MAX_PLAYERS] = 0;
new LSPDAjto[6];
new SFPDKapu[2];
new LsBankKapu;

new AutoSzereloKapu;
new sfpdkapu;
new swatkapu1;
new KereskedoKapu;
new KereskedoKapuHQn;
new audvar;

new Katonacsatorna;
new Fbilezaro1;
new Fbilezaro2;
new Fbilezaro3;

new roadblock[MAX_PLAYERS];
new block[MAX_PLAYERS];
new HolTart[MAX_PLAYERS];
new Rob = 0;
new AnimIdo[MAX_PLAYERS];
new ov[MAX_PLAYERS];
new SzajBekotve[MAX_PLAYERS];
new SzemBekotve[MAX_PLAYERS];
new OvFlood[MAX_PLAYERS];
new NekiSzerelt[MAX_PLAYERS];
new C4Lerakva[MAX_PLAYERS];
new C4Kocsiban[MAX_PLAYERS] = {NINCS, ...};
new C4Object[MAX_PLAYERS];
new C4Ido[MAX_PLAYERS];
new Text3D:C4Text[MAX_PLAYERS];
new Float:C4X[MAX_PLAYERS], Float:C4Y[MAX_PLAYERS], Float:C4Z[MAX_PLAYERS];
new TelefonTipus[MAX_PLAYERS];
new VizsgaAjanlat[MAX_PLAYERS] = NINCS;
new Vizsgafajta[MAX_PLAYERS];
new VizsgaAr[MAX_PLAYERS] = 0;
new Pmek[MAX_PLAYERS]=0;
new Autocp[MAX_PLAYERS];
new Repulocp[MAX_PLAYERS];
new Helicp[MAX_PLAYERS];
new Hajocp[MAX_PLAYERS];
new togkill[MAX_PLAYERS];
new toghatarok[MAX_PLAYERS];
new bool:Tvenged[MAX_PLAYERS];
new bool:GOTOenged[MAX_PLAYERS];
new Kamioncp[MAX_PLAYERS];
new bool:LsBankban[MAX_PLAYERS];
new GarazsElott[MAX_PLAYERS];
new Oktat[MAX_PLAYERS];
new bool: AJFigyelmeztetes[MAX_PLAYERS];
new PingKick[MAX_PLAYERS];
new RepulesEngedely[MAX_VEHICLES];
new RadarBe[MAX_PLAYERS];
new TavoliBomba[MAX_PLAYERS];
new Crosscp[MAX_PLAYERS];
new bool:Baraktiv[MAX_PLAYERS];
new ValaszokEll[MAX_PLAYERS][MAX_PLAYERS];
new AirtaxiJob[MAX_PLAYERS];
new Favago[MAX_PLAYERS];
new Adrcp[MAX_PLAYERS];
new Motorcp[MAX_PLAYERS];
new Jogsineki[MAX_PLAYERS] = NINCS;
new PrivatAjanlat[MAX_PLAYERS] = NINCS;
new PrivatAr[MAX_PLAYERS] = NINCS;
new PrivatEngedely[MAX_PLAYERS] = NINCS;
new robmoney;
new lspdmoney;
new robpenzido[MAX_PLAYERS];
new reporttiltva[MAX_PLAYERS];
new TvEngedely[MAX_PLAYERS];
new tuningolo[MAX_PLAYERS];
new VanBombaBenne[MAX_VEHICLES];
new FbiBelepve[MAX_PLAYERS];
new Szajkendo[MAX_PLAYERS];
new Maszk[MAX_PLAYERS];
new BankAjto;
new BankC4;
new BankRobIdo = 0;
new MikorRabolhato = 0;
new Boltrabolhato = 0;
//new Float:OlajCsere[MAX_VEHICLES];
new KocsiLeadas[MAX_VEHICLES];
new HibasBelepes[MAX_PLAYERS];
new bool:Mysql = false;
//new MysqlHiba = 0;
//new Utolso_Player = MAX_PLAYERS;
new LoginTime[MAX_PLAYERS char];
new BenzintSzallit[MAX_PLAYERS];
new AdasVeteliNeki[MAX_PLAYERS];
new AdasVeteliTipus[MAX_PLAYERS];
new AdasVeteliAra[MAX_PLAYERS];
new AdasVeteliCucc[MAX_PLAYERS];
new MostLepettBe[MAX_PLAYERS];
new KocsiRiaszto[MAX_VEHICLES];
new BackupTime[MAX_PLAYERS];
new HazPickup[MAXHAZ];
new GarazsPickup[MAXGARAZS];
new FelujitasElfogadas[MAX_PLAYERS];
new RegEngedely[MAX_PLAYERS];
new RegAdatok[MAX_PLAYERS];
new Inditasgatlo[MAX_VEHICLES];
new bool:Tankolaskozben[MAX_VEHICLES] = false;
new Almaszedeskozbe[MAX_VEHICLES];
new NemregiKocsi[MAX_PLAYERS];
//new OlajKell[MAX_VEHICLES];
new BizPickup[MAXBIZ];
new Float:JatekosElete[MAX_PLAYERS];
new Float:KocsiElete[MAX_VEHICLES];
new MunkaFelvetel[MAX_PLAYERS];
new AdminDuty[MAX_PLAYERS];
new Text3D:AdminDuty3D[MAX_PLAYERS];
new Text3D:KisLVL[MAX_PLAYERS];
new Text3D:Elajult[MAX_PLAYERS];
new bool:KisLVLFelirat[MAX_PLAYERS];
new bool:Szunet[MAX_PLAYERS], SzunetIdo[MAX_PLAYERS];
new AFKIdo[MAX_PLAYERS];
//new Jelzes[MAX_PLAYERS], JelzesIdo[MAX_PLAYERS];
new Text3D: Swat3D[MAX_PLAYERS];
new LopasProbalkozas[MAX_PLAYERS];
new AnimVezetes[MAX_PLAYERS];
new bool:Lopott[MAX_VEHICLES];
new NevvaltasiEngedely[MAX_PLAYERS];
new Munkaban[MAX_PLAYERS];
new MunkaCheckpoint[MAX_PLAYERS];
new MunkaCheckpoint2[MAX_PLAYERS];
new Float:MunkaStarthely[MAX_PLAYERS][3];
new Matrica[MAXVSKOCSI];
new Rabol[MAX_PLAYERS];
new Mergezve[MAX_PLAYERS] = 0;
new KiMergezte[MAX_PLAYERS] = NINCS;
new Tkerek[MAX_PLAYERS];
new Tszin[MAX_PLAYERS];
new Visz[MAX_PLAYERS];
new HVisz[MAX_PLAYERS];
new Adminseged[MAX_PLAYERS];
new Drogozott[MAX_PLAYERS];
new Animban[MAX_PLAYERS];
new AnimbanRelog[MAX_PLAYERS];
new IDK[MAX_PLAYERS];
new bool:Connected[MAX_PLAYERS];
new bool:NPC[MAX_PLAYERS];
new bool:PreConfigured[MAX_PLAYERS];
new Joypad[MAX_PLAYERS];
new bool:Bankkartya[MAX_PLAYERS];
new bool:MikulasSapka[MAX_PLAYERS];
new bool:MarBelepett[MAX_PLAYERS];
new Desync[MAX_PLAYERS];
new bool:FlyModeBa[MAX_PLAYERS];
new Text3D:BText[MAX_PLAYERS] = {INVALID_3D_TEXT_ID, ...};
new Text3D:AText[MAX_PLAYERS] = {INVALID_3D_TEXT_ID, ...};
//new Float:ClothesPos[MAX_PLAYERS][3];
new bool:Bejelento[MAX_PLAYERS];
new bool:Anev[MAX_PLAYERS];
new Bicikli[MAX_PLAYERS];
new DialogID[MAX_PLAYERS], DialogStyle[MAX_PLAYERS];
new bool:Pee[MAX_PLAYERS];
new CJFutasWarn[MAX_PLAYERS];
new Gyemantjai[MAX_PLAYERS];
//new Neon[MAX_VEHICLES][2];
new Neon[MAX_VEHICLES];//neon
new bool:Detektor[MAX_VEHICLES];
//new bool:NeonBe[MAX_VEHICLES];
//new OnHitVedelem[MAX_PLAYERS];
new bool:ParancsAjto[MAX_PLAYERS];
new PlayerState[MAX_PLAYERS];
new PlayerInterior[MAX_PLAYERS];
new PlayerVW[MAX_PLAYERS];
new Ajtozott[MAX_PLAYERS];
new bool:Ul[MAX_PLAYERS];
new bool:Beszallt[MAX_PLAYERS];
new bool:Aukciozik[MAX_PLAYERS];
new AJSzokesek[MAX_PLAYERS], AJVarakozas[MAX_PLAYERS];
new AJSzovegIdo[MAX_PLAYERS], AJSzovegHiba[MAX_PLAYERS], AJSzoveg[MAX_PLAYERS], AJSzovegString[MAX_PLAYERS][64];
new BejelentIdo[MAX_PLAYERS];
new KocsiUtolsoHasznalat[MAX_VEHICLES];
new KocsiSokkolva[MAX_VEHICLES], KocsitSokkolt[MAX_PLAYERS];
new bool:Sokkol[MAX_PLAYERS], SokkObject[MAX_VEHICLES], Float:SokkTav[MAX_PLAYERS];
new MentoHivas[MAX_PLAYERS],TaxiHivas[MAX_PLAYERS];
new SzereloHiv[MAX_PLAYERS];
new bool:NoName[MAX_PLAYERS];
new bool:Penztkapott[MAX_PLAYERS];
new SSSTamogatas[MAX_PLAYERS];
new KiertMegy[MAX_PLAYERS] = {NINCS, ...};
new Katonabazis[MAX_PLAYERS];
new bool:Halal[MAX_PLAYERS];
new bool:Harcol[MAX_PLAYERS], HarcolTerulet[MAX_PLAYERS];
//new bool:Harcolkeseltet[MAX_PLAYERS];
new Float:TVPos[MAX_PLAYERS][3], TVVW[MAX_PLAYERS], TVInt[MAX_PLAYERS];
new bool:JatekBetoltve[MAX_PLAYERS];
new SebessegKorlat[MAX_PLAYERS], SebessegKorlatTick[MAX_PLAYERS];
new bool:JegyBuntetve[MAX_PLAYERS];
new bool:Kilepesek[MAX_PLAYERS];
new bool:Belepesek[MAX_PLAYERS];
new Tankol[MAX_PLAYERS][2];
new SpawnVedelem[MAX_PLAYERS];
new SpawnHely[MAX_PLAYERS];
new BelepesIdo[MAX_PLAYERS];
new MelyikKamera[MAX_PLAYERS];
new Lehallgat[MAX_PLAYERS];
new Loterben[MAX_PLAYERS];
new Kamera[MAX_PLAYERS];
new bool:PlayerOnline[MAX_PLAYERS];
new Nevek[MAX_PLAYERS];
new Biztos[MAX_PLAYERS];
new Skinsel[MAX_PLAYERS];
new Animbanemrakhato[MAX_PLAYERS];
new AFK[MAX_PLAYERS];
new bool:Lefoglalt[MAX_PLAYERS];
new HitmanRendeles[MAX_PLAYERS];
new Engedely[MAX_PLAYERS];
new ElsoSpawn[MAX_PLAYERS];
new Dialog[MAX_PLAYERS];
new Szallit[MAX_PLAYERS];
new Repul[MAX_PLAYERS];
new Felleszallas[MAX_PLAYERS];
new ZeneVan[MAX_PLAYERS];
new RioMiki[MAX_PLAYERS];
new MoriartyMiki[MAX_PLAYERS];
new SzedKocsi[MAX_PLAYERS];
new SzedZseb[MAX_PLAYERS];
new RioZeneenged[MAX_PLAYERS];
new MoriartyZeneenged[MAX_PLAYERS];
new bool:Havazas[MAX_PLAYERS];
new MunkaTimerID[MAX_PLAYERS];
new NPCElott[MAX_PLAYERS];
new NPCElottKick[MAX_PLAYERS];
new bool:PenzSzallitoDuty[MAX_PLAYERS];
new PenzSzallitimer[MAX_PLAYERS];
new TeloElrak[MAX_PLAYERS];
new bool:MegyPenzTimer;
new SzallitPenz[MAX_PLAYERS];
new RadioHallgatas[MAX_PLAYERS];
new RadioAktivsag;
new RadioMusorNev[64];
new TrailerLampa[2][MAX_VEHICLES];

new CarRespawnSzamlalo = NINCS;

new BelepveFake[MAX_PLAYERS];
new Text3D:KozmunkasFelirat[MAX_PLAYERS];
new OsszRang[22];
new Rangok[MAX_FRAKCIO][MAX_FRAKCIO_RANG][32];
new Szervezetneve[MAX_FRAKCIO][3][32];
new PoliceAlosztaly[MAX_POLICE_CLASS][3][32];
new PoliceRangok[MAX_POLICE_CLASS][MAX_FRAKCIO_RANG][32];
new Float:Ehseg[MAX_PLAYERS], Bar:EhsegBar[MAX_PLAYERS] = {INVALID_BAR_ID, ...};
new Float:Vizelet[MAX_PLAYERS], Bar:VizeletBar[MAX_PLAYERS] = {INVALID_BAR_ID, ...};
#if defined Megbizas
new KivegzoRang[3] = {5, 5, 4};
#endif
new bool:Ninjaengedely;
//new bool:LSPDKapunyit;
new Float:iPlayerHealth[MAX_PLAYERS];
new Float:iNewPlayerHealth[MAX_PLAYERS];
new Float:iPlayerArmour[MAX_PLAYERS];
new Float:iNewPlayerArmour[MAX_PLAYERS];
new iPlayerMoney[MAX_PLAYERS];
new iNewPlayerMoney[MAX_PLAYERS];
new iPlayerAmmo[MAX_PLAYERS];
new iNewPlayerAmmo[MAX_PLAYERS];
new iPlayerVirtualWorld[MAX_PLAYERS];
new iNewPlayerVirtualWorld[MAX_PLAYERS];
new iPlayerInterior[MAX_PLAYERS];
new iNewPlayerInterior[MAX_PLAYERS];
new iPlayerScore[MAX_PLAYERS];
new iNewPlayerScore[MAX_PLAYERS];
new iPlayerTeam[MAX_PLAYERS];
new iNewPlayerTeam[MAX_PLAYERS];
new iPlayerSkin[MAX_PLAYERS];
new iNewPlayerSkin[MAX_PLAYERS];
new iPlayerWantedLevel[MAX_PLAYERS];
new iNewPlayerWantedLevel[MAX_PLAYERS];
new iPlayerWeapon[MAX_PLAYERS];
new iNewPlayerWeapon[MAX_PLAYERS];
new Sokkolt[MAX_PLAYERS];
new Leutott[MAX_PLAYERS];
new Fbibelepes;
new bool:FBIadastiltas;
new bool:FBIhatartiltas;
new Fbibent = 0;
new Fbicelpont[MAX_PLAYERS];
new Hazbanvan[MAX_PLAYERS];
new Fbios[MAX_PLAYERS];
new bool:Leutve[MAX_PLAYERS];
new LeutveIdo[MAX_PLAYERS];
new AblakLent[MAX_VEHICLES];
new Ugrasok[MAX_PLAYERS][3];
new ReportolasIdo[MAX_PLAYERS];
new skine[MAX_PLAYERS];
new fegyvere[MAX_PLAYERS];
new bool:NPCKocsi[MAX_VEHICLES];
new HatartAtlepte[MAX_PLAYERS];
new Nyomozott[MAX_PLAYERS];
new SSSSzef;
new SSSDuty[MAX_PLAYERS];

//carresi
new CarresiDB = 50;
new ResiCounter = 14400;
new AutoResi = 14400;
new bool:ResiCounterFIX=true;

new DeanObject[4];
//new Yakuzakapu[3];
new OnkormanyzatAjto[4];
new GSFAjto;
/*new Text:HelyezesTD[MAX_PLAYERS];
new bool:HelyezesTDCreated[MAX_PLAYERS];*/
new Float:RaceStart[RACESLOTOK][3];
new Float:RaceCel[RACESLOTOK][3];
new Float:RaceCP[RACESLOTOK][RACEMAXCP][3];
//static gTeam[MAX_PLAYERS];
new CurCol[MAX_PLAYERS] = 0;
new Conn[MAX_PLAYERS] = 0;
new Money[MAX_PLAYERS] = 0;
new Text:MoneyTxt[MAX_PLAYERS];
new MoneyTxtCreated[MAX_PLAYERS];
new Text:resitd, Text:resiszerver, Text:FeketesegTD, Text:zerotd;
new BViadal[MAX_PLAYERS] = 0;
new BVStart = 0;
new BVIdo = 1800;
new BVJatekosok = 0;
new BVPenz = 0;
new Locsolas[MAX_PLAYERS] = NINCS;
new Locsolniakar[MAX_PLAYERS] = NINCS;
new TudReportolni[MAX_PLAYERS] = 0;
new TilosOlni = 0; 
new HazKulcs[MAX_PLAYERS] = NINCS;
//new JarmuKulcs[MAX_PLAYERS] = NINCS;
new PSzam1[MAX_PLAYERS] = 0;
new PSzam2[MAX_PLAYERS] = 0;
new PSzam3[MAX_PLAYERS] = 0;
new PSzam4[MAX_PLAYERS] = 0;
new PSzam5[MAX_PLAYERS] = 0;
new PSzam6[MAX_PLAYERS] = 0;
new PSzam7[MAX_PLAYERS] = 0;
new PSzam8[MAX_PLAYERS] = 0;
new RiporterAlive[MAX_PLAYERS] = 0;
new VanSzelvenye[MAX_PLAYERS] = 0;
new PSorsolas = 300; // másodperc
new talalatok[MAX_PLAYERS] = 0;
new NewsRadioHallgatas[MAX_PLAYERS] = NINCS;

new SzerverResiCounter;
new SzerverResiigCounter;
new SzerverCounter;

new bool:KeyPadActive[MAX_PLAYERS];


new KodToroActive[MAX_PLAYERS];


new PlayerText:Kellek[2];
new PlayerText:Gombok[10];
new PlayerText:Jelzes[2];
new PlayerText:KapuNev;
new Szamok[MAX_PLAYERS][6];
new bool:Valtozott[MAX_PLAYERS] = false;
new MelyikKapu[MAX_PLAYERS] = -1;
new Text:InfoTextDraw[MAX_PLAYERS];
new Text:InfoTextDraw2[MAX_PLAYERS];
new Text:InfoTextDraw3[MAX_PLAYERS];
new Text:InfoTextDraw4[MAX_PLAYERS];
new Text:InfoTextDrawWeapons[MAX_PLAYERS];
new Text:InfoTextDrawAmmo[MAX_PLAYERS];
new Text:InfoTextDrawHUD[MAX_PLAYERS];
new Text:InfoTextDrawHUDHearth[MAX_PLAYERS];
new Text:InfoTextDrawBAREHSEG[MAX_PLAYERS];
new Text:InfoTextDrawBARPEE[MAX_PLAYERS];
new Text:InfoTextDrawBARARMOR[MAX_PLAYERS];
new Text:InfoTextDrawBARFOOD[MAX_PLAYERS];
new Text:InfoTextDrawBARTOILET[MAX_PLAYERS];
new PlayerText:LoginTextDraw[MAX_PLAYERS];
new PlayerText:LoginTextDraw2[MAX_PLAYERS];
new InfoTextDrawCreated[MAX_PLAYERS];
new InfoTextDrawCreated2[MAX_PLAYERS];
new InfoTextDrawCreated3[MAX_PLAYERS];
new InfoTextDrawCreatedWeapons[MAX_PLAYERS];
new InfoTextDrawCreatedAmmo[MAX_PLAYERS];
new InfoTextDrawCreatedHUD[MAX_PLAYERS];
new InfoTextDrawCreatedHUDHearth[MAX_PLAYERS];
new InfoTextDrawCreatedBAREHSEG[MAX_PLAYERS];
new InfoTextDrawCreatedBARPEE[MAX_PLAYERS];
new InfoTextDrawCreatedBARARMOR[MAX_PLAYERS];
new InfoTextDrawCreatedBARFOOD[MAX_PLAYERS];
new InfoTextDrawCreatedBARTOILET[MAX_PLAYERS];
//new InfoTextDrawCreated4[MAX_PLAYERS];
new bool:LoginTextDrawCreated[MAX_PLAYERS];
new bool:LoginTextDrawCreated2[MAX_PLAYERS];
new UtkozesErzekenyseg = 8; // 7 az eredeti (elsõ) érték
new bool:Licitalt[MAX_PLAYERS];
new LicitKocsi;
//=========[¢Új Fügvények]==========//
new Gokartozik[MAX_PLAYERS];
//==========[Vége]=============//
new Text3D:OktatoFelirat[MAX_VEHICLES];
new Text3D:SajtoIgazolvany[MAX_PLAYERS];
new Text3D:Onkentestext[MAX_PLAYERS];
new NPC_ID[MAX_PLAYERS];
new NPC_MegallokIdo[MAX_NPC_SOFOR][MAX_MEGALLO];
new Float:NPC_Megallok[MAX_NPC_SOFOR][MAX_MEGALLO][4];
new NPC_MegallokNeve[MAX_NPC_SOFOR][MAX_MEGALLO][30];
new MaxLoter = 15;
new bool: VamkommandoEngedely = true;
//SWATPAJZS
new taktikus = 0;
new SwatTamado = 0;
new SwatPajzsEngedely = 0;
new bool: PajzsNala[MAX_PLAYERS] = false;
//SWATPAJS
new Mento[MAX_PLAYERS][128], MentoHelyszin[MAX_PLAYERS][64], MentoLegi[MAX_PLAYERS];
new CallTuzOk[MAX_PLAYERS][128], CallTuz[MAX_PLAYERS];
new fszallit;
new HullakSzama[MAX_VEHICLES];
new SzemetAKocsiban[MAX_VEHICLES];
new bool:VanSzemetNala[MAX_PLAYERS] = false;
new kuka[MAX_PLAYERS] = NINCS;
new bool:SzemetDebug[MAX_PLAYERS] = false;
new bool:Erosites[MAX_PLAYERS];
new bool:CsaladBK[MAX_PLAYERS];
new swatsilenced;
new swatdeagle;
new swatmp5;
new swatm4;
new swatshotgun;
new swatcombat;
new swatsniper;
new Valasz[MAX_PLAYERS];
new bool:LSPD;
new bool:SFPD;
new ButorKategoria[MAX_PLAYERS];
new SzerkesztesButor[MAX_PLAYERS];
new KapuID[MAX_PLAYERS];
new SzerkesztesAllas[MAX_PLAYERS];
new Float:vehicleh[MAX_VEHICLES];
new Float:velX[MAX_PLAYERS], Float:velY[MAX_PLAYERS], Float:velZ[MAX_PLAYERS];
new vehSpeed[MAX_VEHICLES];
new bool:SKapuEngedely[MAX_PLAYERS];
new Float:HalalPos[MAX_PLAYERS][3];
new HalalVW[MAX_PLAYERS];
new HalalInti[MAX_PLAYERS];
new bool:Haldoklik[MAX_PLAYERS];
new HaldoklasIdo[MAX_PLAYERS];
new Float:HaldoklasPoz[MAX_PLAYERS][3];
new HaldoklasInt[MAX_PLAYERS];
new HaldoklasVW[MAX_PLAYERS];
new bool: LoterFigyel[MAX_PLAYERS] = false;
new KocsiLista[MAX_PLAYERS][9];
new KocsiAr[MAX_PLAYERS][9];
new Zsebradio[MAX_PLAYERS];
new KocsiRadio[MAX_VEHICLES];
new bool:Tiltottszam[MAX_PLAYERS];
new AutokerKulcs[MAX_PLAYERS];
new ObjectSzerkeszt[MAX_PLAYERS];
new LopottTime[MAX_VEHICLES];
new tdcounter, checkprop;
new bool:Csendvan;
new Idojaras[MAX_PLAYERS];
new HoObject[MAX_PLAYERS][MAX_HO_OBJECT];
new PiacDialog[MAX_PLAYERS], PiacAdatok[MAX_PLAYERS][3], PiacDialogNext[MAX_PLAYERS];
new TuzIdo = 10, bool:TuzVan, Text:TuzInfo[3], Tuzoltok, bool:Tuzolto[MAX_PLAYERS], bool:TuzetOlt[MAX_PLAYERS], TuzJutalom, bool:TuzMutat[MAX_PLAYERS];
new ForaglomFigyelmezteto[MAX_PLAYERS];
new MySQLProba;
new EldobottPenzObject[MAX_DROP_ITEMS];
new Text3D:EldobottPenzText[MAX_DROP_ITEMS];
new CarType[MAX_VEHICLES];
new CarUID[MAX_VEHICLES], CarUID2[MAX_VEHICLES];
new JavitasAra[MAX_PLAYERS];
new bool:GumitCserel[MAX_PLAYERS];
new GotoKategoria[MAX_PLAYERS];
new bool:OlajatCserel[MAX_PLAYERS];
new bool:AkkutCserel[MAX_PLAYERS];
new bool:MotortCserel[MAX_PLAYERS];
new bool:ElektronikatCserel[MAX_PLAYERS];
new bool:FeketCserel[MAX_PLAYERS];
new bool:KarosszeriatCserel[MAX_PLAYERS];
new NekiSzerel[MAX_PLAYERS] = NINCS;
new AlkatreszAr[MAX_PLAYERS];
new bool:Snevek[MAX_PLAYERS];
new Fekvorendorok[MAX_FEKVORENDOR][MAX_FEKVORENDOR_PICK];
new Text3D:FekvorendorText[MAX_PLAYERS][MAX_FEKVORENDOR];
new FBILift[5];
new ArveresNPC = NINCS;
new BankNPC = NINCS;
new BankSFNPC = NINCS;
new Text3D:BankNPCText;
new Text3D:TAXITEXT[MAX_VEHICLES];
new Text3D:BankSFNPCText;
new Text3D:ArveresNPCText;
new AjtoSF[2];
new AjtoSFTimer[MAX_PLAYERS];
new FeketeRadar;
new RioZene[256], RiobanVan[MAX_PLAYERS char];
new MoriartyZene[256], MoriartybanVan[MAX_PLAYERS char];
new RiporterZene[256];
new bool:RiporterZeneVan;
new NetKavezo[MAX_PLAYERS];
new SSSCheck[MAX_PLAYERS] = false;
new AJCPValtozo[MAX_PLAYERS];//globális változó
new Iterator:Jatekosok<MAX_PLAYERS>, Iterator:Fekvorendor<MAX_FEKVORENDOR>;
new OnlineJatekosok;
new InfoPickup;
new PlayerText:FaVagasTD;
new RendorPajzsIdo[MAX_PLAYERS];
new KocsiAlakitModel[MAX_PLAYERS];
new KocsiAlakitAra[MAX_PLAYERS];
new KocsiAlakitID[MAX_PLAYERS];
new ObjectIDje[MAX_PLAYERS][3];
new SzamlaraUtal[MAX_PLAYERS];
//new bool:PD_Fegyver_Engedely[2] = false;
new PD_Fegyver_Felvett[MAX_PLAYERS] = 0;
new ladds=1, adds=1;
new SzoltNeki[MAX_PLAYERS];
new AfterLoginTime[MAX_PLAYERS];
new IRCBanTime[MAX_PLAYERS]; new IRCBanRoom[MAX_PLAYERS];
new PBLista[MAX_PLAYERS];
new bool:DriveBy[MAX_PLAYERS];
new bool:Tazer[MAX_PLAYERS];
new gPB[MAX_PLAYERS];
new gOColor[MAX_PLAYERS];
new Float:kamionrandom[MAX_PLAYERS];
new KamionKihagyva[MAX_PLAYERS];
new KamionSzoveg[MAX_PLAYERS][750];
new KamionEgyeb[MAX_PLAYERS];
new RKAOnDuty[MAX_PLAYERS];
new gTogLR[MAX_PLAYERS];
new bool:gLohet[MAX_PLAYERS];
new bool:KereskedoLicitalt[MAX_PLAYERS];
new CsomagAllapot[MAX_PLAYERS];
new Float:Csomag[MAX_PLAYERS][3];
new Laser[26];
new LezerDeaktivalva = false;
new LaserArea;
new Text3D:AlcatrazSzokes3DText;
new SzellozoC4;
new Szokhet = false;
new AlcatrazAjto;
new AjtoDeaktivalva = false;
new bool:VamkommandoDuty[MAX_PLAYERS];
new ElvettRadio[MAX_PLAYERS], gFam2[MAX_PLAYERS];
new bool:HifiZene[MAXHAZ], bool:Hifirolhallgatzenet[MAX_PLAYERS];
new YouTubeZeneRakas[MAX_PLAYERS];

// cp hack
new CheckpointHackCount[MAX_PLAYERS];
new Float:LastCheckpoint[MAX_PLAYERS][3];
new LastCheckpointTime[MAX_PLAYERS];
new LastCheckpointHackTime[MAX_PLAYERS];

// nsql
enum qInfo
{
	bool:qBusy,
	qType,
	qParam1,
	qParam2,
	qParam3,
	qParam4
}
new SQL[ MAX_QUERY ][ qInfo ], MySQL:sql_ID;

new HusvetiEvent = false;
new JarmuKulcs[MAX_PLAYERS] = NINCS;

new Float:PlayerEditObjectPos[MAX_PLAYERS][3];
new pGumilovedek[MAX_PLAYERS];
new bool:Boltotrabol[MAX_PLAYERS];
new bool:selecting[MAX_PLAYERS];

new bool:HUDAktiv[MAX_PLAYERS];
new bool:WeaponsAktiv[MAX_PLAYERS];

new HatarZarUnixTime = NINCS;

//bánya
new bool:banyaszbsz[MAX_PLAYERS];
new bool:vanNalaKo[MAX_PLAYERS];
new obj[4];

//drogteszt
new Drogteszt[MAX_PLAYERS] = -1;

//villanyszerelõ
new bool:oszlopcsere[MAX_PLAYERS];
new bool:vmunk[MAX_PLAYERS];
new hova[MAX_PLAYERS];

//szállít
new szallit[MAX_PLAYERS] = NINCS;
new bool:szallitasz[MAX_PLAYERS];
new fortKapuBalObj[sizeof(fortKapuBal)];
new fortKapuJobbObj[sizeof(fortKapuJobb)];
new cella[MAX_PLAYERS];

//alcatraz
new btakaritok;
new bbanyaszk;

//Graffiti
new SzerkesztGraffiti[MAX_PLAYERS] = NINCS;
new AdminGraffiti[MAX_PLAYERS] = NINCS;
new KeyGraffiti[MAX_PLAYERS] = NINCS;
new KellGomb[MAX_PLAYERS] = NINCS;
new KeyCount[MAX_PLAYERS];

//GPS admin szerkesztés
new AdminGPS[MAX_PLAYERS] = NINCS;

new bool:GovEngedely[MAX_PLAYERS];