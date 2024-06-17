global main
extern imprimirMatriz
extern printf
extern gets
extern strLen
extern moverElemento
extern validarLimites
extern sscanf
extern estaOcaEncerrada
extern estaZorroEncerrado
extern obtenerElemento
extern moverSobreOca
section .data
    matriz dw "-","-","O","O","O","-","-"
           dw "-","-","O","O","O","-","-"
           dw "O","O","O","O","O","O","O"
           dw "O"," "," "," "," "," ","O"
           dw "O"," "," ","X"," "," ","O"
           dw "-","-"," "," "," ","-","-"
           dw "-","-"," "," "," ","-","-"
    msgMovimientoAyuda db "Teclas:",10,"↖ (Q) ↑ (W) ↗ (E)",10,"← (A) ↓ (S) → (D)", 10,"↙ (Z)       ↘ (C)",10,"SALIR (X)",10,0
    msgMovimientoAyudaOca db "Teclas:",10,"      ↑ (W)",10,"← (A) ↓ (S) → (D)",10,"SALIR (X)",10,0
    msgSeleccion db "Seleccion: ",0
    msgTurnoZorro db "TURNO DEL ZORRO",10,0
    msgTurnoOcaRaw db "TURNO DE LA OCA",10,0
    msgOcaFila db "Elige la fila (X) de la oca a controlar: ", 0
    msgOcaColumna db "Elige la columna (Y) de la oca a controlar: ", 0
    msgTurnoOca db "TURNO DE LA OCA en la posicion X:%i Y:%i",10,0
    msgErrorTecla db "ERROR: La tecla ingresada no es valida",10,0
    msgErrorOca db "ERROR: No se puede comer a la oca",10,0
    msgErrorPosOca db "ERROR: No hay ninguna oca en la posicion elegida",10,0
    msgErrorMovOca db "ERROR: La oca no se puede mover a esa posicion porque esta ocupada",10,0
    msgErrorOcaEncerrada db "ERROR: La oca esta encerrada y no se puede mover, selecciona otra oca",10,0
    msgErrorPosicion db "ERROR: No te puedes mover a esa posicion",10,0
    msgErrorPosicionOca db "ERROR: La posicion seleccionada no es valida",10,0
    msgGanadorZorro db "JUEGO FINALIZADO: Gana el zorro por matar a 12 ocas",10,0
    msgGanadorOca db "JUEGO FINALIZADO: Ganan las ocas por encerrar al zorro",10,0
    posXZorro db 4
    posYZorro db 5
    posXOca dq 0
    posYOca dq 0
    ocasMatadas db 0
    turnoActual db "Z"
    formatoPos db "%i",0
section .bss
    posXOcaRaw resq 1
    posYOcaRaw resq 1
    movimientoTecla resb 1

section .text
main:
    mov rdi,matriz
    sub rsp,8
    call imprimirMatriz
    add rsp,8
comenzarMovimiento:
    mov rdi,msgTurnoZorro
    sub rsp,8
    call printf
    add rsp,8

    mov rdi,msgMovimientoAyuda
    sub rsp,8
    call printf
    add rsp,8
preguntarMovimiento:
    mov rdi, msgSeleccion
    sub rsp,8
    call printf
    add rsp,8

    sub rsp,8
    mov rdi, movimientoTecla
    call gets
    add rsp,8

    jmp validarTecla
moverse:
; Casos moverse direcciones, si no cumple ninguna letra entonces es un error.
    cmp byte [movimientoTecla], 'W'
    je moverseArriba

    cmp byte[movimientoTecla], 'w'
    je moverseArriba

    cmp byte [movimientoTecla], 'S'
    je moverseAbajo

    cmp byte [movimientoTecla], 's'
    je moverseAbajo

    cmp byte [movimientoTecla], 'A'
    je moverseIzquierda

    cmp byte[movimientoTecla], 'a'
    je moverseIzquierda

    cmp byte [movimientoTecla], 'D'
    je moverseDerecha

    cmp byte[movimientoTecla], 'd'
    je moverseDerecha

    cmp byte [movimientoTecla], 'Q'
    je moverseArribaIzquierda

    cmp byte[movimientoTecla], 'q'
    je moverseArribaIzquierda

    cmp byte [movimientoTecla], 'E'
    je moverseArribaDerecha

    cmp byte[movimientoTecla], 'e'
    je moverseArribaDerecha

    cmp byte [movimientoTecla], 'Z'
    je moverseAbajoIzquierda

    cmp byte[movimientoTecla], 'z'
    je moverseAbajoIzquierda

    cmp byte [movimientoTecla], 'C'
    je moverseAbajoDerecha

    cmp byte[movimientoTecla], 'c'
    je moverseAbajoDerecha

    cmp byte [movimientoTecla], 'X'
    je salirTecla

    cmp byte[movimientoTecla], 'x'
    je salirTecla

    mov rdi,msgErrorTecla
    sub rsp,8
    call printf
    add rsp,8

    jmp preguntarMovimiento
