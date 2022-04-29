//Ben Ganon 318731007

#include "stdio.h"
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <sys/wait.h>
#include "syscall.h"

#define COM_LEN 100

int getCom(char *input, char **command, char **args) {
    char *temp;
    temp = strtok(input, " ");
    int comLen = strlen(temp);
    *command = (char *) malloc(comLen + 1);
    strcpy(command, temp);
    temp = strtok(NULL, " ");
    int argLen = strlen(temp);
    *args = (char *) malloc(argLen + 1);
    strcpy(args, temp);
    return 0;
}

void execBuilt(char *command, char *args, char commHist[COM_LEN][COM_LEN], int index) {
    char *argv[] = {command, args, NULL};
    if(strcmp(command, "exit") == 0) {
        exit(0);
    } else if(strcmp(command, "history") == 0) {
        sprintf(commHist[index], "%d %s %s", getpid(), command, args);
        for (int i = 0; i <= index; ++i) {
            printf("%s\n", commHist[i]);
        }
    } else if(strcmp(command, "cd") == 0){
        const char* cdCom = "chdir";
        int pid = getpid();
        sprintf(commHist[index], "%d %s %s", pid, command, args);
        syscall(SYS_chdir, args);
    }
}


void execNative(char *command, char *args, char commHist[COM_LEN][COM_LEN], int index) {
    int stat, waited, ret_code;
    char *argv[] = {command, args, NULL};
    if(strlen(args) == 0) {
        argv[1] = NULL;
    }
    pid_t pid;
    pid = fork();
    if (pid == 0) {
        ret_code = execvp(command, argv);
        if (ret_code == -1) {
            char *error = command;
            strcat(error, " failed");
            perror(error);
            exit(-1);
        }
    } else {
        sprintf(commHist[index], "%d %s %s", pid, command, args);
        wait(&stat);
    }
}

void addEnv(int argc, char *argv[]) {
    char *tempPath = getenv("PATH");
    for (int i = 0; i < argc; ++i) {
        strcat(tempPath, ":");
        strcat(tempPath, argv[i]);
    }
    setenv("PATH", tempPath, 1);
    printf("env pat is : %s \n", getenv("PATH"));
}

int main(int argc, char *argv[]) {
    addEnv(argc, argv);
    char commHist[COM_LEN + 10][COM_LEN + 10] = {NULL};
    char input[COM_LEN];
    char command[COM_LEN];
    char args[COM_LEN];
    int stop = 0;
    int comLen, argLen = 0;
    int hist = -1;
    while (!stop) {
        command[0] = '\0';
        args[0] = '\0';
        printf("$ ");
        fflush(stdout);
        scanf("%[^\n]%*c", input);
        char *temp;
        temp = strtok(input, " ");
        strcpy(command, temp);
        comLen = strlen(temp);
        command[comLen] = '\0';
        temp = strtok(NULL, " ");
        if (temp != NULL) {
            argLen = strlen(temp);
            strcpy(args, temp);
            args[argLen] = '\0';
        }
        if (strcmp(command, "exit") == 0 || strcmp(command, "cd") == 0 || strcmp(command, "history") == 0) {
            execBuilt(command, args, commHist, ++hist);
        } else execNative(command, args, commHist, ++hist);
    }


}

