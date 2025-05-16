.global _start
syscall = 0x80
sysexit = 1
success = 0
sysread = 3
syswrite = 4
sysopen = 5
sysclose = 6
stdin = 0
stdout = 1
O_WRONLY = 00001    # flag to accesd a file in write-only mode
O_CREAT = 00100     # flag to accesd a file in create mode (creates the file if it does not exist)
O_APPEND = 02000    # flag to accesd a file in append mode
rw_rw_rw = 0666     # code that gives read and write permission to all users

.data
    name_msg: .ascii "Write the name (maximum characters: 10):\n"
    name_len = . - name_msg
    age_msg: .ascii "Write the age (maximum characters: 10):\n"
    age_len = . - age_msg
    final_msg: .ascii "Want to add a new record? (s for exit / ENTER for continue): "
    final_len = . - final_msg

    tab: .ascii "\t"
    newline: .ascii "\n"

    size = 11
    bufname: .space size
    bufage: .space size

    charSize = 2
    bufEndChar: .space charSize

    filename: .asciz "./personal.txt"   # the file path must end with a NULL character (\0)

    flags = O_WRONLY | O_APPEND | O_CREAT   # sets the file access modes
    umode_t = rw_rw_rw      # creation access permissions (only needed with the O_CREAT flag)

.text
_start:
    /* Open/create the file personal.txt */
    movl $sysopen,  %EAX
    movl $filename, %EBX
    movl $flags,    %ECX
    movl $umode_t,  %EDX
    int $syscall

    movl %EAX,      %EDI    # save the file descriptor in EDI

start:
    /* Print name_msg */
    movl $syswrite, %EAX
    movl $stdout,   %EBX
    movl $name_msg, %ECX
    movl $name_len, %EDX
    int $syscall

    /* Read the input name */
    movl $sysread,  %EAX
    movl $stdin,    %EBX
    movl $bufname,  %ECX
    movl $size,     %EDX
    int $syscall

    /* Write the name in personal.txt */
    decl %EAX   # the last character of the string read is not taken
    movl %EAX,       %EDX
    movl $syswrite,  %EAX
    movl %EDI,       %EBX
    movl $bufname,   %ECX
    int $syscall

    /* Write a space tabulation */
    movl $syswrite,  %EAX
    movl %EDI,       %EBX
    movl $tab,       %ECX
    movl $1,         %EDX
    int $syscall

    /* Print age_msg */
    movl $syswrite, %EAX
    movl $stdout,   %EBX
    movl $age_msg,  %ECX
    movl $age_len,  %EDX
    int $syscall

    /* Read the input age */
    movl $sysread,  %EAX
    movl $stdin,    %EBX
    movl $bufage,   %ECX
    movl $size,     %EDX
    int $syscall

    /* Write the age in personal.txt */
    decl %EAX
    movl %EAX,      %EDX
    movl $syswrite, %EAX
    movl %EDI,      %EBX
    movl $bufage,   %ECX
    int $syscall

    /* Write a line feed */
    movl $syswrite, %EAX
    movl %EDI,      %EBX
    movl $newline,  %ECX
    movl $1,        %EDX
    int $syscall

    /* Print final_msg */
    movl $syswrite,     %EAX
    movl $stdout,       %EBX
    movl $final_msg,    %ECX
    movl $final_len,    %EDX
    int $syscall

    /* Read the final input */
    movl $sysread,      %EAX
    movl $stdin,        %EBX
    movl $bufEndChar,   %ECX
    movl $charSize,     %EDX
    int $syscall

    /* If the final input is 's', the program ends */
    movb bufEndChar,    %AL
    cmpb $'s',          %AL
    jz exit
    movb $0,            %AL
    movb %AL,    bufEndChar
    jmp start

exit:
    /* Close the file */
    movl $sysclose, %EAX
    movl %EDI,      %EBX
    int $syscall

    /* Exit the program */
    movl $sysexit,  %EAX
    movl $success,  %EBX
    int $syscall
