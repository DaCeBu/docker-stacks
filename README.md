# Docker Stacks für Home Server

Dieses Repository enthält verschiedene Docker-Stacks für den Heimserver.
Jeder Stack ist in einem eigenen Ordner organisiert und kann mit Portainer oder Docker-Compose verwaltet werden.

## Enthaltene Stacks:
- **Pi-hole + Unbound**
- **InfluxDB + Grafana (Monitoring)**
- **Eclipse Mosquitto (MQTT)**
- **KNX-Dienst (knxd)**
- **Portainer**
- **Watchtower (Automatische Updates für alle Container)**

## 📌 Nutzung mit Portainer
1. **Portainer öffnen**
2. **Stacks → Add Stack → Git Repository**
3. **Repository-URL einfügen:**
   `https://github.com/YOUR_GITHUB_USERNAME/docker-stacks.git`
4. **Passenden Stack-Ordner auswählen (z. B. `/pihole-unbound`)**
5. **Deploy klicken!**

## 📌 Manuelle Nutzung mit Docker-Compose
Falls du Portainer nicht nutzt, kannst du das Repo klonen und manuell starten:

```bash
git clone https://github.com/YOUR_GITHUB_USERNAME/docker-stacks.git
cd pihole-unbound
docker-compose up -d
```

## 🔄 Automatische Updates mit Watchtower
Falls du möchtest, dass **alle Container automatisch aktualisiert werden**, starte den Watchtower-Stack:

```bash
cd watchtower
docker-compose up -d
```
