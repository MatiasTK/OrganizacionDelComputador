global obtenerElemento

section .bss
    posX resq 1
    posY resq 1
    matrizDir resq 1
    desplazamiento resw 1
section .text
; rdi matrizDir
; rsi posX
; rdx posY
; rax -> elemento
obtenerElemento:
    sub rax,rax
    mov [posX],rsi
    mov [posY],rdx
    mov [matrizDir],rdi
encontrarElemento:
    mov bx, [posY]
    dec bx
    imul bx,bx,14
    mov [desplazamiento], bx

    mov bx, [posX]
    dec bx
    imul bx,bx, 2
    add [desplazamiento], bx

    mov ebx, [desplazamiento]
    movzx ecx, bl
    sub eax,eax
    mov rdx, [matrizDir]
    add rdx, rcx

    mov rax, [rdx]
    ret

