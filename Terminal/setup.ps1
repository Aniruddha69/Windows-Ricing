# Enable-Winget.ps1
# This script installs or updates the Windows Package Manager (winget)

$ErrorActionPreference = "Stop"
$progressPreference = 'silentlyContinue'

Write-Host "Checking if winget is already installed..." -ForegroundColor Cyan

if (Get-Command winget -ErrorAction SilentlyContinue) {
  Write-Host "Winget is already installed!" -ForegroundColor Green
    $version = winget --version
    Write-Host "Version: $version"
}

else {
  Write-Host "Winget not found. Fetching the latest release from GitHub..." -ForegroundColor Yellow

# Enforce TLS 1.2 for the web request
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Get the latest release data from the winget-cli repository
    $releases_url = "https://api.github.com/repos/microsoft/winget-cli/releases/latest"
      $response = Invoke-RestMethod -Uri $releases_url

# Find the .msixbundle asset
      $asset = $response.assets | Where-Object { $_.name -match "\.msixbundle$" }

  if (-not $asset) {
    Write-Error "Could not find the winget.msixbundle in the latest release."
  }

  $download_url = $asset.browser_download_url
    $temp_file = "$env:TEMP\$($asset.name)"

    Write-Host "Downloading winget from $($download_url)..." -ForegroundColor Cyan
    Invoke-WebRequest -Uri $download_url -OutFile $temp_file

    Write-Host "Installing winget (App Installer)..." -ForegroundColor Cyan
    Add-AppxPackage -Path $temp_file

# Verify installation
    if (Get-Command winget -ErrorAction SilentlyContinue) {
      Write-Host "Successfully installed winget!" -ForegroundColor Green
    } else {
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

if ($fontInstalled) {
  Write-Host "JetBrainsMono Nerd Font is already installed. Skipping download!" -ForegroundColor Green
} 
else {
  $fontUrl = "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
    $tempZip = Join-Path $env:TEMP "JetBrainsMono.zip"
    $tempExtract = Join-Path $env:TEMP "JetBrainsMono_Extract"

    Invoke-WebRequest -Uri $fontUrl -OutFile $tempZip

    Write-Host "Extracting and installing fonts (this may take a moment)..." -ForegroundColor Cyan
    if (Test-Path $tempExtract) { Remove-Item -Path $tempExtract -Recurse -Force }
  Expand-Archive -Path $tempZip -DestinationPath $tempExtract -Force

# Define the user-level fonts directory
    $fontFolder = "$env:LOCALAPPDATA\Microsoft\Windows\Fonts"
    if (-not (Test-Path $fontFolder)) { New-Item -ItemType Directory -Path $fontFolder -Force | Out-Null }

# Install each .ttf file and register it in the Current User registry
  $fonts = Get-ChildItem -Path $tempExtract -Filter *.ttf -Recurse
    $registryKey = "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Fonts"

    foreach ($font in $fonts) {
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
winget install --id Git.Git -e --source winget --accept-package-agreements --accept-source-agreements
winget install --id Microsoft.PowerShell --source winget --accept-package-agreements --accept-source-agreements 
winget install --id fastfetch-cli.fastfetch --source winget --accept-package-agreements --accept-source-agreements
winget install --id Mircosoft.WindowsTerminal --source winget --accept-package-agreements --accept-source-agreements
winget install --id ajeetdsouza.zoxide --source winget --accept-package-agreements --accept-source-agreements 
# 3. Define directory paths
$homeDir = $HOME
$configDir = Join-Path $homeDir ".config"
$fastfetchDir = Join-Path $configDir "fastfetch"
$psProfileDir = Join-Path $homeDir "Documents\PowerShell"
$wtSettingsPath = Join-Path $homedir "AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json"
$ohmyposhDir = Join-path $configDir "Oh-My-Posh"
# 4. Create the directories and hide .config
if (-not (Test-Path $configDir)) {
  Write-Host "Creating hidden .config directory..."
    New-Item -Path $configDir -ItemType Directory -Force | Out-Null
    (Get-Item $configDir).Attributes += 'Hidden'
}
if (-not (Test-Path $fastfetchDir)) {
  Write-Host "Creating fastfetch directory inside .config..."
    New-Item -Path $fastfetchDir -ItemType Directory -Force | Out-Null
}

if (-not (Test-Path $psProfileDir)) {
  Write-Host "Creating PowerShell directory in Documents..."
    New-Item -Path $psProfileDir -ItemType Directory -Force | Out-Null
}

if (-not(Test-Path $ohmyposhDir)) {
  Write-Host "Creating Oh-My-Posh directory inside .config..."
    New-Item -Path $ohmyposhDir -ItemType File -Force | Out-Null 
}

# 5. Write config.jsonc
Write-Host "Writing fastfetch config.jsonc..."
$configContent = @'
{
  "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json",
    "logo": {
      "type": "file",
      "source": "%USERNAME%/.config/fastfetch/ascii.txt",
      "color": {
        "1": "#FFFFFF",
        "2": "#F2CDCD",
        "3": "#F5C2E7",
        "4": "#FAB387",
        "5": "#F9E2AF",
        "6": "#A6E3A1",
        "7": "#94E2D5",
        "8": "#89DCEB",
        "9": "#710193"
      },
      "padding": {
        "top": 1,
        "right": 3
      }
    },
    "display": {
      "separator": " "
    },
    "modules": [
      "break",
    {
      "type": "title",
      "color": {
        "user": "#F5C2E7",
        "at": "#CDD6F4",
        "host": "#89DCEB"
      }
    },
    "break",
    {
      "type": "os",
      "key": "",
      "keyColor": "#89DCEB"
    },
    {
      "type": "cpu",
      "key": "",
      "keyColor": "#F5C2E7"
    },
    {
      "type": "board",
      "key": "󰚗",
      "keyColor": "#FAB387"
    },
    {
      "type": "memory",
      "key": "",
      "keyColor": "#A6E3A1",
      "format": "{used} / {total} ({percentage})"
    },
    {
      "type": "disk",
      "key": "",
      "keyColor": "#94E2D5"
    },
    "break",
    {
      "type": "colors",
      "symbol": "circle"
    }
  ]
}
'@
$configPath = Join-Path $fastfetchDir "config.jsonc"
Set-Content -Path $configPath -Value $configContent -Encoding UTF8

# 6. Write ascii.txt
Write-Host "Writing fastfetch ascii.txt..."
$asciiContent = @'
$9⠀⠀⠀⠀⠀⠀⠀⢢⣤⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣠⣤⣶⣶⡟⠁⠀⠀⠀⠀⠀
$9⠀⠀⠀⠀⠀⠀⠀⠀⠹⣿⣿⣿⣷⣶⣦⣤⣀⡀⠀⠀⠀⠀⢀⣀⣤⣴⣶⣶⣶⣶⣶⣶⣦⣤⣀⡀⢀⣀⣠⣤⣴⣶⣾⣿⣿⣿⣿⣿⣿⠏⠀⠀⠀⠀⠀⠀⠀
$9⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠋⠀⠀⠀⠀⠀⠀⠀⠀
$9⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀
$9⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
$9⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣿⣿⣿⣿⣿⠁⠙⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠋⠀⠸⣿⣿⣿⣿⣿⣿⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
$9⠀⠀⠀⠀⠀⠀⠐⢶⣶⣶⣶⣶⣶⣶⣾⣿⣿⣿⣿⠀⠀⠀⠈⠻⣿⣿⣿⣿⣿⣿⣿⣿⡿⠃⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣶⣶⣶⣶⣾⠟⠁⠀⠀⠀⠀⠀⠀
$9 ⠀⠀⠀⠀⠀⠀⠀⠙⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀$1⠠⣶⡆$9⠈⠻⣿⣿⣿⣿⣿⠋$1⠠⣶⡆$9⠀⠀⢀⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠁⠀⠀⠀⠀⠀⠀⠀⠀
$9⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠿⣿⣿⣿⣿⣿⣿⣿⣷⣤⣤⣤⣤⣤⣤⣿⣿⣿⣿⣿⣦⣤⣤⣶⣶⣶⣾⡿⢿⣿⣿⣿⣿⣿⡿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
$9⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⣿⣿⣿⣿⣿⡛⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⢀⣾⣿⣿⣿⣿⣯⣤⡤⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
$9⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⠶⣶⣶⣾⣿⣿⣿⣿⣧⠀⠛⠁⠀⠈⠿⠋⠉⠉⠉⠉⠻⠋⠀⠀⠈⠁⢠⣾⣿⣿⣿⣿⣿⣿⣿⣷⣶⣄⠀⠀⠀⠀⠀⠀⠀⠀
$9⠀⠀⠀⠀⠀⠀⢠⣤⣤⣤⣀⠀⠈⠻⢿⣿⣿⣿⣿⣿⣷⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⣿⣿⣿⣿⣿⣿⣿⠟⣿⣿⣿⣿⡀⠀⠀⠀⠀⠀⠀⠀
$9⠀⠀⠀⠀⠀⠀⣼⣿⣿⣿⣿⣷⣦⡀⠀⠙⠿⣿⣿⣿⣿⣿⣦⣀⣠⣀⣴⡀⣠⡀⣠⡀⣴⣄⣠⣾⣿⣿⣿⣿⣿⣿⡿⠋⠀⣼⣿⣿⣿⣷⡀⠀⠀⠀⠀⠀⠀
$9⠀⠀⠀⠀⠀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣷⣶⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣋⣀⣠⣾⣿⣿⣿⣿⣿⣿⣷⣶⣶⣤⣄⠀
$9⠀⠀⠀⠀⢀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷
$9⠀⢀⣴⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠛⠛⠻⣿⣿⣿⡿⠟⠙⠿⣿⣿⣿⣿⣿⣿⣿⣿
$9⢠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠿⠟⠿⠿⠿⠛⠁⣿⣿⠃⠀⠈⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⢿⣿⣿⠁⠀⠀⠀⠀⠀⠹⡇⠀⠀⠀⠈⠙⠛⠋⠁⣸⡿⠃
$9⠸⣿⣿⡟⠉⠉⠉⠉⠛⠉⠁⠀⠀⠀⠀⠀⠀⠀⠛⠁⠀⠀⠀⠀⠙⣧⠙⣿⣿⣿⣿⣿⣿⣿⣿⠘⡏⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡿⠁⠀
$9⠀⢻⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠣⠈⠻⣿⡿⢿⣿⣿⣿⠀⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
$9⠀⠀⠈⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢷⠈⢻⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
$9⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠻⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
$9⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
'@
$asciiPath = Join-Path $fastfetchDir "ascii.txt"
Set-Content -Path $asciiPath -Value $asciiContent -Encoding UTF8

# 7. Write Oh-My-Posh config
Write-Host "Writing Oh-My-Posh configrations"
$ohmyposhContent = @'
{
  "$schema": "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/schema.json",
    "white-blue": "#a9b1d6",
    "blue-bell": "#9aa5ce",
    "pastal-grey": "#cfc9c2",
    "terminal-magenta": "#bb9af7",
    "blue-black": "#565f89",
    "terminal-black": "#414868",
    "t-background": "p:main-bg"
  },
  "blocks": [
    "palette": {
      "main-bg": "#24283b",
      "terminal-red": "#f7768e",
      "pistachio-green": "#9ece6a",
      "terminal-green": "#73daca",
      "terminal-yellow": "#e0af68",
      "terminal-blue": "#7aa2f7",
      "celeste-blue": "#b4f9f8",
      "light-sky-blue": "#7dcfff",
      "terminal-white": "#c0caf5",
      "white-blue": "#a9b1d6",
      "blue-bell": "#9aa5ce",
      "pastal-grey": "#cfc9c2",
      "terminal-magenta": "#bb9af7",
      "blue-black": "#565f89",
      "terminal-black": "#414868",
      "t-background": "p:main-bg"
    },
    "blocks": [
    {
      "alignment": "left",
      "segments": [
      {
        "type": "text",
        "style": "plain",
        "background": "transparent",
        "foreground": "p:terminal-blue",
        "template": "\u279c "
      },
      {
        "type": "path",
        "style": "plain",
        "foreground": "p:terminal-magenta",
        "options": {
          "style": "folder"
        },
        "template": "<b>{{ .Path }}</b> <p:light-sky-blue>\u26a1</>"
      },
      {
        "type": "git",
        "style": "plain",
        "foreground": "p:light-sky-blue",
        "foreground_templates": [
          "{{ if or (.Working.Changed) (.Staging.Changed) }}p:terminal-red{{ end }}",
        "{{ if and (gt .Ahead 0) (gt .Behind 0)}}p:light-sky-blue {{ end }}",
        "{{ if gt .Ahead 0 }}p:terminal-blue{{ end }}",
        "{{ if gt .Behind 0 }}p:celeste-blue{{ end }}"
        ],
        "template": "({{ .HEAD}})",
        "options": {
          "fetch_status": true,
          "branch_icon": "\ue725 "
        }
      },
      {
        "type": "status",
        "style": "plain",
        "foreground": "p:terminal-red",
        "template": " \uf00d"
      }
      ],
        "type": "prompt"
    },
    {
      "alignment": "right",
      "overflow": "hide",
      "segments": [
      {
        "type": "node",
        "style": "plain",
        "foreground": "p:pistachio-green",
        "template": "\ue718 {{ .Full }} "
      },
      {
        "type": "php",
        "style": "plain",
        "foreground": "p:terminal-blue",
        "template": "\ue73d {{ .Full }} "
      },
      {
        "type": "python",
        "style": "plain",
        "foreground": "p:terminal-yellow",
        "template": "\uE235 {{ .Full }}"
      },
      {
        "type": "julia",
        "style": "plain",
        "foreground": "p:terminal-magenta",
        "template": "\uE624 {{ .Full }}"
      },
      {
        "type": "ruby",
        "style": "plain",
        "foreground": "p:terminal-red",
        "template": "\uE791 {{ .Full}}"
      },
      {
        "type": "go",
        "style": "plain",
        "foreground": "p:light-sky-blue",
        "template": "\uFCD1 {{ .Full}}"
      }
      ],
        "type": "prompt"
    },
    {
      "alignment": "left",
      "newline": true,
      "segments": [
      {
        "foreground": "p:pistachio-green",
        "style": "plain",
        "template": "\u25b6",
        "type": "text"
      }
      ],
        "type": "prompt"
    }
  ],
    "secondary_prompt": {
      "background": "transparent",
      "foreground": "p:terminal-blue",
      "template": "\u279c "
    },
    "transient_prompt": {
      "background": "p:t-background",
      "foreground": "p:terminal-blue",
      "template": "\u279c "
    },
    "final_space": true,
    "version": 4,
    "terminal_background": "p:t-background"
}
'@
$ohmyposhPath = Join-Path $ohmyposhDir "tokyonight.omp.json"
Set-Content -Path $ohmyposhPath -Value $ohmyposhContent -Encoding UTF8


# 8. Write profile.ps1
Write-Host "Writing profile.ps1 to Documents\PowerShell..."
$profileContent = @'

# Aniruddha's Powershell profile 

Write-Host "Use 'Show-Help' to list all available functions" -ForegroundColor Yellow

# KeyBinds
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadLineKeyHandler -Chord 'Ctrl+d' -Function DeleteChar
Set-PSReadLineKeyHandler -Chord 'Ctrl+w' -Function BackwardDeleteWord
Set-PSReadLineKeyHandler -Chord 'Alt+d' -Function DeleteWord
Set-PSReadLineKeyHandler -Chord 'Ctrl+LeftArrow' -Function BackwardWord
Set-PSReadLineKeyHandler -Chord 'Ctrl+RightArrow' -Function ForwardWord
Set-PSReadLineKeyHandler -Chord 'Ctrl+z' -Function Undo
Set-PSReadLineKeyHandler -Chord 'Ctrl+y' -Function Redo

# Functions

# System Utilities
function uptime {
  (Get-Date) - (Get-CimInstance -ClassName Win32_OperatingSystem).LastBootUpTime | Select-Object Days, Hours, Minutes, Seconds
}

function winutil {
  Invoke-RestMethod https://christitus.com/win | Invoke-Expression
}

function winutildev {
  Invoke-RestMethod https://christitus.com/windev | Invoke-Expression
}

# Git Shortcuts
function gs { git status }
function ga { git add . }
function gp { git push }
function gpush { git push }
function gpull { git pull }
function gcl { git clone $args }
function g { __zoxide_z github }

function gcom {
  git add .
    git commit -m "$args"
}

function lazyg {
  git add .
    git commit -m "$args"
    git push
}

function docs {
  Set-Location -Path ([Environment]::GetFolderPath("MyDocuments"))
}

function Update-Profile {
  Invoke-RestMethod https://github.com/Aniruddha69/Windows-Ricing/raw/main/Terminal/setup.ps1 | Invoke-Expression
}

# Help Function
function Show-Help {
  $title    = $PSStyle.Foreground.BrightMagenta
    $section  = $PSStyle.Foreground.BrightBlue
    $command  = $PSStyle.Foreground.BrightGreen
    $desc     = $PSStyle.Foreground.BrightWhite
    $accent   = $PSStyle.Foreground.BrightYellow
    $dim      = $PSStyle.Foreground.BrightBlack
    $reset    = $PSStyle.Reset

    Write-Host @"
    ${title}󰘳 PowerShell Profile Help${reset}
  ${dim}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${reset}

  ${section}󰊢 Update${reset}
  ${command}Update-Profile${reset}  ${accent}→${reset} ${desc}Updates the profile from a remote repository.${reset}

  ${section}󰊢 Git Shortcuts${reset}
  ${dim}────────────────────────────────────────────────────${reset}
  ${command}g${reset}                  ${accent}→${reset} ${desc}Changes to the GitHub directory${reset}        
  ${command}ga${reset}                 ${accent}→${reset} ${desc}git add .${reset}
  ${command}gcl <repo>${reset}         ${accent}→${reset} ${desc}git clone${reset}
  ${command}gcom <message>${reset}     ${accent}→${reset} ${desc}add + commit${reset}
  ${command}gp / gpush${reset}         ${accent}→${reset} ${desc}git push${reset}
  ${command}gpull${reset}              ${accent}→${reset} ${desc}git pull${reset}
  ${command}gs${reset}                 ${accent}→${reset} ${desc}git status${reset}
  ${command}lazyg <message>${reset}    ${accent}→${reset} ${desc}add + commit + push${reset}

  ${section}󰘴 System Shortcuts${reset}
  ${dim}────────────────────────────────────────────────────${reset}
  ${command}docs${reset}               ${accent}→${reset} ${desc}Documents folder${reset}
  ${command}uptime${reset}             ${accent}→${reset} ${desc}System uptime${reset}
  ${command}winutil${reset}            ${accent}→${reset} ${desc}Run WinUtil${reset}
  ${command}winutildev${reset}         ${accent}→${reset} ${desc}Run WinUtil Dev${reset}

  ${dim}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${reset}
  "@
}

Clear-host

oh-my-posh init pwsh --config '~/.config/Oh-My-Posh/tokyonight.omp.json'| Invoke-Expression

# Force Fastfetch to use YOUR config every time (bypass path confusion)
if (Get-Command fastfetch -ErrorAction SilentlyContinue) {
  fastfetch -c "$HOME/.config/fastfetch/config.jsonc"
}

'@
$psProfilePath = Join-Path $psProfileDir "profile.ps1"
Set-Content -Path $psProfilePath -Value $profileContent -Encoding UTF8

# 9. Overwrite Windows Terminal settings.json
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

if (Test-Path -Path $wtSettingsPath -IsValid) {
  Set-Content -Path $wtSettingsPath -Value $wtSettingsContent -Encoding UTF8 -Force
} else {
  Write-Host "Windows Terminal settings path not found. Please ensure Windows Terminal is installed." -ForegroundColor Red
}


#10 Add Git's Unix tools (usr\bin) to the PATH environment variable
Write-Host "Adding Git Unix tools to Environment PATH..." -ForegroundColor Cyan
$gitUsrBin = "C:\Program Files\Git\usr\bin"
$currentPath = [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::User)

if (Test-Path $gitUsrBin) {
  if ($currentPath -notlike "*$gitUsrBin*") {
    $newPath = $currentPath + ";" + $gitUsrBin
      [Environment]::SetEnvironmentVariable("Path", $newPath, [EnvironmentVariableTarget]::User)
      Write-Host "Successfully added $gitUsrBin to User PATH." -ForegroundColor Green
  } else {
    Write-Host "Git Unix tools are already in your PATH." -ForegroundColor Yellow
  }
} else {
  Write-Host "Git usr\bin not found. Ensure Git is installed via winget first." -ForegroundColor Red
}
#11 
# Define the target directory

$targetDir = "$HOME\Documents\PowerShell"

$tempRepoDir = "$env:TEMP\Windows-Ricing-Temp"

$repoUrl = "https://github.com/Aniruddha69/Windows-Ricing.git"


#12 Create the target directory if it doesn't exist

if (-not (Test-Path -Path $targetDir)) {

  New-Item -ItemType Directory -Path $targetDir -Force

}


# Remove temp dir if it already exists from a previous failed run

if (Test-Path -Path $tempRepoDir) {

  Remove-Item -Path $tempRepoDir -Recurse -Force

}


# Clone the repository (shallow clone for speed)

git clone --depth 1 $repoUrl $tempRepoDir


# Define the source path of the module folder within the repo

# Based on your description, it is inside the 'powershell' folder

$sourceFolder = Join-Path $tempRepoDir "Terminal\PowerShell\Modules"


if (Test-Path -Path $sourceFolder) {

# Move the module folder to Documents\PowerShell

# Use -Force to overwrite if it already exists

  Copy-Item -Path $sourceFolder -Destination $targetDir -Recurse -Force

    Write-Host "Success: 'module' has been placed in $targetDir" -ForegroundColor Green

} else {

  Write-Error "Could not find the 'module' folder at $sourceFolder. Please check the folder path inside the repository."

}


# Cleanup: Remove the temporary cloned repository

Remove-Item -Path $tempRepoDir -Recurse -Force 

Write-Host "`nComplete! Close Windows Terminal entirely and reopen it. Your new font, git tool, Unix-like bin paths, themes, layouts, autocomplete, and fastfetch profile should all be loaded!" -ForegroundColor Green
