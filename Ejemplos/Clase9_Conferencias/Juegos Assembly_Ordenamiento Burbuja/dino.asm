%macro MDibujarRex 1
   mov di,ax
   mov si, %1
   cld
   mov cx,20
   rep movsb
%endmacro

%macro MDibujarCactus 1
   mov di,ax
   mov si, %1
   cld
   mov cx,12
   rep movsb
%endmacro

%macro MDibujarCalle 1
   mov di,ax
   mov si, %1
   cld
   mov cx,310
   rep movsb
%endmacro

%macro MoverCactus 1
	mov ax, obstaculos[si]
	cmp ax,0
	jnz %%ContinuarObstaculo
	mov ax,308	
	
	push ax
	xor ax,ax
	mov ax,0
	mov movObstaculos[si],ax
	pop ax
	
%%ContinuarObstaculo:			
	dec ax
	dec ax
	mov obstaculos[si], ax	
	
	xor ax,ax
	mov ax,movObstaculos[si]
	inc ax
	inc ax
	mov movObstaculos[si],ax
%endmacro
;===========================================================================================


org 100h
section .text 

inicio:
    ;mov  ax,data       ; mover la dirección del segmento de datos a ax
    ;mov  ds,ax         ; copiar dirección a ds
    ;mov  es,ax

    ;mov ax, 1024h      ; mover dirección segmento de stack a ax
    ;mov ss,ax          ; copiar dirección a ss    
    
    ;mov sp,stacktop     ; Apuntar sp al principio del stack

inicioVid:
    mov ax,13h          ; modo grafico VGA
    int 10h             ; interrupcion modo video
	
    mov ax, 0A000h
    mov es, ax
    
mainLoop:	
    call HiloDibujar
    
    call HasKey         ; hay tecla
    
    jz mainLoop         ; no hay, saltar a mainLoop

    call GetCh          ; si hay, leer cual es
    ;call ClearIn
    
    cmp al, 'b'         ; es b?, salir
    jne LO1             ; si no , comprobar movimientos
    
finProg:
    
    mov ax,3h           ;Modo Texto
    int 10h
        
    mov ax, 04C00H      ; salir 
    int 21H      

    mov ax, 04C00H      ; salir 
    int 21H             ; fin de programa
   	
LO1:	
	cmp al, 20h
    jne mainLoop
	
	; Si llega aqui es la barra espaciadora
	mov cx,10	
	
	ParabolicoArriba:	              		
		xor ax,ax
		mov ax,[coordRY]
		sub ax,5
		mov [coordRY],ax
		
		push cx
		call HiloDibujar
		pop cx	
	loop ParabolicoArriba
	
	mov cx,10
	ParabolicoAbajo:	              		
		xor ax,ax
		mov ax,[coordRY]
		add ax,5
		mov [coordRY],ax
		
		push cx
		call HiloDibujar
		pop cx	
	loop ParabolicoAbajo
	
    jmp mainLoop
            
;============================================================================
HiloDibujar:	
	call ClearScreen
    call MoverCalle
			
	mov bx, [coordRY]
    mov ax, [coordRX]
    call Dibujarrex
	
	mov bx, [coordLLY]
    mov ax, [coordLLX]
    call Dibujarcalle    	
	xor bx,bx
	xor ax,ax	
	mov cx,6
	xor si,si
		
	;mov ax,obstaculos[si]
	;dec ax
	;dec ax
	;mov obstaculos[si],ax
	
DibObs:
	push cx
	
	cmp si,0
	jz Primero
	
	mov ax,movObstaculos[si]
	
	;push di
	mov di,si
	dec di
	dec di
	
	mov bx,movObstaculos[di]			
	sub bx,ax
	
	mov ax,si

Cactus2:
	cmp ax, 2
	jnz Cactus3
	
	cmp bx,160
	jb Seguir
	jmp Primero
Cactus3:
	cmp ax,4
	jnz Cactus4
	
	cmp bx,160
	jb Seguir
	jmp Primero

Cactus4:
	cmp ax,6
	jnz Cactus5
	
	cmp bx,250
	jb Seguir
	jmp Primero
	
Cactus5:
	cmp ax,8
	jnz Cactus6
	
	cmp bx,160
	jb Seguir
	jmp Primero
	
Cactus6:
	cmp ax,10
	jnz Seguir
	
	cmp bx,210
	jb Seguir
	jmp Primero
	
;Cactus7:
;	cmp ax,12
;	jnz Seguir
;	
;	cmp bx,300
;	jb Seguir
;	jmp Primero
	;pop di
	
