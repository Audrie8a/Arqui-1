include Macrosf.asm
.model small
.stack
.data
; Encabezado
encabezado0 db 0ah, 0dh, '    ARQUITECTURA DE COMPUTADORES Y ENSAMBLADORES 1    ','$'
encabezado1 db 0ah, 0dh, '                       SECCION B                      ','$'
encabezado2 db 0ah, 0dh, '        NOMBRE: Audrie Annelisse del Cid Ochoa        ','$'
encabezado3 db 0ah, 0dh, '                  CARNET: 201801263                   ','$'
encabezado4 db 0ah, 0dh, '                    EXAMEN FINAL                      ','$'

;Variables
bufferEntrada db 5 dup('$')
numero1 dw 0ah, 0dh, '$', '$'
numero2 dw 0ah, 0dh, '$', '$'
isNegativo dw 0
NegarN dw 0
DivCero dw 0

;Cadenas
respuestaEtq db 0ah, 0dh, 'Respuesta: ', '$'

numAEtq db 0ah, 0dh, 'Ingrese el numero 1: ', '$'
numBEtq db 0ah, 0dh, 'Ingrese el numero 2: ', '$'
salirEtq db 0ah, 0dh, 'Presione 0 para salir, 1 para continuar:  ', '$'

errEtq db 0ah, 0dh, 'Error, No existe division por cero', '$'
menos db '-','$'
entero dw 0
decimal dw 0
punto db '.','$'
opcion db 0


.code
main proc    
    Encabezado:

        LimpiarPantalla
        Print encabezado0
        Print encabezado1
        Print encabezado2
        Print encabezado3
        Print encabezado4
        SaltoLinea
        jmp Inicio
    Inicio:
        Print numAEtq 
        limpiar bufferEntrada, SIZEOF bufferEntrada, 24h
        ObtenerTexto bufferEntrada
        StringToInt bufferEntrada

        mov numero1, ax

        

        cmp isNegativo, 1
        je Negativo

        jmp GetNumero2
    Negativo:
        mov NegarN, 1
        jmp GetNumero2    
    NoNegando:
        mov NegarN,0

        jmp Respuesta
    GetNumero2:
        xor ax, ax

        Print numBEtq
        limpiar bufferEntrada, SIZEOF bufferEntrada, 24h
        ObtenerTexto bufferEntrada
        StringToInt bufferEntrada
        mov numero2, ax
        
        DivisionCal numero1, numero2

        cmp DivCero, 1
        je  Error

        ManejarDecimales decimal, entero

        cmp isNegativo, 1
        je NoNegando

        jmp Respuesta
    Error:
        Print errEtq
        SaltoLinea
        jmp salir
    Respuesta:
        IntToString numero1, bufferEntrada
       
        
        Print respuestaEtq
        cmp NegarN, 1
        je RespuestaNegativa

        jmp RespuestaPositiva
        
    RespuestaNegativa:
        Pushs
        Print menos
        jmp RespuestaPositiva
    RespuestaPositiva:
        Pops
        PrintX entero
        Print punto
        PrintX decimal
        getChar

        LimpiarPantalla

        jmp salir


    salir:
        mov ah, 4ch
        xor al, al
        int 21h
main endp
end main
