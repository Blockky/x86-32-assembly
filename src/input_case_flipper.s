/*
 * Author: Blocky [https://github.com/Blockky]
 * Session 2, Exercise 2
 */

.data
    prompt: .ascii "Enter a string without numbers or symbols (up to 20 characters):\n"
    prompt_len = . - prompt

    buffer_size = 21                    # 20 characters + 1 for newline character
    buffer: .space buffer_size          # stores the user input
    lower_string: .space buffer_size     # stores lowercase version
    upper_string: .space buffer_size     # stores uppercase version
    toggle_string: .space buffer_size    # stores toggled-case version

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

    # Store number of bytes read
    movl %eax,  %edx        # %edx will be used later
    movl %eax,  %ecx        # use %ecx as loop counter
    decl %ecx               # exclude the newline character
    movl $0,    %esi        # index = 0

switchcase:
    # Convert to lowercase using OR with 2**5 bit
    movb buffer(%esi),  %al
    orb $lowermask,     %al
    movb %al, lower_string(%esi)

    # Convert to uppercase using AND with 2**5 bit
    movb buffer(%esi),  %al
    andb $uppermask,    %al
    movb %al, upper_string(%esi)

    # Toggle case using XOR with 2**5 bit
    movb buffer(%esi),  %al
    xorb $togglemask,   %al
    movb %al, toggle_string(%esi)

    incl %esi
    loop switchcase

    # Append newline characters to the end of each output string
    movb $0xA, lower_string(%esi)
    movb $0xA, upper_string(%esi)
    movb $0xA, toggle_string(%esi)

    # Print the processed strings (%edx has the length)
    movl $stdout,       %ebx

    # Print lowercase string
    movl $syswrite,     %eax
    movl $lower_string, %ecx
    int $syscall

    # Print uppercase string
    movl $syswrite,     %eax
    movl $upper_string, %ecx
    int $syscall

    # Print toggled-case string
    movl $syswrite,      %eax
    movl $toggle_string, %ecx
    int $syscall

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
uppermask  = 0xDF   # clears bit 2**5 (makes character uppercase)
togglemask = 0x20   # toggles bit 2**5 (switches case)
