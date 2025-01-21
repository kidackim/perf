#!/bin/bash

# Konfiguracja
REPO="gatling/gatling-js-bundle"
DEFAULT_VERSION="1.0.0" # Domyślna wersja
DOWNLOAD_DIR="./gatling-js-bundle" # Katalog docelowy

# Funkcja logowania błędów
log_error() {
  echo "[ERROR] $1" >&2
  exit 1
}

# Funkcja logowania informacji
log_info() {
  echo "[INFO] $1"
}

# Funkcja przygotowania katalogu docelowego
prepare_directory() {
  local dir=$1
  if [ ! -d "$dir" ]; then
    log_info "Katalog $dir nie istnieje. Tworzenie..."
    mkdir -p "$dir" || log_error "Nie udało się utworzyć katalogu $dir."
    log_info "Katalog $dir został utworzony."
  else
    log_info "Katalog $dir istnieje. Usuwanie zawartości..."
    rm -rf "$dir"/* || log_error "Nie udało się usunąć plików z katalogu $dir."
    log_info "Zawartość katalogu $dir została usunięta."
  fi
}

# Funkcja pobierania najnowszej wersji
get_latest_version() {
  log_info "Sprawdzanie najnowszej wersji..."
  local latest_version
  latest_version=$(curl -s "https://api.github.com/repos/$REPO/releases/latest" | jq -r '.tag_name') || log_error "Nie udało się pobrać najnowszej wersji."

  if [[ -z "$latest_version" ]]; then
    log_error "Najnowsza wersja nie została znaleziona."
  fi

  echo "$latest_version"
}

# Funkcja sprawdzania dostępności wersji
check_version_exists() {
  local version=$1
  log_info "Sprawdzanie dostępności wersji: $version..."
  local status_code
  status_code=$(curl -o /dev/null -s -w "%{http_code}" "https://github.com/$REPO/archive/refs/tags/$version.zip") || log_error "Nie można połączyć się z serwerem."

  if [[ "$status_code" -eq 200 ]]; then
    log_info "Wersja $version jest dostępna."
    return 0
  else
    log_info "Wersja $version nie jest dostępna."
    return 1
  fi
}

# Funkcja pobierania i rozpakowywania wersji
download_and_extract() {
  local version=$1
  local download_url="https://github.com/$REPO/archive/refs/tags/$version.zip"
  local zip_file="gatling-js-bundle-$version.zip"

  log_info "Pobieranie wersji $version z $download_url..."
  curl -L -o "$zip_file" "$download_url" || log_error "Błąd podczas pobierania pliku $zip_file."

  log_info "Rozpakowywanie pliku $zip_file do katalogu $DOWNLOAD_DIR..."
  unzip -o "$zip_file" -d "$DOWNLOAD_DIR" || log_error "Błąd podczas rozpakowywania pliku $zip_file."

  log_info "Wersja $version została pomyślnie pobrana i rozpakowana."
}

# Główna funkcja
main() {
  local version=${1:-$DEFAULT_VERSION}

  # Przygotowanie katalogu docelowego
  prepare_directory "$DOWNLOAD_DIR"

  # Weryfikacja wersji
  if ! check_version_exists "$version"; then
    log_info "Domyślna wersja $version nie jest dostępna. Pobieranie najnowszej wersji..."
    version=$(get_latest_version)
  fi

  # Pobieranie i rozpakowywanie
  download_and_extract "$version"
}

# Uruchomienie skryptu
main "$@"
