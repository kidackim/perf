#!/bin/bash

# Konfiguracja
BASE_URL="https://github.com/gatling/gatling-js/releases/download" # Podstawowy URL
DEFAULT_VERSION="v3.13.105" # Domyślna wersja
DEFAULT_FILENAME="gatling-js-bundle-3.13.105-Windows%20NT-x64.zip" # Domyślna nazwa pliku
TEMP_DIR="./temp-npm-install" # Tymczasowy katalog do przechowywania pliku

# Funkcja logowania błędów
log_error() {
  echo "[ERROR] $1" >&2
  exit 1
}

# Funkcja logowania informacji
log_info() {
  echo "[INFO] $1"
}

# Funkcja budowania pełnego adresu URL z korektą znaków
build_download_url() {
  local version=$1
  local filename=$2
  local raw_url="$BASE_URL\\$version\\$filename"

  # Zastąpienie \ na /
  local corrected_url="${raw_url//\\//}"
  echo "$corrected_url"
}

# Funkcja przygotowania katalogu tymczasowego
prepare_temp_directory() {
  local dir=$1
  if [ ! -d "$dir" ]; then
    log_info "Katalog tymczasowy $dir nie istnieje. Tworzenie..."
    mkdir -p "$dir" || log_error "Nie udało się utworzyć katalogu $dir."
  else
    log_info "Katalog tymczasowy $dir istnieje. Usuwanie zawartości..."
    rm -rf "$dir"/* || log_error "Nie udało się usunąć plików z katalogu $dir."
  fi
}

# Funkcja pobierania pliku
download_file() {
  local url=$1
  local output_path="$TEMP_DIR/$(basename "$url")"

  log_info "Pobieranie pliku z $url..."
  curl -L -o "$output_path" "$url" || log_error "Błąd podczas pobierania pliku z $url."
  echo "$output_path"
}

# Funkcja instalacji NPM bezpośrednio z pliku ZIP
install_from_zip() {
  local zip_path=$1

  log_info "Instalacja pakietu z pliku $zip_path za pomocą npm..."
  npm install "$zip_path" || log_error "Błąd podczas instalacji pakietu npm z pliku $zip_path."
  log_info "Pakiet został pomyślnie zainstalowany."
}

# Główna funkcja
main() {
  local version=${1:-$DEFAULT_VERSION}
  local filename=${2:-$DEFAULT_FILENAME}

  # Przygotowanie katalogu tymczasowego
  prepare_temp_directory "$TEMP_DIR"

  # Zbudowanie adresu URL z korektą znaków
  local url
  url=$(build_download_url "$version" "$filename")

  # Pobranie pliku ZIP
  local zip_path
  zip_path=$(download_file "$url")

  # Instalacja pakietu bezpośrednio z pliku ZIP
  install_from_zip "$zip_path"
}

# Uruchomienie skryptu
main "$@"
