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
            cmdmin db "min","$"
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
            valorMax dw 0 
            valorMin dw 0 
            ContadorTexto dw 0
            lengthArray dw 0
            NumeroString db 5 dup('$')
            NumeroInt dw 0 
            contadorActual dw 0
            NumerosReal dw 1000 dup('$')
            arraySize dw 0 
            QtyNumbers2 dw 0
    ;Cadenas Info
        encabezado0 db 0ah, 0dh, '    ARQUITECTURA DE COMPUTADORES Y ENSAMBLADORES 1    ','$'
        encabezado1 db 0ah, 0dh, '                       SECCION B                      ','$'
        encabezado2 db 0ah, 0dh, '        NOMBRE: Audrie Annelisse del Cid Ochoa        ','$'
        encabezado3 db 0ah, 0dh, '                  CARNET: 201801263                   ','$'
        encabezado4 db 0ah, 0dh, '                 PROYECTO 2 ASSEMBLER                 ','$'


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
        ComprobarArchivo bufferEntrada,NombreArchivo
        je abrir
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
        Comparar cmdlimpiar, bufferEntrada
        je limpiar
        Comparar cmdreporte, bufferEntrada
        je reporte

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
    cmediana:
    cmoda:
    cmax:
    cmin:
    gbarraAsc:
    gbarraDesc:
    ghist:
    glinea:
    abrir:
        SaltoLinea
        jmp Inicio
    limpiar:
        LimpiarPantalla
        jmp Inicio
    reporte:
    info:
        Print encabezado0
        Print encabezado1
        Print encabezado2
        Print encabezado3
        Print encabezado4
        SaltoLinea
        jmp Inicio


main endp
end main

