print macro cadena ;imprimir cadenas
    mov ah,09h ;Numero de funcion para imprimir cadena en pantalla
	mov dx, @data ;con esto le decimos que nuestrfo dato se encuentra en la sección data
	mov ds,dx ;el ds debe apuntar al segmento donde se encuentra la cadena (osea el dx, que apunta  a data)
	mov dx,offset cadena ;especificamos el largo de la cadena, con la instrucción offset
	int 21h  ;ejecutamos la interrupción
endm 

close macro  ;cerrar el programa
    mov ah, 4ch ;Numero de función que finaliza el programa
    xor al,al ;limpiar al 
    int 21h
endm

getChar macro ;obtener caracter
    mov ah,01h ;se guarda en al en código hexadecimal del caracter leído 
    int 21h
endm

ObtenerTexto macro cadena ;macro para recibir una cadena, varios caracteres 

LOCAL ObtenerChar, endTexto 
;si, cx, di  registros que usualmente se usan como contadores 
    xor di,di  ; => mov si, 0  reinica el contador

    ObtenerChar:
        getChar  ;llamamos al método de obtener caracter 
        cmp al, 0dh ; como se guarda en al, comparo si al es igual a salto de línea, ascii de salto de linea en hexadecimal o 10en ascii
        je endTexto ;si es igual que el salto de línea, nos vamos a la etiqueta endTexto, donde agregamos el $ de dolar a la entrada 
        mov cadena[di],al ; mov destino, fuente.  Vamos copiando el ascii del caracter que se guardó en al, al vector cadena en la posicion del contador si
        inc di ; => si = si+1
        jmp ObtenerChar

    endTexto:
        mov al, 36 ;ascii del signo $ o en hexadecimal 24h
        mov cadena[di],al  ;copiamos el $ a la cadena
endm 

clear macro ;limpia pantalla
         print skip
         print skip
         print skip
         print skip
         print skip
         print skip
         print skip
         print skip
         print skip
         print skip
         print skip
         print skip
         print skip
         print skip
         print skip
         print skip
endm

concatenarCadena macro origen,destino,indiceEscritura
;xor si,si  ; => mov si, 0  reinica el contador
LOCAL ObtenerCaracter,  termino
    
    mov si,0
    pop si


    ObtenerCaracter:
        cmp origen[di], 36
        je termino
        mov al, origen[di]
        mov destino[si], al
        inc si
        inc di
        jmp ObtenerCaracter 
    termino:
        push si
        mov di,0
        
endm

concatenarCadena2 macro origen,destino





endm

concatenarCadenaMas macro origen,destino,indiceEscritura
;xor si,si  ; => mov si, 0  reinica el contador
LOCAL ObtenerCaracter,  termino 
    
    ;mov cl,indiceEscritura
    ;mov bl,indiceEscritura
    
    mov di,0
    pop si

    
    ObtenerCaracter:
        cmp origen[di], 36
        je termino
        mov al, origen[di]
        mov destino[si], al
        inc si
        inc di
        ;inc bl
        jmp ObtenerCaracter 
    termino:
        ;actualizamos donde empezamos
        push si
        ;print indiceEscritura
        ;mov di,0
        
endm


 
crearArchivo macro nombreArchivo
     mov ax,@data  ;Cargamos el segmento de datos para sacar el nombre del archivo.
     mov ds,ax
     mov ah,3ch ;instrucción para crear el archivo.
     mov cx,0
     mov dx,offset nombreArchivo ;crea el archivo con el nombre archivo2.txt indicado indicado en la parte .data
     int 21h
     mov bx,ax
     mov ah,3eh ;cierra el archivo
     int 21h
endm



escribir macro handler, buffer, numbytes
    mov ah, 40h
	mov bx, handler
	mov cx, numbytes
	lea dx, buffer
	int 21h
	

endm

escribirArchivo macro cadena,nombreArchivo
     pop si
     mov ah,3dh
     mov al,1h
     mov dx,offset nombreArchivo
     int 21h
     ;Escritura de archivo
     mov bx,ax ; mover hadfile
     mov cx,si ;num de caracteres a grabar
     mov dx,offset cadena
     mov ah,40h
     int 21h
     mov ah,3eh ;Cierre de archivo
     int 21h
endm

