#include "crow_all.h"
#include <fstream>
#include <iostream>

int main() {
    crow::SimpleApp app;

    // Startseite
    CROW_ROUTE(app, "/")([](){
        std::ifstream file("templates/index.html");
        std::string content((std::istreambuf_iterator<char>(file)), std::istreambuf_iterator<char>());
        return crow::response(content);
    });

    // Statische Dateien (NUR DIESER EINE EINTRAG!)
    CROW_ROUTE(app, "/static/<path>")([](std::string path){
        crow::response res;
        res.set_static_file_info("static/" + path);
        return res;
    });

    // Hardware API
    CROW_ROUTE(app, "/api/stats")([](){
        crow::json::wvalue x;
        x["status"] = "online";
        x["cpu"] = 5.0;
        return x;
    });

    std::cout << "--- STARTVERSUCH ---" << std::endl;
    app.port(5001).multithreaded().run();
}
