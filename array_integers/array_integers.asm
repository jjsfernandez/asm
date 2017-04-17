; array integers.asm
; author: Joseje Sinohui
; Date: 6 apr 2017
; takes arguments, puts them in an array and prints their average

%include "../functions.asm"

segment .bss
	array resb 100
    num_arg resb 4

section .text
	global _start

_start:
	pop ecx					; get number of arguments
	cmp ecx, 2				; check if there are less than 2 arguments
	jl quit
	pop eax					; get rid of the first argument
	dec ecx				
	mov [num_arg], ecx		; save original number of arguments
	mov esi, array			; put array direction in ESI

cycle:
	pop eax					; get argument direction
    call atoi
    mov [esi], eax          ; moves eax to the array
	add esi, 4              ; moves the pointer
	dec ecx					; one less argument
	cmp ecx, 0				; check if done with arguments
	jne cycle

mov ecx, [num_arg] 			; restore original number of arguments
mov esi, array
mov ebx, 0                  ; ebx to store the sum

summation:
	mov eax, [esi]			; get number from array
    add ebx, eax             
	add esi, 4              ; moves the pointer of the array
	dec ecx
	cmp ecx, 0
	jne summation

mov eax, ebx                ;moving sum to eax
mov ecx, [num_arg]
idiv ecx
call iprintLF
	
jmp quit

