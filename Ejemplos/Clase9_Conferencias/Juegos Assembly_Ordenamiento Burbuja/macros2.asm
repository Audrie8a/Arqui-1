print macro cadena
  LOCAL ETIQUETA
  ETIQUETA:
    Mov ah,09h
    mov dx,@data
    mov ds,dx
    mov dx, offset cadena
    int 21h
endm    

getChar macro
   mov ah,01h
   int 21h
endm   

abrirA macro ruta, handle
  mov ah, 3dh
  mov al, 00h
  lea dx,ruta
  int 21h
  mov handle,ax
endm
  
leerA macro numbytes, buffer, handle
    mov ah,3fh
    mov bx,handle
    mov cx,numbytes
    lea dx,buffer
    int 21h
endm

cerrarA macro handle
    mov ah,3eh
    mov handle,bx
    int 21h
endm
;=============================================================================
GuardarNumeros macro buffer,cantidad,arreglo,numero
	LOCAL INICIO,RECONOCER,GUARDAR,FIN,SALIR
	xor bx,bx
	xor si,si
	xor di,di
;--------------------------------------------------------------------------------------------	
	; metodo que va reconociendo palabras reservadas o caracteres especiales
	;hasta que encuentra un caracter de un numero, y poder iniciar a guardarlo. 
	INICIO:
		mov bl,buffer[si] ; lectura de archivo
		
		cmp bl,36   ; $
		je FIN      ; terminar
		cmp bl,48   ; 0
		jl SALIR    ; salta si es menor que 0
		cmp bl,57   ; 9
		jg SALIR    ; salta si es mayor que 9
		jmp RECONOCER	
;--------------------------------------------------------------------------------------------	
	; metodo que va reconociendo el numero, hasta que encuentra un caracter de finalización. 
	;Al encontrarlo procede a guardar dicho numero
	RECONOCER:
		mov bl,buffer[si]
		cmp bl,48
		jl GUARDAR
		cmp bl,57
		jg GUARDAR
		inc si
		mov numero[di],bl
		inc di
		jmp RECONOCER
;--------------------------------------------------------------------------------------------
	; metodo que guarda el numero reconocido en el arreglo
	GUARDAR:
		push si
		ConvertirDec numero
		xor bx,bx
		mov bl,cantidad
		mov arreglo[bx],al
		
		;getChar
		;xor ax,ax
		;mov al,arreglo[bx]
		;ConvertirString numero
		;print numero
		;Limpiarbuffer numero
		
		inc cantidad
		pop si
		xor bx,bx
		xor ax,ax
		jmp INICIO
;--------------------------------------------------------------------------------------------			
	SALIR:
		
		inc si
		xor di,di
		jmp INICIO
;--------------------------------------------------------------------------------------------			
	FIN: 
		xor ax,ax
		mov al,cantidad
		mov cantidad2,ax
endm   
;===========================================================================
;metodo que convierte la secuencia de digitos en un numero decimal
;regresa el resultado en AX
ConvertirDec macro numero
  LOCAL INICIO,FIN
	xor ax,ax
	xor bx,bx
	xor cx,cx
	mov bx,10	;multiplicador 10
	xor si,si
	INICIO:
		mov cl,numero[si] 
		cmp cl,48
		jl FIN
		cmp cl,57
		jg FIN
		inc si
		sub cl,48	;restar 48 para que me de el numero
		mul bx		;multplicar ax por 10
		add ax,cx	;sumar lo que tengo mas el siguiente
		jmp INICIO
	FIN:
endm

ConvertirString macro buffer
	LOCAL Dividir,Dividir2,FinCr3,NEGATIVO,FIN2,FIN
	xor si,si
	xor cx,cx
	xor bx,bx
	xor dx,dx
	mov dl,0ah
	test ax,1000000000000000
	jnz NEGATIVO
	jmp Dividir2

	NEGATIVO:
		neg ax
		mov buffer[si],45
		inc si
		jmp Dividir2

	Dividir:
		xor ah,ah
	Dividir2:
		div dl
		inc cx
		push ax
		cmp al,00h
		je FinCr3
		jmp Dividir
	FinCr3:
		pop ax
		add ah,30h
		mov buffer[si],ah
		inc si
		loop FinCr3
		mov ah,24h
		mov buffer[si],ah
		inc si
	FIN:
