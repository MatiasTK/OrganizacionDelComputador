; Ingresar por teclado un texto y luego un caracter e imprimir por pantalla:
; - El texto de forma invertida
; - La cantidad de apariciones del caracter en el texto
; - El porcentaje de esas apariciones respecto de la longitud total del texto

%macro mPuts 0
   sub rsp,8
   call puts
   add rsp,8
%endMacro

%macro mGets 0
    sub rsp,8
    call gets
    add rsp,8
%endMacro

%macro mPrintf 0
    sub rsp,8
    call printf
    add rsp,8
%endMacro

global main
extern puts
extern gets; Funcion insegura, hay que tener cuidado con el buffer overflow.
extern printf

section .data
    msgInText db "Ingrese un texto por teclado (Maximo 99 caracteres): ",0
    msgInChar db "ingrese un caracter: ",0
    textLength dq 0; Quad word
    counterChar dq 0
    msgReversedText db "Texto invertido %s",10,0; El 10 es el salto de linea.

section .bss
    text resb 500
    char resb 50
    reversedText resb 500

section .text
main:
    mov rdi, msgInText
    mPuts

    mov rdi, text
    mGets

    mov rdi, msgInChar
    mPuts

    mov rdi, char
    mGets

    ; Voy a invertir el texto
    mov rsi,0; Puntero hacia caracteres
nextCharFindLast:
    cmp byte[text + rsi], 0; Es el fin de string?
    je  endString
    inc rsi; Incremento el puntero
    jmp nextCharFindLast; Bifurcacion incondicional
endString:
    mov rdi,0; Inicializo el puntero para que apunte al primer caracter de reversedText
    mov [textLength], rsi; Guardo la longitud del texto
charCopy:
    cmp rsi,0; Si llegue al inicio del texto termine
    je endCopy
    ; Para hacer una copia necesito un registro como pivote
    mov al, [text + rsi - 1]; al: 8 bits
    mov [reversedText + rdi], al; Copio el char a la siguiente pos de reservedText
    ;Me fijo si lo que esta en al es el char a contar
    cmp al, [char]
    jne movePointers
    add qword[counterChar],1
movePointers:
    inc rdi
    dec rsi
    jmp charCopy
endCopy:
    mov byte[reversedText + rdi], 0; Agrego el caracter nulo al final del string
    ;Imprimo texto invertido
    mov rdi, msgReversedText
    mov rsi, reversedText
    mPrintf
    ret