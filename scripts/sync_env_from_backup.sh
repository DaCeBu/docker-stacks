#!/bin/bash

# Definiere den Pfad zu deinem Backup-Ordner (relativ oder absolut)
BACKUP_FOLDER="/share/CE_CACHEDEV1_DATA/Docker_DATA/secrets"

# Lokaler Zielordner für die .env-Dateien (Projektordner)
LOCAL_SECRET_FOLDER="secrets"

# Überprüfen, ob der Zielordner existiert, wenn nicht, erstelle ihn
if [ ! -d "$LOCAL_SECRET_FOLDER" ]; then
  echo "Erstelle Zielordner: $LOCAL_SECRET_FOLDER"
  mkdir -p $LOCAL_SECRET_FOLDER
fi

# Sicherstellen, dass das Backup-Verzeichnis auf dem QNAP existiert
if [ ! -d "$BACKUP_FOLDER" ]; then
  echo "Das Backup-Verzeichnis existiert nicht: $BACKUP_FOLDER"
  exit 1
fi


# Kopiere alle .env-Dateien vom Backup-Ordner in das Projektverzeichnis
echo "Kopiere die .env-Dateien vom Backup-Ordner $BACKUP_FOLDER nach $LOCAL_SECRET_FOLDER"
cp -r $BACKUP_FOLDER/* $LOCAL_SECRET_FOLDER/

# Bestätige den Abschluss
echo "Umgebungskonfigurationsdateien erfolgreich nachgezogen."

# Zeige die kopierten Dateien im Zielordner an
ls -l $LOCAL_SECRET_FOLDER
