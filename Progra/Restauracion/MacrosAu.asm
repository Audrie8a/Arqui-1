;ARCHIVOS
AbrirArchivo macro buffer,handler
    local Error1,Fin
    mov ah,3dh
    mov al,10b
    lea dx,buffer
    int 21h
    jc Error1
    mov handler,ax
    mov ax,0
    jmp Fin
    Error1:
        mov ax,1
    Fin:
endm

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

;MACROS

Print macro Text   ;Imprimir Texto
    mov ax,@data
    mov ds,ax
    mov ah,09h
    lea dx,Text
    int 21h
endm

PrintX macro numero ;Imprime Número con registros para 16 bits
    Local Inicio,Imprimir
	Pushs
    mov bx,4    
    xor ax,ax   
    mov ax,numero
    mov cx,10   
    Inicio:
        xor dx,dx
        div cx  
        push dx 
        dec bx  
        jnz Inicio
        xor bx,4  
    Imprimir:
        pop dx
        PrintNum dl
        dec bx
        jnz Imprimir

		Pops
endm

PrintNum macro Num    ;Imprime Número
    xor ax,ax
    mov dl,Num
    add dl,48

    mov ah,02h
    int 21h
endm

LeerTexto macro buffer   ;Lee Entrada Texto
    local Leer,Fin
    xor si,si   
    Leer:
        mov ah,1    
        int 21h     
        cmp al, 13  ;Enter
        je Fin  
        mov buffer[si],al  
		inc si 
        jmp Leer   
    Fin:
		mov buffer[si],24h   
endm

Comparar macro texto1, texto2	;Compara 2 Cadenas
	Pushs
	lea si, texto1
	lea di, texto2
	mov cx, LENGTHOF texto1	
	repe CMPSB
	Pops
endm

SaltoLinea macro
	mov ah, 02h
	mov dl, 10
	int 21h
	mov ah,02h
	mov dl, 13
	int 21h
endm

LimpiarPantalla macro
	mov  ah, 0
	mov  al, 3
	int  10H
endm

ComprobarArchivo macro entrada,nameArchivo
	local Inicio, Nombre,Fin,Salir,Comando
	Pushs		
	mov nameArchivo,0
	xor di,di
	xor si,si
	Inicio:
		mov al,entrada[si]

		cmp al,"_"
		je Nombre

		cmp al,"$"
		je Fin

		inc si
		jmp Inicio
	Nombre:
		inc si
		mov al,entrada[si]

		cmp al,"$"
		je Comando

		mov nameArchivo[di],al
		inc di
		jmp Nombre
	Comando:
		mov nameArchivo[di+1],00h
		LeerArchivo nameArchivo
		Comparar cmdabrir,cmdabrir	
		jmp Salir
	Fin:
		Comparar cmdsalir,cmdabrir	
		jmp Salir
	Salir:
		Pops
endm

LeerArchivo macro entrada
	local Estado, Fin
    AbrirArchivo entrada, HandlerArchivo
	cmp ax,1
	jne Estado
	Print errFile
	SaltoLinea
	jmp Fin
	Estado:
    	leer HandlerArchivo, ContenidoArchivo, SIZEOF ContenidoArchivo
    	cerrar HandlerArchivo
		Analizar ContenidoArchivo
		;obtenerNumeros ContenidoArchivo
		Print exitoFile
	Fin:
endm

obtenerNumeros macro arreglo
    LOCAL Inicio, Guardar, InicioGuardado, FinalGuardado, Final
    xor si,si
    xor di, di

    Inicio:
        cmp arreglo[si],24h ;Signo dollar
        je Final
        cmp arreglo[si],3Eh     ;Signo >
        je Guardar
        inc si
        jmp Inicio
    Guardar:
        inc si
        cmp arreglo[si],24h     ;Signo dollar
        je Inicio
        cmp arreglo[si], 0dh    ;Salto de línea
        je Inicio
        jmp InicioGuardado

    InicioGuardado:
        cmp arreglo[si], 3ch    ;Signo <
        je FinalGuardado
        mov al, arreglo[si]
        
        mov numeros[di],al  
        SaltoLinea
        Print numeros[di]   
        inc ContadorTexto
        inc si
        inc di
        jmp InicioGuardado
    FinalGuardado:
        mov numeros[di],20h     ;Espacio
        inc di
        jmp Inicio
    Final:
    inc di
    mov numeros[di],24h
    SaltoLinea
