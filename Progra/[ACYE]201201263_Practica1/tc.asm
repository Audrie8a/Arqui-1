Macros segment
    print macro p1    
        lea dx, p1 ; Equivalente a lea dx, cadena, inicializa en dx la posicion donde comienza la cadena
        mov ah,09h ;Numero de funcion para imprimir cadena en pantalla
        ;mov dx, offset p1
        int 21h
    endm

    obtenerTexto macro buffer 
        Local obtenerChar, FinOT
        xor si,si ;igual a mov si,0

        obtenerChar:
            getChar
            cmp al,0dh ;ascii del salto de línea en hexadecimal
            je FinOT
            mov buffer[si],al;mov destino, fuente
            ;print buffer[si]
            inc si; si=si+1
            jmp obtenerChar

        FinOT:
            mov al, 24h ; ascii del signo dolar 
            mov buffer[si],al
    endm

    getChar macro
        mov ah,01h
        int 21h
    endm

    verificarNum macro buffer
        Local Fin, obtenerNumero, Negativo
        xor si, si
        xor ax, ax
        obtenerNumero:
        mov cl, buffer[si]
        
        cmp cl,2Dh  ; Si tiene signo menos
        je Negativo

        cmp cl,24h  ; Cuando llega al final de la caden $
        je Fin

        mov ax, buffer
        div 10

        mov num1, al
        sub num1, 30h

        mov num2, ah
        sub num2, 30h

        xor ax, ax
        xor al, al
        mov al, num1
        mul 10

        add num1, num2
        mov entrada, num1
        inc si
        Negativo:
        mov isNegative,1
        inc si
        je obtenerNumero
        Fin:



    endm

Macros ends
Data segment
    menu0  DB "1. Calculadora$"
    menu1  DB "2. Salir $"
    label1 DB "Selecciona una operacion $"
    label2 DB "1.- Suma $"
    label3 DB "2.- Resta $"
    label4 DB "3.- Multiplicacion $"
    label5 DB "4.- Division $"
    label6 DB "5.- Regresar $"
    label7 DB "Ingrese una opcion $"
    label8 DB "Ingrese numero     $"
    label10 DB "error no divisible entre 0 $"
    label11 DB "cociente  $"
    label12 DB ", residuo $"
    ; Cadenas Menu ModoCalculadora
    calculadora0 db 0ah,0dh, '-------------CALCULADORA-------------','$'
    calculadora1 db 0ah,0dh, 'Ingrese un numero: ','$'
    calculadora2 db 0ah,0dh, 'Ingrese un operador: ','$'
    calculadora3 db 0ah,0dh, 'Ingrese cualquier valor para volver a menu o ; para finalizar','$'
    label9 db 0ah,0dh, 'El resultado es: ','$'
    msjSalir db 0ah, 0dh, 'Adios :)','$'
    espacioB db 0ah,0dh, '->','$'
    ;Variables
    numero1 db 5 dup('$'), '$'
    numero2 db 5 dup('$'), '$'
    num1 DB 0
    num2 DB 0
    entrada DB 0
    entrada1 DB 0
    entrada2 DB 0
    nuemro DB 0
    operador DB 0
    resultado DB    0
    cociente  DB    0
    residuo   DB    0
    numero    DB    0
    signox    DB    0
    r2      DB    ?
    ac      DB    0
    isNegative DB 0
   
Data ends

pila segment stack
        
    DW 256 DUP (?)

pila ends
    
code segment

menu proc far
    
    assume cs:code,ds:data,ss:pila
    push ds
    xor ax,ax
    push ax
    mov ax,data
    mov ds,ax
    xor dx,dx       
    ;interlineado
    mov ah,02h
    mov dl,10
    int 21h
    mov ah,02h
    mov dl,13
    int 21h          
    ;imprime seleccion de menu 
    mov ah,09h
    mov dx,offset menu0
    int 21h  
    ;interlineado
    mov ah,02h
    mov dl,10
    int 21h
    mov ah,02h
    mov dl,13
    int 21h          
    ;imprime seleccion de menu 
    mov ah,09h
    mov dx,offset menu1
    int 21h 
    ;interlineado
    mov ah,02h
    mov dl,10
    int 21h
    mov ah,02h
    mov dl,13
    int 21h          
    ;imprime seleccion de menu 
    mov ah,09h
    mov dx,offset label7
    int 21h  
    ;lee teclado
    mov ah,01h
    int 21h
     
    ;ajunstando el teclado
    xor ah,ah
    sub al,30h
    mov cx,2
    ;verificando opcion
    
    cmp al,1
    jz calculadora ;se dirige al metodo suma
    cmp al,2
    jz fin
       
calculadora:       
    ;interlineado
    mov ah,02h
    mov dl,10
    int 21h
    mov ah,02h
    mov dl,13
    int 21h          
    ;imprime seleccion de menu 
    print calculadora0
    ;interlineado
    mov ah,02h
    mov dl,10
    int 21h
    mov ah,02h
    mov dl,13
    int 21h

    print calculadora1
    ;interlineado
    mov ah,02h
    mov dl,10
    int 21h
    mov ah,02h
    mov dl,13
    int 21h
    obtenerTexto numero1
        
    mov ah,02h
    mov dl,10
    int 21h
    mov ah,02h
    mov dl,13
    int 21h
    
    print calculadora2
    getChar
    mov operador, al
    mov ah,02h
    mov dl,10
    int 21h
    mov ah,02h
    mov dl,13
    int 21h
    print calculadora1
    
    mov ah,02h
    mov dl,10
    int 21h
    mov ah,02h
    mov dl,13
    int 21h
        
    obtenerTexto numero2  
    
    verificarNum numero1
    mov entrada1, entrada
    verificarNum numero2
    mov entrada2, entrada

        
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

        
    jmp calculadora
