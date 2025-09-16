extern malloc

section .rodata
; Acá se pueden poner todas las máscaras y datos que necesiten para el ejercicio

section .text
; Marca un ejercicio como aún no completado (esto hace que no corran sus tests)
FALSE EQU 0
; Marca un ejercicio como hecho
TRUE  EQU 1

; Marca el ejercicio 1A como hecho (`true`) o pendiente (`false`).
;
; Funciones a implementar:
;   - optimizar
global EJERCICIO_2A_HECHO
EJERCICIO_2A_HECHO: db TRUE ; Cambiar por `TRUE` para correr los tests.

; Marca el ejercicio 1B como hecho (`true`) o pendiente (`false`).
;
; Funciones a implementar:
;   - contarCombustibleAsignado
global EJERCICIO_2B_HECHO
EJERCICIO_2B_HECHO: db FALSE ; Cambiar por `TRUE` para correr los tests.

; Marca el ejercicio 1C como hecho (`true`) o pendiente (`false`).
;
; Funciones a implementar:
;   - modificarUnidad
global EJERCICIO_2C_HECHO
EJERCICIO_2C_HECHO: db FALSE ; Cambiar por `TRUE` para correr los tests.

;########### ESTOS SON LOS OFFSETS Y TAMAÑO DE LOS STRUCTS
; Completar las definiciones (serán revisadas por ABI enforcer):
ATTACKUNIT_CLASE EQU 0
ATTACKUNIT_COMBUSTIBLE EQU 12
ATTACKUNIT_REFERENCES EQU 14
ATTACKUNIT_SIZE EQU 16

global optimizar
optimizar:
	; Te recomendamos llenar una tablita acá con cada parámetro y su
	; ubicación según la convención de llamada. Prestá atención a qué
	; valores son de 64 bits y qué valores son de 32 bits o 8 bits.
	;
	; rdi = mapa_t           mapa
	; rsi = attackunit_t*    compartida
	; rdx = uint32_t*        fun_hash(attackunit_t*)
	push rbp
	mov rbp, rsp
	push r12
	push r13
	push r14
	push r15
	push rbx ; DESALINEADA
	sub rsp, 8 ; alineada
	
	mov r12, rdi ; mapa
	mov r13, rsi ; compartida
	mov r14, rdx ; fun_hash

	mov rdi, r13
	call r13 
	mov r15d, eax  ; hash esta en r15d

	xor rbx, rbx ; i
	xor r8, r8 ; j , lo voy a guardar antes de llamar a la otra funcion

	.ciclo:
		cmp rbx, 255
		je .fin

		.ciclo2:
			cmp r8, 255
			je .fin2

			xor r10, r10
			add r10, rbx
			imul r10, 255 ; i * 255
			add r10, r8 ; r9 = (rbx*255 + r8)
			;cmp [r12 + (rbx*255 + r8) * 8], 0 ; MAL, NO SE PUEDEN PONER TANTOS REGISTROS
			cmp QWORD [r12 + r10 * 8], 0 
			je .next
			
			mov rdi, [r12 + r10 * 8]
			push r8 ;desalineada
			push r10 ; alineada
			call r14 ; llamo a fun_hash, guardo r8
			pop r10
			pop r8
			cmp eax, r15d
			jne .next

			mov r9, [r12 + r10 * 8] ; en r9 esta el puntero
			sub BYTE [r9 + ATTACKUNIT_REFERENCES], 1
			mov [r12 + r10 * 8], r13 ;   mapa[i][j] = compartida;
			add BYTE [r13 + ATTACKUNIT_REFERENCES], 1

			.next:
			inc r8
			jmp .ciclo2
		.fin2:
		inc rbx
		jmp .ciclo
	.fin:
	add rsp, 8
	pop rbx
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbp
	ret

global contarCombustibleAsignado
contarCombustibleAsignado:
	; r/m64 = mapa_t           mapa
	; r/m64 = uint16_t*        fun_combustible(char*)
	ret

global modificarUnidad
modificarUnidad:
	; r/m64 = mapa_t           mapa
	; r/m8  = uint8_t          x
	; r/m8  = uint8_t          y
	; r/m64 = void*            fun_modificar(attackunit_t*)
	ret