salirTecla:
    ret
terminarMovimiento:
    sub rdi,rdi
    mov rdi,matriz
    sub rsp,8
    call imprimirMatriz
    add rsp,8

    cmp byte[ocasMatadas], 12
    je ganadorZorro

    lea rdi,matriz
    mov rsi, [posXZorro]
    mov rdx, [posYZorro]

    sub rsp,8
    call estaZorroEncerrado
    add rsp,8

    cmp rax, 1
    je ganadorOca

    cmp byte[turnoActual], 'Z'
    je comenzarMovimientoOca

    mov byte[turnoActual], 'Z'
    jmp comenzarMovimiento
ganadorZorro:
    mov rdi,msgGanadorZorro
    sub rsp,8
    call printf
    add rsp,8
    ret
ganadorOca:
    mov rdi,msgGanadorOca
    sub rsp,8
    call printf
    add rsp,8
    ret
teclaPosicionInvalidaOca:
    mov rdi,msgErrorPosicionOca
    sub rsp,8
    call printf
    add rsp,8
    jmp cambiarTurnoOca
comenzarMovimientoOca:
    mov rdi,msgTurnoOcaRaw
    sub rsp,8
    call printf
    add rsp,8
cambiarTurnoOca:
    mov rdi, msgOcaFila
    sub rsp,8
    call printf
    add rsp,8

    mov rdi, posXOcaRaw
    sub rsp,8
    call gets
    add rsp,8

    mov rdi, msgOcaColumna
    sub rsp,8
    call printf
    add rsp,8

    mov rdi, posYOcaRaw
    sub rsp,8
    call gets
    add rsp,8

    sub rdi,rdi
    mov rdi, posXOcaRaw
    sub rsp,8
    call strLen
    add rsp,8

    cmp rax,1
    jne teclaPosicionInvalidaOca

    sub rdi,rdi
    mov rdi, posYOcaRaw
    sub rsp,8
    call strLen
    add rsp,8

    cmp rax,1
    jne teclaPosicionInvalidaOca

    mov rdi, posXOcaRaw
    mov rsi, formatoPos
    mov rdx, posXOca
    sub rsp,8
    call sscanf
    add rsp,8

    mov rdi, posYOcaRaw
    mov rsi, formatoPos
    mov rdx, posYOca
    sub rsp,8
    call sscanf
    add rsp,8

    mov rdi, [posXOca]
    mov rsi, [posYOca]

    sub rsp,8
    call validarLimites
    add rsp,8

    cmp rax, 0
    jne ocaInvalida

    lea rdi, matriz
    mov rsi, [posXOca]
    mov rdx, [posYOca]

    sub rsp,8
    call obtenerElemento
    add rsp,8

    cmp al, "O"
    jne ocaElegidaInvalida

    lea rdi, matriz
    mov rsi, [posXOca]
    mov rdx, [posYOca]

    sub rsp,8
    call estaOcaEncerrada
    add rsp,8

    cmp rax, 1
    je ocaEncerrada

    mov byte[turnoActual], "O"

    mov rdi,matriz
    sub rsp,8
    call imprimirMatriz
    add rsp,8

    mov rdi, msgTurnoOca
    mov rsi, [posXOca]
    mov rdx, [posYOca]
    sub rsp,8
    call printf
    add rsp,8

    mov rdi, msgMovimientoAyudaOca
    sub rsp,8
    call printf
    add rsp,8

    jmp preguntarMovimientoOca
