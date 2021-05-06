;-----------------------------------------------------MACROS
printText macro p1
	mov ax,@data
	mov ds,ax
	lea dx, p1 ; Equivalente a lea dx, cadena, inicializa en dx la posicion donde comienza la cadena
	mov ah,09h ;Numero de funcion para imprimir cadena en pantalla
	int 21h
endm

getChar macro
	mov ah,01h
	int 21h
endm

imprimir macro p1
	mov ah, 02h
	mov dl, p1
	int 21h
endm

imprimirMul macro p1
	mov ah, 02h
	mov dl, p1
	add dl, 30h
	int 21h
endm

obtenerTexto macro buffer 
	Local obtenerChar, FinOT
	xor si,si ;igual a mov si,0
	xor al,al
	obtenerChar:
		getChar
		cmp al,0dh ;ascii del salto de línea en hexadecimal
		je FinOT
		mov buffer[si],al;mov destino, fuente
		;print buffer[si]
		inc si; si=si+1
		jmp obtenerChar

	FinOT:
		mov al, 24h	; ascii del signo dolar 
		mov buffer[si],al
endm

filtarNumero macro buffer
	Local Ini,UNum, DNum,  NDNum,Recorrer, Fin, Comprobar,Negativo, Decena,Unidad, Diez, Veinte, Treinta, Cuarenta, Cincuenta, Sesenta, Sietenta,Ochenta, Noventa, Uno, Dos, Tres, Cuatro, Cinco, Seis, Siete, Ocho, Nueve, Negar
	xor si, si
	mov contador, 0
	mov isNegativo, 0
	mov numero,0
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
		mov numero, cl
		add numero, 30h

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
		mov numero, 10
		mov num1A,1
		inc si
		jmp Recorrer
	Veinte:
		mov numero, 20
		mov num1A,2
		inc si
		jmp Recorrer
	Treinta:
		mov numero, 30
		mov num1A,3
		inc si
		jmp Recorrer
	Cuarenta:
		mov numero, 40
		mov num1A,4
		inc si
		jmp Recorrer
	Cincuenta:
		mov numero, 50
		mov num1A,5
		inc si
		jmp Recorrer
	Sesenta:
		mov numero, 60
		mov num1A,6
		inc si
		jmp Recorrer
	Sietenta:
		mov numero, 70
		mov num1A,7
		inc si
		jmp Recorrer
	Ochenta:
		mov numero, 80
		mov num1A,8
		inc si
		jmp Recorrer
	Noventa:
		mov numero, 90
		mov num1A,9
		inc si
		jmp Recorrer

	Uno:
		add numero, 1		
		mov num1B,1
		mov contador,2
		jmp Recorrer
	Dos:
		add numero,2
		mov num1B,2
		mov contador,2
		jmp Recorrer
	Tres:
		add numero, 3
		mov num1B,3
		mov contador,2
		jmp Recorrer
	Cuatro:
		add numero, 4
		mov num1B,4
		mov contador,2
		jmp Recorrer
	Cinco:
		add numero, 5
		mov num1B,5
		mov contador,2
		jmp Recorrer
	Seis:
		add numero, 6
		mov num1B,6
		mov contador,2
		jmp Recorrer
	Siete:
		add numero, 7
		mov num1B,7
		mov contador,2
		jmp Recorrer
	Ocho:
		add numero, 8
		mov num1B,8
		mov contador,2
		jmp Recorrer
	Nueve:
		add numero, 9
		mov num1B,9
		mov contador,2
		jmp Recorrer
	Fin:
		mov al, 24h
		mov buffer[si],al
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


comprobarRespuestaSuma macro dato1, dato2
	Local comprobar, mayor, menor, fin

	comprobar:
		mov bl, dato1
		mov cl, dato2

		cmp bl,cl
		ja mayor
		jb menor 
		je menor
	mayor:
		cmp isNegativeNum1,0
		je menor

		printText SignoMenos
		neg resultado
		printRespuesta resultado
		jmp fin
	menor:
		printRespuesta resultado
		jmp fin
	fin:
		mov ah,02h
	    mov dl,10
	    int 21h
	    mov ah,02h
	    mov dl,13
	    int 21h
endm