endm 



;Limpiar arreglos
clean macro buffer, numbytes, caracter
	LOCAL Repetir
	xor si,si ; colocamos en 0 el contador si
	xor cx,cx ; colocamos en 0 el contador cx
	mov	cx,numbytes ;le pasamos a cx el tamaño del arreglo a limpiar 

	Repetir:
		mov buffer[si], caracter ;le asigno el caracter que le estoy mandando 
		inc si ;incremento si
		Loop Repetir ;se va a repetir hasta que cx sea 0 
endm

ActualizarContadorSi macro num
	LOCAL Ini, Fin
	xor si,si
	mov auxContador,0
	Ini:
		mov ax, auxContador
		cmp ax, num
		je Fin

		inc si
		add auxContador,1
		jmp Ini
	Fin:
endm

;Creo que no lo voy a usar --Posiblemente lo Borre
depurarArreglo macro origen, destino, tama
	LOCAL Ini, Fin
	push si
	push ax
	push di
	xor ax,ax
	xor si,si	
	xor di,di	
	add tama,2
	clean destino, SIZEOF destino,24h		
	Ini:
		sub tama,2
		cmp  tama,-2
		je Fin
		
		mov di, tama
		mov ax, origen[di]
		mov destino[si], ax

		inc si
		jmp Ini

	Fin:
		mov TamaArreglo, si
		pop di
		pop ax
		pop si
endm


Text_Decimal macro texto, entero 
    Local Inicio, condicion, negativo, positivo, fin, negar
	Pushs
	xor ax,ax   
	xor cx,cx  
	xor bx,bx   
	xor di,di   
	mov bx,10	
	xor si,si   
	Inicio:
		mov cl,texto[si]  
		cmp cl,45  
		je negativo
		jmp positivo    
	negativo:
		inc di 
		inc si 
		mov cl,texto[si]   
	positivo:
		cmp cl,48  
		jl condicion 
		cmp cl,57  
		jg condicion  
		inc si  
		sub cl,48	
		mul bx		
		add ax,cx	
		jmp Inicio   
	condicion:
		cmp di,1    
		je negar   
		jmp fin    
	negar:
		neg ax  
	fin:
        mov entero,ax
		Pops
endm

Decimal_Text macro entero, text
	LOCAL Dividir,Dividir2,FinCr3,NEGATIVO,FIN2,FIN
	Pushs
	xor ax,ax
	mov ax, entero
	xor si,si
	xor cx,cx
	xor bx,bx
	xor dx,dx
	mov bx,0ah
	test ax,1000000000000000
	jnz NEGATIVO
	jmp Dividir2

	NEGATIVO:
		neg ax
		mov text[si],45
		inc si
		jmp Dividir2

	Dividir:
		xor dx,dx
	Dividir2:
		div bx
		inc cx
		push dx
		cmp ax,00h
		je FinCr3
		jmp Dividir
	FinCr3:
		pop ax
		add ax,30h
		mov text[si],ax
		inc si
		loop FinCr3
		mov ax,24h
		mov text[si],ax
		inc si
	FIN:
		Pops
endm

Analizar macro entrada	;Analyze the content from input
	Local Inicio, Guardar, InicioGuardado, Numeros, Check1, Check2, FinInicio 
	Local FinalGuardado,  fin, Max, Min, Minimo, Maximo
	
	mov ContadorTexto,0
	mov lengthArray,-2
	mov valorMax,0	
	mov valorMin,999
	mov si,-1

	Inicio:
		inc si
		mov bl,entrada[si]
		cmp bl,'>'
		jne Inicio
		jmp Guardar
	Guardar:
		inc si
		mov bl,entrada[si]
		cmp bl,">"
		jne Guardar
		jmp InicioGuardado
	InicioGuardado:
		inc si
		mov bl,entrada[si]
		cmp bl,"<"
		je FinalGuardado
		mov di,ContadorTexto
		mov NumeroString[di],bl
		inc ContadorTexto
		jmp InicioGuardado
	FinalGuardado:
		inc lengthArray
		inc lengthArray
		mov contadorActual,si
		Text_Decimal NumeroString,NumeroInt	
		mov si,contadorActual
		mov di,lengthArray
		mov bx,NumeroInt
		mov NumerosReal[di],bx

		mov NumeroString[2],0
		mov NumeroString[1],0
		mov ContadorTexto,0
		mov NumeroString,0
		jmp Max
	Check1:
		inc si
		mov bl,entrada[si]
		cmp bl,"<"
		je Check2
		jmp Check1
	Check2:
		inc si
		mov bl,entrada[si]
		cmp bl,"/"
		je FinIni
		jmp Guardar
	Max:
		mov ax,valorMax
		cmp bx,ax
		je Min
		jl Min
		jg Maximo
	Maximo:
		mov valorMax,bx
		jmp Min
	Min:
		mov ax,valorMin
		cmp bx,ax
		je Numeros
		jg Numeros
		je Minimo
	Minimo:
		mov valorMin,bx
		jmp Numeros
	Numeros:
		inc si
		mov bl,entrada[si]
		cmp bl,">"
		je Check1
		jmp Numeros
	
	FinIni:
		inc si
		mov bl,entrada[si]
		cmp bl,"$"
		jne FinIni
	fin:
		;SaltoLinea
        ;PrintX lengthArray
        ;SaltoLinea
        ;PrintX NumerosReal[0]
        ;SaltoLinea
        ProcesarDatos	
