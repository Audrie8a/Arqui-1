print macro buffer ;imprime cadena
	mov ax, @data
	mov ds,ax
	mov ah,09h ;Numero de funcion para imprimir buffer en pantalla
	mov dx,offset buffer ;equivalente a que lea dx,buffer, inicializa en dx la posicion donde comienza la cadena
	int 21h
endm

close macro ;cierra el programa
	mov ah, 4ch ;Numero de funcion que finaliza el programa
	xor al,al
	int 21h
endm

getChar macro  ;obtiene el caracter
	mov ah,01h ; se guarda en al en codigo hexadecimal
	int 21h
endm

obtenerTexto macro buffer
LOCAL ObtenerChar, endTexto
	xor si,si ; xor si,si =	mov si,0
	
	ObtenerChar:
		getChar
		cmp al,0dh ; ascii de salto de linea en hexa
		je endTexto
		mov buffer[si],al ;mov destino, fuente
		inc si ; si = si + 1
		jmp ObtenerChar

	endTexto:
		mov al,24h ; asci del singo dolar $
		mov buffer[si], al  
endm

obtenerRuta macro buffer
LOCAL ObtenerChar, endTexto
	xor si,si ; xor si,si =	mov si,0
	
	ObtenerChar:
		getChar
		cmp al,0dh ; ascii de salto de linea en hexa
		je endTexto
		mov buffer[si],al ;mov destino, fuente
		inc si ; si = si + 1
		jmp ObtenerChar

	endTexto:
		mov al,00h ;
		mov buffer[si], al  
endm

abrir macro buffer,handler

	mov ah,3dh
	mov al,02h
	lea dx,buffer
	int 21h
	jc Error1
	mov handler,ax

endm

cerrar macro handler
	
	mov ah,3eh
	mov bx, handler
	int 21h
	jc Error2
	mov handler,ax

endm

leer macro handler,buffer, numbytes
	
	mov ah,3fh
	mov bx,handler
	mov cx,numbytes
	lea dx,buffer ; mov dx,offset buffer 
	int 21h
	jc  Error5

endm

limpiar macro buffer, numbytes, caracter
LOCAL Repetir
	xor si,si
	xor cx,cx
	mov	cx,numbytes

	Repetir:
		mov buffer[si], caracter
		inc si
		Loop Repetir
endm

crear macro buffer, handler
	
	mov ah,3ch
	mov cx,00h
	lea dx,buffer
	int 21h
	jc Error4
	mov handler, ax

endm

escribir macro handler, buffer, numbytes

	mov ah, 40h
	mov bx, handler
	mov cx, numbytes
	lea dx, buffer
	int 21h
	jc Error3

endm



StringToInt macro string
LOCAL Unidades,Decenas,salir
	

	sizeNumberString string
	xor ax,ax

	cmp bl,1
	je Unidades

	cmp bl,2
	je Decenas



	Unidades:
		mov al,string[0]
		SUB al,30h
		jmp salir

	Decenas:
		

		mov al,string[0]
		sub al,30h
		mov bl,10
		mul bl


		xor bx,bx
		mov bl,string[1]
		sub bl,30h

		add al,bl

		jmp salir

	salir:
	; en el registro al se guarda el numero entero
endm


IntToString macro numero, arreglo
LOCAL Unidades,Decenas, Salir
	xor ax,ax
	xor bx,bx

	mov al,numero
	cmp al, 9 
	ja Decenas

	Unidades:
		add al,30h
		mov arreglo[0],al
		jmp Salir

	Decenas:
		mov bl,10
		div bl     ;divide entre 10 las decenas
		add al,30h ;le suma 30h a al, al cociente 
		add ah,30h ; le suma 30h al residuo 
		mov arreglo[0],al ;decenas
		mov arreglo[1],ah ;unidades 

		jmp Salir

	Salir:
endm

sizeNumberString macro string
LOCAL LeerNumero
	xor si,si ; xor si,si =	mov si,0
	xor bx,bx

	LeerNumero:
		mov bl,string[si] ;mov destino, fuente
		cmp bl,24h ; ascii de signo dolar
		je endTexto
		inc si ; si = si + 1
		jmp LeerNumero

	endTexto:
		mov bx,si
endm
