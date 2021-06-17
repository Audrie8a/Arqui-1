;MACROS
include macros.asm

;DECLARACIONES
.model small

;PILA
.stack

;SEGMENTO DE DATOS
.data
    num db 0
    resultado db 0
    resf db 0
    limite db 0
    diez db 10
    residuo db 0
    ruta db 50 dup('$'), '$'
    handlerentrada dw ?
    info db 1000 dup('$'), '$'
    arregloAux db 15 dup('$'), '$'

    contG dw 0
    cont dw 0
    arregloOperacion db 50 dup('$'), '$'
    ;arregloOperacion db 10 dup(50 dup('$')), '$'

    E_P1 db 0ah, 0dh, '|     UNIVERSIDAD DE SAN CARLOS DE GUATEMALA     |', '$'
    E_P2 db 0ah, 0dh, '|            FACULTAD DE INGENIERIA              |', '$'
    E_P3 db 0ah, 0dh, '|        ESCUELA DE CIENCIAS Y SISTEMAS          |', '$'
    E_P4 db 0ah, 0dh, '| ARQUITECTURA DE COMPUTADORES Y ENSAMBLADORES 1 |', '$'
    E_P5 db 0ah, 0dh, '|                   SECCION B                    |', '$'
    E_P6 db 0ah, 0dh, '|              PRIMER SEMESTRE 2021              |', '$'
    E_P7 db 0ah, 0dh, '|       -> Jose Ottoniel Sincal Guitzol <-       |', '$'
    E_P8 db 0ah, 0dh, '|                -> 201801375 <-                 |', '$'
    E_P9 db 0ah, 0dh, '|        -> Primera Practica Assembler <-        |', '$'
    L_P0 db 0ah, 0dh, '|------------------------------------------------|', '$'
    L_P1 db 0ah, 0dh, '*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*_*', '$'
    M_P1 db 0ah, 0dh, '* ^^<      M E N U    P R I N C I P A L     >^^ *', '$' 
    M_P2 db 0ah, 0dh, '* -> 1. Cargar Archivo                      >^^ *', '$' 
    M_P3 db 0ah, 0dh, '* -> 2. Calculadora                         >^^ *', '$' 
    M_P4 db 0ah, 0dh, '* -> 3. Factorial                           >^^ *', '$' 
    M_P5 db 0ah, 0dh, '* -> 4. Crear Reporte                       >^^ *', '$' 
    M_P6 db 0ah, 0dh, '* -> 5. Salir                               >^^ *', '$'
    elegir db 0ah, 0dh, ' -> Seleccione una opcion: ', '$'
    ingresarNum db 0ah, 0dh, ' -> Ingrese un numero:  ', '$'
    ingresarOp1 db 0ah, 0dh, ' -> Ingrese un operador (+, -, *, /):  ', '$'
    ingresarOp2 db 0ah, 0dh, ' -> Ingrese un operador (+, -, *, /) o '';'' para finalizar:  ', '$'
    msjSal db 0ah, 0dh, ' -> Su resultado es: ', '$'
    msjOpe db 0ah, 0dh, ' -> Operaciones: ', '$'
    err1 db 0ah,0dh, 'Error al abrir el archivo puede que no exista' , '$'
    err2 db 0ah,0dh, 'Error al cerrar el archivo' , '$'
    err3 db 0ah,0dh, 'Error al escribir en el archivo' , '$'
    err4 db 0ah,0dh, 'Error al crear en el archivo' , '$'
    err5 db 0ah,0dh, 'Error al leer en el archivo' , '$'
    ingreseruta db 0ah,0dh, 'Ingrese una ruta de archivo' , '$'
    salto db 0ah, 0dh, '$', '$'

