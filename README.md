# MediaGrab

A modern, cross-platform video and audio downloader with a beautiful user interface.

## Features

- **Multiple Formats**: Download videos with audio (MP4), audio only (MP3/Original), or video only
- **1000+ Platforms**: YouTube, Instagram, TikTok, Twitter, Facebook, Twitch, Vimeo, and more
- **Smart Cookie Support**: Automatically handles authentication for platforms that require login
- **Multi-language**: English, Turkish, Russian, Hindi, Chinese
- **Modern UI**: Light/Dark themes with smooth animations and glassmorphism effects
- **Cross-platform**: Windows, macOS, and Linux support

## Download

### Windows

**Installer (Recommended)**
- Download `MediaGrab-Setup-v2.0.exe`
- Run the installer
- Launch from desktop shortcut

**Portable Version**
- Download `MediaGrab-Portable.zip`
- Extract and run `mediagrab_flutter.exe`
- No installation required

## System Requirements

- **OS**: Windows 10/11, macOS 10.14+, or Linux
- **RAM**: 4 GB minimum, 8 GB recommended
- **Storage**: 500 MB free space
- **Internet**: Required for downloads

## Usage

1. Copy a video URL from any supported platform
2. Paste it into MediaGrab
3. Select your preferred format
4. Click Download
5. Find your file in the Downloads folder

## Building from Source

### Prerequisites

- Flutter SDK 3.9.0 or higher
- Dart SDK
- Platform-specific build tools

### Setup

```bash
# Clone the repository
git clone <repository-url>
cd mediagrab_flutter

# Install dependencies
flutter pub get

# Download binaries
# Windows
powershell -ExecutionPolicy Bypass -File scripts/download_binaries_simple.ps1

# macOS/Linux
chmod +x scripts/download_binaries.sh
./scripts/download_binaries.sh
```

### Build

```bash
# Windows
flutter build windows --release

# macOS
flutter build macos --release

# Linux
flutter build linux --release
```

## Project Structure

```
mediagrab_flutter/
├── lib/
│   ├── l10n/              # Localization files
│   ├── models/            # Data models
│   ├── providers/         # State management
│   ├── screens/           # UI screens
│   ├── services/          # Business logic
│   └── widgets/           # Reusable components
├── assets/
│   ├── binaries/          # Platform binaries
│   └── cookies/           # Cookie files
└── scripts/               # Build scripts
```

## Technologies

- **Flutter** - Cross-platform UI framework
- **yt-dlp** - Video download engine
- **FFmpeg** - Media processing
- **Material Design 3** - Modern design system
- **Provider** - State management

## Legal Notice

This tool is for personal and educational use only. Please respect copyright laws and only download content you have permission to access.

## License

MIT License - See LICENSE.txt for details

## Version

**v2.0** - October 2025

---

Built with Flutter 💙
