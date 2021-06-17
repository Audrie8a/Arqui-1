;===================SECCION DE MACROS========================
include macros3.asm

;===================DECLARACION TIPO DE EJECUTABLE===========
.model small
.stack 100h
.data
;====================SECCION DE ENCABEZADO===================
;CADENAS Y CONSTANTES
encab db 0ah,0dh, 'UNIVERSIDAD DE SAN CARLOS DE GUATEMALA', 0ah,0dh, 'FACULTAD DE INGENIERIA', 0ah,0dh, 'ESCUELA DE CIENCIAS Y SISTEMAS', 0ah,0dh, 'ARQUITECTURA DE COMPUTADORES Y ENSAMBLADORES 1', 0ah,0dh, 'SECCION: B', 0ah,0dh, 'PRIMER SEMESTRE 2021', 0ah,0dh, 'NOMBRE: ALDAIR ESTRADA GARCIA', 0ah,0dh, 'CARNET: 201503855', 0ah,0dh, 'PRIMERA PRACTICA ASSEMBLER', 0ah,0dh, '$'
marco db 0ah,0dh, '%%%%%%%%%%%%%% MENU PRINCIPAL %%%%%%%%%%%%%%' ,0ah,0dh, '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%' ,0ah,0dh, '$'
marco2 db  '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%' ,0ah,0dh, '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%' ,0ah,0dh, '$'
encab2 db '%%%% 1) Cargar Archivo                  %%%%', 0ah,0dh, '%%%% 2) Modo Calculadora                %%%%' ,0ah,0dh, '%%%% 3) Factorial                       %%%%' ,0ah,0dh, '%%%% 4) Crear Reporte                   %%%%' ,0ah,0dh, '%%%% 5) Salir                           %%%%' ,0ah,0dh, '$'

marcocal db 0ah,0dh, '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%' ,0ah,0dh, '%%%%%%%%%%%%% MODO CALCULADORA %%%%%%%%%%%%%' ,0ah,0dh, '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%' ,0ah,0dh, '$'
marcocal2 db '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%' ,0ah,0dh, '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%' ,0ah,0dh, '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%' ,0ah,0dh, '$'
marcofactorial db 0ah,0dh, '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%' ,0ah,0dh, '%%%%%%%%%%%%%%%% FACTORIAL %%%%%%%%%%%%%%%%' ,0ah,0dh, '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%' ,0ah,0dh, '$'
marcofactorial2 db  0ah,0dh, '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%' ,0ah,0dh, '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%' ,0ah,0dh, '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%' ,0ah,0dh, '$'
pedirnumero db 0ah, 0dh, 'Ingrese un numero	: ', '$'
pediroperador db 0ah, 0dh, 'Ingrese un operador	: ', '$'
pediroperador2 db 0ah, 0dh, 'Ingrese Un Operador o ; para finalizar: ', '$'
resfactorial db 0ah,0dh, 'Resultado:' , '$'
msgsuma db 0ah, 0dh, 'La Suma es : ', '$'
msgresta db 0ah, 0dh, 'La Resta es : ', '$'
msgmultiplicacion db 0ah, 0dh, 'La Multiplicacion es : ', '$'
msgdivision db 0ah, 0dh, 'La Division es : ', '$'
msgfactorial1 db 0ah,0dh, 'Operaciones: ' , '$'
msgfactorial2 db '!=' , '$'
msgfactorial3 db '; ' , '$'
factorial0 db '0!=1; ' , '$'
factorialX db '*' , '$'
factorialigual db '=' , '$'
nombre db 0ah, 0dh, 'Nombre del archivo: ', '$'

;variables
debug db 0ah, 0dh, 'Aqui Estoy ', '$'
contador db 0ah,0dh, '$' ,'$'
contadoraux db 0ah,0dh, '$' ,'$'		;guarda el numero que sera el factorial
contadorfactorial db 0ah,0dh, '$' ,'$'	;conteo de factorial que va incrementando
contadornew db 0ah,0dh, '$' ,'$'

conteo1 db 0ah,0dh, '$' ,'$'
conteo2 db 0
conteo3 db 1	
conteo4 db 1