endm
;===========================================================================
;string = " "
;string = null

Limpiarbuffer macro buffer
   LOCAL INICIO, FIN
   xor bx,bx
   INICIO:
      mov buffer[bx],36
      inc bx
      cmp bx,20
      je FIN
      Jmp INICIO
   FIN:
endm

Limpiarbuffer2 macro buffer
   LOCAL INICIO, FIN
   xor bx,bx
   INICIO:
      mov buffer[bx],36
      inc bx
      cmp bx,60
      je FIN
      jmp INICIO
   FIN:
endm

copiarArreglo macro fuente, destino
   LOCAL INICIO , FIN
   xor si,si
   xor bx,bx
   INICIO:
      mov bl, cantidad
      cmp si, bx
      je FIN
      mov al, fuente[si]
      mov destino[si],al
      inc si
      jmp INICIO
  FIN:
endm

;===========================================================================

DeterminarMayor macro
  LOCAL BURBUJA, VERIFICARMENOR, RESETEAR, FIN, MENOR
  xor si,si
  xor ax,ax
  xor bx,bx
  xor cx,cx
  xor dx,dx
  mov dx,cantidad2
  dec dx
  BURBUJA:
      mov al, arreglo[si]
      mov bl, arreglo[si+1]
      cmp al,bl
      jl MENOR
      inc si
      inc cx
      cmp cx,dx
      Jne BURBUJA
      mov cx,0
      mov si,0
      jmp VERIFICARMENOR
  MENOR:
      mov arreglo[si],bl
      mov arreglo[si+1],al
      inc si
      inc cx
      cmp cx,dx
      jne BURBUJA
      mov cx,0
      mov si,0
      jmp VERIFICARMENOR
  VERIFICARMENOR:
      mov al, arreglo[si]
      mov bl, arreglo[si+1]
      cmp al,bl
      jl RESETEAR
      inc si
      inc cx
      cmp cx,dx
      jne VERIFICARMENOR
      Jmp FIN
   RESETEAR:
      MOV si,0
      mov cx,0
      jmp BURBUJA
   FIN:
      xor ax,ax
      mov al,arreglo[0]
      mov maximo,ax
endm   

;==============================================================================

Burbuja macro
     ; Convertir velocidad en hz
     mov cl,9
     sub cl, velocidad1
     inc cl
     mov ax,500
     mov bl,cl
     mul bl
     mov tiempo,ax
;--------------------------------------------------------
     BurbujaAsc	
endm

;==============================================================================

BurbujaAsc macro
    LOCAL BURBUJA, VERIFICARMENOR, RESETEAR, FIN, MENOR
    xor si,si
    xor ax,ax
    xor bx,bx
    xor cx,cx
    xor dx,dx
    mov dl,cantidad
    dec dx
    Graficar arreglo 			; Aqui
    BURBUJA:
       mov al,arreglo[si]
       mov bl,arreglo[si+1]
       cmp al,bl
       jg MENOR
       inc si
       inc cx
       cmp cx,dx
       jne BURBUJA
       mov cx,0
       mov si,0
       jmp VERIFICARMENOR
    MENOR:
        mov arreglo[si],bl
        mov arreglo[si+1],al
        Graficar arreglo		; Aqui
 	inc si
        inc cx
        cmp cx,dx
        jne BURBUJA
        mov cx,0
        mov si,0
        jmp VERIFICARMENOR
    VERIFICARMENOR:
        mov al,arreglo[si]
        mov bl, arreglo[si+1]
        cmp al,bl
        jg RESETEAR
        inc si
        inc cx
        cmp cx,dx
        jne VERIFICARMENOR
        jmp FIN
    RESETEAR:
        mov si,0
        mov cx,0
        jmp BURBUJA
    FIN:
        GraficarFinal arreglo		;Aqui
endm

;=======================================GRAFICAR=====================================

Graficar macro arreglo
     pushear
     obtenerNumeros
     DeterminarTamano tamanoX, espacio,cantidad2,espaciador
     pushearVideo arreglo
     ModoGrafico
     imprimirVN numerosMos, 16h, 02h
     poppearVideo arreglo
     graficarBarras cantidad2, espacio2, arreglo
     ModoTexto
     poppear
endm

