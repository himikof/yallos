OUTPUT_FORMAT("elf32-i386", "elf32-i386", "elf32-i386")
OUTPUT_ARCH(i386)
ENTRY(ldr_start)

MEMORY
{
    MBR (rwx) : org = 0x7c00, len = 0x0200
}

SECTIONS
{
    .text : {
        *(.rodata.head)
        *(.text)
        *(.rodata)
        . =  0x200 - 4;
        *(.rodata.tail)
    }
}
