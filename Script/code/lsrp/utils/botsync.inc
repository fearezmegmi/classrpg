/*----------------------------------------------------------------------------*-
					==========================
					 NPC script communication
					==========================
Description:
	This code provides a system to communicate with bots via files.  It uses
	locks to ensure only one script may communicate at once - bots and the main
	server run in separate processes so it is possible to read and write from
	the files at the same time if locks are not used.
	
	Because the communication is asynchronous replies are not instant, you send
	a message to the bot (or vice versa) then use a callback to process the
	response later.
	
	Fast communication with bots is done via OnClientMessage, but there is no
	way of returning data using this method, any responses from the bot will
	have to go via the regular file system.
	
	This file defines functions useable from scripts, both server and bot end,
	to communicate with each other.  At the server end this file posts the
	messages off to the communication filterscript, except fast messages which,
	as the name implies, are done specially and instantly.  At the bot end this
	file handles all its own file reading and writing as only one script can
	access the files it relates to.
Legal:
	Copyright (C) 2009 Alex "Y_Less" Cole

	The contents of this file are subject to the Mozilla Public License
	Version 1.1 (the "License"); you may not use this file except in
	compliance with the License. You may obtain a copy of the License at
	http://www.mozilla.org/MPL/
	
	Software distributed under the License is distributed on an "AS IS"
	basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
	License for the specific language governing rights and limitations
	under the License.
	
	The Original Code is the NPC synchronisation code include.
	
	The Initial Developer of the Original Code is Alex "Y_Less" Cole.  All
	Rights Reserved.
Version:
	0.1
Changelog:
	02/09/09:
		First version
Functions:
	Public:
		-
	Core:
		-
	Stock:
		-
	Static:
		-
	Inline:
		-
	API:
		-
Callbacks:
	-
Hooks:
	-
Definitions:
	BOTSYNC_IS_BOT - Detects where this is included, in a bot or server script.
	MAX_FAST_MESSAGE - Max length of a fast bot message.
Enums:
	-
Macros:
	-
Tags:
	-
Variables:
	Global:
		-
	Static:
		-
Commands:
	-
Compile options:
	-
Operators:
	-
Iterators:
	BotSync - Array of unsent messages.
-*----------------------------------------------------------------------------*/

#if !defined _samp_included
	#error "Please include a_samp or a_npc before botsync"
#endif

#include <foreach>

#if defined SendChat
	#define BOTSYNC_IS_BOT     (true)
#endif

#if defined BOTSYNC_IS_BOT
	#define BOTSYNC_LOCK_STRING "0"
	#define BOTSYNC_LOCK_CHAR   '0'
	
	#define BOTSYNC_IN_STR      "t"
	#define BOTSYNC_OUT_STR     "f"
	
	#define BOTSYNC_MESSAGE_BUFFER (20)
#else
	#define BOTSYNC_LOCK_STRING "1"
	#define BOTSYNC_LOCK_CHAR   '1'
	
	#define BOTSYNC_IN_STR      "f"
	#define BOTSYNC_OUT_STR     "t"
	
	#define BOTSYNC_MESSAGE_BUFFER (128)
#endif

#define BOTSYNC_MESSAGE_LENGTH (124)

#define BOTSYNC_FOLDER         "BotSync."

#define BOTSYNC_FILE_LENGTH    (20)

#define BOTSYNC_FILE           (BOTSYNC_FOLDER "%03d.%s.l"), (bot), (read ? (BOTSYNC_IN_STR) : (BOTSYNC_OUT_STR))

#if !defined isnull
	#define isnull(%0) \
		(((%0)[0] == '\0') || (((%0)[0] == '\1') && ((%0)[1] == '\0')))
#endif

forward
	OnBotSyncData(bot, const name[], const msg[]);

#if defined BOTSYNC_IS_BOT
	static
		BS_g_MessageBuffer[BOTSYNC_MESSAGE_BUFFER][BOTSYNC_MESSAGE_LENGTH];
	

	public
		OnNPCConnect(myplayerid)
	{
		SetTimer("BotSync_Tick", 10, true);
		BotSync_OnNPCConnect(myplayerid);
	}
	
	#define OnNPCConnect BotSync_OnNPCConnect
	
	forward
		BotSync_OnNPCConnect(myplayerid);
	
	public
		OnClientMessage(color, text[])
	{
		if (color)
		{
			return BotSync_OnClientMessage(color, text);
		}
		new
			pos0 = -1;
		while (text[++pos0] > '\1') {}
		if (text[pos0] == '\1')
		{
			text[pos0] = '\0';
			BOT_SYNC_CALLBACK(-1, text, text[pos0 + 1]);
		}
		return 0;
	}
	
	#define OnClientMessage BotSync_OnClientMessage
	
	forward
		BotSync_OnClientMessage(color, text[]);
	
	stock
		BotSync_Send(bot, type[], message[])
	{
		new
			slot = Itter_Free(BotSync);
		if (slot != -1)
		{
			if (strlen(type) + strlen(message) < BOTSYNC_MESSAGE_LENGTH - 3)
			{
				format(BS_g_MessageBuffer[slot], BOTSYNC_MESSAGE_LENGTH, "%s\1%s\n", type, message);
				Itter_Add(BotSync, slot);
				return 1;
			}
		}
		return 0;
		#pragma unused bot
	}
