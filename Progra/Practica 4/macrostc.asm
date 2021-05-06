print macro p1
	mov ax,@data
	mov ds,ax
	lea dx, p1 ; Equivalente a lea dx, cadena, inicializa en dx la posicion donde comienza la cadena
	mov ah,09h ;Numero de funcion para imprimir cadena en pantalla
	;mov dx, offset p1
	int 21h
endm

imprimir macro p1
	mov ah, 02h
	mov dl, p1
	int 21h
endm

SaltoLinea macro
	mov ah, 02h
	mov dl, 10
	int 21h
	mov ah,02h
	mov dl, 13
	int 21h
endm

getChar macro
	mov ah,01h
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
		mov al,24h ; asci del signo dolar $
		mov buffer[si], al  
endm

close macro ;cierra el programa
	mov ah, 4ch ;Numero de funcion que finaliza el programa
	xor al,al
	int 21h
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
		mov al,00h ; asci del caracter nulo
		mov buffer[si], al  
endm

abrir macro buffer,handler

	mov ah,3dh
	mov al,02h ;010b Acceso de lectura/escritura.
	lea dx,buffer ;equivalente mov dx,offset buffer 
	int 21h
	jc Error1 ;salta si el flag de acarreo = 1
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
	
	mov ah,3fh ;interrupción para leer 
	mov bx,handler
	mov cx,numbytes
	lea dx,buffer ;le pasamos al buffer lo que hay en dx, LEA realiza la carga del valor de desplazamiento de la memoria en un registro.
	int 21h
	jc  Error5
endm

;en el macro limpiar vamos a limpiar el arreglo con $
limpiar macro buffer, numbytes, caracter
	LOCAL Repetir
	xor si,si ; colocamos en 0 el contador si
	xor cx,cx ; colocamos en 0 el contador cx
	mov	cx,numbytes ;le pasamos a cx el tamaño del arreglo a limpiar 

	Repetir:
		mov buffer[si], caracter ;le asigno el caracter que le estoy mandando 
		inc si ;incremento si
		Loop Repetir ;se va a repetir hasta que cx sea 0 
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

LeerNumero macro arreglo
	LOCAL leerchar,final
	push di
	push si
	xor si,si
	xor di,di
	leerchar:

	cmp arreglo[si],24h
	je final

	inc si 
	jmp leerchar

	final:

	dec si
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

getNum macro
	mov ah,01h
	int 21h
	sub al,30h
	mov bh, al
endm

LimpiarArrays macro buffer
	Local Mientras
	xor si,si
	mov cx,5
	Mientras:
		mov buffer[si],24h
		inc si
		Loop Mientras
endm

