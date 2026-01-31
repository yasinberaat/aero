# Forge Logo Kurulum Talimatları

## Adım 1: Logo Dosyasını Kaydet
1. Yüklediğiniz Forge logo görselini `assets/forge_logo.png` olarak kaydedin
2. Aynı görseli `android/app/src/main/res/drawable/forge_logo.png` olarak da kaydedin

## Adım 2: Launcher Icon Boyutları
Android için farklı boyutlarda icon'lar oluşturmanız gerekiyor:

### Gerekli Klasörler ve Boyutlar:
- `mipmap-mdpi/ic_launcher.png` - 48x48 px
- `mipmap-hdpi/ic_launcher.png` - 72x72 px
- `mipmap-xhdpi/ic_launcher.png` - 96x96 px
- `mipmap-xxhdpi/ic_launcher.png` - 144x144 px
- `mipmap-xxxhdpi/ic_launcher.png` - 192x192 px

### Online Araçlar:
1. https://icon.kitchen/ - Android icon generator (önerilen)
2. https://appicon.co/ - Tüm platformlar için icon generator
3. https://easyappicon.com/ - Basit icon generator

## Adım 3: Manuel Kurulum (Alternatif)
Eğer online araç kullanmak istemezseniz:
1. Logo görselini Photoshop/GIMP ile açın
2. Yukarıdaki boyutlarda yeniden boyutlandırın
3. Her birini ilgili klasöre kaydedin

## Otomatik Kurulum
Ben gerekli dosyaları ve yapılandırmayı oluşturuyorum. Siz sadece görseli kaydedin.
