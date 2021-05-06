;============= Abrir archivo=====================
OpenFile macro array,handler
    local erro,fini
    mov ah,3dh
    mov al,10b
    lea dx,array
    int 21h
    jc erro ; If file does not exists go to erro
    mov handler,ax
    mov ax,0
    jmp fini
    erro:
        mov ax,1
    fini:
    endm
;============== MACRO CERRAR ARCHIVO==============
CloseFile macro handler
    mov ah,3eh
    mov bx,handler
    int 21h
    endm
;=========== MACRO LEER ARCHIVO===========
ReadFile macro handler,array,numbytes
    mov ah,3fh
    mov bx,handler
    mov cx,numbytes ; numero maximo de bytes a leer(para proyectos hacerlo gigante) 
    lea dx,array
    int 21h
    endm
;======================== MACRO CREAR ARCHIVO (any extension) ===================
CreateFile macro array,handler
    mov ah,3ch
    mov cx,00h
    lea dx,array
    int 21h
    mov bx,ax
    mov ah,3eh
    int 21h
    endm
; ========================= MACRO ESCRIBIR EN ARCHIVO YA CREADO =================
WriteFile macro handler,array,numbytes
    mov ah,40h
    mov bx,handler
    mov cx,numbytes
    lea dx, array
    int 21h
    endm