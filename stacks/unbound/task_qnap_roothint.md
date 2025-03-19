# Automatisches Update der `root.hints` für Unbound auf QNAP

Dieses Tutorial erklärt, wie du auf deinem **QNAP NAS** eine regelmäßige Aufgabe erstellst, um die **`root.hints`**-Datei für **Unbound** monatlich automatisch zu aktualisieren. Die **`root.hints`**-Datei enthält die IP-Adressen der **Root-Nameserver**, die für die rekursive DNS-Auflösung benötigt werden.

## Voraussetzungen

- Du hast Unbound bereits auf deinem **QNAP NAS** mit Docker eingerichtet.
- Du hast ein Volume für Unbound-Daten, in dem die **`root.hints`**-Datei gespeichert wird.
- Du hast Zugriff auf den **QNAP Task Scheduler**.

## Schritt-für-Schritt Anleitung

### 1. **Erstelle eine benutzerdefinierte Aufgabe im QNAP Task Scheduler**

1. Melde dich bei der **QNAP QTS-Oberfläche** an.
2. Gehe zum **Control Panel** (Systemsteuerung).
3. Wähle im Menü **System** die Option **Task Scheduler**.
4. Klicke auf **Create** (Erstellen), um eine neue Aufgabe hinzuzufügen.

### 2. **Konfiguriere die Aufgabe**

- **Name der Aufgabe**: `Update root.hints`
- **Zeitplan**: **Monatlich am Ersten Montag**.
  - Wähle die Option **Monthly** und dann **Every First Monday**.
  - Stelle sicher, dass die Aufgabe jeden Monat zu diesem Zeitpunkt ausgeführt wird.

### 3. **Erstelle ein benutzerdefiniertes Script**

Im nächsten Schritt musst du das benutzerdefinierte Script hinzufügen, das dafür sorgt, dass die aktuelle **`root.hints`**-Datei regelmäßig heruntergeladen wird. Verwende dafür den folgenden Befehl:

#### Benutzerdefiniertes Script:

```
wget https://www.internic.net/domain/named.root -O /share/CE_CACHEDEV1_DATA/Docker_DATA/volumes/unbound_data/root.hints
```

#### Erklärung des Scripts:

- **`wget`**: Ein Kommandozeilenwerkzeug, mit dem du Dateien von einem Webserver herunterladen kannst.
- **`https://www.internic.net/domain/named.root`**: URL, um die aktuelle **`root.hints`**-Datei herunterzuladen.
- **`-O /share/CE_CACHEDEV1_DATA/Docker_DATA/volumes/unbound_data/root.hints`**: Gibt den Zielpfad auf deinem QNAP NAS an, an dem die Datei gespeichert wird. Ersetze diesen Pfad durch den tatsächlichen Speicherort des Unbound-Volumes auf deinem System.

### 4. **Speichere und aktiviere die Aufgabe**

- Nachdem du das benutzerdefinierte Script hinzugefügt hast, speichere die Aufgabe.
- Stelle sicher, dass die Aufgabe aktiviert ist, damit sie automatisch ausgeführt wird.

### 5. **Überprüfen der Aufgabe**

- Nachdem du die Aufgabe gespeichert und aktiviert hast, kannst du den Task Scheduler verwenden, um sicherzustellen, dass der Task ordnungsgemäß läuft.
- Du kannst die Aufgabe auch manuell ausführen, um zu testen, ob die **`root.hints`**-Datei korrekt heruntergeladen und gespeichert wird.

### 6. **Überprüfe den Download**

Um zu überprüfen, ob die **`root.hints`**-Datei korrekt heruntergeladen wurde, kannst du den Inhalt der Datei auf deinem QNAP NAS überprüfen:

1. Melde dich per SSH auf deinem QNAP NAS an.
2. Überprüfe den Inhalt der **`root.hints`**-Datei:

```
cat /share/CE_CACHEDEV1_DATA/Docker_DATA/volumes/unbound_data/root.hints
```

Du solltest die aktuellen Root-Nameserver-Adressen sehen.

### 7. **Konfiguration von Unbound aktualisieren**

Stelle sicher, dass die **`unbound.conf`** so konfiguriert ist, dass sie die **`root.hints`**-Datei regelmäßig verwendet. In der **`unbound.conf`** sollte die folgende Zeile enthalten sein:

```
server:
  root-hints: "/etc/unbound/custom.conf.d/root.hints"
```

Stelle sicher, dass der Pfad zu deiner **`root.hints`**-Datei korrekt angegeben ist und dass Unbound die Datei beim Starten lädt.

### **Zusammenfassung**

Mit dieser Anleitung hast du eine regelmäßige Aufgabe für dein QNAP NAS erstellt, die sicherstellt, dass die **`root.hints`**-Datei für Unbound jeden Monat automatisch heruntergeladen wird. Dadurch bleibt deine **`root.hints`**-Datei immer auf dem neuesten Stand, was für eine zuverlässige und aktuelle DNS-Auflösung notwendig ist.

Wenn du weitere Fragen oder Probleme hast, lass es mich wissen!
