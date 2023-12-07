#if defined __system_system_mark
	#endinput
#endif
#define __system_system_mark

// toggle enabled
#define SYSTEM_MARK_ENABLED

#if !defined SYSTEM_MARK_ENABLED
	#endinput
#endif

#if defined P
	#undef P
#endif

// prefix
#define P:%1(%2)	MRK_%1(%2)
#define PS			"MRK_"

#include "mark/mark_hooks.pwn"
#include "mark/mark_functions.pwn"
#include "mark/mark_callbacks.pwn"

#undef P
#undef PS
