/*
;-----------------------------------+
; Yallos yaldr - test loader        |
;-----------------------------------+
*/
.intel_syntax noprefix
.include "macro.inc"
.include "define.inc"
.include "size.inc"

.code16
/*.org 0x7c00*/

/*.section .rodata.head, "a"*/ /* Yeah, this may be not the best solution, but I cannot create 3 bytes-long section */

.align 4
.section .text

base:
ENTRY	ldr_start
	jmp 0:boot /* boot */

/*
	;------------------;
	;  Initialization  ;
	;------------------;
*/
boot:
	mov ax, 0x07c0
	mov ds, ax
	mov ax, 0xb0
	mov es, ax
	mov ss, ax
	mov sp, 0x200

/* Move bootloader out of the way */
	mov cx, 256
	xor di, di
	xor si, si
	rep movsw

	jmp 0xb0:copied - base

/*
	;----------------;
	;  Display mode  ;
	;----------------;
*/
copied:
	mov ax, es
	mov ds, ax

    /* Text mode */
	mov ax, 0x0003
	int 0x10

    /* Set palette: ??? */
	mov ax, 0x1000
	mov bx, 0x1207
	int 0x10

    /* Set border color */
	mov ax, 0x1001
	mov bh, 0x12
	int 0x10

    /* Enable blinking */
	mov ax, 0x1003
	mov bl, 01
	int 0x10
/*
    ;------------------+
    ;  Loading kernel  |
    ;------------------+
*/

.ifgt (KERN_SIZE >> 9 - 2048)
.error "Kernel is too big!"
.endif
	mov ax, (KERNEL_LOAD_ADDR & 0xf0000 ) shr 4
	mov es, ax
	mov bx, KERNEL_LOAD_ADDR & 0xffff


	mov dx, 0x0000		/*	start reading from track=0, head=0, sector=2 */
	mov cx, 0x0002
	call read_kernel

/*
	;-------------------------+
	;  Press any key message  |
	;-------------------------+
*/
	mov ax, cs
	mov es, ax

	mov ax, 0x1300
	mov bx, 0x0007
	mov cx, 14
	mov dx, 0x0100
	mov bp, str_press - base
	int 0x10

	xor ax, ax
	int 0x16

	mov ax, 0x1300
	mov bx, 0x0007
	mov cx, 24
	mov dx, 0x0100
	mov bp, str_kernel - base
	int 0x10

/*
	;--------------------------------------+
	;  Transferring control to the kernel  |
	;--------------------------------------+
*/
	xor ax, ax
	mov ds, ax
	mov es, ax
    /*mov bx, 0x4000
    mov ax, [bx]
    OUTPUT ax 0*/
	jmp 0:0x4000/*BOOT_ENTRY16*/

/*
	+----------------------+
	|  SUBROUTINES FOLLOW  |
	+----------------------+
*/

/*
	+-------------------+
	|  Read the kernel  |
	+-------------------+

	KERN_SIZE - length of the kernel image

	es:bx - pointer to the buffer
*/

	read_kernel:
		push si
		push di

		mov dl, 0
		mov di, 0
		mov ax, 0x0211				/*	read 17 sectors after the MBR */
		call read_track+3			/*	we jump to the second command because function reads 18 sectors */

	/* Set variable to read next track */
	.read:
		mov cl, 1					/*	sector = 1 */
		btc dx, 8					/*	head invert (1->0, 0->1) */
		adc ch, 0					/*	track increment if head was 1 */

		call read_track				/*	read 18 sectors */
		jnc .check_end

	/* bx - overflow */
		mov ax, es
		add ah, 0x10
		mov es, ax

	/* Check for completed loading */
	.check_end:
		mov ax, es
		mov si, ((KERN_SIZE+KERNEL_LOAD_ADDR) & 0xf0000) >> 4
		push dx
		mov dx, (KERN_SIZE+KERNEL_LOAD_ADDR) & 0xffff

		sub dx, bx
		sbb si, ax
		pop dx
		ja .read

		pop di
		pop si
		ret

/*
	+-----------------------+
	|  Read a floppy track  |
	+-----------------------+
*/
	read_track:
		mov ax, 0x0212       /* read 18 sectors */
		/*OUTPUT ax 0
		OUTPUT bx 0*/
        int 0x13
		jc .err
		/*OUTPUT ax 0*/


		mov ah, 0
		shl ax, 9
		add bx, ax

		ret

	.err:
		push dx

		mov dx, FLOPPY_PORT
		mov al, 0
		out dx, al

		/*
		xor ax, ax
		xor dx, dx
		int 0x13
		*/

		pop dx
		jmp read_track


/*
	+-----------------------+
	|  LOADER DATA FOLLOWS  |
	+-----------------------+
*/

.section .rodata, "a"

str_error:		.ascii	"Error"
str_error_sz	= 5 /*. - str_error*/
str_press:		.ascii	"Press any key."
str_press_sz	= 14/*. - str_press*/
str_kernel:		.ascii  "Running Yallos kernel..."
str_kernel_sz	= 24/*. - str_kernel*/


/*
	+-----------------+
	|  MBR SIGNATURE  |
	+-----------------+
*/

.section .rodata.tail, "a"
.word 0x0000
.word 0xAA55


