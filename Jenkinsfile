pipeline {
    agent any
    tools{
        maven "Maven 3.8.5"
    }

    stages {
         stage('env variables') {

            steps {
                def artifactory_url="http://localhost:8082/artifactory/"
                def pom_version=readMavenPom file: pom.xml
                sh " java -version"
                sh " mvn -version"
                sh " echo ${pom_version}"
            }
         }

        stage ('Artifactory configuration') {
            steps {
                rtServer id: "server", url: artifactory_url , credentialsId: "token"
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
                    docker build -t demo:${pom_version} .
                    docker push ayoubmouak/demo:${pom_version}
                """
           }
        }

        stage('Helm install'){
           steps{
                sh """
                    helm install my-demo demo
                """
           }
        }

    }
}