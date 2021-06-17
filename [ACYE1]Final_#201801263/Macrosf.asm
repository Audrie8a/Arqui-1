SaltoLinea macro
    mov ah, 02h
    mov dl, 10
    int 21h
    mov ah,02h
    mov dl, 13
    int 21h
endm

Print macro cadena
    mov ax, @data
    mov ds, ax
    mov ah, 09h
    mov dx, offset cadena
    int 21h
endm

getChar macro
    mov ah, 01h
    int 21h
endm

ObtenerTexto macro buffer
    LOCAL ObtenerChar, endTexto
    xor si, si ;xor si,si => mov si,0

    ObtenerChar:
        getChar
        cmp al, 0dh ;ascii del salto de linea
        je endTexto
        mov buffer[si], al ;mov destino, fuente
        inc si ; si++
        jmp ObtenerChar
    
    endTexto:
        mov al, 24h ; ascii del signo dolar $
        mov buffer[si], al
endm

limpiar macro buffer, numbytes, caracter
    LOCAL Repetir 
    push si
    push cx

    xor si,si
    xor cx,cx
    mov cx, numbytes

    Repetir:
        mov buffer[si], caracter
        inc si
        Loop Repetir

    pop cx
    pop si
endm

LimpiarPantalla macro
    mov  ah, 0
    mov  al, 3
    int  10H
endm

IntToString macro num, number
    LOCAL Inicio, Final, Mientras, MientrasN, Cero, InicioN
    limpiar number, SIZEOF number, 24h
    xor ax, ax
    xor bx, bx
    xor dx, dx
    xor di, di
    xor si, si

    mov ax, num
    cmp ax, 0
    je Cero
    jmp Inicio

    Inicio:
        cmp ax, 0
        je Mientras
        mov dx, 0
        mov cx, 10
        div cx
        mov bx, dx
        add bx, 30h
        push bx
        inc di
        jmp Inicio

    Mientras:
        cmp si, di
        je Final
        pop bx
        mov number[si], bl
        inc si
        jmp Mientras

    Cero:
        mov number[0], 30h
        jmp Final

    Final:
endm

StringToInt macro string
    LOCAL Unidades, Decenas, Centenas, UnidadesNegativa, DecenasNegativa, CentenasNegativa,salir, Negar

    tamaString string
    xor ax,ax
    xor cx,cx

    cmp isNegativo, 1
    je Negar
    cmp bl, 1
    je Unidades

    cmp bl, 2
    je Decenas

    cmp bl, 3
    je Centenas

    Unidades:
        mov al, string[0]
        SUB al, 30h
        jmp salir

    Decenas:
        
        mov al, string[0]
        sub al, 30h
        mov bl, 10
        mul bl

        xor bx, bx
        mov bl, string[1]
        sub bl, 30h

        add al, bl

        ;neg al
        jmp salir

    Centenas:
        mov al, string[0]
        sub al, 30h
        mov bx, 100
        mul bx
        mov cx, ax

        xor ax, ax
        mov al, string[1]
        sub al, 30h
        mov bx, 10
        mul bx

        xor bx, bx
        mov bl, string[2]
        sub bl, 30h

        add ax, bx
        add ax, cx

        ;neg al
        jmp salir

    UnidadesNegativa:
        mov al, string[1]
        SUB al, 30h
        jmp salir

    DecenasNegativa:
        
        mov al, string[1]
        sub al, 30h
        mov bl, 10
        mul bl

        xor bx, bx
        mov bl, string[2]
        sub bl, 30h

        add al, bl

        ;neg al
        jmp salir

    CentenasNegativa:
        mov al, string[1]
        sub al, 30h
        mov bx, 100
        mul bx
        mov cx, ax

        xor ax, ax
        mov al, string[2]
        sub al, 30h
        mov bx, 10
        mul bx

        xor bx, bx
        mov bl, string[3]
        sub bl, 30h

        add ax, bx
        add ax, cx

        ;neg al
        jmp salir
    Negar:
        cmp bl, 1
        je UnidadesNegativa

        cmp bl, 2
        je DecenasNegativa

        cmp bl, 3
        je CentenasNegativa

    salir:
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


tamaString macro string
    LOCAL Inicio, FeinaPositivo, Negativo, FinalNegativo, Fin
    mov isNegativo,0
    xor si, si
    xor bx, bx
    mov di, -1
    Inicio:
        mov bl, string[si]
        cmp bl, 24h     ;Signo Dollar
        je FeinaPositivo

        cmp bl, 2dh     ;Signo Menos
        je Negativo
        inc si
        inc di
        jmp Inicio
    Negativo:
        mov isNegativo, 1
        inc si
        inc di
        jmp Inicio
    FeinaPositivo:
        cmp isNegativo,1
        je FinalNegativo

        mov bx, si

        jmp Fin
    FinalNegativo:       
        mov bx, di
        jmp Fin
    Fin:


endm



DivisionCal macro numero, numeroB
    LOCAL Div, cero, salir

    xor si, si
    inc si

    xor bx, bx
    

    cmp numeroB, 0
    je cero

    Div:
        mov ax, numero
        cwd
        mov bx, numeroB
        idiv bx

        mov entero, ax
        mov decimal, dx
        jmp salir
       


    cero:
        mov DivCero, 1
        jmp salir
    
    salir:
        mov numero, bx
endm

ManejarDecimales macro residuo, numero
    Local Inicio
    Pushs
        mov dx, residuo
        mov ax, numero
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

;Limpiar arreglos
clean macro buffer, numbytes, caracter
    LOCAL Repetir
    xor si,si ; colocamos en 0 el contador si
    xor cx,cx ; colocamos en 0 el contador cx
    mov cx,numbytes ;le pasamos a cx el tamaño del arreglo a limpiar 

    Repetir:
        mov buffer[si], caracter ;le asigno el caracter que le estoy mandando 
        inc si ;incremento si
        Loop Repetir ;se va a repetir hasta que cx sea 0 
endm