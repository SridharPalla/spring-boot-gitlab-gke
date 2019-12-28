FROM adoptopenjdk/openjdk11:jdk-11.0.5_10-alpine AS builder

RUN set -eux && \
    apk --no-cache update && \
    apk --no-cache upgrade && \
	apk --no-cache add fontconfig freetype

ENV PATH="$PATH:$JAVA_HOME/bin"

# Copy neccessary files to resolve dependencies
COPY mvnw .
COPY .mvn ./.mvn
COPY pom.xml .

RUN ls -ltr
RUN pwd
RUN ./mvnw -e -B dependency:resolve

# Copy soruce code and build it
COPY src ./src
RUN ./mvnw clean package -Dorg.slf4j.simpleLogger.log.org.apache.maven.cli.transfer.Slf4jMavenTransferListener=warn -B -Dmaven.test.skip=true

# Stage 2
FROM adoptopenjdk/openjdk11:jdk-11.0.5_10-alpine

RUN set -eux && \
    apk --no-cache update && \
    apk --no-cache upgrade && \
	apk --no-cache add fontconfig freetype

RUN addgroup --gid 1001 api && \
    adduser --system --uid 1001 --ingroup api api

USER 1001

COPY --from=builder target/Kommunicera.jar .

EXPOSE 8080

#default value below is local,but this can be over-ridden
ARG arg_profile=local
ENV env_profile=$arg_profile

CMD ["-jar", "Kommunicera.jar"]
ENTRYPOINT ["java","-Dspring.profiles.active=${env_profile}"]
