#if defined _udate_included
	#endinput
#else
	#define _udate_included
#endif


stock
	uDate(time, &e, &h, &n, &o, &p, &mp, hGMT = 0, mGMT = 0)
{
	new
		temp = time,
		Months[12] = {2678400, 2419200, 2678400, 2592000, 2678400, 2592000, 2678400, 2678400, 2592000, 2678400, 2592000, 2678400}
	;
	
	e = 0, h = 0, n = 0, o = 0, p = 0, mp = 0;
	
	time += ((((-12 <= hGMT <= 14) && (0 <= mGMT < 60))) ? ((hGMT * 60 * 60) + (mGMT * 60)) : 0);
	
	new
		year,
		month
	;
	
	while((time -= year) >= (year = (!(e % 4) ? 31622400 : 31536000)))
		e++;

	while((time -= month) >= (month = ((!(e % 4) && (h == 1)) ? 2505600 : Months[h])))
		h++;

	e	+=	1970;
	h	+=	1;
	n 	= 	(floatround(time / 86400) + 1);		time 	-= 	((n - 1) * 86400);
	o 	= 	floatround(time / 3600);				time 	-= 	((o) * 3600);
	p 	= 	floatround(time / 60);				time 	-= 	(p * 60);
	mp 	= 	time;
	
	time = temp;
	return true;
}