#include <unistd.h>
#include <stdlib.h>

int main(){
    const int size = 21;
    char buffer[size];

    int len = read(STDIN_FILENO, buffer, size);
    
    write(STDOUT_FILENO, buffer, len);
    exit(EXIT_SUCCESS);
}