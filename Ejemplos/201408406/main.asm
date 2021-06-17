include macros.asm
;[inicio]-------------------------- [] ---------------------------------
;[fin]----------------------------- [] ---------------------------------


;[inicio]-------------------------- [Macros] ---------------------------
;=========================getPathFile===================




;[inicio]-------------------------- [macro Imprimir] ---------------------------------
   PrintLn macro cadena
   mov ax,@data
   mov ds,ax
   mov ah,09
   mov dx,offset cadena
   int 21h
   endm
;[fin]----------------------------- [macro Imprimir] ---------------------------------


;[inicio]-------------------------- [macro Limpiar Consola] ---------------------------------

   Clear macro
      mov ax,0600h
      mov bh,01h
      mov cx,0000h
      mov dx,184fh
      int 10h
   endm

;[fin]----------------------------- [macro Limpiar Consola] ---------------------------------

;[inicio]-------------------------- [MACRO PAUSA] ---------------------------------
   Pausa macro
      mov ah , 01h 
      int 21h 
      cmp al , 0dh 
      mov ah , 02h 
      mov dl , al 
      int 21h 
   endm
   ;No se sale hasta que presione un enter
;[fin]----------------------------- [MACRO PAUSA] ---------------------------------

;[fin]-------------------------- [Macros] ----------------------------


.model small
.stack 100h

;----------- [CONSTANTES] --------------------
SIGNO_POSITIVO EQU 43
SIGNO_NEGATIVO EQU 45
SIGNO_DIVISION EQU 47
SIGNO_MULTIPLICACION EQU 42
SIGNO_FACTORIAL EQU 33

VALOR_RETORNO EQU 13
VALOR_NUEVALINEA EQU 10 ;NUEVA LINEA O SALTO DE LINEA


.data

;----------- [VARIABLES] ----------------------

;------------------------------ REPORTE -------------------------
   HTML_BANDERA db ' '
   HTML_ENCABEZADO db '<html><head><title>Reporte - Practica 3</title></head><body><h3>Practica 3 Arqui 1 Seccion A</h3>', VALOR_RETORNO
   HTML_DATOS db '<table><tr><td><h5>Estudiante: </h5></td><td><h6>Andrea Marisol Orozco Aparicio</h6></td></tr><tr><td><h5>Carnet: </h5></td><td><h6>201408406</h6></td></tr><tr><td><h5>Fecha: </h5></td><td><h6>', VALOR_RETORNO
   HTML_FECHA_DIA db 3 dup(' '), VALOR_RETORNO
   HTML_FECHA_MES db 3 dup(' '), VALOR_RETORNO
   HTML_FEHCA_ANIO db '2021', VALOR_RETORNO
   HTML_FECHAHORA db '</h6></td></tr><tr><td><h5>Hora: </h5></td><td><h6>', VALOR_RETORNO
   HTML_HORA_HORA db 3 dup(' '), VALOR_RETORNO
   HTML_HORA_MIN db 3 dup(' '), VALOR_RETORNO
   HTML_HORA_SEG db 3 dup(' '), VALOR_RETORNO
   HTML_FIN_ENCABEZADO db '</h6></td></tr></table><br><br>', VALOR_RETORNO
   HTML_TABLAOPERACION db '<table border="1px"><tr><td>Id Operacion</td><td>Operacion</td><td>Resultado</td></tr>', VALOR_RETORNO

   HTML_TABLAOPERACION_OPERACION1 db '<tr><td>Op1</td><td>', VALOR_RETORNO
   vectorOperacionAlmacenadaUno db 44 dup(' '), "$"
   HTML_DIVISION_OPERACION1 db '</td><td>', VALOR_RETORNO
   intResultadoAlmacenadoUno db ('+'), 3 dup (' '), "$"
   HTML_DIVISION_RESULTADO1 db '</td></tr>', VALOR_RETORNO
   HTML_TABLAOPERACION_OPERACION2 db '<tr><td>Op2</td><td>', VALOR_RETORNO
   vectorOperacionAlmacenadaDos db 44 dup(' '), "$"
   HTML_DIVISION_OPERACION2 db '</td><td>', VALOR_RETORNO
   intResultadoAlmacenadoDos db ('+'), 3 dup (' '), "$"
   HTML_DIVISION_RESULTADO2 db '</td></tr>', VALOR_RETORNO
   HTML_TABLAOPERACION_OPERACION3 db '<tr><td>Op3</td><td>', VALOR_RETORNO
   vectorOperacionAlmacenadaTres db 44 dup(' '), "$"
   HTML_DIVISION_OPERACION3 db '</td><td>', VALOR_RETORNO
   intResultadoAlmacenadoTres db ('+'), 3 dup (' '), "$"
   HTML_DIVISION_RESULTADO3 db '</td></tr>', VALOR_RETORNO
   HTML_TABLAOPERACION_OPERACION4 db '<tr><td>Op4</td><td>', VALOR_RETORNO
   vectorOperacionAlmacenadaCuatro db 44 dup(' '), "$"
   HTML_DIVISION_OPERACION4 db '</td><td>', VALOR_RETORNO
   intResultadoAlmacenadoCuatro db ('+'), 3 dup (' '), "$"
   HTML_DIVISION_RESULTADO4 db '</td></tr>', VALOR_RETORNO
   HTML_TABLAOPERACION_OPERACION5 db '<tr><td>Op5</td><td>', VALOR_RETORNO
   vectorOperacionAlmacenadaCinco db 44 dup(' '), "$"
   HTML_DIVISION_OPERACION5 db '</td><td>', VALOR_RETORNO
   intResultadoAlmacenadoCinco db ('+'), 3 dup (' '), "$"
   HTML_DIVISION_RESULTADO5 db '</td></tr>', VALOR_RETORNO
   HTML_TABLAOPERACION_OPERACION6 db '<tr><td>Op6</td><td>', VALOR_RETORNO
   vectorOperacionAlmacenadaSeis db 44 dup(' '), "$"
   HTML_DIVISION_OPERACION6 db '</td><td>', VALOR_RETORNO
   intResultadoAlmacenadoSeis db ('+'), 3 dup (' '), "$"
   HTML_DIVISION_RESULTADO6 db '</td></tr>', VALOR_RETORNO
   HTML_TABLAOPERACION_OPERACION7 db '<tr><td>Op7</td><td>', VALOR_RETORNO
   vectorOperacionAlmacenadaSiete db 44 dup(' '), "$"
   HTML_DIVISION_OPERACION7 db '</td><td>', VALOR_RETORNO
   intResultadoAlmacenadoSiete db ('+'), 3 dup (' '), "$"
   HTML_DIVISION_RESULTADO7 db '</td></tr>', VALOR_RETORNO
   HTML_TABLAOPERACION_OPERACION8 db '<tr><td>Op8</td><td>', VALOR_RETORNO
   vectorOperacionAlmacenadaOcho db 44 dup(' '), "$"
   HTML_DIVISION_OPERACION8 db '</td><td>', VALOR_RETORNO
   intResultadoAlmacenadoOcho db ('+'), 3 dup (' '), "$"
   HTML_DIVISION_RESULTADO8 db '</td></tr>', VALOR_RETORNO
   HTML_TABLAOPERACION_OPERACION9 db '<tr><td>Op9</td><td>', VALOR_RETORNO
   vectorOperacionAlmacenadaNueve db 44 dup(' '), "$"
   HTML_DIVISION_OPERACION9 db '</td><td>', VALOR_RETORNO
   intResultadoAlmacenadoNueve db ('+'), 3 dup (' '), "$"
   HTML_DIVISION_RESULTADO9 db '</td></tr>', VALOR_RETORNO
   HTML_TABLAOPERACION_OPERACION10 db '<tr><td>Op10</td><td>', VALOR_RETORNO
   vectorOperacionAlmacenadaDiez db 44 dup(' '), "$"
   HTML_DIVISION_OPERACION10 db '</td><td>', VALOR_RETORNO
   intResultadoAlmacenadoDiez db ('+'), 3 dup (' '), "$"
   HTML_DIVISION_RESULTADO10 db '</td></tr>', VALOR_RETORNO
   HTML_FIN db '</table></body></html>', VALOR_RETORNO
   HTML_BANDERA_FIN db 'HASTA AQUI - NADA MAS - NO AVANCES MAS' 

   intCalculardia db 0
   intCalcularmes db 0
   intCalcularhora db 0
   intCalcularmin db 0
   intCalcularseg db 0

   HTML_NOMBRE_REPORTE db 'REPORTE.HTM', 0
   
;-------------------------------- REPORTE ----------------------------

;[inicio]---------------------------------[El encabezado]-------------------------------------------

   header_linea_1 db VALOR_NUEVALINEA, VALOR_RETORNO, "UNIVERSIDAD DE SAN CARLOS DE GUATEMALA", "$"
   header_linea_2 db VALOR_NUEVALINEA, VALOR_RETORNO, "FACULTAD DE INGENIERIA", "$"
   header_linea_3 db VALOR_NUEVALINEA, VALOR_RETORNO, "ESCUELA DE CIENCIAS Y SISTEMAS", "$"
   header_linea_4 db VALOR_NUEVALINEA, VALOR_RETORNO, "ARQUITECTURA DE COMPUTADORES Y ENSAMBLADORES 1", "$"
   header_linea_5 db VALOR_NUEVALINEA, VALOR_RETORNO, "SECCION B", "$"
   header_linea_6 db VALOR_NUEVALINEA, VALOR_RETORNO, "PRIMER SEMESTRE 2021", "$"
   header_linea_7 db VALOR_NUEVALINEA, VALOR_RETORNO, "ANDREA MARISOL OROZCO APARICIO", "$"
   header_linea_8 db VALOR_NUEVALINEA, VALOR_RETORNO, "201408406", "$"
   header_linea_9 db VALOR_NUEVALINEA, VALOR_RETORNO, "PRIMERA PRACTICA DE ASSEMBLER", "$"

 ;[fin]---------------------------------[El encabezado]-------------------------------------------

 ;[inicio]--------------------------------------[Menu]------------------------------------------------

   menu_linea_0 db VALOR_NUEVALINEA, VALOR_RETORNO, "---- MENU PRINCIPAL ---", "$"
   menu_linea_1 db VALOR_NUEVALINEA, VALOR_RETORNO, "| 1. CARGAR ARCHIVO   |", "$"
   menu_linea_2 db VALOR_NUEVALINEA, VALOR_RETORNO, "| 2. MODO CALCULADORA |", "$"
   menu_linea_3 db VALOR_NUEVALINEA, VALOR_RETORNO, "| 3. FACTORIAL        |", "$"
   menu_linea_4 db VALOR_NUEVALINEA, VALOR_RETORNO, "| 4. CREAR REPORTE    |", "$"
   menu_linea_5 db VALOR_NUEVALINEA, VALOR_RETORNO, "| 5. SALIR            |", "$"
   menu_linea_6 db VALOR_NUEVALINEA, VALOR_RETORNO, "-----------------------", VALOR_RETORNO, VALOR_NUEVALINEA,"$"

 ;[fin]-----------------------------------------[Menu]------------------------------------------------

