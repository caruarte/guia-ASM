extern malloc
extern free

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
EJERCICIO_2B_HECHO: db TRUE ; Cambiar por `TRUE` para correr los tests.

; Marca el ejercicio 1C como hecho (`true`) o pendiente (`false`).
;
; Funciones a implementar:
;   - modificarUnidad
global EJERCICIO_2C_HECHO
EJERCICIO_2C_HECHO: db TRUE ; Cambiar por `TRUE` para correr los tests.

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
	push rbp ; rbp - 0
	mov rbp, rsp
	push r12 ;rbp - 8 mapa
	push r13 ; rbp - 16 compartida
	push r14 ; rbp - 24 fun_hash
	push r15 ; rbp - 32 hash
	push rbx ; rbp - 40 DESALINEADA - i
	sub rsp, 8 ; alineada
	
	mov r12, rdi ; mapa
	mov r13, rsi ; compartida
	mov r14, rdx ; fun_hash

	mov rdi, r13
	call r14 
	mov r15d, eax  ; hash esta en r15d

	xor rbx, rbx ; indice i
	mov QWORD [rbp - 48], 0 ;indice j


	.ciclo:
		cmp rbx, 255
		je .fin
		mov QWORD [rbp - 48], 0 ; j , lo voy a guardar antes de llamar a la otra funcion ; aca tiene que ir la j
		.ciclo2:
			cmp QWORD [rbp - 48], 255
			je .fin2

			xor r10, r10
			add r10, rbx
			imul r10, 255 ; i * 255
			add r10, [rbp - 48] ; r10 = (i*255 + j)
			mov r9, [r12 + r10 * 8] ; r9 tiene el puntero
			cmp r9, 0 ; VEO SI ES NULL
			je .next

			cmp r13, r9 ; comparo compartida con ptr
			je .next

			mov rdi, r9
			push r10
			push r9
			call r14 ; llamo a fun_hash
			pop r9
			pop r10

			mov r11d, eax ;; LIMPIO LOS BITS ALTOS

			cmp r11, r15 ; comparo fun_hash(ptr) con el hash
			jne .next


			sub BYTE [r9 + ATTACKUNIT_REFERENCES], 1

			movzx r11d, BYTE [r9 + ATTACKUNIT_REFERENCES]

			cmp r11, 0 ; si las references == 0
			jne .refMayorACero
			mov rdi, r9
			push r10
			push r9
			call free
			pop r9
			pop r10

			.refMayorACero:
			mov [r12 + r10 * 8], r13 ;   mapa[i][j] = compartida;
			add BYTE [r13 + ATTACKUNIT_REFERENCES], 1

			.next:
			inc QWORD [rbp - 48]
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
	; rdi = mapa_t           mapa
	; rsi = uint16_t*        fun_combustible(char*)
	push rbp
	mov rbp, rsp
	push r12 ; mapa
	push r13 ; fun_combustible
	push r14 ; rbp - 24  res
	sub rsp, 24

	mov r12, rdi
	mov r13, rsi
	mov r14, 0
	mov QWORD [rbp - 32], 0 ; indice i
	mov QWORD [rbp - 40], 0 ; indice j

	.ciclo:
		cmp QWORD [rbp - 32], 255
		je .fin
		mov QWORD [rbp - 40], 0 
		.ciclo2:
			cmp QWORD [rbp - 40], 255
			je .fin2

			mov r10, QWORD [rbp - 32] ; r10 = i
			imul r10, 255 ; r10 = i*255
			add r10, QWORD [rbp - 40] ; r10 = i*255 + j
			mov r9, [r12 + r10*8] ; r9 tiene mapa[i][j]
			cmp r9, 0
			je .next

			; mov rdi, [r9 + ATTACKUNIT_CLASE] ; NOOOO, r9 es un puntero ya
			mov rdi, r9 + ATTACKUNIT_CLASE

			push r9
			sub rsp, 8
			call r13 ; llamo a fun_combustible
			add rsp, 8
			pop r9
			movzx r10d, ax

			movzx r11d, WORD [r9 + ATTACKUNIT_COMBUSTIBLE]
			add r14, r11
			sub r14, r10
			
			.next:
			inc QWORD [rbp - 40]
			jmp .ciclo2
		.fin2:
		inc QWORD [rbp - 32]
		jmp .ciclo
	.fin:

	mov rax, r14
	add rsp, 24
	pop r14
	pop r13
	pop r12
	pop rbp
	ret

global modificarUnidad
modificarUnidad:
	; rdi = mapa_t           mapa
	; sil  = uint8_t          x
	; dl  = uint8_t          y
	; rcx = void*            fun_modificar(attackunit_t*)

	push rbp
	mov rbp, rsp
	push r12 ; mapa
	push r13 ; x
	push r14 ; y
	push r15 ; fun_modificar
	push rbx ; mapa[x][y]
	sub rsp, 8

	mov r12, rdi
	movzx r13d, sil
	movzx r14d, dl
	mov r15, rcx

	mov r8, r13 ; r8 = x
	imul r8, 255 ; r8 = x*255
	add r8, r14 ; r8 = x*255 + y
	mov rbx, [r12 + r8 * 8] ; rbx = mapa[x][y]
	cmp rbx, 0
	je .fin

	movzx r9D, BYTE [rbx + ATTACKUNIT_REFERENCES] 
	cmp r9, 1 ; mapa[x][y] -> references > 1
	jle .modificar

	dec r9
	mov BYTE [rbx + ATTACKUNIT_REFERENCES], r9b ; mapa[x][y]->references -= 1;

	mov rdi, ATTACKUNIT_SIZE
	call malloc ; nuevaUnidad esta en rax

	mov r9, [rbx + ATTACKUNIT_CLASE] ; copio los 8 bytes mas altos 
	mov [rax + ATTACKUNIT_CLASE], r9
	mov r9d, [rbx + ATTACKUNIT_CLASE + 8] ; copio los 3 bytes mas bajos mas uno de padding (despues se rellenara)
	mov [rax + ATTACKUNIT_CLASE + 8], r9d


	movzx r9D, WORD [rbx + ATTACKUNIT_COMBUSTIBLE] 
	mov WORD [rax + ATTACKUNIT_COMBUSTIBLE], R9w

	mov BYTE [rax + ATTACKUNIT_REFERENCES], 1

	mov r8, r13 ; r8 = x
	imul r8, 255 ; r8 = x*255
	add r8, r14 ; r8 = x*255 + y
	mov [r12 + r8 * 8], rax
	mov rbx, rax

	.modificar:
	mov rdi, rbx
	call r15 ; fun_modificar(mapa[x][y]);

	.fin:
	add rsp, 8
	pop rbx
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbp
	ret
