/*
 * Author: Blocky [https://github.com/Blockky]
 * Session 11, main program
 */

.text
.global _start
_start:
    popl %eax   # argc
    cmpl $2, %eax
    jle _exit
    popl %eax   # argv[0] ./cstrings
    popl %edi   # argv[1] "destiny str"
    popl %esi   # argv[2] "source str"
    
    pushl %edi
    pushl %esi
    # call strcmp
    call strstr
    addl $(4*2), %esp

_exit:
    movl $EXIT,    %eax
    movl $SUCCESS, %ebx
    int $0x80

# CONSTANTS
EXIT = 1
SUCCESS = 0
