section .text
    global _CmpString
    global _stringToInt
    global _GetStringSize

; INPUT
; rsi = pointer to the string
; rcx = number of digit in the string
;
; OUPUT
; rax = integer value
_stringToInt:
    xor rbx, rbx            ; clear rbx
.nextDigit:
    movzx rax, byte [rsi]   ; mov the next number in rax
    inc rsi
    sub al, '0'             ; convert from ASCII to int
    imul rbx, 10            ; we read the int in reverse order
                            ; so the first number is the highest one
                            ; that's why we multiply it by 10.
    add rbx, rax            ; now we add the next number to rbx
    loop .nextDigit         ; dec rcx & jne .nextDigit
    mov rax, rbx            ; once we've finish  put rbx into rax.
    ret

; INPUT
; rax = string 1
; rbx = string 2
;
; OUTPUT
; rax 
;   = 0 the strings are equal
;   = something else the strings are not equal
_CmpString:
    push rax            ; put string 1 into the stack
    push rbx            ; put string 2 into the stack
    call _GetStringSize ; get string 1 size
    mov rbx, 0          ; reset rbx
    mov rbx, rax        ; put string size into rbx
    pop rax             ; put string 2 into rax
    push rax            ; put string 2 into the stack 
    push rbx            ; put string 1 size into the stack
                        ; STACK LAYOUT
                        ; STRING 1 SIZE <- next pop
                        ; STRING 2
                        ; STRING 1
    call _GetStringSize ; get string 2 size
    mov rbx, 0          ; reset rbxs
    pop rbx             ; revover string 1 size
    cmp rax, rbx        ; compare string 1 size to string 2 size
    jne .sizeNotMatch   ; if the size do no match

    pop rbx             ; put string 2 into rbx
    pop rax             ; put string 1 into rbx
.stringMatchloop:
    mov cl, [rax]       ; mov string 1 char into cl (rcx first byte)
    mov dl, [rbx]       ; mov string 2 char into dl (rdx first byte)
    cmp cl, dl          ; compare the two char
    jne .stringNotMatch ; if not equal jump to string does not match
    inc rax             ; increment the register to read next byte
    inc rbx             ; increment the register to read next byte
    cmp cl, 0           ; check if the last char is the end of the string
    jne .stringMatchloop; continue the loop

    mov rax, 0          ; string are equal
    jmp .both           ; execute the next code 
.sizeNotMatch:          ; call .sizeNotMatch to pop and clear the stack before return
    pop rbx             ; pop to clean the stack and reset the return address
    pop rax             ; pop to clean the stack and reset the return address
.stringNotMatch:        ; call .stringNotMatch if the pushed values are already poped
    mov rbx, 0          ; clear rbx
    mov rax, 1
.both:
    ret                 ; return

; INPUT
; rax = the string
;
; OUTPUT
; rax = the string size
_GetStringSize:
    mov rbx, 0      ; put 0 to rbx

.sizeLoop:
    inc rax         ; increment rax to read the next byte
    inc rbx         ; increment rbx to count the size of the string
    mov cl, [rax]   ; mov the content of the byte pointed by rax to cl which are the last 8bits of rcx
    cmp cl, 0       ; compare cl to 0 to see if we reach the end of the string
    jne .sizeLoop   ; jump back to the begining of the loop if we did not reach the end
    mov rax, rbx    ; mov the counter value to rax
    ret