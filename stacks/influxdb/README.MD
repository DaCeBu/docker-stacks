# InfluxDB Docker-Stack

Dieses Verzeichnis enthält die Docker-Stack-Konfiguration für **InfluxDB 2.7.1**. **InfluxDB** ist eine Open-Source-Datenbank für Zeitreihen, die speziell für die Speicherung und Analyse von Metriken und Ereignissen entwickelt wurde.

## Funktionen

- **Datenbank für Zeitreihen**: InfluxDB eignet sich hervorragend für die Speicherung von Zeitstempel-basierten Daten.
- **Web-Oberfläche und API**: Ermöglicht die Verwaltung und Interaktion mit der InfluxDB über eine Web-Oberfläche oder API.
- **Einfache Integration**: Kann mit anderen Monitoring-Tools wie **Grafana** zur Visualisierung von Metriken verbunden werden.
  
## Voraussetzungen

- Docker und Docker Compose müssen auf deinem System installiert sein.
- Ein **GitHub-Repository** oder ein lokales Verzeichnis mit dieser **`docker-compose.yml`**-Datei.
- **Volumes** für persistente Daten (z.B. Datenbankdaten).

## Verwendung

### 1. Docker-Compose-Stack

Um den InfluxDB Stack zu starten, verwende Docker Compose. Stelle sicher, dass du die folgenden Dateien und Verzeichnisse wie beschrieben eingerichtet hast:

1. Clone das Repository oder kopiere den Stack-Ordner `influxdb` in dein Arbeitsverzeichnis.
2. Bearbeite die Konfigurationsdateien, falls nötig (z.B. `influxdb.conf`), und stelle sicher, dass die Volumes korrekt gemountet sind.
3. Führe den folgenden Befehl aus, um den Stack zu starten:

```bash
docker-compose up -d
```

### 2. Zugriff auf die Web-Oberfläche

- Nach dem Start des Containers kannst du die Web-Oberfläche von InfluxDB über `http://<deine_ip>:8086` erreichen.
- Der Adminbereich ist standardmäßig unter `http://<deine_ip>:8086` erreichbar. Du kannst die Ports in der `docker-compose.yml`-Datei anpassen.

### 3. Anpassungen

- **Organisation und Bucket**: Du kannst die Organisation und den Bucket in der `docker-compose.yml`-Datei anpassen.
- **InfluxDB-Token**: Stelle sicher, dass du das InfluxDB-Token für den API-Zugriff in der `.env`-Datei festlegst.

## Volumes

Die Volumes für die Daten von InfluxDB sind in der **`docker-compose.yml`**-Datei definiert:

```yaml
volumes:
  influxdb-data:
    driver: local
```

Das Volume stellt sicher, dass deine **Datenbankdaten** auch nach einem Container-Neustart erhalten bleiben.

### Volume-Pfad:

- **Datenbankdaten**: `/var/lib/influxdb2` - Enthält die Zeitreihendaten, die in InfluxDB gespeichert sind.

## Beispiel-Konfiguration (`influxdb.conf`)

In der **`influxdb.conf`**-Konfigurationsdatei kannst du wichtige Parameter wie Authentifizierung, Erhalt von Metriken und vieles mehr konfigurieren. Ein Beispiel könnte so aussehen:

```yaml
[http]
  bind-address = ":8086"
  auth-enabled = true
  log-level = "info"
  write-tracing = false
  flux-enabled = true
```

## Fehlerbehebung

- **Container startet nicht**: Stelle sicher, dass Docker und Docker Compose korrekt installiert und konfiguriert sind. Überprüfe die Logs mit `docker-compose logs`.
- **Web-Oberfläche nicht erreichbar**: Prüfe, ob die richtigen Ports (z.B. 8086) weitergeleitet wurden und ob keine anderen Anwendungen diese Ports verwenden.

## Lizenz

Dieses Projekt ist unter der [MIT-Lizenz](LICENSE) lizenziert.
