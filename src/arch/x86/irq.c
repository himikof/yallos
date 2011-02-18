/*
	KupOS IRQ routines
*/
#include <kupos/kernel.h>
#include <kupos/interrupts.h>

/*
#define do_irq1_exit() __asm__ (	"pushl %%eax\n\t" \
									"movb 0x20, %%al\n\t" \
									"outb %%al, 0x20\n\t" \
									"jmp .+2\n\t" \
									"popl %%eax\n\t" \
									"iret\n\t" \
									:: \
								)

#define do_irq2_exit() __asm__ (	"pushl %%eax\n\t" \
									"movb 0x20, %%al\n\t" \
									"outb %%al, 0xA0\n\t" \
									"jmp .+2\n\t" \
									"popl %%eax\n\t" \
									"iret\n\t" \
									:: \
								)
*/

extern void irq0(void);
extern void irq1(void);
extern void irq2(void);
extern void irq3(void);
extern void irq4(void);
extern void irq5(void);
extern void irq6(void);
extern void irq7(void);
extern void irq8(void);
extern void irq9(void);
extern void irq10(void);
extern void irq11(void);
extern void irq12(void);
extern void irq13(void);
extern void irq14(void);
extern void irq15(void);

void init_irqs(void)
{
    set_interrupt_gate(0x20, irq0);
	set_interrupt_gate(0x21, irq1);
	set_interrupt_gate(0x22, irq2);
	set_interrupt_gate(0x23, irq3);
	set_interrupt_gate(0x24, irq4);
	set_interrupt_gate(0x25, irq5);
	set_interrupt_gate(0x26, irq6);
	set_interrupt_gate(0x27, irq7);
	set_interrupt_gate(0x28, irq8);
	set_interrupt_gate(0x29, irq9);
	set_interrupt_gate(0x2A, irq10);
	set_interrupt_gate(0x2B, irq11);
	set_interrupt_gate(0x2C, irq12);
	set_interrupt_gate(0x2D, irq13);
	set_interrupt_gate(0x2E, irq14);
	set_interrupt_gate(0x2F, irq15);
}

