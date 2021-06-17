close macro ;cierra el programa
	mov ah, 4ch ;Numero de funcion que finaliza el programa
	xor al,al
	int 21h
endm

getChar macro  ;obtiene el caracter
	mov ah,01h ; se guarda en al en codigo hexadecimal
	int 21h
endm
macroImprimir macro msj  
   mov ax, @data
	mov ds,ax
	mov ah,09h ;Numero de funcion para imprimir buffer en pantalla
	mov dx,offset msj ;equivalente a que lea dx,buffer,carga la dirección de la fuente (buffer) a dx 
	int 21h 
endm  

convertirCadenaANumero macro d,u, numero 
    mov ah,01h 									;Peticion un caracter
	int 21h
	sub al, 30h 								;convertirlo de hexa a decimal 
	mov d, al  							    ;Guarda las decenas en d

	mov ah,01h 									;Peticion segundo caracter
	int 21h
	sub al,30h									;convertirlo de hexa a decimal   
	mov u, al                                 ;guardar unidades 

    ;para convertir a un número de dos dígitos 
    ; 1. multiplico el dígito de las decenas x 10 o 0ah
    mov al,d                      ;copiamos a al, el valor de las decenas                            
	mov bl,0ah                      ;copiamos en bl el valor 10 , en hexa 0ah 
    ;en la multiplicación se indica la parte baja, y se multiplica la parte baja con la alta de b = bl * al             
	mul bl							;y el resultado de la multiplicación se queda en la parte alta, al 
	add al, u                     ;luego le sumo las unidades a al , y ya tenemos el número completo 
	mov numero, al                ;guardamos el número en la variable 
endm 

;***********************************************************************

;************************************************************************