;[inicio]-------------------------- [Mensajes] ---------------------------------
   error_menu_opcion_incorrecta db VALOR_NUEVALINEA, VALOR_RETORNO, "Ha ingresado un numero incorrecto, intentelo de nuevo", "$"

   msj_opcion_menu_CargarArchivo db VALOR_NUEVALINEA, VALOR_RETORNO, "Entre a la opcion cargar archivo", "$"
   msj_opcion_menu_ModoCalculadora db VALOR_NUEVALINEA, VALOR_RETORNO, "Entre a la opcion modo calculadora", "$"
   msj_opcion_menu_Factorial db VALOR_NUEVALINEA, VALOR_RETORNO, "Entre a la opcion Factorial", "$"
   msj_opcion_menu_CrearReporte db VALOR_NUEVALINEA, VALOR_RETORNO, "Entre a la opcion crear reporte", "$"
   msj_opcion_menu_Salir db VALOR_NUEVALINEA, VALOR_RETORNO, "Entre a la opcion salir", "$"

   msj_modocalculadora_PedirNumero db VALOR_NUEVALINEA, VALOR_RETORNO, "Ingrese un numero (-99 a 99)", VALOR_NUEVALINEA,VALOR_RETORNO, "$"
   msj_modocalculadora_PedirOperador db VALOR_NUEVALINEA, VALOR_RETORNO, "Ingrese un operador (+,-,*,/)",VALOR_NUEVALINEA,VALOR_RETORNO, "$"
   msj_modocalculadora_PedirOperadorPuntoycoma db VALOR_NUEVALINEA, VALOR_RETORNO, "Ingrese un operador (+,-,*,/) o punto y coma(;).",VALOR_NUEVALINEA, VALOR_RETORNO, "$"
   msj_modocalculadora_MostrarResultado db VALOR_NUEVALINEA, VALOR_RETORNO, "El resultado es: ", "$"
   msj_modocalculadora_error_Operador db VALOR_NUEVALINEA, VALOR_RETORNO, "ERROR:Ingrese un operador correcto (+,-,*,/)", VALOR_NUEVALINEA,VALOR_RETORNO, "$"
   msj_modocalculadora_error_Numero db VALOR_NUEVALINEA, VALOR_RETORNO, "ERROR:Ingrese un numero correcto (-99 a 99)",VALOR_NUEVALINEA, VALOR_RETORNO, "$"
   msj_modocalculadora_advertencia_maximoNumeros db VALOR_NUEVALINEA, VALOR_RETORNO, "ADVERTENCIA:Ya tiene 10 operaciones, se procedera a ejecutar.",VALOR_NUEVALINEA, VALOR_RETORNO, "$"
   msj_modocalculadora_guardar_pregunta db VALOR_NUEVALINEA, VALOR_RETORNO, "¿Desea almacenar el resultado de la operacion? (S/N)",VALOR_NUEVALINEA, VALOR_RETORNO, "$"
   msj_modocalculadora_error_SinEspacio db VALOR_NUEVALINEA, VALOR_RETORNO, "Lo siento, no hay mas espacio para seguir almacenando operaciones",VALOR_NUEVALINEA, VALOR_RETORNO, "$"


   msj_debug db VALOR_NUEVALINEA, VALOR_RETORNO, "Debug", "$"
   msj_debug_nombre_suma db VALOR_NUEVALINEA, VALOR_RETORNO, "Debug - andie - suma", "$"
   msj_debug_nombre_resta db VALOR_NUEVALINEA, VALOR_RETORNO, "Debug - andie - resta", "$"
   msj_saltoLinea db VALOR_NUEVALINEA, VALOR_RETORNO, "$"

   msj_error_archivoNoEliminado db VALOR_NUEVALINEA, VALOR_RETORNO, 'Error: El archivo no se ha eliminado.',"$"
   msj_warning_archivoEliminado db VALOR_NUEVALINEA, VALOR_RETORNO, 'Warning: El archivo se elimino correctamente.',"$"
   msjCreado db VALOR_NUEVALINEA, VALOR_RETORNO, 'Warning: El archivo se creo correctamente.',"$"
   msjNoCreado db VALOR_NUEVALINEA, VALOR_RETORNO, 'Warning: El archivo se creo correctamente.',"$"
   msjEscrito db VALOR_NUEVALINEA, VALOR_RETORNO, 'Warning: El mensaje se escribio correctamente en el archivo.',"$"
   msjNoEscrito db VALOR_NUEVALINEA, VALOR_RETORNO, 'Error: El mensaje no se escribio correctamente en el archivo.',"$"
   msjNoAbierto db VALOR_NUEVALINEA, VALOR_RETORNO, 'Error: El archivo no se abrio correctamente',"$"
;[fin]----------------------------- [Mensajes] ---------------------------------


;[inicio]-------------------------- [¿Compilo?] ---------------------------------
   compilacion_bandera db VALOR_NUEVALINEA, VALOR_RETORNO, "version 3.3", "$"
;[fin]----------------------------- [¿Compilo?] ---------------------------------

;---------------------- Variables de Modo Calculadora----------------------------------------------

;---------------------- Pedir datos------------------------
   boolYaTengoUnNumero db 0
   intPrimerNumero db 0

   vectorLectura db 4 dup(' '), "$"
   intCadenaValida db 0
   intNumeroValido db 0

   intNumeroDecimal dw 0

   vectorNumerosRecolectados db 23 dup(' '), "$"
   vectorOperadoresRecolectados db 10 dup(' '), "$"
   intContadorNumerosRecolectados db 0
   intContadorOperadoresRecolectados db 0
   ;limpias NO TOCAR 
   vectorNumerosRecolectadosCLON db 23 dup(' '), "$"
   vectorOperadoresRecolectadosCLON db 10 dup(' '), "$"
;---------------------- Pedir datos------------------------

;--------------------- Para hacer las operaciones -----------------------------------------------------
   intContadorTemporalOperadores db 0
   intContadorTemporalNumeros db 0

   chrSignoUno db ' ', "$"
   intNumeroUno dw 0
   chrSignoDos db ' ', "$"
   intNumeroDos dw 0
   intResultado dw 0, "$"
   ;vectorResultados db 20 dup(' '), "$"
   intContadorResultados db 0
   vectorResultado db ('+'), 3 dup (' '), "$"
   intTemporalResultadoImprimir dw 0, "$"


   intContadorNegativos db 0
   intTemporalNumero1 dw 0
   intTemporalNumero2 dw 0
;--------------------- Para hacer las operaciones
  
;------------------------------------------------ Factorial -----------------------------------------
   msj_modofactorial_PedirNumero db VALOR_NUEVALINEA, VALOR_RETORNO, "Ingrese un numero para calcular factorial por favor", VALOR_NUEVALINEA,VALOR_RETORNO, "$"
   vectorFactorial db 3 dup (' '), "$"
   intResultadoFactorial dw 0

   msj_Operacion_Resultado db VALOR_NUEVALINEA, VALOR_RETORNO,'Operaciones: ', "$"
   msj_Concatenacion_Resultado db ' !=   =   ; ', "$"
   msj_Operacion_Resultado_cero db '0!= ; ', '$'
   msj_Operacion_Resultado_Resultado db VALOR_NUEVALINEA, VALOR_RETORNO,'Resultado: ', "$"
   ;msj_Operacion_Resultado_uno db '1!=', '$'
   ;msj_Operacion_Resultado_dos db '2!=', '$'
   ;msj_Operacion_Resultado_tres db '3!=', '$'
   ;msj_Operacion_Resultado_cuatro db '4!=', '$'
   ;msj_Operacion_Resultado_cinco db '5!=', '$'
   ;msj_Operacion_Resultado_espacio db ' ', '$'
;---------------------- Variables de Modo Calculadora----------------------------------------------
;=============================================================================================
;==================== Para cargar el archivo ================================================
;=============================================================================================
lineaH  db 0ah,0dh, '  ========================================================', '$'
header  db 0ah,0dh, '   UNIVERSIDAD DE SAN CARLOS DE GUATEMALA', 0ah,0dh, '   FACULTAD DE INGENIERIA', 0ah,0dh, '   CIENCIAS Y SISTEMAS', 0ah,0dh, '   CURSO: ARQUITECTURA DE COMPUTADORES Y ENSAMBLADORES 1', 0ah,0dh, '   NOMBRE: Andrea Marisol Orozco Aparicio', 0ah,0dh, '   CARNET: 201408406', '$'
options db 0ah,0dh, '   1) CARGAR ARCHIVO', 0ah,0dh, '   2) CONSOLA', 0ah,0dh, '   3) SALIR', '$'
getOPT  db 0ah,0dh, '   >> Escoger Opcion: ', '$'
finHDR  db 0ah,0dh, '  ========================================================', '$'
ln db 0ah,0dh, '$'

msgCarg db 0ah,0dh, '  ==================== CARGAR ARCHIVO ====================', '$'
getPath db 0ah,0dh, '   >> Ingrese Ruta: ', '$'
msgPath db 0ah,0dh, '   ARCHIVO LEIDO CON EXITO!', '$'
msgEPath db 0ah,0dh, '   ERROR AL LEER ARCHIVO', '$'
path db 100 dup('$')

msgCons db 0ah,0dh, '  ======================= CONSOLA ========================', '$'
getCMD db 0ah,0dh, '   >> ', '$'
msgECMD db 0ah,0dh, '   COMANDO NO ECONTRADO', '$'

msgMedia db 0ah,0dh, '   Estadistico Media: ', '$'
msgModa db 0ah,0dh, '   Estadistico Moda: ', '$'
msgMediana db 0ah,0dh, '   Estadistico Mediana: ', '$'
msgMayor db 0ah,0dh, '   Estadistico Mayor: ', '$'
msgMenor db 0ah,0dh, '   Estadistico Menor: ', '$'
msgID db 0ah,0dh, '   Resultado ', '$'

