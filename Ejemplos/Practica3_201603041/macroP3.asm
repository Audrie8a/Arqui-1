print macro buffer
	mov ah,09h
	mov dx,offset buffer
	int 21h 
endm 

getChar macro
	mov ah,01h
	int 21h 
endm

obtenerRuta macro buffer 
	LOCAL ObtenerChar, FinOT 
	xor si,si ;igual a mov si,00h
	ObtenerChar: 
		getChar
		cmp al,0dh; ascci del salto de linea en hexa
		je FinOT
		mov buffer[si],al 
		inc si ; si = si + 1 
		jmp ObtenerChar
	FinOT: 
		mov al,00h ;ascci del signo null 
		mov buffer[si],al
endm

abrir macro buffer,handler
	mov ah,3dh 
	mov al,02h
	lea dx,buffer
	int 21h 
	jc Error2
	mov handler,ax
endm

leer macro handler,buffer,numbytes
	mov ah,3fh
	mov bx,handler
	mov cx,numbytes
	lea dx,buffer 
	int 21h
	jc Error3
endm

crear macro buffer, handler
	mov ah,3ch
	mov cx,00h
	lea dx,buffer
	int 21h 
	jc Error4
	mov handler,ax
endm

escribir macro handler, buffer, numbytes
	mov ah,40h
	mov bx,handler
	mov cx,numbytes
	lea dx,buffer
	int 21h 
	jc Error5
endm

exit macro handler
	mov ah,3eh
	mov bx,handler
	int 21h
	jc Error7
endm

getTime macro
        mov ah, 2ch    ;get the current system time
        int 21h
        ;hour
        mov al, ch      
        call convert
        mov time[0],ah
        mov time[1],al
        ;minutes
        mov al,cl
        call convert
        mov time[3],ah
        mov time[4],al
        ;seconds
        mov al, dh
        call convert
        mov time[6],ah
        mov time[7],al
endm

getDate macro
    mov ah,2ah
    int 21h
    ;day
    mov al, dl 
    call convert
    mov date[0], ah
    mov date[1], al
    ;month
    mov al, dh
    call convert
    mov date[3], ah
    mov date[4], al
    ;year
    ;mov year, cx
endm 

limpiar macro buffer, numbytes, caracter
	LOCAL Repetir
	xor si,si
	xor cx,cx
	mov cx, numbytes 
	
	Repetir: 
		mov buffer[si],caracter
		inc si
		Loop Repetir
endm 

parse macro simbolo, contador, tabla
	xor ax,ax 
	xor bx,bx 
	xor si,si 
	mov bl,simbolo 
	mov ax,contador
	mov si,ax 
	mov al,tabla[si]
	cmp al,simbolo 
	jne errorSintactico
	xor ax,ax 
	mov ax,si
	inc ax 
	mov contador,ax 	
endm

sig macro contador
	xor ax,ax 
	mov ax,contador 
	inc ax 
	mov contador,ax 
endm  

verDatos macro datos,idatos,cadena
	LOCAL repetir
	mov bx,idatos
	mov cx,14h 
	repetir: 
		mov si,cx
		dec si
		mov al,datos[bx+si]
		mov cadena[si],al
	LOOP repetir
	;print cadena 
	;getChar
endm

tamanio macro contador,cadena 
	LOCAL inicio,salir 
	xor ax,ax
	mov contador,ax 
	inicio: 
		mov bx,contador
		cmp cadena[bx],'$' 
		je salir 
		inc bx 
		mov contador,bx 
		jmp inicio	
	salir: 
endm 

copCad macro datos,idatos,identi,iidenti
	LOCAL repetir 
	mov cx,14h 
	repetir: 
		mov si,cx
		dec si
		mov bx,idatos 
		mov al,datos[bx+si]
		mov bx,iidenti
		mov identi[bx+si],al
	LOOP repetir
endm 

cmpMat macro cadena1,ind1,cadena2,ind2,bandera
	LOCAL noigual,igual,salir,evaluar
	mov cx,014h  
	evaluar: 
		mov si,cx 
		mov bx,ind1 
		mov al,cadena1[bx+si-1]
		mov bx,ind2 
		cmp cadena2[bx+si-1],al 
		jne noigual 
		LOOP evaluar
		jmp igual
	
	noigual:
		mov ax,0030h
		jmp salir 

	igual: 
		mov ax,0031h  
		jmp salir 
		
	salir: 
		mov bandera,ax 
