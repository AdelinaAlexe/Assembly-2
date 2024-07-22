%include "../include/io.mac"

; The `expand` function returns an address to the following type of data
; structure.
struc neighbours_t
    .num_neighs resd 1  ; The number of neighbours returned.
    .neighs resd 1      ; Address of the vector containing the `num_neighs` neighbours.
                        ; A neighbour is represented by an unsigned int (dword).
endstruc

section .bss
; Vector for keeping track of visited nodes.
visited resd 10000
global visited

section .data
; Format string for printf.
fmt_str db "%u", 10, 0

section .text
global dfs
extern printf

; C function signiture:
;   void dfs(uint32_t node, neighbours_t *(*expand)(uint32_t node))
; where:
; - node -> the id of the source node for dfs.
; - expand -> pointer to a function that takes a node id and returns a structure
; populated with the neighbours of the node (see struc neighbours_t above).
; 
; note: uint32_t is an unsigned int, stored on 4 bytes (dword).
dfs:
    push ebp
    mov ebp, esp
    pusha

    ; TODO: Implement the depth first search algorith, using the `expand`
    ; function to get the neighbours. When a node is visited, print it by
    ; calling `printf` with the format string in section .data.

    ; node
    mov ebx, [ebp + 8]
    ; [ebp + 12] - expand function

    ; mark node as visited
    mov dword [visited + ebx * 4], 1

    ; print the current node
    push ebx
    push fmt_str
    call printf
    ; move stack pointer
    add esp, 8

    ; get the neighbours of the current node by calling expand
    push ebx
    ; address of expand function
    call [ebp + 12]
    ; move stack pointer
    add esp, 4

    ; store the returned pointer in esi
    xor esi, esi
    mov esi, eax

    ; get the number of neighbours
    xor ecx, ecx
    mov ecx, [esi]

    ; move to the list field
    add esi, 4

    ; load the address of neighbours vector
    xor edi, edi
    mov edi, [esi]

    ; loop through neighbours and call dfs recursively
    xor esi, esi
    ; contor
    mov esi, 0

loop:
    ; iterate through number of neighbours
    cmp esi, ecx
    je end

    ; check too see if neighbour is visited
    xor edx, edx
    ; 4 = sizeof(int)
    mov edx, [edi + esi * 4]
    ; increase contor
    add esi, 1
    ; 4 = sizeof(int)
    cmp dword [visited + edx * 4], 1
    je loop

    ; if it is not, call dfs 
    push dword [ebp + 12]
    push edx
    call dfs
    ; move stack pointer
    add esp, 8
    jmp loop

end:
    popa
    leave
    ret
