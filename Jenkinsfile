//##############################################################
// Jenkinsfile for CS 3100 Operating Systems
// Students: do not modify this file in any way whatsoever.
//##############################################################

pipeline {
	agent {
        node { label 'ubuntuvps' }
	}

	stages {
	
		stage('Build') {
			steps {
				echo 'Building...'
				sh 'cs3100build'
			}
			post {
				failure {
					echo 'Sending console log to submitter'
					sh 'cs3100sendlog "Lab Build failed"'
				}
			}
		}
		
		stage('Test') {
			steps {
				echo 'Testing...'
				sh 'cs3100cucumber'
				echo 'Reporting to the student...'
				sh "cs3100report"
				echo 'Grading the assignment...'
				sh "cs3100grade"
			}
		}
	}
}
