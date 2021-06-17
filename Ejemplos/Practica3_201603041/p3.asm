include macroP3.asm 

imprimirCaracter macro char
    PUSH AX;agregamos a pila ax
	MOV AL, char;movemos a al el caracter entrante
	MOV AH, 0Eh;funcion de salida teletipo
    INT 10h; interrupcion con funcion VGA
    POP AX;sacamos de pila ax
endm 

.model small 

;==============Segmento de Pila===============
.stack  

;==============Segmento de Datos==============
.data
;========================= Menu Principal ======================
menu1 db 13,10,10,'UNIVERSIDAD DE SAN CARLOS DE GUATEMALA',
		13,10,'FACULTAD DE INGENIERIA',
		13,10,'ESCUELA DE CIENCIAS Y SISTEMAS',
		13,10,'ARQUITECTURA DE COMPUTADORES Y ENSAMBLADORES 1 B',
		13,10,'SECCION B',
		13,10,'PRIMER SEMESTRE 2021',
		13,10,'JUAN DE DIOS DE PAZ ROMERO',
		13,10,'201603041',
		13,10,'Primera Practica assembler','$'

;========================= Menu Auxiliar ======================
menuenc db 13,10,10,'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%',
		13,10,'%%%%%%%%% MENU PRINCIPAL %%%%%%%%%',
		13,10,'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%',
		13,10,'%% 1. Cargar Archivo           %%',
		13,10,'%% 2. Modo Calculadora         %%',
		13,10,'%% 3. Factorial                %%',
		13,10,'%% 4. Crear Reporte            %%',
		13,10,'%% 5. Salir                    %%',
		13,10,'%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%','$'

enc_calculadora db  13,10,10,"%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%",
				    13,10,"%%%%%%%% MODO CALDULADORA %%%%%%%%",
				    13,10,"%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%", "$"

enc_factorial db    13,10,10,"%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%",
				    13,10,"%%%%%%%%% MODO FACTORIAL %%%%%%%%%",
				    13,10,"%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%", "$"

enc_reporte db    	13,10,10,"%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%",
				    13,10,"%%%%%%%%% MODO REPORTE  %%%%%%%%%",
				    13,10,"%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%", "$"

enc_carga db    	13,10,10,"%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%",
				    13,10,"%%%%%%%%%   MODO CARGA   %%%%%%%%%",
				    13,10,"%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%", "$"


ops	db 10,13,'1. Cargar Archivo',10,13,'2. Consola',10,13,'3. Salir','$'
ingreseOP db 10,13,'Ingrese una opcion: ','$'


;========================= Cargar ======================
menCargar0 db 10,13,10,13,10,13,"=================== CARGAR ARCHIVO ==================",'$' 
menCargar1 db 10,13,'INGRESE RUTA: ','$'
menCargar2 db 10,13,'Archivo le',161,'do con ',130,'xito!','$'


;========================= Consola ======================
menConsola db 10,13,10,13,"=================== CONSOLA ==================",10,13,">> ",'$' 
comando db 20 dup('$') 
showexit db "EXIT",'$','$','$','$','$','$','$','$','$','$','$','$','$','$','$','$'
noCargado db 10,13,'NO se ha cargado ningun archivo!!','$'
resConsol db 10,13,'Resultado ','$'
msjCreado db 10,13,'Archivo creado exitosamente','$'

;========================= Factoriales ======================
fact0 db  20h,'0!=1','$'
fact1 db  20h,'1!=1','$'
fact2 db  20h,'2!=1*2=2','$'
fact3 db  20h,'3!=1*2*3=6','$'
fact4 db  20h,'4!=1*2*3*4=24','$'


;========================= Reporte ======================
direccion db 30 dup('$')
bufferPadre db 20 dup('$')

report    db "Rep.html",0
nombreArchivo db 'Reporte$'

reporte1 db 10,9,'"',"REPORTE",'"',':',10,9,9,'"',"ALUMNO",'"',':',10,9,9,'{',10,9,9,9,'"'
;reporte1 db '{',10,9,'"',"REPORTE",'"',':',10,9,'{',10,9,9,'"',"ALUMNO",'"',':',10,9,9,'{',10,9,9,9,'"'
reporte2 db "Nombre",'"',':','"',"Juan de Dios de Paz Romero",'"',',',10,9,9,9,'"'
reporte3 db "Carnet",'"',':',"201603041",',',10,9,9,9,'"',"Seccion",'"',':','"',"A",'"'
reporte4 db ',',10,9,9,9,'"',"Curso",'"',':','"',"Arquitectura de Computadores y Ensambladores 1",'"',10,9,9,'}',','
reporte5 db 10,9,9,'"',"FECHA",'"',':',10,9,9,'{',10,9,9,9,'"'
reporte6 db "Dia",'"',':',32,32,',',10,9,9,9,'"',"Mes",'"',':',32,32,',',10,9,9,9,'"',"A",'ñ',"o",'"',':',32,32,32,32,10,9,9,'}',','
reporte7 db 10,9,9,'"',"HORA",'"',':',10,9,9,'{',10,9,9,9,'"'
reporte8 db "Hora",'"',':',32,32,',',10,9,9,9,'"',"Minutos",'"',':',32,32,',',10,9,9,9,'"',"Segundos",'"',':',32,32,10,9,9,'}',','
reporte9 db 10,9,9,'"',"RESULTADOS",'"',':',10,9,9,'{'
reporte11 db ',',10,9,9,9,'"',"Mayor",'"',':' 
reporte12 db ',',10,9,9,9,'"',"Menor",'"',':' 
reporte13 db 10,9,9,'},'
reporte141 db 10,9,9,'"'
reporte142 db '"',':',10,9,9,'['
abreOP db 10,9,9,9,'{'
cierreOP db 10,9,9,9,'},'
cierreOP2 db 10,9,9,9,'}'
linea db 10,9,9,9,9,'"'
comilla db '"'
reporte15 db 10,9,9,'}' 
mostrarnum db 32h,32h,32h,32h,32h,32h,10,13,'$'  
mostrarcadena db 20 dup('$') 
msjFac db 10,13,"Ingrese Factorial: $"

temp dw 0000h 
temp1 dw 0000h 
buff1 db '$','$'

