pipeline {
    agent any
    tools{
        maven "Maven 3.8.5"
    }

    stages {
         stage('env variables') {

            steps {
                sh "echo $JAVA_HOME"
                sh "echo $MAVEN_HOME"
                sh " java -version"
                sh " mvn -version"
            }
         }

        stage ('Artifactory configuration') {
            steps {
                rtServer id: "server", url: "http://localhost:8082/artifactory/", credentialsId: "token"
                rtMavenDeployer id: "deployer", serverId: "server", releaseRepo: "spring_batch",  snapshotRepo: "spring_batch"
            }
        }

        stage ('Build artifact') {
            steps {
                rtMavenRun pom: 'pom.xml', goals: 'clean install', deployerId: "deployer"
            }
        }

       stage('Build docker image'){
           steps{
                sh """
                    docker build -t demo:0.0.1-SNAPSHOT .
                    docker push ayoubmouak/demo:0.0.1-SNAPSHOT
                """
           }
        }

    }
}