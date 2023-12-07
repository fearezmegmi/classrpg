/*
 *            Dini 1.5.1
 *       (c) Copyright 2006 by DracoBlue
 *
 * @author    : DracoBlue (http://dracoblue.com)
 * @date      : 13th May 2006
 * @update    : 3rd June 2007
 * @require   : DUtils 1.8
 *
 * This file is provided as is (no warranties).
 *
 * Feel free to use it, a little message in
 * about box is honouring thing, isn't it?
 *
 */

#if defined _dini_included
  #endinput
#endif

#define _dini_included
#pragma library dutils

#include <util\dutils>

stock  dini_Exists(filename[]) {
	if (fexist(filename)) return true;
	return false;
}

stock  dini_Remove(filename[]) {
	if (!fexist(filename)) return false;
	fremove(filename);
	return true;
}

stock  dini_Create(filename[]) {
	new File:fhnd;
	if (fexist(filename)) return false;
	fhnd=fopen(filename,io_write);
	fclose(fhnd);
	return true;
}

stock  dini_PRIVATE_ExtractKey(line[]) {
	new tmpdini[MAX_STRING];
	tmpdini[0]=0;
	if (strfind(line,"=",true)==-1) return tmpdini;
	set(tmpdini,strlower(ret_memcpy(line,0,strfind(line,"=",true))));
	return tmpdini;
}

stock  dini_PRIVATE_ExtractValue(line[]) {
    new tmpdini[MAX_STRING];
    tmpdini[0]=0;
    if (strfind(line,"=",true)==-1) {
        return tmpdini;
    }
    set(tmpdini,ret_memcpy(line,strfind(line,"=",true)+1,strlen(line)));
    return tmpdini;
}

stock  dini_Set(filename[],key[],value[]) {
	new File:fohnd, File:fwhnd;
	new bool:wasset=false;
	new tmpdinires[MAX_STRING];
	if (key[0]==0) return false; /* If we have no sign in key, it can't be set*/
	format(tmpdinires,sizeof(tmpdinires),"%s.part",filename);
	fohnd=fopen(filename,io_read);
	if (!fohnd) return false;
	fremove(tmpdinires);
	fwhnd=fopen(tmpdinires,io_write);
	//  if (!fwhnd) return false;
	while (fread(fohnd,tmpdinires)) {
		StripNewLine(tmpdinires);
		if ((!wasset)&&(equal(dini_PRIVATE_ExtractKey(tmpdinires),key,true))) {
			/* We've got what needs to be replaced! */
			format(tmpdinires,sizeof(tmpdinires),"%s=%s",key,value);
			wasset=true;
		}
		fwrite(fwhnd,tmpdinires);
		fwrite(fwhnd,"\r\n");
	}

	if (!wasset) {
		format(tmpdinires,sizeof(tmpdinires),"%s=%s",key,value);
		fwrite(fwhnd,tmpdinires);
		fwrite(fwhnd,"\r\n");
	}

	fclose(fohnd);
	fclose(fwhnd);

	format(tmpdinires,sizeof(tmpdinires),"%s.part",filename);
	if (fcopytextfile(tmpdinires,filename)) {
		return fremove(tmpdinires);
	}
	return false;
}


stock  dini_IntSet(filename[],key[],value) {
   new valuestring[MAX_STRING];
   format(valuestring,sizeof(valuestring),"%d",value);
   return dini_Set(filename,key,valuestring);
}

stock  dini_Int(filename[],key[]) {
   return strval(dini_Get(filename,key));
}

stock  dini_FloatSet(filename[],key[],Float:value) {
   new valuestring[MAX_STRING];
   format(valuestring,sizeof(valuestring),"%f",value);
   return dini_Set(filename,key,valuestring);
}

stock  Float:dini_Float(filename[],key[]) {
   return floatstr(dini_Get(filename,key));
}

stock  dini_Bool(filename[],key[]) {
   return strval(dini_Get(filename,key));
}

stock  dini_BoolSet(filename[],key[],value) {
   new valuestring[MAX_STRING];
   format(valuestring,sizeof(valuestring),"%d",value);
   return dini_Set(filename,key,valuestring);
}

stock  dini_Unset(filename[],key[]) {
	new File:fohnd, File:fwhnd;
	new tmpdinires[MAX_STRING];
	format(tmpdinires,sizeof(tmpdinires),"%s.part",filename);
	fohnd=fopen(filename,io_read);
	if (!fohnd) return false;
	fremove(tmpdinires);
	fwhnd=fopen(tmpdinires,io_write);
	//  if (!fwhnd) return false;
	while (fread(fohnd,tmpdinires)) {
		StripNewLine(tmpdinires);
		if (equal(dini_PRIVATE_ExtractKey(tmpdinires),key,true)) {
			/* We've got what needs to be removed! */
		} else {
			format(tmpdinires,sizeof(tmpdinires),"%s",tmpdinires);
			fwrite(fwhnd,tmpdinires);
			fwrite(fwhnd,"\r\n");
		}
	}

	fclose(fohnd);
	fclose(fwhnd);

	format(tmpdinires,sizeof(tmpdinires),"%s.part",filename);
	if (fcopytextfile(tmpdinires,filename)) {
		return fremove(tmpdinires);
	}
	return false;
}

stock  dini_Get(filename[],key[]) {
	new File:fohnd;
	new tmpdinires[MAX_STRING];
	new tmpdinires2[MAX_STRING];
	tmpdinires[0]=0;
	fohnd=fopen(filename,io_read);
	if (!fohnd) return tmpdinires;
	while (fread(fohnd,tmpdinires)) {
		StripNewLine(tmpdinires);
		if (equal(dini_PRIVATE_ExtractKey(tmpdinires),key,true)) {
			/* We've got what we need */
			tmpdinires2[0]=0;
			strcat(tmpdinires2,dini_PRIVATE_ExtractValue(tmpdinires));
			fclose(fohnd);
			return tmpdinires2;
		}
	}
	fclose(fohnd);
	return tmpdinires;
}


stock  dini_Isset(filename[],key[]) {
	new File:fohnd;
	new tmpdinires[MAX_STRING];
	fohnd=fopen(filename,io_read);
	if (!fohnd) return false;
	while (fread(fohnd,tmpdinires)) {
		StripNewLine(tmpdinires);
		if (equal(dini_PRIVATE_ExtractKey(tmpdinires),key,true)) {
			/* We've got what we need */
			fclose(fohnd);
			return true;
		}
	}
	fclose(fohnd);
	return false;
}
