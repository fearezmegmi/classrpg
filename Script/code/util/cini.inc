/*
      # # # #     #             #     #         #     # # # # #
    #             #             #     # #       #         #
    #             #             #     #   #     #         #
    #             #             #     #     #   #         #
    #             #             #     #       # #         #
      # # # #     # # # # #     #     #         #         #
	
	               #     #         #     #
	               #     # #       #     #
	               #     #   #     #     #
	               #     #     #   #     #
	               #     #       # #     #
	               #     #         #     #
				   
	for classrpg.net
	by Clint
	
	Some part of code from Y_Less YINI
	
	I made this simple code,
	because it is much simplier than YINI
	and dont need to import tons of code.
	
	Credits:
	- me (Clint)
*/

#define MAX_INI_FILENAME 		(128)
#define MAX_INI_LINE 			(512)
#define MAX_INI_NAME_LEN 		(32)
#define MAX_INI_VALUE_LEN 		(128)

#define INI_DELIMITER 			" = "
#define INI_DELIMITER_LEN 		(3)

#define INI_NEW_LINE 			"\r\n"
#define INI_NEW_LINE_LEN		(2)

#define MAX_INI_LEN 			(MAX_INI_NAME_LEN + MAX_INI_VALUE_LEN + INI_DELIMITER_LEN + INI_NEW_LINE_LEN)

#if !defined strcpy
	#define strcpy(%0,%1,%2) strcat((%0[0] = '\0', %0), %1, %2)
#endif

#define INI_Check(%1,%2,%3) if(!strcmp(%1,name,true)&&!sscanf(value,%3,%2))return 1
#define INI_Custom(%1,%2,%3) if(!strcmp(%1,name,true)&&!sscanf(value,%2,%3))return 1
#define INI_Int(%1,%2) INI_Check(%1,%2,"d")
#define INI_Float(%1,%2) INI_Check(%1,%2,"f")
#define INI_Bool(%1,%2) INI_Check(%1,%2,"l")
#define INI_String(%1,%2,%3) INI_Check(%1,%2,"s["#%3"]")

enum ini_read
{
	iText[MAX_INI_LEN],
	iName[MAX_INI_NAME_LEN],
	iValue[MAX_INI_VALUE_LEN],
};

new
	INI_Buffer[MAX_INI_LINE][ini_read],
	INI_BufferLines,
	//INI_Tmp[MAX_INI_LEN],
	INI_File[MAX_INI_FILENAME]
;

stock bool:INI_ParseFile(fajlnev[], fuggveny[], bExtra = 0, extra = 0, extra2 = 0)
{
	new
		//name[MAX_INI_NAME_LEN],
		//value[MAX_INI_VALUE_LEN],
		File:file,
		pos,
		len,
		line = -1,
		lines
	;
	
	file = fopen(fajlnev, io_read);
	
	if(file)
	{
		while(++line < MAX_INI_LINE && fread(file, INI_Buffer[line][iText], MAX_INI_LEN)){}
		
		lines = line;
		
		fclose(file);
		
		line = -1;
		while(++line < lines)
		{
			len = strlen(INI_Buffer[line][iText]);
			
			if(len < 5)
				continue;
			
			pos = strfind(INI_Buffer[line][iText], INI_DELIMITER, false, 1);
			
			if(pos == -1)
				continue;
				
			strmid(INI_Buffer[line][iName], INI_Buffer[line][iText], 0, pos, MAX_INI_NAME_LEN);
			strmid(INI_Buffer[line][iValue], INI_Buffer[line][iText], pos + INI_DELIMITER_LEN, len - 2, MAX_INI_VALUE_LEN);
			
			if(INI_Buffer[line][iName][0] == EOS || INI_Buffer[line][iValue][0] == EOS)
				continue;
			
			if(bExtra == 0) CallLocalFunction(fuggveny, "ss", INI_Buffer[line][iName], INI_Buffer[line][iValue]);
			else if(bExtra == 1) CallLocalFunction(fuggveny, "dss", extra, INI_Buffer[line][iName], INI_Buffer[line][iValue]);
			else if(bExtra == 2) CallLocalFunction(fuggveny, "ddss", extra, extra2, INI_Buffer[line][iName], INI_Buffer[line][iValue]);
				
		}
		
		return true;
	}
	
	return false;
}

stock INI:INI_Open(fajlnev[])
{
	INI_BufferLines = 0;
	strcpy(INI_File, fajlnev, MAX_INI_FILENAME);
	
	return INI:1;
}

stock INI_Close(INI:file)
{
	if(file)
	{
		new File:fajl = fopen(INI_File, io_write);
		if(fajl)
		{
			while(--INI_BufferLines >= 0)
			{
				fwrite(fajl, INI_Buffer[INI_BufferLines][iText]);
			}
			
			fclose(fajl);
		}
	}
}

#define INI_AddToBuffer(%1,%2,%3) (INI_BufferLines != MAX_INI_LINE && format(INI_Buffer[INI_BufferLines++][iText], MAX_INI_LEN, "%s%s"%1 INI_NEW_LINE, %2, INI_DELIMITER, %3))
/*stock INI_AddToBuffer(name[], value[])
{
	format(INI_Buffer[INI_BufferLines++][iText], MAX_INI_LEN, "%s%s%s" INI_NEW_LINE, name, INI_DELIMITER, value);
}*/

stock INI_WriteInt(INI:file, name[], value)
{
	if(file)
	{
		/*new tmp[16];
		valstr(tmp, value);
		format(tmp, 16, "%d", value);
		INI_AddToBuffer(name, tmp);*/
		INI_AddToBuffer("%d", name, value);
	}
}

stock INI_WriteFloat(INI:file, name[], Float:value)
{
	if(file)
	{
		/*new tmp[20];
		format(tmp, 20, "%.6f", value);
		INI_AddToBuffer(name, tmp);*/
		INI_AddToBuffer("%.6f", name, value);
	}
}

stock INI_WriteString(INI:file, name[], value[])
{
	if(file)
		INI_AddToBuffer("%s", name, value);
		//INI_AddToBuffer(name, value);
}

stock INI_WriteBool(INI:file, name[], bool:value)
{
	if(file)
		INI_AddToBuffer("%s", name, value ? ("true") : ("false"));
		//INI_AddToBuffer(name, value ? ("true") : ("false"));
}