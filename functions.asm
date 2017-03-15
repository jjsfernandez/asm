; functions.asm

sys_exit		equ 1
sys_read		equ 3
sys_write		equ 4
stdin			equ 0
stdout			equ 1
stderr			equ 3


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; function string length (strlen) ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

strlen:
    push ebx            ;save the value of ebx in the stack
    mov ebx, eax        

nextchar:
    cmp byte[eax], 0    ; compare eax with 0
    jz finish           ; if 0 jump to finish
    inc EAX             ; increment in 1 eax
    jmp nextchar        ; goes back

finish:
    sub eax, ebx        ; substract initial value
    pop ebx             ; brings back ebx 
    ret                 ; return to where the function was called
 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; function string print (sprint) ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
sprint:
    push edx            ; save values to stack
    push ecx
    push ebx
    push eax
    call strlen         ; get string length (stored in eax)
    mov edx, eax        ; move length to edx
    pop eax             ; restore eax
    mov ecx, eax        ; move eax (message) to ecx
    mov ebx, stdout      
    mov eax, sys_write  ; sys_write
    int 80h             ; execute
    pop ebx             ; restore other values
    pop ecx
    pop edx
    ret                 ; return to where the function was called


;; uses sprint and adds a new line at the end
sprintLF:
	call sprint 	
 	push EAX 	
 	mov EAX, 0xA
 	push EAX
 	mov EAX, ESP 	
 	call sprint 
 	pop EAX	
 	pop EAX
 	ret 			


;; uses iprint and adds a new line at the end
iprintLF:
	call iprint
 	push EAX 		
 	mov EAX, 0xA	
 	push EAX	
 	mov EAX, ESP 
 	call sprint 	
 	pop EAX		
 	pop EAX	
 	ret 			


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; function to print              ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

iprint:
	push eax		; save register values to the stack
	push ecx
	push edx
	push esi
	mov ecx, 0 		; initialize the counter

divloop:
	inc ecx;		; increment (will be used to print later)
	mov edx, 0		
	mov esi, 10
	idiv esi 
	add edx, 48
	push edx
	cmp eax, 0
	jnz divloop

printloop:
	dec ecx
	mov eax, esp
	call sprint		; call print function
	pop eax			; restore eax after print
	cmp ecx, 0		; keep printing until the end
	jnz printloop	; jump back if not zero
	pop esi			; restore values
	pop edx
	pop ecx
	pop eax
	ret


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;function to convert ascii to int;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
atoi:
	push ebx		; save registers to the stack
	push ecx
	push edx
	push esi

	mov esi, eax	; number to convert in eax
	mov eax, 0		; initialize with 0
	mov ecx, 0

	multcycle:			; multiplication cycle
	xor ebx, ebx		
	mov bl, [esi+ecx]
	cmp bl, 48
	jl finished
	cmp bl, 57
	jg finished
	cmp bl, 10
	je finished
	cmp bl, 0
	jz finished
	sub bl, 48
	add eax, ebx
	mov ebx, 10
	mul ebx
	inc ecx
	jmp multcycle

	finished:
	mov ebx, 10			; decimal value 10 to ebx
	div ebx				; eax/10
	pop esi				; restore the values
	pop edx
	pop ecx
	pop ebx
	ret

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; sequence to exit the program   ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
quit:
    mov eax, sys_exit          ; exit program
    int 0x80


