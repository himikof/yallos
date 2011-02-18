#ifndef _OUTPUT_H_
#define _OUTPUT_H_

//#define OUTPUT			0x30
//#define PUTS			0
//#define PUTCHAR			1
//#define CLEAR_SCREEN	2
//#define SCROLL_DOWN		3
//#define PUTENTER		4
//#define PUTNUMBER		5

////////////////////////////////////////////////////////

/*void puts(char* str)
{
	asm	volatile( "mov esi, str; mov al, PUTS; int OUTPUT" );
}

void putchar(char T)
{
	asm	volatile( "mov bl, T; mov al, PUTCHAR; int OUTPUT" );
}

void clear_screen()
{
	asm	volatile( "mov al, CLEAR_SCREEN; int OUTPUT;" );
}

void scroll_down(unsigned char num_line, char T)
{
	asm	volatile( "mov bh, num_line; mov bl, T; mov al, SCROLL_DOWN; int OUTPUT;" );
}

void putenter()
{
	asm	volatile( "mov al, PUTENTER; int OUTPUT;" );
}

void putnumber(unsigned int num)
{
	asm	volatile( "mov ebp, num; mov al, PUTNUMBER;	int OUTPUT;" );
}*/

extern int output_puts(const char* str);
extern int output_putchar(char T);
extern void output_clear_screen();
extern void output_scroll_down(unsigned char num_lines, char T);
//extern void putenter();
//extern void putnumber(unsigned int num);

////////////////////////////////////////////////////////

#endif
