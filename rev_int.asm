section .data
    d db 'Введите число и в конце ОБЯЗАТЕЛЬНО нажмите enter', 0xa
    len equ $-d
    e db 'Вы ввели слишком большое число', 0xa
    len1 equ $-e

section .bss
    a resb 100
    b resb 1024
    c resb 100

section .text
    global _start
    _start:
        mov eax, 4
        mov ebx, 1
        mov ecx, d
        mov edx, len
        int 0x80

        call .read
        call .translation_1
        
        call .int_rev
        
        mov eax, 4
        mov ebx, 1
        mov ecx, b
        mov edx, 1024
        int 0x80

    mov eax, 1
    xor ebx, ebx
    int 0x80

.read:
    mov eax, 3
    mov ebx, 0
    mov ecx, a
    mov edx, 100
    int 0x80
    mov [esp+4], eax
ret

.translation_1:
    mov ebx, 10
    mov ecx, [esp+4]
    cmp ecx, 0
    jz .k
        dec ecx
        cmp ecx, 0
        jz .k
            mov esi, a
            xor eax, eax
            .q:
                mul ebx
                jc .b
                mov dl, [esi]
                sub dl, '0'
                add eax, edx
                inc esi
            loop .q
            mov [esp+8], eax
        jmp .k
        .b:
        mov eax, 0
        mov [esp+4], eax
    .k:
ret

.int_rev:
   mov eax, [esp+8]
   mov ecx, b
   mov ebx, 10
    .y:
        xor edx, edx
        div ebx
        add edx, '0'
        mov [ecx], dl
        inc ecx
        cmp eax, 0
    jnz .y
ret
