/*
 * KupOS floppy boot loader
 */
.intel_syntax noprefix
.include "macro.inc"
.include "define.inc"
.include "size.inc"

.code16
/*.org 0x7c00*/

.section ".rodata", "a"		/* Yeah, this may be not the best solution, but I cannot create a 3 bytes-long section */

ENTRY	start
	jmp .+BPB_sz /* boot */
	nop

	BPB_sz = 0x40
/*
	;------------------------------------------;
	;  Standard BIOS Parameter Block, "BPB".   ;
	;------------------------------------------;
*/
	bpbOEM:			.ascii	"KupOS   "
	bpbSectSize:	.word	512
	bpbClustSize:	.byte	1
	bpbReservedSec:	.word	1
	bpbFats:		.byte	2
	bpbRootSize:	.word	256
	bpbTotalSect:	.word	2880
	bpbMedia:		.byte	240
	bpbFatSize:		.word	9
	bpbTrackSect:	.word	18
	bpbHeads:		.word	2
	bpbHiddenSect:	.long	0
	bpbLargeSect:	.long	0
/*
	;---------------------------------;
	;  extended BPB for FAT12/FAT16   ;
	;---------------------------------;
*/
	bpbDriveNo:		.byte	0
	bpbReserved:	.byte	0
	bpbSignature:	.byte	41			    /*; 0 = nothing more. 41 = three more (below)..*/
	bpbID:			.long	1
	bpbVolumeLabel:	.ascii	"BOOT KupOS "
	bpbFileSystem:	.ascii	"FAT12   "

.align 4
.section .text

/* Bootloader initialization */

boot:
	mov ax, 0x07c0
	mov ds, ax
	mov ax, 0xb0
	mov es, ax
	mov ss, ax
	mov sp, 0x200

	mov cx, 256
	xor di, di
	xor si, si
	rep movsw

	jmp 0xb0:offset copied

/* Setting display mode */

copied:
	mov ax, es
	mov ds, ax

	mov al, 0x03
	int 0x10

	mov ax, 0x1000
	mov bx, 0x1207
	int 0x10

	mov ax, 0x1001
	mov bh, 0x12
	int 0x10

	mov ax, 0x1003
	mov bl, 01
	int 0x10

/* Loading kernel */

.ifgt (KERN_SIZE >> 9 - 2048)
.error "Kernel too big!"
.endif
	mov ax, (GDT_IDT & 0xf0000 ) shr 4
	mov es, ax
	mov bx, GDT_IDT & 0xffff


	mov dx, 0x0100		/*	start read from track=0, head=1, sector=18 */
	mov cx, 0x0012
	call read_kernel

/* Displaying 'Press any key' */

	mov ax, cs
	mov es, ax

	mov ax, 0x1300
	mov bx, 0x0007
	mov cx, offset str_press_sz
	mov dx, 0x0100
	mov bp, offset str_press
	int 0x10

	xor ax, ax
	int 0x16

	mov ax, 0x1300
	mov bx, 0x0007
	mov cx, offset str_kernel_sz
	mov dx, 0x0100
	mov bp, offset str_kernel
	int 0x10

/* Transferring control to the kernel */
	xor ax, ax
	mov ds, ax
	mov es, ax
	jmp 0:OS_HEAD

/*
    Kernel loading routine

	KERN_SIZE - length of kernel.bin

	es:bx - pointer to the buffer
*/

	read_kernel:
		push si
		push di

		mov dl, 0
		mov di, 0
		mov ax, 0x0201				/*	read 1 sector after the FAT */
		call read_track+3			/*	we jump to the second command because function reads 18 sectors but we want only 1 */

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

	/* Check for completing the loading */
	.check_end:
		mov ax, es
		mov si, ((KERN_SIZE+GDT_IDT) & 0xf0000) >> 4
		push dx
		mov dx, (KERN_SIZE+GDT_IDT) & 0xffff

		sub dx, bx
		sbb si, ax
		pop dx
		jnb .read

		pop di
		pop si
		ret

/* Read single track */
	read_track:
		mov ax, 0x0212			/*	read 18 sectors */
		/*OUTPUT ax 0
		OUTPUT bx 0*/
        int 0x13
		jc .err
		OUTPUT ax 0


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



.section .data, "a"

/*
;--------------------------------------------------------;
;                       D a t a                          ;
;--------------------------------------------------------;
*/
str_error:      .ascii   "Error"
str_error_sz    = . - str_error
str_press:		.ascii	"Press any key."
str_press_sz    = . - str_press
str_kernel:		.ascii  "Running KupOS kernel..."
str_kernel_sz   = . - str_kernel

/*.space _start + 512 - 2 - .*/
.section .data.tail, "a"
.word 0x0000
.word 0xAA55

/*.fill	512*(18+16), 1, 0*/
