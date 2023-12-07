//#include <gvar>

stock token_by_delim(const string[], return_str[], delim, start_index)
{
	new x=0;
	while(string[start_index] != EOS && string[start_index] != delim) {
	    return_str[x] = string[start_index];
	    x++;
	    start_index++;
	}
	return_str[x] = EOS;
	if(string[start_index] == EOS) start_index = (-1);
	return start_index;
}

stock DeleteWorldObjectForPlayer(playerid, const filename[])
{
	new File:file_ptr;
	new file[64];
	new line[256];
	new var_from_line[64];
	new modeltype;
	new Float:ObjCoor[3],Float:ObjSug;
	new index;
	new object_loaded;
	format(file,64,"maps/Remove/%s.txt",filename);

	file_ptr = fopen(file,filemode:io_read);
	if(!file_ptr) return 0;

	object_loaded = 0;

	while(fread(file_ptr,line,256) > 0)
	{
	    index = 0;
		
	    // Read type
  		index = token_by_delim(line,var_from_line,',',index);
  		if(index == (-1) || strfind(var_from_line,"//",false) != -1) continue;
  		modeltype = strval(var_from_line);

  		// Read X, Y, Z, Rotation
  		index = token_by_delim(line,var_from_line,',',index+1);
  		if(index == (-1)) continue;
  		ObjCoor[0] = floatstr(var_from_line);

  		index = token_by_delim(line,var_from_line,',',index+1);
  		if(index == (-1)) continue;
  		ObjCoor[1] = floatstr(var_from_line);

  		index = token_by_delim(line,var_from_line,',',index+1);
  		if(index == (-1)) continue;
  		ObjCoor[2] = floatstr(var_from_line);

  		index = token_by_delim(line,var_from_line,';',index+1);
  		if(index == (-1)) continue;
  		ObjSug = floatstr(var_from_line);
  		
		RemoveBuildingForPlayer(playerid, modeltype,ObjCoor[0],ObjCoor[1],ObjCoor[2], ObjSug);
		object_loaded++;
	}

	fclose(file_ptr);
	return object_loaded;
}

stock LoadObjectFromFile(const filename[])
{
	new File:file_ptr;
	new line[256];
	new var_from_line[64];
	new modeltype;
	new Float:ObjCoor[3];
	new Float:ObjRot[3];
	new ObjVW,ObjInt;
	new index;
	new object_loaded;
	new file[64];
	format(file,64,"maps/Create/%s.txt",filename);

	file_ptr = fopen(file,filemode:io_read);
	if(!file_ptr) return 0;

	object_loaded = 0;

	while(fread(file_ptr,line,256) > 0)
	{
	    index = 0;
		
	    // Read type
  		index = token_by_delim(line,var_from_line,',',index);
  		if(index == (-1) || strfind(var_from_line,"/",false) != -1) continue;
  		modeltype = strval(var_from_line);

  		// Read X, Y, Z, Rotation
  		index = token_by_delim(line,var_from_line,',',index+1);
  		if(index == (-1)) continue;
  		ObjCoor[0] = floatstr(var_from_line);

  		index = token_by_delim(line,var_from_line,',',index+1);
  		if(index == (-1)) continue;
  		ObjCoor[1] = floatstr(var_from_line);

  		index = token_by_delim(line,var_from_line,',',index+1);
  		if(index == (-1)) continue;
  		ObjCoor[2] = floatstr(var_from_line);

  		index = token_by_delim(line,var_from_line,',',index+1);
  		if(index == (-1)) continue;
  		ObjRot[0] = floatstr(var_from_line);
		
		index = token_by_delim(line,var_from_line,',',index+1);
  		if(index == (-1)) continue;
  		ObjRot[1] = floatstr(var_from_line);
		
		index = token_by_delim(line,var_from_line,',',index+1);
  		if(index == (-1)) continue;
  		ObjRot[2] = floatstr(var_from_line);
		
		//Read int,vw
		index = token_by_delim(line,var_from_line,',',index+1);
  		if(index == (-1)) continue;
  		ObjInt = strval(var_from_line);
		
		index = token_by_delim(line,var_from_line,';',index+1);
  		if(index == (-1)) continue;
  		ObjVW = strval(var_from_line);
		
		object_loaded++;
		new str[32];
		format(str,sizeof(str),"%s%i",file,object_loaded);
		//SetGVarInt(str,CreateDynamicObject(modeltype,ObjCoor[0],ObjCoor[1],ObjCoor[2],ObjRot[0],ObjRot[1],ObjRot[2],ObjVW,ObjInt));
		CreateDynamicObject(modeltype,ObjCoor[0],ObjCoor[1],ObjCoor[2],ObjRot[0],ObjRot[1],ObjRot[2],ObjVW,ObjInt);
	}
	new str[32];
	format(str,sizeof(str),"%s",file);
	//SetGVarInt(str,object_loaded);

	fclose(file_ptr);
	printf("Betöltve %d objekt a %s fájlból.",object_loaded,filename);
	return object_loaded;
}