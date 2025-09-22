;; Learning repo and no hello world? Of course no!
;; this code represents what the printing and exiting the code is like in the assembler

;; To start some basic theory. The code in assembler is basically the set of command which we use to
;; move the data or perform logical or arithmetical operations (Hello ALU ;)). But there is also one confusion
;; We also have "system commands" - set of commands specific to kernel which we can use.
;; The assembler commands and system ones are not same! But we use assembler ones to make system
;; Simplest example is exit. But first:

;; Registries!!!!
;; The registries are the high speed memory blocks that the CPU creates for the process to use.
;; For linux the cashes are following: rax, rbx, rcx, rdx, rsi, rdi, rbp, r8, ..., r15
;; This is basically the storage? yes and no. We can start with the commands. In assembler we
;; can use predefined registries to select command and pass arguments. We then use the syscall
;; which tells kernel that the information is set and then the kernel executes the command based on arguments
;; So, for example the command print("Hello world"); is what we have on line 53-57

;; So here is how the syscall works
;; rax - the selection of command (1 - sys_write, 0 - sys_read, 60 - sys_exit , etc.) They are defined
;; in the linux doc.
;; rdi - the first parameter
;; rsi - the second parameter
;; rsi - the 3 parameter
;; and so on: rdx, rcx, r8, r9. Each command have definition of what to pass and how much

;; So back to system commands. We use the assembler ones to make the system calls using defined above rules.
;; One important topic is also sections, they are parts of code for specific actions such as:
;;  - .data - the declaration of data
;;  - .bss - the reservation of the buffers for future
;;  - .text - for the declaration such as global

;; Each file has the new commands sections, to understand code better:
;;  1) mov - building block of assembly, move data from registry to registry
;;  2) syscall - the call to kernel to execute the sys_command
;;  3) db - in .data you can see I use it to define string, this means define byte. We make array with
;;           one byte one symbol
;;  4) equ - can be seen on line 39. Used to set the constant with numeric value

SYS_WRITE equ 1 ;; the sys_command for the sys_write
SYS_EXIT equ 60 ;; the sys_command for the sys_exit

STD_OUT equ 1   ;; The parameter for STDOUT
EXIT_CODE equ 0 ;; The status code for exit successful

section .data
    NEW_LINE db 0xa        ;; the 0xa is new line symbol in hex
    INPUT db "Hello world!" ;; set the string itself

section .text
    global _start

_start:
    mov rax, SYS_WRITE ;; set the command to sys_write
    mov rdi, STD_OUT   ;; set the output to STD_OUT
    mov rsi, INPUT     ;; set the output string to the string we defined
    mov rdx, 12        ;; set string length to 10
    syscall            ;; perform the system command

    mov rax, SYS_WRITE ;; set the command to sys_write
    mov rdi, STD_OUT   ;; set the output to STD_OUT
    mov rsi, NEW_LINE  ;; set the output string to the new line symbol we defined
    mov rdx, 1         ;; set string length to 10
    syscall            ;; perform the system command

    mov rax, SYS_EXIT  ;; set command to sys_exit
    mov rdi, EXIT_CODE ;; set status to 0 (successful)
    syscall            ;; perform the system command
