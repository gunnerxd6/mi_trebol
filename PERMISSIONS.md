# Configuración de Permisos - Mi Trébol

## 📱 Permisos de Cámara

La aplicación requiere acceso a la cámara para escanear códigos QR. A continuación se detallan las configuraciones necesarias para cada plataforma.

---

## 🤖 Android

### 1. AndroidManifest.xml

El archivo `android/app/src/main/AndroidManifest.xml` debe incluir:

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- Permisos de cámara -->
    <uses-permission android:name="android.permission.CAMERA" />
    <uses-feature android:name="android.hardware.camera" android:required="false" />
    <uses-feature android:name="android.hardware.camera.autofocus" android:required="false" />
    
    <application
        ...
    </application>
</manifest>
```

### 2. build.gradle (App level)

Verifica que `minSdkVersion` sea al menos 21:

```gradle
android {
    defaultConfig {
        minSdkVersion 21  // mobile_scanner requiere mínimo API 21
        targetSdkVersion 34
        ...
    }
}
```

### 3. Permisos en tiempo de ejecución

El paquete `mobile_scanner` maneja automáticamente la solicitud de permisos en tiempo de ejecución. No requiere código adicional.

---

## 🍎 iOS

### 1. Info.plist

Edita el archivo `ios/Runner/Info.plist` y agrega:

```xml
<dict>
    ...
    <!-- Descripción del uso de la cámara -->
    <key>NSCameraUsageDescription</key>
    <string>Necesitamos acceso a la cámara para escanear códigos QR de productos y sucursales</string>
    ...
</dict>
```

### 2. Podfile

Verifica que la versión mínima de iOS sea 12.0 o superior en `ios/Podfile`:

```ruby
platform :ios, '12.0'
```

### 3. Instalación de Pods

Después de modificar el Podfile, ejecuta:

```bash
cd ios
pod install
cd ..
```

---

## 🖥️ Windows

No requiere configuración adicional de permisos.

---

## 🐧 Linux

No requiere configuración adicional de permisos.

---

## 🌐 Web

### 1. Permisos del navegador

La aplicación solicitará automáticamente acceso a la cámara cuando el usuario intente escanear.

### 2. HTTPS requerido

La API de cámara web solo funciona en contextos seguros:
- `localhost` (para desarrollo)
- Dominios con HTTPS (para producción)

---

## ✅ Verificar Permisos

### Android
```bash
# Verificar permisos en el APK
adb shell pm list permissions -d -g | grep CAMERA
```

### iOS
```bash
# Los permisos se pueden verificar en:
# Ajustes → Privacidad → Cámara → Mi Trébol
```

---

## 🔍 Solución de Problemas

### Problema: "La cámara no funciona"

#### Android
1. Verifica que los permisos estén en `AndroidManifest.xml`
2. Desinstala y reinstala la app
3. Verifica permisos en: Ajustes → Apps → Mi Trébol → Permisos

#### iOS
1. Verifica que `NSCameraUsageDescription` esté en `Info.plist`
2. Desinstala y reinstala la app
3. Verifica permisos en: Ajustes → Privacidad → Cámara

### Problema: "Error al compilar (Android)"

Si obtienes errores relacionados con `minSdkVersion`:
```bash
flutter clean
cd android
./gradlew clean
cd ..
flutter pub get
flutter run
```

### Problema: "Error al compilar (iOS)"

Si obtienes errores relacionados con pods:
```bash
flutter clean
cd ios
rm -rf Pods
rm Podfile.lock
pod install
cd ..
flutter run
```

---

## 📚 Referencias

- [mobile_scanner package](https://pub.dev/packages/mobile_scanner)
- [Android Camera Permissions](https://developer.android.com/training/permissions/requesting)
- [iOS Camera Permissions](https://developer.apple.com/documentation/avfoundation/cameras_and_media_capture/requesting_authorization_for_media_capture_on_ios)
