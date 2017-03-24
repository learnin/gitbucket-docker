FROM java:8-jre

RUN apt-get update && apt-get -y install netcat

ADD https://github.com/gitbucket/gitbucket/releases/download/4.10/gitbucket.war /opt/gitbucket.war

RUN ln -s /gitbucket /root/.gitbucket

COPY docker-entry.sh /
RUN chmod +x /docker-entry.sh
ENTRYPOINT ["/docker-entry.sh"]

# Port for web page
EXPOSE 80
# Port for SSH access to git repository (Optional)
EXPOSE 29418
