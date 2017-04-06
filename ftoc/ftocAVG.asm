; Program ftocAVG.asm
; takes arguments converts them to celsius and calculates the average
; Author: Jose Jesus Sinohui
; Date: April 4, 2017

%include '../functions.asm'
section .data
	msj db "The avg of the temperatures in celsius is: ", 0x0

segment .bss
	num_arg resb 4

section .text
	GLOBAL _start

_start:
	pop ecx				; Obtain number of arguments
	cmp ecx, 3			; checks if there are enough arguments
	jl quit

	pop eax				; get the name of the program out
	dec ecx

	mov [num_arg], ecx	; saves the number of arguments to calculate avg later
	
cycle:
	pop eax				; get the argument
	call atoi			; make it an integer
	call ftoc			; convert it to celsius
	add ebx, eax		; does addition
	dec ecx				; one less argument
	cmp ecx, 0			; checks if there are more arguments
	jnz cycle			

mov eax, msj		; print msj
call sprint			
mov eax, ebx		; sum to eax
mov ecx, [num_arg]	; divisor in ecx(number of arguments)
idiv ecx			; does division, result already in eax so it prints
call iprintLF
jmp quit
	
	
