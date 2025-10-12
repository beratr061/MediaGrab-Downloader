# GitHub Release Oluşturma Rehberi

## Adım 1: GitHub'a Git

1. Tarayıcıda aç: https://github.com/beratr061/MediaGrab-Downloader
2. "Releases" sekmesine tıkla (sağ tarafta)
3. "Create a new release" butonuna tıkla

## Adım 2: Release Bilgilerini Doldur

### Tag
- **Tag version**: `v2.0`
- **Target**: `main` (branch)

### Release Title
```
MediaGrab v2.0 - Complete Rewrite
```

### Description
`RELEASE_NOTES_v2.0.md` dosyasının içeriğini kopyala yapıştır.

## Adım 3: Dosyaları Yükle

Aşağıdaki dosyaları "Attach binaries" bölümüne sürükle-bırak:

1. **MediaGrab-Setup-v2.0.exe** (161 MB)
   - Konum: `C:\MediaGrab\mediagrab_flutter\MediaGrab-Setup-v2.0.exe`

2. **MediaGrab-Portable.zip** (219 MB)
   - Konum: `C:\MediaGrab\mediagrab_flutter\MediaGrab-Portable.zip`

## Adım 4: Yayınla

1. "Set as the latest release" işaretli olsun
2. "Publish release" butonuna tıkla

## Adım 5: Doğrula

Release yayınlandıktan sonra:

1. Download linklerini test et
2. README.md'deki linklerin çalıştığını kontrol et
3. Release sayfasının düzgün göründüğünü kontrol et

## Gelecek Güncellemeler İçin

### Yeni Versiyon (örn: v2.1)

```bash
# Değişiklikleri yap
git add .
git commit -m "Version 2.1: Yeni özellikler"
git push

# Tag oluştur
git tag v2.1
git push origin v2.1

# GitHub'da yeni release oluştur
# Tag: v2.1
# Title: MediaGrab v2.1 - Yeni Özellikler
# Description: Değişiklikleri listele
```

## Notlar

- Release dosyaları GitHub'ın CDN'inde saklanır
- Dosya boyutu limiti: 2 GB per file
- Release'ler kalıcıdır, silinse bile tag kalır
- Her release için yeni tag kullan (v2.0, v2.1, v2.2, vb.)

## Hızlı Linkler

- **Releases**: https://github.com/beratr061/MediaGrab-Downloader/releases
- **New Release**: https://github.com/beratr061/MediaGrab-Downloader/releases/new
- **Tags**: https://github.com/beratr061/MediaGrab-Downloader/tags
