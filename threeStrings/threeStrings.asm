; threeStrings.asm
; prints three strings
; author: Joseje Sinohui
; date: 06/03/2017

section .data
    msg1 DB 'First', 0xA,0x0
    msg2 DB 'Second', 0xA,0x0
    msg3 DB 'Third', 0xA,0x0

section .text
    GLOBAL _start

_start:
    mov eax, msg1        ; load first msg
	call sprint			 ; call function to print
    

	mov eax, msg2        ; load second msg
   	call sprint

    mov eax, msg3       ; load third msg
    call sprint
   
	jmp quit	
	

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
	push edx			; save values to stack
	push ecx
	push ebx
	push eax
	call strlen			; get string length (stored in eax)

	mov edx, eax		; move length to edx
	pop eax				; restore eax
	mov ecx, eax		; move eax (message) to ecx
	mov ebx, 1			; stdout
	mov eax, 4			; sys_write
	int 80h				; execute

	pop ebx				; restore other values
	pop ecx
	pop edx
	ret 				; return to where the function was called


quit:
	mov eax, 1			; exit program
	int 0x80