suma: 

    inc bx

    cmp bx,1
    mov al, num1
    
    cmp bx,2
    mov al, num2


    ;verificando si es negativo
    cmp al,2dh
    je signo
       
    ;ajusta teclado
    sub al,30h
    add resultado,al 
    jmp return1
    

signo:
    mov ah,01h
    int 21h
    sub al,30h
    neg al
    add resultado,al

    je return1
 
return1: loop suma
condicionNum1:
    mov al, numero1
condicionNum2:
    mov al, numero2
imp1:
    cmp resultado,00
    jl imp2
    ;interlineado
    mov ah,02h
    mov dl,10
    int 21h
    mov ah,02h
    mov dl,13
    int 21h
    mov AH,09H
    mov DX,OFFSET label9
    int 21H
    jmp imprime
        
       
imp2: 
    neg resultado 
    ;interlineado
    mov ah,02h
    mov dl,10
    int 21h
    mov ah,02h
    mov dl,13
    int 21h
        
    mov AH,09H
    mov DX,OFFSET label9
    int 21H
    mov ah,02h        
    mov dl,'-'        
    int 21h
    jmp imprime
       
imprime:

               
        MOV AH,0
        MOV AL,resultado
        MOV CL,10
        DIV CL
        
        ADD AL,30H
        ADD AH,30H; CONVIRTIENDO A DECIMAL
        MOV BL,AH
        
        MOV DL,AL
        MOV AH,02H;IMPRIME LA DECENA
        INT 21H
        
        MOV DL,BL
        MOV AH,02H
        INT 21H;IMPRIME LA UNIDAD
        mov cx,2  
        mov resultado, 0
        jmp calculadora
resta:
    mov ah,02h
    mov dl,10
    int 21h
    mov ah,02h
    mov dl,13
    int 21h            
    mov ah,09h
    mov dx,offset label8
    int 21h
    
    ;lee teclado
    mov ah,01h
    int 21h
    
    ;verificando si es negativo
    cmp al,2dh
    je signor
      
    ;ajusta teclado
    sub al,30h
    cmp cx,2
    je etiqueta1
    sub resultado,al 
    jmp return2
etiqueta1: mov resultado,al
            jmp return2    
signor:
    mov ah,01h
    int 21h
    sub al,30h
    neg al
    cmp cx,2
    je etiqueta1
    sub resultado,al
    je return2

return2: loop resta
    jmp imp1    
             
mult:
    mov ah,02h
    mov dl,10
    int 21h
    mov ah,02h
    mov dl,13
    int 21h            
    mov ah,09h
    mov dx,offset label8
    int 21h
    
    ;lee teclado
    mov ah,01h
    int 21h
    
    ;verificando si es negativo
    cmp al,2dh
    je signom
    sub al,30h
    cmp cx,2
    je etiqueta2
    mov ah,0
    mul resultado
    jmp return3
etiqueta2:
    mov resultado,al
    jmp return3
signom:
    mov ah,01h
    int 21h
    sub al,30h
    neg al
    cmp cx,2
    je etiqueta2
    mov ah,0
    mul resultado
    jmp return3
return3:loop mult
        mov resultado,al
        jmp imp1    

mov signox,0    
divi:
    mov ah,02h
    mov dl,10
    int 21h
    mov ah,02h
    mov dl,13
    int 21h            
    mov ah,09h
    mov dx,offset label8
    int 21h
    
    ;lee teclado
    mov ah,01h
    int 21h
    
    ;verificando si es negativo
    cmp al,2dh
    je signod
    
    sub al,30h
    cmp cx,2
    je etiqueta3
    cmp al,0
    je falla
    mov ah,0
    mov numero,al
    mov al,resultado
    div numero 
    jmp return4

etiqueta3:
    mov resultado,al
    jmp return4
signod:
    mov ah,01
    int 21h
    sub al,30h
    inc signox
    cmp cx,2
    je etiqueta3
    mov ah,0
    mov numero,al
    mov al,resultado
    div numero
    jmp return4

return4:loop divi
    mov cociente,al
    mov residuo,ah
    mov resultado,al
    jmp imp3
falla: 
    mov ah,9
    mov dx, offset label10
    int 21h
    jmp divi
imp3:
    
    
    mov ah,02h
    mov dl,10
    int 21h
    mov ah,02h
    mov dl,13
    int 21h
    mov AH,09H
    mov DX,OFFSET label9
    int 21H
    jmp imprimedivi
        
       

    
imprimedivi:
       MOV AL,resultado
              
       MOV CH,30H
       ADD AL,CH
       ADD AH,CH
       MOV BL,AH  
       
      
       MOV AH,9
       MOV DX,OFFSET label11
       INT 21H      
       
       cmp signox,1
       jz cambio
       jmp termina
       
cambio:
       mov dl,"-"
       mov ah,02h
       int 21h        
       mov signox,0

termina:
       MOV DX,0
       ADD cociente,30H
       MOV DL,cociente
       MOV AH,02H ;IMPRIME EL COCIENTE
       INT 21H
               
               
       MOV AH,9
       MOV DX,OFFSET label12
       INT 21H
       
       MOV DX,0
       ADD residuo,30H
       MOV DL,residuo 
       MOV AH,02H ;IMPRIME EL RESIDUO
       INT 21H
       
       jmp calculadora  
fin:     ret     
menu endp
code ends
end menu