;========================= tempral ======================
texto1 db 13,10,'Texto prueba!!',13,10,'$'

;========================= Errores ======================
err1 db 13,10,'OPCION INVALIDA, PRUEBA DE NUEVO!!',13,10,'$'
err2 db 13,10,'Error al abrir el archivo',10,13,'$'
err3 db 13,10,'Error al leer el archivo',10,13,'$' 
err4 db 13,10,'Error al crear el archivo',10,13,'$'
err5 db 13,10,'Error al escribir en el archivo',10,13,'$' 
err7 db 13,10,'Error al cerrar el archivo',10,13,'$' 
err8 db 13,10,'Numero fuera del rango','$'
err9 db 10,13,'Comando no reconocido','$' 
err10 db 10,13,'Operador Invalido','$' 
err11 db 13,10,'Comprueba path de archivo',10,13,'$' 
;errores en el analisis de json 
lexerror db "Error Lexico, simbolo desconocido: ",'$' 
lexdesc db 32,'$'  
sinerror db "Error Sintactico, simbolo recibido: ",'$'
sinerror2 db 10,13,"simbolo esperado: ",'$' 
sindesc db 32,'$'

;===================== Mostrar =====================

mayorque dw 0fc19h 
menorque dw 3e7h  
moda dw 0000h 
contOp dw 0000h 
total dw 0000h 


showmayor db "SHOW MAYOR",'$','$','$','$','$','$','$','$','$','$'
resMayor db 10,13,"Estadistico mayor: ",'$'
showmenor db "SHOW MENOR",'$','$','$','$','$','$','$','$','$','$'
resMenor db 10,13,"Estadistico menor: ",'$'

bandera dw 30h
diez dw 10

;========================= Variables ======================
bufferentrada db 999 dup('$')  	;Guarda la ruta de nuestro archivo  
handlerentrada dw ?			   	;Guarda el numero de archivo abierto 
bufferInformacion db 9999 dup('$');Guarda la informacion contenida en el archivo de entrada

lex db 8999 dup('$')			; guarda la tabla de tokens 
iSintactico dw 0000h			; guarda la posicion de la tabla analizada 
iLexico dw 0000h 				; guarda la posicion en el buffer de informacion donde vamos  
datos db 99 dup(20 dup('$')) 	; guarda el nombre de todos los id's

identi db 99 dup(20 dup('$'))  	; guarda los nombres de los identificadores 
iidenti dw 0000h  

tablaNum db 2000 dup(00h) 		; guarda los numeros encontrados 
tablaRes db 198 dup(00h)		; guarda los resultados de los id's 
pila db 2000 dup(00h)
ipila dw 0000h 
ipdatos db 00h 					; guarda la posicion en el char 
idatos dw 0000h 				; guarda la posicion en la tabla datos
pdatos db 30h 					; guarda si es el primer caracter  
inum dw 0000h 					; guarda la posicion del numero 
nnum db 30h 					; bandera por si es negativo 
pnum db 30h 					; bandera por si es el primero 
ires db 00h						; guarda la posicion del resultado homologa a idatos 

saltoL db 10,13,'$'				; salto de linea para consola DOSBox
debuguer db 10,13,">> Lleganding <<",10,13,'$'
soloID db 20 dup('$')
cargado db 0

ordenado dw 50 dup('$')
auxOrden dw 50 dup('$')
msjNum db 0Ah,0dh,"Ingrese Numero: $"


;-----------------Variables para almacenar -----------------
num1 dw ?
num2 dw ?
unidades db 0
decenas db 0
numeroAux db 0

ans dw ?
op db '?'
msjResultado db 0Ah,0Dh, "Resultado = ", "$"
msjContinuar db 0Ah,0dh,"Desea ingresar otra operacion? Si=s/No=;","$"
aprox db " Aprox  $"
msjop db 0Ah,0dh,"Ingrese Operador : ","$"

;==============Texto para Reporte=============

doctype   db "<!DOCTYPE html>",10
htmlInit  db "<html>",10
headInit  db "<head>",10
headEnd   db "</head>",10
bodyInit  db "<body>",10
h1dtInit  db "<h1>",10 
h1dtEnd   db "</h1>",10 
bodyEnd   db "</body>",10
htmlEnd   db "</html>",10
date      db "dd/mm/2020  "
time      db "00:00:00"

nametext  db "<h1>Juan de Dios de Paz Romero </h1>",10
idtext    db "<h1>201603041 </h1>",10


