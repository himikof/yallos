.intel_syntax noprefix
.include "macro.inc"
.include "define.inc"
.include "syscalls_plain.inc"

.text

ENTRY strcmp 				/* ds:esi, es:edi - 2 strings     ecx - length of anyone string */
		push ecx
		push esi
		push edi

		repe cmpsb

		pop edi
		pop esi
		pop ecx
		ret

ENTRY	strlen 				/* es:edi - string        ecx -> length of string */
		push edi

		xor ecx, ecx
		dec ecx
		mov al, 0

		repne scasb

		neg ecx
		dec ecx
		dec ecx

		pop edi
		ret



					
ENTRY	perform				/* esi - string */
		mov edx, esi		/* edx - start of string */

	   .LOOP:
		cmp byte ptr [esi], 0
		je .OK
		cmp byte ptr [esi], ' '
		je ._OK

		or byte ptr [esi], 0x20
		inc esi

		jmp .LOOP

	  ._OK:
		mov byte ptr [esi], 0
	   .OK:

		lea ebx, [esi+1]

		mov edi, edx
		call strlen

		mov esi, edx
		mov edx, table_command

	.LOOP2:
		mov edi, [edx]

		call strcmp
		jz to_command

		add edx, 8
		cmp dword ptr [edx], 0
		jnz .LOOP2

	/*	; switch } */

	    FIN:
		ret

	   to_command:
		jmp dword ptr [edx+4]

/*
	;------------------------------+
	;        COMMANDS              |
	;------------------------------+
*/

	   about:
		mov esi, str_about_KupOS
		mov al, PUTS
		int OUTPUT

		jmp FIN

	   clrscr:
		mov al, CLEAR_SCREEN
		int OUTPUT

		jmp FIN

	   reset:
		mov al, 0xfe
		out 0x64, al
		jmp .

	   time:



		jmp FIN

	   echo:
		mov esi, ebx
		mov al, PUTS
		int OUTPUT

		mov al, PUTENTER
		int OUTPUT

		jmp FIN

.data

table_command:
	.long	str_reset
	.long	reset

	.long	str_echo
	.long	echo

	.long	str_clrscr
	.long	clrscr

	.long	str_about
	.long	about

	.long	str_time
	.long	time

	.long	0


str_reset:	.asciz	"reset"
str_echo:	.asciz	"echo"
str_clrscr:	.asciz	"clrscr"
str_about:	.asciz	"about"
str_time:	.asciz	"time"

str_about_KupOS:	.asciz	"KupOS 0.1\nCreated by Dmitriy Kostromin aka Kupec\n"
