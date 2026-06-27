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

# Install Git, PowerShell 7, and Fastfetch using Winget
Write-Host "`nInstalling Git, PowerShell 7, Yazi, and Dependencies..." -ForegroundColor Cyan
winget install --id Git.Git  --source winget --accept-package-agreements --accept-source-agreements
winget install --id Microsoft.PowerShell --source winget --accept-package-agreements --accept-source-agreements 
winget install --id Gyan.FFmpeg --source winget --accept-package-agreements --accept-source-agreements
winget install --id Mircosoft.WindowsTerminal --source winget --accept-package-agreements --accept-source-agreements
winget install --id JanDeDobbeleer.OhMyPosh --source winget --accept-package-agreements --accept-source-agreements 
winget install --id 7zip.7zip --source winget --accept-package-agreements --accept-source-agreements 
winget install --id ImageMagick.ImageMagick --source winget --accept-package-agreements --accept-source-agreements 
winget install --id jqlang.jq  --source winget --accept-package-agreements --accept-source-agreements 
winget install --id oschwartz10612.Poppler  --source winget --accept-package-agreements --accept-source-agreements 
winget install --id sharkdp.fd  --source winget --accept-package-agreements --accept-source-agreements 
winget install --id BurntSushi.ripgrep.MSVC  --source winget --accept-package-agreements --accept-source-agreements 
winget install --id junegunn.fzf  --source winget --accept-package-agreements --accept-source-agreements 
winget install --id ajeetdsouza.zoxide --source winget --accept-package-agreements --accept-source-agreements 
winget install --id sxyazi.yazi --source winget --accept-package-agreements --accept-source-agreements 


