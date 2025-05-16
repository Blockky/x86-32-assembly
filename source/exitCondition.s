.global _start
syscall = 0x80
sysexit = 1
success = 0
sysread = 3
syswrite = 4
stdin = 0
stdout = 1

.data
    msg: .ascii "\nWrite a character (S for Exit): "
    len = . - msg

    size = 2
    buffer: .space size

.text
_start:
    /* Print msg */
    movl $syswrite, %EAX
    movl $stdout,   %EBX
    movl $msg,      %ECX
    movl $len,      %EDX
    int $syscall

    /* Read the input character */
    movl $sysread,  %EAX
    movl $stdin,    %EBX
    movl $buffer,   %ECX
    movl $size,     %EDX
    int $syscall

    /* Compare the character read with 'S' */
    movb buffer,    %AL
    cmpb $'S',      %AL     # does the subtraction AL - 's' (but only updates the flags [status register])
    jz exit     # jump to label exit if the last operation resulted in zero (if ZF = 1)

    /* Print the character read */
    movl $syswrite, %EAX
    movl $stdout,   %EBX
    movl $buffer,   %ECX
    movl $size,     %EDX
    int $syscall

    jmp _start  # jump to label _start

exit:
    /* Exit the program */
    movl $sysexit,  %EAX
    movl $success,  %EBX
    int $syscall
