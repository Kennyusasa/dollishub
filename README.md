# 🎵 Dollishub - All-in-One Radio & Converter

Ein leistungsstarker C++ Web-Hub für Musik-Streaming, YouTube-Downloads und System-Monitoring.

## 🚀 Features
- **Live Radio:** Streamt Musik direkt von deinem Server über Icecast2.
- **YouTube Converter:** Einfaches Herunterladen und Konvertieren von Videos in die Playlist.
- **Skip-Funktion:** Springe sofort zum nächsten Song (Server-seitiger Signal-Handler).
- **System Monitor:** Echtzeit-Anzeige von CPU-Last, RAM-Verbrauch und HDD-Speicherplatz.
- **HTTPS Ready:** Optimiert für den Betrieb hinter einem Nginx-Reverse-Proxy.

## 🛠 Technik & Voraussetzungen
- **Sprache:** C++ (mit `httplib.h`)
- **Streaming:** FFmpeg & Icecast2
- **Web:** HTML5, CSS3, JavaScript (Vanilla)
- **Proxy:** Nginx mit SSL-Zertifikat

## 📦 Installation & Start
1. Repository klonen.
2. Eine `radio.conf` mit deinen Icecast-Daten erstellen (siehe `.gitignore`).
3. Den C++ Hub kompilieren:
   ```bash
   g++ main.cpp -o jenshub -lpthread
