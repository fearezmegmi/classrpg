/* ============== Ricardo INC ================================
	###################### ###################### ###################### #########
	###################### Ricardo Függvénykönyvtár ################################
	###################### ###################### ###################### #########
   ============== Ricardo INC ================================ */
#include <core>
#include <time>
#include "seif_walk"
#include "Dini"
#include "fixchars"

#define split
#include "mysql"
#undef split

#define DialogBox(%0,%1,%2,%3,%4,%5)	ShowPlayerDialog(%0,%1,DIALOG_STYLE_MSGBOX,%2,%3,%4,%5)
#define DialogInput(%0,%1,%2,%3,%4,%5)	ShowPlayerDialog(%0,%1,DIALOG_STYLE_INPUT,%2,%3,%4,%5)
#define DialogList(%0,%1,%2,%3,%4,%5)	ShowPlayerDialog(%0,%1,DIALOG_STYLE_LIST,%2,%3,%4,%5)

#define LewisInc_LOADED