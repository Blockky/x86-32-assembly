.global _start
syscall = 0x80
sysexit = 1
success = 0
sysread = 3
syswrite = 4
stdin = 0
stdout = 1
lowermask = 0x20    # mask to lowercase an ASCII character
uppermask = 0xDF    # mask to uppercase an ASCII character
togglemask = 0x20   # mask to toggle the size an ASCII character
LF = 10

.data
    msg: .ascii "Write a string of no more than 20 characters (without numbers or symbols):\n"
    len = . - msg
    msg2: .ascii "\nModified strings:\n"
    len2 = . - msg2

    size = 21
    buffer: .space size
    bufupper: .space size
    buflower: .space size
    buftoggle: .space size

.text
_start:
    /* Print msg */
    movl $syswrite, %EAX
    movl $stdout,   %EBX
    movl $msg,      %ECX
    movl $len,      %EDX
    int $syscall

    /* Read the input */
    movl $sysread,  %EAX
    movl $stdin,    %EBX
    movl $buffer,   %ECX
    movl $size,     %EDX
    int $syscall

    /* Initialize a loop to process the characters */
    movl %EAX,  %ECX    # the loop would iterate based on the number of bytes read
    decl %ECX           # the last char (\n) is not taken
    movl $0,    %ESI    # index to access a buffer position

case:
    /* Lowercase the string */
    movb buffer(%ESI),  %AL     # actual character
    orb $lowermask,     %AL     # process the character
    movb %AL, buflower(%ESI)    # store the processed character in buflower

    /* Uppercase the string */
    movb buffer(%ESI),  %AL
    andb $uppermask,    %AL
    movb %AL, bufupper(%ESI)

    /* Toggle character size */
    movb buffer(%ESI),  %AL
    xorb $togglemask,   %AL     
    movb %AL, buftoggle(%ESI)

    incl %ESI   # updates the index
    loop case   # repeats the section case

    /* Add a line feed to the end of the processed strings */
    movb $LF, buflower(%ESI)
    movb $LF, bufupper(%ESI)
    movb $LF, buftoggle(%ESI)

    /* Print the processed strings */
    movl $stdout,   %EBX
    movl $size,     %EDX
    
    movl $syswrite, %EAX
    movl $buflower, %ECX
    int $syscall

    movl $syswrite, %EAX
    movl $bufupper, %ECX
    int $syscall

    movl $syswrite,     %EAX
    movl $buftoggle,    %ECX
    int $syscall

    /* Exit the program */
    movl $sysexit,  %EAX
    movl $success,  %EBX     
    int $syscall
