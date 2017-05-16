;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;                              Project.asm                    19/05/2017;;;
;;; Carlos                                                                ;;;
;;; Lorena                                                                ;;;
;;; Jose                                                                  ;;;
;;;                                                                       ;;;
;;; USO                                                                   ;;;
;;; ./project.sh <nombre del archivo>(opcional)                           ;;;
;;;                                                                       ;;;
;;; Usar las opciones del menu que aparecera en pantalla para caputrar    ;;;
;;; calificaciones de alumnos, mostrarlas junto con varianza, maximo,     ;;;                                                                 
;;; minimo. tambien incluye la opcion para guardar la lista de alumnos y  ;;; 
;;; calificaciones en un archivo de texto                                 ;;;
;;;                                                                       ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


%include '../functions.asm'


segment .bss

    names_saved resb 4
    maximo      resb 4
    minimo      resb 4
    media       resb 4
    sumatoria   resb 4
    varianza    resb 4

    name_buffer resb 30
	name_len equ $-name_buffer

    calificacion_buffer resb 4
    calificacion_len equ $-calificacion_buffer

	option_buffer resb 4
	option_len equ $-option_buffer

	file_buffer resb 2048
	file_len equ $-file_buffer
    
	file resb 2048
    array resb 3000
    array_calificaciones resb 400
    array_final resb 3400
    array_final_len equ $-array_final


section .text

    global _start


segment .data

    coma db ",",0x0
    whitespace db " ", 0x0
    linefeed db "",0xA,0x0
    msg_archivo_no_encontrado db "No se encontro el archivo especificado, iniciando con arreglo vacio...", 0x0
    msg_archivo_encontrado db "Archivo encontrado!, Estos son los contenidos del archivo:...",0x0
    msg_capturar_alumno db "¿Cual es el nombre del alumno?>",0x0
	msg_mostrar_pantalla db "Estos son los nombres guardados:...", 0x0
	msg_pregunta_calificacion db "Ingrese la calificacion del alumno>",0x0 
	msg_guardar_archivo db "¿Nombre del archivo a guardar?>",0x0 
    msg_maximo db "La maxima calificacion fue de: ", 0x0
    msg_minimo db "La minima calificacion fue de: ", 0x0
    msg_varianza db "La varianza de las calificaciones fue de: ", 0x0
	msg_exit db "Adios!", 0x0
	msg_invalid db "Opcion invalida",0x0
    msg_no_alumnos db "No hay alumnos guardados", 0x0
	menu db "       ~MENU~",0xa,"1.- Capturar Alumno",0xa,"2.- Capturar Calificaciones",0xa,"3.- Mostrar alumnos en pantalla",0xa,"4.- Guardar Archivo",0xa,"0.- Salir",0xa,"Opcion>",0x0


_start:

    mov esi, array      ; en esi siempre estara el puntero de array

    ; Checar argumentos y guardar el archivo en el buffer si existe
    pop ecx
    cmp ecx, 2
    jl no_file                

    pop eax
    ; Abrir archivo
    pop ebx     ;nombre del archivo     
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

    
    mov eax, file_buffer         ; copiar el contenido del archivo en eax para copiarlo a archivo(esi)
    call stringcopycount

    mov eax, msg_archivo_encontrado
    call sprintLF

    jmp display_menu


display_menu:

    mov eax, [names_saved]
    call iprintLF       ; imprimir cantidad de nombres actuales (temporal)
    
    ; Muestra el menu
    mov eax, menu 		            
    call sprint

    mov ecx, option_buffer 	
    mov edx, option_len
    call ReadText

    mov eax, option_buffer
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
    mov ecx, [names_saved]
    add ecx, 1
    mov [names_saved], ecx

    ; Limpia el buffer para proximo input
    mov edi, name_buffer
 	mov ecx, 50
 	xor eax, eax
 	rep stosb

    jmp display_menu              

    
capturar_calificaciones:

    ; Primero compara para verificar que hay alumnos guardados
    mov ecx, [names_saved]
    cmp ecx, 0
    je no_alumnos

    mov esi, array                  ; puntero para los nombres
    mov edx, array_calificaciones   ; puntero para las calificaciones


    saveloop:
        
        ; Guarda en el stack para pedir input del usuario
        push ecx                    
        push edx                   

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

        ; Copia al arreglo de calificaciones y recorre los arreglos
        pop edx                     
        mov [edx], eax              
        add esi, 30
        add edx, 4

        ; Limpia el buffer
        mov edi, calificacion_buffer
 	    mov ecx, 50
 	    xor eax, eax
 	    rep stosb

        ; Resta uno a los nombres guardados y checa si finalizo
        pop ecx                    
        dec ecx
        cmp ecx, 0
        jne saveloop


    jmp display_menu


