<h1 align="center">✨ Terminal ✨</h1>

<h3 align="center">A single-liner solution for a wholesome, aesthetic Windows Terminal setup.</h3>

<p align="center">
  <img src="https://img.shields.io/badge/OS-Windows-blue?style=flat-square\&logo=windows" alt="Windows">
  <img src="https://img.shields.io/badge/Shell-PowerShell-blue?style=flat-square\&logo=powershell" alt="PowerShell">
  <img src="https://img.shields.io/badge/Theme-Catppuccin-ABE9B3?style=flat-square" alt="Catppuccin">
</p>

\---
## Pic of my Terminal

<p align="center">
  <img width="1243" height="671" alt="image" src="https://github.com/user-attachments/assets/86626471-ff88-42c7-a16d-93aaf9034e0a" />
</p>

> [!NOTE]
>  It changes resirtry key to register font files it in the Current User registry

## 🚀 Features

This setup script automates the transformation of your Windows Terminal into a productive and beautiful environment:

* **📦 Automated Installation**: Installs PowerShell 7 and Fastfetch using `winget`.
* **🎨 Catppuccin Mocha Theme**: Pre-configured color scheme for a modern, soft look.
* **✨ Custom Fastfetch**: Includes a unique ASCII art logo and system info layout.
* **⌨️ Enhanced PowerShell Profile**:

  * Custom keybindings (Ctrl+D to delete, Ctrl+Z to undo, etc.).
  * Useful utility functions (`uptime`, `winutil`).
  * Powerful Git shortcuts (`gs`, `ga`, `gcom`, `lazyg`).
  * Integrated `Show-Help` command to see all available shortcuts.
* **🖼️ Aesthetic Terminal Settings**:

  * Acrylic transparency (80% opacity).
  * JetBrainsMono Nerd Font integration.
  * Custom cursor and padding.

## 🛠️ Usage

1. Run the setup script:

```powershell
   irm https://github.com/Aniruddha69/Terminal/raw/main/setup.ps1 | iex
   ```

2. **Restart Windows Terminal** to see the changes.

## 📂 File Structure

* `setup.ps1`: The main automation script.
* `LICENSE`: MIT License.

## 🛠️ Customization

* **Fastfetch**: Config located at `~\.config\fastfetch\config.jsonc`.
* **PowerShell Profile**: Located at `~\Documents\PowerShell\profile.ps1`.
* **Terminal Settings**: Automatically updates `~\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json`.

## 🔄 What it changed

* **Install/Updated Winget Package Manager**
* **Installs JetbrainMono Nerd Font by downloding and moving .ttf to appropriate location**
* **Install/Updates Git, Powershell, Windows Terminal, and fastfetch**
* **Adding fastfetch, PowerShell Profile, and Terminal Settings configs to designated directories**
* **Adding everyday commands in PowerShell via Git usr/bin**
* **Adding autocomplete in terminal**

\---

<p align="center">Built with 💖 for a better terminal experience.</p>

