/*
 * Author: Blocky [https://github.com/Blockky]
 * Session 10, library
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
