include metodos.asm
.model small
.stack
.data
u db 0
de db 0
n1 db 0
n2 db 0
numFactorial db 1
buffer db 50 dup('&')
salto db 0ah, 0dh, '$','$'
liena1Encabezado db 0ah, 0dh, 'UNIVERSIDAD DE SAN CARLOS DE GUATEMALA','$'
liena2Encabezado db 0ah, 0dh, 'FACULTAD DE INGENIERIA','$'
liena3Encabezado db 0ah, 0dh, 'ESCUELA DE CIENCIAS Y SISTEMAS','$'
liena4Encabezado db 0ah, 0dh, 'ARQUITECTURA DE COMPUTADORES Y ENSAMBLADORES 1 A','$'
liena5Encabezado db 0ah, 0dh, 'SECCION B','$'
liena6Encabezado db 0ah, 0dh, 'PRIMER SEMESTRE 2021','$'
liena7Encabezado db 0ah, 0dh, 'Elder Fernando Andrade Foronda','$'
liena8Encabezado db 0ah, 0dh, '201700858','$'
liena9Encabezado db 0ah, 0dh, 'Primera Practica Assembler','$'
liena10Encabezado db 0ah, 0dh, '    1. Cargar Archivo','$'
liena11Encabezado db 0ah, 0dh, '    2. Modo Calculadora','$'
liena12Encabezado db 0ah, 0dh, '    3. Factorial','$'
liena13Encabezado db 0ah, 0dh, '    4. Crear reporte','$'
liena14Encabezado db 0ah, 0dh, '    5. Salir.','$'
liena15Encabezado db 0ah, 0dh, 'Elija una opcion:','$'
linea1Archivo db 0ah, 0dh, 'Ingrese Ruta del archivo:','$'
linea1calculadora db 0ah, 0dh, '        Modo Calculadora:','$'
linea2calculadora db 0ah, 0dh, 'Ingrese Numero:','$'
linea3calculadora db 0ah, 0dh, 'Ingrese Operador:','$'
linea4calculadora db 0ah, 0dh, 'Desea Guardar? (S/N)','$'
linea5calculadora db 0ah, 0dh, 'El resultado fue: ','$'
linea1factorial db 0ah, 0dh, '        Modo Factorial:','$'
linea2factorial db 0ah, 0dh, 'Ingrese Numero:','$'
linea3factorial db 0ah, 0dh, 'El resultado fue:','$'
linea1reporte db 0ah, 0dh, 'Reporte Creado','$'
linea2reporte db 0ah, 0dh, '<h1>Practica 3 Arqui 1 Seccion A</h1><h3>Estudiante: Elder Fernando Andrade</h3><h3>Carnet: 201700858</h3><h3>Fecha: 11/3/2021</h3><h3>Hora: 16:44</h3><table><tr><td>Operaciones</td></tr>','$'
linea3reporte db 0ah, 0dh, '</table>','$'
linea4reporte db  "Report.html" , 0
linea5reporte db 0ah, 0dh, 'Error Al crearlo','$'
linea6reporte db 0ah, 0dh, '<tr><td>','$'
linea7reporte db 0ah, 0dh, '</tr></td>','$'
.code
main proc
    mov ax, seg @data
    mov ds, ax
    _MenuPrincipal:
        print salto
        print liena1Encabezado
        print liena2Encabezado
        print liena3Encabezado
        print liena4Encabezado
        print liena5Encabezado
        print liena6Encabezado
        print liena7Encabezado
        print liena8Encabezado
        print liena9Encabezado
        print liena10Encabezado
        print liena11Encabezado
        print liena12Encabezado
        print liena13Encabezado
        print liena14Encabezado
        print liena15Encabezado
        print salto
        getChar
        cmp al,31h
        je _MenuArchivo
        cmp al,32h
        je _MenuCalculadora
        cmp al,33h
        je _MenuFactorial
        cmp al,34h
        je _MenuReporte
        cmp al,35h
        je _Salir
        limpiarPantalla
        jmp _MenuPrincipal
    _MenuArchivo:
        print salto
        print linea1Archivo
        print salto
        obtenerRuta buffer
        print buffer
        getChar
        jmp _MenuPrincipal
    _MenuCalculadora:
        print salto
        print linea1calculadora
        print salto
        aritmetica u,de,n1,n2,linea2calculadora,linea3calculadora,linea5calculadora,linea4calculadora
        limpiarPantalla
        jmp _MenuPrincipal
    _MenuFactorial:
        print salto
        print linea1factorial
        print salto
        factorial linea2factorial,linea3factorial,n1,numFactorial
        limpiarPantalla
        jmp _MenuPrincipal
    _MenuReporte:
        print salto
        print linea1reporte
        print salto
        obtenerRuta buffer
        editarArchivo linea4reporte,linea5reporte,linea1reporte,linea2reporte
        getChar
        limpiarPantalla
        jmp _MenuPrincipal
    _Salir:
        terminar

main endp
end main