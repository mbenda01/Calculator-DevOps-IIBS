# Calculator DevOps

Application Java 17 de calculatrice en ligne de commande, avec pipeline CI/CD GitHub Actions pour Maven, Nexus et DockerHub.

## Prerequis

- Java 17
- Maven 3.8+
- Docker

## Utilisation locale

```bash
mvn clean package
java -jar target/calculator-devops.jar 10 + 5
java -jar target/calculator-devops.jar 10 / 0
```

## Tests

```bash
mvn test
```

## Docker

```bash
mvn -DskipTests package
docker build -t calculator-devops:local .
docker run --rm calculator-devops:local 10 + 5
```

## Pipeline CI/CD

Chaque `push` declenche automatiquement :

- la compilation Maven
- les tests Maven
- la publication du `.jar` sur Nexus apres validation des tests
- la construction et le push de l'image Docker sur DockerHub
- l'execution de l'image Docker publiee sur le runner pour verifier son fonctionnement

Le pipeline utilise une version Maven de type `1.0.<run_number>-SNAPSHOT`, ce qui permet de versionner automatiquement les artefacts Nexus a chaque execution.

Les images Docker sont poussees avec deux tags :

- `1.0.<run_number>`
- `sha-<commit_sha>`

## Secrets GitHub requis

- `NEXUS_USERNAME`
- `NEXUS_PASSWORD`
- `NEXUS_SNAPSHOT_URL`
- `NEXUS_RELEASE_URL`
- `DOCKERHUB_USERNAME`
- `DOCKERHUB_TOKEN`
