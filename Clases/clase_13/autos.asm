;Se cuenta con un archivo listado.dat en formato binario con informacion de autos. Cada registro tiene los campos:
;- Marca: 20 caracteres ascii
;- Modelo: 20 caracteres ascii
;- Año: 2 bytes bpf s/s
;Se pide realizar un programa que pida ingresar por teclado una marca de automovil e imprima por pantalla todos los autos de dicha marca que se encuentran en el archivo.
;Las marcas validas son Fiat, Ford, Chevrolet y Peugeot y se debera validar que la marca ingresada sea alguna de ellas previo a la busqueda en el archivo.

%macro mGets 1
    mov rdi, %1
    sub rsp,8
    call gets
    add rsp,8
%endMacro

%macro mPuts 1
    mov rdi,%1
    sub rsp,8
    call puts
    add rsp,8
%endMacro

global main
extern gets
extern puts
extern strlen

section .data
    msgInAuto db "Ingrese la marca de auto: ",0
    arrMarcas db "Fiat      Ford    Chevrolet Peugeot  "
    marca10Chars times 10 db ""

section .bss
    inMarca resb 100; No le pongo 20 para evitar conflictos.

section .text
main:
    mPuts msgInAuto
    mGets inMarca

    mov rdi, inMarca
    sub rsp, 8
    call strlen
    add rsp,8

    ret