/*
 * Author: Blocky [https://github.com/Blockky]
 * Session 5, Exercise 1
 */

.text
.global _start
_start:
    # Retrieve the number of arguments (argc)
    popl %ecx

beggining:
    # Retrieve the address of the next argument (argv[i])
    popl %ebx

    # The program would not print more than 9 arguments
    incl %esi
    cmpl $9,     %esi
    ja exit

    # If the argument is NULL (0), jump to label exit
    testl %ebx,  %ebx
    jz exit

    # Count the number of characters
    movl %ebx,  %edi
    movl $0,    %eax
    movl $0,    %edx

count:
    cmpb $0,    (%edi)
    jz print
    incl %edi
    incl %edx
    jmp count

print:
    # Add a line feed at the end of the argument and print it
    incl %edx
    movb $10,   (%edi)
    movl %ebx,      %ecx
    movl $syswrite, %eax
    movl $stdout,   %ebx
    int $syscall

    jmp beggining

exit:
    # Exit program
    movl $sysexit,  %eax
    movl $success,  %ebx
    int $syscall

/* Constants */
syswrite   = 4
sysexit    = 1
syscall    = 0x80
stdout     = 1
success    = 0