msgOpeningError  db 0ah,0dh,20h,20h,  'ERROR: NO SE PUDO ABRIR EL ARCHIVO', '$'
msgCreationError db 0ah,0dh,20h,20h,  'ERROR: NO SE PUDO CREAR EL ARCHIVO', '$'
msgWritingError  db 0ah,0dh,20h,20h,  'ERROR: NO SE PUDO ESCRIBIR EN EL ARCHIVO', '$'
msgDeleteError   db 0ah,0dh,20h,20h,  'ERROR: NO SE PUDO ELIMINAR EL ARCHIVO', '$'
msgReadingError  db 0ah,0dh,20h,20h,  'ERROR: NO SE PUDO LEER EL ARCHIVO', '$'
msgCloseError    db 0ah,0dh,20h,20h,  'ERROR: NO SE PUDO CERRAR EL ARCHIVO', '$'

bufferContenidoJSON db 10000 dup('$')       ; Array para almacenar el contenido del archivo
auxiliar db 50 dup('$')                     ; Variable para ir formando cada uno de los IDs y numero del archivo
negativo db 48                              ; Variable para saber si hay que negar un numero
numeroU dw 00h, '$'                         ; Variable para el numero1 a operar
numeroD dw 00h, '$'                         ; Variable para el numero2 a operar
signo   db 00h, '$'                         ; Variable para guardar el signo de operacion
handleFile dw ?

alumnoJSON db '{', 0ah,09h, '"reporte": {', 0ah,09h,09h, '"alumno": {', 0ah,09h,09h,09h, '"Nombre": "Andrea Marisol Orozco Aparicio",',  0ah,09h,09h,09h, '"Carnet": 201408406,', 0ah,09h,09h,09h, '"Seccion": "B",', 0ah,09h,09h,09h, '"Curso": "Arquitectura de Computadoras y Ensambladores 1 A"', 0ah,09h,09h, '},'                                         
fechaDiaJSON db  0ah,09h,09h, '"fecha": {', 0ah,09h,09h,09h, '"Dia": '
fechaMesJSON db  ',', 0ah,09h,09h,09h, '"Mes": '
fechaAnioJSON db  ',', 0ah,09h,09h,09h, '"Año": 2020'
horaHoraJSON db  0ah,09h,09h, '},', 0ah,09h,09h, '"hora": {', 0ah,09h,09h,09h, '"Hora": '
horaMinutosJSON db  ',', 0ah,09h,09h,09h, '"Minutos": '
horaSegundosJSON db  ',', 0ah,09h,09h,09h, '"Segundos": '
resultsMediaJSON db  0ah,09h,09h, '},', 0ah,09h,09h, '"resultados": {', 0ah,09h,09h,09h, '"Media": '
resultsMedianaJSON db  ',', 0ah,09h,09h,09h, '"Mediana": '
resultsModaJSON db  ',', 0ah,09h,09h,09h, '"Moda": '
resultsMenorJSON db  ',', 0ah,09h,09h,09h, '"Menor": '
resultsMayorJSON db  ',', 0ah,09h,09h,09h, '"Mayor": '
operacionesJSON db  0ah,09h,09h, '},', 0ah,09h,09h, '"'
operaciones1JSON db '": ['
operaciones2JSON db 0ah,09h,09h,09h, '{', 0ah,09h,09h,09h,09h
comillasDB db '"'
dosPuntos db ': '
operaciones3JSON db 0ah,09h,09h,09h, '},'
cierreJSON db  0ah,09h,09h, ']', 0ah,09h, '}', 0ah, '}'

fechaDia db 'dd'
fechaMes db 'mm'
fechaHora db 'hh'
fechaMinutos db 'mm'
fechaSegundos db 'ss'
resMedia dw 0, '$'
resMediana dw 0, '$'
resModa dw 0, '$'
resMenor dw 0, '$'
resMayor dw 0, '$'

pathFile db 50 dup('$')         ; Variable para guardar el nombre del padre para el reporte
nameParent db 30 dup('$')       ; Variable para guardar el nombre del padre e imprimir dentro del reporte
sizeNameParent dw 0             ; Variable para almacenar la longitud del nombre del padre
pathBool db 48                  ; Variable para saber si ya se almaceno un nombre padre 0 (False)

arrOperacionesNom db 255 dup('$')
arrOperacionesVal dw 255 dup('$')
contadorOperacionNom dw 0
contadorOperacionVal dw 0
auxValor dw 0

msgRESTA db 0ah,0dh, '   Resultado RESTA ', '$'
msgSUMA db 0ah,0dh, '   Resultado SUMA ', '$'
msgMULT db 0ah,0dh, '   Resultado MULTIPLICACION ', '$'
msgDIV db 0ah,0dh, '   Resultado DIVISION ', '$'
msgAnalisis  db 0ah,0dh,20h,20h,  ' OPERACIONES CALCULADAS', '$'
msG db 0ah,0dh, '   Resultado MAYOR: ', '$'
msL db 0ah,0dh, '   Resultado MENOR: ', '$'
msM db 0ah,0dh, '   Resultado MEDIA: ', '$'
;=============================================================================================
;==================== Para cargar el archivo ================================================
;=============================================================================================



 ;----------------- [Aqui inicia el codigo] ----------------------------------------------------------
.code

mov ax,@data
mov ds,ax ; Lo mueve a data segment

;[inicio]-------------------------- [Aqui si inicia el codigo de a deveritas] ---------------------------------
   
   ;Etiqueta inicio
   Inicio:
   PrintLn compilacion_bandera
   call Print_Encabezado
   jmp Menu

   ;Etiqueta menu
   Menu:
   call Print_Menu
   call PROC_MENU

   ;-------------- Procedimiento: Lectura de una linea
   ReadLn proc near
   mov si,00h ; esto es para contar y empieza en cero
   lea si,vectorLectura
   

   leer:
      mov ah,01h ;llama la funcion lectura
      int 21h
      mov [si],al ;Guardar en el arreglo el valor leido en la posicion si
      inc si
      cmp al,0dh
         jne leer
   ret
   ReadLn endp


   ;----------- Procedimiento: Imprimir Encabezado
   Print_Encabezado proc near
      PrintLn header_linea_1
      PrintLn header_linea_2
      PrintLn header_linea_3
      PrintLn header_linea_4
      PrintLn header_linea_5
      PrintLn header_linea_6
      PrintLn header_linea_7
      PrintLn header_linea_8
      PrintLn header_linea_9

      ret

   Print_Encabezado endp

   ;------------- Procedimiento: Imprimir menu
   Print_Menu proc near

      PrintLn menu_linea_0
      PrintLn menu_linea_1
      PrintLn menu_linea_2
      PrintLn menu_linea_3
      PrintLn menu_linea_4
      PrintLn menu_linea_5
      PrintLn menu_linea_6

      ret

   Print_Menu endp

   ;----------- Procedimiento: Menu que escucha lo que el usuario ingresa a la CALCULADORA
   PROC_MENU proc near

      mov ah,0dh
      int 21h
      ;Comparar la opcion

      ;Para pedir numeros de la consola
      mov ah,01h
      int 21h
      ;Para pedir numeros de la consola

      cmp al,31h ;solo para comparar si es uno
      je menu_CargarArchivo

      cmp al,32h ;solo para comparar si es dos
      je menu_ModoCalculadora

      cmp al,33h ;solo para comparar si es tres
      je menu_Factorial

      cmp al,34h ;solo para comparar si es cuatro
      je menu_CrearReporte

      cmp al,35h ;solo para comparar si es cinco
      je menu_Salir

      
      jmp Inicio

   ret

   PROC_MENU endp


   ;------------- Etiqueta del menu --------------------------------

   ;--------- Opcion del menu para cargar el archivo de entrada
   menu_CargarArchivo: 
      Clear
      PrintLn msj_opcion_menu_CargarArchivo
      call PreCargarArchivo
      jmp Menu

;============================== Metodo inicio cargar ==========
   PreCargarArchivo proc near
   CARGAR:
            clearString path
            clearString pathFile
            clearString bufferContenidoJSON

            clearString auxiliar
            clearString nameParent
            clearString arrOperacionesNom
            clearString arrOperacionesVal
            mov contadorOperacionNom, 0
            mov contadorOperacionVal, 0
            mov resMedia, 0
            mov resMediana, 0
            mov resModa, 0
            mov resMenor, 0
            mov resMayor, 0

            print msgCarg
            print getPath
            getPathFile path
            openFile path, handleFile
            readFile SIZEOF bufferContenidoJSON, bufferContenidoJSON , handleFile
            closeFile handleFile

            analisisJSON bufferContenidoJSON        ; Se recorre el archivo
            ;generateReport

   PreCargarArchivoFinal:

   ret
   PreCargarArchivo endp
;==============================================================
   ;---------- Opcion del menu para ejecutar el modo calculadora
   menu_ModoCalculadora:
      Clear
      call LimpiarVariablesNuevoIngreso
      PrintLn msj_opcion_menu_ModoCalculadora
      jmp ModoCaluladora_PedirNumeros
      jmp Menu
   ;----------- Opcion del menu para ejecutar la operacion factorial
   ;-------------- [Etiqueta donde se generan las peticiones de los numeros] ------------
   ModoCaluladora_PedirNumeros:

      CicloPedirNumeros:
      cmp boolYaTengoUnNumero,1
      je MasNumeros
      PrimerNumero:
         PrintLn msj_modocalculadora_PedirNumero
         call ReadLn
         mov intNumeroDecimal, 0 ;Para limpiar la variable
         call ValidarNumeros
         call GuardarNumero
         PerdirOperadorPrimero:
         PrintLn msj_modocalculadora_PedirOperador
         call ReadLn
         call GuardarOperador
         mov boolYaTengoUnNumero, 1
         jmp CicloPedirNumeros

      MasNumeros:
      PrintLn msj_modocalculadora_PedirNumero
      call ReadLn
      mov intNumeroDecimal, 0 ;Para limpiar la variable
      call ValidarNumeros
      mov al, intContadorNumerosRecolectados
      add al,1
      mov intContadorNumerosRecolectados, al
      call GuardarNumero
      cmp intContadorOperadoresRecolectados, 10
      je AdvertenciaMaximoNumeros

      PedirOperadorSegundo:
      PrintLn msj_modocalculadora_PedirOperadorPuntoycoma
      call ReadLn
      mov si,0
      mov al, vectorLectura[si]
      cmp al,59
      je ModoCalculadora_RealizarOperaciones
      call GuardarOperador
      jmp MasNumeros

      AdvertenciaMaximoNumeros:
      PrintLn msj_modocalculadora_advertencia_maximoNumeros

