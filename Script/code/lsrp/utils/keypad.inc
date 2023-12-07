/*
INTERACTIVE TEXTDRAW KEYPAD SCRIPT BY MIKE (MP2)
*/



/* = CHANGELOG = */
/*
1.0 (27th of March 2011)
- Initial release


### TO-DO ###

- Add 'retry' parameter to CreateKeypad to allow multiple attempts

*/


/* ===[CONFIG]=== */

#define MAX_KEYPAD_KEY_LENGTH 10 // Max length for keypad key
#define KEYPAD_STAY_TIME 1000 // Time in miliseconds the keypad should stay on screen for after input (to show green/red light)

// Input types (for OnPlayerKeypadInput)
#define KEYPAD_INPUT_BAD 0 // Failed authorization
#define KEYPAD_INPUT_GOOD 1 // Successful authorization
#define KEYPAD_INPUT_CANCEL 2 // Called when ESC press to cancel keypad


// Macros
#define GetPlayerKeypad(%0) pKeypad[%0]


/* ===[VARIABLES, ARRAYS ETC.]=== */

new pKeypad[MAX_PLAYERS]; // Store the ID of the keypad that is open for a player
new pKeypadState[MAX_PLAYERS]; // 0=none 1=input 2=result
new pKeypadString[MAX_PLAYERS][MAX_KEYPAD_KEY_LENGTH+1]; // The string they have entered so far
new pKeypadKey[MAX_PLAYERS][MAX_KEYPAD_KEY_LENGTH+1]; // The key that is required for authorization

new Text:keypad_numbers[MAX_PLAYERS][10]; // Textdraws for the numbers
new Text:keypad_boxes[MAX_PLAYERS][12]; // + green and red box
new Text:keypad_background[MAX_PLAYERS]; // The grey background box


// Return codes for CreateKeypad
#define CREATEKEYPAD_RETURN_INVALID_ID 0 // ID must be 1+
#define CREATEKEYPAD_RETURN_NUM -1 // String is not a number sequence
#define CREATEKEYPAD_RETURN_INVALID_PLAYER -2 // 'playerid' not connected

/*
native CreateKeypad(playerid, keypadID, key[]);
native DestroyKeypad(playerid);
*/

// Forwards
forward OnPlayerKeypadInput(playerid, keypadID, type, key);

