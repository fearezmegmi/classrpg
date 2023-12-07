#if defined __system_system_bonus
	#endinput
#endif
#define __system_system_bonus

#define SYSTEM_BONUS

#if defined P
	#undef P
#endif

// prefix
#define P:%1(%2)	BNS_%1(%2)
#define PS			"BNS_"

#include "bonus/bonus_definition.pwn"
#include "bonus/bonus_constants.pwn"
#include "bonus/bonus_variables.pwn"
#include "bonus/bonus_hooks.pwn"
#include "bonus/bonus_luck.pwn"
#include "bonus/bonus_textdraw.pwn"
#include "bonus/bonus_functions.pwn"
#include "bonus/bonus_keys.pwn"
#include "bonus/bonus_callbacks.pwn"

#undef P
#undef PS
