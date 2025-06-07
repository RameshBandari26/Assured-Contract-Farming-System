FROM tomcat:9-jdk17

# Clear default Tomcat webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy your project into Tomcat ROOT
COPY . /usr/local/tomcat/webapps/ROOT/

EXPOSE 8080

CMD ["catalina.sh", "run"]
