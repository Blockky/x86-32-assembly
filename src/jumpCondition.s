/*
 * Author: Blocky [https://github.com/Blockky]
 * Session 3, Exercise 1
 */

.data
    prompt: .ascii "Enter a character (E for Exit):\n"
    prompt_len = . - prompt

    buffer_size = 2                     # 1 character + 1 for newline character
    buffer: .space buffer_size          # stores the user input

.text
.global _start
_start:
    # Print the prompt
    movl $syswrite,     %eax
    movl $stdout,       %ebx
    movl $prompt,       %ecx
    movl $prompt_len,   %edx
    int $syscall

    # Read input from the user
    movl $sysread,      %eax
    movl $stdin,        %ebx
    movl $buffer,       %ecx
    movl $buffer_size,  %edx
    int $syscall

    # If the input is 'E', exit the program;
    # otherwise, print the message and restart the program
    movl $0,    %esi
    movb buffer(%esi),  %al
    cmpb $'E',  %al
    je exit 

    # Print the input back to the screen
    movl $syswrite,     %eax
    movl $stdout,       %ebx
    movl $buffer,       %ecx
    movl $buffer_size,  %edx
    int $syscall

    jmp _start

exit:
    # Exit program
    movl $sysexit, %eax
    movl $success, %ebx
    int $syscall

/* Constants */
syswrite   = 4
sysread    = 3
sysexit    = 1
syscall    = 0x80
stdin      = 0
stdout     = 1
success    = 0
