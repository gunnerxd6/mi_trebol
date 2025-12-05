class Sucursal {
  final int id;
  final String sucursal;
  final String sucursalCodigo;
  final String empresa;

  Sucursal({
    required this.id,
    required this.sucursal,
    required this.sucursalCodigo,
    required this.empresa,
  });

  factory Sucursal.fromJson(Map<String, dynamic> json) {
    return Sucursal(
      id: json['id'] as int,
      sucursal: json['sucursal'] as String,
      sucursalCodigo: json['sucursalCodigo'] as String,
      empresa: json['empresa'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sucursal': sucursal,
      'sucursalCodigo': sucursalCodigo,
      'empresa': empresa,
    };
  }
}
