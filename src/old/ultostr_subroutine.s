/*
 * Author: Blocky [https://github.com/Blockky]
 * Session 9, Exercise 1
 */

.data
    prompt: .ascii "Enter a number represented in the base you want between bases 2 and 16:\n"
    prompt_len = . - prompt

    msg_bas: .ascii "Specify the base of the written number (between 2 and 16):\n"
    len_bas = . - msg_bas

    msg_bas_dec: .ascii "Enter the base in which you want to decode the number:\n"
    len_bas_dec = . - msg_bas_dec

    msg_error: .ascii "ERROR: The number is incorrect or an overflow ocurred!\n"
    len_error = . - msg_error

    msg_end: .ascii "Decoded number:\n"
    len_end = . - msg_end

    newline: .ascii "\n"

    bufbase_size = 3
    base_input: .space bufbase_size
    base_to_dec: .space bufbase_size

    size = 80
    num_input: .space size
    buffer: .space size

    letter_code = 'A' - 10

.text
.global _start
_start:
    # Print number prompt
    movl $syswrite,    %eax
    movl $stdout,      %ebx
    movl $prompt,      %ecx
    movl $prompt_len,  %edx
    int $syscall

    # Read number input
    movl $sysread,     %eax
    movl $stdin,       %ebx
    movl $num_input,   %ecx
    movl $size,        %edx
    int $syscall

    # Print base prompt
    movl $syswrite,    %eax
    movl $stdout,      %ebx
    movl $msg_bas,     %ecx
    movl $len_bas,     %edx
    int $syscall

    # Read base input
    movl $sysread,      %eax
    movl $stdin,        %ebx
    movl $base_input,   %ecx
    movl $bufbase_size, %edx
    int $syscall

    # Print base to decode prompt
    movl $syswrite,     %eax
    movl $stdout,       %ebx
    movl $msg_bas_dec,  %ecx
    movl $len_bas_dec,  %edx
    int $syscall

    # Read base to decode input
    movl $sysread,      %eax
    movl $stdin,        %ebx
    movl $base_to_dec,  %ecx
    movl $bufbase_size, %edx
    int $syscall

    # Encode to binary the base written
    movl $base_input,   %ebx
    movl $10,           %eax

    pushl %ebx      # char* number
    pushl %eax      # int base
    call strtoul2   # it returns the encoded int base in eax

    addl $(2*4),        %esp

    # Encode to binary the number written
    movl $num_input,    %ebx

    pushl %ebx      # char* number
    pushl %eax      # int base
    call strtoul2   # It returns the encoded int number in eax

    addl $(2*4),        %esp

    pushl %eax      # Save the int number in the stack

    # Encode to binary the base to encode written
    movl $base_to_dec,  %ebx
    movl $10,           %eax
    
    pushl %ebx      # char* number
    pushl %eax      # int base
    call strtoul2   # It returns the encoded int base to decode in eax

    addl $(2*4),    %esp
    popl %ebx
    movl $buffer,   %ecx

    pushl %ebx      # int number
    pushl %ecx      # buffer
    pushl %eax      # int base
    call ultostr

    addl $(3*4),    %esp

    cmpl $-1,       %eax
    jz print_error

    # Print final message
    movl $syswrite, %eax
    movl $stdout,   %ebx
    movl $msg_end,  %ecx
    movl $len_end,  %edx
    int $syscall

    # Print decoded number
    movl $syswrite, %eax
    movl $stdout,   %ebx
    movl $buffer,   %ecx
    movl $size,     %edx
    int $syscall

    # Print a new line
    movl $syswrite, %eax
    movl $stdout,   %ebx
    movl $newline,  %ecx
    movl $1,        %edx
    int $syscall

exit:
    # Exit program
    movl $sysexit,  %eax
    movl $success,  %ebx
    int $syscall

print_error:
    # Print error message
    movl $syswrite,    %eax
    movl $stdout,      %ebx
    movl $msg_error,   %ecx
    movl $len_error,   %edx
    int $syscall

    jmp exit

