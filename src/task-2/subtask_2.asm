section .text
    global binary_search
    ;; no extern functions allowed

binary_search:
    ;; create the new stack frame
    enter 0, 0

    ;; save the preserved registers
    push ebx
    push edi
    push esi

    ;; save arguments in local variables
    ; fastcall convention
    ; ecx - buff
    ; edx - needle

    ; start
    mov eax, [ebp + 8]
    ; end
    mov ebx, [ebp + 12]

    ;; recursive bsearch implementation goes here
    ; check if start >= end
    cmp eax, ebx
    je equal
    cmp eax, ebx
    jg not_found

    ; middle index
    xor esi, esi
    mov esi, ebx
    add esi, eax
    ; (start + end) / 2
    shr esi, 1

    ; middle element
    xor edi, edi
    ; 4 = sizeof(int)
    mov edi, dword [ecx + 4 * esi]

    ; compare middle element with the needle
    cmp edx, edi
    je found_element
    cmp edx, edi
    jl search_left
    cmp edx, edi
    jg search_right

; search in the left part of buff
search_left:
    ; midlle - 1
    sub esi, 1
    ; new end
    push esi
    ; start
    push eax
    call binary_search
    ; move stack pointer
    add esp, 8
    jmp end

search_right:
    ; midlle + 1
    add esi, 1
    ; end
    push ebx
    ; new start
    push esi
    call binary_search
    ; move stack pointer
    add esp, 8
    jmp end

; if the needle is found, return position
found_element:
    xor eax, eax
    mov eax, esi
    jmp end

; if start == end skip and check if the single element
; is equal to needle
equal:
    xor edi, edi
    ; 4 = sizeof(int)
    mov edi, dword [ecx + 4 * eax]
    cmp edx, edi
    jne not_found
    xor eax, eax
    mov eax, ebx
    jmp end

; if the needle is not found, return -1
not_found:
    xor eax, eax
    ; if not found, return -1
    mov eax, -1

    ;; restore the preserved registers
end:
    pop esi
    pop edi
    pop ebx
    leave
    ret
