#if defined _sleep_included
        #endinput
#endif
#define _sleep_included
#pragma library sleep
 
stock Sleep(milliseconds)
{
        new count = GetTickCount();
        while((GetTickCount() - count) < milliseconds){}
}