;entradas
temp db 0 ; variable temporal contador
temp2 db 0 ; variable temporal contador
numero db 3 dup('$')
numero2 db 3 dup('$')
numerofactorial db 1 dup('$')	;string




var db 0, '$'
var2 db 0, '$'
num1 db 0ah,0dh, '$' ,'$'
num2 db 0ah,0dh, '$' ,'$'
anteriorfactorial db 0ah,0dh, '$' ,'$'
actualfactorial db 0ah,0dh, '$' ,'$'
numfactorial db 0ah,0dh, '$' ,'$'	;entero
auxfactorial db 0ah,0dh, '$' ,'$'	;regresa el string
resultado db 0ah,0dh, '$' ,'$'
resultadofactorial db 0ah,0dh, '$' ,'$'
resultadofactorial2 db 0ah,0dh, '$' ,'$'
number db 0ah,0dh, '$' ,'$'
negativo1 db 0
negativo2 db 0
negativoflag db 0
negativoflag2 db 0
operador db "$$"

salto db 0ah,0dh, '$' ,'$'
opc db 0ah, 0dh, 'Opcion: ', '$'
ing db 0ah,0dh, 'Ingrese una ruta de archivo' , 0ah,0dh, 'Ejemplo: entrada.txt' , '$'
;errores
err1 db 0ah,0dh, 'Error al abrir el archivo puede que no exista' , '$'
err2 db 0ah,0dh, 'Error al cerrar el archivo' , '$'
err3 db 0ah,0dh, 'Error al escribir en el archivo' , '$'
err4 db 0ah,0dh, 'Error al crear en el archivo' , '$'
err5 db 0ah,0dh, 'Error al leer en el archivo' , '$'

enc2 db 0ah,0dh, '1.) Mostrar informacion' , 0ah,0dh, '2.) Cerrar archivo' , '$'

;archivos
bufferEntrada db 50 dup('$')
handlerEntrada dw ?
bufferInformacion db 800 dup('$')

;reporte
contadorreporte db 1
reporteauxiliar db 0
bufferReporte db 200 dup('$')
namereporte db 'ReporteCalcu.html','$'
html db 0ah, 0dh, '<html>',  00h
head db 0ah, 0dh, '<head>',0ah, 0dh,'<title>REPORTE</title>',0ah, 0dh,'<style type=',34,'text/css',34,'>',0ah, 0dh,'.negro{background-color: #000;color: #fff}',0ah, 0dh,'.blanco{background-color: #fff;color: #000}',0ah, 0dh,'</style>',0ah, 0dh,'</head>',0ah, 0dh, 00h
body db '<body style=',34,'background-color: #6D9FF6',34,'>', 00h
titulo db 0ah, 0dh, '<h1 align=',34,'center',34,'>Practica 3 Arqui 1 Seccion B</h1>', 00h
estudiante db 0ah, 0dh, '<h1 align=',34,'center',34,'>Estudiante: Aldair Estrada García</h1>', 00h
carnet db 0ah, 0dh, '<h1 align=',34,'center',34,'>Carnet: 201503855</h1>', 00h
fecha db 0ah, 0dh, '<h1 align=',34,'center',34,'>Fecha: </h1>', 00h
fecha2 db 0ah, 0dh, '<h1 align=',34,'center',34,'>26/03/2021</h1>', 00h
parte1 db 0ah, 0dh, '<h1 align=',34,'center',34,'>'
partem db ':'
parte2 db '</h1>', 00h
id db 'Id Operacion'
roperacion db 'Operacion'
rresultado db 'Resultado'
hora db 0ah, 0dh, '<h1 align=',34,'center',34,'>Hora: </h1>', 00h
table db 0ah, 0dh, '<table border=',34,'1',34,' style=',34,'height: 100px; width: 400px',34,'align=',34,'center',34,'>',  00h
tbody db 0ah, 0dh, '<tbody>', 00h
tr db 0ah, 0dh, '<tr style=',34,'min-height: 0.125%; min-width: 0.125%',34,' align=',34,'center',34,'>', 00h
tdb db 0ah, 0dh, '<td class=',34,'blanco',34,'>', 00h
tdn db 0ah, 0dh, '<td class=',34,'negro',34,'>', 00h
ctd db '</td>', 00h
ctr db 0ah, 0dh, '</tr>', 00h
ctbody db 0ah, 0dh, '</tbody>', 00h
ctable db 0ah, 0dh, '</table>', 00h
p db 0ah, 0dh, '<p align=',34,'center',34,'><b>'
cp db '   19/03/2019 </b></p>'
cbody db '</body>', 00h
chtml db 0ah, 0dh, '</html>',  00h
signomas db '+'
signomenos db '-'
signodividir db '/'
signomultiplicar db '*'

