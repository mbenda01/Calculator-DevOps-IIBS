#!/bin/bash
# simulate_logs.sh - Envoie les logs directement à Logstash via TCP

IMAGE="${1:-mbenda01/java-calculator:v1.0}"
LOGSTASH_HOST="localhost"
LOGSTASH_PORT="5000"
DELAY=0.5

send_log() {
  echo "$1" | timeout 2 nc $LOGSTASH_HOST $LOGSTASH_PORT || true
  echo "📤 Envoyé : $1"
  sleep $DELAY
}

echo "========================================"
echo "  Simulation de logs — java-calculator"
echo "========================================"

# Additions
echo "[+] Additions..."
send_log "Resultat : 15.0"
send_log "Resultat : 300.0"
send_log "Resultat : 10.0"
send_log "Resultat : 100.0"

# Soustractions
echo "[-] Soustractions..."
send_log "Resultat : 12.0"
send_log "Resultat : 55.0"
send_log "Resultat : -5.0"

# Multiplications
echo "[*] Multiplications..."
send_log "Resultat : 32.0"
send_log "Resultat : 36.0"
send_log "Resultat : 0.0"

# Divisions
echo "[/] Divisions..."
send_log "Resultat : 4.0"
send_log "Resultat : 25.0"
send_log "Resultat : 3.5"

# Erreurs
echo "[!] Erreurs..."
send_log "Erreur : Division par zéro impossible"
send_log "Erreur : Division par zéro impossible"
send_log "Erreur : Division par zéro impossible"

echo ""
echo "========================================"
echo "  Simulation terminée !"
echo "   Ouvrez Kibana : http://localhost:5601"
echo "========================================"