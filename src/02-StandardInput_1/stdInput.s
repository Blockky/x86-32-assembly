/*
 * Author: Blocky [https://github.com/Blockky]
 * Session 2, exercise 1
 */

.data
    size = 21
    buffer: .space size

.text
.global _start
_start:
    movl $READ,   %eax
    movl $STDIN,  %ebx
    movl $buffer, %ecx
    movl $size,   %edx
    int $0x80

    movl %eax,    %edx
    movl $WRITE,  %eax
    movl $STDOUT, %ebx
    movl $msg,    %ecx
    int $0x80

    movl $EXIT,    %eax
    movl $SUCCESS, %ebx
    int $0x80

# CONSTANTS
WRITE = 4
READ = 3
EXIT = 1
STDIN = 0
STDOUT = 1
SUCCESS = 0
