# 🎨 Forge Logo Kurulum Talimatları

## ⚠️ ÖNEMLİ: Görseli Kaydetmeniz Gerekiyor

Yüklediğiniz Forge logo görselini aşağıdaki konumlara kaydetmeniz gerekiyor:

### 1️⃣ Assets Klasörüne Kaydet
📁 Konum: `aero/assets/forge_logo.png`
- Görseli bu klasöre `forge_logo.png` adıyla kaydedin

### 2️⃣ Android Drawable Klasörüne Kaydet
📁 Konum: `aero/android/app/src/main/res/drawable/forge_logo.png`
- Aynı görseli buraya da `forge_logo.png` adıyla kaydedin

---

## 🚀 Launcher Icon (Uygulama Simgesi) Oluşturma

### Kolay Yöntem: Online Araç Kullan (ÖNERİLEN)

1. **https://icon.kitchen/** sitesine gidin
2. Forge logo görselinizi yükleyin
3. "Foreground" olarak ayarlayın
4. Background'u siyah (#000000) yapın
5. "Download" butonuna tıklayın
6. İndirilen ZIP dosyasını açın
7. İçindeki `res` klasörünü projenizin `android/app/src/main/` klasörüne kopyalayın (mevcut dosyaların üzerine yazın)

### Alternatif: Manuel Oluşturma

Eğer kendiniz oluşturmak isterseniz, aşağıdaki boyutlarda PNG dosyaları oluşturun:

```
android/app/src/main/res/
├── mipmap-mdpi/ic_launcher.png (48x48 px)
├── mipmap-hdpi/ic_launcher.png (72x72 px)
├── mipmap-xhdpi/ic_launcher.png (96x96 px)
├── mipmap-xxhdpi/ic_launcher.png (144x144 px)
└── mipmap-xxxhdpi/ic_launcher.png (192x192 px)
```

---

## ✅ Yapılandırma Tamamlandı

Ben aşağıdaki işlemleri yaptım:
- ✅ `pubspec.yaml` dosyasına assets eklendi
- ✅ Splash screen yapılandırması güncellendi (siyah arka plan + logo)
- ✅ `launch_background.xml` dosyası düzenlendi

---

## 🎯 Görselleri Kaydettikten Sonra

1. Terminal'de şu komutu çalıştırın:
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

2. Uygulama açılırken siyah ekranda Forge logosu görünecek
3. Ana ekranda uygulama simgesi Forge logosu olacak

---

## 📸 Beklenen Sonuç

**Splash Screen (Yükleme Ekranı):**
- Tam ekran siyah arka plan
- Ortada büyük Forge logosu
- Uygulama yüklenene kadar görünür

**Launcher Icon (Uygulama Simgesi):**
- Ana ekranda ve uygulama çekmecesinde
- Forge logosu simgesi
- Siyah arka planlı

---

**Görselleri kaydettikten sonra bana haber verin, uygulamayı test edelim!** 🚀
