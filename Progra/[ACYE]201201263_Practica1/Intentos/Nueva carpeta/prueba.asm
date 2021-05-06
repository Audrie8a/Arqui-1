;-----------------------------------------------------MACROS
include macrostc.asm

;----------------------------------------------------DECLARACIONES
.model small

;----------------------------------------------------PILA
.stack 100
DW 256 DUP(?)
;----------------------------------------------------SEGMENTO DE DATOS
.data
;Variables
resultado db 0
cociente db 0
residuo db 0
numero db 0
operador db 0
r2 db ?
ac db 0

numero1 db 5 dup('$'), '$'
numero2 db 5 dup('$'), '$'
; Cadenas Menu ModoCalculadora
calculadora0 db 0ah,0dh, '-------------CALCULADORA-------------','$'
calculadora1 db 0ah,0dh, 'Ingrese un numero: ','$'
calculadora2 db 0ah,0dh, 'Ingrese un operador: ','$'
calculadora3 db 0ah,0dh, 'Ingrese cualquier valor para volver a menu o ; para finalizar','$'
label9 db 0ah,0dh, 'El resultado es: ','$'
msjSalir db 0ah, 0dh, 'Adios :)','$'
espacioB db 0ah,0dh, '->','$'
label10 db 0ah,0dh,'Error, no se divisible entre 0','$'
label11 db 0ah,0dh,'cociente','$'
label12 db 0ah,0dh, 'residuo','$'

;----------------------------------------------------SEGMENTO DE CODIGO
.code

main proc
    
    MenuPrincipal:      

        print calculadora1  ;Imprime Pedido num1
        obtenerTexto numero1
        
        ;print m
        ;mov m,ax
        
        print calculadora2  ;Recibe operador        
        getChar
        mov operador,al
        

        print calculadora1  ;Imprime Pedido num2    
        obtenerTexto numero2
        
    

        jmp Operaciones

    Operaciones:
        ;Comparo la entrada
        cmp operador,2Bh ;opcion Suma
        je Suma
        cmp operador,2Dh ;opcion Resta
        je Resta
        cmp operador,2Ah ;opcion Multiplicacion
        je Multiplicacion
        cmp operador,2Fh ;opcion Division
        je Division
        jmp SubCalculadora
    salir:
    print msjSalir
    mov ah, 4ch
    xor al,al
    int 21h
    
    SubCalculadora:
        print calculadora3
        getChar
        mov operador,al

        cmp operador,3Bh
        je salir

        
        jmp MenuPrincipal
    Suma:
        

        jmp SubCalculadora
    Resta:
       
        

        jmp SubCalculadora
    Multiplicacion:
        
        jmp SubCalculadora
    Division:
    
        jmp salir
main endp
end main

    