filtarNumero macro buffer
	Local Ini,UNum, DNum,  NDNum,Recorrer, Fin, Comprobar,Negativo, Decena,Unidad, Diez, Veinte, Treinta, Cuarenta, Cincuenta, Sesenta, Sietenta,Ochenta, Noventa, Uno, Dos, Tres, Cuatro, Cinco, Seis, Siete, Ocho, Nueve, Negar
	xor si, si
	mov contador, 0
	mov isNegativo, 0
	mov numero2,0
	mov num1A,0
	mov num1B,0

	Recorrer:
		mov cl, buffer[si]
		
		cmp cl, 2dh ;ascii del signo menos
		je Negativo
		
		cmp contador,0
		je DNum

		cmp contador,1
		je Unidad

		cmp contador, 2
		je Comprobar
		inc si
		jmp Recorrer
	DNum:
		cmp sizeBuffer,3
		je Decena

		cmp sizeBuffer,1
		je UNum

		cmp sizeBuffer,2
		je NDNum
	NDNum:
		cmp isNegativo,0
		je Decena

		jmp UNum
	UNum:
		mov contador,1
		jmp Recorrer
	Decena:

		mov contador, 1	
		mov numero2, cl
		add numero2, 30h

		cmp cl,31h
		je Diez
		cmp cl,32h
		je Veinte
		cmp cl,33h
		je Treinta
		cmp cl,34h
		je Cuarenta
		cmp cl,35h
		je Cincuenta
		cmp cl,36h
		je Sesenta
		cmp cl,37h
		je Sietenta
		cmp cl,38h
		je Ochenta
		cmp cl,39h
		je Noventa
		
		mov numero,100
		
	Unidad:
		cmp cl,31h
		je Uno
		cmp cl,32h
		je Dos
		cmp cl,33h
		je Tres
		cmp cl,34h
		je Cuatro
		cmp cl,35h
		je Cinco
		cmp cl,36h
		je Seis
		cmp cl,37h
		je Siete
		cmp cl,38h
		je Ocho
		cmp cl,39h
		je Nueve
		
	Comprobar:
		cmp isNegativo, 1
		je Negar

		jmp Fin
		
	Negar:
		neg numero
		jmp Fin

	Negativo:
		mov isNegativo,1
		inc si
		jmp Recorrer
	Diez:
		mov numero2, 10
		mov num1A,1
		inc si
		jmp Recorrer
	Veinte:
		mov numero2, 20
		mov num1A,2
		inc si
		jmp Recorrer
	Treinta:
		mov numero2, 30
		mov num1A,3
		inc si
		jmp Recorrer
	Cuarenta:
		mov numero2, 40
		mov num1A,4
		inc si
		jmp Recorrer
	Cincuenta:
		mov numero2,5
		inc si
		jmp Recorrer
	Sesenta:
		mov numero2, 60
		mov num1A,6
		inc si
		jmp Recorrer
	Sietenta:
		mov numero2, 70
		mov num1A,7
		inc si
		jmp Recorrer
	Ochenta:
		mov numero2, 80
		mov num1A,8
		inc si
		jmp Recorrer
	Noventa:
		mov numero2, 90
		mov num1A,9
		inc si
		jmp Recorrer

	Uno:
		add numero2, 1		
		mov num1B,1
		mov contador,2
		jmp Recorrer
	Dos:
		add numero2,2
		mov num1B,2
		mov contador,2
		jmp Recorrer
	Tres:
		add numero2, 3
		mov num1B,3
		mov contador,2
		jmp Recorrer
	Cuatro:
		add numero2, 4
		mov num1B,4
		mov contador,2
		jmp Recorrer
	Cinco:
		add numero2, 5
		mov num1B,5
		mov contador,2
		jmp Recorrer
	Seis:
		add numero2, 6
		mov num1B,6
		mov contador,2
		jmp Recorrer
	Siete:
		add numero2, 7
		mov num1B,7
		mov contador,2
		jmp Recorrer
	Ocho:
		add numero2, 8
		mov num1B,8
		mov contador,2
		jmp Recorrer
	Nueve:
		add numero2, 9
		mov num1B,9
		mov contador,2
		jmp Recorrer
	Fin:
		mov al, 24h
		mov buffer[si],al
endm

printRespuesta macro dato
	mov al, dato
	aam

	mov unidad, al
	mov al, ah

	aam
	mov centena,ah

	mov decena, al

	mov ah, 02h

	mov dl, centena
	add dl, 30h
	int 21h

	mov dl, decena
	add dl, 30h
	int 21h

	mov dl, unidad
	add dl, 30h
	int 21h
endm

obtenerSizeBuffer macro buffer
	Local obtiene, EstadoA, EstadoB,EstadoC,SalidaF
	xor si, si
	mov sizeBuffer, 0
	
	obtiene:
		cmp buffer[si],2dh	; Si es signo menos
		je EstadoA

		jmp EstadoB
		
	EstadoA:	; Si es signo menos
		add sizeBuffer,1		
		inc si
		jmp EstadoB
	EstadoB:	; Contar numero y ver que hay despues del número
		add sizeBuffer, 1
		inc si
		cmp buffer[si],24h	; Si el siguiente dato es $ se sale
		je SalidaF

		jmp EstadoC	; si no es $ incrementa contador
	EstadoC:
		add sizeBuffer, 1
		jmp SalidaF
	SalidaF:
		xor si,si			
endm

obtenerNumeros macro arreglo
	LOCAL Inicio, Guardar, InicioGuardado, FinalGuardado, Final
	xor si,si
	xor di, di

	Inicio:
		cmp arreglo[si],24h	;Signo dollar
		je Final
		cmp arreglo[si],3Eh 	;Signo >
		je Guardar
		inc si
		jmp Inicio
	Guardar:
		inc si
		cmp arreglo[si],24h		;Signo dollar
		je Inicio
		cmp arreglo[si], 0dh 	;Salto de línea
		je Inicio
		jmp InicioGuardado

	InicioGuardado:
		cmp arreglo[si], 3ch	;Signo <
		je FinalGuardado
		mov al, arreglo[si]
		mov numeros[di],al
		inc si
		inc di
		jmp InicioGuardado
	FinalGuardado:
		mov numeros[di],20h 	;Espacio
		inc di
		jmp Inicio
	Final:
	inc di
	mov numeros[di],24h
endm 

