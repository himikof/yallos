#ifndef _MEMORY_H_
#define _MEMORY_H_

#define MEMORY				0x31
#define ALLOC_PAGE      	0
#define FREE_PAGE       	1
#define ALLOC_LARGE_PAGE	2
#define FREE_LARGE_PAGE 	3
	
////////////////////////////////////////////////////////

void* alloc_page()
{
	asm	volatile( "mov al, ALLOC_PAGE; int MEMORY;" );
}

void free_page(void* mem)
{
	asm	volatile( "mov edx, mem; mov al, FREE_PAGE; int MEMORY;" );
}

void* alloc_large_page()
{
	asm	volatile( "mov al, ALLOC_LARGE_PAGE; int MEMORY;" );
}

void free_large_page(void* mem)
{
	asm	volatile( "mov edx, mem; mov al, FREE_LARGE_PAGE; int MEMORY;" );
}

////////////////////////////////////////////////////////

#endif
