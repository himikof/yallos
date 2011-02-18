	;-------------------------------------------------------------------------------------------------------------------+
	;                                                                                                                   |
	;        INT 33h - MEMORY                                                                                           |
	;                                                                                                                   |
	;-------------------------------------------------------------------------------------------------------------------+

.include "syscalls_plain.inc"

;---------------------------------------------------------------------

	int_33h:		  ; al - number function memory
		cmp al, 3
		ja .FIN

		movsx eax, al
		call dword [eax*4 + int_33h_func]

	  .FIN:
		iret

;---------------------------------------------------------------------

	int_33h_func:
		dd	alloc_page
		dd	free_page
		dd	alloc_large_page
		dd	free_large_page

	;------------------------------------+
	;   A l l o c   P a g e              |
	;------------------------------------+

      alloc_page:  ; eax -> addr to memory
		push ebx esi ecx

		mov ebx, cr3
		add ebx, 8

		mov ecx, 1024-2

      .search_Table:
		test byte [ebx+1], 10b	       ;  9th bit = 0 ?       -      is free pages exist?
		jz .found_Table

		add ebx, 4
		loop .search_Table

      .err:
		mov al, -1
		jmp .FIN

      .found_Table:
		mov ecx, 1024
		mov esi, [ebx]
		and  si, 0f000h 		; clear 12 low bits

      .search_Page:
		test byte [esi+1], 10b	       ;  9th bit = 0 ?       -      is page free?
		jz .found_Page

		add esi, 4
		jmp .search_Page


      .found_Page:
		bts dword [esi], 9		;  9th bit = 1         -      this page is not free

		call check_free_full_table_of_page

		mov eax, [ebx]
		and  ax, 0f000h 	       ; clear 12 low bits
		sub esi, eax
		mov eax, cr3
		sub ebx, eax

		shl ebx, 20			; shr ebx, 2   ;    shl ebx, 22
		shl esi, 10			; shr esi, 2   ;    shl esi, 12
		lea eax, [ebx+esi]

      .FIN:
		pop ecx esi ebx
		ret

	;------------------------------------+
	;   F r e e     P a g e              |
	;------------------------------------+

      free_page: ; edx <- addr of memory
		push ebx esi

		mov ebx, edx
		mov esi, edx

		and ebx, 0ffc00000h
		and esi, 0004ff000h

		shr ebx, 20		; shl ebx, 2   ;    shr ebx, 22
		shr esi, 10		; shl esi, 2   ;    shr esi, 12

		mov eax, cr3
		mov eax, [ebx+eax]
		and  ax, 0f000h

		btr dword [eax+esi], 9

		call check_free_full_table_of_page

      .FIN:
		pop esi ebx
		ret

	;--------------------------------------+
	; Check for free of full table of page |
	;--------------------------------------+

	check_free_full_table_of_page:	; ebx - addr to record of this table ( 12-31 bits - address of table, 0-11 bits - properties )
		push ecx edx

		xor edx, edx
		mov eax, [ebx]
		and  ax, 0f000h
		mov ecx, 1024

	.check:
		test dword [eax+1], 10b 	; 9th bit = 0 ?      -        is page free ?
		jz .loop

		add eax, 4
		inc edx
	.loop:
		loop .check

		; edx - number of not free page

		test edx, edx
		jnz .not_zero

		; table of page is free

		bts dword [ebx], 10		; 10th bit = 1       -      table of page is free
		btr dword [ebx], 9		;  9th bit = 0       -      table of page isn't full

		jmp .FIN

	.not_zero:

		cmp dx, 1024
		jnz .not_1024

		btr dword [ebx], 10		; 10th bit = 0       -      table of page isn't free
		bts dword [ebx], 9		;  9th bit = 1       -      table of page is full

		jmp .FIN

	.not_1024:

		btr dword [ebx], 10		; 10th bit = 0       -      table of page isn't free
		btr dword [ebx], 9		;  9th bit = 0       -      table of page isn't full
	.FIN:
		pop edx ecx
		ret


	;--------------------------------------+
	;    A l l o c   L a r g e   P a g e   |
	;--------------------------------------+

	alloc_large_page: ; eax -> addr to memory
		push ebx

		mov ebx, cr3
		add ebx, 8

		mov ecx, 1024-2

	.search_Table:
		test byte [ebx+1], 100b 	; 10th bit = 0 ?       -      is table free?
		jnz .found_Table

		add ebx, 4
		loop .search_Table

	.err:
		mov al, -1
		jmp .FIN

	.found_Table:
		btr dword [ebx], 10		; 10th bit = 0       -      table of page isn't free

		mov eax, [ebx]
		and  ax, 0f000h
		mov eax, [eax]
		and  ax, 0f000h

	.FIN:
		pop ebx
		ret


	;--------------------------------------+
	;    F r e e    L a r g e    P a g e   |
	;--------------------------------------+

	free_large_page: ; edx <- addr to memory
		shr edx, 22
		shl edx, 2

		mov eax, cr3
		add eax, edx

		bts dword [eax], 10		; 10th bit = 1       -      table of page is free

		ret