convertirNumero macro arreglo
	LOCAL Inicio, Guardar, Final
	mov contadorArreglo,0
	xor si,si
	xor di,di
	limpiar valorNumero, SIZEOF valorNumero, 24h

	Inicio:
		;imprimir arreglo[si]
		cmp arreglo[si], 24h 	;Signo dollar
		je Final

		cmp arreglo[si],20h 	;Espacio
		je Guardar
		
		mov al, arreglo[si]
		mov valorNumero[di],al
		inc di
		inc si
		jmp Inicio
	Guardar:
		mov di, contadorArreglo
		mov auxsi, si
		mov auxdi, di
		obtenerSizeBuffer valorNumero
		filtarNumero valorNumero
		;StringToInt valorNumero
		
		mov al, numero2
		;imprimeDecimal numero2

		mov numeroReal[di],al
		limpiar valorNumero, SIZEOF valorNumero, 24h
		mov si, auxsi
		mov di, auxdi
		inc si
		xor di,di
		inc contadorArreglo
		jmp Inicio
	Final:
		;imprimeDecimal numeroReal[0]
		;SaltoLinea
		;imprimeDecimal numeroReal[1]
		;SaltoLinea
		;imprimeDecimal numeroReal[2]
		;SaltoLinea
		;imprimeDecimal numeroReal[3]
		;SaltoLinea
		;imprimeDecimal numeroReal[4]		
		;SaltoLinea
		;imprimeDecimal numeroReal[5]
		;SaltoLinea
		;imprimeDecimal numeroReal[6]
		;SaltoLinea		
		;imprimeDecimal numeroReal[7]
		;SaltoLinea
		;imprimeDecimal numeroReal[8]
		;SaltoLinea
		;imprimeDecimal numeroReal[9]
		;SaltoLinea
endm



longitudArreglo macro arreglo
	LOCAL Ini, Fin
	mov lengthArreglo, 0
	mov der,0
	xor si,si
	Ini:
	cmp arreglo[si], 24h
	je Fin

	inc si
	add lengthArreglo,1
	add der, 1
	jmp Ini
	Fin:
endm

copiarArreglo macro origen, destino
	LOCAL Ini, Fin
	xor bx,bx
	xor si,si
	limpiar destino, SIZEOF destino,24h
	Ini:
		mov bl, lengthArreglo
		cmp si, bx
		je Fin

		mov al, origen[si]
		mov destino[si],al
		inc si
		jmp Ini

	Fin:
endm

imprimirArreglo macro arreglo
	LOCAL Ini, Fin
	xor di,di
	xor bx,bx
	limpiar arrayTexto, SIZEOF arrayTexto, 24h
	Ini:
	cmp arreglo[di], 24h
	je Fin

	mov ah, 0
	mov al, arreglo[di]
	mov cl, 10
	div cl

	add al, 30h
	add ah, 30h
	mov dl, ah

	mov arrayTexto[bx],al
	inc bx
	mov arrayTexto[bx],dl
	inc bx
	mov al, 20h
	mov arrayTexto[bx],al

	inc di
	inc bx
	jmp Ini
	Fin:
		print arrayTexto
endm

ConvertirArreglo macro arreglo
	LOCAL Ini, Fin
	xor di,di
	xor bx,bx
	limpiar arrayTexto, SIZEOF arrayTexto, 24h
	Ini:
	cmp arreglo[di], 24h
	je Fin

	mov ah, 0
	mov al, arreglo[di]
	mov cl, 10
	div cl

	add al, 30h
	add ah, 30h
	mov dl, ah

	mov arrayTexto[bx],al
	inc bx
	mov arrayTexto[bx],dl
	inc bx
	mov al, 20h
	mov arrayTexto[bx],al

	inc di
	inc bx
	jmp Ini
	Fin:
		;print arrayTexto
endm

imprimirArregloDesc macro arreglo
	LOCAL Ini, Fin
	xor di,di
	xor bx,bx
	mov al, lengthArreglo
	mov decontador,al

	limpiar arrayTexto, SIZEOF arrayTexto, 24h
	Ini:
	cmp decontador, 1
	jb Fin

	ActualizarContadorDi decontador
	;Divide
	mov ah, 0
	mov al, arreglo[di]
	mov cl, 10
	div cl

	;Convierta a texto
	add al, 30h
	add ah, 30h
	mov dl, ah

	;Guarda en arreglo
	mov arrayTexto[bx],al
	inc bx
	mov arrayTexto[bx],dl
	inc bx
	mov al, 20h
	mov arrayTexto[bx],al

	; Cuenta
	inc bx
	sub decontador,1
	jmp Ini
	Fin:
		print arrayTexto
endm

