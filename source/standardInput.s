.global _start
syscall = 0x80
sysexit = 1
success = 0
sysread = 3
syswrite = 4
stdin = 0
stdout = 1

.data
    size = 21
    buffer: .space size

.text
_start:
    /* Read the input */
    movl $sysread,  %EAX
    movl $stdin,    %EBX
    movl $buffer,   %ECX
    movl $size,     %EDX
    int $syscall

    /* Print the string read */
    movl %EAX,      %EDX    # EAX has the number of bytes read
    movl $syswrite, %EAX
    movl $stdout,   %EBX
    movl $buffer,   %ECX
    int $syscall

    /* Exit the program */
    movl $sysexit,  %EAX
    movl $success,  %EBX     
    int $syscall
