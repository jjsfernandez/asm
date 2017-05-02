;escribe_archivo.asm ;Autor: Federico Cirett
;basado en el codigo de http://www.matveev.se/asm/nasm-fops.htm
;y capturado por Arturo Parada
;27/04/2017

%include '../functions.asm'

segment .bss
	buffer_alumno RESB 30
	len_alumno EQU $-buffer_alumno

	filename RESB 30
	len_filename EQU $-filename

	archivo RESB 30

section .data
	p_nombre  DB "Nombre del alumno> " ,0x0 
	p_archivo DB "Nombre del archivo> ",0x0

section .text
	global _start

_start:

	mov eax, p_nombre 			;pregunta por nombre de alumno
	call sprint					;imprime el mensaje

	mov ecx, buffer_alumno 		;captura en buffer_alumno
	mov edx, len_alumno 		;con longitud maxima de len_alumno
	call ReadText				;input desde el teclado

	mov eax, p_archivo 			;pregunta por nombre de archivo a guardar
	call sprint 				;imprime el mensaje

	mov ecx,filename 			;captura en filename
	mov edx,len_filename  		;con una longitud maxima de len_filename
	call ReadText 				;input desde el teclado

	mov esi, archivo 			;copia hasta archivo
	mov eax, filename 			;desde filename
	call copystring	 			;pero sin el caracter 0xA

;create file
	mov eax, sys_creat 			;sys_creat  EQU 8
	mov ebx, archivo 			;nombre de archivo 
	mov ecx, 511 				;511 = 	rwxr-xr-x
	int 0x80					;ejecuta (llama al sistema op.)

	cmp eax, 0
	jle error					;si es 0 o menos, error al crear


; open file for write
	mov eax, sys_open		;abrir archivo
	mov ebx, archivo		;nombre de archivo desde archivo
	mov ecx, O_RDWR			;abrir en modo de lectura y escritura
	int 0x80				;ejecutar 
	cmp eax,0
	jle error				;si es 0 o menos, error al abrir

	
;write
	mov ebx, eax 			;file handle a ebx

	mov eax, sys_write
	mov ecx, buffer_alumno
	mov edx, len_alumno
	int 0x80
	mov eax, sys_sync		;sincroniza discos (forzar escritura)
	int 0x80 				;sys_sync

;Close file 
	mov eax,sys_close	;
	int 0x80 			;


salida:
	jmp quit

error:
	mov ebx,eax			;
	mov eax,sys_exit	;
	int 0x80 			;