ocaElegidaInvalida:
    mov rdi, msgErrorPosOca
    sub rsp,8
    call printf
    add rsp,8
    jmp cambiarTurnoOca
ocaEncerrada:
    mov rdi, msgErrorOcaEncerrada
    sub rsp,8
    call printf
    add rsp,8
    jmp cambiarTurnoOca
ocaInvalida:
    mov rdi, msgErrorPosicionOca
    sub rsp,8
    call printf
    add rsp,8
    jmp cambiarTurnoOca
validarTecla:
    sub rdi,rdi
    mov rdi, movimientoTecla
    sub rsp,8
    call strLen
    add rsp,8

    cmp rax, 1
    jne teclaInvalida

    jmp moverse
teclaInvalida:
    mov rdi,msgErrorTecla
    sub rsp,8
    call printf
    add rsp,8
    jmp preguntarMovimiento
movimientoInvalido:
    mov rdi,msgErrorPosicion
    sub rsp,8
    call printf
    add rsp,8
    jmp preguntarMovimiento
movimientoInvalidoKill:
    mov rdi,msgErrorOca
    sub rsp,8
    call printf
    add rsp,8
    jmp preguntarMovimiento
moverseArriba:
    mov rdi, [posXZorro]
    mov rsi, [posYZorro]
    dec rsi

    sub rsp,8
    call validarLimites
    add rsp,8

    cmp rax, 0
    jne movimientoInvalido

    sub rdi, rdi
    sub rsi,rsi

    lea rdi, matriz
    mov rsi, [posXZorro]
    mov rdx, [posYZorro]
    mov rcx, [posXZorro]
    mov r8, [posYZorro]
    dec rdx
    dec r8
    dec r8

    sub rsp, 8
    call moverSobreOca
    add rsp, 8

    cmp rax,0
    jl movimientoInvalidoKill

    sub rdi, rdi
    sub rsi,rsi

    lea rdi, matriz
    mov rsi, [posXZorro]
    mov rdx, [posYZorro]
    mov rcx, [posXZorro]
    mov r8, [posYZorro]
    mov r9, "X"

    dec r8

    cmp rax,0
    je realizarMovimientoArriba

    inc byte[ocasMatadas]
    dec r8
realizarMovimientoArriba:
    mov [posXZorro], rcx
    mov [posYZorro], r8

    sub rsp,8
    call moverElemento
    add rsp,8

    jmp terminarMovimiento

moverseAbajo:
    mov rdi, [posXZorro]
    mov rsi, [posYZorro]
    inc rsi

    sub rsp,8
    call validarLimites
    add rsp,8

    cmp rax, 0
    jne movimientoInvalido

    sub rdi, rdi
    sub rsi,rsi

    lea rdi, matriz
    mov rsi, [posXZorro]
    mov rdx, [posYZorro]
    mov rcx, [posXZorro]
    mov r8, [posYZorro]
    inc rdx
    inc r8
    inc r8

    sub rsp, 8
    call moverSobreOca
    add rsp, 8

    cmp rax,0
    jl movimientoInvalidoKill

    sub rdi, rdi
    sub rsi,rsi

    lea rdi, matriz
    mov rsi, [posXZorro]
    mov rdx, [posYZorro]
    mov rcx, [posXZorro]
    mov r8, [posYZorro]
    mov r9, "X"

    inc r8

    cmp rax,0
    je realizarMovimientoAbajo

    inc byte[ocasMatadas]
    inc r8
realizarMovimientoAbajo:

    mov [posXZorro], rcx
    mov [posYZorro], r8

    sub rsp,8
    call moverElemento
    add rsp,8

    jmp terminarMovimiento

moverseIzquierda:
    mov rdi, [posXZorro]
    mov rsi, [posYZorro]
    dec rdi

    sub rsp,8
    call validarLimites
    add rsp,8

    cmp rax, 0
    jne movimientoInvalido

    sub rdi, rdi
    sub rsi,rsi

    lea rdi, matriz
    mov rsi, [posXZorro]
    mov rdx, [posYZorro]
    mov rcx, [posXZorro]
    mov r8, [posYZorro]
    dec rsi
    dec rcx
    dec rcx

    sub rsp, 8
    call moverSobreOca
    add rsp, 8

    cmp rax,0
    jl movimientoInvalidoKill

    sub rdi, rdi
    sub rsi,rsi

    lea rdi, matriz
    mov rsi, [posXZorro]
    mov rdx, [posYZorro]
    mov rcx, [posXZorro]
    mov r8, [posYZorro]
    mov r9, "X"

    dec rcx

    cmp rax,0
    je realizarMovimientoIzquierda

    inc byte[ocasMatadas]
    dec rcx