Limpiar macro
	xor bx,bx
	xor si,si
	xor cx,cx
	xor dx,dx
endm

imprimirMul macro p1
	mov ah, 02h
	mov dl, p1
	add dl, 30h
	int 21h
endm

imprimeDecimal macro dato
	mov ah, 0
	mov al, dato
	mov cl, 10
	div cl

	add al, 30h
	add ah, 30h
	mov bl, ah

	mov dl, al
	mov ah, 02h
	int 21h


	mov dl, bl
	mov ah, 02h
	int 21h

	mov cx, 2
endm


Ascii_Int macro dato
	mov ah, 0
	mov al, dato
	mov cl, 10
	div cl

	add al, 30h
	add ah, 30h
	mov bl, ah

	add al, bl

	mov dato, al

	mov cx, 2
endm

BurbujaAsc macro arreglo
	Local Ini,For2, Fin, Swap
	limpiar arregloOrdenado, SIZEOF arregloOrdenado, 24h
	mov aux, 0
	mov i,1
	mov j, 0
	xor si,si
	Ini:
		add i, 1
		mov j, 0
		xor si,si

		imprimirArreglo arreglo		
		SaltoLinea
		;Graficar arreglo
		mov al, lengthArreglo
		cmp i, al
		jae Fin 	; si i >= lengthArreglo
		jb For2 	; si i< lengthArreglo


	For2:
		mov al, lengthArreglo
		sub al, 1 	; lengthArreglo-1

		cmp j, al
		jae Ini 	; j>= lengthArreglo-1

		mov bl, arreglo[si]

		
		cmp bl,arreglo[si+1]
		ja Swap 	;arreglo[si] > arreglo[si+1]
		 


		add j, 1	
		inc si
		jmp For2
	Swap:
		

		mov al, arreglo[si]	 	; aux = arreglo[si]
		mov aux, al

		mov al, arreglo[si+1]		; al = arreglo[si+1]

		
		mov arreglo[si],al 		; arreglo[si] = arreglo[si+1]

	
		mov al, aux 			; al = aux
		mov arreglo[si+1], al  	; arreglo[si +1 ]= aux

		

		add j, 1	
		inc si
		jmp For2
		

	Fin:
	;copiarArreglo arreglo, arregloOrdenado
	;printRespuesta arregloOrdenado
	imprimirArreglo arreglo
endm

BurbujaDesc macro arreglo
	Local Ini,For2, Fin, Swap
	limpiar arregloOrdenado, SIZEOF arregloOrdenado, 24h
	mov aux, 0
	mov i,1
	mov j, 0
	xor si,si
	Ini:
		add i, 1
		mov j, 0
		xor si,si
		imprimirArreglo arreglo
		SaltoLinea
		mov al, lengthArreglo
		cmp i, al
		jae Fin 	; si i >= lengthArreglo
		jb For2 	; si i< lengthArreglo


	For2:
		mov al, lengthArreglo
		sub al, 1 	; lengthArreglo-1

		cmp j, al
		jae Ini 	; j>= lengthArreglo-1

		mov bl, arreglo[si]

		
		cmp bl,arreglo[si+1]
		jb Swap 	;arreglo[si] > arreglo[si+1]
		 

		add j, 1	
		inc si
		jmp For2
	Swap:
		

		mov al, arreglo[si]	 	; aux = arreglo[si]
		mov aux, al

		mov al, arreglo[si+1]		; al = arreglo[si+1]

		
		mov arreglo[si],al 		; arreglo[si] = arreglo[si+1]

	
		mov al, aux 			; al = aux
		mov arreglo[si+1], al  	; arreglo[si +1 ]= aux
		;mov auxsi,si
		;copiarArreglo arreglo, arregloOrdenado
		;imprimirArreglo arregloOrdenado
		;SaltoLinea
		;mov si, auxsi

	

		add j, 1	
		inc si
		jmp For2
		

	Fin:
	;copiarArreglo arreglo, arregloOrdenado
	;printRespuesta arregloOrdenado
	imprimirArreglo arreglo
endm

Int_Ascii macro dato
	mov ah, 0
	mov al, dato
	mov cl, 10
	div cl

	sub al, 30h
	sub ah, 30h
	mov bl, ah

	add al, bl

	mov dato, al

	mov cx, 2
endm

Dividir macro numero1,numero2
	mov ah, 0
	mov al, numero1
	mov cl, numero2
	idiv cl

	;add al, 30h
	;add ah, 30h
	;mov bl, ah

	mov cociente, al
	mov gap, al

	mov residuo , bl

	;imprimir cociente
