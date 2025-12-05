# Guía de Desarrollo Rápido - Mi Trébol

## 🚀 Inicio Rápido

### 1. Configuración Inicial

```bash
# Clonar el repositorio
git clone <url-repo>
cd mi_trebol

# Instalar dependencias
flutter pub get

# Configurar variables de entorno
cp .env.example .env
# Editar .env con tus credenciales
```

### 2. Ejecutar en modo desarrollo

```bash
# Ver dispositivos disponibles
flutter devices

# Ejecutar en dispositivo específico
flutter run -d <device-id>

# Hot reload: Presiona 'r' en la terminal
# Hot restart: Presiona 'R' en la terminal
```

---

## 📝 Agregar Nueva Funcionalidad

### Crear un Nuevo Módulo

1. **Crear estructura de carpetas**
```bash
mkdir -p lib/modules/nuevo_modulo
```

2. **Crear archivos del módulo**
```
lib/modules/nuevo_modulo/
├── nuevo_modulo_view.dart
├── nuevo_modulo_controller.dart
└── nuevo_modulo_binding.dart
```

3. **Implementar el View**
```dart
// nuevo_modulo_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'nuevo_modulo_controller.dart';

class NuevoModuloView extends GetView<NuevoModuloController> {
  const NuevoModuloView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nuevo Módulo')),
      body: Center(
        child: Obx(() => Text(controller.data.value)),
      ),
    );
  }
}
```

4. **Implementar el Controller**
```dart
// nuevo_modulo_controller.dart
import 'package:get/get.dart';

class NuevoModuloController extends GetxController {
  final data = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    // Lógica aquí
  }
}
```

5. **Implementar el Binding**
```dart
// nuevo_modulo_binding.dart
import 'package:get/get.dart';
import 'nuevo_modulo_controller.dart';

class NuevoModuloBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NuevoModuloController>(() => NuevoModuloController());
  }
}
```

6. **Registrar ruta**

En `lib/routes/app_routes.dart`:
```dart
abstract class Routes {
  static const login = '/login';
  static const consultaPrecios = '/consulta-precios';
  static const productoDetalle = '/producto-detalle';
  static const nuevoModulo = '/nuevo-modulo'; // Nueva ruta
}
```

En `lib/routes/app_pages.dart`:
```dart
import '../modules/nuevo_modulo/nuevo_modulo_view.dart';
import '../modules/nuevo_modulo/nuevo_modulo_binding.dart';

class AppPages {
  static final routes = [
    // ... rutas existentes
    GetPage(
      name: Routes.nuevoModulo,
      page: () => const NuevoModuloView(),
      binding: NuevoModuloBinding(),
    ),
  ];
}
```

---

## 🎨 Trabajar con Estados

### Estados Observables

```dart
// En el Controller
final count = 0.obs;
final text = ''.obs;
final isLoading = false.obs;
final user = Rxn<User>(); // Nullable

// Modificar valores
count.value = 10;
text.value = 'Nuevo texto';
isLoading.value = true;
```

### Usar en la Vista

```dart
// Simple
Obx(() => Text(controller.text.value))

// Condicional
Obx(() => controller.isLoading.value
  ? CircularProgressIndicator()
  : Text('Datos cargados')
)

// Lista
Obx(() => ListView.builder(
  itemCount: controller.items.length,
  itemBuilder: (context, index) => Text(controller.items[index]),
))
```

---

## 🔌 Agregar Nuevo Endpoint

### 1. Agregar método en ApiService

```dart
// En lib/data/services/api_service.dart

Future<MiModelo> consultarAlgo(String parametro) async {
  try {
    final response = await _dio.post(
      '/api/mi-endpoint',
      data: {'parametro': parametro},
    );

    if (response.statusCode == 200) {
      return MiModelo.fromJson(response.data);
    } else {
      throw Exception('Error: ${response.statusCode}');
    }
  } on DioException catch (e) {
    if (e.response != null) {
      throw Exception('Error del servidor: ${e.response?.data}');
    } else {
      throw Exception('Error de conexión: ${e.message}');
    }
  }
}
```

### 2. Usar en el Controller

```dart
final apiService = Get.find<ApiService>();

Future<void> consultarDatos() async {
  try {
    isLoading.value = true;
    final resultado = await apiService.consultarAlgo('parametro');
    // Procesar resultado
  } catch (e) {
    Get.snackbar('Error', e.toString());
  } finally {
    isLoading.value = false;
  }
}
```

---

## 💾 Trabajar con Storage

### Guardar datos

```dart
final storageService = Get.find<StorageService>();

// En StorageService, agregar métodos:
void saveData(String key, dynamic value) {
  _storage.write(key, value);
}

dynamic getData(String key) {
  return _storage.read(key);
}

bool hasData(String key) {
  return _storage.hasData(key);
}

void removeData(String key) {
  _storage.remove(key);
}
```

---

## 🧪 Testing

### Test de Controller

```dart
// test/controllers/login_controller_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mi_trebol/modules/login/login_controller.dart';

void main() {
  late LoginController controller;

  setUp(() {
    controller = LoginController();
  });

  test('Controller initializes correctly', () {
    expect(controller.isLoading.value, false);
    expect(controller.errorMessage.value, '');
  });

  test('Toggle scanner changes showScanner state', () {
    controller.toggleScanner();
    expect(controller.showScanner.value, true);
  });
}
```

---

## 🐛 Debug

### Imprimir en consola

```dart
print('Valor: $variable');
debugPrint('Debug info');
```

### GetX Logger

```dart
Get.log('Mensaje de log');
Get.printInfo(info: 'Info');
Get.printError(info: 'Error');
```

### Flutter DevTools

```bash
flutter run
# En otra terminal:
flutter pub global activate devtools
flutter pub global run devtools
```

---

## 📦 Comandos Útiles

### Desarrollo

```bash
# Hot reload
r

# Hot restart
R

# Ver logs
flutter logs

# Limpiar proyecto
flutter clean

# Actualizar dependencias
flutter pub upgrade

# Ver dependencias desactualizadas
flutter pub outdated
```

### Build

```bash
# Android APK (debug)
flutter build apk --debug

# Android APK (release)
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release
```

### Análisis

```bash
# Analizar código
flutter analyze

# Formatear código
flutter format lib/

# Ver tamaño del APK
flutter build apk --analyze-size
```

---

## 🔧 Configuración IDE

### VS Code Extensions Recomendadas

- Flutter
- Dart
- Awesome Flutter Snippets
- Flutter Widget Snippets
- Error Lens

### Snippets Útiles

**stless** - StatelessWidget
**GetView** - GetView con controller
**Obx** - Obx widget

---

## 🚨 Solución de Problemas Comunes

### "DioError: Connection timeout"
- Verificar conexión a internet
- Verificar que el servidor esté activo
- Verificar URL en `.env`

### "Late initialization error"
- Verificar que servicios estén inicializados en `main.dart`
- Usar `Get.find<Service>()` después de la inicialización

### "GetX Controller not found"
- Verificar que el Binding esté registrado en la ruta
- Usar `Get.lazyPut()` en lugar de `Get.put()` en bindings

### Cambios en .env no se reflejan
```bash
flutter clean
flutter pub get
flutter run
```

---

## 📚 Recursos

- [GetX Documentation](https://github.com/jonataslaw/getx)
- [Dio Documentation](https://pub.dev/packages/dio)
- [Flutter Documentation](https://docs.flutter.dev/)
- [Dart Documentation](https://dart.dev/guides)
