# we will use openjdk 8 with alpine as it is a very small linux distro
FROM docker.io/openjdk:8-jre-alpine3.9

# Expose port for rest calls
EXPOSE 8082

# copy the packaged jar file into our docker image
COPY target/*.jar /demo.jar

# set the startup command to execute the jar
CMD ["java", "-jar", "/demo.jar"]