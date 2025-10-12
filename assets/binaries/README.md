# Binary Files

Bu klasör yt-dlp ve FFmpeg binary dosyalarını içerir.

## 📥 İndirme

Binary'leri indirmek için proje kök dizininde:

**Windows:**
```powershell
powershell -ExecutionPolicy Bypass -File scripts/download_binaries.ps1
```

**macOS/Linux:**
```bash
chmod +x scripts/download_binaries.sh
./scripts/download_binaries.sh
```

## 📂 Yapı

```
binaries/
├── windows/
│   ├── yt-dlp.exe
│   ├── ffmpeg.exe
│   └── ffprobe.exe
├── macos/
│   ├── yt-dlp
│   ├── ffmpeg
│   └── ffprobe
└── linux/
    ├── yt-dlp
    ├── ffmpeg
    └── ffprobe
```

Detaylı bilgi için: [BINARY_SETUP.md](../../BINARY_SETUP.md)
