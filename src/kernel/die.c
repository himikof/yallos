/*
	KupOS kernel emergency halt routine - die
*/

#include <kupos/stdio.h>

void die(char* reason)
{
	kprint("Kernel death - ");
	kprint(reason);
	kprint("\n    Halting now...\n");
	for(;;);
}
