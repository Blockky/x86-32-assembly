#include <unistd.h>
#include <stdlib.h>
#include <string.h>

int main(){
    // Data
    const char *msg = "Hello World!\n";
    int len = strlen(msg);
    
    // Text-Code
    write(STDOUT_FILENO, msg, len);
    exit(EXIT_SUCCESS);
}