#!/bin/bash

# Pfad zur geheimen Konfigurationsdatei
CONF_FILE="/opt/musik_konverter/radio.conf"

# Prüfen, ob die Datei da ist, und dann einlesen
if [ -f "$CONF_FILE" ]; then
    source "$CONF_FILE"
else
    echo "Fehler: $CONF_FILE nicht gefunden!"
    exit 1
fi

MUSIC_DIR="/opt/musik_konverter/downloads"
CURRENT_SONG_FILE="/opt/musik_konverter/radio/current_song.txt"

# Hier nutzen wir jetzt die Variablen aus der radio.conf
ICECAST_URL="icecast://source:${MY_PASS}@${MY_IP}:8000/live-stream"

# Rest bleibt gleich...
trap "pkill -n ffmpeg" SIGUSR1


while true; do
    # Suche alle Formate
    songs=($(find "$MUSIC_DIR" -maxdepth 1 -type f \( -iname "*.mp3" -o -iname "*.mp4" -o -iname "*.mkv" -o -iname "*.flac" -o -iname "*.wav" -o -iname "*.m4a" \)))
    
    if [ ${#songs[@]} -eq 0 ]; then
        echo "Warte auf Musik..."
        sleep 5
        continue
    fi

    # Zufälligen Song wählen
    song=$(printf "%s\n" "${songs[@]}" | shuf -n 1)
    echo "$(basename "$song")" > "$CURRENT_SONG_FILE"
    
    echo "Spiele: $song"

    # FFmpeg startet den Stream
    ffmpeg -re -i "$song" -acodec libmp3lame -ab 128k -ac 2 -ar 44100 -f mp3 "$ICECAST_URL"

    # WICHTIG: Kurze Pause, damit Icecast den Mountpoint sauber schließt
    sleep 2
done
