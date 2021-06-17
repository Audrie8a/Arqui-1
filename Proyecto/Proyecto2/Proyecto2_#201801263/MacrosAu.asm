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

escribir macro handler, buffer, numbytes

	mov ah, 40h
	mov bx, handler
	mov cx, numbytes
	lea dx, buffer
	int 21h
	jc Error3
endm
escribirX macro array	;Write a single character inside the report
    local Inicio,Ciclo,fin
	Pushs
    xor di,di
	mov di,0
    mov ax,array[di]
    Inicio:
        cmp ax,"$"
        jne Ciclo
        jmp fin
    Ciclo:
        mov auxPrint,ax
        escribir HandlerArchivo,auxPrint,1
        inc di
        mov ax,array[di]
        jmp Inicio
    fin:
		Pops
	endm

getChar macro
	mov ah,01h
	int 21h
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
	jc Error2
	mov handler,ax
endm

crear macro buffer, handler
	
	mov ah,3ch
	mov cx,00h
	lea dx,buffer
	int 21h
	jc Error4
	mov handler, ax
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
		SaltoLinea
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
		;FreqCalc
		FecuenciaCalc
		sub sizeArrayFrec, 1
		mov ax, sizeArrayDatos
		mov lenghArregloPrint, ax	

		;SaltoLinea
		;imprimiArreglo arrayDatos
		;SaltoLinea

		;imprimiArreglo arrayFecuencias
		;SaltoLinea

		ModaCalc
		CalcularMax NumerosReal, lengthArray
		CalcularMin NumerosReal
		MedianaCalc NumerosReal, lengthArray
		
		jmp Fin
		
	Err:
		Print errDatos	
		SaltoLinea
		jmp Fin
	Fin:


	;GenerateUniqueArray ArrayFrequency,ArrayHeights,arrlength,arrlengthheight
	;BubbleSort ArrayHeights,arrlengthheight,orderDESC
endm

MedianaCalc macro arreglo, size
	Local Par, Impar, Fin
	mov aux2, 0
	mov aux, 0
	Pushs
	xor ax, ax
	xor bx,bx
	mov bx, 2
	mov ax, size
	add ax, 2
	cwd
	idiv bx
	mov Pivote, ax
	cwd
	idiv bx
	cmp dx, 0
	je Inicio
	jmp Impar
	Par:
		mov ax, size
		add ax, 2
		mov bx,2
		cwd
		idiv bx
		mov si,ax
		mov bx, arreglo[si]
		mov aux, bx
		dec si
		dec si
		mov bx, arreglo[si]
		mov aux2, bx
		mov ax, aux
		mov bx, aux2
		add ax, bx
		mov bx, 2
		mov aux, ax
		mov aux2, bx

		ManejaDecimal aux, aux2, MedDecimal, MedEntero
		jmp Fin
	Impar:
		mov ax, size
		mov bx, 2
		cwd
		idiv bx
		mov si, ax
		mov bx, arreglo[si]
		mov MedEntero, bx
		jmp Fin
	Fin:
		Pops
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
		cmp si, lenghArregloPrint
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

NumeroMaximo macro  array, size
	MaxCalc array, size
	mov si, contador
	PrintX contador
	SaltoLinea
	;add si, 2
	mov  ax, arrayDatos[si]
	mov MayorNum, ax
endm

PromedioCalc macro arreglo
	Local Inicio, Dividir
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
		;mov ax, sumaDatos
		;cwd
		;mov bx, TamaArreglo
		;idiv bx
		;mov promedio, ax
		;mov residuo, dx
		;jmp Fin
		ManejaDecimal sumaDatos, TamaArreglo, residuo, promedio
		;Decimal_Text promedio, promedioTxt
		;Decimal_Text residuo, residuoTxt			
		Pops
endm

ManejaDecimal macro suma, size, residuo, numero
    Local Inicio
    Pushs
    xor dx, dx
    mov ax, suma
    mov bx, size
    div bx
    xor cx,cx
    mov numero, ax
    Inicio:
        mov ax, dx
        xor dx, dx
        push bx
        mov bx, 10
        mul bx
        pop bx
        xor dx,dx
        div bx
        push ax
        push dx
        push bx
        xor dx, dx
        mov ax, residuo
        mov bx, 10
        mul bx
        mov residuo, ax
        pop bx
        pop dx
        pop ax
        add residuo, ax

        inc cx
        cmp cx, 4
        jnz Inicio        
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
	Local Inicio, Fin, Match, GuardarAsignar
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
		jmp Match
	Match:
		mov bx, arrayDatos[di]
		cmp ax, bx
		je Asignar

		cmp bx, '$'
		je Guardar

		inc di
		inc di

		jmp Match

	Asignar:
		mov ax, arrayFecuencias[di]
		mov bx, 1

		add ax,bx
		mov arrayFecuencias[di], ax
		xor di, di
		add sizeArrayFrec, 1

		jmp Inicio
	Guardar:
		mov arrayDatos[di], ax
		inc sizeArrayDatos
		inc sizeArrayDatos
		mov arrayFecuencias[di], 1

		jmp Inicio

	Fin:
		Pops