endm
ActualizarContadorSi macro num
	LOCAL Ini, Fin
	xor si,si
	mov auxContador,0
	Ini:
		mov al, auxContador
		cmp al, num
		je Fin

		inc si
		add auxContador,1
		jmp Ini
	Fin:
endm


ActualizarContadorDi macro num
	LOCAL Ini, Fin
	xor di,di
	mov auxContador,0
	Ini:
		mov al, auxContador
		cmp al, num
		je Fin

		inc di
		add auxContador,1
		jmp Ini
	Fin:
endm

ShellSortAscM2 macro arreglo
	LOCAL Ini,For2,For3,Condicion,Condicion2,Swap,Fin,prueba
	limpiar arregloOrdenado, SIZEOF arregloOrdenado, 24h
	mov aux, 0
	mov i, 0
	mov j, 0
	xor si,si
	xor di,di
	mov al, lengthArreglo
	mov gap,al
	mov aux,0
	Ini:
		Dividir gap, 2
		;imprimeDecimal gap
		mov al, gap
		mov i, al				; i= gap
		;ActualizarContadorSi gap
		;imprimirArreglo arreglo
		;SaltoLinea
		cmp gap, 0
		jbe Fin 	; si gap <= 0
		ja For2 	; si gap> 0
		
	prueba:
		
		imprimeDecimal gap
		jmp Ini
	For2:
		mov al, lengthArreglo

		cmp i, al
		jae Ini 	; i>= lengthArreglo

		ActualizarContadorSi i 	; si=i
		mov bl, arreglo[si]
		mov aux, bl 			; aux = arreglo[i]
		
		add j, 1	
		inc di

		
		call For3

		mov al,aux
		ActualizarContadorDi j 	; di=j
		mov arreglo[di],al 		; arreglo[j] =aux

		ActualizarContadorSi i
		add i, 1
		inc si
		
		jmp For2
	For3:
		ActualizarContadorDi i ;di = i
		mov al,i
		mov j,al 				; j=i

		mov al, j
		cmp al,gap	; j>= gap
		jae Condicion

		ret
	Condicion:
		mov al, j
		sub al,gap 		; j-gap
		ActualizarContadorDi al
		mov al,arreglo[di] 		;al = arreglo[j-gap]
		mov aux2,al 			; aux2 = arreglo[j-gap]

		cmp al, aux
		ja Swap 		; arreglo[j-gap]>aux

		; En caso que no cumpla las condiciones del for, realiza
		; la ultima parte del for2 arr[j]= aux
		; y retorna a for2
		mov al,aux
		ActualizarContadorDi j 	; di=j
		mov arreglo[di],al 		; arreglo[j] =aux

		ActualizarContadorSi i
		add i, 1
		inc si

		jmp For2

	Swap:
		ActualizarContadorDi j  	;di = j
		mov al, aux2 				; aux2 -> arregl[j-gap]
		mov arreglo[di], al 		; arreglo[j] = aux2

		
		mov al, gap
		sub j, al
		ActualizarContadorDi j
		jmp For3
	Fin:
endm

ShellSortAscM macro arreglo
	LOCAL Ini,For2,For3,Swap,Fin,prueba
	limpiar arregloOrdenado, SIZEOF arregloOrdenado, 24h	
	mov i, 0
	mov j, 0
	xor si,si
	xor di,di
	mov al, lengthArreglo
	mov gap,al  				;salto = A.lenth
	mov aux1,0
	mov aux2,0
	mov cond,0
	Ini:

		Dividir gap, 2 			;salto /=2
		;imprimeDecimal gap
		mov al, gap
		;ActualizarContadorSi gap
		imprimirArreglo arreglo
		SaltoLinea
		mov cond,1 		;cambios =true
		cmp gap, 0
		jbe Fin 	; si gap <= 0
		ja For2 	; si gap> 0
		
	prueba:
		
		imprimeDecimal gap
		jmp Ini
	For2:
		cmp cond,0 	
		je Ini

		mov cond,0 		; cambios =false
		mov al, gap
		mov i, al 				; i=salto
		call For3

		jmp For2
	For3:		

		mov al, lengthArreglo
		cmp i, al 				; i>=lengthArreglo
		jae For2

		ActualizarContadorSi i 	; si=i

		;Obteniendo A[i-salto]
		mov al, arreglo[si]		
		mov aux1, al  			; aux = arreglo[i]


		mov al, i
		sub al, gap 			; i- gap
		

		mov j, al 				; j= i-gap

		;imprimeDecimal i
		;SaltoLinea
		;imprimeDecimal j
		;SaltoLinea
		;jmp Fin

		ActualizarContadorDi al 	; di= i-gap
		mov al, arreglo[di] 		; al = arreglo[i-gap]
		mov aux2, al 				; aux2 = arreglo[i-gap]
		
		cmp al,aux1
		ja Swap
		; lo que sigue después de la condicion

		add i, 1				; i++
		jmp For3

	Swap:
		ActualizarContadorSi i
		mov al, aux2
		mov arreglo[si], al 		; arreglo[i] = arreglo[i-salto]

		ActualizarContadorDi j
		mov al , aux1
		mov arreglo[di], al 		; arreglo[i-gap] = arreglo[i]
		mov cond, 1
		
		add i, 1				; i++
		jmp For3

	Fin:
