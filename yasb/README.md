# 🎨 yasb - Yet Another Sleek Bloatware

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform: Windows 11](https://img.shields.io/badge/Platform-Windows%2011-blue.svg)](https://www.microsoft.com/windows/windows-11)
[![PowerShell: 5.1+](https://img.shields.io/badge/PowerShell-5.1%2B-green.svg)](https://docs.microsoft.com/en-us/powershell/)
[![Status: Maintenance](https://img.shields.io/badge/Status-Maintenance-orange.svg)](https://github.com/yourusername/windows-ricing/yasb)

A collection of PowerShell scripts designed to automate the process of setting up and customizing Windows 11 with a modern, sleek aesthetic.

## 📋 Overview

yasb (Yet Another Sleek Bloatware) provides a comprehensive set of PowerShell scripts that help you:

- 🎨 Install popular Windows 11 themes and visual tweaks
- 🖼️ Set up custom wallpapers and aesthetic enhancements
- ⚙️ Configure system settings for optimal performance and appearance
- 🚀 Automate common Windows 11 customization tasks

## 🚀 Installation

First, clone this repository to your machine:

```bash
git clone https://github.com/yourusername/windows-ricing/yasb.git
```

Then install the required dependencies:

```powershell
# Make sure you have PowerShell 5.1 or later
# You may need to allow unsigned scripts to run
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
```

## ▶️ Usage

Run the main PowerShell script to apply all customizations:

```powershell
.\yasb.ps1
```

This script will:

1. 💾 Create a backup of your current settings
2. 🎨 Install and configure all aesthetic enhancements
3. 🖼️ Apply custom themes and wallpapers
4. ⚡ Optimize system performance settings
5. 🔄 Restart necessary services

## ⚙️ Configuration

You can customize the behavior of the scripts by editing the `yasb.ps1` file before running it. Some key settings include:

- **🖼️ Wallpapers folder**: Change the path to your preferred wallpapers directory
- **🎨 Theme settings**: Adjust colors, effects, and animations
- **📦 Installed applications**: Add/remove software from the installation list
- **🔔 Notification settings**: Configure how and when notifications appear

## ✨ Features

- **🎨 Visual Tweaks**: Acrylic transparency, custom borders, rounded corners
- **🌗 Themes**: Dark mode, light mode, and system theme support
- **🖼️ Wallpapers**: Dynamic wallpaper support, organized wallpaper folders
- **⚡ Performance**: System optimizations and resource management
- **🎭 Aesthetic Enhancements**: Custom cursors, icons, and visual effects

## 🔧 Troubleshooting

### Common Issues:

**❓ The script asks for permissions**
- 💻 Run PowerShell as Administrator
- 📁 Navigate to the project directory first

**🖼️ Custom wallpapers don't appear**
- 📂 Ensure your wallpaper folder structure is correct
- 🖼️ Check that the image files are in PNG/JPG format

**🐌 System performance slows down**
- ⏳ This is normal during initial setup
- 🚀 The system will stabilize after all optimizations are applied

**🔍 Features are missing**
- 📋 Check the script output for error messages
- 🪟 Verify your Windows 11 version supports the feature

## 💬 Support

For support, questions, or feature requests:

- 🐛 Create an issue on this repository
- 📚 Check the project documentation for detailed guides
- 💬 Visit the project's Discord or Telegram community

## 🤝 Contributing

Contributions are welcome! Please:

1. 🍴 Fork the repository
2. 🌿 Create a feature branch
3. ✏️ Make your changes
4. 📬 Submit a pull request

This project follows the best practices for clean, maintainable PowerShell code. Please review our contributing guidelines for more details.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

**Quick Links:**
- 🏠 [Home](#-yasb---yet-another-sleek-bloatware)
- 📋 [Overview](#-overview)
- 🚀 [Installation](#-installation)
- ▶️ [Usage](#️-usage)
- ⚙️ [Configuration](#️-configuration)
- ✨ [Features](#-features)
- 🔧 [Troubleshooting](#-troubleshooting)
- 💬 [Support](#-support)
- 🤝 [Contributing](#-contributing)
- 📄 [License](#-license)