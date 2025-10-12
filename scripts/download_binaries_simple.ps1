# MediaGrab Binary Downloader - Simple Version
Write-Host "MediaGrab Binary Downloader" -ForegroundColor Cyan
Write-Host "===========================" -ForegroundColor Cyan
Write-Host ""

# Create directories
New-Item -ItemType Directory -Force -Path "assets/binaries/windows" | Out-Null
New-Item -ItemType Directory -Force -Path "assets/binaries/macos" | Out-Null
New-Item -ItemType Directory -Force -Path "assets/binaries/linux" | Out-Null

# Download Windows yt-dlp
Write-Host "Downloading yt-dlp for Windows..." -ForegroundColor Yellow
Invoke-WebRequest -Uri "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp.exe" -OutFile "assets/binaries/windows/yt-dlp.exe"
Write-Host "Done: yt-dlp.exe" -ForegroundColor Green

# Download macOS yt-dlp
Write-Host "Downloading yt-dlp for macOS..." -ForegroundColor Yellow
Invoke-WebRequest -Uri "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp_macos" -OutFile "assets/binaries/macos/yt-dlp"
Write-Host "Done: yt-dlp (macOS)" -ForegroundColor Green

# Download Linux yt-dlp
Write-Host "Downloading yt-dlp for Linux..." -ForegroundColor Yellow
Invoke-WebRequest -Uri "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp_linux" -OutFile "assets/binaries/linux/yt-dlp"
Write-Host "Done: yt-dlp (Linux)" -ForegroundColor Green

# Download FFmpeg for Windows
Write-Host ""
Write-Host "Downloading FFmpeg for Windows (this may take a while)..." -ForegroundColor Yellow
$ffmpegZip = "$env:TEMP/ffmpeg.zip"
Invoke-WebRequest -Uri "https://github.com/BtbN/FFmpeg-Builds/releases/download/latest/ffmpeg-master-latest-win64-gpl.zip" -OutFile $ffmpegZip

Write-Host "Extracting FFmpeg..." -ForegroundColor Yellow
Expand-Archive -Path $ffmpegZip -DestinationPath "$env:TEMP/ffmpeg" -Force

# Find and copy binaries
$ffmpegExe = Get-ChildItem -Path "$env:TEMP/ffmpeg" -Recurse -Filter "ffmpeg.exe" | Select-Object -First 1
$ffprobeExe = Get-ChildItem -Path "$env:TEMP/ffmpeg" -Recurse -Filter "ffprobe.exe" | Select-Object -First 1

if ($ffmpegExe) {
    Copy-Item $ffmpegExe.FullName -Destination "assets/binaries/windows/ffmpeg.exe"
    Write-Host "Done: ffmpeg.exe" -ForegroundColor Green
}

if ($ffprobeExe) {
    Copy-Item $ffprobeExe.FullName -Destination "assets/binaries/windows/ffprobe.exe"
    Write-Host "Done: ffprobe.exe" -ForegroundColor Green
}

# Cleanup
Remove-Item $ffmpegZip -Force -ErrorAction SilentlyContinue
Remove-Item "$env:TEMP/ffmpeg" -Recurse -Force -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "Windows binaries complete!" -ForegroundColor Green
Write-Host ""
Write-Host "For macOS and Linux FFmpeg:" -ForegroundColor Yellow
Write-Host "  macOS: Download from https://evermeet.cx/ffmpeg/" -ForegroundColor Gray
Write-Host "  Linux: Download from https://johnvansickle.com/ffmpeg/" -ForegroundColor Gray
Write-Host ""
Write-Host "Next: flutter pub get && flutter run" -ForegroundColor Cyan
