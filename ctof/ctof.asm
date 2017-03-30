; Program: ctof.asm
; takes an argument(celsius and converts it to farenheit)
; Author: Jose Jesus Sinohui Fernandez
; Date: March 30, 2017

%include '/home/joseje/git/asm/functions.asm'
section .text
    GLOBAL _start

_start:

    pop ecx             ; get number of arguments
    cmp ecx, 2          ; checks if there is only one argument
    jl quit

    dec ecx
    pop eax             ; gets rid of the first 2 arguments

cycle:
    pop eax             ; gets an argument
    dec ecx             ; decrease number of arguments
    
    call atoi           ; converts it to int
    call ctof
    call iprintLF       ; prints it
    cmp ecx, 0          ; checks if there are more arguments
    jnz cycle

jmp quit
 

