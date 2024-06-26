pipeline {
    agent any
    tools{
        maven "Maven 3.8.5"
    }

    stages {

         stage('env variables') {

            steps {
                script {
                     artifactory_url="http://localhost:8082/artifactory/"
                     pom_version=readMavenPom(file: "pom.xml").getVersion()
                }

                sh " mvn -version"
                echo pom_version
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
                rtMavenRun pom: 'pom.xml', goals: 'versions:set -DnextSnapshot -DprocessDependencies=false versions:commit', deployerId: "deployer"
                rtMavenRun pom: 'pom.xml', goals: 'clean install', deployerId: "deployer"

                withCredentials([gitUsernamePassword(credentialsId: 'github')]) {
                    sh """
                      git add .
                      git commit -m "commit pom with next snapshot"
                      git push origin master
                    """
                }
            }
        }

       stage('Build docker image'){

           steps{
                script{
                    pom_version=readMavenPom(file: "pom.xml").getVersion()
                }
                sh """
                     podman build -t demo:${pom_version} .
                     podman tag demo:${pom_version} docker.io/ayoubmouak/demo:${pom_version}
                     podman push docker.io/ayoubmouak/demo:${pom_version}
                """
           }
       }

       stage('Helm install'){
           steps{
               script{
                  value_yaml = readYaml file: "k8s/demo/values.yaml"
                  value_yaml.deployment.image.version=pom_version
                  writeYaml file: "k8s/demo/values.yaml",data: value_yaml, overwrite: true

               }
                withCredentials([gitUsernamePassword(credentialsId: 'github')]) {
                    sh """
                      git add .
                      git commit -m "commit helmrelease with next snapshot"
                      git push origin master
                    """
                }

           }
       }

    }
}