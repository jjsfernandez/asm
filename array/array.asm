; array.asm
; author: Joseje Sinohui
; Date: 3 apr 2017

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
	mov edx, 0				
	mov esi, array			; put array direction in ESI

cycle:
	pop ebx					; get argument direction
	mov eax, 0				; clear eax
	mov al, byte[ebx]		; get first letter
	mov byte[esi+edx], al	; save letter into array
	inc edx					; increase to save in next array positon on next iteration
	dec ecx					; one less argument
	cmp ecx, 0				; check if done with arguments
	jne cycle

print:
	mov eax, array			; point to array position to print
	call sprintLF			; print it
	
jmp quit


