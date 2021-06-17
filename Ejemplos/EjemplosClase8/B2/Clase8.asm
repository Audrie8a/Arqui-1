; ************** LEER NUMEROS Y PASARLO A ENTERO **************
include macros.asm ;archivo con los macros a utilizar

.model small

;----------------SEGMENTO DE PILA---------------------

.stack

;----------------SEGMENTO DE DATO---------------------

.data
    cr          equ   0dh   ;Constantes
    lf          equ   0ah
    dolar       equ   '$'        
    msjEncabezado   db "**********************************************",cr,lf
                    db "Universidad de San Carlos de Guatemala",cr,lf
                    db "Facultad de Ingenieria",cr,lf
                    db "Arquitectura de ensambladores y computadores 1",cr,lf
                    db "Primer semestre 2021",cr,lf
                    db "Seccion B",cr,lf
                    db "Maria de Los Angeles Herrera",cr,lf
                    db "201504399",cr,lf
                    db "Primera Practica",cr,lf,dolar
    
    msjMenu         db "**********************************************",cr,lf
                    db "Bienvenido al Menu:",cr,lf
                    db "1) Cargar archivo                  ",cr,lf
                    db "2) Modo Calculadora                 ",cr,lf
                    db "3) Factorial        ",cr,lf
                    db "4) Salir             ",cr,lf
                    db " ",cr,lf   
                    db "Ingrese la opcion a realizar: ",cr,lf,dolar 
                    
    msjNum1         db "Ingrese primer numero:  ",cr,lf,dolar               
    msjNum2         db "Ingrese segundo numero: ",cr,lf,dolar  
    msjsigno        db "Ingrese operador aritmetico (signo): ",cr,lf,dolar 
    msjerror        db "error!",cr,lf,dolar
    nuevaLinea      db  lf, cr, dolar   ;Inicializar 3 posiciones de memoria

	varNum1         dw ? ;Variable de dos bytes, no inicializada
    varNum2         dw ? 
	make_minus      DB      ?       ; used as a flag.
	u db "$$$$$$$$"
	d db "$$$$$$$$"
	numero db "$$$$$$$$"
	u2 db "$$$$$$$$"
	d2 db "$$$$$$$$"
	numero2 db "$$$$$$$$"
	resultado db "$$$$$$$$"
	operador db "$$"
	varOperaciones db 1000 dup('$')
	mensajeres db 10,13,7,"EL TOTAL ES: $"
	imprimir db "$$$$$$$$"
	mensajepregunta db 10,13,7,"Desea realizar otra operacion? s/n $"
	cont            dw 0 ;contador auxiliar   
    cont2           dw 0,'$' ;contador auxiliar 

.code
	macroImprimir msjEncabezado
    macroImprimir nuevaLinea
mostrar_menu:
            
            macroImprimir msjMenu       
            ;Llamada a procedimiento para leer la opcion elegida, el resultado es almacenado en AL
            getChar                 
            cmp al,31h
            je opcion2  ; Pregunta si la tecla pulsada fue 1 y salta a la etiqueta opcion 1
            
            cmp al,32h
            je calculadora  ; Pregunta si la tecla pulsada fue 2 y salta a la etiqueta calculadora
            
            cmp al,33h
            je opcion3  ; Pregunta si la tecla pulsada fue 3 y salta a la etiqueta opcion 3
            
            cmp al,34h
            je salir            
            ;Si no se pulso alguna de las teclas validas, muestra un msj de error y regresa al menu      
            jmp mostrar_menu        ;Salto incondicional hacia la etiqueta mostrar_menu

calculadora: 
		macroImprimir nuevaLinea
		macroImprimir msjNum1 
		convertirCadenaANumero u, d, numero 				;pide el primer  numero y lo convierte a decimal 
		macroImprimir nuevaLinea
        macroImprimir msjsigno 
        mov ah,01h 									;Peticion un caracter
		int 21h     								
		mov operador, al  					    ;Guarda el operador 
		macroImprimir nuevaLinea
		macroImprimir msjNum2
		convertirCadenaANumero u2, d2, numero2 			;pide el segundo numero y lo convierte a decimal 

		cmp operador,2Bh  ;si es +
		je SumaDosNumeros

		cmp operador,2Ah ; si es *
		je MultDosNumeros

		cmp operador,2Fh ; si es /
		je DivDosNumeros

		cmp operador,2Dh ; si es -
		je RestaDosNumeros

		jmp mostrar_menu
		
		SumaDosNumeros:
			mov ah , numero
			mov al , numero2
			add al , ah  ;se guarda en el destino, ah  
			;mov al,numero						;resultado de la suma se guarda  en al
			;add al, numero2
			mov resultado, al
			   

			macroImprimir mensajeres					; Mensaje de resultado 
			macroImprimir nuevaLinea
			xor ax,ax
			mov al,resultado
			CALL ConversionNumeroACadena 
			macroImprimir nuevaLinea
			
		je mostrar_menu

opcion2: 

opcion3:

	MultDosNumeros:
		mov al,numero						;copiamos a al el primer numero 
		mov bl, numero2                     ;copiamos a al el segundo numero 
		mul bl                              ;multiplica al por  el destino(bl)
		mov resultado, al 					;el resultado lo guarda en al

		macroImprimir mensajeres					; Mensaje de resultado 
		macroImprimir nuevaLinea
		xor ax,ax
		mov al,resultado
		CALL ConversionNumeroACadena
	je mostrar_menu

	DivDosNumeros:
		mov al,numero						;copiamos a al el primer numero 
		mov bl, numero2                     ;copiamos a al el segundo numero 
		div bl                              ;divide al / bl(fuente)
		mov resultado, al                   ;el resultado se guarda en al 

		macroImprimir mensajeres					; Mensaje de resultado 
		macroImprimir nuevaLinea
		xor ax,ax
		mov al,resultado
		CALL ConversionNumeroACadena
	je mostrar_menu

	RestaDosNumeros:
		mov al,numero						;resultado de la multiplicación en al
		sub al, numero2
		mov resultado, al 

		macroImprimir mensajeres					; Mensaje de resultado 
		macroImprimir nuevaLinea
		xor ax,ax
		mov al,resultado
		CALL ConversionNumeroACadena
	je mostrar_menu
	
ConversionNumeroACadena proc 
    mov si,0 
    mov imprimir[si],64  ;le copio una @ a imprimir 
	inc si ;incremento el contador

    HacerDecimal:
	;divide lo que esta en al  dentro de dh 
	mov dh,0ah			 ;a al lo divide con dh , que tiene el valor de 10 
	idiv dh  			 ;dividir dos números con signo 
	;ah guarda residuo
	;al guarda el cociente
	mov imprimir[si],ah				 ;le copio el residuo						
	inc si                           ;aumento el contador
	mov ah, 0h						 ;le copio a ah 0
	cmp al, 0h						 ; comparo al con 0 
	jne HacerDecimal				 ;si no es igual a 0  
	je comprobar					 ;Si es igual a 0 el cociente, comprobar

	comprobar:
	mov dl,imprimir[si]   			;copiamos imprimir[si] a dl
	cmp dl,64						;comparo si es una @
	jne imprimirDecimal            ;sino es @ imprimirdecimal 

	imprimirDecimal:
	dec si							
	mov dl,imprimir[si]
	cmp dl,64
	je MensajeSalida
	add dl, 30h
	mov ah, 2h                   ;función para imprimir caracter
	int 21h
	jmp imprimirDecimal

	MensajeSalida:
	macroImprimir nuevaLinea
	ret 
ConversionNumeroACadena  endp

salir:
	close
end  