;----------------------------- TODO ESTO ES IMPORTANTE NO LO TOQUES SIN PREGUNTAR --------------------------------------------------------
      ModoCalculadora_RealizarOperaciones:;-------- estoy enojada con mi novio por sabiondo amargadote pero todo lo que hace ,lo hace porque me ama y se preocupa por mi
      ValidarPrimerNumero:
      ;Obtiene el signo del primer numero
      mov bh, 0
      mov bl, intContadorTemporalNumeros
      mov al, vectorNumerosRecolectados[bx]
      ;mov chrSignoUno[0], al
      cmp al, SIGNO_NEGATIVO
      je ConvertirPrimerNumeroNegativo
      ;Actualiza el indice
      inc intContadorTemporalNumeros
      ;Obtiene el valor del primer numero
      mov bh, 0
      mov bl, intContadorTemporalNumeros
      mov ah, 0
      mov al, vectorNumerosRecolectados[bx]
      mov intNumeroUno, ax
      jmp ValidarSegundoNumero

      ConvertirPrimerNumeroNegativo:
      ;Actualiza el indice
      inc intContadorTemporalNumeros
      ;Obtiene el valor del primer numero
      mov bh, 0
      mov bl, intContadorTemporalNumeros
      mov ah, 0
      mov al, 0
      mov al, vectorNumerosRecolectados[bx]
      mov intNumeroUno, ax
      neg intNumeroUno
      jmp ValidarSegundoNumero

      ValidarSegundoNumero:
      inc intContadorTemporalNumeros
      mov bh, 0
      mov bl, intContadorTemporalNumeros
      mov al, vectorNumerosRecolectados[bx]
      cmp al, SIGNO_NEGATIVO
      je ConvertirSegundoNumeroNegativo
      ;Actualiza el indice
      inc intContadorTemporalNumeros
      ;Obtiene el valor del primer numero
      mov bh, 0
      mov bl, intContadorTemporalNumeros
      mov ah, 0
      mov al, vectorNumerosRecolectados[bx]
      mov intNumeroDos, ax
      jmp RealizarOperacion

      ConvertirSegundoNumeroNegativo:
      ;Actualiza el indice
      inc intContadorTemporalNumeros
      ;Obtiene el valor del primer numero
      mov bh, 0
      mov bl, intContadorTemporalNumeros
      mov ah, 0
      mov al, 0
      mov al, vectorNumerosRecolectados[bx]
      mov intNumeroDos, ax
      neg intNumeroDos
      jmp RealizarOperacion

      RealizarOperacion:
      mov bh,0
      mov bl, intContadorTemporalOperadores
      inc intContadorTemporalOperadores
      mov al, vectorOperadoresRecolectados[bx]
      cmp al, SIGNO_POSITIVO
      je ModoCalculadora_OperacionSuma
      cmp al, SIGNO_NEGATIVO
      je ModoCalculadora_OperacionResta
      cmp al, SIGNO_MULTIPLICACION
      je ModoCalculadora_OperacionMultiplicacion
      cmp al, SIGNO_DIVISION
      je ModoCalculadora_OperacionDivision
      jmp ModoCaluladora_PedirNumerosHastaLaMuerte

      ModoCalculadora_OperacionSuma:
      mov ax, intNumeroUno
      mov bx, intNumeroDos
      add ax, bx
      mov intResultado, ax
      mov intTemporalResultadoImprimir, ax
      ;PrintLn intTemporalResultadoImprimir
      ;PrintLn msj_saltoLinea
      jmp ModoCaluladora_PedirNumerosHastaLaMuerte

      ModoCalculadora_OperacionResta:
      mov ax, intNumeroUno
      mov bx, intNumeroDos
      sub ax, bx
      mov intResultado, ax
      mov intTemporalResultadoImprimir, ax
      ;PrintLn intTemporalResultadoImprimir
      ;PrintLn msj_saltoLinea
      jmp ModoCaluladora_PedirNumerosHastaLaMuerte

      ModoCalculadora_OperacionMultiplicacion:
      xor ax, ax
      xor bx, bx
      mov dx, 0
      mov ax, intNumeroUno
      mov bx, intNumeroDos
      mul bx
      mov intResultado, ax
      mov intTemporalResultadoImprimir, ax
      ;PrintLn intTemporalResultadoImprimir
      ;PrintLn msj_saltoLinea
      jmp ModoCaluladora_PedirNumerosHastaLaMuerte

      ModoCalculadora_OperacionDivision:
      xor ax, ax
      xor bx, bx
      mov dx, 0

      mov ax, intNumeroUno
      sal al, 1
      jc ConvertirNumeroUnoPositivo
      mov ax,intNumeroUno; abandonado sin cambio
      mov intTemporalNumero1,ax
      jmp ConvertirNumero

      ConvertirNumeroUnoPositivo:
      mov ax,intNumeroUno; abandonado sin cambio
      mov intTemporalNumero1,ax
      neg intTemporalNumero1
      inc intContadorNegativos
      
      ConvertirNumero:
      mov ax, intNumeroDos
      sal al, 1
      jc ConvertirNumeroDosPositvo
      mov ax,intNumeroDos; abandonado sin cambio
      mov intTemporalNumero2,ax
      jmp RevisionDivisionTemporal

      ConvertirNumeroDosPositvo:
      mov ax, intNumeroDos
      mov intTemporalNumero2,ax
      neg intTemporalNumero2
      inc intContadorNegativos
      jmp RevisionDivisionTemporal


      RevisionDivisionTemporal:
      mov ax, intTemporalNumero1
      mov bx, intTemporalNumero2
      div bx
      mov intResultado, ax
      mov intTemporalResultadoImprimir,ax

      cmp intContadorNegativos,1
      je ConvertirResultadoNegativo
      jmp FinalizarRevisionDivision

      ConvertirResultadoNegativo:
      neg intResultado
      neg intTemporalResultadoImprimir
      jmp FinalizarRevisionDivision

      FinalizarRevisionDivision:
      ;PrintLn intTemporalResultadoImprimir
      ;PrintLn msj_saltoLinea
      jmp ModoCaluladora_PedirNumerosHastaLaMuerte

      
      ModoCaluladora_PedirNumerosHastaLaMuerte:
      
      ValidarPrimerNumeroCiclo:
      ;;Obtiene el signo del primer numero
      mov ax,intResultado
      mov intNumeroUno,ax
      xor bx,bx
      mov bl,intContadorTemporalNumeros
      cmp vectorNumerosRecolectados[bx],'$'
      je ModoCaluladora_PedirNumerosFinal
      cmp vectorNumerosRecolectados[bx],' '
      je ModoCaluladora_PedirNumerosFinal
      mov intContadorNegativos, 0
      ;mov intResultado,0
      jmp ValidarSegundoNumero
      
      ;-------------------------------------------------------------------


      ModoCaluladora_PedirNumerosFinal:
      mov si, 0
      mov ax, intResultado
      sal al, 1
      jc ElValorEsNegativo
      jmp ElValorEsPositivo

      ElValorEsNegativo:
      mov vectorResultado[si], 45
      neg intTemporalResultadoImprimir
      jmp ImprimirResultado

      ElValorEsPositivo:
      mov vectorResultado[si], 43
      jmp ImprimirResultado

      ImprimirResultado:
      mov ax, intTemporalResultadoImprimir
      aam
      mov bh, al
      mov al, ah
      aam
      add al, 048
      add bh, 048
      add ah, 048
      mov vectorResultado[si+1], ah
      mov vectorResultado[si+2], al
      mov vectorResultado[si+3], bh
      PrintLn vectorResultado
      call PreguntarSiGuardaOperacion
      call LimpiarVariablesNuevoIngreso
      Pausa
      jmp Menu

;----------------------------- TODO ESTO ES IMPORTANTE NO LO TOQUES SIN PREGUNTAR --------------------------------------------------------
;----------------------------- Chish nene caca popo --------------------------------------------------------
   
   ;-------------------------- Pregunta si debe guardar el resultado o no ----------------------------------
   PreguntarSiGuardaOperacion proc near
   InicioPregunta:
   PrintLn msj_modocalculadora_guardar_pregunta
   call ReadLn
   xor bx, bx
   mov bl, 0
   cmp vectorLectura[bx], 83
   je GuardarOperacion
   cmp vectorLectura[bx], 115
   je GuardarOperacion
   cmp vectorLectura[bx], 78
   je Menu
   cmp vectorLectura[bx], 110
   je Menu
   jmp InicioPregunta
   
   GuardarOperacion:
   xor bx, bx
   mov bl, 0
   cmp vectorOperacionAlmacenadaUno[bx+1], ' '
   je UsarVariablesUno
   cmp vectorOperacionAlmacenadaDos[bx+1], ' '
   je UsarVariablesDos
   cmp vectorOperacionAlmacenadaTres[bx+1], ' '
   je UsarVariablesTres
   cmp vectorOperacionAlmacenadaCuatro[bx+1], ' '
   je UsarVariablesCuatro
   cmp vectorOperacionAlmacenadaCinco[bx+1], ' '
   je UsarVariablesCinco
   cmp vectorOperacionAlmacenadaSeis[bx+1], ' '
   je UsarVariablesSeis
   cmp vectorOperacionAlmacenadaSiete[bx+1], ' '
   je UsarVariablesSiete
   cmp vectorOperacionAlmacenadaOcho[bx+1], ' '
   je UsarVariablesOcho
   cmp vectorOperacionAlmacenadaNueve[bx+1], ' '
   je UsarVariablesNueve
   cmp vectorOperacionAlmacenadaDiez[bx+1], ' '
   je UsarVariablesDiez
   jmp ImpresionMensajeYaNoHayEspacio

;========================================================================= UNO =====================================================
   UsarVariablesUno:
   mov si, 0 ;Numeros
   mov di, 0 ;Concatenar
   mov cx, 11

   EtiquetaVariableNumeros1:
   xor ax,ax
   mov al,vectorNumerosRecolectados[si]
   cmp al,SIGNO_NEGATIVO
   je SignoNegativoVar1
   jmp SignoPositivoVar1
   
   SignoNegativoVar1:
   mov vectorOperacionAlmacenadaUno[di], al
   
   SignoPositivoVar1:
   mov vectorOperacionAlmacenadaUno[di], ' '
   jmp NumeroVar1
   NumeroVar1:
   inc si
   inc di

   ;Numero divison ---
   xor ax,ax
   mov al,vectorNumerosRecolectados[si]
   cmp al, 32
   jne NoesEspacioEnBlanco1
   mov vectorOperacionAlmacenadaUno[di], 32
   mov vectorOperacionAlmacenadaUno[di+1], 32
   jmp SiesEspacioEnBlanco1
   NoesEspacioEnBlanco1:
      aam
      mov bh, al
      mov al, ah
      aam
      add al, 048
      add bh, 048
      add ah, 048 ;123
   mov vectorOperacionAlmacenadaUno[di], al
   mov vectorOperacionAlmacenadaUno[di+1], bh

   SiesEspacioEnBlanco1:
   inc si
   inc di
   inc di
   inc di
   loop EtiquetaVariableNumeros1

   mov si, 0 ;Numeros
   mov di, 3 ;Concatenar
   mov cx, 10
   EtiquetaVariableOperadores1:
   mov al,vectorOperadoresRecolectados[si]
   mov vectorOperacionAlmacenadaUno[di], al
   inc si
   inc di
   inc di
   inc di
   inc di
   loop EtiquetaVariableOperadores1

   mov si, 0 ;Numeros
   mov di, 0 ;Concatenar
   mov cx, 4
   EtiquetaVariableResultado1:
   mov al,vectorResultado[si]
   mov intResultadoAlmacenadoUno[di], al
   inc si
   inc di
   loop EtiquetaVariableResultado1
   jmp PreguntarSiGuardaOperacionFinal
