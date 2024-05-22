%macro mPrintf 0
    sub rsp, 8
    call printf
    add rsp, 8
%endmacro

%macro mGets 0
    sub rsp, 8
    call gets
    add rsp, 8
%endmacro

%macro mSscanf 0
    sub rsp, 8
    call sscanf
    add rsp, 8
%endmacro

global main

extern printf
extern gets
extern sscanf

section .data
    msgNumero db "Digite un numero: ", 0
    msgPotencia db "Digite la potencia a la que desea elevar el numero: ", 0
    msgResultado db "El resultado es %d", 10,0
    nFormat db " %d", 0

section .bss
    buffer resb 100
    numero resd 100
    potencia resd 100
    resultado resd 100

section .text
main:
    mov rdi, msgNumero
    mPrintf
    mov rdi, buffer
    mGets

    mov rdi, buffer
    mov rsi, nFormat
    mov rdx, numero
    mSscanf

    mov rdi, msgPotencia
    mPrintf
    mov rdi, buffer
    mGets

    mov rdi, buffer
    mov rsi, nFormat
    mov rdx, potencia
    mSscanf

    mov eax, dword[numero]
    mov dword[resultado], eax
aplicarPotencia:
    ; No hago caso con potencia negativa, me tengo me meter con floats...
    cmp dword[potencia], 1
    je exit
    mov eax, dword[numero]
    mov ebx, dword[resultado]
    mul ebx
    mov dword[resultado], eax
    dec dword[potencia]
    jmp aplicarPotencia
exit:
    mov rdi, msgResultado
    mov rsi, [resultado]
    mPrintf

    ret
