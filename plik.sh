# Configuration
$PackageJsonPath = "package.json" # Path to the package.json file
$BaseUrl = "https://github.com/gatling/gatling-js/releases/download" # Base URL for downloading Gatling bundle
$OutputDir = "$PSScriptRoot" # Directory where the file will be saved

# Function for logging errors
function Log-Error {
    param (
        [string]$Message
    )
    Write-Host "[ERROR] $Message" -ForegroundColor Red
    exit 1
}

# Function for logging informational messages
function Log-Info {
    param (
        [string]$Message
    )
    Write-Host "[INFO] $Message" -ForegroundColor Green
}

# Check if the package.json file exists
if (-not (Test-Path -Path $PackageJsonPath)) {
    Log-Error "The package.json file was not found at the specified location: $PackageJsonPath"
}

# Read and parse the package.json file
Log-Info "Reading the package.json file..."
$PackageJsonContent = try {
    Get-Content -Path $PackageJsonPath -Raw | ConvertFrom-Json
} catch {
    Log-Error "Failed to parse the package.json file. Ensure it is valid JSON."
}

# Retrieve the version of @gatling.io/cli from devDependencies
if ($PackageJsonContent.devDependencies."@gatling.io/cli") {
    $GatlingVersion = $PackageJsonContent.devDependencies."@gatling.io/cli"
    # Remove the ^ prefix from the version string
    $GatlingVersion = $GatlingVersion.TrimStart('^')
    Log-Info "Found @gatling.io/cli version: $GatlingVersion"
} else {
    Log-Error "The @gatling.io/cli dependency was not found in the devDependencies section of the package.json file."
}

# Construct the download URL
$VersionTag = "v$GatlingVersion" # Tag with the 'v' prefix
$FileName = "gatling-js-bundle-$GatlingVersion-Windows_NT-x64.zip" # File name without the 'v' prefix
$DownloadUrl = "$BaseUrl/$VersionTag/$FileName"
$OutputFilePath = Join-Path -Path $OutputDir -ChildPath $FileName

Log-Info "Download URL: $DownloadUrl"
Log-Info "The file will be saved as: $OutputFilePath"

# Download the file if it doesn't already exist
if (Test-Path -Path $OutputFilePath) {
    Log-Info "The file $OutputFilePath already exists. Skipping download."
} else {
    Log-Info "Starting the file download..."
    try {
        Invoke-WebRequest -Uri $DownloadUrl -OutFile $OutputFilePath -UseBasicParsing -ErrorAction Stop
        Log-Info "File downloaded successfully: $OutputFilePath"
    } catch {
        Log-Error "Failed to download the file from $DownloadUrl"
    }
}

# Install the downloaded file using npx gatling install
Log-Info "Installing the file using npx gatling install..."
$npxCommand = "npx gatling install $OutputFilePath"

try {
    # Suppress error messages and handle them in the catch block
    Invoke-Expression $npxCommand 2>$null | Out-Null
} catch {
    if ($_.Exception.Message -like "*already exists*") {
        Log-Info "The target directory already exists. Skipping installation."
    } else {
        Log-Error "An unexpected error occurred during installation: $($_.Exception.Message)"
    }
}

Log-Info "Installation process completed successfully."
