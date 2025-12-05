import 'package:get/get.dart';
import 'producto_detalle_controller.dart';

class ProductoDetalleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductoDetalleController>(() => ProductoDetalleController());
  }
}