endm

ShellSortDescM macro arreglo
	LOCAL Ini,For2,For3,Swap,Fin,prueba
	limpiar arregloOrdenado, SIZEOF arregloOrdenado, 24h	
	mov i, 0
	mov j, 0
	xor si,si
	xor di,di
	mov al, lengthArreglo
	mov gap,al  				;salto = A.lenth
	mov aux1,0
	mov aux2,0
	mov cond,0
	Ini:

		Dividir gap, 2 			;salto /=2
		;imprimeDecimal gap
		mov al, gap
		;ActualizarContadorSi gap
		imprimirArreglo arreglo
		SaltoLinea
		mov cond,1 		;cambios =true
		cmp gap, 0
		jbe Fin 	; si gap <= 0
		ja For2 	; si gap> 0
		
	prueba:
		
		imprimeDecimal gap
		jmp Ini
	For2:
		cmp cond,0 	
		je Ini

		mov cond,0 		; cambios =false
		mov al, gap
		mov i, al 				; i=salto
		call For3

		jmp For2
	For3:		

		mov al, lengthArreglo
		cmp i, al 				; i>=lengthArreglo
		jae For2

		ActualizarContadorSi i 	; si=i

		;Obteniendo A[i-salto]
		mov al, arreglo[si]		
		mov aux1, al  			; aux = arreglo[i]


		mov al, i
		sub al, gap 			; i- gap
		

		mov j, al 				; j= i-gap

		;imprimeDecimal i
		;SaltoLinea
		;imprimeDecimal j
		;SaltoLinea
		;jmp Fin

		ActualizarContadorDi al 	; di= i-gap
		mov al, arreglo[di] 		; al = arreglo[i-gap]
		mov aux2, al 				; aux2 = arreglo[i-gap]
		
		cmp al,aux1
		jb Swap
		; lo que sigue después de la condicion

		add i, 1				; i++
		jmp For3

	Swap:
		ActualizarContadorSi i
		mov al, aux2
		mov arreglo[si], al 		; arreglo[i] = arreglo[i-salto]

		ActualizarContadorDi j
		mov al , aux1
		mov arreglo[di], al 		; arreglo[i-gap] = arreglo[i]
		mov cond, 1
		
		add i, 1				; i++
		jmp For3

	Fin:
endm

partitionAsc macro arreglo, l ,h
LOCAL For, If, EndFor
	push si
	push di
	push ax
	push bx

	mov si,l
	mov di,h
	dec si
	mov resultadoPartition,si ; l -1

	mov al,arreglo[di]

	mov si, h
	dec si ; si = h-1
	mov di,l ; di = l
	For:
		cmp di,si
		ja EndFor
		cmp al,arreglo[di]
		jae If
		inc di
		jmp For

	If:
		inc resultadoPartition
		swap arreglo, resultadoPartition
		inc di
		jmp For

	EndFor:
		inc resultadoPartition
		mov di,h
		swap arreglo,resultadoPartition


	pop bx
	pop ax
	pop di
	pop si
endm



swap macro arreglo, i
	push si
	push ax
	push bx

	mov si,i

	;[0][1]
	mov al,arreglo[si]  ;al = 1 - [1] = 1
	mov bl,arreglo[di]  ;di = 0 -  [0] = 0

	mov arreglo[si],bl ; [1]=0
	mov arreglo[di],al ; [0]=1
 
	pop bx
	pop ax
	pop si
endm

