Feature: Source file must be present, compilable and output correct information

	Scenario: nanosh.c must be found
		When I run `rm ../../bin/*`
		Then I run `cp ../../nanosh.c ../../bin/`
		Then a file named "../../bin/nanosh.c" should exist
		Then 20 points are awarded

	Scenario: nanosh.c must be compilable with no errors
		When I run `gcc -Wall -Werror -o ../../bin/nanosh ../../bin/nanosh.c` 
		And OUTPUT is printed
		Then a file named "../../bin/nanosh" should exist
		Then 20 points are awarded

	Scenario: nanosh should issue the appropriate prompt
		When I run `nanosh` interactively
		And I type "exit"
		And OUTPUT is printed
		Then the exit status should be 0
		And the stderr should not contain anything 
		And the stdout should contain exactly "nanosh: "
		Then 10 points are awarded
		
	Scenario: nanosh should exit without crashing
		When I run `nanosh` interactively
		And I type "exit"
		And OUTPUT is printed
		Then the exit status should be 0
		And the stderr should not contain anything 
		Then 15 points are awarded

	Scenario: nanosh exit WORDS should issue perror() with EINVAL if exit has parms
		When I run `nanosh` interactively
		And I type "exit foo"
		And I type "exit"
		And OUTPUT is printed
		And the stderr should contain "Invalid argument"
		And the stdout should contain exactly "nanosh: nanosh: "
		Then 10 points are awarded

	Scenario: nanosh pwd should print correct working directory
		When I run `nanosh` interactively
		And I type "pwd"
		And I type "exit"
		And OUTPUT is printed
		And the output should contain PWD
		And the stderr should not contain anything 
		Then 10 points are awarded

	Scenario: nanosh pwd with parms issues perror() with EINVAL
		When I run `nanosh` interactively
		And I type "pwd foo"
		And I type "exit"
		And OUTPUT is printed
		And the stdout should contain exactly "nanosh: nanosh: "
		And the stderr should contain "Invalid argument"
		Then 10 points are awarded

	Scenario: nanosh cd NEWDIR then pwd should print NEWDIR
		Given a directory named "mysubdir"
		When I run `nanosh` interactively
		And I type "cd mysubdir"
		And I type "pwd"
		And I type "exit"
		And OUTPUT is printed
		And the stdout should contain "mysubdir"
		And the stdout should contain "nanosh: nanosh: "
		Then 10 points are awarded

	Scenario: nanosh cd without parms should cd to the home directory
		Given a directory named "mysubdir"
		When I run `nanosh` interactively
		And I type "cd mysubdir"
		And I type "cd"
		And I type "pwd"
		And I type "exit"
		And OUTPUT is printed
		And the output should contain HOME
		And the output should not contain "mysubdir"
		Then 20 points are awarded

	Scenario: nanosh cd with > 1 parm should issue perror with EINVAL
		When I run `nanosh` interactively
		And I type "cd two parameters"
		And I type "exit"
		And OUTPUT is printed
		And the stdout should contain exactly "nanosh: nanosh: "
		And the stderr should contain "Invalid argument"
		Then 10 points are awarded

	Scenario: nanosh cd to a nonexitent dir should issue perror 
		When I run `nanosh` interactively
		And I type "cd A_TOTALLY_NONEXISTENT_DIRECTORY"
		And I type "exit"
		And OUTPUT is printed
		And the stdout should contain exactly "nanosh: nanosh: "
		And the stderr should contain "No such file or directory"
		Then 10 points are awarded

	Scenario: nanosh CMD should fork() and execvp() CMD
		When I run `gcc -Wall -Werror -c ../../bin/nanosh.c -o nanosh.o`
		And I run `nm nanosh.o`
		And OUTPUT is printed
		And the output should contain "U fork"
		And the output should contain "U execvp"
		Given a file named "testdata" with:
		"""
		I am your father

		"""
		And I run `nanosh` interactively
		And I type "cat testdata"
		And I type "exit"
		And OUTPUT is printed
		And the stdout should contain "I am your father\n"
		Then 10 points are awarded

	Scenario: nanosh CMD should call waitpid()
		When I run `gcc -Wall -Werror -c ../../bin/nanosh.c -o nanosh.o`
		And I run `nm nanosh.o`
		And OUTPUT is printed
		And the output should contain "U waitpid"
		Then 10 points are awarded

	Scenario: nanosh CMD should call perror() if CMD nonexistent
		Given the default aruba exit timeout is 3 seconds
		When I run `nanosh` interactively
		And I type "NONEXISTENTPROGRAM"
		And I type "exit"
		And OUTPUT is printed
		And the stdout should contain exactly "nanosh: nanosh: "
		And the stderr should contain "No such file or directory"
		Then 10 points are awarded

	Scenario: nanosh internal command output on STDOUT only
		When I run `nanosh` interactively
		And I type "pwd"
		And I type "exit"
		And OUTPUT is printed
		Then the stdout should contain "nanosh: "
		And the output should contain PWD
		And the stderr should not contain anything 
		Then 10 points are awarded

	Scenario: nanosh chid process terminate (not yet able to test, so you get 15 free points :-)
		Then 15 points are awarded

