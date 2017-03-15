%include '../functions.asm'

section .data
	number DD 1958 
	string DD "789", 0x0		; String with numbers

section .text
	GLOBAL _start

_start:
	mov eax, [number]
	call iprintLF

	mov eax, string				; move the string to eax
	call atoi					; convert it to int
	call iprintLF				; print it

	jmp quit					; exit the program
