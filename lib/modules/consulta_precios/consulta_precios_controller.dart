import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../data/services/api_service.dart';
import '../../data/services/storage_service.dart';
import '../../routes/app_routes.dart';

class ConsultaPreciosController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  final StorageService _storageService = Get.find<StorageService>();

  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final showScanner = false.obs;
  final sucursalNombre = ''.obs;

  late MobileScannerController scannerController;

  @override
  void onInit() {
    super.onInit();
    scannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
    );
    _loadSucursal();
  }

  @override
  void onClose() {
    scannerController.dispose();
    super.onClose();
  }

  void _loadSucursal() {
    final sucursal = _storageService.getSucursal();
    if (sucursal != null) {
      sucursalNombre.value = '${sucursal.sucursal} - ${sucursal.empresa}';
    }
  }

  void toggleScanner() {
    showScanner.value = !showScanner.value;
    errorMessage.value = '';
  }

  Future<void> onQRScanned(BarcodeCapture capture) async {
    final List<Barcode> barcodes = capture.barcodes;
    
    if (barcodes.isEmpty) return;
    
    final String? code = barcodes.first.rawValue;
    
    if (code == null || code.isEmpty) {
      errorMessage.value = 'Código QR inválido';
      return;
    }

    // Detener el escáner
    await scannerController.stop();
    
    await consultarProducto(code);
  }

  Future<void> consultarProducto(String codigoProducto) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final codigoSucursal = _storageService.getSucursalCodigo();
      
      if (codigoSucursal == null) {
        throw Exception('No hay sucursal seleccionada');
      }

      final producto = await _apiService.consultarProducto(
        codigoProducto,
        codigoSucursal,
      );

      // Navegar a detalle del producto
      Get.toNamed(Routes.productoDetalle, arguments: producto);
      
      // Cerrar el escáner
      showScanner.value = false;
      
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      
      Get.snackbar(
        'Producto no encontrado',
        errorMessage.value,
        backgroundColor: Colors.red.withValues(alpha: 0.8),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );

      // Reiniciar el escáner si hay error
      showScanner.value = false;
      await Future.delayed(const Duration(milliseconds: 500));
      await scannerController.start();
      
    } finally {
      isLoading.value = false;
    }
  }

  void cerrarSesion() {
    Get.dialog(
      AlertDialog(
        title: const Text('Cerrar Sesión'),
        content: const Text('¿Estás seguro que deseas cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              _storageService.clearSucursal();
              Get.offAllNamed(Routes.login);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Cerrar Sesión'),
          ),
        ],
      ),
    );
  }
}