realizarMovimientoIzquierda:
    mov [posXZorro], rcx
    mov [posYZorro], r8

    sub rsp,8
    call moverElemento
    add rsp,8

    jmp terminarMovimiento
moverseDerecha:
    mov rdi, [posXZorro]
    mov rsi, [posYZorro]
    inc rdi

    sub rsp,8
    call validarLimites
    add rsp,8

    cmp rax, 0
    jne movimientoInvalido

    sub rdi, rdi
    sub rsi,rsi

    lea rdi, matriz
    mov rsi, [posXZorro]
    mov rdx, [posYZorro]
    mov rcx, [posXZorro]
    mov r8, [posYZorro]
    inc rsi
    inc rcx
    inc rcx

    sub rsp, 8
    call moverSobreOca
    add rsp, 8

    cmp rax,0
    jl movimientoInvalidoKill

    sub rdi, rdi
    sub rsi,rsi

    lea rdi, matriz
    mov rsi, [posXZorro]
    mov rdx, [posYZorro]
    mov rcx, [posXZorro]
    mov r8, [posYZorro]
    mov r9, "X"

    inc rcx

    cmp rax,0
    je realizarMovimientoDerecha

    inc byte[ocasMatadas]
    inc rcx
realizarMovimientoDerecha:
    mov [posXZorro], rcx
    mov [posYZorro], r8

    sub rsp,8
    call moverElemento
    add rsp,8

    jmp terminarMovimiento
moverseArribaIzquierda:
    mov rdi, [posXZorro]
    mov rsi, [posYZorro]
    dec rsi
    dec rdi

    sub rsp,8
    call validarLimites
    add rsp,8

    cmp rax, 0
    jne movimientoInvalido

    sub rdi, rdi
    sub rsi,rsi

    lea rdi, matriz
    mov rsi, [posXZorro]
    mov rdx, [posYZorro]
    mov rcx, [posXZorro]
    mov r8, [posYZorro]

    dec rsi
    dec rdx

    dec rcx
    dec rcx
    dec r8
    dec r8


    sub rsp, 8
    call moverSobreOca
    add rsp, 8

    cmp rax,0
    jl movimientoInvalidoKill

    sub rdi, rdi
    sub rsi,rsi

    lea rdi, matriz
    mov rsi, [posXZorro]
    mov rdx, [posYZorro]
    mov rcx, [posXZorro]
    mov r8, [posYZorro]
    mov r9, "X"

    dec rcx
    dec r8

    cmp rax,0
    je realizarMovimientoArribaIzquierda

    inc byte[ocasMatadas]
    dec rcx
    dec r8

realizarMovimientoArribaIzquierda:

    mov [posXZorro], rcx
    mov [posYZorro], r8

    sub rsp,8
    call moverElemento
    add rsp,8

    jmp terminarMovimiento
moverseArribaDerecha:
    mov rdi, [posXZorro]
    mov rsi, [posYZorro]
    dec rsi
    inc rdi

    sub rsp,8
    call validarLimites
    add rsp,8

    cmp rax, 0
    jne movimientoInvalido

    sub rdi, rdi
    sub rsi,rsi

    lea rdi, matriz
    mov rsi, [posXZorro]
    mov rdx, [posYZorro]
    mov rcx, [posXZorro]
    mov r8, [posYZorro]

    inc rsi
    dec rdx

    inc rcx
    inc rcx
    dec r8
    dec r8

    sub rsp, 8
    call moverSobreOca
    add rsp, 8

    cmp rax,0
    jl movimientoInvalidoKill

    sub rdi, rdi
    sub rsi,rsi

    lea rdi, matriz
    mov rsi, [posXZorro]
    mov rdx, [posYZorro]
    mov rcx, [posXZorro]
    mov r8, [posYZorro]
    mov r9, "X"

    inc rcx
    dec r8

    cmp rax,0
    je realizarMovimientoArribaDerecha

    inc byte[ocasMatadas]
    inc rcx
    dec r8

