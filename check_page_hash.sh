#!/bin/bash

URL="https://example.com/tournoi"
STATE_FILE="page_hash.txt"

# Télécharger le contenu de la page
PAGE_CONTENT=$(curl -s "$URL")

# Calculer le hash SHA256
PAGE_HASH=$(echo "$PAGE_CONTENT" | sha256sum | awk '{print $1}')

# Vérifier si le fichier d'état existe
if [ ! -f "$STATE_FILE" ]; then
    echo "$PAGE_HASH" > "$STATE_FILE"
    exit 0
fi

# Lire l'ancien hash
OLD_HASH=$(cat "$STATE_FILE")

# Comparer les hash
if [ "$PAGE_HASH" != "$OLD_HASH" ]; then
    # Mise à jour du fichier d'état
    echo "$PAGE_HASH" > "$STATE_FILE"

    # Envoyer alerte Discord
    MESSAGE="🚨 **Changement détecté sur la page du tournoi !**\n👉 $URL"

    curl -H "Content-Type: application/json" \
         -X POST \
         -d "{\"content\":\"$MESSAGE\"}" \
         "$DISCORD_WEBHOOK_URL"
else
    echo "Pas de changement détecté"
fi
