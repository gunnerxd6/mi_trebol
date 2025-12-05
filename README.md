# Mi Trébol - Consulta de Precios

Aplicación móvil para consultar precios de productos en las sucursales de El Trébol.

## 🚀 Características

- **Login con QR**: Escanea el código QR de tu sucursal para ingresar
- **Consulta de Precios**: Escanea productos para ver su precio en tiempo real
- **Ofertas**: Visualiza productos con precio de oferta y ahorro
- **Persistencia**: La sesión de la sucursal se mantiene entre aperturas de la app

## 📋 Requisitos

- Flutter SDK >= 3.10.1
- Dart >= 3.10.1
- Android/iOS/Windows/macOS/Linux/Web

## 🔧 Configuración

### 1. Instalar dependencias

```bash
flutter pub get
```

### 2. Configurar variables de entorno

Edita el archivo `.env` en la raíz del proyecto y completa las siguientes variables:

```env
# Configuración de la API
API_URL=https://tu-api.com
API_TOKEN=tu-token-aqui
```

**Importante**: Asegúrate de no incluir una barra diagonal al final de la URL.

### 3. Permisos de cámara

#### Android
El permiso de cámara ya está configurado en `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-feature android:name="android.hardware.camera" />
```

#### iOS
Agrega a `ios/Runner/Info.plist`:
```xml
<key>NSCameraUsageDescription</key>
<string>Necesitamos acceso a la cámara para escanear códigos QR</string>
```

## 🏃‍♂️ Ejecutar la aplicación

```bash
flutter run
```

Para un dispositivo específico:
```bash
flutter devices
flutter run -d <device-id>
```

## 📁 Estructura del Proyecto

```
lib/
├── data/
│   ├── models/              # Modelos de datos
│   │   ├── sucursal_model.dart
│   │   └── producto_model.dart
│   └── services/            # Servicios
│       ├── api_service.dart
│       └── storage_service.dart
├── modules/                 # Módulos de la aplicación
│   ├── login/
│   │   ├── login_view.dart
│   │   ├── login_controller.dart
│   │   └── login_binding.dart
│   ├── consulta_precios/
│   │   ├── consulta_precios_view.dart
│   │   ├── consulta_precios_controller.dart
│   │   └── consulta_precios_binding.dart
│   └── producto_detalle/
│       ├── producto_detalle_view.dart
│       ├── producto_detalle_controller.dart
│       └── producto_detalle_binding.dart
├── routes/                  # Configuración de rutas
│   ├── app_routes.dart
│   └── app_pages.dart
└── main.dart               # Punto de entrada
```

## 🎯 Flujo de la Aplicación

1. **Login**: 
   - Usuario escanea código QR de la sucursal
   - Se valida contra el endpoint `/api-consulta-precios/consulta-sucursal`
   - La información de la sucursal se guarda localmente

2. **Consulta de Precios**:
   - Usuario presiona botón para escanear producto
   - Se escanea el código QR del producto
   - Se consulta el precio contra `/api-consulta-precios/consulta-producto`
   - Se muestra el detalle del producto

3. **Detalle del Producto**:
   - Muestra nombre, precio y oferta (si aplica)
   - Calcula el ahorro en productos con oferta
   - Permite consultar otro producto

## 🔌 API Endpoints

### Consultar Sucursal
```
POST /api-consulta-precios/consulta-sucursal
Headers: X-API-TOKEN
Body: { "codigoSucursal": "SU16EM1" }
Response: {
  "id": 16,
  "sucursal": "CAJON",
  "sucursalCodigo": "SU16EM1",
  "empresa": "EL TREBOL"
}
```

### Consultar Producto
```
POST /api-consulta-precios/consulta-producto
Headers: X-API-TOKEN
Body: { 
  "codigoProducto": "36109",
  "codigoSucursal": "SU16EM1"
}
Response: {
  "sucursalId": 16,
  "sucursalCodigo": "SU16EM1",
  "sucursalNombre": "CAJON",
  "nombreFantasia": "EL TREBOL",
  "razonSocial": "COMERCIAL AMAR HERMANOS Y COMPANIA LIMITADA",
  "productoId": 20204,
  "productoNombre": "TRUTRO ALA POLLO ASADO   1 KG",
  "productoCodigo": "36109",
  "precioCaja": 8760,
  "listaPrecio": "LISTA PRECIOS BASE"
}
```

## 📦 Dependencias Principales

- **GetX**: Gestión de estado, navegación y dependencias
- **Dio**: Cliente HTTP para peticiones a la API
- **flutter_dotenv**: Manejo de variables de entorno
- **mobile_scanner**: Escaneo de códigos QR
- **get_storage**: Persistencia local de datos

## 🎨 Tema

- Color primario: `#039431` (Verde Trébol)
- Color secundario: `#BEDA51` (Verde Lima)
- Soporte para tema claro y oscuro

## 🔒 Seguridad

- El token de API se almacena en el archivo `.env` (no incluido en el repositorio)
- Asegúrate de agregar `.env` a tu `.gitignore`
- La información de la sucursal se almacena localmente de forma segura

## 🛠️ Comandos Útiles

```bash
# Limpiar build
flutter clean

# Actualizar dependencias
flutter pub upgrade

# Generar APK
flutter build apk --release

# Generar iOS
flutter build ios --release

# Analizar código
flutter analyze

# Formatear código
flutter format .
```

## 📝 Notas

- La aplicación utiliza **GetX** exclusivamente, sin StatefulWidgets
- Todos los estados son reactivos usando `.obs`
- La navegación y la inyección de dependencias están centralizadas
- La arquitectura es escalable para agregar autenticación con usuario/contraseña en el futuro