;==============Segmento de Codigo=============
.code
main proc
	mov dx, @data 
    mov ds,dx

	menuPrincipal:
		print menu1
		print saltoL
		print menuenc
		;print ops
		print saltoL
		print ingreseOP
		getChar 
		cmp aL,	31h 		; comparamos el registro contra el 1 en hexa
		je cargarArchivo	; Si son iguales se activa la bandera equals 
		cmp aL, 32h
		je calculadora ; Si no se cumple je opcion1 verifica si es opcion2 
		cmp aL,33h
		je factorial		; si son iguales entra a factorial
		cmp aL,34h
		je genReporte
		cmp aL,35h
		je salir  ; si no se cumple je opcion1 y opcion2 se verifica salir 
		jmp Error1 ; Como no hay valor regreso a pedir un numero
		
	cargarArchivo: 
		mov cargado,0
	;Apartado de limpieza 
		limpiar identi,SIZEOF identi, 24h
		limpiar bufferPadre, SIZEOF bufferPadre, 24h
		limpiar direccion, SIZEOF direccion, 24h
		limpiar lex,SIZEOF lex,24h
		limpiar datos,SIZEOF datos,24h	
		limpiar tablaNum,SIZEOF tablaNum,00h 
		limpiar tablaRes,SIZEOF tablaRes,00h
		limpiar pila,SIZEOF pila,00h 
		mov ax,0000h
		mov iidenti,ax 
		mov total,ax 
		mov contOp,ax  
		mov iSintactico,ax
		mov iLexico,ax 	
		mov idatos,ax 
		mov ipdatos,al 
		mov ires,al 
		mov inum,ax 
		mov temp,ax 
		mov temp1,ax 
		mov ipila,ax 
		mov al,30h 
		mov pdatos,al 
		mov pnum,al
		mov nnum,al 
		mov ax,0fc19h 
		mov mayorque,ax 
		mov ax,3e7h 
		mov menorque,ax 
		limpiar bufferentrada,SIZEOF bufferentrada, 24h 
		limpiar handlerentrada,SIZEOF handlerentrada,24h 
		limpiar bufferInformacion,SIZEOF bufferInformacion, 24h 
		; Fin limpieza

		print menCargar0
		print menCargar1
		obtenerRuta bufferentrada
		abrir bufferentrada,handlerentrada
		leer handlerentrada,bufferInformacion,SIZEOF bufferInformacion
		exit handlerentrada	
		jmp analisisLexico
	retorno: 
		jmp analisisSintactico 
	retorno2: 			
		;fin de metodos de resultado 
		verDatos datos,0,bufferPadre
		mov cargado,1
		print menCargar2
		getChar
		jmp menuPrincipal 
	
	consola:
		mov al,cargado
		cmp al,1
		jne errConsola
		
		limpiar comando,SIZEOF comando, 24h
		limpiar soloID,SIZEOF soloID, 24h
		limpiar mostrarcadena, SIZEOF mostrarcadena, 24h
		limpiar buff1, SIZEOF buff1, 24h
		xor ax,ax 
		mov bandera,ax 
		mov iidenti,ax
		mov ires,al
		
		print menConsola 
		obtenerComando comando
		
		cmpCad showexit,comando,bandera 
		cmp bandera,0031h 
		je menuPrincipal

		cmpCad showmayor,comando,bandera 
		cmp bandera,0031h 
		je verMayor 

		cmpCad showmenor,comando,bandera 
		cmp bandera,0031h 
		je verMenor

		showPadre datos, bufferPadre, comando, bandera
		cmp bandera,0031h
		je aReporte

		findID comando, soloID, identi, iidenti, mostrarcadena, ires, bandera
		cmp bandera,0031h ;TRUE el id del comando existe y el numero de iteraciones esta en cx
		je verID

		print err9
		getChar
		jmp consola

	errConsola:
		print saltoL
		print noCargado
		getChar
		jmp menuPrincipal
		
	verID:
		print resConsol
		print soloID
		mov buff1[0],':'
		print buff1
		mov buff1[0],' '
		print buff1

		xor bx,bx
		mov bl,ires
		mov al,tablaRes[bx]
		mov ah,tablaRes[bx+1]
		mov temp,ax 
		verNumero2 temp,mostrarnum
		jmp consola

	verMayor: 
		print resMayor
		verNumero2 mayorque, mostrarnum 
		jmp consola
		
	verMenor:  
		print resMenor
		verNumero2 menorque, mostrarnum
		jmp consola 

	genReporte:
		;jmp aReporte
		jmp crearRepo
		;jmp menuPrincipal

	calculadora:
			print enc_calculadora;imprimimos mensaje de bienvenida
			print saltoL;
			print saltoL;
			
			print msjNum;imprimimos mensaje para pedir numero
			
			call getNum;llamamos al proceso 
			mov num1,cx;movemos el resultado a nuestra variable numero1
			
			call obtener_operador		
			
			cmp op,'*';si el numero es menor a * en ascii
			jb OperadorIncorrecto;entonces saltamos a proceso
			cmp op,'/';de la misma forma si es mayor en ascii
			ja operadorIncorrecto
			
			print msjNum;imprimimos mensaje para pedir numero
			call getNum;llamamos al proceso
			mov num2,cx;movemos el segundo resultado a numero2
			
			print msjResultado;imprimimos el msj de resultado
			
			;/////////////////////////Tipo Switch//////////////////////
			cmp op,'*' ;comparamos si el caracter es *
			je CMultiplicacion;vamos al "metodo de multiplicacion
		
			cmp op,'+';comparamos si es suma
			je CSuma ;saltamos al metodo suma

			cmp op,'-';comparamos si es resta
			je CResta;saltamos hacia resta
		
			cmp op,'/';si es division 
			je CDivision;saltamos a division
			;///////////////////// Casos Switch ///////////////////////
			
			CSuma:
				call CalcSuma;llamamos al proceso suma
				jmp Calcretorno;no dirigimos hacia el retorno
			
			CResta:
				call CalcResta;llamamos al proceso resta
				jmp  Calcretorno;no dirigimos hacia el retorno
			
			CMultiplicacion:
				call CalcMultiplicacion;llamamos al proceso multiplicacion
				jmp Calcretorno;no dirigimos hacia el retorno
			
			CDivision:
				call CalcDivision;llamamos el proceso division
				jmp Calcretorno;no dirigimos hacia el retorno
				
			;////////////////////////////////////////////////////////////
			;-------- Para poder retornar hacia el menu o calculadora
			Calcretorno:
				print msjContinuar

				mov ah,01h;leer caracter desde teclado
				int 21h; 
				;sub al,30h;restamos 48 en hexadecimal para obtener un numero 
				;mov opcion,al;movemos el valor resultante la opcion
		
				cmp al,73h
				je calculadora
		
				cmp al,3bh
				je menuPrincipal
			;Si existe un error al ingresar el operador
			OperadorIncorrecto:
				lea dx, err1 ;mostramos el msj
				mov ah, 09h; agregamos funcion 
				int 21h;mostramos en DOS
				jmp calculadora; regresa al inicio de calculadora
			
			jmp menuPrincipal;retornamos a menu
			

			;=================Procesos de operaciones==================================
				CalcSuma:
					mov ax, num1;movemos el numero hacia el registro ax
					add ax,num2;sumamos el numero 2 con el mismo registro
					mov ans,ax;movemos el resultado a ans
					call Imprimir_Numero;llamamos al proceso
				ret

				CalcResta:
					mov ax,num1;movemos el numero hacia el registro ax
					sub ax,num2;restamos el numero 2 a ax
					mov ans,ax;movemos el resultado a ans
					call Imprimir_Numero;llamamos al proceso para imprimir numeros
					ret;

				CalcMultiplicacion:
					mov ax,num1;movemos el numero a el registro ax
					imul num2; multiplicamos AX=AX*numero2
					mov ans,ax;movemos el resultado a ans
					call Imprimir_Numero;llamamos al proceso para imprimir un numero
					ret

				CalcDivision:
					mov dx,0000h;limpiamos el registro dx
					mov ax,num1; movemos el numero hacia el registro ax
					idiv num2;dividimos AX=AX/numero2.... Al=consciente Ah=residuo
					mov ans,ax;movemos el resultado a ans
					call Imprimir_Numero;llamamos el proceso para imprimir numero
					cmp dx,0;si dx tiene residuo 
					jnz msj_Flotante; saltamos hacia el proceso de flotante
					
					ret; retornamos

				msj_Flotante:
					lea dx, aprox;cargamos el mensaje
					mov ah,09h
					int 21h; interrupcion DOS
					ret;retornamos

				Imprimir_Numero:
					push dx;agregamos a pila dx
					push ax;agregamos a pila ax
					
					cmp ax,0;comparamos ax si tiene algun numero
					jnz cno_cero;si no es cero saltamos
					
					imprimirCaracter '0';mandamos un cero si es 0
					jmp cimpreso;saltamos al proceso de finalizacion
					
					cno_cero:
						cmp ax,0;comparamos ax
						jns cpositivo; si no tiene signo
						neg ax;complemento a 2
						
						imprimirCaracter '-';agregamos el caracter -
						
					cpositivo:
						call Imprimir_Numero_sinSigno;llamamos al proceso para imprimir numeros sin signo
						
					cimpreso:
						pop ax;sacamos de pila el registro ax
						pop dx;sacamos de pila el registro dx
				ret;retornamos


				Imprimir_Numero_sinSigno:
					push ax;agregamos a pila ax
					push bx;agregamos a pila bx
					push cx;agregamos a pila cx
					push dx;agregamos a pila dx
					
					mov cx,1
					mov bx,10000
					
					cmp ax,0 ;comparamos el registro ax
					jz imprimir_cero; si ax es igual a 0 vamos a imprimir 0
					
					cinicio:
						cmp bx,0;comparamos el registro bx
						jz cfinal;si es igual a 0 saltamos al final
						
						cmp cx,0;comparamos el registro cx
						je calc;si es igual a 0 saltamos a calc
						
						cmp ax,bx;comparamos ax con bx
						jb csalto;entonces ax<bx por lo tanto div sera diferente cero
					
					calc:
						mov cx,0000h;limpiamos el registro cx
						mov dx,0000h;limpiamos el registro dx
						div bx;dividimos ax=ax/bx
						add al,30h;lo convertimos en numero ascii
						imprimirCaracter al;lo mandamos a imprimir 
						
						mov ax,dx; guardamos el resultado de la ultima division
						
					csalto:
						push ax
						mov dx,0000h;limpiamos registro
						mov ax,bx;guardamos valor de bx en ax para operar
						div diez;dividimos ax=ax/10
						mov bx,ax
						pop ax
						
						jmp cinicio;regresamos
						
					imprimir_cero:
						imprimirCaracter '0';imprimimos 0
					
					cfinal:
						pop dx;sacamos de pila ax,bx,dx,cx
						pop cx
						pop bx
						pop ax
				ret;retornamos


