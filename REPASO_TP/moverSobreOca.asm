global moverSobreOca

extern moverElemento
extern obtenerElemento
extern validarLimites
section .bss
    matrizDir resq 1
    posX resq 1
    posY resq 1
    posXKill resq 1
    posYKill resq 1
    desplazamiento resw 1

section .text
; RDI: Matriz
; RSI,RDX = X,Y actual
; RCX, R8: X,Y KILL
; RAX -> -1 Si hay oca y no pudo matarla, 0 si no hay oca, 1 si hay oca y pudo matarla
moverSobreOca:
    mov [matrizDir], rdi
    mov [posX], rsi
    mov [posY], rdx
    mov [posXKill], rcx
    mov [posYKill], r8
    mov rax,0

    mov rdi, [matrizDir]
    mov rsi, [posX]
    mov rdx, [posY]

    sub rsp, 8
    call obtenerElemento
    add rsp,8

    cmp al, "O"
    je verificarSiSePuedeMatarOca

    sub rax,rax
    ret
verificarSiSePuedeMatarOca:
    mov rdi, [posXKill]
    mov rsi, [posYKill]

    sub rsp, 8
    call validarLimites
    add rsp, 8

    cmp rax, 0
    jne noSePudoMatar

    mov rdi, [matrizDir]
    mov rsi, [posXKill]
    mov rdx, [posYKill]

    sub rsp, 8
    call obtenerElemento
    add rsp, 8

    cmp al, 'O'
    je noSePudoMatar
matarOca:
    mov bx, [posY]
    dec bx
    imul bx,bx,14
    mov [desplazamiento],bx

    mov bx, [posX]
    dec bx
    imul bx,bx,2
    add [desplazamiento], bx

    mov ebx, [desplazamiento]
    movzx ecx, bl
    sub eax,eax
    mov rax, [matrizDir]
    add rax,rcx

    mov byte [rax], " "

    sub rax,rax
    mov rax, 1
    ret
noSePudoMatar:
    sub rax,rax
    mov rax, -1
    ret



