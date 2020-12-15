%include "src/Macro/macro.inc"
%include "src/String/string.inc"
%include "src/IO/io.inc"
%include "src/Args/args.inc"
%include "src/Calc/calc.inc"

section .bss
    argc resb 8
    argIndex resb 8

section .text
    global _start

_start:
    mov rax, 0
    mov [argIndex], rax

    pop rax     ; recover argc
    dec rax     ; the first arg is the command itself so we pop it and won't count it
    mov [argc], rax

    cmp rax, 0  ; check if there are args
    je .agrc_zero

    pop rax     ; pop the first arg (the command itself)

.argv_loop:
    mov rax, [argIndex]
    inc rax
    mov [argIndex], rax
    pop rax                 ; pop the arg out of the stack
    call _ProcessArgs
    mov rax, [argIndex]
    mov rbx, [argc]
    cmp rax, rbx
    jne .argv_loop

    jmp .argc_both
.agrc_zero:
    call _ShowDefaultMode
.argc_both:
    call _CalcUserIn
    exit