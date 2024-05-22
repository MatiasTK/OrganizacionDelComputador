global main
extern printf
extern fopen
extern fclose
extern fread

section .data
    matriz times 144 db 0; 12x12=144
    filename db "PRECIOS.DAT",0
    mode db "rb",0
    msgError db "Error al abrir el archivo",0
    fileHandle dq 0
    formato db "%d %i %i",10,0
    registro times 0 db ""
        piso dw ""
        departamento db 0
        precio dd 0

section .bss

section .text
main:
    ;Abro el archivo
    mov rdi, filename
    mov rsi, mode
    sub rsp,8
    call fopen
    add rsp,8

    mov qword[fileHandle], rax

    cmp qword[fileHandle], 0
    jle errorApertura

    jmp leerArchivo

errorApertura:
    mov rax,0
    mov rdi,msgError
    sub rsp,8
    call printf
    add rsp,8

    jmp fin
leerArchivo:
    mov rdi, registro; Donde voy a copiar los datos
    mov rsi, 7; Long registro
    mov rdx, 1; Cantidad registros
    mov rcx, qword[fileHandle]; File handle
    sub rsp,8
    call fread
    add rsp,8

    cmp rax, 0
    jle eof

    ;Imprimir registro
    mov rdi, formato
    lea rsi, [piso]
    lea rdx, [departamento]
    lea rcx, [precio]
    sub rsp,8
    call printf
    add rsp,8
    jmp eof
eof:
    mov rdi, qword[fileHandle]
    sub rsp,8
    call fclose
    add rsp,8

    jmp fin
fin:
    ret
valreg:
    
