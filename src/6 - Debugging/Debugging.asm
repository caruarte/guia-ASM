extern strcpy
extern malloc
extern free

section .rodata
; Acá se pueden poner todas las máscaras y datos que necesiten para el ejercicio

section .text
; Marca un ejercicio como aún no completado (esto hace que no corran sus tests)
FALSE EQU 0
; Marca un ejercicio como hecho
TRUE  EQU 1

ITEM_OFFSET_NOMBRE EQU 0
ITEM_OFFSET_ID EQU 12
ITEM_OFFSET_CANTIDAD EQU 16

POINTER_SIZE EQU 8
UINT32_SIZE EQU 4

; Marcar el ejercicio como hecho (`true`) o pendiente (`false`).

global EJERCICIO_1_HECHO
EJERCICIO_1_HECHO: db TRUE ; Cambiar por `TRUE` para correr los tests.

global EJERCICIO_2_HECHO
EJERCICIO_2_HECHO: db TRUE ; Cambiar por `TRUE` para correr los tests.

global EJERCICIO_3_HECHO
EJERCICIO_3_HECHO: db TRUE ; Cambiar por `TRUE` para correr los tests.

global EJERCICIO_4_HECHO
EJERCICIO_4_HECHO: db TRUE ; Cambiar por `TRUE` para correr los tests.

global ejercicio1
ejercicio1:
	add rdi, rsi
	add rdi, rdx
    add rdi, rcx
    add rdi, r8
	mov rax, rdi
	ret

global ejercicio2
ejercicio2:
	mov DWORD[rdi+ITEM_OFFSET_ID], esi
	mov DWORD [rdi+ITEM_OFFSET_CANTIDAD], edx
	mov rsi, rcx
	call strcpy 
	ret


global ejercicio3
ejercicio3:
	push rbp
	mov rbp, rsp
	push r12
	push r13
	push r14
	push r15 ; acumulador
	xor r15, r15
	mov r12, rdi ; arr
	mov r13D, esi ; n
	mov r14, rdx ; fun

	cmp rsi, 0
	je .vacio
	cmp rsi, 1
	je .base

	dec esi
	call ejercicio3
	add r15D, eax
	mov edi, eax
	mov r8D, r13D
	dec r8
	mov esi, [r12 + r8*4]
	call r14
	add r15D, eax
	mov eax, r15d
	jmp .end

	.base:
	mov edi, 0
	mov esi, [r12]
	call r14
	jmp .end
	.vacio:
	mov eax, 64

	.end:
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbp
	ret

global ejercicio4
ejercicio4:
	push rbp
	mov rbp, rsp
	push r12
	push r13
	push r14
	push r15
	push rbx
	sub rsp, 8
	mov r12, rdi ; array
	mov r13d, esi ; size
	mov r14d, edx ; constante

	mov rdi, UINT32_SIZE
	imul rdi, r13 ; se guarda en eax, sino usar imul

	call malloc

	mov r15, rax ; res_arr
	
	xor rbx, rbx ; indice
	.loop:
	
	cmp ebx, r13d
	je .end

	mov r8, [r12+rbx*POINTER_SIZE]
	mov r9d, [r8]
	mov eax, r14d ; contante
	imul eax, r9d ; constante * numero
	mov DWORD [r15+rbx*UINT32_SIZE], eax
	
	mov rdi, r8 
	call free
	mov QWORD [r12+rbx*POINTER_SIZE], 0

	inc ebx
	jmp .loop

	.end:
	mov rax, r15
	add rsp, 8
	pop rbx
	pop r15
	pop r14
	pop r13
	pop r12
	pop rbp
	ret
