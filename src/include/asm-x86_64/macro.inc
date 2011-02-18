/*
.macro TSTR2 name, [char]
{
        local current,ch

        label name dword

        virtual at 0
                db char
                count = $
        end virtual

        current = 0
        while current < count
                virtual at 0
                        db char
                        load ch byte from current
                end virtual

                db ch
                db 87h

                current = current + 1
        end while

        name#_sz  = ($ - name) / 2
}
*/

/*
.macro TSTR name, [char]
{
        common
                label name dword
        forward
                db char

        name#_sz  = $ - name
}
*/


.macro _sound
                in al, 0x61           
                jmp .+2               /*;  timer is available*/
                or al, 3              
                out 0x61, al           
                jmp .+2               

                mov eax, 0x2000       /*;  frequence*/

                out 0x42, al
                jmp .+2
                mov al, ah
                out 0x42, al
                jmp .+2

                mov ecx, 0x00ffffff      /*;  time for listen sound*/
                loop .

                in al, 0x61           
                jmp .+2               
                and al, 0b11111100     /*;   end of sound*/
                out 0x61, al           
                jmp .+2               
.endm

.macro dwIDT address, arg1, arg2
	.word (\address & 0xFFFF), \arg1, \arg2, (\address & 0xFFFF0000) >> 16
.endm

.macro ENTRY name
	.globl \name
	\name:
.endm

.macro def_syscall name, argc
	.comm \name, 8
	.long \name, \argc
.endm

/* outputs reg at di/2 position, moves di if stay==0 */
.macro OUTPUT reg stay
        push ax
        push bx
        push cx
        push es
        mov bx, \reg
        mov ax, 0xb800
        mov es, ax
        mov cx, 4
	1:
		mov al, bh
		shr al, 4
		add al, 0x30
        cmp al, 0x39
        jbe 2f
        add al, 7
	2:
        mov ah, 0x04
        stosw
        shl bx, 4
        loop 1b
        mov ax, 0x0420
        stosw
    .if \stay
        sub di, 10
    .endif
        pop es
        pop cx
        pop bx
        pop ax
.endm

.macro PRINT_EBP_AS_NUMBER
	local .qwer
	local .put

        mov ecx, 8
.qwer:
        mov eax, ebp
        shl ebp, 4
        and eax, 0f0000000h
        shr eax, 28
        or  al,  30h

	cmp al, 39h
	jb .put

	add al, 7

.put:

        mov dl, al
        mov al, 1
        int 30h

        loop .qwer

	mov dl, 13
	int 30h
	mov dl, 10
	int 30h
.endm