;SEGMENTO DE CÓDIGO
.code
main proc
    encabezado:
        print L_P0
        print E_P1
        print E_P2
        print E_P3
        print E_P4
        print E_P5
        print E_P6
        print E_P7
        print E_P8
        print E_P9
        print L_P0
        print salto
        jmp menu

    menu:
        print salto
        print L_P1
        print M_P1
        print M_P2
        print M_P3
        print M_P4
        print M_P5
        print M_P6
        print L_P1
        print elegir
        getChar

        cmp al, 31h
        je cargarArchivo
        cmp al, 32h
        je calculadora
        cmp al, 33h
        je factorial
        ;cmp al, 34h
        ;je reporte
        cmp al, 35h
        je salir
        jmp menu

    cargarArchivo:
        print salto
		print ingreseruta
		print salto
		limpiar ruta, SIZEOF ruta,24h ;limpiamos el arreglo bufferentrada con $
		obtenerRuta ruta ;obtenemos la ruta en buffer de entrada
		abrir ruta, handlerentrada  ;le mandamos la ruta y el handler,que será la referencia al fichero 
		limpiar info, SIZEOF info,24h  ;limpiamos la variable donde guardaremos los datos del archivo 
		leer handlerentrada, info, SIZEOF info ;leemos el archivo 

        print salto
		print info
		print salto

    cerrarArchivo:
		cerrar handlerentrada
        limpiar arregloOperacion, SIZEOF arregloOperacion, 24h
        mov contG, 0
        mov cont, 0

    analizarArchivo:
        mov si, contG

        mov al, info[si]
        cmp al, '$'
        je resultadoArchivo

        limpiar arregloAux, SIZEOF arregloAux, 24h
        analizar info, arregloAux

        mov di, cont
        comparacion arregloAux, arregloOperacion
        mov num, al
        cmp num, 1
        je esNumero
        jmp analizarArchivo

    esNumero:
        limpiar arregloAux, SIZEOF arregloAux, 24h
        mov si, contG
        mov di, cont
        obtenerStringNumero info, arregloOperacion
        jmp analizarArchivo

    resultadoArchivo:
        inc di
        inc cont
        mov al, 24h     ; ascii del signo dolar $
        mov arregloOperacion[di], al
        print arregloOperacion
        limpiar arregloOperacion, SIZEOF arregloOperacion, 24h
        jmp menu

    calculadora:
        print salto
        print ingresarNum
        obtenerNumero num, diez
        mov al, num
        mov resultado, al
        print ingresarOp1
        getChar
        cmp al, '+'
        je sumar
        cmp al, '-'
        je restar
        cmp al, '*'
        je multiplicar
        cmp al, '/'
        je dividir
        jmp calculadora
        ;arreglar aqui

    sumar:
        print ingresarNum
        obtenerNumero num, diez
        mov al, resultado
        add al, num
        mov resultado, al
        jmp pedirMas

    restar:
        print ingresarNum
        obtenerNumero num, diez
        mov al, resultado
        sub al, num
        mov resultado, al
        jmp pedirMas

    multiplicar:
        print ingresarNum
        obtenerNumero num, diez
        mov al, resultado
        mov bl, num
        imul bl
        mov resultado, al
        jmp pedirMas

    dividir:
        print ingresarNum
        obtenerNumero num, diez
        mov al, resultado
        mov bl, num
        cbw
        idiv bl
        mov resultado, al
        jmp pedirMas

    pedirMas:
        print ingresarOp2
        getChar
        cmp al, '+'
        je sumar
        cmp al, '-'
        je restar
        cmp al, '*'
        je multiplicar
        cmp al, '/'
        je dividir
        cmp al, ';'
        je mostrarResultado
        jmp pedirMas

    mostrarResultado:
        print salto
        print msjSal
        printNum resultado, residuo, diez
        print salto
        jmp menu

    factorial:
        print salto
        print ingresarNum

        mov ah, 01h
        int 21h
        sub al, 30h

        mov limite, al

        print salto
        print msjOpe

        mov resf, 0
        operaciones:
            printNum resf, residuo, diez
            printFacEqual

            mov al, resf
            mov num, al

            obtenerFactorialAux num
            printNum num, residuo, diez
            printPtcEsp

            inc resf
            mov al, limite
            cmp resf, al
            jle operaciones


        sub resf, 1
        obtenerFactorialAux resf
        print msjSal
        printNum resf, residuo, diez
        print salto
        jmp menu

    Error1:
		print salto
		print err1
		getChar
		jmp menu

	Error2:
		print salto
		print err2
		getChar
		jmp menu
	
	Error3:
		print salto
		print err3
		getChar
		jmp menu
	
	Error4:
		print salto
		print err4
		getChar
		jmp menu

	Error5:
		print salto
		print err5
		getChar
		jmp menu

    salir:
        close
main endp
end main

