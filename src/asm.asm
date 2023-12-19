;------;
; NASM ;
;------;

; macros
%define sys_write       1
%define stdout          1

DEFAULT REL
section .data
message: db "asm_function: got "
integer: db "?"
newline: db 0x0a, 0x00
message_len equ $-message-1

section .text
global asm_function:function

asm_function:

    push rax
    push rdx
    push rsi
    push rdi
    push rbx

    ; input is received in register rdi
    ; 1. move it to rbx
    ; 2. add 0x30 to rbx as a hacky version of atoi
    ; 3. use repne scasb to scan string in rdi for char in rax
    ; 4. repne scasb seems to overshoot by one, so subtract one from
    ;    rdi to overwrite the '?' in message with the value we received
    ;    from the c code that called us.
    mov rbx, rdi
    add rbx, 0x30
    mov rcx, message_len
    lea rdi, [message]
    mov rax, '?'
    repne scasb
    mov byte [rdi-1], bl

    ; 5. use the sys_write syscall to print the message to the screen
    mov     rdx, message_len    ; write string length
    lea     rsi, [message]      ; where to start writing
    mov     rdi, stdout         ; file descriptor
    mov     rax, sys_write      ; sys_write kernel opcode in x86_64
    syscall

    pop rbx
    pop rdi
    pop rsi
    pop rdx
    pop rax

    ; multiply input by 2
    imul rdi, 2
    mov rax, rdi

    ; c calling convention returns values in the rax register
    ret

