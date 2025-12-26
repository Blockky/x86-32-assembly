/*
 * Author: Blocky [https://github.com/Blockky]
 * Session 11, library
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
    movl %esp,    %ebp

    pushl %ebx
    pushl %esi

    movl 8(%ebp), %ebx    # string
    movl $-1,     %esi

    count:
    # Save in %esi the number of characters
    incl %esi
    cmpb $0,  (%ebx, %esi)
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
    movl %esp,  %ebp

    pushl %ebx
    pushl %ecx
    pushl %edx
    pushl %esi
    pushl %edi

    movl 8(%ebp),  %esi  # source string (second one)
    movl 12(%ebp), %edi  # destiny string (first one)
    movl %edi,     %edx  
    movl %esi,     %ebx
    decl %ebx
    movl $0,       %eax

    copy:
    movb (%esi), %cl
    movb %cl,  (%edi)
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
