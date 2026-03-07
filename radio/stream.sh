#!/bin/bash

# 1. Config laden
CONF="/opt/musik_konverter/radio.conf"
if [ -f "$CONF" ]; then
    source "$CONF"
    echo "Config geladen: IP=$MY_IP"
else
    echo "FEHLER: Config unter $CONF nicht gefunden!"
    exit 1
fi

# Fallback
MY_PASS=${MY_PASS:-"passwort_fehlt"}
MY_IP=${MY_IP:-"192.168.0.205"}

MUSIC_DIR="/opt/musik_konverter/downloads"
CURRENT_SONG_FILE="/opt/musik_konverter/radio/current_song.txt"

# --- AB HIER STARTET DER RELEVANTE BLOCK ---
while true; do
    # Lied aussuchen
    song=$(find "$MUSIC_DIR" -maxdepth 1 -type f \( -iname "*.mp3" -o -iname "*.mp4" -o -iname "*.mkv" -o -iname "*.m4a" \) | shuf -n 1)

    if [ -z "$song" ]; then
        echo "Warte auf Musik..."
        sleep 5
        continue
    fi

    # TITEL-ANZEIGE AKTUALISIEREN (VOR DEM STREAM)
    TITLE=$(basename "$song")
    echo "$TITLE" > "$CURRENT_SONG_FILE"
    echo "Sende: $TITLE"

    # URL zusammenbauen
    STREAM_URL="icecast://source:${MY_PASS}@${MY_IP}:8000/live-stream"
    
    # FFmpeg Stream starten
    ffmpeg -re -nostdin -i "$song" -metadata title="$TITLE" -acodec libmp3lame -ab 128k -ac 2 -ar 44100 -f mp3 "$STREAM_URL"

    # 1 Sekunde Pause, dann geht die Schleife von vorne los
    sleep 1
done
# --- HIER ENDET DER BLOCK ---
