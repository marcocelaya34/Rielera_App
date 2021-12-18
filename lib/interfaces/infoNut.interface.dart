class InfoNutri {
  final String Cantidad;
  final String Nombre_etiqueta;
  final String Nombre_platillo;
  final String Video_RA;
  final int id_Platillo;

  InfoNutri({
    required this.Cantidad,
    required this.Nombre_etiqueta,
    required this.Nombre_platillo,
    required this.Video_RA,
    required this.id_Platillo,
  });

  factory InfoNutri.fromJson(Map<String, dynamic> json) {
    return InfoNutri(
      Cantidad: json['Cantidad'],
      Nombre_etiqueta: json['Nombre_etiqueta'],
      Nombre_platillo: json['Nombre_platillo'],
      Video_RA: json['Video_RA'],
      id_Platillo: json['id_Platillo'],
    );
  }
}