Primero:	
	MoverCactus si
Seguir:	
	mov bx,movObstaculos[si]
	cmp bx,0
	jz fin
		
	mov bx,104
	mov ax,obstaculos[si]
    push si
	call Dibujarcactus			
	pop si
	
fin:
	inc si
	inc si
	pop cx
	dec cx
	cmp cx,0
	jnz near DibObs	
    ;----------------------
	
    call VSync
    call VSync

    mov cx,0000h        ; tiempo del delay
    mov dx,00fffh       ; tiempo del delay
    call Delay
	
	ret
;============================================================================
    ;bx= coordenada x
    ;ax= coordenada y
    ;cl= color
    
Dibujarrex:
    mov cx, bx 
    shl cx,8
    shl bx,6
   
    add bx,cx    ;bx=320      
    add ax,bx    ;sumar x
   
    mov di, ax          
    MDibujarRex rexFila1
   
    add ax,320
    MDibujarRex rexFila2  
    
    add ax,320
    MDibujarRex rexFila3
    
    add ax,320
    MDibujarRex rexFila4
    
    add ax,320
    MDibujarRex rexFila5
    
    add ax,320
    MDibujarRex rexFila6
    
    add ax,320
    MDibujarRex rexFila7
	
	add ax,320
    MDibujarRex rexFila8
	
	add ax,320
    MDibujarRex rexFila9
	
	add ax,320
    MDibujarRex rexFila10
		
	add ax,320
    MDibujarRex rexFila11
	
	add ax,320
    MDibujarRex rexFila12
	
	add ax,320
    MDibujarRex rexFila13
	
	add ax,320
    MDibujarRex rexFila14
	
	add ax,320
    MDibujarRex rexFila15
	
	add ax,320
    MDibujarRex rexFila16
	
	add ax,320
    MDibujarRex rexFila17
	
	add ax,320
    MDibujarRex rexFila18
	
	add ax,320
    MDibujarRex rexFila19
	
	add ax,320
    MDibujarRex rexFila20
	
	add ax,320
    MDibujarRex rexFila21
	
	add ax,320
    MDibujarRex rexFila22
    
    ret
	
;============================================================================
    ;bx= coordenada x
    ;ax= coordenada y
    ;cl= color
    
Dibujarcactus:
    mov cx, bx 
    shl cx,8
    shl bx,6
   
    add bx,cx    ;bx=320      
    add ax,bx    ;sumar x
   
    mov di, ax          
    MDibujarCactus cactusFila1
   
    add ax,320
    MDibujarCactus cactusFila2  
    
    add ax,320
    MDibujarCactus cactusFila3
    
    add ax,320
    MDibujarCactus cactusFila4
    
    add ax,320
    MDibujarCactus cactusFila5
    
    add ax,320
    MDibujarCactus cactusFila6
    
    add ax,320
    MDibujarCactus cactusFila7
	
	add ax,320
    MDibujarCactus cactusFila8
	
	add ax,320
    MDibujarCactus cactusFila9
	
	add ax,320
    MDibujarCactus cactusFila10
		
	add ax,320
    MDibujarCactus cactusFila11
	
	add ax,320
    MDibujarCactus cactusFila12
	
	add ax,320
    MDibujarCactus cactusFila13
	
	add ax,320
    MDibujarCactus cactusFila14
	
	add ax,320
    MDibujarCactus cactusFila15
	
	add ax,320
    MDibujarCactus cactusFila16
	
	add ax,320
    MDibujarCactus cactusFila17
	
	add ax,320
    MDibujarCactus cactusFila18
		    
    ret	
;============================================================================
    ;bx= coordenada x
    ;ax= coordenada y
    ;cl= color
    
Dibujarcalle:
    mov cx, bx 
    shl cx,8
    shl bx,6
   
    add bx,cx    ;bx=320      
    add ax,bx    ;sumar x
   
    mov di, ax          
    MDibujarCalle calleFila1
   
    add ax,320
    MDibujarCalle calleFila2  
    
    add ax,320
    MDibujarCalle calleFila3  
    ret	
	
;======================================================================
MoverCalle:
	mov ax, [coordLLX]
	cmp ax,0
	jnz ContinuarCalle	
	mov ax,12	
ContinuarCalle:			
	dec ax
	dec ax
	mov [coordLLX], ax	
	ret
;======================================================================
ClearScreen:
    mov ah,0
    mov al, 13h
    int 0x10
    ret
