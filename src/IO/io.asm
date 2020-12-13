%include "src/String/string.inc"

section .data
    digit db 0,10
    retToLine db 10

section .bss
    in_buffer resb 16  ; reserve 16 bytes of memory

section .text
    global _printString
    global _printInteger
    global _printReturnToLine
    global _GetUserIn
;--------------------------
;           INPUT
;--------------------------

; INPUT
; NONE
;
; OUTPUT
; rax = input length
; rbx = buffer address
_GetUserIn:
    mov rax, 0          ; sys_read
    mov rdi, 0          ; input
    mov rsi, in_buffer  ; set buffer addr to rsi
    mov rdx, 16         ; size to read in byte
    syscall             ; syscall
    mov rbx, in_buffer  ; set rax to buffer addr for return value
    ret                 ; return

;--------------------------
;           OUTPUT
;--------------------------

; INPUT 
; rax pointing to the string to print
;
; OUTPUT : NONE
; Print a string
_printString:
    push rax        ; push rax content on top of the stack
    
    call _GetStringSize
    mov rbx, rax    ; mov the string size into rbx

    mov rax, 1      ; syscall ID
    mov rdi, 1      ; output mode
    pop rsi         ; pop the content of the stack into rsi (the stack content is the data we want to print)
    mov rdx, rbx    ; put rbx (our counter) to rdx (number of byte to print)
    syscall         ; call the syscall

    ret             ; return

; INPUT
; rax = integer to print
; rbx = value length
;
; OUTPUT
; NONE
; print a string
_printInteger:
    mov rcx, 10     ; counter set to 10
    push 0          ; count the number of char in the int
.intPrintLoop1:
    mov rdx, 0
    mov rbx, 10
    div rbx

    pop rbx         ; recover the char number counter

    push rdx        ; put the remaining into the stack

    inc rbx         ; increment the counter 
    push rbx        ; push the counter into the stack

    cmp rax, 0
    je .next
    
    dec rcx
    jne .intPrintLoop1

.next:
    pop rcx         ; recover the number of byte that were pushed
.intPrintLoop2:
    pop rax
    push rcx
    call _printDigit
    pop rcx
    dec rcx
    jne .intPrintLoop2

    ;call _printReturnToLine
    ret

; INPUT
; rax = number to print
;
; OUTPUT
; NONE
; print a digit
_printDigit:
    add rax, 48
    mov [digit], al
    mov rax, 1
    mov rdi, 1
    mov rsi, digit
    mov rdx, 1
    syscall
    ret

; INPUT
; NONE
;
; OUTPUT
; NONE
; Return to the next line
_printReturnToLine:
    mov rax, 1
    mov rdi, 1
    mov rsi, retToLine
    mov rdx, 1
    syscall
    ret