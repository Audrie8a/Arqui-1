QuickSortAsc proc 
	 mov cx,der
	 cmp izq,cx
	 jge fin
	 partitionAsc datosGrafico, izq, der
	 mov bx, der
	 push bx
	 mov ax, resultadoPartition
	 push ax
	 dec ax
	 mov der,ax

	 		;tienen que graficar aqui

	 call QuickSortAsc
	 pop ax 
	 pop bx 
	 mov der,bx
	 inc ax
	 mov izq,ax
	 call QuickSortAsc
	 fin:
	 	ret
	QuickSortAsc endp


partitionAsc macro arreglo, l ,h
LOCAL For, If, EndFor
push si
push di
push ax
push bx

	mov si,l
	mov di,h
	dec si
	mov resultadoPartition,si ; l -1

	mov al,arreglo[di]

	mov si, h
	dec si ; si = h-1
	mov di,l ; di = l
	For:
		cmp di,si
		ja EndFor
		cmp al,arreglo[di]
		jae If
		inc di
		jmp For

	If:
		inc resultadoPartition
		swap arreglo, resultadoPartition
		inc di
		jmp For

	EndFor:
		inc resultadoPartition
		mov di,h
		swap arreglo,resultadoPartition


pop bx
pop ax
pop di
pop si
endm

swap macro arreglo, i
push si
push ax
push bx

	mov si,i

	;[0][1]
	mov al,arreglo[si]  ;al = 1 - [1] = 1
	mov bl,arreglo[di]  ;di = 0 -  [0] = 0

	mov arreglo[si],bl ; [1]=0
	mov arreglo[di],al ; [0]=1
 
pop bx
pop ax
pop si
endm

partitionDesc macro arreglo, l ,h
LOCAL For, If, EndFor
push si
push di
push ax
push bx

	mov si,l
	mov di,h
	dec si
	mov resultadoPartition,si ; l -1

	mov al,arreglo[di]

	mov si, h
	dec si ; si = h-1
	mov di,l ; di = l
	For:
		cmp di,si
		ja EndFor
		cmp al,arreglo[di]
		jbe If
		inc di
		jmp For

	If:
		inc resultadoPartition
		swap arreglo, resultadoPartition
		inc di
		jmp For

	EndFor:
		inc resultadoPartition
		mov di,h
		swap arreglo,resultadoPartition


pop bx
pop ax
pop di
pop si
endm

swap macro arreglo, i
push si
push ax
push bx

	mov si,i

	;[0][1]
	mov al,arreglo[si]  ;al = 1 - [1] = 1
	mov bl,arreglo[di]  ;di = 0 -  [0] = 0

	mov arreglo[si],bl ; [1]=0
	mov arreglo[di],al ; [0]=1
 
pop bx
pop ax
pop si
endm