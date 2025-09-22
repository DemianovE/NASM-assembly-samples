;; This task is to get the 2 numbers in the arguments and print out the result
;; sample: ./args_add 10 2
;; output: 12

;; the main purpose is to show the basic byte operations and how the math can be done
;; The main bit of theory required is that there is a LIFO stack which is used by processes to
;; work with the data such as flags and etc. In future you will see that main purpose is to
;; store registries and flags when calling functions to avoid data overwrites. But in case below stack
;; will be used to store the symbols for printing.

;; For stacks the most important registries in x86 version is rsp and rbp.
;;  - rsp - the stack pointer, points to last element
;;  - rbp - pointer to current stack start (Start of function stack etc.)

;; Maybe you dont know what a flag is? This are specific registries which hold the values of the logic
;; operations when the cmp is used all next operations such as the je or jz relly on them. So saving them
;; is good practice

;; One more small bit of information. In ASCII the numbers in text are exactly 48 byts away from their
;; numeric values. The 0 is 48 and 9 is 57. As such to get the value, we divide the 48 from byt value.
;; opposite is made to make int to string

;; WHat is new in the code
;;  1) pop/push - commands to put the elements to the stack or get from the stack
;;  2) cmp - compare function. used with jumps to make logic blocks
;;  3) jne/je - jump if equal or not equal. Jumps to specific function
;;  4) call - call the function and then return to the same line to continue
;;  5) ret - the jump back to where function is called and point stack to the correct section back
;;  6) add/sub - add and subtract from value
;;  7) xor - XOR logical gate :). It is basically 0 when equal. SO is used to reset registries to 0
;;  8) jmp - unconditional jump to the specific function
;;  9) inc/dec - increment and decrement from the registry value
;; 10)

SYS_WRITE equ 1 ;; the sys_command for the sys_write
SYS_EXIT equ 60 ;; the sys_command for the sys_exit

STD_OUT equ 1   ;; The parameter for STDOUT
EXIT_CODE equ 0 ;; The status code for exit successful

section .data
    NEW_LINE db 0xa ;; New line in the ASCII

    WRONG_ARG_MSG db "Error: expected two CLI arguments", 0xa
    WRONG_TYPE_MSG db "Error: expected int type argument", 0xa
    WRONG_ARG_LEN equ 42

section .text
    global _start ;; init of the intro

_start:
    pop rcx      ;; get the number of passed arguments into rcx
    cmp rcx, 3   ;; check if there are 3 arguments
    jne argError ;; if not equal then execute the error

    mov  rsi, [rsp+8] ;; save argument to rsi registry. Second in stack
    call str_to_int   ;; convert the rsi into the int and store in rax
    mov r10, rax      ;; move result from rax to the r10

    mov  rsi, [rsp+16] ;; save next argument to rsi. Third in stack
    call str_to_int    ;; call the strig to int ans save result to rax
    mov  r11, rax      ;; move the result from rax to r11

    add r10, r11 ;; add the values of two arguments
    mov rax, r10 ;; move the result to rax
    xor r12, r12 ;; reset the counter to 0

    jmp int_to_str ;; start the print stage

str_to_int: ;; make the conversion of the 8b string to int
    xor rax, rax ;; set rax to 0
    mov r12, 10  ;; set base to multiply
__repeat: ;; the loop of str_to_int
    cmp [rsi], byte 0 ;; compare the result to NULL
    je  __return ;; if yes return

    mov bl, [rsi] ;; move the character to the bl registry

    cmp bl, '0'   ;; check if the value is higher then '0'
    jl  typeError ;; if not then make error
    cmp bl, '9'   ;; check if value is lower than '9'
    jg  typeError ;; if not then make error

    sub bl, 48    ;; get the numeric value of the character

    mul r12      ;; multiply to get the place of digit. This is basically multiplying rax by the value in r12
    ADD rax, rbx ;; add the next digit
    inc rsi      ;; get next character

    jmp __repeat
__return: ;; return phase of the str_to_int
    ret ;; return back to the caller

int_to_str: ;; store the string version of number in stack
    mov rdx, 0  ;; high part of the dividend
    mov rbx, 10 ;; the divisor

    div rbx     ;; divide rax by 10, remainder will be stored in rdx
    add rdx, 48 ;; return to the char format by adding the 48 to address

    push rdx ;; store it on stack
    inc  r12 ;; increment the counter

    cmp rax, 0x0    ;; check if rax is empty
    jne int_to_str  ;; make loop back if not equals
    jmp printResult ;; print the result if finished

printResult: ;; make the print of the data stored in stack
    mov rax, r12 ;; store counter value into rax
    mov r12, 8   ;; store 8 in rcx registry
    mul r12      ;; get the number of bytes in rax registry, result is stored in rax

    mov  rsi, rsp   ;; set the message to bugger text
    mov  rdx, rax   ;; set the message length in the stack
    call printSupp ;; call the print supp function

    mov  rsi, NEW_LINE ;; set text to new line
    mov  rdx, 1        ;; set the length of message to 1
    call printSupp    ;; call the print support function

    jmp exit

argError: ;; function to call the error of arguments number
    mov  rsi, WRONG_ARG_MSG ;; pass the error message
    mov  rdx, WRONG_ARG_LEN ;; pass the length of the message
    call printSupp          ;; run supp function to start the print

    jmp exit ;; proceed to jump

typeError: ;; function to call the error of the argument type
    mov  rsi, WRONG_TYPE_MSG ;; pass the error message
    mov  rdx, WRONG_ARG_LEN  ;; pass the length of the message
    call printSupp           ;; run supp function to start the print

    jmp exit ;; proceed to jump

printSupp: ;; function to make printing shorter
    mov rax, SYS_WRITE ;; pass the sys_write to rax
    mov rdi, STD_OUT   ;; set the rdi to stdout
    syscall            ;; execute a system function

    ret ;; make the return of the registries

exit:
    mov rax, SYS_EXIT  ;; start the sys_exit
    mov rdi, EXIT_CODE ;; pass the code successful
    syscall            ;; execute the sys_command