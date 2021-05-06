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
     rep0 db 0ah,0dh,  '<Arqui>',00h
     rep1 db 0ah,0dh,  '<Encabezado>',00h
     rep2 db 0ah,0dh,  '<Universidad>Universidad de San Carlos de Guatemala</Universidad>',00h
     rep3 db 0ah,0dh,  '<Facultad>Facultad de Ingenieria</Facultad>',00h
     rep4 db 0ah,0dh,  '<Escuela>Ciencias y Sistemas</Escuela>',00h
     rep5 db 0ah,0dh,  '<Curso>',00h
     rep6 db 0ah,0dh,  '<Nombre>Arquitectura de Computadores y Ensambladores 1</Nombre>',00h
     rep7 db 0ah,0dh,  '<Seccion>Seccion B</Seccion>',00h
     rep8 db 0ah,0dh,  '</Curso>',00h
     rep9 db 0ah,0dh,  '<Ciclo>Primer Semestre 2021</Ciclo>',00h
     rep10 db 0ah,0dh,  '<Fecha>',00h
     rep11 db 0ah,0dh,  '<Dia>26</Dia>',00h
     rep12 db 0ah,0dh,  '<Mes>03</Mes>',00h
     rep13 db 0ah,0dh,  '<Año>2021</Año>',00h
     rep14 db 0ah,0dh,  '</Fecha>',00h
     rep15 db 0ah,0dh,  '<Hora>',00h
     horaRep db 3 dup('$'), 00h
     minutoRep db 3 dup('$'), 00h
     segundoRep db 3 dup('$'), 00h
     rep16 db 0ah,0dh,  '</Hora>',00h
     rep17 db 0ah,0dh,  '<Minutos>',00h
     rep18 db 0ah,0dh,  '</Minutos>',00h
     rep19 db 0ah,0dh,  '<Segundos>',00h
     rep20 db 0ah,0dh,  '</Segundos>',00h
     rep21 db 0ah,0dh,  '<Alumno>',00h
     rep23 db 0ah,0dh,  '<Nombre>Audrie Annelisse del Cid Ochoa</Nombre>',00h
     rep24 db 0ah,0dh,  '<Carnet>201801263</Carnet>',00h
     rep25 db 0ah,0dh,  '</Alumno>',00h
     rep26 db 0ah,0dh,  '</Encabezado>',00h
     rep27 db 0ah,0dh,  '<Resultados>',00h
     rep28 db 0ah,0dh,  '<Tipo>Ascendente</Tipo>',00h
     rep22 db 0ah,0dh,  '<Tipo>Descendente</Tipo>',00h
     rep29 db 0ah,0dh,  '<Lista_Entrada>',00h
     rep30 db 0ah,0dh,  '</Lista_Entrada>',00h
     rep31 db 0ah,0dh,  '<Lista_Ordenada>',00h
     arregloOrdenado db 1000 dup ('$'),'$'
     rep32 db 0ah,0dh,  '</Lista_Ordenada>',00h
     rep33 db 0ah,0dh,  '<Ordenamiento_BubbleSort>',00h
     rep34 db 0ah,0dh,  '</Ordenamiento_BubbleSort>',00h
     rep35 db 0ah,0dh,  '<Velocidad>',00h
     rep36 db 0ah,0dh,  '</Velocidad>',00h
     rep37 db 0ah,0dh,  '<Tiempo>',00h
     rep38 db 0ah,0dh,  '</Tiempo>',00h
     rep39 db 0ah,0dh,  '<Milisegundos>',00h
     rep40 db 0ah,0dh,  '</Milisegundos>',00h
     rep41 db 0ah,0dh,  '<Ordenamiento_Quicksort>',00h
     rep42 db 0ah,0dh,  '</Ordenamiento_Quicksort>',00h
     rep43 db 0ah,0dh,  '<Ordenamiento_Shellsort>',00h
     rep44 db 0ah,0dh,  '</Ordenamiento_Shellsort>',00h
     rep45 db 0ah,0dh,  '</Resultados>',00h
     rep46 db 0ah,0dh,  '</Arqui>',00h     
     nombreRep db 'Reporte.xml',0
    ErroRep db 0ah,0dh , 'Error al crear el reporte!',"$"
    creadoRep db 0ah,0dh , 'Reporte creado!.',"$"
    errorEliminarRep db 0ah,0dh , 'Error al eliminar el archivo!.',"$"
    eliminarRep db 0ah,0dh, 'El archvio ha sido eliminado!',"$"

    repResultado db 0ah,0dh, 'Reporte Creado!',0
   
     dia db 0
    mes db 0
    hora db 0
    minutos db 0
    segundos db 0


     retorno equ 00h;13
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
     prueba  db  'Velocidad: ','$'
     pruebaAncho  db 0ah, 0dh, 'Ancho: ','$'
     ;Variables
     opcion db 0;
     lengthArreglo db 0;
     lengthArregloAscii db 0;
     regresar db 0ah, 0dh, '0. Regresar Menu principal ','$'
     ;CargarArchivo
     menu01 db 0ah,0dh, '*********************CARGAR ARCHIVO********************','$'
     carga1 db 0ah,0dh, 'Ingrese una ruta de archivo' , 0ah,0dh, 'Ejemplo: entrada.xml' , '$'
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

     mhora db 2 dup(0), 0
     mmin db 2 dup(0), 0
     mseg db 2 dup(0), 0
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


     mdVideo db 0ah,0dh, '1. Ver Modo video','$'
     mdMenu db 0ah,0dh, '2. Menu Principal','$'
     velocidadBubble db 0
     velocidadQuick db 0
     velocidadShell db 0
     velocidad db 0

     arrayBurbuja db 1000 dup ('$'),'$'
     arrayShell db 1000 dup ('$'),'$'
     arrayQuick db 1000 dup ('$'),'$'
     arrayTexto db 1000 dup ('$'),'$'
     arrayBurbujaAsc db 1000 dup ('$'),'$'
     arrayShellAsc db 1000 dup ('$'),'$'
     arrayQuickAsc db 1000 dup ('$'),'$'
     arrayBurbujaDesc db 1000 dup ('$'),'$'
     arrayShellDesc db 1000 dup ('$'),'$'
     arrayQuickDesc db 1000 dup ('$'),'$'
     
     gap db 0
     aux2 db 0
     aux1 db 0
     pivote db 0
     decontador db 0
     arregloOrdenadoDesc db 1000 dup ('$'),'$'
     cond db 0,'$'
     condicion db 0
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

     der dw 0
     izq dw 0
     resultadoPartition dw 0
     orBubble db 'Ordenamiento: Bubble Sort' , '$'
     orQuick db 'Ordenamiento: QuickSort' , '$'
     orShell db  'Ordenamiento: ShellSort' , '$'
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
          limpiar bufferentrada, SIZEOF bufferentrada,24h  
          SaltoLinea        
          ;obtenerRuta bufferentrada
         
          crear nombreRep, handlerentrada
          ;crear bufferentrada, handlerentrada
          escribir handlerEntrada, rep0, SIZEOF rep0
          escribir handlerEntrada, rep1, SIZEOF rep1
          escribir handlerEntrada, rep2, SIZEOF rep2
          escribir handlerEntrada, rep3, SIZEOF rep3
          escribir handlerEntrada, rep4, SIZEOF rep4
          escribir handlerEntrada, rep5, SIZEOF rep5
          escribir handlerEntrada, rep6, SIZEOF rep6
          escribir handlerEntrada, rep7, SIZEOF rep7
          escribir handlerEntrada, rep8, SIZEOF rep8
          escribir handlerEntrada, rep9, SIZEOF rep9
          escribir handlerEntrada, rep10, SIZEOF rep10
          escribir handlerEntrada, rep11, SIZEOF rep11
          escribir handlerEntrada, rep12, SIZEOF rep12
          escribir handlerEntrada, rep13, SIZEOF rep13
          escribir handlerEntrada, rep14, SIZEOF rep14
          
          ObtenerHora
          escribir handlerEntrada, rep15, SIZEOF rep15      ; Hora
          escribir handlerEntrada, mhora, SIZEOF mhora         
          escribir handlerEntrada, rep16, SIZEOF rep16      ;Fin Hora
          
          escribir handlerEntrada, rep17, SIZEOF rep17      ; Minutos
          escribir handlerEntrada, mmin, SIZEOF mmin
          escribir handlerEntrada, rep18, SIZEOF rep18      ; Fin minutos

          escribir handlerEntrada, rep19, SIZEOF rep19      ;Segundos
          escribir handlerEntrada, mseg, SIZEOF mseg         
          escribir handlerEntrada, rep20, SIZEOF rep20      ;Segundos

          escribir handlerEntrada, rep21, SIZEOF rep21
          escribir handlerEntrada, rep23, SIZEOF rep23
          escribir handlerEntrada, rep24, SIZEOF rep24
          escribir handlerEntrada, rep25, SIZEOF rep25
          escribir handlerEntrada, rep26, SIZEOF rep26
          escribir handlerEntrada, rep27, SIZEOF rep27
          escribir handlerEntrada, rep29, SIZEOF rep29      ;Lista_Entrada

          ConvertirArreglo numeroReal          
          escribir handlerEntrada, arrayTexto, SIZEOF arrayTexto ;arreglo

          escribir handlerEntrada, rep30, SIZEOF rep30      ;Lista_Entrada

          ;Ordenamiento Burbuja
          escribir handlerEntrada, rep33, SIZEOF rep33      ;Ini
          escribir handlerEntrada, rep28, SIZEOF rep28      ;Asc
          escribir handlerEntrada, rep31, SIZEOF rep31      ;Lista_Ordenada

          ConvertirArreglo arrayBurbujaAsc          
          escribir handlerEntrada, arrayTexto, SIZEOF arrayTexto ;arreglo

          escribir handlerEntrada, rep32, SIZEOF rep32      ;Lista_Ordenada



          escribir handlerEntrada, rep22, SIZEOF rep22      ;Asc
          escribir handlerEntrada, rep31, SIZEOF rep31      ;Lista_Ordenada

          ConvertirArreglo arrayBurbujaDesc          
          escribir handlerEntrada, arrayTexto, SIZEOF arrayTexto ;arreglo

          escribir handlerEntrada, rep32, SIZEOF rep32      ;Lista_Ordenada



          escribir handlerEntrada, rep35, SIZEOF rep35      ;Velocidad0
          escribir handlerEntrada, velocidadBubble, SIZEOF velocidadBubble
          escribir handlerEntrada, rep36, SIZEOF rep36      ;VelocidadF

          escribir handlerEntrada, rep37, SIZEOF rep37
          escribir handlerEntrada, rep38, SIZEOF rep38

          
          escribir handlerEntrada, rep19, SIZEOF rep19
          escribir handlerEntrada, rep20, SIZEOF rep20

          escribir handlerEntrada, rep39, SIZEOF rep39
          escribir handlerEntrada, rep40, SIZEOF rep40


          escribir handlerEntrada, rep34, SIZEOF rep34      ; fin

          
          ;ORDENAMIENTO QuickSort
          escribir handlerEntrada, rep41, SIZEOF rep41      ;Ini


          escribir handlerEntrada, rep28, SIZEOF rep28      ;Asc
          escribir handlerEntrada, rep31, SIZEOF rep31      ;Lista_Ordenada

          ConvertirArreglo arrayQuickAsc          
          escribir handlerEntrada, arrayTexto, SIZEOF arrayTexto ;arreglo

          escribir handlerEntrada, rep32, SIZEOF rep32      ;Lista_Ordenada



          escribir handlerEntrada, rep22, SIZEOF rep22      ;Desc
          escribir handlerEntrada, rep31, SIZEOF rep31      ;Lista_Ordenada

          ConvertirArreglo arrayQuickDesc          
          escribir handlerEntrada, arrayTexto, SIZEOF arrayTexto ;arreglo

          escribir handlerEntrada, rep32, SIZEOF rep32      ;Lista_Ordenada



          escribir handlerEntrada, rep35, SIZEOF rep35      ;Velocidad0
          escribir handlerEntrada, velocidadQuick, SIZEOF velocidadQuick
          escribir handlerEntrada, rep36, SIZEOF rep36      ;VelocidadF

          escribir handlerEntrada, rep37, SIZEOF rep37      ;Tiempo
          escribir handlerEntrada, rep38, SIZEOF rep38      ; Tiempo

          
          escribir handlerEntrada, rep19, SIZEOF rep19      ;Segundos
          escribir handlerEntrada, rep20, SIZEOF rep20      ; Segundos

          escribir handlerEntrada, rep39, SIZEOF rep39      ;Milisegundos
          escribir handlerEntrada, rep40, SIZEOF rep40      ;Milisegundos




          escribir handlerEntrada, rep42, SIZEOF rep42      ;fin

          ;ORDENAMIENTO ShellSort
          escribir handlerEntrada, rep43, SIZEOF rep43

          escribir handlerEntrada, rep28, SIZEOF rep28      ;Asc
          escribir handlerEntrada, rep31, SIZEOF rep31      ;Lista_Ordenada

          ConvertirArreglo arrayShellAsc          
          escribir handlerEntrada, arrayTexto, SIZEOF arrayTexto ;arreglo

          escribir handlerEntrada, rep32, SIZEOF rep32      ;Lista_Ordenada



          escribir handlerEntrada, rep22, SIZEOF rep22      ;Asc
          escribir handlerEntrada, rep31, SIZEOF rep31      ;Lista_Ordenada

          ConvertirArreglo arrayShellDesc          
          escribir handlerEntrada, arrayTexto, SIZEOF arrayTexto ;arreglo

          escribir handlerEntrada, rep32, SIZEOF rep32      ;Lista_Ordenada



          escribir handlerEntrada, rep35, SIZEOF rep35      ;Velocidad0
          escribir handlerEntrada, velocidadShell, SIZEOF velocidadShell

          escribir handlerEntrada, rep36, SIZEOF rep36      ;VelocidadF

          escribir handlerEntrada, rep37, SIZEOF rep37
          escribir handlerEntrada, rep38, SIZEOF rep38

          
          escribir handlerEntrada, rep19, SIZEOF rep19
          escribir handlerEntrada, rep20, SIZEOF rep20

          escribir handlerEntrada, rep39, SIZEOF rep39
          escribir handlerEntrada, rep40, SIZEOF rep40




          escribir handlerEntrada, rep44, SIZEOF rep44      ;fin
          





          escribir handlerEntrada, rep45, SIZEOF rep45
          escribir handlerEntrada, rep46, SIZEOF rep46
          call cerrarArchivo

          ;print repResultado
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
          mov velocidadBubble, al
          SaltoLinea
          add velocidadBubble, 30h
          ;print velocidadBubble
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
          copiarArreglo arrayBurbuja, arrayBurbujaAsc
          ;AnchoBarra
          ;DibujarBarras arrayBurbuja
          ;Graficar arrayBurbuja
          print mdVideo
         print mdMenu

         getChar
         cmp al, 32h
         je MenuPrincipal
         ConvertirArreglo arrayBurbuja
         Graficar arrayTexto, orBubble, velocidadBubble
     BurbujaDescendente:
          longitudArreglo numeroReal
          copiarArreglo numeroReal, arrayBurbuja
          SaltoLinea
          imprimirArreglo arrayBurbuja
          SaltoLinea
          BurbujaDesc arrayBurbuja
          copiarArreglo arrayBurbuja, arrayBurbujaDesc

          print mdVideo
         print mdMenu

         getChar
         cmp al, 32h
         je MenuPrincipal

         ConvertirArreglo arrayBurbujaDesc
         Graficar arrayTexto, orBubble, velocidadBubble
     QuickSort:
     	 print msjVelocidad
          getChar
          sub al, 48
          mov velocidadQuick, al
          add velocidadQuick, 30h
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
          mov izq, 0
          copiarArreglo numeroReal, arrayQuick
          SaltoLinea
          call QuickSortAscP
          copiarArreglo arrayQuick, arrayQuickAsc
          imprimirArreglo arrayQuick
          print mdVideo
         print mdMenu

         getChar
         cmp al, 32h
         je MenuPrincipal

         Graficar arrayTexto, orQuick, velocidadQuick
     QuickSortDesc:
          longitudArreglo numeroReal
          mov izq, 0
          copiarArreglo numeroReal, arrayQuick
          SaltoLinea
          call QuickSortDescP
          copiarArreglo arrayQuick, arrayQuickDesc
          longitudArreglo numeroReal
          imprimirArregloDesc arrayQuick
          print mdVideo
         print mdMenu

         getChar
         cmp al, 32h
         je MenuPrincipal

         Graficar arrayTexto, orQuick, velocidadQuick
     ShellSort:
     	  print msjVelocidad
          getChar
          sub al, 48
          mov velocidadShell, al
          add velocidadShell, 30h
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
           imprimirArreglo numeroReal
           SaltoLinea
     	 copiarArreglo numeroReal,arrayShell
           ShellSortAscM  arrayShell
           copiarArreglo arrayShell, arrayShellAsc
           imprimirArreglo arrayShell
           print mdVideo
         print mdMenu

         getChar
         cmp al, 32h
         je MenuPrincipal

         Graficar arrayTexto, orShell, velocidadShell
     ShellSortDesc:
     	 longitudArreglo numeroReal
           imprimirArreglo numeroReal
           SaltoLinea
           copiarArreglo numeroReal,arrayShell
           ShellSortDescM  arrayShell
           copiarArreglo arrayShell, arrayShellDesc
           imprimirArreglo arrayShell
         
         print mdVideo
         print mdMenu

         getChar
         cmp al, 32h
         je MenuPrincipal

         Graficar arrayTexto, orShell, velocidadShell
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


     QuickSortAscP proc 
          
           mov cx,der
           cmp izq,cx
           jge fin
           partitionAsc arrayQuick, izq, der
           mov bx, der
           push bx
           mov ax, resultadoPartition
           push ax
           dec ax
           mov der,ax

          imprimirArreglo arrayQuick
          SaltoLinea
                    ;tienen que graficar aqui

           call QuickSortAscP
           pop ax 
           pop bx 
           mov der,bx
           inc ax
           mov izq,ax
           call QuickSortAscP
           fin:
               ret
     QuickSortAscP endp

     QuickSortDescP proc 
           mov cx,der
           cmp izq,cx
           jge fin
           partitionAsc arrayQuick, izq, der
           mov bx, der
           push bx
           mov ax, resultadoPartition
           push ax
           dec ax
           mov der,ax

          imprimirArregloDesc arrayQuick
          SaltoLinea
                    ;tienen que graficar aqui

           call QuickSortDescP
           pop ax 
           pop bx 
           mov der,bx
           inc ax
           mov izq,ax
           call QuickSortDescP
           fin:
               ret
     QuickSortDescP endp
     
     
main endp
end main