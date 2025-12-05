import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'data/services/api_service.dart';
import 'data/services/storage_service.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Cargar variables de entorno
  await dotenv.load(fileName: ".env");
  
  // Inicializar servicios
  await initServices();
  
  runApp(const MyApp());
}

Future<void> initServices() async {
  // Inicializar StorageService
  await Get.putAsync(() => StorageService().init());
  
  // Inicializar ApiService
  await Get.putAsync(() => ApiService().init());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Light theme colors (user-provided): primary #039431, secondary #BEDA51
    final lightColorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF039431),
      primary: const Color(0xFF039431),
      secondary: const Color(0xFFBEDA51),
      brightness: Brightness.light,
    );

    // Dark theme: derive from light but with dark brightness; tweak if needed
    final darkColorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF039431),
      primary: const Color(0xFF039431),
      secondary: const Color(0xFFBEDA51),
      brightness: Brightness.dark,
    );

    // Determinar ruta inicial basada en si hay sucursal guardada
    final storageService = Get.find<StorageService>();
    final initialRoute = storageService.hasSucursal() 
        ? Routes.consultaPrecios 
        : Routes.login;

    return GetMaterialApp(
      title: 'Mi Trébol',
      theme: ThemeData(
        colorScheme: lightColorScheme,
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: lightColorScheme.primary,
          foregroundColor: lightColorScheme.onPrimary,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: lightColorScheme.secondary,
          foregroundColor: lightColorScheme.onSecondary,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: darkColorScheme,
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: darkColorScheme.primary,
          foregroundColor: darkColorScheme.onPrimary,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: darkColorScheme.secondary,
          foregroundColor: darkColorScheme.onSecondary,
        ),
      ),
      themeMode: ThemeMode.system,
      initialRoute: initialRoute,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
    );
  }
}
