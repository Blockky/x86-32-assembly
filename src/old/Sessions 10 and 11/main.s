/*
 * Author: Blocky [https://github.com/Blockky]
 * Session 10 & 11, main program
 */

.data
    flen: .asciz "strlen"
    fcpy: .asciz "strcpy"
    fcat: .asciz "strcat"
    fchr: .asciz "strchr"
    fcmp: .asciz "strcmp"
    fstr: .asciz "strstr"

    buffer_size = 80
    buffer: .space buffer_size
    sign: .asciz "-"
    newline: .ascii "\n"
    
.text
.global _start
_start:
    popl %eax   # argc
    cmpl $1,    %eax
    jz exit
    movl $0,    %ebx
    popl %eax   # argv[0] = "./main"
    popl %eax   # argv[1] = subroutine
    popl %edi   # argv[2] = first string
    testl %edi, %edi
    jz exit
    popl %esi   # argv[3] = second string

select_flen:
    movb (%eax,%ebx),   %cl
    cmpb %cl,   flen(%ebx)
    jnz select_next
    cmpb $0,    (%eax,%ebx)
    jz str_len
    incl %ebx
    jmp select_flen

select_next:
    testl %esi, %esi
    jz exit
    movl $0,    %ebx

select_fcpy:
    movb (%eax,%ebx),   %cl
    cmpb %cl,   fcpy(%ebx)
    jnz select_next_b
    cmpb $0,    (%eax,%ebx)
    jz str_cpy
    incl %ebx
    jmp select_fcpy

select_next_b:
    movl $0,    %ebx

select_fcat:
    movb (%eax,%ebx),   %cl
    cmpb %cl,   fcat(%ebx)
    jnz select_next_c
    cmpb $0,    (%eax,%ebx)
    jz str_cat
    incl %ebx
    jmp select_fcat

select_next_c:
    movl $0,    %ebx

select_fchr:
    movb (%eax,%ebx),   %cl
    cmpb %cl,   fchr(%ebx)
    jnz select_next_d
    cmpb $0,    (%eax,%ebx)
    jz str_chr
    incl %ebx
    jmp select_fchr

select_next_d:
    movl $0,        %ebx

select_fcmp:
    movb (%eax,%ebx),   %cl
    cmpb %cl,   fcmp(%ebx)
    jnz select_next_e
    cmpb $0,    (%eax,%ebx)
    jz str_cmp
    incl %ebx
    jmp select_fcmp

select_next_e:
    movl $0,    %ebx

select_fstr:
    movb (%eax,%ebx),   %cl
    cmpb %cl,   fstr(%ebx)
    jnz exit
    cmpb $0,    (%eax,%ebx)
    jz str_str
    incl %ebx
    jmp select_fstr

str_len:
    pushl %edi
    call strlen
    addl $4,    %esp
    movl $10,   %ebx
    jmp decode_result

str_cpy:
    pushl %edi
    pushl %esi
    call strcpy
    testl %eax, %eax
    jz exit
    addl $(4*2),    %esp
    jmp print_result

str_cat:
    pushl %edi
    pushl %esi
    call strcat
    testl %eax, %eax
    jz exit
    addl $(4*2),    %esp
    jmp print_result

str_chr:
    pushl %edi
    pushl %esi
    call strchr
    testl %eax,     %eax
    jz exit
    addl $(4*2),    %esp
    movl $16,       %ebx
    jmp decode_result

str_cmp:
    pushl %edi
    pushl %esi
    call strcmp
    addl $(4*2),    %esp
    cmpl $1,        %edx
    jz is_negative
    movl $10,       %ebx
    jmp decode_result

is_negative:
    pushl %eax
    movl $sign,     %eax
    pushl %eax
    call print
    addl $4,        %esp
    popl %eax
    movl $10,       %ebx
    jmp decode_result

str_str:
    pushl %edi
    pushl %esi
    call strstr
    testl %eax,     %eax
    jz exit
    addl $(4*2),    %esp
    movl $16,       %ebx

decode_result:
    movl $buffer,   %ecx
    pushl %eax
    pushl %ecx
    pushl %ebx
    call ultostr
    addl $(4*3),    %esp

print_result:
    pushl %eax
    call print
    addl $4,        %esp

    movl $newline,  %eax
    pushl %eax
    call print

exit:
    movl $sysexit,     %eax
    movl $success, %ebx
    int $syscall

/* Constants */
sysexit    = 1
syscall    = 0x80
success    = 0
