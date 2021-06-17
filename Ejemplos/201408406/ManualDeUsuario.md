# UNIVERSIDAD SAN CARLOS DE GUATEMALA

## ARQUITECTURA DE COMPUTADORES Y ENSAMBLADORES 1

## DOCUMENTACION DE USUARIO - PRACTICA 3

### *OBJETIVOS*

#### GENERAL

- Reconocer e implementar algoritmos en el lenguaje ensamblador.

#### ESPECIFICOS

- Aplicar algoritmos de las operaciones básicas con el lenguaje ensamblador.

- Conocer y utilizar el funcionamiento de las interrupciones propias de ensamblador.

- Comprender el uso de la memoria en los programas informaticos

- Aplicar los conocimientos adquiridos en el laboratorio.

### DESCRIPCION DE LA PRACTICA

La practica consiste en desarrollar una calculadora en consola en la que se manejan los signos de las operaciones aritmeticas tales como suma (+), resta (-), multiplicación (*) y division (/). Se muestra un encabezado con los datos del estudiante.

        UNIVERSIDAD DE SAN CARLOS DE GUATEMALA
        FACULTAD DE INGENIERIA
        ESCUELA DE CIENCIAS Y SISTEMAS
        ARQUITECTURA DE COMPUTADORAS Y  ENSAMBLADORES 1 A
        SECCION B
        PRIMER SEMESTRE 2021
        ANDREA MARISOL OROZCO APARICIO
        201408406
        PRIMERA PRACTICA DE ASSEMBLER
</pre>

De la misma manera que se imprime el encabezado se debe imprimir el menu que permite navegar en las diferentes opciones de la calculadora.

        ---- MENU PRINCIPAL ---
        | 1. CARGAR ARCHIVO   |
        | 2. MODO CALCULADORA |
        | 3. FACTORIAL        |
        | 4. CREAR REPORTE    |
        | 5. SALIR            |
        -----------------------
</pre>

#### DESCRIPCION DE LAS OPCIONES DEL MENU

1. _Salir_, como su nombre lo indica sale de la aplicacion.

2. _Cargar archivo_, carga un archivo con operaciones para que se puedan realizar y posteriormente mostrar el resultado. El archivo tiene que ser de extension arq para poder reconocerlo dentro de la aplicacion. Se reconocen numeros unicamente dentro del rango -99 a 99.

3. _Modo calculadora_, en este modo la aplicacion le solicita numeros y operadores, realiza las operaciones sin precedencia por lo que se debe ingresar de una manera correcta. Tambien acepta unicamente numeros de -99 a 99. Los mensajes que se muestran dentro de la consola son unicamente para guiar al usuario en la ejecucion de la calculadora. El ; indica que no se ingresan mas operaciones y en ese momento se muestra el resultado. Este modo pregunta si se desea guardar la operacion y el resultado para luego poder generar el reporte, que se visualiza en la opcion Generar reporte.

4. _Factorial_, es una operacion propia de las matematicas que se realiza en la calculadora unicamente de los numeros del 0 al 7. Muestra al usuario un recorrido de las operaciones realizadas.

5. _Crear reporte_, como su nombre lo indica crea un archivo con extension html en el que se muestran los datos del estudiante y una tabla donde se muestran las operaciones realizadas en el modo calculadora.
