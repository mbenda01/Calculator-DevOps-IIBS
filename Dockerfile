FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

ARG JAR_FILE=target/calculator-devops.jar

COPY ${JAR_FILE} app.jar

ENTRYPOINT ["java", "-jar", "/app/app.jar"]
