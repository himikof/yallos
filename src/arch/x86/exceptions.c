/*
	KupOS exception-handling routines
*/

#include <kupos/kernel.h>
#include <kupos/interrupts.h>

struct registers
{
	unsigned int edi, esi, ebp, esp, ebx, edx, ecx, eax;
};

extern void exception_0x00(void);
extern void exception_0x01(void);
extern void exception_0x02(void);
extern void exception_0x03(void);
extern void exception_0x04(void);
extern void exception_0x05(void);
extern void exception_0x06(void);
extern void exception_0x07(void);
extern void exception_0x08(void);
extern void exception_0x09(void);
extern void exception_0x0A(void);
extern void exception_0x0B(void);
extern void exception_0x0C(void);
extern void exception_0x0D(void);
extern void exception_0x0E(void);
extern void exception_0x10(void);
extern void exception_0x11(void);
extern void exception_0x12(void);

void init_exceptions(void)
{
	set_trap_gate(0x00, &exception_0x00);
	set_trap_gate(0x01, &exception_0x01);
	set_trap_gate(0x02, &exception_0x02);
	set_trap_gate(0x03, &exception_0x03);
	set_trap_gate(0x04, &exception_0x04);
	set_trap_gate(0x05, &exception_0x05);
	set_trap_gate(0x06, &exception_0x06);
	set_trap_gate(0x07, &exception_0x07);
	set_trap_gate(0x08, &exception_0x08);
	set_trap_gate(0x09, &exception_0x09);
	set_trap_gate(0x0A, &exception_0x0A);
	set_trap_gate(0x0B, &exception_0x0B);
	set_trap_gate(0x0C, &exception_0x0C);
	set_trap_gate(0x0D, &exception_0x0D);
	set_trap_gate(0x0E, &exception_0x0E);

	set_trap_gate(0x10, &exception_0x10);
	set_trap_gate(0x11, &exception_0x11);
	set_trap_gate(0x12, &exception_0x12);
}

/* Division error */
void do_division_error (struct registers* regs, long addr, long exception_code, long error_code)		
{
}

/* Debug exception, pushing 0 error code */
void do_debug (struct registers* regs, long addr, long exception_code, long error_code)
{
}

/* NMI, pushing 0 error code */
void do_nmi (struct registers* regs, long addr, long exception_code, long error_code)
{
}

void do_int3 (struct registers* regs, long addr, long exception_code, long error_code)		
{
}

/* Overflow, pushing 0 error code */
void do_overflow (struct registers* regs, long addr, long exception_code, long error_code)		
{
}

/* Bound exception, pushing 0 error code */
void do_out_of_bounds (struct registers* regs, long addr, long exception_code, long error_code)		
{
}

/* Invalid opcode, pushing 0 error code */
void do_invalid_opcode (struct registers* regs, long addr, long exception_code, long error_code)
{
}

/* FPU not availiable, pushing 0 error code */
void do_fpu_not_availiable (struct registers* regs, long addr, long exception_code, long error_code)		
{
}

/* Double fault, error code on stack */
void do_double_fault (struct registers* regs, long addr, long exception_code, long error_code)	
{
}

/* Coprocessor segment overrun, pushing 0 error code */
void do_coprocessor_error (struct registers* regs, long addr, long exception_code, long error_code)		
{
}

/* Invalid TSS, error code on stack */
void do_invalid_tss (struct registers* regs, long addr, long exception_code, long error_code)		
{
}

/* Segment not present, error code on stack */
void do_segment_not_present (struct registers* regs, long addr, long exception_code, long error_code)		
{
}

/* Stack error, error code on stack */
void do_stack_error (struct registers* regs, long addr, long exception_code, long error_code )
{
}

/* General protection fault, error code on stack */
void do_general_protection (struct registers* regs, long addr, long exception_code, long error_code )
{
}

/* Page fault, error code on stack */
void do_page_fault (struct registers* regs, long addr, long exception_code, long error_code )		
{
}

/* FP error, pushing 0 error code */
void do_fp_error (struct registers* regs, long addr, long exception_code, long error_code )		
{
}

/* Alignment check fault, pushing 0 error code */
void do_alignment_fault (struct registers* regs, long addr, long exception_code, long error_code )		
{
}

/* Machine check error, pushing 0 error code */
void do_machine_check_fault (struct registers* regs, long addr, long exception_code, long error_code )		
{
}

void _print_info(struct registers* regs, long addr, long exception_code, char* name, long error_code)
{
}