abrirArchivo macro nombreArchivo,evento
     xor ax,ax
     xor bx,bx
     xor cx,cx
     xor dx,dx
     


     lea dx, nombreArchivo
     mov ah, 3dh ;Metodo para llamar la interrupcion abrir archivo
     mov al, 00h ;Permiso lectura 000b-lectura,01b Escritura,10 lectura/escritura
     int 21h     ;Interrupcion
     mov evento, ax ;Desplazamiento de cadena nombre archivo
     .if carry?  ;Compara que exista el archivo
     mov ax,-1
     .endif
endm

escribirArchivoReporte macro bytes, evento, datosBuffer
       xor ax,ax
    xor bx,bx
    xor cx,cx
    xor dx,dx


     mov ah, 40h     ;Sirve para activar el evento
     mov bx, evento  ;Movemos el evento bx
     mov cx, bytes   ;Mover los bytes que se quiere escribir a cx
     lea dx, datosBuffer
     int 21h         ;Interrupcion 21 llamada
endm

leerArchivo macro bytes, evento, datosBuffer
     mov ah, 3fh     ;Sirve para activar el evento
     mov bx, evento  ;Movemos el evento bx
     mov cx, bytes   ;Mover los bytes que se quiere leer a cx
     ;mov si,cx
     lea dx, datosBuffer
     int 21h         ;Interrupcion 21 llamada
endm

cerrarArchivo macro evento
     mov ah,3eh      ;Activador interrupcion
     mov bx,evento   ;llamar al evento
     int 21h         ;interrupcion 21
endm

;Operaciones aritmeticas

sumar macro  numero1,numero2,resultado,test1,test2,signo3
  LOCAL salto,noSalto,fin   
     
     mov al,numero1 ;Mueve a al el numero1
     imul test1
     mov bl,al
     xor al,al
     mov al,numero2 ;Mueve a al el numero1
     imul test2
     add al,bl ;Le suma a al el numero2

     ;resuelta
        cmp al,1
        jg salto
        cmp al,1
        jmp noSalto
        
        
        salto:
            ;positivo
            mov resultado,al ;al -> resultado
            xor al,al
            mov al,43
            mov signo3[0],al
            xor al,al
            mov al,36
            mov signo3[1],al  
            mov test1,1
            jmp fin
        noSalto:
            ;negativo
            neg al
            mov resultado,al ;al -> resultado
            xor al,al
            mov al,45
            mov signo3[0],al
            xor al,al
            mov al,36
            mov signo3[1],al 
            mov test1,-1

        fin:
    
endm

restar macro numero1,numero2,resultado,test1,test2,signo3
    LOCAL salto,noSalto,fin   

     mov al,numero2 ;Mueve a al el numero1
     imul test2
     mov bl,al
     xor al,al
     mov al,numero1 ;Mueve a al el numero1
     imul test1
     sub al,bl ;Le suma a al el numero2
     
     

     ;resuelta
        cmp al,1
        jg salto
        cmp al,1
        jmp noSalto
        
        
        salto:
            ;positivo
            mov resultado,al ;al -> resultado
            xor al,al
            mov al,43
            mov signo3[0],al
            xor al,al
            mov al,36
            mov signo3[1],al 
            mov test1,1 
            jmp fin
        noSalto:
            ;negativo
            neg al
            mov resultado,al ;al -> resultado
            xor al,al
            mov al,45
            mov signo3[0],al
            xor al,al
            mov al,36
            mov test1,-1
            mov signo3[1],al 

        fin:

endm  

multiplicar macro numero1,numero2,resultado,test1,test2,registroAH

   LOCAL salto,noSalto,fin
    
    mov ax,0000

    
    
    mov al,numero1 ;Numero1 hacia al
    imul test1 ;signo 1
    imul numero2    ;Numero2 por numero1
    imul test2  ;Signo 2
  



    cmp al,1
       jg salto
    cmp al,1
       jmp noSalto
    
    
    salto:
        ;print numero1
        mov resultado,al ;al -> resultado
        mov test1,1
        jmp fin
    noSalto:
        ;print numero1
        mov test1,-1
        neg al ;Conversor a positivo
        mov resultado,al ;al -> resultado
    fin:  
            mov ah,00h
            mov al,bl
            mov cl,0ah
            div cl
            add ah,30h
            mov registroAH[2],ah
            mov ah,00h
            div cl
            add ah,30h
            mov registroAH[1],ah
            mov ah,09h
            add al,30h
            mov registroAH[0],al
            ;print registroAH
