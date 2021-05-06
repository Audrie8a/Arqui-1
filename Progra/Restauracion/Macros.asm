;================================================GENERAL MACROS=========================================
ClearScreen macro   ;Clears the screen
  mov  ah, 0
  mov  al, 3
  int  10H
	endm
PrintText macro Text    ;Prints "Text"
    mov ax,@data
    mov ds,ax
    mov ah,09h
    lea dx,Text
    int 21h
	endm
PrintRegister macro Register    ;Prints "Register"
    xor ax,ax
    mov dl,Register
    mov ah,02h
    int 21h
	endm
EnterOption macro   ;Read input for options
    mov ah,01   ;Input mode
    int 21h     ;Input mode
	endm
Print16 macro Regis ;Print a 16bit number
    local zero,noz
	PushAll
    mov bx,4    ;Moves 4 into bx
    xor ax,ax   ;Clears ax
    mov ax,Regis    ;Moves Regis into ax
    mov cx,10   ;Moves 10 into cx
    zero:
        xor dx,dx   ;Clear dx
        div cx  ;Divide ax by 10
        push dx ;Push the residue into stack
        dec bx  ;Decrease counter
        jnz zero    ;Jump if bx is not zero to zero
        xor bx,4    ;Set bx to 4
    noz:
        pop dx  ;Pop dx from sttack
        PrintN dl   ;Print digit in dl
        dec bx  ;Decrease bx
        jnz noz ;Jump if bx is not zero to noz
		PopAll
	endm
Print16AUX macro Regis ;Print a 16bit number
    local zero,noz
	PushAll
    mov bx,3    ;Moves 4 into bx
    xor ax,ax   ;Clears ax
    mov ax,Regis    ;Moves Regis into ax
    mov cx,10   ;Moves 10 into cx
    zero:
        xor dx,dx   ;Clear dx
        div cx  ;Divide ax by 10
        push dx ;Push the residue into stack
        dec bx  ;Decrease counter
        jnz zero    ;Jump if bx is not zero to zero
        xor bx,3    ;Set bx to 4
    noz:
        pop dx  ;Pop dx from sttack
        PrintN dl   ;Print digit in dl
        dec bx  ;Decrease bx
        jnz noz ;Jump if bx is not zero to noz
		PopAll
	endm
Print8 macro Regis	;Prints an 8bit number
    local zero,noz
    mov bx,2
    xor ax,ax
    mov ax,Regis
    mov cx,10
    zero:
    xor dx,dx
    div cx;NUMERO / 10
    push dx
    dec bx
    jnz zero
    xor bx,2
    noz:
    pop dx
    PrintN dl
    dec bx
    jnz noz

	endm
PrintN macro Num    ;Print a digit
    xor ax,ax
    mov dl,Num
    add dl,48
    mov ah,02h
    int 21h
	endm
ReadText macro array   ;Reads input text
    local read  ;Read mode
    local fin   ;End of number
    xor si,si   ;Clear si
    read:
        mov ah,1    ;Input mode
        int 21h     ;Input mode
        cmp al, 13  ;Compare if input is "ENTER"
        je fin   ;If input is "ENTER" go to fin
        mov array[si],al   ;Save input into buffer position si
		inc si  ;Increment counter si
        jmp read    ;Read next input
    fin: ;End of number
		mov array[si],24h   ;Save input into buffer position si
	endm
TextToDecimal macro array, des ;Converts text to decimal
    Local start
    Local fin
    Local negative
    Local positive
    Local done
    Local negate
	PushAll
	xor ax,ax   ;Clears ax registry
	xor bx,bx   ;Clears bx registry
	xor cx,cx   ;Clears cx registry
	xor di,di   ;Clears di resistry, 0 = Positive, 1 = Negative
	mov bx,10	;Moves 10 into bx
	xor si,si   ;Clears si registry, for counter of position inside buffer
	start:
		mov cl,array[si]   ;Move buffer in position si into cl
		cmp cl,45   ;Compares if cl is "-"
		je negative ;If cl is "-" jump to negative
		jmp positive    ;If cl is not "-" jump to positive
	negative:
		inc di  ;Increment di to 1, now the number is negative
		inc si  ;Increment si by 1 to read next value
		mov cl,array[si]   ;Move the next value into cl
	positive:
		cmp cl,48   ;Compares if cl is 0
		jl fin  ;Jump to negate
		cmp cl,57   ;Compares if cl is 9
		jg fin  ;Jump to negate
		inc si  ;Increment si to read next value
		sub cl,48	;Substract 48 to cl to get number
		mul bx		;Multiply ax by bx
		add ax,cx	;Add to ax cx
		jmp start   ;Jump to start
	fin:
		cmp di,1    ;Compares if di = 1
		je negate   ;Go to negate to negate ax
		jmp done    ;If di = 0 go to done
	negate:
		neg ax  ;Negates ax
	done:
        mov des,ax  ;Moves register ax into des, which is output
		PopAll
	endm
