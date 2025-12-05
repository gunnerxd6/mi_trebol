import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../data/services/api_service.dart';
import '../../data/services/storage_service.dart';
import '../../routes/app_routes.dart';

class LoginController extends GetxController {
  final ApiService _apiService = Get.find<ApiService>();
  final StorageService _storageService = Get.find<StorageService>();

  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final showScanner = false.obs;

  late MobileScannerController scannerController;

  @override
  void onInit() {
    super.onInit();
    scannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
    );
  }

  @override
  void onClose() {
    scannerController.dispose();
    super.onClose();
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
    
    await consultarSucursal(code);
  }

  Future<void> consultarSucursal(String codigoSucursal) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final sucursal = await _apiService.consultarSucursal(codigoSucursal);
      
      // Guardar sucursal en storage
      _storageService.saveSucursal(sucursal);

      Get.snackbar(
        'Bienvenido',
        'Sucursal: ${sucursal.sucursal}',
        backgroundColor: Colors.green.withValues(alpha: 0.8),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 2),
      );

      // Navegar a consulta de precios
      Get.offAllNamed(Routes.consultaPrecios);
      
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      
      Get.snackbar(
        'Error',
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
}
