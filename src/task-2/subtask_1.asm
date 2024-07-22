; subtask 1 - qsort

section .text
    global quick_sort
    ;; no extern functions allowed

quick_sort:
    ;; create the new stack frame
    enter 0, 0
    pusha

    ;; save the preserved registers
    ; pointer to the first element in buff
    mov eax, [ebp + 8]
    ; start
    mov ebx, [ebp + 12]
    ; end
    mov ecx, [ebp + 16]

    ; if start >= end
    cmp ebx, ecx
    jge end

    xor edx, edx
    ; start index
    mov edx, ebx
    xor esi, esi
    ; pivot (last element)
    mov esi, dword [eax + 4 * ecx]

loop:
; if current index >= end index
    cmp edx, ecx
    jge recursive

    ; if current element in buff <= pivot
    cmp esi, dword [eax + 4 * edx]
    jl continue

    ; otherwise swap elements

    ; save pivot (need of 2 registers for swap)
    push esi
    xor esi, esi
    ; 4 = sizeof(int)
    mov esi, dword [eax + 4 * edx]
    xor edi, edi
    ; 4 = sizeof(int)
    mov edi, dword [eax + 4 * ebx]
    ; 4 = sizeof(int)
    mov dword [eax + 4 * ebx], esi
    ; 4 = sizeof(int)
    mov dword [eax + 4 * edx], edi
     ; restore pivot
    pop esi

    ; increase contor for start
    add ebx, 1

continue:
    ; increase contor for current index
    add edx, 1
    jmp loop

recursive:
    ; swap with pivot
    xor esi, esi
    xor edi, edi
    ; 4 = sizeof(int)
    mov esi, dword [eax + 4 * ebx]
    ; 4 = sizeof(int)
    mov edi, dword [eax + 4 * ecx]
    ; 4 = sizeof(int)
    mov dword [eax + 4 * ecx], esi
    ; 4 = sizeof(int)
    mov dword [eax + 4 * ebx], edi

    ; recursive call for left and right part

    ; left

    ; quick_sort( *buff, start, pivot - 1 )
    sub ebx, 1
    ; push new end index
    push ebx
    ; push start index
    push dword [ebp + 12]
    ; push buff
    push dword [ebp + 8]
    call quick_sort
    ; move stack pointer
    add esp, 8
    pop ebx 

    ; right

    ; quick_sort( *buff, pivot + i, end )
    add ebx, 1
    ; push end index
    push dword [ebp + 16]
    ; push new start index
    push ebx
    ; push buff
    push dword [ebp + 8]
    call quick_sort
    ; move stack pointer
    add esp, 12

end:
    popa
    leave
    ret