stock CreateKeypad(playerid, keypadID, key[])
{
	if(!IsPlayerConnected(playerid)) return CREATEKEYPAD_RETURN_INVALID_PLAYER;
	if(keypadID < 1) return CREATEKEYPAD_RETURN_INVALID_ID; // Returns -1 if invalid keypad ID. Must be 1+
	if(!keypad_IsNumeric(key)) return CREATEKEYPAD_RETURN_NUM; // Returns -2 if invalid key. Must be numbers only

	format(pKeypadKey[playerid], MAX_KEYPAD_KEY_LENGTH, "%s", key);
	pKeypad[playerid] = keypadID;
	printf("Keypad létrehozva! Jelszó: %s",key);
	if(!pKeypadState[playerid]) // No keypad already open, create the textdraws
	{
		keypad_background[playerid] = TextDrawCreate(570.000000, 280.000000, "_");
		TextDrawAlignment(keypad_background[playerid], 2);
		TextDrawBackgroundColor(keypad_background[playerid], 255);
		TextDrawFont(keypad_background[playerid], 2);
		TextDrawLetterSize(keypad_background[playerid], 0.319999, 14.799995);
		TextDrawColor(keypad_background[playerid], -1);
		TextDrawSetOutline(keypad_background[playerid], 0);
		TextDrawSetProportional(keypad_background[playerid], 1);
		TextDrawSetShadow(keypad_background[playerid], 0);
		TextDrawUseBox(keypad_background[playerid], 1);
		TextDrawBoxColor(keypad_background[playerid], -1852730422);
		TextDrawTextSize(keypad_background[playerid], 0.000000, 113.000000);
		
		new keypad_box_coords[][] = {
		{540, 290},
		{570, 320},
		{570, 290},
		{600, 290},
		{540, 320},
		{600, 320},
		{600, 350},
		{570, 350},
		{540, 350},
		{570, 380}
		};

		for(new i=0; i<10; i++)
		{
			keypad_boxes[playerid][i] = TextDrawCreate(keypad_box_coords[i][0], keypad_box_coords[i][1], "~N~~N~~N~");
			TextDrawAlignment(keypad_boxes[playerid][i], 2);
			TextDrawBackgroundColor(keypad_boxes[playerid][i], 255);
			TextDrawFont(keypad_boxes[playerid][i], 2);
			TextDrawLetterSize(keypad_boxes[playerid][i], 0.319999, 0.899999);
			TextDrawColor(keypad_boxes[playerid][i], -1);
			TextDrawSetOutline(keypad_boxes[playerid][i], 0);
			TextDrawSetProportional(keypad_boxes[playerid][i], 1);
			TextDrawSetShadow(keypad_boxes[playerid][i], 0);
			TextDrawUseBox(keypad_boxes[playerid][i], 1);
			TextDrawBoxColor(keypad_boxes[playerid][i], 255);
			TextDrawTextSize(keypad_boxes[playerid][i], 100.000000, 23.000000);
			TextDrawShowForPlayer(playerid, keypad_boxes[playerid][i]);
		}
		
		new keypad_num_coords[][] = {
		{570, 379},
		{540, 289},
		{570, 289},
		{600, 289},
		{540, 319},
		{570, 319},
		{600, 319},
		{540, 349},
		{570, 349},
		{600, 349}
		};

		for(new i=0; i<10; i++)
		{
			new numstr[2];
			format(numstr, 2, "%i", i);
			keypad_numbers[playerid][i] = TextDrawCreate(keypad_num_coords[i][0], keypad_num_coords[i][1], numstr);
			TextDrawAlignment(keypad_numbers[playerid][i], 2);
			TextDrawBackgroundColor(keypad_numbers[playerid][i], 255);
			TextDrawFont(keypad_numbers[playerid][i], 2);
			TextDrawLetterSize(keypad_numbers[playerid][i], 0.550000, 2.599998);
			TextDrawColor(keypad_numbers[playerid][i], -1);
			TextDrawSetOutline(keypad_numbers[playerid][i], 0);
			TextDrawSetProportional(keypad_numbers[playerid][i], 1);
			TextDrawSetShadow(keypad_numbers[playerid][i], 0);
			TextDrawTextSize(keypad_numbers[playerid][i], 23.000000, 23.000000);
			TextDrawSetSelectable(keypad_numbers[playerid][i], 1);
			TextDrawShowForPlayer(playerid, keypad_numbers[playerid][i]);
		}
	
	
		// Green and red boxes
		keypad_boxes[playerid][10] = TextDrawCreate(540.000000, 380.000000, "~N~~N~~N~");
		TextDrawAlignment(keypad_boxes[playerid][10], 2);
		TextDrawBackgroundColor(keypad_boxes[playerid][10], 255);
		TextDrawFont(keypad_boxes[playerid][10], 2);
		TextDrawLetterSize(keypad_boxes[playerid][10], 0.319999, 0.899999);
		TextDrawColor(keypad_boxes[playerid][10], -1);
		TextDrawSetOutline(keypad_boxes[playerid][10], 0);
		TextDrawSetProportional(keypad_boxes[playerid][10], 1);
		TextDrawSetShadow(keypad_boxes[playerid][10], 0);
		TextDrawUseBox(keypad_boxes[playerid][10], 1);
		TextDrawBoxColor(keypad_boxes[playerid][10], 1375731967);
		TextDrawTextSize(keypad_boxes[playerid][10], 0.000000, 23.000000);
	
		// Pressable green key
		keypad_boxes[playerid][11] = TextDrawCreate(600.000000, 380.000000, "~N~~N~~N~");
		TextDrawAlignment(keypad_boxes[playerid][11], 2);
		TextDrawBackgroundColor(keypad_boxes[playerid][11], 255);
		TextDrawFont(keypad_boxes[playerid][11], 2);
		TextDrawLetterSize(keypad_boxes[playerid][11], 0.319999, 0.899999);
		TextDrawColor(keypad_boxes[playerid][11], -1);
		TextDrawSetOutline(keypad_boxes[playerid][11], 0);
		TextDrawSetProportional(keypad_boxes[playerid][11], 1);
		TextDrawSetShadow(keypad_boxes[playerid][11], 0);
		TextDrawUseBox(keypad_boxes[playerid][11], 1);
		TextDrawBoxColor(keypad_boxes[playerid][11], 5374207);
		TextDrawTextSize(keypad_boxes[playerid][11], 23.000000, 23.000000);
		
		TextDrawShowForPlayer(playerid, keypad_boxes[playerid][10]);
		TextDrawShowForPlayer(playerid, keypad_boxes[playerid][11]);
		TextDrawShowForPlayer(playerid, keypad_background[playerid]);
		
		SelectTextDraw(playerid, 0x00FF00FF);
		
		pKeypadState[playerid] = 1;
	}

	pKeypadString[playerid] = "";
	return 1;
}

stock DestroyKeypad(playerid)
{
	if(!IsPlayerConnected(playerid)) return CREATEKEYPAD_RETURN_INVALID_PLAYER;
	TextDrawDestroy(keypad_background[playerid]);
	for(new e=0; e<10; e++) TextDrawDestroy(keypad_numbers[playerid][e]);
	for(new e=0; e<12; e++) TextDrawDestroy(keypad_boxes[playerid][e]);
	pKeypadState[playerid] = 0;
	CancelSelectTextDraw(playerid);
	return 1;
}