comprobarRespuestaResta macro dato1, dato2
	Local comprobar, negar,mayor,menor,fin, NNum1
	comprobar:
		mov bl, dato1
		mov cl, dato2
		cmp bl, cl
		ja mayor
		jb menor
		je fin
	menor:
		cmp isNegativeNum1,1
		je NNum1
		

		jmp fin
	NNum1:
		cmp isNegativeNum2,1
		je negar

		jmp negar
	mayor:
		cmp isNegativeNum2,0		
		je negar

		cmp isNegativeNum2,1
		je negar

		jmp fin
	negar:
		neg resultado
		printText SignoMenos
		jmp fin

	fin:
		printRespuesta resultado
endm

comprobarRespuestaDivision macro dato1, dato2
	Local entrada, negar1, negar2,positivo, fin
	mov cl, isNegativeNum1
	mov bl, isNegativeNum2
	mov existeNegativo,0
	entrada:
		
		cmp cl, 1
		je negar1		
		
		cmp bl,1
		je negar2

		jmp fin
	negar1:
		neg dato1
		mov al, dato1
		mov num1,al
		mov cl, 0
		mov existeNegativo,1
		jmp entrada
	negar2:
		neg dato2
		mov al, dato2
		mov num2, al
		mov bl, 0
		cmp existeNegativo,1
		je positivo

		mov existeNegativo,1
		jmp fin
	positivo:
		mov existeNegativo,0
		jmp fin
	fin:
		xor cl, cl
		xor bl, bl
endm

comporbarRespuestaMultiplicacion macro
	Local entradas, negarr1, negarr2,positivos, fins
	mov cl, isNegativeNum1
	mov bl, isNegativeNum2
	mov existeNegativo,0
	entradas:
		
		cmp cl, 1
		je negarr1		
		
		cmp bl,1
		je negarr2

		jmp fins
	negarr1:		
		mov cl, 0
		mov existeNegativo,1
		jmp entradas
	negarr2:		
		mov bl, 0
		cmp existeNegativo,1
		je positivos

		mov existeNegativo,1
		jmp fins
	positivos:
		mov existeNegativo,0
		jmp fins
	fins:
		xor cl, cl
		xor bl, bl

endm
;----------------------------------------------------DECLARACIONES
.model small

;----------------------------------------------------PILA
.stack

;----------------------------------------------------SEGMENTO DE DATOS
.data
	; Cadenas Menu ModoCalculadora
	calculadora0 db 0ah,0dh, '-------------CALCULADORA-------------','$'
	calculadora1 db 0ah,0dh, 'Ingrese un numero: ','$'
	calculadora2 db 0ah,0dh, 'Ingrese un operador: ','$'
	calculadora3 db 0ah,0dh, 'Ingrese cualquier valor para volver a menu o ; para finalizar','$'
	calculadora4 db 0ah,0dh, 'El resultado es: ','$'
	msjSalir db 0ah, 0dh, 'Adios :)','$'
	espacioB db 0ah,0dh, '->','$'
	SignoMenos db 0ah, 0dh, '-','$'
	txtCociente db 0ah, 0dh,'cociente: ','$'
	txtResiduo db 0ah, 0dh, 'residuo: ','$'
	;Variables
    numero1 db 5 dup('$'), '$'
    numero2 db 5 dup('$'), '$'
    operador db 0
    contador db 0
    numero db 0
    num1 db 0
    num2 db 0
    diez db 10
    num1A db 0
    num1B db 0
    num2A db 0
    num2B db 0
    num3A db 0
    num3B db 0
   	r1 db ?
	r2 db ?
	r3 db ?
	r4 db ?
    ac1 db 0
    ac db 0


    numeroBuffer db 0
    isNegativo db 0
    sizeBuffer db 0
    isNegativeNum1 db 0
    isNegativeNum2 db 0
    existeNegativo db 0

    cociente db 0
    resto db 0
    unidad db 0
    decena db 0
    centena db 0

    resultado db 0

;----------------------------------------------------SEGMENTO DE CODIGO
.code

