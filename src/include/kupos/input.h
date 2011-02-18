#ifndef _INPUT_H_
#define _INPUT_H_

#define INPUT			0x31
#define IS_BUF_EMPTY	0
#define READ_KEY		1
#define READ_STR		2
#define CLEAR_BUF		3
	
typedef struct
{
	char scan_code;
	char ascii_code;
} KEY;

////////////////////////////////////////////////////////

char test_buf()
{
	asm	volatile( "mov al, IS_BUF_EMPTY;	int INPUT" );
}

KEY read_key()
{
	asm	volatile( "mov al, READ_KEY;		int INPUT" );
}

unsigned int read_string(char* str)
{
	asm	volatile( "mov al, READ_STR; int INPUT; mov ebx, str; mov [ebx], esi" );
}

void clear_buf()
{
	asm	volatile( "mov al, CLEAR_BUF; int INPUT" );
}

////////////////////////////////////////////////////////

#endif
