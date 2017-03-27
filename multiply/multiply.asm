; Program: multiply.asm
; Date: March 27, 2017
; Author: Jose Jesus Sinohui

%include '../functions.asm'

section .text
  GLOBAL _start

_start:
  pop ecx       ; Obtain number of arguments
  pop eax		; delete the first argument from the cycle
  dec ecx
  mov ebx, 1h

ciclo:
  pop eax       ; Obtain arguments
  call atoi		; ascii to integer function
  imul ebx, eax
  dec ecx       ; Substract 1 to the number of arguments
  cmp ecx,0     ; Checks if there are no more arguments
  jnz ciclo     ; Repeat if not last
  mov eax, ebx
  call iprintLF ; Print multiplication
  jmp quit