GraficarFinal macro arreglo
     pushear
     obtenerNumeros
     DeterminarTamano tamanoX, espacio,cantidad2,espaciador
     pushearVideo arreglo
     ModoGrafico
     imprimirVN numerosMos, 16h, 02h
     poppearVideo arreglo
     graficarBarras cantidad2, espacio2, arreglo
     getChar
     getChar
     ModoTexto
     poppear
endm

;==============================================================================
obtenerNumeros macro
     LOCAL INICIO, FIN
     pushear
     xor si,si
     xor dx,dx
     mov dl, cantidad
     Limpiarbuffer2 numerosMos
     INICIO:
         Limpiarbuffer resultado
	  cmp si,dx
          je FIN
          push si
          push dx
          xor ax,ax
	  mov al,arreglo[si]
          ConvertirString resultado
          insertarNumero resultado
	  Limpiarbuffer resultado
          pop dx
          pop si
          inc si
          jmp INICIO
     FIN:
          poppear
endm

insertarNumero macro cadena
     LOCAL INICIO, FIN, SIGUIENTE
     xor si,si
     xor di,di
     INICIO:
		cmp si,60
        je FIN
        mov al,numerosMos[si]
        cmp al,36			;'$'
        je SIGUIENTE
        inc si
	 	jmp INICIO
	     SIGUIENTE:
		mov al,cadena[di]
	        cmp al,36
		je FIN
	        mov numerosMos[si],al
		inc di
		inc si
		jmp SIGUIENTE
	     FIN:
		mov numerosMos[si],32		;
endm


DeterminarTamano macro tamanoX, espacio, cantidad, espaciador
     mov ax,260		; tamano que tenemos para dibujar de largo
     mov bx,cantidad	; cantidad de datos que tenemos
     xor bh,bh
     div bl		;diviendo el lienzo en la cantidad de datos que tenemos
     xor dx,dx
     mov dl,al		; guardamos el cociente en dl
     mov espaciador,dx	; guardando el cociente en espaciador
     xor ah,ah
     mov bl,25
     mul bl
     mov bl,100
     div bl		; sacamos 25%
     
     mov espacio,al	; guardo el cociente en espacio, Espacio entre c/barra
     mov bx,espaciador
     sub bl,espacio	; restamos el espacio entre cada barra
     mov tamanoX,bx	; asignamor el valor a tamanoX
endm

imprimirVN macro cadena, fila, columna	;param1= lo que imprimo, 2= fila, 3 = columna
  ;funcion 02h, interrupción 10h 
  ;Correr el cursos N cantidad de veces
  ;donde dl = N	
  push ds
  push dx
  xor dx,dx
  mov ah,02h
  mov bh,0		;pagina
  mov dh,fila
  mov dl,columna
  int 10h

  ;Funcion 09H, interrupcion 21h
  ;imprimir  caracteres en consola
  mov ax,@data
  mov ds,ax
  mov ah,09
  mov dx,offset cadena
  int 21h
  pop dx
  pop ds
endm

graficarBarras macro cantidad, espacio, arreglo
    LOCAL INICIO, FIN
    xor cx,cx
    INICIO:
	cmp cx,cantidad
	je FIN
	push cx
	mov si,cx
	xor ax,ax
	mov al, arreglo[si]
	mov valor,al
	push ax
	;DeterminarColor
	mov dl,15					;aquí
	xor ax,ax
	mov ax,maximo
	mov max,al
	dibujarBarra espacio,valor,max		
	pop ax
	mov valor,al
	;DeterminarSonido			;aqui
	delay tiempo				;aquí
	pop cx
	inc cx
	jmp INICIO
    FIN:
endm

DeterminarColor macro
        LOCAL SEGUNDO, TERCERO, CUARTO, QUINTO, FIN
	cmp valor,1
	jb FIN
	cmp valor,20
	ja SEGUNDO
	mov dl,4
        jmp FIN
	SEGUNDO:
		cmp valor,40
		ja TERCERO
		mov dl,1
		jmp FIN
	TERCERO:
		cmp valor,60
		ja CUARTO
		mov dl,44
		JMP FIN
	CUARTO:
		cmp valor,80
		ja QUINTO
		mov dl,2
		jmp FIN
	QUINTO:
		cmp valor,99
		ja FIN 
		mov dl,15
		jmp FIN
	FIN:
