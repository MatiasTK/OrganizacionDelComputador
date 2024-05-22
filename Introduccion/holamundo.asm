global main

extern puts
;es el print

section .data
    ;Si no pongo el 0 tira segfault, puts lee hasta 0 binario.
    mensaje db "Hola mundo", 0
section .text
main:
    mov rbp, rsp; for correct debugging

    sub rsp, 8
    mov rdi, mensaje
    call puts
    add rsp, 8

    ret