endm

ModaCalc macro 
	Pushs
	MaxCalc arrayFecuencias
	mov si, contador
	xor ax, ax
	mov ax, arrayDatos[si]	
	mov ModaNum, ax
	Pops
endm

MaxCalc macro array
	Local Inicio, Fin, Mayor, Check, Check2
	Pushs
	xor si, si
	mov ax, array[0]
	mov maxFreq, ax 		; mayor= array[0]
	xor bx, bx
	mov contador, 0
	mov si, -2
	Inicio:
		inc si
		inc si

		mov ax, array[si+2]	; Siguiente	
		cmp ax, 36
		je Fin			

		
		mov ax, array[si+2]	; Siguiente	
		cmp ax, maxFreq
		ja Mayor

		jmp Inicio
	Mayor:
		xor bx,bx
		xor ax,ax
		inc contador
		inc contador
		mov ax, array[si+2]
		mov maxFreq, ax
		

		jmp Inicio
	
	Fin:		
		Pops
endm

CalcularMax macro arregloOrdenado, size
	Pushs
		xor ax, ax
		xor di, di
		mov di, size
		mov ax, arregloOrdenado[di]
		mov MayorNum, ax
	Pops

endm
CalcularMin macro arregloOrdenado
	Pushs
		xor ax, ax
		mov ax, arregloOrdenado[0]
		mov MinimoNum, ax
	Pops
endm

RespuestasTexto macro 
	Pushs
	xor ax, ax
	mov ax, promedio
	mov auxPromedio, ax

	mov ax, residuo
	mov auxDecProm, ax

	mov ax, MedEntero
	mov auxMediana, ax

	mov ax, MedDecimal
	mov auxDecMediana, ax

	mov ax, ModaNum
	mov auxModa, ax

	mov ax, MayorNum
	mov auxMax , ax

	mov ax, MinimoNum
	mov auxMin, ax

	;Decimal_Text auxMediana, txtMediana
	;Decimal_Text auxDecMediana, txtDecMediana
	;Decimal_Text auxPromedio, txtPromedio
	;Decimal_Text auxDecProm, txtDecProm
	;Decimal_Text auxModa, txtModa
	;Decimal_Text auxMax, txtMax
	;Decimal_Text auxMin, txtMin

	Pops

endm
escribeTabla macro arreglo, arreglo2, handlerEntrada
	Local Inicio, Fin
	Pushs
	push si
	xor si,si
	Inicio:
		mov ax, arreglo[si]

		cmp ax, 24h
		je Fin
		escribir handlerEntrada, Salto, SIZEOF Salto
		Decimal_Text arreglo[si], textNum
		escribirX textNum
		escribir handlerEntrada, Space, SIZEOF Space
		Decimal_Text arreglo2[si], textNum
		escribirX textNum

		inc si
		inc si
		jmp Inicio

	Fin:
		pop si
		Pops
endm
GenerarReporte macro nombreRep, handlerEntrada
	RespuestasTexto
	;PrintX auxMediana
	;Print auxMediana
	;Print punto
	;Print auxDecMediana
	;SaltoLinea
	;Print auxPromedio
	;Print punto
	;Print auxDecProm
	;SaltoLinea
	;Print auxModa
	;SaltoLinea
	;Print auxMax
	;SaltoLinea
	;Print auxMin
	;SaltoLinea
	
	crear nombreRep, handlerEntrada
	escribir handlerEntrada, rep0, SIZEOF rep0
	escribir handlerEntrada, rep1, SIZEOF rep1
	escribir handlerEntrada, rep2, SIZEOF rep2
	Decimal_Text auxMediana, txtaux
	escribirX txtaux
	escribir handlerEntrada, PTO, SIZEOF PTO
	;escribirX PTO
	Decimal_Text auxDecMediana, txtaux
	escribirX txtaux
	escribir handlerEntrada, rep3, SIZEOF rep3
	Decimal_Text auxPromedio, txtaux
	escribirX txtaux
	escribir handlerEntrada, PTO, SIZEOF PTO
	;escribirX PTO
	Decimal_Text auxDecProm, txtaux
	escribirX txtaux
	escribir handlerEntrada, rep4, SIZEOF rep4
	Decimal_Text auxModa, txtaux
	escribirX txtaux
	escribir handlerEntrada, rep5, SIZEOF rep5
	Decimal_Text auxMax, txtaux
	escribirX txtaux
	escribir handlerEntrada, rep6, SIZEOF rep6
	Decimal_Text auxMin, txtaux
	escribirX txtaux
	escribir handlerEntrada, rep7, SIZEOF rep7
	escribir handlerEntrada, rep8, SIZEOF rep8
	escribir handlerEntrada, rep9, SIZEOF rep9
	mov ax, lengthArray
	mov lenghArregloPrint, ax
	escribeTabla arrayDatos, arrayFecuencias, handlerEntrada


	;escribir handlerEntrada, rep0, SIZEOF rep0
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

