global main
extern puts

section .data
    tabla db "FKD", "EJG"
    t1 db "HIQ", "LMN"
    t2 db "OCR", "ABP"
    desplaz db 0
    val1 times 3 db 0

section .text
main:
    mov rdx,3
    mov rcx,1

    dec rdx
    imul rdx,6

    sub rcx,1
    imul rcx,2

    add rdx,rcx
    lea rax, [tabla]
    add rax,rdx

    sub rdx,10
    mov rcx,rdx

    mov rsi,rax
    mov rdi,val1
    rep movsb

    mov rdi,val1
    sub rsp,8
    call puts
    add rsp,8

    sub rax,rax
    mov ax, [t1+4]
    ret