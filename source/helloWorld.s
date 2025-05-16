.global _start
syscall = 0x80
sysexit = 1
success = 0
syswrite = 4
stdout = 1

.data
    msg: .ascii "Hello World!\n"
    len = . - msg   # calculates the length of msg (number of bytes)

    msg2: .ascii "I am from the UAH!\n"
    len2 = . - msg2

.text
_start:
    /* Print msg */
    movl $syswrite, %EAX
    movl $stdout,   %EBX
    movl $msg,      %ECX
    movl $len,      %EDX
    int $syscall

    /* Print msg2 */
    movl $syswrite, %EAX
    movl $stdout,   %EBX
    movl $msg2,     %ECX
    movl $len2,     %EDX
    int $syscall

    /* Exit the program */
    movl $sysexit,  %EAX
    movl $success,  %EBX     
    int $syscall
