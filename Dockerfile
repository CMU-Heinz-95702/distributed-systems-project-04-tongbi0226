# Use a Linix image with Tomcat 10
FROM tomcat:9.0-jdk17-openjdk-slim

# Copy in our ROOT.war to the right place in the container
COPY ROOT.war /usr/local/tomcat/webapps/