# Fichier Dockerfile
FROM eclipse-temurin:17-jre-alpine

# Installer netcat pour envoyer les logs à Logstash
RUN apk add --no-cache netcat-openbsd

WORKDIR /app

COPY target/calculator-1.0.jar app.jar

ENTRYPOINT ["java", "-jar", "/app/app.jar"]