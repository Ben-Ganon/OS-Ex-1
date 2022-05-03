//Ben Ganon 318731007

#include "stdio.h"
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <sys/wait.h>
#include "syscall.h"

#define COM_LEN 100

void execBuilt(char *command, char *args[COM_LEN], char commHist[COM_LEN +10][COM_LEN +10],char* histLine, int index) {
    if(strcmp(command, "exit") == 0) {
        exit(0);
    } else if(strcmp(command, "history") == 0) {
        sprintf(commHist[index], "%d %s%s", getpid(), command, histLine);
        int i;
        for (i = 0; i <= index; ++i) {
            printf("%s\n", commHist[i]);
        }
    } else if(strcmp(command, "cd") == 0){
        int pid = getpid();
        sprintf(commHist[index], "%d %s%s", pid, command, histLine);
        syscall(SYS_chdir, args[1]);
    }
}


void execNative(char *args[COM_LEN], char commHist[COM_LEN + 10][COM_LEN + 10],char* histLine, int index) {
    int stat, waited, ret_code;
    char * command = args[0];
    pid_t pid;
    pid = fork();
    if (pid == 0) {
        ret_code = execvp(command, args);
        if (ret_code == -1) {
            char *error = command;
            strcat(error, " failed");
            perror(error);
            exit(-1);
        }
    } else {

        sprintf(commHist[index], "%d %s%s", pid, command, histLine);
        wait(&stat);
    }
}

void addEnv(int argc, char *argv[]) {
    char *tempPath = getenv("PATH");
    int i;
    for (i = 0; i < argc; ++i) {
        strcat(tempPath, ":");
        strcat(tempPath, argv[i]);
    }
    setenv("PATH", tempPath, 1);
}

int main(int argc, char *argv[]) {
    addEnv(argc, argv);
    char commHist[COM_LEN + 10][COM_LEN + 10] = {NULL};

    int stop = 0;
    int hist = -1;
    while (!stop) {
        char input[COM_LEN];
        char* args[COM_LEN]={NULL};
        int argIndex = 0;
        printf("$ ");
        fflush(stdout);
        scanf("%[^\n]%*c", input);
        char *temp = strtok(input, " ");
        args[argIndex] = temp;
        argIndex++;
        while((temp = strtok(NULL, " ")) != NULL) {
            args[argIndex] = temp;
            argIndex++;
        }
        char histLine[COM_LEN] = {""};
        int curr = 1;
        while(args[curr] != NULL) {
            strcat(histLine, " ");
            strcat(histLine, args[curr]);
            curr++;
        }
        char *command = args[0];

        if (strcmp(command, "exit") == 0 || strcmp(command, "cd") == 0 || strcmp(command, "history") == 0) {
            execBuilt(command,args, commHist,histLine, ++hist);
        } else execNative(args, commHist,histLine, ++hist);
    }


}

