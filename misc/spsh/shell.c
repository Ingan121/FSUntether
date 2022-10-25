// https://stackoverflow.com/questions/28502305/writing-a-simple-shell-in-c-using-fork-execvp

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/wait.h>
#include <unistd.h>
#include <spawn.h>

#define BUFFER_LEN 1024

extern char **environ;

#define POSIX_SPAWN_PERSONA_FLAGS_OVERRIDE 1
int posix_spawnattr_set_persona_np(const posix_spawnattr_t* __restrict, uid_t, uint32_t);
int posix_spawnattr_set_persona_uid_np(const posix_spawnattr_t* __restrict, uid_t);
int posix_spawnattr_set_persona_gid_np(const posix_spawnattr_t* __restrict, uid_t);

// https://kjh95.tistory.com/379
char *substring(char *input, int i_begin, int i_end)
{
     int cnt    = 0;
     int size   = (i_end - i_begin) + 2;
     char *str = (char*)malloc(size);

     memset(str, 0, size);

     for(int i = i_begin; i <= i_end; i++)
     {
          str[cnt] = input[i];
          cnt++;
     }

     return str;
}

// https://stackoverflow.com/questions/21034365/how-to-do-backspace-processing-in-c
void processBksp (char *str) {
    // Set up independent source and dest pointers.

    char *src, *dst;

    for (src = dst = str; *src != '\0'; src++) {
        // Backspaces handled specially.

        if (*src == '\b') {
            // BS will back up unless you're at string start.

            if (dst != str) {
                dst--;
            }
            continue;
        }

        // Non-BS means simply transfer character as is.

        *dst++ = *src;
    }

    // Terminate string.

    *dst = '\0';
}

int main(){
    char user_input[BUFFER_LEN];  //get command line
    char* argv[120]; //user command
    int argc ; //argument count
    char* path= "/var/bin/";  //set path at bin  
    char file_path[50];//full file path
    char* pchBuf;
    int root = 0;

    while(1){
        
        if (getuid() == 0) printf("spsh# ");
        else printf("spsh$ ");  // Greeting shell during startup               
        
        if(!fgets(user_input,BUFFER_LEN, stdin)){
            break;  //break if the command length exceed the defined BUFFER_LEN
        }

        processBksp(user_input);

        if(strcmp(user_input, "exit\n")==0){            //check if command is exit
            break;
        }
        
        root = 0;
        if (strncmp(user_input, "sudo ", 5)==0) {
            pchBuf = substring(user_input, 5, strlen(user_input) - 1);
            strcpy(user_input, pchBuf);
            root = 1;
        }

        size_t length = strlen(user_input);

        if(length == 0){
            break;
        }

        if (user_input[length - 1] == '\n'){
            user_input[length - 1] = '\0'; // replace last char by '\0' if it is new line char
        }
        
        //split command using spaces
        char *token;                  
        token = strtok(user_input," ");
        int argc=0;
        if(token == NULL){
            continue;
        }
        while(token!=NULL){
            argv[argc]=token;      
            token = strtok(NULL," ");
            argc++;
        }
        
        argv[argc]=NULL; 
        
        strcpy(file_path, path);  //Assign path to file_path 
        strcat(file_path, argv[0]); //conctanate command and file path           

        if (access(file_path,F_OK)!=0){  //check the command is available in /bin
            strcpy(file_path, argv[0]);

            if (access(file_path,F_OK)!=0){
                printf("Command is not available in the bin\n"); //Command is not available in the bin
            continue;
            }
        }

        pid_t pid, wpid;
        int result, status;
        posix_spawnattr_t attr;
        posix_spawnattr_init(&attr);
        posix_spawnattr_set_persona_np(&attr, 99, 1);
        posix_spawnattr_set_persona_uid_np(&attr, 0);
        posix_spawnattr_set_persona_gid_np(&attr, 0);

        result = posix_spawn(&pid, file_path, NULL, root ? &attr : NULL, argv, environ);
        if (result == 0) {
            wpid = waitpid(pid, &status, WUNTRACED); 
            while (!WIFEXITED(status) && !WIFSIGNALED(status)){
                wpid = waitpid(pid, &status, WUNTRACED); 
            }
        }
        else {
            perror("Spawn Failed"); //process id can not be null 
        }
    }
}