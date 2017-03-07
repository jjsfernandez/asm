; threeStrings.asm
; prints three strings
; author: Joseje Sinohui
; date: 06/03/2017

section .data
    msg1 DB 'First', 0xA,0x0
    msg2 DB 'Second', 0xA,0x0
    msg3 DB 'Third', 0xA,0x0

section .text
    GLOBAL _start

_start:
    mov eax, msg1        ; load first msg
    call strlen
    mov edx, eax
    mov ecx, msg1
    mov eax, 4
    mov ebx, 1
    int 0x80

	mov eax, msg2        ; load second msg
    call strlen
    mov edx, eax
    mov ecx, msg2
    mov eax, 4
    mov ebx, 1
    int 0x80

	mov eax, msg3       ; load third msg
    call strlen
    mov edx, eax
    mov ecx, msg3
    mov eax, 4
    mov ebx, 1
    int 0x80

	mov eax, 1			; exit program
	int 0x80

strlen:
    push ebx            ;save the value of ebx in the stack
    mov ebx, eax        

nextchar:
    cmp byte[eax], 0    ; compare eax with 0
    jz finish           ; if 0 jump to finish
    inc EAX             ; increment in 1 eax
    jmp nextchar        ; goes back

finish:
    sub eax, ebx        ; substract initial value
    pop ebx             ; brings back ebx 
    ret                 ; return to where the function was called
