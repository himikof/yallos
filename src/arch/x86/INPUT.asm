	;-------------------------------------------------------------------------------------------------------------------+
	;                                                                                                                   |
	;        INT 31h - INPUT TO CONSOLE                                                                                 |
	;                                                                                                                   |
	;-------------------------------------------------------------------------------------------------------------------+

.include "syscalls_plain.inc"

;---------------------------------------------------------------

	int_31h:		  ; al - number function input
		push es gs
		pop es

		cmp al, 3
		ja .FIN

		movsx eax, al
		call dword [eax*4 + int_31h_func]

	  .FIN:
		pop es
		iret

;---------------------------------------------------------------

	int_31h_func:
		dd	test_buf
		dd	read_key
		dd	read_string
		dd	clear_buf


	;----------------------------------------+
	;  TEST  BUFFER                          |
	;----------------------------------------+

	test_buf:		; return al=1 if buffer empty
		cmp byte [num_in_key_buf], 0
		setz al
		ret

	;----------------------------------------+
	;  CLEAR BUFFER                          |
	;----------------------------------------+

	clear_buf:
		mov byte [num_in_key_buf], 0
		ret

	;----------------------------------------+
	;  READ KEY                              |
	;----------------------------------------+

	read_key:		 ; return in al scan and in ah ascii code
		cli

		cmp byte [num_in_key_buf], 0
		jz .ERR

		movsx eax, byte [num_in_key_buf]
		mov ax, word [eax+key_buffer-2]
		sub byte [num_in_key_buf], 2

		sti
		ret

	    .ERR:
		xor eax, eax
		sti
		ret


	;----------------------------------------+
	;  READ STRING                           |
	;----------------------------------------+

	read_string:		 ; return in esi addr to reading string          in eax number of reading chars
		sti
		push esi edi edx
		xor edi, edi

	     .loop:
		call read_key
		test ah, ah
		jz .loop

		cmp ah, 13 ; enter pressed?
		jz .FIN

		; char key pressed

		cmp ah, 8	;  Backspace?
		jnz .nobskp	;

		test edi, edi
		jnz .nobadbskp

		jmp .loop

	    .nobadbskp:
		dec edi

		mov byte [esi+edi], 0
		jmp .putchar

	     .nobskp:
		mov byte [esi+edi], ah		;  record to esi
		inc edi 			;

	     .putchar:
		mov bl, ah			;
		call putchar			;  record to screen
		call syn_cursor 		;

		jmp .loop

	     .FIN:
		mov byte [esi+edi], 0
		mov eax, edi
		pop edx edi esi
		ret
