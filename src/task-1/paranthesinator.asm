; Interpret as 32 bits code
[bits 32]

%include "../include/io.mac"

section .bss
    ; 'fake' stack
    fake_stack resb 1024

section .text
; int check_parantheses(char *str)
global check_parantheses
check_parantheses:
    push ebp
    mov ebp, esp

    ; sa-nceapa concursul

    ; initialize stack pointer
    mov edi, fake_stack

    ; address of the input string
    mov esi, [ebp + 8]

loop:
    ; get the current character
    xor eax, eax
    mov al, [esi]
    ; check for end of string
    cmp al, 0
    je end

; check if the character is an opening bracket
open:
    cmp al, '('
    je push_stack
    cmp al, '{'
    je push_stack
    cmp al, '['
    je push_stack

; check if the character is a closing bracket
close:
    cmp al, ')'
    je pop_stack1
    cmp al, '}'
    je pop_stack2
    cmp al, ']'
    je pop_stack3

; push the opening character on the stack
push_stack:
    mov [edi], al
    inc edi
    jmp next

; pop the character from the stack and 
; check too see if the closing is correct
pop_stack1:
    dec edi
    xor ecx, ecx
    mov cl, [edi]
    cmp cl, '('
    je next
    jmp incorrect

pop_stack2:
    dec edi
    xor ecx, ecx
    mov cl, [edi]
    cmp cl, '{'
    je next
    jmp incorrect

pop_stack3:
    dec edi
    xor ecx, ecx
    mov cl, [edi]
    cmp cl, '['
    je next

incorrect:
    xor eax, eax
    ; if the closing is not correct, return 1
    mov eax, 1
    jmp done

; loop for the next character
next:
    inc esi
    jmp loop

end:
    xor eax, eax
    ; if the closing is correct, return 0
    mov eax, 0

done:
    leave
    ret
