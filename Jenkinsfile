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
                rtServer id: "ARTIFACTORY_SERVER",url: SERVER_URL, credentialsId: CREDENTIALS
                rtMavenDeployer id: "MAVEN_DEPLOYER",serverId: "ARTIFACTORY_SERVER",releaseRepo: ARTIFACTORY_LOCAL_RELEASE_REPO,snapshotRepo: ARTIFACTORY_LOCAL_SNAPSHOT_REPO
                rtMavenResolver id: "MAVEN_RESOLVER",serverId: "ARTIFACTORY_SERVER",releaseRepo: ARTIFACTORY_VIRTUAL_RELEASE_REPO,snapshotRepo: ARTIFACTORY_VIRTUAL_SNAPSHOT_REPO
            }
        }

        stage ('Exec Maven') {
            steps {
                rtMavenRun (
                    pom: 'maven-examples/maven-example/pom.xml',
                    goals: 'clean install',
                    deployerId: "MAVEN_DEPLOYER",
                    resolverId: "MAVEN_RESOLVER"
                )
            }
        }


    }
}