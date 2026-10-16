
# Aniruddha's Powershell Profile

Write-Host "Use 'Show-Help' to list all available functions" -ForegroundColor Yellow

#KeyBinds
Set-PSReadLineKeyHandler -Key Tab -Function MenuComplete
Set-PSReadLineKeyHandler -Chord 'Ctrl+d' -Function DeleteChar
Set-PSReadLineKeyHandler -Chord 'Ctrl+w' -Function BackwardDeleteWord
Set-PSReadLineKeyHandler -Chord 'Alt+d' -Function DeleteWord
Set-PSReadLineKeyHandler -Chord 'Ctrl+LeftArrow' -Function BackwardWord
Set-PSReadLineKeyHandler -Chord 'Ctrl+RightArrow' -Function ForwardWord
Set-PSReadLineKeyHandler -Chord 'Ctrl+z' -Function Undo
Set-PSReadLineKeyHandler -Chord 'Ctrl+y' -Function Redo

# 1. Initialize zoxide normally (this creates the default 'z' command)
Invoke-Expression (& { (zoxide init powershell | Out-String) })

# 2. Remove PowerShell's default 'cd' alias so we can overwrite it
Remove-Item -Path Alias:cd -Force -ErrorAction SilentlyContinue
Remove-Item -Path Alias:ls -Force -ErrorAction SilentlyContinue
$env:EZA_CONFIG_DIR = "$env:USERPROFILE\.config\eza"
function ls {
    eza --long --all --header --no-user --time-style="+%d-%m-%Y %H.%M" --icons --group-directories-first -I "Application Data|Cookies|Local Settings|My Documents|NetHood|PrintHood|Recent|SendTo|Start Menu|Templates|My Music|My Pictures|My Videos|All Users|Default User|Documents and Settings|ntuser*|NTUSER*" @args
}
$env:YAZI_FILE_ONE = "C:\Program Files\Git\usr\bin\file.exe"

# 3. Create our custom 'cd' function
function cd {
    z @args          # Passes your arguments to zoxide
    ls    # Lists the contents of the new directory
} 

# Functions

# System Utilities
function uptime {
    (Get-Date) - (Get-CimInstance -ClassName Win32_OperatingSystem).LastBootUpTime | Select-Object Days, Hours, Minutes, Seconds
}

function matrix {
  Clear-Host ; rusty-rain.exe
}

function clf {
  Clear-Host ; fastfetch.exe -c "$HOME/.config/fastfetch/config.jsonc"
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
function g { cd $HOME\Documents\GitHub}

function y {
	$tmp = (New-TemporaryFile).FullName
	yazi.exe @args --cwd-file="$tmp"
	$cwd = Get-Content -Path $tmp -Encoding UTF8
	if ($cwd -and $cwd -ne $PWD.Path -and (Test-Path -LiteralPath $cwd -PathType Container)) {
		Set-Location -LiteralPath (Resolve-Path -LiteralPath $cwd).Path
	}
	Remove-Item -Path $tmp
}

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
  Set-Location; cd $HOME/Documents/
}

function downloads {
  Set-Location; cd $HOME/Downloads/
}

function desktop {
  Set-Location; cd $HOME/Desktop/
}

function Update-Profile {
  Invoke-RestMethod https://github.com/Aniruddha69/Terminal/raw/main/terminal.ps1 | Invoke-Expression
}

function pipes {
  pipes-rs.exe
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
  ${command}cd${reset}                 ${accent}→${reset} ${desc}change directory ${reset}  
  ${command}matrix${reset}             ${accent}→${reset} ${desc}funny matrix${reset}  
  ${command}clf${reset}                ${accent}→${reset} ${desc}clear and fastfetch${reset}  
  ${command}docs${reset}               ${accent}→${reset} ${desc}Documents folder${reset}
  ${command}downloads${reset}               ${accent}→${reset} ${desc}Downloads folder${reset}
  ${command}desktop${reset}               ${accent}→${reset} ${desc}Desktop folder${reset}
  ${command}uptime${reset}             ${accent}→${reset} ${desc}System uptime${reset}
  ${command}winutil${reset}            ${accent}→${reset} ${desc}Run WinUtil${reset}
  ${command}winutildev${reset}         ${accent}→${reset} ${desc}Run WinUtil Dev${reset}
  ${command}pipes${reset}             ${accent}→${reset} ${desc}funny pipes${reset}  

${dim}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${reset}
"@
}
Clear-host

# Force Fastfetch to use YOUR config every time (bypass path confusion)
if (Get-Command fastfetch -ErrorAction SilentlyContinue) {
    fastfetch -c "$HOME/.config/fastfetch/config.jsonc"
}


# Minimal profile: UTF‑8 + Oh My Posh (if installed) + Fastfetch with explicit config path
oh-my-posh init pwsh --config '~/.config/Oh-My-Posh/tokyonight.omp.json'| Invoke-Expression

