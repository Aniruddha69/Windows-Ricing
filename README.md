<h1 align="center">✨ My Windows 11 Setup ✨</h1>

<p align="center">
A complete guide to my Windows 11 customization – from the YASB bar to all the little tweaks that make it clean, aesthetic, and productive.
</p>

---

## 🖼️ Screenshot
![My Desktop Screenshot](screenshot.png)  _I will add this later, dw._

---

## File Structure

<pre>

Windows-Ricing/  
├── .gitattributes  
├── LICENSE  
├── README.md  
├── Terminal/  
│   ├── fastfetch/  
│   │   ├── ascii.txt  
│   │   └── config.jsonc  
│   ├── Oh-My-Posh/  
│   │   └── tokyonight.omp.json  
│   ├── PowerShell/  
│   │   ├── Modules/  
│   │   │   ├── Microsoft.PowerToys.Configure/  
│   │   │   │   ├── 0.98.1.0/  
│   │   │   │   │   ├── Microsoft.PowerToys.Configure.psd1  
│   │   │   │   │   └── Microsoft.PowerToys.Configure.psm1  
│   │   │   │   └── 0.99.1.0/  
│   │   │   │       ├── Microsoft.PowerToys.Configure.psd1  
│   │   │   │       └── Microsoft.PowerToys.Configure.psm1  
│   │   │   └── Terminal-Icons/  
│   │   │       └── 0.11.0/  
│   │   │           ├── Data/  
│   │   │           │   ├── colorThemes/  
│   │   │           │   │   ├── devblackops_light.psd1  
│   │   │           │   │   └── devblackops.psd1  
│   │   │           │   ├── glyphs.ps1  
│   │   │           │   └── iconThemes/  
│   │   │           │       └── devblackops.psd1  
│   │   │           ├── en-US/  
│   │   │           │   └── Terminal-Icons-help.xml  
│   │   │           ├── PSGetModuleInfo.xml  
│   │   │           ├── Terminal-Icons.format.ps1xml  
│   │   │           ├── Terminal-Icons.psd1  
│   │   │           └── Terminal-Icons.psm1  
│   │   └── profile.ps1  
│   ├── README.md  
│   ├── Resources/  
│   │   ├── terminalexample1.png  
│   │   └── terminalexample2.png  
│   ├── Terminal/  
│   │   └── settings.json  
│   └── terminal.ps1  
└── yasb/  
    ├── config.yaml  
    └── styles.css
 
</pre>

* `LICENSE`: MIT License.

 ---

## 📑 Table of Contents

| 📚 Entry | ✨ App |
|---------------------|------------|
| Status Bar          | [YASB](#yasb) |
| App Launcher        | [Flow Launcher](#flowlauncher) |
| Terminal            | [Windows Terminal](#windows-terminal) |
| System Fetch        | [Fastfetch](#Fastfetch) | 
| Audio Visualizer    | [Cava](#cava) |

Other

| 📚 Entry | ✨ App |
|---------------------|------------|
| Colorscheme         | [Catppuccin Mocha](https://catppuccin.com) |
| Font                | [JetBrainsMono Nerd Font](https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip) |

---

# ⚡ Details

## 📏 YASB
> [!NOTE] 
> Some stuff in my config might not work if you just copy and paste it. Be sure to app your api for the weather widget to work and your wallpaper folder location for the wallpapers widget

A highly configurable Windows status bar written in Python. 

**⚙️ Installation:**  
You can follow the steps below, or jump to the [**setup video**](https://www.youtube.com/watch?v=your-video-id).
- Install [**YASB**]([(https://github.com/amnweb/yasb)])   
- Copy the config files from [**here**](https://github.com/Aniruddha69/Windows-Ricing/tree/main/yasb).
- Remove the codes from **your** YASB config and paste the one you just copied.
- Restart **YASB** for the changes to take effect.

---

## 👾 Terminal + Fastfetch
> [!NOTE] 
> If you just wanna fully use it just like I'm using then I recommend watchng the video. If you just want the config for Fastfetch then just paste the config where **your** Fastfetch config is located. If you have a PowerShell profile then just add your location and other stuff in your profile yourself as idk what you got.
>
> If you see **"execution of scripts is disabled on this system"**, don’t panic! Just open PowerShell as Administrator and run: 
> `Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force`
>
> Also if you notice that the ASCII art is not showing then try editing `"source": "C:/Users/%USERPROFILE%/.config/fastfetch/ascii.txt"` to `"source": "%USERPROFILE%/.config/fastfetch/ascii.txt"`. That should fix it.
 
Fastfetch is a neofetch-like tool for fetching system information and displaying it in a visually appealing way. It is written mainly in C, with a focus on performance and customizability.

**⚙️ Installation:**  
You can follow the steps below, or jump to the [**setup video**](https://www.youtube.com/watch?v=your-video-id) if you want your terminal to look 1:1 to mine.
- Install [**Fastfetch**](https://github.com/fastfetch-cli/fastfetch/releases) and I believe you already got the **Windows terminal** installed.
- Copy the config file for your Terminal [**here**](https://github.com/Aniruddha69/Windows-Ricing/tree/main/Terminal), PowerShell profile from [**here**](https://github.com/Aniruddha69/Windows-Ricing/tree/main/PowerShell) and Fastfetch config from [**here**](https://github.com/Aniruddha69/Windows-Ricing/tree/main/fastfetch)
- Remove the codes from the settings.json file in **your terminal** and paste the one you just copied from above. Do the same thing for your PowerShell profile.
- Create a **.config** *hidden* file in your C:\Users\%USERPROFILE% and create a folder called **fastfetch** inside. Copy the config and ascii code you just downloaded and paste it in that folder.
- Change the %USERPROFILE% from the config file in the fastfetch folder and the PowerShell profile with **your username**..
- Restart your terminal and your done. If this feel complicated just watch the [**setup video coming soon**].

---
