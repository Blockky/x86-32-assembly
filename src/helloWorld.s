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
    /* Print the first message */
    movl $4,    %eax    # sys write
    movl $1,    %ebx    # standard output
    movl $msg,  %ecx    # msg address
    movl $len,  %edx    # msg length
    int $0x80           # sys call

    /* Print the second message */
    movl $4,    %eax
    movl $1,    %ebx
    movl $msg2, %ecx
    movl $len2, %edx
    int $0x80

    /* Exit the program */
    movl $1,    %eax    # sys exit
    movl $0,    %ebx    # exit error code
    int $0x80
