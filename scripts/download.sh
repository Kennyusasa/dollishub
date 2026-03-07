#!/bin/bash

DOWNLOAD_DIR="/opt/musik_konverter/downloads"
URL=$1
FORMAT=$2

if [ -z "$URL" ]; then exit 1; fi
if [ -z "$FORMAT" ]; then FORMAT="mp3"; fi

# Ordner sicherstellen
mkdir -p "$DOWNLOAD_DIR"

if [ "$FORMAT" == "mp4" ] || [ "$FORMAT" == "mkv" ]; then
    # Video Download
    /usr/local/bin/yt-dlp -f "bestvideo+bestaudio/best" \
        --merge-output-format "$FORMAT" \
        -o "$DOWNLOAD_DIR/%(title)s.%(ext)s" "$URL"
else
    # Audio Extraktion
    /usr/local/bin/yt-dlp -x --audio-format "$FORMAT" --audio-quality 0 \
        -o "$DOWNLOAD_DIR/%(title)s.%(ext)s" "$URL"
fi

chmod 644 "$DOWNLOAD_DIR"/*