mostrar_pantalla:

    ; Primero compara para verificar que hay alumnos guardados
    mov ecx, [names_saved]
    cmp ecx, 0
    je no_alumnos

    ; Limpia registros
    mov eax, 0
    mov [sumatoria], eax
    mov [varianza], eax

    ; Imprime mensaje
    mov eax, msg_mostrar_pantalla
    call sprintLF
    
    ; Inicializa punteros
    mov esi, array                  ; puntero para los nombres
    mov edx, array_calificaciones   ; puntero para las calificaciones

    ; Inicializa maximo y minimo en el primero valor
    mov eax, [array_calificaciones] 
    mov [maximo], eax
    mov [minimo], eax


    prloop:

        ; Mueve el nombre del arreglo de los nombres y lo imprime
        mov eax, esi			
        call sprint

        ; Imprime un espacio
        mov eax, whitespace
        call sprint
        
        ; Mueve el nombre del arreglo de calificaciones y lo imprime con line feed
        mov eax, [edx]
        call iprintLF

        add [sumatoria], eax    ; cuenta de la suma de calificaciones


        ; Busca si el valor actual es mayor o menor a los guardados
        comparar:
            cmp eax, [maximo]   
            jg mayor
            
            cmp eax, [minimo]
            jl menor


        ; Recorre los arreglos
        add edx, 4
        add esi, 30
        
        ; Checa si termino el proceso
        dec ecx
        cmp ecx, 0
        jne prloop


    ; Calcula el promedio
    mov eax, [sumatoria]            
    mov ecx, [names_saved]
    mov edx, 0
    idiv ecx
    mov [media], eax


    ; Cicla en las calificaciones para encontrar la varianza
    mov edx, array_calificaciones
    varloop:
        mov eax, [edx]

        sub eax, [media]             
        imul eax, eax
        add [varianza], eax
        
        add edx, 4
        dec ecx
        cmp ecx, 0
        jne varloop
    

    ; Calcula la varianza
    mov eax, [varianza]
    mov ecx, [names_saved]
    mov edx, 0
    idiv ecx
    mov [varianza], eax


    ; Imprime resultados
    mov eax, msg_maximo
    call sprint
    mov eax, [maximo]
    call iprintLF

    mov eax, msg_minimo
    call sprint
    mov eax, [minimo]
    call iprintLF

    mov eax, msg_varianza
    call sprint
    mov eax, [varianza]
    call iprintLF

    jmp display_menu


    ; Cambia el maximo y vuelve al punto de comparacion
    mayor:
        mov [maximo], eax
        jmp comparar


    ; Cambia el minimo y vuelve al punto de comparacion
    menor:
        mov [minimo], eax
        jmp comparar


guardar_archivo:

    ; Primero compara para verificar que hay alumnos guardados
    mov ecx, [names_saved]
    cmp ecx, 0
    je no_alumnos

    push esi                        ; guardar puntero de array

    mov esi, array_final            ; puntero para conjunto
    mov edx, array_calificaciones   ; puntero para las calificaciones
    mov ebx, array                  ; puntero para los nombres

    fillarray:
        mov eax, ebx		        ; mover valor de nombres a eax
        call copystring             ; copiarlo a el arreglo final
   
        ; Recorrer los arreglos
        add esi, 30                 
        add ebx, 30

        mov eax, coma               ; agregar una coma
        call copystring
        add esi, 1                  ; recorrer el arreglo

        mov eax, [edx]              ; mover valor de calificaciones a eax
        call itoa                   ; cambiarlo a string y guardarlo en esi(arreglo final)

        ; Recorrer los arreglos
        add esi, 4
        add edx, 4

        mov eax, linefeed
        call stringcopy
        add esi, 1                  ; recorrer el arreglo

        ; Resta uno a los nombres
        dec ecx
        cmp ecx, 0

        jne fillarray


    ; Guardado del archivo
	mov eax, msg_guardar_archivo; pregunta por nombre de archivo a guardar
	call sprint 				; imprime el mensaje

	mov ecx, file_buffer 		; captura en filename
	mov edx,file_len     		; con una longitud maxima de len_filename
	call ReadText 				; input desde el teclado

	mov esi, file 		        ; copia hasta archivo
	mov eax, file_buffer		; desde filename
	call copystring	 			; pero sin el caracter 0xA

    ; Create file
	mov eax, sys_creat 			; sys_creat  EQU 8
	mov ebx, file   			; nombre de archivo 
	mov ecx, 511 				; 511 = 	rwxr-xr-x
	int 0x80					; ejecuta (llama al sistema op.)
	cmp eax, 0
	jle error					; si es 0 o menos, error al crear

    ; Open file for write
	mov eax, sys_open           ; abrir archivo
	mov ebx, file               ; nombre de archivo desde archivo
	mov ecx, O_RDWR             ; abrir en modo de lectura y escritura
	int 0x80                    ; ejecutar 
	cmp eax,0
	jle error                   ; si es 0 o menos, error al abrir

    ; Write to file
	mov ebx, eax                ; file handle a ebx
	mov eax, sys_write
	mov ecx, array_final             
	mov edx, array_final_len          
	int 0x80
	mov eax, sys_sync           ; sincroniza discos (forzar escritura)
	int 0x80                    ; sys_sync

    ; Close file 
	mov eax,sys_close	
	int 0x80 			

    pop esi                     ; Restaura puntero de nombres
    jmp display_menu

    
no_file:
    mov eax, msg_archivo_no_encontrado
    call sprintLF
    jmp display_menu


no_alumnos:
    mov eax, msg_no_alumnos
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




; not working
stringcopycount:
	mov ebx, 0
	mov ecx, 0
	mov ebx, eax
    mov edx, [names_saved]

.sigcar:

	mov bl, byte[eax]

    cmp bl, 0xA
    je .finpalabra

	mov byte[esi+ecx], bl	; moves a char to esi
	cmp byte[eax], 0  		; checks if it's done
	jz .finalizar

	inc eax
	inc ecx
    jmp .sigcar

.finpalabra:
    inc edx   
    add esi, 30

	inc eax	
	inc ecx		
    jmp .sigcar
    
.finalizar:
    mov [names_saved], edx
	ret


