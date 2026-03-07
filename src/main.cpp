#include "httplib.h"
#include <iostream>
#include <fstream>
#include <string>
#include <iterator>
#include <vector>
#include <cstdio>

// Hilfsfunktion zum Ausführen von Systembefehlen
std::string exec(const char* cmd) {
    char buffer[128];
    std::string result = "";
    FILE* pipe = popen(cmd, "r");
    if (!pipe) return "Fehler";
    while (fgets(buffer, sizeof(buffer), pipe) != NULL) {
        result += buffer;
    }
    pclose(pipe);
    if (!result.empty() && result.back() == '\n') result.pop_back();
    return result;
}

int main() {
    httplib::Server svr;

    // 1. Webseite ausliefern
    svr.Get("/", [](const httplib::Request &, httplib::Response &res) {
        std::ifstream ifs("/opt/musik_konverter/templates/index.html");
        if (ifs.is_open()) {
            std::string content((std::istreambuf_iterator<char>(ifs)), (std::istreambuf_iterator<char>()));
            res.set_content(content, "text/html; charset=utf-8");
        } else {
            res.status = 404;
            res.set_content("Fehler: index.html nicht gefunden!", "text/plain");
        }
    });

    // 2. System-Status (CPU, RAM, HDD)
    svr.Get("/sys-status", [](const httplib::Request &, httplib::Response &res) {
        std::string cpu = exec("top -bn1 | grep 'Cpu(s)' | awk '{print $2}'");
        std::string ram = exec("free -m | awk 'NR==2{printf \"%s/%s MB\", $3,$2}'");
        std::string hdd = exec("df -h / | awk 'NR==2{print $5}'");
        
        std::string status = "CPU: " + cpu + "% | RAM: " + ram + " | HDD: " + hdd;
        res.set_content(status, "text/plain; charset=utf-8");
    });

	//skip song
      svr.Get("/skip-song", [](const httplib::Request &, httplib::Response &res) {
    std::cout << "Skip angefordert!" << std::endl;
    // Killt den neuesten FFmpeg Prozess. 
    // Das stream.sh Skript springt dadurch sofort in die nächste Runde der Schleife.
    system("pkill -n ffmpeg"); 
    
    res.set_header("Access-Control-Allow-Origin", "*");
    res.set_content("OK", "text/plain");
});


    // 4. Radio: Aktueller Titel
    svr.Get("/current-song", [](const httplib::Request &, httplib::Response &res) {
        std::ifstream ifs("/opt/musik_konverter/radio/current_song.txt");
        std::string song = "Kein Titel";
        if (ifs.is_open()) { std::getline(ifs, song); }
        res.set_content(song, "text/plain; charset=utf-8");
    });

    // 5. Playlist: Dateien auflisten
    svr.Get("/list-files", [](const httplib::Request &, httplib::Response &res) {
        std::string list = exec("ls -1 /opt/musik_konverter/downloads");
        res.set_content(list, "text/plain; charset=utf-8");
    });

    // 6. Konverter: Download
    svr.Post("/convert", [](const httplib::Request &req, httplib::Response &res) {
        auto url = req.get_param_value("url");
        auto format = req.get_param_value("format");
        if (format.empty()) format = "mp3";

        if (!url.empty()) {
            std::string cmd = "/bin/bash /opt/musik_konverter/scripts/download.sh \"" + url + "\" \"" + format + "\" &";
            system(cmd.c_str());
            res.set_content("Download gestartet...", "text/plain");
        } else {
            res.status = 400;
            res.set_content("Fehler: Keine URL", "text/plain");
        }
    });

    std::cout << "JensHub v3 (System-Monitor) läuft auf Port 5001" << std::endl;
    svr.listen("0.0.0.0", 5001);
    return 0;
}
