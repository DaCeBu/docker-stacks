#!/bin/bash

# Definiere den Zielordner auf deinem QNAP (wo die Backup-Dateien gespeichert werden sollen)
BACKUP_FOLDER="/share/CE_CACHEDEV1_DATA/Docker_DATA/secrets"

# Lokaler Quellordner für die .env-Dateien (Projektordner)
LOCAL_SECRET_FOLDER="secrets"

# Überprüfen, ob der Quellordner existiert, wenn nicht, erstelle ihn
if [ ! -d "$LOCAL_SECRET_FOLDER" ]; then
  echo "Der Quellordner existiert nicht: $LOCAL_SECRET_FOLDER"
  exit 1
fi

# Sicherstellen, dass das Zielverzeichnis auf dem QNAP existiert
if [ ! -d "$BACKUP_FOLDER" ]; then
  echo "Das Zielverzeichnis existiert nicht auf QNAP: $BACKUP_FOLDER"
  exit 1
fi

# Kopiere alle .env-Dateien vom lokalen Ordner in das Backup-Verzeichnis auf dem QNAP
echo "Kopiere die .env-Dateien vom lokalen Ordner $LOCAL_SECRET_FOLDER nach $BACKUP_FOLDER"
cp -r $LOCAL_SECRET_FOLDER/* $QBACKUP_FOLDER/

# Bestätige den Abschluss
echo "Umgebungskonfigurationsdateien erfolgreich auf den QNAP-Server übertragen."

# Zeige die kopierten Dateien im Zielordner auf QNAP an
ls -l $BACKUP_FOLDER