endm 

obtenerComando macro buffer 
	LOCAL ObtenerChar, FinOT 
	xor si,si ;igual a mov si,00h
	
	ObtenerChar: 
		getChar
		cmp al,0dh; ascci del salto de linea en hexa
		je FinOT
		mov buffer[si],al 
		inc si
		cmp si, 14h 
		je FinOT 	
		jmp ObtenerChar
	FinOT: 
		mov al,'$'
		mov buffer[si],al
endm

cmpCad macro cadena1,cadena2,bandera
	LOCAL noigual,igual,salir,evaluar
	mov cx,SIZEOF cadena1 
	evaluar: 
		mov si,cx 
		mov al,cadena2[si-1]
		cmp cadena1[si-1],al 
		jne noigual 
		LOOP evaluar
		jmp igual
	
	noigual:
		mov ax,0030h
		jmp salir 

	igual: 
		mov ax,0031h  
		jmp salir 
		
	salir: 
		mov bandera,ax 
endm 

showPadre macro datos, nombrePadre, cadena, bandera
	LOCAL inicio, idPadre, noigual, igual, salir
	xor si,si
	xor dx,dx

	xor di,di
	xor ax,ax
	inicio:
		mov dl,cadena[si]
		cmp dl,'S'
		jne noigual
		inc si
		mov dl,cadena[si]
		cmp dl,'H'
		jne noigual
		inc si
		mov dl,cadena[si]
		cmp dl,'O'
		jne noigual
		inc si
		mov dl,cadena[si]
		cmp dl,'W'
		jne noigual
		inc si
		mov dl,cadena[si]
		cmp dl,32
		jne noigual
		inc si
		jmp idPadre
	
	idPadre:
		mov dl,cadena[si]
		mov al,nombrePadre[di]
		cmp dl,al
		jne noigual
		inc si
		inc di
		mov dl,cadena[si]
		cmp dl,'$'
		je cerrarID
		jmp idPadre

	cerrarID:
		mov dl,cadena[si]
		mov al,nombrePadre[di]
		cmp dl,al
		je igual
		jmp noigual

	noigual:
		mov ax,0030h
		jmp salir 

	igual: 
		mov ax,0031h  
		jmp salir 
		
	salir: 
		mov bandera,ax
endm

obtenerID macro entrada, auxID
	LOCAL inicio, getID, error, noerror, salir
	xor si,si
	xor di,di
	xor dx,dx
	inicio:
		mov dl,entrada[si]
		cmp dl,'S'
		jne error
		inc si
		mov dl,entrada[si]
		cmp dl,'H'
		jne error
		inc si
		mov dl,entrada[si]
		cmp dl,'O'
		jne error
		inc si
		mov dl,entrada[si]
		cmp dl,'W'
		jne error
		inc si
		mov dl,entrada[si]
		cmp dl,32
		jne error
		inc si
		jmp getID
	
	getID:
		mov dl,entrada[si]
		mov auxID[di],dl
		inc si
		inc di
		mov dl,entrada[si]
		cmp dl,'$'
		je noerror
		jmp getID

	noerror:
		mov ax,0031h
		jmp salir 
	error:
		mov ax,0030h
		jmp salir

	salir:
endm

findId macro entrada, auxID, datos, inDatos, tempBuffer, iRRES, bandera
	LOCAL inicio, buscar, repetir, noigual, igual, salir
	inicio:
		obtenerID entrada, auxID
		cmp ax,0031h
		je buscar
		jmp noigual
	
	buscar:
		xor bx,bx
	repetir:
		verDatos datos,bx,tempBuffer
		cmpCad auxID,tempBuffer,bandera
		cmp bandera,0031h ;el id en cuestion y el de comando son iguales
		je igual
		
		mov cl,iRRES
		add cl,02h
		mov iRRES,cl
		add bx,14h
		cmp datos[bx],'$'
		je noigual
		jmp repetir

	noigual:
		mov ax,0030h
		jmp salir 

	igual: 
		mov ax,0031h  
		jmp salir 
		
	salir: 
		mov bandera,ax
endm

