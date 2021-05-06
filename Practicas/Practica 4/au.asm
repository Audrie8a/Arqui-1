;-----------------------------------------------------MACROS
include macrostc.asm



;----------------------------------------------------DECLARACIONES
.model small

;----------------------------------------------------PILA
.stack

;----------------------------------------------------SEGMENTO DE DATOS
.data
     ;reporte
     HTML_BANDERA db '$ '
     rep0 db '<Arqui>',retorno
     rep1 db '<Encabezado>',retorno
     rep2 db '<Universidad>Universidad de San Carlos de Guatemala</Universidad>',retorno
     rep3 db '<Facultad>Facultad de Ingenieria</Facultad>',retorno
     rep4 db '<Escuela>Ciencias y Sistemas</Escuela>',retorno
     rep5 db '<Curso>',retorno
     rep6 db '<Nombre>Arquitectura de Computadores y Ensambladores 1</Nombre>',retorno
     rep7 db '<Seccion>Seccion B</Seccion>',retorno
     rep8 db '</Curso>',retorno
     rep9 db '<Ciclo>Primer Semestre 2021</Ciclo>',retorno
     rep10 db '<Fecha>',retorno
     rep11 db '<Dia>26</Dia>',retorno
     rep12 db '<Mes>03</Mes>',retorno
     rep13 db '<Año>2021</Año>',retorno
     rep14 db '</Fecha>',retorno
     rep15 db '<Hora>',retorno
     horaRep db 3 dup('$'), retorno
     minutoRep db 3 dup('$'), retorno
     segundoRep db 3 dup('$'), retorno
     rep16 db '</Hora>',retorno
     rep17 db '<Minutos>',retorno
     rep18 db '</Minutos>',retorno
     rep19 db '<Segundos>',retorno
     rep20 db '</Segundos>',retorno
     rep21 db '<Alumno>',retorno
     rep23 db '<Nombre>Audrie Annelisse del Cid Ochoa</Nombre>',retorno
     rep24 db '<Carnet>201801263</Carnet>',retorno
     rep25 db '</Alumno>',retorno
     rep26 db '</Encabezado>',retorno
     rep27 db '<Resultados>',retorno
     rep28 db '<Tipo>Ascendente</Tipo>',retorno
     rep29 db '<Lista_Entrada>',retorno
     rep30 db '</Lista_Entrada>',retorno
     rep31 db '<Lista_Ordenada>',retorno
     arregloOrdenado db 1000 dup ('$'),'$'
     rep32 db '</Lista_Ordenada>',retorno
     rep33 db '<Ordenamiento_BubbleSort>',retorno
     rep34 db '</Ordenamiento_BubbleSort>',retorno
     rep35 db '<Velocidad>',retorno
     rep36 db '</Velocidad>',retorno
     rep37 db '<Tiempo>',retorno
     rep38 db '</Tiempo>',retorno
     rep39 db '<Milisegundos>',retorno
     rep40 db '</Milisegundos>',retorno
     rep41 db '<Ordenamiento_Quicksort>',retorno
     rep42 db '</Ordenamiento_Quicksort>',retorno
     rep43 db '<Ordenamiento_Shellsort>',retorno
     rep44 db '</Ordenamiento_Shellsort>',retorno
     rep45 db '</Resultados>',retorno
     rep46 db '</Arqui>',retorno     
   	HTML_BANDERA_FIN db 'HASTA AQUI - NADA MAS - NO AVANCES MAS' 
     nombreRep db 'Reporte.xml',0
    ErroRep db 0ah,0dh , 'Error al crear el reporte!',"$"
    creadoRep db 0ah,0dh , 'Reporte creado!.',"$"
    errorEliminarRep db 0ah,0dh , 'Error al eliminar el archivo!.',"$"
    eliminarRep db 0ah,0dh, 'El archvio ha sido eliminado!',"$"
   
     dia db 0
    mes db 0
    hora db 0
    minutos db 0
    segundos db 0

     retorno equ 13
     salto equ 10
     ;Errores 
     err1 db 0ah,0dh, 'Error al abrir el archivo puede que no exista' , '$'
     err2 db 0ah,0dh, 'Error al cerrar el archivo' , '$'
     err3 db 0ah,0dh, 'Error al escribir en el archivo' , '$'
     err4 db 0ah,0dh, 'Error al crear en el archivo' , '$'
     err5 db 0ah,0dh, 'Error al leer en el archivo' , '$'
     ;Separacion
     Separacion0 db 0ah,0dh, '*-----------------------------------------------------*','$'
     guion db 0ah,0dh, '-', '$'
     ;Cadenas Encabezado
     encabezado0 db 0ah, 0dh, '        UNIVERSIDAD DE SAN CARLOS DE GUATEMALA        ','$'
     encabezado1 db 0ah, 0dh, '                FACULTAD DE INGENIERIA                ','$'
     encabezado2 db 0ah, 0dh, '            ESCUELA DE CIENCIAS Y SISTEMAS            ','$'
     encabezado3 db 0ah, 0dh, '    ARQUITECTURA DE COMPUTADORES Y ENSAMBLADORES 1    ','$'
     encabezado4 db 0ah, 0dh, '                       SECCION B                      ','$'
     encabezado5 db 0ah, 0dh, '        NOMBRE: Audrie Annelisse del Cid Ochoa        ','$'
     encabezado6 db 0ah, 0dh, '                  CARNET: 201801263                   ','$'
     encabezado7 db 0ah, 0dh, '                      PRACTICA 4                      ','$'
     ;Cadenas Menu
     menu0 db 0ah,0dh, '*********************MENU PRINCIPAL********************','$'
     menu1 db 0ah,0dh, '1.Cargar Archivo','$'
     menu2 db 0ah,0dh, '2.Ordenar','$'
     menu3 db 0ah,0dh, '3.Generar reporte','$'
     menu4 db 0ah,0dh, '4.Salir','$'
     msjSalir db 0ah, 0dh, 'Adios :)','$'
     prueba  db 0ah, 0dh, '1','$'
     ;Variables
     opcion db 0;
     lengthArreglo db 0;
     regresar db 0ah, 0dh, '0. Regresar Menu principal ','$'
     ;CargarArchivo
     menu01 db 0ah,0dh, '*********************CARGAR ARCHIVO********************','$'
     carga1 db 0ah,0dh, 'Ingrese una ruta de archivo' , 0ah,0dh, 'Ejemplo: entrada.txt' , '$'
     finCarga db 0ah,0dh, 'Archivo cargado exitosamente!', '$'
     bufferentrada db 50 dup('$')
     handlerentrada dw ?
     bufferInformacion db 1000 dup('$'),'$'
     numeros   db 1000 dup('$'),'$'
     contadorArreglo dw 0,'$'
     valorNumero db 2 dup('$')
     numeroReal db 1000 dup ('$')
     numero db "$$$$$$$$"
     u db "$$$$$$$$"
     d db "$$$$$$$$"
     auxContador db 0,'$'
     i db 0,'$'
     j db 0,'$'
     auxdi dw 0, '$'
     auxsi dw 0, '$'
     aux db 0,'$'
     sizeBuffer db 0,'$'
     unidad db 0;
     decena db 0;
     centena db 0;


     contador db 0;
     isNegativo db 0;
     numero2 db 0;
     num1A db 0;
     num1B db 0;
     ;Ordenar
     menu02 db 0ah,0dh, '*********************ORDENAR********************','$'
     ordenar1 db 0ah,0dh, '1. Ordenamiento Bubble Sort','$'
     ordenar2 db 0ah,0dh, '2. Ordenamiento QuickSort','$'
     ordenar3 db 0ah,0dh, '3. Ordenamiento ShellSort','$'
     msjVelocidad db 0ah,0dh, 'Ingrese una velocidad (0-9): ','$'
     menu5 db 0ah,0dh, 'Seleccione una opcion: ','$'
     msjAscendente db 0ah,0dh, '1.Ascendente','$'
     msjDescendente db 0ah,0dh, '2. Descendente','$'
     velocidad db 0
     
     arrayBurbuja db 1000 dup ('$'),'$'
     arrayShell db 1000 dup ('$'),'$'
     arrayQuick db 1000 dup ('$'),'$'
     arrayTexto db 1000 dup ('$'),'$'
     gap db 0
     aux2 db 0
     cociente db 0
     residuo db 0
     ancho db 0
     inicioAcumulado db 0
     actualAcumulado db 0
     xo db 0
     yo db 0
     yf db 0
     xf db 0
     color db 0

     cantidad db 0

     tamanoX         dw 0
     espacio         db 0
     espaciador      db 0
     maximo          dw 0b
     cantidad2      dw 0b
     tiempo          dw 500
     valor           db 20
     numerosMos      db 60 dup('$')
     max             db 0b
     espacio2        db 0b
     resultado       db 20 dup('$')
     ;Generar reporte
     menu03 db 0ah,0dh, '*********************GENERAR REPORTE********************','$'
