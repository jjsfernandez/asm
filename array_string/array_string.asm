; array_string.asm
; author: Joseje Sinohui
; Date: 5 apr 2017

%include "../functions.asm"

segment .bss
	array resb 20

section .text
	global _start

_start:
	pop ecx					; get number of arguments
	cmp ecx, 2				; check if there are less than 2 arguments
	jl quit
	pop eax					; get rid of the first argument
	dec ecx				
	mov edx, ecx			; save original number of arguments
	mov esi, array			; put array direction in ESI

cycle:
	pop eax					; get argument direction
	call stringcopy
	add esi, 10
	dec ecx					; one less argument
	cmp ecx, 0				; check if done with arguments
	jne cycle

mov ecx, edx 				; restore original number of arguments
mov esi, array

print:
	mov eax, esi			
	call sprintLF		
	add esi,10
	dec ecx
	cmp ecx, 0
	jne print
	
jmp quit

