# Enable-Winget.ps1

Write-Host "Checking if winget is already installed..." -ForegroundColor Cyan

if (Get-Command winget -ErrorAction SilentlyContinue)
{
  Write-Host "Winget is installed!" -ForegroundColor Green
    $version = winget --version
    Write-Host "Version: $version"
}

else
{
  Write-Host "Winget package manager is not installed!" -ForegroundColor Red
  exit 1
}

# Download and Install JetBrainsMono Nerd Font
$registryKey = "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Fonts"

Write-Host "Checking if JetBrainsMono Nerd Font is already installed..." -ForegroundColor Cyan
$fontInstalled = Get-ItemProperty -Path $registryKey -ErrorAction SilentlyContinue | 
Get-Member -MemberType Properties | 
Where-Object { $_.Name -like "*JetBrainsMono*" }

if ($fontInstalled)
{
  Write-Host "JetBrainsMono Nerd Font is already installed. Skipping download!" -ForegroundColor Green
} else
{
  $fontUrl = "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
    $tempZip = Join-Path $env:TEMP "JetBrainsMono.zip"
    $tempExtract = Join-Path $env:TEMP "JetBrainsMono_Extract"

    Invoke-WebRequest -Uri $fontUrl -OutFile $tempZip

    Write-Host "Extracting and installing fonts (this may take a moment)..." -ForegroundColor Cyan
    if (Test-Path $tempExtract)
    { Remove-Item -Path $tempExtract -Recurse -Force 
    }
  Expand-Archive -Path $tempZip -DestinationPath $tempExtract -Force

# Define the user-level fonts directory
    $fontFolder = "$env:LOCALAPPDATA\Microsoft\Windows\Fonts"
    if (-not (Test-Path $fontFolder))
    { New-Item -ItemType Directory -Path $fontFolder -Force | Out-Null 
    }

# Install each .ttf file and register it in the Current User registry
  $fonts = Get-ChildItem -Path $tempExtract -Filter *.ttf -Recurse
    $registryKey = "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Fonts"

    foreach ($font in $fonts)
    {
      $destPath = Join-Path $fontFolder $font.Name
        Copy-Item -Path $font.FullName -Destination $destPath -Force

        $fontName = $font.BaseName + " (TrueType)"
        Set-ItemProperty -Path $registryKey -Name $fontName -Value $destPath -Force
    }

# Cleanup font temp files
  Remove-Item -Path $tempZip -Force
    Remove-Item -Path $tempExtract -Recurse -Force
    Write-Host "Font installation complete!" -ForegroundColor Green
}

# Download and Install JetBrainsMono Nerd Font

$registryKey = "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Fonts"

Write-Host "Checking if JetBrainsMono Nerd Font is already installed..." -ForegroundColor Cyan
$fontInstalled = Get-ItemProperty -Path $registryKey -ErrorAction SilentlyContinue | 
Get-Member -MemberType Properties | 
Where-Object { $_.Name -like "*JetBrainsMono*" }

if ($fontInstalled)
{
  Write-Host "JetBrainsMono Nerd Font is already installed. Skipping download!" -ForegroundColor Green
} else
{
  $fontUrl = "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
    $tempZip = Join-Path $env:TEMP "JetBrainsMono.zip"
    $tempExtract = Join-Path $env:TEMP "JetBrainsMono_Extract"

    Invoke-WebRequest -Uri $fontUrl -OutFile $tempZip

    Write-Host "Extracting and installing fonts (this may take a moment)..." -ForegroundColor Cyan
    if (Test-Path $tempExtract)
    { Remove-Item -Path $tempExtract -Recurse -Force 
    }
  Expand-Archive -Path $tempZip -DestinationPath $tempExtract -Force

# Define the user-level fonts directory
    $fontFolder = "$env:LOCALAPPDATA\Microsoft\Windows\Fonts"
    if (-not (Test-Path $fontFolder))
    { New-Item -ItemType Directory -Path $fontFolder -Force | Out-Null 
    }

# Install each .ttf file and register it in the Current User registry
  $fonts = Get-ChildItem -Path $tempExtract -Filter *.ttf -Recurse
    $registryKey = "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Fonts"

    foreach ($font in $fonts)
    {
      $destPath = Join-Path $fontFolder $font.Name
        Copy-Item -Path $font.FullName -Destination $destPath -Force

        $fontName = $font.BaseName + " (TrueType)"
        Set-ItemProperty -Path $registryKey -Name $fontName -Value $destPath -Force
    }

# Cleanup font temp files
  Remove-Item -Path $tempZip -Force
    Remove-Item -Path $tempExtract -Recurse -Force
    Write-Host "Font installation complete!" -ForegroundColor Green
}

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

$source1 = Join-Path $repo "yasb\Config\config.yaml"
$source2 = Join-Path $repo "yasb\Config\styles.css"

# cleaning previous intances and configs 

if (Test-Path $yasbDir) {
    Remove-Item $yasbDir -Recurse -Force
    New-Item -Path $yasbDir -ItemType Directory -Force | Out-Null
}

else {
    New-Item -Path $configDir -ItemType Directory -Force | Out-Null
    exit 1
}

# moving files from repo to .config directory

if (Test-Path $source1) { Move-Item -Path $source1 -Destination $yasbDir -Force }
if (Test-Path $source2) { Move-Item -Path $source2 -Destination $yasbDir -Force }

# cleaning temp folder 


if (Test-Path $repo) {
    Remove-Item $repo -Recurse -Force
}

# Runing the Program

Set-Location "C:\Program Files\YASB\"; .\yasb.exe
Set-Location "~"

