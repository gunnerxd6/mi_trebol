import 'package:get/get.dart';
import 'consulta_precios_controller.dart';

class ConsultaPreciosBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ConsultaPreciosController>(() => ConsultaPreciosController());
  }
}