#else
	#if defined BOTSYNC_SYNC_FS
		enum E_BOTSYNC_BUFFER
		{
			E_BOTSYNC_BOT,
			E_BOTSYNC_MESSAGE[BOTSYNC_MESSAGE_LENGTH]
		}
		
		static
			BS_g_MessageBuffer[BOTSYNC_MESSAGE_BUFFER][E_BOTSYNC_BUFFER];
		
		forward
			BotSync_Buffer(bot, type[], message[]);
		
		public
			BotSync_Tick()
		{
			new
				dun = -1,
				msg,
				last;
			do
			{
				last = -1;
				foreachex (BotSync, msg)
				{
					if (msg > dun)
					{
						new
							bot = BS_g_MessageBuffer[msg][E_BOTSYNC_BOT];
						if (BotSync_GetLock(bot, false))
						{
							new
								BSF:fhnd = BotSync_Open(bot);
							if (fhnd)
							{
								BotSync_Write(fhnd, BS_g_MessageBuffer[msg][E_BOTSYNC_MESSAGE]);
								new
									cur = YSI_gBotSyncA[msg],
									lst = msg;
								while (cur != -1)
								{
									if (BS_g_MessageBuffer[cur][E_BOTSYNC_BOT] == bot)
									{
										BotSync_Write(fhnd, BS_g_MessageBuffer[cur][E_BOTSYNC_MESSAGE]);
										YSI_gBotSyncA[lst] = YSI_gBotSyncA[cur];
										YSI_gBotSyncA[cur] = -1;
										cur = YSI_gBotSyncA[lst];
										--YSI_gBotSyncC;
									}
									else
									{
										lst = cur;
										cur = YSI_gBotSyncA[cur];
									}
								}
								BotSync_Close(fhnd);
								BotSync_ReleaseLock(bot, false);
								dun = msg;
								if (last == -1)
								{
									YSI_gBotSyncS = YSI_gBotSyncA[msg];
								}
								else
								{
									YSI_gBotSyncA[last] = YSI_gBotSyncA[msg];
								}
								YSI_gBotSyncA[msg] = -1;
								--YSI_gBotSyncC;
								break;
							}
							BotSync_ReleaseLock(bot, false);
						}
					}
					last = msg;
				}
			}
			while (msg != -1);
			foreach (Bot, bot)
			{
				new
					name[BOTSYNC_FILE_LENGTH];
				format(name, sizeof (name), BOTSYNC_FOLDER "%03d." BOTSYNC_IN_STR ".d", bot);
				if (fexist(name))
				{
					if (BotSync_GetLock(bot, true))
					{
						new
							File:fhnd = fopen(name, io_read);
						if (fhnd)
						{
							new
								str[BOTSYNC_MESSAGE_LENGTH];
							while (fread(fhnd, str))
							{
								new
									pos0 = -1;
								while (str[++pos0] > '\1') {}
								if (str[pos0] == '\1')
								{
									new
										pos1 = pos0;
									while (str[++pos1] >= ' ') {}
									str[pos0] = '\0';
									str[pos1] = '\0';
									CallRemoteFunction("OnBotSyncData", "iss", bot, str, str[pos0 + 1]);
								}
							}
							fclose(fhnd);
							fremove(name);
						}
						BotSync_ReleaseLock(bot, true);
					}
				}
			}
		}
		
		public
			BotSync_Buffer(bot, type[], message[])
		{
			// Buffer the message and send it later.
			if (isnull(type) || isnull(message))
			{
				return 0;
			}
			if (IsPlayerNPC(bot))
			{
				new
					slot = Itter_Free(BotSync);
				if (slot != -1)
				{
					if (strlen(type) + strlen(message) < BOTSYNC_MESSAGE_LENGTH - 3)
					{
						format(BS_g_MessageBuffer[slot][E_BOTSYNC_MESSAGE], BOTSYNC_MESSAGE_LENGTH, "%s\1%s\n", type, message);
						BS_g_MessageBuffer[slot][E_BOTSYNC_BOT] = bot;
						Itter_Add(BotSync, slot);
						return 1;
					}
				}
			}
			return 0;
		}
	#else
		stock
			BotSync_SendFast(bot, type[], message[])
		{
			if (IsPlayerNPC(bot))
			{
				if (strlen(type) + strlen(message) < BOTSYNC_MESSAGE_LENGTH - 3)
				{
					new
						str[BOTSYNC_MESSAGE_LENGTH];
					format(str, sizeof (str), "%s\1%s", type, message);
					SendClientMessage(bot, 0, str);
					return 1;
				}
			}
			return 0;
		}
		
		stock
			BotSync_Send(bot, type[], message[])
		{
			CallRemoteFunction("BotSync_Buffer", "iss", bot, type, message);
		}
	#endif
#endif