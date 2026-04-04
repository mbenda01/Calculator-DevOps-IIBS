#!/bin/sh
# run-calculations.sh
# Lance plusieurs calculs et envoie les logs JSON vers Logstash en TCP

LOGSTASH_HOST="logstash"
LOGSTASH_PORT="5000"
JAR="/app/calculator-1.0.jar"

log_to_logstash() {
  OP="$1"; A="$2"; B="$3"; MSG="$4"
  TS=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
  PAYLOAD="{\"timestamp\":\"$TS\",\"operation\":\"$OP\",\"operand_a\":$A,\"operand_b\":$B,\"message\":\"OP=$OP A=$A B=$B $MSG\"}"
  echo "$PAYLOAD" | nc -w1 "$LOGSTASH_HOST" "$LOGSTASH_PORT" 2>/dev/null || true
}

echo "=== Démarrage des calculs de démonstration ==="

# Additions
for i in 1 2 3; do
  RES=$(java -jar "$JAR" 10 + 5 2>&1)
  log_to_logstash "+" 10 5 "$RES"
  echo "$RES"
  sleep 1
done

# Soustractions
RES=$(java -jar "$JAR" 20 - 8 2>&1)
log_to_logstash "-" 20 8 "$RES"
echo "$RES"
sleep 1

# Multiplications
for i in 1 2; do
  RES=$(java -jar "$JAR" 6 '*' 7 2>&1)
  log_to_logstash "*" 6 7 "$RES"
  echo "$RES"
  sleep 1
done

# Divisions
RES=$(java -jar "$JAR" 15 / 3 2>&1)
log_to_logstash "/" 15 3 "$RES"
echo "$RES"
sleep 1

# Divisions par zéro (erreurs — UC-015 Visualisation 2)
for i in 1 2 3; do
  RES=$(java -jar "$JAR" 10 / 0 2>&1)
  log_to_logstash "/" 10 0 "$RES"
  echo "$RES"
  sleep 1
done

echo "=== Calculs terminés — logs envoyés vers Logstash ==="
