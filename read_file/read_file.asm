; read file 
; author: Joseje Sinohui

%include '../functions.asm'

segment .bss
    buffer resb 2048
    len equ $-buffer

section .text
    global _start

_start:
    pop ecx
    cmp ecx, 2
    jl exit                 ; check if there are existing arguments
    pop eax
    dec ecx

    ; opens file
    pop ebx             ;file name
    mov eax, sys_open
    mov ecx, O_RDONLY
    int 0x80
    cmp eax, 0
    jle error

    ; read file
    mov ebx, eax
    mov eax, sys_read
    mov ecx, buffer
    mov edx ,len
    int 0x80

    ;close file
    mov eax, sys_close
    int 0x80

    mov eax, buffer
    call sprintLF

exit:
    jmp quit

error:
    mov ebx, eax
    mov eax, sys_exit
    int 0x80

