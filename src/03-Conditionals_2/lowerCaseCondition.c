#include <unistd.h>
#include <stdlib.h>
#include <string.h>

#define LOWERMASK 0x20

int main(){
    const char *prompt = "Enter a string (up to 20 characters) [E for Exit]:\n";
    int prompt_l = strlen(prompt);

    const int buffer_s = 21;
    char buffer[buffer_s];
    char lower_str[buffer_s];

    int len, i;
    while(1){
        write(STDOUT_FILENO, prompt, prompt_l);
        len = read(STDIN_FILENO, buffer, buffer_s);
        if(buffer[0] == 'E' && len == 2)
            exit(EXIT_SUCCESS);
        else{
            i = 0;
            while(buffer[i] != '\n'){
                lower_str[i] = buffer[i] | LOWERMASK;
                i++;
            }
            lower_str[i] = '\n';
            write(STDOUT_FILENO, lower_str, len);
            for(i = 0; i < buffer_s; i++){
                buffer[i] = 0;
                lower_str[i] = 0;
            }
        }
    }
}