;====================================================================================== UNO ================================================

;=================================================================================== DOS ====================================================
   UsarVariablesDos:
   mov si, 0 ;Numeros
   mov di, 0 ;Concatenar
   mov cx, 11

   EtiquetaVariableNumeros2:
   xor ax,ax
   mov al,vectorNumerosRecolectados[si]
   cmp al,SIGNO_NEGATIVO
   je SignoNegativoVar2
   jmp SignoPositivoVar2
   
   SignoNegativoVar2:
   mov vectorOperacionAlmacenadaDos[di], al
   
   SignoPositivoVar2:
   mov vectorOperacionAlmacenadaDos[di], ' '
   jmp NumeroVar2
   NumeroVar2:
   inc si
   inc di

   ;Numero divison ---
   xor ax,ax
   mov al,vectorNumerosRecolectados[si]
   cmp al, 32
   jne NoesEspacioEnBlanco2
   mov vectorOperacionAlmacenadaDos[di], 32
   mov vectorOperacionAlmacenadaDos[di+1], 32
   jmp SiesEspacioEnBlanco2
   NoesEspacioEnBlanco2:
      aam
      mov bh, al
      mov al, ah
      aam
      add al, 048
      add bh, 048
      add ah, 048 ;123
   mov vectorOperacionAlmacenadaDos[di], al
   mov vectorOperacionAlmacenadaDos[di+1], bh

   SiesEspacioEnBlanco2:
   inc si
   inc di
   inc di
   inc di
   loop EtiquetaVariableNumeros2

   mov si, 0 ;Numeros
   mov di, 3 ;Concatenar
   mov cx, 10
   EtiquetaVariableOperadores2:
   mov al,vectorOperadoresRecolectados[si]
   mov vectorOperacionAlmacenadaDos[di], al
   inc si
   inc di
   inc di
   inc di
   inc di
   loop EtiquetaVariableOperadores2

   mov si, 0 ;Numeros
   mov di, 0 ;Concatenar
   mov cx, 4
   EtiquetaVariableResultado2:
   mov al,vectorResultado[si]
   mov intResultadoAlmacenadoDos[di], al
   inc si
   inc di
   loop EtiquetaVariableResultado2
   jmp PreguntarSiGuardaOperacionFinal
;======================================================================== DOS =============================================

