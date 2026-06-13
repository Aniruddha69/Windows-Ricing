# Enable-Winget.ps1
# This script installs or updates the Windows Package Manager (winget)

$ErrorActionPreference = "Stop"
$progressPreference = 'silentlyContinue'

Write-Host "Checking if winget is already installed..." -ForegroundColor Cyan

if (Get-Command winget -ErrorAction SilentlyContinue)
{
  Write-Host "Winget is installed!" -ForegroundColor Green
    $version = winget --version
    Write-Host "Version: $version"
}

else
{
  Write-Host " winget package manager is not installed! " 'ForegroundColor Red
    exit 
}

# 1. Download and Install JetBrainsMono Nerd Font
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
# 2. Install Git, PowerShell 7, and Fastfetch using Winget
Write-Host "`nInstalling Git, PowerShell 7, and Fastfetch..." -ForegroundColor Cyan
winget install --id Git.Git  --source winget --accept-package-agreements --accept-source-agreements
winget install --id Microsoft.PowerShell --source winget --accept-package-agreements --accept-source-agreements 
winget install --id fastfetch-cli.fastfetch --source winget --accept-package-agreements --accept-source-agreements
winget install --id Mircosoft.WindowsTerminal --source winget --accept-package-agreements --accept-source-agreements
winget install --id JanDeDobbeleer.OhMyPosh --source winget --accept-package-agreements --accept-source-agreements 
# 3. Define directory paths
$homeDir = $HOME
$configDir = Join-Path $homeDir ".config"
$DocsDir = Join-Path $homeDir "Documents"
$wtSettingsPath = Join-Path $homedir "AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"
# 4. Create the directories and hide .config
if (-not (Test-Path $configDir))
{
  Write-Host "Creating hidden .config directory..."
    New-Item -Path $configDir -ItemType Directory -Force | Out-Null
    (Get-Item $configDir).Attributes += 'Hidden'
}
$repo = Join-Path $env:TEMP "Windows-Ricing"

if (!(Test-Path $repo)) {
    git clone https://github.com/Aniruddha69/Windows-Ricing.git $repo
}

$source1 = Join-Path $repo "Terminal\PowerShell"
$source2 = Join-Path $repo "Terminal\Oh-My-Posh"
$source3 = Join-Path $repo "Terminal\fastfetch"
$source4 = Join-Path $repo "Terminal\Terminal"

if (Test-Path $source1) { Move-Item -Path $source1 -Destination $DocsDir -Force }
if (Test-Path $source2) { Move-Item -Path $source2 -Destination $configDir -Force }
if (Test-Path $source3) { Move-Item -Path $source3 -Destination $configDir -Force }
if (Test-Path $source4) { Move-Item -Path $source4 -Destination $wtSettingsPath -Force }
# Clean up

Remove-Item -Path "$env:TEMP\Windows-Ricing" -Force

if (Test-Path -Path $wtSettingsPath -IsValid)
{
  Set-Content -Path $wtSettingsPath -Value $wtSettingsContent -Encoding UTF8 -Force
} else
{
  Write-Host "Windows Terminal settings path not found. Please ensure Windows Terminal is installed." -ForegroundColor Red
}


#10 Add Git's Unix tools (usr\bin) to the PATH environment variable
Write-Host "Adding Git Unix tools to Environment PATH..." -ForegroundColor Cyan
$gitUsrBin = "C:\Program Files\Git\usr\bin"
$currentPath = [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::User)

if (Test-Path $gitUsrBin)
{
  if ($currentPath -notlike "*$gitUsrBin*")
  {
    $newPath = $currentPath + ";" + $gitUsrBin
      [Environment]::SetEnvironmentVariable("Path", $newPath, [EnvironmentVariableTarget]::User)
      Write-Host "Successfully added $gitUsrBin to User PATH." -ForegroundColor Green
  } else
  {
    Write-Host "Git Unix tools are already in your PATH." -ForegroundColor Yellow
  }
} else
{
  Write-Host "Git usr\bin not found. Ensure Git is installed via winget first." -ForegroundColor Red
}

Write-Host "`nComplete! Close Windows Terminal entirely and reopen it. Your new font, git tool, Unix-like bin paths, themes, layouts, autocomplete, and fastfetch profile should all be loaded!" -ForegroundColor Green
