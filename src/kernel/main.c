/*
	KupOS main routines
*/

#include <kupos/kernel.h>
#include <kupos/stdio.h>
#include <kupos/output.h>
#include <kupos/interrupts.h>
#include <kupos/syscall.h>
/*
#include <kupos/input.h>
#include <kupos/memory.h>
*/

void init_syscalls()
{
	set_usermode_gate(0x30, &syscall_handler);
}

void kernel_main(void)
{
    output_clear_screen();
	kprint("Starting main kernel init\n");
	init_syscalls();
	init_exceptions();
	init_irqs();
	enable_nmi();
	sti();
	kprintf("printf() call test\n%d %s %X %p", 42, "Hello", 0xFF, IDT);
	for(;;);									// <-- runs up to here without problems
	/* This is an old KupOS functionality ;) */
	/*clear_buf();
	clear_screen();
	puts("Kupec Operation System (KupOS)\nBeta-version 0.1\n");
	void* buffer = alloc_page();
	while (1)
	{
		puts("-> ");
		read_string((char**)(&buffer));
		putenter();
		perform();
	}*/
}
