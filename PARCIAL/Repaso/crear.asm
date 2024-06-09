global main
extern printf
extern fopen
extern fclose
extern fwrite
extern rewind

section .data
    filename db "PRECIOS.DAT",0
    mode db "wb",0
    msgErrorOpen db "Error al abrir el archivo",0

    registro times 0 db ""
    piso dw 1
    departamento db 1
    precio dd 5000

    registro1 times 0 db ""
    dw '1'
    db 2
    dd 2000

    registro2 times 0 db ""
    dw '2'
    db 1
    dd 3000

section .bss
    fileHandle resq 1

section .text
main:
    mov rdi, filename
    mov rsi, mode
    sub rsp,8
    call fopen
    add rsp,8

    cmp rax,0
    jg agregarRegistros

    mov rdi, msgErrorOpen
    sub rsp,8
    call printf
    add rsp,8
    jmp fin
agregarRegistros:
    mov [fileHandle], rax

    mov rdi, registro
    mov rsi, 7
    mov rdx, 1
    mov rcx, [fileHandle]
    sub rsp,8
    call fwrite
    add rsp,8

;    mov rdi, registro1
;    mov rsi, 7
;    mov rdx, 1
;    mov rcx, [fileHandle]
;    sub rsp,8
;    call fwrite
;    add rsp,8
;
;    mov rdi, registro2
;    mov rsi, 7
;    mov rdx, 1
;    mov rcx, [fileHandle]
;    sub rsp,8
;    call fwrite
;    add rsp,8
eof:
    mov rdi, [fileHandle]
    sub rsp,8
    call fclose
    add rsp,8
fin:
    ret