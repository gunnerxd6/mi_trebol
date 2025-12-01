import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class CounterController extends GetxController {
  final count = 0.obs;
  void increment() => count.value++;
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

    return GetMaterialApp(
      title: 'Mi Trebol',
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
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final CounterController controller = Get.put(CounterController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contador con GetX'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Has presionado el botón esta cantidad de veces:'),
            const SizedBox(height: 8),
            Obx(() => Text(
                  '${controller.count.value}',
                  style: Theme.of(context).textTheme.headlineMedium,
                )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.increment,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
