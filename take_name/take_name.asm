; take_name.asm
; author: Joseje Sinohui
; Date: 18 apr 2017
; captures name

%include '../functions.asm'

section .data
    msg1 DB 'Cual es tu nombre?',0x0    
    msg2 DB 'Cual es tu edad?', 0x0

segment .bss
    buffer_nombre resb 20
    buffer_nombre_len equ $-buffer_nombre
    nombre RESB 20

    buffer_edad resb 3
    buffer_edad_len equ $-buffer_edad
    edad RESB 4

section .text
    GLOBAL _start

_start:
    ; print the first message
    mov eax, msg1
    call sprint
    ; prepare for capture
    mov ecx, buffer_nombre
    mov edx, buffer_nombre_len
    call ReadText
    ; move the input to variable
    mov eax, buffer_nombre
    mov esi, nombre
    call stringcopy

    ; same as before
    mov eax, msg2
    call sprint
    mov ecx, buffer_edad
    mov edx, buffer_edad_len
    call ReadText
    mov eax, buffer_edad
    call atoi
    ; move to value instead of address
    mov [edad], eax

    mov eax, [edad]
    call iprintLF

    mov eax, nombre
    call sprint
    
    jmp quit
    
