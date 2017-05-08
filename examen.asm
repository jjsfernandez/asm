

%include "functions.asm"

section .data
    msg1 db "alan",0x0
    msg2 db "99", 0x0
    coma db ",", 0x0

segment .bss
    msg3 resb 30

section .text
    global _start

_start:
    mov ESI, msg3      ; pone el puntero de msg3 en ESI

    mov EAX, msg1       ; poner el primer mensaje en EAX
    call copystring     ; copiar el mensaje a ESI (sin salto de linea)
    add ESI, 10         ; mover el puntero

    mov EAX, coma
    call copystring
    add ESI, 10

    mov EAX, msg2
    call copystring

    mov ESI, msg3
    mov eax, ESI
    call sprint
    add ESI, 10
    mov eax, ESI
    call sprint
    add ESI, 10
    mov eax, ESI
    call sprint
    jmp quit
