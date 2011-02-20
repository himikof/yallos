OUTPUT_FORMAT("elf64-x86-64")
OUTPUT_ARCH(i386:x86-64)
ENTRY(boot_entry16)

SECTIONS
{
	. = 0x2000;
    .gdt : { *(.gdt) }
    .idt : { *(.idt) }
	. = 0x3000;
    .text.head : 
    {
		_system_text = .;
		*(.text.head)
	}
    .initdata : 
    {
		*(.initdata)
		*(.initdata.*)
	}
    .text : 
    {
		*(.text)
		*(.text.*)
	}
	.data :
	{
		*(.data)
		*(.data.*)
	}
	.bss :
	{
		*(.bss)
		*(.bss.*)
		*(COMMON)
		_end = .;
	}
}
