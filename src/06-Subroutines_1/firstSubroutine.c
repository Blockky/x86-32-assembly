#include <unistd.h>
#include <stdlib.h>
#include <string.h>

const char *o_msg = "Error, the operation resulted in overflow!\n";
const char *p_msg = "The result is positive!\n";
const char *n_msg = "The result is negative!\n";

int addition(int a, int b);

int main(){
    int o_len = strlen(o_msg);
    int p_len = strlen(p_msg);
    int n_len = strlen(n_msg);

    int a = addition(32, 128);
    if(a == -1)
        write(STDOUT_FILENO, o_msg, o_len);
    else if(a > 0)
        write(STDOUT_FILENO, p_msg, p_len);
    else
        write(STDOUT_FILENO, n_msg, n_len);

    exit(EXIT_SUCCESS);
}

int addition(int a, int b){
    int result = a + b;
    if((a > 0 && b > 0 && result < 0)
        || (a < 0 && b < 0 && result > 0))
        result = -1;
    return result;
}