;==========================================================================

	;===============================================================================

	factorial:
		print enc_factorial
		print saltoL
		print msjFac
		print saltoL
		call getNum

		cmp cx,4			;validar factorial  menor a 4
		jle numAceptado
		jg 	errorNumFactorial

			numAceptado: 
				xor si,si

				cmp cx,0
				je num_cero

				cmp cx,1
				je num_uno
				
				cmp cx,2
				je num_dos
				
				cmp cx,3
				je num_tres
				
				cmp cx,4
				je num_cuatro

					num_cero:
						print fact0	
						jmp menuPrincipal	

					num_uno:
						print fact0	
						print fact1	
				
						jmp menuPrincipal	

					num_dos:
						print fact0	
						print fact1
						print fact2
				
						jmp menuPrincipal	

					num_tres:
						print fact0	
						print fact1
						print fact2	
						print fact3	
				
						jmp menuPrincipal	

					num_cuatro:
						print fact0	
						print fact1	
						print fact2
						print fact3	
						print fact4
				
						jmp menuPrincipal	


			errorNumFactorial:
				print err8
				print saltoL
				jmp factorial

	getNum: 
		push dx;metemos el pila el registro dx
		push ax;metemos en pila el registro ax
		push si;metemos en pila el registro indice (si)
		
		mov cx,0000h;limpiamos el registro
		mov cs:negativo,0;reseteamos bandera negativo
		
		siguiente_digito:
			mov ah,00h
			int 16h
			
			mov ah,0Eh
			int 10h
			
			cmp al,'-'
			je asignar_negativo
			
			cmp al,'a'
			je asignar_anterior
			
			cmp al,0Dh
			jne sin_carrie
			
			jmp parar_entrada
		
		asignar_anterior:
			mov cx,ans
			jmp parar_entrada
		
		sin_carrie:
			cmp al,08h
			jne verificacion
			mov dx,0000h
			mov ax,cx
			div diez
			mov cx,ax
			imprimirCaracter ' '
			imprimirCaracter 08h
			
			jmp siguiente_digito
			
		verificacion:
			cmp al,'0'
			jae entrecero_nueve
			jmp remover_caracter
			
		entrecero_nueve:
			cmp al,'9'
			jbe esnumero
			
		remover_caracter:
			imprimirCaracter 08h 
			imprimirCaracter ' '
			imprimirCaracter 08h
			jmp siguiente_digito
			
		esnumero:
			push ax
			mov ax,cx
			mul diez
			mov cx,ax
			pop ax
			
			cmp dx,0
			jne demasiado_grande
			
			sub al,30h
			
			mov ah,00h
			mov dx,cx
			add cx,ax
			jc demasiado_grande2 
			
			jmp siguiente_digito
			
		asignar_negativo:
			mov cs:negativo,1
			jmp siguiente_digito
		
		demasiado_grande:
			mov ax,cx
			div diez
			mov cx,ax
			imprimirCaracter 08h
			imprimirCaracter ' ' 
			imprimirCaracter 08h;
			jmp siguiente_digito;
			
		demasiado_grande2:
			mov cx,dx
			mov dx,0000h
		
		parar_entrada:
			cmp cs:negativo,0
			je positivo
			neg cx 
		positivo:
			pop si
			pop ax
			pop dx
			ret
		negativo db ?
	ret
		
		
