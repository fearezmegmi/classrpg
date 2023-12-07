#define WHITE   -1

if(egyezik(cmd, "/anim"))
{
	new anim_string[1800];
	
	SendClientMessage(playerid, -1, "_____________________________________");
	SendClientMessage(playerid, -1, "__________Karakter Animációk_________");
	SendClientMessage(playerid, -1, "[Ülés/Lazulás] /msit /fsit /sit [1-2] /lay [1-3]");
	SendClientMessage(playerid, -1, "[Jelzések] /gangsign [1-5] /wave");
	SendClientMessage(playerid, -1, "[Kommunikáció] /chat [1-9] /deal [1-2]");
	SendClientMessage(playerid, -1, "[Kommunikáció] /yes /greet /thankyou /invite1 /invite2");
	SendClientMessage(playerid, -1, "[Kommunikáció] /gang1 /gang2 /gang3 /cry1 /cry2 /fucku");
	SendClientMessage(playerid, -1, "[Kommunikáció] /lookout /chant /angry /ghand1 /ghand2");
	SendClientMessage(playerid, -1, "[Fizikai Akciók] /box /akick /bat1 /bat2 /taichi");
	
	strcat(anim_string, "| /crack | /handsup | /slapass | /seat | /drunk | /laugh |\n");
	strcat(anim_string, "| /plant | /vomit | | /reload | /lift | /cover | /put |\n");
	strcat(anim_string, "| /cpr | /hitchhike  | /drink | /tired | /throw | /checkout |\n");
	strcat(anim_string, "| /pee | /cellin  | /cellout | /shakehead | /benddown | \n");
	strcat(anim_string, "| /bj | /bj2 | /bj3 | /bj4 | /piss | /follow | /greet |\n");
	strcat(anim_string, "| /stand | /hitch | /bitchslap /kiss1 | /chairsit |\n");
	strcat(anim_string, "| /slapped | /skate | /gwalk | /gwalk2 | /limp | /eatsit |\n");
	strcat(anim_string, "| /celebrate | /win | /win2 | /yes | /thankyou | /invite1 |\n");
	strcat(anim_string, "| /invite2 | /celebrate2 | /scratch | /bomb | /getarrested |\n");
	strcat(anim_string, "| /lookout | /robman | /eat | /wave | /smokem | /smokef |\n");
	strcat(anim_string, "| /msit | /fsit | /fucku | /taichi | /relax | /bat1 | /bat2 |\n");
	strcat(anim_string, "| /bat3 | /bat4 | /bat5 | /nod | /gang1 | /gang2 | /gang3 |\n");
	strcat(anim_string, "| /gang4 | /gang5 | /gang6 | /gang7 | /cry1 | /cry2 | /bed1 |\n");
	strcat(anim_string, "| /bed2 | /bed3 | /bed4 | /kiss2 | /kiss3 | /kiss4 | /kiss5 |\n");
	strcat(anim_string, "| /kiss6 | /kiss7 | /kiss8 | /carsit | /carsit2 | /fwalk |\n");
	strcat(anim_string, "| /mwalk | /stretch |/chant | /angry | /crack2 | /ghand1 |\n");
	strcat(anim_string, "| /ghand2 | /ghand3 | /ghand4 | /ghand5 | /exhausted | /carsmoke |\n");
	strcat(anim_string, "| /getup | /basket1 | /basket2 | /basket3 | /basket4 | /basket5 |\n");
	strcat(anim_string, "| /basket6 | /akick | /box | /cockgun | /bar1 | /bar2 | /bar3 |\n");
	strcat(anim_string, "| /bar4 | /lay2 | /liftup | /putdown | /joint | /die | /die2\n");
	strcat(anim_string, "\n \n");
	strcat(anim_string, "| /smoke [1-2] | /lean [1-2] | /dance [1-15] | /rap [1-3] | /gangsign [1-5] |\n");
	strcat(anim_string, "| /strip [1-7] | /lay [1-3] | /sit [1-2] | /aim [1-7] | /fall [1-6] | /injured [1-2] |\n");
	strcat(anim_string, "| /chat [1-9] | /ball [1-7] | /friskanim [1-2] | /deal [1-2] | /crossarms [1-5] |\n");
	//strcat(anim_string, "| /chat [1-9] | /ball [1-7] | /friskanim [1-2] | /deal [1-2] | /crossarms [1-5] |\n");
	///respond [yes/no]
	
	ShowPlayerDialog(playerid, 1, DIALOG_STYLE_LIST, "Egyéb Animációk", anim_string, "O", "K");
	
	
	return 1;
}

