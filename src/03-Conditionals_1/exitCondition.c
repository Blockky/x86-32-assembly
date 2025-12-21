#include <unistd.h>
#include <stdlib.h>
#include <string.h>

int main(){
    // Data
    const char *prompt = "Enter a character (E for Exit):\n";
    int prompt_l = strlen(prompt);

    const int buffer_s = 2;
    char buffer[buffer_s];

    // Text-Code
    while(buffer[0] != 'E'){
        write(STDOUT_FILENO, prompt, prompt_l);
        read(STDIN_FILENO, buffer, buffer_s);
        if(buffer[0] != 'E')
            write(STDOUT_FILENO, buffer, buffer_s);
    }
    exit(EXIT_SUCCESS);
}