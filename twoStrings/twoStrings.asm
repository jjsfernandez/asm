; twoStrings.asm
; prints two strings
; author: Joseje Sinohui
; date: 26/feb/2017

section .data
    msg1 DB 'First', 0xA,0x0    
    len1 EQU $ -msg1            ; length of first string
    msg2 DB 'Second', 0xA,0x0
    len2 EQU $ -msg2            ; lenght of second string

section .text
    GLOBAL _start

_start:
    mov EDX, len1               ; length of first string
    mov ECX, msg1               ; first string
    mov EBX, 1                  ; stdout(?)
    mov EAX, 4
    int 0x80

    mov EDX, len2               ; same as above but with
    mov ECX, msg2               ; second string.
    mov EBX, 1
    mov EAX, 4
    int 0x80
    
    mov EAX, 1                  ; (sys_exit)
    int 0x80                    ; call kernel