DecimalToText macro entrada, salida ;Converts decimal to text
    Local divide
    Local divide2
    Local make
    Local negative
    Local done
	PushAll
    xor ax,ax   ;Clear ax
    mov ax,entrada  ;Move number into ax
	xor si,si   ;Clear si
	xor cx,cx   ;Clear cx
	xor bx,bx   ;Clear bx
	xor dx,dx   ;Clear dx
	mov bx,0ah  ;Move 10 into bx
	test ax,1000000000000000    ;Compare if ax is negative
	jnz negative    ;If ax is negative go to negative
	jmp divide2 ;if ax is positive go to divide2
	negative:
		neg ax  ;Negate ax to make it positive
		mov salida[si],45   ;Move a "-" at the start of text
		inc si  ;Increment counter si
		jmp divide2    ;Go to divide 2
	divide:
		xor dx,dx   ;Clear dx
	divide2:
		div bx  ;divide ax by bx
		inc cx  ;Increment counter cx
		push dx ;Push dx register into stack
		cmp ax,00h  ;Campre if ax is 0
		je make ;IF ax is 0 go to make
		jmp divide  ;If ax is not 0 go to divide
	make:
		pop ax  ;Take out last register from stack
		add ax,30h  ;Make conversion
		mov salida[si],ax   ;Move ax into salida position si
		inc si  ;Increment counter si
		loop make ;Loop to make
		mov ax,24h  ;Move $ to ax
		mov salida[si],ax   ;Move ax into salida position si
		inc si  ;Increment si
	done:
		PopAll
		;PrintText salida    ;Display result
	endm
PushAll macro	;Saves all values into stack
    push ax
    push bx
    push cx
    push dx
	push si
    push di
    push sp
    push bp
	endm
PopAll macro	;Retrieves all values from stack
    pop bp
    pop sp
    pop di
    pop si
	pop dx
    pop cx
    pop bx
    pop ax
	endm
ClearAll macro	;Clears all the registries
	xor ax,ax
    xor bx,bx
    xor cx,cx
    xor dx,dx
	xor si,si
    xor di,di
	endm
Delay macro number	;Dleay with value
	local loop1
	local loop2
	local done
	push ax
	push bx
	xor ax,ax
	xor bx,bx
	mov ax,number
	loop1:
		dec ax
		jz done
		mov bx,number
	loop2:
		dec bx
		jnz loop2
		jmp loop1
	done:
		pop bx
		pop ax
	endm
CloneArray macro original,clone,length	;Clone an array dw
	local l2,l3
	push si
	push ax
	xor ax,ax
	xor si,si
	mov si,0	
	l2:
		mov ax,original[si]
		mov clone[si],ax
		cmp si,length
		je l3
		inc si
		inc si	;Double increment because array will be dw type
		jmp l2
	l3:
		pop ax
		pop si
	endm
PrintArrayDW macro array,length	;Prints elements inside dw array
	local print1
	local done
	PushAll
	ClearAll
	mov si,0
	mov ax,array[si]
	print1:
		mov decform, ax
		Print16 decform
		cmp si,length
		je done
		inc si
		inc si
		PrintText space
		mov ax,array[si]
		jmp print1
	done:
		PopAll
	endm
CompareString macro string1, string2	;Compares two strings
	lea si, string1
	lea di, string2
	mov cx, LENGTHOF string1	
	repe CMPSB
	endm
DivideWithDecimal macro reg1,reg2,resinteger,resdecimal	;Divides two numbers and saves the decimal
	local l1
	PushAll
    xor dx,dx
    mov ax,reg1
    mov bx,reg2
    div bx	;reg1/reg2
    xor cx,cx
    mov resinteger,ax
    l1:
        mov ax,dx	;Move residue to ax
        xor dx,dx
        push bx	;Save number
        mov bx,10
        mul bx
        pop bx	;Pop number
        xor dx,dx
        div bx	;Residue = Residue * 10
        push ax
        push dx
        push bx
        xor dx,dx
        mov ax,resdecimal
        mov bx,10
        mul bx
        mov resdecimal,ax
        pop bx
        pop dx
        pop ax
        add resdecimal,ax
        inc cx
        cmp cx,4
        jnz l1
		PopAll
	endm
