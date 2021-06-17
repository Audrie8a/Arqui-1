include macros2.asm
;================== DECLARACION EJECUTABLE ===================
.model small
.stack 100h
.data
;======================= SECCION DATOS =======================
velocidadmsg    db 0ah,0dh,'Ingrese una velocidad(0-9)',32,'$'
ordenaminetos   db 0ah,0dh,'1) Cargar Archivo', 0ah,0dh,'2) Ordenamiento Burbuja', 0ah,0dh,'3) Salir', 0ah,0dh,'$'
opcion          db 0ah,0dh,'Seleccione una opcion: ',32,'$'

ruta            db 'Entrada.txt', 00h
handleFichero   dw ?
bufferLectura   db 1000 dup('$')

arreglo         db 30 dup(0)
arregloInicial  db 30 dup(0)
arregloBurbuja  db 30 dup(0)

maximo          dw 0b
cantidad        db 0b
cantidad2       dw 0b
numero          db 20 dup('$')
arregloCad      db 60 dup('$')
resultado       db 20 dup('$')
;coma            db ',','$'
;entere          db 0ah,0dh,'$'

;medio           db 0b
;it              db 0b
;temp            db 0b
;jta             db 0b

;tamaMax         dw 0b
;tamaMin         dw 0b
;pivot           dw 0b
;valoractual     dw 0b

velocidad1      db 0b

numerosMos      db 60 dup('$')
tamanoX         dw 0
espacio         db 0b
espaciador      dw 0

espacio2        dw 0b
tiempo          dw 500
valor           db 20
max             db 0b

.code
;================== SECCION DE CODIGO ===========================
main proc 
	Menu:
			print ordenaminetos
			print opcion			
			getChar				
			cmp al,49
			je CARGAR
			cmp al,50
			je BUBBLE			
			cmp al,51
			je SALIR
			jmp Menu
		CARGAR:
            abrirA ruta,handleFichero
			leerA SIZEOF bufferLectura,bufferLectura,handleFichero
			cerrarA handleFichero 
			GuardarNumeros bufferLectura,cantidad,arreglo,numero
			copiarArreglo arreglo,arregloInicial
			DeterminarMayor
			copiarArreglo arregloInicial,arreglo                    ;aqui se regresa a como estaba
			jmp Menu      ;aqui se regresa a como estaba
;-------------------------------------------------------------------------			
		BUBBLE:
			print velocidadmsg
			getChar
			sub al,48
			mov velocidad1,al           ; VELOCIDAD DE ORDENAMIENTO
			Burbuja
			;copiarArreglo arreglo,arregloBurbuja
			copiarArreglo arregloInicial,arreglo
			jmp Menu
;-------------------------------------------------------------------------		
		SALIR:
      MOV ah,4ch 
			int 21h

	main endp
;================ FIN DE SECCION DE CODIGO ========================
end