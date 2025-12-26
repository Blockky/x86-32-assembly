/*
 * Author: Blocky [https://github.com/Blockky]
 * Session 10, main program
 */

.text
.global _start
_start:
    popl %eax   # argc
    cmpl $1, %eax
    jz _exit
    popl %eax   # argv[0] ./cstrings
    popl %edi   # argv[1] "destiny str"
    popl %esi   # argv[2] "source str"
    
    pushl %edi
    call strlen
    
    addl $4, %esp

    # pushl %esi
    # call strlen
    # call strcat
    # call strchr
    # addl $(4*2), %esp

_exit:
    movl $EXIT,    %eax
    movl $SUCCESS, %ebx
    int $0x80

# CONSTANTS
EXIT = 1
SUCCESS = 0
