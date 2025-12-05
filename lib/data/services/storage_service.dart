import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import '../models/sucursal_model.dart';

class StorageService extends GetxService {
  late final GetStorage _storage;

  Future<StorageService> init() async {
    await GetStorage.init();
    _storage = GetStorage();
    return this;
  }

  // Guardar sucursal
  void saveSucursal(Sucursal sucursal) {
    _storage.write('sucursal', sucursal.toJson());
  }

  // Obtener sucursal guardada
  Sucursal? getSucursal() {
    final data = _storage.read('sucursal');
    if (data != null) {
      return Sucursal.fromJson(Map<String, dynamic>.from(data));
    }
    return null;
  }

  // Obtener código de sucursal
  String? getSucursalCodigo() {
    return getSucursal()?.sucursalCodigo;
  }

  // Verificar si hay sucursal guardada
  bool hasSucursal() {
    return _storage.hasData('sucursal');
  }

  // Limpiar sucursal (para cerrar sesión)
  void clearSucursal() {
    _storage.remove('sucursal');
  }

  // Limpiar todo
  void clearAll() {
    _storage.erase();
  }
}
