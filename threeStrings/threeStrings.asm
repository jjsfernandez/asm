; threeStrings.asm
; prints three strings
; author: Joseje Sinohui
; date: 06/03/2017

%include '../functions.asm'

section .data
    msg1 DB 'First', 0xA,0x0
    msg2 DB 'Second', 0xA,0x0
    msg3 DB 'Third', 0xA,0x0

section .text
    GLOBAL _start

_start:
    mov eax, msg1        ; load first msg
	call sprint			 ; call function to print
    

	mov eax, msg2        ; load second msg
   	call sprint

    mov eax, msg3       ; load third msg
    call sprint
   
	jmp quit	
