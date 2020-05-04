FROM openjdk:11-jre-slim
ADD application.properties /opt/
ADD Seeker_Agent.jar /opt/
ADD Seeker_Agent.sh /opt/
ADD SEEKER/ /opt/SEEKER/
RUN chmod +x /opt/Seeker_Agent.sh
WORKDIR /opt/
CMD ./Seeker_Agent.sh start