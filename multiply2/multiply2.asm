; Program: multiply2.asm
; Date: March 27, 2017
; Author: Jose Jesus Sinohui

%include '../functions.asm'

section .text
  GLOBAL _start

_start:
  pop ecx       ; Obtain number of arguments
  cmp ecx, 3	; compares if number of arguments less than 3
  jl end		; if true jump to end
  pop eax       ; delete the first argument from the cycle

  pop eax		; first argument
  call atoi		; convert to ascii
  mov ebx, eax	; move value to ebx
  pop eax		; get next argument
  call atoi		; convert to ascii
  imul eax, ebx	; multiply the 2 numbers
  call iprintLF	; print the multiplication

end:
  jmp quit


