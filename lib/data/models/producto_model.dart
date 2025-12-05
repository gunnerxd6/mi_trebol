class Producto {
  final int sucursalId;
  final String sucursalCodigo;
  final String sucursalNombre;
  final String nombreFantasia;
  final String razonSocial;
  final int productoId;
  final String productoNombre;
  final String productoCodigo;
  final double precioCaja;
  final String listaPrecio;

  Producto({
    required this.sucursalId,
    required this.sucursalCodigo,
    required this.sucursalNombre,
    required this.nombreFantasia,
    required this.razonSocial,
    required this.productoId,
    required this.productoNombre,
    required this.productoCodigo,
    required this.precioCaja,
    required this.listaPrecio,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      sucursalId: json['sucursalId'] as int,
      sucursalCodigo: json['sucursalCodigo'] as String,
      sucursalNombre: json['sucursalNombre'] as String,
      nombreFantasia: json['nombreFantasia'] as String,
      razonSocial: json['razonSocial'] as String,
      productoId: json['productoId'] as int,
      productoNombre: json['productoNombre'] as String,
      productoCodigo: json['productoCodigo'] as String,
      precioCaja: (json['precioCaja'] as num).toDouble(),
      listaPrecio: json['listaPrecio'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sucursalId': sucursalId,
      'sucursalCodigo': sucursalCodigo,
      'sucursalNombre': sucursalNombre,
      'nombreFantasia': nombreFantasia,
      'razonSocial': razonSocial,
      'productoId': productoId,
      'productoNombre': productoNombre,
      'productoCodigo': productoCodigo,
      'precioCaja': precioCaja,
      'listaPrecio': listaPrecio,
    };
  }
}
