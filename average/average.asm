; Program: summation.asm
; Date: March 28, 2017
; Author: Jose Jesus Sinohui

%include '../functions.asm'
section .data
	msj db "el promedio es: ", 0x0

segment .bss
	num_arg resb 4

section .text
	GLOBAL _start

_start:
	pop ecx				; Obtain number of arguments
	cmp ecx, 3			; checks if less than 2 arguments
	jl end				; ends the program if there are less 
	dec ecx
	pop eax
	mov [num_arg], ecx	; saves original number of arguments


ciclo:
	pop eax				 ; Obtain arguments
	call atoi			 ; ascii to integer function
	add ebx, eax		 ; does addition
	dec ecx				 ; Substract 1 to the number of arguments
	cmp ecx,0			 ; Checks if there are no more arguments
	jnz ciclo			 ; Repeat if not last
	mov eax, msj		 ; moves the message to eax
	call sprint			; prints the message
	mov eax, ebx	   	; moves sum to eax
	mov ecx, [num_arg]  ; divisor in ecx(number of arguments)
	idiv ecx
	call iprintLF 		; Prints the average
	jmp end

end:
	jmp quit