;hora
mhora db 2 dup(0), 0
mmin db 2 dup(0), 0
mseg db 2 dup(0), 0
aux1 db 0 ;auxiliar de numero
;======================SECCION DE CODIGO=======================
.code ; segemento de codigo
	main proc
		print encab
		Menu:
			
			print marco
			print encab2
			print marco2
			print opc
			getChar
			cmp al,49
			je AbrirArchivo
			cmp al,50
			je Modo_Calculadora
			cmp al,51
			je Factorial
			cmp al,52
			je Crear_Reporte
			cmp al,53
			je Salir
			jmp Menu
		AbrirArchivo:
			print salto
			print ing
			print salto
			limpiar bufferentrada, SIZEOF bufferentrada,24h
			obtenerRuta bufferentrada
			abrir bufferentrada,handlerentrada
			limpiar bufferInformacion, SIZEOF bufferInformacion,24h
			leer handlerentrada, bufferInformacion, SIZEOF bufferInformacion		
		AbrirArchivo2:	
			print salto
			print enc2
			print salto
			print opc
			getChar
			cmp al,31h
			je MostrarInformacion
			cmp al,32h
			je CerrarArchivo
			jmp AbrirArchivo
		MostrarInformacion:
			print salto
			print bufferInformacion
			print salto
			getChar
			jmp AbrirArchivo2
		CerrarArchivo:
			cerrar handlerentrada
			jmp Menu

		Modo_Calculadora:
			;crea el archivo
			print nombre
			limpiar bufferentrada, SIZEOF bufferentrada,24h
			obtenerRuta bufferentrada
			crear bufferentrada, handlerentrada
			ObtenerHora
			escribir handlerEntrada, html, SIZEOF html
			escribir handlerEntrada, head, SIZEOF head
			escribir handlerEntrada, body, SIZEOF body
			escribir handlerEntrada, titulo, SIZEOF titulo
			escribir handlerEntrada, estudiante, SIZEOF estudiante
			escribir handlerEntrada, carnet, SIZEOF carnet
			escribir handlerEntrada, fecha, SIZEOF fecha
			escribir handlerEntrada, fecha2, SIZEOF fecha2
			escribir handlerEntrada, hora, SIZEOF hora
			escribir handlerentrada, parte1, SIZEOF parte1
			escribir handlerEntrada, mhora, SIZEOF mhora
			escribir handlerentrada, partem, SIZEOF partem
			escribir handlerEntrada, mmin, SIZEOF mmin
			escribir handlerentrada, partem, SIZEOF partem
			escribir handlerEntrada, mseg, SIZEOF mseg
			escribir handlerentrada, parte2, SIZEOF parte2
			escribir handlerEntrada, table, SIZEOF table
			escribir handlerEntrada, tbody, SIZEOF tbody

			escribir handlerEntrada, tr, SIZEOF tr

			escribir handlerEntrada, tdb, SIZEOF tdb
			escribir handlerEntrada, id, SIZEOF id
			escribir handlerEntrada, ctd, SIZEOF ctd
			
			escribir handlerEntrada, tdb, SIZEOF tdb
			escribir handlerEntrada, roperacion, SIZEOF roperacion
			escribir handlerEntrada, ctd, SIZEOF ctd

			escribir handlerEntrada, tdb, SIZEOF tdb
			escribir handlerEntrada, rresultado, SIZEOF rresultado
			escribir handlerEntrada, ctd, SIZEOF ctd

			escribir handlerEntrada, ctr, SIZEOF ctr

			print marcocal
			Numeros:
				print pedirnumero
				limpiar numero, SIZEOF numero,24h
				obtenerTexto numero
				

		 		StringToInt numero
		 		mov reporteauxiliar,al
		 		mov num1,al
		 		;primer numero ============================================================
		 		escribir handlerEntrada, tr, SIZEOF tr
				escribir handlerEntrada, tdb, SIZEOF tdb			
				add contadorreporte, 48							
				escribir handlerEntrada, contadorreporte, SIZEOF contadorreporte
				inc contadorreporte
				escribir handlerEntrada, ctd, SIZEOF ctd
				escribir handlerEntrada, tdb, SIZEOF tdb
				
				add reporteauxiliar, 48
				escribir handlerEntrada, reporteauxiliar, SIZEOF reporteauxiliar
				mov reporteauxiliar,0
				;==========================================================================
		 		limpiar numero, SIZEOF numero,24h 
		 		;al numero convertido
		 		;23d = al
				jmp OpcionOperador
				
			
			OpcionOperador:
				print pediroperador2
				getChar
				mov operador,al
				cmp operador,3Bh ;si es ;
				je FinOperacion
				cmp operador,2Bh ;si es +
				je Suma
				cmp operador,2Dh ; si es -
				je Resta
				cmp operador,2Ah ; si es *
				je Multiplicacion
				cmp operador,2Fh ; si es /
				je Division

				jmp OpcionOperador
			Suma:
				escribir handlerEntrada, signomas, SIZEOF signomas
				SumarNumeros num1
				jmp OpcionOperador
			Resta:
				escribir handlerEntrada, signomenos, SIZEOF signomenos
				RestarNumeros num1
				jmp OpcionOperador
			Multiplicacion:
				escribir handlerEntrada, signomultiplicar, SIZEOF signomultiplicar
				MultiplicarNumeros num1
				jmp OpcionOperador
			Division:
				escribir handlerEntrada, signodividir, SIZEOF signodividir
				DividirNumeros num1
				jmp OpcionOperador
			FinOperacion:
				escribir handlerEntrada, ctd, SIZEOF ctd

				escribir handlerEntrada, tdb, SIZEOF tdb			
				add contadorreporte, 48							
				escribir handlerEntrada, resultado, SIZEOF resultado
				;inc contadorreporte
				escribir handlerEntrada, ctd, SIZEOF ctd

				escribir handlerEntrada, ctr, SIZEOF ctr
				;print resultado
				;escribir handlerEntrada, resultado, SIZEOF resultado
				;escribir handlerEntrada, ctd, SIZEOF ctd
				limpiar resultado, SIZEOF resultado,24h
				jmp Menu
		Factorial:
			print marcofactorial
			print pedirnumero
			limpiar numerofactorial, SIZEOF numerofactorial,24h
			obtenerTexto numerofactorial

	 		StringToInt numerofactorial
	 		
	 		mov numfactorial,al
	 		limpiar numerofactorial, SIZEOF numerofactorial,24h

	 		FactorialNumero numfactorial
			
		 	
		 	print marcofactorial2
			getChar
		
			jmp Menu
		Crear_Reporte:
			;print nombre
			;limpiar bufferentrada, SIZEOF bufferentrada,24h
			;obtenerRuta bufferentrada
			;crear obtenerRuta, handlerentrada
			


			
			
			
			

			
			escribir handlerEntrada, ctbody, SIZEOF ctbody
			escribir handlerEntrada, ctable, SIZEOF ctable

			cerrar handlerentrada


			
			getChar
			jmp Menu

		Error1:
			print salto
			print err1
			getChar
			jmp Menu

		Error2:
			print salto
			print err2
			getChar
			jmp Menu
		
		Error3:
			print salto
			print err3
			getChar
			jmp Menu
		
		Error4:
			print salto
			print err4
			getChar
			jmp Menu

		Error5:
			print salto
			print err5
			getChar
			jmp Menu

		Salir:
			close
	main endp
end main