/*
 * Author: Blocky [https://github.com/Blockky]
 * Session 8, Exercise 1
 */

.data
    number: .asciz "A67B"

    prompt: .ascii "Enter the base of the number (between 2 and 16):\n"
    prompt_len = . - prompt

    buffer_size = 3
    buffer: .space buffer_size

    letter_code = 'A' - 10

.text
.global _start
_start:
    # Print the prompt
    movl $syswrite,     %eax
    movl $stdout,       %ebx
    movl $prompt,       %ecx
    movl $prompt_len,   %edx
    int $syscall

    # Read input from user
    movl $sysread,      %eax
    movl $stdin,        %ebx
    movl $buffer,       %ecx
    movl $buffer_size,  %edx
    int $syscall

    movl $buffer,  %ebx
    movl $10,      %eax

    pushl %ebx      # char* number
    pushl %eax      # int base
    call strtoul2   # it returns the encoded int in eax

    addl $(2*4),    %esp

    movl $number,   %ebx

    pushl %ebx      # char* number
    pushl %eax      # int base
    call strtoul2

    addl $(2*4),    %esp

    # Exit program
    movl $sysexit,  %eax
    movl $success,  %ebx
    int $syscall

#----------------------------------------------------------------
# int strtoul2(char*, int)
# Converts a string in a specific base to an unsigned long int
# Returns 0xFFFFFFFF in case of error
#----------------------------------------------------------------
.type strtoul2, @function
.global strtoul2
strtoul2:
    push %ebp           
    movl %esp,  %ebp

    pushl %ebx
    pushl %ecx
    pushl %edx
    pushl %edi
    pushl %esi

    movl 8(%ebp),   %edi    # int base
    movl 12(%ebp),  %ebx    # char* number

    movl $0,        %eax
    movl $0,        %esi
    movl $0,        %edx

    # Check if the base is between 2 and 16
    cmpl $16,   %edi
    ja encode_error2
    cmpl $2,    %edi
    jb encode_error2

encode2:
    # Check if the character is NULL or \n
    movb (%ebx, %esi), %cl
    cmpb $0,           %cl
    jz exit_strtoul2
    cmpb $10,          %cl
    jz exit_strtoul2

    # Check if the character is a number or a letter
    movl %edi,        %edx
    cmpb $'0',         %cl
    jb encode_error2
    cmpb $'9',         %cl
    ja check_letter

check_number:
    addb $'0',      %DL
    cmpb %DL,       %cl
    jae encode_error2

    # Encode the number
    andl $encodermask,  %ecx
    mull %edi
    jc encode_error2
    addl %ecx,      %eax
    jc encode_error2
    incl %esi
    jmp encode2

check_letter:
    cmpl $9,       %edi
    jbe encode_error2
    cmpb $'A',      %cl
    jb encode_error2
    cmpb $'F',      %cl
    ja encode_error2
    addb $letter_code,      %DL
    cmpb %DL,       %cl
    jae encode_error2
    
    # Encode the letter
    subb $'A',      %cl
    addb $10,       %cl
    mull %edi
    jc encode_error2
    addl %ecx,      %eax
    jc encode_error2
    incl %esi
    jmp encode2

encode_error2:
    movl $-1,       %eax

exit_strtoul2:
    popl %ebx
    popl %ecx
    popl %edx
    popl %edi
    popl %esi
    leave
    ret

/* Constants */
sysexit     = 1
syscall     = 0x80
success     = 0
encodermask = 0x0F
syswrite    = 4
sysread     = 3
stdout      = 1
stdin       = 0
