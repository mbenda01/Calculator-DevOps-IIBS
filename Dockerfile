FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

COPY target/calculator-1.0.jar app.jar

ENTRYPOINT ["java", "-jar", "/app/app.jar"]