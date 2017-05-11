%include '../functions.asm'

segment .bss
    numero resb 300
    arreglote resb 300

section .text
  GLOBAL _start


_start:
    mov esi, numero

    mov eax, 30
    mov edx, arreglote
    mov [edx], eax
    
    mov eax, [edx]
    call itoa

    mov eax, esi
    call sprint

    jmp quit
    
