/*
 *                              rl_files 1.3.1
 *        All right reserved! © By: RaFaeL
 *
 * Owner                : RaFaeL
 * Time                 : 28.01.2013
 *
 * Thanks to:
 *                      RaFaeL							 - Scripting, PAWN
 *                      Kyosaur							 - How to build plugin
 *                      Gamer_Z							 - Help in passing arrays by referance
 *                      SA:MP Team past, present, future - SA:MP.
 *
 *
 * Functions:
 *          fcheck(dir[], idx) - Check if file exist by idx
 *          fnum(dir[]) - Return how much files in dir
 *          fname(dir[], idx, souce[], len = sizeof(souce)) - Return the file name by idx
 *          fprint(dir[]) - Print all files in dir
 *          fend(file[]) - Delete the file ext like .txt
 *          farray(dir[], arr[][], &idx = 0, &returned = 0, step = sizeof(arr)) - create files array
 *
 *          Dir:dopen(const dir[]) - Open directory
 *          dreopen(Dir:dir) - Reopen the directory (start file counting from 0)
 *          dread(Dir:dir, file[], &type) - Get files and sub directories from directory
 *          dclose(Dir:dir) - Close directory
 *          dcreate(const dir[]) - Create new directory
 *          dremove(const dir[], bool:empty = true) - Delete exist directory
 *          drename(const oldname[], const newname[]) - Rename directory to new name
 *          dexist(const dir[]) - Check if directory exist
 *
 * CallBacks:
 *          None.
 *
 * Update:
 *      28.01.2013:
 *          Other:              - First Release
 *                              - Bug fixed
 *      29.01.2013:
 *          Functions:          - fend(file[], len = sizeof(file))
 *                              - 
 *
 *          Other:
 *                              - fnum(dir[]) changed to PAWN scripted function
 *                              - No meter if "." or "" directory
 *      31.01.2013:
 *          Other:              - Fixed bug while reading directorys
 *                              - Default dir[] = "."
 *      01.02.2013:
 *          Functions:          - farray(dir[], arr[][], &idx = 0, &returned = 0, step = sizeof(arr))
 *                              - 
 *      02.02.2013:
 *          Functions:          - Dir:dopen(const dir[])
 *                              - dreopen(Dir:dir)
 *                              - dread(Dir:dir, file[], &type)
 *                              - dclose(Dir:dir)
 *                              - dcreate(const dir[])
 *                              - dremove(const dir[], bool:empty = true)
 *                              - drename(const oldname[], const newname[])
 *                              - dexist(const dir[])
 *
 *          Other:              - 
 *                              - 
 *
 */
 
#if defined rl_files
	#error files is already defined!
#endif
#define rl_files
 

#define MAX_FILE_NAME         64
#define NULL_DIR              "."
#define PRINT_FORMAT          "%s/%s",dir,file

#define TYPE_FILE     0x1
#define TYPE_DIR      0x10
#define TYPE_UNKNOWN  0x100

//

native fname(const dir[], idx, souce[], len = sizeof(souce));

native Dir:dopen(const dir[]);
native dreopen(Dir:dir);
native dread(Dir:dir, file[], &type);
native dclose(Dir:dir);

native dcreate(const dir[]);
native dremove(const dir[], bool:empty = true);
native drename(const oldname[], const newname[]);
native dexist(const dir[]);

//

stock fprint(dir[] = NULL_DIR) {
	new
		idx,
		file[MAX_FILE_NAME];
	while(fname(dir, idx, file)) {
		printf(PRINT_FORMAT);
		idx++;
	}
	return 1;
}

stock fnum(dir[] = NULL_DIR) {
	new
		idx,
		file[MAX_FILE_NAME];
	while(fname(dir, idx, file)) {
		idx++;
	}
	return idx;
}

stock fcheck(dir[], idx) {
	new
		file[MAX_FILE_NAME];
	if(!fname(dir, idx, file))
		return 0;
	return 1;
}

stock fend(file[]) {
	new
		ret[MAX_FILE_NAME],
		pos = strfind(file, ".", true);
	strcat((ret[0] = EOS, ret), file);
	if(pos != -1)
		ret[pos] = '\0';
		
	return ret;
}

stock farray(dir[], array[][], &idx = 0, &returned = 0, step = sizeof(array), size = sizeof(array[])) {
	new
		idxMax = idx + step,
		posWrite,
		
		file[MAX_FILE_NAME];
		
	returned = 0;
		
	while(fname(dir, idx, file) && idx < idxMax) if(posWrite < idxMax) {
		strcat((array[posWrite][0] = EOS, array[posWrite]), file, size);
		idx++;
		posWrite++;
	}
	returned = posWrite;
	
	return (returned)? (fnum(dir) - returned):(0);
}