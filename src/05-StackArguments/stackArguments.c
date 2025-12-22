#include <unistd.h>
#include <stdlib.h>

int main(int argc, char* argv[]) {
    int i;
    int len;
    for (i = 0; i < argc && i < 9; i++) {
        len = 0;
        while (argv[i][len] != '\0') {
            len++;
        }
        argv[i][len] = '\n';
        write(STDOUT_FILENO, argv[i], len + 1);
        argv[i][len] = '\0';
    }
    exit(EXIT_SUCCESS);
}