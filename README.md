# Calculator DevOps

Application calculatrice Java SE avec pipeline CI/CD complet.

## Prérequis
- Java 17
- Maven 3.8+
- Docker & Docker Compose

## Utilisation locale

```bash
mvn package
java -jar target/calculator-1.0.jar 10 + 5
java -jar target/calculator-1.0.jar 10 / 0
```

## Tests

```bash
mvn test
```

---

## UC-013 — Stack ELK avec Docker Compose

### Description
Mise en place d'une stack de monitoring complète avec **Elasticsearch**, **Logstash** et **Kibana** via Docker Compose. Les logs générés par la calculatrice sont collectés en temps réel et indexés dans Elasticsearch.

### Architecture

```
Calculatrice Java
      │
      │ logs JSON (TCP port 5000)
      ▼
   Logstash  ──────────────────►  Elasticsearch
(grok parsing)                   (index calculator-logs-*)
                                        │
                                        ▼
                                     Kibana
                                  (port 5601)
```

### Fichiers créés

| Fichier | Rôle |
|---------|------|
| `docker-compose.yml` | Définit les 4 services : elasticsearch, logstash, kibana, calculator |
| `elk/logstash/pipeline/calculator.conf` | Pipeline Logstash : parsing grok des logs Java |
| `elk/logstash/config/logstash.yml` | Configuration de base Logstash |
| `elk/run-calculations.sh` | Script qui lance 10 calculs et envoie les logs vers Logstash |

### Services Docker Compose

| Service | Image | Port | Rôle |
|---------|-------|------|------|
| `elasticsearch` | `elasticsearch:8.13.0` | 9200 | Stockage et indexation des logs |
| `logstash` | `logstash:8.13.0` | 5000 | Collecte et parsing des logs |
| `kibana` | `kibana:8.13.0` | 5601 | Visualisation |
| `calculator` | `eclipse-temurin:17-jre-alpine` | — | Lance les calculs et génère les logs |

### Démarrer la stack

```bash
# Démarrer Elasticsearch + Logstash + Kibana
docker-compose up -d elasticsearch logstash kibana

# Vérifier que les conteneurs sont UP
docker ps
```

### Lancer les calculs (génère les logs)

```bash
# Script complet (10 calculs : additions, soustractions, multiplications, divisions, erreurs)
docker-compose run --rm calculator

# Calcul unique
docker-compose run --rm --entrypoint "java -jar /app/calculator-1.0.jar 10 + 5" calculator
docker-compose run --rm --entrypoint "java -jar /app/calculator-1.0.jar 6 * 7" calculator
docker-compose run --rm --entrypoint "java -jar /app/calculator-1.0.jar 10 / 0" calculator
```

### Pipeline Logstash (`elk/logstash/pipeline/calculator.conf`)

Le pipeline écoute sur le **port TCP/UDP 5000** et parse les messages JSON avec des patterns **grok** :

- Messages `Resultat` → champ `log_type = result` avec extraction de `operation`, `operand_a`, `operand_b`, `result`
- Messages `Erreur` → champ `log_type = error` (erreurs division par zéro)
- Autres → champ `log_type = info`

Les documents sont indexés dans Elasticsearch sous l'index `calculator-logs-YYYY.MM.dd`.

### Arrêter la stack

```bash
docker-compose down
```

---

## UC-015 — Dashboard Kibana

### Description
Création d'un dashboard de monitoring avec **3 visualisations** dans Kibana qui affichent en temps réel les statistiques des calculs effectués par la calculatrice.

### Visualisations

| # | Titre | Type | Contenu |
|---|-------|------|---------|
| Viz 1 | Opérations par type (Bar Chart) | Histogram | Nombre d'opérations par type (`+`, `-`, `*`, `/`) |
| Viz 2 | Erreurs Division par Zéro (Counter) | Lens Metric | Compteur des erreurs `log_type = error` |
| Viz 3 | Volume d'exécutions par heure (Line Chart) | Line | Nombre de calculs dans le temps |

### Importer le dashboard

Le dashboard est exporté dans `elk/kibana/dashboard-calculator.ndjson` et peut être importé dans Kibana :

1. Ouvrir Kibana sur **http://localhost:5601**
2. Aller dans **Stack Management → Saved Objects**
3. Cliquer sur **Import**
4. Sélectionner le fichier `elk/kibana/dashboard-calculator.ndjson`
5. Cliquer sur **Import** puis **Done**

Ou via l'API Kibana :

```bash
curl -X POST "http://localhost:5601/api/saved_objects/_import?overwrite=true" \
  -H "kbn-xsrf: true" \
  --form file=@elk/kibana/dashboard-calculator.ndjson
```

### Accéder au dashboard

Une fois importé, le dashboard est accessible sur :

```
http://localhost:5601/app/dashboards#/view/dashboard-calculator
```

### Résultat attendu

Après avoir lancé `docker-compose run --rm calculator` :

- **Viz 1** : Bar chart avec 4 barres (6 additions, 5 multiplications, 4 divisions, 2 soustractions)
- **Viz 2** : Compteur rouge affichant **3** (les 3 erreurs de division par zéro)
- **Viz 3** : Courbe montrant les 10 exécutions dans le temps
