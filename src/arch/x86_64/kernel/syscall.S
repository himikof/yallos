.intel_syntax noprefix
.include "macro.inc"

.text

/*
	Ok, this is the 0x30 interrupt gate handler (syscall function)
	EAX				- Syscall number
	EDX				- First parameter
	ECX				- Second parameter
	EBX				- Third parameter
	[ESP+?]			- Pointer to the other parameters
	
	Return value should be in EAX
*/
/*--------------------------------------------------------------------*/

ENTRY	syscall_handler
		
		
		cmp eax, __syscall_table_sz
		jae syscall_bad

		push rax
		mov eax, dword ptr [__syscall_table + eax*8 + 4]
		cmp eax, 3
		jna 1f
		sub eax, 3
		
		
	1:	
		mov eax, [esp+eax*4]

		call qword ptr [__syscall_table + eax*8]

	syscall_ret:
		iret
	
	syscall_bad:
		mov eax, -1
		jmp syscall_ret;

/*--------------------------------------------------------------------*/

/*
	"Empty" system call (just a stub)
*/
.align 8
ENTRY sys_stub
		ret
