; Program: summation.asm
; Date: March 28, 2017
; Author: Jose Jesus Sinohui

%include '../functions.asm'

section .text
  GLOBAL _start

_start:
  pop ecx       ; Obtain number of arguments
  cmp ecx, 3	; compares if less than 3 arguments
  jl end		; ends program if less than 3

ciclo:
  pop eax       ; Obtain arguments
  call atoi     ; ascii to integer function
  add ebx, eax	; does addition
  dec ecx       ; Substract 1 to the number of arguments
  cmp ecx,0     ; Checks if there are no more arguments
  jnz ciclo     ; Repeat if not last
  mov eax, ebx
  call iprintLF ; Prints the sum
  jmp end
 
end:
	jmp quit

