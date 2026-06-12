# Enable-Winget.ps1
# This script installs or updates the Windows Package Manager (winget)

$ErrorActionPreference = "Stop"
$progressPreference = 'silentlyContinue'

Write-Host "Checking if winget is already installed..." -ForegroundColor Cyan

if (Get-Command winget -ErrorAction SilentlyContinue)
{
  Write-Host "Winget is already installed!" -ForegroundColor Green
  $version = winget --version
  Write-Host "Version: $version"
}

else
{
  Write-Host "Winget not found. Fetching the latest release from GitHub..." -ForegroundColor Yellow

  # Enforce TLS 1.2 for the web request
  [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

  # Get the latest release data from the winget-cli repository
  $releases_url = "https://api.github.com/repos/microsoft/winget-cli/releases/latest"
  $response = Invoke-RestMethod -Uri $releases_url

  # Find the .msixbundle asset
  $asset = $response.assets | Where-Object { $_.name -match "\.msixbundle$" }

  if (-not $asset)
  {
    Write-Error "Could not find the winget.msixbundle in the latest release."
  }

  $download_url = $asset.browser_download_url
  $temp_file = "$env:TEMP\$($asset.name)"

  Write-Host "Downloading winget from $($download_url)..." -ForegroundColor Cyan
  Invoke-WebRequest -Uri $download_url -OutFile $temp_file

  Write-Host "Installing winget (App Installer)..." -ForegroundColor Cyan
  Add-AppxPackage -Path $temp_file

  # Verify installation
  if (Get-Command winget -ErrorAction SilentlyContinue)
  {
    Write-Host "Successfully installed winget!" -ForegroundColor Green
  } else
  {
    Write-Host "Installation completed, but you may need to restart your terminal or PC to use the 'winget' command." -ForegroundColor Yellow
  }

  # Clean up
  Remove-Item -Path $temp_file -Force
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
$wtSettingsPath = Join-Path $homedir "AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
$temprepo
# 4. Create the directories and hide .config
if (-not (Test-Path $configDir))
{
  Write-Host "Creating hidden .config directory..."
  New-Item -Path $configDir -ItemType Directory -Force | Out-Null
  (Get-Item $configDir).Attributes += 'Hidden'
}
# 5. downloading the repository 
git clone https://github.com/Aniruddha69/Windows-Ricing.git "$env:TEMP"

# 6. moving to dedicated folder 
Move-Item -Path "$env:TEMP\Windows-Ricing\Terminal\PowerShell" -Destination "$DocsDir"
Move-Item -Path "$env:TEMP\Windows-Ricing\Terminal\Oh-My-Posh" -Destination "$configDir"
Move-Item -Path "$env:TEMP\Windows-Ricing\Terminal\fastfetch" -Destination "$configDir"

# 7. Overwrite Windows Terminal settings.json
Write-Host "Overwriting Windows Terminal settings.json..."
$wtSettingsContent = @'
{
  "$help": "https://aka.ms/terminal-documentation",
    "$schema": "https://aka.ms/terminal-profiles-schema",
    "actions":
      [
      {
        "command":
        {
          "action": "copy",
          "singleLine": false
        },
        "id": "User.copy.644BA8F2"
      },
      {
        "command": "paste",
        "id": "User.paste"
      },
      {
        "command":
        {
          "action": "splitPane",
          "split": "auto",
          "splitMode": "duplicate"
        },
        "id": "User.splitPane.A6751878"
      },
      {
        "command": "find",
        "id": "User.find"
      }
  ],
    "alwaysOnTop": false,
    "copyFormatting": "none",
    "copyOnSelect": false,
    "defaultProfile": "{61c54bbd-c2c6-5271-96e7-009a87ff44bf}",
    "keybindings":
      [
      {
        "id": "User.copy.644BA8F2",
        "keys": "ctrl+c"
      },
      {
        "id": "User.paste",
        "keys": "ctrl+v"
      },
      {
        "id": "User.find",
        "keys": "ctrl+shift+f"
      },
      {
        "id": "User.splitPane.A6751878",
        "keys": "alt+shift+d"
      }
      ],
        "newTabMenu":
          [
          {
            "type": "remainingProfiles"
          }
          ],
            "profiles":
            {
              "defaults":
              {
                "colorScheme": "Catppuccin Mocha",
                "cursorShape": "filledBox",
                "experimental.retroTerminalEffect": false,
                "font":
                {
                  "builtinGlyphs": true,
                  "cellHeight": "1.2",
                  "colorGlyphs": true,
                  "face": "JetBrainsMono Nerd Font Mono",
                  "size": 10,
                  "weight": "extra-black"
                },
                "intenseTextStyle": "all",
                "opacity": 80,
                "padding": "8",
                "useAcrylic": true
              },
              "list":
                [
                {
                  "commandline": "%SystemRoot%\\System32\\WindowsPowerShell\\v1.0\\powershell.exe",
                  "guid": "{61c54bbd-c2c6-5271-96e7-009a87ff44bf}",
                  "hidden": false,
                  "name": "Windows PowerShell"
                },
                {
                  "commandline": "%SystemRoot%\\System32\\cmd.exe",
                  "guid": "{0caa0dad-35be-5f56-a8ff-afceeeaa6101}",
                  "hidden": false,
                  "name": "Command Prompt"
                },
                {
                  "guid": "{b453ae62-4e3d-5e58-b989-0a998ec441b8}",
                  "hidden": false,
                  "name": "Azure Cloud Shell",
                  "source": "Windows.Terminal.Azure"
                },
                {
                  "guid": "{574e775e-4f2a-5b96-ac1e-a2962a402336}",
                  "hidden": false,
                  "name": "PowerShell",
                  "source": "Windows.Terminal.PowershellCore"
                }
              ]
            },
            "schemes":
              [
              {
                "background": "#1E1E2E",
                "black": "#45475A",
                "blue": "#89B4FA",
                "brightBlack": "#585B70",
                "brightBlue": "#89B4FA",
                "brightCyan": "#94E2D5",
                "brightGreen": "#A6E3A1",
                "brightPurple": "#F5C2E7",
                "brightRed": "#F38BA8",
                "brightWhite": "#A6ADC8",
                "brightYellow": "#F9E2AF",
                "cursorColor": "#F5E0DC",
                "cyan": "#94E2D5",
                "foreground": "#CDD6F4",
                "green": "#A6E3A1",
                "name": "Catppuccin Mocha",
                "purple": "#F5C2E7",
                "red": "#F38BA8",
                "selectionBackground": "#585B70",
                "white": "#BAC2DE",
                "yellow": "#F9E2AF"
              },
              {
                "background": "#000000",
                "black": "#0C0C0C",
                "blue": "#0037DA",
                "brightBlack": "#767676",
                "brightBlue": "#3B78FF",
                "brightCyan": "#61D6D6",
                "brightGreen": "#16C60C",
                "brightPurple": "#B4009E",
                "brightRed": "#E74856",
                "brightWhite": "#F2F2F2",
                "brightYellow": "#F9F1A5",
                "cursorColor": "#FFFFFF",
                "cyan": "#3A96DD",
                "foreground": "#FFFFFF",
                "green": "#13A10E",
                "name": "Color Scheme 15",
                "purple": "#881798",
                "red": "#C50F1F",
                "selectionBackground": "#FFFFFF",
                "white": "#CCCCCC",
                "yellow": "#C19C00"
              },
              {
                "background": "#282A36",
                "black": "#21222C",
                "blue": "#BD93F9",
                "brightBlack": "#6272A4",
                "brightBlue": "#D6ACFF",
                "brightCyan": "#A4FFFF",
                "brightGreen": "#69FF94",
                "brightPurple": "#FF92DF",
                "brightRed": "#FF6E6E",
                "brightWhite": "#FFFFFF",
                "brightYellow": "#FFFFA5",
                "cursorColor": "#F8F8F2",
                "cyan": "#8BE9FD",
                "foreground": "#F8F8F2",
                "green": "#50FA7B",
                "name": "Dracula",
                "purple": "#FF79C6",
                "red": "#FF5555",
                "selectionBackground": "#44475A",
                "white": "#F8F8F2",
                "yellow": "#F1FA8C"
              }
          ],
            "tabWidthMode": "titleLength",
            "themes": [],
            "useAcrylicInTabRow": true
}
'@

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