;=========================Analisis Lexico================================
	analisisLexico:
		xor ax,ax
		xor si,si 
		mov ax,iLexico
		mov si,ax
		mov al,bufferInformacion[si]

		cmp al,3ch 
		je menque 
		cmp al,3eh
		je mayque
		cmp al,2fh
		je barra
		cmp al,20h 
		jbe ignorar
		cmp al,24h 
		je retorno
		cmp al,30h 
		jae confirmar	;Verifica letras, numeros 
		
	errorLexico:			
		mov lexdesc,al 
		print lexerror
		print lexdesc
		getChar
		jmp menuPrincipal
		
	siguiente: 
		xor ax,ax 
		xor si,si 
		mov ax,iLexico
		inc ax 
		mov iLexico,ax 
		jmp analisisLexico
		
	;subapartado
	confirmar: 
		cmp al,39h 
		jbe numero
		cmp al,41h 
		jae confirmar2
		jmp errorLexico
	
	confirmar2: 
		cmp al,5ah
		jbe minus
		cmp al,61h 
		jae confirmar3 
		jmp errorLexico
	
	confirmar3: 
		cmp al,7ah 
		jbe letra
		jmp errorLexico
	
	numero:
		xor cx,cx 
		mov cl,al  
			mov al,pdatos
			cmp al,31h
			je nLetra
		mov al,pnum 
		cmp al,30h 
		je primero 
		; agrega el nuevo valor 
		mov bx,inum
		mov al,tablaNum[bx]
		mov ah,tablaNum[bx+1]
		mov bl,0ah 
		mul bl  
		sub cl,30h 
		add al,cl 
		adc ah,00h 
		mov bx,inum 
		mov tablaNum[bx],al 
		mov tablaNum[bx+1],ah 
		;si el numero es muy grande 
		cmp ax,03e8h 
		jae Error8 
		jmp ultimo 
		
	ultimo: 
		;verifica si es el ultimo 
		xor ax,ax
		xor si,si 
		mov ax,iLexico
		mov si,ax
		mov al,bufferInformacion[si+1]
		cmp al,30h 
		jb siultimo 
		cmp al,39h 
		ja siultimo
		jmp siguiente 
		
	siultimo: 
		;valida el negativo
		mov al,nnum
		cmp al,31h 
		je negar
		jmp negarRegreso
		
	negarRegreso: 
		;regresa la bandera 
		mov al,30h 
		mov pnum,al 
		;mueve a la siguiente posicion 
		mov ax, inum
		add ax,02h  
		mov inum, ax 
		;fin de validacion
		jmp siguiente

	negar: 
		;ya cambio inum y regresar bander 
		mov bx,inum
		mov al,tablaNum[bx]
		mov ah,tablaNum[bx+1]
		neg ax 
		mov tablaNum[bx],al 
		mov tablaNum[bx+1],ah 
		;regreso la bandera 
		mov al,30h 
		mov nnum,al 
		jmp negarRegreso
		
	
	primero: 
		; guardo el token en la tabla 
		mov al,30h
		mov di,iSintactico 
		mov lex[di],al
		; mueve el siguiente sintactico 
		sig iSintactico
		; guardo el valor en el array de numeros 		
		sub cl,30h 
		mov bx,inum  
		mov tablaNum[bx],cl 
		mov tablaNum[bx+1],00h 
		; indica que es el primero y verifica si es el ultimo 
		mov al,31h 
		mov pnum,al 
		jmp ultimo 
	
	minus: 
		add al, 20h 
		jmp letra
	
	letra:
		xor cx,cx 
		mov cl,al 
		mov al,pdatos
		cmp al,30h 
		je primeroL 
	
	nLetra: 
		xor ax,ax 
		mov bx,idatos 
		mov al,ipdatos
		mov si,ax 
		mov datos[bx+si],cl 
		jmp ultimoL
	
	ultimoL: 
		; guarda el valor de los caracteres 
		mov al,ipdatos
		inc al  
		mov ipdatos,al 
		; verifica si es el ultimo 
		xor ax,ax
		mov bx,iLexico
		mov al,bufferInformacion[bx+1]
		cmp al, 3Eh
		je siUltimoL 
		jmp siguiente 
		
	siUltimoL:
		;regresa la bandera 
		mov al,30h 
		mov pdatos,al 
		;mueve a la siguiente posicion
		mov ax,idatos
		add ax,14h 
		mov idatos,ax  
		;regresa el ipdatos
		mov al,00h 
		mov ipdatos,al 
		jmp siguiente
		
	primeroL:
		mov al,cl 
		cmp al,73h 
		je cambiaraSuma 
		cmp al,72h
		je cambiaraResta
		cmp al,6dh 
		je cambiaraMulti
		cmp al,64h
		je cambiaraDivi 
		jmp noEra 
		
	noEra: 
		; guardo el token en la tabla 
		mov al,61h 
		mov di,iSintactico 
		mov lex[di],al
		; mueve el siguiente sintactico 
		sig iSintactico
		; guarda el valor en el array de caracteres 
		mov bx,idatos
		mov datos[bx],cl 
		; indica que es el primero y verifica si es el ultimo
		mov al,31h 
		mov pdatos,al
		jmp ultimoL 
	
	cambiaraSuma:
		mov bx,iLexico
		mov al,bufferInformacion[bx+1]
		cmp al,75h
		je casiSuma
		cmp al,55h 
		je casiSuma
		jmp noEra 
		
	casiSuma: 
		mov bx,iLexico
		mov al,bufferInformacion[bx+2]
		cmp al,6dh
		je siEsSuma
		cmp al,4dh 
		je siEsSuma
		jmp noEra 
		
	siEsSuma:
		mov bx,iLexico
		add bx,02h 
		mov iLexico,bx
		jmp mas
		
	cambiaraResta: 
		mov bx,iLexico
		mov al,bufferInformacion[bx+1]
		cmp al,45h
		je casiResta
		cmp al,65h  
		je casiResta 
		jmp noEra 
		
	casiResta: 
		mov bx,iLexico
		mov al,bufferInformacion[bx+2]
		cmp al,53h
		je siEsResta
		cmp al,73h 
		je siEsResta 
		jmp noEra 	
	
	siEsResta: 
		mov bx,iLexico
		add bx,02h
		mov iLexico,bx 
		jmp menos
		
	cambiaraMulti:
		mov bx,iLexico
		mov al,bufferInformacion[bx+1]
		cmp al,55h
		je casiMulti
		cmp al,75h  
		je casiMulti 
		jmp noEra 	
	
	casiMulti:
		mov bx,iLexico
		mov al,bufferInformacion[bx+2]
		cmp al,6ch
		je siEsMulti
		cmp al,4ch 
		je siEsMulti
		jmp noEra 	
		
	siEsMulti: 
		mov bx,iLexico
		add bx,02h
		mov iLexico,bx 
		jmp multi 
		
	cambiaraDivi: 	
		mov bx,iLexico
		mov al,bufferInformacion[bx+1]
		cmp al,69h 
		je casiDivi
		cmp al,49h  
		je casiDivi  
		jmp noEra 

	casiDivi: 
		mov bx,iLexico
		mov al,bufferInformacion[bx+2]
		cmp al,56h
		je siEsDivi
		cmp al,76h
		je siEsDivi
		jmp noEra

	siEsDivi: 
		mov bx,iLexico
		add bx,02h
		mov iLexico,bx 
		jmp divi
	
	ignorar: 
		jmp siguiente
		
	menque: 
		mov al,3ch
		mov di,iSintactico 
		mov lex[di],al
		sig iSintactico
		jmp siguiente
		
	mayque: 
		mov al,3eh 
		mov di,iSintactico 
		mov lex[di],al
		sig iSintactico
		jmp siguiente
	
	barra: 
		mov al, 2fh
		mov di,iSintactico 		
		mov lex[di],al
		sig iSintactico		
		jmp siguiente
	
	mas: 
		mov al,2bh
		mov di,iSintactico 		
		mov lex[di],al
		sig iSintactico
		jmp siguiente
	
	signo: 
		xor cx,cx 
		mov cl,al 
		mov bx,iLexico
		mov al,bufferInformacion[bx+1]
		cmp al,30h
		jb menos 
		cmp al,39h 
		jbe siHaySigno
		jmp menos 
		
	siHaySigno: 
		mov ax,0031h
		mov nnum,al
		jmp siguiente

	menos: 
		mov al,2dh
		mov di,iSintactico 		
		mov lex[di],al
		sig iSintactico
		jmp siguiente
		
	multi: 
		mov al,2ah
		mov di,iSintactico 		
		mov lex[di],al
		sig iSintactico		
		jmp siguiente
		
	divi: 
		mov al, 2fh
		mov di,iSintactico 		
		mov lex[di],al
		sig iSintactico		
		jmp siguiente

