#if defined __util_string
	#endinput
#endif
#define __util_string

stock reverse(const source[]) //By Gabriel "Larcius" Cordes
{
	new string[32];
	for(new i=(strlen(source)-1); i>=0; i--)
	{
		strcat(string,GetSingleChar(source,i));
	}
	return string;
}

stock GetSingleChar(const source[], num) //By Gabriel "Larcius" Cordes
{
	new string[32];
	strmid(string,source,num,(num+1));
	return string;
}

stock strrep(string[], find, replace)
{
    for(new i=0; string[i]; i++)
    {
        if(string[i] == find)
        {
            string[i] = replace;
        }
    }
}