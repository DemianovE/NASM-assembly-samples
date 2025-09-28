;; This script was two reasons to exists
;;  - The buffer and how to work with it
;;  - The macros, inline functions. very useful

;; So starting with buffer. The .bss is the sections to reserver some memory but not allocate it yet.
;; Here the resb is used to reserve the byte space. Then we use this specific buffer and byte pointer math
;; to stove symbols. In this case reverse string

;; The macros are beautiful. Not like in C where they are the lib preferred type. Here they are used for
;; explicit actions which we will be  user repeatedly. In future I will be using the lib folder with specified
;; "libs" which are for specific actions. As such we write them specifically for that.
;; for macro creation the %macro and %endmacro is used. This is a great way to optimise code.

;; What is new
;;   - lodsb - We move the [rsi] into al, the x32 part of rax. As such basically we store one item and
;;             move pointer of rsi one bit further. Effectively reading the rsi bit by bit

SYS_WRITE equ 1 ;; the sys_command for the sys_write
SYS_EXIT equ 60 ;; the sys_command for the sys_exit

STD_OUT equ 1   ;; The parameter for STDOUT
EXIT_CODE equ 0 ;; The status code for exit successful

;; macro to perform a system command of print
%macro PRINTLN 1 ;; string
    mov rax, SYS_WRITE ;; set the command to sys_write
    mov rdi, STD_OUT   ;; set the output to STD_OUT
    mov rsi, %1        ;; set the output string to the buffer we defined
    syscall            ;; perform the system command

    mov rax, SYS_WRITE ;; set the command to sys_write
    mov rdi, STD_OUT   ;; set the output to STD_OUT
    mov rsi, NEW_LINE  ;; set the output string to the new line symbol
    mov rdx, 1         ;; set the length to one element
    syscall            ;; perform the system command
%endmacro

;; macro to perform a simple system command of exit
%macro EXIT 1 ;; exit code
    mov rax, SYS_EXIT ;; set command to sys_exit
    mov rdi, %1       ;; set status to passed one
    syscall           ;; perform the system command
%endmacro

section .data
    NEW_LINE db 0xa
    INPUT db "Hello wold!"

section .bss ;; the buffer definition section
    OUTPUT resb 1 ;; output buffer for reverse

section .text
    global _start

_start:
    xor rcx, rcx    ;; set rcx to 0
    mov rsi, INPUT  ;; store input text address in rsi
    mov rdi, OUTPUT ;; store output first bit address into rdi

reverseStringAndPrint: ;; save characters into the stack and get len of the string
    cmp byte [rsi], 0  ;; check if the value of rsi is NUL
    mov rdx, rcx       ;; preserve the length of rcx
    je  reverseString  ;; if reached the end, reverse it
    lodsb              ;; load rsi byte into al and move to next character

    push rax                   ;; save the character on the stack
    inc  rcx                   ;; increment number of elements
    jmp  reverseStringAndPrint ;; continue loop

reverseString: ;; reverse the string and save to output buffer
    cmp rcx, 0      ;; check if there is no symbols
    je  printResult ;; if true than skip the reverse

    pop rax        ;; pop one symbol from stack to rax
    mov [rdi], rax ;; put the character to the out buffer
    inc rdi        ;; move to next character in buffer

    dec rcx           ;; decrease the counter of characters
    jmp reverseString ;; loop back

printResult:
    PRINTLN OUTPUT
    EXIT EXIT_CODE