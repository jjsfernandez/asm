%include '../functions.asm'

segment .bss
    name_buffer resb 30
	name_len equ $-name_buffer

    calificacion_buffer resb 4
    calificacion_len equ $-calificacion_buffer

	option_buffer resb 3
	option_len equ $-option_buffer

	file_buffer resb 2048
	file_len equ $-file_buffer

    name resb 30
	option resb 3
	file resb 2048
    array resb 3000
    array_calificaciones resb 400
    array_final resb 3400
    array_final_len equ $-array_final



section .text
    global _start

segment .data
    coma db ",",0x0
    msg_archivo_no_encontrado db "No se encontro el archivo especificado, iniciando con arreglo vacio...", 0x0
    msg_archivo_encontrado db "Archivo encontrado!, Estos son los contenidos del archivo:...",0x0
    msg_capturar_alumno db "Ingresa el nombre del alumno>",0x0
	msg_mostrar_pantalla db "Estos son los nombres guardados:...", 0x0
	msg_pregunta_calificacion db "Ingrese la calificacion del alumno>",0x0 
	msg_guardar_archivo db "Inserte el nombre del archivo>",0x0 
    
	msg_exit db "Goodbye :)", 0x0
	msg_invalid db "Not valid",0x0
    
	menu db "       ~MENU~",0xa,"1.- Capturar Alumno",0xa,"2.- Capturar Calificaciones",0xa,"3.- Mostrar alumnos en pantalla",0xa,"4.- Guardar Archivo",0xa,"0.- Salir",0xa,"Opcion>",0x0

_start:

    mov esi, array      ; en esi siempre estara el puntero de array

    ;; Checar argumentos y guardar el archivo en el buffer si existe
    pop ecx
    cmp ecx, 2
    jl no_file                 ;; el programa empieza aqui, por el momento no funciona recibir archivo de argumento
    pop eax

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


    mov ecx, 0              ;inicializar un contador para los nombres guardados
    push ecx                ;guardarlo en el stack
    
    mov eax, file_buffer    ; copiar el contenido del archivo en eax para copiarlo a archivo(esi)
    call stringcopycount         ; no funciona todavia
    add esi, 60
    pop ecx 
    add ecx, 2
    push ecx

    mov eax, msg_archivo_encontrado
    call sprintLF

    jmp mostrar_pantalla


display_menu:

    pop eax
    call iprintLF       ; imprimir cantidad de nombres actuales (temporal)
    push eax

    push esi ; guardar el puntero del archivo
    
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

    pop esi ;restaurar el puntero del archivo

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
    
    ; Imprime mensaje y espera input
    mov eax, msg_capturar_alumno                          
    call sprint                                     

    ; Guardar input del usuario en eax
    mov ecx, name_buffer
    mov edx, name_len
    call ReadText
    mov eax, name_buffer

    ; Copia el nombre al arreglo y recorre el arreglo
    call copystring               
    add esi, 30                  
    
    ; Le agrega uno al contador de nombres
    pop ecx                                 
    add ecx, 1
    push ecx

    ; Limpia el buffer para proximo input
    mov edi, name_buffer
 	mov ecx, 50
 	xor eax, eax
 	rep stosb


    jmp display_menu                ; vuelve al menu

    
capturar_calificaciones:

    pop ecx                         ; Trae del stack el numero de nombres guardados
    push ecx                        ; Los vuelve a guardar en el stack

    mov esi, array                  ; puntero para los nombres
    mov edx, array_calificaciones   ; puntero para las calificaciones

    saveloop:
        
        push ecx                    ; guarda cantidad de nombres
        push edx                    ; guarda puntero de calificaciones

        ; Imprime el nombre del alumno
        mov eax, esi			
        call sprintLF

        ; Pregunta por la calificacion
        mov eax, msg_pregunta_calificacion
        call sprint

        ; Espera el input y lo convierte a entero
        mov ecx, calificacion_buffer
        mov edx, calificacion_len
        call ReadText                                 
        mov eax, calificacion_buffer                           
        call atoi

        pop edx                     ; Restaura el puntero de calificaciones
        
        ; Copia al arreglo de calificaciones y recorre los arreglos
        mov [edx], eax              
        add esi, 30
        add edx, 4

        ; Limpia el buffer
        mov edi, calificacion_buffer
 	    mov ecx, 50
 	    xor eax, eax
 	    rep stosb

        ; Resta uno a los nombres guardados
        pop ecx                     ; devuelve ecx del stack
        dec ecx

        cmp ecx, 0
        jne saveloop

    jmp display_menu


