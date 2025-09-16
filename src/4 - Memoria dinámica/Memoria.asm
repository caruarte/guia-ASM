extern malloc
extern free
extern fprintf

section .data
null_str db "NULL", 0
fmt_str  db "%s", 0

section .text

global strCmp
global strClone
global strDelete
global strPrint
global strLen

; ** String **

; int32_t strCmp(char* a, char* b) rdi rsi
strCmp:
	xor eax, eax
	.ciclo:
		movzx r10d, byte [rdi] 
    	movzx r11d, byte [rsi]
		cmp r10d, r11d
		ja .mayor ; saltos unsigned
		jb .menor
		cmp r10b, 0
		je .fin
		inc rdi
		inc rsi
		jmp .ciclo
	.mayor:
		dec eax
		jmp .fin
	.menor:
		inc eax
		jmp .fin
	.fin:
	ret

; char* strClone(char* a)
strClone:
	push rbp ;alineada
	mov rbp, rsp
	push r12 ;desalineada
	push r13 ;alineada
	mov r12, rdi
	call strLen
	mov rdi, rax
	inc rdi ; le sumo uno para contar el \0
	call malloc
	mov r13, rax
	.ciclo:
		mov r10b, [r12]
		mov [rax], r10b
		cmp r10b, 0
		je .fin
		inc r12
		inc rax
		jmp .ciclo
	.fin:
	mov rax, r13
	pop r13
	pop r12
	pop rbp
	ret

; void strDelete(char* a)
strDelete:
	call free
	ret

; void strPrint(char* a, FILE* pFile)
strPrint:
    ; rdi = char* a
    ; rsi = FILE* pFile

    mov al, [rdi]        ; cargamos primer byte de a
    cmp al, 0
    jne .write_string    ; si no es '\0', vamos a escribir la cadena

    ; a es vacío → escribir "NULL"
    mov rdi, rsi         ; 1er argumento: FILE* pFile
    lea rsi, [rel null_str] ; 2do argumento: puntero a "NULL"
    call fprintf
    ret

.write_string:
    mov rdi, rsi         ; 1er argumento: FILE* pFile
    lea rsi, [rel fmt_str] ; 2do argumento: formato "%s"
    mov rdx, rdi          ; 3er argumento: la cadena a imprimir
    call fprintf
    ret

; uint32_t strLen(char* a)
strLen:
	mov eax, 0
	ciclo:
	cmp byte [rdi], 0
	je .fin
	inc eax
	inc rdi
	jmp ciclo
	.fin:
	ret