;======================================================================

    ; funcion HasKey
    ; hay una tecla presionada en espera?
    ; zf = 0 => Hay tecla esperando 
    ; zf = 1 => No hay tecla en espera     
    
HasKey:


    push ax            

    mov ah, 01h        ; funcion 1
    int 16h        ; interrupcion bios

    pop ax            

    ret                  

;======================================================================
    ; Esta funcion recibe un numero de 32 bits , pero en dos partes
    ; de 16 bits c/u cx y dx. CX en la parte alta y DX en la parte baja
    ; Esta funcion causa retardos de un micro segundo = 1/1 000 000


Delay:

    mov ah , 86h
    int 15h
    ret

;======================================================================
    ; funcion GetCh
    ; ascii tecla presionada
    ; Salida en al codigo ascii sin eco, via BIOS
GetCh:
    
    xor ah,ah        
    int 16h            
    ret            
             
;======================================================================

    ;wait for vsync ( retraso vertical ) 


VSync: 

    mov dx,03dah
    WaitNotVSync: ;wait to be out of vertical sync
    in al,dx
    and al,08h
    jnz WaitNotVSync
    WaitVSync: ;wait until vertical sync begins
    in al,dx
    and al,08h
    jz WaitVSync

    ret    
;======================================================================
section .data
    rexFila0  DB 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 
	rexFila1  DB 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 15, 15, 15, 15, 15, 15, 15, 15, 0
	rexFila2  DB 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 15, 15, 15, 15, 15, 15, 15, 15, 15, 15
	rexFila3  DB 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 15, 15, 0 , 15, 15, 15, 15, 15, 15, 15
	rexFila4  DB 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 15, 15, 15, 15, 15, 15, 15, 15, 15, 15
	rexFila5  DB 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 15, 15, 15, 15, 15, 15, 15, 15, 15, 15
	rexFila6  DB 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 15, 15, 15, 15, 15, 15, 15, 15, 15, 15
	rexFila7  DB 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 15, 15, 15, 15, 15, 0 , 0 , 0 , 0 , 0 
	rexFila8  DB 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 15, 15, 15, 15, 15, 15, 15, 15, 0 , 0
	rexFila9  DB 15, 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 15, 15, 15, 15, 15, 0 , 0 , 0 , 0 , 0 , 0
	rexFila10 DB 15, 0 , 0 , 0 , 0 , 0 , 0 , 0 , 15, 15, 15, 15, 15, 15, 0 , 0 , 0 , 0 , 0 , 0
	rexFila11 DB 15, 15, 0 , 0 , 0 , 0 , 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 0 , 0 , 0 , 0
	rexFila12 DB 15, 15, 15, 0 , 0 , 15, 15, 15, 15, 15, 15, 15, 15, 15, 0 , 15, 0 , 0 , 0 , 0
	rexFila13 DB 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 0 , 0 , 0 , 0 , 0 , 0 
	rexFila14 DB 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 0 , 0 , 0 , 0 , 0 , 0
	rexFila15 DB 0 , 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 0 , 0 , 0 , 0 , 0 , 0 , 0
	rexFila16 DB 0 , 0 , 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 0 , 0 , 0 , 0 , 0 , 0 , 0
	rexFila17 DB 0 , 0 , 0 , 15, 15, 15, 15, 15, 15, 15, 15, 15, 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0
	rexFila18 DB 0 , 0 , 0 , 0 , 15, 15, 15, 15, 15, 15, 15, 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 
	rexFila19 DB 0 , 0 , 0 , 0 , 0 , 15, 15, 15, 0 , 15, 15, 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0
	rexFila20 DB 0 , 0 , 0 , 0 , 0 , 15, 15, 0 , 0 , 0 , 15, 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0
	rexFila21 DB 0 , 0 , 0 , 0 , 0 , 15, 0 , 0 , 0 , 0 , 15, 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 
	rexFila22 DB 0 , 0 , 0 , 0 , 0 , 15, 15, 0 , 0 , 0 , 15, 15, 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 	
    
    coordRX DW 5        ; posicion X de la rex
    coordRY DW 100        ; posicion Y de la rex
    