;**********************************************************************************
;------------------------------------MODO VIDEO -----------------------------------

	INI_VIDEO macro
		mov ax, 0013h
		int 10h
		mov ax, 0A000h
		mov ds, ax
	endm

	FIN_VIDEO macro
		mov ax, 0003h
		int 10h
		mov ax, @data
		mov ds, ax
	endm


	pintar_pixel macro a, b, color
		push ax
		push bx
		push di
		xor ax, ax
		xor bx, bx
		xor di, di
		mov ax, 320d
		mov bx, a
		mul bx
		add ax,b
		mov di, ax
		mov al, color
		mov [di],al
		pop di
		pop bx
		pop ax
	endm


	delay macro param
		LOCAL ret2, ret1, finRet
		push ax
		push bx
		xor ax, ax
		xor bx, bx
		mov ax, param
		ret2:
			dec ax
			jz finRet
			mov bx, param
			ret1:
				dec bx
			jnz ret1
		jmp ret2
		finRet:
		pop bx
		pop ax
	endm

	push_s macro
		push ax
		push bx
		push cx
		push dx
		push si
		push di
	endm

	pop_s macro
		pop di
		pop si
		pop dx
		pop cx
		pop bx
		pop ax

	endm


	pintar_marco macro izq, der, arr, aba, color
		LOCAL ciclo1,ciclo2
		push si
		xor si,si
		mov si, izq

		ciclo1:
			pintar_pixel arr, si, color
			pintar_pixel aba, si, color
			inc si
			cmp si, der
			jne ciclo1

			xor si, si
			mov si, arr

		ciclo2:
			pintar_pixel si, der, color
			pintar_pixel si, izq, color
			inc si
			cmp si, aba
			jne ciclo2
			pop si
	endm

	Datos_Video macro
		push ax
		mov ax, 0A000h
		mov ds, ax
		pop ax
	endm

	Video_Datos macro
		push ax
		mov ax, @data
		mov ds, ax
		pop ax
	endm

	PintarBarra macro xo,yo,yf,xf, color
		LOCAL ciclo1, ciclo2
		xor cx, cx
		xor si,si
		mov dx, xo
		mov si, dx
		ciclo1:
			xor cx, cx
			mov dx, yo
			mov cx, dx
			ciclo2:
				mov al, color
				pintar_pixel cx,si,9d
				inc cx
			mov dx, yf
			cmp cx,dx
			jnz ciclo2

			inc si
		cmp si, xf
		jne ciclo1
	endm 


	ImprimirModoVideo macro fila,columna, texto
		xor ax,ax
		mov ah, 02h
		mov bh, 00h
		mov dh, fila
		mov dl, columna
		int 10h
		Video_Datos
		print texto
		Datos_Video 

	endm

	Graficar macro arreglo, texto,vel
		push ds
			mov ax, 0
			push ax
			mov ax, @data
			mov ds, ax
			AnchoBarra

			INI_VIDEO
				;pintar_pixel 120h, 160, 15d
				;  izq, der,arr, ab,color
				pintar_marco 10, 310, 20d, 180d, 10d
				;DibujarBarras arreglo
				;izq, arr,ab,der,color
				PintarBarra 150d,25d,155,170d,5d
				;PintarBarra 15,35,155,35,5		
				;DibujarBarras arreglo
				mov al, vel
				sub al, 30h
				mov vel, al
				mov al, ancho
				sub al, 30h
				mov ancho, al
				ImprimirModoVideo 20d, 6d, arreglo
				ImprimirModoVideo 0d, 6d, texto
				ImprimirModoVideo 5d, 3d, prueba
				ImprimirModoVideo 6d, 3d, vel
				ImprimirModoVideo 7d, 3d, pruebaAncho
				ImprimirModoVideo 8d, 3d, ancho

				delay 3000
			FIN_VIDEO

			mov ax,4c00h
			int 21h

			Video_Datos
	endm

	DibujarBarras macro arreglo
		LOCAL Ini, Dibujar,Fin
		mov actualAcumulado, 0
		mov inicioAcumulado,0
		mov auxContador,0
		Ini:
			
			
			add auxContador,1
			mov al, lengthArreglo
			cmp auxContador,al
			jae Fin
			jb Dibujar
		Dibujar:	
			xor al,al
			mov al, actualAcumulado
			mov inicioAcumulado, al
			mov al, ancho		
			add actualAcumulado,al
			mov cl,inicioAcumulado
			mov bl,actualAcumulado
			xor ax,ax
			xor dx,dx
			add ax, 40
			mov dx, 60
			;izq, arr,ab,der,color
			PintarBarra ax,25d,dx,30,5d
			;ImprimirModoVideo 20d, 6d, arrayTexto

			
			SaltoLinea
			jmp Ini
			
		Fin:
	endm

	AnchoBarra macro 
		LOCAL Ini, Diez, Veinte, Treinta, Cuarenta, Cincuenta, Sesenta, Sietenta, Ochenta, Noventa,Recorrer
		;Solo puedo usar registro di o bx
		; si uso bx, no puedo usar bl
		Ini:
		mov ah,0
		mov al, 30
		mov cl, lengthArreglo
		idiv cl

		;Convertir a decmimal
			add al, 30h
			add ah, 30h
			mov bl, ah

		mov espaciador, al
		mov espacio, bl

		mov al, espaciador

			cmp espaciador,31h
			je Diez
			cmp espaciador,32h
			je Veinte
			cmp espaciador,33h
			je Treinta
			cmp espaciador,34h
			je Cuarenta
			cmp espaciador,35h
			je Cincuenta
			cmp espaciador,36h
			je Sesenta
			cmp espaciador,37h
			je Sietenta
			cmp espaciador,38h
			je Ochenta
			cmp espaciador,39h
			je Noventa
		Diez:
			mov numero2, 10
			mov num1A,1
			inc si
			jmp Recorrer
		Veinte:
			mov numero2, 20
			mov num1A,2
			inc si
			jmp Recorrer
		Treinta:
			mov numero2, 30
			mov num1A,3
			inc si
			jmp Recorrer
		Cuarenta:
			mov numero2, 40
			mov num1A,4
			inc si
			jmp Recorrer
		Cincuenta:
			mov numero2,5
			inc si
			jmp Recorrer
		Sesenta:
			mov numero2, 60
			mov num1A,6
			inc si
			jmp Recorrer
		Sietenta:
			mov numero2, 70
			mov num1A,7
			inc si
			jmp Recorrer
		Ochenta:
			mov numero2, 80
			mov num1A,8
			inc si
			jmp Recorrer
		Noventa:
			mov numero2, 90
			mov num1A,9
			inc si
			jmp Recorrer
		Recorrer:
		mov al, numero2
		mov ancho,0
		mov ancho,al
		imprimeDecimal ancho
	endm
