include MacrosAu.asm

.model small

.stack 100h

.data
    ;COMANDOS
        ;Cadenas
            comando db "consolap2> ","$"
            cmdcprom db "cprom","$"
            cmdinfo db "info","$"
            cmdsalir db "salir","$"        
            cmdmediana db "cmediana","$"
            cmdmoda db "cmoda","$"
            cmdmax db "cmax","$"
            cmdmin db "cmin","$"
            cmdgbarraAsc db "gbarra_asc","$"
            cmdgbarraDesc db "gbarra_desc","$"
            cmdghist db "ghist","$"
            cmdglinea db "glinea","$"
            cmdabrir db "abrir_","$"
            cmdlimpiar db "limpiar","$"
            cmdreporte db "reporte","$"    
            descono db "Comando No identificado","$"            
        ;Variables
            bufferEntrada db 50 dup ("$")
    ;ARCHIVOS
        ;Cadenas    
            errFile db "Error al Cargar Archivo!","$"
            exitoFile db "Archivo Cargado correctamente!","$"
        ;Variables
            NombreArchivo db 200 dup('$')  
            HandlerArchivo dw ?
            ContenidoArchivo db 9999 dup('$'), '$'
            numeros   db 1000 dup('$'),'$'
            valorMax dw 0 
            valorMin dw 0 
            ContadorTexto dw 0
            lengthArray dw 0
            auxLengthArray dw 0
            NumeroString db 5 dup('$')
            NumeroInt dw 0 
            contadorActual dw 0
            NumerosReal dw 1000 dup('$')
            lstNumerosReal dw 1000 dup('$')
            arraySize dw 0 
            TamaArreglo dw 0
            der dw 0
            izq dw 0
            aux dw 0
            aux2 dw 0
            auxContador dw 0

    ;Cadenas Info
        encabezado0 db 0ah, 0dh, '    ARQUITECTURA DE COMPUTADORES Y ENSAMBLADORES 1    ','$'
        encabezado1 db 0ah, 0dh, '                       SECCION B                      ','$'
        encabezado2 db 0ah, 0dh, '        NOMBRE: Audrie Annelisse del Cid Ochoa        ','$'
        encabezado3 db 0ah, 0dh, '                  CARNET: 201801263                   ','$'
        encabezado4 db 0ah, 0dh, '                 PROYECTO 2 ASSEMBLER                 ','$'
    ;PROCESOS
        ;Cadenas
            errDatos db "            El archivo no cuenta con datos para procesar!","$"
            textNum dw ?
            arrayTexto   db 1000 dup('$'),'$'
            espacio db '-','$'
        ;Promedio
            sumaDatos dw 0
            promedio dw 0
            residuo dw 0
            punto db ".", "$"
            promedioTxt dw ?
            residuoTxt dw ?
            PromedioEtq db 0ah, 0dh, '            Promedio: ','$'
        ;Fecuencias
             arrayDatos dw 500 dup('$')
             arrayFecuencias dw 500 dup('$')
             sizeArrayDatos dw 0
             sizeArrayFrec dw 0
             actual dw 0
             index dw 0
             textNum1 dw ?
             textNum2 dw ?
             contador dw 0
        ;Max
            MayorNum dw 0
            lenghArregloPrint dw 0  
            MaxEtq db 0ah, 0dh, '            Maximo: ','$' 
        ;Min
            MinimoNum dw 0 
            MinEtq db 0ah, 0dh, '            Minimo: ','$' 
        ;Moda
            ModaEtq db 0ah, 0dh, '            Moda: ','$'
            ModaNum dw 0     
            maxFreq dw 0  
        ;Mediana
        	MedianaEtq db 0ah, 0dh, '            Mediana: ','$'
        	Pivote dw 0
        	MedEntero dw 0
        	MedDecimal dw 0
        ;Errores 
		     err1 db 0ah,0dh, 'Error al abrir el archivo puede que no exista' , '$'
		     err2 db 0ah,0dh, 'Error al cerrar el archivo' , '$'
		     err3 db 0ah,0dh, 'Error al escribir en el archivo' , '$'
		     err4 db 0ah,0dh, 'Error al crear en el archivo' , '$'
		     err5 db 0ah,0dh, 'Error al leer en el archivo' , '$'

	     ;reporte
	    	auxMediana dw 0
	    	auxDecMediana dw 0
	     	auxPromedio dw 0
	     	auxDecProm dw 0
	     	auxModa dw 0
	     	auxMax dw 0
	     	auxMin dw 0

	     	txtMediana dw ?
	    	txtDecMediana dw ?
	     	txtPromedio dw ?
	     	txtDecProm dw ?
	     	txtModa dw ?
	     	txtMax dw ?
	     	txtMin dw ?

	     	horaRep db 3 dup('$'), 00h
     		minutoRep db 3 dup('$'), 00h
     		segundoRep db 3 dup('$'), 00h

	     	repEtq  db 0ah,0dh, 'Generando Reporte ...' , '$'
	     	nombreReporte db '201801263.txt',0
	     	rep0 db 0ah,0dh,  'NOMBRE: Audrie Annelisse del Cid Ochoa '
	     	rep1 db 0ah,0dh,  'CARNET: 201801263'
	     	rep2 db 0ah,0dh,  'Mediana: '
	     	rep3 db 0ah,0dh,  'Promedio: '
	     	rep4 db 0ah,0dh,  'Moda: '
	     	rep5 db 0ah,0dh,  'Maximo: '
	     	rep6 db 0ah,0dh,  'Minimo: '
	     	rep7 db 0ah,0dh,  'Hora: '
	     	PTO db '.'
	     	rep8 db 0ah,0dh,  'Fecha: '
	     	rep9 db 0ah,0dh,  'Dato:                       Frecuencia:'
	     	Space db '   ----------------->   '
	     	Salto db 0ah, 0dh,'*'
	     	auxPrint dw ?
	     	txtaux dw ?

	     ;Graficas
	     	g0 db 0ah,0dh, 'gbarraDesc' , '$'
	     	g1 db 0ah,0dh, 'gbarraAsc' , '$'
	     	g2 db 0ah,0dh, 'ghist' , '$'
	     	g3 db 0ah,0dh, 'glinea' , '$'