endm

dibujarBarra macro espacio, valor, max
	LOCAL INICIO, FIN
	xor cx,cx
	DeterminarTamanoY valor,max
	INICIO:
		cmp cx,tamanoX
		je FIN 
		push cx
		mov ax,170
		mov bx,ax
		sub bl,valor
		xor bh,bh
		mov si,bx
		mov bx,30
		add bx,espacio
		add bx,cx
		PintarY
		pop cx
		inc cl
		jmp INICIO
	FIN:
		mov ax,espaciador
		add espacio,ax
endm

DeterminarTamanoY macro valor, max
	xor ax,ax
	mov al,valor
	mov bl,130
	mul bl
	mov bl,max
	div bl
	mov valor,al
endm

PintarY macro
	LOCAL ejey, FIN
	; Dibujar eje de las abcisas
	mov cx,si 
	ejey:
		cmp cx,ax
		je FIN
		mov di,cx
		push ax
		push dx
		mov ax,320
		mul di
		mov di,ax
		pop dx
		pop ax
		mov [di+bx],dl	;  160 -> 160 representa los 160 pixeles de ancho que es la distancia a la que se estarán pintando las de Y
		inc cx
		jmp ejey
	FIN:
endm

DeterminarSonido macro
	LOCAL SEGUNDO, TERCERO, CUARTO, FIN, QUINTO
	cmp valor,1
	jb FIN
	cmp valor,20
	ja SEGUNDO
	Sound 100
	jmp FIN
	SEGUNDO:
		cmp valor,40
		ja TERCERO
		Sound 300
		jmp FIN
	TERCERO:
		cmp valor,60
		ja CUARTO
		Sound 500
		jmp FIN
	CUARTO:
		cmp valor,80
		ja QUINTO
		Sound 700
		jmp FIN
	QUINTO:
		cmp valor,99
		ja FIN
		Sound 900
		jmp FIN
	FIN:
endm

;----------------- SONIDO EN HZ
Sound macro hz
	mov al,86h
	out 43h,al
	mov ax,(1193180 / hz ) ;numero de hz
	out 42h,al
	mov al,ah
	out 42h, al
	in al,61h
	or al, 00000011b
	out 61h,al
	delay tiempo  ;mando a ejecutar el delay para que se escuche el sonido por varios segundos
	 ; apagar la bocina
	in al, 61h
	and al, 11111100b
	out 61h,al
endm

Delay macro constante
	LOCAL D1,D2,Fin
	push si
	push di
	
	mov si,constante
	D1:
		dec si
		jz Fin
		mov di,constante
	D2:
		dec di
		jnz D2
		jmp D1
	Fin:
		pop di
		pop si
endm

ModoTexto macro
	;regresar a modo texto
	mov ax,0003h
	int 10h
	mov ax,@data
	mov ds,ax
endm	
		
;===============================PUSH Y POP TODO ================================================
pushear macro
	push ax
	push bx
	push cx
	push dx
	push si
	push di
endm

poppear macro
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
endm

pushearVideo macro arreglo
	pushArreglo arreglo
	push maximo
	push tamanoX
	push espaciador
	push cantidad2
	push tiempo	
endm

poppearVideo macro arreglo
	pop tiempo
	pop cantidad2
	pop espaciador
	pop tamanoX
	pop maximo
	popArreglo arreglo
endm

pushArreglo macro arreglo
	LOCAL INICIO,FIN
	xor si,si
	INICIO:
		xor ax,ax
		cmp si,cantidad2
		je FIN
		mov al,arreglo[si]
		push ax
		inc si
		jmp INICIO
	FIN:
endm

popArreglo macro arreglo
	LOCAL INICIO,FIN
	xor si,si
	mov si,cantidad2
	dec si
	INICIO:
		cmp si,0
		jl FIN
		pop ax
		mov arreglo[si],al
		dec si
		jmp INICIO
	FIN:
endm	

;==============================================================================
ModoGrafico macro
	;Iniciacion de modo video  
	mov ax,0013h ;nos da una resolución de 200x320 (pixeles (alto,ancho))
	int 10h
	mov ax, 0A000h
	mov ds, ax  ; DS = A000h (memoria de graficos).
endm