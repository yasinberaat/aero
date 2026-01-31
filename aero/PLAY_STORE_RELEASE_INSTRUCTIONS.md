# 🚀 Google Play Store Yükleme Talimatları - Forge

## ⚠️ ÖNEMLİ: Keystore Şifresi Hatası

Release build sırasında keystore şifresi hatası aldık. İşte çözüm:

### Adım 1: Keystore Şifresini Kontrol Et

`android/key.properties` dosyasını açın ve şifrelerin doğru olduğundan emin olun:

```properties
storePassword=YourStorePassword
keyPassword=YourKeyPassword
keyAlias=aero
storeFile=C:/Users/Yasin/Desktop/aero_key.jks
```

**Önemli:** 
- `storePassword` ve `keyPassword` keystore oluştururken belirlediğiniz şifreler olmalı
- Eğer şifreleri unuttuysanız, yeni bir keystore oluşturmanız gerekecek

---

## 📦 Release Build Oluşturma

Şifreleri düzelttikten sonra:

```bash
cd C:\Users\Yasin\Desktop\programming\aero\aero
flutter build appbundle --release --no-tree-shake-icons
```

**Başarılı olursa:**
```
✓ Built build/app/outputs/bundle/release/app-release.aab
```

AAB dosyası şurada olacak:
```
C:\Users\Yasin\Desktop\programming\aero\aero\build\app\outputs\bundle\release\app-release.aab
```

---

## 🔑 Yeni Keystore Oluşturma (Eğer Şifre Unutulduysa)

```bash
keytool -genkey -v -keystore C:\Users\Yasin\Desktop\forge_key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias forge
```

**Sorulacak Bilgiler:**
- Keystore şifresi (en az 6 karakter)
- İsim ve soyisim
- Organizasyon birimi
- Organizasyon adı
- Şehir
- Eyalet
- Ülke kodu (TR)

**Sonra `key.properties` dosyasını güncelleyin:**
```properties
storePassword=YeniŞifreniz
keyPassword=YeniŞifreniz
keyAlias=forge
storeFile=C:/Users/Yasin/Desktop/forge_key.jks
```

---

## 📱 Google Play Console'da Uygulama Oluşturma

### 1. Play Console'a Giriş
https://play.google.com/console

### 2. Yeni Uygulama Oluştur
- "Uygulama oluştur" butonuna tıklayın
- **Uygulama adı:** Forge
- **Varsayılan dil:** Türkçe
- **Uygulama türü:** Uygulama
- **Ücretsiz mi:** Evet
- Beyanları kabul edin

### 3. Uygulama Detayları

#### Kısa Açıklama (80 karakter)
```
Forge - Üretkenlik yardımcınız. Finans, iş ve spor takibi.
```

#### Tam Açıklama (4000 karakter)
```
Forge, hayatınızı organize etmenize yardımcı olan kapsamlı bir üretkenlik uygulamasıdır.

🎯 ÖZELLİKLER:

💰 FİNANS YÖNETİMİ
• Gelir ve gider takibi
• Kategori bazlı harcama analizi
• Günlük kar/zarar hesaplama
• Haftalık finansal özet
• Renkli grafikler ve görselleştirme

💼 İŞ YÖNETİMİ
• Günlük görev listesi
• Tekrarlayan görevler (haftanın belirli günleri)
• Sürekli tekrarlama seçeneği
• Öncelik seviyeleri
• Deadline bildirimleri

🏋️ SPOR TAKİBİ
• Haftalık antrenman programı
• Egzersiz notları
• Set ve tekrar takibi
• İlerleme kaydı

✨ GENEL ÖZELLİKLER:
• Modern ve şık arayüz
• Karanlık mod desteği
• Hızlı ve akıcı kullanım
• Offline çalışma
• Veri güvenliği

Forge ile hayatınızın kontrolünü elinize alın!
```

#### Uygulama İkonu
- 512x512 PNG (şeffaf arka plan yok)
- Forge logonuzu kullanın

#### Ekran Görüntüleri
En az 2, en fazla 8 adet:
- Telefon: 1080x2340 px
- Ana ekran, Finans, İş, Spor sayfalarından screenshot'lar

#### Öne Çıkan Grafik
1024x500 px - Forge logosu ve slogan

### 4. İçerik Derecelendirmesi
- Hedef kitle: 3+ (Herkes)
- Şiddet: Yok
- Cinsel içerik: Yok
- Uyuşturucu: Yok

### 5. Hedef Kitle
- Yaş aralığı: 13+
- Hedef ülkeler: Türkiye (başlangıç için)

### 6. Fiyatlandırma
- Ücretsiz
- Uygulama içi satın alma: Hayır
- Reklamlar: Hayır

### 7. Gizlilik Politikası
Bir gizlilik politikası URL'i gerekli. Basit bir örnek:

```
Forge Gizlilik Politikası

Forge uygulaması hiçbir kişisel veri toplamaz.
Tüm verileriniz cihazınızda yerel olarak saklanır.
Hiçbir veri sunucularımıza gönderilmez.
Üçüncü taraf servisler kullanılmaz.

İletişim: yasinberaat@gmail.com
```

Bu metni GitHub Pages, Blogger veya kendi web sitenizde yayınlayın.

### 8. AAB Dosyasını Yükle

**Üretim → Yeni sürüm oluştur**
- AAB dosyasını yükleyin
- Sürüm adı: 1.0.0 (1)
- Sürüm notları:
  ```
  İlk sürüm
  • Finans yönetimi
  • İş takibi
  • Spor programı
  • Karanlık mod
  ```

### 9. İncelemeye Gönder

Tüm bilgileri doldurduktan sonra "İncelemeye gönder" butonuna tıklayın.

**İnceleme süresi:** 1-7 gün

---

## ✅ Kontrol Listesi

- [ ] Keystore şifresi doğru
- [ ] AAB dosyası oluşturuldu
- [ ] Play Console hesabı oluşturuldu ($25 tek seferlik ücret)
- [ ] Uygulama detayları dolduruldu
- [ ] Ekran görüntüleri hazırlandı
- [ ] Gizlilik politikası URL'i eklendi
- [ ] AAB dosyası yüklendi
- [ ] İncelemeye gönderildi

---

## 🆘 Sorun Giderme

### "Keystore password was incorrect"
- `key.properties` dosyasındaki şifreleri kontrol edin
- Keystore oluştururken kullandığınız şifreleri kullanın
- Gerekirse yeni keystore oluşturun

### "Failed to read key aero from store"
- `keyAlias` doğru mu kontrol edin
- Keystore dosyası doğru konumda mı kontrol edin

### "Tree shake icons error"
- `--no-tree-shake-icons` flag'ini kullanın

---

## 📞 İletişim

Sorun yaşarsanız:
1. Hata mesajını tam olarak kopyalayın
2. Hangi adımda olduğunuzu belirtin
3. Bana bildirin

**Başarılar! 🚀**
