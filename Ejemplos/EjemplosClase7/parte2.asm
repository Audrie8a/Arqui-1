;saltos incondicionados , procedimiento 
include macros.asm 
.model small 
; -------------- SEGMENTO DE PILA -----------------
.stack 
; -------------- SEGMENTO DE DATOS -----------------
.data 
cadena db  10, 'Cadena  1', '$' ; 
cadena2 db  0ah, 'Cadena 2', '$' ; 
cadena3 db  0ah, 'Cadena 3', '$' ; 

; -------------- SEGMENTO DE CODIGO -----------------
.code

    CALL procedimiento1
    jmp etiqueta2 

    procedimiento1 proc 
        print cadena
        ret 
    procedimiento1 endp 

    etiqueta1: 
        print cadena2
        jmp salir

    etiqueta2:
        print cadena3
        jmp etiqueta1

    salir:
        close 

end 