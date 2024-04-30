pipeline {
    agent any

    stages {
    stage('Cleaning the project') {

                    steps {
                        sh "echo $JAVA_HOME"
                        sh "echo $MAVEN_HOME"
                        sh "echo $M2_HOME"

                    }
            }


        stage('Cleaning the project') {

                steps {
                    echo 'cleaning project ...'
                    sh 'mvn clean'
                }
        }

        stage('Artifact Construction') {

                steps {
                    echo "artificat contruction"
                    sh 'mvn package'
                }
        }

    }
}