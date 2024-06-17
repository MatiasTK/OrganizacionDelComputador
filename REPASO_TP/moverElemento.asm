global moverElemento

extern printf

section .data
    formatoMovimiento db "ENCONTRADO: %c",10,0
section .bss
    posXInicial resq 1
    posYInicial resq 1
    posXFinal resq 1
    posYFinal resq 1
    desplazamiento resw 1
    matrizDir resq 1
    letra resq 1
section .text
; rdi matrizDir
; rsi x inicial
; rdx y inicial
; rcx x final
; r8 y final
; r9 letra
moverElemento:
    mov [matrizDir], rdi
    mov [posXInicial], rsi
    mov [posYInicial], rdx
    mov [posXFinal], rcx
    mov [posYFinal], r8
    mov [letra], r9
    mov rax, 0
borrarPosicionActual:
    mov bx, [posYInicial]
    dec bx
    imul bx,bx, 14
    mov [desplazamiento], bx

    mov bx, [posXInicial]
    dec bx
    imul bx,bx, 2
    add [desplazamiento], bx

    mov ebx, [desplazamiento]
    movzx ecx, bl; Porque? Nadie lo sabe. pero sin esta linea no funciona nada.
    sub eax,eax
    mov rax, [matrizDir]
    add rax, rcx

    mov byte [rax], " "

agregarPosicionNueva:
    mov bx, [posYFinal]
    dec bx
    imul bx,bx, 14
    mov [desplazamiento], bx

    mov bx, [posXFinal]
    dec bx
    imul bx,bx, 2
    add [desplazamiento], bx

    mov ebx, [desplazamiento]
    movzx ecx, bl; Porque? Nadie lo sabe. pero sin esta linea no funciona nada.
    sub eax,eax
    mov rax, [matrizDir]
    add rax, rcx

    movzx ecx, byte [letra]
    mov byte [rax], cl

    ret