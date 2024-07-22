; Interpret as 64 bits code
[bits 64]

; nu uitati sa scrieti in feedback ca voiati
; assembly pe 64 de biti

section .text
global map
global reduce
map:
    ; look at these fancy registers
    push rbp
    mov rbp, rsp

    ; sa-nceapa turneu'
    ; save the arguments in registers

    ; destination array
    mov r12, rdi
    ; source array
    mov r13, rsi
    ; array size
    mov r14, rdx
    ; function to apply
    mov r15, rcx

    ; initialize loop contor
    xor rbx, rbx
    ; start from 0
    mov rbx, 0

    ; loop through elements in source array

loop:
    cmp rbx, r14
    jge end

    ; move in rdi the current element in source array
    ; call function to apply
    mov rdi, qword [r13 + 8 * rbx]
    call r15

    ; move returned value in destination array
    mov qword [r12 + 8 * rbx], rax

    ; increase contor
    add rbx, 1
    jmp loop

end:
    leave
    ret


; int reduce(int *dst, int *src, int n, int acc_init, int(*f)(int, int));
; int f(int acc, int curr_elem);
reduce:
    ; look at these fancy registers
    push rbp
    mov rbp, rsp

    ; sa-nceapa festivalu'

    ; save the arguments in registers

    ; destination array
    mov r12, rdi
    ; source array
    mov r13, rsi
    ; array size
    mov r14, rdx
    ; accumulator
    mov r15, rcx
    ; function to apply
    mov r10, r8

    ; initialize loop contor
    xor rbx, rbx
    ; start from 0
    mov rbx, 0

    ; loop through elements in source array
loop2:
    cmp rbx, r14
    je end2

    ; move in rsi the current element in source array
    ; move in rdi the accumulator
    ; call function to apply
    mov rsi, qword [r13 + 8 * rbx]
    mov rdi, r15
    call r10

    ; move returned accumulator in r15
    mov r15, rax

    ; increase contor
    add rbx, 1
    jmp loop2

end2:
    xor rax, rax
    mov rax, r15
    leave
    ret

