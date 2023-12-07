#if defined __system_system_client_v2
	#endinput
#endif
#define __system_system_client_v2

#if defined P
	#undef P
#endif

// prefix
#define P:%1(%2)	CLNT_%1(%2)
#define PS			"CLNT_"

#include "client_v2/client_core.pwn"

#undef P
#undef PS
