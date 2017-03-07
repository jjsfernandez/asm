; sum.asm
; sums 2 bytes
; Author: Joseje Sinohui
; 6/03/17

section .data
    a DB "4"
    b DB "5"
    msg db "La suma es: ", 0x0
    len equ $ - msg
    vac db " ", 0xA, 0x0
    lv equ $ - vac

segment .bss
    sum resb 1

section .text
    global _start

_start:
    mov eax, [a]        ; prepare numbers
    sub eax, '0'

    mov ebx, [b]
    sub ebx, '0'

    add eax, ebx
    add eax, '0'
    mov [sum], eax

    mov ecx, msg        ; print msg
    mov edx, len
    mov ebx, 1
    mov eax, 4
    int 0x80

    mov ecx, sum        ; print sum
    mov edx, 1
    mov ebx, 1
    mov eax, 4
    int 0x80;

    mov ecx, vac        ; print empty line
    mov edx, lv
    mov ebx, 1
    mov eax, 4
    int 0x80

    mov eax, 1          ; exit program
    int 0x80

