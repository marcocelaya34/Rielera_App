class Recomendados {
  final int idPlatillo;
  final int acompaniamiento;
  final int asociacion;

  Recomendados({
    required this.idPlatillo,
    required this.acompaniamiento,
    required this.asociacion,
  });

  factory Recomendados.fromJson(Map<String, dynamic> json) {
    return Recomendados(
      idPlatillo: json['Platillo target'],
      acompaniamiento: json['Acompanamiento'],
      asociacion: json['Asociacion'],
    );
  }
}