main proc
	MenuPrincipal:
		mov numero, 0
		mov resultado, 0
		mov isNegativo, 0
		mov num1,0
		mov num2,0
		mov isNegativeNum1,0
		mov isNegativeNum2,0
		mov contador,0
		mov sizeBuffer,0
		mov unidad,0
		mov decena,0
		mov centena,0


		printText calculadora0
		printText calculadora1
		obtenerTexto numero1

		obtenerSizeBuffer numero1
		filtarNumero numero1		
		mov al, num1A
		mov num2A, al
		mov al, num1B
		mov num2B, al



		mov al, numero
		mov num1, al
		mov al, isNegativo
		mov isNegativeNum1,al

		printText calculadora2
		getChar
		mov operador,al

		printText calculadora1
		obtenerTexto numero2

		mov sizeBuffer,0
		obtenerSizeBuffer numero2
		filtarNumero numero2
		mov al, num1A
		mov num3A, al
		mov al, num1B
		mov num3B, al		

		mov al, numero
		mov num2, al
		mov al, isNegativo
		mov isNegativeNum2,al



		jmp Operaciones

	Operaciones:
        xor al, al
        xor dx, dx
        ;Comparo la entrada
        cmp operador,2Bh ;opcion Suma
        je suma
        cmp operador,2Dh ;opcion Resta
        je resta
        cmp operador,2Ah ;opcion Multiplicacion
        je mult
        cmp operador,2Fh ;opcion Division
        je divi
        jmp SubCalculadora

		
	SubCalculadora:
	    printText calculadora3
	    getChar
	    mov operador,al

	    cmp operador,3Bh
	    je salir

	        
	    jmp MenuPrincipal
		

	Salir:
		printText msjSalir
		mov ah, 4ch
		xor al,al
		int 21h
	suma:
		mov al, num2
		add num1, al
		mov al, num1
		mov resultado, al
		printText calculadora4
		comprobarRespuestaSuma num1, num2
		jmp SubCalculadora
	resta:
		mov al, num2
		sub num1, al
		mov al, num1
		mov resultado, al
		printText calculadora4
		comprobarRespuestaResta num1, num2
		jmp SubCalculadora
	mult:	
		
		comporbarRespuestaMultiplicacion		
		
		mov al,num3B
		mov bl, num2B
		mul bl
		mov ah,0
		aam
		mov ac1,ah
		mov r4,al

		mov al, num3B
		mov bl, num2A
		mul bl
		mov r3,al
		mov bl, ac1
		add r3,bl
		mov ah, 00h
		mov al, r3
		aam
		mov r3, al
		mov ac1, ah

		mov al, num3A
		mov bl, num2B
		mul bl
		mov ah, 00h
		aam
		mov ac, ah
		mov r2, al

		mov al, num3A
		mov bl, num2A
		mul bl
		mov r1,al
		mov bl, ac
		add r1,bl
		mov ah, 00h
		mov al, r1
		aam
		mov r1, al
		mov ac, ah

		mov ax, 0000h
		
		mov al, r3
		mov bl, r2
		add al, bl
		mov ah, 00h
		aam
		mov r3,al
		mov r2, ah

		mov ax, 0000h

		mov al, ac1
		mov bl, r1
		add al, r2
		add al, bl
		mov ah, 00h
		aam
		mov r1,al
		mov r2, ah

		mov al, r2
		mov bl, ac
		add al, bl
		mov ac, al

		cmp existeNegativo, 1
		je multiNegativa

		printText calculadora4
		;Mostrando resultado
		mov ah, 02h
		mov dl, ac
		add dl, 30h
		int 21h

		mov ah, 02h
		mov dl, r1
		add dl, 30h
		int 21h

		mov ah, 02h
		mov dl, r3
		add dl, 30h
		int 21h

		mov ah, 02h
		mov dl, r4
		add dl, 30h
		int 21h

		jmp SubCalculadora
	multiNegativa:
		printText calculadora4
		printText SignoMenos
		;Mostrando resultado
		mov ah, 02h
		mov dl, ac
		add dl, 30h
		int 21h

		mov ah, 02h
		mov dl, r1
		add dl, 30h
		int 21h

		mov ah, 02h
		mov dl, r3
		add dl, 30h
		int 21h

		mov ah, 02h
		mov dl, r4
		add dl, 30h
		int 21h

		jmp SubCalculadora
	divi:		
		comprobarRespuestaDivision num1, num2
		mov ah,0
		mov al, num1
		mov cl, num2
		idiv cl
		
		;Convertir a decmimal
		add al, 30h
		add ah, 30h
		mov bl, ah

		mov cociente, al
		mov resto, bl

		cmp existeNegativo,1
		je diviNegativa

		printText calculadora4
		printText txtCociente
		imprimir cociente
		printText txtResiduo
		imprimir resto

		jmp SubCalculadora
	diviNegativa:

		printText calculadora4
		printText txtCociente
		printText SignoMenos
		imprimir cociente
		printText txtResiduo
		imprimir resto

		jmp SubCalculadora
		 

main endp
end main