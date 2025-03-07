# Docker Stacks für Home Server

Dieses Repository enthält verschiedene Docker-Stacks für den Heimserver.  
Jeder Stack ist in einem eigenen Ordner organisiert und kann mit Portainer oder Docker-Compose verwaltet werden.

## Enthaltene Stacks:
- 🛡️ **AdGuard Home + Unbound**
- 📊 **InfluxDB + Grafana (Monitoring)**
- 📡 **Eclipse Mosquitto (MQTT)**
- 🔌 **KNX-Dienst (knxd)**
- 🧑‍💻 **Portainer**
- 🔄 **Watchtower (Automatische Updates für alle Container)**

## 📌 Nutzung mit Portainer
1. **Portainer öffnen**
2. **Stacks → Add Stack → Git Repository**
3. **Repository-URL einfügen:**
   `https://github.com/YOUR_GITHUB_USERNAME/docker-stacks.git`
4. **Passenden Stack-Ordner auswählen (z. B. `/stacks/adguard-home`)**
5. **Deploy klicken!**

## 📌 Manuelle Nutzung mit Docker-Compose
Falls du Portainer nicht nutzt, kannst du das Repo klonen und manuell starten:

```bash
git clone https://github.com/YOUR_GITHUB_USERNAME/docker-stacks.git
cd stacks/adguard-home
docker-compose up -d
```

## 🔄 Automatische Updates mit Watchtower
Falls du möchtest, dass **alle Container automatisch aktualisiert werden**, starte den Watchtower-Stack:

```bash
cd watchtower
docker-compose up -d
```

## 🔐 Secrets und ENV-Variablen
Alle sensitiven Daten (wie Passwörter oder API-Keys) sollten in **ENV-Variablen** oder **Secrets** gespeichert werden, um die Sicherheit zu gewährleisten.  
Die **ENV-Variablen** für jeden Stack können in den `.env`-Dateien innerhalb der jeweiligen Stack-Ordner angepasst werden. Diese Dateien werden **nicht** in das Repository hochgeladen und müssen lokal gespeichert werden.

## 📝 Weitere Hinweise
- 🛡️ **AdGuard Home + Unbound**: Dieser Stack sorgt für DNS-Filtering (AdGuard Home) und rekursive DNS-Auflösung (Unbound).
- 📊 **InfluxDB + Grafana**: Zur Erfassung und Visualisierung von Metriken.
- 📡 **Eclipse Mosquitto**: MQTT-Broker für IoT-Anwendungen.
- 🔌 **KNX-Dienst (knxd)**: Verbindung zu KNX-basierten Heimautomatisierungssystemen.
- 🔄 **Watchtower**: Hält alle Container auf dem neuesten Stand, indem es regelmäßig nach Updates sucht.

Stelle sicher, dass du die `.env`-Dateien nach deinen Bedürfnissen anpasst und die entsprechenden Secrets für jeden Stack einrichtest.

## 📂 Verzeichnisstruktur

Die Struktur des Repositories ist so aufgebaut, dass jeder Stack (Docker-Container) seine eigene Konfiguration und Docker-Compose-Datei hat. Dadurch kannst du jeden Stack unabhängig von den anderen starten und verwalten. Die wichtigsten Ordner und Dateien im Root-Verzeichnis sind:

### **Root-Verzeichnis**
- **`docker-compose.yml`**: Diese Datei ist die zentrale Verwaltungseinheit, falls du mehrere Stacks gleichzeitig verwalten möchtest. Du kannst sie verwenden, um alle Stacks gemeinsam zu starten, indem du die einzelnen Docker-Compose-Dateien der jeweiligen Stacks referenzierst. Diese Datei ist optional und dient vor allem der zentralen Verwaltung.
- **`.gitignore`**: Ignoriert alle nicht relevanten Dateien, wie `.env` und andere temporäre oder sensible Dateien, die nicht ins Repository hochgeladen werden sollten.
- **`README.md`**: Die Dokumentation des Projekts, in der die Nutzung, die Verzeichnisstruktur und andere relevante Informationen erklärt werden.

### **`stacks/`-Verzeichnis**
- **`/stacks/adguard-home/`**: Enthält die `docker-compose.yml`-Datei für den AdGuard Home + Unbound Stack und alle dazugehörigen Konfigurationsdateien. Diese Ordnerstruktur ist für jeden Stack individuell.
- **`/stacks/influxdb/`**: Enthält die `docker-compose.yml`-Datei und Konfigurationsdateien für den InfluxDB-Stack.
- **`/stacks/grafana/`**: Enthält die `docker-compose.yml`-Datei und Konfigurationsdateien für den Grafana-Stack.
- Jeder Stack-Ordner enthält eine eigene **`docker-compose.yml`**-Datei, um den jeweiligen Container zu verwalten, sowie **`config/`**-Ordner für Konfigurationsdateien, die für den Stack benötigt werden.

### **`secrets/`-Verzeichnis**
- **`/secrets/`**: Enthält geheime Umgebungsvariablen und andere sensible Informationen. Diese Dateien werden **nicht** in GitHub hochgeladen, sondern sollten lokal gespeichert und sicher verwaltet werden.

### **`/stacks/*/config/` und `.env`-Dateien**
- Jeder Stack-Ordner enthält **`config/`**-Ordner für Konfigurationsdateien und eine `.env`-Datei für Stack-spezifische Umgebungsvariablen, die nicht im Repository gespeichert werden, sondern lokal verwaltet werden sollten.

### 📂 Warum eine zentrale `docker-compose.yml` im Root-Verzeichnis?
Die zentrale **`docker-compose.yml`** im Root-Verzeichnis ermöglicht es dir, alle Stacks gleichzeitig zu starten, zu stoppen oder zu verwalten, ohne in die einzelnen Stack-Ordner wechseln zu müssen. Wenn du mehrere Container gleichzeitig betreiben möchtest und gemeinsame Netzwerke oder Volumes nutzt, ist eine zentrale Verwaltung praktisch. Diese Datei verweist auf die jeweiligen `docker-compose.yml`-Dateien in den Stack-Ordnern, um die entsprechenden Dienste zu starten. So kannst du mit einem einzigen Befehl alle Container auf einmal starten.

---

Diese Struktur gibt dir die Flexibilität, die Docker-Stacks sowohl einzeln als auch gemeinsam zu verwalten, je nach Bedarf und Setup.
