print macro buffer          ; imprime cadena
    mov ax, @data
    mov ds, ax
    mov ah, 09h             ; Numpero de funciones para imprimir buffer en pantalla
    mov dx, offset buffer   ; equivalente a que lea dx,buffer, inicializa en dx la posicion donde comienza la cadena
    int 21h
endm

close macro                 ; cierra el programa
    mov ah, 4ch             ; numero de funciones que finaliza el programa
    xor al, al
    int 21h
endm

getChar macro             ; obtiene el caracter
    mov ah, 01h           ; se guarda en al en codigo hex
    int 21h
endm

obtenerTexto macro buffer
    LOCAL ObtenerChar, endTexto
        xor si, si        ; xor si, si = mov si, 0

        ObtenerChar:
            getChar
            cmp al, 0dh     ; ascii de salto de linea hex
            je endTexto
            mov buffer[si], al  ; mov dstino, fuente
            inc si          ; si = si + 1
            jmp ObtenerChar

        endTexto:
            mov al, 24h     ; ascii del signo dolar $
            mov buffer[si], al
endm

obtenerNumero macro numero, diez         ;etiqueta a la que regresa el salto
    LOCAL isPositive, isNegative, NegateNumber, getSign

        getSign:
            getChar
            cmp al, '-'
            je isNegative

        isPositive:
            sub al, 30h
            mov bl, 10
            mul diez
            mov numero, al  ; ya se tiene el primer digito ahora el segundo
            mov ah, 01h
            int 21h
            sub al, 30h
            add numero, al
            neg numero
            jmp NegateNumber
    
        isNegative:
            mov ah, 01h
            int 21h
            sub al, 30h
            mul diez
            mov numero, al  ; ya se tiene el primer digito ahora el segundo
            mov ah, 01h
            int 21h
            sub al, 30h
            add numero, al

        NegateNumber:
            neg numero

endm

printNum macro numero, residuo, diez
    LOCAL evaluateNumber, printSign, printNumero

        evaluateNumber:
            mov bl, numero
            test bl, bl
            jns printNumero

        printSign:
            mov ah, 02h
            mov dx, 2dh
            int 21h
            neg numero

        printNumero:
            mov al, numero              ; el valor a convertir debe estar AX o AL, depende del tipo
            cbw                         ; haciendo la conversion de Byte a Word
            div diez                    ; resultado en AL y residuo en AH
            mov residuo, ah
            mov dl, al
            add dl, 30h                 ; añadiendo lo substraído
            mov ah, 02h
            int 21h
            mov dl, residuo
            add dl, 30h                 ; añadiendo lo substraído
            mov ah, 02h
            int 21h
endm

printFacEqual macro
    mov ah, 02h
    mov dx, 21h
    int 21h
    mov ah, 02h
    mov dx, 3dh
    int 21h
endm

printPtcEsp macro
    mov ah, 02h
    mov dx, 3bh
    int 21h
    mov ah, 02h
    mov dx, 20h
    int 21h
endm

obtenerFactorialAux macro resf
    LOCAL ciclo, endCiclo, return1

        mov al, resf

        cmp al, 1
        jbe return1

        mov ah, 0
        mov bx, ax

        ciclo:
            dec bx
            mul bx
            cmp bx, 1
            jne ciclo
            mov cx, ax
            jmp endCiclo

        return1:
            mov cl, 1

        endCiclo:
            mov resf, cl

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

abrir macro ruta, handler

	mov ah, 3dh
	mov al, 02h
	lea dx, ruta
	int 21h
	jc Error1
	mov handler, ax

endm

cerrar macro handler
	
	mov ah,3eh
	mov bx, handler
	int 21h
	jc Error2
	mov handler,ax

endm

leer macro handler, buffer, numbytes
	
	mov ah, 3fh
	mov bx, handler
	mov cx, numbytes
	lea dx, buffer ; mov dx,offset buffer 
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

analizar macro arreglo, arregloAux
    Local evaluar, concatenar, salida
        evaluar:
            mov si, contG
            mov di, 0

            mov al, arreglo[si]
            cmp al, '<'      
            je concatenar
            inc si
            inc contG
            jmp evaluar

        concatenar:
            inc si
            inc contG

            mov bl, arreglo[si]
            cmp bl, '>'     
            je salida

            mov arregloAux[di], bl
            inc di

            jmp concatenar

        salida:
            inc si
            inc contG
            mov al, 24h     ; ascii del signo dolar $
            mov arregloAux[di], al
endm

comparacion macro arregloAux, arreglo
    Local suma, resta, multiplicacion, division, valor, salir

        mov al, arregloAux[0]
        cmp al, 'S'
        je suma
        cmp al, 'R'
        je resta
        cmp al, 'M'
        je multiplicacion
        cmp al, 'D'
        je division
        cmp al, 'V'
        je valor
        mov al, 0
        jmp salir

        suma:
            mov al, 0
            mov arreglo[di], 2bh
            inc cont
            jmp salir

        resta:
            mov al, 0
            mov arreglo[di], 2dh
            inc cont
            jmp salir

        multiplicacion:
            mov al, 0
            mov arreglo[di], 2ah
            inc cont
            jmp salir

        division:
            mov al, 0
            mov arreglo[di], 2fh
            inc cont
            jmp salir

        valor:
            mov al, 1
            jmp salir

        salir:
endm 

obtenerStringNumero macro arreglo, arregloAux
    Local concatenar, salir
        mov si, contG

        concatenar:
            mov al, arreglo[si]
            cmp al, '<'      
            je salir

            mov arregloAux[di], al

            inc contG
            inc si
            inc di
            inc cont
            jmp concatenar

        salir: 
            mov al, 20h     ; ascii del signo dolar $
            mov arregloAux[di], al
            inc di
            inc cont
            mov al, 24h     ; ascii del signo dolar $
            mov arregloAux[di], al
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