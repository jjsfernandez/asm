; Program: arguments.asm
; Date: March 16, 2017
; Author: Jose Jesus Sinohui

%include '../functions.asm'

section .text
  GLOBAL _start	

_start:			
  pop ecx		; Obtain number of arguments

ciclo:
  pop eax		; Obtain arguments
  call sprintLF ; Print arguments

  dec ecx		; Substract 1 to the number of arguments
  cmp ecx,0		; Checks if there are no more arguments
  jnz ciclo		; Repeat if not last
			
  call quit		
