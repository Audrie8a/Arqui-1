include Macros.asm
include Archivos.asm
.model small
.stack 100h
.data
    ;Auxiliar variables*********************************************************
        space db " ","$"    ;Blank space
        coma db ",","$"
        punto db ".","$"
        tab db "    "
        ln db 13,10,"$" ;Next line
        decform dw ?
        orderDESC db "2","$"
        orderASC db "1","$"
    ;Text for header************************************************************
        header  db 13,10,"ARQUITECTURA DE COMPUTADORES Y ENSAMBLADORES 1"
                db 13,10,"SECCION A"
                db 13,10,"PRIMER SEMESTRE 2021"
                db 13,10,"NOMBRE: Sergio Sebastian Chacon Herrera"
                db 13,10,"CARNET: 201709159"
                db 13,10,"Proyecto 2 Aseembler",13,10,13,10,"$"
    ;Load file variables********************************************************
        fileloaded db "Archivo Cargado",13,10,"$"
        nonexist db "No existe archivo",13,10,"$"
        numres db "Numeros: ","$"
        maxnumtxt db "Mayor: ","$"
        minnumtxt db "Menor: ","$"
        FileName db 200 dup('$')    ;Contains the location of file
        FileContent db 9999 dup('$'), '$'    ;Saves the content of file
        HandlerFile dw ?    ;Handler for file
        posarr dw 0 ;Length of array
        TextNCounter dw 0 ;Counter for TextNumber
        TextNumber db 5 dup('$') ;Holds current number in text
        NumberDecimal dw 0  ;Contains number in decimal
        curpos dw 0 ;Saves current counter
        InputNumbers dw 1000 dup('$') ;Contains array of input numbers
        MaxValue dw 0   ;Saves the max value from the numbers inside InputNumbers
        MinValue dw 0   ;Saves the min value from the numbers inside InputNumbers
    ;For Reporte****************************************************************
        mesrep db "Reporte creado",13,10,"$"
        repname db "201801263.txt","$"
        handleReporte dw ?
        repmediana db 13,10,"Mediana: "
        repprom db 13,10,"Promedio: "
        repmoda db 13,10,"Moda: "
        repmax db 13,10,"Mayor: "
        repmin db 13,10,"Menor: "
        reptable db 13,10,"Numero    Frecuencia"
        repdate db 13,10,"Fecha: "
        reptime db 13,10,"Hora: "
        repdatos db 13,10,"Nombre: Sergio Sebastian Chacon Herrera"
        repcarnet db 13,10,"Carnet: 201709159"
        datesep db "/","$"
        timesep db ":","$"
        day db 2 dup(' ')
	    month db 2 dup(' ')
	    year db 4 dup(' ')
	    hour db 2 dup(' ')
	    min db 2 dup(' ')
	    sec db 2 dup(' ')
        charw dw ?
    ;Variables for commands*********************************************************
        ccprom db "cprom","$"
        cmediana db "cmediana","$"
        cmoda db "cmoda","$"
        cmax db "cmax","$"
        cmin db "cmin","$"
        cbarraasc db "cbarra_asc","$"
        cbarradesc db "cbarra_desc","$"
        cghist db "ghist","$"
        cglinea db "glinea","$"
        cabrir db "abrir_","$"
        climpiar db "limpiar","$"
        creporte db "reporte","$"
        cinfo db "info","$"
        csalir db "salir","$"
        mesini db "Proyecto2> ","$"
        inputtext db 50 dup ("$")
        comerr db "No existe el comando",13,10,"$"
    ;Variables to calculate statistics**********************************************
        avgsum dw 0
        mesavg db "Promedio: ","$"
        numtxt dw ? ;Contains any number in text type
        mesmedian db "Mediana: ","$"
        mesmode db "Moda: ","$"
        modevalue dw 0  ;Contains the number of the mode
        enteroprom dw 0 ;Contains the integer for average value in decimal form
        decimalprom dw 0    ;Contains the decimal for avegare in decimal form
        intpromtxt dw ? ;Contains the integer for average value in text form
        decpromtxt dw ? ;Contains the decimal for avegare in text form
        QtyNumbers dw 0 ;Contains the amount of numbers
        QtyNumbers2 dw 0    ;Containts the amount of numbers in ArrayOrder
        
        freqvalue dw 0 ;Contains current frequency
        ArrayOrder dw 500 dup('$')  ;Contains the input numbers
        ArrayFrequency dw 500 dup('$')  ;Contains the frequency of ArrayOrder
        ArrayASC dw 500 dup('$')   ;Contains input numbers in asc order
        ArrayDESC dw 500 dup('$')   ;Contains input numbers in desc order
        arrlength dw 0  ;Contains length of ArrayOrder
        num1 dw 0
        num2 dw 0
        intmedian dw ?    ;Contains the integer of median value
        decmedian dw ?    ;Contains the decimal of median value
    ;Variables for video mode
        BarLength dw  10    ;Contains the legth of the bars inside video mode
        Barpos dw  0    ;Contains the position of the bars inside video mode
        BarSep dw 5 ;Default separation between bars
        iniBar dw 0 ;Contais the position of start of a bar
        MaxHeight dw 0  ;Saves the max height for video mode
        DefaultMaxHeight dw 50 ;Containts default maximum height for video mode
        AuxHeight dw 0 ;Saves the auxiliar height
        StartBar dw 0   ;Starting position for bars in video mode
        empty db 0  ;Empty space
        empty2 db 0 ;Empty space 2
        empty3 db 0 ;Empty space 3
        count1 dw 0 ;Counter for video mode
        ArrayHeights dw 500 dup('$') ;Contains unique frequency values
        arrlengthheight dw 0  ;Contains length of ArrayHeights
        QtyNumbersHeight dw 0   ;Amount of numbers in height

        pointheight1 dw 0   ;Saves the position in y of point 1
        pointpos1 dw  0 ;Saves the poisition in x of point 1
        pointheight2 dw 0   ;Saves the position in y of point 2
        pointpos2 dw  0 ;Saves the poisition in x of point 2
        
