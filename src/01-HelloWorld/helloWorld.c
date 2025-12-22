#include <unistd.h>
#include <stdlib.h>
#include <string.h>

int main(){
    const char *msg = "Hello World!\n";
    int len = strlen(msg);
    
    write(STDOUT_FILENO, msg, len);
    exit(EXIT_SUCCESS);
}