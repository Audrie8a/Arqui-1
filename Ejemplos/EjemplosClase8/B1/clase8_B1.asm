include macros.asm ;archivo con los macros a utilizar

.model small

;----------------SEGMENTO DE PILA---------------------

.stack

;----------------SEGMENTO DE DATO---------------------

.data

numero db 2 dup('$')

salto db 0ah,0dh, '$' ,'$'
esco db 0ah,0dh, 'Elija una opcion:' , '$'
enc1 db 0ah,0dh, 'Texto a Entero' , 0ah,0dh, '1.) Ingresar contador' , 0ah,0dh, '2.) Mostrar conteo' , 0ah,0dh, '3.) Salir' , '$'
enc2 db 0ah,0dh, 'Ingrese un numero:' , '$'
enc3 db 0ah,0dh, 'Ciclo:' , '$'
enc4 db 0ah,0dh, 'Cantidad:' , '$'

contador db 0ah,0dh, '$' ,'$'
;----------------SEGMENTO DE CODIGO---------------------

.code
main proc


	MenuPrincipal:
		print salto
		print enc1
		print salto
		print esco
		getChar
		cmp al,31h
		je Registrar
		cmp al,32h
		je Mostrar
		cmp al,33h
		je Salir
		jmp MenuPrincipal


	Registrar:
		getChar
		print enc2
		limpiar numero, SIZEOF numero,24h
		obtenerTexto numero
		jmp MenuPrincipal


	Mostrar:
	 	print salto
	 	StringToInt numero
	 	limpiar numero, SIZEOF numero,24h 
	 	;al numero convertido
	 	
	 	mov contador,al
	 	
	 	push ax
	 	IntToString contador, numero
	 	print enc4
	 	print numero
	 	print salto
 		pop ax

		FuncionLoop:
		mov cx,ax

		Mientras:
			mov contador,cl
	 	
	 		push cx
	 		limpiar numero, SIZEOF numero,24h 
	 		pop cx

	 		IntToString contador, numero
	 		print enc3
	 		print numero
	 		print salto
			

			Loop Mientras  
			jmp MenuPrincipal

	Salir:
		close

main endp
end main	
