#if defined __game_function_timer
	#endinput
#endif
#define __game_function_timer

fpublic CustomPickups()
{
	for(new a = 0; a < MAXAJTO; a++)
	{
		if(!Ajtok[a][Van] || !Ajtok[a][Kocsi]) continue;

		if(Ajtok[a][PickupKocsiBeRe])
		{
			Ajtok[a][PickupKocsiBeRe] = false;
			DestroyDynamicPickup(Ajtok[a][PickupKocsiBe]);
			Ajtok[a][PickupKocsiBe] = UjPickup(1007, 14, Ajtok[a][BeX], Ajtok[a][BeY], Ajtok[a][BeZ], Ajtok[a][BeVW], Ajtok[a][BeInt]);
		}
		if(Ajtok[a][PickupKocsiKiRe])
		{
			Ajtok[a][PickupKocsiKiRe] = false;
			DestroyDynamicPickup(Ajtok[a][PickupKocsiKi]);
			Ajtok[a][PickupKocsiKi] = UjPickup(1007, 14, Ajtok[a][KiX], Ajtok[a][KiY], Ajtok[a][KiZ], Ajtok[a][KiVW], Ajtok[a][KiInt]);
		}

	}
	new oks, tmpcar = -1;
	foreach(Jatekosok, i)
	{
		oks = 0;

		if(IsPlayerInAnyVehicle(i))
			tmpcar = GetPlayerVehicleID(i);

		for(new h = 0; h < sizeof(HouseInfo); h++)
		{
			if(HouseInfo[h][Van] != 1) continue;

			if(PlayerToPoint(3.0, i, HouseInfo[h][hEntrancex], HouseInfo[h][hEntrancey], HouseInfo[h][hEntrancez]))
			{
				if(HouseInfo[h][hOwned] == 1)
				{
					//if(HouseInfo[h][hRentabil] == 0)
					format(_tmpString, 128, "~w~Class utca %d.~n~Tulaj:%s",h,HouseInfo[h][hOwner]);
					//else
						//format(string, sizeof(string), "~w~Class utca %d.~n~Tulaj:%s~n~Berelheto:%dFT~n~Szobaberles: /rentroom",h,HouseInfo[h][hOwner],HouseInfo[h][hRent]);
					GameTextForPlayer(i, _tmpString, CUSTOMPICKUPSTIME, 3);
					oks = 1;
					break;
				}
				else
				{
				    if(HouseInfo[h][hCsak] != 1)
						format(_tmpString, 128, "~w~Class utca %d.~n~Ara:~g~%s FT~n~~w~Haz megvetele:/buyhouse",h,FormatNumber( HouseInfo[h][hValue], 0, ',' ));
        			else
			         	format(_tmpString, 128, "~w~Class utca %d.~n~Ara:~g~%s FT~n~~w~Haz megvetele:/buyhouse~n~Csak:%s",h,FormatNumber( HouseInfo[h][hValue], 0, ',' ), HouseInfo[h][hCsakneki]);
					GameTextForPlayer(i, _tmpString, CUSTOMPICKUPSTIME, 3);
					oks = 1;
					break;
				}
			}
		}
		if(oks) continue;
		for(new h = 0; h < sizeof(GarazsInfo); h++)
		{
			if(GarazsInfo[h][Van] != 1) continue;

			if(PlayerToPoint(3.0, i, GarazsInfo[h][hEntrancex], GarazsInfo[h][hEntrancey], GarazsInfo[h][hEntrancez]))
			{
				if(GarazsInfo[h][hEladva] == 1)
				{
					if(GarazsInfo[h][hHaz] != NINCS)
					{
						if(Admin(i,1))
							format(_tmpString, 128, "~w~Class utca %d.~n~~w~((id: %d))",GarazsInfo[h][hHaz],h);
						else
							format(_tmpString, 128, "~w~Class utca %d.~n~",GarazsInfo[h][hHaz]);
					}
					else
					{
						format(_tmpString, 128, "~w~Class gar˜zs %d.~n~Tulaj:%s",h,GarazsInfo[h][hOwner]);
					}
					GarazsElott[i]=h;
					GameTextForPlayer(i, _tmpString, CUSTOMPICKUPSTIME, 3);
					oks = 1;
					break;
				}
				else if(GarazsInfo[h][hHaz]>NINCS)
				{
					if(Admin(i,1))
						format(_tmpString, 128, "~w~Class gar˜zs %d.~n~˜ra:~g~%s FT~n~~w~Csak %d h˜z tulaj˜nak. Megvžtele:/buyhazgarazs ((id: %d))",h,FormatNumber( GarazsInfo[h][hAra] , 0, ',' ),GarazsInfo[h][hHaz],h);
					else
						format(_tmpString, 128, "~w~Class gar˜zs %d.~n~˜ra:~g~%s FT~n~~w~Csak %d h˜z tulaj˜nak. Megvžtele:/buyhazgarazs",h,FormatNumber( GarazsInfo[h][hAra] , 0, ',' ),GarazsInfo[h][hHaz]);
					GameTextForPlayer(i, _tmpString, CUSTOMPICKUPSTIME, 3);
					oks = 1;
					break;

				}
				else
				{
					format(_tmpString, 128, "~w~Class garazs %d.~n~Ara:~g~%s FT~n~~w~Garazs megvetele:/buygarazs",h,FormatNumber( GarazsInfo[h][hAra] , 0, ',' ));
					GameTextForPlayer(i, _tmpString, CUSTOMPICKUPSTIME, 3);
					oks = 1;
					break;
				}
			}
		}
		if(oks) continue;

		for(new h = 0; h < sizeof(BizzInfo); h++)
		{
			if(tmpcar != -1 && IsATruck(tmpcar) && PlayerToPoint(10.0, i, BizzInfo[h][bEntranceX], BizzInfo[h][bEntranceY], BizzInfo[h][bEntranceZ]))
			{
				format(_tmpString, 128, "~w~%s~n~~r~Products Required~w~: %d~n~~y~Price per Product: ~w~: %dFT~n~~g~Funds: ~w~: %dFT",BizzInfo[h][bMessage],(BizzInfo[h][bMaxProducts]-BizzInfo[h][bProducts]),BizzInfo[h][bPriceProd],BizzInfo[h][bTill]);
				GameTextForPlayer(i, _tmpString, CUSTOMPICKUPSTIME, 3);
				oks = 1;
				break;
			}
			if(PlayerToPoint(2.0, i, BizzInfo[h][bEntranceX], BizzInfo[h][bEntranceY], BizzInfo[h][bEntranceZ]))
			{
				if(BizzInfo[h][bOwned] == 1)
				{
					if(h == BIZ_LOTER)
					{
						format(_tmpString, 128, "~w~%s~w~~n~Tulaj: %s~n~M˜sodtulaj: %s~n~Belžp§ : ~g~%dFT ~n~Belžpžshez /l§tžr",BizzInfo[h][bMessage],BizzInfo[h][bOwner],BizzInfo[h][bExtortion],BizzInfo[h][bEntranceCost]);
					}
					else if(h == BIZ_PB)
					{
						format(_tmpString, 128, "~w~%s~w~~n~Tulaj: %s~n~M˜sodtulaj: %s~n~Belžp§ : ~g~%dFT ~n~/pb vagy /kikžpz§",BizzInfo[h][bMessage],BizzInfo[h][bOwner],BizzInfo[h][bExtortion],BizzInfo[h][bEntranceCost]);
					}
					else	
						format(_tmpString, 128, "~w~%s~w~~n~Tulaj: %s~n~M˜sodtulaj: %s~n~Belžp§ : ~g~%dFT ~n~Belžpžshez /enter",BizzInfo[h][bMessage],BizzInfo[h][bOwner],BizzInfo[h][bExtortion],BizzInfo[h][bEntranceCost]);
				}
				else
					format(_tmpString, 128, "~w~%s~w~~n~Ez a biznisz elado!~n~Ara: ~g~%s FT ~n~Biznisz megvetele:/buybiz",BizzInfo[h][bMessage],FormatNumber( BizzInfo[h][bBuyPrice] , 0, ',' ),BizzInfo[h][bLevelNeeded]);
				GameTextForPlayer(i, _tmpString, CUSTOMPICKUPSTIME, 3);
				oks = 1;
				break;
			}
		}
		if(oks) continue;

		if (GetPlayerState(i) == 1 && PlayerToPoint(2.0, i, 362.639312, 169.937469, 1025.789062) && GetPlayerInterior(i) == 3)
		{
			GameTextForPlayer(i, "~y~Munkafelvev§ hely~n~Munkafelvžtel: /munka", CUSTOMPICKUPSTIME, 5);
			continue;
		}
		else if (GetPlayerState(i) == 1 && PlayerToPoint(2.0, i, 2525.047119, -1289.786499, 1048.289062) && GetPlayerInterior(i) == 2)
		{
			GameTextForPlayer(i, "~y~Illegalis munkafelvevo hely~n~Munkafelvetel: /munka", CUSTOMPICKUPSTIME, 5);
			continue;
		}
	}
	return 1;
}