GenerateUniqueArray macro array,arrayresu,length,lengthresu	;Generate array with unique values and saves it into array resu
	local read1
	local compare
	local done
	local newv
	PushAll
	ClearAll
	mov lengthresu,0	;Resets length 
	mov si,0
	mov di,0
	mov ax,array[si]	;Moves first element of original array into ax
	mov arrayresu[di],ax	;Moves firs element of original array into arrayresu
	read1:
		xor di,di
		cmp si,length	;Compares if si equals to length of original array
		je done	;If it is equal go to done
		inc si
		inc si	;Moves to next position
		mov ax,array[si]	;Moves next element into ax
		jmp compare	;Go to compare
	compare:
		mov bx,arrayresu[di]
		cmp ax,bx
		je read1
		cmp bx,'$'
		je newv
		inc di
		inc di
		jmp compare
	newv:
		mov arrayresu[di],ax
		inc lengthresu
		inc lengthresu
		jmp read1
	done:
		PopAll
	endm
;==============================================LOAD FILE MACROS=======================================
VerifyLoad macro string,resu	;String receives the full command, resu is the file name
	local start
	local getname
	local finc
	local fin
	local done
	PushAll
	xor si,si
	xor di,di
	mov resu,0
	start:
		mov al,string[si]
		cmp al,"_"
		je getname
		cmp al,"$"
		je fin
		inc si
		jmp start
	getname:
		inc si
		mov al,string[si]
		cmp al,"$"
		je finc
		mov resu[di],al
		inc di
		jmp getname
	finc:
		mov resu[di+1],00h
		LoadFile resu
		CompareString cabrir,cabrir	;Compare same string to say it is a correct command
		jmp done
	fin:
		CompareString csalir,cabrir	;Compare different strings to say it is incorrect command
		jmp done
	done:
		PopAll
	endm
LoadFile macro input	;Loads file with name input
	local continue
	local fin
    OpenFile input, HandlerFile
	cmp ax,1
	jne continue
	PrintText nonexist
	jmp fin
	continue:
    	ReadFile HandlerFile, FileContent, SIZEOF FileContent
    	CloseFile HandlerFile
		AnalyzeContent FileContent
		PrintText fileloaded
	fin:
	endm
AnalyzeContent macro input	;Analyze the content from input
	local maintag
	local secondtag
	local number
	local csecondtag
	local verify
	local verify2
	local cmaintag
	local savenumber
	local show
	local done
	local checkmax
	local checkmin
	local assignmin
	local assignmax
	mov MaxValue,0	;Reset max value
	mov MinValue,999	;Reset min value
	mov si,-1	;Position inside input
	mov TextNCounter,0	;Position inside TextNumber
	mov posarr,-2	;Position inside InputNumber
	maintag:
		inc si
		mov bl,input[si]
		cmp bl,'>'
		jne maintag
		jmp secondtag
	secondtag:
		inc si
		mov bl,input[si]
		cmp bl,">"
		jne secondtag
		jmp number
	number:
		inc si
		mov bl,input[si]
		cmp bl,"<"
		je savenumber
		mov di,TextNCounter
		mov TextNumber[di],bl
		inc TextNCounter
		jmp number
	savenumber:
		inc posarr	;Increment counter
		inc posarr	;Increment counter
		mov curpos,si	;Save current position inside input text
		TextToDecimal TextNumber,NumberDecimal	;Make conversion of TextNumber to decimal
		mov si,curpos	;Restore position
		mov di,posarr	;Move posarr into di
		mov bx,NumberDecimal	;Move number in decimal format to bx
		mov InputNumbers[di],bx	;Move number into InputNumbers position di
		mov TextNumber[2],0
		mov TextNumber[1],0	;Move null to TextNumber position di
		mov TextNCounter,0	;reset counter
		mov TextNumber,0	;Move null to TextNumber
		jmp checkmax
	checkmax:
		mov ax,MaxValue
		cmp bx,ax
		je checkmin
		jl checkmin
		jg assignmax
	assignmax:
		mov MaxValue,bx
		jmp checkmin
	checkmin:
		mov ax,MinValue
		cmp bx,ax
		je csecondtag
		jg csecondtag
		je assignmin
	assignmin:
		mov MinValue,bx
		jmp csecondtag
	csecondtag:
		inc si
		mov bl,input[si]
		cmp bl,">"
		je verify
		jmp csecondtag
	verify:
		inc si
		mov bl,input[si]
		cmp bl,"<"
		je verify2
		jmp verify
	verify2:
		inc si
		mov bl,input[si]
		cmp bl,"/"
		je cmaintag
		jmp secondtag
	cmaintag:
		inc si
		mov bl,input[si]
		cmp bl,"$"
		jne cmaintag
		;PrintText numres
		;mov di,0
		;jmp show
	show:
		;Print16 InputNumbers[di]
		;cmp di,posarr
		;je done
		;inc di
		;inc di
		;PrintText coma
		;jmp show
	done:
		BubbleSort InputNumbers,posarr,orderASC
		CalcAverage InputNumbers,posarr
		GenerateFreq InputNumbers,posarr
		FindMode ArrayOrder,ArrayFrequency,arrlength
		FindMedian InputNumbers,posarr
		GenerateUniqueArray ArrayFrequency,ArrayHeights,arrlength,arrlengthheight
		BubbleSort ArrayHeights,arrlengthheight,orderDESC
		mov ax,arrlength
		mov bx,2
		add ax,bx
		cwd
		idiv bx
		mov QtyNumbers2,ax
	endm
