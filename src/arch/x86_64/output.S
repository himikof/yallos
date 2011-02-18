/*
	;--------------------------------------------------------------------------------+
	;                                                                                |
	;          BIOS CONSOLE OUTPUT DRIVER                                            |
	;                                                                                |
	;--------------------------------------------------------------------------------+
*/

.intel_syntax noprefix
.include "macro.inc"
.include "syscalls_plain.inc"

	cursor:		.word	0 /* offset from 0b8000h */
	videomem = 0xb8000

/**
 * Print str at current cursor position, updating it.
 */
ENTRY	output_puts			/* int output_puts ( char* str ) - Text out */
		push rbp
		mov ebp, esp

		mov esi, [ebp+8]

        .puts:
		lodsb
		test al, al
		jz .FIN

		push rax
		call output_putchar
		add rsp, 8

		jmp .puts

	    .FIN:
	    xor rax, rax
	    pop rbp
		ret

/**
 * Print ch at current cursor position, updating it.
 */
ENTRY	output_putchar		   /*int output_putchar ( char ch ) - Text out */
		push rbp
		mov ebp, esp
		
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

        movsx rax, word ptr [cursor]
	shl rax, 1
	add rax, videomem
        mov [rax], bx
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
        movsx rax, word ptr [cursor]
        mov bl, 0x20
	shl rax, 1
	add rax, videomem
        mov [rax], bl

        /* end printing */

.OK:
        cmp word ptr [cursor], 80*25-1    /* check for end screen */
        jna 1f

        push 0x20
        push 0x01
        call output_scroll_down
        add esp, 16

     1:
		call output_syn_cursor
        xor eax, eax
        pop rbp
        ret

/**
 * Is this needed?
 */
ENTRY	putnumber		/* int putnumber(int num) */
		push rbp
		mov ebp, esp
		push rbx
		push rcx
		push rdx
		
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
		push rbx
		call output_putchar
		add esp, 8
		
		loop .l1

        // print '\n'
        push 10
		call output_putchar

		xor eax, eax
		pop rdx
		pop rcx 
		pop rbx
		pop rbp
		ret

/**
 * Scroll screen (one?) line down
 */
ENTRY	output_scroll_down			/*  int output_scroll_down(int start_line, char fill) */
		push rbp
		mov ebp, esp
		push rdi
		push rcx 
		push rsi

		mov bl, [ebp+8]
		mov bh, [ebp+12]

		mov al, 80*2
		inc bh
		mul bh
		movsx rsi, ax
		add rsi, videomem

		lea rdi, [rsi - 80*2]

		mov rcx, 80*25*2
		sub rcx, rsi
		shr rcx, 2

		rep movsd

		pop rsi

/*		mov bh, 0x07
		mov ax, bx
		shl eax , 16
		mov ax, bx*/

		mov rdi, 80*25*2 - 80*2
		add rdi, videomem
		mov rcx, (80*2) / 4
		rep stosd

		sub word ptr [cursor], 80

		pop rcx
		pop rdi
		pop rbp
		call output_syn_cursor
		xor rax, rax
		ret


/**
 * Synchronize cursor label and the cursor on screen
 */
ENTRY	output_syn_cursor			/*	void output_syn_cursor(void)  */
		push rbx
		push rdx

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

		pop rdx
		pop rbx
		ret

/**
 * Clear the screen
 */
ENTRY	output_clear_screen			/* void output_clear_screen(void) */
		push rcx
		push rdi

		xor rax, rax
		mov [cursor], ax

		mov rdi, videomem
		mov rax, 0x07200720
		mov rcx, 80*25*2 / 4
		xor rdi, rdi

		rep stosd

		pop rdi
		pop rcx
		call output_syn_cursor
		ret

// vim:ts=4
