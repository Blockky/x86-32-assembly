/*
 * Author: Blocky [https://github.com/Blockky]
 * Session 3, Exercise 2
 */

.data
    prompt: .ascii "Enter a string (up to 20 characters) [E for Exit]:\n"
    prompt_l = . - prompt

    buffer_s = 21
    buffer: .space buffer_s
    lower_str: .space buffer_s

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

    # Store number of bytes read in %edx
    movl %eax,  %edx

    # If the input is 'E', exit the program;
    # otherwise, lowercase and print the message and restart the program
    movl $0,     %esi
    movb buffer, %al
    cmpb $'E',   %al
    jne lowercase
    cmpl $2,     %edx
    je _exit

lowercase:
    # Convert to lowercase using OR with 2**5 bit
    movb buffer(%esi), %al
    cmpb $'\n',        %al
    jz print
    orb $LOWERMASK,    %al
    movb %al, lower_str(%esi)
    incl %esi
    jmp lowercase

print:
    # Append a line feed to the end of the output string
    movb $0xA, lower_str(%esi)

    # Print lowercase string
    movl $WRITE,     %eax
    movl $STDOUT,    %ebx
    movl $lower_str, %ecx
    int $0x80

    # Clear buffers
    movl $buffer_s,  %ecx
    movl $0,    %esi

clear:
    movb $0,    buffer(%esi)
    movb $0,    lower_str(%esi)
    incl %esi
    loop clear
    jmp _start

_exit:
    movl $EXIT,    %eax
    movl $SUCCESS, %ebx
    int $0x80

# CONSTANTS
LOWERMASK = 0x20   # 0b00100000

WRITE = 4
READ = 3
EXIT = 1
STDIN = 0
STDOUT = 1
SUCCESS = 0