endm

GetSizeArray macro
 	push ax
 	mov ax, lengthArray
 	add ax, 2
 	cwd
 	mov bx, 2 
 	idiv bx
 	mov TamaArreglo, ax
 	pop ax
endm

ProcesarDatos macro
	Local Inicio, Fin, Procesos, Err
	GetSizeArray ;Obtener SizeArreglo
	xor ax, ax
	Inicio:
		mov ax, TamaArreglo
		cmp ax, 0
		je Err
	Procesos:
		OrdenarAsc
		PromedioCalc NumerosReal
		FreqCalc
		jmp Fin
	Err:
		Print errDatos	
		SaltoLinea
		jmp Fin
	Fin:
	;PrintX arrayDatos[0]
	;SaltoLinea
	;PrintX arrayFecuencias[0]
	;SaltoLinea
	;GenerateFreq NumerosReal,lengthArray
	;FindMode ArrayOrder,ArrayFrequency,arrlength
	;FindMedian NumerosReal,lengthArray
	;GenerateUniqueArray ArrayFrequency,ArrayHeights,arrlength,arrlengthheight
	;BubbleSort ArrayHeights,arrlengthheight,orderDESC
endm

BurbujaAsc2 macro arreglo
    LOCAL BURBUJA, VERIFICARMENOR, RESETEAR, FIN, MENOR
    xor si,si
    xor ax,ax
    xor bx,bx
    xor cx,cx
    xor dx,dx
    mov dx,TamaArreglo
    dec dx
    BURBUJA:
       mov ax,arreglo[si]
       mov bx,arreglo[si+1]
       cmp ax,bx
       jg MENOR
       inc si
       inc cx
       cmp cx,dx
       jne BURBUJA
       mov cx,0
       mov si,0
       jmp VERIFICARMENOR
    MENOR:
        mov arreglo[si],bx
        mov arreglo[si+1],ax
 	inc si
        inc cx
        cmp cx,dx
        jne BURBUJA
        mov cx,0
        mov si,0
        jmp VERIFICARMENOR
    VERIFICARMENOR:
        mov ax,arreglo[si]
        mov bx, arreglo[si+1]
        cmp ax,bx
        jg RESETEAR
        inc si
        inc cx
        cmp cx,dx
        jne VERIFICARMENOR
        jmp FIN
    RESETEAR:
        mov si,0
        mov cx,0
        jmp BURBUJA
    FIN:
endm

LimpiarRegistros macro
	xor ax, ax
	xor bx, bx
	xor cx, cx
	xor dx, dx
	xor di, di
	xor si, si
endm

OrdenarAsc macro 
	Local Inicio, Fin, Swap, Siguiente, Condicion
	Pushs
	LimpiarRegistros
	
	Inicio:
		mov ax, NumerosReal[si]		; ax = Posicion Inicial
		mov bx, NumerosReal[si+2]	; bx = Siguiente Posicion
	Swap:
		cmp ax, bx
		jbe Siguiente	;si <= lengthArray

		;Swap
		mov NumerosReal[si],bx
		mov NumerosReal[si+2],ax

		inc si
		inc si
		mov di, 0
		
		cmp si, lengthArray
		je Condicion

		jmp Inicio
	Condicion:
		cmp di, si
		je Fin

		mov di, 0
		mov si, 0
		jmp Inicio

	Siguiente:
		inc si
		inc si
		inc di
		inc di

		cmp si, lengthArray
		je Condicion

		jmp Inicio
	Fin:
		Pops
