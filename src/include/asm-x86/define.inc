/* Addresses */

//CAT_OF_CAT    	=	0x00000000
//FIRST_CAT   		=	0x00001000
KERNEL_LOAD_ADDR	=	0x00002000
BOOT_ENTRY16    	=	0x00003000
//FLOPPY_MEM	   	=	OS_HEAD
//MAIN_COMMANDS   	=	0x00013000
END_STACK	    	=	0x003efff0
BEG_STACK	    	=	0x003ffffc
SYS_STACK_ESP   	=	BEG_STACK - END_STACK
//SECOND_CAT	    	=	0x00400000
//LOW_MEM		    	=	0x00800000


/* Ports */

FLOPPY_PORT		=		0x03F2
CMOS_PORT		=		0x70
