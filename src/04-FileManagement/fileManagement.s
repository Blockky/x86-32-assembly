/*
 * Author: Blocky [https://github.com/Blockky]
 * Session 4, Exercise 1
 */

.data
    name_p: .ascii "Write the name (up to 10 characters):\n"
    name_l = . - name_p
    age_p: .ascii "Write the age (up to 10 characters):\n"
    age_l = . - age_p
    final_p: .ascii "Want to add a new record? (E for Exit / ENTER for continue): "
    final_l = . - final_p

    buffer_s = 11
    name_b: .space buffer_s
    age_b: .space buffer_s
    buf_end_char: .space buffer_s

    filename: .asciz "./personal.txt"   # the file path must end with a NULL character (\0)
    flags = O_WRONLY | O_APPEND | O_CREAT   # sets the file access modes
    umode_t = 0666      # creation access permissions (only needed with the O_CREAT flag)

.text
.global _start
_start:
    # Open/create the file personal.txt
    movl $OPEN,     %eax
    movl $filename, %ebx
    movl $flags,    %ecx
    movl $umode_t,  %edx
    int $0x80

    # Save the file descriptor in %edi
    movl %eax,  %edi

beginning:
    # Print the first prompt
    movl $WRITE,  %eax
    movl $STDOUT, %ebx
    movl $name_p, %ecx
    movl $name_l, %edx
    int $0x80

    # Read input name
    movl $READ,     %eax
    movl $STDIN,    %ebx
    movl $name_b,   %ecx
    movl $buffer_s, %edx
    int $0x80

    # Write the name + tab (\t) in personal.txt
    movl %eax,    %edx
    decl %eax
    movb $'\t',   name_b(%eax)
    movl $WRITE,  %eax
    movl %edi,    %ebx
    movl $name_b, %ecx
    int $0x80

    # Print the second prompt
    movl $WRITE,  %eax
    movl $STDOUT, %ebx
    movl $age_p,  %ecx
    movl $age_l,  %edx
    int $0x80

    # Read input age
    movl $READ,     %eax
    movl $STDIN,    %ebx
    movl $age_b,    %ecx
    movl $buffer_s, %edx
    int $0x80

    # Write the age + new line (\n) in personal.txt
    movl %eax,   %edx
    decl %eax
    movb $'\n',  age_b(%eax)
    movl $WRITE, %eax
    movl %edi,   %ebx
    movl $age_b, %ecx
    int $0x80

final:
    # Print the final prompt
    movl $WRITE,   %eax
    movl $STDOUT,  %ebx
    movl $final_p, %ecx
    movl $final_l, %edx
    int $0x80

    # Read final input
    movl $READ,         %eax
    movl $STDIN,        %ebx
    movl $buf_end_char, %ecx
    movl $buffer_s,     %edx
    int $0x80

    cmpl $2,    %eax
    ja final
    movl $0,    %esi
    movb buf_end_char(%esi), %al
    cmpb $'E',  %al
    je exit
    movl $buffer_s,  %ecx
    cmpb $'\n',      %al
    je continue
    jmp final

continue:
    movb $0,    age_b(%esi)
    movb $0,    name_b(%esi)
    incl %esi
    loop continue
    jmp beginning
    
exit:
    # Close file personal.txt
    movl $CLOSE, %eax
    movl %edi,   %ebx
    int $0x80

    movl $EXIT,    %eax
    movl $SUCCESS, %ebx
    int $0x80

# CONSTANTS
O_WRONLY = 01
O_CREAT = 0100
O_APPEND = 02000

OPEN = 5
CLOSE = 6
WRITE = 4
READ = 3
EXIT = 1
STDIN = 0
STDOUT = 1
SUCCESS = 0