/////////////////////////////////////////////////////////////////////ANIMS WITHOUT PARAMETER/////////////////////////////////////////////////////////////////////

if(egyezik(cmd, "/pee"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"PAULNMAC","Piss_loop", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/cellin"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	SetPlayerSpecialAction(playerid,SPECIAL_ACTION_USECELLPHONE);
	return 1;
}

if(egyezik(cmd, "/cellout"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	SetPlayerSpecialAction(playerid,SPECIAL_ACTION_STOPUSECELLPHONE);
	return 1;
}

if(egyezik(cmd, "/crack"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
    ApplyAnimation(playerid, "CRACK", "crckdeth2", 4.0,0,0,0,1,1);
	return 1;
}

if(egyezik(cmd, "/handsup"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid, "ROB_BANK", "SHP_HandsUp_Scr", 4.0,0,0,0,1,1);
	return 1;
}

if(egyezik(cmd, "/slapass"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"SWEET","sweet_ass_slap", 4.0,0,0,0,1,1);
	return 1;
}

if(egyezik(cmd, "/seat"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"PED","SEAT_idle", 4.0,0,0,0,1,1);
	return 1;
}

if(egyezik(cmd, "/drunk"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
    ApplyAnimation(playerid,"PED","WALK_DRUNK", 4.0,0,0,0,1,1);
	return 1;
}

if(egyezik(cmd, "/laugh"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid, "RAPPING", "Laugh_01", 4.0,0,0,0,1,1);
	return 1;
}

if(egyezik(cmd, "/cpr"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"MEDIC","CPR", 4.0,0,0,0,1,1);
	return 1;
}

if(egyezik(cmd, "/hitchhike"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"MISC","Hiker_Pose", 4.0,0,0,0,1,1);
	return 1;
}

if(egyezik(cmd, "/plant"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0,0,0,0,1,1);
	return 1;
}

if(egyezik(cmd, "/vomit"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid, "FOOD", "EAT_Vomit_P", 4.0,0,0,0,1,1);
	return 1;
}

if(egyezik(cmd, "/drink"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
    ApplyAnimation(playerid, "GANGS", "drnkbr_prtl", 4.0,0,0,0,1,1);
    return 1;
}

if(egyezik(cmd, "/tired"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"FAT","IDLE_tired", 4.0,0,0,0,1,1);
	return 1;
}

if(egyezik(cmd, "/reload"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid, "SILENCED", "Silence_reload", 4.0,0,0,0,1,1);
	return 1;
}

if(egyezik(cmd, "/throw"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid, "GRENADE", "WEAPON_throw", 4.0,0,0,0,1,1);
	return 1;
}

if(egyezik(cmd, "/lift"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid, "CARRY", "liftup", 4.0,0,0,0,1,1);
	return 1;
}

if(egyezik(cmd, "/put"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid, "CARRY", "putdwn", 4.0,0,0,0,1,1);
	return 1;
}

if(egyezik(cmd, "/cover"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid, "ped", "cower", 3.0, 1, 0, 0, 0, 1);
	return 1;
}

if(egyezik(cmd, "/bj"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"BLOWJOBZ","BJ_COUCH_START_P", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/bj2"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"BLOWJOBZ","BJ_COUCH_START_W", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/bj3"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"BLOWJOBZ","BJ_COUCH_LOOP_P", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/bj4"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"BLOWJOBZ","BJ_COUCH_LOOP_W", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/piss"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	SetPlayerSpecialAction(playerid, 68);
	return 1;
}
if(egyezik(cmd, "/follow"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"WUZI","Wuzi_follow", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/greet"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"WUZI","Wuzi_Greet_Wuzi", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/stand"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"WUZI","Wuzi_stand_loop", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/hitch"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"MISC","Hiker_Pose", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/bitchslap"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"MISC","bitchslap", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/kiss1"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"KISSING","gift_give", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/chairsit"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"PED","SEAT_idle", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/slapped"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"SWEET","ho_ass_slapped", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/skate"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"SKATE","skate_run", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/gwalk"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
 	ApplyAnimation(playerid,"PED","WALK_gang1", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/gwalk2"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"PED","WALK_gang2", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/limp"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"PED","WALK_old", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/eatsit"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"FOOD","FF_Sit_Loop", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/celebrate"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"benchpress","gym_bp_celebrate", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/win"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"CASINO","cards_win", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/win2"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"CASINO","Roulette_win", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/yes"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"CLOTHES","CLO_Buy", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/thankyou"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"FOOD","SHP_Thank", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/invite1"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"GANGS","Invite_Yes", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/invite2"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"GANGS","Invite_No", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/celebrate2"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"GYMNASIUM","gym_tread_celebrate", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/scratch"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"MISC","Scratchballs_01", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/bomb"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ClearAnimations(playerid);
	ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0,0,0,0,1,1); // Place Bomb
	return 1;
}
if(egyezik(cmd, "/getarrested"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"ped", "ARRESTgun", 4.0,0,0,0,1,1); // Gun Arrest
	return 1;
}
if(egyezik(cmd, "/lookout"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid, "SHOP", "ROB_Shifty", 4.0,0,0,0,1,1); // Rob Lookout
	return 1;
}
if(egyezik(cmd, "/robman"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid, "SHOP", "ROB_Loop_Threat", 4.0,0,0,0,1,1); // Rob
	return 1;
}
if(egyezik(cmd, "/eat")){
 	ApplyAnimation(playerid, "FOOD", "EAT_Burger", 4.0,0,0,0,1,1); // Eat Burger
	return 1;
}
if(egyezik(cmd, "/wave"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
 	ApplyAnimation(playerid, "ON_LOOKERS", "wave_loop", 4.0,0,0,0,1,1); // Wave
	return 1;
}
if(egyezik(cmd, "/smokem"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
 	ApplyAnimation(playerid,"SMOKING", "M_smklean_loop", 4.0,0,0,0,1,1); // Smoke
	return 1;
}
if(egyezik(cmd, "/smokef"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
 	ApplyAnimation(playerid, "SMOKING", "F_smklean_loop", 4.0,0,0,0,1,1); // Female Smoking
	return 1;
}
if(egyezik(cmd, "/msit"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
 	ApplyAnimation(playerid,"BEACH", "ParkSit_M_loop", 4.0,0,0,0,1,1); // Male Sit
	return 1;
}
if(egyezik(cmd, "/fsit"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
 	ApplyAnimation(playerid,"BEACH", "ParkSit_W_loop", 4.0,0,0,0,1,1); // Female Sit
	return 1;
}
if(egyezik(cmd, "/fucku"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"PED","fucku", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/taichi"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"PARK","Tai_Chi_Loop", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/relax"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"BEACH","Lay_Bac_Loop", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/bat1"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"BASEBALL","Bat_IDLE", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/bat2"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"BASEBALL","Bat_M", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/bat3"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"BASEBALL","BAT_PART", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/bat4"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"CRACK","Bbalbat_Idle_01", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/bat5"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"CRACK","Bbalbat_Idle_02", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/nod"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"COP_AMBIENT","Coplook_nod", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/gang1"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"GANGS","hndshkaa", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/gang2"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"GANGS","hndshkba", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/gang3"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"GANGS","hndshkca", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/gang4"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"GANGS","hndshkcb", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/gang5"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"GANGS","hndshkda", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/gang6"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"GANGS","hndshkea", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/gang7"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"GANGS","hndshkfa", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/cry1"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"GRAVEYARD","mrnF_loop", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/cry2"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"GRAVEYARD","mrnM_loop", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/bed1"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"INT_HOUSE","BED_In_L", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/bed2"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"INT_HOUSE","BED_In_R", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/bed3"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"INT_HOUSE","BED_Loop_L", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/bed4"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"INT_HOUSE","BED_Loop_R", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/kiss2"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"BD_FIRE","Grlfrd_Kiss_03", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/kiss3"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"KISSING","Grlfrd_Kiss_01", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/kiss4"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"KISSING","Grlfrd_Kiss_02", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/kiss5"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"KISSING","Grlfrd_Kiss_03", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/kiss6"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"KISSING","Playa_Kiss_01", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/kiss7"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"KISSING","Playa_Kiss_02", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/kiss8"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"KISSING","Playa_Kiss_03", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/carsit"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"CAR","Tap_hand", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/carsit2"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"LOWRIDER","Sit_relaxed", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/fwalk"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"ped","WOMAN_walksexy", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/mwalk"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"ped","WALK_player", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/stretch"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"PLAYIDLES","stretch", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/chant"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"RIOT","RIOT_CHANT", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/angry"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"RIOT","RIOT_ANGRY", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/crack2"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid, "CRACK", "crckidle2", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/ghand1"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"GHANDS","gsign1LH", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/ghand2"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"GHANDS","gsign2LH", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/ghand3"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"GHANDS","gsign3LH", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/ghand4"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"GHANDS","gsign4LH", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/ghand5"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"GHANDS","gsign5LH", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/exhausted"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"FAT","IDLE_tired", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/carsmoke"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"PED","Smoke_in_car", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/getup"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"PED","getup", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/basket1"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"BSKTBALL","BBALL_def_loop", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/basket2"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"BSKTBALL","BBALL_idleloop", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/basket3"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"BSKTBALL","BBALL_pickup", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/basket4"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"BSKTBALL","BBALL_Jump_Shot", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/basket5"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"BSKTBALL","BBALL_Dnk", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/basket6"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"BSKTBALL","BBALL_run", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/akick"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"FIGHT_E","FightKick", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/box"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"GYMNASIUM","gym_shadowbox", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/cockgun"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid, "SILENCED", "Silence_reload", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/bar1"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid, "BAR", "Barcustom_get", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/bar2"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid, "BAR", "Barcustom_order", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/bar3"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid, "BAR", "Barserve_give", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/bar4"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid, "BAR", "Barserve_glass", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/lay2"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"BEACH", "SitnWait_loop_W", 4.0,0,0,0,1,1); // Lay down
	return 1;
}
if(egyezik(cmd, "/liftup"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid, "CARRY", "liftup", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/putdown"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid, "CARRY", "putdwn", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/joint"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"GANGS","smkcig_prtl", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/die"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid,"KNIFE","KILL_Knife_Ped_Die", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/shakehead"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid, "MISC", "plyr_shkhead", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/die2"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid, "PARACHUTE", "FALL_skyDive_DIE", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/benddown"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid, "BAR", "Barserve_bottle", 4.0,0,0,0,1,1);
	return 1;
}
if(egyezik(cmd, "/checkout"))
{
	if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	ApplyAnimation(playerid, "GRAFFITI", "graffiti_Chkout", 4.0,0,0,0,1,1);
	return 1;
}

/////////////////////////////////////////////////////////////////////ANIMS WITH PARAMETER/////////////////////////////////////////////////////////////////////

if(egyezik(cmd, "/crossarms"))
{
	new aimid;
	if(sscanf(params, "i", aimid)) return SendClientMessage(playerid, WHITE, "Használat: /crossarms [1-5]");
	else
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		switch(aimid)
		{
		    case 1: ApplyAnimation(playerid, "COP_AMBIENT", "Coplook_loop", 4.0,0,0,0,1,1);
            case 2: ApplyAnimation(playerid, "DEALER", "DEALER_IDLE", 4.0,0,0,0,1,1);
            case 3: ApplyAnimation(playerid, "DEALER", "DEALER_IDLE_01", 4.0,0,0,0,1,1);
            case 4: ApplyAnimation(playerid, "DEALER", "DEALER_IDLE_02", 4.0,0,0,0,1,1);
            case 5: ApplyAnimation(playerid, "DEALER", "DEALER_IDLE_03", 4.0,0,0,0,1,1);
            default: SendClientMessage(playerid, WHITE, "Használat: /crossarms [1-5]");
		}
	}
	return 1;
}

if(egyezik(cmd, "/lay"))
{
	new aimid;
	if(sscanf(params, "i", aimid)) return SendClientMessage(playerid, WHITE, "Használat: /lay [1-3]");
	else
	{
	    if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	    switch(aimid)
	    {
	        case 1: ApplyAnimation(playerid,"BEACH", "bather", 4.0,0,0,0,1,1);
	        case 2: ApplyAnimation(playerid,"BEACH", "SitnWait_loop_W", 4.0,0,0,0,1,1);
	        case 3: ApplyAnimation(playerid,"BEACH","Lay_Bac_Loop", 4.0,0,0,0,1,1);
	        default: SendClientMessage(playerid, WHITE, "Használat: /lay [1-3]");
		}
	}
	return 1;
}

if(egyezik(cmd, "/sit"))
{
	new aimid;
	if(sscanf(params, "i", aimid)) return SendClientMessage(playerid, WHITE, "Használat: /sit [1-2]");
	else
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		switch(aimid)
		{
			case 1: ApplyAnimation(playerid, "ON_LOOKERS", "wave_loop", 4.0,0,0,0,1,1);
			case 2: ApplyAnimation(playerid,"BEACH", "ParkSit_W_loop", 4.0,0,0,0,1,1);
			default: SendClientMessage(playerid, WHITE, "Használat: /sit [1-2]");
		}
	}
	return 1;
}

if(egyezik(cmd, "/aim"))
{
	new aimid;
	if(sscanf(params, "i", aimid)) return SendClientMessage(playerid, WHITE, "Használat: /aim [1-7]");
	else
	{
	    if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	    switch(aimid)
	    {
 			case 1: ApplyAnimation(playerid,"PED","gang_gunstand",4.0,1,1,1,1,1);
            case 2: ApplyAnimation(playerid, "SHOP", "SHP_Gun_Aim", 4.0,0,0,0,1,1);
            case 3: ApplyAnimation(playerid,"PED","Driveby_L",4.0, 0, 1, 1, 1, -1);
            case 4: ApplyAnimation(playerid,"PED","Driveby_R",4.0, 0, 1, 1, 1, -1);
            case 5: ApplyAnimation(playerid,"ped", "ARRESTgun", 4.0,0,0,0,1,1);
            case 6: ApplyAnimation(playerid, "SHOP", "ROB_Loop_Threat", 4.0,0,0,0,1,1);
            case 7: ApplyAnimation(playerid, "PED", "GUN_STAND", 4.0,0,0,0,1,1);
            default: SendClientMessage(playerid, WHITE, "Használat: /aim [1-7]");
		}
	}
	return 1;
}

if(egyezik(cmd, "/fall"))
{
	new aimid;
	if(sscanf(params, "i", aimid)) return SendClientMessage(playerid, WHITE, "Használat: /fall [1-6]");
	else
	{
	    if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	    switch(aimid)
	    {
 			case 1: ApplyAnimation(playerid, "ped", "FLOOR_hit", 4.0,0,0,0,1,1);
		    case 2: ApplyAnimation(playerid, "ped", "FLOOR_hit_f", 4.0,0,0,0,1,1);
		    case 3: ApplyAnimation(playerid, "ped", "KO_shot_front", 4.0,0,0,0,1,1);
		    case 4: ApplyAnimation(playerid, "ped", "KO_shot_stom", 4.0,0,0,0,1,1);
            case 5: ApplyAnimation(playerid, "ped", "BIKE_fall_off", 4.0,0,0,0,1,1);
			case 6: ApplyAnimation(playerid, "FINALE", "FIN_Land_Die", 4.0,0,0,0,1,1);
            default: SendClientMessage(playerid, WHITE, "Használat: /fall [1-6]");
		}
	}
	return 1;
}

if(egyezik(cmd, "/gangsign"))
{
	new aimid;
	if(sscanf(params, "i", aimid)) return SendClientMessage(playerid, WHITE, "Használat: /gangsign [1-5]");
	else
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		switch(aimid)
		{
 			case 1: ApplyAnimation(playerid,"GHANDS","gsign1", 4.0,0,0,0,1,1);
            case 2: ApplyAnimation(playerid,"GHANDS","gsign2", 4.0,0,0,0,1,1);
            case 3: ApplyAnimation(playerid,"GHANDS","gsign3", 4.0,0,0,0,1,1);
            case 4: ApplyAnimation(playerid,"GHANDS","gsign4", 4.0,0,0,0,1,1);
            case 5: ApplyAnimation(playerid,"GHANDS","gsign5", 4.0,0,0,0,1,1);
            default: SendClientMessage(playerid, WHITE, "Használat: /gangsign [1-5]");
		}
	}
	return 1;
}

if(egyezik(cmd, "/injured"))
{
	new aimid;
	if(sscanf(params, "i", aimid)) return SendClientMessage(playerid, WHITE, "Használat: /injured [1-2]");
	else
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		switch(aimid)
		{
 			case 1: ApplyAnimation(playerid,"SWEET","Sweet_injuredloop", 4.0,0,0,0,1,1);
            case 2: ApplyAnimation(playerid,"SWAT","gnstwall_injurd", 4.0,0,0,0,1,1);
            default: SendClientMessage(playerid, WHITE, "Használat: /injured [1-2]");
		}
	}
	return 1;
}

if(egyezik(cmd, "/respond"))
{
	new response[4];
	if(sscanf(params, "s[4]", response)) return SendClientMessage(playerid, WHITE, "Használat: /respond [yes/no]");
	else
	{
		if(strcmp(response, "yes", true) == 0)
		{
		    if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		    ApplyAnimation(playerid,"GANGS","Invite_Yes", 4.0,0,0,0,1,1);
		    return 1;
		}
		else if(strcmp(response, "no", true) == 0)
		{
		    if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		    ApplyAnimation(playerid,"GANGS","Invite_No", 4.0,0,0,0,1,1);
		    return 1;
		}
		else return SendClientMessage(playerid, WHITE, "Használat: /respond [yes/no]");
	}
}

if(egyezik(cmd, "/friskanim"))
{
	new aimid;
	if(sscanf(params, "i", aimid)) return SendClientMessage(playerid, WHITE, "Használat: /friskanim [1-2]");
	else
	{
	    if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	    switch(aimid)
		{
		    case 1: ApplyAnimation(playerid, "POLICE", "plc_drgbst_01", 4.0,0,0,0,1,1);
            case 2: ApplyAnimation(playerid, "POLICE", "plc_drgbst_02", 4.0,0,0,0,1,1);
            default: SendClientMessage(playerid, WHITE, "Használat: /friskanim [1-2]");
		}
	}
	return 1;
}

if(egyezik(cmd, "/deal"))
{
	new aimid;
	if(sscanf(params, "i", aimid)) return SendClientMessage(playerid, WHITE, "Használat: /deal [1-2]");
	else
	{
	    if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	    switch(aimid)
		{
		    case 1: ApplyAnimation(playerid, "DEALER", "DEALER_DEAL", 4.0,0,0,0,1,1);
            case 2: ApplyAnimation(playerid,"DEALER","DRUGS_BUY", 4.0,0,0,0,1,1);
            default: SendClientMessage(playerid, WHITE, "Használat: /deal [1-2]");
		}
	}
	return 1;
}

if(egyezik(cmd, "/chat"))
{
	new aimid;
	if(sscanf(params, "i", aimid)) return SendClientMessage(playerid, WHITE, "Használat: /chat [1-9]");
	else
	{
	    if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	    switch(aimid)
		{
		    case 1: ApplyAnimation(playerid,"PED","IDLE_CHAT", 4.0,0,0,0,1,1);
            case 2: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkA", 4.0,0,0,0,1,1);
            case 3: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkB", 4.0,0,0,0,1,1);
            case 4: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkC", 4.0,0,0,0,1,1);
            case 5: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkD", 4.0,0,0,0,1,1);
            case 6: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkE", 4.0,0,0,0,1,1);
            case 7: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkF", 4.0,0,0,0,1,1);
            case 8: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkG", 4.0,0,0,0,1,1);
            case 9: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkH", 4.0,0,0,0,1,1);
            default: SendClientMessage(playerid, WHITE, "Használat: /chat [1-9]");
		}
	}
	return 1;
}

if(egyezik(cmd, "/ball"))
{
	new aimid;
	if(sscanf(params, "i", aimid)) return SendClientMessage(playerid, WHITE, "Használat: /ball [1-7]");
	else
	{
	    if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
	    switch(aimid)
		{
		    case 1: ApplyAnimation(playerid,"BSKTBALL","BBALL_def_loop", 4.0,0,0,0,1,1);
            case 2: ApplyAnimation(playerid,"BSKTBALL","BBALL_idleloop", 4.0,0,0,0,1,1);
            case 3: ApplyAnimation(playerid,"BSKTBALL","BBALL_pickup", 4.0,0,0,0,1,1);
            case 4: ApplyAnimation(playerid,"BSKTBALL","BBALL_Jump_Shot", 4.0,0,0,0,1,1);
            case 5: ApplyAnimation(playerid,"BSKTBALL","BBALL_Dnk", 4.0,0,0,0,1,1);
            case 6: ApplyAnimation(playerid,"BSKTBALL","BBALL_run", 4.0,0,0,0,1,1);
            case 7: ApplyAnimation(playerid,"BSKTBALL","BBALL_walk", 4.0,0,0,0,1,1);
            default: SendClientMessage(playerid, WHITE, "Használat: /ball [1-7]");
		}
	}
	return 1;
}

if(egyezik(cmd, "/smoke"))
{
	new aimid;
	if(sscanf(params, "i", aimid)) return SendClientMessage(playerid, WHITE, "Használat: /smoke [1-2]");
	else
	{
	    if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
        switch(aimid)
		{
		    case 1: ApplyAnimation(playerid,"SMOKING", "M_smklean_loop", 4.0,0,0,0,1,1);
            case 2: ApplyAnimation(playerid,"GANGS","smkcig_prtl", 4.0,0,0,0,1,1);
            default: SendClientMessage(playerid, WHITE, "Használat: /smoke [1-2]");
		}
	}
	return 1;
}

if(egyezik(cmd, "/lean"))
{
	new aimid;
	if(sscanf(params, "i", aimid)) return SendClientMessage(playerid, WHITE, "Használat: /lean [1-2]");
	else
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		switch(aimid)
		{
		    case 1: ApplyAnimation(playerid,"GANGS","leanIDLE", 4.0,0,0,0,1,1);
            case 2: ApplyAnimation(playerid,"MISC","Plyrlean_loop", 4.0,0,0,0,1,1);
            default: SendClientMessage(playerid, WHITE, "Használat: /lean [1-2]");
		}
	}
	return 1;
}

if(egyezik(cmd, "/dance"))
{
	new aimid;
	if(sscanf(params, "i", aimid)) return SendClientMessage(playerid, WHITE, "Használat: /dance [1-15]");
	else
	{
		if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
		switch(aimid)
		{
		    case 1: SetPlayerSpecialAction(playerid,SPECIAL_ACTION_DANCE1);
            case 2: SetPlayerSpecialAction(playerid,SPECIAL_ACTION_DANCE2);
            case 3: SetPlayerSpecialAction(playerid,SPECIAL_ACTION_DANCE3);
            case 4: SetPlayerSpecialAction(playerid,SPECIAL_ACTION_DANCE4);
            case 5: ApplyAnimation(playerid,"DANCING","bd_clap",4.0, 1, 0, 0, 1, 1);
            case 6: ApplyAnimation(playerid,"DANCING","DAN_Down_A",4.0, 1, 0, 0, 1, 1);
            case 7: ApplyAnimation(playerid,"DANCING","DAN_Left_A",4.0, 1, 0, 0, 1, 1);
            case 8: ApplyAnimation(playerid,"DANCING","DAN_Loop_A",4.0, 1, 0, 0, 1, 1);
            case 9: ApplyAnimation(playerid,"DANCING","DAN_Right_A",4.0, 1, 0, 0, 1, 1);
            case 10: ApplyAnimation(playerid,"DANCING","DAN_Up_A",4.0, 1, 0, 0, 1, 1);
            case 11: ApplyAnimation(playerid,"DANCING","dnce_M_a",4.0, 1, 0, 0, 1, 1);
            case 12: ApplyAnimation(playerid,"DANCING","dnce_M_b",4.0, 1, 0, 0, 1, 1);
            case 13: ApplyAnimation(playerid,"DANCING","dnce_M_c",4.0, 1, 0, 0, 1, 1);
            case 14: ApplyAnimation(playerid,"DANCING","dnce_M_d",4.0, 1, 0, 0, 1, 1);
            case 15: ApplyAnimation(playerid,"DANCING","dnce_M_e",4.0, 1, 0, 0, 1, 1);
            default: SendClientMessage(playerid, WHITE, "Használat: /dance [1-15]");
		}
	}
	return 1;
}

if(egyezik(cmd, "/rap"))
{
	new aimid;
	if(sscanf(params, "i", aimid)) return SendClientMessage(playerid, WHITE, "Használat: /rap [1-3]");
	else
	{
	    if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
        switch(aimid)
		{
		    case 1: ApplyAnimation(playerid,"RAPPING","RAP_A_Loop",4.0,1,1,1,1,1);
            case 2: ApplyAnimation(playerid,"RAPPING","RAP_B_Loop",4.0,1,1,1,1,1);
            case 3: ApplyAnimation(playerid,"RAPPING","RAP_C_Loop",4.0,1,1,1,1,1);
            default: SendClientMessage(playerid, WHITE, "Használat: /rap [1-3]");
		}
	}
	return 1;
}

if(egyezik(cmd, "/strip"))
{
	new aimid;
	if(sscanf(params, "i", aimid)) return SendClientMessage(playerid, WHITE, "Használat: /strip [1-7]");
	else
	{
	    if(NemHasznalhatAnimot(playerid)) return Msg(playerid, "Jelenleg nem használhatod ezt a parancsot!");
        switch(aimid)
		{
		    case 1: ApplyAnimation(playerid,"STRIP","strip_A",4.0,1,1,1,1,1);
            case 2: ApplyAnimation(playerid,"STRIP","strip_B",4.0,1,1,1,1,1);
            case 3: ApplyAnimation(playerid,"STRIP","strip_C",4.0,1,1,1,1,1);
            case 4: ApplyAnimation(playerid,"STRIP","strip_D",4.0,1,1,1,1,1);
            case 5: ApplyAnimation(playerid,"STRIP","strip_E",4.0,1,1,1,1,1);
            case 6: ApplyAnimation(playerid,"STRIP","strip_F",4.0,1,1,1,1,1);
            case 7: ApplyAnimation(playerid,"STRIP","strip_G",4.0,1,1,1,1,1);
            default: SendClientMessage(playerid, WHITE, "Használat: /strip [1-7]");
		}
	}
	return 1;
}