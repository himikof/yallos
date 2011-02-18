	;---------------+
	; IRQ3 - Mouse  |
	;---------------+

	int_23h:
		mov byte [es:4], 'M'

		jmp IRQ1_end