;=================================================================== TRES =========================================================
   UsarVariablesTres:
   mov si, 0 ;Numeros
   mov di, 0 ;Concatenar
   mov cx, 11

   EtiquetaVariableNumeros3:
   xor ax,ax
   mov al,vectorNumerosRecolectados[si]
   cmp al,SIGNO_NEGATIVO
   je SignoNegativoVar3
   jmp SignoPositivoVar3
   
   SignoNegativoVar3:
   mov vectorOperacionAlmacenadaTres[di], al
   
   SignoPositivoVar3:
   mov vectorOperacionAlmacenadaTres[di], ' '
   jmp NumeroVar3
   NumeroVar3:
   inc si
   inc di

   ;Numero divison ---
   xor ax,ax
   mov al,vectorNumerosRecolectados[si]
   cmp al, 32
   jne NoesEspacioEnBlanco3
   mov vectorOperacionAlmacenadaTres[di], 32
   mov vectorOperacionAlmacenadaTres[di+1], 32
   jmp SiesEspacioEnBlanco3
   NoesEspacioEnBlanco3:
      aam
      mov bh, al
      mov al, ah
      aam
      add al, 048
      add bh, 048
      add ah, 048 ;123
   mov vectorOperacionAlmacenadaTres[di], al
   mov vectorOperacionAlmacenadaTres[di+1], bh

   SiesEspacioEnBlanco3:
   inc si
   inc di
   inc di
   inc di
   loop EtiquetaVariableNumeros3

   mov si, 0 ;Numeros
   mov di, 3 ;Concatenar
   mov cx, 10
   EtiquetaVariableOperadores3:
   mov al,vectorOperadoresRecolectados[si]
   mov vectorOperacionAlmacenadaTres[di], al
   inc si
   inc di
   inc di
   inc di
   inc di
   loop EtiquetaVariableOperadores3

   mov si, 0 ;Numeros
   mov di, 0 ;Concatenar
   mov cx, 4
   EtiquetaVariableResultado3:
   mov al,vectorResultado[si]
   mov intResultadoAlmacenadoTres[di], al
   inc si
   inc di
   loop EtiquetaVariableResultado3
   jmp PreguntarSiGuardaOperacionFinal
   ;============================================================================ TRES ================================================

   ;==================================================================== CUATRO ======================================================
   UsarVariablesCuatro:
   mov si, 0 ;Numeros
   mov di, 0 ;Concatenar
   mov cx, 11

   EtiquetaVariableNumeros4:
   xor ax,ax
   mov al,vectorNumerosRecolectados[si]
   cmp al,SIGNO_NEGATIVO
   je SignoNegativoVar4
   jmp SignoPositivoVar4
   
   SignoNegativoVar4:
   mov vectorOperacionAlmacenadaCuatro[di], al
   
   SignoPositivoVar4:
   mov vectorOperacionAlmacenadaCuatro[di], ' '
   jmp NumeroVar4
   NumeroVar4:
   inc si
   inc di

   ;Numero divison ---
   xor ax,ax
   mov al,vectorNumerosRecolectados[si]
   cmp al, 32
   jne NoesEspacioEnBlanco4
   mov vectorOperacionAlmacenadaCuatro[di], 32
   mov vectorOperacionAlmacenadaCuatro[di+1], 32
   jmp SiesEspacioEnBlanco4
   NoesEspacioEnBlanco4:
      aam
      mov bh, al
      mov al, ah
      aam
      add al, 048
      add bh, 048
      add ah, 048 ;123
   mov vectorOperacionAlmacenadaCuatro[di], al
   mov vectorOperacionAlmacenadaCuatro[di+1], bh

   SiesEspacioEnBlanco4:
   inc si
   inc di
   inc di
   inc di
   loop EtiquetaVariableNumeros4

   mov si, 0 ;Numeros
   mov di, 3 ;Concatenar
   mov cx, 10
   EtiquetaVariableOperadores4:
   mov al,vectorOperadoresRecolectados[si]
   mov vectorOperacionAlmacenadaCuatro[di], al
   inc si
   inc di
   inc di
   inc di
   inc di
   loop EtiquetaVariableOperadores4

   mov si, 0 ;Numeros
   mov di, 0 ;Concatenar
   mov cx, 4
   EtiquetaVariableResultado4:
   mov al,vectorResultado[si]
   mov intResultadoAlmacenadoCuatro[di], al
   inc si
   inc di
   loop EtiquetaVariableResultado4
   jmp PreguntarSiGuardaOperacionFinal
   ;==================================================================== CUATRO ==============================================================

   ;=================================================================== CINCO =================================================================
   UsarVariablesCinco:
   mov si, 0 ;Numeros
   mov di, 0 ;Concatenar
   mov cx, 11

   EtiquetaVariableNumeros5:
   xor ax,ax
   mov al,vectorNumerosRecolectados[si]
   cmp al,SIGNO_NEGATIVO
   je SignoNegativoVar5
   jmp SignoPositivoVar5
   
   SignoNegativoVar5:
   mov vectorOperacionAlmacenadaCinco[di], al
   
   SignoPositivoVar5:
   mov vectorOperacionAlmacenadaCinco[di], ' '
   jmp NumeroVar5
   NumeroVar5:
   inc si
   inc di

   ;Numero divison ---
   xor ax,ax
   mov al,vectorNumerosRecolectados[si]
   cmp al, 32
   jne NoesEspacioEnBlanco5
   mov vectorOperacionAlmacenadaCinco[di], 32
   mov vectorOperacionAlmacenadaCinco[di+1], 32
   jmp SiesEspacioEnBlanco5
   NoesEspacioEnBlanco5:
      aam
      mov bh, al
      mov al, ah
      aam
      add al, 048
      add bh, 048
      add ah, 048 ;123
   mov vectorOperacionAlmacenadaCinco[di], al
   mov vectorOperacionAlmacenadaCinco[di+1], bh

   SiesEspacioEnBlanco5:
   inc si
   inc di
   inc di
   inc di
   loop EtiquetaVariableNumeros5

   mov si, 0 ;Numeros
   mov di, 3 ;Concatenar
   mov cx, 10
   EtiquetaVariableOperadores5:
   mov al,vectorOperadoresRecolectados[si]
   mov vectorOperacionAlmacenadaCinco[di], al
   inc si
   inc di
   inc di
   inc di
   inc di
   loop EtiquetaVariableOperadores5

   mov si, 0 ;Numeros
   mov di, 0 ;Concatenar
   mov cx, 4
   EtiquetaVariableResultado5:
   mov al,vectorResultado[si]
   mov intResultadoAlmacenadoCinco[di], al
   inc si
   inc di
   loop EtiquetaVariableResultado5
   jmp PreguntarSiGuardaOperacionFinal
   ;============================================================= CINCO ======================================================================

   ;============================================================= SEIS ======================================================================
   UsarVariablesSeis:
   mov si, 0 ;Numeros
   mov di, 0 ;Concatenar
   mov cx, 11

   EtiquetaVariableNumeros6:
   xor ax,ax
   mov al,vectorNumerosRecolectados[si]
   cmp al,SIGNO_NEGATIVO
   je SignoNegativoVar6
   jmp SignoPositivoVar6
   
   SignoNegativoVar6:
   mov vectorOperacionAlmacenadaSeis[di], al
   
   SignoPositivoVar6:
   mov vectorOperacionAlmacenadaSeis[di], ' '
   jmp NumeroVar6
   NumeroVar6:
   inc si
   inc di

   ;Numero divison ---
   xor ax,ax
   mov al,vectorNumerosRecolectados[si]
   cmp al, 32
   jne NoesEspacioEnBlanco6
   mov vectorOperacionAlmacenadaSeis[di], 32
   mov vectorOperacionAlmacenadaSeis[di+1], 32
   jmp SiesEspacioEnBlanco6
   NoesEspacioEnBlanco6:
      aam
      mov bh, al
      mov al, ah
      aam
      add al, 048
      add bh, 048
      add ah, 048 ;123
   mov vectorOperacionAlmacenadaSeis[di], al
   mov vectorOperacionAlmacenadaSeis[di+1], bh

   SiesEspacioEnBlanco6:
   inc si
   inc di
   inc di
   inc di
   loop EtiquetaVariableNumeros6

   mov si, 0 ;Numeros
   mov di, 3 ;Concatenar
   mov cx, 10
   EtiquetaVariableOperadores6:
   mov al,vectorOperadoresRecolectados[si]
   mov vectorOperacionAlmacenadaSeis[di], al
   inc si
   inc di
   inc di
   inc di
   inc di
   loop EtiquetaVariableOperadores6

   mov si, 0 ;Numeros
   mov di, 0 ;Concatenar
   mov cx, 4
   EtiquetaVariableResultado6:
   mov al,vectorResultado[si]
   mov intResultadoAlmacenadoSeis[di], al
   inc si
   inc di
   loop EtiquetaVariableResultado6
   jmp PreguntarSiGuardaOperacionFinal
   ;=============================================================== SEIS =================================================================

   ;=============================================================== SIETE ================================================================
   UsarVariablesSiete:
   mov si, 0 ;Numeros
   mov di, 0 ;Concatenar
   mov cx, 11

   EtiquetaVariableNumeros7:
   xor ax,ax
   mov al,vectorNumerosRecolectados[si]
   cmp al,SIGNO_NEGATIVO
   je SignoNegativoVar7
   jmp SignoPositivoVar7
   
   SignoNegativoVar7:
   mov vectorOperacionAlmacenadaSiete[di], al
   
   SignoPositivoVar7:
   mov vectorOperacionAlmacenadaSiete[di], ' '
   jmp NumeroVar7
   NumeroVar7:
   inc si
   inc di

   ;Numero divison ---
   xor ax,ax
   mov al,vectorNumerosRecolectados[si]
   cmp al, 32
   jne NoesEspacioEnBlanco7
   mov vectorOperacionAlmacenadaSiete[di], 32
   mov vectorOperacionAlmacenadaSiete[di+1], 32
   jmp SiesEspacioEnBlanco7
   NoesEspacioEnBlanco7:
      aam
      mov bh, al
      mov al, ah
      aam
      add al, 048
      add bh, 048
      add ah, 048 ;123
   mov vectorOperacionAlmacenadaSiete[di], al
   mov vectorOperacionAlmacenadaSiete[di+1], bh

   SiesEspacioEnBlanco7:
   inc si
   inc di
   inc di
   inc di
   loop EtiquetaVariableNumeros7

   mov si, 0 ;Numeros
   mov di, 3 ;Concatenar
   mov cx, 10
   EtiquetaVariableOperadores7:
   mov al,vectorOperadoresRecolectados[si]
   mov vectorOperacionAlmacenadaSiete[di], al
   inc si
   inc di
   inc di
   inc di
   inc di
   loop EtiquetaVariableOperadores7

   mov si, 0 ;Numeros
   mov di, 0 ;Concatenar
   mov cx, 4
   EtiquetaVariableResultado7:
   mov al,vectorResultado[si]
   mov intResultadoAlmacenadoSiete[di], al
   inc si
   inc di
   loop EtiquetaVariableResultado7
   jmp PreguntarSiGuardaOperacionFinal
   ;============================================================== SIETE ============================================================

   ;=========================================================================== OCHO =================================================
   UsarVariablesOcho:
   mov si, 0 ;Numeros
   mov di, 0 ;Concatenar
   mov cx, 11

   EtiquetaVariableNumeros8:
   xor ax,ax
   mov al,vectorNumerosRecolectados[si]
   cmp al,SIGNO_NEGATIVO
   je SignoNegativoVar8
   jmp SignoPositivoVar8
   
   SignoNegativoVar8:
   mov vectorOperacionAlmacenadaOcho[di], al
   
   SignoPositivoVar8:
   mov vectorOperacionAlmacenadaOcho[di], ' '
   jmp NumeroVar8
   NumeroVar8:
   inc si
   inc di

   ;Numero divison ---
   xor ax,ax
   mov al,vectorNumerosRecolectados[si]
   cmp al, 32
   jne NoesEspacioEnBlanco8
   mov vectorOperacionAlmacenadaOcho[di], 32
   mov vectorOperacionAlmacenadaOcho[di+1], 32
   jmp SiesEspacioEnBlanco8
   NoesEspacioEnBlanco8:
      aam
      mov bh, al
      mov al, ah
      aam
      add al, 048
      add bh, 048
      add ah, 048 ;123
   mov vectorOperacionAlmacenadaOcho[di], al
   mov vectorOperacionAlmacenadaOcho[di+1], bh

   SiesEspacioEnBlanco8:
   inc si
   inc di
   inc di
   inc di
   loop EtiquetaVariableNumeros8

   mov si, 0 ;Numeros
   mov di, 3 ;Concatenar
   mov cx, 10
   EtiquetaVariableOperadores8:
   mov al,vectorOperadoresRecolectados[si]
   mov vectorOperacionAlmacenadaOcho[di], al
   inc si
   inc di
   inc di
   inc di
   inc di
   loop EtiquetaVariableOperadores8

   mov si, 0 ;Numeros
   mov di, 0 ;Concatenar
   mov cx, 4
   EtiquetaVariableResultado8:
   mov al,vectorResultado[si]
   mov intResultadoAlmacenadoOcho[di], al
   inc si
   inc di
   loop EtiquetaVariableResultado8
   jmp PreguntarSiGuardaOperacionFinal
   ;================================================================== OCHO =================================================================

   ;======================================================= NUEVE ==================================================================
   UsarVariablesNueve:
   mov si, 0 ;Numeros
   mov di, 0 ;Concatenar
   mov cx, 11

   EtiquetaVariableNumeros9:
   xor ax,ax
   mov al,vectorNumerosRecolectados[si]
   cmp al,SIGNO_NEGATIVO
   je SignoNegativoVar9
   jmp SignoPositivoVar9
   
   SignoNegativoVar9:
   mov vectorOperacionAlmacenadaNueve[di], al
   
   SignoPositivoVar9:
   mov vectorOperacionAlmacenadaNueve[di], ' '
   jmp NumeroVar9
   NumeroVar9:
   inc si
   inc di

   ;Numero divison ---
   xor ax,ax
   mov al,vectorNumerosRecolectados[si]
   cmp al, 32
   jne NoesEspacioEnBlanco9
   mov vectorOperacionAlmacenadaNueve[di], 32
   mov vectorOperacionAlmacenadaNueve[di+1], 32
   jmp SiesEspacioEnBlanco9
   NoesEspacioEnBlanco9:
      aam
      mov bh, al
      mov al, ah
      aam
      add al, 048
      add bh, 048
      add ah, 048 ;123
   mov vectorOperacionAlmacenadaNueve[di], al
   mov vectorOperacionAlmacenadaNueve[di+1], bh

   SiesEspacioEnBlanco9:
   inc si
   inc di
   inc di
   inc di
   loop EtiquetaVariableNumeros9

   mov si, 0 ;Numeros
   mov di, 3 ;Concatenar
   mov cx, 10
   EtiquetaVariableOperadores9:
   mov al,vectorOperadoresRecolectados[si]
   mov vectorOperacionAlmacenadaNueve[di], al
   inc si
   inc di
   inc di
   inc di
   inc di
   loop EtiquetaVariableOperadores9

   mov si, 0 ;Numeros
   mov di, 0 ;Concatenar
   mov cx, 4
   EtiquetaVariableResultado9:
   mov al,vectorResultado[si]
   mov intResultadoAlmacenadoNueve[di], al
   inc si
   inc di
   loop EtiquetaVariableResultado9
   jmp PreguntarSiGuardaOperacionFinal
   ;================================================================= NUEVE ===========================================================

   ;================================================= DIEZ ============================================================================
   UsarVariablesDiez:
   mov si, 0 ;Numeros
   mov di, 0 ;Concatenar
   mov cx, 11

   EtiquetaVariableNumeros10:
   xor ax,ax
   mov al,vectorNumerosRecolectados[si]
   cmp al,SIGNO_NEGATIVO
   je SignoNegativoVar10
   jmp SignoPositivoVar10
   
   SignoNegativoVar10:
   mov vectorOperacionAlmacenadaDiez[di], al
   
   SignoPositivoVar10:
   mov vectorOperacionAlmacenadaDiez[di], ' '
   jmp NumeroVar10
   NumeroVar10:
   inc si
   inc di

   ;Numero divison ---
   xor ax,ax
   mov al,vectorNumerosRecolectados[si]
   cmp al, 32
   jne NoesEspacioEnBlanco10
   mov vectorOperacionAlmacenadaDiez[di], 32
   mov vectorOperacionAlmacenadaDiez[di+1], 32
   jmp SiesEspacioEnBlanco10
   NoesEspacioEnBlanco10:
      aam
      mov bh, al
      mov al, ah
      aam
      add al, 048
      add bh, 048
      add ah, 048 ;123
   mov vectorOperacionAlmacenadaDiez[di], al
   mov vectorOperacionAlmacenadaDiez[di+1], bh

   SiesEspacioEnBlanco10:
   inc si
   inc di
   inc di
   inc di
   loop EtiquetaVariableNumeros10

   mov si, 0 ;Numeros
   mov di, 3 ;Concatenar
   mov cx, 10
   EtiquetaVariableOperadores10:
   mov al,vectorOperadoresRecolectados[si]
   mov vectorOperacionAlmacenadaDiez[di], al
   inc si
   inc di
   inc di
   inc di
   inc di
   loop EtiquetaVariableOperadores10

   mov si, 0 ;Numeros
   mov di, 0 ;Concatenar
   mov cx, 4
   EtiquetaVariableResultado10:
   mov al,vectorResultado[si]
   mov intResultadoAlmacenadoDiez[di], al
   inc si
   inc di
   loop EtiquetaVariableResultado10
   jmp PreguntarSiGuardaOperacionFinal
   ;============================================================ DIEZ =======================================================
   ImpresionMensajeYaNoHayEspacio:
   PrintLn msj_modocalculadora_error_SinEspacio

   PreguntarSiGuardaOperacionFinal:
   ret
   PreguntarSiGuardaOperacion endp
   ;-------------- [Etiqueta donde se generan las peticiones de los numeros] ------------

