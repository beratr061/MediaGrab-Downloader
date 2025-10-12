# GitHub'a Yükleme Rehberi

## Adım 1: Remote Ekle

Mevcut GitHub repo'nuzu ekleyin:

```bash
git remote add origin https://github.com/KULLANICI_ADI/REPO_ADI.git
```

## Adım 2: Branch Kontrol

```bash
# Ana branch'i kontrol et
git branch -M main
```

## Adım 3: Push

```bash
# İlk push (force ile mevcut repo'yu güncelle)
git push -u origin main --force

# Veya mevcut içeriği korumak istiyorsanız:
git pull origin main --allow-unrelated-histories
git push -u origin main
```

## Adım 4: GitHub Releases

Büyük dosyaları (exe, zip) GitHub Releases'e yükleyin:

1. GitHub repo'nuza gidin
2. "Releases" sekmesine tıklayın
3. "Create a new release" tıklayın
4. Tag: `v2.0`
5. Title: `MediaGrab v2.0`
6. Description:
```markdown
# MediaGrab v2.0

Modern, cross-platform video and audio downloader.

## Downloads

- **Windows Installer**: MediaGrab-Setup-v2.0.exe (161 MB)
- **Windows Portable**: MediaGrab-Portable.zip (219 MB)

## Features

- 1000+ platform support
- Multiple formats (MP4, MP3, Original Audio, Video Only)
- Multi-language (EN, TR, RU, HI, ZH)
- Light/Dark themes
- Automatic cookie support

## System Requirements

- Windows 10/11 (64-bit)
- 4 GB RAM
- 500 MB free space
```

7. Dosyaları sürükle-bırak ile ekle
8. "Publish release" tıkla

## Adım 5: README Güncelle

README.md'de download linklerini güncelleyin:

```markdown
## Download

### Windows

**Installer (Recommended)**
- [Download MediaGrab-Setup-v2.0.exe](https://github.com/KULLANICI_ADI/REPO_ADI/releases/download/v2.0/MediaGrab-Setup-v2.0.exe)

**Portable Version**
- [Download MediaGrab-Portable.zip](https://github.com/KULLANICI_ADI/REPO_ADI/releases/download/v2.0/MediaGrab-Portable.zip)
```

## Notlar

- Binary dosyaları (yt-dlp, ffmpeg) .gitignore'da olduğu için yüklenmez
- Kullanıcılar `scripts/download_binaries_simple.ps1` ile indirebilir
- Veya build'den sonra otomatik olarak embed edilir

## Gelecek Güncellemeler

```bash
# Değişiklikleri commit et
git add .
git commit -m "Update: açıklama"
git push
```
