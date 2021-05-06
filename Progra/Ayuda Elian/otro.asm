;-----------------------------------------------------MACROS
include macrostc.asm

pixelPaint macro i, j, color

    push ax
    push bx
    push di

    xor ax, ax
    xor bx, bx
    xor di, di

    mov ax, 320d
    mov bx, i
    mul bx

    add ax, j

    mov di, ax
    mov [di], color

    xor ax, ax
    xor bx, bx
    xor di, di

    pop di
    pop bx
    pop ax


ENDM

paintBorder MACRO up, down, left, right, color

    LOCAL FOR1, FOR2, OUT_BORDER

    push si

    xor si, si
    mov si, left

    FOR1: 

        pixelPaint up, si, color
        pixelPaint down, si, color
        inc si

        cmp si, right
        jne FOR1

    xor si, si
    mov si, up

    FOR2: 

        pixelPaint si, left, color
        pixelPaint si, right, color

        inc si

        cmp si, down
        jne FOR2

    OUT_DELAY: 

        pop si

    
ENDM

paintBar MACRO up, down, left, right, color


    ;call seg_video
    LOCAL FOR1, FOR2, OUT_BAR

    push si
    push cx

    xor si, si
    mov si, left                                ;5
    xor cx, cx
    mov cx, up                                  ;25

    FOR1: 
        ;xor di, di
        mov cx, up

        FOR2: 

            pixelPaint cx, si, color            ;25, 5; 26, 5; 27, 5; 28, 5
            ;pixelPaint di, si, color

            inc cx                              ;26, 27, 28, 29

            cmp cx, down                        ;29 != 30
            jne FOR2
        
        inc si                                  
        cmp si, right
        jne FOR1

    OUT_BAR: 
        ;delay 2000

        pop cx
        pop si

    
ENDM
posCursor MACRO row, column

    ;Guardamos los registros para no perder la información
    ;que se tenian al momento de llamar la función
    push ax 
    push bx
    push dx

    xor ax, ax

    mov ah, 02h             ;Movemos la función a ah
    mov bh, 00h             ;Indicamos que la página de video es la 0
    mov dh, row             ;el parametro row tendrá el número de fila 
    mov dl, column          ;el parametro column tendrá el número de columna
    int 10h                 ;ejecuta la función 02h

    xor ax, ax

    pop dx
    pop bx
    pop ax
    
    ;Devolvemos la inforamción previa a los registros
    
ENDM

delay macro retard

    LOCAL FOR1, FOR2, OUT_DELAY

    push ax
    push bx

    xor ax, ax
    xor bx, bx

    mov ax, retard

    FOR1:

        dec ax
        jz OUT_DELAY

        mov bx, retard

        FOR2: 
            dec bx
            jnz FOR2

        jmp FOR1

    OUT_DELAY:
        xor ax, ax
        xor bx, bx 


    pop ax
    pop bx

ENDM

;----------------------------------------------------DECLARACIONES
.model small

;----------------------------------------------------PILA
.stack

;----------------------------------------------------SEGMENTO DE DATOS
.data
mesage db "Hola", "$"
;----------------------------------------------------SEGMENTO DE CODIGO
.code

main proc
    mov dx, @data
    mov ds, dx

    call mode_video
          
          
          call seg_text
          posCursor 5d, 12d
          print mesage

          call seg_video
          delay(5000)

    call mode_text
   
     
main endp


 mode_video proc

        mov ax, 13h
        int 10h

        mov dx, 0A000h
        mov ds, dx
        ret

    mode_video endp

    mode_text proc

        mov ax, 03h
        int 10h

        mov dx, @DATA
        mov ds, dx
        mov es, dx

        ret

    mode_text endp

    seg_video proc

        push dx

        mov dx, 0A000h
        mov ds, dx

        pop dx

        ret

    seg_video endp

    ;description
    seg_text PROC

        push dx

        mov dx, @DATA
        mov ds, dx

        pop dx

        ret
        
    seg_text ENDP


end 