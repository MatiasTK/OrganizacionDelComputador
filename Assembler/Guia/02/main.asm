%macro mGets 0
    sub rsp, 8
    call gets
    add rsp, 8
%endMacro

%macro mPuts 0
    sub rsp, 8
    call puts
    add rsp, 8
%endMacro

%macro mPrintf 0
    sub rsp, 8
    call printf
    add rsp, 8
%endMacro

global main

extern puts
extern gets
extern printf

section .data
    msgNombre db "Ingrese el nombre y apellido del alumno: ",0
    msgPadron db "Ingrese el padron del alumno: ",0
    msgFecha db "Ingrese la fecha de nacimiento del alumno: ",0
    msgResultado db "El alumno %s con padron %s nacio el %s",10,0

section .bss
    nombre resb 100
    padron resb 100
    fecha resb 100

section .text
main:
    mov rdi, msgNombre
    mPrintf

    mov rdi, nombre
    mGets

    mov rdi, msgPadron
    mPrintf

    mov rdi, padron
    mGets

    mov rdi, msgFecha
    mPrintf

    mov rdi, fecha
    mGets

    mov rdi, msgResultado
    mov rsi, nombre
    mov rdx, padron
    mov rcx, fecha

    mPrintf
    ret