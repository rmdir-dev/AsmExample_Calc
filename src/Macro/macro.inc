%macro exit 0
    mov rax, SYS_EXIT
    mov rdi, 0
    syscall
%endmacro

%macro printNbrToLine 1
    mov rax, %1
    call _printInteger
    call _printReturnToLine
%endmacro

%macro printNbr 1
    mov rax, %1
    call _printInteger
%endmacro

%define SYS_EXIT 60