global validarLimites

extern printf

section .bss
    fila resb 1
    columna resb 1
section .text
; rdi fila
; rsi columna
; rax -> 0 si es valido, -1 si no es valido
validarLimites:
    mov [fila], rdi
    mov [columna], rsi
    sub rax, rax

    ; Limites matriz
    cmp byte[fila], 1
    jl validacionIncorrecta

    cmp byte[fila], 7
    jg validacionIncorrecta

    cmp byte[columna], 1
    jl validacionIncorrecta

    cmp byte[columna], 7
    jg validacionIncorrecta

    ; Espacios vacios
    cmp byte[fila], 3
    jl validarPrimerBloque
segundoBloque:
    cmp byte[fila], 3
    jl validarSegundoBloque
tercerBloque:
    cmp byte[fila], 5
    jg validarTercerBloque
cuartoBloque:
    cmp byte[fila], 5
    jg validarCuartoBloque
fin:
    ret

validarPrimerBloque:
    cmp byte[columna], 3
    jl validacionIncorrecta
    jmp segundoBloque
validarSegundoBloque:
    cmp byte[columna], 5
    jg validacionIncorrecta
    jmp tercerBloque
validarTercerBloque:
    cmp byte[columna], 3
    jl validacionIncorrecta
    jmp cuartoBloque
validarCuartoBloque:
    cmp byte[columna], 5
    jg validacionIncorrecta
    jmp fin
validacionIncorrecta:
    mov rax, -1
    ret