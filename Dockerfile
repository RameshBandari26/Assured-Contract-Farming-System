FROM tomcat:10.1.14-jdk17-temurin

# Remove default Tomcat webapps to avoid conflicts
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy your exploded WAR content to the ROOT webapp directory
COPY . /usr/local/tomcat/webapps/ROOT/

# Expose port 8080 (Tomcat default)
EXPOSE 8080

# Use the default startup command for Tomcat
CMD ["catalina.sh", "run"]
