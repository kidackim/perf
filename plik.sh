# Konfiguracja
$PackageJsonPath = "package.json" # Ścieżka do pliku package.json
$BaseUrl = "https://github.com/gatling/gatling-js/releases/download"
$OutputDir = "$PSScriptRoot" # Katalog, w którym zapiszesz plik

# Funkcja logowania błędów
function Log-Error {
    param ([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor Red
    exit 1
}

# Funkcja logowania informacji
function Log-Info {
    param ([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor Green
}

# Sprawdzanie, czy plik package.json istnieje
if (-not (Test-Path -Path $PackageJsonPath)) {
    Log-Error "Nie znaleziono pliku package.json w lokalizacji: $PackageJsonPath"
}

# Odczytywanie package.json
Log-Info "Odczytywanie pliku package.json..."
$PackageJsonContent = Get-Content -Path $PackageJsonPath -Raw | ConvertFrom-Json

# Pobieranie wersji @gatling.io/cli
$GatlingVersion = $PackageJsonContent.dependencies."@gatling.io/cli"
if (-not $GatlingVersion) {
    Log-Error "Nie znaleziono wpisu dla @gatling.io/cli w pliku package.json."
}

Log-Info "Znaleziono wersję @gatling.io/cli: $GatlingVersion"

# Tworzenie URL do pobrania pliku
$VersionTag = "v$($GatlingVersion.TrimStart('^'))"
$FileName = "gatling-js-bundle-$($VersionTag)-Windows_NT-x64.zip"
$DownloadUrl = "$BaseUrl/$VersionTag/$FileName"
$OutputFilePath = Join-Path -Path $OutputDir -ChildPath $FileName

Log-Info "URL do pobrania: $DownloadUrl"
Log-Info "Plik zostanie zapisany jako: $OutputFilePath"

# Pobieranie pliku
Log-Info "Rozpoczynanie pobierania pliku..."
Invoke-WebRequest -Uri $DownloadUrl -OutFile $OutputFilePath -UseBasicParsing -ErrorAction Stop

if (-not (Test-Path -Path $OutputFilePath)) {
    Log-Error "Nie udało się pobrać pliku: $OutputFilePath"
}

Log-Info "Pomyślnie pobrano plik: $OutputFilePath"

# Instalacja za pomocą npx gatling install
Log-Info "Instalacja pliku za pomocą npx gatling install..."
$npxCommand = "npx gatling install $OutputFilePath"
Invoke-Expression $npxCommand

if ($LASTEXITCODE -ne 0) {
    Log-Error "Wystąpił błąd podczas instalacji pliku za pomocą npx gatling install."
}

Log-Info "Pomyślnie zainstalowano plik za pomocą npx gatling install."