public OnPlayerConnect(playerid)
{
	pKeypadState[playerid] = 0;
	return CallLocalFunction("keypad_OnPlayerConnect", "i", playerid);
}

#if defined _ALS_OnPlayerConnect
    #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect keypad_OnPlayerConnect
forward keypad_OnPlayerConnect(playerid);

public OnPlayerDisconnect(playerid, reason)
{
	if(pKeypadState[playerid]) DestroyKeypad(playerid);
	return CallLocalFunction("keypad_OnPlayerDisconnect", "ii", playerid, reason);
}

#if defined _ALS_OnPlayerDisconnect
    #undef OnPlayerDisconnect
#else
    #define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect keypad_OnPlayerDisconnect
forward keypad_OnPlayerDisconnect(playerid, reason);

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
	if(pKeypadState[playerid] == 1)
	{
	    if(clickedid == Text:INVALID_TEXT_DRAW)
		{
		    PlayerPlaySound(playerid, 21001, 0, 0, 0);
			CallLocalFunction("OnPlayerKeypadInput", "iiii", playerid, pKeypad[playerid], KEYPAD_INPUT_CANCEL, strval(pKeypadKey[playerid]));
			return DestroyKeypad(playerid);
		}
	    for(new i=0; i<10; i++)
	    {
	        if(clickedid == keypad_numbers[playerid][i])
	        {
	            new numstr[2];
	            format(numstr, 2, "%i", i);
	            strins(pKeypadString[playerid], numstr, strlen(pKeypadString[playerid]));
	            if(strlen(pKeypadString[playerid]) == strlen(pKeypadKey[playerid])) // Reached check point
	            {
	                if(strcmp(pKeypadString[playerid], pKeypadKey[playerid]) != 0) // Not the correct key
	                {
			    		PlayerPlaySound(playerid, 21001, 0, 0, 0);
						
						new keypad_memory = pKeypad[playerid];
						pKeypad[playerid] = 0;
						
			    		// Highlight red box
 	        			TextDrawBoxColor(keypad_boxes[playerid][10], 0xFF0000FF);
	        			TextDrawHideForPlayer(playerid, keypad_boxes[playerid][10]);
	        			TextDrawShowForPlayer(playerid, keypad_boxes[playerid][10]);
	        			pKeypadState[playerid] = 2; // Still got keypad open, but don't allow more input
	        			CancelSelectTextDraw(playerid);
			    		
			    		CallLocalFunction("OnPlayerKeypadInput", "iiii", playerid, keypad_memory, KEYPAD_INPUT_BAD, strval(pKeypadString[playerid]));
			    		SetTimerEx("keypad_destroy", KEYPAD_STAY_TIME, false, "i", playerid);
						return 1;
					}
					else // Success!
					{
	        			PlayerPlaySound(playerid, 21002, 0, 0, 0);
	        			TextDrawBoxColor(keypad_boxes[playerid][11], 0x00FF00FF);
	        			TextDrawHideForPlayer(playerid, keypad_boxes[playerid][11]);
	        			TextDrawShowForPlayer(playerid, keypad_boxes[playerid][11]);
	        			pKeypadState[playerid] = 2; // Still got keypad open, but don't allow more input
	        			CancelSelectTextDraw(playerid);
						new keypad_memory = pKeypad[playerid];
						pKeypad[playerid] = 0;
	        			SetTimerEx("keypad_destroy", KEYPAD_STAY_TIME, false, "i", playerid);
	        			CallLocalFunction("OnPlayerKeypadInput", "iiii", playerid, keypad_memory, KEYPAD_INPUT_GOOD, strval(pKeypadString[playerid]));
						return 1;
					}
				}
	            PlayerPlaySound(playerid, 21000, 0, 0, 0);
	            return 1;
	        }
	    }
	}
	return CallLocalFunction("myinc_OnPlayerClickTextDraw", "ii", playerid, _:clickedid);
}

#if defined _ALS_OnPlayerClickTextDraw
    #undef OnPlayerClickTextDraw
#else
    #define _ALS_OnPlayerClickTextDraw
#endif
#define OnPlayerClickTextDraw myinc_OnPlayerClickTextDraw
forward myinc_OnPlayerClickTextDraw(playerid, Text:clickedid);

forward keypad_destroy(playerid);
public keypad_destroy(playerid)
{
	DestroyKeypad(playerid);
	return 1;
}

stock keypad_IsNumeric(const isthisnumeric[])
{
	if(!strlen(isthisnumeric)) return 0;
	for(new i = 0; i < strlen(isthisnumeric); i++)
	{
		if(isthisnumeric[i] > '9' || isthisnumeric[i] < '0') return 0;
	}
	return 1;
}