endm

multiplicarSuma macro numero1,numero2,resultado,test1,test2
LOCAL salto,noSalto,fin
    mov al,numero1 ;Numero1 hacia al
    imul test1
    imul numero2    ;Numero2 por numero1
    imul test2
    cmp al,1
       jg salto
    cmp al,1
       jmp noSalto
    
    
salto:
      ;print numero1
      mov resultado,al ;al -> resultado
      jmp fin
noSalto:
      ;print numero1
      neg al
      mov resultado,al ;al -> resultado
fin:

endm

dividir macro numero1,numero2,resultado,test1,test2
LOCAL salto,noSalto,fin
    mov al,numero2 ;Numero1 hacia al
    imul test2
    mov bl,al
    mov al,numero1 ;Numero1 hacia al
    imul test1
    idiv bl
    
    ;resultado 
  
    cmp al,1
       jg salto
    cmp al,1
       jmp noSalto
    
    
    salto:
        ;print numero1
        mov resultado,al ;al -> resultado
        jmp fin
    noSalto:
        ;print numero1
        neg al
        mov resultado,al ;al -> resultado
    fin:

endm

factorialNormal macro cartel,movimientos,ingreseFactorial,saltolinea,concatenar,resultado,concatenaResultado
LOCAL Mientras,fin
      ;Limpieza de variables
      xor dx,dx
      xor bl,bl
      xor al,al
      xor si,si
      ;Variables iniciales
      mov bl,0
      mov dl,1
      mov si,0
      mov dl,0

        ;Muestra los mensajes de inicio
        limpiarCadena concatenar
        print saltolinea
		print ingreseFactorial
        getChar

        ;Extraemos al y lo convertimos a decimal
        cmp al,48
        je casoEspecial


        mov cl,al
        sub cl,48
        ;Limpiamos
        and ax,0

        ;al se ingresa con 1
        mov al,resultado  ;
        


        Mientras:
             
             mov bl,cl  ;movemos el cl al bl para comparar 
             add bl,48  ;Le sumamos 48 para convertirlo a ASCII
             mov concatenar[si],bl	;Movemos a la cadena 
             inc si   ;incrementa si 
             
             mov concatenar[si], 32  ;agregamos espacio a la cadena
             inc si   ;incrementa si 
             
             ;Compara que sea la ultima para no concatenar el resultado
             cmp cl,1   
             je imprimirFactorial

             ;Concatenar *
             mov bl,42
             mov concatenar[si],bl	 
             inc si
             ;realiza el factorial
             mul cl
            
			Loop Mientras ;lo lleva a la etiqueta mientras pero decrementa cx 
           
            
        imprimirFactorial:
              mov concatenar[si], 32  ;concatenamos espacio
              inc si   ;Incrementa si
 
              aam                ; Conversor a ASCII
              add ax, 3030h      ; agrega 3030h
              push ax            ; agregamos a pila ax
              mov dl, ah         ; movemos ah a dl
              mov concatenaResultado[0], dl  ;Concatenamos el primer resultado decenas
              pop dx             ; Extraemos dx de la pila
              mov al,dl          ; Copiamos dl a al
              mov concatenaResultado[1], al  ;Agremos las unidades
              ;Mensajes para imprimir el resultado
              print saltolinea
              print concatenar
              print saltolinea
              print cartel
              print concatenaResultado

              jmp fin

        casoEspecial:
             ;volvemos a hacer uno por uno
             
             add bl,49
             mov concatenar[si],bl	
             inc si
             
             ;Operaciones
             mov al , 1 ; Se coloca en 1 
             mov bl, 1
             mul bl
             add al ,48 ; Se agrega 48 para convertir en ASCII
             
             ;resultado
             mov concatenaResultado[0],al
             mov concatenaResultado[1],36
             
             ;Imprimir mensajes
             print saltolinea
             print concatenar
             print saltolinea
             print cartel
             print concatenaResultado
            
        fin:
        


endm

