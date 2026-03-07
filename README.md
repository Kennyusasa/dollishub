# Jens Admin Hub - C++ Video & Audio Downloader

Ein extrem schneller und leichtgewichtiger Web-Hub auf C++ Basis (Crow Framework), um YouTube-Videos in verschiedene Audio- und Videoformate zu konvertieren. Optimiert für den Betrieb in einem LXC-Container unter Proxmox.

## Features
- **Live Hardware-Monitoring:** Echtzeit-Anzeige von CPU-Last, RAM-Verbrauch und freiem Festplattenspeicher (GB).
- **Breiter Format-Support:** - **Audio:** MP3, WAV, FLAC, M4A, OPUS.
  - **Video:** MP4, MKV.
- **Integriertes Dateimanagement:** Liste aller Downloads mit Funktionen zum lokalen Speichern und Löschen direkt vom Server.
- **Performance:** Geschrieben in C++17 mit dem Crow Framework für minimale Systemlast.

## Voraussetzungen
Stelle sicher, dass die folgenden Pakete auf deinem Linux-System installiert sind:
- `g++` (mit C++17 Support)
- `yt-dlp` (für den Download und die Konvertierung)
- `ffmpeg` (als Backend für yt-dlp)
- `libpthread` (für Multithreading)

## Installation & Kompilierung

1. **Abhängigkeiten installieren:**
   ```bash
   sudo apt update && sudo apt install g++ yt-dlp ffmpeg -y