verNumero macro numero, cadena
	LOCAL negativo, positivo, llenar  
	mov ax,numero 
	and ax,1000000000000000b
	cmp ax,00h 
	je positivo 
	
	negativo: 
		mov ax,numero 
		neg ax 
		mov cadena[0],'-' 
		jmp llenar

	positivo:
		mov cadena[0],'+' 
		mov ax,numero 

	llenar:  
		mov bx,2710h 
		mov dx,00h
		div bx
		add al,30h 
		mov cadena[1],al
		xor ax,ax 
		mov ax,dx 
		mov bx,03e8h
		mov dx,00h 
		div bx
		add al,30h
		mov cadena[2],al
		xor ax,ax 
		mov ax,dx
		mov bx,64h
		mov dx,00h 
		div bx
		add al,30h 
		mov cadena[3],al 
		xor ax,ax 
		mov ax,dx 
		mov bx,0ah
		mov dx,00h
		div bx 
		add al,30h 
		mov cadena[4],al
		add dl,30h 
		mov cadena[5],dl 
		;print cadena 
		;getChar
endm 

verNumero2 macro numero, cadena
	LOCAL negativo, positivo, llenar  
		mov ax,numero 
		and ax,1000000000000000b
		cmp ax,00h 
		je positivo 
		
	negativo: 
		mov ax,numero 
		neg ax 
		mov cadena[0],'-' 
		jmp llenar

	positivo:
		mov cadena[0],'+' 
		mov ax,numero 

	llenar:  
		mov bx,2710h 
		mov dx,00h
		div bx
		add al,30h 
		mov cadena[1],al
		xor ax,ax 
		mov ax,dx 
		mov bx,03e8h
		mov dx,00h 
		div bx
		add al,30h
		mov cadena[2],al
		xor ax,ax 
		mov ax,dx
		mov bx,64h
		mov dx,00h 
		div bx
		add al,30h 
		mov cadena[3],al 
		xor ax,ax 
		mov ax,dx 
		mov bx,0ah
		mov dx,00h
		div bx 
		add al,30h 
		mov cadena[4],al
		add dl,30h 
		mov cadena[5],dl 
		print cadena 
		getChar
endm 

convertirString macro buffer
	LOCAL Dividir,Dividir2,FinCr3,NEGATIVO,FIN2,FIN
	xor si,si
	xor cx,cx
	xor bx,bx
	xor dx,dx
	mov dl,0ah
	test ax,1000000000000000
	jnz NEGATIVO
	jmp Dividir2

	NEGATIVO:
		neg ax
		mov buffer[si],45
		inc si
		jmp Dividir2

	Dividir:
		xor ah,ah
	Dividir2:
		div dl
		inc cx
		push ax
		cmp al,00h
		je FinCr3
		jmp Dividir
	FinCr3:
		pop ax
		add ah,30h
		mov buffer[si],ah
		inc si
		loop FinCr3
		mov ah,24h
		mov buffer[si],ah
		inc si
	FIN:
endm

ordenarRes macro datos, indDatos
	LOCAL nonNUM, salir, movida, acabo, noNUM
	;limpio indices y registros
	xor ax,ax
	xor bx,bx 
	xor cx,cx
	mov iidenti,ax 
	mov ires,al
	
	;verifico que no este vacio
	mov bx,iidenti
	cmp identi[bx],'$'
	je noNUM ;no hay numeros
	
	;muevo el primero
	xor bx,bx
	mov bl,ires 
	mov al,tablaRes[bx]
	mov ah,tablaRes[bx+1]
	mov ordenado[0],ax ;ya meti el primero
	inc cx
	mov bl,ires 
	add bl,02h
	mov ires,bl 
	mov bx,iidenti
	add bx,14h
	mov iidenti,bx

	movida:
		mov bx,iidenti
		cmp identi[bx],'$'
		je acabo

	acabo:
		mov ax,31h
		jmp salir

	noNUM:
		mov ax,30h
		jmp salir
	
	salir:
endm

apilar macro pila, indice, dato
	mov ax,dato 
	mov bx,indice 
	mov pila[bx],al
	mov pila[bx+1],ah 
	mov bx,indice 
	add bx,02h
	mov indice,bx 
endm 

desapilar macro pila, indice, dato 
	mov bx,indice
	sub bx,02h 
	mov indice,bx 
	mov al,pila[bx]
	mov ah,pila[bx+1]
	mov dato,ax 
	mov pila[bx],00h
	mov pila[bx+1],00h 	
endm 