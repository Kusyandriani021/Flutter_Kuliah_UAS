# Panduan Build APK Flutter

## Praktikum Pengembangan Aplikasi Mobile

### Prasyarat

1. Flutter SDK terinstall dengan benar
2. Android Studio terinstall
3. JDK 11 terinstall
4. Android SDK terinstall
5. Path environment variables sudah dikonfigurasi dengan benar

### Langkah-langkah Build APK

#### 1. Persiapan Project

1. Buka terminal di root project
2. Jalankan perintah berikut untuk memastikan semua dependencies terinstall:

```bash
flutter pub get
```

#### 2. Konfigurasi Android

1. Buka file `android/app/build.gradle.kts`
2. Pastikan konfigurasi sesuai:

```kotlin
android {
    namespace = "com.example.flutter_kuliah"
    compileSdk = flutter.compileSdkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    defaultConfig {
        applicationId = "com.example.flutter_kuliah"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }
}
```

#### 3. Konfigurasi Keystore (Untuk Release)

1. Buat keystore baru dengan perintah:

```bash
keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

2. Simpan keystore di folder `android/app`
3. Tambahkan konfigurasi di `android/key.properties`:

```properties
storePassword=<password-keystore>
keyPassword=<password-key>
keyAlias=upload
storeFile=upload-keystore.jks
```

4. Update `android/app/build.gradle.kts`:

```kotlin
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
            storeFile = file(keystoreProperties["storeFile"] as String)
            storePassword = keystoreProperties["storePassword"] as String
        }
    }
    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}
```

#### 4. Build APK

1. Build APK Debug (untuk testing):

```bash
flutter build apk --debug
```

2. Build APK Release (untuk production):

```bash
flutter build apk --release
```

3. Build APK Split (untuk mengoptimalkan ukuran):

```bash
flutter build apk --split-per-abi
```

#### 5. Lokasi Output APK

- Debug APK: `build/app/outputs/flutter-apk/app-debug.apk`
- Release APK: `build/app/outputs/flutter-apk/app-release.apk`
- Split APKs:
  - `build/app/outputs/flutter-apk/app-armeabi-v7a-release.apk`
  - `build/app/outputs/flutter-apk/app-arm64-v8a-release.apk`
  - `build/app/outputs/flutter-apk/app-x86_64-release.apk`

### Troubleshooting Umum

1. **Error: Failed to find target with hash string 'android-XX'**

   - Solusi: Update Android SDK melalui Android Studio

2. **Error: Keystore file not found**

   - Solusi: Pastikan path keystore benar dan file ada di lokasi yang ditentukan

3. **Error: Gradle build failed**

   - Solusi:
     ```bash
     flutter clean
     flutter pub get
     flutter build apk
     ```

4. **Error: Kotlin DSL related issues**
   - Solusi: Pastikan menggunakan sintaks Kotlin yang benar di build.gradle.kts
   - Periksa versi Kotlin di project

### Tips Tambahan

1. **Optimasi Ukuran APK**

   - Gunakan `flutter build apk --split-per-abi`
   - Hapus resources yang tidak digunakan
   - Kompres gambar dan aset

2. **Testing APK**

   - Install APK di device fisik
   - Test di berbagai versi Android
   - Periksa performa dan penggunaan memori

3. **Keamanan**
   - Jangan share keystore
   - Simpan password keystore dengan aman
   - Gunakan ProGuard untuk obfuscation

### Referensi

- [Flutter Documentation](https://flutter.dev/docs)
- [Android Developer Documentation](https://developer.android.com/studio/build)
- [Flutter Build Modes](https://flutter.dev/docs/testing/build-modes)
- [Kotlin DSL Documentation](https://docs.gradle.org/current/userguide/kotlin_dsl.html)
