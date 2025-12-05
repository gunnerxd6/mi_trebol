import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart' hide Response;
import '../models/sucursal_model.dart';
import '../models/producto_model.dart';

class ApiService extends GetxService {
  late final Dio _dio;

  Future<ApiService> init() async {
    final apiUrl = dotenv.env['API_URL'] ?? '';
    final apiToken = dotenv.env['API_TOKEN'] ?? '';

    _dio = Dio(
      BaseOptions(
        baseUrl: apiUrl,
        headers: {
          'X-API-TOKEN': apiToken,
          'Content-Type': 'application/json',
        },
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );

    // Interceptor para logging (opcional)
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        error: true,
      ),
    );

    return this;
  }

  Future<Sucursal> consultarSucursal(String codigoSucursal) async {
    try {
      final response = await _dio.post(
        '/api-consulta-precios/consulta-sucursal',
        data: {
          'codigoSucursal': codigoSucursal,
        },
      );

      if (response.statusCode == 200) {
        return Sucursal.fromJson(response.data);
      } else {
        throw Exception('Error al consultar sucursal: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Error del servidor: ${e.response?.data}');
      } else {
        throw Exception('Error de conexión: ${e.message}');
      }
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }

  Future<Producto> consultarProducto(
    String codigoProducto,
    String codigoSucursal,
  ) async {
    try {
      final response = await _dio.post(
        '/api-consulta-precios/consulta-producto',
        data: {
          'codigoProducto': codigoProducto,
          'codigoSucursal': codigoSucursal,
        },
      );

      if (response.statusCode == 200) {
        return Producto.fromJson(response.data);
      } else {
        throw Exception('Error al consultar producto: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Error del servidor: ${e.response?.data}');
      } else {
        throw Exception('Error de conexión: ${e.message}');
      }
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }
}
