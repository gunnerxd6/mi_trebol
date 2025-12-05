import 'package:get/get.dart';
import '../modules/login/login_view.dart';
import '../modules/login/login_binding.dart';
import '../modules/consulta_precios/consulta_precios_view.dart';
import '../modules/consulta_precios/consulta_precios_binding.dart';
import '../modules/producto_detalle/producto_detalle_view.dart';
import '../modules/producto_detalle/producto_detalle_binding.dart';
import 'app_routes.dart';

class AppPages {
  static const initial = Routes.login;

  static final routes = [
    GetPage(
      name: Routes.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.consultaPrecios,
      page: () => const ConsultaPreciosView(),
      binding: ConsultaPreciosBinding(),
    ),
    GetPage(
      name: Routes.productoDetalle,
      page: () => const ProductoDetalleView(),
      binding: ProductoDetalleBinding(),
    ),
  ];
}
