global strlen

section .text
; Voy a asumir que en rdi esta la dir de inicio de string.
strlen:
    mov rax,0
nextChar:
    cmp byte[rdi+rax],0
    je endstrlen
    inc rax
    jmp nextChar
endstrlen:
ret