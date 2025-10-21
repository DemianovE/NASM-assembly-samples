;; The string macro group
;; used for string related jobs. The main purpose is of course print for now

%include "sys.asm" ;; include system specific code

MAXIMUM_LEN_SIZE equ 4096 ;; one page is maximum for the string to process
NEW_LINE_ db 0xa ;; The symbol for the PRINTLN macro

;; The macro to calculate the string length. It has a stoper which acts as a safety measure
;; The params are:
;;  1 - the string itself
;;  2 - the maximum size. By default is   MAXIMUM_LEN_SIZE
;; The function throws the error when maximum is archived
;; The output is length which is saved in rax
%macro STR_LEN 1-2 MAXIMUM_LEN_SIZE ;; string, [maximum length]
    SAVE_SPECIFIC_REGS rdi

    xor rax, rax ;; set rax to 0
    mov rdi, %2  ;; set the length of the maximum
%%loop_len: ;; the loop which goes bit by bit
    test rdi, rdi ;; check if the maximum was hit
    jz   error    ;; trigger the max size error

    cmp byte [%1+rax], 0 ;; shift the byte pointer and check in NUL
    je  %%after_work       ;; if yes, finish
    inc rax              ;; if not increase the rax pointer
    dec rdi              ;; decrease the maximum limit
    jmp %%loop_len       ;; loop back
%%error: ;; the error maximum length call
    RESTORE_SPECIFIC_REGS rdi
    %error "The string limit is reached"
%%after_work: ;; the return part
    RESTORE_SPECIFIC_REGS rdi
%%done:
%endmacro

;; the macro to make a single string or symbol print
;; The params are:
;;   1 - the string itself
;;   2 - the length of the string. Calculated by default
;; The command make no output. But the print error can be executed
%macro PRINT 1-2 ;; string, [length of string]
    SAVE_ALL_REGS
    %if %0 == 2      ;; check if there is length
        mov rdx, %2  ;; set the length to second argument
    %elif %0 == 1    ;; of no then execute default flow
        STR_LEN %1   ;; calculate length and save in rax
        mov rdx, rax ;; move the value from rax
        xor rax, rax ;; set rax to 0
    %else
        %error "PRINT macro requires 1 or 2 arguments"
    %endif

    mov rax, SYS_WRITE ;; make the sys_command set to sys_write
    mov rdi, STD_OUT   ;; set type of output STD_OUT
    mov rsi, %1        ;; the print string

    syscall ;; perform the sys_command

    test rax, rax ;; test of the rax is less than zero
    jl error      ;; if <0 then trigger error
    jmp after_work      ;; otherwise finish the command
%%error:
    RESTORE_ALL_REGS
    %error "The print command failed"
%%after_work:
    RESTORE_ALL_REGS
%%done:
%endmacro

;; The function to execute the print with next line symbol
;; The params are:
;;   1 - the string itself
;;   2 - the length of the string. Calculated by default
;; The command make no output or error
%macro PRINTLN 1-2 ;; string, [length of string]
    %if %0 == 2      ;; check if length is present
        PRINT %1, %2 ;; execute the print with length
    %else            ;; otherwise
        PRINT %1     ;; provide no length
    %endif

    PRINT NEW_LINE_, 1 ;; the new line symbol execution
%endmacro
