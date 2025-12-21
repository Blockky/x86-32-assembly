#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>

int main(){
    // Data
    const char *prompt = "Enter a string (up to 20 characters) [E for Exit]:\n";
    int prompt_l = strlen(prompt);

    const int buffer_s = 21;
    char buffer[buffer_s];
    char lower_str[buffer_s];

    // Text-Code
    int flags = O_WRONLY | O_APPEND | O_CREAT;
    int fd = open("./personal.txt\0",flags,0666);
    exit(EXIT_SUCCESS);
}