#include <unistd.h>
#include <stdlib.h>

int main(){
    const int buffer_s = 21;
    char buffer[buffer_s];
    
    int len = read(STDIN_FILENO, buffer, buffer_s);
    write(STDOUT_FILENO, buffer, len);
    exit(EXIT_SUCCESS);
}