factorialMacro macro cartel,movimientos,ingreseFactorial,saltolinea,resultado
LOCAL Conversor,factorial,limpiar,recopilar,mostrar,Especial1,Especial2,fin,Especial11,Especial22
        mov bh,0       ;limpiamos bh
        mov si,0       ;el contador para mover la matriz
        and ax,0
        and bx,0
        and cx,0
        and dx,0
        mov di,6
        
        jmp Especial1
        ;jmp Conversor

        

        Conversor: 
           sub al,48 ;- 48 para convertir a decimal
           mov cl,al ;movemos temporalmente a C low
           and ax,0  ;limpiamos ax = ah + al
           add al,cl ;le volvemos a sumar cl
           mov bh,al ;movemos a low para b high
           and cx,0  ;limpiamos cx
           and ax,0  ;limpiamos ax
           mov cl,bh ;movemos bh para cl
           dec cx    ;restamos uno a cx
           mov al,bh ;restauramos al
           mov di,0
           
           limpiarCadena movimientos
            mov bl, 32
            mov movimientos[di],bl
            inc di
            mov bl, cl
            add bl, 49
            mov movimientos[di],bl
            inc di
            mov bl, 32
            mov movimientos[di],bl
            inc di

            

            

            mov bl, 33
            mov movimientos[di],bl
            inc di
            mov bl, 61
            mov movimientos[di],bl
            inc di
            
            

        factorial:
            mul cx
            push cx 
            push ax

            mov bl, 32
            mov movimientos[di],bl
            inc di
            mov bl, cl
            add bl, 49
            mov movimientos[di],bl
            inc di
            mov bl, 32
            mov movimientos[di],bl
            inc di

            

            

            mov bl, 33
            mov movimientos[di],bl
            inc di
            mov bl, 61
            mov movimientos[di],bl
            inc di


            and dx,0
            mov bx,0000h
            mov cx,10
            recopilarCadena
            mostrarCadena cartel,movimientos,saltolinea,resultado
            ;limpiarCadena movimientos
            ;limpiarCadena resultado 
            mov di,0
            mov si,0

           pop ax
           pop cx 
           loop factorial
           jmp fin
       
        limpiar:
            and dx,0
            mov bx,0000h
            mov cx,10

        recopilar:
            div cx    ;dx almacena el resudio que nos interesa
            push dx   ;almacenamos dx en pila
            add bx,1h ;sumamos 1 a bx
            and dx,0  ;limpiamos dx
            cmp ax,0  ;comparamos que no resta nada del numero
            jne recopilar
        
        MOV AH,2
        ;print saltolinea
        ;print cartel

        mostrar:
            sub bx,1h                    ;restamos a bx 1
            pop dx                       ;restauramos dx de la pila
            add dl,30h                   ;Agregamos 48 a dl para mostrarlo
            mov resultado[si],dl ;Agregamos resultado
            inc si
            ;int 21H                      ;interrupcion 21
            cmp bx,0                     ;comparamos si ya terminamos
            jne mostrar
            print movimientos
            print saltolinea
            print resultado      
            jmp fin

        Especial1:
            print saltolinea
            
            
            cmp al,48  ;caso especial 11
            je Especial11
            jmp Especial2
            

        Especial11:
            print movimientos
            print cartel
            add al,1
            mov resultado[0],al
            print resultado
            jmp fin

            
        Especial2:
            mov bl, 49
            mov movimientos[di],bl
            inc di
            mov bl, 33
            mov movimientos[di],bl
            inc di
            mov bl, 61
            mov movimientos[di],bl
            inc di
            mov bl, 49
            mov movimientos[di],bl
            inc di
            print movimientos

            cmp al,49  ;caso especial 1
            je Especial22

            jmp Conversor

        Especial22:
            print saltolinea
            print cartel
            mov resultado[0],al
            print resultado
            jmp fin

        fin:
            limpiarCadena movimientos
            limpiarCadena resultado

endm

recopilarCadena macro 
LOCAL recopilar

        recopilar:
            div cx    ;dx almacena el resudio que nos interesa
            push dx   ;almacenamos dx en pila
            add bx,1h ;sumamos 1 a bx
            and dx,0  ;limpiamos dx
            cmp ax,0  ;comparamos que no resta nada del numero
            jne recopilar

            MOV AH,2
endm