;============================================STATISTIC MACROS=========================================
CalcAverage macro array,length	;Calculates average value
	local start
	local divide
	PushAll
	xor si,si
	xor ax,ax
	xor bx,bx
	start:
		mov bx,array[si]
		add ax,bx
		cmp si,length
		je divide
		inc si
		inc si
		jmp start
	divide:
		mov avgsum,ax
		mov bx,2
		mov ax,length
		add ax,2
		cwd
		idiv bx	;divide length by 2 to obtain the amount of numbers
		mov QtyNumbers,ax	;Move amount of numbers into QtyNumbers
		DivideWithDecimal avgsum,QtyNumbers,enteroprom,decimalprom
	PopAll
	endm
GenerateFreq macro array,length	;Generate array with frequencies
	local read1
	local compare
	local done
	local newv
	local assign
	PushAll
	ClearAll
	mov arrlength,0
	mov si,0
	mov di,0
	mov ax,array[si]	;Moves first element of original array into ax
	mov ArrayOrder[di],ax	;Moves firs element of original array into ArrayOrder
	mov ArrayFrequency[di],1
	read1:
		xor di,di
		cmp si,length
		je done
		inc si
		inc si
		mov ax,array[si]
		jmp compare
	compare:
		mov bx,ArrayOrder[di]
		cmp ax,bx
		je assign
		cmp bx,'$'
		je newv
		inc di
		inc di
		jmp compare
	newv:
		mov ArrayOrder[di],ax
		inc arrlength
		inc arrlength
		mov ArrayFrequency[di],1
		jmp read1
	assign:
		mov ax,ArrayFrequency[di]
		mov bx,1
		add ax,bx
		mov ArrayFrequency[di],ax
		xor di,di
		jmp read1
	done:
		PopAll
	endm
FindMode macro array,arrayf,length	;array contains the array with numbers and arrayf the frequency for each number
	local start
	local continue
	local assign
	local done
	PushAll
	mov si,0	;Reset counter
	mov ax,arrayf[si]	;Moves first frequency into ax
	mov freqvalue,ax	;Moves current frequency into freqvalue
	mov bx,array[si]	;Moves first value into bx
	mov modevalue,bx	;Moves first value into modevalue
	start:
		cmp si,length
		je done
		jmp continue
	continue:
		inc si
		inc si
		mov ax,arrayf[si]
		cmp ax,freqvalue
		jg assign
		jmp start
	assign:
		mov bx,array[si]
		mov modevalue,bx
		mov bx,arrayf[si]
		mov freqvalue,bx
		jmp start
	done:
		PopAll
	endm
