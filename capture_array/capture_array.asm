; captures array content into a file
; author: Joseje Sinohui


%include '../functions.asm'

segment .bss
    buffer_name resb 20
	len_name equ $-buffer_name

	buffer_option resb 3
	len_option equ $-buffer_option

	buffer_file resb 2048
	len_file equ $-buffer_file

	name resb 20
	option resb 4
	file resb 2048
    array resb 200

section .text
    global _start

segment .data
    msg_captureStudent db "Insert the name of the student>", 0x0
	msg_printing db "Printing contents from the file...", 0x0
	msg_captureFile db "Insert the path to the file>",0x0 
	msg_exit db "Goodbye :)", 0x0
	msg_invalid db "Not valid",0x0
	menu db "~MENU~",0xa, "1.-Capture Student",0xa, "2.-Print",0xa,"3.-Save to file",0xa,"0.-Exit",0xa,"Pick an option",0xa,0x0

_start:

	mov eax, menu 		
	call sprint

	mov ecx, buffer_option 	
	mov edx, len_option
	call ReadText

	mov eax, buffer_option
	mov esi, option
	call stringcopy

	mov eax, option
	call atoi

	cmp eax, 1
	je read

	cmp eax, 2
	je print

	cmp eax, 3
	je save

    cmp eax, 0
    je exit
    

	jmp invalid



read:

    mov eax, msg_captureStudent                          
    call sprint                                     
    mov ecx, buffer_name
    mov edx, len_name
    call ReadText                                    ;waits for name input
    mov eax, buffer_name                             ;saves buffer_name to memory in eax
    mov esi, array
    add esi, ebx
    call stringcopy

    add ebx, 10
    inc ecx

    jmp _start                                       ;jump to _start to display menu again


print:

    mov esi, array

    prloop:
        mov eax, esi			
        call sprintLF		
        add esi,10
        dec ecx
        cmp ecx, 0
        jne prloop

    jmp _start


save:
	mov eax, msg_captureFile	;pregunta por nombre de archivo a guardar
	call sprint 				;imprime el mensaje

	mov ecx,buffer_file 		;captura en filename
	mov edx,len_file     		;con una longitud maxima de len_filename
	call ReadText 				;input desde el teclado

	mov esi, file 		        ;copia hasta archivo
	mov eax, buffer_file		;desde filename
	call copystring	 			;pero sin el caracter 0xA

;create file
	mov eax, sys_creat 			;sys_creat  EQU 8
	mov ebx, file   			;nombre de archivo 
	mov ecx, 511 				;511 = 	rwxr-xr-x
	int 0x80					;ejecuta (llama al sistema op.)

	cmp eax, 0
	jle error					;si es 0 o menos, error al crear


; open file for write
	mov eax, sys_open		;abrir archivo
	mov ebx, file	    	;nombre de archivo desde archivo
	mov ecx, O_RDWR			;abrir en modo de lectura y escritura
	int 0x80				;ejecutar 
	cmp eax,0
	jle error				;si es 0 o menos, error al abrir

	
;write
	mov ebx, eax 			;file handle a ebx

	mov eax, sys_write
	mov ecx, buffer_name
	mov edx, len_name
	int 0x80
	mov eax, sys_sync		;sincroniza discos (forzar escritura)
	int 0x80 				;sys_sync

;Close file 
	mov eax,sys_close	;
	int 0x80 			;
    jmp _start


invalid:
	mov eax, msg_invalid
	call sprintLF
	jmp _start

error:
	mov ebx, eax
	mov eax, sys_exit
	int 0x80

exit:
	mov eax, msg_exit
	call sprintLF
	jmp quit
