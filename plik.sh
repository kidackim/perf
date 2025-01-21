#!/bin/bash

# URL pliku do pobrania
FILE_URL="https://github.com/gatling/gatling-js/releases/download/v3.13.105/gatling-js-bundle-3.13.105-Windows_NT-x64.zip"

# Ścieżka, gdzie plik zostanie zapisany
DOWNLOAD_DIR="$PWD"  # Aktualny katalog roboczy
OUTPUT_FILE="$DOWNLOAD_DIR/gatling-js-bundle-3.13.105-Windows_NT-x64.zip"

# Funkcja logowania błędów
log_error() {
  echo "[ERROR] $1" >&2
  exit 1
}

# Funkcja logowania informacji
log_info() {
  echo "[INFO] $1"
}

# Pobieranie pliku za pomocą Chrome w trybie bezgłowym
log_info "Pobieranie pliku $FILE_URL za pomocą Google Chrome..."

google-chrome --headless \
  --disable-gpu \
  --no-sandbox \
  --disable-dev-shm-usage \
  --disable-extensions \
  --disable-logging \
  --window-size=1920,1080 \
  --remote-debugging-port=9222 \
  --user-data-dir="$DOWNLOAD_DIR/chrome-profile" \
  "$FILE_URL" || log_error "Błąd podczas pobierania pliku za pomocą Google Chrome."

# Sprawdzenie, czy plik został pobrany
if [ -f "$OUTPUT_FILE" ]; then
  log_info "Plik został pomyślnie pobrany do: $OUTPUT_FILE"
else
  log_error "Plik nie został pobrany lub nie istnieje w lokalizacji: $OUTPUT_FILE"
fi