FindMedian macro array,length	;Finds the median value of an array
	local even
	local odd
	local fin
	PushAll
	mov bx,2
	mov ax,length
	add ax,2
	cwd
	idiv bx
	mov QtyNumbers,ax
	cwd
	idiv bx
	cmp dx,0
	je	even
	jmp	odd
	even:
		mov ax,length
		add ax,2
		mov bx,2
		cwd
		idiv bx
		mov si,ax
		mov bx,array[si]
		mov num1,bx
		dec si
		dec si
		mov bx,array[si]
		mov num2,bx
		mov ax,num1
		mov bx,num2
		add ax,bx
		mov bx,2
		mov num1,ax
		mov num2,bx
		DivideWithDecimal num1,num2,intmedian,decmedian
		jmp fin
	odd:
		mov ax,length
		mov bx,2
		cwd
		idiv bx
		mov si,ax
		mov bx,array[si]
		mov intmedian,bx
		jmp fin
	fin:
		PopAll
	endm
;======================================SORT MACROS================================================
BubbleSort macro array,length,order	;Executes bubblesort ASC(1) and DESC(2) 
	local setord
	local changeASC
	local changeDESC
	local done
	local check
	local check2
	local fin
	PushAll
	ClearAll
	mov si,0	;Reset si
	mov di,0
	cmp si,length	;Check if array is empty
	je fin	;Array is empty, do nothing
	setord:
		mov ax,array[si]	;Move first value into ax
		mov bx,array[si+2]	;Move next value into bx
		cmp order,'2'
		je changeDESC
		jmp changeASC
	changeASC:	;Changes ASC
		cmp ax,bx	;Compare first value and next value
		jl done	;If it is lesser go to done
		je done	;If they are equal go to done
		mov array[si],bx	;Moves second value into position si
		mov array[si+2],ax	;Moves first value into next position
		inc si
		inc si
		mov di,0	;Reset the correct moves
		jmp check
	changeDESC:	;Changes DESC
		cmp ax,bx	;Compare first value and next value
		je done	
		jg done	
		mov array[si],bx	;Moves second value into position si
		mov array[si+2],ax	;Moves first value into next position
		inc si
		inc si
		mov di,0	;Reset the correct moves
		jmp check
	done:	;There is no need for change
		inc di	;Increment correct moves
		inc di	;Increment correct moves
		inc si
		inc si
		jmp check
	check:	;Check if array is complete
		cmp si,length
		je check2
		jmp setord
	check2:
		cmp di,si
		je fin
		mov di,0	;Reset correct moves
		mov si,0	;Reset position inside original array
		jmp setord
	fin:
		PopAll
	endm
BubbleSortF macro array,arrayF,length,order	;Executes bubblesort ASC(1) and DESC(2) for array with frequencies
	local setord
	local changeASC
	local changeDESC
	local done
	local check
	local check2
	local fin
	PushAll
	ClearAll
	mov si,0	;Reset si
	mov di,0
	cmp si,length	;Check if array is empty
	je fin	;Array is empty, do nothing
	setord:
		mov ax,arrayF[si]	;Move first value into ax
		mov bx,arrayF[si+2]	;Move next value into bx
		cmp order,'2'
		je changeDESC
		jmp changeASC
	changeASC:	;Changes ASC
		cmp ax,bx	;Compare first value and next value
		jl done	;If it is lesser go to done
		je done	;If they are equal go to done
		mov arrayF[si],bx	;Moves second value into position si
		mov arrayF[si+2],ax	;Moves first value into next position
		mov ax,array[si]
		mov bx,array[si+2]
		mov array[si],bx
		mov array[si+2],ax
		inc si
		inc si
		mov di,0	;Reset the correct moves
		jmp check
	changeDESC:	;Changes DESC
		cmp ax,bx	;Compare first value and next value
		je done	
		jg done	
		mov arrayF[si],bx	;Moves second value into position si
		mov arrayF[si+2],ax	;Moves first value into next position
		mov ax,array[si]
		mov bx,array[si+2]
		mov array[si],bx
		mov array[si+2],ax
		inc si
		inc si
		mov di,0	;Reset the correct moves
		jmp check
	done:	;There is no need for change
		inc di	;Increment correct moves
		inc di	;Increment correct moves
		inc si
		inc si
		jmp check
	check:	;Check if array is complete
		cmp si,length
		je check2
		jmp setord
	check2:
		cmp di,si
		je fin
		mov di,0	;Reset correct moves
		mov si,0	;Reset position inside original array
		jmp setord
	fin:
		PopAll
	endm
;======================================VIDEO MODE MACROS==========================================
Video12HON macro	;Starts video mode INT 10h/12h
	mov ax, 0012h	;480x640
	int 10h
	mov ax, 0A000h
	mov es, ax
	endm
