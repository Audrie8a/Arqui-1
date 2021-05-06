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
	lea si, texto1
	lea di, texto2
	mov cx, LENGTHOF texto1	
	repe CMPSB
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
		Print exitoFile
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
Analizar macro entrada	
	local Inicio, Guardar, InicioGuardado, csecondtag, verify
	local verify2, cmaintag, FinalGuardado,  fin, checkmax
	local checkmin, assignmin, assignmax
	mov valorMax,0	
	mov valorMin,999
	mov si,-1
	mov ContadorTexto,0
	mov lengthArray,-2
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
		jmp checkmax
	checkmax:
		mov ax,valorMax
		cmp bx,ax
		je checkmin
		jl checkmin
		jg assignmax
	assignmax:
		mov valorMax,bx
		jmp checkmin
	checkmin:
		mov ax,valorMin
		cmp bx,ax
		je csecondtag
		jg csecondtag
		je assignmin
	assignmin:
		mov valorMin,bx
		jmp csecondtag
	csecondtag:
		inc si
		mov bl,entrada[si]
		cmp bl,">"
		je verify
		jmp csecondtag
	verify:
		inc si
		mov bl,entrada[si]
		cmp bl,"<"
		je verify2
		jmp verify
	verify2:
		inc si
		mov bl,entrada[si]
		cmp bl,"/"
		je cmaintag
		jmp Guardar
	cmaintag:
		inc si
		mov bl,entrada[si]
		cmp bl,"$"
		jne cmaintag
	fin:
		;BubbleSort NumerosReal,lengthArray,orderASC
		;CalcAverage NumerosReal,lengthArray
		;GenerateFreq NumerosReal,lengthArray
		;FindMode ArrayOrder,ArrayFrequency,arrlength
		;FindMedian NumerosReal,lengthArray
		;GenerateUniqueArray ArrayFrequency,ArrayHeights,arrlength,arrlengthheight
		;BubbleSort ArrayHeights,arrlengthheight,orderDESC
		mov ax,arraySize
		mov bx,2
		add ax,bx
		cwd
		idiv bx
		mov QtyNumbers2,ax
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