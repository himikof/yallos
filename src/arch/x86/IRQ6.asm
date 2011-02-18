	;---------------+
	; IRQ6 - Floppy |
	;---------------+

	int_26h:
		mov [floppy_int], 1

		jmp IRQ1_end

	floppy_int db 0

	;----- SUBROUTINE --------

	wait_floppy:
		cmp [floppy_int], 1
		jnz wait_floppy

		mov [floppy_int], 0
		ret
