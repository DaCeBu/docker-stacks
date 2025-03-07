# AdGuard Home Docker-Stack

Dieses Verzeichnis enthält die Docker-Stack-Konfiguration für **AdGuard Home**. **AdGuard Home** ist ein leistungsstarker DNS-Server und Werbeblocker, der als lokal laufender DNS-Server fungiert und Werbung sowie Tracking auf Netzwerkebene blockiert. In diesem Stack wird AdGuard Home in einem Docker-Container betrieben, um den DNS-Verkehr zu filtern und sicherzustellen, dass alle Geräte im Netzwerk eine saubere und sichere DNS-Auflösung erhalten.

## Funktionen

- **DNS-over-HTTPS (DoH)** und **DNS-over-TLS (DoT)** zur sicheren und verschlüsselten DNS-Auflösung.
- Blockierung von Werbung und Trackern auf Netzwerkebene.
- Eine Web-Oberfläche zur Verwaltung und Konfiguration von AdGuard Home.
- Option zur Verwendung von benutzerdefinierten Filterlisten und benutzerdefinierten DNS-Servern.
  
## Voraussetzungen

- Docker und Docker Compose müssen auf deinem System installiert sein.
- Ein **GitHub-Repository** oder ein lokales Verzeichnis mit dieser **`docker-compose.yml`**-Datei.
- **Volumes** für persistente Daten (z.B. Konfiguration und Logs).

## Verwendung

### 1. Docker-Compose-Stack

Um den AdGuard Home Stack zu starten, verwende Docker Compose. Stelle sicher, dass du die folgenden Dateien und Verzeichnisse wie beschrieben eingerichtet hast:

1. Clone das Repository oder kopiere den Stack-Ordner `adguard-home` in dein Arbeitsverzeichnis.
2. Bearbeite die Konfigurationsdateien, falls nötig (z.B. `AdGuardHome.yaml`), und stelle sicher, dass die Volumes korrekt gemountet sind.
3. Führe den folgenden Befehl aus, um den Stack zu starten:

```bash
docker-compose up -d
```

### 2. Zugriff auf die Web-Oberfläche

- Nach dem Start des Containers kannst du die Web-Oberfläche von AdGuard Home über `http://<deine_ip>:80` erreichen.
- Der Adminbereich ist standardmäßig unter `http://<deine_ip>:80` erreichbar. Du kannst die Ports in der `docker-compose.yml`-Datei anpassen.

### 3. Anpassungen

- **DNS-over-HTTPS (DoH)** und **DNS-over-TLS (DoT)**: Du kannst DNS-over-HTTPS oder DNS-over-TLS aktivieren, indem du die entsprechenden Optionen in der `AdGuardHome.yaml` Datei konfigurierst.
- **Filterlisten**: Du kannst benutzerdefinierte Filterlisten in der Web-Oberfläche von AdGuard Home hinzufügen und aktualisieren.

## Volumes

Die Volumes für die Konfiguration und Arbeitsdaten von AdGuard Home sind in der **`docker-compose.yml`**-Datei definiert:

```yaml
volumes:
  adguard-home-work:
    driver: local
  adguard-home-conf:
    driver: local
```

Die Volumes stellen sicher, dass deine **Konfigurationsdaten** und **Arbeitsdaten** auch nach einem Container-Neustart erhalten bleiben.

### Volume-Pfade:

- **Konfigurationsdateien**: `/opt/adguardhome/conf` - Diese Dateien können bearbeitet werden, um zusätzliche Anpassungen vorzunehmen (wie z.B. die `AdGuardHome.yaml`).
- **Arbeitsdaten**: `/opt/adguardhome/work` - Enthält Arbeitsdateien, die von AdGuard Home verwendet werden (z.B. Cache, Logs).

## Beispiel-Konfiguration (`AdGuardHome.yaml`)

Im **`AdGuardHome.yaml`**-Konfigurationsdatei kannst du wichtige Parameter wie DNS-Server, DNS-over-HTTPS (DoH), DNS-over-TLS (DoT) und mehr konfigurieren. Hier ist ein Beispiel:

```yaml
    dns:
      bind_hosts:
        - "0.0.0.0"
      port: 53
      bootstrap_dns:
        - 1.1.1.1
        - 8.8.8.8
      block_ads: true
      dns_over_https:
        enabled: true
        server: "https://dns.google/dns-query"
      dns_over_tls:
        enabled: true
        server: "dns.cloudflare.com"
      log_level: 1
      use_dnssec: true
```

## Fehlerbehebung

- **Container startet nicht**: Stelle sicher, dass Docker und Docker Compose korrekt installiert und konfiguriert sind. Überprüfe die Logs mit `docker-compose logs`.
- **Web-Oberfläche nicht erreichbar**: Prüfe, ob die richtigen Ports (z.B. 80, 443) weitergeleitet wurden und ob keine anderen Anwendungen diese Ports verwenden.

## Lizenz

Dieses Projekt ist unter der [MIT-Lizenz](LICENSE) lizenziert.

