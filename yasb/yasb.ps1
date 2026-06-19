# downloading git and yasb via winget package manager
winget install --id Git.Git  --source winget --accept-package-agreements --accept-source-agreements
winget install --id AmN.yasb --source winget --accept-package-agreements --accept-source-agreements

# defining directory 

$homeDir = $HOME
$configDir = Join-Path $homeDir ".config"
$repo = Join-Path $env:TEMP "Windows-Ricing"
$yasbDir = Join-Path $configDir "yasb"

# making .config dircectory

if (-not (Test-Path $configDir))
{
  Write-Host "Creating hidden .config directory..."
    New-Item -Path $configDir -ItemType Directory -Force | Out-Null
    (Get-Item $configDir).Attributes += 'Hidden'
}

# cloning my repo in temp folder

if (!(Test-Path $repo)) {
    git clone https://github.com/Aniruddha69/Windows-Ricing.git $repo
}

# defining directory in repo inside temp folder

$source1 = Join-Path $repo "yasb/Config"

# cleaning previous intances and configs 

if (Test-Path $yasbDir) {
    Remove-Item $yasbDir -Recurse -Force
}

# moving files from repo to .config directory

if (Test-Path $source1) { Move-Item -Path $source1 -Destination $configDir -Force }

# cleaning temp folder 


if (Test-Path $repo) {
    Remove-Item $repo -Recurse -Force
}

# Runing the Program

Set-Location "C:\Program Files\YASB\"; .\yasb.exe
Set-Location 