realizarMovimientoArribaDerecha:

    mov [posXZorro], rcx
    mov [posYZorro], r8

    sub rsp,8
    call moverElemento
    add rsp,8

    jmp terminarMovimiento
moverseAbajoIzquierda:
    mov rdi, [posXZorro]
    mov rsi, [posYZorro]
    inc rdi
    dec rsi

    sub rsp,8
    call validarLimites
    add rsp,8

    cmp rax, 0
    jne movimientoInvalido

    sub rdi, rdi
    sub rsi,rsi

    lea rdi, matriz
    mov rsi, [posXZorro]
    mov rdx, [posYZorro]
    mov rcx, [posXZorro]
    mov r8, [posYZorro]

    dec rsi
    inc rdx

    dec rcx
    dec rcx
    inc r8
    inc r8

    sub rsp, 8
    call moverSobreOca
    add rsp, 8

    cmp rax,0
    jl movimientoInvalidoKill

    sub rdi, rdi
    sub rsi,rsi

    lea rdi, matriz
    mov rsi, [posXZorro]
    mov rdx, [posYZorro]
    mov rcx, [posXZorro]
    mov r8, [posYZorro]
    mov r9, "X"

    dec rcx
    inc r8

    cmp rax,0
    je realizarMovimientoAbajoIzquierda

    inc byte[ocasMatadas]
    dec rcx
    inc r8

realizarMovimientoAbajoIzquierda:

    mov [posXZorro], rcx
    mov [posYZorro], r8

    sub rsp,8
    call moverElemento
    add rsp,8

    jmp terminarMovimiento

moverseAbajoDerecha:
    mov rdi, [posXZorro]
    mov rsi, [posYZorro]
    inc rdi
    inc rsi

    sub rsp,8
    call validarLimites
    add rsp,8

    cmp rax, 0
    jne movimientoInvalido

    sub rdi, rdi
    sub rsi,rsi

    lea rdi, matriz
    mov rsi, [posXZorro]
    mov rdx, [posYZorro]
    mov rcx, [posXZorro]
    mov r8, [posYZorro]

    inc rsi
    inc rdx

    inc rcx
    inc rcx
    inc r8
    inc r8

    sub rsp, 8
    call moverSobreOca
    add rsp, 8

    cmp rax,0
    jl movimientoInvalidoKill

    sub rdi, rdi
    sub rsi,rsi

    lea rdi, matriz
    mov rsi, [posXZorro]
    mov rdx, [posYZorro]
    mov rcx, [posXZorro]
    mov r8, [posYZorro]
    mov r9, "X"

    inc rcx
    inc r8

    cmp rax,0
    je realizarMovimientoAbajoDerecha

    inc byte[ocasMatadas]
    inc rcx
    inc r8

realizarMovimientoAbajoDerecha:

    mov [posXZorro], rcx
    mov [posYZorro], r8

    sub rsp,8
    call moverElemento
    add rsp,8

    jmp terminarMovimiento
preguntarMovimientoOca:
    mov rdi, msgSeleccion
    sub rsp,8
    call printf
    add rsp,8

    mov rdi, movimientoTecla
    sub rsp,8
    call gets
    add rsp,8
validarTeclaOca:
    sub rdi,rdi
    mov rdi, movimientoTecla
    sub rsp,8
    call strLen
    add rsp,8

    cmp rax, 1
    jne teclaInvalidaOca

    jmp moverseOca
teclaInvalidaOca:
    mov rdi,msgErrorTecla
    sub rsp,8
    call printf
    add rsp,8
    jmp preguntarMovimientoOca
moverseOca:
    cmp byte [movimientoTecla], 'W'
    je moverseArribaOca

    cmp byte[movimientoTecla], 'w'
    je moverseArribaOca

    cmp byte [movimientoTecla], 'S'
    je moverseAbajoOca

    cmp byte [movimientoTecla], 's'
    je moverseAbajoOca

    cmp byte [movimientoTecla], 'A'
    je moverseIzquierdaOca

    cmp byte[movimientoTecla], 'a'
    je moverseIzquierdaOca

    cmp byte [movimientoTecla], 'D'
    je moverseDerechaOca

    cmp byte[movimientoTecla], 'd'
    je moverseDerechaOca

    cmp byte [movimientoTecla], 'X'
    je salirTecla

    cmp byte[movimientoTecla], 'x'
    je salirTecla

    mov rdi,msgErrorTecla
    sub rsp,8
    call printf
    add rsp,8

    jmp preguntarMovimientoOca

    ret