Video12HOFF macro	;Ends video mode INT 10h/12h
	mov ah, 00h
	mov al, 03h
	int 10h
	mov dx,@data
    mov ds,dx
    mov es,dx
	endm
PaintBackgroud12H macro color	;Paints the backgroud of a set color INT 10h/12h
	local loop1
	local loop2
	PushAll
	ClearAll
	mov ah,0ch
	mov bh,00h
	mov al, color	;Pixel color
	mov cx, 0	;Position x
	mov dx, 0	;Position y
	int 10h	;Paint pixel
	loop1:
		inc cx	;Increment column
		int 10h	;Paint pixel
		cmp cx,640	;Compare if cx reached the last column
		je loop2	;if it is in the last column go to loop2
		jmp loop1	;If not continue painting next column
	loop2:
		mov cx,0	;Reset column counter
		inc dx	;Increment row
		cmp dx,481	;Compare if dx paint all rows
		jne loop1	;If not go to loop1
		PopAll
	endm
PaintIndexX12H macro array, length	;Paints indexes below bars INT 10h/12H
	local printnumber
	PushAll
	xor dx,dx
	mov ax,BarLength	;Based off BarLength move into ax
	mov bx,8d	;8d move into bx
	div bx
	mov empty,al	;Move al into empty space
	xor dx,dx
	xor ax,ax
	mov al,empty
	mov bx,2d
	div bx
	mov empty2,al	;Divide empty2 by al
	xor cx,cx
	mov cl,0	;Starting position for indexes
	mov al,empty2
	add cl,al
	mov empty3,cl
	mov count1,-2	;Starting position to read array
	jmp printnumber
	printnumber:
		mov dl, empty3
		mov dh, 29
		mov bx, 0
		mov ah, 2h
		int 10h
		xor cx,cx
		inc count1
		inc count1
		mov si, count1
		mov cx,array[si]
		Print16AUX cx
		mov cl, empty3
		add cl,empty
		inc cl
		mov empty3,cl
		mov dx,count1
		cmp dx,length
		jne printnumber
		PopAll
	endm
PaintIndexY12H macro array, length	;Paints indexes below bars INT 10h/12H
	local printnumber
	PushAll
	SetLength12H length,QtyNumbersHeight
	xor dx,dx
	mov ax,BarLength	;Based off BarLength move into ax
	mov bx,8d	;8d move into bx
	div bx
	mov al,7	;Position for max height
	mov empty,al	;Move al into empty space
	xor dx,dx
	xor ax,ax
	mov al,empty
	mov bx,2d
	div bx
	mov empty2,al	;Divide empty2 by al
	xor cx,cx
	mov cl,0	;Starting position for indexes
	mov al,empty2
	add cl,al
	mov empty3,cl
	mov count1,-2	;Starting position to read array
	jmp printnumber
	printnumber:
		mov dl, 0	;Rows
		mov dh, empty3	;Columns
		mov bx, 0
		mov ah, 2h
		int 10h
		xor cx,cx
		inc count1
		inc count1
		mov si, count1
		mov cx,array[si]
		Print8 cx
		mov cl, empty3
		add cl,empty
		;inc cl
		mov empty3,cl
		mov dx,count1
		cmp dx,length
		jne printnumber
		PopAll
	endm
SetLength12H macro arrlength,numbers	;Set the length of the bars inside video mode INT 10h/12H
	PushAll
	;This step is necessary because in my array of InputNumbers the length is double the amount of numbers
	xor dx,dx   ;Clear dx
    mov bx, 2    ;Move 2 into bx
    mov ax, arrlength   ;Move the length of array(InputNumbers) into ax
	add ax,bx
    cwd ;Convert word to doubleword
    idiv bx ;Divide ax by bx
    mov numbers, ax    ;Move ax into number1n
	;End extra step----------------------------------
	mov bx,numbers	;Amount of numbers into ax
	mov ax,5	;Space between bars
	dec bx	;decrement the amount of numbers by 1
	imul bx
	mov bx,ax	;Move ax into bx
	mov ax,620	;Space for bars
	sub ax,bx	;Substract bx to ax
	mov bx,numbers
	cwd
	idiv bx	;Divide ax by bx
	mov BarLength,ax	;Save length for bars into BarLength
	PopAll
	endm
