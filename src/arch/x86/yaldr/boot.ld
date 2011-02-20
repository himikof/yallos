OUTPUT_FORMAT("elf32-i386", "elf32-i386", "elf32-i386")
OUTPUT_ARCH(i386)
ENTRY(ldr_start)
MEMORY
{
	bootloader : ORIGIN = 0x0000, LENGTH = 0x200
	image      : ORIGIN = 0x0000, LENGTH = 0x200	
}
SECTIONS
{
    .rodata.head : 
    {
		*(.rodata.head)
	} >bootloader AT>image
    .text : 
    {
		*(.text)
	} >bootloader AT>image
    .rodata : 
    {
		*(.rodata)
	} >bootloader AT>image
	.rodata.tail ALIGN(0x0000+0x200-4) :
	{
		*(.rodata.tail)
	} >bootloader AT>image
}
