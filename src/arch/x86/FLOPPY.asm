	;-------------------------------------------------------------------------------------------------------------------+
	;                                                                                                                   |
	;        INT 32h - F L O P P Y                                                                                      |
	;                                                                                                                   |
	;-------------------------------------------------------------------------------------------------------------------+

.include "syscalls_plain.inc"

;-----------------------------------------------------------------

	int_32h:		  ; al - number function floppy
		push ebp

		cmp al, 4
		ja .FIN

		movsx eax, al
		call dword [eax*4 + int_32h_func]

	  .FIN:
		pop ebp
		iret

;-----------------------------------------------------------------

	int_32h_func:
		dd	read_sector
		dd	write_sector
		dd	read_file
		dd	write_file
		dd	stop_floppy

	;----------------------------------------+
	;  READ / WRITE  SECTOR                  |
	;----------------------------------------+

	read_sector:
		xor ebp, ebp
		jmp rw_sector

	write_sector:
		mov bp, 12
	       ;jmp rw_sector

	rw_sector:    ;  edi - addr to buffer ; ecx - sectors to read < 128 ; ebx - 0AABBCCDDh -- AA - number sector(1-..), BB - number heades(0-..), CC - number track(0-..), DD - number device(0-3) ; ebp = 12 - write, 0 - read
		push edx esi

		mov al, 1ch   ; enable floppy interrupt ; not calibrate
		or  al, bl    ; set number device

		mov dx, FLOPPY_PORT
		out dx, al
		jmp $+2

		mov al, 9
		call wait_tick

		mov esi, out_fdc	; call esi  is shorter than   call out_fdc

		mov ah, 0fh		; operation FIND
		call esi

		mov eax, ebx		;
		shl ax, 14		; number device and heades
		shr eax, 6		;
		mov bl, ah		;
		call esi
		mov ah, bh		; number track
		call esi

		call wait_floppy

		mov al, 5
		call wait_tick

		mov al, 46h		;  code of reading/writing
		xor eax, ebp		;  read or write?
		out 0ch, al		;  write something - clear this port
		jmp $+2 		;
		out 0bh, al		;  but here we have to write 46h for read and 4Ah for write
		jmp $+2 		;


		mov eax, FLOPPY_MEM	;
					;
		out 04h, al		;
		jmp $+2 		;
					;
		mov al, ah		;     THIS CODE SET ADDRESS OF BUFFER FOR READING
		out 04h, al		;
		jmp $+2 		;
					;
		shr eax, 16		;
		out 81h, al		;
		jmp $+2 		;

		mov eax, ecx		;
		out 05h, al		;
		jmp $+2 		;     SETTING SIZE OF READING
					;
		mov al, ah		;
		out 05h, al		;
		jmp $+2 		;

		mov al, 2		;
		out 0Ah, al		;     chanel #2 - now isn't masked
		jmp $+2 		;

		;  Writing/Reading - =)(=

		mov ah, 45h		; code write
		test ebp, ebp
		jnz .write
		add ah, 21h		; code read
	    .write:

		call esi

		mov al, bh		; heades
		shl al, 2
		or  bl, al		; now bl in bit2 have heades

		mov ah, bl		; number device(bits 0-1) and heades(bit - 2)
		call esi

		mov ah, bh		; number tracks
		call esi

		shr ebx, 16
		mov ah, bl		; number heades
		call esi

		mov ah, bh		; number sector
		call esi

		mov ah, 2		; sector = 512 bytes
		call esi

		mov ah, 9		; ID end tracks         ??? (possible 18 or 36)
		call esi

		mov ah, 1ah		; ID
		call esi

		mov ah, 0ffh		; ID
		call esi

		; End Writing/Reading

		push ecx
		mov ecx, 7

	     .loop:			;   BUFFER STATE - =)
		call in_fdc		;
		loop .loop		;

		call stop_floppy

		pop ecx 		;
		shr ecx, 2		;   copy from FLOPPY_MEM to EDI
		mov esi, FLOPPY_MEM	;
		rep movsd		;

	     .FIN:
		pop esi edx
		ret

	;----- SUBROUTINE --------

	out_fdc:		; out 03f4h, ah      with correction
		mov dx, 03f4h

	     .wait:
		in al, dx
		jmp $+2
		test al, 80h
		jz .wait

		inc dx
		mov al, ah
		out dx, al
		jmp $+2

		ret

	in_fdc: 	       ; in  al, 03f4h      with correction
		mov dx, 03f4h

	     .wait:
		in al, dx
		jmp $+2
		test al, 80h
		jz .wait

		inc dx
		in al, dx
		jmp $+2

		ret

	;----------------------------------------+
	;  READ FILE                             |
	;----------------------------------------+

	read_file:
		ret

	;----------------------------------------+
	;  WRITE FILE                            |
	;----------------------------------------+

	write_file:
		ret

	;----------------------------------------+
	;  STOP FLOPPY                           |
	;----------------------------------------+

	stop_floppy:
		mov dx, 03f2h		;
		mov al, 0		;  stop motors and etc - END!
		out dx, al		;
		jmp $+2 		;

		ret