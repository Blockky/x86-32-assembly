#include <unistd.h>
#include <stdlib.h>
#include <string.h>

#define LOWERMASK 0x20
#define UPPERMASK 0xDF
#define TOGGLEMASK 0x20

int main(){
    const char *prompt = "Enter a string without numbers or symbols (up to 20 characters):\n";
    int prompt_l = strlen(prompt);

    const int buffer_s = 21;
    char buffer[buffer_s];
    char lower_str[buffer_s];
    char upper_str[buffer_s];
    char toggle_str[buffer_s];

    write(STDOUT_FILENO, prompt, prompt_l);
    int len = read(STDIN_FILENO, buffer, buffer_s);

    int count = len - 1;
    int i = 0;

    while (i < count){
        lower_str[i] = buffer[i] | LOWERMASK;
        upper_str[i] = buffer[i] & UPPERMASK;
        toggle_str[i] = buffer[i] ^ TOGGLEMASK;
        i++;
    }
    
    lower_str[i] = '\n';
    upper_str[i] = '\n';
    toggle_str[i] = '\n';

    write(STDOUT_FILENO, lower_str, len);
    write(STDOUT_FILENO, upper_str, len);
    write(STDOUT_FILENO, toggle_str, len);
    exit(EXIT_SUCCESS);
}