;==========================Analisis Sintactico===========================================================================================================
	analisisSintactico: 
		mov ax, 0000h 
		mov iSintactico,ax 	
		mov inum,ax 
		mov temp,ax
		mov temp1,ax 
		mov iidenti,ax 
		mov idatos,ax 
		xor ax,ax

		parse 3ch, iSintactico, lex 
		parse 61h, iSintactico, lex
		parse 3eh, iSintactico, lex

		;incrementar 
		mov ax, idatos
		add ax,14h 
		mov idatos,ax

		;parse 22h, iSintactico, lex 
		;parse 3ah, iSintactico, lex
		;parse 5bh, iSintactico, lex
		;jmp E2 
		;unoReturn: 
		;parse 5dh, iSintactico, lex
		;parse 7dh, iSintactico, lex 
			;mov total,ax 
			;and ax,1000000000000000b
			;cmp ax,0000h		
		jmp retorno2 
		
	E2: 
		parse 7bh, iSintactico, lex 
		call ope
		;mete a la tabla de resultado 
		desapilar pila,ipila,temp
		xor bx,bx 
		mov bl,ires
		mov ax,temp
		mov tablaRes[bx],al
		mov tablaRes[bx+1],ah 
		add bx,02h 
		mov ires,bl 
		;fin del metodo 
		;compara si es menor  y si es mayor :) 
		mov bx,menorque 
		cmp ax,bx 
		jl cambiarmenor 
		jmp seguirResultado
	
	cambiarmenor: 
		mov menorque,ax 
		jmp seguirResultado 
		
		;fin del metodo 
	seguirResultado:
		mov bx,mayorque
		cmp ax,bx 
		jg cambiarmayor
		jmp seguirResultado2
		
	cambiarmayor: 
		mov mayorque,ax
		jmp seguirResultado2
		
	seguirResultado2: 
		
		add ax,bx 
		mov ax,contOp
		inc ax 
		mov contOp,ax 
		;fin del metod 
		parse 7dh, iSintactico, lex 
		jmp E3 
		
	E3: 
		xor ax,ax 
		mov ax,iSintactico
		mov si,ax 
		mov al,lex[si]
		cmp al,5dh  
		;je unoReturn
		parse 2ch, iSintactico, lex 
		jmp E2 

	ope: 
		parse 22h, iSintactico, lex 
		parse 61h, iSintactico, lex
			;ingresar a la cadena de datos 
			copCad datos,idatos,identi,iidenti
			mov ax, iidenti
			add ax,14h 
			mov iidenti,ax 
			;incrementar 
			mov ax, idatos
			add ax,14h 
			mov idatos,ax 		
		parse 22h, iSintactico, lex 
		parse 3ah, iSintactico, lex 
		parse 7bh, iSintactico, lex 
		call ope1 	
		parse 7dh, iSintactico, lex 	
	ret 
		
	ope1: 
		parse 22h, iSintactico, lex 
		xor ax,ax 
		mov ax,iSintactico
		mov si,ax 
		mov al,lex[si]
		cmp al,2bh 
		je suma
		cmp al,2dh 
		je resta 
		cmp al,2ah 
		je multiplicacion 
		cmp al,2fh 
		je division 
		jmp errorSintactico
		ope1Return: 
			parse 7dh, iSintactico, lex 
	ret  		
	
	;Zona de analisis
	suma: 
		parse 2bh, iSintactico, lex 
		parse 22h, iSintactico, lex 
		parse 3ah, iSintactico, lex 
		parse 7bh, iSintactico, lex 
		call ope2 
		; operacion de suma 
		desapilar pila,ipila,temp
		mov cx,temp 
		desapilar pila,ipila,temp 
		mov bx,temp 
		add cx,bx 
		mov temp,cx
			apilar pila,ipila,temp 
		; fin del metodo
		jmp ope1Return 
	
	resta: 
		parse 2dh, iSintactico, lex 
		parse 22h, iSintactico, lex 
		parse 3ah, iSintactico, lex 
		parse 7bh, iSintactico, lex 
		call ope2 
		; operacion de resta 
		desapilar pila,ipila,temp 
		mov cx,temp 
		desapilar pila,ipila,temp
		mov bx,temp 
		sub bx,cx 
		mov temp,bx 
			apilar pila,ipila,temp 
		; fin del metodo 
		jmp ope1Return 		
	
	multiplicacion: 
		parse 2ah, iSintactico, lex 
		parse 22h, iSintactico, lex 
		parse 3ah, iSintactico, lex 
		parse 7bh, iSintactico, lex 
		call ope2 
		; operacion de multiplicacion	
		desapilar pila,ipila,temp 
		mov cx,temp 
		desapilar pila,ipila,temp
		mov bx,temp 
		mov ax,cx		
		imul bx 
		mov temp,ax 
			apilar pila,ipila,temp 
		; fin del metodo 
		jmp ope1Return 
		
	division: 
		parse 2fh, iSintactico, lex 
		parse 22h, iSintactico, lex 
		parse 3ah, iSintactico, lex 
		parse 7bh, iSintactico, lex 
		call ope2 
		; operacion de division
		desapilar pila,ipila,temp 
		mov cx,temp 
		desapilar pila,ipila,temp
			mov ax,temp 
			and ax,1000000000000000b
			cmp ax,0000h
			jne errordiv
			jmp division2 
			
		errordiv:
			neg cx 
			neg temp 
			
		division2: 	
		mov bx,temp 
		mov ax,bx
		mov bx,cx 
		xor dx,dx 
		idiv bx 
		mov temp,ax 	
			apilar pila,ipila,temp 
		; fin de division 
		jmp ope1Return 	
		
	ope2: 
		call ope3 
		parse 2ch, iSintactico, lex 
		call ope3 
	ret 
	
	ope3: 
		xor ax,ax 
		mov ax, iSintactico
		mov si,ax 
		mov al, lex[si+1]
		cmp al,23h 
		je numero1
		cmp al,61h 
		je id
		call ope1
		ope3ret: 
	ret 
	
	numero1: 
		parse 22h, iSintactico, lex 
		parse 23h, iSintactico, lex 
		parse 22h, iSintactico, lex 
		parse 3ah, iSintactico, lex 
		parse 30h, iSintactico, lex 
		; agregar a la pila y sumar el contador
		mov bx,inum 
		mov al,tablaNum[bx]
		mov ah,tablaNum[bx+1]
		mov temp,ax 
		apilar pila,ipila,temp 
		mov bx,inum 
		add bx,02h 
		mov inum,bx 
		; fin del metodo de la pila 
		jmp ope3ret
		
	id: 
		parse 22h, iSintactico, lex 
		parse 61h, iSintactico, lex 
			;incrementar 
			mov ax, idatos
			add ax,14h 
			mov idatos,ax 			
		parse 22h, iSintactico, lex 
		parse 3ah, iSintactico, lex 
		parse 22h, iSintactico, lex 
		parse 61h, iSintactico, lex 
			;agregar a la pila
			xor ax,ax 
			xor bx,bx 
			mov temp,ax
			mov temp1,ax 
			buscar:			
				cmpMat datos,idatos,identi,temp,bandera ;se mentiene el dato y cambia el identificador de prueba 
				mov ax,bandera 
				cmp ax,0031h 
				je siIgual 
				mov ax,temp1
				add ax,02h
				mov temp1,ax 
				mov ax,temp 
				add ax,14h
				mov temp,ax 
				mov bx,temp 
				cmp identi[bx],'$' 
				jne buscar 
				jmp noIgual
					
			siIgual: 
				; agregar a la pila y sumar el contador
				mov bx,temp1
				mov al,tablaRes[bx]
				mov ah,tablaRes[bx+1]
				mov temp,ax 
				apilar pila,ipila,temp 
				jmp finId 
				
			noIgual: 
				xor ax,ax  
				mov temp,ax 
				apilar pila, ipila,temp 
				jmp finId
			
			finId: 
					
			
			;incrementar 
			mov ax, idatos
			add ax,14h 
			mov idatos,ax 
		parse 22h, iSintactico, lex 
		jmp ope3ret

	errorSintactico: 
		mov ax,iSintactico
		mov si,ax 
		mov al, lex[si]
		mov sindesc,al 
		print sinerror
		print sindesc
		print sinerror2 
		mov sindesc,bl 
		print sindesc
		getChar
		jmp menuPrincipal
		