SetHeight12H macro height,maxi	;Sets the height of the bars inside video mode INT 10h/12H
	PushAll
	mov ax,460	;460 is the base of the bars
	mov bx,DefaultMaxHeight
	sub ax, bx	;Base - max height
	mov bx,height
	imul bx	;Multiply height of bar by possible height
	mov bx,maxi	;Move max value into bx
	idiv bx	;Divide current height by bx
	mov bx,ax	;Save value into bx
	mov ax,460	;460 is base of the bars
	sub ax,bx	;460-height
	mov AuxHeight, ax	;Move ax into aux height
	PopAll
	endm
PaintBars12H macro array,arrayF,length,maxi	;Paints the graph in video mode INT 10h/12H
	local setbar
	local paint
	local paint2
	local check
	local done
	PushAll
	SetLength12H length,QtyNumbers
	mov cx,5	;Starting position for bars in x
	mov dx,460	;Starting position for bars in y
	mov si,-2	;Starting position for array
	mov Barpos,0	;Reset bar position
	jmp setbar
	setbar:	;Sets position for bar
		push cx
		inc si
		inc si
		mov cx,arrayF[si]
		SetHeight12H cx,maxi
		pop cx
		add cx,BarSep	;Separation
		mov iniBar,cx	;Save starting position into cx
		mov ax,BarLength
		add ax,cx
		mov Barpos,ax
		mov bh,00h
		mov ah,0ch
		mov al,3	;Pixel color
		jmp paint
	paint:
		inc cx
		int 10h	;Paint pixel
		cmp cx,Barpos
		je paint2
		jmp paint
	paint2:
		dec dx
		cmp dx,AuxHeight	;Height here
		je check
		mov cx,iniBar
		jmp paint
	check:
		mov dx,460
		cmp si,length
		je done
		jmp setbar
	done:
		PopAll
	endm
PaintGLine12H macro array,arrayF,length,maxi
	local check
	local point1
	local point2
	local setpaint
	local verticaldown
	local horizontal
	local verticalup
	local done
	PushAll
	SetLength12H length,QtyNumbers
	mov cx,10	;Starting position for bars in x
	mov si,0	;Starting position for array
	jmp check
	check:
		cmp si,length
		je done
		jmp point1
	point1:
		push cx
		mov cx,arrayF[si]
		SetHeight12H cx,maxi
		inc si
		inc si
		pop cx
		mov ax,AuxHeight
		mov pointheight1, ax	;Height of point 1
		mov pointpos1,cx	;Position of point 1
		jmp point2
	point2:
		push cx
		mov cx,arrayF[si]
		SetHeight12H cx,maxi
		pop cx
		mov ax,AuxHeight
		mov pointheight2, ax	;Height of point 2
		mov bx,BarLength
		add cx,bx
		mov bx,5
		add cx,bx
		mov pointpos2,cx	;Position of point 2
		jmp setpaint
	setpaint:
		mov bh,00h
		mov ah,0ch
		mov al,11	;Pixel color
		mov cx,pointpos1
		mov dx,pointheight1
		cmp dx,pointheight2
		jg	verticaldown
		je	horizontal
		jl	verticalup
	verticaldown:
		inc cx
		dec dx
		int 10h	;Paint pixel
		cmp dx,pointheight2
		je check
		cmp cx,pointpos2
		jne verticaldown
		jmp check
	horizontal:
		inc cx
		int 10h
		cmp cx,pointpos2
		je check
		jmp horizontal
	verticalup:
		inc cx
		inc dx
		int 10h	;Paint pixel
		cmp dx,pointheight2
		je check
		cmp cx,pointpos2
		jne verticalup
		jmp check
	done:
		PopAll
	endm