mostrarCadena macro cartel,movimientos,saltolinea,resultado
LOCAL  mostrar
        mostrar:
            sub bx,1h                    ;restamos a bx 1
            pop dx                       ;restauramos dx de la pila
            add dl,30h                   ;Agregamos 48 a dl para mostrarlo
            mov resultado[si],dl ;Agregamos resultado
            inc si
            ;int 21H                      ;interrupcion 21
            cmp bx,0                     ;comparamos si ya terminamos
            jne mostrar
            print movimientos
            print resultado  
               
            

endm

limpiarCadena macro  cadena
     mov cadena[0],36  
     mov cadena[1],36
     mov cadena[2],36
     mov cadena[3],36
     mov cadena[4],36
     mov cadena[5],36
     mov cadena[6],36
     mov cadena[7],36
     mov cadena[8],36
     mov cadena[9],36
     mov cadena[10],36
     mov cadena[11],36
     mov cadena[12],36
     mov cadena[13],36
     mov cadena[14],36
     mov cadena[15],36
     mov cadena[16],36
     mov cadena[17],36
   
  
     

endm

imprimirDecimal macro numero,guardar
    mov al, numero     
    aam               
    add ax, 3030h     
    push ax            
    mov dl, ah         
    mov guardar[0], dl
    mov ah, 02h        
    int 21h
    pop dx             
    mov al,dl
    mov guardar[1], al
    mov ah, 02h        
    int 21h
endm

NoImprimirDecimal macro numero,guardar
    mov al, numero     
    aam               
    add ax, 3030h     
    push ax            
    mov dl, ah         
    mov guardar[0], dl
    mov ah, 02h        
    ;int 21h
    pop dx             
    mov al,dl
    mov guardar[1], al
    mov ah, 02h        
    ;int 21h
endm

