/*
 * Author: Blocky [https://github.com/Blockky]
 * Session 8, Exercise 1
 */

.data
    number: .asciz "A67B"

    prompt: .ascii "Enter the base of the number (between 2 and 16):\n"
    prompt_l = . - prompt

    buffer_s = 3
    buffer: .space buffer_s

    letter_code = 'A' - 10

.text
.global _start
_start:
    # Print the prompt
    movl $WRITE,    %eax
    movl $STDOUT,   %ebx
    movl $prompt,   %ecx
    movl $prompt_l, %edx
    int $0x80

    # Read input from user
    movl $READ,     %eax
    movl $STDIN,    %ebx
    movl $buffer,   %ecx
    movl $buffer_s, %edx
    int $0x80

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

    addl $(2*4), %esp

    cmpl $-1,    %eax
    jz exit_failure

    movl $SUCCESS, %ebx
    jmp _exit

exit_failure:
    movl $FAILURE, %ebx
    
_exit:
    movl $EXIT, %eax
    int $0x80

#----------------------------------------------------------------
# int strtoul2(char*, int)
# Converts a string in a specific base to an unsigned long int
# Returns -1 in case of error
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

    movl 8(%ebp),  %edi    # int base
    movl 12(%ebp), %ebx    # char* number

    xorl %eax, %eax
    xorl %esi, %esi
    xorl %edx, %edx

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
    andl $ENCODERMASK, %ecx
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

# CONSTANTS
EXIT = 1
WRITE = 4
READ = 3
STDIN = 0
STDOUT = 1
SUCCESS = 0
FAILURE = -1
ENCODERMASK = 0x0F
