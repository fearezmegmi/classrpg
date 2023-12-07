#if defined __util_vehicles
	#endinput
#endif
#define __util_vehicles

#define CalcGetVehiclePanelStatus(%0,%1,%2,%3,%4,%5,%6,%7) (%1=%0&7,%2=(%0>>4)&7,%3=(%0>>8)&7,%4=(%0>>12)&7,%5=(%0>>16)&7,%6=(%0>>20)&7,%7=(%0>>24)&7)
#define CalcSetVehiclePanelStatus(%0,%1,%2,%3,%4,%5,%6,%7) (%0=%1|(%2<<4)|(%3<<8)|(%4<<12)|(%5<<16)|(%6<<20)|(%7<<24))