	;------------------+
	; IRQ1 - Keyboard  |
	;------------------+

	int_21h:
		pushad

		xor eax, eax
		in al, 60h
		jmp $+2

		test al, 80h	      ;  press or unpress ?
		jz .press

		mov byte [key_state+eax-80h], 0
		jmp .FINP

	    .press:

		mov byte [key_state+eax], 1

		; scan -> ascii

		mov ebx, ascii_table
		test byte [key_state+shift], 1
		jz .convert
		add ebx, ascii_table_sh - ascii_table

	   .convert:
		mov dl, [ebx+eax-1]		    ; dl <- ascii code
						    ; al = scan code
		movsx ebx, byte [num_in_key_buf]
		cmp ebx, key_buffer_sz
		jnz .buf_not_overflow

		call sound
		jmp .FIN

	.buf_not_overflow:

		mov [ebx + key_buffer], al
		mov [ebx + key_buffer+1], dl

		add byte [num_in_key_buf], 2

		; send keyboard message of success

	    .FINP:
		in  al, 61h
		jmp $+2
		or  al, 80h
		out 61h, al
		jmp $+2
		and al, 7fh
		out 61h, al
		jmp $+2

		; exit from interruption

	    .FIN:
		popad
		jmp IRQ1_end

	key_buffer_sz	      = 40h
	shift		      = 42

	num_in_key_buf	      db	0
	key_buffer	      db	key_buffer_sz	 dup(0)

	key_state	      db	80		 dup(0)



	ascii_table		db	0, '1234567890-=', 8, ' ', 'qwertyuiop[]', 13,\ 	    ;
					0, 'asdfghjkl;', "'`", 0, 0, 'zxcvbnm,./',\		    ;
					0, '*', 0, ' ', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,\	    ;    It isn't shit
					0, '789-456+1230.', 0, 0				    ;
												    ;
	ascii_table_sh		db	0, '!@#$%^&*()_+', 8, ' ', 'QWERTYUIOP{}', 13,\ 	    ;    It is life  =)
					0, 'ASDFGHJKL:"~', 0, 0, 'ZXCVBNM<>?',\ 		    ;
					0, '*', 0, ' ', 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,\	    ;
					0, '789-456+1230.', 0, 0				    ;

	sound:
		in al, 61h	      ;
		jmp $+2 	      ;  timer is available
		or al, 3	      ;
		out 61h, al	      ;
		jmp $+2 	      ;

		mov eax, 2000h	      ;  frequence

		out 42h, al
		jmp $+2
		mov al, ah
		out 42h, al
		jmp $+2

		mov ecx, 0fffffh      ;  time for listen sound
		loop $

		in al, 61h	      ;
		jmp $+2 	      ;
		and al, 11111100b     ;   end of sound
		out 61h, al	      ;
		jmp $+2 	      ;

		ret