/* 
 CS 3100 Lab 2 - by YOUR NAME HERE
*/

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <limits.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/wait.h>


void cmdExit(int argc, char **argv) {
	if(!argv[1]) {
		exit(0); 
	} 
	else if(argv[1]) {
		errno = EINVAL; 
		perror("Invalid argument"); 
	 }
}

void cmdPwd(int argc, char **argv) {
	char cwd[1024]; 
	if(argv[1]) {
		errno = EINVAL; 
		perror("Invalid argument"); 
	} else {
	getcwd(cwd, sizeof(cwd)); 
	printf("%s", cwd);
	printf("\n"); 
	} 
}

void cmdCd(int argc, char **argv) {
	//more than one argument
		if(argv[2]) {
		errno = EINVAL; 
		perror("Invalid argument"); 
	} else if(argc == 1) {
		//only one argument
		if(argc == 1) {
			chdir(getenv("HOME")); 
		}
	} else {
		errno = ENOENT; 
		perror(argv[1]); 
	}
}
void cmdOther(int argc, char **argv) {
	pid_t pid = fork(); 

	if(pid == -1) {
		errno = EINVAL; 
		perror("Couldn't fork child"); 
	} else if(pid == 0) {
		if(execvp(argv[0], argv) < 0) {
		errno = ENOENT; 
		perror("Couldn't execute command"); 	
		}
		exit(1); 
	} else {
		waitpid(-1, &pid, 0); 
		return; 
	}
	
	}

// getParameters returns the argc, the number of words found in cmd
//  while populating argv with pointers to each word
int getParameters(char *cmd, char **argv) {
	char *token;
	int argc = 0;
	token = strtok(cmd, " \t\n");
	while (token != NULL) {
		argv[argc] = token;
		argc++;
		token = strtok(NULL, " \t\n");
	}
	argv[argc] = NULL;		// set last + 1 argument to NULL
	return argc;
}

int main(int argc, char **argv) {

	char cmd[1024];
	char *rc;
	int myArgc = 0;
	char *myArgv[1000];

	while (1) {
		printf("nanosh: ");
		fflush(stdout);
		rc = fgets(cmd, sizeof(cmd), stdin);
		if (rc == NULL) {
			exit(0);
		}
		myArgc = getParameters(cmd, myArgv);

		// if no words typed: restart loop
		if (myArgc == 0) {		
			continue;
		}

		// if the first word is "exit", terminate the program
		if (strcmp(myArgv[0], "exit") == 0) {
			cmdExit(myArgc, myArgv);
			continue;
		}

		//if the first word is pwd
		if (strcmp(myArgv[0], "pwd") == 0) {
			cmdPwd(myArgc, myArgv);
			continue;
		}
		//if the first word is cd
		if (strcmp(myArgv[0], "cd") == 0) {
			cmdCd(myArgc, myArgv); 
			continue; 
		}

		else {
			cmdOther(myArgc, myArgv); 
			continue; 
		}

		// add if statements here for the other internal commands
		//   and a default action that calls a function to fork()
		//   and exec() while the parent issues waitpid()
	}

	return 0;
} 