;============================= Reporte 2============================
	crearRepo:
		
		crear report,handlerentrada
		escribir handlerentrada, doctype, SIZEOF doctype 
		escribir handlerentrada, htmlInit, SIZEOF htmlInit 
		escribir handlerentrada, headInit, SIZEOF headInit 
		escribir handlerentrada, headEnd, SIZEOF headEnd 
		escribir handlerentrada, bodyInit, SIZEOF bodyInit 
		escribir handlerentrada, h1dtInit, SIZEOF h1dtInit
		getDate
		getTime
    	escribir handlerentrada, date, SIZEOF date
    	escribir handlerentrada, time, SIZEOF time
		escribir handlerentrada, nametext, SIZEOF nametext
		escribir handlerentrada, idtext, SIZEOF idtext
		escribir handlerentrada, h1dtEnd, SIZEOF h1dtEnd
		escribir handlerentrada, bodyEnd, SIZEOF bodyEnd 
		escribir handlerentrada, htmlEnd, SIZEOF htmlEnd 
		exit handlerentrada

		print saltoL
		print saltoL
		jmp menuPrincipal




;============================= Reporte ============================
	aReporte:
	;nombrar el documento de reporte
		;verDatos datos,0,bufferPadre
		;tamanio temp, bufferPadre
		verDatos datos,0,nombreArchivo
		tamanio temp, nombreArchivo
		xor cx,cx
		xor si,si
		mov cx,temp
	acomodar:
		mov dl,bufferPadre[si]
		mov direccion[si],dl
		inc si
		cmp si,cx
		je terminar
		jmp acomodar
	terminar:
		mov direccion[si],'.'
		inc si
		mov direccion[si],'j'
		inc si
		mov direccion[si],'s'
		inc si
		mov direccion[si],'o'
		inc si
		mov direccion[si],00h

		crear direccion,handlerentrada
		escribir handlerentrada,reporte1, SIZEOF reporte1 
		escribir handlerentrada,reporte2, SIZEOF reporte2 
		escribir handlerentrada,reporte3, SIZEOF reporte3 
		escribir handlerentrada,reporte4, SIZEOF reporte4	
	;Segmento de hora y fecha 
		mov ah,2ah
		int 21h 
		mov di,dx ;Guardo la variable antes de la operacion 
		xor ax,ax
		mov al,dl
		mov bx,0ah
		mov dx,00h
		div bx    ;Después de la división, el residuo esta dx y el cociente esta en ax
		add al,30h
		mov reporte6[5],al
		add dl,30h
		mov reporte6[6],dl
		;fecha
		xor ax,ax 
		mov dx,di
		mov al,dh
		mov bx,0ah
		mov dx,00h
		div bx 
		add al,30h
		mov reporte6[18],al 
		add dl,30h
		mov reporte6[19],dl
		xor ax,ax 
		mov ax,cx
		mov bx,03e8h
		mov dx,00h
		div bx
		add al,30h 
		mov reporte6[32],al
		xor ax,ax
		mov ax,dx 
		mov bx,64h
		mov dx,00h
		div bx 
		add al,30h 
		mov reporte6[33],al
		xor ax,ax
		mov ax,dx
		mov bx,0ah 
		mov dx,00h 
		div bx
		add al,30h 
		mov reporte6[34],al
		add dl,30h 
		mov reporte6[35],dl
		;hora
		xor ax,ax  ; sse comienza en la 7 
		mov ah,2ch
		int 21h 
		xor ax,ax
		mov si,dx 
		mov al,ch
		mov bx,0ah
		mov dx,00h
		div bx 
		add al,30h
		mov reporte8[6],al 
		add dl,30h 
		mov reporte8[7],dl 
		xor ax,ax
		mov al,cl
		mov bx,0ah 
		mov dx,00h
		div bx
		add al,30h 
		mov reporte8[23],al
		add dl,30h 
		mov reporte8[24],dl
		xor ax,ax
		mov dx,si
		mov al,dh
		mov bx,0ah
		mov dx,00h
		div bx
		add al,30h
		mov reporte8[41],al
		add dl,30h
		mov reporte8[42],dl				
	;fin de decha y hora 
		escribir handlerentrada,reporte5, SIZEOF reporte5 
		escribir handlerentrada,reporte6, SIZEOF reporte6 	
		escribir handlerentrada,reporte7, SIZEOF reporte7 
		escribir handlerentrada,reporte8, SIZEOF reporte8	
		escribir handlerentrada,reporte9, SIZEOF reporte9		
		escribir handlerentrada,mostrarnum, 6
		escribir handlerentrada,reporte11, SIZEOF reporte11		
		verNumero mayorque,mostrarnum
		escribir handlerentrada,mostrarnum, 6
		escribir handlerentrada,reporte12, SIZEOF reporte12
		verNumero menorque,mostrarnum 
		escribir handlerentrada,mostrarnum, 6
		escribir handlerentrada,reporte13, SIZEOF reporte13
		escribir handlerentrada,reporte141, SIZEOF reporte141
		tamanio temp, bufferPadre
		escribir handlerentrada,bufferPadre,temp
		escribir handlerentrada,reporte142, SIZEOF reporte142
	;bucle 		
			xor ax,ax
			xor bx,bx 
			mov iidenti,ax 
			mov ires,al 
			imprimir: 
				mov bx,iidenti
				escribir handlerentrada,abreOP,SIZEOF abreOP
				verDatos identi,iidenti,mostrarcadena
				escribir handlerentrada,linea,SIZEOF linea
				tamanio temp, mostrarcadena
				escribir handlerentrada,mostrarcadena,temp
				escribir handlerentrada,comilla,SIZEOF comilla
				mov cx,':'
				mov temp,cx 
				escribir handlerentrada,temp,1
				mov bl,ires 
				mov al,tablaRes[bx]
				mov ah,tablaRes[bx+1]
				mov temp,ax 
				verNumero temp,mostrarnum
				escribir handlerentrada,mostrarnum, 6
				mov bl,ires 
				add bl,02h
				mov ires,bl 
				mov bx,iidenti
				add bx,14h
				mov iidenti,bx   
				cmp identi[bx],'$'
				jne seguirImprimir
			;fin bucle 
		escribir handlerentrada,cierreOP,SIZEOF cierreOP2
		escribir handlerentrada,reporte15, SIZEOF reporte15
		exit handlerentrada
		jmp consola

		seguirImprimir:
				escribir handlerentrada,cierreOP,SIZEOF cierreOP
				jmp imprimir
		
;========================= Errores ============================
	Error1: 
		print err1
		getChar
		jmp menuPrincipal
		
	Error2: 
		print err2
		getChar
		jmp menuPrincipal
	
	Error3: 
		print err3
		getChar
		jmp menuPrincipal
		
	Error4: 
		print err4
		getChar
		jmp menuPrincipal
	
	Error5: 
		print err5
		getChar
		jmp menuPrincipal
		
	Error7: 
		print err7
		getChar
		jmp menuPrincipal
		
	Error8: 
		print err8
		getChar
		jmp menuPrincipal	

	salir:
		mov ah,4ch
		xor al,al
		int 21h
main endp	

obtener_operador proc near
	mov ah,09h; funcion para imprimir cadena
	lea dx,msjop;para que elija una opcion
	int 21h; funcion DOS

	mov ah,01h;leer caracter desde teclado
	int 21h
	mov op,al
	
	ret
obtener_operador endp

; Procedimiento para convertir de binario -> ascii
; input : AL=binary code
; output : AX=ASCII code
convert proc
       aam 
       add ax, 3030h
ret
convert endp

end main 