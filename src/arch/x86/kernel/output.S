/*
	;-------------------------------------------------------------------------------------------------------------------+
	;                                                                                                                   |
	;        INT 30h - OUTPUT TO CONSOLE                                                                                |
	;                                                                                                                   |
	;-------------------------------------------------------------------------------------------------------------------+
*/

.intel_syntax noprefix
.include "macro.inc"
.include "syscalls_plain.inc"

/*--------------------------------------------------------------------*/
/*
	int_30h:		 */ /* al - number function output */ /*
		push es
		push gs
		pop es

		cmp al, 5
		ja 1f

		movsx eax, al

		call dword ptr [eax*4 + int_30h_func]
		call _output_syn_cursor

	1:
		pop es
		iret
*/
/*--------------------------------------------------------------------*/

/*
	int_30h_func:
		.long	_puts
		.long	_output_putchar
		.long	_output_clear_screen
		.long	_output_scroll_down
		.long	_output_putenter
		.long	_output_putnumber
*/


	cursor:		.word	0 /* offset from 0b8000h */
    videomem = 0xb8000

/*
	;-------------------------------------------------------------------------------------------------------------------+
	;                                                                                                                   |
	;        PUTS - TEXT OUT                                                                                            |
	;                                                                                                                   |
	;-------------------------------------------------------------------------------------------------------------------+
*/

ENTRY	output_puts			/* int output_puts ( char* str ) - Text out */
		push ebp
		mov ebp, esp

		mov esi, [ebp+8]

        .puts:
		lodsb
		test al, al
		jz .FIN

		push eax
		call output_putchar
		add esp, 4

		jmp .puts

	    .FIN:
	    xor eax, eax
	    pop ebp
		ret

/*
	;-------------------------------------------------------------------------------------------------------------------+
	;                                                                                                                   |
	;        PUTCHAR - CHAR OUT                                                                                         |
	;                                                                                                                   |
	;-------------------------------------------------------------------------------------------------------------------+
*/

ENTRY	output_putchar		   /*int output_putchar ( char ch ) - Text out */
		push ebp
		mov ebp, esp
		push es
		push gs
		pop es
		
		mov bl, [ebp+8]

        test bl, bl
        jz .FIN

        mov bh, 0x07

        /* check for enter,backspace and etc */

        cmp bl, 10
        jz .nextline
        cmp bl, 8
        jz .backspace

        /* if no then print char */

        movzx eax, word ptr [cursor]
        lea eax, [videomem + 2*eax]
        mov [eax], bx
        inc word ptr [cursor]
        jmp .OK

.nextline:
        mov bh, 80
        mov ax, [cursor]
        div bh
        inc eax
        mul bh
        mov [cursor], ax
        jmp .OK

.backspace:
        dec word ptr [cursor]
        movzx eax, word ptr [cursor]
        lea eax, [videomem + 2*eax]
        mov bl, 0x20
        mov [eax], bl

        /* end printing */

.OK:
        cmp word ptr [cursor], 80*25-1    /* check for end screen */
        jna 1f

        push 0x20
        push 0x01
        call output_scroll_down
        add esp, 8

     1:
		call output_syn_cursor
        xor eax, eax
		pop es
        pop ebp
        ret

/*
	;-------------------------------------------------------------------------------------------------------------------+
	;                                                                                                                   |
	;        PUTENTER - PRESS ENTER                                                                                     |
	;                                                                                                                   |
	;-------------------------------------------------------------------------------------------------------------------+
*/

ENTRY	output_putenter	/* void output_putenter(void)	*/

        
        push 10
        call output_putchar
        add esp, 4

		ret

/*
	;-------------------------------------------------------------------------------------------------------------------+
	;                                                                                                                   |
	;        PUTNUMBER - PRINT NUMBER(32bit)                                                                            |
	;                                                                                                                   |
	;-------------------------------------------------------------------------------------------------------------------+
*/

ENTRY	output_putnumber		/* int output_putnumber(int num) */
		push ebp
		mov ebp, esp
		push ebx
		push ecx
		push edx
		
		mov edx, [ebp+8]

		mov ecx, 8
	   .l1:
		mov ebx, edx
		shl edx, 4
		and ebx, 0xf0000000
		shr ebx, 28
		or  bl,  0x30

		cmp bl, 0x3A
		jb .put

		add bl, 7

	  .put:
		and ebx, 0xFF
		push ebx
		call output_putchar
		add esp, 4
		
		loop .l1

		call output_putenter

		xor eax, eax
		pop edx
		pop ecx 
		pop ebx
		pop ebp
		ret

/*
	;-------------------------------------------------------------------------------------------------------------------+
	;                                                                                                                   |
	;            SCROLL_DOWN - SCROLL SCREEN ONE LINE DOWNWARDS                                                         |
	;                                                                                                                   |
	;-------------------------------------------------------------------------------------------------------------------+
*/

ENTRY	output_scroll_down			/*  int output_scroll_down(int start_line, char fill) */
		push ebp
		mov ebp, esp
		push es
		push edi
		push ecx 
		push ds
		push esi


		mov cx, gs
		mov es, cx
		mov ds, cx
		
		mov bl, [ebp+8]
		mov bh, [ebp+12]

		mov al, 80*2
		inc bh
		mul bh
		movsx esi, ax

		lea edi, [esi - 80*2]

		mov ecx, 80*25*2
		sub ecx, esi
		shr ecx, 2

		rep movsd

		pop esi
		pop ds

		mov bh, 0x07
		mov ax, bx
		shl eax , 16
		mov ax, bx

		mov edi, 80*25*2 - 80*2
		mov ecx, (80*2) / 4
		rep stosd

		sub word ptr [cursor], 80

		pop ecx
		pop edi
        pop es
		pop ebp
		call output_syn_cursor
		xor eax, eax
		ret

/*
	;-------------------------------------------------------------------------------------------------------------------+
	;                                                                                                                   |
	;        SYN_CURSOR - SYNCHRONIZE CURSOR LABEL AND CURSOR ON SCREEN                                                 |
	;                                                                                                                   |
	;-------------------------------------------------------------------------------------------------------------------+
*/

ENTRY	output_syn_cursor			/*	void output_syn_cursor(void)  */
		push ebx
		push edx

		mov bx, word ptr [cursor]

		mov dx, 0x03d4
		mov al, 0x0E
		out dx, al
		jmp .+2

		inc dx
		mov al, bh
		out dx, al
		jmp .+2

		dec dx
		mov al, 0x0F
		out dx, al
		jmp .+2

		inc dx
		mov al, bl
		out dx, al
		jmp .+2

		pop edx
		pop ebx
		ret

/*
	;-------------------------------------------------------------------------------------------------------------------+
	;                                                                                                                   |
	;        CLEAR_SCREEN - :)                                                                                          |
	;                                                                                                                   |
	;-------------------------------------------------------------------------------------------------------------------+
*/

ENTRY	output_clear_screen			/* void output_clear_screen(void) */
		push ecx
		push edi
		push es
		push gs
		pop es

		xor eax, eax
		mov [cursor], ax

		mov eax, 0x07200720
		mov ecx, 80*25*2 / 4
		xor edi, edi

		rep stosd

        pop es
		pop edi
		pop ecx
		call output_syn_cursor
		ret
