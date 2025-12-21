/*
 * Author: Blocky [https://github.com/Blockky]
 * Session 1, exercise 2
 */

.data
    msg1: .ascii "Hello World!\n"
    len1 = . - msg1
    msg2: .ascii "I'm from the UAH!\n"
    len2 = . - msg2

.text
.global _start
_start:
    # Print the first message
    movl $WRITE,  %eax
    movl $STDOUT, %ebx
    movl $msg1,   %ecx
    movl $len1,   %edx
    int $0x80

    # Print the second message
    movl $WRITE,  %eax
    movl $STDOUT, %ebx
    movl $msg2,   %ecx
    movl $len2,   %edx
    int $0x80

    # Exit program
    movl $EXIT,    %eax
    movl $SUCCESS, %ebx
    int $0x80
    
# CONSTANTS
WRITE = 4
EXIT = 1
STDOUT = 1
SUCCESS = 0
