# Use Ubuntu as the base image for the build stage
FROM ubuntu:latest AS BUILD_IMAGE

# Install necessary tools and dependencies
RUN apt update && apt install -y git maven

# Clone the Git repository and build the application
RUN git clone https://github.com/KenzDev01/UCP-CONTROLER.git
RUN cd UCP-CONTROLER && git checkout master && mvn install 

# Use Tomcat as the base image for the final stage
FROM tomcat:9-jre11

# Remove the default Tomcat webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the WAR file from the build stage to Tomcat
COPY --from=BUILD_IMAGE UCP-CONTROLER/target/vprofile-v2.war /usr/local/tomcat/webapps/ROOT.war

# Expose the Tomcat port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]

