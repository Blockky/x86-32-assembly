/*
 * Author: Blocky [https://github.com/Blockky]
 * Session 7, Exercise 1
 */

.data
    number: .asciz "1256"

.text
.global _start
_start:
    movl $number,   %ebx

    pushl %ebx      # char* number
    call strtoul
    
    addl $4,    %esp

    # Exit program
    movl $sysexit,  %eax
    movl $success,  %ebx
    int $syscall

#---------------------------------------------
# int strtoul(char*)
# Converts a string to an unsigned long int
# Returns 0xFFFFFFFF in case of error
#---------------------------------------------  
.type strtoul, @function
.global strtoul
strtoul:
    push %ebp           
    movl %esp,  %ebp

    pushl %ebx
    pushl %ecx
    pushl %edi
    pushl %esi

    movl 8(%ebp),   %ebx    # char* number
    movl $10,       %edi

encode:
    # Check if the character is NULL
    movb (%ebx, %esi), %cl
    cmpb $0,           %cl
    jz exit_strtoul

    # Check if the character is a number
    cmpb $'9',  %cl
    ja encode_error
    cmpb $'0',  %cl
    jb encode_error

    # Encode the number
    andl $encodermask,  %ecx
    mull %edi
    jc encode_error
    addl %ecx,  %eax
    jc encode_error
    incl %esi
    jmp encode

encode_error:
    movl $-1,   %eax

exit_strtoul:
    popl %ebx
    popl %ecx
    popl %edi
    popl %esi
    leave
    ret

/* Constants */
sysexit     = 1
syscall     = 0x80
success     = 0
encodermask = 0x0F
