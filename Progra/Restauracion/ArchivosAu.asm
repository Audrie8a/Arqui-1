leer macro handler,buffer, numbytes	
	mov ah,3fh ;interrupción para leer 
	mov bx,handler
	mov cx,numbytes
	lea dx,buffer ;le pasamos al buffer lo que hay en dx, LEA realiza la carga del valor de desplazamiento de la memoria en un registro.
	int 21h
endm

cerrar macro handler
	mov ah,3eh
	mov bx, handler
	int 21h
endm

AbrirArchivo macro buffer,handler
    local Error1,Fin
    mov ah,3dh
    mov al,10b
    lea dx,array
    int 21h
    jc Error1
    mov handler,ax
    mov ax,0
    jmp fini
    Error1:
        mov ax,1
    Fin:
endm