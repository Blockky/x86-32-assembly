/*
 * Author: Blocky [https://github.com/Blockky]
 * Session 2, Exercise 1
 */

.data
    prompt: .ascii "Write a string (max 20 characters):\n"
    prompt_len = . - prompt

    buffer_size = 21               # 20 characters + 1 for newline character
    buffer: .space buffer_size     # buffer to store the input string

.text
.global _start
_start:
    # Print the prompt message
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

    # Store number of bytes read in %edx
    movl %eax, %edx

    # Echo the input back to stdout
    movl $syswrite, %eax
    movl $stdout,   %ebx
    movl $buffer,   %ecx
    int $syscall

    # Exit program
    movl $sysexit, %eax
    movl $success, %ebx
    int $syscall

/* Constants */
syswrite = 4
sysread  = 3
sysexit  = 1
syscall  = 0x80
stdin    = 0
stdout   = 1
success  = 0
