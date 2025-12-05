import 'package:get/get.dart';
import '../../data/models/producto_model.dart';

class ProductoDetalleController extends GetxController {
  late Producto producto;

  @override
  void onInit() {
    super.onInit();
    producto = Get.arguments as Producto;
  }

  void volver() {
    Get.back();
  }

  void consultarOtroProducto() {
    Get.back();
  }

  String formatearPrecio(double precio) {
    // Formato sin decimales para el precio de oferta
    return precio.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  String formatearPrecioNormal(double precio) {
    // Calcula un precio "normal" ligeramente superior (ejemplo: +25%)
    final precioNormal = precio * 1.25;
    return precioNormal.toStringAsFixed(0).replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }
}
