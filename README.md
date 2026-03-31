# Calculator DevOps

Projet DevOps pour une calculatrice console Java SE avec cycle complet autour de l'application :

- développement Java 17 avec Maven,
- tests unitaires JUnit 5,
- conteneurisation Docker,
- pipeline CI/CD GitHub Actions,
- publication du `.jar` dans Nexus,
- ingestion des logs d'exécution dans ELK.

## Stack

- Java 17
- Maven 3
- JUnit 5
- Docker / DockerHub
- GitHub Actions
- Nexus Repository
- Elasticsearch / Logstash / Kibana

## Structure du projet

```text
.
├── .github/workflows/ci.yml
├── Dockerfile
├── docker-compose.yml
├── elk/
│   ├── logs/
│   └── logstash/pipeline/logstash.conf
├── pom.xml
├── scripts/
│   ├── run-and-capture.sh
│   └── simulate-calculations.sh
└── src/
    ├── main/java/com/devops/
    │   ├── Calculator.java
    │   └── Main.java
    └── test/java/com/devops/
        └── CalculatorTest.java
```

## Fonctionnalites de l'application

La calculatrice expose 4 operations :

- addition
- soustraction
- multiplication
- division avec exception si division par zero

Exemples :

```bash
mvn clean package
java -jar target/calculator-devops.jar 10 + 5
java -jar target/calculator-devops.jar 8 '*' 4
java -jar target/calculator-devops.jar 10 / 0
```

Sorties attendues :

```text
Resultat : 15.0
CALC_EVENT {"timestamp":"...","status":"SUCCESS","operation":"+","left_operand":10.0,"right_operand":5.0,"result":15.0}
```

```text
Erreur : Division par zéro impossible
CALC_EVENT {"timestamp":"...","status":"ERROR","operation":"/","left_operand":10.0,"right_operand":0.0,"error":"Division par zéro impossible"}
```

La ligne `CALC_EVENT` est volontairement structuree pour faciliter l'ingestion dans Logstash et la visualisation dans Kibana.

## Tests locaux

Compilation :

```bash
mvn compile
```

Tests :

```bash
mvn test
```

Packaging :

```bash
mvn package
```

## Docker

Build local :

```bash
mvn -DskipTests clean package
docker build -t calculator-devops:local .
```

Execution locale :

```bash
docker run --rm calculator-devops:local 15 - 3
docker run --rm calculator-devops:local 10 / 0
```

L'image utilise `eclipse-temurin:17-jre-alpine` et lance directement le `.jar` avec :

```dockerfile
ENTRYPOINT ["java", "-jar", "/app.jar"]
```

## Pipeline GitHub Actions

Le workflow [`.github/workflows/ci.yml`](/home/user/Bureau/Calculator-DevOps-IIBS/.github/workflows/ci.yml) contient 4 jobs :

1. `Job 1 - Compile And Test`
2. `Job 2 - Package And Publish Jar To Nexus`
3. `Job 3 - Build And Push Docker Image`
4. `Job 4 - Deploy Validation`

Regles :

- le pipeline se declenche sur `push` vers `main` et `develop`,
- il se declenche aussi sur `pull_request` vers `main` et `develop`,
- si les tests echouent, les jobs de publication ne s'executent pas,
- l'image Docker est poussee avec les tags `v1.0`, `1.0.<run_number>` et `sha-<commit_sha>`.

## Secrets GitHub requis

- `DOCKERHUB_USERNAME`
- `DOCKERHUB_TOKEN`
- `NEXUS_USERNAME`
- `NEXUS_PASSWORD`
- `NEXUS_SNAPSHOT_URL`
- `NEXUS_RELEASE_URL`

## Publication Nexus

Le projet utilise `mvn deploy` avec `distributionManagement` dans [pom.xml](/home/user/Bureau/Calculator-DevOps-IIBS/pom.xml).

La version Maven injectee dans la pipeline est :

```text
1.0.<github.run_number>-SNAPSHOT
```

Cela permet d'obtenir des artefacts versionnes dans Nexus sans ecraser les executions precedentes.

## Monitoring ELK

Demarrage de la stack :

```bash
docker compose up -d
```

Cette commande lance :

- Elasticsearch sur `http://localhost:9200`
- Kibana sur `http://localhost:5601`
- Logstash avec la pipeline [elk/logstash/pipeline/logstash.conf](/home/user/Bureau/Calculator-DevOps-IIBS/elk/logstash/pipeline/logstash.conf)

## Simulation des calculs pour Kibana

Le script [scripts/simulate-calculations.sh](/home/user/Bureau/Calculator-DevOps-IIBS/scripts/simulate-calculations.sh) :

- package l'application Maven,
- build l'image Docker locale,
- lance plusieurs calculs dans le conteneur,
- enregistre les sorties dans `elk/logs/*.log`.

Execution :

```bash
./scripts/simulate-calculations.sh
```

Pour capturer une execution manuelle unique :

```bash
LOG_FILE=elk/logs/manual-demo.log ./scripts/run-and-capture.sh calculator-devops:local 12 + 7
```

## Visualisations Kibana a creer

Index pattern :

```text
calculator-logs-*
```

Visualisations recommandees :

1. Bar chart `Operations par type`
2. Metric `Nombre d'erreurs`
3. Line chart `Activite dans le temps`

Champs utiles :

- `operation.keyword`
- `status.keyword`
- `error.keyword`
- `@timestamp`

Exemple de filtre KQL pour les erreurs de division par zero :

```text
status.keyword : "ERROR" and operation.keyword : "/"
```

## Scenario de demo live

1. Push sur GitHub.
2. Montrer l'execution des 4 jobs GitHub Actions.
3. Verifier le `.jar` publie dans Nexus.
4. Verifier l'image publiee sur DockerHub.
5. Lancer `docker compose up -d`.
6. Executer `./scripts/simulate-calculations.sh`.
7. Ouvrir Kibana et afficher les 3 visualisations.

## Strategie Git conseillée

- `main` pour la version stable
- `develop` pour l'integration
- branches feature pour chaque evolution

Exemples de commits :

- `feat: add calculator operations`
- `test: add junit coverage for divide by zero`
- `ci: add github actions pipeline`
- `chore: add elk stack for log monitoring`
