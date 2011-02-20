.intel_syntax noprefix
.include "macro.inc"
.include "define.inc"
.include "syscalls_plain.inc"
/*
	;-------------------------------------------+
	;               M A I N                     |
	;-------------------------------------------+
*/
.globl main_com
main_com:
	mov al, CLEAR_BUF
	int INPUT

	mov al, CLEAR_SCREEN
	int OUTPUT

	mov esi, str_head_welcome
	mov al, PUTS
	int OUTPUT

	mov al, ALLOC_PAGE
	int MEMORY
	mov ebp, eax

.loop:
	mov esi, str_enter
	mov al, PUTS
	int OUTPUT

	mov esi, ebp
	mov al, READ_STR
	int INPUT

	mov al, PUTENTER
	int OUTPUT

	mov esi, ebp
	call perform

	jmp .loop

/*.include "commands.S"*/

/*--------------------------------------------------------*/

str_enter:			.asciz	"-> "
str_head_welcome:	.asciz	"Kupec Operation System (KupOS)\nBeta-version 0.1\n"
