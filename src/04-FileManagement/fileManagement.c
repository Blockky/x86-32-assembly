#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>

int main(){
    const char *name_p = "Write the name (up to 10 characters):\n";
    const char *age_p = "Write the age (up to 10 characters):\n";
    const char *final_p = "Want to add a new record? (E for Exit / ENTER for continue): ";

    int name_l = strlen(name_p);
    int age_l = strlen(age_p);
    int final_l = strlen(final_p);

    const int buffer_s = 11;
    char name_b[buffer_s], age_b[buffer_s], buf_end_char[buffer_s];

    const char *filename = "./personal_C.txt";
    int flags = O_WRONLY | O_APPEND | O_CREAT;
    int umode_t = 0666;

    int fd_txt = open(filename, flags, umode_t);

    while(1){
        write(STDOUT_FILENO, name_p, name_l);
        int len = read(STDIN_FILENO, name_b, buffer_s);

        name_b[len-1] = '\t';
        write(fd_txt, name_b, len);

        write(STDOUT_FILENO, age_p, age_l);
        len = read(STDIN_FILENO, age_b, buffer_s);

        age_b[len-1] = '\n';
        write(fd_txt, age_b, len);

        int keep_asking = 1;
        while (keep_asking) {
            write(STDOUT_FILENO,final_p,final_l);
            len = read(STDIN_FILENO, buf_end_char, buffer_s);
            if(buf_end_char[0]=='E' && len==2){
                exit(EXIT_SUCCESS);
            }
            else if(buf_end_char[0]=='\n'){
                for(int i = 0; i < buffer_s; i++){
                    name_b[i] = 0;
                    age_b[i] = 0;
                }
                keep_asking = 0;
            }
        }
    }
    close(fd_txt);
    exit(EXIT_SUCCESS);
}