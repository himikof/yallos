OUTPUT_FORMAT("elf32-i386", "elf32-i386", "elf32-i386")
OUTPUT_ARCH(i386)
ENTRY(boot_entry16)

SECTIONS
{
	. = 0x2000;
    .gdt : { *(.gdt) }
    .idt : { *(.idt) }
	. = 0x3000;
    .text.boot : 
    {
		_system_text = .;
		*(.text.boot)
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
