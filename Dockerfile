FROM tomcat:9.0-jdk17

# Remove default webapps to keep the container clean
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the web application source to the ROOT webapp
# This assumes the project structure has src/main/webapp
COPY src/main/webapp /usr/local/tomcat/webapps/ROOT

# Copy the PostgreSQL driver to the Tomcat lib directory
# This assumes the driver is in src/main/webapp/WEB-INF/lib
COPY src/main/webapp/WEB-INF/lib/postgresql-42.7.6.jar /usr/local/tomcat/lib/

# Expose port 8080
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
