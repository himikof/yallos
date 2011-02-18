#ifndef _INTERRUPTS_H_
#define _INTERRUPTS_H_

////////////////////////////////////////////////////////

struct idt_entry
{
   unsigned short offset_lo; // offset bits 0..15
   unsigned short selector;  // a code segment selector
   unsigned char zero;       // unused, set to 0
   unsigned char type_attr;  // type and attributes
   unsigned short offset_hi; // offset bits 16..31
};


extern struct idt_entry IDT[256];

#define sti() asm volatile ("sti"::)
#define cli() asm volatile ("cli"::)
#define nop() asm volatile ("nop"::)

#define iret() asm volatile ("iret"::)

#define enable_nmi() \
	asm volatile ( \
			"	xorb %%al, %%al \n" \
			"	outb %%al, $0x21 \n" \
			"	jmp .+2 \n" \
			"	outb %%al, $0xA1 \n" \
			"	jmp .+2 \n" \
			"	 \n" \
			"	inb $0x70, %%al  \n" \
			"	jmp .+2 \n" \
			"	andb $0x7f, %%al \n" \
			"	outb %%al, $0x70 \n" \
			"	jmp .+2 \n" \
			:: \
			)

#define set_gate(gate_addr, type, dpl, selector, handler_addr) \
	asm volatile (	"movw %%dx, %%ax\n\t" \
					"movl %%eax, (%1)\n\t" \
					"movw %0, %%dx\n\t" \
					"movl %%edx, 4(%1)\n\t" \
					: 	\
					: "i"((short)(0x8000|dpl<<13|type<<8)), \
						"r"((char*)gate_addr),	\
						"d"((char*)handler_addr), \
						"a"(selector<<16) \
			)

#define set_interrupt_gate(n, handler_addr)	set_gate(&IDT[n], 0xE, 0, 0x0008, handler_addr)
#define set_trap_gate(n, handler_addr)		set_gate(&IDT[n], 0xF, 0, 0x0008, handler_addr)
#define set_usermode_gate(n, handler_addr)	set_gate(&IDT[n], 0xE, 3, 0x0008, handler_addr)

////////////////////////////////////////////////////////

/*

	IDT layout:
		0x00-0x1f	: exceptions (trap || usermode)
		0x20-0x2f	: IRQs		  (interrupts)
		0x30		: syscall usermode interrupt

	IQRs:
		0x00		: System timer
		0x01		: Keyboard 
		0x02		: 
		0x03		: 
		0x04		: 
		0x05		: 
		0x06		: Floppy drive
		0x07		: 
		0x08-0x0f	: Reserved
*/

////////////////////////////////////////////////////////

#endif
