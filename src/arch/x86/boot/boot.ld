OUTPUT_FORMAT("pe-i386", "pe-i386", "pe-i386")
OUTPUT_ARCH(i386)
ENTRY(_start)
MEMORY
{
	bootloader : ORIGIN = 0x0000, LENGTH = 0x200
	image      : ORIGIN = 0x0000, LENGTH = 0x200	
}
SECTIONS
{
    .rodata : 
    {
		*(.rodata)
	} >bootloader AT>image
    .text : 
    {
		*(.text)
	} >bootloader AT>image
    .data : 
    {
		*(.data)
	} >bootloader AT>image
	.data.tail ALIGN(0x0000+0x200-4) :
	{
		*(.data.tail)
	} >bootloader AT>image
}