.code
main proc
    mov dx,@data
    mov ds,dx
    mov es,dx
    Inicio:    	
        Print comando
        LeerTexto bufferEntrada
        Comparar cmdcprom, bufferEntrada
        je cprom
        Comparar cmdinfo, bufferEntrada
        je info
        Comparar cmdsalir, bufferEntrada
        je Salir
        ;Comparar cmdabrir, bufferEntrada
        ;je abrir        
        Comparar cmdmediana, bufferEntrada
        je cmediana
        Comparar cmdmoda, bufferEntrada
        je cmoda
        Comparar cmdmax, bufferEntrada
        je cmax
        Comparar cmdmin, bufferEntrada
        je cmin
        Comparar cmdgbarraAsc, bufferEntrada
        je gbarraAsc
        Comparar cmdgbarraDesc, bufferEntrada
        je gbarraDesc
        Comparar cmdghist, bufferEntrada
        je ghist    
        Comparar cmdglinea, bufferEntrada
        je glinea  
        Comparar cmdlimpiar, bufferEntrada
        je limpiar
        Comparar cmdreporte, bufferEntrada
        je reporte
        ComprobarArchivo bufferEntrada,NombreArchivo
        je abrir
        jmp Desconocido
    Desconocido:
        Print descono
        SaltoLinea
        jmp Inicio
    Salir:
        mov ah, 4ch
        xor al,al
        int 21h
    cprom:
        SaltoLinea
        Print PromedioEtq
        PrintX promedio
        Print punto
        PrintX residuo
        SaltoLinea
        SaltoLinea
        jmp Inicio
    cmediana:	
    	Print MedianaEtq
    	Printx MedEntero
    	Print punto
    	PrintX MedDecimal
    	SaltoLinea
    	SaltoLinea
    	jmp Inicio

    cmoda:
        Print ModaEtq
        PrintX ModaNum
        SaltoLinea
        SaltoLinea
        jmp Inicio
    cmax:
        Print MaxEtq
        PrintX MayorNum
        SaltoLinea
        SaltoLinea
        jmp Inicio
    cmin:
    	Print MinEtq
        PrintX MinimoNum
        SaltoLinea
        SaltoLinea
        jmp Inicio
    gbarraAsc:
    	Print g1
    	SaltoLinea
    	jmp Inicio
    gbarraDesc:
    	Print g0
    	SaltoLinea
    	jmp Inicio
    ghist:
    	Print g2
    	SaltoLinea
    	jmp Inicio
    glinea:
    	Print g3
    	SaltoLinea
    	jmp Inicio
    abrir:
        SaltoLinea
        jmp Inicio
    limpiar:
        LimpiarPantalla
        jmp Inicio
    reporte:
    	Print repEtq
    	SaltoLinea
    	clean bufferEntrada, SIZEOF bufferEntrada, 24h
    	GenerarReporte nombreReporte, HandlerArchivo
    	call cerrarArchivo
    	jmp Inicio
    info:
        Print encabezado0
        Print encabezado1
        Print encabezado2
        Print encabezado3
        Print encabezado4
        SaltoLinea
        jmp Inicio
    cerrarArchivo:
          cerrar HandlerArchivo
          ret
        
     Error1:
          SaltoLinea
          print err1
          getChar
          jmp Inicio

     Error2:
          SaltoLinea
          Print err2
          getChar
          jmp Inicio
     Error3:
          SaltoLinea
          Print err3
          getChar
          jmp Inicio
     
     Error4:
          SaltoLinea
          Print err4
          getChar
          jmp Inicio

     Error5:
          SaltoLinea
          Print err5
          getChar
          jmp Inicio


main endp
end main

