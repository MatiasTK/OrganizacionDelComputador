global estaOcaEncerrada

extern obtenerElemento
extern validarLimites

section .bss
    matrizDir resq 1
    posX resq 1
    posY resq 1
section .text
; rdi matrizDir
; rsi posX
; rdx posY
; rax -> 0 si no esta encerrada, 1 si esta encerrada
estaOcaEncerrada:
    mov [matrizDir], rdi
    mov [posX], rsi
    mov [posY], rdx
    sub rax,rax
    mov rax,0
chequearIzquierda:
    mov rdi, [posX]
    mov rsi, [posY]

    dec rdi

    sub rsp,8
    call validarLimites
    add rsp,8

    cmp rax,0
    jne chequearDerecha

    mov rdi, [matrizDir]
    mov rsi, [posX]
    mov rdx, [posY]

    dec rsi

    sub rsp,8
    call obtenerElemento
    add rsp,8

    cmp al, " "
    je esValido
chequearDerecha:
    mov rdi, [posX]
    mov rsi, [posY]

    inc rdi

    sub rsp,8
    call validarLimites
    add rsp,8

    cmp rax,0
    jne chequearArriba

    mov rdi, [matrizDir]
    mov rsi, [posX]
    mov rdx, [posY]

    inc rsi

    sub rsp,8
    call obtenerElemento
    add rsp,8

    cmp al, " "
    je esValido
chequearArriba:
    mov rdi, [posX]
    mov rsi, [posY]

    dec rsi

    sub rsp,8
    call validarLimites
    add rsp,8

    cmp rax,0
    jne chequearAbajo

    mov rdi, [matrizDir]
    mov rsi, [posX]
    mov rdx, [posY]

    dec rdx

    sub rsp,8
    call obtenerElemento
    add rsp,8

    cmp al, " "
    je esValido
chequearAbajo:
    mov rdi, [posX]
    mov rsi, [posY]

    inc rsi

    sub rsp,8
    call validarLimites
    add rsp,8

    cmp rax,0
    jne esValido

    mov rdi, [matrizDir]
    mov rsi, [posX]
    mov rdx, [posY]

    inc rdx

    sub rsp,8
    call obtenerElemento
    add rsp,8

    cmp al, " "
    je esValido
esInvalido:
    mov rax,1
    ret
esValido:
    mov rax,0
    ret