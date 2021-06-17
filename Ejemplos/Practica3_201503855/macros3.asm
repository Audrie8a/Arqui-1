print macro buffer ;imprimir cadenas
	push ax
	push dx
    mov ah,09h ;Numero de funcion para imprimir cadena en pantalla
	mov dx, @data ;con esto le decimos que nuestro dato se encuentra en la sección data
	mov ds,dx ;el ds debe apuntar al segmento donde se encuentra la cadena (osea el dx, que apunta  a data)
	mov dx,offset buffer ;especificamos el largo de la cadena, con la instrucción offset
	int 21h  ;ejecutamos la interrupción
	pop dx
	pop ax
endm

printchar macro char
	push ax
    MOV al, char
    MOV var, al
    print var
    pop ax    
endm

getChar macro
	mov ah,01h
	int 21h
endm

close macro ;cierra el programa
	mov ah,4ch ;termina el programa
	xor al,al ;limpia al
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

obtenerNumero macro buffer
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
		mov num1, al
		CharToNum num1, 2, num1, negativo1
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


;=============================================================
;=======================CONVERTIR NUMEROS=====================
;=============================================================
StringToInt macro string
LOCAL Unidades,Unidades2,Decenas,Decenas2,Prueba,Verificar,Negar,salir	
	sizeNumberString string
	xor ax,ax
	cmp bl,1
	je Unidades
	cmp bl,2
	je Verificar
	cmp bl,3
	je Decenas2

	Unidades:
		mov al,string[0]
		SUB al,30h
		jmp salir

	Unidades2:
		mov al,string[1]
		SUB al,30h
		neg al
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

	Decenas2:
		
		mov al,string[1]
		sub al,30h
		mov bl,10
		mul bl

		xor bx,bx
		mov bl,string[2]
		sub bl,30h

		add al,bl	
		;print debug
		neg al
		jmp salir

	Verificar:
		mov al,string[0]
		cmp al,2Dh
		je Negar 
		jmp Decenas
	Negar:
		;mov negativoflag,1
		jmp Unidades2
	Prueba:
		;print debug
		jmp salir
	salir:
	; en el registro al se guarda el numero entero
endm


IntToString macro numero, arreglo
LOCAL Unidades,Decenas,UnidadesNegativas,DecenasNegativas,Negativo, Salir
	xor ax,ax
	xor bx,bx

	mov al,numero
	test al,al
	js Negativo
	cmp al, 9 
	ja Decenas

	Unidades:
		add al,30h
		mov arreglo[0],al
		jmp Salir

	UnidadesNegativas:
		add al,30h
		mov arreglo[1],al
		jmp Salir

	Decenas:
		mov bl,10
		div bl
		add al,30h
		add ah,30h
		mov arreglo[0],al
		mov arreglo[1],ah
		jmp Salir
	DecenasNegativas:
		mov bl,10
		div bl
		add al,30h
		add ah,30h
		mov arreglo[1],al
		mov arreglo[2],ah
		jmp Salir
	Negativo:
		mov arreglo[0],2Dh
		neg al
		cmp al, 9 
		ja DecenasNegativas
		jmp UnidadesNegativas
	Salir:
endm


sizeNumberString macro string
LOCAL LeerNumero, endTexto
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

SumarNumeros macro numero1
	;limpiar bufferReporte, SIZEOF bufferReporte,24h
	;mov reporteauxiliar,numero1
	;mov si,contadorreporte
	;mov bufferReporte[si], numero1
				;inc contadorreporte
				
	;Se pide el segundo numero
	print pedirnumero
	limpiar numero2, SIZEOF numero2,24h
	obtenerTexto numero2
	;Se convierte a entero
	StringToInt numero2
	mov reporteauxiliar,al
	mov num2,al
	limpiar numero2, SIZEOF numero2,24h 
	;Se efectuan la suma
	mov ah,num1
	;neg ah
	mov al,num2
	add al,ah
	limpiar resultado, SIZEOF resultado,24h
	mov resultado, al

	;=================================================
	add reporteauxiliar, 48
	escribir handlerEntrada, reporteauxiliar, SIZEOF reporteauxiliar
	mov reporteauxiliar,0
	;=====================================================
	;Se le asigna el contador para convertirlo a string
	xor ax,ax
	mov al,resultado
	mov num1, al
 	mov contador,al
 	;Se convierte a string y se imprime
 	push ax

 	IntToString contador, resultado
 	;IntToString contador, numero2
 	print msgsuma	
 	print resultado
 	;print numero2
 	print salto
	pop ax
endm