imprimirDecimalDirecto macro
    aam                ; -> AH is quotient (1) , AL is remainder (2)
    add ax, 3030h      ; -> AH is "1", AL is "2"
    push ax            ; (1)
    mov dl, ah         ; First we print the tens
    ;mov guardar[0], dl
    mov ah, 02h        ; DOS.PrintChar
    int 21h
    pop dx             ; (1) Secondly we print the ones (moved from AL to DL via those PUSH AX and POP DX instructions
    mov es,dx
    ;mov guardar[1], dl
    mov ah, 02h        ; DOS.PrintChar
    int 21h

endm

multitest macro numeroResultado
     mov ax , 50
     mov cl, 50
     mul cl
     mov numeroResultado,al
     print numeroResultado
endm

convertirPushar macro numero
LOCAL positivo ,negativo,fin
    xor ax,ax 
    mov al, numero[0]
    cmp al, 45
    je negativo

    jmp positivo

    positivo:
            mov al ,numero[0]
            ;mov resultado[0], al
            sub al,48
            mov cl,10
            mul cl
            mov bl,al
            mov al, numero[1]
            sub al,48
            add bl,al
            mov cl,-1
            mov al,bl
            mul cl
            ;al tiene el resultado y lo metemos a la pila
            push ax
         
         jmp fin
    negativo:
            mov al ,numero[1]
            ;mov resultado[0], al
            sub al,48
            mov cl,10
            mul cl
            mov bl,al
            mov al, numero[2]
            sub al,48
            add bl,al
            mov cl,-1
            mov al,bl
            mul cl
            ;al tiene el resultado y lo metemos a la pila
            push ax
            
            
            jmp fin

    fin: 
            
            ;print signo
    
endm
    
conversor macro numero1,resultado,numero2
    mov al ,numero1[0]
    ;mov resultado[0], al
    sub al,48
    mov cl,10
    mul cl
    mov bl,al
    mov al, numero2[0]
    sub al,48
    add bl,al
    ;add bl, numero2
    mov resultado,bl

endm

extractor macro arreglo,numero1,numero2
    mov ax,0000
    mov al ,arreglo[0]
    mov numero1[0],al
    mov al, 36 ;ascii del signo $ o en hexadecimal 24h
    mov numero1[1],al  ;copiamos el $ a la cadena
    mov al,0
    mov al ,arreglo[1]
    mov numero2[0],al
    mov al, 36 ;ascii del signo $ o en hexadecimal 24h
    mov numero2[1],al  ;copiamos el $ a la cadena
endm

corrector macro numero
LOCAL positivo,positivo2 ,negativo,fin ,negativo2
    mov al, numero[0]
    cmp al, 95
    je negativo

    jmp positivo
    

    

    ;Pero en caso venga un negativo o guion bajo
    


    positivo:
         ;verificar que sea 1 solo numero o dos
         mov al, numero[1]
         cmp al,36   ;es dolar entonces solo hay un digito
         je positivo2
         
        
         ;En caso que si hay 2 digitos
         mov numero[2], 36 ;dolar al espacio vacio
         jmp fin

    positivo2:
         ;En caso que no hay 2 digitos
         mov al, numero[0]
         mov numero[1], al
         mov al, 48
         mov numero[0], al 
         
         mov numero[2], 36 ;dolar al espacio vacio
         jmp fin
    
    negativo:
            
            mov numero[0] , 45

            mov al ,numero[2]
            ;verificamos si es negativo unico o decimal
            cmp al,36
            je negativo2
            ;en caso que no seguir normal.
            ;no se modifica solo el signo
            jmp fin

    negativo2:
            mov al ,numero[1]
            mov numero[2] , al
            mov numero[1], 48
            jmp fin
    fin: 
            
            ;print signo

        

endm

extractorCompleto macro arreglo,numero1,numero2,test1,signo
Local ok,malo,fin
            mov ax,0000
        
            mov al ,arreglo[0]
            cmp al,47 ;0
                ;print arreglo
                ja ok
               
            cmp al,45
                ;print arreglo
                je malo
            ;abria que agregar en caso es positivo
            ;sobre un resultado anterior.

        

      ok:
            mov al ,arreglo[0]
            mov numero1[0],al
            mov al, 36 ;ascii del signo $ o en hexadecimal 24h
            mov numero1[1],al  ;copiamos el $ a la cadena
            mov al,0
            mov al ,arreglo[1]
            mov numero2[0],al
            mov al, 36 ;ascii del signo $ o en hexadecimal 24h
            mov numero2[1],al  ;copiamos el $ a la cadena
            mov al, 1
            mov test1,al  
            mov al,43
            mov signo[0],al
            mov al,36
            mov signo[1],al
            ;print signo
            jmp fin
            
      malo:
            mov al ,arreglo[1]
            mov numero1[0],al
            mov al, 36 ;ascii del signo $ o en hexadecimal 24h
            mov numero1[1],al  ;copiamos el $ a la cadena
            mov al,0
            mov al ,arreglo[2]
            mov numero2[0],al
            mov al, 36 ;ascii del signo $ o en hexadecimal 24h
            mov numero2[1],al  ;copiamos el $ a la cadena
            mov al, -1
            mov test1,al  
            mov al,45
            mov signo[0],al
            mov al,36
            mov signo[1],al
            ;print signo
        fin:

            
endm

cuentaIntento macro numero
      xor ax,0
      mov al,numero
      add al,1
      mov numero,al
endm

extractorCompletoSigno macro arreglo,numero1,numero2,test1,signo
Local ok,malo,fin,positivo
            mov ax,0000
        
            mov al ,signo
            cmp al,43
                ;print arreglo
                je positivo

               
            cmp al,45
                ;print arreglo
                je malo

            
            ;abria que agregar en caso es positivo
            ;sobre un resultado anterior.
      positivo:
            mov al ,arreglo[0]
            mov numero1[0],al
            mov al, 36 ;ascii del signo $ o en hexadecimal 24h
            mov numero1[1],al  ;copiamos el $ a la cadena
            mov al,0
            mov al ,arreglo[1]
            mov numero2[0],al
            mov al, 36 ;ascii del signo $ o en hexadecimal 24h
            mov numero2[1],al  ;copiamos el $ a la cadena
            mov al, 1
            mov test1,al  
            mov al,43
            mov signo[0],al
            mov al,36
            mov signo[1],al


        
           jmp fin
      ok:
            mov al ,arreglo[0]
            mov numero1[0],al
            mov al, 36 ;ascii del signo $ o en hexadecimal 24h
            mov numero1[1],al  ;copiamos el $ a la cadena
            mov al,0
            mov al ,arreglo[1]
            mov numero2[0],al
            mov al, 36 ;ascii del signo $ o en hexadecimal 24h
            mov numero2[1],al  ;copiamos el $ a la cadena
            mov al, 1
            mov test1,al  
            mov al,43
            mov signo[0],al
            mov al,36
            mov signo[1],al
            ;print signo
            jmp fin
            
      malo:
            mov al ,arreglo[1]
            mov numero1[0],al
            mov al, 36 ;ascii del signo $ o en hexadecimal 24h
            mov numero1[1],al  ;copiamos el $ a la cadena
            mov al,0
            mov al ,arreglo[2]
            mov numero2[0],al
            mov al, 36 ;ascii del signo $ o en hexadecimal 24h
            mov numero2[1],al  ;copiamos el $ a la cadena
            mov al, -1
            mov test1,al  
            mov al,45
            mov signo[0],al
            mov al,36
            mov signo[1],al
            ;print signo
        fin:

            
endm

leySignos macro signo,signo2,signo3
 LOCAL  multi,divi,flag1,flag11,flag111,flag2,flag22,flag222,fin   
    
         xor al,al
         mov al,signo[0]
         cmp al,45
           je flag1
         cmp al,43
           je flag2


    flag1:
         xor bl,bl
         mov bl,signo2[0]
         cmp bl,45
           je flag11
         cmp bl,43
           je flag111

    flag11:
          xor al,al
          mov al,43
          mov signo3[0],al 
          xor al,al
          mov al,36
          mov signo3[1],al  
            
          jmp fin

    flag111:
          xor al,al
          mov al,45
          mov signo3[0],al  
          xor al,al
          mov al,36
          mov signo3[1],al  
         

          jmp fin

    flag2:
         xor bl,bl
         mov bl,signo2[0]
         cmp bl,45
           je flag22
         cmp bl,43
           je flag222

    flag22:
          xor al,al
          mov al,45
          mov signo3[0],al  
          xor al,al
          mov al,36
          mov signo3[1],al  
           
          jmp fin  
    flag222:
          xor al,al
          mov al,43
          mov signo3[0],al 
          xor al,al
          mov al,36
          mov signo3[1],al  
            
          jmp fin 
         

    fin:


endm

limpiarCadenaCiclo macro cadena,indice
LOCAL limpieza,conversor
    mov cl,indice
    mov si,0

    conversor:
        inc si
        loop conversor
        
    mov cl,indice 

    limpieza:
        mov cadena[si], 48
        dec si
        loop limpieza




endm

esNumero macro numero,verificador
     mov al,numero
     cmp al, 43
     je esNumber
     cmp al, 45
     je esNumber
     cmp al, 48
     je esNumber
     cmp al, 49
     je esNumber
     cmp al, 50
     je esNumber
     cmp al, 51
     je esNumber
     cmp al, 52
     je esNumber
     cmp al, 53
     je esNumber
     cmp al, 54
     je esNumber
     cmp al, 55
     je esNumber
     cmp al, 56
     je esNumber
     cmp al, 57
     je esNumber




    jmp fin
       esNumber:
       mov verificador[0] ,1



     fin:
       mov verificador[0],0



endm


compararCadena macro cadena1,cadena2,bool
Local iniciar,validacion1,validacion2,fin
        iniciar:
            mov al,cadena1[0]
            mov bl,cadena2[0]

            cmp al,bl
            je validacion1


            mov bool[0],48   ;es valida
            jmp fin 

        validacion1:
            mov al,cadena1[1]
            mov bl,cadena2[1]

            cmp al,bl
            je validacion2

            mov bool[0],48   ;es valida
            jmp fin
        validacion2:
            mov bool[0],49   ;es valida
            jmp fin
        fin:

endm


if_imprimir macro bool,cartel1,cartel2
LOCAL fin ,no  
     mov al, bool[0]

     cmp al,48
     je no

     print cartel2

     jmp fin

     no:
       print cartel1

    fin:


endm


abrir macro buffer,handler

	mov ah,3dh
	mov al,02h
	lea dx,buffer
	int 21h
	jc Error1
	mov handler,ax

endm

limpiar macro buffer, numbytes, caracter
LOCAL Repetir
	xor si,si
	xor cx,cx
	mov	cx,numbytes

	Repetir:
		mov buffer[si], caracter
		inc si
		Loop Repetir
endm

cerrar macro handler
	
	mov ah,3eh
	mov bx, handler
	int 21h
	jc Error2
	mov handler,ax

endm

leer macro handler,buffer, numbytes
	xor ax,ax
    xor bx,bx
    xor cx,cx
    xor dx,dx


	mov ah,3fh
	mov bx,handler
	mov cx,numbytes
	lea dx,buffer ; mov dx,offset buffer 
	int 21h
	jc  Error5

endm

crear macro buffer, handler
    xor ax,ax
    xor bx,bx
    xor cx,cx
    xor dx,dx
	
	mov ah,3ch
	mov cx,00h
	lea dx,buffer
	int 21h
	jc Error4
	mov handler, ax

endm

escribir macro handler, buffer, numbytes
    xor ax,ax
    xor bx,bx
    xor cx,cx
    xor dx,dx


	mov ah, 40h
	mov bx, handler
	mov cx, numbytes
	lea dx, buffer
	int 21h
	jc Error3

endm


esLetra macro caracter,bool
LOCAL falso,verdadero,fin
    mov al,caracter[0]
    cmp al, 65
    je verdadero
    cmp al, 66
    je verdadero
    cmp al, 67
    je verdadero
    cmp al, 68
    je verdadero
    cmp al, 69
    je verdadero
    cmp al, 70
    je verdadero
    cmp al, 71
    je verdadero
    cmp al, 72
    je verdadero
    cmp al, 73
    je verdadero
    cmp al, 74
    je verdadero
    cmp al, 75
    je verdadero
    cmp al, 76
    je verdadero
    cmp al, 77
    je verdadero
    cmp al, 78
    je verdadero
    cmp al, 79
    je verdadero
    cmp al, 80
    je verdadero
    cmp al, 81
    je verdadero
    cmp al, 82
    je verdadero
    cmp al, 83
    je verdadero
    cmp al, 84
    je verdadero
    cmp al, 85
    je verdadero
    cmp al, 86
    je verdadero
    cmp al, 87
    je verdadero
    cmp al, 88
    je verdadero
    cmp al, 89
    je verdadero
    cmp al, 90
    je verdadero
    cmp al, 97
    je verdadero
    cmp al, 98
    je verdadero
    cmp al, 99
    je verdadero
    cmp al, 100
    je verdadero
    cmp al, 101
    je verdadero
    cmp al, 102
    je verdadero
    cmp al, 103
    je verdadero
    cmp al, 104
    je verdadero
    cmp al, 105
    je verdadero
    cmp al, 106
    je verdadero
    cmp al, 107
    je verdadero
    cmp al, 108
    je verdadero
    cmp al, 109
    je verdadero
    cmp al, 110
    je verdadero
    cmp al, 111
    je verdadero
    cmp al, 112
    je verdadero
    cmp al, 113
    je verdadero
    cmp al, 114
    je verdadero
    cmp al, 115
    je verdadero
    cmp al, 116
    je verdadero
    cmp al, 117
    je verdadero
    cmp al, 118
    je verdadero
    cmp al, 119
    je verdadero
    cmp al, 120
    je verdadero
    cmp al, 121
    je verdadero
    cmp al, 122
    je verdadero

    

    falso:
         mov bool[0],48
         jmp fin

    verdadero:
         mov bool[0],49
         jmp fin
    fin:




endm

esNumero macro caracter,bool
LOCAL falso,verdadero,fin
    mov al,caracter[0]
    cmp al, 48
    je verdadero
    cmp al, 49
    je verdadero
    cmp al, 50
    je verdadero
    cmp al, 51
    je verdadero
    cmp al, 52
    je verdadero
    cmp al, 53
    je verdadero
    cmp al, 54
    je verdadero
    cmp al, 55
    je verdadero
    cmp al, 56
    je verdadero
    cmp al, 57
    je verdadero
    cmp al, 95
    je verdadero
  
 
    falso:
         mov bool[0],48
         jmp fin

    verdadero:
         mov bool[0],49
         jmp fin
    fin:




endm


actualizarContador macro numero
LOCAL mientras1
      mov cl,numero
      xor si,si

      mientras1:
           inc si
           loop mientras1
      mov cl,numero
      add cl,1
      mov numero,cl

endm