.code
main proc   ;Main procedure starts
    mov dx,@data
    mov ds,dx
    mov es,dx
    start:
        PrintText mesini
        ReadText inputtext
        CompareString ccprom,inputtext
        je cprom
        CompareString cmediana,inputtext
        je mediana
        CompareString cmoda,inputtext
        je moda
        CompareString cmax,inputtext
        je max
        CompareString cmin,inputtext
        je lmin
        CompareString cbarraasc,inputtext
        je barraasc
        CompareString cbarradesc,inputtext
        je barradesc
        CompareString cghist,inputtext
        je ghist
        CompareString cglinea,inputtext
        je glinea
        CompareString climpiar,inputtext
        je limpiar
        CompareString creporte,inputtext
        je reporte
        CompareString cinfo,inputtext
        je info
        CompareString csalir,inputtext
        je salir
        VerifyLoad inputtext, FileName
        je abrir
        jmp comandoe
    cprom:
        PrintText mesavg
		Print16 enteroprom
		PrintText punto
		Print16 decimalprom
		PrintText ln
        jmp start
    mediana:
        PrintText mesmedian
        Print16 intmedian
        PrintText punto
        Print16 decmedian
        PrintText ln
        jmp start
    moda:
        PrintText mesmode
        Print16 modevalue
        PrintText ln
        jmp start
    max:
        Printtext maxnumtxt
        Print16 MaxValue
        PrintText ln
        jmp start
    lmin:
        Printtext minnumtxt
        Print16 MinValue
        PrintText ln
        jmp start
    barraasc:
        BubbleSortF ArrayOrder,ArrayFrequency,arrlength,orderASC
        Video12HON
        PaintBackgroud12H 15
        PaintBars12H ArrayOrder,ArrayFrequency, arrlength,freqvalue
        PaintIndexX12H ArrayOrder,arrlength
        PaintIndexY12H ArrayHeights,arrlengthheight
        EnterOption
        Video12HOFF
        jmp start
    barradesc:
        BubbleSortF ArrayOrder,ArrayFrequency,arrlength,orderDESC
        Video12HON
        PaintBackgroud12H 15
        PaintBars12H ArrayOrder,ArrayFrequency, arrlength,freqvalue
        PaintIndexX12H ArrayOrder,arrlength
        PaintIndexY12H ArrayHeights,arrlengthheight
        EnterOption
        Video12HOFF
        jmp start
    ghist:
        BubbleSortF ArrayFrequency,ArrayOrder,arrlength,orderASC
        Video12HON
        PaintBackgroud12H 15
        PaintBars12H ArrayOrder,ArrayFrequency,arrlength,freqvalue
        PaintIndexX12H ArrayOrder,arrlength
        PaintIndexY12H ArrayHeights,arrlengthheight
        EnterOption
        Video12HOFF
        jmp start
    glinea:
        BubbleSortF ArrayFrequency,ArrayOrder,arrlength,orderASC
        Video12HON
        PaintBackgroud12H 8
        PaintGLine12H ArrayOrder,ArrayFrequency,arrlength,freqvalue
        PaintIndexX12H ArrayOrder,arrlength
        PaintIndexY12H ArrayHeights,arrlengthheight
        EnterOption
        Video12HOFF
        jmp start
        jmp start
    abrir:
        jmp start
    limpiar:
        ClearScreen
        jmp start
    reporte:
        CreateReport
        jmp start
    info:
        PrintText header
        jmp start
    comandoe:
        PrintText comerr
        jmp start
    salir:
        mov ah,4ch  ;Exit program
        int 21h     ;Exit program
main endp   ;Main procedure ends
end main