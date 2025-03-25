# Unbound DNS-Server Docker-Stack

Dieses Verzeichnis enthält die Docker-Stack-Konfiguration für **Unbound**, einen rekursiven DNS-Server, der als sicherer und privater DNS-Resolver fungiert. Dieser Stack nutzt Docker und Docker Compose, um Unbound in einem Container auszuführen und für DNS-Auflösungen zu verwenden.

## Funktionen

- **Rekursiver DNS-Resolver** zur Auflösung von DNS-Abfragen.
- Unterstützung von **DNS-over-HTTPS (DoH)** und **DNS-over-TLS (DoT)** für sichere und verschlüsselte DNS-Auflösungen.
- **DNSSEC** zur Sicherstellung der Authentizität von DNS-Daten.

## Voraussetzungen

- Docker und Docker Compose müssen auf deinem System installiert sein.
- Ein **GitHub-Repository** oder ein lokales Verzeichnis mit dieser **`docker-compose.yml`**-Datei.
- **Volumes** für persistente Daten (z.B. Konfiguration und Logs).

## Verwendung

### 1. Docker-Compose-Stack

Um den Unbound-Stack zu starten, verwende Docker Compose. Stelle sicher, dass du die folgenden Dateien und Verzeichnisse wie beschrieben eingerichtet hast:

1. Clone das Repository oder kopiere den Stack-Ordner `unbound` in dein Arbeitsverzeichnis.
2. Bearbeite die Konfigurationsdateien, falls nötig (z.B. `unbound.conf`), und stelle sicher, dass die Volumes korrekt gemountet sind.
3. Führe den folgenden Befehl aus, um den Stack zu starten:

```bash
docker-compose up -d
```

### 2. Zugriff auf den DNS-Server

Unbound hört auf Port **53** (Standardport für DNS), sodass du den DNS-Server über die IP des Hosts oder Containers ansprechen kannst.

Beispiel, um von einem anderen System im Netzwerk auf Unbound zuzugreifen:

```bash
dig @192.168.70.6 google.com
```

### 3. Anpassungen

- **DNS-over-HTTPS (DoH)** und **DNS-over-TLS (DoT)**: Du kannst DNS-over-HTTPS oder DNS-over-TLS aktivieren, indem du die entsprechenden Optionen in der `unbound.conf` Datei konfigurierst.
- **Filterlisten**: Falls du Filterlisten verwendest, kannst du diese direkt in der `unbound.conf` Datei eintragen.

## Volumes

Die Volumes für die Konfiguration und Arbeitsdaten von Unbound sind in der **`docker-compose.yml`**-Datei definiert:

```yaml
volumes:
  unbound-data:
    driver: local
  unbound-conf:
    driver: local
```

Die Volumes stellen sicher, dass deine **Konfigurationsdaten** und **Arbeitsdaten** auch nach einem Container-Neustart erhalten bleiben.

### Volume-Pfade:

- **Konfigurationsdateien**: `/opt/unbound/etc/unbound` - Diese Dateien können bearbeitet werden, um zusätzliche Anpassungen vorzunehmen (z.B. die `unbound.conf`).
- **Arbeitsdaten**: `/opt/unbound/var/lib/unbound` - Enthält Arbeitsdateien, die von Unbound verwendet werden (z.B. Cache, Logs).

## root.hints und DNSSEC

### 1. **Erstellen der `root.hints`-Datei**

Die **`root.hints`**-Datei enthält die IP-Adressen der Root-Nameserver und ist notwendig, damit Unbound DNS-Abfragen rekursiv auflösen kann. Du kannst die **`root.hints`**-Datei automatisch herunterladen, indem du einen Cron-Job erstellst oder den folgenden Befehl manuell ausführst:

```bash
wget https://www.internic.net/domain/named.root -O /share/CE_CACHEDEV1_DATA/Docker_DATA/volumes/unbound_data/root.hints
```

Die Datei wird dann in deinem Docker-Volume für Unbound gespeichert.

### 2. **Zertifikate für DNSSEC (root.key)**

Um die DNSSEC-Sicherheit zu aktivieren, musst du den **root.key** Trust Anchor herunterladen. Dies wird mit dem folgenden Befehl im Unbound-Container erledigt:

```bash
docker exec unbound unbound-anchor -a /opt/unbound/etc/unbound/root.key
```

Dieser Befehl lädt die neuesten DNSSEC-Zertifikate und speichert sie in der **`root.key`**-Datei, die dann in der **`unbound.conf`**-Datei verwendet wird.

### 3. **Konfiguration von Unbound**

Stelle sicher, dass deine **`unbound.conf`**-Datei auf die **`root.hints`**- und **`root.key`**-Dateien verweist:

```bash
server:
  root-hints: "/etc/unbound/custom.conf.d/root.hints"
  auto-trust-anchor-file: "/etc/unbound/custom.conf.d/root.key"
```

### 4. **Konfiguration der Unbound-Dateien in `templates/`**

Im **`templates/`**-Ordner des Repositories findest du die folgenden wichtigen Konfigurationsdateien, die ins Unbound-Volume abgelegt werden müssen:

- **`unbound.conf`**: Dies ist die Hauptkonfigurationsdatei für Unbound, in der du grundlegende Servereinstellungen wie DNSSEC und Forwarding konfigurieren kannst.
- **`a-records.conf`**: Diese Datei enthält alle lokalen DNS-Daten wie A-Records für interne Geräte in deinem Netzwerk. Zum Beispiel:

```bash
local-data: "ha.home.decebu.com. IN A 192.168.50.2"
local-data: "media.home.decebu.com. IN A 192.168.40.5"
```

- **`forward-records.conf`**: Diese Datei enthält die DNS-Forwarding-Einstellungen. Hier kannst du die DNS-Server angeben, an die Unbound DNS-Anfragen weiterleiten soll, wenn sie nicht lokal beantwortet werden können. Zum Beispiel:

```bash
forward-zone:
  name: "."
  forward-addr: 1.1.1.1@853  # Cloudflare DNS (DNS-over-TLS)
  forward-addr: 8.8.8.8@853  # Google DNS (DNS-over-TLS)
```

Diese Dateien müssen in das Unbound-Volume eingebunden werden, um sicherzustellen, dass Unbound beim Start die richtigen Konfigurationen lädt.

### 5. **Testen von Unbound**

Verwende den **`dig`**-Befehl, um sicherzustellen, dass Unbound korrekt funktioniert:

```bash
dig @192.168.70.6 google.com
```

Wenn Unbound richtig arbeitet, solltest du die **IP-Adresse von google.com** als Antwort erhalten.

### 6. **Fehlerbehebung**

- **Container startet nicht**: Stelle sicher, dass Docker und Docker Compose korrekt installiert sind. Überprüfe die Logs mit `docker-compose logs`.
- **Web-Oberfläche nicht erreichbar**: Prüfe, ob die richtigen Ports (z.B. 80, 443) weitergeleitet wurden und ob keine anderen Anwendungen diese Ports verwenden.

## Lizenz

Dieses Projekt ist unter der [MIT-Lizenz](LICENSE) lizenziert.
