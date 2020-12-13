%include "src/IO/io.inc"
%include "src/String/string.inc"
%include "src/Args/args.inc"
%include "src/Macro/macro.inc"

section .data
    text db "Enter a number: ",10,0     ; text = label
                                        ; db = data byte
                                        ; "..." = content as a string
                                        ; 10 = return to line
                                        ; 0 = 0 ended string
    text2 db "Enter the second number: ",10,0
    text3 db "You operation is equal to: ",0
    text4 db "You utter moron! you manage to have a wrong mode!",10,0
    decimal db ".",0
    minus db "-",0

section .text
    global _CalculatorMain

_CalculatorMain:
    mov rax, text
    call _printString

    call _GetUserIn
    mov rsi, rbx
    sub rax, 1          ; eax = string length, - 1 is necessary for the loop
    mov rcx, rax
    call _stringToInt
    push rax            ; push the number to the stack

    mov rax, text2
    call _printString

    call _GetUserIn
    mov rsi, rbx
    sub rax, 1          ; eax = string length, - 1 is necessary for the loop
    mov rcx, rax
    call _stringToInt
    push rax            ; push the result to the stack

    mov rax, text3
    call _printString

    call _GetMode
    cmp rax, 0          ; mode = addition
    je .Addition

    cmp rax, 1          ; mode = substraction
    je .Substraction

    cmp rax, 2          ; mode = Multiply
    je .Multiply

    cmp rax, 3          ; mode = Divide
    je .Divide

    jmp .ErrorMode

.Addition:
    pop rbx
    pop rax
    add rax, rbx
    printNbrToLine rax

    jmp .AllOperation

.Substraction:
    pop rbx
    pop rax
    sub rax, rbx

    test rax, rax
    jns .nonSigned
.signed:
    push rax
    
    mov rax, minus
    call _printString

    pop rax
    neg rax
.nonSigned:
    printNbrToLine rax

    jmp .AllOperation

.Multiply:
    pop rbx
    pop rax
    imul rbx
    printNbrToLine rax

    jmp .AllOperation

.Divide:
    pop rbx
    pop rax
    mov rdx, 0          ; clear rdx register
                        ; if not done it would lead to a floating point exception
    idiv rbx
    push rdx
    printNbr rax

    mov rax, decimal
    call _printString

    pop rax
    printNbrToLine rax

    jmp .AllOperation

.ErrorMode:
    pop rax
    pop rbx
    mov rax, text4
    call _printString

.AllOperation:
    ret