; holamundo.asm
; imprime holamundo
; autor: Joseje Sinohui
; fecha: 23 de febrero de 2k17

section .data
	msj DB 'Hola mundo',0xA,0x0
	lon EQU $ - msj

section .text
	global _start

_start:
	mov EDX, lon
	mov ECX, msj
	mov EBX, 1
	mov EAX, 4
	int 0x80
	mov EAX , 1
	int 0x80
