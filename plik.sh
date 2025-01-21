#!/bin/bash

# Konfiguracja
BASE_URL="https://github.com/gatling/gatling-js/releases/download"
DEFAULT_VERSION="v3.13.105"
DEFAULT_FILENAME="gatling-js-bundle-3.13.105-Windows%20NT-x64.zip"

# Funkcje logowania
log_error() {
  echo "[ERROR] $1" >&2
  exit 1
}

log_info() {
  echo "[INFO] $1"
}

# Funkcja pobierania i instalacji pliku za pomocą npm
download_and_install() {
  local version=$1
  local filename=${2:-$DEFAULT_FILENAME}
  local url="$BASE_URL/$version/$filename"

  log_info "Pobieranie pliku $filename z $url..."
  curl -L -o "$filename" "$url" || log_error "Błąd podczas pobierania pliku $filename."

  log_info "Instalacja pakietu $filename za pomocą npm..."
  npm install "$filename" || log_error "Błąd podczas instalacji pakietu npm z pliku $filename."

  log_info "Pakiet $filename został pomyślnie zainstalowany."
}

# Główna funkcja
main() {
  local version=${1:-$DEFAULT_VERSION}
  local filename=${2:-$DEFAULT_FILENAME}

  # Pobranie i instalacja pakietu
  download_and_install "$version" "$filename"
}

# Uruchomienie skryptu
main "$@"
