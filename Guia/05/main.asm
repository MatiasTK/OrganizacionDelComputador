%macro mPrintf 1
    mov rdi, %1
    sub rsp, 0
    call printf
    add rsp,0
%endMacro

global main
extern printf

section .data
    array dw 1,2,3,4,5,6,8,9,10,11,12,13,14,15,16,17,18,19,20
    msgMax db "El numero maximo es %i", 10,0
    msgMin db "El numero minimo es %i", 10,0
    msgPromedio db "El promedio es %i", 10,0
    pos db 0
section .bss
    max resw 1
    min resw 1
    sum resd 1
section .text
main:
    mov ax, [array]
    mov [max], ax
    mov [min], ax
    mov dword[sum], 0
loop:
    mov rcx, [pos]
    dec rcx
    imul ebx, ecx, 2

    mov ax, [array + ebx]
    cmp ax, [max]
    jle noMax
    mov [max], ax
noMax:
    cmp ax, [min]
    jge noMin
    mov [min], ax
noMin:
    add dword[sum], eax
    inc dword[pos]
    cmp dword[pos], 10
    jne loop

    mov eax, [max]
    mPrintf msgMax
    mov eax, [min]
    mPrintf msgMin
    mov eax, [sum]
    mov ebx, 10
    idiv ebx
    mPrintf msgPromedio
    ret
