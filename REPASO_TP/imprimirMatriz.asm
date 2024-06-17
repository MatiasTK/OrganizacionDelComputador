
global imprimirMatriz

extern system
extern printf

section .data
    msgFilaActual db "%i",0
    formatoElementoMatriz dw " %c",0
    saltoLinea dw "",10
    indiceColumna dw 1
    indiceFila dw 1
    msgColumnas db "  1 2 3 4 5 6 7",10,0
    clear db "clear",0
section .bss
    desplazamiento resw 1
    matriz resq 1
section .text
; rdi matriz
imprimirMatriz:
    sub rax,rax
    sub rbx,rbx
    mov [matriz], rdi
    mov rax,0

    mov word[indiceFila], 1
    mov word[indiceColumna], 1

    mov rdi, clear
    sub rsp, 8
    call system
    add rsp, 8

    mov rdi, msgColumnas
    sub rsp, 8
    call printf
    add rsp, 8
mostrarFilaActual:
    sub rsi, rsi
    mov rdi, msgFilaActual
    mov si, [indiceFila]
    sub rsp,8
    call printf
    add rsp,8
siguienteElemento:
    ; (FILA-1)*LongFil + (COLUMNA-1)*LongElemento
    ; LongFil = LongElemento * CANT_COLUMNAS
    ; LongElemento = 2 bytes (WORD)
    mov bx, [indiceColumna]
    cmp bx, 8; Llegue al final de la matriz
    je siguienteLinea

    mov bx, [indiceFila] ; 1) BX = FILA
    dec bx ; 2) BX = FILA - 1
    imul bx, bx, 14
    mov [desplazamiento], bx ; 3) DESPLAZAMIENTO = (FILA-1)*10

    mov bx, [indiceColumna] ; 4) BX = COLUMNA
    dec bx ; 5) COLUMNA - 1
    imul bx, bx, 2
    add [desplazamiento], bx

    mov bx, [desplazamiento]
    sub eax, eax
    mov rax, [matriz]
    add rax, rbx

    mov rdi, formatoElementoMatriz
    mov rsi, [rax]
    sub rsp,8
    call printf
    add rsp,8

    inc word[indiceColumna]
    jmp siguienteElemento
siguienteLinea:
    inc word[indiceFila]
    mov word[indiceColumna], 1
    mov rdi, saltoLinea
    sub rsp, 8
    call printf
    add rsp, 8

    mov bx, [indiceFila]
    cmp bx, 8; Si llegue al final de la columna aumento la fila
    je endImprimirMatriz

    jmp mostrarFilaActual
endImprimirMatriz:
    ret