;------------------ Procedimiento para limpiar variables ------------------------

   LimpiarVectorNumerosRecolectados proc near
   mov si, 0
   mov cx, 23
   Etiqueta1:
   mov vectorNumerosRecolectados[si], ' '
   inc si
   loop Etiqueta1
   LimpiarVectorNumerosRecolectadosFinal:
   ret
   LimpiarVectorNumerosRecolectados endp

   LimpiarVectorOperadoresRecolectados proc near
   mov si, 0
   mov cx, 10
   Etiqueta1:
   mov vectorOperadoresRecolectados[si], ' '
   inc si
   loop Etiqueta1
   LimpiarVectorOperadoresRecolectadosFinal:
   ret
   LimpiarVectorOperadoresRecolectados endp


   LimpiarVariablesNuevoIngreso proc near

   mov boolYaTengoUnNumero, 0
   mov intPrimerNumero, 0
   ;mov intCadenaValida, 0
   ;mov intNumeroValido, 0 
   mov intNumeroDecimal, 0
   
   call LimpiarVectorNumerosRecolectados
   ;mov si, offset vectorNumerosRecolectadosCLON
   ;mov di, offset vectorNumerosRecolectados
   ;mov cx, 23
   ;rep movsb
   
   call LimpiarVectorOperadoresRecolectados
   ;mov si, offset vectorOperadoresRecolectadosCLON
   ;mov di, offset vectorOperadoresRecolectados
   ;mov cx, 10
   ;rep movsb


   mov intContadorNumerosRecolectados, 0
   mov intContadorOperadoresRecolectados, 0

   mov intContadorTemporalOperadores, 0
   mov intContadorTemporalNumeros, 0

   mov intNumeroUno, 0
   mov intNumeroDos, 0
   ;mov intResultado, 0
   ;vectorResultados db 20 dup(' '), "$"
   mov intContadorResultados, 0
   mov intTemporalResultadoImprimir, 0


   mov intContadorNegativos, 0
   mov intTemporalNumero1, 0
   mov intTemporalNumero2, 0

   LimpiarVariablesNuevoIngresoFinal:
   ret
   LimpiarVariablesNuevoIngreso endp
   ;-------- Metodo para guardar el numero recibido
   GuardarNumero proc near
   mov bh,0
   mov bl, intContadorNumerosRecolectados

   mov al, vectorLectura[0]
   cmp al, SIGNO_NEGATIVO
   je AsignarSignoNegativo
   jmp AsignarSignoPositivo

   AsignarSignoNegativo:
   mov vectorNumerosRecolectados[bx], 45
   jmp SignoAsignado

   AsignarSignoPositivo:
   mov vectorNumerosRecolectados[bx], 43
   jmp SignoAsignado
   

   SignoAsignado:
   mov bh,0
   mov bl, intContadorNumerosRecolectados
   add bl, 1
   mov ax, 0
   mov ax, intNumeroDecimal; ax= ah=0|al=intNumeroDecimal
   mov intContadorNumerosRecolectados, bl 
   mov vectorNumerosRecolectados[bx], al


   ;PrintLn vectorNumerosRecolectados
   ;PrintLn msj_saltoLinea
   ;PrintLn intNumeroDecimal
   ;PrintLn msj_saltoLinea
   ;PrintLn intContadorNumerosRecolectados

   GuardarNumeroFinal:
   ret
   GuardarNumero endp

;Para validar los nuemeros que entraron
   ValidarNumeros proc near
   
      mov ax, 0
      mov si, 0
      mov al, vectorLectura[si]
      cmp al, SIGNO_NEGATIVO
      je NumeroNegativo
      jmp NumeroNormal

   NumeroNegativo:
      mov si,2
      mov al, vectorLectura[si]
      cmp al, VALOR_RETORNO
      je UnidadNegativa
      jmp DecenaNegativa

   UnidadNegativa:
   mov si,1
   call MetodoUnidad
   jmp ValidarNumerosFinal
      
   DecenaNegativa:
   mov si,1
   call MetodoDecena
   mov si,2
   call MetodoUnidad
   jmp ValidarNumerosFinal

   NumeroNormal:
      mov ax,0;limpiar AX
      mov si,1
      mov al, vectorLectura[si]
      cmp al, VALOR_RETORNO
      je UnidadNormal
      jmp DecenaNormal

   UnidadNormal:
      mov si,0
      call MetodoUnidad
      jmp ValidarNumerosFinal

   DecenaNormal:
      mov si,0
      call MetodoDecena
      mov si,1
      call MetodoUnidad
      jmp ValidarNumerosFinal

   ValidarNumerosFinal:

      ret
   ValidarNumeros endp

;--------------------Metodo para generar Unidades
   MetodoUnidad proc near
    ;mov si,1
    mov ax, 0;limpiando Ax=0 |ah=0|al=0
    mov al,vectorLectura[si]
    mov intCadenaValida,al
    mov ax,0


    cmp intCadenaValida,48;-----------Es 0
    je Unidad0

    cmp intCadenaValida,49;-----------Es 1
    je Unidad1

    cmp intCadenaValida,50;-----------Es 2
    je Unidad2

    cmp intCadenaValida,51;-----------Es 3
    je Unidad3

    cmp intCadenaValida,52;-----------Es 4
    je Unidad4

    cmp intCadenaValida,53;-----------Es 5
    je Unidad5

    cmp intCadenaValida,54;-----------Es 6
    je Unidad6

    cmp intCadenaValida,55;-----------Es 7
    je Unidad7

    cmp intCadenaValida,56;-----------Es 8
    je Unidad8

    cmp intCadenaValida,57;-----------Es 9
    je Unidad9
    jmp MetodoUnidadFinal

    Unidad0:
    mov ax,intNumeroDecimal
    add ax,0
    mov intNumeroDecimal,ax
    jmp MetodoUnidadFinal

    Unidad1:
    mov ax,intNumeroDecimal
    add ax,1
    mov intNumeroDecimal,ax
    jmp MetodoUnidadFinal

    Unidad2:
    mov ax,intNumeroDecimal
    add ax,2
    mov intNumeroDecimal,ax    
    jmp MetodoUnidadFinal

    Unidad3:
    mov ax,intNumeroDecimal
    add ax,3
    mov intNumeroDecimal,ax
    jmp MetodoUnidadFinal

    Unidad4:
    mov ax,intNumeroDecimal
    add ax,4
    mov intNumeroDecimal,ax
    jmp MetodoUnidadFinal

    Unidad5:
    mov ax,intNumeroDecimal
    add ax,5
    mov intNumeroDecimal,ax
    jmp MetodoUnidadFinal

    Unidad6:
    mov ax,intNumeroDecimal
    add ax,6
    mov intNumeroDecimal,ax
    jmp MetodoUnidadFinal

    Unidad7:

    mov ax,intNumeroDecimal
    add ax,7
    mov intNumeroDecimal,ax
    jmp MetodoUnidadFinal

    Unidad8:
    mov ax,intNumeroDecimal
    add ax,8
    mov intNumeroDecimal,ax
    jmp MetodoUnidadFinal

    Unidad9:
    mov ax,intNumeroDecimal
    add ax,9
    mov intNumeroDecimal,ax
    jmp MetodoUnidadFinal


  MetodoUnidadFinal:

  ret

   MetodoUnidad endp
;--------------------Metodo para generar Decenas-----------------
   MetodoDecena proc near

   mov ax, 0 ;limpiando Ax=0 |ah=0|al=0
   mov al,vectorLectura[si]
   mov intCadenaValida,al


   cmp intCadenaValida,48;-----------Es 0
   je Decena0
   cmp intCadenaValida,49;-----------Es 10
   je Decena1
   cmp intCadenaValida,50;-----------Es 20
   je Decena2
   cmp intCadenaValida,51;-----------Es 30
   je Decena3
   cmp intCadenaValida,52;-----------Es 40
   je Decena4
   cmp intCadenaValida,53;-----------Es 50
   je Decena5
   cmp intCadenaValida,54;-----------Es 60
   je Decena6
   cmp intCadenaValida,55;-----------Es 70
   je Decena7
   cmp intCadenaValida,56;-----------Es 80
   je Decena8
   cmp intCadenaValida,57;-----------Es 90
   je Decena9
   jmp MetodoDecenaFinal
    Decena0:
    mov ax,intNumeroDecimal
    add ax,0
    mov intNumeroDecimal,ax
    jmp MetodoDecenaFinal

    Decena1:
    mov ax,intNumeroDecimal
    add ax,10
    mov intNumeroDecimal,ax
    jmp MetodoDecenaFinal

    Decena2:
    mov ax,intNumeroDecimal
    add ax,20
    mov intNumeroDecimal,ax    
    jmp MetodoDecenaFinal

    Decena3:
    mov ax,intNumeroDecimal
    add ax,30
    mov intNumeroDecimal,ax
    jmp MetodoDecenaFinal

    Decena4:
    mov ax,intNumeroDecimal
    add ax,40
    mov intNumeroDecimal,ax
    jmp MetodoDecenaFinal

    Decena5:
    mov ax,intNumeroDecimal
    add ax,50
    mov intNumeroDecimal,ax
    jmp MetodoDecenaFinal

    Decena6:
    mov ax,intNumeroDecimal
    add ax,60
    mov intNumeroDecimal,ax
    jmp MetodoDecenaFinal

    Decena7:
    mov ax,intNumeroDecimal
    add ax,70
    mov intNumeroDecimal,ax
    jmp MetodoDecenaFinal

    Decena8:
    mov ax,intNumeroDecimal
    add ax,80
    mov intNumeroDecimal,ax
    jmp MetodoDecenaFinal

    Decena9:
    mov ax,intNumeroDecimal
    add ax,90
    mov intNumeroDecimal,ax
    jmp MetodoDecenaFinal
   MetodoDecenaFinal:

   ret
   MetodoDecena endp