movimientoInvalidoOca:
    mov rdi,msgErrorPosicion
    sub rsp,8
    call printf
    add rsp,8
    jmp preguntarMovimientoOca
movimientoInvalidoOcaOcupado:
    mov rdi,msgErrorMovOca
    sub rsp,8
    call printf
    add rsp,8
    jmp preguntarMovimientoOca
moverseArribaOca:
    mov rdi, [posXOca]
    mov rsi, [posYOca]
    dec rsi

    sub rsp,8
    call validarLimites
    add rsp,8

    cmp rax, 0
    jne movimientoInvalidoOca

    lea rdi, matriz
    mov rsi, [posXOca]
    mov rdx, [posYOca]

    dec rdx
    sub rsp, 8
    call obtenerElemento
    add rsp, 8

    cmp al, " "
    jne movimientoInvalidoOcaOcupado

    sub rdi, rdi
    sub rsi,rsi

    lea rdi, matriz
    mov rsi, [posXOca]
    mov rdx, [posYOca]
    mov rcx, [posXOca]
    mov r8, [posYOca]
    mov r9, "O"

    dec r8

    sub rsp, 8
    call moverElemento
    add rsp, 8

    jmp terminarMovimiento
moverseAbajoOca:
    mov rdi, [posXOca]
    mov rsi, [posYOca]
    inc rsi

    sub rsp,8
    call validarLimites
    add rsp,8

    cmp rax, 0
    jne movimientoInvalidoOca

    lea rdi, matriz
    mov rsi, [posXOca]
    mov rdx, [posYOca]

    inc rdx
    sub rsp, 8
    call obtenerElemento
    add rsp, 8

    cmp al, " "
    jne movimientoInvalidoOcaOcupado

    sub rdi, rdi
    sub rsi,rsi

    lea rdi, matriz
    mov rsi, [posXOca]
    mov rdx, [posYOca]
    mov rcx, [posXOca]
    mov r8, [posYOca]
    mov r9, "O"

    inc r8

    sub rsp, 8
    call moverElemento
    add rsp, 8

    jmp terminarMovimiento
moverseIzquierdaOca:
    mov rdi, [posXOca]
    mov rsi, [posYOca]
    dec rdi

    sub rsp,8
    call validarLimites
    add rsp,8

    cmp rax, 0
    jne movimientoInvalidoOca

    lea rdi, matriz
    mov rsi, [posXOca]
    mov rdx, [posYOca]

    dec rsi
    sub rsp, 8
    call obtenerElemento
    add rsp, 8

    cmp al, " "
    jne movimientoInvalidoOcaOcupado

    sub rdi, rdi
    sub rsi,rsi

    lea rdi, matriz
    mov rsi, [posXOca]
    mov rdx, [posYOca]
    mov rcx, [posXOca]
    mov r8, [posYOca]
    mov r9, "O"

    dec rcx

    sub rsp, 8
    call moverElemento
    add rsp, 8

    jmp terminarMovimiento
moverseDerechaOca:
    mov rdi, [posXOca]
    mov rsi, [posYOca]
    inc rdi

    sub rsp,8
    call validarLimites
    add rsp,8

    cmp rax, 0
    jne movimientoInvalidoOca

    lea rdi, matriz
    mov rsi, [posXOca]
    mov rdx, [posYOca]

    inc rsi
    sub rsp, 8
    call obtenerElemento
    add rsp, 8

    cmp al, " "
    jne movimientoInvalidoOcaOcupado

    sub rdi, rdi
    sub rsi,rsi

    lea rdi, matriz
    mov rsi, [posXOca]
    mov rdx, [posYOca]
    mov rcx, [posXOca]
    mov r8, [posYOca]
    mov r9, "O"

    inc rcx

    sub rsp, 8
    call moverElemento
    add rsp, 8

    jmp terminarMovimiento