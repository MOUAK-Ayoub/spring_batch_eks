pipeline {
    agent any
    tools{
        maven "Maven 3.8.5"
    }

    environment {
         artifactory_url="http://localhost:8082/artifactory/"
         pom_version=readMavenPom file: pom.xml
    }
    stages {

         stage('env variables') {

            steps {

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
                rtMavenRun pom: 'pom.xml', goals: 'versions:set -DnextSnapshot -DprocessDependencies=false', deployerId: "deployer"
                rtMavenRun pom: 'pom.xml', goals: 'clean install', deployerId: "deployer"
                sh """
                  git add .
                  git commit -m "commit pom with next snapshot"
                  git push
                """
            }
        }

       stage('Build docker image'){
           environment{
                      pom_version= readMavenPom file: pom.xml

           }
           steps{
                sh """
                    podman build -t demo:${pom_version} .
                    podman tag demo:${pom_version} docker.io/ayoubmouak/demo:${pom_version}
                    podman push docker.io/ayoubmouak/demo:${pom_version}
                """
           }
       }

       stage('Helm install'){
           value_yaml = readYaml text: k8s/demo/values.yaml
           value_yaml.deployment.image.version=pom_version
           steps{

                sh """
                  git add .
                  git commit -m "commit helmrelease with next snapshot"
                  git push
                """
           }
       }

    }
}