;======================================================================
    cactusFila1  DB 0  , 0  , 0  , 0  , 0  , 15, 15 , 0  , 0 , 0   , 0   , 0 
    cactusFila2  DB 0  , 15 , 0  , 0  , 15 , 15, 15 , 15 , 0 , 0   , 0   , 0 
	cactusFila3  DB 15 , 15 , 15 , 0  , 15 , 15, 15 , 15 , 0 , 0   , 0   , 0 
	cactusFila4  DB 15 , 15 , 15 , 0  , 15 , 15, 15 , 15 , 0 , 0   , 0   , 0 	
	cactusFila5  DB 15 , 15 , 15 , 0  , 15 , 15, 15 , 15 , 0 , 0   , 0   , 0 
	cactusFila6  DB 15 , 15 , 15 , 0  , 15 , 15, 15 , 15 , 0 , 0   , 15  , 0 
	cactusFila7  DB 15 , 15 , 15 , 0  , 15 , 15, 15 , 15 , 0 , 15  , 15  , 15 
	cactusFila8  DB 15 , 15 , 15 , 15 , 15 , 15, 15 , 15 , 0 , 15  , 15  , 15 
	cactusFila9  DB 0  , 15 , 15 , 15 , 15 , 15, 15 , 15 , 0 , 15  , 15  , 15 
	cactusFila10 DB 0  , 0  , 15 , 15 , 15 , 15, 15 , 15 , 0 , 15  , 15  , 15 
	cactusFila11 DB 0  , 0  , 0  , 15 , 15 , 15, 15 , 15 , 0 , 15  , 15  , 15
	cactusFila12 DB 0  , 0  , 0  , 0  , 15 , 15, 15 , 15 , 15, 15  , 15  , 0	
	cactusFila13 DB 0  , 0  , 0  , 0  , 15 , 15, 15 , 15 , 15, 15  , 0   , 0	
	cactusFila14 DB 0  , 0  , 0  , 0  , 15 , 15, 15 , 15 , 15, 0   , 0   , 0	
	cactusFila15 DB 0  , 0  , 0  , 0  , 15 , 15, 15 , 15 , 0 , 0   , 0   , 0
	cactusFila16 DB 0  , 0  , 0  , 0  , 15 , 15, 15 , 15 , 0 , 0   , 0   , 0	
	cactusFila17 DB 0  , 0  , 0  , 0  , 15 , 15, 15 , 15 , 0 , 0   , 0   , 0	
	cactusFila18 DB 0  , 0  , 0  , 0  , 15 , 15, 15 , 15 , 0 , 0   , 0   , 0	
    
	obstaculos dw 7 dup(308)
	
	movObstaculos dw 0,0,0,0,0,0,0
	
