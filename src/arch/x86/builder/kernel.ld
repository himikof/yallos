OUTPUT_FORMAT("elf32-i386", "elf32-i386", "elf32-i386")
OUTPUT_ARCH(i386)
ENTRY(start)
SECTIONS
{
	. = 0x2000;
    .gdt : 
    {
		*(.gdt)
	}
    .idt : 
    {
		*(.idt)
	}
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
