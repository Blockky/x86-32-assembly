/*
 * Author: Blocky [https://github.com/Blockky]
 * Session 6, Exercise 1
 */

.data
    overflow_msg: .ascii "Error, the operation resulted in overflow!\n"
    overflow_len = . - overflow_msg

    negative_msg: .ascii "The result is negative!\n"
    negative_len = . - negative_msg

    positive_msg: .ascii "The result is positive!\n"
    positive_len = . - positive_msg

.text
.global _start
_start:
    # Caller (calls the subroutine addition)
    pushl $32           # 2nd argument
    pushl $128          # 1st argument
    call addition

    # Save the result and clear the arguments
    movl %eax,   %ebx
    addl $(2*4), %esp

    # Check if the result is -1
    cmpl $-1,   %ebx
    jz overflow_case

    # Check if the result is negative
    testl %ebx, %ebx
    js negative_case

positive_case:
    # Print positive_msg
    movl $WRITE,        %eax
    movl $STDOUT,       %ebx
    movl $positive_msg, %ecx
    movl $positive_len, %edx
    int $0x80
    
    jmp _exit

negative_case:
    # Print negative_msg
    movl $WRITE,        %eax
    movl $STDOUT,       %ebx
    movl $negative_msg, %ecx
    movl $negative_len, %edx
    int $0x80

    jmp _exit

overflow_case:
    # Print overflow_msg
    movl $WRITE,        %eax
    movl $STDOUT,       %ebx
    movl $overflow_msg, %ecx
    movl $overflow_len, %edx
    int $0x80

_exit:
    movl $EXIT,    %eax
    movl $SUCCESS, %ebx
    int $0x80

#-------------------------------------------------------------
# int addition(int, int)
# Returns the addition of two int or -1 in case of overflow
#-------------------------------------------------------------
.type addition, @function
.global addition
addition:
    # Callee
    push %ebp           
    movl %esp,      %ebp

    pushl %ebx

    movl 8(%ebp),   %eax
    movl 12(%ebp),  %ebx

    addl %ebx,      %eax
    jno exit_addition
    movl $-1,       %eax

exit_addition:
    popl %ebx
    leave
    ret

# CONSTANTS
WRITE = 4
EXIT = 1
STDOUT = 1
SUCCESS = 0
