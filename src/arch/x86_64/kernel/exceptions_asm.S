/*
; KupOS exceptions handler          |
;-----------------------------------+
*/

.intel_syntax noprefix
.include "macro.inc"
.include "define.inc"

exception_handler:

		push rax
		mov rax, [esp+32]
		
		call [rax]
		
		pop rax
		add esp, 12
		iret

.macro def_exception number, handler, push
ENTRY	exception_\number
	.ifeq  \push
		push 0
	.endif
		push \number
		.comm _\handler, 4
		push offset _\handler
		jmp exception_handler
.endm

def_exception 0x00, do_division_error,		0		/* Division error, fault, pushing 0 error code */
def_exception 0x01, do_debug,				0		/* Debug exception, f/trap , pushing 0 error code */
def_exception 0x02, do_nmi,					0		/* NMI, pushing 0 error code */
def_exception 0x03, do_int3,				0		/* int3 (breakpoint), trap, pushing 0 error code */
def_exception 0x04, do_overflow,			0		/* Overflow, trap, pushing 0 error code */
def_exception 0x05, do_out_of_bounds,		0		/* Bound exception, fault, pushing 0 error code */
def_exception 0x06, do_invalid_opcode,		0		/* Invalid opcode, fault, pushing 0 error code */
def_exception 0x07, do_fpu_not_availiable,	0		/* FPU not availiable, fault, pushing 0 error code */
def_exception 0x08, do_double_fault,		-1		/* Double fault, abort, error code on stack */
def_exception 0x09, do_coprocessor_error,	0		/* Coprocessor segment overrun, abort, pushing 0 error code */
def_exception 0x0A, do_invalid_tss,			-1		/* Invalid TSS, fault, error code on stack */
def_exception 0x0B, do_segment_not_present,	-1		/* Segment not present, fault, error code on stack */
def_exception 0x0C, do_stack_error,			-1		/* Stack error, fault, error code on stack */
def_exception 0x0D, do_general_protection,	-1		/* General protection fault, fault, error code on stack */
def_exception 0x0E, do_page_fault,			-1		/* Page fault, fault, error code on stack */

/* exception 0x0F is reserved */

def_exception 0x10, do_fp_error,			0		/* FP error, fault, pushing 0 error code */
def_exception 0x11, do_alignment_fault,		0		/* Alignment check fault, fault, pushing 0 error code */
def_exception 0x12, do_machine_check_fault,	0		/* Machine check error, pushing 0 error code */

/* exceptions 0x13-0x1f are reserved */
