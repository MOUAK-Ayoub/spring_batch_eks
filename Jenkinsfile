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
           steps{
                pom_version= readMavenPom file: pom.xml
                sh """
                    podman build -t demo:${pom_version} .
                    podman tag demo:${pom_version} docker.io/ayoubmouak/demo:${pom_version}
                    podman push docker.io/ayoubmouak/demo:${pom_version}
                """
           }
       }

       stage('Helm install'){
           steps{
                def value_yaml = readYaml text: k8s/demo/values.yaml
                value_yaml.deployment.image.version=pom_version
                sh """
                  git add .
                  git commit -m "commit helmrelease with next snapshot"
                  git push
                """
           }
       }

    }
}