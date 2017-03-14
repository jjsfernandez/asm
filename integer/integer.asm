%include '../functions.asm'

section .data
	number DD 1958

section .text
	GLOBAL _start

_start:
	mov eax, [number]
	call iprintLF
	jmp quit
