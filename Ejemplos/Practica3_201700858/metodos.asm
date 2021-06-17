print macro cadena
    mov ah, 09h
    lea dx, cadena
    int 21h
endm

terminar macro 
    mov ah, 4ch
    xor al, al
    int 21h
endm

getChar macro
    mov ah,01h
    int 21h
endm

limpiarPantalla macro
    mov ax,0600h
    mov bh,0fh
    mov cx, 0000h
    mov dx, 184Fh
    int 10h
endm

numeroDoble macro u,de,n
LOCAL _INICIO, _FIN, _NEGATIVO
    _INICIO:
        getChar
        cmp al,2DH
        je _NEGATIVO
        sub al,30h
        mov de, al
        getChar
        sub al,30h
        mov u, al
        mov al,de
        mov bl,10
        mul bl
        add al,u
        mov n, al
        jmp _FIN
    _NEGATIVO:
        getChar
        sub al,30h
        mov de, al
        getChar
        sub al,30h
        mov u, al
        mov al,de
        mov bl,10
        mul bl
        add al,u
        mov n, al
        neg n
        jmp _FIN
    _FIN:

endm

imprimirNumero macro n1
    mov al,n1
    AAM
    mov bx,ax
    mov ah,02h
    mov dl,bh
    add dl,30h
    int 21h
    mov ah,02h
    mov dl,bl
    add dl,30h
    int 21h
endm


aritmetica macro u,de,n1,n2,msg1,msg2,msg3,msg4
LOCAL _Inicio, _Operador, _Suma, _Resta, _Multiplicacion,_Division, _Resultado
    _Inicio:
        print msg1
        numeroDoble u,de,n1
        jmp _Operador
    _Operador:
        print msg2
        getChar
        cmp al,2BH
        je _Suma
        cmp al,2DH
        je _Resta
        cmp al,2AH
        je _Multiplicacion
        cmp al,2FH
        je _Division
        cmp al,3BH
        je _Resultado
    _Suma:
        xor al,al
        print msg1
        numeroDoble u,de,n2
        mov al, n1
        add al, n2
        mov n1, al

        jmp _Operador
    _Resta:
        xor al,al
        print msg1
        numeroDoble u,de,n2
        mov al, n1
        sub al, n2
        mov n1, al

        jmp _Operador
    _Multiplicacion:
        xor al,al
        print msg1
        numeroDoble u,de,n2
        mov al, n1
        mov bl, n2
        imul bl
        mov n1,al

        jmp _Operador
    _Division:
        print msg1
        numeroDoble u,de,n2
        xor ax,ax
        mov bl, n2
        mov al, n1
        idiv bl
        mov n1, al
        jmp _Operador
    _Resultado:
        print msg3
        imprimirNumero n1
        print msg4
        getChar

endm

factorial macro msg1,msg2,n1, numFactorial
local _inicio,_Multiplicacion,_Resultado
    _inicio:
        print msg1
        getChar
        sub al,30h
        mov cl, al
        jmp _Multiplicacion
    _Multiplicacion:
        mov al,numFactorial
        mov bl,cl
        mul bl
        mov numFactorial, al
    loop _Multiplicacion
    _Resultado:
        print msg2
        imprimirNumero numFactorial
        getChar
endm

arreglo macro vec,msg1
    add vec[si],offset msg1
    inc si
endm

crearArchivo macro nombre,error,exito
LOCAL _exito,_Error,_FIN
    mov ah,3ch
    mov cx,0
    lea dx,offset nombre
    int 21h
    jc _Error
    jmp _exito
    _exito:
        mov bx,ax
        mov ah, 3eh
        int 21h
        print exito
        jmp _FIN
    _Error: 
        print salto
        jmp _FIN
    _FIN:
endm

editarArchivo macro nombre,error,exito,vec
    crearArchivo nombre,error,exito
    mov ah,3dh
    mov al,1h
    mov dx, offset nombre
    int 21h
    mov bx,ax
    mov cx, offset vec
    mov dx,offset vec
    mov ah,40h
    int 21h
    print exito
    mov ah,3eh
    int 21h
endm

obtenerRuta macro buffer
LOCAL _obtenerChar,_endtexto
    _obtenerChar:
        getChar
        cmp al,0dh
        je _endtexto
        mov buffer[si],al
        inc si
        jmp _obtenerChar
    _endtexto:
        mov al,00h
        mov buffer[si],al

endm

abrir macro archivo
    mov ah,3dh
    mov al,1h
    mov dx, offset nombre
    int 21h
endm

escribirArchivo macro archivo, texto
    mov bx,ax
    mov cx, offset vec
    mov dx,offset vec
    mov ah,40h
    int 21h
endm

cerrarArchivo macro archivo
    mov ah,3eh
    int 21h
endm