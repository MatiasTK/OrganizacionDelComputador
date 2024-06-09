global main

extern puts

section .data
    texto db "Organizacion del Computador", 0

section .text
main:
    sub rsp, 8
    mov rdi, texto
    call puts
    add rsp, 8

    ret