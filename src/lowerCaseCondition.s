/*
 * Author: Blocky [https://github.com/Blockky]
 * Session 3, Exercise 2
 */

.data
    prompt: .ascii "Enter a string (up to 20 characters) [E for Exit]:\n"
    prompt_len = . - prompt

    buffer_size = 21                    # 20 characters + 1 for newline character
    buffer: .space buffer_size          # stores the user input
    lowerstring: .space buffer_size     # stores lowercase version

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

    # Store number of bytes read in %edx
    movl %eax,  %edx

    # If the input is 'E', exit the program;
    # otherwise, lowercase and print the message and restart the program
    movl $0,    %esi
    movb buffer,    %al
    cmpb $'E',      %al
    jne lowercase
    cmpl $2,    %edx
    je exit

lowercase:
    # Convert to lowercase using OR with 2**5 bit
    movb buffer(%esi),  %al
    cmpb $'\n',         %al
    jz print
    orb $lowermask,     %al
    movb %al, lowerstring(%esi)
    incl %esi
    jmp lowercase

print:
    # Append newline character to the end of the output string
    movb $0xA, lowerstring(%esi)

    # Print lowercase string
    movl $syswrite,     %eax
    movl $stdout,       %ebx
    movl $lowerstring,  %ecx
    int $syscall

    # Empty buffers
    movl $buffer_size,  %ecx
    movl $0,    %esi

clear:
    movb $0,    buffer(%esi)
    movb $0,    lowerstring(%esi)
    incl %esi
    loop clear
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
lowermask  = 0x20   # sets bit 2**5 (makes character lowercase)
