# UNIVERSIDAD SAN CARLOS DE GUATEMALA

## ARQUITECTURA DE COMPUTADORES Y ENSAMBLADORES 1

## DOCUMENTACION TECNICA - PRACTICA 3

### *OBJETIVOS*

#### GENERAL

- Reconocer e implementar algoritmos en el lenguaje ensamblador.

#### ESPECIFICOS

- Aplicar algoritmos de las operaciones básicas con el lenguaje ensamblador.

- Conocer y utilizar el funcionamiento de las interrupciones propias de ensamblador.

- Comprender el uso de la memoria en los programas informaticos

- Aplicar los conocimientos adquiridos en el laboratorio.

### DESCRIPCION DE LA SOLUCION

Se describie la manera en la que se desarrollo la solucion. Como es una calculadora, se desarrollo en el siguiente orden.

1. Impresion de textos en pantalla, como el encabezado y el menu. Se desarrollo con una macro con el nombre de PrintLn. El codigo es el siguiente:

    ```Assemnbler
        PrintLn macro cadena
           mov ax,@data
           mov ds,ax
           mov ah,09
           mov dx,offset cadena
           int 21h
        endm
    ;Esta macro se utiliza para imprimir todos los textos dentro de la aplicacion.
    ```

2. Lectura de datos desde la aplicacion, para ello se utiliza un procedimiento, tiene el nombre de ReadLn, este llena un vector con la lectura y lo deja listo para leer los datos insertados por el usuario y en el codigo luce de la siguiente manera:

    ```Assembler
        ReadLn proc near
            mov si,00h ; esto es para contar y  empieza en cero
            lea si,vectorLectura
            leer:
                mov ah,01h ;llama la funcion lectura
                int 21h
                mov [si],al 
                inc si
                cmp al,0dh
                jne leer
            ret
        ReadLn endp
    ```

3. Otras macros utilizadas dentro de la aplicacion son la de Pause y Clear que pausan la ejecucion en consola hasta presionar cualquier tecla y limpian la consola para las siguientes nuevas impresiones. Estas macros dentro del codigo lucen de la siguiente manera:

    ```Assembler
        Clear macro
           mov ax,0600h
           mov bh,01h
           mov cx,0000h
           mov dx,184fh
           int 10h
        endm

        Pausa macro
           mov ah , 01h 
           int 21h 
           cmp al , 0dh 
           mov ah , 02h 
           mov dl , al 
           int 21h 
        endm
    ```

4. Se desarrollo la eleccion para cada opcion del menu, se compara la opcion ingresada y si no es una opcion valida imprime de nuevo el menu.

    ```Asembler
        Inicio:
            PrintLn compilacion_bandera
            call Print_Encabezado
            jmp Menu

        ;Etiqueta menu
        Menu:
        call Print_Menu
        call PROC_MENU
    ```

5. Luego se desarrollo la logica del modo calculadora, que lee y guarda numeros en un arreglo, de la misma manera se almacenan los operadores para luego recorrerlos y ejecutar las sumas. Hay una variable con el nombre `intResultado` que cuando se terminan de ingresar numeros los resultados se van almacenando en ella para poder finalizado el proceso mostrar el resultado en pantalla. El codigo de esa logica queda de la siguiente manera:

    ```Assembler
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
        mov intNumeroDecimal, 0 ;Para limpiar la  variable
        call ValidarNumeros
        mov al, intContadorNumerosRecolectados
        add al,1
        mov intContadorNumerosRecolectados, al
        call GuardarNumero
        cmp intContadorOperadoresRecolectados, 10
        je AdvertenciaMaximoNumeros

        PedirOperadorSegundo:
        PrintLn   msj_modocalculadora_PedirOperadorPuntoyco ma
        call ReadLn
        mov si,0
        mov al, vectorLectura[si]
        cmp al,59
        je ModoCalculadora_RealizarOperaciones
        call GuardarOperador
        jmp MasNumeros

        AdvertenciaMaximoNumeros:
        PrintLn   msj_modocalculadora_advertencia_maximoNum eros


        ModoCalculadora_RealizarOperaciones:; -------- estoy enojada con mi novio por  sabiondo amargadote pero todo lo que     hace ,lo hace porque me ama y se    preocupa por mi
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
        je    ModoCalculadora_OperacionMultiplicacion
        cmp al, SIGNO_DIVISION
        je ModoCalculadora_OperacionDivision
        jmp   ModoCaluladora_PedirNumerosHastaLaMuerte

        ModoCalculadora_OperacionSuma:
        mov ax, intNumeroUno
        mov bx, intNumeroDos
        add ax, bx
        mov intResultado, ax
        mov intTemporalResultadoImprimir, ax
        ;PrintLn intTemporalResultadoImprimir
        ;PrintLn msj_saltoLinea
        jmp   ModoCaluladora_PedirNumerosHastaLaMuerte

        ModoCalculadora_OperacionResta:
        mov ax, intNumeroUno
        mov bx, intNumeroDos
        sub ax, bx
        mov intResultado, ax
        mov intTemporalResultadoImprimir, ax
        ;PrintLn intTemporalResultadoImprimir
        ;PrintLn msj_saltoLinea
        jmp   ModoCaluladora_PedirNumerosHastaLaMuerte

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
        jmp   ModoCaluladora_PedirNumerosHastaLaMuerte

        ModoCalculadora_OperacionDivision:
        xor ax, ax
        xor bx, bx
        mov dx, 0

        mov ax, intNumeroUno
        sal al, 1
        jc ConvertirNumeroUnoPositivo
        mov ax,intNumeroUno; abandonado sin   cambio
        mov intTemporalNumero1,ax
        jmp ConvertirNumero

        ConvertirNumeroUnoPositivo:
        mov ax,intNumeroUno; abandonado sin   cambio
        mov intTemporalNumero1,ax
        neg intTemporalNumero1
        inc intContadorNegativos

        ConvertirNumero:
        mov ax, intNumeroDos
        sal al, 1
        jc ConvertirNumeroDosPositvo
        mov ax,intNumeroDos; abandonado sin   cambio
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
        jmp   ModoCaluladora_PedirNumerosHastaLaMuerte


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

        ; -----------------------------------------    --------------------------


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

    ```

6. Luego se desarrollo la logica para crear el reporte, que luce de la siguiente manera:

    ```Assembler
        menu_CrearReporte:
            Clear
            ;PrintLn msj_opcion_menu_CrearReporte
            ;GENERAR REPORTE
            call CrearReporte
            jmp Menu
            ;hace el reporte
            CrearReporte proc near
            call EliminarReporte
            call CrearNuevoReporte
            call ObtenerFecha
            call ObtenerHora
            call SobreescribirReporte
            CrearReporteFinal:
            ret
            CrearReporte endp

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

        CrearNuevoReporte proc near
            mov ah,3ch ;instrucción para crear el archivo.
            mov cx,0
            mov dx,offset HTML_NOMBRE_REPORTE  
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

            ObtenerFecha proc near
            mov ah,2ah
            int 21h

            mov intCalculardia,dl
            mov intCalcularmes,dh
   
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
   
        SobreescribirReporte proc near
            FinalHeditar:
            ;abrir el archivo
            mov ah,3dh
            mov al,1h ;Abrimos el archivo en solo escritura.
            mov dx,offset HTML_NOMBRE_REPORTE
            int 21h
            jc FinalHErrorAbrir ;Si hubo error


            mov si,4229;numero de caracteres en la cadena
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
    ```

