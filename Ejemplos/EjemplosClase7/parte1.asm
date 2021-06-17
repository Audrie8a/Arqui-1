;introducción a macros
print macro parametro1
    mov ah, 09h ; numero de la función para imprimir cadenas 
    mov dx, @data 
    mov ds, dx
    mov dx, offset parametro1
    int 21h ;llamada a la interrupción 
endm

.model small 
; -------------- SEGMENTO DE PILA -----------------
.stack 
; -------------- SEGMENTO DE DATOS -----------------
.data 
cadena db  10, 'Prueba clase 1', '$' ; 
cadena2 db  0ah, 'Prueba clase 2', '$' ; 

; -------------- SEGMENTO DE CODIGO -----------------
.code
main proc 
    print cadena
    print cadena2

    Salir: 
        mov ah, 4ch  ;función para terminar el programa 
        xor al,al ;limpiar al 
        int 21h ;ejecutar la interrupción

main endp
end main 