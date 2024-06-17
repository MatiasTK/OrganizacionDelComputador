global main

extern puts
extern sscanf
extern printf
extern gets

section .data
    mensajeInicio db "Ingrese una FILA y COLUMNA para imprimir(separados por un espacio): ",0
    formatoIngreso db "%i %i %i",0
    msgErrorParametrosInsuficientes db "Error, parametros insuficientes (falto la fila o columna)",10,0
    resultadoImpreso db "Ingresaste la fila: %hi columna: %hi",10,0
    msgOutputResultado db "El elemento es: %i",10,0
    matriz dw 0,1,1,1,1
           dw 2,2,2,2,2
           dw 3,3,3,3,3
           dw 4,4,4,4,4
           dw 5,5,5,5,5

    indiceFila dw 1
    indiceColumna dw 1
    msgErrorFila db "Error, la fila ingresada es invalida (debe estar entre 1 y 5)",10,0
    msgErrorColumna db "Error, la columna ingresada es invalida (debe estar entre 1 y 5)",10,0
    formatoElementoMatriz db "%i",0
    saltoLinea db "",10
section .bss
    input resb 50
    fila resw 1
    columna resw 1
    desplazamiento resw 1

    resultado resw 1

section .text

main:
preguntarIngreso:
    mov rdi, mensajeInicio
    sub rsp,8
    call puts
    add rsp,8

    mov rdi, input
    sub rsp, 8
    call gets
    add rsp, 8

    mov rdi, input
    call strLen
    cmp rax, 3
    jne errorParametrosInsuficiente

    mov rdi, input
    mov rsi, formatoIngreso
    mov rdx, fila
    mov rcx, columna
    sub rsp, 8
    call sscanf
    add rsp, 8
validarFila:
    mov bx, [fila]
    cmp bx, 1
    jl filaInvalida
    cmp bx,5
    jg filaInvalida
validarColumna:
    mov bx, [columna]
    cmp bx, 1
    jl columnaInvalida
    cmp bx, 5
    jg columnaInvalida
parametrosSuficientes:
    mov rdi, resultadoImpreso
    mov rsi, [fila]
    mov rdx, [columna]
    sub rsp,8
    call printf
    add rsp,8
calcularDesplazamiento:
    ; (FILA-1)*LongFil + (COLUMNA-1)*LongElemento
    ; LongFil = LongElemento * CANT_COLUMNAS
    ; LongElemento = 2 bytes (WORD)
    mov bx, [fila] ; 1) BX = FILA
    dec bx ; 2) BX = FILA - 1
    imul bx, bx, 10
    mov [desplazamiento], bx ; 3) DESPLAZAMIENTO = (FILA-1)*10

    mov bx, [columna] ; 4) BX = COLUMNA
    dec bx ; 5) COLUMNA - 1
    imul bx, bx, 2
    add [desplazamiento], bx

obtenerElemento:
    mov bx, [desplazamiento]
    sub eax, eax
    mov ax, [matriz+ebx]
    mov [resultado], eax


imprimirResultado:
    mov rdi, msgOutputResultado
    mov rsi, [resultado]
    sub rsp,8
    call printf
    add rsp,8


imprimirMatriz:
    mov rdi, matriz
    mov word[indiceFila], 1
    mov word[indiceColumna], 1
siguienteElemento:
    ; (FILA-1)*LongFil + (COLUMNA-1)*LongElemento
    ; LongFil = LongElemento * CANT_COLUMNAS
    ; LongElemento = 2 bytes (WORD)
    mov bx, [indiceFila]
    cmp bx, 6; Si llegue al final de la columna aumento la fila
    je endImprimirMatriz

    mov bx, [indiceColumna]
    cmp bx, 6; Llegue al final de la matriz
    je siguienteLinea

    mov bx, [indiceFila] ; 1) BX = FILA
    dec bx ; 2) BX = FILA - 1
    imul bx, bx, 10
    mov [desplazamiento], bx ; 3) DESPLAZAMIENTO = (FILA-1)*10

    mov bx, [indiceColumna] ; 4) BX = COLUMNA
    dec bx ; 5) COLUMNA - 1
    imul bx, bx, 2
    add [desplazamiento], bx

    mov bx, [desplazamiento]
    sub eax, eax
    mov ax, [matriz+ebx]
    mov rbx, rax

    mov rdi, formatoElementoMatriz
    mov rsi, rbx
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
    jmp siguienteElemento
endImprimirMatriz:
    ret

filaInvalida:
    mov rdi, msgErrorFila
    sub rsp, 8
    call puts
    add rsp, 8
    jmp preguntarIngreso
columnaInvalida:
    mov rdi, msgErrorColumna
    sub rsp, 8
    call puts
    add rsp, 8
    jmp preguntarIngreso

errorParametrosInsuficiente:
    mov rdi, msgErrorParametrosInsuficientes
    sub rsp, 8
    call puts
    add rsp, 8
    jmp preguntarIngreso

strLen:
    mov     rax,0
nextChar:
    cmp     byte[rdi+rax],0
    je      endStrLen
    inc     rax
    jmp     nextChar
endStrLen:
    ret
