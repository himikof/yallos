	;------------------+
	; IRQ0 - Timer     |
	;------------------+


	int_20h:
		cmp [timer_wait], 0
		jz .timer_done

		dec [timer_wait]

	.timer_done:
		jmp IRQ1_end


	    ; timer

	    timer_wait db 0

	;----- SUBROUTINE --------

	wait_tick:		       ; 1 tick  =  1 / 18.2 seconds
		mov [timer_wait], al
	     .wait:
		cmp [timer_wait], 0
		jnz .wait

		ret

