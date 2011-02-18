/*
; KupOS IRQ low-level handlers      |
;-----------------------------------+
*/
.intel_syntax noprefix
.include "macro.inc"
.include "define.inc"	
	
	_irq_master_end:		/* exit IRQ interruption */
		push eax
		mov al, 0x20
		out 0x20, al
		jmp .+2
		pop eax
		iret

	_irq_slave_end:			/* exit IRQ interruption */
		push eax
		mov al, 0x20
		out 0xA0, al
		jmp .+2
		pop eax
		iret

.macro def_irq_stub num controller
	ENTRY _irq\num
	
	.if \controller
		jmp _irq_master_end
	.else
		jmp _irq_slave_end
	.endif
.endm

.macro def_irq num controller
	ENTRY _irq\num
		
		call _do_irq\num	
	.if \controller
		jmp _irq_master_end
	.else
		jmp _irq_slave_end
	.endif
.endm

def_irq_stub 0 0
def_irq_stub 1 0
def_irq_stub 2 0
def_irq_stub 3 0
def_irq_stub 4 0
def_irq_stub 5 0
def_irq_stub 6 0
def_irq_stub 7 0
def_irq_stub 8 1
def_irq_stub 9 1
def_irq_stub 10 1
def_irq_stub 11 1
def_irq_stub 12 1
def_irq_stub 13 1
def_irq_stub 14 1
def_irq_stub 15 1
