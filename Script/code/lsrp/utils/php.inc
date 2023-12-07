/*

Pawn Library
Run PHP through Pawn
by i514x_

*/

#include <a_http>

#define MAX_PHP_LENGTH 256

forward OnServerTryingToRunPHP(index, response_code, data[]);
forward OnScriptResponse(scriptid, contents[]);

stock RunPHP(scriptid, code[MAX_PHP_LENGTH])
{
	new string[MAX_PHP_LENGTH+5];
	format(string, sizeof(string), "code=%s&security="SECURITY_CODE, code);
	HTTP(scriptid, HTTP_POST, PHP_FILE_LOCATION, string, "OnServerTryingToRunPHP");
}

stock FromFile(filename[])
{
	new string[MAX_PHP_LENGTH];
	new File:f = fopen(filename, io_read);
	if(f) 
	{
		fread(f, string);
	}
	fclose(f);
	return string;
}

public OnServerTryingToRunPHP(index, response_code, data[])
{
	if(response_code != 200)
	{
		printf("Error: %d, trying to compile PHP on external server.", response_code);
		return 0;
	}
	CallLocalFunction("OnScriptResponse", "ds", index, data);
	return 1;
}