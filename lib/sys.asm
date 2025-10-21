;; System specific equ definitions
;; it is used by other macros as a way to organise the inter system communications
;; also it manages the registry specific logic

;; TO-DO:
;; 1) introduce the multi system registry definition
;; 2) make system check automatic

%ifdef LINUX ;; check for LINUX configs
    SYS_WRITE equ 1 ;; the sys_command for the sys_write
    SYS_EXIT equ 60 ;; the sys_command for the sys_exit
    SYS_READ equ 0  ;; the sys_command for the sys_read
%elifdef MACOS ;; check for MACOS configs
    SYS_WRITE equ 0x2000004 ;; the sys_command for the sys_write
    SYS_EXIT equ 0x2000001  ;; the sys_command for the sys_exit
    SYS_READ equ 0x2000003  ;; the sys_command for the sys_read
%else
    %error "You must define LINUX or MACOS"
%endif

;; |======================================== REGISTRIES

;; function to save selected registries. The start wrapper to preserve the registries
;; the arguments are:
;;  1-* - registries
%macro SAVE_SPECIFIC_REGS 1-*
    %rep %0
        push %1
        %rotate 1
    %endrep
%endmacro

;; function to restores selected registries. The start wrapper to preserve the registries
;; the arguments are:
;;  1-* - registries. Should be reverted
%macro RESTORE_SPECIFIC_REGS 1-*
    %rep %0
        %rotate -1
        pop %1
    %endrep
%endmacro

;; function for general all save and restore. Both use previous functions
;; the arguments are none
%macro SAVE_ALL_REGS 0
    SAVE_SPECIFIC_REGS rax, rbx, rcx, rdx, rsi, rdi, rbp    ;; push regs on stack
    SAVE_SPECIFIC_REGS r8, r9, r10, r11, r12, r13, r14, r15 ;; push regs on stack

    pushf ;; push flags on stack
%endmacro
%macro RESTORE_ALL_REGS 0
    popf ;; pop the flags from stack

    RESTORE_SPECIFIC_REGS r8, r9, r10, r11, r12, r13, r14, r15 ;; pop regs from stack
    RESTORE_SPECIFIC_REGS rax, rbx, rcx, rdx, rsi, rdi, rbp    ;; pop regs from stack
%endmacro

;; |======================================== ERRORS + EXITS

;; Function to perform the sys_exit action
;; The argument are
;; - [1] - the code of error, 0 by default (successful)
%macro EXIT 0-1 0 ;; [exit code]

%endmacro