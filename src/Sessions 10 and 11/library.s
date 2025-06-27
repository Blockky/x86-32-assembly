/*
 * Author: Blocky [https://github.com/Blockky]
 * Session 10 & 11, library
 */

.text
#------------------------------------------
# int strlen (char *)
# Returns the length of a string
#------------------------------------------
.type strlen, @function
.global strlen
strlen:
    pushl %ebp
    movl %esp,     %ebp

    pushl %ebx
    pushl %esi

    movl 8(%ebp),  %ebx    # string
    movl $-1,      %esi

count:
    # Save in %esi the number of characters
    incl %esi
    cmpb $0,    (%ebx, %esi)
    jnz count

    movl %esi, %eax
    
    popl %ebx
    popl %esi
    leave
    ret

#--------------------------------------------------------------
# char * strcpy(char *, char *)
# Copies the second string into the first one and returns it
#--------------------------------------------------------------
.type strcpy, @function
.global strcpy
strcpy:
    pushl %ebp
    movl %esp,      %ebp

    pushl %ebx
    pushl %ecx
    pushl %edx
    pushl %esi
    pushl %edi

    movl 8(%ebp),   %esi  # source string (second one)
    movl 12(%ebp),  %edi  # destiny string (first one)
    movl %edi,      %edx  
    movl %esi,      %ebx
    decl %ebx
    movl $0,        %eax

copy:
    movb (%esi), %cl
    movb %cl, (%edi)
    cmpb $0,     %cl
    jz exit_cpy
    cmpl %ebx,  %edi
    jz null_cpy
    incl %esi
    incl %edi
    jmp copy
    
exit_cpy:
    movl %edx,   %eax

null_cpy:
    popl %ebx
    popl %ecx
    popl %edx
    popl %esi
    popl %edi
    leave
    ret

#---------------------------------------
# char * strcat(char *, char *)
# Concatenates two strings
#---------------------------------------
.type strcat, @function
.global strcat
strcat:
    pushl %ebp
    movl %esp,       %ebp

    pushl %ecx
    pushl %edx
    pushl %esi
    pushl %edi

    movl 8(%ebp),    %esi  # source string (second one)
    movl 12(%ebp),   %edi  # destiny string (first one)
    movl %edi,       %edx

next:
    cmpb $0, (%edi)
    jz append
    incl %edi
    jmp next

append:
    movb (%esi), %cl
    movb %cl, (%edi)
    cmpb $0,     %cl
    jz exit_cat
    incl %esi
    incl %edi
    jmp append

exit_cat:
    movl %edx, %eax

    popl %ecx
    popl %edx
    popl %esi
    popl %edi
    leave
    ret

#----------------------------------------------------------------
# int * strchr(char *, char *)
# Returns the position of the searched character in the string
#----------------------------------------------------------------
.type strchr, @function
.global strchr
strchr:
    pushl %ebp
    movl %esp,       %ebp

    pushl %ecx
    pushl %esi
    pushl %edi

    movl 8(%ebp),    %esi  # searched character (second one)
    movl 12(%ebp),   %edi  # destiny string (first one)
    movb (%esi),     %cl

search:
    cmpb $0,    (%edi)
    jz not_found
    cmpb %cl,   (%edi)
    jz found
    incl %edi
    jmp search

found:
    movl %edi,  %eax
    jmp exit_chr

not_found:
    movl $0,    %eax
    
exit_chr:
    popl %ecx
    popl %esi
    popl %edi
    leave
    ret

#-----------------------------------------------------
# int strcmp(char *, char *) 
# Returns an int of the difference of two strings
#-----------------------------------------------------
.type strcmp, @function
.global strcmp
strcmp:
    pushl %ebp
    movl %esp,       %ebp

    pushl %ecx
    pushl %esi
    pushl %edi

    movl 8(%ebp),    %esi  # source string (second one)
    movl 12(%ebp),   %edi  # destiny string (first one)
    movl $0,         %ecx
    movl $0,         %eax

compare:
    movb (%esi), %cl
    subb (%edi), %cl
    jz next_char
    testb %cl,   %cl
    js negative
    movb %cl,    %al
    jmp exit_cmp

negative:       # if the result is negative, return its C2 and edx = 1
    neg %cl
    movb %cl,    %al
    movl $1,     %edx
    jmp exit_cmp

next_char:
    cmpb $0,    (%edi)
    jz exit_cmp
    incl %esi
    incl %edi
    jmp compare

exit_cmp:
    popl %ecx
    popl %esi
    popl %edi
    leave
    ret

#---------------------------------------------------------------------
# char * strstr(char *, char *) 
# Returns the position of the searched string in the destiny string
#---------------------------------------------------------------------
.type strstr, @function
.global strstr
strstr:
    pushl %ebp
    movl %esp,      %ebp

    pushl %ebx
    pushl %ecx
    pushl %esi
    pushl %edi

    movl 8(%ebp),   %ebx  # searched string (second one)
    movl 12(%ebp),  %edx  # destiny string (first one)

search_first_char:
    movl %edx,      %edi
    movl %ebx,      %esi
    movl $0,        %ecx
    movl $0,        %eax

    pushl %eax
    pushl %edi
    pushl %esi
    call strchr

    movl %eax,      %edi
    addl $(2*4),    %esp
    popl %eax

    cmpl $0,        %edi
    jz exit_str

    movl %edi,      %eax
    
next_srch:
    incl %esi
    incl %edi
    movb (%esi),    %cl
    cmpb $0,        %cl
    jz exit_str

    cmpb %cl,  (%edi)
    jz next_srch

    cmpb $0,   (%edi)
    jnz check_again
    movl $0,    %eax

exit_str:
    popl %ebx
    popl %ecx
    popl %esi
    popl %edi
    leave
    ret

check_again:
    incl %edx
    jmp search_first_char

#--------------------------------------
# print (char *)
# Prints a string to the terminal
#--------------------------------------
.type print, @function
.global print
sys_call = 0x80
sys_write = 4
std_out = 1

print:
    pushl %ebp
    movl %esp,      %ebp

    pushl %ebx
    pushl %ecx
    pushl %edx
    pushl %esi

    movl 8(%ebp),   %ecx    # string
    movl $-1,       %esi

count_bytes:
    incl %esi
    cmpb $0,    (%ecx,%esi)
    jnz count_bytes

    movl $sys_write,    %eax
    movl $std_out,      %ebx
    movl %esi,          %edx
    int $sys_call

    popl %ebx
    popl %ecx
    popl %edx
    popl %esi
    leave
    ret

#-----------------------------------------------------------------------
# char* ultostr(int, char*, int)
# Converts a unsigned long int in a specific base to a string returned
# in the given buffer pointer. Returns 0xFFFFFFFF in case of error.
#-----------------------------------------------------------------------
.type ultostr, @function
.global ultostr
letter_code = 'A' - 10

ultostr:
    push %ebp           
    movl %esp,      %ebp

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

/* Constants */
syswrite   = 4
syscall    = 0x80
stdout     = 1
    