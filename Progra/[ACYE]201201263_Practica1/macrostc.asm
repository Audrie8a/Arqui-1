print macro p1
mov ax,@data
mov ds,ax
lea dx, p1 ; Equivalente a lea dx, cadena, inicializa en dx la posicion donde comienza la cadena
mov ah,09h ;Numero de funcion para imprimir cadena en pantalla
;mov dx, offset p1
int 21h
endm

getNum macro
mov ah,01h
int 21h
sub al,30h
mov bh, al
endm

getChar macro
mov ah,01h
int 21h
endm


LimpiarArrays macro buffer
	Local Mientras
	xor si,si
	mov cx,5
	Mientras:
		mov buffer[si],24h
		inc si
		Loop Mientras
endm


obtenerTexto macro buffer 
	Local obtenerChar, FinOT
	xor si,si ;igual a mov si,0

	obtenerChar:
		getChar
		cmp al,0dh ;ascii del salto de línea en hexadecimal
		je FinOT
		mov buffer[si],al;mov destino, fuente
		;print buffer[si]
		inc si; si=si+1
		jmp obtenerChar

	FinOT:
		mov al, 24h	; ascii del signo dolar 
		mov buffer[si],al
endm


Limpiar macro
	xor bx,bx
	xor si,si
	xor cx,cx
	xor dx,dx
endm



;Suma= bh.bl + ch.cl

;digito 1 num 1 bh
;digito 2 num 1 bl

;digito 1 num 2 ch
;digito 2 num 2 cls