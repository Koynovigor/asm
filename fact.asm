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
        call .fact
        call .write

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

.fact:
    mov edx, [esp+4]
    cmp edx, 0
    jz .n
        cmp edx, 1
        jz .v
            xor edx, edx
            mov ecx, b
            mov eax, [esp+8]
            mov ebx, 2
            .e:
                mov edi, eax
                div ebx
                cmp edx, 0
                jnz .r
                    mov [esp-4], eax
                    mov [esp-8], ebx
                    mov [esp-12], edx
                    mov [esp-16], edi
                    mov [esp-20], ecx
                    mov eax, ebx
                    mov ebx, 10
                    xor edi, edi
                    mov ecx, c
                    .y:
                        xor edx, edx
                        div ebx
                        add edx, '0'
                        mov [ecx], dl
                        inc ecx
                        inc edi
                        cmp eax, 0
                    jnz .y
                    mov [esp-24], edi
                    mov eax, ecx
                    dec eax
                    mov ecx, [esp-20]
                    .h:
                        mov bl, [eax]
                        mov [ecx], bl
                        dec eax
                        inc ecx
                        dec edi
                        cmp edi, 0
                    jnz .h
                    mov edi, [esp-24]
                    mov ecx, [esp-20]
                    add ecx, edi
                    mov eax, [esp-4]
                    mov ebx, [esp-8]
                    mov edx, [esp-12]
                    mov edi, [esp-16]
                    mov byte [ecx], '*'
                    inc ecx
                jmp .w
                .r:
                mov eax, edi
                inc ebx
                xor edx, edx
                .w:
                cmp eax, 1
            jnz .e
            mov byte [ecx-1], 0xa
        .v:
        jmp .m
    .n:
    mov eax, 4
    mov ebx, 1
    mov ecx, e
    mov edx, len1
    int 0x80
        .m:
ret

.write:
    mov eax, 4
    mov ebx, 1
    mov ecx, b
    mov edx, 1024
    int 0x80
ret
