/*
 * Author: Blocky [https://github.com/Blockky]
 * Session 4, Exercise 1
 */

.data
    name_prompt: .ascii "Write the name (up to 10 characters):\n"
    name_len = . - name_prompt
    age_prompt: .ascii "Write the age (up to 10 characters):\n"
    age_len = . - age_prompt
    final_prompt: .ascii "Want to add a new record? (E for Exit / ENTER for continue): "
    final_len = . - final_prompt

    buffer_size = 11
    name_buffer: .space buffer_size
    age_buffer: .space buffer_size
    buf_end_char: .space buffer_size

    filename: .asciz "./personal.txt"   # the file path must end with a NULL character (\0)
    flags = O_WRONLY | O_APPEND | O_CREAT   # sets the file access modes
    umode_t = rw_rw_rw      # creation access permissions (only needed with the O_CREAT flag)

.text
.global _start
_start:
    # Open/create the file personal.txt
    movl $sysopen,  %eax
    movl $filename, %ebx
    movl $flags,    %ecx
    movl $umode_t,  %edx
    int $syscall

    # Save the file descriptor in %edi
    movl %eax,  %edi

beginning:
    # Print the first prompt
    movl $syswrite,     %eax
    movl $stdout,       %ebx
    movl $name_prompt,  %ecx
    movl $name_len,     %edx
    int $syscall

    # Read input name
    movl $sysread,      %eax
    movl $stdin,        %ebx
    movl $name_buffer,  %ecx
    movl $buffer_size,  %edx
    int $syscall

    # Write the name + tab (\t) in personal.txt
    movl %eax,  %edx
    decl %eax
    movb $'\t', name_buffer(%eax)
    movl $syswrite,     %eax
    movl %edi,          %ebx
    movl $name_buffer,  %ecx
    int $syscall

    # Print the second prompt
    movl $syswrite,     %eax
    movl $stdout,       %ebx
    movl $age_prompt,   %ecx
    movl $age_len,      %edx
    int $syscall

    # Read input age
    movl $sysread,      %eax
    movl $stdin,        %ebx
    movl $age_buffer,   %ecx
    movl $buffer_size,  %edx
    int $syscall

    # Write the age + new line (\n) in personal.txt
    movl %eax,  %edx
    decl %eax
    movb $'\n', age_buffer(%eax)
    movl $syswrite,     %eax
    movl %edi,          %ebx
    movl $age_buffer,   %ecx
    int $syscall

final:
    # Print the final prompt
    movl $syswrite,     %eax
    movl $stdout,       %ebx
    movl $final_prompt, %ecx
    movl $final_len,    %edx
    int $syscall

    # Read final input
    movl $sysread,      %eax
    movl $stdin,        %ebx
    movl $buf_end_char, %ecx
    movl $buffer_size,  %edx
    int $syscall

    cmpl $2,    %eax
    ja final
    movl $0,    %esi
    movb buf_end_char(%esi), %al
    cmpb $'E',  %al
    je exit
    movl $buffer_size,  %ecx
    cmpb $'\n',  %al
    je continue
    jmp final

continue:
    movb $0,    age_buffer(%esi)
    movb $0,    name_buffer(%esi)
    incl %esi
    loop continue
    jmp beginning
    
exit:
    # Close file personal.txt
    movl $sysclose, %eax
    movl %edi,      %ebx
    int $syscall

    # Exit program
    movl $sysexit, %eax
    movl $success, %ebx
    int $syscall

/* Constants */
sysopen    = 5
sysclose   = 6
syswrite   = 4
sysread    = 3
sysexit    = 1
syscall    = 0x80
stdin      = 0
stdout     = 1
success    = 0
O_WRONLY   = 01         # 0000 0000 0001
O_CREAT    = 0100       # 0000 0100 0000
O_APPEND   = 02000      # 0100 0000 0000
rw_rw_rw   = 0666       # 0110-0110-0110 = rw-rw-rw
