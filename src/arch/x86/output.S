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

	int_30h:		  /* al - number function output */
		push es
		push gs
		pop es

		cmp al, 5
		ja 1f

		movsx eax, al

		call dword ptr [eax*4 + int_30h_func]
		call _syn_cursor

	1:
		pop es
		iret

/*--------------------------------------------------------------------*/


	int_30h_func:
		.long	_puts
		.long	_putchar
		.long	_clear_screen
		.long	_scroll_down
		.long	_putenter
		.long	_putnumber



	cursor:		.word	0 /* offset from 0b8000h */

/*
	;-------------------------------------------------------------------------------------------------------------------+
	;                                                                                                                   |
	;        PUTS - TEXT OUT                                                                                            |
	;                                                                                                                   |
	;-------------------------------------------------------------------------------------------------------------------+
*/

ENTRY	_puts			/* int puts ( char* str ) - Text out */
		push ebp
		mov ebp, esp

		mov esi, [ebp+8]

        .puts:
		lodsb
		test al, al
		jz .FIN

		push eax
		call _putchar
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

ENTRY	_putchar		   /*int putchar ( char ch ) - Text out */
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

        movsx eax, word ptr [cursor]
        mov [es:eax*2], bx
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
        movsx eax, word ptr [cursor]
        mov bl, 0x20
        mov [es:eax*2], bl

        /* end printing */

.OK:
        cmp word ptr [cursor], 80*25-1    /* check for end screen */
        jna 1f

        push 0x20
        push 0x01
        call _scroll_down
        add esp, 8

     1:
		call _syn_cursor
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

ENTRY	_putenter	/* void putenter(void)	*/

        
        push 10
        call _putchar
        add esp, 4

		ret

/*
	;-------------------------------------------------------------------------------------------------------------------+
	;                                                                                                                   |
	;        PUTNUMBER - PRINT NUMBER(32bit)                                                                            |
	;                                                                                                                   |
	;-------------------------------------------------------------------------------------------------------------------+
*/

ENTRY	_putnumber		/* int putnumber(int num) */
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
		call _putchar
		add esp, 4
		
		loop .l1

		call _putenter

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

ENTRY	_scroll_down			/*  int scroll_down(int start_line, char fill) */
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
		call _syn_cursor
		xor eax, eax
		ret

/*
	;-------------------------------------------------------------------------------------------------------------------+
	;                                                                                                                   |
	;        SYN_CURSOR - SYNCHRONIZE CURSOR LABEL AND CURSOR ON SCREEN                                                 |
	;                                                                                                                   |
	;-------------------------------------------------------------------------------------------------------------------+
*/

ENTRY	_syn_cursor			/*	void syn_cursor(void)  */
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

ENTRY	_clear_screen			/* void clear_screen(void) */
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
		call _syn_cursor
		ret
