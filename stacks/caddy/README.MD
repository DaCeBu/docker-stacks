# Caddy Docker-Stack

Dieses Verzeichnis enthält die Docker-Stack-Konfiguration für **Caddy**, einen leistungsstarken Webserver und Reverse Proxy, der als **HTTPS-TLS-Proxy** und **DNS-Server** fungiert. Caddy wird in einem Docker-Container betrieben und kümmert sich um die sichere Verbindung zu lokalen Geräten und Diensten im Heimnetzwerk.

## Funktionen

- **HTTPS für lokale Dienste**: Caddy stellt Zertifikate über **Let's Encrypt** zur Verfügung, um die Kommunikation über HTTPS zu sichern.
- **Reverse Proxy**: Caddy leitet Anfragen an interne Dienste wie **HA Server** oder **Mediaserver** weiter.
- **DNS-Server**: Caddy kann in Kombination mit **Unbound** verwendet werden, um DNS-Anfragen für lokale Domains wie `ha.home.decebu.com` oder `media.home.decebu.com` aufzulösen.

## Wie funktioniert Caddy mit Unbound?

- **Unbound** fungiert als **DNS-Server** für das gesamte Heimnetzwerk. Alle Geräte im Netzwerk, einschließlich der Geräte im Subnetz **`192.168.50.0/24`** und **`192.168.40.0/24`**, greifen auf Unbound für die DNS-Auflösung zu.
- **Unbound** nimmt lokale DNS-Einträge für Geräte wie den **HA Server (192.168.50.2)** und den **Mediaserver (192.168.40.5)** entgegen und leitet diese Anfragen über **Caddy** weiter.
- **Caddy** verwendet **DNS-over-HTTPS** und **DNS-over-TLS** für die Kommunikation mit externen DNS-Diensten wie **Cloudflare**, um die Sicherheit der Verbindungen zu gewährleisten.
- Durch die Kombination von **Unbound** und **Caddy** werden DNS-Anfragen für **interne Domains** über **Unbound** aufgelöst und dann über **Caddy** mit HTTPS-Zertifikaten abgesichert.
- **Alle von Caddy aufzulösenden Adressen müssen in Unbound als `local-data` in der `a-records.conf` aufgenommen werden**, wobei als Ziel-IP die **IP-Adresse des Caddy-Containers** gesetzt werden muss.

## Container-Aufbau und Konfiguration

Der **Caddy-Container** wird mit Docker betrieben und erfordert folgende Schritte:

### 1. **Docker-Compose-Datei**

Die Docker-Compose-Datei konfiguriert die **Caddy**-Umgebung und stellt sicher, dass der **Caddy-Container** mit den richtigen Umgebungsvariablen, Volumes und Netzwerken ausgeführt wird. Hier ist eine Beispielkonfiguration:

```yaml
version: "3.8"

services:
  caddy:
    build: ./dockerfile-dns
    container_name: caddy
    hostname: caddy
    restart: unless-stopped
    ports:
      - "80:80"
      - "443:443"
      - "53:53"  # DNS-Port für Caddy
    networks:
      - qnet-static-vlan30
    env_file:
      - ../../secrets/caddy_secrets.env
    volumes:
      - ./Caddyfile:/etc/caddy/Caddyfile:ro
      - caddy-data:/data
      - caddy-conf:/config

networks:
  qnet-static-vlan30:
    external: true

volumes:
  caddy-data:
  caddy-conf:
```

### 2. **Caddyfile-Konfiguration**

Die **Caddyfile** enthält die Konfiguration für die Domains, die **Caddy** verwaltet, sowie die **Reverse Proxy**-Einstellungen und die TLS-Konfiguration.

#### Beispiel Caddyfile für lokale Geräte:

```caddyfile
# HA Server - 192.168.50.2
ha.home.decebu.com {
    reverse_proxy 192.168.50.2:80  # Anfragen an den HA-Server weiterleiten
    tls {
        dns cloudflare {env.CLOUDFLARE_API_TOKEN}
    }
}

# Mediaserver - 192.168.40.5
media.home.decebu.com {
    reverse_proxy 192.168.40.5:80  # Anfragen an den Mediaserver weiterleiten
    tls {
        dns cloudflare {env.CLOUDFLARE_API_TOKEN}
    }
}
```

#### Erklärung:
- **`ha.home.decebu.com`** und **`media.home.decebu.com`** sind die internen Domain-Namen für die lokalen Geräte.
- **`reverse_proxy`** leitet Anfragen an die internen IP-Adressen der Geräte weiter.
- **`tls`** sorgt dafür, dass Caddy über **DNS-over-TLS** mit **Cloudflare** kommuniziert, um die Zertifikate zu erhalten.

### 3. **Unbound-Konfiguration**

Um sicherzustellen, dass Unbound die richtigen lokalen Adressen auflöst, musst du **`local-data`**-Einträge für die Geräte hinzufügen, die von **Caddy** verwaltet werden. Diese Einträge sollten die **IP-Adresse des Caddy-Containers** als Ziel-IP verwenden, da Caddy der Reverse-Proxy für diese Geräte ist.

#### Beispiel für `a-records.conf` in Unbound:

```bash
local-data: "ha.home.decebu.com. IN A 192.168.0.4"  # IP von Caddy
local-data: "media.home.decebu.com. IN A 192.168.0.4"  # IP von Caddy
```

### 4. **Caddy-Container starten**

1. **Clone das Repository** oder kopiere den Stack-Ordner **`caddy`** in dein Arbeitsverzeichnis.
2. Bearbeite die Konfigurationsdateien, wie **`Caddyfile`** und **Umgebungsvariablen** in der Datei **`caddy_secrets.env`**.
3. Führe den folgenden Befehl aus, um den **Caddy-Container** zu starten:

```bash
docker-compose up -d
```

### 5. **Zugriff auf die Web-Oberfläche**

- Nach dem Start des Containers kannst du die Web-Oberfläche von **Caddy** über **`http://<deine_ip>:80`** erreichen.
- Der Adminbereich ist standardmäßig unter **`http://<deine_ip>:80`** erreichbar.

### 6. **Anpassungen in der Caddyfile**

Wenn du weitere Domains oder Konfigurationen hinzufügen möchtest, kannst du die **Caddyfile** anpassen. Achte darauf, dass die **DNS-over-HTTPS**-Konfiguration und die **`reverse_proxy`**-Direktive richtig gesetzt sind.

### 7. **Caddy als DNS-Server für lokale Geräte**

- Du kannst Caddy so konfigurieren, dass er DNS-Anfragen für interne Domains wie **`ha.home.decebu.com`** oder **`media.home.decebu.com`** über **Unbound** weiterleitet.
- Alle Teilnehmer im Heimnetzwerk müssen **Caddy als DNS-Server** verwenden, damit sie auf diese lokalen Domains zugreifen können.

### 8. **Wichtige Schritte zur Fehlerbehebung**

- **Container startet nicht**: Stelle sicher, dass Docker und Docker Compose korrekt installiert sind. Überprüfe die Logs mit `docker-compose logs`.
- **Web-Oberfläche nicht erreichbar**: Prüfe, ob die richtigen Ports (z.B. 80, 443) weitergeleitet wurden und ob keine anderen Anwendungen diese Ports verwenden.


## Links
Diese Vorgehensweise basiert auf folgendem Blog von Helge Klein:
https://helgeklein.com/blog/automatic-https-certificates-for-services-on-internal-home-network-without-opening-firewall-port/

## Lizenz

Dieses Projekt ist unter der [MIT-Lizenz](LICENSE) lizenziert.
