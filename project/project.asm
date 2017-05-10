%include '../functions.asm'

segment .bss
    name_buffer resb 50
	name_len equ $-name_buffer

	option_buffer resb 3
	option_len equ $-option_buffer

	file_buffer resb 2048
	file_len equ $-file_buffer

	option resb 4
	file resb 2048
    array resb 300
    arry_len equ $-array

section .text
    global _start

segment .data
    msg_archivo_no_encontrado db "No se encontro el archivo especificado, iniciando con arreglo vacio...", 0x0
	msg_printing db "Printing names...", 0x0
	msg_captureFile db "Insert the path to the file>",0x0 
	msg_exit db "Goodbye :)", 0x0
	msg_invalid db "Not valid",0x0
    
	menu db "       ~MENU~",0xa,"1.- Capturar Alumno",0xa,"2.- Capturar Calificaciones",0xa,"3.- Mostrar alumnos en pantalla",0xa,"4.- Guardar Archivo",0xa,"0.- Salir",0xa,"Opcion >",0x0

_start:
    
    ;; Checar argumentos y guardar el archivo en el buffer si existe
    pop ecx
    cmp ecx, 2
    jl no_file                 
    pop eax
    dec ecx

    ; Abrir archivo
    pop ebx             ;file name
    mov eax, sys_open
    mov ecx, O_RDONLY
    int 0x80
    cmp eax, 0
    jle error

    ; Leer Archivo
    mov ebx, eax
    mov eax, sys_read
    mov ecx, file_buffer
    mov edx ,file_len
    int 0x80

    ; Cerrar archivo
    mov eax, sys_close
    int 0x80

    mov eax, file_buffer
    call sprintLF

display_menu:
    ; muestra el menu
    mov eax, menu 		            
    call sprint

    mov ecx, option_buffer 	
    mov edx, option_len
    call ReadText

    mov eax, option_buffer
    mov esi, option
    call stringcopy

    mov eax, option
    call atoi

    cmp eax, 1
    je capturar_alumno

    cmp eax, 2
    je capturar_calificaciones

    cmp eax, 3
    je mostrar_pantalla

    cmp eax, 4
    je guardar_archivo

    cmp eax, 0
    je exit
    

    jmp invalid


capturar_alumno:
    ;to do
    jmp display_menu

    
capturar_calificaciones:
    ;to do
    jmp display_menu

mostrar_archivo:
    ;to do
    jmp display_menu

guardar_archivo:
    ;to do
    jmp display_menu

mostrar_pantalla:




no_file:
    mov eax, msg_archivo_no_encontrado
    call sprintLF
    jmp display_menu

invalid:
	mov eax, msg_invalid
	call sprintLF
	jmp display_menu

error:
	mov ebx, eax
	mov eax, sys_exit
	int 0x80

exit:
	mov eax, msg_exit
	call sprintLF
	jmp quit
