/*
 * Author: Blocky [https://github.com/Blockky]
 * Session 1, exercise 1
 */

.data
    msg: .string "Hello World!\n"
    len = . - msg

.text
.global _start
_start:
    movl $4,   %eax     # write()
    movl $1,   %ebx     # int fd
    movl $msg, %ecx     # const char *buf
    movl $len, %edx     # size_t count
    int $0x80           # kernel syscall

    movl $1, %eax       # exit()
    movl $0, %ebx       # int status
    int $0x80
    