;**********************************************************************************
;-------------------------------------REPORTE--------------------------------------
	CrearReporte macro 
		LOCAL Ini, Final, Error, Creado
		Ini:
			mov ah, 3ch 	;Crear archivo
			mov cx, 0
			mov dx, offset nombreRep	; N
			int 21h
			jc Error
			jmp Creado
			Error:
				print ErroRep
			Creado:
				print creadoRep
				mov bx,ax
				mov ah, 3eh 
				int 21h
				jmp Final

			Final:

	endm

	EliminaReporte macro
		LOCAL Ini, Fin,Error, Eliminado
		Ini:
			mov ah, 41h
			mov dx, offset nombreRep
			int 21h
			jc Error
			jnc Eliminado

		Error:
			print errorEliminarRep
			jmp Fin
		Eliminado:
			print eliminarRep
			jmp Fin
		Fin:

	endm

	getHora macro
		mov ah, 2ch
		int 21h

		mov hora, ch
		mov minutos, cl
		mov segundos, dh

		mov al, [hora]
		mov cl, 10
		mov ah, 0
		div cl
		or ax, 3030h
		mov bx, offset horaRep
		mov [bx],al
		inc bx
		mov [bx], ah
		inc bx
		mov horaRep[03],':'

		mov al,[minutos]
		mov cl,10
		mov ah, 0
		div cl
		or ax,3030h
		mov bx, offset minutoRep
		mov [bx], al
		inc bx
		mov [bx],ah
		inc bx
		mov minutoRep[03],':'

		mov al,[segundos]
		mov cl,10
		mov ah, 0
		div cl
		or ax,3030h
		mov bx, offset segundoRep
		mov [bx], al
		inc bx
		mov [bx],ah
		inc bx
	endm

	ObtenerHora macro
	LOCAL DIVIDIR, OBTENERH, OBTENERS, OBTENERM, FIN
	xor si, si
	mov ah,2ch
	int 21h
	mov aux1, ch

	DIVIDIR:
		mov ah, 0
		mov al, aux1
		mov bl, 10
		div bl 
		add al , 48
		add ah , 48
		cmp si, 0
		je OBTENERH
		cmp si, 2
		je OBTENERM
		jmp OBTENERS

	OBTENERH:
		mov mhora[0] , al
		inc si
		mov mhora[1] , ah
		inc si
		mov aux1, cl
		jmp DIVIDIR

	OBTENERM:
		mov mmin[0] , al
		inc si
		mov mmin[1] , ah
		inc si
		mov aux1, dh
		jmp DIVIDIR

	OBTENERS:
		mov mseg[0] , al
		inc si
		mov mseg[1] , ah
		inc si
	
	FIN:
endm