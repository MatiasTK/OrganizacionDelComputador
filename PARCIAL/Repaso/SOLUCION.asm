global main
extern fopen
extern fclose
extern fread
extern printf
extern gets
extern sscanf


section .data

	matriz times 144 dd 0                            ; Matriz de 12x12 = 144 departamentos. Binario de 4 bytes = double

	msjPrintfListado dw "Listado de pisos donde el departamento tiene un valor menor al ingresado",10,0

	msjMostrarPiso dw "Piso: %i"

	msjIngresoPrecio dw "Por favor ingrese un valor que represente el precio", 0

	msjIngresoDepto  dw "Por favor ingrese un valor que represente un departamento", 0

	msjErrorArchivo dw "Hubo un error", 0

	nombreArchivo db "PRECIOS.DAT",0
	mode db "rb",0


	registro times 0 db ""
		piso dw ""
		dpto db 0
		precio dd 0

	esValid db ""

	formatConversion dw "%i"

	elemento dd 0

	fileHandle dq 0

	pisoInicial dd 1

section .bss

	pisoIng    resd 1

	buffer    resb 10

	dptoIng   resb 4

	precioIng resq 1

section .text

main:

	call abrirArch
	cmp qword[fileHandle], 0
	jle error

	call leerArch

	call ingresoUsuario



endProg:

	ret



abrirArch:


	mov rdi, nombreArchivo                  ; Parametro 1: Nombre del archivo a abrir
	mov rsi, mode                           ; Parametro 2: Modo de apertura
	sub rsp, 8                              ; resto 8 al rsp dado que estoy trabajando en linux
	call fopen                              ; Llamado a la funcion de C fopen
	add rsp, 8

	mov qword[fileHandle], rax

	ret


error:

	mov rax, 0
	mov rdi, msjErrorArchivo				; Parametro 1: Mensaje a imprimir
	call printf                             ; Llamado a la funcion de C printf

	jmp endProg




leerArch:


leerRegistro:

	mov rdi, registro                     ; Parametro 1: Donde voy a copiar los datos
	mov rsi, 7                            ; Parametro 2: Longitud del registro. word = 2 bytes + byte = 1 byte + double = 4 bytes = 7
	mov rdx, 1                            ; Parametro 3: Cantidad de registros a leerArch
	mov rcx, qword[fileHandle]            ; Parametro 4: Handle del archivo
	sub rsp, 8
	call fread                            ; Llamado a la funcion de C fread
	add rsp, 8

	cmp rax, 0
	jle eof

	call VALREG

	cmp byte[esValid], "N"
	je leerRegistro

	call actualizarMatriz				; Actualizo la matriz con los datos obtenidos

	jmp leerRegistro


eof:

	mov rdi, qword[fileHandle]         ; Parametro 1: FileHandle del archivo a cerrar
	sub rsp, 8
	call fclose
	add rsp, 8

	ret


VALREG:


	mov rdi, piso                       ; Parametro 1: Donde estan los datos a convertir
	mov rsi, formatConversion           ; Parametro 2: El formato de la conversion
	mov rdx, pisoIng					; Parametro 3: Donde guardo los datos convertidos
	sub rsp, 8
	call sscanf                         ; Llamado a la funcion de C sscanf
	add rsp, 8

	cmp rax, 1
	jl error

	cmp dword[pisoIng], 1
	jl  registroInvalido

	cmp dword[pisoIng], 12
	jg  registroInvalido
										; Tanto el piso como el departamento tienen que ser valores entre 1 y 12.

	cmp byte[dpto], 1
	jl registroInvalido

	cmp byte[dpto], 12
	jg registroInvalido


	cmp dword[precio], 0
	jg registroInvalido


										;Si paso todas las validaciones, tengo un registro valido

	mov byte[esValid], "S"
	jmp finVALREG

registroInvalido:

	mov byte[esValid], "N"
	jmp finVALREG


finVALREG:

	ret


actualizarMatriz:

	mov rax, dword[pisoIng]
	dec rax                           ; RAX = FILA - 1

	imul rax, 4                       ; Multiplico por la longitud del elemento
	imul rax, 12                      ; Multiplico por la cantidad de columnas

	mov ebx, rax                      ; rbx = desplazamiento de FILA

	mov rax, dword[dpto]
	dec rax                           ; RAX = COLUMNA - 1

	imul rax, 4                       ; Multiplico por la longitud del elemento

	add ebx, rax                      ; rbx = desplazamiento total

	mov rax, dword[precio]			  ; Almaceno el precio (double 4 bytes x 8 bits = 32 bits) en el eax
	mov dword[matriz + ebx], rax      ; Guardo en la matriz el precio


	ret                               ; Termine de actualizar el precio del dpto indicado en el piso indicado



ingresoUsuario:


	mov rdi, msjIngresoDepto         ; Parametro 1: Mensaje a imprimir
	sub rsp, 8
	call printf
	add rsp, 8

	mov rdi, buffer					; Parametro 1: Donde voy a guardar lo ingresado
	sub rsp, 8
	call gets
	add rsp, 8

	mov rdi, buffer					; Parametro 1: De donde voy a leer los datos. Cuando pedi un ingreso por pantalla lo guarda como un string tengo que convertirlo a un numero
	mov rsi, formatConversion		; Parametro 2: Formato de conversion
	mov rdx, dptoIng				; Parametro 3: Donde voy a almacenar el dato convertido
	sub rsp, 8
	call sscanf
	add rsp, 8


	mov rdi, msjIngresoPrecio       ; Parametro 1: Mensaje a imprimir
	sub rsp, 8
	call printf
	add rsp, 8

	mov rdi, buffer					; Parametro 1: Donde voy a guardar lo ingresado
	sub rsp, 8
	call gets
	add rsp, 8

	mov rdi, buffer                ; Parametro 1: De donde voy a leer los datos
	mov rsi, formatConversion      ; Parametro 2: Formato de conversion
	mov rdx, precioIng             ; Parametro 3: Donde voy a almacenar el resultado
	sub rsp, 8
	call sscanf
	add rsp, 8


mostrarPisos:

	mov rax, 0
	mov rdi, msjPrintfListado     ; Parametro 1: Mensaje a imprimir
	sub rsp, 8
	call printf
	add rsp, 8

	mov dword[pisoInicial], 1

recorrerPisos:

	cmp dword[pisoInicial], 12
	jg  finMostrar

	mov rax, dword[pisoInicial]	; EAX = PISO = FILA
	dec rax                     ; = EAX = PISO - 1

	imul rax, 4                 ; Multiplico por la longitud del elemento
	imul rax, 12                ; Multiplico por la cantidad de columnas

	mov ebx, rax                ; ebx = desplazamiento fila

	mov rax, dword[dptoIng]     ; EAX = DPTO = COL
	dec rax                     ; EAX = COL - 1

	imul rax, 4                 ; Multiplico por la longitud del elemento

	add ebx, rax                ; EBX = DESPLAZAMIENTO TOTAL

	mov rax, dword[matriz + ebx] ; muevo el precio del dpto al eax
	cdqe                         ; Lo paso a 64 bits = rax

	cmp qword[precioIng], rax
	jg incrementarPiso


	mov rdi, msjMostrarPiso     ; Parametro 1: Mensaje a imprimir
	mov rsi, [pisoInicial]      ; Parametro 2: Piso a mostrar
	sub rsp, 8
	call printf
	add rsp, 8


incrementarPiso:

	inc dword[pisoInicial]
	jmp recorrerPisos


finMostrar:

	ret
