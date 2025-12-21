#include <unistd.h>
#include <stdlib.h>

int main(){
    // Data
    const int buffer_s = 21;
    char buffer[buffer_s];
    
    // Text-Code
    int len = read(STDIN_FILENO, buffer, buffer_s);
    write(STDOUT_FILENO, buffer, len);
    exit(EXIT_SUCCESS);
}