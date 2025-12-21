/*
 * Author: Blocky [https://github.com/Blockky]
 * Session 2, exercise 2
 */

.data
    prompt: .ascii "Enter a string without numbers or symbols (up to 20 characters):\n"
    prompt_l = . - prompt

    buffer_s = 21               # 20 characters + 1 for newline character
    buffer: .space buffer_s         # stores the user input
    lower_str: .space buffer_s      # stores lowercase version
    upper_str: .space buffer_s      # stores uppercase version
    toggle_str: .space buffer_s     # stores toggled-case version

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

    # Store number of bytes read
    movl %eax,  %edx        # %edx will be used later
    movl %eax,  %ecx        # use %ecx as loop counter
    decl %ecx               # exclude the line feed '\n' character
    movl $0,    %esi        # index = 0

switchcase:
    # Convert to lowercase using OR with 2**5 bit
    movb buffer(%esi),  %al
    orb $LOWERMASK,     %al
    movb %al, lower_str(%esi)

    # Convert to uppercase using AND with 2**5 bit
    movb buffer(%esi),  %al
    andb $UPPERMASK,    %al
    movb %al, upper_str(%esi)

    # Toggle case using XOR with 2**5 bit
    movb buffer(%esi),  %al
    xorb $TOGGLEMASK,   %al
    movb %al, toggle_str(%esi)

    incl %esi
    loop switchcase

    # Append a line feed to the end of each output string
    movb $0xA, lower_str(%esi)
    movb $0xA, upper_str(%esi)
    movb $0xA, toggle_str(%esi)

    # Print the processed strings (%edx has the length)
    movl $STDOUT,       %ebx

    # Print lowercase string
    movl $WRITE,     %eax
    movl $lower_str, %ecx
    int $0x80

    # Print uppercase string
    movl $WRITE,     %eax
    movl $upper_str, %ecx
    int $0x80

    # Print toggled-case string
    movl $WRITE,      %eax
    movl $toggle_str, %ecx
    int $0x80

    movl $EXIT,    %eax
    movl $SUCCESS, %ebx
    int $0x80

# CONSTANTS
LOWERMASK = 0x20   # 0b00100000
UPPERMASK = 0xDF   # 0b11011111
TOGGLEMASK = 0x20  # 0b00100000

WRITE = 4
READ = 3
EXIT = 1
STDIN = 0
STDOUT = 1
SUCCESS = 0