RestarNumeros macro numero1
	;Se pide el segundo numero
	print pedirnumero
	limpiar numero2, SIZEOF numero2,24h
	obtenerTexto numero2
	;Se convierte a entero
	StringToInt numero2
	mov reporteauxiliar,al
	mov num2,al
	limpiar numero2, SIZEOF numero2,24h 
	;Se efectua la resta
	mov al,num1
	sub al,num2
	limpiar resultado, SIZEOF resultado,24h
	mov resultado, al
	;=================================================
	add reporteauxiliar, 48
	escribir handlerEntrada, reporteauxiliar, SIZEOF reporteauxiliar
	mov reporteauxiliar,0
	;=====================================================
	;Se le asigna el contador para convertirlo a string
	xor ax,ax
	mov al,resultado
	mov num1, al
 	mov contador,al
 	;Se convierte a string y se imprime
 	push ax
 	IntToString contador, resultado
 	
 	print msgresta	
 	print resultado
 	;print numero2
 	print salto
	pop ax
endm

MultiplicarNumeros macro numero1
	
	;Se pide el segundo numero
	print pedirnumero
	limpiar numero2, SIZEOF numero2,24h
	obtenerTexto numero2
	;Se convierte a entero
	StringToInt numero2
	mov reporteauxiliar,al

	mov num2,al
	limpiar numero2, SIZEOF numero2,24h 
	;Se efectua la multiplicacion
	mov al,num1
	mov bl,num2
	imul bl
	limpiar resultado, SIZEOF resultado,24h
	mov resultado, al
	;=================================================
	add reporteauxiliar, 48
	escribir handlerEntrada, reporteauxiliar, SIZEOF reporteauxiliar
	mov reporteauxiliar,0
	;=====================================================
	;Se le asigna el contador para convertirlo a string
	xor ax,ax
	mov al,resultado
	mov num1, al
 	mov contador,al
 	;Se convierte a string y se imprime
 	push ax
 	IntToString contador, resultado
 	
 	
	print msgmultiplicacion	
	print resultado
	print salto
	pop ax
endm	

DividirNumeros2 macro numero1
	;Se pide el segundo numero
	print pedirnumero
	limpiar numero2, SIZEOF numero2,24h
	obtenerTexto numero2
	;Se convierte a entero
	StringToInt numero2
	mov num2,al
	limpiar numero2, SIZEOF numero2,24h 
	;Se efectua la division
	
	mov al,num1
	mov bl,num2
	idiv bl

	limpiar resultado, SIZEOF resultado,24h

	mov resultado, al
	;Se le asigna el contador para convertirlo a string
	xor ax,ax
	mov al,resultado
	mov num1, al
 	mov contador,al
 	;Se convierte a string y se imprime
 	push ax
 	IntToString contador, resultado
 	
 	print msgdivision
 	print resultado
 	;print numero2
 	print salto
	pop ax
endm


DividirNumeros  macro numero1
	LOCAL PrimeroPositivo,PrimeroNegativo,Salida
	;Se pide el segundo numero
	print pedirnumero
	limpiar numero2, SIZEOF numero2,24h
	obtenerTexto numero2
	;Se convierte a entero
	StringToInt numero2
	mov reporteauxiliar,al
	mov num2,al
	;=================================================
	add reporteauxiliar, 48
	escribir handlerEntrada, reporteauxiliar, SIZEOF reporteauxiliar
	mov reporteauxiliar,0
	;=====================================================
	limpiar numero2, SIZEOF numero2,24h 
	;Se efectua la multiplicacion
	xor ax,ax
	xor bx,bx
	xor dx,dx
	mov al,num1
	
	test al,al
	js PrimeroNegativo
	cmp al,0
	ja PrimeroPositivo
	;jmp PrimeroPositivo

	PrimeroNegativo:
		neg al
		mov bl,num2
		idiv bl

		limpiar resultado, SIZEOF resultado,24h
		neg al
		mov resultado, al

		;Se le asigna el contador para convertirlo a string	
		mov al,resultado
		mov num1, al
	 	mov contador,al
	 	;Se convierte a string y se imprime 	
	 	IntToString contador, resultado	
		print msgdivision	
		print resultado
		print salto	
		jmp Salida
	PrimeroPositivo:
		mov bl,num2
		idiv bl

		limpiar resultado, SIZEOF resultado,24h
		mov resultado, al

		;Se le asigna el contador para convertirlo a string	
		mov al,resultado
		mov num1, al
	 	mov contador,al
	 	;Se convierte a string y se imprime 	
	 	IntToString contador, resultado	
		print msgdivision	
		print resultado
		print salto	
	Salida:

endm

