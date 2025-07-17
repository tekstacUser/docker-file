# Use official Tomcat 8.5 image with JDK 17
FROM tomcat:8.5-jdk17
# Remove the default ROOT application if exists
RUN rm -rf /usr/local/tomcat/webapps/ROOT
# Copy WAR file to ROOT.war (so it runs at '/')
COPY build/*.war /usr/local/tomcat/webapps/ROOT.war
# Expose port 8080
EXPOSE 8080
# Start Tomcat
CMD ["catalina.sh", "run"]
