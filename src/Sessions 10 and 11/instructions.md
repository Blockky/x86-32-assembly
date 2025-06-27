How to assemble and link the program?
```s
as --32 library.s -o library.o
as --32 main.s -o main.o
ld -melf_i386 library.o main.o -o main
```

How to use the program?
```s
./main strlen "string"

./main strcpy "destiny string" "source string"

./main strcat "string1" "string2"

./main strchr "destiny string" 'searched character'

./main strcmp "string1" "string2"

./main strstr "destiny string" "searched string"
```

