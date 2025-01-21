#!/bin/bash

# Konfiguracja
BASE_URL="https://github.com/gatling/gatling-js/releases/download" # Podstawowy URL
DEFAULT_VERSION="v3.13.105" # Domyślna wersja
DEFAULT_FILENAME="gatling-js-bundle-3.13.105-Windows NT-x64.zip" # Domyślna nazwa pliku
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

# Funkcja kodowania URL
url_encode() {
  local raw_url=$1
  local encoded_url=""
  local char

  for (( i=0; i<${#raw_url}; i++ )); do
    char="${raw_url:$i:1}"
    case "$char" in
      [a-zA-Z0-9.~_-]) encoded_url+="$char" ;;  # Nie trzeba kodować tych znaków
      *) encoded_url+=$(printf '%%%02X' "'$char") ;;  # Kodowanie znaków specjalnych
    esac
  done
  echo "$encoded_url"
}

# Funkcja budowania pełnego adresu URL z kodowaniem znaków
build_download_url() {
  local version=$1
  local filename=$2

  # Kodowanie nazwy pliku
  local encoded_filename
  encoded_filename=$(url_encode "$filename")
  local full_url="$BASE_URL/$version/$encoded_filename"
  echo "$full_url"
}

# Funkcja sprawdzania poprawności adresu URL
verify_url() {
  local url=$1
  log_info "Weryfikacja URL: $url"
  local http_status
  http_status=$(curl -o /dev/null -s -w "%{http_code}" "$url")

  if [[ "$http_status" -eq 200 ]]; then
    log_info "URL jest poprawny: $url"
    return 0
  else
    log_error "URL jest nieprawidłowy lub plik nie istnieje. Status HTTP: $http_status"
    return 1
  fi
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

  # Zbudowanie adresu URL z kodowaniem znaków
  local url
  url=$(build_download_url "$version" "$filename")

  # Weryfikacja adresu URL
  verify_url "$url" || exit 1

  # Pobranie pliku ZIP
  local zip_path
  zip_path=$(download_file "$url")

  # Instalacja pakietu bezpośrednio z pliku ZIP
  install_from_zip "$zip_path"
}

# Uruchomienie skryptu
main "$@"
