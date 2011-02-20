/*
; KupOS kernel header               |
;-----------------------------------+
*/
.intel_syntax noprefix
.include "macro.inc"
.include "define.inc"

.org GDT_IDT
.code16

.section .gdt, "a"

/*
;------------------------------------------------+
;                   D A T A                      |
;------------------------------------------------+
*/


ENTRY GDT

	null_desc:		.quad	0

	code_descr:		.byte	0xFF, 0xFF, 0x00, 0x00, 0x00, 0b10011010, 0b11001111 , 0x00
	data_descr:		.byte	0xFF, 0xFF, 0x00, 0x00, 0x00, 0b10010010, 0b11001111 , 0x00
	video_descr:	.byte	0xFF, 0xFF, 0x00, 0x80, 0x0b, 0b10010010, 0b11001111 , 0x00
	stack_descr:	.byte	0xFF, 0xFF, 0xf0, 0xff, 0x3e, 0b10010010, 0b01001111 , 0x00

	.fill	8*256 - (. - GDT)

GDT_sz = . - GDT - 1

/*;--------------------------------134 */

.section .idt, "aw"

ENTRY IDT

	trap_int		=	0b1000111100000000
	default_int		=	0b1000111000000000
	cs_seg			=	0x08

/*
	;------------;
	; Exceptions ;
	;------------;

	There they were...

*/

/*
	;------;
	; IRQs ;
	;------;
*/

/*	dwIDT int_20h, cs_seg, default_int

	dwIDT int_21h, cs_seg, default_int

	.rept 4
		dwIDT IRQ1_end, cs_seg, default_int
	.endr

	dwIDT int_26h, cs_seg, default_int

	dwIDT IRQ1_end, cs_seg, default_int

	.rept 8
		dwIDT IRQ2_end, cs_seg, default_int
	.endr
*/
/*
	;-------------;
	; KERNEL INTs ;
	;-------------;
*/

/*	dwIDT int_30h, cs_seg, default_int	*/	   /* OUTPUT */
/*	dwIDT int_31h, cs_seg, default_int	*/	   /* INPUT */
/*	dwIDT int_32h, cs_seg, default_int	*/	   /* FLOPPY */
/*	dwIDT int_33h, cs_seg, default_int	*/	   /* MEMORY */

	.fill	8*256 - (. - IDT)

IDT_sz = . - IDT - 1

/*
;---------------------------------------------------------------------------;
;           H E A D                            S T A R T                    ;
;---------------------------------------------------------------------------;
*/

.section .text.head, "ax"


/* .org OS_HEAD */
ENTRY	start

/*
	;--------------------------------------------------------;
	;            P r o t e c t e d   M o d e                 ;
	;--------------------------------------------------------;
*/

	cli

	in  al, 0x70
	jmp .+2
	or  al, 0x80	  /* cli NMI */
	out 0x70, al
	jmp .+2

	in  al, 0x92
	jmp .+2
	or  al, 2	  /* A20 - available */
	out 0x92, al
	jmp .+2

	/* rePrograming controlers */

	mov al, 0x11
	out 0x20, al
	jmp .+2
	out 0xA0, al
	jmp .+2

	mov al, 0x20
	out 0x21, al
	jmp .+2
	mov al, 0x28
	out 0xA1, al
	jmp .+2

	mov al, 4
	out 0x21, al
	jmp .+2
	mov al, 2
	out 0xA1, al
	jmp .+2

	mov al, 1
	out 0x21, al
	jmp .+2
	out 0xA1, al
	jmp .+2

	mov al, -1
	out 0x21, al
	jmp .+2
	out 0xA1, al
	jmp .+2

	lgdt [GDTR]
	lidt [IDTR]

	mov eax, cr0
	or  al, 1
	mov cr0, eax

	jmp 8:offset prot_mode

prot_mode:

.code32

	mov eax, 0b10000
	mov ds, ax
	mov es, ax

	mov eax, 0b11000
	mov gs, ax

	lss esp, [SYS_STACK]

/*
	;-------------------------------------------+
	;      C O P Y      M A I N                 |
	;-------------------------------------------+
*/

/*
	.comm end, 4
	.comm system_text, 4

	mov esi, _main_com_
	mov edi, system_text						/*  memory 0x03000 - 0x13000 (64kb)  = memory for floppy DMA *//*
	mov ecx, (end - system_text) / 4
	rep movsd									/* main is 0x13000 and we copy it there *//*
*/

/*
	;-------------------------------------------+
	;     P a g i n g - ;-((((((((((((((((((((  |
	;-------------------------------------------+
*/

	mov eax, 0x1407
	mov ecx, 1023			/* Catalog */
	xor edi, edi
	stosd
	add eax, 0x3ff000
						    /* of */
  .fill_catalog:
	stosd				    /* Tables of Pages */
	add eax, 0x1000
	loop .fill_catalog

	xor eax, eax
	mov al, 0x07
	mov ecx, 1024
						    /* Fill */
    .fill:				    /* table */
	stosd				    /* of */
	add eax, 0x1000		    /* Pages 1 */
	loop .fill

	lea edi, [eax-7]
	mov ecx, 1024*1023	   /* Fill */

    .fill2:				   /* tables */
	stosd				   /* of */
	add eax, 0x1000		   /* Pages 2-1024 */
	loop .fill2

	/* -- stop filling -- */

	xor eax, eax
	mov cr3, eax

	mov eax, cr0
	bts eax, 0x1f		  /* and now setup paging =))) fuf */
	mov cr0, eax

/*
	;-------------------------------------------+
	;         I n t e r r u p t i o n  =)       |
	;-------------------------------------------+
*/

/*	mov byte [num_in_key_buf], 0 */	/* for keyboard */

	xor al, al
	out 0x21, al
	jmp .+2			/* controlers sti */
	out 0xA1, al
	jmp .+2

	in  al, 0x70
	jmp .+2
	and al, 0x7f	/* NMI sti */
	out 0x70, al
	jmp .+2

	call fill_idt

	/*sti*/									/* It's not safe yet */

/*
	;--------------------------------+
	;   Set form of cursor           |					why here?
	;--------------------------------+
*/

	mov dx, 0x03d4
	mov ax, 0x000A	     /* Select reg #10   and     reg #10  <- 0 (Low line of cursor) */
	out dx, ax
	jmp .+2

	mov ax, 0x0D0B	     /* Select reg #11   and     reg #11  <- 13 (High line of cursor) */
	out dx, ax
	jmp .+2

	.comm kernel_main, 4
	jmp kernel_main		/* should never return */

fill_idt:
	mov ecx, 0x100
	mov ebx, offset IDT
	mov edx, offset ignore_interrupt

	mov eax, 0x00080000
	mov ax, dx
	mov dx, 0x008E

	1:
	mov dword ptr [ebx], eax
	mov dword ptr [ebx+4], edx
	add ebx, 8

	loop 1b
	ret

ignore_interrupt:			/* dummy handler */
	iret

/*
	;-----------------------------------------------+
	;            DATA                               |
	;-----------------------------------------------+
*/

.section .initdata, "a"

	GDTR:   .word	GDT_sz
			.long	GDT

	IDTR:   .word	IDT_sz
			.long	IDT

	SYS_STACK:	.long	SYS_STACK_ESP
			.word	0b100000

	/*------------------------------------------*/


/*.section .buffer, "a"
		.org	MAIN_COMMANDS*/

/*	.include "main.S" */




/*
									    E N D   O F   H E A D
*/



