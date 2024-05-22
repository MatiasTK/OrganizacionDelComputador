%macro mPrintf 0
    sub rsp,8
    call printf
    add rsp,8
%endMacro

%macro mScanf 0
    sub rsp,8
    call scanf
    add rsp,8
%endMacro


global main
extern printf
extern scanf

section .data
    msgEj db "Ingresa 15 numeros:",10, 0
    msgFormato db "%d", 0

section .bss
    numerosArray resd 32
    numerosCount resd 1

section .text
main:
    mov rdi, msgEj
    mPrintf

    mov dword[numerosCount], 0
    mov rdi, 0
agregarNumero:
    cmp dword[numerosCount], 5
    je imprimirNumeros

    mov rdi, msgFormato
    mov rsi, numerosArray
    mScanf

    inc dword[numerosCount]
    add rsi, 4
    jmp agregarNumero
imprimirNumeros:
    mov rbx,0
    mov rsi, [numerosArray]
    mov rdi, msgFormato
imprimirNumero:
    mPrintf

    add rbx, 1
    add rsi, 4
    cmp rbx, [numerosCount]
    jne imprimirNumero

    ret