;======================================================================
    calleFila1  DB 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 ,15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 ,15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 ,15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 ,15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 ,15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 ,15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 ,15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 ,15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 ,15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 ,15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 ,15 , 15 , 15 , 15 , 15 , 15, 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15
    calleFila2  DB 0  , 15 , 0  , 0  , 15 , 15 , 15 , 15 , 0  , 0  , 0  , 0  , 15 , 15 , 0  , 0  , 15 , 0  , 0  , 0 , 0  , 15 , 0  , 0  , 15 , 15 , 15 , 15 , 0  , 0  , 0  , 0  , 15 , 15 , 0  , 0  , 15 , 0  , 0  , 0  ,0  , 15 , 0  , 0  , 15 , 15 , 15 , 15 , 0  , 0  , 0  , 0  , 15 , 15 , 0  , 0  , 15 , 0  , 0  , 0  ,0  , 15 , 0  , 0  , 15 , 15 , 15 , 15 , 0  , 0  , 0  , 0  , 15 , 15 , 0  , 0  , 15 , 0  , 0  , 0  , 15 , 15 , 15 , 0  , 0  , 0  , 0  , 15 , 15 , 15 , 0  , 15 , 0  , 0  , 0  , 15 , 15 , 15 , 15 , 15 ,15 , 15 , 15 , 0  , 0  , 0  , 0  , 15 , 15 , 15 , 0  , 15 , 0  , 0  , 0  , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 0  , 0  , 0  , 0  , 15 , 15 , 15 , 0  , 15 , 0  , 0  , 0  , 15 , 15 , 15 , 15 , 15  ,15 , 15 , 15 , 0  , 0  , 0  , 0  , 15 , 15 , 15 , 0  , 15 , 0  , 0  , 0  , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 0  , 0  , 0  , 0  , 15 , 15 , 15 , 0  , 15 , 0  , 0  , 0  , 15 , 15 , 15 , 15 , 15  ,15 , 15 , 15 , 0  , 0  , 0  , 0  , 15 , 15 , 15 , 0  , 15 , 0  , 0  , 0  , 15 , 15 , 15 , 15 , 15 , 0  , 15 , 0  , 0  , 15 , 15 , 15 , 15 , 0  , 0  , 0  , 0  , 15 , 15 , 0  , 0  , 15 , 0  , 0  , 0 , 0  , 15 , 0  , 0  , 15 , 15, 0  , 15 , 0  , 0  , 15 , 15 , 15 , 15 , 0  , 0  , 0  , 0  , 15 , 15 , 0  , 0  , 15 , 0  , 0  , 0 , 0  , 15 , 0  , 0  , 15 , 15 , 15 , 15 , 15 , 0  , 0  , 0  , 0  , 15 , 15 , 15 , 0  , 15 , 0  , 0  , 0  , 15 , 15 , 15 , 15 , 15 ,15 , 15 , 15 , 0  , 0  , 0  , 15 , 15 , 15 , 0  , 0  , 0  , 0  , 15 , 15 , 15 , 0  , 15 , 0  , 0  , 0  , 15 , 15 , 15 , 15 , 15 ,15 , 15 , 15 , 0  , 0  , 0  , 0  , 15 , 0  , 0  , 15 , 15 , 15 , 15 , 0  , 0  , 0  , 0  , 15 , 15 , 0  , 0
	calleFila3  DB 15 , 15 , 15 , 0  , 0  , 0  , 0  , 15 , 15 , 15 , 0  , 15 , 0  , 0  , 0  , 15 , 15 , 15 , 15 , 15 ,15 , 15 , 15 , 0  , 0  , 0  , 0  , 15 , 15 , 15 , 0  , 15 , 0  , 0  , 0  , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 0  , 0  , 0  , 0  , 15 , 15 , 15 , 0  , 15 , 0  , 0  , 0  , 15 , 15 , 15 , 15 , 15  ,15 , 15 , 15 , 0  , 0  , 0  , 0  , 15 , 15 , 15 , 0  , 15 , 0  , 0  , 0  , 15 , 15 , 15 , 15 , 15 , 0  , 15 , 0  , 0  , 15 , 15 , 15 , 15 , 0  , 0  , 0  , 0  , 15 , 15 , 0  , 0  , 15 , 0  , 0  , 0 , 0  , 15 , 0  , 0  , 15 , 15 , 15 , 15 , 0  , 0  , 0  , 0  , 15 , 15 , 0  , 0  , 15 , 0  , 0  , 0  ,0  , 15 , 0  , 0  , 15 , 15 , 15 , 15 , 0  , 0  , 0  , 0  , 15 , 15 , 0  , 0  , 15 , 0  , 0  , 0  ,0  , 15 , 0  , 0  , 15 , 15 , 15 , 15 , 0  , 0  , 0  , 0  , 15 , 15 , 0  , 0  , 15 , 0  , 0  , 0  , 0 , 0 , 0 , 0  , 15  , 15 , 15 , 15 , 0 , 0 , 0  , 0 , 0  , 15  , 15 , 15 , 0 , 0 , 0 , 0 ,15 , 15 , 15 , 0  , 0  , 0  , 0  , 15 , 15 , 15 , 0  , 15 , 0  , 0  , 0  , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 15 , 0  , 0  , 0  , 0  , 15 , 15 , 15 , 0  , 15 , 0  , 0  , 0  , 15 , 15 , 15 , 15 , 15 ,15 , 15 , 15 , 0  , 0  , 0 ,15 , 15 , 15 , 0  , 0  , 0  , 0  , 15 , 15 , 15 , 0  , 15 , 0  , 0  , 0  , 15 , 15 , 15 , 15 , 15 ,15 , 15 , 15 , 0  , 0  , 0 ,  0  , 15 , 0  , 0  , 15 , 15 , 15 , 15 , 0  , 0  , 0  , 0  , 15 , 15 , 0  , 0  , 15 , 0  , 0  , 0 , 0  , 15 , 0  , 0  , 15 , 15  , 0  , 15 , 0  , 0  , 15 , 15 , 15 , 15 , 0  , 0  , 0  , 0  , 15 , 15 , 0  , 0  , 15 , 0  , 0  , 0 , 0  , 15 , 0  , 0  , 15 , 15, 15 , 15 , 15 , 0  , 0  , 0  , 0  , 15 , 15 , 15 , 0  , 15 , 0  , 0  , 0  , 15 , 15
	
	coordLLX DW 0        ; posicion X de la calle
	coordLLY DW 123      ; posicion Y de la calle
;======================================================================    
section .stack 1024h   
  stacktop: