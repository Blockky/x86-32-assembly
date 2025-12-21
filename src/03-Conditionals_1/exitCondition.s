/*
 * Author: Blocky [https://github.com/Blockky]
 * Session 3, Exercise 1
 */

.data
    prompt: .ascii "Enter a character (E for Exit):\n"
    prompt_l = . - prompt

    buffer_s = 2
    buffer: .space buffer_s

.text
.global _start
_start:
    # Print the prompt
    movl $WRITE,    %eax
    movl $STDOUT,   %ebx
    movl $prompt,   %ecx
    movl $prompt_l, %edx
    int $0x80

    # Read input from the user
    movl $READ,     %eax
    movl $STDIN,    %ebx
    movl $buffer,   %ecx
    movl $buffer_s, %edx
    int $0x80

    # If the input is 'E', exit the program;
    # otherwise, print the message and restart the program
    movb buffer,    %al
    cmpb $'E',      %al
    je exit 

    # Print the input back to the standard output
    movl $WRITE,    %eax
    movl $STDOUT,   %ebx
    movl $buffer,   %ecx
    movl $buffer_s, %edx
    int $0x80

    jmp _start

exit:
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
