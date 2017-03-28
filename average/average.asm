; Program: summation.asm
; Date: March 28, 2017
; Author: Jose Jesus Sinohui

%include '../functions.asm'

section .text
  GLOBAL _start

_start:
  pop ecx       ; Obtain number of arguments
  cmp ecx, 3	; checks if less than 2 arguments
  jl end		; ends the program if there are less 
  dec ecx
  pop eax
  mov edx, ecx	; saves original number of arguments


ciclo:
  pop eax       ; Obtain arguments
  call atoi     ; ascii to integer function
  add ebx, eax  ; does addition
  dec ecx       ; Substract 1 to the number of arguments
  cmp ecx,0     ; Checks if there are no more arguments
  jnz ciclo     ; Repeat if not last

  mov eax, ebx	; moves sum to eax
  mov ecx, edx  ; divisor in ecx(number of arguments)
  mov edx, 0	; edx must be in 0
  idiv ecx
  call iprintLF ; Prints the average

  jmp end

end:
	jmp quit
