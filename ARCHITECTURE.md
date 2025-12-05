# Arquitectura del Proyecto - Mi Trébol

## 📐 Patrón de Arquitectura

El proyecto utiliza una **arquitectura limpia y escalable** basada en el patrón **MVC (Model-View-Controller)** implementado con **GetX**, siguiendo las mejores prácticas de Flutter.

## 🏗️ Estructura de Capas

```
lib/
├── data/                    # Capa de Datos
│   ├── models/             # Modelos de dominio
│   └── services/           # Servicios (API, Storage)
├── modules/                # Capa de Presentación
│   ├── login/             # Módulo de Login
│   ├── consulta_precios/  # Módulo de Consulta de Precios
│   └── producto_detalle/  # Módulo de Detalle de Producto
├── routes/                 # Configuración de Navegación
└── main.dart              # Punto de entrada
```

## 📦 Descripción de Capas

### 1. Capa de Datos (`data/`)

#### Models
- **`sucursal_model.dart`**: Modelo de datos para la información de la sucursal
  - Atributos: id, sucursal, sucursalCodigo, empresa
  - Métodos: `fromJson()`, `toJson()`

- **`producto_model.dart`**: Modelo de datos para la información del producto
  - Atributos: nombre, precio, precioOferta, tieneOferta
  - Métodos: `fromJson()`, `toJson()`

#### Services
- **`api_service.dart`**: Servicio centralizado para llamadas HTTP
  - Configuración de Dio con baseURL y headers
  - Métodos:
    - `consultarSucursal(codigoSucursal)`: POST a `/api-consulta-precios/consulta-sucursal`
    - `consultarProducto(codigoProducto, codigoSucursal)`: POST a `/api-consulta-precios/consulta-producto`
  - Manejo de errores y logging

- **`storage_service.dart`**: Servicio de persistencia local
  - Basado en GetStorage
  - Métodos:
    - `saveSucursal(sucursal)`: Guardar información de sucursal
    - `getSucursal()`: Obtener sucursal guardada
    - `getSucursalCodigo()`: Obtener código de sucursal
    - `hasSucursal()`: Verificar si hay sucursal guardada
    - `clearSucursal()`: Limpiar datos de sucursal
    - `clearAll()`: Limpiar todo el storage

### 2. Capa de Presentación (`modules/`)

Cada módulo sigue el patrón **View-Controller-Binding**:

#### Login Module
- **`login_view.dart`**: UI para escanear código QR de sucursal
  - Vista principal con instrucciones
  - Vista de escáner con overlay
  - Manejo de estados (loading, error)

- **`login_controller.dart`**: Lógica de negocio del login
  - Control del escáner QR
  - Llamada al API para validar sucursal
  - Persistencia de datos de sucursal
  - Navegación a consulta de precios

- **`login_binding.dart`**: Inyección de dependencias del módulo

#### Consulta Precios Module
- **`consulta_precios_view.dart`**: UI para escanear productos
  - Muestra información de sucursal actual
  - Botón para activar escáner
  - Vista de escáner con overlay
  - Opción de cerrar sesión

- **`consulta_precios_controller.dart`**: Lógica de consulta de productos
  - Control del escáner QR
  - Llamada al API para consultar producto
  - Navegación a detalle del producto
  - Gestión de cierre de sesión

- **`consulta_precios_binding.dart`**: Inyección de dependencias del módulo

#### Producto Detalle Module
- **`producto_detalle_view.dart`**: UI para mostrar detalles del producto
  - Nombre del producto
  - Precio normal o con oferta
  - Cálculo de ahorro (si aplica)
  - Botón para consultar otro producto

- **`producto_detalle_controller.dart`**: Lógica del detalle
  - Recibe datos del producto via argumentos
  - Navegación de regreso

- **`producto_detalle_binding.dart`**: Inyección de dependencias del módulo

### 3. Navegación (`routes/`)

- **`app_routes.dart`**: Definición de rutas nombradas
  - `login`: Ruta del login
  - `consultaPrecios`: Ruta de consulta de precios
  - `productoDetalle`: Ruta de detalle de producto

- **`app_pages.dart`**: Configuración de páginas GetX
  - Mapeo de rutas a vistas
  - Asociación de bindings
  - Ruta inicial dinámica

## 🔄 Flujo de Datos

```
Usuario → View → Controller → Service → API
                     ↓
                   Model
                     ↓
              Storage (opcional)
```

### Flujo de Login
1. Usuario abre la app
2. LoginView muestra botón para escanear
3. Usuario presiona botón → activa escáner
4. Usuario escanea QR → LoginController recibe código
5. LoginController → ApiService.consultarSucursal()
6. API retorna datos → se crea modelo Sucursal
7. StorageService guarda la sucursal
8. Navegación a ConsultaPreciosView

### Flujo de Consulta de Producto
1. Usuario en ConsultaPreciosView
2. Usuario presiona botón → activa escáner
3. Usuario escanea QR → ConsultaPreciosController recibe código
4. Controller obtiene código de sucursal del Storage
5. Controller → ApiService.consultarProducto()
6. API retorna datos → se crea modelo Producto
7. Navegación a ProductoDetalleView con producto como argumento

## 🎯 Principios Aplicados

### 1. Separation of Concerns (SoC)
- **Views**: Solo se encargan de la UI
- **Controllers**: Lógica de negocio y estados
- **Services**: Comunicación con APIs y almacenamiento
- **Models**: Estructura de datos

### 2. Dependency Injection
- Servicios registrados como singletons en `main.dart`
- Controllers inyectados via Bindings
- Acceso a servicios via `Get.find<Service>()`

### 3. Reactive Programming
- Todos los estados son observables (`.obs`)
- UI reacciona automáticamente a cambios (`Obx()`)
- Sin necesidad de `setState()`

### 4. Single Responsibility
- Cada clase tiene una única responsabilidad
- Servicios especializados (API, Storage)
- Controllers específicos por módulo

## 🔌 Gestión de Estado con GetX

### Estados Observables
```dart
final isLoading = false.obs;  // Estado de carga
final errorMessage = ''.obs;   // Mensajes de error
final showScanner = false.obs; // Control del escáner
```

### Acceso en la Vista
```dart
Obx(() => controller.isLoading.value
  ? CircularProgressIndicator()
  : ElevatedButton(...)
)
```

## 🚀 Escalabilidad

La arquitectura permite fácilmente:

1. **Agregar nuevos módulos**:
   - Crear carpeta en `modules/`
   - Crear View, Controller, Binding
   - Registrar ruta en `app_routes.dart` y `app_pages.dart`

2. **Agregar autenticación**:
   - Crear `auth_service.dart`
   - Agregar campos de login en `LoginView`
   - Implementar JWT en headers de Dio

3. **Agregar caché**:
   - Extender `StorageService` para cachear productos
   - Implementar estrategia de cache-first

4. **Testing**:
   - Services son fácilmente mockeables
   - Controllers pueden testearse de forma aislada
   - Views son puras y sin lógica

## 📝 Convenciones de Código

- Nombres de archivos: `snake_case.dart`
- Nombres de clases: `PascalCase`
- Nombres de variables/métodos: `camelCase`
- Constantes: `camelCase` (routes)
- Carpetas: `snake_case`
- Sin StatefulWidgets, solo GetView/StatelessWidget
- Controllers extienden GetxController
- Services extienden GetxService
