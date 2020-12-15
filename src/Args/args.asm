%include "src/String/string.inc"
%include "src/IO/io.inc"

section .data
    wrong_arg db "unknown argument! ",0
    mode_already_set db "bad calculator mode is already set!",10,0
    arg_a db "-a",0     ; add arg
    arg_s db "-s",0     ; substract arg
    arg_m db "-m",0     ; multiply arg
    arg_d db "-d",0     ; divide arg
    arg_f db "-f",0     ; from file
    mode_a db "Mode is add",10,0           ; add arg
    mode_s db "Mode is substract",10,0     ; substract arg
    mode_m db "Mode is multiply",10,0      ; multiply arg
    mode_d db "Mode is divide",10,0        ; divide arg
    mode db 00          ; mode 0 = addition
                        ; mode 1 = substraction
                        ; mode 2 = multiply
                        ; mode 3 = divide
                        ; mode 4 = from file
    mode_set db 00      ; set to 1 once mode is set

section .text
    global _ProcessArgs
    global _GetMode
    global _ShowDefaultMode

; INPUT
; rax = arg
;
; OUTPUT
; NONE
; process the cmd line args
_ProcessArgs:
    push rax            ; push the string address
    mov rbx, arg_a      ; mov arg_a into rbx for compare
    call _CmpString
    cmp rax, 0          ; check if the strings are equal
    je .argIsAdd

    pop rax
    push rax
    mov rbx, arg_s      ; mov arg_s into rbx for compare
    call _CmpString
    cmp rax, 0          ; check if the strings are equal
    je .argIsSub

    pop rax
    push rax
    mov rbx, arg_m      ; mov arg_m into rbx for compare
    call _CmpString
    cmp rax, 0          ; check if the strings are equal
    je .argIsMul

    pop rax
    push rax
    mov rbx, arg_d      ; mov arg_d into rbx for compare
    call _CmpString
    cmp rax, 0          ; check if the strings are equal
    je .argIsDiv
    
    jmp .WrongArg
.argIsAdd:
    mov al, [mode_set]
    cmp al, 0
    jne .modeAlreadySet
    mov al, 0
    mov [mode], al
    mov al, 1
    mov [mode_set], al

    mov rax, mode_a
    call _printString
    
    jmp .allArgs

.argIsSub:
    mov al, [mode_set]
    cmp al, 0
    jne .modeAlreadySet
    mov al, 1
    mov [mode], al
    mov al, 1
    mov [mode_set], al
    
    mov rax, mode_s
    call _printString

    jmp .allArgs

.argIsMul:
    mov al, [mode_set]
    cmp al, 0
    jne .modeAlreadySet
    mov al, 2
    mov [mode], al
    mov al, 1
    mov [mode_set], al

    mov rax, mode_m
    call _printString

    jmp .allArgs

.argIsDiv:
    mov al, [mode_set]
    cmp al, 0
    jne .modeAlreadySet
    mov al, 3
    mov [mode], al
    mov al, 1
    mov [mode_set], al

    mov rax, mode_d
    call _printString

    jmp .allArgs

.modeAlreadySet:
    mov rax, mode_already_set
    call _printString
    jmp .allArgs
.WrongArg:
    mov rax, wrong_arg
    call _printString
    pop rax
    call _printString
    call _printReturnToLine
    jmp .return         ; not required because the it is just below it
.allArgs:
    pop rax             ; pop rax value to have the correct ret address
.return:
    ret

; INPUT
; NONE
; 
; OUTPUT
; NONE
; print the default mode
_ShowDefaultMode:
    mov rax, mode_a
    call _printString
    ret

; INPUT
; NONE
; 
; OUTPUT
; NONE
; return the mode
; rax = the current mode
; mode 0 = addition
; mode 1 = substraction
; mode 2 = multiply
; mode 3 = divide
_GetMode:
    mov rax, 0
    mov al, [mode]
    ret

_SetMode:
    ret