#-----------------------------------------------------------------------
# char* ultostr(int, char*, int)
# Converts a unsigned long int in a specific base to a string returned
# in the given buffer pointer. Returns 0xFFFFFFFF in case of error.
#-----------------------------------------------------------------------
.type ultostr, @function
.global ultostr
ultostr:
    push %ebp           
    movl %esp,  %ebp

    pushl %ebx
    pushl %ecx
    pushl %edx
    pushl %edi
    pushl %esi

    movl 8(%ebp),   %edi    # int base number
    movl 12(%ebp),  %ecx    # char* buffer
    movl 16(%ebp),  %eax    # int number

    movl $0,        %esi
    cmpl $-1,       %eax
    jz decode_error

decode:
    movl $0,        %edx
    divl %edi
    cmpl $10,       %edx
    jb decode_number

    jmp decode_letter

decode_number:
    addb $'0',  %DL
    movb %DL,  (%ecx, %esi)
    incl %esi
    test %eax,  %eax
    jz end_decode
    jmp decode

decode_letter:
    addb $letter_code, %DL
    movb %DL,  (%ecx, %esi)
    incl %esi
    test %eax,  %eax
    jz end_decode
    jmp decode
 
end_decode:
    movl $0,    %esi
    movl $0,    %edi
    movl $0,    %ebx
    pushl %ebx

temp:
    movb (%ecx, %esi),  %BL
    incl %esi
    testl %ebx, %ebx
    jz swap
    pushl %ebx
    jmp temp

swap:
    popl %ebx
    movb %BL,   (%ecx, %edi)
    incl %edi
    testl %ebx, %ebx
    jz exit_decode
    jmp swap

exit_decode:
    movl %ecx,  %eax

exit_ultostr:
    popl %ebx
    popl %ecx
    popl %edx
    popl %edi
    popl %esi
    leave
    ret

decode_error:
    movl $-1,   %eax
    jmp exit_ultostr

#----------------------------------------------------------------
# int strtoul2(char*, int)
# Converts a string in a specific base to an unsigned long int
# Returns 0xFFFFFFFF in case of error
#----------------------------------------------------------------
.type strtoul2, @function
.global strtoul2
strtoul2:
    push %ebp           
    movl %esp,      %ebp

    pushl %ebx
    pushl %ecx
    pushl %edx
    pushl %edi
    pushl %esi

    movl 8(%ebp),   %edi    # int number base
    movl 12(%ebp),  %ebx    # char* number

    movl $0,        %eax
    movl $0,        %esi
    movl $0,        %edx

    # Check if the base is between 2 and 16
    cmpl $16,   %edi
    ja encode_error2
    cmpl $2,    %edi
    jb encode_error2

encode2:
    # Check if the character is NULL or \n
    movb (%ebx, %esi), %CL
    cmpb $0,           %CL
    jz exit_strtoul2
    cmpb $10,          %CL
    jz exit_strtoul2

    # Check if the character is a number or a letter
    movl %edi,        %edx
    cmpb $'0',         %CL
    jb encode_error2
    cmpb $'9',         %CL
    ja check_letter

check_number:
    addb $'0',      %DL
    cmpb %DL,       %CL
    jae encode_error2

    # Encode the number
    andl $encodermask,  %ecx
    mull %edi
    jc encode_error2
    addl %ecx,      %eax
    jc encode_error2
    incl %esi
    jmp encode2

check_letter:
    cmpl $9,       %edi
    jbe encode_error2
    cmpb $'A',      %CL
    jb encode_error2
    cmpb $'F',      %CL
    ja encode_error2
    addb $letter_code,      %DL
    cmpb %DL,       %CL
    jae encode_error2
    
    # Encode the letter
    subb $'A',      %CL
    addb $10,       %CL
    mull %edi
    jc encode_error2
    addl %ecx,      %eax
    jc encode_error2
    incl %esi
    jmp encode2

encode_error2:
    movl $-1,       %eax

exit_strtoul2:
    popl %ebx
    popl %ecx
    popl %edx
    popl %edi
    popl %esi
    leave
    ret

/* Constants */
sysexit     = 1
syscall     = 0x80
success     = 0
encodermask = 0x0F
syswrite    = 4
sysread     = 3
stdout      = 1
stdin       = 0
