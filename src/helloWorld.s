/*
 * Author: Blocky [https://github.com/Blockky]
 * Session 1, exercise 2
 */

.data
    msg: .ascii "Hello World!\n"
    len = . - msg

    msg2: .ascii "I am from the UAH!\n"
    len2 = . - msg2

.text
.global _start
_start:
    # Print the first message
    movl $4,    %eax
    movl $1,    %ebx
    movl $msg,  %ecx
    movl $len,  %edx
    int $0x80

    # Print the second message
    movl $4,    %eax
    movl $1,    %ebx
    movl $msg2, %ecx
    movl $len2, %edx
    int $0x80

    # Exit program
    movl $1,    %eax
    movl $0,    %ebx
    int $0x80