;======================================REPORT MACROS==============================================
CreateReport macro	;Creates file for report
	local desc
	local asc
	local continue
	local bubble
	local quick
	local shell
	local continue2
    MakeDate
    MakeTime
    CreateFile repname, handleReporte
    OpenFile repname,handleReporte
	;======================================STARTS FILE CONTENT======================
	WriteFile handleReporte,repdatos,SIZEOF repdatos
	WriteFile handleReporte,repcarnet,SIZEOF repcarnet
	WriteFile handleReporte,repdate,SIZEOF repdate
	WriteFile handleReporte,day,SIZEOF day
	WriteFile handleReporte,datesep,1
	WriteFile handleReporte,month,SIZEOF month
	WriteFile handleReporte,datesep,1
	WriteFile handleReporte,year,SIZEOF year
	WriteFile handleReporte,reptime,SIZEOF reptime
	WriteFile handleReporte,hour,SIZEOF hour
	WriteFile handleReporte,timesep,1
	WriteFile handleReporte,min,SIZEOF min
	WriteFile handleReporte,timesep,1
	WriteFile handleReporte,sec,SIZEOF sec
	WriteFile handleReporte,reptable,SIZEOF reptable
	;---------------------------------------------------------------
	FillTable
	;---------------------------------------------------------------
	WriteFile handleReporte,repmediana,SIZEOF repmediana
	DecimalToText intmedian,numtxt
	WriteChar numtxt
	WriteFile handleReporte,punto,1
	DecimalToText decmedian,numtxt
	WriteChar numtxt
	WriteFile handleReporte,repprom,SIZEOF repprom
	DecimalToText enteroprom,numtxt
	WriteChar numtxt
	WriteFile handleReporte,punto,1
	DecimalToText decimalprom,numtxt
	WriteChar numtxt
	WriteFile handleReporte,repmoda,SIZEOF repmoda
	DecimalToText modevalue,numtxt
	WriteChar numtxt
	WriteFile handleReporte,repmax,SIZEOF repmax
	DecimalToText MaxValue,numtxt
	WriteChar numtxt
	WriteFile handleReporte,repmin,SIZEOF repmin
	DecimalToText MinValue,numtxt
	WriteChar numtxt
	;======================================ENDS FILE CONTENT========================
    CloseFile handleReporte
    PrintText mesrep
	endm
FillTable macro	;Fill table with frequencies and numbers inside the report
	local start
	local done
	PushAll
	mov si,0
	start:
		mov ax,ArrayOrder[si]
		mov decform,ax
		DecimalToText decform,numtxt
		WriteFile handleReporte,ln,1
		WriteChar numtxt
		WriteFile handleReporte,tab,SIZEOF tab
		WriteFile handleReporte,tab,SIZEOF tab
		WriteFile handleReporte,tab,SIZEOF tab
		mov bx,ArrayFrequency[si]
		mov decform,bx
		DecimalToText decform,numtxt
		WriteChar numtxt
		cmp si,arrlength
		je done
		inc si
		inc si
		jmp start
	done:
		PopAll
	endm
WriteChar macro text	;Write a single character inside the report
    local check
    local loop
    local fin
	PushAll
    xor di,di
	mov di,0
    mov ax,text[di]
    check:
        cmp ax,"$"
        jne loop
        jmp fin
    loop:
        mov charw,ax
        WriteFile handleReporte,charw,1
        inc di
        mov ax,text[di]
        jmp check
    fin:
		PopAll
	endm
MakeDate macro  ;Create the date
    xor ax,ax   ;Clear ax
    xor bx,bx   ;Clear bx
    getDate
    mov bx,cx   ;Move year into bx
    ToString bx,year
    xor bx,bx
    getDate
    mov bl,dh   ;Move month into bl
    ToString bx,month
    xor dl,dl
    getDate
    mov bl,dl   ;Move day into bx
    ToString bx,day
    xor bx,bx
	endm
MakeTime macro  ;Create the time
    xor ax,ax   ;Clear ax
    xor bx,bx   ;Clear bx
    getTime
	mov bl,ch   ;Move hours into bl
	ToString bx,hour
	getTime
	mov bl,cl   ;Move minutes into bl
	ToString bx,min
	getTime
	mov bl,dh   ;Move seconds into bl
	ToString bx,sec
	endm
getDate macro  ;Obtain system date
	mov ah,2ah
	int 21h
	endm
getTime macro   ;Obtain system time
	mov ah,2ch
	int 21h
	endm
ToString macro input, result    ;Date and Time to String
    Local divide
    Local make
    Local divide2
    xor si,si   ;Clear counter si
    xor cx,cx   ;Clear xc registry
    xor ax,ax   ;Clear ax registry
    mov ax,input    ;Move input to ax
    mov dl,10   ;Move 10 to dl
    jmp divide
    divide:
        div dl  ;Divide ax by dl
        inc cx  ;Increment cx
        push ax ;Push result into stack
        cmp al, 0   ;Compare al with 0
        je  make
        jmp divide2
    divide2:
        xor ah,ah   ;Clear ah registry
        jmp divide
    make:
        pop ax  ;Obtain last element of stack ax
        add ah,30h  ;Make conversion
        mov result[si],ah   ;Move ah into result position si
        inc si  ;Increment si
        Loop make
	endm