/*
 * Author: Blocky [https://github.com/Blockky]
 * Session 2, exercise 1
 */

.data
    buffer_s = 21
    buffer: .space buffer_s

.text
.global _start
_start:
    # Read input from user
    movl $READ,     %eax
    movl $STDIN,    %ebx
    movl $buffer,   %ecx
    movl $buffer_s, %edx
    int $0x80

    # Store number of bytes read in %edx
    movl %eax,      %edx

    # Print the input back to the standard output
    movl $WRITE,    %eax
    movl $STDOUT,   %ebx
    movl $buffer,   %ecx
    int $0x80

    movl $EXIT,     %eax
    movl $SUCCESS,  %ebx
    int $0x80

# CONSTANTS
WRITE = 4
READ = 3
EXIT = 1
STDIN = 0
STDOUT = 1
SUCCESS = 0
