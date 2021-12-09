class MasComprados {
  final String nombrePlatillo;
  final int idCategoria;
  final int pedidos;

  MasComprados({
    required this.nombrePlatillo,
    required this.idCategoria,
    required this.pedidos,
  });

  factory MasComprados.fromJson(Map<String, dynamic> json) {
    return MasComprados(
      nombrePlatillo: json['Nombre_platillo'],
      idCategoria: json['id_Categoria'],
      pedidos: json['pedidos'],
    );
  }
}