;-------- [GUARDA LOS OPERADORES QUE VA LEYENDO EN EL MODO CALCULADORA]
   GuardarOperador proc near

   mov bh,0
   mov bl, intContadorOperadoresRecolectados

   mov al, vectorLectura[0]
   cmp al, SIGNO_POSITIVO
   je AsignarOperadorSuma
   cmp al, SIGNO_NEGATIVO
   je AsignarOperadorResta
   cmp al, SIGNO_MULTIPLICACION
   je AsignarOperadorMultiplicacion
   cmp al, SIGNO_DIVISION
   je AsignarOperadorDivision

   PrintLn msj_modocalculadora_error_Operador
   cmp boolYaTengoUnNumero, 0
   je PerdirOperadorPrimero
   jmp PedirOperadorSegundo

   AsignarOperadorSuma:
   mov vectorOperadoresRecolectados[bx], 43
   jmp GuardarOperadorFinal

   AsignarOperadorResta:
   mov vectorOperadoresRecolectados[bx], 45
   jmp GuardarOperadorFinal

   AsignarOperadorMultiplicacion:
   mov vectorOperadoresRecolectados[bx], 42
   jmp GuardarOperadorFinal
   AsignarOperadorDivision:
   mov vectorOperadoresRecolectados[bx], 47
   jmp GuardarOperadorFinal

   GuardarOperadorFinal:
   mov ax,0
   mov al,intContadorOperadoresRecolectados
   add al,1
   mov intContadorOperadoresRecolectados,al

   ;PrintLn vectorOperadoresRecolectados
   ;PrintLn msj_saltoLinea

   ret
   GuardarOperador endp
   ;-------- [GUARDA LOS OPERADORES QUE VA LEYENDO EN EL MODO CALCULADORA]

   menu_Factorial:
      Clear
      PrintLn msj_modofactorial_PedirNumero
      call CalcularFactorial
      jmp Menu

   ;=================================== factorial =============================================
   CalcularFactorial proc near
      call ReadLn
      mov intNumeroDecimal, 0 ;Para limpiar la variable
      mov intResultadoFactorial, 1
      call ValidarNumeros

      xor ax, ax
      mov ax, intNumeroDecimal
      cmp al, 0
      je FactorialCero
      ;cmp al, 1
      ;je FactorialCero
      mov di, 0
      mov ax, intResultadoFactorial
      aam
      mov bh, al
      mov al, ah
      aam
      add al, 048
      add bh, 048
      add ah, 048
      mov msj_Operacion_Resultado_cero[di+3], bh
      PrintLn msj_Operacion_Resultado
      PrintLn msj_Operacion_Resultado_cero
      xor ax, ax
      mov ax, intNumeroDecimal
      mov di, 0
      mov si, 1
      mov cx, ax
      EtiquetaEjecutarFactorial:
      xor bx, bx
      mov ax, si
      mov di, 0
      aam
      mov bh, al
      mov al, ah
      aam
      add al, 048
      add bh, 048
      add ah, 048
      mov msj_Concatenacion_Resultado[di+0], bh
      mov msj_Concatenacion_Resultado[di+4], SIGNO_MULTIPLICACION
      mov msj_Concatenacion_Resultado[di+3], bh
      mov ax, intResultadoFactorial
      mov di, 0
      aam
      mov bh, al
      mov al, ah
      aam
      add al, 048
      add bh, 048
      add ah, 048
      mov msj_Concatenacion_Resultado[di+5], bh
      xor ax, ax
      xor bx, bx
      mov dx, 0
      mov ax, intResultadoFactorial
      mov bx, si
      mul bx
      mov intResultadoFactorial, ax
      mov ax, intResultadoFactorial
      mov di, 0
      aam
      mov bh, al
      mov al, ah
      aam
      add al, 048
      add bh, 048
      add ah, 048
      mov msj_Concatenacion_Resultado[di+7], ah
      mov msj_Concatenacion_Resultado[di+8], al
      mov msj_Concatenacion_Resultado[di+9], bh
      PrintLn msj_Concatenacion_Resultado
      inc si
      loop EtiquetaEjecutarFactorial
      jmp CalcularFactorialFinal
      
      FactorialCero:
      mov ax, intResultadoFactorial
      mov di, 0
      aam
      mov bh, al
      mov al, ah
      aam
      add al, 048
      add bh, 048
      add ah, 048
      mov msj_Operacion_Resultado_cero[di+3], bh
      PrintLn msj_Operacion_Resultado
      PrintLn msj_Operacion_Resultado_cero
      inc intNumeroDecimal
      jmp CalcularFactorialFinal
   CalcularFactorialFinal:
   mov si, 0
   mov ax, intResultadoFactorial
   aam
   mov bh, al
   mov al, ah
   aam
   add al, 048
   add bh, 048
   add ah, 048
   mov vectorResultado[si], SIGNO_POSITIVO
   mov vectorResultado[si+1], ah
   mov vectorResultado[si+2], al
   mov vectorResultado[si+3], bh
   PrintLn msj_Operacion_Resultado_Resultado
   PrintLn vectorResultado
   ret
   CalcularFactorial endp
   ;----------- Opcion del menu para ejecutar el reporte
   menu_CrearReporte:
      Clear
      ;PrintLn msj_opcion_menu_CrearReporte
      ;GENERAR REPORTE
      call CrearReporte
      jmp Menu
   ; hace el reporte
      CrearReporte proc near
      call EliminarReporte
      call CrearNuevoReporte
      call ObtenerFecha
      call ObtenerHora
      call SobreescribirReporte
      CrearReporteFinal:
      ret
      CrearReporte endp
;================================================== menu =============================================
;======================================= accion de eliminar el reporte ======================================
      EliminarReporte proc near
      mov ah,41h
      mov dx, offset HTML_NOMBRE_REPORTE
      int 21h 
      jc FinalHErrorElimado ;Si hubo error
      jnc FinalHSiEliminado

      FinalHErrorElimado:
      PrintLn msj_error_archivoNoEliminado
      jmp EliminarReporteFinal

      FinalHSiEliminado:
      PrintLn msj_warning_archivoEliminado
      jmp EliminarReporteFinal
      EliminarReporteFinal:
      ret
      EliminarReporte endp
;========================================================= accion eliminar reporte =============================================

;===========================================================================================================================
   CrearNuevoReporte proc near
   mov ah,3ch ;instrucción para crear el archivo.
   mov cx,0
   mov dx,offset HTML_NOMBRE_REPORTE  ;crea el archivo con el nombre archivo2.txt indicado indicado en la parte .data
   int 21h
   jc FinalHErrorCreado ;si no se pudo crear el archivo arroja un error, se captura con jc.
   jmp FinalHSiCreado

   FinalHSiCreado:
   PrintLn msjCreado
   mov bx,ax
   mov ah,3eh ;cierra el archivo
   int 21h
   ret
   FinalHErrorCreado:
   PrintLn msjNoCreado
   CrearNuevoReporteFinal:
   ret
   CrearNuevoReporte endp
   ;===========================================================================================================================


   ;=========================================================================================================================
   ObtenerFecha proc near
   mov ah,2ah
   int 21h

   mov intCalculardia,dl
   mov intCalcularmes,dh
   ;mov anio,cx
   ;------------Obtenemos Dia-------------------
   mov al,[intCalculardia]
   mov cl,10
   mov ah,0
   div cl
   or ax,3030h
   mov bx,offset HTML_FECHA_DIA
   mov [bx],al 
   inc bx
   mov [bx],ah
   inc bx
   mov HTML_FECHA_DIA[03],'/'
   ;-------------------Obtenemos MEs------------------

   mov al,[intCalcularmes]
   mov cl,10
   mov ah,0
   div cl
   or ax,3030h
   mov bx,offset HTML_FECHA_MES
   mov [bx],al 
   inc bx
   mov [bx],ah
   inc bx
   mov HTML_FECHA_MES[03],'/'
   ObtenerFechaFinal:
   ret
   ObtenerFecha endp
   ;================================================================================================================================


   ;=================================================================================================================================
   ObtenerHora proc near
   mov ah, 2Ch
   int 21h
   mov  intCalcularhora, ch
   mov  intCalcularmin, cl
   mov  intCalcularseg, dh
   ;------obtenemos hora--------------
   mov al, [intCalcularhora]
   mov cl, 10
   mov ah, 0
   div cl
   or ax, 3030h
   mov bx, offset HTML_HORA_HORA
   mov [bx], al
   inc bx
   mov [bx], ah
   inc bx
   mov HTML_HORA_HORA[03],':'
   ;--------------obtenemos min

   mov al,[intCalcularmin]
   mov cl,10
   mov ah,0
   div cl
   or ax,3030h
   mov bx,offset HTML_HORA_MIN
   mov [bx],al 
   inc bx
   mov [bx],ah
   inc bx
   mov HTML_HORA_MIN[03],':'

   ;--------------obteners seg

   mov al,[intCalcularseg]
   mov cl,10
   mov ah,0
   div cl
   or ax,3030h
   mov bx,offset HTML_HORA_SEG
   mov [bx],al 
   inc bx
   mov [bx],ah
   inc bx
   ObtenerHoraFinal:
   ret
   ObtenerHora endp
   ;======================================================================================================================================

   ;=========================================================================================================================================
   SobreescribirReporte proc near
   FinalHeditar:
   ;abrir el archivo
   mov ah,3dh
   mov al,1h ;Abrimos el archivo en solo escritura.
   mov dx,offset HTML_NOMBRE_REPORTE
   int 21h
   jc FinalHErrorAbrir ;Si hubo error

   
   mov si,1433;numero de caracteres en la cadena
   mov bx,ax ; mover hadfile
   mov cx,si ;num de caracteres a grabar
   mov dx,offset HTML_BANDERA
   mov ah,40h
   int 21h
   PrintLn msjEscrito
   
   mov ah,3eh  ;Cierre de archivo
   int 21h
   jmp FinalHFinalEditado

   FinalHErrorEditado:
   PrintLn msjNoEscrito
   ret

   FinalHErrorAbrir:
   PrintLn msjNoAbierto
   ret

   FinalHFinalEditado:
   ret
   SobreescribirReporte endp


   ;=========================================================================================================================================
   ;----------- Opcion del menu para salir de la aplicacion
   menu_Salir:
      Clear
      PrintLn msj_opcion_menu_Salir
      mov ah,04ch
      int 21h
      jmp Menu


   ;========================================= etiquetas para los erroes de la carga de archivos
   OpeningError: 
	    	print msgOpeningError
	    	getChr
	    	jmp Menu
        
        CreationError:
	    	print msgCreationError
	    	getChr
	    	jmp Menu

        ReadingError:
	    	print msgReadingError
	    	getChr
	    	jmp Menu
        
        WritingError:
	    	print msgWritingError
	    	getChr
	    	jmp Menu

        DeleteError:
	    	print msgDeleteError
	    	getChr
	    	jmp Menu

        CloseError:
	    	print msgCloseError
	    	getChr
	    	jmp Menu

;[fin]----------------------------- [Aqui si inicia el codigo de a deveritas] ---------------------------------
end