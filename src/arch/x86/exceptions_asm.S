/*
; KupOS exceptions handler          |
;-----------------------------------+
*/

.intel_syntax noprefix
.include "macro.inc"
.include "define.inc"

exception_handler:

		pusha
		mov eax, [esp+32]
		
		call [eax]
		
		popa
		add esp, 12
		iret

.macro def_exception number, handler, push
ENTRY	_exception_\number
	.ifeq  \push
		push 0
	.endif
		push \number
		.comm _\handler, 4
		push offset _\handler
		jmp exception_handler
.endm

def_exception 0x00, do_division_error,		0		/* Division error, pushing 0 error code */
def_exception 0x01, do_debug,				0		/* Debug exception, pushing 0 error code */
def_exception 0x02, do_nmi,					0		/* NMI, pushing 0 error code */
def_exception 0x03, do_int3,				0		/* int3 (breakpoint), pushing 0 error code */
def_exception 0x04, do_overflow,			0		/* Overflow, pushing 0 error code */
def_exception 0x05, do_out_of_bounds,		0		/* Bound exception, pushing 0 error code */
def_exception 0x06, do_invalid_opcode,		0		/* Invalid opcode, pushing 0 error code */
def_exception 0x07, do_fpu_not_availiable,	0		/* FPU not availiable, pushing 0 error code */
def_exception 0x08, do_double_fault,		-1		/* Double fault, error code on stack */
def_exception 0x09, do_coprocessor_error,	0		/* Coprocessor segment overrun, pushing 0 error code */
def_exception 0x0A, do_invalid_tss,			-1		/* Invalid TSS, error code on stack */
def_exception 0x0B, do_segment_not_present,	-1		/* Segment not present, error code on stack */
def_exception 0x0C, do_stack_error,			-1		/* Stack error, error code on stack */
def_exception 0x0D, do_general_protection,	-1		/* General protection fault, error code on stack */
def_exception 0x0E, do_page_fault,			-1		/* Page fault, error code on stack */

/* exception 0x0F is reserved */

def_exception 0x10, do_fp_error,			0		/* FP error, pushing 0 error code */
def_exception 0x11, do_alignment_fault,		0		/* Alignment check fault, pushing 0 error code */
def_exception 0x12, do_machine_check_fault,	0		/* Machine check error, pushing 0 error code */

/* exceptions 0x13-0x1f are reserved */
