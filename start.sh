#!/bin/bash

# Starten des Python-Skripts
echo "Starte Python Backend..."
python3 app/app.py &

# Warten, damit das Backend starten kann
sleep 5

# Starten der Flutter-App
echo "Starte Flutter App in Chrome..."
cd diplomprojekt/
flutter run -d chrome

# Beenden der Hintergrundprozesse beim Beenden des Skripts
trap "exit" INT TERM ERR
trap "kill 0" EXIT