;----------------------------------------------------SEGMENTO DE CODIGO
.code

main proc
     Encabezado:
          print Separacion0
          print encabezado0
          print encabezado1
          print encabezado2
          print encabezado3
          print encabezado4
          print encabezado5
          print encabezado6
          print encabezado7
          print Separacion0

          SaltoLinea
          SaltoLinea
          jmp MenuPrincipal
     MenuPrincipal:
          print menu0
          print menu1
          print menu2
          print menu3
          print menu4

          SaltoLinea
          getChar
          mov opcion, al

          cmp opcion, 31h
          je CargarArchivo

          cmp opcion, 32h
          je Ordenar

          cmp opcion, 33h
          je GenerarReporte

          cmp opcion, 34h
          je Salir


     CargarArchivo:
          SaltoLinea
          print menu01
          call AbrirArchivo

          jmp MenuPrincipal
     AbrirArchivo:
          print carga1
          SaltoLinea
          limpiar numeros, SIZEOF numeros,24h
          limpiar bufferentrada, SIZEOF bufferentrada,24h
          obtenerRuta bufferentrada
          abrir bufferentrada, handlerentrada
          limpiar bufferInformacion, SIZEOF bufferInformacion,24h
          leer handlerentrada, bufferInformacion, SIZEOF bufferInformacion
          call cerrarArchivo       
          obtenerNumeros bufferInformacion
          convertirNumero numeros  ;Resultados en el arreglo 
          longitudArreglo numeroReal
          print finCarga
          ret

     Ordenar:
          print menu02
          print ordenar1
          print ordenar2
          print ordenar3
          print regresar

          SaltoLinea
          getChar
          mov opcion, al

          cmp opcion, 31h
          je Burbuja

          cmp opcion, 32h
          je QuickSort

          cmp opcion, 33h
          je ShellSort

          cmp opcion, 30h
          je MenuPrincipal

          ret
     GenerarReporte:
          SaltoLinea
          print menu03
          
          ret
     Salir:
          SaltoLinea
          print msjSalir
          mov ah, 4ch
          xor al,al
          int 21h
     Burbuja:
          print msjVelocidad
          getChar
          sub al, 48
          mov velocidad, al
          SaltoLinea
          print menu5
          print msjAscendente
          print msjDescendente
          SaltoLinea
          getChar
          cmp al, 31h
          je BurbujaAscendente

          cmp al, 32h
          je BurbujaDescendente

     BurbujaAscendente:
          longitudArreglo numeroReal
          copiarArreglo numeroReal, arrayBurbuja
          SaltoLinea
          imprimirArreglo arrayBurbuja
          SaltoLinea
          BurbujaAsc arrayBurbuja
          SaltoLinea
          copiarArreglo arrayBurbuja, arregloOrdenado
          ;AnchoBarra
          ;DibujarBarras arrayBurbuja
          ;Graficar arrayBurbuja
          jmp MenuPrincipal
     BurbujaDescendente:
          longitudArreglo numeroReal
          copiarArreglo numeroReal, arrayBurbuja
          SaltoLinea
          imprimirArreglo arrayBurbuja
          SaltoLinea
          BurbujaDesc arrayBurbuja
          copiarArreglo arrayBurbuja, arregloOrdenado

          jmp MenuPrincipal

     QuickSort:
     	 print msjVelocidad
          getChar
          sub al, 48
          mov velocidad, al
          SaltoLinea
          print menu5
          print msjAscendente
          print msjDescendente
          SaltoLinea
          getChar
          cmp al, 31h
          je QuickSortAsc

          cmp al, 32h
          je QuickSortDesc
     QuickSortAsc:
     	  longitudArreglo numeroReal
          copiarArreglo arrayQuick, arrayBurbuja
          jmp MenuPrincipal
     QuickSortDesc:
          longitudArreglo numeroReal
          copiarArreglo arrayQuick, arrayBurbuja
          jmp MenuPrincipal
     ShellSort:
     	  print msjVelocidad
          getChar
          sub al, 48
          mov velocidad, al
          SaltoLinea
          print menu5
          print msjAscendente
          print msjDescendente
          SaltoLinea
          getChar
          cmp al, 31h
          je ShellSortAsc

          cmp al, 32h
          je ShellSortDesc
     ShellSortAsc:
     	 longitudArreglo numeroReal
     	 copiarArreglo numeroReal,arrayShell
     	 ShellSortAscM  arrayShell
         copiarArreglo arrayShell, arrayBurbuja
         jmp MenuPrincipal
     ShellSortDesc:
     	 longitudArreglo numeroReal
         copiarArreglo arrayShell, arrayBurbuja
         jmp MenuPrincipal
     cerrarArchivo:
          cerrar handlerentrada
          ret
        
     Error1:
          SaltoLinea
          print err1
          getChar
          jmp MenuPrincipal

     Error2:
          SaltoLinea
          print err2
          getChar
          jmp MenuPrincipal
     Error3:
          SaltoLinea
          print err3
          getChar
          jmp MenuPrincipal
     
     Error4:
          SaltoLinea
          print err4
          getChar
          jmp MenuPrincipal

     Error5:
          SaltoLinea
          print err5
          getChar
          jmp MenuPrincipal


          ;GraficarP proc
          ;    Graficar
          ;GraficarP endp
     
main endp
end main