mostrar_pantalla:
    ;Imprime mensaje
    mov eax, msg_mostrar_pantalla
    call sprintLF

    pop ecx                         ; Trae del stack el numero de nombres guardados
    push ecx                        ; Los vuelve a guardar en el stack
    
    mov esi, array                  ; puntero para los nombres
    mov edx, array_calificaciones   ; puntero para las calificaciones

    prloop:
        ; Mueve el nombre del arreglo de los nombres y lo imprime
        mov eax, esi			
        call sprint

        ; Imprime una coma
        mov eax, coma
        call sprint
        
        ; Mueve el nombre del arreglo de calificaciones y lo imprime con line feed
        mov eax, [edx]
        call iprintLF

        ; Recorre los arreglos
        add edx, 4
        add esi, 30
        
        ; Checa si termino el proceso
        dec ecx
        cmp ecx, 0
        jne prloop

    jmp display_menu


guardar_archivo:
    pop ecx                         ; Trae del stack el numero de nombres guardados
    push ecx                        ; Los vuelve a guardar en el stack
    push esi                        ; guardar puntero de array

    mov esi, array_final            ; puntero para conjunto
    mov edx, array_calificaciones   ; puntero para las calificaciones
    mov ebx, array                  ; puntero para los nombres

    fillarray:
        mov eax, ebx		        ; mover valor de nombres a eax
        call copystring             ; copiarlo a el arreglo final
                                    ; recorrerlo
        add esi, 30                 
        add ebx, 30

        mov eax, coma               ; agregar una coma
        call copystring
        add esi, 1

        mov eax, [edx]
        call itoa

        ; OCUPA UN SALTO DE LINEA
        ;mov byte [esi], 0xA
        ;add esi, 1

        add esi, 4
        add edx, 4


        ; Resta uno a los nombres
        dec ecx

        cmp ecx, 0
        jne fillarray


	mov eax, msg_guardar_archivo;pregunta por nombre de archivo a guardar
	call sprint 				;imprime el mensaje

	mov ecx, file_buffer 		;captura en filename
	mov edx,file_len     		;con una longitud maxima de len_filename
	call ReadText 				;input desde el teclado

	mov esi, file 		        ;copia hasta archivo
	mov eax, file_buffer		;desde filename
	call copystring	 			;pero sin el caracter 0xA

    ; Create file
	mov eax, sys_creat 			;sys_creat  EQU 8
	mov ebx, file   			;nombre de archivo 
	mov ecx, 511 				;511 = 	rwxr-xr-x
	int 0x80					;ejecuta (llama al sistema op.)

	cmp eax, 0
	jle error					;si es 0 o menos, error al crear


    ; Open file for write
	mov eax, sys_open		;abrir archivo
	mov ebx, file	    	;nombre de archivo desde archivo
	mov ecx, O_RDWR			;abrir en modo de lectura y escritura
	int 0x80				;ejecutar 
	cmp eax,0
	jle error				;si es 0 o menos, error al abrir

	
    ; Write to file
	mov ebx, eax 			;file handle a ebx
	mov eax, sys_write
	mov ecx, array_final         
	mov edx, array_final_len      
	int 0x80
	mov eax, sys_sync		;sincroniza discos (forzar escritura)
	int 0x80 				;sys_sync

    

    ; Close file 
	mov eax,sys_close	
	int 0x80 			

    pop esi
    jmp display_menu

    
no_file:
    mov eax, msg_archivo_no_encontrado
    call sprintLF
    mov ecx, 0
    push ecx
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


stringcopycount:
	mov ebx, 0
	mov ecx, 0
	mov ebx, eax

.sigcar:

	cmp byte[eax],0  		; checks if it's done
	jz .finalizar

	mov bl, byte[eax]

    cmp bl, 0xA
    je .finpalabra

	mov byte[esi+ecx], bl	; moves a char to esi

	inc eax			    	; next letter
	inc ecx			    	; so it doesn't rewrite a char
    jmp .sigcar

.finpalabra:
	mov byte[esi+ecx], bl	; moves a char to esi (0xA)

    pop edx
    inc edx
    push edx
    add esi, 30

	inc eax				; next letter
	inc ecx				; so it doesn't rewrite a char
    jmp .sigcar
    
.finalizar:				; restore values
	ret


