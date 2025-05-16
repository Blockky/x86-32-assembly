.global _start
syscall = 0x80
sysexit = 1
success = 0
syswrite = 4
stdout = 1

.text
_start:
    popl %ECX   # retrieve the number of arguments (argc)

start:
    popl %EBX   # retrieve the address of the next argument (argv[i])

    /* The program would not print more than 9 arguments */
    incl %ESI
    cmpl $9,     %ESI
    ja exit

    testl %EBX,  %EBX
    jz exit     # if the argument is NULL (0), jump to label exit

    /* Count the number of characters */
    movl %EBX,  %EDI
    movl $0,    %EAX
    movl $0,    %EDX

count:
    cmpb $0,    (%EDI)
    jz print
    incl %EDI
    incl %EDX   # the count is saved in EDX
    jmp count

print:
    incl %EDX
    movb $10,   (%EDI)   # add a line feed at the end of the argument

    /* Print the argument */
    movl %EBX,      %ECX
    movl $syswrite, %EAX
    movl $stdout,   %EBX
    int $syscall

    jmp start

exit:
    /* Exit the program */
    movl $sysexit,  %EAX
    movl $success,  %EBX
    int $syscall
