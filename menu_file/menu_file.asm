; menu to manage files
; author: Joseje Sinohui


%include '../functions.asm'

segment .bss
   buffer_nombre resb 20
	len_nombre equ $-buffer_nombre

	buffer_opcion resb 3
	len_opcion equ $-buffer_opcion

	buffer_archivo resb 2048
	len_archivo equ $-buffer_archivo

	nombre resb 20
	opcion resb 4
	archivo resb 2048

section .text
    global _start
segment .data
	msg_imprimiendo db "Printing contents from the file...", 0x0
	msg_leyendo db "Insert the path to the file>",0x0 
	msg_saliendo db "Baiiii", 0x0
	mensaje_valido db "Not valid",0x0
	menu db "~MENU~",0xa, "1.-Read File",0xa, "2.-Print File",0xa,"0.-Exit",0xa,"Pick an option",0xa,0x0
_start:
	mov EAX,menu 		
	call sprint

	mov ECX, buffer_opcion 	
	mov EDX, len_opcion
	call ReadText

	mov EAX, buffer_opcion
	mov ESI, opcion
	call stringcopy

	mov EAX, opcion
	call atoi

	cmp EAX, 1
	je leer

	cmp EAX, 2
	je imprimir

	cmp EAX, 0
	je exit
    

	jmp invalid


leer:
	mov EAX, msg_leyendo
	call sprint

	mov ECX, buffer_nombre
	mov EDX, len_nombre
	call ReadText

	mov EAX, buffer_nombre
	mov ESI, nombre

	call copystring

	jmp _start

imprimir:
	mov EBX, nombre
	mov EAX, sys_open
	mov ECX, O_RDONLY
	int 0x80

	cmp EAX, 0
	jle error


	mov EBX, EAX
	mov EAX, sys_read
	mov ECX, buffer_archivo
	mov EDX, len_archivo
	int 0x80

	mov EAX, sys_close
	int 0x80

	mov EAX, buffer_archivo
	call sprintLF

	jmp _start






invalid:
	mov eax, mensaje_valido
	call sprintLF
	jmp _start

error:
	mov EBX,EAX
	mov EAX,sys_exit
	int 0x80

exit:
	mov eax, msg_saliendo
	call sprintLF
	jmp quit
