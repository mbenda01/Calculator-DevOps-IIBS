# Calculator DevOps

Application calculatrice Java SE avec pipeline CI/CD complet (GitHub Actions → DockerHub).

[![CI/CD](https://github.com/[YOUR-USERNAME]/calculator-devops/workflows/CI/CD%20Calculator%20DevOps/badge.svg)](https://github.com/[YOUR-USERNAME]/calculator-devops/actions)

## Prérequis
- Java 17
- Maven 3.8+
- Docker

## Utilisation locale
```bash
mvn clean package
java -jar target/calculator-1.0.jar 10 + 5
java -jar target/calculator-1.0.jar 10 / 0  # Lance ArithmeticException
```

## Tests
```bash
mvn test
```

## Docker
```bash
docker build -t java-calculator:v1.0 .
docker run java-calculator:v1.0 10 + 5
```

## Pipeline CI/CD
- **Compile**: `mvn compile`
- **Test**: `mvn test` (JUnit 5)
- **Package**: `mvn package` → `calculator-1.0.jar`
- **Deploy**: Build/push `java-calculator:v1.0` to DockerHub

Trigger: push/PR to `main`. Secrets: `DOCKERHUB_USERNAME`, `DOCKERHUB_TOKEN`.

Image: [DockerHub](https://hub.docker.com/r/[YOUR-USERNAME]/java-calculator)
