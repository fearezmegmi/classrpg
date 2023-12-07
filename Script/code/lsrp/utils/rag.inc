#if defined _rag_included
	#endinput
#endif
#define _rag_included
#pragma library rag

stock rag(szo[],tipus) // 1 - val-vel  2 - nak-nek   3 - t
{
    new string[128];
    new string2[128];
	if(tipus == 1 || tipus == 2 || tipus == 3)
	{
		new xd = strlen(szo);
		format(string, sizeof(string), "%s", szo);
		strdel(string, 0, xd-2);
		new sorszam = strfind(string, "a");
		if(sorszam == 1)
		{
		    format(string,sizeof(string),"%s", szo);
			strdel(string, xd-1, xd);
			if(tipus == 1) format(string2,sizeof(string2),"%sával", string);
			else if(tipus == 2) format(string2,sizeof(string2),"%sának", string);
			else if(tipus == 3) format(string2,sizeof(string2),"%sát", string);
		    return string2;
		}
		else
		{
            sorszam = strfind(string, "e");
            if(sorszam == 1)
			{
			    format(string,sizeof(string),"%s", szo);
				strdel(string, xd-1, xd);
			    if(tipus == 1) format(string2,sizeof(string2),"%sével", string);
			    else if(tipus == 2) format(string2,sizeof(string2),"%sének", string);
			    else if(tipus == 3) format(string2,sizeof(string2),"%sét", string);
			    return string2;
			}
			else
			{
                sorszam = strfind(string, "i");
	            if(sorszam == 1)
				{
				    format(string,sizeof(string),"%s", szo);
				    strdel(string, 0, xd-3);
				    if(tipus == 3) { format(string,sizeof(string),"%st", szo); return string2; }
				    if( strfind(string, "a") != -1 || strfind(string, "o") != -1 || strfind(string, "u") != -1)
				    {
				    	if(tipus == 1) format(string2,sizeof(string2),"%sval", szo);
				    	else if(tipus == 2) format(string2,sizeof(string2),"%snak", szo);
				    	return string2;
				    }
				    else if(strfind(string, "e") != -1 || strfind(string, "i") != -1)
				    {
				        if(tipus == 1) format(string2,sizeof(string2),"%svel", szo);
				        else if(tipus == 2) format(string2,sizeof(string2),"%snek", szo);
				    	return string2;
				    }
				    else
				    {
				        format(string2,sizeof(string2),"%svel", szo);
				    	return string2;
				    }
				}
				else
				{
				    sorszam = strfind(string, "o");
		            if(sorszam == 1)
					{
					    format(string,sizeof(string),"%s", szo);
						strdel(string, xd-1, xd);
					    if(tipus == 1) format(string2,sizeof(string2),"%sóval", string);
					    else if(tipus == 2) format(string2,sizeof(string2),"%sónak", string);
					    else if(tipus == 3) format(string2,sizeof(string2),"%sót", string);
					    return string2;
					}
					else
					{
					    sorszam = strfind(string, "u");
			            if(sorszam == 1)
						{
						    if(tipus == 1) format(string2,sizeof(string2),"%sval", szo);
						    else if(tipus == 2) format(string2,sizeof(string2),"%snak", szo);
						    else if(tipus == 3) format(string2,sizeof(string2),"%st", szo);
						    return string2;
						}
						else
						{
							if(tipus == 1 || tipus == 2)
							{
							    new string3[10];
								format(string,sizeof(string),"%s", szo);
							    if(tipus==1)
							    {
								    if(strfind(string, "cs") != -1 || strfind(string, "dz") != -1 || strfind(string, "dzs") != -1 || strfind(string, "gy") != -1 || strfind(string, "ly") != -1 || strfind(string, "ny") != -1 || strfind(string, "sz") != -1 || strfind(string, "ty") != -1 || strfind(string, "zs") != -1)
								    {
								        if(strfind(string, "dzs") != -1)
								        {
								            strdel(string, 0, xd-3);
								            if(strfind(string, "dzs") != -1)
								            {
								                strmid(string3, szo, 0, xd-2);
								    			format(string2,sizeof(string2),"%sdzsel", string3);
								    			return string2;
								    		}
								    	}
								        strdel(string,0, xd-2);
								        if(strfind(string, "cs") != -1 || strfind(string, "dz") != -1 || strfind(string, "gy") != -1 || strfind(string, "ly") != -1 || strfind(string, "ny") != -1 || strfind(string, "sz") != -1 || strfind(string, "ty") != -1 || strfind(string, "zs") != -1)
								        {
								            format(string,sizeof(string),"%s", szo);
								            strdel(string, 0, xd-3);
								    		if( strfind(string, "a") != -1 || strfind(string, "o") != -1 || strfind(string, "u") != -1)
								    		{
								            	format(string,sizeof(string),"%s", szo);
								            	strdel(string, xd-1, xd);
								            	strmid(string3, szo, xd-2, xd);
								            	format(string2,sizeof(string2),"%s%sal", string,string3);
								            	return string2;
								            }
								            else
								            {
								                format(string,sizeof(string),"%s", szo);
								            	strdel(string, xd-1, xd);
								            	strmid(string3, szo, xd-2, xd);
								            	format(string2,sizeof(string2),"%s%sel", string,string3);
								            	return string2;
								            }
								        }
								    }
								}
					    		strdel(string, 0, xd-3);
					    		if( strfind(string, "a") != -1 || strfind(string, "o") != -1 || strfind(string, "u") != -1)
					    		{
							    	strmid(string3, szo, xd-1, xd);
							    	if(tipus == 1) format(string2,sizeof(string2),"%s%sal", szo, string3);
							    	else if(tipus == 2) format(string2,sizeof(string2),"%snak", szo);
							    	return string2;
							    }
							    else
							    {
							    	strmid(string3, szo, xd-1, xd);
							    	if(tipus == 1) format(string2,sizeof(string2),"%s%sel", szo, string3);
							    	else if(tipus == 2) format(string2,sizeof(string2),"%snek", szo);
							    	return string2;
							    }
							}
							else if(tipus == 3)
							{
							    format(string,sizeof(string),"%s", szo);
						        strdel(string, 0, xd-1);
						    	if(strfind(string, "j") != -1 || strfind(string, "l") != -1 || strfind(string, "n") != -1 || strfind(string, "r") != -1 || strfind(string, "s") != -1 || strfind(string, "y") != -1 || strfind(string, "z") != -1)
						    	{
						    	    format(string2,sizeof(string2),"%st", szo);
						    	    return string2;
						    	}
						    	else
						    	{
						    	    format(string,sizeof(string),"%s", szo);
						    	    strdel(string, 0, xd-3);
						    	    if( strfind(string, "a") != -1 || strfind(string, "o") != -1 || strfind(string, "u") != -1)
						    	    {
						    	        format(string2,sizeof(string2),"%sot", szo);
						    	    	return string2;
						    	    }
						    	    else
						    	    {
						    	        format(string2,sizeof(string2),"%set", szo);
						    	    	return string2;
						    	    }
						    	}
						    }
						}
					}
				}
			}
		}
	}
	else format(string, sizeof(string), "Típus nem jó");
	return string;
}