endm

OrdenarDesc macro 
	Local Inicio, Fin, Swap, Siguiente, Condicion
	Pushs
	LimpiarRegistros
	
	Inicio:
		mov ax, NumerosReal[si]		; ax = Posicion Inicial
		mov bx, NumerosReal[si+2]	; bx = Siguiente Posicion
	Swap:
		cmp ax, bx
		jae Siguiente	;si >= lengthArray

		;Swap
		mov NumerosReal[si],bx
		mov NumerosReal[si+2],ax

		inc si
		inc si
		mov di, 0
		
		cmp si, lengthArray
		je Condicion

		jmp Inicio
	Condicion:
		cmp di, si
		je Fin

		mov di, 0
		mov si, 0
		jmp Inicio

	Siguiente:
		inc si
		inc si
		inc di
		inc di

		cmp si, lengthArray
		je Condicion

		jmp Inicio
	Fin:
		Pops
endm

imprimiArreglo macro arreglo
	Local Inicio, Fin
	push si
	xor si,si
	Inicio:
		cmp si, lengthArray
		ja Fin

		Decimal_Text arreglo[si], textNum
		Print textNum
		Print espacio
		inc si
		inc si
		jmp Inicio

	Fin:
		SaltoLinea
		pop si
endm


PromedioCalc macro arreglo
	Local Inicio, Dividir, Fin
	Pushs
	xor si, si
	Inicio:
		cmp si, lengthArray
		ja Dividir

		mov ax, arreglo[si]
		add sumaDatos, ax	

		inc si
		inc si
		jmp Inicio
	Dividir:
		mov ax, sumaDatos
		cwd
		mov bx, TamaArreglo
		idiv bx
		mov promedio, ax
		mov residuo, dx
		jmp Fin
	Fin:
		Decimal_Text promedio, promedioTxt
		Decimal_Text residuo, residuoTxt			
		Pops
endm

FreqCalc macro
	Local For1, For2, Fin, Incrementar, Datos
	Pushs
	LimpiarRegistros
	mov di,-2 	; j
	mov  si,-2 	; i
	mov actual, 0
	mov index, -1	
	mov contador, 0
		For1:			

			add index,1
			inc si
			inc si



			cmp si, lengthArray
			ja Fin

			mov ax, NumerosReal[si]
			mov actual, ax
			Decimal_Text actual,textNum1
			

			jmp For2
			
		For2:
			inc di
			inc di

			PrintX di
			SaltoLinea

			cmp di, lengthArray
			ja For1

			Decimal_Text NumerosReal[di], textNum2			
			
			Print textNum1
			SaltoLinea
			Print textNum2
			SaltoLinea
			Comparar textNum1, textNum2
			je Incrementar

			jmp Fin
		Datos:
			mov di, index

			
			mov ax, contador 	
			mov arrayFecuencias[di], ax
			;Multiplico por 2 contador para obtener index
			mov ax, contador
			mov bx, 2
			imul bx
			mov contador ,ax
			mov si, contador 	; i= contador*2
			mov ax, actual 		
			
			mov arrayDatos[di], ax 	; arrayDatos[index]= actual
			
			
			xor di,di
			mov contador, 0
			jmp For1		
			
		Incrementar:
			Print espacio
			add contador, 1
			
			jmp For2
		Fin:
			Pops
endm
FecuenciaCalc macro 
	Local Inicio, Fin
	Pushs
	LimpiarRegistros
	mov sizeArrayDatos, 0
	mov di, 0
	mov si, 0
	mov ax, NumerosReal[si]
	mov arrayDatos[di], ax
	mov arrayFecuencias[di], 1
	Inicio:
		xor di,di

		cmp si, lengthArray
		je Fin

		inc si
		inc si
		mov ax, NumerosReal[si]
		jmp 
	Fin:
		Pops
endm

ModaCalc macro arreglo
	
endm


; Ayuda Stack
Pushs macro
    push ax
    push bx
    push cx
    push dx
    push di
	push si
    push bp
    push sp
	endm

Pops macro
    pop sp
    pop bp
    pop si
    pop di
	pop dx
    pop cx
    pop bx
    pop ax
	endm