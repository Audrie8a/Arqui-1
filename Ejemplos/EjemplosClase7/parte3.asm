;menú para ingresar texto, mostrar texto y un ciclo 
include macros.asm 
.model small 
; -------------- SEGMENTO DE PILA -----------------
.stack 
; -------------- SEGMENTO DE DATOS -----------------
.data 
arreglo db 15 dup('$'), '$'
cadena db 0ah,0dh, 'Escoja una opcion:' , '$'
cadena2 db 0ah,0dh, '1.) Ingresar texto:' , '$'
cadena3 db 0ah,0dh, '2.) Mostrar texto guardado' , '$'
cadena6 db 0ah,0dh, '3.) Salir' , '$'
cadena7 db 0ah,0dh, '4.) Loop' , 10,'$'
mensaje db 0ah,0dh, 'En ciclo' , '$'
saltolinea db 10,'$'
mensaje2 db 10,'El texto es: ','$' 


;----------------SEGMENTO DE CODIGO---------------------

.code
main proc	
	menu:
		print cadena
		print cadena2
		print cadena3
		print cadena6
		print cadena7
		getChar
        ;cmp para comparar 
		cmp al,49 ;mnemonio 31h = 1 en hexadecimal, ascii 49
		je opcion1
		cmp al,50 ;mnemonio 32h = 2 en hexadecimal, ascii 50
		je opcion2
		cmp al,51 ;mnemonio 33h = 3 en hexadecimal, ascii 51
		je salir
		cmp al,52 ;mnemonio 34h = 4 en hexadecimal, ascii 52
		je FuncionLoop
		jmp menu

	opcion1:
        print saltolinea
		ObtenerTexto arreglo       
		jmp menu

	opcion2:
		print mensaje2
		print arreglo
		getChar
		jmp menu

	FuncionLoop:
		mov cx,5 ;siemre en el uso de loop, cx, lleva el contador de las veces que se va a repetir el loop 

		Mientras:
			print mensaje ;imprime el mensaje 
			Loop Mientras ;lo lleva a la etiqueta mientras pero decrementa cx 
			jmp menu ; y cuando cx ya es 0 , avanza y ejecuta este jmp 
	salir:
		close
main endp
end main