#include <unistd.h>
#include <stdlib.h>
#include <string.h>

int main(){
    // Data
    const char *msg1 = "Hello World!\n";
    int len1 = strlen(msg1);
    
    const char *msg2 = "I'm from the UAH!\n";
    int len2 = strlen(msg2);

    // Text-Code
    write(STDOUT_FILENO, msg1, len1);
    write(STDOUT_FILENO, msg2, len2);
    exit(EXIT_SUCCESS);
}