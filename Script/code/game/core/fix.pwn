#if defined __game_core_fix
	#endinput
#endif
#define __game_core_fix

stock File:FIX_fopen(const name[], filemode:mode = io_readwrite)
{
	new File:handle = fopen(name, mode);
	
	if(!handle)
		printf("[Debug][fopen] Hibas handle - %s", name);
	
	return handle;
}

#if defined _ALS_fopen
	#undef fclose
#else
	#define _ALS_fopen
#endif
#define fopen FIX_fopen

stock bool:FIX_fclose(File:handle)
{
	if(handle)
		return fclose(handle);
	
	print("[Debug][fclose] Hibas handle");
	return false;
}

#if defined _ALS_fclose
	#undef fclose
#else
	#define _ALS_fclose
#endif
#define fclose FIX_fclose

stock FIX_fwrite(File:handle, const string[])
{
	if(handle)
		return fwrite(handle, string);
	
	printf("[Debug][fwrite] Hibas handle - %s", string);
	return 0;
}

#if defined _ALS_fwrite
	#undef fwrite
#else
	#define _ALS_fwrite
#endif
#define fwrite FIX_fwrite

stock FIX_fread(File:handle, string[], size = sizeof(string), bool:pack = false)
{
	if(handle)
		return fread(handle, string, size, pack);
	
	printf("[Debug][fread] Hibas handle - %s", string);
	return 0;
}

#if defined _ALS_fread
	#undef fread
#else
	#define _ALS_fread
#endif
#define fread FIX_fread