FROM adoptopenjdk/openjdk11:jdk-11.0.5_10-alpine AS builder
ENV APP_FILE hello-world-1.0-SNAPSHOT.jar
ENV APP_HOME /usr/apps
EXPOSE 8080
COPY target/$APP_FILE $APP_HOME/
WORKDIR $APP_HOME
ENTRYPOINT ["sh", "-c"]
CMD ["exec java -jar $APP_FILE"]