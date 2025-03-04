# Watchtower Stack
## Beschreibung
Watchtower sorgt für automatische Updates aller Docker-Container.

## Nutzung
### Mit Docker-Compose:
```bash
cd watchtower
docker-compose up -d
```

### Mit Portainer:
1. **Portainer öffnen**
2. **Stacks → Add Stack → Git Repository**
3. **Repository-URL:** `https://github.com/YOUR_GITHUB_USERNAME/docker-stacks.git`
4. **Pfad auswählen:** `/watchtower`
5. **Deploy klicken!**

## Konfiguration
- `WATCHTOWER_CLEANUP=true` entfernt alte Images automatisch.
- `WATCHTOWER_POLL_INTERVAL=86400` prüft einmal am Tag auf neue Versionen.
- `WATCHTOWER_INCLUDE_STOPPED=true` aktualisiert auch gestoppte Container.
