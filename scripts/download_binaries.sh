#!/bin/bash

# MediaGrab Binary Downloader for macOS/Linux
# Run with: bash scripts/download_binaries.sh

echo "🚀 MediaGrab Binary Downloader"
echo "================================"
echo ""

# Create directories
mkdir -p assets/binaries/windows
mkdir -p assets/binaries/macos
mkdir -p assets/binaries/linux

# Function to download file
download_file() {
    local url=$1
    local output=$2
    local name=$3
    
    echo "  Downloading $name..."
    if curl -L -o "$output" "$url" --progress-bar; then
        chmod +x "$output" 2>/dev/null
        local size=$(du -h "$output" | cut -f1)
        echo "  ✅ $name downloaded ($size)"
    else
        echo "  ❌ Failed to download $name"
    fi
}

# Download Windows binaries
echo "📥 Downloading Windows binaries..."
download_file \
    "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe" \
    "assets/binaries/windows/yt-dlp.exe" \
    "yt-dlp (Windows)"

echo ""
echo "  ⚠️  FFmpeg for Windows:"
echo "  Manual download required:"
echo "  1. Visit: https://github.com/BtbN/FFmpeg-Builds/releases"
echo "  2. Download: ffmpeg-master-latest-win64-gpl.zip"
echo "  3. Extract ffmpeg.exe and ffprobe.exe to: assets/binaries/windows/"

# Download macOS binaries
echo ""
echo "📥 Downloading macOS binaries..."
download_file \
    "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp_macos" \
    "assets/binaries/macos/yt-dlp" \
    "yt-dlp (macOS)"

echo ""
echo "  Downloading FFmpeg (macOS)..."
if [[ "$OSTYPE" == "darwin"* ]]; then
    if command -v brew &> /dev/null; then
        echo "  Using Homebrew to locate FFmpeg..."
        if brew list ffmpeg &> /dev/null; then
            FFMPEG_PATH=$(brew --prefix ffmpeg)/bin
            cp "$FFMPEG_PATH/ffmpeg" assets/binaries/macos/ffmpeg
            cp "$FFMPEG_PATH/ffprobe" assets/binaries/macos/ffprobe
            chmod +x assets/binaries/macos/ffmpeg
            chmod +x assets/binaries/macos/ffprobe
            echo "  ✅ FFmpeg copied from Homebrew"
        else
            echo "  ⚠️  FFmpeg not installed via Homebrew"
            echo "  Run: brew install ffmpeg"
        fi
    else
        echo "  ⚠️  Homebrew not found"
        echo "  Download from: https://evermeet.cx/ffmpeg/"
    fi
else
    echo "  ⚠️  Not running on macOS"
    echo "  Download from: https://evermeet.cx/ffmpeg/"
fi

# Download Linux binaries
echo ""
echo "📥 Downloading Linux binaries..."
download_file \
    "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp_linux" \
    "assets/binaries/linux/yt-dlp" \
    "yt-dlp (Linux)"

echo ""
echo "  Downloading FFmpeg (Linux)..."
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Download static FFmpeg build
    FFMPEG_URL="https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz"
    TEMP_DIR=$(mktemp -d)
    
    echo "  Downloading static FFmpeg build..."
    if curl -L -o "$TEMP_DIR/ffmpeg.tar.xz" "$FFMPEG_URL" --progress-bar; then
        cd "$TEMP_DIR"
        tar -xf ffmpeg.tar.xz
        
        # Find and copy binaries
        find . -name "ffmpeg" -type f -exec cp {} "$(pwd)/../../assets/binaries/linux/ffmpeg" \;
        find . -name "ffprobe" -type f -exec cp {} "$(pwd)/../../assets/binaries/linux/ffprobe" \;
        
        cd - > /dev/null
        chmod +x assets/binaries/linux/ffmpeg
        chmod +x assets/binaries/linux/ffprobe
        
        rm -rf "$TEMP_DIR"
        echo "  ✅ FFmpeg downloaded and extracted"
    else
        echo "  ❌ Failed to download FFmpeg"
        echo "  Download manually from: https://johnvansickle.com/ffmpeg/"
    fi
else
    echo "  ⚠️  Not running on Linux"
    echo "  Download from: https://johnvansickle.com/ffmpeg/"
fi

# Summary
echo ""
echo "✅ Download complete!"
echo ""
echo "📦 Binary locations:"
echo "  Windows: assets/binaries/windows"
echo "  macOS:   assets/binaries/macos"
echo "  Linux:   assets/binaries/linux"
echo ""
echo "⚠️  Next steps:"
echo "  1. Verify all binaries are present"
echo "  2. Run: flutter pub get"
echo "  3. Run: flutter run"
