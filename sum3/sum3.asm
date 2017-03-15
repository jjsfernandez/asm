; sum3.asm

%include '../functions.asm'

section .data
	num1		DD 543		; integer
	string1		DB "789"	; string of numbers 
	num2 		DD 888		; second integer

segment .bss
	sum resb 4			;reserve 4 bytes

section .text
	GLOBAL _start

_start:
	mov eax, string1
	call atoi
	mov [sum], eax
	mov ebx, [num1]
	add eax, ebx
	mov ebx, [num2]
	add eax, ebx
	call iprintLF

	jmp quit
