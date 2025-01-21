# Configuration
$PackageJsonPath = "package.json" # Path to package.json file
$BaseUrl = "https://github.com/gatling/gatling-js/releases/download"
$OutputDir = "$PSScriptRoot" # Directory to save the file

# Function for error logging
function Log-Error {
    param ([string]$Message)
    Write-Error "[ERROR] $Message"
    exit 1
}

# Function for info logging
function Log-Info {
    param ([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor Green
}

# Verify if package.json exists
if (-not (Test-Path -Path $PackageJsonPath)) {
    Log-Error "package.json file not found at: $PackageJsonPath"
}

# Read package.json content
Log-Info "Reading package.json..."
try {
    $PackageJsonContent = Get-Content -Path $PackageJsonPath -Raw | ConvertFrom-Json
} catch {
    Log-Error "Failed to parse package.json. Please ensure it is valid JSON."
}

# Extract @gatling.io/cli version from devDependencies
if ($PackageJsonContent.devDependencies."@gatling.io/cli") {
    $GatlingVersion = $PackageJsonContent.devDependencies."@gatling.io/cli".TrimStart('^')
    Log-Info "Found @gatling.io/cli version: $GatlingVersion"
} else {
    Log-Error "@gatling.io/cli entry not found in devDependencies in package.json."
}

# Build the download URL
$VersionTag = "v$GatlingVersion" # Version tag with 'v'
$FileName = "gatling-js-bundle-$GatlingVersion-Windows_NT-x64.zip" # File name without 'v'
$DownloadUrl = "$BaseUrl/$VersionTag/$FileName"
$OutputFilePath = Join-Path -Path $OutputDir -ChildPath $FileName

Log-Info "Download URL: $DownloadUrl"
Log-Info "File will be saved as: $OutputFilePath"

# Download the file
if (Test-Path -Path $OutputFilePath) {
    Log-Info "File $OutputFilePath already exists. Skipping download."
} else {
    Log-Info "Starting file download..."
    try {
        Invoke-WebRequest -Uri $DownloadUrl -OutFile $OutputFilePath -UseBasicParsing -ErrorAction Stop
        Log-Info "File successfully downloaded: $OutputFilePath"
    } catch {
        Log-Error "Failed to download the file from: $DownloadUrl"
    }
}

# Install using npx gatling install
Log-Info "Installing file using npx gatling install..."
$npxCommand = "npx gatling install $OutputFilePath"
Invoke-Expression $npxCommand

if ($LASTEXITCODE -ne 0) {
    if ($Error[0] -match "already exists") {
        Log-Info "The library already exists. Continuing..."
    } else {
        Log-Error "An error occurred during installation with npx gatling install."
    }
} else {
    Log-Info "File successfully installed using npx gatling install."
}



feat(powershell): Add dynamic script for downloading and installing Gatling JS

- Replaced the previously static inclusion of the Gatling JS bundle in the repository with a dynamic PowerShell script.
- The script automatically retrieves the correct version of @gatling.io/cli from package.json.
- Implements error handling and logging for improved reliability.
- Dynamically constructs the download URL and installs the bundle using `npx gatling install`.
- Modernized for compatibility with PowerShell standards and enhanced maintainability.