FactorialNumero macro num_factorial
	LOCAL Imprimir,Salir
	mov al,num_factorial                    ;recibo el factorial
	mov contador,al							;lo paso a contador
	;push ax	
	IntToString contador, numerofactorial	;lo parseo a string
	;print msgfactorial2
	;print numerofactorial					;y aqui lo imprimiera
	;print salto
	;pop ax
	xor ax,ax								;limpio variable
	xor cx, cx								;limpio variable
	mov al,contador							;muevo a al el contador para ax
	mov contadorfactorial,1					;inicializo en 0 el contador que se incrementara
	print msgfactorial1
	print factorial0
	Imprimir:	
		cmp ax,cx		
		;printchar al					;comparo
		je Salir                            ;si son iguales se sale

		push ax								;guardo valores
		push cx								;guardo valores
		xor ax,ax							;limpio variable
		xor cx,cx							;limpio variable
		mov al,contadorfactorial			;el contador lo guardo en al
		mov auxfactorial,al					;guardo en aux factorial que es donde regresa en string
		mov contadoraux,al					;guardo en contador aux que es el contador del numero que sera el factorial
		limpiar auxfactorial, SIZEOF auxfactorial,24h	;limip la variable
		IntToString contadoraux, auxfactorial			;la regreso a string
		

		mov al,contadorfactorial
		sub al,1
		limpiar anteriorfactorial, SIZEOF anteriorfactorial,24h
		mov anteriorfactorial, al
		;mul
		mov al,anteriorfactorial
		mov bl,contadorfactorial
		imul bl
		limpiar actualfactorial, SIZEOF actualfactorial,24h
		mov actualfactorial, al
		IntToString actualfactorial,actualfactorial
		IntToString anteriorfactorial, anteriorfactorial

		;print anteriorfactorial
		
		print auxfactorial					;imprimo valores
		print msgfactorial2	
		;print actualfactorial
		HacerFactorial auxfactorial
		print msgfactorial3
		
		

		pop cx								;regreso valores
		pop ax								;regreso valores
						;imprimo !=

		inc contadorfactorial				;incremento el contador que lleva el conteo xd
		inc cx
		jmp Imprimir
	Salir:
		;print cadenafactorial
		
		print resfactorial
endm

HacerFactorial macro num_factorial2
	LOCAL IMPRIMIR,SALIR
	StringToInt num_factorial2
	;mov al,num_factorial2
	;printchar al
	mov contadornew,al
	xor ax,ax
	xor dx,dx
	mov al,contadornew
	mov dl,1

	;mov conteo2,1

	Imprimir:
		;printchar al
		;printchar dl
		mov conteo2,dl
		mov temp,dl
		add temp, 48
		printchar temp

		;push ax								;guardo valores
		;mov al,conteo3
		;mov bl,dl
		;mul bl
		;mov conteo3,al
		;pop ax
		

		cmp ax,dx
		je SALIR
		print factorialX
		;printchar dl
		push ax								;guardo valores
		;push dx	

		;xor ax,ax							;limpio variable
		;xor dx,dx
		;mov al,conteo3
		;mov bl,dl
		;mul bl
		;mov conteo3,al
		;Num conteo3
		;printchar conteo3
		;print debug
		
		;printchar conteo1
		;limpiar conteo1, SIZEOF conteo1,24h
		;mov resultadofactorial,al
		;IntToString conteo2,conteo1
		;print conteo1
		;pop dx								;regreso valores
		pop ax	
		;inc conteo2
		inc dx
		jmp IMPRIMIR 
	SALIR:
		print factorialigual
		;printchar conteo3
	
		;Num conteo3
		limpiar resultadofactorial2, SIZEOF resultadofactorial2,24h
		IntToString conteo3, resultadofactorial2
		;print resultadofactorial2
		;printchar temp
		ResultadosFactorial temp

endm

ResultadosFactorial macro number
	LOCAL FuncionLoop,Mientras,Salir

	FuncionLoop:
		mov cl,number
		printchar cl
		Mientras:
			
		Salir:
	
	limpiar resultadofactorial2, SIZEOF resultadofactorial2,24h
	IntToString conteo3, resultadofactorial2
	print resultadofactorial2
endm

	;mov al,num_factorial2                    ;recibo el factorial
	;mov contador,al							;lo paso a contador
	;push ax	
	;limpiar numerofactorial, SIZEOF numerofactorial,24h
	;IntToString contador, numerofactorial	;lo parseo a string
	;print msgfactorial2
	;print numerofactorial					;y aqui lo imprimiera
	;print salto
	;pop ax

Num macro container
	mov al, container
	mov temp2, al
	add temp2, 48
	printchar temp2
	
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